Return-Path: <kvm+bounces-9604-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 6AF5C8629BB
	for <lists+kvm@lfdr.de>; Sun, 25 Feb 2024 09:39:12 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 8F37E1C20C23
	for <lists+kvm@lfdr.de>; Sun, 25 Feb 2024 08:39:11 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B255EF4E2;
	Sun, 25 Feb 2024 08:39:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="BQEM2CEG"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1622BDF4E
	for <kvm@vger.kernel.org>; Sun, 25 Feb 2024 08:38:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708850341; cv=none; b=U3z2A+aAeavECoqayPMKSda7fPI+ngjWp/HxM8BBDEBep9UUOlCV+SmuPp6I2dhRm3sToAa7Cjug76reU/92tZcTwLvrDdggSQbuyAEeaKmfFyLQpOEyowUP+hiBSiHd85E45AIAD7K3ZWHM89nBbRXWDSk5KYb6DeYiQ8kyzqs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708850341; c=relaxed/simple;
	bh=XwoBp/lZSU/lG0USQah8IAohQuQR3IGwBy6XblKxmT0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=TY161nivAftj1TJMdmoLJ3vPypRu0Mgcc/TNbCXI/RKy6oqdvl8GCLHd/CCFpvP9we+5Kyy/B/wH89FQeFtYTlluc0ACQD5PyR/tDoT4RNRaRbgP3Xt/cZcGq2EOKmsqHPu1srJAj2lZGzp12qX6l/G8ItRYL0TrB52Hs8RDnng=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=BQEM2CEG; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1708850338;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=EOMCrVzOmp4RbossCfe+/kCrx/xWG8OsrWuMVOuxeWU=;
	b=BQEM2CEGCzKmpLYQUjwcXYhiOLkKw8KgLXzFfsHacxXs+41tDp5D5F9np96PK3v+DeAlT5
	4lUCVyH6mxrnltkK0vbYnOvW3RxAMrxCDyeGv+zlzmfplauycxdOCDMAsjGGpCfIpBUO46
	PAjG4wnqKUB/zGaoMBLvQ8uaQ/pTun4=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-608-0zWGaBNoON2uuETVLdv4WQ-1; Sun, 25 Feb 2024 03:38:57 -0500
X-MC-Unique: 0zWGaBNoON2uuETVLdv4WQ-1
Received: by mail-wr1-f70.google.com with SMTP id ffacd0b85a97d-33d39bc6bf4so1193121f8f.0
        for <kvm@vger.kernel.org>; Sun, 25 Feb 2024 00:38:57 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1708850336; x=1709455136;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=EOMCrVzOmp4RbossCfe+/kCrx/xWG8OsrWuMVOuxeWU=;
        b=I464ATqJKSqfeuvxG5iMLrPDW0+gY8Yv9foCT9holUuSZc1xfcmRECn+ZVqSgKf1wp
         9lG2ZMjnRYawFXr1d2r9it/38p2QXXQN2nIl78PWdl5xS/yV32LJQXC7aU9FhK89YdIN
         UKlI0lxtYeuNpdqsCfyO+2PbFxl5wpAdt6DKpWcNPXOSXyvP2+1lsJz4hp+I74geTnwW
         PpLSbIG+2TI7Mb3+jVQEe38hH4vn2oOOjYj3oL5Mgp9dwLkhVVf2XONRhto3ZBSL2fQc
         3INNiNLsfxnplx4p/ZbysUnuD/BM3Lkyi2x5jux39MdK1uYJy1VQmpkmdHuypESnOZwK
         9jpg==
X-Forwarded-Encrypted: i=1; AJvYcCWnRsy1zOXxXSnrlthQAHEEaImNflwn7gX8LZYFDxcUGjurg3AtoOoE+Fva1U8rzsEZg2ribxvSYbmGMNdsvwxy5Pka
X-Gm-Message-State: AOJu0YxssBNclHrnx5lJ7krRl/eZP3Hm2gxRtq3f4VhgbbWrswbMP4i2
	H6a3dWtNkKL2sKEu+d2YEqaNnN0YWdF+B7rjegt0ZgozSaHpy5P3ns1Mc5K9Y9bpoUJoAkFmWGX
	gmaxqxVj/YW7Oep56MSjvAVYiXouWtCifyIN2F2yxQqgCoGC+jg==
