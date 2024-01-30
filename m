Return-Path: <kvm+bounces-7419-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 93966841A1D
	for <lists+kvm@lfdr.de>; Tue, 30 Jan 2024 04:09:24 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 4982428A83A
	for <lists+kvm@lfdr.de>; Tue, 30 Jan 2024 03:09:23 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EAB46374EC;
	Tue, 30 Jan 2024 03:06:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b="Ywvb1IEe"
X-Original-To: kvm@vger.kernel.org
Received: from out30-132.freemail.mail.aliyun.com (out30-132.freemail.mail.aliyun.com [115.124.30.132])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1B62D53E0A;
	Tue, 30 Jan 2024 03:06:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=115.124.30.132
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706583990; cv=none; b=bho1bBRYGzQ3Tsr4qaDbzf2sqMTrWyb+ERZj2Wo5k70neoXe/plLVpnoaj6Sc/5wCDCd6gLGA7dIRlkCpOoa7l3+U50bslDPCNp1znXiF6CdRe+IexY68VTtyLYPnWwe8E4ny017mV/5cvIkO0lhdHcrUaTv+dusJjcin9GX0Kk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706583990; c=relaxed/simple;
	bh=tmhjzYNCYCrDHond5B6w87b0fu++aBkzE0b6FJjDiXU=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=qqVjdl395s50RYXR90dyYGWc9zWYzLXXuhJxpKx///xRh1yIFoPk6ppKFvFgWXWcN/h2STPzHV4KVjo1ggxOVm2KoLl5+V1X2DRYgup1Vf7icpBE8DfJjCm4HQt8is/yvArJi4TUhX1TV0cKVGpXz82G3b/WE3LhAt9l9aKfDKQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com; spf=pass smtp.mailfrom=linux.alibaba.com; dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b=Ywvb1IEe; arc=none smtp.client-ip=115.124.30.132
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.alibaba.com
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1706583985; h=From:To:Subject:Date:Message-Id:MIME-Version;
	bh=NS9ceng5ziq2Yn2+9KrlE+PH2QFHreCvTPLpx0wusIg=;
	b=Ywvb1IEeUVL4yr5O0hJN7sb5UHSdq/MiFNL1QHJ4RLquvlb1XTTsnRMFOQ+ypuruNxCw7TzS6G7FWEwyWRiyhqiZNwOOSQHc7rSANCFsY+E6ID1i9MiWobGA6Uu64NzAYyEvG9OcRGrITF1BFZTNfizElou3JEYQri9FIW/gn/Q=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R171e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=ay29a033018046059;MF=xuanzhuo@linux.alibaba.com;NM=1;PH=DS;RN=37;SR=0;TI=SMTPD_---0W.eaYxi_1706583981;
Received: from localhost(mailfrom:xuanzhuo@linux.alibaba.com fp:SMTPD_---0W.eaYxi_1706583981)
          by smtp.aliyun-inc.com;
          Tue, 30 Jan 2024 11:06:22 +0800
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
	Yang Li <yang.lee@linux.alibaba.com>,
	linux-um@lists.infradead.org,
	netdev@vger.kernel.org,
	platform-driver-x86@vger.kernel.org,
	linux-remoteproc@vger.kernel.org,
	linux-s390@vger.kernel.org,
	kvm@vger.kernel.org,
	bpf@vger.kernel.org
Subject: [PATCH 10/14] virtio_net: set premapped mode by find_vqs()
Date: Tue, 30 Jan 2024 11:06:00 +0800
Message-Id: <20240130030604.108463-11-xuanzhuo@linux.alibaba.com>
X-Mailer: git-send-email 2.32.0.3.g01195cf9f
In-Reply-To: <20240130030604.108463-1-xuanzhuo@linux.alibaba.com>
References: <20240130030604.108463-1-xuanzhuo@linux.alibaba.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Git-Hash: ce068f9b825d
Content-Transfer-Encoding: 8bit

Now, the virtio core can set the premapped mode by find_vqs().
If the premapped can be enabled, the dma array will not be
allocated. So virtio-net use the api of find_vqs to enable the
premapped.

