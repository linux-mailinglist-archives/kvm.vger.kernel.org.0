Return-Path: <kvm+bounces-39928-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id A82AEA4CDC4
	for <lists+kvm@lfdr.de>; Mon,  3 Mar 2025 22:58:56 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 267E53A7B6A
	for <lists+kvm@lfdr.de>; Mon,  3 Mar 2025 21:58:45 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BBDE71E9B3D;
	Mon,  3 Mar 2025 21:58:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="N85qszCf"
X-Original-To: kvm@vger.kernel.org
Received: from out-172.mta0.migadu.com (out-172.mta0.migadu.com [91.218.175.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4439F1E5213
	for <kvm@vger.kernel.org>; Mon,  3 Mar 2025 21:58:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741039129; cv=none; b=OTcnw0xNKMnTo6SonRdk8w0+wQPxt00AZmACDtMvFtyz6xutIbSsbYihC59EIrpdDuii04zWfLjQcsyiJSKYlWJsp7etGti/dgDm1opMpzAauxhSA6vwhkE0hEaqDwB0sUm1TTCuMUWtSKDBp2Piwt08E3PfElULyG3zJYagKTA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741039129; c=relaxed/simple;
	bh=/v4ZzWOhJhAo9OD0L35X7Om2CGQccUuLpqmDBOLUYd4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=agzgiOlbUBWM4QY/jcvTH3+Y+8LWSUwPtFmsBhxLjq36GuY3EUqS9vENK6dtWAD6r6lUIsUZXv17nbsy0WaPPG1IW3jZjcj6KjmZDyG4Ho2pnTp/DNGH0PwfwUoBxL48j4xbeb96heLvTq/XjwzPaA+KNkHSBTek3IKIKxb8x6s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=N85qszCf; arc=none smtp.client-ip=91.218.175.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Date: Mon, 3 Mar 2025 21:58:40 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1741039125;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=CZUV3OyQGBJhpNGNEXZNub3xajm8alUJBqWeKSYalKI=;
	b=N85qszCf1qk7qOSqtGxnTRaZKeq1Sw/3uqYUgmv/4voLgJoa8AnG9pCb+QdsMQE9Ls+1ki
	WVmzuJfbS7qyKhNueNj4aPoU3ujC2HHIWvNL1me5xw7C88A4KF7IqIuXauZmrhxDRI4Sl9
	Mbpwdui83VZ5XrhOkzjTFfjWBpMVhXw=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Yosry Ahmed <yosry.ahmed@linux.dev>
To: Maxim Levitsky <mlevitsk@redhat.com>
Cc: Sean Christopherson <seanjc@google.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Vitaly Kuznetsov <vkuznets@redhat.com>, kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH 02/13] KVM: nSVM: Rework svm_flush_tlb_asid() to
 operate on a given VMCB
Message-ID: <Z8YmEC_P73JsvRWs@google.com>
References: <20250205182402.2147495-1-yosry.ahmed@linux.dev>
 <20250205182402.2147495-3-yosry.ahmed@linux.dev>
 <2bb5b47e1b6c1251ae7fffe6d4d9836a401a1be0.camel@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2bb5b47e1b6c1251ae7fffe6d4d9836a401a1be0.camel@redhat.com>
X-Migadu-Flow: FLOW_OUT

On Fri, Feb 28, 2025 at 08:29:34PM -0500, Maxim Levitsky wrote:
> On Wed, 2025-02-05 at 18:23 +0000, Yosry Ahmed wrote:
> > svm_flush_tlb_asid() currently operates on the current VMCB. In
> > preparation for properly tracking TLB flushes for L1 and L2 ASIDs,
> > refactor it to work on a given VMCB. All existing callers pass the
> > current VMCB.
> > 
> > Create a svm_flush_tlb_guest() wrapper to use as the flush_tlb_guest()
> > callback.
> > 
> > kvm_hv_vcpu_purge_flush_tlb() is only called when the current VMCB is
> > passed to maintain current behavior.
> > 
> > No functional change intended.
> > 
> > Signed-off-by: Yosry Ahmed <yosry.ahmed@linux.dev>
> > ---
> >  arch/x86/kvm/svm/svm.c | 25 ++++++++++++++++++-------
> >  1 file changed, 18 insertions(+), 7 deletions(-)
> > 
> > diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
> > index 08340ae57777b..2108b48ba4959 100644
> > --- a/arch/x86/kvm/svm/svm.c
> > +++ b/arch/x86/kvm/svm/svm.c
> > @@ -3954,7 +3954,7 @@ static void svm_enable_nmi_window(struct kvm_vcpu *vcpu)
> >  	svm->vmcb->save.rflags |= (X86_EFLAGS_TF | X86_EFLAGS_RF);
> >  }
> >  
> > -static void svm_flush_tlb_asid(struct kvm_vcpu *vcpu)
> > +static void svm_flush_tlb_asid(struct kvm_vcpu *vcpu, struct kvm_vmcb_info *vmcb)
> >  {
> >  	struct vcpu_svm *svm = to_svm(vcpu);
> >  
> > @@ -3963,7 +3963,8 @@ static void svm_flush_tlb_asid(struct kvm_vcpu *vcpu)
> >  	 * A TLB flush for the current ASID flushes both "host" and "guest" TLB
> >  	 * entries, and thus is a superset of Hyper-V's fine grained flushing.
> >  	 */
> > -	kvm_hv_vcpu_purge_flush_tlb(vcpu);
> > +	if (vmcb == svm->current_vmcb)
> > +		kvm_hv_vcpu_purge_flush_tlb(vcpu);
> 
> This is hyperv PV feature that should be looked upon very carefully.
> 
> To recap, 
> each vCPU has 2 queues of pending TLB flush requests that target only small range of
> memory pages. 

Thanks for pointing this out, I missed this.

> 
> One is for L1 and one for L2, because now KVM supports a mode where L2
> can ask L0 to do a tlb flush on its behalf, and KVM will figure out to which L1 vCPUs
> to send this flush request.
> 
> Requests arrive from other vCPUs.
> 
> Here we purge the TLB request queue because we flushed a super-set of the requests,
> which used to contain both L1 and L2 TLB, but soon that won't be true.
> 
> So I think it might make sense to also add vmcb to kvm_hv_vcpu_purge_flush_tlb, and then
> depending if it is vmcb01 or vmcb02, purge the correct queue.
> I don't know if this is theoretical or actual bug but it is better to be safe IMHO.

But I think we are already purging the right queue here. We purge the
TLB flush requests only if we are flushing the current VMCB. Within
kvm_hv_vcpu_purge_flush_tlb(), we choose the queue based on
is_guest_mode(vcpu).

svm_flush_tlb_asid() is called when servicing a TLB flush request, at
which point IIUC the current VMCB and whether the vCPU is in guest mode
should be in sync. So we will be correctly purging the L1 or L2 queue
based on the current VMCB.

That being said, it's a bit confusing that svm_flush_tlb_asid() uses the
VMCB to differentiate L1 and L2 ,while kvm_hv_vcpu_purge_flush_tlb()
uses is_guest_mode(). We also miss the opportunity to purge both queues
when called from svm_flush_tlb_all().

However, we cannot pass the VMCB to kvm_hv_vcpu_purge_flush_tlb() as it
is also called from common code. So I think we can make
kvm_hv_vcpu_purge_flush_tlb() take is_guest_mode as a parameter and pass
it here based on which VMCB is passed in.

WDYT?

