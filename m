Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0A7FE39EBF3
	for <lists+kvm@lfdr.de>; Tue,  8 Jun 2021 04:26:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230233AbhFHC1t (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 7 Jun 2021 22:27:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41210 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231524AbhFHC1s (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 7 Jun 2021 22:27:48 -0400
Received: from ozlabs.org (ozlabs.org [IPv6:2401:3900:2:1::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B982EC061574;
        Mon,  7 Jun 2021 19:25:56 -0700 (PDT)
Received: by ozlabs.org (Postfix, from userid 1007)
        id 4FzYxm6L3yz9sW8; Tue,  8 Jun 2021 12:25:48 +1000 (AEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
        d=gibson.dropbear.id.au; s=201602; t=1623119148;
        bh=lncYIbxArPowV0MRkDFVxKOswtaRzRtG9W2xdghAx6E=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Fl9N/rY051u/vXA8Hw32d6pExmLKI3N41TquwdbFFNmvj4ancl24Wkx4HSWiolM+/
         pT1F2q/2VhF59OyNxNlXSpAEqFIyRsYMFMf4P3aALG2JOQUSOwl3st8G4JX8vKfRtM
         3qtkRUSTv9gMnqY1vA6bx6Z+lDdwhUTBcM8bIE8I=
Date:   Tue, 8 Jun 2021 10:53:02 +1000
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
Message-ID: <YL6/bjHyuHJTn4Rd@yekko>
References: <MWHPR11MB1886422D4839B372C6AB245F8C239@MWHPR11MB1886.namprd11.prod.outlook.com>
 <20210528173538.GA3816344@nvidia.com>
 <YLcl+zaK6Y0gB54a@yekko>
 <20210602161648.GY1002214@nvidia.com>
 <YLhlCINGPGob4Nld@yekko>
 <20210603115224.GQ1002214@nvidia.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="g5xwcfR2A+2YrJL6"
Content-Disposition: inline
In-Reply-To: <20210603115224.GQ1002214@nvidia.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


--g5xwcfR2A+2YrJL6
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Jun 03, 2021 at 08:52:24AM -0300, Jason Gunthorpe wrote:
> On Thu, Jun 03, 2021 at 03:13:44PM +1000, David Gibson wrote:
>=20
> > > We can still consider it a single "address space" from the IOMMU
> > > perspective. What has happened is that the address table is not just a
> > > 64 bit IOVA, but an extended ~80 bit IOVA formed by "PASID, IOVA".
> >=20
> > True.  This does complexify how we represent what IOVA ranges are
> > valid, though.  I'll bet you most implementations don't actually
> > implement a full 64-bit IOVA, which means we effectively have a large
> > number of windows from (0..max IOVA) for each valid pasid.  This adds
> > another reason I don't think my concept of IOVA windows is just a
> > power specific thing.
>=20
> Yes
>=20
> Things rapidly get into weird hardware specific stuff though, the
> request will be for things like:
>   "ARM PASID&IO page table format from SMMU IP block vXX"

So, I'm happy enough for picking a user-managed pagetable format to
imply the set of valid IOVA ranges (though a query might be nice).

I'm mostly thinking of representing (and/or choosing) valid IOVA
ranges as something for the kernel-managed pagetable style
(MAP/UNMAP).

> Which may have a bunch of (possibly very weird!) format specific data
> to describe and/or configure it.
>=20
> The uAPI needs to be suitably general here. :(
>=20
> > > If we are already going in the direction of having the IOASID specify
> > > the page table format and other details, specifying that the page
> > > tabnle format is the 80 bit "PASID, IOVA" format is a fairly small
> > > step.
> >=20
> > Well, rather I think userspace needs to request what page table format
> > it wants and the kernel tells it whether it can oblige or not.
>=20
> Yes, this is what I ment.
>=20
> Jason
>=20

--=20
David Gibson			| I'll have my music baroque, and my code
david AT gibson.dropbear.id.au	| minimalist, thank you.  NOT _the_ _other_
				| _way_ _around_!
http://www.ozlabs.org/~dgibson

--g5xwcfR2A+2YrJL6
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEdfRlhq5hpmzETofcbDjKyiDZs5IFAmC+v24ACgkQbDjKyiDZ
s5Khrg/+O8Zfek3/FbN5ebI8tszXAHZwV5BjxM1PNWD6PIjlBfD/7OG7REO2l9w9
6idpUCjPhg6/3wuCDpPfqgD5xvhKwyW05VrcVUWhKbmMNXZ47iBRkOpeBY99JoIl
IVJeoRMXRwtdHGem7WKJfrg2KZl7uoFDMB5oxswwukVPfVCema7SGEsjnXXCaeQU
oUnl8usFPedPUgf04GUlN4mMOQccOiLcg3B6SxytX/yWY+aal0M3XGcWVIT61vOS
2FEcYxwn1qcZOYMcmqyanLxaAo+8fQ7fSeacF6c5mPG1JJWfdn4J3PCn3Ot8Jz3x
GPvUm2V79AEu8OyEYLGbGnnEY44TaYho40gaoW67Oq3c5vw/jfxKiTDHQ0sZGcE5
/Zx7zjw3XbSDogbyG2EYmZK0peVNPcu1UhWXRYMnC6C2KFWDZnxrJLO8/qNNpIHd
CQXpnEVj8LX5aU4bpg3bTWiidYQ2Ifb+VEyDrJ6NouWwPySDO5Dwv/JySPz8gHbl
4tmiWz1ZdHoTEY1pSrirzPI1S0OY+5n0S5xXFeRayOFdE+3PZ4a5Mn+FEIIh4ynE
SYygZh5LM5KuCjLbT1LO7/bUsCWpNBe9yP0C4kTi6rUVvh4nWq7vO9qpxtMeoVyv
Cd809jz15Cs2A89v65hLgF4MsgFKLxApFx/yXUkp6b27l6gw8Hc=
=2eQJ
-----END PGP SIGNATURE-----

--g5xwcfR2A+2YrJL6--
