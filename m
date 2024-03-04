Return-Path: <kvm+bounces-10789-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 5050A86FE41
	for <lists+kvm@lfdr.de>; Mon,  4 Mar 2024 11:02:16 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id DB7CA1F22E56
	for <lists+kvm@lfdr.de>; Mon,  4 Mar 2024 10:02:15 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 581D622635;
	Mon,  4 Mar 2024 10:01:57 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0D6D5225A2
	for <kvm@vger.kernel.org>; Mon,  4 Mar 2024 10:01:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709546516; cv=none; b=Fo7FEsNaMB8X5i22ba3uyYeXEqCWeohAGGc5p9Q9WRMYaPZhctWtuv83tWH3gg5bONDjXhPbBjPw3qX5DvoEMqD/4OXyiGMyREiqVRChuC+DomNPbQLG/NQYvD80FRnC8nr/rjHqVzSyk64r+Cs+TF2CUr4myw/Uaziw7plA/6Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709546516; c=relaxed/simple;
	bh=nO/W4jh3XOG1Y2/4vz/5vcxaX2LuCxiH8Sp07kPHKRM=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=RqGkPaiH9GX6XLKvyVA8H+Ferv7i38OwjdClQAqCDvq4F+BR/k26DDQgIUeFMu9TJTdrWiaDIh6xfrXFH2pw71+OfxsMRWSQebu1bFnOV00MdUIXScMPFgdpIZ7E/x7NI0Xs4Xcqr+n7NMRklGWbH+lsQz+OP3qcisnfPybsnGc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 15FA31FB;
	Mon,  4 Mar 2024 02:02:30 -0800 (PST)
Received: from [192.168.5.30] (unknown [172.31.20.19])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 1DE643F738;
	Mon,  4 Mar 2024 02:01:52 -0800 (PST)
Message-ID: <cc7ed07d-d08f-4b0d-b642-bfaf4fbafdb1@arm.com>
Date: Mon, 4 Mar 2024 10:01:51 +0000
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [kvm-unit-tests PATCH v2 13/18] arm64: Simplify efi_mem_init
Content-Language: en-GB
To: Andrew Jones <andrew.jones@linux.dev>
Cc: kvm@vger.kernel.org, kvmarm@lists.linux.dev, alexandru.elisei@arm.com,
 eric.auger@redhat.com, shahuang@redhat.com, pbonzini@redhat.com,
 thuth@redhat.com
References: <20240227192109.487402-20-andrew.jones@linux.dev>
 <20240227192109.487402-33-andrew.jones@linux.dev>
 <3d0cb559-87dc-423f-9461-574e810fbdb2@arm.com>
 <20240304-9cc10a0c64d1723d3c203cf2@orel>
From: Nikos Nikoleris <nikos.nikoleris@arm.com>
In-Reply-To: <20240304-9cc10a0c64d1723d3c203cf2@orel>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 04/03/2024 09:55, Andrew Jones wrote:
> On Mon, Mar 04, 2024 at 08:10:40AM +0000, Nikos Nikoleris wrote:
>> On 27/02/2024 19:21, Andrew Jones wrote:
>>> Reduce the EFI mem_map loop to only setting flags and finding the
>>> largest free memory region. Then, apply memregions_split() for
>>> the code/data region split and do the rest of the things that
>>> used to be done in the EFI mem_map loop in a separate mem_region
>>> loop.
>>>
>>> Signed-off-by: Andrew Jones <andrew.jones@linux.dev>
>>
>> Reviewed-by: Nikos Nikoleris <nikos.nikoleris@arm.com>
> 
> Thanks. While skimming this patch now to remind myself about it for v3,
> I see the etext = ALIGN() below which I forgot to consider. We certainly
> need the end of the text section to be on a page boundary, but that
> doesn't seem to be the case right now. I think we need to add this
> change

I missed and it didn't manifest in any of the runs I did. However, it 
makes sense.

Thanks,

Nikos

