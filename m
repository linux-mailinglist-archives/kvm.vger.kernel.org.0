Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F323422A0BE
	for <lists+kvm@lfdr.de>; Wed, 22 Jul 2020 22:32:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726841AbgGVUcH (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 22 Jul 2020 16:32:07 -0400
Received: from mga09.intel.com ([134.134.136.24]:18047 "EHLO mga09.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726447AbgGVUcH (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 22 Jul 2020 16:32:07 -0400
IronPort-SDR: XVKPbTjZ3H7ZDlXnwGDfeh354/hFEqiO+dnRK8pgpn/vioMSqpc5bvKIvmMLfLp4Ux9B68BfRo
 wW2OO0HdRxxw==
X-IronPort-AV: E=McAfee;i="6000,8403,9690"; a="151735900"
X-IronPort-AV: E=Sophos;i="5.75,383,1589266800"; 
   d="scan'208";a="151735900"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Jul 2020 13:32:06 -0700
IronPort-SDR: ERgv1SKH905lV7xuMiYG5qpPdjmoGL8F5IdsGhRRs39KH/fevt5ehukFRppoHiB4QCyYnMS30H
 o83GeSLC5V0A==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.75,383,1589266800"; 
   d="scan'208";a="362827612"
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com) ([10.54.74.152])
  by orsmga001.jf.intel.com with ESMTP; 22 Jul 2020 13:32:06 -0700
Date:   Wed, 22 Jul 2020 13:32:06 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Yang Weijiang <weijiang.yang@intel.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        pbonzini@redhat.com, jmattson@google.com,
        yu.c.zhang@linux.intel.com
Subject: Re: [RESEND v13 05/11] KVM: x86: Refresh CPUID once guest changes
 XSS bits
Message-ID: <20200722203206.GF9114@linux.intel.com>
References: <20200716031627.11492-1-weijiang.yang@intel.com>
 <20200716031627.11492-6-weijiang.yang@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200716031627.11492-6-weijiang.yang@intel.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Jul 16, 2020 at 11:16:21AM +0800, Yang Weijiang wrote:
> CPUID(0xd, 1) reports the current required storage size of XCR0 | XSS,
> when guest updates the XSS, it's necessary to update the CPUID leaf, otherwise
> guest will fetch old state size, and results to some WARN traces during guest
> running.
> 
> supported_xss is initialized to host_xss & KVM_SUPPORTED_XSS to indicate current
> MSR_IA32_XSS bits supported in KVM, but actual XSS bits seen in guest depends
> on the setting of CPUID(0xd,1).{ECX, EDX} for guest.
> 
> Co-developed-by: Zhang Yi Z <yi.z.zhang@linux.intel.com>
> Signed-off-by: Zhang Yi Z <yi.z.zhang@linux.intel.com>
> Signed-off-by: Yang Weijiang <weijiang.yang@intel.com>
> ---
>  arch/x86/include/asm/kvm_host.h |  1 +
>  arch/x86/kvm/cpuid.c            | 23 +++++++++++++++++++----
>  arch/x86/kvm/x86.c              | 12 ++++++++----
>  3 files changed, 28 insertions(+), 8 deletions(-)
> 
> diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
> index be5363b21540..e8c749596ba2 100644
> --- a/arch/x86/include/asm/kvm_host.h
> +++ b/arch/x86/include/asm/kvm_host.h
> @@ -654,6 +654,7 @@ struct kvm_vcpu_arch {
>  
>  	u64 xcr0;
>  	u64 guest_supported_xcr0;
> +	u64 guest_supported_xss;
>  
>  	struct kvm_pio_request pio;
>  	void *pio_data;
> diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
> index 8a294f9747aa..d97b2a6e8a8c 100644
> --- a/arch/x86/kvm/cpuid.c
> +++ b/arch/x86/kvm/cpuid.c
> @@ -88,14 +88,29 @@ int kvm_update_cpuid(struct kvm_vcpu *vcpu)
>  		vcpu->arch.guest_supported_xcr0 = 0;
>  	} else {
>  		vcpu->arch.guest_supported_xcr0 =
> -			(best->eax | ((u64)best->edx << 32)) & supported_xcr0;
> +			(((u64)best->edx << 32) | best->eax) & supported_xcr0;

While I don't necessarily disagree with the change, it doesn't belong in
this patch.

>  		best->ebx = xstate_required_size(vcpu->arch.xcr0, false);
>  	}
>  
>  	best = kvm_find_cpuid_entry(vcpu, 0xD, 1);
> -	if (best && (cpuid_entry_has(best, X86_FEATURE_XSAVES) ||
> -		     cpuid_entry_has(best, X86_FEATURE_XSAVEC)))
> -		best->ebx = xstate_required_size(vcpu->arch.xcr0, true);
> +	if (best) {
> +		if (cpuid_entry_has(best, X86_FEATURE_XSAVES) ||
> +		    cpuid_entry_has(best, X86_FEATURE_XSAVEC))  {
> +			u64 xstate = vcpu->arch.xcr0 | vcpu->arch.ia32_xss;
> +
> +			best->ebx = xstate_required_size(xstate, true);
> +		}
> +
> +		if (!cpuid_entry_has(best, X86_FEATURE_XSAVES)) {
> +			best->ecx = 0;
> +			best->edx = 0;
> +		}
> +		vcpu->arch.guest_supported_xss =
> +			(((u64)best->edx << 32) | best->ecx) & supported_xss;
> +
> +	} else {
> +		vcpu->arch.guest_supported_xss = 0;
> +	}
>  
>  	/*
>  	 * The existing code assumes virtual address is 48-bit or 57-bit in the
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index 906e07039d59..8aed32ff9c0c 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -2912,9 +2912,12 @@ int kvm_set_msr_common(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
>  		 * IA32_XSS[bit 8]. Guests have to use RDMSR/WRMSR rather than
>  		 * XSAVES/XRSTORS to save/restore PT MSRs.
>  		 */
> -		if (data & ~supported_xss)
> +		if (data & ~vcpu->arch.guest_supported_xss)
>  			return 1;
> -		vcpu->arch.ia32_xss = data;
> +		if (vcpu->arch.ia32_xss != data) {
> +			vcpu->arch.ia32_xss = data;
> +			kvm_update_cpuid(vcpu);
> +		}
>  		break;
>  	case MSR_SMI_COUNT:
>  		if (!msr_info->host_initiated)
> @@ -9779,8 +9782,9 @@ int kvm_arch_hardware_setup(void *opaque)
>  
>  	memcpy(&kvm_x86_ops, ops->runtime_ops, sizeof(kvm_x86_ops));
>  
> -	if (!kvm_cpu_cap_has(X86_FEATURE_XSAVES))
> -		supported_xss = 0;
> +	supported_xss = 0;
> +	if (kvm_cpu_cap_has(X86_FEATURE_XSAVES))
> +		supported_xss = host_xss & KVM_SUPPORTED_XSS;

Updating supported_xss in the actual enabling patch.

>  
>  #define __kvm_cpu_cap_has(UNUSED_, f) kvm_cpu_cap_has(f)
>  	cr4_reserved_bits = __cr4_reserved_bits(__kvm_cpu_cap_has, UNUSED_);
> -- 
> 2.17.2
> 
