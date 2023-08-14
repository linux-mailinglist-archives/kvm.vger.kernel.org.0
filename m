Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4FE9377B38C
	for <lists+kvm@lfdr.de>; Mon, 14 Aug 2023 10:12:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232704AbjHNIMU (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 14 Aug 2023 04:12:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40296 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234784AbjHNILf (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 14 Aug 2023 04:11:35 -0400
Received: from mgamail.intel.com (mgamail.intel.com [134.134.136.100])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EDF571719;
        Mon, 14 Aug 2023 01:11:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1692000675; x=1723536675;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=oSgIdi+RSlbeWUJDGskccGgHISPirJiQabwtsdaIRR8=;
  b=f45T9bnQsmDdvkS2rB/aECdT7n9U9IVqwlbYx2m0f/7UC1RF8TPwkBa7
   kaRPhvzKhLJRIjjPNMODm+BJ+ZyKSWmFpPF2Y7MtIotL5NGh5EvRJ5+Gg
   JdhhCy+OxQKceUn8HSfeBoJq1TEu6alUULLtQsc8zBb0LaiWy9AQvMf5S
   Uqnk0cSxQGBuz5ltBKog0Ul7whi8Q3lPKDPTjVnWhzLthiokNloeQpbce
   cmJFjtEgKk/oz3lwZ5iwYO4KWktPZ0CgatKssW19FlcdN5sqhIBhdsSa/
   HNzCb+NzuRdubHt8HCwWpy1g+FuS3BE1q0wjL2f3BxU1udmGAzrO4+1ly
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10801"; a="438321522"
X-IronPort-AV: E=Sophos;i="6.01,172,1684825200"; 
   d="scan'208";a="438321522"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Aug 2023 01:11:08 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.01,202,1684825200"; 
   d="scan'208";a="876869083"
Received: from yy-desk-7060.sh.intel.com (HELO localhost) ([10.239.159.76])
  by fmsmga001.fm.intel.com with ESMTP; 14 Aug 2023 01:11:10 -0700
Date:   Mon, 14 Aug 2023 16:11:05 +0800
From:   Yuan Yao <yuan.yao@linux.intel.com>
To:     Sean Christopherson <seanjc@google.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Maxim Levitsky <mlevitsk@redhat.com>
Subject: Re: [PATCH v2 13/21] KVM: nVMX: Use KVM-governed feature framework
 to track "nested VMX enabled"
Message-ID: <20230814081105.yr6bamyoutijc36i@yy-desk-7060>
References: <20230729011608.1065019-1-seanjc@google.com>
 <20230729011608.1065019-14-seanjc@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230729011608.1065019-14-seanjc@google.com>
User-Agent: NeoMutt/20171215
X-Spam-Status: No, score=-4.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Jul 28, 2023 at 06:16:00PM -0700, Sean Christopherson wrote:
> Track "VMX exposed to L1" via a governed feature flag instead of using a
> dedicated helper to provide the same functionality.  The main goal is to
> drive convergence between VMX and SVM with respect to querying features
> that are controllable via module param (SVM likes to cache nested
> features), avoiding the guest CPUID lookups at runtime is just a bonus
> and unlikely to provide any meaningful performance benefits.
>
> No functional change intended.
>
> Signed-off-by: Sean Christopherson <seanjc@google.com>
> ---
>  arch/x86/kvm/governed_features.h |  1 +
>  arch/x86/kvm/vmx/nested.c        |  7 ++++---
>  arch/x86/kvm/vmx/vmx.c           | 21 ++++++---------------
>  arch/x86/kvm/vmx/vmx.h           |  1 -
>  4 files changed, 11 insertions(+), 19 deletions(-)
>
> diff --git a/arch/x86/kvm/governed_features.h b/arch/x86/kvm/governed_features.h
> index b896a64e4ac3..22446614bf49 100644
> --- a/arch/x86/kvm/governed_features.h
> +++ b/arch/x86/kvm/governed_features.h
> @@ -7,6 +7,7 @@ BUILD_BUG()
>
>  KVM_GOVERNED_X86_FEATURE(GBPAGES)
>  KVM_GOVERNED_X86_FEATURE(XSAVES)
> +KVM_GOVERNED_X86_FEATURE(VMX)
>
>  #undef KVM_GOVERNED_X86_FEATURE
>  #undef KVM_GOVERNED_FEATURE
> diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
> index 22e08d30baef..c5ec0ef51ff7 100644
> --- a/arch/x86/kvm/vmx/nested.c
> +++ b/arch/x86/kvm/vmx/nested.c
> @@ -6426,7 +6426,7 @@ static int vmx_get_nested_state(struct kvm_vcpu *vcpu,
>  	vmx = to_vmx(vcpu);
>  	vmcs12 = get_vmcs12(vcpu);
>
> -	if (nested_vmx_allowed(vcpu) &&
> +	if (guest_can_use(vcpu, X86_FEATURE_VMX) &&
>  	    (vmx->nested.vmxon || vmx->nested.smm.vmxon)) {
>  		kvm_state.hdr.vmx.vmxon_pa = vmx->nested.vmxon_ptr;
>  		kvm_state.hdr.vmx.vmcs12_pa = vmx->nested.current_vmptr;
> @@ -6567,7 +6567,7 @@ static int vmx_set_nested_state(struct kvm_vcpu *vcpu,
>  		if (kvm_state->flags & ~KVM_STATE_NESTED_EVMCS)
>  			return -EINVAL;
>  	} else {
> -		if (!nested_vmx_allowed(vcpu))
> +		if (!guest_can_use(vcpu, X86_FEATURE_VMX))
>  			return -EINVAL;
>
>  		if (!page_address_valid(vcpu, kvm_state->hdr.vmx.vmxon_pa))
> @@ -6601,7 +6601,8 @@ static int vmx_set_nested_state(struct kvm_vcpu *vcpu,
>  		return -EINVAL;
>
>  	if ((kvm_state->flags & KVM_STATE_NESTED_EVMCS) &&
> -		(!nested_vmx_allowed(vcpu) || !vmx->nested.enlightened_vmcs_enabled))
> +	    (!guest_can_use(vcpu, X86_FEATURE_VMX) ||
> +	     !vmx->nested.enlightened_vmcs_enabled))
>  			return -EINVAL;
>
>  	vmx_leave_nested(vcpu);
> diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
> index 3100ed62615c..fdf932cfc64d 100644
> --- a/arch/x86/kvm/vmx/vmx.c
> +++ b/arch/x86/kvm/vmx/vmx.c
> @@ -1894,17 +1894,6 @@ static void vmx_write_tsc_multiplier(struct kvm_vcpu *vcpu)
>  	vmcs_write64(TSC_MULTIPLIER, vcpu->arch.tsc_scaling_ratio);
>  }
>
> -/*
> - * nested_vmx_allowed() checks whether a guest should be allowed to use VMX
> - * instructions and MSRs (i.e., nested VMX). Nested VMX is disabled for
> - * all guests if the "nested" module option is off, and can also be disabled
> - * for a single guest by disabling its VMX cpuid bit.
> - */
> -bool nested_vmx_allowed(struct kvm_vcpu *vcpu)
> -{
> -	return nested && guest_cpuid_has(vcpu, X86_FEATURE_VMX);

the removed nested here already covered by
kvm_cpu_cap_set(X86_FEATURE_VMX) from vmx_set_cpu_caps().

Reviewed-by: Yuan Yao <yuan.yao@intel.com>

> -}
> -
>  /*
>   * Userspace is allowed to set any supported IA32_FEATURE_CONTROL regardless of
>   * guest CPUID.  Note, KVM allows userspace to set "VMX in SMX" to maintain
> @@ -2032,7 +2021,7 @@ static int vmx_get_msr(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
>  			[msr_info->index - MSR_IA32_SGXLEPUBKEYHASH0];
>  		break;
>  	case KVM_FIRST_EMULATED_VMX_MSR ... KVM_LAST_EMULATED_VMX_MSR:
> -		if (!nested_vmx_allowed(vcpu))
> +		if (!guest_can_use(vcpu, X86_FEATURE_VMX))
>  			return 1;
>  		if (vmx_get_vmx_msr(&vmx->nested.msrs, msr_info->index,
>  				    &msr_info->data))
> @@ -2340,7 +2329,7 @@ static int vmx_set_msr(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
>  	case KVM_FIRST_EMULATED_VMX_MSR ... KVM_LAST_EMULATED_VMX_MSR:
>  		if (!msr_info->host_initiated)
>  			return 1; /* they are read-only */
> -		if (!nested_vmx_allowed(vcpu))
> +		if (!guest_can_use(vcpu, X86_FEATURE_VMX))
>  			return 1;
>  		return vmx_set_vmx_msr(vcpu, msr_index, data);
>  	case MSR_IA32_RTIT_CTL:
> @@ -7727,13 +7716,15 @@ static void vmx_vcpu_after_set_cpuid(struct kvm_vcpu *vcpu)
>  	    guest_cpuid_has(vcpu, X86_FEATURE_XSAVE))
>  		kvm_governed_feature_check_and_set(vcpu, X86_FEATURE_XSAVES);
>
> +	kvm_governed_feature_check_and_set(vcpu, X86_FEATURE_VMX);
> +
>  	vmx_setup_uret_msrs(vmx);
>
>  	if (cpu_has_secondary_exec_ctrls())
>  		vmcs_set_secondary_exec_control(vmx,
>  						vmx_secondary_exec_control(vmx));
>
> -	if (nested_vmx_allowed(vcpu))
> +	if (guest_can_use(vcpu, X86_FEATURE_VMX))
>  		vmx->msr_ia32_feature_control_valid_bits |=
>  			FEAT_CTL_VMX_ENABLED_INSIDE_SMX |
>  			FEAT_CTL_VMX_ENABLED_OUTSIDE_SMX;
> @@ -7742,7 +7733,7 @@ static void vmx_vcpu_after_set_cpuid(struct kvm_vcpu *vcpu)
>  			~(FEAT_CTL_VMX_ENABLED_INSIDE_SMX |
>  			  FEAT_CTL_VMX_ENABLED_OUTSIDE_SMX);
>
> -	if (nested_vmx_allowed(vcpu))
> +	if (guest_can_use(vcpu, X86_FEATURE_VMX))
>  		nested_vmx_cr_fixed1_bits_update(vcpu);
>
>  	if (boot_cpu_has(X86_FEATURE_INTEL_PT) &&
> diff --git a/arch/x86/kvm/vmx/vmx.h b/arch/x86/kvm/vmx/vmx.h
> index cde902b44d97..c2130d2c8e24 100644
> --- a/arch/x86/kvm/vmx/vmx.h
> +++ b/arch/x86/kvm/vmx/vmx.h
> @@ -374,7 +374,6 @@ struct kvm_vmx {
>  	u64 *pid_table;
>  };
>
> -bool nested_vmx_allowed(struct kvm_vcpu *vcpu);
>  void vmx_vcpu_load_vmcs(struct kvm_vcpu *vcpu, int cpu,
>  			struct loaded_vmcs *buddy);
>  int allocate_vpid(void);
> --
> 2.41.0.487.g6d72f3e995-goog
>
