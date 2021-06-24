Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DD1DD3B2691
	for <lists+kvm@lfdr.de>; Thu, 24 Jun 2021 06:53:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230379AbhFXEy7 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 24 Jun 2021 00:54:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54738 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230132AbhFXEyv (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 24 Jun 2021 00:54:51 -0400
Received: from ozlabs.org (bilbo.ozlabs.org [IPv6:2401:3900:2:1::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 43708C061574;
        Wed, 23 Jun 2021 21:52:33 -0700 (PDT)
Received: by ozlabs.org (Postfix, from userid 1007)
        id 4G9SRT4pGKz9t0T; Thu, 24 Jun 2021 14:52:21 +1000 (AEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
        d=gibson.dropbear.id.au; s=201602; t=1624510341;
        bh=Y1ZXO4GOKwiZGQOUSkU62M3QSVIF13l7lSRYG/A5sd4=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Ihu3DMzkLAV+wjtqkkh/A0N7zBO2qjXvqPIoL5l26qdg3N4Fpa6+Mg5QnLEYJ36C+
         E8IfzU/O8tDq34n9NEkU4Ui+voj839ng2PR0r2T7a4WXMpZu1iaIyq/8aMRgwfYmkI
         F42I0a7ZNBzG+9PEbFmvHo8VbdxCQQktyxyZcIDM=
Date:   Thu, 24 Jun 2021 14:29:29 +1000
From:   David Gibson <david@gibson.dropbear.id.au>
To:     Jason Gunthorpe <jgg@nvidia.com>
Cc:     Joerg Roedel <joro@8bytes.org>,
        "Tian, Kevin" <kevin.tian@intel.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        Jean-Philippe Brucker <jean-philippe@linaro.org>,
        Jason Wang <jasowang@redhat.com>,
        "parav@mellanox.com" <parav@mellanox.com>,
        "Enrico Weigelt, metux IT consult" <lkml@metux.net>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Shenming Lu <lushenming@huawei.com>,
        Eric Auger <eric.auger@redhat.com>,
        Jonathan Corbet <corbet@lwn.net>,
        "Raj, Ashok" <ashok.raj@intel.com>,
        "Liu, Yi L" <yi.l.liu@intel.com>, "Wu, Hao" <hao.wu@intel.com>,
        "Jiang, Dave" <dave.jiang@intel.com>,
        Jacob Pan <jacob.jun.pan@linux.intel.com>,
        Kirti Wankhede <kwankhede@nvidia.com>,
        Robin Murphy <robin.murphy@arm.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "iommu@lists.linux-foundation.org" <iommu@lists.linux-foundation.org>,
        David Woodhouse <dwmw2@infradead.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Lu Baolu <baolu.lu@linux.intel.com>
Subject: Re: Plan for /dev/ioasid RFC v2
Message-ID: <YNQKKSb3onBCz+f6@yekko>
References: <20210612105711.7ac68c83.alex.williamson@redhat.com>
 <20210614140711.GI1002214@nvidia.com>
 <20210614102814.43ada8df.alex.williamson@redhat.com>
 <MWHPR11MB1886239C82D6B66A732830B88C309@MWHPR11MB1886.namprd11.prod.outlook.com>
 <20210615101215.4ba67c86.alex.williamson@redhat.com>
 <MWHPR11MB188692A6182B1292FADB3BDB8C0F9@MWHPR11MB1886.namprd11.prod.outlook.com>
 <20210616133937.59050e1a.alex.williamson@redhat.com>
 <MWHPR11MB18865DF9C50F295820D038798C0E9@MWHPR11MB1886.namprd11.prod.outlook.com>
 <YMykBzUHmATPbmdV@8bytes.org>
 <20210618151506.GG1002214@nvidia.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="yLEcQ6F0C4xJHQpz"
Content-Disposition: inline
In-Reply-To: <20210618151506.GG1002214@nvidia.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


--yLEcQ6F0C4xJHQpz
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Jun 18, 2021 at 12:15:06PM -0300, Jason Gunthorpe wrote:
> On Fri, Jun 18, 2021 at 03:47:51PM +0200, Joerg Roedel wrote:
> > Hi Kevin,
> >=20
> > On Thu, Jun 17, 2021 at 07:31:03AM +0000, Tian, Kevin wrote:
> > > Now let's talk about the new IOMMU behavior:
> > >=20
> > > -   A device is blocked from doing DMA to any resource outside of
> > >     its group when it's probed by the IOMMU driver. This could be a
> > >     special state w/o attaching to any domain, or a new special domain
> > >     type which differentiates it from existing domain types (identity=
,=20
> > >     dma, or unmanged). Actually existing code already includes a
> > >     IOMMU_DOMAIN_BLOCKED type but nobody uses it.
> >=20
> > There is a reason for the default domain to exist: Devices which require
> > RMRR mappings to be present. You can't just block all DMA from devices
> > until a driver takes over, we put much effort into making sure there is
> > not even a small window in time where RMRR regions (unity mapped regions
> > on AMD) are not mapped.
>=20
> Yes, I think the DMA blocking can only start around/after a VFIO type
> driver has probed() and bound to a device in the group, not much
> different from today.

But as I keep saying, some forms of grouping (and DMA aliasing as Alex
mentioned) mean that changing the domain of one device can change the
domain of another device, unavoidably.  It may be rare with modern
hardware, but we still can't ignore the case.

Which means you can't DMA block until everything in the group is
managed by a vfio-like driver.

--=20
David Gibson			| I'll have my music baroque, and my code
david AT gibson.dropbear.id.au	| minimalist, thank you.  NOT _the_ _other_
				| _way_ _around_!
http://www.ozlabs.org/~dgibson

--yLEcQ6F0C4xJHQpz
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEdfRlhq5hpmzETofcbDjKyiDZs5IFAmDUCikACgkQbDjKyiDZ
s5LTyA//bJpWtaDHUtdmpyHIrjTXkhO/p0T3/Me6MMC2aA3PiMYgq5mOYQ8rJEfX
7kRqkNMRDLOjachD429QvNosQGm8ImsLOK7SRLQeE9BMBYB6IU7G8ig+jpTsRbRT
qmKFuoqWalvFrP9Mct8HLY3SjT/lXke7356q11hjhKMVRWNdmwZSsX6rak8+N+cy
sQI9Y/ZtjJVSYYA8e/FQOSsMW4AnQpDCNCQhDEU0Do6MJ+Epf92C4BiDQnBprrBJ
GuZaoRA3tlUKb1wUYcyG1piE8aAWGUyVNxGR0h7P6CQ9qR1mLugUPEJLwS8J6ZFD
h50XuLB9SD1WynaS3onyvugDSP8EPdnei+nAHQqyOs97zZksy6j+/066OslhEhWw
OIMQbIC+f9WHHBABG7g4g8ZCQUY9jYPvw23gjyWDHuyQtqrCXRUE8O/9kn6fQbBM
0jcZUEyvq5RiSnfnP3+Ja6z0bj6BL83IYkUIrVKJFwY4c19HwTk5cqYqU+lG2PRg
hv212bYgICZXJ4QZBbzqR/1Jc5maQB/tc0LYiyrtc4GagrUOuchgN3T9mmNKe+IV
widXRoL/4ntxuPzZnUhgcOjpHAVxC2wkv3aAfLcRVDTfu7xfU29YW84cSHbCulHK
FZ6zhyeEY818TljNrE8LY6iCyUJqLINRaIC97bqzCvxkquXvQF4=
=pdCD
-----END PGP SIGNATURE-----

--yLEcQ6F0C4xJHQpz--
