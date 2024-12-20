Return-Path: <kvm+bounces-34218-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 2C4C99F9560
	for <lists+kvm@lfdr.de>; Fri, 20 Dec 2024 16:25:53 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id C2AC71897837
	for <lists+kvm@lfdr.de>; Fri, 20 Dec 2024 15:23:14 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 577C3218E87;
	Fri, 20 Dec 2024 15:23:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="LZ/QCUGv"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.9])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 14D392AE8D;
	Fri, 20 Dec 2024 15:22:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.9
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734708180; cv=none; b=OomMnD9Qr4p0dEKl7E1cJriTLcEaQ/1XfV5X7VCjOxRndi4scdq9W6trKTfuBCG8asAaHJzPmRi9Np200OQn46HqAr4xDbEwnnUfKPSzST7T3S6J5lVxdjCV/06p5Or6T7X+qSzY5XxNkKAjLrN2yqxXBgT3RngwVbXrSRApppU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734708180; c=relaxed/simple;
	bh=kVj4sIaSJlxzP7R/8K9wGfjr1BhUPsGhIuK2Fo2wgeA=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=pzXXvpQkTk9QoS/+VppJx4dhBeYUBIXFLuq0OJYgm5uMfydbLPxCFHMP4FsBjUsuT3CBEZJvPjTJLVriVwzKnQNuHZAQjWFcHyt7JE0lqCOgCPku23/3d9bzhzwXwNgiy3hF8VaIm3p/8k7zrO/mCh2dzH5dR3biK2FJwepA7T0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=LZ/QCUGv; arc=none smtp.client-ip=198.175.65.9
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1734708179; x=1766244179;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=kVj4sIaSJlxzP7R/8K9wGfjr1BhUPsGhIuK2Fo2wgeA=;
  b=LZ/QCUGvd3T5bZ4Vf9uQxrw/uGRT0Twtur1Xw0nSh15oM8G8Ya7jxStg
   FEdEJLyldT7forWEihknEWCczOEmr5w7Vm+RfKhjvoTS8nSbKon72Cv5I
   Lpvm8aE0EYoRIE2fvuvUJou2twCkajhvUvoacMBodx3IBA4Xcp16roK2c
   zJBsGn3yyVNzp1zp4XUOhSU5qIx+HCBEQb68E8uYf2PgrVnrhy33CbpBp
   URGu8uBc3QQDtILYgAkggWxtV044bes7h6A1Z7F2LiCYOYXsKldI0pOxq
   QizYQB5mD2BseNgleVOt6g87m7SUYyecKPYvNe1R9gvxjLREuOkDq/IQU
   A==;
X-CSE-ConnectionGUID: MbLB6RBKSaSf8PM71pU9kw==
X-CSE-MsgGUID: dJxE9FkYSg6XBJmqLjp48g==
X-IronPort-AV: E=McAfee;i="6700,10204,11292"; a="57729968"
X-IronPort-AV: E=Sophos;i="6.12,251,1728975600"; 
   d="scan'208";a="57729968"
Received: from orviesa008.jf.intel.com ([10.64.159.148])
  by orvoesa101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Dec 2024 07:22:58 -0800
X-CSE-ConnectionGUID: p9WvkUbnQx6Maqo+UQiR2Q==
X-CSE-MsgGUID: vlEG3d7ETdi/VsCdluKkwQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.12,224,1728975600"; 
   d="scan'208";a="99367846"
Received: from ahunter6-mobl1.ger.corp.intel.com (HELO [10.0.2.15]) ([10.246.16.163])
  by orviesa008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Dec 2024 07:22:52 -0800
Message-ID: <487a32e6-54cd-43b7-bfa6-945c725a313d@intel.com>
Date: Fri, 20 Dec 2024 17:22:44 +0200
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 4/7] KVM: TDX: restore host xsave state when exit from the
 guest TD
