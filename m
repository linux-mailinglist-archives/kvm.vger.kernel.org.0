Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 22A8377D8B9
	for <lists+kvm@lfdr.de>; Wed, 16 Aug 2023 04:59:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241423AbjHPC7F (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 15 Aug 2023 22:59:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49402 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241451AbjHPC6t (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 15 Aug 2023 22:58:49 -0400
Received: from mgamail.intel.com (mgamail.intel.com [134.134.136.24])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5C3A0212E;
        Tue, 15 Aug 2023 19:58:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1692154725; x=1723690725;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=1f/Vy3LfuSuWALj45td3XyVhJGWgqfyRRn5kWtTOnQg=;
  b=CM7Wf952eefuOOo1M8vFNdNghqnfGJZI7DHOjaqNqk6HG3ooyT1d6iIE
   BNlFdMaRY9j3LSoynlMQaky1p5EnafTHBoYCCq89rKKyFKWsquKZIj3e4
   Y7CV32E0/Q/aLlHW3KxXgYnaF6aUbtD6q083yx0OAttWaj3mMwf7BGC4S
   JPkHTu+7KyjJNCaMRY+Ewgqx9p6M8A+B0QufnGPe9spQx6BvyN8lc7xXG
   YZ99C3tuWFYr3yZ8EnlXvJnI+Uqd5nM7a2f1G58B6P9Gz5fYJyMWOpF9d
   iNkZSZ1y1T/bpsHy5you4dsV2/syRUpRVGLcdZAAfVb2F+GFFWlj+Zdr4
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10803"; a="375197896"
X-IronPort-AV: E=Sophos;i="6.01,175,1684825200"; 
   d="scan'208";a="375197896"
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Aug 2023 19:58:44 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10803"; a="824078911"
X-IronPort-AV: E=Sophos;i="6.01,175,1684825200"; 
   d="scan'208";a="824078911"
Received: from yy-desk-7060.sh.intel.com (HELO localhost) ([10.239.159.76])
  by FMSMGA003.fm.intel.com with ESMTP; 15 Aug 2023 19:58:42 -0700
Date:   Wed, 16 Aug 2023 10:58:41 +0800
From:   Yuan Yao <yuan.yao@linux.intel.com>
To:     Sean Christopherson <seanjc@google.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Zeng Guang <guang.zeng@intel.com>,
        Yuan Yao <yuan.yao@intel.com>
Subject: Re: [PATCH v3 06/15] KVM: x86: Use KVM-governed feature framework to
 track "XSAVES enabled"
Message-ID: <20230816025841.hp4lortav6lzwyuy@yy-desk-7060>
References: <20230815203653.519297-1-seanjc@google.com>
 <20230815203653.519297-7-seanjc@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230815203653.519297-7-seanjc@google.com>
User-Agent: NeoMutt/20171215
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_BLOCKED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Aug 15, 2023 at 01:36:44PM -0700, Sean Christopherson wrote:
> Use the governed feature framework to track if XSAVES is "enabled", i.e.
> if XSAVES can be used by the guest.  Add a comment in the SVM code to
> explain the very unintuitive logic of deliberately NOT checking if XSAVES
> is enumerated in the guest CPUID model.
>
> No functional change intended.
>
> Signed-off-by: Sean Christopherson <seanjc@google.com>
> ---
>  arch/x86/include/asm/kvm_host.h  |  1 -
>  arch/x86/kvm/governed_features.h |  1 +
>  arch/x86/kvm/svm/svm.c           | 17 ++++++++++++---
>  arch/x86/kvm/vmx/vmx.c           | 36 ++++++++++++++++----------------
>  arch/x86/kvm/x86.c               |  4 ++--
>  5 files changed, 35 insertions(+), 24 deletions(-)
>
> diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
> index 60d430b4650f..9f57aa33798b 100644
> --- a/arch/x86/include/asm/kvm_host.h
> +++ b/arch/x86/include/asm/kvm_host.h
> @@ -746,7 +746,6 @@ struct kvm_vcpu_arch {
>  	u64 smi_count;
>  	bool at_instruction_boundary;
>  	bool tpr_access_reporting;
> -	bool xsaves_enabled;
>  	bool xfd_no_write_intercept;
>  	u64 ia32_xss;
>  	u64 microcode_version;
> diff --git a/arch/x86/kvm/governed_features.h b/arch/x86/kvm/governed_features.h
> index b29c15d5e038..b896a64e4ac3 100644
> --- a/arch/x86/kvm/governed_features.h
> +++ b/arch/x86/kvm/governed_features.h
> @@ -6,6 +6,7 @@ BUILD_BUG()
>  #define KVM_GOVERNED_X86_FEATURE(x) KVM_GOVERNED_FEATURE(X86_FEATURE_##x)
>
>  KVM_GOVERNED_X86_FEATURE(GBPAGES)
> +KVM_GOVERNED_X86_FEATURE(XSAVES)
>
>  #undef KVM_GOVERNED_X86_FEATURE
>  #undef KVM_GOVERNED_FEATURE
> diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
> index 6aaa3c7b4578..d67f6e23dcd2 100644
> --- a/arch/x86/kvm/svm/svm.c
> +++ b/arch/x86/kvm/svm/svm.c
> @@ -4273,9 +4273,20 @@ static void svm_vcpu_after_set_cpuid(struct kvm_vcpu *vcpu)
>  	struct vcpu_svm *svm = to_svm(vcpu);
>  	struct kvm_cpuid_entry2 *best;
>
> -	vcpu->arch.xsaves_enabled = guest_cpuid_has(vcpu, X86_FEATURE_XSAVE) &&
> -				    boot_cpu_has(X86_FEATURE_XSAVE) &&
> -				    boot_cpu_has(X86_FEATURE_XSAVES);
> +	/*
> +	 * SVM doesn't provide a way to disable just XSAVES in the guest, KVM
> +	 * can only disable all variants of by disallowing CR4.OSXSAVE from
> +	 * being set.  As a result, if the host has XSAVE and XSAVES, and the
> +	 * guest has XSAVE enabled, the guest can execute XSAVES without
> +	 * faulting.  Treat XSAVES as enabled in this case regardless of
> +	 * whether it's advertised to the guest so that KVM context switches
> +	 * XSS on VM-Enter/VM-Exit.  Failure to do so would effectively give
> +	 * the guest read/write access to the host's XSS.
> +	 */
> +	if (boot_cpu_has(X86_FEATURE_XSAVE) &&
> +	    boot_cpu_has(X86_FEATURE_XSAVES) &&
> +	    guest_cpuid_has(vcpu, X86_FEATURE_XSAVE))
> +		kvm_governed_feature_set(vcpu, X86_FEATURE_XSAVES);
>
>  	/* Update nrips enabled cache */
>  	svm->nrips_enabled = kvm_cpu_cap_has(X86_FEATURE_NRIPS) &&
> diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
> index 22975cc949b7..6314ca32a5cf 100644
> --- a/arch/x86/kvm/vmx/vmx.c
> +++ b/arch/x86/kvm/vmx/vmx.c
> @@ -4543,16 +4543,19 @@ vmx_adjust_secondary_exec_control(struct vcpu_vmx *vmx, u32 *exec_control,
>   * based on a single guest CPUID bit, with a dedicated feature bit.  This also
>   * verifies that the control is actually supported by KVM and hardware.
>   */
> -#define vmx_adjust_sec_exec_control(vmx, exec_control, name, feat_name, ctrl_name, exiting) \
> -({									 \
> -	bool __enabled;							 \
> -									 \
> -	if (cpu_has_vmx_##name()) {					 \
> -		__enabled = guest_cpuid_has(&(vmx)->vcpu,		 \
> -					    X86_FEATURE_##feat_name);	 \
> -		vmx_adjust_secondary_exec_control(vmx, exec_control,	 \
> -			SECONDARY_EXEC_##ctrl_name, __enabled, exiting); \
> -	}								 \
> +#define vmx_adjust_sec_exec_control(vmx, exec_control, name, feat_name, ctrl_name, exiting)	\
> +({												\
> +	struct kvm_vcpu *__vcpu = &(vmx)->vcpu;							\
> +	bool __enabled;										\
> +												\
> +	if (cpu_has_vmx_##name()) {								\
> +		if (kvm_is_governed_feature(X86_FEATURE_##feat_name))				\
> +			__enabled = guest_can_use(__vcpu, X86_FEATURE_##feat_name);		\
> +		else										\
> +			__enabled = guest_cpuid_has(__vcpu, X86_FEATURE_##feat_name);		\
> +		vmx_adjust_secondary_exec_control(vmx, exec_control, SECONDARY_EXEC_##ctrl_name,\
> +						  __enabled, exiting);				\
> +	}											\
>  })
>
>  /* More macro magic for ENABLE_/opt-in versus _EXITING/opt-out controls. */
> @@ -4612,10 +4615,7 @@ static u32 vmx_secondary_exec_control(struct vcpu_vmx *vmx)
>  	if (!enable_pml || !atomic_read(&vcpu->kvm->nr_memslots_dirty_logging))
>  		exec_control &= ~SECONDARY_EXEC_ENABLE_PML;
>
> -	if (cpu_has_vmx_xsaves())
> -		vmx_adjust_secondary_exec_control(vmx, &exec_control,
> -						  SECONDARY_EXEC_ENABLE_XSAVES,
> -						  vcpu->arch.xsaves_enabled, false);
> +	vmx_adjust_sec_exec_feature(vmx, &exec_control, xsaves, XSAVES);
>
>  	/*
>  	 * RDPID is also gated by ENABLE_RDTSCP, turn on the control if either
> @@ -4634,6 +4634,7 @@ static u32 vmx_secondary_exec_control(struct vcpu_vmx *vmx)
>  						  SECONDARY_EXEC_ENABLE_RDTSCP,
>  						  rdpid_or_rdtscp_enabled, false);
>  	}
> +
>  	vmx_adjust_sec_exec_feature(vmx, &exec_control, invpcid, INVPCID);
>
>  	vmx_adjust_sec_exec_exiting(vmx, &exec_control, rdrand, RDRAND);
> @@ -7745,10 +7746,9 @@ static void vmx_vcpu_after_set_cpuid(struct kvm_vcpu *vcpu)
>  	 * to the guest.  XSAVES depends on CR4.OSXSAVE, and CR4.OSXSAVE can be
>  	 * set if and only if XSAVE is supported.
>  	 */
> -	vcpu->arch.xsaves_enabled = kvm_cpu_cap_has(X86_FEATURE_XSAVES) &&
> -				    boot_cpu_has(X86_FEATURE_XSAVE) &&
> -				    guest_cpuid_has(vcpu, X86_FEATURE_XSAVE) &&
> -				    guest_cpuid_has(vcpu, X86_FEATURE_XSAVES);
> +	if (boot_cpu_has(X86_FEATURE_XSAVE) &&
> +	    guest_cpuid_has(vcpu, X86_FEATURE_XSAVE))

Should above 2 be X86_FEATURE_XSAVES ? XSAVE and XSAVES have different
cpuid definition.
Otherwise X86_FEATURE_XSAVES is allowed in governor even XSAVES
is not exposed to guest cpuid, with unnecessary context switches.

> +		kvm_governed_feature_check_and_set(vcpu, X86_FEATURE_XSAVES);
>
>  	vmx_setup_uret_msrs(vmx);
>
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index eba35d43e3fe..34945c7dba38 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -1016,7 +1016,7 @@ void kvm_load_guest_xsave_state(struct kvm_vcpu *vcpu)
>  		if (vcpu->arch.xcr0 != host_xcr0)
>  			xsetbv(XCR_XFEATURE_ENABLED_MASK, vcpu->arch.xcr0);
>
> -		if (vcpu->arch.xsaves_enabled &&
> +		if (guest_can_use(vcpu, X86_FEATURE_XSAVES) &&
>  		    vcpu->arch.ia32_xss != host_xss)
>  			wrmsrl(MSR_IA32_XSS, vcpu->arch.ia32_xss);
>  	}
> @@ -1047,7 +1047,7 @@ void kvm_load_host_xsave_state(struct kvm_vcpu *vcpu)
>  		if (vcpu->arch.xcr0 != host_xcr0)
>  			xsetbv(XCR_XFEATURE_ENABLED_MASK, host_xcr0);
>
> -		if (vcpu->arch.xsaves_enabled &&
> +		if (guest_can_use(vcpu, X86_FEATURE_XSAVES) &&
>  		    vcpu->arch.ia32_xss != host_xss)
>  			wrmsrl(MSR_IA32_XSS, host_xss);
>  	}
> --
> 2.41.0.694.ge786442a9b-goog
>
