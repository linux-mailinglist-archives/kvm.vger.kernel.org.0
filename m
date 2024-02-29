Return-Path: <kvm+bounces-10447-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id BADB286C232
	for <lists+kvm@lfdr.de>; Thu, 29 Feb 2024 08:24:42 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 344F41F2125D
	for <lists+kvm@lfdr.de>; Thu, 29 Feb 2024 07:24:42 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 217F055E46;
	Thu, 29 Feb 2024 07:21:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b="rvTwESTo"
X-Original-To: kvm@vger.kernel.org
Received: from out30-101.freemail.mail.aliyun.com (out30-101.freemail.mail.aliyun.com [115.124.30.101])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4CCEF44C9D;
	Thu, 29 Feb 2024 07:21:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=115.124.30.101
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709191273; cv=none; b=ee5HOIRd1KWUmcVnfn4CdOKuZGLAIQrCNdIPphkNrs4oafaGFah+rGFMZqvgvLq6MUY+i7yZe+vGnw/o12+eGTYezzmEnC4qO0D3W6ZpwwgHo8ZGQcx89INaXeMJ1vOeHq9KhgyKKksMK1ORzt0I07N/JO9fYNNSVIOrZNyD4SQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709191273; c=relaxed/simple;
	bh=MUO8U5SVj3P1Xil/ahjJ/yQETxekSikLccDlysDuyiA=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=c55UHZZswz9+h30b7mmf7yZnc0jR6lVx0JgtZry22IUGW9rkpUdsaLA1fxRr5+GN98r07Z4MkXNLi83+gh8F2sCgQmkjurI8auoq3rJjlq3qgTpwBQszAeKh4Y4F23SDO0FJ1Q2hEXc9IhDQNcNqBGQf2qUPuGLP/+Cxws+4lxo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com; spf=pass smtp.mailfrom=linux.alibaba.com; dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b=rvTwESTo; arc=none smtp.client-ip=115.124.30.101
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.alibaba.com
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1709191268; h=From:To:Subject:Date:Message-Id:MIME-Version;
	bh=IRSlxqMw0yhAkJ08APM/0uZy3bVrhWlhvpCjnaXaq8Y=;
	b=rvTwESToXUsNOmX9s/U6z8RNjNMRR2oQCnaaqA54V2u5YvgdbqtGm0LXxgevIzsqX+fai7Npdpv+/WmeDwvGLUZlw4cBX3MqAyj9wHqgx3XjSWdNfuaqE0rYH+4CUZjrTcqgUY5UcKZx9Sss7UtfHmdqU94rTqk0jqsjcSCLdxY=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R441e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=ay29a033018046060;MF=xuanzhuo@linux.alibaba.com;NM=1;PH=DS;RN=35;SR=0;TI=SMTPD_---0W1SD3j6_1709191266;
Received: from localhost(mailfrom:xuanzhuo@linux.alibaba.com fp:SMTPD_---0W1SD3j6_1709191266)
          by smtp.aliyun-inc.com;
          Thu, 29 Feb 2024 15:21:06 +0800
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
Subject: [PATCH vhost v3 13/19] virtio_net: set premapped mode by find_vqs()
Date: Thu, 29 Feb 2024 15:20:38 +0800
Message-Id: <20240229072044.77388-14-xuanzhuo@linux.alibaba.com>
X-Mailer: git-send-email 2.32.0.3.g01195cf9f
In-Reply-To: <20240229072044.77388-1-xuanzhuo@linux.alibaba.com>
References: <20240229072044.77388-1-xuanzhuo@linux.alibaba.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Git-Hash: e3a3e51d6b70
Content-Transfer-Encoding: 8bit

Now, the virtio core can set the premapped mode by find_vqs().
If the premapped can be enabled, the dma array will not be
allocated. So virtio-net use the api of find_vqs to enable the
premapped.

Judge the premapped mode by the vq->premapped instead of saving
local variable.

