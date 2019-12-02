Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5491310E597
	for <lists+kvm@lfdr.de>; Mon,  2 Dec 2019 06:51:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726210AbfLBFvq (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 2 Dec 2019 00:51:46 -0500
Received: from 107-174-27-60-host.colocrossing.com ([107.174.27.60]:51846 "EHLO
        ozlabs.ru" rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
        id S1725807AbfLBFvp (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 2 Dec 2019 00:51:45 -0500
Received: from fstn1-p1.ozlabs.ibm.com (localhost [IPv6:::1])
        by ozlabs.ru (Postfix) with ESMTP id CBF4DAE800ED;
        Mon,  2 Dec 2019 00:50:39 -0500 (EST)
From:   Alexey Kardashevskiy <aik@ozlabs.ru>
To:     linuxppc-dev@lists.ozlabs.org
Cc:     Alexey Kardashevskiy <aik@ozlabs.ru>,
        David Gibson <david@gibson.dropbear.id.au>,
        kvm@vger.kernel.org, Alistair Popple <alistair@popple.id.au>,
        "Oliver O'Halloran" <oohall@gmail.com>,
        Alex Williamson <alex.williamson@redhat.com>
Subject: [PATCH kernel RFC 00/4] powerpc/powernv/ioda: Move TCE bypass base to PE
Date:   Mon,  2 Dec 2019 16:51:39 +1100
Message-Id: <20191202055139.9364-1-aik@ozlabs.ru>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20191202015953.127902-1-aik@ozlabs.ru>
References: <20191202015953.127902-1-aik@ozlabs.ru>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

We are about to allow another location for the second DMA window and
we will need to advertise it outside of the powernv platform code.

This moves bypass base address to iommu_table_group so drivers such as
VFIO SPAPR TCE can see it.

Signed-off-by: Alexey Kardashevskiy <aik@ozlabs.ru>
---
 arch/powerpc/include/asm/iommu.h          |  1 +
 arch/powerpc/platforms/powernv/pci.h      |  1 -
 arch/powerpc/platforms/powernv/npu-dma.c  |  1 +
 arch/powerpc/platforms/powernv/pci-ioda.c | 18 +++++++++---------
 4 files changed, 11 insertions(+), 10 deletions(-)

diff --git a/arch/powerpc/include/asm/iommu.h b/arch/powerpc/include/asm/iommu.h
index 350101e11ddb..479439ef003e 100644
--- a/arch/powerpc/include/asm/iommu.h
+++ b/arch/powerpc/include/asm/iommu.h
@@ -194,6 +194,7 @@ struct iommu_table_group {
 	__u64 pgsizes; /* Bitmap of supported page sizes */
 	__u32 max_dynamic_windows_supported;
 	__u32 max_levels;
+	__u64 tce64_start;
 
 	struct iommu_group *group;
 	struct iommu_table *tables[IOMMU_TABLE_GROUP_MAX_TABLES];
diff --git a/arch/powerpc/platforms/powernv/pci.h b/arch/powerpc/platforms/powernv/pci.h
index f914f0b14e4e..faf9d7e95a85 100644
--- a/arch/powerpc/platforms/powernv/pci.h
+++ b/arch/powerpc/platforms/powernv/pci.h
@@ -67,7 +67,6 @@ struct pnv_ioda_pe {
 
 	/* 64-bit TCE bypass region */
 	bool			tce_bypass_enabled;
-	uint64_t		tce_bypass_base;
 
 	/* MSIs. MVE index is identical for for 32 and 64 bit MSI
 	 * and -1 if not supported. (It's actually identical to the
diff --git a/arch/powerpc/platforms/powernv/npu-dma.c b/arch/powerpc/platforms/powernv/npu-dma.c
index b95b9e3c4c98..97a479848003 100644
--- a/arch/powerpc/platforms/powernv/npu-dma.c
+++ b/arch/powerpc/platforms/powernv/npu-dma.c
@@ -469,6 +469,7 @@ struct iommu_table_group *pnv_try_setup_npu_table_group(struct pnv_ioda_pe *pe)
 	table_group->tce32_start = pe->table_group.tce32_start;
 	table_group->tce32_size = pe->table_group.tce32_size;
 	table_group->max_levels = pe->table_group.max_levels;
+	table_group->tce64_start = pe->table_group.tce64_start;
 	if (!table_group->pgsizes)
 		table_group->pgsizes = pe->table_group.pgsizes;
 
diff --git a/arch/powerpc/platforms/powernv/pci-ioda.c b/arch/powerpc/platforms/powernv/pci-ioda.c
index c28d0d9b7ee0..9e55bd9d7ecd 100644
--- a/arch/powerpc/platforms/powernv/pci-ioda.c
+++ b/arch/powerpc/platforms/powernv/pci-ioda.c
@@ -1747,7 +1747,7 @@ static void pnv_pci_ioda_dma_dev_setup(struct pnv_phb *phb, struct pci_dev *pdev
 
 	pe = &phb->ioda.pe_array[pdn->pe_number];
 	WARN_ON(get_dma_ops(&pdev->dev) != &dma_iommu_ops);
-	pdev->dev.archdata.dma_offset = pe->tce_bypass_base;
+	pdev->dev.archdata.dma_offset = pe->table_group.tce64_start;
 	set_iommu_table_base(&pdev->dev, pe->table_group.tables[0]);
 	/*
 	 * Note: iommu_add_device() will fail here as
@@ -1839,7 +1839,8 @@ static bool pnv_pci_ioda_iommu_bypass_supported(struct pci_dev *pdev,
 
 	pe = &phb->ioda.pe_array[pdn->pe_number];
 	if (pe->tce_bypass_enabled) {
-		u64 top = pe->tce_bypass_base + memblock_end_of_DRAM() - 1;
+		u64 top = pe->table_group.tce64_start +
+			memblock_end_of_DRAM() - 1;
 		if (dma_mask >= top)
 			return true;
 	}
@@ -1873,7 +1874,7 @@ static void pnv_ioda_setup_bus_dma(struct pnv_ioda_pe *pe, struct pci_bus *bus)
 
 	list_for_each_entry(dev, &bus->devices, bus_list) {
 		set_iommu_table_base(&dev->dev, pe->table_group.tables[0]);
-		dev->dev.archdata.dma_offset = pe->tce_bypass_base;
+		dev->dev.archdata.dma_offset = pe->table_group.tce64_start;
 
 		if ((pe->flags & PNV_IODA_PE_BUS_ALL) && dev->subordinate)
 			pnv_ioda_setup_bus_dma(pe, dev->subordinate);
@@ -2333,13 +2334,13 @@ static void pnv_pci_ioda2_set_bypass(struct pnv_ioda_pe *pe, bool enable)
 		rc = opal_pci_map_pe_dma_window_real(pe->phb->opal_id,
 						     pe->pe_number,
 						     window_id,
-						     pe->tce_bypass_base,
+						     pe->table_group.tce64_start,
 						     top);
 	} else {
 		rc = opal_pci_map_pe_dma_window_real(pe->phb->opal_id,
 						     pe->pe_number,
 						     window_id,
-						     pe->tce_bypass_base,
+						     pe->table_group.tce64_start,
 						     0);
 	}
 	if (rc)
@@ -2355,7 +2356,8 @@ static long pnv_pci_ioda2_create_table(struct iommu_table_group *table_group,
 	struct pnv_ioda_pe *pe = container_of(table_group, struct pnv_ioda_pe,
 			table_group);
 	int nid = pe->phb->hose->node;
-	__u64 bus_offset = num ? pe->tce_bypass_base : table_group->tce32_start;
+	__u64 bus_offset = num ?
+		pe->table_group.tce64_start : table_group->tce32_start;
 	long ret;
 	struct iommu_table *tbl;
 
@@ -2705,9 +2707,6 @@ static void pnv_pci_ioda2_setup_dma_pe(struct pnv_phb *phb,
 	if (!pnv_pci_ioda_pe_dma_weight(pe))
 		return;
 
-	/* TVE #1 is selected by PCI address bit 59 */
-	pe->tce_bypass_base = 1ull << 59;
-
 	/* The PE will reserve all possible 32-bits space */
 	pe_info(pe, "Setting up 32-bit TCE table at 0..%08x\n",
 		phb->ioda.m32_pci_base);
@@ -2715,6 +2714,7 @@ static void pnv_pci_ioda2_setup_dma_pe(struct pnv_phb *phb,
 	/* Setup linux iommu table */
 	pe->table_group.tce32_start = 0;
 	pe->table_group.tce32_size = phb->ioda.m32_pci_base;
+	pe->table_group.tce64_start = 1UL << 59;
 	pe->table_group.max_dynamic_windows_supported =
 			IOMMU_TABLE_GROUP_MAX_TABLES;
 	pe->table_group.max_levels = POWERNV_IOMMU_MAX_LEVELS;
-- 
2.17.1

