Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9E0DD2EEBA1
	for <lists+kvm@lfdr.de>; Fri,  8 Jan 2021 04:06:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726646AbhAHDGA (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 7 Jan 2021 22:06:00 -0500
Received: from mga05.intel.com ([192.55.52.43]:17920 "EHLO mga05.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726113AbhAHDGA (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 7 Jan 2021 22:06:00 -0500
IronPort-SDR: VsFnLbYZE+yJvkCFO2/MLqDhUJdxmYgerXBSspUzxGfrh4qU5QLJ833betKphS2GQ05vSFXMaU
 hrzoKOV5Bc5A==
X-IronPort-AV: E=McAfee;i="6000,8403,9857"; a="262301961"
X-IronPort-AV: E=Sophos;i="5.79,330,1602572400"; 
   d="scan'208";a="262301961"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Jan 2021 19:05:19 -0800
IronPort-SDR: a+KB6jKswdvMiDMNThNVT9k3PAzkVkxo/c7iT8fS6bNzGCPzfkNyl5RSgUxUx5ugh+RLkm9/zp
 QQEsdbzX7rtA==
X-IronPort-AV: E=Sophos;i="5.79,330,1602572400"; 
   d="scan'208";a="379965243"
Received: from likexu-mobl1.ccr.corp.intel.com (HELO [10.238.4.93]) ([10.238.4.93])
  by orsmga008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Jan 2021 19:05:13 -0800
Subject: Re: [PATCH v3 07/17] KVM: x86/pmu: Add IA32_DS_AREA MSR emulation to
 manage guest DS buffer
To:     Sean Christopherson <seanjc@google.com>,
        Like Xu <like.xu@linux.intel.com>,
        Andi Kleen <andi@firstfloor.org>
Cc:     Peter Zijlstra <peterz@infradead.org>,
        Paolo Bonzini <pbonzini@redhat.com>, eranian@google.com,
        kvm@vger.kernel.org, Ingo Molnar <mingo@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Kan Liang <kan.liang@linux.intel.com>, wei.w.wang@intel.com,
        luwei.kang@intel.com, linux-kernel@vger.kernel.org
References: <20210104131542.495413-1-like.xu@linux.intel.com>
 <20210104131542.495413-8-like.xu@linux.intel.com>
 <X/TXGylLUVLHNIC7@google.com>
From:   "Xu, Like" <like.xu@intel.com>
Message-ID: <961e6135-ff6d-86d1-3b7b-a1846ad0e4c4@intel.com>
Date:   Fri, 8 Jan 2021 11:05:11 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.0
MIME-Version: 1.0
In-Reply-To: <X/TXGylLUVLHNIC7@google.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Sean,

On 2021/1/6 5:16, Sean Christopherson wrote:
>> diff --git a/arch/x86/events/intel/core.c b/arch/x86/events/intel/core.c
>> index 6453b8a6834a..ccddda455bec 100644
>> --- a/arch/x86/events/intel/core.c
>> +++ b/arch/x86/events/intel/core.c
>> @@ -3690,6 +3690,7 @@ static struct perf_guest_switch_msr *intel_guest_get_msrs(int *nr)
>>   {
>>   	struct cpu_hw_events *cpuc = this_cpu_ptr(&cpu_hw_events);
>>   	struct perf_guest_switch_msr *arr = cpuc->guest_switch_msrs;
>> +	struct debug_store *ds = __this_cpu_read(cpu_hw_events.ds);
>>   
>>   	arr[0].msr = MSR_CORE_PERF_GLOBAL_CTRL;
>>   	arr[0].host = x86_pmu.intel_ctrl & ~cpuc->intel_ctrl_guest_mask;
>> @@ -3735,6 +3736,18 @@ static struct perf_guest_switch_msr *intel_guest_get_msrs(int *nr)
>>   		*nr = 2;
>>   	}
>>   
>> +	if (arr[1].guest) {
>> +		arr[2].msr = MSR_IA32_DS_AREA;
>> +		arr[2].host = (unsigned long)ds;
>> +		/* KVM will update MSR_IA32_DS_AREA with the trapped guest value. */
>> +		arr[2].guest = 0ull;
>> +		*nr = 3;
>> +	} else if (*nr == 2) {
>> +		arr[2].msr = MSR_IA32_DS_AREA;
>> +		arr[2].host = arr[2].guest = 0;
>> +		*nr = 3;
>> +	}
> Similar comments as the previous patch, please figure out a way to properly
> integrate this into the PEBS logic instead of querying arr/nr.

To address your comment, please help confirm whether you are
fine or happy with the streamlined logic of intel_guest_get_msrs():

static struct perf_guest_switch_msr *intel_guest_get_msrs(int *nr)
{
     struct cpu_hw_events *cpuc = this_cpu_ptr(&cpu_hw_events);
     struct perf_guest_switch_msr *arr = cpuc->guest_switch_msrs;
     struct debug_store *ds = __this_cpu_read(cpu_hw_events.ds);

     arr[0].msr = MSR_CORE_PERF_GLOBAL_CTRL;
     arr[0].host = x86_pmu.intel_ctrl & ~cpuc->intel_ctrl_guest_mask;
     arr[0].guest = x86_pmu.intel_ctrl & ~cpuc->intel_ctrl_host_mask;

     /*
      * Disable PEBS in the guest if PEBS is used by the host; enabling PEBS
      * in both will lead to unexpected PMIs in the host and/or missed PMIs
      * in the guest.
      */
     if (cpuc->pebs_enabled & ~cpuc->intel_ctrl_host_mask) {
         if (x86_pmu.flags & PMU_FL_PEBS_ALL)
             arr[0].guest &= ~cpuc->pebs_enabled;
         else
             arr[0].guest &= ~(cpuc->pebs_enabled & PEBS_COUNTER_MASK);
     }
     *nr = 1;

     if (x86_pmu.pebs) {
         arr[1].msr = MSR_IA32_PEBS_ENABLE;
         arr[2].msr = MSR_IA32_DS_AREA;
         if (x86_pmu.intel_cap.pebs_baseline)
             arr[3].msr = MSR_PEBS_DATA_CFG;

         /* Skip the MSR loads by stuffing guest=host (KVM will remove the 
entry). */
         arr[1].guest = arr[1].host = cpuc->pebs_enabled & 
~cpuc->intel_ctrl_guest_mask;
         arr[2].guest = arr[2].host = (unsigned long)ds;
         if (x86_pmu.intel_cap.pebs_baseline)
             arr[3].guest = arr[3].host = cpuc->pebs_data_cfg;

         /*
          * Host and guest PEBS are mutually exclusive. Load the guest
          * value iff PEBS is disabled in the host.
          *
          * If PEBS is enabled in the host and the CPU supports PEBS isolation,
          * disabling the counters is sufficient (see commit 9b545c04abd4);
          * Without isolation, PEBS must be explicitly disabled prior to
          * VM-Enter to prevent PEBS writes from overshooting VM-Enter.
          *
          * KVM will update arr[2|3].guest with the trapped guest values
          * iff guest PEBS is allowed to be enabled.
          */
         if (!arr[1].host) {
             arr[1].guest = cpuc->pebs_enabled & ~cpuc->intel_ctrl_host_mask;
             arr[0].guest |= arr[1].guest;
         } else if (x86_pmu.pebs_no_isolation)
             arr[1].guest = 0;

         *nr = x86_pmu.intel_cap.pebs_baseline ? 4 : 3;
     }

     return arr;
}

---
thx,likexu

>
>> +
>>   	return arr;
>>   }

