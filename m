Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 19C3A27C086
	for <lists+kvm@lfdr.de>; Tue, 29 Sep 2020 11:09:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727887AbgI2JJb (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 29 Sep 2020 05:09:31 -0400
Received: from mga04.intel.com ([192.55.52.120]:8993 "EHLO mga04.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727831AbgI2JJb (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 29 Sep 2020 05:09:31 -0400
IronPort-SDR: 5nG2zDOC1VUSQ/8TIJzpCbXvHLOnEHGtLtVAIHItc/xBI6PrJ3MYi4tHhaqJEGoChA60dWveRm
 tU+xV8uyvwPA==
X-IronPort-AV: E=McAfee;i="6000,8403,9758"; a="159525592"
X-IronPort-AV: E=Sophos;i="5.77,317,1596524400"; 
   d="asc'?scan'208";a="159525592"
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Sep 2020 02:09:29 -0700
IronPort-SDR: V8B+5zTyvtgoVu447vuHYdkRQH8Z5TJxy2UP8i/0hZHyPQeN3SxAY9LP/badVJ3iuMTYBodH4Q
 Fl7WEtaA/4LA==
X-IronPort-AV: E=Sophos;i="5.77,317,1596524400"; 
   d="asc'?scan'208";a="489399476"
Received: from zhen-hp.sh.intel.com (HELO zhen-hp) ([10.239.160.147])
  by orsmga005-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Sep 2020 02:09:26 -0700
Date:   Tue, 29 Sep 2020 16:49:26 +0800
From:   Zhenyu Wang <zhenyuw@linux.intel.com>
To:     Fred Gao <fred.gao@intel.com>
Cc:     kvm@vger.kernel.org, intel-gfx@lists.freedesktop.org,
        Xiong Zhang <xiong.y.zhang@intel.com>,
        Hang Yuan <hang.yuan@linux.intel.com>,
        Stuart Summers <stuart.summers@intel.com>,
        Lucas De Marchi <lucas.demarchi@intel.com>
Subject: Re: [PATCH v2] vfio/pci: Refine Intel IGD OpRegion support
Message-ID: <20200929084926.GH27141@zhen-hp.sh.intel.com>
Reply-To: Zhenyu Wang <zhenyuw@linux.intel.com>
References: <20200929161038.15465-1-fred.gao@intel.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="HlL+5n6rz5pIUxbD"
Content-Disposition: inline
In-Reply-To: <20200929161038.15465-1-fred.gao@intel.com>
User-Agent: Mutt/1.10.0 (2018-05-17)
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


--HlL+5n6rz5pIUxbD
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable


On 2020.09.30 00:10:38 +0800, Fred Gao wrote:
> Bypass the IGD initialization for Intel's dgfx devices with own expansion
> ROM and the host/LPC bridge config space are no longer accessed.
>=20
> v2: simply test if discrete or integrated gfx device
>     with root bus. (Alex Williamson)
>

Patch title is somehow misleading that better change to what this one does
that skip VFIO IGD setup for Intel discrete graphics card.

With that,

Reviewed-by: Zhenyu Wang <zhenyuw@linux.intel.com>

> Cc: Zhenyu Wang <zhenyuw@linux.intel.com>
> Cc: Xiong Zhang <xiong.y.zhang@intel.com>
> Cc: Hang Yuan <hang.yuan@linux.intel.com>
> Cc: Stuart Summers <stuart.summers@intel.com>
> Signed-off-by: Lucas De Marchi <lucas.demarchi@intel.com>
> Signed-off-by: Fred Gao <fred.gao@intel.com>
> ---
>  drivers/vfio/pci/vfio_pci.c | 5 +++--
>  1 file changed, 3 insertions(+), 2 deletions(-)
>=20
> diff --git a/drivers/vfio/pci/vfio_pci.c b/drivers/vfio/pci/vfio_pci.c
> index f634c81998bb..9258ccfadb79 100644
> --- a/drivers/vfio/pci/vfio_pci.c
> +++ b/drivers/vfio/pci/vfio_pci.c
> @@ -336,10 +336,11 @@ static int vfio_pci_enable(struct vfio_pci_device *=
vdev)
>  	if (!vfio_vga_disabled() && vfio_pci_is_vga(pdev))
>  		vdev->has_vga =3D true;
> =20
> -
> +	/* Intel's dgfx should not appear on root bus */
>  	if (vfio_pci_is_vga(pdev) &&
>  	    pdev->vendor =3D=3D PCI_VENDOR_ID_INTEL &&
> -	    IS_ENABLED(CONFIG_VFIO_PCI_IGD)) {
> +	    IS_ENABLED(CONFIG_VFIO_PCI_IGD) &&
> +	    pci_is_root_bus(pdev->bus)) {
>  		ret =3D vfio_pci_igd_init(vdev);
>  		if (ret) {
>  			pci_warn(pdev, "Failed to setup Intel IGD regions\n");
> --=20
> 2.24.1.1.gb6d4d82bd5
>=20

--=20

$gpg --keyserver wwwkeys.pgp.net --recv-keys 4D781827

--HlL+5n6rz5pIUxbD
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iF0EARECAB0WIQTXuabgHDW6LPt9CICxBBozTXgYJwUCX3L1FQAKCRCxBBozTXgY
J0HhAJ4zPRLTzVpVZIG1lz/KPtRhS21HnwCeN0l7hSLjgzmKH81NVxD5ObtDDfU=
=fdQd
-----END PGP SIGNATURE-----

--HlL+5n6rz5pIUxbD--
