Return-Path: <kvm+bounces-65375-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 6EE7DCA8BD7
	for <lists+kvm@lfdr.de>; Fri, 05 Dec 2025 19:20:56 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 9BAC2304F670
	for <lists+kvm@lfdr.de>; Fri,  5 Dec 2025 18:20:12 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1A7C6343D76;
	Fri,  5 Dec 2025 18:20:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="OlEXwJS0"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f202.google.com (mail-pl1-f202.google.com [209.85.214.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D11DE33FE0D
	for <kvm@vger.kernel.org>; Fri,  5 Dec 2025 18:20:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764958811; cv=none; b=ncbCi3SfPGoFWAIbcE8v415ImEADeW8eSDZvlY9i+sZfZPvqYOcbSkqtxOMHIufbw/BrjDDUOieaskKMHQ6RvS18SaV4dxQ3F4mjkEBJZ7OJYPrNP0y2xFDM8SlrIdVDPTEG5cZ6h+yWpih4VtO4Fv8jq0ncnv/ARs4dNUKW/do=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764958811; c=relaxed/simple;
	bh=I+O+sUnxsnY6UL1Sl9kJ8aFF2cqrLd+a+nKZ3b6aBBA=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=k/7YfYCVA68DBKM/goqJyhXSl+a1gCQByij4WQzIRqwkXqcHEX2UDTlYuwf855xK8v1qqRqCuAbFIrjRQ+8osObZbs4X1e3VTVlSKxujnQUOrQuhjfLoEt6TVBQ16FaJhFzGd1/seRfF1aEua78CwjPGWvE3Ml4P5PsgW+70YUE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=OlEXwJS0; arc=none smtp.client-ip=209.85.214.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pl1-f202.google.com with SMTP id d9443c01a7336-297ddb3c707so21936885ad.2
        for <kvm@vger.kernel.org>; Fri, 05 Dec 2025 10:20:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1764958808; x=1765563608; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=23728gWIp0NWE+AUO+c93qDDX2Z7/eBMOa4oJsljnjI=;
        b=OlEXwJS0nfmnRzOJ0MzmzlOez5KR2xD78mgImxh/SMdyr52sJ6gbAAAtVi9K9fTk3r
         5XBq+n+FS0cj/663ZROPx+tJf7+03ie4tOwU0Hkuf7wsYNuA9xYHCAPs3sTUMyPu46Jo
         Cw6/FGcoVpKW7O/uWR/JDLgT8pBC1FasUlGhzgbhcKmWEJ3fHajgR/JYAnchMKRZM/21
         gDnOt46F33zg0nflHIrKvoAfdRA440lprb0VFsLd2oGExk/qIihP4u42ANMvL4t/XOcM
         V1FlVP2H7VdNBqlier+LX6jSx2YK/UA1tgQR/oadpgGD+1YePYGMttI2wA0Dio0uRuwA
         98bg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764958808; x=1765563608;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=23728gWIp0NWE+AUO+c93qDDX2Z7/eBMOa4oJsljnjI=;
        b=MpzmFe634eJYsu4PB+cxRjFGgliHiR5FL1VsSwGNqCx41E6yQg93ZfTSd5rkYN1gO+
         J5GYKEkap/4FXhTmkcHVzhkOVIm3DuKX9rZ1ei8rJ42sH5/0JSx6gnkej19C8CHPbAVG
         nRYcmrqwJ37dujWlztIHKCBmuZGu0Vm8UalP1iIMNZn3Fs4B7gyiyXU5/BZVQZrw1VN7
         GJwT0Q/pZUYomOYFKbVPyzy02/8LNNtZxW3Oo+pdXuCfhHxkEY0yCo16C1341OB6fiPR
         3DeyCjVNVKsBrPnYBRh4MMelCGnJ4LYOfAbXmC37g8aQo64XxvAxFwHTNeEzCMwjPxQD
         XFOg==
X-Gm-Message-State: AOJu0YwpF9xVU8l+B3A6F81jT/OyMeijoAIz9+8ZCEJlrjWJmXmXrS/B
	vQTepSvBtgYI1MFr0nK7BIUQZmlcoR5NSb6EGxTuOfrPRq0jAEf0Du5RC5yKb9s3j6uAMDe3P4G
	M03FMtA==
X-Google-Smtp-Source: AGHT+IE+obwGqLNB6BPbmeeTkYF3iGkD2a8UJvmWtbjJHKd0a6stcx7dxGR31zwzKyBgpnRgeLbQzWozADs=
X-Received: from pll21.prod.google.com ([2002:a17:902:c215:b0:29d:5afa:2d7])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:902:d48d:b0:295:99f0:6c66
 with SMTP id d9443c01a7336-29da1c8780cmr91059355ad.36.1764958808026; Fri, 05
 Dec 2025 10:20:08 -0800 (PST)
Date: Fri, 5 Dec 2025 10:20:06 -0800
In-Reply-To: <b1a294bc9ed4dae532474a5dc6c8cb6e5962de7c.1757416809.git.houwenlong.hwl@antgroup.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <cover.1757416809.git.houwenlong.hwl@antgroup.com> <b1a294bc9ed4dae532474a5dc6c8cb6e5962de7c.1757416809.git.houwenlong.hwl@antgroup.com>
Message-ID: <aTMiVoOGS6gQm9aL@google.com>
Subject: Re: [PATCH 5/7] KVM: VMX: Set 'BS' bit in pending debug exceptions
 during instruction emulation
From: Sean Christopherson <seanjc@google.com>
To: Hou Wenlong <houwenlong.hwl@antgroup.com>
Cc: kvm@vger.kernel.org, Lai Jiangshan <jiangshan.ljs@antgroup.com>, 
	Paolo Bonzini <pbonzini@redhat.com>, Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, 
	Borislav Petkov <bp@alien8.de>, Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org, 
	"H. Peter Anvin" <hpa@zytor.com>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="us-ascii"

On Wed, Sep 10, 2025, Hou Wenlong wrote:
> If 'STI' or 'MOV SS' with 'X86_EFLAGS_TF' set is emulated by the
> emulator (e.g., using the 'force emulation' prefix), the check for
> pending debug exceptions during VM entry would fail,

s/fail/VM-Fail, and please elaborate on what exactly fails.  I've had a lot (too
much) of exposure to the consistency check, but I still have to look up the details
every time.

> as #UD clears the pending debug exceptions. Therefore, set the 'BS' bit in
> such situations to make instruction emulation more robust.
> 
> Signed-off-by: Hou Wenlong <houwenlong.hwl@antgroup.com>
> ---
>  arch/x86/include/asm/kvm-x86-ops.h |  1 +
>  arch/x86/include/asm/kvm_host.h    |  1 +
>  arch/x86/kvm/vmx/main.c            |  9 +++++++++
>  arch/x86/kvm/vmx/vmx.c             | 14 +++++++++-----
>  arch/x86/kvm/vmx/x86_ops.h         |  1 +
>  arch/x86/kvm/x86.c                 |  7 +++++--
>  6 files changed, 26 insertions(+), 7 deletions(-)
> 
> diff --git a/arch/x86/include/asm/kvm-x86-ops.h b/arch/x86/include/asm/kvm-x86-ops.h
> index 18a5c3119e1a..3a0ab1683f17 100644
> --- a/arch/x86/include/asm/kvm-x86-ops.h
> +++ b/arch/x86/include/asm/kvm-x86-ops.h
> @@ -50,6 +50,7 @@ KVM_X86_OP(get_gdt)
>  KVM_X86_OP(set_gdt)
>  KVM_X86_OP(sync_dirty_debug_regs)
>  KVM_X86_OP(set_dr7)
> +KVM_X86_OP_OPTIONAL(set_pending_dbg)
>  KVM_X86_OP(cache_reg)
>  KVM_X86_OP(get_rflags)
>  KVM_X86_OP(set_rflags)
> diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
> index 0d3cc0fc27af..a36ca751ee2e 100644
> --- a/arch/x86/include/asm/kvm_host.h
> +++ b/arch/x86/include/asm/kvm_host.h
> @@ -1765,6 +1765,7 @@ struct kvm_x86_ops {
>  	void (*set_gdt)(struct kvm_vcpu *vcpu, struct desc_ptr *dt);
>  	void (*sync_dirty_debug_regs)(struct kvm_vcpu *vcpu);
>  	void (*set_dr7)(struct kvm_vcpu *vcpu, unsigned long value);
> +	void (*set_pending_dbg)(struct kvm_vcpu *vcpu);
>  	void (*cache_reg)(struct kvm_vcpu *vcpu, enum kvm_reg reg);
>  	unsigned long (*get_rflags)(struct kvm_vcpu *vcpu);
>  	void (*set_rflags)(struct kvm_vcpu *vcpu, unsigned long rflags);
> diff --git a/arch/x86/kvm/vmx/main.c b/arch/x86/kvm/vmx/main.c
> index dbab1c15b0cd..23adff73f90b 100644
> --- a/arch/x86/kvm/vmx/main.c
> +++ b/arch/x86/kvm/vmx/main.c
> @@ -465,6 +465,14 @@ static void vt_set_dr7(struct kvm_vcpu *vcpu, unsigned long val)
>  	vmx_set_dr7(vcpu, val);
>  }
>  
> +static void vt_set_pending_dbg(struct kvm_vcpu *vcpu)
> +{
> +	if (is_td_vcpu(vcpu))

WARN_ON_ONCE()?

> +		return;
> +
> +	vmx_set_pending_dbg(vcpu);
> +}
> +
>  static void vt_sync_dirty_debug_regs(struct kvm_vcpu *vcpu)
>  {
>  	/*
> @@ -906,6 +914,7 @@ struct kvm_x86_ops vt_x86_ops __initdata = {
>  	.get_gdt = vt_op(get_gdt),
>  	.set_gdt = vt_op(set_gdt),
>  	.set_dr7 = vt_op(set_dr7),
> +	.set_pending_dbg = vt_op(set_pending_dbg),
>  	.sync_dirty_debug_regs = vt_op(sync_dirty_debug_regs),
>  	.cache_reg = vt_op(cache_reg),
>  	.get_rflags = vt_op(get_rflags),
> diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
> index 227b45430ad8..e861a0edb3f4 100644
> --- a/arch/x86/kvm/vmx/vmx.c
> +++ b/arch/x86/kvm/vmx/vmx.c
> @@ -5243,11 +5243,7 @@ static int handle_exception_nmi(struct kvm_vcpu *vcpu)
>  			 */
>  			if (is_icebp(intr_info))
>  				WARN_ON(!skip_emulated_instruction(vcpu));
> -			else if ((vmx_get_rflags(vcpu) & X86_EFLAGS_TF) &&
> -				 (vmcs_read32(GUEST_INTERRUPTIBILITY_INFO) &
> -				  (GUEST_INTR_STATE_STI | GUEST_INTR_STATE_MOV_SS)))
> -				vmcs_writel(GUEST_PENDING_DBG_EXCEPTIONS,
> -					    vmcs_readl(GUEST_PENDING_DBG_EXCEPTIONS) | DR6_BS);
> +			vmx_set_pending_dbg(vcpu);

This looks wrong.  Per Table 19-2. Debug Exception Conditions, INT1 doesn't
set DR6.BS.  Oooh, the helper is _conditionally_ setting DR6_BS.  But that still
_looks_ wrong, and it makes the comment confusing.

>  
>  			kvm_queue_exception_p(vcpu, DB_VECTOR, dr6);
>  			return 1;
> @@ -5554,6 +5550,14 @@ void vmx_set_dr7(struct kvm_vcpu *vcpu, unsigned long val)
>  	vmcs_writel(GUEST_DR7, val);
>  }
>  
> +void vmx_set_pending_dbg(struct kvm_vcpu *vcpu)

Related to above, this is a confusing name.  In no small part because of the rather
insane complexity related to pending debug exceptions being visible to software
via the VMCS.  E.g. I initially read this as "set a pending #DB", not "set the
VMCS field with the same name based on RFLAGS.TF and whether or not the vCPU is
in an interrupt shadow".

Maybe refresh_pending_dbg_excpetions()?  And then the above case would be:

			if (is_icebp(intr_info))
				WARN_ON(!skip_emulated_instruction(vcpu));
			else
				vmx_refresh_pending_dbg_exceptions(vcpu);

> +{
> +	if ((vmx_get_rflags(vcpu) & X86_EFLAGS_TF) &&
> +	    vmx_get_interrupt_shadow(vcpu))
> +		vmcs_writel(GUEST_PENDING_DBG_EXCEPTIONS,
> +			    vmcs_readl(GUEST_PENDING_DBG_EXCEPTIONS) | DR6_BS);
> +}
> +
>  static int handle_tpr_below_threshold(struct kvm_vcpu *vcpu)
>  {
>  	kvm_apic_update_ppr(vcpu);
> diff --git a/arch/x86/kvm/vmx/x86_ops.h b/arch/x86/kvm/vmx/x86_ops.h
> index 2b3424f638db..2913648cfe4f 100644
> --- a/arch/x86/kvm/vmx/x86_ops.h
> +++ b/arch/x86/kvm/vmx/x86_ops.h
> @@ -75,6 +75,7 @@ void vmx_get_gdt(struct kvm_vcpu *vcpu, struct desc_ptr *dt);
>  void vmx_set_gdt(struct kvm_vcpu *vcpu, struct desc_ptr *dt);
>  void vmx_set_dr6(struct kvm_vcpu *vcpu, unsigned long val);
>  void vmx_set_dr7(struct kvm_vcpu *vcpu, unsigned long val);
> +void vmx_set_pending_dbg(struct kvm_vcpu *vcpu);
>  void vmx_sync_dirty_debug_regs(struct kvm_vcpu *vcpu);
>  void vmx_cache_reg(struct kvm_vcpu *vcpu, enum kvm_reg reg);
>  unsigned long vmx_get_rflags(struct kvm_vcpu *vcpu);
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index 83960214d5d8..464e9649cb54 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -9250,10 +9250,13 @@ int x86_emulate_instruction(struct kvm_vcpu *vcpu, gpa_t cr2_or_gpa,
>  			if (ctxt->is_branch)
>  				kvm_pmu_branch_retired(vcpu);
>  			kvm_rip_write(vcpu, ctxt->eip);
> -			if (r && (ctxt->tf || (vcpu->guest_debug & KVM_GUESTDBG_SINGLESTEP)))
> +			__kvm_set_rflags(vcpu, ctxt->eflags);
> +			if (r && (ctxt->tf || (vcpu->guest_debug & KVM_GUESTDBG_SINGLESTEP))) {
>  				r = kvm_vcpu_do_singlestep(vcpu);
> +				if (r)
> +					kvm_x86_call(set_pending_dbg)(vcpu);

Why not handle this in kvm_vcpu_do_singlestep()?  Ah, because the call from
kvm_skip_emulated_instruction() can never occur in an interrupt shadow.  But
that's a _really_ subtle detail, and more imporantly the call is benign in that
case.

So unless there's a good reason to do otherwise, I vote to move the call into
kvm_vcpu_do_singlestep().

> +			}
>  			kvm_x86_call(update_emulated_instruction)(vcpu);
> -			__kvm_set_rflags(vcpu, ctxt->eflags);

Please move the relocation of the call to __kvm_set_rflags() to its own patch.
I vaguely recall running into problems related to the state of RFLAGS in the
emulator versus those in the vCPU.  I don't _think_ there's a problem here, but
if there is, I want the change to be fully isolated.

>  		}
>  
>  		/*
> -- 
> 2.31.1
> 

