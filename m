Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EF85ABEAB2
	for <lists+kvm@lfdr.de>; Thu, 26 Sep 2019 04:37:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391590AbfIZCh0 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 25 Sep 2019 22:37:26 -0400
Received: from mga03.intel.com ([134.134.136.65]:10016 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725768AbfIZCh0 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 25 Sep 2019 22:37:26 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by orsmga103.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 25 Sep 2019 19:37:25 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.64,550,1559545200"; 
   d="scan'208";a="201462986"
Received: from allen-box.sh.intel.com (HELO [10.239.159.136]) ([10.239.159.136])
  by orsmga002.jf.intel.com with ESMTP; 25 Sep 2019 19:37:22 -0700
Cc:     baolu.lu@linux.intel.com, Joerg Roedel <joro@8bytes.org>,
        David Woodhouse <dwmw2@infradead.org>,
        Alex Williamson <alex.williamson@redhat.com>,
        kevin.tian@intel.com, Yi Sun <yi.y.sun@linux.intel.com>,
        ashok.raj@intel.com, kvm@vger.kernel.org, sanjay.k.kumar@intel.com,
        iommu@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
        yi.y.sun@intel.com
Subject: Re: [RFC PATCH 2/4] iommu/vt-d: Add first level page table interfaces
To:     Peter Xu <peterx@redhat.com>
References: <20190923122454.9888-1-baolu.lu@linux.intel.com>
 <20190923122454.9888-3-baolu.lu@linux.intel.com>
 <20190925052157.GL28074@xz-x1>
From:   Lu Baolu <baolu.lu@linux.intel.com>
Message-ID: <c9792e0b-bf42-1dbb-f060-0b1a43125f47@linux.intel.com>
Date:   Thu, 26 Sep 2019 10:35:24 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20190925052157.GL28074@xz-x1>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Peter,

Thanks for reviewing my code.

On 9/25/19 1:21 PM, Peter Xu wrote:
> On Mon, Sep 23, 2019 at 08:24:52PM +0800, Lu Baolu wrote:
>> This adds functions to manipulate first level page tables
>> which could be used by a scalale mode capable IOMMU unit.
>>
>> intel_mmmap_range(domain, addr, end, phys_addr, prot)
>>   - Map an iova range of [addr, end) to the physical memory
>>     started at @phys_addr with the @prot permissions.
>>
>> intel_mmunmap_range(domain, addr, end)
>>   - Tear down the map of an iova range [addr, end). A page
>>     list will be returned which will be freed after iotlb
>>     flushing.
>>
>> Cc: Ashok Raj <ashok.raj@intel.com>
>> Cc: Jacob Pan <jacob.jun.pan@linux.intel.com>
>> Cc: Kevin Tian <kevin.tian@intel.com>
>> Cc: Liu Yi L <yi.l.liu@intel.com>
>> Cc: Yi Sun <yi.y.sun@linux.intel.com>
>> Signed-off-by: Lu Baolu <baolu.lu@linux.intel.com>
>> ---
>>   drivers/iommu/Makefile             |   2 +-
>>   drivers/iommu/intel-pgtable.c      | 342 +++++++++++++++++++++++++++++
>>   include/linux/intel-iommu.h        |  24 +-
>>   include/trace/events/intel_iommu.h |  60 +++++
>>   4 files changed, 426 insertions(+), 2 deletions(-)
>>   create mode 100644 drivers/iommu/intel-pgtable.c
>>
>> diff --git a/drivers/iommu/Makefile b/drivers/iommu/Makefile
>> index 4f405f926e73..dc550e14cc58 100644
>> --- a/drivers/iommu/Makefile
>> +++ b/drivers/iommu/Makefile
>> @@ -17,7 +17,7 @@ obj-$(CONFIG_ARM_SMMU) += arm-smmu.o arm-smmu-impl.o
>>   obj-$(CONFIG_ARM_SMMU_V3) += arm-smmu-v3.o
>>   obj-$(CONFIG_DMAR_TABLE) += dmar.o
>>   obj-$(CONFIG_INTEL_IOMMU) += intel-iommu.o intel-pasid.o
>> -obj-$(CONFIG_INTEL_IOMMU) += intel-trace.o
>> +obj-$(CONFIG_INTEL_IOMMU) += intel-trace.o intel-pgtable.o
>>   obj-$(CONFIG_INTEL_IOMMU_DEBUGFS) += intel-iommu-debugfs.o
>>   obj-$(CONFIG_INTEL_IOMMU_SVM) += intel-svm.o
>>   obj-$(CONFIG_IPMMU_VMSA) += ipmmu-vmsa.o
>> diff --git a/drivers/iommu/intel-pgtable.c b/drivers/iommu/intel-pgtable.c
>> new file mode 100644
>> index 000000000000..8e95978cd381
>> --- /dev/null
>> +++ b/drivers/iommu/intel-pgtable.c
>> @@ -0,0 +1,342 @@
>> +// SPDX-License-Identifier: GPL-2.0
>> +/**
>> + * intel-pgtable.c - Intel IOMMU page table manipulation library
> 
> Could this be a bit misleading?  Normally I'll use "IOMMU page table"
> to refer to the 2nd level page table only, and I'm always
> understanding it as "the new IOMMU will understand MMU page table as
> the 1st level".  At least mention "IOMMU 1st level page table"?
> 

This file is a place holder for all code that manipulating iommu page
tables (both first level and second level). Instead of putting
everything in intel_iommu.c, let's make the code more structured so that
it's easier for reading and maintaining. This is the motivation of this
file.

>> + *
>> + * Copyright (C) 2019 Intel Corporation
>> + *
>> + * Author: Lu Baolu <baolu.lu@linux.intel.com>
>> + */
>> +
>> +#define pr_fmt(fmt)     "DMAR: " fmt
>> +#include <linux/vmalloc.h>
>> +#include <linux/mm.h>
>> +#include <linux/sched.h>
>> +#include <linux/io.h>
>> +#include <linux/export.h>
>> +#include <linux/intel-iommu.h>
>> +#include <asm/cacheflush.h>
>> +#include <asm/pgtable.h>
>> +#include <asm/pgalloc.h>
>> +#include <trace/events/intel_iommu.h>
>> +
>> +#ifdef CONFIG_X86
>> +/*
>> + * mmmap: Map a range of IO virtual address to physical addresses.
> 
> "... to physical addresses using MMU page table"?
> 
> Might be clearer?

Yes.

> 
>> + */
>> +#define pgtable_populate(domain, nm)					\
>> +do {									\
>> +	void *__new = alloc_pgtable_page(domain->nid);			\
>> +	if (!__new)							\
>> +		return -ENOMEM;						\
>> +	smp_wmb();							\
> 
> Could I ask what's this wmb used for?

Sure. This is answered by a comment in __pte_alloc() in mm/memory.c. Let
me post it here.

         /*
          * Ensure all pte setup (eg. pte page lock and page clearing) are
          * visible before the pte is made visible to other CPUs by being
          * put into page tables.
          *
          * The other side of the story is the pointer chasing in the page
          * table walking code (when walking the page table without locking;
          * ie. most of the time). Fortunately, these data accesses consist
          * of a chain of data-dependent loads, meaning most CPUs (alpha
          * being the notable exception) will already guarantee loads are
          * seen in-order. See the alpha page table accessors for the
          * smp_read_barrier_depends() barriers in page table walking code.
          */
         smp_wmb(); /* Could be smp_wmb__xxx(before|after)_spin_lock */

> 
>> +	spin_lock(&(domain)->page_table_lock);				\
> 
> Is this intended to lock here instead of taking the lock during the
> whole page table walk?  Is it safe?
> 
> Taking the example where nm==PTE: when we reach here how do we
> guarantee that the PMD page that has this PTE is still valid?

We will always keep the non-leaf pages in the table, hence we only need
a spin lock to serialize multiple tries of populating a entry for pde.
As for pte, we can assume there is only single thread which can access
it at a time because different mappings will have different iova's.

> 
>> +	if (nm ## _present(*nm)) {					\
>> +		free_pgtable_page(__new);				\
>> +	} else {							\
>> +		set_##nm(nm, __##nm(__pa(__new) | _PAGE_TABLE));	\
> 
> It seems to me that PV could trap calls to set_pte().  Then these
> could also be trapped by e.g. Xen?  Are these traps needed?  Is there
> side effect?  I'm totally not familiar with this, but just ask aloud...

Good catch. But I don't think a vIOMMU could get a chance to run in a PV
environment. I might miss something?

> 
>> +		domain_flush_cache(domain, nm, sizeof(nm##_t));		\
>> +	}								\
>> +	spin_unlock(&(domain)->page_table_lock);			\
>> +} while(0);
>> +
>> +static int
>> +mmmap_pte_range(struct dmar_domain *domain, pmd_t *pmd, unsigned long addr,
>> +		unsigned long end, phys_addr_t phys_addr, pgprot_t prot)
>> +{
>> +	pte_t *pte, *first_pte;
>> +	u64 pfn;
>> +
>> +	pfn = phys_addr >> PAGE_SHIFT;
>> +	if (unlikely(pmd_none(*pmd)))
>> +		pgtable_populate(domain, pmd);
>> +
>> +	first_pte = pte = pte_offset_kernel(pmd, addr);
>> +
>> +	do {
>> +		set_pte(pte, pfn_pte(pfn, prot));
>> +		pfn++;
>> +	} while (pte++, addr += PAGE_SIZE, addr != end);
>> +
>> +	domain_flush_cache(domain, first_pte, (void *)pte - (void *)first_pte);
>> +
>> +	return 0;
>> +}
>> +
>> +static int
>> +mmmap_pmd_range(struct dmar_domain *domain, pud_t *pud, unsigned long addr,
>> +		unsigned long end, phys_addr_t phys_addr, pgprot_t prot)
>> +{
>> +	unsigned long next;
>> +	pmd_t *pmd;
>> +
>> +	if (unlikely(pud_none(*pud)))
>> +		pgtable_populate(domain, pud);
>> +	pmd = pmd_offset(pud, addr);
>> +
>> +	phys_addr -= addr;
>> +	do {
>> +		next = pmd_addr_end(addr, end);
>> +		if (mmmap_pte_range(domain, pmd, addr, next,
>> +				    phys_addr + addr, prot))
>> +			return -ENOMEM;
> 
> How about return the errcode of mmmap_pte_range() directly?

Yes. Fair enough.

> 
>> +	} while (pmd++, addr = next, addr != end);
>> +
>> +	return 0;
>> +}
>> +
>> +static int
>> +mmmap_pud_range(struct dmar_domain *domain, p4d_t *p4d, unsigned long addr,
>> +		unsigned long end, phys_addr_t phys_addr, pgprot_t prot)
>> +{
>> +	unsigned long next;
>> +	pud_t *pud;
>> +
>> +	if (unlikely(p4d_none(*p4d)))
>> +		pgtable_populate(domain, p4d);
>> +
>> +	pud = pud_offset(p4d, addr);
>> +
>> +	phys_addr -= addr;
>> +	do {
>> +		next = pud_addr_end(addr, end);
>> +		if (mmmap_pmd_range(domain, pud, addr, next,
>> +				    phys_addr + addr, prot))
>> +			return -ENOMEM;
> 
> Same.
> 
>> +	} while (pud++, addr = next, addr != end);
>> +
>> +	return 0;
>> +}
>> +
>> +static int
>> +mmmap_p4d_range(struct dmar_domain *domain, pgd_t *pgd, unsigned long addr,
>> +		unsigned long end, phys_addr_t phys_addr, pgprot_t prot)
>> +{
>> +	unsigned long next;
>> +	p4d_t *p4d;
>> +
>> +	if (cpu_feature_enabled(X86_FEATURE_LA57) && unlikely(pgd_none(*pgd)))
>> +		pgtable_populate(domain, pgd);
>> +
>> +	p4d = p4d_offset(pgd, addr);
>> +
>> +	phys_addr -= addr;
>> +	do {
>> +		next = p4d_addr_end(addr, end);
>> +		if (mmmap_pud_range(domain, p4d, addr, next,
>> +				    phys_addr + addr, prot))
>> +			return -ENOMEM;
> 
> Same.
> 
>> +	} while (p4d++, addr = next, addr != end);
>> +
>> +	return 0;
>> +}
>> +
>> +int intel_mmmap_range(struct dmar_domain *domain, unsigned long addr,
>> +		      unsigned long end, phys_addr_t phys_addr, int dma_prot)
>> +{
>> +	unsigned long next;
>> +	pgprot_t prot;
>> +	pgd_t *pgd;
>> +
>> +	trace_domain_mm_map(domain, addr, end, phys_addr);
>> +
>> +	/*
>> +	 * There is no PAGE_KERNEL_WO for a pte entry, so let's use RW
>> +	 * for a pte that requires write operation.
>> +	 */
>> +	prot = dma_prot & DMA_PTE_WRITE ? PAGE_KERNEL : PAGE_KERNEL_RO;
>> +	BUG_ON(addr >= end);
>> +
>> +	phys_addr -= addr;
>> +	pgd = pgd_offset_pgd(domain->pgd, addr);
>> +	do {
>> +		next = pgd_addr_end(addr, end);
>> +		if (mmmap_p4d_range(domain, pgd, addr, next,
>> +				    phys_addr + addr, prot))
>> +			return -ENOMEM;
> 
> Same.
> 
>> +	} while (pgd++, addr = next, addr != end);
>> +
>> +	return 0;
>> +}
>> +
>> +/*
>> + * mmunmap: Unmap an existing mapping between a range of IO vitual address
>> + *          and physical addresses.
>> + */
>> +static struct page *
>> +mmunmap_pte_range(struct dmar_domain *domain, pmd_t *pmd,
>> +		  unsigned long addr, unsigned long end,
>> +		  struct page *freelist, bool reclaim)
>> +{
>> +	int i;
>> +	unsigned long start;
>> +	pte_t *pte, *first_pte;
>> +
>> +	start = addr;
>> +	pte = pte_offset_kernel(pmd, addr);
>> +	first_pte = pte;
>> +	do {
>> +		set_pte(pte, __pte(0));
>> +	} while (pte++, addr += PAGE_SIZE, addr != end);
>> +
>> +	domain_flush_cache(domain, first_pte, (void *)pte - (void *)first_pte);
>> +
>> +	/* Add page to free list if all entries are empty. */
>> +	if (reclaim) {
> 
> Shouldn't we know whether to reclaim if with (addr, end) specified as
> long as they cover the whole range of this PMD?

Current policy is that we don't reclaim any pages until the whole page
table will be torn down. The gain is that we don't have to use a
spinlock when map/unmap a pmd entry anymore.

> 
> Also I noticed that this value right now is passed in from the very
> top of the unmap() call.  I didn't really catch the point of that...
> 

The caller decides whether to reclaim the pages. Current policy is only
reclaiming pages when torn down a page table.

> I'll have similar question to below a few places but I'll skip to
> comment after I understand this one.
> 
>> +		struct page *pte_page;
>> +
>> +		pte = (pte_t *)pmd_page_vaddr(*pmd);
>> +		for (i = 0; i < PTRS_PER_PTE; i++)
>> +			if (!pte || !pte_none(pte[i]))
>> +				goto pte_out;
>> +
>> +		pte_page = pmd_page(*pmd);
>> +		pte_page->freelist = freelist;
>> +		freelist = pte_page;
>> +		pmd_clear(pmd);
>> +		domain_flush_cache(domain, pmd, sizeof(pmd_t));
>> +	}
>> +
>> +pte_out:
>> +	return freelist;
>> +}
> 
> Regards,
> 

Best regards,
Baolu
