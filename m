Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 391DCBB3B2
	for <lists+kvm@lfdr.de>; Mon, 23 Sep 2019 14:27:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732394AbfIWM10 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 23 Sep 2019 08:27:26 -0400
Received: from mga06.intel.com ([134.134.136.31]:4334 "EHLO mga06.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730399AbfIWM1Y (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 23 Sep 2019 08:27:24 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by orsmga104.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 23 Sep 2019 05:27:23 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.64,539,1559545200"; 
   d="scan'208";a="203116669"
Received: from allen-box.sh.intel.com ([10.239.159.136])
  by fmsmga001.fm.intel.com with ESMTP; 23 Sep 2019 05:27:21 -0700
From:   Lu Baolu <baolu.lu@linux.intel.com>
To:     Joerg Roedel <joro@8bytes.org>,
        David Woodhouse <dwmw2@infradead.org>,
        Alex Williamson <alex.williamson@redhat.com>
Cc:     ashok.raj@intel.com, sanjay.k.kumar@intel.com,
        jacob.jun.pan@linux.intel.com, kevin.tian@intel.com,
        yi.l.liu@intel.com, yi.y.sun@intel.com,
        iommu@lists.linux-foundation.org, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Lu Baolu <baolu.lu@linux.intel.com>,
        Yi Sun <yi.y.sun@linux.intel.com>
Subject: [RFC PATCH 2/4] iommu/vt-d: Add first level page table interfaces
Date:   Mon, 23 Sep 2019 20:24:52 +0800
Message-Id: <20190923122454.9888-3-baolu.lu@linux.intel.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20190923122454.9888-1-baolu.lu@linux.intel.com>
References: <20190923122454.9888-1-baolu.lu@linux.intel.com>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This adds functions to manipulate first level page tables
which could be used by a scalale mode capable IOMMU unit.

intel_mmmap_range(domain, addr, end, phys_addr, prot)
 - Map an iova range of [addr, end) to the physical memory
   started at @phys_addr with the @prot permissions.

intel_mmunmap_range(domain, addr, end)
 - Tear down the map of an iova range [addr, end). A page
   list will be returned which will be freed after iotlb
   flushing.

Cc: Ashok Raj <ashok.raj@intel.com>
Cc: Jacob Pan <jacob.jun.pan@linux.intel.com>
Cc: Kevin Tian <kevin.tian@intel.com>
Cc: Liu Yi L <yi.l.liu@intel.com>
Cc: Yi Sun <yi.y.sun@linux.intel.com>
Signed-off-by: Lu Baolu <baolu.lu@linux.intel.com>
---
 drivers/iommu/Makefile             |   2 +-
 drivers/iommu/intel-pgtable.c      | 342 +++++++++++++++++++++++++++++
 include/linux/intel-iommu.h        |  24 +-
 include/trace/events/intel_iommu.h |  60 +++++
 4 files changed, 426 insertions(+), 2 deletions(-)
 create mode 100644 drivers/iommu/intel-pgtable.c

diff --git a/drivers/iommu/Makefile b/drivers/iommu/Makefile
index 4f405f926e73..dc550e14cc58 100644
--- a/drivers/iommu/Makefile
+++ b/drivers/iommu/Makefile
@@ -17,7 +17,7 @@ obj-$(CONFIG_ARM_SMMU) += arm-smmu.o arm-smmu-impl.o
 obj-$(CONFIG_ARM_SMMU_V3) += arm-smmu-v3.o
 obj-$(CONFIG_DMAR_TABLE) += dmar.o
 obj-$(CONFIG_INTEL_IOMMU) += intel-iommu.o intel-pasid.o
-obj-$(CONFIG_INTEL_IOMMU) += intel-trace.o
+obj-$(CONFIG_INTEL_IOMMU) += intel-trace.o intel-pgtable.o
 obj-$(CONFIG_INTEL_IOMMU_DEBUGFS) += intel-iommu-debugfs.o
 obj-$(CONFIG_INTEL_IOMMU_SVM) += intel-svm.o
 obj-$(CONFIG_IPMMU_VMSA) += ipmmu-vmsa.o
diff --git a/drivers/iommu/intel-pgtable.c b/drivers/iommu/intel-pgtable.c
new file mode 100644
index 000000000000..8e95978cd381
--- /dev/null
+++ b/drivers/iommu/intel-pgtable.c
@@ -0,0 +1,342 @@
+// SPDX-License-Identifier: GPL-2.0
+/**
+ * intel-pgtable.c - Intel IOMMU page table manipulation library
+ *
+ * Copyright (C) 2019 Intel Corporation
+ *
+ * Author: Lu Baolu <baolu.lu@linux.intel.com>
+ */
+
+#define pr_fmt(fmt)     "DMAR: " fmt
+#include <linux/vmalloc.h>
+#include <linux/mm.h>
+#include <linux/sched.h>
+#include <linux/io.h>
+#include <linux/export.h>
+#include <linux/intel-iommu.h>
+#include <asm/cacheflush.h>
+#include <asm/pgtable.h>
+#include <asm/pgalloc.h>
+#include <trace/events/intel_iommu.h>
+
+#ifdef CONFIG_X86
+/*
+ * mmmap: Map a range of IO virtual address to physical addresses.
+ */
+#define pgtable_populate(domain, nm)					\
+do {									\
+	void *__new = alloc_pgtable_page(domain->nid);			\
+	if (!__new)							\
+		return -ENOMEM;						\
+	smp_wmb();							\
+	spin_lock(&(domain)->page_table_lock);				\
+	if (nm ## _present(*nm)) {					\
+		free_pgtable_page(__new);				\
+	} else {							\
+		set_##nm(nm, __##nm(__pa(__new) | _PAGE_TABLE));	\
+		domain_flush_cache(domain, nm, sizeof(nm##_t));		\
+	}								\
+	spin_unlock(&(domain)->page_table_lock);			\
+} while(0);
+
+static int
+mmmap_pte_range(struct dmar_domain *domain, pmd_t *pmd, unsigned long addr,
+		unsigned long end, phys_addr_t phys_addr, pgprot_t prot)
+{
+	pte_t *pte, *first_pte;
+	u64 pfn;
+
+	pfn = phys_addr >> PAGE_SHIFT;
+	if (unlikely(pmd_none(*pmd)))
+		pgtable_populate(domain, pmd);
+
+	first_pte = pte = pte_offset_kernel(pmd, addr);
+
+	do {
+		set_pte(pte, pfn_pte(pfn, prot));
+		pfn++;
+	} while (pte++, addr += PAGE_SIZE, addr != end);
+
+	domain_flush_cache(domain, first_pte, (void *)pte - (void *)first_pte);
+
+	return 0;
+}
+
+static int
+mmmap_pmd_range(struct dmar_domain *domain, pud_t *pud, unsigned long addr,
+		unsigned long end, phys_addr_t phys_addr, pgprot_t prot)
+{
+	unsigned long next;
+	pmd_t *pmd;
+
+	if (unlikely(pud_none(*pud)))
+		pgtable_populate(domain, pud);
+	pmd = pmd_offset(pud, addr);
+
+	phys_addr -= addr;
+	do {
+		next = pmd_addr_end(addr, end);
+		if (mmmap_pte_range(domain, pmd, addr, next,
+				    phys_addr + addr, prot))
+			return -ENOMEM;
+	} while (pmd++, addr = next, addr != end);
+
+	return 0;
+}
+
+static int
+mmmap_pud_range(struct dmar_domain *domain, p4d_t *p4d, unsigned long addr,
+		unsigned long end, phys_addr_t phys_addr, pgprot_t prot)
+{
+	unsigned long next;
+	pud_t *pud;
+
+	if (unlikely(p4d_none(*p4d)))
+		pgtable_populate(domain, p4d);
+
+	pud = pud_offset(p4d, addr);
+
+	phys_addr -= addr;
+	do {
+		next = pud_addr_end(addr, end);
+		if (mmmap_pmd_range(domain, pud, addr, next,
+				    phys_addr + addr, prot))
+			return -ENOMEM;
+	} while (pud++, addr = next, addr != end);
+
+	return 0;
+}
+
+static int
+mmmap_p4d_range(struct dmar_domain *domain, pgd_t *pgd, unsigned long addr,
+		unsigned long end, phys_addr_t phys_addr, pgprot_t prot)
+{
+	unsigned long next;
+	p4d_t *p4d;
+
+	if (cpu_feature_enabled(X86_FEATURE_LA57) && unlikely(pgd_none(*pgd)))
+		pgtable_populate(domain, pgd);
+
+	p4d = p4d_offset(pgd, addr);
+
+	phys_addr -= addr;
+	do {
+		next = p4d_addr_end(addr, end);
+		if (mmmap_pud_range(domain, p4d, addr, next,
+				    phys_addr + addr, prot))
+			return -ENOMEM;
+	} while (p4d++, addr = next, addr != end);
+
+	return 0;
+}
+
+int intel_mmmap_range(struct dmar_domain *domain, unsigned long addr,
+		      unsigned long end, phys_addr_t phys_addr, int dma_prot)
+{
+	unsigned long next;
+	pgprot_t prot;
+	pgd_t *pgd;
+
+	trace_domain_mm_map(domain, addr, end, phys_addr);
+
+	/*
+	 * There is no PAGE_KERNEL_WO for a pte entry, so let's use RW
+	 * for a pte that requires write operation.
+	 */
+	prot = dma_prot & DMA_PTE_WRITE ? PAGE_KERNEL : PAGE_KERNEL_RO;
+	BUG_ON(addr >= end);
+
+	phys_addr -= addr;
+	pgd = pgd_offset_pgd(domain->pgd, addr);
+	do {
+		next = pgd_addr_end(addr, end);
+		if (mmmap_p4d_range(domain, pgd, addr, next,
+				    phys_addr + addr, prot))
+			return -ENOMEM;
+	} while (pgd++, addr = next, addr != end);
+
+	return 0;
+}
+
+/*
+ * mmunmap: Unmap an existing mapping between a range of IO vitual address
+ *          and physical addresses.
+ */
+static struct page *
+mmunmap_pte_range(struct dmar_domain *domain, pmd_t *pmd,
+		  unsigned long addr, unsigned long end,
+		  struct page *freelist, bool reclaim)
+{
+	int i;
+	unsigned long start;
+	pte_t *pte, *first_pte;
+
+	start = addr;
+	pte = pte_offset_kernel(pmd, addr);
+	first_pte = pte;
+	do {
+		set_pte(pte, __pte(0));
+	} while (pte++, addr += PAGE_SIZE, addr != end);
+
+	domain_flush_cache(domain, first_pte, (void *)pte - (void *)first_pte);
+
+	/* Add page to free list if all entries are empty. */
+	if (reclaim) {
+		struct page *pte_page;
+
+		pte = (pte_t *)pmd_page_vaddr(*pmd);
+		for (i = 0; i < PTRS_PER_PTE; i++)
+			if (!pte || !pte_none(pte[i]))
+				goto pte_out;
+
+		pte_page = pmd_page(*pmd);
+		pte_page->freelist = freelist;
+		freelist = pte_page;
+		pmd_clear(pmd);
+		domain_flush_cache(domain, pmd, sizeof(pmd_t));
+	}
+
+pte_out:
+	return freelist;
+}
+
+static struct page *
+mmunmap_pmd_range(struct dmar_domain *domain, pud_t *pud,
+		  unsigned long addr, unsigned long end,
+		  struct page *freelist, bool reclaim)
+{
+	int i;
+	pmd_t *pmd;
+	unsigned long start, next;
+
+	start = addr;
+	pmd = pmd_offset(pud, addr);
+	do {
+		next = pmd_addr_end(addr, end);
+		if (pmd_none_or_clear_bad(pmd))
+			continue;
+		freelist = mmunmap_pte_range(domain, pmd, addr, next,
+					     freelist, reclaim);
+	} while (pmd++, addr = next, addr != end);
+
+	/* Add page to free list if all entries are empty. */
+	if (reclaim) {
+		struct page *pmd_page;
+
+		pmd = (pmd_t *)pud_page_vaddr(*pud);
+		for (i = 0; i < PTRS_PER_PMD; i++)
+			if (!pmd || !pmd_none(pmd[i]))
+				goto pmd_out;
+
+		pmd_page = pud_page(*pud);
+		pmd_page->freelist = freelist;
+		freelist = pmd_page;
+		pud_clear(pud);
+		domain_flush_cache(domain, pud, sizeof(pud_t));
+	}
+
+pmd_out:
+	return freelist;
+}
+
+static struct page *
+mmunmap_pud_range(struct dmar_domain *domain, p4d_t *p4d,
+		  unsigned long addr, unsigned long end,
+		  struct page *freelist, bool reclaim)
+{
+	int i;
+	pud_t *pud;
+	unsigned long start, next;
+
+	start = addr;
+	pud = pud_offset(p4d, addr);
+	do {
+		next = pud_addr_end(addr, end);
+		if (pud_none_or_clear_bad(pud))
+			continue;
+		freelist = mmunmap_pmd_range(domain, pud, addr, next,
+					     freelist, reclaim);
+	} while (pud++, addr = next, addr != end);
+
+	/* Add page to free list if all entries are empty. */
+	if (reclaim) {
+		struct page *pud_page;
+
+		pud = (pud_t *)p4d_page_vaddr(*p4d);
+		for (i = 0; i < PTRS_PER_PUD; i++)
+			if (!pud || !pud_none(pud[i]))
+				goto pud_out;
+
+		pud_page = p4d_page(*p4d);
+		pud_page->freelist = freelist;
+		freelist = pud_page;
+		p4d_clear(p4d);
+		domain_flush_cache(domain, p4d, sizeof(p4d_t));
+	}
+
+pud_out:
+	return freelist;
+}
+
+static struct page *
+mmunmap_p4d_range(struct dmar_domain *domain, pgd_t *pgd,
+		  unsigned long addr, unsigned long end,
+		  struct page *freelist, bool reclaim)
+{
+	p4d_t *p4d;
+	unsigned long start, next;
+
+	start = addr;
+	p4d = p4d_offset(pgd, addr);
+	do {
+		next = p4d_addr_end(addr, end);
+		if (p4d_none_or_clear_bad(p4d))
+			continue;
+		freelist = mmunmap_pud_range(domain, p4d, addr, next,
+					     freelist, reclaim);
+	} while (p4d++, addr = next, addr != end);
+
+	/* Add page to free list if all entries are empty. */
+	if (cpu_feature_enabled(X86_FEATURE_LA57) && reclaim) {
+		struct page *p4d_page;
+		int i;
+
+		p4d = (p4d_t *)pgd_page_vaddr(*pgd);
+		for (i = 0; i < PTRS_PER_P4D; i++)
+			if (!p4d || !p4d_none(p4d[i]))
+				goto p4d_out;
+
+		p4d_page = pgd_page(*pgd);
+		p4d_page->freelist = freelist;
+		freelist = p4d_page;
+		pgd_clear(pgd);
+		domain_flush_cache(domain, pgd, sizeof(pgd_t));
+	}
+
+p4d_out:
+	return freelist;
+}
+
+struct page *
+intel_mmunmap_range(struct dmar_domain *domain,
+		    unsigned long addr, unsigned long end)
+{
+	pgd_t *pgd;
+	unsigned long next;
+	struct page *freelist = NULL;
+
+	trace_domain_mm_unmap(domain, addr, end);
+
+	BUG_ON(addr >= end);
+	pgd = pgd_offset_pgd(domain->pgd, addr);
+	do {
+		next = pgd_addr_end(addr, end);
+		if (pgd_none_or_clear_bad(pgd))
+			continue;
+		freelist = mmunmap_p4d_range(domain, pgd, addr, next,
+					     freelist, !addr);
+	} while (pgd++, addr = next, addr != end);
+
+	return freelist;
+}
+#endif /* CONFIG_X86 */
diff --git a/include/linux/intel-iommu.h b/include/linux/intel-iommu.h
index 3ee694d4f361..044a91fa5431 100644
--- a/include/linux/intel-iommu.h
+++ b/include/linux/intel-iommu.h
@@ -489,7 +489,8 @@ struct dmar_domain {
 	struct list_head auxd;		/* link to device's auxiliary list */
 	struct iova_domain iovad;	/* iova's that belong to this domain */
 
-	struct dma_pte	*pgd;		/* virtual address */
+	void		*pgd;		/* virtual address */
+	spinlock_t page_table_lock;	/* Protects page tables */
 	int		gaw;		/* max guest address width */
 
 	/* adjusted guest address width, 0 is level 2 30-bit */
@@ -662,6 +663,27 @@ int for_each_device_domain(int (*fn)(struct device_domain_info *info,
 void iommu_flush_write_buffer(struct intel_iommu *iommu);
 int intel_iommu_enable_pasid(struct intel_iommu *iommu, struct device *dev);
 
+#ifdef CONFIG_X86
+int intel_mmmap_range(struct dmar_domain *domain, unsigned long addr,
+		      unsigned long end, phys_addr_t phys_addr, int dma_prot);
+struct page *intel_mmunmap_range(struct dmar_domain *domain,
+				 unsigned long addr, unsigned long end);
+#else
+static inline int
+intel_mmmap_range(struct dmar_domain *domain, unsigned long addr,
+		  unsigned long end, phys_addr_t phys_addr, int dma_prot)
+{
+	return -ENODEV;
+}
+
+static inline struct page *
+intel_mmunmap_range(struct dmar_domain *domain,
+		    unsigned long addr, unsigned long end)
+{
+	return NULL;
+}
+#endif
+
 #ifdef CONFIG_INTEL_IOMMU_SVM
 int intel_svm_init(struct intel_iommu *iommu);
 extern int intel_svm_enable_prq(struct intel_iommu *iommu);
diff --git a/include/trace/events/intel_iommu.h b/include/trace/events/intel_iommu.h
index 54e61d456cdf..e8c95290fd13 100644
--- a/include/trace/events/intel_iommu.h
+++ b/include/trace/events/intel_iommu.h
@@ -99,6 +99,66 @@ DEFINE_EVENT(dma_unmap, bounce_unmap_single,
 	TP_ARGS(dev, dev_addr, size)
 );
 
+DECLARE_EVENT_CLASS(domain_map,
+	TP_PROTO(struct dmar_domain *domain, unsigned long addr,
+		 unsigned long end, phys_addr_t phys_addr),
+
+	TP_ARGS(domain, addr, end, phys_addr),
+
+	TP_STRUCT__entry(
+		__field(struct dmar_domain *, domain)
+		__field(unsigned long, addr)
+		__field(unsigned long, end)
+		__field(phys_addr_t, phys_addr)
+	),
+
+	TP_fast_assign(
+		__entry->domain = domain;
+		__entry->addr = addr;
+		__entry->end = end;
+		__entry->phys_addr = phys_addr;
+	),
+
+	TP_printk("domain=%p addr=0x%lx end=0x%lx phys_addr=0x%llx",
+		  __entry->domain, __entry->addr, __entry->end,
+		  (unsigned long long)__entry->phys_addr)
+);
+
+DEFINE_EVENT(domain_map, domain_mm_map,
+	TP_PROTO(struct dmar_domain *domain, unsigned long addr,
+		 unsigned long end, phys_addr_t phys_addr),
+
+	TP_ARGS(domain, addr, end, phys_addr)
+);
+
+DECLARE_EVENT_CLASS(domain_unmap,
+	TP_PROTO(struct dmar_domain *domain, unsigned long addr,
+		 unsigned long end),
+
+	TP_ARGS(domain, addr, end),
+
+	TP_STRUCT__entry(
+		__field(struct dmar_domain *, domain)
+		__field(unsigned long, addr)
+		__field(unsigned long, end)
+	),
+
+	TP_fast_assign(
+		__entry->domain = domain;
+		__entry->addr = addr;
+		__entry->end = end;
+	),
+
+	TP_printk("domain=%p addr=0x%lx end=0x%lx",
+		  __entry->domain, __entry->addr, __entry->end)
+);
+
+DEFINE_EVENT(domain_unmap, domain_mm_unmap,
+	TP_PROTO(struct dmar_domain *domain, unsigned long addr,
+		 unsigned long end),
+
+	TP_ARGS(domain, addr, end)
+);
 #endif /* _TRACE_INTEL_IOMMU_H */
 
 /* This part must be outside protection */
-- 
2.17.1

