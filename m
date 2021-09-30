Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E166441D22E
	for <lists+kvm@lfdr.de>; Thu, 30 Sep 2021 06:20:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347821AbhI3EVL (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 30 Sep 2021 00:21:11 -0400
Received: from gandalf.ozlabs.org ([150.107.74.76]:54841 "EHLO
        gandalf.ozlabs.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229643AbhI3EVI (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 30 Sep 2021 00:21:08 -0400
Received: by gandalf.ozlabs.org (Postfix, from userid 1007)
        id 4HKg4C5Nqkz4xbP; Thu, 30 Sep 2021 14:19:23 +1000 (AEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gibson.dropbear.id.au; s=201602; t=1632975563;
        bh=i+RGI9rpio1f9EZOmFMgvr+f89K9pwqzCrMlLiqEWBg=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=FbzFOHv16oDoZtnbVQYUyMRvyDXQI4YLsyG2XKZ4GrxAck6W71yAIVJFYOehjs+qB
         UywCjtC94TblKHh3y31F2/hjtyR4oATlOKO9szyQaP9PhU2/dwKL9A1g3JbQaRx/yq
         oyD0eqiKWeP7fVkfKKmGwMCmedhCm3cxV9fjxrJE=
Date:   Thu, 30 Sep 2021 13:09:22 +1000
From:   David Gibson <david@gibson.dropbear.id.au>
To:     Jason Gunthorpe <jgg@nvidia.com>
Cc:     "Tian, Kevin" <kevin.tian@intel.com>,
        "Liu, Yi L" <yi.l.liu@intel.com>,
        "alex.williamson@redhat.com" <alex.williamson@redhat.com>,
        "hch@lst.de" <hch@lst.de>,
        "jasowang@redhat.com" <jasowang@redhat.com>,
        "joro@8bytes.org" <joro@8bytes.org>,
        "jean-philippe@linaro.org" <jean-philippe@linaro.org>,
        "parav@mellanox.com" <parav@mellanox.com>,
        "lkml@metux.net" <lkml@metux.net>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "lushenming@huawei.com" <lushenming@huawei.com>,
        "eric.auger@redhat.com" <eric.auger@redhat.com>,
        "corbet@lwn.net" <corbet@lwn.net>,
        "Raj, Ashok" <ashok.raj@intel.com>,
        "yi.l.liu@linux.intel.com" <yi.l.liu@linux.intel.com>,
        "Tian, Jun J" <jun.j.tian@intel.com>, "Wu, Hao" <hao.wu@intel.com>,
        "Jiang, Dave" <dave.jiang@intel.com>,
        "jacob.jun.pan@linux.intel.com" <jacob.jun.pan@linux.intel.com>,
        "kwankhede@nvidia.com" <kwankhede@nvidia.com>,
        "robin.murphy@arm.com" <robin.murphy@arm.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "iommu@lists.linux-foundation.org" <iommu@lists.linux-foundation.org>,
        "dwmw2@infradead.org" <dwmw2@infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "baolu.lu@linux.intel.com" <baolu.lu@linux.intel.com>,
        "nicolinc@nvidia.com" <nicolinc@nvidia.com>
Subject: Re: [RFC 06/20] iommu: Add iommu_device_init[exit]_user_dma
 interfaces
Message-ID: <YVUqYsJTMkt1nnXL@yekko>
References: <20210919063848.1476776-1-yi.l.liu@intel.com>
 <20210919063848.1476776-7-yi.l.liu@intel.com>
 <YVPxzad5TYHAc1H/@yekko>
 <BN9PR11MB5433E1BF538C7D3632F4C6188CA99@BN9PR11MB5433.namprd11.prod.outlook.com>
 <YVQJJ/ZlRoJbAt0+@yekko>
 <20210929125716.GT964074@nvidia.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="Mv1ylZtgq547n0AU"
Content-Disposition: inline
In-Reply-To: <20210929125716.GT964074@nvidia.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


--Mv1ylZtgq547n0AU
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Sep 29, 2021 at 09:57:16AM -0300, Jason Gunthorpe wrote:
> On Wed, Sep 29, 2021 at 04:35:19PM +1000, David Gibson wrote:
>=20
> > Yes, exactly.  And with a group interface it's obvious it has to
> > understand it.  With the non-group interface, you can get to this
> > stage in ignorance of groups.  It will even work as long as you are
> > lucky enough only to try with singleton-group devices.  Then you try
> > it with two devices in the one group and doing (3) on device A will
> > implicitly change the DMA environment of device B.
>=20
> The security model here says this is fine.

I'm not making a statement about the security model, I'm making a
statement about surprisingness of the programming interface.  In your
program you have devices A & B, you perform an operation that
specifies only device A and device B changes behaviour.

> This idea to put the iommu code in charge of security is quite clean,
> as I said in the other mail drivers attached to 'struct devices *'
> tell the iommu layer what they are are doing:
>=20
>    iommu_set_device_dma_owner(dev, DMA_OWNER_KERNEL, NULL)
>    iommu_set_device_dma_owner(dev, DMA_OWNER_SHARED, NULL)
>    iommu_set_device_dma_owner(dev, DMA_OWNER_USERSPACE, group_file/iommu_=
file)
>=20
> And it decides if it is allowed.
>=20
> If device A is allowed to go to userspace then security wise it is
> deemed fine that B is impacted. That is what we have defined already
> today.
>=20
> This proposal does not free userpace from having to understand this!
> The iommu_group sysfs is still there and still must be understood.
>=20
> The *admin* the one responsible to understand the groups, not the
> applications. The admin has no idea what a group FD is - they should
> be looking at the sysfs and seeing the iommu_group directories.

Not just the admin.  If an app is given two devices in the same group
to use *both* it must understand that and act accordingly.

--=20
David Gibson			| I'll have my music baroque, and my code
david AT gibson.dropbear.id.au	| minimalist, thank you.  NOT _the_ _other_
				| _way_ _around_!
http://www.ozlabs.org/~dgibson

--Mv1ylZtgq547n0AU
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEdfRlhq5hpmzETofcbDjKyiDZs5IFAmFVKmIACgkQbDjKyiDZ
s5K5XBAAqrZ2Hc8P6SOxVMykfq+JWNlN1rOjaPhyyjJHdRNUSOoguO93Ywjx5dzN
FBqEQMxLqdE2vmw/OgQAcvjCKjKcNXP2OjhZThJtU9U2YGPJYqxbPL12n++FQ5f9
pYcNBQMeIrpv1Of+fCgd680kvHw+El/oK4LMz9p4K9d/Hy6kyZLyHbsAfM3RZx4m
+sSHKEglvAqtJfVqr14Ovl8xTywy7LjZowINxkf7HDPvTbfUM2L2UlZ290mb48Im
zImL5gVBESiXnjGrcxL8vel9KjYGI4MU+Qy7J2TZEgB78Mack2y3pLw3kIBYBwiZ
JAAUxO2lTLISY9jbtvg3GekiSCxEbHhwIv8CxB6ojsuLz93UEDsvfodRp/Mske6K
YrFF/GylnRnYYs3gj9EBYnAP7CJ/WqDfrYDoYIH7yWVIRjJvhIz1Xf6yvK+F7Le4
ffJHrGeoJhmzSPnAPWfIchie+E0uD7KaJUqDBvIUwFFLtNvlHnc8Ca2u+EM4qho/
O8gZIWeeiExfBrwchyyVWnXRL6N6LGp7YGkP7aYq8d09EtK8BnKVgjfNzd0vnF6j
ONMT6xNiL0scHdLrpv06m8dAZ3PRTMB7cVds4oiTzPTxecZLl0LzeOoypT+qZ/cG
XHlxswnKS6Ba2MjM5Qi7pPhwPhZtk/wzH7mI8D3Zsd22cBaWzlI=
=RiYv
-----END PGP SIGNATURE-----

--Mv1ylZtgq547n0AU--
