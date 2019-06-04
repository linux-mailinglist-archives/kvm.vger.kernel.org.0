Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DE3CD35081
	for <lists+kvm@lfdr.de>; Tue,  4 Jun 2019 21:58:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726352AbfFDT6D (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 4 Jun 2019 15:58:03 -0400
Received: from mga03.intel.com ([134.134.136.65]:31163 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725933AbfFDT6D (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 4 Jun 2019 15:58:03 -0400
X-Amp-Result: UNSCANNABLE
X-Amp-File-Uploaded: False
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by orsmga103.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 04 Jun 2019 12:58:02 -0700
X-ExtLoop1: 1
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com) ([10.54.74.36])
  by orsmga008.jf.intel.com with ESMTP; 04 Jun 2019 12:58:01 -0700
Date:   Tue, 4 Jun 2019 12:58:01 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Yang Weijiang <weijiang.yang@intel.com>
Cc:     pbonzini@redhat.com, mst@redhat.com, rkrcmar@redhat.com,
        jmattson@google.com, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, yu-cheng.yu@intel.com
Subject: Re: [PATCH v5 2/8] KVM: x86: Implement CET CPUID support for Guest
Message-ID: <20190604195801.GA7476@linux.intel.com>
References: <20190522070101.7636-1-weijiang.yang@intel.com>
 <20190522070101.7636-3-weijiang.yang@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190522070101.7636-3-weijiang.yang@intel.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, May 22, 2019 at 03:00:55PM +0800, Yang Weijiang wrote:
> CET SHSTK and IBT features are introduced here so that
> CPUID.(EAX=7, ECX=0):ECX[bit 7] and EDX[bit 20] reflect them.
> CET xsave components for supervisor and user mode are reported
> via CPUID.(EAX=0xD, ECX=1):ECX[bit 11] and ECX[bit 12]
> respectively.
> 
> To make the code look clean, wrap CPUID(0xD,n>=1) report code in
> a helper function now.

Create the helper in a separate patch so that it's introduced without
any functional changes.
 
> Signed-off-by: Yang Weijiang <weijiang.yang@intel.com>
> Co-developed-by: Zhang Yi Z <yi.z.zhang@linux.intel.com>
> ---
>  arch/x86/include/asm/kvm_host.h |  4 +-
>  arch/x86/kvm/cpuid.c            | 97 +++++++++++++++++++++------------
>  arch/x86/kvm/vmx/vmx.c          |  6 ++
>  arch/x86/kvm/x86.h              |  4 ++
>  4 files changed, 76 insertions(+), 35 deletions(-)
> 
> diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
> index a5db4475e72d..8c3f0ddc7676 100644
> --- a/arch/x86/include/asm/kvm_host.h
> +++ b/arch/x86/include/asm/kvm_host.h
> @@ -91,7 +91,8 @@
>  			  | X86_CR4_PGE | X86_CR4_PCE | X86_CR4_OSFXSR | X86_CR4_PCIDE \
>  			  | X86_CR4_OSXSAVE | X86_CR4_SMEP | X86_CR4_FSGSBASE \
>  			  | X86_CR4_OSXMMEXCPT | X86_CR4_LA57 | X86_CR4_VMXE \
> -			  | X86_CR4_SMAP | X86_CR4_PKE | X86_CR4_UMIP))
> +			  | X86_CR4_SMAP | X86_CR4_PKE | X86_CR4_UMIP \
> +			  | X86_CR4_CET))

As I mentioned in v4, the patch ordering is wrong.  Features shouldn't be
advertised to userspace or exposed to the guest until they're fully
supported in KVM, i.e. the bulk of this patch to advertise the CPUID bits
and allow CR4.CET=1 belongs at the end of the series.

