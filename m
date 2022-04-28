Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 72E165136B2
	for <lists+kvm@lfdr.de>; Thu, 28 Apr 2022 16:19:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348253AbiD1OWM (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 28 Apr 2022 10:22:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55512 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230128AbiD1OWL (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 28 Apr 2022 10:22:11 -0400
Received: from mga07.intel.com (mga07.intel.com [134.134.136.100])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C7828B6D21;
        Thu, 28 Apr 2022 07:18:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1651155536; x=1682691536;
  h=message-id:date:mime-version:subject:to:references:from:
   in-reply-to:content-transfer-encoding;
  bh=aPhTz0JDV2h95i9ZtlBz+qDBbAxlRKmeFPSbHaSb/XI=;
  b=LaUUVc0heYeUGsfhr/b7P5QeJo/hM3mLnjtpgdn0buavNVDD2w3YFTwd
   gFODOy/EIdQX4BPNmleIhZrO8pxl8zOke+1109gJ7+X6YmbZ9PZy5BQDP
   Z2XrFIdhlAuxRNIQN/70kh8VKeEyh6NvgBMoVUK15VgZxbEOahRccGrvs
   U9ZcPtjszScTKG7tzYlFhe/R3Y4VsJqpRqnRpg6ABbrvf7IY7VhOk1pq1
   ePhkOmxnb++raaWytY8S6Ad8LtAS69wfUFvm7kTvv8YQ154cJ+77rc8Ax
   DHm5c3oqBNNvwjchDwScAg9Sg1sngf8HXWay6BiDe3xzEXSVyrTtVpV1I
   g==;
X-IronPort-AV: E=McAfee;i="6400,9594,10330"; a="329247916"
X-IronPort-AV: E=Sophos;i="5.91,295,1647327600"; 
   d="scan'208";a="329247916"
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Apr 2022 07:18:56 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.91,295,1647327600"; 
   d="scan'208";a="533905895"
Received: from linux.intel.com ([10.54.29.200])
  by orsmga006.jf.intel.com with ESMTP; 28 Apr 2022 07:18:56 -0700
Received: from [10.209.10.70] (kliang2-MOBL.ccr.corp.intel.com [10.209.10.70])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by linux.intel.com (Postfix) with ESMTPS id 60C09580279;
        Thu, 28 Apr 2022 07:18:55 -0700 (PDT)
Message-ID: <4ad3bbff-8577-8e84-6ed9-b6f90e018224@linux.intel.com>
Date:   Thu, 28 Apr 2022 10:18:54 -0400
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.8.1
Subject: Re: [PATCH v10 08/16] KVM: x86/pmu: Refactor code to support guest
 Arch LBR
Content-Language: en-US
To:     Yang Weijiang <weijiang.yang@intel.com>, pbonzini@redhat.com,
        jmattson@google.com, seanjc@google.com, like.xu.linux@gmail.com,
        vkuznets@redhat.com, wei.w.wang@intel.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20220422075509.353942-1-weijiang.yang@intel.com>
 <20220422075509.353942-9-weijiang.yang@intel.com>
From:   "Liang, Kan" <kan.liang@linux.intel.com>
In-Reply-To: <20220422075509.353942-9-weijiang.yang@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.9 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 4/22/2022 3:55 AM, Yang Weijiang wrote:
> Take account of Arch LBR when do sanity checks before program
> vPMU for guest. Pass through Arch LBR recording MSRs to guest
> to gain better performance. Note, Arch LBR and Legacy LBR support
> are mutually exclusive, i.e., they're not both available on one
> platform.
> 
> Co-developed-by: Like Xu <like.xu@linux.intel.com>
> Signed-off-by: Like Xu <like.xu@linux.intel.com>
> Signed-off-by: Yang Weijiang <weijiang.yang@intel.com>
> ---
>   arch/x86/kvm/vmx/pmu_intel.c | 37 +++++++++++++++++++++++++++++-------
>   arch/x86/kvm/vmx/vmx.c       |  3 +++
>   2 files changed, 33 insertions(+), 7 deletions(-)
> 
> diff --git a/arch/x86/kvm/vmx/pmu_intel.c b/arch/x86/kvm/vmx/pmu_intel.c
> index 7dc8a5783df7..cb28888e9f4f 100644
> --- a/arch/x86/kvm/vmx/pmu_intel.c
> +++ b/arch/x86/kvm/vmx/pmu_intel.c
> @@ -170,12 +170,16 @@ static inline struct kvm_pmc *get_fw_gp_pmc(struct kvm_pmu *pmu, u32 msr)
>   
>   bool intel_pmu_lbr_is_compatible(struct kvm_vcpu *vcpu)
>   {
> +	if (kvm_cpu_cap_has(X86_FEATURE_ARCH_LBR))
> +		return guest_cpuid_has(vcpu, X86_FEATURE_ARCH_LBR);
> +
>   	/*
>   	 * As a first step, a guest could only enable LBR feature if its
>   	 * cpu model is the same as the host because the LBR registers
>   	 * would be pass-through to the guest and they're model specific.
>   	 */
> -	return boot_cpu_data.x86_model == guest_cpuid_model(vcpu);
> +	return !boot_cpu_has(X86_FEATURE_ARCH_LBR) &&
> +		boot_cpu_data.x86_model == guest_cpuid_model(vcpu);
>   }
>   
>   bool intel_pmu_lbr_is_enabled(struct kvm_vcpu *vcpu)
> @@ -193,12 +197,19 @@ static bool intel_pmu_is_valid_lbr_msr(struct kvm_vcpu *vcpu, u32 index)

I think we should move MSR_ARCH_LBR_DEPTH and MSR_ARCH_LBR_CTL to this 
function as well, since they are LBR related MSRs.

>   	if (!intel_pmu_lbr_is_enabled(vcpu))
>   		return ret;
>   
> -	ret = (index == MSR_LBR_SELECT) || (index == MSR_LBR_TOS) ||
> -		(index >= records->from && index < records->from + records->nr) ||
> -		(index >= records->to && index < records->to + records->nr);
> +	if (!guest_cpuid_has(vcpu, X86_FEATURE_ARCH_LBR))
> +		ret = (index == MSR_LBR_SELECT) || (index == MSR_LBR_TOS);
> +
> +	if (!ret) {
> +		ret = (index >= records->from &&
> +		       index < records->from + records->nr) ||
> +		      (index >= records->to &&
> +		       index < records->to + records->nr);
> +	}
>   
>   	if (!ret && records->info)
> -		ret = (index >= records->info && index < records->info + records->nr);
> +		ret = (index >= records->info &&
> +		       index < records->info + records->nr);

Please use "{}" since you split it to two lines.

Thanks,
Kan
>   
>   	return ret;
>   }
> @@ -747,6 +758,9 @@ static void vmx_update_intercept_for_lbr_msrs(struct kvm_vcpu *vcpu, bool set)
>   			vmx_set_intercept_for_msr(vcpu, lbr->info + i, MSR_TYPE_RW, set);
>   	}
>   
> +	if (guest_cpuid_has(vcpu, X86_FEATURE_ARCH_LBR))
> +		return;
> +
>   	vmx_set_intercept_for_msr(vcpu, MSR_LBR_SELECT, MSR_TYPE_RW, set);
>   	vmx_set_intercept_for_msr(vcpu, MSR_LBR_TOS, MSR_TYPE_RW, set);
>   }
> @@ -787,10 +801,13 @@ void vmx_passthrough_lbr_msrs(struct kvm_vcpu *vcpu)
>   {
>   	struct kvm_pmu *pmu = vcpu_to_pmu(vcpu);
>   	struct lbr_desc *lbr_desc = vcpu_to_lbr_desc(vcpu);
> +	bool lbr_enable = guest_cpuid_has(vcpu, X86_FEATURE_ARCH_LBR) ?
> +		(vmcs_read64(GUEST_IA32_LBR_CTL) & ARCH_LBR_CTL_LBREN) :
> +		(vmcs_read64(GUEST_IA32_DEBUGCTL) & DEBUGCTLMSR_LBR);
>   
>   	if (!lbr_desc->event) {
>   		vmx_disable_lbr_msrs_passthrough(vcpu);
> -		if (vmcs_read64(GUEST_IA32_DEBUGCTL) & DEBUGCTLMSR_LBR)
> +		if (lbr_enable)
>   			goto warn;
>   		if (test_bit(INTEL_PMC_IDX_FIXED_VLBR, pmu->pmc_in_use))
>   			goto warn;
> @@ -807,13 +824,19 @@ void vmx_passthrough_lbr_msrs(struct kvm_vcpu *vcpu)
>   	return;
>   
>   warn:
> +	if (kvm_cpu_cap_has(X86_FEATURE_ARCH_LBR))
> +		wrmsrl(MSR_ARCH_LBR_DEPTH, lbr_desc->records.nr);
>   	pr_warn_ratelimited("kvm: vcpu-%d: fail to passthrough LBR.\n",
>   		vcpu->vcpu_id);
>   }
>   
>   static void intel_pmu_cleanup(struct kvm_vcpu *vcpu)
>   {
> -	if (!(vmcs_read64(GUEST_IA32_DEBUGCTL) & DEBUGCTLMSR_LBR))
> +	bool lbr_enable = guest_cpuid_has(vcpu, X86_FEATURE_ARCH_LBR) ?
> +		(vmcs_read64(GUEST_IA32_LBR_CTL) & ARCH_LBR_CTL_LBREN) :
> +		(vmcs_read64(GUEST_IA32_DEBUGCTL) & DEBUGCTLMSR_LBR);
> +
> +	if (!lbr_enable)
>   		intel_pmu_release_guest_lbr_event(vcpu);
>   }
>   
> diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
> index 73961fcfb62d..a1816c6597f5 100644
> --- a/arch/x86/kvm/vmx/vmx.c
> +++ b/arch/x86/kvm/vmx/vmx.c
> @@ -573,6 +573,9 @@ static bool is_valid_passthrough_msr(u32 msr)
>   	case MSR_LBR_NHM_TO ... MSR_LBR_NHM_TO + 31:
>   	case MSR_LBR_CORE_FROM ... MSR_LBR_CORE_FROM + 8:
>   	case MSR_LBR_CORE_TO ... MSR_LBR_CORE_TO + 8:
> +	case MSR_ARCH_LBR_FROM_0 ... MSR_ARCH_LBR_FROM_0 + 31:
> +	case MSR_ARCH_LBR_TO_0 ... MSR_ARCH_LBR_TO_0 + 31:
> +	case MSR_ARCH_LBR_INFO_0 ... MSR_ARCH_LBR_INFO_0 + 31:
>   		/* LBR MSRs. These are handled in vmx_update_intercept_for_lbr_msrs() */
>   		return true;
>   	}
