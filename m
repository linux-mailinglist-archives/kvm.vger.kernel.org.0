Return-Path: <kvm+bounces-29932-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 208209B456B
	for <lists+kvm@lfdr.de>; Tue, 29 Oct 2024 10:15:33 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 70940B20300
	for <lists+kvm@lfdr.de>; Tue, 29 Oct 2024 09:15:30 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C44EF1E0DB5;
	Tue, 29 Oct 2024 09:15:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Gn6ta54M"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.8])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CA48818C33B;
	Tue, 29 Oct 2024 09:15:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.8
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730193320; cv=none; b=V8+5jdc0oPBkXjQKEm0Dez44hMGf7m8WdbYJdHsFTqaReEEgOGmcZtZYXJ+o7Pd4UIzzQiZZXmz8CQrD9yISuyGBzEZkXkOq68DO53TeDHBsgBLs+jYKBc/jBngsCNv8gPPKQFFX0412JIORmrSnlsdih20+6/xZvIf3zS7VzPs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730193320; c=relaxed/simple;
	bh=HDYJQCLEBxCmXHa0cy8/U0NzXNhzXlQDLDtz6/M/1R8=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=h768lRHWtTYUhVIFGMefteK82z8eNqZzCDe0MHHoZCy/s4mlErPSLKRX5A4I8TlcAJch8i+nEELCp07N8k1Zc6LdTcWBPkTSu62mXAbgHbgYPxhwRSnhQyGksIh9CSJOIZeaaDEUV4/vLyiEsMiFHJbgTI5c8A+IBon53tsVhOs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=Gn6ta54M; arc=none smtp.client-ip=192.198.163.8
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1730193318; x=1761729318;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=HDYJQCLEBxCmXHa0cy8/U0NzXNhzXlQDLDtz6/M/1R8=;
  b=Gn6ta54MmCy65vs/Zbfuo9EIW1uWFnWzMugGr0U10xvdmvevoV477rbd
   4i5kOBs+I+/zytZ6TUflIOc11LRwdoIvRz243m+P7q5dpmm7RKiZP+Tfr
   3EVjGl7KVloLSA3KfR90iC277FIJcsWy2RuMhi0BuIWMEesrjdAD1sLBk
   XrHV/LMD7tEkzONvbYZPWAzYGEyzmYxfscJ9z3oto27/zfGtGMiP+Rbp7
   DnHQFQtJuCM3VDSSXBjwZuTGQhGrvJ1nRFUoG0MOLpSDkFTHC2l5LejJm
   J5tcIv8FblbJY5ZcjPWnKoqICISk2jEPdATTFecZ65wxP3s1VeWtw3AEn
   A==;
X-CSE-ConnectionGUID: LW9IBtIOQw2YWUz8aVslGQ==
X-CSE-MsgGUID: MDb5ilRUR+y2tIMaz93Axg==
X-IronPort-AV: E=McAfee;i="6700,10204,11239"; a="47299432"
X-IronPort-AV: E=Sophos;i="6.11,241,1725346800"; 
   d="scan'208";a="47299432"
Received: from orviesa001.jf.intel.com ([10.64.159.141])
  by fmvoesa102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Oct 2024 02:15:17 -0700
X-CSE-ConnectionGUID: UB/d2OifTCuGY/GPVt0epg==
X-CSE-MsgGUID: Wr7bJn31Ra6sijXxxCA/Eg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.11,241,1725346800"; 
   d="scan'208";a="119357839"
Received: from xiaoyaol-hp-g830.ccr.corp.intel.com (HELO [10.124.227.172]) ([10.124.227.172])
  by smtpauth.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Oct 2024 02:15:14 -0700
Message-ID: <ff5d23fa-12c6-47bb-8309-b19d39875827@intel.com>
Date: Tue, 29 Oct 2024 17:15:11 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v14 09/13] tsc: Use the GUEST_TSC_FREQ MSR for discovering
 TSC frequency
To: "Nikunj A. Dadhania" <nikunj@amd.com>, linux-kernel@vger.kernel.org,
 thomas.lendacky@amd.com, bp@alien8.de, x86@kernel.org, kvm@vger.kernel.org
Cc: mingo@redhat.com, tglx@linutronix.de, dave.hansen@linux.intel.com,
 pgonda@google.com, seanjc@google.com, pbonzini@redhat.com
References: <20241028053431.3439593-1-nikunj@amd.com>
 <20241028053431.3439593-10-nikunj@amd.com>
 <b015fb9c-4595-49a9-afde-ef01a45e15d1@intel.com>
 <ebfae76b-1a4d-175a-e0ab-91319164e461@amd.com>
