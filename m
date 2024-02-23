Return-Path: <kvm+bounces-9501-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id D741E860CCE
	for <lists+kvm@lfdr.de>; Fri, 23 Feb 2024 09:33:26 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 34E07B26B25
	for <lists+kvm@lfdr.de>; Fri, 23 Feb 2024 08:33:24 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 531894DA19;
	Fri, 23 Feb 2024 08:28:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b="kyZ1XRku"
X-Original-To: kvm@vger.kernel.org
Received: from out30-119.freemail.mail.aliyun.com (out30-119.freemail.mail.aliyun.com [115.124.30.119])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 40DB44CB23;
	Fri, 23 Feb 2024 08:28:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=115.124.30.119
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708676884; cv=none; b=ZZmI4F7O8brZWei2tIlIjm1UnESHRj34ANPRpIvAdndE0aP1KDZqHpsIduhk9FoxSTsJ4O3cTbKSB6X1rixZ9tgeAItre/GtxHmdNFKUJVNPvyofUVfOrxf335fZ4SKLO3Vuc6hRXnlHuEguvYRD6ofLJTNb0SL6hGwPB3J8cEA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708676884; c=relaxed/simple;
	bh=ebU0mf7uHLesU9rjth4gN2TUDxEGZDMelrjYPH5RKDQ=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=nWpSt6rUF850iJr3d7u+N2a2LhxQRb8eX4vzgZOsrDT+w/7ncXBYkJgcGsvKVWoTbEBmAnui9RgZkkjqXgOQ8XyjYJcFKwo6VXdOEj8+Bx0T+UqFaM0JsPBzBGcJUaVQ3GRgmWBVJQpaCF16sBDxjlYfp55rtKoaZBzDFPSlQ/8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com; spf=pass smtp.mailfrom=linux.alibaba.com; dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b=kyZ1XRku; arc=none smtp.client-ip=115.124.30.119
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.alibaba.com
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1708676879; h=From:To:Subject:Date:Message-Id:MIME-Version;
	bh=KkT5T/swMYJC+M1uG40XFtpIGk/ayvRaf2PNE7WpniY=;
	b=kyZ1XRkuy8du/QkOIJ+rldpZSedbXtCzkqDImk5q0c3p7XX2WY7xec7QoOqKaHQezftD6LEI/4u9YXSq5w8/eE0AVi4rjDAHJOuoy7bvT0PLh24bZQdfAsCzD644xHVxvB8t4GXT27IUEd5Rd0oMwcJlEb2a6ZAOaxmGwG/ahLc=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R121e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=ay29a033018046050;MF=xuanzhuo@linux.alibaba.com;NM=1;PH=DS;RN=35;SR=0;TI=SMTPD_---0W13ndSm_1708676876;
Received: from localhost(mailfrom:xuanzhuo@linux.alibaba.com fp:SMTPD_---0W13ndSm_1708676876)
          by smtp.aliyun-inc.com;
          Fri, 23 Feb 2024 16:27:56 +0800
From: Xuan Zhuo <xuanzhuo@linux.alibaba.com>
To: virtualization@lists.linux.dev
Cc: Richard Weinberger <richard@nod.at>,
	Anton Ivanov <anton.ivanov@cambridgegreys.com>,
	Johannes Berg <johannes@sipsolutions.net>,
	"Michael S. Tsirkin" <mst@redhat.com>,
	Jason Wang <jasowang@redhat.com>,
	Xuan Zhuo <xuanzhuo@linux.alibaba.com>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	Hans de Goede <hdegoede@redhat.com>,
	=?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>,
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
Subject: [PATCH vhost v2 19/19] virtio_net: sq support premapped mode
Date: Fri, 23 Feb 2024 16:27:26 +0800
Message-Id: <20240223082726.52915-20-xuanzhuo@linux.alibaba.com>
X-Mailer: git-send-email 2.32.0.3.g01195cf9f
In-Reply-To: <20240223082726.52915-1-xuanzhuo@linux.alibaba.com>
References: <20240223082726.52915-1-xuanzhuo@linux.alibaba.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Git-Hash: 510995f33855
Content-Transfer-Encoding: 8bit

If the xsk is enabling, the xsk tx will share the send queue.
But the xsk requires that the send queue use the premapped mode.
So the send queue must support premapped mode.

