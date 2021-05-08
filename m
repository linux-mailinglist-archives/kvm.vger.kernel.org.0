Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4416C376FB1
	for <lists+kvm@lfdr.de>; Sat,  8 May 2021 07:08:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230429AbhEHFJx (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 8 May 2021 01:09:53 -0400
Received: from mga05.intel.com ([192.55.52.43]:44649 "EHLO mga05.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229841AbhEHFJw (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 8 May 2021 01:09:52 -0400
IronPort-SDR: PV/luzZuE82VIC9b1M9LifUL7iKLG6C5D846ri5UNlEBF/+7VtdzUPdCRZBejh38UV83ns7JAu
 jZpiswjunfYg==
X-IronPort-AV: E=McAfee;i="6200,9189,9977"; a="284333992"
X-IronPort-AV: E=Sophos;i="5.82,282,1613462400"; 
   d="asc'?scan'208";a="284333992"
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 May 2021 22:08:52 -0700
IronPort-SDR: Dv3dGDws6GEtevLyQTECKkR1AuLUReLH1KTJFez646MGA6b4ixaiVRy+90+G3n+Xr5SvbCm8K9
 suwx2W96fVUQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.82,282,1613462400"; 
   d="asc'?scan'208";a="460405312"
Received: from zhen-hp.sh.intel.com (HELO zhen-hp) ([10.239.160.147])
  by FMSMGA003.fm.intel.com with ESMTP; 07 May 2021 22:08:50 -0700
Date:   Sat, 8 May 2021 12:50:04 +0800
From:   Zhenyu Wang <zhenyuw@linux.intel.com>
To:     Alex Williamson <alex.williamson@redhat.com>
Cc:     tkffaul@outlook.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] vfio/pci: Sanity check IGD OpRegion Size
Message-ID: <20210508045004.GH4589@zhen-hp.sh.intel.com>
Reply-To: Zhenyu Wang <zhenyuw@linux.intel.com>
References: <162041357421.21800.16214130780777455390.stgit@omen>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="KFztAG8eRSV9hGtP"
Content-Disposition: inline
In-Reply-To: <162041357421.21800.16214130780777455390.stgit@omen>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


--KFztAG8eRSV9hGtP
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On 2021.05.07 12:53:17 -0600, Alex Williamson wrote:
> The size field of the IGD OpRegion table is supposed to indicate table
> size in KB, but we've seen at least one report of a BIOS that appears
> to incorrectly report size in bytes.  The default size is 8 (*1024 =3D
> 8KB), but an incorrect implementation may report 8192 (*1024 =3D 8MB)
> and can cause a variety of mapping errors.
>=20
> It's believed that 8MB would be an implausible, if not absurd, actual
> size, so we can probably be pretty safe in assuming this is a BIOS bug
> where the intended size is likely 8KB.
>=20
> Reported-by: Travis Faulhaber <tkffaul@outlook.com>
> Tested-by: Travis Faulhaber <tkffaul@outlook.com>
> Signed-off-by: Alex Williamson <alex.williamson@redhat.com>
> ---
>  drivers/vfio/pci/vfio_pci_igd.c |   11 ++++++++++-
>  1 file changed, 10 insertions(+), 1 deletion(-)
>=20
> diff --git a/drivers/vfio/pci/vfio_pci_igd.c b/drivers/vfio/pci/vfio_pci_=
igd.c
> index 228df565e9bc..c89a4797cd18 100644
> --- a/drivers/vfio/pci/vfio_pci_igd.c
> +++ b/drivers/vfio/pci/vfio_pci_igd.c
> @@ -86,7 +86,16 @@ static int vfio_pci_igd_opregion_init(struct vfio_pci_=
device *vdev)
>  		return -EINVAL;
>  	}
> =20
> -	size *=3D 1024; /* In KB */
> +	/*
> +	 * The OpRegion size field is specified as size in KB, but there have b=
een
> +	 * user reports where this field appears to report size in bytes.  If we
> +	 * read 8192, assume this is the case.
> +	 */
> +	if (size =3D=3D OPREGION_SIZE)
> +		pci_warn(vdev->pdev,
> +			 "BIOS Bug, IGD OpRegion reports invalid size, assuming default 8KB\n=
");
> +	else
> +		size *=3D 1024; /* In KB */
> =20
>  	/*
>  	 * Support opregion v2.1+
>=20

Reviewed-by: Zhenyu Wang <zhenyuw@linux.intel.com>

thanks

--KFztAG8eRSV9hGtP
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iF0EARECAB0WIQTXuabgHDW6LPt9CICxBBozTXgYJwUCYJYYcwAKCRCxBBozTXgY
J9gLAJ9WZQAELAZanHt41Fm37Zpywbd/5wCgnfwh7QDlG6+zsX/eLRycHAm9RmY=
=mQOk
-----END PGP SIGNATURE-----

--KFztAG8eRSV9hGtP--
