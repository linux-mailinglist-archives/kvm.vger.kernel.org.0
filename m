Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5A832374D5D
	for <lists+kvm@lfdr.de>; Thu,  6 May 2021 04:18:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231328AbhEFCTP (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 5 May 2021 22:19:15 -0400
Received: from bilbo.ozlabs.org ([203.11.71.1]:52781 "EHLO ozlabs.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229872AbhEFCTO (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 5 May 2021 22:19:14 -0400
Received: by ozlabs.org (Postfix, from userid 1007)
        id 4FbHLJ0vvfz9sW5; Thu,  6 May 2021 12:18:16 +1000 (AEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
        d=gibson.dropbear.id.au; s=201602; t=1620267496;
        bh=ZLuFZc3g0T5FC1Zhjaern/QiWQO1K7L2BDXOenwvxO0=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=IZB/Fbg7YTL6JL+E25yHLmr+W4Ctgm2Rx4i9N/meGx0hC6G/PSNCIHyYPyzD85g7k
         bZUr83zCV6I+qnSFz3BwutSgKXcOqg05wDBys8FtTGjQpvAiB41v73UxBfhFlTA6th
         H8+DO5Oa7xlwwNG2NpS9jOCpSAVGpNDr+mm62QH4=
Date:   Thu, 6 May 2021 12:18:09 +1000
From:   David Gibson <david@gibson.dropbear.id.au>
To:     Philippe =?iso-8859-1?Q?Mathieu-Daud=E9?= <philmd@redhat.com>
Cc:     qemu-devel@nongnu.org, Paolo Bonzini <pbonzini@redhat.com>,
        Warner Losh <imp@bsdimp.com>, Kyle Evans <kevans@freebsd.org>,
        Greg Kurz <groug@kaod.org>,
        Alex =?iso-8859-1?Q?Benn=E9e?= <alex.bennee@linaro.org>,
        "open list:PowerPC TCG CPUs" <qemu-ppc@nongnu.org>,
        "open list:Overall KVM CPUs" <kvm@vger.kernel.org>
Subject: Re: [PATCH 5/5] target/ppc/kvm: Replace alloca() by g_malloc()
Message-ID: <YJNR4W21LXT0vRPb@yekko>
References: <20210505170055.1415360-1-philmd@redhat.com>
 <20210505170055.1415360-6-philmd@redhat.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="m22QEPzxGV2bZflI"
Content-Disposition: inline
In-Reply-To: <20210505170055.1415360-6-philmd@redhat.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


--m22QEPzxGV2bZflI
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, May 05, 2021 at 07:00:55PM +0200, Philippe Mathieu-Daud=E9 wrote:
> The ALLOCA(3) man-page mentions its "use is discouraged".
>=20
> Replace it by a g_malloc() call.
>=20
> Signed-off-by: Philippe Mathieu-Daud=E9 <philmd@redhat.com>

Acked-by: David Gibson <david@gibson.dropbear.id.au>

> ---
>  target/ppc/kvm.c | 10 +++++-----
>  1 file changed, 5 insertions(+), 5 deletions(-)
>=20
> diff --git a/target/ppc/kvm.c b/target/ppc/kvm.c
> index 104a308abb5..ae62daddf7d 100644
> --- a/target/ppc/kvm.c
> +++ b/target/ppc/kvm.c
> @@ -2698,11 +2698,11 @@ int kvmppc_save_htab(QEMUFile *f, int fd, size_t =
bufsize, int64_t max_ns)
>  int kvmppc_load_htab_chunk(QEMUFile *f, int fd, uint32_t index,
>                             uint16_t n_valid, uint16_t n_invalid, Error *=
*errp)
>  {
> -    struct kvm_get_htab_header *buf;
> -    size_t chunksize =3D sizeof(*buf) + n_valid * HASH_PTE_SIZE_64;
> +    size_t chunksize =3D sizeof(struct kvm_get_htab_header)
> +                       + n_valid * HASH_PTE_SIZE_64;
>      ssize_t rc;
> +    g_autofree struct kvm_get_htab_header *buf =3D g_malloc(chunksize);
> =20
> -    buf =3D alloca(chunksize);
>      buf->index =3D index;
>      buf->n_valid =3D n_valid;
>      buf->n_invalid =3D n_invalid;
> @@ -2741,10 +2741,10 @@ void kvmppc_read_hptes(ppc_hash_pte64_t *hptes, h=
waddr ptex, int n)
>      i =3D 0;
>      while (i < n) {
>          struct kvm_get_htab_header *hdr;
> +        char buf[sizeof(*hdr) + HPTES_PER_GROUP * HASH_PTE_SIZE_64];
>          int m =3D n < HPTES_PER_GROUP ? n : HPTES_PER_GROUP;
> -        char buf[sizeof(*hdr) + m * HASH_PTE_SIZE_64];
> =20
> -        rc =3D read(fd, buf, sizeof(buf));
> +        rc =3D read(fd, buf, sizeof(*hdr) + m * HASH_PTE_SIZE_64);
>          if (rc < 0) {
>              hw_error("kvmppc_read_hptes: Unable to read HPTEs");
>          }

--=20
David Gibson			| I'll have my music baroque, and my code
david AT gibson.dropbear.id.au	| minimalist, thank you.  NOT _the_ _other_
				| _way_ _around_!
http://www.ozlabs.org/~dgibson

--m22QEPzxGV2bZflI
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEdfRlhq5hpmzETofcbDjKyiDZs5IFAmCTUeEACgkQbDjKyiDZ
s5KPbw/+MQVWvvwspJ/Fg3nDdAfuprco2JYk0mz0Fln7P1W2dO1IUnlvyblai7Mm
pIABl7RrSkHV2NZUZ6/R5q5CoZY+Pd4sFpyuRYcRLlkACljeEQk72CXheUXJWfPz
K7ngp/LY2FBHMv5PCI5Ng++BPR/aG2y56+4Pdp1FBa0OOck4cNNTrTF8ruwHr1K7
hZwyoIrcrNrqDH7VUXxOCr1mK55na2AxkBHFhIBsAKh41jl/oIBZ43I+lTo03pHv
D03KxiREVZDJ7jLc87TuEBu6DN3iY4ma6D63rsGALzIaQ98pnrq4i/d+Rrcte+S/
2JH5pAGHupns2/PH7W4UNrwXgpTO70pF+iTyKXB+zveA/3/1jtnLugLI82CFnDK7
s0Sbpklqw7rVKyBWtPfRQSHN0Vx+JTYZ3pcMpE9tzeLkeQPrYsuNOUF39IxW+CYq
QmRpijKzpx6EQ3lzDm4Rc2WFtclg73u0Z5p61xmij60asZDO3YustO6sUs4Qa4rB
oWF+QvH5ibhSbxhufiL7CmPXWvsCiSTyAWdZtSICmCk+uhBgAjFMRgSxmzs8ESI7
lzSbAOCreThZvhYH6Ugto0xjJa0HRo5CKu8DlFcNxymIw6CmYqLnN6a553cT45cl
A1LpSpT3iFPo5o1Ag6In9I/EHzW+4NJmzjpcoOq4mv0G6PMrMOs=
=1Oa8
-----END PGP SIGNATURE-----

--m22QEPzxGV2bZflI--