cmd:
    sh samples/pktgen/pktgen_sample01_simple.sh -i eth0 \
        -s 16 -d 10.0.0.128 -m 00:16:3e:2c:c8:2e -n 0 -p 100
CPU:
    Intel(R) Xeon(R) Platinum 8369B CPU @ 2.70GHz

Machine:
    ecs.g7.2xlarge(Aliyun)

before:              1600010.00
after(no-premapped): 1599966.00
after(premapped):    1600014.00

Signed-off-by: Xuan Zhuo <xuanzhuo@linux.alibaba.com>
---
 drivers/net/virtio_net.c | 136 +++++++++++++++++++++++++++++++++++++--
 1 file changed, 132 insertions(+), 4 deletions(-)

diff --git a/drivers/net/virtio_net.c b/drivers/net/virtio_net.c
index 7715bb7032ec..b83ef6afc4fb 100644
--- a/drivers/net/virtio_net.c
+++ b/drivers/net/virtio_net.c
@@ -146,6 +146,25 @@ struct virtnet_rq_dma {
 	u16 need_sync;
 };
 
+struct virtnet_sq_dma {
+	union {
+		struct virtnet_sq_dma *next;
+		void *data;
+	};
+
+	u32 num;
+
+	dma_addr_t addr[MAX_SKB_FRAGS + 2];
+	u32 len[MAX_SKB_FRAGS + 2];
+};
+
+struct virtnet_sq_dma_head {
+	/* record for kfree */
+	void *p;
+
+	struct virtnet_sq_dma *free;
+};
+
 /* Internal representation of a send virtqueue */
 struct send_queue {
 	/* Virtqueue associated with this send _queue */
@@ -165,6 +184,8 @@ struct send_queue {
 
 	/* Record whether sq is in reset state. */
 	bool reset;
+
+	struct virtnet_sq_dma_head dmainfo;
 };
 
 /* Internal representation of a receive virtqueue */
@@ -368,6 +389,95 @@ static struct xdp_frame *ptr_to_xdp(void *ptr)
 	return (struct xdp_frame *)((unsigned long)ptr & ~VIRTIO_XDP_FLAG);
 }
 
