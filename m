Return-Path: <kvm+bounces-71200-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id yAHBOG/8lGm8JgIAu9opvQ
	(envelope-from <kvm+bounces-71200-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Wed, 18 Feb 2026 00:40:31 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sin.lore.kernel.org (sin.lore.kernel.org [104.64.211.4])
	by mail.lfdr.de (Postfix) with ESMTPS id 1C109151FA8
	for <lists+kvm@lfdr.de>; Wed, 18 Feb 2026 00:40:31 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sin.lore.kernel.org (Postfix) with ESMTP id C6155300AD9D
	for <lists+kvm@lfdr.de>; Tue, 17 Feb 2026 23:40:28 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 458D432AAA1;
	Tue, 17 Feb 2026 23:40:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="OAw4KAWG"
X-Original-To: kvm@vger.kernel.org
Received: from out-181.mta0.migadu.com (out-181.mta0.migadu.com [91.218.175.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A13B2329361
	for <kvm@vger.kernel.org>; Tue, 17 Feb 2026 23:40:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771371624; cv=none; b=rhn84v5ZrlUk7A3KTNRcyfmY0ACZVg1b4B3GbtxaB5DykcCVfExCtblKtx5+TKxT3BXoloCXunLBFK4QsuIw4KfNofy5goc/FVxv+/Dwe/4kGpgSMx3rS79sGRXcWtikqpCAb365j8vbPOkERjQPxWF9QIqM0b3Z3KIcFu3lvBE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771371624; c=relaxed/simple;
	bh=n3665hyqD+YFxO1qA6277r/JprP6rvjuvnDtF6eHn3g=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=NgpjHwqUs8hSbyyH3wyeRpRUaD/AVvbDvDAnEK66LP/1uROR4Xq0Riac5rLvqkQ/ktyC4dGhZ2e9KQmkvjXx7sErMiknw7IuZbGXaoDdZ56MhjqoNn/OjxfV2j1UJ2+Nr7dIX+yfyuVCND6NqJbb3UG0wZcze+41bjOlvKo7bCE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=OAw4KAWG; arc=none smtp.client-ip=91.218.175.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Date: Tue, 17 Feb 2026 23:40:03 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1771371608;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=AcijYy5uG9XsxVduS24EayjI5STy9xec0AclJ9VPUKA=;
	b=OAw4KAWGWZmktrMYoegg139Gvhyadx2uVmlCTP2ECZKRzXuc+WSo0iRNTKSdC/+1niHpt0
	SA1cmAAxmeHTRZi0YNjanQfGFeN/Neqv+Kkawd0pGu0KjxZQTV2HUnkn62MNB2XU4QKm5v
	ynw/oyrAjELwDuw/VQH0NusuASzJEI0=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Yosry Ahmed <yosry.ahmed@linux.dev>
To: Sean Christopherson <seanjc@google.com>
Cc: Jim Mattson <jmattson@google.com>, Paolo Bonzini <pbonzini@redhat.com>, 
	Thomas Gleixner <tglx@kernel.org>, Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, 
	Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org, "H. Peter Anvin" <hpa@zytor.com>, 
	Shuah Khan <shuah@kernel.org>, kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-kselftest@vger.kernel.org
Subject: Re: [PATCH v4 4/8] KVM: x86: nSVM: Redirect IA32_PAT accesses to
 either hPAT or gPAT
Message-ID: <tpqwkctcbv47rxd2kutz3wk52klf332nnrf5bgtrpsaysfjpva@sj4blucyaftv>
References: <20260212155905.3448571-1-jmattson@google.com>
 <20260212155905.3448571-5-jmattson@google.com>
 <gqj4y6awen5dfxy32lbskcxw6xdv4xiiouycyftjacndjinhvp@7p4dtgdh6tjw>
 <aY9BPKhzgxo4UuHB@google.com>
 <CALMp9eR4ayj_gwsDQVH8pQvzqgEYVB6ExWp3aFgJXRWikLEikw@mail.gmail.com>
 <aY-jViitsLQm9B83@google.com>
 <CALMp9eTnXW9=0=+RxQjeXfA++UP3MX0LzXo5qwUP-dCCQjOLVQ@mail.gmail.com>
 <aZT5eldlkLpRm7OD@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aZT5eldlkLpRm7OD@google.com>
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-1.66 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	MID_RHS_NOT_FQDN(0.50)[];
	DMARC_POLICY_ALLOW(-0.50)[linux.dev,none];
	R_DKIM_ALLOW(-0.20)[linux.dev:s=key1];
	R_SPF_ALLOW(-0.20)[+ip4:104.64.211.4:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCVD_TLS_LAST(0.00)[];
	RCVD_COUNT_THREE(0.00)[3];
	FROM_HAS_DN(0.00)[];
	MIME_TRACE(0.00)[0:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCPT_COUNT_TWELVE(0.00)[13];
	TAGGED_FROM(0.00)[bounces-71200-lists,kvm=lfdr.de];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	TO_DN_SOME(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[yosry.ahmed@linux.dev,kvm@vger.kernel.org];
	DKIM_TRACE(0.00)[linux.dev:+];
	TAGGED_RCPT(0.00)[kvm];
	MISSING_XM_UA(0.00)[];
	ASN(0.00)[asn:63949, ipnet:104.64.192.0/19, country:SG];
	DBL_BLOCKED_OPENRESOLVER(0.00)[linux.dev:dkim,sin.lore.kernel.org:helo,sin.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: 1C109151FA8
X-Rspamd-Action: no action

> I like it.  And AFAICT it largely Just Works, because the calls from
> svm_set_nested_state() will always be routed to gpat since the calls are already
> guarded with is_guest_mode() + nested_npt_enabled().
> 
> Side topic, either as a prep patch (to duplicate code) or as a follow-up patch
> (to move the PAT handling in x86.c to vmx.c), the "common" handling of PAT should
> be fully forked between VMX and SVM.  As of this patch, it's not just misleading,
> it's actively dangerous since calling kvm_get_msr_common() for SVM would get the
> wrong value.

+1 on both points.

> FWIW, this is what I ended up with when hacking on top of your patches to see how
> this played out.
> 
> ---
> @@ -2838,16 +2876,7 @@ static int svm_get_msr(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
>  		msr_info->data = svm->msr_decfg;
>  		break;
>  	case MSR_IA32_CR_PAT:
> -		/*
> -		 * When nested NPT is enabled, L2 has a separate PAT from
> -		 * L1.  Guest accesses to IA32_PAT while running L2 target
> -		 * L2's gPAT; host-initiated accesses always target L1's
> -		 * hPAT for backward and forward KVM_GET_MSRS compatibility
> -		 * with older kernels.
> -		 */
> -		WARN_ON_ONCE(msr_info->host_initiated && vcpu->wants_to_run);
> -		if (!msr_info->host_initiated && is_guest_mode(vcpu) &&
> -		    nested_npt_enabled(svm))
> +		if (svm_is_access_to_gpat(vcpu, msr_info->host_initiated))
>  			msr_info->data = svm->nested.save.g_pat;
>  		else
>  			msr_info->data = vcpu->arch.pat;

I'd go a step further here and add svm_get_pat(), then this just
becomes:

	msr_info->data = svm_get_pat(vcpu, msr_info->host_initiated);

It's more consistent with svm_set_msr(), and completely abstracts the L1
vs. L2 PAT logic with the helpers.

> @@ -2937,19 +2966,8 @@ static int svm_set_msr(struct kvm_vcpu *vcpu, struct msr_data *msr)
>  	case MSR_IA32_CR_PAT:
>  		if (!kvm_pat_valid(data))
>  			return 1;
> -		/*
> -		 * When nested NPT is enabled, L2 has a separate PAT from
> -		 * L1.  Guest accesses to IA32_PAT while running L2 target
> -		 * L2's gPAT; host-initiated accesses always target L1's
> -		 * hPAT for backward and forward KVM_SET_MSRS compatibility
> -		 * with older kernels.
> -		 */
> -		WARN_ON_ONCE(msr->host_initiated && vcpu->wants_to_run);
> -		if (!msr->host_initiated && is_guest_mode(vcpu) &&
> -		    nested_npt_enabled(svm))
> -			svm_set_gpat(svm, data);
> -		else
> -			svm_set_hpat(svm, data);
> +
> +		svm_set_pat(vcpu, data, msr->host_initiated);
>  		break;
>  	case MSR_IA32_SPEC_CTRL:
>  		if (!msr->host_initiated &&

