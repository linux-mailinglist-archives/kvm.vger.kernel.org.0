Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 461C441BD67
	for <lists+kvm@lfdr.de>; Wed, 29 Sep 2021 05:28:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243989AbhI2D3p (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 28 Sep 2021 23:29:45 -0400
Received: from gandalf.ozlabs.org ([150.107.74.76]:36685 "EHLO
        gandalf.ozlabs.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243929AbhI2D3m (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 28 Sep 2021 23:29:42 -0400
Received: by gandalf.ozlabs.org (Postfix, from userid 1007)
        id 4HK1zN6nb2z4xbV; Wed, 29 Sep 2021 13:28:00 +1000 (AEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gibson.dropbear.id.au; s=201602; t=1632886080;
        bh=Lh+wqN85LusSTOWoTTGpIhxEKSNXglqDi5cXmcybyPM=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=m7I2czU/ggIlbJAAyXgNdK8RQLIITkNN0SyDYxNIKsDzIiU5uNcek1Cfjb7jJp1WR
         YwqoJQfaA1ULr8RKCo/228A0SIauH0eZFDoXW7OUbeei1V22P6MVvNhW4rciYaFQA/
         9cfwuWQaJGiCzNlMpKNOef7AQANPmV5yDZ3dOncw=
Date:   Wed, 29 Sep 2021 12:52:35 +1000
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
Subject: Re: [RFC 04/20] iommu: Add iommu_device_get_info interface
Message-ID: <YVPU89utk3JFPzS7@yekko>
References: <20210919063848.1476776-1-yi.l.liu@intel.com>
 <20210919063848.1476776-5-yi.l.liu@intel.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="sQ2hNteQVd2DEBye"
Content-Disposition: inline
In-Reply-To: <20210919063848.1476776-5-yi.l.liu@intel.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


--sQ2hNteQVd2DEBye
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Sun, Sep 19, 2021 at 02:38:32PM +0800, Liu Yi L wrote:
> From: Lu Baolu <baolu.lu@linux.intel.com>
>=20
> This provides an interface for upper layers to get the per-device iommu
> attributes.
>=20
>     int iommu_device_get_info(struct device *dev,
>                               enum iommu_devattr attr, void *data);

That fact that this interface doesn't let you know how to size the
data buffer, other than by just knowing the right size for each attr
concerns me.

>=20
> The first attribute (IOMMU_DEV_INFO_FORCE_SNOOP) is added. It tells if
> the iommu can force DMA to snoop cache. At this stage, only PCI devices
> which have this attribute set could use the iommufd, this is due to
> supporting no-snoop DMA requires additional refactoring work on the
> current kvm-vfio contract. The following patch will have vfio check this
> attribute to decide whether a pci device can be exposed through
> /dev/vfio/devices.
>=20
> Signed-off-by: Lu Baolu <baolu.lu@linux.intel.com>
> ---
>  drivers/iommu/iommu.c | 16 ++++++++++++++++
>  include/linux/iommu.h | 19 +++++++++++++++++++
>  2 files changed, 35 insertions(+)
>=20
> diff --git a/drivers/iommu/iommu.c b/drivers/iommu/iommu.c
> index 63f0af10c403..5ea3a007fd7c 100644
> --- a/drivers/iommu/iommu.c
> +++ b/drivers/iommu/iommu.c
> @@ -3260,3 +3260,19 @@ static ssize_t iommu_group_store_type(struct iommu=
_group *group,
> =20
>  	return ret;
>  }
> +
> +/* Expose per-device iommu attributes. */
> +int iommu_device_get_info(struct device *dev, enum iommu_devattr attr, v=
oid *data)
> +{
> +	const struct iommu_ops *ops;
> +
> +	if (!dev->bus || !dev->bus->iommu_ops)
> +		return -EINVAL;
> +
> +	ops =3D dev->bus->iommu_ops;
> +	if (unlikely(!ops->device_info))
> +		return -ENODEV;
> +
> +	return ops->device_info(dev, attr, data);
> +}
> +EXPORT_SYMBOL_GPL(iommu_device_get_info);
> diff --git a/include/linux/iommu.h b/include/linux/iommu.h
> index 32d448050bf7..52a6d33c82dc 100644
> --- a/include/linux/iommu.h
> +++ b/include/linux/iommu.h
> @@ -150,6 +150,14 @@ enum iommu_dev_features {
>  	IOMMU_DEV_FEAT_IOPF,
>  };
> =20
> +/**
> + * enum iommu_devattr - Per device IOMMU attributes
> + * @IOMMU_DEV_INFO_FORCE_SNOOP [bool]: IOMMU can force DMA to be snooped.
> + */
> +enum iommu_devattr {
> +	IOMMU_DEV_INFO_FORCE_SNOOP,
> +};
> +
>  #define IOMMU_PASID_INVALID	(-1U)
> =20
>  #ifdef CONFIG_IOMMU_API
> @@ -215,6 +223,7 @@ struct iommu_iotlb_gather {
>   *		- IOMMU_DOMAIN_IDENTITY: must use an identity domain
>   *		- IOMMU_DOMAIN_DMA: must use a dma domain
>   *		- 0: use the default setting
> + * @device_info: query per-device iommu attributes
>   * @pgsize_bitmap: bitmap of all possible supported page sizes
>   * @owner: Driver module providing these ops
>   */
> @@ -283,6 +292,8 @@ struct iommu_ops {
> =20
>  	int (*def_domain_type)(struct device *dev);
> =20
> +	int (*device_info)(struct device *dev, enum iommu_devattr attr, void *d=
ata);
> +
>  	unsigned long pgsize_bitmap;
>  	struct module *owner;
>  };
> @@ -604,6 +615,8 @@ struct iommu_sva *iommu_sva_bind_device(struct device=
 *dev,
>  void iommu_sva_unbind_device(struct iommu_sva *handle);
>  u32 iommu_sva_get_pasid(struct iommu_sva *handle);
> =20
> +int iommu_device_get_info(struct device *dev, enum iommu_devattr attr, v=
oid *data);
> +
>  #else /* CONFIG_IOMMU_API */
> =20
>  struct iommu_ops {};
> @@ -999,6 +1012,12 @@ static inline struct iommu_fwspec *dev_iommu_fwspec=
_get(struct device *dev)
>  {
>  	return NULL;
>  }
> +
> +static inline int iommu_device_get_info(struct device *dev,
> +					enum iommu_devattr type, void *data)
> +{
> +	return -ENODEV;
> +}
>  #endif /* CONFIG_IOMMU_API */
> =20
>  /**

--=20
David Gibson			| I'll have my music baroque, and my code
david AT gibson.dropbear.id.au	| minimalist, thank you.  NOT _the_ _other_
				| _way_ _around_!
http://www.ozlabs.org/~dgibson

--sQ2hNteQVd2DEBye
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEdfRlhq5hpmzETofcbDjKyiDZs5IFAmFT1PMACgkQbDjKyiDZ
s5Kp4xAAuqP94XHXa8idfiJzr+Zmk3LlF5iLCDGNb7As35wm2B95WzFXrIvnG0PR
9GuRnTDbazPssJA5PSwrI8g10LpZ52exjVV00iv1sU62Nk64xahNK+1jpLq5Ktsf
621axCsT3ZqGHy7IQDfERmgJccl4FNdU2Jiv+uUiCcfeUTPNEx6UOggtUGfHMapF
/RYgmuGlI34vI9TUz2y+SxBdfiDp9ySjhNnD5PEjggGy731te7iWKF3nJv4WBPPH
1E0vEaj4ttoY9CnA3ta1waG8pZDJXtNcX3kXC+VE0hmd0KiazEIGt1cqqkZZ9khq
40y+9nfCu2mzsD10qD8VMy3vwoDRnPChsepZRQdT884+J5OjlOk9shLZHdp8mjRh
YDAyqlMyg6dNyHfH/scB7W+eTASkas6FkyNCNvGMFj1nGjGt4xssWFC3mUtHYE1s
Bnd8g5HGZspQKn/hzaXoDgvi6TdNQzApVzIwY+I0AdKFnr3v3kFtIhOptfzKGYGT
q0Ar3JXZAdppywVBThSRKWjMOIBUHbCkXUl6TVdo+ebmeKOJjceKY2BC3SQoDKiG
Pv0vraoPolTkSq1iaKMnR+xwVmATYdZ6wAuKG4TIZ5I7yGAzK+0s5d6zS2mm66kN
uBaU2bfeBKTDdz2xj1fxiK2vZ88TB0rDXoKagGCeKHAigohc82Y=
=EJNn
-----END PGP SIGNATURE-----

--sQ2hNteQVd2DEBye--
