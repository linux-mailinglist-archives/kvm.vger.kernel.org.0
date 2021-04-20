Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 02F25365424
	for <lists+kvm@lfdr.de>; Tue, 20 Apr 2021 10:30:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230500AbhDTIaz (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 20 Apr 2021 04:30:55 -0400
Received: from szxga08-in.huawei.com ([45.249.212.255]:3342 "EHLO
        szxga08-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230495AbhDTIaz (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 20 Apr 2021 04:30:55 -0400
Received: from DGGEML402-HUB.china.huawei.com (unknown [172.30.72.57])
        by szxga08-in.huawei.com (SkyGuard) with ESMTP id 4FPcGg3sCZz14JV1;
        Tue, 20 Apr 2021 16:26:35 +0800 (CST)
Received: from dggpeml500013.china.huawei.com (7.185.36.41) by
 DGGEML402-HUB.china.huawei.com (10.3.17.38) with Microsoft SMTP Server (TLS)
 id 14.3.498.0; Tue, 20 Apr 2021 16:30:21 +0800
Received: from [10.174.187.161] (10.174.187.161) by
 dggpeml500013.china.huawei.com (7.185.36.41) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256) id
 15.1.2176.2; Tue, 20 Apr 2021 16:30:20 +0800
Subject: Re: [PATCH v5 10/16] KVM: x86: Set PEBS_UNAVAIL in IA32_MISC_ENABLE
 when PEBS is enabled
To:     Like Xu <like.xu@linux.intel.com>, <peterz@infradead.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>
References: <20210415032016.166201-1-like.xu@linux.intel.com>
 <20210415032016.166201-11-like.xu@linux.intel.com>
CC:     <andi@firstfloor.org>, <kan.liang@linux.intel.com>,
        <wei.w.wang@intel.com>, <eranian@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, <kvm@vger.kernel.org>,
        <x86@kernel.org>, <linux-kernel@vger.kernel.org>,
        "Fangyi (Eric)" <eric.fangyi@huawei.com>,
        Xiexiangyou <xiexiangyou@huawei.com>
From:   Liuxiangdong <liuxiangdong5@huawei.com>
Message-ID: <607E911C.4090706@huawei.com>
Date:   Tue, 20 Apr 2021 16:30:20 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:38.0) Gecko/20100101
 Thunderbird/38.1.0
MIME-Version: 1.0
In-Reply-To: <20210415032016.166201-11-like.xu@linux.intel.com>
Content-Type: text/plain; charset="windows-1252"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.174.187.161]
X-ClientProxiedBy: dggeme712-chm.china.huawei.com (10.1.199.108) To
 dggpeml500013.china.huawei.com (7.185.36.41)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 2021/4/15 11:20, Like Xu wrote:
> The bit 12 represents "Processor Event Based Sampling Unavailable (RO)" :
> 	1 = PEBS is not supported.
> 	0 = PEBS is supported.
>
> A write to this PEBS_UNAVL available bit will bring #GP(0) when guest PEBS
> is enabled. Some PEBS drivers in guest may care about this bit.
>
> Signed-off-by: Like Xu <like.xu@linux.intel.com>
> ---
>   arch/x86/kvm/vmx/pmu_intel.c | 2 ++
>   arch/x86/kvm/x86.c           | 4 ++++
>   2 files changed, 6 insertions(+)
>
> diff --git a/arch/x86/kvm/vmx/pmu_intel.c b/arch/x86/kvm/vmx/pmu_intel.c
> index 58f32a55cc2e..c846d3eef7a7 100644
> --- a/arch/x86/kvm/vmx/pmu_intel.c
> +++ b/arch/x86/kvm/vmx/pmu_intel.c
> @@ -588,6 +588,7 @@ static void intel_pmu_refresh(struct kvm_vcpu *vcpu)
>   		bitmap_set(pmu->all_valid_pmc_idx, INTEL_PMC_IDX_FIXED_VLBR, 1);
>   
>   	if (vcpu->arch.perf_capabilities & PERF_CAP_PEBS_FORMAT) {
> +		vcpu->arch.ia32_misc_enable_msr &= ~MSR_IA32_MISC_ENABLE_PEBS_UNAVAIL;
>   		if (vcpu->arch.perf_capabilities & PERF_CAP_PEBS_BASELINE) {
>   			pmu->pebs_enable_mask = ~pmu->global_ctrl;
>   			pmu->reserved_bits &= ~ICL_EVENTSEL_ADAPTIVE;
> @@ -597,6 +598,7 @@ static void intel_pmu_refresh(struct kvm_vcpu *vcpu)
>   			}
>   			pmu->pebs_data_cfg_mask = ~0xff00000full;
>   		} else {
> +			vcpu->arch.ia32_misc_enable_msr |= MSR_IA32_MISC_ENABLE_PEBS_UNAVAIL;
>   			pmu->pebs_enable_mask =
>   				~((1ull << pmu->nr_arch_gp_counters) - 1);
>   		}

