Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9360E42D24B
	for <lists+kvm@lfdr.de>; Thu, 14 Oct 2021 08:22:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229933AbhJNGYn (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 14 Oct 2021 02:24:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40558 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229672AbhJNGYj (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 14 Oct 2021 02:24:39 -0400
Received: from gandalf.ozlabs.org (gandalf.ozlabs.org [IPv6:2404:9400:2:0:216:3eff:fee2:21ea])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2A12BC061746;
        Wed, 13 Oct 2021 23:22:35 -0700 (PDT)
Received: by gandalf.ozlabs.org (Postfix, from userid 1007)
        id 4HVK7r2S38z4xqT; Thu, 14 Oct 2021 17:22:32 +1100 (AEDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gibson.dropbear.id.au; s=201602; t=1634192552;
        bh=OTTe4+lAhyLUWJzZiGJrOam3cYsUQwZJXvJ/DxMrddo=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=HQWLk7Fe8segL63WWDIUMVqqyL9MO5uGR7AItks/wHEwX735Oj/tg6WqkCmzoWJKM
         7DfgLmb2hIyVO1woDdbTyetbzXEQXd1DWP/QjwrUc5UqcCCvvDK1M7n2nxl0KP/KPu
         twP6rH6BjHRpv5PDiYtX//j87GI7cYEk9G8C5qO4=
Date:   Thu, 14 Oct 2021 16:24:03 +1100
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
Subject: Re: [RFC 13/20] iommu: Extend iommu_at[de]tach_device() for multiple
 devices group
Message-ID: <YWe+88sfCbxgMYPN@yekko>
References: <20210919063848.1476776-1-yi.l.liu@intel.com>
 <20210919063848.1476776-14-yi.l.liu@intel.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="yqSnmJuJEfpVkol+"
Content-Disposition: inline
In-Reply-To: <20210919063848.1476776-14-yi.l.liu@intel.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


--yqSnmJuJEfpVkol+
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Sun, Sep 19, 2021 at 02:38:41PM +0800, Liu Yi L wrote:
> From: Lu Baolu <baolu.lu@linux.intel.com>
>=20
> These two helpers could be used when 1) the iommu group is singleton,
> or 2) the upper layer has put the iommu group into the secure state by
> calling iommu_device_init_user_dma().
>=20
> As we want the iommufd design to be a device-centric model, we want to
> remove any group knowledge in iommufd. Given that we already have
> iommu_at[de]tach_device() interface, we could extend it for iommufd
> simply by doing below:
>=20
>  - first device in a group does group attach;
>  - last device in a group does group detach.
>=20
> as long as the group has been put into the secure context.
>=20
> The commit <426a273834eae> ("iommu: Limit iommu_attach/detach_device to
> device with their own group") deliberately restricts the two interfaces
> to single-device group. To avoid the conflict with existing usages, we
> keep this policy and put the new extension only when the group has been
> marked for user_dma.

I still kind of hate this interface because it means an operation that
appears to be explicitly on a single device has an implicit effect on
other devices.

> Signed-off-by: Lu Baolu <baolu.lu@linux.intel.com>
> ---
>  drivers/iommu/iommu.c | 25 +++++++++++++++++++++----
>  1 file changed, 21 insertions(+), 4 deletions(-)
>=20
> diff --git a/drivers/iommu/iommu.c b/drivers/iommu/iommu.c
> index bffd84e978fb..b6178997aef1 100644
> --- a/drivers/iommu/iommu.c
> +++ b/drivers/iommu/iommu.c
> @@ -47,6 +47,7 @@ struct iommu_group {
>  	struct list_head entry;
>  	unsigned long user_dma_owner_id;
>  	refcount_t owner_cnt;
> +	refcount_t attach_cnt;
>  };
> =20
>  struct group_device {
> @@ -1994,7 +1995,7 @@ static int __iommu_attach_device(struct iommu_domai=
n *domain,
>  int iommu_attach_device(struct iommu_domain *domain, struct device *dev)
>  {
>  	struct iommu_group *group;
> -	int ret;
> +	int ret =3D 0;
> =20
>  	group =3D iommu_group_get(dev);
>  	if (!group)
> @@ -2005,11 +2006,23 @@ int iommu_attach_device(struct iommu_domain *doma=
in, struct device *dev)
>  	 * change while we are attaching
>  	 */
>  	mutex_lock(&group->mutex);
> -	ret =3D -EINVAL;
> -	if (iommu_group_device_count(group) !=3D 1)
> +	if (group->user_dma_owner_id) {
> +		if (group->domain) {
> +			if (group->domain !=3D domain)
> +				ret =3D -EBUSY;
> +			else
> +				refcount_inc(&group->attach_cnt);
> +
> +			goto out_unlock;
> +		}
> +	} else if (iommu_group_device_count(group) !=3D 1) {

With this condition in the else, how can you ever attach the first
device of a multi-device group?

> +		ret =3D -EINVAL;
>  		goto out_unlock;
> +	}
> =20
>  	ret =3D __iommu_attach_group(domain, group);
> +	if (!ret && group->user_dma_owner_id)
> +		refcount_set(&group->attach_cnt, 1);
> =20
>  out_unlock:
>  	mutex_unlock(&group->mutex);
> @@ -2261,7 +2274,10 @@ void iommu_detach_device(struct iommu_domain *doma=
in, struct device *dev)
>  		return;
> =20
>  	mutex_lock(&group->mutex);
> -	if (iommu_group_device_count(group) !=3D 1) {
> +	if (group->user_dma_owner_id) {
> +		if (!refcount_dec_and_test(&group->attach_cnt))
> +			goto out_unlock;
> +	} else if (iommu_group_device_count(group) !=3D 1) {

Shouldn't this path (detach a thing that's not attached), be a no-op
regardless of whether it's a singleton group or not?  Why does one
deserve a warning and one not?

>  		WARN_ON(1);
>  		goto out_unlock;
>  	}
> @@ -3368,6 +3384,7 @@ static int iommu_group_init_user_dma(struct iommu_g=
roup *group,
> =20
>  	group->user_dma_owner_id =3D owner;
>  	refcount_set(&group->owner_cnt, 1);
> +	refcount_set(&group->attach_cnt, 0);
> =20
>  	/* default domain is unsafe for user-initiated dma */
>  	if (group->domain =3D=3D group->default_domain)

--=20
David Gibson			| I'll have my music baroque, and my code
david AT gibson.dropbear.id.au	| minimalist, thank you.  NOT _the_ _other_
				| _way_ _around_!
http://www.ozlabs.org/~dgibson

--yqSnmJuJEfpVkol+
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEdfRlhq5hpmzETofcbDjKyiDZs5IFAmFnvvEACgkQbDjKyiDZ
s5Klnw/+LwB1ZX7cilbD1febQTg36WiCbtZJYQYs6KgI10I8omcDnltCppdJDejN
8wo0M6cE+7lfXmtWs0amn1FFt+dlCr34htN5695HAH5G++WpRNCiFGpbMwu9oz67
XMeSylngf19m34qnVzrjgeKIEEvVOqI7S/CCMBh0iuM3UAry9TvxkDupppYUDP0u
TYFTETu5VfYyL68RfBjOdU4CFe8+k6XQzXu4gwpYkBxLWEhV63qyS77hXnWZBj12
6dQ3j3KwVJ3BnEXCh9op3iExD231zblX9zukstgxhXPVfLEMhRhMaKnIjjwmT95a
OPCFCqMHLUItBtBeIlc+O+rBXN6ywokSNZc3RNI+rLSs47V+PFW/a/bgTDxTOnKL
1Urv1GTfzuISUVZjn8JTrz81iew7LLXsKFisj9vyZtSFMlhU+Q1GTjBXYBUBGDFr
4JPW42uttcw8/GNGWeiX6tonnVhyneO+suiW+AGzrjDuYqvsw8yIiVNR+UKe8jPI
CI3kvSycu2R3JcDQ54ynzvwgT59Rt2YJkparBySyq5n6WvgFTtgm52daRve2XLDn
CUKdS8ajgzhm4ib36yiWe2KM9lGC/izFE5sy5xkT0LIr0Pwt/TJ8g7Wa7YoLztvP
6V2lwyOwb9fzU3Olv8EHEPAo1Ze6BVKLOXvelQ5fIJBRgQ0B00M=
=NemI
-----END PGP SIGNATURE-----

--yqSnmJuJEfpVkol+--
