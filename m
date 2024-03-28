Return-Path: <kvm+bounces-12919-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 337BC88F42B
	for <lists+kvm@lfdr.de>; Thu, 28 Mar 2024 01:47:58 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 568D51C333A2
	for <lists+kvm@lfdr.de>; Thu, 28 Mar 2024 00:47:57 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 44CC325776;
	Thu, 28 Mar 2024 00:45:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="fohkXO9Y"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.9])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 12FAD25601
	for <kvm@vger.kernel.org>; Thu, 28 Mar 2024 00:45:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.9
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711586711; cv=none; b=bUrd5svjWbgzZ7XUOFhD4pqZp5bfiwVKoWABt6GtNBntl3ZjMi56mqm/It+BBbKgoIjG+yophCQDN4tI3maXLp5n5+6sooSzIbpw8QtwrJLRq2iI23L4SpyMPIembmOopyVQBXRrMQHzLWozYikrJ8V9s0nnZi2CQWQdSOA0Kc4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711586711; c=relaxed/simple;
	bh=qMr1lni1QD7AcsTQhnj6Msn8Z5FbVcK5sLp+/58NNJ0=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=YJs3m8pXQfnII7ZL80mpfikjxeurNsoZG/nskeeiN+fY5fBLvSYowugGv3m+I11ThbfMu4GUsgk4xKpxlsIpraZsnb6go5eFOUK0tJRJ/uj8XpCyzxgJqFrd7nCWGOeeLDqRij7+PHCSaGZRQMTs88nm0EDgmNcOBXpWR16Hcuo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=fohkXO9Y; arc=none smtp.client-ip=198.175.65.9
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1711586709; x=1743122709;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=qMr1lni1QD7AcsTQhnj6Msn8Z5FbVcK5sLp+/58NNJ0=;
  b=fohkXO9YWKoP8oaG0EcfIhT/CSYJdKKVOILPzaNsVcjSk7M5OjsqrTn9
   GNF3F2XWqOO09p2+8khjsJ/pHbDSz9cy+MwOEc82KC4Sjq+iqVnPCNiUT
   inFW2layjE9YtdZ4hwWqeO8Q3GAW4+YgXLTBcLQOY2SgPUNV4h+fBfUSa
   RSiwbSvYhvhGV6pG1sZQ+ZWxNOAEY4BhwpPjY2j2BM88CjUHQT4jQYT9I
   l0pCq9/B453/R0BTsvlN1MOxn14bi2mCoaCgKNTCjh0RmTX0RJuM25qTq
   Fr3Otgm/SgR4IoYqehkWJjX917LbMur5XxCVX+9OW9l8zDmVS7Qb4CMlq
   g==;
X-CSE-ConnectionGUID: VXEmuAUQS6qPSFPumBVP/g==
X-CSE-MsgGUID: 6nKbEaeNTgil5aDAqSflnQ==
X-IronPort-AV: E=McAfee;i="6600,9927,11026"; a="29200853"
X-IronPort-AV: E=Sophos;i="6.07,160,1708416000"; 
   d="scan'208";a="29200853"
Received: from fmviesa001.fm.intel.com ([10.60.135.141])
  by orvoesa101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Mar 2024 17:45:08 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.07,160,1708416000"; 
   d="scan'208";a="47683047"
Received: from xiaoyaol-hp-g830.ccr.corp.intel.com (HELO [10.124.224.7]) ([10.124.224.7])
  by smtpauth.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Mar 2024 17:45:06 -0700
Message-ID: <61462f83-1406-48ea-8f1a-fae848ff1443@intel.com>
Date: Thu, 28 Mar 2024 08:45:03 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 48/49] hw/i386/sev: Use guest_memfd for legacy ROMs
To: Isaku Yamahata <isaku.yamahata@intel.com>,
 Michael Roth <michael.roth@amd.com>
Cc: qemu-devel@nongnu.org, kvm@vger.kernel.org,
 Tom Lendacky <thomas.lendacky@amd.com>, Paolo Bonzini <pbonzini@redhat.com>,
 =?UTF-8?Q?Daniel_P=2E_Berrang=C3=A9?= <berrange@redhat.com>,
 Markus Armbruster <armbru@redhat.com>, Pankaj Gupta <pankaj.gupta@amd.com>,
 Isaku Yamahata <isaku.yamahata@linux.intel.com>
References: <20240320083945.991426-1-michael.roth@amd.com>
 <20240320083945.991426-49-michael.roth@amd.com>
 <20240320181223.GG1994522@ls.amr.corp.intel.com>
