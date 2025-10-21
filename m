Return-Path: <kvm+bounces-60710-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [IPv6:2605:f480:58:1:0:1994:3:14])
	by mail.lfdr.de (Postfix) with ESMTPS id 05091BF83CD
	for <lists+kvm@lfdr.de>; Tue, 21 Oct 2025 21:23:00 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id 7A3B14F2512
	for <lists+kvm@lfdr.de>; Tue, 21 Oct 2025 19:22:55 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 93CB2351FD9;
	Tue, 21 Oct 2025 19:22:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="XSF1yFGA"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B0447351FA1;
	Tue, 21 Oct 2025 19:22:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761074559; cv=none; b=rfpCd2M5KDcqZGPmtu4I5boVHeScLTRtwzWHpW+TfKKSk7iILWF/4/cYTEeVQ/AlCGkS4YgqzuIyWUdq0eEf72W1ESygDA3zludwsnSRJJQmqt4mYrCL6swFrem/xHUH6GXtzP+xCMiHx1aTF9F1f/YaxEEOJjMLV8bSqnPtj/o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761074559; c=relaxed/simple;
	bh=kLQuZ77APTbGac5pbyjhPnx3O7zXM+2TL9oYOXoVcaA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=c7WxXotF/IxsbXNE4L0DJcVUdbDfZGdnVhWLRiIfn0HM0qO71r8IVvbA7tnrj/qTihWfzk8eZSlkJbx++65Noxh2DiGwuHJN4se9Q8K+BNs+B/NMs06GMqg1oIN2lUR/jRQjg3RRKH9zqGyLgIqgYIgjBvyBFoAzs4RoUCPgJUU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=XSF1yFGA; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3A024C4CEF1;
	Tue, 21 Oct 2025 19:22:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1761074558;
	bh=kLQuZ77APTbGac5pbyjhPnx3O7zXM+2TL9oYOXoVcaA=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=XSF1yFGAgyigzdVw99xrgCcGbbjXdnIUa003MIJBj4ylEg24A+tkpzeCuVHFA5ycd
	 jxreQ/tWeCavNXjT6wJA8bz3HcUNfe1l818hKm9f9XONLVjlmHS6bCQgEaotYXBV7y
	 6YiCBNlzjrR5dHFsSg3tGUABit4yTxpqV/Ao1sgqy9zYa/S/sHgqS14FCKSwdnT0fX
	 CEfAZ5Mw5SLX+ZeXfsv9QJIgSZGL1uaTouGGRyAhwvxLSHrwvZqG6o8sGBYzwEoyr4
	 bLgz3UV6Ah4fimNpBa2Dgx3M/u0B4DJQExGeJj3p1f3ckDQ9Dx1CBSqn9UWjsBPJyK
	 h/kX0B+zBreSg==
Date: Tue, 21 Oct 2025 20:22:32 +0100
From: Mark Brown <broonie@kernel.org>
To: Sascha Bischoff <Sascha.Bischoff@arm.com>
Cc: "linux-arm-kernel@lists.infradead.org" <linux-arm-kernel@lists.infradead.org>,
	"kvmarm@lists.linux.dev" <kvmarm@lists.linux.dev>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"kvm@vger.kernel.org" <kvm@vger.kernel.org>, nd <nd@arm.com>,
	Mark Rutland <Mark.Rutland@arm.com>,
	Catalin Marinas <Catalin.Marinas@arm.com>,
	"maz@kernel.org" <maz@kernel.org>,
	"oliver.upton@linux.dev" <oliver.upton@linux.dev>,
	Joey Gouly <Joey.Gouly@arm.com>,
	Suzuki Poulose <Suzuki.Poulose@arm.com>,
	"yuzenghui@huawei.com" <yuzenghui@huawei.com>,
	"will@kernel.org" <will@kernel.org>,
	"lpieralisi@kernel.org" <lpieralisi@kernel.org>
Subject: Re: [PATCH v2 2/4] arm64/sysreg: Support feature-specific fields
 with 'Prefix' descriptor
Message-ID: <c835fd10-5590-42de-b968-4696917b41be@sirena.org.uk>
References: <20251009165427.437379-1-sascha.bischoff@arm.com>
 <20251009165427.437379-3-sascha.bischoff@arm.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="3FiDR95fQGlL7dSr"
Content-Disposition: inline
In-Reply-To: <20251009165427.437379-3-sascha.bischoff@arm.com>
X-Cookie: Accordion, n.:


--3FiDR95fQGlL7dSr
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Oct 09, 2025 at 04:54:48PM +0000, Sascha Bischoff wrote:

> The Prefix descriptor can be used in the following way:
>=20
>         Sysreg  EXAMPLE 0    1    2    3    4
>         Prefix    FEAT_A
> 	Field   63:0    Foo
> 	EndPrefix
> 	Prefix    FEAT_B
> 	Field   63:1    Bar
>  	Res0    0
>         EndPrefix
>         Field   63:0    Baz
>         EndSysreg

This seems like a reasonable solution to the practical problem, and the
implementation seems OK:

Reviewed-by: Mark Brown <broonie@kernel.org>

I think trying to do too much more would open up far too many cans of
worms to be reasonable to block things on.

One nit:

>  # Parse a "<msb>[:<lsb>]" string into the global variables @msb and @lsb
> @@ -132,10 +149,7 @@ $1 =3D=3D "EndSysregFields" && block_current() =3D=
=3D "SysregFields" {
>  	if (next_bit >=3D 0)
>  		fatal("Unspecified bits in " reg)
> =20
> -	define(reg "_RES0", "(" res0 ")")
> -	define(reg "_RES1", "(" res1 ")")
> -	define(reg "_UNKN", "(" unkn ")")
> -	print ""
> +	define_resx_unkn(prefix, reg, res0, res1, unkn)

This refactoring into a function seems like it could usefully have been
a separate patch.

--3FiDR95fQGlL7dSr
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAmj33XcACgkQJNaLcl1U
h9Cyhwf/YsjdawmSEFXnz/ThgkSJaPvHJwggse623h6Bi/49edb4f21ET1S3ThkF
bFxUYa0RApCMFMiYaLsHHihwrO5JoZRxXUyeqRezt9sGxk/RbO+ii/hOZp0OpZ1q
hgrM0srqSvxRqpXuDBWLS0tzGQaviyvWAIlN3xVQBwoNdQTVKYQSjtzyEFoC6pJp
LIZ5mCLSSQcE6+kgDFSMenCY4xp5eiVIo1FwftEm0RilTpCMvHrdBV02ncIqcwn2
Tb9iX7KoyX6Y/EUnqwHhdvhioeqwCk7YkQlzHC1ihPKntAVLutzjb6lCfSDTZa2J
odMHxKAzSvAvp4UTXOo98nuAKnlQDw==
=BAQL
-----END PGP SIGNATURE-----

--3FiDR95fQGlL7dSr--

