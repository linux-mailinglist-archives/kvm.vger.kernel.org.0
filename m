Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 53E5B375EF4
	for <lists+kvm@lfdr.de>; Fri,  7 May 2021 05:00:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230413AbhEGDBn (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 6 May 2021 23:01:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45078 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229942AbhEGDBm (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 6 May 2021 23:01:42 -0400
Received: from ozlabs.org (ozlabs.org [IPv6:2401:3900:2:1::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B6230C061574
        for <kvm@vger.kernel.org>; Thu,  6 May 2021 20:00:43 -0700 (PDT)
Received: by ozlabs.org (Postfix, from userid 1007)
        id 4FbwDm2j3Tz9sXS; Fri,  7 May 2021 13:00:40 +1000 (AEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
        d=gibson.dropbear.id.au; s=201602; t=1620356440;
        bh=V3Col8QuO+oqxyxGF4EMsfKrF/pUgQZGNFIpssOh0AI=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=edza2LeyxxkxmGtfpPhcz3XklUpdUgN1Aqkrr6AcESVHjA5NDMONhLDq8vdFR0mA9
         Ev2aVcmxor+FyG9jCJ03f7dIGIn4hb2rHFiwsWWm+ATaBNAgAA30gKGrnmOTaCbya4
         p4Coak2+knhaXxjx8cMB2Ef29JD/zmObxV8j8DFo=
Date:   Fri, 7 May 2021 11:05:35 +1000
From:   David Gibson <david@gibson.dropbear.id.au>
To:     Philippe =?iso-8859-1?Q?Mathieu-Daud=E9?= <philmd@redhat.com>
Cc:     qemu-devel@nongnu.org, kvm@vger.kernel.org, qemu-ppc@nongnu.org,
        qemu-arm@nongnu.org, Gerd Hoffmann <kraxel@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Alex =?iso-8859-1?Q?Benn=E9e?= <alex.bennee@linaro.org>,
        Greg Kurz <groug@kaod.org>
Subject: Re: [PATCH v2 9/9] target/ppc/kvm: Replace alloca() by g_malloc()
Message-ID: <YJSSX1eUIecBpwwX@yekko>
References: <20210506133758.1749233-1-philmd@redhat.com>
 <20210506133758.1749233-10-philmd@redhat.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="g1x6QJlBgI8sUhxy"
Content-Disposition: inline
In-Reply-To: <20210506133758.1749233-10-philmd@redhat.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


--g1x6QJlBgI8sUhxy
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, May 06, 2021 at 03:37:58PM +0200, Philippe Mathieu-Daud=E9 wrote:
> The ALLOCA(3) man-page mentions its "use is discouraged".
>=20
> Replace it by a g_malloc() call.
>=20
> Signed-off-by: Philippe Mathieu-Daud=E9 <philmd@redhat.com>
> ---
>  target/ppc/kvm.c | 3 +--
>  1 file changed, 1 insertion(+), 2 deletions(-)
>=20
> diff --git a/target/ppc/kvm.c b/target/ppc/kvm.c
> index 104a308abb5..63c458e2211 100644
> --- a/target/ppc/kvm.c
> +++ b/target/ppc/kvm.c
> @@ -2698,11 +2698,10 @@ int kvmppc_save_htab(QEMUFile *f, int fd, size_t =
bufsize, int64_t max_ns)
>  int kvmppc_load_htab_chunk(QEMUFile *f, int fd, uint32_t index,
>                             uint16_t n_valid, uint16_t n_invalid, Error *=
*errp)
>  {
> -    struct kvm_get_htab_header *buf;
>      size_t chunksize =3D sizeof(*buf) + n_valid * HASH_PTE_SIZE_64;
> +    g_autofree struct kvm_get_htab_header *buf =3D g_malloc(chunksize);

Um.. that doesn't look like it would compile, since you use
sizeof(*buf) before declaring buf.

>      ssize_t rc;
> =20
> -    buf =3D alloca(chunksize);
>      buf->index =3D index;
>      buf->n_valid =3D n_valid;
>      buf->n_invalid =3D n_invalid;

--=20
David Gibson			| I'll have my music baroque, and my code
david AT gibson.dropbear.id.au	| minimalist, thank you.  NOT _the_ _other_
				| _way_ _around_!
http://www.ozlabs.org/~dgibson

--g1x6QJlBgI8sUhxy
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEdfRlhq5hpmzETofcbDjKyiDZs5IFAmCUkl0ACgkQbDjKyiDZ
s5JeShAAtE6r+nLzXGSDEwW1F4BeqX9QVewuCmaxNGgnLxraxLHuO0ME9IMsp0jM
xJg2sv+KFC9axYu1o2RZeGeH8+wGBusgofIRlxmL28+jIgYyFeD/VQZM5Fh2C/Qz
apTpHA6Pjn6Ed6d8qk+6cTCAYj4cEZkq+4PvI7Rf492WLPDJxKMa28DeUdJ4Oe/K
SsYZIgJMRXrgk8ckPEJ7faYweaBtVxlvIK8yt/dKJuv+u33oHMoFwwqfPJP2i5ed
LKCl5bN/wEMGkaD5iP39AgPbLf5ICl2W3wB42+jbsewTBwCzr//+Oudl1Qt7Okns
08kk6GFbK/9jLrSUDUAN8JUblIzPGu0QF+QEsWGaCvgnL+EXHUDBNjv9BtEpupPt
KauPOUXwA6XA6gEnU3N3S5kP9QlN1sWs9Df0wH0flbJo62cGFAg1A1ZxgCmyayfZ
H3c7bPsQvTm1lB6YEHAirHe2FB5G9blsNAZU4dtMsxxdm2uOK87rEwuwFzW3XfZY
aNcENy3aYUbKVLSOWoeRLLlvtVXHAT8afhN1RYtaby+mA8w/fI22IW1F55scEz1B
AZSDqkJ0ZDmNM3KUY+n6YRJeYvTTQJNIgAO5Lud5533d9hZFxD3HVD7oogXykAaL
XYG+MJamQEwkV5wZr9VXyy543zqIwRatQdJk7RAxeHPsqt8lYsY=
=JBda
-----END PGP SIGNATURE-----

--g1x6QJlBgI8sUhxy--
