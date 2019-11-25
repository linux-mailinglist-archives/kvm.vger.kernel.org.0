Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1E933108BCC
	for <lists+kvm@lfdr.de>; Mon, 25 Nov 2019 11:32:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727630AbfKYKcu (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 25 Nov 2019 05:32:50 -0500
Received: from foss.arm.com ([217.140.110.172]:47822 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727604AbfKYKct (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 25 Nov 2019 05:32:49 -0500
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 484CA55D;
        Mon, 25 Nov 2019 02:32:48 -0800 (PST)
Received: from e123195-lin.cambridge.arm.com (e123195-lin.cambridge.arm.com [10.1.196.63])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id 5E2D63F52E;
        Mon, 25 Nov 2019 02:32:47 -0800 (PST)
From:   Alexandru Elisei <alexandru.elisei@arm.com>
To:     kvm@vger.kernel.org
Cc:     will@kernel.org, julien.thierry.kdev@gmail.com,
        andre.przywara@arm.com, sami.mujawar@arm.com,
        lorenzo.pieralisi@arm.com
Subject: [PATCH kvmtool 16/16] Add PCI Express 1.1 support
Date:   Mon, 25 Nov 2019 10:30:33 +0000
Message-Id: <20191125103033.22694-17-alexandru.elisei@arm.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191125103033.22694-1-alexandru.elisei@arm.com>
References: <20191125103033.22694-1-alexandru.elisei@arm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

PCI Express comes with an extended addressing scheme, which directly
translated into a bigger device configuration space (256->4096 bytes)
and bigger PCI configuration space (16->256 MB), as well as mandatory
capabilities (power management and PCI Express capabilities) [1].

Add support for PCI Express in preparation for running EDK2.

We take this opportunity to rewrite the initialization steps in
virtio_pci__init to make it more consistent and easy to follow.

[1] PCI Express Base Specification Revision 1.1

Signed-off-by: Alexandru Elisei <alexandru.elisei@arm.com>
---
 arm/include/arm-common/kvm-arch.h |  2 +-
 arm/pci.c                         |  2 +-
 hw/vesa.c                         | 15 ++++++++
 include/kvm/pci.h                 | 57 +++++++++++++++++++++++-------
 pci.c                             |  5 +--
 virtio/pci.c                      | 58 +++++++++++++++++++++----------
 6 files changed, 104 insertions(+), 35 deletions(-)

diff --git a/arm/include/arm-common/kvm-arch.h b/arm/include/arm-common/kvm-arch.h
index b9d486d5eac2..aafb8bb797cb 100644
--- a/arm/include/arm-common/kvm-arch.h
+++ b/arm/include/arm-common/kvm-arch.h
@@ -23,7 +23,7 @@
 
 #define ARM_IOPORT_SIZE		(ARM_MMIO_AREA - ARM_IOPORT_AREA)
 #define ARM_VIRTIO_MMIO_SIZE	(ARM_AXI_AREA - (ARM_MMIO_AREA + ARM_GIC_SIZE))
-#define ARM_PCI_CFG_SIZE	(1ULL << 24)
+#define ARM_PCI_CFG_SIZE	(1ULL << 28)
 #define ARM_PCI_MMIO_SIZE	(ARM_MEMORY_AREA - \
 				(ARM_AXI_AREA + ARM_PCI_CFG_SIZE))
 
diff --git a/arm/pci.c b/arm/pci.c
index 4e6467357ce8..0c8e3aecc20b 100644
--- a/arm/pci.c
+++ b/arm/pci.c
@@ -80,7 +80,7 @@ void pci__generate_fdt_nodes(void *fdt)
 	_FDT(fdt_property_cell(fdt, "#address-cells", 0x3));
 	_FDT(fdt_property_cell(fdt, "#size-cells", 0x2));
 	_FDT(fdt_property_cell(fdt, "#interrupt-cells", 0x1));
-	_FDT(fdt_property_string(fdt, "compatible", "pci-host-cam-generic"));
+	_FDT(fdt_property_string(fdt, "compatible", "pci-host-ecam-generic"));
 	_FDT(fdt_property(fdt, "dma-coherent", NULL, 0));
 
 	_FDT(fdt_property(fdt, "bus-range", bus_range, sizeof(bus_range)));
diff --git a/hw/vesa.c b/hw/vesa.c
index 0191e9264666..d0caecf0b1b4 100644
--- a/hw/vesa.c
+++ b/hw/vesa.c
@@ -69,6 +69,21 @@ struct framebuffer *vesa__init(struct kvm *kvm)
 
 	vesa_base_addr			= (u16)r;
 	vesa_pci_device.bar[0]		= cpu_to_le32(vesa_base_addr | PCI_BASE_ADDRESS_SPACE_IO);
+	vesa_pci_device.capabilities	= (void *)&vesa_pci_device.pm - (void *)&vesa_pci_device;
+
+	vesa_pci_device.pm = (struct pm_cap) {
+		.cap	= PCI_CAP_ID_PM,
+		.next	= (void *)&vesa_pci_device.pcie - (void *)&vesa_pci_device,
+		.pmc	= PM_CAP_VER,
+		.pmcsr	= PCI_PM_CTRL_NO_SOFT_RESET,
+	};
+
+	vesa_pci_device.pcie = (struct pcie_cap) {
+		.cap		= PCI_CAP_ID_EXP,
+		.next		= 0,
+		.cap_reg	= PCIE_CAP_REG_DEV_LEGACY | PCIE_CAP_REG_VER,
+	};
+
 	device__register(&vesa_device);
 
 	mem = mmap(NULL, VESA_MEM_SIZE, PROT_RW, MAP_ANON_NORESERVE, -1, 0);
diff --git a/include/kvm/pci.h b/include/kvm/pci.h
index ccb155e3e8fe..1ac7809e80ed 100644
--- a/include/kvm/pci.h
+++ b/include/kvm/pci.h
@@ -20,7 +20,11 @@
 #define PCI_CONFIG_BUS_FORWARD	0xcfa
 #define PCI_IO_SIZE		0x100
 #define PCI_IOPORT_START	0x6200
-#define PCI_CFG_SIZE		(1ULL << 24)
+#define PCI_CFG_SIZE		(1ULL << 28)
+
+#define PCIE_CAP_REG_VER	0x1
+#define PCIE_CAP_REG_DEV_LEGACY	(1 << 4)
+#define PM_CAP_VER		0x3
 
 struct kvm;
 
@@ -28,19 +32,19 @@ union pci_config_address {
 	struct {
 #if __BYTE_ORDER == __LITTLE_ENDIAN
 		unsigned	reg_offset	: 2;		/* 1  .. 0  */
-		unsigned	register_number	: 6;		/* 7  .. 2  */
-		unsigned	function_number	: 3;		/* 10 .. 8  */
-		unsigned	device_number	: 5;		/* 15 .. 11 */
-		unsigned	bus_number	: 8;		/* 23 .. 16 */
-		unsigned	reserved	: 7;		/* 30 .. 24 */
+		unsigned	register_number	: 10;		/* 11 .. 2  */
+		unsigned	function_number	: 3;		/* 14 .. 12  */
+		unsigned	device_number	: 5;		/* 19 .. 15 */
+		unsigned	bus_number	: 8;		/* 27 .. 20 */
+		unsigned	reserved	: 3;		/* 30 .. 28 */
 		unsigned	enable_bit	: 1;		/* 31       */
 #else
 		unsigned	enable_bit	: 1;		/* 31       */
-		unsigned	reserved	: 7;		/* 30 .. 24 */
-		unsigned	bus_number	: 8;		/* 23 .. 16 */
-		unsigned	device_number	: 5;		/* 15 .. 11 */
-		unsigned	function_number	: 3;		/* 10 .. 8  */
-		unsigned	register_number	: 6;		/* 7  .. 2  */
+		unsigned	reserved	: 3;		/* 30 .. 28 */
+		unsigned	bus_number	: 8;		/* 27 .. 20 */
+		unsigned	device_number	: 5;		/* 19 .. 15 */
+		unsigned	function_number	: 3;		/* 14 .. 12  */
+		unsigned	register_number	: 10;		/* 11 .. 2  */
 		unsigned	reg_offset	: 2;		/* 1  .. 0  */
 #endif
 	};
@@ -88,8 +92,35 @@ struct pci_cap_hdr {
 	u8	next;
 };
 
+struct pcie_cap {
+	u8 cap;
+	u8 next;
+	u16 cap_reg;
+	u32 dev_cap;
+	u16 dev_ctrl;
+	u16 dev_status;
+	u32 link_cap;
+	u16 link_ctrl;
+	u16 link_status;
+	u32 slot_cap;
+	u16 slot_ctrl;
+	u16 slot_status;
+	u16 root_ctrl;
+	u16 root_cap;
+	u32 root_status;
+};
+
+struct pm_cap {
+	u8 cap;
+	u8 next;
+	u16 pmc;
+	u16 pmcsr;
+	u8 pmcsr_bse;
+	u8 data;
+};
+
 #define PCI_BAR_OFFSET(b)	(offsetof(struct pci_device_header, bar[b]))
-#define PCI_DEV_CFG_SIZE	256
+#define PCI_DEV_CFG_SIZE	4096
 #define PCI_DEV_CFG_MASK	(PCI_DEV_CFG_SIZE - 1)
 
 struct pci_device_header;
@@ -127,6 +158,8 @@ struct pci_device_header {
 			u8		irq_pin;
 			u8		min_gnt;
 			u8		max_lat;
+			struct pm_cap pm;
+			struct pcie_cap pcie;
 			struct msix_cap msix;
 		} __attribute__((packed));
 		/* Pad to PCI config space size */
diff --git a/pci.c b/pci.c
index b4677434c50c..f1bfa5a8d157 100644
--- a/pci.c
+++ b/pci.c
@@ -155,7 +155,8 @@ static struct ioport_operations pci_config_data_ops = {
 void pci__config_wr(struct kvm *kvm, union pci_config_address addr, void *data, int size)
 {
 	void *base;
-	u8 bar, offset;
+	u8 bar;
+	u16 offset;
 	struct pci_device_header *pci_hdr;
 	u8 dev_num = addr.device_number;
 	u32 value = 0;
@@ -222,7 +223,7 @@ void pci__config_wr(struct kvm *kvm, union pci_config_address addr, void *data,
 
 void pci__config_rd(struct kvm *kvm, union pci_config_address addr, void *data, int size)
 {
-	u8 offset;
+	u16 offset;
 	struct pci_device_header *pci_hdr;
 	u8 dev_num = addr.device_number;
 
diff --git a/virtio/pci.c b/virtio/pci.c
index dadb796e6d62..004a136af672 100644
--- a/virtio/pci.c
+++ b/virtio/pci.c
@@ -666,36 +666,56 @@ int virtio_pci__init(struct kvm *kvm, void *dev, struct virtio_device *vdev,
 		.bar[1]                 = vpci->mmio_addr | PCI_BASE_ADDRESS_SPACE_MEMORY,
 		.bar[2]                 = vpci->msix_io_block | PCI_BASE_ADDRESS_SPACE_MEMORY,
 		.status			= cpu_to_le16(PCI_STATUS_CAP_LIST),
-		.capabilities		= (void *)&vpci->pci_hdr.msix - (void *)&vpci->pci_hdr,
+		.capabilities		= (void *)&vpci->pci_hdr.pm - (void *)&vpci->pci_hdr,
 		.bar_size[0]		= cpu_to_le32(PCI_IO_SIZE),
 		.bar_size[1]		= cpu_to_le32(PCI_IO_SIZE),
 		.bar_size[2]		= cpu_to_le32(PCI_IO_SIZE*2),
 		.cfg_ops.write		= virtio_pci__config_wr,
 	};
 
+	vpci->pci_hdr.pm = (struct pm_cap) {
+		.cap	= PCI_CAP_ID_PM,
+		.next	= (void *)&vpci->pci_hdr.pcie - (void *)&vpci->pci_hdr,
+		.pmc	= PM_CAP_VER,
+		/*
+		 * We don't do device state emulation, let the driver know that
+		 * going from D0->D3hot->D0 won't change the internal state of
+		 * the device.
+		 */
+		.pmcsr	= PCI_PM_CTRL_NO_SOFT_RESET,
+	};
+
+	vpci->pci_hdr.pcie = (struct pcie_cap) {
+		.cap		= PCI_CAP_ID_EXP,
+		.next		= (void *)&vpci->pci_hdr.msix - (void *)&vpci->pci_hdr,
+		.cap_reg	= PCIE_CAP_REG_DEV_LEGACY | PCIE_CAP_REG_VER,
+	};
+
+	vpci->pci_hdr.msix = (struct msix_cap) {
+		.cap		= PCI_CAP_ID_MSIX,
+		.next		= 0,
+		/*
+		 * We at most have VIRTIO_PCI_MAX_VQ entries for virt queue,
+		 * VIRTIO_PCI_MAX_CONFIG entries for config.
+		 *
+		 * To quote the PCI spec:
+		 *
+		 * System software reads this field to determine the
+		 * MSI-X Table Size N, which is encoded as N-1.
+		 * For example, a returned value of "00000000011"
+		 * indicates a table size of 4.
+		 */
+		.ctrl		= cpu_to_le16(VIRTIO_PCI_MAX_VQ + VIRTIO_PCI_MAX_CONFIG - 1),
+		/* Both table and PBA are mapped to the same BAR (2) */
+		.table_offset	= cpu_to_le32(2),
+		.pba_offset	= cpu_to_le32(2 | PCI_IO_SIZE),
+	};
+
 	vpci->dev_hdr = (struct device_header) {
 		.bus_type		= DEVICE_BUS_PCI,
 		.data			= &vpci->pci_hdr,
 	};
 
-	vpci->pci_hdr.msix.cap = PCI_CAP_ID_MSIX;
-	vpci->pci_hdr.msix.next = 0;
-	/*
-	 * We at most have VIRTIO_PCI_MAX_VQ entries for virt queue,
-	 * VIRTIO_PCI_MAX_CONFIG entries for config.
-	 *
-	 * To quote the PCI spec:
-	 *
-	 * System software reads this field to determine the
-	 * MSI-X Table Size N, which is encoded as N-1.
-	 * For example, a returned value of "00000000011"
-	 * indicates a table size of 4.
-	 */
-	vpci->pci_hdr.msix.ctrl = cpu_to_le16(VIRTIO_PCI_MAX_VQ + VIRTIO_PCI_MAX_CONFIG - 1);
-
-	/* Both table and PBA are mapped to the same BAR (2) */
-	vpci->pci_hdr.msix.table_offset = cpu_to_le32(2);
-	vpci->pci_hdr.msix.pba_offset = cpu_to_le32(2 | PCI_IO_SIZE);
 	vpci->config_vector = 0;
 
 	if (irq__can_signal_msi(kvm))
-- 
2.20.1

