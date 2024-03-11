Return-Path: <kvm+bounces-11504-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id AFF39877B4D
	for <lists+kvm@lfdr.de>; Mon, 11 Mar 2024 08:22:08 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 297291F20F66
	for <lists+kvm@lfdr.de>; Mon, 11 Mar 2024 07:22:08 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4170914284;
	Mon, 11 Mar 2024 07:21:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b="cj69mOqb"
X-Original-To: kvm@vger.kernel.org
Received: from out30-113.freemail.mail.aliyun.com (out30-113.freemail.mail.aliyun.com [115.124.30.113])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B9AD311712;
	Mon, 11 Mar 2024 07:21:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=115.124.30.113
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710141691; cv=none; b=ddwov3jUkl/jn+vHmJ/ScTn/gDphe51XT+Ef7JPNbkoilGxyfaA+eK0vtOoE/bVxBDWaxKELX75yowG+qHFdRO9j6RKb/26bonSU0wjIAafE3eoxQUzq/6k7wxafa4/0JrhpqOOrhpWF5pa0mMWA69WGqx2nGUUvdLoCqiwiIao=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710141691; c=relaxed/simple;
	bh=mnfECoRhxOUr5hq+aTQH146GAEbMcFSwTqK664QF1ug=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=jggnhFz+X6gzqOCNWnR/3rFolI9pZ70Mid8xuVGiHpGgVQ8YqZjsZGtv7I/M8gzmSCijUDqzIrXgW/0njrKKtwLqhVsJAuUIlLjfdG5Ad/DWGq3IlxFyNKk1zjIQ0DkcpQN9MCTAxI+zUDo50TbVYKErnWLo/h7iGylfolqqg5w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com; spf=pass smtp.mailfrom=linux.alibaba.com; dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b=cj69mOqb; arc=none smtp.client-ip=115.124.30.113
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.alibaba.com
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1710141681; h=From:To:Subject:Date:Message-Id:MIME-Version;
	bh=kjSYAVfiWOD4MW886BySgZ+l1WsXmtRdOaa62X5lOi4=;
	b=cj69mOqbLY3+Ta9U6IroXslbFPxa44XRZXFiv6R35X/ZwZvW/DsnD5+6MHBFbmM/aXB/pApgQsjnl1Yvl0BCEuotR2aUU2JZVE/mCi9suchuoAzIi00NXortMhx+CUrgpXzbp+RReleDlnNmvoNZUFJt3pYkSPqz8T2iyDgBYF0=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R821e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=ay29a033018046051;MF=xuanzhuo@linux.alibaba.com;NM=1;PH=DS;RN=25;SR=0;TI=SMTPD_---0W2D2K72_1710141678;
Received: from localhost(mailfrom:xuanzhuo@linux.alibaba.com fp:SMTPD_---0W2D2K72_1710141678)
          by smtp.aliyun-inc.com;
          Mon, 11 Mar 2024 15:21:19 +0800
From: Xuan Zhuo <xuanzhuo@linux.alibaba.com>
To: virtualization@lists.linux.dev
Cc: Richard Weinberger <richard@nod.at>,
	Anton Ivanov <anton.ivanov@cambridgegreys.com>,
	Johannes Berg <johannes@sipsolutions.net>,
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
	"Michael S. Tsirkin" <mst@redhat.com>,
	Jason Wang <jasowang@redhat.com>,
	Xuan Zhuo <xuanzhuo@linux.alibaba.com>,
	linux-um@lists.infradead.org,
	platform-driver-x86@vger.kernel.org,
	linux-remoteproc@vger.kernel.org,
	linux-s390@vger.kernel.org,
	kvm@vger.kernel.org
Subject: [PATCH vhost v2 4/4] virtio_ring: simplify the parameters of the funcs related to vring_create/new_virtqueue()
Date: Mon, 11 Mar 2024 15:21:13 +0800
Message-Id: <20240311072113.67673-5-xuanzhuo@linux.alibaba.com>
X-Mailer: git-send-email 2.32.0.3.g01195cf9f
In-Reply-To: <20240311072113.67673-1-xuanzhuo@linux.alibaba.com>
References: <20240311072113.67673-1-xuanzhuo@linux.alibaba.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Git-Hash: a38f8a85b807
Content-Transfer-Encoding: 8bit

