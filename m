Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2FCA541BF1E
	for <lists+kvm@lfdr.de>; Wed, 29 Sep 2021 08:27:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244338AbhI2G3a (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 29 Sep 2021 02:29:30 -0400
Received: from gandalf.ozlabs.org ([150.107.74.76]:51261 "EHLO
        gandalf.ozlabs.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244007AbhI2G3a (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 29 Sep 2021 02:29:30 -0400
Received: by gandalf.ozlabs.org (Postfix, from userid 1007)
        id 4HK5yr2fkzz4xbL; Wed, 29 Sep 2021 16:27:48 +1000 (AEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gibson.dropbear.id.au; s=201602; t=1632896868;
        bh=mr8T2dUFcwNty0SxIc0VjskQ4O0Q+O9/95F3lM2pwU4=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=c5/7JuoKUpL5hoAKKXVA55lE2T3MHf41T+ZKUeZHBJ0kT+COHyT3qjHM3HbcduCKf
         BTOcA6viX8/8gp623bNEk3eR+S/oKMF+zG1EyGBKmHTCniktGH/Q2kPsoEWOSXtlSF
         0CWkHLqvGxjqg5n7X4nwalBSXAk//fwmjjIVDH90=
Date:   Wed, 29 Sep 2021 15:25:54 +1000
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
Subject: Re: [RFC 07/20] iommu/iommufd: Add iommufd_[un]bind_device()
Message-ID: <YVP44v4FVYJBSEEF@yekko>
References: <20210919063848.1476776-1-yi.l.liu@intel.com>
 <20210919063848.1476776-8-yi.l.liu@intel.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="9rRoGsf9TeuDCWkD"
Content-Disposition: inline
In-Reply-To: <20210919063848.1476776-8-yi.l.liu@intel.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


--9rRoGsf9TeuDCWkD
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Sun, Sep 19, 2021 at 02:38:35PM +0800, Liu Yi L wrote:
> Under the /dev/iommu model, iommufd provides the interface for I/O page
> tables management such as dma map/unmap. However, it cannot work
> independently since the device is still owned by the device-passthrough
> frameworks (VFIO, vDPA, etc.) and vice versa. Device-passthrough framewor=
ks
> should build a connection between its device and the iommufd to delegate
> the I/O page table management affairs to iommufd.
>=20
> This patch introduces iommufd_[un]bind_device() helpers for the device-
> passthrough framework to build such connection. The helper functions then
> invoke iommu core (iommu_device_init/exit_user_dma()) to establish/exit
> security context for the bound device. Each successfully bound device is
> internally tracked by an iommufd_device object. This object is returned
> to the caller for subsequent attaching operations on the device as well.
>=20
> The caller should pass a user-provided cookie to mark the device in the
> iommufd. Later this cookie will be used to represent the device in iommufd
> uAPI, e.g. when querying device capabilities or handling per-device I/O
> page faults. One alternative is to have iommufd allocate a device label
> and return to the user. Either way works, but cookie is slightly preferred
> per earlier discussion as it may allow the user to inject faults slightly
> faster without ID->vRID lookup.
>=20
> iommu_[un]bind_device() functions are only used for physical devices. Oth=
er
> variants will be introduced in the future, e.g.:
>=20
> -  iommu_[un]bind_device_pasid() for mdev/subdev which requires pasid gra=
nular
>    DMA isolation;
> -  iommu_[un]bind_sw_mdev() for sw mdev which relies on software measures
>    instead of iommu to isolate DMA;
>=20
> Signed-off-by: Liu Yi L <yi.l.liu@intel.com>
> ---
>  drivers/iommu/iommufd/iommufd.c | 160 +++++++++++++++++++++++++++++++-
>  include/linux/iommufd.h         |  38 ++++++++
>  2 files changed, 196 insertions(+), 2 deletions(-)
>  create mode 100644 include/linux/iommufd.h
>=20
> diff --git a/drivers/iommu/iommufd/iommufd.c b/drivers/iommu/iommufd/iomm=
ufd.c
> index 710b7e62988b..e16ca21e4534 100644
> --- a/drivers/iommu/iommufd/iommufd.c
> +++ b/drivers/iommu/iommufd/iommufd.c
> @@ -16,10 +16,30 @@
>  #include <linux/miscdevice.h>
>  #include <linux/mutex.h>
>  #include <linux/iommu.h>
> +#include <linux/iommufd.h>
> +#include <linux/xarray.h>
> +#include <asm-generic/bug.h>
> =20
>  /* Per iommufd */
>  struct iommufd_ctx {
>  	refcount_t refs;
> +	struct mutex lock;
> +	struct xarray device_xa; /* xarray of bound devices */
> +};
> +
> +/*
> + * A iommufd_device object represents the binding relationship
> + * between iommufd and device. It is created per a successful
> + * binding request from device driver. The bound device must be
> + * a physical device so far. Subdevice will be supported later
> + * (with additional PASID information). An user-assigned cookie
> + * is also recorded to mark the device in the /dev/iommu uAPI.
> + */
> +struct iommufd_device {
> +	unsigned int id;
> +	struct iommufd_ctx *ictx;
> +	struct device *dev; /* always be the physical device */
> +	u64 dev_cookie;

Why do you need both an 'id' and a 'dev_cookie'?  Since they're both
unique, couldn't you just use the cookie directly as the index into
the xarray?

>  };
> =20
>  static int iommufd_fops_open(struct inode *inode, struct file *filep)
> @@ -32,15 +52,58 @@ static int iommufd_fops_open(struct inode *inode, str=
uct file *filep)
>  		return -ENOMEM;
> =20
>  	refcount_set(&ictx->refs, 1);
> +	mutex_init(&ictx->lock);
> +	xa_init_flags(&ictx->device_xa, XA_FLAGS_ALLOC);
>  	filep->private_data =3D ictx;
> =20
>  	return ret;
>  }
> =20
> +static void iommufd_ctx_get(struct iommufd_ctx *ictx)
> +{
> +	refcount_inc(&ictx->refs);
> +}
> +
> +static const struct file_operations iommufd_fops;
> +
> +/**
> + * iommufd_ctx_fdget - Acquires a reference to the internal iommufd cont=
ext.
> + * @fd: [in] iommufd file descriptor.
> + *
> + * Returns a pointer to the iommufd context, otherwise NULL;
> + *
> + */
> +static struct iommufd_ctx *iommufd_ctx_fdget(int fd)
> +{
> +	struct fd f =3D fdget(fd);
> +	struct file *file =3D f.file;
> +	struct iommufd_ctx *ictx;
> +
> +	if (!file)
> +		return NULL;
> +
> +	if (file->f_op !=3D &iommufd_fops)
> +		return NULL;
> +
> +	ictx =3D file->private_data;
> +	if (ictx)
> +		iommufd_ctx_get(ictx);
> +	fdput(f);
> +	return ictx;
> +}
> +
> +/**
> + * iommufd_ctx_put - Releases a reference to the internal iommufd contex=
t.
> + * @ictx: [in] Pointer to iommufd context.
> + *
> + */
>  static void iommufd_ctx_put(struct iommufd_ctx *ictx)
>  {
> -	if (refcount_dec_and_test(&ictx->refs))
> -		kfree(ictx);
> +	if (!refcount_dec_and_test(&ictx->refs))
> +		return;
> +
> +	WARN_ON(!xa_empty(&ictx->device_xa));
> +	kfree(ictx);
>  }
> =20
>  static int iommufd_fops_release(struct inode *inode, struct file *filep)
> @@ -86,6 +149,99 @@ static struct miscdevice iommu_misc_dev =3D {
>  	.mode =3D 0666,
>  };
> =20
> +/**
> + * iommufd_bind_device - Bind a physical device marked by a device
> + *			 cookie to an iommu fd.
> + * @fd:		[in] iommufd file descriptor.
> + * @dev:	[in] Pointer to a physical device struct.
> + * @dev_cookie:	[in] A cookie to mark the device in /dev/iommu uAPI.
> + *
> + * A successful bind establishes a security context for the device
> + * and returns struct iommufd_device pointer. Otherwise returns
> + * error pointer.
> + *
> + */
> +struct iommufd_device *iommufd_bind_device(int fd, struct device *dev,
> +					   u64 dev_cookie)
> +{
> +	struct iommufd_ctx *ictx;
> +	struct iommufd_device *idev;
> +	unsigned long index;
> +	unsigned int id;
> +	int ret;
> +
> +	ictx =3D iommufd_ctx_fdget(fd);
> +	if (!ictx)
> +		return ERR_PTR(-EINVAL);
> +
> +	mutex_lock(&ictx->lock);
> +
> +	/* check duplicate registration */
> +	xa_for_each(&ictx->device_xa, index, idev) {
> +		if (idev->dev =3D=3D dev || idev->dev_cookie =3D=3D dev_cookie) {
> +			idev =3D ERR_PTR(-EBUSY);
> +			goto out_unlock;
> +		}
> +	}
> +
> +	idev =3D kzalloc(sizeof(*idev), GFP_KERNEL);
> +	if (!idev) {
> +		ret =3D -ENOMEM;
> +		goto out_unlock;
> +	}
> +
> +	/* Establish the security context */
> +	ret =3D iommu_device_init_user_dma(dev, (unsigned long)ictx);
> +	if (ret)
> +		goto out_free;
> +
> +	ret =3D xa_alloc(&ictx->device_xa, &id, idev,
> +		       XA_LIMIT(IOMMUFD_DEVID_MIN, IOMMUFD_DEVID_MAX),
> +		       GFP_KERNEL);
> +	if (ret) {
> +		idev =3D ERR_PTR(ret);
> +		goto out_user_dma;
> +	}
> +
> +	idev->ictx =3D ictx;
> +	idev->dev =3D dev;
> +	idev->dev_cookie =3D dev_cookie;
> +	idev->id =3D id;
> +	mutex_unlock(&ictx->lock);
> +
> +	return idev;
> +out_user_dma:
> +	iommu_device_exit_user_dma(idev->dev);
> +out_free:
> +	kfree(idev);
> +out_unlock:
> +	mutex_unlock(&ictx->lock);
> +	iommufd_ctx_put(ictx);
> +
> +	return ERR_PTR(ret);
> +}
> +EXPORT_SYMBOL_GPL(iommufd_bind_device);
> +
> +/**
> + * iommufd_unbind_device - Unbind a physical device from iommufd
> + *
> + * @idev: [in] Pointer to the internal iommufd_device struct.
> + *
> + */
> +void iommufd_unbind_device(struct iommufd_device *idev)
> +{
> +	struct iommufd_ctx *ictx =3D idev->ictx;
> +
> +	mutex_lock(&ictx->lock);
> +	xa_erase(&ictx->device_xa, idev->id);
> +	mutex_unlock(&ictx->lock);
> +	/* Exit the security context */
> +	iommu_device_exit_user_dma(idev->dev);
> +	kfree(idev);
> +	iommufd_ctx_put(ictx);
> +}
> +EXPORT_SYMBOL_GPL(iommufd_unbind_device);
> +
>  static int __init iommufd_init(void)
>  {
>  	int ret;
> diff --git a/include/linux/iommufd.h b/include/linux/iommufd.h
> new file mode 100644
> index 000000000000..1603a13937e9
> --- /dev/null
> +++ b/include/linux/iommufd.h
> @@ -0,0 +1,38 @@
> +/* SPDX-License-Identifier: GPL-2.0-only */
> +/*
> + * IOMMUFD API definition
> + *
> + * Copyright (C) 2021 Intel Corporation
> + *
> + * Author: Liu Yi L <yi.l.liu@intel.com>
> + */
> +#ifndef __LINUX_IOMMUFD_H
> +#define __LINUX_IOMMUFD_H
> +
> +#include <linux/types.h>
> +#include <linux/errno.h>
> +#include <linux/err.h>
> +#include <linux/device.h>
> +
> +#define IOMMUFD_DEVID_MAX	((unsigned int)(0x7FFFFFFF))
> +#define IOMMUFD_DEVID_MIN	0
> +
> +struct iommufd_device;
> +
> +#if IS_ENABLED(CONFIG_IOMMUFD)
> +struct iommufd_device *
> +iommufd_bind_device(int fd, struct device *dev, u64 dev_cookie);
> +void iommufd_unbind_device(struct iommufd_device *idev);
> +
> +#else /* !CONFIG_IOMMUFD */
> +static inline struct iommufd_device *
> +iommufd_bind_device(int fd, struct device *dev, u64 dev_cookie)
> +{
> +	return ERR_PTR(-ENODEV);
> +}
> +
> +static inline void iommufd_unbind_device(struct iommufd_device *idev)
> +{
> +}
> +#endif /* CONFIG_IOMMUFD */
> +#endif /* __LINUX_IOMMUFD_H */

--=20
David Gibson			| I'll have my music baroque, and my code
david AT gibson.dropbear.id.au	| minimalist, thank you.  NOT _the_ _other_
				| _way_ _around_!
http://www.ozlabs.org/~dgibson

--9rRoGsf9TeuDCWkD
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEdfRlhq5hpmzETofcbDjKyiDZs5IFAmFT+N8ACgkQbDjKyiDZ
s5JkSRAAjLugKr7SstRX6J1JqlhJ0YzpyFgvrQFrfpvyeIYqsQxjN0gn1rRfoZCq
9DxPe138xIRAwx9JtSggc0j2tf7TSeLaRvF/8EWIqMNvZExTq/HQoV5LGqO/qrVc
ahj7LnrF9PuiOgtLbN6OGS+qVhxu0Bfb1ikKy++ptV+AenAXA362JOrqoJgc3/Fo
Ve2INGP+mxBzjbMjojnpZL0Jp9QKcRACobDNV8YnUi2U0tC46EBsXyaBjgADA9od
+TqARKmwH83cTDS93QaO6BkrkL5EUt5nj52giSoyFT9/3znKPQYHq5id63qQeznc
e6/42ZUEELVjLWjVHiKU9kKkH1LCcFxWa1qh7yQLRhJmfM62h68RU8SIRlg1AtbF
spFXsTwG0G9OfEytAGl2gS72eEVxKidizHqSh5Nk+BUNRH/xztiWiVd0+FCMdGnZ
1dNug/yCSOsXuuWOGwRZBbOpUvSDaA3YMW9Xik1w2etlJLzQIsZfyIdnPRJHhbOk
EjQnM6y7zTbco9QHlcoBJijXOyQpjFn9EWlMDRlyc2SaLUL7yNCp/ZaZvudb1lWd
REGh8Vn7s7o1rtaYtnFoJzX5Xhm5++c4ggOFsm4NoycY3KB6R1SyH3uaflAxs1BA
GIMVUZLwjES05BNCjB5BuUnHC+gDKe4YH9mvUNKdIGcMkZbQyaE=
=89YU
-----END PGP SIGNATURE-----

--9rRoGsf9TeuDCWkD--
