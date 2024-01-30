Return-Path: <kvm+bounces-7417-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id C7D2A841A0F
	for <lists+kvm@lfdr.de>; Tue, 30 Jan 2024 04:08:47 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 33521B2698E
	for <lists+kvm@lfdr.de>; Tue, 30 Jan 2024 03:08:45 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1B095374CC;
	Tue, 30 Jan 2024 03:06:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b="Hj3koiwO"
X-Original-To: kvm@vger.kernel.org
Received: from out30-119.freemail.mail.aliyun.com (out30-119.freemail.mail.aliyun.com [115.124.30.119])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5EBAB433CD;
	Tue, 30 Jan 2024 03:06:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=115.124.30.119
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706583986; cv=none; b=AuHjMmzMVn4IJpXtPH03VtgueAp2SbhVzD6r0Xe/eFyBQbt/1winGvh/z8cZ3Mx8NPN6lzcD83CpNEyQRkVIiaFHz/9BTpXRWUVFksN/WnacuEhU/NH6wbi7Nm0FqDICbaYGSrxCHpL1GeSpyqYuaKZdFaFNeHdYSVqyFuY6yAE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706583986; c=relaxed/simple;
	bh=6G571sJ4EdFAIcFL28AlPWeFbDahxvOWW2JSK/6QgjY=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=T8dvanm5keMBV7+E0/TQggsub142PZSREvWC0DrXNtfJs/8GIv0rw52WUXG7+6PVkseubqpjv/Lx/JkPTQuIbHWSMxZlx4jZ66zJdAclA4sZcCNjF2ZJJ4eYkUv3vA5Qkqb7mxxepndbIKbI4P0Hz7/b8poDmsgCDHLymsovmtk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com; spf=pass smtp.mailfrom=linux.alibaba.com; dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b=Hj3koiwO; arc=none smtp.client-ip=115.124.30.119
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.alibaba.com
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1706583976; h=From:To:Subject:Date:Message-Id:MIME-Version;
	bh=z3UTRsbRsFcB2sqFN3XBDD7wrtKUw8K4tiUA1HwO3kw=;
	b=Hj3koiwO8iHFD0m5xzlwE8GYQFDHQ7bEldOE+q+irZoGNWNogbFo2TuLzeUjnw3RP4s/DfpX7pTWViwkGGjj1IFAqty2RB1GQ3CsMxnb4+Tsles431kGW2FRau1fysa7GilH6fLkWLpeYIRj3lAUg/kMgrU5jziQQybIwPpalRU=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R101e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=ay29a033018046050;MF=xuanzhuo@linux.alibaba.com;NM=1;PH=DS;RN=37;SR=0;TI=SMTPD_---0W.eeCAv_1706583973;
Received: from localhost(mailfrom:xuanzhuo@linux.alibaba.com fp:SMTPD_---0W.eeCAv_1706583973)
          by smtp.aliyun-inc.com;
          Tue, 30 Jan 2024 11:06:14 +0800
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
Subject: [PATCH 05/14] virtio_ring: split: structure the indirect desc table
Date: Tue, 30 Jan 2024 11:05:55 +0800
Message-Id: <20240130030604.108463-6-xuanzhuo@linux.alibaba.com>
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

This commit structure the indirect desc table.
Then we can get the desc num directly when doing unmap.

And save the dma info to the struct, then the indirect
will not use the dma fields of the desc_extra. The subsequent
commits will make the dma fields are optional. But for
the indirect case, we must record the dma info.

Signed-off-by: Xuan Zhuo <xuanzhuo@linux.alibaba.com>
---
 drivers/virtio/virtio_ring.c | 86 ++++++++++++++++++++++--------------
 1 file changed, 52 insertions(+), 34 deletions(-)

diff --git a/drivers/virtio/virtio_ring.c b/drivers/virtio/virtio_ring.c
index 2b41fdbce975..831667a57429 100644
--- a/drivers/virtio/virtio_ring.c
+++ b/drivers/virtio/virtio_ring.c
@@ -67,9 +67,16 @@
 #define LAST_ADD_TIME_INVALID(vq)
 #endif
 
