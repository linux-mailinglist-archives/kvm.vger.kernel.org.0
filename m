Return-Path: <kvm+bounces-39934-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id A5FA9A4CE2B
	for <lists+kvm@lfdr.de>; Mon,  3 Mar 2025 23:20:21 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 0A93E3ADA0E
	for <lists+kvm@lfdr.de>; Mon,  3 Mar 2025 22:19:59 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 450E020E313;
	Mon,  3 Mar 2025 22:19:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="Z47OAkMR"
X-Original-To: kvm@vger.kernel.org
Received: from out-170.mta0.migadu.com (out-170.mta0.migadu.com [91.218.175.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3F22C23956A
	for <kvm@vger.kernel.org>; Mon,  3 Mar 2025 22:19:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741040359; cv=none; b=HIzK0g6GjXrSFOHQ4ksQeFiscRv70Tt/PAFdFTUIuM2aC+mH4RzXCV2xhKFWLlaXVY9VU8QM+el6BvZLNKtE3/5N1f3FdLPgACWQP//6C6BrEwj+RigG6hgPl7wqDJpx6THFrAd4YogXVP7KrqEHAG7ba4TD7WJAqp51H7czVj0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741040359; c=relaxed/simple;
	bh=BlPYKcfBkBVpT3V5O26Xd6WR6xCeoqftHSDi4xMENnc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=SiejFc1FDHZUhyV+4+ZfvKrz8IRtpClMlxFcU1IPe3Iunse2lfve9ExEn1A9Qrdy4hP10fyqii1CCShIjjGeNP/nOUwHyROjGbejcOgzQO1IKFLh3wqP4/uKm4d36drJpPeRQZY5Ylsy4wxCxJDxJoSfMQw4B1Kx3FvWIQ13H3k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=Z47OAkMR; arc=none smtp.client-ip=91.218.175.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Date: Mon, 3 Mar 2025 22:18:59 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1741040344;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=BqNM3b9INTyWTAPDqRKsbsOJ+JU7cKGKgDcZdOQhQpY=;
	b=Z47OAkMRrnvMr//9J9gBTG2gdHDpVx40BcwBJNHUNaUnH/CJdZKwmch8k2VSxVo23UP5+t
	1N2DwaEVMtBkYJ8UBI/MkiNsi28wluWEdDHziDMgfUFsirbkwVSSfR9io4AEEQSQTHFf0n
	oiiuqYL2pVhlKnUdV3zqdeYHRwoaaHU=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Yosry Ahmed <yosry.ahmed@linux.dev>
To: Maxim Levitsky <mlevitsk@redhat.com>
Cc: Sean Christopherson <seanjc@google.com>,
	Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH 12/13] KVM: nSVM: Service local TLB flushes before
 nested transitions
Message-ID: <Z8Yq00wc_9_NRRkZ@google.com>
References: <20250205182402.2147495-1-yosry.ahmed@linux.dev>
 <20250205182402.2147495-13-yosry.ahmed@linux.dev>
 <540397690642d3aa7e77775a721ba5a62bbdc2ae.camel@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <540397690642d3aa7e77775a721ba5a62bbdc2ae.camel@redhat.com>
X-Migadu-Flow: FLOW_OUT

On Fri, Feb 28, 2025 at 09:20:18PM -0500, Maxim Levitsky wrote:
> On Wed, 2025-02-05 at 18:24 +0000, Yosry Ahmed wrote:
> > KVM does not track TLB flush requests for L1 vs. L2. Hence, service
> > local flush that target the current context before switching to a new
> > one. Since ASIDs are tracked per-VMCB, service the flushes before every
> > VMCB switch.
> > 
> > This is conceptually similar to how nVMX calls
> > kvm_service_local_tlb_flush_requests() in
> > nested_vmx_enter_non_root_mode() and nested_vmx_vmexit(), with the
> > following differences:
> > 
> > 1. nVMX tracks the current VPID based on is_guest_mode(), so local TLB
> >    flushes are serviced before enter_guest_mode() and
> >    leave_guest_mode(). On the other hand, nSVM tracks the current ASID
> >    based on the current VMCB, so the TLB flushes are serviced before an
> >    VMCB switch.
> > 
> > 2. nVMX only enters and leaves guest mode in
> >    nested_vmx_enter_non_root_mode() and nested_vmx_vmexit(). Other paths
> >    like vmx_set_nested_state() and vmx_leave_nested() call into these
> >    two functions. On the other hand, nSVM open codes the switch in
> >    functions like svm_set_nested_state() and svm_leave_nested(), so
> >    servicing the flush in svm_switch_svm() is probably most reliable.
> > 
> > Signed-off-by: Yosry Ahmed <yosry.ahmed@linux.dev>
> > ---
> >  arch/x86/kvm/svm/svm.c | 6 ++++++
> >  1 file changed, 6 insertions(+)
> > 
> > diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
> > index 5e7b1c9bfa605..6daa7efa9262b 100644
> > --- a/arch/x86/kvm/svm/svm.c
> > +++ b/arch/x86/kvm/svm/svm.c
> > @@ -1421,6 +1421,12 @@ static void svm_vcpu_reset(struct kvm_vcpu *vcpu, bool init_event)
> >  
> >  void svm_switch_vmcb(struct vcpu_svm *svm, struct kvm_vmcb_info *target_vmcb)
> >  {
> > +	/*
> > +	 * ASIDs are tracked per-VMCB. Perform any pending TLB flushes for the
> > +	 * current VMCB before switching to a new one.
> > +	 */
> > +	kvm_service_local_tlb_flush_requests(&svm->vcpu);
> > +
> >  	svm->current_vmcb = target_vmcb;
> >  	svm->vmcb = target_vmcb->ptr;
> >  }
> 
> 
> Note that another difference between SVM and VMX is that this code will only set tlb_ctl
> in the current vmcb, the actual flush can happen much later, when we do VM entry with this vmcb,
> e.g if we are now in L2, the flush will happen when we enter L2 again.

Right, but I think the internal implementation of the TLB flushes is not
relevant in this specific instance. Do you think it would be useful to
mention that here?

If we were to document the difference in TLB flush handling between VMX
and SVM I think a better place would be at kvm_vcpu_flush_tlb_*(), or
maybe in kvm_host.h where the vendor callbacks are defined? Not sure.

> 
> I think that this is correct but I might be mistaken.
> 
> Reviewed-by: Maxim Levitsky <mlevitsk@redhat.com>

Thanks!

