Return-Path: <kvm+bounces-9488-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 9D8F8860C74
	for <lists+kvm@lfdr.de>; Fri, 23 Feb 2024 09:29:27 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 2D47B1F26F73
	for <lists+kvm@lfdr.de>; Fri, 23 Feb 2024 08:29:27 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2146A2E629;
	Fri, 23 Feb 2024 08:27:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b="piHRdFnk"
X-Original-To: kvm@vger.kernel.org
Received: from out30-100.freemail.mail.aliyun.com (out30-100.freemail.mail.aliyun.com [115.124.30.100])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 16BC622611;
	Fri, 23 Feb 2024 08:27:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=115.124.30.100
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708676866; cv=none; b=H5NC7J9DxJFvmix8EjJZRIfW3rbNLwDjX2Oeck7S8ZZTUL8jq56SnOMvtsrug2sK3Cb/moJiZSfNi2thvgtfx4KPdEAWqRkoTSHE7axc8LUNbfoTc8wN9NgGqvT9XGdpTaSWikcnfLmWXrHNLgsT/SLG98Z9RKQCKbt4CH7uMQ8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708676866; c=relaxed/simple;
	bh=TRrAKbfwzzkdL2jPh1gz0R+f8MO1U3YSLR9p9bHBPmE=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=UHtzECvTizgHXursLX82a/b+i/eMiWvLESlAiwoPwJ5AHVYEuyIE7JqDZNe+GnqkdZGERiAfCwG/2DN+mwI6QQAlmVGxX+oYptLgVIZBUiX8e5i8Etk8QbwLjGPCM6te25gBheozH69o1hNGh+zN0LA8bGPEZq63jSIZw1txUBg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com; spf=pass smtp.mailfrom=linux.alibaba.com; dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b=piHRdFnk; arc=none smtp.client-ip=115.124.30.100
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.alibaba.com
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1708676855; h=From:To:Subject:Date:Message-Id:MIME-Version;
	bh=6IMo6cIkJbw27Q1oQFwPBSLp5dDwzhNSd1jF51DsYTA=;
	b=piHRdFnkq7sVQT1Z1PxWrVnWc//BKftKy9ikgMZa7AlwHMQIv1dh1uw3jXOykrcSuLa3F+/DM8jJUCH2bOlxfPumTymxf0GuX44kKOgbOzg/hRaGLshen6fEwbFTBaRD0nc/R1I2aOj69ftuPUHOm8tvY/Xrl1VUJG4yFnLuP+A=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R121e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=ay29a033018045176;MF=xuanzhuo@linux.alibaba.com;NM=1;PH=DS;RN=35;SR=0;TI=SMTPD_---0W13nF3Y_1708676853;
Received: from localhost(mailfrom:xuanzhuo@linux.alibaba.com fp:SMTPD_---0W13nF3Y_1708676853)
          by smtp.aliyun-inc.com;
          Fri, 23 Feb 2024 16:27:33 +0800
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
Subject: [PATCH vhost v2 04/19] virtio_ring: split: remove double check of the unmap ops
Date: Fri, 23 Feb 2024 16:27:11 +0800
Message-Id: <20240223082726.52915-5-xuanzhuo@linux.alibaba.com>
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

In the functions vring_unmap_one_split and
vring_unmap_one_split_indirect,
multiple checks are made whether unmap is performed and whether it is
INDIRECT.

These two functions are usually called in a loop, and we should put the
check outside the loop.

And we unmap the descs with VRING_DESC_F_INDIRECT on the same path with
other descs, that make the thing more complex. If we distinguish the
descs with VRING_DESC_F_INDIRECT before unmap, thing will be clearer.

1. only one desc of the desc table is used, we do not need the loop
2. the called unmap api is difference from the other desc
3. the vq->premapped is not needed to check
4. the vq->indirect is not needed to check
5. the state->indir_desc must not be null

Signed-off-by: Xuan Zhuo <xuanzhuo@linux.alibaba.com>
---
 drivers/virtio/virtio_ring.c | 79 +++++++++++++++++-------------------
 1 file changed, 38 insertions(+), 41 deletions(-)

