Return-Path: <kvm+bounces-11306-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 5A1898751D2
	for <lists+kvm@lfdr.de>; Thu,  7 Mar 2024 15:27:42 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 109DE286DF7
	for <lists+kvm@lfdr.de>; Thu,  7 Mar 2024 14:27:41 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1A62712EBEE;
	Thu,  7 Mar 2024 14:26:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="e9f8vdF9"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2D80412B144;
	Thu,  7 Mar 2024 14:26:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709821596; cv=none; b=RjxDLMKIkFv7vlMWuiqDoEc6PL/R2ZGCXCVQ/+4CvwEZ0EBP9nASWIyQNVvtenASYYhIa4Z4YVQzDwaA9e5o2F18buGD6ACDrVdBZOWytQNCkI/ozApU3W95kz/RikluZK4lAbIxgpEczSM4f2kgMgRElYHyQP/gksCMkC0OXIE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709821596; c=relaxed/simple;
	bh=ERFgShQvFhcrWGlVZuQlZmDIiSMh3WKYF+9+ofB/zXA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=qmp0gkHnjqqByh4JO0fFkhG+dm484X6azIAS39lCrNgd+Mom9DUGEgEhonAoSNUH1Fcevx5yWCpsV7iHl6XFIk4Q9YzqzDiqQWnU18Eb7WUUjcjgjNKRdbYHRg1ztr+UYnWJqjM4sqZUHTFr5Vj0CIVJFN4Igf7fgbm+F7Ymjto=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=e9f8vdF9; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B0CDFC433F1;
	Thu,  7 Mar 2024 14:26:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1709821595;
	bh=ERFgShQvFhcrWGlVZuQlZmDIiSMh3WKYF+9+ofB/zXA=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=e9f8vdF9HGfJMgvGLTCm0ewPDD+nCFGGUBCgjI8+C+uMi9IsWU20WyjcxiREjdnMv
	 2/pQty8meFGSHNDQEA9aBs/0P3SDl+oTscwuR0Ox95Ju7vMh4oxeTEk64GwOZf0ARK
	 3SECbs2szLaK+lw2JIGd1sWTUPmcsfxqSHeyo1A91m6m290CpvKoGlSgwjc5WZuT0c
	 p4k6uD4++cCwdE2w+JPEh9WsSrrz2lM7lSTY3N/BVJIOyXGiLzICDo/UX0G2ikzCLH
	 EGP1/YLnqeOP+XbnSe4r0TBW45oPnsbYuKVHX/q+88c6MXC4Ig6Q2F6JAhViXmmvYb
	 eHJokuEppoekQ==
Date: Thu, 7 Mar 2024 14:26:30 +0000
From: Mark Brown <broonie@kernel.org>
To: Marc Zyngier <maz@kernel.org>
Cc: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org,
	kvm@vger.kernel.org, James Morse <james.morse@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Oliver Upton <oliver.upton@linux.dev>,
	Zenghui Yu <yuzenghui@huawei.com>,
	James Clark <james.clark@arm.com>,
	Anshuman Khandual <anshuman.khandual@arm.com>
Subject: Re: [PATCH 5/5] KVM: arm64: Exclude FP ownership from kvm_vcpu_arch
Message-ID: <3d731a55-300e-4a14-89bb-4effbd16b781@sirena.org.uk>
References: <20240302111935.129994-1-maz@kernel.org>
 <20240302111935.129994-6-maz@kernel.org>
 <6acffbef-6872-4a15-b24a-7a0ec6bbb373@sirena.org.uk>
 <87edcnr8zy.wl-maz@kernel.org>
 <a8416451-011c-4159-b9e4-b492b81f5a2c@sirena.org.uk>
 <86msra1emn.wl-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="FRfexx2pgfvQa5A6"
Content-Disposition: inline
In-Reply-To: <86msra1emn.wl-maz@kernel.org>
X-Cookie: Been Transferred Lately?


--FRfexx2pgfvQa5A6
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Mar 07, 2024 at 11:10:40AM +0000, Marc Zyngier wrote:
> Mark Brown <broonie@kernel.org> wrote:
> > On Wed, Mar 06, 2024 at 09:43:13AM +0000, Marc Zyngier wrote:
> > > Mark Brown <broonie@kernel.org> wrote:
> > > > On Sat, Mar 02, 2024 at 11:19:35AM +0000, Marc Zyngier wrote:

> > > > The SME patch series proposes adding an additional state to this
> > > > enumeration which would say if the registers are stored in a format
> > > > suitable for exchange with userspace, that would make this state pa=
rt of
> > > > the vCPU state.  With the addition of SME we can have two vector le=
ngths
> > > > in play so the series proposes picking the larger to be the format =
for
> > > > userspace registers.

> > > What does this addition have anything to do with the ownership of the
> > > physical register file? Not a lot, it seems.

> > > Specially as there better be no state resident on the CPU when
> > > userspace messes up with it.

> > If we have a situation where the state might be stored in memory in
> > multiple formats it seems reasonable to consider the metadata which
> > indicates which format is currently in use as part of the state.

> There is no reason why the state should be in multiple formats
> *simultaneously*. All the FP/SIMD/SVE/SME state is largely
> overlapping, and we only need to correctly invalidate the state that
> isn't relevant to writes from userspace.

