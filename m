Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9B3396E0E5
	for <lists+kvm@lfdr.de>; Fri, 19 Jul 2019 08:10:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727317AbfGSGI5 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 19 Jul 2019 02:08:57 -0400
Received: from mga17.intel.com ([192.55.52.151]:28944 "EHLO mga17.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726600AbfGSGI5 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 19 Jul 2019 02:08:57 -0400
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by fmsmga107.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 18 Jul 2019 23:08:57 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.64,281,1559545200"; 
   d="asc'?scan'208";a="170814276"
Received: from zhen-hp.sh.intel.com (HELO zhen-hp) ([10.239.13.116])
  by orsmga003.jf.intel.com with ESMTP; 18 Jul 2019 23:08:53 -0700
Date:   Fri, 19 Jul 2019 14:05:40 +0800
From:   Zhenyu Wang <zhenyuw@linux.intel.com>
To:     Kechen Lu <kechen.lu@intel.com>
Cc:     intel-gvt-dev@lists.freedesktop.org, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Tina Zhang <tina.zhang@intel.com>,
        kraxel@redhat.com, zhenyuw@linux.intel.com, zhiyuan.lv@intel.com,
        zhi.a.wang@intel.com, kevin.tian@intel.com, hang.yuan@intel.com,
        alex.williamson@redhat.com, Eric Auger <eric.auger@redhat.com>
Subject: Re: [RFC PATCH v4 1/6] vfio: Define device specific irq type
 capability
Message-ID: <20190719060540.GC28809@zhen-hp.sh.intel.com>
Reply-To: Zhenyu Wang <zhenyuw@linux.intel.com>
References: <20190718155640.25928-1-kechen.lu@intel.com>
 <20190718155640.25928-2-kechen.lu@intel.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="1ccMZA6j1vT5UqiK"
Content-Disposition: inline
In-Reply-To: <20190718155640.25928-2-kechen.lu@intel.com>
User-Agent: Mutt/1.10.0 (2018-05-17)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


--1ccMZA6j1vT5UqiK
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On 2019.07.18 23:56:35 +0800, Kechen Lu wrote:
> From: Tina Zhang <tina.zhang@intel.com>
>=20
> Cap the number of irqs with fixed indexes and use capability chains
> to chain device specific irqs.
>=20
> Signed-off-by: Tina Zhang <tina.zhang@intel.com>
> Signed-off-by: Eric Auger <eric.auger@redhat.com>
> ---
>  include/uapi/linux/vfio.h | 19 ++++++++++++++++++-
>  1 file changed, 18 insertions(+), 1 deletion(-)
>=20
> diff --git a/include/uapi/linux/vfio.h b/include/uapi/linux/vfio.h
> index 8f10748dac79..be6adab4f759 100644
> --- a/include/uapi/linux/vfio.h
> +++ b/include/uapi/linux/vfio.h
> @@ -448,11 +448,27 @@ struct vfio_irq_info {
>  #define VFIO_IRQ_INFO_MASKABLE		(1 << 1)
>  #define VFIO_IRQ_INFO_AUTOMASKED	(1 << 2)
>  #define VFIO_IRQ_INFO_NORESIZE		(1 << 3)
> +#define VFIO_IRQ_INFO_FLAG_CAPS		(1 << 4) /* Info supports caps */
>  	__u32	index;		/* IRQ index */
>  	__u32	count;		/* Number of IRQs within this index */
> +	__u32	cap_offset;	/* Offset within info struct of first cap */

This still breaks ABI as argsz would be updated with this new field, so it =
would
cause compat issue. I think my last suggestion was to assume cap list start=
s after
vfio_irq_info.

>  };
>  #define VFIO_DEVICE_GET_IRQ_INFO	_IO(VFIO_TYPE, VFIO_BASE + 9)
> =20
> +/*
> + * The irq type capability allows irqs unique to a specific device or
> + * class of devices to be exposed.
> + *
> + * The structures below define version 1 of this capability.
> + */
> +#define VFIO_IRQ_INFO_CAP_TYPE      3
> +
> +struct vfio_irq_info_cap_type {
> +	struct vfio_info_cap_header header;
> +	__u32 type;     /* global per bus driver */
> +	__u32 subtype;  /* type specific */
> +};
> +
>  /**
>   * VFIO_DEVICE_SET_IRQS - _IOW(VFIO_TYPE, VFIO_BASE + 10, struct vfio_ir=
q_set)
>   *
> @@ -554,7 +570,8 @@ enum {
>  	VFIO_PCI_MSIX_IRQ_INDEX,
>  	VFIO_PCI_ERR_IRQ_INDEX,
>  	VFIO_PCI_REQ_IRQ_INDEX,
> -	VFIO_PCI_NUM_IRQS
> +	VFIO_PCI_NUM_IRQS =3D 5	/* Fixed user ABI, IRQ indexes >=3D5 use   */
> +				/* device specific cap to define content */
>  };
> =20
>  /*
> --=20
> 2.17.1
>=20

--=20
Open Source Technology Center, Intel ltd.

$gpg --keyserver wwwkeys.pgp.net --recv-keys 4D781827

--1ccMZA6j1vT5UqiK
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iF0EARECAB0WIQTXuabgHDW6LPt9CICxBBozTXgYJwUCXTFdtAAKCRCxBBozTXgY
J+A6AKCdu+X82qvxu8+c+G7Xf2KT4EPb+QCcDuu89yudz4pTfaN3llmqJsIf1LQ=
=mAF2
-----END PGP SIGNATURE-----

--1ccMZA6j1vT5UqiK--
