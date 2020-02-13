Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6AE2615C038
	for <lists+kvm@lfdr.de>; Thu, 13 Feb 2020 15:21:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730121AbgBMOVh (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 13 Feb 2020 09:21:37 -0500
Received: from mga17.intel.com ([192.55.52.151]:31134 "EHLO mga17.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730003AbgBMOVg (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 13 Feb 2020 09:21:36 -0500
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmsmga107.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 13 Feb 2020 06:21:30 -0800
X-IronPort-AV: E=Sophos;i="5.70,437,1574150400"; 
   d="scan'208";a="227244438"
Received: from xiaoyaol-mobl.ccr.corp.intel.com (HELO [10.255.30.123]) ([10.255.30.123])
  by orsmga008-auth.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-SHA; 13 Feb 2020 06:21:28 -0800
Subject: Re: [PATCH 20/61] KVM: x86: Calculate the supported xcr0 mask at load
 time
To:     Sean Christopherson <sean.j.christopherson@intel.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20200201185218.24473-1-sean.j.christopherson@intel.com>
 <20200201185218.24473-21-sean.j.christopherson@intel.com>
From:   Xiaoyao Li <xiaoyao.li@intel.com>
Message-ID: <e39da523-e015-663e-7a7a-5d6731ac5e65@intel.com>
Date:   Thu, 13 Feb 2020 22:21:26 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.2
MIME-Version: 1.0
In-Reply-To: <20200201185218.24473-21-sean.j.christopherson@intel.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 2/2/2020 2:51 AM, Sean Christopherson wrote:
> Add a new global variable, supported_xcr0, to track which xcr0 bits can
> be exposed to the guest instead of calculating the mask on every call.
> The supported bits are constant for a given instance of KVM.
> 
> This paves the way toward eliminating the ->mpx_supported() call in
> kvm_mpx_supported(), e.g. eliminates multiple retpolines in VMX's nested
> VM-Enter path, and eventually toward eliminating ->mpx_supported()
> altogether.
> 
> No functional change intended.
> 

Reviewed-by: Xiaoyao Li <xiaoyao.li@intel.com>

> Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
> ---
>   arch/x86/kvm/cpuid.c   | 32 +++++++++-----------------------
>   arch/x86/kvm/svm.c     |  2 ++
>   arch/x86/kvm/vmx/vmx.c |  4 ++++
>   arch/x86/kvm/x86.c     | 14 +++++++++++---
>   arch/x86/kvm/x86.h     |  7 +------
>   5 files changed, 27 insertions(+), 32 deletions(-)
> 
> diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
> index bfd8304a8437..b9763eb711cb 100644
> --- a/arch/x86/kvm/cpuid.c
> +++ b/arch/x86/kvm/cpuid.c
> @@ -52,16 +52,6 @@ bool kvm_mpx_supported(void)
>   }
>   EXPORT_SYMBOL_GPL(kvm_mpx_supported);
>   
> -u64 kvm_supported_xcr0(void)
> -{
> -	u64 xcr0 = KVM_SUPPORTED_XCR0 & host_xcr0;
> -
> -	if (!kvm_mpx_supported())
> -		xcr0 &= ~(XFEATURE_MASK_BNDREGS | XFEATURE_MASK_BNDCSR);
> -
> -	return xcr0;
> -}
> -
>   #define F feature_bit
>   
>   int kvm_update_cpuid(struct kvm_vcpu *vcpu)
> @@ -107,8 +97,7 @@ int kvm_update_cpuid(struct kvm_vcpu *vcpu)
>   		vcpu->arch.guest_xstate_size = XSAVE_HDR_SIZE + XSAVE_HDR_OFFSET;
>   	} else {
>   		vcpu->arch.guest_supported_xcr0 =
> -			(best->eax | ((u64)best->edx << 32)) &
> -			kvm_supported_xcr0();
> +			(best->eax | ((u64)best->edx << 32)) & supported_xcr0;
>   		vcpu->arch.guest_xstate_size = best->ebx =
>   			xstate_required_size(vcpu->arch.xcr0, false);
>   	}
> @@ -633,14 +622,12 @@ static inline int __do_cpuid_func(struct kvm_cpuid_array *array, u32 function)
>   				goto out;
>   		}
>   		break;
> -	case 0xd: {
> -		u64 supported = kvm_supported_xcr0();
> -
> -		entry->eax &= supported;
> -		entry->ebx = xstate_required_size(supported, false);
> +	case 0xd:
> +		entry->eax &= supported_xcr0;
> +		entry->ebx = xstate_required_size(supported_xcr0, false);
>   		entry->ecx = entry->ebx;
> -		entry->edx &= supported >> 32;
> -		if (!supported)
> +		entry->edx &= supported_xcr0 >> 32;
> +		if (!supported_xcr0)
>   			break;
>   
>   		entry = do_host_cpuid(array, function, 1);
> @@ -650,7 +637,7 @@ static inline int __do_cpuid_func(struct kvm_cpuid_array *array, u32 function)
>   		entry->eax &= kvm_cpuid_D_1_eax_x86_features;
>   		cpuid_mask(&entry->eax, CPUID_D_1_EAX);
>   		if (entry->eax & (F(XSAVES)|F(XSAVEC)))
> -			entry->ebx = xstate_required_size(supported, true);
> +			entry->ebx = xstate_required_size(supported_xcr0, true);
>   		else
>   			entry->ebx = 0;
>   		/* Saving XSS controlled state via XSAVES isn't supported. */
> @@ -658,7 +645,7 @@ static inline int __do_cpuid_func(struct kvm_cpuid_array *array, u32 function)
>   		entry->edx = 0;
>   
>   		for (i = 2; i < 64; ++i) {
> -			if (!(supported & BIT_ULL(i)))
> +			if (!(supported_xcr0 & BIT_ULL(i)))
>   				continue;
>   
>   			entry = do_host_cpuid(array, function, i);
> @@ -666,7 +653,7 @@ static inline int __do_cpuid_func(struct kvm_cpuid_array *array, u32 function)
>   				goto out;
>   
>   			/*
> -			 * The @supported check above should have filtered out
> +			 * The supported check above should have filtered out
>   			 * invalid sub-leafs as well as sub-leafs managed by
>   			 * IA32_XSS MSR.  Only XCR0-managed sub-leafs should
>   			 * reach this point, and they should have a non-zero
> @@ -681,7 +668,6 @@ static inline int __do_cpuid_func(struct kvm_cpuid_array *array, u32 function)
>   			entry->edx = 0;
>   		}
>   		break;
> -	}
>   	/* Intel PT */
>   	case 0x14:
>   		if (!f_intel_pt)
> diff --git a/arch/x86/kvm/svm.c b/arch/x86/kvm/svm.c
> index bf0556588ad0..af096c4f9c5f 100644
> --- a/arch/x86/kvm/svm.c
> +++ b/arch/x86/kvm/svm.c
> @@ -1368,6 +1368,8 @@ static __init int svm_hardware_setup(void)
>   
>   	init_msrpm_offsets();
>   
> +	supported_xcr0 &= ~(XFEATURE_MASK_BNDREGS | XFEATURE_MASK_BNDCSR);
> +
>   	if (boot_cpu_has(X86_FEATURE_NX))
>   		kvm_enable_efer_bits(EFER_NX);
>   
> diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
> index 588aa5e4164e..32a84ec15064 100644
> --- a/arch/x86/kvm/vmx/vmx.c
> +++ b/arch/x86/kvm/vmx/vmx.c
> @@ -7590,6 +7590,10 @@ static __init int hardware_setup(void)
>   		WARN_ONCE(host_bndcfgs, "KVM: BNDCFGS in host will be lost");
>   	}
>   
> +	if (!kvm_mpx_supported())
> +		supported_xcr0 &= ~(XFEATURE_MASK_BNDREGS |
> +				    XFEATURE_MASK_BNDCSR);
> +
>   	if (!cpu_has_vmx_vpid() || !cpu_has_vmx_invvpid() ||
>   	    !(cpu_has_vmx_invvpid_single() || cpu_has_vmx_invvpid_global()))
>   		enable_vpid = 0;
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index 7e3f1d937224..f90c56c0c64a 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -180,6 +180,11 @@ struct kvm_shared_msrs {
>   static struct kvm_shared_msrs_global __read_mostly shared_msrs_global;
>   static struct kvm_shared_msrs __percpu *shared_msrs;
>   
> +#define KVM_SUPPORTED_XCR0     (XFEATURE_MASK_FP | XFEATURE_MASK_SSE \
> +				| XFEATURE_MASK_YMM | XFEATURE_MASK_BNDREGS \
> +				| XFEATURE_MASK_BNDCSR | XFEATURE_MASK_AVX512 \
> +				| XFEATURE_MASK_PKRU)
> +
>   static u64 __read_mostly host_xss;
>   
>   struct kvm_stats_debugfs_item debugfs_entries[] = {
> @@ -226,6 +231,8 @@ struct kvm_stats_debugfs_item debugfs_entries[] = {
>   };
>   
>   u64 __read_mostly host_xcr0;
> +u64 __read_mostly supported_xcr0;
> +EXPORT_SYMBOL_GPL(supported_xcr0);
>   
>   struct kmem_cache *x86_fpu_cache;
>   EXPORT_SYMBOL_GPL(x86_fpu_cache);
> @@ -4081,8 +4088,7 @@ static int kvm_vcpu_ioctl_x86_set_xsave(struct kvm_vcpu *vcpu,
>   		 * CPUID leaf 0xD, index 0, EDX:EAX.  This is for compatibility
>   		 * with old userspace.
>   		 */
> -		if (xstate_bv & ~kvm_supported_xcr0() ||
> -			mxcsr & ~mxcsr_feature_mask)
> +		if (xstate_bv & ~supported_xcr0 || mxcsr & ~mxcsr_feature_mask)
>   			return -EINVAL;
>   		load_xsave(vcpu, (u8 *)guest_xsave->region);
>   	} else {
> @@ -7335,8 +7341,10 @@ int kvm_arch_init(void *opaque)
>   
>   	perf_register_guest_info_callbacks(&kvm_guest_cbs);
>   
> -	if (boot_cpu_has(X86_FEATURE_XSAVE))
> +	if (boot_cpu_has(X86_FEATURE_XSAVE)) {
>   		host_xcr0 = xgetbv(XCR_XFEATURE_ENABLED_MASK);
> +		supported_xcr0 = host_xcr0 & KVM_SUPPORTED_XCR0;
> +	}
>   
>   	kvm_lapic_init();
>   	if (pi_inject_timer == -1)
> diff --git a/arch/x86/kvm/x86.h b/arch/x86/kvm/x86.h
> index 3624665acee4..02b49ee49e24 100644
> --- a/arch/x86/kvm/x86.h
> +++ b/arch/x86/kvm/x86.h
> @@ -280,13 +280,8 @@ int x86_emulate_instruction(struct kvm_vcpu *vcpu, gpa_t cr2_or_gpa,
>   			    int emulation_type, void *insn, int insn_len);
>   enum exit_fastpath_completion handle_fastpath_set_msr_irqoff(struct kvm_vcpu *vcpu);
>   
> -#define KVM_SUPPORTED_XCR0     (XFEATURE_MASK_FP | XFEATURE_MASK_SSE \
> -				| XFEATURE_MASK_YMM | XFEATURE_MASK_BNDREGS \
> -				| XFEATURE_MASK_BNDCSR | XFEATURE_MASK_AVX512 \
> -				| XFEATURE_MASK_PKRU)
>   extern u64 host_xcr0;
> -
> -extern u64 kvm_supported_xcr0(void);
> +extern u64 supported_xcr0;
>   
>   extern unsigned int min_timer_period_us;
>   
> 

