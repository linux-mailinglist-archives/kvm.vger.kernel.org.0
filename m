Return-Path: <kvm+bounces-57587-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 8F9C2B58179
	for <lists+kvm@lfdr.de>; Mon, 15 Sep 2025 18:03:54 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id AAF27487216
	for <lists+kvm@lfdr.de>; Mon, 15 Sep 2025 16:03:23 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1B4DF23D7CE;
	Mon, 15 Sep 2025 16:03:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="F2jM0e+/"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7259C225761
	for <kvm@vger.kernel.org>; Mon, 15 Sep 2025 16:03:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757952197; cv=none; b=MEh8a8fdXWHpu3D0vws0SzJZ1QED+OUbufRM+O0sQ7438pJ5fVlrV+NqH5R4F8EmxT5VzTEa1iiKjFzHpVopFvmqKG8RkFK+T2WpQoA6y9OxHbcbtTTKxwmAc5IAf9fwXErFWpS2qJJNWUrcSBlILv55/uZJTqI6xnXdeRsX1e4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757952197; c=relaxed/simple;
	bh=UgpAiUSkfqsIiMi/5vuPzG4RqiLKzyDrVtzPJiZs6b0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=mTy66yCBCxJcKqRBIH7koUjzr82l8Y9HOQ814kdlgRpzCYfRXxKIshNovRzSFrp2bOyt16cXT1UJKtl/AgHRdc3+uIMMyFA6jplkfgcA3/d/Jb3f3o36+2sr/A9s4DW9TSPJFB1wMCMFlCTqIdBL6GbfGrH3Z9S8JKGJDmTgXmY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=F2jM0e+/; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1757952194;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=mxYYDZD7WvA8pBIh8RZ+XYWpfwg8m7Jck2wpptSqpfw=;
	b=F2jM0e+/Q22FqjhSptTRCvclXEKs3R+tu8gMcgG0XLnvjvBQqDH3xk+yWn2t+I2iqk0imL
	XY+pFchv1lVfOrkXqg6CMypX6mEamg1/mNJbG3IdToW+IinrsE8meTXi/KT6jQ7pVj+khJ
	kRBM2xIrMVaEc+yLcuRkBCGCRqkKKew=
