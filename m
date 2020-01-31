Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7A0B314E7D4
	for <lists+kvm@lfdr.de>; Fri, 31 Jan 2020 05:19:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727979AbgAaETG (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 30 Jan 2020 23:19:06 -0500
Received: from ozlabs.org ([203.11.71.1]:48049 "EHLO ozlabs.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727448AbgAaETG (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 30 Jan 2020 23:19:06 -0500
Received: by ozlabs.org (Postfix, from userid 1007)
        id 4883rR4rtpz9sPJ; Fri, 31 Jan 2020 15:19:03 +1100 (AEDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
        d=gibson.dropbear.id.au; s=201602; t=1580444343;
        bh=YMrHIKpHZN+FtTmXPufRwCtpDmLobyzyioqBex+64Qw=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=PZMmeo7n+ILHck96MbaK5ABTN5wd7eKLwH16rx+wv59aoQ3Eg6nJoxHJS/qLONtgW
         6HJUZizCDJ/kP5aylkpdVIsFGVROKgC4Z/JARLCAst7BOYeTyjXt4CbLyoFCq30w07
         ydcLJF2m4nnce52pwYnh7Scraz1A1L2MAHekEUa4=
Date:   Fri, 31 Jan 2020 15:06:44 +1100
From:   David Gibson <david@gibson.dropbear.id.au>
To:     "Liu, Yi L" <yi.l.liu@intel.com>
Cc:     qemu-devel@nongnu.org, pbonzini@redhat.com,
        alex.williamson@redhat.com, peterx@redhat.com, mst@redhat.com,
        eric.auger@redhat.com, kevin.tian@intel.com, jun.j.tian@intel.com,
        yi.y.sun@intel.com, kvm@vger.kernel.org, hao.wu@intel.com,
        Jacob Pan <jacob.jun.pan@linux.intel.com>,
        Yi Sun <yi.y.sun@linux.intel.com>
Subject: Re: [RFC v3 03/25] hw/iommu: introduce IOMMUContext
Message-ID: <20200131040644.GG15210@umbus.fritz.box>
References: <1580300216-86172-1-git-send-email-yi.l.liu@intel.com>
 <1580300216-86172-4-git-send-email-yi.l.liu@intel.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="hcut4fGOf7Kh6EdG"
Content-Disposition: inline
In-Reply-To: <1580300216-86172-4-git-send-email-yi.l.liu@intel.com>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


--hcut4fGOf7Kh6EdG
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Jan 29, 2020 at 04:16:34AM -0800, Liu, Yi L wrote:
> From: Peter Xu <peterx@redhat.com>
>=20
> Currently, many platform vendors provide the capability of dual stage
> DMA address translation in hardware. For example, nested translation
> on Intel VT-d scalable mode, nested stage translation on ARM SMMUv3,
> and etc. Also there are efforts to make QEMU vIOMMU be backed by dual
> stage DMA address translation capability provided by hardware to have
> better address translation support for passthru devices.
>=20
> As so, making vIOMMU be backed by dual stage translation capability
> requires QEMU vIOMMU to have a way to get aware of such hardware
> capability and also require a way to receive DMA address translation
> faults (e.g. I/O page request) from host as guest owns stage-1 translation
> structures in dual stage DAM address translation.
>=20
> This patch adds IOMMUContext as an abstract of vIOMMU related operations.
> Like provide a way for passthru modules (e.g. VFIO) to register
> DualStageIOMMUObject instances. And in future, it is expected to offer
> support for receiving host DMA translation faults happened on stage-1
> translation.
>=20
> For more backgrounds, may refer to the discussion below, while there
> is also difference between the current implementation and original
> proposal. This patch introduces the IOMMUContext as an abstract layer
> for passthru module (e.g. VFIO) calls into vIOMMU. The first introduced
> interface is to make QEMU vIOMMU be aware of dual stage translation
> capability.
>=20
> https://lists.gnu.org/archive/html/qemu-devel/2019-07/msg05022.html

Again, is there a reason for not making this a QOM class or interface?


I'm not very clear on the relationship betwen an IOMMUContext and a
DualStageIOMMUObject.  Can there be many IOMMUContexts to a
DualStageIOMMUOBject?  The other way around?  Or is it just
zero-or-one DualStageIOMMUObjects to an IOMMUContext?

> Cc: Kevin Tian <kevin.tian@intel.com>
> Cc: Jacob Pan <jacob.jun.pan@linux.intel.com>
> Cc: Peter Xu <peterx@redhat.com>
> Cc: Eric Auger <eric.auger@redhat.com>
> Cc: Yi Sun <yi.y.sun@linux.intel.com>
> Cc: David Gibson <david@gibson.dropbear.id.au>
> Signed-off-by: Peter Xu <peterx@redhat.com>
> Signed-off-by: Liu Yi L <yi.l.liu@intel.com>
> ---
>  hw/iommu/Makefile.objs           |  1 +
>  hw/iommu/iommu_context.c         | 54 +++++++++++++++++++++++++++++++++++
>  include/hw/iommu/iommu_context.h | 61 ++++++++++++++++++++++++++++++++++=
++++++
>  3 files changed, 116 insertions(+)
>  create mode 100644 hw/iommu/iommu_context.c
>  create mode 100644 include/hw/iommu/iommu_context.h
>=20
> diff --git a/hw/iommu/Makefile.objs b/hw/iommu/Makefile.objs
> index d4f3b39..1e45072 100644
> --- a/hw/iommu/Makefile.objs
> +++ b/hw/iommu/Makefile.objs
> @@ -1 +1,2 @@
>  obj-y +=3D dual_stage_iommu.o
> +obj-y +=3D iommu_context.o
> diff --git a/hw/iommu/iommu_context.c b/hw/iommu/iommu_context.c
> new file mode 100644
> index 0000000..6340ca3
> --- /dev/null
> +++ b/hw/iommu/iommu_context.c
> @@ -0,0 +1,54 @@
> +/*
> + * QEMU abstract of vIOMMU context
> + *
> + * Copyright (C) 2020 Red Hat Inc.
> + *
> + * Authors: Peter Xu <peterx@redhat.com>,
> + *          Liu Yi L <yi.l.liu@intel.com>
> + *
> + * This program is free software; you can redistribute it and/or modify
> + * it under the terms of the GNU General Public License as published by
> + * the Free Software Foundation; either version 2 of the License, or
> + * (at your option) any later version.
> +
> + * This program is distributed in the hope that it will be useful,
> + * but WITHOUT ANY WARRANTY; without even the implied warranty of
> + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> + * GNU General Public License for more details.
> +
> + * You should have received a copy of the GNU General Public License alo=
ng
> + * with this program; if not, see <http://www.gnu.org/licenses/>.
> + */
> +
> +#include "qemu/osdep.h"
> +#include "hw/iommu/iommu_context.h"
> +
> +int iommu_context_register_ds_iommu(IOMMUContext *iommu_ctx,
> +                                    DualStageIOMMUObject *dsi_obj)
> +{
> +    if (!iommu_ctx || !dsi_obj) {

Would this ever happen apart from a bug in the caller?  If not it
should be an assert().

> +        return -ENOENT;
> +    }
> +
> +    if (iommu_ctx->ops && iommu_ctx->ops->register_ds_iommu) {
> +        return iommu_ctx->ops->register_ds_iommu(iommu_ctx, dsi_obj);
> +    }
> +    return -ENOENT;
> +}
> +
> +void iommu_context_unregister_ds_iommu(IOMMUContext *iommu_ctx,
> +                                      DualStageIOMMUObject *dsi_obj)
> +{
> +    if (!iommu_ctx || !dsi_obj) {
> +        return;
> +    }
> +
> +    if (iommu_ctx->ops && iommu_ctx->ops->unregister_ds_iommu) {
> +        iommu_ctx->ops->unregister_ds_iommu(iommu_ctx, dsi_obj);
> +    }
> +}
> +
> +void iommu_context_init(IOMMUContext *iommu_ctx, IOMMUContextOps *ops)
> +{
> +    iommu_ctx->ops =3D ops;
> +}
> diff --git a/include/hw/iommu/iommu_context.h b/include/hw/iommu/iommu_co=
ntext.h
> new file mode 100644
> index 0000000..6f2ccb5
> --- /dev/null
> +++ b/include/hw/iommu/iommu_context.h
> @@ -0,0 +1,61 @@
> +/*
> + * QEMU abstraction of IOMMU Context
> + *
> + * Copyright (C) 2020 Red Hat Inc.
> + *
> + * Authors: Peter Xu <peterx@redhat.com>,
> + *          Liu, Yi L <yi.l.liu@intel.com>
> + *
> + * This program is free software; you can redistribute it and/or modify
> + * it under the terms of the GNU General Public License as published by
> + * the Free Software Foundation; either version 2 of the License, or
> + * (at your option) any later version.
> +
> + * This program is distributed in the hope that it will be useful,
> + * but WITHOUT ANY WARRANTY; without even the implied warranty of
> + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> + * GNU General Public License for more details.
> +
> + * You should have received a copy of the GNU General Public License alo=
ng
> + * with this program; if not, see <http://www.gnu.org/licenses/>.
> + */
> +
> +#ifndef HW_IOMMU_CONTEXT_H
> +#define HW_IOMMU_CONTEXT_H
> +
> +#include "qemu/queue.h"
> +#ifndef CONFIG_USER_ONLY
> +#include "exec/hwaddr.h"
> +#endif
> +#include "hw/iommu/dual_stage_iommu.h"
> +
> +typedef struct IOMMUContext IOMMUContext;
> +typedef struct IOMMUContextOps IOMMUContextOps;
> +
> +struct IOMMUContextOps {
> +    /*
> +     * Register DualStageIOMMUObject to vIOMMU thus vIOMMU
> +     * is aware of dual stage translation capability, and
> +     * also be able to setup dual stage translation via
> +     * interfaces exposed by DualStageIOMMUObject.
> +     */
> +    int (*register_ds_iommu)(IOMMUContext *iommu_ctx,
> +                             DualStageIOMMUObject *dsi_obj);
> +    void (*unregister_ds_iommu)(IOMMUContext *iommu_ctx,
> +                                DualStageIOMMUObject *dsi_obj);
> +};
> +
> +/*
> + * This is an abstraction of IOMMU context.
> + */
> +struct IOMMUContext {
> +    IOMMUContextOps *ops;
> +};
> +
> +int iommu_context_register_ds_iommu(IOMMUContext *iommu_ctx,
> +                                    DualStageIOMMUObject *dsi_obj);
> +void iommu_context_unregister_ds_iommu(IOMMUContext *iommu_ctx,
> +                                       DualStageIOMMUObject *dsi_obj);
> +void iommu_context_init(IOMMUContext *iommu_ctx, IOMMUContextOps *ops);
> +
> +#endif

--=20
David Gibson			| I'll have my music baroque, and my code
david AT gibson.dropbear.id.au	| minimalist, thank you.  NOT _the_ _other_
				| _way_ _around_!
http://www.ozlabs.org/~dgibson

--hcut4fGOf7Kh6EdG
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEdfRlhq5hpmzETofcbDjKyiDZs5IFAl4zp9MACgkQbDjKyiDZ
s5ILnxAAwz0uyLrA+96XuLiZkJU3NqdNCf60z8Qc7zno3rlT/uAEJJgTYfnIV74G
0zagkc9fCNp/ivmFRNVDeuhvgptrNobw6aT5eaI4sW3+1BjbUB2O5KEHxw2gT67i
84uDMlyTTnKSlTRDjmjCbJtxD72fjqnNbBsCo0lc+H+qtH/C5NXMHVpnTSNqdpDD
Z8slR+3pdP/LBsna2o0AM2d9QnDg8Ak7/ZExyA9YXamnXaWvLTmxxpM2wweuhEUu
iVSt675Dzgo7DidsVBPV1l+kQI2/8+66BgoLFrHeTw6szJ+NeOPlmMod+jx8h02O
k7dL+Qj7ctxbT7hG1DZbfbGW0odvxT7WjI+dc3yzz/hp0GpA4+HRvdJV9UUhCx2D
5DnigmsSehV+lk5zaNhQLlnonvCraZFssHSs1g2Ed26swZTpHUleXoWZ222SYCAJ
4bcPUxvnGlkXpECc3leKfEJCf9TW5Esm4P6GeFbkQ5EuevA1KsXWn0qtVcPfwgKL
UvSBYaMQzqYb1X1PhAk+d4dg8i32qAHfOX5Gy268H42oc9hO/YPvrDV713ZYsbb4
TJkEVmBpjy8ZNxe7st7Ag6dsjy2t67Gk0a39hFyG7cCoDQd1khGgtGsVKssqpEkQ
6HivGpsuXvGSHw2T+ynV4X/DjM/Kx9HQ1wsaQB4rjWsCneK+sMo=
=vboI
-----END PGP SIGNATURE-----

--hcut4fGOf7Kh6EdG--