Content-Language: en-US
From: Xiaoyao Li <xiaoyao.li@intel.com>
In-Reply-To: <20240320181223.GG1994522@ls.amr.corp.intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 3/21/2024 2:12 AM, Isaku Yamahata wrote:
> On Wed, Mar 20, 2024 at 03:39:44AM -0500,
> Michael Roth <michael.roth@amd.com> wrote:
> 
>> TODO: make this SNP-specific if TDX disables legacy ROMs in general
> 
> TDX disables pc.rom, not disable isa-bios. IIRC, TDX doesn't need pc pflash.

Not TDX doesn't need pc pflash, but TDX cannot support pflash.

Can SNP support the behavior of pflash? That what's got changed will be 
synced back to OVMF file?

> Xiaoyao can chime in.
> 
> Thanks,
> 
>>
>> Current SNP guest kernels will attempt to access these regions with
>> with C-bit set, so guest_memfd is needed to handle that. Otherwise,
>> kvm_convert_memory() will fail when the guest kernel tries to access it
>> and QEMU attempts to call KVM_SET_MEMORY_ATTRIBUTES to set these ranges
>> to private.
>>
>> Whether guests should actually try to access ROM regions in this way (or
>> need to deal with legacy ROM regions at all), is a separate issue to be
>> addressed on kernel side, but current SNP guest kernels will exhibit
>> this behavior and so this handling is needed to allow QEMU to continue
>> running existing SNP guest kernels.
>>
>> Signed-off-by: Michael Roth <michael.roth@amd.com>
>> ---
>>   hw/i386/pc.c       | 13 +++++++++----
>>   hw/i386/pc_sysfw.c | 13 ++++++++++---
>>   2 files changed, 19 insertions(+), 7 deletions(-)
>>
>> diff --git a/hw/i386/pc.c b/hw/i386/pc.c
>> index feb7a93083..5feaeb43ee 100644
>> --- a/hw/i386/pc.c
>> +++ b/hw/i386/pc.c
>> @@ -1011,10 +1011,15 @@ void pc_memory_init(PCMachineState *pcms,
>>       pc_system_firmware_init(pcms, rom_memory);
>>   
>>       option_rom_mr = g_malloc(sizeof(*option_rom_mr));
>> -    memory_region_init_ram(option_rom_mr, NULL, "pc.rom", PC_ROM_SIZE,
>> -                           &error_fatal);
>> -    if (pcmc->pci_enabled) {
>> -        memory_region_set_readonly(option_rom_mr, true);
>> +    if (machine_require_guest_memfd(machine)) {
>> +        memory_region_init_ram_guest_memfd(option_rom_mr, NULL, "pc.rom",
>> +                                           PC_ROM_SIZE, &error_fatal);
>> +    } else {
>> +        memory_region_init_ram(option_rom_mr, NULL, "pc.rom", PC_ROM_SIZE,
>> +                               &error_fatal);
>> +        if (pcmc->pci_enabled) {
>> +            memory_region_set_readonly(option_rom_mr, true);
>> +        }
>>       }
>>       memory_region_add_subregion_overlap(rom_memory,
>>                                           PC_ROM_MIN_VGA,
>> diff --git a/hw/i386/pc_sysfw.c b/hw/i386/pc_sysfw.c
>> index 9dbb3f7337..850f86edd4 100644
>> --- a/hw/i386/pc_sysfw.c
>> +++ b/hw/i386/pc_sysfw.c
>> @@ -54,8 +54,13 @@ static void pc_isa_bios_init(MemoryRegion *rom_memory,
>>       /* map the last 128KB of the BIOS in ISA space */
>>       isa_bios_size = MIN(flash_size, 128 * KiB);
>>       isa_bios = g_malloc(sizeof(*isa_bios));
>> -    memory_region_init_ram(isa_bios, NULL, "isa-bios", isa_bios_size,
>> -                           &error_fatal);
>> +    if (machine_require_guest_memfd(current_machine)) {
>> +        memory_region_init_ram_guest_memfd(isa_bios, NULL, "isa-bios",
>> +                                           isa_bios_size, &error_fatal);
>> +    } else {
>> +        memory_region_init_ram(isa_bios, NULL, "isa-bios", isa_bios_size,
>> +                               &error_fatal);
>> +    }
>>       memory_region_add_subregion_overlap(rom_memory,
>>                                           0x100000 - isa_bios_size,
>>                                           isa_bios,
>> @@ -68,7 +73,9 @@ static void pc_isa_bios_init(MemoryRegion *rom_memory,
>>              ((uint8_t*)flash_ptr) + (flash_size - isa_bios_size),
>>              isa_bios_size);
>>   
>> -    memory_region_set_readonly(isa_bios, true);
>> +    if (!machine_require_guest_memfd(current_machine)) {
>> +        memory_region_set_readonly(isa_bios, true);
>> +    }
>>   }
>>   
>>   static PFlashCFI01 *pc_pflash_create(PCMachineState *pcms,
>> -- 
>> 2.25.1
>>
>>
> 


