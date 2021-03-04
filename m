Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B28E832CAA8
	for <lists+kvm@lfdr.de>; Thu,  4 Mar 2021 04:01:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232040AbhCDDAN (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 3 Mar 2021 22:00:13 -0500
Received: from mga12.intel.com ([192.55.52.136]:40515 "EHLO mga12.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232041AbhCDC7o (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 3 Mar 2021 21:59:44 -0500
IronPort-SDR: i4luhUhI5bOeYNahGolze4qmRDkazFwQoiu68otlwXs4B1v+wYjX79bNMADhBdIIZYIxY/LLIE
 Ja5RGnQxyUwA==
X-IronPort-AV: E=McAfee;i="6000,8403,9912"; a="166582579"
X-IronPort-AV: E=Sophos;i="5.81,221,1610438400"; 
   d="scan'208";a="166582579"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Mar 2021 18:59:03 -0800
IronPort-SDR: NGlUq52S0lrB1WgpjaSaG7ci4gIFvJ4SwrVEGIhKWGcplFkxLlqVkBQZw/N7e4Hqley6FpZ299
 r9NNfgQD/cHg==
X-IronPort-AV: E=Sophos;i="5.81,221,1610438400"; 
   d="scan'208";a="400282908"
Received: from likexu-mobl1.ccr.corp.intel.com (HELO [10.238.4.93]) ([10.238.4.93])
  by fmsmga008-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Mar 2021 18:58:59 -0800
Subject: Re: [PATCH v3 6/9] KVM: vmx/pmu: Add MSR_ARCH_LBR_CTL emulation for
 Arch LBR
To:     Sean Christopherson <seanjc@google.com>
Cc:     Peter Zijlstra <peterz@infradead.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Kan Liang <kan.liang@linux.intel.com>,
        Dave Hansen <dave.hansen@intel.com>, wei.w.wang@intel.com,
        Borislav Petkov <bp@alien8.de>, kvm@vger.kernel.org,
        x86@kernel.org, linux-kernel@vger.kernel.org,
        Like Xu <like.xu@linux.intel.com>
References: <20210303135756.1546253-1-like.xu@linux.intel.com>
 <20210303135756.1546253-7-like.xu@linux.intel.com>
 <YD/FFsTq6wprdMCB@google.com>
From:   "Xu, Like" <like.xu@intel.com>
Message-ID: <88d2481d-5435-1ffb-dc98-5534c446bd52@intel.com>
Date:   Thu, 4 Mar 2021 10:58:57 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.0
MIME-Version: 1.0
In-Reply-To: <YD/FFsTq6wprdMCB@google.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 2021/3/4 1:19, Sean Christopherson wrote:
> On Wed, Mar 03, 2021, Like Xu wrote:
>> diff --git a/arch/x86/kvm/vmx/pmu_intel.c b/arch/x86/kvm/vmx/pmu_intel.c
>> index 25d620685ae7..d14a14eb712d 100644
>> --- a/arch/x86/kvm/vmx/pmu_intel.c
>> +++ b/arch/x86/kvm/vmx/pmu_intel.c
>> @@ -19,6 +19,7 @@
>>   #include "pmu.h"
>>   
>>   #define MSR_PMC_FULL_WIDTH_BIT      (MSR_IA32_PMC0 - MSR_IA32_PERFCTR0)
>> +#define KVM_ARCH_LBR_CTL_MASK			0x7f000f
> It would nice to build this up with the individual bits instead of tossing in a
> magic number.

I will move the mask ARCH_LBR_CTL_MASK from lbr.c to msr-index.h and thus,
#define KVM_ARCH_LBR_CTL_MASK  (ARCH_LBR_CTL_MASK | ARCH_LBR_CTL_LBREN)

I assume the move operation would be a separate patch for host side.

>
>>   static struct kvm_event_hw_type_mapping intel_arch_events[] = {
>>   	/* Index must match CPUID 0x0A.EBX bit vector */
>> @@ -221,6 +222,7 @@ static bool intel_is_valid_msr(struct kvm_vcpu *vcpu, u32 msr)
>>   		ret = pmu->version > 1;
>>   		break;
>>   	case MSR_ARCH_LBR_DEPTH:
>> +	case MSR_ARCH_LBR_CTL:
>>   		ret = guest_cpuid_has(vcpu, X86_FEATURE_ARCH_LBR);
>>   		break;
>>   	default:
>> @@ -390,6 +392,9 @@ static int intel_pmu_get_msr(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
>>   	case MSR_ARCH_LBR_DEPTH:
>>   		msr_info->data = lbr_desc->records.nr;
>>   		return 0;
>> +	case MSR_ARCH_LBR_CTL:
>> +		msr_info->data = vmcs_read64(GUEST_IA32_LBR_CTL);
>> +		return 0;
>>   	default:
>>   		if ((pmc = get_gp_pmc(pmu, msr, MSR_IA32_PERFCTR0)) ||
>>   		    (pmc = get_gp_pmc(pmu, msr, MSR_IA32_PMC0))) {
>> @@ -457,6 +462,15 @@ static int intel_pmu_set_msr(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
>>   		lbr_desc->records.nr = data;
>>   		lbr_desc->arch_lbr_reset = true;
>>   		return 0;
>> +	case MSR_ARCH_LBR_CTL:
>> +		if (!(data & ~KVM_ARCH_LBR_CTL_MASK)) {
> Maybe invert this to reduce indentation?
>
> 		if (data & ...)
> 			break; (or "return 1;")

Fine to me.

>
>
>> +			vmcs_write64(GUEST_IA32_LBR_CTL, data);
>> +			if (intel_pmu_lbr_is_enabled(vcpu) && !lbr_desc->event &&
>> +				(data & ARCH_LBR_CTL_LBREN))
> Alignment.

I'll fix it.

>
>> +				intel_pmu_create_guest_lbr_event(vcpu);
>> +			return 0;
>> +		}
>> +		break;
>>   	default:
>>   		if ((pmc = get_gp_pmc(pmu, msr, MSR_IA32_PERFCTR0)) ||
>>   		    (pmc = get_gp_pmc(pmu, msr, MSR_IA32_PMC0))) {
>> @@ -635,12 +649,15 @@ static void intel_pmu_reset(struct kvm_vcpu *vcpu)
>>    */
>>   static void intel_pmu_legacy_freezing_lbrs_on_pmi(struct kvm_vcpu *vcpu)
>>   {
>> -	u64 data = vmcs_read64(GUEST_IA32_DEBUGCTL);
>> +	u32 lbr_ctl_field = GUEST_IA32_DEBUGCTL;
>>   
>> -	if (data & DEBUGCTLMSR_FREEZE_LBRS_ON_PMI) {
>> -		data &= ~DEBUGCTLMSR_LBR;
>> -		vmcs_write64(GUEST_IA32_DEBUGCTL, data);
>> -	}
>> +	if (!(vmcs_read64(GUEST_IA32_DEBUGCTL) & DEBUGCTLMSR_FREEZE_LBRS_ON_PMI))
>> +		return;
>> +
>> +	if (guest_cpuid_has(vcpu, X86_FEATURE_ARCH_LBR))
>> +		lbr_ctl_field = GUEST_IA32_LBR_CTL;
>> +
>> +	vmcs_write64(lbr_ctl_field, vmcs_read64(lbr_ctl_field) & ~BIT(0));
> Use ARCH_LBR_CTL_LBREN?

I'm trying to unify the usage of EN bit for both Arch LBR and legacy LBR:

#define ARCH_LBR_CTL_LBREN        BIT(0)
#define DEBUGCTLMSR_LBR            (1UL <<  0)

Any suggestion ?

>
>>   }
>>   
>>   static void intel_pmu_deliver_pmi(struct kvm_vcpu *vcpu)
>> diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
>> index 6d7e760fdfa0..a0660b9934c6 100644
>> --- a/arch/x86/kvm/vmx/vmx.c
>> +++ b/arch/x86/kvm/vmx/vmx.c
>> @@ -2036,6 +2036,13 @@ static int vmx_set_msr(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
>>   						VM_EXIT_SAVE_DEBUG_CONTROLS)
>>   			get_vmcs12(vcpu)->guest_ia32_debugctl = data;
>>   
>> +		/*
>> +		 * For Arch LBR, IA32_DEBUGCTL[bit 0] has no meaning.
>> +		 * It can be written to 0 or 1, but reads will always return 0.
>> +		 */
>> +		if (guest_cpuid_has(vcpu, X86_FEATURE_ARCH_LBR))
>> +			data &= ~DEBUGCTLMSR_LBR;
>> +
>>   		vmcs_write64(GUEST_IA32_DEBUGCTL, data);
>>   		if (intel_pmu_lbr_is_enabled(vcpu) && !to_vmx(vcpu)->lbr_desc.event &&
>>   		    (data & DEBUGCTLMSR_LBR))
>> @@ -4463,6 +4470,8 @@ static void vmx_vcpu_reset(struct kvm_vcpu *vcpu, bool init_event)
>>   		vmcs_writel(GUEST_SYSENTER_ESP, 0);
>>   		vmcs_writel(GUEST_SYSENTER_EIP, 0);
>>   		vmcs_write64(GUEST_IA32_DEBUGCTL, 0);
>> +		if (cpu_has_vmx_arch_lbr())
>> +			vmcs_write64(GUEST_IA32_LBR_CTL, 0);
> Not that any guest is likely to care, but is the MSR cleared on INIT?  The SDM
> has specific language for warm reset, but I can't find anything for INIT.
>
>    On a warm reset, all LBR MSRs, including IA32_LBR_DEPTH, have their values
>    preserved. However, IA32_LBR_CTL.LBREn is cleared to 0, disabling LBRs. If a
>    warm reset is triggered while the processor is in C6, also known as warm init,
>    all LBR MSRs will be reset to their initial values.

I was told that the reset behavior of GUEST_IA32_LBR_CTL
would be the same as the GUEST_IA32_DEBUGCTL (true for INIT as well).

It looks we have not strictly distinguished the guest's power concept C*.
Do we have two trap paths for "warm reset" and "warm init" ?

>
>>   	}
>>   
>>   	kvm_set_rflags(vcpu, X86_EFLAGS_FIXED);
>> -- 
>> 2.29.2
>>

