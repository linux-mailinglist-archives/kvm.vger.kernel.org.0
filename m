Return-Path: <kvm+bounces-40134-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 583F0A4F736
	for <lists+kvm@lfdr.de>; Wed,  5 Mar 2025 07:37:45 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id B145E188F68D
	for <lists+kvm@lfdr.de>; Wed,  5 Mar 2025 06:37:51 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BE0181DE89E;
	Wed,  5 Mar 2025 06:37:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="Qr9Ov2mQ"
X-Original-To: kvm@vger.kernel.org
Received: from out-181.mta1.migadu.com (out-181.mta1.migadu.com [95.215.58.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ECB5D1078F
	for <kvm@vger.kernel.org>; Wed,  5 Mar 2025 06:37:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741156642; cv=none; b=g0tRCqDuigRLDGaH5cehFsX2gl4QiBghgRuj0zg+ElNREnz5Rp9UA8J3mszaq+smcah4MeUkOR6CxvHCyrUXr4ogL/6dTr5nT0/3ewLTwFLwYe0VWwphs5N7r0y5Kcg2KmNJt9/P7WN+uatxyrv0d6okW8LpFIbwra6WlnRl79g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741156642; c=relaxed/simple;
	bh=LJwKyeSAzsXj1fORsbPWmxJcEpvNxujfGGxxVhSDJVY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=myTwwMlw9BUD/RWA1HloALZj2QQMLnJSksuDbp+JfE61RwS/rJoaw/xIlzJBxu8qHBunL9DFDQy0Vnufc/pofMeMBMw3Nd5lm4CLOGVmvx/HMqFbBVx1DYenKOmlhTnJXDRfLBs/DZiRt8kwKlGn24hwOGMb/ctIfGK4ESiX6wE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=Qr9Ov2mQ; arc=none smtp.client-ip=95.215.58.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Date: Wed, 5 Mar 2025 06:37:13 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1741156638;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=Mr+nCRMjELAhCCoYRcZskfPBSCbPgmipzPBsRhL21pk=;
	b=Qr9Ov2mQNOXlrNHWIPlLZrn5rfB2+bJkvI+9CChaUE8Jc4MMwGJoeYzyvqyjtD+E1fXC0v
	pOQ+1O/3yF8xLQTvRxjh9HVPcqzg4cU6jOfT8TKaNus4D1lA/iSJuQHcaQgzc10v54BZFM
	rpPROjmKtFl+j36u8ln27LCDPkZ7H08=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Yosry Ahmed <yosry.ahmed@linux.dev>
To: Maxim Levitsky <mlevitsk@redhat.com>
Cc: Sean Christopherson <seanjc@google.com>,
	Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH 12/13] KVM: nSVM: Service local TLB flushes before
 nested transitions
Message-ID: <Z8fxGYt6OmTlOd5i@google.com>
References: <20250205182402.2147495-1-yosry.ahmed@linux.dev>
 <20250205182402.2147495-13-yosry.ahmed@linux.dev>
 <540397690642d3aa7e77775a721ba5a62bbdc2ae.camel@redhat.com>
 <Z8Yq00wc_9_NRRkZ@google.com>
 <d070c0c136bd05a68492e81077303603deefb9af.camel@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <d070c0c136bd05a68492e81077303603deefb9af.camel@redhat.com>
X-Migadu-Flow: FLOW_OUT

On Tue, Mar 04, 2025 at 10:03:51PM -0500, Maxim Levitsky wrote:
> On Mon, 2025-03-03 at 22:18 +0000, Yosry Ahmed wrote:
> > On Fri, Feb 28, 2025 at 09:20:18PM -0500, Maxim Levitsky wrote:
> > > On Wed, 2025-02-05 at 18:24 +0000, Yosry Ahmed wrote:
> > > > KVM does not track TLB flush requests for L1 vs. L2. Hence, service
> > > > local flush that target the current context before switching to a new
> > > > one. Since ASIDs are tracked per-VMCB, service the flushes before every
> > > > VMCB switch.
> > > > 
> > > > This is conceptually similar to how nVMX calls
> > > > kvm_service_local_tlb_flush_requests() in
> > > > nested_vmx_enter_non_root_mode() and nested_vmx_vmexit(), with the
> > > > following differences:
> > > > 
> > > > 1. nVMX tracks the current VPID based on is_guest_mode(), so local TLB
> > > >    flushes are serviced before enter_guest_mode() and
> > > >    leave_guest_mode(). On the other hand, nSVM tracks the current ASID
> > > >    based on the current VMCB, so the TLB flushes are serviced before an
> > > >    VMCB switch.
> > > > 
> > > > 2. nVMX only enters and leaves guest mode in
> > > >    nested_vmx_enter_non_root_mode() and nested_vmx_vmexit(). Other paths
> > > >    like vmx_set_nested_state() and vmx_leave_nested() call into these
> > > >    two functions. On the other hand, nSVM open codes the switch in
> > > >    functions like svm_set_nested_state() and svm_leave_nested(), so
> > > >    servicing the flush in svm_switch_svm() is probably most reliable.
> > > > 
> > > > Signed-off-by: Yosry Ahmed <yosry.ahmed@linux.dev>
> > > > ---
> > > >  arch/x86/kvm/svm/svm.c | 6 ++++++
> > > >  1 file changed, 6 insertions(+)
> > > > 
> > > > diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
> > > > index 5e7b1c9bfa605..6daa7efa9262b 100644
> > > > --- a/arch/x86/kvm/svm/svm.c
> > > > +++ b/arch/x86/kvm/svm/svm.c
> > > > @@ -1421,6 +1421,12 @@ static void svm_vcpu_reset(struct kvm_vcpu *vcpu, bool init_event)
> > > >  
> > > >  void svm_switch_vmcb(struct vcpu_svm *svm, struct kvm_vmcb_info *target_vmcb)
> > > >  {
> > > > +	/*
> > > > +	 * ASIDs are tracked per-VMCB. Perform any pending TLB flushes for the
> > > > +	 * current VMCB before switching to a new one.
> > > > +	 */
> > > > +	kvm_service_local_tlb_flush_requests(&svm->vcpu);
> > > > +
> > > >  	svm->current_vmcb = target_vmcb;
> > > >  	svm->vmcb = target_vmcb->ptr;
> > > >  }
> > > 
> > > Note that another difference between SVM and VMX is that this code will only set tlb_ctl
> > > in the current vmcb, the actual flush can happen much later, when we do VM entry with this vmcb,
> > > e.g if we are now in L2, the flush will happen when we enter L2 again.
> > 
> > Right, but I think the internal implementation of the TLB flushes is not
> > relevant in this specific instance. Do you think it would be useful to
> > mention that here?
> 
> I am not sure to be honest, I just mentioned this because in theory there can be a difference,
> in regard to the fact that we might think that we flushed the TLB while in fact we haven't yet.
> 
> I am trying my best to think about what hidden problems might lurk around and surface later.
> 
> Not directly related to the above, but I am thinking:
> I really like the way SVM flush works because it ensures that redundant flushes don't cost anything.
> 
> I wonder if we can make VMX code emulate this,
> by having an emulated 'tlb_control' field and then doing the flush (INVEPT) on VM entry.

I briefly thought about this while working on this series. One way to do
this is to make TLB flush requests (e.g. KVM_REQ_TLB_FLUSH) when
emulating INVVPID and INVEPT instead of doing the flush right away. Then
we do service the flushes once before running the guest. Redundant
flushes are coalesced.

But I did not look too closely if the existing TLB flush requests
satisfy all the use cases or if we would need to create new ones. Not
sure if the complexity would be worth it, but something to think about.

