Return-Path: <kvm+bounces-11205-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 4094E874297
	for <lists+kvm@lfdr.de>; Wed,  6 Mar 2024 23:19:16 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id F09632826D9
	for <lists+kvm@lfdr.de>; Wed,  6 Mar 2024 22:19:14 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3B4971BC3C;
	Wed,  6 Mar 2024 22:19:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Yr/Nie1y"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6817719BA5;
	Wed,  6 Mar 2024 22:19:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709763548; cv=none; b=JAvZxSe5WQ6RZO/vHV/V4DLLWcYN53nprbX/CueK80j4ZFbjiI5RHjhB2MFFcOa0lQcDdo86VbXSPUwzrfiXOpdSbuwYKEUznvDPK7sksryytTfBZufrl9lA3TWuM0JT2js0a32DgCZBqyC8OzSq+wUa4DvfEtZ/cKbN8sul8xc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709763548; c=relaxed/simple;
	bh=t48F+o0edpL0osyU8lhPuUtT2+HsGKdKH8ZVTh6h7V4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=hq29Sn1Udk0MAxykzRAHRuv/LZIr4LSjJKrebeLltYWq48vcQHelM6C2lqcRQcTgJGYNhQyxrImvJZU9T5AtOIQBFnjsYxYm18/nAWmUaUiJ6PJ4xZEgpH4HBvKV1dvDkxH49k7Iy7l/6iA/UL1zd4dXfsLxrg7Z2Zno0Yzx0S8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Yr/Nie1y; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E02ACC433F1;
	Wed,  6 Mar 2024 22:19:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1709763548;
	bh=t48F+o0edpL0osyU8lhPuUtT2+HsGKdKH8ZVTh6h7V4=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=Yr/Nie1y90Vwms77nfC9eejNfoDV156uvdr9UabpNQ+lzf7LSMN+E3PFa1FZaqT7K
	 uLhJEsSrm+Ic+JguWnz/cAClEzk0R+YkQxHqBxi6MmZUezB1wJUabVbRuFOaNn0v5b
	 IcLxD4ilvMu68a0fe+IXImx2wC27tYbIz45UQNsCIn/kmMmreaOyc3EDWCUTRwYOeV
	 uc+dNECA+Y4cmUr0VhMeP9GacwA1JcDT5UFccjUmrMGATJm+tn+PrA9ee3TnM2/txe
	 SsREslj1yVhHNhxgzi4TTLQY/FTP0SAi0XIL5dbP46wWGGOyRZi2tc4sDkmwldiMk5
	 3pKNr0rF3DydQ==
Date: Wed, 6 Mar 2024 22:19:03 +0000
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
Message-ID: <a8416451-011c-4159-b9e4-b492b81f5a2c@sirena.org.uk>
References: <20240302111935.129994-1-maz@kernel.org>
 <20240302111935.129994-6-maz@kernel.org>
 <6acffbef-6872-4a15-b24a-7a0ec6bbb373@sirena.org.uk>
 <87edcnr8zy.wl-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="g1jHqhZvHhgVxiRs"
Content-Disposition: inline
In-Reply-To: <87edcnr8zy.wl-maz@kernel.org>
X-Cookie: Have at you!


--g1jHqhZvHhgVxiRs
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Mar 06, 2024 at 09:43:13AM +0000, Marc Zyngier wrote:
> Mark Brown <broonie@kernel.org> wrote:
> > On Sat, Mar 02, 2024 at 11:19:35AM +0000, Marc Zyngier wrote:

> > > Move the ownership tracking into the host data structure, and
> > > rename it from fp_state to fp_owner, which is a better description
> > > (name suggested by Mark Brown).

> > The SME patch series proposes adding an additional state to this
> > enumeration which would say if the registers are stored in a format
> > suitable for exchange with userspace, that would make this state part of
> > the vCPU state.  With the addition of SME we can have two vector lengths
> > in play so the series proposes picking the larger to be the format for
> > userspace registers.

> What does this addition have anything to do with the ownership of the
> physical register file? Not a lot, it seems.

> Specially as there better be no state resident on the CPU when
> userspace messes up with it.

