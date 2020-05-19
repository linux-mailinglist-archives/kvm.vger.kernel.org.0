Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 129A31D9738
	for <lists+kvm@lfdr.de>; Tue, 19 May 2020 15:11:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728901AbgESNLF (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 19 May 2020 09:11:05 -0400
Received: from mga02.intel.com ([134.134.136.20]:10145 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728705AbgESNLE (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 19 May 2020 09:11:04 -0400
IronPort-SDR: c4t4SSwR/JNBF3lCrIwTh+v3Qmhi/MhIMmA9ss2up+76oStqQWOpnw/Mpgdb2lEgZ8wrYYzFVp
 r2Ga4UrGIi6Q==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 May 2020 06:11:04 -0700
IronPort-SDR: Q1oJwjhWRHQZVxyRT2XVq6iFqHxtT7QDhVGshWTbMBpzbO6OUFVFWexIReRlCIeAOBMM1iDsnf
 eRNW9Bzes32g==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.73,410,1583222400"; 
   d="scan'208";a="288951757"
Received: from likexu-mobl1.ccr.corp.intel.com (HELO [10.249.171.98]) ([10.249.171.98])
  by fmsmga004.fm.intel.com with ESMTP; 19 May 2020 06:10:59 -0700
Reply-To: like.xu@intel.com
Subject: Re: [PATCH v11 10/11] KVM: x86/pmu: Check guest LBR availability in
 case host reclaims them
To:     Peter Zijlstra <peterz@infradead.org>,
        Like Xu <like.xu@linux.intel.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org,
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
From:   "Xu, Like" <like.xu@intel.com>
Organization: Intel OTC
Message-ID: <3a234754-e103-907f-9b06-44b5e7ae12d3@intel.com>
Date:   Tue, 19 May 2020 21:10:58 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.8.0
MIME-Version: 1.0
In-Reply-To: <20200519111559.GJ279861@hirez.programming.kicks-ass.net>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 2020/5/19 19:15, Peter Zijlstra wrote:
> On Thu, May 14, 2020 at 04:30:53PM +0800, Like Xu wrote:
>
>> diff --git a/arch/x86/kvm/vmx/pmu_intel.c b/arch/x86/kvm/vmx/pmu_intel.c
>> index ea4faae56473..db185dca903d 100644
>> --- a/arch/x86/kvm/vmx/pmu_intel.c
>> +++ b/arch/x86/kvm/vmx/pmu_intel.c
>> @@ -646,6 +646,43 @@ static void intel_pmu_lbr_cleanup(struct kvm_vcpu *vcpu)
>>   		intel_pmu_free_lbr_event(vcpu);
>>   }
>>   
>> +static bool intel_pmu_lbr_is_availabile(struct kvm_vcpu *vcpu)
>> +{
>> +	struct kvm_pmu *pmu = vcpu_to_pmu(vcpu);
>> +
>> +	if (!pmu->lbr_event)
>> +		return false;
>> +
>> +	if (event_is_oncpu(pmu->lbr_event)) {
>> +		intel_pmu_intercept_lbr_msrs(vcpu, false);
>> +	} else {
>> +		intel_pmu_intercept_lbr_msrs(vcpu, true);
>> +		return false;
>> +	}
>> +
>> +	return true;
>> +}
> This is unreadable gunk, what?

Abstractly, it is saying "KVM would passthrough the LBR satck MSRs if
event_is_oncpu() is true, otherwise cancel the passthrough state if any."

I'm using 'event->oncpu != -1' to represent the guest LBR event
is scheduled on rather than 'event->state == PERF_EVENT_STATE_ERROR'.

For intel_pmu_intercept_lbr_msrs(), false means to passthrough the LBR stack
MSRs to the vCPU, and true means to cancel the passthrough state and make
LBR MSR accesses trapped by the KVM.

>
>> +/*
>> + * Higher priority host perf events (e.g. cpu pinned) could reclaim the
>> + * pmu resources (e.g. LBR) that were assigned to the guest. This is
>> + * usually done via ipi calls (more details in perf_install_in_context).
>> + *
>> + * Before entering the non-root mode (with irq disabled here), double
>> + * confirm that the pmu features enabled to the guest are not reclaimed
>> + * by higher priority host events. Otherwise, disallow vcpu's access to
>> + * the reclaimed features.
>> + */
>> +static void intel_pmu_availability_check(struct kvm_vcpu *vcpu)
>> +{
>> +	lockdep_assert_irqs_disabled();
>> +
>> +	if (lbr_is_enabled(vcpu) && !intel_pmu_lbr_is_availabile(vcpu) &&
>> +		(vmcs_read64(GUEST_IA32_DEBUGCTL) & DEBUGCTLMSR_LBR))
>> +		pr_warn_ratelimited("kvm: vcpu-%d: LBR is temporarily unavailable.\n",
>> +			vcpu->vcpu_id);
> More unreadable nonsense; when the events go into ERROR state, it's a
> permanent fail, they'll not come back.
It's not true.  The guest LBR event with 'ERROR state' or 'oncpu != -1' 
would be
lazy released and re-created in the next time the 
intel_pmu_create_lbr_event() is
called and it's supposed to be re-scheduled and re-do availability_check() 
as well.

 From the perspective of the guest user, the guest LBR is only temporarily 
unavailable
until the host no longer reclaims the LBR.
>
>> +}
>> +
>>   struct kvm_pmu_ops intel_pmu_ops = {
>>   	.find_arch_event = intel_find_arch_event,
>>   	.find_fixed_event = intel_find_fixed_event,
>> @@ -662,4 +699,5 @@ struct kvm_pmu_ops intel_pmu_ops = {
>>   	.reset = intel_pmu_reset,
>>   	.deliver_pmi = intel_pmu_deliver_pmi,
>>   	.lbr_cleanup = intel_pmu_lbr_cleanup,
>> +	.availability_check = intel_pmu_availability_check,
>>   };
>> diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
>> index 9969d663826a..80d036c5f64a 100644
>> --- a/arch/x86/kvm/vmx/vmx.c
>> +++ b/arch/x86/kvm/vmx/vmx.c
>> @@ -6696,8 +6696,10 @@ static fastpath_t vmx_vcpu_run(struct kvm_vcpu *vcpu)
>>   
>>   	pt_guest_enter(vmx);
>>   
>> -	if (vcpu_to_pmu(vcpu)->version)
>> +	if (vcpu_to_pmu(vcpu)->version) {
>>   		atomic_switch_perf_msrs(vmx);
>> +		kvm_x86_ops.pmu_ops->availability_check(vcpu);
>> +	}
> AFAICT you just did a call out to the kvm_pmu crud in
> atomic_switch_perf_msrs(), why do another call?
In fact, availability_check() is only called here for just one time.

The callchain looks like:
- vmx_vcpu_run()
     - kvm_x86_ops.pmu_ops->availability_check();
         - intel_pmu_availability_check()
             - intel_pmu_lbr_is_availabile()
                 - event_is_oncpu() ...

Thanks,
Like Xu
>
>

