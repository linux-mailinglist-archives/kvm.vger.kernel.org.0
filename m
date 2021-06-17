Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A2C083AAD5F
	for <lists+kvm@lfdr.de>; Thu, 17 Jun 2021 09:22:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230484AbhFQHY3 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 17 Jun 2021 03:24:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52614 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230331AbhFQHYY (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 17 Jun 2021 03:24:24 -0400
Received: from ozlabs.org (ozlabs.org [IPv6:2401:3900:2:1::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7BC54C061574;
        Thu, 17 Jun 2021 00:22:16 -0700 (PDT)
Received: by ozlabs.org (Postfix, from userid 1007)
        id 4G5D5W75dmz9sXN; Thu, 17 Jun 2021 17:22:07 +1000 (AEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
        d=gibson.dropbear.id.au; s=201602; t=1623914528;
        bh=qHt4cdZnk75miSfGS18ZGHebQR5ivhD/A2lqaj41G0w=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=MFBPTGRFEVaNTvvFvlTgUWKwEc4kQPWOSalxsFmlF/dxovJu6UNpgXh06qmieAtla
         aTOsdeIpcRXrYzZ4M5ZysP3isWxuYVwSRue2XMxKO51w62GFXvTty/W2z2NR4Vc26v
         kGEdyjdkfH3HSbrNihVHLK5CK8XMgkoT3Stmj2Ig=
Date:   Thu, 17 Jun 2021 14:45:46 +1000
From:   David Gibson <david@gibson.dropbear.id.au>
To:     Jason Gunthorpe <jgg@nvidia.com>
Cc:     Joerg Roedel <joro@8bytes.org>,
        "Tian, Kevin" <kevin.tian@intel.com>,
        "Alex Williamson (alex.williamson@redhat.com)" 
        <alex.williamson@redhat.com>,
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
Message-ID: <YMrTeuUoqgzmSplL@yekko>
References: <MWHPR11MB188699D0B9C10EB51686C4138C389@MWHPR11MB1886.namprd11.prod.outlook.com>
 <YMCy48Xnt/aphfh3@8bytes.org>
 <20210609123919.GA1002214@nvidia.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="dBV3Ysu62aAbOUva"
Content-Disposition: inline
In-Reply-To: <20210609123919.GA1002214@nvidia.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


--dBV3Ysu62aAbOUva
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Jun 09, 2021 at 09:39:19AM -0300, Jason Gunthorpe wrote:
> On Wed, Jun 09, 2021 at 02:24:03PM +0200, Joerg Roedel wrote:
> > On Mon, Jun 07, 2021 at 02:58:18AM +0000, Tian, Kevin wrote:
> > > -   Device-centric (Jason) vs. group-centric (David) uAPI. David is n=
ot fully
> > >     convinced yet. Based on discussion v2 will continue to have ioasi=
d uAPI
> > >     being device-centric (but it's fine for vfio to be group-centric)=
=2E A new
> > >     section will be added to elaborate this part;
> >=20
> > I would vote for group-centric here. Or do the reasons for which VFIO is
> > group-centric not apply to IOASID? If so, why?
>=20
> VFIO being group centric has made it very ugly/difficult to inject
> device driver specific knowledge into the scheme.
>=20
> The device driver is the only thing that knows to ask:
>  - I need a SW table for this ioasid because I am like a mdev
>  - I will issue TLPs with PASID
>  - I need a IOASID linked to a PASID
>  - I am a devices that uses ENQCMD and vPASID
>  - etc in future

mdev drivers might know these, but shim drivers, like basic vfio-pci
often won't.  In that case only the userspace driver will know that
for certain.  The shim driver at best has a fairly loose bound on what
the userspace driver *could* do.

I still think you're having a tendency to partially conflate several
meanings of "group":
	1. the unavoidable hardware unit of non-isolation
	2. the kernel internal concept and interface to it
	3. the user visible fd and interface

We can't avoid having (1) somewhere, (3) and to a lesser extent (2)
are what you object to.

> The current approach has the group try to guess the device driver
> intention in the vfio type 1 code.

I agree this has gotten ugly.  What I'm not yet convinced of is that
reworking groups to make this not-ugly necessarily requires totally
minimizing the importance of groups.

> I want to see this be clean and have the device driver directly tell
> the iommu layer what kind of DMA it plans to do, and thus how it needs
> the IOMMU and IOASID configured.

>=20
> This is the source of the ugly symbol_get and the very, very hacky 'if
> you are a mdev *and* a iommu then you must want a single PASID' stuff
> in type1.
>=20
> The group is causing all this mess because the group knows nothing
> about what the device drivers contained in the group actually want.
>=20
> Further being group centric eliminates the possibility of working in
> cases like !ACS. How do I use PASID functionality of a device behind a
> !ACS switch if the uAPI forces all IOASID's to be linked to a group,
> not a device?
>=20
> Device centric with an report that "all devices in the group must use
> the same IOASID" covers all the new functionality, keep the old, and
> has a better chance to keep going as a uAPI into the future.
>=20
> Jason
>=20

--=20
David Gibson			| I'll have my music baroque, and my code
david AT gibson.dropbear.id.au	| minimalist, thank you.  NOT _the_ _other_
				| _way_ _around_!
http://www.ozlabs.org/~dgibson

--dBV3Ysu62aAbOUva
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEdfRlhq5hpmzETofcbDjKyiDZs5IFAmDK03gACgkQbDjKyiDZ
s5IDihAArTAIG0ZjpRdzkGG1oSy/yIILv/6kpvhvO41K7EWs7BoSD9wHWgKmNdOV
Z1/Wy1C+nITlY0c8Lfv94BziM+8f32AaoTbfekmzKYDcGHmZuBKmyLcHOulLsx78
OccGNfd4gFe9AsX7wMonxhTQEAjxGQOyqU+Fx1vnyUmhxypHx7iXdGosY+u1RaiN
uCNO0uHvslaEym/g11x1gTE02wAmd3eKpdl/Mdt9gMOB9Jq8kjr4inZf3NEOrPly
epHoghD1te2rQl5XZxJ/N9qrzofbpFuXwEfTBJyprctpFPF69iDK4i3txfb7JY6b
jFmwFSspVn2uzwmIW30dTvNDxwWqaIC+oHrzkYwGPF5Zc9NNRZdTbtJjbVafJTWr
eNnP4QzlRtlI/zcYQcvlnHgawL3O2w+MUvNWv9g8kxtFCbuqY1wMjcKIBle6ac/O
5Ln3MtAe2ZjwtRsmbsQL97XkjGaBtbNJHTtlBaJtY4x4fdND5CRvsOaPp/Nx0uLL
j8t+cr4WiBT7HP/68Ap0HZBqMWDjupyH30yWHDL4cWEIpSwFKb6Kwn8joGTLqhXS
BCXjR5EakXCp6fTkrtYOMqWRXp0dNpdLhsVphrMpzXyIB8wYtb2yRQlNW517/ccz
PDrwJgsax16LJkiIhq+5yGMzbUtiYOhvpU7B4KSQNn7d5y69Sn0=
=xxEr
-----END PGP SIGNATURE-----

--dBV3Ysu62aAbOUva--
