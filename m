Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 02C7E2ECFF7
	for <lists+kvm@lfdr.de>; Thu,  7 Jan 2021 13:42:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728116AbhAGMj2 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 7 Jan 2021 07:39:28 -0500
Received: from mga07.intel.com ([134.134.136.100]:32301 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727830AbhAGMj2 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 7 Jan 2021 07:39:28 -0500
IronPort-SDR: N6FpzajfbnKH7KDK7fTGoGN+O5wRlGohlZDD1Z+kXzb9WkoOUrel9uurT1Er5wyqY3e2VHSp5r
 /MaBV+EFMmXg==
X-IronPort-AV: E=McAfee;i="6000,8403,9856"; a="241493238"
X-IronPort-AV: E=Sophos;i="5.79,329,1602572400"; 
   d="scan'208";a="241493238"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Jan 2021 04:38:46 -0800
IronPort-SDR: TnZyBNEDQF7YAYQ9aXqYnymgJZIOoDMV3LYI+ErR+nISs6T+b69qAtJNWuwoaz/eEVaEyNY/CU
 aZBZs0KGZBYQ==
X-IronPort-AV: E=Sophos;i="5.79,329,1602572400"; 
   d="scan'208";a="379702310"
Received: from likexu-mobl1.ccr.corp.intel.com (HELO [10.249.172.116]) ([10.249.172.116])
  by orsmga008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Jan 2021 04:38:43 -0800
Subject: Re: [PATCH v3 06/17] KVM: x86/pmu: Add IA32_PEBS_ENABLE MSR emulation
 for extended PEBS
To:     Sean Christopherson <seanjc@google.com>,
        Like Xu <like.xu@linux.intel.com>
Cc:     Peter Zijlstra <peterz@infradead.org>,
        Paolo Bonzini <pbonzini@redhat.com>, eranian@google.com,
        kvm@vger.kernel.org, Ingo Molnar <mingo@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Andi Kleen <andi@firstfloor.org>,
        Kan Liang <kan.liang@linux.intel.com>, wei.w.wang@intel.com,
        luwei.kang@intel.com, linux-kernel@vger.kernel.org
References: <20210104131542.495413-1-like.xu@linux.intel.com>
 <20210104131542.495413-7-like.xu@linux.intel.com>
 <X/TV9nZw49XFwDF/@google.com>
From:   "Xu, Like" <like.xu@intel.com>
Message-ID: <1d7d366d-dc99-8bd1-d2f7-e9328827fe8f@intel.com>
Date:   Thu, 7 Jan 2021 20:38:40 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.0
MIME-Version: 1.0
In-Reply-To: <X/TV9nZw49XFwDF/@google.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Sean,

On 2021/1/6 5:11, Sean Christopherson wrote:
> On Mon, Jan 04, 2021, Like Xu wrote:
>> If IA32_PERF_CAPABILITIES.PEBS_BASELINE [bit 14] is set, the
>> IA32_PEBS_ENABLE MSR exists and all architecturally enumerated fixed
>> and general purpose counters have corresponding bits in IA32_PEBS_ENABLE
>> that enable generation of PEBS records. The general-purpose counter bits
>> start at bit IA32_PEBS_ENABLE[0], and the fixed counter bits start at
>> bit IA32_PEBS_ENABLE[32].
>>
>> When guest PEBS is enabled, the IA32_PEBS_ENABLE MSR will be
>> added to the perf_guest_switch_msr() and switched during the
>> VMX transitions just like CORE_PERF_GLOBAL_CTRL MSR.
>>
>> Originally-by: Andi Kleen <ak@linux.intel.com>
>> Co-developed-by: Kan Liang <kan.liang@linux.intel.com>
>> Signed-off-by: Kan Liang <kan.liang@linux.intel.com>
>> Co-developed-by: Luwei Kang <luwei.kang@intel.com>
>> Signed-off-by: Luwei Kang <luwei.kang@intel.com>
>> Signed-off-by: Like Xu <like.xu@linux.intel.com>
>> ---
>>   arch/x86/events/intel/core.c     | 20 ++++++++++++++++++++
>>   arch/x86/include/asm/kvm_host.h  |  1 +
>>   arch/x86/include/asm/msr-index.h |  6 ++++++
>>   arch/x86/kvm/vmx/pmu_intel.c     | 28 ++++++++++++++++++++++++++++
>>   4 files changed, 55 insertions(+)
>>
>> diff --git a/arch/x86/events/intel/core.c b/arch/x86/events/intel/core.c
>> index af457f8cb29d..6453b8a6834a 100644
>> --- a/arch/x86/events/intel/core.c
>> +++ b/arch/x86/events/intel/core.c
>> @@ -3715,6 +3715,26 @@ static struct perf_guest_switch_msr *intel_guest_get_msrs(int *nr)
>>   		*nr = 2;
>>   	}
>>   
>> +	if (cpuc->pebs_enabled & ~cpuc->intel_ctrl_host_mask) {
>> +		arr[1].msr = MSR_IA32_PEBS_ENABLE;
>> +		arr[1].host = cpuc->pebs_enabled & ~cpuc->intel_ctrl_guest_mask;
>> +		arr[1].guest = cpuc->pebs_enabled & ~cpuc->intel_ctrl_host_mask;
>> +		/*
>> +		 * The guest PEBS will be disabled once the host PEBS is enabled
>> +		 * since the both enabled case may brings a unknown PMI to
>> +		 * confuse host and the guest PEBS overflow PMI would be missed.
>> +		 */
>> +		if (arr[1].host)
>> +			arr[1].guest = 0;
>> +		arr[0].guest |= arr[1].guest;
> Can't you modify the code that strips the PEBS counters from the guest's
> value instead of poking into the array entry after the fact?
Ah, nice move.
>
> Also, why is this scenario even allowed?  Can't we force exclude_guest for
> events that use PEBS?

The attr.exclude_guest can be configured for each event, and
it's not shared with other perf_events on the same CPU,
and changing it will not take effect when the event is running.

Host perf would still allow to create or run the PEBS perf_event
for vcpu when host is using PEBS counter. One reason is that the
perf scheduler needs to know which event owns which PEBS counter.

>
>> +		*nr = 2;
>> +	} else if (*nr == 1) {
>> +		/* Remove MSR_IA32_PEBS_ENABLE from MSR switch list in KVM */
>> +		arr[1].msr = MSR_IA32_PEBS_ENABLE;
>> +		arr[1].host = arr[1].guest = 0;
>> +		*nr = 2;
> Similar to above, rather then check "*nr == 1", this should properly integrate
> with the "x86_pmu.pebs && x86_pmu.pebs_no_isolation" logic instead of poking
> into the array after the fact.
Thanks, it makes sense to me and I'll figure it out w/ your clearly code.
>
> By incorporating both suggestions, the logic can be streamlined significantly,
> and IMO makes the overall flow much more understandable.  Untested...
>
> diff --git a/arch/x86/events/intel/core.c b/arch/x86/events/intel/core.c
> index d4569bfa83e3..c5cc7e558c8e 100644
> --- a/arch/x86/events/intel/core.c
> +++ b/arch/x86/events/intel/core.c
> @@ -3708,24 +3708,39 @@ static struct perf_guest_switch_msr *intel_guest_get_msrs(int *nr)
>          arr[0].msr = MSR_CORE_PERF_GLOBAL_CTRL;
>          arr[0].host = x86_pmu.intel_ctrl & ~cpuc->intel_ctrl_guest_mask;
>          arr[0].guest = x86_pmu.intel_ctrl & ~cpuc->intel_ctrl_host_mask;
> -       if (x86_pmu.flags & PMU_FL_PEBS_ALL)
> -               arr[0].guest &= ~cpuc->pebs_enabled;
> -       else
> -               arr[0].guest &= ~(cpuc->pebs_enabled & PEBS_COUNTER_MASK);
> +
> +       /*
> +        * Disable PEBS in the guest if PEBS is used by the host; enabling PEBS
> +        * in both will lead to unexpected PMIs in the host and/or missed PMIs
> +        * in the guest.
> +        */
> +       if (cpuc->pebs_enabled & ~cpuc->intel_ctrl_guest_mask) {
> +               if (x86_pmu.flags & PMU_FL_PEBS_ALL)
> +                       arr[0].guest &= ~cpuc->pebs_enabled;
> +               else
> +                       arr[0].guest &= ~(cpuc->pebs_enabled & PEBS_COUNTER_MASK);
> +       }
>          *nr = 1;
>
> -       if (x86_pmu.pebs && x86_pmu.pebs_no_isolation) {
> -               /*
> -                * If PMU counter has PEBS enabled it is not enough to
> -                * disable counter on a guest entry since PEBS memory
> -                * write can overshoot guest entry and corrupt guest
> -                * memory. Disabling PEBS solves the problem.
> -                *
> -                * Don't do this if the CPU already enforces it.
> -                */
> +       if (x86_pmu.pebs) {
>                  arr[1].msr = MSR_IA32_PEBS_ENABLE;
> -               arr[1].host = cpuc->pebs_enabled;
> -               arr[1].guest = 0;
> +               arr[1].host = cpuc->pebs_enabled & ~cpuc->intel_ctrl_guest_mask;
> +
> +               /*
> +                * Host and guest PEBS are mutually exclusive.  Load the guest
> +                * value iff PEBS is disabled in the host.  If PEBS is enabled
> +                * in the host and the CPU supports PEBS isolation, disabling
> +                * the counters is sufficient (see above); skip the MSR loads
s/above/9b545c04abd4/
> +                * by stuffing guest=host (KVM will remove the entry).  Without
> +                * isolation, PEBS must be explicitly disabled prior to
> +                * VM-Enter to prevent PEBS writes from overshooting VM-Enter.
> +                */
> +               if (!arr[1].host)
> +                       arr[1].guest = cpuc->pebs_enabled & ~cpuc->intel_ctrl_host_mask;
miss "arr[0].guest |= arr[1].guest;" here to make it enabled in the 
global_ctrl msr.

Sean, if you have more comments on other patches, just let me know.

---
thx,likexu
> +               else if (x86_pmu.pebs_no_isolation)
> +                       arr[1].guest = 0;
> +               else
> +                       arr[1].guest = arr[1].host;
>                  *nr = 2;
>          }

