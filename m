Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 81E622F70B9
	for <lists+kvm@lfdr.de>; Fri, 15 Jan 2021 03:51:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732261AbhAOCuh (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 14 Jan 2021 21:50:37 -0500
Received: from mga09.intel.com ([134.134.136.24]:17228 "EHLO mga09.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732212AbhAOCug (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 14 Jan 2021 21:50:36 -0500
IronPort-SDR: Y2++N2Yeu2m13DuBDWqs7CyOWCgiWUXL231IC7i77gfE8RxMuYYpXc/k7FZJqPIxSJ+L2aMPzq
 hYvStdZMhU/A==
X-IronPort-AV: E=McAfee;i="6000,8403,9864"; a="178635431"
X-IronPort-AV: E=Sophos;i="5.79,347,1602572400"; 
   d="scan'208";a="178635431"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Jan 2021 18:49:55 -0800
IronPort-SDR: ebdsqn0PweN4mbAiiVH2+aBu4aCNwJUh55v11gyEc/C0igEvDoqF0d+FuJ83QciAKNOEvIpx70
 Rh9aRKnE22Uw==
X-IronPort-AV: E=Sophos;i="5.79,347,1602572400"; 
   d="scan'208";a="354131970"
Received: from likexu-mobl1.ccr.corp.intel.com (HELO [10.238.4.93]) ([10.238.4.93])
  by fmsmga008-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Jan 2021 18:49:51 -0800
Subject: Re: [PATCH v3 04/17] perf: x86/ds: Handle guest PEBS overflow PMI and
 inject it to guest
To:     Sean Christopherson <seanjc@google.com>,
        Like Xu <like.xu@linux.intel.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Kan Liang <kan.liang@linux.intel.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>, eranian@google.com,
        kvm@vger.kernel.org, Ingo Molnar <mingo@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Andi Kleen <andi@firstfloor.org>, wei.w.wang@intel.com,
        luwei.kang@intel.com, linux-kernel@vger.kernel.org
References: <20210104131542.495413-1-like.xu@linux.intel.com>
 <20210104131542.495413-5-like.xu@linux.intel.com>
 <YACTnkdi1rxfrRCg@google.com>
From:   "Xu, Like" <like.xu@intel.com>
Message-ID: <a0b5dc29-e63f-6ec9-a03f-6435cb3373c6@intel.com>
Date:   Fri, 15 Jan 2021 10:49:49 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.1
MIME-Version: 1.0
In-Reply-To: <YACTnkdi1rxfrRCg@google.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 2021/1/15 2:55, Sean Christopherson wrote:
> On Mon, Jan 04, 2021, Like Xu wrote:
>> ---
>>   arch/x86/events/intel/ds.c | 62 ++++++++++++++++++++++++++++++++++++++
>>   1 file changed, 62 insertions(+)
>>
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
>> +	 *
>> +	 * If PEBS interrupt threshold on host is not exceeded in a NMI, there
>> +	 * must be a PEBS overflow PMI generated from the guest PEBS counters.
>> +	 * There is no ambiguity since the reported event in the PMI is guest
>> +	 * only. It gets handled correctly on a case by case base for each event.
>> +	 *
>> +	 * Note: KVM disables the co-existence of guest PEBS and host PEBS.
> By "KVM", do you mean KVM's loading of the MSRs provided by intel_guest_get_msrs()?
> Because the PMU should really be the entity that controls guest vs. host.  KVM
> should just be a dumb pipe that handles the mechanics of how values are context
> switch.

The intel_guest_get_msrs() and atomic_switch_perf_msrs()
will work together to disable the co-existence of guest PEBS and host PEBS:

https://lore.kernel.org/kvm/961e6135-ff6d-86d1-3b7b-a1846ad0e4c4@intel.com/

+

static void atomic_switch_perf_msrs(struct vcpu_vmx *vmx)
...
     if (nr_msrs > 2 && (msrs[1].guest & msrs[0].guest)) {
         msrs[2].guest = pmu->ds_area;
         if (nr_msrs > 3)
             msrs[3].guest = pmu->pebs_data_cfg;
     }

    for (i = 0; i < nr_msrs; i++)
...

>
> For example, commit 7099e2e1f4d9 ("KVM: VMX: disable PEBS before a guest entry"),
> where KVM does an explicit WRMSR(PEBS_ENABLE) to (attempt to) force PEBS
> quiescence, is flawed in that the PMU can re-enable PEBS after the WRMSR if a
> PMI arrives between the WRMSR and VM-Enter (because VMX can't block NMIs).  The
> PMU really needs to be involved in the WRMSR workaround.

Thanks, I will carefully confirm the PEBS quiescent behavior on the ICX.
But we're fine to keep "wrmsrl(MSR_IA32_PEBS_ENABLE, 0);" here
since we will load a new guest value (if any) for this msr later.

>
>> +	 */
>> +	if (!guest_pebs_idxs || !in_nmi() ||
> Are PEBS updates guaranteed to be isolated in both directions on relevant
> hardware?

I think it's true on the ICX.

> By that I mean, will host updates be fully processed before VM-Enter
> compeletes, and guest updates before VM-Exit completes?

The situation is more complicated.

> If that's the case,
> then this path could be optimized to change the KVM invocation of the NMI
> handler so that the "is this a guest PEBS PMI" check is done if and only if the
> PMI originated from with the guest.

When we have a PEBS PMI due to guest workload and vm-exits,
the code path from vm-exit to the host PEBS PMI handler may also
bring PEBS PMI and mark the status bit. The current PMI handler
can't distinguish them and would treat the later one as a suspicious
PMI and output a warning.

This is the main reason why we choose to disable the co-existence
of guest PEBS and host PEBS, and future hardware enhancements
may break this limitation.

---
thx, likexu
>
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

