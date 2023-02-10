Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1A4D2691F6A
	for <lists+kvm@lfdr.de>; Fri, 10 Feb 2023 14:01:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232040AbjBJNBZ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 10 Feb 2023 08:01:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36742 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231422AbjBJNBX (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 10 Feb 2023 08:01:23 -0500
Received: from mga02.intel.com (mga02.intel.com [134.134.136.20])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E83F614229;
        Fri, 10 Feb 2023 05:01:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1676034081; x=1707570081;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=07eEJnnJoAi7WSzA2yjP/AMoUqh6QQY+oN3ITBoNJSU=;
  b=L+8/HB2p2xzzIlBSXQeoem7bx00NYXiqT3eF0WZvUM9ceKohN8k7wwP4
   pJSB54BQw35ZUzKu9oAVb/0er8NXYO6T95cZCoJRLyk0v4iJ65gWFBQtz
   Bvfm5jdksQXo/hMBfwEiIeyYixkZHvq9sVGdchtdhv90yAUcHJOW3t7Fx
   9BaI8szIgKogD1DvKGRtk/6Gr+8gRm0dq88w9jnQyEshdXRoerdYKIaBJ
   VKpGfniArfo7yGL/qZRGpBYpDFSorVolBhAAvzmWDAKwp/ngVwx7lqbSW
   X3VR3Td+bITKy3CYAB/52polrCKQhzDYJiDpJBaylTmOKa34cAgyFJwpH
   w==;
X-IronPort-AV: E=McAfee;i="6500,9779,10616"; a="318429909"
X-IronPort-AV: E=Sophos;i="5.97,287,1669104000"; 
   d="scan'208";a="318429909"
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Feb 2023 05:01:21 -0800
X-IronPort-AV: E=McAfee;i="6500,9779,10616"; a="842013978"
X-IronPort-AV: E=Sophos;i="5.97,287,1669104000"; 
   d="scan'208";a="842013978"
Received: from linheidx-mobl1.ccr.corp.intel.com (HELO localhost) ([10.249.175.125])
  by orsmga005-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Feb 2023 05:01:18 -0800
Date:   Fri, 10 Feb 2023 21:01:15 +0800
From:   Yu Zhang <yu.c.zhang@linux.intel.com>
To:     Sean Christopherson <seanjc@google.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Xiaoyao Li <xiaoyao.li@intel.com>,
        Like Xu <like.xu.linux@gmail.com>
Subject: Re: [PATCH v2 05/21] KVM: x86: Disallow writes to immutable feature
 MSRs after KVM_RUN
Message-ID: <20230210130115.che6rqfckwt7fzqp@linux.intel.com>
References: <20230210003148.2646712-1-seanjc@google.com>
 <20230210003148.2646712-6-seanjc@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230210003148.2646712-6-seanjc@google.com>
User-Agent: NeoMutt/20171215
X-Spam-Status: No, score=-4.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Feb 10, 2023 at 12:31:32AM +0000, Sean Christopherson wrote:
> Disallow writes to feature MSRs after KVM_RUN to prevent userspace from
> changing the vCPU model after running the vCPU.  Similar to guest CPUID,
> KVM uses feature MSRs to configure intercepts, determine what operations
> are/aren't allowed, etc.  Changing the capabilities while the vCPU is
> active will at best yield unpredictable guest behavior, and at worst
> could be dangerous to KVM.
> 
> Allow writing the current value, e.g. so that userspace can blindly set
> all MSRs when emulating RESET, and unconditionally allow writes to
> MSR_IA32_UCODE_REV so that userspace can emulate patch loads.
> 
> Special case the VMX MSRs to keep the generic list small, i.e. so that
> KVM can do a linear walk of the generic list without incurring meaningful
> overhead.
> 
> Cc: Like Xu <like.xu.linux@gmail.com>
> Signed-off-by: Sean Christopherson <seanjc@google.com>
> ---
>  arch/x86/kvm/x86.c | 36 ++++++++++++++++++++++++++++++++++++
>  1 file changed, 36 insertions(+)
> 
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index 7b73a0b45041..186cb6a81643 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -1554,6 +1554,25 @@ static u32 msr_based_features[ARRAY_SIZE(msr_based_features_all_except_vmx) +
>  			      (KVM_LAST_EMULATED_VMX_MSR - KVM_FIRST_EMULATED_VMX_MSR + 1)];
>  static unsigned int num_msr_based_features;
>  
> +/*
> + * All feature MSRs except uCode revID, which tracks the currently loaded uCode
> + * patch, are immutable once the vCPU model is defined.
> + */
> +static bool kvm_is_immutable_feature_msr(u32 msr)
> +{
> +	int i;
> +
> +	if (msr >= KVM_FIRST_EMULATED_VMX_MSR && msr <= KVM_LAST_EMULATED_VMX_MSR)
> +		return true;
> +
> +	for (i = 0; i < ARRAY_SIZE(msr_based_features_all_except_vmx); i++) {
> +		if (msr == msr_based_features_all_except_vmx[i])
> +			return msr != MSR_IA32_UCODE_REV;
> +	}
> +
> +	return false;
> +}
> +
>  /*
>   * Some IA32_ARCH_CAPABILITIES bits have dependencies on MSRs that KVM
>   * does not yet virtualize. These include:
> @@ -2168,6 +2187,23 @@ static int do_get_msr(struct kvm_vcpu *vcpu, unsigned index, u64 *data)
>  
>  static int do_set_msr(struct kvm_vcpu *vcpu, unsigned index, u64 *data)
>  {
> +	u64 val;
> +
> +	/*
> +	 * Disallow writes to immutable feature MSRs after KVM_RUN.  KVM does
> +	 * not support modifying the guest vCPU model on the fly, e.g. changing
> +	 * the nVMX capabilities while L2 is running is nonsensical.  Ignore
> +	 * writes of the same value, e.g. to allow userspace to blindly stuff
> +	 * all MSRs when emulating RESET.
> +	 */
> +	if (vcpu->arch.last_vmentry_cpu != -1 &&

Use kvm_vcpu_has_run(vcpu) here? 

B.R.
Yu
