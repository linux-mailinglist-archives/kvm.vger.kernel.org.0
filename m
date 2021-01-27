Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5F9E03052B9
	for <lists+kvm@lfdr.de>; Wed, 27 Jan 2021 07:03:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234667AbhA0GCl (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 27 Jan 2021 01:02:41 -0500
Received: from mga07.intel.com ([134.134.136.100]:6545 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232560AbhA0Fp4 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 27 Jan 2021 00:45:56 -0500
IronPort-SDR: tNlgcIO+UwJnPFPcA7C9xlxqq2bLeo8wPKs07rBwZERXi6DPw73zkfqg20uhunVKuLUSKPE53L
 w48rlnARKzOQ==
X-IronPort-AV: E=McAfee;i="6000,8403,9876"; a="244097037"
X-IronPort-AV: E=Sophos;i="5.79,378,1602572400"; 
   d="scan'208";a="244097037"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Jan 2021 21:45:13 -0800
IronPort-SDR: XIPxgouR/xvDcnhn09nAFREz1xZm0rMDUeLj0JUtqN20YocOzme60eJfXkrP4K0I1MscG30Efs
 twSlE75bRD/Q==
X-IronPort-AV: E=Sophos;i="5.79,378,1602572400"; 
   d="scan'208";a="388170074"
Received: from likexu-mobl1.ccr.corp.intel.com (HELO [10.238.4.93]) ([10.238.4.93])
  by orsmga008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Jan 2021 21:45:09 -0800
Subject: Re: [RESEND v13 09/10] KVM: vmx/pmu: Expose LBR_FMT in the
 MSR_IA32_PERF_CAPABILITIES
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Ingo Molnar <mingo@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Borislav Petkov <bp@alien8.de>,
        "H . Peter Anvin" <hpa@zytor.com>, ak@linux.intel.com,
        wei.w.wang@intel.com, kan.liang@intel.com, x86@kernel.org,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Joerg Roedel <joro@8bytes.org>,
        Jim Mattson <jmattson@google.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Like Xu <like.xu@linux.intel.com>,
        Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>
References: <20210108013704.134985-1-like.xu@linux.intel.com>
 <20210108013704.134985-10-like.xu@linux.intel.com>
 <2ff8ca5a-32ec-ca5d-50c3-d1690e933f6d@redhat.com>
From:   "Xu, Like" <like.xu@intel.com>
Message-ID: <fb4c3124-997b-5897-e38f-1b9aa782e5e2@intel.com>
Date:   Wed, 27 Jan 2021 13:45:07 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.1
MIME-Version: 1.0
In-Reply-To: <2ff8ca5a-32ec-ca5d-50c3-d1690e933f6d@redhat.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 2021/1/26 17:30, Paolo Bonzini wrote:
> On 08/01/21 02:37, Like Xu wrote:
>> Userspace could enable guest LBR feature when the exactly supported
>> LBR format value is initialized to the MSR_IA32_PERF_CAPABILITIES
>> and the LBR is also compatible with vPMU version and host cpu model.
>>
>> Signed-off-by: Like Xu <like.xu@linux.intel.com>
>> Reviewed-by: Andi Kleen <ak@linux.intel.com>
>> ---
>>   arch/x86/kvm/vmx/capabilities.h | 9 ++++++++-
>>   arch/x86/kvm/vmx/vmx.c          | 7 +++++++
>>   2 files changed, 15 insertions(+), 1 deletion(-)
>>
>> diff --git a/arch/x86/kvm/vmx/capabilities.h 
>> b/arch/x86/kvm/vmx/capabilities.h
>> index 57b940c613ab..a9a7c4d1b634 100644
>> --- a/arch/x86/kvm/vmx/capabilities.h
>> +++ b/arch/x86/kvm/vmx/capabilities.h
>> @@ -378,7 +378,14 @@ static inline u64 vmx_get_perf_capabilities(void)
>>        * Since counters are virtualized, KVM would support full
>>        * width counting unconditionally, even if the host lacks it.
>>        */
>> -    return PMU_CAP_FW_WRITES;
>> +    u64 perf_cap = PMU_CAP_FW_WRITES;
>> +
>> +    if (boot_cpu_has(X86_FEATURE_PDCM))
>> +        rdmsrl(MSR_IA32_PERF_CAPABILITIES, perf_cap);
>> +
>> +    perf_cap |= perf_cap & PMU_CAP_LBR_FMT;
>> +
>> +    return perf_cap;
>>   }
>>     static inline u64 vmx_supported_debugctl(void)
>> diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
>> index ad3b079f6700..9cb5b1e4fc27 100644
>> --- a/arch/x86/kvm/vmx/vmx.c
>> +++ b/arch/x86/kvm/vmx/vmx.c
>> @@ -2229,6 +2229,13 @@ static int vmx_set_msr(struct kvm_vcpu *vcpu, 
>> struct msr_data *msr_info)
>>       case MSR_IA32_PERF_CAPABILITIES:
>>           if (data && !vcpu_to_pmu(vcpu)->version)
>>               return 1;
>> +        if (data & PMU_CAP_LBR_FMT) {
>> +            if ((data & PMU_CAP_LBR_FMT) !=
>> +                (vmx_get_perf_capabilities() & PMU_CAP_LBR_FMT))
>> +                return 1;
>> +            if (!intel_pmu_lbr_is_compatible(vcpu))
>> +                return 1;
>> +        }
>>           ret = kvm_set_msr_common(vcpu, msr_info);
>>           break;
>>
>
> Please move this hunk to patch 4.
>
> Paolo
>
Thanks, I'll do this part early in the next version.

I would have thought that we need to
make the interface exposing as the last enabling step.
