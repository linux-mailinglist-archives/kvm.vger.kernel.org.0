Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 19AF87AD3D3
	for <lists+kvm@lfdr.de>; Mon, 25 Sep 2023 10:52:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233097AbjIYIwq (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 25 Sep 2023 04:52:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60688 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233030AbjIYIwk (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 25 Sep 2023 04:52:40 -0400
Received: from mgamail.intel.com (mgamail.intel.com [134.134.136.100])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ED14E107
        for <kvm@vger.kernel.org>; Mon, 25 Sep 2023 01:52:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1695631951; x=1727167951;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=5w31NDHjoiiue0y05l8HuGUxH9CVJ95KTkTPBavuEt0=;
  b=UcTIWOermDf7ST42WcG2iACRNYVcSw4P0nc2YaDeuW5+gCJCIlFK6Zpd
   Ch0tDCX8bh0iUV5YRcOuzQhujMbVfuGmNght283B2bm0+/FdSDgtQ55gY
   CWDx3pasOP9YDTmhuf25nIEEnkYFCPtAwT+DOVZ9plKU7aRLNc5zvQ+34
   6C2UPVYze3rWOrs+n37YtB2X00VvpmWppAQV6U59xwbu+7ySEo9y1Fu5g
   lOapfAoAiYcbx6ZY0kzp3TmGuEYdNBY3cygzYaKHVhxU74Zvzl688KoeU
   Mx7xlQSwSEUi3B0dLxxHl5iG3wnd5HzmXEQ/cNLRMXI3++nNZm7tg46Io
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10843"; a="447692386"
X-IronPort-AV: E=Sophos;i="6.03,174,1694761200"; 
   d="scan'208";a="447692386"
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Sep 2023 01:52:31 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10843"; a="921903518"
X-IronPort-AV: E=Sophos;i="6.03,174,1694761200"; 
   d="scan'208";a="921903518"
Received: from dapengmi-mobl1.ccr.corp.intel.com (HELO [10.93.5.53]) ([10.93.5.53])
  by orsmga005-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Sep 2023 01:52:29 -0700
Message-ID: <26b661fb-da18-4a71-8eee-1688cdf59325@linux.intel.com>
Date:   Mon, 25 Sep 2023 16:52:26 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 3/9] KVM: x85/pmu: Add Streamlined FREEZE_LBR_ON_PMI
 for vPMU v4
Content-Language: en-US
To:     Xiong Zhang <xiong.y.zhang@intel.com>, kvm@vger.kernel.org
Cc:     seanjc@google.com, like.xu.linux@gmail.com, zhiyuan.lv@intel.com,
        zhenyu.z.wang@intel.com, kan.liang@intel.com
References: <20230921082957.44628-1-xiong.y.zhang@intel.com>
 <20230921082957.44628-4-xiong.y.zhang@intel.com>
From:   "Mi, Dapeng" <dapeng1.mi@linux.intel.com>
In-Reply-To: <20230921082957.44628-4-xiong.y.zhang@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 9/21/2023 4:29 PM, Xiong Zhang wrote:
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
> In order to emulate this behavior, LBR stack must be frozen on guest
> vPMI. KVM has two choice to do this:
> 1. KVM stops vLBR event through perf_event_pause(), and put vLBR
> event into off state, then vLBR lose LBR hw resource, finally guest
> couldn't read LBR records in guest PMI handler. This choice couldn't
> be used.
> 2. KVM clears guest DEBUGCTLMSR_LBR bit in VMCS on PMI, so when guest
> is running, LBR HW stack is disabled, while vLBR event is still active
> and own LBR HW, so guest could still read LBR records in guest PMI
> handler. But the sequence of streamlined freeze LBR doesn't clear
> DEBUGCTLMSR_LBR bit, so when guest read guest DEBUGCTL_MSR, KVM will
> return a value with DEBUGCTLMSR_LBR bit set during LBR freezing. Once
> guest clears IA32_PERF_GLOBAL_STATUS.LBR_FRZ in step 4, KVM will
> re-enable guest LBR through setting guest DEBUGCTL_LBR bit in VMCS.
>
> As KVM needs re-enable guest LBR when guest clears global status, the
> handling of GLOBAL_OVF_CTRL MSR is moved from common pmu.c into
> vmx/pmu_intel.c.
>
> Signed-off-by: Xiong Zhang <xiong.y.zhang@intel.com>
> Reviewed-by: Dapeng Mi <dapeng1.mi@linux.intel.com>
> ---
>   arch/x86/include/asm/msr-index.h |  1 +
>   arch/x86/kvm/pmu.c               |  8 ------
>   arch/x86/kvm/vmx/pmu_intel.c     | 49 ++++++++++++++++++++++++++++++++
>   arch/x86/kvm/vmx/vmx.c           |  7 +++++
>   4 files changed, 57 insertions(+), 8 deletions(-)
>
> diff --git a/arch/x86/include/asm/msr-index.h b/arch/x86/include/asm/msr-index.h
> index 1d111350197f..badc2f729a8e 100644
> --- a/arch/x86/include/asm/msr-index.h
> +++ b/arch/x86/include/asm/msr-index.h
> @@ -1054,6 +1054,7 @@
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
> index c8d46c3d1ab6..6e3bbe777bf5 100644
> --- a/arch/x86/kvm/vmx/pmu_intel.c
> +++ b/arch/x86/kvm/vmx/pmu_intel.c
> @@ -426,6 +426,34 @@ static int intel_pmu_set_msr(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
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
> +
> +		/*
> +		 * Guest clears GLOBAL_STATUS_LBR_FREEZE bit, KVM re-enable
> +		 * Guset LBR which is disabled at vPMI injection for streamlined
> +		 * Freeze_LBR_On_PMI.
> +		 */
> +		if (pmu->version >= 4 && !msr_info->host_initiated &&
> +		    (data & MSR_CORE_PERF_GLOBAL_OVF_CTRL_LBR_FREEZE) &&
> +		    (pmu->global_status & MSR_CORE_PERF_GLOBAL_OVF_CTRL_LBR_FREEZE)) {
> +			u64 debug_ctl = vmcs_read64(GUEST_IA32_DEBUGCTL);
> +
> +			if (!(debug_ctl & DEBUGCTLMSR_LBR)) {
> +				debug_ctl |= DEBUGCTLMSR_LBR;
> +				vmcs_write64(GUEST_IA32_DEBUGCTL, debug_ctl);
> +			}


I'm thinking if we can enable guest LBR directly here. I'm afraid that 
some guest handlers may not follow the SDM strictly and they may disable 
LBR before writing GLOBAL_OVF_CTRL in guest PMI handler, then we should 
not enable LBR directly here.


> +			vcpu_to_lbr_desc(vcpu)->state = LBR_STATE_IN_USE;
> +		}
> +
> +		if (!msr_info->host_initiated)
> +			pmu->global_status &= ~data;
> +		break;
>   	default:
>   		if ((pmc = get_gp_pmc(pmu, msr, MSR_IA32_PERFCTR0)) ||
>   		    (pmc = get_gp_pmc(pmu, msr, MSR_IA32_PMC0))) {
> @@ -565,6 +593,9 @@ static void intel_pmu_refresh(struct kvm_vcpu *vcpu)
>   	if (vmx_pt_mode_is_host_guest())
>   		pmu->global_status_mask &=
>   				~MSR_CORE_PERF_GLOBAL_OVF_CTRL_TRACE_TOPA_PMI;
> +	if (pmu->version >= 4)
> +		pmu->global_status_mask &=
> +				~MSR_CORE_PERF_GLOBAL_OVF_CTRL_LBR_FREEZE;
>   
>   	entry = kvm_find_cpuid_entry_index(vcpu, 7, 0);
>   	if (entry &&
> @@ -675,6 +706,22 @@ static void intel_pmu_legacy_freezing_lbrs_on_pmi(struct kvm_vcpu *vcpu)
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
> @@ -684,6 +731,8 @@ static void intel_pmu_deliver_pmi(struct kvm_vcpu *vcpu)
>   
>   	if (version > 1 && version < 4)
>   		intel_pmu_legacy_freezing_lbrs_on_pmi(vcpu);
> +	else if (version >= 4)
> +		intel_pmu_streamlined_freezing_lbrs_on_pmi(vcpu);
>   }
>   
>   static void vmx_update_intercept_for_lbr_msrs(struct kvm_vcpu *vcpu, bool set)
> diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
> index 565df8eeb78b..66e4cf714dbd 100644
> --- a/arch/x86/kvm/vmx/vmx.c
> +++ b/arch/x86/kvm/vmx/vmx.c
> @@ -2113,6 +2113,13 @@ static int vmx_get_msr(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
>   		break;
>   	case MSR_IA32_DEBUGCTLMSR:
>   		msr_info->data = vmcs_read64(GUEST_IA32_DEBUGCTL);
> +		/*
> +		 * In streamlined Freeze_LBR_On_PMI, guest should see LBR_EN.
> +		 */
> +		if ((vcpu_to_pmu(vcpu)->global_status &
> +		     MSR_CORE_PERF_GLOBAL_OVF_CTRL_LBR_FREEZE) &&
> +		    vcpu_to_pmu(vcpu)->version >= 4)
> +			msr_info->data |= DEBUGCTLMSR_LBR;
>   		break;
>   	default:
>   	find_uret_msr:
