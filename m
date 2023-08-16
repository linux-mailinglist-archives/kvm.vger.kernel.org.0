Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6AC7877DB16
	for <lists+kvm@lfdr.de>; Wed, 16 Aug 2023 09:25:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242396AbjHPHZA (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 16 Aug 2023 03:25:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57538 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242452AbjHPHYz (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 16 Aug 2023 03:24:55 -0400
Received: from mgamail.intel.com (mgamail.intel.com [134.134.136.100])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 479F110C0;
        Wed, 16 Aug 2023 00:24:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1692170694; x=1723706694;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=FuXk8eaDhEmSlSSgWaMjdVgErM9HdCsrnMZcT9jfoxw=;
  b=A++XqVmufwHIu60fewmAUelLd563JZ9l8t8JlAita1mfWnUGzcD7+5xJ
   BU17loh/gRs3zUmA25BA1z5dLM62MrpwGlbGHTB2B/jbxmnMLBRRsGS2w
   wmlMI/wck8OAmheq9oKNcBb8gwRc9UdBLqQBXrh788GFCivQ6Oorwemf5
   PyJMxrYRhztZPus15QFwJOae43qLZ0WMPpvY5K0WTFmD7EJoOT2HFsR9I
   j4/Q+sINLgpEVoImoVmk8gqRQIvoNQ90b+LzToA/22r3DWqxSC/MtRFJO
   S+6Qb/RFSCUdX4MJYq5tS5YoPjXF2LZCpUBiwbQ4Jk5viuDTJB822feUZ
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10803"; a="438809307"
X-IronPort-AV: E=Sophos;i="6.01,176,1684825200"; 
   d="scan'208";a="438809307"
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Aug 2023 00:24:49 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10803"; a="683956357"
X-IronPort-AV: E=Sophos;i="6.01,176,1684825200"; 
   d="scan'208";a="683956357"
Received: from yy-desk-7060.sh.intel.com (HELO localhost) ([10.239.159.76])
  by orsmga003.jf.intel.com with ESMTP; 16 Aug 2023 00:24:47 -0700
Date:   Wed, 16 Aug 2023 15:24:46 +0800
From:   Yuan Yao <yuan.yao@linux.intel.com>
To:     Sean Christopherson <seanjc@google.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Zeng Guang <guang.zeng@intel.com>,
        Yuan Yao <yuan.yao@intel.com>
Subject: Re: [PATCH v3 12/15] KVM: nSVM: Use KVM-governed feature framework
 to track "Pause Filter enabled"
Message-ID: <20230816072446.6imoml23qvwxsjql@yy-desk-7060>
References: <20230815203653.519297-1-seanjc@google.com>
 <20230815203653.519297-13-seanjc@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230815203653.519297-13-seanjc@google.com>
User-Agent: NeoMutt/20171215
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_BLOCKED,
        SPF_HELO_NONE,SPF_NONE,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Aug 15, 2023 at 01:36:50PM -0700, Sean Christopherson wrote:
> Track "Pause Filtering is exposed to L1" via governed feature flags
> instead of using dedicated bits/flags in vcpu_svm.
>
> No functional change intended.
>
> Signed-off-by: Sean Christopherson <seanjc@google.com>

Reviewed-by: Yuan Yao <yuan.yao@intel.com>

> ---
>  arch/x86/kvm/governed_features.h |  2 ++
>  arch/x86/kvm/svm/nested.c        | 10 ++++++++--
>  arch/x86/kvm/svm/svm.c           |  7 ++-----
>  arch/x86/kvm/svm/svm.h           |  2 --
>  4 files changed, 12 insertions(+), 9 deletions(-)
>
> diff --git a/arch/x86/kvm/governed_features.h b/arch/x86/kvm/governed_features.h
> index 3a4c0e40e1e0..9afd34f30599 100644
> --- a/arch/x86/kvm/governed_features.h
> +++ b/arch/x86/kvm/governed_features.h
> @@ -12,6 +12,8 @@ KVM_GOVERNED_X86_FEATURE(NRIPS)
>  KVM_GOVERNED_X86_FEATURE(TSCRATEMSR)
>  KVM_GOVERNED_X86_FEATURE(V_VMSAVE_VMLOAD)
>  KVM_GOVERNED_X86_FEATURE(LBRV)
> +KVM_GOVERNED_X86_FEATURE(PAUSEFILTER)
> +KVM_GOVERNED_X86_FEATURE(PFTHRESHOLD)
>
>  #undef KVM_GOVERNED_X86_FEATURE
>  #undef KVM_GOVERNED_FEATURE
> diff --git a/arch/x86/kvm/svm/nested.c b/arch/x86/kvm/svm/nested.c
> index f50f74b1a04e..ac03b2bc5b2c 100644
> --- a/arch/x86/kvm/svm/nested.c
> +++ b/arch/x86/kvm/svm/nested.c
> @@ -743,8 +743,14 @@ static void nested_vmcb02_prepare_control(struct vcpu_svm *svm,
>  	if (!nested_vmcb_needs_vls_intercept(svm))
>  		vmcb02->control.virt_ext |= VIRTUAL_VMLOAD_VMSAVE_ENABLE_MASK;
>
> -	pause_count12 = svm->pause_filter_enabled ? svm->nested.ctl.pause_filter_count : 0;
> -	pause_thresh12 = svm->pause_threshold_enabled ? svm->nested.ctl.pause_filter_thresh : 0;
> +	if (guest_can_use(vcpu, X86_FEATURE_PAUSEFILTER))
> +		pause_count12 = svm->nested.ctl.pause_filter_count;
> +	else
> +		pause_count12 = 0;
> +	if (guest_can_use(vcpu, X86_FEATURE_PFTHRESHOLD))
> +		pause_thresh12 = svm->nested.ctl.pause_filter_thresh;
> +	else
> +		pause_thresh12 = 0;
>  	if (kvm_pause_in_guest(svm->vcpu.kvm)) {
>  		/* use guest values since host doesn't intercept PAUSE */
>  		vmcb02->control.pause_filter_count = pause_count12;
> diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
> index de40745bc8a6..9bfff65e8b7a 100644
> --- a/arch/x86/kvm/svm/svm.c
> +++ b/arch/x86/kvm/svm/svm.c
> @@ -4300,11 +4300,8 @@ static void svm_vcpu_after_set_cpuid(struct kvm_vcpu *vcpu)
>  	if (!guest_cpuid_is_intel(vcpu))
>  		kvm_governed_feature_check_and_set(vcpu, X86_FEATURE_V_VMSAVE_VMLOAD);
>
> -	svm->pause_filter_enabled = kvm_cpu_cap_has(X86_FEATURE_PAUSEFILTER) &&
> -			guest_cpuid_has(vcpu, X86_FEATURE_PAUSEFILTER);
> -
> -	svm->pause_threshold_enabled = kvm_cpu_cap_has(X86_FEATURE_PFTHRESHOLD) &&
> -			guest_cpuid_has(vcpu, X86_FEATURE_PFTHRESHOLD);
> +	kvm_governed_feature_check_and_set(vcpu, X86_FEATURE_PAUSEFILTER);
> +	kvm_governed_feature_check_and_set(vcpu, X86_FEATURE_PFTHRESHOLD);
>
>  	svm->vgif_enabled = vgif && guest_cpuid_has(vcpu, X86_FEATURE_VGIF);
>
> diff --git a/arch/x86/kvm/svm/svm.h b/arch/x86/kvm/svm/svm.h
> index 45cbbdeac3a3..d57a096e070a 100644
> --- a/arch/x86/kvm/svm/svm.h
> +++ b/arch/x86/kvm/svm/svm.h
> @@ -259,8 +259,6 @@ struct vcpu_svm {
>  	bool soft_int_injected;
>
>  	/* optional nested SVM features that are enabled for this guest  */
> -	bool pause_filter_enabled         : 1;
> -	bool pause_threshold_enabled      : 1;
>  	bool vgif_enabled                 : 1;
>  	bool vnmi_enabled                 : 1;
>
> --
> 2.41.0.694.ge786442a9b-goog
>