To: Sean Christopherson <seanjc@google.com>
Cc: Chao Gao <chao.gao@intel.com>, pbonzini@redhat.com, kvm@vger.kernel.org,
 dave.hansen@linux.intel.com, rick.p.edgecombe@intel.com,
 kai.huang@intel.com, reinette.chatre@intel.com, xiaoyao.li@intel.com,
 tony.lindgren@linux.intel.com, binbin.wu@linux.intel.com,
 dmatlack@google.com, isaku.yamahata@intel.com, nik.borisov@suse.com,
 linux-kernel@vger.kernel.org, x86@kernel.org, yan.y.zhao@intel.com,
 weijiang.yang@intel.com
References: <20241121201448.36170-1-adrian.hunter@intel.com>
 <20241121201448.36170-5-adrian.hunter@intel.com> <Z0AbZWd/avwcMoyX@intel.com>
 <a42183ab-a25a-423e-9ef3-947abec20561@intel.com>
 <Z2GiQS_RmYeHU09L@google.com>
Content-Language: en-US
From: Adrian Hunter <adrian.hunter@intel.com>
Organization: Intel Finland Oy, Registered Address: PL 281, 00181 Helsinki,
 Business Identity Code: 0357606 - 4, Domiciled in Helsinki
In-Reply-To: <Z2GiQS_RmYeHU09L@google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 17/12/24 18:09, Sean Christopherson wrote:
> On Mon, Nov 25, 2024, Adrian Hunter wrote:
> I would rather just use kvm_load_host_xsave_state(), by forcing vcpu->arch.{xcr0,xss}
> to XFAM, with a comment explaining that the TDX module sets XCR0 and XSS prior to
> returning from VP.ENTER.  I don't see any justificaton for maintaining a special
> flow for TDX, it's just more work.  E.g. TDX is missing the optimization to elide
> WRPKRU if the current value is the same as the host value.

Not entirely missing since write_pkru() does do that by itself:

static inline void write_pkru(u32 pkru)
{
	if (!cpu_feature_enabled(X86_FEATURE_OSPKE))
		return;
	/*
	 * WRPKRU is relatively expensive compared to RDPKRU.
	 * Avoid WRPKRU when it would not change the value.
	 */
	if (pkru != rdpkru())
		wrpkru(pkru);
}

For TDX, we don't really need rdpkru() since the TDX Module
clears it, so it could be:

	if (pkru)
		wrpkru(pkru);

