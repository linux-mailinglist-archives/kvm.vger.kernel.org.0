Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 06E5C6C8631
	for <lists+kvm@lfdr.de>; Fri, 24 Mar 2023 20:50:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231899AbjCXTuv (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 24 Mar 2023 15:50:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55246 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231891AbjCXTut (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 24 Mar 2023 15:50:49 -0400
Received: from mail-lf1-x129.google.com (mail-lf1-x129.google.com [IPv6:2a00:1450:4864:20::129])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2CC7619C4C
        for <kvm@vger.kernel.org>; Fri, 24 Mar 2023 12:50:38 -0700 (PDT)
Received: by mail-lf1-x129.google.com with SMTP id br6so3584128lfb.11
        for <kvm@vger.kernel.org>; Fri, 24 Mar 2023 12:50:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=daynix-com.20210112.gappssmtp.com; s=20210112; t=1679687436;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=2Yw8aFsO52nF+rCwkiyobvl69eUncIFVtLSBaTu9azE=;
        b=j6jff6epBcmgpWZzr6Mt4fo1JsP01f32arVrxjAkaSC5wFGzaZyAdq2zMj7mb/PTdh
         0OzYz9mESkbBxCpeuK39NQJTQI+dhTUDSv+8GC/8lLDOxF1+Jg5Ef7gbjlwjJQssNkZ4
         s8Z8OM1IC1AJv+yrkTyviHWcDBDADHX1czDoDx2Wn3QdQZXptwIqe6mzmvhibgvSvsOd
         g0XtmqMsoGc/N7Bi3bGtaZ8WSHMq79vDh6/U6MVgA4pUeIXfu2TI1SIg3+GqEF/WIIl0
         Qyul0WtoCGDrbnBp+grjJ0yXNO9ra71E2CxyFvxLOMbGdOWbzOj6lLaQpOEMbaiv3Gea
         DGJw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679687436;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=2Yw8aFsO52nF+rCwkiyobvl69eUncIFVtLSBaTu9azE=;
        b=AuMcJ1Fhkd9oa4WLxdmf0cqntbtxOPh8lF2xQOk5PcLJ5sF8g4X6OXNZCzaMwbfgWA
         JgP557U7QJ1WBoy/gAgvudC+OZSrmJKjgw0zGBV1rPaO53NxqU5diDl2QKv3vR2t4lSf
         1axiEfVelhY/5XzQff0r5Gc7Fs/StoQVHBqUizGDkKVk1ElTRE8ivdutm3904YZu9wQ1
         mj5MQOXtLTz+qZm1giZdv6MImqOp9z109GWin5y3o17UQXZo+iHKNHlVmxX3x1Ien1pr
         mOv/dSE4Ep04WNLkRmCnQvrT66zvvtsot+jMbA6hHsfmd/x+MniR6FXTYFU6KTOadGVv
         co8A==
X-Gm-Message-State: AAQBX9exYNGjkCDLtYQnhLL9H4qk81cFfTY29/qvcdA08hMa1DyI5AGz
        JOJGJtxJ+2mPtXTLlPrTRnYfrA==
X-Google-Smtp-Source: AKy350bUox4jMX8WDd8OT9XknY5+QOLfcn69cZ0KHubEUzso4Fj26uq9efyRVcRKrDtp9MOWavheWA==
X-Received: by 2002:ac2:4c13:0:b0:4e9:2c0e:c39d with SMTP id t19-20020ac24c13000000b004e92c0ec39dmr879285lfq.41.1679687436084;
        Fri, 24 Mar 2023 12:50:36 -0700 (PDT)
Received: from vp-pc.. (109-252-122-203.nat.spd-mgts.ru. [109.252.122.203])
        by smtp.gmail.com with ESMTPSA id 15-20020ac2484f000000b004eaf6d7228bsm1136021lfy.110.2023.03.24.12.50.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 24 Mar 2023 12:50:35 -0700 (PDT)
From:   Viktor Prutyanov <viktor@daynix.com>
To:     mst@redhat.com, jasowang@redhat.com
Cc:     cohuck@redhat.com, pasic@linux.ibm.com, farman@linux.ibm.com,
        linux-s390@vger.kernel.org, kvm@vger.kernel.org,
        virtualization@lists.linux-foundation.org,
        linux-kernel@vger.kernel.org, yan@daynix.com, viktor@daynix.com
Subject: [PATCH v6] virtio: add VIRTIO_F_NOTIFICATION_DATA feature support
Date:   Fri, 24 Mar 2023 22:50:29 +0300
Message-Id: <20230324195029.2410503-1-viktor@daynix.com>
X-Mailer: git-send-email 2.35.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=0.0 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

According to VirtIO spec v1.2, VIRTIO_F_NOTIFICATION_DATA feature
indicates that the driver passes extra data along with the queue
notifications.

In a split queue case, the extra data is 16-bit available index. In a
packed queue case, the extra data is 1-bit wrap counter and 15-bit
available index.

Add support for this feature for MMIO, channel I/O and modern PCI
transports.

Signed-off-by: Viktor Prutyanov <viktor@daynix.com>
Acked-by: Jason Wang <jasowang@redhat.com>
Reviewed-by: Xuan Zhuo <xuanzhuo@linux.alibaba.com>
---
 v6: use VRING_PACKED_EVENT_F_WRAP_CTR
 v5: replace ternary operator with if-else
 v4: remove VP_NOTIFY macro and legacy PCI support, add
    virtio_ccw_kvm_notify_with_data to virtio_ccw
 v3: support feature in virtio_ccw, remove VM_NOTIFY, use avail_idx_shadow,
    remove byte swap, rename to vring_notification_data
 v2: reject the feature in virtio_ccw, replace __le32 with u32

 Tested with disabled VIRTIO_F_NOTIFICATION_DATA on qemu-system-s390x
 (virtio-blk-ccw), qemu-system-riscv64 (virtio-blk-device,
 virtio-rng-device), qemu-system-x86_64 (virtio-blk-pci, virtio-net-pci)
 to make sure nothing is broken.
 Tested with enabled VIRTIO_F_NOTIFICATION_DATA on 64-bit RISC-V Linux
 and my hardware implementation of virtio-rng with MMIO.

 drivers/s390/virtio/virtio_ccw.c   | 22 +++++++++++++++++++---
 drivers/virtio/virtio_mmio.c       | 18 +++++++++++++++++-
 drivers/virtio/virtio_pci_modern.c | 17 ++++++++++++++++-
 drivers/virtio/virtio_ring.c       | 19 +++++++++++++++++++
 include/linux/virtio_ring.h        |  2 ++
 include/uapi/linux/virtio_config.h |  6 ++++++
 6 files changed, 79 insertions(+), 5 deletions(-)

diff --git a/drivers/s390/virtio/virtio_ccw.c b/drivers/s390/virtio/virtio_ccw.c
index 954fc31b4bc7..02922768b129 100644
--- a/drivers/s390/virtio/virtio_ccw.c
+++ b/drivers/s390/virtio/virtio_ccw.c
@@ -391,7 +391,7 @@ static void virtio_ccw_drop_indicator(struct virtio_ccw_device *vcdev,
 	ccw_device_dma_free(vcdev->cdev, thinint_area, sizeof(*thinint_area));
 }
 
-static bool virtio_ccw_kvm_notify(struct virtqueue *vq)
+static inline bool virtio_ccw_do_kvm_notify(struct virtqueue *vq, u32 data)
 {
 	struct virtio_ccw_vq_info *info = vq->priv;
 	struct virtio_ccw_device *vcdev;
@@ -402,12 +402,22 @@ static bool virtio_ccw_kvm_notify(struct virtqueue *vq)
 	BUILD_BUG_ON(sizeof(struct subchannel_id) != sizeof(unsigned int));
 	info->cookie = kvm_hypercall3(KVM_S390_VIRTIO_CCW_NOTIFY,
 				      *((unsigned int *)&schid),
-				      vq->index, info->cookie);
+				      data, info->cookie);
 	if (info->cookie < 0)
 		return false;
 	return true;
 }
 
+static bool virtio_ccw_kvm_notify(struct virtqueue *vq)
+{
+	return virtio_ccw_do_kvm_notify(vq, vq->index);
+}
+
+static bool virtio_ccw_kvm_notify_with_data(struct virtqueue *vq)
+{
+	return virtio_ccw_do_kvm_notify(vq, vring_notification_data(vq));
+}
+
 static int virtio_ccw_read_vq_conf(struct virtio_ccw_device *vcdev,
 				   struct ccw1 *ccw, int index)
 {
@@ -495,6 +505,7 @@ static struct virtqueue *virtio_ccw_setup_vq(struct virtio_device *vdev,
 					     struct ccw1 *ccw)
 {
 	struct virtio_ccw_device *vcdev = to_vc_device(vdev);
+	bool (*notify)(struct virtqueue *vq);
 	int err;
 	struct virtqueue *vq = NULL;
 	struct virtio_ccw_vq_info *info;
@@ -502,6 +513,11 @@ static struct virtqueue *virtio_ccw_setup_vq(struct virtio_device *vdev,
 	unsigned long flags;
 	bool may_reduce;
 
+	if (__virtio_test_bit(vdev, VIRTIO_F_NOTIFICATION_DATA))
+		notify = virtio_ccw_kvm_notify_with_data;
+	else
+		notify = virtio_ccw_kvm_notify;
+
 	/* Allocate queue. */
 	info = kzalloc(sizeof(struct virtio_ccw_vq_info), GFP_KERNEL);
 	if (!info) {
@@ -524,7 +540,7 @@ static struct virtqueue *virtio_ccw_setup_vq(struct virtio_device *vdev,
 	may_reduce = vcdev->revision > 0;
 	vq = vring_create_virtqueue(i, info->num, KVM_VIRTIO_CCW_RING_ALIGN,
 				    vdev, true, may_reduce, ctx,
-				    virtio_ccw_kvm_notify, callback, name);
+				    notify, callback, name);
 
 	if (!vq) {
 		/* For now, we fail if we can't get the requested size. */
diff --git a/drivers/virtio/virtio_mmio.c b/drivers/virtio/virtio_mmio.c
index 3ff746e3f24a..dd4424c14233 100644
--- a/drivers/virtio/virtio_mmio.c
+++ b/drivers/virtio/virtio_mmio.c
@@ -285,6 +285,16 @@ static bool vm_notify(struct virtqueue *vq)
 	return true;
 }
 
+static bool vm_notify_with_data(struct virtqueue *vq)
+{
+	struct virtio_mmio_device *vm_dev = to_virtio_mmio_device(vq->vdev);
+	u32 data = vring_notification_data(vq);
+
+	writel(data, vm_dev->base + VIRTIO_MMIO_QUEUE_NOTIFY);
+
+	return true;
+}
+
 /* Notify all virtqueues on an interrupt. */
 static irqreturn_t vm_interrupt(int irq, void *opaque)
 {
@@ -363,12 +373,18 @@ static struct virtqueue *vm_setup_vq(struct virtio_device *vdev, unsigned int in
 				  const char *name, bool ctx)
 {
 	struct virtio_mmio_device *vm_dev = to_virtio_mmio_device(vdev);
+	bool (*notify)(struct virtqueue *vq);
 	struct virtio_mmio_vq_info *info;
 	struct virtqueue *vq;
 	unsigned long flags;
 	unsigned int num;
 	int err;
 
+	if (__virtio_test_bit(vdev, VIRTIO_F_NOTIFICATION_DATA))
+		notify = vm_notify_with_data;
+	else
+		notify = vm_notify;
+
 	if (!name)
 		return NULL;
 
@@ -397,7 +413,7 @@ static struct virtqueue *vm_setup_vq(struct virtio_device *vdev, unsigned int in
 
 	/* Create the vring */
 	vq = vring_create_virtqueue(index, num, VIRTIO_MMIO_VRING_ALIGN, vdev,
-				 true, true, ctx, vm_notify, callback, name);
+				 true, true, ctx, notify, callback, name);
 	if (!vq) {
 		err = -ENOMEM;
 		goto error_new_virtqueue;
diff --git a/drivers/virtio/virtio_pci_modern.c b/drivers/virtio/virtio_pci_modern.c
index 9e496e288cfa..05deba5153bd 100644
--- a/drivers/virtio/virtio_pci_modern.c
+++ b/drivers/virtio/virtio_pci_modern.c
@@ -288,6 +288,15 @@ static u16 vp_config_vector(struct virtio_pci_device *vp_dev, u16 vector)
 	return vp_modern_config_vector(&vp_dev->mdev, vector);
 }
 
+static bool vp_notify_with_data(struct virtqueue *vq)
+{
+	u32 data = vring_notification_data(vq);
+
+	iowrite32(data, (void __iomem *)vq->priv);
+
+	return true;
+}
+
 static struct virtqueue *setup_vq(struct virtio_pci_device *vp_dev,
 				  struct virtio_pci_vq_info *info,
 				  unsigned int index,
@@ -298,10 +307,16 @@ static struct virtqueue *setup_vq(struct virtio_pci_device *vp_dev,
 {
 
 	struct virtio_pci_modern_device *mdev = &vp_dev->mdev;
+	bool (*notify)(struct virtqueue *vq);
 	struct virtqueue *vq;
 	u16 num;
 	int err;
 
+	if (__virtio_test_bit(&vp_dev->vdev, VIRTIO_F_NOTIFICATION_DATA))
+		notify = vp_notify_with_data;
+	else
+		notify = vp_notify;
+
 	if (index >= vp_modern_get_num_queues(mdev))
 		return ERR_PTR(-EINVAL);
 
@@ -321,7 +336,7 @@ static struct virtqueue *setup_vq(struct virtio_pci_device *vp_dev,
 	vq = vring_create_virtqueue(index, num,
 				    SMP_CACHE_BYTES, &vp_dev->vdev,
 				    true, true, ctx,
-				    vp_notify, callback, name);
+				    notify, callback, name);
 	if (!vq)
 		return ERR_PTR(-ENOMEM);
 
diff --git a/drivers/virtio/virtio_ring.c b/drivers/virtio/virtio_ring.c
index 4c3bb0ddeb9b..f9c6604352b4 100644
--- a/drivers/virtio/virtio_ring.c
+++ b/drivers/virtio/virtio_ring.c
@@ -2752,6 +2752,23 @@ void vring_del_virtqueue(struct virtqueue *_vq)
 }
 EXPORT_SYMBOL_GPL(vring_del_virtqueue);
 
+u32 vring_notification_data(struct virtqueue *_vq)
+{
+	struct vring_virtqueue *vq = to_vvq(_vq);
+	u16 next;
+
+	if (vq->packed_ring)
+		next = (vq->packed.next_avail_idx &
+				~(-(1 << VRING_PACKED_EVENT_F_WRAP_CTR))) |
+			vq->packed.avail_wrap_counter <<
+				VRING_PACKED_EVENT_F_WRAP_CTR;
+	else
+		next = vq->split.avail_idx_shadow;
+
+	return next << 16 | _vq->index;
+}
+EXPORT_SYMBOL_GPL(vring_notification_data);
+
 /* Manipulates transport-specific feature bits. */
 void vring_transport_features(struct virtio_device *vdev)
 {
@@ -2771,6 +2788,8 @@ void vring_transport_features(struct virtio_device *vdev)
 			break;
 		case VIRTIO_F_ORDER_PLATFORM:
 			break;
+		case VIRTIO_F_NOTIFICATION_DATA:
+			break;
 		default:
 			/* We don't understand this bit. */
 			__virtio_clear_bit(vdev, i);
diff --git a/include/linux/virtio_ring.h b/include/linux/virtio_ring.h
index 8b95b69ef694..2550c9170f4f 100644
--- a/include/linux/virtio_ring.h
+++ b/include/linux/virtio_ring.h
@@ -117,4 +117,6 @@ void vring_del_virtqueue(struct virtqueue *vq);
 void vring_transport_features(struct virtio_device *vdev);
 
 irqreturn_t vring_interrupt(int irq, void *_vq);
+
+u32 vring_notification_data(struct virtqueue *_vq);
 #endif /* _LINUX_VIRTIO_RING_H */
diff --git a/include/uapi/linux/virtio_config.h b/include/uapi/linux/virtio_config.h
index 3c05162bc988..2c712c654165 100644
--- a/include/uapi/linux/virtio_config.h
+++ b/include/uapi/linux/virtio_config.h
@@ -99,6 +99,12 @@
  */
 #define VIRTIO_F_SR_IOV			37
 
+/*
+ * This feature indicates that the driver passes extra data (besides
+ * identifying the virtqueue) in its device notifications.
+ */
+#define VIRTIO_F_NOTIFICATION_DATA	38
+
 /*
  * This feature indicates that the driver can reset a queue individually.
  */
-- 
2.35.1

