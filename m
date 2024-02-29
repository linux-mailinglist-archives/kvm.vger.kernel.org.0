Return-Path: <kvm+bounces-10438-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id ECC9C86C1F0
	for <lists+kvm@lfdr.de>; Thu, 29 Feb 2024 08:22:04 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 137371C229FB
	for <lists+kvm@lfdr.de>; Thu, 29 Feb 2024 07:22:04 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id ECD2745951;
	Thu, 29 Feb 2024 07:20:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b="ffQugzaU"
X-Original-To: kvm@vger.kernel.org
Received: from out30-98.freemail.mail.aliyun.com (out30-98.freemail.mail.aliyun.com [115.124.30.98])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EA63B45940;
	Thu, 29 Feb 2024 07:20:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=115.124.30.98
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709191258; cv=none; b=O0btNTvmVnDrt/7TgxAmB51AReZrZt1RPHN21s88mDe+S1TjiHvc3sNp1AotZkrf4WOhGHMkIVvXKi4Ut9/bcMQsPbojd44L3Mi8sJKDXO9R9+4BTItBsC3sIdst6o7FukYT+n/HVW4vO6hoVG2SYcWmwjvUQsOyZ2xR4QAcB9g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709191258; c=relaxed/simple;
	bh=J5cJ2czOhIvgpSmEC6fnTwEkg5TGNWL6ZotrgsHxZkI=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=jm7h1yb8h0Nj0NxnVQgxO1CZfnCYrygl+q1IExfTNU0iRBv1T34aFzgrxKvLV3oJlEN+nKZ8GuCyK94+bBbqBtdRR3VyTwFH5AfISdFC5elWWq9BCEvWl7Nny+fhS8XTGUWImJfhhpEinmWWEOn5GEzeJG87DA56whBqlSunNEI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com; spf=pass smtp.mailfrom=linux.alibaba.com; dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b=ffQugzaU; arc=none smtp.client-ip=115.124.30.98
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.alibaba.com
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1709191249; h=From:To:Subject:Date:Message-Id:MIME-Version;
	bh=saSIU1bHCwAg5v0mYMoHrXba5As9q/PsyzQZAzeMUCk=;
	b=ffQugzaU/hJA3yM61IG5CZKoDlgqTkIbzpc7p4/E5gc3WLtO1v4XvoSQgUCzhzQMXxodhz8a8uGga6yH0BmVw7vve7e4ETd7CFM0vONq00jTiMDIt/0gAyDTzP+YWKhea0QtED30i2te5ye7Yfvkk1RWIonLUdQbYKHV7r4LNqU=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R201e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=ay29a033018045192;MF=xuanzhuo@linux.alibaba.com;NM=1;PH=DS;RN=35;SR=0;TI=SMTPD_---0W1SBc1d_1709191246;
Received: from localhost(mailfrom:xuanzhuo@linux.alibaba.com fp:SMTPD_---0W1SBc1d_1709191246)
          by smtp.aliyun-inc.com;
          Thu, 29 Feb 2024 15:20:47 +0800
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
Subject: [PATCH vhost v3 01/19] virtio_ring: introduce vring_need_unmap_buffer
Date: Thu, 29 Feb 2024 15:20:26 +0800
Message-Id: <20240229072044.77388-2-xuanzhuo@linux.alibaba.com>
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

To make the code readable, introduce vring_need_unmap_buffer() to
replace do_unmap.

   use_dma_api premapped -> vring_need_unmap_buffer()
1. false       false        false
2. true        false        true
3. true        true         false

Signed-off-by: Xuan Zhuo <xuanzhuo@linux.alibaba.com>
Acked-by: Jason Wang <jasowang@redhat.com>
---
 drivers/virtio/virtio_ring.c | 27 ++++++++++++---------------
 1 file changed, 12 insertions(+), 15 deletions(-)

diff --git a/drivers/virtio/virtio_ring.c b/drivers/virtio/virtio_ring.c
index 6f7e5010a673..21c461e2d851 100644
--- a/drivers/virtio/virtio_ring.c
+++ b/drivers/virtio/virtio_ring.c
@@ -175,11 +175,6 @@ struct vring_virtqueue {
 	/* Do DMA mapping by driver */
 	bool premapped;
 
-	/* Do unmap or not for desc. Just when premapped is False and
-	 * use_dma_api is true, this is true.
-	 */
-	bool do_unmap;
-
 	/* Head of free buffer list. */
 	unsigned int free_head;
 	/* Number we've added since last sync. */
@@ -297,6 +292,11 @@ static bool vring_use_dma_api(const struct virtio_device *vdev)
 	return false;
 }
 
