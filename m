Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 08F273982ED
	for <lists+kvm@lfdr.de>; Wed,  2 Jun 2021 09:29:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231663AbhFBHbD (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 2 Jun 2021 03:31:03 -0400
Received: from bilbo.ozlabs.org ([203.11.71.1]:37319 "EHLO ozlabs.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231480AbhFBHbA (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 2 Jun 2021 03:31:00 -0400
Received: by ozlabs.org (Postfix, from userid 1007)
        id 4Fw0yh3X6mz9sVb; Wed,  2 Jun 2021 17:29:16 +1000 (AEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
        d=gibson.dropbear.id.au; s=201602; t=1622618956;
        bh=fjBj8PRTLF5KDwaLcn9aAOU++MBjXNfeiCyAkMaW3Ag=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Z6CS9wi3Osfai3DhrzeU4984e1Da0ZUcR5rLzfNFxtCeqynzeaTIhFbh/7QEZGAS8
         t3kHkF+5OYj581MKnYDWSbt+aqlk7j1IOHj/33PliumMl3R0PZ86z+woiS98olm5W/
         mMZL0mIj0lBLdHgsWroftN+GVi0Pf6DrOd4A2iJE=
Date:   Wed, 2 Jun 2021 16:57:52 +1000
From:   David Gibson <david@gibson.dropbear.id.au>
To:     Jason Gunthorpe <jgg@nvidia.com>
Cc:     "Tian, Kevin" <kevin.tian@intel.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Joerg Roedel <joro@8bytes.org>,
        Lu Baolu <baolu.lu@linux.intel.com>,
        David Woodhouse <dwmw2@infradead.org>,
        "iommu@lists.linux-foundation.org" <iommu@lists.linux-foundation.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "Alex Williamson (alex.williamson@redhat.com)" 
        <alex.williamson@redhat.com>, Jason Wang <jasowang@redhat.com>,
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
Message-ID: <YLcr8B7EPDCejlWZ@yekko>
References: <MWHPR11MB1886422D4839B372C6AB245F8C239@MWHPR11MB1886.namprd11.prod.outlook.com>
 <20210528195839.GO1002214@nvidia.com>
 <MWHPR11MB1886A17F36CF744857C531148C3E9@MWHPR11MB1886.namprd11.prod.outlook.com>
 <20210601175643.GQ1002214@nvidia.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="fYHZ/urV5RbW7aYp"
Content-Disposition: inline
In-Reply-To: <20210601175643.GQ1002214@nvidia.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


--fYHZ/urV5RbW7aYp
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Jun 01, 2021 at 02:56:43PM -0300, Jason Gunthorpe wrote:
> On Tue, Jun 01, 2021 at 08:38:00AM +0000, Tian, Kevin wrote:
> > > From: Jason Gunthorpe <jgg@nvidia.com>
> > > Sent: Saturday, May 29, 2021 3:59 AM
> > >=20
> > > On Thu, May 27, 2021 at 07:58:12AM +0000, Tian, Kevin wrote:
> > > >
> > > > 5. Use Cases and Flows
> > > >
> > > > Here assume VFIO will support a new model where every bound device
> > > > is explicitly listed under /dev/vfio thus a device fd can be acquir=
ed w/o
> > > > going through legacy container/group interface. For illustration pu=
rpose
> > > > those devices are just called dev[1...N]:
> > > >
> > > > 	device_fd[1...N] =3D open("/dev/vfio/devices/dev[1...N]", mode);
> > > >
> > > > As explained earlier, one IOASID fd is sufficient for all intended =
use cases:
> > > >
> > > > 	ioasid_fd =3D open("/dev/ioasid", mode);
> > > >
> > > > For simplicity below examples are all made for the virtualization s=
tory.
> > > > They are representative and could be easily adapted to a non-virtua=
lization
> > > > scenario.
> > >=20
> > > For others, I don't think this is *strictly* necessary, we can
> > > probably still get to the device_fd using the group_fd and fit in
> > > /dev/ioasid. It does make the rest of this more readable though.
> >=20
> > Jason, want to confirm here. Per earlier discussion we remain an
> > impression that you want VFIO to be a pure device driver thus
> > container/group are used only for legacy application.
>=20
> Let me call this a "nice wish".
>=20
> If you get to a point where you hard need this, then identify the hard
> requirement and let's do it, but I wouldn't bloat this already large
> project unnecessarily.
>=20
> Similarly I wouldn't depend on the group fd existing in this design
> so it could be changed later.

I don't think presence or absence of a group fd makes a lot of
difference to this design.  Having a group fd just means we attach
groups to the ioasid instead of individual devices, and we no longer
need the bookkeeping of "partial" devices.

> > From this comment are you suggesting that VFIO can still keep
> > container/ group concepts and user just deprecates the use of vfio
> > iommu uAPI (e.g. VFIO_SET_IOMMU) by using /dev/ioasid (which has a
> > simple policy that an IOASID will reject cmd if partially-attached
> > group exists)?
>=20
> I would say no on the container. /dev/ioasid =3D=3D the container, having
> two competing objects at once in a single process is just a mess.

Right.  I'd assume that for compatibility, creating a container would
create a single IOASID under the hood with a compatiblity layer
translating the container operations to iosaid operations.

> If the group fd can be kept requires charting a path through the
> ioctls where the container is not used and /dev/ioasid is sub'd in
> using the same device FD specific IOCTLs you show here.

Again, I don't think it makes much difference.  The model doesn't
really change even if you allow both ATTACH_GROUP and ATTACH_DEVICE on
the IOASID.  Basically ATTACH_GROUP would just be equivalent to
attaching all the constituent devices.

> I didn't try to chart this out carefully.
>=20
> Also, ultimately, something need to be done about compatability with
> the vfio container fd. It looks clear enough to me that the the VFIO
> container FD is just a single IOASID using a special ioctl interface
> so it would be quite rasonable to harmonize these somehow.
>=20
> But that is too complicated and far out for me at least to guess on at
> this point..
>=20
> > > Still a little unsure why the vPASID is here not on the gva_ioasid. Is
> > > there any scenario where we want different vpasid's for the same
> > > IOASID? I guess it is OK like this. Hum.
> >=20
> > Yes, it's completely sane that the guest links a I/O page table to=20
> > different vpasids on dev1 and dev2. The IOMMU doesn't mandate
> > that when multiple devices share an I/O page table they must use
> > the same PASID#.=20
>=20
> Ok..
>=20
> Jason
>=20

--=20
David Gibson			| I'll have my music baroque, and my code
david AT gibson.dropbear.id.au	| minimalist, thank you.  NOT _the_ _other_
				| _way_ _around_!
http://www.ozlabs.org/~dgibson

--fYHZ/urV5RbW7aYp
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEdfRlhq5hpmzETofcbDjKyiDZs5IFAmC3K/AACgkQbDjKyiDZ
s5L/aRAAl5MdgT6Qfp8L0FSuJM4hyAWp5EatxJgBSzaVAbqXESHHMUXl8AN/nsDW
KsgexDRZXSFelArNl5MN0dbxk1gjFZUQHea+cVb89ym9hEF+WKW+COb1wOBCl3A1
aHM3sXc3A9TCbfFLUysEJ+yHyDisNhvt7qwxw3qLnrqgHTZvTFIpQVCzD+XoB0mp
e6aQC9uN99cCf1+ZGCHaVHbx1Ym4NtJEPxetSWe/k5dVKi89lmtujlW1pWt58AL/
sN8pzcMMlaXIw5ImB23JB9ohNCm5F0lfyuXgxeK5/Cc88D/2d+E1Q7r68lj2aVIr
+bInhy44ZzB+fBK/dDzpD0WdoxXHsZXhAch2bWwK61ovSfoWBqzTAHOJZOFb+rRn
Yt69xgJNUVNe1ll4ksrlmQdUNB7CsZJIr+csmGRhByrW+84JMlBvTlZNDXzfB3z4
S2mtVZU7QwVX3zNzyfvLaZKl5vRlWvf7YiuUaN0c9WtnZgKOhLrLpiM0rI6LJNEn
V2gkaEOQJhpEVXLym4EX3vRgU08bF2gsvSSAL4gDqwrDtv/MUGCWLokbeiOZ0kte
Ewi4+bNTmi9JwGUhhMriTbkFOccil5OTDQwRCx6YR1++2Rtf0G+R90pzQXNudled
S89lwkKtFtdxQ+jhTbbAOvMfyrHi8Fp2FXQs5yubhwFYHIXVuHU=
=hCaa
-----END PGP SIGNATURE-----

--fYHZ/urV5RbW7aYp--