Content-Language: en-US
From: Xiaoyao Li <xiaoyao.li@intel.com>
In-Reply-To: <ebfae76b-1a4d-175a-e0ab-91319164e461@amd.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 10/29/2024 11:56 AM, Nikunj A. Dadhania wrote:
> 
> 
> On 10/29/2024 8:32 AM, Xiaoyao Li wrote:
>> On 10/28/2024 1:34 PM, Nikunj A Dadhania wrote:
>>> Calibrating the TSC frequency using the kvmclock is not correct for
>>> SecureTSC enabled guests. Use the platform provided TSC frequency via the
>>> GUEST_TSC_FREQ MSR (C001_0134h).
>>>
>>> Signed-off-by: Nikunj A Dadhania <nikunj@amd.com>
>>> ---
>>>    arch/x86/include/asm/sev.h |  2 ++
>>>    arch/x86/coco/sev/core.c   | 16 ++++++++++++++++
>>>    arch/x86/kernel/tsc.c      |  5 +++++
>>>    3 files changed, 23 insertions(+)
>>>
>>> diff --git a/arch/x86/include/asm/sev.h b/arch/x86/include/asm/sev.h
>>> index d27c4e0f9f57..9ee63ddd0d90 100644
>>> --- a/arch/x86/include/asm/sev.h
>>> +++ b/arch/x86/include/asm/sev.h
>>> @@ -536,6 +536,7 @@ static inline int handle_guest_request(struct snp_msg_desc *mdesc, u64 exit_code
>>>    }
>>>      void __init snp_secure_tsc_prepare(void);
>>> +void __init snp_secure_tsc_init(void);
>>>      #else    /* !CONFIG_AMD_MEM_ENCRYPT */
>>>    @@ -584,6 +585,7 @@ static inline int handle_guest_request(struct snp_msg_desc *mdesc, u64 exit_code
>>>                           u32 resp_sz) { return -ENODEV; }
>>>      static inline void __init snp_secure_tsc_prepare(void) { }
>>> +static inline void __init snp_secure_tsc_init(void) { }
>>>      #endif    /* CONFIG_AMD_MEM_ENCRYPT */
>>>    diff --git a/arch/x86/coco/sev/core.c b/arch/x86/coco/sev/core.c
>>> index 140759fafe0c..0be9496b8dea 100644
>>> --- a/arch/x86/coco/sev/core.c
>>> +++ b/arch/x86/coco/sev/core.c
>>> @@ -3064,3 +3064,19 @@ void __init snp_secure_tsc_prepare(void)
>>>          pr_debug("SecureTSC enabled");
>>>    }
>>> +
>>> +static unsigned long securetsc_get_tsc_khz(void)
>>> +{
>>> +    unsigned long long tsc_freq_mhz;
>>> +
>>> +    setup_force_cpu_cap(X86_FEATURE_TSC_KNOWN_FREQ);
>>> +    rdmsrl(MSR_AMD64_GUEST_TSC_FREQ, tsc_freq_mhz);
>>> +
>>> +    return (unsigned long)(tsc_freq_mhz * 1000);
>>> +}
>>> +
>>> +void __init snp_secure_tsc_init(void)
>>> +{
>>> +    x86_platform.calibrate_cpu = securetsc_get_tsc_khz;
>>> +    x86_platform.calibrate_tsc = securetsc_get_tsc_khz;
>>> +}
>>> diff --git a/arch/x86/kernel/tsc.c b/arch/x86/kernel/tsc.c
>>> index dfe6847fd99e..730cbbd4554e 100644
>>> --- a/arch/x86/kernel/tsc.c
>>> +++ b/arch/x86/kernel/tsc.c
>>> @@ -30,6 +30,7 @@
>>>    #include <asm/i8259.h>
>>>    #include <asm/topology.h>
>>>    #include <asm/uv/uv.h>
>>> +#include <asm/sev.h>
>>>      unsigned int __read_mostly cpu_khz;    /* TSC clocks / usec, not used here */
>>>    EXPORT_SYMBOL(cpu_khz);
>>> @@ -1514,6 +1515,10 @@ void __init tsc_early_init(void)
>>>        /* Don't change UV TSC multi-chassis synchronization */
>>>        if (is_early_uv_system())
>>>            return;
>>> +
>>> +    if (cc_platform_has(CC_ATTR_GUEST_SNP_SECURE_TSC))
>>> +        snp_secure_tsc_init();
>>
>> IMHO, it isn't the good place to call snp_secure_tsc_init() to update the callbacks here.
>>
>> It's better to be called in some snp init functions.
> 
> As part of setup_arch(), init_hypervisor_platform() gets called and all the PV clocks
> are registered and initialized as part of init_platform callback. Once the hypervisor
> platform is initialized, tsc_early_init() is called. SEV SNP guest can be running on
> any hypervisor, so the call back needs to be updated either in tsc_early_init() or
> init_hypervisor_platform(), as the change is TSC related, I have updated it here.

I think it might be due to

1. it lacks a central place for SNP related stuff, like tdx_early_init()
2. even we have some place of 1), the callbacks will be overwrote in 
init_hypervisor_platform() by specific PV ops.

However, I don't think it's good practice to update it tsc.c. The reason 
why callback is used is that arch/hypervisor specific code can implement
and overwrite with it's own implementation in its own file.

Back to your case, I think a central snp init function would be helpful, 
and we can introduce a new flag to skip the overwrite of tsc/cpu 
calibration for hypervisor when the flag is set.


>>
>>>        if (!determine_cpu_tsc_frequencies(true))
>>>            return;
>>>        tsc_enable_sched_clock();
>>
> 
> Regards,
> Nikunj


