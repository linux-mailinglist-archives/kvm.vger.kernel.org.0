Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0534E6C3322
	for <lists+kvm@lfdr.de>; Tue, 21 Mar 2023 14:44:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231183AbjCUNob (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 21 Mar 2023 09:44:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41608 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229899AbjCUNo3 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 21 Mar 2023 09:44:29 -0400
Received: from mail-lf1-x12c.google.com (mail-lf1-x12c.google.com [IPv6:2a00:1450:4864:20::12c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8335013D4F
        for <kvm@vger.kernel.org>; Tue, 21 Mar 2023 06:44:26 -0700 (PDT)
Received: by mail-lf1-x12c.google.com with SMTP id bi9so19143900lfb.12
        for <kvm@vger.kernel.org>; Tue, 21 Mar 2023 06:44:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=daynix-com.20210112.gappssmtp.com; s=20210112; t=1679406265;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=J74rlYuOkDpXn/1AWoVjA3V64axvEb7X/6Sujjtnzfk=;
        b=5VhooroitN4a2oNceq8aDpEsr/3fXxY726qo4j/WrAqJGU/a9jFZprpjbIvQolwXS/
         Kboam4kWGv9kla+ZRgS1TlVx0DG52MOjhSMWZJJ5nSYB1/lOBkDbq/VMFlDoE0QD0+3X
         Uc1P3gflo8GcMQjCZg8ONlKQG1zjXVLXKuv7j21pMtvBRAwUUJFeTps4ziWH4K0g7LSL
         D+kRoZxpqYblV+6iLlyIVqxf7OmoLv00mVgE8Bh+Xvw3hBdPvcb8tsk/+weWB8zhNeVW
         zmP3Ov33M/KFnDOHAW6F+2xiVsy8j4FyFbcEVxBTDqX804NVuHIQXZef51rtUlGgHBxu
         HA5A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679406265;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=J74rlYuOkDpXn/1AWoVjA3V64axvEb7X/6Sujjtnzfk=;
        b=GaJfp1L24+XFaVQ1J84vSbF2NWeP5LF8dnpTCrowdJ72LgpIeUJgKA0FG5fD5Do0jQ
         wuMWzPOE0TLP5Wkm64pYXy5zNGaZ8Ma+RCYWijbUXxVKdNbQ8VDE3uMoaB0fLddwuvEd
         2H9wtm5YSHj4pSgpt7GLzqTyQTG5InQiu6iN/Gpg2kvE76Ha6Bs/srqT5mmAe+HHOgG+
         3xsQ8JbC+fQQ/MpcIqe5pJZ9cW/yDOj56u41UhdAy/QdnVDsIiRxNHCI2sOSIlp8yP97
         6I7MEZz1SrXJNDQ9VDEa5zDSr2x1ysigmldEk6HWqZYUpfvLN/P1mkiJGqoL85C0Ta55
         V9nA==
X-Gm-Message-State: AO0yUKVgUgdls3jy4bEvmvcl7AurkU2pdHE3YS9ajC4IxA5A33SmqpMa
        oeeUmW13Ecw6U99gkDUXlDPJbA==
X-Google-Smtp-Source: AK7set/ZTlY7nTob+rAGs07LnUHjb7+Rd77ozCWKWk36KH4OwB7C9/RlB76NuDwzIaBTKsK6/NO9tA==
X-Received: by 2002:ac2:411a:0:b0:4df:5cc0:8ad1 with SMTP id b26-20020ac2411a000000b004df5cc08ad1mr733820lfi.28.1679406264735;
        Tue, 21 Mar 2023 06:44:24 -0700 (PDT)
Received: from localhost.localdomain (109-252-122-203.nat.spd-mgts.ru. [109.252.122.203])
        by smtp.gmail.com with ESMTPSA id u29-20020ac251dd000000b004dc4d26c324sm2164126lfm.143.2023.03.21.06.44.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 21 Mar 2023 06:44:24 -0700 (PDT)
From:   Viktor Prutyanov <viktor@daynix.com>
To:     mst@redhat.com, jasowang@redhat.com
Cc:     cohuck@redhat.com, pasic@linux.ibm.com, farman@linux.ibm.com,
        linux-s390@vger.kernel.org, kvm@vger.kernel.org,
        virtualization@lists.linux-foundation.org,
        linux-kernel@vger.kernel.org, yan@daynix.com, viktor@daynix.com
Subject: [PATCH v3] virtio: add VIRTIO_F_NOTIFICATION_DATA feature support
Date:   Tue, 21 Mar 2023 16:44:10 +0300
Message-Id: <20230321134410.2097163-1-viktor@daynix.com>
X-Mailer: git-send-email 2.35.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE
        autolearn=unavailable autolearn_force=no version=3.4.6
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

Add support for this feature for MMIO, PCI and channel I/O transports.

Signed-off-by: Viktor Prutyanov <viktor@daynix.com>
---
 v3: support feature in virtio_ccw, remove VM_NOTIFY, use avail_idx_shadow,
    remove byte swap, rename to vring_notification_data
 v2: reject the feature in virtio_ccw, replace __le32 with u32

 drivers/s390/virtio/virtio_ccw.c   |  4 +++-
 drivers/virtio/virtio_mmio.c       | 14 +++++++++++++-
 drivers/virtio/virtio_pci_common.c | 10 ++++++++++
 drivers/virtio/virtio_pci_common.h |  4 ++++
 drivers/virtio/virtio_pci_legacy.c |  2 +-
 drivers/virtio/virtio_pci_modern.c |  2 +-
 drivers/virtio/virtio_ring.c       | 17 +++++++++++++++++
 include/linux/virtio_ring.h        |  2 ++
 include/uapi/linux/virtio_config.h |  6 ++++++
 9 files changed, 57 insertions(+), 4 deletions(-)

diff --git a/drivers/s390/virtio/virtio_ccw.c b/drivers/s390/virtio/virtio_ccw.c
index 954fc31b4bc7..c33172c5b8d5 100644
--- a/drivers/s390/virtio/virtio_ccw.c
+++ b/drivers/s390/virtio/virtio_ccw.c
@@ -396,13 +396,15 @@ static bool virtio_ccw_kvm_notify(struct virtqueue *vq)
 	struct virtio_ccw_vq_info *info = vq->priv;
 	struct virtio_ccw_device *vcdev;
 	struct subchannel_id schid;
+	u32 data = __virtio_test_bit(vq->vdev, VIRTIO_F_NOTIFICATION_DATA) ?
+			vring_notification_data(vq) : vq->index;
 
 	vcdev = to_vc_device(info->vq->vdev);
 	ccw_device_get_schid(vcdev->cdev, &schid);
 	BUILD_BUG_ON(sizeof(struct subchannel_id) != sizeof(unsigned int));
 	info->cookie = kvm_hypercall3(KVM_S390_VIRTIO_CCW_NOTIFY,
 				      *((unsigned int *)&schid),
-				      vq->index, info->cookie);
+				      data, info->cookie);
 	if (info->cookie < 0)
 		return false;
 	return true;
diff --git a/drivers/virtio/virtio_mmio.c b/drivers/virtio/virtio_mmio.c
index 3ff746e3f24a..7c16e622c33d 100644
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
@@ -368,6 +378,8 @@ static struct virtqueue *vm_setup_vq(struct virtio_device *vdev, unsigned int in
 	unsigned long flags;
 	unsigned int num;
 	int err;
+	bool (*notify)(struct virtqueue *vq) = __virtio_test_bit(vdev,
+		VIRTIO_F_NOTIFICATION_DATA) ? vm_notify_with_data : vm_notify;
 
 	if (!name)
 		return NULL;
@@ -397,7 +409,7 @@ static struct virtqueue *vm_setup_vq(struct virtio_device *vdev, unsigned int in
 
 	/* Create the vring */
 	vq = vring_create_virtqueue(index, num, VIRTIO_MMIO_VRING_ALIGN, vdev,
-				 true, true, ctx, vm_notify, callback, name);
+				 true, true, ctx, notify, callback, name);
 	if (!vq) {
 		err = -ENOMEM;
 		goto error_new_virtqueue;
diff --git a/drivers/virtio/virtio_pci_common.c b/drivers/virtio/virtio_pci_common.c
index a6c86f916dbd..e915c22f2384 100644
--- a/drivers/virtio/virtio_pci_common.c
+++ b/drivers/virtio/virtio_pci_common.c
@@ -43,6 +43,16 @@ bool vp_notify(struct virtqueue *vq)
 	/* we write the queue's selector into the notification register to
 	 * signal the other end */
 	iowrite16(vq->index, (void __iomem *)vq->priv);
+
+	return true;
+}
+
+bool vp_notify_with_data(struct virtqueue *vq)
+{
+	u32 data = vring_notification_data(vq);
+
+	iowrite32(data, (void __iomem *)vq->priv);
+
 	return true;
 }
 
diff --git a/drivers/virtio/virtio_pci_common.h b/drivers/virtio/virtio_pci_common.h
index 23112d84218f..9a7212dcbb32 100644
--- a/drivers/virtio/virtio_pci_common.h
+++ b/drivers/virtio/virtio_pci_common.h
@@ -105,6 +105,7 @@ static struct virtio_pci_device *to_vp_device(struct virtio_device *vdev)
 void vp_synchronize_vectors(struct virtio_device *vdev);
 /* the notify function used when creating a virt queue */
 bool vp_notify(struct virtqueue *vq);
+bool vp_notify_with_data(struct virtqueue *vq);
 /* the config->del_vqs() implementation */
 void vp_del_vqs(struct virtio_device *vdev);
 /* the config->find_vqs() implementation */
@@ -114,6 +115,9 @@ int vp_find_vqs(struct virtio_device *vdev, unsigned int nvqs,
 		struct irq_affinity *desc);
 const char *vp_bus_name(struct virtio_device *vdev);
 
+#define VP_NOTIFY(vdev) (__virtio_test_bit((vdev), VIRTIO_F_NOTIFICATION_DATA) \
+	? vp_notify : vp_notify_with_data)
+
 /* Setup the affinity for a virtqueue:
  * - force the affinity for per vq vector
  * - OR over all affinities for shared MSI
diff --git a/drivers/virtio/virtio_pci_legacy.c b/drivers/virtio/virtio_pci_legacy.c
index 2257f1b3d8ae..b98e994cae48 100644
--- a/drivers/virtio/virtio_pci_legacy.c
+++ b/drivers/virtio/virtio_pci_legacy.c
@@ -131,7 +131,7 @@ static struct virtqueue *setup_vq(struct virtio_pci_device *vp_dev,
 	vq = vring_create_virtqueue(index, num,
 				    VIRTIO_PCI_VRING_ALIGN, &vp_dev->vdev,
 				    true, false, ctx,
-				    vp_notify, callback, name);
+				    VP_NOTIFY(&vp_dev->vdev), callback, name);
 	if (!vq)
 		return ERR_PTR(-ENOMEM);
 
diff --git a/drivers/virtio/virtio_pci_modern.c b/drivers/virtio/virtio_pci_modern.c
index 9e496e288cfa..7fcd8af5af7e 100644
--- a/drivers/virtio/virtio_pci_modern.c
+++ b/drivers/virtio/virtio_pci_modern.c
@@ -321,7 +321,7 @@ static struct virtqueue *setup_vq(struct virtio_pci_device *vp_dev,
 	vq = vring_create_virtqueue(index, num,
 				    SMP_CACHE_BYTES, &vp_dev->vdev,
 				    true, true, ctx,
-				    vp_notify, callback, name);
+				    VP_NOTIFY(&vp_dev->vdev), callback, name);
 	if (!vq)
 		return ERR_PTR(-ENOMEM);
 
diff --git a/drivers/virtio/virtio_ring.c b/drivers/virtio/virtio_ring.c
index 4c3bb0ddeb9b..837875cc3190 100644
--- a/drivers/virtio/virtio_ring.c
+++ b/drivers/virtio/virtio_ring.c
@@ -2752,6 +2752,21 @@ void vring_del_virtqueue(struct virtqueue *_vq)
 }
 EXPORT_SYMBOL_GPL(vring_del_virtqueue);
 
+u32 vring_notification_data(struct virtqueue *_vq)
+{
+	struct vring_virtqueue *vq = to_vvq(_vq);
+	u16 next;
+
+	if (vq->packed_ring)
+		next = (vq->packed.next_avail_idx & ~(1 << 15)) |
+			vq->packed.avail_wrap_counter << 15;
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
@@ -2771,6 +2786,8 @@ void vring_transport_features(struct virtio_device *vdev)
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

