Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C03D737F16F
	for <lists+kvm@lfdr.de>; Thu, 13 May 2021 04:50:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230364AbhEMCwE (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 12 May 2021 22:52:04 -0400
Received: from mga11.intel.com ([192.55.52.93]:15460 "EHLO mga11.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229745AbhEMCwC (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 12 May 2021 22:52:02 -0400
IronPort-SDR: 6uSWLJ+A8r+KgKYftq3Ju/PH8PmJv7vBUYl8ODO/lBpUbdOtIOHAuoHLdZ1Dp6dILxDym4uuSD
 86RPaStwx0Zw==
X-IronPort-AV: E=McAfee;i="6200,9189,9982"; a="196761692"
X-IronPort-AV: E=Sophos;i="5.82,296,1613462400"; 
   d="scan'208";a="196761692"
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 May 2021 19:50:50 -0700
IronPort-SDR: 6rmxe/j+8FY1jJu5OoDnevBHx6jzZIeJxnDX74H92iE5f9tYHRRrAmOnvBnI4HGk3IYilCgBEo
 R0Sdxsp62FqQ==
X-IronPort-AV: E=Sophos;i="5.82,296,1613462400"; 
   d="scan'208";a="623066848"
Received: from likexu-mobl1.ccr.corp.intel.com (HELO [10.238.4.93]) ([10.238.4.93])
  by fmsmga006-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 May 2021 19:50:44 -0700
Subject: Re: [PATCH v6 04/16] KVM: x86/pmu: Set MSR_IA32_MISC_ENABLE_EMON bit
 when vPMU is enabled
To:     Sean Christopherson <seanjc@google.com>
Cc:     Venkatesh Srinivas <venkateshs@chromium.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Borislav Petkov <bp@alien8.de>,
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
 <ead61a83-1534-a8a6-13ee-646898a6d1a9@intel.com>
 <YJvx4tr2iXo4bQ/d@google.com>
From:   "Xu, Like" <like.xu@intel.com>
Message-ID: <5ef2215b-1c43-fc8a-42ef-46c22e093f40@intel.com>
Date:   Thu, 13 May 2021 10:50:42 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <YJvx4tr2iXo4bQ/d@google.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 2021/5/12 23:18, Sean Christopherson wrote:
> On Wed, May 12, 2021, Xu, Like wrote:
>> Hi Venkatesh Srinivas,
>>
>> On 2021/5/12 9:58, Venkatesh Srinivas wrote:
>>> On 5/10/21, Like Xu <like.xu@linux.intel.com> wrote:
>>>> On Intel platforms, the software can use the IA32_MISC_ENABLE[7] bit to
>>>> detect whether the processor supports performance monitoring facility.
>>>>
>>>> It depends on the PMU is enabled for the guest, and a software write
>>>> operation to this available bit will be ignored.
>>> Is the behavior that writes to IA32_MISC_ENABLE[7] are ignored (rather than #GP)
>>> documented someplace?
>> The bit[7] behavior of the real hardware on the native host is quite
>> suspicious.
> Ugh.  Can you file an SDM bug to get the wording and accessibility updated?  The
> current phrasing is a mess:
>
>    Performance Monitoring Available (R)
>    1 = Performance monitoring enabled.
>    0 = Performance monitoring disabled.
>
> The (R) is ambiguous because most other entries that are read-only use (RO), and
> the "enabled vs. disabled" implies the bit is writable and really does control
> the PMU.  But on my Haswell system, it's read-only.

On your Haswell system, does it cause #GP or just silent if you change this 
bit ?

> Assuming the bit is supposed
> to be a read-only "PMU supported bit", the SDM should be:
>
>    Performance Monitoring Available (RO)
>    1 = Performance monitoring supported.
>    0 = Performance monitoring not supported.
>
> And please update the changelog to explain the "why" of whatever the behavior
> ends up being.  The "what" is obvious from the code.

Thanks for your "why" comment.

>
>> To keep the semantics consistent and simple, we propose ignoring write
>> operation in the virtualized world, since whether or not to expose PMU is
>> configured by the hypervisor user space and not by the guest side.
> Making up our own architectural behavior because it's convient is not a good
> idea.

Sometime we do change it.

For example, the scope of some msrs may be "core level share"
but we likely keep it as a "thread level" variable in the KVM out of 
convenience.

>
>>>> diff --git a/arch/x86/kvm/vmx/pmu_intel.c b/arch/x86/kvm/vmx/pmu_intel.c
>>>> index 9efc1a6b8693..d9dbebe03cae 100644
>>>> --- a/arch/x86/kvm/vmx/pmu_intel.c
>>>> +++ b/arch/x86/kvm/vmx/pmu_intel.c
>>>> @@ -488,6 +488,7 @@ static void intel_pmu_refresh(struct kvm_vcpu *vcpu)
>>>>    	if (!pmu->version)
>>>>    		return;
>>>>
>>>> +	vcpu->arch.ia32_misc_enable_msr |= MSR_IA32_MISC_ENABLE_EMON;
> Hmm, normally I would say overwriting the guest's value is a bad idea, but if
> the bit really is a read-only "PMU supported" bit, then this is the correct
> behavior, albeit weird if userspace does a late CPUID update (though that's
> weird no matter what).
>
>>>>    	perf_get_x86_pmu_capability(&x86_pmu);
>>>>
>>>>    	pmu->nr_arch_gp_counters = min_t(int, eax.split.num_counters,
>>>> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
>>>> index 5bd550eaf683..abe3ea69078c 100644
>>>> --- a/arch/x86/kvm/x86.c
>>>> +++ b/arch/x86/kvm/x86.c
>>>> @@ -3211,6 +3211,7 @@ int kvm_set_msr_common(struct kvm_vcpu *vcpu, struct
>>>> msr_data *msr_info)
>>>>    		}
>>>>    		break;
>>>>    	case MSR_IA32_MISC_ENABLE:
>>>> +		data &= ~MSR_IA32_MISC_ENABLE_EMON;
> However, this is not.  If it's a read-only bit, then toggling the bit should
> cause a #GP.

The proposal here is trying to make it as an
unchangeable bit and don't make it #GP if guest changes it.

It may different from the host behavior but
it doesn't cause potential issue if some guest code
changes it during the use of performance monitoring.

Does this make sense to you or do you want to
keep it strictly the same as the host side?

>
>>>>    		if (!kvm_check_has_quirk(vcpu->kvm, KVM_X86_QUIRK_MISC_ENABLE_NO_MWAIT)
>>>> &&
>>>>    		    ((vcpu->arch.ia32_misc_enable_msr ^ data) &
>>>> MSR_IA32_MISC_ENABLE_MWAIT)) {
>>>>    			if (!guest_cpuid_has(vcpu, X86_FEATURE_XMM3))
>>>> --

