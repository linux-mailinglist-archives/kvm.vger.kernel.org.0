Return-Path: <kvm+bounces-68834-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id yDJRMXWAcWk1IAAAu9opvQ
	(envelope-from <kvm+bounces-68834-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Thu, 22 Jan 2026 02:42:13 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [IPv6:2605:f480:58:1:0:1994:3:14])
	by mail.lfdr.de (Postfix) with ESMTPS id 4322160734
	for <lists+kvm@lfdr.de>; Thu, 22 Jan 2026 02:42:13 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id 307E3743C79
	for <lists+kvm@lfdr.de>; Thu, 22 Jan 2026 01:41:43 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E41BA359707;
	Thu, 22 Jan 2026 01:41:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="ehektt9K"
X-Original-To: kvm@vger.kernel.org
Received: from out-189.mta1.migadu.com (out-189.mta1.migadu.com [95.215.58.189])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3312734FF54
	for <kvm@vger.kernel.org>; Thu, 22 Jan 2026 01:41:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.189
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769046066; cv=none; b=raGpbGlgnApIGXa6xce7qOpsxMzqRtdUdU8i9PTEWDgDPxJB6wOhv+AisLIlbLp0z0O9qV8675Z3HMxbSeT+ZVH50BcEl6EiYXq3T9rs0Z/Uyr6sqIyaP1JI9g9rry9vB5Sc2Ps1qRGSbOWUNObMaZJCPWDIjno9MUv/PbyG6k0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769046066; c=relaxed/simple;
	bh=bJD8B7bMB/V2cOZrBvyhQmiOIc0VYncXJQ4LUUkgsRA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=LeRXbmkWQdCW92DjTJmcBRTscKMYE+LBZO2SM/3o7LvXjxFyoIfj9Ynll0oEs/IK6zmoZJrKTGR3nS50PZKSE6nRjwtQKsvVBhQ1hZPF074Im0B4fzL47rW9Bxy7YrDRduFxNJZXtVuaODGKYBeFBpLscBnYLIqvUOt3HUguBLc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=ehektt9K; arc=none smtp.client-ip=95.215.58.189
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Date: Thu, 22 Jan 2026 01:40:49 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1769046061;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=MTU7xvnq/CoKFFvKaS8PklF1z9AUkIMhRVrO9s2dpgQ=;
	b=ehektt9Kn0oW6v4eReQLNvvMM0fyiGCHe7nMmLYuqcYdtEPt4CNOpZIWSjY91C7doqZ++k
	eOQX7xdcWIuSAI5e85pvfaeMbwMucu4dscUTdkSEpNwbRUhrqieWZH3TM0huJm14Kb+TWD
	QPXan5EF+rQitNS31U0o7SCKvYOHJ6k=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Yosry Ahmed <yosry.ahmed@linux.dev>
To: Jim Mattson <jmattson@google.com>
Cc: Sean Christopherson <seanjc@google.com>, 
	Paolo Bonzini <pbonzini@redhat.com>, Thomas Gleixner <tglx@linutronix.de>, 
	Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, 
	Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org, "H. Peter Anvin" <hpa@zytor.com>, 
	Shuah Khan <shuah@kernel.org>, kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-kselftest@vger.kernel.org
Subject: Re: [PATCH v2 3/8] KVM: x86: nSVM: Add validity check for vmcb12
 g_pat