Received: from mail-ed1-f72.google.com (mail-ed1-f72.google.com
 [209.85.208.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-251-e4us6OvsMva9LnotqNhNwg-1; Mon, 15 Sep 2025 12:03:13 -0400
X-MC-Unique: e4us6OvsMva9LnotqNhNwg-1
X-Mimecast-MFC-AGG-ID: e4us6OvsMva9LnotqNhNwg_1757952192
Received: by mail-ed1-f72.google.com with SMTP id 4fb4d7f45d1cf-62ef8d95301so1910456a12.1
        for <kvm@vger.kernel.org>; Mon, 15 Sep 2025 09:03:12 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757952192; x=1758556992;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=mxYYDZD7WvA8pBIh8RZ+XYWpfwg8m7Jck2wpptSqpfw=;
        b=k2nAREeOnrXGEIlpUeJRLplAxfCGrAEDAVsycgFQVBIP4vyUW+7gCl8kPcYCsJpB5b
         QPIPiTLmvkpdeV2qr/Ki/ktVrOFF6eXH/byLiSsTUOpw7076wfmvgoUz6yBdE7MgI1oK
         YoJYbK+MPei76PF5auvJm8WffyG7VmjAX23Cwkgj0svcyQPxUAgWe0fLMmLN4N/bLBaz
         GOQA1X1Rb3joA0N0/5mjQeS9oQnKdUjaUlygtj2TUYz1bTl7yQp2FlRfNPElET4WFiie
         KoNvaUv1NGlgumn6Mf8bhLaVRcrqsEEEvejyc4JIVsVAcrgp8/wUiegGaEiO6gYje2GA
         8oFQ==
X-Forwarded-Encrypted: i=1; AJvYcCXZkcPTS6eaEyKqiSAQtswwJ+AGxdS2l+/BkB5+3hvyUnmBuTexj/LmrNBRaAM133baGWQ=@vger.kernel.org
X-Gm-Message-State: AOJu0YwYLfsQU0xFL6fJLl0EVwnApfJiMgRJKvcgAxzG3d9NpaH3x9jx
	z8kAEGwmlxQxjLVnltZpySIksIA4FK2qkmTCjdIb3Ch/Mpdw9ABLdhK1M/DRDglyeCodBErEHI7
	iL8v5YuQCy5qGMZedWfWPA6mVr5jebS4DulevL69hLXoNMqhZeZ/P8Q==
X-Gm-Gg: ASbGnctpc+7dvE0moyNRY/I5C/uBJzw4K5fepUev0a8qg0hdleNXXdHQJrDXaBn1csB
	7N4IyklNN9grd0FVCZv0TOFvLLLylgNdGoisoz074lTtqbAgaFAh7QnXrFnQusfT9NpgFyE0ysm
	KgRyXWn6gFx+zIN0BIPGZKE91+5ALgMrytU0/JUyLxnDvUGcdC60BxyWDrdGeyDbEqmX07QMQbN
	uSYbFS+rTH2VNCuEyhDaXczRJ+R5hOKqTHdt9eKVOnp+cBE7DF0xjKvkrXH+7U9DK5/3FNytqq6
	6Iy3qJQtgIZpe0mCDn2W+2tImazS
X-Received: by 2002:a05:6402:5c9:b0:62f:5cd8:9b2e with SMTP id 4fb4d7f45d1cf-62f5cd8a072mr216482a12.29.1757952191718;
        Mon, 15 Sep 2025 09:03:11 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IFjGn2Z0BOy+sfljpNHO+I5IXHBbdbcb8SYTOdauYndHQ59yMvvIQnAzpSL9eW6X/im0GKszQ==
X-Received: by 2002:a05:6402:5c9:b0:62f:5cd8:9b2e with SMTP id 4fb4d7f45d1cf-62f5cd8a072mr216441a12.29.1757952191084;
        Mon, 15 Sep 2025 09:03:11 -0700 (PDT)
Received: from redhat.com ([31.187.78.47])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-62f454f4288sm1899363a12.5.2025.09.15.09.03.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 15 Sep 2025 09:03:10 -0700 (PDT)
Date: Mon, 15 Sep 2025 12:03:07 -0400
From: "Michael S. Tsirkin" <mst@redhat.com>
To: Jason Wang <jasowang@redhat.com>
Cc: eperezma@redhat.com, jonah.palmer@oracle.com, kuba@kernel.org,
	jon@nutanix.com, kvm@vger.kernel.org,
	virtualization@lists.linux.dev, netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH net 2/2] vhost-net: correctly flush batched packet before
 enabling notification
Message-ID: <20250915120210-mutt-send-email-mst@kernel.org>
References: <20250912082658.2262-1-jasowang@redhat.com>
 <20250912082658.2262-2-jasowang@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250912082658.2262-2-jasowang@redhat.com>

On Fri, Sep 12, 2025 at 04:26:58PM +0800, Jason Wang wrote:
> Commit 8c2e6b26ffe2 ("vhost/net: Defer TX queue re-enable until after
> sendmsg") tries to defer the notification enabling by moving the logic
> out of the loop after the vhost_tx_batch() when nothing new is
> spotted. This will bring side effects as the new logic would be reused
> for several other error conditions.
> 
> One example is the IOTLB: when there's an IOTLB miss, get_tx_bufs()
> might return -EAGAIN and exit the loop and see there's still available
> buffers, so it will queue the tx work again until userspace feed the
> IOTLB entry correctly. This will slowdown the tx processing and may
> trigger the TX watchdog in the guest.
> 
> Fixing this by stick the notificaiton enabling logic inside the loop
> when nothing new is spotted and flush the batched before.
> 
> Reported-by: Jon Kohler <jon@nutanix.com>
> Cc: stable@vger.kernel.org
> Fixes: 8c2e6b26ffe2 ("vhost/net: Defer TX queue re-enable until after sendmsg")
> Signed-off-by: Jason Wang <jasowang@redhat.com>
> ---
>  drivers/vhost/net.c | 33 +++++++++++++--------------------
>  1 file changed, 13 insertions(+), 20 deletions(-)
> 
> diff --git a/drivers/vhost/net.c b/drivers/vhost/net.c
> index 16e39f3ab956..3611b7537932 100644
> --- a/drivers/vhost/net.c
> +++ b/drivers/vhost/net.c
> @@ -765,11 +765,11 @@ static void handle_tx_copy(struct vhost_net *net, struct socket *sock)
>  	int err;
>  	int sent_pkts = 0;
>  	bool sock_can_batch = (sock->sk->sk_sndbuf == INT_MAX);
> -	bool busyloop_intr;
>  	bool in_order = vhost_has_feature(vq, VIRTIO_F_IN_ORDER);
>  
>  	do {
> -		busyloop_intr = false;
> +		bool busyloop_intr = false;
> +
>  		if (nvq->done_idx == VHOST_NET_BATCH)
>  			vhost_tx_batch(net, nvq, sock, &msg);
>  
> @@ -780,10 +780,18 @@ static void handle_tx_copy(struct vhost_net *net, struct socket *sock)
>  			break;
>  		/* Nothing new?  Wait for eventfd to tell us they refilled. */
>  		if (head == vq->num) {
> -			/* Kicks are disabled at this point, break loop and
> -			 * process any remaining batched packets. Queue will
> -			 * be re-enabled afterwards.
> +			/* Flush batched packets before enabling
> +			 * virqtueue notification to reduce
> +			 * unnecssary virtqueue kicks.
>  			 */
> +			vhost_tx_batch(net, nvq, sock, &msg);

So why don't we do this in the "else" branch"? If we are busy polling
then we are not enabling kicks, so is there a reason to flush?


> +			if (unlikely(busyloop_intr)) {
> +				vhost_poll_queue(&vq->poll);
> +			} else if (unlikely(vhost_enable_notify(&net->dev,
> +								vq))) {
> +				vhost_disable_notify(&net->dev, vq);
> +				continue;
> +			}
>  			break;
>  		}
>  
> @@ -839,22 +847,7 @@ static void handle_tx_copy(struct vhost_net *net, struct socket *sock)
>  		++nvq->done_idx;
>  	} while (likely(!vhost_exceeds_weight(vq, ++sent_pkts, total_len)));
>  
> -	/* Kicks are still disabled, dispatch any remaining batched msgs. */
>  	vhost_tx_batch(net, nvq, sock, &msg);
> -
> -	if (unlikely(busyloop_intr))
> -		/* If interrupted while doing busy polling, requeue the
> -		 * handler to be fair handle_rx as well as other tasks
> -		 * waiting on cpu.
> -		 */
> -		vhost_poll_queue(&vq->poll);
> -	else
> -		/* All of our work has been completed; however, before
> -		 * leaving the TX handler, do one last check for work,
> -		 * and requeue handler if necessary. If there is no work,
> -		 * queue will be reenabled.
> -		 */
> -		vhost_net_busy_poll_try_queue(net, vq);
>  }
>  
>  static void handle_tx_zerocopy(struct vhost_net *net, struct socket *sock)
> -- 
> 2.34.1


