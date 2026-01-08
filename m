Return-Path: <kvm+bounces-67472-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [IPv6:2600:3c04:e001:36c::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 5E8B1D061DB
	for <lists+kvm@lfdr.de>; Thu, 08 Jan 2026 21:38:26 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 4617E30286DF
	for <lists+kvm@lfdr.de>; Thu,  8 Jan 2026 20:38:23 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 84DF1330305;
	Thu,  8 Jan 2026 20:38:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="ldNaTZvS"
X-Original-To: kvm@vger.kernel.org
Received: from out-178.mta0.migadu.com (out-178.mta0.migadu.com [91.218.175.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 424D232FA2F
	for <kvm@vger.kernel.org>; Thu,  8 Jan 2026 20:38:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767904698; cv=none; b=MoBJKESlRKbSail6Kca30zYyYAysr+eyHx5sckKUDtRDe8LbgTDZsY2Jng0Zfm3spD8uWspkzovmeOp2x0LJPagG4APFCs6Gxr2UK49MiZdGL7qllD5007mpag5LDO3lNo8l7nPlKCgWvBF3bmFA708XvhXuqRcQgnjMRaZ3gnw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767904698; c=relaxed/simple;
	bh=7DrLupMPCc0q3sgWMjZy7++HTue5gN9DuNdR4zne+Bs=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=q//X0RTpLjU8FUYspj85WkRvbQsLA7Hfh0SeBMeaRh0C2GSy+AMIRkc5noOk3QPry21TOHamDs2hV+NtrPmbEJR+iE+W42wjGsCMLuadLeaylhU+GLdc5sci8mDLAEdrkk89pNaDGl8AidhtnMuoyfgZGetggRVAoTdDzAQLA30=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=ldNaTZvS; arc=none smtp.client-ip=91.218.175.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Date: Thu, 8 Jan 2026 20:38:11 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1767904695;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=LKJhlwtS826B6pKoUq6DKq2WDHcIW9g9b21xXJjJv8E=;
	b=ldNaTZvSHa/sYitfuMzckxWOeJaGSZksWQxNqogZU0kdZ+Cs145jRRz7Hnt11asNfI/Ymt
	NRZf42umFRRCNEIdTGLzG87GBn1QVUv9+MMpFJ15mlemji8XWWB/WYcCutWozpF9SwEC4A
	p0QcWYL4pTtH/raiKASKyd08l7Wspuo=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Yosry Ahmed <yosry.ahmed@linux.dev>
To: Sean Christopherson <seanjc@google.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, Jim Mattson <jmattson@google.com>, 
	kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 1/4] KVM: SVM: Allow KVM_SET_NESTED_STATE to clear GIF
 when SVME==0
Message-ID: <6ilulzhszphdjk3ta5jt7t222jicn3zj5e6em3fknzmudeqr3f@dogx6h7lsrax>
References: <20251121204803.991707-1-yosry.ahmed@linux.dev>
 <20251121204803.991707-2-yosry.ahmed@linux.dev>
 <aV_-YLO4AVQc-ZmY@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aV_-YLO4AVQc-ZmY@google.com>
X-Migadu-Flow: FLOW_OUT

On Thu, Jan 08, 2026 at 10:58:40AM -0800, Sean Christopherson wrote:
> On Fri, Nov 21, 2025, Yosry Ahmed wrote:
> > From: Jim Mattson <jmattson@google.com>
> > 
> > GIF==0 together with EFER.SVME==0 is a valid architectural
> > state. Don't return -EINVAL for KVM_SET_NESTED_STATE when this
> > combination is specified.
> > 
> > Fixes: cc440cdad5b7 ("KVM: nSVM: implement KVM_GET_NESTED_STATE and KVM_SET_NESTED_STATE")
> > Signed-off-by: Jim Mattson <jmattson@google.com>
> > Reviewed-by: Yosry Ahmed <yosry.ahmed@linux.dev>
> > Signed-off-by: Yosry Ahmed <yosry.ahmed@linux.dev>
> > ---
> >  arch/x86/kvm/svm/nested.c | 4 ++--
> >  1 file changed, 2 insertions(+), 2 deletions(-)
> > 
> > diff --git a/arch/x86/kvm/svm/nested.c b/arch/x86/kvm/svm/nested.c
> > index c81005b24522..3e4bd8d69788 100644
> > --- a/arch/x86/kvm/svm/nested.c
> > +++ b/arch/x86/kvm/svm/nested.c
> > @@ -1784,8 +1784,8 @@ static int svm_set_nested_state(struct kvm_vcpu *vcpu,
> >  	 * EFER.SVME, but EFER.SVME still has to be 1 for VMRUN to succeed.
> >  	 */
> >  	if (!(vcpu->arch.efer & EFER_SVME)) {
> > -		/* GIF=1 and no guest mode are required if SVME=0.  */
> > -		if (kvm_state->flags != KVM_STATE_NESTED_GIF_SET)
> > +		/* GUEST_MODE must be clear when SVME==0 */
> > +		if (kvm_state->flags & KVM_STATE_NESTED_GUEST_MODE)
> 
> Hmm, this is technically wrong, as it will allow KVM_STATE_NESTED_RUN_PENDING.
> Now, arguably KVM already has a flaw there as KVM allows KVM_STATE_NESTED_RUN_PENDING
> without KVM_STATE_NESTED_GUEST_MODE for SVME=1, but I'd prefer not to make the
> hole bigger.
> 
> The nested if-statement is also unnecessary.
> 
> How about this instead?  (not yet tested)
> 
> 	/*
> 	 * If in guest mode, vcpu->arch.efer actually refers to the L2 guest's
> 	 * EFER.SVME, but EFER.SVME still has to be 1 for VMRUN to succeed.
> 	 * If SVME is disabled, the only valid states are "none" and GIF=1
> 	 * (clearing SVME does NOT set GIF, i.e. GIF=0 is allowed).
> 	 */
> 	if (!(vcpu->arch.efer & EFER_SVME) && kvm_state->flags &&
> 	    kvm_state->flags != KVM_STATE_NESTED_GIF_SET)
> 		return -EINVAL;

Looks good to me, with the tiny exception that at this point clearing
SVME does set GIF. Maybe re-order the patches?

Let me know if you want me to send a new version or if you'll fix it up
while applying.