>  #define CR8_RESERVED_BITS (~(unsigned long)X86_CR8_TPR)
>  
> @@ -1192,6 +1193,7 @@ struct kvm_x86_ops {
>  	int (*nested_enable_evmcs)(struct kvm_vcpu *vcpu,
>  				   uint16_t *vmcs_version);
>  	uint16_t (*nested_get_evmcs_version)(struct kvm_vcpu *vcpu);
> +	u64 (*supported_xss)(void);
>  };
>  
>  struct kvm_arch_async_pf {
> diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
> index fd3951638ae4..b9fc967fe55a 100644
> --- a/arch/x86/kvm/cpuid.c
> +++ b/arch/x86/kvm/cpuid.c
> @@ -65,6 +65,11 @@ u64 kvm_supported_xcr0(void)
>  	return xcr0;
>  }
>  
> +u64 kvm_supported_xss(void)
> +{
> +	return KVM_SUPPORTED_XSS & kvm_x86_ops->supported_xss();
> +}
> +
>  #define F(x) bit(X86_FEATURE_##x)
>  
>  int kvm_update_cpuid(struct kvm_vcpu *vcpu)
> @@ -316,6 +321,50 @@ static int __do_cpuid_ent_emulated(struct kvm_cpuid_entry2 *entry,
>  	return 0;
>  }
>  
> +static inline int __do_cpuid_dx_leaf(struct kvm_cpuid_entry2 *entry, int *nent,
> +				     int maxnent, u64 xss_mask, u64 xcr0_mask,
> +				     u32 eax_mask)
> +{
> +	int idx, i;
> +	u64 mask;
> +	u64 supported;
> +
> +	for (idx = 1, i = 1; idx < 64; ++idx) {
> +		mask = ((u64)1 << idx);
> +		if (*nent >= maxnent)
> +			return -EINVAL;
> +
> +		do_cpuid_1_ent(&entry[i], 0xD, idx);
> +		if (idx == 1) {
> +			entry[i].eax &= eax_mask;
> +			cpuid_mask(&entry[i].eax, CPUID_D_1_EAX);
> +			supported = xcr0_mask | xss_mask;
> +			entry[i].ebx = 0;
> +			entry[i].edx = 0;
> +			entry[i].ecx &= xss_mask;
> +			if (entry[i].eax & (F(XSAVES) | F(XSAVEC))) {
> +				entry[i].ebx =
> +					xstate_required_size(supported,
> +							     true);
> +			}
> +		} else {
> +			supported = (entry[i].ecx & 1) ? xss_mask :
> +				     xcr0_mask;
> +			if (entry[i].eax == 0 || !(supported & mask))
> +				continue;
> +			entry[i].ecx &= 1;
> +			entry[i].edx = 0;
> +			if (entry[i].ecx)
> +				entry[i].ebx = 0;
> +		}
> +		entry[i].flags |=
> +			KVM_CPUID_FLAG_SIGNIFCANT_INDEX;
> +		++*nent;
> +		++i;
> +	}
> +	return 0;
> +}
> +
>  static inline int __do_cpuid_ent(struct kvm_cpuid_entry2 *entry, u32 function,
>  				 u32 index, int *nent, int maxnent)
>  {
> @@ -405,12 +454,13 @@ static inline int __do_cpuid_ent(struct kvm_cpuid_entry2 *entry, u32 function,
>  		F(AVX512VBMI) | F(LA57) | F(PKU) | 0 /*OSPKE*/ |
>  		F(AVX512_VPOPCNTDQ) | F(UMIP) | F(AVX512_VBMI2) | F(GFNI) |
>  		F(VAES) | F(VPCLMULQDQ) | F(AVX512_VNNI) | F(AVX512_BITALG) |
> -		F(CLDEMOTE) | F(MOVDIRI) | F(MOVDIR64B);
> +		F(CLDEMOTE) | F(MOVDIRI) | F(MOVDIR64B) | F(SHSTK);
>  
>  	/* cpuid 7.0.edx*/
>  	const u32 kvm_cpuid_7_0_edx_x86_features =
>  		F(AVX512_4VNNIW) | F(AVX512_4FMAPS) | F(SPEC_CTRL) |
> -		F(SPEC_CTRL_SSBD) | F(ARCH_CAPABILITIES) | F(INTEL_STIBP);
> +		F(SPEC_CTRL_SSBD) | F(ARCH_CAPABILITIES) | F(INTEL_STIBP) |
> +		F(IBT);
>  
>  	/* all calls to cpuid_count() should be made on the same cpu */
>  	get_cpu();
> @@ -565,44 +615,23 @@ static inline int __do_cpuid_ent(struct kvm_cpuid_entry2 *entry, u32 function,
>  		break;
>  	}
>  	case 0xd: {
> -		int idx, i;
> -		u64 supported = kvm_supported_xcr0();
> +		u64 u_supported = kvm_supported_xcr0();
> +		u64 s_supported = kvm_supported_xss();
> +		u32 eax_mask = kvm_cpuid_D_1_eax_x86_features;
>  
> -		entry->eax &= supported;
> -		entry->ebx = xstate_required_size(supported, false);
> +		entry->eax &= u_supported;
> +		entry->ebx = xstate_required_size(u_supported, false);
>  		entry->ecx = entry->ebx;
> -		entry->edx &= supported >> 32;
> +		entry->edx &= u_supported >> 32;
>  		entry->flags |= KVM_CPUID_FLAG_SIGNIFCANT_INDEX;
> -		if (!supported)
> +
> +		if (!u_supported && !s_supported)
>  			break;
>  
> -		for (idx = 1, i = 1; idx < 64; ++idx) {
> -			u64 mask = ((u64)1 << idx);
> -			if (*nent >= maxnent)
> -				goto out;
> +		if (__do_cpuid_dx_leaf(entry, nent, maxnent, s_supported,
> +				       u_supported, eax_mask) < 0)
> +			goto out;
>  
> -			do_cpuid_1_ent(&entry[i], function, idx);
> -			if (idx == 1) {
> -				entry[i].eax &= kvm_cpuid_D_1_eax_x86_features;
> -				cpuid_mask(&entry[i].eax, CPUID_D_1_EAX);
> -				entry[i].ebx = 0;
> -				if (entry[i].eax & (F(XSAVES)|F(XSAVEC)))
> -					entry[i].ebx =
> -						xstate_required_size(supported,
> -								     true);
> -			} else {
> -				if (entry[i].eax == 0 || !(supported & mask))
> -					continue;
> -				if (WARN_ON_ONCE(entry[i].ecx & 1))
> -					continue;
> -			}
> -			entry[i].ecx = 0;
> -			entry[i].edx = 0;
> -			entry[i].flags |=
> -			       KVM_CPUID_FLAG_SIGNIFCANT_INDEX;
> -			++*nent;
> -			++i;
> -		}
>  		break;
>  	}
>  	/* Intel PT */
> diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
> index 7c015416fd58..574428375ff9 100644
> --- a/arch/x86/kvm/vmx/vmx.c
> +++ b/arch/x86/kvm/vmx/vmx.c
> @@ -1637,6 +1637,11 @@ static inline bool vmx_feature_control_msr_valid(struct kvm_vcpu *vcpu,
>  	return !(val & ~valid_bits);
>  }
>  
> +static __always_inline u64 vmx_supported_xss(void)

This can't be __always_inline since it's invoked indirectly.  Out of
curiosity, does the compiler generate a warning of any kind?

> +{
> +	return host_xss;
> +}
> +
>  static int vmx_get_msr_feature(struct kvm_msr_entry *msr)
>  {
>  	switch (msr->index) {
> @@ -7711,6 +7716,7 @@ static struct kvm_x86_ops vmx_x86_ops __ro_after_init = {
>  	.set_nested_state = NULL,
>  	.get_vmcs12_pages = NULL,
>  	.nested_enable_evmcs = NULL,
> +	.supported_xss = vmx_supported_xss,
>  };
>  
>  static void vmx_cleanup_l1d_flush(void)
> diff --git a/arch/x86/kvm/x86.h b/arch/x86/kvm/x86.h
> index 28406aa1136d..e96616149f84 100644
> --- a/arch/x86/kvm/x86.h
> +++ b/arch/x86/kvm/x86.h
> @@ -288,6 +288,10 @@ int x86_emulate_instruction(struct kvm_vcpu *vcpu, unsigned long cr2,
>  				| XFEATURE_MASK_YMM | XFEATURE_MASK_BNDREGS \
>  				| XFEATURE_MASK_BNDCSR | XFEATURE_MASK_AVX512 \
>  				| XFEATURE_MASK_PKRU)
> +
> +#define KVM_SUPPORTED_XSS	(XFEATURE_MASK_CET_USER \
> +				| XFEATURE_MASK_CET_KERNEL)
> +
>  extern u64 host_xcr0;
>  
>  extern u64 kvm_supported_xcr0(void);
> -- 
> 2.17.2
> 
