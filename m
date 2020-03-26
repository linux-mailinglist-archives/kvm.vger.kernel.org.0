Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 07F3E193F2B
	for <lists+kvm@lfdr.de>; Thu, 26 Mar 2020 13:48:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728205AbgCZMr6 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 26 Mar 2020 08:47:58 -0400
Received: from mga18.intel.com ([134.134.136.126]:16947 "EHLO mga18.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727841AbgCZMr5 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 26 Mar 2020 08:47:57 -0400
IronPort-SDR: 7WQ/DVEfSuuuJ3MO3WQeXL8T/8epGDim1PVVmvtCBKg+uvtDnP7wCWZ/0KPE4930UYEIQejHHj
 UreKrO+Med0g==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Mar 2020 05:47:57 -0700
IronPort-SDR: 4MeGnowaMGpgEa9Oj0vOqTX6OTJWRFj2MYMvitJ08h0w8rixQahEakV1Y57nrNbL7Iv7suTABP
 oZzd3Exx34kg==
X-IronPort-AV: E=Sophos;i="5.72,308,1580803200"; 
   d="scan'208";a="420687679"
Received: from likexu-mobl1.ccr.corp.intel.com (HELO [10.249.175.106]) ([10.249.175.106])
  by orsmga005-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Mar 2020 05:47:54 -0700
Subject: Re: [PATCH v2] KVM: x86/pmu: Reduce counter period change overhead
 and delay the effective time
To:     pbonzini@redhat.com
Cc:     ehankland@google.com, jmattson@google.com, joro@8bytes.org,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        sean.j.christopherson@intel.com, vkuznets@redhat.com,
        wanpengli@tencent.com
References: <20200317075315.70933-1-like.xu@linux.intel.com>
 <20200317081458.88714-1-like.xu@linux.intel.com>
From:   Like Xu <like.xu@linux.intel.com>
Organization: Intel OTC
Message-ID: <1528e1b4-3dee-161b-9463-57471263b5a8@linux.intel.com>
Date:   Thu, 26 Mar 2020 20:47:53 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.6.0
MIME-Version: 1.0
In-Reply-To: <20200317081458.88714-1-like.xu@linux.intel.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Anyone to help review this change?

Thanks,
Like Xu

On 2020/3/17 16:14, Like Xu wrote:
> The cost of perf_event_period() is unstable, and when the guest samples
> multiple events, the overhead increases dramatically (5378 ns on E5-2699).
> 
> For a non-running counter, the effective time of the new period is when
> its corresponding enable bit is enabled. Calling perf_event_period()
> in advance is superfluous. For a running counter, it's safe to delay the
> effective time until the KVM_REQ_PMU event is handled. If there are
> multiple perf_event_period() calls before handling KVM_REQ_PMU,
> it helps to reduce the total cost.
> 
> Signed-off-by: Like Xu <like.xu@linux.intel.com>
> ---
>   arch/x86/kvm/pmu.c           | 11 -----------
>   arch/x86/kvm/pmu.h           | 11 +++++++++++
>   arch/x86/kvm/vmx/pmu_intel.c | 10 ++++------
>   3 files changed, 15 insertions(+), 17 deletions(-)
> 
> diff --git a/arch/x86/kvm/pmu.c b/arch/x86/kvm/pmu.c
> index d1f8ca57d354..527a8bb85080 100644
> --- a/arch/x86/kvm/pmu.c
> +++ b/arch/x86/kvm/pmu.c
> @@ -437,17 +437,6 @@ void kvm_pmu_init(struct kvm_vcpu *vcpu)
>   	kvm_pmu_refresh(vcpu);
>   }
>   
> -static inline bool pmc_speculative_in_use(struct kvm_pmc *pmc)
> -{
> -	struct kvm_pmu *pmu = pmc_to_pmu(pmc);
> -
> -	if (pmc_is_fixed(pmc))
> -		return fixed_ctrl_field(pmu->fixed_ctr_ctrl,
> -			pmc->idx - INTEL_PMC_IDX_FIXED) & 0x3;
> -
> -	return pmc->eventsel & ARCH_PERFMON_EVENTSEL_ENABLE;
> -}
> -
>   /* Release perf_events for vPMCs that have been unused for a full time slice.  */
>   void kvm_pmu_cleanup(struct kvm_vcpu *vcpu)
>   {
> diff --git a/arch/x86/kvm/pmu.h b/arch/x86/kvm/pmu.h
> index d7da2b9e0755..cd112e825d2c 100644
> --- a/arch/x86/kvm/pmu.h
> +++ b/arch/x86/kvm/pmu.h
> @@ -138,6 +138,17 @@ static inline u64 get_sample_period(struct kvm_pmc *pmc, u64 counter_value)
>   	return sample_period;
>   }
>   
> +static inline bool pmc_speculative_in_use(struct kvm_pmc *pmc)
> +{
> +	struct kvm_pmu *pmu = pmc_to_pmu(pmc);
> +
> +	if (pmc_is_fixed(pmc))
> +		return fixed_ctrl_field(pmu->fixed_ctr_ctrl,
> +			pmc->idx - INTEL_PMC_IDX_FIXED) & 0x3;
> +
> +	return pmc->eventsel & ARCH_PERFMON_EVENTSEL_ENABLE;
> +}
> +
>   void reprogram_gp_counter(struct kvm_pmc *pmc, u64 eventsel);
>   void reprogram_fixed_counter(struct kvm_pmc *pmc, u8 ctrl, int fixed_idx);
>   void reprogram_counter(struct kvm_pmu *pmu, int pmc_idx);
> diff --git a/arch/x86/kvm/vmx/pmu_intel.c b/arch/x86/kvm/vmx/pmu_intel.c
> index 7c857737b438..20f654a0c09b 100644
> --- a/arch/x86/kvm/vmx/pmu_intel.c
> +++ b/arch/x86/kvm/vmx/pmu_intel.c
> @@ -263,15 +263,13 @@ static int intel_pmu_set_msr(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
>   			if (!msr_info->host_initiated)
>   				data = (s64)(s32)data;
>   			pmc->counter += data - pmc_read_counter(pmc);
> -			if (pmc->perf_event)
> -				perf_event_period(pmc->perf_event,
> -						  get_sample_period(pmc, data));
> +			if (pmc_speculative_in_use(pmc))
> +				kvm_make_request(KVM_REQ_PMU, vcpu);
>   			return 0;
>   		} else if ((pmc = get_fixed_pmc(pmu, msr))) {
>   			pmc->counter += data - pmc_read_counter(pmc);
> -			if (pmc->perf_event)
> -				perf_event_period(pmc->perf_event,
> -						  get_sample_period(pmc, data));
> +			if (pmc_speculative_in_use(pmc))
> +				kvm_make_request(KVM_REQ_PMU, vcpu);
>   			return 0;
>   		} else if ((pmc = get_gp_pmc(pmu, msr, MSR_P6_EVNTSEL0))) {
>   			if (data == pmc->eventsel)
> 