+static struct virtnet_sq_dma *virtnet_sq_unmap(struct send_queue *sq, void **data)
+{
+	struct virtnet_sq_dma *d;
+	int i;
+
+	d = *data;
+	*data = d->data;
+
+	for (i = 0; i < d->num; ++i)
+		virtqueue_dma_unmap_page_attrs(sq->vq, d->addr[i], d->len[i],
+					       DMA_TO_DEVICE, 0);
+
+	d->next = sq->dmainfo.free;
+	sq->dmainfo.free = d;
+
+	return d;
+}
+
+static struct virtnet_sq_dma *virtnet_sq_map_sg(struct send_queue *sq,
+						int nents, void *data)
+{
+	struct virtnet_sq_dma *d;
+	struct scatterlist *sg;
+	int i;
+
+	if (!sq->dmainfo.free)
+		return NULL;
+
+	d = sq->dmainfo.free;
+	sq->dmainfo.free = d->next;
+
+	for_each_sg(sq->sg, sg, nents, i) {
+		if (virtqueue_dma_map_sg_attrs(sq->vq, sg, DMA_TO_DEVICE, 0))
+			goto err;
+
+		d->addr[i] = sg->dma_address;
+		d->len[i] = sg->length;
+	}
+
+	d->data = data;
+	d->num = i;
+	return d;
+
+err:
+	d->num = i;
+	virtnet_sq_unmap(sq, (void **)&d);
+	return NULL;
+}
+
+static int virtnet_add_outbuf(struct send_queue *sq, u32 num, void *data)
+{
+	int ret;
+
+	if (sq->vq->premapped) {
+		data = virtnet_sq_map_sg(sq, num, data);
+		if (!data)
+			return -ENOMEM;
+	}
+
+	ret = virtqueue_add_outbuf(sq->vq, sq->sg, num, data, GFP_ATOMIC);
+	if (ret && sq->vq->premapped)
+		virtnet_sq_unmap(sq, &data);
+
+	return ret;
+}
+
+static int virtnet_sq_init_dma_mate(struct send_queue *sq)
+{
+	struct virtnet_sq_dma *d;
+	int num, i;
+
+	num = virtqueue_get_vring_size(sq->vq);
+
+	sq->dmainfo.free = kcalloc(num, sizeof(*sq->dmainfo.free), GFP_KERNEL);
+	if (!sq->dmainfo.free)
+		return -ENOMEM;
+
+	sq->dmainfo.p = sq->dmainfo.free;
+
+	for (i = 0; i < num; ++i) {
+		d = &sq->dmainfo.free[i];
+		d->next = d + 1;
+	}
+
+	d->next = NULL;
+
+	return 0;
+}
+
 static void __free_old_xmit(struct send_queue *sq, bool in_napi,
 			    struct virtnet_sq_free_stats *stats)
 {
@@ -377,6 +487,9 @@ static void __free_old_xmit(struct send_queue *sq, bool in_napi,
 	while ((ptr = virtqueue_get_buf(sq->vq, &len)) != NULL) {
 		++stats->packets;
 
+		if (sq->vq->premapped)
+			virtnet_sq_unmap(sq, &ptr);
+
 		if (!is_xdp_frame(ptr)) {
 			struct sk_buff *skb = ptr;
 
@@ -890,8 +1003,7 @@ static int __virtnet_xdp_xmit_one(struct virtnet_info *vi,
 			    skb_frag_size(frag), skb_frag_off(frag));
 	}
 
-	err = virtqueue_add_outbuf(sq->vq, sq->sg, nr_frags + 1,
-				   xdp_to_ptr(xdpf), GFP_ATOMIC);
+	err = virtnet_add_outbuf(sq, nr_frags + 1, xdp_to_ptr(xdpf));
 	if (unlikely(err))
 		return -ENOSPC; /* Caller handle free/refcnt */
 
@@ -2357,7 +2469,7 @@ static int xmit_skb(struct send_queue *sq, struct sk_buff *skb)
 			return num_sg;
 		num_sg++;
 	}
-	return virtqueue_add_outbuf(sq->vq, sq->sg, num_sg, skb, GFP_ATOMIC);
+	return virtnet_add_outbuf(sq, num_sg, skb);
 }
 
 static netdev_tx_t start_xmit(struct sk_buff *skb, struct net_device *dev)
@@ -4166,6 +4278,8 @@ static void virtnet_free_queues(struct virtnet_info *vi)
 	for (i = 0; i < vi->max_queue_pairs; i++) {
 		__netif_napi_del(&vi->rq[i].napi);
 		__netif_napi_del(&vi->sq[i].napi);
+
+		kfree(vi->sq[i].dmainfo.p);
 	}
 
 	/* We called __netif_napi_del(),
@@ -4214,6 +4328,15 @@ static void free_receive_page_frags(struct virtnet_info *vi)
 
 static void virtnet_sq_free_unused_buf(struct virtqueue *vq, void *buf)
 {
+	struct virtnet_info *vi = vq->vdev->priv;
+	struct send_queue *sq;
+	int i = vq2rxq(vq);
+
+	sq = &vi->sq[i];
+
+	if (sq->vq->premapped)
+		virtnet_sq_unmap(sq, &buf);
+
 	if (!is_xdp_frame(buf))
 		dev_kfree_skb(buf);
 	else
@@ -4327,8 +4450,10 @@ static int virtnet_find_vqs(struct virtnet_info *vi)
 		if (ctx)
 			ctx[rxq2vq(i)] = true;
 
-		if (premapped)
+		if (premapped) {
 			premapped[rxq2vq(i)] = true;
+			premapped[txq2vq(i)] = true;
+		}
 	}
 
 	cfg.nvqs      = total_vqs;
@@ -4352,6 +4477,9 @@ static int virtnet_find_vqs(struct virtnet_info *vi)
 		vi->rq[i].vq = vqs[rxq2vq(i)];
 		vi->rq[i].min_buf_len = mergeable_min_buf_len(vi, vi->rq[i].vq);
 		vi->sq[i].vq = vqs[txq2vq(i)];
+
+		if (vi->sq[i].vq->premapped)
+			virtnet_sq_init_dma_mate(&vi->sq[i]);
 	}
 
 	/* run here: ret == 0. */
-- 
2.32.0.3.g01195cf9f


