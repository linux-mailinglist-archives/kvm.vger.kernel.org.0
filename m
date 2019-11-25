Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0B480108BC8
	for <lists+kvm@lfdr.de>; Mon, 25 Nov 2019 11:32:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727603AbfKYKcs (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 25 Nov 2019 05:32:48 -0500
Received: from foss.arm.com ([217.140.110.172]:47796 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727553AbfKYKcp (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 25 Nov 2019 05:32:45 -0500
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id D8950328;
        Mon, 25 Nov 2019 02:32:44 -0800 (PST)
Received: from e123195-lin.cambridge.arm.com (e123195-lin.cambridge.arm.com [10.1.196.63])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id F25543F52E;
        Mon, 25 Nov 2019 02:32:43 -0800 (PST)
From:   Alexandru Elisei <alexandru.elisei@arm.com>
To:     kvm@vger.kernel.org
Cc:     will@kernel.org, julien.thierry.kdev@gmail.com,
        andre.przywara@arm.com, sami.mujawar@arm.com,
        lorenzo.pieralisi@arm.com
Subject: [PATCH kvmtool 13/16] vfio: Add support for BAR configuration
Date:   Mon, 25 Nov 2019 10:30:30 +0000
Message-Id: <20191125103033.22694-14-alexandru.elisei@arm.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191125103033.22694-1-alexandru.elisei@arm.com>
References: <20191125103033.22694-1-alexandru.elisei@arm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Julien Thierry <julien.thierry@arm.com>

When a guest can reassign BARs, kvmtool needs to maintain the vfio_region
consistent with their corresponding BARs. Take the new updated addresses
from the PCI header read back from the vfio driver.

Also, to modify the BARs, it is expected that guests will disable
IO/Memory response in the PCI command. Support this by mapping/unmapping
regions when the corresponding response gets enabled/disabled.

Cc: julien.thierry.kdev@gmail.com
Signed-off-by: Julien Thierry <julien.thierry@arm.com>
[Fixed BAR selection]
Signed-off-by: Alexandru Elisei <alexandru.elisei@arm.com>
---
 vfio/core.c |  8 ++---
 vfio/pci.c  | 88 ++++++++++++++++++++++++++++++++++++++++++++++++++---
 2 files changed, 87 insertions(+), 9 deletions(-)

diff --git a/vfio/core.c b/vfio/core.c
index 0ed1e6fee6bf..b554897fc8c1 100644
--- a/vfio/core.c
+++ b/vfio/core.c
@@ -202,14 +202,13 @@ static int vfio_setup_trap_region(struct kvm *kvm, struct vfio_device *vdev,
 				  struct vfio_region *region)
 {
 	if (region->is_ioport) {
-		int port = pci_get_io_port_block(region->info.size);
+		int port = ioport__register(kvm, region->port_base,
+					    &vfio_ioport_ops,
+					    region->info.size, region);
 
-		port = ioport__register(kvm, port, &vfio_ioport_ops,
-					region->info.size, region);
 		if (port < 0)
 			return port;
 
-		region->port_base = port;
 		return 0;
 	}
 
@@ -258,6 +257,7 @@ void vfio_unmap_region(struct kvm *kvm, struct vfio_region *region)
 {
 	if (region->host_addr) {
 		munmap(region->host_addr, region->info.size);
+		region->host_addr = NULL;
 	} else if (region->is_ioport) {
 		ioport__unregister(kvm, region->port_base);
 	} else {
diff --git a/vfio/pci.c b/vfio/pci.c
index bc5a6d452f7a..28f895c06b27 100644
--- a/vfio/pci.c
+++ b/vfio/pci.c
@@ -1,3 +1,4 @@
+#include "kvm/ioport.h"
 #include "kvm/irq.h"
 #include "kvm/kvm.h"
 #include "kvm/kvm-cpu.h"
@@ -464,6 +465,67 @@ static void vfio_pci_cfg_read(struct kvm *kvm, struct pci_device_header *pci_hdr
 			      sz, offset);
 }
 
+static void vfio_pci_cfg_handle_command(struct kvm *kvm, struct vfio_device *vdev,
+					void *data, int sz)
+{
+	struct pci_device_header *hdr = &vdev->pci.hdr;
+	bool toggle_io;
+	bool toggle_mem;
+	u16 cmd;
+	int i;
+
+	cmd = ioport__read16(data);
+	toggle_io = !!((cmd ^ hdr->command) & PCI_COMMAND_IO);
+	toggle_mem = !!((cmd ^ hdr->command) & PCI_COMMAND_MEMORY);
+
+	for (i = VFIO_PCI_BAR0_REGION_INDEX; i <= VFIO_PCI_BAR5_REGION_INDEX; ++i) {
+		struct vfio_region *region = &vdev->regions[i];
+
+		if (region->is_ioport && toggle_io) {
+			if (cmd & PCI_COMMAND_IO)
+				vfio_map_region(kvm, vdev, region);
+			else
+				vfio_unmap_region(kvm, region);
+		}
+
+		if (!region->is_ioport && toggle_mem) {
+			if (cmd & PCI_COMMAND_MEMORY)
+				vfio_map_region(kvm, vdev, region);
+			else
+				vfio_unmap_region(kvm, region);
+		}
+	}
+}
+
+static void vfio_pci_cfg_update_bar(struct kvm *kvm, struct vfio_device *vdev,
+				    int bar_num, void *data, int sz)
+{
+	struct pci_device_header *hdr = &vdev->pci.hdr;
+	struct vfio_region *region;
+	uint32_t bar;
+
+	region = &vdev->regions[bar_num + VFIO_PCI_BAR0_REGION_INDEX];
+	bar = ioport__read32(data);
+
+	if (region->is_ioport) {
+		if (hdr->command & PCI_COMMAND_IO)
+			vfio_unmap_region(kvm, region);
+
+		region->port_base = bar & PCI_BASE_ADDRESS_IO_MASK;
+
+		if (hdr->command & PCI_COMMAND_IO)
+			vfio_map_region(kvm, vdev, region);
+	} else {
+		if (hdr->command & PCI_COMMAND_MEMORY)
+			vfio_unmap_region(kvm, region);
+
+		region->guest_phys_addr = bar & PCI_BASE_ADDRESS_MEM_MASK;
+
+		if (hdr->command & PCI_COMMAND_MEMORY)
+			vfio_map_region(kvm, vdev, region);
+	}
+}
+
 static void vfio_pci_cfg_write(struct kvm *kvm, struct pci_device_header *pci_hdr,
 			       u8 offset, void *data, int sz)
 {
@@ -471,6 +533,7 @@ static void vfio_pci_cfg_write(struct kvm *kvm, struct pci_device_header *pci_hd
 	struct vfio_pci_device *pdev;
 	struct vfio_device *vdev;
 	void *base = pci_hdr;
+	int bar_num;
 
 	pdev = container_of(pci_hdr, struct vfio_pci_device, hdr);
 	vdev = container_of(pdev, struct vfio_device, pci);
@@ -487,9 +550,17 @@ static void vfio_pci_cfg_write(struct kvm *kvm, struct pci_device_header *pci_hd
 	if (pdev->irq_modes & VFIO_PCI_IRQ_MODE_MSI)
 		vfio_pci_msi_cap_write(kvm, vdev, offset, data, sz);
 
+	if (offset == PCI_COMMAND)
+		vfio_pci_cfg_handle_command(kvm, vdev, data, sz);
+
 	if (pread(vdev->fd, base + offset, sz, info->offset + offset) != sz)
 		vfio_dev_warn(vdev, "Failed to read %d bytes from Configuration Space at 0x%x",
 			      sz, offset);
+
+	if (offset >= PCI_BASE_ADDRESS_0 && offset <= PCI_BASE_ADDRESS_5) {
+		bar_num = (offset - PCI_BASE_ADDRESS_0) / sizeof(u32);
+		vfio_pci_cfg_update_bar(kvm, vdev, bar_num, data, sz);
+	}
 }
 
 static ssize_t vfio_pci_msi_cap_size(struct msi_cap_64 *cap_hdr)
@@ -808,6 +879,7 @@ static int vfio_pci_configure_bar(struct kvm *kvm, struct vfio_device *vdev,
 	size_t map_size;
 	struct vfio_pci_device *pdev = &vdev->pci;
 	struct vfio_region *region = &vdev->regions[nr];
+	bool map_now;
 
 	if (nr >= vdev->info.num_regions)
 		return 0;
@@ -848,16 +920,22 @@ static int vfio_pci_configure_bar(struct kvm *kvm, struct vfio_device *vdev,
 		}
 	}
 
-	if (!region->is_ioport) {
+	if (region->is_ioport) {
+		region->port_base = pci_get_io_port_block(region->info.size);
+		map_now = !!(pdev->hdr.command & PCI_COMMAND_IO);
+	} else {
 		/* Grab some MMIO space in the guest */
 		map_size = ALIGN(region->info.size, PAGE_SIZE);
 		region->guest_phys_addr = pci_get_mmio_block(map_size);
+		map_now = !!(pdev->hdr.command & PCI_COMMAND_MEMORY);
 	}
 
-	/* Map the BARs into the guest or setup a trap region. */
-	ret = vfio_map_region(kvm, vdev, region);
-	if (ret)
-		return ret;
+	if (map_now) {
+		/* Map the BARs into the guest or setup a trap region. */
+		ret = vfio_map_region(kvm, vdev, region);
+		if (ret)
+			return ret;
+	}
 
 	return 0;
 }
-- 
2.20.1

