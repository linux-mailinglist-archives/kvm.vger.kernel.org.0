Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 734853AAD5C
	for <lists+kvm@lfdr.de>; Thu, 17 Jun 2021 09:22:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230268AbhFQHYY (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 17 Jun 2021 03:24:24 -0400
Received: from ozlabs.org ([203.11.71.1]:51963 "EHLO ozlabs.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230152AbhFQHYS (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 17 Jun 2021 03:24:18 -0400
Received: by ozlabs.org (Postfix, from userid 1007)
        id 4G5D5X1pwnz9sfG; Thu, 17 Jun 2021 17:22:07 +1000 (AEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
        d=gibson.dropbear.id.au; s=201602; t=1623914528;
        bh=STE+d2uTnkvdb42HamLd+MfBt9F8tUHB2UkclaEK7v8=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=PNq/C0LPf1BgWwCaRdZtEEDQVl7d9At1bLkWjoJSrAw0T6UF3ViXg5+mvjNwQ+9jv
         /wp0Y+Dn/tG5KfQf+IhgjPpwuW/selVgFMdz4WuREir4QoCn1+fymt+nnDNkpARVWN
         IjcHbdRMrkybcDavtdz1q58To3+VDiUMf6jHogDU=
Date:   Thu, 17 Jun 2021 15:22:53 +1000
From:   David Gibson <david@gibson.dropbear.id.au>
To:     Lu Baolu <baolu.lu@linux.intel.com>
Cc:     Jason Gunthorpe <jgg@nvidia.com>, Joerg Roedel <joro@8bytes.org>,
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
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: Plan for /dev/ioasid RFC v2
Message-ID: <YMrcLcTL+cUKd1a5@yekko>
References: <MWHPR11MB188699D0B9C10EB51686C4138C389@MWHPR11MB1886.namprd11.prod.outlook.com>
 <YMCy48Xnt/aphfh3@8bytes.org>
 <20210609123919.GA1002214@nvidia.com>
 <14d884a8-13bc-b2ba-7020-94b219e3e2d9@linux.intel.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="Qg4Qzsx5xFwMhlcX"
Content-Disposition: inline
In-Reply-To: <14d884a8-13bc-b2ba-7020-94b219e3e2d9@linux.intel.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


--Qg4Qzsx5xFwMhlcX
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Jun 10, 2021 at 01:50:22PM +0800, Lu Baolu wrote:
> On 6/9/21 8:39 PM, Jason Gunthorpe wrote:
> > On Wed, Jun 09, 2021 at 02:24:03PM +0200, Joerg Roedel wrote:
> > > On Mon, Jun 07, 2021 at 02:58:18AM +0000, Tian, Kevin wrote:
> > > > -   Device-centric (Jason) vs. group-centric (David) uAPI. David is=
 not fully
> > > >      convinced yet. Based on discussion v2 will continue to have io=
asid uAPI
> > > >      being device-centric (but it's fine for vfio to be group-centr=
ic). A new
> > > >      section will be added to elaborate this part;
> > > I would vote for group-centric here. Or do the reasons for which VFIO=
 is
> > > group-centric not apply to IOASID? If so, why?
> > VFIO being group centric has made it very ugly/difficult to inject
> > device driver specific knowledge into the scheme.
> >=20
> > The device driver is the only thing that knows to ask:
> >   - I need a SW table for this ioasid because I am like a mdev
> >   - I will issue TLPs with PASID
> >   - I need a IOASID linked to a PASID
> >   - I am a devices that uses ENQCMD and vPASID
> >   - etc in future
> >=20
> > The current approach has the group try to guess the device driver
> > intention in the vfio type 1 code.
> >=20
> > I want to see this be clean and have the device driver directly tell
> > the iommu layer what kind of DMA it plans to do, and thus how it needs
> > the IOMMU and IOASID configured.
> >=20
> > This is the source of the ugly symbol_get and the very, very hacky 'if
> > you are a mdev*and*  a iommu then you must want a single PASID' stuff
> > in type1.
> >=20
> > The group is causing all this mess because the group knows nothing
> > about what the device drivers contained in the group actually want.
> >=20
> > Further being group centric eliminates the possibility of working in
> > cases like !ACS. How do I use PASID functionality of a device behind a
> > !ACS switch if the uAPI forces all IOASID's to be linked to a group,
> > not a device?
> >=20
> > Device centric with an report that "all devices in the group must use
> > the same IOASID" covers all the new functionality, keep the old, and
> > has a better chance to keep going as a uAPI into the future.
>=20
> The iommu_group can guarantee the isolation among different physical
> devices (represented by RIDs). But when it comes to sub-devices (ex. mdev=
 or
> vDPA devices represented by RID + SSID), we have to rely on the
> device driver for isolation. The devices which are able to generate sub-
> devices should either use their own on-device mechanisms or use the
> platform features like Intel Scalable IOV to isolate the sub-devices.

This seems like a misunderstanding of groups.  Groups are not tied to
any PCI meaning.  Groups are the smallest unit of isolation, no matter
what is providing that isolation.

If mdevs are isolated from each other by clever software, even though
they're on the same PCI device they are in different groups from each
other *by definition*.  They are also in a different group from their
parent device (however the mdevs only exist when mdev driver is
active, which implies that the parent device's group is owned by the
kernel).

> Under above conditions, different sub-device from a same RID device
> could be able to use different IOASID. This seems to means that we can't
> support mixed mode where, for example, two RIDs share an iommu_group and
> one (or both) of them have sub-devices.

That doesn't necessarily follow.  mdevs which can be successfully
isolated by their mdev driver are in a different group from their
parent device, and therefore need not be affected by whether the
parent device shares a group with some other physical device.  They
*might* be, but that's up to the mdev driver to determine based on
what it can safely isolate.

> AIUI, when we attach a "RID + SSID" to an IOASID, we should require that
> the RID doesn't share the iommu_group with any other RID.
>=20
> Best regards,
> baolu
>=20

--=20
David Gibson			| I'll have my music baroque, and my code
david AT gibson.dropbear.id.au	| minimalist, thank you.  NOT _the_ _other_
				| _way_ _around_!
http://www.ozlabs.org/~dgibson

--Qg4Qzsx5xFwMhlcX
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEdfRlhq5hpmzETofcbDjKyiDZs5IFAmDK3CsACgkQbDjKyiDZ
s5IlrBAAwxFTrL8LAB2uQXstokS55+p2jxYUo/fOIk5+cfRY6geiV+GbzkG/xTod
k7QlN4g8dKSVLrHUnsqisNjAgO3y82Xedjs65Z1NzK2H+d1NUEZWvshZiraj/UkJ
9oAiDT7Vjso/HVTChuBOG/XpKvWCLVw/hjUB50msuwGcujvyjC8Wjg55t4hEJ+rE
2oV+hyxthPMIT3a/bxBbLegwXDJUCSZaDF7HzhHmbxUmMA6CxijfFHN3gJUE9NTk
Ilknrr5hDeDZOxjWhs9Fe3eRiD3dI75X8t33HGbFX5WM1tlz+6AGauoWBDoRYqGW
4LmrhHiNDLP2aS83/UKEoa2euTcjqS0vFzm0DhIpBBCrtX6W7mXOzJxBCBC6B8m/
HuwNVtA1R3NWmKOojtBoYXPouAecAvyeRW1QFPXzzSnoiQ8QEQW/p7lnusfIKIM1
2x2c4cL3pHpDspHY+juuDWK4Y7iM8RKRyvEHdfdXK2k1PDBhNsa8Jteo+gdXtIMO
SqXGCZjHV4d6RWfMUplc+4BJbVIJVzU7QB5j3fSNd2DYUSRS4LTpbP4RaA2jESJ0
aW9kXhCq1DazqnP6gTA5LDgRYWOT9VBOpCw51keQmQqehsvg/0v1mM6HV8IPnAf3
UyurYxCaU3lApcGqNOxk+hLdU7Fcd9B0WVMgKl3eqgMLxHFbxaE=
=X5QH
-----END PGP SIGNATURE-----

--Qg4Qzsx5xFwMhlcX--