As the refactor of find_vqs()/vring_new_virtqueue()/vring_create_virtqueue
the struct cfg/tp_cfg are passed to vring.

This patch refactors the vring by these structures. This can simplify
the code.

Signed-off-by: Xuan Zhuo <xuanzhuo@linux.alibaba.com>
---
 drivers/virtio/virtio_ring.c | 157 +++++++++++------------------------
 1 file changed, 50 insertions(+), 107 deletions(-)

diff --git a/drivers/virtio/virtio_ring.c b/drivers/virtio/virtio_ring.c
index 03687800d8ff..94c442ba844f 100644
--- a/drivers/virtio/virtio_ring.c
+++ b/drivers/virtio/virtio_ring.c
@@ -223,15 +223,11 @@ struct vring_virtqueue {
 #endif
 };
 
-static struct virtqueue *__vring_new_virtqueue(unsigned int index,
+static struct virtqueue *__vring_new_virtqueue(struct virtio_device *vdev,
+					       unsigned int index,
 					       struct vring_virtqueue_split *vring_split,
-					       struct virtio_device *vdev,
-					       bool weak_barriers,
-					       bool context,
-					       bool (*notify)(struct virtqueue *),
-					       void (*callback)(struct virtqueue *),
-					       const char *name,
-					       struct device *dma_dev);
+					       struct vq_transport_config *tp_cfg,
+					       struct virtio_vq_config *cfg);
 static struct vring_desc_extra *vring_alloc_desc_extra(unsigned int num);
 static void vring_free(struct virtqueue *_vq);
 
@@ -240,6 +236,8 @@ static void vring_free(struct virtqueue *_vq);
  */
 
 #define to_vvq(_vq) container_of_const(_vq, struct vring_virtqueue, vq)
+#define cfg_vq_val(cfg, key) (cfg->key[cfg->cfg_idx])
+#define cfg_vq_get(cfg, key) (cfg->key ? cfg_vq_val(cfg, key) : false)
 
 static bool virtqueue_use_indirect(const struct vring_virtqueue *vq,
 				   unsigned int total_sg)
@@ -1138,32 +1136,28 @@ static int vring_alloc_queue_split(struct vring_virtqueue_split *vring_split,
 	return 0;
 }
 
-static struct virtqueue *vring_create_virtqueue_split(
-	unsigned int index,
-	unsigned int num,
-	unsigned int vring_align,
-	struct virtio_device *vdev,
-	bool weak_barriers,
-	bool may_reduce_num,
-	bool context,
-	bool (*notify)(struct virtqueue *),
-	void (*callback)(struct virtqueue *),
-	const char *name,
-	struct device *dma_dev)
+static struct virtqueue *vring_create_virtqueue_split(struct virtio_device *vdev,
+						      unsigned int index,
+						      struct vq_transport_config *tp_cfg,
+						      struct virtio_vq_config *cfg)
 {
 	struct vring_virtqueue_split vring_split = {};
 	struct virtqueue *vq;
 	int err;
 
-	err = vring_alloc_queue_split(&vring_split, vdev, num, vring_align,
-				      may_reduce_num, dma_dev);
+	tp_cfg->dma_dev = tp_cfg->dma_dev ? : vdev->dev.parent;
+
+	err = vring_alloc_queue_split(&vring_split, vdev,
+				      tp_cfg->num,
+				      tp_cfg->vring_align,
+				      tp_cfg->may_reduce_num,
+				      tp_cfg->dma_dev);
 	if (err)
 		return NULL;
 
-	vq = __vring_new_virtqueue(index, &vring_split, vdev, weak_barriers,
-				   context, notify, callback, name, dma_dev);
+	vq = __vring_new_virtqueue(vdev, index, &vring_split, tp_cfg, cfg);
 	if (!vq) {
-		vring_free_split(&vring_split, vdev, dma_dev);
+		vring_free_split(&vring_split, vdev, tp_cfg->dma_dev);
 		return NULL;
 	}
 
@@ -2050,38 +2044,33 @@ static void virtqueue_reinit_packed(struct vring_virtqueue *vq)
 	virtqueue_vring_init_packed(&vq->packed, !!vq->vq.callback);
 }
 
