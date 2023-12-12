Return-Path: <kvm+bounces-4209-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 597AF80F1FD
	for <lists+kvm@lfdr.de>; Tue, 12 Dec 2023 17:11:46 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 7C4511C20DA0
	for <lists+kvm@lfdr.de>; Tue, 12 Dec 2023 16:11:45 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 17BB477F26;
	Tue, 12 Dec 2023 16:11:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="aok3d51H"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E2CFD10F
	for <kvm@vger.kernel.org>; Tue, 12 Dec 2023 08:11:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1702397482;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=gDJ4BJvrh413d67atQh4JmcBdn9fiHCIFP3pSXKUEOs=;
	b=aok3d51Hgnyi+IImkwUue9qKWQrbtwRRIRrzdobGkEjB6q9MgiLr+apqHj4oZAPqiblVZZ
	y0/6gR+hPYc8upeUQTl0sbUI2WiZ+8HT7Qzzid4lI+VagKnf/q7QJXWIdJP+MPFoxKmdM8
	g/2BI5I7iEJ6WXlkNTwXwdoVCvZEJCk=
Received: from mail-ej1-f72.google.com (mail-ej1-f72.google.com
 [209.85.218.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-395-ooh512utMYe166S8V1j09w-1; Tue, 12 Dec 2023 11:11:19 -0500
X-MC-Unique: ooh512utMYe166S8V1j09w-1
Received: by mail-ej1-f72.google.com with SMTP id a640c23a62f3a-a018014e8e5so331652066b.2
        for <kvm@vger.kernel.org>; Tue, 12 Dec 2023 08:11:19 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1702397478; x=1703002278;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=gDJ4BJvrh413d67atQh4JmcBdn9fiHCIFP3pSXKUEOs=;
        b=WE0wqmkHojhhioAAISSPrW3tpDabTBJQuV2dq5mczFsqPTCTNGq2YgBKFQlG3Toryk
         diyoLUuNPoV3CpGPIcLTHhfhy78v17eKal4TZsISN3gyxE1AXJ07wwOV2nOLXTGMJGgy
         E3Noq8u7TuMMXKi6pSCXP1u/fLEhqcCt0pjtL13mwAxEEMUF1sPQJVUWQ1tdaA2z712x
         j+8O1drO4Nf5LUEx97PeAxRJ7FUV9MfCr8bKM9Q4Y02YrZqcDceRiV8RlU8ByKA2M78T
         lPoSPJ09dCOqpKW5YTVoktoJURcbisM0tX7ZvE5Y7CbMERZyK/HzFkQK9zxRdGxFPbSs
         K+Og==
X-Gm-Message-State: AOJu0Yx6djjX2QO/FyLzrVfpnzgPrSAQAOUXIfBVTPlKCh11IJwDLC0d
	bIFLe7erzb/GWVqOmnoBY5IdH+jx9FrR2rcFm67004YiBfhecZq3kU+A7MHOEfwlhVKEQfPblHU
	Z7SPSShkI5jOq
X-Received: by 2002:a17:907:948f:b0:a04:4b57:8f27 with SMTP id dm15-20020a170907948f00b00a044b578f27mr3729857ejc.60.1702397478646;
        Tue, 12 Dec 2023 08:11:18 -0800 (PST)
X-Google-Smtp-Source: AGHT+IFCmdg/6lDFekXlVbpsIxgUSkkmTZGgKOXN7kgsWywVrdXY9qocK2cPhMevqdguDpeicUzVpg==
X-Received: by 2002:a17:907:948f:b0:a04:4b57:8f27 with SMTP id dm15-20020a170907948f00b00a044b578f27mr3729847ejc.60.1702397478298;
        Tue, 12 Dec 2023 08:11:18 -0800 (PST)
Received: from redhat.com ([2.52.23.105])
        by smtp.gmail.com with ESMTPSA id ld4-20020a1709079c0400b009a19701e7b5sm6464141ejc.96.2023.12.12.08.11.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 12 Dec 2023 08:11:17 -0800 (PST)
Date: Tue, 12 Dec 2023 11:11:13 -0500
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
Subject: Re: [PATCH net-next v8 3/4] virtio/vsock: fix logic which reduces
 credit update messages
Message-ID: <20231212110953-mutt-send-email-mst@kernel.org>
References: <20231211211658.2904268-1-avkrasnov@salutedevices.com>
 <20231211211658.2904268-4-avkrasnov@salutedevices.com>
 <20231212105322-mutt-send-email-mst@kernel.org>
 <f8b52c41-9a33-def4-6ca1-fc29ed257446@salutedevices.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <f8b52c41-9a33-def4-6ca1-fc29ed257446@salutedevices.com>

On Tue, Dec 12, 2023 at 06:50:39PM +0300, Arseniy Krasnov wrote:
> 
> 
> On 12.12.2023 18:54, Michael S. Tsirkin wrote:
> > On Tue, Dec 12, 2023 at 12:16:57AM +0300, Arseniy Krasnov wrote:
> >> Add one more condition for sending credit update during dequeue from
> >> stream socket: when number of bytes in the rx queue is smaller than
> >> SO_RCVLOWAT value of the socket. This is actual for non-default value
> >> of SO_RCVLOWAT (e.g. not 1) - idea is to "kick" peer to continue data
> >> transmission, because we need at least SO_RCVLOWAT bytes in our rx
> >> queue to wake up user for reading data (in corner case it is also
> >> possible to stuck both tx and rx sides, this is why 'Fixes' is used).
> > 
> > I don't get what does "to stuck both tx and rx sides" mean.
> 
> I meant situation when tx waits for the free space, while rx doesn't send
> credit update, just waiting for more data. Sorry for my English :)
> 
> > Besides being agrammatical, is there a way to do this without
> > playing with SO_RCVLOWAT?
> 
> No, this may happen only with non-default SO_RCVLOWAT values (e.g. != 1)
> 
> Thanks, Arseniy 

I am split on whether we need the Fixes tag. I guess if the other side
is vhost with SO_RCVLOWAT then it might be stuck and it might apply
without SO_RCVLOWAT on the local kernel?


> > 
> >>
> >> Fixes: b89d882dc9fc ("vsock/virtio: reduce credit update messages")
> >> Signed-off-by: Arseniy Krasnov <avkrasnov@salutedevices.com>
> >> ---
> >>  Changelog:
> >>  v6 -> v7:
> >>   * Handle wrap of 'fwd_cnt'.
> >>   * Do to send credit update when 'fwd_cnt' == 'last_fwd_cnt'.
> >>  v7 -> v8:
> >>   * Remove unneeded/wrong handling of wrap for 'fwd_cnt'.
> >>
> >>  net/vmw_vsock/virtio_transport_common.c | 13 ++++++++++---
> >>  1 file changed, 10 insertions(+), 3 deletions(-)
> >>
> >> diff --git a/net/vmw_vsock/virtio_transport_common.c b/net/vmw_vsock/virtio_transport_common.c
> >> index e137d740804e..8572f94bba88 100644
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
> >> @@ -601,7 +603,10 @@ virtio_transport_stream_do_dequeue(struct vsock_sock *vsk,
> >>  		}
> >>  	}
> >>  
> >> -	free_space = vvs->buf_alloc - (vvs->fwd_cnt - vvs->last_fwd_cnt);
> >> +	fwd_cnt_delta = vvs->fwd_cnt - vvs->last_fwd_cnt;
> >> +	free_space = vvs->buf_alloc - fwd_cnt_delta;
> >> +	low_rx_bytes = (vvs->rx_bytes <
> >> +			sock_rcvlowat(sk_vsock(vsk), 0, INT_MAX));
> >>  
> >>  	spin_unlock_bh(&vvs->rx_lock);
> >>  
> >> @@ -611,9 +616,11 @@ virtio_transport_stream_do_dequeue(struct vsock_sock *vsk,
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


