Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AA2FC1CA649
	for <lists+kvm@lfdr.de>; Fri,  8 May 2020 10:42:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726767AbgEHImF (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 8 May 2020 04:42:05 -0400
Received: from mga02.intel.com ([134.134.136.20]:16873 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726598AbgEHImE (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 8 May 2020 04:42:04 -0400
IronPort-SDR: JzLmgT8388nsuRevE1If3FhfU6Sv9gotl3pIXB3cp/uw+/OGNxmciOnKbg+LFSw3bxEkYDCYib
 LYY7Fj+XpPWw==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 May 2020 01:42:04 -0700
IronPort-SDR: Zrk0YVJAwrNi0wgEAjBxIEnF+Ma2ZBKnHXD1TJaTvJI/h2NX/Xp4qAuJEOeksFV5F4s5scW25V
 aJW/QaMWG53A==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.73,367,1583222400"; 
   d="scan'208";a="296009850"
Received: from likexu-mobl1.ccr.corp.intel.com (HELO [10.238.4.141]) ([10.238.4.141])
  by fmsmga002.fm.intel.com with ESMTP; 08 May 2020 01:42:01 -0700
Reply-To: like.xu@intel.com
Subject: Re: [PATCH v2] KVM: x86/pmu: Support full width counting
To:     Paolo Bonzini <pbonzini@redhat.com>,
        Like Xu <like.xu@linux.intel.com>
Cc:     Sean Christopherson <sean.j.christopherson@intel.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20200507021452.174646-1-like.xu@linux.intel.com>
 <3fb56700-7f0b-59e1-527a-f8eb601185b1@redhat.com>
From:   "Xu, Like" <like.xu@intel.com>
Organization: Intel OTC
Message-ID: <72d7d120-85af-d846-a0d5-fe8fe058be34@intel.com>
Date:   Fri, 8 May 2020 16:42:00 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.8.0
MIME-Version: 1.0
In-Reply-To: <3fb56700-7f0b-59e1-527a-f8eb601185b1@redhat.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Paolo,

Thanks for your detailed comments.

On 2020/5/7 15:57, Paolo Bonzini wrote:
> On 07/05/20 04:14, Like Xu wrote:
>> +static inline u64 vmx_get_perf_capabilities(void)
>> +{
>> +	u64 perf_cap = 0;
>> +
>> +	if (boot_cpu_has(X86_FEATURE_PDCM))
>> +		rdmsrl(MSR_IA32_PERF_CAPABILITIES, perf_cap);
>> +
>> +	/* Currently, KVM only supports Full-Width Writes. */
>> +	perf_cap &= PMU_CAP_FW_WRITES;
>> +
>> +	return perf_cap;
>> +}
>> +
> Since counters are virtualized, it seems to me that you can support
> PMU_CAP_FW_WRITES unconditionally, even if the host lacks it.  So just
> return PMU_CAP_FW_WRITES from this function.
Sure, let's export PMU_CAP_FW_WRITES unconditionally.
>
>> +	case MSR_IA32_PERF_CAPABILITIES:
>> +		return 1; /* RO MSR */
>>   	default:
> You need to allow writes from the host if (data &
> ~vmx_get_perf_capabilities()) == 0.
Yes, it makes sense after I understand the intention of host_initiated.
>
>> -			if (!msr_info->host_initiated)
>> +		if ((pmc = get_gp_pmc(pmu, msr, MSR_IA32_PERFCTR0)) ||
>> +			(pmc = get_gp_pmc(pmu, msr, MSR_IA32_PMC0))) {
>> +			if (data & ~pmu->counter_bitmask[KVM_PMC_GP])
>> +				return 1;
>> +			if (!fw_writes_is_enabled(pmu))
>>   				data = (s64)(s32)data;
>
> You are dropping the test on msr_info->host_initiated here, you should
> keep it otherwise you allow full-width write to MSR_IA32_PERFCTR0 as
> well.  So:
>
> #define MSR_PMC_FULL_WIDTH_BIT      (MSR_IA32_PMC0 - MSR_IA32_PERFCTR0)
>
> 	if (!msr_info->host_initiated && !(msr & MSR_PMC_FULL_WIDTH_BIT))
> 		data = (s64)(s32)data;
Thanks, it looks good to me and I'll apply it.
>
>> +	case MSR_IA32_PERF_CAPABILITIES:
>> +		if (!nested)
>> +			return 1;
>> +		msr->data = vmx_get_perf_capabilities();
>> +		return 0;
> The !nested check is wrong.
You're absolutely right about this.
>
>> +++ b/arch/x86/kvm/x86.c
>> @@ -1220,6 +1220,13 @@ static const u32 msrs_to_save_all[] = {
>>   	MSR_ARCH_PERFMON_EVENTSEL0 + 12, MSR_ARCH_PERFMON_EVENTSEL0 + 13,
>>   	MSR_ARCH_PERFMON_EVENTSEL0 + 14, MSR_ARCH_PERFMON_EVENTSEL0 + 15,
>>   	MSR_ARCH_PERFMON_EVENTSEL0 + 16, MSR_ARCH_PERFMON_EVENTSEL0 + 17,
>> +
>> +	MSR_IA32_PMC0, MSR_IA32_PMC0 + 1, MSR_IA32_PMC0 + 2,
>> +	MSR_IA32_PMC0 + 3, MSR_IA32_PMC0 + 4, MSR_IA32_PMC0 + 5,
>> +	MSR_IA32_PMC0 + 6, MSR_IA32_PMC0 + 7, MSR_IA32_PMC0 + 8,
>> +	MSR_IA32_PMC0 + 9, MSR_IA32_PMC0 + 10, MSR_IA32_PMC0 + 11,
>> +	MSR_IA32_PMC0 + 12, MSR_IA32_PMC0 + 13, MSR_IA32_PMC0 + 14,
>> +	MSR_IA32_PMC0 + 15, MSR_IA32_PMC0 + 16, MSR_IA32_PMC0 + 17,
>>   };
> This is not needed because the full-width content is already accessible
> from the host via MSR_IA32_PERFCTRn.
That's true because they're just alias registers for MSR_IA32_PERFCTRn.
>
> Given the bugs, it is clear that you should also modify the pmu.c
> testcase for kvm-unit-tests to cover full-width writes (and especially
> the non-full-width write behavior of MSR_IA32_PERFCTRn).  Even before
> the QEMU side is begin worked on, you can test it with "-cpu
> host,migratable=off".
Sure, I added some testcases in pmu.c to cover this feature.

Please review the v3 patch 
https://lore.kernel.org/kvm/20200508083218.120559-1-like.xu@linux.intel.com/
as well as the kvm-unit-tests testcase.

Thanks,
Like Xu
>
> Thanks,
>
> Paolo
>

