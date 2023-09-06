Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8EC477938D6
	for <lists+kvm@lfdr.de>; Wed,  6 Sep 2023 11:50:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232559AbjIFJuG (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 6 Sep 2023 05:50:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49098 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229661AbjIFJuG (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 6 Sep 2023 05:50:06 -0400
Received: from mgamail.intel.com (mgamail.intel.com [134.134.136.126])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 03FCB1BB
        for <kvm@vger.kernel.org>; Wed,  6 Sep 2023 02:50:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1693993802; x=1725529802;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=NQfHsrxrx8T9vaYQwhCGhwxnGhvvyB2ffT3NCZiBWhs=;
  b=ERybSWW5aFothboRH3nhbFh9kX5NJKXJjyjxzpbL363NVHGIbmFGelTF
   43oWV3Rpj0wYNWM2v+ZrUdszfh4TDXjVEiIeZGolzqrQ4gWQDbP//UeD6
   GJOSaGQasbFxPE26hnVRUEfcouQXevl7ZPho4cPEkAjyC5K8NYeFP+Cl1
   DfFcUimErm283robJiRLwdn/kZxCwXS+qw7bxKAekmIwBPz6UFLPotQ9h
   XPdZmwSZsvVq8DnV9qjkkA0A5AV8TSWcbwBX9IJlaGYfT3MAt6l66geIO
   JLPjAjQwRxHUXINM7vgn19HStfQ/O44kgQ9HKtmfAnF7K/6vZ8/4MuLEc
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10824"; a="362046492"
X-IronPort-AV: E=Sophos;i="6.02,231,1688454000"; 
   d="scan'208";a="362046492"
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Sep 2023 02:50:01 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10824"; a="1072322572"
X-IronPort-AV: E=Sophos;i="6.02,231,1688454000"; 
   d="scan'208";a="1072322572"
Received: from dapengmi-mobl1.ccr.corp.intel.com (HELO [10.93.20.184]) ([10.93.20.184])
  by fmsmga005-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Sep 2023 02:49:58 -0700
Message-ID: <75563bcd-23e9-e4b0-d7a8-48b04dd8d0ea@linux.intel.com>
Date:   Wed, 6 Sep 2023 17:49:56 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.15.0
Subject: Re: [PATCH 2/9] KVM: x85/pmu: Add Streamlined FREEZE_LBR_ON_PMI for
 vPMU v4
Content-Language: en-US
To:     Xiong Zhang <xiong.y.zhang@intel.com>, kvm@vger.kernel.org
Cc:     seanjc@google.com, like.xu.linux@gmail.com, zhiyuan.lv@intel.com,
        zhenyu.z.wang@intel.com, kan.liang@intel.com
References: <20230901072809.640175-1-xiong.y.zhang@intel.com>
 <20230901072809.640175-3-xiong.y.zhang@intel.com>
From:   "Mi, Dapeng" <dapeng1.mi@linux.intel.com>
In-Reply-To: <20230901072809.640175-3-xiong.y.zhang@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-3.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 9/1/2023 3:28 PM, Xiong Zhang wrote:
> Arch PMU version 4 adds a streamlined FREEZE_LBR_ON_PMI feature, this
> feature adds LBR_FRZ[bit 58] into IA32_PERF_GLOBAL_STATUS, this bit is
> set due to the following conditions:
> -- IA32_DEBUGCTL.FREEZE_LBR_ON_PMI has been set
> -- A performance counter, configured to generate PMI, has overflowed to
> signal a PMI. Consequently the LBR stack is frozen.
> Effectively, this bit also serves as a control to enabled capturing
> data in the LBR stack. When this bit is set, LBR stack is frozen, and
> new LBR records won't be filled.
>
> The sequence of streamlined freeze LBR is:
> 1. Profiling agent set IA32_DEBUGCTL.FREEZE_LBR_ON_PMI, and enable
> a performance counter to generate PMI on overflow.
> 2. Processor generates PMI and sets IA32_PERF_GLOBAL_STATUS.LBR_FRZ,
> then LBR stack is forzen.
> 3. Profiling agent PMI handler handles overflow, and clears
> IA32_PERF_GLOBAL_STATUS.
> 4. When IA32_PERF_GLOBAL_STATUS.LBR_FRZ is cleared in step 3,
> processor resume LBR stack, and new LBR records can be filled
> again.
>
> In order to emulate this behavior, LBR stack must be frozen on PMI.
> KVM has two choice to do this:
> 1. KVM stops vLBR event through perf_event_pause(), and put vLBR
> event into off state, then vLBR lose LBR hw resource, finally guest
> couldn't read LBR records in guest PMI handler. This choice couldn't
> be used.
> 2. KVM clear guest DEBUGCTLMSR_LBR bit in VMCS on PMI, so when guest
> is running, LBR HW stack is disabled, while vLBR event is still active
> and own LBR HW, so guest could still read LBR records in guest PMI
> handler. But the sequence of streamlined freeze LBR doesn't clear
> DEBUGCTLMSR_LBR bit, so when guest read guest DEBUGCTL_MSR, KVM will
> return a value with DEBUGCTLMSR_LBR bit set during LBR freezing. Once
> guest clears IA32_PERF_GLOBAL_STATUS.LBR_FRZ in step 4, KVM will
> re-enable guest LBR through setting guest DEBUGCTL_LBR bit in VMCS.
>
> As KVM will re-enable guest LBR when guest clears global status, the
> handling of GLOBAL_OVF_CTRL MSR is moved from common pmu.c into
> vmx/pmu_intel.c.
>
> Signed-off-by: Xiong Zhang <xiong.y.zhang@intel.com>
> ---
>   arch/x86/include/asm/msr-index.h |  1 +
>   arch/x86/kvm/pmu.c               |  8 ------
>   arch/x86/kvm/vmx/pmu_intel.c     | 44 ++++++++++++++++++++++++++++++++
>   arch/x86/kvm/vmx/vmx.c           |  3 +++
>   4 files changed, 48 insertions(+), 8 deletions(-)
>
> diff --git a/arch/x86/include/asm/msr-index.h b/arch/x86/include/asm/msr-index.h
> index 3aedae61af4f..4fce37ae5a90 100644
> --- a/arch/x86/include/asm/msr-index.h
> +++ b/arch/x86/include/asm/msr-index.h
> @@ -1041,6 +1041,7 @@
>   /* PERF_GLOBAL_OVF_CTL bits */
>   #define MSR_CORE_PERF_GLOBAL_OVF_CTRL_TRACE_TOPA_PMI_BIT	55
>   #define MSR_CORE_PERF_GLOBAL_OVF_CTRL_TRACE_TOPA_PMI		(1ULL << MSR_CORE_PERF_GLOBAL_OVF_CTRL_TRACE_TOPA_PMI_BIT)
> +#define MSR_CORE_PERF_GLOBAL_OVF_CTRL_LBR_FREEZE		BIT_ULL(58)
>   #define MSR_CORE_PERF_GLOBAL_OVF_CTRL_OVF_BUF_BIT		62
>   #define MSR_CORE_PERF_GLOBAL_OVF_CTRL_OVF_BUF			(1ULL <<  MSR_CORE_PERF_GLOBAL_OVF_CTRL_OVF_BUF_BIT)
>   #define MSR_CORE_PERF_GLOBAL_OVF_CTRL_COND_CHGD_BIT		63
> diff --git a/arch/x86/kvm/pmu.c b/arch/x86/kvm/pmu.c
> index edb89b51b383..4b6a508f3f0b 100644
> --- a/arch/x86/kvm/pmu.c
> +++ b/arch/x86/kvm/pmu.c
> @@ -640,14 +640,6 @@ int kvm_pmu_set_msr(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
>   			reprogram_counters(pmu, diff);
>   		}
>   		break;
> -	case MSR_CORE_PERF_GLOBAL_OVF_CTRL:
> -		/*
> -		 * GLOBAL_OVF_CTRL, a.k.a. GLOBAL STATUS_RESET, clears bits in
> -		 * GLOBAL_STATUS, and so the set of reserved bits is the same.
> -		 */
> -		if (data & pmu->global_status_mask)
> -			return 1;
> -		fallthrough;
>   	case MSR_AMD64_PERF_CNTR_GLOBAL_STATUS_CLR:
>   		if (!msr_info->host_initiated)
>   			pmu->global_status &= ~data;
> diff --git a/arch/x86/kvm/vmx/pmu_intel.c b/arch/x86/kvm/vmx/pmu_intel.c
> index 3a36a91638c6..ba7695a64ff1 100644
> --- a/arch/x86/kvm/vmx/pmu_intel.c
> +++ b/arch/x86/kvm/vmx/pmu_intel.c
> @@ -426,6 +426,29 @@ static int intel_pmu_set_msr(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
>   
>   		pmu->pebs_data_cfg = data;
>   		break;
> +	case MSR_CORE_PERF_GLOBAL_OVF_CTRL:
> +		/*
> +		 * GLOBAL_OVF_CTRL, a.k.a. GLOBAL STATUS_RESET, clears bits in
> +		 * GLOBAL_STATUS, and so the set of reserved bits is the same.
> +		 */
> +		if (data & pmu->global_status_mask)
> +			return 1;
> +		if (pmu->version >= 4 && !msr_info->host_initiated &&
> +		    (data & MSR_CORE_PERF_GLOBAL_OVF_CTRL_LBR_FREEZE)) {
> +			u64 debug_ctl = vmcs_read64(GUEST_IA32_DEBUGCTL);
> +			struct lbr_desc *lbr_desc = vcpu_to_lbr_desc(vcpu);
> +
> +			if (!(debug_ctl & DEBUGCTLMSR_LBR) &&
> +			    lbr_desc->freeze_on_pmi) {
> +				debug_ctl |= DEBUGCTLMSR_LBR;
> +				vmcs_write64(GUEST_IA32_DEBUGCTL, debug_ctl);
> +				lbr_desc->freeze_on_pmi = false;
> +			}
> +		}
> +
> +		if (!msr_info->host_initiated)
> +			pmu->global_status &= ~data;
> +		break;
>   	default:
>   		if ((pmc = get_gp_pmc(pmu, msr, MSR_IA32_PERFCTR0)) ||
>   		    (pmc = get_gp_pmc(pmu, msr, MSR_IA32_PMC0))) {
> @@ -565,6 +588,9 @@ static void intel_pmu_refresh(struct kvm_vcpu *vcpu)
>   	if (vmx_pt_mode_is_host_guest())
>   		pmu->global_status_mask &=
>   				~MSR_CORE_PERF_GLOBAL_OVF_CTRL_TRACE_TOPA_PMI;
> +	if (pmu->version >= 4)
> +		pmu->global_status_mask &=
> +				~MSR_CORE_PERF_GLOBAL_OVF_CTRL_LBR_FREEZE;
>   
>   	entry = kvm_find_cpuid_entry_index(vcpu, 7, 0);
>   	if (entry &&
> @@ -675,6 +701,22 @@ static void intel_pmu_legacy_freezing_lbrs_on_pmi(struct kvm_vcpu *vcpu)
>   	}
>   }
>   
> +static void intel_pmu_streamlined_freezing_lbrs_on_pmi(struct kvm_vcpu *vcpu)
> +{
> +	u64 data = vmcs_read64(GUEST_IA32_DEBUGCTL);
> +	struct kvm_pmu *pmu = vcpu_to_pmu(vcpu);
> +
> +	/*
> +	 * Even if streamlined freezing LBR won't clear LBR_EN like legacy
> +	 * freezing LBR, here legacy freezing LBR is called to freeze LBR HW
> +	 * for streamlined freezing LBR when guest run. But guest VM will
> +	 * see a fake guest DEBUGCTL MSR with LBR_EN bit set.
> +	 */
> +	intel_pmu_legacy_freezing_lbrs_on_pmi(vcpu);
> +	if ((data & DEBUGCTLMSR_FREEZE_LBRS_ON_PMI) && (data & DEBUGCTLMSR_LBR))
> +		pmu->global_status |= MSR_CORE_PERF_GLOBAL_OVF_CTRL_LBR_FREEZE;
> +}
> +
>   static void intel_pmu_deliver_pmi(struct kvm_vcpu *vcpu)
>   {
>   	u8 version = vcpu_to_pmu(vcpu)->version;
> @@ -684,6 +726,8 @@ static void intel_pmu_deliver_pmi(struct kvm_vcpu *vcpu)
>   
>   	if (version > 1 && version < 4)
>   		intel_pmu_legacy_freezing_lbrs_on_pmi(vcpu);
> +	else if (version >= 4)
> +		intel_pmu_streamlined_freezing_lbrs_on_pmi(vcpu);
>   }
>   
>   static void vmx_update_intercept_for_lbr_msrs(struct kvm_vcpu *vcpu, bool set)
> diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
> index 199d0da1dbee..3bd64879aab3 100644
> --- a/arch/x86/kvm/vmx/vmx.c
> +++ b/arch/x86/kvm/vmx/vmx.c
> @@ -2098,6 +2098,9 @@ static int vmx_get_msr(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
>   		break;
>   	case MSR_IA32_DEBUGCTLMSR:
>   		msr_info->data = vmcs_read64(GUEST_IA32_DEBUGCTL);
> +		if (vcpu_to_lbr_desc(vcpu)->freeze_on_pmi &&
> +		    vcpu_to_pmu(vcpu)->version >= 4)
> +			msr_info->data |= DEBUGCTLMSR_LBR;
>   		break;
>   	default:
>   	find_uret_msr:

Reviewed-by: Dapeng Mi <dapeng1.mi@linux.intel.com>

