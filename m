Return-Path: <kvm+bounces-65798-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [IPv6:2600:3c04:e001:36c::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 922CCCB7213
	for <lists+kvm@lfdr.de>; Thu, 11 Dec 2025 21:13:57 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 13AC330146E4
	for <lists+kvm@lfdr.de>; Thu, 11 Dec 2025 20:13:55 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 31304315760;
	Thu, 11 Dec 2025 20:13:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="DI3k+YuT"
X-Original-To: kvm@vger.kernel.org
Received: from out-185.mta0.migadu.com (out-185.mta0.migadu.com [91.218.175.185])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 30CC431AAB1
	for <kvm@vger.kernel.org>; Thu, 11 Dec 2025 20:13:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.185
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765484031; cv=none; b=hTG9swOggG+XoFrmIt8TxhsUMzi7pD0sVRYj2IIl4vbkjTLn66gx70FSAFvthoxFNlTPVafthYiaeK26UWFu7nYjH4H8hVT8kaRmdRushe5p54TLjKqZmX1IrVkPIoKtd+Bsfij9/4df/gDIyxM1TV6npGrxruxApYHpGZQfuYg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765484031; c=relaxed/simple;
	bh=3x6Ht5OPL63/9Dv+kzLaTxMjY2nYzAqEO5QUkqmb/LM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ti+jiAO82rCm+JKLNN/Pq6WaFOEXmXT5GesHZzbVYEGp3UYZh60YtiPKORJi7ls+4s5mduOOHNDt7iP9xPCdCjoRYz+DtNeKELvM8a43RfY9iKzjbz7+F25gGH4vaSaBHtGUwjZ9kwZq26qLSXUjsAG38fpcZEtZ9gGd4CBiQKw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=DI3k+YuT; arc=none smtp.client-ip=91.218.175.185
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Date: Thu, 11 Dec 2025 20:13:33 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1765484017;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=zDJHPh6wPxNqP62Agj95CIdsATiMhAQlhN1KJXsSG2A=;
	b=DI3k+YuTlLOxy/7BBv6NsQpsVV8ubYbLbCtDlCHTtnku3NBDCeIzevKmEugbCK2vQ1eTVs
	aXoHlZXELJT3rs3p2vEi3JzpvuifnoUTD/TrcIgvLMjQfAkaovz+m3smUIekkqgRGfytVC
	V4N2hwbFhbBVG1UniihI5g+twxWnGSM=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Yosry Ahmed <yosry.ahmed@linux.dev>
To: Sean Christopherson <seanjc@google.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, Jim Mattson <jmattson@google.com>, 
	kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 11/13] KVM: nSVM: Simplify nested_svm_vmrun()
Message-ID: <lbbd3hbglrlnsxwqb2t6cri7peqcjrrxqtfqdcnhqo5njlgava@v56im3yjgllf>
References: <20251110222922.613224-1-yosry.ahmed@linux.dev>
 <20251110222922.613224-12-yosry.ahmed@linux.dev>
 <aThKPT9ItrrDZdSd@google.com>
 <cqoepoowhgkauskf7enfmqo7gxn3onaqwuoxtv6yfpf6ilbzeo@afeqsa4juzkx>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cqoepoowhgkauskf7enfmqo7gxn3onaqwuoxtv6yfpf6ilbzeo@afeqsa4juzkx>
X-Migadu-Flow: FLOW_OUT