If we have a situation where the state might be stored in memory in
multiple formats it seems reasonable to consider the metadata which
indicates which format is currently in use as part of the state.

> > We could store this separately to fp_state/owner but it'd still be a
> > value stored in the vCPU.

> I totally disagree.

Where would you expect to see the state stored?

> > Storing in a format suitable for userspace
> > usage all the time when we've got SME would most likely result in
> > performance overhead

> What performance overhead? Why should we care?

Since in situations where we're not using the larger VL we would need to
load and store the registers using a vector length other than the
currently configured vector length we would not be able to use the
ability to load and store to a location based on a multiple of the
vector length that the architecture has:

   LDR <Zt>, [<Xn|SP>{, #<imm>, MUL VL}]
   LDR <Pt>, [<Xn|SP>{, #<imm>, MUL VL}]
  =20
   STR <Zt>, [<Xn|SP>{, #<imm>, MUL VL}]
   STR <Pt>, [<Xn|SP>{, #<imm>, MUL VL}]

and would instead need to manually compute the memory locations where
values are stored.  As well as the extra instructions when using the
smaller vector length we'd also be working with sparser data likely over
more cache lines.

We would also need to consider if we need to zero the holes in the data
when saving, we'd only potentially be leaking information from the guest
but it might cause nasty surprises given that transitioning to/from
streaming mode is expected to zero values.  If we do need to zero then
that would be additional work that would need doing.

Exactly what the performance hit would be will be system and use case
dependent.  *Hopefully* we aren't needing to save and load the guest
state too often but I would be very surprised if we didn't have people
considering any cost in the guest context switch path worth paying
attention to.

As well as the performance overhead there would be some code complexity
cost, if nothing else we'd not be using the same format as fpsimd_save()
and would need to rearrange how we handle saving the register state.

Spending more effort to implement something which also has more runtime
performance overhead for the case of saving and restoring guest state
which I expect to be vastly more common than the VMM accessing the guest
registers just doesn't seem like an appealing choice.

> > if nothing else and feels more complicated than
> > rewriting the data in the relatively unusual case where userspace looks
> > at it.  Trying to convert userspace writes into the current layout would
> > have issues if the current layout uses the smaller vector length and
> > create fragility with ordering issues when loading the guest state.

> What ordering issues? If userspace manipulates the guest state, the
> guest isn't running. If it is, all bets are off.

If we were storing the data in the native format for the guest then that
format will change if streaming mode is changed via a write to SVCR.
This would mean that the host would need to understand that when writing
values SVCR needs to be written before the Z and P registers.  To be
clear I don't think this is a good idea.

> > The proposal is not the most lovely idea ever but given the architecture
> > I think some degree of clunkiness would be unavoidable.

> It is only unavoidable if we decide to make a bad job of it.

I don't think the handling of the vector registers for KVM with SME is
something where there is a clear good and bad job we can do - I don't
see how we can reasonably avoid at some point needing to translate
vector lengths or to/from FPSIMD format (in the case of a system with
SME but not SVE) which is just inherently a sharp edge.  It's just a
question of when and how we do that.

--g1jHqhZvHhgVxiRs
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAmXo69YACgkQJNaLcl1U
h9D0xAf8CC4owu06ic4id2BQ4lmWheCdTsOUUHb6p0KGQyInu0+qSwz9w44RCXVh
GBqbisSAo9UlcgNM2SZ2QGFqovvzID3tznVN8TWPquZGWmqAnKTIi2WkRcTEXEha
lBC7YzQGWRCt/dpqqQToWDidHktxkzDfE6p+DxUchLPWFkO1mqCcvQfishmqdLgN
MDPXWLC7w4ZigAyxsqwqY4Le8Ec76B8v0WKhGvpA4SwRdKpk4K4Ij3gN4vGvZqrU
UnpgqyRnEu/jkAJB5ZW4Y7o+bjuLG9MoZFFRvOEgsZmRU0++zgBAMblpJYTDAKQ1
IcxJ4RTgSQQ5G6ybth29YTp+UvPmWQ==
=SNg1
-----END PGP SIGNATURE-----

--g1jHqhZvHhgVxiRs--

