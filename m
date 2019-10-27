Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 16A06E64B2
	for <lists+kvm@lfdr.de>; Sun, 27 Oct 2019 18:48:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727360AbfJ0RsG (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 27 Oct 2019 13:48:06 -0400
Received: from ozlabs.org ([203.11.71.1]:51103 "EHLO ozlabs.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727069AbfJ0RsF (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 27 Oct 2019 13:48:05 -0400
Received: by ozlabs.org (Postfix, from userid 1007)
        id 471QL95K96z9sPL; Mon, 28 Oct 2019 04:48:01 +1100 (AEDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
        d=gibson.dropbear.id.au; s=201602; t=1572198481;
        bh=TDXLHWLNnqSo7qgAsvJM05PMm7+dNRlhU5WtQdoLRbU=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=FgUdiZgzsWlw02NZ9d5SrpKVv9wjpLqTatHxIJMoq3xtNcJuggw7jd3HAL94DvVCs
         YdW7dwloaqXk3QdDPR1lP2T52H3WkZ2rU5ccoyBOmrL2XC8kohwuG0qNfxXboaQM5R
         qA1cNBQYXTGK9aP4zNystvzCKhwDCmvVxms3zMG4=
Date:   Sun, 27 Oct 2019 18:39:29 +0100
From:   David Gibson <david@gibson.dropbear.id.au>
To:     Liu Yi L <yi.l.liu@intel.com>
Cc:     qemu-devel@nongnu.org, mst@redhat.com, pbonzini@redhat.com,
        alex.williamson@redhat.com, peterx@redhat.com,
        eric.auger@redhat.com, tianyu.lan@intel.com, kevin.tian@intel.com,
        jun.j.tian@intel.com, yi.y.sun@intel.com,
        jacob.jun.pan@linux.intel.com, kvm@vger.kernel.org,
        Yi Sun <yi.y.sun@linux.intel.com>
Subject: Re: [RFC v2 04/22] hw/iommu: introduce IOMMUContext
Message-ID: <20191027173929.GK3552@umbus.metropole.lan>
References: <1571920483-3382-1-git-send-email-yi.l.liu@intel.com>
 <1571920483-3382-5-git-send-email-yi.l.liu@intel.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="M0YLxmUXciMpOLPE"
Content-Disposition: inline
In-Reply-To: <1571920483-3382-5-git-send-email-yi.l.liu@intel.com>
User-Agent: Mutt/1.12.1 (2019-06-15)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


--M0YLxmUXciMpOLPE
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Oct 24, 2019 at 08:34:25AM -0400, Liu Yi L wrote:
> From: Peter Xu <peterx@redhat.com>
>=20
> This patch adds IOMMUContext as an abstract layer of IOMMU related
> operations. The current usage of this abstract layer is setup dual-
> stage IOMMU translation (vSVA) for vIOMMU.
>=20
> To setup dual-stage IOMMU translation, vIOMMU needs to propagate
> guest changes to host via passthru channels (e.g. VFIO). To have
> a better abstraction, it is better to avoid direct calling between
> vIOMMU and VFIO. So we have this new structure to act as abstract
> layer between VFIO and vIOMMU. So far, it is proposed to provide a
> notifier mechanism, which registered by VFIO and fired by vIOMMU.
>=20
> For more background, may refer to the discussion below:
>=20
> https://lists.gnu.org/archive/html/qemu-devel/2019-07/msg05022.html
>=20
> Cc: Kevin Tian <kevin.tian@intel.com>
> Cc: Jacob Pan <jacob.jun.pan@linux.intel.com>
> Cc: Peter Xu <peterx@redhat.com>
> Cc: Eric Auger <eric.auger@redhat.com>
> Cc: Yi Sun <yi.y.sun@linux.intel.com>
> Cc: David Gibson <david@gibson.dropbear.id.au>
> Signed-off-by: Peter Xu <peterx@redhat.com>
> Signed-off-by: Liu Yi L <yi.l.liu@intel.com>
> ---
>  hw/Makefile.objs         |  1 +
>  hw/iommu/Makefile.objs   |  1 +
>  hw/iommu/iommu.c         | 66 ++++++++++++++++++++++++++++++++++++++++
>  include/hw/iommu/iommu.h | 79 ++++++++++++++++++++++++++++++++++++++++++=
++++++
>  4 files changed, 147 insertions(+)
>  create mode 100644 hw/iommu/Makefile.objs
>  create mode 100644 hw/iommu/iommu.c
>  create mode 100644 include/hw/iommu/iommu.h
>=20
> diff --git a/hw/Makefile.objs b/hw/Makefile.objs
> index ece6cc3..ac19f9c 100644
> --- a/hw/Makefile.objs
> +++ b/hw/Makefile.objs
> @@ -39,6 +39,7 @@ devices-dirs-y +=3D xen/
>  devices-dirs-$(CONFIG_MEM_DEVICE) +=3D mem/
>  devices-dirs-y +=3D semihosting/
>  devices-dirs-y +=3D smbios/
> +devices-dirs-y +=3D iommu/
>  endif
> =20
>  common-obj-y +=3D $(devices-dirs-y)
> diff --git a/hw/iommu/Makefile.objs b/hw/iommu/Makefile.objs
> new file mode 100644
> index 0000000..0484b79
> --- /dev/null
> +++ b/hw/iommu/Makefile.objs
> @@ -0,0 +1 @@
> +obj-y +=3D iommu.o
> diff --git a/hw/iommu/iommu.c b/hw/iommu/iommu.c
> new file mode 100644
> index 0000000..2391b0d
> --- /dev/null
> +++ b/hw/iommu/iommu.c
> @@ -0,0 +1,66 @@
> +/*
> + * QEMU abstract of IOMMU context
> + *
> + * Copyright (C) 2019 Red Hat Inc.
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
> +#include "hw/iommu/iommu.h"
> +
> +void iommu_ctx_notifier_register(IOMMUContext *iommu_ctx,
> +                                 IOMMUCTXNotifier *n,
> +                                 IOMMUCTXNotifyFn fn,
> +                                 IOMMUCTXEvent event)
> +{
> +    n->event =3D event;
> +    n->iommu_ctx_event_notify =3D fn;
> +    QLIST_INSERT_HEAD(&iommu_ctx->iommu_ctx_notifiers, n, node);

Having this both modify the IOMMUCTXNotifier structure and insert it
in the list seems confusing to me - and gratuitously different from
the interface for both IOMMUNotifier and Notifier.

Separating out a iommu_ctx_notifier_init() as a helper and having
register take a fully initialized structure seems better to me.

> +    return;

Using an explicit return at the end of a function returning void is an
odd style.

> +}
> +
> +void iommu_ctx_notifier_unregister(IOMMUContext *iommu_ctx,
> +                                   IOMMUCTXNotifier *notifier)
> +{
> +    IOMMUCTXNotifier *cur, *next;
> +
> +    QLIST_FOREACH_SAFE(cur, &iommu_ctx->iommu_ctx_notifiers, node, next)=
 {
> +        if (cur =3D=3D notifier) {
> +            QLIST_REMOVE(cur, node);
> +            break;
> +        }
> +    }
> +}
> +
> +void iommu_ctx_event_notify(IOMMUContext *iommu_ctx,
> +                            IOMMUCTXEventData *event_data)
> +{
> +    IOMMUCTXNotifier *cur;
> +
> +    QLIST_FOREACH(cur, &iommu_ctx->iommu_ctx_notifiers, node) {
> +        if ((cur->event =3D=3D event_data->event) &&
> +                                 cur->iommu_ctx_event_notify) {

Do you actually need the test on iommu_ctx_event_notify?  I can't see
any reason to register a notifier with a NULL function pointer.

> +            cur->iommu_ctx_event_notify(cur, event_data);
> +        }
> +    }
> +}
> +
> +void iommu_context_init(IOMMUContext *iommu_ctx)
> +{
> +    QLIST_INIT(&iommu_ctx->iommu_ctx_notifiers);
> +}
> diff --git a/include/hw/iommu/iommu.h b/include/hw/iommu/iommu.h
> new file mode 100644
> index 0000000..c22c442
> --- /dev/null
> +++ b/include/hw/iommu/iommu.h
> @@ -0,0 +1,79 @@
> +/*
> + * QEMU abstraction of IOMMU Context
> + *
> + * Copyright (C) 2019 Red Hat Inc.
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
> +#ifndef HW_PCI_PASID_H
> +#define HW_PCI_PASID_H

These guards need to be updated for the new header name.

> +
> +#include "qemu/queue.h"
> +#ifndef CONFIG_USER_ONLY
> +#include "exec/hwaddr.h"
> +#endif
> +
> +typedef struct IOMMUContext IOMMUContext;
> +
> +enum IOMMUCTXEvent {
> +    IOMMU_CTX_EVENT_NUM,
> +};
> +typedef enum IOMMUCTXEvent IOMMUCTXEvent;
> +
> +struct IOMMUCTXEventData {
> +    IOMMUCTXEvent event;
> +    uint64_t length;
> +    void *data;
> +};
> +typedef struct IOMMUCTXEventData IOMMUCTXEventData;
> +
> +typedef struct IOMMUCTXNotifier IOMMUCTXNotifier;
> +
> +typedef void (*IOMMUCTXNotifyFn)(IOMMUCTXNotifier *notifier,
> +                                 IOMMUCTXEventData *event_data);
> +
> +struct IOMMUCTXNotifier {
> +    IOMMUCTXNotifyFn iommu_ctx_event_notify;
> +    /*
> +     * What events we are listening to. Let's allow multiple event
> +     * registrations from beginning.
> +     */
> +    IOMMUCTXEvent event;
> +    QLIST_ENTRY(IOMMUCTXNotifier) node;
> +};
> +
> +/*
> + * This is an abstraction of IOMMU context.
> + */
> +struct IOMMUContext {
> +    uint32_t pasid;

This confuses me a bit.  I thought the idea was that IOMMUContext with
SVM would represent all the PASIDs in use, but here we have a specific
pasid stored in the structure.

> +    QLIST_HEAD(, IOMMUCTXNotifier) iommu_ctx_notifiers;
> +};
> +
> +void iommu_ctx_notifier_register(IOMMUContext *iommu_ctx,
> +                                 IOMMUCTXNotifier *n,
> +                                 IOMMUCTXNotifyFn fn,
> +                                 IOMMUCTXEvent event);
> +void iommu_ctx_notifier_unregister(IOMMUContext *iommu_ctx,
> +                                   IOMMUCTXNotifier *notifier);
> +void iommu_ctx_event_notify(IOMMUContext *iommu_ctx,
> +                            IOMMUCTXEventData *event_data);
> +
> +void iommu_context_init(IOMMUContext *iommu_ctx);
> +
> +#endif

--=20
David Gibson			| I'll have my music baroque, and my code
david AT gibson.dropbear.id.au	| minimalist, thank you.  NOT _the_ _other_
				| _way_ _around_!
http://www.ozlabs.org/~dgibson

--M0YLxmUXciMpOLPE
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEdfRlhq5hpmzETofcbDjKyiDZs5IFAl211k4ACgkQbDjKyiDZ
s5K0Uw//RVP0RainFrEUfLXMu+stD/JRcjmXKoRPGKhAgCYr3NssXyHM6VuNHgaY
fOSksAMV0TEasmgC0ZQtt1mkutEaF+6u70C67sZS28ymLbA9i6HWcfXpEVBV/jOW
UDm7v49562cejhf5qUKSrO1E37AaNrcGcbKua91JZqYqHVMdRmKOscPiOTmA4x5e
0NeHKvk5zj2WVWfrPwYvMe0HmyM/IkElVeG/5xxipc86/SoCf2nzziMY3tDcjIXa
iWaiPI3B+ucSY9DYwfaWLUzurCTA3giUgO4k1bGFiZiatn+IOX+2U+Zv6WWpKj+D
u33s9FfAS0lb3SvhN/vuROrlgOj0b51mm3EiITcu8NWk7+zUOzz4BOw+stp/eak7
/u2/K+06saNVorNbfD6QGEM3NGBS4mMndRIe6N+AxWwX3x6hjVfK+y77oUx8joCM
jPxWs3693rR+p+kkwOIzAGPgYTQ1GdXevPEWJMcjUlShmZ9AeWMKnH5AU+opiGDu
TpyT9FPPD2HS7xW1Uedk9QrF2BxBqAT1o5XzKGRyLo176oiACxFqi90rD4ZTSPxU
h3jLCzIRiK0bmM1Ufa4hOCNZnZO5y8wp8mOXMvo/+zFjvlguzac1y7NiSwY4iFX+
Kv2J3ErOJDrfZG8eASEqoGB1nQHA+CDOM0PuK64/9hQJ9QJ97VY=
=SouO
-----END PGP SIGNATURE-----

--M0YLxmUXciMpOLPE--
