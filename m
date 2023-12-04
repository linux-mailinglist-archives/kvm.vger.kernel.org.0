Return-Path: <kvm+bounces-3342-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 323AB8036BA
	for <lists+kvm@lfdr.de>; Mon,  4 Dec 2023 15:30:47 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 54C2E1C20A3C
	for <lists+kvm@lfdr.de>; Mon,  4 Dec 2023 14:30:46 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 35F9F28E1D;
	Mon,  4 Dec 2023 14:30:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="eoS1Dts6"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C75F92D61
	for <kvm@vger.kernel.org>; Mon,  4 Dec 2023 06:30:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1701700227;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=RSBmlOR1UqkHD0oYidhVbBfvIzTzf5U/uh3kWBx8ItM=;
	b=eoS1Dts6Aiu0GIvI9t0zuN7QJctxbvebd2gqcW9siqfd6ulu1GMqWOtXGJ+cd+oNi76EWs
	r6lBl1bH2X3B8jFQyTZL8NIYoFzSg2kpPyrONTCJ+tIo9BbUscFgRDboXD1pyH0gjb3l8R
	BZUNFQ6lMKclC1RanAkhivDbObEFaDg=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-321-3fPPmFfeO0W4JYJJ9xZ1Sg-1; Mon, 04 Dec 2023 09:30:23 -0500
X-MC-Unique: 3fPPmFfeO0W4JYJJ9xZ1Sg-1
Received: by mail-wm1-f70.google.com with SMTP id 5b1f17b1804b1-40a4c765d3bso25108725e9.0
        for <kvm@vger.kernel.org>; Mon, 04 Dec 2023 06:30:23 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1701700222; x=1702305022;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=RSBmlOR1UqkHD0oYidhVbBfvIzTzf5U/uh3kWBx8ItM=;
        b=AGAgi9wXhDfrXhRUbbMAaTCpJqwHT6Q5Pn1QNASoAuuSg1MYM3YaV/UIAa0O7/KH8M
         hgcNdgiZNwQwH9hPr584l9SFWGquiVxFhmuTMSpGUMQKMVfvnCtpMxd73FySdXOBuekA
         qvs4TeocnZ6nKLvrif4ved+zm+U8p888ft9Uhbws9JLyN1rTVo+cYcKixJ0b2xk2uFdy
         Y1HxA3lgW+wcZkg4P5ifinbEafCnEEkhjooDwvS2GZrVgUk981xLlFjaD5qJXF+Avdtx
         5DXgVmuhBpmR20u+CiE9XS7aktdRBi+1pt2GHIX3qtvZbbm2nCXUkfSf27iC1f9yVJbV
         WxGQ==
X-Gm-Message-State: AOJu0YzBrB5SvlqMZ0QJqVFHAU2mrM4EqPsmhWoLtD4o6YNgLogHBHTb
	nEB6Gp3wvGrIO/HvwsVHXhdZDLpxzoCCmXxd2lY5LUndWOKs4SSmR8c3B/WRIK+xxh3vdeg5CmL
	u42s38PEBjuQs
X-Received: by 2002:a05:600c:4711:b0:40b:5e26:237a with SMTP id v17-20020a05600c471100b0040b5e26237amr3023491wmo.43.1701700222509;
        Mon, 04 Dec 2023 06:30:22 -0800 (PST)
X-Google-Smtp-Source: AGHT+IGsObmpgovFZtPLsGHM5UifZVuJ4qnoaZ7VOE5NY2SN7kfGCeEjXNr5c5SpPhNfltQzb52PdA==
X-Received: by 2002:a05:600c:4711:b0:40b:5e26:237a with SMTP id v17-20020a05600c471100b0040b5e26237amr3023478wmo.43.1701700222099;
        Mon, 04 Dec 2023 06:30:22 -0800 (PST)
Received: from sgarzare-redhat (host-79-46-200-125.retail.telecomitalia.it. [79.46.200.125])
        by smtp.gmail.com with ESMTPSA id x18-20020adff0d2000000b003333b67f58csm6444882wro.48.2023.12.04.06.30.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 04 Dec 2023 06:30:21 -0800 (PST)
