Return-Path: <kvm+bounces-43815-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id EE00DA9657B
	for <lists+kvm@lfdr.de>; Tue, 22 Apr 2025 12:10:01 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id C1FAB189D375
	for <lists+kvm@lfdr.de>; Tue, 22 Apr 2025 10:10:12 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5CD8B2147E6;
	Tue, 22 Apr 2025 10:08:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="b/bC3Usk"
X-Original-To: kvm@vger.kernel.org
Received: from out-171.mta1.migadu.com (out-171.mta1.migadu.com [95.215.58.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 53B561F12FC;
	Tue, 22 Apr 2025 10:08:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745316530; cv=none; b=r4IJdu3IK66eWRR9O3egJAQCVR49SFj6uA20c4mgu4Tu5H+EkAP8Cs0EAXGsHyY93yolLsUqMcATCAapog0AbDS1MnvurA6ro2DTqqjyfzkuSO9IqVEiROy10SlS/SLTGfUck0SvKt//2oBRUs5vcU7bMR8X5/JSYa5NYRnnbWg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745316530; c=relaxed/simple;
	bh=h4N7Dko8R6UGn+qNGPyVQVMY0w62iCT+zo+1WX5kD7k=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=eWY2XsUi/FfD+gbkw9PRkF679a6OyvDp7ieIVdeSI+EC8P05u+w4GavMEJ2abhuk9a56+xCuvwISG9/mY1wJh9iRyqjq3nSb8l4OikiHBSEulcsbsL1p/72qPvxvD6WDf6a1dRrodZpv3Rlp54+/CHweTWaqamMRgVfS80Ym+ag=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=b/bC3Usk; arc=none smtp.client-ip=95.215.58.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Date: Tue, 22 Apr 2025 03:08:39 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1745316525;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=dpgN1iCHtrzufW+DbgbyyyVHThOJ+H9TFWEBE9Mxrfs=;
	b=b/bC3UskRDd9sIGVMmiTVXo06tx2uWcD/PMRYbCjerpzzJadyGWzd0yQkCRbXjiuz01oSu
	nD+hOzLDSVIQ4PyP+kO7FDULeY6FfVFAVUmsQr8tKfK73/5jyC+b4P3w5733wPkXo338vz
	I0qnErijkyvXTSqfVjIx2nBdZai/rFY=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Yosry Ahmed <yosry.ahmed@linux.dev>
To: Maxim Levitsky <mlevitsk@redhat.com>
Cc: Sean Christopherson <seanjc@google.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Jim Mattson <jmattson@google.com>,
	Vitaly Kuznetsov <vkuznets@redhat.com>,
	Rik van Riel <riel@surriel.com>,
	Tom Lendacky <thomas.lendacky@amd.com>, x86@kernel.org,
	kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH 11/24] KVM: nSVM: Use a separate ASID for nested
 guests
Message-ID: <aAdqpxHFZ2r1OkFW@Asmaa.>
References: <20250326193619.3714986-1-yosry.ahmed@linux.dev>
 <20250326193619.3714986-12-yosry.ahmed@linux.dev>
 <45e6e250e5bc51d2b0a8490f31e2144054990b82.camel@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <45e6e250e5bc51d2b0a8490f31e2144054990b82.camel@redhat.com>
X-Migadu-Flow: FLOW_OUT

On Thu, Apr 03, 2025 at 04:09:30PM -0400, Maxim Levitsky wrote:
> On Wed, 2025-03-26 at 19:36 +0000, Yosry Ahmed wrote:
> > The per-VM ASID is currently shared by both L1 and L2 guests. That ASID
> > is currently flushed on every transition between L1 and L2.
> > 
> > Allocate and track a separate ASID per-VM for nested guests. This is in
> > preparation for doing fine-grained TLB flushes on nested transitions
> > instead of unconditional full flushes.
> > 
> > Nested ASIDs are still not fully maintained (e.g. a remote flush will
> > only flush the current ASID), so keep the TLB flush on every transition
> > until this is sorted out in following changes.
> > 
> > Add a helper to get the ASID associated with a specific VMCB and use it
> > instead of directly reading the VM's ASID. This transparently uses L2's
> > ASID when an L2 guest is being run.
> > 
> > L1's ASID is flushed on KVM_REQ_TLB_FLUSH_GUEST if it is the active
> > context, so remove the TODO in nested_svm_transition_tlb_flush() about
> > it.
> > 
> > Signed-off-by: Yosry Ahmed <yosry.ahmed@linux.dev>
> > ---
> >  arch/x86/kvm/svm/nested.c |  8 ++++++--
> >  arch/x86/kvm/svm/svm.c    | 13 +++++++++++--
> >  arch/x86/kvm/svm/svm.h    |  3 ++-
> >  3 files changed, 19 insertions(+), 5 deletions(-)
> > 
> > diff --git a/arch/x86/kvm/svm/nested.c b/arch/x86/kvm/svm/nested.c
> > index 81184b2fb27fd..75223869aa8c6 100644
> > --- a/arch/x86/kvm/svm/nested.c
> > +++ b/arch/x86/kvm/svm/nested.c
> > @@ -495,7 +495,6 @@ static void nested_svm_transition_tlb_flush(struct kvm_vcpu *vcpu)
> >  	 *  - Honor L1's request to flush an ASID on nested VMRUN
> >  	 *  - Sync nested NPT MMU on VMRUN that flushes L2's ASID[*]
> >  	 *  - Don't crush a pending TLB flush in vmcb02 on nested VMRUN
> > -	 *  - Flush L1's ASID on KVM_REQ_TLB_FLUSH_GUEST
> >  	 *
> >  	 * [*] Unlike nested EPT, SVM's ASID management can invalidate nested
> >  	 *     NPT guest-physical mappings on VMRUN.
> > @@ -677,7 +676,7 @@ static void nested_vmcb02_prepare_control(struct vcpu_svm *svm,
> >  	vmcb02->control.nested_ctl = vmcb01->control.nested_ctl;
> >  	vmcb02->control.iopm_base_pa = vmcb01->control.iopm_base_pa;
> >  	vmcb02->control.msrpm_base_pa = vmcb01->control.msrpm_base_pa;
> > -	vmcb02->control.asid = svm_asid(vcpu->kvm);
> > +	vmcb02->control.asid = svm_nested_asid(vcpu->kvm);
> >  
> >  	/* Also overwritten later if necessary.  */
> >  	vmcb_clr_flush_asid(vmcb02);
> > @@ -1179,6 +1178,7 @@ static void nested_svm_triple_fault(struct kvm_vcpu *vcpu)
> >  
> >  int svm_allocate_nested(struct vcpu_svm *svm)
> >  {
> > +	struct kvm_svm *kvm_svm = to_kvm_svm(svm->vcpu.kvm);
> >  	struct page *vmcb02_page;
> >  
> >  	if (svm->nested.initialized)
> > @@ -1196,6 +1196,10 @@ int svm_allocate_nested(struct vcpu_svm *svm)
> >  	svm_vcpu_init_msrpm(&svm->vcpu, svm->nested.msrpm);
> >  
> >  	svm->nested.initialized = true;
> > +
> > +	if (!kvm_svm->nested_asid)
> > +		kvm_svm->nested_asid = kvm_svm->asid;
> 
> Nitpick: maybe put nested_asid into .nested struct as well?
> I don't have a strong option on this, feel free to leave it where it is now.

I did this initially but I thought created a struct just for the purpose
of holding the nested ASID would be an overkill, but I don't feel
strongly.

> 
> 
> > +
> >  	return 0;
> >  
> >  err_free_vmcb02:
> > diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
> > index f028d006f69dc..e664d8428c792 100644
> > --- a/arch/x86/kvm/svm/svm.c
> > +++ b/arch/x86/kvm/svm/svm.c
> > @@ -1225,17 +1225,26 @@ static inline void init_vmcb_after_set_cpuid(struct kvm_vcpu *vcpu)
> >  	}
> >  }
> >  
> > -unsigned int svm_asid(struct kvm *kvm)
> > +unsigned int svm_nested_asid(struct kvm *kvm)
> > +{
> > +	return to_kvm_svm(kvm)->nested_asid;
> > +}
> 
> It might also make sense to add WARN_ON_ONCE(!svm->nested.initialized) here, just in case.

Yeah we can do that, but I will check the callers first to make sure
there's no chance of false positives.

> 
> > +
> > +static unsigned int svm_asid(struct kvm *kvm)
> >  {
> >  	return to_kvm_svm(kvm)->asid;
> >  }
> >  
> >  static unsigned int svm_get_current_asid(struct vcpu_svm *svm)
> >  {
> > -	struct kvm *kvm = svm->vcpu.kvm;
> > +	struct kvm_vcpu *vcpu = &svm->vcpu;
> > +	struct kvm *kvm = vcpu->kvm;
> >  
> >  	if (sev_guest(kvm))
> >  		return sev_get_asid(kvm);
> > +	if (is_guest_mode(vcpu))
> > +		return svm_nested_asid(kvm);
> > +	WARN_ON_ONCE(svm->current_vmcb != &svm->vmcb01);
> >  	return svm_asid(kvm);
> >  }
> >  
> > diff --git a/arch/x86/kvm/svm/svm.h b/arch/x86/kvm/svm/svm.h
> > index 436b7e83141b9..e67e3a64e92f7 100644
> > --- a/arch/x86/kvm/svm/svm.h
> > +++ b/arch/x86/kvm/svm/svm.h
> > @@ -118,6 +118,7 @@ struct kvm_svm {
> >  	struct kvm kvm;
> >  
> >  	unsigned int asid;
> > +	unsigned int nested_asid;
> >  
> >  	/* Struct members for AVIC */
> >  	u32 avic_vm_id;
> > @@ -651,7 +652,7 @@ void svm_complete_interrupt_delivery(struct kvm_vcpu *vcpu, int delivery_mode,
> >  				     int trig_mode, int vec);
> >  bool svm_register_asid(unsigned int asid);
> >  void svm_unregister_asid(unsigned int asid);
> > -unsigned int svm_asid(struct kvm *kvm);
> > +unsigned int svm_nested_asid(struct kvm *kvm);
> >  
> >  /* nested.c */
> >  
> 
> 
> Overall looks good,
> 
> Reviewed-by: Maxim Levitsky <mlevitsk@redhat.com>

Thanks!

> 
> Best regards,
> 	Maxim Levitsky
> 
> 
> 

