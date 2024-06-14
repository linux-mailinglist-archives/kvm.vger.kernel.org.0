Return-Path: <kvm+bounces-19661-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 0F31F9086D9
	for <lists+kvm@lfdr.de>; Fri, 14 Jun 2024 10:58:16 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id D9FD11C22BC4
	for <lists+kvm@lfdr.de>; Fri, 14 Jun 2024 08:58:14 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C344219149C;
	Fri, 14 Jun 2024 08:58:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="U4xUeQ3N"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.9])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BFCAF1836D7
	for <kvm@vger.kernel.org>; Fri, 14 Jun 2024 08:58:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.9
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718355490; cv=none; b=NYMsUFOVsf/Y5KHoaSlf3s/kzysUk/IGDx9KLbgu7e6c6kUgnpPt4dKenLo/duMaGDgUtGe9wHTSGagJiaONvuVEAq/4sHoduH3IT063ETHlrOsVIfF0CRmpKmPtwikfNfn7LIttCQ71Iu5aDfZNuA/dgDvEdEa4cEUIwacl/u4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718355490; c=relaxed/simple;
	bh=ZkPLu1HSLwVqyFvZ09LNN8JNPb4JfA5nMv9opMuXQrc=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=I/hucIj77MjH757qlzQk6Rzmfw8FwdmpYLgUS8tOOkUnkVZoE9/liwuF+aTSSGKsaOkReCZLlz11IFzLH2UB6iHwZH1ZIGsd894Mr/yhHVWN9txedy9IwBQvtiYPG8Fogn1C3ECyQq72jJj5bu6f1pJR2f6yNJ54jYD9tI9AaGs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=U4xUeQ3N; arc=none smtp.client-ip=192.198.163.9
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1718355488; x=1749891488;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=ZkPLu1HSLwVqyFvZ09LNN8JNPb4JfA5nMv9opMuXQrc=;
  b=U4xUeQ3N3SJhvnLc9bBa5sBdzFEueAyP6WLJE6lpiCT85udKt3ZA6a5R
   iXCI7Kzk+PL0m3gtwEdO9//Z5FhpBTBKFl8omEj0Y1BJr5APqB6KWOa6D
   P9gmJg2VEwNEzlqInvJaEg74Mykp9KZOPKYSxYcXu6nlO+PgojnD7bQob
   zAsFzkt8M5qGXdyK4ckmdx+PiGoy+WD6Q/WFUX1ZzKowvs41oDSKxeLP/
   WYCkKmudlJDCKWRpDFhs0uFJAmDh2I6hSNtAW0F810kalmHOXHc0PbdLY
   AOyNw4gfRetifAHJsV+5LWB+geyp0Ex/v8eWtPh/L/FQ0qDX/B6AGQvTF
   w==;
X-CSE-ConnectionGUID: 0EAu/CkxRGCPKMNQf/NDpg==
X-CSE-MsgGUID: If9vpEqSQ0CaMiQuHszHPw==
X-IronPort-AV: E=McAfee;i="6700,10204,11102"; a="25906236"
X-IronPort-AV: E=Sophos;i="6.08,237,1712646000"; 
   d="scan'208";a="25906236"
Received: from fmviesa009.fm.intel.com ([10.60.135.149])
  by fmvoesa103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Jun 2024 01:58:07 -0700
X-CSE-ConnectionGUID: Lu9ghrZNTEmZlzKrkO63zA==
X-CSE-MsgGUID: xiAXtWP7SMm0AuzF9KsU+w==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.08,237,1712646000"; 
   d="scan'208";a="40539531"
Received: from xiaoyaol-hp-g830.ccr.corp.intel.com (HELO [10.124.238.14]) ([10.124.238.14])
  by fmviesa009-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Jun 2024 01:58:04 -0700
Message-ID: <ce895ad3-7a84-4af1-8927-6e85f60ef4f6@intel.com>
Date: Fri, 14 Jun 2024 16:58:01 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 27/31] hw/i386/sev: Use guest_memfd for legacy ROMs
To: Pankaj Gupta <pankaj.gupta@amd.com>, qemu-devel@nongnu.org
Cc: brijesh.singh@amd.com, dovmurik@linux.ibm.com, armbru@redhat.com,
 michael.roth@amd.com, pbonzini@redhat.com, thomas.lendacky@amd.com,
 isaku.yamahata@intel.com, berrange@redhat.com, kvm@vger.kernel.org,
 anisinha@redhat.com
References: <20240530111643.1091816-1-pankaj.gupta@amd.com>
 <20240530111643.1091816-28-pankaj.gupta@amd.com>
