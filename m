Return-Path: <kvm+bounces-54552-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 9D646B239FA
	for <lists+kvm@lfdr.de>; Tue, 12 Aug 2025 22:31:25 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 482976E09D1
	for <lists+kvm@lfdr.de>; Tue, 12 Aug 2025 20:31:24 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4107E2D73B3;
	Tue, 12 Aug 2025 20:30:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="N8Uc6s7s"
X-Original-To: kvm@vger.kernel.org
Received: from out-180.mta1.migadu.com (out-180.mta1.migadu.com [95.215.58.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5B3F42D7393
	for <kvm@vger.kernel.org>; Tue, 12 Aug 2025 20:30:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755030639; cv=none; b=tOJSjaxYXt3OusAXMcCYnkE7Gp1GIiQO01lBCfPXD0GwfCohCuewF2Es3D/gzjxoOoVjIviTUTpxphXu4rGqocChH/aXVMtT7hFbGU6iJ/9fPaKCKWxfQtEFm9H4+mVCTBwEZYGBPy3GcLjWwOXHkzPDzLFKGaxvLZ4FPbYRrqU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755030639; c=relaxed/simple;
	bh=Cn/KD1uihUkoOB9BpCdcRlk3C/io7haunMyDMvtE9HA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Jq93GL/svx60AuO1+vMbNKV1xGLNQSWJaAmfm0ENmxIUrSHSzJFGxqtTU3Jqj4kg4E8VdgxpT5O1d6NzYPEtjZIx7sRnifYkEQ5JdGy0TXY7pgB5PVy/l8yR0FAC01ANm36zEBMkq3+vMx1vAQJoGabpa8b/0a7hLWZdjiaqp8M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=N8Uc6s7s; arc=none smtp.client-ip=95.215.58.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Date: Tue, 12 Aug 2025 13:30:19 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1755030635;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=fWF//TLWk8cmca7cPqt/4nADnzqsMkzXNmgduuYJNKo=;
	b=N8Uc6s7siIMVgAEbrTew6Ji7XrWyOzkwEeg9pTKN3W1BSxy9kyoUPpppLWuSpMcdF/hp6F
	VoUhhu4u+8vUNPVk+1EM3CHSljpwkUFZe0rWbQyOSfwqObzGQSuem5AZmc5cnblch/nsCq
	IagXgXdrQ5G8fiUSdVOMcfFeo5354vQ=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Oliver Upton <oliver.upton@linux.dev>
To: Marc Zyngier <maz@kernel.org>
Cc: Joey Gouly <joey.gouly@arm.com>, kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>, Will Deacon <will@kernel.org>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Cornelia Huck <cohuck@redhat.com>
Subject: Re: [PATCH v2 4/5] KVM: arm64: Expose FEAT_RASv1p1 in a canonical
 manner
Message-ID: <aJukWzsI8aubZ9sl@linux.dev>
References: <20250806165615.1513164-1-maz@kernel.org>
 <20250806165615.1513164-5-maz@kernel.org>
 <20250807125531.GB2351327@e124191.cambridge.arm.com>
 <aJZ-wCLYh_STGiTI@linux.dev>
 <8734a0tfe4.wl-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <8734a0tfe4.wl-maz@kernel.org>
X-Migadu-Flow: FLOW_OUT

On Sat, Aug 09, 2025 at 09:21:39PM +0100, Marc Zyngier wrote:
> On Fri, 08 Aug 2025 23:48:32 +0100,
> Oliver Upton <oliver.upton@linux.dev> wrote:
> > 
> > On Thu, Aug 07, 2025 at 01:55:31PM +0100, Joey Gouly wrote:
> > > On Wed, Aug 06, 2025 at 05:56:14PM +0100, Marc Zyngier wrote:
> > > > If we have RASv1p1 on the host, advertise it to the guest in the
> > > > "canonical way", by setting ID_AA64PFR0_EL1 to V1P1, rather than
> > > > the convoluted RAS+RAS_frac method.
> > > > 
> > > > Note that this also advertises FEAT_DoubleFault, which doesn't
> > > > affect the guest at all, as only EL3 is concerned by this.
> > > > 
> > > > Signed-off-by: Marc Zyngier <maz@kernel.org>
> > > > ---
> > > >  arch/arm64/kvm/sys_regs.c | 12 ++++++++++++
> > > >  1 file changed, 12 insertions(+)
> > > > 
> > > > diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
> > > > index 1b4114790024e..66e5a733e9628 100644
> > > > --- a/arch/arm64/kvm/sys_regs.c
> > > > +++ b/arch/arm64/kvm/sys_regs.c
> > > > @@ -1800,6 +1800,18 @@ static u64 sanitise_id_aa64pfr0_el1(const struct kvm_vcpu *vcpu, u64 val)
> > > >  	if (!vcpu_has_sve(vcpu))
> > > >  		val &= ~ID_AA64PFR0_EL1_SVE_MASK;
> > > >  
> > > > +	/*
> > > > +	 * Describe RASv1p1 in a canonical way -- ID_AA64PFR1_EL1.RAS_frac
> > > > +	 * is cleared separately. Note that by advertising RASv1p1 here, we
> > > 
> > > Where is it cleared? __kvm_read_sanitised_id_reg() is where I would have
> > > expected to see it:
> > 
> > Actually, I'm a bit worried this change doesn't give us very much value
> > since Marc already does the exhaustive RASv1p1 check in the sysreg
> > emulation.
> > 
> > There's potential for breakage when migrating VMs between new/old kernels
> > on systems w/ FEAT_RASv1p1 && !FEAT_DoubleFault.
> > 
> > Marc, WDYT about dropping this patch and instead opening up RAS_frac to
> > writes?
> 
> That's indeed probably best. But the question I can't manage to answer
> right now is how we migrate RASv1p1 between the two versions? It means
> cross-idreg dependencies, ordering and all that, and I'm a bit
> reluctant to do so.

Adding our offline conversation to the list in case folks have any
concerns.

Next steps here are to allow the RAS_frac mechanism for RASv1p1 only on
RASv1p1 machines (to protect against turds like a potential RASv2p1) and
allow the user to de-feature the RAS_frac field.

A VMM that wants to migrate cross-implementation (with mixed support for
FEAT_DoubleFault) will need to compute the intersection of CPU features
and decide it needs to de-feature FEAT_RASv1p1 anyway (RAS = 0x1,
RAS_frac = 0x0) so the canonicalization isn't that big of a deal.

Thanks,
Oliver

