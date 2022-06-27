Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D067955CB05
	for <lists+kvm@lfdr.de>; Tue, 28 Jun 2022 14:59:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239516AbiF0Qgc (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 27 Jun 2022 12:36:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35306 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234815AbiF0Qg3 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 27 Jun 2022 12:36:29 -0400
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id B0161DFC1
        for <kvm@vger.kernel.org>; Mon, 27 Jun 2022 09:36:28 -0700 (PDT)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id B4A6B1758;
        Mon, 27 Jun 2022 09:36:28 -0700 (PDT)
Received: from [10.57.40.121] (unknown [10.57.40.121])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 54F963F66F;
        Mon, 27 Jun 2022 09:36:27 -0700 (PDT)
Message-ID: <6c5a3ef7-3742-c4e9-5a94-c702a5b3ebca@arm.com>
Date:   Mon, 27 Jun 2022 17:36:25 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.10.0
Subject: Re: [kvm-unit-tests PATCH v2 16/23] arm/arm64: Add a setup sequence
 for systems that boot through EFI
Content-Language: en-GB
To:     Alexandru Elisei <alexandru.elisei@arm.com>
Cc:     kvm@vger.kernel.org, drjones@redhat.com, pbonzini@redhat.com,
        jade.alglave@arm.com
References: <20220506205605.359830-1-nikos.nikoleris@arm.com>
 <20220506205605.359830-17-nikos.nikoleris@arm.com>
 <Yn5dhgVGoZUgYGUi@monolith.localdoman>
From:   Nikos Nikoleris <nikos.nikoleris@arm.com>
In-Reply-To: <Yn5dhgVGoZUgYGUi@monolith.localdoman>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-6.9 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        RCVD_IN_DNSWL_HI,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Alex,

On 13/05/2022 14:31, Alexandru Elisei wrote:
> Hi,
> 
> On Fri, May 06, 2022 at 09:55:58PM +0100, Nikos Nikoleris wrote:
>> This change implements an alternative setup sequence for the system
>> when we are booting through EFI. The memory map is discovered through
>> EFI boot services and devices through ACPI.
>>
>> This change is based on a change initially proposed by
>> Andrew Jones <drjones@redhat.com>
>>
>> Signed-off-by: Nikos Nikoleris <nikos.nikoleris@arm.com>
>> ---
>>   lib/linux/efi.h     |   1 +
>>   lib/arm/asm/setup.h |   2 +
>>   lib/arm/setup.c     | 181 +++++++++++++++++++++++++++++++++++++++++++-
>>   arm/cstart.S        |   1 +
>>   arm/cstart64.S      |   1 +
>>   5 files changed, 184 insertions(+), 2 deletions(-)
>>
>> diff --git a/lib/linux/efi.h b/lib/linux/efi.h
>> index 594eaca..9b77c39 100644
>> --- a/lib/linux/efi.h
>> +++ b/lib/linux/efi.h
>> @@ -63,6 +63,7 @@ typedef guid_t efi_guid_t;
>>   	(c) & 0xff, ((c) >> 8) & 0xff, d } }
>>   
>>   #define ACPI_TABLE_GUID EFI_GUID(0xeb9d2d30, 0x2d88, 0x11d3, 0x9a, 0x16, 0x00, 0x90, 0x27, 0x3f, 0xc1, 0x4d)
>> +#define ACPI_20_TABLE_GUID EFI_GUID(0x8868e871, 0xe4f1, 0x11d3,  0xbc, 0x22, 0x00, 0x80, 0xc7, 0x3c, 0x88, 0x81)
>>   
>>   #define LOADED_IMAGE_PROTOCOL_GUID EFI_GUID(0x5b1b31a1, 0x9562, 0x11d2,  0x8e, 0x3f, 0x00, 0xa0, 0xc9, 0x69, 0x72, 0x3b)
>>   
>> diff --git a/lib/arm/asm/setup.h b/lib/arm/asm/setup.h
>> index 64cd379..1a7e734 100644
>> --- a/lib/arm/asm/setup.h
>> +++ b/lib/arm/asm/setup.h
>> @@ -5,6 +5,7 @@
>>    *
>>    * This work is licensed under the terms of the GNU LGPL, version 2.
>>    */
>> +#include <efi.h>
>>   #include <libcflat.h>
>>   #include <asm/page.h>
>>   #include <asm/pgtable-hwdef.h>
>> @@ -37,5 +38,6 @@ extern unsigned int mem_region_get_flags(phys_addr_t paddr);
>>   #define SMP_CACHE_BYTES		L1_CACHE_BYTES
>>   
>>   void setup(const void *fdt, phys_addr_t freemem_start);
>> +efi_status_t setup_efi(efi_bootinfo_t *efi_bootinfo);
>>   
>>   #endif /* _ASMARM_SETUP_H_ */
>> diff --git a/lib/arm/setup.c b/lib/arm/setup.c
>> index 2d67292..542e2ff 100644
>> --- a/lib/arm/setup.c
>> +++ b/lib/arm/setup.c
>> @@ -34,7 +34,7 @@
>>   #define NR_EXTRA_MEM_REGIONS	16
>>   #define NR_INITIAL_MEM_REGIONS	(MAX_DT_MEM_REGIONS + NR_EXTRA_MEM_REGIONS)
>>   
>> -extern unsigned long _etext;
>> +extern unsigned long _text, _etext, _data, _edata;
>>   
>>   char *initrd;
>>   u32 initrd_size;
>> @@ -44,7 +44,10 @@ int nr_cpus;
>>   
>>   static struct mem_region __initial_mem_regions[NR_INITIAL_MEM_REGIONS + 1];
>>   struct mem_region *mem_regions = __initial_mem_regions;
>> -phys_addr_t __phys_offset, __phys_end;
>> +phys_addr_t __phys_offset = (phys_addr_t)-1, __phys_end = 0;
>> +
>> +extern void exceptions_init(void);
>> +extern void asm_mmu_disable(void);
>>   
>>   int mpidr_to_cpu(uint64_t mpidr)
>>   {
>> @@ -272,3 +275,177 @@ void setup(const void *fdt, phys_addr_t freemem_start)
>>   	if (!(auxinfo.flags & AUXINFO_MMU_OFF))
>>   		setup_vm();
>>   }
>> +
>> +#ifdef CONFIG_EFI
>> +
>> +#include <efi.h>
>> +
>> +static efi_status_t setup_rsdp(efi_bootinfo_t *efi_bootinfo)
>> +{
>> +	efi_status_t status;
>> +	struct rsdp_descriptor *rsdp;
>> +
>> +	/*
>> +	 * RSDP resides in an EFI_ACPI_RECLAIM_MEMORY region, which is not used
>> +	 * by kvm-unit-tests arm64 memory allocator. So it is not necessary to
>> +	 * copy the data structure to another memory region to prevent
>> +	 * unintentional overwrite.
>> +	 */
>> +	status = efi_get_system_config_table(ACPI_20_TABLE_GUID, (void **)&rsdp);
>> +	if (status != EFI_SUCCESS)
>> +		return status;
>> +
>> +	set_efi_rsdp(rsdp);
>> +
>> +	return EFI_SUCCESS;
>> +}
>> +
>> +static efi_status_t efi_mem_init(efi_bootinfo_t *efi_bootinfo)
>> +{
>> +	int i;
>> +	unsigned long free_mem_pages = 0;
>> +	unsigned long free_mem_start = 0;
>> +	struct efi_boot_memmap *map = &(efi_bootinfo->mem_map);
>> +	efi_memory_desc_t *buffer = *map->map;
>> +	efi_memory_desc_t *d = NULL;
>> +	phys_addr_t base, top;
>> +	struct mem_region *r;
>> +	uintptr_t text = (uintptr_t)&_text, etext = __ALIGN((uintptr_t)&_etext, 4096);
>> +	uintptr_t data = (uintptr_t)&_data, edata = __ALIGN((uintptr_t)&_edata, 4096);
>> +
>> +	/*
>> +	 * Record the largest free EFI_CONVENTIONAL_MEMORY region
>> +	 * which will be used to set up the memory allocator, so that
>> +	 * the memory allocator can work in the largest free
>> +	 * continuous memory region.
>> +	 */
>> +	for (i = 0, r = &mem_regions[0]; i < *(map->map_size); i += *(map->desc_size), ++r) {
>> +		d = (efi_memory_desc_t *)(&((u8 *)buffer)[i]);
>> +
>> +		r->start = d->phys_addr;
>> +		r->end = d->phys_addr + d->num_pages * EFI_PAGE_SIZE;
>> +
>> +		switch (d->type) {
>> +		case EFI_RESERVED_TYPE:
>> +		case EFI_LOADER_DATA:
>> +		case EFI_BOOT_SERVICES_CODE:
>> +		case EFI_BOOT_SERVICES_DATA:
>> +		case EFI_RUNTIME_SERVICES_CODE:
>> +		case EFI_RUNTIME_SERVICES_DATA:
>> +		case EFI_UNUSABLE_MEMORY:
>> +		case EFI_ACPI_RECLAIM_MEMORY:
>> +		case EFI_ACPI_MEMORY_NVS:
>> +		case EFI_PAL_CODE:
>> +			r->flags = MR_F_RESERVED;
>> +			break;
>> +		case EFI_MEMORY_MAPPED_IO:
>> +		case EFI_MEMORY_MAPPED_IO_PORT_SPACE:
>> +			r->flags = MR_F_IO;
>> +			break;
>> +		case EFI_LOADER_CODE:
>> +			if (r->start <= text && r->end > text) {
>> +				/* This is the unit test region. Flag the code separately. */
>> +				phys_addr_t tmp = r->end;
>> +
>> +				assert(etext <= data);
>> +				assert(edata <= r->end);
>> +				r->flags = MR_F_CODE;
>> +				r->end = data;
>> +				++r;
>> +				r->start = data;
>> +				r->end = tmp;
>> +			} else {
>> +				r->flags = MR_F_RESERVED;
>> +			}
>> +			break;
>> +		case EFI_CONVENTIONAL_MEMORY:
>> +			if (free_mem_pages < d->num_pages) {
>> +				free_mem_pages = d->num_pages;
>> +				free_mem_start = d->phys_addr;
>> +			}
>> +			break;
>> +		}
>> +
>> +		if (!(r->flags & MR_F_IO)) {
>> +			if (r->start < __phys_offset)
>> +				__phys_offset = r->start;
>> +			if (r->end > __phys_end)
>> +				__phys_end = r->end;
>> +		}
>> +	}
>> +	__phys_end &= PHYS_MASK;
>> +	asm_mmu_disable();
> 
> And here's why moving the dcache clean + invalidate *before* turning the MMU off
> is fixing something: __phys_offset and __phys_end are written with MMU on and
> are still in the cache; when the CPU reads them with the MMU off it gets back
> stale values and the CMO doesn't execute correctly.
> 
> Doing a dcache clean for just those two variables should be enough and you can
> drop patch #12 ("arm/arm64: mmu_disable: Clean and invalidate before
> disabling").
> 

I think, there is much more that we need to clean, we're still using the 
same stack, we've loaded the code with the MMU on and we're using some 
memory up until the point we got here. I don't think, it would be safe 
to clean only __phys_offset and __phys_end and move on. Unless what 
you're suggesting is to clean __phys_offset and __phys_end after we 
switch the MMU off. But then I have two questions:
* If the CPU can still speculatively load __phys_offset and __phys_end 
at least the invalidate operation is still questionable.
* If we switch off the MMU and then clean the cache, are we causing 
coherence issues by issuing the CMOs with different memory attributes 
(Device-nGnRnE vs Normal Write-back).

Thanks,

Nikos
