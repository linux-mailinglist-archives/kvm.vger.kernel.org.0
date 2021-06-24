Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 885A13B268D
	for <lists+kvm@lfdr.de>; Thu, 24 Jun 2021 06:53:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230299AbhFXEy5 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 24 Jun 2021 00:54:57 -0400
Received: from ozlabs.org ([203.11.71.1]:39663 "EHLO ozlabs.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229813AbhFXEyt (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 24 Jun 2021 00:54:49 -0400
Received: by ozlabs.org (Postfix, from userid 1007)
        id 4G9SRT1z33z9sf9; Thu, 24 Jun 2021 14:52:21 +1000 (AEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
        d=gibson.dropbear.id.au; s=201602; t=1624510341;
        bh=gtNqfON2b+uPZ4FFUk66B4cN5cUYbQo0UQOhSPJibRU=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=jACRQu74hhjVKLkBHbKaYa++no5/SpyDDCAmXLWGBqnA2Fk6QNQppmT/jPuootYM6
         nz5PGPPdqUHpyANKEcuRG0xRLh0p5eDHB2pw4NGtnyyxnslef26zVe84l9SgVHRh2s
         jXTKqSjziY1gxL9oUH4FD6j5EeZKTIYHg7jP5La4=
Date:   Thu, 24 Jun 2021 13:55:17 +1000
From:   David Gibson <david@gibson.dropbear.id.au>
To:     "Tian, Kevin" <kevin.tian@intel.com>
Cc:     Jean-Philippe Brucker <jean-philippe@linaro.org>,
        "Alex Williamson (alex.williamson@redhat.com)" 
        <alex.williamson@redhat.com>, "Raj, Ashok" <ashok.raj@intel.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        Jonathan Corbet <corbet@lwn.net>,
        Robin Murphy <robin.murphy@arm.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Kirti Wankhede <kwankhede@nvidia.com>,
        "iommu@lists.linux-foundation.org" <iommu@lists.linux-foundation.org>,
        Jason Gunthorpe <jgg@nvidia.com>,
        "Jiang, Dave" <dave.jiang@intel.com>,
        David Woodhouse <dwmw2@infradead.org>,
        Jason Wang <jasowang@redhat.com>
Subject: Re: [RFC] /dev/ioasid uAPI proposal
Message-ID: <YNQCJfU/G5uwDCSE@yekko>
References: <MWHPR11MB1886422D4839B372C6AB245F8C239@MWHPR11MB1886.namprd11.prod.outlook.com>
 <YLch6zbbYqV4PyVf@yekko>
 <MWHPR11MB188668D220E1BF7360F2A6BE8C3C9@MWHPR11MB1886.namprd11.prod.outlook.com>
 <YMrKksUeNW/PEGPM@yekko>
 <MWHPR11MB188672DF8E0AC2C0D56EF86D8C089@MWHPR11MB1886.namprd11.prod.outlook.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="p3xeV50Hfib5E9x2"
Content-Disposition: inline
In-Reply-To: <MWHPR11MB188672DF8E0AC2C0D56EF86D8C089@MWHPR11MB1886.namprd11.prod.outlook.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


--p3xeV50Hfib5E9x2
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Jun 23, 2021 at 08:00:49AM +0000, Tian, Kevin wrote:
> > From: David Gibson
> > Sent: Thursday, June 17, 2021 12:08 PM
> >=20
> > On Thu, Jun 03, 2021 at 08:12:27AM +0000, Tian, Kevin wrote:
> > > > From: David Gibson <david@gibson.dropbear.id.au>
> > > > Sent: Wednesday, June 2, 2021 2:15 PM
> > > >
> > > [...]
> > >
> > > > >
> > > > > /*
> > > > >   * Get information about an I/O address space
> > > > >   *
> > > > >   * Supported capabilities:
> > > > >   *	- VFIO type1 map/unmap;
> > > > >   *	- pgtable/pasid_table binding
> > > > >   *	- hardware nesting vs. software nesting;
> > > > >   *	- ...
> > > > >   *
> > > > >   * Related attributes:
> > > > >   * 	- supported page sizes, reserved IOVA ranges (DMA
> > mapping);
> > > >
> > > > Can I request we represent this in terms of permitted IOVA ranges,
> > > > rather than reserved IOVA ranges.  This works better with the "wind=
ow"
> > > > model I have in mind for unifying the restrictions of the POWER IOM=
MU
> > > > with Type1 like mapping.
> > >
> > > Can you elaborate how permitted range work better here?
> >=20
> > Pretty much just that MAP operations would fail if they don't entirely
> > lie within a permitted range.  So, for example if your IOMMU only
> > implements say, 45 bits of IOVA, then you'd have 0..0x1fffffffffff as
> > your only permitted range.  If, like the POWER paravirtual IOMMU (in
> > defaut configuration) you have a small (1G) 32-bit range and a large
> > (45-bit) 64-bit range at a high address, you'd have say:
> > 	0x00000000..0x3fffffff (32-bit range)
> > and
> > 	0x800000000000000 .. 0x8001fffffffffff (64-bit range)
> > as your permitted ranges.
> >=20
> > If your IOMMU supports truly full 64-bit addressing, but has a
> > reserved range (for MSIs or whatever) at 0xaaaa000..0xbbbb0000 then
> > you'd have permitted ranges of 0..0xaaa9ffff and
> > 0xbbbb0000..0xffffffffffffffff.
>=20
> I see. Has incorporated this comment in v2.
>=20
> >=20
> > [snip]
> > > > For debugging and certain hypervisor edge cases it might be useful =
to
> > > > have a call to allow userspace to lookup and specific IOVA in a gue=
st
> > > > managed pgtable.
> > >
> > > Since all the mapping metadata is from userspace, why would one
> > > rely on the kernel to provide such service? Or are you simply asking
> > > for some debugfs node to dump the I/O page table for a given
> > > IOASID?
> >=20
> > I'm thinking of this as a debugging aid so you can make sure that how
> > the kernel is interpreting that metadata in the same way that your
> > userspace expects it to interpret that metadata.
> >=20
>=20
> I'll not include it in this RFC. There are already too many stuff. The
> debugging aid can be added anyway when it's actually required.

Fair enough.

--=20
David Gibson			| I'll have my music baroque, and my code
david AT gibson.dropbear.id.au	| minimalist, thank you.  NOT _the_ _other_
				| _way_ _around_!
http://www.ozlabs.org/~dgibson

--p3xeV50Hfib5E9x2
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEdfRlhq5hpmzETofcbDjKyiDZs5IFAmDUAiUACgkQbDjKyiDZ
s5JCJA//d6pXwX9h3dUB9R3TtYglCzE5E3WU1J/RJ2hPYPSn1FwmUqC/d+pCcBzz
0S/8iAD90q2/Ng8z2o/6bb6Tqd85xB892OT32V3QBh+NI4AGPP3qP5oD5lLdGQnI
uCv7s6VkPK5kPZ0rM1C2WTHI07dFMZWLcS0BqBaxXBXF2IkSbqU/2lhNTqyZzOih
TpQNsnXyjyU/IpgugqYfsKgUtWG6g/sKqv1mNOcybEeLbCJx0iFfxJRZz/snJzZo
5VKSP8DOU0Rb53jJo0mAprcCVOd0xUViuoMd1S3SoRjeyY1NFx6A5IxjgyZRWWiS
LWMqsyr9mLSoQ8jLd7DZ+tSjbreP1uQxuvuEpTdOUvoqNdTTYRJW3bwlT8KgduMP
0xGD1FMwbsdg5MkeelGWaiM+pJdEmX/qf5RuWMKm/lUMP6tceG9TJhwLbmv54uDt
nwVtVS/p05hbYdpF3iLfoyGf3Sn8m+qN/x12tX6dAgBpb6xNqRwt7OahBZJ0BFXF
akWb3aclIeeo77zyMxcAz5KcA5XCHlhwagPdEFe40G4mGBQ7kUSx5BduEruB87kC
eGzHy/XzL+9LVF10FQ27FR4wXQifjafgJ0ois5wZOzY2GiauK9Efkop1jZQV6KiU
m0uZtPlFOjfSXLMp6Z9dmaYa74oyLJvF+9ArZwxTpBa4DgHcT5E=
=R3gb
-----END PGP SIGNATURE-----

--p3xeV50Hfib5E9x2--
