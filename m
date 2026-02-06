Return-Path: <kvm+bounces-70470-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id IBQUIZkxhmmcKQQAu9opvQ
	(envelope-from <kvm+bounces-70470-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Fri, 06 Feb 2026 19:23:21 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id DC910101BF7
	for <lists+kvm@lfdr.de>; Fri, 06 Feb 2026 19:23:20 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id D15DB30297B3
	for <lists+kvm@lfdr.de>; Fri,  6 Feb 2026 18:23:07 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 21C49423A92;
	Fri,  6 Feb 2026 18:23:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="k+wEmk27"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com [209.85.216.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4B7DB335547
	for <kvm@vger.kernel.org>; Fri,  6 Feb 2026 18:23:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770402185; cv=none; b=GstGAsPwyjofdmFzkxfvrqLAEOTnTO8NceIJP/6SRUA2+uRUjHUeNWksNh81dwnPLTkYJjfdbx3wW+3Fq6aEJSATAITd1n+RbzrtzzfwalWu2xl8gPSWYH6SsIic5tti+Koft65dQRB9SG7zhu5y+ihybR7X5D4uIXyBq7gB3jo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770402185; c=relaxed/simple;
	bh=bWfisosvauXpNiB2JxliSmu7idKCf+SAbGX4CyflJNE=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=Nk7ksO2vVLdcyzsZkLQMxlsTBW8uRhapzPGCxjVQeg7EKCUKKnZx/oLTezCE8msN0GQxQNzF03OC/sgBNF/3OQywySFyxspkDxoJIWC+BkZ66dBxNZW18mvinKAJ0kmOmBNjXxTKVp1Gnn9Dmr10zaWDiytuvEsfDzThZRoVdDQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=k+wEmk27; arc=none smtp.client-ip=209.85.216.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f74.google.com with SMTP id 98e67ed59e1d1-3545dbb7f14so2242298a91.0
        for <kvm@vger.kernel.org>; Fri, 06 Feb 2026 10:23:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1770402185; x=1771006985; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=N7ZkTvztciSiP7jae9vXXt3djU2YHid1DHOyalrGato=;
        b=k+wEmk27/WAfBtCGLv0x35upSviJbTMCe9DCSkoTd5gbK09acHTck/XHROFvLD7ilM
         946+VDIpTTRUURcL4sw95FLN5aKVfDba63xdwX8v40JudNURvesG4DzxM4PQkQ+C7m3F
         1ysTcCIPNnTtuOWwRgabUDG0a9yDDCscrCFqq2kj5VFwKG37WMrPbBt0HepHZueaWSe5
         XvPzOwKypGuYHMKw05anNbzHAZqzXT5zf/our/UstsYifHdlNuMOZfvIm/LIS9bd63ig
         jc3GyXe6WTP8wU3vS3DCb5Bc0jQBo1GZFZ5FUFk16cjFLG89st+ztOsVTSs/n2IiUryV
         SLjA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1770402185; x=1771006985;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=N7ZkTvztciSiP7jae9vXXt3djU2YHid1DHOyalrGato=;
        b=Fv0MsWD9vjIRxLweCOAjGg+/j8lifd8/WOUmsFDE1uz0jk5gsjeu9H/mEsUzxfPvMi
         AbN3c0kLY8/IJcE3f15b9m+E9A1pyvhXPjbUIeFOuanuaof8nPefMr85OoEsmxQnWGFn
         LJXOPFk93pnJ08mvxZPFyRZ2U0AX6ZfIeYg12zsmnjVczN+CKTT37eKG2DyaMTBmTLVV
         MOknNvgVBnPme6i0tYJXh/I4PIt310bcUVwlZ2PHq7j2WHq+DOo9gRxC/SJnq316avl/
         lGnfutCJmz4/BGYfYRhGQF8LDhf88tZfWx9Lh5RqqLHa6qxmoNbH9meJqyDFR65i97IY
         vvtQ==
X-Forwarded-Encrypted: i=1; AJvYcCW07t47xc1MouXj9kvmT9EkrJPW9QuPTLTsJWvh+dVlpxAX0ROgJ1krWCVkihFtSwhXWEs=@vger.kernel.org
X-Gm-Message-State: AOJu0Yyk+KqJexnTBCWkR5hatj9TLJVztCpyLZ6ShPWm1jtlN3+XqpNq
	+cTI5K0gly+dVWEUgxqUOrZchPPwPJn/XWjwjrm5ezKr5scADVfPDzCTkj3RttDM8ssEP+xeNRj
	su5KpVw==
X-Received: from pjbjs24.prod.google.com ([2002:a17:90b:1498:b0:34c:2797:7072])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90a:d883:b0:340:e4fb:130b
 with SMTP id 98e67ed59e1d1-354b3be26camr2751196a91.14.1770402184623; Fri, 06
 Feb 2026 10:23:04 -0800 (PST)
Date: Fri, 6 Feb 2026 10:23:03 -0800
In-Reply-To: <20260205214326.1029278-4-jmattson@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20260205214326.1029278-1-jmattson@google.com> <20260205214326.1029278-4-jmattson@google.com>
Message-ID: <aYYxh8EiLrBTiq0L@google.com>
Subject: Re: [PATCH v3 3/8] KVM: x86: nSVM: Set vmcb02.g_pat correctly for
 nested NPT
From: Sean Christopherson <seanjc@google.com>
To: Jim Mattson <jmattson@google.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, Thomas Gleixner <tglx@kernel.org>, Ingo Molnar <mingo@redhat.com>, 
	Borislav Petkov <bp@alien8.de>, Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org, 
	"H. Peter Anvin" <hpa@zytor.com>, Shuah Khan <shuah@kernel.org>, kvm@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-kselftest@vger.kernel.org, 
	Yosry Ahmed <yosry.ahmed@linux.dev>
Content-Type: text/plain; charset="us-ascii"
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-1.66 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[google.com,reject];
	MV_CASE(0.50)[];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c0a:e001:db::/64:c];
	R_DKIM_ALLOW(-0.20)[google.com:s=20230601];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-70470-lists,kvm=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	FROM_HAS_DN(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	MIME_TRACE(0.00)[0:+];
	RCVD_COUNT_THREE(0.00)[4];
	RCPT_COUNT_TWELVE(0.00)[13];
	DKIM_TRACE(0.00)[google.com:+];
	ASN(0.00)[asn:63949, ipnet:2600:3c0a::/32, country:SG];
	MISSING_XM_UA(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[seanjc@google.com,kvm@vger.kernel.org];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	MID_RHS_MATCH_FROM(0.00)[];
	TAGGED_RCPT(0.00)[kvm];
	NEURAL_HAM(-0.00)[-1.000];
	TO_DN_SOME(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: DC910101BF7
X-Rspamd-Action: no action

On Thu, Feb 05, 2026, Jim Mattson wrote:
> When nested NPT is enabled in vmcb12, copy the (cached and validated)
> vmcb12 g_pat field to the guest PAT register. Under KVM, the guest PAT
> register lives in the vmcb02 g_pat field.
> 
> When NPT is enabled, but nested NPT is disabled, copy L1's IA32_PAT MSR to
> the vmcb02 g_pat field, since L2 shares the IA32_PAT MSR with L1.
> 
> When NPT is disabled, the vmcb02 g_pat field is ignored by hardware.

Uber nit, the "vmcb02" qualifier can be dropped, i.e.

  When NPT is disabled, the g_pat field is ignored by hardware.

Scoping it to vmcb02 makes it sound like there's a special rule about vmcb02.

> Fixes: 15038e147247 ("KVM: SVM: obey guest PAT")
> Signed-off-by: Jim Mattson <jmattson@google.com>
> ---
>  arch/x86/kvm/svm/nested.c | 16 +++++++++++++---
>  1 file changed, 13 insertions(+), 3 deletions(-)
> 
> diff --git a/arch/x86/kvm/svm/nested.c b/arch/x86/kvm/svm/nested.c
> index 1d4ff6408b34..1ff2ede96094 100644
> --- a/arch/x86/kvm/svm/nested.c
> +++ b/arch/x86/kvm/svm/nested.c
> @@ -646,9 +646,6 @@ static void nested_vmcb02_prepare_save(struct vcpu_svm *svm, struct vmcb *vmcb12
>  	struct vmcb *vmcb02 = svm->nested.vmcb02.ptr;
>  	struct kvm_vcpu *vcpu = &svm->vcpu;
>  
> -	nested_vmcb02_compute_g_pat(svm);
> -	vmcb_mark_dirty(vmcb02, VMCB_NPT);
> -
>  	/* Load the nested guest state */
>  	if (svm->nested.vmcb12_gpa != svm->nested.last_vmcb12_gpa) {
>  		new_vmcb12 = true;
> @@ -656,6 +653,19 @@ static void nested_vmcb02_prepare_save(struct vcpu_svm *svm, struct vmcb *vmcb12
>  		svm->nested.force_msr_bitmap_recalc = true;
>  	}
>  
> +	if (npt_enabled) {
> +		if (nested_npt_enabled(svm)) {
> +			if (unlikely(new_vmcb12 ||
> +				     vmcb_is_dirty(vmcb12, VMCB_NPT))) {
> +				vmcb02->save.g_pat = svm->nested.gpat;
> +				vmcb_mark_dirty(vmcb02, VMCB_NPT);
> +			}
> +		} else {
> +			vmcb02->save.g_pat = vcpu->arch.pat;
> +			vmcb_mark_dirty(vmcb02, VMCB_NPT);
> +		}
> +	}

To reduce indentation, how about this?  There's a consistency check for
nested_npt_enabled() vs. npt_enabled, so it's guaranteed to do the right thing.

	if (nested_npt_enabled(svm)) {
		if (unlikely(new_vmcb12 || vmcb_is_dirty(vmcb12, VMCB_NPT))) {
			vmcb02->save.g_pat = svm->nested.gpat;
			vmcb_mark_dirty(vmcb02, VMCB_NPT);
		}
	} else if (npt_enabled) {
		vmcb02->save.g_pat = vcpu->arch.pat;
		vmcb_mark_dirty(vmcb02, VMCB_NPT);
	}

> +
>  	if (unlikely(new_vmcb12 || vmcb_is_dirty(vmcb12, VMCB_SEG))) {
>  		vmcb02->save.es = vmcb12->save.es;
>  		vmcb02->save.cs = vmcb12->save.cs;
> -- 
> 2.53.0.rc2.204.g2597b5adb4-goog
> 

