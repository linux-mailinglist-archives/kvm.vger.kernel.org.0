Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D777F3B2689
	for <lists+kvm@lfdr.de>; Thu, 24 Jun 2021 06:53:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230159AbhFXEyx (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 24 Jun 2021 00:54:53 -0400
Received: from bilbo.ozlabs.org ([203.11.71.1]:39533 "EHLO ozlabs.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229723AbhFXEyt (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 24 Jun 2021 00:54:49 -0400
Received: by ozlabs.org (Postfix, from userid 1007)
        id 4G9SRT2HPNz9sjD; Thu, 24 Jun 2021 14:52:21 +1000 (AEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
        d=gibson.dropbear.id.au; s=201602; t=1624510341;
        bh=BdMsr801TLRg6n1agXO9W99Z9X2Ycr8wu5/qVxtFlo0=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=l/K+SERQX3av85LdONGF5HU3qIWVLog4ZRIrV/rgiI+Ikw4O+mOlGq7sl6zA7Z8m6
         lUgnfpUAdkOH1esnooHfRbWjWNRpnByhKJ4IVoLyKm1h4mmwDN04FGwKWES3DQEt2V
         ffqwCEjaXTnzhHSqjrMWrSoXkKSpxj1Ss22nCr5A=
Date:   Thu, 24 Jun 2021 13:53:48 +1000
From:   David Gibson <david@gibson.dropbear.id.au>
To:     "Tian, Kevin" <kevin.tian@intel.com>
Cc:     Jason Gunthorpe <jgg@nvidia.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Joerg Roedel <joro@8bytes.org>,
        Lu Baolu <baolu.lu@linux.intel.com>,
        David Woodhouse <dwmw2@infradead.org>,
        "iommu@lists.linux-foundation.org" <iommu@lists.linux-foundation.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        Jason Wang <jasowang@redhat.com>,
        Eric Auger <eric.auger@redhat.com>,
        Jonathan Corbet <corbet@lwn.net>,
        "Raj, Ashok" <ashok.raj@intel.com>,
        "Liu, Yi L" <yi.l.liu@intel.com>, "Wu, Hao" <hao.wu@intel.com>,
        "Jiang, Dave" <dave.jiang@intel.com>,
        Jacob Pan <jacob.jun.pan@linux.intel.com>,
        Jean-Philippe Brucker <jean-philippe@linaro.org>,
        Kirti Wankhede <kwankhede@nvidia.com>,
        Robin Murphy <robin.murphy@arm.com>
Subject: Re: [RFC] /dev/ioasid uAPI proposal
Message-ID: <YNQBzCbWAJj4HZaQ@yekko>
References: <MWHPR11MB1886422D4839B372C6AB245F8C239@MWHPR11MB1886.namprd11.prod.outlook.com>
 <20210528200311.GP1002214@nvidia.com>
 <MWHPR11MB188685D57653827B566BF9B38C3E9@MWHPR11MB1886.namprd11.prod.outlook.com>
 <20210601162225.259923bc.alex.williamson@redhat.com>
 <YL7X0FKj+r6lIHQZ@yekko>
 <20210608131756.GF1002214@nvidia.com>
 <YMrF2BV0goTIPbrN@yekko>
 <MWHPR11MB188626BD4B67FB00EFD008ED8C089@MWHPR11MB1886.namprd11.prod.outlook.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="gCWd0fTYw+m8JsSq"
Content-Disposition: inline
In-Reply-To: <MWHPR11MB188626BD4B67FB00EFD008ED8C089@MWHPR11MB1886.namprd11.prod.outlook.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


--gCWd0fTYw+m8JsSq
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Jun 23, 2021 at 07:59:21AM +0000, Tian, Kevin wrote:
> > From: David Gibson <david@gibson.dropbear.id.au>
> > Sent: Thursday, June 17, 2021 11:48 AM
> >=20
> > On Tue, Jun 08, 2021 at 10:17:56AM -0300, Jason Gunthorpe wrote:
> > > On Tue, Jun 08, 2021 at 12:37:04PM +1000, David Gibson wrote:
> > >
> > > > > The PPC/SPAPR support allows KVM to associate a vfio group to an
> > IOMMU
> > > > > page table so that it can handle iotlb programming from pre-regis=
tered
> > > > > memory without trapping out to userspace.
> > > >
> > > > To clarify that's a guest side logical vIOMMU page table which is
> > > > partially managed by KVM.  This is an optimization - things can work
> > > > without it, but it means guest iomap/unmap becomes a hot path becau=
se
> > > > each map/unmap hypercall has to go
> > > > 	guest -> KVM -> qemu -> VFIO
> > > >
> > > > So there are multiple context transitions.
> > >
> > > Isn't this overhead true of many of the vIOMMUs?
> >=20
> > Yes, but historically it bit much harder on POWER for a couple of reaso=
ns:
> >=20
> > 1) POWER guests *always* have a vIOMMU - the platform has no concept
> >    of passthrough mode.  We therefore had a vIOMMU implementation some
> >    time before the AMD or Intel IOMMUs were implemented as vIOMMUs in
> >    qemu.
> >=20
> > 2) At the time we were implementing this the supported IOVA window for
> >    the paravirtualized IOMMU was pretty small (1G, I think) making
> >    vIOMMU maps and unmaps a pretty common operation.
> >=20
> > > Can the fast path be
> > > generalized?
> >=20
> > Not really.  This is a paravirtualized guest IOMMU, so it's a platform
> > specific group of hypercalls that's being interpreted by KVM and
> > passed through to the IOMMU side using essentially the same backend
> > that that the userspace implementation would eventually get to after a
> > bunch more context switches.
> >=20
>=20
> Can virtio-iommu work on PPC? iirc Jean has a plan to implement
> a vhost-iommu which is supposed to implement the similar in-kernel
> acceleration...

I don't know - I'd have to research virtio-iommu a bunch to determine
that.

Even if we can, the platform IOMMU would still be there (it's a
platform requirement), so we couldn't completely ignore it.

--=20
David Gibson			| I'll have my music baroque, and my code
david AT gibson.dropbear.id.au	| minimalist, thank you.  NOT _the_ _other_
				| _way_ _around_!
http://www.ozlabs.org/~dgibson

--gCWd0fTYw+m8JsSq
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEdfRlhq5hpmzETofcbDjKyiDZs5IFAmDUAcwACgkQbDjKyiDZ
s5KfnRAAwW5fhc16eIczBASYEIkpgZQeK/OLxT7fNHcgkkw9kt7Qa0fLXfsomQgF
Nf3E2pDkzkwaTnvH/ubj7nghSy5cgda5ng8G87HMccVlcFE+8x2Z/9CSqw8tsoCG
MYDc0d2qQ8+Bz3+JvCluzGXcgrMTB1NoJpEX6rl6rk8s1sQuF/vF5z2eSg8Hqui9
NoxtlbfybModgNUSBD2ebUfFFbxGlUOBHpPqPG0zL/nrjPIMZKzWRnJD6qsCe1aT
VBahBFktcwxsdQL8TeN0lWCw2pJ92vho4ryFvGb6+o8VvqpBGGNknPee6zGtBaQ9
Fy4mx7afACusbxJDIMCjS4OifB21P9lh7kGGQFVU5kOr5f+qfXiqZEL+YW+9F2Y2
wy/naoJBiNT7KlDzLgHbjZOH/Z/6pDyUWeHzPU6p/ho398jtQYSWPTTcS36uLxMP
ABdS356rO8U7FTjGE+sQbyzRrnaS+JGVF8PyDV2sNHetyvNwyfeybfYnH9aWlg+x
SrqIRKj6FLrUDxSrldunAOU89dAseeF8geueErh3z0x6sm8xnnB9osDPpgz09ewb
zlbKh8NP33pO+C5592S+kPxf1HCnjKIXdCy9BMndt7zzw3lBKuEr/c+INwsixNfR
/GJRZJvOAh4G8Kms2NQbE8ArNbdSzSFmHoSVqWdWbJck15dGiMg=
=+vXD
-----END PGP SIGNATURE-----

--gCWd0fTYw+m8JsSq--
