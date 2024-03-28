Return-Path: <kvm+bounces-12980-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 56B9488F9A3
	for <lists+kvm@lfdr.de>; Thu, 28 Mar 2024 09:05:39 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 79A7A1C2BD6E
	for <lists+kvm@lfdr.de>; Thu, 28 Mar 2024 08:05:38 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B298F58127;
	Thu, 28 Mar 2024 08:04:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b="BtU0S8QA"
X-Original-To: kvm@vger.kernel.org
Received: from out30-119.freemail.mail.aliyun.com (out30-119.freemail.mail.aliyun.com [115.124.30.119])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C87CE57874;
	Thu, 28 Mar 2024 08:04:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=115.124.30.119
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711613048; cv=none; b=jvi+Gd1iqEjJZB32cu7X9bzEFYvH/NTnPtBmbg4hP0DWgw/bIITceDpJQqENAc3gZSQZJj/+L0GRpYmHrIIEhvVXRYOW0PpvD+tLSabwYqSnluFyBCXxvlidkiH25cuQjxiXEye6srLJEHkMpMkaw+qMlnHnS523SlvsQ2pry4w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711613048; c=relaxed/simple;
	bh=crGXTAbQdM5B+cqw9C/5bc1hgbweNhNR6FNPX+JW9po=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version:Content-Type; b=RDiY8XbYLAVBfXQIxOsCPeI+pwS9vj+MDMR5N9CcGYIWxGuz0OehoQouTyUiDhJMZzVphgo70IE2x7e95FRdSlJpMgSEMC4IiauxKFPodgl+r0tLVvLhgxKUXQ42EQoa9ygp4LjaLi7C5SUX4GDkS6J5lQcQ/iB/VJiK4TnJuxE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com; spf=pass smtp.mailfrom=linux.alibaba.com; dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b=BtU0S8QA; arc=none smtp.client-ip=115.124.30.119
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.alibaba.com
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1711613037; h=From:To:Subject:Date:Message-Id:MIME-Version:Content-Type;
	bh=eNiPrJlHVXw2h/n8XNSowSOCGTcqSwKZP7rw6j1Wb/w=;
	b=BtU0S8QAIQZuboLstWxHNt4ebcc67/z8/v2PvkxOxlQxVLUoJhbbQF4jPphK9VugRRQK2I07hFsSbH/SyLQmRFYvGzXbHAn4vZjktzeqOBuC4nhUF1tDbWqajoFfwopWIYBnhocAUYwFxVA/OutEnihePME38882DSX0ZxaRZ/I=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R951e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=ay29a033018046060;MF=xuanzhuo@linux.alibaba.com;NM=1;PH=DS;RN=26;SR=0;TI=SMTPD_---0W3Sgpx._1711613034;
Received: from localhost(mailfrom:xuanzhuo@linux.alibaba.com fp:SMTPD_---0W3Sgpx._1711613034)
          by smtp.aliyun-inc.com;
          Thu, 28 Mar 2024 16:03:55 +0800
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
	David Hildenbrand <david@redhat.com>,
	Jason Wang <jasowang@redhat.com>,
	Xuan Zhuo <xuanzhuo@linux.alibaba.com>,
	linux-um@lists.infradead.org,
	platform-driver-x86@vger.kernel.org,
	linux-remoteproc@vger.kernel.org,
	linux-s390@vger.kernel.org,
	kvm@vger.kernel.org
Subject: [PATCH vhost v7 4/6] virtio: vring_create_virtqueue: pass struct instead of multi parameters
Date: Thu, 28 Mar 2024 16:03:46 +0800
Message-Id: <20240328080348.3620-5-xuanzhuo@linux.alibaba.com>
X-Mailer: git-send-email 2.32.0.3.g01195cf9f
In-Reply-To: <20240328080348.3620-1-xuanzhuo@linux.alibaba.com>
References: <20240328080348.3620-1-xuanzhuo@linux.alibaba.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-Git-Hash: fc2c3bb8a235
Content-Transfer-Encoding: 8bit

Now, we pass multi parameters to vring_create_virtqueue. These parameters
may from transport or from driver.

vring_create_virtqueue is called by many places.
Every time, we try to add a new parameter, that is difficult.

If parameters from the driver, that should directly be passed to vring.
Then the vring can access the config from driver directly.

If parameters from the transport, we squish the parameters to a
structure. That will be helpful to add new parameter.