X-Received: by 2002:adf:e9cb:0:b0:33d:9d49:cfd1 with SMTP id l11-20020adfe9cb000000b0033d9d49cfd1mr3666329wrn.34.1708850336192;
        Sun, 25 Feb 2024 00:38:56 -0800 (PST)
X-Google-Smtp-Source: AGHT+IEhK28+oXcoeTRfiKdRQ9r84bfxBvSjdNy60lSOACL0i+/V47ase4Z2bcj3vqDRsDCm11uahQ==
X-Received: by 2002:adf:e9cb:0:b0:33d:9d49:cfd1 with SMTP id l11-20020adfe9cb000000b0033d9d49cfd1mr3666304wrn.34.1708850335736;
        Sun, 25 Feb 2024 00:38:55 -0800 (PST)
Received: from redhat.com ([2.52.10.44])
        by smtp.gmail.com with ESMTPSA id bv20-20020a0560001f1400b0033d73e1505bsm4513271wrb.18.2024.02.25.00.38.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 25 Feb 2024 00:38:54 -0800 (PST)
Date: Sun, 25 Feb 2024 03:38:48 -0500
From: "Michael S. Tsirkin" <mst@redhat.com>
To: Xuan Zhuo <xuanzhuo@linux.alibaba.com>
Cc: virtualization@lists.linux.dev, Richard Weinberger <richard@nod.at>,
	Anton Ivanov <anton.ivanov@cambridgegreys.com>,
	Johannes Berg <johannes@sipsolutions.net>,
	Jason Wang <jasowang@redhat.com>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
	Hans de Goede <hdegoede@redhat.com>,
	Ilpo =?iso-8859-1?Q?J=E4rvinen?= <ilpo.jarvinen@linux.intel.com>,
	Vadim Pasternak <vadimp@nvidia.com>,
	Bjorn Andersson <andersson@kernel.org>,
	Mathieu Poirier <mathieu.poirier@linaro.org>,
	Cornelia Huck <cohuck@redhat.com>,
	Halil Pasic <pasic@linux.ibm.com>,
	Eric Farman <farman@linux.ibm.com>,
	Heiko Carstens <hca@linux.ibm.com>,
	Vasily Gorbik <gor@linux.ibm.com>,
	Alexander Gordeev <agordeev@linux.ibm.com>,
	Christian Borntraeger <borntraeger@linux.ibm.com>,
	Sven Schnelle <svens@linux.ibm.com>,
	Alexei Starovoitov <ast@kernel.org>,
	Daniel Borkmann <daniel@iogearbox.net>,
	Jesper Dangaard Brouer <hawk@kernel.org>,
	John Fastabend <john.fastabend@gmail.com>,
	linux-um@lists.infradead.org, netdev@vger.kernel.org,
	platform-driver-x86@vger.kernel.org,
	linux-remoteproc@vger.kernel.org, linux-s390@vger.kernel.org,
	kvm@vger.kernel.org, bpf@vger.kernel.org
Subject: Re: [PATCH vhost v2 19/19] virtio_net: sq support premapped mode
Message-ID: <20240225032330-mutt-send-email-mst@kernel.org>
References: <20240223082726.52915-1-xuanzhuo@linux.alibaba.com>
 <20240223082726.52915-20-xuanzhuo@linux.alibaba.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240223082726.52915-20-xuanzhuo@linux.alibaba.com>

