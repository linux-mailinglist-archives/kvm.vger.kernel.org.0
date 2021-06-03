Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F2CF4399AAC
	for <lists+kvm@lfdr.de>; Thu,  3 Jun 2021 08:28:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229885AbhFCGaK (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 3 Jun 2021 02:30:10 -0400
Received: from bilbo.ozlabs.org ([203.11.71.1]:41555 "EHLO ozlabs.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229818AbhFCGaI (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 3 Jun 2021 02:30:08 -0400
Received: by ozlabs.org (Postfix, from userid 1007)
        id 4FwbYy6DNyz9sWF; Thu,  3 Jun 2021 16:28:22 +1000 (AEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
        d=gibson.dropbear.id.au; s=201602; t=1622701702;
        bh=aDuwQw7JrOoWOZBdQAxjHc0hPzIrNB9PMwrjph0YmcE=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=dKNw6CKpKiVdxCeJpQ2DPorhkr+EONZiqYqYZqC8QIAFzxeywisBFGPqJ/edk+09f
         cWjm2rFfdwfk2GX0nalZfUYRHjrrrPJ8ZjLmiotFQdHSc6E6Xd4Q5cvTT046PLbFuI
         V474o5BtKuIKa7tr6mqAot0YgGYf0J+3y3B+P3bg=
Date:   Thu, 3 Jun 2021 15:48:23 +1000
From:   David Gibson <david@gibson.dropbear.id.au>
To:     "Tian, Kevin" <kevin.tian@intel.com>
Cc:     Jason Gunthorpe <jgg@nvidia.com>,
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
Message-ID: <YLhtJ5tg5TD/9ewj@yekko>
References: <MWHPR11MB1886422D4839B372C6AB245F8C239@MWHPR11MB1886.namprd11.prod.outlook.com>
 <20210528195839.GO1002214@nvidia.com>
 <YLcpw5Kx61L7TVmR@yekko>
 <20210602165838.GA1002214@nvidia.com>
 <MWHPR11MB1886A746307BD6E16FCBC3418C3C9@MWHPR11MB1886.namprd11.prod.outlook.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="3SygcrTGvz8uv5oi"
Content-Disposition: inline
In-Reply-To: <MWHPR11MB1886A746307BD6E16FCBC3418C3C9@MWHPR11MB1886.namprd11.prod.outlook.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


--3SygcrTGvz8uv5oi
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Jun 03, 2021 at 02:49:56AM +0000, Tian, Kevin wrote:
> > From: Jason Gunthorpe <jgg@nvidia.com>
> > Sent: Thursday, June 3, 2021 12:59 AM
> >=20
> > On Wed, Jun 02, 2021 at 04:48:35PM +1000, David Gibson wrote:
> > > > > 	/* Bind guest I/O page table  */
> > > > > 	bind_data =3D {
> > > > > 		.ioasid	=3D gva_ioasid;
> > > > > 		.addr	=3D gva_pgtable1;
> > > > > 		// and format information
> > > > > 	};
> > > > > 	ioctl(ioasid_fd, IOASID_BIND_PGTABLE, &bind_data);
> > > >
> > > > Again I do wonder if this should just be part of alloc_ioasid. Is
> > > > there any reason to split these things? The only advantage to the
> > > > split is the device is known, but the device shouldn't impact
> > > > anything..
> > >
> > > I'm pretty sure the device(s) could matter, although they probably
> > > won't usually.
> >=20
> > It is a bit subtle, but the /dev/iommu fd itself is connected to the
> > devices first. This prevents wildly incompatible devices from being
> > joined together, and allows some "get info" to report the capability
> > union of all devices if we want to do that.
>=20
> I would expect the capability reported per-device via /dev/iommu.=20
> Incompatible devices can bind to the same fd but cannot attach to
> the same IOASID. This allows incompatible devices to share locked
> page accounting.

Yeah... I'm not convinced that everything relevant here can be
reported per-device.  I think we may have edge cases where
combinations of devices have restrictions that individual devices in
the set do not.

--=20
David Gibson			| I'll have my music baroque, and my code
david AT gibson.dropbear.id.au	| minimalist, thank you.  NOT _the_ _other_
				| _way_ _around_!
http://www.ozlabs.org/~dgibson

--3SygcrTGvz8uv5oi
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEdfRlhq5hpmzETofcbDjKyiDZs5IFAmC4bScACgkQbDjKyiDZ
s5LHWA//XLNAmCjZXhhflQU9dr/nQ8aAcicFwWhaZzX2v+8YuOCWt1u2b9O2Qtnd
fYOr3khb983eHexf5jwEIVgf7OzbcbsywHB2m6Y+o8940ybteoDeK9GXINp1B0Tx
q7GB4VtU3LhIumTZaiml1glDQPmZOtvntLTCQhAY9ynT8+GctbJTVf47dxi3aRff
xpTSrkyO3pwlXSQMpjiSP7uuYI4OZ28A9v5C/fvvKjYAiWV5oKoJvMbY91E9uKwF
vRV9vUOnq9XU+p9laziHzHVowiaq4wWmSP+DAqehdp4h/B78oT9xKxvd8/+tIopp
NOOjhmqwlYOHB7HZgP3nK2A1gzNlFMzo7nCUBTYpdSB+aZMCfmLKhihoY45wKswk
bV7mFju9KjvhIe7nby8KFI4UossQANvvQxtMShXl11h/2Vh8gXCeG7gm6/F0QuGc
SPa4PPjWH+lb72aFu7wH8AxzVEezof2gsKyyYhKgxgFaXtI8V4DYhHBk84W3Xy+S
op8M3AOGzk+tPGz5FUeIwqkvZYQaQVP5AbhroUilAaI7OaQ/qmxPupi02b4AV3oR
yhOOINsW1r+EvGRZzsD5utY1XLTQTeEuXdi2ydhojMsCXrZa2r8Ed2HWDS0Wh+yV
Xf7prWcJhkicS2LUH/l1Ras21cl2lCYOkZab+GAQJX/xhitcRm4=
=fgPw
-----END PGP SIGNATURE-----

--3SygcrTGvz8uv5oi--