Signed-off-by: Xuan Zhuo <xuanzhuo@linux.alibaba.com>
---
 drivers/net/virtio_net.c      | 57 +++++++++++++++++------------------
 include/linux/virtio_config.h | 16 ++--------
 2 files changed, 29 insertions(+), 44 deletions(-)

diff --git a/drivers/net/virtio_net.c b/drivers/net/virtio_net.c
index d7ce4a1011ea..140b2c155650 100644
--- a/drivers/net/virtio_net.c
+++ b/drivers/net/virtio_net.c
@@ -208,9 +208,6 @@ struct receive_queue {
 
 	/* Record the last dma info to free after new pages is allocated. */
 	struct virtnet_rq_dma *last_dma;
-
-	/* Do dma by self */
-	bool do_dma;
 };
 
 /* This structure can contain rss message with maximum settings for indirection table and keysize
@@ -657,7 +654,7 @@ static void *virtnet_rq_get_buf(struct receive_queue *rq, u32 *len, void **ctx)
 	void *buf;
 
 	buf = virtqueue_get_buf_ctx(rq->vq, len, ctx);
-	if (buf && rq->do_dma)
+	if (buf && rq->vq->premapped)
 		virtnet_rq_unmap(rq, buf, *len);
 
 	return buf;
@@ -670,7 +667,7 @@ static void virtnet_rq_init_one_sg(struct receive_queue *rq, void *buf, u32 len)
 	u32 offset;
 	void *head;
 
-	if (!rq->do_dma) {
+	if (!rq->vq->premapped) {
 		sg_init_one(rq->sg, buf, len);
 		return;
 	}
@@ -700,7 +697,7 @@ static void *virtnet_rq_alloc(struct receive_queue *rq, u32 size, gfp_t gfp)
 
 	head = page_address(alloc_frag->page);
 
-	if (rq->do_dma) {
+	if (rq->vq->premapped) {
 		dma = head;
 
 		/* new pages */
@@ -746,22 +743,6 @@ static void *virtnet_rq_alloc(struct receive_queue *rq, u32 size, gfp_t gfp)
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
@@ -770,7 +751,7 @@ static void virtnet_rq_unmap_free_buf(struct virtqueue *vq, void *buf)
 
 	rq = &vi->rq[i];
 
-	if (rq->do_dma)
+	if (rq->vq->premapped)
 		virtnet_rq_unmap(rq, buf, 0);
 
 	virtnet_rq_free_buf(vi, rq, buf);