I guess what we want is

         if (vcpu->arch.perf_capabilities & PERF_CAP_PEBS_FORMAT) {
                 vcpu->arch.ia32_misc_enable_msr &= 
~MSR_IA32_MISC_ENABLE_PEBS_UNAVAIL;
                 if (vcpu->arch.perf_capabilities & 
PERF_CAP_PEBS_BASELINE) {
                         pmu->pebs_enable_mask = ~pmu->global_ctrl;
                         pmu->reserved_bits &= ~ICL_EVENTSEL_ADAPTIVE;
                         for (i = 0; i < pmu->nr_arch_fixed_counters; i++) {
                                 pmu->fixed_ctr_ctrl_mask &=
                                         ~(1ULL << (INTEL_PMC_IDX_FIXED 
+ i * 4));
                         }
                         pmu->pebs_data_cfg_mask = ~0xff00000full;
                 } else {
                         pmu->pebs_enable_mask =
                                 ~((1ull << pmu->nr_arch_gp_counters) - 1);
                 }
         } else {
                 vcpu->arch.ia32_misc_enable_msr |= 
MSR_IA32_MISC_ENABLE_PEBS_UNAVAIL;
                 vcpu->arch.perf_capabilities &= ~PERF_CAP_PEBS_MASK;
         }


But here is

         if (vcpu->arch.perf_capabilities & PERF_CAP_PEBS_FORMAT) {
                 vcpu->arch.ia32_misc_enable_msr &= 
~MSR_IA32_MISC_ENABLE_PEBS_UNAVAIL;
                 if (vcpu->arch.perf_capabilities & 
PERF_CAP_PEBS_BASELINE) {
                         pmu->pebs_enable_mask = ~pmu->global_ctrl;
                         pmu->reserved_bits &= ~ICL_EVENTSEL_ADAPTIVE;
                         for (i = 0; i < pmu->nr_arch_fixed_counters; i++) {
                                 pmu->fixed_ctr_ctrl_mask &=
                                         ~(1ULL << (INTEL_PMC_IDX_FIXED 
+ i * 4));
                         }
                         pmu->pebs_data_cfg_mask = ~0xff00000full;
                 } else {
                         vcpu->arch.ia32_misc_enable_msr |= 
MSR_IA32_MISC_ENABLE_PEBS_UNAVAIL;
                         pmu->pebs_enable_mask =
                                 ~((1ull << pmu->nr_arch_gp_counters) - 1);
                 }
         } else {
                 vcpu->arch.perf_capabilities &= ~PERF_CAP_PEBS_MASK;
         }


Wrong else branch?


> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index 1a64e816e06d..ed38f1dada63 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -3126,6 +3126,10 @@ int kvm_set_msr_common(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
>   		break;
>   	case MSR_IA32_MISC_ENABLE:
>   		data &= ~MSR_IA32_MISC_ENABLE_EMON;
> +		if (!msr_info->host_initiated &&
> +		    (vcpu->arch.perf_capabilities & PERF_CAP_PEBS_FORMAT) &&
> +		    (data & MSR_IA32_MISC_ENABLE_PEBS_UNAVAIL))
> +			return 1;
>   		if (!kvm_check_has_quirk(vcpu->kvm, KVM_X86_QUIRK_MISC_ENABLE_NO_MWAIT) &&
>   		    ((vcpu->arch.ia32_misc_enable_msr ^ data) & MSR_IA32_MISC_ENABLE_MWAIT)) {
>   			if (!guest_cpuid_has(vcpu, X86_FEATURE_XMM3))

