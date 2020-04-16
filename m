Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D6F211AC681
	for <lists+kvm@lfdr.de>; Thu, 16 Apr 2020 16:41:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2394398AbgDPOkl (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 16 Apr 2020 10:40:41 -0400
Received: from mga03.intel.com ([134.134.136.65]:50382 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2394351AbgDPOkj (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 16 Apr 2020 10:40:39 -0400
IronPort-SDR: 5ZwiseOLGGV7W6Xrx/u+UqMxZwFgbKjo5HnNoIVwhjMp7fqEC+ve2VW5D6CfPNTRqoxSUthA/h
 boBs2gur9zAg==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Apr 2020 07:40:38 -0700
IronPort-SDR: JlyUbcayvN+Dj+yHk3BwZbC7Z2ryIM8yYu4rP6QhWbWfaF5YBMD2Lr5znLtlb70WzbL61zGkdr
 /V2Q4Gh+5E+w==
X-IronPort-AV: E=Sophos;i="5.72,391,1580803200"; 
   d="scan'208";a="427852526"
Received: from likexu-mobl1.ccr.corp.intel.com (HELO [10.249.170.42]) ([10.249.170.42])
  by orsmga005-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Apr 2020 07:40:36 -0700
Subject: Re: [PATCH] KVM: x86/pmu: Support full width counting
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Andi Kleen <ak@linux.intel.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20200408135325.3160-1-like.xu@linux.intel.com>
From:   Like Xu <like.xu@linux.intel.com>
Organization: Intel OTC
Message-ID: <89f5464e-3bff-898f-f407-28dbba36aa60@linux.intel.com>
Date:   Thu, 16 Apr 2020 22:40:34 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.7.0
MIME-Version: 1.0
In-Reply-To: <20200408135325.3160-1-like.xu@linux.intel.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Paolo,

If there is anything needs to be improved for this patch,
please let me know.

Thanks,
Like Xu

On 2020/4/8 21:53, Like Xu wrote:
> Intel CPUs have a new alternative MSR range (starting from MSR_IA32_PMC0)
> for GP counters that allows writing the full counter width. Enable this
> range from a new capability bit (IA32_PERF_CAPABILITIES.FW_WRITE[bit 13]).
> 
> The perf driver queries CPUID to get the counter width, and sign extends
> the counter values as needed. The traditional MSRs always limit to 32bit,
> even though the counter internally is larger (usually 48 bits).
> 
> When the new capability is set, use the alternative range which do not
> have these restrictions. This lowers the overhead of perf stat slightly
> because it has to do less interrupts to accumulate the counter value.
> 
> Signed-off-by: Like Xu <like.xu@linux.intel.com>
> ---
>   arch/x86/include/asm/kvm_host.h |  1 +
>   arch/x86/kvm/vmx/capabilities.h | 15 +++++++++++++
>   arch/x86/kvm/vmx/pmu_intel.c    | 38 +++++++++++++++++++++++++++------
>   arch/x86/kvm/vmx/vmx.c          |  2 ++
>   4 files changed, 50 insertions(+), 6 deletions(-)
> 
> diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
> index 42a2d0d3984a..1c2e3e79490b 100644
> --- a/arch/x86/include/asm/kvm_host.h
> +++ b/arch/x86/include/asm/kvm_host.h
> @@ -481,6 +481,7 @@ struct kvm_pmu {
>   	u64 counter_bitmask[2];
>   	u64 global_ctrl_mask;
>   	u64 global_ovf_ctrl_mask;
> +	u64 perf_capabilities;
>   	u64 reserved_bits;
>   	u8 version;
>   	struct kvm_pmc gp_counters[INTEL_PMC_MAX_GENERIC];
> diff --git a/arch/x86/kvm/vmx/capabilities.h b/arch/x86/kvm/vmx/capabilities.h
> index 8903475f751e..3624568633bd 100644
> --- a/arch/x86/kvm/vmx/capabilities.h
> +++ b/arch/x86/kvm/vmx/capabilities.h
> @@ -367,4 +367,19 @@ static inline bool vmx_pt_mode_is_host_guest(void)
>   	return pt_mode == PT_MODE_HOST_GUEST;
>   }
>   
> +#define PMU_CAP_FW_WRITE	(1ULL << 13)
> +
> +static inline u64 vmx_supported_perf_capabilities(void)
> +{
> +	u64 perf_cap = 0;
> +
> +	if (boot_cpu_has(X86_FEATURE_PDCM))
> +		rdmsrl(MSR_IA32_PERF_CAPABILITIES, perf_cap);
> +
> +	/* Currently, KVM only support Full-Width Writes. */
> +	perf_cap &= PMU_CAP_FW_WRITE;
> +
> +	return perf_cap;
> +}
> +
>   #endif /* __KVM_X86_VMX_CAPS_H */
> diff --git a/arch/x86/kvm/vmx/pmu_intel.c b/arch/x86/kvm/vmx/pmu_intel.c
> index 7c857737b438..99563d1ec854 100644
> --- a/arch/x86/kvm/vmx/pmu_intel.c
> +++ b/arch/x86/kvm/vmx/pmu_intel.c
> @@ -150,6 +150,12 @@ static struct kvm_pmc *intel_rdpmc_ecx_to_pmc(struct kvm_vcpu *vcpu,
>   	return &counters[array_index_nospec(idx, num_counters)];
>   }
>   
> +static inline bool full_width_writes_is_enabled(struct kvm_pmu *pmu)
> +{
> +	return (vmx_supported_perf_capabilities() & PMU_CAP_FW_WRITE) &&
> +		(pmu->perf_capabilities & PMU_CAP_FW_WRITE);
> +}
> +
>   static bool intel_is_valid_msr(struct kvm_vcpu *vcpu, u32 msr)
>   {
>   	struct kvm_pmu *pmu = vcpu_to_pmu(vcpu);
> @@ -162,10 +168,15 @@ static bool intel_is_valid_msr(struct kvm_vcpu *vcpu, u32 msr)
>   	case MSR_CORE_PERF_GLOBAL_OVF_CTRL:
>   		ret = pmu->version > 1;
>   		break;
> +	case MSR_IA32_PERF_CAPABILITIES:
> +		ret = guest_cpuid_has(vcpu, X86_FEATURE_PDCM);
> +		break;
>   	default:
>   		ret = get_gp_pmc(pmu, msr, MSR_IA32_PERFCTR0) ||
>   			get_gp_pmc(pmu, msr, MSR_P6_EVNTSEL0) ||
> -			get_fixed_pmc(pmu, msr);
> +			get_fixed_pmc(pmu, msr) ||
> +			(get_gp_pmc(pmu, msr, MSR_IA32_PMC0) &&
> +				full_width_writes_is_enabled(pmu));
>   		break;
>   	}
>   
> @@ -202,8 +213,12 @@ static int intel_pmu_get_msr(struct kvm_vcpu *vcpu, u32 msr, u64 *data)
>   	case MSR_CORE_PERF_GLOBAL_OVF_CTRL:
>   		*data = pmu->global_ovf_ctrl;
>   		return 0;
> +	case MSR_IA32_PERF_CAPABILITIES:
> +		*data = pmu->perf_capabilities;
> +		return 0;
>   	default:
> -		if ((pmc = get_gp_pmc(pmu, msr, MSR_IA32_PERFCTR0))) {
> +		if ((pmc = get_gp_pmc(pmu, msr, MSR_IA32_PERFCTR0))
> +			|| (pmc = get_gp_pmc(pmu, msr, MSR_IA32_PMC0))) {
>   			u64 val = pmc_read_counter(pmc);
>   			*data = val & pmu->counter_bitmask[KVM_PMC_GP];
>   			return 0;
> @@ -258,9 +273,13 @@ static int intel_pmu_set_msr(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
>   			return 0;
>   		}
>   		break;
> +	case MSR_IA32_PERF_CAPABILITIES:
> +		return 1; /* RO MSR */
>   	default:
> -		if ((pmc = get_gp_pmc(pmu, msr, MSR_IA32_PERFCTR0))) {
> -			if (!msr_info->host_initiated)
> +		if ((pmc = get_gp_pmc(pmu, msr, MSR_IA32_PERFCTR0))
> +			|| (pmc = get_gp_pmc(pmu, msr, MSR_IA32_PMC0))) {
> +			if (!msr_info->host_initiated &&
> +				!full_width_writes_is_enabled(pmu))
>   				data = (s64)(s32)data;
>   			pmc->counter += data - pmc_read_counter(pmc);
>   			if (pmc->perf_event)
> @@ -303,15 +322,18 @@ static void intel_pmu_refresh(struct kvm_vcpu *vcpu)
>   
>   	entry = kvm_find_cpuid_entry(vcpu, 0xa, 0);
>   	if (!entry)
> -		return;
> +		goto end;
>   	eax.full = entry->eax;
>   	edx.full = entry->edx;
>   
>   	pmu->version = eax.split.version_id;
>   	if (!pmu->version)
> -		return;
> +		goto end;
>   
>   	perf_get_x86_pmu_capability(&x86_pmu);
> +	pmu->perf_capabilities = vmx_supported_perf_capabilities();
> +	if (!pmu->perf_capabilities)
> +		guest_cpuid_clear(vcpu, X86_FEATURE_PDCM);
>   
>   	pmu->nr_arch_gp_counters = min_t(int, eax.split.num_counters,
>   					 x86_pmu.num_counters_gp);
> @@ -351,6 +373,10 @@ static void intel_pmu_refresh(struct kvm_vcpu *vcpu)
>   		INTEL_PMC_MAX_GENERIC, pmu->nr_arch_fixed_counters);
>   
>   	nested_vmx_pmu_entry_exit_ctls_update(vcpu);
> +	return;
> +
> +end:
> +	guest_cpuid_clear(vcpu, X86_FEATURE_PDCM);
>   }
>   
>   static void intel_pmu_init(struct kvm_vcpu *vcpu)
> diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
> index 4f844257a72d..abc0f15a4de5 100644
> --- a/arch/x86/kvm/vmx/vmx.c
> +++ b/arch/x86/kvm/vmx/vmx.c
> @@ -7112,6 +7112,8 @@ static __init void vmx_set_cpu_caps(void)
>   		kvm_cpu_cap_check_and_set(X86_FEATURE_INVPCID);
>   	if (vmx_pt_mode_is_host_guest())
>   		kvm_cpu_cap_check_and_set(X86_FEATURE_INTEL_PT);
> +	if (vmx_supported_perf_capabilities())
> +		kvm_cpu_cap_check_and_set(X86_FEATURE_PDCM);
>   
>   	/* PKU is not yet implemented for shadow paging. */
>   	if (enable_ept && boot_cpu_has(X86_FEATURE_OSPKE))
> 

