Return-Path: <kvm+bounces-10820-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 4C8CE870A1D
	for <lists+kvm@lfdr.de>; Mon,  4 Mar 2024 20:10:22 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 02B811F231B6
	for <lists+kvm@lfdr.de>; Mon,  4 Mar 2024 19:10:22 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 389C378B73;
	Mon,  4 Mar 2024 19:10:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ao0/j/TN"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5AEF178B5C;
	Mon,  4 Mar 2024 19:10:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709579414; cv=none; b=rRl1IcdVvc/1GzHg+hAJhbpRiskNJv/2NvRHcgKqhr6R5s0JfOP4wD6YtM6hV2iYElVuG8+8sqDe5ZJ152H7Lbo4c6V/xsL1Zb/k47RN9cNgpnaYSowfrf+4zLGThq+mLT3PbuyuMzXsK47lE0ty2fY6XBcqqs93aOyxWNMZjzQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709579414; c=relaxed/simple;
	bh=938sL2j3ohr65qslp9QwEEHXoKL7O5+fVugpPrTHhXE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=kumUb7Eo9m65/84hGoNU4XMpAoVT/VpIKId8tlDS7PA4kl5AjMX8T+WRyziwQc1YXvSOAAjrPbxiZpBIGo+mALbOkz8g8LdgNyMySLWu4JEm8fHGoJXfVqjJiKAAE6r8gyp7h+K4+r9yZ37esurG0d0umlJKQiO91rkFjBzrJW0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ao0/j/TN; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EA3AFC43394;
	Mon,  4 Mar 2024 19:10:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1709579414;
	bh=938sL2j3ohr65qslp9QwEEHXoKL7O5+fVugpPrTHhXE=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=ao0/j/TNLYQITc3o6JNjvuh/CMc9DvdbDr/iluypBOkT1Vt4vjdv+Tjori9wQupxC
	 5jNy0EgGmzoBQSeNHh9Ik8hKTE/EgKNzZOF5eoE49Bfk3c77LUD5s3GEuAmbXSzpUw
	 OwI0S44QsOXfLdwqDTdZyGWGmlwKcVUa6hhll/KDQoZX7nLIKFLIg+RgbypAVYMw8Z
	 HJ48htm/5E9/Owm4gFfHeNF+mF7VKZNOTeDf0nLlDUHDhMcRC2M7JuLesPPmhTW/Yx
	 OF0EFfq8wGFVUG75Oe45X+x0vvEcKtGr9zj+7EQfnhQWJgcZ9FDt96Qo0BR+fc16Yd
	 UZWqf3b8+T/TQ==
Date: Mon, 4 Mar 2024 19:10:08 +0000
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
Message-ID: <6acffbef-6872-4a15-b24a-7a0ec6bbb373@sirena.org.uk>
References: <20240302111935.129994-1-maz@kernel.org>
 <20240302111935.129994-6-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="J1BPLmtYAIajQQn7"
Content-Disposition: inline
In-Reply-To: <20240302111935.129994-6-maz@kernel.org>
X-Cookie: He who hesitates is last.


--J1BPLmtYAIajQQn7
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Sat, Mar 02, 2024 at 11:19:35AM +0000, Marc Zyngier wrote:
> In retrospect, it is fairly obvious that the FP state ownership
> is only meaningful for a given CPU, and that locating this
> information in the vcpu was just a mistake.
>=20
> Move the ownership tracking into the host data structure, and
> rename it from fp_state to fp_owner, which is a better description
> (name suggested by Mark Brown).

The SME patch series proposes adding an additional state to this
enumeration which would say if the registers are stored in a format
suitable for exchange with userspace, that would make this state part of
the vCPU state.  With the addition of SME we can have two vector lengths
in play so the series proposes picking the larger to be the format for
userspace registers. =20

We could store this separately to fp_state/owner but it'd still be a
value stored in the vCPU.  Storing in a format suitable for userspace
usage all the time when we've got SME would most likely result in
performance overhead if nothing else and feels more complicated than
rewriting the data in the relatively unusual case where userspace looks
at it.  Trying to convert userspace writes into the current layout would
have issues if the current layout uses the smaller vector length and
create fragility with ordering issues when loading the guest state.

The proposal is not the most lovely idea ever but given the architecture
I think some degree of clunkiness would be unavoidable. =20

--J1BPLmtYAIajQQn7
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAmXmHJAACgkQJNaLcl1U
h9BYsQf+LIbSo6Bh6yoOvYNuRxS7018F18Km79T9F/FzkTjPjkU6O5R8UpYKPcc/
vYV7qAWLd3mWuJ05Kdidw3JIPyxIDw4vFQ+fdV9RgVOoKn3H5DMx/Xb93T9STS5F
BJHCnPvbpWUpxJOzOLVcI4QSmb/twDDA+k4DDMnnWi6r0hgZc2tF+p+bKvAqocRI
8CrSn1tc1Jbj+oZwgygc40Ys/9OCYdDSZwErbYC6GAbczBENgBQgauXPEvStCdU0
zrfH5gwT2DHx6DSZ/mRJnMQCvQ5iShy/stB46OulB3+hgKe6mMOZlULQmgt+em3D
QFz/9XuCAOamKcJtuzfCH3i6elbWFg==
=UfFB
-----END PGP SIGNATURE-----

--J1BPLmtYAIajQQn7--

