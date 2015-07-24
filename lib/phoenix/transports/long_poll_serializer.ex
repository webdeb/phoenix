defmodule Phoenix.Transports.LongPollSerializer do
  @moduledoc false

  @behaviour Phoenix.Transports.Serializer

  alias Phoenix.Socket.Reply
  alias Phoenix.Socket.Message
  alias Phoenix.Socket.Broadcast

  @doc """
  Normalizes a `Phoenix.Socket.Message` struct.

  Encoding is handled downstream in the LongPoll controller.
  """
  def encode!(%Reply{} = reply) do
    %Message{
      topic: reply.topic,
      event: "phx_reply",
      ref: reply.ref,
      payload: %{status: reply.status, response: reply.payload}
    }
  end
  def encode!(%Broadcast{} = msg) do
    %Message{
      topic: msg.topic,
      event: msg.event,
      payload: msg.payload
    }
  end
  def encode!(%Message{} = msg), do: msg

  @doc """
  Decodes JSON String into `Phoenix.Socket.Message` struct.
  """
  def decode!(message, :text) do
    message
    |> Poison.decode!()
    |> Phoenix.Socket.Message.from_map!()
  end
end
