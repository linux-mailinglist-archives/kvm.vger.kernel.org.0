Return-Path: <kvm+bounces-65554-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id D18D2CB088D
	for <lists+kvm@lfdr.de>; Tue, 09 Dec 2025 17:20:04 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 9832A30D5CEA
	for <lists+kvm@lfdr.de>; Tue,  9 Dec 2025 16:19:08 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2B9652FFF9C;
	Tue,  9 Dec 2025 16:19:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="cxN7L8G+"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f202.google.com (mail-pl1-f202.google.com [209.85.214.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 03F6E2836A0
	for <kvm@vger.kernel.org>; Tue,  9 Dec 2025 16:19:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765297147; cv=none; b=QlM7hoUlX4bdM8uFvTwAgpl2P10WtyIok7Dn1xpKZLg+oymsuJENCWVMJhodq5fFGOwjMRgym9qr3JgfguHBCfpN3Gm64iDL596OjGD9aAtbWR5KIuWAtXZYlaqIZB/0Nq0TF/3KUFQM4cyjszubZSfaMjF8FFZpDgpyyi1HB3o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765297147; c=relaxed/simple;
	bh=n1TdUlUaJoG+8+9Rf73ARYAWwSqIqINVR7HkoZPvz/c=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=lnTV722GPbhCSBac6PaXwag/qepSEI612E4vNoxnqL/IEImEjUKK7ti14u2zGWr4Eg0nbdP+5fChw7VCrHIHZSTWVHQ7KTlh+aLGfuFLtlc1xFmWjbZ5wH3oyaalHHd/H7px5hXaP8Y0jfaWMOXAF1CpJvPYDllpkBWTuCDDREU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=cxN7L8G+; arc=none smtp.client-ip=209.85.214.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pl1-f202.google.com with SMTP id d9443c01a7336-29da1ea0b97so123868845ad.3
        for <kvm@vger.kernel.org>; Tue, 09 Dec 2025 08:19:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1765297144; x=1765901944; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=f9wEPIjH7JZDSHyB1bVbcJDdzSZl/HAok3LhsrD9Sj4=;
        b=cxN7L8G+bgXvkraJbiYw0M0VQ8PK228mavOR6H2V76mKjJlezPGnvMUdEKUQaZVRkk
         NoJ0PWeIQj2AiP92JAuhDZz36V4LtJesqKdtNYNZRcteNdz31l8G9tUR8r6NLEBRT4D+
         xqNNfxjedQw2pDD6knCHmGvL8txJCRaode17kJGHxxZmWXAa7BTdqZC5HFpqm0nnegZe
         cbgCxKAogMkFdqJjXIeAFkShGP9bjpDR6WGmLQ05MXjX8O1Ov5LlWuZf3p6iW7NSqZPo
         i5yJoUatRhXNXA8K7FnxDJphYQZZI1H0MxNQcdIKa324XsY9qzy23j7znqlR/Xhhm3oa
         4qlw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1765297144; x=1765901944;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=f9wEPIjH7JZDSHyB1bVbcJDdzSZl/HAok3LhsrD9Sj4=;
        b=EFwbER6+/L8WFqaMMjHfmIeGsPPvleqHKIvE6OGYDOJiAtFcP0OBl5XcC0PaZqPzCJ
         rDL8Hfk2nMfESS+kNmwPwXxTuB0XjFAWxkYwtr9XaZT1FmlfH0mkdM4Cma1JsrYdeUxc
         14hU7EDFpgunoTHtiNENsmsdOGP37Sc0cGE/sPGLEQDGRBh4U0es8Ah0cMZByjoogp3y
         rECLfcWZTXDXhPMd1lkg21V0Du4YMS0dq0Yx2Fmj1rBcVCLONOdNU4fj2aP48nBhOq9c
         1baZ2qahUBx56+Ixpzc7tBw4NBFpOT+FdN8zwBQA9Q17fszfCBAsohhCDHYsKv9tU3CR
         TOUQ==
X-Forwarded-Encrypted: i=1; AJvYcCWmXKKcsw2MEhiKm+/w0lDAaTr0+8MfS27cexlSCXJzuEpsqY9ke85CEhrEqkwLFgzKRWk=@vger.kernel.org
X-Gm-Message-State: AOJu0YzdPPoy4smbGlxcn8DoBNau7Y9OS40BLzPgTRMu42USBdcXnuQS
	9KX0vh6k8dUCXyIA9uVLjBH2aVbPTsT+EfYtDF84biJIhOddwHfdSqFcFmkFyQw/SNNC0mmShYE
	gCxRpdg==
X-Google-Smtp-Source: AGHT+IG4I96+WQNqi+k/OHbtsbmp95n+wAAGMKYEQMdMjqkusqMcJ6tCd3x0EEEH9Ux8W5YwXs6dKH7vTHc=
X-Received: from pldp13.prod.google.com ([2002:a17:902:eacd:b0:29d:83c9:8bd1])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:902:e80a:b0:295:3eb5:6de1
 with SMTP id d9443c01a7336-29df8710342mr131157765ad.34.1765297144214; Tue, 09
 Dec 2025 08:19:04 -0800 (PST)
Date: Tue, 9 Dec 2025 08:19:02 -0800
In-Reply-To: <20251110222922.613224-13-yosry.ahmed@linux.dev>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20251110222922.613224-1-yosry.ahmed@linux.dev> <20251110222922.613224-13-yosry.ahmed@linux.dev>
Message-ID: <aThL9nUuZzZVoKi3@google.com>
Subject: Re: [PATCH v2 12/13] KVM: nSVM: Sanitize control fields copied from VMCB12
From: Sean Christopherson <seanjc@google.com>
To: Yosry Ahmed <yosry.ahmed@linux.dev>
Cc: Paolo Bonzini <pbonzini@redhat.com>, Jim Mattson <jmattson@google.com>, kvm@vger.kernel.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="us-ascii"

On Mon, Nov 10, 2025, Yosry Ahmed wrote:
> Make sure all fields used from VMCB12 in creating the VMCB02 are
> sanitized, such no unhandled or reserved bits end up in the VMCB02.
> 
> The following control fields are read from VMCB12 and have bits that are
> either reserved or not handled/advertised by KVM: tlb_ctl, int_ctl,
> int_state, int_vector, event_inj, misc_ctl, and misc_ctl2.
> 
> The following fields do not require any extra sanitizing:
> - int_ctl: bits from VMCB12 are copied bit-by-bit as needed.
> - misc_ctl: only used in consistency checks (particularly NP_ENABLE).
> - misc_ctl2: bits from VMCB12 are copied bit-by-bit as needed.
> 
> For the remaining fields, make sure only defined bits are copied from
> VMCB12 by defining appropriate masks where needed. The only exception is
> tlb_ctl, which is unused, so remove it.
> 
> Opportunisitcally move some existing definitions in svm.h around such

Opportunistically.  But moot point, because please put such cleanups in a separate
patch.  There are so many opportunistic cleanups in this patch that I genuinely
can't see what's changing, and I don't have the patience right now to stare hard.

Cleanups will making *related* changes are totally fine, e.g. bundling the use
of PAGE_MASK in conjuction with changing the code to do "from->iopm_base_pa & ..."
instead of "to->msrpm_base_pa &= ..." is fine, but those changes have nothing to
do with the rest of the patch.

> that they are ordered by bit position, and cleanup ignoring the lower
> bits of {io/msr}pm_base_pa in __nested_copy_vmcb_control_to_cache() by
> using PAGE_MASK. Also, expand the comment about the ASID being copied
> only for consistency checks.
> 
> Suggested-by: Jim Mattson <jmattson@google.com>
> Signed-off-by: Yosry Ahmed <yosry.ahmed@linux.dev>
> ---
>  arch/x86/include/asm/svm.h | 11 ++++++++---
>  arch/x86/kvm/svm/nested.c  | 26 ++++++++++++++------------
>  arch/x86/kvm/svm/svm.h     |  1 -
>  3 files changed, 22 insertions(+), 16 deletions(-)
> 
> diff --git a/arch/x86/include/asm/svm.h b/arch/x86/include/asm/svm.h
> index a842018952d2c..44f2cfcd8d4ff 100644
> --- a/arch/x86/include/asm/svm.h
> +++ b/arch/x86/include/asm/svm.h
> @@ -213,11 +213,13 @@ struct __attribute__ ((__packed__)) vmcb_control_area {
>  #define V_NMI_ENABLE_SHIFT 26
>  #define V_NMI_ENABLE_MASK (1 << V_NMI_ENABLE_SHIFT)
>  
> +#define X2APIC_MODE_SHIFT 30
> +#define X2APIC_MODE_MASK (1 << X2APIC_MODE_SHIFT)
> +
>  #define AVIC_ENABLE_SHIFT 31
>  #define AVIC_ENABLE_MASK (1 << AVIC_ENABLE_SHIFT)
>  
> -#define X2APIC_MODE_SHIFT 30
> -#define X2APIC_MODE_MASK (1 << X2APIC_MODE_SHIFT)
> +#define SVM_INT_VECTOR_MASK (0xff)
>  
>  #define SVM_INTERRUPT_SHADOW_MASK	BIT_ULL(0)
>  #define SVM_GUEST_INTERRUPT_MASK	BIT_ULL(1)
> @@ -626,8 +628,11 @@ static inline void __unused_size_checks(void)
>  #define SVM_EVTINJ_TYPE_EXEPT (3 << SVM_EVTINJ_TYPE_SHIFT)
>  #define SVM_EVTINJ_TYPE_SOFT (4 << SVM_EVTINJ_TYPE_SHIFT)
>  
> -#define SVM_EVTINJ_VALID (1 << 31)
>  #define SVM_EVTINJ_VALID_ERR (1 << 11)
> +#define SVM_EVTINJ_VALID (1 << 31)

If you want to do cleanup, these should all use BIT()...

> +
> +#define SVM_EVTINJ_RESERVED_BITS ~(SVM_EVTINJ_VEC_MASK | SVM_EVTINJ_TYPE_MASK | \
> +				   SVM_EVTINJ_VALID_ERR | SVM_EVTINJ_VALID)

Because then I don't have to think hard about what exactly this will generate.

>  #define SVM_EXITINTINFO_VEC_MASK SVM_EVTINJ_VEC_MASK
>  #define SVM_EXITINTINFO_TYPE_MASK SVM_EVTINJ_TYPE_MASK
> diff --git a/arch/x86/kvm/svm/nested.c b/arch/x86/kvm/svm/nested.c
> index 89830380cebc5..503cb7f5a4c5f 100644
> --- a/arch/x86/kvm/svm/nested.c
> +++ b/arch/x86/kvm/svm/nested.c
> @@ -479,10 +479,11 @@ void __nested_copy_vmcb_control_to_cache(struct kvm_vcpu *vcpu,
>  	for (i = 0; i < MAX_INTERCEPT; i++)
>  		to->intercepts[i] = from->intercepts[i];
>  
> -	to->iopm_base_pa        = from->iopm_base_pa;
> -	to->msrpm_base_pa       = from->msrpm_base_pa;
> +	/* Lower bits of IOPM_BASE_PA and MSRPM_BASE_PA are ignored */
> +	to->iopm_base_pa        = from->iopm_base_pa & PAGE_MASK;
> +	to->msrpm_base_pa       = from->msrpm_base_pa & PAGE_MASK;
> +
>  	to->tsc_offset          = from->tsc_offset;
> -	to->tlb_ctl             = from->tlb_ctl;
>  	to->int_ctl             = from->int_ctl;
>  	to->int_vector          = from->int_vector;
>  	to->int_state           = from->int_state;
> @@ -492,19 +493,21 @@ void __nested_copy_vmcb_control_to_cache(struct kvm_vcpu *vcpu,
>  	to->exit_info_2         = from->exit_info_2;
>  	to->exit_int_info       = from->exit_int_info;
>  	to->exit_int_info_err   = from->exit_int_info_err;
> -	to->misc_ctl          = from->misc_ctl;
> +	to->misc_ctl		= from->misc_ctl;
>  	to->event_inj           = from->event_inj;
>  	to->event_inj_err       = from->event_inj_err;
>  	to->next_rip            = from->next_rip;
>  	to->nested_cr3          = from->nested_cr3;
> -	to->misc_ctl2            = from->misc_ctl2;
> +	to->misc_ctl2		= from->misc_ctl2;
>  	to->pause_filter_count  = from->pause_filter_count;
>  	to->pause_filter_thresh = from->pause_filter_thresh;
>  
> -	/* Copy asid here because nested_vmcb_check_controls will check it.  */
> +	/*
> +	 * Copy asid here because nested_vmcb_check_controls() will check it.
> +	 * The ASID could be invalid, or conflict with another VM's ASID , so it
> +	 * should never be used directly to run L2.
> +	 */
>  	to->asid           = from->asid;
> -	to->msrpm_base_pa &= ~0x0fffULL;
> -	to->iopm_base_pa  &= ~0x0fffULL;
>  
>  #ifdef CONFIG_KVM_HYPERV
>  	/* Hyper-V extensions (Enlightened VMCB) */
> @@ -890,9 +893,9 @@ static void nested_vmcb02_prepare_control(struct vcpu_svm *svm,
>  		(svm->nested.ctl.int_ctl & int_ctl_vmcb12_bits) |
>  		(vmcb01->control.int_ctl & int_ctl_vmcb01_bits);
>  
> -	vmcb02->control.int_vector          = svm->nested.ctl.int_vector;
> -	vmcb02->control.int_state           = svm->nested.ctl.int_state;
> -	vmcb02->control.event_inj           = svm->nested.ctl.event_inj;
> +	vmcb02->control.int_vector          = svm->nested.ctl.int_vector & SVM_INT_VECTOR_MASK;
> +	vmcb02->control.int_state           = svm->nested.ctl.int_state & SVM_INTERRUPT_SHADOW_MASK;
> +	vmcb02->control.event_inj           = svm->nested.ctl.event_inj & ~SVM_EVTINJ_RESERVED_BITS;
>  	vmcb02->control.event_inj_err       = svm->nested.ctl.event_inj_err;
>  
>  	/*
> @@ -1774,7 +1777,6 @@ static void nested_copy_vmcb_cache_to_control(struct vmcb_control_area *dst,
>  	dst->msrpm_base_pa        = from->msrpm_base_pa;
>  	dst->tsc_offset           = from->tsc_offset;
>  	dst->asid                 = from->asid;
> -	dst->tlb_ctl              = from->tlb_ctl;
>  	dst->int_ctl              = from->int_ctl;
>  	dst->int_vector           = from->int_vector;
>  	dst->int_state            = from->int_state;
> diff --git a/arch/x86/kvm/svm/svm.h b/arch/x86/kvm/svm/svm.h
> index ef6bdce630dc0..c8d43793aa9d6 100644
> --- a/arch/x86/kvm/svm/svm.h
> +++ b/arch/x86/kvm/svm/svm.h
> @@ -178,7 +178,6 @@ struct vmcb_ctrl_area_cached {
>  	u64 msrpm_base_pa;
>  	u64 tsc_offset;
>  	u32 asid;
> -	u8 tlb_ctl;
>  	u32 int_ctl;
>  	u32 int_vector;
>  	u32 int_state;
> -- 
> 2.51.2.1041.gc1ab5b90ca-goog
> 

