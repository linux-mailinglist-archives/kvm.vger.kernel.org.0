Return-Path: <kvm+bounces-68831-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id UMhgHad7cWm0HwAAu9opvQ
	(envelope-from <kvm+bounces-68831-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Thu, 22 Jan 2026 02:21:43 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from ams.mirrors.kernel.org (ams.mirrors.kernel.org [IPv6:2a01:60a::1994:3:14])
	by mail.lfdr.de (Postfix) with ESMTPS id 19BD460460
	for <lists+kvm@lfdr.de>; Thu, 22 Jan 2026 02:21:43 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ams.mirrors.kernel.org (Postfix) with ESMTPS id 9E7E83C7DBF
	for <lists+kvm@lfdr.de>; Thu, 22 Jan 2026 01:21:36 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1DB6B34EF0B;
	Thu, 22 Jan 2026 01:21:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="t/gUDhMa"
X-Original-To: kvm@vger.kernel.org
Received: from out-188.mta1.migadu.com (out-188.mta1.migadu.com [95.215.58.188])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 956CA34E746
	for <kvm@vger.kernel.org>; Thu, 22 Jan 2026 01:21:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.188
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769044885; cv=none; b=gYOpz7lVXXrjAw9c0/wbk2Ghd3vgHr9lHHle2KII0AJETVknjwpoX1r5Np0VzlT6IVUHot8QFfF3WNhuOoSYsTS3s53nXRIRbbFvSkcvkJeRrDfzPh1puv4+9a7xHDtI1QasYT28ABKrwcCmiSWx0yNOr6GDS9uUl321zwZfhhk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769044885; c=relaxed/simple;
	bh=DEZCwVapmO47K6ojlDvC8A8h0dMoIygl3A/SLwxzwKY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=MeZskyLI6N+7BLRnXN3ujewYK/J9GEJ1cT/qzKXP7aV0VdmHvc7bYG3SbWDfKJ+khA4Jm1M80SA+z91D0q4Eua8W0CzqN4HJ/U9ptrkoN85cAOnrT8qD7yUEPOkD/oKZ6OUNrZ3VhIEfGZglHKRJQ17W+mOZu1I131SFgTssB28=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=t/gUDhMa; arc=none smtp.client-ip=95.215.58.188
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Date: Thu, 22 Jan 2026 01:20:48 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1769044870;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=ftSN5twPp8Ns7GpEGwoxZdimbsxRxVNds58ZpH1Vjn0=;
	b=t/gUDhMaO+Rnkx5YgDRGc0W6iCknAklxffEyEhUIqaEMabdxp+Vwq3J8kditpFravHVdva
	zEXu1FDBjOEcYUHgr2oyBZaFCrRQ7ReMGGUXQ2JZA9BUBLJKiLgaGnZKwYtTL/KqfiZxrA
	1sEkfW3xmzccmoo2JKx7EVIDzigIVho=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Yosry Ahmed <yosry.ahmed@linux.dev>
To: Jim Mattson <jmattson@google.com>
Cc: Sean Christopherson <seanjc@google.com>, 
	Paolo Bonzini <pbonzini@redhat.com>, Thomas Gleixner <tglx@linutronix.de>, 
	Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, 
	Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org, "H. Peter Anvin" <hpa@zytor.com>, 
	Shuah Khan <shuah@kernel.org>, kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-kselftest@vger.kernel.org
Subject: Re: [PATCH v2 1/8] KVM: x86: nSVM: Redirect IA32_PAT accesses to
 either hPAT or gPAT
Message-ID: <5jwnuhsfer2eovcran7zfyjh7jjrc4zdjgimuipympjnznq7gr@fxdpszsihgup>
References: <20260115232154.3021475-1-jmattson@google.com>
 <20260115232154.3021475-2-jmattson@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260115232154.3021475-2-jmattson@google.com>
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-1.46 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	MID_RHS_NOT_FQDN(0.50)[];
	DMARC_POLICY_ALLOW_WITH_FAILURES(-0.50)[];
	R_DKIM_ALLOW(-0.20)[linux.dev:s=key1];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCVD_TLS_LAST(0.00)[];
	FROM_HAS_DN(0.00)[];
	RCVD_COUNT_THREE(0.00)[3];
	FORGED_SENDER_MAILLIST(0.00)[];
	TAGGED_FROM(0.00)[bounces-68831-lists,kvm=lfdr.de];
	RCPT_COUNT_TWELVE(0.00)[13];
	MIME_TRACE(0.00)[0:+];
	DMARC_POLICY_ALLOW(0.00)[linux.dev,none];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	TO_DN_SOME(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[yosry.ahmed@linux.dev,kvm@vger.kernel.org];
	DKIM_TRACE(0.00)[linux.dev:+];
	R_SPF_SOFTFAIL(0.00)[~all:c];
	ASN(0.00)[asn:7979, ipnet:2a01:60a::/32, country:US];
	TAGGED_RCPT(0.00)[kvm];
	MISSING_XM_UA(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[linux.dev:dkim,ams.mirrors.kernel.org:helo,ams.mirrors.kernel.org:rdns]
X-Rspamd-Queue-Id: 19BD460460
X-Rspamd-Action: no action

On Thu, Jan 15, 2026 at 03:21:40PM -0800, Jim Mattson wrote:
> When the vCPU is in guest mode with nested NPT enabled, guest accesses to
> IA32_PAT are redirected to the gPAT register, which is stored in
> vmcb02->save.g_pat.
> 
> Non-guest accesses (e.g. from userspace) to IA32_PAT are always redirected
> to hPAT, which is stored in vcpu->arch.pat.
> 
> This is architected behavior. It also makes it possible to restore a new
> checkpoint on an old kernel with reasonable semantics. After the restore,
> gPAT will be lost, and L2 will run on L1's PAT. Note that the old kernel
> would have always run L2 on L1's PAT.

This creates a difference in MSR_IA32_CR_PAT handling with nested SVM
and nested VMX, right?

AFAICT, reading MSR_IA32_CR_PAT while an L2 VMX guest is running will
read L2's PAT. With this change, the same scenario on SVM will read L1's
PAT. We can claim that it was always L1's PAT though, because we've
always been running L2 with L1's PAT.

I am just raising this in case it's a problem to have different behavior
for SVM and VMX. I understand that we need to do this to be able to
save/restore L1's PAT with SVM in guest mode and maintain backward
compatibility.

IIUC VMX does not have the same issue because host and guest PAT are
both in vmcs12 and are both saved/restored appropriately.

> 
> Signed-off-by: Jim Mattson <jmattson@google.com>
> ---
>  arch/x86/kvm/svm/svm.c | 31 ++++++++++++++++++++++++-------
>  1 file changed, 24 insertions(+), 7 deletions(-)
> 
> diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
> index 7041498a8091..3f8581adf0c1 100644
> --- a/arch/x86/kvm/svm/svm.c
> +++ b/arch/x86/kvm/svm/svm.c
> @@ -2846,6 +2846,13 @@ static int svm_get_msr(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
>  	case MSR_AMD64_DE_CFG:
>  		msr_info->data = svm->msr_decfg;
>  		break;
> +	case MSR_IA32_CR_PAT:
> +		if (!msr_info->host_initiated && is_guest_mode(vcpu) &&
> +		    nested_npt_enabled(svm))
> +			msr_info->data = svm->vmcb->save.g_pat; /* gPAT */
> +		else
> +			msr_info->data = vcpu->arch.pat; /* hPAT */
> +		break;
>  	default:
>  		return kvm_get_msr_common(vcpu, msr_info);
>  	}
> @@ -2929,14 +2936,24 @@ static int svm_set_msr(struct kvm_vcpu *vcpu, struct msr_data *msr)
>  
>  		break;
>  	case MSR_IA32_CR_PAT:
> -		ret = kvm_set_msr_common(vcpu, msr);
> -		if (ret)
> -			break;
> +		if (!kvm_pat_valid(data))
> +			return 1;
>  
> -		svm->vmcb01.ptr->save.g_pat = data;

This is a bug fix, L2 is now able to alter L1's PAT, right?

> -		if (is_guest_mode(vcpu))
> -			nested_vmcb02_compute_g_pat(svm);
> -		vmcb_mark_dirty(svm->vmcb, VMCB_NPT);

This looks like another bug fix, it seems like we'll update vmcb01 but
clear the clean bit in vmcb02 if we're in guest mode.

Probably worth calling these out (and CC:stable, Fixes:.., etc)?

We probably need a comment here explaining the gPAT vs hPAT case, I
don't think it's super obvious why we only redirect L2's own accesses to
its PAT but not userspace's.

> +		if (!msr->host_initiated && is_guest_mode(vcpu) &&
> +		    nested_npt_enabled(svm)) {
> +			svm->vmcb->save.g_pat = data; /* gPAT */
> +			vmcb_mark_dirty(svm->vmcb, VMCB_NPT);
> +		} else {
> +			vcpu->arch.pat = data; /* hPAT */

Should we call kvm_set_msr_common() here instead of setting
vcpu->arch.pat? The kvm_pat_valid() call would be redundant but that
should be fine. My main concern is if kvm_set_msr_common() gains more
logic for MSR_IA32_CR_PAT that isn't reflected here. Probably unlikely
tho..

> +			if (npt_enabled) {
> +				svm->vmcb01.ptr->save.g_pat = data;
> +				vmcb_mark_dirty(svm->vmcb01.ptr, VMCB_NPT);
> +				if (is_guest_mode(vcpu)) {

IIUC (with the fix you mentioned) this is because L1 and L2 share the
PAT if nested NPT is disabled, and if we're already in guest mode then
we also need to update vmcb02 (as it was already created based on vmcb01
with the old PAT). Probably worth a comment.

> +					svm->vmcb->save.g_pat = data;
> +					vmcb_mark_dirty(svm->vmcb, VMCB_NPT);
> +				}
> +			}
> +		}
>  		break;
>  	case MSR_IA32_SPEC_CTRL:
>  		if (!msr->host_initiated &&
> -- 
> 2.52.0.457.g6b5491de43-goog
> 

