Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5638C356071
	for <lists+kvm@lfdr.de>; Wed,  7 Apr 2021 02:48:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245435AbhDGArv (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 6 Apr 2021 20:47:51 -0400
Received: from mga06.intel.com ([134.134.136.31]:34303 "EHLO mga06.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233073AbhDGArv (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 6 Apr 2021 20:47:51 -0400
IronPort-SDR: eFz7IoREAasP9AMGV/ATtYJm4m+w6fUi4feZvgCcgAPYmaRN5etF8aOWfDLV0L2R6Mr+t5cRkC
 o822xaQohzog==
X-IronPort-AV: E=McAfee;i="6000,8403,9946"; a="254522701"
X-IronPort-AV: E=Sophos;i="5.82,201,1613462400"; 
   d="scan'208";a="254522701"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Apr 2021 17:47:42 -0700
IronPort-SDR: dFvHysc5N71iqXbIglsESnWNUJszXzaHEwnGMFE6DzzvzW/uX6B+Hi9eyc4m4nU/oBCnb8u6Vz
 eEuExMPrrOPg==
X-IronPort-AV: E=Sophos;i="5.82,201,1613462400"; 
   d="scan'208";a="421464553"
Received: from likexu-mobl1.ccr.corp.intel.com (HELO [10.255.29.228]) ([10.255.29.228])
  by orsmga008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Apr 2021 17:47:36 -0700
Subject: Re: [PATCH v4 02/16] perf/x86/intel: Handle guest PEBS overflow PMI
 for KVM guest
To:     Peter Zijlstra <peterz@infradead.org>
Cc:     Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>, eranian@google.com,
        andi@firstfloor.org, kan.liang@linux.intel.com,
        wei.w.wang@intel.com, Wanpeng Li <wanpengli@tencent.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        x86@kernel.org, linux-kernel@vger.kernel.org,
        Andi Kleen <ak@linux.intel.com>,
        Like Xu <like.xu@linux.intel.com>
References: <20210329054137.120994-1-like.xu@linux.intel.com>
 <20210329054137.120994-3-like.xu@linux.intel.com>
 <YGyKsna7CcncX0g6@hirez.programming.kicks-ass.net>
From:   "Xu, Like" <like.xu@intel.com>
Message-ID: <604f994e-6636-c5e8-8983-86b717175dd8@intel.com>
Date:   Wed, 7 Apr 2021 08:47:34 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.9.0
MIME-Version: 1.0
In-Reply-To: <YGyKsna7CcncX0g6@hirez.programming.kicks-ass.net>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 2021/4/7 0:22, Peter Zijlstra wrote:
> On Mon, Mar 29, 2021 at 01:41:23PM +0800, Like Xu wrote:
>> With PEBS virtualization, the guest PEBS records get delivered to the
>> guest DS, and the host pmi handler uses perf_guest_cbs->is_in_guest()
>> to distinguish whether the PMI comes from the guest code like Intel PT.
>>
>> No matter how many guest PEBS counters are overflowed, only triggering
>> one fake event is enough. The fake event causes the KVM PMI callback to
>> be called, thereby injecting the PEBS overflow PMI into the guest.
>>
>> KVM will inject the PMI with BUFFER_OVF set, even if the guest DS is
>> empty. That should really be harmless. Thus the guest PEBS handler would
>> retrieve the correct information from its own PEBS records buffer.
>>
>> Originally-by: Andi Kleen <ak@linux.intel.com>
>> Co-developed-by: Kan Liang <kan.liang@linux.intel.com>
>> Signed-off-by: Kan Liang <kan.liang@linux.intel.com>
>> Signed-off-by: Like Xu <like.xu@linux.intel.com>
>> ---
>>   arch/x86/events/intel/core.c | 45 +++++++++++++++++++++++++++++++++++-
>>   1 file changed, 44 insertions(+), 1 deletion(-)
>>
>> diff --git a/arch/x86/events/intel/core.c b/arch/x86/events/intel/core.c
>> index 591d60cc8436..af9ac48fe840 100644
>> --- a/arch/x86/events/intel/core.c
>> +++ b/arch/x86/events/intel/core.c
>> @@ -2747,6 +2747,46 @@ static void intel_pmu_reset(void)
>>   	local_irq_restore(flags);
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
>> + * The contents and other behavior of the guest event do not matter.
>> + */
>> +static int x86_pmu_handle_guest_pebs(struct pt_regs *regs,
>> +					struct perf_sample_data *data)
>> +{
>> +	struct cpu_hw_events *cpuc = this_cpu_ptr(&cpu_hw_events);
>> +	u64 guest_pebs_idxs = cpuc->pebs_enabled & ~cpuc->intel_ctrl_host_mask;
>> +	struct perf_event *event = NULL;
>> +	int bit;
>> +
>> +	if (!x86_pmu.pebs_active || !guest_pebs_idxs)
>> +		return 0;
>> +
>> +	for_each_set_bit(bit, (unsigned long *)&guest_pebs_idxs,
>> +			INTEL_PMC_IDX_FIXED + x86_pmu.num_counters_fixed) {
>> +
>> +		event = cpuc->events[bit];
>> +		if (!event->attr.precise_ip)
>> +			continue;
>> +
>> +		perf_sample_data_init(data, 0, event->hw.last_period);
>> +		if (perf_event_overflow(event, data, regs))
>> +			x86_pmu_stop(event, 0);
>> +
>> +		/* Inject one fake event is enough. */
>> +		return 1;
>> +	}
>> +
>> +	return 0;
>> +}
> Why the return value, it is ignored.

Thanks, I'll apply it.

>
>> +
>>   static int handle_pmi_common(struct pt_regs *regs, u64 status)
>>   {
>>   	struct perf_sample_data data;
>> @@ -2797,7 +2837,10 @@ static int handle_pmi_common(struct pt_regs *regs, u64 status)
>>   		u64 pebs_enabled = cpuc->pebs_enabled;
>>   
>>   		handled++;
>> -		x86_pmu.drain_pebs(regs, &data);
>> +		if (x86_pmu.pebs_vmx && perf_guest_cbs && perf_guest_cbs->is_in_guest())
>> +			x86_pmu_handle_guest_pebs(regs, &data);
>> +		else
>> +			x86_pmu.drain_pebs(regs, &data);
> Why is that else? Since we can't tell if the PMI was for the guest or
> for our own DS, we should check both, no?

Yes, it's helpful for the later usage and I'll apply it.

By the way, do you have any comments on patches 01, 03
and the changes related to intel_guest_get_msrs() (such as patch 09) ?


