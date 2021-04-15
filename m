Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6A682360F57
	for <lists+kvm@lfdr.de>; Thu, 15 Apr 2021 17:48:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234037AbhDOPsc (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 15 Apr 2021 11:48:32 -0400
Received: from foss.arm.com ([217.140.110.172]:49686 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233330AbhDOPsb (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 15 Apr 2021 11:48:31 -0400
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 7CED1106F;
        Thu, 15 Apr 2021 08:48:08 -0700 (PDT)
Received: from [192.168.0.110] (unknown [172.31.20.19])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 978613FA35;
        Thu, 15 Apr 2021 08:48:07 -0700 (PDT)
Subject: Re: [PATCH kvm-unit-tests 5/8] arm/arm64: mmu: Remove memory layout
 assumptions
To:     Andrew Jones <drjones@redhat.com>, kvm@vger.kernel.org
Cc:     nikos.nikoleris@arm.com, andre.przywara@arm.com,
        eric.auger@redhat.com
References: <20210407185918.371983-1-drjones@redhat.com>
 <20210407185918.371983-6-drjones@redhat.com>
From:   Alexandru Elisei <alexandru.elisei@arm.com>
Message-ID: <b1e637b2-b926-18f3-16d3-e112d51acb8f@arm.com>
Date:   Thu, 15 Apr 2021 16:48:41 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.9.0
MIME-Version: 1.0
In-Reply-To: <20210407185918.371983-6-drjones@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Content-Language: en-US
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Drew,

On 4/7/21 7:59 PM, Andrew Jones wrote:
> Rather than making too many assumptions about the memory layout
> in mmu code, just set up the page tables per the memory regions
> (which means putting all the memory layout assumptions in setup).
> To ensure we get the right default flags set we need to split the
> primary region into two regions for code and data.
>
> We still only expect the primary regions to be present, but the
> next patch will remove that assumption too.

Nitpick, but we still make assumptions about the memory layout:

- In setup_mmu(), we limit the maximum linear address to 3GiB, but on arm64 we can
have memory starting well above that.

- In mem_init(), we still have the predefined I/O regions.

I don't know if this is a rebasing error or intentional. If it's intentional, I
think it should be mentioned in the commit message, if only to say they will be
removed in a later patch (like you do with the primary region).

>
> Signed-off-by: Andrew Jones <drjones@redhat.com>
> ---
>  lib/arm/asm/setup.h |  1 +
>  lib/arm/mmu.c       | 26 +++++++++++++++-----------
>  lib/arm/setup.c     | 22 ++++++++++++++--------
>  3 files changed, 30 insertions(+), 19 deletions(-)
>
> diff --git a/lib/arm/asm/setup.h b/lib/arm/asm/setup.h
> index c8afb2493f8d..210c14f818fb 100644
> --- a/lib/arm/asm/setup.h
> +++ b/lib/arm/asm/setup.h
> @@ -15,6 +15,7 @@ extern int nr_cpus;
>  
>  #define MR_F_PRIMARY		(1U << 0)
>  #define MR_F_IO			(1U << 1)
> +#define MR_F_CODE		(1U << 2)
>  #define MR_F_UNKNOWN		(1U << 31)
>  
>  struct mem_region {
> diff --git a/lib/arm/mmu.c b/lib/arm/mmu.c
> index a7b7ae51afe3..edd2b9da809b 100644
> --- a/lib/arm/mmu.c
> +++ b/lib/arm/mmu.c
> @@ -20,8 +20,6 @@
>  
>  #include <linux/compiler.h>
>  
> -extern unsigned long etext;
> -
>  #define MMU_MAX_PERSISTENT_MAPS 64
>  
>  struct mmu_persistent_map {
> @@ -208,7 +206,7 @@ void mmu_set_range_sect(pgd_t *pgtable, uintptr_t virt_offset,
>  
>  void *setup_mmu(phys_addr_t phys_end)
>  {
> -	uintptr_t code_end = (uintptr_t)&etext;
> +	struct mem_region *r;
>  
>  	/* 0G-1G = I/O, 1G-3G = identity, 3G-4G = vmalloc */
>  	if (phys_end > (3ul << 30))
> @@ -223,14 +221,20 @@ void *setup_mmu(phys_addr_t phys_end)
>  
>  	mmu_idmap = alloc_page();
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

This looks good.

>  
>  	mmu_set_persistent_maps(mmu_idmap);
>  
> diff --git a/lib/arm/setup.c b/lib/arm/setup.c
> index 9c16f6004e9f..9da5d24b0be9 100644
> --- a/lib/arm/setup.c
> +++ b/lib/arm/setup.c
> @@ -31,6 +31,7 @@
>  #define NR_INITIAL_MEM_REGIONS 16
>  
>  extern unsigned long stacktop;
> +extern unsigned long etext;
>  
>  struct timer_state __timer_state;
>  
> @@ -88,10 +89,12 @@ unsigned int mem_region_get_flags(phys_addr_t paddr)
>  
>  static void mem_init(phys_addr_t freemem_start)
>  {
> +	phys_addr_t code_end = (phys_addr_t)(unsigned long)&etext;
>  	struct dt_pbus_reg regs[NR_INITIAL_MEM_REGIONS];
> -	struct mem_region primary, mem = {
> +	struct mem_region mem = {
>  		.start = (phys_addr_t)-1,
>  	};
> +	struct mem_region *primary = NULL;
>  	phys_addr_t base, top;
>  	int nr_regs, nr_io = 0, i;
>  
> @@ -110,8 +113,6 @@ static void mem_init(phys_addr_t freemem_start)
>  	nr_regs = dt_get_memory_params(regs, NR_INITIAL_MEM_REGIONS - nr_io);
>  	assert(nr_regs > 0);
>  
> -	primary = (struct mem_region){ 0 };
> -
>  	for (i = 0; i < nr_regs; ++i) {
>  		struct mem_region *r = &mem_regions[nr_io + i];
>  
> @@ -123,7 +124,7 @@ static void mem_init(phys_addr_t freemem_start)
>  		 */
>  		if (freemem_start >= r->start && freemem_start < r->end) {
>  			r->flags |= MR_F_PRIMARY;

Here we mark mem_regions[nr_io + i] as primary...

> -			primary = *r;
> +			primary = r;
>  		}
>  
>  		/*
> @@ -135,13 +136,18 @@ static void mem_init(phys_addr_t freemem_start)
>  		if (r->end > mem.end)
>  			mem.end = r->end;
>  	}
> -	assert(primary.end != 0);
> +	assert(primary);
>  	assert(!(mem.start & ~PHYS_MASK) && !((mem.end - 1) & ~PHYS_MASK));
>  
> -	__phys_offset = primary.start;	/* PHYS_OFFSET */
> -	__phys_end = primary.end;	/* PHYS_END */
> +	__phys_offset = primary->start;	/* PHYS_OFFSET */
> +	__phys_end = primary->end;	/* PHYS_END */
> +
> +	/* Split the primary region into two regions; code and data */
> +	mem.start = code_end, mem.end = primary->end, mem.flags = MR_F_PRIMARY;

Here we mark mem as primary...

> +	mem_regions[nr_io + i] = mem;

And then we set mem_regions[nr_io + nr_regs] to mem, which I think means we can
end up with two primary memory regions. Am I missing something?

> +	primary->end = code_end, primary->flags |= MR_F_CODE;

Please consider splitting the assignments each on its own line, because it makes
the code so hard to read (and I assume really easy to miss if we ever change
something).

Thanks,

Alex

>  
> -	phys_alloc_init(freemem_start, primary.end - freemem_start);
> +	phys_alloc_init(freemem_start, __phys_end - freemem_start);
>  	phys_alloc_set_minimum_alignment(SMP_CACHE_BYTES);
>  
>  	phys_alloc_get_unused(&base, &top);
