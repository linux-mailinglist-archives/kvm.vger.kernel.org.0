Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 967EB39EBE9
	for <lists+kvm@lfdr.de>; Tue,  8 Jun 2021 04:25:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231481AbhFHC1m (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 7 Jun 2021 22:27:42 -0400
Received: from ozlabs.org ([203.11.71.1]:48075 "EHLO ozlabs.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230233AbhFHC1m (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 7 Jun 2021 22:27:42 -0400
Received: by ozlabs.org (Postfix, from userid 1007)
        id 4FzYxm5n40z9sRK; Tue,  8 Jun 2021 12:25:48 +1000 (AEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
        d=gibson.dropbear.id.au; s=201602; t=1623119148;
        bh=rxA81Y8neKOEB5Cc9kisefM4q1thUTdt4CWm4Nfc2Yw=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=mqQDfQu00RfVzGtfTX4DNhpOwyKEuh4+3BuPpAuEQaaigEfRHJ0YKZiEb2L4JHZMU
         nGSyWMI8ikc0MPFbpLIgRTgvQMmRcbl0oY3uYleB8E9LY/GqNVJTxo89kv87GuZa0a
         8u7Qv1p3rtwRcQVht4Y38pf1IFltqs0Vtjlz0v3I=
Date:   Tue, 8 Jun 2021 10:49:56 +1000
From:   David Gibson <david@gibson.dropbear.id.au>
To:     "Tian, Kevin" <kevin.tian@intel.com>
Cc:     Jean-Philippe Brucker <jean-philippe@linaro.org>,
        "Jiang, Dave" <dave.jiang@intel.com>,
        "Raj, Ashok" <ashok.raj@intel.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        Jonathan Corbet <corbet@lwn.net>,
        David Woodhouse <dwmw2@infradead.org>,
        Jason Wang <jasowang@redhat.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Kirti Wankhede <kwankhede@nvidia.com>,
        "Alex Williamson (alex.williamson@redhat.com)" 
        <alex.williamson@redhat.com>,
        "iommu@lists.linux-foundation.org" <iommu@lists.linux-foundation.org>,
        Jason Gunthorpe <jgg@nvidia.com>,
        Robin Murphy <robin.murphy@arm.com>
Subject: Re: [RFC] /dev/ioasid uAPI proposal
Message-ID: <YL6+tBc+Xq7pgb/z@yekko>
References: <MWHPR11MB1886422D4839B372C6AB245F8C239@MWHPR11MB1886.namprd11.prod.outlook.com>
 <20210528173538.GA3816344@nvidia.com>
 <MWHPR11MB18866C362840EA2D45A402188C3E9@MWHPR11MB1886.namprd11.prod.outlook.com>
 <20210601174229.GP1002214@nvidia.com>
 <MWHPR11MB1886283575628D7A2F4BFFAB8C3D9@MWHPR11MB1886.namprd11.prod.outlook.com>
 <20210602160914.GX1002214@nvidia.com>
 <MWHPR11MB18861FA1636BFB66E5E563508C3C9@MWHPR11MB1886.namprd11.prod.outlook.com>
 <YLhj9mi9J/f+rqkP@yekko>
 <MWHPR11MB1886E929BD1414817E9247898C3C9@MWHPR11MB1886.namprd11.prod.outlook.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="lVmKxZwYU6H/NYU5"
Content-Disposition: inline
In-Reply-To: <MWHPR11MB1886E929BD1414817E9247898C3C9@MWHPR11MB1886.namprd11.prod.outlook.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


--lVmKxZwYU6H/NYU5
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Jun 03, 2021 at 06:49:20AM +0000, Tian, Kevin wrote:
> > From: David Gibson
> > Sent: Thursday, June 3, 2021 1:09 PM
> [...]
> > > > In this way the SW mode is the same as a HW mode with an infinite
> > > > cache.
> > > >
> > > > The collaposed shadow page table is really just a cache.
> > > >
> > >
> > > OK. One additional thing is that we may need a 'caching_mode"
> > > thing reported by /dev/ioasid, indicating whether invalidation is
> > > required when changing non-present to present. For hardware
> > > nesting it's not reported as the hardware IOMMU will walk the
> > > guest page table in cases of iotlb miss. For software nesting
> > > caching_mode is reported so the user must issue invalidation
> > > upon any change in guest page table so the kernel can update
> > > the shadow page table timely.
> >=20
> > For the fist cut, I'd have the API assume that invalidates are
> > *always* required.  Some bypass to avoid them in cases where they're
> > not needed can be an additional extension.
> >=20
>=20
> Isn't a typical TLB semantics is that non-present entries are not
> cached thus invalidation is not required when making non-present
> to present?

Usually, but not necessarily.

> It's true to both CPU TLB and IOMMU TLB.

I don't think it's entirely true of the CPU TLB on all ppc MMU models
(of which there are far too many).

> In reality
> I feel there are more usages built on hardware nesting than software
> nesting thus making default following hardware TLB behavior makes
> more sense...

I'm arguing for always-require-invalidate because it's strictly more
general.  Requiring the invalidate will support models that don't
require it in all cases; we just make the invalidate a no-op.  The
reverse is not true, so we should tackle the general case first, then
optimize.

--=20
David Gibson			| I'll have my music baroque, and my code
david AT gibson.dropbear.id.au	| minimalist, thank you.  NOT _the_ _other_
				| _way_ _around_!
http://www.ozlabs.org/~dgibson

--lVmKxZwYU6H/NYU5
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEdfRlhq5hpmzETofcbDjKyiDZs5IFAmC+vrQACgkQbDjKyiDZ
s5IOTQ/+OnKcpdjvyqxaSbBDFwAu0SI4Q+ls/bus20IbeYmALM5ylflnO9Xrgryx
Ph3tOOhR7CrHdjhQ/WzsFmemr1rn3ICex6ZLjiRvEI4EYuWtNkYtwA0R579Vzp3t
11E4tYgyL+my7ti4Z5iHhIeQNtxptI9CAVuAe3RGmvEijy5XBCH3Uz2po9dpoZ58
pgNxE71ugfDasnP1JGvXlNYQHVJ5QDuvDcmRDIK+VoOQbnHDo8aL6KwGfBST0cvi
ZfFj4L5xaLFaAeo4lKxe2inPpdAoHNJEbseKBLauVRI47VZ10SWhk3UHdbd1CBjI
qMWo8S+XUkfFL5WHHYfWu8GU5W57EiP8r/ipNDp/kBvtuRvVE8nzOFkrN+6R57XR
DvtV0rxxzzA3K4lZbfRwx71TPHfuVGC5pdhyppKk47HQcXloAGTXYA8TviXDG7hp
Ff7GnUzDcu4z3L2dl70KbX8vn19DdLF6lgsC2xt0OTI77AetybIzAauu5yq1LocD
EuNwCaJy889iZpquHihGoXjmwPph766/JMECSwJh3Uhg0Yiup6XPhOqg8H7lweBK
6ayA51i4GfukYOPdY3dNDTeh4km8PKl8bxhwHI+uqPf1xWjbUG319+oWLVT0oYSn
EzZrA0KOdA9yGoB5IYD7WfXqIkIUoJBu7PoS+RaC91XPuD5id+w=
=5vgw
-----END PGP SIGNATURE-----

--lVmKxZwYU6H/NYU5--
