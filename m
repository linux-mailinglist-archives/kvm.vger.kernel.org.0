Return-Path: <kvm+bounces-69746-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id CBO6Aur2fGllPgIAu9opvQ
	(envelope-from <kvm+bounces-69746-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Fri, 30 Jan 2026 19:22:34 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 5C522BDAC4
	for <lists+kvm@lfdr.de>; Fri, 30 Jan 2026 19:22:33 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 92E373026AA0
	for <lists+kvm@lfdr.de>; Fri, 30 Jan 2026 18:21:58 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DCDC937474F;
	Fri, 30 Jan 2026 18:21:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="TxszwPgP"
X-Original-To: kvm@vger.kernel.org
Received: from out-178.mta0.migadu.com (out-178.mta0.migadu.com [91.218.175.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7E9C63033C7
	for <kvm@vger.kernel.org>; Fri, 30 Jan 2026 18:21:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769797317; cv=none; b=PRfLGfPMbaLnQZ/l9Zx79bfOQlvibnURSUbXv1PGE/JQImmoMMqi2GV1SLTNmzrTaGwFw14vCA4VsVs16ADB8/dxCKjNBVsPg7tlxBEArkha7149rAuE2lolrbWu1udnPDlQqqVYM1RjY9bJ5RweiZ3PsLG3cZZZI4GHIJn8GN4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769797317; c=relaxed/simple;
	bh=FKVuHWPPMbIVXU2tRKRzBCU+ONFzK7DBRnBvaViW+Iw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=rTJJRdipGbyJdoLg4yB8HOip/n3aT08WFt4qzFnLGl5bCEUlNEQPNdv7OWLXUpkqUfHMxZBHnwSRjHRY30G6IZrJ0hgl12oHvo8d++mDPK794Ccv7b+CrvVsXmfKPzchSGRPeI3MF6WR+SWj2hlsEkR1ABllq79Gyb1bG2WTWIc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=TxszwPgP; arc=none smtp.client-ip=91.218.175.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Date: Fri, 30 Jan 2026 18:21:37 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1769797302;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=20rbhSfsJOSLFEXhddqYXCozjH94/CkNxpK7Pk7mhbo=;
	b=TxszwPgPk5/8C7BVGk/nwuCO7H77Qn1eOZgwp1M5kjWp9mCFxeUiTSqJjChRMa46UciBGF
	ZHIgR2JpIVNSeUHvfjp48qia7VUZdWXsPZ44XnLQU4QAXjzL6ILEhYr3Rob+0PAD2FsFBg
	0F7B+Z6cIWxBpDMeY+ZxqHt6k5IRGL8=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Yosry Ahmed <yosry.ahmed@linux.dev>
To: Sean Christopherson <seanjc@google.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org, 
	linux-kernel@vger.kernel.org, Jim Mattson <jmattson@google.com>, 
	David Kaplan <david.kaplan@amd.com>
Subject: Re: [PATCH 1/2] KVM: x86: Defer IBPBs for vCPU and nested
 transitions until core run loop
Message-ID: <lgsgu5rxioy3zt67i6envq45mdvg2y3kxh26aw6qsqeqogbyho@al24pkui5lt2>
References: <20260128013432.3250805-1-seanjc@google.com>
 <20260128013432.3250805-2-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260128013432.3250805-2-seanjc@google.com>
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
	FORGED_SENDER_MAILLIST(0.00)[];
	TAGGED_FROM(0.00)[bounces-69746-lists,kvm=lfdr.de];
	TO_DN_SOME(0.00)[];
	MIME_TRACE(0.00)[0:+];
	FROM_HAS_DN(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	RCPT_COUNT_FIVE(0.00)[6];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[yosry.ahmed@linux.dev,kvm@vger.kernel.org];
	DKIM_TRACE(0.00)[linux.dev:+];
	NEURAL_HAM(-0.00)[-1.000];
	ASN(0.00)[asn:63949, ipnet:172.234.224.0/19, country:SG];
	TAGGED_RCPT(0.00)[kvm];
	MISSING_XM_UA(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[amd.com:email,sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns,linux.dev:email,linux.dev:dkim]
X-Rspamd-Queue-Id: 5C522BDAC4
X-Rspamd-Action: no action

On Tue, Jan 27, 2026 at 05:34:31PM -0800, Sean Christopherson wrote:
> When emitting an Indirect Branch Prediction Barrier to isolate different
> guest security domains (different vCPUs or L1 vs. L2 in the same vCPU),
> defer the IBPB until VM-Enter is imminent to avoid redundant and/or
> unnecessary IBPBs.  E.g. if a vCPU is loaded on a CPU without ever doing
> VM-Enter, then _KVM_ isn't responsible for doing an IBPB as KVM's job is
> purely to mitigate guests<=>guest attacks; guest=>host attacks are covered
> by IBRS.
> 
> Cc: stable@vger.kernel.org
> Cc: Yosry Ahmed <yosry.ahmed@linux.dev>
> Cc: Jim Mattson <jmattson@google.com>
> Cc: David Kaplan <david.kaplan@amd.com>
> Signed-off-by: Sean Christopherson <seanjc@google.com>
> ---
>  arch/x86/include/asm/kvm_host.h | 1 +
>  arch/x86/kvm/x86.c              | 7 ++++++-
>  arch/x86/kvm/x86.h              | 2 +-
>  3 files changed, 8 insertions(+), 2 deletions(-)
> 
> diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
> index e441f270f354..76bbc80a2d1d 100644
> --- a/arch/x86/include/asm/kvm_host.h
> +++ b/arch/x86/include/asm/kvm_host.h
> @@ -826,6 +826,7 @@ struct kvm_vcpu_arch {
>  	u64 smbase;
>  	u64 smi_count;
>  	bool at_instruction_boundary;
> +	bool need_ibpb;

We have IBPB_ON_VMEXIT, so this is a bit confusing, the reader could
assume this is an optimization for IBPB_ON_VMEXIT.

Maybe need_ibpb_on_vmenter or need_ibpb_on_run?

>  	bool tpr_access_reporting;
>  	bool xfd_no_write_intercept;
>  	u64 microcode_version;
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index 8acfdfc583a1..e5ae655702b4 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -5187,7 +5187,7 @@ void kvm_arch_vcpu_load(struct kvm_vcpu *vcpu, int cpu)
>  		 * is handled on the nested VM-Exit path.
>  		 */
>  		if (static_branch_likely(&switch_vcpu_ibpb))
> -			indirect_branch_prediction_barrier();
> +			vcpu->arch.need_ibpb = true;

This means that if we run vCPU A on a pCPU, then load vCPU B without
running it, we won't do an IBPB. At least not until vCPU B (or any vCPU)
actually runs on the pCPU.

My question would be, is it possible for training done by vCPU A to lead
KVM into leaking some of vCPU B's state after loading it, even without
actually running vCPU B?

Basically this scenario (all on the same pCPU):

1. Malicious vCPU A runs and injects branch predictor entries.

2. KVM loads vCPU B to perform some action without actually running
   vCPU B. The training from (1) leaks some of vCPU B's state into the
   microarchitectural state.

3. Malicious vCPU A runs again and extracts the leaked data.

>  		per_cpu(last_vcpu, cpu) = vcpu;
>  	}
>  
> @@ -11315,6 +11315,11 @@ static int vcpu_enter_guest(struct kvm_vcpu *vcpu)
>  		kvm_make_request(KVM_REQ_EVENT, vcpu);
>  	}
>  
> +	if (unlikely(vcpu->arch.need_ibpb)) {
> +		indirect_branch_prediction_barrier();
> +		vcpu->arch.need_ibpb = false;
> +	}
> +
>  	fpregs_assert_state_consistent();
>  	if (test_thread_flag(TIF_NEED_FPU_LOAD))
>  		switch_fpu_return();
> diff --git a/arch/x86/kvm/x86.h b/arch/x86/kvm/x86.h
> index 70e81f008030..6708142d051d 100644
> --- a/arch/x86/kvm/x86.h
> +++ b/arch/x86/kvm/x86.h
> @@ -169,7 +169,7 @@ static inline void kvm_nested_vmexit_handle_ibrs(struct kvm_vcpu *vcpu)
>  
>  	if (guest_cpu_cap_has(vcpu, X86_FEATURE_SPEC_CTRL) ||
>  	    guest_cpu_cap_has(vcpu, X86_FEATURE_AMD_IBRS))
> -		indirect_branch_prediction_barrier();
> +		vcpu->arch.need_ibpb = true;

I think the same question more-or-less applies here, could an L2 guest
lead KVM to leak some of L1's state before L1 is actually run? Although
in this case it could be harder for any leaked state to survive KVM
running L1 and then going back to L2.

>  }
>  
>  /*
> -- 
> 2.52.0.457.g6b5491de43-goog
> 

