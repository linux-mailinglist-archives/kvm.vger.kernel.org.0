Return-Path: <kvm+bounces-9849-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 371FB8673B0
	for <lists+kvm@lfdr.de>; Mon, 26 Feb 2024 12:43:42 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 5AB971C25AB8
	for <lists+kvm@lfdr.de>; Mon, 26 Feb 2024 11:43:41 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E661522091;
	Mon, 26 Feb 2024 11:43:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b="aJlU6eY8"
X-Original-To: kvm@vger.kernel.org
Received: from out30-113.freemail.mail.aliyun.com (out30-113.freemail.mail.aliyun.com [115.124.30.113])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F051C1DA4E;
	Mon, 26 Feb 2024 11:43:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=115.124.30.113
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708947799; cv=none; b=GK72aPMAmSCsK/krCg0yigJMKDkA846Z9vg33Gavv2IiSssuF0Wgd4jQ8xRmsr7W7sdwTZhzGg6iCu/i4hQf0YGG3vTgrc+UounhBxVwry5BB92hCUa7rHdIX0W6Uc1Uq19blJ8btD/Dpmxqi/mvMSIHgK4Cl3uL9+UuPGX3wsc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708947799; c=relaxed/simple;
	bh=PwanmAhLF9R2KkluYxxvPaUYAP2rKx4wJr10rs8by2w=;
	h=Message-ID:Subject:Date:From:To:Cc:References:In-Reply-To; b=HXrK7fAaPm+ltsewm8ELvCBL71fwzeQ5ebvxQu0039f+VoLUgf5+RoaTknpP7FXO1B3apzV4ivOADDWbFR9IxIfL6czLazhedy8H1nUID0hJwEL+KaRtIXGwBTIJNddtExl6EWouZ26iExlXogKs+VYG4BCW12w0VUZAH//d2Eo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com; spf=pass smtp.mailfrom=linux.alibaba.com; dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b=aJlU6eY8; arc=none smtp.client-ip=115.124.30.113
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.alibaba.com
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1708947794; h=Message-ID:Subject:Date:From:To;
	bh=w54PmwyV0s9tFV5jocGx7O22Pyuye58ZHfjd5DpkDv0=;
	b=aJlU6eY85rf2o5yJ3Vwx/O2vRDr3qGwZwYVCq548izWI46nI8ad3PfjFsb6QFvTT2YHsLMLktoAvu7y9qs0VbvDTqen0c5Op7dG2tB4jzFHXUnJsdIin3f7ysCF+4jGuiEuU2G43Si++lmLe/tD38L/RhxNauoirO2sZMQuGZqM=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R861e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=ay29a033018046059;MF=xuanzhuo@linux.alibaba.com;NM=1;PH=DS;RN=34;SR=0;TI=SMTPD_---0W1HktSN_1708947791;
Received: from localhost(mailfrom:xuanzhuo@linux.alibaba.com fp:SMTPD_---0W1HktSN_1708947791)
          by smtp.aliyun-inc.com;
          Mon, 26 Feb 2024 19:43:12 +0800
Message-ID: <1708947680.4503584-3-xuanzhuo@linux.alibaba.com>
Subject: Re: [PATCH vhost v2 19/19] virtio_net: sq support premapped mode
Date: Mon, 26 Feb 2024 19:41:20 +0800
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
 <1708939451.7601678-3-xuanzhuo@linux.alibaba.com>
 <20240226063843-mutt-send-email-mst@kernel.org>
In-Reply-To: <20240226063843-mutt-send-email-mst@kernel.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>

