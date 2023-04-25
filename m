Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 962316EDC1C
	for <lists+kvm@lfdr.de>; Tue, 25 Apr 2023 09:05:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233311AbjDYHFb (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 25 Apr 2023 03:05:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33402 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232831AbjDYHFa (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 25 Apr 2023 03:05:30 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BCAF44ED5
        for <kvm@vger.kernel.org>; Tue, 25 Apr 2023 00:04:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1682406269;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=3Jj9PPDyLT88z/p8GAdjV6v0ILpOudFMRm/AIIWQI+M=;
        b=BI1b2yVcTXRW4PgWumVqgQu3pZfwbZa05VzhbcBiP/Po38xKOX7kAqLftXkKCNRJXq2psI
        CIWK96wD+jZEU8AQXcK7GT8dgO69A0lbscCpH5u1dBV8AJIV4tQnEj8Yb7yO57DGwBkXRo
        K0bSk9Cspw6HEA5KqRV0ucH5mIMmThw=
Received: from mail-pl1-f200.google.com (mail-pl1-f200.google.com
 [209.85.214.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-317-O2ZYlbI5MJCWm24RBDfYvw-1; Tue, 25 Apr 2023 03:04:28 -0400
X-MC-Unique: O2ZYlbI5MJCWm24RBDfYvw-1
Received: by mail-pl1-f200.google.com with SMTP id d9443c01a7336-1a6a5debce1so3157465ad.0
        for <kvm@vger.kernel.org>; Tue, 25 Apr 2023 00:04:28 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1682406267; x=1684998267;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=3Jj9PPDyLT88z/p8GAdjV6v0ILpOudFMRm/AIIWQI+M=;
        b=hOY+klOG3259Ck6xg3YcluWXhDgg77PpELxi8OVSdNNplcXc3wVn7dk+7HfNtdsuyC
         KH7e4fXyJE6NjiYdmz6j/cQ98iewXzezcN8XS8mIaLhawWb553Zy/dljBCLqG7JwBkw0
         b9QUfB+tEavyFPXLnbLYHkmmERxH7LbdKAIOxIFFSKmh+1BRqOLqLedo4ta5Py9tJyWi
         M7l2Sp/Sp6mzpkHV6bfda78RwkUYTyiHT5inkfnEKVo5uH/0inLzg0R1zsAn+mZ//QU+
         YC5YruFoX8Jp7C6H87boAYGP5sykYONn+cVey+ZFJjhfrlAH7mkZXHOWhCiteZ4e0N9C
         pw7g==
X-Gm-Message-State: AAQBX9daZX6gXml/XjHmtQwzlgAeBbjTfGGXTxl/NPyLBMa5gF5Mjvdw
        7oIOc1NcgaGm0Zt/RE1KfW0bFIY8syGzMQrHpw7YXePkHhQedrckkN5z4k0QFESkmU6bcOeUVE1
        iVY2++S+ZM2Tc
X-Received: by 2002:a17:902:da88:b0:1a2:175a:6153 with SMTP id j8-20020a170902da8800b001a2175a6153mr20492408plx.1.1682406267271;
        Tue, 25 Apr 2023 00:04:27 -0700 (PDT)
X-Google-Smtp-Source: AKy350Y79SuNGLL7aRcdwSpMdbAHUS9mDNGERMeyKf4BmWDF+jqtctggsch6ej4GzOuTf/g+0PRgGw==
X-Received: by 2002:a17:902:da88:b0:1a2:175a:6153 with SMTP id j8-20020a170902da8800b001a2175a6153mr20492385plx.1.1682406266893;
        Tue, 25 Apr 2023 00:04:26 -0700 (PDT)
Received: from [10.66.61.39] ([43.228.180.230])
        by smtp.gmail.com with ESMTPSA id w1-20020a1709029a8100b001a66fd54dd4sm7551193plp.258.2023.04.25.00.04.24
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 25 Apr 2023 00:04:26 -0700 (PDT)
Message-ID: <cf161112-ba2c-0dfb-9bcd-ffd288f2ae0b@redhat.com>
Date:   Tue, 25 Apr 2023 15:04:22 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.8.0
Subject: Re: [PATCH v4 23/30] arm64: Add a setup sequence for systems that
 boot through EFI
Content-Language: en-US
To:     Nikos Nikoleris <nikos.nikoleris@arm.com>, kvm@vger.kernel.org,
        kvmarm@lists.linux.dev, andrew.jones@linux.dev
Cc:     pbonzini@redhat.com, alexandru.elisei@arm.com, ricarkol@google.com
References: <20230213101759.2577077-1-nikos.nikoleris@arm.com>
 <20230213101759.2577077-24-nikos.nikoleris@arm.com>
From:   Shaoqin Huang <shahuang@redhat.com>
In-Reply-To: <20230213101759.2577077-24-nikos.nikoleris@arm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-3.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Nikos,

For that DABT_EL1 error, I have some clues about how it happens. It's 
mainly because this patch includes a memory overflow. I will explain in 
the code body.

On 2/13/23 18:17, Nikos Nikoleris wrote:
> This change implements an alternative setup sequence for the system
> when we are booting through EFI. The memory map is discovered through
> EFI boot services and devices through ACPI.
> 
> This change is based on a change initially proposed by
> Andrew Jones <drjones@redhat.com>
> 
> Signed-off-by: Nikos Nikoleris <nikos.nikoleris@arm.com>
> ---
>   arm/cstart.S        |   1 +
>   arm/cstart64.S      |   1 +
>   lib/arm/asm/setup.h |   8 ++
>   lib/arm/setup.c     | 181 +++++++++++++++++++++++++++++++++++++++++++-
>   lib/linux/efi.h     |   1 +
>   5 files changed, 190 insertions(+), 2 deletions(-)
> 
> diff --git a/arm/cstart.S b/arm/cstart.S
> index 7036e67f..3dd71ed9 100644
> --- a/arm/cstart.S
> +++ b/arm/cstart.S
> @@ -242,6 +242,7 @@ asm_mmu_disable:
>    *
>    * Input r0 is the stack top, which is the exception stacks base
>    */
> +.globl exceptions_init
>   exceptions_init:
>   	mrc	p15, 0, r2, c1, c0, 0	@ read SCTLR
>   	bic	r2, #CR_V		@ SCTLR.V := 0
> diff --git a/arm/cstart64.S b/arm/cstart64.S
> index e4ab7d06..223c1092 100644
> --- a/arm/cstart64.S
> +++ b/arm/cstart64.S
> @@ -265,6 +265,7 @@ asm_mmu_disable:
>    * Vectors
>    */
>   
> +.globl exceptions_init
>   exceptions_init:
>   	adrp	x4, vector_table
>   	add	x4, x4, :lo12:vector_table
> diff --git a/lib/arm/asm/setup.h b/lib/arm/asm/setup.h
> index 64cd379b..06069116 100644
> --- a/lib/arm/asm/setup.h
> +++ b/lib/arm/asm/setup.h
> @@ -38,4 +38,12 @@ extern unsigned int mem_region_get_flags(phys_addr_t paddr);
>   
>   void setup(const void *fdt, phys_addr_t freemem_start);
>   
> +#ifdef CONFIG_EFI
> +
> +#include <efi.h>
> +
> +efi_status_t setup_efi(efi_bootinfo_t *efi_bootinfo);
> +
> +#endif
> +
>   #endif /* _ASMARM_SETUP_H_ */
> diff --git a/lib/arm/setup.c b/lib/arm/setup.c
> index 03a4098e..cab19b1e 100644
> --- a/lib/arm/setup.c
> +++ b/lib/arm/setup.c
> @@ -33,7 +33,7 @@
>   #define NR_EXTRA_MEM_REGIONS	16
>   #define NR_INITIAL_MEM_REGIONS	(MAX_DT_MEM_REGIONS + NR_EXTRA_MEM_REGIONS)
>   
> -extern unsigned long _etext;
> +extern unsigned long _text, _etext, _data, _edata;
>   
>   char *initrd;
>   u32 initrd_size;
> @@ -43,7 +43,10 @@ int nr_cpus;
>   
>   static struct mem_region __initial_mem_regions[NR_INITIAL_MEM_REGIONS + 1];
>   struct mem_region *mem_regions = __initial_mem_regions;
> -phys_addr_t __phys_offset, __phys_end;
> +phys_addr_t __phys_offset = (phys_addr_t)-1, __phys_end = 0;
> +
> +extern void exceptions_init(void);
> +extern void asm_mmu_disable(void);
>   
>   int mpidr_to_cpu(uint64_t mpidr)
>   {
> @@ -289,3 +292,177 @@ void setup(const void *fdt, phys_addr_t freemem_start)
>   	if (!(auxinfo.flags & AUXINFO_MMU_OFF))
>   		setup_vm();
>   }
> +
> +#ifdef CONFIG_EFI
> +
> +#include <efi.h>
> +
> +static efi_status_t setup_rsdp(efi_bootinfo_t *efi_bootinfo)
> +{
> +	efi_status_t status;
> +	struct acpi_table_rsdp *rsdp;
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

At here, we can see here use the mem_regions to record the 
efi_boot_memmap information, so we will iterate the efi_boot_memmap 
which has (*map->map_size)/(*map->desc_size) number of the structure. 
Obviously, here didn't check if the mem_regions is fulled, so when the 
efi_boot_memmap is bigger than the mem_regions, the memory overflow happens.

And when memory overflow happens, Coincidentally, the mmu_idmap is just 
follow the memory of the mem_regions, so this iteration will write to 
mmu_idmap memory, which cause the mmu_idmap not NULL, so when the first 
time the __ioremap being called, which the call trace is:

efi_main->
   setup_efi->
     io_init->
       uart0_init_acpi->
         ioremap->
	  __ioremap

	   if (mmu_enabled()) {
                    pgtable = current_thread_info()->pgtable;
            } else {
                    if (!mmu_idmap)
                            mmu_idmap = alloc_page();
                    pgtable = mmu_idmap;
            }

When it first arrive at here, the mmu_idmap should be NULL, and a new 
mmu_idmap will be allocated, but unfortunately, the mmu_idmap has been 
write to a value, so it is not NULL, so the dirty mmu_idmap will be used 
as a pgtable. Which cause the DABT_EL1 error when continue build the 
page table.

And the solution is very easy, just make the mem_regions bigger, for 
example:

static struct mem_region __initial_mem_regions[NR_INITIAL_MEM_REGIONS + 20];
struct mem_region *mem_regions = __initial_mem_regions;

After make it bigger, the DABT_EL1 error will not happen on my machine. 
Hope it works for you.

Thanks,
Shaoqin

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
> +	asm_mmu_disable();
> +
> +	if (free_mem_pages == 0)
> +		return EFI_OUT_OF_RESOURCES;
> +
> +	assert(sizeof(long) == 8 || free_mem_start < (3ul << 30));
> +
> +	phys_alloc_init(free_mem_start, free_mem_pages << EFI_PAGE_SHIFT);
> +	phys_alloc_set_minimum_alignment(SMP_CACHE_BYTES);
> +
> +	phys_alloc_get_unused(&base, &top);
> +	base = PAGE_ALIGN(base);
> +	top = top & PAGE_MASK;
> +	assert(sizeof(long) == 8 || !(base >> 32));
> +	if (sizeof(long) != 8 && (top >> 32) != 0)
> +		top = ((uint64_t)1 << 32);
> +	page_alloc_init_area(0, base >> PAGE_SHIFT, top >> PAGE_SHIFT);
> +	page_alloc_ops_enable();
> +
> +	return EFI_SUCCESS;
> +}
> +
> +efi_status_t setup_efi(efi_bootinfo_t *efi_bootinfo)
> +{
> +	efi_status_t status;
> +
> +	struct thread_info *ti = current_thread_info();
> +
> +	memset(ti, 0, sizeof(*ti));
> +
> +	exceptions_init();
> +
> +	status = efi_mem_init(efi_bootinfo);
> +	if (status != EFI_SUCCESS) {
> +		printf("Failed to initialize memory: ");
> +		switch (status) {
> +		case EFI_OUT_OF_RESOURCES:
> +			printf("No free memory region\n");
> +			break;
> +		default:
> +			printf("Unknown error\n");
> +			break;
> +		}
> +		return status;
> +	}
> +
> +	status = setup_rsdp(efi_bootinfo);
> +	if (status != EFI_SUCCESS) {
> +		printf("Cannot find RSDP in EFI system table\n");
> +		return status;
> +	}
> +
> +	psci_set_conduit();
> +	cpu_init();
> +	/* cpu_init must be called before thread_info_init */
> +	thread_info_init(current_thread_info(), 0);
> +	/* mem_init must be called before io_init */
> +	io_init();
> +
> +	timer_save_state();
> +	if (initrd) {
> +		/* environ is currently the only file in the initrd */
> +		char *env = malloc(initrd_size);
> +
> +		memcpy(env, initrd, initrd_size);
> +		setup_env(env, initrd_size);
> +	}
> +
> +	if (!(auxinfo.flags & AUXINFO_MMU_OFF))
> +		setup_vm();
> +
> +	return EFI_SUCCESS;
> +}
> +
> +#endif
> diff --git a/lib/linux/efi.h b/lib/linux/efi.h
> index 53748dd4..89f9a9e0 100644
> --- a/lib/linux/efi.h
> +++ b/lib/linux/efi.h
> @@ -63,6 +63,7 @@ typedef guid_t efi_guid_t;
>   	(c) & 0xff, ((c) >> 8) & 0xff, d } }
>   
>   #define ACPI_TABLE_GUID EFI_GUID(0xeb9d2d30, 0x2d88, 0x11d3, 0x9a, 0x16, 0x00, 0x90, 0x27, 0x3f, 0xc1, 0x4d)
> +#define ACPI_20_TABLE_GUID EFI_GUID(0x8868e871, 0xe4f1, 0x11d3,  0xbc, 0x22, 0x00, 0x80, 0xc7, 0x3c, 0x88, 0x81)
>   
>   #define LOADED_IMAGE_PROTOCOL_GUID EFI_GUID(0x5b1b31a1, 0x9562, 0x11d2,  0x8e, 0x3f, 0x00, 0xa0, 0xc9, 0x69, 0x72, 0x3b)
>   

-- 
Shaoqin

