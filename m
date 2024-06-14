Return-Path: <kvm+bounces-19662-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 664709086F5
	for <lists+kvm@lfdr.de>; Fri, 14 Jun 2024 11:03:42 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id A56F4B24348
	for <lists+kvm@lfdr.de>; Fri, 14 Jun 2024 09:03:39 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 12DCA1922E3;
	Fri, 14 Jun 2024 09:03:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="ZkIoApEr"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 748981922C1
	for <kvm@vger.kernel.org>; Fri, 14 Jun 2024 09:03:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718355804; cv=none; b=pp060Z/+ktPSSSQWMLJKVJ04Mm3iit3AV6N2xoF/0yHs4w3Kp+jj/TWpLLGfSSA4nHbM5zjarma2iPMZEGUDV+JH8VEOQFHQj9ZlD1RMXCT30/fUslEqWkHaYOiYrHyX8DRia7A2uEkpvdorAEMTOyRo+VdDatQ6+tjoEOWvpY4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718355804; c=relaxed/simple;
	bh=VDNWhaDKx5gMUEdZYrQPKyGNrbmaYJH4PQGXvCrweFo=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=GVvjYajOQk+Bs6WMpmTlmXYO4bxn0F4By67+q9bq/eMd40qDasPqK0/O72PkxEyNODLb0TplwjYT4gy5Y9b01nvPBdl3FijOMnBI0MEsOS/7qbLXuSuzGCDkc8lEJZlDVITmfpzCL6vSvvClJYlZSMTFtS1yyssJII5yKoH425A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=ZkIoApEr; arc=none smtp.client-ip=198.175.65.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1718355803; x=1749891803;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=VDNWhaDKx5gMUEdZYrQPKyGNrbmaYJH4PQGXvCrweFo=;
  b=ZkIoApErqMPru51D6avazy79TjkJCLrjhtvwx0sXTqToWpwf40Zs+KjO
   ZvFDopTNu6YSE6sNvviOOpcwZphU17BkcgLPgjK0mJF+o3aBv+/HTVWST
   e5SwdLfaMRlVeLgaGuDvYuazN5PZSXkVKTbTKQ9zhffEDKZLt8qCLct65
   dp/nKZJactMTnYlnTfIY0gVkuXNp2GzgkVWBYzvJZBdGbYBY3vXcRobQz
   D0nXcpHnilQvX5+NE18DZCl8uXlEVkOpf7ttYKYKT+YQIiLVt1bzgrtto
   kJ/mOvCjPkUxBcXEVTBp5QRiEXzzjGd1UdqMh2Tga4vQQhC9UfpHSrk9x
   A==;
X-CSE-ConnectionGUID: GoN1snczQ0W1w25Mwbo4jQ==
X-CSE-MsgGUID: OLv3uFnASVufSKnlNLCQ1Q==
X-IronPort-AV: E=McAfee;i="6700,10204,11102"; a="15382478"
X-IronPort-AV: E=Sophos;i="6.08,237,1712646000"; 
   d="scan'208";a="15382478"
Received: from fmviesa006.fm.intel.com ([10.60.135.146])
  by orvoesa110.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Jun 2024 02:03:22 -0700
X-CSE-ConnectionGUID: 77tP1a3bS1i3DHMlF3uVDw==
X-CSE-MsgGUID: zukt3YxBQd2vKIk5rCH0hg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.08,237,1712646000"; 
   d="scan'208";a="40329521"
Received: from xiaoyaol-hp-g830.ccr.corp.intel.com (HELO [10.124.238.14]) ([10.124.238.14])
  by fmviesa006-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Jun 2024 02:03:16 -0700
Message-ID: <49c9f19c-9b2b-44c8-91f3-67372b5979ab@intel.com>
Date: Fri, 14 Jun 2024 17:03:13 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 28/31] hw/i386: Add support for loading BIOS using
 guest_memfd
To: "Gupta, Pankaj" <pankaj.gupta@amd.com>, qemu-devel@nongnu.org
Cc: brijesh.singh@amd.com, dovmurik@linux.ibm.com, armbru@redhat.com,
 michael.roth@amd.com, pbonzini@redhat.com, thomas.lendacky@amd.com,
 isaku.yamahata@intel.com, berrange@redhat.com, kvm@vger.kernel.org,
 anisinha@redhat.com
References: <20240530111643.1091816-1-pankaj.gupta@amd.com>
 <20240530111643.1091816-29-pankaj.gupta@amd.com>
 <434b5332-a7fb-44e4-88f5-4ac93de9c09b@intel.com>
 <a93b94b7-078e-0785-7fb5-e1fc85832aaa@amd.com>