-static struct virtqueue *vring_create_virtqueue_packed(
-	unsigned int index,
-	unsigned int num,
-	unsigned int vring_align,
-	struct virtio_device *vdev,
-	bool weak_barriers,
-	bool may_reduce_num,
-	bool context,
-	bool (*notify)(struct virtqueue *),
-	void (*callback)(struct virtqueue *),
-	const char *name,
-	struct device *dma_dev)
+static struct virtqueue *vring_create_virtqueue_packed(struct virtio_device *vdev,
+						       unsigned int index,
+						       struct vq_transport_config *tp_cfg,
+						       struct virtio_vq_config *cfg)
 {
 	struct vring_virtqueue_packed vring_packed = {};
 	struct vring_virtqueue *vq;
+	struct device *dma_dev;
 	int err;
 
-	if (vring_alloc_queue_packed(&vring_packed, vdev, num, dma_dev))
+	dma_dev = tp_cfg->dma_dev ? : vdev->dev.parent;
+
+	if (vring_alloc_queue_packed(&vring_packed, vdev, tp_cfg->num, dma_dev))
 		goto err_ring;
 
 	vq = kmalloc(sizeof(*vq), GFP_KERNEL);
 	if (!vq)
 		goto err_vq;
 
-	vq->vq.callback = callback;
+	vq->vq.callback = cfg_vq_val(cfg, callbacks);
 	vq->vq.vdev = vdev;
-	vq->vq.name = name;
+	vq->vq.name = cfg_vq_val(cfg, names);
 	vq->vq.index = index;
 	vq->vq.reset = false;
 	vq->we_own_ring = true;
-	vq->notify = notify;
-	vq->weak_barriers = weak_barriers;
+	vq->notify = tp_cfg->notify;
+	vq->weak_barriers = tp_cfg->weak_barriers;
 #ifdef CONFIG_VIRTIO_HARDEN_NOTIFICATION
 	vq->broken = true;
 #else
@@ -2094,7 +2083,7 @@ static struct virtqueue *vring_create_virtqueue_packed(
 	vq->do_unmap = vq->use_dma_api;
 
 	vq->indirect = virtio_has_feature(vdev, VIRTIO_RING_F_INDIRECT_DESC) &&
-		!context;
+		!cfg_vq_get(cfg, ctx);
 	vq->event = virtio_has_feature(vdev, VIRTIO_RING_F_EVENT_IDX);
 
 	if (virtio_has_feature(vdev, VIRTIO_F_ORDER_PLATFORM))
@@ -2104,9 +2093,9 @@ static struct virtqueue *vring_create_virtqueue_packed(
 	if (err)
 		goto err_state_extra;
 
-	virtqueue_vring_init_packed(&vring_packed, !!callback);
+	virtqueue_vring_init_packed(&vring_packed, !!cfg_vq_val(cfg, callbacks));
 
-	virtqueue_init(vq, num);
+	virtqueue_init(vq, tp_cfg->num);
 	virtqueue_vring_attach_packed(vq, &vring_packed);
 
 	spin_lock(&vdev->vqs_list_lock);
@@ -2599,15 +2588,11 @@ irqreturn_t vring_interrupt(int irq, void *_vq)
 EXPORT_SYMBOL_GPL(vring_interrupt);
 
 /* Only available for split ring */
-static struct virtqueue *__vring_new_virtqueue(unsigned int index,
+static struct virtqueue *__vring_new_virtqueue(struct virtio_device *vdev,
+					       unsigned int index,
 					       struct vring_virtqueue_split *vring_split,
-					       struct virtio_device *vdev,
-					       bool weak_barriers,
-					       bool context,
-					       bool (*notify)(struct virtqueue *),
-					       void (*callback)(struct virtqueue *),
-					       const char *name,
-					       struct device *dma_dev)
+					       struct vq_transport_config *tp_cfg,
+					       struct virtio_vq_config *cfg)
 {
 	struct vring_virtqueue *vq;
 	int err;
@@ -2620,26 +2605,26 @@ static struct virtqueue *__vring_new_virtqueue(unsigned int index,
 		return NULL;
 
 	vq->packed_ring = false;
-	vq->vq.callback = callback;
+	vq->vq.callback = cfg_vq_val(cfg, callbacks);
 	vq->vq.vdev = vdev;
-	vq->vq.name = name;
+	vq->vq.name = cfg_vq_val(cfg, names);
 	vq->vq.index = index;
 	vq->vq.reset = false;
 	vq->we_own_ring = false;
-	vq->notify = notify;
-	vq->weak_barriers = weak_barriers;
+	vq->notify = tp_cfg->notify;
+	vq->weak_barriers = tp_cfg->weak_barriers;
 #ifdef CONFIG_VIRTIO_HARDEN_NOTIFICATION
 	vq->broken = true;
 #else
 	vq->broken = false;
 #endif
-	vq->dma_dev = dma_dev;
+	vq->dma_dev = tp_cfg->dma_dev;
 	vq->use_dma_api = vring_use_dma_api(vdev);
 	vq->premapped = false;
 	vq->do_unmap = vq->use_dma_api;
 
 	vq->indirect = virtio_has_feature(vdev, VIRTIO_RING_F_INDIRECT_DESC) &&
-		!context;
+		!cfg_vq_get(cfg, ctx);
 	vq->event = virtio_has_feature(vdev, VIRTIO_RING_F_EVENT_IDX);
 
 	if (virtio_has_feature(vdev, VIRTIO_F_ORDER_PLATFORM))
@@ -2667,36 +2652,10 @@ struct virtqueue *vring_create_virtqueue(struct virtio_device *vdev,
 					 struct vq_transport_config *tp_cfg,
 					 struct virtio_vq_config *cfg)
 {
-	struct device *dma_dev;
-	unsigned int num;
-	unsigned int vring_align;
-	bool weak_barriers;
-	bool may_reduce_num;
-	bool context;
-	bool (*notify)(struct virtqueue *_);
-	void (*callback)(struct virtqueue *_);
-	const char *name;
-
-	dma_dev = tp_cfg->dma_dev ? : vdev->dev.parent;
-
-	num            = tp_cfg->num;
-	vring_align    = tp_cfg->vring_align;
-	weak_barriers  = tp_cfg->weak_barriers;
-	may_reduce_num = tp_cfg->may_reduce_num;
-	notify         = tp_cfg->notify;
-
-	name     = cfg->names[cfg->cfg_idx];
-	callback = cfg->callbacks[cfg->cfg_idx];
-	context  = cfg->ctx ? cfg->ctx[cfg->cfg_idx] : false;
-
 	if (virtio_has_feature(vdev, VIRTIO_F_RING_PACKED))
-		return vring_create_virtqueue_packed(index, num, vring_align,
-				vdev, weak_barriers, may_reduce_num,
-				context, notify, callback, name, dma_dev);
+		return vring_create_virtqueue_packed(vdev, index, tp_cfg, cfg);
 
-	return vring_create_virtqueue_split(index, num, vring_align,
-			vdev, weak_barriers, may_reduce_num,
-			context, notify, callback, name, dma_dev);
+	return vring_create_virtqueue_split(vdev, index, tp_cfg, cfg);
 }
 EXPORT_SYMBOL_GPL(vring_create_virtqueue);
 
@@ -2842,30 +2801,14 @@ struct virtqueue *vring_new_virtqueue(struct virtio_device *vdev,
 				      struct virtio_vq_config *cfg)
 {
 	struct vring_virtqueue_split vring_split = {};
-	unsigned int num;
-	unsigned int vring_align;
-	bool weak_barriers;
-	bool context;
-	bool (*notify)(struct virtqueue *_);
-	void (*callback)(struct virtqueue *_);
-	const char *name;
-
-	num            = tp_cfg->num;
-	vring_align    = tp_cfg->vring_align;
-	weak_barriers  = tp_cfg->weak_barriers;
-	notify         = tp_cfg->notify;
-
-	name     = cfg->names[cfg->cfg_idx];
-	callback = cfg->callbacks[cfg->cfg_idx];
-	context  = cfg->ctx ? cfg->ctx[cfg->cfg_idx] : false;
 
 	if (virtio_has_feature(vdev, VIRTIO_F_RING_PACKED))
 		return NULL;
 
-	vring_init(&vring_split.vring, num, pages, vring_align);
-	return __vring_new_virtqueue(index, &vring_split, vdev, weak_barriers,
-				     context, notify, callback, name,
-				     vdev->dev.parent);
+	tp_cfg->dma_dev = vdev->dev.parent;
+
+	vring_init(&vring_split.vring, tp_cfg->num, pages, tp_cfg->vring_align);
+	return __vring_new_virtqueue(vdev, index, &vring_split, tp_cfg, cfg);
 }
 EXPORT_SYMBOL_GPL(vring_new_virtqueue);
 
-- 
2.32.0.3.g01195cf9f


