Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EAC4D68386
	for <lists+kvm@lfdr.de>; Mon, 15 Jul 2019 08:25:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726975AbfGOGZJ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 15 Jul 2019 02:25:09 -0400
Received: from bilbo.ozlabs.org ([203.11.71.1]:50575 "EHLO ozlabs.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726579AbfGOGZJ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 15 Jul 2019 02:25:09 -0400
Received: by ozlabs.org (Postfix, from userid 1007)
        id 45nD6B4Bc6z9sP0; Mon, 15 Jul 2019 16:25:06 +1000 (AEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
        d=gibson.dropbear.id.au; s=201602; t=1563171906;
        bh=MMDinOD+wXlv4awyV674igDfgFgonl4wftkkwcmlRFU=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=PL+hSpKR28IrMGvUCzlZKT6tRFajGAuminDj1Jm7BPtEZ/M8Kx61FZXXaiCcnlqWz
         3HV/g9lGIU/EFd0k133XAF0Pp2GzrAUZHdR7lNhlxu/WINieGx1FGK6iW9VVEF+MP1
         cfQgTD1C14v31DIHiDqbDqlxsbPpCvwEfR3vZaWM=
Date:   Mon, 15 Jul 2019 12:55:19 +1000
From:   David Gibson <david@gibson.dropbear.id.au>
To:     Liu Yi L <yi.l.liu@intel.com>
Cc:     qemu-devel@nongnu.org, mst@redhat.com, pbonzini@redhat.com,
        alex.williamson@redhat.com, peterx@redhat.com,
        eric.auger@redhat.com, tianyu.lan@intel.com, kevin.tian@intel.com,
        jun.j.tian@intel.com, yi.y.sun@intel.com, kvm@vger.kernel.org,
        Jacob Pan <jacob.jun.pan@linux.intel.com>,
        Yi Sun <yi.y.sun@linux.intel.com>
Subject: Re: [RFC v1 05/18] vfio/pci: add pasid alloc/free implementation
Message-ID: <20190715025519.GE3440@umbus.fritz.box>
References: <1562324511-2910-1-git-send-email-yi.l.liu@intel.com>
 <1562324511-2910-6-git-send-email-yi.l.liu@intel.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="h56sxpGKRmy85csR"
Content-Disposition: inline
In-Reply-To: <1562324511-2910-6-git-send-email-yi.l.liu@intel.com>
User-Agent: Mutt/1.12.0 (2019-05-25)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


--h56sxpGKRmy85csR
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Jul 05, 2019 at 07:01:38PM +0800, Liu Yi L wrote:
> This patch adds vfio implementation PCIPASIDOps.alloc_pasid/free_pasid().
> These two functions are used to propagate guest pasid allocation and
> free requests to host via vfio container ioctl.

As I said in an earlier comment, I think doing this on the device is
conceptually incorrect.  I think we need an explcit notion of an SVM
context (i.e. the namespace in which all the PASIDs live) - which will
IIUC usually be shared amongst multiple devices.  The create and free
PASID requests should be on that object.

>=20
> Cc: Kevin Tian <kevin.tian@intel.com>
> Cc: Jacob Pan <jacob.jun.pan@linux.intel.com>
> Cc: Peter Xu <peterx@redhat.com>
> Cc: Eric Auger <eric.auger@redhat.com>
> Cc: Yi Sun <yi.y.sun@linux.intel.com>
> Cc: David Gibson <david@gibson.dropbear.id.au>
> Signed-off-by: Liu Yi L <yi.l.liu@intel.com>
> Signed-off-by: Yi Sun <yi.y.sun@linux.intel.com>
> ---
>  hw/vfio/pci.c | 61 +++++++++++++++++++++++++++++++++++++++++++++++++++++=
++++++
>  1 file changed, 61 insertions(+)
>=20
> diff --git a/hw/vfio/pci.c b/hw/vfio/pci.c
> index ce3fe96..ab184ad 100644
> --- a/hw/vfio/pci.c
> +++ b/hw/vfio/pci.c
> @@ -2690,6 +2690,65 @@ static void vfio_unregister_req_notifier(VFIOPCIDe=
vice *vdev)
>      vdev->req_enabled =3D false;
>  }
> =20
> +static int vfio_pci_device_request_pasid_alloc(PCIBus *bus,
> +                                               int32_t devfn,
> +                                               uint32_t min_pasid,
> +                                               uint32_t max_pasid)
> +{
> +    PCIDevice *pdev =3D bus->devices[devfn];
> +    VFIOPCIDevice *vdev =3D DO_UPCAST(VFIOPCIDevice, pdev, pdev);
> +    VFIOContainer *container =3D vdev->vbasedev.group->container;
> +    struct vfio_iommu_type1_pasid_request req;
> +    unsigned long argsz;
> +    int pasid;
> +
> +    argsz =3D sizeof(req);
> +    req.argsz =3D argsz;
> +    req.flag =3D VFIO_IOMMU_PASID_ALLOC;
> +    req.min_pasid =3D min_pasid;
> +    req.max_pasid =3D max_pasid;
> +
> +    rcu_read_lock();
> +    pasid =3D ioctl(container->fd, VFIO_IOMMU_PASID_REQUEST, &req);
> +    if (pasid < 0) {
> +        error_report("vfio_pci_device_request_pasid_alloc:"
> +                     " request failed, contanier: %p", container);
> +    }
> +    rcu_read_unlock();
> +    return pasid;
> +}
> +
> +static int vfio_pci_device_request_pasid_free(PCIBus *bus,
> +                                              int32_t devfn,
> +                                              uint32_t pasid)
> +{
> +    PCIDevice *pdev =3D bus->devices[devfn];
> +    VFIOPCIDevice *vdev =3D DO_UPCAST(VFIOPCIDevice, pdev, pdev);
> +    VFIOContainer *container =3D vdev->vbasedev.group->container;
> +    struct vfio_iommu_type1_pasid_request req;
> +    unsigned long argsz;
> +    int ret =3D 0;
> +
> +    argsz =3D sizeof(req);
> +    req.argsz =3D argsz;
> +    req.flag =3D VFIO_IOMMU_PASID_FREE;
> +    req.pasid =3D pasid;
> +
> +    rcu_read_lock();
> +    ret =3D ioctl(container->fd, VFIO_IOMMU_PASID_REQUEST, &req);
> +    if (ret !=3D 0) {
> +        error_report("vfio_pci_device_request_pasid_free:"
> +                     " request failed, contanier: %p", container);
> +    }
> +    rcu_read_unlock();
> +    return ret;
> +}
> +
> +static PCIPASIDOps vfio_pci_pasid_ops =3D {
> +    .alloc_pasid =3D vfio_pci_device_request_pasid_alloc,
> +    .free_pasid =3D vfio_pci_device_request_pasid_free,
> +};
> +
>  static void vfio_realize(PCIDevice *pdev, Error **errp)
>  {
>      VFIOPCIDevice *vdev =3D PCI_VFIO(pdev);
> @@ -2991,6 +3050,8 @@ static void vfio_realize(PCIDevice *pdev, Error **e=
rrp)
>      vfio_register_req_notifier(vdev);
>      vfio_setup_resetfn_quirk(vdev);
> =20
> +    pci_setup_pasid_ops(pdev, &vfio_pci_pasid_ops);
> +
>      return;
> =20
>  out_teardown:

--=20
David Gibson			| I'll have my music baroque, and my code
david AT gibson.dropbear.id.au	| minimalist, thank you.  NOT _the_ _other_
				| _way_ _around_!
http://www.ozlabs.org/~dgibson

--h56sxpGKRmy85csR
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEdfRlhq5hpmzETofcbDjKyiDZs5IFAl0r6xQACgkQbDjKyiDZ
s5J4Eg//aM7TV3CkLDHJtnRYwSfA06xJ1K3BJ78h1scn8zlw7J0CCcwYYK6FuVvT
SXFXQP9dlyKMaRvieS1SfV+LjQ+lCToDJSllg1Wq0CYSTwnpKjCefPIP8O3sQ+DF
Jda+AC3BAfldLrgyN9I7lUXgrIFrP77uMR2ciobnyb4516ZLy4DQ2GYOeBggDDwW
QRZWgNSuvEBob8MFuIg7sTKTz63+N/hL83Jjy27BERVHaNQqDU0XPnOGBBBOmd16
Dn5DGR6HBBeVgOjyOr+8u/lByufe0j4pmhl8bS0wCmAtS4JfCfqxhNEiOhV5QCBA
UxRtzLxKfAbUnAfQMRc79hAJGM2DiChIlLVycRF9OxsD/dmYe2O8GOR337BIe7fv
oYORbuIomOsU0clA/8nisIQKftkoJcK3AO4CIc1ShQcMKa2j0f9Y2c5WH1BC3TX8
67MDlK7hBgRS/gbydog4ZuyUzMSr9bas2+L9CNXG0j1wN2ckFoK9MYSgsRmMSZDJ
BPBLEiYPnlYgU85wlCHTNWxDv0XQ1bHIq0pl3Rxh0Zubrobj3j/FSA1DVWb0NXLP
/p8qBE2ZOj952LRcYUOLFWMgRZyOf30Zlrs+KwKSdjDrZbso9j60m7wRTspsGY4x
LuIU0Jb0Df/F8T6lsYSdtlZfcGt689JLR2v+hrg2kpXScz9TDWA=
=i1pv
-----END PGP SIGNATURE-----

--h56sxpGKRmy85csR--
