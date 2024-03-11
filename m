Return-Path: <kvm+bounces-11586-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id D92FD878832
	for <lists+kvm@lfdr.de>; Mon, 11 Mar 2024 19:52:50 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 02A501C20F0B
	for <lists+kvm@lfdr.de>; Mon, 11 Mar 2024 18:52:50 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 666EB54BFC;
	Mon, 11 Mar 2024 18:42:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="TpuEq2nq"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 91C3454BCC;
	Mon, 11 Mar 2024 18:42:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710182552; cv=none; b=dLTFYNR3eGkf6H1q4Ql93r8lic4l4+mwOhrBr+VfxNU+pe1CP8VVi6+/KSS+/biuPZVV/jlrge39mGCSI1sBMTGk2vLFMvOdm5NgKej0rUPjTh7MbHLeeqp/KYYgbuh/M0kCFPDWFvJ175cKGtD2FgY5fYKJWjmDoXhBdT47aOo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710182552; c=relaxed/simple;
	bh=Kc9yLJoZjEazNZ+uf/PLacshqdOi5zfu6FUN3Wusjnw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=pXEogzd6EpA+4BAFHYzTX0SDZqoWMgm/37+tGOpYg9Aa4erHVUKgRH41gqRToohM0E/YL8K9JyKH4SPqCHFDnIaDIVIq0S/sWGaYPSNtD/f5fk1Qz9eZqJLAIBtN/RH/EW24KBGf64K3GnKnxoIfRde+TbdNdnvDzcs2YCezjeE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=TpuEq2nq; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 01AC9C433C7;
	Mon, 11 Mar 2024 18:42:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1710182552;
	bh=Kc9yLJoZjEazNZ+uf/PLacshqdOi5zfu6FUN3Wusjnw=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=TpuEq2nqosdlFrvyzjeIJx7ay/njWzDEzO8GoLCEpQjeCvluXXfNKWagp0eArlqX+
	 Klztx4s5rM55baeMyTdXF4if0iz152j5KwzUvPFSSHPV9pbq9kH49tlKtekckvX054
	 Q1I6uWkbHkGQ7iLnBly1geygkthafXRuumbqBx3gwXlUCuWA7CiMmCtOQJmsUwU1gp
	 pEnzCiaJuGOPn8q3DbBKYepcvkei4gMaPULuneiiZFMq0j05018UHyr8twmiSJSOf+
	 5Txdf3aMjRfnLq3IbqAJqp8RVTrk3t2XS79tMpCNAgE1lgG0t0Uq6trNV/0KpULreF
	 V6S8+AovemC9g==
Date: Mon, 11 Mar 2024 18:42:27 +0000
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
Message-ID: <420150f4-f6bf-4c23-a9b8-78651f139137@sirena.org.uk>
References: <20240302111935.129994-1-maz@kernel.org>
 <20240302111935.129994-6-maz@kernel.org>
 <6acffbef-6872-4a15-b24a-7a0ec6bbb373@sirena.org.uk>
 <87edcnr8zy.wl-maz@kernel.org>
 <a8416451-011c-4159-b9e4-b492b81f5a2c@sirena.org.uk>
 <86msra1emn.wl-maz@kernel.org>
 <3d731a55-300e-4a14-89bb-4effbd16b781@sirena.org.uk>
 <871q8jr7mj.wl-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="JxquxlKQKGqK2/P1"
Content-Disposition: inline
In-Reply-To: <871q8jr7mj.wl-maz@kernel.org>
X-Cookie: Sorry.  Nice try.


--JxquxlKQKGqK2/P1
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Sat, Mar 09, 2024 at 11:01:56AM +0000, Marc Zyngier wrote:
> Mark Brown <broonie@kernel.org> wrote:

> > I agree that we don't want to store multiple copies, the proposed
> > implementation for SME does that - when converting between guest native
> > and userspace formats we discard the original format after conversion
> > and updates the metadata which says which format is stored.  That
> > metadata is modeled as adding a new owner.

> What conversion? If userspace writes to FP, the upper bits of the SVE
> registers should get zeroed. If it writes to SVE, it writes using the
> current VL for the current streaming/non-streaming mode.

> If the current userspace API doesn't give us the tools to do so, we
> rev it.

This is the conversion of vector lengths rather than something resulting
=66rom acccessing from accessing the V registers via the sysreg interface
(which is not supported by either upstream or the currently posted SME
patches once either vector extension is enabled).  As previously
mentioned the current implementation of SME support for KVM always
presents the vector length sized registers to userspace with the maximum
vector length, not the vector length currently selected by SVCR.

