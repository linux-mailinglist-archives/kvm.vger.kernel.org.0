Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 316D177DA85
	for <lists+kvm@lfdr.de>; Wed, 16 Aug 2023 08:36:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242150AbjHPGgR (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 16 Aug 2023 02:36:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40250 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242147AbjHPGfy (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 16 Aug 2023 02:35:54 -0400
Received: from mgamail.intel.com (mgamail.intel.com [134.134.136.24])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 138981B2;
        Tue, 15 Aug 2023 23:35:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1692167753; x=1723703753;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=kqXuORo6oWKj5r+Wsh1IBbFbA0PzSHmTKaJuSgC0YLw=;
  b=WFf+XAKtQwMGqOxok4N58u0P/KSUGaf1t3Tz/hfGcv80juP7sddcoJu9
   aS08QMGnbtwJv5RupidWi/E/6iw/GbJ1sIoUnhQCZEghBqWgyJB+0w7dz
   dsMba3lirRn2JEEZUYx69lKOIo/6Upzo/g+3RdvJwAdfCByWzbrNE6bp8
   eLuEKHDNPEpAEDNjj2JByZnzcFhpl9xZeDdgCMdqh6lQAqSmBQGmBGNKT
   hJ/1shOx/KYfz0wU7hXPQ15EvibVEp+bsAhBRvlzqj11NFUkGjI2wXsW7
   EICOyAv3dp7qsAHFLCu4fkXuKL6zHzaQMEKHgQZlxvyx8dTwXHTjYpDQG
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10803"; a="375224537"
X-IronPort-AV: E=Sophos;i="6.01,176,1684825200"; 
   d="scan'208";a="375224537"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Aug 2023 23:35:33 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.01,202,1684825200"; 
   d="scan'208";a="877655127"
Received: from yy-desk-7060.sh.intel.com (HELO localhost) ([10.239.159.76])
  by fmsmga001.fm.intel.com with ESMTP; 15 Aug 2023 23:35:35 -0700
Date:   Wed, 16 Aug 2023 14:35:31 +0800
From:   Yuan Yao <yuan.yao@linux.intel.com>
To:     Sean Christopherson <seanjc@google.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Zeng Guang <guang.zeng@intel.com>,
        Yuan Yao <yuan.yao@intel.com>
Subject: Re: [PATCH v3 09/15] KVM: nSVM: Use KVM-governed feature framework
 to track "TSC scaling enabled"
Message-ID: <20230816063531.rq7tyrvceln5q4du@yy-desk-7060>
References: <20230815203653.519297-1-seanjc@google.com>
 <20230815203653.519297-10-seanjc@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230815203653.519297-10-seanjc@google.com>
User-Agent: NeoMutt/20171215
X-Spam-Status: No, score=-4.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Aug 15, 2023 at 01:36:47PM -0700, Sean Christopherson wrote:
> Track "TSC scaling exposed to L1" via a governed feature flag instead of
> using a dedicated bit/flag in vcpu_svm.
>
> Note, this fixes a benign bug where KVM would mark TSC scaling as exposed
> to L1 even if overall nested SVM supported is disabled, i.e. KVM would let
> L1 write MSR_AMD64_TSC_RATIO even when KVM didn't advertise TSCRATEMSR
> support to userspace.
>
> Signed-off-by: Sean Christopherson <seanjc@google.com>
> ---
>  arch/x86/kvm/governed_features.h |  1 +
>  arch/x86/kvm/svm/nested.c        |  2 +-
>  arch/x86/kvm/svm/svm.c           | 10 ++++++----
>  arch/x86/kvm/svm/svm.h           |  1 -
>  4 files changed, 8 insertions(+), 6 deletions(-)
>
> diff --git a/arch/x86/kvm/governed_features.h b/arch/x86/kvm/governed_features.h
> index 722b66af412c..32c0469cf952 100644
> --- a/arch/x86/kvm/governed_features.h
> +++ b/arch/x86/kvm/governed_features.h
> @@ -9,6 +9,7 @@ KVM_GOVERNED_X86_FEATURE(GBPAGES)
>  KVM_GOVERNED_X86_FEATURE(XSAVES)
>  KVM_GOVERNED_X86_FEATURE(VMX)
>  KVM_GOVERNED_X86_FEATURE(NRIPS)
> +KVM_GOVERNED_X86_FEATURE(TSCRATEMSR)
>
>  #undef KVM_GOVERNED_X86_FEATURE
>  #undef KVM_GOVERNED_FEATURE
> diff --git a/arch/x86/kvm/svm/nested.c b/arch/x86/kvm/svm/nested.c
> index 9092f3f8dccf..da65948064dc 100644
> --- a/arch/x86/kvm/svm/nested.c
> +++ b/arch/x86/kvm/svm/nested.c
> @@ -695,7 +695,7 @@ static void nested_vmcb02_prepare_control(struct vcpu_svm *svm,
>
>  	vmcb02->control.tsc_offset = vcpu->arch.tsc_offset;
>
> -	if (svm->tsc_scaling_enabled &&
> +	if (guest_can_use(vcpu, X86_FEATURE_TSCRATEMSR) &&
>  	    svm->tsc_ratio_msr != kvm_caps.default_tsc_scaling_ratio)
>  		nested_svm_update_tsc_ratio_msr(vcpu);
>
> diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
> index c8b97cb3138c..15c79457d8c5 100644
> --- a/arch/x86/kvm/svm/svm.c
> +++ b/arch/x86/kvm/svm/svm.c
> @@ -2809,7 +2809,8 @@ static int svm_get_msr(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
>
>  	switch (msr_info->index) {
>  	case MSR_AMD64_TSC_RATIO:
> -		if (!msr_info->host_initiated && !svm->tsc_scaling_enabled)
> +		if (!msr_info->host_initiated &&
> +		    !guest_can_use(vcpu, X86_FEATURE_TSCRATEMSR))
>  			return 1;
>  		msr_info->data = svm->tsc_ratio_msr;
>  		break;
> @@ -2959,7 +2960,7 @@ static int svm_set_msr(struct kvm_vcpu *vcpu, struct msr_data *msr)
>  	switch (ecx) {
>  	case MSR_AMD64_TSC_RATIO:
>
> -		if (!svm->tsc_scaling_enabled) {
> +		if (!guest_can_use(vcpu, X86_FEATURE_TSCRATEMSR)) {
>
>  			if (!msr->host_initiated)
>  				return 1;
> @@ -2981,7 +2982,8 @@ static int svm_set_msr(struct kvm_vcpu *vcpu, struct msr_data *msr)
>
>  		svm->tsc_ratio_msr = data;
>
> -		if (svm->tsc_scaling_enabled && is_guest_mode(vcpu))
> +		if (guest_can_use(vcpu, X86_FEATURE_TSCRATEMSR) &&
> +		    is_guest_mode(vcpu))

I prefer (is_guest_mode(vcpu) && ....), so I can skip them more quickly LOL.
but anyway depends on you :-)

>  			nested_svm_update_tsc_ratio_msr(vcpu);
>
>  		break;
> @@ -4289,8 +4291,8 @@ static void svm_vcpu_after_set_cpuid(struct kvm_vcpu *vcpu)
>  		kvm_governed_feature_set(vcpu, X86_FEATURE_XSAVES);
>
>  	kvm_governed_feature_check_and_set(vcpu, X86_FEATURE_NRIPS);
> +	kvm_governed_feature_check_and_set(vcpu, X86_FEATURE_TSCRATEMSR);
>
> -	svm->tsc_scaling_enabled = tsc_scaling && guest_cpuid_has(vcpu, X86_FEATURE_TSCRATEMSR);

Not account "nested" is the reason of the benign bug.

Reviewed-by: Yuan Yao <yuan.yao@intel.com>

>  	svm->lbrv_enabled = lbrv && guest_cpuid_has(vcpu, X86_FEATURE_LBRV);
>
>  	svm->v_vmload_vmsave_enabled = vls && guest_cpuid_has(vcpu, X86_FEATURE_V_VMSAVE_VMLOAD);
> diff --git a/arch/x86/kvm/svm/svm.h b/arch/x86/kvm/svm/svm.h
> index e147f2046ffa..3696f10e2887 100644
> --- a/arch/x86/kvm/svm/svm.h
> +++ b/arch/x86/kvm/svm/svm.h
> @@ -259,7 +259,6 @@ struct vcpu_svm {
>  	bool soft_int_injected;
>
>  	/* optional nested SVM features that are enabled for this guest  */
> -	bool tsc_scaling_enabled          : 1;
>  	bool v_vmload_vmsave_enabled      : 1;
>  	bool lbrv_enabled                 : 1;
>  	bool pause_filter_enabled         : 1;
> --
> 2.41.0.694.ge786442a9b-goog
>
