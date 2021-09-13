Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7902B4097AA
	for <lists+kvm@lfdr.de>; Mon, 13 Sep 2021 17:43:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242273AbhIMPok (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 13 Sep 2021 11:44:40 -0400
Received: from foss.arm.com ([217.140.110.172]:33244 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1344188AbhIMPo3 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 13 Sep 2021 11:44:29 -0400
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 72B8911D4;
        Mon, 13 Sep 2021 08:42:58 -0700 (PDT)
Received: from monolith.cable.virginm.net (unknown [172.31.20.19])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 6B91D3F719;
        Mon, 13 Sep 2021 08:42:57 -0700 (PDT)
From:   Alexandru Elisei <alexandru.elisei@arm.com>
To:     will@kernel.org, julien.thierry.kdev@gmail.com, kvm@vger.kernel.org
Cc:     andre.przywara@arm.com, jean-philippe@linaro.org
Subject: [PATCH v1 kvmtool 5/7] vfio/pci: Rework MSIX table and PBA physical size allocation
Date:   Mon, 13 Sep 2021 16:44:11 +0100
Message-Id: <20210913154413.14322-6-alexandru.elisei@arm.com>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210913154413.14322-1-alexandru.elisei@arm.com>
References: <20210913154413.14322-1-alexandru.elisei@arm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

When creating the MSIX table and PBA, kvmtool rounds up the table and
pending bit array sizes to the host's page size. Unfortunately, when doing
that, it doesn't take into account that the new size can exceed the device
BAR size, leading to hard to diagnose errors for certain configurations.

One theoretical example: PBA and table in the same 4k BAR, host's page size
is 4k. In this case, table->size = 4k, pba->size = 4k, map_size = 4k, which
means that pba->guest_phys_addr = table->guest_phys_addr + 4k, which is
outside of the 4k MMIO range allocated for both structures.

Another example, this time a real-world error that I encountered: happens
with a 64k host booting a 4k guest, an RTL8168 PCIE NIC assigned to the
guest. In this case, kvmtool sets table->size = 64k (because it's rounded
to the host's page size) and pba->size = 64k.

Truncated output of lspci -vv on the host:

01:00.0 Ethernet controller: Realtek Semiconductor Co., Ltd. RTL8111/8168/8411 PCI Express Gigabit Ethernet Controller (rev 06)
	Subsystem: TP-LINK Technologies Co., Ltd. TG-3468 Gigabit PCI Express Network Adapter
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx-
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 0
	Interrupt: pin A routed to IRQ 255
	Region 0: I/O ports at 1000 [size=256]
	Region 2: Memory at 40000000 (64-bit, non-prefetchable) [size=4K]
	Region 4: Memory at 100000000 (64-bit, prefetchable) [size=16K]
	[..]
	Capabilities: [b0] MSI-X: Enable- Count=4 Masked-
		Vector table: BAR=4 offset=00000000
		PBA: BAR=4 offset=00000800
	[..]

When booting the guest:

[..]
[    0.207444] pci-host-generic 40000000.pci: host bridge /pci ranges:
[    0.208564] pci-host-generic 40000000.pci:       IO 0x0000000000..0x000000ffff -> 0x0000000000
[    0.209857] pci-host-generic 40000000.pci:      MEM 0x0050000000..0x007fffffff -> 0x0050000000
[    0.211184] pci-host-generic 40000000.pci: ECAM at [mem 0x40000000-0x4fffffff] for [bus 00]
[    0.212625] pci-host-generic 40000000.pci: PCI host bridge to bus 0000:00
[    0.213647] pci_bus 0000:00: root bus resource [bus 00]
[    0.214429] pci_bus 0000:00: root bus resource [io  0x0000-0xffff]
[    0.215355] pci_bus 0000:00: root bus resource [mem 0x50000000-0x7fffffff]
[    0.216676] pci 0000:00:00.0: [10ec:8168] type 00 class 0x020000
[    0.223771] pci 0000:00:00.0: reg 0x10: [io  0x6200-0x62ff]
[    0.239765] pci 0000:00:00.0: reg 0x18: [mem 0x50010000-0x50010fff]
[    0.244595] pci 0000:00:00.0: reg 0x20: [mem 0x50000000-0x50003fff]
[    0.246331] pci 0000:00:01.0: [1af4:1000] type 00 class 0x020000
[    0.247278] pci 0000:00:01.0: reg 0x10: [io  0x6300-0x63ff]
[    0.248212] pci 0000:00:01.0: reg 0x14: [mem 0x50020000-0x500200ff]
[    0.249172] pci 0000:00:01.0: reg 0x18: [mem 0x50020400-0x500207ff]
[    0.250450] pci 0000:00:02.0: [1af4:1001] type 00 class 0x018000
[    0.251392] pci 0000:00:02.0: reg 0x10: [io  0x6400-0x64ff]
[    0.252351] pci 0000:00:02.0: reg 0x14: [mem 0x50020800-0x500208ff]
[    0.253312] pci 0000:00:02.0: reg 0x18: [mem 0x50020c00-0x50020fff]
(1) [    0.254760] pci 0000:00:00.0: BAR 4: assigned [mem 0x50000000-0x50003fff]
(2) [    0.255805] pci 0000:00:00.0: BAR 2: assigned [mem 0x50004000-0x50004fff]
  Warning: [10ec:8168] Error activating emulation for BAR 2
  Warning: [10ec:8168] Error activating emulation for BAR 2
[    0.260432] pci 0000:00:01.0: BAR 2: assigned [mem 0x50005000-0x500053ff]
  Warning: [1af4:1000] Error activating emulation for BAR 2
  Warning: [1af4:1000] Error activating emulation for BAR 2
[    0.261469] pci 0000:00:02.0: BAR 2: assigned [mem 0x50005400-0x500057ff]
  Warning: [1af4:1001] Error activating emulation for BAR 2
  Warning: [1af4:1001] Error activating emulation for BAR 2
[    0.262499] pci 0000:00:00.0: BAR 0: assigned [io  0x1000-0x10ff]
[    0.263415] pci 0000:00:01.0: BAR 0: assigned [io  0x1100-0x11ff]
[    0.264462] pci 0000:00:01.0: BAR 1: assigned [mem 0x50005800-0x500058ff]
  Warning: [1af4:1000] Error activating emulation for BAR 1
  Warning: [1af4:1000] Error activating emulation for BAR 1
[    0.265481] pci 0000:00:02.0: BAR 0: assigned [io  0x1200-0x12ff]
[    0.266397] pci 0000:00:02.0: BAR 1: assigned [mem 0x50005900-0x500059ff]
  Warning: [1af4:1001] Error activating emulation for BAR 1
  Warning: [1af4:1001] Error activating emulation for BAR 1
[    0.267892] EINJ: ACPI disabled.
[    0.269922] virtio-pci 0000:00:01.0: virtio_pci: leaving for legacy driver
[    0.271118] virtio-pci 0000:00:02.0: virtio_pci: leaving for legacy driver
[    0.274122] Serial: 8250/16550 driver, 4 ports, IRQ sharing enabled
[    0.275930] printk: console [ttyS0] disabled
[    0.276669] 1000000.U6_16550A: ttyS0 at MMIO 0x1000000 (irq = 13, base_baud = 115200) is a 16550A
[    0.278058] printk: console [ttyS0] enabled
[    0.278058] printk: console [ttyS0] enabled
[    0.279304] printk: bootconsole [ns16550a0] disabled
[    0.279304] printk: bootconsole [ns16550a0] disabled
[    0.281252] 1001000.U6_16550A: ttyS1 at MMIO 0x1001000 (irq = 14, base_baud = 115200) is a 16550A
[    0.282842] 1002000.U6_16550A: ttyS2 at MMIO 0x1002000 (irq = 15, base_baud = 115200) is a 16550A
[    0.284611] 1003000.U6_16550A: ttyS3 at MMIO 0x1003000 (irq = 16, base_baud = 115200) is a 16550A
[    0.286094] SuperH (H)SCI(F) driver initialized
[    0.286868] msm_serial: driver initialized
[    0.287890] [drm] radeon kernel modesetting enabled.
[    0.288826] cacheinfo: Unable to detect cache hierarchy for CPU 0
[    0.293321] loop: module loaded
KVM_SET_GSI_ROUTING: Invalid argument

At (1), the guest writes 0x50000000 into BAR 4 of the NIC (which holds
the MSIX table and PBA), expecting that will cover only 16k of address
space (the BAR size), up to 0x50003fff, inclusive. On the host side, in
vfio_pci_bar_activate(), kvmtool will actually register for MMIO
emulation the region 0x50000000-0x5000ffff (64k in total) for the MSIX
table and 0x50010000-0x5001ffff (another 64k) for the PBA (kvmtool set
table->size and pba->size to 64k when it aligned them to the host's page
size).

Then at step (2), the guest writes the next available address (from its
point of view) into BAR 2 of the NIC, which is 0x50004000. On the host
side, the PCI emulation layer will search all the regions that overlap with
the BAR address range (0x50004000-0x50004fff) and will find none because,
just like the guest, it uses the BAR size to check for overlaps. When
vfio_pci_bar_activate() is reached, kvmtool will try to register memory for
this region, but it is already registered for the MSIX table emulation and
fails.

The same scenario repeats for every following memory BAR, because the MSIX
table and PBA use memory from 0x50000000 to 0x5001ffff.

The error at the end, which finally terminates the VM, is caused by the
guest trying to write to a totally different BAR, which vfio-pci
interpretes as a write to MSI-X table because it falls in the 64k region
that was registered for emulation. The IRQ ID is not a valid SPI number and
gicv2m_update_routing() returns an error (and sets errno to EINVAL).

Fix this by aligning the table and PBA size to 8 bytes to allow for
qword accesses, like PCI 3.0 mandates.

For the sake of simplicity, the PBA offset in a BAR, in case of a shared
BAR, is kept the same as the offset of the physical device. One hopes that
the device respects the recommendations set forth in PCI LOCAL BUS
SPECIFICATION, REV. 3.0, section "MSI-X Capability and Table Structures"

Signed-off-by: Alexandru Elisei <alexandru.elisei@arm.com>
---
 include/kvm/vfio.h |  1 +
 vfio/pci.c         | 65 ++++++++++++++++++++++++++++------------------
 2 files changed, 41 insertions(+), 25 deletions(-)

diff --git a/include/kvm/vfio.h b/include/kvm/vfio.h
index 8cdf04f..764ab9b 100644
--- a/include/kvm/vfio.h
+++ b/include/kvm/vfio.h
@@ -50,6 +50,7 @@ struct vfio_pci_msix_pba {
 	size_t				size;
 	off_t				fd_offset; /* in VFIO device fd */
 	unsigned int			bar;
+	u32				bar_offset; /* in the shared BAR */
 	u32				guest_phys_addr;
 };
 
diff --git a/vfio/pci.c b/vfio/pci.c
index cc18311..7781868 100644
--- a/vfio/pci.c
+++ b/vfio/pci.c
@@ -502,7 +502,7 @@ static int vfio_pci_bar_activate(struct kvm *kvm,
 
 	if (has_msix && (u32)bar_num == pba->bar) {
 		if (pba->bar == table->bar)
-			pba->guest_phys_addr = table->guest_phys_addr + table->size;
+			pba->guest_phys_addr = table->guest_phys_addr + pba->bar_offset;
 		else
 			pba->guest_phys_addr = region->guest_phys_addr;
 		ret = kvm__register_mmio(kvm, pba->guest_phys_addr,
@@ -815,15 +815,21 @@ static int vfio_pci_fixup_cfg_space(struct vfio_device *vdev)
 	if (msix) {
 		/* Add a shortcut to the PBA region for the MMIO handler */
 		int pba_index = VFIO_PCI_BAR0_REGION_INDEX + pdev->msix_pba.bar;
+		u32 pba_bar_offset = msix->pba_offset & PCI_MSIX_PBA_OFFSET;
+
 		pdev->msix_pba.fd_offset = vdev->regions[pba_index].info.offset +
-					   (msix->pba_offset & PCI_MSIX_PBA_OFFSET);
+					   pba_bar_offset;
 
 		/* Tidy up the capability */
 		msix->table_offset &= PCI_MSIX_TABLE_BIR;
-		msix->pba_offset &= PCI_MSIX_PBA_BIR;
-		if (pdev->msix_table.bar == pdev->msix_pba.bar)
-			msix->pba_offset |= pdev->msix_table.size &
-					    PCI_MSIX_PBA_OFFSET;
+		if (pdev->msix_table.bar == pdev->msix_pba.bar) {
+			/* Keep the same offset as the MSIX cap. */
+			pdev->msix_pba.bar_offset = pba_bar_offset;
+		} else {
+			/* PBA is at the start of the BAR. */
+			msix->pba_offset &= PCI_MSIX_PBA_BIR;
+			pdev->msix_pba.bar_offset = 0;
+		}
 	}
 
 	/* Install our fake Configuration Space */
@@ -896,8 +902,10 @@ static int vfio_pci_create_msix_table(struct kvm *kvm, struct vfio_device *vdev)
 	 * KVM needs memory regions to be multiple of and aligned on PAGE_SIZE.
 	 */
 	nr_entries = (msix->ctrl & PCI_MSIX_FLAGS_QSIZE) + 1;
-	table->size = ALIGN(nr_entries * PCI_MSIX_ENTRY_SIZE, PAGE_SIZE);
-	pba->size = ALIGN(DIV_ROUND_UP(nr_entries, 64), PAGE_SIZE);
+
+	/* MSIX table and PBA must support QWORD accesses. */
+	table->size = ALIGN(nr_entries * PCI_MSIX_ENTRY_SIZE, 8);
+	pba->size = ALIGN(DIV_ROUND_UP(nr_entries, 64), 8);
 
 	entries = calloc(nr_entries, sizeof(struct vfio_pci_msi_entry));
 	if (!entries)
@@ -911,23 +919,8 @@ static int vfio_pci_create_msix_table(struct kvm *kvm, struct vfio_device *vdev)
 		return ret;
 	if (!info.size)
 		return -EINVAL;
-	map_size = info.size;
-
-	if (table->bar != pba->bar) {
-		ret = vfio_pci_get_region_info(vdev, pba->bar, &info);
-		if (ret)
-			return ret;
-		if (!info.size)
-			return -EINVAL;
-		map_size += info.size;
-	}
 
-	/*
-	 * To ease MSI-X cap configuration in case they share the same BAR,
-	 * collapse table and pending array. The size of the BAR regions must be
-	 * powers of two.
-	 */
-	map_size = ALIGN(map_size, PAGE_SIZE);
+	map_size = ALIGN(info.size, PAGE_SIZE);
 	table->guest_phys_addr = pci_get_mmio_block(map_size);
 	if (!table->guest_phys_addr) {
 		pr_err("cannot allocate MMIO space");
@@ -943,7 +936,29 @@ static int vfio_pci_create_msix_table(struct kvm *kvm, struct vfio_device *vdev)
 	 * between MSI-X table and PBA. For the sake of isolation, create a
 	 * virtual PBA.
 	 */
-	pba->guest_phys_addr = table->guest_phys_addr + table->size;
+	if (table->bar == pba->bar) {
+		u32 pba_bar_offset = msix->pba_offset & PCI_MSIX_PBA_OFFSET;
+		/* Sanity checks. */
+		if (table->size > pba_bar_offset)
+			die("MSIX table overlaps with PBA");
+		if (pba_bar_offset + pba->size > info.size)
+			die("PBA exceeds the size of the region");
+		pba->guest_phys_addr = table->guest_phys_addr + pba_bar_offset;
+	} else {
+		ret = vfio_pci_get_region_info(vdev, pba->bar, &info);
+		if (ret)
+			return ret;
+		if (!info.size)
+			return -EINVAL;
+
+		map_size = ALIGN(info.size, PAGE_SIZE);
+		pba->guest_phys_addr = pci_get_mmio_block(map_size);
+		if (!pba->guest_phys_addr) {
+			pr_err("cannot allocate MMIO space");
+			ret = -ENOMEM;
+			goto out_free;
+		}
+	}
 
 	pdev->msix.entries = entries;
 	pdev->msix.nr_entries = nr_entries;
-- 
2.20.1