Date: Mon, 4 Dec 2023 15:30:16 +0100
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
Message-ID: <g7fcjjohedsc4dldrzzlmvegakim3rwarlkh3hgqqvm4qwyld3@h7cqwi7jqq6o>
References: <20231130084044-mutt-send-email-mst@kernel.org>
 <02de8982-ec4a-b3b2-e8e5-1bca28cfc01b@salutedevices.com>
 <20231130085445-mutt-send-email-mst@kernel.org>
 <pbkiwezwlf6dmogx7exur6tjrtcfzxyn7eqlehqxivqifbkojv@xlziiuzekon4>
 <20231130123815-mutt-send-email-mst@kernel.org>
 <smu77vmxw3ki36xhqnhtvujwswvkg5gkfwnt4vr5bnwljclseh@inbewbwkcqxs>
 <e58cf080-3611-0a19-c6e5-544d7101e975@salutedevices.com>
 <vqlspza4hzs6i5eajidxgeqd7wesv43ajpo42mljm4leuxfym4@j3h6ux2xlxbi>
 <214df55d-89e3-2c1d-250a-7428360b6b1b@salutedevices.com>
 <20231202152108-mutt-send-email-mst@kernel.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1; format=flowed
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20231202152108-mutt-send-email-mst@kernel.org>

