Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EDE0835E0EF
	for <lists+kvm@lfdr.de>; Tue, 13 Apr 2021 16:07:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237475AbhDMOHV (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 13 Apr 2021 10:07:21 -0400
Received: from foss.arm.com ([217.140.110.172]:42934 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230435AbhDMOHU (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 13 Apr 2021 10:07:20 -0400
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 3589F106F;
        Tue, 13 Apr 2021 07:07:00 -0700 (PDT)
Received: from C02W217MHV2R.local (unknown [172.31.20.19])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 52BED3F694;
        Tue, 13 Apr 2021 07:06:59 -0700 (PDT)
Subject: Re: [PATCH kvm-unit-tests 4/8] arm/arm64: mmu: Stop mapping an
 assumed IO region
To:     Andrew Jones <drjones@redhat.com>, kvm@vger.kernel.org
Cc:     alexandru.elisei@arm.com, andre.przywara@arm.com,
        eric.auger@redhat.com
References: <20210407185918.371983-1-drjones@redhat.com>
 <20210407185918.371983-5-drjones@redhat.com>
From:   Nikos Nikoleris <nikos.nikoleris@arm.com>
Message-ID: <7db65c6e-aacc-fe74-8960-1dc26a9310a4@arm.com>
Date:   Tue, 13 Apr 2021 15:06:58 +0100
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.9.1
MIME-Version: 1.0
In-Reply-To: <20210407185918.371983-5-drjones@redhat.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 07/04/2021 19:59, Andrew Jones wrote:
> By providing a proper ioremap function, we can just rely on devices
> calling it for each region they need (as they already do) instead of
> mapping a big assumed I/O range. The persistent maps weirdness allows
> us to call setup_vm after io_init. Why don't we just call setup_vm
> before io_init, I hear you ask? Well, that's because tests like sieve
> want to start with the MMU off and later call setup_vm, and all the
> while have working I/O. Some unit tests are just really demanding...
> 
> Signed-off-by: Andrew Jones <drjones@redhat.com>

That's a very nice improvement! I wonder if any of the current calls to 
ioremap are for ranges big enough to allow for a sect map. However, this 
would be a performance improvent and something we can look at at some 
point in the future.

Reviewed-by: Nikos Nikoleris <nikos.nikoleris@arm.com>

> ---
>   lib/arm/asm/io.h      |  6 ++++
>   lib/arm/asm/mmu-api.h |  1 +
>   lib/arm/asm/mmu.h     |  1 +
>   lib/arm/asm/page.h    |  2 ++
>   lib/arm/mmu.c         | 82 ++++++++++++++++++++++++++++++++++++++-----
>   lib/arm64/asm/io.h    |  6 ++++
>   lib/arm64/asm/mmu.h   |  1 +
>   lib/arm64/asm/page.h  |  2 ++
>   8 files changed, 93 insertions(+), 8 deletions(-)
> 
> diff --git a/lib/arm/asm/io.h b/lib/arm/asm/io.h
> index ba3b0b2412ad..e4caa6ff5d1e 100644
> --- a/lib/arm/asm/io.h
> +++ b/lib/arm/asm/io.h
> @@ -77,6 +77,12 @@ static inline void __raw_writel(u32 val, volatile void __iomem *addr)
>   		     : "r" (val));
>   }
>   
> +#define ioremap ioremap
> +static inline void __iomem *ioremap(phys_addr_t phys_addr, size_t size)
> +{
> +	return __ioremap(phys_addr, size);
> +}
> +
>   #define virt_to_phys virt_to_phys
>   static inline phys_addr_t virt_to_phys(const volatile void *x)
>   {
> diff --git a/lib/arm/asm/mmu-api.h b/lib/arm/asm/mmu-api.h
> index 05fc12b5afb8..b9a5a8f6b3c1 100644
> --- a/lib/arm/asm/mmu-api.h
> +++ b/lib/arm/asm/mmu-api.h
> @@ -17,6 +17,7 @@ extern void mmu_set_range_sect(pgd_t *pgtable, uintptr_t virt_offset,
>   extern void mmu_set_range_ptes(pgd_t *pgtable, uintptr_t virt_offset,
>   			       phys_addr_t phys_start, phys_addr_t phys_end,
>   			       pgprot_t prot);
> +extern void mmu_set_persistent_maps(pgd_t *pgtable);
>   extern pteval_t *mmu_get_pte(pgd_t *pgtable, uintptr_t vaddr);
>   extern void mmu_clear_user(pgd_t *pgtable, unsigned long vaddr);
>   #endif
> diff --git a/lib/arm/asm/mmu.h b/lib/arm/asm/mmu.h
> index 122874b8aebe..d88a4f16df42 100644
> --- a/lib/arm/asm/mmu.h
> +++ b/lib/arm/asm/mmu.h
> @@ -12,6 +12,7 @@
>   #define PTE_SHARED		L_PTE_SHARED
>   #define PTE_AF			PTE_EXT_AF
>   #define PTE_WBWA		L_PTE_MT_WRITEALLOC
> +#define PTE_UNCACHED		L_PTE_MT_UNCACHED
>   
>   /* See B3.18.7 TLB maintenance operations */
>   
> diff --git a/lib/arm/asm/page.h b/lib/arm/asm/page.h
> index 1fb5cd26ac66..8eb4a883808e 100644
> --- a/lib/arm/asm/page.h
> +++ b/lib/arm/asm/page.h
> @@ -47,5 +47,7 @@ typedef struct { pteval_t pgprot; } pgprot_t;
>   extern phys_addr_t __virt_to_phys(unsigned long addr);
>   extern unsigned long __phys_to_virt(phys_addr_t addr);
>   
> +extern void *__ioremap(phys_addr_t phys_addr, size_t size);
> +
>   #endif /* !__ASSEMBLY__ */
>   #endif /* _ASMARM_PAGE_H_ */
> diff --git a/lib/arm/mmu.c b/lib/arm/mmu.c
> index 15eef007f256..a7b7ae51afe3 100644
> --- a/lib/arm/mmu.c
> +++ b/lib/arm/mmu.c
> @@ -11,6 +11,7 @@
>   #include <asm/mmu.h>
>   #include <asm/setup.h>
>   #include <asm/page.h>
> +#include <asm/io.h>
>   
>   #include "alloc_page.h"
>   #include "vmalloc.h"
> @@ -21,6 +22,57 @@
>   
>   extern unsigned long etext;
>   
> +#define MMU_MAX_PERSISTENT_MAPS 64
> +
> +struct mmu_persistent_map {
> +	uintptr_t virt_offset;
> +	phys_addr_t phys_start;
> +	phys_addr_t phys_end;
> +	pgprot_t prot;
> +	bool sect;
> +};
> +
> +static struct mmu_persistent_map mmu_persistent_maps[MMU_MAX_PERSISTENT_MAPS];
> +
> +static void
> +mmu_set_persistent_range(uintptr_t virt_offset, phys_addr_t phys_start,
> +			 phys_addr_t phys_end, pgprot_t prot, bool sect)
> +{
> +	int i;
> +
> +	assert(phys_end);
> +
> +	for (i = 0; i < MMU_MAX_PERSISTENT_MAPS; ++i) {
> +		if (!mmu_persistent_maps[i].phys_end)
> +			break;
> +	}
> +	assert(i < MMU_MAX_PERSISTENT_MAPS);
> +
> +	mmu_persistent_maps[i] = (struct mmu_persistent_map){
> +		.virt_offset = virt_offset,
> +		.phys_start = phys_start,
> +		.phys_end = phys_end,
> +		.prot = prot,
> +		.sect = sect,
> +	};
> +}
> +
> +void mmu_set_persistent_maps(pgd_t *pgtable)
> +{
> +	struct mmu_persistent_map *map;
> +
> +	for (map = &mmu_persistent_maps[0]; map->phys_end; ++map) {
> +		if (map->sect)
> +			mmu_set_range_sect(pgtable, map->virt_offset,
> +					   map->phys_start, map->phys_end,
> +					   map->prot);
> +		else
> +			mmu_set_range_ptes(pgtable, map->virt_offset,
> +					   map->phys_start, map->phys_end,
> +					   map->prot);
> +	}
> +}
> +
>   pgd_t *mmu_idmap;
>   
>   /* CPU 0 starts with disabled MMU */
> @@ -157,7 +209,6 @@ void mmu_set_range_sect(pgd_t *pgtable, uintptr_t virt_offset,
>   void *setup_mmu(phys_addr_t phys_end)
>   {
>   	uintptr_t code_end = (uintptr_t)&etext;
> -	struct mem_region *r;
>   
>   	/* 0G-1G = I/O, 1G-3G = identity, 3G-4G = vmalloc */
>   	if (phys_end > (3ul << 30))
> @@ -172,13 +223,6 @@ void *setup_mmu(phys_addr_t phys_end)
>   
>   	mmu_idmap = alloc_page();
>   
> -	for (r = mem_regions; r->end; ++r) {
> -		if (!(r->flags & MR_F_IO))
> -			continue;
> -		mmu_set_range_sect(mmu_idmap, r->start, r->start, r->end,
> -				   __pgprot(PMD_SECT_UNCACHED | PMD_SECT_USER));
> -	}
> -
>   	/* armv8 requires code shared between EL1 and EL0 to be read-only */
>   	mmu_set_range_ptes(mmu_idmap, PHYS_OFFSET,
>   		PHYS_OFFSET, code_end,
> @@ -188,10 +232,32 @@ void *setup_mmu(phys_addr_t phys_end)
>   		code_end, phys_end,
>   		__pgprot(PTE_WBWA | PTE_USER));
>   
> +	mmu_set_persistent_maps(mmu_idmap);
> +
>   	mmu_enable(mmu_idmap);
>   	return mmu_idmap;
>   }
>   
> +void __iomem *__ioremap(phys_addr_t phys_addr, size_t size)
> +{
> +	phys_addr_t paddr_aligned = phys_addr & PAGE_MASK;
> +	phys_addr_t paddr_end = PAGE_ALIGN(phys_addr + size);
> +	pgprot_t prot = __pgprot(PTE_UNCACHED | PTE_USER);
> +
> +	assert(sizeof(long) == 8 || !(phys_addr >> 32));
> +
> +	mmu_set_persistent_range(paddr_aligned, paddr_aligned, paddr_end,
> +				 prot, false);
> +
> +	if (mmu_enabled()) {
> +		pgd_t *pgtable = current_thread_info()->pgtable;
> +		mmu_set_range_ptes(pgtable, paddr_aligned, paddr_aligned,
> +				   paddr_end, prot);
> +	}
> +
> +	return (void __iomem *)(unsigned long)phys_addr;
> +}
> +
>   phys_addr_t __virt_to_phys(unsigned long addr)
>   {
>   	if (mmu_enabled()) {
> diff --git a/lib/arm64/asm/io.h b/lib/arm64/asm/io.h
> index e0a03b250d5b..be19f471c0fa 100644
> --- a/lib/arm64/asm/io.h
> +++ b/lib/arm64/asm/io.h
> @@ -71,6 +71,12 @@ static inline u64 __raw_readq(const volatile void __iomem *addr)
>   	return val;
>   }
>   
> +#define ioremap ioremap
> +static inline void __iomem *ioremap(phys_addr_t phys_addr, size_t size)
> +{
> +	return __ioremap(phys_addr, size);
> +}
> +
>   #define virt_to_phys virt_to_phys
>   static inline phys_addr_t virt_to_phys(const volatile void *x)
>   {
> diff --git a/lib/arm64/asm/mmu.h b/lib/arm64/asm/mmu.h
> index 72d75eafc882..72371b2d9fe3 100644
> --- a/lib/arm64/asm/mmu.h
> +++ b/lib/arm64/asm/mmu.h
> @@ -8,6 +8,7 @@
>   #include <asm/barrier.h>
>   
>   #define PMD_SECT_UNCACHED	PMD_ATTRINDX(MT_DEVICE_nGnRE)
> +#define PTE_UNCACHED		PTE_ATTRINDX(MT_DEVICE_nGnRE)
>   #define PTE_WBWA		PTE_ATTRINDX(MT_NORMAL)
>   
>   static inline void flush_tlb_all(void)
> diff --git a/lib/arm64/asm/page.h b/lib/arm64/asm/page.h
> index ae4484b22114..d0fac6ea563d 100644
> --- a/lib/arm64/asm/page.h
> +++ b/lib/arm64/asm/page.h
> @@ -72,5 +72,7 @@ typedef struct { pteval_t pgprot; } pgprot_t;
>   extern phys_addr_t __virt_to_phys(unsigned long addr);
>   extern unsigned long __phys_to_virt(phys_addr_t addr);
>   
> +extern void *__ioremap(phys_addr_t phys_addr, size_t size);
> +
>   #endif /* !__ASSEMBLY__ */
>   #endif /* _ASMARM64_PAGE_H_ */
> 
