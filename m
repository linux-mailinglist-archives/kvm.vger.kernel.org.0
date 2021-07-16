Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 405EB3CB2FE
	for <lists+kvm@lfdr.de>; Fri, 16 Jul 2021 09:12:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235208AbhGPHP1 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 16 Jul 2021 03:15:27 -0400
Received: from mga11.intel.com ([192.55.52.93]:52773 "EHLO mga11.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229930AbhGPHPZ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 16 Jul 2021 03:15:25 -0400
X-IronPort-AV: E=McAfee;i="6200,9189,10046"; a="207663283"
X-IronPort-AV: E=Sophos;i="5.84,244,1620716400"; 
   d="asc'?scan'208";a="207663283"
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Jul 2021 00:12:29 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.84,244,1620716400"; 
   d="asc'?scan'208";a="495951551"
Received: from zhen-hp.sh.intel.com (HELO zhen-hp) ([10.239.160.143])
  by FMSMGA003.fm.intel.com with ESMTP; 16 Jul 2021 00:12:21 -0700
Date:   Fri, 16 Jul 2021 14:50:57 +0800
From:   Zhenyu Wang <zhenyuw@linux.intel.com>
To:     Jason Gunthorpe <jgg@nvidia.com>
Cc:     David Airlie <airlied@linux.ie>,
        Tony Krowiak <akrowiak@linux.ibm.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Jonathan Corbet <corbet@lwn.net>,
        Daniel Vetter <daniel@ffwll.ch>,
        Diana Craciun <diana.craciun@oss.nxp.com>,
        dri-devel@lists.freedesktop.org,
        Eric Auger <eric.auger@redhat.com>,
        Eric Farman <farman@linux.ibm.com>,
        Harald Freudenberger <freude@linux.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>,
        Heiko Carstens <hca@linux.ibm.com>,
        intel-gfx@lists.freedesktop.org,
        intel-gvt-dev@lists.freedesktop.org,
        Jani Nikula <jani.nikula@linux.intel.com>,
        Jason Herne <jjherne@linux.ibm.com>,
        Joonas Lahtinen <joonas.lahtinen@linux.intel.com>,
        kvm@vger.kernel.org, Kirti Wankhede <kwankhede@nvidia.com>,
        linux-doc@vger.kernel.org, linux-s390@vger.kernel.org,
        Matthew Rosato <mjrosato@linux.ibm.com>,
        Peter Oberparleiter <oberpar@linux.ibm.com>,
        Halil Pasic <pasic@linux.ibm.com>,
        Rodrigo Vivi <rodrigo.vivi@intel.com>,
        Vineeth Vijayan <vneethv@linux.ibm.com>,
        Zhenyu Wang <zhenyuw@linux.intel.com>,
        Zhi Wang <zhi.a.wang@intel.com>,
        "Raj, Ashok" <ashok.raj@intel.com>, Christoph Hellwig <hch@lst.de>,
        Leon Romanovsky <leonro@nvidia.com>,
        Max Gurtovoy <mgurtovoy@nvidia.com>,
        Yishai Hadas <yishaih@nvidia.com>
Subject: Re: [PATCH 12/13] vfio/gvt: Fix open/close when multiple device FDs
 are open
Message-ID: <20210716065057.GA13928@zhen-hp.sh.intel.com>
Reply-To: Zhenyu Wang <zhenyuw@linux.intel.com>
References: <0-v1-eaf3ccbba33c+1add0-vfio_reflck_jgg@nvidia.com>
 <12-v1-eaf3ccbba33c+1add0-vfio_reflck_jgg@nvidia.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="k+w/mQv8wyuph6w0"
Content-Disposition: inline
In-Reply-To: <12-v1-eaf3ccbba33c+1add0-vfio_reflck_jgg@nvidia.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


--k+w/mQv8wyuph6w0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On 2021.07.14 21:20:41 -0300, Jason Gunthorpe wrote:
> The user can open multiple device FDs if it likes, however the open
> function calls vfio_register_notifier() on device global state. Calling
> vfio_register_notifier() twice will trigger a WARN_ON from
> notifier_chain_register() and the first close will wrongly delete the
> notifier and more.
>=20
> Since these really want the new open/close_device() semantics just change
> the function over.
>=20
> Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
> ---
>  drivers/gpu/drm/i915/gvt/kvmgt.c | 8 ++++----
>  1 file changed, 4 insertions(+), 4 deletions(-)
>=20
> diff --git a/drivers/gpu/drm/i915/gvt/kvmgt.c b/drivers/gpu/drm/i915/gvt/=
kvmgt.c
> index 1ac98f8aba31e6..7efa386449d104 100644
> --- a/drivers/gpu/drm/i915/gvt/kvmgt.c
> +++ b/drivers/gpu/drm/i915/gvt/kvmgt.c
> @@ -885,7 +885,7 @@ static int intel_vgpu_group_notifier(struct notifier_=
block *nb,
>  	return NOTIFY_OK;
>  }
> =20
> -static int intel_vgpu_open(struct mdev_device *mdev)
> +static int intel_vgpu_open_device(struct mdev_device *mdev)
>  {
>  	struct intel_vgpu *vgpu =3D mdev_get_drvdata(mdev);
>  	struct kvmgt_vdev *vdev =3D kvmgt_vdev(vgpu);
> @@ -1004,7 +1004,7 @@ static void __intel_vgpu_release(struct intel_vgpu =
*vgpu)
>  	vgpu->handle =3D 0;
>  }
> =20
> -static void intel_vgpu_release(struct mdev_device *mdev)
> +static void intel_vgpu_close_device(struct mdev_device *mdev)
>  {
>  	struct intel_vgpu *vgpu =3D mdev_get_drvdata(mdev);
> =20
> @@ -1753,8 +1753,8 @@ static struct mdev_parent_ops intel_vgpu_ops =3D {
>  	.create			=3D intel_vgpu_create,
>  	.remove			=3D intel_vgpu_remove,
> =20
> -	.open			=3D intel_vgpu_open,
> -	.release		=3D intel_vgpu_release,
> +	.open_device		=3D intel_vgpu_open_device,
> +	.close_device		=3D intel_vgpu_close_device,
> =20
>  	.read			=3D intel_vgpu_read,
>  	.write			=3D intel_vgpu_write,

Looks ok to me. Thanks!

Reviewed-by: Zhenyu Wang <zhenyuw@linux.intel.com>

--k+w/mQv8wyuph6w0
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iF0EARECAB0WIQTXuabgHDW6LPt9CICxBBozTXgYJwUCYPEsTAAKCRCxBBozTXgY
Jx7CAJwL3rjxtO0hmyVLloknYXTNq4Pl4gCcC95wG37YNR4DYMf5Ns1jbuH5Nqk=
=WTLJ
-----END PGP SIGNATURE-----

--k+w/mQv8wyuph6w0--
