Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5E1DD387444
	for <lists+kvm@lfdr.de>; Tue, 18 May 2021 10:45:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346712AbhERIpj (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 18 May 2021 04:45:39 -0400
Received: from mga06.intel.com ([134.134.136.31]:36400 "EHLO mga06.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S241784AbhERIpi (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 18 May 2021 04:45:38 -0400
IronPort-SDR: MD08VHyxG+2r+hhI7auytOMogNKJ/jIFlKmvrkNdn9wv3IXFDKY+7kmW3ZNkbx8vwsOF5C1LJY
 lalX//3RLzKQ==
X-IronPort-AV: E=McAfee;i="6200,9189,9987"; a="261890459"
X-IronPort-AV: E=Sophos;i="5.82,309,1613462400"; 
   d="scan'208";a="261890459"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 May 2021 01:44:20 -0700
IronPort-SDR: mN2MH/8odEPxWFWlnT7H5kVTDuv9JWn3pna63zpSihh8KJi6Augh17Ii7ugWq7Xhj2OVQ3V3Ai
 5JkvABga9d6Q==
X-IronPort-AV: E=Sophos;i="5.82,309,1613462400"; 
   d="scan'208";a="472852491"
Received: from likexu-mobl1.ccr.corp.intel.com (HELO [10.238.4.93]) ([10.238.4.93])
  by orsmga001-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 May 2021 01:44:15 -0700
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
        Luwei Kang <luwei.kang@intel.com>,
        Like Xu <like.xu@linux.intel.com>
References: <20210511024214.280733-1-like.xu@linux.intel.com>
 <20210511024214.280733-7-like.xu@linux.intel.com>
 <YKIqJTe/StbBrrUy@hirez.programming.kicks-ass.net>
From:   "Xu, Like" <like.xu@intel.com>
Message-ID: <bc6d19ec-7ceb-0414-da68-e271466b9b8b@intel.com>
Date:   Tue, 18 May 2021 16:44:13 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <YKIqJTe/StbBrrUy@hirez.programming.kicks-ass.net>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 2021/5/17 16:32, Peter Zijlstra wrote:
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
>> +
>> +	*nr = 0;
>> +	arr[(*nr)++] = (struct perf_guest_switch_msr){
>> +		.msr = MSR_CORE_PERF_GLOBAL_CTRL,
>> +		.host = intel_ctrl & ~cpuc->intel_ctrl_guest_mask,
>> +		.guest = intel_ctrl & (~cpuc->intel_ctrl_host_mask | ~pebs_mask),
>> +	};
>>   
>> +	if (!x86_pmu.pebs)
>> +		return arr;
>>   
>> +	/*
>> +	 * If PMU counter has PEBS enabled it is not enough to
>> +	 * disable counter on a guest entry since PEBS memory
>> +	 * write can overshoot guest entry and corrupt guest
>> +	 * memory. Disabling PEBS solves the problem.
>> +	 *
>> +	 * Don't do this if the CPU already enforces it.
>> +	 */
>> +	if (x86_pmu.pebs_no_isolation) {
>> +		arr[(*nr)++] = (struct perf_guest_switch_msr){
>> +			.msr = MSR_IA32_PEBS_ENABLE,
>> +			.host = cpuc->pebs_enabled,
>> +			.guest = 0,
>> +		};
>> +		return arr;
>>   	}
>>   
>> +	if (!x86_pmu.pebs_vmx)
>> +		return arr;
>> +
>> +	arr[*nr] = (struct perf_guest_switch_msr){
>> +		.msr = MSR_IA32_PEBS_ENABLE,
>> +		.host = cpuc->pebs_enabled & ~cpuc->intel_ctrl_guest_mask,
>> +		.guest = pebs_mask & ~cpuc->intel_ctrl_host_mask,
>> +	};
>> +
>> +	/* Set hw GLOBAL_CTRL bits for PEBS counter when it runs for guest */
>> +	arr[0].guest |= arr[*nr].guest;
>> +
>> +	++(*nr);
>>   	return arr;
>>   }
> ISTR saying I was confused as heck by this function, I still don't see
> clarifying comments :/
>
> What's .host and .guest ?

Will adding the following comments help you ?

+/*
+ * Currently, the only caller of this function is the 
atomic_switch_perf_msrs().
+ * The host perf conext helps to prepare the values of the real hardware for
+ * a set of msrs that need to be switched atomically in a vmx transaction.
+ *
+ * For example, the pseudocode needed to add a new msr should look like:
+ *
+ * arr[(*nr)++] = (struct perf_guest_switch_msr){
+ *     .msr = the hardware msr address,
+ *     .host = the value the hardware has when it doesn't run a guest,
+ *     .guest = the value the hardware has when it runs a guest,
+ * };
+ *
+ * These values have nothing to do with the emulated values the guest sees
+ * when it uses {RD,WR}MSR, which should be handled in the KVM context.
+ */
  static struct perf_guest_switch_msr *intel_guest_get_msrs(int *nr, void 
*data)


