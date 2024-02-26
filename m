Return-Path: <kvm+bounces-9779-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 1AEFB866F92
	for <lists+kvm@lfdr.de>; Mon, 26 Feb 2024 10:59:12 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 3F96B1C25724
	for <lists+kvm@lfdr.de>; Mon, 26 Feb 2024 09:59:11 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 14C6558100;
	Mon, 26 Feb 2024 09:30:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b="C1J5Z6CN"
X-Original-To: kvm@vger.kernel.org
Received: from out30-119.freemail.mail.aliyun.com (out30-119.freemail.mail.aliyun.com [115.124.30.119])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 52D101BC30;
	Mon, 26 Feb 2024 09:30:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=115.124.30.119
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708939844; cv=none; b=is3j56z1D3XOQD0Xpa3Ch1nEV1R52jrTZf17fdtMgjDonic/rHEk2hhZ6F9LyEmu14a/6F4ecH4M0gA+XkvK8U76LVCMkSq44QzdCVbB0c6MwV7giyvfNP0k6VGfRgyhpmtKFzL8Gt/mAFGK86nQU+00gDx2AlOSfWfArIsX10I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708939844; c=relaxed/simple;
	bh=OiE2GjI9ymIQ6HLdX0je5+ntcMKubBu34WK+jFxRGvU=;
	h=Message-ID:Subject:Date:From:To:Cc:References:In-Reply-To; b=WL5CLe9h+w4LhS3v5NehrlR9UkysMqf+ruhzNAzCQDDpthZMfeqHYobAIbhsWj7JGlwxL3ctr01Vg0Xm8/knAip1Rej7e9wkx5ohhlsdz4xvjP+2vzJNuGt3WnO9zEVid0LJWatAUamio3NdCB/vrkf6AEqjVlkQ8pzkVo5/E4E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com; spf=pass smtp.mailfrom=linux.alibaba.com; dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b=C1J5Z6CN; arc=none smtp.client-ip=115.124.30.119
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.alibaba.com
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1708939838; h=Message-ID:Subject:Date:From:To;
	bh=xEH79XloeCWwYFRjbQWwvM/K3wpplCxfHiQw2CFFMEw=;
	b=C1J5Z6CNpobwtdL/mJzebFYe3fObzQTeUIaFu0CGMFGZ6mgwmvPl4yF3KnR/Lhb9xxW0MnCnRWjr7lz9Evhy/4DMrnrLSLfP/IEaEOq6B7mN6OWERG7wLEXcnEoQghke/PGQFN++w1tB0SL3KSYlYcom7mWfwkJp/yozhbaKl7A=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R201e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=ay29a033018046059;MF=xuanzhuo@linux.alibaba.com;NM=1;PH=DS;RN=34;SR=0;TI=SMTPD_---0W1FmByV_1708939835;
Received: from localhost(mailfrom:xuanzhuo@linux.alibaba.com fp:SMTPD_---0W1FmByV_1708939835)
          by smtp.aliyun-inc.com;
          Mon, 26 Feb 2024 17:30:36 +0800
Message-ID: <1708939451.7601678-3-xuanzhuo@linux.alibaba.com>
Subject: Re: [PATCH vhost v2 19/19] virtio_net: sq support premapped mode
Date: Mon, 26 Feb 2024 17:24:11 +0800
From: Xuan Zhuo <xuanzhuo@linux.alibaba.com>
To: "Michael S. Tsirkin" <mst@redhat.com>
Cc: virtualization@lists.linux.dev,
 Richard Weinberger <richard@nod.at>,
 Anton Ivanov <anton.ivanov@cambridgegreys.com>,
 Johannes Berg <johannes@sipsolutions.net>,
 Jason Wang <jasowang@redhat.com>,
 "David S. Miller" <davem@davemloft.net>,
 Eric Dumazet <edumazet@google.com>,
 Jakub Kicinski <kuba@kernel.org>,
 Paolo Abeni <pabeni@redhat.com>,
 Hans de Goede <hdegoede@redhat.com>,
 =?utf-8?q?Ilpo_J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>,
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
 linux-um@lists.infradead.org,
 netdev@vger.kernel.org,
 platform-driver-x86@vger.kernel.org,
 linux-remoteproc@vger.kernel.org,
 linux-s390@vger.kernel.org,
 kvm@vger.kernel.org,
 bpf@vger.kernel.org
