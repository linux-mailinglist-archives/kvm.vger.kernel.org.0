Return-Path: <kvm+bounces-64576-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ams.mirrors.kernel.org (ams.mirrors.kernel.org [213.196.21.55])
	by mail.lfdr.de (Postfix) with ESMTPS id E1CA6C878D7
	for <lists+kvm@lfdr.de>; Wed, 26 Nov 2025 01:08:14 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ams.mirrors.kernel.org (Postfix) with ESMTPS id AA4D53532A4
	for <lists+kvm@lfdr.de>; Wed, 26 Nov 2025 00:08:13 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 13F7CF507;
	Wed, 26 Nov 2025 00:08:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="YtR9UdVu";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="DYZJuYUs"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 597124C6C
	for <kvm@vger.kernel.org>; Wed, 26 Nov 2025 00:08:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764115682; cv=none; b=MoTFN/UVtRg5pClNaPWNzoGj6xaL9G5KALcAgcqjt36Yjhs2wkHPzoiIe2AbweKXCf7Uq4em2YL4j93Aj+54DpKDkqF2FOvIEscKJiQNhyC68+cAOTlUxcYgzngSotljs2bJCBhSt1YkSdc3IgzgONPLSO296BFGmlQGXf9msUI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764115682; c=relaxed/simple;
	bh=NggLvYCsCYitR7PzyKQAuMZ9PVYDu0g9Y6ARtGEOrhs=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=NRNld9sSZSSZ2cohMBjuca13Ens08XW0Fs1AhOc+42d7WY2VWXkk7LG8T9GLFSSENz0V5Gasmp/Y3V8uey//iBrj2jML7Ewm8s/iIkC7OZ63UIUHogs8VnpfrAuQnTRX+dUlrohcV7KHa9zCs4308fCFT998pwtQVW0PejYUp7s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=YtR9UdVu; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=DYZJuYUs; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1764115679;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=6LfR8L6b81mySpISuZ/q1L5WKsAidakJ+F4/kEKwC3w=;
	b=YtR9UdVu7lMkYK1JaJayQbd6VCax/QJp2UMVKkKAZlVJE54a2CEbp2BRPMDVWQV91YcNUK
	O2/lkfLCLqBUs3p5lLrLZ2hohmzYkbO58eid1/HsmvyXaRARUG3Dr8sS4nH1Kc3jEajhmh
	up6Avip4XELfSx//HebApgyxrqPA4f4=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-488-oA6y3l7SOJGxpuhXod736A-1; Tue, 25 Nov 2025 19:07:58 -0500
X-MC-Unique: oA6y3l7SOJGxpuhXod736A-1
X-Mimecast-MFC-AGG-ID: oA6y3l7SOJGxpuhXod736A_1764115677
Received: by mail-wm1-f69.google.com with SMTP id 5b1f17b1804b1-47106a388cfso36999155e9.0
        for <kvm@vger.kernel.org>; Tue, 25 Nov 2025 16:07:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1764115677; x=1764720477; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=6LfR8L6b81mySpISuZ/q1L5WKsAidakJ+F4/kEKwC3w=;
        b=DYZJuYUsc2TqESLOoKCUTi5MvMtx4qRc8K+KYGFrw8e46AIk7QyWghuJd83u/6/rLM
         V+SL9rsoDpNb1kNCpTtRdvmQJQRMM75gcgUJIOG8D9P/Hj+TPnQblsSUoTOQrblERFi5
         RiqT79OblWHuOMbWFY4gt2l0qtWQRr8Q0Xxrj1V4M6zdqBxCDKduKrxPVCLA0XzZnk9Q
         8robYqm92Mhkr8Gr8HcxgGXdTCQkiZMZ0BMvzJZ+m1baKbV++eN0/xacqlA/0gzWe5gg
         FHt/PWdhn0bms94U8OsHRGdqgUEKJh6XjBPIrQSeapvPJgSl8s42eA8k4mcTbmmkWa31
         rnnQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764115677; x=1764720477;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=6LfR8L6b81mySpISuZ/q1L5WKsAidakJ+F4/kEKwC3w=;
        b=KA51ECBtcS5MyGLxjncqNWEsYO3FWlF4rzCQ7tOdjtNzMxevJXh1pONLlySvYneNmT
         QKrOsKsXerFNSNGaYZalfcDxAEKv6HlI/+KyPiCUcw/UZ5w4lp+hnlkx/NuYKR8qtrmL
         zjVLJ3KpPuBatWP7VDz++Jf1aSUYSTmLQ/hHLMhFQEdvY0OrmE1UBqC/dmlk5XV78noQ
         XAgXrteCtmupLIFhRBxtyiMLIyP9a1pc1deAYwK2xHCFZOWgj9Vbg4/+PpW+ZEymz3lY
         3bs0K6Diw0kuVbIB8mBlXNcWopToEmQW2GPjns4HOvqkcXJUgOOsQ3ipQ5CQF28ElgAx
         DRjQ==
