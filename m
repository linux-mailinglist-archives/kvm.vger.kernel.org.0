Return-Path: <kvm+bounces-39931-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id F2673A4CDE4
	for <lists+kvm@lfdr.de>; Mon,  3 Mar 2025 23:10:30 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id D1B217A86EA
	for <lists+kvm@lfdr.de>; Mon,  3 Mar 2025 22:09:29 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8313F225390;
	Mon,  3 Mar 2025 22:10:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="XnGLIOrR"
X-Original-To: kvm@vger.kernel.org
Received: from out-170.mta0.migadu.com (out-170.mta0.migadu.com [91.218.175.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 725CC1EE00D
	for <kvm@vger.kernel.org>; Mon,  3 Mar 2025 22:10:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741039819; cv=none; b=N4wg7Wh5iXIxkJzreVWf8p7REG7U829Eo5hvrj05S9/L7eZ+49++P0rjy7nSW4zNZuzcHXXZ68STc56oRftz8TRXfIdxl/b9tWzYl0r7+n8oTV4ZXkmBaT12r+wI6EwxnTVd7DGQtLuxuxpjChIr/XxfHT4YIgrmv86Q9VPxMGA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741039819; c=relaxed/simple;
	bh=Fq+aPCle+1rzMj5GZ0Hr68ErMZvpgCUwbKsGXlweaOA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=mb2u+KTKUXVep79pjU5YQlLSA9BHFJ0NZYo0MfJ++NtAKC0uOgLfBbW2Xz0rP/0HCkxI4DPZELgVbPOTAXqpa+a3B6H0L9HLZpqzHB1397uGemCcQaDRNsL/N10d8BzojrOJ2GF1WfNthDYz6VFnmzR9O8zNTmW3ndv8EkgePUE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=XnGLIOrR; arc=none smtp.client-ip=91.218.175.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Date: Mon, 3 Mar 2025 22:10:07 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1741039811;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=9yFPBBYOAYAtyEgP77LACsnC4woQs7RcjDSHEfoMl1w=;
	b=XnGLIOrR78h89TYst5HZrtxIIBxdd+8cPuZgw+LfrRXGmbmKZYiRPOPxz9VCWooqTqgxXh
	54p+YbOSeq1O3vrdyaZbsxJsTONtHR8h04QXr+e4rxusDy1hgVOdRVRF1gr/i4qq68nfuD
	qtl6Ffgu1+Sifk/0vzsln+oMjuOq48w=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Yosry Ahmed <yosry.ahmed@linux.dev>
To: Maxim Levitsky <mlevitsk@redhat.com>
Cc: Sean Christopherson <seanjc@google.com>,
	Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH 09/13] KVM: nSVM: Handle nested TLB flush requests
 through TLB_CONTROL
Message-ID: <Z8Yovz0I3QLuq6VQ@google.com>
References: <20250205182402.2147495-1-yosry.ahmed@linux.dev>
 <20250205182402.2147495-10-yosry.ahmed@linux.dev>
 <2dfc8e02c16e78989bee94893cc48d531cdfa909.camel@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2dfc8e02c16e78989bee94893cc48d531cdfa909.camel@redhat.com>
X-Migadu-Flow: FLOW_OUT

On Fri, Feb 28, 2025 at 09:06:18PM -0500, Maxim Levitsky wrote:
> On Wed, 2025-02-05 at 18:23 +0000, Yosry Ahmed wrote:
> > Handle L1's requests to flush L2's TLB through the TLB_CONTROL field of
> > VMCB12. This is currently redundant because a full flush is executed on
> > every nested transition, but is a step towards removing that.
> > 
> > TLB_CONTROL_FLUSH_ALL_ASID flushes all ASIDs from L1's perspective,
> > including its own, so do a guest TLB flush on both transitions. Never
> > propagate TLB_CONTROL_FLUSH_ALL_ASID from the guest to the actual VMCB,
> > as this gives the guest the power to flush the entire physical TLB
> > (including translations for the host and other VMs).
> > 
> > For other cases, the TLB flush is only done when entering L2. The nested
> > NPT MMU is also sync'd because TLB_CONTROL also flushes NPT
> > guest-physical mappings.
> > 
> > All TLB_CONTROL values can be handled by KVM regardless of FLUSHBYASID
> > support on the underlying CPU, so keep advertising FLUSHBYASID to the
> > guest unconditionally.
> > 
> > Signed-off-by: Yosry Ahmed <yosry.ahmed@linux.dev>
> > ---
> >  arch/x86/kvm/svm/nested.c | 42 ++++++++++++++++++++++++++++++++-------
> >  arch/x86/kvm/svm/svm.c    |  6 +++---
> >  2 files changed, 38 insertions(+), 10 deletions(-)
> > 
> > diff --git a/arch/x86/kvm/svm/nested.c b/arch/x86/kvm/svm/nested.c
> > index 0735177b95a1d..e2c59eb2907e8 100644
> > --- a/arch/x86/kvm/svm/nested.c
> > +++ b/arch/x86/kvm/svm/nested.c
> > @@ -484,19 +484,36 @@ static void nested_save_pending_event_to_vmcb12(struct vcpu_svm *svm,
> >  
> >  static void nested_svm_entry_tlb_flush(struct kvm_vcpu *vcpu)
> >  {
> > +	struct vcpu_svm *svm = to_svm(vcpu);
> > +
> >  	/* Handle pending Hyper-V TLB flush requests */
> >  	kvm_hv_nested_transtion_tlb_flush(vcpu, npt_enabled);
> >  
> > +	/*
> > +	 * If L1 requested a TLB flush for L2, flush L2's TLB on nested entry
> > +	 * and sync the nested NPT MMU, as TLB_CONTROL also flushes NPT
> > +	 * guest-physical mappings. We technically only need to flush guest_mode
> > +	 * page tables.
> > +	 *
> > +	 * KVM_REQ_TLB_FLUSH_GUEST will flush L2's ASID even if the underlying
> > +	 * CPU does not support FLUSHBYASID (by assigning a new ASID), so we
> > +	 * can handle all TLB_CONTROL values from L1 regardless.
> > +	 *
> > +	 * Note that TLB_CONTROL_FLUSH_ASID_LOCAL is handled exactly like
> > +	 * TLB_CONTROL_FLUSH_ASID. We can technically flush less TLB entries,
> > +	 * but this would require significantly more complexity.
> > +	 */
> 
> I think it might make sense to note that we in essence support only one non zero ASID
> in L1, the one that it picks for the nested guest.
> 
> 
> Thus when asked to TLB_CONTROL_FLUSH_ALL_ASID 
> we need to flush the L2's real asid and L1 asid only.

This is described by the comment in nested_svm_exit_tlb_flush(). Do you
mean that we should also mention that here?

I guess one way to make things clearer is to describe the behavior for
all values of TLB_CONTROL here, and in nested_svm_exit_tlb_flush() just
say /* see nested_svm_entry_tlb_flush() */. Would that improve things?

> 
> 
> > +	if (svm->nested.ctl.tlb_ctl != TLB_CONTROL_DO_NOTHING) {
> > +		if (nested_npt_enabled(svm))
> > +			kvm_make_request(KVM_REQ_MMU_SYNC, vcpu);
> > +		kvm_make_request(KVM_REQ_TLB_FLUSH_GUEST, vcpu);
> > +	}
> > +
> >  	/*
> >  	 * TODO: optimize unconditional TLB flush/MMU sync.  A partial list of
> >  	 * things to fix before this can be conditional:
> >  	 *
> > -	 *  - Honor L1's request to flush an ASID on nested VMRUN
> > -	 *  - Sync nested NPT MMU on VMRUN that flushes L2's ASID[*]
> >  	 *  - Don't crush a pending TLB flush in vmcb02 on nested VMRUN
> > -	 *
> > -	 * [*] Unlike nested EPT, SVM's ASID management can invalidate nested
> > -	 *     NPT guest-physical mappings on VMRUN.
> >  	 */
> >  	kvm_make_request(KVM_REQ_MMU_SYNC, vcpu);
> >  	kvm_make_request(KVM_REQ_TLB_FLUSH_CURRENT, vcpu);
> > @@ -504,9 +521,18 @@ static void nested_svm_entry_tlb_flush(struct kvm_vcpu *vcpu)
> >  
> >  static void nested_svm_exit_tlb_flush(struct kvm_vcpu *vcpu)
> >  {
> > +	struct vcpu_svm *svm = to_svm(vcpu);
> > +
> >  	/* Handle pending Hyper-V TLB flush requests */
> >  	kvm_hv_nested_transtion_tlb_flush(vcpu, npt_enabled);
> >  
> > +	/*
> > +	 * If L1 had requested a full TLB flush when entering L2, also flush its
> > +	 * TLB entries when exiting back to L1.
> > +	 */
> > +	if (svm->nested.ctl.tlb_ctl == TLB_CONTROL_FLUSH_ALL_ASID)
> > +		kvm_make_request(KVM_REQ_TLB_FLUSH_GUEST, vcpu);
> 
> Makes sense.
> 
> > +
> >  	/* See nested_svm_entry_tlb_flush() */
> >  	kvm_make_request(KVM_REQ_MMU_SYNC, vcpu);
> >  	kvm_make_request(KVM_REQ_TLB_FLUSH_CURRENT, vcpu);
> > @@ -825,7 +851,8 @@ int enter_svm_guest_mode(struct kvm_vcpu *vcpu, u64 vmcb12_gpa,
> >  	nested_svm_copy_common_state(svm->vmcb01.ptr, svm->nested.vmcb02.ptr);
> >  
> >  	svm_switch_vmcb(svm, &svm->nested.vmcb02);
> > -	nested_vmcb02_prepare_control(svm, vmcb12->save.rip, vmcb12->save.cs.base);
> > +	nested_vmcb02_prepare_control(svm, vmcb12->save.rip,
> > +				      vmcb12->save.cs.base);
> >  	nested_vmcb02_prepare_save(svm, vmcb12);
> >  
> >  	ret = nested_svm_load_cr3(&svm->vcpu, svm->nested.save.cr3,
> > @@ -1764,7 +1791,8 @@ static int svm_set_nested_state(struct kvm_vcpu *vcpu,
> >  	nested_copy_vmcb_control_to_cache(svm, ctl);
> >  
> >  	svm_switch_vmcb(svm, &svm->nested.vmcb02);
> > -	nested_vmcb02_prepare_control(svm, svm->vmcb->save.rip, svm->vmcb->save.cs.base);
> > +	nested_vmcb02_prepare_control(svm, svm->vmcb->save.rip,
> > +				      svm->vmcb->save.cs.base);
> >  
> >  	/*
> >  	 * While the nested guest CR3 is already checked and set by
> > diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
> > index 8342c7eadbba8..5e7b1c9bfa605 100644
> > --- a/arch/x86/kvm/svm/svm.c
> > +++ b/arch/x86/kvm/svm/svm.c
> > @@ -5242,9 +5242,9 @@ static __init void svm_set_cpu_caps(void)
> >  		kvm_cpu_cap_set(X86_FEATURE_VMCBCLEAN);
> >  
> >  		/*
> > -		 * KVM currently flushes TLBs on *every* nested SVM transition,
> > -		 * and so for all intents and purposes KVM supports flushing by
> > -		 * ASID, i.e. KVM is guaranteed to honor every L1 ASID flush.
> > +		 * KVM currently handles all TLB_CONTROL values set by L1, even
> > +		 * if the underlying CPU does not. See
> > +		 * nested_svm_transition_tlb_flush().
> >  		 */
> >  		kvm_cpu_cap_set(X86_FEATURE_FLUSHBYASID);
> >  
> 
> Patch looks OK, but I can't be 100% sure about this.
> 
> Reviewed-by: Maxim Levitsky <mlevitsk@redhat.com>
> 
> Best regards,
> 	Maxim Levitsky
> 
> 

