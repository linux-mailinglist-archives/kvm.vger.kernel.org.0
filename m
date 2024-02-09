Return-Path: <kvm+bounces-8508-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 39C7584FFF4
	for <lists+kvm@lfdr.de>; Fri,  9 Feb 2024 23:31:30 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id A72261F260AA
	for <lists+kvm@lfdr.de>; Fri,  9 Feb 2024 22:31:29 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C297838DFB;
	Fri,  9 Feb 2024 22:29:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=grsecurity.net header.i=@grsecurity.net header.b="AUdbvKRQ"
X-Original-To: kvm@vger.kernel.org
Received: from mail-ed1-f54.google.com (mail-ed1-f54.google.com [209.85.208.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C3BFB3A1C8
	for <kvm@vger.kernel.org>; Fri,  9 Feb 2024 22:29:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707517757; cv=none; b=PuPztwzDC12nDw1oeJZch6TXmx6m2v/BTuA6Eb+xUDCRBQ3EzejydICn8pbG9kORKeYCoFBWafEhiixZO8K+lX3zkzP7aecFc6X+Lj6FyCI8euw3B/HcK6JxK1stt6PPEeJ/NOJ6zxPIzZjjl+257PTqLkQDI3juGx0W/iMKfiA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707517757; c=relaxed/simple;
	bh=FZHGlsyACuhsQPOyIEMZ7BXLlXCY4/u8Btg+8W4YGNM=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=XEzBjFzlzTj8h0GQCnYCYJaiYVPl0UPv6RyOBezMG038qXW5T2/1yqbVVjqJGiry68ubKr/m44uEe5UpdcJO95drOapdy+nJAG6arW8lhcGx/pFAvlfjcSU7RHjU6h751vkFQ8ia+q+cbPT5d7zca/VaGBs6X2CeKbHMWXyXsq4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=grsecurity.net; spf=pass smtp.mailfrom=opensrcsec.com; dkim=pass (2048-bit key) header.d=grsecurity.net header.i=@grsecurity.net header.b=AUdbvKRQ; arc=none smtp.client-ip=209.85.208.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=grsecurity.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=opensrcsec.com
Received: by mail-ed1-f54.google.com with SMTP id 4fb4d7f45d1cf-556c3f0d6c5so1876920a12.2
        for <kvm@vger.kernel.org>; Fri, 09 Feb 2024 14:29:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=grsecurity.net; s=grsec; t=1707517754; x=1708122554; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:autocrypt:from:references:cc
         :to:content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=9TzCrROyhab9DGeFOYfuVnpuQbl5BW+MB3vXmiAa2aU=;
        b=AUdbvKRQij0OfUt7WxnMlSglLteSTfUXHbtfaPFnRfJRBE4rmQtCkd47N5r5b+uN1a
         9dcH7g0ICX9xXPBrlfBCY6Xh+AX9cKXfPA3tExnd9WY0FbbR6rx8cW0KUoF0Kg7y4hxv
         vrLov0cxw2mki9oN6T2Kq5XK5J7bl6UC3/PK83XrBDrRK2cndf5fJdPYenvBvwqxeVHw
         aSIX3t5XM16tx0nkcja23Z7AAdde+iOjt51LSgi5XvUOK8vz5kUW2Wj5QvN18MOwaXw3
         Dye1oWqA6nH6YTu0ibBu67bKuD5Pw1EZrLsghr8KB1TXH0mh17rwM0tDpugndQzD2rdv
         FkKQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1707517754; x=1708122554;
        h=content-transfer-encoding:in-reply-to:autocrypt:from:references:cc
         :to:content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=9TzCrROyhab9DGeFOYfuVnpuQbl5BW+MB3vXmiAa2aU=;
        b=eVmgo3SzfJTw9pFak5q0iQx920nn73mpFQPF0En+B1Rd4sYP7B1fnfNjalgQuDGvj6
         tDjzaoYEcTVT/pq4mwJif6O0Lqcs0Hl4k5MzbdT7S/LBqBo5CZIJbVt/zIKbYHLXXEqp
         d2NLI4mN9er5tAmckNz+ix9GUuR0tOUlgMMMpHecOdz5eFbVl5ix/JdPuC6WfRMsZh/R
         A/6XmEZxZDsv0K8ejuvXWSqudHOSZnCrU8SRBrCSVuVhBSQxvdPXF1GCwdkyKgRFxipF
         5C0kHSYvCN1v02cOxWHYPFizFgu6XaRhmDANml8UidpV+P06LKtgws0xWz3ts4R4BdaG
         u2OA==
X-Gm-Message-State: AOJu0YwRQMWfhwP3n9GfqH7mcVPM/Wjue5HeYHCGit/Rf+YuZcPTM8HW
	/NpJA8Fs/7pr7DVHIETyEjg82VbYg9xwRv5mSvFEdDrGMVElyx491wt6mu6vecQ=
X-Google-Smtp-Source: AGHT+IHK7UGb5Vt/nRIscXKbznM1UbwyABURtqd8H4EsETC9LNsEGpbae+CgF3O2Du2zK1uZjWFf9g==
X-Received: by 2002:a17:906:3507:b0:a3c:2294:30d3 with SMTP id r7-20020a170906350700b00a3c229430d3mr213471eja.25.1707517752039;
        Fri, 09 Feb 2024 14:29:12 -0800 (PST)
X-Forwarded-Encrypted: i=1; AJvYcCWYqI/tlvoqwdU2owiFnfUd2RAiq+aN+Ow3kA8+KuJ9GWRJtZ+OHDi2VMYQ5a9ADOhTdt0kT2viDudQEwQpr4foZ9ainKZBQC3shi9/yyYHiCGu4zsP199YcwiWn2h/emrQ
Received: from ?IPV6:2003:f6:af2c:a500:6e26:87f:cb2:6335? (p200300f6af2ca5006e26087f0cb26335.dip0.t-ipconnect.de. [2003:f6:af2c:a500:6e26:87f:cb2:6335])
        by smtp.gmail.com with ESMTPSA id go43-20020a1709070dab00b00a385535a02asm1171411ejc.171.2024.02.09.14.29.11
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 09 Feb 2024 14:29:11 -0800 (PST)
Message-ID: <0d82c2c0-759e-49aa-8041-0435a430ebed@grsecurity.net>
Date: Fri, 9 Feb 2024 23:29:11 +0100
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 1/2] KVM: x86: Make kvm_get_dr() return a value, not use
 an out parameter
Content-Language: en-US, de-DE
To: Sean Christopherson <seanjc@google.com>,
 Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20240209220752.388160-1-seanjc@google.com>
 <20240209220752.388160-2-seanjc@google.com>
From: Mathias Krause <minipli@grsecurity.net>
Autocrypt: addr=minipli@grsecurity.net; keydata=
 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
 RzDVkdgPJkL/NFTKZHo5foFXNi89kA==
In-Reply-To: <20240209220752.388160-2-seanjc@google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 09.02.24 23:07, Sean Christopherson wrote:
> Convert kvm_get_dr()'s output parameter to a return value, and clean up
> most of the mess that was created by forcing callers to provide a pointer.
> 
> No functional change intended.
> 
> Acked-by: Mathias Krause <minipli@grsecurity.net>
> Signed-off-by: Sean Christopherson <seanjc@google.com>
> ---
>  arch/x86/include/asm/kvm_host.h |  2 +-
>  arch/x86/kvm/emulate.c          | 17 ++++-------------
>  arch/x86/kvm/kvm_emulate.h      |  2 +-
>  arch/x86/kvm/smm.c              | 15 ++++-----------
>  arch/x86/kvm/svm/svm.c          |  7 ++-----
>  arch/x86/kvm/vmx/nested.c       |  2 +-
>  arch/x86/kvm/vmx/vmx.c          |  5 +----
>  arch/x86/kvm/x86.c              | 20 +++++++-------------
>  8 files changed, 21 insertions(+), 49 deletions(-)
> 
> diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
> index ad5319a503f0..464fa2197748 100644
> --- a/arch/x86/include/asm/kvm_host.h
> +++ b/arch/x86/include/asm/kvm_host.h
> @@ -2046,7 +2046,7 @@ int kvm_set_cr3(struct kvm_vcpu *vcpu, unsigned long cr3);
>  int kvm_set_cr4(struct kvm_vcpu *vcpu, unsigned long cr4);
>  int kvm_set_cr8(struct kvm_vcpu *vcpu, unsigned long cr8);
>  int kvm_set_dr(struct kvm_vcpu *vcpu, int dr, unsigned long val);
> -void kvm_get_dr(struct kvm_vcpu *vcpu, int dr, unsigned long *val);
> +unsigned long kvm_get_dr(struct kvm_vcpu *vcpu, int dr);
>  unsigned long kvm_get_cr8(struct kvm_vcpu *vcpu);
>  void kvm_lmsw(struct kvm_vcpu *vcpu, unsigned long msw);
>  int kvm_emulate_xsetbv(struct kvm_vcpu *vcpu);
> diff --git a/arch/x86/kvm/emulate.c b/arch/x86/kvm/emulate.c
> index 695ab5b6055c..33444627fcf4 100644
> --- a/arch/x86/kvm/emulate.c
> +++ b/arch/x86/kvm/emulate.c
> @@ -3011,7 +3011,7 @@ static int emulator_do_task_switch(struct x86_emulate_ctxt *ctxt,
>  		ret = em_push(ctxt);
>  	}
>  
> -	ops->get_dr(ctxt, 7, &dr7);
> +	dr7 = ops->get_dr(ctxt, 7);
>  	ops->set_dr(ctxt, 7, dr7 & ~(DR_LOCAL_ENABLE_MASK | DR_LOCAL_SLOWDOWN));
>  
>  	return ret;
> @@ -3866,15 +3866,6 @@ static int check_cr_access(struct x86_emulate_ctxt *ctxt)
>  	return X86EMUL_CONTINUE;
>  }
>  
> -static int check_dr7_gd(struct x86_emulate_ctxt *ctxt)
> -{
> -	unsigned long dr7;
> -
> -	ctxt->ops->get_dr(ctxt, 7, &dr7);
> -
> -	return dr7 & DR7_GD;
> -}
> -
>  static int check_dr_read(struct x86_emulate_ctxt *ctxt)
>  {
>  	int dr = ctxt->modrm_reg;
> @@ -3887,10 +3878,10 @@ static int check_dr_read(struct x86_emulate_ctxt *ctxt)
>  	if ((cr4 & X86_CR4_DE) && (dr == 4 || dr == 5))
>  		return emulate_ud(ctxt);
>  
> -	if (check_dr7_gd(ctxt)) {
> +	if (ctxt->ops->get_dr(ctxt, 7) & DR7_GD) {
>  		ulong dr6;
>  
> -		ctxt->ops->get_dr(ctxt, 6, &dr6);
> +		dr6 = ctxt->ops->get_dr(ctxt, 6);
>  		dr6 &= ~DR_TRAP_BITS;
>  		dr6 |= DR6_BD | DR6_ACTIVE_LOW;
>  		ctxt->ops->set_dr(ctxt, 6, dr6);
> @@ -5449,7 +5440,7 @@ int x86_emulate_insn(struct x86_emulate_ctxt *ctxt)
>  		ctxt->dst.val = ops->get_cr(ctxt, ctxt->modrm_reg);
>  		break;
>  	case 0x21: /* mov from dr to reg */
> -		ops->get_dr(ctxt, ctxt->modrm_reg, &ctxt->dst.val);
> +		ctxt->dst.val = ops->get_dr(ctxt, ctxt->modrm_reg);
>  		break;
>  	case 0x40 ... 0x4f:	/* cmov */
>  		if (test_cc(ctxt->b, ctxt->eflags))
> diff --git a/arch/x86/kvm/kvm_emulate.h b/arch/x86/kvm/kvm_emulate.h
> index 4351149484fb..5382646162a3 100644
> --- a/arch/x86/kvm/kvm_emulate.h
> +++ b/arch/x86/kvm/kvm_emulate.h
> @@ -203,7 +203,7 @@ struct x86_emulate_ops {
>  	ulong (*get_cr)(struct x86_emulate_ctxt *ctxt, int cr);
>  	int (*set_cr)(struct x86_emulate_ctxt *ctxt, int cr, ulong val);
>  	int (*cpl)(struct x86_emulate_ctxt *ctxt);
> -	void (*get_dr)(struct x86_emulate_ctxt *ctxt, int dr, ulong *dest);
> +	ulong (*get_dr)(struct x86_emulate_ctxt *ctxt, int dr);
>  	int (*set_dr)(struct x86_emulate_ctxt *ctxt, int dr, ulong value);
>  	int (*set_msr_with_filter)(struct x86_emulate_ctxt *ctxt, u32 msr_index, u64 data);
>  	int (*get_msr_with_filter)(struct x86_emulate_ctxt *ctxt, u32 msr_index, u64 *pdata);
> diff --git a/arch/x86/kvm/smm.c b/arch/x86/kvm/smm.c
> index dc3d95fdca7d..19a7a0a31953 100644
> --- a/arch/x86/kvm/smm.c
> +++ b/arch/x86/kvm/smm.c
> @@ -184,7 +184,6 @@ static void enter_smm_save_state_32(struct kvm_vcpu *vcpu,
>  				    struct kvm_smram_state_32 *smram)
>  {
>  	struct desc_ptr dt;
> -	unsigned long val;
>  	int i;
>  
>  	smram->cr0     = kvm_read_cr0(vcpu);
> @@ -195,10 +194,8 @@ static void enter_smm_save_state_32(struct kvm_vcpu *vcpu,
>  	for (i = 0; i < 8; i++)
>  		smram->gprs[i] = kvm_register_read_raw(vcpu, i);
>  
> -	kvm_get_dr(vcpu, 6, &val);
> -	smram->dr6     = (u32)val;
> -	kvm_get_dr(vcpu, 7, &val);
> -	smram->dr7     = (u32)val;
> +	smram->dr6     = (u32)kvm_get_dr(vcpu, 6);
> +	smram->dr7     = (u32)kvm_get_dr(vcpu, 7);
>  
>  	enter_smm_save_seg_32(vcpu, &smram->tr, &smram->tr_sel, VCPU_SREG_TR);
>  	enter_smm_save_seg_32(vcpu, &smram->ldtr, &smram->ldtr_sel, VCPU_SREG_LDTR);
> @@ -231,7 +228,6 @@ static void enter_smm_save_state_64(struct kvm_vcpu *vcpu,
>  				    struct kvm_smram_state_64 *smram)
>  {
>  	struct desc_ptr dt;
> -	unsigned long val;
>  	int i;
>  
>  	for (i = 0; i < 16; i++)
> @@ -240,11 +236,8 @@ static void enter_smm_save_state_64(struct kvm_vcpu *vcpu,
>  	smram->rip    = kvm_rip_read(vcpu);
>  	smram->rflags = kvm_get_rflags(vcpu);
>  
> -
> -	kvm_get_dr(vcpu, 6, &val);
> -	smram->dr6 = val;
> -	kvm_get_dr(vcpu, 7, &val);
> -	smram->dr7 = val;
> +	smram->dr6 = kvm_get_dr(vcpu, 6);
> +	smram->dr7 = kvm_get_dr(vcpu, 7);
>  
>  	smram->cr0 = kvm_read_cr0(vcpu);
>  	smram->cr3 = kvm_read_cr3(vcpu);
> diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
> index e90b429c84f1..dda91f7cd71b 100644
> --- a/arch/x86/kvm/svm/svm.c
> +++ b/arch/x86/kvm/svm/svm.c
> @@ -2735,7 +2735,6 @@ static int dr_interception(struct kvm_vcpu *vcpu)
>  {
>  	struct vcpu_svm *svm = to_svm(vcpu);
>  	int reg, dr;
> -	unsigned long val;
>  	int err = 0;
>  
>  	/*
> @@ -2763,11 +2762,9 @@ static int dr_interception(struct kvm_vcpu *vcpu)
>  	dr = svm->vmcb->control.exit_code - SVM_EXIT_READ_DR0;
>  	if (dr >= 16) { /* mov to DRn  */
>  		dr -= 16;
> -		val = kvm_register_read(vcpu, reg);
> -		err = kvm_set_dr(vcpu, dr, val);
> +		err = kvm_set_dr(vcpu, dr, kvm_register_read(vcpu, reg));
>  	} else {
> -		kvm_get_dr(vcpu, dr, &val);
> -		kvm_register_write(vcpu, reg, val);
> +		kvm_register_write(vcpu, reg, kvm_get_dr(vcpu, dr));
>  	}
>  
>  	return kvm_complete_insn_gp(vcpu, err);
> diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
> index 994e014f8a50..28d1088a1770 100644
> --- a/arch/x86/kvm/vmx/nested.c
> +++ b/arch/x86/kvm/vmx/nested.c
> @@ -4433,7 +4433,7 @@ static void sync_vmcs02_to_vmcs12(struct kvm_vcpu *vcpu, struct vmcs12 *vmcs12)
>  		(vm_entry_controls_get(to_vmx(vcpu)) & VM_ENTRY_IA32E_MODE);
>  
>  	if (vmcs12->vm_exit_controls & VM_EXIT_SAVE_DEBUG_CONTROLS)
> -		kvm_get_dr(vcpu, 7, (unsigned long *)&vmcs12->guest_dr7);
> +		vmcs12->guest_dr7 = kvm_get_dr(vcpu, 7);
>  
>  	if (vmcs12->vm_exit_controls & VM_EXIT_SAVE_IA32_EFER)
>  		vmcs12->guest_ia32_efer = vcpu->arch.efer;
> diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
> index e262bc2ba4e5..aa47433d0c9b 100644
> --- a/arch/x86/kvm/vmx/vmx.c
> +++ b/arch/x86/kvm/vmx/vmx.c
> @@ -5566,10 +5566,7 @@ static int handle_dr(struct kvm_vcpu *vcpu)
>  
>  	reg = DEBUG_REG_ACCESS_REG(exit_qualification);
>  	if (exit_qualification & TYPE_MOV_FROM_DR) {
> -		unsigned long val;
> -
> -		kvm_get_dr(vcpu, dr, &val);
> -		kvm_register_write(vcpu, reg, val);
> +		kvm_register_write(vcpu, reg, kvm_get_dr(vcpu, dr));
>  		err = 0;
>  	} else {
>  		err = kvm_set_dr(vcpu, dr, kvm_register_read(vcpu, reg));
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index b66c45e7f6f8..bfffc13f91e6 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -1399,22 +1399,19 @@ int kvm_set_dr(struct kvm_vcpu *vcpu, int dr, unsigned long val)
>  }
>  EXPORT_SYMBOL_GPL(kvm_set_dr);
>  
> -void kvm_get_dr(struct kvm_vcpu *vcpu, int dr, unsigned long *val)
> +unsigned long kvm_get_dr(struct kvm_vcpu *vcpu, int dr)
>  {
>  	size_t size = ARRAY_SIZE(vcpu->arch.db);
>  
>  	switch (dr) {
>  	case 0 ... 3:
> -		*val = vcpu->arch.db[array_index_nospec(dr, size)];
> -		break;
> +		return vcpu->arch.db[array_index_nospec(dr, size)];
>  	case 4:
>  	case 6:
> -		*val = vcpu->arch.dr6;
> -		break;
> +		return vcpu->arch.dr6;
>  	case 5:
>  	default: /* 7 */
> -		*val = vcpu->arch.dr7;
> -		break;
> +		return vcpu->arch.dr7;
>  	}
>  }
>  EXPORT_SYMBOL_GPL(kvm_get_dr);
> @@ -5505,7 +5502,6 @@ static int kvm_vcpu_ioctl_x86_set_vcpu_events(struct kvm_vcpu *vcpu,
>  static void kvm_vcpu_ioctl_x86_get_debugregs(struct kvm_vcpu *vcpu,
>  					     struct kvm_debugregs *dbgregs)
>  {
> -	unsigned long val;
>  	unsigned int i;
>  
>  	memset(dbgregs, 0, sizeof(*dbgregs));
> @@ -5514,8 +5510,7 @@ static void kvm_vcpu_ioctl_x86_get_debugregs(struct kvm_vcpu *vcpu,
>  	for (i = 0; i < ARRAY_SIZE(vcpu->arch.db); i++)
>  		dbgregs->db[i] = vcpu->arch.db[i];
>  
> -	kvm_get_dr(vcpu, 6, &val);
> -	dbgregs->dr6 = val;
> +	dbgregs->dr6 = kvm_get_dr(vcpu, 6);
>  	dbgregs->dr7 = vcpu->arch.dr7;
>  }
>  
> @@ -8169,10 +8164,9 @@ static void emulator_wbinvd(struct x86_emulate_ctxt *ctxt)
>  	kvm_emulate_wbinvd_noskip(emul_to_vcpu(ctxt));
>  }
>  
> -static void emulator_get_dr(struct x86_emulate_ctxt *ctxt, int dr,
> -			    unsigned long *dest)
> +static unsigned long emulator_get_dr(struct x86_emulate_ctxt *ctxt, int dr)
>  {
> -	kvm_get_dr(emul_to_vcpu(ctxt), dr, dest);
> +	return kvm_get_dr(emul_to_vcpu(ctxt), dr);
>  }
>  
>  static int emulator_set_dr(struct x86_emulate_ctxt *ctxt, int dr,

Reviewed-by: Mathias Krause <minipli@grsecurity.net>