> 
> KVM already disallows emulating a WRMSR to XSS via the tdx_has_emulated_msr()
> check, and AFAICT there's no path for the guest to set KVM's view of XCR0, CR0,
> or CR4, so I'm pretty sure stuffing state at vCPU creation is all that's needed.
> 
> That said, out of paranoia, KVM should disallow the guest from changing XSS if
> guest state is protected, i.e. in common code, as XSS is a mandatory passthrough
> for SEV-ES+, i.e. XSS is fully guest-owned for both TDX and ES+.
> 
> Ditto for CR0 and CR4 (TDX only; SEV-ES+ lets the host see the guest values).
> The current TDX code lets KVM read CR0 and CR4, but KVM will always see the RESET
> values, which are completely wrong for TDX.  KVM can obviously "work" without a
> sane view of guest CR0/CR4, but I think having a sane view will yield code that
> is easier to maintain and understand, because almost all special casing will be
> in TDX's initialization flow, not spread out wherever KVM needs to know that what
> KVM sees in guest state is a lie.
> 
> The guest_state_protected check in kvm_load_host_xsave_state() needs to be moved
> to svm_vcpu_run(), but IMO that's where the checks belong anyways, because not
> restoring host state for protected guests is obviously specific to SEV-ES+ guests,
> not to all protected guests.
> 
> Side topic, tdx_cache_reg() is ridiculous.  Just mark the "cached" registers as
> available on exit.  Invoking a callback just to do nothing is a complete waste.
> I'm also not convinced letting KVM read garbage for RIP, RSP, CR3, or PDPTRs is
> at all reasonable.  CR3 and PDPTRs should be unreachable, and I gotta imagine the
> same holds true for RSP.  Allow reads/writes to RIP is fine, in that it probably
> simplifies the overall code.
> 
> Something like this (probably won't apply, I have other local hacks as the result
> of suggestions).
> 
> ---
>  arch/x86/kvm/svm/svm.c     |  7 ++++--
>  arch/x86/kvm/vmx/main.c    |  4 +--
>  arch/x86/kvm/vmx/tdx.c     | 50 ++++++++++----------------------------
>  arch/x86/kvm/vmx/x86_ops.h |  4 ---
>  arch/x86/kvm/x86.c         | 15 +++++++-----
>  5 files changed, 28 insertions(+), 52 deletions(-)
> 
> diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
> index dd15cc635655..63df43e5dcce 100644
> --- a/arch/x86/kvm/svm/svm.c
> +++ b/arch/x86/kvm/svm/svm.c
> @@ -4251,7 +4251,9 @@ static __no_kcsan fastpath_t svm_vcpu_run(struct kvm_vcpu *vcpu,
>  		svm_set_dr6(svm, DR6_ACTIVE_LOW);
>  
>  	clgi();
> -	kvm_load_guest_xsave_state(vcpu);
> +
> +	if (!vcpu->arch.guest_state_protected)
> +		kvm_load_guest_xsave_state(vcpu);
>  
>  	kvm_wait_lapic_expire(vcpu);
>  
> @@ -4280,7 +4282,8 @@ static __no_kcsan fastpath_t svm_vcpu_run(struct kvm_vcpu *vcpu,
>  	if (unlikely(svm->vmcb->control.exit_code == SVM_EXIT_NMI))
>  		kvm_before_interrupt(vcpu, KVM_HANDLING_NMI);
>  
> -	kvm_load_host_xsave_state(vcpu);
> +	if (!vcpu->arch.guest_state_protected)
> +		kvm_load_host_xsave_state(vcpu);
>  	stgi();
>  
>  	/* Any pending NMI will happen here */
> diff --git a/arch/x86/kvm/vmx/main.c b/arch/x86/kvm/vmx/main.c
> index 2742f2af7f55..d2e78e6675b9 100644
> --- a/arch/x86/kvm/vmx/main.c
> +++ b/arch/x86/kvm/vmx/main.c
> @@ -520,10 +520,8 @@ static void vt_sync_dirty_debug_regs(struct kvm_vcpu *vcpu)
>  
>  static void vt_cache_reg(struct kvm_vcpu *vcpu, enum kvm_reg reg)
>  {
> -	if (is_td_vcpu(vcpu)) {
> -		tdx_cache_reg(vcpu, reg);
> +	if (WARN_ON_ONCE(is_td_vcpu(vcpu)))
>  		return;
> -	}
>  
>  	vmx_cache_reg(vcpu, reg);
>  }
> diff --git a/arch/x86/kvm/vmx/tdx.c b/arch/x86/kvm/vmx/tdx.c
> index 7eff717c9d0d..b49dcf32206b 100644
> --- a/arch/x86/kvm/vmx/tdx.c
> +++ b/arch/x86/kvm/vmx/tdx.c
> @@ -636,6 +636,9 @@ int tdx_vcpu_create(struct kvm_vcpu *vcpu)
>  	vcpu->arch.cr0_guest_owned_bits = -1ul;
>  	vcpu->arch.cr4_guest_owned_bits = -1ul;
>  
> +	vcpu->arch.cr4 = <maximal value>;

Sorry for slow reply.  Seems fine except maybe CR4 usage.

TDX Module validates CR4 based on XFAM and scrubs host state
based on XFAM.  It seems like we would need to use XFAM to
manufacture a CR4 that we then effectively use as a proxy
instead of just checking XFAM.

Since only some vcpu->arch.cr4 bits will be meaningful, it also
still leaves the possibility for confusion.

Are you sure you want this?

> +	vcpu->arch.cr0 = <maximal value, give or take>;

AFAICT we don't need to care about CR0

> +
>  	vcpu->arch.tsc_offset = kvm_tdx->tsc_offset;
>  	vcpu->arch.l1_tsc_offset = vcpu->arch.tsc_offset;
>  	/*
> @@ -659,6 +662,14 @@ int tdx_vcpu_create(struct kvm_vcpu *vcpu)
>  
>  	tdx->state = VCPU_TD_STATE_UNINITIALIZED;
>  
> +	/*
> +	 * On return from VP.ENTER, the TDX Module sets XCR0 and XSS to the
> +	 * maximal values supported by the guest, so from KVM's perspective,
> +	 * those are the guest's values at all times.
> +	 */
> +	vcpu->arch.ia32_xss = (kvm_tdx->xfam & XFEATURE_SUPERVISOR_MASK);
> +	vcpu->arch.xcr0 = (kvm_tdx->xfam & XFEATURE_USE_MASK);
> +
>  	return 0;
>  }
>  
> @@ -824,24 +835,6 @@ static void tdx_user_return_msr_update_cache(struct kvm_vcpu *vcpu)
>  		kvm_user_return_msr_update_cache(tdx_uret_tsx_ctrl_slot, 0);
>  }
>  
> -static void tdx_restore_host_xsave_state(struct kvm_vcpu *vcpu)
> -{
> -	struct kvm_tdx *kvm_tdx = to_kvm_tdx(vcpu->kvm);
> -
> -	if (static_cpu_has(X86_FEATURE_XSAVE) &&
> -	    kvm_host.xcr0 != (kvm_tdx->xfam & kvm_caps.supported_xcr0))
> -		xsetbv(XCR_XFEATURE_ENABLED_MASK, kvm_host.xcr0);
> -	if (static_cpu_has(X86_FEATURE_XSAVES) &&
> -	    /* PT can be exposed to TD guest regardless of KVM's XSS support */
> -	    kvm_host.xss != (kvm_tdx->xfam &
> -			 (kvm_caps.supported_xss | XFEATURE_MASK_PT |
> -			  XFEATURE_MASK_CET_USER | XFEATURE_MASK_CET_KERNEL)))
> -		wrmsrl(MSR_IA32_XSS, kvm_host.xss);
> -	if (static_cpu_has(X86_FEATURE_PKU) &&
> -	    (kvm_tdx->xfam & XFEATURE_MASK_PKRU))
> -		write_pkru(vcpu->arch.host_pkru);
> -}
> -
>  static union vmx_exit_reason tdx_to_vmx_exit_reason(struct kvm_vcpu *vcpu)
>  {
>  	struct vcpu_tdx *tdx = to_tdx(vcpu);
> @@ -941,10 +934,10 @@ fastpath_t tdx_vcpu_run(struct kvm_vcpu *vcpu, bool force_immediate_exit)
>  	tdx_vcpu_enter_exit(vcpu);
>  
>  	tdx_user_return_msr_update_cache(vcpu);
> -	tdx_restore_host_xsave_state(vcpu);
> +	kvm_load_host_xsave_state(vcpu);
>  	tdx->host_state_need_restore = true;
>  
> -	vcpu->arch.regs_avail &= ~VMX_REGS_LAZY_LOAD_SET;
> +	vcpu->arch.regs_avail = TDX_REGS_UNSUPPORTED_SET;
>  
>  	if (unlikely((tdx->vp_enter_ret & TDX_SW_ERROR) == TDX_SW_ERROR))
>  		return EXIT_FASTPATH_NONE;
> @@ -1963,23 +1956,6 @@ int tdx_set_msr(struct kvm_vcpu *vcpu, struct msr_data *msr)
>  	}
>  }
>  
> -void tdx_cache_reg(struct kvm_vcpu *vcpu, enum kvm_reg reg)
> -{
> -	kvm_register_mark_available(vcpu, reg);
> -	switch (reg) {
> -	case VCPU_REGS_RSP:
> -	case VCPU_REGS_RIP:
> -	case VCPU_EXREG_PDPTR:
> -	case VCPU_EXREG_CR0:
> -	case VCPU_EXREG_CR3:
> -	case VCPU_EXREG_CR4:
> -		break;
> -	default:
> -		KVM_BUG_ON(1, vcpu->kvm);
> -		break;
> -	}
> -}
> -
>  static int tdx_get_capabilities(struct kvm_tdx_cmd *cmd)
>  {
>  	const struct tdx_sys_info_td_conf *td_conf = &tdx_sysinfo->td_conf;
> diff --git a/arch/x86/kvm/vmx/x86_ops.h b/arch/x86/kvm/vmx/x86_ops.h
> index ef60eb7b1245..efa6723837c6 100644
> --- a/arch/x86/kvm/vmx/x86_ops.h
> +++ b/arch/x86/kvm/vmx/x86_ops.h
> @@ -145,8 +145,6 @@ bool tdx_has_emulated_msr(u32 index);
>  int tdx_get_msr(struct kvm_vcpu *vcpu, struct msr_data *msr);
>  int tdx_set_msr(struct kvm_vcpu *vcpu, struct msr_data *msr);
>  
> -void tdx_cache_reg(struct kvm_vcpu *vcpu, enum kvm_reg reg);
> -
>  int tdx_vcpu_ioctl(struct kvm_vcpu *vcpu, void __user *argp);
>  
>  int tdx_sept_link_private_spt(struct kvm *kvm, gfn_t gfn,
> @@ -193,8 +191,6 @@ static inline bool tdx_has_emulated_msr(u32 index) { return false; }
>  static inline int tdx_get_msr(struct kvm_vcpu *vcpu, struct msr_data *msr) { return 1; }
>  static inline int tdx_set_msr(struct kvm_vcpu *vcpu, struct msr_data *msr) { return 1; }
>  
> -static inline void tdx_cache_reg(struct kvm_vcpu *vcpu, enum kvm_reg reg) {}
> -
>  static inline int tdx_vcpu_ioctl(struct kvm_vcpu *vcpu, void __user *argp) { return -EOPNOTSUPP; }
>  
>  static inline int tdx_sept_link_private_spt(struct kvm *kvm, gfn_t gfn,
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index 4f94b1e24eae..d380837433c6 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -1184,11 +1184,9 @@ EXPORT_SYMBOL_GPL(kvm_lmsw);
>  
>  void kvm_load_guest_xsave_state(struct kvm_vcpu *vcpu)
>  {
> -	if (vcpu->arch.guest_state_protected)
> -		return;
> +	WARN_ON_ONCE(vcpu->arch.guest_state_protected);
>  
>  	if (kvm_is_cr4_bit_set(vcpu, X86_CR4_OSXSAVE)) {
> -
>  		if (vcpu->arch.xcr0 != kvm_host.xcr0)
>  			xsetbv(XCR_XFEATURE_ENABLED_MASK, vcpu->arch.xcr0);
>  
> @@ -1207,9 +1205,6 @@ EXPORT_SYMBOL_GPL(kvm_load_guest_xsave_state);
>  
>  void kvm_load_host_xsave_state(struct kvm_vcpu *vcpu)
>  {
> -	if (vcpu->arch.guest_state_protected)
> -		return;
> -
>  	if (cpu_feature_enabled(X86_FEATURE_PKU) &&
>  	    ((vcpu->arch.xcr0 & XFEATURE_MASK_PKRU) ||
>  	     kvm_is_cr4_bit_set(vcpu, X86_CR4_PKE))) {
> @@ -3943,6 +3938,10 @@ int kvm_set_msr_common(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
>  		if (!msr_info->host_initiated &&
>  		    !guest_cpuid_has(vcpu, X86_FEATURE_XSAVES))
>  			return 1;
> +
> +		if (vcpu->arch.guest_state_protected)
> +			return 1;
> +
>  		/*
>  		 * KVM supports exposing PT to the guest, but does not support
>  		 * IA32_XSS[bit 8]. Guests have to use RDMSR/WRMSR rather than
> @@ -4402,6 +4401,10 @@ int kvm_get_msr_common(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
>  		if (!msr_info->host_initiated &&
>  		    !guest_cpuid_has(vcpu, X86_FEATURE_XSAVES))
>  			return 1;
> +
> +		if (vcpu->arch.guest_state_protected)
> +			return 1;
> +
>  		msr_info->data = vcpu->arch.ia32_xss;
>  		break;
>  	case MSR_K7_CLK_CTL:
> 
> base-commit: 0319082fc23089f516618e193d94da18c837e35a