I agree that we don't want to store multiple copies, the proposed
implementation for SME does that - when converting between guest native
and userspace formats we discard the original format after conversion
and updates the metadata which says which format is stored.  That
metadata is modeled as adding a new owner.

> > > > We could store this separately to fp_state/owner but it'd still be a
> > > > value stored in the vCPU.

> > > I totally disagree.

> > Where would you expect to see the state stored?

> Sorry, that came out wrong. I expect *some* vcpu state to describe the
> current use of the FP/vector registers, and that's about it. Not the
> ownership information.

Ah, I think the distinction here is that you're modeling the state
tracking updated by this patch as purely tracking the registers in which
case yes, we should just add a separate variable in the vCPU for
tracking the format of the data.  I was modeling the state tracking as
covering both the state in the registers and the state of the storage
backing them (since the guest state being in the registers means that
the state in memory is invalid).

> > > > Storing in a format suitable for userspace
> > > > usage all the time when we've got SME would most likely result in
> > > > performance overhead

> > > What performance overhead? Why should we care?
> >=20
> > Since in situations where we're not using the larger VL we would need to
> > load and store the registers using a vector length other than the

=2E..

> > and would instead need to manually compute the memory locations where
> > values are stored.  As well as the extra instructions when using the
> > smaller vector length we'd also be working with sparser data likely over
> > more cache lines.

> Are you talking about a context switch? or userspace accesses? I don't
> give a damn about the latter, as it statistically never happens. The
> former is of course of interest, but you still don't explain why the
> above is a problem.

Well, there will be a cost in any rewriting so I'm trying to shift it
away from context switch to userspace access since as you say they are
negligably frequent.

> Nothing prevent you from storing the registers using the *current* VL,
> since there is no data sharing between the SVE registers and the
> streaming-SVE ones. All you need to do is to make sure you don't mix
> the two.

You seem to be suggesting modeling the streaming mode registers as a
completely different set of registers in the KVM ABI.  That would
certainly be another option, though it's a bit unclear from an
architecture point of view and it didn't seem to entirely fit with the
handling of the FPSIMD registers when SVE is in use.  From an
architecture point of view the streaming mode registers aren't really a
separate set of registers.  When in streaming mode it is not possible to
observe the non-streaming register state and vice versa, and entering or
exiting streaming mode zeros the register state so functionally you just
have floating point registers.

You'd need to handle what happens with access to the inactive register
set from userspace, the simplest thing to implement would be to read the
logical value of zero and either discard or return an error on writes.

> > We would also need to consider if we need to zero the holes in the data
> > when saving, we'd only potentially be leaking information from the guest
> > but it might cause nasty surprises given that transitioning to/from
> > streaming mode is expected to zero values.  If we do need to zero then
> > that would be additional work that would need doing.

> The zeroing is mandated by the architecture, AFAIU. That's not optional.

Yes, we need to zero at some point - we could just do it on userspace
read though I think rather than having to do it when saving.

> > Spending more effort to implement something which also has more runtime
> > performance overhead for the case of saving and restoring guest state
> > which I expect to be vastly more common than the VMM accessing the guest
> > registers just doesn't seem like an appealing choice.

> I don't buy the runtime performance aspect at all. As long as you have
> the space to dump the largest possible VL, you can always dump it in
> the native format.

Sure, my point was that you appeared to be asking to dump in a
non-native format. =20

> > If we were storing the data in the native format for the guest then that
> > format will change if streaming mode is changed via a write to SVCR.
> > This would mean that the host would need to understand that when writing
> > values SVCR needs to be written before the Z and P registers.  To be
> > clear I don't think this is a good idea.

> The architecture is crystal clear: you flip SVCR.SM, you loose all
> data in both Z and P regs. If userspace doesn't understand the
> architecture, that's their problem. The only thing we need to provide
> is a faithful emulation of the architecture.

It is not clear to me that the intention behind the KVM register ABI is
that it should have all the ordering requirements that the architecture
has, and decisions like hiding the V registers when SVE is active do
take us away from just a natural architectural point of view.  My
understanding was that it was intended that userspace should be able to
do something like just enumerate all the registers, save them and then
later on restore them without really understanding them.

--FRfexx2pgfvQa5A6
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAmXpzpYACgkQJNaLcl1U
h9DjNQgAgKUJ9sHh4bjpJJ9K8LNZGPeZaFhD0zd99CxvPkBH5ss1Mzqg6YHgNoAJ
RB0WiaPAkLvzmV7Cr0GDi/jZ3V5biM+9BN6LPitlWxU9PPosoh9NqT6ZtUJZZTAD
W+CnPS3dOUe7fRjWiI3r+WV83Agi/gRZgI5KqTWrTR/BqJSSuJ47dTemSOgQG3O6
ZLjdE7xbrDC2SVFR5jWWa90dFb6O0M/+UYC+x3xLVJhAEEDPPXeJhoiCezsCVcns
Nu+zlBbvwC3I0Acpe9+wRsWXa8ffi75H0Pn7cpRUkIrKvXqkmm23D9obYW8oXdKv
vo3xMOw+tmLPHjprLd6IsUccmUUmIw==
=NNpE
-----END PGP SIGNATURE-----

--FRfexx2pgfvQa5A6--

