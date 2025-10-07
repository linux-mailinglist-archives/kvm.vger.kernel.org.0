Return-Path: <kvm+bounces-59586-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ams.mirrors.kernel.org (ams.mirrors.kernel.org [213.196.21.55])
	by mail.lfdr.de (Postfix) with ESMTPS id 4DA7DBC21DA
	for <lists+kvm@lfdr.de>; Tue, 07 Oct 2025 18:28:35 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ams.mirrors.kernel.org (Postfix) with ESMTPS id 2193F350395
	for <lists+kvm@lfdr.de>; Tue,  7 Oct 2025 16:28:34 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 81D242E8B6F;
	Tue,  7 Oct 2025 16:28:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="V6gLOwgn"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 937CD11712;
	Tue,  7 Oct 2025 16:28:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759854498; cv=none; b=GD9euknB66oGhmLML3ObvWsyU+qbu54ywZT3KY1YzyNUxIB+oxtXslWM+5Ee0Qe5nyzgP18KbJllJVHhWuMuhj6begse5jjcpBnekUTktwH/CY55+ZQC6tZa27zT8VKQ/+PY43VWhX6kAAF+SO1wEJ7vmTbTlQ4EcatXAdmUHyE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759854498; c=relaxed/simple;
	bh=xYeA5nn/abbj5ed3ef1cNUU82SoHc8qkl+HZ9ylyjw0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=K9PgkzPY/ohSTyDwc1iScqabgDsP95NbA8LcR0dMoF3zuxqRgfaQtEnDim9DwiA9D303/rFUOB4HYV0k/tJMTD+GerzQO0ZYmZpZni4RaKYcAahQGfHV1ioK5Bc3p7VeFXQFtEnoi0ydRZ5Hvb4+oT2Ul6c10QaiDiYJB83SRnE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=V6gLOwgn; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 35AEBC4CEF7;
	Tue,  7 Oct 2025 16:28:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1759854498;
	bh=xYeA5nn/abbj5ed3ef1cNUU82SoHc8qkl+HZ9ylyjw0=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=V6gLOwgnvOxPmJz0LQMipMYO5vPDFV2CTcpBXKWlC2TaqSGT+mEm4K0D0NemSziR+
	 a4L5Jd2D+bj64roEwzpceQowvn1wIf8vSepKeIwWp//LmKqlJarXByX8yBNEm0K9wT
	 QB1ZUUIKRIHJE66kz3NZL3TUwuBF6yZcXvXc0fsz5fYo1vIIdIjgtL64vHPyF5V54T
	 nk2QNw3WoblZcLttkdFD0oPGFd3IThCJcEgCoTjVRR3FAWogq8xYeFhE8tcpkXN4BS
	 yapf08l++uGwkTeGLJagoTf86oBKBPUPxbfQKXJwnjS9kNhWRl1Lsnt2+URfaCWFtx
	 Zth3UW0roW0uw==
Date: Tue, 7 Oct 2025 17:28:12 +0100
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
Subject: Re: [PATCH 1/3] arm64/sysreg: Support feature-specific fields with
 'Feat' descriptor
Message-ID: <26d69b0d-3529-454f-9385-99a914bf1ebc@sirena.org.uk>
References: <20251007153505.1606208-1-sascha.bischoff@arm.com>
 <20251007153505.1606208-2-sascha.bischoff@arm.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="2tSGI2X8sep9nY9m"
Content-Disposition: inline
In-Reply-To: <20251007153505.1606208-2-sascha.bischoff@arm.com>
X-Cookie: Teachers have class.


--2tSGI2X8sep9nY9m
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Oct 07, 2025 at 03:35:14PM +0000, Sascha Bischoff wrote:

> Some system register field encodings change based on the available and
> in-use architecture features. In order to support these different
> field encodings, introduce the Feat descriptor (Feat, ElseFeat,
> EndFeat) for describing such sysregs.

We have other system registers which change layouts based on things
other than features, ESR_ELx is probably the most entertaining of these
but there's others like PAR_EL1.  Ideally we should probably do the
logic for generating the conditionals in a manner that's not tied to
features with a layer on top that generates standard naming for common
patterns like FEAT, but OTOH part of why that's not been done because
it's got a bunch of nasty issues so perhaps just doing the simpler case
is fine.

