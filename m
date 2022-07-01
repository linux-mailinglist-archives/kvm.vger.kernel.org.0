Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 71EE656359F
	for <lists+kvm@lfdr.de>; Fri,  1 Jul 2022 16:31:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233279AbiGAObP (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 1 Jul 2022 10:31:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48760 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232558AbiGAOay (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 1 Jul 2022 10:30:54 -0400
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id AF2CF71BE4
        for <kvm@vger.kernel.org>; Fri,  1 Jul 2022 07:25:56 -0700 (PDT)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 392E91C25;
        Fri,  1 Jul 2022 07:25:37 -0700 (PDT)
Received: from localhost.localdomain (unknown [172.31.20.19])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id 485733F792;
        Fri,  1 Jul 2022 07:25:35 -0700 (PDT)
From:   Jean-Philippe Brucker <jean-philippe.brucker@arm.com>
To:     will@kernel.org
Cc:     andre.przywara@arm.com, alexandru.elisei@arm.com,
        kvm@vger.kernel.org, suzuki.poulose@arm.com, sashal@kernel.org,
        jean-philippe@linaro.org
Subject: [PATCH kvmtool v2 10/12] virtio: Add support for modern virtio-mmio
Date:   Fri,  1 Jul 2022 15:24:32 +0100
Message-Id: <20220701142434.75170-11-jean-philippe.brucker@arm.com>
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

Add modern MMIO transport to virtio, make it the default. Legacy transport
can be enabled with --virtio-legacy. The main change for MMIO is the queue
addresses. They are now 64-bit addresses instead of 32-bit PFNs. Apart
from that all changes for supporting modern devices are already
implemented.

Signed-off-by: Jean-Philippe Brucker <jean-philippe.brucker@arm.com>
---
 Makefile                          |   1 +
 arm/include/arm-common/kvm-arch.h |   2 +-
 include/kvm/virtio-mmio.h         |  20 +++-
 include/kvm/virtio.h              |   1 +
 riscv/include/kvm/kvm-arch.h      |   3 +-
 virtio/core.c                     |   6 +-
 virtio/mmio-modern.c              | 161 ++++++++++++++++++++++++++++++
 virtio/mmio.c                     |  12 ++-
 8 files changed, 195 insertions(+), 11 deletions(-)
 create mode 100644 virtio/mmio-modern.c

diff --git a/Makefile b/Makefile
index 4063d185..349468f3 100644
--- a/Makefile
+++ b/Makefile
@@ -107,6 +107,7 @@ OBJS	+= kvm-ipc.o
 OBJS	+= builtin-sandbox.o
 OBJS	+= virtio/mmio.o
 OBJS	+= virtio/mmio-legacy.o
+OBJS	+= virtio/mmio-modern.o
 
 # Translate uname -m into ARCH string
 ARCH ?= $(shell uname -m | sed -e s/i.86/i386/ -e s/ppc.*/powerpc/ \
diff --git a/arm/include/arm-common/kvm-arch.h b/arm/include/arm-common/kvm-arch.h
index 0a960f4f..a4c7604a 100644
--- a/arm/include/arm-common/kvm-arch.h
+++ b/arm/include/arm-common/kvm-arch.h
@@ -84,7 +84,7 @@
 #define VIRTIO_DEFAULT_TRANS(kvm)					\
 	((kvm)->cfg.arch.virtio_trans_pci ?				\
 	 ((kvm)->cfg.virtio_legacy ? VIRTIO_PCI_LEGACY : VIRTIO_PCI) :	\
-	 VIRTIO_MMIO)
+	 ((kvm)->cfg.virtio_legacy ? VIRTIO_MMIO_LEGACY : VIRTIO_MMIO))
 
 #define VIRTIO_RING_ENDIAN	(VIRTIO_ENDIAN_LE | VIRTIO_ENDIAN_BE)
 
diff --git a/include/kvm/virtio-mmio.h b/include/kvm/virtio-mmio.h
index e7ef8386..b428b8d3 100644
--- a/include/kvm/virtio-mmio.h
+++ b/include/kvm/virtio-mmio.h
@@ -27,20 +27,30 @@ struct virtio_mmio_hdr {
 	u32	reserved_1[2];
 	u32	guest_features;
 	u32	guest_features_sel;
-	u32	guest_page_size;
+	u32	guest_page_size;	/* legacy */
 	u32	reserved_2;
 	u32	queue_sel;
 	u32	queue_num_max;
 	u32	queue_num;
-	u32	queue_align;
-	u32	queue_pfn;
-	u32	reserved_3[3];
+	u32	queue_align;		/* legacy */
+	u32	queue_pfn;		/* legacy */
+	u32	queue_ready;		/* modern */
+	u32	reserved_3[2];
 	u32	queue_notify;
 	u32	reserved_4[3];
 	u32	interrupt_state;
 	u32	interrupt_ack;
 	u32	reserved_5[2];
 	u32	status;
+	u32	reserved_7[3];
+	u32	queue_desc_low;		/* modern */
+	u32	queue_desc_high;
+	u32	reserved_8[2];
+	u32	queue_avail_low;
+	u32	queue_avail_high;
+	u32	reserved_9[2];
+	u32	queue_used_low;
+	u32	queue_used_high;
 } __attribute__((packed));
 
 struct virtio_mmio {
@@ -64,6 +74,8 @@ int virtio_mmio_init_ioeventfd(struct kvm *kvm, struct virtio_device *vdev,
 
 void virtio_mmio_legacy_callback(struct kvm_cpu *vcpu, u64 addr, u8 *data,
 				 u32 len, u8 is_write, void *ptr);
+void virtio_mmio_modern_callback(struct kvm_cpu *vcpu, u64 addr, u8 *data,
+				 u32 len, u8 is_write, void *ptr);
 int virtio_mmio_init_vq(struct kvm *kvm, struct virtio_device *vdev, int vq);
 void virtio_mmio_exit_vq(struct kvm *kvm, struct virtio_device *vdev, int vq);
 #endif
diff --git a/include/kvm/virtio.h b/include/kvm/virtio.h
index 869064ba..94bddefe 100644
--- a/include/kvm/virtio.h
+++ b/include/kvm/virtio.h
@@ -196,6 +196,7 @@ enum virtio_trans {
 	VIRTIO_PCI,
 	VIRTIO_PCI_LEGACY,
 	VIRTIO_MMIO,
+	VIRTIO_MMIO_LEGACY,
 };
 
 struct virtio_device {
diff --git a/riscv/include/kvm/kvm-arch.h b/riscv/include/kvm/kvm-arch.h
index f090883c..1e130f59 100644
--- a/riscv/include/kvm/kvm-arch.h
+++ b/riscv/include/kvm/kvm-arch.h
@@ -46,7 +46,8 @@
 
 #define KVM_VM_TYPE		0
 
-#define VIRTIO_DEFAULT_TRANS(kvm)	VIRTIO_MMIO
+#define VIRTIO_DEFAULT_TRANS(kvm) \
+	((kvm)->cfg.virtio_legacy ? VIRTIO_MMIO_LEGACY : VIRTIO_MMIO)
 
 #define VIRTIO_RING_ENDIAN	VIRTIO_ENDIAN_LE
 
diff --git a/virtio/core.c b/virtio/core.c
index 5fc2e789..f432421a 100644
--- a/virtio/core.c
+++ b/virtio/core.c
@@ -16,7 +16,7 @@ const char* virtio_trans_name(enum virtio_trans trans)
 {
 	if (trans == VIRTIO_PCI || trans == VIRTIO_PCI_LEGACY)
 		return "pci";
-	else if (trans == VIRTIO_MMIO)
+	else if (trans == VIRTIO_MMIO || trans == VIRTIO_MMIO_LEGACY)
 		return "mmio";
 	return "unknown";
 }
@@ -345,8 +345,10 @@ int virtio_init(struct kvm *kvm, void *dev, struct virtio_device *vdev,
 		vdev->ops->reset		= virtio_pci__reset;
 		r = vdev->ops->init(kvm, dev, vdev, device_id, subsys_id, class);
 		break;
-	case VIRTIO_MMIO:
+	case VIRTIO_MMIO_LEGACY:
 		vdev->legacy			= true;
+		/* fall through */
+	case VIRTIO_MMIO:
 		virtio = calloc(sizeof(struct virtio_mmio), 1);
 		if (!virtio)
 			return -ENOMEM;
diff --git a/virtio/mmio-modern.c b/virtio/mmio-modern.c
new file mode 100644
index 00000000..6c0bb382
--- /dev/null
+++ b/virtio/mmio-modern.c
@@ -0,0 +1,161 @@
+#include "kvm/virtio.h"
+#include "kvm/virtio-mmio.h"
+
+#include <linux/byteorder.h>
+
+#define vmmio_selected_vq(vmmio) \
+	vdev->ops->get_vq((vmmio)->kvm, (vmmio)->dev, (vmmio)->hdr.queue_sel)
+
+static void virtio_mmio_config_in(struct kvm_cpu *vcpu,
+				  u64 addr, u32 *data, u32 len,
+				  struct virtio_device *vdev)
+{
+	struct virtio_mmio *vmmio = vdev->virtio;
+	u64 features = 1ULL << VIRTIO_F_VERSION_1;
+	u32 val = 0;
+
+	switch (addr) {
+	case VIRTIO_MMIO_MAGIC_VALUE:
+	case VIRTIO_MMIO_VERSION:
+	case VIRTIO_MMIO_DEVICE_ID:
+	case VIRTIO_MMIO_VENDOR_ID:
+	case VIRTIO_MMIO_STATUS:
+	case VIRTIO_MMIO_INTERRUPT_STATUS:
+		val = *(u32 *)(((void *)&vmmio->hdr) + addr);
+		break;
+	case VIRTIO_MMIO_DEVICE_FEATURES:
+		if (vmmio->hdr.host_features_sel > 1)
+			break;
+		features |= vdev->ops->get_host_features(vmmio->kvm, vmmio->dev);
+		val = features >> (32 * vmmio->hdr.host_features_sel);
+		break;
+	case VIRTIO_MMIO_QUEUE_NUM_MAX:
+		val = vdev->ops->get_size_vq(vmmio->kvm, vmmio->dev,
+					     vmmio->hdr.queue_sel);
+		break;
+	case VIRTIO_MMIO_QUEUE_READY:
+		val = vmmio_selected_vq(vmmio)->enabled;
+		break;
+	case VIRTIO_MMIO_QUEUE_DESC_LOW:
+		val = vmmio_selected_vq(vmmio)->vring_addr.desc_lo;
+		break;
+	case VIRTIO_MMIO_QUEUE_DESC_HIGH:
+		val = vmmio_selected_vq(vmmio)->vring_addr.desc_hi;
+		break;
+	case VIRTIO_MMIO_QUEUE_USED_LOW:
+		val = vmmio_selected_vq(vmmio)->vring_addr.used_lo;
+		break;
+	case VIRTIO_MMIO_QUEUE_USED_HIGH:
+		val = vmmio_selected_vq(vmmio)->vring_addr.used_hi;
+		break;
+	case VIRTIO_MMIO_QUEUE_AVAIL_LOW:
+		val = vmmio_selected_vq(vmmio)->vring_addr.avail_lo;
+		break;
+	case VIRTIO_MMIO_QUEUE_AVAIL_HIGH:
+		val = vmmio_selected_vq(vmmio)->vring_addr.avail_hi;
+		break;
+	case VIRTIO_MMIO_CONFIG_GENERATION:
+		/*
+		 * The config generation changes when the device updates a
+		 * config field larger than 32 bits, that the driver reads using
+		 * multiple accesses. Since kvmtool doesn't use any mutable
+		 * config field larger than 32 bits, the generation is constant.
+		 */
+		break;
+	default:
+		return;
+	}
+
+	*data = cpu_to_le32(val);
+}
+
+static void virtio_mmio_config_out(struct kvm_cpu *vcpu,
+				   u64 addr, u32 *data, u32 len,
+				   struct virtio_device *vdev)
+{
+	struct virtio_mmio *vmmio = vdev->virtio;
+	struct kvm *kvm = vmmio->kvm;
+	u32 val = le32_to_cpu(*data);
+	u64 features;
+
+	switch (addr) {
+	case VIRTIO_MMIO_DEVICE_FEATURES_SEL:
+	case VIRTIO_MMIO_DRIVER_FEATURES_SEL:
+	case VIRTIO_MMIO_QUEUE_SEL:
+		*(u32 *)(((void *)&vmmio->hdr) + addr) = val;
+		break;
+	case VIRTIO_MMIO_STATUS:
+		vmmio->hdr.status = val;
+		virtio_notify_status(kvm, vdev, vmmio->dev, val);
+		break;
+	case VIRTIO_MMIO_DRIVER_FEATURES:
+		if (vmmio->hdr.guest_features_sel > 1)
+			break;
+
+		features = (u64)val << (32 * vmmio->hdr.guest_features_sel);
+		virtio_set_guest_features(vmmio->kvm, vdev, vmmio->dev,
+					  features);
+		break;
+	case VIRTIO_MMIO_QUEUE_NUM:
+		vmmio->hdr.queue_num = val;
+		vdev->ops->set_size_vq(vmmio->kvm, vmmio->dev,
+				       vmmio->hdr.queue_sel, val);
+		break;
+	case VIRTIO_MMIO_QUEUE_READY:
+		if (val)
+			virtio_mmio_init_vq(kvm, vdev, vmmio->hdr.queue_sel);
+		else
+			virtio_mmio_exit_vq(kvm, vdev, vmmio->hdr.queue_sel);
+		break;
+	case VIRTIO_MMIO_QUEUE_NOTIFY:
+		vdev->ops->notify_vq(vmmio->kvm, vmmio->dev, val);
+		break;
+	case VIRTIO_MMIO_INTERRUPT_ACK:
+		vmmio->hdr.interrupt_state &= ~val;
+		break;
+	case VIRTIO_MMIO_QUEUE_DESC_LOW:
+		vmmio_selected_vq(vmmio)->vring_addr.desc_lo = val;
+		break;
+	case VIRTIO_MMIO_QUEUE_DESC_HIGH:
+		vmmio_selected_vq(vmmio)->vring_addr.desc_hi = val;
+		break;
+	case VIRTIO_MMIO_QUEUE_USED_LOW:
+		vmmio_selected_vq(vmmio)->vring_addr.used_lo = val;
+		break;
+	case VIRTIO_MMIO_QUEUE_USED_HIGH:
+		vmmio_selected_vq(vmmio)->vring_addr.used_hi = val;
+		break;
+	case VIRTIO_MMIO_QUEUE_AVAIL_LOW:
+		vmmio_selected_vq(vmmio)->vring_addr.avail_lo = val;
+		break;
+	case VIRTIO_MMIO_QUEUE_AVAIL_HIGH:
+		vmmio_selected_vq(vmmio)->vring_addr.avail_hi = val;
+		break;
+	};
+}
+
+void virtio_mmio_modern_callback(struct kvm_cpu *vcpu, u64 addr, u8 *data,
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
+	if (len != 4) {
+		pr_debug("Invalid %s size %d at 0x%llx", is_write ? "write" :
+			 "read", len, addr);
+		return;
+	}
+
+	if (is_write)
+		virtio_mmio_config_out(vcpu, offset, (void *)data, len, ptr);
+	else
+		virtio_mmio_config_in(vcpu, offset, (void *)data, len, ptr);
+}
diff --git a/virtio/mmio.c b/virtio/mmio.c
index fab45733..fae73b52 100644
--- a/virtio/mmio.c
+++ b/virtio/mmio.c
@@ -149,6 +149,7 @@ static void generate_virtio_mmio_fdt_node(void *fdt,
 int virtio_mmio_init(struct kvm *kvm, void *dev, struct virtio_device *vdev,
 		     int device_id, int subsys_id, int class)
 {
+	bool legacy = vdev->legacy;
 	struct virtio_mmio *vmmio = vdev->virtio;
 	int r;
 
@@ -156,14 +157,19 @@ int virtio_mmio_init(struct kvm *kvm, void *dev, struct virtio_device *vdev,
 	vmmio->kvm	= kvm;
 	vmmio->dev	= dev;
 
-	r = kvm__register_mmio(kvm, vmmio->addr, VIRTIO_MMIO_IO_SIZE,
-			       false, virtio_mmio_legacy_callback, vdev);
+	if (!legacy)
+		vdev->endian = VIRTIO_ENDIAN_LE;
+
+	r = kvm__register_mmio(kvm, vmmio->addr, VIRTIO_MMIO_IO_SIZE, false,
+			       legacy ? virtio_mmio_legacy_callback :
+					virtio_mmio_modern_callback,
+			       vdev);
 	if (r < 0)
 		return r;
 
 	vmmio->hdr = (struct virtio_mmio_hdr) {
 		.magic		= {'v', 'i', 'r', 't'},
-		.version	= 1,
+		.version	= legacy ? 1 : 2,
 		.device_id	= subsys_id,
 		.vendor_id	= 0x4d564b4c , /* 'LKVM' */
 		.queue_num_max	= 256,
-- 
2.36.1

