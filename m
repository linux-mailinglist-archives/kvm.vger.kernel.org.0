Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6B11D7938C4
	for <lists+kvm@lfdr.de>; Wed,  6 Sep 2023 11:47:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234986AbjIFJrr (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 6 Sep 2023 05:47:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56258 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236661AbjIFJrm (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 6 Sep 2023 05:47:42 -0400
Received: from mgamail.intel.com (mgamail.intel.com [134.134.136.24])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8EE081717
        for <kvm@vger.kernel.org>; Wed,  6 Sep 2023 02:47:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1693993655; x=1725529655;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=PlIj76q9h4GbohlRkiQnz8cc2knHnXUJBaDMsTLT5hY=;
  b=Ym5S5nOS847lV6ZS0pQ41cfwNYZA6p0oH1nrd31idRiNt3R+aPiP6nbO
   8XwoXP++D8wcSTVCbm8waqp/85rxlqt9aCg4IZyoHUoaGv/jYs8WcVktk
   IIReEpcqebVW37/xPBj6AMHOQfgAw6fXU+IBZ9RzmnokeOh1dbRewb3sm
   CcN779mX0E3O+u0P5tYalIMsYlmMTzOjmL9kJ9fRk8ISqniECyVrxQGg/
   /uwP2pxwFkKH8m6I0IuDlNKO8nivvJmt6VpDO3OjdXtGfKsNU+8BcJpf+
   oC4BzHunHPG9+LeynrdC9pqSBxft1grrzuO28g/6hQ5xerWYnmpbDkDTf
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10824"; a="379733333"
X-IronPort-AV: E=Sophos;i="6.02,231,1688454000"; 
   d="scan'208";a="379733333"
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Sep 2023 02:47:34 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10824"; a="915205424"
X-IronPort-AV: E=Sophos;i="6.02,231,1688454000"; 
   d="scan'208";a="915205424"
Received: from dapengmi-mobl1.ccr.corp.intel.com (HELO [10.93.20.184]) ([10.93.20.184])
  by orsmga005-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Sep 2023 02:47:31 -0700
Message-ID: <13788236-1fdc-ff6b-c762-f07ba0dc027f@linux.intel.com>
Date:   Wed, 6 Sep 2023 17:47:29 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.15.0
Subject: Re: [PATCH 1/9] KVM: x86/PMU: Don't release vLBR caused by PMI
Content-Language: en-US
To:     Xiong Zhang <xiong.y.zhang@intel.com>, kvm@vger.kernel.org
Cc:     seanjc@google.com, like.xu.linux@gmail.com, zhiyuan.lv@intel.com,
        zhenyu.z.wang@intel.com, kan.liang@intel.com
References: <20230901072809.640175-1-xiong.y.zhang@intel.com>
 <20230901072809.640175-2-xiong.y.zhang@intel.com>
From:   "Mi, Dapeng" <dapeng1.mi@linux.intel.com>
In-Reply-To: <20230901072809.640175-2-xiong.y.zhang@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-3.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_BLOCKED,RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


On 9/1/2023 3:28 PM, Xiong Zhang wrote:
> vLBR event will be released at vcpu sched-in time if LBR_EN bit is not
> set in GUEST_IA32_DEBUGCTL VMCS field, this bit is cleared in two cases:
> 1. guest disable LBR through WRMSR
> 2. KVM disable LBR at PMI injection to emulate guest FREEZE_LBR_ON_PMI.
>
> The first case is guest LBR won't be used anymore and vLBR event can be
> released, but guest LBR is still be used in the second case, vLBR event
> can not be released.
>
> Considering this serial:
> 1. vPMC overflow, KVM injects vPMI and clears guest LBR_EN
> 2. guest handles PMI, and reads LBR records.
> 3. vCPU is sched-out, later sched-in, vLBR event is released.
> 4. Guest continue reading LBR records, KVM creates vLBR event again,
> the vLBR event is the only LBR user on host now, host PMU driver will
> reset HW LBR facility at vLBR creataion.
> 5. Guest gets the remain LBR records with reset state.
> This is conflict with FREEZE_LBR_ON_PMI meaning, so vLBR event can
> not be release on PMI.
>
> This commit adds a freeze_on_pmi flag, this flag is set at pmi
> injection and is cleared when guest operates guest DEBUGCTL_MSR. If
> this flag is true, vLBR event will not be released.
>
> Signed-off-by: Xiong Zhang <xiong.y.zhang@intel.com>
> ---
>   arch/x86/kvm/vmx/pmu_intel.c |  5 ++++-
>   arch/x86/kvm/vmx/vmx.c       | 12 +++++++++---
>   arch/x86/kvm/vmx/vmx.h       |  3 +++
>   3 files changed, 16 insertions(+), 4 deletions(-)
>
> diff --git a/arch/x86/kvm/vmx/pmu_intel.c b/arch/x86/kvm/vmx/pmu_intel.c
> index f2efa0bf7ae8..3a36a91638c6 100644
> --- a/arch/x86/kvm/vmx/pmu_intel.c
> +++ b/arch/x86/kvm/vmx/pmu_intel.c
> @@ -628,6 +628,7 @@ static void intel_pmu_init(struct kvm_vcpu *vcpu)
>   	lbr_desc->records.nr = 0;
>   	lbr_desc->event = NULL;
>   	lbr_desc->msr_passthrough = false;
> +	lbr_desc->freeze_on_pmi = false;
>   }
>   
>   static void intel_pmu_reset(struct kvm_vcpu *vcpu)
> @@ -670,6 +671,7 @@ static void intel_pmu_legacy_freezing_lbrs_on_pmi(struct kvm_vcpu *vcpu)
>   	if (data & DEBUGCTLMSR_FREEZE_LBRS_ON_PMI) {
>   		data &= ~DEBUGCTLMSR_LBR;
>   		vmcs_write64(GUEST_IA32_DEBUGCTL, data);
> +		vcpu_to_lbr_desc(vcpu)->freeze_on_pmi = true;
>   	}
>   }
>   
> @@ -761,7 +763,8 @@ void vmx_passthrough_lbr_msrs(struct kvm_vcpu *vcpu)
>   
>   static void intel_pmu_cleanup(struct kvm_vcpu *vcpu)
>   {
> -	if (!(vmcs_read64(GUEST_IA32_DEBUGCTL) & DEBUGCTLMSR_LBR))
> +	if (!(vmcs_read64(GUEST_IA32_DEBUGCTL) & DEBUGCTLMSR_LBR) &&
> +	    !vcpu_to_lbr_desc(vcpu)->freeze_on_pmi)
>   		intel_pmu_release_guest_lbr_event(vcpu);
>   }
>   
> diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
> index e6849f780dba..199d0da1dbee 100644
> --- a/arch/x86/kvm/vmx/vmx.c
> +++ b/arch/x86/kvm/vmx/vmx.c
> @@ -2223,9 +2223,15 @@ static int vmx_set_msr(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
>   			get_vmcs12(vcpu)->guest_ia32_debugctl = data;
>   
>   		vmcs_write64(GUEST_IA32_DEBUGCTL, data);
> -		if (intel_pmu_lbr_is_enabled(vcpu) && !to_vmx(vcpu)->lbr_desc.event &&
> -		    (data & DEBUGCTLMSR_LBR))
> -			intel_pmu_create_guest_lbr_event(vcpu);
> +
> +		if (intel_pmu_lbr_is_enabled(vcpu)) {
> +			struct lbr_desc *lbr_desc = vcpu_to_lbr_desc(vcpu);
> +
> +			lbr_desc->freeze_on_pmi = false;
> +			if (!lbr_desc->event && (data & DEBUGCTLMSR_LBR))
> +				intel_pmu_create_guest_lbr_event(vcpu);
> +		}
> +
>   		return 0;
>   	}
>   	case MSR_IA32_BNDCFGS:
> diff --git a/arch/x86/kvm/vmx/vmx.h b/arch/x86/kvm/vmx/vmx.h
> index c2130d2c8e24..9729ccfa75ae 100644
> --- a/arch/x86/kvm/vmx/vmx.h
> +++ b/arch/x86/kvm/vmx/vmx.h
> @@ -107,6 +107,9 @@ struct lbr_desc {
>   
>   	/* True if LBRs are marked as not intercepted in the MSR bitmap */
>   	bool msr_passthrough;
> +
> +	/* True if LBR is frozen on PMI */
> +	bool freeze_on_pmi;
>   };
>   
>   /*
Reviewed-by: Dapeng Mi <dapeng1.mi@linux.intel.com>
