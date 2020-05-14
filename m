Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CE1A91D354B
	for <lists+kvm@lfdr.de>; Thu, 14 May 2020 17:39:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728041AbgENPiw (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 14 May 2020 11:38:52 -0400
Received: from foss.arm.com ([217.140.110.172]:39210 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728040AbgENPiv (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 14 May 2020 11:38:51 -0400
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 59D781045;
        Thu, 14 May 2020 08:38:50 -0700 (PDT)
Received: from e121566-lin.arm.com (unknown [10.57.31.200])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 237ED3F71E;
        Thu, 14 May 2020 08:38:49 -0700 (PDT)
From:   Alexandru Elisei <alexandru.elisei@arm.com>
To:     kvm@vger.kernel.org
Cc:     will@kernel.org, julien.thierry.kdev@gmail.com,
        andre.przywara@arm.com, sami.mujawar@arm.com,
        lorenzo.pieralisi@arm.com, maz@kernel.org
Subject: [PATCH v4 kvmtool 08/12] pci: Implement callbacks for toggling BAR emulation
Date:   Thu, 14 May 2020 16:38:25 +0100
Message-Id: <1589470709-4104-9-git-send-email-alexandru.elisei@arm.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1589470709-4104-1-git-send-email-alexandru.elisei@arm.com>
References: <1589470709-4104-1-git-send-email-alexandru.elisei@arm.com>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Implement callbacks for activating and deactivating emulation for a BAR
region. This is in preparation for allowing a guest operating system to
enable and disable access to I/O or memory space, or to reassign the
BARs.

The emulated vesa device framebuffer isn't designed to allow stopping and
restarting at arbitrary points in the guest execution. Furthermore, on x86,
the kernel will not change the BAR addresses, which on bare metal are
programmed by the firmware, so take the easy way out and refuse to
activate/deactivate emulation for the BAR regions. We also take this
opportunity to make the vesa emulation code more consistent by moving all
static variable definitions in one place, at the top of the file.

Signed-off-by: Alexandru Elisei <alexandru.elisei@arm.com>
---
 hw/vesa.c         |  70 ++++++++++++++++++++++-------------
 include/kvm/pci.h |  18 ++++++++-
 pci.c             |  39 ++++++++++++++++++++
 vfio/pci.c        | 107 ++++++++++++++++++++++++++++++++++++++++++++++--------
 virtio/pci.c      |  92 ++++++++++++++++++++++++++++++++++------------
 5 files changed, 258 insertions(+), 68 deletions(-)

diff --git a/hw/vesa.c b/hw/vesa.c
index a4ec7e16e1e6..8659a0028d31 100644
--- a/hw/vesa.c
+++ b/hw/vesa.c
@@ -18,6 +18,31 @@
 #include <inttypes.h>
 #include <unistd.h>
 
+static struct pci_device_header vesa_pci_device = {
+	.vendor_id	= cpu_to_le16(PCI_VENDOR_ID_REDHAT_QUMRANET),
+	.device_id	= cpu_to_le16(PCI_DEVICE_ID_VESA),
+	.header_type	= PCI_HEADER_TYPE_NORMAL,
+	.revision_id	= 0,
+	.class[2]	= 0x03,
+	.subsys_vendor_id = cpu_to_le16(PCI_SUBSYSTEM_VENDOR_ID_REDHAT_QUMRANET),
+	.subsys_id	= cpu_to_le16(PCI_SUBSYSTEM_ID_VESA),
+	.bar[1]		= cpu_to_le32(VESA_MEM_ADDR | PCI_BASE_ADDRESS_SPACE_MEMORY),
+	.bar_size[1]	= VESA_MEM_SIZE,
+};
+
+static struct device_header vesa_device = {
+	.bus_type	= DEVICE_BUS_PCI,
+	.data		= &vesa_pci_device,
+};
+
+static struct framebuffer vesafb = {
+	.width		= VESA_WIDTH,
+	.height		= VESA_HEIGHT,
+	.depth		= VESA_BPP,
+	.mem_addr	= VESA_MEM_ADDR,
+	.mem_size	= VESA_MEM_SIZE,
+};
+
 static bool vesa_pci_io_in(struct ioport *ioport, struct kvm_cpu *vcpu, u16 port, void *data, int size)
 {
 	return true;
@@ -33,24 +58,19 @@ static struct ioport_operations vesa_io_ops = {
 	.io_out			= vesa_pci_io_out,
 };
 
-static struct pci_device_header vesa_pci_device = {
-	.vendor_id		= cpu_to_le16(PCI_VENDOR_ID_REDHAT_QUMRANET),
-	.device_id		= cpu_to_le16(PCI_DEVICE_ID_VESA),
-	.header_type		= PCI_HEADER_TYPE_NORMAL,
-	.revision_id		= 0,
-	.class[2]		= 0x03,
-	.subsys_vendor_id	= cpu_to_le16(PCI_SUBSYSTEM_VENDOR_ID_REDHAT_QUMRANET),
-	.subsys_id		= cpu_to_le16(PCI_SUBSYSTEM_ID_VESA),
-	.bar[1]			= cpu_to_le32(VESA_MEM_ADDR | PCI_BASE_ADDRESS_SPACE_MEMORY),
-	.bar_size[1]		= VESA_MEM_SIZE,
-};
-
-static struct device_header vesa_device = {
-	.bus_type	= DEVICE_BUS_PCI,
-	.data		= &vesa_pci_device,
-};
+static int vesa__bar_activate(struct kvm *kvm, struct pci_device_header *pci_hdr,
+			      int bar_num, void *data)
+{
+	/* We don't support remapping of the framebuffer. */
+	return 0;
+}
 
-static struct framebuffer vesafb;
+static int vesa__bar_deactivate(struct kvm *kvm, struct pci_device_header *pci_hdr,
+				int bar_num, void *data)
+{
+	/* We don't support remapping of the framebuffer. */
+	return -EINVAL;
+}
 
 struct framebuffer *vesa__init(struct kvm *kvm)
 {
@@ -68,6 +88,11 @@ struct framebuffer *vesa__init(struct kvm *kvm)
 
 	vesa_pci_device.bar[0]		= cpu_to_le32(vesa_base_addr | PCI_BASE_ADDRESS_SPACE_IO);
 	vesa_pci_device.bar_size[0]	= PCI_IO_SIZE;
+	r = pci__register_bar_regions(kvm, &vesa_pci_device, vesa__bar_activate,
+				      vesa__bar_deactivate, NULL);
+	if (r < 0)
+		goto unregister_ioport;
+
 	r = device__register(&vesa_device);
 	if (r < 0)
 		goto unregister_ioport;
@@ -82,15 +107,8 @@ struct framebuffer *vesa__init(struct kvm *kvm)
 	if (r < 0)
 		goto unmap_dev;
 
-	vesafb = (struct framebuffer) {
-		.width			= VESA_WIDTH,
-		.height			= VESA_HEIGHT,
-		.depth			= VESA_BPP,
-		.mem			= mem,
-		.mem_addr		= VESA_MEM_ADDR,
-		.mem_size		= VESA_MEM_SIZE,
-		.kvm			= kvm,
-	};
+	vesafb.mem = mem;
+	vesafb.kvm = kvm;
 	return fb__register(&vesafb);
 
 unmap_dev:
diff --git a/include/kvm/pci.h b/include/kvm/pci.h
index 0f0815b36157..73e06d76d244 100644
--- a/include/kvm/pci.h
+++ b/include/kvm/pci.h
@@ -89,12 +89,19 @@ struct pci_cap_hdr {
 	u8	next;
 };
 
+struct pci_device_header;
+
+typedef int (*bar_activate_fn_t)(struct kvm *kvm,
+				 struct pci_device_header *pci_hdr,
+				 int bar_num, void *data);
+typedef int (*bar_deactivate_fn_t)(struct kvm *kvm,
+				   struct pci_device_header *pci_hdr,
+				   int bar_num, void *data);
+
 #define PCI_BAR_OFFSET(b)	(offsetof(struct pci_device_header, bar[b]))
 #define PCI_DEV_CFG_SIZE	256
 #define PCI_DEV_CFG_MASK	(PCI_DEV_CFG_SIZE - 1)
 
-struct pci_device_header;
-
 struct pci_config_operations {
 	void (*write)(struct kvm *kvm, struct pci_device_header *pci_hdr,
 		      u8 offset, void *data, int sz);
@@ -136,6 +143,9 @@ struct pci_device_header {
 
 	/* Private to lkvm */
 	u32		bar_size[6];
+	bar_activate_fn_t	bar_activate_fn;
+	bar_deactivate_fn_t	bar_deactivate_fn;
+	void *data;
 	struct pci_config_operations	cfg_ops;
 	/*
 	 * PCI INTx# are level-triggered, but virtual device often feature
@@ -162,6 +172,10 @@ void pci__config_rd(struct kvm *kvm, union pci_config_address addr, void *data,
 
 void *pci_find_cap(struct pci_device_header *hdr, u8 cap_type);
 
+int pci__register_bar_regions(struct kvm *kvm, struct pci_device_header *pci_hdr,
+			      bar_activate_fn_t bar_activate_fn,
+			      bar_deactivate_fn_t bar_deactivate_fn, void *data);
+
 static inline bool __pci__memory_space_enabled(u16 command)
 {
 	return command & PCI_COMMAND_MEMORY;
diff --git a/pci.c b/pci.c
index eb0bb366a291..b8e71b5f8d6c 100644
--- a/pci.c
+++ b/pci.c
@@ -66,6 +66,11 @@ int pci__assign_irq(struct pci_device_header *pci_hdr)
 	return pci_hdr->irq_line;
 }
 
+static bool pci_bar_is_implemented(struct pci_device_header *pci_hdr, int bar_num)
+{
+	return pci__bar_size(pci_hdr, bar_num);
+}
+
 static void *pci_config_address_ptr(u16 port)
 {
 	unsigned long offset;
@@ -273,6 +278,40 @@ struct pci_device_header *pci__find_dev(u8 dev_num)
 	return hdr->data;
 }
 
+int pci__register_bar_regions(struct kvm *kvm, struct pci_device_header *pci_hdr,
+			      bar_activate_fn_t bar_activate_fn,
+			      bar_deactivate_fn_t bar_deactivate_fn, void *data)
+{
+	int i, r;
+
+	assert(bar_activate_fn && bar_deactivate_fn);
+
+	pci_hdr->bar_activate_fn = bar_activate_fn;
+	pci_hdr->bar_deactivate_fn = bar_deactivate_fn;
+	pci_hdr->data = data;
+
+	for (i = 0; i < 6; i++) {
+		if (!pci_bar_is_implemented(pci_hdr, i))
+			continue;
+
+		if (pci__bar_is_io(pci_hdr, i) &&
+		    pci__io_space_enabled(pci_hdr)) {
+			r = bar_activate_fn(kvm, pci_hdr, i, data);
+			if (r < 0)
+				return r;
+		}
+
+		if (pci__bar_is_memory(pci_hdr, i) &&
+		    pci__memory_space_enabled(pci_hdr)) {
+			r = bar_activate_fn(kvm, pci_hdr, i, data);
+			if (r < 0)
+				return r;
+		}
+	}
+
+	return 0;
+}
+
 int pci__init(struct kvm *kvm)
 {
 	int r;
diff --git a/vfio/pci.c b/vfio/pci.c
index 2de893407574..34f19792765e 100644
--- a/vfio/pci.c
+++ b/vfio/pci.c
@@ -10,6 +10,8 @@
 #include <sys/resource.h>
 #include <sys/time.h>
 
+#include <assert.h>
+
 /* Wrapper around UAPI vfio_irq_set */
 union vfio_irq_eventfd {
 	struct vfio_irq_set	irq;
@@ -456,6 +458,88 @@ out_unlock:
 	mutex_unlock(&pdev->msi.mutex);
 }
 
+static int vfio_pci_bar_activate(struct kvm *kvm,
+				 struct pci_device_header *pci_hdr,
+				 int bar_num, void *data)
+{
+	struct vfio_device *vdev = data;
+	struct vfio_pci_device *pdev = &vdev->pci;
+	struct vfio_pci_msix_pba *pba = &pdev->msix_pba;
+	struct vfio_pci_msix_table *table = &pdev->msix_table;
+	struct vfio_region *region;
+	bool has_msix;
+	int ret;
+
+	assert((u32)bar_num < vdev->info.num_regions);
+
+	region = &vdev->regions[bar_num];
+	has_msix = pdev->irq_modes & VFIO_PCI_IRQ_MODE_MSIX;
+
+	if (has_msix && (u32)bar_num == table->bar) {
+		ret = kvm__register_mmio(kvm, table->guest_phys_addr,
+					 table->size, false,
+					 vfio_pci_msix_table_access, pdev);
+		/*
+		 * The MSIX table and the PBA structure can share the same BAR,
+		 * but for convenience we register different regions for mmio
+		 * emulation. We want to we update both if they share the same
+		 * BAR.
+		 */
+		if (ret < 0 || table->bar != pba->bar)
+			goto out;
+	}
+
+	if (has_msix && (u32)bar_num == pba->bar) {
+		ret = kvm__register_mmio(kvm, pba->guest_phys_addr,
+					 pba->size, false,
+					 vfio_pci_msix_pba_access, pdev);
+		goto out;
+	}
+
+	ret = vfio_map_region(kvm, vdev, region);
+out:
+	return ret;
+}
+
+static int vfio_pci_bar_deactivate(struct kvm *kvm,
+				   struct pci_device_header *pci_hdr,
+				   int bar_num, void *data)
+{
+	struct vfio_device *vdev = data;
+	struct vfio_pci_device *pdev = &vdev->pci;
+	struct vfio_pci_msix_pba *pba = &pdev->msix_pba;
+	struct vfio_pci_msix_table *table = &pdev->msix_table;
+	struct vfio_region *region;
+	bool has_msix, success;
+	int ret;
+
+	assert((u32)bar_num < vdev->info.num_regions);
+
+	region = &vdev->regions[bar_num];
+	has_msix = pdev->irq_modes & VFIO_PCI_IRQ_MODE_MSIX;
+
+	if (has_msix && (u32)bar_num == table->bar) {
+		success = kvm__deregister_mmio(kvm, table->guest_phys_addr);
+		/* kvm__deregister_mmio fails when the region is not found. */
+		ret = (success ? 0 : -ENOENT);
+		/* See vfio_pci_bar_activate(). */
+		if (ret < 0 || table->bar!= pba->bar)
+			goto out;
+	}
+
+	if (has_msix && (u32)bar_num == pba->bar) {
+		success = kvm__deregister_mmio(kvm, pba->guest_phys_addr);
+		ret = (success ? 0 : -ENOENT);
+		goto out;
+	}
+
+	vfio_unmap_region(kvm, region);
+	ret = 0;
+
+out:
+	return ret;
+}
+
 static void vfio_pci_cfg_read(struct kvm *kvm, struct pci_device_header *pci_hdr,
 			      u8 offset, void *data, int sz)
 {
@@ -818,12 +902,6 @@ static int vfio_pci_create_msix_table(struct kvm *kvm, struct vfio_device *vdev)
 		ret = -ENOMEM;
 		goto out_free;
 	}
-	pba->guest_phys_addr = table->guest_phys_addr + table->size;
-
-	ret = kvm__register_mmio(kvm, table->guest_phys_addr, table->size,
-				 false, vfio_pci_msix_table_access, pdev);
-	if (ret < 0)
-		goto out_free;
 
 	/*
 	 * We could map the physical PBA directly into the guest, but it's
@@ -833,10 +911,7 @@ static int vfio_pci_create_msix_table(struct kvm *kvm, struct vfio_device *vdev)
 	 * between MSI-X table and PBA. For the sake of isolation, create a
 	 * virtual PBA.
 	 */
-	ret = kvm__register_mmio(kvm, pba->guest_phys_addr, pba->size, false,
-				 vfio_pci_msix_pba_access, pdev);
-	if (ret < 0)
-		goto out_free;
+	pba->guest_phys_addr = table->guest_phys_addr + table->size;
 
 	pdev->msix.entries = entries;
 	pdev->msix.nr_entries = nr_entries;
@@ -907,11 +982,6 @@ static int vfio_pci_configure_bar(struct kvm *kvm, struct vfio_device *vdev,
 		region->guest_phys_addr = pci_get_mmio_block(map_size);
 	}
 
-	/* Map the BARs into the guest or setup a trap region. */
-	ret = vfio_map_region(kvm, vdev, region);
-	if (ret)
-		return ret;
-
 	return 0;
 }
 
@@ -958,7 +1028,12 @@ static int vfio_pci_configure_dev_regions(struct kvm *kvm,
 	}
 
 	/* We've configured the BARs, fake up a Configuration Space */
-	return vfio_pci_fixup_cfg_space(vdev);
+	ret = vfio_pci_fixup_cfg_space(vdev);
+	if (ret)
+		return ret;
+
+	return pci__register_bar_regions(kvm, &pdev->hdr, vfio_pci_bar_activate,
+					 vfio_pci_bar_deactivate, vdev);
 }
 
 /*
diff --git a/virtio/pci.c b/virtio/pci.c
index eded8685e1b3..6eea6c686695 100644
--- a/virtio/pci.c
+++ b/virtio/pci.c
@@ -11,6 +11,7 @@
 #include <sys/ioctl.h>
 #include <linux/virtio_pci.h>
 #include <linux/byteorder.h>
+#include <assert.h>
 #include <string.h>
 
 static u16 virtio_pci__port_addr(struct virtio_pci *vpci)
@@ -462,6 +463,66 @@ static void virtio_pci__io_mmio_callback(struct kvm_cpu *vcpu,
 		virtio_pci__data_out(vcpu, vdev, addr - mmio_addr, data, len);
 }
 
+static int virtio_pci__bar_activate(struct kvm *kvm,
+				    struct pci_device_header *pci_hdr,
+				    int bar_num, void *data)
+{
+	struct virtio_device *vdev = data;
+	u32 bar_addr, bar_size;
+	int r = -EINVAL;
+
+	assert(bar_num <= 2);
+
+	bar_addr = pci__bar_address(pci_hdr, bar_num);
+	bar_size = pci__bar_size(pci_hdr, bar_num);
+
+	switch (bar_num) {
+	case 0:
+		r = ioport__register(kvm, bar_addr, &virtio_pci__io_ops,
+				     bar_size, vdev);
+		if (r > 0)
+			r = 0;
+		break;
+	case 1:
+		r =  kvm__register_mmio(kvm, bar_addr, bar_size, false,
+					virtio_pci__io_mmio_callback, vdev);
+		break;
+	case 2:
+		r =  kvm__register_mmio(kvm, bar_addr, bar_size, false,
+					virtio_pci__msix_mmio_callback, vdev);
+		break;
+	}
+
+	return r;
+}
+
+static int virtio_pci__bar_deactivate(struct kvm *kvm,
+				      struct pci_device_header *pci_hdr,
+				      int bar_num, void *data)
+{
+	u32 bar_addr;
+	bool success;
+	int r = -EINVAL;
+
+	assert(bar_num <= 2);
+
+	bar_addr = pci__bar_address(pci_hdr, bar_num);
+
+	switch (bar_num) {
+	case 0:
+		r = ioport__unregister(kvm, bar_addr);
+		break;
+	case 1:
+	case 2:
+		success = kvm__deregister_mmio(kvm, bar_addr);
+		/* kvm__deregister_mmio fails when the region is not found. */
+		r = (success ? 0 : -ENOENT);
+		break;
+	}
+
+	return r;
+}
+
 int virtio_pci__init(struct kvm *kvm, void *dev, struct virtio_device *vdev,
 		     int device_id, int subsys_id, int class)
 {
@@ -476,23 +537,8 @@ int virtio_pci__init(struct kvm *kvm, void *dev, struct virtio_device *vdev,
 	BUILD_BUG_ON(!is_power_of_two(PCI_IO_SIZE));
 
 	port_addr = pci_get_io_port_block(PCI_IO_SIZE);
-	r = ioport__register(kvm, port_addr, &virtio_pci__io_ops, PCI_IO_SIZE,
-			     vdev);
-	if (r < 0)
-		return r;
-	port_addr = (u16)r;
-
 	mmio_addr = pci_get_mmio_block(PCI_IO_SIZE);
-	r = kvm__register_mmio(kvm, mmio_addr, PCI_IO_SIZE, false,
-			       virtio_pci__io_mmio_callback, vdev);
-	if (r < 0)
-		goto free_ioport;
-
 	msix_io_block = pci_get_mmio_block(PCI_IO_SIZE * 2);
-	r = kvm__register_mmio(kvm, msix_io_block, PCI_IO_SIZE * 2, false,
-			       virtio_pci__msix_mmio_callback, vdev);
-	if (r < 0)
-		goto free_mmio;
 
 	vpci->pci_hdr = (struct pci_device_header) {
 		.vendor_id		= cpu_to_le16(PCI_VENDOR_ID_REDHAT_QUMRANET),
@@ -518,6 +564,12 @@ int virtio_pci__init(struct kvm *kvm, void *dev, struct virtio_device *vdev,
 		.bar_size[2]		= cpu_to_le32(PCI_IO_SIZE*2),
 	};
 
+	r = pci__register_bar_regions(kvm, &vpci->pci_hdr,
+				      virtio_pci__bar_activate,
+				      virtio_pci__bar_deactivate, vdev);
+	if (r < 0)
+		return r;
+
 	vpci->dev_hdr = (struct device_header) {
 		.bus_type		= DEVICE_BUS_PCI,
 		.data			= &vpci->pci_hdr,
@@ -550,17 +602,9 @@ int virtio_pci__init(struct kvm *kvm, void *dev, struct virtio_device *vdev,
 
 	r = device__register(&vpci->dev_hdr);
 	if (r < 0)
-		goto free_msix_mmio;
+		return r;
 
 	return 0;
-
-free_msix_mmio:
-	kvm__deregister_mmio(kvm, msix_io_block);
-free_mmio:
-	kvm__deregister_mmio(kvm, mmio_addr);
-free_ioport:
-	ioport__unregister(kvm, port_addr);
-	return r;
 }
 
 int virtio_pci__reset(struct kvm *kvm, struct virtio_device *vdev)
-- 
2.7.4

