Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EFA481CA687
	for <lists+kvm@lfdr.de>; Fri,  8 May 2020 10:48:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727030AbgEHIsg (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 8 May 2020 04:48:36 -0400
Received: from mga18.intel.com ([134.134.136.126]:31689 "EHLO mga18.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726616AbgEHIsf (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 8 May 2020 04:48:35 -0400
IronPort-SDR: uiWwEpsLk3KC1hqlUobUmzl70VNTqTo4jqVpFJ0/EBpugrHbHLrShh0giCaM19vtt+IayYd0YO
 ZjpkGG4oMUrA==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 May 2020 01:48:35 -0700
IronPort-SDR: o/UFJtcmQaq+kZTdWiOUM5OwBW/Hlzau4txwZwl9ISo4XMuA7AhP6r/AMSy4kFa9nSeEQU1cPr
 plKUyFVeSD+g==
X-IronPort-AV: E=Sophos;i="5.73,367,1583222400"; 
   d="scan'208";a="407953065"
Received: from likexu-mobl1.ccr.corp.intel.com (HELO [10.238.4.141]) ([10.238.4.141])
  by orsmga004-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 May 2020 01:48:32 -0700
Subject: Re: [PATCH v10 08/11] KVM: x86/pmu: Add LBR feature emulation via
 guest LBR event
From:   Like Xu <like.xu@linux.intel.com>
To:     Peter Zijlstra <peterz@infradead.org>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, wei.w.wang@intel.com,
        ak@linux.intel.com
References: <20200423081412.164863-1-like.xu@linux.intel.com>
 <20200423081412.164863-9-like.xu@linux.intel.com>
 <20200424121626.GB20730@hirez.programming.kicks-ass.net>
 <87abf620-d292-d997-c9be-9a5d2544f3fa@linux.intel.com>
Organization: Intel OTC
Message-ID: <c9b4df65-ca2d-083a-883d-415e6be52ac2@linux.intel.com>
Date:   Fri, 8 May 2020 16:48:30 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.8.0
MIME-Version: 1.0
In-Reply-To: <87abf620-d292-d997-c9be-9a5d2544f3fa@linux.intel.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Peter,

On 2020/4/27 11:16, Like Xu wrote:
> Hi Peter,
> 
> On 2020/4/24 20:16, Peter Zijlstra wrote:
>> On Thu, Apr 23, 2020 at 04:14:09PM +0800, Like Xu wrote:
>>> +static int intel_pmu_create_lbr_event(struct kvm_vcpu *vcpu)
>>> +{
>>> +    struct kvm_pmu *pmu = vcpu_to_pmu(vcpu);
>>> +    struct perf_event *event;
>>> +
>>> +    /*
>>> +     * The perf_event_attr is constructed in the minimum efficient way:
>>> +     * - set 'pinned = true' to make it task pinned so that if another
>>> +     *   cpu pinned event reclaims LBR, the event->oncpu will be set to 
>>> -1;
>>> +     *
>>> +     * - set 'sample_type = PERF_SAMPLE_BRANCH_STACK' and
>>> +     *   'exclude_host = true' to mark it as a guest LBR event which
>>> +     *   indicates host perf to schedule it without but a fake counter,
>>> +     *   check is_guest_lbr_event() and intel_guest_event_constraints();
>>> +     *
>>> +     * - set 'branch_sample_type = PERF_SAMPLE_BRANCH_CALL_STACK |
>>> +     *   PERF_SAMPLE_BRANCH_USER' to configure it to use callstack mode,
>>> +     *   which allocs 'ctx->task_ctx_data' and request host perf subsystem
>>> +     *   to save/restore guest LBR records during host context switches,
>>> +     *   check branch_user_callstack() and intel_pmu_lbr_sched_task();
>>> +     */
>>> +    struct perf_event_attr attr = {
>>> +        .type = PERF_TYPE_RAW,
>>
>> This is not right; this needs a .config
> 
> Now we know the default value .config = 0 for attr is not acceptable.
> 
>>
>> And I suppose that is why you need that horrible:
>> needs_guest_lbr_without_counter() thing to begin with.
> 
> Do you suggest to use event->attr.config check to replace
> "needs_branch_stack(event) && is_kernel_event(event) &&
> event->attr.exclude_host" check for guest LBR event ?
> 
>>
>> Please allocate yourself an event from the pseudo event range:
>> event==0x00. Currently we only have umask==3 for Fixed2 and umask==4
>> for Fixed3, given you claim 58, which is effectively Fixed25,
>> umask==0x1a might be appropriate.
> 
> OK, I assume that adding one more field ".config = 0x1a00" is
> efficient enough for perf_event_attr to allocate guest LBR events.

Do you have any comment for this ?

> 
>>
>> Also, I suppose we need to claim 0x0000 as an error, so that other
>> people won't try this again.
> 
> Does the following fix address your concern on this ?

Does the following fix address your concern on this ?

> 
> diff --git a/arch/x86/events/core.c b/arch/x86/events/core.c
> index 2405926e2dba..32d2a3f8c51f 100644
> --- a/arch/x86/events/core.c
> +++ b/arch/x86/events/core.c
> @@ -498,6 +498,9 @@ int x86_pmu_max_precise(void)
> 
>   int x86_pmu_hw_config(struct perf_event *event)
>   {
> +       if (!unlikely(event->attr.config & X86_ARCH_EVENT_MASK))
> +               return -EINVAL;
> +
>          if (event->attr.precise_ip) {
>                  int precise = x86_pmu_max_precise();
> 
> diff --git a/arch/x86/include/asm/perf_event.h 
> b/arch/x86/include/asm/perf_event.h
> index 2e6c59308344..bdba87a6f0af 100644
> --- a/arch/x86/include/asm/perf_event.h
> +++ b/arch/x86/include/asm/perf_event.h
> @@ -47,6 +47,8 @@
>          (ARCH_PERFMON_EVENTSEL_EVENT | (0x0FULL << 32))
>   #define INTEL_ARCH_EVENT_MASK  \
>          (ARCH_PERFMON_EVENTSEL_UMASK | ARCH_PERFMON_EVENTSEL_EVENT)
> +#define X86_ARCH_EVENT_MASK    \
> +       (ARCH_PERFMON_EVENTSEL_UMASK | ARCH_PERFMON_EVENTSEL_EVENT)
> 
>   #define AMD64_L3_SLICE_SHIFT                           48
>   #define AMD64_L3_SLICE_MASK
> 

>>
>>> +        .size = sizeof(attr),
>>> +        .pinned = true,
>>> +        .exclude_host = true,
>>> +        .sample_type = PERF_SAMPLE_BRANCH_STACK,
>>> +        .branch_sample_type = PERF_SAMPLE_BRANCH_CALL_STACK |
>>> +                    PERF_SAMPLE_BRANCH_USER,
>>> +    };
>>> +
>>> +    if (unlikely(pmu->lbr_event))
>>> +        return 0;
>>> +
>>> +    event = perf_event_create_kernel_counter(&attr, -1,
>>> +                        current, NULL, NULL);
>>> +    if (IS_ERR(event)) {
>>> +        pr_debug_ratelimited("%s: failed %ld\n",
>>> +                    __func__, PTR_ERR(event));
>>> +        return -ENOENT;
>>> +    }
>>> +    pmu->lbr_event = event;
>>> +    pmu->event_count++;
>>> +    return 0;
>>> +}
>>
>> Also, what happens if you fail programming due to a conflicting cpu
>> event? That pinned doesn't guarantee you'll get the event, it just means
>> you'll error instead of getting RR.
>>
>> I didn't find any code checking the event state.
>>
> 
> Error instead of RR is expected.
> 
> If the KVM fails programming due to a conflicting cpu event
> the LBR registers will not be passthrough to the guest,
> and KVM would return zero for any guest LBR records accesses
> until the next attempt to program the guest LBR event.
> 
> Every time before cpu enters the non-root mode where irq is
> disabled, the "event-> oncpu! =-1" check will be applied.
> (more details in the comment around intel_pmu_availability_check())
> 
> The guests administer is supposed to know the result of guest
> LBR records is inaccurate if someone is using LBR to record
> guest or hypervisor on the host side.
> 
> Is this acceptable to you？
> 
> If there is anything needs to be improved, please let me know.

Is this acceptable to you？

If there is anything needs to be improved, please let me know.

> 
> Thanks,
> Like Xu
> 