> 
> diff --git a/arm/efi/elf_aarch64_efi.lds b/arm/efi/elf_aarch64_efi.lds
> index 836d98255d88..7a4192b77900 100644
> --- a/arm/efi/elf_aarch64_efi.lds
> +++ b/arm/efi/elf_aarch64_efi.lds
> @@ -13,6 +13,7 @@ SECTIONS
>       *(.rodata*)
>       . = ALIGN(16);
>     }
> +  . = ALIGN(4096);
>     _etext = .;
>     _text_size = . - _text;
>     .dynamic  : { *(.dynamic) }
> 
> Thanks,
> drew
> 
>>
>> Thanks,
>>
>> Nikos
>>
>>> ---
>>>    lib/arm/setup.c | 45 ++++++++++++++++++++-------------------------
>>>    1 file changed, 20 insertions(+), 25 deletions(-)
>>>
>>> diff --git a/lib/arm/setup.c b/lib/arm/setup.c
>>> index d0be4c437708..631597b343f1 100644
>>> --- a/lib/arm/setup.c
>>> +++ b/lib/arm/setup.c
>>> @@ -301,9 +301,7 @@ static efi_status_t efi_mem_init(efi_bootinfo_t *efi_bootinfo)
>>>    	struct efi_boot_memmap *map = &(efi_bootinfo->mem_map);
>>>    	efi_memory_desc_t *buffer = *map->map;
>>>    	efi_memory_desc_t *d = NULL;
>>> -	struct mem_region r;
>>> -	uintptr_t text = (uintptr_t)&_text, etext = ALIGN((uintptr_t)&_etext, 4096);
>>> -	uintptr_t data = (uintptr_t)&_data, edata = ALIGN((uintptr_t)&_edata, 4096);
>>> +	struct mem_region r, *code, *data;
>>>    	const void *fdt = efi_bootinfo->fdt;
>>>    	/*
>>> @@ -337,21 +335,7 @@ static efi_status_t efi_mem_init(efi_bootinfo_t *efi_bootinfo)
>>>    			r.flags = MR_F_IO;
>>>    			break;
>>>    		case EFI_LOADER_CODE:
>>> -			if (r.start <= text && r.end > text) {
>>> -				/* This is the unit test region. Flag the code separately. */
>>> -				phys_addr_t tmp = r.end;
>>> -
>>> -				assert(etext <= data);
>>> -				assert(edata <= r.end);
>>> -				r.flags = MR_F_CODE;
>>> -				r.end = data;
>>> -				memregions_add(&r);
>>> -				r.start = data;
>>> -				r.end = tmp;
>>> -				r.flags = 0;
>>> -			} else {
>>> -				r.flags = MR_F_RESERVED;
>>> -			}
>>> +			r.flags = MR_F_CODE;
>>>    			break;
>>>    		case EFI_CONVENTIONAL_MEMORY:
>>>    			if (free_mem_pages < d->num_pages) {
>>> @@ -361,15 +345,27 @@ static efi_status_t efi_mem_init(efi_bootinfo_t *efi_bootinfo)
>>>    			break;
>>>    		}
>>> -		if (!(r.flags & MR_F_IO)) {
>>> -			if (r.start < __phys_offset)
>>> -				__phys_offset = r.start;
>>> -			if (r.end > __phys_end)
>>> -				__phys_end = r.end;
>>> -		}
>>>    		memregions_add(&r);
>>>    	}
>>> +	memregions_split((unsigned long)&_etext, &code, &data);
>>> +	assert(code && (code->flags & MR_F_CODE));
>>> +	if (data)
>>> +		data->flags &= ~MR_F_CODE;
>>> +
>>> +	for (struct mem_region *m = mem_regions; m->end; ++m) {
>>> +		if (m != code && (m->flags & MR_F_CODE))
>>> +			m->flags = MR_F_RESERVED;
>>> +
>>> +		if (!(m->flags & MR_F_IO)) {
>>> +			if (m->start < __phys_offset)
>>> +				__phys_offset = m->start;
>>> +			if (m->end > __phys_end)
>>> +				__phys_end = m->end;
>>> +		}
>>> +	}
>>> +	__phys_end &= PHYS_MASK;
>>> +
>>>    	if (efi_bootinfo->fdt_valid) {
>>>    		unsigned long old_start = free_mem_start;
>>>    		void *freemem = (void *)free_mem_start;
>>> @@ -380,7 +376,6 @@ static efi_status_t efi_mem_init(efi_bootinfo_t *efi_bootinfo)
>>>    		free_mem_pages = (free_mem_start - old_start) >> EFI_PAGE_SHIFT;
>>>    	}
>>> -	__phys_end &= PHYS_MASK;
>>>    	asm_mmu_disable();
>>>    	if (free_mem_pages == 0)

