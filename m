Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7C9AE3873C9
	for <lists+kvm@lfdr.de>; Tue, 18 May 2021 10:14:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347415AbhERIPB (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 18 May 2021 04:15:01 -0400
Received: from mga14.intel.com ([192.55.52.115]:11498 "EHLO mga14.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S242198AbhERIPA (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 18 May 2021 04:15:00 -0400
IronPort-SDR: +rXcNqY2VF07+JHK/bldMdVcq6MjVzvGYWagfi3PLz+A6yIqr3oNy1jFQXNVk7MePI5NUpcYl+
 6n+ZcWX7X4qQ==
X-IronPort-AV: E=McAfee;i="6200,9189,9987"; a="200350191"
X-IronPort-AV: E=Sophos;i="5.82,309,1613462400"; 
   d="scan'208";a="200350191"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 May 2021 01:13:42 -0700
IronPort-SDR: DDc3bdMAKnR4RyF+G1GbXBza8dsSJItYN8ny3BQx+KVhdkw14oSIKHv6AHZFsyDBHka+ZPoHrS
 6it0w3hbZzCg==
X-IronPort-AV: E=Sophos;i="5.82,309,1613462400"; 
   d="scan'208";a="472841391"
Received: from likexu-mobl1.ccr.corp.intel.com (HELO [10.238.4.93]) ([10.238.4.93])
  by orsmga001-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 May 2021 01:13:36 -0700
Subject: Re: [PATCH v6 06/16] KVM: x86/pmu: Add IA32_PEBS_ENABLE MSR emulation
 for extended PEBS
To:     Peter Zijlstra <peterz@infradead.org>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Borislav Petkov <bp@alien8.de>,
        Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, weijiang.yang@intel.com,
        Kan Liang <kan.liang@linux.intel.com>, ak@linux.intel.com,
        wei.w.wang@intel.com, eranian@google.com, liuxiangdong5@huawei.com,
        linux-kernel@vger.kernel.org, x86@kernel.org, kvm@vger.kernel.org,
        Like Xu <like.xu@linux.intel.com>
References: <20210511024214.280733-1-like.xu@linux.intel.com>
 <20210511024214.280733-7-like.xu@linux.intel.com>
 <YKIqbph62oclxjnt@hirez.programming.kicks-ass.net>
From:   "Xu, Like" <like.xu@intel.com>
Message-ID: <69c3b712-0e6b-65d9-a0f9-40d939cd9d54@intel.com>
Date:   Tue, 18 May 2021 16:13:34 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <YKIqbph62oclxjnt@hirez.programming.kicks-ass.net>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 2021/5/17 16:33, Peter Zijlstra wrote:
> On Tue, May 11, 2021 at 10:42:04AM +0800, Like Xu wrote:
>> diff --git a/arch/x86/events/intel/core.c b/arch/x86/events/intel/core.c
>> index 2f89fd599842..c791765f4761 100644
>> --- a/arch/x86/events/intel/core.c
>> +++ b/arch/x86/events/intel/core.c
>> @@ -3898,31 +3898,49 @@ static struct perf_guest_switch_msr *intel_guest_get_msrs(int *nr, void *data)
>>   	struct cpu_hw_events *cpuc = this_cpu_ptr(&cpu_hw_events);
>>   	struct perf_guest_switch_msr *arr = cpuc->guest_switch_msrs;
>>   	u64 intel_ctrl = hybrid(cpuc->pmu, intel_ctrl);
>> +	u64 pebs_mask = (x86_pmu.flags & PMU_FL_PEBS_ALL) ?
>> +		cpuc->pebs_enabled : (cpuc->pebs_enabled & PEBS_COUNTER_MASK);
>> -	if (x86_pmu.flags & PMU_FL_PEBS_ALL)
>> -		arr[0].guest &= ~cpuc->pebs_enabled;
>> -	else
>> -		arr[0].guest &= ~(cpuc->pebs_enabled & PEBS_COUNTER_MASK);
>> -	*nr = 1;
> Instead of endlessly mucking about with branches, do we want something
> like this instead?

Fine to me. How about the commit message for your below patch:

x86/perf/core: Add pebs_capable to store valid PEBS_COUNTER_MASK value

The value of pebs_counter_mask will be accessed frequently
for repeated use in the intel_guest_get_msrs(). So it can be
optimized instead of endlessly mucking about with branches.

Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>

>
> ---
> diff --git a/arch/x86/events/intel/core.c b/arch/x86/events/intel/core.c
> index 2521d03de5e0..bcfba11196c8 100644
> --- a/arch/x86/events/intel/core.c
> +++ b/arch/x86/events/intel/core.c
> @@ -2819,10 +2819,7 @@ static int handle_pmi_common(struct pt_regs *regs, u64 status)
>   	 * counters from the GLOBAL_STATUS mask and we always process PEBS
>   	 * events via drain_pebs().
>   	 */
> -	if (x86_pmu.flags & PMU_FL_PEBS_ALL)
> -		status &= ~cpuc->pebs_enabled;
> -	else
> -		status &= ~(cpuc->pebs_enabled & PEBS_COUNTER_MASK);
> +	status &= ~(cpuc->pebs_enabled & x86_pmu.pebs_capable);
>   
>   	/*
>   	 * PEBS overflow sets bit 62 in the global status register
> @@ -3862,10 +3859,7 @@ static struct perf_guest_switch_msr *intel_guest_get_msrs(int *nr)
>   	arr[0].msr = MSR_CORE_PERF_GLOBAL_CTRL;
>   	arr[0].host = intel_ctrl & ~cpuc->intel_ctrl_guest_mask;
>   	arr[0].guest = intel_ctrl & ~cpuc->intel_ctrl_host_mask;
> -	if (x86_pmu.flags & PMU_FL_PEBS_ALL)
> -		arr[0].guest &= ~cpuc->pebs_enabled;
> -	else
> -		arr[0].guest &= ~(cpuc->pebs_enabled & PEBS_COUNTER_MASK);
> +	arr[0].guest &= ~(cpuc->pebs_enabled & x86_pmu.pebs_capable);
>   	*nr = 1;
>   
>   	if (x86_pmu.pebs && x86_pmu.pebs_no_isolation) {
> @@ -5546,6 +5540,7 @@ __init int intel_pmu_init(void)
>   	x86_pmu.events_mask_len		= eax.split.mask_length;
>   
>   	x86_pmu.max_pebs_events		= min_t(unsigned, MAX_PEBS_EVENTS, x86_pmu.num_counters);
> +	x86_pmu.pebs_capable		= PEBS_COUNTER_MASK;
>   
>   	/*
>   	 * Quirk: v2 perfmon does not report fixed-purpose events, so
> @@ -5730,6 +5725,7 @@ __init int intel_pmu_init(void)
>   		x86_pmu.pebs_aliases = NULL;
>   		x86_pmu.pebs_prec_dist = true;
>   		x86_pmu.lbr_pt_coexist = true;
> +		x86_pmu.pebs_capable = ~0ULL;
>   		x86_pmu.flags |= PMU_FL_HAS_RSP_1;
>   		x86_pmu.flags |= PMU_FL_PEBS_ALL;
>   		x86_pmu.get_event_constraints = glp_get_event_constraints;
> @@ -6080,6 +6076,7 @@ __init int intel_pmu_init(void)
>   		x86_pmu.pebs_aliases = NULL;
>   		x86_pmu.pebs_prec_dist = true;
>   		x86_pmu.pebs_block = true;
> +		x86_pmu.pebs_capable = ~0ULL;
>   		x86_pmu.flags |= PMU_FL_HAS_RSP_1;
>   		x86_pmu.flags |= PMU_FL_NO_HT_SHARING;
>   		x86_pmu.flags |= PMU_FL_PEBS_ALL;
> @@ -6123,6 +6120,7 @@ __init int intel_pmu_init(void)
>   		x86_pmu.pebs_aliases = NULL;
>   		x86_pmu.pebs_prec_dist = true;
>   		x86_pmu.pebs_block = true;
> +		x86_pmu.pebs_capable = ~0ULL;
>   		x86_pmu.flags |= PMU_FL_HAS_RSP_1;
>   		x86_pmu.flags |= PMU_FL_NO_HT_SHARING;
>   		x86_pmu.flags |= PMU_FL_PEBS_ALL;
> diff --git a/arch/x86/events/perf_event.h b/arch/x86/events/perf_event.h
> index 27fa85e7d4fd..6f3cf81ccb1b 100644
> --- a/arch/x86/events/perf_event.h
> +++ b/arch/x86/events/perf_event.h
> @@ -805,6 +805,7 @@ struct x86_pmu {
>   	void		(*pebs_aliases)(struct perf_event *event);
>   	unsigned long	large_pebs_flags;
>   	u64		rtm_abort_event;
> +	u64		pebs_capable;
>   
>   	/*
>   	 * Intel LBR