Message-ID: <mcxo54ct7bsu2d6xmalpsae6wq32ykjh6dd4kfgcgru474dqre@47flraln5zz5>
References: <20260115232154.3021475-1-jmattson@google.com>
 <20260115232154.3021475-4-jmattson@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260115232154.3021475-4-jmattson@google.com>
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
	TAGGED_FROM(0.00)[bounces-68834-lists,kvm=lfdr.de];
	RCPT_COUNT_TWELVE(0.00)[13];
	MIME_TRACE(0.00)[0:+];
	DMARC_POLICY_ALLOW(0.00)[linux.dev,none];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	TO_DN_SOME(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[yosry.ahmed@linux.dev,kvm@vger.kernel.org];
	DKIM_TRACE(0.00)[linux.dev:+];
	R_SPF_SOFTFAIL(0.00)[~all:c];
	ASN(0.00)[asn:7979, ipnet:2605:f480::/32, country:US];
	TAGGED_RCPT(0.00)[kvm];
	MISSING_XM_UA(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[dfw.mirrors.kernel.org:helo,dfw.mirrors.kernel.org:rdns,linux.dev:dkim]
X-Rspamd-Queue-Id: 4322160734
X-Rspamd-Action: no action

On Thu, Jan 15, 2026 at 03:21:42PM -0800, Jim Mattson wrote:
> Add a validity check for g_pat, so that when nested paging is enabled for
> vmcb12, an invalid g_pat causes an immediate VMEXIT with exit code
> VMEXIT_INVALID, as specified in the APM, volume 2: "Nested Paging and
> VMRUN/VMEXIT."
> 
> Update the signature of __nested_vmcb_check_save() to include a pointer to
> a struct vmcb_ctrl_area_cached, since the g_pat validity check depend on
> the nested paging control bit.
> 
> Fixes: 3d6368ef580a ("KVM: SVM: Add VMRUN handler")
> Signed-off-by: Jim Mattson <jmattson@google.com>
> ---
>  arch/x86/kvm/svm/nested.c | 12 +++++++++---
>  1 file changed, 9 insertions(+), 3 deletions(-)
> 
> diff --git a/arch/x86/kvm/svm/nested.c b/arch/x86/kvm/svm/nested.c
> index 07a57a43fc3b..e65291434be9 100644
> --- a/arch/x86/kvm/svm/nested.c
> +++ b/arch/x86/kvm/svm/nested.c
> @@ -369,7 +369,8 @@ static bool __nested_vmcb_check_controls(struct kvm_vcpu *vcpu,
>  
>  /* Common checks that apply to both L1 and L2 state.  */
>  static bool __nested_vmcb_check_save(struct kvm_vcpu *vcpu,
> -				     struct vmcb_save_area_cached *save)
> +				     struct vmcb_save_area_cached *save,
> +				     struct vmcb_ctrl_area_cached *control)
>  {
>  	if (CC(!(save->efer & EFER_SVME)))
>  		return false;
> @@ -400,6 +401,10 @@ static bool __nested_vmcb_check_save(struct kvm_vcpu *vcpu,
>  	if (CC(!kvm_valid_efer(vcpu, save->efer)))
>  		return false;
>  
> +	if (CC((control->nested_ctl & SVM_NESTED_CTL_NP_ENABLE) &&
> +	       npt_enabled && !kvm_pat_valid(save->g_pat)))

If this lands after "KVM: nSVM: Drop the non-architectural consistency
check for NP_ENABLE" [1], the npt_enabled check can be dropped, as
SVM_NESTED_CTL_NP_ENABLE will be cleared if the guest cannot use NPTs.

[1]https://lore.kernel.org/kvm/20260115011312.3675857-16-yosry.ahmed@linux.dev/

> +		return false;
> +
>  	return true;
>  }
>  
> @@ -407,8 +412,9 @@ static bool nested_vmcb_check_save(struct kvm_vcpu *vcpu)
>  {
>  	struct vcpu_svm *svm = to_svm(vcpu);
>  	struct vmcb_save_area_cached *save = &svm->nested.save;
> +	struct vmcb_ctrl_area_cached *ctl = &svm->nested.ctl;
>  
> -	return __nested_vmcb_check_save(vcpu, save);
> +	return __nested_vmcb_check_save(vcpu, save, ctl);
>  }
>  
>  static bool nested_vmcb_check_controls(struct kvm_vcpu *vcpu)
> @@ -1892,7 +1898,7 @@ static int svm_set_nested_state(struct kvm_vcpu *vcpu,
>  	if (!(save->cr0 & X86_CR0_PG) ||
>  	    !(save->cr0 & X86_CR0_PE) ||
>  	    (save->rflags & X86_EFLAGS_VM) ||
> -	    !__nested_vmcb_check_save(vcpu, &save_cached))
> +	    !__nested_vmcb_check_save(vcpu, &save_cached, &ctl_cached))

save_cached here is from vmcb01, but ctl_cached is from vmcb12, right?
So we're conditioning the PAT validity check on L1's gPAT on NPT being
enabled for L2 IIUC.

Perhaps we should pass 'bool guest_npt' instead of the cached control
area?  Then we can just pass npt_enabled here IIUC.

>  		goto out_free;
>  
>  
> -- 
> 2.52.0.457.g6b5491de43-goog
> 