Judge the premapped mode by the vq->premapped instead of saving
local variable.

Signed-off-by: Xuan Zhuo <xuanzhuo@linux.alibaba.com>
---
 drivers/net/virtio_net.c      | 50 ++++++++++++++---------------------
 include/linux/virtio_config.h | 10 +++----
 2 files changed, 25 insertions(+), 35 deletions(-)

diff --git a/drivers/net/virtio_net.c b/drivers/net/virtio_net.c
index 51b1868d2f22..660459b4c3e3 100644
--- a/drivers/net/virtio_net.c
+++ b/drivers/net/virtio_net.c
@@ -196,9 +196,6 @@ struct receive_queue {
 
 	/* Record the last dma info to free after new pages is allocated. */
 	struct virtnet_rq_dma *last_dma;
-
-	/* Do dma by self */
-	bool do_dma;
 };
 
 /* This structure can contain rss message with maximum settings for indirection table and keysize
@@ -638,7 +635,7 @@ static void *virtnet_rq_get_buf(struct receive_queue *rq, u32 *len, void **ctx)
 	void *buf;
 
 	buf = virtqueue_get_buf_ctx(rq->vq, len, ctx);
-	if (buf && rq->do_dma)
+	if (buf && rq->vq->premapped)
 		virtnet_rq_unmap(rq, buf, *len);
 
 	return buf;
@@ -651,7 +648,7 @@ static void virtnet_rq_init_one_sg(struct receive_queue *rq, void *buf, u32 len)
 	u32 offset;
 	void *head;
 
-	if (!rq->do_dma) {
+	if (!rq->vq->premapped) {
 		sg_init_one(rq->sg, buf, len);
 		return;
 	}
@@ -681,7 +678,7 @@ static void *virtnet_rq_alloc(struct receive_queue *rq, u32 size, gfp_t gfp)
 
 	head = page_address(alloc_frag->page);
 
-	if (rq->do_dma) {
+	if (rq->vq->premapped) {
 		dma = head;
 
 		/* new pages */
@@ -727,22 +724,6 @@ static void *virtnet_rq_alloc(struct receive_queue *rq, u32 size, gfp_t gfp)
 	return buf;
 }
 
