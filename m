Return-Path: <kvm+bounces-64140-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [IPv6:2600:3c04:e001:36c::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 919C0C7A14F
	for <lists+kvm@lfdr.de>; Fri, 21 Nov 2025 15:16:36 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by tor.lore.kernel.org (Postfix) with ESMTPS id A2AF22AB31
	for <lists+kvm@lfdr.de>; Fri, 21 Nov 2025 14:16:35 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E111034B40C;
	Fri, 21 Nov 2025 14:15:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="RO9KnU9B"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E9DDA26A1B6;
	Fri, 21 Nov 2025 14:15:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763734519; cv=none; b=mo1kn/BZw15fl2PEFLA5iuPim5hWthsbVJJYESBXjTSytSoae7Leo0JatYndWtxekyKw4c7EoXaH0qMw3BmaaMJIxQdX4k3Bog5GaBAd1MbWDoMqcLMHPzIix4lCfF+s1jPlSFPhQ+qtIkOqtcB/rhD7k/V9musktzcA/WKFTqA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763734519; c=relaxed/simple;
	bh=/x9XVW86+2s3jlErW1DxxYPeq6kQMcfnJyAcrji943s=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=FqEfT8Cz8Ym9ADzMt5MAIED9E0CJPTdGaKthCNcqfhsGCcnCHUKNEW/VKPwzD7FnL5y/FTGLaLmipIsukiOV5Ltx/ufoBNeHuhz+1Fnn6qwBFGVXjPQ14ISfHG2wwrBA9G4JmciKGNor428UA+kcYugoUy6m0QanUCYG9+rUob8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=RO9KnU9B; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6A1FDC4CEF1;
	Fri, 21 Nov 2025 14:15:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1763734518;
	bh=/x9XVW86+2s3jlErW1DxxYPeq6kQMcfnJyAcrji943s=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=RO9KnU9BYDkrKXGlvOl/ypTyhmyvako5YfbMggcazRk3FQXuUavtIkMQF8Uzd+VaH
	 dmxHSq+Vp4zvq0nPr43OM/w9P9aLT3BnDoTX2N9EARRVzW4qWJc4LgBgzluILdes0+
	 RWspvMxNecFCI+J6OoYGL/5kcHLwPl5qJ9hh+fi3gW9qMKNgO3iYQ8eCvo45CmHHX/
	 9wL4TN4TO3up41kkVb/XPWmdf4x6jUUq9i6kUuRJw6zd9eQno4AL4VitkzC7lRXDBb
	 AqIvmY48uJSVk0r5Ox9gsNOePiu1DfIk39j37FTOl803KaV9ZxiQjvnNkT0CdQaXwI
	 kUo54IFnjU4fQ==
Date: Fri, 21 Nov 2025 14:15:13 +0000
From: Mark Brown <broonie@kernel.org>
To: Marc Zyngier <maz@kernel.org>
Cc: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org,
	kvm@vger.kernel.org, Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Oliver Upton <oupton@kernel.org>, Zenghui Yu <yuzenghui@huawei.com>,
	Christoffer Dall <christoffer.dall@arm.com>,
	Fuad Tabba <tabba@google.com>
Subject: Re: [PATCH v4 00/49] KVM: arm64: Add LR overflow infrastructure (the
 final one, I swear!)
Message-ID: <71adf5c4-5c12-4e06-937b-98fd0bcbd26a@sirena.org.uk>
References: <20251120172540.2267180-1-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="UQ9PUqRNEd+h0QiL"
Content-Disposition: inline
In-Reply-To: <20251120172540.2267180-1-maz@kernel.org>
X-Cookie: revolutionary, adj.:


--UQ9PUqRNEd+h0QiL
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Nov 20, 2025 at 05:24:50PM +0000, Marc Zyngier wrote:
> As $SUBJECT says, I really hope this is the last dance for this
> particular series -- I'm done with it! It was supposed to be a 5 patch
> job, and we're close to 50. Something went really wrong...
>=20
> Most of the fixes have now been squashed back into the base patches,
> and the only new patch is plugging the deactivation helper into the NV
> code, making it more correct.

I threw this at my CI and it seemed happy:

Tested-by: Mark Brown <broonie@kernel.org>

--UQ9PUqRNEd+h0QiL
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAmkgc/AACgkQJNaLcl1U
h9D+dgf/SgfgT62MCWlP6mY9hXQ3y6PsSwyLB38B4n9fZ633Gi7hKM3PCkM6PH8p
YpVOCC8fGV5dZ4x1DDCMGOmHWG57bFXP6RLGK2a2GhQWgCgj1qgERlprpOMsjItu
scfc8/LybvMd/8vw6xH/8hI3IvI4Jo+8K6abypdZ/k7ydwQWT7Y9/6TshxsjPvEB
tqrraYLtiEEVRUyCKMCUToQqxC2+XbQEoIuE+tfW8DBBGW5DEsMWVQgdNvlULDph
8/7OsrIKC2KTDiC3I6y9K7mLdc93ab/nYFiTu4oHxaotp18Wwb98NxAKTEGGY9O9
7P6EGq46SyLAnz+Y3E+YXUIRdFSZyw==
=r/t9
-----END PGP SIGNATURE-----

--UQ9PUqRNEd+h0QiL--

