Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id ACF6A9C917
	for <lists+kvm@lfdr.de>; Mon, 26 Aug 2019 08:17:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729518AbfHZGRU (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 26 Aug 2019 02:17:20 -0400
Received: from ozlabs.ru ([107.173.13.209]:55936 "EHLO ozlabs.ru"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725385AbfHZGRT (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 26 Aug 2019 02:17:19 -0400
Received: from fstn1-p1.ozlabs.ibm.com (localhost [IPv6:::1])
        by ozlabs.ru (Postfix) with ESMTP id 9A820AE801D4;
        Mon, 26 Aug 2019 02:16:56 -0400 (EDT)
From:   Alexey Kardashevskiy <aik@ozlabs.ru>
To:     linuxppc-dev@lists.ozlabs.org
Cc:     David Gibson <david@gibson.dropbear.id.au>,
        kvm-ppc@vger.kernel.org, kvm@vger.kernel.org,
        Alistair Popple <alistair@popple.id.au>,
        Alex Williamson <alex.williamson@redhat.com>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Paul Mackerras <paulus@ozlabs.org>,
        Alexey Kardashevskiy <aik@ozlabs.ru>
Subject: [PATCH kernel v2 1/4] powerpc/powernv/ioda: Split out TCE invalidation from TCE updates
Date:   Mon, 26 Aug 2019 16:17:02 +1000
Message-Id: <20190826061705.92048-2-aik@ozlabs.ru>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20190826061705.92048-1-aik@ozlabs.ru>
References: <20190826061705.92048-1-aik@ozlabs.ru>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

At the moment updates in a TCE table are made by iommu_table_ops::exchange
which update one TCE and invalidates an entry in the PHB/NPU TCE cache
via set of registers called "TCE Kill" (hence the naming).
Writing a TCE is a simple xchg() but invalidating the TCE cache is
a relatively expensive OPAL call. Mapping a 100GB guest with PCI+NPU
passed through devices takes about 20s.

Thankfully we can do better. Since such big mappings happen at the boot
time and when memory is plugged/onlined (i.e. not often), these requests
come in 512 pages so we call call OPAL 512 times less which brings 20s
from the above to less than 10s. Also, since TCE caches can be flushed
entirely, calling OPAL for 512 TCEs helps skiboot [1] to decide whether
to flush the entire cache or not.

This implements 2 new iommu_table_ops callbacks:
- xchg_no_kill() to update a single TCE with no TCE invalidation;
- tce_kill() to invalidate multiple TCEs.
This uses the same xchg_no_kill() callback for IODA1/2.

This implements 2 new wrappers on top of the new callbacks similar to
the existing iommu_tce_xchg().

This does not use the new callbacks yet, the next patches will;
so this should not cause any behavioral change.

Signed-off-by: Alexey Kardashevskiy <aik@ozlabs.ru>
---
 arch/powerpc/include/asm/iommu.h          | 17 ++++++++++++++
 arch/powerpc/kernel/iommu.c               | 27 +++++++++++++++++++++++
 arch/powerpc/platforms/powernv/pci-ioda.c | 12 ++++++++++
 3 files changed, 56 insertions(+)

diff --git a/arch/powerpc/include/asm/iommu.h b/arch/powerpc/include/asm/iommu.h
index d7bf1f104c15..837b5122f257 100644
--- a/arch/powerpc/include/asm/iommu.h
+++ b/arch/powerpc/include/asm/iommu.h
@@ -58,6 +58,17 @@ struct iommu_table_ops {
 			unsigned long *hpa,
 			enum dma_data_direction *direction);
 
+	int (*xchg_no_kill)(struct iommu_table *tbl,
+			long index,
+			unsigned long *hpa,
+			enum dma_data_direction *direction,
+			bool realmode);
+
+	void (*tce_kill)(struct iommu_table *tbl,
+			unsigned long index,
+			unsigned long pages,
+			bool realmode);
+
 	__be64 *(*useraddrptr)(struct iommu_table *tbl, long index, bool alloc);
 #endif
 	void (*clear)(struct iommu_table *tbl,
@@ -209,6 +220,12 @@ extern void iommu_del_device(struct device *dev);
 extern long iommu_tce_xchg(struct mm_struct *mm, struct iommu_table *tbl,
 		unsigned long entry, unsigned long *hpa,
 		enum dma_data_direction *direction);
+extern long iommu_tce_xchg_no_kill(struct mm_struct *mm,
+		struct iommu_table *tbl,
+		unsigned long entry, unsigned long *hpa,
+		enum dma_data_direction *direction);
+extern void iommu_tce_kill(struct iommu_table *tbl,
+		unsigned long entry, unsigned long pages);
 #else
 static inline void iommu_register_group(struct iommu_table_group *table_group,
 					int pci_domain_number,
diff --git a/arch/powerpc/kernel/iommu.c b/arch/powerpc/kernel/iommu.c
index e7a2b160d4c6..070492f9b46e 100644
--- a/arch/powerpc/kernel/iommu.c
+++ b/arch/powerpc/kernel/iommu.c
@@ -1037,6 +1037,33 @@ long iommu_tce_xchg(struct mm_struct *mm, struct iommu_table *tbl,
 }
 EXPORT_SYMBOL_GPL(iommu_tce_xchg);
 
+extern long iommu_tce_xchg_no_kill(struct mm_struct *mm,
+		struct iommu_table *tbl,
+		unsigned long entry, unsigned long *hpa,
+		enum dma_data_direction *direction)
+{
+	long ret;
+	unsigned long size = 0;
+
+	ret = tbl->it_ops->xchg_no_kill(tbl, entry, hpa, direction, false);
+	if (!ret && ((*direction == DMA_FROM_DEVICE) ||
+			(*direction == DMA_BIDIRECTIONAL)) &&
+			!mm_iommu_is_devmem(mm, *hpa, tbl->it_page_shift,
+					&size))
+		SetPageDirty(pfn_to_page(*hpa >> PAGE_SHIFT));
+
+	return ret;
+}
+EXPORT_SYMBOL_GPL(iommu_tce_xchg_no_kill);
+
+void iommu_tce_kill(struct iommu_table *tbl,
+		unsigned long entry, unsigned long pages)
+{
+	if (tbl->it_ops->tce_kill)
+		tbl->it_ops->tce_kill(tbl, entry, pages, false);
+}
+EXPORT_SYMBOL_GPL(iommu_tce_kill);
+
 int iommu_take_ownership(struct iommu_table *tbl)
 {
 	unsigned long flags, i, sz = (tbl->it_size + 7) >> 3;
diff --git a/arch/powerpc/platforms/powernv/pci-ioda.c b/arch/powerpc/platforms/powernv/pci-ioda.c
index ec48ea25a674..4e56b2c620ec 100644
--- a/arch/powerpc/platforms/powernv/pci-ioda.c
+++ b/arch/powerpc/platforms/powernv/pci-ioda.c
@@ -1939,6 +1939,14 @@ static int pnv_ioda1_tce_build(struct iommu_table *tbl, long index,
 }
 
 #ifdef CONFIG_IOMMU_API
+/* Common for IODA1 and IODA2 */
+static int pnv_ioda_tce_xchg_no_kill(struct iommu_table *tbl, long index,
+		unsigned long *hpa, enum dma_data_direction *direction,
+		bool realmode)
+{
+	return pnv_tce_xchg(tbl, index, hpa, direction, !realmode);
+}
+
 static int pnv_ioda1_tce_xchg(struct iommu_table *tbl, long index,
 		unsigned long *hpa, enum dma_data_direction *direction)
 {
@@ -1975,6 +1983,8 @@ static struct iommu_table_ops pnv_ioda1_iommu_ops = {
 #ifdef CONFIG_IOMMU_API
 	.exchange = pnv_ioda1_tce_xchg,
 	.exchange_rm = pnv_ioda1_tce_xchg_rm,
+	.xchg_no_kill = pnv_ioda_tce_xchg_no_kill,
+	.tce_kill = pnv_pci_p7ioc_tce_invalidate,
 	.useraddrptr = pnv_tce_useraddrptr,
 #endif
 	.clear = pnv_ioda1_tce_free,
@@ -2140,6 +2150,8 @@ static struct iommu_table_ops pnv_ioda2_iommu_ops = {
 #ifdef CONFIG_IOMMU_API
 	.exchange = pnv_ioda2_tce_xchg,
 	.exchange_rm = pnv_ioda2_tce_xchg_rm,
+	.xchg_no_kill = pnv_ioda_tce_xchg_no_kill,
+	.tce_kill = pnv_pci_ioda2_tce_invalidate,
 	.useraddrptr = pnv_tce_useraddrptr,
 #endif
 	.clear = pnv_ioda2_tce_free,
-- 
2.17.1