> > > Nothing prevent you from storing the registers using the *current* VL,
> > > since there is no data sharing between the SVE registers and the
> > > streaming-SVE ones. All you need to do is to make sure you don't mix
> > > the two.

> > You seem to be suggesting modeling the streaming mode registers as a
> > completely different set of registers in the KVM ABI.

> Where are you reading this? I *never* said anything of the sort. There
> is only one set of SVE registers. The fact that they change size and
> get randomly zeroed when userspace flips bits is a property of the
> architecture. The HW *can* implements them as two sets of registers if
> SME is a separate accelerator, but that's not architectural.

When you talk about there being "no data sharing" and "mixing the two"
that sounds a lot like there might be two separate sets of data.  I've
been inferring a lot of what you are looking for from statements that
you make about other ideas and from the existing code and documentation
so things are less clear than they might be and it's likely there's been
some assumptions missed in places.  In order to try to clarify things
I've written down a summary of what I currently understand you're
looking for below.

> All I'm saying is that you can have a *single* register file, spanning
> both FPSIMD and SVE, using the maximum VL achievable in the guest, and

When you say "using" there I take it that you mean "sized to store"
rather than "written/accessed in the format for" since elsewhere you've
been taking about storing the current native format and changing the VL
in the ABI based on SVCR.SM?  I would have read "using the maximum VL
achievable in the guest" as meaning we store in a format reflecting the
larger VL but I'm pretty sure it's just the allocation you're
referencing there.

To be clear what I'm currently understanding for the userspace ABI is:

 - Create a requirement for userspace to set SVCR prior to setting any
   vector impacted register to ensure the correct format and that data
   isn't zeroed when SVCR is set.
 - Use the value of SVCR.SM and the guest maximum SVE and SME VLs to
   select the currently visible vector length for the Z, P and FFR
   registers.
 - This also implies discarding or failing all writes to ZA and ZT0
   unless SVCR.ZA is set for consistency, though that's much less
   impactful in terms of the implementation.
 - Add support for the V registers in the sysreg interface when SVE is
   enabled.

then the implementation can do what it likes to achieve that, the most
obvious thing being to store in native format for the current hardware
mode based on SVCR.{SM,ZA}.  Does that sound about right?

If that's all good the main thing I'm unclear on your expectations for
is what should happen with registers that are inaccessible in the
current mode (Z, P and FFR when in non-streaming mode without SVE, FFR
when in streaming mode without FA64, and ZA and ZT0 when SVCR.ZA is 0).
Having these registers cause errors on access as they would in the
architecture but I worry about complicating and potentially breaking the
ABI by having enumerable but inaccessible registers, though I think
that's more in line with your general thinking.  The main alternative
would be RAZ/WI style behavior which isn't quite what the architecture
does but does give what the guest would observe when it changes modes
and looks at the contents of those registers.

> be done with it. Yes, you'll have to refactor the code so that FPSIMD
> lands at the right spot in the SVE register file. Big deal.

At present the ABI just disables the V registers when SVE is enabled, I
was slightly surprised at that implementation and was concerned there
might be something that was considered desirable about the removal of
ambiguity (the changelog for the relevant commit did mention that it was
convenient to implement).

> > My
> > understanding was that it was intended that userspace should be able to
> > do something like just enumerate all the registers, save them and then
> > later on restore them without really understanding them.

> And this statement doesn't get in the way of anything above. We own
> the ABI, and can change it as we see fit when SME is enabled.

If you're willing to require specific ordering knowledge to do guest
state load then that makes life a bit easier for the implementation.  It
had appeared that VMMs could have existing ABI expectations about how
they can enumerate, store and load the state the guest implements which
we would cause problems by breaking.

--JxquxlKQKGqK2/P1
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAmXvUJIACgkQJNaLcl1U
h9Anmwf+NQ0to9AAGq4vGRF7Im1hnws64OG/qVENspIUGMsioQEW2HD3I9OHohrP
zgQhhMRnSn1x6crH6P68RLyyJLlROCrWQ1Rq3ipuHJT5NSW+yo9NuDzJBPJzEHrw
V4zmc+PFlRIzMd9Wanii+FqV4Rnuplz4SqiIuIpcxDCy1x0Xw8fMSMpnTEqleJ4x
KE/sPLuODP2lq5dft9rB51D4xDQHiSjx0HkudEatIq+RnonzVQkr0McCwesrf3RA
q9LO68CqniGgRArxmio59ax5FCu1+9yd67E0fiJVLK5MCrE9f6e48UMtzHeHLCYU
a6qq1AyFbaYkL5jx+7shi2Qhy9wC5Q==
=uhWm
-----END PGP SIGNATURE-----

--JxquxlKQKGqK2/P1--