On Mon, 26 Feb 2024 06:39:51 -0500, "Michael S. Tsirkin" <mst@redhat.com> wrote:
> On Mon, Feb 26, 2024 at 05:24:11PM +0800, Xuan Zhuo wrote:
> > On Sun, 25 Feb 2024 03:38:48 -0500, "Michael S. Tsirkin" <mst@redhat.com> wrote:
> > > On Fri, Feb 23, 2024 at 04:27:26PM +0800, Xuan Zhuo wrote:
> > > > If the xsk is enabling, the xsk tx will share the send queue.
> > > > But the xsk requires that the send queue use the premapped mode.
> > > > So the send queue must support premapped mode.
> > > >
> > > > cmd:
> > > >     sh samples/pktgen/pktgen_sample01_simple.sh -i eth0 \
> > > >         -s 16 -d 10.0.0.128 -m 00:16:3e:2c:c8:2e -n 0 -p 100
> > > > CPU:
> > > >     Intel(R) Xeon(R) Platinum 8369B CPU @ 2.70GHz
> > > >
> > > > Machine:
> > > >     ecs.g7.2xlarge(Aliyun)
> > > >
> > > > before:              1600010.00
> > > > after(no-premapped): 1599966.00
> > > > after(premapped):    1600014.00
> > > >
> > > > Signed-off-by: Xuan Zhuo <xuanzhuo@linux.alibaba.com>
> > > > ---
> > > >  drivers/net/virtio_net.c | 136 +++++++++++++++++++++++++++++++++++++--
> > > >  1 file changed, 132 insertions(+), 4 deletions(-)
> > > >
> > > > diff --git a/drivers/net/virtio_net.c b/drivers/net/virtio_net.c
> > > > index 7715bb7032ec..b83ef6afc4fb 100644
> > > > --- a/drivers/net/virtio_net.c
> > > > +++ b/drivers/net/virtio_net.c
> > > > @@ -146,6 +146,25 @@ struct virtnet_rq_dma {
> > > >  	u16 need_sync;
> > > >  };
> > > >
> > > > +struct virtnet_sq_dma {
> > > > +	union {
> > > > +		struct virtnet_sq_dma *next;
> > > > +		void *data;
> > > > +	};
> > > > +
> > > > +	u32 num;
> > > > +
> > > > +	dma_addr_t addr[MAX_SKB_FRAGS + 2];
> > > > +	u32 len[MAX_SKB_FRAGS + 2];
> > > > +};
> > > > +
> > > > +struct virtnet_sq_dma_head {
> > > > +	/* record for kfree */
> > > > +	void *p;
> > > > +
> > > > +	struct virtnet_sq_dma *free;
> > > > +};
> > > > +
> > > >  /* Internal representation of a send virtqueue */
> > > >  struct send_queue {
> > > >  	/* Virtqueue associated with this send _queue */
> > > > @@ -165,6 +184,8 @@ struct send_queue {
> > > >
> > > >  	/* Record whether sq is in reset state. */
> > > >  	bool reset;
> > > > +
> > > > +	struct virtnet_sq_dma_head dmainfo;
> > > >  };
> > > >
> > > >  /* Internal representation of a receive virtqueue */
> > > > @@ -368,6 +389,95 @@ static struct xdp_frame *ptr_to_xdp(void *ptr)
> > > >  	return (struct xdp_frame *)((unsigned long)ptr & ~VIRTIO_XDP_FLAG);
> > > >  }
> > > >
> > > > +static struct virtnet_sq_dma *virtnet_sq_unmap(struct send_queue *sq, void **data)
> > > > +{
> > > > +	struct virtnet_sq_dma *d;
> > > > +	int i;
> > > > +
> > > > +	d = *data;
> > > > +	*data = d->data;
> > > > +
> > > > +	for (i = 0; i < d->num; ++i)
> > > > +		virtqueue_dma_unmap_page_attrs(sq->vq, d->addr[i], d->len[i],
> > > > +					       DMA_TO_DEVICE, 0);
> > > > +
> > > > +	d->next = sq->dmainfo.free;
> > > > +	sq->dmainfo.free = d;
> > > > +
> > > > +	return d;
> > > > +}
> > > > +
> > > > +static struct virtnet_sq_dma *virtnet_sq_map_sg(struct send_queue *sq,
> > > > +						int nents, void *data)
> > > > +{
> > > > +	struct virtnet_sq_dma *d;
> > > > +	struct scatterlist *sg;
> > > > +	int i;
> > > > +
> > > > +	if (!sq->dmainfo.free)
> > > > +		return NULL;
> > > > +
> > > > +	d = sq->dmainfo.free;
> > > > +	sq->dmainfo.free = d->next;
> > > > +
> > > > +	for_each_sg(sq->sg, sg, nents, i) {
> > > > +		if (virtqueue_dma_map_sg_attrs(sq->vq, sg, DMA_TO_DEVICE, 0))
> > > > +			goto err;
> > > > +
> > > > +		d->addr[i] = sg->dma_address;
> > > > +		d->len[i] = sg->length;
> > > > +	}
> > > > +
> > > > +	d->data = data;
> > > > +	d->num = i;
> > > > +	return d;
> > > > +
> > > > +err:
> > > > +	d->num = i;
> > > > +	virtnet_sq_unmap(sq, (void **)&d);
> > > > +	return NULL;
> > > > +}
> > >
> > >
> > > Do I see a reimplementation of linux/llist.h here?
> > >
> > >
> > > > +
> > > > +static int virtnet_add_outbuf(struct send_queue *sq, u32 num, void *data)
> > > > +{
> > > > +	int ret;
> > > > +
> > > > +	if (sq->vq->premapped) {
> > > > +		data = virtnet_sq_map_sg(sq, num, data);
> > > > +		if (!data)
> > > > +			return -ENOMEM;
> > > > +	}
> > > > +
> > > > +	ret = virtqueue_add_outbuf(sq->vq, sq->sg, num, data, GFP_ATOMIC);
> > > > +	if (ret && sq->vq->premapped)
> > > > +		virtnet_sq_unmap(sq, &data);
> > > > +
> > > > +	return ret;
> > > > +}
> > > > +
> > > > +static int virtnet_sq_init_dma_mate(struct send_queue *sq)
> > >
> > > Mate? The popular south african drink?
> > >
> > > > +{
> > > > +	struct virtnet_sq_dma *d;
> > > > +	int num, i;
> > > > +
> > > > +	num = virtqueue_get_vring_size(sq->vq);
> > > > +
> > > > +	sq->dmainfo.free = kcalloc(num, sizeof(*sq->dmainfo.free), GFP_KERNEL);
> > > > +	if (!sq->dmainfo.free)
> > > > +		return -ENOMEM;
> > >
> > >
> > > This could be quite a bit of memory for a large queue.  And for a bunch
> > > of common cases where unmap is a nop (e.g. iommu pt) this does nothing
> > > useful at all.  And also, this does nothing useful if PLATFORM_ACCESS is off
> > > which is super common.
> > >
> > > A while ago I proposed:
> > > - extend DMA APIs so one can query whether unmap is a nop
> >
> >
> > We may have trouble for this.
> >
> > dma_addr_t dma_map_page_attrs(struct device *dev, struct page *page,
> > 		size_t offset, size_t size, enum dma_data_direction dir,
> > 		unsigned long attrs)
> > {
> > 	const struct dma_map_ops *ops = get_dma_ops(dev);
> > 	dma_addr_t addr;
> >
> > 	BUG_ON(!valid_dma_direction(dir));
> >
> > 	if (WARN_ON_ONCE(!dev->dma_mask))
> > 		return DMA_MAPPING_ERROR;
> >
> > 	if (dma_map_direct(dev, ops) ||
> > 	    arch_dma_map_page_direct(dev, page_to_phys(page) + offset + size))
> > 		addr = dma_direct_map_page(dev, page, offset, size, dir, attrs);
> > 	else
> > 		addr = ops->map_page(dev, page, offset, size, dir, attrs);
> > 	kmsan_handle_dma(page, offset, size, dir);
> > 	debug_dma_map_page(dev, page, offset, size, dir, addr, attrs);
> >
> > 	return addr;
> > }
> >
> > arch_dma_map_page_direct will check the dma address.
> > So we can not judge by the API in advance.
> >
> > Thanks.
>
> So if dma_map_direct is false we'll still waste some memory.
> So be it.

arch_dma_map_page_direct default is marco (false), just for powerpc
it is a function. So I think we can skip it.

If the dma_map_direct is false, I think should save the dma info.

Thanks.

>
>
> >
> >
> >
> > >   and whether sync is a nop
> > > - virtio wrapper taking into account PLATFORM_ACCESS too
> > >
> > > then we can save all this work and memory when not needed.
> > >
> > >
> > >
> > > > +
> > > > +	sq->dmainfo.p = sq->dmainfo.free;
> > > > +
> > > > +	for (i = 0; i < num; ++i) {
> > > > +		d = &sq->dmainfo.free[i];
> > > > +		d->next = d + 1;
> > > > +	}
> > > > +
> > > > +	d->next = NULL;
> > > > +
> > > > +	return 0;
> > > > +}
> > > > +
> > > >  static void __free_old_xmit(struct send_queue *sq, bool in_napi,
> > > >  			    struct virtnet_sq_free_stats *stats)
> > > >  {
> > > > @@ -377,6 +487,9 @@ static void __free_old_xmit(struct send_queue *sq, bool in_napi,
> > > >  	while ((ptr = virtqueue_get_buf(sq->vq, &len)) != NULL) {
> > > >  		++stats->packets;
> > > >
> > > > +		if (sq->vq->premapped)
> > > > +			virtnet_sq_unmap(sq, &ptr);
> > > > +
> > > >  		if (!is_xdp_frame(ptr)) {
> > > >  			struct sk_buff *skb = ptr;
> > > >
> > > > @@ -890,8 +1003,7 @@ static int __virtnet_xdp_xmit_one(struct virtnet_info *vi,
> > > >  			    skb_frag_size(frag), skb_frag_off(frag));
> > > >  	}
> > > >
> > > > -	err = virtqueue_add_outbuf(sq->vq, sq->sg, nr_frags + 1,
> > > > -				   xdp_to_ptr(xdpf), GFP_ATOMIC);
> > > > +	err = virtnet_add_outbuf(sq, nr_frags + 1, xdp_to_ptr(xdpf));
> > > >  	if (unlikely(err))
> > > >  		return -ENOSPC; /* Caller handle free/refcnt */
> > > >
> > > > @@ -2357,7 +2469,7 @@ static int xmit_skb(struct send_queue *sq, struct sk_buff *skb)
> > > >  			return num_sg;
> > > >  		num_sg++;
> > > >  	}
> > > > -	return virtqueue_add_outbuf(sq->vq, sq->sg, num_sg, skb, GFP_ATOMIC);
> > > > +	return virtnet_add_outbuf(sq, num_sg, skb);
> > > >  }
> > > >
> > > >  static netdev_tx_t start_xmit(struct sk_buff *skb, struct net_device *dev)
> > > > @@ -4166,6 +4278,8 @@ static void virtnet_free_queues(struct virtnet_info *vi)
> > > >  	for (i = 0; i < vi->max_queue_pairs; i++) {
> > > >  		__netif_napi_del(&vi->rq[i].napi);
> > > >  		__netif_napi_del(&vi->sq[i].napi);
> > > > +
> > > > +		kfree(vi->sq[i].dmainfo.p);
> > > >  	}
> > > >
> > > >  	/* We called __netif_napi_del(),
> > > > @@ -4214,6 +4328,15 @@ static void free_receive_page_frags(struct virtnet_info *vi)
> > > >
> > > >  static void virtnet_sq_free_unused_buf(struct virtqueue *vq, void *buf)
> > > >  {
> > > > +	struct virtnet_info *vi = vq->vdev->priv;
> > > > +	struct send_queue *sq;
> > > > +	int i = vq2rxq(vq);
> > > > +
> > > > +	sq = &vi->sq[i];
> > > > +
> > > > +	if (sq->vq->premapped)
> > > > +		virtnet_sq_unmap(sq, &buf);
> > > > +
> > > >  	if (!is_xdp_frame(buf))
> > > >  		dev_kfree_skb(buf);
> > > >  	else
> > > > @@ -4327,8 +4450,10 @@ static int virtnet_find_vqs(struct virtnet_info *vi)
> > > >  		if (ctx)
> > > >  			ctx[rxq2vq(i)] = true;
> > > >
> > > > -		if (premapped)
> > > > +		if (premapped) {
> > > >  			premapped[rxq2vq(i)] = true;
> > > > +			premapped[txq2vq(i)] = true;
> > > > +		}
> > > >  	}
> > > >
> > > >  	cfg.nvqs      = total_vqs;
> > > > @@ -4352,6 +4477,9 @@ static int virtnet_find_vqs(struct virtnet_info *vi)
> > > >  		vi->rq[i].vq = vqs[rxq2vq(i)];
> > > >  		vi->rq[i].min_buf_len = mergeable_min_buf_len(vi, vi->rq[i].vq);
> > > >  		vi->sq[i].vq = vqs[txq2vq(i)];
> > > > +
> > > > +		if (vi->sq[i].vq->premapped)
> > > > +			virtnet_sq_init_dma_mate(&vi->sq[i]);
> > > >  	}
> > > >
> > > >  	/* run here: ret == 0. */
> > > > --
> > > > 2.32.0.3.g01195cf9f
> > >
>

