Return-Path: <kvm+bounces-12321-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 9CD1F881738
	for <lists+kvm@lfdr.de>; Wed, 20 Mar 2024 19:12:34 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 456B61F254A6
	for <lists+kvm@lfdr.de>; Wed, 20 Mar 2024 18:12:34 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1FF586AFB9;
	Wed, 20 Mar 2024 18:12:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="CZ3rkZ0A"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.15])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 693C3320B
	for <kvm@vger.kernel.org>; Wed, 20 Mar 2024 18:12:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.15
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710958347; cv=none; b=U1Yh61gPHgNfi8/HCME/miDxuYdk+P/xLgDMk0E1ybCOPaeyCWsZ4/VYyFI/wcpt0uUUhAlJT3sV8YYrMjlrN+ZMg2yZN0UYtLICojk7wvTguxMFjkk2Odmj3pxC8oNQRHg3y3ayVdjplvmVtiwMj6jaYhBn3f0s2m2ZHu6owZ8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710958347; c=relaxed/simple;
	bh=Vnbag9q3xQRvF0qzbjgLy7tYXm8Ph98PFJ3DvYqpeYA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=oAlFsJvFetl2AVxBWbSvc70rhubPqmfp4nTWdxc1GwE9GqAiIHEtRkZVhMlH3eYoIcwFRfJJSKOQceRYM4H2LFnmyYfhgkNO+xQyfNmZ/MpxoMGnXcFd9qvsljr+FuqZiARYXzJSXzBqFL5YtytA1ChPlGMQ3BJGtMLMfHMTovw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=CZ3rkZ0A; arc=none smtp.client-ip=198.175.65.15
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1710958345; x=1742494345;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=Vnbag9q3xQRvF0qzbjgLy7tYXm8Ph98PFJ3DvYqpeYA=;
  b=CZ3rkZ0AZWNfAecYmn27qM8faFTVIq+O7GfSr/0zl0bYYlPV3WBzBOfG
   FlYEWLeyT6A1tNaJ1QdwsADftMyOt5wQuzewkyFvr+gtRagsOIQPsmRvE
   FB7wuBBT06HaHcw7VSDt6NovpcuXQgz49XfhZ1CiOT8gRa96uVuvThbz2
   umbhC853+/645VuYm0hLpPgIF9SAO4L5soORSfMuhzs9yhLvOQMXDAdl7
   r8AaoS/s6srvnFmNhEZ3+KU1YU1loZ6jXVJhFWqHbxTqVKAX61x8gqpGh
   DyovV7OHcoruqOMEku/rc2+9CVd93WqMmIOt8ZuIljgr7E0hKDpG/xJ49
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,11019"; a="9697213"
X-IronPort-AV: E=Sophos;i="6.07,140,1708416000"; 
   d="scan'208";a="9697213"
Received: from orviesa010.jf.intel.com ([10.64.159.150])
  by orvoesa107.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Mar 2024 11:12:24 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.07,140,1708416000"; 
   d="scan'208";a="14142999"
Received: from ls.sc.intel.com (HELO localhost) ([172.25.112.31])
  by orviesa010-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Mar 2024 11:12:24 -0700
Date: Wed, 20 Mar 2024 11:12:23 -0700
From: Isaku Yamahata <isaku.yamahata@intel.com>
To: Michael Roth <michael.roth@amd.com>
Cc: qemu-devel@nongnu.org, kvm@vger.kernel.org,
	Tom Lendacky <thomas.lendacky@amd.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Daniel P =?utf-8?B?LiBCZXJyYW5nw6k=?= <berrange@redhat.com>,
	Markus Armbruster <armbru@redhat.com>,
	Pankaj Gupta <pankaj.gupta@amd.com>,
	Xiaoyao Li <xiaoyao.li@intel.com>,
	Isaku Yamahata <isaku.yamahata@linux.intel.com>,
	isaku.yamahata@intel.com
