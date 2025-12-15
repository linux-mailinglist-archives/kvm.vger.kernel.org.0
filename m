Return-Path: <kvm+bounces-66000-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id F011DCBF72B
	for <lists+kvm@lfdr.de>; Mon, 15 Dec 2025 19:36:54 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 02820301EC61
	for <lists+kvm@lfdr.de>; Mon, 15 Dec 2025 18:35:11 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 59EC52F363F;
	Mon, 15 Dec 2025 18:35:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="CG+6cnKm"
X-Original-To: kvm@vger.kernel.org
Received: from out-174.mta0.migadu.com (out-174.mta0.migadu.com [91.218.175.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 58C1118C02E
	for <kvm@vger.kernel.org>; Mon, 15 Dec 2025 18:35:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765823710; cv=none; b=eS7X271Ja8nD4fvsl8TicgSpGwH5yLyLppflR4drW9jiixvY+VZLyjCKw08MnIseK8QLaGwdV6nWudDo6Cq0G94+/1VXzQ6AvAsoDWxuZf6WaezJJn5iXbwGU2ih11OiQFBozibrE2pq/S1ebYUoHvAfvZap7GpJIt7CD32LDCM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765823710; c=relaxed/simple;
	bh=puV6V/Gj7mwOAKNbqHqzoJqeXl395bbUjS9z/cK4Wl8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=fd3CoPpjhRfFUT+twUCkku6b6jxdX1p7pBiRbOFE4LNbvFA5rUuhp8Ki2n5paKOX6fmOSXpzbtMr9nbm/51+ynFbVzozhU6EjTrVLF+ozZ1JFwcjF/dDhVUqyiyr8d6zjrFPjDmQQDaecMCLtK6Q68WsGrYQS9lEQDT3O0roKnM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=CG+6cnKm; arc=none smtp.client-ip=91.218.175.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Date: Mon, 15 Dec 2025 18:34:56 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1765823700;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=YSeM5WmPIW+W2SeBDGi8ey2F1prthd6W2daGoqOplfo=;
	b=CG+6cnKmdcD4Vfmj2Ff8Tcfpg+GilHOLCfsma3oBGTJpogsJoDyZTjZt/4++anjpIGLkD0
	pHLevAlCGO9OGzG/0Fq2RBu1Jiysl3mS1yeZrDT+GubtbEv/iMHH2+J0Ac/XukUJNTOp3x
	++GQiqDQOD+AI9GEFXhDRgN7JOXEXmM=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Yosry Ahmed <yosry.ahmed@linux.dev>
To: Sean Christopherson <seanjc@google.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, Jim Mattson <jmattson@google.com>, 
	kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 11/13] KVM: nSVM: Simplify nested_svm_vmrun()
Message-ID: <ywd3yhhdpz3k5rc3rg3dpt7sq73kyvjt5d5tuzw7id75y25l5a@r5hvfviipfn3>
References: <20251110222922.613224-1-yosry.ahmed@linux.dev>
 <20251110222922.613224-12-yosry.ahmed@linux.dev>
 <aThKPT9ItrrDZdSd@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aThKPT9ItrrDZdSd@google.com>
X-Migadu-Flow: FLOW_OUT

On Tue, Dec 09, 2025 at 08:11:41AM -0800, Sean Christopherson wrote:
> On Mon, Nov 10, 2025, Yosry Ahmed wrote:
> > Call nested_svm_merge_msrpm() from enter_svm_guest_mode() if called from
> > the VMRUN path, instead of making the call in nested_svm_vmrun(). This
> > simplifies the flow of nested_svm_vmrun() and removes all jumps to
> > cleanup labels.
> > 
> > Signed-off-by: Yosry Ahmed <yosry.ahmed@linux.dev>
> > ---
> >  arch/x86/kvm/svm/nested.c | 28 +++++++++++++---------------
> >  1 file changed, 13 insertions(+), 15 deletions(-)
> > 
> > diff --git a/arch/x86/kvm/svm/nested.c b/arch/x86/kvm/svm/nested.c
> > index a48668c36a191..89830380cebc5 100644
> > --- a/arch/x86/kvm/svm/nested.c
> > +++ b/arch/x86/kvm/svm/nested.c
> > @@ -1020,6 +1020,9 @@ int enter_svm_guest_mode(struct kvm_vcpu *vcpu, u64 vmcb12_gpa, bool from_vmrun)
> >  
> >  	nested_svm_hv_update_vm_vp_ids(vcpu);
> >  
> > +	if (from_vmrun && !nested_svm_merge_msrpm(vcpu))
> 
> This is silly, just do:
> 
> 	if (enter_svm_guest_mode(vcpu, vmcb12_gpa, true) ||
> 	    nested_svm_merge_msrpm(vcpu)) {
> 		svm->nested.nested_run_pending = 0;
> 		svm->nmi_l1_to_l2 = false;
> 		svm->soft_int_injected = false;
> 
> 		svm->vmcb->control.exit_code    = SVM_EXIT_ERR;
> 		svm->vmcb->control.exit_code_hi = -1u;
> 		svm->vmcb->control.exit_info_1  = 0;
> 		svm->vmcb->control.exit_info_2  = 0;
> 
> 		nested_svm_vmexit(svm);
> 	}
> 
> > +		return -1;
> 
> Please stop returning -1, use a proper -errno.
> 
> > +
> >  	return 0;
> >  }
> >  
> > @@ -1105,23 +1108,18 @@ int nested_svm_vmrun(struct kvm_vcpu *vcpu)
> >  
> >  	svm->nested.nested_run_pending = 1;
> >  
> > -	if (enter_svm_guest_mode(vcpu, vmcb12_gpa, true))
> > -		goto out_exit_err;
> > -
> > -	if (nested_svm_merge_msrpm(vcpu))
> > -		return ret;
> > -
> > -out_exit_err:
> > -	svm->nested.nested_run_pending = 0;
> > -	svm->nmi_l1_to_l2 = false;
> > -	svm->soft_int_injected = false;
> > +	if (enter_svm_guest_mode(vcpu, vmcb12_gpa, true)) {
> > +		svm->nested.nested_run_pending = 0;
> > +		svm->nmi_l1_to_l2 = false;
> > +		svm->soft_int_injected = false;
> >  
> > -	svm->vmcb->control.exit_code    = SVM_EXIT_ERR;
> > -	svm->vmcb->control.exit_code_hi = 0;
> > -	svm->vmcb->control.exit_info_1  = 0;
> > -	svm->vmcb->control.exit_info_2  = 0;
> > +		svm->vmcb->control.exit_code    = SVM_EXIT_ERR;
> > +		svm->vmcb->control.exit_code_hi = 0;
> > +		svm->vmcb->control.exit_info_1  = 0;
> > +		svm->vmcb->control.exit_info_2  = 0;
> >  
> > -	nested_svm_vmexit(svm);
> > +		nested_svm_vmexit(svm);
> 
> Note, there's a pre-existing bug in nested_svm_vmexit().  Lovely, and it's a
> user-triggerable WARN_ON() (and not even a WARN_ON_ONCE() at that).
> 
> If nested_svm_vmexit() fails to map vmcb12, it (unbelievably stupidly) injects a
> #GP and hopes for the best.  Oh FFS, it also has the asinine -EINVAL "logic".
> Anyways, it injects #GP (maybe), and bails early, which leaves
> KVM_REQ_GET_NESTED_STATE_PAGES set.  KVM will then process that on the next
> vcpu_enter_guest() and trip the WARN_ON() in svm_get_nested_state_pages().

FWIW, I don't think there will be a warning because when
nested_svm_vmexit() fails to map vmcb12 it also fails to leave guest
mode, so the WARN_ON() should not fire.

I still agree this is a bug and will include a fix/cleanup in the next
version that I will send out shortly.

