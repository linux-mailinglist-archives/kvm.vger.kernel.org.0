Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B3A0937B53B
	for <lists+kvm@lfdr.de>; Wed, 12 May 2021 07:00:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230111AbhELFBb (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 12 May 2021 01:01:31 -0400
Received: from mga12.intel.com ([192.55.52.136]:62358 "EHLO mga12.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229730AbhELFBb (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 12 May 2021 01:01:31 -0400
IronPort-SDR: BHgET79TguYm7IfA9QmKcS/i7PmhqUJWcUoNmF4r9MsEVCfYVoDCSKlM7vPP4nm9/mCm1SBVez
 AkDgQyNE2NRg==
X-IronPort-AV: E=McAfee;i="6200,9189,9981"; a="179211622"
X-IronPort-AV: E=Sophos;i="5.82,293,1613462400"; 
   d="scan'208";a="179211622"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 May 2021 22:00:23 -0700
IronPort-SDR: MGnaFeC8SGot2dzUNyVXV8muw+3o/BVLW+i34rxzYRdo72YFfl3s9f8Lsge7nGyoXU9t9FaO4f
 WAgRKYnFVRdw==
X-IronPort-AV: E=Sophos;i="5.82,293,1613462400"; 
   d="scan'208";a="437014682"
Received: from likexu-mobl1.ccr.corp.intel.com (HELO [10.238.4.93]) ([10.238.4.93])
  by orsmga008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 May 2021 22:00:18 -0700
Subject: Re: [PATCH v6 04/16] KVM: x86/pmu: Set MSR_IA32_MISC_ENABLE_EMON bit
 when vPMU is enabled
To:     Venkatesh Srinivas <venkateshs@chromium.org>
Cc:     Peter Zijlstra <peterz@infradead.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Borislav Petkov <bp@alien8.de>,
        Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, weijiang.yang@intel.com,
        Kan Liang <kan.liang@linux.intel.com>, ak@linux.intel.com,
        wei.w.wang@intel.com, eranian@google.com, liuxiangdong5@huawei.com,
        linux-kernel@vger.kernel.org, x86@kernel.org, kvm@vger.kernel.org,
        Yao Yuan <yuan.yao@intel.com>,
        Like Xu <like.xu@linux.intel.com>
References: <20210511024214.280733-1-like.xu@linux.intel.com>
 <20210511024214.280733-5-like.xu@linux.intel.com>
 <CAA0tLErUFPnZ=SL82bLe8Ddf5rFu2Pdv5xE0aq4A91mzn9=ABA@mail.gmail.com>
From:   "Xu, Like" <like.xu@intel.com>
Message-ID: <ead61a83-1534-a8a6-13ee-646898a6d1a9@intel.com>
Date:   Wed, 12 May 2021 13:00:16 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <CAA0tLErUFPnZ=SL82bLe8Ddf5rFu2Pdv5xE0aq4A91mzn9=ABA@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Venkatesh Srinivas,

On 2021/5/12 9:58, Venkatesh Srinivas wrote:
> On 5/10/21, Like Xu <like.xu@linux.intel.com> wrote:
>> On Intel platforms, the software can use the IA32_MISC_ENABLE[7] bit to
>> detect whether the processor supports performance monitoring facility.
>>
>> It depends on the PMU is enabled for the guest, and a software write
>> operation to this available bit will be ignored.
> Is the behavior that writes to IA32_MISC_ENABLE[7] are ignored (rather than #GP)
> documented someplace?

The bit[7] behavior of the real hardware on the native host is quite 
suspicious.

To keep the semantics consistent and simple, we propose ignoring write 
operation
in the virtualized world, since whether or not to expose PMU is configured 
by the
hypervisor user space and not by the guest side.

I assume your "reviewed-by" also points this out. Thanks.

>
> Reviewed-by: Venkatesh Srinivas <venkateshs@chromium.org>
>
>> Cc: Yao Yuan <yuan.yao@intel.com>
>> Signed-off-by: Like Xu <like.xu@linux.intel.com>
>> ---
>>   arch/x86/kvm/vmx/pmu_intel.c | 1 +
>>   arch/x86/kvm/x86.c           | 1 +
>>   2 files changed, 2 insertions(+)
>>
>> diff --git a/arch/x86/kvm/vmx/pmu_intel.c b/arch/x86/kvm/vmx/pmu_intel.c
>> index 9efc1a6b8693..d9dbebe03cae 100644
>> --- a/arch/x86/kvm/vmx/pmu_intel.c
>> +++ b/arch/x86/kvm/vmx/pmu_intel.c
>> @@ -488,6 +488,7 @@ static void intel_pmu_refresh(struct kvm_vcpu *vcpu)
>>   	if (!pmu->version)
>>   		return;
>>
>> +	vcpu->arch.ia32_misc_enable_msr |= MSR_IA32_MISC_ENABLE_EMON;
>>   	perf_get_x86_pmu_capability(&x86_pmu);
>>
>>   	pmu->nr_arch_gp_counters = min_t(int, eax.split.num_counters,
>> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
>> index 5bd550eaf683..abe3ea69078c 100644
>> --- a/arch/x86/kvm/x86.c
>> +++ b/arch/x86/kvm/x86.c
>> @@ -3211,6 +3211,7 @@ int kvm_set_msr_common(struct kvm_vcpu *vcpu, struct
>> msr_data *msr_info)
>>   		}
>>   		break;
>>   	case MSR_IA32_MISC_ENABLE:
>> +		data &= ~MSR_IA32_MISC_ENABLE_EMON;
>>   		if (!kvm_check_has_quirk(vcpu->kvm, KVM_X86_QUIRK_MISC_ENABLE_NO_MWAIT)
>> &&
>>   		    ((vcpu->arch.ia32_misc_enable_msr ^ data) &
>> MSR_IA32_MISC_ENABLE_MWAIT)) {
>>   			if (!guest_cpuid_has(vcpu, X86_FEATURE_XMM3))
>> --
>> 2.31.1
>>
>>

