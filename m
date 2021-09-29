Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0D4C441BF21
	for <lists+kvm@lfdr.de>; Wed, 29 Sep 2021 08:27:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244368AbhI2G3c (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 29 Sep 2021 02:29:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45750 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244225AbhI2G3a (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 29 Sep 2021 02:29:30 -0400
Received: from gandalf.ozlabs.org (gandalf.ozlabs.org [IPv6:2404:9400:2:0:216:3eff:fee2:21ea])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 044F5C06161C;
        Tue, 28 Sep 2021 23:27:50 -0700 (PDT)
Received: by gandalf.ozlabs.org (Postfix, from userid 1007)
        id 4HK5yr2tQPz4xbP; Wed, 29 Sep 2021 16:27:48 +1000 (AEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gibson.dropbear.id.au; s=201602; t=1632896868;
        bh=jq2RpusWHbQmu4C255IjEuoWL2nlq46w37a5n3Getco=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=OlWwvFagh1rqSCOVTOisB2+Tc54K3wngEj09GsGl+QABR6dFisGGAAbOPmjikajsv
         Jhcxd94fi7gfKScaavy0aVLY0ylDiGDa8fXjfeeQ3KR7oRYWzwM+1uCdefDE65x5dO
         Su8cIQcsG+598a5C8JIB6AN+W6jxAaRxg30fTkA4=
Date:   Wed, 29 Sep 2021 16:00:54 +1000
From:   David Gibson <david@gibson.dropbear.id.au>
To:     Liu Yi L <yi.l.liu@intel.com>
Cc:     alex.williamson@redhat.com, jgg@nvidia.com, hch@lst.de,
        jasowang@redhat.com, joro@8bytes.org, jean-philippe@linaro.org,
        kevin.tian@intel.com, parav@mellanox.com, lkml@metux.net,
        pbonzini@redhat.com, lushenming@huawei.com, eric.auger@redhat.com,
        corbet@lwn.net, ashok.raj@intel.com, yi.l.liu@linux.intel.com,
        jun.j.tian@intel.com, hao.wu@intel.com, dave.jiang@intel.com,
        jacob.jun.pan@linux.intel.com, kwankhede@nvidia.com,
        robin.murphy@arm.com, kvm@vger.kernel.org,
        iommu@lists.linux-foundation.org, dwmw2@infradead.org,
        linux-kernel@vger.kernel.org, baolu.lu@linux.intel.com,
        nicolinc@nvidia.com
Subject: Re: [RFC 08/20] vfio/pci: Add VFIO_DEVICE_BIND_IOMMUFD
Message-ID: <YVQBFgOa4fQRpwqN@yekko>
References: <20210919063848.1476776-1-yi.l.liu@intel.com>
 <20210919063848.1476776-9-yi.l.liu@intel.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="/nD5aDiJP7H15fC3"
Content-Disposition: inline
In-Reply-To: <20210919063848.1476776-9-yi.l.liu@intel.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


--/nD5aDiJP7H15fC3
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Sun, Sep 19, 2021 at 02:38:36PM +0800, Liu Yi L wrote:
> This patch adds VFIO_DEVICE_BIND_IOMMUFD for userspace to bind the vfio
> device to an iommufd. No VFIO_DEVICE_UNBIND_IOMMUFD interface is provided
> because it's implicitly done when the device fd is closed.
>=20
> In concept a vfio device can be bound to multiple iommufds, each hosting
> a subset of I/O address spaces attached by this device.

I really feel like this many<->many mapping between devices is going
to be super-confusing, and therefore make it really hard to be
confident we have all the rules right for proper isolation.

That's why I was suggesting a concept like endpoints, to break this
into two many<->one relationships.  I'm ok if that isn't visible in
the user API, but I think this is going to be really hard to keep
track of if it isn't explicit somewhere in the internals.

> However as a
> starting point (matching current vfio), only one I/O address space is
> supported per vfio device. It implies one device can only be attached
> to one iommufd at this point.
>=20
> Signed-off-by: Liu Yi L <yi.l.liu@intel.com>
> ---
>  drivers/vfio/pci/Kconfig            |  1 +
>  drivers/vfio/pci/vfio_pci.c         | 72 ++++++++++++++++++++++++++++-
>  drivers/vfio/pci/vfio_pci_private.h |  8 ++++
>  include/uapi/linux/vfio.h           | 30 ++++++++++++
>  4 files changed, 110 insertions(+), 1 deletion(-)
>=20
> diff --git a/drivers/vfio/pci/Kconfig b/drivers/vfio/pci/Kconfig
> index 5e2e1b9a9fd3..3abfb098b4dc 100644
> --- a/drivers/vfio/pci/Kconfig
> +++ b/drivers/vfio/pci/Kconfig
> @@ -5,6 +5,7 @@ config VFIO_PCI
>  	depends on MMU
>  	select VFIO_VIRQFD
>  	select IRQ_BYPASS_MANAGER
> +	select IOMMUFD
>  	help
>  	  Support for the PCI VFIO bus driver.  This is required to make
>  	  use of PCI drivers using the VFIO framework.
> diff --git a/drivers/vfio/pci/vfio_pci.c b/drivers/vfio/pci/vfio_pci.c
> index 145addde983b..20006bb66430 100644
> --- a/drivers/vfio/pci/vfio_pci.c
> +++ b/drivers/vfio/pci/vfio_pci.c
> @@ -552,6 +552,16 @@ static void vfio_pci_release(struct vfio_device *cor=
e_vdev)
>  			vdev->req_trigger =3D NULL;
>  		}
>  		mutex_unlock(&vdev->igate);
> +
> +		mutex_lock(&vdev->videv_lock);
> +		if (vdev->videv) {
> +			struct vfio_iommufd_device *videv =3D vdev->videv;
> +
> +			vdev->videv =3D NULL;
> +			iommufd_unbind_device(videv->idev);
> +			kfree(videv);
> +		}
> +		mutex_unlock(&vdev->videv_lock);
>  	}
> =20
>  	mutex_unlock(&vdev->reflck->lock);
> @@ -780,7 +790,66 @@ static long vfio_pci_ioctl(struct vfio_device *core_=
vdev,
>  		container_of(core_vdev, struct vfio_pci_device, vdev);
>  	unsigned long minsz;
> =20
> -	if (cmd =3D=3D VFIO_DEVICE_GET_INFO) {
> +	if (cmd =3D=3D VFIO_DEVICE_BIND_IOMMUFD) {
> +		struct vfio_device_iommu_bind_data bind_data;
> +		unsigned long minsz;
> +		struct iommufd_device *idev;
> +		struct vfio_iommufd_device *videv;
> +
> +		/*
> +		 * Reject the request if the device is already opened and
> +		 * attached to a container.
> +		 */
> +		if (vfio_device_in_container(core_vdev))

Usually one would do argument sanity checks before checks that
actually depend on machine state.

> +			return -ENOTTY;

This doesn't seem like the right error code.  It's a perfectly valid
operation for this device - just not available right now.

> +
> +		minsz =3D offsetofend(struct vfio_device_iommu_bind_data, dev_cookie);
> +
> +		if (copy_from_user(&bind_data, (void __user *)arg, minsz))
> +			return -EFAULT;
> +
> +		if (bind_data.argsz < minsz ||
> +		    bind_data.flags || bind_data.iommu_fd < 0)
> +			return -EINVAL;
> +
> +		mutex_lock(&vdev->videv_lock);
> +		/*
> +		 * Allow only one iommufd per device until multiple
> +		 * address spaces (e.g. vSVA) support is introduced
> +		 * in the future.
> +		 */
> +		if (vdev->videv) {
> +			mutex_unlock(&vdev->videv_lock);
> +			return -EBUSY;
> +		}
> +
> +		idev =3D iommufd_bind_device(bind_data.iommu_fd,
> +					   &vdev->pdev->dev,
> +					   bind_data.dev_cookie);
> +		if (IS_ERR(idev)) {
> +			mutex_unlock(&vdev->videv_lock);
> +			return PTR_ERR(idev);
> +		}
> +
> +		videv =3D kzalloc(sizeof(*videv), GFP_KERNEL);
> +		if (!videv) {
> +			iommufd_unbind_device(idev);
> +			mutex_unlock(&vdev->videv_lock);
> +			return -ENOMEM;
> +		}
> +		videv->idev =3D idev;
> +		videv->iommu_fd =3D bind_data.iommu_fd;
> +		/*
> +		 * A security context has been established. Unblock
> +		 * user access.
> +		 */
> +		if (atomic_read(&vdev->block_access))
> +			atomic_set(&vdev->block_access, 0);
> +		vdev->videv =3D videv;
> +		mutex_unlock(&vdev->videv_lock);
> +
> +		return 0;
> +	} else if (cmd =3D=3D VFIO_DEVICE_GET_INFO) {
>  		struct vfio_device_info info;
>  		struct vfio_info_cap caps =3D { .buf =3D NULL, .size =3D 0 };
>  		unsigned long capsz;
> @@ -2031,6 +2100,7 @@ static int vfio_pci_probe(struct pci_dev *pdev, con=
st struct pci_device_id *id)
>  	mutex_init(&vdev->vma_lock);
>  	INIT_LIST_HEAD(&vdev->vma_list);
>  	init_rwsem(&vdev->memory_lock);
> +	mutex_init(&vdev->videv_lock);
> =20
>  	ret =3D vfio_pci_reflck_attach(vdev);
>  	if (ret)
> diff --git a/drivers/vfio/pci/vfio_pci_private.h b/drivers/vfio/pci/vfio_=
pci_private.h
> index f12012e30b53..bd784accac35 100644
> --- a/drivers/vfio/pci/vfio_pci_private.h
> +++ b/drivers/vfio/pci/vfio_pci_private.h
> @@ -14,6 +14,7 @@
>  #include <linux/types.h>
>  #include <linux/uuid.h>
>  #include <linux/notifier.h>
> +#include <linux/iommufd.h>
> =20
>  #ifndef VFIO_PCI_PRIVATE_H
>  #define VFIO_PCI_PRIVATE_H
> @@ -99,6 +100,11 @@ struct vfio_pci_mmap_vma {
>  	struct list_head	vma_next;
>  };
> =20
> +struct vfio_iommufd_device {
> +	struct iommufd_device *idev;

Could this be embedded to avoid multiple layers of pointers?

> +	int iommu_fd;
> +};
> +
>  struct vfio_pci_device {
>  	struct vfio_device	vdev;
>  	struct pci_dev		*pdev;
> @@ -144,6 +150,8 @@ struct vfio_pci_device {
>  	struct list_head	vma_list;
>  	struct rw_semaphore	memory_lock;
>  	atomic_t		block_access;
> +	struct mutex		videv_lock;
> +	struct vfio_iommufd_device *videv;
>  };
> =20
>  #define is_intx(vdev) (vdev->irq_type =3D=3D VFIO_PCI_INTX_IRQ_INDEX)
> diff --git a/include/uapi/linux/vfio.h b/include/uapi/linux/vfio.h
> index ef33ea002b0b..c902abd60339 100644
> --- a/include/uapi/linux/vfio.h
> +++ b/include/uapi/linux/vfio.h
> @@ -190,6 +190,36 @@ struct vfio_group_status {
> =20
>  /* --------------- IOCTLs for DEVICE file descriptors --------------- */
> =20
> +/*
> + * VFIO_DEVICE_BIND_IOMMUFD - _IOR(VFIO_TYPE, VFIO_BASE + 19,
> + *				struct vfio_device_iommu_bind_data)
> + *
> + * Bind a vfio_device to the specified iommufd
> + *
> + * The user should provide a device cookie when calling this ioctl. The
> + * cookie is later used in iommufd for capability query, iotlb invalidat=
ion
> + * and I/O fault handling.
> + *
> + * User is not allowed to access the device before the binding operation
> + * is completed.
> + *
> + * Unbind is automatically conducted when device fd is closed.
> + *
> + * Input parameters:
> + *	- iommu_fd;
> + *	- dev_cookie;
> + *
> + * Return: 0 on success, -errno on failure.
> + */
> +struct vfio_device_iommu_bind_data {
> +	__u32	argsz;
> +	__u32	flags;
> +	__s32	iommu_fd;
> +	__u64	dev_cookie;
> +};
> +
> +#define VFIO_DEVICE_BIND_IOMMUFD	_IO(VFIO_TYPE, VFIO_BASE + 19)
> +
>  /**
>   * VFIO_DEVICE_GET_INFO - _IOR(VFIO_TYPE, VFIO_BASE + 7,
>   *						struct vfio_device_info)

--=20
David Gibson			| I'll have my music baroque, and my code
david AT gibson.dropbear.id.au	| minimalist, thank you.  NOT _the_ _other_
				| _way_ _around_!
http://www.ozlabs.org/~dgibson

--/nD5aDiJP7H15fC3
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEdfRlhq5hpmzETofcbDjKyiDZs5IFAmFUARMACgkQbDjKyiDZ
s5L4Jw/+NgsMPNvxtj3apjSyt0/aHAJwv8hcuQKR/Ge7fTVxTktX9jnWe75QBOp/
IT1sp5+3SghyQr/BNedlP5/FBslC4xNhxW3PZcHh5tggPT6lMz18PD+Goqoww7DP
c1yAIkOZ12Y1uirUNM6Gk+uj5MpRggT8LImcsAd2pL7RzjF7uGm09GMp5UoU7GMW
ikdShKoEVBw7tnYry7iHK0F35Y8XRO5/qr37G2swxh6dXfa9EtRV7ZMrqR7VD4ky
X4Li8ZeodCjWUwokeJ9mS474vw7dwcdrce9Dq6dv5I6k+bYv6G9LfYLoL5fvd/17
QIdJKFMRyHlZFqlXujXV7g/Yc5G7C0CZhKlarh2QxHgHpNZ6lLBPMqX8awg05j6t
9IE9gVCmva0HI2JXLKje650HWwz3rloIRvN+Ix48ZAWHYkVkHFFZmyl3Fi7vCiVF
qQlr2eLim/Vxj0X/HDYmIzgHZjIVr8LzH+ZkNMjArskc+wU8q+kuIR4tIK4bu8ib
PjTIAdN7oYlAt2tB74FRF/Hh253UQ0qFoFGPOrEfOmLNCYka1TUGxeCGqc273b9a
bpkZr/1/SuOiLOmfwSkMsWeOd9AcXQAv5WZx1QCjpK/BuPMjwpuVG/WtTBk1plPM
uM2HBrEYkizFX8bOlWZsVaTse6IzEIyJYv8kmfT8PXfYvhsc0eM=
=XCRH
-----END PGP SIGNATURE-----

--/nD5aDiJP7H15fC3--