On Fri, Feb 23, 2024 at 04:27:26PM +0800, Xuan Zhuo wrote:
> If the xsk is enabling, the xsk tx will share the send queue.
> But the xsk requires that the send queue use the premapped mode.
> So the send queue must support premapped mode.
> 
> cmd:
>     sh samples/pktgen/pktgen_sample01_simple.sh -i eth0 \
>         -s 16 -d 10.0.0.128 -m 00:16:3e:2c:c8:2e -n 0 -p 100
> CPU:
>     Intel(R) Xeon(R) Platinum 8369B CPU @ 2.70GHz
> 
> Machine:
>     ecs.g7.2xlarge(Aliyun)
> 
> before:              1600010.00
> after(no-premapped): 1599966.00
> after(premapped):    1600014.00
> 
> Signed-off-by: Xuan Zhuo <xuanzhuo@linux.alibaba.com>
> ---
>  drivers/net/virtio_net.c | 136 +++++++++++++++++++++++++++++++++++++--
>  1 file changed, 132 insertions(+), 4 deletions(-)
> 
> diff --git a/drivers/net/virtio_net.c b/drivers/net/virtio_net.c
> index 7715bb7032ec..b83ef6afc4fb 100644
> --- a/drivers/net/virtio_net.c
> +++ b/drivers/net/virtio_net.c
> @@ -146,6 +146,25 @@ struct virtnet_rq_dma {
>  	u16 need_sync;
>  };
>  
> +struct virtnet_sq_dma {
> +	union {
> +		struct virtnet_sq_dma *next;
> +		void *data;
> +	};
> +
> +	u32 num;
> +
> +	dma_addr_t addr[MAX_SKB_FRAGS + 2];
> +	u32 len[MAX_SKB_FRAGS + 2];
> +};
> +
> +struct virtnet_sq_dma_head {
> +	/* record for kfree */
> +	void *p;
> +
> +	struct virtnet_sq_dma *free;
> +};
> +
>  /* Internal representation of a send virtqueue */
>  struct send_queue {
>  	/* Virtqueue associated with this send _queue */
> @@ -165,6 +184,8 @@ struct send_queue {
>  
>  	/* Record whether sq is in reset state. */
>  	bool reset;
> +
> +	struct virtnet_sq_dma_head dmainfo;
>  };
>  
>  /* Internal representation of a receive virtqueue */
> @@ -368,6 +389,95 @@ static struct xdp_frame *ptr_to_xdp(void *ptr)
>  	return (struct xdp_frame *)((unsigned long)ptr & ~VIRTIO_XDP_FLAG);
>  }
>  
> +static struct virtnet_sq_dma *virtnet_sq_unmap(struct send_queue *sq, void **data)
> +{
> +	struct virtnet_sq_dma *d;
> +	int i;
> +
> +	d = *data;
> +	*data = d->data;
> +
> +	for (i = 0; i < d->num; ++i)
> +		virtqueue_dma_unmap_page_attrs(sq->vq, d->addr[i], d->len[i],
> +					       DMA_TO_DEVICE, 0);
> +
> +	d->next = sq->dmainfo.free;
> +	sq->dmainfo.free = d;
> +
> +	return d;
> +}
> +
> +static struct virtnet_sq_dma *virtnet_sq_map_sg(struct send_queue *sq,
> +						int nents, void *data)
> +{
> +	struct virtnet_sq_dma *d;
> +	struct scatterlist *sg;
> +	int i;
> +
> +	if (!sq->dmainfo.free)
> +		return NULL;
> +
> +	d = sq->dmainfo.free;
> +	sq->dmainfo.free = d->next;
> +
> +	for_each_sg(sq->sg, sg, nents, i) {
> +		if (virtqueue_dma_map_sg_attrs(sq->vq, sg, DMA_TO_DEVICE, 0))
> +			goto err;
> +
> +		d->addr[i] = sg->dma_address;
> +		d->len[i] = sg->length;
> +	}
> +
> +	d->data = data;
> +	d->num = i;
> +	return d;
> +
> +err:
> +	d->num = i;
> +	virtnet_sq_unmap(sq, (void **)&d);
> +	return NULL;
> +}


Do I see a reimplementation of linux/llist.h here?


> +
> +static int virtnet_add_outbuf(struct send_queue *sq, u32 num, void *data)
> +{
> +	int ret;
> +
> +	if (sq->vq->premapped) {
> +		data = virtnet_sq_map_sg(sq, num, data);
> +		if (!data)
> +			return -ENOMEM;
> +	}
> +
> +	ret = virtqueue_add_outbuf(sq->vq, sq->sg, num, data, GFP_ATOMIC);
> +	if (ret && sq->vq->premapped)
> +		virtnet_sq_unmap(sq, &data);
> +
> +	return ret;
> +}
> +
> +static int virtnet_sq_init_dma_mate(struct send_queue *sq)

Mate? The popular south african drink?

