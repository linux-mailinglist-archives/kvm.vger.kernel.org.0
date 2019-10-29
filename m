Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0DF1BE8AAC
	for <lists+kvm@lfdr.de>; Tue, 29 Oct 2019 15:22:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389216AbfJ2OWk (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 29 Oct 2019 10:22:40 -0400
Received: from ozlabs.org ([203.11.71.1]:47275 "EHLO ozlabs.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388989AbfJ2OWk (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 29 Oct 2019 10:22:40 -0400
Received: by ozlabs.org (Postfix, from userid 1007)
        id 472YhD5xDWz9sR4; Wed, 30 Oct 2019 01:22:35 +1100 (AEDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
        d=gibson.dropbear.id.au; s=201602; t=1572358956;
        bh=/OsjRqAbu3lpJDivohmd7XhSBhLtc95gs65ePZiLNzg=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=V6/DkmvnNQXDcPjBd+GwtHw0nTEjmP+Ii3RvDBtpjRpXnbln93Br5/+MNDT5cGGyE
         HABMKH6W91vQe7fUb4gQEx/bB4LH0nJTDGTeJn+DeWxiDOC/owZ+E6rcmtVBpndVnZ
         apZjyY70LUh5kmEHvBmkx010j0CPznDaUrwfJMfY=
Date:   Tue, 29 Oct 2019 13:15:44 +0100
From:   David Gibson <david@gibson.dropbear.id.au>
To:     Liu Yi L <yi.l.liu@intel.com>
Cc:     qemu-devel@nongnu.org, mst@redhat.com, pbonzini@redhat.com,
        alex.williamson@redhat.com, peterx@redhat.com,
        eric.auger@redhat.com, tianyu.lan@intel.com, kevin.tian@intel.com,
        jun.j.tian@intel.com, yi.y.sun@intel.com,
        jacob.jun.pan@linux.intel.com, kvm@vger.kernel.org,
        Yi Sun <yi.y.sun@linux.intel.com>
Subject: Re: [RFC v2 09/22] vfio/pci: add iommu_context notifier for pasid
 alloc/free
Message-ID: <20191029121544.GS3552@umbus.metropole.lan>
References: <1571920483-3382-1-git-send-email-yi.l.liu@intel.com>
 <1571920483-3382-10-git-send-email-yi.l.liu@intel.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="oJFDFiWc3BlD0xT/"
Content-Disposition: inline
In-Reply-To: <1571920483-3382-10-git-send-email-yi.l.liu@intel.com>
User-Agent: Mutt/1.12.1 (2019-06-15)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


--oJFDFiWc3BlD0xT/
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Oct 24, 2019 at 08:34:30AM -0400, Liu Yi L wrote:
> This patch adds pasid alloc/free notifiers for vfio-pci. It is
> supposed to be fired by vIOMMU. VFIO then sends PASID allocation
> or free request to host.
>=20
> Cc: Kevin Tian <kevin.tian@intel.com>
> Cc: Jacob Pan <jacob.jun.pan@linux.intel.com>
> Cc: Peter Xu <peterx@redhat.com>
> Cc: Eric Auger <eric.auger@redhat.com>
> Cc: Yi Sun <yi.y.sun@linux.intel.com>
> Cc: David Gibson <david@gibson.dropbear.id.au>
> Signed-off-by: Liu Yi L <yi.l.liu@intel.com>
> ---
>  hw/vfio/common.c         |  9 ++++++
>  hw/vfio/pci.c            | 81 ++++++++++++++++++++++++++++++++++++++++++=
++++++
>  include/hw/iommu/iommu.h | 15 +++++++++
>  3 files changed, 105 insertions(+)
>=20
> diff --git a/hw/vfio/common.c b/hw/vfio/common.c
> index d418527..e6ad21c 100644
> --- a/hw/vfio/common.c
> +++ b/hw/vfio/common.c
> @@ -1436,6 +1436,7 @@ static void vfio_disconnect_container(VFIOGroup *gr=
oup)
>      if (QLIST_EMPTY(&container->group_list)) {
>          VFIOAddressSpace *space =3D container->space;
>          VFIOGuestIOMMU *giommu, *tmp;
> +        VFIOIOMMUContext *giommu_ctx, *ctx;
> =20
>          QLIST_REMOVE(container, next);
> =20
> @@ -1446,6 +1447,14 @@ static void vfio_disconnect_container(VFIOGroup *g=
roup)
>              g_free(giommu);
>          }
> =20
> +        QLIST_FOREACH_SAFE(giommu_ctx, &container->iommu_ctx_list,
> +                                                   iommu_ctx_next, ctx) {
> +            iommu_ctx_notifier_unregister(giommu_ctx->iommu_ctx,
> +                                                      &giommu_ctx->n);
> +            QLIST_REMOVE(giommu_ctx, iommu_ctx_next);
> +            g_free(giommu_ctx);
> +        }
> +
>          trace_vfio_disconnect_container(container->fd);
>          close(container->fd);
>          g_free(container);
> diff --git a/hw/vfio/pci.c b/hw/vfio/pci.c
> index 12fac39..8721ff6 100644
> --- a/hw/vfio/pci.c
> +++ b/hw/vfio/pci.c
> @@ -2699,11 +2699,80 @@ static void vfio_unregister_req_notifier(VFIOPCID=
evice *vdev)
>      vdev->req_enabled =3D false;
>  }
> =20
> +static void vfio_register_iommu_ctx_notifier(VFIOPCIDevice *vdev,
> +                                             IOMMUContext *iommu_ctx,
> +                                             IOMMUCTXNotifyFn fn,
> +                                             IOMMUCTXEvent event)
> +{
> +    VFIOContainer *container =3D vdev->vbasedev.group->container;
> +    VFIOIOMMUContext *giommu_ctx;
> +
> +    giommu_ctx =3D g_malloc0(sizeof(*giommu_ctx));
> +    giommu_ctx->container =3D container;
> +    giommu_ctx->iommu_ctx =3D iommu_ctx;
> +    QLIST_INSERT_HEAD(&container->iommu_ctx_list,
> +                      giommu_ctx,
> +                      iommu_ctx_next);
> +    iommu_ctx_notifier_register(iommu_ctx,
> +                                &giommu_ctx->n,
> +                                fn,
> +                                event);
> +}
> +
> +static void vfio_iommu_pasid_alloc_notify(IOMMUCTXNotifier *n,
> +                                          IOMMUCTXEventData *event_data)
> +{
> +    VFIOIOMMUContext *giommu_ctx =3D container_of(n, VFIOIOMMUContext, n=
);
> +    VFIOContainer *container =3D giommu_ctx->container;
> +    IOMMUCTXPASIDReqDesc *pasid_req =3D
> +                              (IOMMUCTXPASIDReqDesc *) event_data->data;
> +    struct vfio_iommu_type1_pasid_request req;
> +    unsigned long argsz;
> +    int pasid;
> +
> +    argsz =3D sizeof(req);
> +    req.argsz =3D argsz;
> +    req.flag =3D VFIO_IOMMU_PASID_ALLOC;
> +    req.min_pasid =3D pasid_req->min_pasid;
> +    req.max_pasid =3D pasid_req->max_pasid;
> +
> +    pasid =3D ioctl(container->fd, VFIO_IOMMU_PASID_REQUEST, &req);
> +    if (pasid < 0) {
> +        error_report("%s: %d, alloc failed", __func__, -errno);
> +    }
> +    pasid_req->alloc_result =3D pasid;

Altering the event data from the notifier doesn't make sense.  By
definition there can be multiple notifiers on the chain, so in that
case which one is responsible for updating the writable field?

> +}
> +
> +static void vfio_iommu_pasid_free_notify(IOMMUCTXNotifier *n,
> +                                          IOMMUCTXEventData *event_data)
> +{
> +    VFIOIOMMUContext *giommu_ctx =3D container_of(n, VFIOIOMMUContext, n=
);
> +    VFIOContainer *container =3D giommu_ctx->container;
> +    IOMMUCTXPASIDReqDesc *pasid_req =3D
> +                              (IOMMUCTXPASIDReqDesc *) event_data->data;
> +    struct vfio_iommu_type1_pasid_request req;
> +    unsigned long argsz;
> +    int ret =3D 0;
> +
> +    argsz =3D sizeof(req);
> +    req.argsz =3D argsz;
> +    req.flag =3D VFIO_IOMMU_PASID_FREE;
> +    req.pasid =3D pasid_req->pasid;
> +
> +    ret =3D ioctl(container->fd, VFIO_IOMMU_PASID_REQUEST, &req);
> +    if (ret !=3D 0) {
> +        error_report("%s: %d, pasid %u free failed",
> +                   __func__, -errno, (unsigned) pasid_req->pasid);
> +    }
> +    pasid_req->free_result =3D ret;

Same problem here.

> +}
> +
>  static void vfio_realize(PCIDevice *pdev, Error **errp)
>  {
>      VFIOPCIDevice *vdev =3D PCI_VFIO(pdev);
>      VFIODevice *vbasedev_iter;
>      VFIOGroup *group;
> +    IOMMUContext *iommu_context;
>      char *tmp, *subsys, group_path[PATH_MAX], *group_name;
>      Error *err =3D NULL;
>      ssize_t len;
> @@ -3000,6 +3069,18 @@ static void vfio_realize(PCIDevice *pdev, Error **=
errp)
>      vfio_register_req_notifier(vdev);
>      vfio_setup_resetfn_quirk(vdev);
> =20
> +    iommu_context =3D pci_device_iommu_context(pdev);
> +    if (iommu_context) {
> +        vfio_register_iommu_ctx_notifier(vdev,
> +                                         iommu_context,
> +                                         vfio_iommu_pasid_alloc_notify,
> +                                         IOMMU_CTX_EVENT_PASID_ALLOC);
> +        vfio_register_iommu_ctx_notifier(vdev,
> +                                         iommu_context,
> +                                         vfio_iommu_pasid_free_notify,
> +                                         IOMMU_CTX_EVENT_PASID_FREE);
> +    }
> +
>      return;
> =20
>  out_teardown:
> diff --git a/include/hw/iommu/iommu.h b/include/hw/iommu/iommu.h
> index c22c442..4352afd 100644
> --- a/include/hw/iommu/iommu.h
> +++ b/include/hw/iommu/iommu.h
> @@ -31,10 +31,25 @@
>  typedef struct IOMMUContext IOMMUContext;
> =20
>  enum IOMMUCTXEvent {
> +    IOMMU_CTX_EVENT_PASID_ALLOC,
> +    IOMMU_CTX_EVENT_PASID_FREE,
>      IOMMU_CTX_EVENT_NUM,
>  };
>  typedef enum IOMMUCTXEvent IOMMUCTXEvent;
> =20
> +union IOMMUCTXPASIDReqDesc {
> +    struct {
> +        uint32_t min_pasid;
> +        uint32_t max_pasid;
> +        int32_t alloc_result; /* pasid allocated for the alloc request */
> +    };
> +    struct {
> +        uint32_t pasid; /* pasid to be free */
> +        int free_result;
> +    };
> +};

Apart from theproblem with writable fields, using a big union for
event data is pretty ugly.  If you need this different information for
the different events, it might make more sense to have a separate
notifier chain with a separate call interface for each event type,
rather than trying to multiplex them together.

> +typedef union IOMMUCTXPASIDReqDesc IOMMUCTXPASIDReqDesc;
> +
>  struct IOMMUCTXEventData {
>      IOMMUCTXEvent event;
>      uint64_t length;

--=20
David Gibson			| I'll have my music baroque, and my code
david AT gibson.dropbear.id.au	| minimalist, thank you.  NOT _the_ _other_
				| _way_ _around_!
http://www.ozlabs.org/~dgibson

--oJFDFiWc3BlD0xT/
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEdfRlhq5hpmzETofcbDjKyiDZs5IFAl24LW0ACgkQbDjKyiDZ
s5KArg//VdtrUL7LmSAtXr99bFhDGE9HfD3kDksbBRHS+VU1LojEx4QPyQO+ClxS
6jXrsk6kq2pM+W+pCRm6fK3fd6Z+hoABjh35Auj3oqwZ+XGunGKv1Wd29v+dMBAC
UYFWL99tF5K8mjPtQQuMS98JyeaJCTdRdkE7gjlwHCynYbXlpKHwLxE9lxB5Mq7D
6JCuzfIsXggYUxGUe36a6SCJ1wjS5Bck1jxJM6W9u5LqOf5wq8UgyZC36edraATO
CxcYwbJYcaSJlybiFUOs8ZhP2MxRJwFdkjl+51n8bxlCCNYoyhjlbTiIweEBQmfv
AHM5kiSc8hvBTuBUWzeLdkqS1X3dJ8CrWtKHVkaA4abZmLgSYqerUUmxvF1W5Jb+
TBlu9NIZnAMtfKFEjzykYARPbROMspaJi/6MElcNF/XdBr2mZVP4L+kD2voewEG/
Yg3EIItfdear1JNPsIKLTkHadZ2ELjHEd/nS96ePVUxEF9D/Apk69W0lh7P8td5I
IImUFxKzX9TV5JeAW0Ys6eQI3GOQV8Ajz4oaSymS3V8Y3YHdBSMR4kCLGpD1p9Us
5+Lj1MxdaOmgme+kYCnlkJ+yMAP5ByWh/je5o3Og50loG9qf1HY7/VnhawRoQj4i
wjF4eGEH12W56qReBEs5kZSnCESJCMg/4HS2P7SV0L3vG7rtZhk=
=imxI
-----END PGP SIGNATURE-----

--oJFDFiWc3BlD0xT/--
