Return-Path: <kvm+bounces-65796-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id A843DCB6FF4
	for <lists+kvm@lfdr.de>; Thu, 11 Dec 2025 20:25:56 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 05CB830361F0
	for <lists+kvm@lfdr.de>; Thu, 11 Dec 2025 19:25:39 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C0C7D316912;
	Thu, 11 Dec 2025 19:25:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="bhE5a5w/"
X-Original-To: kvm@vger.kernel.org
Received: from out-186.mta1.migadu.com (out-186.mta1.migadu.com [95.215.58.186])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7B2C731A056
	for <kvm@vger.kernel.org>; Thu, 11 Dec 2025 19:25:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.186
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765481136; cv=none; b=o9pAZLEISIlEIryGtv5/relPD0gdZ3YUXPR2+UWXIodbOBLA/uS+fdM0w8dkGQDxgwYmpdz0tXFzvqp9MgB/jt0kGwavciDhsXcmJ9JxtawZwzFlMoDsRRT/72cfllvDQUNBb17oQG/B0an05Vu8N0L2iB6TOWq2wTfNXv3sG1o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765481136; c=relaxed/simple;
	bh=tRu1vUerswcCQpcQtHnIVnFPOWqodjHp5O+JilGEBHE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=BlU5BE9D8leueQFrK/6Tm2ah8tXxqKH3/IeiQz+1cbpqwB8yQW3nAblYbh8QKzj/uMfzNGwxf40FpiX3960ITyzJ6g8zATLB0RA4rKOptpT7bH7oZ9qsQvr9wuu+jZCBwySvzSRrlGy/W7IfkbLCdQRo3TWWEUgcV5J+N5Ox3FA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=bhE5a5w/; arc=none smtp.client-ip=95.215.58.186
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Date: Thu, 11 Dec 2025 19:25:13 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1765481121;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=VB5q0XsqVDTf88m6gqOLvNZHtj7eCMSJe1d0HDeH9nc=;
	b=bhE5a5w/wyyKHOOSa1jb955VxK/bdxl2X6xbN0CFwXJ2CKW63s6vT0xnvCMXVc4WCLWGgi
	8lvJQ9rmmD9n3cBBjGhWLwzUcYnN16y7vKxUWuUrPn0GkCdbx0TVhCMNW97P2Ivl2LCPWK
	ZHCK8bbWiNFRIpYA/G59Jbouacdh4jo=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Yosry Ahmed <yosry.ahmed@linux.dev>
To: Sean Christopherson <seanjc@google.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, Jim Mattson <jmattson@google.com>, 
	kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 11/13] KVM: nSVM: Simplify nested_svm_vmrun()
Message-ID: <cqoepoowhgkauskf7enfmqo7gxn3onaqwuoxtv6yfpf6ilbzeo@afeqsa4juzkx>
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

Actually, if we go with the approach of making all VMRUN failures
happen before preparing the VMCB02 (as discussed in the other thread),
then we will want to call nested_svm_merge_msrpm() from within
enter_svm_guest_mode().

Otherwise, we either have a separate failure path for
nested_svm_merge_msrpm(), or we make all VMRUN failures happen after
preparing the VMCB02 and handled by nested_svm_vmexit().

I like having a separate exit path for VMRUN failures, and it makes more
sense to do the consistency checks on VMCB12 before preparing VMCB02.
But I understand if you prefer to keep things simple and move all
failures after VMCB02.

I already have it implemented with the separate VMRUN failure path, but
I don't wanna spam you with another series if you prefer it the other
way.

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
> 
> Something like this to clean up the mess:
> 
> diff --git a/arch/x86/kvm/svm/nested.c b/arch/x86/kvm/svm/nested.c
> index d4c872843a9d..96f8009a0d45 100644
> --- a/arch/x86/kvm/svm/nested.c
> +++ b/arch/x86/kvm/svm/nested.c
> @@ -1018,9 +1018,6 @@ int enter_svm_guest_mode(struct kvm_vcpu *vcpu, u64 vmcb12_gpa, bool from_vmrun)
>  
>         nested_svm_hv_update_vm_vp_ids(vcpu);
>  
> -       if (from_vmrun && !nested_svm_merge_msrpm(vcpu))
> -               return -1;
> -
>         return 0;
>  }
>  
> @@ -1094,7 +1091,8 @@ int nested_svm_vmrun(struct kvm_vcpu *vcpu)
>  
>         svm->nested.nested_run_pending = 1;
>  
> -       if (enter_svm_guest_mode(vcpu, vmcb12_gpa, true)) {
> +       if (enter_svm_guest_mode(vcpu, vmcb12_gpa, true) ||
> +           nested_svm_merge_msrpm(vcpu)) {
>                 svm->nested.nested_run_pending = 0;
>                 svm->nmi_l1_to_l2 = false;
>                 svm->soft_int_injected = false;
> @@ -1158,24 +1156,16 @@ void svm_copy_vmloadsave_state(struct vmcb *to_vmcb, struct vmcb *from_vmcb)
>  int nested_svm_vmexit(struct vcpu_svm *svm)
>  {
>         struct kvm_vcpu *vcpu = &svm->vcpu;
> +       gpa_t vmcb12_gpa = svm->nested.vmcb12_gpa;
>         struct vmcb *vmcb01 = svm->vmcb01.ptr;
>         struct vmcb *vmcb02 = svm->nested.vmcb02.ptr;
>         struct vmcb *vmcb12;
>         struct kvm_host_map map;
> -       int rc;
> -
> -       rc = kvm_vcpu_map(vcpu, gpa_to_gfn(svm->nested.vmcb12_gpa), &map);
> -       if (rc) {
> -               if (rc == -EINVAL)
> -                       kvm_inject_gp(vcpu, 0);
> -               return 1;
> -       }
>  
>         vmcb12 = map.hva;
>  
>         /* Exit Guest-Mode */
>         leave_guest_mode(vcpu);
> -       svm->nested.vmcb12_gpa = 0;
>         WARN_ON_ONCE(svm->nested.nested_run_pending);
>  
>         kvm_clear_request(KVM_REQ_GET_NESTED_STATE_PAGES, vcpu);
> @@ -1183,6 +1173,13 @@ int nested_svm_vmexit(struct vcpu_svm *svm)
>         /* in case we halted in L2 */
>         kvm_set_mp_state(vcpu, KVM_MP_STATE_RUNNABLE);
>  
> +       svm->nested.vmcb12_gpa = 0;
> +
> +       if (kvm_vcpu_map(vcpu, gpa_to_gfn(vmcb12_gpa), &map)) {
> +               kvm_make_request(KVM_REQ_TRIPLE_FAULT, vcpu);
> +               return 1;
> +       }
> +
>         /* Give the current vmcb to the guest */
>  
>         vmcb12->save.es     = vmcb02->save.es;
> @@ -1973,7 +1970,7 @@ static int svm_set_nested_state(struct kvm_vcpu *vcpu,
>  
>  static bool svm_get_nested_state_pages(struct kvm_vcpu *vcpu)
>  {
> -       if (WARN_ON(!is_guest_mode(vcpu)))
> +       if (WARN_ON_ONCE(!is_guest_mode(vcpu)))
>                 return true;
>  
>         if (!vcpu->arch.pdptrs_from_userspace &&
> 

