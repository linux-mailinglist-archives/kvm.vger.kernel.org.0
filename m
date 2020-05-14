Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DA6161D354D
	for <lists+kvm@lfdr.de>; Thu, 14 May 2020 17:39:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727939AbgENPiz (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 14 May 2020 11:38:55 -0400
Received: from foss.arm.com ([217.140.110.172]:39228 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728054AbgENPiy (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 14 May 2020 11:38:54 -0400
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id C93391FB;
        Thu, 14 May 2020 08:38:53 -0700 (PDT)
Received: from e121566-lin.arm.com (unknown [10.57.31.200])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id E30043F71E;
        Thu, 14 May 2020 08:38:51 -0700 (PDT)
From:   Alexandru Elisei <alexandru.elisei@arm.com>
To:     kvm@vger.kernel.org
Cc:     will@kernel.org, julien.thierry.kdev@gmail.com,
        andre.przywara@arm.com, sami.mujawar@arm.com,
        lorenzo.pieralisi@arm.com, maz@kernel.org
Subject: [PATCH v4 kvmtool 10/12] pci: Implement reassignable BARs
Date:   Thu, 14 May 2020 16:38:27 +0100
Message-Id: <1589470709-4104-11-git-send-email-alexandru.elisei@arm.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1589470709-4104-1-git-send-email-alexandru.elisei@arm.com>
References: <1589470709-4104-1-git-send-email-alexandru.elisei@arm.com>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

BARs are used by the guest to configure the access to the PCI device by
writing the address to which the device will respond. The basic idea for
adding support for reassignable BARs is straightforward: deactivate
emulation for the memory region described by the old BAR value, and
activate emulation for the new region.

BAR reassignment can be done while device access is enabled and memory
regions for different devices can overlap as long as no access is made to
the overlapping memory regions. This means that it is legal for the BARs of
two distinct devices to point to an overlapping memory region, and indeed,
this is how Linux does resource assignment at boot. To account for this
situation, the simple algorithm described above is enhanced to scan for all
devices and:

- Deactivate emulation for any BARs that might overlap with the new BAR
  value.

- Enable emulation for any BARs that were overlapping with the old value
  after the BAR has been updated.

Activating/deactivating emulation of a memory region has side effects.  In
order to prevent the execution of the same callback twice we now keep track
of the state of the region emulation. For example, this can happen if we
program a BAR with an address that overlaps a second BAR, thus deactivating
emulation for the second BAR, and then we disable all region accesses to
the second BAR by writing to the command register.

Signed-off-by: Alexandru Elisei <alexandru.elisei@arm.com>
---
 include/kvm/pci.h |  14 ++-
 pci.c             | 250 +++++++++++++++++++++++++++++++++++++++++++-----------
 vfio/pci.c        |  12 +++
 3 files changed, 227 insertions(+), 49 deletions(-)

diff --git a/include/kvm/pci.h b/include/kvm/pci.h
index 73e06d76d244..bf81323d83b7 100644
--- a/include/kvm/pci.h
+++ b/include/kvm/pci.h
@@ -11,6 +11,17 @@
 #include "kvm/msi.h"
 #include "kvm/fdt.h"
 
+#define pci_dev_err(pci_hdr, fmt, ...) \
+	pr_err("[%04x:%04x] " fmt, pci_hdr->vendor_id, pci_hdr->device_id, ##__VA_ARGS__)
+#define pci_dev_warn(pci_hdr, fmt, ...) \
+	pr_warning("[%04x:%04x] " fmt, pci_hdr->vendor_id, pci_hdr->device_id, ##__VA_ARGS__)
+#define pci_dev_info(pci_hdr, fmt, ...) \
+	pr_info("[%04x:%04x] " fmt, pci_hdr->vendor_id, pci_hdr->device_id, ##__VA_ARGS__)
+#define pci_dev_dbg(pci_hdr, fmt, ...) \
+	pr_debug("[%04x:%04x] " fmt, pci_hdr->vendor_id, pci_hdr->device_id, ##__VA_ARGS__)
+#define pci_dev_die(pci_hdr, fmt, ...) \
+	die("[%04x:%04x] " fmt, pci_hdr->vendor_id, pci_hdr->device_id, ##__VA_ARGS__)
+
 /*
  * PCI Configuration Mechanism #1 I/O ports. See Section 3.7.4.1.
  * ("Configuration Mechanism #1") of the PCI Local Bus Specification 2.1 for
@@ -142,7 +153,8 @@ struct pci_device_header {
 	};
 
 	/* Private to lkvm */
-	u32		bar_size[6];
+	u32			bar_size[6];
+	bool			bar_active[6];
 	bar_activate_fn_t	bar_activate_fn;
 	bar_deactivate_fn_t	bar_deactivate_fn;
 	void *data;
diff --git a/pci.c b/pci.c
index 96239160110c..2e2c0270a166 100644
--- a/pci.c
+++ b/pci.c
@@ -71,6 +71,11 @@ static bool pci_bar_is_implemented(struct pci_device_header *pci_hdr, int bar_nu
 	return pci__bar_size(pci_hdr, bar_num);
 }
 
+static bool pci_bar_is_active(struct pci_device_header *pci_hdr, int bar_num)
+{
+	return  pci_hdr->bar_active[bar_num];
+}
+
 static void *pci_config_address_ptr(u16 port)
 {
 	unsigned long offset;
@@ -163,6 +168,46 @@ static struct ioport_operations pci_config_data_ops = {
 	.io_out	= pci_config_data_out,
 };
 
+static int pci_activate_bar(struct kvm *kvm, struct pci_device_header *pci_hdr,
+			    int bar_num)
+{
+	int r = 0;
+
+	if (pci_bar_is_active(pci_hdr, bar_num))
+		goto out;
+
+	r = pci_hdr->bar_activate_fn(kvm, pci_hdr, bar_num, pci_hdr->data);
+	if (r < 0) {
+		pci_dev_warn(pci_hdr, "Error activating emulation for BAR %d",
+			     bar_num);
+		goto out;
+	}
+	pci_hdr->bar_active[bar_num] = true;
+
+out:
+	return r;
+}
+
+static int pci_deactivate_bar(struct kvm *kvm, struct pci_device_header *pci_hdr,
+			      int bar_num)
+{
+	int r = 0;
+
+	if (!pci_bar_is_active(pci_hdr, bar_num))
+		goto out;
+
+	r = pci_hdr->bar_deactivate_fn(kvm, pci_hdr, bar_num, pci_hdr->data);
+	if (r < 0) {
+		pci_dev_warn(pci_hdr, "Error deactivating emulation for BAR %d",
+			     bar_num);
+		goto out;
+	}
+	pci_hdr->bar_active[bar_num] = false;
+
+out:
+	return r;
+}
+
 static void pci_config_command_wr(struct kvm *kvm,
 				  struct pci_device_header *pci_hdr,
 				  u16 new_command)
@@ -179,26 +224,167 @@ static void pci_config_command_wr(struct kvm *kvm,
 
 		if (toggle_io && pci__bar_is_io(pci_hdr, i)) {
 			if (__pci__io_space_enabled(new_command))
-				pci_hdr->bar_activate_fn(kvm, pci_hdr, i,
-							 pci_hdr->data);
+				pci_activate_bar(kvm, pci_hdr, i);
 			else
-				pci_hdr->bar_deactivate_fn(kvm, pci_hdr, i,
-							   pci_hdr->data);
+				pci_deactivate_bar(kvm, pci_hdr, i);
 		}
 
 		if (toggle_mem && pci__bar_is_memory(pci_hdr, i)) {
 			if (__pci__memory_space_enabled(new_command))
-				pci_hdr->bar_activate_fn(kvm, pci_hdr, i,
-							 pci_hdr->data);
+				pci_activate_bar(kvm, pci_hdr, i);
 			else
-				pci_hdr->bar_deactivate_fn(kvm, pci_hdr, i,
-							   pci_hdr->data);
+				pci_deactivate_bar(kvm, pci_hdr, i);
 		}
 	}
 
 	pci_hdr->command = new_command;
 }
 
+static int pci_toggle_bar_regions(bool activate, struct kvm *kvm, u32 start, u32 size)
+{
+	struct device_header *dev_hdr;
+	struct pci_device_header *tmp_hdr;
+	u32 tmp_start, tmp_size;
+	int i, r;
+
+	dev_hdr = device__first_dev(DEVICE_BUS_PCI);
+	while (dev_hdr) {
+		tmp_hdr = dev_hdr->data;
+		for (i = 0; i < 6; i++) {
+			if (!pci_bar_is_implemented(tmp_hdr, i))
+				continue;
+
+			tmp_start = pci__bar_address(tmp_hdr, i);
+			tmp_size = pci__bar_size(tmp_hdr, i);
+			if (tmp_start + tmp_size <= start ||
+			    tmp_start >= start + size)
+				continue;
+
+			if (activate)
+				r = pci_activate_bar(kvm, tmp_hdr, i);
+			else
+				r = pci_deactivate_bar(kvm, tmp_hdr, i);
+			if (r < 0)
+				return r;
+		}
+		dev_hdr = device__next_dev(dev_hdr);
+	}
+
+	return 0;
+}
+
+static inline int pci_activate_bar_regions(struct kvm *kvm, u32 start, u32 size)
+{
+	return pci_toggle_bar_regions(true, kvm, start, size);
+}
+
+static inline int pci_deactivate_bar_regions(struct kvm *kvm, u32 start, u32 size)
+{
+	return pci_toggle_bar_regions(false, kvm, start, size);
+}
+
+static void pci_config_bar_wr(struct kvm *kvm,
+			      struct pci_device_header *pci_hdr, int bar_num,
+			      u32 value)
+{
+	u32 old_addr, new_addr, bar_size;
+	u32 mask;
+	int r;
+
+	if (pci__bar_is_io(pci_hdr, bar_num))
+		mask = (u32)PCI_BASE_ADDRESS_IO_MASK;
+	else
+		mask = (u32)PCI_BASE_ADDRESS_MEM_MASK;
+
+	/*
+	 * If the kernel masks the BAR, it will expect to find the size of the
+	 * BAR there next time it reads from it. After the kernel reads the
+	 * size, it will write the address back.
+	 *
+	 * According to the PCI local bus specification REV 3.0: The number of
+	 * upper bits that a device actually implements depends on how much of
+	 * the address space the device will respond to. A device that wants a 1
+	 * MB memory address space (using a 32-bit base address register) would
+	 * build the top 12 bits of the address register, hardwiring the other
+	 * bits to 0.
+	 *
+	 * Furthermore, software can determine how much address space the device
+	 * requires by writing a value of all 1's to the register and then
+	 * reading the value back. The device will return 0's in all don't-care
+	 * address bits, effectively specifying the address space required.
+	 *
+	 * Software computes the size of the address space with the formula
+	 * S =  ~B + 1, where S is the memory size and B is the value read from
+	 * the BAR. This means that the BAR value that kvmtool should return is
+	 * B = ~(S - 1).
+	 */
+	if (value == 0xffffffff) {
+		value = ~(pci__bar_size(pci_hdr, bar_num) - 1);
+		/* Preserve the special bits. */
+		value = (value & mask) | (pci_hdr->bar[bar_num] & ~mask);
+		pci_hdr->bar[bar_num] = value;
+		return;
+	}
+
+	value = (value & mask) | (pci_hdr->bar[bar_num] & ~mask);
+
+	/* Don't toggle emulation when region type access is disbled. */
+	if (pci__bar_is_io(pci_hdr, bar_num) &&
+	    !pci__io_space_enabled(pci_hdr)) {
+		pci_hdr->bar[bar_num] = value;
+		return;
+	}
+
+	if (pci__bar_is_memory(pci_hdr, bar_num) &&
+	    !pci__memory_space_enabled(pci_hdr)) {
+		pci_hdr->bar[bar_num] = value;
+		return;
+	}
+
+	/*
+	 * BAR reassignment can be done while device access is enabled and
+	 * memory regions for different devices can overlap as long as no access
+	 * is made to the overlapping memory regions. To implement BAR
+	 * reasignment, we deactivate emulation for the region described by the
+	 * BAR value that the guest is changing, we disable emulation for the
+	 * regions that overlap with the new one (by scanning through all PCI
+	 * devices), we enable emulation for the new BAR value and finally we
+	 * enable emulation for all device regions that were overlapping with
+	 * the old value.
+	 */
+	old_addr = pci__bar_address(pci_hdr, bar_num);
+	new_addr = __pci__bar_address(value);
+	bar_size = pci__bar_size(pci_hdr, bar_num);
+
+	r = pci_deactivate_bar(kvm, pci_hdr, bar_num);
+	if (r < 0)
+		return;
+
+	r = pci_deactivate_bar_regions(kvm, new_addr, bar_size);
+	if (r < 0) {
+		/*
+		 * We cannot update the BAR because of an overlapping region
+		 * that failed to deactivate emulation, so keep the old BAR
+		 * value and re-activate emulation for it.
+		 */
+		pci_activate_bar(kvm, pci_hdr, bar_num);
+		return;
+	}
+
+	pci_hdr->bar[bar_num] = value;
+	r = pci_activate_bar(kvm, pci_hdr, bar_num);
+	if (r < 0) {
+		/*
+		 * New region cannot be emulated, re-enable the regions that
+		 * were overlapping.
+		 */
+		pci_activate_bar_regions(kvm, new_addr, bar_size);
+		return;
+	}
+
+	pci_activate_bar_regions(kvm, old_addr, bar_size);
+}
+
 void pci__config_wr(struct kvm *kvm, union pci_config_address addr, void *data, int size)
 {
 	void *base;
@@ -206,7 +392,6 @@ void pci__config_wr(struct kvm *kvm, union pci_config_address addr, void *data,
 	struct pci_device_header *pci_hdr;
 	u8 dev_num = addr.device_number;
 	u32 value = 0;
-	u32 mask;
 
 	if (!pci_device_exists(addr.bus_number, dev_num, 0))
 		return;
@@ -231,46 +416,13 @@ void pci__config_wr(struct kvm *kvm, union pci_config_address addr, void *data,
 	}
 
 	bar = (offset - PCI_BAR_OFFSET(0)) / sizeof(u32);
-
-	/*
-	 * If the kernel masks the BAR, it will expect to find the size of the
-	 * BAR there next time it reads from it. After the kernel reads the
-	 * size, it will write the address back.
-	 */
 	if (bar < 6) {
-		if (pci__bar_is_io(pci_hdr, bar))
-			mask = (u32)PCI_BASE_ADDRESS_IO_MASK;
-		else
-			mask = (u32)PCI_BASE_ADDRESS_MEM_MASK;
-		/*
-		 * According to the PCI local bus specification REV 3.0:
-		 * The number of upper bits that a device actually implements
-		 * depends on how much of the address space the device will
-		 * respond to. A device that wants a 1 MB memory address space
-		 * (using a 32-bit base address register) would build the top
-		 * 12 bits of the address register, hardwiring the other bits
-		 * to 0.
-		 *
-		 * Furthermore, software can determine how much address space
-		 * the device requires by writing a value of all 1's to the
-		 * register and then reading the value back. The device will
-		 * return 0's in all don't-care address bits, effectively
-		 * specifying the address space required.
-		 *
-		 * Software computes the size of the address space with the
-		 * formula S = ~B + 1, where S is the memory size and B is the
-		 * value read from the BAR. This means that the BAR value that
-		 * kvmtool should return is B = ~(S - 1).
-		 */
 		memcpy(&value, data, size);
-		if (value == 0xffffffff)
-			value = ~(pci__bar_size(pci_hdr, bar) - 1);
-		/* Preserve the special bits. */
-		value = (value & mask) | (pci_hdr->bar[bar] & ~mask);
-		memcpy(base + offset, &value, size);
-	} else {
-		memcpy(base + offset, data, size);
+		pci_config_bar_wr(kvm, pci_hdr, bar, value);
+		return;
 	}
+
+	memcpy(base + offset, data, size);
 }
 
 void pci__config_rd(struct kvm *kvm, union pci_config_address addr, void *data, int size)
@@ -336,16 +488,18 @@ int pci__register_bar_regions(struct kvm *kvm, struct pci_device_header *pci_hdr
 		if (!pci_bar_is_implemented(pci_hdr, i))
 			continue;
 
+		assert(!pci_bar_is_active(pci_hdr, i));
+
 		if (pci__bar_is_io(pci_hdr, i) &&
 		    pci__io_space_enabled(pci_hdr)) {
-			r = bar_activate_fn(kvm, pci_hdr, i, data);
+			r = pci_activate_bar(kvm, pci_hdr, i);
 			if (r < 0)
 				return r;
 		}
 
 		if (pci__bar_is_memory(pci_hdr, i) &&
 		    pci__memory_space_enabled(pci_hdr)) {
-			r = bar_activate_fn(kvm, pci_hdr, i, data);
+			r = pci_activate_bar(kvm, pci_hdr, i);
 			if (r < 0)
 				return r;
 		}
diff --git a/vfio/pci.c b/vfio/pci.c
index 34f19792765e..49ecd12a38cd 100644
--- a/vfio/pci.c
+++ b/vfio/pci.c
@@ -467,6 +467,7 @@ static int vfio_pci_bar_activate(struct kvm *kvm,
 	struct vfio_pci_msix_pba *pba = &pdev->msix_pba;
 	struct vfio_pci_msix_table *table = &pdev->msix_table;
 	struct vfio_region *region;
+	u32 bar_addr;
 	bool has_msix;
 	int ret;
 
@@ -475,7 +476,14 @@ static int vfio_pci_bar_activate(struct kvm *kvm,
 	region = &vdev->regions[bar_num];
 	has_msix = pdev->irq_modes & VFIO_PCI_IRQ_MODE_MSIX;
 
+	bar_addr = pci__bar_address(pci_hdr, bar_num);
+	if (pci__bar_is_io(pci_hdr, bar_num))
+		region->port_base = bar_addr;
+	else
+		region->guest_phys_addr = bar_addr;
+
 	if (has_msix && (u32)bar_num == table->bar) {
+		table->guest_phys_addr = region->guest_phys_addr;
 		ret = kvm__register_mmio(kvm, table->guest_phys_addr,
 					 table->size, false,
 					 vfio_pci_msix_table_access, pdev);
@@ -490,6 +498,10 @@ static int vfio_pci_bar_activate(struct kvm *kvm,
 	}
 
 	if (has_msix && (u32)bar_num == pba->bar) {
+		if (pba->bar == table->bar)
+			pba->guest_phys_addr = table->guest_phys_addr + table->size;
+		else
+			pba->guest_phys_addr = region->guest_phys_addr;
 		ret = kvm__register_mmio(kvm, pba->guest_phys_addr,
 					 pba->size, false,
 					 vfio_pci_msix_pba_access, pdev);
-- 
2.7.4

