Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CDC871DA7A3
	for <lists+kvm@lfdr.de>; Wed, 20 May 2020 04:01:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728525AbgETCBy (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 19 May 2020 22:01:54 -0400
Received: from mga02.intel.com ([134.134.136.20]:11265 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726348AbgETCBy (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 19 May 2020 22:01:54 -0400
IronPort-SDR: kTWqmYpW6EkOtejWN+oRs01tcIR6Ss/IGlDXzaKFATrJwlXUiOj5GIaxw3vPw9Lp9sBw19HZH5
 /DXu7SkPoz8Q==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 May 2020 19:01:53 -0700
IronPort-SDR: Bx2MGVsoWwRD9snZ15HM/bJkxeVIqCjxfvW0LzfuaFFvtBEeXEa1nSYY5BtC/tDNhXcVOG5gvX
 Qgk35wLCxytA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.73,412,1583222400"; 
   d="scan'208";a="254893848"
Received: from likexu-mobl1.ccr.corp.intel.com (HELO [10.238.4.141]) ([10.238.4.141])
  by fmsmga008.fm.intel.com with ESMTP; 19 May 2020 19:01:50 -0700
Reply-To: like.xu@intel.com
Subject: Re: [PATCH v11 10/11] KVM: x86/pmu: Check guest LBR availability in
 case host reclaims them
To:     Peter Zijlstra <peterz@infradead.org>
Cc:     Like Xu <like.xu@linux.intel.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Thomas Gleixner <tglx@linutronix.de>, ak@linux.intel.com,
        wei.w.wang@intel.com
References: <20200514083054.62538-1-like.xu@linux.intel.com>
 <20200514083054.62538-11-like.xu@linux.intel.com>
 <20200519111559.GJ279861@hirez.programming.kicks-ass.net>
 <3a234754-e103-907f-9b06-44b5e7ae12d3@intel.com>
 <20200519145756.GC317569@hirez.programming.kicks-ass.net>
From:   "Xu, Like" <like.xu@intel.com>
Organization: Intel OTC
Message-ID: <9577169d-62f4-0750-7054-5e842d5d2296@intel.com>
Date:   Wed, 20 May 2020 10:01:49 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.8.0
MIME-Version: 1.0
In-Reply-To: <20200519145756.GC317569@hirez.programming.kicks-ass.net>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 2020/5/19 22:57, Peter Zijlstra wrote:
> On Tue, May 19, 2020 at 09:10:58PM +0800, Xu, Like wrote:
>> On 2020/5/19 19:15, Peter Zijlstra wrote:
>>> On Thu, May 14, 2020 at 04:30:53PM +0800, Like Xu wrote:
>>>
>>>> diff --git a/arch/x86/kvm/vmx/pmu_intel.c b/arch/x86/kvm/vmx/pmu_intel.c
>>>> index ea4faae56473..db185dca903d 100644
>>>> --- a/arch/x86/kvm/vmx/pmu_intel.c
>>>> +++ b/arch/x86/kvm/vmx/pmu_intel.c
>>>> @@ -646,6 +646,43 @@ static void intel_pmu_lbr_cleanup(struct kvm_vcpu *vcpu)
>>>>    		intel_pmu_free_lbr_event(vcpu);
>>>>    }
>>>> +static bool intel_pmu_lbr_is_availabile(struct kvm_vcpu *vcpu)
>>>> +{
>>>> +	struct kvm_pmu *pmu = vcpu_to_pmu(vcpu);
>>>> +
>>>> +	if (!pmu->lbr_event)
>>>> +		return false;
>>>> +
>>>> +	if (event_is_oncpu(pmu->lbr_event)) {
>>>> +		intel_pmu_intercept_lbr_msrs(vcpu, false);
>>>> +	} else {
>>>> +		intel_pmu_intercept_lbr_msrs(vcpu, true);
>>>> +		return false;
>>>> +	}
>>>> +
>>>> +	return true;
>>>> +}
>>> This is unreadable gunk, what?
>> Abstractly, it is saying "KVM would passthrough the LBR satck MSRs if
>> event_is_oncpu() is true, otherwise cancel the passthrough state if any."
>>
>> I'm using 'event->oncpu != -1' to represent the guest LBR event
>> is scheduled on rather than 'event->state == PERF_EVENT_STATE_ERROR'.
>>
>> For intel_pmu_intercept_lbr_msrs(), false means to passthrough the LBR stack
>> MSRs to the vCPU, and true means to cancel the passthrough state and make
>> LBR MSR accesses trapped by the KVM.
> To me it seems very weird to change state in a function that is supposed
> to just query state.
>
> 'is_available' seems to suggest a simple: return 'lbr_event->state ==
> PERF_EVENT_STATE_ACTIVE' or something.
This clarification led me to reconsider the use of a more readable name here.

Do you accept the check usage of "event->oncpu != -1" instead of
'event->state == PERF_EVENT_STATE_ERROR' before KVM do passthrough ?
>
>>>> +static void intel_pmu_availability_check(struct kvm_vcpu *vcpu)
>>>> +{
>>>> +	lockdep_assert_irqs_disabled();
>>>> +
>>>> +	if (lbr_is_enabled(vcpu) && !intel_pmu_lbr_is_availabile(vcpu) &&
>>>> +		(vmcs_read64(GUEST_IA32_DEBUGCTL) & DEBUGCTLMSR_LBR))
>>>> +		pr_warn_ratelimited("kvm: vcpu-%d: LBR is temporarily unavailable.\n",
>>>> +			vcpu->vcpu_id);
>>> More unreadable nonsense; when the events go into ERROR state, it's a
>>> permanent fail, they'll not come back.
>> It's not true.  The guest LBR event with 'ERROR state' or 'oncpu != -1'
>> would be
>> lazy released and re-created in the next time the
>> intel_pmu_create_lbr_event() is
>> called and it's supposed to be re-scheduled and re-do availability_check()
>> as well.
> Where? Also, wth would you need to destroy and re-create an event for
> that?
If the guest does not set the EN_LBR bit and did not touch any LBR-related 
registers
in the last time slice, KVM will destroy the guest LBR event in 
kvm_pmu_cleanup()
which is called once every time the vCPU thread is scheduled in.

The re-creation is not directly called after the destruction
but is triggered by the next guest access to the LBR-related registers if any.

 From the time when the guest LBR event enters the "oncpu! = -1" state
to the next re-creation, the guest LBR is not available. After the re-creation,
the guest LBR is hopefully available and if it's true, the LBR will be 
passthrough
and used by the guest normally.

That's the reason for "LBR is temporarily unavailable"
and please let me know if it doesn't make sense to you.

>>>> @@ -6696,8 +6696,10 @@ static fastpath_t vmx_vcpu_run(struct kvm_vcpu *vcpu)
>>>>    	pt_guest_enter(vmx);
>>>> -	if (vcpu_to_pmu(vcpu)->version)
>>>> +	if (vcpu_to_pmu(vcpu)->version) {
>>>>    		atomic_switch_perf_msrs(vmx);
>>>> +		kvm_x86_ops.pmu_ops->availability_check(vcpu);
>>>> +	}
>>> AFAICT you just did a call out to the kvm_pmu crud in
>>> atomic_switch_perf_msrs(), why do another call?
>> In fact, availability_check() is only called here for just one time.
>>
>> The callchain looks like:
>> - vmx_vcpu_run()
>>      - kvm_x86_ops.pmu_ops->availability_check();
>>          - intel_pmu_availability_check()
>>              - intel_pmu_lbr_is_availabile()
>>                  - event_is_oncpu() ...
>>
> What I'm saying is that you just did a pmu_ops indirect call in
> atomic_switch_perf_msrs(), why add another?
Do you mean the indirect call:
- atomic_switch_perf_msrs()
     - perf_guest_get_msrs()
         - x86_pmu.guest_get_msrs()
?

The two pmu_ops are quite different:
- the first one in atomic_switch_perf_msrs() is defined in the host side;
- the second one for availability_check() is defined in the KVM side;

The availability_check() for guest LBR event and MSRs pass-through
operations are definitely KVM context specific.

Thanks,
Like Xu