References: <20240223082726.52915-1-xuanzhuo@linux.alibaba.com>
 <20240223082726.52915-20-xuanzhuo@linux.alibaba.com>
 <20240225032330-mutt-send-email-mst@kernel.org>
In-Reply-To: <20240225032330-mutt-send-email-mst@kernel.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>

On Sun, 25 Feb 2024 03:38:48 -0500, "Michael S. Tsirkin" <mst@redhat.com> wrote:
> On Fri, Feb 23, 2024 at 04:27:26PM +0800, Xuan Zhuo wrote:
> > If the xsk is enabling, the xsk tx will share the send queue.
> > But the xsk requires that the send queue use the premapped mode.
> > So the send queue must support premapped mode.
> >
> > cmd:
> >     sh samples/pktgen/pktgen_sample01_simple.sh -i eth0 \
> >         -s 16 -d 10.0.0.128 -m 00:16:3e:2c:c8:2e -n 0 -p 100
> > CPU:
> >     Intel(R) Xeon(R) Platinum 8369B CPU @ 2.70GHz
> >
> > Machine:
> >     ecs.g7.2xlarge(Aliyun)
> >
> > before:              1600010.00
> > after(no-premapped): 1599966.00
> > after(premapped):    1600014.00
> >
> > Signed-off-by: Xuan Zhuo <xuanzhuo@linux.alibaba.com>
> > ---
> >  drivers/net/virtio_net.c | 136 +++++++++++++++++++++++++++++++++++++--
> >  1 file changed, 132 insertions(+), 4 deletions(-)
> >
> > diff --git a/drivers/net/virtio_net.c b/drivers/net/virtio_net.c
> > index 7715bb7032ec..b83ef6afc4fb 100644
> > --- a/drivers/net/virtio_net.c
> > +++ b/drivers/net/virtio_net.c
> > @@ -146,6 +146,25 @@ struct virtnet_rq_dma {
> >  	u16 need_sync;
> >  };
> >
> > +struct virtnet_sq_dma {
> > +	union {
> > +		struct virtnet_sq_dma *next;
> > +		void *data;
> > +	};
> > +
> > +	u32 num;
> > +
> > +	dma_addr_t addr[MAX_SKB_FRAGS + 2];
> > +	u32 len[MAX_SKB_FRAGS + 2];
> > +};
> > +
> > +struct virtnet_sq_dma_head {
> > +	/* record for kfree */
> > +	void *p;
> > +
> > +	struct virtnet_sq_dma *free;
> > +};
> > +
> >  /* Internal representation of a send virtqueue */
> >  struct send_queue {
> >  	/* Virtqueue associated with this send _queue */
> > @@ -165,6 +184,8 @@ struct send_queue {
> >
> >  	/* Record whether sq is in reset state. */
> >  	bool reset;
> > +
> > +	struct virtnet_sq_dma_head dmainfo;
> >  };
> >
> >  /* Internal representation of a receive virtqueue */
> > @@ -368,6 +389,95 @@ static struct xdp_frame *ptr_to_xdp(void *ptr)
> >  	return (struct xdp_frame *)((unsigned long)ptr & ~VIRTIO_XDP_FLAG);
> >  }
> >
> > +static struct virtnet_sq_dma *virtnet_sq_unmap(struct send_queue *sq, void **data)
> > +{
> > +	struct virtnet_sq_dma *d;
> > +	int i;
> > +
> > +	d = *data;
> > +	*data = d->data;
> > +
> > +	for (i = 0; i < d->num; ++i)
> > +		virtqueue_dma_unmap_page_attrs(sq->vq, d->addr[i], d->len[i],
> > +					       DMA_TO_DEVICE, 0);
> > +
> > +	d->next = sq->dmainfo.free;
> > +	sq->dmainfo.free = d;
> > +
> > +	return d;
> > +}
> > +
> > +static struct virtnet_sq_dma *virtnet_sq_map_sg(struct send_queue *sq,
> > +						int nents, void *data)
> > +{
> > +	struct virtnet_sq_dma *d;
> > +	struct scatterlist *sg;
> > +	int i;
> > +
> > +	if (!sq->dmainfo.free)
> > +		return NULL;
> > +
> > +	d = sq->dmainfo.free;
> > +	sq->dmainfo.free = d->next;
> > +
> > +	for_each_sg(sq->sg, sg, nents, i) {
> > +		if (virtqueue_dma_map_sg_attrs(sq->vq, sg, DMA_TO_DEVICE, 0))
> > +			goto err;
> > +
> > +		d->addr[i] = sg->dma_address;
> > +		d->len[i] = sg->length;
> > +	}
> > +
> > +	d->data = data;
> > +	d->num = i;
> > +	return d;
> > +
> > +err:
> > +	d->num = i;
> > +	virtnet_sq_unmap(sq, (void **)&d);
> > +	return NULL;
> > +}
>
>
> Do I see a reimplementation of linux/llist.h here?
>
>
> > +
> > +static int virtnet_add_outbuf(struct send_queue *sq, u32 num, void *data)
> > +{
> > +	int ret;
> > +
> > +	if (sq->vq->premapped) {
> > +		data = virtnet_sq_map_sg(sq, num, data);
> > +		if (!data)
> > +			return -ENOMEM;
> > +	}
> > +
> > +	ret = virtqueue_add_outbuf(sq->vq, sq->sg, num, data, GFP_ATOMIC);
> > +	if (ret && sq->vq->premapped)
> > +		virtnet_sq_unmap(sq, &data);
> > +
> > +	return ret;
> > +}
> > +
> > +static int virtnet_sq_init_dma_mate(struct send_queue *sq)
>
> Mate? The popular south african drink?
>
> > +{
> > +	struct virtnet_sq_dma *d;
> > +	int num, i;
> > +
> > +	num = virtqueue_get_vring_size(sq->vq);
> > +
> > +	sq->dmainfo.free = kcalloc(num, sizeof(*sq->dmainfo.free), GFP_KERNEL);
> > +	if (!sq->dmainfo.free)
> > +		return -ENOMEM;
>
>
> This could be quite a bit of memory for a large queue.  And for a bunch
> of common cases where unmap is a nop (e.g. iommu pt) this does nothing
> useful at all.  And also, this does nothing useful if PLATFORM_ACCESS is off
> which is super common.
>
> A while ago I proposed:
> - extend DMA APIs so one can query whether unmap is a nop


We may have trouble for this.

dma_addr_t dma_map_page_attrs(struct device *dev, struct page *page,
		size_t offset, size_t size, enum dma_data_direction dir,
		unsigned long attrs)
{
	const struct dma_map_ops *ops = get_dma_ops(dev);
	dma_addr_t addr;

	BUG_ON(!valid_dma_direction(dir));

	if (WARN_ON_ONCE(!dev->dma_mask))
		return DMA_MAPPING_ERROR;

	if (dma_map_direct(dev, ops) ||
	    arch_dma_map_page_direct(dev, page_to_phys(page) + offset + size))
		addr = dma_direct_map_page(dev, page, offset, size, dir, attrs);
	else
		addr = ops->map_page(dev, page, offset, size, dir, attrs);
	kmsan_handle_dma(page, offset, size, dir);
	debug_dma_map_page(dev, page, offset, size, dir, addr, attrs);

	return addr;
}

arch_dma_map_page_direct will check the dma address.
So we can not judge by the API in advance.

Thanks.




>   and whether sync is a nop
> - virtio wrapper taking into account PLATFORM_ACCESS too
>
> then we can save all this work and memory when not needed.
>
>
>
> > +
> > +	sq->dmainfo.p = sq->dmainfo.free;
> > +
> > +	for (i = 0; i < num; ++i) {
> > +		d = &sq->dmainfo.free[i];
> > +		d->next = d + 1;
> > +	}
> > +
> > +	d->next = NULL;
> > +
> > +	return 0;
> > +}
> > +
> >  static void __free_old_xmit(struct send_queue *sq, bool in_napi,
> >  			    struct virtnet_sq_free_stats *stats)
> >  {
> > @@ -377,6 +487,9 @@ static void __free_old_xmit(struct send_queue *sq, bool in_napi,
> >  	while ((ptr = virtqueue_get_buf(sq->vq, &len)) != NULL) {
> >  		++stats->packets;
> >
> > +		if (sq->vq->premapped)
> > +			virtnet_sq_unmap(sq, &ptr);
> > +
> >  		if (!is_xdp_frame(ptr)) {
> >  			struct sk_buff *skb = ptr;
> >
> > @@ -890,8 +1003,7 @@ static int __virtnet_xdp_xmit_one(struct virtnet_info *vi,
> >  			    skb_frag_size(frag), skb_frag_off(frag));
> >  	}
> >
> > -	err = virtqueue_add_outbuf(sq->vq, sq->sg, nr_frags + 1,
> > -				   xdp_to_ptr(xdpf), GFP_ATOMIC);
> > +	err = virtnet_add_outbuf(sq, nr_frags + 1, xdp_to_ptr(xdpf));
> >  	if (unlikely(err))
> >  		return -ENOSPC; /* Caller handle free/refcnt */
> >
> > @@ -2357,7 +2469,7 @@ static int xmit_skb(struct send_queue *sq, struct sk_buff *skb)
> >  			return num_sg;
> >  		num_sg++;
> >  	}
> > -	return virtqueue_add_outbuf(sq->vq, sq->sg, num_sg, skb, GFP_ATOMIC);
> > +	return virtnet_add_outbuf(sq, num_sg, skb);
> >  }
> >
> >  static netdev_tx_t start_xmit(struct sk_buff *skb, struct net_device *dev)
> > @@ -4166,6 +4278,8 @@ static void virtnet_free_queues(struct virtnet_info *vi)
> >  	for (i = 0; i < vi->max_queue_pairs; i++) {
> >  		__netif_napi_del(&vi->rq[i].napi);
> >  		__netif_napi_del(&vi->sq[i].napi);
> > +
> > +		kfree(vi->sq[i].dmainfo.p);
> >  	}
> >
> >  	/* We called __netif_napi_del(),
> > @@ -4214,6 +4328,15 @@ static void free_receive_page_frags(struct virtnet_info *vi)
> >
> >  static void virtnet_sq_free_unused_buf(struct virtqueue *vq, void *buf)
> >  {
> > +	struct virtnet_info *vi = vq->vdev->priv;
> > +	struct send_queue *sq;
> > +	int i = vq2rxq(vq);
> > +
> > +	sq = &vi->sq[i];
> > +
> > +	if (sq->vq->premapped)
> > +		virtnet_sq_unmap(sq, &buf);
> > +
> >  	if (!is_xdp_frame(buf))
> >  		dev_kfree_skb(buf);
> >  	else
> > @@ -4327,8 +4450,10 @@ static int virtnet_find_vqs(struct virtnet_info *vi)
> >  		if (ctx)
> >  			ctx[rxq2vq(i)] = true;
> >
> > -		if (premapped)
> > +		if (premapped) {
> >  			premapped[rxq2vq(i)] = true;
> > +			premapped[txq2vq(i)] = true;
> > +		}
> >  	}
> >
> >  	cfg.nvqs      = total_vqs;
> > @@ -4352,6 +4477,9 @@ static int virtnet_find_vqs(struct virtnet_info *vi)
> >  		vi->rq[i].vq = vqs[rxq2vq(i)];
> >  		vi->rq[i].min_buf_len = mergeable_min_buf_len(vi, vi->rq[i].vq);
> >  		vi->sq[i].vq = vqs[txq2vq(i)];
> > +
> > +		if (vi->sq[i].vq->premapped)
> > +			virtnet_sq_init_dma_mate(&vi->sq[i]);
> >  	}
> >
> >  	/* run here: ret == 0. */
> > --
> > 2.32.0.3.g01195cf9f
>