Signed-off-by: Xuan Zhuo <xuanzhuo@linux.alibaba.com>
Acked-by: Johannes Berg <johannes@sipsolutions.net>
Reviewed-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Acked-by: Jason Wang <jasowang@redhat.com>
---
 arch/um/drivers/virtio_uml.c       | 14 +++++---
 drivers/s390/virtio/virtio_ccw.c   | 14 ++++----
 drivers/virtio/virtio_mmio.c       | 14 ++++----
 drivers/virtio/virtio_pci_legacy.c | 15 ++++----
 drivers/virtio/virtio_pci_modern.c | 15 ++++----
 drivers/virtio/virtio_ring.c       | 57 ++++++++++++------------------
 drivers/virtio/virtio_vdpa.c       | 21 +++++------
 include/linux/virtio_ring.h        | 51 +++++++++++++-------------
 8 files changed, 101 insertions(+), 100 deletions(-)

diff --git a/arch/um/drivers/virtio_uml.c b/arch/um/drivers/virtio_uml.c
index adc619362cc0..1ac8904b53c7 100644
--- a/arch/um/drivers/virtio_uml.c
+++ b/arch/um/drivers/virtio_uml.c
@@ -942,6 +942,7 @@ static struct virtqueue *vu_setup_vq(struct virtio_device *vdev,
 {
 	struct virtio_uml_device *vu_dev = to_virtio_uml_device(vdev);
 	struct platform_device *pdev = vu_dev->pdev;
+	struct vq_transport_config tp_cfg = {};
 	struct virtio_uml_vq_info *info;
 	struct virtqueue *vq;
 	int num = MAX_SUPPORTED_QUEUE_SIZE;
@@ -955,10 +956,15 @@ static struct virtqueue *vu_setup_vq(struct virtio_device *vdev,
 	snprintf(info->name, sizeof(info->name), "%s.%d-%s", pdev->name,
 		 pdev->id, cfg->names[index]);
 
-	vq = vring_create_virtqueue(index, num, PAGE_SIZE, vdev, true, true,
-				    cfg->ctx ? cfg->ctx[index] : false,
-				    vu_notify,
-				    cfg->callbacks[index], info->name);
+	tp_cfg.num = num;
+	tp_cfg.vring_align = PAGE_SIZE;
+	tp_cfg.weak_barriers = true;
+	tp_cfg.may_reduce_num = true;
+	tp_cfg.notify = vu_notify;
+
+	cfg->names[index] = info->name;
+
+	vq = vring_create_virtqueue(vdev, index, &tp_cfg, cfg);
 	if (!vq) {
 		rc = -ENOMEM;
 		goto error_create;
diff --git a/drivers/s390/virtio/virtio_ccw.c b/drivers/s390/virtio/virtio_ccw.c
index 3c78122f00f5..27f904d165ff 100644
--- a/drivers/s390/virtio/virtio_ccw.c
+++ b/drivers/s390/virtio/virtio_ccw.c
@@ -503,6 +503,7 @@ static struct virtqueue *virtio_ccw_setup_vq(struct virtio_device *vdev,
 					     struct virtio_vq_config *cfg)
 {
 	struct virtio_ccw_device *vcdev = to_vc_device(vdev);
+	struct vq_transport_config tp_cfg = {};
 	bool (*notify)(struct virtqueue *vq);
 	int err;
 	struct virtqueue *vq = NULL;
@@ -536,13 +537,14 @@ static struct virtqueue *virtio_ccw_setup_vq(struct virtio_device *vdev,
 		goto out_err;
 	}
 	may_reduce = vcdev->revision > 0;
-	vq = vring_create_virtqueue(i, info->num, KVM_VIRTIO_CCW_RING_ALIGN,
-				    vdev, true, may_reduce,
-				    cfg->ctx ? cfg->ctx[i] : false,
-				    notify,
-				    cfg->callbacks[i],
-				    cfg->names[i]);
 
+	tp_cfg.num = info->num;
+	tp_cfg.vring_align = KVM_VIRTIO_CCW_RING_ALIGN;
+	tp_cfg.weak_barriers = true;
+	tp_cfg.may_reduce_num = may_reduce;
+	tp_cfg.notify = notify;
+
+	vq = vring_create_virtqueue(vdev, i, &tp_cfg, cfg);
 	if (!vq) {
 		/* For now, we fail if we can't get the requested size. */
 		dev_warn(&vcdev->cdev->dev, "no vq\n");
diff --git a/drivers/virtio/virtio_mmio.c b/drivers/virtio/virtio_mmio.c
index 7f0fdc3f51cb..2820a9abe8f7 100644
--- a/drivers/virtio/virtio_mmio.c
+++ b/drivers/virtio/virtio_mmio.c
@@ -373,6 +373,7 @@ static struct virtqueue *vm_setup_vq(struct virtio_device *vdev, unsigned int in
 				     struct virtio_vq_config *cfg)
 {
 	struct virtio_mmio_device *vm_dev = to_virtio_mmio_device(vdev);
+	struct vq_transport_config tp_cfg = {};
 	bool (*notify)(struct virtqueue *vq);
 	struct virtio_mmio_vq_info *info;
 	struct virtqueue *vq;
@@ -408,13 +409,14 @@ static struct virtqueue *vm_setup_vq(struct virtio_device *vdev, unsigned int in
 		goto error_new_virtqueue;
 	}
 
+	tp_cfg.num = num;
+	tp_cfg.vring_align = VIRTIO_MMIO_VRING_ALIGN;
+	tp_cfg.weak_barriers = true;
+	tp_cfg.may_reduce_num = true;
+	tp_cfg.notify = notify;
+
 	/* Create the vring */
-	vq = vring_create_virtqueue(index, num, VIRTIO_MMIO_VRING_ALIGN, vdev,
-				    true, true,
-				    cfg->ctx ? cfg->ctx[index] : false,
-				    notify,
-				    cfg->callbacks[index],
-				    cfg->names[index]);
+	vq = vring_create_virtqueue(vdev, index, &tp_cfg, cfg);
 	if (!vq) {
 		err = -ENOMEM;
 		goto error_new_virtqueue;
diff --git a/drivers/virtio/virtio_pci_legacy.c b/drivers/virtio/virtio_pci_legacy.c
index a8de653dd7a7..6fe675b2a5e5 100644
--- a/drivers/virtio/virtio_pci_legacy.c
+++ b/drivers/virtio/virtio_pci_legacy.c
@@ -113,6 +113,7 @@ static struct virtqueue *setup_vq(struct virtio_pci_device *vp_dev,
 				  struct virtio_vq_config *cfg,
 				  u16 msix_vec)
 {
+	struct vq_transport_config tp_cfg = {};
 	struct virtqueue *vq;
 	u16 num;
 	int err;
@@ -125,14 +126,14 @@ static struct virtqueue *setup_vq(struct virtio_pci_device *vp_dev,
 
 	info->msix_vector = msix_vec;
 
+	tp_cfg.num = num;
+	tp_cfg.vring_align = VIRTIO_PCI_VRING_ALIGN;
+	tp_cfg.weak_barriers = true;
+	tp_cfg.may_reduce_num = false;
+	tp_cfg.notify = vp_notify;
+
 	/* create the vring */
-	vq = vring_create_virtqueue(index, num,
-				    VIRTIO_PCI_VRING_ALIGN, &vp_dev->vdev,
-				    true, false,
-				    cfg->ctx ? cfg->ctx[index] : false,
-				    vp_notify,
-				    cfg->callbacks[index],
-				    cfg->names[index]);
+	vq = vring_create_virtqueue(&vp_dev->vdev, index, &tp_cfg, cfg);
 	if (!vq)
 		return ERR_PTR(-ENOMEM);
 
diff --git a/drivers/virtio/virtio_pci_modern.c b/drivers/virtio/virtio_pci_modern.c
index bcb829ffec64..12130027d0c0 100644
--- a/drivers/virtio/virtio_pci_modern.c
+++ b/drivers/virtio/virtio_pci_modern.c
@@ -535,6 +535,7 @@ static struct virtqueue *setup_vq(struct virtio_pci_device *vp_dev,
 {
 
 	struct virtio_pci_modern_device *mdev = &vp_dev->mdev;
+	struct vq_transport_config tp_cfg = {};
 	bool (*notify)(struct virtqueue *vq);
 	struct virtqueue *vq;
 	bool is_avq;
@@ -558,14 +559,14 @@ static struct virtqueue *setup_vq(struct virtio_pci_device *vp_dev,
 
 	info->msix_vector = msix_vec;
 
+	tp_cfg.num = num;
+	tp_cfg.vring_align = SMP_CACHE_BYTES;
+	tp_cfg.weak_barriers = true;
+	tp_cfg.may_reduce_num = true;
+	tp_cfg.notify = notify;
+
 	/* create the vring */
-	vq = vring_create_virtqueue(index, num,
-				    SMP_CACHE_BYTES, &vp_dev->vdev,
-				    true, true,
-				    cfg->ctx ? cfg->ctx[index] : false,
-				    notify,
-				    cfg->callbacks[index],
-				    cfg->names[index]);
+	vq = vring_create_virtqueue(&vp_dev->vdev, index, &tp_cfg, cfg);
 	if (!vq)
 		return ERR_PTR(-ENOMEM);
 
diff --git a/drivers/virtio/virtio_ring.c b/drivers/virtio/virtio_ring.c
index 6f7e5010a673..b0e19a84644c 100644
--- a/drivers/virtio/virtio_ring.c
+++ b/drivers/virtio/virtio_ring.c
@@ -2662,43 +2662,32 @@ static struct virtqueue *__vring_new_virtqueue(unsigned int index,
 	return &vq->vq;
 }
 
-struct virtqueue *vring_create_virtqueue(
-	unsigned int index,
-	unsigned int num,
-	unsigned int vring_align,
-	struct virtio_device *vdev,
-	bool weak_barriers,
-	bool may_reduce_num,
-	bool context,
-	bool (*notify)(struct virtqueue *),
-	void (*callback)(struct virtqueue *),
-	const char *name)
+struct virtqueue *vring_create_virtqueue(struct virtio_device *vdev,
+					 unsigned int index,
+					 struct vq_transport_config *tp_cfg,
+					 struct virtio_vq_config *cfg)
 {
+	struct device *dma_dev;
+	unsigned int num;
+	unsigned int vring_align;
+	bool weak_barriers;
+	bool may_reduce_num;
+	bool context;
+	bool (*notify)(struct virtqueue *_);
+	void (*callback)(struct virtqueue *_);
+	const char *name;
 
-	if (virtio_has_feature(vdev, VIRTIO_F_RING_PACKED))
-		return vring_create_virtqueue_packed(index, num, vring_align,
-				vdev, weak_barriers, may_reduce_num,
-				context, notify, callback, name, vdev->dev.parent);
+	dma_dev = tp_cfg->dma_dev ? : vdev->dev.parent;
 
-	return vring_create_virtqueue_split(index, num, vring_align,
-			vdev, weak_barriers, may_reduce_num,
-			context, notify, callback, name, vdev->dev.parent);
-}
-EXPORT_SYMBOL_GPL(vring_create_virtqueue);
+	num            = tp_cfg->num;
+	vring_align    = tp_cfg->vring_align;
+	weak_barriers  = tp_cfg->weak_barriers;
+	may_reduce_num = tp_cfg->may_reduce_num;
+	notify         = tp_cfg->notify;
 
-struct virtqueue *vring_create_virtqueue_dma(
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
-{
+	name     = cfg->names[index];
+	callback = cfg->callbacks[index];
+	context  = cfg->ctx ? cfg->ctx[index] : false;
 
 	if (virtio_has_feature(vdev, VIRTIO_F_RING_PACKED))
 		return vring_create_virtqueue_packed(index, num, vring_align,
@@ -2709,7 +2698,7 @@ struct virtqueue *vring_create_virtqueue_dma(
 			vdev, weak_barriers, may_reduce_num,
 			context, notify, callback, name, dma_dev);
 }
-EXPORT_SYMBOL_GPL(vring_create_virtqueue_dma);
+EXPORT_SYMBOL_GPL(vring_create_virtqueue);
 
 /**
  * virtqueue_resize - resize the vring of vq
diff --git a/drivers/virtio/virtio_vdpa.c b/drivers/virtio/virtio_vdpa.c
index 6e7aafb42100..965936771645 100644
--- a/drivers/virtio/virtio_vdpa.c
+++ b/drivers/virtio/virtio_vdpa.c
@@ -146,8 +146,8 @@ virtio_vdpa_setup_vq(struct virtio_device *vdev, unsigned int index,
 {
 	struct virtio_vdpa_device *vd_dev = to_virtio_vdpa_device(vdev);
 	struct vdpa_device *vdpa = vd_get_vdpa(vdev);
-	struct device *dma_dev;
 	const struct vdpa_config_ops *ops = vdpa->config;
+	struct vq_transport_config tp_cfg = {};
 	struct virtio_vdpa_vq_info *info;
 	bool (*notify)(struct virtqueue *vq) = virtio_vdpa_notify;
 	struct vdpa_callback cb;
@@ -198,16 +198,17 @@ virtio_vdpa_setup_vq(struct virtio_device *vdev, unsigned int index,
 	align = ops->get_vq_align(vdpa);
 
 	if (ops->get_vq_dma_dev)
-		dma_dev = ops->get_vq_dma_dev(vdpa, index);
+		tp_cfg.dma_dev = ops->get_vq_dma_dev(vdpa, index);
 	else
-		dma_dev = vdpa_get_dma_dev(vdpa);
-	vq = vring_create_virtqueue_dma(index, max_num, align, vdev,
-					true, may_reduce_num,
-					cfg->ctx ? cfg->ctx[index] : false,
-					notify,
-					cfg->callbacks[index],
-					cfg->names[index],
-					dma_dev);
+		tp_cfg.dma_dev = vdpa_get_dma_dev(vdpa);
+
+	tp_cfg.num = max_num;
+	tp_cfg.vring_align = align;
+	tp_cfg.weak_barriers = true;
+	tp_cfg.may_reduce_num = may_reduce_num;
+	tp_cfg.notify = notify;
+
+	vq = vring_create_virtqueue(vdev, index, &tp_cfg, cfg);
 	if (!vq) {
 		err = -ENOMEM;
 		goto error_new_virtqueue;
diff --git a/include/linux/virtio_ring.h b/include/linux/virtio_ring.h
index 9b33df741b63..0a81f7f025ce 100644
--- a/include/linux/virtio_ring.h
+++ b/include/linux/virtio_ring.h
@@ -5,6 +5,7 @@
 #include <asm/barrier.h>
 #include <linux/irqreturn.h>
 #include <uapi/linux/virtio_ring.h>
+#include <linux/virtio_config.h>
 
 /*
  * Barriers in virtio are tricky.  Non-SMP virtio guests can't assume
@@ -60,38 +61,36 @@ struct virtio_device;
 struct virtqueue;
 struct device;
 
+/**
+ * struct vq_transport_config - Configuration for creating a new virtqueue (vq)
+ * @num: Number of descriptors in this virtqueue.
+ * @vring_align: Alignment size of this virtqueue's ring.
+ * @weak_barriers: Memory barrier strategy used within virtio_[rw]mb() to
+ *	enforce ordering of memory operations.
+ * @may_reduce_num: Indicates whether the number of descriptors can be reduced
+ *	if vring allocation fails.
+ * @notify: Callback function used to notify the device of certain events.
+ * @dma_dev: DMA device associated with this virtqueue, used by the DMA API.
+ */
+struct vq_transport_config {
+	unsigned int num;
+	unsigned int vring_align;
+	bool weak_barriers;
+	bool may_reduce_num;
+	bool (*notify)(struct virtqueue *vq);
+	struct device *dma_dev;
+};
+
 /*
  * Creates a virtqueue and allocates the descriptor ring.  If
  * may_reduce_num is set, then this may allocate a smaller ring than
  * expected.  The caller should query virtqueue_get_vring_size to learn
  * the actual size of the ring.
  */
-struct virtqueue *vring_create_virtqueue(unsigned int index,
-					 unsigned int num,
-					 unsigned int vring_align,
-					 struct virtio_device *vdev,
-					 bool weak_barriers,
-					 bool may_reduce_num,
-					 bool ctx,
-					 bool (*notify)(struct virtqueue *vq),
-					 void (*callback)(struct virtqueue *vq),
-					 const char *name);
-
-/*
- * Creates a virtqueue and allocates the descriptor ring with per
- * virtqueue DMA device.
- */
-struct virtqueue *vring_create_virtqueue_dma(unsigned int index,
-					     unsigned int num,
-					     unsigned int vring_align,
-					     struct virtio_device *vdev,
-					     bool weak_barriers,
-					     bool may_reduce_num,
-					     bool ctx,
-					     bool (*notify)(struct virtqueue *vq),
-					     void (*callback)(struct virtqueue *vq),
-					     const char *name,
-					     struct device *dma_dev);
+struct virtqueue *vring_create_virtqueue(struct virtio_device *vdev,
+					 unsigned int index,
+					 struct vq_transport_config *tp_cfg,
+					 struct virtio_vq_config *cfg);
 
 /*
  * Creates a virtqueue with a standard layout but a caller-allocated
-- 
2.32.0.3.g01195cf9f


