Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 82700342255
	for <lists+kvm@lfdr.de>; Fri, 19 Mar 2021 17:43:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231157AbhCSQmy (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 19 Mar 2021 12:42:54 -0400
Received: from mail.kernel.org ([198.145.29.99]:57558 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230176AbhCSQml (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 19 Mar 2021 12:42:41 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 5594B6197D;
        Fri, 19 Mar 2021 16:42:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1616172160;
        bh=VvUapEq2wKe3jRL/2pb7xke5nb1W78nB9EG7oF+dI0E=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=JTaq5qq1C71cvBEa8m+Q0Nbhc5upiRJe/SjVFYBRLZmkfeAbqo/sg0DGGYx68+PEr
         AWfGuefxzylcaIlKZfkJoJalo4AYTnupqTIT3Py1VpRyxq5fX2ntvqQvftDyNnngbO
         eV2Nm0OCgW7zid1MmShZ7DlFiwSEYWxROortaSSIMROq14ShsblOK2r8/C8gxlBg/W
         pXXPUDRmuYRixaNLV6DYomItoSXmxWiuW5Abk+no/FSr1/1agoOWvWaaSwjqFGHqt5
         ymTlHQmKKXuUV5amaO4XQUXo2MP2DlRXaNo7dj6OYJqqRPGTIHQEZpFFq8qip8iWbh
         YSGn80oH4OfaQ==
Date:   Fri, 19 Mar 2021 16:42:36 +0000
From:   Mark Brown <broonie@kernel.org>
To:     Marc Zyngier <maz@kernel.org>
Cc:     kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org,
        kvm@vger.kernel.org, dave.martin@arm.com, daniel.kiss@arm.com,
        Will Deacon <will@kernel.org>,
        Catalin Marinas <catalin.marinas@arm.com>,
        James Morse <james.morse@arm.com>,
        Julien Thierry <julien.thierry.kdev@gmail.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>, ascull@google.com,
        qperret@google.com, kernel-team@android.com
Subject: Re: [PATCH v2 05/11] arm64: sve: Provide a conditional update
 accessor for ZCR_ELx
Message-ID: <20210319164236.GH5619@sirena.org.uk>
References: <20210318122532.505263-1-maz@kernel.org>
 <20210318122532.505263-6-maz@kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="GBDnBH7+ZvLx8QD4"
Content-Disposition: inline
In-Reply-To: <20210318122532.505263-6-maz@kernel.org>
X-Cookie: No purchase necessary.
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


--GBDnBH7+ZvLx8QD4
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Mar 18, 2021 at 12:25:26PM +0000, Marc Zyngier wrote:

> A common pattern is to conditionally update ZCR_ELx in order
> to avoid the "self-synchronizing" effect that writing to this
> register has.
>=20
> Let's provide an accessor that does exactly this.

Reviewed-by: Mark Brown <broonie@kernel.org>

> +#define sve_cond_update_zcr_vq(val, reg)		\
> +	do {						\
> +		u64 __zcr =3D read_sysreg_s((reg));	\
> +		u64 __new =3D __zcr & ~ZCR_ELx_LEN_MASK;	\
> +		__new |=3D (val) & ZCR_ELx_LEN_MASK;	\
> +		if (__zcr !=3D __new)			\
> +			write_sysreg_s(__new, (reg));	\
> +	} while (0)
> +

Do compilers actually do much better with this than with a static
inline like the other functions in this header?  Seems like something
they should be figuring out.

--GBDnBH7+ZvLx8QD4
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAmBU1HsACgkQJNaLcl1U
h9CM/gf+N7nbcXjDF0+HU24muCH+sUwbBDrs3PP+0I2Sqcmu0zMshrnD7tuL5xNU
lWckrtiVBzELjoz0UfVEl+sh+pzeh7fUZHEB3Bbz4AFQYxJhusvp3auTiN8DfWs4
YM6T4hoSYAE8QpnPtz2N8llENkU5mudFoRnp6cZHK/7nGp/A5c+ZTsBp01UO8p/C
vl+eSWW7J07t5txdE8m19+a8GTmyHbI9Fl8Op5jR+9rfcRarVTcpMIszYwc+bwan
O2DTbyC8ZeHKjCxpwh1zIXCy2WgUUFWHW/XOPZmhWooOfWlZQy67j/9jLgJs/cCi
qwMvWZUBJaRClgmANXsPOg92w13MLg==
=QV3R
-----END PGP SIGNATURE-----

--GBDnBH7+ZvLx8QD4--
