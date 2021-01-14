Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 90D0F2F5975
	for <lists+kvm@lfdr.de>; Thu, 14 Jan 2021 04:42:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726953AbhANDjs (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 13 Jan 2021 22:39:48 -0500
Received: from mga02.intel.com ([134.134.136.20]:61843 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726897AbhANDjr (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 13 Jan 2021 22:39:47 -0500
IronPort-SDR: nhtk0yaeeEz2tnVNOmbC+qti/j626cHYtDxbZaCgmr9fH0f+i8nsYLdZIwTJltDi5nv9fORJ+T
 ZeIu7nuu5rLg==
X-IronPort-AV: E=McAfee;i="6000,8403,9863"; a="165391598"
X-IronPort-AV: E=Sophos;i="5.79,346,1602572400"; 
   d="scan'208";a="165391598"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Jan 2021 19:39:06 -0800
IronPort-SDR: 0qGN73YN94xaLN68Sj8XWp71ggVNe7NLBW3QW4Z2Zupg3zld6+Vsdxsk+ePnNMN+EO43MxlTJi
 vE6/e4cZIa8A==
X-IronPort-AV: E=Sophos;i="5.79,346,1602572400"; 
   d="scan'208";a="353731937"
Received: from likexu-mobl1.ccr.corp.intel.com (HELO [10.238.4.93]) ([10.238.4.93])
  by fmsmga008-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Jan 2021 19:39:02 -0800
Subject: Re: [PATCH v3 04/17] perf: x86/ds: Handle guest PEBS overflow PMI and
 inject it to guest
To:     Peter Zijlstra <peterz@infradead.org>,
        Like Xu <like.xu@linux.intel.com>,
        Kan Liang <kan.liang@linux.intel.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>, eranian@google.com,
        kvm@vger.kernel.org, Ingo Molnar <mingo@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Andi Kleen <andi@firstfloor.org>, wei.w.wang@intel.com,
        luwei.kang@intel.com, linux-kernel@vger.kernel.org
References: <20210104131542.495413-1-like.xu@linux.intel.com>
 <20210104131542.495413-5-like.xu@linux.intel.com>
 <X/86UWuV/9yt14hQ@hirez.programming.kicks-ass.net>
From:   "Xu, Like" <like.xu@intel.com>
Message-ID: <9c343e40-bbdf-8af0-3307-5274070ee3d2@intel.com>
Date:   Thu, 14 Jan 2021 11:39:00 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.1
MIME-Version: 1.0
In-Reply-To: <X/86UWuV/9yt14hQ@hirez.programming.kicks-ass.net>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 2021/1/14 2:22, Peter Zijlstra wrote:
> On Mon, Jan 04, 2021 at 09:15:29PM +0800, Like Xu wrote:
>
>> diff --git a/arch/x86/events/intel/ds.c b/arch/x86/events/intel/ds.c
>> index b47cc4226934..c499bdb58373 100644
>> --- a/arch/x86/events/intel/ds.c
>> +++ b/arch/x86/events/intel/ds.c
>> @@ -1721,6 +1721,65 @@ intel_pmu_save_and_restart_reload(struct perf_event *event, int count)
>>   	return 0;
>>   }
>>   
>> +/*
>> + * We may be running with guest PEBS events created by KVM, and the
>> + * PEBS records are logged into the guest's DS and invisible to host.
>> + *
>> + * In the case of guest PEBS overflow, we only trigger a fake event
>> + * to emulate the PEBS overflow PMI for guest PBES counters in KVM.
>> + * The guest will then vm-entry and check the guest DS area to read
>> + * the guest PEBS records.
>> + *
>> + * The guest PEBS overflow PMI may be dropped when both the guest and
>> + * the host use PEBS. Therefore, KVM will not enable guest PEBS once
>> + * the host PEBS is enabled since it may bring a confused unknown NMI.
>> + *
>> + * The contents and other behavior of the guest event do not matter.
>> + */
>> +static int intel_pmu_handle_guest_pebs(struct cpu_hw_events *cpuc,
>> +				       struct pt_regs *iregs,
>> +				       struct debug_store *ds)
>> +{
>> +	struct perf_sample_data data;
>> +	struct perf_event *event = NULL;
>> +	u64 guest_pebs_idxs = cpuc->pebs_enabled & ~cpuc->intel_ctrl_host_mask;
>> +	int bit;
>> +
>> +	/*
>> +	 * Ideally, we should check guest DS to understand if it's
>> +	 * a guest PEBS overflow PMI from guest PEBS counters.
>> +	 * However, it brings high overhead to retrieve guest DS in host.
>> +	 * So we check host DS instead for performance.
> Again; for the virt illiterate people here (me); why is it expensive to
> check guest DS?

We are not checking the guest DS here for two reasons:
- it brings additional kvm mem locking operations and guest page table 
traversal,
    which is very expensive for guests with large memory (if we have cached the
    mapped values, we still need to check whether the cached ones are still 
valid);
- the current interface kvm_read_guest_*() might sleep and is not irq safe;

If you still need me to try this guest DS check approach, please let me know,
I will provide more performance data.

>
> Why do we need to? Can't we simply always forward the PMI if the guest
> has bits set in MSR_IA32_PEBS_ENABLE ? Surely we can access the guest
> MSRs at a reasonable rate..
>
> Sure, it'll send too many PMIs, but is that really a problem?

More vPMI means more guest irq handler calls and
more PMI virtualization overhead. In addition,

the correctness of some workloads (RR?) depends on
the correct number of PMIs and the PMI trigger times
and virt may not want to break this assumption.

>
>> +	 *
>> +	 * If PEBS interrupt threshold on host is not exceeded in a NMI, there
>> +	 * must be a PEBS overflow PMI generated from the guest PEBS counters.
>> +	 * There is no ambiguity since the reported event in the PMI is guest
>> +	 * only. It gets handled correctly on a case by case base for each event.
>> +	 *
>> +	 * Note: KVM disables the co-existence of guest PEBS and host PEBS.
> Where; I need a code reference here.

How about:

Note: KVM will disable the co-existence of guest PEBS and host PEBS.
In the intel_guest_get_msrs(), when we have host PEBS ctrl bit(s) enabled,
KVM will clear the guest PEBS ctrl enable bit(s) before vm-entry.
The guest PEBS users should be notified of this runtime restriction.

>
>> +	 */
>> +	if (!guest_pebs_idxs || !in_nmi() ||
> All the other code uses !iregs instead of !in_nmi(), also your
> indentation is broken.

Sure, I'll use !iregs and fix the indentation in the next version.

---
thx,likexu
>> +		ds->pebs_index >= ds->pebs_interrupt_threshold)
>> +		return 0;
>> +
>> +	for_each_set_bit(bit, (unsigned long *)&guest_pebs_idxs,
>> +			INTEL_PMC_IDX_FIXED + x86_pmu.num_counters_fixed) {
>> +
>> +		event = cpuc->events[bit];
>> +		if (!event->attr.precise_ip)
>> +			continue;
>> +
>> +		perf_sample_data_init(&data, 0, event->hw.last_period);
>> +		if (perf_event_overflow(event, &data, iregs))
>> +			x86_pmu_stop(event, 0);
>> +
>> +		/* Inject one fake event is enough. */
>> +		return 1;
>> +	}
>> +
>> +	return 0;
>> +}
>> +
>>   static __always_inline void
>>   __intel_pmu_pebs_event(struct perf_event *event,
>>   		       struct pt_regs *iregs,
>> @@ -1965,6 +2024,9 @@ static void intel_pmu_drain_pebs_icl(struct pt_regs *iregs, struct perf_sample_d
>>   	if (!x86_pmu.pebs_active)
>>   		return;
>>   
>> +	if (intel_pmu_handle_guest_pebs(cpuc, iregs, ds))
>> +		return;
>> +
>>   	base = (struct pebs_basic *)(unsigned long)ds->pebs_buffer_base;
>>   	top = (struct pebs_basic *)(unsigned long)ds->pebs_index;
>>   
>> -- 
>> 2.29.2
>>

