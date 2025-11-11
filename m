Return-Path: <kvm+bounces-62699-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [IPv6:2605:f480:58:1:0:1994:3:14])
	by mail.lfdr.de (Postfix) with ESMTPS id 8C19AC4B499
	for <lists+kvm@lfdr.de>; Tue, 11 Nov 2025 04:11:53 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id AF5F24EE627
	for <lists+kvm@lfdr.de>; Tue, 11 Nov 2025 03:11:46 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 33FED3491F2;
	Tue, 11 Nov 2025 03:11:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="Skm0YYT0"
X-Original-To: kvm@vger.kernel.org
Received: from out-174.mta1.migadu.com (out-174.mta1.migadu.com [95.215.58.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 193FE31D36C
	for <kvm@vger.kernel.org>; Tue, 11 Nov 2025 03:11:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762830701; cv=none; b=K9QLWBJM6Dyisb7cHgaZuNIvGfmdYpF6zjeDibjF8EjyIMLjDgzQqAu0Y0EX/4SBrm5Dfhu2GOO95GVUlgpxzYiI7qL1zNJuUwfHlWq6vvoSICBVSrT1EphJ3mwFI7CZ1Cw0Q5drIdljSySLyJEiwv2eQLxb/oJcdM2xMMb+bGE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762830701; c=relaxed/simple;
	bh=USQ/wPIxJAH7GpbX1QvZ9fIFzSecnN5IjUXB8iXX3c8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=oBQGiEN2MMYtdAyomC9BYc5NbA4P2kJ3uRZdfyHtRAPjZGeYl5F8wZK/IdJGhQ6vA8jcs0iWR52jvF45Pi+B+ILiEvE/g0MyCmaTW2B5/InYqMAw0PqTZmdJsM/4OsP2rtE6EnGOol/NPEuaSmAVMoLEKCoKr7LA7iWJmkAVYp8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=Skm0YYT0; arc=none smtp.client-ip=95.215.58.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Date: Tue, 11 Nov 2025 03:11:13 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1762830697;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=nsHIXl5EhCMyskzxVvo+4ZfHKMb5wMbNpmFMAwBDo4w=;
	b=Skm0YYT0GvoNOhWH+pV+5oS3eT6o/vfhrBCrwz4PAbh5hutD72prIuTz1K1g30Y2d+DXpn
	aTB/1KO9T+o6lelML5jc9RLKsyHEEi183Fdf14U1ZEPqfmISiyAhvTnq1ZoKMlARBk5djB
	fJl0ZZwrTwkZw+czg+0UgyWfDX4leUc=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Yosry Ahmed <yosry.ahmed@linux.dev>
To: Sean Christopherson <seanjc@google.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, Jim Mattson <jmattson@google.com>, 
	Maxim Levitsky <mlevitsk@redhat.com>, kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	stable@vger.kernel.org
Subject: Re: [PATCH 2/6] KVM: nSVM: Always recalculate LBR MSR intercepts in
 svm_update_lbrv()
Message-ID: <aktjuidgjmdqdlc42mmy4hby5zc2e5at7lgrmkfxavlzusveus@ai7h3sk6j37b>
References: <20251108004524.1600006-1-yosry.ahmed@linux.dev>
 <20251108004524.1600006-3-yosry.ahmed@linux.dev>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251108004524.1600006-3-yosry.ahmed@linux.dev>
X-Migadu-Flow: FLOW_OUT

On Sat, Nov 08, 2025 at 12:45:20AM +0000, Yosry Ahmed wrote:
> svm_update_lbrv() is called when MSR_IA32_DEBUGCTLMSR is updated, and on
> nested transitions where LBRV is used. It checks whether LBRV enablement
> needs to be changed in the current VMCB, and if it does, it also
> recalculate intercepts to LBR MSRs.
> 
> However, there are cases where intercepts need to be updated even when
> LBRV enablement doesn't. Example scenario:
> - L1 has MSR_IA32_DEBUGCTLMSR cleared.
> - L1 runs L2 without LBR_CTL_ENABLE (no LBRV).
> - L2 sets DEBUGCTLMSR_LBR in MSR_IA32_DEBUGCTLMSR, svm_update_lbrv()
>   sets LBR_CTL_ENABLE in VMCB02 and disables intercepts to LBR MSRs.
> - L2 exits to L1, svm_update_lbrv() is not called on this transition.
> - L1 clears MSR_IA32_DEBUGCTLMSR, svm_update_lbrv() finds that
>   LBR_CTL_ENABLE is already cleared in VMCB01 and does nothing.
> - Intercepts remain disabled, L1 reads to LBR MSRs read the host MSRs.
> 
> Fix it by always recalculating intercepts in svm_update_lbrv().

This actually breaks hyperv_svm_test, because svm_update_lbrv() is
called on every nested transition, calling
svm_recalc_lbr_msr_intercepts() -> svm_set_intercept_for_msr() and
setting svm->nested.force_msr_bitmap_recalc to true.

This breaks the hyperv optimization in nested_svm_vmrun_msrpm() AFAICT.

I think there are two ways to fix this:
- Add another bool to svm->nested to track LBR intercepts, and only call
  svm_set_intercept_for_msr() if the intercepts need to be updated.

- Update svm_set_intercept_for_msr() itself to do nothing if the
  intercepts do not need to be changed, which is more clutter but
  applies to other callers as well so could shave cycles elsewhere (see
  below).

Sean, Paolo, any preferences?

Here's what updating svm_set_intercept_for_msr() looks like:

diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index 2fbb0b88c6a3e..b1afafc8b37c0 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -664,24 +664,36 @@ void svm_set_intercept_for_msr(struct kvm_vcpu *vcpu, u32 msr, int type, bool se
 {
        struct vcpu_svm *svm = to_svm(vcpu);
        void *msrpm = svm->msrpm;
+       bool recalc = false;
+       bool already_set;

        /* Don't disable interception for MSRs userspace wants to handle. */
        if (type & MSR_TYPE_R) {
-               if (!set && kvm_msr_allowed(vcpu, msr, KVM_MSR_FILTER_READ))
+               already_set = svm_test_msr_bitmap_read(msrpm, msr);
+               if (!set && already_set && kvm_msr_allowed(vcpu, msr, KVM_MSR_FILTER_READ)) {
                        svm_clear_msr_bitmap_read(msrpm, msr);
-               else
+                       recalc = true;
+               } else if (set && !already_set) {
                        svm_set_msr_bitmap_read(msrpm, msr);
+                       recalc = true;
+               }
        }

        if (type & MSR_TYPE_W) {
-               if (!set && kvm_msr_allowed(vcpu, msr, KVM_MSR_FILTER_WRITE))
+               already_set = svm_test_msr_bitmap_write(msrpm, msr);
+               if (!set && already_set && kvm_msr_allowed(vcpu, msr, KVM_MSR_FILTER_WRITE)) {
                        svm_clear_msr_bitmap_write(msrpm, msr);
-               else
+                       recalc = true;
+               } else if (set && !already_set) {
                        svm_set_msr_bitmap_write(msrpm, msr);
+                       recalc = true;
+               }
        }

-       svm_hv_vmcb_dirty_nested_enlightenments(vcpu);
-       svm->nested.force_msr_bitmap_recalc = true;
+       if (recalc) {
+               svm_hv_vmcb_dirty_nested_enlightenments(vcpu);
+               svm->nested.force_msr_bitmap_recalc = true;
+       }
 }

 void *svm_alloc_permissions_map(unsigned long size, gfp_t gfp_mask)

> 
> Fixes: 1d5a1b5860ed ("KVM: x86: nSVM: correctly virtualize LBR msrs when L2 is running")
> Cc: stable@vger.kernel.org
> 
> Signed-off-by: Yosry Ahmed <yosry.ahmed@linux.dev>
> ---
>  arch/x86/kvm/svm/svm.c | 29 +++++++++++++++++++----------
>  1 file changed, 19 insertions(+), 10 deletions(-)
> 
> diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
> index d25c56b30b4e2..26ab75ecf1c67 100644
> --- a/arch/x86/kvm/svm/svm.c
> +++ b/arch/x86/kvm/svm/svm.c
> @@ -806,25 +806,29 @@ void svm_copy_lbrs(struct vmcb *to_vmcb, struct vmcb *from_vmcb)
>  	vmcb_mark_dirty(to_vmcb, VMCB_LBR);
>  }
>  
> -void svm_enable_lbrv(struct kvm_vcpu *vcpu)
> +static void __svm_enable_lbrv(struct kvm_vcpu *vcpu)
>  {
>  	struct vcpu_svm *svm = to_svm(vcpu);
>  
>  	svm->vmcb->control.virt_ext |= LBR_CTL_ENABLE_MASK;
> -	svm_recalc_lbr_msr_intercepts(vcpu);
>  
>  	/* Move the LBR msrs to the vmcb02 so that the guest can see them. */
>  	if (is_guest_mode(vcpu))
>  		svm_copy_lbrs(svm->vmcb, svm->vmcb01.ptr);
>  }
>  
> -static void svm_disable_lbrv(struct kvm_vcpu *vcpu)
> +void svm_enable_lbrv(struct kvm_vcpu *vcpu)
> +{
> +	__svm_enable_lbrv(vcpu);
> +	svm_recalc_lbr_msr_intercepts(vcpu);
> +}
> +
> +static void __svm_disable_lbrv(struct kvm_vcpu *vcpu)
>  {
>  	struct vcpu_svm *svm = to_svm(vcpu);
>  
>  	KVM_BUG_ON(sev_es_guest(vcpu->kvm), vcpu->kvm);
>  	svm->vmcb->control.virt_ext &= ~LBR_CTL_ENABLE_MASK;
> -	svm_recalc_lbr_msr_intercepts(vcpu);
>  
>  	/*
>  	 * Move the LBR msrs back to the vmcb01 to avoid copying them
> @@ -853,13 +857,18 @@ void svm_update_lbrv(struct kvm_vcpu *vcpu)
>  			    (is_guest_mode(vcpu) && guest_cpu_cap_has(vcpu, X86_FEATURE_LBRV) &&
>  			    (svm->nested.ctl.virt_ext & LBR_CTL_ENABLE_MASK));
>  
> -	if (enable_lbrv == current_enable_lbrv)
> -		return;
> +	if (enable_lbrv && !current_enable_lbrv)
> +		__svm_enable_lbrv(vcpu);
> +	else if (!enable_lbrv && current_enable_lbrv)
> +		__svm_disable_lbrv(vcpu);
>  
> -	if (enable_lbrv)
> -		svm_enable_lbrv(vcpu);
> -	else
> -		svm_disable_lbrv(vcpu);
> +	/*
> +	 * During nested transitions, it is possible that the current VMCB has
> +	 * LBR_CTL set, but the previous LBR_CTL had it cleared (or vice versa).
> +	 * In this case, even though LBR_CTL does not need an update, intercepts
> +	 * do, so always recalculate the intercepts here.
> +	 */
> +	svm_recalc_lbr_msr_intercepts(vcpu);
>  }
>  
>  void disable_nmi_singlestep(struct vcpu_svm *svm)
> -- 
> 2.51.2.1041.gc1ab5b90ca-goog
> 

