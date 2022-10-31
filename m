Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 91BDA613B74
	for <lists+kvm@lfdr.de>; Mon, 31 Oct 2022 17:39:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231876AbiJaQji (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 31 Oct 2022 12:39:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56120 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231392AbiJaQjg (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 31 Oct 2022 12:39:36 -0400
Received: from mga12.intel.com (mga12.intel.com [192.55.52.136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0A5B3266E;
        Mon, 31 Oct 2022 09:39:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1667234375; x=1698770375;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=vuV7Dpe/0/ak3bH14e0WJVfOQ2/nf4METLK/tRQIVFY=;
  b=A7qp8P5vZ17hCJ8oNqrIbC3Mz1x1UO3ecoTr98t72D864VfJ3++thnHj
   U23DIJlF8BLftPSVnQ4ggPIYWUUQYYQA3L1jd/erT2Ju8wDUBIEXvIrxj
   1nz8d6OR+G4s2jQGcFDKMnvxCvHvb9RZ75UXU65I0FzrgzTxyANhPEYmS
   Ik+s/D6mXiRNMurWJXaJSCGqR6LraN4DYVl/B3tdX8z+JPwcbXgFJsUBr
   klom2aZcbvV3AjUvI35b5gpmiv44I1zZVR+XMqYG+oefkEig2NUL8GI2X
   IyImOvsPIbnDyDdeAkdJFzXCgUtiQXzbe+exy9X/DSpkKTLlyak0rP90h
   Q==;
X-IronPort-AV: E=McAfee;i="6500,9779,10517"; a="288658691"
X-IronPort-AV: E=Sophos;i="5.95,228,1661842800"; 
   d="scan'208";a="288658691"
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 31 Oct 2022 09:39:17 -0700
X-IronPort-AV: E=McAfee;i="6500,9779,10517"; a="962837064"
X-IronPort-AV: E=Sophos;i="5.95,228,1661842800"; 
   d="scan'208";a="962837064"
Received: from yingwan3-mobl.ccr.corp.intel.com (HELO localhost) ([10.249.175.243])
  by fmsmga005-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 31 Oct 2022 09:39:13 -0700
Date:   Tue, 1 Nov 2022 00:39:07 +0800
From:   Yu Zhang <yu.c.zhang@linux.intel.com>
To:     Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Eric Li <ercli@ucdavis.edu>,
        David Matlack <dmatlack@google.com>,
        Oliver Upton <oupton@google.com>
Subject: Re: [PATCH v5 05/15] KVM: nVMX: Let userspace set nVMX MSR to any
 _host_ supported value
Message-ID: <20221031163907.w64vyg5twzvv2nho@linux.intel.com>
References: <20220607213604.3346000-1-seanjc@google.com>
 <20220607213604.3346000-6-seanjc@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220607213604.3346000-6-seanjc@google.com>
User-Agent: NeoMutt/20171215
X-Spam-Status: No, score=-5.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_PASS,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Sean & Paolo,

On Tue, Jun 07, 2022 at 09:35:54PM +0000, Sean Christopherson wrote:
> Restrict the nVMX MSRs based on KVM's config, not based on the guest's
> current config.  Using the guest's config to audit the new config
> prevents userspace from restoring the original config (KVM's config) if
> at any point in the past the guest's config was restricted in any way.

May I ask for an example here, to explain why we use the KVM config
here, instead of the guest's? I mean, the guest's config can be
adjusted after cpuid updates by vmx_vcpu_after_set_cpuid(). Yet the
msr settings in vmcs_config.nested might be outdated by then.

Another question is about the setting of secondary_ctls_high in
nested_vmx_setup_ctls_msrs().  I saw there's a comment saying:
	"Do not include those that depend on CPUID bits, they are
	added later by vmx_vcpu_after_set_cpuid.".

But since cpuid updates can adjust the vmx->nested.msrs.secondary_ctls_high,
do we really need to clear those flags for secondary_ctls_high in this
global config? Could we just set 
	msrs->secondary_ctls_high = vmcs_conf->cpu_based_2nd_exec_ctrl?

If yes, code(in nested_vmx_setup_ctls_msrs()) such as
	if (enable_ept) {
		/* nested EPT: emulate EPT also to L1 */
		msrs->secondary_ctls_high |=
			SECONDARY_EXEC_ENABLE_EPT;
or 
	if (cpu_has_vmx_vmfunc()) {
		msrs->secondary_ctls_high |=
			SECONDARY_EXEC_ENABLE_VMFUNC;
and other similar ones may also be uncessary.

B.R.
Yu

> 
> Fixes: 62cc6b9dc61e ("KVM: nVMX: support restore of VMX capability MSRs")
> Cc: stable@vger.kernel.org
> Cc: David Matlack <dmatlack@google.com>
> Signed-off-by: Sean Christopherson <seanjc@google.com>
> ---
>  arch/x86/kvm/vmx/nested.c | 100 ++++++++++++++++++++------------------
>  1 file changed, 52 insertions(+), 48 deletions(-)
> 
> diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
> index 00c7b00c017a..fca30e79b3a0 100644
> --- a/arch/x86/kvm/vmx/nested.c
> +++ b/arch/x86/kvm/vmx/nested.c
> @@ -1223,7 +1223,7 @@ static int vmx_restore_vmx_basic(struct vcpu_vmx *vmx, u64 data)
>  		BIT_ULL(49) | BIT_ULL(54) | BIT_ULL(55) |
>  		/* reserved */
>  		BIT_ULL(31) | GENMASK_ULL(47, 45) | GENMASK_ULL(63, 56);
> -	u64 vmx_basic = vmx->nested.msrs.basic;
> +	u64 vmx_basic = vmcs_config.nested.basic;
>  
>  	if (!is_bitwise_subset(vmx_basic, data, feature_and_reserved))
>  		return -EINVAL;
> @@ -1246,36 +1246,42 @@ static int vmx_restore_vmx_basic(struct vcpu_vmx *vmx, u64 data)
>  	return 0;
>  }
>  
> +static void vmx_get_control_msr(struct nested_vmx_msrs *msrs, u32 msr_index,
> +				u32 **low, u32 **high)
> +{
> +	switch (msr_index) {
> +	case MSR_IA32_VMX_TRUE_PINBASED_CTLS:
> +		*low = &msrs->pinbased_ctls_low;
> +		*high = &msrs->pinbased_ctls_high;
> +		break;
> +	case MSR_IA32_VMX_TRUE_PROCBASED_CTLS:
> +		*low = &msrs->procbased_ctls_low;
> +		*high = &msrs->procbased_ctls_high;
> +		break;
> +	case MSR_IA32_VMX_TRUE_EXIT_CTLS:
> +		*low = &msrs->exit_ctls_low;
> +		*high = &msrs->exit_ctls_high;
> +		break;
> +	case MSR_IA32_VMX_TRUE_ENTRY_CTLS:
> +		*low = &msrs->entry_ctls_low;
> +		*high = &msrs->entry_ctls_high;
> +		break;
> +	case MSR_IA32_VMX_PROCBASED_CTLS2:
> +		*low = &msrs->secondary_ctls_low;
> +		*high = &msrs->secondary_ctls_high;
> +		break;
> +	default:
> +		BUG();
> +	}
> +}
> +
>  static int
>  vmx_restore_control_msr(struct vcpu_vmx *vmx, u32 msr_index, u64 data)
>  {
> -	u64 supported;
>  	u32 *lowp, *highp;
> +	u64 supported;
>  
> -	switch (msr_index) {
> -	case MSR_IA32_VMX_TRUE_PINBASED_CTLS:
> -		lowp = &vmx->nested.msrs.pinbased_ctls_low;
> -		highp = &vmx->nested.msrs.pinbased_ctls_high;
> -		break;
> -	case MSR_IA32_VMX_TRUE_PROCBASED_CTLS:
> -		lowp = &vmx->nested.msrs.procbased_ctls_low;
> -		highp = &vmx->nested.msrs.procbased_ctls_high;
> -		break;
> -	case MSR_IA32_VMX_TRUE_EXIT_CTLS:
> -		lowp = &vmx->nested.msrs.exit_ctls_low;
> -		highp = &vmx->nested.msrs.exit_ctls_high;
> -		break;
> -	case MSR_IA32_VMX_TRUE_ENTRY_CTLS:
> -		lowp = &vmx->nested.msrs.entry_ctls_low;
> -		highp = &vmx->nested.msrs.entry_ctls_high;
> -		break;
> -	case MSR_IA32_VMX_PROCBASED_CTLS2:
> -		lowp = &vmx->nested.msrs.secondary_ctls_low;
> -		highp = &vmx->nested.msrs.secondary_ctls_high;
> -		break;
> -	default:
> -		BUG();
> -	}
> +	vmx_get_control_msr(&vmcs_config.nested, msr_index, &lowp, &highp);
>  
>  	supported = vmx_control_msr(*lowp, *highp);
>  
> @@ -1287,6 +1293,7 @@ vmx_restore_control_msr(struct vcpu_vmx *vmx, u32 msr_index, u64 data)
>  	if (!is_bitwise_subset(supported, data, GENMASK_ULL(63, 32)))
>  		return -EINVAL;
>  
> +	vmx_get_control_msr(&vmx->nested.msrs, msr_index, &lowp, &highp);
>  	*lowp = data;
>  	*highp = data >> 32;
>  	return 0;
> @@ -1300,10 +1307,8 @@ static int vmx_restore_vmx_misc(struct vcpu_vmx *vmx, u64 data)
>  		BIT_ULL(28) | BIT_ULL(29) | BIT_ULL(30) |
>  		/* reserved */
>  		GENMASK_ULL(13, 9) | BIT_ULL(31);
> -	u64 vmx_misc;
> -
> -	vmx_misc = vmx_control_msr(vmx->nested.msrs.misc_low,
> -				   vmx->nested.msrs.misc_high);
> +	u64 vmx_misc = vmx_control_msr(vmcs_config.nested.misc_low,
> +				       vmcs_config.nested.misc_high);
>  
>  	if (!is_bitwise_subset(vmx_misc, data, feature_and_reserved_bits))
>  		return -EINVAL;
> @@ -1331,10 +1336,8 @@ static int vmx_restore_vmx_misc(struct vcpu_vmx *vmx, u64 data)
>  
>  static int vmx_restore_vmx_ept_vpid_cap(struct vcpu_vmx *vmx, u64 data)
>  {
> -	u64 vmx_ept_vpid_cap;
> -
> -	vmx_ept_vpid_cap = vmx_control_msr(vmx->nested.msrs.ept_caps,
> -					   vmx->nested.msrs.vpid_caps);
> +	u64 vmx_ept_vpid_cap = vmx_control_msr(vmcs_config.nested.ept_caps,
> +					       vmcs_config.nested.vpid_caps);
>  
>  	/* Every bit is either reserved or a feature bit. */
>  	if (!is_bitwise_subset(vmx_ept_vpid_cap, data, -1ULL))
> @@ -1345,20 +1348,21 @@ static int vmx_restore_vmx_ept_vpid_cap(struct vcpu_vmx *vmx, u64 data)
>  	return 0;
>  }
>  
> +static u64 *vmx_get_fixed0_msr(struct nested_vmx_msrs *msrs, u32 msr_index)
> +{
> +	switch (msr_index) {
> +	case MSR_IA32_VMX_CR0_FIXED0:
> +		return &msrs->cr0_fixed0;
> +	case MSR_IA32_VMX_CR4_FIXED0:
> +		return &msrs->cr4_fixed0;
> +	default:
> +		BUG();
> +	}
> +}
> +
>  static int vmx_restore_fixed0_msr(struct vcpu_vmx *vmx, u32 msr_index, u64 data)
>  {
> -	u64 *msr;
> -
> -	switch (msr_index) {
> -	case MSR_IA32_VMX_CR0_FIXED0:
> -		msr = &vmx->nested.msrs.cr0_fixed0;
> -		break;
> -	case MSR_IA32_VMX_CR4_FIXED0:
> -		msr = &vmx->nested.msrs.cr4_fixed0;
> -		break;
> -	default:
> -		BUG();
> -	}
> +	const u64 *msr = vmx_get_fixed0_msr(&vmcs_config.nested, msr_index);
>  
>  	/*
>  	 * 1 bits (which indicates bits which "must-be-1" during VMX operation)
> @@ -1367,7 +1371,7 @@ static int vmx_restore_fixed0_msr(struct vcpu_vmx *vmx, u32 msr_index, u64 data)
>  	if (!is_bitwise_subset(data, *msr, -1ULL))
>  		return -EINVAL;
>  
> -	*msr = data;
> +	*vmx_get_fixed0_msr(&vmx->nested.msrs, msr_index) = data;
>  	return 0;
>  }
>  
> @@ -1428,7 +1432,7 @@ int vmx_set_vmx_msr(struct kvm_vcpu *vcpu, u32 msr_index, u64 data)
>  		vmx->nested.msrs.vmcs_enum = data;
>  		return 0;
>  	case MSR_IA32_VMX_VMFUNC:
> -		if (data & ~vmx->nested.msrs.vmfunc_controls)
> +		if (data & ~vmcs_config.nested.vmfunc_controls)
>  			return -EINVAL;
>  		vmx->nested.msrs.vmfunc_controls = data;
>  		return 0;
> -- 
> 2.36.1.255.ge46751e96f-goog
> 
