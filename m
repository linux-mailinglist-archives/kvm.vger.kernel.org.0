Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 645D530A181
	for <lists+kvm@lfdr.de>; Mon,  1 Feb 2021 06:40:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231555AbhBAFj1 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 1 Feb 2021 00:39:27 -0500
Received: from mga01.intel.com ([192.55.52.88]:48550 "EHLO mga01.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231410AbhBAFgu (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 1 Feb 2021 00:36:50 -0500
IronPort-SDR: tJKfS56OPjX6k/R1qzPXtOIigjKUlx7+fsVfcNJTu6v/aSEPoSPaxABXZ7OcKZ/VPRJywTgh7l
 ynRIi0uguj9w==
X-IronPort-AV: E=McAfee;i="6000,8403,9881"; a="199525906"
X-IronPort-AV: E=Sophos;i="5.79,391,1602572400"; 
   d="scan'208";a="199525906"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 31 Jan 2021 21:29:03 -0800
IronPort-SDR: gg71IwCmrKZtS0DvWtia3QUhihLapWAOr9gl1gKI9AoC6tmH4ejmOqsdL6AaN3id2MahUgD2hk
 5rGAPHOqbJ5w==
X-IronPort-AV: E=Sophos;i="5.79,391,1602572400"; 
   d="scan'208";a="390696394"
Received: from likexu-mobl1.ccr.corp.intel.com (HELO [10.238.4.93]) ([10.238.4.93])
  by orsmga008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 31 Jan 2021 21:28:59 -0800
Subject: Re: [RESEND v13 03/10] KVM: x86/pmu: Use IA32_PERF_CAPABILITIES to
 adjust features visibility
From:   Like Xu <like.xu@linux.intel.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Ingo Molnar <mingo@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Borislav Petkov <bp@alien8.de>,
        "H . Peter Anvin" <hpa@zytor.com>, ak@linux.intel.com,
        wei.w.wang@intel.com, kan.liang@intel.com, x86@kernel.org,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Joerg Roedel <joro@8bytes.org>,
        Jim Mattson <jmattson@google.com>,
        Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>
References: <20210108013704.134985-1-like.xu@linux.intel.com>
 <20210108013704.134985-4-like.xu@linux.intel.com>
 <a1291d0b-297c-9146-9689-f4a4129de3c6@redhat.com>
 <fd7df596-9715-e6a8-0040-18aecedb0fae@linux.intel.com>
Organization: Intel OTC
Message-ID: <01d94530-000f-f80d-d2b7-4c1bf882d2a7@linux.intel.com>
Date:   Mon, 1 Feb 2021 13:28:57 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.0
MIME-Version: 1.0
In-Reply-To: <fd7df596-9715-e6a8-0040-18aecedb0fae@linux.intel.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Paolo,

On 2021/1/27 14:04, Like Xu wrote:
> On 2021/1/26 17:42, Paolo Bonzini wrote:
>> On 08/01/21 02:36, Like Xu wrote:
>>>
>>> @@ -401,6 +398,9 @@ static void intel_pmu_init(struct kvm_vcpu *vcpu)
>>>          pmu->fixed_counters[i].idx = i + INTEL_PMC_IDX_FIXED;
>>>          pmu->fixed_counters[i].current_config = 0;
>>>      }
>>> +
>>> +    vcpu->arch.perf_capabilities = guest_cpuid_has(vcpu, 
>>> X86_FEATURE_PDCM) ?
>>> +        vmx_get_perf_capabilities() : 0;
>>
>> There is one thing I don't understand with this patch: intel_pmu_init is 
>> not called when CPUID is changed.  So I would have thought that anything 
>> that uses guest_cpuid_has must stay in intel_pmu_refresh.  As I 
>> understand it vcpu->arch.perf_capabilities is always set to 0 
>> (vmx_get_perf_capabilities is never called), and kvm_set_msr_common 
>> would fail to set any bit in the MSR.  What am I missing?
>>
>> In addition, the code of patch 4:
>>
>> +    if (!intel_pmu_lbr_is_enabled(vcpu)) {
>> +        vcpu->arch.perf_capabilities &= ~PMU_CAP_LBR_FMT;
>> +        lbr_desc->records.nr = 0;
>> +    }
>>
>> is not okay after MSR changes.  The value written by the host must be 
>> either rejected (with "return 1") or applied unchanged.
>>
>> Fortunately I think this code is dead if you move the check in 
>> kvm_set_msr from patch 9 to patch 4.  However, in patch 9 
>> vmx_get_perf_capabilities() must only set the LBR format bits if 
>> intel_pmu_lbr_is_compatible(vcpu).
>
> Thanks for the guidance. How about handling it in this way:
>
> In the intel_pmu_init():
>
>     vcpu->arch.perf_capabilities = 0;
>     lbr_desc->records.nr = 0;
>
> In the intel_pmu_refresh():
>
>     if (guest_cpuid_has(vcpu, X86_FEATURE_PDCM)) {
>         vcpu->arch.perf_capabilities = vmx_get_perf_capabilities();
>         if (!lbr_desc->records.nr)
>             vcpu->arch.perf_capabilities &= ~PMU_CAP_LBR_FMT;
>     }
>
> In the vmx_set_msr():
>
>     case MSR_IA32_PERF_CAPABILITIES:
>         // set up lbr_desc->records.nr
>         if (!intel_pmu_lbr_is_compatible(vcpu))
>             return 1;
>         ret = kvm_set_msr_common(vcpu, msr_info);
>
> In the kvm_set_msr_common():
>
>     case MSR_IA32_PERF_CAPABILITIES:
>         vcpu->arch.perf_capabilities = data;
>         kvm_pmu_refresh(vcpu);

