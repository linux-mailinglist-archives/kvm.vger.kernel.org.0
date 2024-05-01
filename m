Return-Path: <kvm+bounces-16379-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 04B068B91C1
	for <lists+kvm@lfdr.de>; Thu,  2 May 2024 00:50:23 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 0CAE91C211A6
	for <lists+kvm@lfdr.de>; Wed,  1 May 2024 22:50:22 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B4E78165FA1;
	Wed,  1 May 2024 22:50:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="kRUKb/kc"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yb1-f201.google.com (mail-yb1-f201.google.com [209.85.219.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7F9CB4E1DA
	for <kvm@vger.kernel.org>; Wed,  1 May 2024 22:50:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714603815; cv=none; b=bo+K8fPKk3PZ2K5Yg/CjQqPInji65EeFNDG+ZHCoMCMjHBkkuZQctS0e8vNujfHeZYWimit73wgUe72lU0oYwEJ7QO+BtqtZhZ3U1wxfctzf8ZQybIM9Xqdi36V3gDDbkk2NCsVfBTyDtjScuYKJ6eo1gYkUQEw6KAj7MExZrDA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714603815; c=relaxed/simple;
	bh=YNNf0XLM+4ChwsAjeHwf7iXcDfwaWcrjgejEJs7VaII=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=NTWDOysGb3ayhUwwOOiHaoi8p215xfaHF37YRFeU2uDZktjyr+gG/Gbd5lE80nl1SZsj82yt3bfJswmXs8vC3lpVxSf2Q2mYXufaLAlRwCG+Yp8SmLpwYiwMnhifYfdDVDwOrWE2x6Jlhxj/bd7J0iel7ZY7b6QvtWuqxstCncE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=kRUKb/kc; arc=none smtp.client-ip=209.85.219.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-yb1-f201.google.com with SMTP id 3f1490d57ef6-dc6b26783b4so10661623276.0
        for <kvm@vger.kernel.org>; Wed, 01 May 2024 15:50:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1714603813; x=1715208613; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=1P/Mv3chyaRaiyKE52xANGAdVdVRLjPvU/jVzwzR+Xg=;
        b=kRUKb/kcIS6ExXDqVIfmC8J5dFc9ZnH2bTKtfdDklUQFp8+UZrkhyAQBUW6I8pIjDK
         iGnSUY91tdSuEwsfELYmKwtjEQ3mB1q35MRLjedsHzvB/s88mgBiHYS7ikBTr7/g6bXo
         BgBtyYwsDbuVSw7y4vNzB0GdyCJSDrLv4zJ41/bYhxAU/UUtASo+/RMLjDIAAzzQvgts
         q/eIE8tRHExiVHo59CPgzKoyxtLK8ZvmpfJhhL4Gmsyqy4kx44c99MlO69NHFvGOJhrn
         b6pCCcDcpVSr0cUvymVl6qBDtzOAFT5SVdPRiS5JuuLB/H0Gukvs6zj08gooMu9tc6u+
         JcMw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1714603813; x=1715208613;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=1P/Mv3chyaRaiyKE52xANGAdVdVRLjPvU/jVzwzR+Xg=;
        b=nMiAiLLvlGsxeol7AAGyMos+YKOtxoKEeln+js/bWss1MfjGnFwYsZSvaxHduR8cQu
         bJ4UJdayegRc58O/jzEs56baIl0V/ADQxU+6p9fraj/4tGjknCA698tQCPRmL9ecRcTh
         lROrlr6UEkGmP4tQRAkcU92V/Zm5ErE95Pk012h+tdU1DHdvI44uViQ9r7i+cEOU3ZDg
         T/onruTqSKiBFOO6HIKLMSdUdQ8be/vt2eYCdPM2x+FmljOz8aFKxOKvokBHPjYAlYSK
         YNC1sla4xs6G1m0lsGyTW92NtCu0161kaJ0IRIICxRzEMIpXDsMK6H9/c+1ACnktWYiz
         3Xfw==
X-Forwarded-Encrypted: i=1; AJvYcCUtX8zLeFNObd/cdJnLWdib/kYX3CpH5YhXxO+K4Rnj1lezN1Unbvtrp10Dges1iP4grj9a9wCmWqt1r8MH45D0n9Bg
X-Gm-Message-State: AOJu0Yy92mNqgfECFPxpukHe12vA2tsmVQ0jtlTVPt9AJBU+TxIVnCef
	yJf6S+/CV5EE3PZIMEkVXuHdhMOPWYvZKVoer6GwiRUkkkuJunOnEQcimIoFEDAG5ELY8pp1MgE
	AhA==
X-Google-Smtp-Source: AGHT+IGGSDrCekYrtHmH/SUMWADT9s1mekgVLLzvXNmpTp7v+CLKPhTEfnQLviQEEbNCoM8euzGOr0ZzVnQ=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a05:6902:1243:b0:dc6:b813:5813 with SMTP id
 t3-20020a056902124300b00dc6b8135813mr321284ybu.9.1714603813461; Wed, 01 May
 2024 15:50:13 -0700 (PDT)
Date: Wed, 1 May 2024 15:50:11 -0700
In-Reply-To: <20240219074733.122080-22-weijiang.yang@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240219074733.122080-1-weijiang.yang@intel.com> <20240219074733.122080-22-weijiang.yang@intel.com>
Message-ID: <ZjLHIwCsLoatrxQ4@google.com>
Subject: Re: [PATCH v10 21/27] KVM: x86: Save and reload SSP to/from SMRAM
From: Sean Christopherson <seanjc@google.com>
To: Yang Weijiang <weijiang.yang@intel.com>
Cc: pbonzini@redhat.com, dave.hansen@intel.com, x86@kernel.org, 
	kvm@vger.kernel.org, linux-kernel@vger.kernel.org, peterz@infradead.org, 
	chao.gao@intel.com, rick.p.edgecombe@intel.com, mlevitsk@redhat.com, 
	john.allen@amd.com
Content-Type: text/plain; charset="us-ascii"

On Sun, Feb 18, 2024, Yang Weijiang wrote:
> Save CET SSP to SMRAM on SMI and reload it on RSM. KVM emulates HW arch
> behavior when guest enters/leaves SMM mode,i.e., save registers to SMRAM
> at the entry of SMM and reload them at the exit to SMM. Per SDM, SSP is
> one of such registers on 64-bit Arch, and add the support for SSP. Note,
> on 32-bit Arch, SSP is not defined in SMRAM, so fail 32-bit CET guest
> launch.
> 
> Suggested-by: Sean Christopherson <seanjc@google.com>
> Signed-off-by: Yang Weijiang <weijiang.yang@intel.com>
> Reviewed-by: Maxim Levitsky <mlevitsk@redhat.com>
> ---
>  arch/x86/kvm/cpuid.c | 11 +++++++++++
>  arch/x86/kvm/smm.c   |  8 ++++++++
>  arch/x86/kvm/smm.h   |  2 +-
>  3 files changed, 20 insertions(+), 1 deletion(-)
> 
> diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
> index 2bb1931103ad..c0e13040e35b 100644
> --- a/arch/x86/kvm/cpuid.c
> +++ b/arch/x86/kvm/cpuid.c
> @@ -149,6 +149,17 @@ static int kvm_check_cpuid(struct kvm_vcpu *vcpu,
>  		if (vaddr_bits != 48 && vaddr_bits != 57 && vaddr_bits != 0)
>  			return -EINVAL;
>  	}
> +	/*
> +	 * Prevent 32-bit guest launch if shadow stack is exposed as SSP
> +	 * state is not defined for 32-bit SMRAM.

Why?  Lack of save/restore for SSP on 32-bit guests is a gap in Intel's
architecture, I don't see why KVM should diverge from hardware.  I.e. just do
nothing for SSP on SMI/RSM, because that's exactly what the architecture says
will happen.

> +	 */
> +	best = cpuid_entry2_find(entries, nent, 0x80000001,
> +				 KVM_CPUID_INDEX_NOT_SIGNIFICANT);
> +	if (best && !(best->edx & F(LM))) {
> +		best = cpuid_entry2_find(entries, nent, 0x7, 0);
> +		if (best && (best->ecx & F(SHSTK)))
> +			return -EINVAL;
> +	}
>  
>  	/*
>  	 * Exposing dynamic xfeatures to the guest requires additional
> diff --git a/arch/x86/kvm/smm.c b/arch/x86/kvm/smm.c
> index 45c855389ea7..7aac9c54c353 100644
> --- a/arch/x86/kvm/smm.c
> +++ b/arch/x86/kvm/smm.c
> @@ -275,6 +275,10 @@ static void enter_smm_save_state_64(struct kvm_vcpu *vcpu,
>  	enter_smm_save_seg_64(vcpu, &smram->gs, VCPU_SREG_GS);
>  
>  	smram->int_shadow = static_call(kvm_x86_get_interrupt_shadow)(vcpu);
> +
> +	if (guest_can_use(vcpu, X86_FEATURE_SHSTK))
> +		KVM_BUG_ON(kvm_msr_read(vcpu, MSR_KVM_SSP, &smram->ssp),
> +			   vcpu->kvm);
>  }
>  #endif
>  
> @@ -564,6 +568,10 @@ static int rsm_load_state_64(struct x86_emulate_ctxt *ctxt,
>  	static_call(kvm_x86_set_interrupt_shadow)(vcpu, 0);
>  	ctxt->interruptibility = (u8)smstate->int_shadow;
>  
> +	if (guest_can_use(vcpu, X86_FEATURE_SHSTK))
> +		KVM_BUG_ON(kvm_msr_write(vcpu, MSR_KVM_SSP, smstate->ssp),
> +			   vcpu->kvm);


This should synthesize triple-fault, not WARN and kill the VM, as the value to
be restored is guest controlled (the guest can scribble SMRAM from within the
SMI handler).

At that point, I would just synthesize triple-fault for the read path too.

