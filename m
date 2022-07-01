Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A369C56359C
	for <lists+kvm@lfdr.de>; Fri,  1 Jul 2022 16:31:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232475AbiGAObN (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 1 Jul 2022 10:31:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48694 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233262AbiGAOax (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 1 Jul 2022 10:30:53 -0400
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 5695171BDD
        for <kvm@vger.kernel.org>; Fri,  1 Jul 2022 07:25:56 -0700 (PDT)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 449A51C14;
        Fri,  1 Jul 2022 07:25:35 -0700 (PDT)
Received: from localhost.localdomain (unknown [172.31.20.19])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id A4B4D3F792;
        Fri,  1 Jul 2022 07:25:33 -0700 (PDT)
From:   Jean-Philippe Brucker <jean-philippe.brucker@arm.com>
To:     will@kernel.org
Cc:     andre.przywara@arm.com, alexandru.elisei@arm.com,
        kvm@vger.kernel.org, suzuki.poulose@arm.com, sashal@kernel.org,
        jean-philippe@linaro.org
Subject: [PATCH kvmtool v2 09/12] virtio: Move MMIO transport to mmio-legacy
Date:   Fri,  1 Jul 2022 15:24:31 +0100
Message-Id: <20220701142434.75170-10-jean-philippe.brucker@arm.com>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220701142434.75170-1-jean-philippe.brucker@arm.com>
References: <20220701142434.75170-1-jean-philippe.brucker@arm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-6.9 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

To make space for the modern register layout, move the current code to
mmio-legacy.

Signed-off-by: Jean-Philippe Brucker <jean-philippe.brucker@arm.com>
---
 Makefile                  |   1 +
 include/kvm/virtio-mmio.h |   9 +++
 virtio/mmio-legacy.c      | 150 +++++++++++++++++++++++++++++++++++
 virtio/mmio.c             | 160 ++------------------------------------
 4 files changed, 165 insertions(+), 155 deletions(-)
 create mode 100644 virtio/mmio-legacy.c

diff --git a/Makefile b/Makefile
index 56cfaaf4..4063d185 100644
--- a/Makefile
+++ b/Makefile
@@ -106,6 +106,7 @@ OBJS	+= virtio/9p-pdu.o
 OBJS	+= kvm-ipc.o
 OBJS	+= builtin-sandbox.o
 OBJS	+= virtio/mmio.o
+OBJS	+= virtio/mmio-legacy.o
 
 # Translate uname -m into ARCH string
 ARCH ?= $(shell uname -m | sed -e s/i.86/i386/ -e s/ppc.*/powerpc/ \
diff --git a/include/kvm/virtio-mmio.h b/include/kvm/virtio-mmio.h
index 6bc50bd1..e7ef8386 100644
--- a/include/kvm/virtio-mmio.h
+++ b/include/kvm/virtio-mmio.h
@@ -4,6 +4,8 @@
 #include <linux/types.h>
 #include <linux/virtio_mmio.h>
 
+#include <kvm/kvm-cpu.h>
+
 #define VIRTIO_MMIO_MAX_VQ	32
 #define VIRTIO_MMIO_MAX_CONFIG	1
 #define VIRTIO_MMIO_IO_SIZE	0x200
@@ -57,4 +59,11 @@ int virtio_mmio_exit(struct kvm *kvm, struct virtio_device *vdev);
 int virtio_mmio_reset(struct kvm *kvm, struct virtio_device *vdev);
 int virtio_mmio_init(struct kvm *kvm, void *dev, struct virtio_device *vdev,
 		      int device_id, int subsys_id, int class);
+int virtio_mmio_init_ioeventfd(struct kvm *kvm, struct virtio_device *vdev,
+			       u32 vq);
+
+void virtio_mmio_legacy_callback(struct kvm_cpu *vcpu, u64 addr, u8 *data,
+				 u32 len, u8 is_write, void *ptr);
+int virtio_mmio_init_vq(struct kvm *kvm, struct virtio_device *vdev, int vq);
+void virtio_mmio_exit_vq(struct kvm *kvm, struct virtio_device *vdev, int vq);
 #endif
diff --git a/virtio/mmio-legacy.c b/virtio/mmio-legacy.c
new file mode 100644
index 00000000..7ca7e69f
--- /dev/null
+++ b/virtio/mmio-legacy.c
@@ -0,0 +1,150 @@
+#include "kvm/ioport.h"
+#include "kvm/virtio.h"
+#include "kvm/virtio-mmio.h"
+
+#include <linux/virtio_mmio.h>
+
+#define vmmio_selected_vq(vdev, vmmio) \
+	(vdev)->ops->get_vq((vmmio)->kvm, (vmmio)->dev, (vmmio)->hdr.queue_sel)
+
+static void virtio_mmio_config_in(struct kvm_cpu *vcpu,
+				  u64 addr, void *data, u32 len,
+				  struct virtio_device *vdev)
+{
+	struct virtio_mmio *vmmio = vdev->virtio;
+	struct virt_queue *vq;
+	u32 val = 0;
+
+	switch (addr) {
+	case VIRTIO_MMIO_MAGIC_VALUE:
+	case VIRTIO_MMIO_VERSION:
+	case VIRTIO_MMIO_DEVICE_ID:
+	case VIRTIO_MMIO_VENDOR_ID:
+	case VIRTIO_MMIO_STATUS:
+	case VIRTIO_MMIO_INTERRUPT_STATUS:
+		ioport__write32(data, *(u32 *)(((void *)&vmmio->hdr) + addr));
+		break;
+	case VIRTIO_MMIO_DEVICE_FEATURES:
+		if (vmmio->hdr.host_features_sel == 0)
+			val = vdev->ops->get_host_features(vmmio->kvm,
+							   vmmio->dev);
+		ioport__write32(data, val);
+		break;
+	case VIRTIO_MMIO_QUEUE_PFN:
+		vq = vmmio_selected_vq(vdev, vmmio);
+		ioport__write32(data, vq->vring_addr.pfn);
+		break;
+	case VIRTIO_MMIO_QUEUE_NUM_MAX:
+		val = vdev->ops->get_size_vq(vmmio->kvm, vmmio->dev,
+					     vmmio->hdr.queue_sel);
+		ioport__write32(data, val);
+		break;
+	default:
+		break;
+	}
+}
+
+static void virtio_mmio_config_out(struct kvm_cpu *vcpu,
+				   u64 addr, void *data, u32 len,
+				   struct virtio_device *vdev)
+{
+	struct virtio_mmio *vmmio = vdev->virtio;
+	struct kvm *kvm = vmmio->kvm;
+	unsigned int vq_count = vdev->ops->get_vq_count(kvm, vmmio->dev);
+	struct virt_queue *vq;
+	u32 val = 0;
+
+	switch (addr) {
+	case VIRTIO_MMIO_DEVICE_FEATURES_SEL:
+	case VIRTIO_MMIO_DRIVER_FEATURES_SEL:
+		val = ioport__read32(data);
+		*(u32 *)(((void *)&vmmio->hdr) + addr) = val;
+		break;
+	case VIRTIO_MMIO_QUEUE_SEL:
+		val = ioport__read32(data);
+		if (val >= vq_count) {
+			WARN_ONCE(1, "QUEUE_SEL value (%u) is larger than VQ count (%u)\n",
+				val, vq_count);
+			break;
+		}
+		*(u32 *)(((void *)&vmmio->hdr) + addr) = val;
+		break;
+	case VIRTIO_MMIO_STATUS:
+		vmmio->hdr.status = ioport__read32(data);
+		if (!vmmio->hdr.status) /* Sample endianness on reset */
+			vdev->endian = kvm_cpu__get_endianness(vcpu);
+		virtio_notify_status(kvm, vdev, vmmio->dev, vmmio->hdr.status);
+		break;
+	case VIRTIO_MMIO_DRIVER_FEATURES:
+		if (vmmio->hdr.guest_features_sel == 0) {
+			val = ioport__read32(data);
+			virtio_set_guest_features(vmmio->kvm, vdev,
+						  vmmio->dev, val);
+		}
+		break;
+	case VIRTIO_MMIO_GUEST_PAGE_SIZE:
+		val = ioport__read32(data);
+		vmmio->hdr.guest_page_size = val;
+		break;
+	case VIRTIO_MMIO_QUEUE_NUM:
+		val = ioport__read32(data);
+		vmmio->hdr.queue_num = val;
+		vdev->ops->set_size_vq(vmmio->kvm, vmmio->dev,
+				       vmmio->hdr.queue_sel, val);
+		break;
+	case VIRTIO_MMIO_QUEUE_ALIGN:
+		val = ioport__read32(data);
+		vmmio->hdr.queue_align = val;
+		break;
+	case VIRTIO_MMIO_QUEUE_PFN:
+		val = ioport__read32(data);
+		if (val) {
+			vq = vmmio_selected_vq(vdev, vmmio);
+			vq->vring_addr = (struct vring_addr) {
+				.legacy	= true,
+				.pfn	= val,
+				.align	= vmmio->hdr.queue_align,
+				.pgsize	= vmmio->hdr.guest_page_size,
+			};
+			virtio_mmio_init_vq(kvm, vdev, vmmio->hdr.queue_sel);
+		} else {
+			virtio_mmio_exit_vq(kvm, vdev, vmmio->hdr.queue_sel);
+		}
+		break;
+	case VIRTIO_MMIO_QUEUE_NOTIFY:
+		val = ioport__read32(data);
+		if (val >= vq_count) {
+			WARN_ONCE(1, "QUEUE_NOTIFY value (%u) is larger than VQ count (%u)\n",
+				val, vq_count);
+			break;
+		}
+		vdev->ops->notify_vq(vmmio->kvm, vmmio->dev, val);
+		break;
+	case VIRTIO_MMIO_INTERRUPT_ACK:
+		val = ioport__read32(data);
+		vmmio->hdr.interrupt_state &= ~val;
+		break;
+	default:
+		break;
+	};
+}
+
+void virtio_mmio_legacy_callback(struct kvm_cpu *vcpu, u64 addr, u8 *data,
+				 u32 len, u8 is_write, void *ptr)
+{
+	struct virtio_device *vdev = ptr;
+	struct virtio_mmio *vmmio = vdev->virtio;
+	u32 offset = addr - vmmio->addr;
+
+	if (offset >= VIRTIO_MMIO_CONFIG) {
+		offset -= VIRTIO_MMIO_CONFIG;
+		virtio_access_config(vmmio->kvm, vdev, vmmio->dev, offset, data,
+				     len, is_write);
+		return;
+	}
+
+	if (is_write)
+		virtio_mmio_config_out(vcpu, offset, data, len, ptr);
+	else
+		virtio_mmio_config_in(vcpu, offset, data, len, ptr);
+}
diff --git a/virtio/mmio.c b/virtio/mmio.c
index 2a96e0e3..fab45733 100644
--- a/virtio/mmio.c
+++ b/virtio/mmio.c
@@ -1,10 +1,8 @@
 #include "kvm/devices.h"
 #include "kvm/virtio-mmio.h"
 #include "kvm/ioeventfd.h"
-#include "kvm/ioport.h"
 #include "kvm/virtio.h"
 #include "kvm/kvm.h"
-#include "kvm/kvm-cpu.h"
 #include "kvm/irq.h"
 #include "kvm/fdt.h"
 
@@ -29,8 +27,8 @@ static void virtio_mmio_ioevent_callback(struct kvm *kvm, void *param)
 	ioeventfd->vdev->ops->notify_vq(kvm, vmmio->dev, ioeventfd->vq);
 }
 
-static int virtio_mmio_init_ioeventfd(struct kvm *kvm,
-				      struct virtio_device *vdev, u32 vq)
+int virtio_mmio_init_ioeventfd(struct kvm *kvm, struct virtio_device *vdev,
+			       u32 vq)
 {
 	struct virtio_mmio *vmmio = vdev->virtio;
 	struct ioevent ioevent;
@@ -79,8 +77,7 @@ int virtio_mmio_signal_vq(struct kvm *kvm, struct virtio_device *vdev, u32 vq)
 	return 0;
 }
 
-static int virtio_mmio_init_vq(struct kvm *kvm, struct virtio_device *vdev,
-			       int vq)
+int virtio_mmio_init_vq(struct kvm *kvm, struct virtio_device *vdev, int vq)
 {
 	int ret;
 	struct virtio_mmio *vmmio = vdev->virtio;
@@ -93,8 +90,7 @@ static int virtio_mmio_init_vq(struct kvm *kvm, struct virtio_device *vdev,
 	return vdev->ops->init_vq(vmmio->kvm, vmmio->dev, vq);
 }
 
-static void virtio_mmio_exit_vq(struct kvm *kvm, struct virtio_device *vdev,
-				int vq)
+void virtio_mmio_exit_vq(struct kvm *kvm, struct virtio_device *vdev, int vq)
 {
 	struct virtio_mmio *vmmio = vdev->virtio;
 
@@ -112,152 +108,6 @@ int virtio_mmio_signal_config(struct kvm *kvm, struct virtio_device *vdev)
 	return 0;
 }
 
-#define vmmio_selected_vq(vdev, vmmio) \
-	(vdev)->ops->get_vq((vmmio)->kvm, (vmmio)->dev, (vmmio)->hdr.queue_sel)
-
-static void virtio_mmio_config_in(struct kvm_cpu *vcpu,
-				  u64 addr, void *data, u32 len,
-				  struct virtio_device *vdev)
-{
-	struct virtio_mmio *vmmio = vdev->virtio;
-	struct virt_queue *vq;
-	u32 val = 0;
-
-	switch (addr) {
-	case VIRTIO_MMIO_MAGIC_VALUE:
-	case VIRTIO_MMIO_VERSION:
-	case VIRTIO_MMIO_DEVICE_ID:
-	case VIRTIO_MMIO_VENDOR_ID:
-	case VIRTIO_MMIO_STATUS:
-	case VIRTIO_MMIO_INTERRUPT_STATUS:
-		ioport__write32(data, *(u32 *)(((void *)&vmmio->hdr) + addr));
-		break;
-	case VIRTIO_MMIO_DEVICE_FEATURES:
-		if (vmmio->hdr.host_features_sel == 0)
-			val = vdev->ops->get_host_features(vmmio->kvm,
-							   vmmio->dev);
-		ioport__write32(data, val);
-		break;
-	case VIRTIO_MMIO_QUEUE_PFN:
-		vq = vmmio_selected_vq(vdev, vmmio);
-		ioport__write32(data, vq->vring_addr.pfn);
-		break;
-	case VIRTIO_MMIO_QUEUE_NUM_MAX:
-		val = vdev->ops->get_size_vq(vmmio->kvm, vmmio->dev,
-					     vmmio->hdr.queue_sel);
-		ioport__write32(data, val);
-		break;
-	default:
-		break;
-	}
-}
-
-static void virtio_mmio_config_out(struct kvm_cpu *vcpu,
-				   u64 addr, void *data, u32 len,
-				   struct virtio_device *vdev)
-{
-	struct virtio_mmio *vmmio = vdev->virtio;
-	struct kvm *kvm = vmmio->kvm;
-	unsigned int vq_count = vdev->ops->get_vq_count(kvm, vmmio->dev);
-	struct virt_queue *vq;
-	u32 val = 0;
-
-	switch (addr) {
-	case VIRTIO_MMIO_DEVICE_FEATURES_SEL:
-	case VIRTIO_MMIO_DRIVER_FEATURES_SEL:
-		val = ioport__read32(data);
-		*(u32 *)(((void *)&vmmio->hdr) + addr) = val;
-		break;
-	case VIRTIO_MMIO_QUEUE_SEL:
-		val = ioport__read32(data);
-		if (val >= vq_count) {
-			WARN_ONCE(1, "QUEUE_SEL value (%u) is larger than VQ count (%u)\n",
-				val, vq_count);
-			break;
-		}
-		*(u32 *)(((void *)&vmmio->hdr) + addr) = val;
-		break;
-	case VIRTIO_MMIO_STATUS:
-		vmmio->hdr.status = ioport__read32(data);
-		if (!vmmio->hdr.status) /* Sample endianness on reset */
-			vdev->endian = kvm_cpu__get_endianness(vcpu);
-		virtio_notify_status(kvm, vdev, vmmio->dev, vmmio->hdr.status);
-		break;
-	case VIRTIO_MMIO_DRIVER_FEATURES:
-		if (vmmio->hdr.guest_features_sel == 0) {
-			val = ioport__read32(data);
-			virtio_set_guest_features(vmmio->kvm, vdev,
-						  vmmio->dev, val);
-		}
-		break;
-	case VIRTIO_MMIO_GUEST_PAGE_SIZE:
-		val = ioport__read32(data);
-		vmmio->hdr.guest_page_size = val;
-		break;
-	case VIRTIO_MMIO_QUEUE_NUM:
-		val = ioport__read32(data);
-		vmmio->hdr.queue_num = val;
-		vdev->ops->set_size_vq(vmmio->kvm, vmmio->dev,
-				       vmmio->hdr.queue_sel, val);
-		break;
-	case VIRTIO_MMIO_QUEUE_ALIGN:
-		val = ioport__read32(data);
-		vmmio->hdr.queue_align = val;
-		break;
-	case VIRTIO_MMIO_QUEUE_PFN:
-		val = ioport__read32(data);
-		if (val) {
-			vq = vmmio_selected_vq(vdev, vmmio);
-			vq->vring_addr = (struct vring_addr) {
-				.legacy	= true,
-				.pfn	= val,
-				.align	= vmmio->hdr.queue_align,
-				.pgsize	= vmmio->hdr.guest_page_size,
-			};
-			virtio_mmio_init_vq(kvm, vdev, vmmio->hdr.queue_sel);
-		} else {
-			virtio_mmio_exit_vq(kvm, vdev, vmmio->hdr.queue_sel);
-		}
-		break;
-	case VIRTIO_MMIO_QUEUE_NOTIFY:
-		val = ioport__read32(data);
-		if (val >= vq_count) {
-			WARN_ONCE(1, "QUEUE_NOTIFY value (%u) is larger than VQ count (%u)\n",
-				val, vq_count);
-			break;
-		}
-		vdev->ops->notify_vq(vmmio->kvm, vmmio->dev, val);
-		break;
-	case VIRTIO_MMIO_INTERRUPT_ACK:
-		val = ioport__read32(data);
-		vmmio->hdr.interrupt_state &= ~val;
-		break;
-	default:
-		break;
-	};
-}
-
-static void virtio_mmio_mmio_callback(struct kvm_cpu *vcpu,
-				      u64 addr, u8 *data, u32 len,
-				      u8 is_write, void *ptr)
-{
-	struct virtio_device *vdev = ptr;
-	struct virtio_mmio *vmmio = vdev->virtio;
-	u32 offset = addr - vmmio->addr;
-
-	if (offset >= VIRTIO_MMIO_CONFIG) {
-		offset -= VIRTIO_MMIO_CONFIG;
-		virtio_access_config(vmmio->kvm, vdev, vmmio->dev, offset, data,
-				     len, is_write);
-		return;
-	}
-
-	if (is_write)
-		virtio_mmio_config_out(vcpu, offset, data, len, ptr);
-	else
-		virtio_mmio_config_in(vcpu, offset, data, len, ptr);
-}
-
 #ifdef CONFIG_HAS_LIBFDT
 #define DEVICE_NAME_MAX_LEN 32
 static
@@ -307,7 +157,7 @@ int virtio_mmio_init(struct kvm *kvm, void *dev, struct virtio_device *vdev,
 	vmmio->dev	= dev;
 
 	r = kvm__register_mmio(kvm, vmmio->addr, VIRTIO_MMIO_IO_SIZE,
-			       false, virtio_mmio_mmio_callback, vdev);
+			       false, virtio_mmio_legacy_callback, vdev);
 	if (r < 0)
 		return r;
 
-- 
2.36.1

