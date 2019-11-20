Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4ED15103284
	for <lists+kvm@lfdr.de>; Wed, 20 Nov 2019 05:28:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727629AbfKTE2G (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 19 Nov 2019 23:28:06 -0500
Received: from ozlabs.org ([203.11.71.1]:51247 "EHLO ozlabs.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727264AbfKTE2G (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 19 Nov 2019 23:28:06 -0500
Received: by ozlabs.org (Postfix, from userid 1007)
        id 47HqS21Nf8z9sPc; Wed, 20 Nov 2019 15:28:02 +1100 (AEDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
        d=gibson.dropbear.id.au; s=201602; t=1574224082;
        bh=LaH01KzXUG8osJf+FKzF3QRxkjm9zL46s4Srl7HjQoc=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=BYGmKxs4qkqt04SO11Mw73RB3d6ihXaPKcpXsZPh/faswGUo+hmDImBaC88Xj+YYa
         f444AvqgTlEAzl5xy19ZvJcf1FmSyqhaZt1P38yLL5htzuzKYfodPHRBN+0f4bzdkf
         8Dgo0Vk7dN/01FZy3uJ0KFIOqJbICyDSwSSF7Mxo=
Date:   Wed, 20 Nov 2019 15:27:52 +1100
From:   David Gibson <david@gibson.dropbear.id.au>
To:     "Liu, Yi L" <yi.l.liu@intel.com>
Cc:     "qemu-devel@nongnu.org" <qemu-devel@nongnu.org>,
        "mst@redhat.com" <mst@redhat.com>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "alex.williamson@redhat.com" <alex.williamson@redhat.com>,
        "peterx@redhat.com" <peterx@redhat.com>,
        "eric.auger@redhat.com" <eric.auger@redhat.com>,
        "Tian, Kevin" <kevin.tian@intel.com>,
        "Tian, Jun J" <jun.j.tian@intel.com>,
        "Sun, Yi Y" <yi.y.sun@intel.com>,
        "jacob.jun.pan@linux.intel.com" <jacob.jun.pan@linux.intel.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        Yi Sun <yi.y.sun@linux.intel.com>
Subject: Re: [RFC v2 09/22] vfio/pci: add iommu_context notifier for pasid
 alloc/free
Message-ID: <20191120042752.GF5582@umbus.fritz.box>
References: <1571920483-3382-1-git-send-email-yi.l.liu@intel.com>
 <1571920483-3382-10-git-send-email-yi.l.liu@intel.com>
 <20191029121544.GS3552@umbus.metropole.lan>
 <A2975661238FB949B60364EF0F2C25743A0EF2CE@SHSMSX104.ccr.corp.intel.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="hNrJFWHEm0TKGkuH"
Content-Disposition: inline
In-Reply-To: <A2975661238FB949B60364EF0F2C25743A0EF2CE@SHSMSX104.ccr.corp.intel.com>
User-Agent: Mutt/1.12.1 (2019-06-15)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


--hNrJFWHEm0TKGkuH
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Nov 06, 2019 at 12:14:50PM +0000, Liu, Yi L wrote:
> > From: David Gibson [mailto:david@gibson.dropbear.id.au]
> > Sent: Tuesday, October 29, 2019 8:16 PM
> > To: Liu, Yi L <yi.l.liu@intel.com>
> > Subject: Re: [RFC v2 09/22] vfio/pci: add iommu_context notifier for pa=
sid alloc/free
> >=20
> > On Thu, Oct 24, 2019 at 08:34:30AM -0400, Liu Yi L wrote:
> > > This patch adds pasid alloc/free notifiers for vfio-pci. It is
> > > supposed to be fired by vIOMMU. VFIO then sends PASID allocation
> > > or free request to host.
> > >
> > > Cc: Kevin Tian <kevin.tian@intel.com>
> > > Cc: Jacob Pan <jacob.jun.pan@linux.intel.com>
> > > Cc: Peter Xu <peterx@redhat.com>
> > > Cc: Eric Auger <eric.auger@redhat.com>
> > > Cc: Yi Sun <yi.y.sun@linux.intel.com>
> > > Cc: David Gibson <david@gibson.dropbear.id.au>
> > > Signed-off-by: Liu Yi L <yi.l.liu@intel.com>
> > > ---
> > >  hw/vfio/common.c         |  9 ++++++
> > >  hw/vfio/pci.c            | 81
> > ++++++++++++++++++++++++++++++++++++++++++++++++
> > >  include/hw/iommu/iommu.h | 15 +++++++++
> > >  3 files changed, 105 insertions(+)
> > >
> > > diff --git a/hw/vfio/common.c b/hw/vfio/common.c
> > > index d418527..e6ad21c 100644
> > > --- a/hw/vfio/common.c
> > > +++ b/hw/vfio/common.c
> > > @@ -1436,6 +1436,7 @@ static void vfio_disconnect_container(VFIOGroup
> > *group)
> > >      if (QLIST_EMPTY(&container->group_list)) {
> > >          VFIOAddressSpace *space =3D container->space;
> > >          VFIOGuestIOMMU *giommu, *tmp;
> > > +        VFIOIOMMUContext *giommu_ctx, *ctx;
> > >
> > >          QLIST_REMOVE(container, next);
> > >
> > > @@ -1446,6 +1447,14 @@ static void vfio_disconnect_container(VFIOGroup
> > *group)
> > >              g_free(giommu);
> > >          }
> > >
> > > +        QLIST_FOREACH_SAFE(giommu_ctx, &container->iommu_ctx_list,
> > > +                                                   iommu_ctx_next, c=
tx) {
> > > +            iommu_ctx_notifier_unregister(giommu_ctx->iommu_ctx,
> > > +                                                      &giommu_ctx->n=
);
> > > +            QLIST_REMOVE(giommu_ctx, iommu_ctx_next);
> > > +            g_free(giommu_ctx);
> > > +        }
> > > +
> > >          trace_vfio_disconnect_container(container->fd);
> > >          close(container->fd);
> > >          g_free(container);
> > > diff --git a/hw/vfio/pci.c b/hw/vfio/pci.c
> > > index 12fac39..8721ff6 100644
> > > --- a/hw/vfio/pci.c
> > > +++ b/hw/vfio/pci.c
> > > @@ -2699,11 +2699,80 @@ static void
> > vfio_unregister_req_notifier(VFIOPCIDevice *vdev)
> > >      vdev->req_enabled =3D false;
> > >  }
> > >
> > > +static void vfio_register_iommu_ctx_notifier(VFIOPCIDevice *vdev,
> > > +                                             IOMMUContext *iommu_ctx,
> > > +                                             IOMMUCTXNotifyFn fn,
> > > +                                             IOMMUCTXEvent event)
> > > +{
> > > +    VFIOContainer *container =3D vdev->vbasedev.group->container;
> > > +    VFIOIOMMUContext *giommu_ctx;
> > > +
> > > +    giommu_ctx =3D g_malloc0(sizeof(*giommu_ctx));
> > > +    giommu_ctx->container =3D container;
> > > +    giommu_ctx->iommu_ctx =3D iommu_ctx;
> > > +    QLIST_INSERT_HEAD(&container->iommu_ctx_list,
> > > +                      giommu_ctx,
> > > +                      iommu_ctx_next);
> > > +    iommu_ctx_notifier_register(iommu_ctx,
> > > +                                &giommu_ctx->n,
> > > +                                fn,
> > > +                                event);
> > > +}
> > > +
> > > +static void vfio_iommu_pasid_alloc_notify(IOMMUCTXNotifier *n,
> > > +                                          IOMMUCTXEventData *event_d=
ata)
> > > +{
> > > +    VFIOIOMMUContext *giommu_ctx =3D container_of(n, VFIOIOMMUContex=
t, n);
> > > +    VFIOContainer *container =3D giommu_ctx->container;
> > > +    IOMMUCTXPASIDReqDesc *pasid_req =3D
> > > +                              (IOMMUCTXPASIDReqDesc *) event_data->d=
ata;
> > > +    struct vfio_iommu_type1_pasid_request req;
> > > +    unsigned long argsz;
> > > +    int pasid;
> > > +
> > > +    argsz =3D sizeof(req);
> > > +    req.argsz =3D argsz;
> > > +    req.flag =3D VFIO_IOMMU_PASID_ALLOC;
> > > +    req.min_pasid =3D pasid_req->min_pasid;
> > > +    req.max_pasid =3D pasid_req->max_pasid;
> > > +
> > > +    pasid =3D ioctl(container->fd, VFIO_IOMMU_PASID_REQUEST, &req);
> > > +    if (pasid < 0) {
> > > +        error_report("%s: %d, alloc failed", __func__, -errno);
> > > +    }
> > > +    pasid_req->alloc_result =3D pasid;
> >=20
> > Altering the event data from the notifier doesn't make sense.  By
> > definition there can be multiple notifiers on the chain, so in that
> > case which one is responsible for updating the writable field?
>=20
> I guess you mean multiple pasid_alloc nofitiers. right?
>=20
> It works for VT-d now, as Intel vIOMMU maintains the IOMMUContext
> per-bdf. And there will be only 1 pasid_alloc notifier in the chain. But,=
 I
> agree it is not good if other module just share an IOMMUConext across
> devices. Definitely, it would have multiple pasid_alloc notifiers.

Right.

> How about enforcing IOMMUContext layer to only invoke one successful
> pasid_alloc/free notifier if PASID_ALLOC/FREE event comes? pasid
> alloc/free are really special as it requires feedback. And a potential
> benefit is that the pasid_alloc/free will not be affected by hot plug
> scenario. There will be always a notifier to work for pasid_alloc/free
> work unless all passthru devices are hot plugged. How do you think? Or
> if any other idea?

Hrm, that still doesn't seem right to me.  I don't think a notifier is
really the right mechanism for something that needs to return values.
This seems like something where you need to find a _single_
responsible object and call a method / callback on that specifically.

But it seems to me there's a more fundamental problem here.  AIUI the
idea is that a single IOMMUContext could hold multiple devices.  But
if the devices are responsible for assigning their own pasid values
(by passing that decisionon to the host through vfio) then that really
can't work.

I'm assuming it's impossible from the hardware side to virtualize the
pasids (so that we could assign them from qemu without host
intervention).

If so, then the pasid allocation really has to be a Context level, not
device level operation.  We'd have to wire the VFIO backend up to the
context itself, not a device... I'm not immediately sure how to do
that, though.

--=20
David Gibson			| I'll have my music baroque, and my code
david AT gibson.dropbear.id.au	| minimalist, thank you.  NOT _the_ _other_
				| _way_ _around_!
http://www.ozlabs.org/~dgibson

--hNrJFWHEm0TKGkuH
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEdfRlhq5hpmzETofcbDjKyiDZs5IFAl3UwMEACgkQbDjKyiDZ
s5KZsA//XoelIlgONN7f19PheYAfU+DR8erhYyZtmWqzjeD9DmyWMXY+R2IRUWFd
Pm8XaGqVAgL030DECHdv8LubB/qXT9+6Vj1mgMYE5jsAds/+UpVmtTZyKyKBKJkx
pU6TwW9nzdOrHoz1tWF5RNbrLV850F+qVIHEuuEeB8DHunxf4iNos9hSGQ3eisZ1
cNxWzmB64CknY0TuVBTvUm9oe0/UXIFCdx+Tvy/hHfKFXV+M6b6YisYfR4yIKmyo
UUV9jJePXgSv1j4/94KnUxGgvu7XVr+bFccb2jsA4qaHDV3QK+QB6SymdrUJIF7Y
9u/R8Ju6tE4joENQZh4/XhiZs2rR9DtboBdBFryeASy7UN3Exw1lHQiaC0bGgGCY
q4nmM3Oj2kpjEXO1SHVG/pQv4G5U3uq8XPfMHSdTObLwwnehQlLWgk3ZQlpG0H44
NI3xhQnCsHoiUmXbI7IKxEqdJ4wjT/KN0axZIz+Gz8tZXTF6y1vtNg47ow75+ZNF
6KzwGB4EVkqKTp5kTNFPg27bXSXPbv9Pyc8+J0sQnhUL/0PfsHxaUvf1dPD3c8Iu
4sBh4siqZ1wlBtOdjyynehUUTIBw3/snScdKZ2YTR8YrSfLJWcJaoX0Tm32yuy75
XPfPvQyoRs8U+gYRbkqqns+YTprs6Uk89e/us17fbdV+AR7Oew8=
=5vxW
-----END PGP SIGNATURE-----

--hNrJFWHEm0TKGkuH--
