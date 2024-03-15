Return-Path: <kvm+bounces-11921-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id B4EF787D2B8
	for <lists+kvm@lfdr.de>; Fri, 15 Mar 2024 18:26:43 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 4B479283AAD
	for <lists+kvm@lfdr.de>; Fri, 15 Mar 2024 17:26:42 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F0757482F4;
	Fri, 15 Mar 2024 17:26:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="eJLiuupd"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f202.google.com (mail-pf1-f202.google.com [209.85.210.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A4B9B3B18C
	for <kvm@vger.kernel.org>; Fri, 15 Mar 2024 17:26:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710523594; cv=none; b=Or1RML/CnoTyTanh9cQi0aotLtDrzV3BJdWpw9l8dHBIzuXGEzwbAfMON+CMxEZCNgRQXgYcjdkgAxSHnLQYqzbouMfKcgANj72kSfOsCMLoXUtWIEEGVxlab/e8wqxz1GOd7a96V0KOgl3cipYg37IqsSPiOgr32+Y7+mTq9Ow=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710523594; c=relaxed/simple;
	bh=8+iEamvYNnnhpAwMYtEnj73QOL5hzW4CCiMAPDnH9Yo=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=RkpdckMWSS6iT8ZvGivUMNAtfcDTCLKXHO9FRL3xbhSH9lXYVQkRkLHJZfGOmVAejgxNjAPUX7sJM+DmhKZNV3EZdvigePVxnUbsFclwMmcubQpHmC1yl5nlyxAqzDARxatdBG7J1FPUKTDan8t6mIUzjr5E7Ugyn3ZHQCf+iC0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=eJLiuupd; arc=none smtp.client-ip=209.85.210.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pf1-f202.google.com with SMTP id d2e1a72fcca58-6e6edde53cfso1315346b3a.0
        for <kvm@vger.kernel.org>; Fri, 15 Mar 2024 10:26:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1710523592; x=1711128392; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=SBPud4Qyt0c6+W4f+FotFxIkibCaGt2ovKebQi1WSxI=;
        b=eJLiuupdk9NiAkiUN7nohpdfgxViM6iewe9RuyZJKHClUqWSBf6H2zON+DqJSB1oK2
         sfRcH0DF9cze8sY/phWI+qZd9TBav5OvQukWtY8HLWqG+Dn/hDDPZO2TNMXADnw0D1+J
         NBhBimJihPZNTpTOGOv/gT/AnoSkwbj8MTNlxXAyESiJpWD3f9GZUhi+BtF4f8AqnsaC
         WfAa6+dH1VRjeQaVVc7OlQmtpbYRu/xK/CMqF0g9BPnSVZTkb40pdnGwVGdtSb2IH1Lv
         A+V0KkiIbWB/+aAHjvLe2jSuVZ8W0Lxh2A4/ZvRs2RA1OXcQKPnnY0zp6JeJu+h5puIT
         M8wg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1710523592; x=1711128392;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=SBPud4Qyt0c6+W4f+FotFxIkibCaGt2ovKebQi1WSxI=;
        b=AT5cVbHdvveHbFk+P/J7mOZLazPYXdtSwl17B7Xg2qnCwppHF6xGaXRM6yvggLDAfG
         EIn7WTG5c2VtJxhelFd0uzI/3Kiq2fBqC6OD7na9pyRupiFc7oXw7gxhUrYHdbf7KVVr
         wr2rVKe3VO3JIE0TkudGyKrDi+DHUwQc1g5vNqH/Y7q+iIG9XxYyvb8hc2mapnlnlioT
         lxmulivTIfcyu7lFdk9hMtzlWDR+fi6oKyJe00b6gKdbTgZpYfL9YW0oIiOyK6o0R9WZ
         z1dP/eB3A1Js1SrDEnWGFkWe6ZKKtKNRjOZh3S7tS+bhzI1P3vO3b+6q6alf64DUPMlr
         cvoA==
X-Gm-Message-State: AOJu0Yz3y3uxHFnkslyfwz4qpGF3UofK2hbut/mrZztfXmyMyPG6xwr8
	NbyNqokh2TlxKVR8uKD9vcmdpz45yTrJEneV7Z2uzlOf954x6sBCYQEgT3SjVeIarfawbjvqQnp
	58w==
X-Google-Smtp-Source: AGHT+IGoF3GpjQW71lpjD5bgySALm0aszQEi6sZCjZGA77NimyDJoIgOSWabefxIH0uquY+9NJsNKNN47Xw=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a05:6a00:3d15:b0:6e6:97c8:4ea2 with SMTP id
 lo21-20020a056a003d1500b006e697c84ea2mr205752pfb.0.1710523591938; Fri, 15 Mar
 2024 10:26:31 -0700 (PDT)
Date: Fri, 15 Mar 2024 10:26:30 -0700
In-Reply-To: <dbaa6b1a6c4ebb1400be5f7099b4b9e3b54431bb.1708933498.git.isaku.yamahata@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <cover.1708933498.git.isaku.yamahata@intel.com> <dbaa6b1a6c4ebb1400be5f7099b4b9e3b54431bb.1708933498.git.isaku.yamahata@intel.com>
Message-ID: <ZfSExlemFMKjBtZb@google.com>
Subject: Re: [PATCH v19 078/130] KVM: TDX: Implement TDX vcpu enter/exit path
From: Sean Christopherson <seanjc@google.com>
To: isaku.yamahata@intel.com
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	isaku.yamahata@gmail.com, Paolo Bonzini <pbonzini@redhat.com>, erdemaktas@google.com, 
	Sagi Shahar <sagis@google.com>, Kai Huang <kai.huang@intel.com>, chen.bo@intel.com, 
	hang.yuan@intel.com, tina.zhang@intel.com
Content-Type: text/plain; charset="us-ascii"

On Mon, Feb 26, 2024, isaku.yamahata@intel.com wrote:
> +static noinstr void tdx_vcpu_enter_exit(struct vcpu_tdx *tdx)
> +{
> +	struct tdx_module_args args;
> +
> +	/*
> +	 * Avoid section mismatch with to_tdx() with KVM_VM_BUG().  The caller
> +	 * should call to_tdx().

C'mon.  I don't think it's unreasonable to expect that at least one of the many
people working on TDX would figure out why to_vmx() is __always_inline.

> +	 */
> +	struct kvm_vcpu *vcpu = &tdx->vcpu;
> +
> +	guest_state_enter_irqoff();
> +
> +	/*
> +	 * TODO: optimization:
> +	 * - Eliminate copy between args and vcpu->arch.regs.
> +	 * - copyin/copyout registers only if (tdx->tdvmvall.regs_mask != 0)
> +	 *   which means TDG.VP.VMCALL.
> +	 */
> +	args = (struct tdx_module_args) {
> +		.rcx = tdx->tdvpr_pa,
> +#define REG(reg, REG)	.reg = vcpu->arch.regs[VCPU_REGS_ ## REG]

Organizing tdx_module_args's registers by volatile vs. non-volatile is asinine.
This code should not need to exist.

> +	WARN_ON_ONCE(!kvm_rebooting &&
> +		     (tdx->exit_reason.full & TDX_SW_ERROR) == TDX_SW_ERROR);
> +
> +	guest_state_exit_irqoff();
> +}
> +
> +fastpath_t tdx_vcpu_run(struct kvm_vcpu *vcpu)
> +{
> +	struct vcpu_tdx *tdx = to_tdx(vcpu);
> +
> +	if (unlikely(!tdx->initialized))
> +		return -EINVAL;
> +	if (unlikely(vcpu->kvm->vm_bugged)) {
> +		tdx->exit_reason.full = TDX_NON_RECOVERABLE_VCPU;
> +		return EXIT_FASTPATH_NONE;
> +	}
> +
> +	trace_kvm_entry(vcpu);
> +
> +	tdx_vcpu_enter_exit(tdx);
> +
> +	vcpu->arch.regs_avail &= ~VMX_REGS_LAZY_LOAD_SET;
> +	trace_kvm_exit(vcpu, KVM_ISA_VMX);
> +
> +	return EXIT_FASTPATH_NONE;
> +}
> +
>  void tdx_load_mmu_pgd(struct kvm_vcpu *vcpu, hpa_t root_hpa, int pgd_level)
>  {
>  	WARN_ON_ONCE(root_hpa & ~PAGE_MASK);
> diff --git a/arch/x86/kvm/vmx/tdx.h b/arch/x86/kvm/vmx/tdx.h
> index d822e790e3e5..81d301fbe638 100644
> --- a/arch/x86/kvm/vmx/tdx.h
> +++ b/arch/x86/kvm/vmx/tdx.h
> @@ -27,6 +27,37 @@ struct kvm_tdx {
>  	struct page *source_page;
>  };
>  
> +union tdx_exit_reason {
> +	struct {
> +		/* 31:0 mirror the VMX Exit Reason format */

Then use "union vmx_exit_reason", having to maintain duplicate copies of the same
union is not something I want to do.

I'm honestly not even convinced that "union tdx_exit_reason" needs to exist.  I
added vmx_exit_reason because we kept having bugs where KVM would fail to strip
bits 31:16, and because nested VMX needs to stuff failed_vmentry, but I don't
see a similar need for TDX.

I would even go so far as to say the vcpu_tdx field shouldn't be exit_reason,
and instead should be "return_code" or something.  E.g. if the TDX module refuses
to run the vCPU, there's no VM-Enter and thus no VM-Exit (unless you count the
SEAMCALL itself, har har).  Ditto for #GP or #UD on the SEAMCALL (or any other
reason that generates TDX_SW_ERROR).

Ugh, I'm doubling down on that suggesting.  This:

	WARN_ON_ONCE(!kvm_rebooting &&
		     (tdx->vp_enter_ret & TDX_SW_ERROR) == TDX_SW_ERROR);

	if ((u16)tdx->exit_reason.basic == EXIT_REASON_EXCEPTION_NMI &&
	    is_nmi(tdexit_intr_info(vcpu))) {
		kvm_before_interrupt(vcpu, KVM_HANDLING_NMI);
		vmx_do_nmi_irqoff();
		kvm_after_interrupt(vcpu);
	}

is heinous.  If there's an error that leaves bits 15:0 zero, KVM will synthesize
a spurious NMI.  I don't know whether or not that can happen, but it's not
something that should even be possible in KVM, i.e. the exit reason should be
processed if and only if KVM *knows* there was a sane VM-Exit from non-root mode.

tdx_vcpu_run() has a similar issue, though it's probably benign.  If there's an
error in bits 15:0 that happens to collide with EXIT_REASON_TDCALL, weird things
will happen.

	if (tdx->exit_reason.basic == EXIT_REASON_TDCALL)
		tdx->tdvmcall.rcx = vcpu->arch.regs[VCPU_REGS_RCX];
	else
		tdx->tdvmcall.rcx = 0;

I vote for something like the below, with much more robust checking of vp_enter_ret
before it's converted to a VMX exit reason.

static __always_inline union vmx_exit_reason tdexit_exit_reason(struct kvm_vcpu *vcpu)
{
	return (u32)vcpu->vp_enter_ret;
}

diff --git a/arch/x86/kvm/vmx/tdx.h b/arch/x86/kvm/vmx/tdx.h
index af3a2b8afee8..b9b40b2eaccb 100644
--- a/arch/x86/kvm/vmx/tdx.h
+++ b/arch/x86/kvm/vmx/tdx.h
@@ -43,37 +43,6 @@ struct kvm_tdx {
        struct page *source_page;
 };
 
-union tdx_exit_reason {
-       struct {
-               /* 31:0 mirror the VMX Exit Reason format */
-               u64 basic               : 16;
-               u64 reserved16          : 1;
-               u64 reserved17          : 1;
-               u64 reserved18          : 1;
-               u64 reserved19          : 1;
-               u64 reserved20          : 1;
-               u64 reserved21          : 1;
-               u64 reserved22          : 1;
-               u64 reserved23          : 1;
-               u64 reserved24          : 1;
-               u64 reserved25          : 1;
-               u64 bus_lock_detected   : 1;
-               u64 enclave_mode        : 1;
-               u64 smi_pending_mtf     : 1;
-               u64 smi_from_vmx_root   : 1;
-               u64 reserved30          : 1;
-               u64 failed_vmentry      : 1;
-
-               /* 63:32 are TDX specific */
-               u64 details_l1          : 8;
-               u64 class               : 8;
-               u64 reserved61_48       : 14;
-               u64 non_recoverable     : 1;
-               u64 error               : 1;
-       };
-       u64 full;
-};
-
 struct vcpu_tdx {
        struct kvm_vcpu vcpu;
 
@@ -103,7 +72,8 @@ struct vcpu_tdx {
                };
                u64 rcx;
        } tdvmcall;
-       union tdx_exit_reason exit_reason;
+
+       u64 vp_enter_ret;
 
        bool initialized;
 