On Sat, Dec 02, 2023 at 03:22:39PM -0500, Michael S. Tsirkin wrote:
>On Fri, Dec 01, 2023 at 01:40:41PM +0300, Arseniy Krasnov wrote:
>>
>>
>> On 01.12.2023 12:48, Stefano Garzarella wrote:
>> > On Fri, Dec 01, 2023 at 11:35:56AM +0300, Arseniy Krasnov wrote:
>> >>
>> >>
>> >> On 01.12.2023 11:27, Stefano Garzarella wrote:
>> >>> On Thu, Nov 30, 2023 at 12:40:43PM -0500, Michael S. Tsirkin wrote:
>> >>>> On Thu, Nov 30, 2023 at 03:11:19PM +0100, Stefano Garzarella wrote:
>> >>>>> On Thu, Nov 30, 2023 at 08:58:58AM -0500, Michael S. Tsirkin wrote:
>> >>>>> > On Thu, Nov 30, 2023 at 04:43:34PM +0300, Arseniy Krasnov wrote:
>> >>>>> > >
>> >>>>> > >
>> >>>>> > > On 30.11.2023 16:42, Michael S. Tsirkin wrote:
>> >>>>> > > > On Thu, Nov 30, 2023 at 04:08:39PM +0300, Arseniy Krasnov wrote:
>> >>>>> > > >> Send credit update message when SO_RCVLOWAT is updated and it is bigger
>> >>>>> > > >> than number of bytes in rx queue. It is needed, because 'poll()' will
>> >>>>> > > >> wait until number of bytes in rx queue will be not smaller than
>> >>>>> > > >> SO_RCVLOWAT, so kick sender to send more data. Otherwise mutual hungup
>> >>>>> > > >> for tx/rx is possible: sender waits for free space and receiver is
>> >>>>> > > >> waiting data in 'poll()'.
>> >>>>> > > >>
>> >>>>> > > >> Signed-off-by: Arseniy Krasnov <avkrasnov@salutedevices.com>
>> >>>>> > > >> ---
>> >>>>> > > >>  Changelog:
>> >>>>> > > >>  v1 -> v2:
>> >>>>> > > >>   * Update commit message by removing 'This patch adds XXX' manner.
>> >>>>> > > >>   * Do not initialize 'send_update' variable - set it directly during
>> >>>>> > > >>     first usage.
>> >>>>> > > >>  v3 -> v4:
>> >>>>> > > >>   * Fit comment in 'virtio_transport_notify_set_rcvlowat()' to 80 chars.
>> >>>>> > > >>  v4 -> v5:
>> >>>>> > > >>   * Do not change callbacks order in transport structures.
>> >>>>> > > >>
>> >>>>> > > >>  drivers/vhost/vsock.c                   |  1 +
>> >>>>> > > >>  include/linux/virtio_vsock.h            |  1 +
>> >>>>> > > >>  net/vmw_vsock/virtio_transport.c        |  1 +
>> >>>>> > > >>  net/vmw_vsock/virtio_transport_common.c | 27 +++++++++++++++++++++++++
>> >>>>> > > >>  net/vmw_vsock/vsock_loopback.c          |  1 +
>> >>>>> > > >>  5 files changed, 31 insertions(+)
>> >>>>> > > >>
>> >>>>> > > >> diff --git a/drivers/vhost/vsock.c b/drivers/vhost/vsock.c
>> >>>>> > > >> index f75731396b7e..4146f80db8ac 100644
>> >>>>> > > >> --- a/drivers/vhost/vsock.c
>> >>>>> > > >> +++ b/drivers/vhost/vsock.c
>> >>>>> > > >> @@ -451,6 +451,7 @@ static struct virtio_transport vhost_transport = {
>> >>>>> > > >>          .notify_buffer_size       = virtio_transport_notify_buffer_size,
>> >>>>> > > >>
>> >>>>> > > >>          .read_skb = virtio_transport_read_skb,
>> >>>>> > > >> +        .notify_set_rcvlowat      = virtio_transport_notify_set_rcvlowat
>> >>>>> > > >>      },
>> >>>>> > > >>
>> >>>>> > > >>      .send_pkt = vhost_transport_send_pkt,
>> >>>>> > > >> diff --git a/include/linux/virtio_vsock.h b/include/linux/virtio_vsock.h
>> >>>>> > > >> index ebb3ce63d64d..c82089dee0c8 100644
>> >>>>> > > >> --- a/include/linux/virtio_vsock.h
>> >>>>> > > >> +++ b/include/linux/virtio_vsock.h
>> >>>>> > > >> @@ -256,4 +256,5 @@ void virtio_transport_put_credit(struct virtio_vsock_sock *vvs, u32 credit);
>> >>>>> > > >>  void virtio_transport_deliver_tap_pkt(struct sk_buff *skb);
>> >>>>> > > >>  int virtio_transport_purge_skbs(void *vsk, struct sk_buff_head *list);
>> >>>>> > > >>  int virtio_transport_read_skb(struct vsock_sock *vsk, skb_read_actor_t read_actor);
>> >>>>> > > >> +int virtio_transport_notify_set_rcvlowat(struct vsock_sock *vsk, int val);
>> >>>>> > > >>  #endif /* _LINUX_VIRTIO_VSOCK_H */
>> >>>>> > > >> diff --git a/net/vmw_vsock/virtio_transport.c b/net/vmw_vsock/virtio_transport.c
>> >>>>> > > >> index af5bab1acee1..8007593a3a93 100644
>> >>>>> > > >> --- a/net/vmw_vsock/virtio_transport.c
>> >>>>> > > >> +++ b/net/vmw_vsock/virtio_transport.c
>> >>>>> > > >> @@ -539,6 +539,7 @@ static struct virtio_transport virtio_transport = {
>> >>>>> > > >>          .notify_buffer_size       = virtio_transport_notify_buffer_size,
>> >>>>> > > >>
>> >>>>> > > >>          .read_skb = virtio_transport_read_skb,
>> >>>>> > > >> +        .notify_set_rcvlowat      = virtio_transport_notify_set_rcvlowat
>> >>>>> > > >>      },
>> >>>>> > > >>
>> >>>>> > > >>      .send_pkt = virtio_transport_send_pkt,
>> >>>>> > > >> diff --git a/net/vmw_vsock/virtio_transport_common.c b/net/vmw_vsock/virtio_transport_common.c
>> >>>>> > > >> index f6dc896bf44c..1cb556ad4597 100644
>> >>>>> > > >> --- a/net/vmw_vsock/virtio_transport_common.c
>> >>>>> > > >> +++ b/net/vmw_vsock/virtio_transport_common.c
>> >>>>> > > >> @@ -1684,6 +1684,33 @@ int virtio_transport_read_skb(struct vsock_sock *vsk, skb_read_actor_t recv_acto
>> >>>>> > > >>  }
>> >>>>> > > >>  EXPORT_SYMBOL_GPL(virtio_transport_read_skb);
>> >>>>> > > >>
>> >>>>> > > >> +int virtio_transport_notify_set_rcvlowat(struct vsock_sock *vsk,
>> >>>>> > > >> int val)
>> >>>>> > > >> +{
>> >>>>> > > >> +    struct virtio_vsock_sock *vvs = vsk->trans;
>> >>>>> > > >> +    bool send_update;
>> >>>>> > > >> +
>> >>>>> > > >> +    spin_lock_bh(&vvs->rx_lock);
>> >>>>> > > >> +
>> >>>>> > > >> +    /* If number of available bytes is less than new SO_RCVLOWAT value,
>> >>>>> > > >> +     * kick sender to send more data, because sender may sleep in
>> >>>>> > > >> its
>> >>>>> > > >> +     * 'send()' syscall waiting for enough space at our side.
>> >>>>> > > >> +     */
>> >>>>> > > >> +    send_update = vvs->rx_bytes < val;
>> >>>>> > > >> +
>> >>>>> > > >> +    spin_unlock_bh(&vvs->rx_lock);
>> >>>>> > > >> +
>> >>>>> > > >> +    if (send_update) {
>> >>>>> > > >> +        int err;
>> >>>>> > > >> +
>> >>>>> > > >> +        err = virtio_transport_send_credit_update(vsk);
>> >>>>> > > >> +        if (err < 0)
>> >>>>> > > >> +            return err;
>> >>>>> > > >> +    }
>> >>>>> > > >> +
>> >>>>> > > >> +    return 0;
>> >>>>> > > >> +}
>> >>>>> > > >
>> >>>>> > > >
>> >>>>> > > > I find it strange that this will send a credit update
>> >>>>> > > > even if nothing changed since this was called previously.
>> >>>>> > > > I'm not sure whether this is a problem protocol-wise,
>> >>>>> > > > but it certainly was not envisioned when the protocol was
>> >>>>> > > > built. WDYT?
>> >>>>> > >
>> >>>>> > > >From virtio spec I found:
>> >>>>> > >
>> >>>>> > > It is also valid to send a VIRTIO_VSOCK_OP_CREDIT_UPDATE packet without previously receiving a
>> >>>>> > > VIRTIO_VSOCK_OP_CREDIT_REQUEST packet. This allows communicating updates any time a change
>> >>>>> > > in buffer space occurs.
>> >>>>> > > So I guess there is no limitations to send such type of packet, e.g. it is not
>> >>>>> > > required to be a reply for some another packet. Please, correct me if im wrong.
>> >>>>> > >
>> >>>>> > > Thanks, Arseniy
>> >>>>> >
>> >>>>> >
>> >>>>> > Absolutely. My point was different - with this patch it is possible
>> >>>>> > that you are not adding any credits at all since the previous
>> >>>>> > VIRTIO_VSOCK_OP_CREDIT_UPDATE.
>> >>>>>
>> >>>>> I think the problem we're solving here is that since as an optimization we
>> >>>>> avoid sending the update for every byte we consume, but we put a threshold,
>> >>>>> then we make sure we update the peer.
>> >>>>>
>> >>>>> A credit update contains a snapshot and sending it the same as the previous
>> >>>>> one should not create any problem.
>> >>>>
>> >>>> Well it consumes a buffer on the other side.
>> >>>
>> >>> Sure, but we are already speculating by not updating the other side when
>> >>> we consume bytes before a certain threshold. This already avoids to
>> >>> consume many buffers.
>> >>>
>> >>> Here we're only sending it once, when the user sets RCVLOWAT, so
>> >>> basically I expect it won't affect performance.
>> >>
>> >> Moreover I think in practice setting RCVLOWAT is rare case, while this patch
>> >> fixes real problem I guess
>> >>
>> >>
>> >>>
>> >>>>
>> >>>>> My doubt now is that we only do this when we set RCVLOWAT , should we also
>> >>>>> do something when we consume bytes to avoid the optimization we have?
>> >>>>>
>> >>>>> Stefano
>> >>>>
>> >>>> Isn't this why we have credit request?
>> >>>
>> >>> Yep, but in practice we never use it. It would also consume 2 buffers,
>> >>> one at the transmitter and one at the receiver.
>> >>>
>> >>> However I agree that maybe we should start using it before we decide not
>> >>> to send any more data.
>> >>>
>> >>> To be compatible with older devices, though, I think for now we also
>> >>> need to send a credit update when the bytes in the receive queue are
>> >>> less than RCVLOWAT, as Arseniy proposed in the other series.
>> >>
>> >> Looks like (in theory of course), that credit request is considered to be
>> >> paired with credit update. While current usage of credit update is something
>> >> like ACK packet in TCP, e.g. telling peer that we are ready to receive more
>> >> data.
>> >
>> > I don't honestly know what the original author's choice was, but I think we reduce latency this way.
>>
>> Ah I see,ok
>>
>> >
>> > Effectively though, if we never send any credit update when we consume bytes and always leave it up to the transmitter to ask for an update before transmission, we save even more buffer than the optimization we have, but maybe the latency would grow a lot.
>>
>> I think:
>> 1) Way where sender must request current credit status before sending packet requires rework of kernel part, and for me this approach is not
>>    so clear than current simple implementation (send RW, reply with CREDIT_UPDATE if needed).
>> 2) In theory yes, we need one more buffer for such CREDIT_UPDATE, but in practice I don't know how big is this trouble.
>>
>> Thanks, Arseniy
>
>I just worry that yes, normal users will only call RCVLOWAT once,
>but a bad user might call it many times causing a ton of
>credit updates. This is why I feel it's prudent to at least
>keep track of last credit update and if nothing changed
>do not resend it on a repeated RCVLOWAT.

Okay, now I get you!

Yeah, absolutely, we already have `last_fwd_cnt` in `struct 
virtio_vsock_sock` to do that check.

Thanks,
Stefano


