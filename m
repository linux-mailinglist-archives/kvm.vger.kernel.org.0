Return-Path: <kvm+bounces-70608-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id SLIPFCgGimluFQAAu9opvQ
	(envelope-from <kvm+bounces-70608-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Mon, 09 Feb 2026 17:07:04 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id A47B711252B
	for <lists+kvm@lfdr.de>; Mon, 09 Feb 2026 17:07:03 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 9E99E301A382
	for <lists+kvm@lfdr.de>; Mon,  9 Feb 2026 16:05:53 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1BEE9298CC9;
	Mon,  9 Feb 2026 16:05:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="D8nd+jX/"
X-Original-To: kvm@vger.kernel.org
Received: from out-176.mta1.migadu.com (out-176.mta1.migadu.com [95.215.58.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 188F737756D
	for <kvm@vger.kernel.org>; Mon,  9 Feb 2026 16:05:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.176
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770653152; cv=none; b=NPSghp6XK8WTxcV6jo9+WVor6Zy+7Ng2rbBJKCrHN6GDe9ADQ8hALW58USg88/lA+CoM6DxQOgSM8+eI0c6CYgqlgE5+831SQ986lj8LuL4fgWwuE4HWJl8sFYYbzoMjIkQw+A+bkHB3htEfKxl/H2QMn2CtGr7Wt8ppR1xjUw0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770653152; c=relaxed/simple;
	bh=BThjGlM5C8zPKvz55IHhMJUZD/VwsIDK1vbQ1XU3Ok4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Hf+0EI1EIAkshkLdHwAGckajRe9apH7s7574rVHdjw+ZZTQ5p5IXGIiFiCvgdDGUz6RemwyKC9suwiHxdrp+yvgERK7s4eqfIn/jaMrcNmCtN8ij/djqzOlpl+ldKl12GucioYNMwKeJIX9mGg6lQVLHpyAmvBflnBCkGThWBAw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=D8nd+jX/; arc=none smtp.client-ip=95.215.58.176
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Date: Mon, 9 Feb 2026 16:05:41 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1770653150;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=af799B6iT69sVNLhSxX5YpPxUpFdRI/IblJVCoe32D4=;
	b=D8nd+jX/3qo4KRUlNmdG/X0YljkyI0Kmm2cCTh+dqBrYgfU71jpTAPMBOT4ohutdr4W/DQ
	l+vkO0zDbfpoZrx2XeeQ3VYeoa6geIPLZJKLtLG7O1FdtkUDSLRB4oxGw6yp0s1EWdxfTm
	u+lfhSZDc9We2qVP9tN5K9g/yKvBdLo=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Yosry Ahmed <yosry.ahmed@linux.dev>
To: Jim Mattson <jmattson@google.com>
Cc: Sean Christopherson <seanjc@google.com>, 
	Paolo Bonzini <pbonzini@redhat.com>, Thomas Gleixner <tglx@kernel.org>, 
	Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, 
	Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org, "H. Peter Anvin" <hpa@zytor.com>, 
	Shuah Khan <shuah@kernel.org>, kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-kselftest@vger.kernel.org
Subject: Re: [PATCH v3 1/8] KVM: x86: nSVM: Clear VMCB_NPT clean bit when
 updating g_pat in L2
Message-ID: <mfejpune47o6ebsbv4bpn6qlgpwcc5rld3tik4c7xp7odxfa5u@w7ovavcrxn43>
References: <20260205214326.1029278-1-jmattson@google.com>
 <20260205214326.1029278-2-jmattson@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260205214326.1029278-2-jmattson@google.com>
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
	TAGGED_FROM(0.00)[bounces-70608-lists,kvm=lfdr.de];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	TO_DN_SOME(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[yosry.ahmed@linux.dev,kvm@vger.kernel.org];
	DKIM_TRACE(0.00)[linux.dev:+];
	TAGGED_RCPT(0.00)[kvm];
	MISSING_XM_UA(0.00)[];
	ASN(0.00)[asn:63949, ipnet:172.234.224.0/19, country:SG];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: A47B711252B
X-Rspamd-Action: no action

On Thu, Feb 05, 2026 at 01:43:01PM -0800, Jim Mattson wrote:
> When running an L2 guest and writing to MSR_IA32_CR_PAT, the host PAT value
> is stored in vmcb01.ptr->save.g_pat, but the clean bit was only being
> cleared for svm->vmcb, which points to vmcb02 in guest mode.
> 
> Introduce the helper svm_set_vmcb_gpat() which sets vmcb->save.g_pat and
> marks the VMCB dirty for VMCB_NPT. Use this helper in both svm_set_msr()
> for updating vmcb01 and in nested_vmcb02_compute_g_pat() for updating
> vmcb02, ensuring both VMCBs are properly marked dirty.
> 
> Fixes: 4995a3685f1b ("KVM: SVM: Use a separate vmcb for the nested L2 guest")
> Signed-off-by: Jim Mattson <jmattson@google.com>
> ---
>  arch/x86/kvm/svm/nested.c | 2 +-
>  arch/x86/kvm/svm/svm.c    | 3 +--
>  arch/x86/kvm/svm/svm.h    | 6 ++++++
>  3 files changed, 8 insertions(+), 3 deletions(-)
> 
> diff --git a/arch/x86/kvm/svm/nested.c b/arch/x86/kvm/svm/nested.c
> index de90b104a0dd..f72dbd10dcad 100644
> --- a/arch/x86/kvm/svm/nested.c
> +++ b/arch/x86/kvm/svm/nested.c
> @@ -636,7 +636,7 @@ void nested_vmcb02_compute_g_pat(struct vcpu_svm *svm)
>  		return;
>  
>  	/* FIXME: merge g_pat from vmcb01 and vmcb12.  */
> -	svm->nested.vmcb02.ptr->save.g_pat = svm->vmcb01.ptr->save.g_pat;
> +	svm_set_vmcb_gpat(svm->nested.vmcb02.ptr, svm->vmcb01.ptr->save.g_pat);
>  }
>  
>  static void nested_vmcb02_prepare_save(struct vcpu_svm *svm, struct vmcb *vmcb12)
> diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
> index 5f0136dbdde6..08f145eb9215 100644
> --- a/arch/x86/kvm/svm/svm.c
> +++ b/arch/x86/kvm/svm/svm.c
> @@ -2939,10 +2939,9 @@ static int svm_set_msr(struct kvm_vcpu *vcpu, struct msr_data *msr)
>  		if (ret)
>  			break;
>  
> -		svm->vmcb01.ptr->save.g_pat = data;
> +		svm_set_vmcb_gpat(svm->vmcb01.ptr, data);
>  		if (is_guest_mode(vcpu))
>  			nested_vmcb02_compute_g_pat(svm);
> -		vmcb_mark_dirty(svm->vmcb, VMCB_NPT);
>  		break;
>  	case MSR_IA32_SPEC_CTRL:
>  		if (!msr->host_initiated &&
> diff --git a/arch/x86/kvm/svm/svm.h b/arch/x86/kvm/svm/svm.h
> index ebd7b36b1ceb..986d90f2d4ca 100644
> --- a/arch/x86/kvm/svm/svm.h
> +++ b/arch/x86/kvm/svm/svm.h
> @@ -420,6 +420,12 @@ static inline bool vmcb_is_dirty(struct vmcb *vmcb, int bit)
>          return !test_bit(bit, (unsigned long *)&vmcb->control.clean);
>  }
>  
> +static inline void svm_set_vmcb_gpat(struct vmcb *vmcb, u64 data)

Nit: vmcb_set_gpat() is probably more consistent with other helpers
(e.g.  vmcb_set_intercept() and vmcb_set_seg()).

> +{
> +	vmcb->save.g_pat = data;
> +	vmcb_mark_dirty(vmcb, VMCB_NPT);
> +}
> +
>  static __always_inline struct vcpu_svm *to_svm(struct kvm_vcpu *vcpu)
>  {
>  	return container_of(vcpu, struct vcpu_svm, vcpu);
> -- 
> 2.53.0.rc2.204.g2597b5adb4-goog
> 

