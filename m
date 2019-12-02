Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6E22010F357
	for <lists+kvm@lfdr.de>; Tue,  3 Dec 2019 00:23:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727133AbfLBXWz (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 2 Dec 2019 18:22:55 -0500
Received: from mga17.intel.com ([192.55.52.151]:51294 "EHLO mga17.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727047AbfLBXWx (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 2 Dec 2019 18:22:53 -0500
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmsmga107.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 02 Dec 2019 15:22:52 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.69,270,1571727600"; 
   d="scan'208";a="204753844"
Received: from jacob-builder.jf.intel.com (HELO jacob-builder) ([10.7.199.155])
  by orsmga008.jf.intel.com with ESMTP; 02 Dec 2019 15:22:49 -0800
Date:   Mon, 2 Dec 2019 15:27:32 -0800
From:   Jacob Pan <jacob.jun.pan@linux.intel.com>
To:     Lu Baolu <baolu.lu@linux.intel.com>
Cc:     Joerg Roedel <joro@8bytes.org>,
        David Woodhouse <dwmw2@infradead.org>,
        Alex Williamson <alex.williamson@redhat.com>,
        ashok.raj@intel.com, sanjay.k.kumar@intel.com,
        kevin.tian@intel.com, yi.l.liu@intel.com, yi.y.sun@intel.com,
        Peter Xu <peterx@redhat.com>, iommu@lists.linux-foundation.org,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Yi Sun <yi.y.sun@linux.intel.com>,
        jacob.jun.pan@linux.intel.com
Subject: Re: [PATCH v2 5/8] iommu/vt-d: Add first level page table
 interfaces
Message-ID: <20191202152732.3d9c6589@jacob-builder>
In-Reply-To: <20191128022550.9832-6-baolu.lu@linux.intel.com>
References: <20191128022550.9832-1-baolu.lu@linux.intel.com>
        <20191128022550.9832-6-baolu.lu@linux.intel.com>
Organization: OTC
X-Mailer: Claws Mail 3.13.2 (GTK+ 2.24.30; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, 28 Nov 2019 10:25:47 +0800
Lu Baolu <baolu.lu@linux.intel.com> wrote:

> This adds functions to manipulate first level page tables
> which could be used by a scalale mode capable IOMMU unit.
> 
FL and SL page tables are very similar, and I presume we are not using
all the flag bits in FL paging structures for DMA mapping. Are there
enough relevant differences to warrant a new set of helper functions
for FL? Or we can merge into one.

> Cc: Ashok Raj <ashok.raj@intel.com>
> Cc: Jacob Pan <jacob.jun.pan@linux.intel.com>
> Cc: Kevin Tian <kevin.tian@intel.com>
> Cc: Liu Yi L <yi.l.liu@intel.com>
> Cc: Yi Sun <yi.y.sun@linux.intel.com>
> Signed-off-by: Lu Baolu <baolu.lu@linux.intel.com>
> ---
>  drivers/iommu/Makefile             |   2 +-
>  drivers/iommu/intel-iommu.c        |  33 +++
>  drivers/iommu/intel-pgtable.c      | 376
> +++++++++++++++++++++++++++++ include/linux/intel-iommu.h        |
> 33 ++- include/trace/events/intel_iommu.h |  60 +++++
>  5 files changed, 502 insertions(+), 2 deletions(-)
>  create mode 100644 drivers/iommu/intel-pgtable.c
> 
> diff --git a/drivers/iommu/Makefile b/drivers/iommu/Makefile
> index 35d17094fe3b..aa04f4c3ae26 100644
> --- a/drivers/iommu/Makefile
> +++ b/drivers/iommu/Makefile
> @@ -18,7 +18,7 @@ obj-$(CONFIG_ARM_SMMU) += arm-smmu.o arm-smmu-impl.o
>  obj-$(CONFIG_ARM_SMMU_V3) += arm-smmu-v3.o
>  obj-$(CONFIG_DMAR_TABLE) += dmar.o
>  obj-$(CONFIG_INTEL_IOMMU) += intel-iommu.o intel-pasid.o
> -obj-$(CONFIG_INTEL_IOMMU) += intel-trace.o
> +obj-$(CONFIG_INTEL_IOMMU) += intel-trace.o intel-pgtable.o
>  obj-$(CONFIG_INTEL_IOMMU_DEBUGFS) += intel-iommu-debugfs.o
>  obj-$(CONFIG_INTEL_IOMMU_SVM) += intel-svm.o
>  obj-$(CONFIG_IPMMU_VMSA) += ipmmu-vmsa.o
> diff --git a/drivers/iommu/intel-iommu.c b/drivers/iommu/intel-iommu.c
> index 66f76f6df2c2..a314892ee72b 100644
> --- a/drivers/iommu/intel-iommu.c
> +++ b/drivers/iommu/intel-iommu.c
> @@ -1670,6 +1670,37 @@ static void free_dmar_iommu(struct intel_iommu
> *iommu) #endif
>  }
>  
> +/* First level 5-level paging support */
> +static bool first_lvl_5lp_support(void)
> +{
> +	struct dmar_drhd_unit *drhd;
> +	struct intel_iommu *iommu;
> +	static int first_level_5lp_supported = -1;
> +
> +	if (likely(first_level_5lp_supported != -1))
> +		return first_level_5lp_supported;
> +
> +	first_level_5lp_supported = 1;
> +#ifdef CONFIG_X86
> +	/* Match IOMMU first level and CPU paging mode */
> +	if (!cpu_feature_enabled(X86_FEATURE_LA57)) {
> +		first_level_5lp_supported = 0;
> +		return first_level_5lp_supported;
> +	}
> +#endif /* #ifdef CONFIG_X86 */
> +
> +	rcu_read_lock();
> +	for_each_active_iommu(iommu, drhd) {
> +		if (!cap_5lp_support(iommu->cap)) {
> +			first_level_5lp_supported = 0;
> +			break;
> +		}
> +	}
> +	rcu_read_unlock();
> +
> +	return first_level_5lp_supported;
> +}
> +
>  static struct dmar_domain *alloc_domain(int flags)
>  {
>  	struct dmar_domain *domain;
> @@ -1683,6 +1714,8 @@ static struct dmar_domain *alloc_domain(int
> flags) domain->flags = flags;
>  	domain->has_iotlb_device = false;
>  	domain->ops = &second_lvl_pgtable_ops;
> +	domain->first_lvl_5lp = first_lvl_5lp_support();
> +	spin_lock_init(&domain->page_table_lock);
>  	INIT_LIST_HEAD(&domain->devices);
>  
>  	return domain;
> diff --git a/drivers/iommu/intel-pgtable.c
> b/drivers/iommu/intel-pgtable.c new file mode 100644
> index 000000000000..4a26d08a7570
> --- /dev/null
> +++ b/drivers/iommu/intel-pgtable.c
> @@ -0,0 +1,376 @@
> +// SPDX-License-Identifier: GPL-2.0
> +/**
> + * intel-pgtable.c - Intel IOMMU page table manipulation library
> + *
> + * Copyright (C) 2019 Intel Corporation
> + *
> + * Author: Lu Baolu <baolu.lu@linux.intel.com>
> + */
> +
> +#define pr_fmt(fmt)     "DMAR: " fmt
> +#include <linux/vmalloc.h>
> +#include <linux/mm.h>
> +#include <linux/sched.h>
> +#include <linux/io.h>
> +#include <linux/export.h>
> +#include <linux/intel-iommu.h>
> +#include <asm/cacheflush.h>
> +#include <asm/pgtable.h>
> +#include <asm/pgalloc.h>
> +#include <trace/events/intel_iommu.h>
> +
> +/*
> + * first_lvl_map: Map a range of IO virtual address to physical
> addresses.
> + */
> +#ifdef CONFIG_X86
> +#define pgtable_populate(domain,
> nm)					\ +do
> {
> \
> +	void *__new =
> alloc_pgtable_page(domain->nid);			\
> +	if
> (!__new)							\
> +		return
> -ENOMEM;						\
> +
> smp_wmb();							\
> +
> spin_lock(&(domain)->page_table_lock);
> \
> +	if (nm ## _present(*nm))
> {					\
> +
> free_pgtable_page(__new);				\
> +	} else
> {							\
> +		set_##nm(nm, __##nm(__pa(__new) |
> _PAGE_TABLE));	\
> +		domain_flush_cache(domain, nm,
> sizeof(nm##_t));		\
> +	}
> \
> +
> spin_unlock(&(domain)->page_table_lock);			\ +}
> while (0) +
> +static int
> +first_lvl_map_pte_range(struct dmar_domain *domain, pmd_t *pmd,
> +			unsigned long addr, unsigned long end,
> +			phys_addr_t phys_addr, pgprot_t prot)
> +{
> +	pte_t *pte, *first_pte;
> +	u64 pfn;
> +
> +	pfn = phys_addr >> PAGE_SHIFT;
> +	if (unlikely(pmd_none(*pmd)))
> +		pgtable_populate(domain, pmd);
> +
> +	first_pte = pte = pte_offset_kernel(pmd, addr);
> +
> +	do {
> +		if (pte_present(*pte))
> +			pr_crit("ERROR: PTE for vPFN 0x%llx already
> set to 0x%llx\n",
> +				pfn, (unsigned long
> long)pte_val(*pte));
> +		set_pte(pte, pfn_pte(pfn, prot));
> +		pfn++;
> +	} while (pte++, addr += PAGE_SIZE, addr != end);
> +
> +	domain_flush_cache(domain, first_pte, (void *)pte - (void
> *)first_pte); +
> +	return 0;
> +}
> +
> +static int
> +first_lvl_map_pmd_range(struct dmar_domain *domain, pud_t *pud,
> +			unsigned long addr, unsigned long end,
> +			phys_addr_t phys_addr, pgprot_t prot)
> +{
> +	unsigned long next;
> +	pmd_t *pmd;
> +
> +	if (unlikely(pud_none(*pud)))
> +		pgtable_populate(domain, pud);
> +	pmd = pmd_offset(pud, addr);
> +
> +	phys_addr -= addr;
> +	do {
> +		next = pmd_addr_end(addr, end);
> +		if (first_lvl_map_pte_range(domain, pmd, addr, next,
> +					    phys_addr + addr, prot))
> +			return -ENOMEM;
> +	} while (pmd++, addr = next, addr != end);
> +
> +	return 0;
> +}
> +
> +static int
> +first_lvl_map_pud_range(struct dmar_domain *domain, p4d_t *p4d,
> +			unsigned long addr, unsigned long end,
> +			phys_addr_t phys_addr, pgprot_t prot)
> +{
> +	unsigned long next;
> +	pud_t *pud;
> +
> +	if (unlikely(p4d_none(*p4d)))
> +		pgtable_populate(domain, p4d);
> +
> +	pud = pud_offset(p4d, addr);
> +
> +	phys_addr -= addr;
> +	do {
> +		next = pud_addr_end(addr, end);
> +		if (first_lvl_map_pmd_range(domain, pud, addr, next,
> +					    phys_addr + addr, prot))
> +			return -ENOMEM;
> +	} while (pud++, addr = next, addr != end);
> +
> +	return 0;
> +}
> +
> +static int
> +first_lvl_map_p4d_range(struct dmar_domain *domain, pgd_t *pgd,
> +			unsigned long addr, unsigned long end,
> +			phys_addr_t phys_addr, pgprot_t prot)
> +{
> +	unsigned long next;
> +	p4d_t *p4d;
> +
> +	if (domain->first_lvl_5lp && unlikely(pgd_none(*pgd)))
> +		pgtable_populate(domain, pgd);
> +
> +	p4d = p4d_offset(pgd, addr);
> +
> +	phys_addr -= addr;
> +	do {
> +		next = p4d_addr_end(addr, end);
> +		if (first_lvl_map_pud_range(domain, p4d, addr, next,
> +					    phys_addr + addr, prot))
> +			return -ENOMEM;
> +	} while (p4d++, addr = next, addr != end);
> +
> +	return 0;
> +}
> +
> +int first_lvl_map_range(struct dmar_domain *domain, unsigned long
> addr,
> +			unsigned long end, phys_addr_t phys_addr,
> int dma_prot) +{
> +	unsigned long next;
> +	pgprot_t prot;
> +	pgd_t *pgd;
> +
> +	trace_domain_mm_map(domain, addr, end, phys_addr);
> +
> +	/*
> +	 * There is no PAGE_KERNEL_WO for a pte entry, so let's use
> RW
> +	 * for a pte that requires write operation.
> +	 */
> +	prot = dma_prot & DMA_PTE_WRITE ? PAGE_KERNEL :
> PAGE_KERNEL_RO;
> +	if (WARN_ON(addr >= end))
> +		return -EINVAL;
> +
> +	phys_addr -= addr;
> +	pgd = pgd_offset_pgd(domain->pgd, addr);
> +	do {
> +		next = pgd_addr_end(addr, end);
> +		if (first_lvl_map_p4d_range(domain, pgd, addr, next,
> +					    phys_addr + addr, prot))
> +			return -ENOMEM;
> +	} while (pgd++, addr = next, addr != end);
> +
> +	return 0;
> +}
> +
> +/*
> + * first_lvl_unmap: Unmap an existing mapping between a range of IO
> virtual
> + *		    address and physical addresses.
> + */
> +static struct page *
> +first_lvl_unmap_pte_range(struct dmar_domain *domain, pmd_t *pmd,
> +			  unsigned long addr, unsigned long end,
> +			  struct page *freelist)
> +{
> +	unsigned long start;
> +	pte_t *pte, *first_pte;
> +
> +	start = addr;
> +	pte = pte_offset_kernel(pmd, addr);
> +	first_pte = pte;
> +	do {
> +		set_pte(pte, __pte(0));
> +	} while (pte++, addr += PAGE_SIZE, addr != end);
> +
> +	domain_flush_cache(domain, first_pte, (void *)pte - (void
> *)first_pte); +
> +	/*
> +	 * Reclaim pmd page, lock is unnecessary here if it owns
> +	 * the whole range.
> +	 */
> +	if (start != end && IS_ALIGNED(start | end, PMD_SIZE)) {
> +		struct page *pte_page;
> +
> +		pte_page = pmd_page(*pmd);
> +		pte_page->freelist = freelist;
> +		freelist = pte_page;
> +		pmd_clear(pmd);
> +		domain_flush_cache(domain, pmd, sizeof(pmd_t));
> +	}
> +
> +	return freelist;
> +}
> +
> +static struct page *
> +first_lvl_unmap_pmd_range(struct dmar_domain *domain, pud_t *pud,
> +			  unsigned long addr, unsigned long end,
> +			  struct page *freelist)
> +{
> +	pmd_t *pmd;
> +	unsigned long start, next;
> +
> +	start = addr;
> +	pmd = pmd_offset(pud, addr);
> +	do {
> +		next = pmd_addr_end(addr, end);
> +		if (pmd_none_or_clear_bad(pmd))
> +			continue;
> +		freelist = first_lvl_unmap_pte_range(domain, pmd,
> +						     addr, next,
> freelist);
> +	} while (pmd++, addr = next, addr != end);
> +
> +	/*
> +	 * Reclaim pud page, lock is unnecessary here if it owns
> +	 * the whole range.
> +	 */
> +	if (start != end && IS_ALIGNED(start | end, PUD_SIZE)) {
> +		struct page *pmd_page;
> +
> +		pmd_page = pud_page(*pud);
> +		pmd_page->freelist = freelist;
> +		freelist = pmd_page;
> +		pud_clear(pud);
> +		domain_flush_cache(domain, pud, sizeof(pud_t));
> +	}
> +
> +	return freelist;
> +}
> +
> +static struct page *
> +first_lvl_unmap_pud_range(struct dmar_domain *domain, p4d_t *p4d,
> +			  unsigned long addr, unsigned long end,
> +			  struct page *freelist)
> +{
> +	pud_t *pud;
> +	unsigned long start, next;
> +
> +	start = addr;
> +	pud = pud_offset(p4d, addr);
> +	do {
> +		next = pud_addr_end(addr, end);
> +		if (pud_none_or_clear_bad(pud))
> +			continue;
> +		freelist = first_lvl_unmap_pmd_range(domain, pud,
> +						     addr, next,
> freelist);
> +	} while (pud++, addr = next, addr != end);
> +
> +	/*
> +	 * Reclaim p4d page, lock is unnecessary here if it owns
> +	 * the whole range.
> +	 */
> +	if (start != end && IS_ALIGNED(start | end, P4D_SIZE)) {
> +		struct page *pud_page;
> +
> +		pud_page = p4d_page(*p4d);
> +		pud_page->freelist = freelist;
> +		freelist = pud_page;
> +		p4d_clear(p4d);
> +		domain_flush_cache(domain, p4d, sizeof(p4d_t));
> +	}
> +
> +	return freelist;
> +}
> +
> +static struct page *
> +first_lvl_unmap_p4d_range(struct dmar_domain *domain, pgd_t *pgd,
> +			  unsigned long addr, unsigned long end,
> +			  struct page *freelist)
> +{
> +	p4d_t *p4d;
> +	unsigned long start, next;
> +
> +	start = addr;
> +	p4d = p4d_offset(pgd, addr);
> +	do {
> +		next = p4d_addr_end(addr, end);
> +		if (p4d_none_or_clear_bad(p4d))
> +			continue;
> +		freelist = first_lvl_unmap_pud_range(domain, p4d,
> +						     addr, next,
> freelist);
> +	} while (p4d++, addr = next, addr != end);
> +
> +	/*
> +	 * Reclaim pgd page, lock is unnecessary here if it owns
> +	 * the whole range.
> +	 */
> +	if (domain->first_lvl_5lp && start != end &&
> +	    IS_ALIGNED(start | end, PGDIR_SIZE)) {
> +		struct page *p4d_page;
> +
> +		p4d_page = pgd_page(*pgd);
> +		p4d_page->freelist = freelist;
> +		freelist = p4d_page;
> +		pgd_clear(pgd);
> +		domain_flush_cache(domain, pgd, sizeof(pgd_t));
> +	}
> +
> +	return freelist;
> +}
> +
> +struct page *first_lvl_unmap_range(struct dmar_domain *domain,
> +				   unsigned long addr, unsigned long
> end) +{
> +	pgd_t *pgd;
> +	unsigned long next;
> +	struct page *freelist = NULL;
> +
> +	trace_domain_mm_unmap(domain, addr, end);
> +
> +	if (WARN_ON(addr >= end))
> +		return NULL;
> +
> +	pgd = pgd_offset_pgd(domain->pgd, addr);
> +	do {
> +		next = pgd_addr_end(addr, end);
> +		if (pgd_none_or_clear_bad(pgd))
> +			continue;
> +		freelist = first_lvl_unmap_p4d_range(domain, pgd,
> +						     addr, next,
> freelist);
> +	} while (pgd++, addr = next, addr != end);
> +
> +	return freelist;
> +}
> +
> +static pte_t *iova_to_pte(struct dmar_domain *domain, unsigned long
> iova) +{
> +	pgd_t *pgd;
> +	p4d_t *p4d;
> +	pud_t *pud;
> +	pmd_t *pmd;
> +
> +	if (WARN_ON_ONCE(!IS_ALIGNED(iova, PAGE_SIZE)))
> +		return NULL;
> +
> +	pgd = pgd_offset_pgd(domain->pgd, iova);
> +	if (pgd_none_or_clear_bad(pgd))
> +		return NULL;
> +
> +	p4d = p4d_offset(pgd, iova);
> +	if (p4d_none_or_clear_bad(p4d))
> +		return NULL;
> +
> +	pud = pud_offset(p4d, iova);
> +	if (pud_none_or_clear_bad(pud))
> +		return NULL;
> +
> +	pmd = pmd_offset(pud, iova);
> +	if (pmd_none_or_clear_bad(pmd))
> +		return NULL;
> +
> +	return pte_offset_kernel(pmd, iova);
> +}
> +
> +phys_addr_t
> +first_lvl_iova_to_phys(struct dmar_domain *domain, unsigned long
> iova) +{
> +	pte_t *pte = iova_to_pte(domain, PAGE_ALIGN(iova));
> +
> +	if (!pte || !pte_present(*pte))
> +		return 0;
> +
> +	return (pte_val(*pte) & PTE_PFN_MASK) | (iova & ~PAGE_MASK);
> +}
> +#endif /* CONFIG_X86 */
> diff --git a/include/linux/intel-iommu.h b/include/linux/intel-iommu.h
> index 9b259756057b..9273e3f59078 100644
> --- a/include/linux/intel-iommu.h
> +++ b/include/linux/intel-iommu.h
> @@ -540,9 +540,11 @@ struct dmar_domain {
>  	struct iova_domain iovad;	/* iova's that belong to
> this domain */ 
>  	/* page table used by this domain */
> -	struct dma_pte	*pgd;		/* virtual
> address */
> +	void		*pgd;		/* virtual address
> */
> +	spinlock_t page_table_lock;	/* Protects page tables */
>  	int		gaw;		/* max guest address
> width */ const struct pgtable_ops *ops;	/* page table ops */
> +	bool		first_lvl_5lp;	/* First level
> 5-level paging support */ 
>  	/* adjusted guest address width, 0 is level 2 30-bit */
>  	int		agaw;
> @@ -708,6 +710,35 @@ int for_each_device_domain(int (*fn)(struct
> device_domain_info *info, void iommu_flush_write_buffer(struct
> intel_iommu *iommu); int intel_iommu_enable_pasid(struct intel_iommu
> *iommu, struct device *dev); 
> +#ifdef CONFIG_X86
> +int first_lvl_map_range(struct dmar_domain *domain, unsigned long
> addr,
> +			unsigned long end, phys_addr_t phys_addr,
> int dma_prot); +struct page *first_lvl_unmap_range(struct dmar_domain
> *domain,
> +				   unsigned long addr, unsigned long
> end); +phys_addr_t first_lvl_iova_to_phys(struct dmar_domain *domain,
> +				   unsigned long iova);
> +#else
> +static inline int
> +first_lvl_map_range(struct dmar_domain *domain, unsigned long addr,
> +		    unsigned long end, phys_addr_t phys_addr, int
> dma_prot) +{
> +	return -ENODEV;
> +}
> +
> +static inline struct page *
> +first_lvl_unmap_range(struct dmar_domain *domain,
> +		      unsigned long addr, unsigned long end)
> +{
> +	return NULL;
> +}
> +
> +static inline phys_addr_t
> +first_lvl_iova_to_phys(struct dmar_domain *domain, unsigned long
> iova) +{
> +	return 0;
> +}
> +#endif /* CONFIG_X86 */
> +
>  #ifdef CONFIG_INTEL_IOMMU_SVM
>  extern void intel_svm_check(struct intel_iommu *iommu);
>  extern int intel_svm_enable_prq(struct intel_iommu *iommu);
> diff --git a/include/trace/events/intel_iommu.h
> b/include/trace/events/intel_iommu.h index 54e61d456cdf..e8c95290fd13
> 100644 --- a/include/trace/events/intel_iommu.h
> +++ b/include/trace/events/intel_iommu.h
> @@ -99,6 +99,66 @@ DEFINE_EVENT(dma_unmap, bounce_unmap_single,
>  	TP_ARGS(dev, dev_addr, size)
>  );
>  
> +DECLARE_EVENT_CLASS(domain_map,
> +	TP_PROTO(struct dmar_domain *domain, unsigned long addr,
> +		 unsigned long end, phys_addr_t phys_addr),
> +
> +	TP_ARGS(domain, addr, end, phys_addr),
> +
> +	TP_STRUCT__entry(
> +		__field(struct dmar_domain *, domain)
> +		__field(unsigned long, addr)
> +		__field(unsigned long, end)
> +		__field(phys_addr_t, phys_addr)
> +	),
> +
> +	TP_fast_assign(
> +		__entry->domain = domain;
> +		__entry->addr = addr;
> +		__entry->end = end;
> +		__entry->phys_addr = phys_addr;
> +	),
> +
> +	TP_printk("domain=%p addr=0x%lx end=0x%lx phys_addr=0x%llx",
> +		  __entry->domain, __entry->addr, __entry->end,
> +		  (unsigned long long)__entry->phys_addr)
> +);
> +
> +DEFINE_EVENT(domain_map, domain_mm_map,
> +	TP_PROTO(struct dmar_domain *domain, unsigned long addr,
> +		 unsigned long end, phys_addr_t phys_addr),
> +
> +	TP_ARGS(domain, addr, end, phys_addr)
> +);
> +
> +DECLARE_EVENT_CLASS(domain_unmap,
> +	TP_PROTO(struct dmar_domain *domain, unsigned long addr,
> +		 unsigned long end),
> +
> +	TP_ARGS(domain, addr, end),
> +
> +	TP_STRUCT__entry(
> +		__field(struct dmar_domain *, domain)
> +		__field(unsigned long, addr)
> +		__field(unsigned long, end)
> +	),
> +
> +	TP_fast_assign(
> +		__entry->domain = domain;
> +		__entry->addr = addr;
> +		__entry->end = end;
> +	),
> +
> +	TP_printk("domain=%p addr=0x%lx end=0x%lx",
> +		  __entry->domain, __entry->addr, __entry->end)
> +);
> +
> +DEFINE_EVENT(domain_unmap, domain_mm_unmap,
> +	TP_PROTO(struct dmar_domain *domain, unsigned long addr,
> +		 unsigned long end),
> +
> +	TP_ARGS(domain, addr, end)
> +);
>  #endif /* _TRACE_INTEL_IOMMU_H */
>  
>  /* This part must be outside protection */

[Jacob Pan]
