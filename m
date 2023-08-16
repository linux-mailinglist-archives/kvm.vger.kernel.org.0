Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0F18977D86D
	for <lists+kvm@lfdr.de>; Wed, 16 Aug 2023 04:27:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241288AbjHPC0j (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 15 Aug 2023 22:26:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51156 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241284AbjHPC0J (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 15 Aug 2023 22:26:09 -0400
Received: from mgamail.intel.com (mgamail.intel.com [134.134.136.24])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8FB0E1FDC;
        Tue, 15 Aug 2023 19:26:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1692152766; x=1723688766;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=9eo18+APnQSaEDNZudNvHXWktQLMt2Aka4yEqGMeDcE=;
  b=nWfwUFPsDAtAvtwMK4xgVDXnEIXowqjJlZFFgBzwa7ytcU+e8QIYU47S
   X8u2cxv6BDzkqxzH7VGvC9b2JmnVZuWOws75np408m1lfvRrRG7e12X7e
   L9+SiqmYt0ofk8SbgcXUpRpTl4ntjIUVKAPfFYshYFP8r9QfalScVf4Rk
   bLH64qwQUs3DSwP6pWcHT6TQLSmB/OSK/ZmsgpmD+gesifPmmX4BXARU1
   On6D7Qt33xiCYWXIWtGkHlqq9X4VciF8jMCjAHRpHm32Vt/u2Xd7uPi/K
   7Xv+yMQjLF+jUAN2bUH5iHHS6Af+YxwpH463QcCw0YpmJmTRIZMvUiu8l
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10803"; a="375193521"
X-IronPort-AV: E=Sophos;i="6.01,175,1684825200"; 
   d="scan'208";a="375193521"
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Aug 2023 19:26:06 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10803"; a="737111117"
X-IronPort-AV: E=Sophos;i="6.01,175,1684825200"; 
   d="scan'208";a="737111117"
Received: from yy-desk-7060.sh.intel.com (HELO localhost) ([10.239.159.76])
  by fmsmga007.fm.intel.com with ESMTP; 15 Aug 2023 19:26:04 -0700
Date:   Wed, 16 Aug 2023 10:26:03 +0800
From:   Yuan Yao <yuan.yao@linux.intel.com>
To:     Sean Christopherson <seanjc@google.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Zeng Guang <guang.zeng@intel.com>,
        Yuan Yao <yuan.yao@intel.com>
Subject: Re: [PATCH v3 03/15] KVM: VMX: Recompute "XSAVES enabled" only after
 CPUID update
Message-ID: <20230816022603.lxbpf22auv7wc3f6@yy-desk-7060>
References: <20230815203653.519297-1-seanjc@google.com>
 <20230815203653.519297-4-seanjc@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230815203653.519297-4-seanjc@google.com>
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

On Tue, Aug 15, 2023 at 01:36:41PM -0700, Sean Christopherson wrote:
> Recompute whether or not XSAVES is enabled for the guest only if the
> guest's CPUID model changes instead of redoing the computation every time
> KVM generates vmcs01's secondary execution controls.  The boot_cpu_has()
> and cpu_has_vmx_xsaves() checks should never change after KVM is loaded,
> and if they do the kernel/KVM is hosed.
>
> Opportunistically add a comment explaining _why_ XSAVES is effectively
> exposed to the guest if and only if XSAVE is also exposed to the guest.
>
> Practically speaking, no functional change intended (KVM will do fewer
> computations, but should still see the same xsaves_enabled value whenever
> KVM looks at it).
>
> Signed-off-by: Sean Christopherson <seanjc@google.com>
> ---
>  arch/x86/kvm/vmx/vmx.c | 24 +++++++++++-------------
>  1 file changed, 11 insertions(+), 13 deletions(-)
>
> diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
> index 434bf524e712..1bf85bd53416 100644
> --- a/arch/x86/kvm/vmx/vmx.c
> +++ b/arch/x86/kvm/vmx/vmx.c
> @@ -4612,19 +4612,10 @@ static u32 vmx_secondary_exec_control(struct vcpu_vmx *vmx)
>  	if (!enable_pml || !atomic_read(&vcpu->kvm->nr_memslots_dirty_logging))
>  		exec_control &= ~SECONDARY_EXEC_ENABLE_PML;
>
> -	if (cpu_has_vmx_xsaves()) {
> -		/* Exposing XSAVES only when XSAVE is exposed */
> -		bool xsaves_enabled =
> -			boot_cpu_has(X86_FEATURE_XSAVE) &&
> -			guest_cpuid_has(vcpu, X86_FEATURE_XSAVE) &&
> -			guest_cpuid_has(vcpu, X86_FEATURE_XSAVES);
> -
> -		vcpu->arch.xsaves_enabled = xsaves_enabled;
> -
> +	if (cpu_has_vmx_xsaves())
>  		vmx_adjust_secondary_exec_control(vmx, &exec_control,
>  						  SECONDARY_EXEC_XSAVES,
> -						  xsaves_enabled, false);
> -	}
> +						  vcpu->arch.xsaves_enabled, false);

xsaves_enabled is same as before in case of init_vmcs().

Reviewed-by: Yuan Yao <yuan.yao@intel.com>

>
>  	/*
>  	 * RDPID is also gated by ENABLE_RDTSCP, turn on the control if either
> @@ -7749,8 +7740,15 @@ static void vmx_vcpu_after_set_cpuid(struct kvm_vcpu *vcpu)
>  {
>  	struct vcpu_vmx *vmx = to_vmx(vcpu);
>
> -	/* xsaves_enabled is recomputed in vmx_compute_secondary_exec_control(). */
> -	vcpu->arch.xsaves_enabled = false;
> +	/*
> +	 * XSAVES is effectively enabled if and only if XSAVE is also exposed
> +	 * to the guest.  XSAVES depends on CR4.OSXSAVE, and CR4.OSXSAVE can be
> +	 * set if and only if XSAVE is supported.
> +	 */
> +	vcpu->arch.xsaves_enabled = cpu_has_vmx_xsaves() &&
> +				    boot_cpu_has(X86_FEATURE_XSAVE) &&
> +				    guest_cpuid_has(vcpu, X86_FEATURE_XSAVE) &&
> +				    guest_cpuid_has(vcpu, X86_FEATURE_XSAVES);
>
>  	vmx_setup_uret_msrs(vmx);
>
> --
> 2.41.0.694.ge786442a9b-goog
>