-static void virtnet_rq_set_premapped(struct virtnet_info *vi)
-{
-	int i;
-
-	/* disable for big mode */
-	if (!vi->mergeable_rx_bufs && vi->big_packets)
-		return;
-
-	for (i = 0; i < vi->max_queue_pairs; i++) {
-		if (virtqueue_set_dma_premapped(vi->rq[i].vq))
-			continue;
-
-		vi->rq[i].do_dma = true;
-	}
-}
-
 static void virtnet_rq_unmap_free_buf(struct virtqueue *vq, void *buf)
 {
 	struct virtnet_info *vi = vq->vdev->priv;
@@ -751,7 +732,7 @@ static void virtnet_rq_unmap_free_buf(struct virtqueue *vq, void *buf)
 
 	rq = &vi->rq[i];
 
-	if (rq->do_dma)
+	if (rq->vq->premapped)
 		virtnet_rq_unmap(rq, buf, 0);
 
 	virtnet_rq_free_buf(vi, rq, buf);
@@ -1846,7 +1827,7 @@ static int add_recvbuf_small(struct virtnet_info *vi, struct receive_queue *rq,
 
 	err = virtqueue_add_inbuf_ctx(rq->vq, rq->sg, 1, buf, ctx, gfp);
 	if (err < 0) {
-		if (rq->do_dma)
+		if (rq->vq->premapped)
 			virtnet_rq_unmap(rq, buf, 0);
 		put_page(virt_to_head_page(buf));
 	}
@@ -1961,7 +1942,7 @@ static int add_recvbuf_mergeable(struct virtnet_info *vi,
 	ctx = mergeable_len_to_ctx(len + room, headroom);
 	err = virtqueue_add_inbuf_ctx(rq->vq, rq->sg, 1, buf, ctx, gfp);
 	if (err < 0) {
-		if (rq->do_dma)
+		if (rq->vq->premapped)
 			virtnet_rq_unmap(rq, buf, 0);
 		put_page(virt_to_head_page(buf));
 	}
@@ -4030,7 +4011,7 @@ static void free_receive_page_frags(struct virtnet_info *vi)
 	int i;
 	for (i = 0; i < vi->max_queue_pairs; i++)
 		if (vi->rq[i].alloc_frag.page) {
-			if (vi->rq[i].do_dma && vi->rq[i].last_dma)
+			if (vi->rq[i].vq->premapped && vi->rq[i].last_dma)
 				virtnet_rq_unmap(&vi->rq[i], vi->rq[i].last_dma, 0);
 			put_page(vi->rq[i].alloc_frag.page);
 		}
@@ -4099,6 +4080,7 @@ static int virtnet_find_vqs(struct virtnet_info *vi)
 	int ret = -ENOMEM;
 	int i, total_vqs;
 	const char **names;
+	bool *premapped;
 	bool *ctx;
 
 	/* We expect 1 RX virtqueue followed by 1 TX virtqueue, followed by
@@ -4122,8 +4104,13 @@ static int virtnet_find_vqs(struct virtnet_info *vi)
 		ctx = kcalloc(total_vqs, sizeof(*ctx), GFP_KERNEL);
 		if (!ctx)
 			goto err_ctx;
+
+		premapped = kcalloc(total_vqs, sizeof(*ctx), GFP_KERNEL);
+		if (!ctx)
+			goto err_premapped;
 	} else {
 		ctx = NULL;
+		premapped = NULL;
 	}
 
 	/* Parameters for control virtqueue, if any */
@@ -4142,10 +4129,13 @@ static int virtnet_find_vqs(struct virtnet_info *vi)
 		names[txq2vq(i)] = vi->sq[i].name;
 		if (ctx)
 			ctx[rxq2vq(i)] = true;
+
+		if (premapped)
+			premapped[rxq2vq(i)] = true;
 	}
 
-	ret = virtio_find_vqs_ctx(vi->vdev, total_vqs, vqs, callbacks,
-				  names, ctx, NULL);
+	ret = virtio_find_vqs_ctx_premapped(vi->vdev, total_vqs, vqs, callbacks,
+					    names, ctx, premapped, NULL);
 	if (ret)
 		goto err_find;
 
@@ -4165,6 +4155,8 @@ static int virtnet_find_vqs(struct virtnet_info *vi)
 
 
 err_find:
+	kfree(premapped);
+err_premapped:
 	kfree(ctx);
 err_ctx:
 	kfree(names);
@@ -4234,8 +4226,6 @@ static int init_vqs(struct virtnet_info *vi)
 	if (ret)
 		goto err_free;
 
-	virtnet_rq_set_premapped(vi);
-
 	cpus_read_lock();
 	virtnet_set_affinity(vi);
 	cpus_read_unlock();
diff --git a/include/linux/virtio_config.h b/include/linux/virtio_config.h
index 45b5a980561e..908e68a48c99 100644
--- a/include/linux/virtio_config.h
+++ b/include/linux/virtio_config.h
@@ -235,13 +235,13 @@ int virtio_find_vqs(struct virtio_device *vdev, unsigned nvqs,
 }
 
 static inline
-int virtio_find_vqs_ctx(struct virtio_device *vdev, unsigned nvqs,
-			struct virtqueue *vqs[], vq_callback_t *callbacks[],
-			const char * const names[], const bool *ctx,
-			struct irq_affinity *desc)
+int virtio_find_vqs_ctx_premapped(struct virtio_device *vdev, unsigned int nvqs,
+				  struct virtqueue *vqs[], vq_callback_t *callbacks[],
+				  const char * const names[], const bool *ctx,
+				  const bool *premapped, struct irq_affinity *desc)
 {
 	return vdev->config->find_vqs(vdev, nvqs, vqs, callbacks, names, ctx,
-				      NULL, desc);
+				      premapped, desc);
 }
 
 /**
-- 
2.32.0.3.g01195cf9f


