Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0B7E47AD340
	for <lists+kvm@lfdr.de>; Mon, 25 Sep 2023 10:22:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232714AbjIYIWi (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 25 Sep 2023 04:22:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55964 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232521AbjIYIWg (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 25 Sep 2023 04:22:36 -0400
Received: from mgamail.intel.com (mgamail.intel.com [134.134.136.126])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 62D49109
        for <kvm@vger.kernel.org>; Mon, 25 Sep 2023 01:22:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1695630150; x=1727166150;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=UXNkfChyimlN54IhWE7RMEgKt/rbNWqpc20MoEliu0Y=;
  b=XZx7T1sChBxrw60IyoU+F+uwqpJUzVgzWjSuKvP4I5md+lz2gbGrMqTA
   m8OxEWJzdZp3bRsZTkykWEsnhBN6ECzhKxdPTVjWyhD5uzAZ5doi+CkWT
   HoOXLiXi8MULUCDPIpPW7+CxMNjioSQ9TOLVkdUWQ7zddJ7/ql8qElREJ
   gFHPeQOKSpsZcU7npMzUtbA1nqDAyqXs3GC6hWJEby+3L7sgiFZateo5L
   ClZaM+rUX3it7hvQeJ3B2DKkQnJuFwfjTDVVp93rftCeNoGE9L79G+5fL
   Yz+Gug6qrKHWIlx9AlVbNwX0Czboaw5PRKqJ90dcFF2+Bn5QkK2KphZC0
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10843"; a="366257707"
X-IronPort-AV: E=Sophos;i="6.03,174,1694761200"; 
   d="scan'208";a="366257707"
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Sep 2023 01:22:30 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10843"; a="921897298"
X-IronPort-AV: E=Sophos;i="6.03,174,1694761200"; 
   d="scan'208";a="921897298"
Received: from dapengmi-mobl1.ccr.corp.intel.com (HELO [10.93.5.53]) ([10.93.5.53])
  by orsmga005-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Sep 2023 01:22:27 -0700
Message-ID: <b1d50ec7-9e49-4796-9236-38f63f196f67@linux.intel.com>
Date:   Mon, 25 Sep 2023 16:22:25 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 2/9] KVM: x86/pmu: Don't release vLBR casued by vPMI
To:     Xiong Zhang <xiong.y.zhang@intel.com>, kvm@vger.kernel.org
Cc:     seanjc@google.com, like.xu.linux@gmail.com, zhiyuan.lv@intel.com,
        zhenyu.z.wang@intel.com, kan.liang@intel.com
References: <20230921082957.44628-1-xiong.y.zhang@intel.com>
 <20230921082957.44628-3-xiong.y.zhang@intel.com>
Content-Language: en-US
From:   "Mi, Dapeng" <dapeng1.mi@linux.intel.com>
In-Reply-To: <20230921082957.44628-3-xiong.y.zhang@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_BLOCKED,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 9/21/2023 4:29 PM, Xiong Zhang wrote:
> To emulate Freeze_LBR_On_PMI feature, KVM PMU disables guest LBR at PMI
> injection. When guest LBR is disabled, vLBR event may be released at two
> vCPU sched-in later. once vLBR event is released, KVM will create a new
> vLBR event when guest access LBR MSRs again. First this adds overhead
> at vLBR event release and re-creation. Second this may changes guest
> LBR contend as vLBR event creation may cause host LBR drvier reset
> hw LBR facility.
>
> This commit avoids the vLBR release for Freeze_LBR_On_PMI emulation.
> It changes boolean lbr_desc->in_use into enum lbr_desc->state, so
> it could express more LBR states, KVM sets lbr_desc->state as
> FREEZE_ON_PMI at vPMI injection, so that vLBR release function could
> check this state to avoid vLBR release. When guest enables LBR
> at the end of the guest PMI handler, KVM will set lbr_desc->state
> as IN_USE.
>
> Signed-off-by: Xiong Zhang <xiong.y.zhang@intel.com>
> ---
>   arch/x86/kvm/vmx/pmu_intel.c | 8 +++++---
>   arch/x86/kvm/vmx/vmx.c       | 2 +-
>   arch/x86/kvm/vmx/vmx.h       | 8 +++++++-
>   3 files changed, 13 insertions(+), 5 deletions(-)
>
> diff --git a/arch/x86/kvm/vmx/pmu_intel.c b/arch/x86/kvm/vmx/pmu_intel.c
> index 76d7bd8e4fc6..c8d46c3d1ab6 100644
> --- a/arch/x86/kvm/vmx/pmu_intel.c
> +++ b/arch/x86/kvm/vmx/pmu_intel.c
> @@ -628,7 +628,7 @@ static void intel_pmu_init(struct kvm_vcpu *vcpu)
>   	lbr_desc->records.nr = 0;
>   	lbr_desc->event = NULL;
>   	lbr_desc->msr_passthrough = false;
> -	lbr_desc->in_use = FALSE;
> +	lbr_desc->state = LBR_STATE_PREDICT_FREE;
>   }
>   
>   static void intel_pmu_reset(struct kvm_vcpu *vcpu)
> @@ -671,6 +671,7 @@ static void intel_pmu_legacy_freezing_lbrs_on_pmi(struct kvm_vcpu *vcpu)
>   	if (data & DEBUGCTLMSR_FREEZE_LBRS_ON_PMI) {
>   		data &= ~DEBUGCTLMSR_LBR;
>   		vmcs_write64(GUEST_IA32_DEBUGCTL, data);
> +		vcpu_to_lbr_desc(vcpu)->state = LBR_STATE_FREEZE_ON_PMI;
>   	}
>   }
>   
> @@ -765,9 +766,10 @@ static void intel_pmu_cleanup(struct kvm_vcpu *vcpu)
>   	struct lbr_desc *lbr_desc = vcpu_to_lbr_desc(vcpu);
>   
>   	if (!(vmcs_read64(GUEST_IA32_DEBUGCTL) & DEBUGCTLMSR_LBR)) {
> -		if (!lbr_desc->in_use)
> +		if (lbr_desc->state == LBR_STATE_PREDICT_FREE)
>   			intel_pmu_release_guest_lbr_event(vcpu);
> -		lbr_desc->in_use = false;
> +		else if (lbr_desc->state == LBR_STATE_IN_USE)
> +			lbr_desc->state = LBR_STATE_PREDICT_FREE;
>   	}
>   }