> +{
> +	struct virtnet_sq_dma *d;
> +	int num, i;
> +
> +	num = virtqueue_get_vring_size(sq->vq);
> +
> +	sq->dmainfo.free = kcalloc(num, sizeof(*sq->dmainfo.free), GFP_KERNEL);
> +	if (!sq->dmainfo.free)
> +		return -ENOMEM;


This could be quite a bit of memory for a large queue.  And for a bunch
of common cases where unmap is a nop (e.g. iommu pt) this does nothing
useful at all.  And also, this does nothing useful if PLATFORM_ACCESS is off
which is super common.

A while ago I proposed:
- extend DMA APIs so one can query whether unmap is a nop
  and whether sync is a nop
- virtio wrapper taking into account PLATFORM_ACCESS too

then we can save all this work and memory when not needed.



> +
> +	sq->dmainfo.p = sq->dmainfo.free;
> +
> +	for (i = 0; i < num; ++i) {
> +		d = &sq->dmainfo.free[i];
> +		d->next = d + 1;
> +	}
> +
> +	d->next = NULL;
> +
> +	return 0;
> +}
> +
>  static void __free_old_xmit(struct send_queue *sq, bool in_napi,
>  			    struct virtnet_sq_free_stats *stats)
>  {
> @@ -377,6 +487,9 @@ static void __free_old_xmit(struct send_queue *sq, bool in_napi,
>  	while ((ptr = virtqueue_get_buf(sq->vq, &len)) != NULL) {
>  		++stats->packets;
>  
> +		if (sq->vq->premapped)
> +			virtnet_sq_unmap(sq, &ptr);
> +
>  		if (!is_xdp_frame(ptr)) {
>  			struct sk_buff *skb = ptr;
>  
> @@ -890,8 +1003,7 @@ static int __virtnet_xdp_xmit_one(struct virtnet_info *vi,
>  			    skb_frag_size(frag), skb_frag_off(frag));
>  	}
>  
> -	err = virtqueue_add_outbuf(sq->vq, sq->sg, nr_frags + 1,
> -				   xdp_to_ptr(xdpf), GFP_ATOMIC);
> +	err = virtnet_add_outbuf(sq, nr_frags + 1, xdp_to_ptr(xdpf));
>  	if (unlikely(err))
>  		return -ENOSPC; /* Caller handle free/refcnt */
>  
> @@ -2357,7 +2469,7 @@ static int xmit_skb(struct send_queue *sq, struct sk_buff *skb)
>  			return num_sg;
>  		num_sg++;
>  	}
> -	return virtqueue_add_outbuf(sq->vq, sq->sg, num_sg, skb, GFP_ATOMIC);
> +	return virtnet_add_outbuf(sq, num_sg, skb);
>  }
>  
>  static netdev_tx_t start_xmit(struct sk_buff *skb, struct net_device *dev)
> @@ -4166,6 +4278,8 @@ static void virtnet_free_queues(struct virtnet_info *vi)
>  	for (i = 0; i < vi->max_queue_pairs; i++) {
>  		__netif_napi_del(&vi->rq[i].napi);
>  		__netif_napi_del(&vi->sq[i].napi);
> +
> +		kfree(vi->sq[i].dmainfo.p);
>  	}
>  
>  	/* We called __netif_napi_del(),
> @@ -4214,6 +4328,15 @@ static void free_receive_page_frags(struct virtnet_info *vi)
>  
>  static void virtnet_sq_free_unused_buf(struct virtqueue *vq, void *buf)
>  {
> +	struct virtnet_info *vi = vq->vdev->priv;
> +	struct send_queue *sq;
> +	int i = vq2rxq(vq);
> +
> +	sq = &vi->sq[i];
> +
> +	if (sq->vq->premapped)
> +		virtnet_sq_unmap(sq, &buf);
> +
>  	if (!is_xdp_frame(buf))
>  		dev_kfree_skb(buf);
>  	else
> @@ -4327,8 +4450,10 @@ static int virtnet_find_vqs(struct virtnet_info *vi)
>  		if (ctx)
>  			ctx[rxq2vq(i)] = true;
>  
> -		if (premapped)
> +		if (premapped) {
>  			premapped[rxq2vq(i)] = true;
> +			premapped[txq2vq(i)] = true;
> +		}
>  	}
>  
>  	cfg.nvqs      = total_vqs;
> @@ -4352,6 +4477,9 @@ static int virtnet_find_vqs(struct virtnet_info *vi)
>  		vi->rq[i].vq = vqs[rxq2vq(i)];
>  		vi->rq[i].min_buf_len = mergeable_min_buf_len(vi, vi->rq[i].vq);
>  		vi->sq[i].vq = vqs[txq2vq(i)];
> +
> +		if (vi->sq[i].vq->premapped)
> +			virtnet_sq_init_dma_mate(&vi->sq[i]);
>  	}
>  
>  	/* run here: ret == 0. */
> -- 
> 2.32.0.3.g01195cf9f