@@ -1865,7 +1846,7 @@ static int add_recvbuf_small(struct virtnet_info *vi, struct receive_queue *rq,
 
 	err = virtqueue_add_inbuf_ctx(rq->vq, rq->sg, 1, buf, ctx, gfp);
 	if (err < 0) {
-		if (rq->do_dma)
+		if (rq->vq->premapped)
 			virtnet_rq_unmap(rq, buf, 0);
 		put_page(virt_to_head_page(buf));
 	}
@@ -1980,7 +1961,7 @@ static int add_recvbuf_mergeable(struct virtnet_info *vi,
 	ctx = mergeable_len_to_ctx(len + room, headroom);
 	err = virtqueue_add_inbuf_ctx(rq->vq, rq->sg, 1, buf, ctx, gfp);
 	if (err < 0) {
-		if (rq->do_dma)
+		if (rq->vq->premapped)
 			virtnet_rq_unmap(rq, buf, 0);
 		put_page(virt_to_head_page(buf));
 	}
@@ -4229,7 +4210,7 @@ static void free_receive_page_frags(struct virtnet_info *vi)
 	int i;
 	for (i = 0; i < vi->max_queue_pairs; i++)
 		if (vi->rq[i].alloc_frag.page) {
-			if (vi->rq[i].do_dma && vi->rq[i].last_dma)
+			if (vi->rq[i].vq->premapped && vi->rq[i].last_dma)
 				virtnet_rq_unmap(&vi->rq[i], vi->rq[i].last_dma, 0);
 			put_page(vi->rq[i].alloc_frag.page);
 		}
@@ -4293,11 +4274,13 @@ static unsigned int mergeable_min_buf_len(struct virtnet_info *vi, struct virtqu
 
 static int virtnet_find_vqs(struct virtnet_info *vi)
 {
+	struct virtio_vq_config cfg = {};
 	vq_callback_t **callbacks;
 	struct virtqueue **vqs;
 	const char **names;
 	int ret = -ENOMEM;
 	int total_vqs;
+	bool *premapped;
 	bool *ctx;
 	u16 i;
 
@@ -4322,8 +4305,13 @@ static int virtnet_find_vqs(struct virtnet_info *vi)
 		ctx = kcalloc(total_vqs, sizeof(*ctx), GFP_KERNEL);
 		if (!ctx)
 			goto err_ctx;
+
+		premapped = kcalloc(total_vqs, sizeof(*premapped), GFP_KERNEL);
+		if (!ctx)
+			goto err_premapped;
 	} else {
 		ctx = NULL;
+		premapped = NULL;
 	}
 
 	/* Parameters for control virtqueue, if any */
@@ -4342,10 +4330,19 @@ static int virtnet_find_vqs(struct virtnet_info *vi)
 		names[txq2vq(i)] = vi->sq[i].name;
 		if (ctx)
 			ctx[rxq2vq(i)] = true;
+
+		if (premapped)
+			premapped[rxq2vq(i)] = true;
 	}
 
-	ret = virtio_find_vqs_ctx(vi->vdev, total_vqs, vqs, callbacks,
-				  names, ctx, NULL);
+	cfg.nvqs      = total_vqs;
+	cfg.vqs       = vqs;
+	cfg.callbacks = callbacks;
+	cfg.names     = names;
+	cfg.ctx       = ctx;
+	cfg.premapped = premapped;
+
+	ret = virtio_find_vqs_cfg(vi->vdev, &cfg);
 	if (ret)
 		goto err_find;
 
@@ -4365,6 +4362,8 @@ static int virtnet_find_vqs(struct virtnet_info *vi)
 
 
 err_find:
+	kfree(premapped);
+err_premapped:
 	kfree(ctx);
 err_ctx:
 	kfree(names);
@@ -4437,8 +4436,6 @@ static int init_vqs(struct virtnet_info *vi)
 	if (ret)
 		goto err_free;
 
-	virtnet_rq_set_premapped(vi);
-
 	cpus_read_lock();
 	virtnet_set_affinity(vi);
 	cpus_read_unlock();
diff --git a/include/linux/virtio_config.h b/include/linux/virtio_config.h
index f1f62e57f395..e40509fef5fe 100644
--- a/include/linux/virtio_config.h
+++ b/include/linux/virtio_config.h
@@ -260,21 +260,9 @@ int virtio_find_vqs(struct virtio_device *vdev, unsigned nvqs,
 }
 
 static inline
-int virtio_find_vqs_ctx(struct virtio_device *vdev, unsigned nvqs,
-			struct virtqueue *vqs[], vq_callback_t *callbacks[],
-			const char * const names[], const bool *ctx,
-			struct irq_affinity *desc)
+int virtio_find_vqs_cfg(struct virtio_device *vdev, struct virtio_vq_config *cfg)
 {
-	struct virtio_vq_config cfg = {};
-
-	cfg.nvqs = nvqs;
-	cfg.vqs = vqs;
-	cfg.callbacks = callbacks;
-	cfg.names = (const char **)names;
-	cfg.ctx = ctx;
-	cfg.desc = desc;
-
-	return vdev->config->find_vqs(vdev, &cfg);
+	return vdev->config->find_vqs(vdev, cfg);
 }
 
 /**
-- 
2.32.0.3.g01195cf9f


