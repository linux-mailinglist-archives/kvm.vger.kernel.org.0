Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9905A35E15F
	for <lists+kvm@lfdr.de>; Tue, 13 Apr 2021 16:27:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232003AbhDMO1x (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 13 Apr 2021 10:27:53 -0400
Received: from foss.arm.com ([217.140.110.172]:43164 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231913AbhDMO1v (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 13 Apr 2021 10:27:51 -0400
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 2EF00106F;
        Tue, 13 Apr 2021 07:27:30 -0700 (PDT)
Received: from C02W217MHV2R.local (unknown [172.31.20.19])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 47A9F3F694;
        Tue, 13 Apr 2021 07:27:29 -0700 (PDT)
Subject: Re: [PATCH kvm-unit-tests 5/8] arm/arm64: mmu: Remove memory layout
 assumptions
To:     Andrew Jones <drjones@redhat.com>, kvm@vger.kernel.org
Cc:     alexandru.elisei@arm.com, andre.przywara@arm.com,
        eric.auger@redhat.com
References: <20210407185918.371983-1-drjones@redhat.com>
 <20210407185918.371983-6-drjones@redhat.com>
From:   Nikos Nikoleris <nikos.nikoleris@arm.com>
Message-ID: <ebdc8e4a-4983-a807-0913-cc91a2ae0b5f@arm.com>
Date:   Tue, 13 Apr 2021 15:27:27 +0100
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.9.1
MIME-Version: 1.0
In-Reply-To: <20210407185918.371983-6-drjones@redhat.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 07/04/2021 19:59, Andrew Jones wrote:
> Rather than making too many assumptions about the memory layout
> in mmu code, just set up the page tables per the memory regions
> (which means putting all the memory layout assumptions in setup).
> To ensure we get the right default flags set we need to split the
> primary region into two regions for code and data.
> 
> We still only expect the primary regions to be present, but the
> next patch will remove that assumption too.
> 
> Signed-off-by: Andrew Jones <drjones@redhat.com>

Looks good to me.

Reviewed-by: Nikos Nikoleris <nikos.nikoleris@arm.com>

> ---
>   lib/arm/asm/setup.h |  1 +
>   lib/arm/mmu.c       | 26 +++++++++++++++-----------
>   lib/arm/setup.c     | 22 ++++++++++++++--------
>   3 files changed, 30 insertions(+), 19 deletions(-)
> 
> diff --git a/lib/arm/asm/setup.h b/lib/arm/asm/setup.h
> index c8afb2493f8d..210c14f818fb 100644
> --- a/lib/arm/asm/setup.h
> +++ b/lib/arm/asm/setup.h
> @@ -15,6 +15,7 @@ extern int nr_cpus;
>   
>   #define MR_F_PRIMARY		(1U << 0)
>   #define MR_F_IO			(1U << 1)
> +#define MR_F_CODE		(1U << 2)
>   #define MR_F_UNKNOWN		(1U << 31)
>   
>   struct mem_region {
> diff --git a/lib/arm/mmu.c b/lib/arm/mmu.c
> index a7b7ae51afe3..edd2b9da809b 100644
> --- a/lib/arm/mmu.c
> +++ b/lib/arm/mmu.c
> @@ -20,8 +20,6 @@
>   
>   #include <linux/compiler.h>
>   
> -extern unsigned long etext;
> -
>   #define MMU_MAX_PERSISTENT_MAPS 64
>   
>   struct mmu_persistent_map {
> @@ -208,7 +206,7 @@ void mmu_set_range_sect(pgd_t *pgtable, uintptr_t virt_offset,
>   
>   void *setup_mmu(phys_addr_t phys_end)
>   {
> -	uintptr_t code_end = (uintptr_t)&etext;
> +	struct mem_region *r;
>   
>   	/* 0G-1G = I/O, 1G-3G = identity, 3G-4G = vmalloc */
>   	if (phys_end > (3ul << 30))
> @@ -223,14 +221,20 @@ void *setup_mmu(phys_addr_t phys_end)
>   
>   	mmu_idmap = alloc_page();
>   
> -	/* armv8 requires code shared between EL1 and EL0 to be read-only */
> -	mmu_set_range_ptes(mmu_idmap, PHYS_OFFSET,
> -		PHYS_OFFSET, code_end,
> -		__pgprot(PTE_WBWA | PTE_RDONLY | PTE_USER));
> -
> -	mmu_set_range_ptes(mmu_idmap, code_end,
> -		code_end, phys_end,
> -		__pgprot(PTE_WBWA | PTE_USER));
> +	for (r = mem_regions; r->end; ++r) {
> +		if (r->flags & MR_F_IO) {
> +			continue;
> +		} else if (r->flags & MR_F_CODE) {
> +			assert_msg(r->flags & MR_F_PRIMARY, "Unexpected code region");
> +			/* armv8 requires code shared between EL1 and EL0 to be read-only */
> +			mmu_set_range_ptes(mmu_idmap, r->start, r->start, r->end,
> +					   __pgprot(PTE_WBWA | PTE_USER | PTE_RDONLY));
> +		} else {
> +			assert_msg(r->flags & MR_F_PRIMARY, "Unexpected data region");
> +			mmu_set_range_ptes(mmu_idmap, r->start, r->start, r->end,
> +					   __pgprot(PTE_WBWA | PTE_USER));
> +		}
> +	}
>   
>   	mmu_set_persistent_maps(mmu_idmap);
>   
> diff --git a/lib/arm/setup.c b/lib/arm/setup.c
> index 9c16f6004e9f..9da5d24b0be9 100644
> --- a/lib/arm/setup.c
> +++ b/lib/arm/setup.c
> @@ -31,6 +31,7 @@
>   #define NR_INITIAL_MEM_REGIONS 16
>   
>   extern unsigned long stacktop;
> +extern unsigned long etext;
>   
>   struct timer_state __timer_state;
>   
> @@ -88,10 +89,12 @@ unsigned int mem_region_get_flags(phys_addr_t paddr)
>   
>   static void mem_init(phys_addr_t freemem_start)
>   {
> +	phys_addr_t code_end = (phys_addr_t)(unsigned long)&etext;
>   	struct dt_pbus_reg regs[NR_INITIAL_MEM_REGIONS];
> -	struct mem_region primary, mem = {
> +	struct mem_region mem = {
>   		.start = (phys_addr_t)-1,
>   	};
> +	struct mem_region *primary = NULL;
>   	phys_addr_t base, top;
>   	int nr_regs, nr_io = 0, i;
>   
> @@ -110,8 +113,6 @@ static void mem_init(phys_addr_t freemem_start)
>   	nr_regs = dt_get_memory_params(regs, NR_INITIAL_MEM_REGIONS - nr_io);
>   	assert(nr_regs > 0);
>   
> -	primary = (struct mem_region){ 0 };
> -
>   	for (i = 0; i < nr_regs; ++i) {
>   		struct mem_region *r = &mem_regions[nr_io + i];
>   
> @@ -123,7 +124,7 @@ static void mem_init(phys_addr_t freemem_start)
>   		 */
>   		if (freemem_start >= r->start && freemem_start < r->end) {
>   			r->flags |= MR_F_PRIMARY;
> -			primary = *r;
> +			primary = r;
>   		}
>   
>   		/*
> @@ -135,13 +136,18 @@ static void mem_init(phys_addr_t freemem_start)
>   		if (r->end > mem.end)
>   			mem.end = r->end;
>   	}
> -	assert(primary.end != 0);
> +	assert(primary);
>   	assert(!(mem.start & ~PHYS_MASK) && !((mem.end - 1) & ~PHYS_MASK));
>   
> -	__phys_offset = primary.start;	/* PHYS_OFFSET */
> -	__phys_end = primary.end;	/* PHYS_END */
> +	__phys_offset = primary->start;	/* PHYS_OFFSET */
> +	__phys_end = primary->end;	/* PHYS_END */
> +
> +	/* Split the primary region into two regions; code and data */
> +	mem.start = code_end, mem.end = primary->end, mem.flags = MR_F_PRIMARY;
> +	mem_regions[nr_io + i] = mem;
> +	primary->end = code_end, primary->flags |= MR_F_CODE;
>   
> -	phys_alloc_init(freemem_start, primary.end - freemem_start);
> +	phys_alloc_init(freemem_start, __phys_end - freemem_start);
>   	phys_alloc_set_minimum_alignment(SMP_CACHE_BYTES);
>   
>   	phys_alloc_get_unused(&base, &top);
> 