X-Forwarded-Encrypted: i=1; AJvYcCVhKRUYUS1FbT7wfDJFQBo6Lzbrje91UPxr/EmyqB3ZwG4hXgTSgreRb1LTmwSSIGtZ5kQ=@vger.kernel.org
X-Gm-Message-State: AOJu0YwyNgncp1owY4TIfNcIEFglaNWW1bUo5UDFavQc4G6jmgSkLBVd
	HfTy+rfZXgkL9sdfLWHb/NwrnmxVBls2xjWPTIGrSIHl4ranZJW9ytfvTCiTLq751Hl6T6Vao+6
	5o2VBGfDa06KBfv6RhEZ2AnfDMt1Ybk6+rRWrHU1hmRsdylTZ219x4sA6o0C/Rw==
X-Gm-Gg: ASbGncvWUmjFZtKzIfLX3BXeVxZwMqVioFdZQqs/pwBt2+mMSsxZhg1RyIgZXoSOCmV
	funJogFNrSEhcBWO6LP1wEPtJXCJqceEI5exexvoHtQjplPVnVUlNkLTF0XyJjHBoMbR+w+0rW/
	sV6lD679dHWmyYvByX/juKsJihasdj3gSIg65VbesyTTgOIGx04VROspDo5S9+r2JEu3nWp5tl2
	GsA+o1cq0AW3ZvkB5Dlh1WLshlgo1h5vCeEY7T3C6pc7Ri308x657rOTxrGlYj7UxUzs9fgvnKy
	S1Clb62nGsy+2DVGRG+3ezoiSOzmjg7SOfE0tH5BCnLXeTGH3T2CmnDD6LXUpplMW+fiBJyhBpf
	8lqCNgDG2sD7UCiTjhreZYnFgi0rlcA==
X-Received: by 2002:a05:600c:474e:b0:477:7523:da8c with SMTP id 5b1f17b1804b1-477c111d3f8mr203494535e9.15.1764115676893;
        Tue, 25 Nov 2025 16:07:56 -0800 (PST)
X-Google-Smtp-Source: AGHT+IGB3URk6xMwxmshnNVOt6ZVX8qLY09EPucXDJK8VamBZ7pUujQcHsySCZNWix7NvoN/emo4DQ==
X-Received: by 2002:a05:600c:474e:b0:477:7523:da8c with SMTP id 5b1f17b1804b1-477c111d3f8mr203494365e9.15.1764115676418;
        Tue, 25 Nov 2025 16:07:56 -0800 (PST)
Received: from redhat.com (IGLD-80-230-39-63.inter.net.il. [80.230.39.63])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-42cb7fb919bsm36922863f8f.34.2025.11.25.16.07.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 25 Nov 2025 16:07:55 -0800 (PST)
Date: Tue, 25 Nov 2025 19:07:53 -0500
From: "Michael S. Tsirkin" <mst@redhat.com>
To: liming.wu@jaguarmicro.com
Cc: Jason Wang <jasowang@redhat.com>,
	Xuan Zhuo <xuanzhuo@linux.alibaba.com>,
	Eugenio =?iso-8859-1?Q?P=E9rez?= <eperezma@redhat.com>,
	kvm@vger.kernel.org, virtualization@lists.linux-foundation.org,
	netdev@vger.kernel.org, angus.chen@jaguarmicro.com
Subject: Re: [PATCH v2] virtio_net: enhance wake/stop tx queue statistics
 accounting
Message-ID: <20251125190743-mutt-send-email-mst@kernel.org>
References: <20251120015320.1418-1-liming.wu@jaguarmicro.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251120015320.1418-1-liming.wu@jaguarmicro.com>

