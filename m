Return-Path: <kvm+bounces-3071-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 201A9800581
	for <lists+kvm@lfdr.de>; Fri,  1 Dec 2023 09:28:07 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 1177F1C20F3F
	for <lists+kvm@lfdr.de>; Fri,  1 Dec 2023 08:28:06 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DA5341B269;
	Fri,  1 Dec 2023 08:28:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="bEGxHlyd"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BF2CC1717
	for <kvm@vger.kernel.org>; Fri,  1 Dec 2023 00:27:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1701419274;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=TXlehmG2X8bR464lQdsPhRNIsLgCTWHUZUf/l+hBZHs=;
	b=bEGxHlydsGQvpoP0dKv+bg+i8q+l8Ikcv3Fmsqic9+e6O0FS36Hah486uz2h0Xstl69q5D
	MPyDc9dMCdioMvYhr8dueQB9mXlFtfTW39O1t29/Ay6ErSyEUExSjfsdZEZvEcW0foIvFg
	0EILgPpftF83hqEMn+QwI4gaWfyomTs=
Received: from mail-ed1-f72.google.com (mail-ed1-f72.google.com
 [209.85.208.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-182-YNpK9rOaNDKC18G1awQBHw-1; Fri, 01 Dec 2023 03:27:53 -0500
X-MC-Unique: YNpK9rOaNDKC18G1awQBHw-1
Received: by mail-ed1-f72.google.com with SMTP id 4fb4d7f45d1cf-54c0a4d9624so1286309a12.1
        for <kvm@vger.kernel.org>; Fri, 01 Dec 2023 00:27:53 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1701419272; x=1702024072;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=TXlehmG2X8bR464lQdsPhRNIsLgCTWHUZUf/l+hBZHs=;
        b=wwUWjmhI6winH5pcwt4vojL3zY7WiQlhplrJcmRgp3H2M0ZaEBaQEpKomgQQmJmAdO
         sgvwWGScoVrvOlmD7fUn9vOZEAlU7Tkr7WQ3yQ+7KN8ANaVnHVcdnxSioa1CjjcNNZDV
         zAqAamHZ6qkx1ddl6LbXePHHjuFsM6TIRoIGw7BFEcK3bA+Fct4tFlghUWNvq7odrWsc
         mI0T6VtwVwsHrVGfmk/21N1bbTf913Za8n36/eUobS7o01pPlvg9aXn6OhebmXEqFUgl
         jg0LWKNdHZhSZNDU2oItR+LQFSiAInpD++KXTyk3sKZLQPnIcHvl8Q7a7tkw7ndklCSx
         TYZw==
X-Gm-Message-State: AOJu0YycAFnN0dGzeyoDkHciha6b7XFGjJuAvPIKvmcCiIHwzad8FHqt
	bcGzhBCmK6osjQdiu1NCT+4cOP91+/qzBizR2Fk57Q0O03iFAbJeANB7w9S9U+KEkc9Theq8XBd
	5jT9zyGQWGwOXIVXzkMtg
X-Received: by 2002:a50:8e42:0:b0:54a:e87c:4951 with SMTP id 2-20020a508e42000000b0054ae87c4951mr622240edx.41.1701419272338;
        Fri, 01 Dec 2023 00:27:52 -0800 (PST)
X-Google-Smtp-Source: AGHT+IFhBuopBPFWwv/i2+HgEvjFGevJis2FETkAvTKcndNFDF37w40NnwfqHCDStPcJZ86f7bgYvQ==
X-Received: by 2002:a50:8e42:0:b0:54a:e87c:4951 with SMTP id 2-20020a508e42000000b0054ae87c4951mr622226edx.41.1701419271994;
        Fri, 01 Dec 2023 00:27:51 -0800 (PST)
Received: from sgarzare-redhat (host-79-46-200-199.retail.telecomitalia.it. [79.46.200.199])
        by smtp.gmail.com with ESMTPSA id bt15-20020a0564020a4f00b0054c63ebfa15sm125308edb.83.2023.12.01.00.27.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 01 Dec 2023 00:27:51 -0800 (PST)
Date: Fri, 1 Dec 2023 09:27:47 +0100
From: Stefano Garzarella <sgarzare@redhat.com>
To: "Michael S. Tsirkin" <mst@redhat.com>
Cc: Arseniy Krasnov <avkrasnov@salutedevices.com>, 
	Stefan Hajnoczi <stefanha@redhat.com>, "David S. Miller" <davem@davemloft.net>, 
	Eric Dumazet <edumazet@google.com>, Jakub Kicinski <kuba@kernel.org>, 
	Paolo Abeni <pabeni@redhat.com>, Jason Wang <jasowang@redhat.com>, 
	Bobby Eshleman <bobby.eshleman@bytedance.com>, kvm@vger.kernel.org, virtualization@lists.linux-foundation.org, 
	netdev@vger.kernel.org, linux-kernel@vger.kernel.org, kernel@sberdevices.ru, 
	oxffffaa@gmail.com
Subject: Re: [PATCH net-next v5 2/3] virtio/vsock: send credit update during
 setting SO_RCVLOWAT
Message-ID: <smu77vmxw3ki36xhqnhtvujwswvkg5gkfwnt4vr5bnwljclseh@inbewbwkcqxs>
References: <20231130130840.253733-1-avkrasnov@salutedevices.com>
 <20231130130840.253733-3-avkrasnov@salutedevices.com>
 <20231130084044-mutt-send-email-mst@kernel.org>
 <02de8982-ec4a-b3b2-e8e5-1bca28cfc01b@salutedevices.com>
 <20231130085445-mutt-send-email-mst@kernel.org>
 <pbkiwezwlf6dmogx7exur6tjrtcfzxyn7eqlehqxivqifbkojv@xlziiuzekon4>
 <20231130123815-mutt-send-email-mst@kernel.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20231130123815-mutt-send-email-mst@kernel.org>

On Thu, Nov 30, 2023 at 12:40:43PM -0500, Michael S. Tsirkin wrote:
>On Thu, Nov 30, 2023 at 03:11:19PM +0100, Stefano Garzarella wrote:
>> On Thu, Nov 30, 2023 at 08:58:58AM -0500, Michael S. Tsirkin wrote:
>> > On Thu, Nov 30, 2023 at 04:43:34PM +0300, Arseniy Krasnov wrote:
>> > >
>> > >
>> > > On 30.11.2023 16:42, Michael S. Tsirkin wrote:
>> > > > On Thu, Nov 30, 2023 at 04:08:39PM +0300, Arseniy Krasnov wrote:
>> > > >> Send credit update message when SO_RCVLOWAT is updated and it is bigger
>> > > >> than number of bytes in rx queue. It is needed, because 'poll()' will
>> > > >> wait until number of bytes in rx queue will be not smaller than
>> > > >> SO_RCVLOWAT, so kick sender to send more data. Otherwise mutual hungup
>> > > >> for tx/rx is possible: sender waits for free space and receiver is
>> > > >> waiting data in 'poll()'.
>> > > >>
>> > > >> Signed-off-by: Arseniy Krasnov <avkrasnov@salutedevices.com>
>> > > >> ---
>> > > >>  Changelog:
>> > > >>  v1 -> v2:
>> > > >>   * Update commit message by removing 'This patch adds XXX' manner.
>> > > >>   * Do not initialize 'send_update' variable - set it directly during
>> > > >>     first usage.
>> > > >>  v3 -> v4:
>> > > >>   * Fit comment in 'virtio_transport_notify_set_rcvlowat()' to 80 chars.
>> > > >>  v4 -> v5:
>> > > >>   * Do not change callbacks order in transport structures.
>> > > >>
>> > > >>  drivers/vhost/vsock.c                   |  1 +
>> > > >>  include/linux/virtio_vsock.h            |  1 +
>> > > >>  net/vmw_vsock/virtio_transport.c        |  1 +
>> > > >>  net/vmw_vsock/virtio_transport_common.c | 27 +++++++++++++++++++++++++
>> > > >>  net/vmw_vsock/vsock_loopback.c          |  1 +
>> > > >>  5 files changed, 31 insertions(+)
>> > > >>
>> > > >> diff --git a/drivers/vhost/vsock.c b/drivers/vhost/vsock.c
>> > > >> index f75731396b7e..4146f80db8ac 100644
>> > > >> --- a/drivers/vhost/vsock.c
>> > > >> +++ b/drivers/vhost/vsock.c
>> > > >> @@ -451,6 +451,7 @@ static struct virtio_transport vhost_transport = {
>> > > >>  		.notify_buffer_size       = virtio_transport_notify_buffer_size,
>> > > >>
>> > > >>  		.read_skb = virtio_transport_read_skb,
>> > > >> +		.notify_set_rcvlowat      = virtio_transport_notify_set_rcvlowat
>> > > >>  	},
>> > > >>
>> > > >>  	.send_pkt = vhost_transport_send_pkt,
>> > > >> diff --git a/include/linux/virtio_vsock.h b/include/linux/virtio_vsock.h
>> > > >> index ebb3ce63d64d..c82089dee0c8 100644
>> > > >> --- a/include/linux/virtio_vsock.h
>> > > >> +++ b/include/linux/virtio_vsock.h
>> > > >> @@ -256,4 +256,5 @@ void virtio_transport_put_credit(struct virtio_vsock_sock *vvs, u32 credit);
>> > > >>  void virtio_transport_deliver_tap_pkt(struct sk_buff *skb);
>> > > >>  int virtio_transport_purge_skbs(void *vsk, struct sk_buff_head *list);
>> > > >>  int virtio_transport_read_skb(struct vsock_sock *vsk, skb_read_actor_t read_actor);
>> > > >> +int virtio_transport_notify_set_rcvlowat(struct vsock_sock *vsk, int val);
>> > > >>  #endif /* _LINUX_VIRTIO_VSOCK_H */
>> > > >> diff --git a/net/vmw_vsock/virtio_transport.c b/net/vmw_vsock/virtio_transport.c
>> > > >> index af5bab1acee1..8007593a3a93 100644
>> > > >> --- a/net/vmw_vsock/virtio_transport.c
>> > > >> +++ b/net/vmw_vsock/virtio_transport.c
>> > > >> @@ -539,6 +539,7 @@ static struct virtio_transport virtio_transport = {
>> > > >>  		.notify_buffer_size       = virtio_transport_notify_buffer_size,
>> > > >>
>> > > >>  		.read_skb = virtio_transport_read_skb,
>> > > >> +		.notify_set_rcvlowat      = virtio_transport_notify_set_rcvlowat
>> > > >>  	},
>> > > >>
>> > > >>  	.send_pkt = virtio_transport_send_pkt,
>> > > >> diff --git a/net/vmw_vsock/virtio_transport_common.c b/net/vmw_vsock/virtio_transport_common.c
>> > > >> index f6dc896bf44c..1cb556ad4597 100644
>> > > >> --- a/net/vmw_vsock/virtio_transport_common.c
>> > > >> +++ b/net/vmw_vsock/virtio_transport_common.c
>> > > >> @@ -1684,6 +1684,33 @@ int virtio_transport_read_skb(struct vsock_sock *vsk, skb_read_actor_t recv_acto
>> > > >>  }
>> > > >>  EXPORT_SYMBOL_GPL(virtio_transport_read_skb);
>> > > >>
>> > > >> +int virtio_transport_notify_set_rcvlowat(struct vsock_sock *vsk,
>> > > >> int val)
>> > > >> +{
>> > > >> +	struct virtio_vsock_sock *vvs = vsk->trans;
>> > > >> +	bool send_update;
>> > > >> +
>> > > >> +	spin_lock_bh(&vvs->rx_lock);
>> > > >> +
>> > > >> +	/* If number of available bytes is less than new SO_RCVLOWAT value,
>> > > >> +	 * kick sender to send more data, because sender may sleep in
>> > > >> its
>> > > >> +	 * 'send()' syscall waiting for enough space at our side.
>> > > >> +	 */
>> > > >> +	send_update = vvs->rx_bytes < val;
>> > > >> +
>> > > >> +	spin_unlock_bh(&vvs->rx_lock);
>> > > >> +
>> > > >> +	if (send_update) {
>> > > >> +		int err;
>> > > >> +
>> > > >> +		err = virtio_transport_send_credit_update(vsk);
>> > > >> +		if (err < 0)
>> > > >> +			return err;
>> > > >> +	}
>> > > >> +
>> > > >> +	return 0;
>> > > >> +}
>> > > >
>> > > >
>> > > > I find it strange that this will send a credit update
>> > > > even if nothing changed since this was called previously.
>> > > > I'm not sure whether this is a problem protocol-wise,
>> > > > but it certainly was not envisioned when the protocol was
>> > > > built. WDYT?
>> > >
>> > > >From virtio spec I found:
>> > >
>> > > It is also valid to send a VIRTIO_VSOCK_OP_CREDIT_UPDATE packet without previously receiving a
>> > > VIRTIO_VSOCK_OP_CREDIT_REQUEST packet. This allows communicating updates any time a change
>> > > in buffer space occurs.
>> > > So I guess there is no limitations to send such type of packet, e.g. it is not
>> > > required to be a reply for some another packet. Please, correct me if im wrong.
>> > >
>> > > Thanks, Arseniy
>> >
>> >
>> > Absolutely. My point was different - with this patch it is possible
>> > that you are not adding any credits at all since the previous
>> > VIRTIO_VSOCK_OP_CREDIT_UPDATE.
>>
>> I think the problem we're solving here is that since as an optimization we
>> avoid sending the update for every byte we consume, but we put a threshold,
>> then we make sure we update the peer.
>>
>> A credit update contains a snapshot and sending it the same as the previous
>> one should not create any problem.
>
>Well it consumes a buffer on the other side.

Sure, but we are already speculating by not updating the other side when
we consume bytes before a certain threshold. This already avoids to
consume many buffers.

Here we're only sending it once, when the user sets RCVLOWAT, so
basically I expect it won't affect performance.

>
>> My doubt now is that we only do this when we set RCVLOWAT , should we 
>> also
>> do something when we consume bytes to avoid the optimization we have?
>>
>> Stefano
>
>Isn't this why we have credit request?

Yep, but in practice we never use it. It would also consume 2 buffers,
one at the transmitter and one at the receiver.

However I agree that maybe we should start using it before we decide not
to send any more data.

To be compatible with older devices, though, I think for now we also
need to send a credit update when the bytes in the receive queue are
less than RCVLOWAT, as Arseniy proposed in the other series.

Thanks,
Stefano