On Thu, Dec 11, 2025 at 07:25:21PM +0000, Yosry Ahmed wrote:
> On Tue, Dec 09, 2025 at 08:11:41AM -0800, Sean Christopherson wrote:
> > On Mon, Nov 10, 2025, Yosry Ahmed wrote:
> > > Call nested_svm_merge_msrpm() from enter_svm_guest_mode() if called from
> > > the VMRUN path, instead of making the call in nested_svm_vmrun(). This
> > > simplifies the flow of nested_svm_vmrun() and removes all jumps to
> > > cleanup labels.
> > > 
> > > Signed-off-by: Yosry Ahmed <yosry.ahmed@linux.dev>
> > > ---
> > >  arch/x86/kvm/svm/nested.c | 28 +++++++++++++---------------
> > >  1 file changed, 13 insertions(+), 15 deletions(-)
> > > 
> > > diff --git a/arch/x86/kvm/svm/nested.c b/arch/x86/kvm/svm/nested.c
> > > index a48668c36a191..89830380cebc5 100644
> > > --- a/arch/x86/kvm/svm/nested.c
> > > +++ b/arch/x86/kvm/svm/nested.c
> > > @@ -1020,6 +1020,9 @@ int enter_svm_guest_mode(struct kvm_vcpu *vcpu, u64 vmcb12_gpa, bool from_vmrun)
> > >  
> > >  	nested_svm_hv_update_vm_vp_ids(vcpu);
> > >  
> > > +	if (from_vmrun && !nested_svm_merge_msrpm(vcpu))
> > 
> > This is silly, just do:
> > 
> > 	if (enter_svm_guest_mode(vcpu, vmcb12_gpa, true) ||
> > 	    nested_svm_merge_msrpm(vcpu)) {
> > 		svm->nested.nested_run_pending = 0;
> > 		svm->nmi_l1_to_l2 = false;
> > 		svm->soft_int_injected = false;
> > 
> > 		svm->vmcb->control.exit_code    = SVM_EXIT_ERR;
> > 		svm->vmcb->control.exit_code_hi = -1u;
> > 		svm->vmcb->control.exit_info_1  = 0;
> > 		svm->vmcb->control.exit_info_2  = 0;
> > 
> > 		nested_svm_vmexit(svm);
> > 	}
> 
> Actually, if we go with the approach of making all VMRUN failures
> happen before preparing the VMCB02 (as discussed in the other thread),
> then we will want to call nested_svm_merge_msrpm() from within
> enter_svm_guest_mode().

We can also just call nested_svm_merge_msrpm() before
enter_svm_guest_mode(), which seems to work. Part of me still prefers to
keep all the potential failures bundled together in
enter_svm_guest_mode() though.

