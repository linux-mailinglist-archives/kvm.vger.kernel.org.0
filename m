Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A0BFC69E34F
	for <lists+kvm@lfdr.de>; Tue, 21 Feb 2023 16:23:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234178AbjBUPX5 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 21 Feb 2023 10:23:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45324 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233828AbjBUPXz (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 21 Feb 2023 10:23:55 -0500
Received: from mga17.intel.com (mga17.intel.com [192.55.52.151])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BA8809EC3;
        Tue, 21 Feb 2023 07:23:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1676993034; x=1708529034;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=Z6M0/vKzo30bTTnXTPEnegNDD/JsCsXi5PT8Dy1dSkI=;
  b=XA+ZAL+OCm1sY3hfP+5I2hE/CIDHVtrjp06dshf6AVT6mI1sQZFX9RFS
   1VKntG9FK364aAq4GbVptfXpLm9ox0bsqEmI41rrAOaWEeZHjJUcl2Fp4
   yEz1VpycJ91RSxp4cosi5fisiRI0dMwbSTZrm8BQYQYpdUariSRyOTqdd
   /vbFvRwPFVE4o9qOG63RBdgPKZYvwacq8wfAkJzKruwcKDxYPxUkwtu5y
   bvguybtddysIBDARdAXQGfuvUHYHYyBXjOC87Qd7WUBpzHOdAt+dB5FLH
   nLf5M3IStZOKQ2l8siW06YPF9q7v6vkg2jybwHMY7/3KNhftxNdLHvQPp
   w==;
X-IronPort-AV: E=McAfee;i="6500,9779,10628"; a="313028857"
X-IronPort-AV: E=Sophos;i="5.97,315,1669104000"; 
   d="scan'208";a="313028857"
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Feb 2023 07:23:54 -0800
X-IronPort-AV: E=McAfee;i="6500,9779,10628"; a="917225773"
X-IronPort-AV: E=Sophos;i="5.97,315,1669104000"; 
   d="scan'208";a="917225773"
Received: from yichaohu-mobl.ccr.corp.intel.com (HELO localhost) ([10.254.208.83])
  by fmsmga006-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Feb 2023 07:23:52 -0800
Date:   Tue, 21 Feb 2023 23:23:49 +0800
From:   Yu Zhang <yu.c.zhang@linux.intel.com>
To:     Sean Christopherson <seanjc@google.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 08/12] KVM: nSVM: Use KVM-governed feature framework to
 track "vVM{SAVE,LOAD} enabled"
Message-ID: <20230221152349.ulcjtbnvziair7ff@linux.intel.com>
References: <20230217231022.816138-1-seanjc@google.com>
 <20230217231022.816138-9-seanjc@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230217231022.816138-9-seanjc@google.com>
User-Agent: NeoMutt/20171215
X-Spam-Status: No, score=-4.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Feb 17, 2023 at 03:10:18PM -0800, Sean Christopherson wrote:
> Track "virtual VMSAVE/VMLOAD exposed to L1" via a governed feature flag
> instead of using a dedicated bit/flag in vcpu_svm.
> 
> No functional change intended.
> 
> Signed-off-by: Sean Christopherson <seanjc@google.com>
> ---
>  arch/x86/kvm/governed_features.h | 1 +
>  arch/x86/kvm/svm/nested.c        | 2 +-
>  arch/x86/kvm/svm/svm.c           | 5 ++---
>  arch/x86/kvm/svm/svm.h           | 1 -
>  4 files changed, 4 insertions(+), 5 deletions(-)
> 
> diff --git a/arch/x86/kvm/governed_features.h b/arch/x86/kvm/governed_features.h
> index 0335576a80a8..b66b9d550f33 100644
> --- a/arch/x86/kvm/governed_features.h
> +++ b/arch/x86/kvm/governed_features.h
> @@ -9,6 +9,7 @@ KVM_GOVERNED_X86_FEATURE(GBPAGES)
>  KVM_GOVERNED_X86_FEATURE(XSAVES)
>  KVM_GOVERNED_X86_FEATURE(NRIPS)
>  KVM_GOVERNED_X86_FEATURE(TSCRATEMSR)
> +KVM_GOVERNED_X86_FEATURE(V_VMSAVE_VMLOAD)
>  
>  #undef KVM_GOVERNED_X86_FEATURE
>  #undef KVM_GOVERNED_FEATURE
> diff --git a/arch/x86/kvm/svm/nested.c b/arch/x86/kvm/svm/nested.c
> index 30e00c4e07c7..6a96058c0e48 100644
> --- a/arch/x86/kvm/svm/nested.c
> +++ b/arch/x86/kvm/svm/nested.c
> @@ -107,7 +107,7 @@ static void nested_svm_uninit_mmu_context(struct kvm_vcpu *vcpu)
>  
>  static bool nested_vmcb_needs_vls_intercept(struct vcpu_svm *svm)
>  {
> -	if (!svm->v_vmload_vmsave_enabled)
> +	if (!guest_can_use(&svm->vcpu, X86_FEATURE_V_VMSAVE_VMLOAD))
>  		return true;
>  
>  	if (!nested_npt_enabled(svm))
> diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
> index dd4aead5462c..b3f0271c73b9 100644
> --- a/arch/x86/kvm/svm/svm.c
> +++ b/arch/x86/kvm/svm/svm.c
> @@ -1162,8 +1162,6 @@ static inline void init_vmcb_after_set_cpuid(struct kvm_vcpu *vcpu)
>  
>  		set_msr_interception(vcpu, svm->msrpm, MSR_IA32_SYSENTER_EIP, 0, 0);
>  		set_msr_interception(vcpu, svm->msrpm, MSR_IA32_SYSENTER_ESP, 0, 0);
> -
> -		svm->v_vmload_vmsave_enabled = false;
>  	} else {
>  		/*
>  		 * If hardware supports Virtual VMLOAD VMSAVE then enable it
> @@ -4153,7 +4151,8 @@ static void svm_vcpu_after_set_cpuid(struct kvm_vcpu *vcpu)
>  
>  	svm->lbrv_enabled = lbrv && guest_cpuid_has(vcpu, X86_FEATURE_LBRV);
>  
> -	svm->v_vmload_vmsave_enabled = vls && guest_cpuid_has(vcpu, X86_FEATURE_V_VMSAVE_VMLOAD);
> +	if (vls && !guest_cpuid_is_intel(vcpu))
> +		kvm_governed_feature_check_and_set(vcpu, X86_FEATURE_V_VMSAVE_VMLOAD);

Sorry, why guest_cpuid_is_intel(vcpu)? Is it becasue that a AMD host with virtual
VMSAVE/VMLOAD capability will always expose this feature for all AMD guests? 

If yes, how about adding some comments? Thanks!

B.R.
Yu