diff --git a/drivers/virtio/virtio_ring.c b/drivers/virtio/virtio_ring.c
index 2d4d1417a1d6..194bd877ab5a 100644
--- a/drivers/virtio/virtio_ring.c
+++ b/drivers/virtio/virtio_ring.c
@@ -452,9 +452,6 @@ static void vring_unmap_one_split_indirect(const struct vring_virtqueue *vq,
 {
 	u16 flags;
 
-	if (!vring_need_unmap_buffer(vq))
-		return;
-
 	flags = virtio16_to_cpu(vq->vq.vdev, desc->flags);
 
 	dma_unmap_page(vring_dma_dev(vq),
@@ -472,27 +469,12 @@ static unsigned int vring_unmap_one_split(const struct vring_virtqueue *vq,
 
 	flags = extra[i].flags;
 
-	if (flags & VRING_DESC_F_INDIRECT) {
-		if (!vq->use_dma_api)
-			goto out;
-
-		dma_unmap_single(vring_dma_dev(vq),
-				 extra[i].addr,
-				 extra[i].len,
-				 (flags & VRING_DESC_F_WRITE) ?
-				 DMA_FROM_DEVICE : DMA_TO_DEVICE);
-	} else {
-		if (!vring_need_unmap_buffer(vq))
-			goto out;
-
-		dma_unmap_page(vring_dma_dev(vq),
-			       extra[i].addr,
-			       extra[i].len,
-			       (flags & VRING_DESC_F_WRITE) ?
-			       DMA_FROM_DEVICE : DMA_TO_DEVICE);
-	}
+	dma_unmap_page(vring_dma_dev(vq),
+		       extra[i].addr,
+		       extra[i].len,
+		       (flags & VRING_DESC_F_WRITE) ?
+		       DMA_FROM_DEVICE : DMA_TO_DEVICE);
 
-out:
 	return extra[i].next;
 }
 
@@ -660,7 +642,7 @@ static inline int virtqueue_add_split(struct virtqueue *_vq,
 			vq, desc, total_sg * sizeof(struct vring_desc),
 			DMA_TO_DEVICE);
 		if (vring_mapping_error(vq, addr)) {
-			if (vq->premapped)
+			if (!vring_need_unmap_buffer(vq))
 				goto free_indirect;
 
 			goto unmap_release;
@@ -713,6 +695,9 @@ static inline int virtqueue_add_split(struct virtqueue *_vq,
 	return 0;
 
 unmap_release:
+
+	WARN_ON(!vring_need_unmap_buffer(vq));
+
 	err_idx = i;
 
 	if (indirect)
@@ -774,34 +759,42 @@ static void detach_buf_split(struct vring_virtqueue *vq, unsigned int head,
 {
 	unsigned int i, j;
 	__virtio16 nextflag = cpu_to_virtio16(vq->vq.vdev, VRING_DESC_F_NEXT);
+	u16 flags;
 
 	/* Clear data ptr. */
 	vq->split.desc_state[head].data = NULL;
+	flags = vq->split.desc_extra[head].flags;
 
 	/* Put back on free list: unmap first-level descriptors and find end */
 	i = head;
 
-	while (vq->split.vring.desc[i].flags & nextflag) {
-		vring_unmap_one_split(vq, i);
-		i = vq->split.desc_extra[i].next;
-		vq->vq.num_free++;
-	}
-
-	vring_unmap_one_split(vq, i);
-	vq->split.desc_extra[i].next = vq->free_head;
-	vq->free_head = head;
+	if (!(flags & VRING_DESC_F_INDIRECT)) {
+		while (vq->split.vring.desc[i].flags & nextflag) {
+			if (vring_need_unmap_buffer(vq))
+				vring_unmap_one_split(vq, i);
+			i = vq->split.desc_extra[i].next;
+			vq->vq.num_free++;
+		}
 
-	/* Plus final descriptor */
-	vq->vq.num_free++;
+		if (vring_need_unmap_buffer(vq))
+			vring_unmap_one_split(vq, i);
 
-	if (vq->indirect) {
+		if (ctx)
+			*ctx = vq->split.desc_state[head].indir_desc;
+	} else {
 		struct vring_desc *indir_desc =
 				vq->split.desc_state[head].indir_desc;
 		u32 len;
 
-		/* Free the indirect table, if any, now that it's unmapped. */
-		if (!indir_desc)
-			return;
+		if (vq->use_dma_api) {
+			struct vring_desc_extra *extra = vq->split.desc_extra;
+
+			dma_unmap_single(vring_dma_dev(vq),
+					 extra[i].addr,
+					 extra[i].len,
+					 (flags & VRING_DESC_F_WRITE) ?
+					 DMA_FROM_DEVICE : DMA_TO_DEVICE);
+		}
 
 		len = vq->split.desc_extra[head].len;
 
@@ -816,9 +809,13 @@ static void detach_buf_split(struct vring_virtqueue *vq, unsigned int head,
 
 		kfree(indir_desc);
 		vq->split.desc_state[head].indir_desc = NULL;
-	} else if (ctx) {
-		*ctx = vq->split.desc_state[head].indir_desc;
 	}
+
+	vq->split.desc_extra[i].next = vq->free_head;
+	vq->free_head = head;
+
+	/* Plus final descriptor */
+	vq->vq.num_free++;
 }
 
 static bool more_used_split(const struct vring_virtqueue *vq)
-- 
2.32.0.3.g01195cf9f