I'm concerning whether there is a risk that the vLBR event can't be 
released forever. Base on the logic, the state must be set to 
LBR_STATE_IN_USE firstly and then could be freed in next cycle. Assuming 
the guest PMI handler doesn't enable LBR again as some reason, the LBR 
state would stay in LBR_STATE_FREEZE_ON_PMI state and the vLBR event 
would not be released and LBR stack would not be reset. when guest 
enables LBR in next time, guest may see the stale LBR data. I think we 
may add a backup mechanism to ensure the vLBR event can be freed if vLBR 
is disabled after several schedule slots.

>   
> diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
> index 4056e19266b5..565df8eeb78b 100644
> --- a/arch/x86/kvm/vmx/vmx.c
> +++ b/arch/x86/kvm/vmx/vmx.c
> @@ -2242,7 +2242,7 @@ static int vmx_set_msr(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
>   		if (intel_pmu_lbr_is_enabled(vcpu) && (data & DEBUGCTLMSR_LBR)) {
>   			struct lbr_desc *lbr_desc = vcpu_to_lbr_desc(vcpu);
>   
> -			lbr_desc->in_use = true;
> +			lbr_desc->state = LBR_STATE_IN_USE;
>   			if (!lbr_desc->event)
>   				intel_pmu_create_guest_lbr_event(vcpu);
>   		}
> diff --git a/arch/x86/kvm/vmx/vmx.h b/arch/x86/kvm/vmx/vmx.h
> index 547edeb52d09..0cb68a319fc8 100644
> --- a/arch/x86/kvm/vmx/vmx.h
> +++ b/arch/x86/kvm/vmx/vmx.h
> @@ -93,6 +93,12 @@ union vmx_exit_reason {
>   	u32 full;
>   };
>   
> +enum lbr_state {
> +	LBR_STATE_PREDICT_FREE = 0,
> +	LBR_STATE_IN_USE = 1,
> +	LBR_STATE_FREEZE_ON_PMI = 2
> +};
> +
>   struct lbr_desc {
>   	/* Basic info about guest LBR records. */
>   	struct x86_pmu_lbr records;
> @@ -108,7 +114,7 @@ struct lbr_desc {
>   	/* True if LBRs are marked as not intercepted in the MSR bitmap */
>   	bool msr_passthrough;
>   
> -	bool in_use;
> +	enum lbr_state state;
>   };
>   
>   /*