The new version will make the vcpu->arch.perf_capabilities crud as simple 
as possible.

>
>>
>>
>> The patches look good apart from these issues and the other nits I 
>> pointed out.  However, you need testcases here, for both kvm-unit-tests 
>> and tools/testing/selftests/kvm.
>>
>> For KVM, it would be at least a basic check that looks for the MSR LBR 
>> (using the MSR indices for the various processors), does a branch, and 
>> checks that the FROM_IP/TO_IP are good.  You can write the 
>> kvm-unit-tests using the QEMU option "-cpu host,migratable=no": if you 
>> do this, QEMU will pick the KVM_GET_SUPPORTED_CPUID bits and move them 
>> more or less directly into the guest CPUID.
>>
>> For tools/testing/selftests/kvm, your test need to check the effect of 
>> various CPUID settings on the PERF_CAPABILITIES MSR, check that whatever 
>> you write with KVM_SET_MSR is _not_ modified and can be retrieved with 
>> KVM_GET_MSR, and check that invalid LBR formats are rejected.
>
> Thanks, I will add the above tests in the next version.
>
>>
>> I'm really, really sorry for leaving these patches on my todo list for 
>> months, but you guys need to understand the main reason for this: they 
>> come with no testcases.  A large patch series adding userspace APIs and 
>> complicated CPUID/MSR processing *automatically* goes to the bottom of 
>> my queue, because:

Please review the new version 
https://lore.kernel.org/kvm/20210201051039.255478-1-like.xu@linux.intel.com/T/#t
and kvm-unit-tests: 
https://lore.kernel.org/kvm/20210201045751.243231-1-like.xu@linux.intel.com,
in case the patch set is not *automatically* processed to the bottom of 
your queue.

I'll also add tests for other new vPMU features.

---
thx, likexu

>>
>> - I need to go with a fine comb over all the userspace API changes, I 
>> cannot just look at test code and see if it works.
>>
>> - I will have no way to test its correctness after it's committed.
>>
>> For you, the work ends when your patch is accepted.  For me, that's when 
>> the work begins, and I need to make sure that the patch will be 
>> maintainable in the future.
>>
>> Thanks, and sorry again for the delay.
>>
>> Paolo
>>
>

