Return-Path: <kvm+bounces-39980-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 7CFD4A4D38C
	for <lists+kvm@lfdr.de>; Tue,  4 Mar 2025 07:11:49 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id E68FE3AAF68
	for <lists+kvm@lfdr.de>; Tue,  4 Mar 2025 06:11:37 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4E7551F4E5F;
	Tue,  4 Mar 2025 06:11:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="gecEldUA"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.15])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4D29D1F4264
	for <kvm@vger.kernel.org>; Tue,  4 Mar 2025 06:11:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.15
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741068698; cv=none; b=sSGY5kx9M9oCwnCnMdg2MVtco9Atg4OIUzToxeDP7Eb6wr0lzZ3XGk4GqCrzSsrqyLXPJzGaqXTaKCxr2F81X/Sh1cGTOSzWlUoAQ6z4JrOfLC2t7cG/Cb3e71t2GSfsYwilUxrV0KCBG6h8Oj7Fl8wz3BkihXdUEIsse7CUFdg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741068698; c=relaxed/simple;
	bh=HHhKVtxadplL5mKHcw+YWQLXuPPV+DKKFP7OBci2gWQ=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=O5L+jEVhwpXV6nqB4jH2Ap3w7K7lCF4Z31CXhPrgAJHSHOEitYf2KK89CgrSORlFqJ84PtIELT6EP6EQ67RI4oGZVnX74HjM8F0nqAkiIhiD5A0fsfM2jyBNsKAlIKB7Lq8V+89LCBUJM+qqraJg7qntf1WzOXy6cCbGr3QPz8s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=gecEldUA; arc=none smtp.client-ip=198.175.65.15
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1741068697; x=1772604697;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=HHhKVtxadplL5mKHcw+YWQLXuPPV+DKKFP7OBci2gWQ=;
  b=gecEldUAQGRYXkXsY1P3Ok2yHWU7YnfXbAlPxJaniX5OXpvbglOnRIed
   IIcJX5qdt6owzgCiSKRzK7vHL2qdevVDQiAwHJ5usXmr4UEW05UETtqSf
   yj2tG0CaKkkf2xiXGvaCAJV/JYKAAERtqDoiM7l15FDs+YNhtbxgAp1sR
   QC8xPVYKwGaybwgFdUweO01fiWvDZVieZYN+sWTBRcrwue/4m2U0DyUZ4
   trLwVvlBhKNRl9up2XbgBY1yEP1hE9Ck3pZVkGsd3629AkSHQkYjQdjJg
   4hQS2XSEmddUrApCVhIYbKvS1Mldl4bViPXw+7GvJPCrs0iz/N++Meb5A
   g==;
X-CSE-ConnectionGUID: eAhN+O0sRQWS6j2SjtkKmg==
X-CSE-MsgGUID: GuSPy2PuSrGsc1tXo7+Twg==
X-IronPort-AV: E=McAfee;i="6700,10204,11362"; a="45619432"
X-IronPort-AV: E=Sophos;i="6.13,331,1732608000"; 
   d="scan'208";a="45619432"
Received: from fmviesa002.fm.intel.com ([10.60.135.142])
  by orvoesa107.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Mar 2025 22:11:35 -0800
X-CSE-ConnectionGUID: QAJh1PKgSEGQGeotrcQ+8w==
X-CSE-MsgGUID: sEGnnyB9Sz2ZQAW7wcSnSg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.13,331,1732608000"; 
   d="scan'208";a="141500769"
Received: from xiaoyaol-hp-g830.ccr.corp.intel.com (HELO [10.124.247.1]) ([10.124.247.1])
  by fmviesa002-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Mar 2025 22:11:29 -0800
Message-ID: <addd4bf3-af4c-446d-b586-62c89ab37d26@intel.com>
Date: Tue, 4 Mar 2025 14:11:27 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 02/10] target/i386: disable PERFCORE when "-pmu" is
 configured
To: dongli.zhang@oracle.com, qemu-devel@nongnu.org, kvm@vger.kernel.org
Cc: pbonzini@redhat.com, zhao1.liu@intel.com, mtosatti@redhat.com,
 sandipan.das@amd.com, babu.moger@amd.com, likexu@tencent.com,
 like.xu.linux@gmail.com, zhenyuw@linux.intel.com, groug@kaod.org,
 khorenko@virtuozzo.com, alexander.ivanov@virtuozzo.com, den@virtuozzo.com,
 davydov-max@yandex-team.ru, dapeng1.mi@linux.intel.com, joe.jin@oracle.com
