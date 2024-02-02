Return-Path: <kvm+bounces-7849-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 66B39846CD0
	for <lists+kvm@lfdr.de>; Fri,  2 Feb 2024 10:45:56 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 173D2283C08
	for <lists+kvm@lfdr.de>; Fri,  2 Feb 2024 09:45:55 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B7A587765D;
	Fri,  2 Feb 2024 09:40:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b="JpVgmPpE"
X-Original-To: kvm@vger.kernel.org
Received: from out30-118.freemail.mail.aliyun.com (out30-118.freemail.mail.aliyun.com [115.124.30.118])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 11EC081AC6;
	Fri,  2 Feb 2024 09:40:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=115.124.30.118
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706866829; cv=none; b=q5hSaSZj3Jom3sM7i8cB/3ObLXn1pb8cTYdabXGR1PSbRhwf9zyMfJne/H/4jLwXNy2uChb5bBrY1iG+i2gKGI7OkS0zED4+o8xOgxOpFK9RxVK4I8ghFUPnKacKta7hCniZnhkeysMuYxCXvZnMQRB+gnbgPd/ScACr69zJ0zg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706866829; c=relaxed/simple;
	bh=Vnn3QePFpL5bECmaIaKMt6pFWXXsWWCikFQjjD5z4yI=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=M2k6yZI0DLSCCVAydMmaf9aFGXCkklKeIfeHZRMLHb7sd7+m6tMhiNruHNQCsYPkJHAiWTCE2+Wq5opwrEXxOFZjDevS/CVEGzhK/dpwvs5b/NqYu+0Omn7m0WsvUJVH6mX8vDMawALdjDgduq4edcTf9udAtgb/8xErCmYYKWM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com; spf=pass smtp.mailfrom=linux.alibaba.com; dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b=JpVgmPpE; arc=none smtp.client-ip=115.124.30.118
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.alibaba.com
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1706866825; h=From:To:Subject:Date:Message-Id:MIME-Version;
	bh=tVlTdeEcGcalzCdG6nwmVXT49iPRM8whSzQr6PYMHDo=;
	b=JpVgmPpE7yeArgD4iigBN2LBG0pHS2EMh9pkbZC1wkBw416zH7rzrl7kR43+B/DRH6Ncq4yGfhyo1iGSaNURDr/2j8bdT2+IePH+u4ZOv+2Upk157bwzQLfyh7KkUYRoi00IfCLN9tTWDQSHxmRZ1bZpOHi6mY6nvP9vx0jAVqE=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R151e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=ay29a033018046051;MF=xuanzhuo@linux.alibaba.com;NM=1;PH=DS;RN=36;SR=0;TI=SMTPD_---0W.wgXJI_1706866822;
Received: from localhost(mailfrom:xuanzhuo@linux.alibaba.com fp:SMTPD_---0W.wgXJI_1706866822)
          by smtp.aliyun-inc.com;
          Fri, 02 Feb 2024 17:40:23 +0800
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
	Benjamin Berg <benjamin.berg@intel.com>,
	linux-um@lists.infradead.org,
	netdev@vger.kernel.org,
	platform-driver-x86@vger.kernel.org,
	linux-remoteproc@vger.kernel.org,
	linux-s390@vger.kernel.org,
	kvm@vger.kernel.org,
	bpf@vger.kernel.org
Subject: [PATCH vhost v1 19/19] virtio_net: sq support premapped mode
Date: Fri,  2 Feb 2024 17:39:51 +0800
Message-Id: <20240202093951.120283-20-xuanzhuo@linux.alibaba.com>
X-Mailer: git-send-email 2.32.0.3.g01195cf9f
In-Reply-To: <20240202093951.120283-1-xuanzhuo@linux.alibaba.com>
References: <20240202093951.120283-1-xuanzhuo@linux.alibaba.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Git-Hash: 4c7bacd05cb8
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
 drivers/net/virtio_net.c | 160 ++++++++++++++++++++++++++++++++++++++-
 1 file changed, 156 insertions(+), 4 deletions(-)

