Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0E4FC5635A1
	for <lists+kvm@lfdr.de>; Fri,  1 Jul 2022 16:31:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233299AbiGAObL (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 1 Jul 2022 10:31:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49656 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231757AbiGAOaw (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 1 Jul 2022 10:30:52 -0400
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 3769F71BC2
        for <kvm@vger.kernel.org>; Fri,  1 Jul 2022 07:25:55 -0700 (PDT)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id BF09D1C01;
        Fri,  1 Jul 2022 07:25:31 -0700 (PDT)
Received: from localhost.localdomain (unknown [172.31.20.19])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id 049EA3F792;
        Fri,  1 Jul 2022 07:25:29 -0700 (PDT)
From:   Jean-Philippe Brucker <jean-philippe.brucker@arm.com>
To:     will@kernel.org
Cc:     andre.przywara@arm.com, alexandru.elisei@arm.com,
        kvm@vger.kernel.org, suzuki.poulose@arm.com, sashal@kernel.org,
        jean-philippe@linaro.org
Subject: [PATCH kvmtool v2 07/12] virtio: Move PCI transport to pci-legacy
Date:   Fri,  1 Jul 2022 15:24:29 +0100
Message-Id: <20220701142434.75170-8-jean-philippe.brucker@arm.com>
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

To make space for the more recent virtio version, move the legacy bits of
virtio-pci to a different file.

Signed-off-by: Jean-Philippe Brucker <jean-philippe.brucker@arm.com>
---
 Makefile                 |   1 +
 include/kvm/virtio-pci.h |  39 +++++++
 virtio/pci-legacy.c      | 205 ++++++++++++++++++++++++++++++++
 virtio/pci.c             | 245 ++-------------------------------------
 4 files changed, 254 insertions(+), 236 deletions(-)
 create mode 100644 virtio/pci-legacy.c

diff --git a/Makefile b/Makefile
index 77cfa9a9..6dc2d95e 100644
--- a/Makefile
+++ b/Makefile
@@ -74,6 +74,7 @@ OBJS	+= virtio/rng.o
 OBJS    += virtio/balloon.o
 OBJS	+= virtio/pci.o
 OBJS	+= virtio/vsock.o
+OBJS	+= virtio/pci-legacy.o
 OBJS	+= disk/blk.o
 OBJS	+= disk/qcow.o
 OBJS	+= disk/raw.o
diff --git a/include/kvm/virtio-pci.h b/include/kvm/virtio-pci.h
index d64e5c99..8cce5528 100644
--- a/include/kvm/virtio-pci.h
+++ b/include/kvm/virtio-pci.h
@@ -4,12 +4,15 @@
 #include "kvm/devices.h"
 #include "kvm/pci.h"
 
+#include <stdbool.h>
+#include <linux/byteorder.h>
 #include <linux/types.h>
 
 #define VIRTIO_PCI_MAX_VQ	32
 #define VIRTIO_PCI_MAX_CONFIG	1
 
 struct kvm;
+struct kvm_cpu;
 
 struct virtio_pci_ioevent_param {
 	struct virtio_device	*vdev;
@@ -18,6 +21,13 @@ struct virtio_pci_ioevent_param {
 
 #define VIRTIO_PCI_F_SIGNAL_MSI (1 << 0)
 
+#define ALIGN_UP(x, s)		ALIGN((x) + (s) - 1, (s))
+#define VIRTIO_NR_MSIX		(VIRTIO_PCI_MAX_VQ + VIRTIO_PCI_MAX_CONFIG)
+#define VIRTIO_MSIX_TABLE_SIZE	(VIRTIO_NR_MSIX * 16)
+#define VIRTIO_MSIX_PBA_SIZE	(ALIGN_UP(VIRTIO_MSIX_TABLE_SIZE, 64) / 8)
+#define VIRTIO_MSIX_BAR_SIZE	(1UL << fls_long(VIRTIO_MSIX_TABLE_SIZE + \
+						 VIRTIO_MSIX_PBA_SIZE))
+
 struct virtio_pci {
 	struct pci_device_header pci_hdr;
 	struct device_header	dev_hdr;
@@ -57,4 +67,33 @@ int virtio_pci__reset(struct kvm *kvm, struct virtio_device *vdev);
 int virtio_pci__init(struct kvm *kvm, void *dev, struct virtio_device *vdev,
 		     int device_id, int subsys_id, int class);
 
+static inline bool virtio_pci__msix_enabled(struct virtio_pci *vpci)
+{
+	return vpci->pci_hdr.msix.ctrl & cpu_to_le16(PCI_MSIX_FLAGS_ENABLE);
+}
+
+static inline u16 virtio_pci__port_addr(struct virtio_pci *vpci)
+{
+	return pci__bar_address(&vpci->pci_hdr, 0);
+}
+
+static inline u32 virtio_pci__mmio_addr(struct virtio_pci *vpci)
+{
+	return pci__bar_address(&vpci->pci_hdr, 1);
+}
+
+static inline u32 virtio_pci__msix_io_addr(struct virtio_pci *vpci)
+{
+	return pci__bar_address(&vpci->pci_hdr, 2);
+}
+
+int virtio_pci__add_msix_route(struct virtio_pci *vpci, u32 vec);
+int virtio_pci__init_ioeventfd(struct kvm *kvm, struct virtio_device *vdev,
+			       u32 vq);
+int virtio_pci_init_vq(struct kvm *kvm, struct virtio_device *vdev, int vq);
+void virtio_pci_exit_vq(struct kvm *kvm, struct virtio_device *vdev, int vq);
+
+void virtio_pci_legacy__io_mmio_callback(struct kvm_cpu *vcpu, u64 addr, u8 *data,
+				  u32 len, u8 is_write, void *ptr);
+
 #endif
diff --git a/virtio/pci-legacy.c b/virtio/pci-legacy.c
new file mode 100644
index 00000000..58047967
--- /dev/null
+++ b/virtio/pci-legacy.c
@@ -0,0 +1,205 @@
+#include "kvm/virtio-pci.h"
+
+#include "kvm/ioport.h"
+#include "kvm/virtio.h"
+
+static bool virtio_pci__specific_data_in(struct kvm *kvm, struct virtio_device *vdev,
+					 void *data, u32 size, unsigned long offset)
+{
+	u32 config_offset;
+	struct virtio_pci *vpci = vdev->virtio;
+	int type = virtio__get_dev_specific_field(offset - 20,
+							virtio_pci__msix_enabled(vpci),
+							&config_offset);
+	if (type == VIRTIO_PCI_O_MSIX) {
+		switch (offset) {
+		case VIRTIO_MSI_CONFIG_VECTOR:
+			ioport__write16(data, vpci->config_vector);
+			break;
+		case VIRTIO_MSI_QUEUE_VECTOR:
+			ioport__write16(data, vpci->vq_vector[vpci->queue_selector]);
+			break;
+		};
+
+		return true;
+	} else if (type == VIRTIO_PCI_O_CONFIG) {
+		return virtio_access_config(kvm, vdev, vpci->dev, config_offset,
+					    data, size, false);
+	}
+
+	return false;
+}
+
+static bool virtio_pci__data_in(struct kvm_cpu *vcpu, struct virtio_device *vdev,
+				unsigned long offset, void *data, u32 size)
+{
+	bool ret = true;
+	struct virtio_pci *vpci;
+	struct virt_queue *vq;
+	struct kvm *kvm;
+	u32 val;
+
+	kvm = vcpu->kvm;
+	vpci = vdev->virtio;
+
+	switch (offset) {
+	case VIRTIO_PCI_HOST_FEATURES:
+		val = vdev->ops->get_host_features(kvm, vpci->dev);
+		ioport__write32(data, val);
+		break;
+	case VIRTIO_PCI_QUEUE_PFN:
+		vq = vdev->ops->get_vq(kvm, vpci->dev, vpci->queue_selector);
+		ioport__write32(data, vq->vring_addr.pfn);
+		break;
+	case VIRTIO_PCI_QUEUE_NUM:
+		val = vdev->ops->get_size_vq(kvm, vpci->dev, vpci->queue_selector);
+		ioport__write16(data, val);
+		break;
+	case VIRTIO_PCI_STATUS:
+		ioport__write8(data, vpci->status);
+		break;
+	case VIRTIO_PCI_ISR:
+		ioport__write8(data, vpci->isr);
+		kvm__irq_line(kvm, vpci->legacy_irq_line, VIRTIO_IRQ_LOW);
+		vpci->isr = VIRTIO_IRQ_LOW;
+		break;
+	default:
+		ret = virtio_pci__specific_data_in(kvm, vdev, data, size, offset);
+		break;
+	};
+
+	return ret;
+}
+
+static bool virtio_pci__specific_data_out(struct kvm *kvm, struct virtio_device *vdev,
+					  void *data, u32 size, unsigned long offset)
+{
+	struct virtio_pci *vpci = vdev->virtio;
+	u32 config_offset, vec;
+	int gsi;
+	int type = virtio__get_dev_specific_field(offset - 20, virtio_pci__msix_enabled(vpci),
+							&config_offset);
+	if (type == VIRTIO_PCI_O_MSIX) {
+		switch (offset) {
+		case VIRTIO_MSI_CONFIG_VECTOR:
+			vec = vpci->config_vector = ioport__read16(data);
+
+			gsi = virtio_pci__add_msix_route(vpci, vec);
+			if (gsi < 0)
+				break;
+
+			vpci->config_gsi = gsi;
+			break;
+		case VIRTIO_MSI_QUEUE_VECTOR:
+			vec = ioport__read16(data);
+			vpci->vq_vector[vpci->queue_selector] = vec;
+
+			gsi = virtio_pci__add_msix_route(vpci, vec);
+			if (gsi < 0)
+				break;
+
+			vpci->gsis[vpci->queue_selector] = gsi;
+			if (vdev->ops->notify_vq_gsi)
+				vdev->ops->notify_vq_gsi(kvm, vpci->dev,
+							 vpci->queue_selector,
+							 gsi);
+			break;
+		};
+
+		return true;
+	} else if (type == VIRTIO_PCI_O_CONFIG) {
+		return virtio_access_config(kvm, vdev, vpci->dev, config_offset,
+					    data, size, true);
+	}
+
+	return false;
+}
+
+static bool virtio_pci__data_out(struct kvm_cpu *vcpu, struct virtio_device *vdev,
+				 unsigned long offset, void *data, u32 size)
+{
+	bool ret = true;
+	struct virtio_pci *vpci;
+	struct virt_queue *vq;
+	struct kvm *kvm;
+	u32 val;
+	unsigned int vq_count;
+
+	kvm = vcpu->kvm;
+	vpci = vdev->virtio;
+	vq_count = vdev->ops->get_vq_count(kvm, vpci->dev);
+
+	switch (offset) {
+	case VIRTIO_PCI_GUEST_FEATURES:
+		val = ioport__read32(data);
+		virtio_set_guest_features(kvm, vdev, vpci->dev, val);
+		break;
+	case VIRTIO_PCI_QUEUE_PFN:
+		val = ioport__read32(data);
+		if (val) {
+			vq = vdev->ops->get_vq(kvm, vpci->dev,
+					       vpci->queue_selector);
+			vq->vring_addr = (struct vring_addr) {
+				.legacy	= true,
+				.pfn	= val,
+				.align	= VIRTIO_PCI_VRING_ALIGN,
+				.pgsize	= 1 << VIRTIO_PCI_QUEUE_ADDR_SHIFT,
+			};
+			virtio_pci_init_vq(kvm, vdev, vpci->queue_selector);
+		} else {
+			virtio_pci_exit_vq(kvm, vdev, vpci->queue_selector);
+		}
+		break;
+	case VIRTIO_PCI_QUEUE_SEL:
+		val = ioport__read16(data);
+		if (val >= vq_count) {
+			WARN_ONCE(1, "QUEUE_SEL value (%u) is larger than VQ count (%u)\n",
+				val, vq_count);
+			return false;
+		}
+		vpci->queue_selector = val;
+		break;
+	case VIRTIO_PCI_QUEUE_NOTIFY:
+		val = ioport__read16(data);
+		if (val >= vq_count) {
+			WARN_ONCE(1, "QUEUE_SEL value (%u) is larger than VQ count (%u)\n",
+				val, vq_count);
+			return false;
+		}
+		vdev->ops->notify_vq(kvm, vpci->dev, val);
+		break;
+	case VIRTIO_PCI_STATUS:
+		vpci->status = ioport__read8(data);
+		if (!vpci->status) /* Sample endianness on reset */
+			vdev->endian = kvm_cpu__get_endianness(vcpu);
+		virtio_notify_status(kvm, vdev, vpci->dev, vpci->status);
+		break;
+	default:
+		ret = virtio_pci__specific_data_out(kvm, vdev, data, size, offset);
+		break;
+	};
+
+	return ret;
+}
+
+void virtio_pci_legacy__io_mmio_callback(struct kvm_cpu *vcpu, u64 addr,
+					 u8 *data, u32 len, u8 is_write,
+					 void *ptr)
+{
+	struct virtio_device *vdev = ptr;
+	struct virtio_pci *vpci = vdev->virtio;
+	u32 ioport_addr = virtio_pci__port_addr(vpci);
+	u32 base_addr;
+
+	if (addr >= ioport_addr &&
+	    addr < ioport_addr + pci__bar_size(&vpci->pci_hdr, 0))
+		base_addr = ioport_addr;
+	else
+		base_addr = virtio_pci__mmio_addr(vpci);
+
+	if (!is_write)
+		virtio_pci__data_in(vcpu, vdev, addr - base_addr, data, len);
+	else
+		virtio_pci__data_out(vcpu, vdev, addr - base_addr, data, len);
+}
+
diff --git a/virtio/pci.c b/virtio/pci.c
index 320865c1..35362423 100644
--- a/virtio/pci.c
+++ b/virtio/pci.c
@@ -11,33 +11,10 @@
 
 #include <sys/ioctl.h>
 #include <linux/virtio_pci.h>
-#include <linux/byteorder.h>
 #include <assert.h>
 #include <string.h>
 
-#define ALIGN_UP(x, s)		ALIGN((x) + (s) - 1, (s))
-#define VIRTIO_NR_MSIX		(VIRTIO_PCI_MAX_VQ + VIRTIO_PCI_MAX_CONFIG)
-#define VIRTIO_MSIX_TABLE_SIZE	(VIRTIO_NR_MSIX * 16)
-#define VIRTIO_MSIX_PBA_SIZE	(ALIGN_UP(VIRTIO_MSIX_TABLE_SIZE, 64) / 8)
-#define VIRTIO_MSIX_BAR_SIZE	(1UL << fls_long(VIRTIO_MSIX_TABLE_SIZE + \
-						 VIRTIO_MSIX_PBA_SIZE))
-
-static u16 virtio_pci__port_addr(struct virtio_pci *vpci)
-{
-	return pci__bar_address(&vpci->pci_hdr, 0);
-}
-
-static u32 virtio_pci__mmio_addr(struct virtio_pci *vpci)
-{
-	return pci__bar_address(&vpci->pci_hdr, 1);
-}
-
-static u32 virtio_pci__msix_io_addr(struct virtio_pci *vpci)
-{
-	return pci__bar_address(&vpci->pci_hdr, 2);
-}
-
-static int virtio_pci__add_msix_route(struct virtio_pci *vpci, u32 vec)
+int virtio_pci__add_msix_route(struct virtio_pci *vpci, u32 vec)
 {
 	int gsi;
 	struct msi_msg *msg;
@@ -75,7 +52,8 @@ static void virtio_pci__ioevent_callback(struct kvm *kvm, void *param)
 	ioeventfd->vdev->ops->notify_vq(kvm, vpci->dev, ioeventfd->vq);
 }
 
-static int virtio_pci__init_ioeventfd(struct kvm *kvm, struct virtio_device *vdev, u32 vq)
+int virtio_pci__init_ioeventfd(struct kvm *kvm, struct virtio_device *vdev,
+			       u32 vq)
 {
 	struct ioevent ioevent;
 	struct virtio_pci *vpci = vdev->virtio;
@@ -130,8 +108,7 @@ free_ioport_evt:
 	return r;
 }
 
-static int virtio_pci_init_vq(struct kvm *kvm, struct virtio_device *vdev,
-			      int vq)
+int virtio_pci_init_vq(struct kvm *kvm, struct virtio_device *vdev, int vq)
 {
 	int ret;
 	struct virtio_pci *vpci = vdev->virtio;
@@ -144,8 +121,7 @@ static int virtio_pci_init_vq(struct kvm *kvm, struct virtio_device *vdev,
 	return vdev->ops->init_vq(kvm, vpci->dev, vq);
 }
 
-static void virtio_pci_exit_vq(struct kvm *kvm, struct virtio_device *vdev,
-			       int vq)
+void virtio_pci_exit_vq(struct kvm *kvm, struct virtio_device *vdev, int vq)
 {
 	struct virtio_pci *vpci = vdev->virtio;
 	u32 mmio_addr = virtio_pci__mmio_addr(vpci);
@@ -160,79 +136,6 @@ static void virtio_pci_exit_vq(struct kvm *kvm, struct virtio_device *vdev,
 	virtio_exit_vq(kvm, vdev, vpci->dev, vq);
 }
 
-static inline bool virtio_pci__msix_enabled(struct virtio_pci *vpci)
-{
-	return vpci->pci_hdr.msix.ctrl & cpu_to_le16(PCI_MSIX_FLAGS_ENABLE);
-}
-
-static bool virtio_pci__specific_data_in(struct kvm *kvm, struct virtio_device *vdev,
-					 void *data, u32 size, unsigned long offset)
-{
-	u32 config_offset;
-	struct virtio_pci *vpci = vdev->virtio;
-	int type = virtio__get_dev_specific_field(offset - 20,
-							virtio_pci__msix_enabled(vpci),
-							&config_offset);
-	if (type == VIRTIO_PCI_O_MSIX) {
-		switch (offset) {
-		case VIRTIO_MSI_CONFIG_VECTOR:
-			ioport__write16(data, vpci->config_vector);
-			break;
-		case VIRTIO_MSI_QUEUE_VECTOR:
-			ioport__write16(data, vpci->vq_vector[vpci->queue_selector]);
-			break;
-		};
-
-		return true;
-	} else if (type == VIRTIO_PCI_O_CONFIG) {
-		return virtio_access_config(kvm, vdev, vpci->dev, config_offset,
-					    data, size, false);
-	}
-
-	return false;
-}
-
-static bool virtio_pci__data_in(struct kvm_cpu *vcpu, struct virtio_device *vdev,
-				unsigned long offset, void *data, u32 size)
-{
-	bool ret = true;
-	struct virtio_pci *vpci;
-	struct virt_queue *vq;
-	struct kvm *kvm;
-	u32 val;
-
-	kvm = vcpu->kvm;
-	vpci = vdev->virtio;
-
-	switch (offset) {
-	case VIRTIO_PCI_HOST_FEATURES:
-		val = vdev->ops->get_host_features(kvm, vpci->dev);
-		ioport__write32(data, val);
-		break;
-	case VIRTIO_PCI_QUEUE_PFN:
-		vq = vdev->ops->get_vq(kvm, vpci->dev, vpci->queue_selector);
-		ioport__write32(data, vq->vring_addr.pfn);
-		break;
-	case VIRTIO_PCI_QUEUE_NUM:
-		val = vdev->ops->get_size_vq(kvm, vpci->dev, vpci->queue_selector);
-		ioport__write16(data, val);
-		break;
-	case VIRTIO_PCI_STATUS:
-		ioport__write8(data, vpci->status);
-		break;
-	case VIRTIO_PCI_ISR:
-		ioport__write8(data, vpci->isr);
-		kvm__irq_line(kvm, vpci->legacy_irq_line, VIRTIO_IRQ_LOW);
-		vpci->isr = VIRTIO_IRQ_LOW;
-		break;
-	default:
-		ret = virtio_pci__specific_data_in(kvm, vdev, data, size, offset);
-		break;
-	};
-
-	return ret;
-}
-
 static void update_msix_map(struct virtio_pci *vpci,
 			    struct msix_table *msix_entry, u32 vecnum)
 {
@@ -257,117 +160,6 @@ static void update_msix_map(struct virtio_pci *vpci,
 	irq__update_msix_route(vpci->kvm, gsi, &msix_entry->msg);
 }
 
-static bool virtio_pci__specific_data_out(struct kvm *kvm, struct virtio_device *vdev,
-					  void *data, u32 size, unsigned long offset)
-{
-	struct virtio_pci *vpci = vdev->virtio;
-	u32 config_offset, vec;
-	int gsi;
-	int type = virtio__get_dev_specific_field(offset - 20, virtio_pci__msix_enabled(vpci),
-							&config_offset);
-	if (type == VIRTIO_PCI_O_MSIX) {
-		switch (offset) {
-		case VIRTIO_MSI_CONFIG_VECTOR:
-			vec = vpci->config_vector = ioport__read16(data);
-
-			gsi = virtio_pci__add_msix_route(vpci, vec);
-			if (gsi < 0)
-				break;
-
-			vpci->config_gsi = gsi;
-			break;
-		case VIRTIO_MSI_QUEUE_VECTOR:
-			vec = ioport__read16(data);
-			vpci->vq_vector[vpci->queue_selector] = vec;
-
-			gsi = virtio_pci__add_msix_route(vpci, vec);
-			if (gsi < 0)
-				break;
-
-			vpci->gsis[vpci->queue_selector] = gsi;
-			if (vdev->ops->notify_vq_gsi)
-				vdev->ops->notify_vq_gsi(kvm, vpci->dev,
-							 vpci->queue_selector,
-							 gsi);
-			break;
-		};
-
-		return true;
-	} else if (type == VIRTIO_PCI_O_CONFIG) {
-		return virtio_access_config(kvm, vdev, vpci->dev, config_offset,
-					    data, size, true);
-	}
-
-	return false;
-}
-
-static bool virtio_pci__data_out(struct kvm_cpu *vcpu, struct virtio_device *vdev,
-				 unsigned long offset, void *data, u32 size)
-{
-	bool ret = true;
-	struct virtio_pci *vpci;
-	struct virt_queue *vq;
-	struct kvm *kvm;
-	u32 val;
-	unsigned int vq_count;
-
-	kvm = vcpu->kvm;
-	vpci = vdev->virtio;
-	vq_count = vdev->ops->get_vq_count(kvm, vpci->dev);
-
-	switch (offset) {
-	case VIRTIO_PCI_GUEST_FEATURES:
-		val = ioport__read32(data);
-		virtio_set_guest_features(kvm, vdev, vpci->dev, val);
-		break;
-	case VIRTIO_PCI_QUEUE_PFN:
-		val = ioport__read32(data);
-		if (val) {
-			vq = vdev->ops->get_vq(kvm, vpci->dev,
-					       vpci->queue_selector);
-			vq->vring_addr = (struct vring_addr) {
-				.legacy	= true,
-				.pfn	= val,
-				.align	= VIRTIO_PCI_VRING_ALIGN,
-				.pgsize	= 1 << VIRTIO_PCI_QUEUE_ADDR_SHIFT,
-			};
-			virtio_pci_init_vq(kvm, vdev, vpci->queue_selector);
-		} else {
-			virtio_pci_exit_vq(kvm, vdev, vpci->queue_selector);
-		}
-		break;
-	case VIRTIO_PCI_QUEUE_SEL:
-		val = ioport__read16(data);
-		if (val >= vq_count) {
-			WARN_ONCE(1, "QUEUE_SEL value (%u) is larger than VQ count (%u)\n",
-				val, vq_count);
-			return false;
-		}
-		vpci->queue_selector = val;
-		break;
-	case VIRTIO_PCI_QUEUE_NOTIFY:
-		val = ioport__read16(data);
-		if (val >= vq_count) {
-			WARN_ONCE(1, "QUEUE_SEL value (%u) is larger than VQ count (%u)\n",
-				val, vq_count);
-			return false;
-		}
-		vdev->ops->notify_vq(kvm, vpci->dev, val);
-		break;
-	case VIRTIO_PCI_STATUS:
-		vpci->status = ioport__read8(data);
-		if (!vpci->status) /* Sample endianness on reset */
-			vdev->endian = kvm_cpu__get_endianness(vcpu);
-		virtio_notify_status(kvm, vdev, vpci->dev, vpci->status);
-		break;
-	default:
-		ret = virtio_pci__specific_data_out(kvm, vdev, data, size, offset);
-		break;
-	};
-
-	return ret;
-}
-
 static void virtio_pci__msix_mmio_callback(struct kvm_cpu *vcpu,
 					   u64 addr, u8 *data, u32 len,
 					   u8 is_write, void *ptr)
@@ -478,27 +270,6 @@ int virtio_pci__signal_config(struct kvm *kvm, struct virtio_device *vdev)
 	return 0;
 }
 
-static void virtio_pci__io_mmio_callback(struct kvm_cpu *vcpu,
-					 u64 addr, u8 *data, u32 len,
-					 u8 is_write, void *ptr)
-{
-	struct virtio_device *vdev = ptr;
-	struct virtio_pci *vpci = vdev->virtio;
-	u32 ioport_addr = virtio_pci__port_addr(vpci);
-	u32 base_addr;
-
-	if (addr >= ioport_addr &&
-	    addr < ioport_addr + pci__bar_size(&vpci->pci_hdr, 0))
-		base_addr = ioport_addr;
-	else
-		base_addr = virtio_pci__mmio_addr(vpci);
-
-	if (!is_write)
-		virtio_pci__data_in(vcpu, vdev, addr - base_addr, data, len);
-	else
-		virtio_pci__data_out(vcpu, vdev, addr - base_addr, data, len);
-}
-
 static int virtio_pci__bar_activate(struct kvm *kvm,
 				    struct pci_device_header *pci_hdr,
 				    int bar_num, void *data)
@@ -515,11 +286,13 @@ static int virtio_pci__bar_activate(struct kvm *kvm,
 	switch (bar_num) {
 	case 0:
 		r = kvm__register_pio(kvm, bar_addr, bar_size,
-				      virtio_pci__io_mmio_callback, vdev);
+				      virtio_pci_legacy__io_mmio_callback,
+				      vdev);
 		break;
 	case 1:
 		r =  kvm__register_mmio(kvm, bar_addr, bar_size, false,
-					virtio_pci__io_mmio_callback, vdev);
+					virtio_pci_legacy__io_mmio_callback,
+					vdev);
 		break;
 	case 2:
 		r =  kvm__register_mmio(kvm, bar_addr, bar_size, false,
-- 
2.36.1