References: <20250302220112.17653-1-dongli.zhang@oracle.com>
 <20250302220112.17653-3-dongli.zhang@oracle.com>
 <99810e4f-f41d-4905-ae6d-1080b14fc8fd@intel.com>
 <0dcdd9c1-35e5-4cee-be0b-59113e01e73c@oracle.com>
Content-Language: en-US
From: Xiaoyao Li <xiaoyao.li@intel.com>
In-Reply-To: <0dcdd9c1-35e5-4cee-be0b-59113e01e73c@oracle.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 3/4/2025 2:45 AM, dongli.zhang@oracle.com wrote:
> Hi Xiaoyao,
> 
> On 3/2/25 5:59 PM, Xiaoyao Li wrote:
>> On 3/3/2025 6:00 AM, Dongli Zhang wrote:
>>> Currently, AMD PMU support isn't determined based on CPUID, that is, the
>>> "-pmu" option does not fully disable KVM AMD PMU virtualization.
>>>
>>> To minimize AMD PMU features, remove PERFCORE when "-pmu" is configured.
>>>
>>> To completely disable AMD PMU virtualization will be implemented via
>>> KVM_CAP_PMU_CAPABILITY in upcoming patches.
>>>
>>> As a reminder, neither CPUID_EXT3_PERFCORE nor
>>> CPUID_8000_0022_EAX_PERFMON_V2 is removed from env->features[] when "-pmu"
>>> is configured. Developers should query whether they are supported via
>>> cpu_x86_cpuid() rather than relying on env->features[] in future patches.
>>
>> I don't think it is the correct direction to go.
>>
>> env->features[] should be finalized before cpu_x86_cpuid() and env-
>>> features[] needs to be able to be exposed to guest directly. This ensures
>> guest and QEMU have the same view of CPUIDs and it simplifies things.
>>
>> We can adjust env->features[] by filtering all PMU related CPUIDs based on
>> cpu->enable_pmu in x86_cpu_realizefn().
> 
> Thank you very much for suggestion.
> 
> I see  code like below in x86_cpu_realizefn() to edit env->features[].
> 
> 7982     /* On AMD CPUs, some CPUID[8000_0001].EDX bits must match the bits on
> 7983      * CPUID[1].EDX.
> 7984      */
> 7985     if (IS_AMD_CPU(env)) {
> 7986         env->features[FEAT_8000_0001_EDX] &= ~CPUID_EXT2_AMD_ALIASES;
> 7987         env->features[FEAT_8000_0001_EDX] |= (env->features[FEAT_1_EDX]
> 7988            & CPUID_EXT2_AMD_ALIASES);
> 7989     }
> 
> I may do something similar to them for CPUID_EXT3_PERFCORE and
> CPUID_8000_0022_EAX_PERFMON_V2.

I just sent a series for CPUID_EXT_PDCM[1]. I think you can put 
CPUID_EXT3_PERFCORE and CPUID_8000_0022_EAX_PERFMON_V2 at the same place.

[1] 
https://lore.kernel.org/qemu-devel/20250304052450.465445-1-xiaoyao.li@intel.com/T/#m31c6777131b6361d7c3af22b09532bdc785dbc06

> Dongli Zhang
> 
> 
> 
>>
>>> Suggested-by: Zhao Liu <zhao1.liu@intel.com>
>>> Signed-off-by: Dongli Zhang <dongli.zhang@oracle.com>
>>> ---
>>>    target/i386/cpu.c | 4 ++++
>>>    1 file changed, 4 insertions(+)
>>>
>>> diff --git a/target/i386/cpu.c b/target/i386/cpu.c
>>> index b6d6167910..61a671028a 100644
>>> --- a/target/i386/cpu.c
>>> +++ b/target/i386/cpu.c
>>> @@ -7115,6 +7115,10 @@ void cpu_x86_cpuid(CPUX86State *env, uint32_t
>>> index, uint32_t count,
>>>                !(env->hflags & HF_LMA_MASK)) {
>>>                *edx &= ~CPUID_EXT2_SYSCALL;
>>>            }
>>> +
>>> +        if (kvm_enabled() && IS_AMD_CPU(env) && !cpu->enable_pmu) {
>>> +            *ecx &= ~CPUID_EXT3_PERFCORE;
>>> +        }
>>>            break;
>>>        case 0x80000002:
>>>        case 0x80000003:
>>
> 


