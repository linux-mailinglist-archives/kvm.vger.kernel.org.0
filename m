Return-Path: <kvm+bounces-71028-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id MDHhDQFwjmmLCQEAu9opvQ
	(envelope-from <kvm+bounces-71028-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Fri, 13 Feb 2026 01:27:45 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 973A91320FD
	for <lists+kvm@lfdr.de>; Fri, 13 Feb 2026 01:27:44 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 505293057484
	for <lists+kvm@lfdr.de>; Fri, 13 Feb 2026 00:27:27 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 009A71DF980;
	Fri, 13 Feb 2026 00:27:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="rp5kRPWr"
X-Original-To: kvm@vger.kernel.org
Received: from out-189.mta0.migadu.com (out-189.mta0.migadu.com [91.218.175.189])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CD4A11A5B84
	for <kvm@vger.kernel.org>; Fri, 13 Feb 2026 00:27:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.189
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770942444; cv=none; b=QxCjR9IIn8+eFdpe6RNLKcZZYIg39VD9uW2KQ4pIQPTYkMi9+XazFKFIu2YkhL5At57THJPgLFsyBGO6+eEOwwC+MC2AN1eOUUDxQcLXGmND6oFKLrlD1lPdbR32G9L7lUCqetbGt3hDyzIDrcLr29Uw7vuZR3EOBJokWgzAxLo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770942444; c=relaxed/simple;
	bh=FhyjB6UZEnddfUvtzRjtXrY7CTyRkp73r2jr8cSdqas=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=HMb2XfWFU0XRWyzHIdBv4FhGN+piGFyPbakCHj4mKSpeUlnMRXVOFVeZ3hAxStAxdgsGY27srsKdHtT3tu4hz5hnWasrtvqt+o00N3YIJXNiJM7aV74yYpR3jKAmOdaWzY6nguwVSEOONARkkpERpQkWwilO+k6arqs7leGpQy4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=rp5kRPWr; arc=none smtp.client-ip=91.218.175.189
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Date: Fri, 13 Feb 2026 00:27:14 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1770942440;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=+lTNwjqJZUSDoFa3txjk2T+++THCiW+2PYKP9zQPyFg=;
	b=rp5kRPWr4sG6dq0zKMMZSls14cz+u7xUYj7bnrcSbrTp8ch405ooCyZwvnTPkKaTcEFURK
	ph5KOuy1xr3Wx2H9fSPCA2v//jx+rEVbcx1ALRa1kHtxbahPfrxooAB6kdofk1DTQSpnlV
	qMDY8NWiG3ezMnPsQqlg5bcEZL70jio=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Yosry Ahmed <yosry.ahmed@linux.dev>
To: Jim Mattson <jmattson@google.com>
Cc: Sean Christopherson <seanjc@google.com>, 
	Paolo Bonzini <pbonzini@redhat.com>, Thomas Gleixner <tglx@kernel.org>, 
	Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, 
	Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org, "H. Peter Anvin" <hpa@zytor.com>, 
	Shuah Khan <shuah@kernel.org>, kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-kselftest@vger.kernel.org
Subject: Re: [PATCH v4 3/8] KVM: x86: nSVM: Set vmcb02.g_pat correctly for
 nested NPT
Message-ID: <qohb5conkbp6rsnuffzrsqrvvkus73dcycyo2s3ocjp427iwl4@y6y5rv4zwpee>
References: <20260212155905.3448571-1-jmattson@google.com>
 <20260212155905.3448571-4-jmattson@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260212155905.3448571-4-jmattson@google.com>
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-1.66 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	MID_RHS_NOT_FQDN(0.50)[];
	DMARC_POLICY_ALLOW(-0.50)[linux.dev,none];
	R_DKIM_ALLOW(-0.20)[linux.dev:s=key1];
	R_SPF_ALLOW(-0.20)[+ip4:172.234.253.10:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCVD_TLS_LAST(0.00)[];
	RCVD_COUNT_THREE(0.00)[3];
	FROM_HAS_DN(0.00)[];
	MIME_TRACE(0.00)[0:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCPT_COUNT_TWELVE(0.00)[13];
	TAGGED_FROM(0.00)[bounces-71028-lists,kvm=lfdr.de];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	TO_DN_SOME(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[yosry.ahmed@linux.dev,kvm@vger.kernel.org];
	DKIM_TRACE(0.00)[linux.dev:+];
	TAGGED_RCPT(0.00)[kvm];
	MISSING_XM_UA(0.00)[];
	ASN(0.00)[asn:63949, ipnet:172.234.224.0/19, country:SG];
	DBL_BLOCKED_OPENRESOLVER(0.00)[linux.dev:email,linux.dev:dkim]
X-Rspamd-Queue-Id: 973A91320FD
X-Rspamd-Action: no action

On Thu, Feb 12, 2026 at 07:58:51AM -0800, Jim Mattson wrote:
> When nested NPT is enabled in vmcb12, copy the (cached and validated)
> vmcb12 g_pat field to the guest PAT register. Under KVM, the guest PAT
> register lives in svm->nested.save.g_pat.
> 
> When NPT is enabled, but nested NPT is disabled, copy L1's IA32_PAT MSR to
> the vmcb02 g_pat field, since L2 shares the IA32_PAT MSR with L1.
> 
> When NPT is disabled, the g_pat field is ignored by hardware.
> 
> Fixes: 15038e147247 ("KVM: SVM: obey guest PAT")
> Signed-off-by: Jim Mattson <jmattson@google.com>

Reviewed-by: Yosry Ahmed <yosry.ahmed@linux.dev>

> ---
>  arch/x86/kvm/svm/nested.c | 10 +++++++---
>  1 file changed, 7 insertions(+), 3 deletions(-)
> 
> diff --git a/arch/x86/kvm/svm/nested.c b/arch/x86/kvm/svm/nested.c
> index 91b35adb83f8..dc8275837120 100644
> --- a/arch/x86/kvm/svm/nested.c
> +++ b/arch/x86/kvm/svm/nested.c
> @@ -724,9 +724,6 @@ static void nested_vmcb02_prepare_save(struct vcpu_svm *svm)
>  	struct vmcb *vmcb02 = svm->nested.vmcb02.ptr;
>  	struct kvm_vcpu *vcpu = &svm->vcpu;
>  
> -	nested_vmcb02_compute_g_pat(svm);
> -	vmcb_mark_dirty(vmcb02, VMCB_NPT);
> -
>  	/* Load the nested guest state */
>  	if (svm->nested.vmcb12_gpa != svm->nested.last_vmcb12_gpa) {
>  		new_vmcb12 = true;
> @@ -757,6 +754,13 @@ static void nested_vmcb02_prepare_save(struct vcpu_svm *svm)
>  		vmcb_mark_dirty(vmcb02, VMCB_CET);
>  	}
>  
> +	if (nested_npt_enabled(svm)) {
> +		if (unlikely(new_vmcb12 || vmcb12_is_dirty(control, VMCB_NPT)))
> +			vmcb_set_gpat(vmcb02, svm->nested.save.g_pat);
> +	} else if (npt_enabled) {
> +		vmcb_set_gpat(vmcb02, vcpu->arch.pat);
> +	}
> +
>  	kvm_set_rflags(vcpu, save->rflags | X86_EFLAGS_FIXED);
>  
>  	svm_set_efer(vcpu, svm->nested.save.efer);
> -- 
> 2.53.0.239.g8d8fc8a987-goog
> 

