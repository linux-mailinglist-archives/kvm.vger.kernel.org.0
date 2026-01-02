Return-Path: <kvm+bounces-66958-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [IPv6:2600:3c04:e001:36c::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id E2ECFCEF1D5
	for <lists+kvm@lfdr.de>; Fri, 02 Jan 2026 19:00:53 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 14A65300D306
	for <lists+kvm@lfdr.de>; Fri,  2 Jan 2026 18:00:47 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7C4B31A254E;
	Fri,  2 Jan 2026 18:00:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="YrJgOWb3"
X-Original-To: kvm@vger.kernel.org
Received: from out-172.mta0.migadu.com (out-172.mta0.migadu.com [91.218.175.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5654C221726
	for <kvm@vger.kernel.org>; Fri,  2 Jan 2026 18:00:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767376844; cv=none; b=hBfVuAG5m9Tukvx+Ovm6Hqe7S3LB6qzG7FwPa6GBRvUaGC8LcBkhu84y5BZJRBvwVhwPcs2K3p1N9ZLdnoUwibujbVzmWXPbqPm0ebhfoAG5KIrnAQeC/J4101UNXxQ6d6WluZqyLQWrzNJMvJfz6mf0DOK1tvhacubMt/IK5uc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767376844; c=relaxed/simple;
	bh=ngVYv/LeytLHBlQCp9cdf23wFxN0zFp6mFVxJEILIeA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=p5fJTeV6pAZoN9TPzMaBG6f1BgC7Q2jPEev6DvXk8v4UkpfjrOCHCP1ryaFuDKUrc91SPhND+yaHEEJu4tyvHjWc/x+Qx53Fs72XklxHa8mS66T/tWgduQsFW8LzFEX2293g/orprzxb9Q95YbYSl8xKr9gkKB3Y5WlJOAHLuXc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=YrJgOWb3; arc=none smtp.client-ip=91.218.175.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Date: Fri, 2 Jan 2026 18:00:32 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1767376839;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=B2HoAOMQmg2qcG0bIw0WFjm2Y3+8G6yx5RaP4t3SLos=;
	b=YrJgOWb3CFkdUBq6Kpb6Y0ChDy8LulOWQrWuF+hCrovupqsT1/3jt9nnGEe5p/DFk72zxA
	NmL+JeJykWJBym/uo0IgiZ71AEQN5oHRN/UZwUXO5YJvFmcFqRHbUpcQwDM+qdnnl8iecK
	gB5r9Jp7mzsDfS+OGklMrZ11IyVRoJ4=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Yosry Ahmed <yosry.ahmed@linux.dev>
To: Sean Christopherson <seanjc@google.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org, 
	linux-kernel@vger.kernel.org, Kevin Cheng <chengkev@google.com>
Subject: Re: [PATCH] KVM: x86: Disallow setting CPUID and/or feature MSRs if
 L2 is active
Message-ID: <shaevlgw5h7i3oxtoj6yqun3mklwdi6nng3noypxeqevnuqlcu@urfhn55x7owk>
References: <20251230205641.4092235-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251230205641.4092235-1-seanjc@google.com>
X-Migadu-Flow: FLOW_OUT

On Tue, Dec 30, 2025 at 12:56:41PM -0800, Sean Christopherson wrote:
> Extend KVM's restriction on CPUID and feature MSR changes to disallow
> updates while L2 is active in addition to rejecting updates after the vCPU
> has run at least once.  Like post-run vCPU model updates, attempting to
> react to model changes while L2 is active is practically infeasible, e.g.
> KVM would need to do _something_ in response to impossible situations where
> userspace has a removed a feature that was consumed as parted of nested
> VM-Enter.
> 
> In practice, disallowing vCPU model changes while L2 is active is largely
> uninteresting, as the only way for L2 to be active without the vCPU having
> run at least once is if userspace stuffed state via KVM_SET_NESTED_STATE.
> And because KVM_SET_NESTED_STATE can't put the vCPU into L2 without
> userspace first defining the vCPU model, e.g. to enable SVM/VMX, modifying
> the vCPU model while L2 is active would require deliberately setting the
> vCPU model, then loading nested state, and then changing the model.  I.e.
> no sane VMM should run afoul of the new restriction, and any VMM that does
> encounter problems has likely been running a broken setup for a long time.
> 
> Cc: Yosry Ahmed <yosry.ahmed@linux.dev>
> Cc: Kevin Cheng <chengkev@google.com>
> Signed-off-by: Sean Christopherson <seanjc@google.com>

I can't speak to the policy change, but the code looks correct (with a
minor nit below):

Reviewed-by: Yosry Ahmed <yosry.ahmed@linux.dev>

> ---
>  arch/x86/kvm/cpuid.c   | 19 +++++++++++--------
>  arch/x86/kvm/mmu/mmu.c |  6 +-----
>  arch/x86/kvm/pmu.c     |  2 +-
>  arch/x86/kvm/x86.c     | 13 +++++++------
>  arch/x86/kvm/x86.h     |  4 ++--
>  5 files changed, 22 insertions(+), 22 deletions(-)
> 
> diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
> index 88a5426674a1..f37331ad3ad8 100644
> --- a/arch/x86/kvm/cpuid.c
> +++ b/arch/x86/kvm/cpuid.c
> @@ -534,17 +534,20 @@ static int kvm_set_cpuid(struct kvm_vcpu *vcpu, struct kvm_cpuid_entry2 *e2,
>  	BUILD_BUG_ON(sizeof(vcpu_caps) != sizeof(vcpu->arch.cpu_caps));
>  
>  	/*
> -	 * KVM does not correctly handle changing guest CPUID after KVM_RUN, as
> -	 * MAXPHYADDR, GBPAGES support, AMD reserved bit behavior, etc.. aren't
> -	 * tracked in kvm_mmu_page_role.  As a result, KVM may miss guest page
> -	 * faults due to reusing SPs/SPTEs. In practice no sane VMM mucks with
> -	 * the core vCPU model on the fly. It would've been better to forbid any
> -	 * KVM_SET_CPUID{,2} calls after KVM_RUN altogether but unfortunately
> -	 * some VMMs (e.g. QEMU) reuse vCPU fds for CPU hotplug/unplug and do
> +	 * KVM does not correctly handle changing guest CPUID after KVM_RUN or
> +	 * while L2 is active, as MAXPHYADDR, GBPAGES support, AMD reserved bit
> +	 * behavior, etc. aren't tracked in kvm_mmu_page_role, and L2 state
> +	 * can't be adjusted (without breaking L2 in some way).  As a result,
> +	 * KVM may reuse SPs/SPTEs and/or run L2 with bad/misconfigured state.
> +	 *
> +	 * In practice, no sane VMM mucks with the core vCPU model on the fly.
> +	 * It would've been better to forbid any KVM_SET_CPUID{,2} calls after
> +	 * KVM_RUN or KVM_SET_NESTED_STATE altogether, but unfortunately some
> +	 * VMMs (e.g. QEMU) reuse vCPU fds for CPU hotplug/unplug and do
>  	 * KVM_SET_CPUID{,2} again. To support this legacy behavior, check
>  	 * whether the supplied CPUID data is equal to what's already set.
>  	 */
> -	if (kvm_vcpu_has_run(vcpu)) {
> +	if (!kvm_can_set_cpuid_and_feature_msrs(vcpu)) {
>  		r = kvm_cpuid_check_equal(vcpu, e2, nent);
>  		if (r)
>  			goto err;
> diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
> index 02c450686b4a..f17324546900 100644
> --- a/arch/x86/kvm/mmu/mmu.c
> +++ b/arch/x86/kvm/mmu/mmu.c
> @@ -6031,11 +6031,7 @@ void kvm_mmu_after_set_cpuid(struct kvm_vcpu *vcpu)
>  	vcpu->arch.nested_mmu.cpu_role.ext.valid = 0;
>  	kvm_mmu_reset_context(vcpu);
>  
> -	/*
> -	 * Changing guest CPUID after KVM_RUN is forbidden, see the comment in
> -	 * kvm_arch_vcpu_ioctl().
> -	 */
> -	KVM_BUG_ON(kvm_vcpu_has_run(vcpu), vcpu->kvm);
> +	KVM_BUG_ON(!kvm_can_set_cpuid_and_feature_msrs(vcpu), vcpu->kvm);
>  }
>  
>  void kvm_mmu_reset_context(struct kvm_vcpu *vcpu)
> diff --git a/arch/x86/kvm/pmu.c b/arch/x86/kvm/pmu.c
> index 487ad19a236e..ff20b4102173 100644
> --- a/arch/x86/kvm/pmu.c
> +++ b/arch/x86/kvm/pmu.c
> @@ -853,7 +853,7 @@ void kvm_pmu_refresh(struct kvm_vcpu *vcpu)
>  {
>  	struct kvm_pmu *pmu = vcpu_to_pmu(vcpu);
>  
> -	if (KVM_BUG_ON(kvm_vcpu_has_run(vcpu), vcpu->kvm))
> +	if (KVM_BUG_ON(!kvm_can_set_cpuid_and_feature_msrs(vcpu), vcpu->kvm))
>  		return;
>  
>  	/*
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index ff8812f3a129..211d8c24a4b1 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -2314,13 +2314,14 @@ static int do_set_msr(struct kvm_vcpu *vcpu, unsigned index, u64 *data)
>  	u64 val;
>  
>  	/*
> -	 * Disallow writes to immutable feature MSRs after KVM_RUN.  KVM does
> -	 * not support modifying the guest vCPU model on the fly, e.g. changing
> -	 * the nVMX capabilities while L2 is running is nonsensical.  Allow
> -	 * writes of the same value, e.g. to allow userspace to blindly stuff
> -	 * all MSRs when emulating RESET.
> +	 * Reject writes to immutable feature MSRs if the vCPU model is frozen,
> +	 * as KVM doesn't support modifying the guest vCPU model on the fly,
> +	 * e.g. changing the VMX capabilities MSRs while L2 is active is
> +	 * nonsensical.  Allow writes of the same value, e.g. so that userspace
> +	 * can blindly stuff all MSRs when emulating RESET.
>  	 */
> -	if (kvm_vcpu_has_run(vcpu) && kvm_is_immutable_feature_msr(index) &&
> +	if (!kvm_can_set_cpuid_and_feature_msrs(vcpu) &&
> +	    kvm_is_immutable_feature_msr(index) &&
>  	    (do_get_msr(vcpu, index, &val) || *data != val))
>  		return -EINVAL;
>  
> diff --git a/arch/x86/kvm/x86.h b/arch/x86/kvm/x86.h
> index fdab0ad49098..9084e0dfa15c 100644
> --- a/arch/x86/kvm/x86.h
> +++ b/arch/x86/kvm/x86.h
> @@ -172,9 +172,9 @@ static inline void kvm_nested_vmexit_handle_ibrs(struct kvm_vcpu *vcpu)
>  		indirect_branch_prediction_barrier();
>  }
>  
> -static inline bool kvm_vcpu_has_run(struct kvm_vcpu *vcpu)
> +static inline bool kvm_can_set_cpuid_and_feature_msrs(struct kvm_vcpu *vcpu)
>  {
> -	return vcpu->arch.last_vmentry_cpu != -1;
> +	return vcpu->arch.last_vmentry_cpu == -1 && !is_guest_mode(vcpu);
>  }

To make this self-contained (e.g. for readers not coming from
kvm_set_cpuid()), should we add a comment here about is_guest_mode()
only possibly being true with last_vmentry_cpu == -1 if userspace does
the set CPUID, set nested state, set CPUID again dance?

>  
>  static inline void kvm_set_mp_state(struct kvm_vcpu *vcpu, int mp_state)
> 
> base-commit: 9448598b22c50c8a5bb77a9103e2d49f134c9578
> -- 
> 2.52.0.351.gbe84eed79e-goog
> 

