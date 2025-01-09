Return-Path: <kvm+bounces-34937-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id E9925A0807C
	for <lists+kvm@lfdr.de>; Thu,  9 Jan 2025 20:12:09 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id E12FC163F08
	for <lists+kvm@lfdr.de>; Thu,  9 Jan 2025 19:12:07 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B61E11AF0B6;
	Thu,  9 Jan 2025 19:12:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="pB6Y9HHJ"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com [209.85.216.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4359E1B0421
	for <kvm@vger.kernel.org>; Thu,  9 Jan 2025 19:12:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736449922; cv=none; b=U4xU3qtC+wtlXM2zKIbQOPaNMHi9UW3JSN+z6rXzC/P6UNTI21NeHU59jRt3csjqrN2AQ4Sa72ASyAOwLdGV6E2DRfUGwyUfh8vDs5Lt9tYOSKouYd9I719cMsictBeLVGkb1mqEdc/gWqRAjwRXiwgwrhr0hOER7jXdYE6gVWE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736449922; c=relaxed/simple;
	bh=BpBiGqYFHovSTWgRh2+JaFBjaw0skiP5qvfBnoyxfmw=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=BZ/4GzktVrPDL2jNatG2+FuqXFEsVOecfIVdGClin2txM8YN/5FeYujB0fXbGWE8LG6BPDgAwa8WRqJnX3OpVG9FCLrD0ZCfEgVYVmKoqEwxsDpMM4z0mQMN3kvYFu32zfelU3U5OcmCp/PognglOA+rQQB8sgUrCfGP8gZYqtk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=pB6Y9HHJ; arc=none smtp.client-ip=209.85.216.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f74.google.com with SMTP id 98e67ed59e1d1-2ef9dbeb848so2224458a91.0
        for <kvm@vger.kernel.org>; Thu, 09 Jan 2025 11:12:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1736449921; x=1737054721; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=Popomy9GSdt0n+wQr0HSUTu4uxH1zenxdXoNJL+kXDg=;
        b=pB6Y9HHJk56txshE4w5Z5+UkVry050YTvWUzBuhTgB7F7tdM5d4hU+bxGsyhKBawBh
         QNTnVqyR+Q2fjhHWRwBRxZTmoQPbYEhj4nPAvmrlpjvGlciKeaTVRwAaJvHMGY4BoqLx
         9TRP/0a2BNyZHzdCXKj5ZflNG+YKqo7bTsLHl15NjaTOS5dMGODC5499iqjOnKw+Ggq6
         adT2BppS6OmixW0mxDjcl+Mj2jw0WXAjrHWc1PVr43zrqlgyQ9g7nYGowRCnTI4qVNKg
         Vff+YhFQGadnlyAAOVonzC93ku4ZUIHRFtiUSgc40hMe/XnjjX3qGOqFChXxSlDotw9y
         bwdw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1736449921; x=1737054721;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Popomy9GSdt0n+wQr0HSUTu4uxH1zenxdXoNJL+kXDg=;
        b=FyFE/F8h0znKx22Xa2DMm37cdEgkpa2i9SuAboyfT94veKdusMlaFJ3kN/w7VfUpNc
         sYtjhPHdGDAJuquAGWzw5BRAZAW9ZRySHJeABu/myAv7lzGMPdBTYd3MJf3PKdQB/Ige
         cQ64YH3RXDiK+qn0pkEaKEtLfRzIWRYjhezrsFfWfb0qDj30xXCQEn/FMFykS0RLpgX8
         ngXwTVh/WeP6WIaIF50D8U6P+2cE5XBR37DaXAPL57OaH0ZlkGQ5Wj70B/W+OJAxddn1
         s2YVWMnu/oBVy84sxqluDVbe6d7uFFaFz5xin5r6wTfHWc2cZE5gK0o0ym+f5RqDB7hr
         CkEA==
X-Forwarded-Encrypted: i=1; AJvYcCU+SqLISJTPz+9niS8UZ+QuK1kWIj4q87WRL9k5Ztlioi1YoQgCte9vTIAVS5R5v4V/OZ4=@vger.kernel.org
X-Gm-Message-State: AOJu0YzOzQFPGzzjsbKSv2X/yNq+V3stMflK4m9q3t+Ao1t6dGWHsWWQ
	QRQRhqRJHRcMTMao8k2g2cs8AJ/EXzWLmggGXDifIZgpUSWvCinK9QbucxgnWF1h0dl9K5IXMQo
	IVA==
X-Google-Smtp-Source: AGHT+IGPwD26PC7dyY20aQizNwGfhpaz2P0l3/aBLxxPRwuQ2Loi59wllDD6C/eVWYNYTPbNrIXc50U6qNw=
X-Received: from pjbsu12.prod.google.com ([2002:a17:90b:534c:b0:2f4:3e59:8bb1])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90a:c2ce:b0:2ee:741c:e9f4
 with SMTP id 98e67ed59e1d1-2f548ebba5bmr11516750a91.11.1736449920678; Thu, 09
 Jan 2025 11:12:00 -0800 (PST)
Date: Thu, 9 Jan 2025 11:11:59 -0800
In-Reply-To: <96f7204b-6eb4-4fac-b5bb-1cd5c1fc6def@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20241121201448.36170-1-adrian.hunter@intel.com>
 <20241121201448.36170-5-adrian.hunter@intel.com> <Z0AbZWd/avwcMoyX@intel.com>
 <a42183ab-a25a-423e-9ef3-947abec20561@intel.com> <Z2GiQS_RmYeHU09L@google.com>
 <487a32e6-54cd-43b7-bfa6-945c725a313d@intel.com> <Z2WZ091z8GmGjSbC@google.com>
 <96f7204b-6eb4-4fac-b5bb-1cd5c1fc6def@intel.com>
Message-ID: <Z4Aff2QTJeOyrEUY@google.com>
Subject: Re: [PATCH 4/7] KVM: TDX: restore host xsave state when exit from the
 guest TD
From: Sean Christopherson <seanjc@google.com>
To: Adrian Hunter <adrian.hunter@intel.com>
Cc: Chao Gao <chao.gao@intel.com>, pbonzini@redhat.com, kvm@vger.kernel.org, 
	dave.hansen@linux.intel.com, rick.p.edgecombe@intel.com, kai.huang@intel.com, 
	reinette.chatre@intel.com, xiaoyao.li@intel.com, 
	tony.lindgren@linux.intel.com, binbin.wu@linux.intel.com, dmatlack@google.com, 
	isaku.yamahata@intel.com, nik.borisov@suse.com, linux-kernel@vger.kernel.org, 
	x86@kernel.org, yan.y.zhao@intel.com, weijiang.yang@intel.com
Content-Type: text/plain; charset="us-ascii"

On Fri, Jan 03, 2025, Adrian Hunter wrote:
> On 20/12/24 18:22, Sean Christopherson wrote:
> +/* Set a maximal guest CR0 value */
> +static u64 tdx_guest_cr0(struct kvm_vcpu *vcpu, u64 cr4)
> +{
> +	u64 cr0;
> +
> +	rdmsrl(MSR_IA32_VMX_CR0_FIXED1, cr0);
> +
> +	if (cr4 & X86_CR4_CET)
> +		cr0 |= X86_CR0_WP;
> +
> +	cr0 |= X86_CR0_PE | X86_CR0_NE;
> +	cr0 &= ~(X86_CR0_NW | X86_CR0_CD);
> +
> +	return cr0;
> +}
> +
> +/*
> + * Set a maximal guest CR4 value. Clear bits forbidden by XFAM or
> + * TD Attributes.
> + */
> +static u64 tdx_guest_cr4(struct kvm_vcpu *vcpu)
> +{
> +	struct kvm_tdx *kvm_tdx = to_kvm_tdx(vcpu->kvm);
> +	u64 cr4;
> +
> +	rdmsrl(MSR_IA32_VMX_CR4_FIXED1, cr4);

This won't be accurate long-term.  E.g. run KVM on hardware with CR4 bits that
neither KVM nor TDX know about, and vcpu->arch.cr4 will end up with bits set that
KVM think are illegal, which will cause it's own problems.

For CR0 and CR4, we should be able to start with KVM's set of allowed bits, not
the CPU's.  That will mean there will likely be missing bits, in vcpu->arch.cr{0,4},
but if KVM doesn't know about a bit, the fact that it's missing should be a complete
non-issue.

That also avoids weirdness for things like user-mode interrupts, LASS, PKS, etc.,
where KVM is open coding the bits.  The downside is that we'll need to remember
to update TDX when enabling those features to account for kvm_tdx->attributes,
but that's not unreasonable.

> +
> +	if (!(kvm_tdx->xfam & XFEATURE_PKRU))
> +		cr4 &= ~X86_CR4_PKE;
> +
> +	if (!(kvm_tdx->xfam & XFEATURE_CET_USER) || !(kvm_tdx->xfam & BIT_ULL(12)))
> +		cr4 &= ~X86_CR4_CET;
> +
> +	/* User Interrupts */
> +	if (!(kvm_tdx->xfam & BIT_ULL(14)))
> +		cr4 &= ~BIT_ULL(25);
> +
> +	if (!(kvm_tdx->attributes & TDX_TD_ATTR_LASS))
> +		cr4 &= ~BIT_ULL(27);
> +
> +	if (!(kvm_tdx->attributes & TDX_TD_ATTR_PKS))
> +		cr4 &= ~BIT_ULL(24);
> +
> +	if (!(kvm_tdx->attributes & TDX_TD_ATTR_KL))
> +		cr4 &= ~BIT_ULL(19);
> +
> +	cr4 &= ~X86_CR4_SMXE;
> +
> +	return cr4;
> +}
> +
>  int tdx_vcpu_create(struct kvm_vcpu *vcpu)
>  {
>  	struct kvm_tdx *kvm_tdx = to_kvm_tdx(vcpu->kvm);
> @@ -732,8 +783,8 @@ int tdx_vcpu_create(struct kvm_vcpu *vcpu)
>  	vcpu->arch.cr0_guest_owned_bits = -1ul;
>  	vcpu->arch.cr4_guest_owned_bits = -1ul;
>  
> -	vcpu->arch.cr4 = <maximal value>;
> -	vcpu->arch.cr0 = <maximal value, give or take>;
> +	vcpu->arch.cr4 = tdx_guest_cr4(vcpu);
> +	vcpu->arch.cr0 = tdx_guest_cr0(vcpu, vcpu->arch.cr4);
>  
>  	vcpu->arch.tsc_offset = kvm_tdx->tsc_offset;
>  	vcpu->arch.l1_tsc_offset = vcpu->arch.tsc_offset;
> @@ -767,6 +818,12 @@ int tdx_vcpu_create(struct kvm_vcpu *vcpu)
>  	return 0;
>  }
>  
> +void tdx_vcpu_after_set_cpuid(struct kvm_vcpu *vcpu)
> +{
> +	if (cpu_feature_enabled(X86_FEATURE_XSAVES))

This should use kvm_cpu_caps_has(), because strictly speaking it's KVM support
that matters.  In practice, I don't think it matters for XSAVES, but it can
matter for other features (though probably not for TDX guests).

> +		kvm_governed_feature_set(vcpu, X86_FEATURE_XSAVES);
> +}
> +
>  void tdx_vcpu_load(struct kvm_vcpu *vcpu, int cpu)
>  {
>  	struct vcpu_tdx *tdx = to_tdx(vcpu);
> @@ -933,6 +990,24 @@ static void tdx_user_return_msr_update_cache(void)
>  						 tdx_uret_msrs[i].defval);
>  }
>  
> +static void tdx_reinforce_guest_state(struct kvm_vcpu *vcpu)
> +{
> +	struct kvm_tdx *kvm_tdx = to_kvm_tdx(vcpu->kvm);
> +
> +	if (WARN_ON_ONCE(vcpu->arch.xcr0 != (kvm_tdx->xfam & TDX_XFAM_XCR0_MASK)))
> +		vcpu->arch.xcr0 = kvm_tdx->xfam & TDX_XFAM_XCR0_MASK;
> +	if (WARN_ON_ONCE(vcpu->arch.ia32_xss != (kvm_tdx->xfam & TDX_XFAM_XSS_MASK)))
> +		vcpu->arch.ia32_xss = kvm_tdx->xfam & TDX_XFAM_XSS_MASK;
> +	if (WARN_ON_ONCE(vcpu->arch.pkru))
> +		vcpu->arch.pkru = 0;
> +	if (WARN_ON_ONCE(cpu_feature_enabled(X86_FEATURE_XSAVE) &&
> +			 !kvm_is_cr4_bit_set(vcpu, X86_CR4_OSXSAVE)))
> +		vcpu->arch.cr4 |= X86_CR4_OSXSAVE;
> +	if (WARN_ON_ONCE(cpu_feature_enabled(X86_FEATURE_XSAVES) &&
> +			 !guest_can_use(vcpu, X86_FEATURE_XSAVES)))
> +		kvm_governed_feature_set(vcpu, X86_FEATURE_XSAVES);
> +}
> +
>  static noinstr void tdx_vcpu_enter_exit(struct kvm_vcpu *vcpu)
>  {
>  	struct vcpu_tdx *tdx = to_tdx(vcpu);
> @@ -1028,9 +1103,11 @@ fastpath_t tdx_vcpu_run(struct kvm_vcpu *vcpu, bool force_immediate_exit)
>  		update_debugctlmsr(tdx->host_debugctlmsr);
>  
>  	tdx_user_return_msr_update_cache();
> +
> +	tdx_reinforce_guest_state(vcpu);

Hmm, I don't think fixing up guest state is a good idea.  It probably works?
But continuing on when we know there's a KVM bug *and* a chance for host data
corruption seems unnecessarily risky.

My vote would to KVM_BUG_ON() before entering the guest.  I think I'd also be ok
omitting the checks, it's not like the potential for KVM bugs that clobber KVM's
view of state are unique to TDX (though I do agree that the behavior of the TDX
module in this case does make them more likely).

>  	kvm_load_host_xsave_state(vcpu);
>  
> -	vcpu->arch.regs_avail = TDX_REGS_UNSUPPORTED_SET;
> +	vcpu->arch.regs_avail = ~0;
>  
>  	if (unlikely((tdx->vp_enter_ret & TDX_SW_ERROR) == TDX_SW_ERROR))
>  		return EXIT_FASTPATH_NONE;
> diff --git a/arch/x86/kvm/vmx/tdx_arch.h b/arch/x86/kvm/vmx/tdx_arch.h
> index 861c0f649b69..2e0e300a1f5e 100644
> --- a/arch/x86/kvm/vmx/tdx_arch.h
> +++ b/arch/x86/kvm/vmx/tdx_arch.h
> @@ -110,6 +110,7 @@ struct tdx_cpuid_value {
>  } __packed;
>  
>  #define TDX_TD_ATTR_DEBUG		BIT_ULL(0)
> +#define TDX_TD_ATTR_LASS		BIT_ULL(27)
>  #define TDX_TD_ATTR_SEPT_VE_DISABLE	BIT_ULL(28)
>  #define TDX_TD_ATTR_PKS			BIT_ULL(30)
>  #define TDX_TD_ATTR_KL			BIT_ULL(31)
> diff --git a/arch/x86/kvm/vmx/x86_ops.h b/arch/x86/kvm/vmx/x86_ops.h
> index 7fb1bbf12b39..7f03a6a24abc 100644
> --- a/arch/x86/kvm/vmx/x86_ops.h
> +++ b/arch/x86/kvm/vmx/x86_ops.h
> @@ -126,6 +126,7 @@ void tdx_vm_free(struct kvm *kvm);
>  int tdx_vm_ioctl(struct kvm *kvm, void __user *argp);
>  
>  int tdx_vcpu_create(struct kvm_vcpu *vcpu);
> +void tdx_vcpu_after_set_cpuid(struct kvm_vcpu *vcpu);
>  void tdx_vcpu_free(struct kvm_vcpu *vcpu);
>  void tdx_vcpu_load(struct kvm_vcpu *vcpu, int cpu);
>  int tdx_vcpu_pre_run(struct kvm_vcpu *vcpu);
> @@ -170,6 +171,7 @@ static inline void tdx_vm_free(struct kvm *kvm) {}
>  static inline int tdx_vm_ioctl(struct kvm *kvm, void __user *argp) { return -EOPNOTSUPP; }
>  
>  static inline int tdx_vcpu_create(struct kvm_vcpu *vcpu) { return -EOPNOTSUPP; }
> +static inline void tdx_vcpu_after_set_cpuid(struct kvm_vcpu *vcpu) {}
>  static inline void tdx_vcpu_free(struct kvm_vcpu *vcpu) {}
>  static inline void tdx_vcpu_load(struct kvm_vcpu *vcpu, int cpu) {}
>  static inline int tdx_vcpu_pre_run(struct kvm_vcpu *vcpu) { return -EOPNOTSUPP; }
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index d2ea7db896ba..f2b1980f830d 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -1240,6 +1240,11 @@ static int __kvm_set_xcr(struct kvm_vcpu *vcpu, u32 index, u64 xcr)
>  	u64 old_xcr0 = vcpu->arch.xcr0;
>  	u64 valid_bits;
>  
> +	if (vcpu->arch.guest_state_protected) {

This should be a WARN_ON_ONCE() + return 1, no?

> +		kvm_update_cpuid_runtime(vcpu);
> +		return 0;
> +	}
> +
>  	/* Only support XCR_XFEATURE_ENABLED_MASK(xcr0) now  */
>  	if (index != XCR_XFEATURE_ENABLED_MASK)
>  		return 1;
> @@ -12388,7 +12393,7 @@ void kvm_vcpu_reset(struct kvm_vcpu *vcpu, bool init_event)
>  	 * into hardware, to be zeroed at vCPU creation.  Use CRs as a sentinel
>  	 * to detect improper or missing initialization.
>  	 */
> -	WARN_ON_ONCE(!init_event &&
> +	WARN_ON_ONCE(!init_event && !vcpu->arch.guest_state_protected &&
>  		     (old_cr0 || kvm_read_cr3(vcpu) || kvm_read_cr4(vcpu)));

Maybe stuff state in tdx_vcpu_init() to avoid this waiver?  KVM is already
deferring APIC base and RCX initialization to that point, waiting to stuff all
TDX-specific vCPU state seems natural.

