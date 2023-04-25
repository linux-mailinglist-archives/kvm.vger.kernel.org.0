Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 63A706EE786
	for <lists+kvm@lfdr.de>; Tue, 25 Apr 2023 20:31:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234230AbjDYSbT (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 25 Apr 2023 14:31:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38218 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231337AbjDYSbS (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 25 Apr 2023 14:31:18 -0400
Received: from out-54.mta1.migadu.com (out-54.mta1.migadu.com [IPv6:2001:41d0:203:375::36])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 66177B463
        for <kvm@vger.kernel.org>; Tue, 25 Apr 2023 11:31:16 -0700 (PDT)
Date:   Tue, 25 Apr 2023 20:31:12 +0200
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1682447474;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=bGCouJwWz7IPVyz6KiYsgWM2eEjPWxZ4Fw/TQ+3nhuQ=;
        b=by354ZVsNW5s1cLPT11ZUwYQOq5mca4qFhZteelDRp20bAII6vF1rd+wDMAJ6R2Wr+EtW4
        szj3LbeBPeGvR89esYzcNR4PJdXXI8VoimZDDprEtt+uPppjJvxjLdESKf+0egKxlWjgIg
        VX8NlDo4Xayzq6AvPJNT1iwMjMBddDw=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From:   Andrew Jones <andrew.jones@linux.dev>
To:     Nikos Nikoleris <nikos.nikoleris@arm.com>
Cc:     Shaoqin Huang <shahuang@redhat.com>, kvm@vger.kernel.org,
        kvmarm@lists.linux.dev, pbonzini@redhat.com,
        alexandru.elisei@arm.com, ricarkol@google.com
Subject: Re: [PATCH v4 23/30] arm64: Add a setup sequence for systems that
 boot through EFI
Message-ID: <w42xq2sfwx64qvmca6b7niokvhzkri3rufilmhznms2hpauvk5@dj277vxepv5z>
References: <20230213101759.2577077-1-nikos.nikoleris@arm.com>
 <20230213101759.2577077-24-nikos.nikoleris@arm.com>
 <cf161112-ba2c-0dfb-9bcd-ffd288f2ae0b@redhat.com>
 <6e2e50a5-13a1-c783-12dc-692901e35aa5@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <6e2e50a5-13a1-c783-12dc-692901e35aa5@arm.com>
X-Migadu-Flow: FLOW_OUT
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Apr 25, 2023 at 10:09:51AM +0100, Nikos Nikoleris wrote:
> Hi Shaoqin,
> 
> On 25/04/2023 08:04, Shaoqin Huang wrote:
> > Hi Nikos,
> > 
> > For that DABT_EL1 error, I have some clues about how it happens. It's
> > mainly because this patch includes a memory overflow. I will explain in
> > the code body.
> > 
> 
> Many thanks for this. This is the 2nd time I get caught by this :(

Yes, thank you Shaoqin for getting to the bottom of this and reporting it!

> 
> > On 2/13/23 18:17, Nikos Nikoleris wrote:
> > > This change implements an alternative setup sequence for the system
> > > when we are booting through EFI. The memory map is discovered through
> > > EFI boot services and devices through ACPI.
> > > 
> > > This change is based on a change initially proposed by
> > > Andrew Jones <drjones@redhat.com>
> > > 
> > > Signed-off-by: Nikos Nikoleris <nikos.nikoleris@arm.com>
> > > ---
> > >    arm/cstart.S        |   1 +
> > >    arm/cstart64.S      |   1 +
> > >    lib/arm/asm/setup.h |   8 ++
> > >    lib/arm/setup.c     | 181 +++++++++++++++++++++++++++++++++++++++++++-
> > >    lib/linux/efi.h     |   1 +
> > >    5 files changed, 190 insertions(+), 2 deletions(-)
> > > 
> > > diff --git a/arm/cstart.S b/arm/cstart.S
> > > index 7036e67f..3dd71ed9 100644
> > > --- a/arm/cstart.S
> > > +++ b/arm/cstart.S
> > > @@ -242,6 +242,7 @@ asm_mmu_disable:
> > >     *
> > >     * Input r0 is the stack top, which is the exception stacks base
> > >     */
> > > +.globl exceptions_init
> > >    exceptions_init:
> > >    	mrc	p15, 0, r2, c1, c0, 0	@ read SCTLR
> > >    	bic	r2, #CR_V		@ SCTLR.V := 0
> > > diff --git a/arm/cstart64.S b/arm/cstart64.S
> > > index e4ab7d06..223c1092 100644
> > > --- a/arm/cstart64.S
> > > +++ b/arm/cstart64.S
> > > @@ -265,6 +265,7 @@ asm_mmu_disable:
> > >     * Vectors
> > >     */
> > > +.globl exceptions_init
> > >    exceptions_init:
> > >    	adrp	x4, vector_table
> > >    	add	x4, x4, :lo12:vector_table
> > > diff --git a/lib/arm/asm/setup.h b/lib/arm/asm/setup.h
> > > index 64cd379b..06069116 100644
> > > --- a/lib/arm/asm/setup.h
> > > +++ b/lib/arm/asm/setup.h
> > > @@ -38,4 +38,12 @@ extern unsigned int mem_region_get_flags(phys_addr_t paddr);
> > >    void setup(const void *fdt, phys_addr_t freemem_start);
> > > +#ifdef CONFIG_EFI
> > > +
> > > +#include <efi.h>
> > > +
> > > +efi_status_t setup_efi(efi_bootinfo_t *efi_bootinfo);
> > > +
> > > +#endif
> > > +
> > >    #endif /* _ASMARM_SETUP_H_ */
> > > diff --git a/lib/arm/setup.c b/lib/arm/setup.c
> > > index 03a4098e..cab19b1e 100644
> > > --- a/lib/arm/setup.c
> > > +++ b/lib/arm/setup.c
> > > @@ -33,7 +33,7 @@
> > >    #define NR_EXTRA_MEM_REGIONS	16
> > >    #define NR_INITIAL_MEM_REGIONS	(MAX_DT_MEM_REGIONS + NR_EXTRA_MEM_REGIONS)
> > > -extern unsigned long _etext;
> > > +extern unsigned long _text, _etext, _data, _edata;
> > >    char *initrd;
> > >    u32 initrd_size;
> > > @@ -43,7 +43,10 @@ int nr_cpus;
> > >    static struct mem_region __initial_mem_regions[NR_INITIAL_MEM_REGIONS + 1];
> > >    struct mem_region *mem_regions = __initial_mem_regions;
> > > -phys_addr_t __phys_offset, __phys_end;
> > > +phys_addr_t __phys_offset = (phys_addr_t)-1, __phys_end = 0;
> > > +
> > > +extern void exceptions_init(void);
> > > +extern void asm_mmu_disable(void);
> > >    int mpidr_to_cpu(uint64_t mpidr)
> > >    {
> > > @@ -289,3 +292,177 @@ void setup(const void *fdt, phys_addr_t freemem_start)
> > >    	if (!(auxinfo.flags & AUXINFO_MMU_OFF))
> > >    		setup_vm();
> > >    }
> > > +
> > > +#ifdef CONFIG_EFI
> > > +
> > > +#include <efi.h>
> > > +
> > > +static efi_status_t setup_rsdp(efi_bootinfo_t *efi_bootinfo)
> > > +{
> > > +	efi_status_t status;
> > > +	struct acpi_table_rsdp *rsdp;
> > > +
> > > +	/*
> > > +	 * RSDP resides in an EFI_ACPI_RECLAIM_MEMORY region, which is not used
> > > +	 * by kvm-unit-tests arm64 memory allocator. So it is not necessary to
> > > +	 * copy the data structure to another memory region to prevent
> > > +	 * unintentional overwrite.
> > > +	 */
> > > +	status = efi_get_system_config_table(ACPI_20_TABLE_GUID, (void **)&rsdp);
> > > +	if (status != EFI_SUCCESS)
> > > +		return status;
> > > +
> > > +	set_efi_rsdp(rsdp);
> > > +
> > > +	return EFI_SUCCESS;
> > > +}
> > > +
> > > +static efi_status_t efi_mem_init(efi_bootinfo_t *efi_bootinfo)
> > > +{
> > > +	int i;
> > > +	unsigned long free_mem_pages = 0;
> > > +	unsigned long free_mem_start = 0;
> > > +	struct efi_boot_memmap *map = &(efi_bootinfo->mem_map);
> > > +	efi_memory_desc_t *buffer = *map->map;
> > > +	efi_memory_desc_t *d = NULL;
> > > +	phys_addr_t base, top;
> > > +	struct mem_region *r;
> > > +	uintptr_t text = (uintptr_t)&_text, etext = __ALIGN((uintptr_t)&_etext, 4096);
> > > +	uintptr_t data = (uintptr_t)&_data, edata = __ALIGN((uintptr_t)&_edata, 4096);
> > > +
> > > +	/*
> > > +	 * Record the largest free EFI_CONVENTIONAL_MEMORY region
> > > +	 * which will be used to set up the memory allocator, so that
> > > +	 * the memory allocator can work in the largest free
> > > +	 * continuous memory region.
> > > +	 */
> > > +	for (i = 0, r = &mem_regions[0]; i < *(map->map_size); i += *(map->desc_size), ++r) {
> > 
> > At here, we can see here use the mem_regions to record the
> > efi_boot_memmap information, so we will iterate the efi_boot_memmap
> > which has (*map->map_size)/(*map->desc_size) number of the structure.
> > Obviously, here didn't check if the mem_regions is fulled, so when the
> > efi_boot_memmap is bigger than the mem_regions, the memory overflow happens.
> > 
> > And when memory overflow happens, Coincidentally, the mmu_idmap is just
> > follow the memory of the mem_regions, so this iteration will write to
> > mmu_idmap memory, which cause the mmu_idmap not NULL, so when the first
> > time the __ioremap being called, which the call trace is:
> > 
> > efi_main->
> >     setup_efi->
> >       io_init->
> >         uart0_init_acpi->
> >           ioremap->
> > 	  __ioremap
> > 
> > 	   if (mmu_enabled()) {
> >                      pgtable = current_thread_info()->pgtable;
> >              } else {
> >                      if (!mmu_idmap)
> >                              mmu_idmap = alloc_page();
> >                      pgtable = mmu_idmap;
> >              }
> > 
> > When it first arrive at here, the mmu_idmap should be NULL, and a new
> > mmu_idmap will be allocated, but unfortunately, the mmu_idmap has been
> > write to a value, so it is not NULL, so the dirty mmu_idmap will be used
> > as a pgtable. Which cause the DABT_EL1 error when continue build the
> > page table.
> > 
> > And the solution is very easy, just make the mem_regions bigger, for
> > example:
> > 
> > static struct mem_region __initial_mem_regions[NR_INITIAL_MEM_REGIONS + 20];
> > struct mem_region *mem_regions = __initial_mem_regions;
> > 
> > After make it bigger, the DABT_EL1 error will not happen on my machine.
> > Hope it works for you.
> > 
> 
> Indeed, I can confirm that this is the issue I run into. It would be nice if
> Drew can confirm as well. Just to be on the safe side in the v5 I will apply
> these changes.
> 
> Thanks,
> 
> Nikos

I gave the below patch a try and it appears to have resolved the issue.
I'll look forward to a refresh of the series which, fingers crossed,
will be finally merged!

Thanks,
drew

> 
> From a836dc91706cc9e9aee5ce6b8b659d74d98c7bd7 Mon Sep 17 00:00:00 2001
> From: Nikos Nikoleris <nikos.nikoleris@arm.com>
> Date: Wed, 3 Aug 2022 13:47:56 +0100
> Subject: [kvm-unit-tests PATCH] fixup! arm/arm64: Add a setup sequence for
> systems that boot through EFI
> X-ARM-No-Footer: FoSSMail
> 
> ---
>  lib/arm/setup.c | 45 ++++++++++++++++++++++++---------------------
>  1 file changed, 24 insertions(+), 21 deletions(-)
> 
> diff --git a/lib/arm/setup.c b/lib/arm/setup.c
> index cab19b1e..c4f495a9 100644
> --- a/lib/arm/setup.c
> +++ b/lib/arm/setup.c
> @@ -30,7 +30,7 @@
>  #include "io.h"
> 
>  #define MAX_DT_MEM_REGIONS	16
> -#define NR_EXTRA_MEM_REGIONS	16
> +#define NR_EXTRA_MEM_REGIONS	64
>  #define NR_INITIAL_MEM_REGIONS	(MAX_DT_MEM_REGIONS + NR_EXTRA_MEM_REGIONS)
> 
>  extern unsigned long _text, _etext, _data, _edata;
> @@ -326,7 +326,7 @@ static efi_status_t efi_mem_init(efi_bootinfo_t
> *efi_bootinfo)
>  	efi_memory_desc_t *buffer = *map->map;
>  	efi_memory_desc_t *d = NULL;
>  	phys_addr_t base, top;
> -	struct mem_region *r;
> +	struct mem_region r;
>  	uintptr_t text = (uintptr_t)&_text, etext = __ALIGN((uintptr_t)&_etext,
> 4096);
>  	uintptr_t data = (uintptr_t)&_data, edata = __ALIGN((uintptr_t)&_edata,
> 4096);
> 
> @@ -336,11 +336,12 @@ static efi_status_t efi_mem_init(efi_bootinfo_t
> *efi_bootinfo)
>  	 * the memory allocator can work in the largest free
>  	 * continuous memory region.
>  	 */
> -	for (i = 0, r = &mem_regions[0]; i < *(map->map_size); i +=
> *(map->desc_size), ++r) {
> +	for (i = 0; i < *(map->map_size); i += *(map->desc_size)) {
>  		d = (efi_memory_desc_t *)(&((u8 *)buffer)[i]);
> 
> -		r->start = d->phys_addr;
> -		r->end = d->phys_addr + d->num_pages * EFI_PAGE_SIZE;
> +		r.start = d->phys_addr;
> +		r.end = d->phys_addr + d->num_pages * EFI_PAGE_SIZE;
> +		r.flags = 0;
> 
>  		switch (d->type) {
>  		case EFI_RESERVED_TYPE:
> @@ -353,26 +354,27 @@ static efi_status_t efi_mem_init(efi_bootinfo_t
> *efi_bootinfo)
>  		case EFI_ACPI_RECLAIM_MEMORY:
>  		case EFI_ACPI_MEMORY_NVS:
>  		case EFI_PAL_CODE:
> -			r->flags = MR_F_RESERVED;
> +			r.flags = MR_F_RESERVED;
>  			break;
>  		case EFI_MEMORY_MAPPED_IO:
>  		case EFI_MEMORY_MAPPED_IO_PORT_SPACE:
> -			r->flags = MR_F_IO;
> +			r.flags = MR_F_IO;
>  			break;
>  		case EFI_LOADER_CODE:
> -			if (r->start <= text && r->end > text) {
> +			if (r.start <= text && r.end > text) {
>  				/* This is the unit test region. Flag the code separately. */
> -				phys_addr_t tmp = r->end;
> +				phys_addr_t tmp = r.end;
> 
>  				assert(etext <= data);
> -				assert(edata <= r->end);
> -				r->flags = MR_F_CODE;
> -				r->end = data;
> -				++r;
> -				r->start = data;
> -				r->end = tmp;
> +				assert(edata <= r.end);
> +				r.flags = MR_F_CODE;
> +				r.end = data;
> +				mem_region_add(&r);
> +				r.start = data;
> +				r.end = tmp;
> +				r.flags = 0;
>  			} else {
> -				r->flags = MR_F_RESERVED;
> +				r.flags = MR_F_RESERVED;
>  			}
>  			break;
>  		case EFI_CONVENTIONAL_MEMORY:
> @@ -383,12 +385,13 @@ static efi_status_t efi_mem_init(efi_bootinfo_t
> *efi_bootinfo)
>  			break;
>  		}
> 
> -		if (!(r->flags & MR_F_IO)) {
> -			if (r->start < __phys_offset)
> -				__phys_offset = r->start;
> -			if (r->end > __phys_end)
> -				__phys_end = r->end;
> +		if (!(r.flags & MR_F_IO)) {
> +			if (r.start < __phys_offset)
> +				__phys_offset = r.start;
> +			if (r.end > __phys_end)
> +				__phys_end = r.end;
>  		}
> +		mem_region_add(&r);
>  	}
>  	__phys_end &= PHYS_MASK;
>  	asm_mmu_disable();
> --
> 2.25.1
