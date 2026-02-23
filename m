Return-Path: <kvm+bounces-71546-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id +KOaHs7fnGnCLwQAu9opvQ
	(envelope-from <kvm+bounces-71546-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Tue, 24 Feb 2026 00:16:30 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sin.lore.kernel.org (sin.lore.kernel.org [IPv6:2600:3c15:e001:75::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id A646B17F15F
	for <lists+kvm@lfdr.de>; Tue, 24 Feb 2026 00:16:29 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sin.lore.kernel.org (Postfix) with ESMTP id 91E2B303CD8E
	for <lists+kvm@lfdr.de>; Mon, 23 Feb 2026 23:15:23 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A1D5C37E2FF;
	Mon, 23 Feb 2026 23:15:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="S7vrsr8x"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f73.google.com (mail-pj1-f73.google.com [209.85.216.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9D3FF37E31E
	for <kvm@vger.kernel.org>; Mon, 23 Feb 2026 23:15:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771888520; cv=none; b=BKCR+tJAeS2TSj0tPXKJ2NUD3nMbNJ5n0X194iVW0osLoThdgMmWeqmhZhhqnta0pGKsuwwrPCfkOVWHPKOo+JZWvTsTGD2hz6VsoRAPUasmFzWl7aykrcUyYhi9bwUzOB/NBu1yuAWI0alwbLZFd/N3njTG91QoCM88BpS6fBg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771888520; c=relaxed/simple;
	bh=B9rEHO/Alu+wvKNgWIpdOvdWR+itIxpOX4WOHVwRT4c=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=gnmlpVwSd5a3X9f+jQeQF6M9CQJlAfE6gV5Zf9USyxDUAlFLq1z0rLhh0aOIdw4+PpnnfBCbG7IoeFJFrLmY780kRkUKNGaQTQyV1pADBKgtogOjYAUSDoezgc4JXlLrX7GsK+srUmxkXVFropZsZzcOba4EFN+kcefV6nafVhM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=S7vrsr8x; arc=none smtp.client-ip=209.85.216.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f73.google.com with SMTP id 98e67ed59e1d1-3568090851aso33937877a91.1
        for <kvm@vger.kernel.org>; Mon, 23 Feb 2026 15:15:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1771888519; x=1772493319; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=+b2NA5qyQrO16m+c2pRd+nTlMHqOSFWpDC57i2Qp01k=;
        b=S7vrsr8xHyShFbhghyIfbu7QpMTWI08iA1X5M5KmdF0Y6su11MNUtlwJyPMAxQXST6
         35xr+gNeXziFOQKBTUbHo/OHgt9rKqdmNX1RfIRdozNk9U5zQGQ/ueM5pj/ExsOcdGUr
         mq5W2VvhKMjvN5Lj8g9JXepJHNUCl4rPy0xRw/5632QyHJWYBHEaspEWe0vsmdCAYaYT
         LW7Bl6vM6OGJhokYLU7qIwskXAyrVWdp9annTjaoJSCmQ6RtxFLIb2kY8HS1v1ESguKB
         5z3eqlt4JVWhtxsoVt2TVVOx3PkIDKLi2SIHEfVtdKlkshs6UTfUPhiS3upuWnmYiqhJ
         IsZw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1771888519; x=1772493319;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=+b2NA5qyQrO16m+c2pRd+nTlMHqOSFWpDC57i2Qp01k=;
        b=cGOnbA2gZ85Jp+kxGdU8ik74gur9d7TAx9zvXIZinZ3ccr191BfvHIBeXYtJvYG9yR
         EHfNBNAlHav+wWmXlb1+977nkLfF7EAmxTuq4dSd8lIvPS3jHBm1aE7Tn7LrTyh1zm5o
         KF0Fv/yLXyDqkByg90sp+FqkIgSt2VqNQt3fUmN+D3SPhfNWGtVLzM/blJUXmRoxkuoP
         BdTk1o8Hzyy6Y6tq4LPq7HFsYJYm3vKbrce7alb4v95OAKfFj34vQWIiuMxA2zMm5Qlf
         2qNUF81i5ZW17Y0jmQzM1x7FmUgWCE2q88l6Ykfs0tZwp4cMRXyh93oHB/r+FCcRs3d7
         5L3Q==
X-Forwarded-Encrypted: i=1; AJvYcCXsW+Gm+BOAueWjT6j61wk0Od97gg/hrCxFks76nDTpJHPZJYALxV5EueMaVyo35c7VHxw=@vger.kernel.org
X-Gm-Message-State: AOJu0Yy7FwKSuQIUzx/LyEfZTYBRtbc0U1EjoWY6WQm5vAsDD2EhZevh
	WJC3GikAQPa+pOD8KFgCfUdcpVbvJVN3VN4RBJntKy4rsS990Zu6ApDbH2Oyyz1OOPKsayo7wG5
	cNZ4jrw==
X-Received: from pjug8.prod.google.com ([2002:a17:90a:ce88:b0:354:7c11:76e1])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:3d50:b0:356:2eac:b650
 with SMTP id 98e67ed59e1d1-358ae7c3731mr8524476a91.3.1771888518929; Mon, 23
 Feb 2026 15:15:18 -0800 (PST)
Date: Mon, 23 Feb 2026 15:15:17 -0800
In-Reply-To: <20260206190851.860662-26-yosry.ahmed@linux.dev>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20260206190851.860662-1-yosry.ahmed@linux.dev> <20260206190851.860662-26-yosry.ahmed@linux.dev>
Message-ID: <aZzfhY1qigh71n2e@google.com>
Subject: Re: [PATCH v5 25/26] KVM: nSVM: Sanitize control fields copied from VMCB12
From: Sean Christopherson <seanjc@google.com>
To: Yosry Ahmed <yosry.ahmed@linux.dev>
Cc: Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Jim Mattson <jmattson@google.com>
Content-Type: text/plain; charset="us-ascii"
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-1.66 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[google.com,reject];
	MV_CASE(0.50)[];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c15:e001:75::/64];
	R_DKIM_ALLOW(-0.20)[google.com:s=20230601];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-71546-lists,kvm=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	FROM_HAS_DN(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	MIME_TRACE(0.00)[0:+];
	RCVD_COUNT_THREE(0.00)[4];
	TO_DN_SOME(0.00)[];
	DKIM_TRACE(0.00)[google.com:+];
	ASN(0.00)[asn:63949, ipnet:2600:3c15::/32, country:SG];
	MISSING_XM_UA(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[seanjc@google.com,kvm@vger.kernel.org];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	MID_RHS_MATCH_FROM(0.00)[];
	TAGGED_RCPT(0.00)[kvm];
	NEURAL_HAM(-0.00)[-1.000];
	RCPT_COUNT_FIVE(0.00)[5];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sin.lore.kernel.org:helo,sin.lore.kernel.org:rdns,linux.dev:email]
X-Rspamd-Queue-Id: A646B17F15F
X-Rspamd-Action: no action

On Fri, Feb 06, 2026, Yosry Ahmed wrote:
> Make sure all fields used from VMCB12 in creating the VMCB02 are
> sanitized, such that no unhandled or reserved bits end up in the VMCB02.
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
> L1's VMCB12 into KVM'cache by defining appropriate masks where needed.
> The only exception is tlb_ctl, which is unused, so remove it.
> 
> Opportunistically cleanup ignoring the lower bits of {io/msr}pm_base_pa
> in __nested_copy_vmcb_control_to_cache() by using PAGE_MASK. Also, move
> the ASID copying ahead with other special cases, and expand the comment
> about the ASID being copied only for consistency checks.

Stop. Bundling. Changes.

This is not a hypothetical situation, bundling small changes like this is quite
literally making review take 3-4x longer than it should.

The interrupt changes are trivial to review.

The I/O and MSR bitmap changes are also easy enough, but I wanted to double that
PAGE_MASK does indeed equal ~0x0fffULL (__PHYSICAL_MASK is the one that can be dynamic).

I disagree the the tlb_ctl change.

Moving the ASID handling is _completely_ superfluous.

Combining any two of those is annoying to deal with.  Combining all of them wastes
a non-trivial amount of time.  What should have taken me ~5 minutes to review is
dragging into 20+ minutes, because I keep having to cross-reference the changelog
with the code to understand WTF is going on.

Just stop doing it, please.
 
> Suggested-by: Jim Mattson <jmattson@google.com>
> Signed-off-by: Yosry Ahmed <yosry.ahmed@linux.dev>
> ---
>  arch/x86/include/asm/svm.h |  5 +++++
>  arch/x86/kvm/svm/nested.c  | 28 +++++++++++++++-------------
>  arch/x86/kvm/svm/svm.h     |  1 -
>  3 files changed, 20 insertions(+), 14 deletions(-)
> 
> diff --git a/arch/x86/include/asm/svm.h b/arch/x86/include/asm/svm.h
> index c169256c415f..fe3b6d9cea31 100644
> --- a/arch/x86/include/asm/svm.h
> +++ b/arch/x86/include/asm/svm.h
> @@ -222,6 +222,8 @@ struct __attribute__ ((__packed__)) vmcb_control_area {
>  #define X2APIC_MODE_SHIFT 30
>  #define X2APIC_MODE_MASK (1 << X2APIC_MODE_SHIFT)
>  
> +#define SVM_INT_VECTOR_MASK GENMASK(7, 0)
> +
>  #define SVM_INTERRUPT_SHADOW_MASK	BIT_ULL(0)
>  #define SVM_GUEST_INTERRUPT_MASK	BIT_ULL(1)
>  
> @@ -635,6 +637,9 @@ static inline void __unused_size_checks(void)
>  #define SVM_EVTINJ_VALID (1 << 31)
>  #define SVM_EVTINJ_VALID_ERR (1 << 11)
>  
> +#define SVM_EVTINJ_RESERVED_BITS ~(SVM_EVTINJ_VEC_MASK | SVM_EVTINJ_TYPE_MASK | \
> +				   SVM_EVTINJ_VALID_ERR | SVM_EVTINJ_VALID)
> +
>  #define SVM_EXITINTINFO_VEC_MASK SVM_EVTINJ_VEC_MASK
>  #define SVM_EXITINTINFO_TYPE_MASK SVM_EVTINJ_TYPE_MASK
>  
> diff --git a/arch/x86/kvm/svm/nested.c b/arch/x86/kvm/svm/nested.c
> index 0a7bb01f5404..c87738962970 100644
> --- a/arch/x86/kvm/svm/nested.c
> +++ b/arch/x86/kvm/svm/nested.c
> @@ -499,32 +499,35 @@ void __nested_copy_vmcb_control_to_cache(struct kvm_vcpu *vcpu,
>  	if (!guest_cpu_cap_has(vcpu, X86_FEATURE_NPT))
>  		to->misc_ctl &= ~SVM_MISC_ENABLE_NP;
>  
> -	to->iopm_base_pa        = from->iopm_base_pa;
> -	to->msrpm_base_pa       = from->msrpm_base_pa;
> +	/*
> +	 * Copy the ASID here because nested_vmcb_check_controls() will check
> +	 * it.  The ASID could be invalid, or conflict with another VM's ASID ,

Spurious space before the command.

> +	 * so it should never be used directly to run L2.
> +	 */
> +	to->asid = from->asid;
> +
> +	/* Lower bits of IOPM_BASE_PA and MSRPM_BASE_PA are ignored */
> +	to->iopm_base_pa        = from->iopm_base_pa & PAGE_MASK;
> +	to->msrpm_base_pa       = from->msrpm_base_pa & PAGE_MASK;
>>  	to->tsc_offset          = from->tsc_offset;
> -	to->tlb_ctl             = from->tlb_ctl;

I don't think we should completely drop tlb_ctl.  KVM doesn't do anything with
vmcb12's tlb_ctl only because we haven't addressed the TODO list in
nested_svm_transition_tlb_flush().  I think I would rather update this code to
sanitize the field now, as opposed to waiting until we address that TODO.

KVM advertises X86_FEATURE_FLUSHBYASID, so I think we can do the right thing
without having to speculate on what the future will bring.

Alternatively, we could add a TODO here or update the one in
nested_svm_transition_tlb_flush(), but that seems like more overall work than
just hardening the code.