On Thu, Nov 20, 2025 at 09:53:20AM +0800, liming.wu@jaguarmicro.com wrote:
> From: Liming Wu <liming.wu@jaguarmicro.com>
> 
> This patch refines and strengthens the statistics collection of TX queue
> wake/stop events introduced by commit c39add9b2423 ("virtio_net: Add TX
> stopped and wake counters").
> 
> Previously, the driver only recorded partial wake/stop statistics
> for TX queues. Some wake events triggered by 'skb_xmit_done()' or resume
> operations were not counted, which made the per-queue metrics incomplete.
> 
> Signed-off-by: Liming Wu <liming.wu@jaguarmicro.com>

Acked-by: Michael S. Tsirkin <mst@redhat.com>

> ---
>  drivers/net/virtio_net.c | 44 ++++++++++++++++++++++++----------------
>  1 file changed, 26 insertions(+), 18 deletions(-)
> 
> diff --git a/drivers/net/virtio_net.c b/drivers/net/virtio_net.c
> index 8e8a179aaa49..b714b190db2a 100644
> --- a/drivers/net/virtio_net.c
> +++ b/drivers/net/virtio_net.c
> @@ -775,10 +775,26 @@ static bool virtqueue_napi_complete(struct napi_struct *napi,
>  	return false;
>  }
>  
> +static void virtnet_tx_wake_queue(struct virtnet_info *vi,
> +				struct send_queue *sq)
> +{
> +	unsigned int index = vq2txq(sq->vq);
> +	struct netdev_queue *txq = netdev_get_tx_queue(vi->dev, index);
> +
> +	if (netif_tx_queue_stopped(txq)) {
> +		u64_stats_update_begin(&sq->stats.syncp);
> +		u64_stats_inc(&sq->stats.wake);
> +		u64_stats_update_end(&sq->stats.syncp);
> +		netif_tx_wake_queue(txq);
> +	}
> +}
> +
>  static void skb_xmit_done(struct virtqueue *vq)
>  {
>  	struct virtnet_info *vi = vq->vdev->priv;
> -	struct napi_struct *napi = &vi->sq[vq2txq(vq)].napi;
> +	unsigned int index = vq2txq(vq);
> +	struct send_queue *sq = &vi->sq[index];
> +	struct napi_struct *napi = &sq->napi;
>  
>  	/* Suppress further interrupts. */
>  	virtqueue_disable_cb(vq);
> @@ -786,8 +802,7 @@ static void skb_xmit_done(struct virtqueue *vq)
>  	if (napi->weight)
>  		virtqueue_napi_schedule(napi, vq);
>  	else
> -		/* We were probably waiting for more output buffers. */
> -		netif_wake_subqueue(vi->dev, vq2txq(vq));
> +		virtnet_tx_wake_queue(vi, sq);
>  }
>  
>  #define MRG_CTX_HEADER_SHIFT 22
> @@ -3068,13 +3083,8 @@ static void virtnet_poll_cleantx(struct receive_queue *rq, int budget)
>  			free_old_xmit(sq, txq, !!budget);
>  		} while (unlikely(!virtqueue_enable_cb_delayed(sq->vq)));
>  
> -		if (sq->vq->num_free >= MAX_SKB_FRAGS + 2 &&
> -		    netif_tx_queue_stopped(txq)) {
> -			u64_stats_update_begin(&sq->stats.syncp);
> -			u64_stats_inc(&sq->stats.wake);
> -			u64_stats_update_end(&sq->stats.syncp);
> -			netif_tx_wake_queue(txq);
> -		}
> +		if (sq->vq->num_free >= MAX_SKB_FRAGS + 2)
> +			virtnet_tx_wake_queue(vi, sq);
>  
>  		__netif_tx_unlock(txq);
>  	}
> @@ -3264,13 +3274,8 @@ static int virtnet_poll_tx(struct napi_struct *napi, int budget)
>  	else
>  		free_old_xmit(sq, txq, !!budget);
>  
> -	if (sq->vq->num_free >= MAX_SKB_FRAGS + 2 &&
> -	    netif_tx_queue_stopped(txq)) {
> -		u64_stats_update_begin(&sq->stats.syncp);
> -		u64_stats_inc(&sq->stats.wake);
> -		u64_stats_update_end(&sq->stats.syncp);
> -		netif_tx_wake_queue(txq);
> -	}
> +	if (sq->vq->num_free >= MAX_SKB_FRAGS + 2)
> +		virtnet_tx_wake_queue(vi, sq);
>  
>  	if (xsk_done >= budget) {
>  		__netif_tx_unlock(txq);
> @@ -3521,6 +3526,9 @@ static void virtnet_tx_pause(struct virtnet_info *vi, struct send_queue *sq)
>  
>  	/* Prevent the upper layer from trying to send packets. */
>  	netif_stop_subqueue(vi->dev, qindex);
> +	u64_stats_update_begin(&sq->stats.syncp);
> +	u64_stats_inc(&sq->stats.stop);
> +	u64_stats_update_end(&sq->stats.syncp);
>  
>  	__netif_tx_unlock_bh(txq);
>  }
> @@ -3537,7 +3545,7 @@ static void virtnet_tx_resume(struct virtnet_info *vi, struct send_queue *sq)
>  
>  	__netif_tx_lock_bh(txq);
>  	sq->reset = false;
> -	netif_tx_wake_queue(txq);
> +	virtnet_tx_wake_queue(vi, sq);
>  	__netif_tx_unlock_bh(txq);
>  
>  	if (running)
> -- 
> 2.34.1


