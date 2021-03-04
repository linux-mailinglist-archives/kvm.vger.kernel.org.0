Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 198A632D42E
	for <lists+kvm@lfdr.de>; Thu,  4 Mar 2021 14:30:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241337AbhCDN3Y (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 4 Mar 2021 08:29:24 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:41864 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S238735AbhCDN24 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 4 Mar 2021 08:28:56 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1614864451;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=3DM/uYG0+41nMrPMGhgqVHr9MfuAA3kvziMhA3H7WNQ=;
        b=Vg5UzjUOqshU65XXFtVx94fmxqgZudnBF8VzrWEmIdeLGGxN/YJZNquEk8QygIWFF3T9IK
        1GYs4C1YvFGLiBWoIhl1k+RB99I+1C0xxUwWN7LtH8dGRZdADZ0F+11tVYuoXDNnhG9kxw
        rIGOCGHcamXvydsjqWTVCf6of1no+R0=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-311-C24VAaX8Osa_hUUW77Wr1g-1; Thu, 04 Mar 2021 08:27:29 -0500
X-MC-Unique: C24VAaX8Osa_hUUW77Wr1g-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id B273094EF4;
        Thu,  4 Mar 2021 13:27:27 +0000 (UTC)
Received: from gondolin.redhat.com (ovpn-114-163.ams2.redhat.com [10.36.114.163])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 0B36F17C76;
        Thu,  4 Mar 2021 13:27:25 +0000 (UTC)
From:   Cornelia Huck <cohuck@redhat.com>
To:     Halil Pasic <pasic@linux.ibm.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Jason Wang <jasowang@redhat.com>
Cc:     linux-s390@vger.kernel.org,
        virtualization@lists.linux-foundation.org, kvm@vger.kernel.org,
        Cornelia Huck <cohuck@redhat.com>
Subject: [PATCH RFC 2/2] virtio/s390: make legacy support configurable
Date:   Thu,  4 Mar 2021 14:27:15 +0100
Message-Id: <20210304132715.1587211-3-cohuck@redhat.com>
In-Reply-To: <20210304132715.1587211-1-cohuck@redhat.com>
References: <20210304132715.1587211-1-cohuck@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

We may want to remove legacy virtio support in the future. In order
to prepare virtio-ccw for that, add an option to disable legacy
support there. This means raising the minimum transport revision
to 1.

Signed-off-by: Cornelia Huck <cohuck@redhat.com>
---
 arch/s390/Kconfig                       |  11 ++
 drivers/s390/virtio/Makefile            |   1 +
 drivers/s390/virtio/virtio_ccw.c        | 160 ++++++------------------
 drivers/s390/virtio/virtio_ccw_common.h | 113 +++++++++++++++++
 drivers/s390/virtio/virtio_ccw_legacy.c | 138 ++++++++++++++++++++
 drivers/virtio/Kconfig                  |   8 ++
 6 files changed, 312 insertions(+), 119 deletions(-)
 create mode 100644 drivers/s390/virtio/virtio_ccw_common.h
 create mode 100644 drivers/s390/virtio/virtio_ccw_legacy.c

diff --git a/arch/s390/Kconfig b/arch/s390/Kconfig
index e8f7216f6c63..b2743dcf5b36 100644
--- a/arch/s390/Kconfig
+++ b/arch/s390/Kconfig
@@ -941,6 +941,17 @@ config S390_GUEST
 	  Select this option if you want to run the kernel as a guest under
 	  the KVM hypervisor.
 
+config VIRTIO_CCW_LEGACY
+	def_bool y
+	prompt "Support for legacy virtio-ccw devices"
+	depends on S390_GUEST
+	select VIRTIO_LEGACY
+	help
+	  Enabling this option adds support for virtio-ccw paravirtual device
+	  drivers with legacy support, i.e. it enables transitional a
+	  transitional virtio-ccw driver.
+
+	  If unsure, say Y.
 endmenu
 
 menu "Selftests"
diff --git a/drivers/s390/virtio/Makefile b/drivers/s390/virtio/Makefile
index 2dc4d9aab634..96dd68411d64 100644
--- a/drivers/s390/virtio/Makefile
+++ b/drivers/s390/virtio/Makefile
@@ -4,3 +4,4 @@
 # Copyright IBM Corp. 2008
 
 obj-$(CONFIG_S390_GUEST) += virtio_ccw.o
+obj-$(CONFIG_VIRTIO_CCW_LEGACY) += virtio_ccw_legacy.o
diff --git a/drivers/s390/virtio/virtio_ccw.c b/drivers/s390/virtio/virtio_ccw.c
index 0d3971dbc109..32234b6b9074 100644
--- a/drivers/s390/virtio/virtio_ccw.c
+++ b/drivers/s390/virtio/virtio_ccw.c
@@ -11,11 +11,8 @@
 #include <linux/init.h>
 #include <linux/memblock.h>
 #include <linux/err.h>
-#include <linux/virtio.h>
-#include <linux/virtio_config.h>
 #include <linux/slab.h>
 #include <linux/interrupt.h>
-#include <linux/virtio_ring.h>
 #include <linux/pfn.h>
 #include <linux/async.h>
 #include <linux/wait.h>
@@ -30,16 +27,16 @@
 #include <asm/irq.h>
 #include <asm/cio.h>
 #include <asm/ccwdev.h>
-#include <asm/virtio-ccw.h>
 #include <asm/isc.h>
 #include <asm/airq.h>
+#include "virtio_ccw_common.h"
 
 /*
  * Provide a knob to turn off support for older revisions. This is useful
  * if we want to act as a non-transitional virtio device driver: requiring
  * a minimum revision of 1 turns off support for legacy devices.
  */
-static int min_revision;
+int min_revision = VIRTIO_CCW_REV_MIN;
 
 module_param(min_revision, int, 0444);
 MODULE_PARM_DESC(min_revision, "minimum transport revision to accept");
@@ -53,9 +50,6 @@ struct vq_config_block {
 	__u16 num;
 } __packed;
 
-#define VIRTIO_CCW_CONFIG_SIZE 0x100
-/* same as PCI config space size, should be enough for all drivers */
-
 struct vcdev_dma_area {
 	unsigned long indicators;
 	unsigned long indicators2;
@@ -63,25 +57,6 @@ struct vcdev_dma_area {
 	__u8 status;
 };
 
-struct virtio_ccw_device {
-	struct virtio_device vdev;
-	__u8 config[VIRTIO_CCW_CONFIG_SIZE];
-	struct ccw_device *cdev;
-	__u32 curr_io;
-	int err;
-	unsigned int revision; /* Transport revision */
-	wait_queue_head_t wait_q;
-	spinlock_t lock;
-	struct mutex io_lock; /* Serializes I/O requests */
-	struct list_head virtqueues;
-	bool is_thinint;
-	bool going_away;
-	bool device_lost;
-	unsigned int config_ready;
-	void *airq_info;
-	struct vcdev_dma_area *dma_area;
-};
-
 static inline unsigned long *indicators(struct virtio_ccw_device *vcdev)
 {
 	return &vcdev->dma_area->indicators;
@@ -92,13 +67,6 @@ static inline unsigned long *indicators2(struct virtio_ccw_device *vcdev)
 	return &vcdev->dma_area->indicators2;
 }
 
-struct vq_info_block_legacy {
-	__u64 queue;
-	__u32 align;
-	__u16 index;
-	__u16 num;
-} __packed;
-
 struct vq_info_block {
 	__u64 desc;
 	__u32 res0;
@@ -129,18 +97,6 @@ struct virtio_rev_info {
 /* the highest virtio-ccw revision we support */
 #define VIRTIO_CCW_REV_MAX 2
 
-struct virtio_ccw_vq_info {
-	struct virtqueue *vq;
-	int num;
-	union {
-		struct vq_info_block s;
-		struct vq_info_block_legacy l;
-	} *info_block;
-	int bit_nr;
-	struct list_head node;
-	long cookie;
-};
-
 #define VIRTIO_AIRQ_ISC IO_SCH_ISC /* inherit from subchannel */
 
 #define VIRTIO_IV_BITS (L1_CACHE_BYTES * 8)
@@ -164,40 +120,6 @@ static inline u8 *get_summary_indicator(struct airq_info *info)
 	return summary_indicators + info->summary_indicator_idx;
 }
 
-#define CCW_CMD_SET_VQ 0x13
-#define CCW_CMD_VDEV_RESET 0x33
-#define CCW_CMD_SET_IND 0x43
-#define CCW_CMD_SET_CONF_IND 0x53
-#define CCW_CMD_READ_FEAT 0x12
-#define CCW_CMD_WRITE_FEAT 0x11
-#define CCW_CMD_READ_CONF 0x22
-#define CCW_CMD_WRITE_CONF 0x21
-#define CCW_CMD_WRITE_STATUS 0x31
-#define CCW_CMD_READ_VQ_CONF 0x32
-#define CCW_CMD_READ_STATUS 0x72
-#define CCW_CMD_SET_IND_ADAPTER 0x73
-#define CCW_CMD_SET_VIRTIO_REV 0x83
-
-#define VIRTIO_CCW_DOING_SET_VQ 0x00010000
-#define VIRTIO_CCW_DOING_RESET 0x00040000
-#define VIRTIO_CCW_DOING_READ_FEAT 0x00080000
-#define VIRTIO_CCW_DOING_WRITE_FEAT 0x00100000
-#define VIRTIO_CCW_DOING_READ_CONFIG 0x00200000
-#define VIRTIO_CCW_DOING_WRITE_CONFIG 0x00400000
-#define VIRTIO_CCW_DOING_WRITE_STATUS 0x00800000
-#define VIRTIO_CCW_DOING_SET_IND 0x01000000
-#define VIRTIO_CCW_DOING_READ_VQ_CONF 0x02000000
-#define VIRTIO_CCW_DOING_SET_CONF_IND 0x04000000
-#define VIRTIO_CCW_DOING_SET_IND_ADAPTER 0x08000000
-#define VIRTIO_CCW_DOING_SET_VIRTIO_REV 0x10000000
-#define VIRTIO_CCW_DOING_READ_STATUS 0x20000000
-#define VIRTIO_CCW_INTPARM_MASK 0xffff0000
-
-static struct virtio_ccw_device *to_vc_device(struct virtio_device *vdev)
-{
-	return container_of(vdev, struct virtio_ccw_device, vdev);
-}
-
 static void drop_airq_indicator(struct virtqueue *vq, struct airq_info *info)
 {
 	unsigned long i, flags;
@@ -327,8 +249,8 @@ static int doing_io(struct virtio_ccw_device *vcdev, __u32 flag)
 	return ret;
 }
 
-static int ccw_io_helper(struct virtio_ccw_device *vcdev,
-			 struct ccw1 *ccw, __u32 intparm)
+int ccw_io_helper(struct virtio_ccw_device *vcdev,
+		  struct ccw1 *ccw, __u32 intparm)
 {
 	int ret;
 	unsigned long flags;
@@ -423,7 +345,7 @@ static inline long do_kvm_notify(struct subchannel_id schid,
 	return __do_kvm_notify(schid, queue_index, cookie);
 }
 
-static bool virtio_ccw_kvm_notify(struct virtqueue *vq)
+bool virtio_ccw_kvm_notify(struct virtqueue *vq)
 {
 	struct virtio_ccw_vq_info *info = vq->priv;
 	struct virtio_ccw_device *vcdev;
@@ -437,8 +359,8 @@ static bool virtio_ccw_kvm_notify(struct virtqueue *vq)
 	return true;
 }
 
-static int virtio_ccw_read_vq_conf(struct virtio_ccw_device *vcdev,
-				   struct ccw1 *ccw, int index)
+int virtio_ccw_read_vq_conf(struct virtio_ccw_device *vcdev,
+			    struct ccw1 *ccw, int index)
 {
 	int ret;
 
@@ -457,30 +379,29 @@ static void virtio_ccw_del_vq(struct virtqueue *vq, struct ccw1 *ccw)
 {
 	struct virtio_ccw_device *vcdev = to_vc_device(vq->vdev);
 	struct virtio_ccw_vq_info *info = vq->priv;
+	struct vq_info_block *info_block;
 	unsigned long flags;
 	int ret;
 	unsigned int index = vq->index;
 
+	if (vcdev->revision == 0) {
+		virtio_ccw_del_vq_legacy(vq, ccw);
+		return;
+	}
+
 	/* Remove from our list. */
 	spin_lock_irqsave(&vcdev->lock, flags);
 	list_del(&info->node);
 	spin_unlock_irqrestore(&vcdev->lock, flags);
 
 	/* Release from host. */
-	if (vcdev->revision == 0) {
-		info->info_block->l.queue = 0;
-		info->info_block->l.align = 0;
-		info->info_block->l.index = index;
-		info->info_block->l.num = 0;
-		ccw->count = sizeof(info->info_block->l);
-	} else {
-		info->info_block->s.desc = 0;
-		info->info_block->s.index = index;
-		info->info_block->s.num = 0;
-		info->info_block->s.avail = 0;
-		info->info_block->s.used = 0;
-		ccw->count = sizeof(info->info_block->s);
-	}
+	info_block = info->info_block;
+	info_block->desc = 0;
+	info_block->index = index;
+	info_block->num = 0;
+	info_block->avail = 0;
+	info_block->used = 0;
+	ccw->count = sizeof(*info_block);
 	ccw->cmd_code = CCW_CMD_SET_VQ;
 	ccw->flags = 0;
 	ccw->cda = (__u32)(unsigned long)(info->info_block);
@@ -496,7 +417,7 @@ static void virtio_ccw_del_vq(struct virtqueue *vq, struct ccw1 *ccw)
 
 	vring_del_virtqueue(vq);
 	ccw_device_dma_free(vcdev->cdev, info->info_block,
-			    sizeof(*info->info_block));
+			    sizeof(*info_block));
 	kfree(info);
 }
 
@@ -527,9 +448,13 @@ static struct virtqueue *virtio_ccw_setup_vq(struct virtio_device *vdev,
 	int err;
 	struct virtqueue *vq = NULL;
 	struct virtio_ccw_vq_info *info;
+	struct vq_info_block *info_block;
 	u64 queue;
 	unsigned long flags;
-	bool may_reduce;
+
+	if (vcdev->revision == 0)
+		return virtio_ccw_setup_vq_legacy(vdev, i, callback, name,
+						  ctx, ccw);
 
 	/* Allocate queue. */
 	info = kzalloc(sizeof(struct virtio_ccw_vq_info), GFP_KERNEL);
@@ -539,7 +464,7 @@ static struct virtqueue *virtio_ccw_setup_vq(struct virtio_device *vdev,
 		goto out_err;
 	}
 	info->info_block = ccw_device_dma_zalloc(vcdev->cdev,
-						 sizeof(*info->info_block));
+						 sizeof(struct vq_info_block));
 	if (!info->info_block) {
 		dev_warn(&vcdev->cdev->dev, "no info block\n");
 		err = -ENOMEM;
@@ -550,9 +475,8 @@ static struct virtqueue *virtio_ccw_setup_vq(struct virtio_device *vdev,
 		err = info->num;
 		goto out_err;
 	}
-	may_reduce = vcdev->revision > 0;
 	vq = vring_create_virtqueue(i, info->num, KVM_VIRTIO_CCW_RING_ALIGN,
-				    vdev, true, may_reduce, ctx,
+				    vdev, true, true, ctx,
 				    virtio_ccw_kvm_notify, callback, name);
 
 	if (!vq) {
@@ -566,20 +490,13 @@ static struct virtqueue *virtio_ccw_setup_vq(struct virtio_device *vdev,
 
 	/* Register it with the host. */
 	queue = virtqueue_get_desc_addr(vq);
-	if (vcdev->revision == 0) {
-		info->info_block->l.queue = queue;
-		info->info_block->l.align = KVM_VIRTIO_CCW_RING_ALIGN;
-		info->info_block->l.index = i;
-		info->info_block->l.num = info->num;
-		ccw->count = sizeof(info->info_block->l);
-	} else {
-		info->info_block->s.desc = queue;
-		info->info_block->s.index = i;
-		info->info_block->s.num = info->num;
-		info->info_block->s.avail = (__u64)virtqueue_get_avail_addr(vq);
-		info->info_block->s.used = (__u64)virtqueue_get_used_addr(vq);
-		ccw->count = sizeof(info->info_block->s);
-	}
+	info_block = info->info_block;
+	info_block->desc = queue;
+	info_block->index = i;
+	info_block->num = info->num;
+	info_block->avail = (__u64)virtqueue_get_avail_addr(vq);
+	info_block->used = (__u64)virtqueue_get_used_addr(vq);
+	ccw->count = sizeof(*info_block);
 	ccw->cmd_code = CCW_CMD_SET_VQ;
 	ccw->flags = 0;
 	ccw->cda = (__u32)(unsigned long)(info->info_block);
@@ -604,7 +521,7 @@ static struct virtqueue *virtio_ccw_setup_vq(struct virtio_device *vdev,
 		vring_del_virtqueue(vq);
 	if (info) {
 		ccw_device_dma_free(vcdev->cdev, info->info_block,
-				    sizeof(*info->info_block));
+				    sizeof(*info_block));
 	}
 	kfree(info);
 	return ERR_PTR(err);
@@ -1271,6 +1188,7 @@ static int virtio_ccw_set_transport_rev(struct virtio_ccw_device *vcdev)
 		ret = ccw_io_helper(vcdev, ccw,
 				    VIRTIO_CCW_DOING_SET_VIRTIO_REV);
 		if (ret == -EOPNOTSUPP) {
+#ifdef CONFIG_VIRTIO_CCW_LEGACY
 			if (vcdev->revision == 0)
 				/*
 				 * The host device does not support setting
@@ -1279,6 +1197,7 @@ static int virtio_ccw_set_transport_rev(struct virtio_ccw_device *vcdev)
 				 */
 				ret = 0;
 			else
+#endif
 				vcdev->revision--;
 		}
 	} while (vcdev->revision >= min_revision && ret == -EOPNOTSUPP);
@@ -1497,6 +1416,9 @@ static int __init virtio_ccw_init(void)
 {
 	int rc;
 
+	if (min_revision < VIRTIO_CCW_REV_MIN)
+		min_revision = VIRTIO_CCW_REV_MIN;
+
 	/* parse no_auto string before we do anything further */
 	no_auto_parse();
 
diff --git a/drivers/s390/virtio/virtio_ccw_common.h b/drivers/s390/virtio/virtio_ccw_common.h
new file mode 100644
index 000000000000..6c6c9e9a1960
--- /dev/null
+++ b/drivers/s390/virtio/virtio_ccw_common.h
@@ -0,0 +1,113 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+/*
+ * common definitions for the ccw based virtio transport
+ *
+ * Copyright IBM Corp. 2012, 2014
+ * Copyright Red Hat, Inc. 2021
+ *
+ *    Author(s): Cornelia Huck <cohuck@redhat.com>
+ */
+
+#include <linux/virtio.h>
+#include <linux/virtio_config.h>
+#include <linux/virtio_ring.h>
+#include <asm/cio.h>
+#include <asm/virtio-ccw.h>
+
+#ifdef CONFIG_VIRTIO_CCW_LEGACY
+#define VIRTIO_CCW_REV_MIN 0
+void virtio_ccw_del_vq_legacy(struct virtqueue *vq, struct ccw1 *ccw);
+struct virtqueue *virtio_ccw_setup_vq_legacy(struct virtio_device *vdev,
+					     int i, vq_callback_t *callback,
+					     const char *name, bool ctx,
+					     struct ccw1 *ccw);
+#else
+#define VIRTIO_CCW_REV_MIN 1
+static inline void virtio_ccw_del_vq_legacy(struct virtqueue *vq,
+					    struct ccw1 *ccw)
+{
+}
+static inline struct virtqueue *
+virtio_ccw_setup_vq_legacy(struct virtio_device *vdev,
+			   int i, vq_callback_t *callback,
+			   const char *name, bool ctx,
+			   struct ccw1 *ccw)
+{
+	return ERR_PTR(-EINVAL);
+}
+#endif
+
+extern int min_revision;
+
+struct virtio_ccw_vq_info {
+	struct virtqueue *vq;
+	int num;
+	void *info_block;
+	int bit_nr;
+	struct list_head node;
+	long cookie;
+};
+
+#define CCW_CMD_SET_VQ 0x13
+#define CCW_CMD_VDEV_RESET 0x33
+#define CCW_CMD_SET_IND 0x43
+#define CCW_CMD_SET_CONF_IND 0x53
+#define CCW_CMD_READ_FEAT 0x12
+#define CCW_CMD_WRITE_FEAT 0x11
+#define CCW_CMD_READ_CONF 0x22
+#define CCW_CMD_WRITE_CONF 0x21
+#define CCW_CMD_WRITE_STATUS 0x31
+#define CCW_CMD_READ_VQ_CONF 0x32
+#define CCW_CMD_READ_STATUS 0x72
+#define CCW_CMD_SET_IND_ADAPTER 0x73
+#define CCW_CMD_SET_VIRTIO_REV 0x83
+
+#define VIRTIO_CCW_DOING_SET_VQ 0x00010000
+#define VIRTIO_CCW_DOING_RESET 0x00040000
+#define VIRTIO_CCW_DOING_READ_FEAT 0x00080000
+#define VIRTIO_CCW_DOING_WRITE_FEAT 0x00100000
+#define VIRTIO_CCW_DOING_READ_CONFIG 0x00200000
+#define VIRTIO_CCW_DOING_WRITE_CONFIG 0x00400000
+#define VIRTIO_CCW_DOING_WRITE_STATUS 0x00800000
+#define VIRTIO_CCW_DOING_SET_IND 0x01000000
+#define VIRTIO_CCW_DOING_READ_VQ_CONF 0x02000000
+#define VIRTIO_CCW_DOING_SET_CONF_IND 0x04000000
+#define VIRTIO_CCW_DOING_SET_IND_ADAPTER 0x08000000
+#define VIRTIO_CCW_DOING_SET_VIRTIO_REV 0x10000000
+#define VIRTIO_CCW_DOING_READ_STATUS 0x20000000
+#define VIRTIO_CCW_INTPARM_MASK 0xffff0000
+
+#define VIRTIO_CCW_CONFIG_SIZE 0x100
+/* same as PCI config space size, should be enough for all drivers */
+
+struct virtio_ccw_device {
+	struct virtio_device vdev;
+	__u8 config[VIRTIO_CCW_CONFIG_SIZE];
+	struct ccw_device *cdev;
+	__u32 curr_io;
+	int err;
+	unsigned int revision; /* Transport revision */
+	wait_queue_head_t wait_q;
+	spinlock_t lock;
+	struct mutex io_lock; /* Serializes I/O requests */
+	struct list_head virtqueues;
+	bool is_thinint;
+	bool going_away;
+	bool device_lost;
+	unsigned int config_ready;
+	void *airq_info;
+	struct vcdev_dma_area *dma_area;
+};
+
+static struct virtio_ccw_device *to_vc_device(struct virtio_device *vdev)
+{
+	return container_of(vdev, struct virtio_ccw_device, vdev);
+}
+
+int ccw_io_helper(struct virtio_ccw_device *vcdev,
+		  struct ccw1 *ccw, __u32 intparm);
+
+int virtio_ccw_read_vq_conf(struct virtio_ccw_device *vcdev,
+			    struct ccw1 *ccw, int index);
+
+bool virtio_ccw_kvm_notify(struct virtqueue *vq);
diff --git a/drivers/s390/virtio/virtio_ccw_legacy.c b/drivers/s390/virtio/virtio_ccw_legacy.c
new file mode 100644
index 000000000000..cce683f10502
--- /dev/null
+++ b/drivers/s390/virtio/virtio_ccw_legacy.c
@@ -0,0 +1,138 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * ccw based virtio transport -- legacy support
+ *
+ * Copyright IBM Corp. 2012, 2014
+ * Copyright Red Hat, Inc. 2021
+ *
+ *    Author(s): Cornelia Huck <cohuck@redhat.com>
+ */
+
+#include <asm/ccwdev.h>
+#include "virtio_ccw_common.h"
+
+struct vq_info_block_legacy {
+	__u64 queue;
+	__u32 align;
+	__u16 index;
+	__u16 num;
+} __packed;
+
+
+void virtio_ccw_del_vq_legacy(struct virtqueue *vq, struct ccw1 *ccw)
+{
+	struct virtio_ccw_device *vcdev = to_vc_device(vq->vdev);
+	struct virtio_ccw_vq_info *info = vq->priv;
+	struct vq_info_block_legacy *info_block;
+	unsigned long flags;
+	int ret;
+	unsigned int index = vq->index;
+
+	/* Remove from our list. */
+	spin_lock_irqsave(&vcdev->lock, flags);
+	list_del(&info->node);
+	spin_unlock_irqrestore(&vcdev->lock, flags);
+
+	/* Release from host. */
+	info_block = info->info_block;
+	info_block->queue = 0;
+	info_block->align = 0;
+	info_block->index = index;
+	info_block->num = 0;
+	ccw->count = sizeof(*info_block);
+	ccw->cmd_code = CCW_CMD_SET_VQ;
+	ccw->flags = 0;
+	ccw->cda = (__u32)(unsigned long)(info->info_block);
+	ret = ccw_io_helper(vcdev, ccw,
+			    VIRTIO_CCW_DOING_SET_VQ | index);
+	/*
+	 * -ENODEV isn't considered an error: The device is gone anyway.
+	 * This may happen on device detach.
+	 */
+	if (ret && (ret != -ENODEV))
+		dev_warn(&vq->vdev->dev, "Error %d while deleting queue %d\n",
+			 ret, index);
+
+	vring_del_virtqueue(vq);
+	ccw_device_dma_free(vcdev->cdev, info->info_block,
+			    sizeof(*info_block));
+	kfree(info);
+}
+
+struct virtqueue *virtio_ccw_setup_vq_legacy(struct virtio_device *vdev,
+					     int i, vq_callback_t *callback,
+					     const char *name, bool ctx,
+					     struct ccw1 *ccw)
+{
+	struct virtio_ccw_device *vcdev = to_vc_device(vdev);
+	int err;
+	struct virtqueue *vq = NULL;
+	struct virtio_ccw_vq_info *info;
+	struct vq_info_block_legacy *info_block;
+	u64 queue;
+	unsigned long flags;
+
+	/* Allocate queue. */
+	info = kzalloc(sizeof(struct virtio_ccw_vq_info), GFP_KERNEL);
+	if (!info) {
+		err = -ENOMEM;
+		goto out_err;
+	}
+	info->info_block = ccw_device_dma_zalloc(vcdev->cdev,
+						 sizeof(struct vq_info_block_legacy));
+	if (!info->info_block) {
+		dev_warn(&vcdev->cdev->dev, "no info block\n");
+		err = -ENOMEM;
+		goto out_err;
+	}
+	info->num = virtio_ccw_read_vq_conf(vcdev, ccw, i);
+	if (info->num < 0) {
+		err = info->num;
+		goto out_err;
+	}
+	vq = vring_create_virtqueue(i, info->num, KVM_VIRTIO_CCW_RING_ALIGN,
+				    vdev, true, false, ctx,
+				    virtio_ccw_kvm_notify, callback, name);
+
+	if (!vq) {
+		dev_warn(&vcdev->cdev->dev, "no vq\n");
+		err = -ENOMEM;
+		goto out_err;
+	}
+
+	/* Register it with the host. */
+	queue = virtqueue_get_desc_addr(vq);
+	info_block->queue = queue;
+	info_block->align = KVM_VIRTIO_CCW_RING_ALIGN;
+	info_block->index = i;
+	info_block->num = info->num;
+	ccw->count = sizeof(*info_block);
+	ccw->cmd_code = CCW_CMD_SET_VQ;
+	ccw->flags = 0;
+	ccw->cda = (__u32)(unsigned long)(info->info_block);
+	err = ccw_io_helper(vcdev, ccw, VIRTIO_CCW_DOING_SET_VQ | i);
+	if (err) {
+		dev_warn(&vcdev->cdev->dev, "SET_VQ failed\n");
+		goto out_err;
+	}
+
+	info->vq = vq;
+	vq->priv = info;
+
+	/* Save it to our list. */
+	spin_lock_irqsave(&vcdev->lock, flags);
+	list_add(&info->node, &vcdev->virtqueues);
+	spin_unlock_irqrestore(&vcdev->lock, flags);
+
+	return vq;
+
+out_err:
+	if (vq)
+		vring_del_virtqueue(vq);
+	if (info) {
+		ccw_device_dma_free(vcdev->cdev, info->info_block,
+				    sizeof(*info_block));
+	}
+	kfree(info);
+	return ERR_PTR(err);
+}
diff --git a/drivers/virtio/Kconfig b/drivers/virtio/Kconfig
index 7b41130d3f35..0f94913c9c7a 100644
--- a/drivers/virtio/Kconfig
+++ b/drivers/virtio/Kconfig
@@ -18,6 +18,13 @@ menuconfig VIRTIO_MENU
 
 if VIRTIO_MENU
 
+config VIRTIO_LEGACY
+	def_bool y
+	help
+	  This option selects base support for legacy virtio devices prior
+	  to the virtio standard, such as those in the Virtio PCI Card
+	  0.9.X Draft and older.
+
 config VIRTIO_PCI
 	tristate "PCI driver for virtio devices"
 	depends on PCI
@@ -34,6 +41,7 @@ config VIRTIO_PCI_LEGACY
 	bool "Support for legacy virtio draft 0.9.X and older devices"
 	default y
 	depends on VIRTIO_PCI
+	select VIRTIO_LEGACY
 	help
           Virtio PCI Card 0.9.X Draft (circa 2014) and older device support.
 
-- 
2.26.2

