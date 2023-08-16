Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6220E77DA68
	for <lists+kvm@lfdr.de>; Wed, 16 Aug 2023 08:19:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242053AbjHPGTQ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 16 Aug 2023 02:19:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44766 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242091AbjHPGSu (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 16 Aug 2023 02:18:50 -0400
Received: from mgamail.intel.com (mgamail.intel.com [134.134.136.31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 205DA1BE6;
        Tue, 15 Aug 2023 23:18:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1692166729; x=1723702729;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=rmaGpqgmqHBPiSdtmwJkObODwLvcQ3yhPyjaJpg/XkM=;
  b=DK2N3H/BJ+3NUIpsvTNeZK9sargxZaNEut5VKyJGvhvwe5moKL5p6RXi
   yF87IST1hxuxj45qS6sZyB8aRHpDRzMJx78ABIBDV5uHUL4hfEEVRaZJL
   qJiEPDZEF0A1EFQaJZmSE43s8JsYh+oFGelTZznnD1AI1w9Ht7re/qgLq
   xUyNdJi3WR6Z31PW71bxLyw0RYOiEyiMa4tFM5iydT7lZ+tCRln6Cmw7e
   xhSuHNfUXdjHbHYz0GeZlJFLOuCZVO/L8ZPHKrwnZy+Ew7Wd5SRt+h9tK
   G5//rU0jGxjIIguZlFhXRd2iLJkdStX7wp80Me95YqPOYVegTEjHJs1Sf
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10803"; a="436352582"
X-IronPort-AV: E=Sophos;i="6.01,176,1684825200"; 
   d="scan'208";a="436352582"
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Aug 2023 23:18:48 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10803"; a="727646619"
X-IronPort-AV: E=Sophos;i="6.01,176,1684825200"; 
   d="scan'208";a="727646619"
Received: from yy-desk-7060.sh.intel.com (HELO localhost) ([10.239.159.76])
  by orsmga007.jf.intel.com with ESMTP; 15 Aug 2023 23:18:46 -0700
Date:   Wed, 16 Aug 2023 14:18:45 +0800
From:   Yuan Yao <yuan.yao@linux.intel.com>
To:     Sean Christopherson <seanjc@google.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Zeng Guang <guang.zeng@intel.com>,
        Yuan Yao <yuan.yao@intel.com>
Subject: Re: [PATCH v3 08/15] KVM: nSVM: Use KVM-governed feature framework
 to track "NRIPS enabled"
Message-ID: <20230816061845.qygaiwsgbi3sp2ya@yy-desk-7060>
References: <20230815203653.519297-1-seanjc@google.com>
 <20230815203653.519297-9-seanjc@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230815203653.519297-9-seanjc@google.com>
User-Agent: NeoMutt/20171215
X-Spam-Status: No, score=-4.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE,URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Aug 15, 2023 at 01:36:46PM -0700, Sean Christopherson wrote:
> Track "NRIPS exposed to L1" via a governed feature flag instead of using
> a dedicated bit/flag in vcpu_svm.
>
> No functional change intended.
>
> Signed-off-by: Sean Christopherson <seanjc@google.com>

Reviewed-by: Yuan Yao <yuan.yao@intel.com>

> ---
>  arch/x86/kvm/governed_features.h | 1 +
>  arch/x86/kvm/svm/nested.c        | 6 +++---
>  arch/x86/kvm/svm/svm.c           | 4 +---
>  arch/x86/kvm/svm/svm.h           | 1 -
>  4 files changed, 5 insertions(+), 7 deletions(-)
>
> diff --git a/arch/x86/kvm/governed_features.h b/arch/x86/kvm/governed_features.h
> index 22446614bf49..722b66af412c 100644
> --- a/arch/x86/kvm/governed_features.h
> +++ b/arch/x86/kvm/governed_features.h
> @@ -8,6 +8,7 @@ BUILD_BUG()
>  KVM_GOVERNED_X86_FEATURE(GBPAGES)
>  KVM_GOVERNED_X86_FEATURE(XSAVES)
>  KVM_GOVERNED_X86_FEATURE(VMX)
> +KVM_GOVERNED_X86_FEATURE(NRIPS)
>
>  #undef KVM_GOVERNED_X86_FEATURE
>  #undef KVM_GOVERNED_FEATURE
> diff --git a/arch/x86/kvm/svm/nested.c b/arch/x86/kvm/svm/nested.c
> index 3342cc4a5189..9092f3f8dccf 100644
> --- a/arch/x86/kvm/svm/nested.c
> +++ b/arch/x86/kvm/svm/nested.c
> @@ -716,7 +716,7 @@ static void nested_vmcb02_prepare_control(struct vcpu_svm *svm,
>  	 * what a nrips=0 CPU would do (L1 is responsible for advancing RIP
>  	 * prior to injecting the event).
>  	 */
> -	if (svm->nrips_enabled)
> +	if (guest_can_use(vcpu, X86_FEATURE_NRIPS))
>  		vmcb02->control.next_rip    = svm->nested.ctl.next_rip;
>  	else if (boot_cpu_has(X86_FEATURE_NRIPS))
>  		vmcb02->control.next_rip    = vmcb12_rip;
> @@ -726,7 +726,7 @@ static void nested_vmcb02_prepare_control(struct vcpu_svm *svm,
>  		svm->soft_int_injected = true;
>  		svm->soft_int_csbase = vmcb12_csbase;
>  		svm->soft_int_old_rip = vmcb12_rip;
> -		if (svm->nrips_enabled)
> +		if (guest_can_use(vcpu, X86_FEATURE_NRIPS))
>  			svm->soft_int_next_rip = svm->nested.ctl.next_rip;
>  		else
>  			svm->soft_int_next_rip = vmcb12_rip;
> @@ -1026,7 +1026,7 @@ int nested_svm_vmexit(struct vcpu_svm *svm)
>  	if (vmcb12->control.exit_code != SVM_EXIT_ERR)
>  		nested_save_pending_event_to_vmcb12(svm, vmcb12);
>
> -	if (svm->nrips_enabled)
> +	if (guest_can_use(vcpu, X86_FEATURE_NRIPS))
>  		vmcb12->control.next_rip  = vmcb02->control.next_rip;
>
>  	vmcb12->control.int_ctl           = svm->nested.ctl.int_ctl;
> diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
> index d67f6e23dcd2..c8b97cb3138c 100644
> --- a/arch/x86/kvm/svm/svm.c
> +++ b/arch/x86/kvm/svm/svm.c
> @@ -4288,9 +4288,7 @@ static void svm_vcpu_after_set_cpuid(struct kvm_vcpu *vcpu)
>  	    guest_cpuid_has(vcpu, X86_FEATURE_XSAVE))
>  		kvm_governed_feature_set(vcpu, X86_FEATURE_XSAVES);
>
> -	/* Update nrips enabled cache */
> -	svm->nrips_enabled = kvm_cpu_cap_has(X86_FEATURE_NRIPS) &&
> -			     guest_cpuid_has(vcpu, X86_FEATURE_NRIPS);
> +	kvm_governed_feature_check_and_set(vcpu, X86_FEATURE_NRIPS);
>
>  	svm->tsc_scaling_enabled = tsc_scaling && guest_cpuid_has(vcpu, X86_FEATURE_TSCRATEMSR);
>  	svm->lbrv_enabled = lbrv && guest_cpuid_has(vcpu, X86_FEATURE_LBRV);
> diff --git a/arch/x86/kvm/svm/svm.h b/arch/x86/kvm/svm/svm.h
> index 5115b35a4d31..e147f2046ffa 100644
> --- a/arch/x86/kvm/svm/svm.h
> +++ b/arch/x86/kvm/svm/svm.h
> @@ -259,7 +259,6 @@ struct vcpu_svm {
>  	bool soft_int_injected;
>
>  	/* optional nested SVM features that are enabled for this guest  */
> -	bool nrips_enabled                : 1;
>  	bool tsc_scaling_enabled          : 1;
>  	bool v_vmload_vmsave_enabled      : 1;
>  	bool lbrv_enabled                 : 1;
> --
> 2.41.0.694.ge786442a9b-goog
>
