Return-Path: <kvm+bounces-10441-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 7A0EC86C203
	for <lists+kvm@lfdr.de>; Thu, 29 Feb 2024 08:22:53 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 35ED0281F92
	for <lists+kvm@lfdr.de>; Thu, 29 Feb 2024 07:22:52 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4AA49524A5;
	Thu, 29 Feb 2024 07:21:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b="HZnefzT8"
X-Original-To: kvm@vger.kernel.org
Received: from out30-131.freemail.mail.aliyun.com (out30-131.freemail.mail.aliyun.com [115.124.30.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 505A14E1DD;
	Thu, 29 Feb 2024 07:20:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=115.124.30.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709191262; cv=none; b=uZy+aEmR55sm3BkTqF3Wxj/maSoYzWhxAL0KlHsaWb+ZN6zLVDiLx2ChuKhuQ3zk1AtL5A64itIu2L5tHi3FjJmTuZlxVL59Zau1vdcNeknltvp3lvezLp2BqM9Efkduyg6L2XzimogpUOSOJ/5HzfPJ4N4QgNfKlBPNTdgqbxI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709191262; c=relaxed/simple;
	bh=CniNnIZ9GNdg9mZl/L/CRuDJhJzQveSh/1T8nV5GtDY=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=J6pEke1zq8yrOnrhnzkA3duGnEhBnJ+T498Noc5LOSmDsr2EUsn8hXxq2WeOzdw9NE6YxA/CqgunVtjV4ewZ0KouQBH6a2rN44PJvJ2X5JdfYkuqob2aKbJo8CuRwxhl1xptHFQuIa6LsxwdR+BnL9H9erQ7LYizrdnAnE7Q3JI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com; spf=pass smtp.mailfrom=linux.alibaba.com; dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b=HZnefzT8; arc=none smtp.client-ip=115.124.30.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.alibaba.com
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1709191257; h=From:To:Subject:Date:Message-Id:MIME-Version;
	bh=sjGZ6V6Wg7dragljIJeNGw4jGyz/uv3T+cDPwN7GEJ4=;
	b=HZnefzT8wa/XJLN0GAQwEBXj7uLmUBqdskDamP6WPlOeGcYZPKHOCNg3P1lm8+FgWb5c5V+f5URkkUQ5VlGW8OdsKS7Fw3bLdiA2PCC07VHl5zy9d9uf0wkS/VjGPS/Cq9JyhQU3GgdCQNNsweYRopsM71x8HJjq6KTQdK1olTE=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R121e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=ay29a033018045192;MF=xuanzhuo@linux.alibaba.com;NM=1;PH=DS;RN=35;SR=0;TI=SMTPD_---0W1SAV7l_1709191254;
Received: from localhost(mailfrom:xuanzhuo@linux.alibaba.com fp:SMTPD_---0W1SAV7l_1709191254)
          by smtp.aliyun-inc.com;
          Thu, 29 Feb 2024 15:20:55 +0800
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
Subject: [PATCH vhost v3 06/19] virtio_ring: no store dma info when unmap is not needed
Date: Thu, 29 Feb 2024 15:20:31 +0800
Message-Id: <20240229072044.77388-7-xuanzhuo@linux.alibaba.com>
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

As discussed:
http://lore.kernel.org/all/CACGkMEug-=C+VQhkMYSgUKMC==04m7-uem_yC21bgGkKZh845w@mail.gmail.com

When the vq is premapped mode, the driver manages the dma
info is a good way.

So this commit make the virtio core not to store the dma
info and release the memory which is used to store the dma
info.

If the use_dma_api is false, the memory is also not allocated.

Signed-off-by: Xuan Zhuo <xuanzhuo@linux.alibaba.com>
---
 drivers/virtio/virtio_ring.c | 89 ++++++++++++++++++++++++++++--------
 1 file changed, 70 insertions(+), 19 deletions(-)

diff --git a/drivers/virtio/virtio_ring.c b/drivers/virtio/virtio_ring.c
index 9680b3827d5b..c1e4edaeb446 100644
--- a/drivers/virtio/virtio_ring.c
+++ b/drivers/virtio/virtio_ring.c
@@ -94,12 +94,15 @@ struct vring_desc_state_packed {
 };
 
 struct vring_desc_extra {
-	dma_addr_t addr;		/* Descriptor DMA addr. */
-	u32 len;			/* Descriptor length. */
 	u16 flags;			/* Descriptor flags. */
 	u16 next;			/* The next desc state in a list. */
 };
 
+struct vring_desc_dma {
+	dma_addr_t addr;		/* Descriptor DMA addr. */
+	u32 len;			/* Descriptor length. */
+};
+
 struct vring_virtqueue_split {
 	/* Actual memory layout for this queue. */
 	struct vring vring;
@@ -116,6 +119,7 @@ struct vring_virtqueue_split {
 	/* Per-descriptor state. */
 	struct vring_desc_state_split *desc_state;
 	struct vring_desc_extra *desc_extra;
+	struct vring_desc_dma *desc_dma;
 
 	/* DMA address and size information */
 	dma_addr_t queue_dma_addr;
@@ -156,6 +160,7 @@ struct vring_virtqueue_packed {
 	/* Per-descriptor state. */
 	struct vring_desc_state_packed *desc_state;
 	struct vring_desc_extra *desc_extra;
+	struct vring_desc_dma *desc_dma;
 
 	/* DMA address and size information */
 	dma_addr_t ring_dma_addr;
@@ -472,13 +477,14 @@ static unsigned int vring_unmap_one_split(const struct vring_virtqueue *vq,
 					  unsigned int i)
 {
 	struct vring_desc_extra *extra = vq->split.desc_extra;
+	struct vring_desc_dma *dma = vq->split.desc_dma;
 	u16 flags;
 
 	flags = extra[i].flags;
 
 	dma_unmap_page(vring_dma_dev(vq),
-		       extra[i].addr,
-		       extra[i].len,
+		       dma[i].addr,
+		       dma[i].len,
 		       (flags & VRING_DESC_F_WRITE) ?
 		       DMA_FROM_DEVICE : DMA_TO_DEVICE);
 
@@ -535,8 +541,11 @@ static inline unsigned int virtqueue_add_desc_split(struct virtqueue *vq,
 		next = extra[i].next;
 		desc[i].next = cpu_to_virtio16(vq->vdev, next);
 
-		extra[i].addr = addr;
-		extra[i].len = len;
+		if (vring->split.desc_dma) {
+			vring->split.desc_dma[i].addr = addr;
+			vring->split.desc_dma[i].len = len;
+		}
+
 		extra[i].flags = flags;
 	} else
 		next = virtio16_to_cpu(vq->vdev, desc[i].next);
@@ -1072,16 +1081,26 @@ static void virtqueue_vring_attach_split(struct vring_virtqueue *vq,
 	vq->free_head = 0;
 }
 
-static int vring_alloc_state_extra_split(struct vring_virtqueue_split *vring_split)
+static int vring_alloc_state_extra_split(struct vring_virtqueue_split *vring_split,
+					 bool need_unmap)
 {
 	struct vring_desc_state_split *state;
 	struct vring_desc_extra *extra;
+	struct vring_desc_dma *dma;
 	u32 num = vring_split->vring.num;
 
 	state = kmalloc_array(num, sizeof(struct vring_desc_state_split), GFP_KERNEL);
 	if (!state)
 		goto err_state;
 
+	if (need_unmap) {
+		dma = kmalloc_array(num, sizeof(struct vring_desc_dma), GFP_KERNEL);
+		if (!dma)
+			goto err_dma;
+	} else {
+		dma = NULL;
+	}
+
 	extra = vring_alloc_desc_extra(num);
 	if (!extra)
 		goto err_extra;
@@ -1090,9 +1109,12 @@ static int vring_alloc_state_extra_split(struct vring_virtqueue_split *vring_spl
 
 	vring_split->desc_state = state;
 	vring_split->desc_extra = extra;
+	vring_split->desc_dma = dma;
 	return 0;
 
 err_extra:
+	kfree(dma);
+err_dma:
 	kfree(state);
 err_state:
 	return -ENOMEM;
@@ -1108,6 +1130,7 @@ static void vring_free_split(struct vring_virtqueue_split *vring_split,
 
 	kfree(vring_split->desc_state);
 	kfree(vring_split->desc_extra);
+	kfree(vring_split->desc_dma);
 }
 
 static int vring_alloc_queue_split(struct vring_virtqueue_split *vring_split,
@@ -1209,7 +1232,8 @@ static int virtqueue_resize_split(struct virtqueue *_vq, u32 num)
 	if (err)
 		goto err;
 
-	err = vring_alloc_state_extra_split(&vring_split);
+	err = vring_alloc_state_extra_split(&vring_split,
+					    vring_need_unmap_buffer(vq));
 	if (err)
 		goto err_state_extra;
 
@@ -1245,14 +1269,16 @@ static u16 packed_last_used(u16 last_used_idx)
 
 /* caller must check vring_need_unmap_buffer() */
 static void vring_unmap_extra_packed(const struct vring_virtqueue *vq,
-				     const struct vring_desc_extra *extra)
+				     unsigned int i)
 {
+	const struct vring_desc_extra *extra = &vq->packed.desc_extra[i];
+	const struct vring_desc_dma *dma = &vq->packed.desc_dma[i];
 	u16 flags;
 
 	flags = extra->flags;
 
 	dma_unmap_page(vring_dma_dev(vq),
-		       extra->addr, extra->len,
+		       dma->addr, dma->len,
 		       (flags & VRING_DESC_F_WRITE) ?
 		       DMA_FROM_DEVICE : DMA_TO_DEVICE);
 }
@@ -1503,8 +1529,8 @@ static inline int virtqueue_add_packed(struct virtqueue *_vq,
 			desc[i].id = cpu_to_le16(id);
 
 			if (vring_need_unmap_buffer(vq)) {
-				vq->packed.desc_extra[curr].addr = addr;
-				vq->packed.desc_extra[curr].len = sg->length;
+				vq->packed.desc_dma[curr].addr = addr;
+				vq->packed.desc_dma[curr].len = sg->length;
 			}
 
 			vq->packed.desc_extra[curr].flags = le16_to_cpu(flags);
@@ -1563,7 +1589,7 @@ static inline int virtqueue_add_packed(struct virtqueue *_vq,
 	for (n = 0; n < total_sg; n++) {
 		if (i == err_idx)
 			break;
-		vring_unmap_extra_packed(vq, &vq->packed.desc_extra[curr]);
+		vring_unmap_extra_packed(vq, curr);
 		curr = vq->packed.desc_extra[curr].next;
 		i++;
 		if (i >= vq->packed.vring.num)
@@ -1644,8 +1670,7 @@ static void detach_buf_packed(struct vring_virtqueue *vq,
 		if (vring_need_unmap_buffer(vq)) {
 			curr = id;
 			for (i = 0; i < state->num; i++) {
-				vring_unmap_extra_packed(vq,
-							 &vq->packed.desc_extra[curr]);
+				vring_unmap_extra_packed(vq, curr);
 				curr = vq->packed.desc_extra[curr].next;
 			}
 		}
@@ -1958,6 +1983,7 @@ static void vring_free_packed(struct vring_virtqueue_packed *vring_packed,
 
 	kfree(vring_packed->desc_state);
 	kfree(vring_packed->desc_extra);
+	kfree(vring_packed->desc_dma);
 }
 
 static int vring_alloc_queue_packed(struct vring_virtqueue_packed *vring_packed,
@@ -2014,10 +2040,12 @@ static int vring_alloc_queue_packed(struct vring_virtqueue_packed *vring_packed,
 	return -ENOMEM;
 }
 
-static int vring_alloc_state_extra_packed(struct vring_virtqueue_packed *vring_packed)
+static int vring_alloc_state_extra_packed(struct vring_virtqueue_packed *vring_packed,
+					  bool need_unmap)
 {
 	struct vring_desc_state_packed *state;
 	struct vring_desc_extra *extra;
+	struct vring_desc_dma *dma;
 	u32 num = vring_packed->vring.num;
 
 	state = kmalloc_array(num, sizeof(struct vring_desc_state_packed), GFP_KERNEL);
@@ -2026,6 +2054,14 @@ static int vring_alloc_state_extra_packed(struct vring_virtqueue_packed *vring_p
 
 	memset(state, 0, num * sizeof(struct vring_desc_state_packed));
 
+	if (need_unmap) {
+		dma = kmalloc_array(num, sizeof(struct vring_desc_dma), GFP_KERNEL);
+		if (!dma)
+			goto err_desc_dma;
+	} else {
+		dma = NULL;
+	}
+
 	extra = vring_alloc_desc_extra(num);
 	if (!extra)
 		goto err_desc_extra;
@@ -2036,6 +2072,8 @@ static int vring_alloc_state_extra_packed(struct vring_virtqueue_packed *vring_p
 	return 0;
 
 err_desc_extra:
+	kfree(dma);
+err_desc_dma:
 	kfree(state);
 err_desc_state:
 	return -ENOMEM;
@@ -2127,7 +2165,8 @@ static struct virtqueue *vring_create_virtqueue_packed(
 	if (virtio_has_feature(vdev, VIRTIO_F_ORDER_PLATFORM))
 		vq->weak_barriers = false;
 
-	err = vring_alloc_state_extra_packed(&vring_packed);
+	err = vring_alloc_state_extra_packed(&vring_packed,
+					     vring_need_unmap_buffer(vq));
 	if (err)
 		goto err_state_extra;
 
@@ -2159,7 +2198,8 @@ static int virtqueue_resize_packed(struct virtqueue *_vq, u32 num)
 	if (vring_alloc_queue_packed(&vring_packed, vdev, num, vring_dma_dev(vq)))
 		goto err_ring;
 
-	err = vring_alloc_state_extra_packed(&vring_packed);
+	err = vring_alloc_state_extra_packed(&vring_packed,
+					     vring_need_unmap_buffer(vq));
 	if (err)
 		goto err_state_extra;
 
@@ -2671,7 +2711,8 @@ static struct virtqueue *__vring_new_virtqueue(unsigned int index,
 	if (virtio_has_feature(vdev, VIRTIO_F_ORDER_PLATFORM))
 		vq->weak_barriers = false;
 
-	err = vring_alloc_state_extra_split(vring_split);
+	err = vring_alloc_state_extra_split(vring_split,
+					    vring_need_unmap_buffer(vq));
 	if (err) {
 		kfree(vq);
 		return NULL;
@@ -2831,6 +2872,14 @@ int virtqueue_set_dma_premapped(struct virtqueue *_vq)
 
 	vq->premapped = true;
 
+	if (vq->packed_ring) {
+		kfree(vq->packed.desc_dma);
+		vq->packed.desc_dma = NULL;
+	} else {
+		kfree(vq->split.desc_dma);
+		vq->split.desc_dma = NULL;
+	}
+
 	END_USE(vq);
 
 	return 0;
@@ -2920,6 +2969,7 @@ static void vring_free(struct virtqueue *_vq)
 
 			kfree(vq->packed.desc_state);
 			kfree(vq->packed.desc_extra);
+			kfree(vq->packed.desc_dma);
 		} else {
 			vring_free_queue(vq->vq.vdev,
 					 vq->split.queue_size_in_bytes,
@@ -2931,6 +2981,7 @@ static void vring_free(struct virtqueue *_vq)
 	if (!vq->packed_ring) {
 		kfree(vq->split.desc_state);
 		kfree(vq->split.desc_extra);
+		kfree(vq->split.desc_dma);
 	}
 }
 
-- 
2.32.0.3.g01195cf9f