Subject: Re: [PATCH v3 48/49] hw/i386/sev: Use guest_memfd for legacy ROMs
Message-ID: <20240320181223.GG1994522@ls.amr.corp.intel.com>
References: <20240320083945.991426-1-michael.roth@amd.com>
 <20240320083945.991426-49-michael.roth@amd.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20240320083945.991426-49-michael.roth@amd.com>

On Wed, Mar 20, 2024 at 03:39:44AM -0500,
Michael Roth <michael.roth@amd.com> wrote:

> TODO: make this SNP-specific if TDX disables legacy ROMs in general

TDX disables pc.rom, not disable isa-bios. IIRC, TDX doesn't need pc pflash.
Xiaoyao can chime in.

Thanks,

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
> ---
>  hw/i386/pc.c       | 13 +++++++++----
>  hw/i386/pc_sysfw.c | 13 ++++++++++---
>  2 files changed, 19 insertions(+), 7 deletions(-)
> 
> diff --git a/hw/i386/pc.c b/hw/i386/pc.c
> index feb7a93083..5feaeb43ee 100644
> --- a/hw/i386/pc.c
> +++ b/hw/i386/pc.c
> @@ -1011,10 +1011,15 @@ void pc_memory_init(PCMachineState *pcms,
>      pc_system_firmware_init(pcms, rom_memory);
>  
>      option_rom_mr = g_malloc(sizeof(*option_rom_mr));
> -    memory_region_init_ram(option_rom_mr, NULL, "pc.rom", PC_ROM_SIZE,
> -                           &error_fatal);
> -    if (pcmc->pci_enabled) {
> -        memory_region_set_readonly(option_rom_mr, true);
> +    if (machine_require_guest_memfd(machine)) {
> +        memory_region_init_ram_guest_memfd(option_rom_mr, NULL, "pc.rom",
> +                                           PC_ROM_SIZE, &error_fatal);
> +    } else {
> +        memory_region_init_ram(option_rom_mr, NULL, "pc.rom", PC_ROM_SIZE,
> +                               &error_fatal);
> +        if (pcmc->pci_enabled) {
> +            memory_region_set_readonly(option_rom_mr, true);
> +        }
>      }
>      memory_region_add_subregion_overlap(rom_memory,
>                                          PC_ROM_MIN_VGA,
> diff --git a/hw/i386/pc_sysfw.c b/hw/i386/pc_sysfw.c
> index 9dbb3f7337..850f86edd4 100644
> --- a/hw/i386/pc_sysfw.c
> +++ b/hw/i386/pc_sysfw.c
> @@ -54,8 +54,13 @@ static void pc_isa_bios_init(MemoryRegion *rom_memory,
>      /* map the last 128KB of the BIOS in ISA space */
>      isa_bios_size = MIN(flash_size, 128 * KiB);
>      isa_bios = g_malloc(sizeof(*isa_bios));
> -    memory_region_init_ram(isa_bios, NULL, "isa-bios", isa_bios_size,
> -                           &error_fatal);
> +    if (machine_require_guest_memfd(current_machine)) {
> +        memory_region_init_ram_guest_memfd(isa_bios, NULL, "isa-bios",
> +                                           isa_bios_size, &error_fatal);
> +    } else {
> +        memory_region_init_ram(isa_bios, NULL, "isa-bios", isa_bios_size,
> +                               &error_fatal);
> +    }
>      memory_region_add_subregion_overlap(rom_memory,
>                                          0x100000 - isa_bios_size,
>                                          isa_bios,
> @@ -68,7 +73,9 @@ static void pc_isa_bios_init(MemoryRegion *rom_memory,
>             ((uint8_t*)flash_ptr) + (flash_size - isa_bios_size),
>             isa_bios_size);
>  
> -    memory_region_set_readonly(isa_bios, true);
> +    if (!machine_require_guest_memfd(current_machine)) {
> +        memory_region_set_readonly(isa_bios, true);
> +    }
>  }
>  
>  static PFlashCFI01 *pc_pflash_create(PCMachineState *pcms,
> -- 
> 2.25.1
> 
> 

-- 
Isaku Yamahata <isaku.yamahata@intel.com>

