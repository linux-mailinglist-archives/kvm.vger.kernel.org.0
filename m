Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9198F3792F1
	for <lists+kvm@lfdr.de>; Mon, 10 May 2021 17:44:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230521AbhEJPpt (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 10 May 2021 11:45:49 -0400
Received: from foss.arm.com ([217.140.110.172]:32910 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230300AbhEJPpq (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 10 May 2021 11:45:46 -0400
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 3B7E9168F;
        Mon, 10 May 2021 08:44:41 -0700 (PDT)
Received: from [192.168.0.110] (unknown [172.31.20.19])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 5ED113F719;
        Mon, 10 May 2021 08:44:40 -0700 (PDT)
Subject: Re: [PATCH kvm-unit-tests v3 4/8] arm/arm64: mmu: Stop mapping an
 assumed IO region
To:     Andrew Jones <drjones@redhat.com>, kvm@vger.kernel.org
Cc:     nikos.nikoleris@arm.com, andre.przywara@arm.com,
        eric.auger@redhat.com
References: <20210429164130.405198-1-drjones@redhat.com>
 <20210429164130.405198-5-drjones@redhat.com>
From:   Alexandru Elisei <alexandru.elisei@arm.com>
Message-ID: <94288c5b-8894-5f8b-2477-6e45e087c4b5@arm.com>
Date:   Mon, 10 May 2021 16:45:18 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <20210429164130.405198-5-drjones@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Content-Language: en-US
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Drew,

On 4/29/21 5:41 PM, Andrew Jones wrote:
> By providing a proper ioremap function, we can just rely on devices
> calling it for each region they need (as they already do) instead of
> mapping a big assumed I/O range. We don't require the MMU to be
> enabled at the time of the ioremap. In that case, we add the mapping
> to the identity map anyway. This allows us to call setup_vm after
> io_init. Why don't we just call setup_vm before io_init, I hear you
> ask? Well, that's because tests like sieve want to start with the MMU
> off, later call setup_vm, and all the while have working I/O. Some
> unit tests are just really demanding...
>
> While at it, ensure we map the I/O regions with XN (execute never),
> as suggested by Alexandru Elisei.

I got to thinking why this wasn't an issue before. Under KVM, device memory is not
usually mapped at stage 2, so any speculated reads wouldn't have reached memory at
all. The only way I imagine that happening if the user was running kvm-unit-tests
with a passthrough PCI device, which I don't think happens too often.

But we cannot rely on devices not being mapped at stage 2 when running under EFI
(we're mapping them ourselves with ioremap), so I believe this is a good fix.

Had another look at the patch, looks good to me:

Reviewed-by: Alexandru Elisei <alexandru.elisei@arm.com>

Thanks,

Alex

>
> Signed-off-by: Andrew Jones <drjones@redhat.com>
> ---
>  lib/arm/asm/io.h            |  6 ++++++
>  lib/arm/asm/mmu.h           |  3 +++
>  lib/arm/asm/page.h          |  2 ++
>  lib/arm/asm/pgtable-hwdef.h |  1 +
>  lib/arm/mmu.c               | 37 +++++++++++++++++++++++++++----------
>  lib/arm64/asm/io.h          |  6 ++++++
>  lib/arm64/asm/mmu.h         |  1 +
>  lib/arm64/asm/page.h        |  2 ++
>  8 files changed, 48 insertions(+), 10 deletions(-)
>
> diff --git a/lib/arm/asm/io.h b/lib/arm/asm/io.h
> index ba3b0b2412ad..e4caa6ff5d1e 100644
> --- a/lib/arm/asm/io.h
> +++ b/lib/arm/asm/io.h
> @@ -77,6 +77,12 @@ static inline void __raw_writel(u32 val, volatile void __iomem *addr)
>  		     : "r" (val));
>  }
>  
> +#define ioremap ioremap
> +static inline void __iomem *ioremap(phys_addr_t phys_addr, size_t size)
> +{
> +	return __ioremap(phys_addr, size);
> +}
> +
>  #define virt_to_phys virt_to_phys
>  static inline phys_addr_t virt_to_phys(const volatile void *x)
>  {
> diff --git a/lib/arm/asm/mmu.h b/lib/arm/asm/mmu.h
> index 122874b8aebe..94e70f0a84bf 100644
> --- a/lib/arm/asm/mmu.h
> +++ b/lib/arm/asm/mmu.h
> @@ -8,10 +8,13 @@
>  #include <asm/barrier.h>
>  
>  #define PTE_USER		L_PTE_USER
> +#define PTE_UXN			L_PTE_XN
> +#define PTE_PXN			L_PTE_PXN
>  #define PTE_RDONLY		PTE_AP2
>  #define PTE_SHARED		L_PTE_SHARED
>  #define PTE_AF			PTE_EXT_AF
>  #define PTE_WBWA		L_PTE_MT_WRITEALLOC
> +#define PTE_UNCACHED		L_PTE_MT_UNCACHED
>  
>  /* See B3.18.7 TLB maintenance operations */
>  
> diff --git a/lib/arm/asm/page.h b/lib/arm/asm/page.h
> index 1fb5cd26ac66..8eb4a883808e 100644
> --- a/lib/arm/asm/page.h
> +++ b/lib/arm/asm/page.h
> @@ -47,5 +47,7 @@ typedef struct { pteval_t pgprot; } pgprot_t;
>  extern phys_addr_t __virt_to_phys(unsigned long addr);
>  extern unsigned long __phys_to_virt(phys_addr_t addr);
>  
> +extern void *__ioremap(phys_addr_t phys_addr, size_t size);
> +
>  #endif /* !__ASSEMBLY__ */
>  #endif /* _ASMARM_PAGE_H_ */
> diff --git a/lib/arm/asm/pgtable-hwdef.h b/lib/arm/asm/pgtable-hwdef.h
> index fe1d8540ea3f..90fd306c7cc0 100644
> --- a/lib/arm/asm/pgtable-hwdef.h
> +++ b/lib/arm/asm/pgtable-hwdef.h
> @@ -34,6 +34,7 @@
>  #define L_PTE_USER		(_AT(pteval_t, 1) << 6)		/* AP[1] */
>  #define L_PTE_SHARED		(_AT(pteval_t, 3) << 8)		/* SH[1:0], inner shareable */
>  #define L_PTE_YOUNG		(_AT(pteval_t, 1) << 10)	/* AF */
> +#define L_PTE_PXN		(_AT(pteval_t, 1) << 53)	/* PXN */
>  #define L_PTE_XN		(_AT(pteval_t, 1) << 54)	/* XN */
>  
>  /*
> diff --git a/lib/arm/mmu.c b/lib/arm/mmu.c
> index 15eef007f256..791b1f88f946 100644
> --- a/lib/arm/mmu.c
> +++ b/lib/arm/mmu.c
> @@ -11,6 +11,7 @@
>  #include <asm/mmu.h>
>  #include <asm/setup.h>
>  #include <asm/page.h>
> +#include <asm/io.h>
>  
>  #include "alloc_page.h"
>  #include "vmalloc.h"
> @@ -157,9 +158,8 @@ void mmu_set_range_sect(pgd_t *pgtable, uintptr_t virt_offset,
>  void *setup_mmu(phys_addr_t phys_end)
>  {
>  	uintptr_t code_end = (uintptr_t)&etext;
> -	struct mem_region *r;
>  
> -	/* 0G-1G = I/O, 1G-3G = identity, 3G-4G = vmalloc */
> +	/* 3G-4G region is reserved for vmalloc, cap phys_end at 3G */
>  	if (phys_end > (3ul << 30))
>  		phys_end = 3ul << 30;
>  
> @@ -170,14 +170,8 @@ void *setup_mmu(phys_addr_t phys_end)
>  			"Unsupported translation granule %ld\n", PAGE_SIZE);
>  #endif
>  
> -	mmu_idmap = alloc_page();
> -
> -	for (r = mem_regions; r->end; ++r) {
> -		if (!(r->flags & MR_F_IO))
> -			continue;
> -		mmu_set_range_sect(mmu_idmap, r->start, r->start, r->end,
> -				   __pgprot(PMD_SECT_UNCACHED | PMD_SECT_USER));
> -	}
> +	if (!mmu_idmap)
> +		mmu_idmap = alloc_page();
>  
>  	/* armv8 requires code shared between EL1 and EL0 to be read-only */
>  	mmu_set_range_ptes(mmu_idmap, PHYS_OFFSET,
> @@ -192,6 +186,29 @@ void *setup_mmu(phys_addr_t phys_end)
>  	return mmu_idmap;
>  }
>  
> +void __iomem *__ioremap(phys_addr_t phys_addr, size_t size)
> +{
> +	phys_addr_t paddr_aligned = phys_addr & PAGE_MASK;
> +	phys_addr_t paddr_end = PAGE_ALIGN(phys_addr + size);
> +	pgprot_t prot = __pgprot(PTE_UNCACHED | PTE_USER | PTE_UXN | PTE_PXN);
> +	pgd_t *pgtable;
> +
> +	assert(sizeof(long) == 8 || !(phys_addr >> 32));
> +
> +	if (mmu_enabled()) {
> +		pgtable = current_thread_info()->pgtable;
> +	} else {
> +		if (!mmu_idmap)
> +			mmu_idmap = alloc_page();
> +		pgtable = mmu_idmap;
> +	}
> +
> +	mmu_set_range_ptes(pgtable, paddr_aligned, paddr_aligned,
> +			   paddr_end, prot);
> +
> +	return (void __iomem *)(unsigned long)phys_addr;
> +}
> +
>  phys_addr_t __virt_to_phys(unsigned long addr)
>  {
>  	if (mmu_enabled()) {
> diff --git a/lib/arm64/asm/io.h b/lib/arm64/asm/io.h
> index e0a03b250d5b..be19f471c0fa 100644
> --- a/lib/arm64/asm/io.h
> +++ b/lib/arm64/asm/io.h
> @@ -71,6 +71,12 @@ static inline u64 __raw_readq(const volatile void __iomem *addr)
>  	return val;
>  }
>  
> +#define ioremap ioremap
> +static inline void __iomem *ioremap(phys_addr_t phys_addr, size_t size)
> +{
> +	return __ioremap(phys_addr, size);
> +}
> +
>  #define virt_to_phys virt_to_phys
>  static inline phys_addr_t virt_to_phys(const volatile void *x)
>  {
> diff --git a/lib/arm64/asm/mmu.h b/lib/arm64/asm/mmu.h
> index 72d75eafc882..72371b2d9fe3 100644
> --- a/lib/arm64/asm/mmu.h
> +++ b/lib/arm64/asm/mmu.h
> @@ -8,6 +8,7 @@
>  #include <asm/barrier.h>
>  
>  #define PMD_SECT_UNCACHED	PMD_ATTRINDX(MT_DEVICE_nGnRE)
> +#define PTE_UNCACHED		PTE_ATTRINDX(MT_DEVICE_nGnRE)
>  #define PTE_WBWA		PTE_ATTRINDX(MT_NORMAL)
>  
>  static inline void flush_tlb_all(void)
> diff --git a/lib/arm64/asm/page.h b/lib/arm64/asm/page.h
> index ae4484b22114..d0fac6ea563d 100644
> --- a/lib/arm64/asm/page.h
> +++ b/lib/arm64/asm/page.h
> @@ -72,5 +72,7 @@ typedef struct { pteval_t pgprot; } pgprot_t;
>  extern phys_addr_t __virt_to_phys(unsigned long addr);
>  extern unsigned long __phys_to_virt(phys_addr_t addr);
>  
> +extern void *__ioremap(phys_addr_t phys_addr, size_t size);
> +
>  #endif /* !__ASSEMBLY__ */
>  #endif /* _ASMARM64_PAGE_H_ */
