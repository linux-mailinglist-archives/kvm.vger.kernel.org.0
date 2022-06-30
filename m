Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C1D66561894
	for <lists+kvm@lfdr.de>; Thu, 30 Jun 2022 12:54:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233845AbiF3KyV (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 30 Jun 2022 06:54:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41436 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233793AbiF3KyU (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 30 Jun 2022 06:54:20 -0400
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 2F46139695
        for <kvm@vger.kernel.org>; Thu, 30 Jun 2022 03:54:19 -0700 (PDT)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 36E051063;
        Thu, 30 Jun 2022 03:54:19 -0700 (PDT)
Received: from monolith.localdoman (unknown [172.31.20.19])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id AC1BB3F5A1;
        Thu, 30 Jun 2022 03:54:17 -0700 (PDT)
Date:   Thu, 30 Jun 2022 11:54:47 +0100
From:   Alexandru Elisei <alexandru.elisei@arm.com>
To:     Nikos Nikoleris <nikos.nikoleris@arm.com>
Cc:     kvm@vger.kernel.org, andrew.jones@linux.dev, drjones@redhat.com,
        pbonzini@redhat.com, jade.alglave@arm.com, ricarkol@google.com
Subject: Re: [kvm-unit-tests PATCH v3 19/27] arm/arm64: Add a setup sequence
 for systems that boot through EFI
Message-ID: <Yr2A93BF+KIVjFqB@monolith.localdoman>
References: <20220630100324.3153655-1-nikos.nikoleris@arm.com>
 <20220630100324.3153655-20-nikos.nikoleris@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220630100324.3153655-20-nikos.nikoleris@arm.com>
X-Spam-Status: No, score=-6.9 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi,

I missed your reply [1] to my comment [2] regarding v2 of this patch, I'm
going to do my best to reply here. I'll try to copy your reply, I hope it
doesn't turn into something unreadable.

You mentioned the stack in your reply [1], that got me thinking. I guess I
have a question now, are you using the stack set by EFI or another stack
that you have control over? If you're using the EFI stack, then there
should be a set of properties for that stack that EFI guarantees. What are
those guarantees?

[1] https://lore.kernel.org/all/6c5a3ef7-3742-c4e9-5a94-c702a5b3ebca@arm.com/
[2] https://lore.kernel.org/all/Yn5dhgVGoZUgYGUi@monolith.localdoman/

On Thu, Jun 30, 2022 at 11:03:16AM +0100, Nikos Nikoleris wrote:
> This change implements an alternative setup sequence for the system
> when we are booting through EFI. The memory map is discovered through
> EFI boot services and devices through ACPI.
> 
> This change is based on a change initially proposed by
> Andrew Jones <drjones@redhat.com>
> 
> Signed-off-by: Nikos Nikoleris <nikos.nikoleris@arm.com>
> ---
>  lib/linux/efi.h     |   1 +
>  lib/arm/asm/setup.h |   2 +
>  lib/arm/setup.c     | 181 +++++++++++++++++++++++++++++++++++++++++++-
>  arm/cstart.S        |   1 +
>  arm/cstart64.S      |   1 +
>  5 files changed, 184 insertions(+), 2 deletions(-)
> 
> diff --git a/lib/linux/efi.h b/lib/linux/efi.h
> index 53748dd..89f9a9e 100644
> --- a/lib/linux/efi.h
> +++ b/lib/linux/efi.h
> @@ -63,6 +63,7 @@ typedef guid_t efi_guid_t;
>  	(c) & 0xff, ((c) >> 8) & 0xff, d } }
>  
>  #define ACPI_TABLE_GUID EFI_GUID(0xeb9d2d30, 0x2d88, 0x11d3, 0x9a, 0x16, 0x00, 0x90, 0x27, 0x3f, 0xc1, 0x4d)
> +#define ACPI_20_TABLE_GUID EFI_GUID(0x8868e871, 0xe4f1, 0x11d3,  0xbc, 0x22, 0x00, 0x80, 0xc7, 0x3c, 0x88, 0x81)
>  
>  #define LOADED_IMAGE_PROTOCOL_GUID EFI_GUID(0x5b1b31a1, 0x9562, 0x11d2,  0x8e, 0x3f, 0x00, 0xa0, 0xc9, 0x69, 0x72, 0x3b)
>  
> diff --git a/lib/arm/asm/setup.h b/lib/arm/asm/setup.h
> index 64cd379..c4cd485 100644
> --- a/lib/arm/asm/setup.h
> +++ b/lib/arm/asm/setup.h
> @@ -6,6 +6,7 @@
>   * This work is licensed under the terms of the GNU LGPL, version 2.
>   */
>  #include <libcflat.h>
> +#include <efi.h>
>  #include <asm/page.h>
>  #include <asm/pgtable-hwdef.h>
>  
> @@ -37,5 +38,6 @@ extern unsigned int mem_region_get_flags(phys_addr_t paddr);
>  #define SMP_CACHE_BYTES		L1_CACHE_BYTES
>  
>  void setup(const void *fdt, phys_addr_t freemem_start);
> +efi_status_t setup_efi(efi_bootinfo_t *efi_bootinfo);
>  
>  #endif /* _ASMARM_SETUP_H_ */
> diff --git a/lib/arm/setup.c b/lib/arm/setup.c
> index 13513d0..30d04d0 100644
> --- a/lib/arm/setup.c
> +++ b/lib/arm/setup.c
> @@ -34,7 +34,7 @@
>  #define NR_EXTRA_MEM_REGIONS	16
>  #define NR_INITIAL_MEM_REGIONS	(MAX_DT_MEM_REGIONS + NR_EXTRA_MEM_REGIONS)
>  
> -extern unsigned long _etext;
> +extern unsigned long _text, _etext, _data, _edata;
>  
>  char *initrd;
>  u32 initrd_size;
> @@ -44,7 +44,10 @@ int nr_cpus;
>  
>  static struct mem_region __initial_mem_regions[NR_INITIAL_MEM_REGIONS + 1];
>  struct mem_region *mem_regions = __initial_mem_regions;
> -phys_addr_t __phys_offset, __phys_end;
> +phys_addr_t __phys_offset = (phys_addr_t)-1, __phys_end = 0;
> +
> +extern void exceptions_init(void);
> +extern void asm_mmu_disable(void);
>  
>  int mpidr_to_cpu(uint64_t mpidr)
>  {
> @@ -272,3 +275,177 @@ void setup(const void *fdt, phys_addr_t freemem_start)
>  	if (!(auxinfo.flags & AUXINFO_MMU_OFF))
>  		setup_vm();
>  }
> +
> +#ifdef CONFIG_EFI
> +
> +#include <efi.h>
> +
> +static efi_status_t setup_rsdp(efi_bootinfo_t *efi_bootinfo)
> +{
> +	efi_status_t status;
> +	struct rsdp_descriptor *rsdp;
> +
> +	/*
> +	 * RSDP resides in an EFI_ACPI_RECLAIM_MEMORY region, which is not used
> +	 * by kvm-unit-tests arm64 memory allocator. So it is not necessary to
> +	 * copy the data structure to another memory region to prevent
> +	 * unintentional overwrite.
> +	 */
> +	status = efi_get_system_config_table(ACPI_20_TABLE_GUID, (void **)&rsdp);
> +	if (status != EFI_SUCCESS)
> +		return status;
> +
> +	set_efi_rsdp(rsdp);
> +
> +	return EFI_SUCCESS;
> +}
> +
> +static efi_status_t efi_mem_init(efi_bootinfo_t *efi_bootinfo)
> +{
> +	int i;
> +	unsigned long free_mem_pages = 0;
> +	unsigned long free_mem_start = 0;
> +	struct efi_boot_memmap *map = &(efi_bootinfo->mem_map);
> +	efi_memory_desc_t *buffer = *map->map;
> +	efi_memory_desc_t *d = NULL;
> +	phys_addr_t base, top;
> +	struct mem_region *r;
> +	uintptr_t text = (uintptr_t)&_text, etext = __ALIGN((uintptr_t)&_etext, 4096);
> +	uintptr_t data = (uintptr_t)&_data, edata = __ALIGN((uintptr_t)&_edata, 4096);
> +
> +	/*
> +	 * Record the largest free EFI_CONVENTIONAL_MEMORY region
> +	 * which will be used to set up the memory allocator, so that
> +	 * the memory allocator can work in the largest free
> +	 * continuous memory region.
> +	 */
> +	for (i = 0, r = &mem_regions[0]; i < *(map->map_size); i += *(map->desc_size), ++r) {
> +		d = (efi_memory_desc_t *)(&((u8 *)buffer)[i]);
> +
> +		r->start = d->phys_addr;
> +		r->end = d->phys_addr + d->num_pages * EFI_PAGE_SIZE;
> +
> +		switch (d->type) {
> +		case EFI_RESERVED_TYPE:
> +		case EFI_LOADER_DATA:
> +		case EFI_BOOT_SERVICES_CODE:
> +		case EFI_BOOT_SERVICES_DATA:
> +		case EFI_RUNTIME_SERVICES_CODE:
> +		case EFI_RUNTIME_SERVICES_DATA:
> +		case EFI_UNUSABLE_MEMORY:
> +		case EFI_ACPI_RECLAIM_MEMORY:
> +		case EFI_ACPI_MEMORY_NVS:
> +		case EFI_PAL_CODE:
> +			r->flags = MR_F_RESERVED;
> +			break;
> +		case EFI_MEMORY_MAPPED_IO:
> +		case EFI_MEMORY_MAPPED_IO_PORT_SPACE:
> +			r->flags = MR_F_IO;
> +			break;
> +		case EFI_LOADER_CODE:
> +			if (r->start <= text && r->end > text) {
> +				/* This is the unit test region. Flag the code separately. */
> +				phys_addr_t tmp = r->end;
> +
> +				assert(etext <= data);
> +				assert(edata <= r->end);
> +				r->flags = MR_F_CODE;
> +				r->end = data;
> +				++r;
> +				r->start = data;
> +				r->end = tmp;
> +			} else {
> +				r->flags = MR_F_RESERVED;
> +			}
> +			break;
> +		case EFI_CONVENTIONAL_MEMORY:
> +			if (free_mem_pages < d->num_pages) {
> +				free_mem_pages = d->num_pages;
> +				free_mem_start = d->phys_addr;
> +			}
> +			break;
> +		}
> +
> +		if (!(r->flags & MR_F_IO)) {
> +			if (r->start < __phys_offset)
> +				__phys_offset = r->start;
> +			if (r->end > __phys_end)
> +				__phys_end = r->end;
> +		}
> +	}
> +	__phys_end &= PHYS_MASK;
>
> I think, there is much more that we need to clean, we're still using the
> same stack, we've loaded the code with the MMU on and we're using some

The assembly routing to disable the MMU doesn't use the stack, so I'm not
really sure what you trying to say here. If you're worried that the region
described by __phys_offset and __phys_end doesn't include the stack, then
that means that mmu_disable() will never work for a test (it will not clean
+ invalidate the stack), and that should be definitely fixed.

> memory up until the point we got here. I don't think, it would be safe to
> clean only __phys_offset and __phys_end and move on. Unless what you're
> suggesting is to clean __phys_offset and __phys_end after we switch the MMU

The purpose of cleaning __phys_offset and __phys_end is to for the latest
values to be in memory. It doesn't matter if it's done with the MMU off or
on, as long as it's done after the last write to the variables, and before
they are loaded, obviously.

> off. But then I have two questions:
> * If the CPU can still speculatively load __phys_offset and __phys_end at
> least the invalidate operation is still questionable.

Like I've said above, the purpose of the clean (you don't need an
invalidate) is to make sure that the CPU loads the latest values from
memory when the MMU is off. It doesn't matter if the value is in the cache,
as the subsequent clean + invalidate sequence will invalidate it. Which
also does not matter since this is the last time kvm-unit-tests writes to
the variables (the invalidate is needed so the CPU sees the values written
with the MMU off instead of stale values in the cache).

> * If we switch off the MMU and then clean the cache, are we causing
> coherence issues by issuing the CMOs with different memory attributes
> (Device-nGnRnE vs Normal Write-back).

This is interesting, but I find it very vague. Would you care to elaborate
how that might happen? A specific scenario would be helpful here, I
believe.

> +	asm_mmu_disable();

Thanks,
Alex
