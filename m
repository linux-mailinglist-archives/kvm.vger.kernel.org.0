Return-Path: <kvm+bounces-6325-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id C4D8E82EA02
	for <lists+kvm@lfdr.de>; Tue, 16 Jan 2024 08:26:11 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id EB4351C230E5
	for <lists+kvm@lfdr.de>; Tue, 16 Jan 2024 07:26:10 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 887131119F;
	Tue, 16 Jan 2024 07:26:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="aNfwW6vk"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2FD9D11184;
	Tue, 16 Jan 2024 07:25:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1705389960; x=1736925960;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=0VYlJARRAU2puU6RAyuMiQBsYdqfLxIjxrmkwXJqv10=;
  b=aNfwW6vkQiBAfchG7HnPN7RJTN3zhABoHp2sSrPdh/YKsJ86JzA8MgKX
   53o903s9HDbO5DRcssZLnGEFEpYunqPVfBwOQLOaytiBIe9mY3YDsW5NP
   kMhmeAlbQgmiJFmEHZkqxkqwkQUiXzl18xs6NWtrXBh13btadeMviMQTV
   mS/SbxGMpsyFAyNus4VbI0EZ/zCUmUMcebv2BmVJjnLpT4GY6hDi2bGF7
   vVddCkUmmVvQ77Sqi1S8g9prQRRAjN3dmj76Gt0mbGYtdEWUJMoLpJyvZ
   VdmTnMQ4mkAL5TOd/0ivdeqKWVfyPQslULMZgHHehZ2yQpnshSi3hj890
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10954"; a="7156741"
X-IronPort-AV: E=Sophos;i="6.04,198,1695711600"; 
   d="scan'208";a="7156741"
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by fmvoesa104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Jan 2024 23:25:59 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10954"; a="1030892839"
X-IronPort-AV: E=Sophos;i="6.04,198,1695711600"; 
   d="scan'208";a="1030892839"
Received: from yy-desk-7060.sh.intel.com (HELO localhost) ([10.239.159.76])
  by fmsmga006.fm.intel.com with ESMTP; 15 Jan 2024 23:25:56 -0800
Date: Tue, 16 Jan 2024 15:25:55 +0800
From: Yuan Yao <yuan.yao@linux.intel.com>
To: Yang Weijiang <weijiang.yang@intel.com>
Cc: seanjc@google.com, pbonzini@redhat.com, dave.hansen@intel.com,
	kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
	peterz@infradead.org, chao.gao@intel.com,
	rick.p.edgecombe@intel.com, mlevitsk@redhat.com, john.allen@amd.com
Subject: Re: [PATCH v8 24/26] KVM: x86: Enable CET virtualization for VMX and
 advertise to userspace
Message-ID: <20240116072555.jnj74yairx7add6i@yy-desk-7060>
References: <20231221140239.4349-1-weijiang.yang@intel.com>
 <20231221140239.4349-25-weijiang.yang@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20231221140239.4349-25-weijiang.yang@intel.com>
User-Agent: NeoMutt/20171215

On Thu, Dec 21, 2023 at 09:02:37AM -0500, Yang Weijiang wrote:
> Expose CET features to guest if KVM/host can support them, clear CPUID
> feature bits if KVM/host cannot support.
>
> Set CPUID feature bits so that CET features are available in guest CPUID.
> Add CR4.CET bit support in order to allow guest set CET master control
> bit.
>
> Disable KVM CET feature if unrestricted_guest is unsupported/disabled as
> KVM does not support emulating CET.
>
> The CET load-bits in VM_ENTRY/VM_EXIT control fields should be set to make
> guest CET xstates isolated from host's.
>
> On platforms with VMX_BASIC[bit56] == 0, inject #CP at VMX entry with error
> code will fail, and if VMX_BASIC[bit56] == 1, #CP injection with or without
> error code is allowed. Disable CET feature bits if the MSR bit is cleared
> so that nested VMM can inject #CP if and only if VMX_BASIC[bit56] == 1.
>
> Don't expose CET feature if either of {U,S}_CET xstate bits is cleared
> in host XSS or if XSAVES isn't supported.
>
> CET MSR contents after reset, power-up and INIT are set to 0s, clears the
> guest fpstate fields so that the guest MSRs are reset to 0s after the events.
>
> Signed-off-by: Yang Weijiang <weijiang.yang@intel.com>
> ---
>  arch/x86/include/asm/kvm_host.h  |  2 +-
>  arch/x86/include/asm/msr-index.h |  1 +
>  arch/x86/kvm/cpuid.c             | 19 +++++++++++++++++--
>  arch/x86/kvm/vmx/capabilities.h  |  6 ++++++
>  arch/x86/kvm/vmx/vmx.c           | 29 ++++++++++++++++++++++++++++-
>  arch/x86/kvm/vmx/vmx.h           |  6 ++++--
>  arch/x86/kvm/x86.c               | 31 +++++++++++++++++++++++++++++--
>  arch/x86/kvm/x86.h               |  3 +++
>  8 files changed, 89 insertions(+), 8 deletions(-)
...
> -#define KVM_SUPPORTED_XSS     0
> +#define KVM_SUPPORTED_XSS	(XFEATURE_MASK_CET_USER | \
> +				 XFEATURE_MASK_CET_KERNEL)
>
>  u64 __read_mostly host_efer;
>  EXPORT_SYMBOL_GPL(host_efer);
> @@ -9921,6 +9922,20 @@ static int __kvm_x86_vendor_init(struct kvm_x86_init_ops *ops)
>  	if (!kvm_cpu_cap_has(X86_FEATURE_XSAVES))
>  		kvm_caps.supported_xss = 0;
>
> +	if (!kvm_cpu_cap_has(X86_FEATURE_SHSTK) &&
> +	    !kvm_cpu_cap_has(X86_FEATURE_IBT))
> +		kvm_caps.supported_xss &= ~(XFEATURE_CET_USER |
> +					    XFEATURE_CET_KERNEL);