+struct vring_split_desc_indir {
+	dma_addr_t addr;		/* Descriptor Array DMA addr. */
+	u32 len;			/* Descriptor Array length. */
+	u32 num;
+	struct vring_desc desc[];
+};
+
 struct vring_desc_state_split {
 	void *data;			/* Data for callback. */
-	struct vring_desc *indir_desc;	/* Indirect descriptor, if any. */
+	struct vring_split_desc_indir *indir_desc;	/* Indirect descriptor, if any. */
 };
 
 struct vring_packed_desc_indir {
@@ -478,12 +485,16 @@ static unsigned int vring_unmap_one_split(const struct vring_virtqueue *vq,
 	return extra[i].next;
 }
 
-static struct vring_desc *alloc_indirect_split(struct virtqueue *_vq,
-					       unsigned int total_sg,
-					       gfp_t gfp)
+static struct vring_split_desc_indir *alloc_indirect_split(struct virtqueue *_vq,
+							   unsigned int total_sg,
+							   gfp_t gfp)
 {
+	struct vring_split_desc_indir *in_desc;
 	struct vring_desc *desc;
 	unsigned int i;
+	u32 size;
+
+	size = struct_size(in_desc, desc, total_sg);
 
 	/*
 	 * We require lowmem mappings for the descriptors because
@@ -492,13 +503,16 @@ static struct vring_desc *alloc_indirect_split(struct virtqueue *_vq,
 	 */
 	gfp &= ~__GFP_HIGHMEM;
 
-	desc = kmalloc_array(total_sg, sizeof(struct vring_desc), gfp);
-	if (!desc)
+	in_desc = kmalloc(size, gfp);
+	if (!in_desc)
 		return NULL;
 
+	desc = in_desc->desc;
+
 	for (i = 0; i < total_sg; i++)
 		desc[i].next = cpu_to_virtio16(_vq->vdev, i + 1);
-	return desc;
+
+	return in_desc;
 }
 
 static inline unsigned int virtqueue_add_desc_split(struct virtqueue *vq,
@@ -540,6 +554,7 @@ static inline int virtqueue_add_split(struct virtqueue *_vq,
 				      gfp_t gfp)
 {
 	struct vring_virtqueue *vq = to_vvq(_vq);
+	struct vring_split_desc_indir *in_desc;
 	struct scatterlist *sg;
 	struct vring_desc *desc;
 	unsigned int i, n, avail, descs_used, prev, err_idx;
@@ -562,9 +577,13 @@ static inline int virtqueue_add_split(struct virtqueue *_vq,
 
 	head = vq->free_head;
 
-	if (virtqueue_use_indirect(vq, total_sg))
-		desc = alloc_indirect_split(_vq, total_sg, gfp);
-	else {
+	if (virtqueue_use_indirect(vq, total_sg)) {
+		in_desc = alloc_indirect_split(_vq, total_sg, gfp);
+		if (!in_desc)
+			desc = NULL;
+		else
+			desc = in_desc->desc;
+	} else {
 		desc = NULL;
 		WARN_ON_ONCE(total_sg > vq->split.vring.num && !vq->indirect);
 	}
@@ -637,10 +656,10 @@ static inline int virtqueue_add_split(struct virtqueue *_vq,
 			~VRING_DESC_F_NEXT;
 
 	if (indirect) {
+		u32 size = total_sg * sizeof(struct vring_desc);
+
 		/* Now that the indirect table is filled in, map it. */
-		dma_addr_t addr = vring_map_single(
-			vq, desc, total_sg * sizeof(struct vring_desc),
-			DMA_TO_DEVICE);
+		dma_addr_t addr = vring_map_single(vq, desc, size, DMA_TO_DEVICE);
 		if (vring_mapping_error(vq, addr)) {
 			if (!vring_need_unmap_buffer(vq))
 				goto free_indirect;
@@ -648,11 +667,17 @@ static inline int virtqueue_add_split(struct virtqueue *_vq,
 			goto unmap_release;
 		}
 
-		virtqueue_add_desc_split(_vq, vq->split.vring.desc,
-					 head, addr,
-					 total_sg * sizeof(struct vring_desc),
-					 VRING_DESC_F_INDIRECT,
-					 false);
+		desc = &vq->split.vring.desc[head];
+
+		desc->flags = cpu_to_virtio16(_vq->vdev, VRING_DESC_F_INDIRECT);
+		desc->addr = cpu_to_virtio64(_vq->vdev, addr);
+		desc->len = cpu_to_virtio32(_vq->vdev, size);
+
+		vq->split.desc_extra[head].flags = VRING_DESC_F_INDIRECT;
+
+		in_desc->addr = addr;
+		in_desc->len = size;
+		in_desc->num = total_sg;
 	}
 
 	/* We're using some buffers from the free list. */
@@ -667,7 +692,7 @@ static inline int virtqueue_add_split(struct virtqueue *_vq,
 	/* Store token and indirect buffer state. */
 	vq->split.desc_state[head].data = data;
 	if (indirect)
-		vq->split.desc_state[head].indir_desc = desc;
+		vq->split.desc_state[head].indir_desc = in_desc;
 	else
 		vq->split.desc_state[head].indir_desc = ctx;
 
@@ -717,7 +742,7 @@ static inline int virtqueue_add_split(struct virtqueue *_vq,
 
 free_indirect:
 	if (indirect)
-		kfree(desc);
+		kfree(in_desc);
 
 	END_USE(vq);
 	return -ENOMEM;
@@ -782,34 +807,27 @@ static void detach_buf_split(struct vring_virtqueue *vq, unsigned int head,
 		if (ctx)
 			*ctx = vq->split.desc_state[head].indir_desc;
 	} else {
-		struct vring_desc *indir_desc =
-				vq->split.desc_state[head].indir_desc;
-		u32 len;
+		struct vring_split_desc_indir *in_desc;
 
-		if (vq->use_dma_api) {
-			struct vring_desc_extra *extra = vq->split.desc_extra;
+		in_desc = vq->split.desc_state[head].indir_desc;
 
+		if (vq->use_dma_api) {
 			dma_unmap_single(vring_dma_dev(vq),
-					 extra[i].addr,
-					 extra[i].len,
+					 in_desc->addr, in_desc->len,
 					 (flags & VRING_DESC_F_WRITE) ?
 					 DMA_FROM_DEVICE : DMA_TO_DEVICE);
 		}
 
-		len = vq->split.desc_extra[head].len;
-
 		BUG_ON(!(vq->split.desc_extra[head].flags &
 				VRING_DESC_F_INDIRECT));
-		BUG_ON(len == 0 || len % sizeof(struct vring_desc));
 
 		if (vring_need_unmap_buffer(vq)) {
-			for (j = 0; j < len / sizeof(struct vring_desc); j++)
-				vring_unmap_one_split_indirect(vq, &indir_desc[j]);
+			for (j = 0; j < in_desc->num; j++)
+				vring_unmap_one_split_indirect(vq, &in_desc->desc[j]);
 		}
 
-		kfree(indir_desc);
+		kfree(in_desc);
 		vq->split.desc_state[head].indir_desc = NULL;
-
 	}
 
 	vq->split.desc_extra[i].next = vq->free_head;
-- 
2.32.0.3.g01195cf9f


