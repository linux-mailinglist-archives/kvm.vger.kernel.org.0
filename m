Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9D06C361113
	for <lists+kvm@lfdr.de>; Thu, 15 Apr 2021 19:25:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234172AbhDOR0A (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 15 Apr 2021 13:26:00 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:46655 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231726AbhDOR0A (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 15 Apr 2021 13:26:00 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1618507536;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=S0lbMyTnBitO0HI1V5b3CK+mEchHgniJjtzbFTeS0zc=;
        b=J0iqVPLf8FTReS5nE+gxBlXP9N6GL+c2yiCfF7yuLHT0B0qcG86o77JUn+ujzuRl1IQ81K
        FnIbkPcgC2r9NZGzq3m7EquU4Dq0/xAxDa7mkWQmSGnD71Fqk73vjCsy/wfSB6rysTthw5
        X8ev2MXQV6aYM5ROv+0hXdvXkBD70+o=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-216-KuR2i-0INcOmPHUcUFXtSw-1; Thu, 15 Apr 2021 13:25:35 -0400
X-MC-Unique: KuR2i-0INcOmPHUcUFXtSw-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 1BD47107ACE3;
        Thu, 15 Apr 2021 17:25:34 +0000 (UTC)
Received: from kamzik.brq.redhat.com (unknown [10.40.192.57])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 71B8A2C01E;
        Thu, 15 Apr 2021 17:25:29 +0000 (UTC)
Date:   Thu, 15 Apr 2021 19:25:26 +0200
From:   Andrew Jones <drjones@redhat.com>
To:     Alexandru Elisei <alexandru.elisei@arm.com>
Cc:     kvm@vger.kernel.org, nikos.nikoleris@arm.com,
        andre.przywara@arm.com, eric.auger@redhat.com
Subject: Re: [PATCH kvm-unit-tests 6/8] arm/arm64: setup: Consolidate memory
 layout assumptions
Message-ID: <20210415172526.msfseu2qwwb4jquc@kamzik.brq.redhat.com>
References: <20210407185918.371983-1-drjones@redhat.com>
 <20210407185918.371983-7-drjones@redhat.com>
 <aab892dc-6ef9-cfb5-7057-88ef7c692bba@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aab892dc-6ef9-cfb5-7057-88ef7c692bba@arm.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Apr 15, 2021 at 05:59:19PM +0100, Alexandru Elisei wrote:
> Hi Drew,
> 
> On 4/7/21 7:59 PM, Andrew Jones wrote:
> > Keep as much memory layout assumptions as possible in init::start
> > and a single setup function. This prepares us for calling setup()
> > from different start functions which have been linked with different
> > linker scripts. To do this, stacktop is only referenced from
> > init::start, making freemem_start a parameter to setup(). We also
> > split mem_init() into three parts, one that populates the mem regions
> > per the DT, one that populates the mem regions per assumptions,
> > and one that does the mem init. The concept of a primary region
> > is dropped, but we add a sanity check for the absence of memory
> > holes, because we don't know how to deal with them yet.
> >
> > Signed-off-by: Andrew Jones <drjones@redhat.com>
> > ---
> >  arm/cstart.S        |   4 +-
> >  arm/cstart64.S      |   2 +
> >  arm/flat.lds        |  23 ++++++
> >  lib/arm/asm/setup.h |   8 +--
> >  lib/arm/mmu.c       |   2 -
> >  lib/arm/setup.c     | 165 ++++++++++++++++++++++++--------------------
> >  6 files changed, 123 insertions(+), 81 deletions(-)
> >
> > diff --git a/arm/cstart.S b/arm/cstart.S
> > index 731f841695ce..14444124c43f 100644
> > --- a/arm/cstart.S
> > +++ b/arm/cstart.S
> > @@ -80,7 +80,9 @@ start:
> >  
> >  	/* complete setup */
> >  	pop	{r0-r1}
> > -	bl	setup
> > +	mov	r1, #0
> 
> Doesn't that mean that for arm, the second argument to setup() will be 0 instead
> of stacktop?

The second argument is 64-bit, but we assume the upper 32 are zero.

> 
> > +	ldr	r2, =stacktop		@ r1,r2 is the base of free memory
> > +	bl	setup			@ r0 is the addr of the dtb
> >  
> >  	/* run the test */
> >  	ldr	r0, =__argc
> > diff --git a/arm/cstart64.S b/arm/cstart64.S
> > index add60a2b4e74..434723d4b45d 100644
> > --- a/arm/cstart64.S
> > +++ b/arm/cstart64.S
> > @@ -94,6 +94,8 @@ start:
> >  
> >  	/* complete setup */
> >  	mov	x0, x4				// restore the addr of the dtb
> > +	adrp	x1, stacktop
> > +	add	x1, x1, :lo12:stacktop		// x1 is the base of free memory
> 
> I think we already have stacktop in x5.

Oh yeah, ever since we added zero_range. I'll use it.

> 
> >  	bl	setup
> >  
> >  	/* run the test */
> > diff --git a/arm/flat.lds b/arm/flat.lds
> > index 6ed377c0eaa0..6fb459efb815 100644
> > --- a/arm/flat.lds
> > +++ b/arm/flat.lds
> > @@ -1,3 +1,26 @@
> > +/*
> > + * init::start will pass stacktop to setup() as the base of free memory.
> > + * setup() will then move the FDT and initrd to that base before calling
> > + * mem_init(). With those movements and this linker script, we'll end up
> > + * having the following memory layout:
> > + *
> > + *    +----------------------+   <-- top of physical memory
> > + *    |                      |
> > + *    ~                      ~
> > + *    |                      |
> > + *    +----------------------+   <-- top of initrd
> > + *    |                      |
> > + *    +----------------------+   <-- top of FDT
> > + *    |                      |
> > + *    +----------------------+   <-- top of cpu0's stack
> > + *    |                      |
> > + *    +----------------------+   <-- top of text/data/bss sections
> > + *    |                      |
> > + *    |                      |
> > + *    +----------------------+   <-- load address
> > + *    |                      |
> > + *    +----------------------+   <-- physical address 0x0
> > + */
> >  
> >  SECTIONS
> >  {
> > diff --git a/lib/arm/asm/setup.h b/lib/arm/asm/setup.h
> > index 210c14f818fb..f0e70b119fb0 100644
> > --- a/lib/arm/asm/setup.h
> > +++ b/lib/arm/asm/setup.h
> > @@ -13,9 +13,8 @@
> >  extern u64 cpus[NR_CPUS];	/* per-cpu IDs (MPIDRs) */
> >  extern int nr_cpus;
> >  
> > -#define MR_F_PRIMARY		(1U << 0)
> > -#define MR_F_IO			(1U << 1)
> > -#define MR_F_CODE		(1U << 2)
> > +#define MR_F_IO			(1U << 0)
> > +#define MR_F_CODE		(1U << 1)
> >  #define MR_F_UNKNOWN		(1U << 31)
> >  
> >  struct mem_region {
> > @@ -26,6 +25,7 @@ struct mem_region {
> >  extern struct mem_region *mem_regions;
> >  extern phys_addr_t __phys_offset, __phys_end;
> >  
> > +extern struct mem_region *mem_region_find(phys_addr_t paddr);
> >  extern unsigned int mem_region_get_flags(phys_addr_t paddr);
> >  
> >  #define PHYS_OFFSET		(__phys_offset)
> > @@ -35,6 +35,6 @@ extern unsigned int mem_region_get_flags(phys_addr_t paddr);
> >  #define L1_CACHE_BYTES		(1 << L1_CACHE_SHIFT)
> >  #define SMP_CACHE_BYTES		L1_CACHE_BYTES
> >  
> > -void setup(const void *fdt);
> > +void setup(const void *fdt, phys_addr_t freemem_start);
> >  
> >  #endif /* _ASMARM_SETUP_H_ */
> > diff --git a/lib/arm/mmu.c b/lib/arm/mmu.c
> > index edd2b9da809b..7cff22a12e86 100644
> > --- a/lib/arm/mmu.c
> > +++ b/lib/arm/mmu.c
> > @@ -225,12 +225,10 @@ void *setup_mmu(phys_addr_t phys_end)
> 
> What happens now with init_alloc_vpage? We don't make sure that 3-4GiB is not in
> the linear map, and from what I can tell when allocating using vmalloc_ops we can
> end up changing the VA->PA of an existing linear mapping. I think that can break
> code that is already using the VA.

Yup, that's what I was referring to in my reply to the last patch. We need
to deal with this 3-4G range issue, but for this series I may just make
the assumption more clear.

> 
> >  		if (r->flags & MR_F_IO) {
> >  			continue;
> >  		} else if (r->flags & MR_F_CODE) {
> > -			assert_msg(r->flags & MR_F_PRIMARY, "Unexpected code region");
> >  			/* armv8 requires code shared between EL1 and EL0 to be read-only */
> >  			mmu_set_range_ptes(mmu_idmap, r->start, r->start, r->end,
> >  					   __pgprot(PTE_WBWA | PTE_USER | PTE_RDONLY));
> >  		} else {
> > -			assert_msg(r->flags & MR_F_PRIMARY, "Unexpected data region");
> >  			mmu_set_range_ptes(mmu_idmap, r->start, r->start, r->end,
> >  					   __pgprot(PTE_WBWA | PTE_USER));
> >  		}
> > diff --git a/lib/arm/setup.c b/lib/arm/setup.c
> > index 9da5d24b0be9..5cda2d919d2b 100644
> > --- a/lib/arm/setup.c
> > +++ b/lib/arm/setup.c
> > @@ -28,9 +28,9 @@
> >  
> >  #include "io.h"
> >  
> > -#define NR_INITIAL_MEM_REGIONS 16
> > +#define MAX_DT_MEM_REGIONS	16
> > +#define NR_EXTRA_MEM_REGIONS	16
> >  
> > -extern unsigned long stacktop;
> >  extern unsigned long etext;
> >  
> >  struct timer_state __timer_state;
> > @@ -41,7 +41,7 @@ u32 initrd_size;
> >  u64 cpus[NR_CPUS] = { [0 ... NR_CPUS-1] = (u64)~0 };
> >  int nr_cpus;
> >  
> > -static struct mem_region __initial_mem_regions[NR_INITIAL_MEM_REGIONS + 1];
> > +static struct mem_region __initial_mem_regions[MAX_DT_MEM_REGIONS + NR_EXTRA_MEM_REGIONS];
> >  struct mem_region *mem_regions = __initial_mem_regions;
> >  phys_addr_t __phys_offset, __phys_end;
> >  
> > @@ -75,28 +75,62 @@ static void cpu_init(void)
> >  	set_cpu_online(0, true);
> >  }
> >  
> > -unsigned int mem_region_get_flags(phys_addr_t paddr)
> > +static int mem_regions_next_index(void)
> >  {
> >  	struct mem_region *r;
> > +	int n;
> >  
> > -	for (r = mem_regions; r->end; ++r) {
> > -		if (paddr >= r->start && paddr < r->end)
> > -			return r->flags;
> > +	for (r = mem_regions, n = 0; r->end; ++r, ++n)
> > +		;
> > +	return n;
> > +}
> > +
> > +static void mem_regions_get_dt_regions(void)
> > +{
> > +	struct dt_pbus_reg regs[MAX_DT_MEM_REGIONS];
> > +	int nr_regs, i, n;
> > +
> > +	nr_regs = dt_get_memory_params(regs, MAX_DT_MEM_REGIONS);
> > +	assert(nr_regs > 0);
> > +
> > +	n = mem_regions_next_index();
> > +
> > +	for (i = 0; i < nr_regs; ++i) {
> > +		struct mem_region *r = &mem_regions[n + i];
> > +		r->start = regs[i].addr;
> > +		r->end = regs[i].addr + regs[i].size;
> >  	}
> > +}
> > +
> > +struct mem_region *mem_region_find(phys_addr_t paddr)
> > +{
> > +	struct mem_region *r;
> > +
> > +	for (r = mem_regions; r->end; ++r)
> 
> I guess this relies on the fact that from the DT we cannot have more than
> MAX_DT_MEM_REGIONS, and from the assumed regions we have at most 5 (code + data +
> 3 I/O for arm64), but it looks a bit scary not checking for the bounds of a
> statically allocated array. Same assumption throughout all the functions that
> iterate through the array.

Oops, I accidentally dropped the '+ 1' in the array size that I used to
have. The '+ 1' ensures we always have a zero element at the end, allowing
r->end to always be a safe stop condition.

> 
> > +		if (paddr >= r->start && paddr < r->end)
> > +			return r;
> > +	return NULL;
> > +}
> >  
> > -	return MR_F_UNKNOWN;
> > +unsigned int mem_region_get_flags(phys_addr_t paddr)
> > +{
> > +	struct mem_region *r = mem_region_find(paddr);
> > +	return r ? r->flags : MR_F_UNKNOWN;
> >  }
> >  
> > -static void mem_init(phys_addr_t freemem_start)
> > +static void mem_regions_add_assumed(void)
> >  {
> >  	phys_addr_t code_end = (phys_addr_t)(unsigned long)&etext;
> > -	struct dt_pbus_reg regs[NR_INITIAL_MEM_REGIONS];
> > -	struct mem_region mem = {
> > -		.start = (phys_addr_t)-1,
> > -	};
> > -	struct mem_region *primary = NULL;
> > -	phys_addr_t base, top;
> > -	int nr_regs, nr_io = 0, i;
> > +	int n = mem_regions_next_index();
> > +	struct mem_region mem = {0}, *r;
> > +
> > +	r = mem_region_find(code_end - 1);
> > +	assert(r);
> > +
> > +	/* Split the region with the code into two regions; code and data */
> > +	mem.start = code_end, mem.end = r->end;
> > +	mem_regions[n++] = mem;
> > +	r->end = code_end, r->flags = MR_F_CODE;
> >  
> >  	/*
> >  	 * mach-virt I/O regions:
> > @@ -104,50 +138,47 @@ static void mem_init(phys_addr_t freemem_start)
> >  	 *   - 512M at 256G (arm64, arm uses highmem=off)
> >  	 *   - 512G at 512G (arm64, arm uses highmem=off)
> >  	 */
> > -	mem_regions[nr_io++] = (struct mem_region){ 0, (1ul << 30), MR_F_IO };
> > +	mem_regions[n++] = (struct mem_region){ 0, (1ul << 30), MR_F_IO };
> >  #ifdef __aarch64__
> > -	mem_regions[nr_io++] = (struct mem_region){ (1ul << 38), (1ul << 38) | (1ul << 29), MR_F_IO };
> > -	mem_regions[nr_io++] = (struct mem_region){ (1ul << 39), (1ul << 40), MR_F_IO };
> > +	mem_regions[n++] = (struct mem_region){ (1ul << 38), (1ul << 38) | (1ul << 29), MR_F_IO };
> > +	mem_regions[n++] = (struct mem_region){ (1ul << 39), (1ul << 40), MR_F_IO };
> >  #endif
> > +}
> >  
> > -	nr_regs = dt_get_memory_params(regs, NR_INITIAL_MEM_REGIONS - nr_io);
> > -	assert(nr_regs > 0);
> > -
> > -	for (i = 0; i < nr_regs; ++i) {
> > -		struct mem_region *r = &mem_regions[nr_io + i];
> > +static void mem_init(phys_addr_t freemem_start)
> > +{
> > +	phys_addr_t base, top;
> > +	struct mem_region *freemem, *r, mem = {
> > +		.start = (phys_addr_t)-1,
> > +	};
> >  
> > -		r->start = regs[i].addr;
> > -		r->end = regs[i].addr + regs[i].size;
> > +	freemem = mem_region_find(freemem_start);
> > +	assert(freemem && !(freemem->flags & (MR_F_IO | MR_F_CODE)));
> >  
> > -		/*
> > -		 * pick the region we're in for our primary region
> > -		 */
> > -		if (freemem_start >= r->start && freemem_start < r->end) {
> > -			r->flags |= MR_F_PRIMARY;
> > -			primary = r;
> > +	for (r = mem_regions; r->end; ++r) {
> > +		assert(!(r->start & ~PHYS_MASK) && !((r->end - 1) & ~PHYS_MASK));
> 
> I don't think kvm-unit-tests needs *all* available memory to be mapped in order to
> function correctly. As far as I can tell, setup_mmu() will map freemem->end as
> phys_end, so I think the assert is only needed for the freemem region, but I admit
> I'm a bit foggy when it comes to the memory allocators.
>

Nope, we don't need all the available memory and we don't need to care if
the memory we don't map doesn't fit within our assumptions. I'll change
the assert to only check about the region we plan to map.

Thanks,
drew

