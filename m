Return-Path: <kvm+bounces-69747-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id yDZwCQ33fGllPgIAu9opvQ
	(envelope-from <kvm+bounces-69747-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Fri, 30 Jan 2026 19:23:09 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sto.lore.kernel.org (sto.lore.kernel.org [172.232.135.74])
	by mail.lfdr.de (Postfix) with ESMTPS id BA21FBDAD9
	for <lists+kvm@lfdr.de>; Fri, 30 Jan 2026 19:23:08 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sto.lore.kernel.org (Postfix) with ESMTP id 183CE3007882
	for <lists+kvm@lfdr.de>; Fri, 30 Jan 2026 18:23:08 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C467437D12F;
	Fri, 30 Jan 2026 18:23:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="xUqeOgLg"
X-Original-To: kvm@vger.kernel.org
Received: from out-171.mta0.migadu.com (out-171.mta0.migadu.com [91.218.175.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 92AA634679C
	for <kvm@vger.kernel.org>; Fri, 30 Jan 2026 18:23:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769797386; cv=none; b=BJwTFnliL7RsMNH2KwmWHxM+IDeTluypR6z6fHATiNN6NcL7CGkxClEo+gYtgW9W/ZOWSHH5QLlq7GTWDrloa3XRd1O8joDOFXBFDeAI/hQtDKzlqV5uxfRb6TDZVoz27H0nQKeYCNYUY5ZNrWm7axov2/SkCK67ObcSdLoF6lk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769797386; c=relaxed/simple;
	bh=OG37J5Jzzo6l+oM8jGjTb6l5jhlpamLSKo0B7tpu6y8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=J7cWmYn/u10mTwc/6bRmhUOLnFYWmYVVqYfIshSTNSwQsVV6czugjd/dpP6KN7u1bHpFT6l+jn7+KzEZ7GDj9yD9+o2lKHHiR/APAW7G8nd9cWCjmqm10dOYR0MVauTvZysfr3EzThj5aAWsKRUjbI132Q6SUAlxlx3RJxzG/30=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=xUqeOgLg; arc=none smtp.client-ip=91.218.175.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Date: Fri, 30 Jan 2026 18:22:58 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1769797382;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=AmVNi/FSTGVI0ehnt+cuEmc4BszGYb+Z6j8uy3p+sCs=;
	b=xUqeOgLgfI6hd5lGmH2xe70BNu1r/DsnDXmCfKHG5aEWN4V3dCGhpSHmbw9MvTa8AHkLcI
	Uj7XisaLt7ovVPwX4dJ9oS6Rnh7yt8+hYhAiWwu04V6GeuIL2gCU4+nWXbEioqGyZmTue9
	Bwq1dGQ7D3XcTpStwwcPQXpBFFPqkvs=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Yosry Ahmed <yosry.ahmed@linux.dev>
To: Sean Christopherson <seanjc@google.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org, 
	linux-kernel@vger.kernel.org, Jim Mattson <jmattson@google.com>, 
	David Kaplan <david.kaplan@amd.com>
Subject: Re: [PATCH 2/2] KVM: x86: Emit IBPB on pCPU migration if IBPB is
 advertised to guest
Message-ID: <aon55swe4yedwkzqavs23jyarksm2ddedgjjcm2yq742kblzwy@ritf2ohy3umu>
References: <20260128013432.3250805-1-seanjc@google.com>
 <20260128013432.3250805-3-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260128013432.3250805-3-seanjc@google.com>
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-1.66 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	MID_RHS_NOT_FQDN(0.50)[];
	DMARC_POLICY_ALLOW(-0.50)[linux.dev,none];
	R_DKIM_ALLOW(-0.20)[linux.dev:s=key1];
	R_SPF_ALLOW(-0.20)[+ip4:172.232.135.74:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCVD_TLS_LAST(0.00)[];
	RCVD_COUNT_THREE(0.00)[3];
	FORGED_SENDER_MAILLIST(0.00)[];
	TAGGED_FROM(0.00)[bounces-69747-lists,kvm=lfdr.de];
	TO_DN_SOME(0.00)[];
	MIME_TRACE(0.00)[0:+];
	FROM_HAS_DN(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	RCPT_COUNT_FIVE(0.00)[6];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[yosry.ahmed@linux.dev,kvm@vger.kernel.org];
	DKIM_TRACE(0.00)[linux.dev:+];
	NEURAL_HAM(-0.00)[-1.000];
	ASN(0.00)[asn:63949, ipnet:172.232.128.0/19, country:SG];
	TAGGED_RCPT(0.00)[kvm];
	MISSING_XM_UA(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[linux.dev:dkim,amd.com:email,sto.lore.kernel.org:helo,sto.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: BA21FBDAD9
X-Rspamd-Action: no action

On Tue, Jan 27, 2026 at 05:34:32PM -0800, Sean Christopherson wrote:
> Emit an Indirect Branch Prediction Barrier if a vCPU is migrated to a
> different pCPU and IBPB support is advertised to the guest, to ensure any
> IBPBs performed by the guest are effective across pCPUs.  Ideally, KVM
> would only emit IBPB if the guest performed an IBPB since the vCPU last
> ran on the "new" pCPU, but pCPU migration is a relatively rare/slow path,
> and so the cost of tracking which pCPUs a vCPUs has run on, let alone
> intercepting PRED_CMD writes, outweighs the potential benefits of
> avoiding IBPBs on pCPU migration.
> 
> E.g. if a single vCPU is bouncing between pCPUs A and B, and the guest is
> doing IBPBs on context switches to mitigate cross-task attacks, then the
> following scenario can occur and needs to be mitigated by KVM:
> 
>  1. vCPU starts on pCPU A.  It runs a userspace task (task #1) which
>     installs various branch predictions into pCPU A's BTB.
>  2. The vCPU is migrated to pCPU B.
>  3. The guest switches to userspace task #2 and emits an IBPB, on pCPU B.
>  4. The vCPU is migrated back to pCPU A.  Userspace task (task #2) in the
>     guest now consumes the potentially dangerous branch predictions
>     installed in step 1 from task #1.
> 
> Reported-by: David Kaplan <david.kaplan@amd.com>
> Cc: stable@vger.kernel.org
> Signed-off-by: Sean Christopherson <seanjc@google.com>
> ---
>  arch/x86/kvm/x86.c | 13 +++++++++++++
>  1 file changed, 13 insertions(+)
> 
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index e5ae655702b4..9d1641c2d83c 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -5201,6 +5201,19 @@ void kvm_arch_vcpu_load(struct kvm_vcpu *vcpu, int cpu)
>  		kvm_make_request(KVM_REQ_CLOCK_UPDATE, vcpu);
>  	}
>  
> +	/*
> +	 * If the vCPU is migrated to a different pCPU than the one on which
> +	 * the vCPU last ran, and IBPB is advertised to the vCPU, then flush
> +	 * indirect branch predictors before the next VM-Enter to ensure the
> +	 * vCPU doesn't consume prediction information from a previous run on
> +	 * the "new" pCPU.
> +	 */
> +	if (unlikely(vcpu->arch.last_vmentry_cpu != cpu &&
> +		     vcpu->arch.last_vmentry_cpu >= 0) &&
> +	    (guest_cpu_cap_has(vcpu, X86_FEATURE_SPEC_CTRL) ||
> +	     guest_cpu_cap_has(vcpu, X86_FEATURE_AMD_IBPB)))
> +		vcpu->arch.need_ibpb = true;

Disregarding deferring the IBPB, the logic looks sound. Should this be
moved right after the other IBPB condition above though?

> +
>  	if (unlikely(vcpu->cpu != cpu) || kvm_check_tsc_unstable()) {
>  		s64 tsc_delta = !vcpu->arch.last_host_tsc ? 0 :
>  				rdtsc() - vcpu->arch.last_host_tsc;
> -- 
> 2.52.0.457.g6b5491de43-goog
> 