Content-Language: en-US
From: Xiaoyao Li <xiaoyao.li@intel.com>
In-Reply-To: <20240530111643.1091816-28-pankaj.gupta@amd.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 5/30/2024 7:16 PM, Pankaj Gupta wrote:
> From: Michael Roth <michael.roth@amd.com>
> 
> Current SNP guest kernels will attempt to access these regions with
> with C-bit set, so guest_memfd is needed to handle that. Otherwise,
> kvm_convert_memory() will fail when the guest kernel tries to access it
> and QEMU attempts to call KVM_SET_MEMORY_ATTRIBUTES to set these ranges
> to private.
> 
> Whether guests should actually try to access ROM regions in this way (or
> need to deal with legacy ROM regions at all), is a separate issue to be
> addressed on kernel side, but current SNP guest kernels will exhibit
> this behavior and so this handling is needed to allow QEMU to continue
> running existing SNP guest kernels.
> 
> Signed-off-by: Michael Roth <michael.roth@amd.com>
> [pankaj: Added sev_snp_enabled() check]
> Signed-off-by: Pankaj Gupta <pankaj.gupta@amd.com>
> ---
>   hw/i386/pc.c       | 14 ++++++++++----
>   hw/i386/pc_sysfw.c | 13 ++++++++++---
>   2 files changed, 20 insertions(+), 7 deletions(-)
> 
> diff --git a/hw/i386/pc.c b/hw/i386/pc.c
> index 7b638da7aa..62c25ea1e9 100644
> --- a/hw/i386/pc.c
> +++ b/hw/i386/pc.c
> @@ -62,6 +62,7 @@
>   #include "hw/mem/memory-device.h"
>   #include "e820_memory_layout.h"
>   #include "trace.h"
> +#include "sev.h"
>   #include CONFIG_DEVICES
>   
>   #ifdef CONFIG_XEN_EMU
> @@ -1022,10 +1023,15 @@ void pc_memory_init(PCMachineState *pcms,
>       pc_system_firmware_init(pcms, rom_memory);
>   
>       option_rom_mr = g_malloc(sizeof(*option_rom_mr));
> -    memory_region_init_ram(option_rom_mr, NULL, "pc.rom", PC_ROM_SIZE,
> -                           &error_fatal);
> -    if (pcmc->pci_enabled) {
> -        memory_region_set_readonly(option_rom_mr, true);
> +    if (sev_snp_enabled()) {
> +        memory_region_init_ram_guest_memfd(option_rom_mr, NULL, "pc.rom",
> +                                           PC_ROM_SIZE, &error_fatal);
> +    } else {
> +        memory_region_init_ram(option_rom_mr, NULL, "pc.rom", PC_ROM_SIZE,
> +                               &error_fatal);
> +        if (pcmc->pci_enabled) {
> +            memory_region_set_readonly(option_rom_mr, true);
> +        }
>       }
>       memory_region_add_subregion_overlap(rom_memory,
>                                           PC_ROM_MIN_VGA,
> diff --git a/hw/i386/pc_sysfw.c b/hw/i386/pc_sysfw.c
> index 00464afcb4..def77a442d 100644
> --- a/hw/i386/pc_sysfw.c
> +++ b/hw/i386/pc_sysfw.c
> @@ -51,8 +51,13 @@ static void pc_isa_bios_init(MemoryRegion *isa_bios, MemoryRegion *rom_memory,
>   
>       /* map the last 128KB of the BIOS in ISA space */
>       isa_bios_size = MIN(flash_size, 128 * KiB);
> -    memory_region_init_ram(isa_bios, NULL, "isa-bios", isa_bios_size,
> -                           &error_fatal);
> +    if (sev_snp_enabled()) {
> +        memory_region_init_ram_guest_memfd(isa_bios, NULL, "isa-bios",
> +                                           isa_bios_size, &error_fatal);
> +    } else {
> +        memory_region_init_ram(isa_bios, NULL, "isa-bios", isa_bios_size,
> +                               &error_fatal);
> +    }
>       memory_region_add_subregion_overlap(rom_memory,
>                                           0x100000 - isa_bios_size,
>                                           isa_bios,
> @@ -65,7 +70,9 @@ static void pc_isa_bios_init(MemoryRegion *isa_bios, MemoryRegion *rom_memory,
>              ((uint8_t*)flash_ptr) + (flash_size - isa_bios_size),
>              isa_bios_size);
>   
> -    memory_region_set_readonly(isa_bios, true);
> +    if (!machine_require_guest_memfd(current_machine)) {
> +        memory_region_set_readonly(isa_bios, true);
> +    }

This patch takes different approach than next patch that this patch 
chooses to not set readonly when require guest memfd while next patch 
skips the whole isa_bios setup for -bios case. Why make different 
handling for the two cases?

More importantly, with commit a44ea3fa7f2a,
pcmc->isa_bios_alias is default true for all new machine after 9.0, then 
pc_isa_bios_init() would be hit even on plash case. It will call 
x86_isa_bios_init() in pc_system_flash_map().

So with -bios case, the call site is

   pc_system_firmware_init()
      -> x86_bios_rom_init()
	-> x86_isa_bios_init()

   because require_guest_memfd is true for snp, x86_isa_bios_init() is 
not called.

However, with pflash case, the call site is

   pc_system_firmware_init()
      -> pc_system_flash_map()
	 -> if (pcmc->isa_bios_alias) {
                 x86_isa_bios_init();
             } else {
                 pc_isa_bios_init();
             }

As I said above, pcmc->isa_bios_alias is true for machine after 9.0, so 
it will goes x86_isa_bios_init().

So please anyone explain to me why x86_isa_bios_init() is ok for pflash 
case but not for -bios case?

>   }
>   
>   static PFlashCFI01 *pc_pflash_create(PCMachineState *pcms,


