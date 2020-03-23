Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 22CFF18F08D
	for <lists+kvm@lfdr.de>; Mon, 23 Mar 2020 09:01:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727539AbgCWIBJ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 23 Mar 2020 04:01:09 -0400
Received: from 107-174-27-60-host.colocrossing.com ([107.174.27.60]:50662 "EHLO
        ozlabs.ru" rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
        id S1727524AbgCWIBD (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 23 Mar 2020 04:01:03 -0400
Received: from fstn1-p1.ozlabs.ibm.com (localhost [IPv6:::1])
        by ozlabs.ru (Postfix) with ESMTP id 0AE43AE80564;
        Mon, 23 Mar 2020 03:52:20 -0400 (EDT)
From:   Alexey Kardashevskiy <aik@ozlabs.ru>
To:     linuxppc-dev@lists.ozlabs.org
Cc:     David Gibson <david@gibson.dropbear.id.au>,
        kvm-ppc@vger.kernel.org, kvm@vger.kernel.org,
        Alistair Popple <alistair@popple.id.au>,
        Fabiano Rosas <farosas@linux.ibm.com>,
        Alexey Kardashevskiy <aik@ozlabs.ru>
Subject: [PATCH kernel v2 2/7] powerpc/powernv/ioda: Rework for huge DMA window at 4GB
Date:   Mon, 23 Mar 2020 18:53:49 +1100
Message-Id: <20200323075354.93825-3-aik@ozlabs.ru>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200323075354.93825-1-aik@ozlabs.ru>
References: <20200323075354.93825-1-aik@ozlabs.ru>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This moves code to make the next patches look simpler. In particular:

1. Separate locals declaration as we will be allocating a smaller DMA
window if a TVE1_4GB option (allows a huge DMA windows at 4GB) is enabled;

2. Pass the bypass offset directly to pnv_pci_ioda2_create_table()
as it is the only information needed from @pe;

3. Use PAGE_SHIFT for it_map allocation estimate and @tceshift for
the IOMMU page size; this makes the distinction clear and allows
easy switching between different IOMMU page size.

These changes should not cause behavioral change.

Signed-off-by: Alexey Kardashevskiy <aik@ozlabs.ru>
---

I really need 1), 2) makes the code less dependent on the PE struct member
value (==easier to follow), 3) is to enable 2MB quickly for the default
DMA window for debugging/performance testing.
---
 arch/powerpc/platforms/powernv/pci-ioda.c | 38 ++++++++++++-----------
 1 file changed, 20 insertions(+), 18 deletions(-)

diff --git a/arch/powerpc/platforms/powernv/pci-ioda.c b/arch/powerpc/platforms/powernv/pci-ioda.c
index 52db10ab4fef..f5f1b4e25530 100644
--- a/arch/powerpc/platforms/powernv/pci-ioda.c
+++ b/arch/powerpc/platforms/powernv/pci-ioda.c
@@ -2375,15 +2375,10 @@ static void pnv_pci_ioda2_set_bypass(struct pnv_ioda_pe *pe, bool enable)
 		pe->tce_bypass_enabled = enable;
 }
 
-static long pnv_pci_ioda2_create_table(struct iommu_table_group *table_group,
-		int num, __u32 page_shift, __u64 window_size, __u32 levels,
+static long pnv_pci_ioda2_create_table(int nid, int num, __u64 bus_offset,
+		__u32 page_shift, __u64 window_size, __u32 levels,
 		bool alloc_userspace_copy, struct iommu_table **ptbl)
 {
-	struct pnv_ioda_pe *pe = container_of(table_group, struct pnv_ioda_pe,
-			table_group);
-	int nid = pe->phb->hose->node;
-	__u64 bus_offset = num ?
-		pe->table_group.tce64_start : table_group->tce32_start;
 	long ret;
 	struct iommu_table *tbl;
 
@@ -2410,21 +2405,23 @@ static long pnv_pci_ioda2_setup_default_config(struct pnv_ioda_pe *pe)
 {
 	struct iommu_table *tbl = NULL;
 	long rc;
-	unsigned long res_start, res_end;
+	u64 max_memory, maxblock, window_size;
+	const unsigned int tceshift = PAGE_SHIFT;
+	unsigned long res_start, res_end, tces_order, tcelevel_order, levels;
 
 	/*
 	 * crashkernel= specifies the kdump kernel's maximum memory at
 	 * some offset and there is no guaranteed the result is a power
 	 * of 2, which will cause errors later.
 	 */
-	const u64 max_memory = __rounddown_pow_of_two(memory_hotplug_max());
+	max_memory = __rounddown_pow_of_two(memory_hotplug_max());
 
 	/*
 	 * In memory constrained environments, e.g. kdump kernel, the
 	 * DMA window can be larger than available memory, which will
 	 * cause errors later.
 	 */
-	const u64 maxblock = 1UL << (PAGE_SHIFT + MAX_ORDER - 1);
+	maxblock = 1UL << (PAGE_SHIFT + MAX_ORDER - 1);
 
 	/*
 	 * We create the default window as big as we can. The constraint is
@@ -2434,11 +2431,11 @@ static long pnv_pci_ioda2_setup_default_config(struct pnv_ioda_pe *pe)
 	 * to support crippled devices (i.e. not fully 64bit DMAble) only.
 	 */
 	/* iommu_table::it_map uses 1 bit per IOMMU page, hence 8 */
-	const u64 window_size = min((maxblock * 8) << PAGE_SHIFT, max_memory);
+	window_size = min((maxblock * 8) << tceshift, max_memory);
 	/* Each TCE level cannot exceed maxblock so go multilevel if needed */
-	unsigned long tces_order = ilog2(window_size >> PAGE_SHIFT);
-	unsigned long tcelevel_order = ilog2(maxblock >> 3);
-	unsigned int levels = tces_order / tcelevel_order;
+	tces_order = ilog2(window_size >> tceshift);
+	tcelevel_order = ilog2(maxblock >> 3);
+	levels = tces_order / tcelevel_order;
 
 	if (tces_order % tcelevel_order)
 		levels += 1;
@@ -2448,8 +2445,8 @@ static long pnv_pci_ioda2_setup_default_config(struct pnv_ioda_pe *pe)
 	 */
 	levels = max_t(unsigned int, levels, POWERNV_IOMMU_DEFAULT_LEVELS);
 
-	rc = pnv_pci_ioda2_create_table(&pe->table_group, 0, PAGE_SHIFT,
-			window_size, levels, false, &tbl);
+	rc = pnv_pci_ioda2_create_table(pe->phb->hose->node,
+			0, 0, tceshift, window_size, levels, false, &tbl);
 	if (rc) {
 		pe_err(pe, "Failed to create 32-bit TCE table, err %ld",
 				rc);
@@ -2551,8 +2548,13 @@ static long pnv_pci_ioda2_create_table_userspace(
 		int num, __u32 page_shift, __u64 window_size, __u32 levels,
 		struct iommu_table **ptbl)
 {
-	long ret = pnv_pci_ioda2_create_table(table_group,
-			num, page_shift, window_size, levels, true, ptbl);
+	struct pnv_ioda_pe *pe = container_of(table_group, struct pnv_ioda_pe,
+			table_group);
+	__u64 bus_offset = num ?
+		pe->table_group.tce64_start : table_group->tce32_start;
+	long ret = pnv_pci_ioda2_create_table(pe->phb->hose->node,
+			num, bus_offset, page_shift, window_size, levels, true,
+			ptbl);
 
 	if (!ret)
 		(*ptbl)->it_allocated_size = pnv_pci_ioda2_get_table_size(
-- 
2.17.1

