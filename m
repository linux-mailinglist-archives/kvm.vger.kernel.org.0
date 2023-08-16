Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A7A5E77DB1B
	for <lists+kvm@lfdr.de>; Wed, 16 Aug 2023 09:28:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242404AbjHPH1o (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 16 Aug 2023 03:27:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45858 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237544AbjHPH1P (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 16 Aug 2023 03:27:15 -0400
Received: from mgamail.intel.com (mgamail.intel.com [134.134.136.20])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8A6D8C1;
        Wed, 16 Aug 2023 00:27:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1692170834; x=1723706834;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=DqjOkYBmd2qQsOWks5dyAjs0faGjRt37ofw89A2DOuk=;
  b=UxEgkipL3Z31vWIJeAt/vB7m+4Js74kqeRfODrZGja8a3Dz/ki4lE2lG
   uUe29/OwMul73CG20YuW2alDDAVF51ef5wunJPi+D00WIJqGH0wwfJsYA
   EFU6G9pOAymuXsZpxBqaAqBb7Z6jF9K34YdSs7CkST4kF4qVFrEYfsSnW
   aRvznctHIhcT/8AMBkBxd3GiooAFROjcUaP7DyGbtZVu9/Is8yDdLP4hK
   lfn7yGhCfO/ja0QwT5HtgY/Ly7zfYfxD3YavSRl8I1UVO/QuSBevewXnm
   /HB7T3gnhh9faMNFPigEZQ7yrsVRF0jqgNuPtKB1WFkyhmz9VD6H/qQUF
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10803"; a="362618996"
X-IronPort-AV: E=Sophos;i="6.01,176,1684825200"; 
   d="scan'208";a="362618996"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Aug 2023 00:27:14 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10803"; a="799475083"
X-IronPort-AV: E=Sophos;i="6.01,176,1684825200"; 
   d="scan'208";a="799475083"
Received: from yy-desk-7060.sh.intel.com (HELO localhost) ([10.239.159.76])
  by fmsmga008.fm.intel.com with ESMTP; 16 Aug 2023 00:27:11 -0700
Date:   Wed, 16 Aug 2023 15:27:11 +0800
From:   Yuan Yao <yuan.yao@linux.intel.com>
To:     Sean Christopherson <seanjc@google.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Zeng Guang <guang.zeng@intel.com>,
        Yuan Yao <yuan.yao@intel.com>
Subject: Re: [PATCH v3 13/15] KVM: nSVM: Use KVM-governed feature framework
 to track "vGIF enabled"
Message-ID: <20230816072711.jurh2r35dwxrff2a@yy-desk-7060>
References: <20230815203653.519297-1-seanjc@google.com>
 <20230815203653.519297-14-seanjc@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230815203653.519297-14-seanjc@google.com>
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

On Tue, Aug 15, 2023 at 01:36:51PM -0700, Sean Christopherson wrote:
> Track "virtual GIF exposed to L1" via a governed feature flag instead of
> using a dedicated bit/flag in vcpu_svm.
>
> Note, checking KVM's capabilities instead of the "vgif" param means that
> the code isn't strictly equivalent, as vgif_enabled could have been set
> if nested=false where as that the governed feature cannot.  But that's a
> glorified nop as the feature/flag is consumed only by paths that are

gated by nSVM being enabled.

>
> Signed-off-by: Sean Christopherson <seanjc@google.com>
> ---
>  arch/x86/kvm/governed_features.h | 1 +
>  arch/x86/kvm/svm/nested.c        | 3 ++-
>  arch/x86/kvm/svm/svm.c           | 3 +--
>  arch/x86/kvm/svm/svm.h           | 5 +++--
>  4 files changed, 7 insertions(+), 5 deletions(-)
>
> diff --git a/arch/x86/kvm/governed_features.h b/arch/x86/kvm/governed_features.h
> index 9afd34f30599..368696c2e96b 100644
> --- a/arch/x86/kvm/governed_features.h
> +++ b/arch/x86/kvm/governed_features.h
> @@ -14,6 +14,7 @@ KVM_GOVERNED_X86_FEATURE(V_VMSAVE_VMLOAD)
>  KVM_GOVERNED_X86_FEATURE(LBRV)
>  KVM_GOVERNED_X86_FEATURE(PAUSEFILTER)
>  KVM_GOVERNED_X86_FEATURE(PFTHRESHOLD)
> +KVM_GOVERNED_X86_FEATURE(VGIF)
>
>  #undef KVM_GOVERNED_X86_FEATURE
>  #undef KVM_GOVERNED_FEATURE
> diff --git a/arch/x86/kvm/svm/nested.c b/arch/x86/kvm/svm/nested.c
> index ac03b2bc5b2c..dd496c9e5f91 100644
> --- a/arch/x86/kvm/svm/nested.c
> +++ b/arch/x86/kvm/svm/nested.c
> @@ -660,7 +660,8 @@ static void nested_vmcb02_prepare_control(struct vcpu_svm *svm,
>  	 * exit_int_info, exit_int_info_err, next_rip, insn_len, insn_bytes.
>  	 */
>
> -	if (svm->vgif_enabled && (svm->nested.ctl.int_ctl & V_GIF_ENABLE_MASK))
> +	if (guest_can_use(vcpu, X86_FEATURE_VGIF) &&
> +	    (svm->nested.ctl.int_ctl & V_GIF_ENABLE_MASK))
>  		int_ctl_vmcb12_bits |= (V_GIF_MASK | V_GIF_ENABLE_MASK);
>  	else
>  		int_ctl_vmcb01_bits |= (V_GIF_MASK | V_GIF_ENABLE_MASK);
> diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
> index 9bfff65e8b7a..9eac0ad3403e 100644
> --- a/arch/x86/kvm/svm/svm.c
> +++ b/arch/x86/kvm/svm/svm.c
> @@ -4302,8 +4302,7 @@ static void svm_vcpu_after_set_cpuid(struct kvm_vcpu *vcpu)
>
>  	kvm_governed_feature_check_and_set(vcpu, X86_FEATURE_PAUSEFILTER);
>  	kvm_governed_feature_check_and_set(vcpu, X86_FEATURE_PFTHRESHOLD);
> -
> -	svm->vgif_enabled = vgif && guest_cpuid_has(vcpu, X86_FEATURE_VGIF);
> +	kvm_governed_feature_check_and_set(vcpu, X86_FEATURE_VGIF);
>
>  	svm->vnmi_enabled = vnmi && guest_cpuid_has(vcpu, X86_FEATURE_VNMI);
>
> diff --git a/arch/x86/kvm/svm/svm.h b/arch/x86/kvm/svm/svm.h
> index d57a096e070a..eaddaac6bf18 100644
> --- a/arch/x86/kvm/svm/svm.h
> +++ b/arch/x86/kvm/svm/svm.h
> @@ -22,6 +22,7 @@
>  #include <asm/svm.h>
>  #include <asm/sev-common.h>
>
> +#include "cpuid.h"
>  #include "kvm_cache_regs.h"
>
>  #define __sme_page_pa(x) __sme_set(page_to_pfn(x) << PAGE_SHIFT)
> @@ -259,7 +260,6 @@ struct vcpu_svm {
>  	bool soft_int_injected;
>
>  	/* optional nested SVM features that are enabled for this guest  */
> -	bool vgif_enabled                 : 1;
>  	bool vnmi_enabled                 : 1;
>
>  	u32 ldr_reg;
> @@ -443,7 +443,8 @@ static inline bool svm_is_intercept(struct vcpu_svm *svm, int bit)
>
>  static inline bool nested_vgif_enabled(struct vcpu_svm *svm)
>  {
> -	return svm->vgif_enabled && (svm->nested.ctl.int_ctl & V_GIF_ENABLE_MASK);
> +	return guest_can_use(&svm->vcpu, X86_FEATURE_VGIF) &&
> +	       (svm->nested.ctl.int_ctl & V_GIF_ENABLE_MASK);
>  }
>
>  static inline struct vmcb *get_vgif_vmcb(struct vcpu_svm *svm)
> --
> 2.41.0.694.ge786442a9b-goog
>
