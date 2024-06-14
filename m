Return-Path: <kvm+bounces-19658-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id C376C90865A
	for <lists+kvm@lfdr.de>; Fri, 14 Jun 2024 10:34:20 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id EA7AA1F239F4
	for <lists+kvm@lfdr.de>; Fri, 14 Jun 2024 08:34:19 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E21F3190062;
	Fri, 14 Jun 2024 08:34:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="IHcaqaQO"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.13])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DF1FE184135
	for <kvm@vger.kernel.org>; Fri, 14 Jun 2024 08:34:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.13
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718354053; cv=none; b=EEHZg3lgPNX6subxlZ/nVjPLa8W3whzAe8qUP3mWhCxScxgDTQDUr+sB1lRTypU4MVxLEYdCaX5vK2ItwCV6ypq8jNL8o6dUZft5+Fm1ISXoHbO/ZvT37xPQvqIQEqkrULElfgVFHwDCrQC1qs0IUWsR0HdWVetWPYFDUA4ckkI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718354053; c=relaxed/simple;
	bh=NC5NOlSne8d0qmG34/IP21rBACHo8yPr9eKqSZdP9mk=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=nk+CsU72BejeuObJ46sE79r3l11JGf9ejEKiZaf4AIuzps5l+nTKBVoFnTweW5g70g5AjoAgrsSGOEBI2BTeTkfJ4X0jR2oluZ6tpDDbpnSG801wDqQZRY9sNvfd8mZIQLLgycfyr6iEzIzAeSOJuQmFq94OZZGFGO1MEZjhvZA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=IHcaqaQO; arc=none smtp.client-ip=198.175.65.13
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1718354051; x=1749890051;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=NC5NOlSne8d0qmG34/IP21rBACHo8yPr9eKqSZdP9mk=;
  b=IHcaqaQOw3KmnX8T8/Ge22x+yFjIws92w1YjBNbmkauSk2J3cGUuRHWs
   xzPMNEfaXzWY/rE1mQT8iWH3yMZzL3exrctDcqWZ4VMNNNdTqjv0knXd3
   Rhb0aumFvEfDxFvnVOcq7Ka/yIqyskb/+XiGuI6e0SjiZUn9nyElwfjmx
   o3Mv6AIUZJr5Wo5vS7leF1GRSjJ3D934ySeikEOaZ6rSA5GU/CHJywL0X
   I4qdlmYDY/MXg7w37GR6gV+TtaASfFA1QuYVagSx+l/q+OZetwg5wQvQd
   /qRKaWtLiDZ70B3sTZ0JQLrldT4zG2dbfzO3t7R12HcJAicsZTPu9YVMj
   g==;
X-CSE-ConnectionGUID: eCvyCujMTqqCEjqQjGNWFg==
X-CSE-MsgGUID: AvSGnokMS7upIqUSTHvSnA==
X-IronPort-AV: E=McAfee;i="6700,10204,11102"; a="26347435"
X-IronPort-AV: E=Sophos;i="6.08,237,1712646000"; 
   d="scan'208";a="26347435"
Received: from orviesa005.jf.intel.com ([10.64.159.145])
  by orvoesa105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Jun 2024 01:34:10 -0700
X-CSE-ConnectionGUID: J62/y7vPS4CD01cPxopgww==
X-CSE-MsgGUID: Xo+hnqw9QCaM/x7I9GYzOQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.08,237,1712646000"; 
   d="scan'208";a="45389342"
Received: from xiaoyaol-hp-g830.ccr.corp.intel.com (HELO [10.124.238.14]) ([10.124.238.14])
  by orviesa005-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Jun 2024 01:34:07 -0700
Message-ID: <434b5332-a7fb-44e4-88f5-4ac93de9c09b@intel.com>
Date: Fri, 14 Jun 2024 16:34:03 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 28/31] hw/i386: Add support for loading BIOS using
 guest_memfd
