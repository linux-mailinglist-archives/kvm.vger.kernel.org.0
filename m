Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AAA94BD7BA
	for <lists+kvm@lfdr.de>; Wed, 25 Sep 2019 07:22:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2633965AbfIYFWO (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 25 Sep 2019 01:22:14 -0400
Received: from mx1.redhat.com ([209.132.183.28]:38282 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2633952AbfIYFWM (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 25 Sep 2019 01:22:12 -0400
Received: from mail-pl1-f199.google.com (mail-pl1-f199.google.com [209.85.214.199])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 9662980F91
        for <kvm@vger.kernel.org>; Wed, 25 Sep 2019 05:22:11 +0000 (UTC)
Received: by mail-pl1-f199.google.com with SMTP id g20so2630770plj.15
        for <kvm@vger.kernel.org>; Tue, 24 Sep 2019 22:22:11 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=qpstl2yJkkpj95636PfTSAxVYaG/GkSVcL8Wuku3BZk=;
        b=DvKHbDpoSOiM0aMjrSL9SDUVAG7AqVgLk+XyOlDq8xFJ4ZAt/0AAiSWcGoFNX9T7qz
         tW5MXLSppnKBTS3mjvDlLy1gdzUEQ9bXOq7wlspk9A9oscQn1tvbI9KORC0YmP/eBs0U
         T959wRjSrPX9XUa1qhoSuC2qZ7EI7QSjDJtzlFyuRmACe30G9+BPATgPaNPDNMATMyRz
         zp23JQkJ3tu8ZMIvM4lYjcT6pUkVKA0ru3n4v5E8lQka0IonFwaJYVHOyHfx7MH61J0k
         taSkLw6wa1V0o3IcvA0iy/ANrZmcJGVKjvX9MefcEUrU0IFNBQCW5iL3Dn1DakYDlKKy
         oDHQ==
X-Gm-Message-State: APjAAAUctrRFnpn38V/1ewaJZxXTxybiNWVwNTVOxvPy6oU8uNffp/P2
        w2TM/3gh5wzjU4a+YbPx8YAzjVEmkw+cRxpjyFQZIJcraMoAFEiaYBAavhCQk9a9iySXVQmfG+h
        gc+jjINhhilBl
X-Received: by 2002:a65:5c0b:: with SMTP id u11mr6974915pgr.294.1569388930461;
        Tue, 24 Sep 2019 22:22:10 -0700 (PDT)
X-Google-Smtp-Source: APXvYqxVH44sOKA0TrcGiF/TYwgX91lTxmEKuAa+c51LptqDzNivQ0XTKrbkH4QTN7/cD8hPJHAv9Q==
X-Received: by 2002:a65:5c0b:: with SMTP id u11mr6974881pgr.294.1569388930048;
        Tue, 24 Sep 2019 22:22:10 -0700 (PDT)
Received: from xz-x1 ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id y2sm5821568pfe.126.2019.09.24.22.22.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 24 Sep 2019 22:22:09 -0700 (PDT)
Date:   Wed, 25 Sep 2019 13:21:57 +0800
From:   Peter Xu <peterx@redhat.com>
To:     Lu Baolu <baolu.lu@linux.intel.com>
Cc:     Joerg Roedel <joro@8bytes.org>,
        David Woodhouse <dwmw2@infradead.org>,
        Alex Williamson <alex.williamson@redhat.com>,
        kevin.tian@intel.com, Yi Sun <yi.y.sun@linux.intel.com>,
        ashok.raj@intel.com, kvm@vger.kernel.org, sanjay.k.kumar@intel.com,
        iommu@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
        yi.y.sun@intel.com
Subject: Re: [RFC PATCH 2/4] iommu/vt-d: Add first level page table interfaces
Message-ID: <20190925052157.GL28074@xz-x1>
References: <20190923122454.9888-1-baolu.lu@linux.intel.com>
 <20190923122454.9888-3-baolu.lu@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20190923122454.9888-3-baolu.lu@linux.intel.com>
User-Agent: Mutt/1.11.4 (2019-03-13)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Sep 23, 2019 at 08:24:52PM +0800, Lu Baolu wrote:
> This adds functions to manipulate first level page tables
> which could be used by a scalale mode capable IOMMU unit.
> 
> intel_mmmap_range(domain, addr, end, phys_addr, prot)
>  - Map an iova range of [addr, end) to the physical memory
>    started at @phys_addr with the @prot permissions.
> 
> intel_mmunmap_range(domain, addr, end)
>  - Tear down the map of an iova range [addr, end). A page
>    list will be returned which will be freed after iotlb
>    flushing.
> 
> Cc: Ashok Raj <ashok.raj@intel.com>
> Cc: Jacob Pan <jacob.jun.pan@linux.intel.com>
> Cc: Kevin Tian <kevin.tian@intel.com>
> Cc: Liu Yi L <yi.l.liu@intel.com>
> Cc: Yi Sun <yi.y.sun@linux.intel.com>
> Signed-off-by: Lu Baolu <baolu.lu@linux.intel.com>
> ---
>  drivers/iommu/Makefile             |   2 +-
>  drivers/iommu/intel-pgtable.c      | 342 +++++++++++++++++++++++++++++
>  include/linux/intel-iommu.h        |  24 +-
>  include/trace/events/intel_iommu.h |  60 +++++
>  4 files changed, 426 insertions(+), 2 deletions(-)
>  create mode 100644 drivers/iommu/intel-pgtable.c
> 
> diff --git a/drivers/iommu/Makefile b/drivers/iommu/Makefile
> index 4f405f926e73..dc550e14cc58 100644
> --- a/drivers/iommu/Makefile
> +++ b/drivers/iommu/Makefile
> @@ -17,7 +17,7 @@ obj-$(CONFIG_ARM_SMMU) += arm-smmu.o arm-smmu-impl.o
>  obj-$(CONFIG_ARM_SMMU_V3) += arm-smmu-v3.o
>  obj-$(CONFIG_DMAR_TABLE) += dmar.o
>  obj-$(CONFIG_INTEL_IOMMU) += intel-iommu.o intel-pasid.o
> -obj-$(CONFIG_INTEL_IOMMU) += intel-trace.o
> +obj-$(CONFIG_INTEL_IOMMU) += intel-trace.o intel-pgtable.o
>  obj-$(CONFIG_INTEL_IOMMU_DEBUGFS) += intel-iommu-debugfs.o
>  obj-$(CONFIG_INTEL_IOMMU_SVM) += intel-svm.o
>  obj-$(CONFIG_IPMMU_VMSA) += ipmmu-vmsa.o
> diff --git a/drivers/iommu/intel-pgtable.c b/drivers/iommu/intel-pgtable.c
> new file mode 100644
> index 000000000000..8e95978cd381
> --- /dev/null
> +++ b/drivers/iommu/intel-pgtable.c
> @@ -0,0 +1,342 @@
> +// SPDX-License-Identifier: GPL-2.0
> +/**
> + * intel-pgtable.c - Intel IOMMU page table manipulation library

Could this be a bit misleading?  Normally I'll use "IOMMU page table"
to refer to the 2nd level page table only, and I'm always
understanding it as "the new IOMMU will understand MMU page table as
the 1st level".  At least mention "IOMMU 1st level page table"?

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
> +#ifdef CONFIG_X86
> +/*
> + * mmmap: Map a range of IO virtual address to physical addresses.

"... to physical addresses using MMU page table"?

Might be clearer?

> + */
> +#define pgtable_populate(domain, nm)					\
> +do {									\
> +	void *__new = alloc_pgtable_page(domain->nid);			\
> +	if (!__new)							\
> +		return -ENOMEM;						\
> +	smp_wmb();							\

Could I ask what's this wmb used for?

> +	spin_lock(&(domain)->page_table_lock);				\

Is this intended to lock here instead of taking the lock during the
whole page table walk?  Is it safe?

Taking the example where nm==PTE: when we reach here how do we
guarantee that the PMD page that has this PTE is still valid?

> +	if (nm ## _present(*nm)) {					\
> +		free_pgtable_page(__new);				\
> +	} else {							\
> +		set_##nm(nm, __##nm(__pa(__new) | _PAGE_TABLE));	\

It seems to me that PV could trap calls to set_pte().  Then these
could also be trapped by e.g. Xen?  Are these traps needed?  Is there
side effect?  I'm totally not familiar with this, but just ask aloud...

> +		domain_flush_cache(domain, nm, sizeof(nm##_t));		\
> +	}								\
> +	spin_unlock(&(domain)->page_table_lock);			\
> +} while(0);
> +
> +static int
> +mmmap_pte_range(struct dmar_domain *domain, pmd_t *pmd, unsigned long addr,
> +		unsigned long end, phys_addr_t phys_addr, pgprot_t prot)
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
> +		set_pte(pte, pfn_pte(pfn, prot));
> +		pfn++;
> +	} while (pte++, addr += PAGE_SIZE, addr != end);
> +
> +	domain_flush_cache(domain, first_pte, (void *)pte - (void *)first_pte);
> +
> +	return 0;
> +}
> +
> +static int
> +mmmap_pmd_range(struct dmar_domain *domain, pud_t *pud, unsigned long addr,
> +		unsigned long end, phys_addr_t phys_addr, pgprot_t prot)
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
> +		if (mmmap_pte_range(domain, pmd, addr, next,
> +				    phys_addr + addr, prot))
> +			return -ENOMEM;

How about return the errcode of mmmap_pte_range() directly?

> +	} while (pmd++, addr = next, addr != end);
> +
> +	return 0;
> +}
> +
> +static int
> +mmmap_pud_range(struct dmar_domain *domain, p4d_t *p4d, unsigned long addr,
> +		unsigned long end, phys_addr_t phys_addr, pgprot_t prot)
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
> +		if (mmmap_pmd_range(domain, pud, addr, next,
> +				    phys_addr + addr, prot))
> +			return -ENOMEM;

Same.

> +	} while (pud++, addr = next, addr != end);
> +
> +	return 0;
> +}
> +
> +static int
> +mmmap_p4d_range(struct dmar_domain *domain, pgd_t *pgd, unsigned long addr,
> +		unsigned long end, phys_addr_t phys_addr, pgprot_t prot)
> +{
> +	unsigned long next;
> +	p4d_t *p4d;
> +
> +	if (cpu_feature_enabled(X86_FEATURE_LA57) && unlikely(pgd_none(*pgd)))
> +		pgtable_populate(domain, pgd);
> +
> +	p4d = p4d_offset(pgd, addr);
> +
> +	phys_addr -= addr;
> +	do {
> +		next = p4d_addr_end(addr, end);
> +		if (mmmap_pud_range(domain, p4d, addr, next,
> +				    phys_addr + addr, prot))
> +			return -ENOMEM;

Same.

> +	} while (p4d++, addr = next, addr != end);
> +
> +	return 0;
> +}
> +
> +int intel_mmmap_range(struct dmar_domain *domain, unsigned long addr,
> +		      unsigned long end, phys_addr_t phys_addr, int dma_prot)
> +{
> +	unsigned long next;
> +	pgprot_t prot;
> +	pgd_t *pgd;
> +
> +	trace_domain_mm_map(domain, addr, end, phys_addr);
> +
> +	/*
> +	 * There is no PAGE_KERNEL_WO for a pte entry, so let's use RW
> +	 * for a pte that requires write operation.
> +	 */
> +	prot = dma_prot & DMA_PTE_WRITE ? PAGE_KERNEL : PAGE_KERNEL_RO;
> +	BUG_ON(addr >= end);
> +
> +	phys_addr -= addr;
> +	pgd = pgd_offset_pgd(domain->pgd, addr);
> +	do {
> +		next = pgd_addr_end(addr, end);
> +		if (mmmap_p4d_range(domain, pgd, addr, next,
> +				    phys_addr + addr, prot))
> +			return -ENOMEM;

Same.

> +	} while (pgd++, addr = next, addr != end);
> +
> +	return 0;
> +}
> +
> +/*
> + * mmunmap: Unmap an existing mapping between a range of IO vitual address
> + *          and physical addresses.
> + */
> +static struct page *
> +mmunmap_pte_range(struct dmar_domain *domain, pmd_t *pmd,
> +		  unsigned long addr, unsigned long end,
> +		  struct page *freelist, bool reclaim)
> +{
> +	int i;
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
> +	domain_flush_cache(domain, first_pte, (void *)pte - (void *)first_pte);
> +
> +	/* Add page to free list if all entries are empty. */
> +	if (reclaim) {

Shouldn't we know whether to reclaim if with (addr, end) specified as
long as they cover the whole range of this PMD?

Also I noticed that this value right now is passed in from the very
top of the unmap() call.  I didn't really catch the point of that...

I'll have similar question to below a few places but I'll skip to
comment after I understand this one.

> +		struct page *pte_page;
> +
> +		pte = (pte_t *)pmd_page_vaddr(*pmd);
> +		for (i = 0; i < PTRS_PER_PTE; i++)
> +			if (!pte || !pte_none(pte[i]))
> +				goto pte_out;
> +
> +		pte_page = pmd_page(*pmd);
> +		pte_page->freelist = freelist;
> +		freelist = pte_page;
> +		pmd_clear(pmd);
> +		domain_flush_cache(domain, pmd, sizeof(pmd_t));
> +	}
> +
> +pte_out:
> +	return freelist;
> +}

Regards,

-- 
Peter Xu