+static bool vring_need_unmap_buffer(const struct vring_virtqueue *vring)
+{
+	return vring->use_dma_api && !vring->premapped;
+}
+
 size_t virtio_max_dma_size(const struct virtio_device *vdev)
 {
 	size_t max_segment_size = SIZE_MAX;
@@ -445,7 +445,7 @@ static void vring_unmap_one_split_indirect(const struct vring_virtqueue *vq,
 {
 	u16 flags;
 
-	if (!vq->do_unmap)
+	if (!vring_need_unmap_buffer(vq))
 		return;
 
 	flags = virtio16_to_cpu(vq->vq.vdev, desc->flags);
@@ -475,7 +475,7 @@ static unsigned int vring_unmap_one_split(const struct vring_virtqueue *vq,
 				 (flags & VRING_DESC_F_WRITE) ?
 				 DMA_FROM_DEVICE : DMA_TO_DEVICE);
 	} else {
-		if (!vq->do_unmap)
+		if (!vring_need_unmap_buffer(vq))
 			goto out;
 
 		dma_unmap_page(vring_dma_dev(vq),
@@ -643,7 +643,7 @@ static inline int virtqueue_add_split(struct virtqueue *_vq,
 	}
 	/* Last one doesn't continue. */
 	desc[prev].flags &= cpu_to_virtio16(_vq->vdev, ~VRING_DESC_F_NEXT);
-	if (!indirect && vq->do_unmap)
+	if (!indirect && vring_need_unmap_buffer(vq))
 		vq->split.desc_extra[prev & (vq->split.vring.num - 1)].flags &=
 			~VRING_DESC_F_NEXT;
 
@@ -802,7 +802,7 @@ static void detach_buf_split(struct vring_virtqueue *vq, unsigned int head,
 				VRING_DESC_F_INDIRECT));
 		BUG_ON(len == 0 || len % sizeof(struct vring_desc));
 
-		if (vq->do_unmap) {
+		if (vring_need_unmap_buffer(vq)) {
 			for (j = 0; j < len / sizeof(struct vring_desc); j++)
 				vring_unmap_one_split_indirect(vq, &indir_desc[j]);
 		}
@@ -1236,7 +1236,7 @@ static void vring_unmap_extra_packed(const struct vring_virtqueue *vq,
 				 (flags & VRING_DESC_F_WRITE) ?
 				 DMA_FROM_DEVICE : DMA_TO_DEVICE);
 	} else {
-		if (!vq->do_unmap)
+		if (!vring_need_unmap_buffer(vq))
 			return;
 
 		dma_unmap_page(vring_dma_dev(vq),
@@ -1251,7 +1251,7 @@ static void vring_unmap_desc_packed(const struct vring_virtqueue *vq,
 {
 	u16 flags;
 
-	if (!vq->do_unmap)
+	if (!vring_need_unmap_buffer(vq))
 		return;
 
 	flags = le16_to_cpu(desc->flags);
@@ -1632,7 +1632,7 @@ static void detach_buf_packed(struct vring_virtqueue *vq,
 		if (!desc)
 			return;
 
-		if (vq->do_unmap) {
+		if (vring_need_unmap_buffer(vq)) {
 			len = vq->packed.desc_extra[id].len;
 			for (i = 0; i < len / sizeof(struct vring_packed_desc);
 					i++)
@@ -2091,7 +2091,6 @@ static struct virtqueue *vring_create_virtqueue_packed(
 	vq->dma_dev = dma_dev;
 	vq->use_dma_api = vring_use_dma_api(vdev);
 	vq->premapped = false;
-	vq->do_unmap = vq->use_dma_api;
 
 	vq->indirect = virtio_has_feature(vdev, VIRTIO_RING_F_INDIRECT_DESC) &&
 		!context;
@@ -2636,7 +2635,6 @@ static struct virtqueue *__vring_new_virtqueue(unsigned int index,
 	vq->dma_dev = dma_dev;
 	vq->use_dma_api = vring_use_dma_api(vdev);
 	vq->premapped = false;
-	vq->do_unmap = vq->use_dma_api;
 
 	vq->indirect = virtio_has_feature(vdev, VIRTIO_RING_F_INDIRECT_DESC) &&
 		!context;
@@ -2804,7 +2802,6 @@ int virtqueue_set_dma_premapped(struct virtqueue *_vq)
 	}
 
 	vq->premapped = true;
-	vq->do_unmap = false;
 
 	END_USE(vq);
 
-- 
2.32.0.3.g01195cf9f


