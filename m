Return-Path: <kvm+bounces-7460-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id E9B7F8423A7
	for <lists+kvm@lfdr.de>; Tue, 30 Jan 2024 12:45:04 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 635FE1F278E9
	for <lists+kvm@lfdr.de>; Tue, 30 Jan 2024 11:45:04 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0D1A36F082;
	Tue, 30 Jan 2024 11:42:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b="PnInmAKc"
X-Original-To: kvm@vger.kernel.org
Received: from out30-97.freemail.mail.aliyun.com (out30-97.freemail.mail.aliyun.com [115.124.30.97])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E38826D1C6;
	Tue, 30 Jan 2024 11:42:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=115.124.30.97
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706614960; cv=none; b=QltWxVm0cRIiWsQcpHkNup7MbrnJhkAgv7UhheqkH1bQUnu4UQApicrKey04xxOmmiy6D60tCcZC2hJoCxrRIdPXHAICp/aJyx8qme1/Dic5z7Fn3v7roviAARKUFfP1f+dWvzMGtVx8JzgKoBXu7MuEAHs25G0xscS1mc2W/+U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706614960; c=relaxed/simple;
	bh=csVqBjWHLd0wx8pt5oq5iqtKVwsT+VuwzwY4U+gqvHU=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=rbyYJLSnsuY86Yg2PKXcbEt3wBh2ok5QxCyKjtICUlWWSzv+xelYzTTYJC8Pi46AZtbfDMZCpvDHjFp3SLPH3SxL79dY/X96vlXZJMT3Glm7e9TBJKhWG/P3UQwe4SkKWLoLlFOLtMtqh+kH40JpuaUPyprFS7+lgIViBo47Jcs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com; spf=pass smtp.mailfrom=linux.alibaba.com; dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b=PnInmAKc; arc=none smtp.client-ip=115.124.30.97
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.alibaba.com
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1706614956; h=From:To:Subject:Date:Message-Id:MIME-Version;
	bh=HrZuvU9yrR6T2DolteXZPfHuA2cDqF8W4GegYsiFG0w=;
	b=PnInmAKcMxnyTSS9YZoTwqHkhQHzhZGX126kTii3kldj0G9oo+IaoaFFoy0NT/7tgMEI/Sn+cu8RGC7aNbqW/T2zt+YxDjGwUJzhxwP/mb710/bAUtgCMyc3tuARng06AXumUrRGMirp7I727xum0wv793Y8Fjc7+IgdjfNI7cw=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R151e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=ay29a033018045168;MF=xuanzhuo@linux.alibaba.com;NM=1;PH=DS;RN=37;SR=0;TI=SMTPD_---0W.g4wMQ_1706614951;
Received: from localhost(mailfrom:xuanzhuo@linux.alibaba.com fp:SMTPD_---0W.g4wMQ_1706614951)
          by smtp.aliyun-inc.com;
          Tue, 30 Jan 2024 19:42:32 +0800
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
Subject: [PATCH vhost 04/17] virtio_ring: split: remove double check of the unmap ops
Date: Tue, 30 Jan 2024 19:42:11 +0800
Message-Id: <20240130114224.86536-5-xuanzhuo@linux.alibaba.com>
X-Mailer: git-send-email 2.32.0.3.g01195cf9f
In-Reply-To: <20240130114224.86536-1-xuanzhuo@linux.alibaba.com>
References: <20240130114224.86536-1-xuanzhuo@linux.alibaba.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Git-Hash: 239d1d475be4
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
 drivers/virtio/virtio_ring.c | 80 ++++++++++++++++++------------------
 1 file changed, 39 insertions(+), 41 deletions(-)

diff --git a/drivers/virtio/virtio_ring.c b/drivers/virtio/virtio_ring.c
index dd03bc5a81fe..2b41fdbce975 100644
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
 
@@ -816,9 +809,14 @@ static void detach_buf_split(struct vring_virtqueue *vq, unsigned int head,
 
 		kfree(indir_desc);
 		vq->split.desc_state[head].indir_desc = NULL;
-	} else if (ctx) {
-		*ctx = vq->split.desc_state[head].indir_desc;
+
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


