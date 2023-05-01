Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7E16B6F3159
	for <lists+kvm@lfdr.de>; Mon,  1 May 2023 15:00:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232255AbjEANA0 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 1 May 2023 09:00:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48208 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230139AbjEANAZ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 1 May 2023 09:00:25 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AFBE3FD
        for <kvm@vger.kernel.org>; Mon,  1 May 2023 05:59:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1682945976;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=GlTIAVlYDvWGUgcAI69vPMhiBOoC9FH4wrN3XCSq6aw=;
        b=L8+Dc4Kn47uioflNZGvIrEmHPXfMsqG7U/4h+0Oof5HeoDISThK5/TQVZOSbKXukxeUhTk
        VCMelPMYf1S+Dtyk47SiCPkqJtPK8HYfFQ7kJrEhcW7YE+5qsiG3JZUQmeKMNqwjGKKUQE
        SfZ150jEzdN0m4MAugl3YiGcX8if3rY=
Received: from mail-pl1-f197.google.com (mail-pl1-f197.google.com
 [209.85.214.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-127-MXpm384UMJCToDsdNS0NkQ-1; Mon, 01 May 2023 08:59:35 -0400
X-MC-Unique: MXpm384UMJCToDsdNS0NkQ-1
Received: by mail-pl1-f197.google.com with SMTP id d9443c01a7336-1a687e3de0aso2746205ad.1
        for <kvm@vger.kernel.org>; Mon, 01 May 2023 05:59:35 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1682945974; x=1685537974;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=GlTIAVlYDvWGUgcAI69vPMhiBOoC9FH4wrN3XCSq6aw=;
        b=MwqY6+1jMeBIPS23OH/lGU8WjBuez8HDt0Y6xyvzkLyKst7DoeFtPdS5tfbK4t0I++
         KYmxsjrkS3WwLNvBtMCtr+Lj/WWTD7oQ5YWYMzJyZ+cn25GpUn6DE+uk0MIee+eldkKn
         1ev4b1DFxzkt/Mg7THYJP8vyAnx4t0aUF3nsN29UfOgHFWR02W4xU+Dc+0vp68/Ovxmm
         P6y8+xTbdKNpqv0Tn8C/NhI5AeJDuicouti6umwZkrTShMVcCjHdctAhBruoR4H3dFYX
         t5rMQ8WXTTdZQGBKx3/gcPpC7Ku7m4TY+crFl+QDfAe4+PB2zdBTTfnXm4U2Ob4IZdnt
         zg1A==
X-Gm-Message-State: AC+VfDy9XPjouTCbmTDRm10+eedjl9Kpwtg9baB7C6rExeinR9IXYtqi
        +BaUs3OlQ7z9q3DuV1e2StFo2Ho2mzTV842Qv1/rhpVMhwFbaVI7Ga+WbJB2ULqizR5RxM9IIgQ
        x/PSiiVSWOraf
X-Received: by 2002:a17:902:ea02:b0:1a9:83c8:f7f2 with SMTP id s2-20020a170902ea0200b001a983c8f7f2mr16897929plg.2.1682945974496;
        Mon, 01 May 2023 05:59:34 -0700 (PDT)
X-Google-Smtp-Source: ACHHUZ5Qz7Bmoywxk2GaR3M8fWqBoVGB8ZWZZPY6jTFmDn7kS21rp5U77lM0Pf0McMsew5yQcvMpbg==
X-Received: by 2002:a17:902:ea02:b0:1a9:83c8:f7f2 with SMTP id s2-20020a170902ea0200b001a983c8f7f2mr16897911plg.2.1682945974176;
        Mon, 01 May 2023 05:59:34 -0700 (PDT)
Received: from [10.66.61.39] ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id s2-20020a170902988200b001994fc55998sm17674219plp.217.2023.05.01.05.59.31
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 01 May 2023 05:59:33 -0700 (PDT)
Message-ID: <9476af3f-b61b-9134-8b6a-a255a07dcc82@redhat.com>
Date:   Mon, 1 May 2023 20:59:30 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.8.0
Subject: Re: [kvm-unit-tests PATCH v5 22/29] arm64: Add a setup sequence for
 systems that boot through EFI
Content-Language: en-US
To:     Nikos Nikoleris <nikos.nikoleris@arm.com>, kvm@vger.kernel.org,
        kvmarm@lists.linux.dev, andrew.jones@linux.dev
Cc:     pbonzini@redhat.com, alexandru.elisei@arm.com, ricarkol@google.com
References: <20230428120405.3770496-1-nikos.nikoleris@arm.com>
 <20230428120405.3770496-23-nikos.nikoleris@arm.com>
From:   Shaoqin Huang <shahuang@redhat.com>
In-Reply-To: <20230428120405.3770496-23-nikos.nikoleris@arm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-3.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 4/28/23 20:03, Nikos Nikoleris wrote:
> This change implements an alternative setup sequence for the system
> when we are booting through EFI. The memory map is discovered through
> EFI boot services and devices through ACPI.
> 
> This change is based on a change initially proposed by
> Andrew Jones <drjones@redhat.com>
> 
> Signed-off-by: Nikos Nikoleris <nikos.nikoleris@arm.com>
Reviewed-by: Shaoqin Huang <shahuang@redhat.com>
> ---
>   lib/linux/efi.h     |   1 +
>   lib/arm/asm/setup.h |   8 ++
>   lib/arm/setup.c     | 186 +++++++++++++++++++++++++++++++++++++++++++-
>   arm/cstart.S        |   1 +
>   arm/cstart64.S      |   1 +
>   5 files changed, 194 insertions(+), 3 deletions(-)
> 
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
> index 03a4098e..c4f495a9 100644
> --- a/lib/arm/setup.c
> +++ b/lib/arm/setup.c
> @@ -30,10 +30,10 @@
>   #include "io.h"
>   
>   #define MAX_DT_MEM_REGIONS	16
> -#define NR_EXTRA_MEM_REGIONS	16
> +#define NR_EXTRA_MEM_REGIONS	64
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
> @@ -289,3 +292,180 @@ void setup(const void *fdt, phys_addr_t freemem_start)
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
> +	struct mem_region r;
> +	uintptr_t text = (uintptr_t)&_text, etext = __ALIGN((uintptr_t)&_etext, 4096);
> +	uintptr_t data = (uintptr_t)&_data, edata = __ALIGN((uintptr_t)&_edata, 4096);
> +
> +	/*
> +	 * Record the largest free EFI_CONVENTIONAL_MEMORY region
> +	 * which will be used to set up the memory allocator, so that
> +	 * the memory allocator can work in the largest free
> +	 * continuous memory region.
> +	 */
> +	for (i = 0; i < *(map->map_size); i += *(map->desc_size)) {
> +		d = (efi_memory_desc_t *)(&((u8 *)buffer)[i]);
> +
> +		r.start = d->phys_addr;
> +		r.end = d->phys_addr + d->num_pages * EFI_PAGE_SIZE;
> +		r.flags = 0;
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
> +			r.flags = MR_F_RESERVED;
> +			break;
> +		case EFI_MEMORY_MAPPED_IO:
> +		case EFI_MEMORY_MAPPED_IO_PORT_SPACE:
> +			r.flags = MR_F_IO;
> +			break;
> +		case EFI_LOADER_CODE:
> +			if (r.start <= text && r.end > text) {
> +				/* This is the unit test region. Flag the code separately. */
> +				phys_addr_t tmp = r.end;
> +
> +				assert(etext <= data);
> +				assert(edata <= r.end);
> +				r.flags = MR_F_CODE;
> +				r.end = data;
> +				mem_region_add(&r);
> +				r.start = data;
> +				r.end = tmp;
> +				r.flags = 0;
> +			} else {
> +				r.flags = MR_F_RESERVED;
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
> +		if (!(r.flags & MR_F_IO)) {
> +			if (r.start < __phys_offset)
> +				__phys_offset = r.start;
> +			if (r.end > __phys_end)
> +				__phys_end = r.end;
> +		}
> +		mem_region_add(&r);
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

-- 
Shaoqin