> 
> Otherwise, we either have a separate failure path for
> nested_svm_merge_msrpm(), or we make all VMRUN failures happen after
> preparing the VMCB02 and handled by nested_svm_vmexit().
> 
> I like having a separate exit path for VMRUN failures, and it makes more
> sense to do the consistency checks on VMCB12 before preparing VMCB02.
> But I understand if you prefer to keep things simple and move all
> failures after VMCB02.
> 
> I already have it implemented with the separate VMRUN failure path, but
> I don't wanna spam you with another series if you prefer it the other
> way.
> 
> > 
> > > +		return -1;
> > 
> > Please stop returning -1, use a proper -errno.
> > 
> > > +
> > >  	return 0;
> > >  }
> > >  
> > > @@ -1105,23 +1108,18 @@ int nested_svm_vmrun(struct kvm_vcpu *vcpu)
> > >  
> > >  	svm->nested.nested_run_pending = 1;
> > >  
> > > -	if (enter_svm_guest_mode(vcpu, vmcb12_gpa, true))
> > > -		goto out_exit_err;
> > > -
> > > -	if (nested_svm_merge_msrpm(vcpu))
> > > -		return ret;
> > > -
> > > -out_exit_err:
> > > -	svm->nested.nested_run_pending = 0;
> > > -	svm->nmi_l1_to_l2 = false;
> > > -	svm->soft_int_injected = false;
> > > +	if (enter_svm_guest_mode(vcpu, vmcb12_gpa, true)) {
> > > +		svm->nested.nested_run_pending = 0;
> > > +		svm->nmi_l1_to_l2 = false;
> > > +		svm->soft_int_injected = false;
> > >  
> > > -	svm->vmcb->control.exit_code    = SVM_EXIT_ERR;
> > > -	svm->vmcb->control.exit_code_hi = 0;
> > > -	svm->vmcb->control.exit_info_1  = 0;
> > > -	svm->vmcb->control.exit_info_2  = 0;
> > > +		svm->vmcb->control.exit_code    = SVM_EXIT_ERR;
> > > +		svm->vmcb->control.exit_code_hi = 0;
> > > +		svm->vmcb->control.exit_info_1  = 0;
> > > +		svm->vmcb->control.exit_info_2  = 0;
> > >  
> > > -	nested_svm_vmexit(svm);
> > > +		nested_svm_vmexit(svm);
> > 
> > Note, there's a pre-existing bug in nested_svm_vmexit().  Lovely, and it's a
> > user-triggerable WARN_ON() (and not even a WARN_ON_ONCE() at that).
> > 
> > If nested_svm_vmexit() fails to map vmcb12, it (unbelievably stupidly) injects a
> > #GP and hopes for the best.  Oh FFS, it also has the asinine -EINVAL "logic".
> > Anyways, it injects #GP (maybe), and bails early, which leaves
> > KVM_REQ_GET_NESTED_STATE_PAGES set.  KVM will then process that on the next
> > vcpu_enter_guest() and trip the WARN_ON() in svm_get_nested_state_pages().
> > 
> > Something like this to clean up the mess:
> > 
> > diff --git a/arch/x86/kvm/svm/nested.c b/arch/x86/kvm/svm/nested.c
> > index d4c872843a9d..96f8009a0d45 100644
> > --- a/arch/x86/kvm/svm/nested.c
> > +++ b/arch/x86/kvm/svm/nested.c
> > @@ -1018,9 +1018,6 @@ int enter_svm_guest_mode(struct kvm_vcpu *vcpu, u64 vmcb12_gpa, bool from_vmrun)
> >  
> >         nested_svm_hv_update_vm_vp_ids(vcpu);
> >  
> > -       if (from_vmrun && !nested_svm_merge_msrpm(vcpu))
> > -               return -1;
> > -
> >         return 0;
> >  }
> >  
> > @@ -1094,7 +1091,8 @@ int nested_svm_vmrun(struct kvm_vcpu *vcpu)
> >  
> >         svm->nested.nested_run_pending = 1;
> >  
> > -       if (enter_svm_guest_mode(vcpu, vmcb12_gpa, true)) {
> > +       if (enter_svm_guest_mode(vcpu, vmcb12_gpa, true) ||
> > +           nested_svm_merge_msrpm(vcpu)) {
> >                 svm->nested.nested_run_pending = 0;
> >                 svm->nmi_l1_to_l2 = false;
> >                 svm->soft_int_injected = false;
> > @@ -1158,24 +1156,16 @@ void svm_copy_vmloadsave_state(struct vmcb *to_vmcb, struct vmcb *from_vmcb)
> >  int nested_svm_vmexit(struct vcpu_svm *svm)
> >  {
> >         struct kvm_vcpu *vcpu = &svm->vcpu;
> > +       gpa_t vmcb12_gpa = svm->nested.vmcb12_gpa;
> >         struct vmcb *vmcb01 = svm->vmcb01.ptr;
> >         struct vmcb *vmcb02 = svm->nested.vmcb02.ptr;
> >         struct vmcb *vmcb12;
> >         struct kvm_host_map map;
> > -       int rc;
> > -
> > -       rc = kvm_vcpu_map(vcpu, gpa_to_gfn(svm->nested.vmcb12_gpa), &map);
> > -       if (rc) {
> > -               if (rc == -EINVAL)
> > -                       kvm_inject_gp(vcpu, 0);
> > -               return 1;
> > -       }
> >  
> >         vmcb12 = map.hva;
> >  
> >         /* Exit Guest-Mode */
> >         leave_guest_mode(vcpu);
> > -       svm->nested.vmcb12_gpa = 0;
> >         WARN_ON_ONCE(svm->nested.nested_run_pending);
> >  
> >         kvm_clear_request(KVM_REQ_GET_NESTED_STATE_PAGES, vcpu);
> > @@ -1183,6 +1173,13 @@ int nested_svm_vmexit(struct vcpu_svm *svm)
> >         /* in case we halted in L2 */
> >         kvm_set_mp_state(vcpu, KVM_MP_STATE_RUNNABLE);
> >  
> > +       svm->nested.vmcb12_gpa = 0;
> > +
> > +       if (kvm_vcpu_map(vcpu, gpa_to_gfn(vmcb12_gpa), &map)) {
> > +               kvm_make_request(KVM_REQ_TRIPLE_FAULT, vcpu);
> > +               return 1;
> > +       }
> > +
> >         /* Give the current vmcb to the guest */
> >  
> >         vmcb12->save.es     = vmcb02->save.es;
> > @@ -1973,7 +1970,7 @@ static int svm_set_nested_state(struct kvm_vcpu *vcpu,
> >  
> >  static bool svm_get_nested_state_pages(struct kvm_vcpu *vcpu)
> >  {
> > -       if (WARN_ON(!is_guest_mode(vcpu)))
> > +       if (WARN_ON_ONCE(!is_guest_mode(vcpu)))
> >                 return true;
> >  
> >         if (!vcpu->arch.pdptrs_from_userspace &&
> > 