Looks should be XFEATURE_MASK_xxx.

> +
> +	if ((kvm_caps.supported_xss & (XFEATURE_MASK_CET_USER |
> +	     XFEATURE_MASK_CET_KERNEL)) !=
> +	    (XFEATURE_MASK_CET_USER | XFEATURE_MASK_CET_KERNEL)) {
> +		kvm_cpu_cap_clear(X86_FEATURE_SHSTK);
> +		kvm_cpu_cap_clear(X86_FEATURE_IBT);
> +		kvm_caps.supported_xss &= ~(XFEATURE_CET_USER |
> +					    XFEATURE_CET_KERNEL);

Ditto.

> +	}
> +
>  #define __kvm_cpu_cap_has(UNUSED_, f) kvm_cpu_cap_has(f)
>  	cr4_reserved_bits = __cr4_reserved_bits(__kvm_cpu_cap_has, UNUSED_);
>  #undef __kvm_cpu_cap_has
> @@ -12392,7 +12407,9 @@ void kvm_arch_vcpu_destroy(struct kvm_vcpu *vcpu)
>
>  static inline bool is_xstate_reset_needed(void)
>  {
> -	return kvm_cpu_cap_has(X86_FEATURE_MPX);
> +	return kvm_cpu_cap_has(X86_FEATURE_MPX) ||
> +	       kvm_cpu_cap_has(X86_FEATURE_SHSTK) ||
> +	       kvm_cpu_cap_has(X86_FEATURE_IBT);
>  }
>
>  void kvm_vcpu_reset(struct kvm_vcpu *vcpu, bool init_event)
> @@ -12469,6 +12486,16 @@ void kvm_vcpu_reset(struct kvm_vcpu *vcpu, bool init_event)
>  						       XFEATURE_BNDCSR);
>  		}
>
> +		if (kvm_cpu_cap_has(X86_FEATURE_SHSTK)) {
> +			fpstate_clear_xstate_component(fpstate,
> +						       XFEATURE_CET_USER);
> +			fpstate_clear_xstate_component(fpstate,
> +						       XFEATURE_CET_KERNEL);
> +		} else if (kvm_cpu_cap_has(X86_FEATURE_IBT)) {
> +			fpstate_clear_xstate_component(fpstate,
> +						       XFEATURE_CET_USER);
> +		}
> +
>  		if (init_event)
>  			kvm_load_guest_fpu(vcpu);
>  	}
> diff --git a/arch/x86/kvm/x86.h b/arch/x86/kvm/x86.h
> index 656107e64c93..cc585051d24b 100644
> --- a/arch/x86/kvm/x86.h
> +++ b/arch/x86/kvm/x86.h
> @@ -533,6 +533,9 @@ bool kvm_msr_allowed(struct kvm_vcpu *vcpu, u32 index, u32 type);
>  		__reserved_bits |= X86_CR4_PCIDE;       \
>  	if (!__cpu_has(__c, X86_FEATURE_LAM))           \
>  		__reserved_bits |= X86_CR4_LAM_SUP;     \
> +	if (!__cpu_has(__c, X86_FEATURE_SHSTK) &&       \
> +	    !__cpu_has(__c, X86_FEATURE_IBT))           \
> +		__reserved_bits |= X86_CR4_CET;         \
>  	__reserved_bits;                                \
>  })
>
> --
> 2.39.3
>
>