diff --git a/drivers/net/virtio_net.c b/drivers/net/virtio_net.c
index 226ab830870e..2b775a2ed045 100644
--- a/drivers/net/virtio_net.c
+++ b/drivers/net/virtio_net.c
@@ -46,6 +46,7 @@ module_param(napi_tx, bool, 0644);
 #define VIRTIO_XDP_REDIR	BIT(1)
 
 #define VIRTIO_XDP_FLAG	BIT(0)
+#define VIRTIO_DMA_FLAG	BIT(1)
 
 /* RX packet size EWMA. The average packet size is used to determine the packet
  * buffer size when refilling RX rings. As the entire RX ring may be refilled
@@ -140,6 +141,23 @@ struct virtnet_rq_dma {
 	u16 need_sync;
 };
 
+struct virtnet_sq_dma {
+	union {
+		struct virtnet_sq_dma *next;
+		void *data;
+	};
+	dma_addr_t addr;
+	u32 len;
+	bool is_tail;
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
@@ -159,6 +177,8 @@ struct send_queue {
 
 	/* Record whether sq is in reset state. */
 	bool reset;
+
+	struct virtnet_sq_dma_head dmainfo;
 };
 
 /* Internal representation of a receive virtqueue */
@@ -348,6 +368,122 @@ static struct xdp_frame *ptr_to_xdp(void *ptr)
 	return (struct xdp_frame *)((unsigned long)ptr & ~VIRTIO_XDP_FLAG);
 }
 