> The Feat descriptor can be used in the following way (Feat acts as
> both an if and an else-if):

>         Sysreg  EXAMPLE 0    1    2    3    4
>         Feat    FEAT_A
>         Field   63:0    Foo
>         Feat    FEAT_B

This assumes that there will never be nesting of these conditions in the
architecture.  I'm not sure I would want to assume that, even for plain
features though I can't think of any examples where it's an issue.
There are more serious issues with the implementation for practical
patterns with nesting (see below) which mean we might not want to deal
with that now but we should define the syntax for the file in a way that
will cope so I'd prefer not to have the implicit elses.

I'd also be inclined to say that something that's specificly for
features shouldn't repeat the FEAT_ so:

          Feat    A

instead, but that's purely a taste question.

> -	define("REG_" reg, "S" op0 "_" op1 "_C" crn "_C" crm "_" op2)
> -	define("SYS_" reg, "sys_reg(" op0 ", " op1 ", " crn ", " crm ", " op2 "=
)")
> +	feat =3D null
> +
> +	define(feat, "REG_" reg, "S" op0 "_" op1 "_C" crn "_C" crm "_" op2)
> +	define(feat, "SYS_" reg, "sys_reg(" op0 ", " op1 ", " crn ", " crm ", "=
 op2 ")")
> =20
> -	define("SYS_" reg "_Op0", op0)
> -	define("SYS_" reg "_Op1", op1)
> -	define("SYS_" reg "_CRn", crn)
> -	define("SYS_" reg "_CRm", crm)
> -	define("SYS_" reg "_Op2", op2)
> +	define(feat, "SYS_" reg "_Op0", op0)
> +	define(feat, "SYS_" reg "_Op1", op1)
> +	define(feat, "SYS_" reg "_CRn", crn)
> +	define(feat, "SYS_" reg "_CRm", crm)
> +	define(feat, "SYS_" reg "_Op2", op2)

Possibly it's worth having a reg_define() or something given the number
of things needing updating here?

> @@ -201,6 +205,7 @@ $1 =3D=3D "EndSysreg" && block_current() =3D=3D "Sysr=
eg" {
>  	res0 =3D null
>  	res1 =3D null
>  	unkn =3D null
> +	feat =3D null
> =20
>  	block_pop()
>  	next

Probably worth complaining if we end a sysreg with a feature/prefix
defined.

> +$1 =3D=3D "Feat" && (block_current() =3D=3D "Sysreg" || block_current() =
=3D=3D "SysregFields" || block_current() =3D=3D "Feat") {

=2E..

> +	next_bit =3D 63
> +
> +	res0 =3D "UL(0)"
> +	res1 =3D "UL(0)"
> +	unkn =3D "UL(0)"

This is only going to work if the whole register is in a FEAT_ block, so
you coudn't have:

        Sysreg  EXAMPLE 0    1    2    3    4
	Res0	63
        Feat    FEAT_A
        Field   62:1    Foo
        Feat    FEAT_B
        Field   62:32    Foo
        Field   31:1     Bar
	EndFeat
	Res0	0
	EndSysreg

but then supporting partial registers does have entertaining
consequences for handling Res0 and Res1.  If we're OK with that
restriction then the program should complain if someone tries to=20
define a smaller FEAT block.

--2tSGI2X8sep9nY9m
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAmjlP5sACgkQJNaLcl1U
h9AY1Qf/csPwwhVqEVz16SFCiD4J+Z7duRX2w5NTCWs3V6z30u19pzao0zemleKD
l0UdPz/T/LaiHj6hEdZqwuni6i84rlzgmbPfJ6XPXAfjmg7p4FeKBavOLU3Ablhz
yiTGGyi4INGrTu4znpmuHVT1Vx2RIeaCWPpjkTcGdJ7aHWIErjKNPzpdJTl6cz7n
f6ChusvOhN5nCKgD93MX5imL2oe+xULMuCBEhJ9EdjsWHCndFmIl/hoLv1gFJ0yJ
ppwnKqdEiszW8Gx6VUhiCILY5lkuVl0yOwM7tsol+sGEv44msyJJouplCqw1JoYt
7Rb48t0H3ra9N3XS6TOh7UQOYBKkDw==
=QE7l
-----END PGP SIGNATURE-----

--2tSGI2X8sep9nY9m--

