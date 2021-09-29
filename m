Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 833CC41BD65
	for <lists+kvm@lfdr.de>; Wed, 29 Sep 2021 05:28:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243982AbhI2D3o (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 28 Sep 2021 23:29:44 -0400
Received: from gandalf.ozlabs.org ([150.107.74.76]:53491 "EHLO
        gandalf.ozlabs.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243927AbhI2D3m (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 28 Sep 2021 23:29:42 -0400
Received: by gandalf.ozlabs.org (Postfix, from userid 1007)
        id 4HK1zN6TVLz4xbP; Wed, 29 Sep 2021 13:28:00 +1000 (AEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gibson.dropbear.id.au; s=201602; t=1632886080;
        bh=ZS1zwvHNhy7AC5tdaO90EXykhJjziNdx6qw7TXGPvmg=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Q4dKuUBaZfcYwZad2bfwRDQo9ZmIkZnM1Jq6ZpD88XbzcazSZOxqM0UyjsodrZXGP
         b/kSzBXVKQS3icvLSQkuS/rHPeHAgC2vShlH7HLv5jcfbksDjUx3NPuoSn+brtRa3f
         SZf21EyITeYNRQi3stuZZ2MA67Vkl8HswtMZ5Vpg=
Date:   Wed, 29 Sep 2021 12:43:47 +1000
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
Subject: Re: [RFC 03/20] vfio: Add vfio_[un]register_device()
Message-ID: <YVPS43bNjvzdxdiM@yekko>
References: <20210919063848.1476776-1-yi.l.liu@intel.com>
 <20210919063848.1476776-4-yi.l.liu@intel.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="rxFB5Bqis+DMYXzX"
Content-Disposition: inline
In-Reply-To: <20210919063848.1476776-4-yi.l.liu@intel.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


--rxFB5Bqis+DMYXzX
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Sun, Sep 19, 2021 at 02:38:31PM +0800, Liu Yi L wrote:
> With /dev/vfio/devices introduced, now a vfio device driver has three
> options to expose its device to userspace:
>=20
> a)  only legacy group interface, for devices which haven't been moved to
>     iommufd (e.g. platform devices, sw mdev, etc.);
>=20
> b)  both legacy group interface and new device-centric interface, for
>     devices which supports iommufd but also wants to keep backward
>     compatibility (e.g. pci devices in this RFC);
>=20
> c)  only new device-centric interface, for new devices which don't carry
>     backward compatibility burden (e.g. hw mdev/subdev with pasid);
>=20
> This patch introduces vfio_[un]register_device() helpers for the device
> drivers to specify the device exposure policy to vfio core. Hence the
> existing vfio_[un]register_group_dev() become the wrapper of the new
> helper functions. The new device-centric interface is described as
> 'nongroup' to differentiate from existing 'group' stuff.
>=20
> TBD: this patch needs to rebase on top of below series from Christoph in
> next version.
>=20
> 	"cleanup vfio iommu_group creation"
>=20
> Legacy userspace continues to follow the legacy group interface.
>=20
> Newer userspace can first try the new device-centric interface if the
> device is present under /dev/vfio/devices. Otherwise fall back to the
> group interface.
>=20
> One open about how to organize the device nodes under /dev/vfio/devices/.
> This RFC adopts a simple policy by keeping a flat layout with mixed devna=
me
> from all kinds of devices. The prerequisite of this model is that devnames
> from different bus types are unique formats:
>=20
> 	/dev/vfio/devices/0000:00:14.2 (pci)
> 	/dev/vfio/devices/PNP0103:00 (platform)
> 	/dev/vfio/devices/83b8f4f2-509f-382f-3c1e-e6bfe0fa1001 (mdev)

Oof.  I really don't think this is a good idea.  Ensuring that a
format is "unique" in the sense that it can't collide with any of the
other formats, for *every* value of the parameters on both sides is
actually pretty complicated in general.

I think per-type sub-directories would be helpful here, Jason's
suggestion of just sequential numbers would work as well.

> One alternative option is to arrange device nodes in sub-directories based
> on the device type. But doing so also adds one trouble to userspace. The
> current vfio uAPI is designed to have the user query device type via
> VFIO_DEVICE_GET_INFO after opening the device. With this option the user
> instead needs to figure out the device type before opening the device, to
> identify the sub-directory.

Wouldn't this be up to the operator / configuration, rather than the
actual software though?  I would assume that typically the VFIO
program would be pointed at a specific vfio device node file to use,
e.g.
	my-vfio-prog -d /dev/vfio/pci/0000:0a:03.1

Or more generally, if you're expecting userspace to know a name in a
uniqu pattern, they can equally well know a "type/name" pair.

> Another tricky thing is that "pdev. vs. mdev"
> and "pci vs. platform vs. ccw,..." are orthogonal categorizations. Need
> more thoughts on whether both or just one category should be used to defi=
ne
> the sub-directories.
>=20
> Signed-off-by: Liu Yi L <yi.l.liu@intel.com>
> ---
>  drivers/vfio/vfio.c  | 137 +++++++++++++++++++++++++++++++++++++++----
>  include/linux/vfio.h |   9 +++
>  2 files changed, 134 insertions(+), 12 deletions(-)
>=20
> diff --git a/drivers/vfio/vfio.c b/drivers/vfio/vfio.c
> index 84436d7abedd..1e87b25962f1 100644
> --- a/drivers/vfio/vfio.c
> +++ b/drivers/vfio/vfio.c
> @@ -51,6 +51,7 @@ static struct vfio {
>  	struct cdev			device_cdev;
>  	dev_t				device_devt;
>  	struct mutex			device_lock;
> +	struct list_head		device_list;
>  	struct idr			device_idr;
>  } vfio;
> =20
> @@ -757,7 +758,7 @@ void vfio_init_group_dev(struct vfio_device *device, =
struct device *dev,
>  }
>  EXPORT_SYMBOL_GPL(vfio_init_group_dev);
> =20
> -int vfio_register_group_dev(struct vfio_device *device)
> +static int __vfio_register_group_dev(struct vfio_device *device)
>  {
>  	struct vfio_device *existing_device;
>  	struct iommu_group *iommu_group;
> @@ -794,8 +795,13 @@ int vfio_register_group_dev(struct vfio_device *devi=
ce)
>  	/* Our reference on group is moved to the device */
>  	device->group =3D group;
> =20
> -	/* Refcounting can't start until the driver calls register */
> -	refcount_set(&device->refcount, 1);
> +	/*
> +	 * Refcounting can't start until the driver call register. Don=E2=80=99t
> +	 * start twice when the device is exposed in both group and nongroup
> +	 * interfaces.
> +	 */
> +	if (!refcount_read(&device->refcount))

Is there a possible race here with something getting in and
incrementing the refcount between the read and set?

> +		refcount_set(&device->refcount, 1);
> =20
>  	mutex_lock(&group->device_lock);
>  	list_add(&device->group_next, &group->device_list);
> @@ -804,7 +810,78 @@ int vfio_register_group_dev(struct vfio_device *devi=
ce)
> =20
>  	return 0;
>  }
> -EXPORT_SYMBOL_GPL(vfio_register_group_dev);
> +
> +static int __vfio_register_nongroup_dev(struct vfio_device *device)
> +{
> +	struct vfio_device *existing_device;
> +	struct device *dev;
> +	int ret =3D 0, minor;
> +
> +	mutex_lock(&vfio.device_lock);
> +	list_for_each_entry(existing_device, &vfio.device_list, vfio_next) {
> +		if (existing_device =3D=3D device) {
> +			ret =3D -EBUSY;
> +			goto out_unlock;

This indicates a bug in the caller, doesn't it?  Should it be a BUG or
WARN instead?

> +		}
> +	}
> +
> +	minor =3D idr_alloc(&vfio.device_idr, device, 0, MINORMASK + 1, GFP_KER=
NEL);
> +	pr_debug("%s - mnior: %d\n", __func__, minor);
> +	if (minor < 0) {
> +		ret =3D minor;
> +		goto out_unlock;
> +	}
> +
> +	dev =3D device_create(vfio.device_class, NULL,
> +			    MKDEV(MAJOR(vfio.device_devt), minor),
> +			    device, "%s", dev_name(device->dev));
> +	if (IS_ERR(dev)) {
> +		idr_remove(&vfio.device_idr, minor);
> +		ret =3D PTR_ERR(dev);
> +		goto out_unlock;
> +	}
> +
> +	/*
> +	 * Refcounting can't start until the driver call register. Don=E2=80=99t
> +	 * start twice when the device is exposed in both group and nongroup
> +	 * interfaces.
> +	 */
> +	if (!refcount_read(&device->refcount))
> +		refcount_set(&device->refcount, 1);
> +
> +	device->minor =3D minor;
> +	list_add(&device->vfio_next, &vfio.device_list);
> +	dev_info(device->dev, "Creates Device interface successfully!\n");
> +out_unlock:
> +	mutex_unlock(&vfio.device_lock);
> +	return ret;
> +}
> +
> +int vfio_register_device(struct vfio_device *device, u32 flags)
> +{
> +	int ret =3D -EINVAL;
> +
> +	device->minor =3D -1;
> +	device->group =3D NULL;
> +	atomic_set(&device->opened, 0);
> +
> +	if (flags & ~(VFIO_DEVNODE_GROUP | VFIO_DEVNODE_NONGROUP))
> +		return ret;
> +
> +	if (flags & VFIO_DEVNODE_GROUP) {
> +		ret =3D __vfio_register_group_dev(device);
> +		if (ret)
> +			return ret;
> +	}
> +
> +	if (flags & VFIO_DEVNODE_NONGROUP) {
> +		ret =3D __vfio_register_nongroup_dev(device);
> +		if (ret && device->group)
> +			vfio_unregister_device(device);
> +	}
> +	return ret;
> +}
> +EXPORT_SYMBOL_GPL(vfio_register_device);
> =20
>  /**
>   * Get a reference to the vfio_device for a device.  Even if the
> @@ -861,13 +938,14 @@ static struct vfio_device *vfio_device_get_from_nam=
e(struct vfio_group *group,
>  /*
>   * Decrement the device reference count and wait for the device to be
>   * removed.  Open file descriptors for the device... */
> -void vfio_unregister_group_dev(struct vfio_device *device)
> +void vfio_unregister_device(struct vfio_device *device)
>  {
>  	struct vfio_group *group =3D device->group;
>  	struct vfio_unbound_dev *unbound;
>  	unsigned int i =3D 0;
>  	bool interrupted =3D false;
>  	long rc;
> +	int minor =3D device->minor;
> =20
>  	/*
>  	 * When the device is removed from the group, the group suddenly
> @@ -878,14 +956,20 @@ void vfio_unregister_group_dev(struct vfio_device *=
device)
>  	 * solve this, we track such devices on the unbound_list to bridge
>  	 * the gap until they're fully unbound.
>  	 */
> -	unbound =3D kzalloc(sizeof(*unbound), GFP_KERNEL);
> -	if (unbound) {
> -		unbound->dev =3D device->dev;
> -		mutex_lock(&group->unbound_lock);
> -		list_add(&unbound->unbound_next, &group->unbound_list);
> -		mutex_unlock(&group->unbound_lock);
> +	if (group) {
> +		/*
> +		 * If caller hasn't called vfio_register_group_dev(), this
> +		 * branch is not necessary.
> +		 */
> +		unbound =3D kzalloc(sizeof(*unbound), GFP_KERNEL);
> +		if (unbound) {
> +			unbound->dev =3D device->dev;
> +			mutex_lock(&group->unbound_lock);
> +			list_add(&unbound->unbound_next, &group->unbound_list);
> +			mutex_unlock(&group->unbound_lock);
> +		}
> +		WARN_ON(!unbound);
>  	}
> -	WARN_ON(!unbound);
> =20
>  	vfio_device_put(device);
>  	rc =3D try_wait_for_completion(&device->comp);
> @@ -910,6 +994,21 @@ void vfio_unregister_group_dev(struct vfio_device *d=
evice)
>  		}
>  	}
> =20
> +	/* nongroup interface related cleanup */
> +	if (minor >=3D 0) {
> +		mutex_lock(&vfio.device_lock);
> +		list_del(&device->vfio_next);
> +		device->minor =3D -1;
> +		device_destroy(vfio.device_class,
> +			       MKDEV(MAJOR(vfio.device_devt), minor));
> +		idr_remove(&vfio.device_idr, minor);
> +		mutex_unlock(&vfio.device_lock);
> +	}
> +
> +	/* No need go further if no group. */
> +	if (!group)
> +		return;
> +
>  	mutex_lock(&group->device_lock);
>  	list_del(&device->group_next);
>  	group->dev_counter--;
> @@ -935,6 +1034,18 @@ void vfio_unregister_group_dev(struct vfio_device *=
device)
>  	/* Matches the get in vfio_register_group_dev() */
>  	vfio_group_put(group);
>  }
> +EXPORT_SYMBOL_GPL(vfio_unregister_device);
> +
> +int vfio_register_group_dev(struct vfio_device *device)
> +{
> +	return vfio_register_device(device, VFIO_DEVNODE_GROUP);
> +}
> +EXPORT_SYMBOL_GPL(vfio_register_group_dev);
> +
> +void vfio_unregister_group_dev(struct vfio_device *device)
> +{
> +	vfio_unregister_device(device);
> +}
>  EXPORT_SYMBOL_GPL(vfio_unregister_group_dev);
> =20
>  /**
> @@ -2447,6 +2558,7 @@ static int vfio_init_device_class(void)
> =20
>  	mutex_init(&vfio.device_lock);
>  	idr_init(&vfio.device_idr);
> +	INIT_LIST_HEAD(&vfio.device_list);
> =20
>  	/* /dev/vfio/devices/$DEVICE */
>  	vfio.device_class =3D class_create(THIS_MODULE, "vfio-device");
> @@ -2542,6 +2654,7 @@ static int __init vfio_init(void)
>  static void __exit vfio_cleanup(void)
>  {
>  	WARN_ON(!list_empty(&vfio.group_list));
> +	WARN_ON(!list_empty(&vfio.device_list));
> =20
>  #ifdef CONFIG_VFIO_NOIOMMU
>  	vfio_unregister_iommu_driver(&vfio_noiommu_ops);
> diff --git a/include/linux/vfio.h b/include/linux/vfio.h
> index 4a5f3f99eab2..9448b751b663 100644
> --- a/include/linux/vfio.h
> +++ b/include/linux/vfio.h
> @@ -26,6 +26,7 @@ struct vfio_device {
>  	struct list_head group_next;
>  	int minor;
>  	atomic_t opened;
> +	struct list_head vfio_next;
>  };
> =20
>  /**
> @@ -73,6 +74,14 @@ enum vfio_iommu_notify_type {
>  	VFIO_IOMMU_CONTAINER_CLOSE =3D 0,
>  };
> =20
> +/* The device can be opened via VFIO_GROUP_GET_DEVICE_FD */
> +#define VFIO_DEVNODE_GROUP	BIT(0)
> +/* The device can be opened via /dev/sys/devices/${DEVICE} */
> +#define VFIO_DEVNODE_NONGROUP	BIT(1)
> +
> +extern int vfio_register_device(struct vfio_device *device, u32 flags);
> +extern void vfio_unregister_device(struct vfio_device *device);
> +
>  /**
>   * struct vfio_iommu_driver_ops - VFIO IOMMU driver callbacks
>   */

--=20
David Gibson			| I'll have my music baroque, and my code
david AT gibson.dropbear.id.au	| minimalist, thank you.  NOT _the_ _other_
				| _way_ _around_!
http://www.ozlabs.org/~dgibson

--rxFB5Bqis+DMYXzX
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEdfRlhq5hpmzETofcbDjKyiDZs5IFAmFT0uEACgkQbDjKyiDZ
s5IONBAAh/wwfk+EVKETtLc7FGMbI7u57fcxq61Q6nwQP7X00dZBjPMMeTRkLe50
1Qvy3H3HN7dHeTru+xK+LqUIg2B5ZG6mAQtVnvbNwxq8VnYdm0rIwtqXQmXyokMz
zvCvjqSupU7LUJx0bY6k89kCSHh93H637D+/6gPlu8jk11e9tGR0IAsB8pQbiLxD
pI20GwfLiBx8xQQG01RSAZl03X8+R5n+aLoI6JHjyxLaLXvPMjP6MKTjfXRPsyr3
RdxCCDpRRFDPOfK3SYrjGP6AvIFZWsAAbl37Q9rmeCEEFLreLN+fUit8W0JN6/EX
J+g88yRTClvxq8gdXQ5hvR0cMTPUxex3wDe5924uiPbmJJpYuCylJYZJC6wFY7cM
3UuLCCmKd2s9yuUFGFzEhc5wMZllZyY/e6ypumoQNBUmhn5IzUhduT+y6KVdf58L
uZ7UnAzbYyCfEfhzkNxad6FZXzb1tq4MHHAsmpU89SaR2uJ6bhjyd9a+TlUN2XhW
1lF94cCaMDpn8yaAxIxNNaGph2YSdoevewfix0AsyfuU8wi4AGMBWappIwGMi3FT
vQcVfQDEWAeonuHarvRj7Ln5YEZOapy5bx00hjWDEHVCBfbPCBHhqHEtdiXv5whR
kgbWEgpCHHIMirGLJiTBqC4Znc5uy87m5IKOiZjLn/iCiuR18k0=
=iur8
-----END PGP SIGNATURE-----

--rxFB5Bqis+DMYXzX--
