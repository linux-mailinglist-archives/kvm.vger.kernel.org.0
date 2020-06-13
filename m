Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6DDD91F8246
	for <lists+kvm@lfdr.de>; Sat, 13 Jun 2020 11:43:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726432AbgFMJnA (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 13 Jun 2020 05:43:00 -0400
Received: from mga12.intel.com ([192.55.52.136]:49529 "EHLO mga12.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726308AbgFMJm5 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 13 Jun 2020 05:42:57 -0400
IronPort-SDR: 8Oo4QzHo+sjYPi1gb6ta8TthR6cqZp6sixYQuua/HToLwHN51BllOFaE22FMPyxV+RqHbyaxKZ
 lfBNnEtkwyfA==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Jun 2020 02:42:56 -0700
IronPort-SDR: tqGCK+MzI8ZX7mtnsBUEPDm3sg5SHSiZYRP0VwbABifd0tyFRHIob+7ckCj+6KsbMtbKGj7Akz
 0UgUyoPOHDgg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.73,506,1583222400"; 
   d="scan'208";a="297277115"
Received: from likexu-mobl1.ccr.corp.intel.com (HELO [10.255.31.114]) ([10.255.31.114])
  by fmsmga004.fm.intel.com with ESMTP; 13 Jun 2020 02:42:51 -0700
Reply-To: like.xu@intel.com
Subject: Re: [PATCH v12 07/11] KVM: vmx/pmu: Unmask LBR fields in the
 MSR_IA32_DEBUGCTLMSR emualtion
To:     Xiaoyao Li <xiaoyao.li@intel.com>,
        Like Xu <like.xu@linux.intel.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     Peter Zijlstra <peterz@infradead.org>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, ak@linux.intel.com,
        wei.w.wang@intel.com, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org
References: <20200613080958.132489-1-like.xu@linux.intel.com>
 <20200613080958.132489-8-like.xu@linux.intel.com>
 <654d931c-a724-ed69-6501-52ce195a6f44@intel.com>
From:   "Xu, Like" <like.xu@intel.com>
Organization: Intel OTC
Message-ID: <ea424570-c93f-2624-3e85-d7255b609da4@intel.com>
Date:   Sat, 13 Jun 2020 17:42:50 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.9.0
MIME-Version: 1.0
In-Reply-To: <654d931c-a724-ed69-6501-52ce195a6f44@intel.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 2020/6/13 17:14, Xiaoyao Li wrote:
> On 6/13/2020 4:09 PM, Like Xu wrote:
>> When the LBR feature is reported by the vmx_get_perf_capabilities(),
>> the LBR fields in the [vmx|vcpu]_supported debugctl should be unmasked.
>>
>> The debugctl msr is handled separately in vmx/svm and they're not
>> completely identical, hence remove the common msr handling code.
>>
>> Signed-off-by: Like Xu <like.xu@linux.intel.com>
>> ---
>>   arch/x86/kvm/vmx/capabilities.h | 12 ++++++++++++
>>   arch/x86/kvm/vmx/pmu_intel.c    | 19 +++++++++++++++++++
>>   arch/x86/kvm/x86.c              | 13 -------------
>>   3 files changed, 31 insertions(+), 13 deletions(-)
>>
>> diff --git a/arch/x86/kvm/vmx/capabilities.h 
>> b/arch/x86/kvm/vmx/capabilities.h
>> index b633a90320ee..f6fcfabb1026 100644
>> --- a/arch/x86/kvm/vmx/capabilities.h
>> +++ b/arch/x86/kvm/vmx/capabilities.h
>> @@ -21,6 +21,8 @@ extern int __read_mostly pt_mode;
>>   #define PMU_CAP_FW_WRITES    (1ULL << 13)
>>   #define PMU_CAP_LBR_FMT        0x3f
>>   +#define DEBUGCTLMSR_LBR_MASK        (DEBUGCTLMSR_LBR | 
>> DEBUGCTLMSR_FREEZE_LBRS_ON_PMI)
>> +
>>   struct nested_vmx_msrs {
>>       /*
>>        * We only store the "true" versions of the VMX capability MSRs. We
>> @@ -387,4 +389,14 @@ static inline u64 vmx_get_perf_capabilities(void)
>>       return perf_cap;
>>   }
>>   +static inline u64 vmx_get_supported_debugctl(void)
>> +{
>> +    u64 val = 0;
>> +
>> +    if (vmx_get_perf_capabilities() & PMU_CAP_LBR_FMT)
>> +        val |= DEBUGCTLMSR_LBR_MASK;
>> +
>> +    return val;
>> +}
>> +
>>   #endif /* __KVM_X86_VMX_CAPS_H */
>> diff --git a/arch/x86/kvm/vmx/pmu_intel.c b/arch/x86/kvm/vmx/pmu_intel.c
>> index a953c7d633f6..d92e95b64c74 100644
>> --- a/arch/x86/kvm/vmx/pmu_intel.c
>> +++ b/arch/x86/kvm/vmx/pmu_intel.c
>> @@ -187,6 +187,7 @@ static bool intel_is_valid_msr(struct kvm_vcpu 
>> *vcpu, u32 msr)
>>       case MSR_CORE_PERF_GLOBAL_OVF_CTRL:
>>           ret = pmu->version > 1;
>>           break;
>> +    case MSR_IA32_DEBUGCTLMSR:
>>       case MSR_IA32_PERF_CAPABILITIES:
>>           ret = 1;
>>           break;
>> @@ -237,6 +238,9 @@ static int intel_pmu_get_msr(struct kvm_vcpu *vcpu, 
>> struct msr_data *msr_info)
>>               return 1;
>>           msr_info->data = vcpu->arch.perf_capabilities;
>>           return 0;
>> +    case MSR_IA32_DEBUGCTLMSR:
>> +        msr_info->data = vmcs_read64(GUEST_IA32_DEBUGCTL);
>
> Can we put the emulation of MSR_IA32_DEBUGCTLMSR in vmx_{get/set})_msr(). 
> AFAIK, MSR_IA32_DEBUGCTLMSR is not a pure PMU related MSR that there is 
> bit 2 to enable #DB for bus lock.
We already have "case MSR_IA32_DEBUGCTLMSR" handler in the vmx_set_msr()
and you may apply you bus lock changes in that handler.
>> +        return 0;
>>       default:
>>           if ((pmc = get_gp_pmc(pmu, msr, MSR_IA32_PERFCTR0)) ||
>>               (pmc = get_gp_pmc(pmu, msr, MSR_IA32_PMC0))) {
>> @@ -282,6 +286,16 @@ static inline bool lbr_is_compatible(struct 
>> kvm_vcpu *vcpu)
>>       return true;
>>   }
>>   +static inline u64 vcpu_get_supported_debugctl(struct kvm_vcpu *vcpu)
>> +{
>> +    u64 debugctlmsr = vmx_get_supported_debugctl();
>> +
>> +    if (!lbr_is_enabled(vcpu))
>> +        debugctlmsr &= ~DEBUGCTLMSR_LBR_MASK;
>> +
>> +    return debugctlmsr;
>> +}
>> +
>>   static int intel_pmu_set_msr(struct kvm_vcpu *vcpu, struct msr_data 
>> *msr_info)
>>   {
>>       struct kvm_pmu *pmu = vcpu_to_pmu(vcpu);
>> @@ -336,6 +350,11 @@ static int intel_pmu_set_msr(struct kvm_vcpu *vcpu, 
>> struct msr_data *msr_info)
>>           }
>>           vcpu->arch.perf_capabilities = data;
>>           return 0;
>> +    case MSR_IA32_DEBUGCTLMSR:
>> +        if (data & ~vcpu_get_supported_debugctl(vcpu))
>> +            return 1;
>> +        vmcs_write64(GUEST_IA32_DEBUGCTL, data);
>> +        return 0;
>>       default:
>>           if ((pmc = get_gp_pmc(pmu, msr, MSR_IA32_PERFCTR0)) ||
>>               (pmc = get_gp_pmc(pmu, msr, MSR_IA32_PMC0))) {
>> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
>> index 00c88c2f34e4..56f275eb4554 100644
>> --- a/arch/x86/kvm/x86.c
>> +++ b/arch/x86/kvm/x86.c
>> @@ -2840,18 +2840,6 @@ int kvm_set_msr_common(struct kvm_vcpu *vcpu, 
>> struct msr_data *msr_info)
>>               return 1;
>>           }
>>           break;
>> -    case MSR_IA32_DEBUGCTLMSR:
>> -        if (!data) {
>> -            /* We support the non-activated case already */
>> -            break;
>> -        } else if (data & ~(DEBUGCTLMSR_LBR | DEBUGCTLMSR_BTF)) {
>
> So after this patch, guest trying to set bit DEBUGCTLMSR_BTF will get a 
> #GP instead of being ignored and printing a log in kernel.
>

Since the BTF is not implemented on the KVM at all,
I do propose not left this kind of dummy thing in the future KVM code.

Let's see if Netware or any BTF user will complain about this change.

> These codes were introduced ~12 years ago in commit b5e2fec0ebc3 ("KVM: 
> Ignore DEBUGCTL MSRs with no effect"), just to make Netware happy. Maybe 
> I'm overthinking for that too old thing.
>
>> -            /* Values other than LBR and BTF are vendor-specific,
>> -               thus reserved and should throw a #GP */
>> -            return 1;
>> -        }
>> -        vcpu_unimpl(vcpu, "%s: MSR_IA32_DEBUGCTLMSR 0x%llx, nop\n",
>> -                __func__, data);
>> -        break;
>>       case 0x200 ... 0x2ff:
>>           return kvm_mtrr_set_msr(vcpu, msr, data);
>>       case MSR_IA32_APICBASE:
>> @@ -3120,7 +3108,6 @@ int kvm_get_msr_common(struct kvm_vcpu *vcpu, 
>> struct msr_data *msr_info)
>>       switch (msr_info->index) {
>>       case MSR_IA32_PLATFORM_ID:
>>       case MSR_IA32_EBL_CR_POWERON:
>> -    case MSR_IA32_DEBUGCTLMSR:
>>       case MSR_IA32_LASTBRANCHFROMIP:
>>       case MSR_IA32_LASTBRANCHTOIP:
>>       case MSR_IA32_LASTINTFROMIP:
>>
>

