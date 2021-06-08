Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B4D5C39EF0B
	for <lists+kvm@lfdr.de>; Tue,  8 Jun 2021 08:54:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230389AbhFHG4e (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 8 Jun 2021 02:56:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43256 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230324AbhFHG43 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 8 Jun 2021 02:56:29 -0400
Received: from ozlabs.org (ozlabs.org [IPv6:2401:3900:2:1::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ED341C061795;
        Mon,  7 Jun 2021 23:54:36 -0700 (PDT)
Received: by ozlabs.org (Postfix, from userid 1007)
        id 4Fzgvs1lpfz9s5R; Tue,  8 Jun 2021 16:54:33 +1000 (AEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
        d=gibson.dropbear.id.au; s=201602; t=1623135273;
        bh=l+542s68FYtLIf55CdSwqHV1l4dLW1vCSkh7RGkVPCs=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=JXtAOc30bFKcr5H8BAuJnug2WX/xvOI7rzD80il7H1427ZIB2iszE43P8Yooi6ONY
         ek5ZNSmqe9TGTe/ngcMV5XWcUYrVKL4BxOzJTE4xdx+FBaG6ejPvUT/gidM+2t+AoV
         xrpbEPd/b1LOq+06nJ4knPGJkNIc6GjalFHkGAOg=
Date:   Tue, 8 Jun 2021 16:04:26 +1000
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
Message-ID: <YL8Iam4+cog7oVDa@yekko>
References: <MWHPR11MB1886422D4839B372C6AB245F8C239@MWHPR11MB1886.namprd11.prod.outlook.com>
 <20210528195839.GO1002214@nvidia.com>
 <MWHPR11MB1886A17F36CF744857C531148C3E9@MWHPR11MB1886.namprd11.prod.outlook.com>
 <20210601175643.GQ1002214@nvidia.com>
 <YLcr8B7EPDCejlWZ@yekko>
 <20210602163753.GZ1002214@nvidia.com>
 <YLhnRbJJqPUBiRwa@yekko>
 <20210603122832.GS1002214@nvidia.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="4VGf9ivCxwiJX0fs"
Content-Disposition: inline
In-Reply-To: <20210603122832.GS1002214@nvidia.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


--4VGf9ivCxwiJX0fs
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Jun 03, 2021 at 09:28:32AM -0300, Jason Gunthorpe wrote:
> On Thu, Jun 03, 2021 at 03:23:17PM +1000, David Gibson wrote:
> > On Wed, Jun 02, 2021 at 01:37:53PM -0300, Jason Gunthorpe wrote:
> > > On Wed, Jun 02, 2021 at 04:57:52PM +1000, David Gibson wrote:
> > >=20
> > > > I don't think presence or absence of a group fd makes a lot of
> > > > difference to this design.  Having a group fd just means we attach
> > > > groups to the ioasid instead of individual devices, and we no longer
> > > > need the bookkeeping of "partial" devices.
> > >=20
> > > Oh, I think we really don't want to attach the group to an ioasid, or
> > > at least not as a first-class idea.
> > >=20
> > > The fundamental problem that got us here is we now live in a world
> > > where there are many ways to attach a device to an IOASID:
> >=20
> > I'm not seeing that that's necessarily a problem.
> >=20
> > >  - A RID binding
> > >  - A RID,PASID binding
> > >  - A RID,PASID binding for ENQCMD
> >=20
> > I have to admit I haven't fully grasped the differences between these
> > modes.  I'm hoping we can consolidate at least some of them into the
> > same sort of binding onto different IOASIDs (which may be linked in
> > parent/child relationships).
>=20
> What I would like is that the /dev/iommu side managing the IOASID
> doesn't really care much, but the device driver has to tell
> drivers/iommu what it is going to do when it attaches.

By the device driver, do you mean the userspace or guest device
driver?  Or do you mean the vfio_pci or mdev "shim" device driver"?

> It makes sense, in PCI terms, only the driver knows what TLPs the
> device will generate. The IOMMU needs to know what TLPs it will
> recieve to configure properly.
>=20
> PASID or not is major device specific variation, as is the ENQCMD/etc
>=20
> Having the device be explicit when it tells the IOMMU what it is going
> to be sending is a major plus to me. I actually don't want to see this
> part of the interface be made less strong.

Ok, if I'm understanding this right a PASID capable IOMMU will be able
to process *both* transactions with just a RID and transactions with a
RID+PASID.

So if we're thinking of this notional 84ish-bit address space, then
that includes "no PASID" as well as all the possible PASID values.
Yes?  Or am I confused?

>=20
> > > The selection of which mode to use is based on the specific
> > > driver/device operation. Ie the thing that implements the 'struct
> > > vfio_device' is the thing that has to select the binding mode.
> >=20
> > I thought userspace selected the binding mode - although not all modes
> > will be possible for all devices.
>=20
> /dev/iommu is concerned with setting up the IOAS and filling the IO
> page tables with information
>=20
> The driver behind "struct vfio_device" is responsible to "route" its
> HW into that IOAS.
>=20
> They are two halfs of the problem, one is only the io page table, and one
> the is connection of a PCI TLP to a specific io page table.
>=20
> Only the driver knows what format of TLPs the device will generate so
> only the driver can specify the "route"

Ok.  I'd really like if we can encode this in a way that doesn't build
PCI-specific structure into the API, though.

> =20
> > > eg if two PCI devices are in a group then it is perfectly fine that
> > > one device uses RID binding and the other device uses RID,PASID
> > > binding.
> >=20
> > Uhhhh... I don't see how that can be.  They could well be in the same
> > group because their RIDs cannot be distinguished from each other.
>=20
> Inability to match the RID is rare, certainly I would expect any IOMMU
> HW that can do PCIEe PASID matching can also do RID matching.

It's not just up to the IOMMU.  The obvious case is a PCIe-to-PCI
bridge.  All transactions show the RID of the bridge, because vanilla
PCI doesn't have them.  Same situation with a buggy multifunction
device which uses function 0's RID for all functions.

It may be rare, but we still have to deal with it one way or another.

I really don't think we want to support multiple binding types for a
single group.

> With
> such HW the above is perfectly fine - the group may not be secure
> between members (eg !ACS), but the TLPs still carry valid RIDs and
> PASID and the IOMMU can still discriminate.

They carry RIDs, whether they're valid depends on how buggy your
hardware is.

> I think you are talking about really old IOMMU's that could only
> isolate based on ingress port or something.. I suppose modern PCIe has
> some cases like this in the NTB stuff too.

Depends what you mean by really old.  They may seem really old to
those working on new fancy IOMMU technology.  But I hit problems in
practice not long ago with awkwardly multi-device groups because it
was on a particular Dell server without ACS implementation.  Likewise
I strongly suspect non-PASID IOMMUs will remain common on low end
hardware (like peoples' laptops) for some time.

> Oh, I hadn't spent time thinking about any of those.. It is messy but
> it can still be forced to work, I guess. A device centric model means
> all the devices using the same routing ID have to be connected to the
> same IOASID by userspace. So some of the connections will be NOPs.

See, that's exactly what I thought the group checks were enforcing.
I'm really hoping we don't need two levels of granularity here: groups
of devices that can't be identified from each other, and then groups
of those that can't be isolated from each other.  That introduces a
huge amount of extra conceptual complexity.

--=20
David Gibson			| I'll have my music baroque, and my code
david AT gibson.dropbear.id.au	| minimalist, thank you.  NOT _the_ _other_
				| _way_ _around_!
http://www.ozlabs.org/~dgibson

--4VGf9ivCxwiJX0fs
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEdfRlhq5hpmzETofcbDjKyiDZs5IFAmC/CGgACgkQbDjKyiDZ
s5JMCBAAlYAbFNYbeY8IPBsKKj4Jp7ze0Qfle6wVzSAXKBio81llZffxvTZe012f
sJ9/N4tEJn6VpxG3bKMJXhAa6msKbF+OLHGLOqxOQB+nnNORZ/RCTNIV5llr13dI
wCs4Kvl9CbbYY9omogJz4P8WqJNunLBAr+Nngy5FEDZ3zV8ujWM7kMjlGWsl6Jxx
wz2YDQSz2yZ1z9kSdmqMt0hvPdj/msyh6KmbcdQIboKeMphvL7OXMuQGnbLCdTKS
RMUUh0Ui4RMJ857fGfk8tm+5Ctnb1lHOW7/FhSgRMCtBdT8w2cKq7Y8wMn0RmSk7
HMhyEYsYbYVyOmGUAXduvmBxkn0WhG7YpP6ktVB1kfaTXOKJ1lU+NkZdWQNuual0
zeNMZHg3JUNIYvKVy2KgkwLIdnNhMHa6AaaYgqhv9B+ihFNWQLXHhCW48om/2LN1
UG51A1eruOE7m4D7lIW3DdxaqcIxeFbUs9hAzT1hvK9pq+CcoFHjkgP0r0jCKZB8
0fVq7HMjUeaOu8ygDOH30go/vIFJ9QvCnOqVwxAgP0zh1mFp/cpWSaTzw+WCBSwt
p5r9LpFcZLQHwtJ8nJvDoz6jlaw2apzt8KPSNVxlHlPcRrRrsY5sZuW2z41yIiSC
5I3VOlaDy86+6sVsxMf1oucPg+IddFD5GnMGbD0ILlzXjdTKOwI=
=o2DZ
-----END PGP SIGNATURE-----

--4VGf9ivCxwiJX0fs--
