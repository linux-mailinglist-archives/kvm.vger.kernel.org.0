Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2E97322A170
	for <lists+kvm@lfdr.de>; Wed, 22 Jul 2020 23:33:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726685AbgGVVdb (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 22 Jul 2020 17:33:31 -0400
Received: from mga01.intel.com ([192.55.52.88]:37475 "EHLO mga01.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732992AbgGVVd3 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 22 Jul 2020 17:33:29 -0400
IronPort-SDR: eljUyjkynkZ1BFiyII3nOh37zLyPu5YKDR+FPEVWkAGU0qWAaRY1uDTjSLXMiDeD+qyZBeYsof
 EgMPTgYLDQpw==
X-IronPort-AV: E=McAfee;i="6000,8403,9690"; a="168565581"
X-IronPort-AV: E=Sophos;i="5.75,383,1589266800"; 
   d="scan'208";a="168565581"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Jul 2020 14:33:28 -0700
IronPort-SDR: JXs4dF7/ZGYQKYyOeMWcrtFpVi9h+gNIz7ONrilMuy7q41aQRAbNeeqQ6Xm1JAkovawy9v3HFv
 2f956f7Cr9VA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.75,383,1589266800"; 
   d="scan'208";a="488599266"
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com) ([10.54.74.152])
  by fmsmga005.fm.intel.com with ESMTP; 22 Jul 2020 14:33:28 -0700
Date:   Wed, 22 Jul 2020 14:33:28 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Yang Weijiang <weijiang.yang@intel.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        pbonzini@redhat.com, jmattson@google.com,
        yu.c.zhang@linux.intel.com
Subject: Re: [RESEND v13 11/11] KVM: x86: Enable CET virtualization and
 advertise CET to userspace
Message-ID: <20200722213328.GL9114@linux.intel.com>
References: <20200716031627.11492-1-weijiang.yang@intel.com>
 <20200716031627.11492-12-weijiang.yang@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200716031627.11492-12-weijiang.yang@intel.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Jul 16, 2020 at 11:16:27AM +0800, Yang Weijiang wrote:
> Set the feature bits so that CET capabilities can be seen in guest via
> CPUID enumeration. Add CR4.CET bit support in order to allow guest set CET
> master control bit(CR4.CET).
> 
> Disable KVM CET feature once unrestricted_guest is turned off because
> KVM cannot emulate guest CET behavior well in this case.
> 
> Don't expose CET feature if dependent CET bits are cleared in host XSS.
> 
> Signed-off-by: Yang Weijiang <weijiang.yang@intel.com>
> ---
>  arch/x86/include/asm/kvm_host.h |  3 ++-
>  arch/x86/kvm/cpuid.c            |  5 +++--
>  arch/x86/kvm/vmx/vmx.c          |  5 +++++
>  arch/x86/kvm/x86.c              | 11 +++++++++++
>  4 files changed, 21 insertions(+), 3 deletions(-)
> 
> diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
> index e8c749596ba2..c4c82db68b6a 100644
> --- a/arch/x86/include/asm/kvm_host.h
> +++ b/arch/x86/include/asm/kvm_host.h
> @@ -99,7 +99,8 @@
>  			  | X86_CR4_PGE | X86_CR4_PCE | X86_CR4_OSFXSR | X86_CR4_PCIDE \
>  			  | X86_CR4_OSXSAVE | X86_CR4_SMEP | X86_CR4_FSGSBASE \
>  			  | X86_CR4_OSXMMEXCPT | X86_CR4_LA57 | X86_CR4_VMXE \
> -			  | X86_CR4_SMAP | X86_CR4_PKE | X86_CR4_UMIP))
> +			  | X86_CR4_SMAP | X86_CR4_PKE | X86_CR4_UMIP \
> +			  | X86_CR4_CET))
>  
>  #define CR8_RESERVED_BITS (~(unsigned long)X86_CR8_TPR)
>  
> diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
> index d97b2a6e8a8c..a085b8c57f34 100644
> --- a/arch/x86/kvm/cpuid.c
> +++ b/arch/x86/kvm/cpuid.c
> @@ -340,7 +340,8 @@ void kvm_set_cpu_caps(void)
>  		F(AVX512VBMI) | F(LA57) | F(PKU) | 0 /*OSPKE*/ | F(RDPID) |
>  		F(AVX512_VPOPCNTDQ) | F(UMIP) | F(AVX512_VBMI2) | F(GFNI) |
>  		F(VAES) | F(VPCLMULQDQ) | F(AVX512_VNNI) | F(AVX512_BITALG) |
> -		F(CLDEMOTE) | F(MOVDIRI) | F(MOVDIR64B) | 0 /*WAITPKG*/
> +		F(CLDEMOTE) | F(MOVDIRI) | F(MOVDIR64B) | 0 /*WAITPKG*/ |
> +		F(SHSTK)
>  	);
>  	/* Set LA57 based on hardware capability. */
>  	if (cpuid_ecx(7) & F(LA57))
> @@ -356,7 +357,7 @@ void kvm_set_cpu_caps(void)
>  	kvm_cpu_cap_mask(CPUID_7_EDX,
>  		F(AVX512_4VNNIW) | F(AVX512_4FMAPS) | F(SPEC_CTRL) |
>  		F(SPEC_CTRL_SSBD) | F(ARCH_CAPABILITIES) | F(INTEL_STIBP) |
> -		F(MD_CLEAR) | F(AVX512_VP2INTERSECT) | F(FSRM)
> +		F(MD_CLEAR) | F(AVX512_VP2INTERSECT) | F(FSRM) | F(IBT)
>  	);
>  
>  	/* TSC_ADJUST and ARCH_CAPABILITIES are emulated in software. */
> diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
> index 5d4250b9dec8..31593339b6fe 100644
> --- a/arch/x86/kvm/vmx/vmx.c
> +++ b/arch/x86/kvm/vmx/vmx.c
> @@ -7542,6 +7542,11 @@ static __init void vmx_set_cpu_caps(void)
>  
>  	if (vmx_waitpkg_supported())
>  		kvm_cpu_cap_check_and_set(X86_FEATURE_WAITPKG);
> +
> +	if (!enable_unrestricted_guest) {

This also needs to check cpu_has_load_cet_ctrl().

> +		kvm_cpu_cap_clear(X86_FEATURE_SHSTK);
> +		kvm_cpu_cap_clear(X86_FEATURE_IBT);
> +	}
>  }
>  
>  static void vmx_request_immediate_exit(struct kvm_vcpu *vcpu)
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index 76892fb0b0a0..c7393d62ad72 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -9808,10 +9808,21 @@ int kvm_arch_hardware_setup(void *opaque)
>  	if (kvm_cpu_cap_has(X86_FEATURE_XSAVES))
>  		supported_xss = host_xss & KVM_SUPPORTED_XSS;
>  
> +	if (!(supported_xss & (XFEATURE_MASK_CET_USER |
> +	    XFEATURE_MASK_CET_KERNEL))) {
> +		kvm_cpu_cap_clear(X86_FEATURE_SHSTK);
> +		kvm_cpu_cap_clear(X86_FEATURE_IBT);

I played around with a variety of options, and ended up with:

	if (!kvm_cpu_cap_has(X86_FEATURE_XSAVES))
		supported_xss = 0;
	else
		supported_xss &= host_xss;

	/* Update CET features now that supported_xss is finalized. */
	if (!kvm_cet_supported()) {
		kvm_cpu_cap_clear(X86_FEATURE_SHSTK);
		kvm_cpu_cap_clear(X86_FEATURE_IBT);
	}

in x86.c / kvm_arch_hardware_setup(), and 

	if (!cpu_has_load_cet_ctrl() || !enable_unrestricted_guest) {
		kvm_cpu_cap_clear(X86_FEATURE_SHSTK);
		kvm_cpu_cap_clear(X86_FEATURE_IBT);
	} else if (kvm_cpu_cap_has(X86_FEATURE_SHSTK) ||
		   kvm_cpu_cap_has(X86_FEATURE_IBT)) {
		supported_xss |= XFEATURE_MASK_CET_USER |
				 XFEATURE_MASK_CET_KERNEL;
	}

in vmx.c / vmx_set_cpu_caps.

That avoids KVM_SUPPORTED_XSS, and was the least ugly option I could devise
for avoiding the cyclical dependency between XSS and SHSTK/IBT without
potentially exploding SVM in the future.

> +	}
> +
>  #define __kvm_cpu_cap_has(UNUSED_, f) kvm_cpu_cap_has(f)
>  	cr4_reserved_bits = __cr4_reserved_bits(__kvm_cpu_cap_has, UNUSED_);
>  #undef __kvm_cpu_cap_has
>  
> +	if (!kvm_cpu_cap_has(X86_FEATURE_SHSTK) &&
> +	    !kvm_cpu_cap_has(X86_FEATURE_IBT))
> +		supported_xss &= ~(XFEATURE_MASK_CET_USER |
> +				   XFEATURE_MASK_CET_KERNEL);
> +
>  	if (kvm_has_tsc_control) {
>  		/*
>  		 * Make sure the user can only configure tsc_khz values that
> -- 
> 2.17.2
> 
