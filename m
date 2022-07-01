Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 809A656359B
	for <lists+kvm@lfdr.de>; Fri,  1 Jul 2022 16:31:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233236AbiGAObK (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 1 Jul 2022 10:31:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49660 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233259AbiGAOaw (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 1 Jul 2022 10:30:52 -0400
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 14D8871BC1
        for <kvm@vger.kernel.org>; Fri,  1 Jul 2022 07:25:55 -0700 (PDT)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 8BEC81C0A;
        Fri,  1 Jul 2022 07:25:33 -0700 (PDT)
Received: from localhost.localdomain (unknown [172.31.20.19])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id C2A763F792;
        Fri,  1 Jul 2022 07:25:31 -0700 (PDT)
From:   Jean-Philippe Brucker <jean-philippe.brucker@arm.com>
To:     will@kernel.org
Cc:     andre.przywara@arm.com, alexandru.elisei@arm.com,
        kvm@vger.kernel.org, suzuki.poulose@arm.com, sashal@kernel.org,
        jean-philippe@linaro.org
Subject: [PATCH kvmtool v2 08/12] virtio: Add support for modern virtio-pci
Date:   Fri,  1 Jul 2022 15:24:30 +0100
Message-Id: <20220701142434.75170-9-jean-philippe.brucker@arm.com>
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

Add support for modern virtio-pci implementation (based on the 1.0 virtio
spec). We add a new transport, alongside MMIO and PCI-legacy. This is now
the default when selecting PCI, but users can still select the legacy
transport for all virtio devices by passing "--virtio-legacy" on the
command-line.

The main change in modern PCI is the way we address virtqueues, using
64-bit values instead of PFNs. To keep the queue configuration atomic the
device also gets a "queue enable" register. Configuration is also made
extensible by more feature bits and PCI capabilities. Scalability is
improved as well, as devices can have notification registers for each
virtqueue on separate pages. However this implementation keeps a single
notification register.

Signed-off-by: Sasha Levin <sasha.levin@oracle.com>
Signed-off-by: Jean-Philippe Brucker <jean-philippe.brucker@arm.com>
---
 Makefile                          |   1 +
 arm/include/arm-common/kvm-arch.h |   6 +-
 include/kvm/kvm-config.h          |   1 +
 include/kvm/kvm.h                 |   6 +
 include/kvm/pci.h                 |  11 +
 include/kvm/virtio-pci-dev.h      |   4 +
 include/kvm/virtio-pci.h          |   6 +
 include/kvm/virtio.h              |   1 +
 mips/include/kvm/kvm-arch.h       |   2 -
 powerpc/include/kvm/kvm-arch.h    |   2 -
 x86/include/kvm/kvm-arch.h        |   2 -
 builtin-run.c                     |   2 +
 virtio/core.c                     |   6 +-
 virtio/pci-modern.c               | 390 ++++++++++++++++++++++++++++++
 virtio/pci.c                      |  24 +-
 15 files changed, 445 insertions(+), 19 deletions(-)
 create mode 100644 virtio/pci-modern.c

diff --git a/Makefile b/Makefile
index 6dc2d95e..56cfaaf4 100644
--- a/Makefile
+++ b/Makefile
@@ -75,6 +75,7 @@ OBJS    += virtio/balloon.o
 OBJS	+= virtio/pci.o
 OBJS	+= virtio/vsock.o
 OBJS	+= virtio/pci-legacy.o
+OBJS	+= virtio/pci-modern.o
 OBJS	+= disk/blk.o
 OBJS	+= disk/qcow.o
 OBJS	+= disk/raw.o
diff --git a/arm/include/arm-common/kvm-arch.h b/arm/include/arm-common/kvm-arch.h
index fc55360d..0a960f4f 100644
--- a/arm/include/arm-common/kvm-arch.h
+++ b/arm/include/arm-common/kvm-arch.h
@@ -81,8 +81,10 @@
 
 #define KVM_VM_TYPE		0
 
-#define VIRTIO_DEFAULT_TRANS(kvm)	\
-	((kvm)->cfg.arch.virtio_trans_pci ? VIRTIO_PCI : VIRTIO_MMIO)
+#define VIRTIO_DEFAULT_TRANS(kvm)					\
+	((kvm)->cfg.arch.virtio_trans_pci ?				\
+	 ((kvm)->cfg.virtio_legacy ? VIRTIO_PCI_LEGACY : VIRTIO_PCI) :	\
+	 VIRTIO_MMIO)
 
 #define VIRTIO_RING_ENDIAN	(VIRTIO_ENDIAN_LE | VIRTIO_ENDIAN_BE)
 
diff --git a/include/kvm/kvm-config.h b/include/kvm/kvm-config.h
index 6a5720c4..0e72d84c 100644
--- a/include/kvm/kvm-config.h
+++ b/include/kvm/kvm-config.h
@@ -62,6 +62,7 @@ struct kvm_config {
 	bool no_dhcp;
 	bool ioport_debug;
 	bool mmio_debug;
+	bool virtio_legacy;
 };
 
 #endif
diff --git a/include/kvm/kvm.h b/include/kvm/kvm.h
index ad732e56..36a688d6 100644
--- a/include/kvm/kvm.h
+++ b/include/kvm/kvm.h
@@ -45,6 +45,12 @@ struct kvm_cpu;
 typedef void (*mmio_handler_fn)(struct kvm_cpu *vcpu, u64 addr, u8 *data,
 				u32 len, u8 is_write, void *ptr);
 
+/* Archs can override this in kvm-arch.h */
+#ifndef VIRTIO_DEFAULT_TRANS
+#define VIRTIO_DEFAULT_TRANS(kvm) \
+	((kvm)->cfg.virtio_legacy ? VIRTIO_PCI_LEGACY : VIRTIO_PCI)
+#endif
+
 enum {
 	KVM_VMSTATE_RUNNING,
 	KVM_VMSTATE_PAUSED,
diff --git a/include/kvm/pci.h b/include/kvm/pci.h
index d6eb3986..25113f60 100644
--- a/include/kvm/pci.h
+++ b/include/kvm/pci.h
@@ -4,6 +4,7 @@
 #include <linux/types.h>
 #include <linux/kvm.h>
 #include <linux/pci_regs.h>
+#include <linux/virtio_pci.h>
 #include <endian.h>
 #include <stdbool.h>
 
@@ -142,6 +143,14 @@ struct msi_cap_32 {
 	u32 pend_bits;
 };
 
+struct virtio_caps {
+	struct virtio_pci_cap		common;
+	struct virtio_pci_notify_cap	notify;
+	struct virtio_pci_cap		isr;
+	struct virtio_pci_cap		device;
+	struct virtio_pci_cfg_cap	pci;
+};
+
 struct pci_cap_hdr {
 	u8	type;
 	u8	next;
@@ -212,6 +221,7 @@ struct pci_device_header {
 			struct msix_cap msix;
 			/* Used only by architectures which support PCIE */
 			struct pci_exp_cap pci_exp;
+			struct virtio_caps virtio;
 		} __attribute__((packed));
 		/* Pad to PCI config space size */
 		u8	__pad[PCI_DEV_CFG_SIZE];
@@ -232,6 +242,7 @@ struct pci_device_header {
 };
 
 #define PCI_CAP(pci_hdr, pos) ((void *)(pci_hdr) + (pos))
+#define PCI_CAP_OFF(pci_hdr, cap) ((void *)&(pci_hdr)->cap - (void *)(pci_hdr))
 
 #define pci_for_each_cap(pos, cap, hdr)				\
 	for ((pos) = (hdr)->capabilities & ~3;			\
diff --git a/include/kvm/virtio-pci-dev.h b/include/kvm/virtio-pci-dev.h
index 7bf35cdb..9d59e677 100644
--- a/include/kvm/virtio-pci-dev.h
+++ b/include/kvm/virtio-pci-dev.h
@@ -19,6 +19,10 @@
 #define PCI_DEVICE_ID_VESA			0x2000
 #define PCI_DEVICE_ID_PCI_SHMEM			0x0001
 
+/* Modern virtio device IDs start at 1040 */
+#define PCI_DEVICE_ID_VIRTIO_BASE		0x1040
+#define PCI_SUBSYS_ID_VIRTIO_BASE		0x0040
+
 #define PCI_VENDOR_ID_REDHAT_QUMRANET		0x1af4
 #define PCI_VENDOR_ID_PCI_SHMEM			0x0001
 #define PCI_SUBSYSTEM_VENDOR_ID_REDHAT_QUMRANET	0x1af4
diff --git a/include/kvm/virtio-pci.h b/include/kvm/virtio-pci.h
index 8cce5528..47075334 100644
--- a/include/kvm/virtio-pci.h
+++ b/include/kvm/virtio-pci.h
@@ -3,6 +3,7 @@
 
 #include "kvm/devices.h"
 #include "kvm/pci.h"
+#include "kvm/virtio.h"
 
 #include <stdbool.h>
 #include <linux/byteorder.h>
@@ -37,6 +38,8 @@ struct virtio_pci {
 	u32			doorbell_offset;
 	u8			status;
 	u8			isr;
+	u32			device_features_sel;
+	u32			driver_features_sel;
 	u32			features;
 
 	/*
@@ -66,6 +69,7 @@ int virtio_pci__exit(struct kvm *kvm, struct virtio_device *vdev);
 int virtio_pci__reset(struct kvm *kvm, struct virtio_device *vdev);
 int virtio_pci__init(struct kvm *kvm, void *dev, struct virtio_device *vdev,
 		     int device_id, int subsys_id, int class);
+int virtio_pci_modern_init(struct virtio_device *vdev);
 
 static inline bool virtio_pci__msix_enabled(struct virtio_pci *vpci)
 {
@@ -95,5 +99,7 @@ void virtio_pci_exit_vq(struct kvm *kvm, struct virtio_device *vdev, int vq);
 
 void virtio_pci_legacy__io_mmio_callback(struct kvm_cpu *vcpu, u64 addr, u8 *data,
 				  u32 len, u8 is_write, void *ptr);
+void virtio_pci_modern__io_mmio_callback(struct kvm_cpu *vcpu, u64 addr, u8 *data,
+					 u32 len, u8 is_write, void *ptr);
 
 #endif
diff --git a/include/kvm/virtio.h b/include/kvm/virtio.h
index 57da2047..869064ba 100644
--- a/include/kvm/virtio.h
+++ b/include/kvm/virtio.h
@@ -194,6 +194,7 @@ int virtio__get_dev_specific_field(int offset, bool msix, u32 *config_off);
 
 enum virtio_trans {
 	VIRTIO_PCI,
+	VIRTIO_PCI_LEGACY,
 	VIRTIO_MMIO,
 };
 
diff --git a/mips/include/kvm/kvm-arch.h b/mips/include/kvm/kvm-arch.h
index e2f048a0..f5b9044f 100644
--- a/mips/include/kvm/kvm-arch.h
+++ b/mips/include/kvm/kvm-arch.h
@@ -35,8 +35,6 @@
 
 #define KVM_IOEVENTFD_HAS_PIO	0
 
-#define VIRTIO_DEFAULT_TRANS(kvm)	VIRTIO_PCI
-
 #define MAX_PAGE_SIZE		SZ_64K
 
 #include <stdbool.h>
diff --git a/powerpc/include/kvm/kvm-arch.h b/powerpc/include/kvm/kvm-arch.h
index 8eeca507..ff42c132 100644
--- a/powerpc/include/kvm/kvm-arch.h
+++ b/powerpc/include/kvm/kvm-arch.h
@@ -51,8 +51,6 @@
 
 #define MAX_PAGE_SIZE			SZ_256K
 
-#define VIRTIO_DEFAULT_TRANS(kvm)	VIRTIO_PCI
-
 struct spapr_phb;
 
 struct kvm_arch {
diff --git a/x86/include/kvm/kvm-arch.h b/x86/include/kvm/kvm-arch.h
index d8a7312d..73a957bb 100644
--- a/x86/include/kvm/kvm-arch.h
+++ b/x86/include/kvm/kvm-arch.h
@@ -33,8 +33,6 @@
 
 #define MAX_PAGE_SIZE		SZ_4K
 
-#define VIRTIO_DEFAULT_TRANS(kvm)	VIRTIO_PCI
-
 struct kvm_arch {
 	u16			boot_selector;
 	u16			boot_ip;
diff --git a/builtin-run.c b/builtin-run.c
index 9a1a0c1f..5b9d8f0e 100644
--- a/builtin-run.c
+++ b/builtin-run.c
@@ -128,6 +128,8 @@ void kvm_run_set_wrapper_sandbox(void)
 			" rootfs"),					\
 	OPT_STRING('\0', "hugetlbfs", &(cfg)->hugetlbfs_path, "path",	\
 			"Hugetlbfs path"),				\
+	OPT_BOOLEAN('\0', "virtio-legacy", &(cfg)->virtio_legacy,	\
+		    "Use legacy virtio transport"),			\
 									\
 	OPT_GROUP("Kernel options:"),					\
 	OPT_STRING('k', "kernel", &(cfg)->kernel_filename, "kernel",	\
diff --git a/virtio/core.c b/virtio/core.c
index 6688cb44..5fc2e789 100644
--- a/virtio/core.c
+++ b/virtio/core.c
@@ -14,7 +14,7 @@
 
 const char* virtio_trans_name(enum virtio_trans trans)
 {
-	if (trans == VIRTIO_PCI)
+	if (trans == VIRTIO_PCI || trans == VIRTIO_PCI_LEGACY)
 		return "pci";
 	else if (trans == VIRTIO_MMIO)
 		return "mmio";
@@ -329,8 +329,10 @@ int virtio_init(struct kvm *kvm, void *dev, struct virtio_device *vdev,
 	int r;
 
 	switch (trans) {
-	case VIRTIO_PCI:
+	case VIRTIO_PCI_LEGACY:
 		vdev->legacy			= true;
+		/* fall through */
+	case VIRTIO_PCI:
 		virtio = calloc(sizeof(struct virtio_pci), 1);
 		if (!virtio)
 			return -ENOMEM;
diff --git a/virtio/pci-modern.c b/virtio/pci-modern.c
new file mode 100644
index 00000000..753e95bd
--- /dev/null
+++ b/virtio/pci-modern.c
@@ -0,0 +1,390 @@
+#include "kvm/virtio-pci.h"
+
+#include "kvm/ioport.h"
+#include "kvm/virtio.h"
+#include "kvm/virtio-pci-dev.h"
+
+#include <linux/virtio_config.h>
+
+#define VPCI_CFG_COMMON_SIZE	sizeof(struct virtio_pci_common_cfg)
+#define VPCI_CFG_COMMON_START	0
+#define VPCI_CFG_COMMON_END	(VPCI_CFG_COMMON_SIZE - 1)
+/*
+ * Use a naturally aligned 4-byte doorbell, in case we ever want to
+ * implement VIRTIO_F_NOTIFICATION_DATA
+ */
+#define VPCI_CFG_NOTIFY_SIZE	4
+#define VPCI_CFG_NOTIFY_START	(VPCI_CFG_COMMON_END + 1)
+#define VPCI_CFG_NOTIFY_END	(VPCI_CFG_COMMON_END + VPCI_CFG_NOTIFY_SIZE)
+#define VPCI_CFG_ISR_SIZE	4
+#define VPCI_CFG_ISR_START	(VPCI_CFG_NOTIFY_END + 1)
+#define VPCI_CFG_ISR_END	(VPCI_CFG_NOTIFY_END + VPCI_CFG_ISR_SIZE)
+/*
+ * We're at 64 bytes. Use the remaining 192 bytes in PCI_IO_SIZE for the
+ * device-specific config space. It's sufficient for the devices we
+ * currently implement (virtio_blk_config is 60 bytes) and, I think, all
+ * existing virtio 1.2 devices.
+ */
+#define VPCI_CFG_DEV_START	(VPCI_CFG_ISR_END + 1)
+#define VPCI_CFG_DEV_END	((PCI_IO_SIZE) - 1)
+#define VPCI_CFG_DEV_SIZE	(VPCI_CFG_DEV_END - VPCI_CFG_DEV_START + 1)
+
+#define vpci_selected_vq(vpci) \
+	vdev->ops->get_vq((vpci)->kvm, (vpci)->dev, (vpci)->queue_selector)
+
+typedef bool (*access_handler_t)(struct virtio_device *, unsigned long, void *, int);
+
+static bool virtio_pci__common_write(struct virtio_device *vdev,
+				     unsigned long offset, void *data, int size)
+{
+	u64 features;
+	u32 val, gsi, vec;
+	struct virtio_pci *vpci = vdev->virtio;
+
+	switch (offset - VPCI_CFG_COMMON_START) {
+	case VIRTIO_PCI_COMMON_DFSELECT:
+		vpci->device_features_sel = ioport__read32(data);
+		break;
+	case VIRTIO_PCI_COMMON_GFSELECT:
+		vpci->driver_features_sel = ioport__read32(data);
+		break;
+	case VIRTIO_PCI_COMMON_GF:
+		val = ioport__read32(data);
+		if (vpci->driver_features_sel > 1)
+			break;
+
+		features = (u64)val << (32 * vpci->driver_features_sel);
+		virtio_set_guest_features(vpci->kvm, vdev, vpci->dev, features);
+		break;
+	case VIRTIO_PCI_COMMON_MSIX:
+		vec = vpci->config_vector = ioport__read16(data);
+		gsi = virtio_pci__add_msix_route(vpci, vec);
+		if (gsi < 0)
+			break;
+
+		vpci->config_gsi = gsi;
+		break;
+	case VIRTIO_PCI_COMMON_STATUS:
+		vpci->status = ioport__read8(data);
+		virtio_notify_status(vpci->kvm, vdev, vpci->dev, vpci->status);
+		break;
+	case VIRTIO_PCI_COMMON_Q_SELECT:
+		val = ioport__read16(data);
+		if (val >= (u32)vdev->ops->get_vq_count(vpci->kvm, vpci->dev))
+			pr_warning("invalid vq number %u", val);
+		else
+			vpci->queue_selector = val;
+		break;
+	case VIRTIO_PCI_COMMON_Q_SIZE:
+		vdev->ops->set_size_vq(vpci->kvm, vpci->dev,
+				       vpci->queue_selector,
+				       ioport__read16(data));
+		break;
+	case VIRTIO_PCI_COMMON_Q_MSIX:
+		vec = vpci->vq_vector[vpci->queue_selector] = ioport__read16(data);
+
+		gsi = virtio_pci__add_msix_route(vpci, vec);
+		if (gsi < 0)
+			break;
+
+		vpci->gsis[vpci->queue_selector] = gsi;
+		if (vdev->ops->notify_vq_gsi)
+			vdev->ops->notify_vq_gsi(vpci->kvm, vpci->dev,
+						 vpci->queue_selector, gsi);
+		break;
+	case VIRTIO_PCI_COMMON_Q_ENABLE:
+		val = ioport__read16(data);
+		if (val)
+			virtio_pci_init_vq(vpci->kvm, vdev, vpci->queue_selector);
+		else
+			virtio_pci_exit_vq(vpci->kvm, vdev, vpci->queue_selector);
+		break;
+	case VIRTIO_PCI_COMMON_Q_DESCLO:
+		vpci_selected_vq(vpci)->vring_addr.desc_lo = ioport__read32(data);
+		break;
+	case VIRTIO_PCI_COMMON_Q_DESCHI:
+		vpci_selected_vq(vpci)->vring_addr.desc_hi = ioport__read32(data);
+		break;
+	case VIRTIO_PCI_COMMON_Q_AVAILLO:
+		vpci_selected_vq(vpci)->vring_addr.avail_lo = ioport__read32(data);
+		break;
+	case VIRTIO_PCI_COMMON_Q_AVAILHI:
+		vpci_selected_vq(vpci)->vring_addr.avail_hi = ioport__read32(data);
+		break;
+	case VIRTIO_PCI_COMMON_Q_USEDLO:
+		vpci_selected_vq(vpci)->vring_addr.used_lo = ioport__read32(data);
+		break;
+	case VIRTIO_PCI_COMMON_Q_USEDHI:
+		vpci_selected_vq(vpci)->vring_addr.used_hi = ioport__read32(data);
+		break;
+	}
+
+	return true;
+}
+
+static bool virtio_pci__notify_write(struct virtio_device *vdev,
+				     unsigned long offset, void *data, int size)
+{
+	u16 vq = ioport__read16(data);
+	struct virtio_pci *vpci = vdev->virtio;
+
+	vdev->ops->notify_vq(vpci->kvm, vpci->dev, vq);
+
+	return true;
+}
+
+static bool virtio_pci__config_write(struct virtio_device *vdev,
+				     unsigned long offset, void *data, int size)
+{
+	struct virtio_pci *vpci = vdev->virtio;
+
+	return virtio_access_config(vpci->kvm, vdev, vpci->dev,
+				    offset - VPCI_CFG_DEV_START, data, size,
+				    true);
+}
+
+static bool virtio_pci__common_read(struct virtio_device *vdev,
+				    unsigned long offset, void *data, int size)
+{
+	u32 val;
+	struct virtio_pci *vpci = vdev->virtio;
+	u64 features = 1ULL << VIRTIO_F_VERSION_1;
+
+	switch (offset - VPCI_CFG_COMMON_START) {
+	case VIRTIO_PCI_COMMON_DFSELECT:
+		val = vpci->device_features_sel;
+		ioport__write32(data, val);
+		break;
+	case VIRTIO_PCI_COMMON_DF:
+		if (vpci->device_features_sel > 1)
+			break;
+		features |= vdev->ops->get_host_features(vpci->kvm, vpci->dev);
+		val = features >> (32 * vpci->device_features_sel);
+		ioport__write32(data, val);
+		break;
+	case VIRTIO_PCI_COMMON_GFSELECT:
+		val = vpci->driver_features_sel;
+		ioport__write32(data, val);
+		break;
+	case VIRTIO_PCI_COMMON_MSIX:
+		val = vpci->config_vector;
+		ioport__write32(data, val);
+		break;
+	case VIRTIO_PCI_COMMON_NUMQ:
+		val = vdev->ops->get_vq_count(vpci->kvm, vpci->dev);
+		ioport__write32(data, val);
+		break;
+	case VIRTIO_PCI_COMMON_STATUS:
+		ioport__write8(data, vpci->status);
+		break;
+	case VIRTIO_PCI_COMMON_CFGGENERATION:
+		/*
+		 * The config generation changes when the device updates a
+		 * config field larger than 32 bits, that the driver may read
+		 * using multiple accesses. Since kvmtool doesn't use any
+		 * mutable config field larger than 32 bits, the generation is
+		 * constant.
+		 */
+		ioport__write8(data, 0);
+		break;
+	case VIRTIO_PCI_COMMON_Q_SELECT:
+		ioport__write16(data, vpci->queue_selector);
+		break;
+	case VIRTIO_PCI_COMMON_Q_SIZE:
+		val = vdev->ops->get_size_vq(vpci->kvm, vpci->dev,
+					     vpci->queue_selector);
+		ioport__write16(data, val);
+		break;
+	case VIRTIO_PCI_COMMON_Q_MSIX:
+		val = vpci->vq_vector[vpci->queue_selector];
+		ioport__write16(data, val);
+		break;
+	case VIRTIO_PCI_COMMON_Q_ENABLE:
+		val = vpci_selected_vq(vpci)->enabled;
+		ioport__write16(data, val);
+		break;
+	case VIRTIO_PCI_COMMON_Q_NOFF:
+		val = vpci->queue_selector;
+		ioport__write16(data, val);
+		break;
+	case VIRTIO_PCI_COMMON_Q_DESCLO:
+		val = vpci_selected_vq(vpci)->vring_addr.desc_lo;
+		ioport__write32(data, val);
+		break;
+	case VIRTIO_PCI_COMMON_Q_DESCHI:
+		val = vpci_selected_vq(vpci)->vring_addr.desc_hi;
+		ioport__write32(data, val);
+		break;
+	case VIRTIO_PCI_COMMON_Q_AVAILLO:
+		val = vpci_selected_vq(vpci)->vring_addr.avail_lo;
+		ioport__write32(data, val);
+		break;
+	case VIRTIO_PCI_COMMON_Q_AVAILHI:
+		val = vpci_selected_vq(vpci)->vring_addr.avail_hi;
+		ioport__write32(data, val);
+		break;
+	case VIRTIO_PCI_COMMON_Q_USEDLO:
+		val = vpci_selected_vq(vpci)->vring_addr.used_lo;
+		ioport__write32(data, val);
+		break;
+	case VIRTIO_PCI_COMMON_Q_USEDHI:
+		val = vpci_selected_vq(vpci)->vring_addr.used_hi;
+		ioport__write32(data, val);
+		break;
+	};
+
+	return true;
+}
+
+static bool virtio_pci__isr_read(struct virtio_device *vdev,
+				 unsigned long offset, void *data, int size)
+{
+	struct virtio_pci *vpci = vdev->virtio;
+
+	if (WARN_ON(offset - VPCI_CFG_ISR_START != 0))
+		return false;
+
+	ioport__write8(data, vpci->isr);
+	/*
+	 * Interrupts are edge triggered (yes, going against the PCI and virtio
+	 * specs), so no need to deassert the IRQ line.
+	 */
+	vpci->isr = 0;
+
+	return 0;
+}
+
+static bool virtio_pci__config_read(struct virtio_device *vdev,
+				    unsigned long offset, void *data, int size)
+{
+	struct virtio_pci *vpci = vdev->virtio;
+
+	return virtio_access_config(vpci->kvm, vdev, vpci->dev,
+				    offset - VPCI_CFG_DEV_START, data, size,
+				    false);
+}
+
+static bool virtio_pci_access(struct kvm_cpu *vcpu, struct virtio_device *vdev,
+			      unsigned long offset, void *data, int size,
+			      bool write)
+{
+	access_handler_t handler = NULL;
+
+	switch (offset) {
+	case VPCI_CFG_COMMON_START...VPCI_CFG_COMMON_END:
+		if (write)
+			handler = virtio_pci__common_write;
+		else
+			handler = virtio_pci__common_read;
+		break;
+	case VPCI_CFG_NOTIFY_START...VPCI_CFG_NOTIFY_END:
+		if (write)
+			handler = virtio_pci__notify_write;
+		break;
+	case VPCI_CFG_ISR_START...VPCI_CFG_ISR_END:
+		if (!write)
+			handler = virtio_pci__isr_read;
+		break;
+	case VPCI_CFG_DEV_START...VPCI_CFG_DEV_END:
+		if (write)
+			handler = virtio_pci__config_write;
+		else
+			handler = virtio_pci__config_read;
+		break;
+	}
+
+	if (!handler)
+		return false;
+
+	return handler(vdev, offset, data, size);
+}
+
+void virtio_pci_modern__io_mmio_callback(struct kvm_cpu *vcpu, u64 addr,
+					 u8 *data, u32 len, u8 is_write,
+					 void *ptr)
+{
+	struct virtio_device *vdev = ptr;
+	struct virtio_pci *vpci = vdev->virtio;
+	u32 mmio_addr = virtio_pci__mmio_addr(vpci);
+
+	virtio_pci_access(vcpu, vdev, addr - mmio_addr, data, len, is_write);
+}
+
+int virtio_pci_modern_init(struct virtio_device *vdev)
+{
+	int subsys_id;
+	struct virtio_pci *vpci = vdev->virtio;
+	struct pci_device_header *hdr = &vpci->pci_hdr;
+
+	subsys_id = le16_to_cpu(hdr->subsys_id);
+
+	hdr->device_id = cpu_to_le16(PCI_DEVICE_ID_VIRTIO_BASE + subsys_id);
+	hdr->subsys_id = cpu_to_le16(PCI_SUBSYS_ID_VIRTIO_BASE + subsys_id);
+
+	vpci->doorbell_offset = VPCI_CFG_NOTIFY_START;
+	vdev->endian = VIRTIO_ENDIAN_LE;
+
+	hdr->msix.next = PCI_CAP_OFF(hdr, virtio);
+
+	hdr->virtio.common = (struct virtio_pci_cap) {
+		.cap_vndr		= PCI_CAP_ID_VNDR,
+		.cap_next		= PCI_CAP_OFF(hdr, virtio.notify),
+		.cap_len		= sizeof(hdr->virtio.common),
+		.cfg_type		= VIRTIO_PCI_CAP_COMMON_CFG,
+		.bar			= 1,
+		.offset			= cpu_to_le32(VPCI_CFG_COMMON_START),
+		.length			= cpu_to_le32(VPCI_CFG_COMMON_SIZE),
+	};
+	BUILD_BUG_ON(VPCI_CFG_COMMON_START & 0x3);
+
+	hdr->virtio.notify = (struct virtio_pci_notify_cap) {
+		.cap.cap_vndr		= PCI_CAP_ID_VNDR,
+		.cap.cap_next		= PCI_CAP_OFF(hdr, virtio.isr),
+		.cap.cap_len		= sizeof(hdr->virtio.notify),
+		.cap.cfg_type		= VIRTIO_PCI_CAP_NOTIFY_CFG,
+		.cap.bar		= 1,
+		.cap.offset		= cpu_to_le32(VPCI_CFG_NOTIFY_START),
+		.cap.length		= cpu_to_le32(VPCI_CFG_NOTIFY_SIZE),
+		/*
+		 * Notify multiplier is 0, meaning that notifications are all on
+		 * the same register
+		 */
+	};
+	BUILD_BUG_ON(VPCI_CFG_NOTIFY_START & 0x3);
+
+	hdr->virtio.isr = (struct virtio_pci_cap) {
+		.cap_vndr		= PCI_CAP_ID_VNDR,
+		.cap_next		= PCI_CAP_OFF(hdr, virtio.device),
+		.cap_len		= sizeof(hdr->virtio.isr),
+		.cfg_type		= VIRTIO_PCI_CAP_ISR_CFG,
+		.bar			= 1,
+		.offset			= cpu_to_le32(VPCI_CFG_ISR_START),
+		.length			= cpu_to_le32(VPCI_CFG_ISR_SIZE),
+	};
+
+	hdr->virtio.device = (struct virtio_pci_cap) {
+		.cap_vndr		= PCI_CAP_ID_VNDR,
+		.cap_next		= PCI_CAP_OFF(hdr, virtio.pci),
+		.cap_len		= sizeof(hdr->virtio.device),
+		.cfg_type		= VIRTIO_PCI_CAP_DEVICE_CFG,
+		.bar			= 1,
+		.offset			= cpu_to_le32(VPCI_CFG_DEV_START),
+		.length			= cpu_to_le32(VPCI_CFG_DEV_SIZE),
+	};
+	BUILD_BUG_ON(VPCI_CFG_DEV_START & 0x3);
+
+	/*
+	 * TODO: implement this weird proxy capability (it is a "MUST" in the
+	 * spec, but I don't know if anyone actually uses it).
+	 * It doesn't use any BAR space. Instead the driver writes .cap.offset
+	 * and .cap.length to access a register in a BAR.
+	 */
+	hdr->virtio.pci = (struct virtio_pci_cfg_cap) {
+		.cap.cap_vndr		= PCI_CAP_ID_VNDR,
+		.cap.cap_next		= 0,
+		.cap.cap_len		= sizeof(hdr->virtio.pci),
+		.cap.cfg_type		= VIRTIO_PCI_CAP_PCI_CFG,
+	};
+
+	return 0;
+}
diff --git a/virtio/pci.c b/virtio/pci.c
index 35362423..c645d4a0 100644
--- a/virtio/pci.c
+++ b/virtio/pci.c
@@ -275,9 +275,15 @@ static int virtio_pci__bar_activate(struct kvm *kvm,
 				    int bar_num, void *data)
 {
 	struct virtio_device *vdev = data;
+	mmio_handler_fn mmio_fn;
 	u32 bar_addr, bar_size;
 	int r = -EINVAL;
 
+	if (vdev->legacy)
+		mmio_fn = &virtio_pci_legacy__io_mmio_callback;
+	else
+		mmio_fn = &virtio_pci_modern__io_mmio_callback;
+
 	assert(bar_num <= 2);
 
 	bar_addr = pci__bar_address(pci_hdr, bar_num);
@@ -285,13 +291,10 @@ static int virtio_pci__bar_activate(struct kvm *kvm,
 
 	switch (bar_num) {
 	case 0:
-		r = kvm__register_pio(kvm, bar_addr, bar_size,
-				      virtio_pci_legacy__io_mmio_callback,
-				      vdev);
+		r = kvm__register_pio(kvm, bar_addr, bar_size, mmio_fn, vdev);
 		break;
 	case 1:
-		r =  kvm__register_mmio(kvm, bar_addr, bar_size, false,
-					virtio_pci_legacy__io_mmio_callback,
+		r =  kvm__register_mmio(kvm, bar_addr, bar_size, false, mmio_fn,
 					vdev);
 		break;
 	case 2:
@@ -347,14 +350,12 @@ int virtio_pci__init(struct kvm *kvm, void *dev, struct virtio_device *vdev,
 	mmio_addr = pci_get_mmio_block(PCI_IO_SIZE);
 	msix_io_block = pci_get_mmio_block(VIRTIO_MSIX_BAR_SIZE);
 
-	vpci->doorbell_offset = VIRTIO_PCI_QUEUE_NOTIFY;
-
 	vpci->pci_hdr = (struct pci_device_header) {
 		.vendor_id		= cpu_to_le16(PCI_VENDOR_ID_REDHAT_QUMRANET),
 		.device_id		= cpu_to_le16(device_id),
 		.command		= PCI_COMMAND_IO | PCI_COMMAND_MEMORY,
 		.header_type		= PCI_HEADER_TYPE_NORMAL,
-		.revision_id		= 0,
+		.revision_id		= vdev->legacy ? 0 : 1,
 		.class[0]		= class & 0xff,
 		.class[1]		= (class >> 8) & 0xff,
 		.class[2]		= (class >> 16) & 0xff,
@@ -367,7 +368,7 @@ int virtio_pci__init(struct kvm *kvm, void *dev, struct virtio_device *vdev,
 		.bar[2]			= cpu_to_le32(msix_io_block
 							| PCI_BASE_ADDRESS_SPACE_MEMORY),
 		.status			= cpu_to_le16(PCI_STATUS_CAP_LIST),
-		.capabilities		= (void *)&vpci->pci_hdr.msix - (void *)&vpci->pci_hdr,
+		.capabilities		= PCI_CAP_OFF(&vpci->pci_hdr, msix),
 		.bar_size[0]		= cpu_to_le32(PCI_IO_SIZE),
 		.bar_size[1]		= cpu_to_le32(PCI_IO_SIZE),
 		.bar_size[2]		= cpu_to_le32(VIRTIO_MSIX_BAR_SIZE),
@@ -414,6 +415,11 @@ int virtio_pci__init(struct kvm *kvm, void *dev, struct virtio_device *vdev,
 	if (r < 0)
 		return r;
 
+	if (vdev->legacy)
+		vpci->doorbell_offset = VIRTIO_PCI_QUEUE_NOTIFY;
+	else
+		return virtio_pci_modern_init(vdev);
+
 	return 0;
 }
 
-- 
2.36.1