To: Pankaj Gupta <pankaj.gupta@amd.com>, qemu-devel@nongnu.org
Cc: brijesh.singh@amd.com, dovmurik@linux.ibm.com, armbru@redhat.com,
 michael.roth@amd.com, pbonzini@redhat.com, thomas.lendacky@amd.com,
 isaku.yamahata@intel.com, berrange@redhat.com, kvm@vger.kernel.org,
 anisinha@redhat.com
References: <20240530111643.1091816-1-pankaj.gupta@amd.com>
 <20240530111643.1091816-29-pankaj.gupta@amd.com>
Content-Language: en-US
From: Xiaoyao Li <xiaoyao.li@intel.com>
In-Reply-To: <20240530111643.1091816-29-pankaj.gupta@amd.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 5/30/2024 7:16 PM, Pankaj Gupta wrote:
> From: Michael Roth <michael.roth@amd.com>
> 
> When guest_memfd is enabled, the BIOS is generally part of the initial
> encrypted guest image and will be accessed as private guest memory. Add
> the necessary changes to set up the associated RAM region with a
> guest_memfd backend to allow for this.
> 
> Current support centers around using -bios to load the BIOS data.
> Support for loading the BIOS via pflash requires additional enablement
> since those interfaces rely on the use of ROM memory regions which make
> use of the KVM_MEM_READONLY memslot flag, which is not supported for
> guest_memfd-backed memslots.
> 
> Signed-off-by: Michael Roth <michael.roth@amd.com>
> Signed-off-by: Pankaj Gupta <pankaj.gupta@amd.com>
> ---
>   hw/i386/x86-common.c | 22 ++++++++++++++++------
>   1 file changed, 16 insertions(+), 6 deletions(-)
> 
> diff --git a/hw/i386/x86-common.c b/hw/i386/x86-common.c
> index f41cb0a6a8..059de65f36 100644
> --- a/hw/i386/x86-common.c
> +++ b/hw/i386/x86-common.c
> @@ -999,10 +999,18 @@ void x86_bios_rom_init(X86MachineState *x86ms, const char *default_firmware,
>       }
>       if (bios_size <= 0 ||
>           (bios_size % 65536) != 0) {
> -        goto bios_error;
> +        if (!machine_require_guest_memfd(MACHINE(x86ms))) {
> +                g_warning("%s: Unaligned BIOS size %d", __func__, bios_size);
> +                goto bios_error;
> +        }
> +    }
> +    if (machine_require_guest_memfd(MACHINE(x86ms))) {
> +        memory_region_init_ram_guest_memfd(&x86ms->bios, NULL, "pc.bios",
> +                                           bios_size, &error_fatal);
> +    } else {
> +        memory_region_init_ram(&x86ms->bios, NULL, "pc.bios",
> +                               bios_size, &error_fatal);
>       }
> -    memory_region_init_ram(&x86ms->bios, NULL, "pc.bios", bios_size,
> -                           &error_fatal);
>       if (sev_enabled()) {
>           /*
>            * The concept of a "reset" simply doesn't exist for
> @@ -1023,9 +1031,11 @@ void x86_bios_rom_init(X86MachineState *x86ms, const char *default_firmware,
>       }
>       g_free(filename);
>   
> -    /* map the last 128KB of the BIOS in ISA space */
> -    x86_isa_bios_init(&x86ms->isa_bios, rom_memory, &x86ms->bios,
> -                      !isapc_ram_fw);
> +    if (!machine_require_guest_memfd(MACHINE(x86ms))) {
> +        /* map the last 128KB of the BIOS in ISA space */
> +        x86_isa_bios_init(&x86ms->isa_bios, rom_memory, &x86ms->bios,
> +                          !isapc_ram_fw);
> +    }

Could anyone explain to me why above change is related to this patch and 
why need it?

because inside x86_isa_bios_init(), the alias isa_bios is set to 
read_only while guest_memfd doesn't support readonly?

>       /* map all the bios at the top of memory */
>       memory_region_add_subregion(rom_memory,


