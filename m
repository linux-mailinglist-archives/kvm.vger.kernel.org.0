Return-Path: <kvm+bounces-43814-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id CC957A96558
	for <lists+kvm@lfdr.de>; Tue, 22 Apr 2025 12:04:42 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id A0CE9189CEA5
	for <lists+kvm@lfdr.de>; Tue, 22 Apr 2025 10:04:53 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5FC7A20B7FC;
	Tue, 22 Apr 2025 10:04:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="PPWsPL6U"
X-Original-To: kvm@vger.kernel.org
Received: from out-184.mta0.migadu.com (out-184.mta0.migadu.com [91.218.175.184])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BEB361E3DEF
	for <kvm@vger.kernel.org>; Tue, 22 Apr 2025 10:04:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.184
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745316271; cv=none; b=sGPWa8Zu5Rs0PdDUtdtqQPBoUDi8otT0Y1nJ0bi4GGnLmjYI6qxJvYf9AXgFUNCEtxHq/wUxhCHc4OZvsXJSiQI7x48/Yp4jDgNFNIqafhb549BrFziJxKafpsS32XZvrVVO+ry6cGhp2B0cn1DjzVpdbSAbEVZDSpRAZLpy9bs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745316271; c=relaxed/simple;
	bh=7lYgGV+kVZpFE7CtLbwBBvPR+oiIuKgqFz7vDrunuJ0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=BYIsTPb4lNNjFFswIKdGUlXIl51Ccs5Lm+stoxB/9LMFojzYT3HFE1ocm9yTe5jJmrrCRhfvpUMoBDADoXZVcIwR32Wb+22w19Ds0UNZjYuoNQU14NZHHJ684/m7K2/SYEvRTNjpJlhY0N5zGyYUHvSS3npfbXMO7Uw8fqcnnAE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=PPWsPL6U; arc=none smtp.client-ip=91.218.175.184
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Date: Tue, 22 Apr 2025 03:04:23 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1745316266;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=sLvf3k1xS4oMdL7x+BMCStKTo3P8Sq3mlNgTCG4VAts=;
	b=PPWsPL6Ul1kr4lt6gN0DPH73O7NYtDA94DLJM8vvd/QfNi2lQUdR5kW0vQ/4MpIEkrQ/iY
	DbWA8deiDrY839n0fmScKPktYw25w87rubGvX7hph9ORt8kXfZrZ1Dq/ZdHIOUK4cU4mb9
	kZ8voQXcoKkULj1FzfFtOY/hd9lmqYc=
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
Subject: Re: [RFC PATCH 13/24] KVM: nSVM: Parameterize svm_flush_tlb_asid()
 by is_guest_mode
Message-ID: <aAdpp_xAuKMLR0vx@Asmaa.>
References: <20250326193619.3714986-1-yosry.ahmed@linux.dev>
 <20250326193619.3714986-14-yosry.ahmed@linux.dev>
 <a910ebd37e05091ec59ba7e731f10f6f7b9b97bc.camel@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <a910ebd37e05091ec59ba7e731f10f6f7b9b97bc.camel@redhat.com>
X-Migadu-Flow: FLOW_OUT

On Thu, Apr 03, 2025 at 04:10:06PM -0400, Maxim Levitsky wrote:
> On Wed, 2025-03-26 at 19:36 +0000, Yosry Ahmed wrote:
> > svm_flush_tlb_asid() currently operates on the current VMCB. In
> > preparation for properly tracking TLB flushes for L1 and L2 ASIDs,
> > refactor it to take is_guest_mode and find the proper VMCB. All existing
> > callers pass is_guest_mode(vcpu) to maintain existing behavior for now.
> > 
> > Move the comment about only flushing the current ASID to
> > svm_flush_tlb_all(), where it probably should have been anyway, because
> > svm_flush_tlb_asid() now flushes a given ASID, not the current ASID.
> > 
> > Create a svm_flush_tlb_guest() wrapper to use as the flush_tlb_guest()
> > callback.
> > 
> > No functional change intended.
> > 
> > Signed-off-by: Yosry Ahmed <yosry.ahmed@linux.dev>
> > ---
> >  arch/x86/kvm/svm/svm.c | 39 +++++++++++++++++++++++++--------------
> >  1 file changed, 25 insertions(+), 14 deletions(-)
> > 
> > diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
> > index 865c5ce4fa473..fb6b9f88a1504 100644
> > --- a/arch/x86/kvm/svm/svm.c
> > +++ b/arch/x86/kvm/svm/svm.c
> > @@ -4016,25 +4016,24 @@ static void svm_enable_nmi_window(struct kvm_vcpu *vcpu)
> >  	svm->vmcb->save.rflags |= (X86_EFLAGS_TF | X86_EFLAGS_RF);
> >  }
> >  
> > -static void svm_flush_tlb_asid(struct kvm_vcpu *vcpu)
> > +static struct vmcb *svm_get_vmcb(struct vcpu_svm *svm, bool is_guest_mode)
> > +{
> > +	return is_guest_mode ? svm->nested.vmcb02.ptr : svm->vmcb01.ptr;
> > +}
> 
> Not sure 100% about this helper, it name might be a bit confusing because
> we already have a current vmcb. Maybe add a comment above stating this
> this is to get vmcb which might not be currently active?