Content-Language: en-US
From: Xiaoyao Li <xiaoyao.li@intel.com>
In-Reply-To: <a93b94b7-078e-0785-7fb5-e1fc85832aaa@amd.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 6/14/2024 4:48 PM, Gupta, Pankaj wrote:
> On 6/14/2024 10:34 AM, Xiaoyao Li wrote:
>> On 5/30/2024 7:16 PM, Pankaj Gupta wrote:
>>> From: Michael Roth <michael.roth@amd.com>
>>>
>>> When guest_memfd is enabled, the BIOS is generally part of the initial
>>> encrypted guest image and will be accessed as private guest memory. Add
>>> the necessary changes to set up the associated RAM region with a
>>> guest_memfd backend to allow for this.
>>>
>>> Current support centers around using -bios to load the BIOS data.
>>> Support for loading the BIOS via pflash requires additional enablement
>>> since those interfaces rely on the use of ROM memory regions which make
>>> use of the KVM_MEM_READONLY memslot flag, which is not supported for
>>> guest_memfd-backed memslots.
>>>
>>> Signed-off-by: Michael Roth <michael.roth@amd.com>
>>> Signed-off-by: Pankaj Gupta <pankaj.gupta@amd.com>
>>> ---
>>>   hw/i386/x86-common.c | 22 ++++++++++++++++------
>>>   1 file changed, 16 insertions(+), 6 deletions(-)
>>>
>>> diff --git a/hw/i386/x86-common.c b/hw/i386/x86-common.c
>>> index f41cb0a6a8..059de65f36 100644
>>> --- a/hw/i386/x86-common.c
>>> +++ b/hw/i386/x86-common.c
>>> @@ -999,10 +999,18 @@ void x86_bios_rom_init(X86MachineState *x86ms, 
>>> const char *default_firmware,
>>>       }
>>>       if (bios_size <= 0 ||
>>>           (bios_size % 65536) != 0) {
>>> -        goto bios_error;
>>> +        if (!machine_require_guest_memfd(MACHINE(x86ms))) {
>>> +                g_warning("%s: Unaligned BIOS size %d", __func__, 
>>> bios_size);
>>> +                goto bios_error;
>>> +        }
>>> +    }
>>> +    if (machine_require_guest_memfd(MACHINE(x86ms))) {
>>> +        memory_region_init_ram_guest_memfd(&x86ms->bios, NULL, 
>>> "pc.bios",
>>> +                                           bios_size, &error_fatal);
>>> +    } else {
>>> +        memory_region_init_ram(&x86ms->bios, NULL, "pc.bios",
>>> +                               bios_size, &error_fatal);
>>>       }
>>> -    memory_region_init_ram(&x86ms->bios, NULL, "pc.bios", bios_size,
>>> -                           &error_fatal);
>>>       if (sev_enabled()) {
>>>           /*
>>>            * The concept of a "reset" simply doesn't exist for
>>> @@ -1023,9 +1031,11 @@ void x86_bios_rom_init(X86MachineState *x86ms, 
>>> const char *default_firmware,
>>>       }
>>>       g_free(filename);
>>> -    /* map the last 128KB of the BIOS in ISA space */
>>> -    x86_isa_bios_init(&x86ms->isa_bios, rom_memory, &x86ms->bios,
>>> -                      !isapc_ram_fw);
>>> +    if (!machine_require_guest_memfd(MACHINE(x86ms))) {
>>> +        /* map the last 128KB of the BIOS in ISA space */
>>> +        x86_isa_bios_init(&x86ms->isa_bios, rom_memory, &x86ms->bios,
>>> +                          !isapc_ram_fw);
>>> +    }
>>
>> Could anyone explain to me why above change is related to this patch 
>> and why need it?
>>
>> because inside x86_isa_bios_init(), the alias isa_bios is set to 
>> read_only while guest_memfd doesn't support readonly?
> 
> I could not understand your comment entirely. This condition is for non 
> guest_memfd case? You expect something else?

I'm asking why x86_isa_bios_init() cannot be called when machine 
requires guest memfd.

Please see my comment[1] to previous patch, patch 27, the two patches 
conflict with each other. The two patches did lack the clarification on 
the changes it made. sigh...

[1] 
https://lore.kernel.org/qemu-devel/ce895ad3-7a84-4af1-8927-6e85f60ef4f6@intel.com/

> Thanks,
> Pankaj
>>
>>>       /* map all the bios at the top of memory */
>>>       memory_region_add_subregion(rom_memory,
>>
> 


