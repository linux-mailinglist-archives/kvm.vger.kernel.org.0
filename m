Return-Path: <kvm+bounces-3778-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 48358807B21
	for <lists+kvm@lfdr.de>; Wed,  6 Dec 2023 23:08:30 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id ECB821F218C3
	for <lists+kvm@lfdr.de>; Wed,  6 Dec 2023 22:08:29 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5C16A563B3;
	Wed,  6 Dec 2023 22:08:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="LP0ayxyb"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3CF04DE
	for <kvm@vger.kernel.org>; Wed,  6 Dec 2023 14:08:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1701900491;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=3cM3G3IxJYLM5tCOwlfSEThSnIq2Ia0o8pmJScU+oeA=;
	b=LP0ayxybCAMjGUkLBJUNs2htBzsetpzYMQ6kAeuKXcQ1DOky651j49kha21z8RksbePzAJ
	bp3yj0KJObKkI7m6YU0RALQP0u+229gchUauIFREiyStzy8ujZjmhq6ISGGVhkZg9+d4ph
	nmn6lE6ksgeEb4zFfOzAJmsNNedzksk=
Received: from mail-ej1-f69.google.com (mail-ej1-f69.google.com
 [209.85.218.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-538-OhDmJ-fpMAuIw-PrJJo-7A-1; Wed, 06 Dec 2023 17:08:09 -0500
X-MC-Unique: OhDmJ-fpMAuIw-PrJJo-7A-1
Received: by mail-ej1-f69.google.com with SMTP id a640c23a62f3a-a1db7b26269so14429466b.0
        for <kvm@vger.kernel.org>; Wed, 06 Dec 2023 14:08:09 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1701900489; x=1702505289;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=3cM3G3IxJYLM5tCOwlfSEThSnIq2Ia0o8pmJScU+oeA=;
        b=svblqye5M5eUvwa9PG+dF0kTBmNggthsbov0nPOd9uqbLz6+9F8Babd1eyHP1WopUK
         wFcAxWzHgR+ZqI/pYRDM7345/QyoJPi479eKvLzx1v4xhPRaeYew+7l8rYV4wgYWekWS
         PLpi3oC8Xe/8M9QvNJP4vLPYbvlZnm2AUMhi78/JbPabWNbrUZMmH+JzBjLbfZFCo+is
         TD7UqGeZimx25kL5aH+cf2te49p1d7q3vS2DMUQu9NAUpb16CB6qCDqzCEDaSnB5tiLs
         yxfU9ceokYEty0ScMXrOJX2lrnIMUAe3GGQ5qx6wFrb/mTqF8tkC5I6p/EANnAgCVmA+
         jMRQ==
X-Gm-Message-State: AOJu0YyT4qP3Jtyv6uH+oS6o8VXmbEAjOQBqzlawtjSDrdiQWTcsXFey
	QV5stSVjkXtsib2kpcw9J6wBYqIXfjKtmZ+TInhBUvfhZC3rcNcBhc56UERYhLgukxrD9YB6l9L
	CpstAtazrbLbT
X-Received: by 2002:a17:906:225a:b0:a01:9d8b:db17 with SMTP id 26-20020a170906225a00b00a019d8bdb17mr1089764ejr.15.1701900488765;
        Wed, 06 Dec 2023 14:08:08 -0800 (PST)
X-Google-Smtp-Source: AGHT+IELc1CseN/Lgd5NWinZpBx+NzuVrz10mseWrWKMVnwyTe6bCu+laowzD1kdbkuuvmu6nxMTFQ==
X-Received: by 2002:a17:906:225a:b0:a01:9d8b:db17 with SMTP id 26-20020a170906225a00b00a019d8bdb17mr1089759ejr.15.1701900488420;
        Wed, 06 Dec 2023 14:08:08 -0800 (PST)
Received: from redhat.com ([2.55.11.67])
        by smtp.gmail.com with ESMTPSA id d25-20020a170906371900b00a1d754b30a9sm462436ejc.86.2023.12.06.14.08.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 06 Dec 2023 14:08:07 -0800 (PST)
Date: Wed, 6 Dec 2023 17:08:02 -0500
From: "Michael S. Tsirkin" <mst@redhat.com>
To: Arseniy Krasnov <avkrasnov@salutedevices.com>
Cc: Stefan Hajnoczi <stefanha@redhat.com>,
	Stefano Garzarella <sgarzare@redhat.com>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
	Jason Wang <jasowang@redhat.com>,
	Bobby Eshleman <bobby.eshleman@bytedance.com>, kvm@vger.kernel.org,
	virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org, kernel@sberdevices.ru,
	oxffffaa@gmail.com
Subject: Re: [PATCH net-next v7 3/4] virtio/vsock: fix logic which reduces
 credit update messages
Message-ID: <20231206170640-mutt-send-email-mst@kernel.org>
References: <20231206211849.2707151-1-avkrasnov@salutedevices.com>
 <20231206211849.2707151-4-avkrasnov@salutedevices.com>
 <20231206165045-mutt-send-email-mst@kernel.org>
 <d9d1ec6a-dd9b-61d9-9211-52e9437cbb1f@salutedevices.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <d9d1ec6a-dd9b-61d9-9211-52e9437cbb1f@salutedevices.com>

On Thu, Dec 07, 2023 at 12:52:51AM +0300, Arseniy Krasnov wrote:
> 
> 
> On 07.12.2023 00:53, Michael S. Tsirkin wrote:
> > On Thu, Dec 07, 2023 at 12:18:48AM +0300, Arseniy Krasnov wrote:
> >> Add one more condition for sending credit update during dequeue from
> >> stream socket: when number of bytes in the rx queue is smaller than
> >> SO_RCVLOWAT value of the socket. This is actual for non-default value
> >> of SO_RCVLOWAT (e.g. not 1) - idea is to "kick" peer to continue data
> >> transmission, because we need at least SO_RCVLOWAT bytes in our rx
> >> queue to wake up user for reading data (in corner case it is also
> >> possible to stuck both tx and rx sides, this is why 'Fixes' is used).
> >> Also handle case when 'fwd_cnt' wraps, while 'last_fwd_cnt' is still
> >> not.
> >>
> >> Fixes: b89d882dc9fc ("vsock/virtio: reduce credit update messages")
> >> Signed-off-by: Arseniy Krasnov <avkrasnov@salutedevices.com>
> >> ---
> >>  Changelog:
> >>  v6 -> v7:
> >>   * Handle wrap of 'fwd_cnt'.
> >>   * Do to send credit update when 'fwd_cnt' == 'last_fwd_cnt'.
> >>
> >>  net/vmw_vsock/virtio_transport_common.c | 18 +++++++++++++++---
> >>  1 file changed, 15 insertions(+), 3 deletions(-)
> >>
> >> diff --git a/net/vmw_vsock/virtio_transport_common.c b/net/vmw_vsock/virtio_transport_common.c
> >> index e137d740804e..39f8660d825d 100644
> >> --- a/net/vmw_vsock/virtio_transport_common.c
> >> +++ b/net/vmw_vsock/virtio_transport_common.c
> >> @@ -558,6 +558,8 @@ virtio_transport_stream_do_dequeue(struct vsock_sock *vsk,
> >>  	struct virtio_vsock_sock *vvs = vsk->trans;
> >>  	size_t bytes, total = 0;
> >>  	struct sk_buff *skb;
> >> +	u32 fwd_cnt_delta;
> >> +	bool low_rx_bytes;
> >>  	int err = -EFAULT;
> >>  	u32 free_space;
> >>  
> >> @@ -601,7 +603,15 @@ virtio_transport_stream_do_dequeue(struct vsock_sock *vsk,
> >>  		}
> >>  	}
> >>  
> >> -	free_space = vvs->buf_alloc - (vvs->fwd_cnt - vvs->last_fwd_cnt);
> >> +	/* Handle wrap of 'fwd_cnt'. */
> >> +	if (vvs->fwd_cnt < vvs->last_fwd_cnt)
> >> +		fwd_cnt_delta = vvs->fwd_cnt + (U32_MAX - vvs->last_fwd_cnt);
> > 
> > Are you sure there's no off by one here? for example if fwd_cnt is 0
> > and last_fwd_cnt is 0xfffffffff then apparently delta is 0.
> 
> Seems yes, I need +1 here

And then you will get a nop, because assigning U32_MAX + 1 to u32
gives you 0. Adding () does nothing to change the result,
+ and - are commutative.


> > 
> > 
> >> +	else
> >> +		fwd_cnt_delta = vvs->fwd_cnt - vvs->last_fwd_cnt;
> > 
> > I actually don't see what is wrong with just
> > 	fwd_cnt_delta = vvs->fwd_cnt - vvs->last_fwd_cnt
> > 32 bit unsigned math will I think handle wrap around correctly.
> > 
> > And given buf_alloc is also u32 - I don't see where the bug is in
> > the original code.
> 
> I think problem is when fwd_cnt wraps, while last_fwd_cnt is not. In this
> case fwd_cnt_delta will be too big, so we won't send credit update which
> leads to stall for sender
> 
> Thanks, Arseniy

Care coming up with an example?


> > 
> > 
> >> +
> >> +	free_space = vvs->buf_alloc - fwd_cnt_delta;
> >> +	low_rx_bytes = (vvs->rx_bytes <
> >> +			sock_rcvlowat(sk_vsock(vsk), 0, INT_MAX));
> >>  
> >>  	spin_unlock_bh(&vvs->rx_lock);
> >>  
> >> @@ -611,9 +621,11 @@ virtio_transport_stream_do_dequeue(struct vsock_sock *vsk,
> >>  	 * too high causes extra messages. Too low causes transmitter
> >>  	 * stalls. As stalls are in theory more expensive than extra
> >>  	 * messages, we set the limit to a high value. TODO: experiment
> >> -	 * with different values.
> >> +	 * with different values. Also send credit update message when
> >> +	 * number of bytes in rx queue is not enough to wake up reader.
> >>  	 */
> >> -	if (free_space < VIRTIO_VSOCK_MAX_PKT_BUF_SIZE)
> >> +	if (fwd_cnt_delta &&
> >> +	    (free_space < VIRTIO_VSOCK_MAX_PKT_BUF_SIZE || low_rx_bytes))
> >>  		virtio_transport_send_credit_update(vsk);
> >>  
> >>  	return total;
> >> -- 
> >> 2.25.1
> > 