Yeah I spent some time trying to come up with an elaborate name then
convinced myself that the is_guest_mode parameter will make it clear
that the caller specifies which VMCB it wants, regardless of which VMCB
is current.

I can add a comment to make it clearer.

> 
> > +
> > +static void svm_flush_tlb_asid(struct kvm_vcpu *vcpu, bool is_guest_mode)
> >  {
> >  	struct vcpu_svm *svm = to_svm(vcpu);
> > +	struct vmcb *vmcb = svm_get_vmcb(svm, is_guest_mode);
> >  
> >  	/*
> >  	 * Unlike VMX, SVM doesn't provide a way to flush only NPT TLB entries.
> >  	 * A TLB flush for the current ASID flushes both "host" and "guest" TLB
> >  	 * entries, and thus is a superset of Hyper-V's fine grained flushing.
> >  	 */
> > -	kvm_hv_vcpu_purge_flush_tlb(vcpu, is_guest_mode(vcpu));
> > -
> > -	/*
> > -	 * Flush only the current ASID even if the TLB flush was invoked via
> > -	 * kvm_flush_remote_tlbs().  Although flushing remote TLBs requires all
> > -	 * ASIDs to be flushed, KVM uses a single ASID for L1 and L2, and
> > -	 * unconditionally does a TLB flush on both nested VM-Enter and nested
> > -	 * VM-Exit (via kvm_mmu_reset_context()).
> > -	 */
> > -	vmcb_set_flush_asid(svm->vmcb);
> > +	kvm_hv_vcpu_purge_flush_tlb(vcpu, is_guest_mode);
> > +	if (vmcb)
> > +		vmcb_set_flush_asid(vmcb);
> >  }
> >  
> >  static void svm_flush_tlb_current(struct kvm_vcpu *vcpu)
> > @@ -4050,7 +4049,7 @@ static void svm_flush_tlb_current(struct kvm_vcpu *vcpu)
> >  	if (svm_hv_is_enlightened_tlb_enabled(vcpu) && VALID_PAGE(root_tdp))
> >  		hyperv_flush_guest_mapping(root_tdp);
> >  
> > -	svm_flush_tlb_asid(vcpu);
> > +	svm_flush_tlb_asid(vcpu, is_guest_mode(vcpu));
> >  }
> >  
> >  static void svm_flush_tlb_all(struct kvm_vcpu *vcpu)
> > @@ -4065,7 +4064,14 @@ static void svm_flush_tlb_all(struct kvm_vcpu *vcpu)
> >  	if (WARN_ON_ONCE(svm_hv_is_enlightened_tlb_enabled(vcpu)))
> >  		hv_flush_remote_tlbs(vcpu->kvm);
> >  
> > -	svm_flush_tlb_asid(vcpu);
> > +	/*
> > +	 * Flush only the current ASID even if the TLB flush was invoked via
> > +	 * kvm_flush_remote_tlbs().  Although flushing remote TLBs requires all
> > +	 * ASIDs to be flushed, KVM uses a single ASID for L1 and L2, and
> > +	 * unconditionally does a TLB flush on both nested VM-Enter and nested
> > +	 * VM-Exit (via kvm_mmu_reset_context()).
> > +	 */
> > +	svm_flush_tlb_asid(vcpu, is_guest_mode(vcpu));
> >  }
> >  
> >  static void svm_flush_tlb_gva(struct kvm_vcpu *vcpu, gva_t gva)
> > @@ -4075,6 +4081,11 @@ static void svm_flush_tlb_gva(struct kvm_vcpu *vcpu, gva_t gva)
> >  	invlpga(gva, svm_get_current_asid(svm));
> >  }
> >  
> > +static void svm_flush_tlb_guest(struct kvm_vcpu *vcpu)
> > +{
> > +	svm_flush_tlb_asid(vcpu, is_guest_mode(vcpu));
> > +}
> > +
> >  static inline void sync_cr8_to_lapic(struct kvm_vcpu *vcpu)
> >  {
> >  	struct vcpu_svm *svm = to_svm(vcpu);
> > @@ -5187,7 +5198,7 @@ static struct kvm_x86_ops svm_x86_ops __initdata = {
> >  	.flush_tlb_all = svm_flush_tlb_all,
> >  	.flush_tlb_current = svm_flush_tlb_current,
> >  	.flush_tlb_gva = svm_flush_tlb_gva,
> > -	.flush_tlb_guest = svm_flush_tlb_asid,
> > +	.flush_tlb_guest = svm_flush_tlb_guest,
> >  
> >  	.vcpu_pre_run = svm_vcpu_pre_run,
> >  	.vcpu_run = svm_vcpu_run,
> 
> 
> Reviewed-by: Maxim Levitsky <mlevitsk@redhat.com>

Thanks!

> 
> 
> Best regards,
> 	Maxim Levitsky
> 
> 
> 
> 
> 