+static void *virtnet_sq_unmap(struct send_queue *sq, void *data)
+{
+	struct virtnet_sq_dma *head, *tail;
+
+	if (!((unsigned long)data & VIRTIO_DMA_FLAG))
+		return data;
+
+	head = (void *)((unsigned long)data & ~VIRTIO_DMA_FLAG);
+
+	tail = head;
+
+	while (true) {
+		virtqueue_dma_unmap_page_attrs(sq->vq, tail->addr, tail->len,
+					       DMA_TO_DEVICE, 0);
+		if (tail->is_tail)
+			break;
+
+		tail = tail->next;
+	}
+
+	data = tail->data;
+	tail->is_tail = false;
+
+	tail->next = sq->dmainfo.free;
+	sq->dmainfo.free = head;
+
+	return data;
+}
+
+static void *virtnet_sq_dma_splice(struct send_queue *sq,
+				   struct virtnet_sq_dma *head,
+				   struct virtnet_sq_dma *tail,
+				   void *data)
+{
+	sq->dmainfo.free = tail->next;
+
+	tail->is_tail = true;
+	tail->data = data;
+
+	head = (void *)((unsigned long)head | VIRTIO_DMA_FLAG);
+
+	return head;
+}
+
+static struct virtnet_sq_dma *virtnet_sq_map_sg(struct send_queue *sq, int nents, void *data)
+{
+	struct virtnet_sq_dma *head, *tail, *p;
+	struct scatterlist *sg;
+	int i;
+
+	head = sq->dmainfo.free;
+	p = head;
+
+	tail = NULL;
+
+	for_each_sg(sq->sg, sg, nents, i) {
+		if (virtqueue_dma_map_sg_attrs(sq->vq, sg, DMA_TO_DEVICE, 0))
+			goto err;
+
+		tail = p;
+		tail->addr = sg->dma_address;
+		tail->len = sg->length;
+
+		p = p->next;
+	}
+
+	return virtnet_sq_dma_splice(sq, head, tail, data);
+
+err:
+	if (tail)
+		virtnet_sq_unmap(sq, virtnet_sq_dma_splice(sq, head, tail, data));
+
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
+		virtnet_sq_unmap(sq, data);
+
+	return ret;
+}
+
+static int virtnet_sq_init_dma_mate(struct send_queue *sq)
+{
+	struct virtnet_sq_dma *d;
+	int num, i;
+
+	num = (virtqueue_get_vring_size(sq->vq) + 1) * ARRAY_SIZE(sq->sg);
+
+	sq->dmainfo.free = kcalloc(num, sizeof(*sq->dmainfo.free), GFP_KERNEL);
+	if (!sq->dmainfo.free)
+		return -ENOMEM;
+
+	sq->dmainfo.p = sq->dmainfo.free;
+
+	for (i = 0; i < num; ++i) {
+		d = &sq->dmainfo.free[i];
+		d->is_tail = false;
+		d->next = d + 1;
+	}
+
+	d->next = NULL;
+
+	return 0;
+}
+
 static void __free_old_xmit(struct send_queue *sq, bool in_napi,
 			    u64 *bytes, u64 *packets)
 {
@@ -355,6 +491,8 @@ static void __free_old_xmit(struct send_queue *sq, bool in_napi,
 	void *ptr;
 
 	while ((ptr = virtqueue_get_buf(sq->vq, &len)) != NULL) {
+		ptr = virtnet_sq_unmap(sq, ptr);
+
 		if (!is_xdp_frame(ptr)) {
 			struct sk_buff *skb = ptr;
 
@@ -865,8 +1003,7 @@ static int __virtnet_xdp_xmit_one(struct virtnet_info *vi,
 			    skb_frag_size(frag), skb_frag_off(frag));
 	}
 
-	err = virtqueue_add_outbuf(sq->vq, sq->sg, nr_frags + 1,
-				   xdp_to_ptr(xdpf), GFP_ATOMIC);
+	err = virtnet_add_outbuf(sq, nr_frags + 1, xdp_to_ptr(xdpf));
 	if (unlikely(err))
 		return -ENOSPC; /* Caller handle free/refcnt */
 
@@ -2305,7 +2442,7 @@ static int xmit_skb(struct send_queue *sq, struct sk_buff *skb)
 			return num_sg;
 		num_sg++;
 	}
-	return virtqueue_add_outbuf(sq->vq, sq->sg, num_sg, skb, GFP_ATOMIC);
+	return virtnet_add_outbuf(sq, num_sg, skb);
 }
 
 static netdev_tx_t start_xmit(struct sk_buff *skb, struct net_device *dev)
@@ -3961,6 +4098,8 @@ static void virtnet_free_queues(struct virtnet_info *vi)
 	for (i = 0; i < vi->max_queue_pairs; i++) {
 		__netif_napi_del(&vi->rq[i].napi);
 		__netif_napi_del(&vi->sq[i].napi);
+
+		kfree(vi->sq[i].dmainfo.p);
 	}
 
 	/* We called __netif_napi_del(),
@@ -4009,6 +4148,14 @@ static void free_receive_page_frags(struct virtnet_info *vi)
 
 static void virtnet_sq_free_unused_buf(struct virtqueue *vq, void *buf)
 {
+	struct virtnet_info *vi = vq->vdev->priv;
+	struct send_queue *sq;
+	int i = vq2rxq(vq);
+
+	sq = &vi->sq[i];
+
+	buf = virtnet_sq_unmap(sq, buf);
+
 	if (!is_xdp_frame(buf))
 		dev_kfree_skb(buf);
 	else
@@ -4121,8 +4268,10 @@ static int virtnet_find_vqs(struct virtnet_info *vi)
 		if (ctx)
 			ctx[rxq2vq(i)] = true;
 
-		if (premapped)
+		if (premapped) {
 			premapped[rxq2vq(i)] = true;
+			premapped[txq2vq(i)] = true;
+		}
 	}
 
 	cfg.nvqs      = total_vqs;
@@ -4146,6 +4295,9 @@ static int virtnet_find_vqs(struct virtnet_info *vi)
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


