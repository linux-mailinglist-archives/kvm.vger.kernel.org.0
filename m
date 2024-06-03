Return-Path: <kvm+bounces-18682-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 411BA8D87ED
	for <lists+kvm@lfdr.de>; Mon,  3 Jun 2024 19:29:29 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id EF97E285892
	for <lists+kvm@lfdr.de>; Mon,  3 Jun 2024 17:29:27 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 65BC0137924;
	Mon,  3 Jun 2024 17:29:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="i0OTsqaz"
X-Original-To: kvm@vger.kernel.org
Received: from out-181.mta0.migadu.com (out-181.mta0.migadu.com [91.218.175.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 63A4F136E28
	for <kvm@vger.kernel.org>; Mon,  3 Jun 2024 17:29:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717435749; cv=none; b=Grkv8Ri3kuj0M2cbp29BlIR80WJbdBUjAxVsSSPd8rJQoA7kK1W11Kvp7EPh5wXs3BSeein/bGxUbuCLIw39fa5unJoEJEu2d+fDpeKEnt9hGhomd4haUxbPjU04nhMFgO9XqGqazA58CiYGTl8ncQ+bZWGT+cuH94RC7kESwx8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717435749; c=relaxed/simple;
	bh=/xApLLOMk0AoZv2ZOIS0JcBigZIfybAUWCc5Uew4Les=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=tRrB6BDfo2dCjlh59Lk/TXj5E9Oxh5q5RiJM7KLYb1sg0fuMDUcb6/APxa7Jn/MOUOQFIn3UIpGfncuJjaL0N4m66c5i54Cjh2Ijb9yPvNzPNExi7FSZOYliJaKGlxOxwzHrdvVwj2UgfrsTEonZzGJ/uZ+ZlnqdtU4RMIQvQ4Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=i0OTsqaz; arc=none smtp.client-ip=91.218.175.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
X-Envelope-To: maz@kernel.org
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1717435743;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=KXwbtmmqy279NKKcMMAiteNjQJFYfQJ3wusGDC1I9E4=;
	b=i0OTsqazQTpljpFm/MpIobNd0DIGB0VBtmh82ycc3pfqV1Pgse805NP43id26Nox+ynNJ1
	8+0hLt9Zi+/t9ymx+X+3fvFITz7luO4MqSzALn9tkQmHvwmxGpXJrM78tSgCeN0eQCJK1h
	IhG2SoZi5oE7FQr3a7YWFbk9cmItdfw=
X-Envelope-To: kvmarm@lists.linux.dev
X-Envelope-To: james.morse@arm.com
X-Envelope-To: suzuki.poulose@arm.com
X-Envelope-To: yuzenghui@huawei.com
X-Envelope-To: kvm@vger.kernel.org
Date: Mon, 3 Jun 2024 17:28:56 +0000
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Oliver Upton <oliver.upton@linux.dev>
To: Marc Zyngier <maz@kernel.org>
Cc: kvmarm@lists.linux.dev, James Morse <james.morse@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>, kvm@vger.kernel.org
Subject: Re: [PATCH 10/11] KVM: arm64: nv: Honor guest hypervisor's FP/SVE
 traps in CPTR_EL2
Message-ID: <Zl39WCKpyaDmccgY@linux.dev>
References: <20240531231358.1000039-1-oliver.upton@linux.dev>
 <20240531231358.1000039-11-oliver.upton@linux.dev>
 <86le3mkxsp.wl-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <86le3mkxsp.wl-maz@kernel.org>
X-Migadu-Flow: FLOW_OUT

Hey,

On Mon, Jun 03, 2024 at 01:36:54PM +0100, Marc Zyngier wrote:

[...]

> > +	/*
> > +	 * Layer the guest hypervisor's trap configuration on top of our own if
> > +	 * we're in a nested context.
> > +	 */
> > +	if (!vcpu_has_nv(vcpu) || is_hyp_ctxt(vcpu))
> > +		goto write;
> > +
> > +	if (guest_hyp_fpsimd_traps_enabled(vcpu))
> > +		val &= ~CPACR_ELx_FPEN;
> > +	if (guest_hyp_sve_traps_enabled(vcpu))
> > +		val &= ~CPACR_ELx_ZEN;
> 
> I'm afraid this isn't quite right. You are clearing both FPEN (resp
> ZEN) bits based on any of the two bits being clear, while what we want
> is to actually propagate the 0 bits (and only those).

An earlier version of the series I had was effectively doing this,
applying the L0 trap configuration on top of L1's CPTR_EL2. Unless I'm
missing something terribly obvious, I think this is still correct, as:

 - If we're in a hyp context, vEL2's CPTR_EL2 is loaded into CPACR_EL1.
   The independent EL0/EL1 enable bits are handled by hardware. All this
   junk gets skipped and we go directly to writing CPTR_EL2.

 - If we are not in a hyp context, vEL2's CPTR_EL2 gets folded into the
   hardware value for CPTR_EL2. TGE must be 0 in this case, so there is
   no conditional trap based on what EL the vCPU is in. There's only two
   functional trap states at this point, hence the all-or-nothing
   approach.

> What I have in my tree is something along the lines of:
> 
> 	cptr = vcpu_sanitised_cptr_el2(vcpu);
> 	tmp = cptr & (CPACR_ELx_ZEN_MASK | CPACR_ELx_FPEN_MASK);
> 	val &= ~(tmp ^ (CPACR_ELx_ZEN_MASK | CPACR_ELx_FPEN_MASK));

My hesitation with this is it gives the impression that both trap bits
are significant, but in reality only the LSB is useful. Unless my
understanding is disastrously wrong, of course :)

Anyway, my _slight_ preference is towards keeping what I have if
possible, with a giant comment explaining the reasoning behind it. But I
can take your approach instead too.

-- 
Thanks,
Oliver

