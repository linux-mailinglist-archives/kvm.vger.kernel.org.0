Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4897435D46C
	for <lists+kvm@lfdr.de>; Tue, 13 Apr 2021 02:26:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243909AbhDMA0q (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 12 Apr 2021 20:26:46 -0400
Received: from bilbo.ozlabs.org ([203.11.71.1]:45177 "EHLO ozlabs.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239645AbhDMA0p (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 12 Apr 2021 20:26:45 -0400
Received: by ozlabs.org (Postfix, from userid 1007)
        id 4FK5xs5rVdz9sWX; Tue, 13 Apr 2021 10:26:25 +1000 (AEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
        d=gibson.dropbear.id.au; s=201602; t=1618273585;
        bh=K+re1xAJo3EiW64Z8O31AYLAA/6WJY72c+pyc2hdygs=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=fEMixVVXOLf8Tioz71eq2HiwEL0gbPMct5aTquAopzuiLdneI0wp3jMKDBsz+yJWw
         ENtnBL8bKDd/w238Q8COb3xgcJuOqlJ5V5aRscpu22BtdohJebt4fTcTSiENXyUpQG
         hTYwehURGA7CgnDZ23Ul8kY5K3+bptyuLp1KIuBQ=
Date:   Tue, 13 Apr 2021 10:24:14 +1000
From:   David Gibson <david@gibson.dropbear.id.au>
To:     "Christian A. Ehrhardt" <lk@c--e.de>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Alex Williamson <alex.williamson@redhat.com>,
        Alexey Kardashevskiy <aik@ozlabs.ru>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Cornelia Huck <cohuck@redhat.com>
Subject: Re: [PATCH] vfio/pci: Add missing range check in vfio_pci_mmap
Message-ID: <YHTkrvXRGrfzJXlv@yekko.fritz.box>
References: <20210410230013.GC416417@lisa.in-ulm.de>
 <20210412140238.184e141f@omen>
 <20210412214124.GA241759@lisa.in-ulm.de>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="lFf8eGH+B7CgY5sW"
Content-Disposition: inline
In-Reply-To: <20210412214124.GA241759@lisa.in-ulm.de>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


--lFf8eGH+B7CgY5sW
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Apr 12, 2021 at 11:41:24PM +0200, Christian A. Ehrhardt wrote:
>=20
> When mmaping an extra device region verify that the region index
> derived from the mmap offset is valid.
>=20
> Fixes: a15b1883fee1 ("vfio_pci: Allow mapping extra regions")
> Cc: stable@vger.kernel.org
> Signed-off-by: Christian A. Ehrhardt <lk@c--e.de>

Reviewed-by: David Gibson <david@gibson.dropbear.id.au>

> ---
>  drivers/vfio/pci/vfio_pci.c | 4 +++-
>  1 file changed, 3 insertions(+), 1 deletion(-)
>=20
> diff --git a/drivers/vfio/pci/vfio_pci.c b/drivers/vfio/pci/vfio_pci.c
> index 65e7e6b44578..5023e23db3bc 100644
> --- a/drivers/vfio/pci/vfio_pci.c
> +++ b/drivers/vfio/pci/vfio_pci.c
> @@ -1656,6 +1656,8 @@ static int vfio_pci_mmap(void *device_data, struct =
vm_area_struct *vma)
> =20
>  	index =3D vma->vm_pgoff >> (VFIO_PCI_OFFSET_SHIFT - PAGE_SHIFT);
> =20
> +	if (index >=3D VFIO_PCI_NUM_REGIONS + vdev->num_regions)
> +		return -EINVAL;
>  	if (vma->vm_end < vma->vm_start)
>  		return -EINVAL;
>  	if ((vma->vm_flags & VM_SHARED) =3D=3D 0)
> @@ -1664,7 +1666,7 @@ static int vfio_pci_mmap(void *device_data, struct =
vm_area_struct *vma)
>  		int regnum =3D index - VFIO_PCI_NUM_REGIONS;
>  		struct vfio_pci_region *region =3D vdev->region + regnum;
> =20
> -		if (region && region->ops && region->ops->mmap &&
> +		if (region->ops && region->ops->mmap &&
>  		    (region->flags & VFIO_REGION_INFO_FLAG_MMAP))
>  			return region->ops->mmap(vdev, region, vma);
>  		return -EINVAL;

--=20
David Gibson			| I'll have my music baroque, and my code
david AT gibson.dropbear.id.au	| minimalist, thank you.  NOT _the_ _other_
				| _way_ _around_!
http://www.ozlabs.org/~dgibson

--lFf8eGH+B7CgY5sW
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEdfRlhq5hpmzETofcbDjKyiDZs5IFAmB05K0ACgkQbDjKyiDZ
s5K+ng//dpAJrZVrBcWPmyRDzm0cUbxKm5RMDcTbWRLfAiZCPZZH2oDAyvJJB3ZJ
oZXSS7o1ThT+ngz/doZwdU1hb7RRZuRnYML8dS68/YF31v6nsMyprXMhS6KWklF3
DjNrS48aJIz7B0DFG/mKklUEiTJe80ftUFsAEWO1QxLT3bBoqnf0EaD+2uH8ZtYn
Gj/GaYrg829brfkRMxaL0rKSSwQmvMfdDNA2UN9xmMxFLpT1+L5MW5Fb3RrzaNNc
fNLu4ooM6Zh/yInREnWUCWU7VVJENlogqUCfez8GyNdBr594pCIgvsDWNu4hW/Kh
Rn0TuEBCqVlSgPxl2c3jjbR7zbRUE3nuCjVtZqrGTfEQnmBUAp9BlxO9/fpeAtjT
gJIfkD+tlpOvQNWvevlfe8XQ3YMiHwDUysuDxaU7ABkKrgO+8lmqVjJSkieLEiOz
GgYZEj/z01Q2yHtx9jREdskILw+L7ZiSuzLO3xhkfohvY1d8cT2i1vj3dyUf+aq6
NsrkbhHZjDq2XNweoiQXtQnwzZMZLrCOIuyzKIjzUsueg9fLybHV37jUk7pSyzMa
QJ+raXoJzDJ1javPNmyG0gF7zMR6ygMH+686V6kqqMr2iKnlF0BqappAGk6LlYhI
a2CpTVyGJAPx3uypdQvyWUKqc7C9bcDgQwUvLY5BCzef75XaNzg=
=BeT5
-----END PGP SIGNATURE-----

--lFf8eGH+B7CgY5sW--
