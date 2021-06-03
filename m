Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E856D399AB2
	for <lists+kvm@lfdr.de>; Thu,  3 Jun 2021 08:28:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229957AbhFCGaP (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 3 Jun 2021 02:30:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51228 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229884AbhFCGaK (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 3 Jun 2021 02:30:10 -0400
Received: from ozlabs.org (ozlabs.org [IPv6:2401:3900:2:1::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4DEA4C061756;
        Wed,  2 Jun 2021 23:28:26 -0700 (PDT)
Received: by ozlabs.org (Postfix, from userid 1007)
        id 4FwbYy71WNz9sXL; Thu,  3 Jun 2021 16:28:22 +1000 (AEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
        d=gibson.dropbear.id.au; s=201602; t=1622701702;
        bh=cTwVnIFTZKt9mDLUFydsyzbNUUaTjzx27s1g2jtwlGE=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=OXJffrQW11S12kndAx7p9k3y4f5O4FtOyPV8J0fuXBCL4hyEJTVYjvAimlktJ2yMz
         UcZAAzo6eIw8Zk1+Luhzl3tSsjZ/2uRSreKspdMFxw2sLjJKyCz+tFpz3uIESF606K
         LskCQb9aCbom1pr+8x3UR2W6C1cNW68J9Az4r1aw=
Date:   Thu, 3 Jun 2021 16:26:08 +1000
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
Message-ID: <YLh2APcZFpDoqOKG@yekko>
References: <MWHPR11MB1886422D4839B372C6AB245F8C239@MWHPR11MB1886.namprd11.prod.outlook.com>
 <YLch6zbbYqV4PyVf@yekko>
 <20210602171930.GB1002214@nvidia.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="FAcR9kiyfl4RJ44h"
Content-Disposition: inline
In-Reply-To: <20210602171930.GB1002214@nvidia.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


--FAcR9kiyfl4RJ44h
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Jun 02, 2021 at 02:19:30PM -0300, Jason Gunthorpe wrote:
> On Wed, Jun 02, 2021 at 04:15:07PM +1000, David Gibson wrote:
>=20
> > Is there a compelling reason to have all the IOASIDs handled by one
> > FD?
>=20
> There was an answer on this, if every PASID needs an IOASID then there
> are too many FDs.

Too many in what regard?  fd limits?  Something else?

It seems to be there are two different cases for PASID handling here.
One is where userspace explicitly creates each valid PASID and
attaches a separate pagetable for each (or handles each with
MAP/UNMAP).  In that case I wouldn't have expected there to be too
many fds.

Then there's the case where we register a whole PASID table, in which
case I think you only need the one FD.  We can treat that as creating
an 84-bit IOAS, whose pagetable format is (PASID table + a bunch of
pagetables for each PASID).

> It is difficult to share the get_user_pages cache across FDs.

Ah... hrm, yes I can see that.

> There are global properties in the /dev/iommu FD, like what devices
> are part of it, that are important for group security operations. This
> becomes confused if it is split to many FDs.

I'm still not seeing those.  I'm really not seeing any well-defined
meaning to devices being attached to the fd, but not to a particular
IOAS.

> > > I/O address space can be managed through two protocols, according to=
=20
> > > whether the corresponding I/O page table is constructed by the kernel=
 or=20
> > > the user. When kernel-managed, a dma mapping protocol (similar to=20
> > > existing VFIO iommu type1) is provided for the user to explicitly spe=
cify=20
> > > how the I/O address space is mapped. Otherwise, a different protocol =
is=20
> > > provided for the user to bind an user-managed I/O page table to the=
=20
> > > IOMMU, plus necessary commands for iotlb invalidation and I/O fault=
=20
> > > handling.=20
> > >=20
> > > Pgtable binding protocol can be used only on the child IOASID's, impl=
ying=20
> > > IOASID nesting must be enabled. This is because the kernel doesn't tr=
ust=20
> > > userspace. Nesting allows the kernel to enforce its DMA isolation pol=
icy=20
> > > through the parent IOASID.
> >=20
> > To clarify, I'm guessing that's a restriction of likely practice,
> > rather than a fundamental API restriction.  I can see a couple of
> > theoretical future cases where a user-managed pagetable for a "base"
> > IOASID would be feasible:
> >=20
> >   1) On some fancy future MMU allowing free nesting, where the kernel
> >      would insert an implicit extra layer translating user addresses
> >      to physical addresses, and the userspace manages a pagetable with
> >      its own VAs being the target AS
>=20
> I would model this by having a "SVA" parent IOASID. A "SVA" IOASID one
> where the IOVA =3D=3D process VA and the kernel maintains this mapping.

That makes sense.  Needs a different name to avoid Intel and PCI
specificness, but having a trivial "pagetable format" which just says
IOVA =3D=3D user address is nice idea.

> Since the uAPI is so general I do have a general expecation that the
> drivers/iommu implementations might need to be a bit more complicated,
> like if the HW can optimize certain specific graphs of IOASIDs we
> would still model them as graphs and the HW driver would have to
> "compile" the graph into the optimal hardware.
>=20
> This approach has worked reasonable in other kernel areas.

That seems sensible.

> >   2) For a purely software virtual device, where its virtual DMA
> >      engine can interpet user addresses fine
>=20
> This also sounds like an SVA IOASID.

Ok.

> Depending on HW if a device can really only bind to a very narrow kind
> of IOASID then it should ask for that (probably platform specific!)
> type during its attachment request to drivers/iommu.
>=20
> eg "I am special hardware and only know how to do PLATFORM_BLAH
> transactions, give me an IOASID comatible with that". If the only way
> to create "PLATFORM_BLAH" is with a SVA IOASID because BLAH is
> hardwired to the CPU ASID  then that is just how it is.

Fair enough.

> > I wonder if there's a way to model this using a nested AS rather than
> > requiring special operations.  e.g.
> >=20
> > 	'prereg' IOAS
> > 	|
> > 	\- 'rid' IOAS
> > 	   |
> > 	   \- 'pasid' IOAS (maybe)
> >=20
> > 'prereg' would have a kernel managed pagetable into which (for
> > example) qemu platform code would map all guest memory (using
> > IOASID_MAP_DMA).  qemu's vIOMMU driver would then mirror the guest's
> > IO mappings into the 'rid' IOAS in terms of GPA.
> >=20
> > This wouldn't quite work as is, because the 'prereg' IOAS would have
> > no devices.  But we could potentially have another call to mark an
> > IOAS as a purely "preregistration" or pure virtual IOAS.  Using that
> > would be an alternative to attaching devices.
>=20
> It is one option for sure, this is where I was thinking when we were
> talking in the other thread. I think the decision is best
> implementation driven as the datastructure to store the
> preregsitration data should be rather purpose built.

Right.  I think this gets nicer now that we're considering more
specific options at IOAS creation time, and different "types" of
IOAS.  We could add a "preregistration" IOAS type, which supports
MAP/UNMAP of user addresses, and allows *no* devices to be attached,
but does allow other IOAS types to be added as children.

>=20
> > > /*
> > >   * Map/unmap process virtual addresses to I/O virtual addresses.
> > >   *
> > >   * Provide VFIO type1 equivalent semantics. Start with the same=20
> > >   * restriction e.g. the unmap size should match those used in the=20
> > >   * original mapping call.=20
> > >   *
> > >   * If IOASID_REGISTER_MEMORY has been called, the mapped vaddr
> > >   * must be already in the preregistered list.
> > >   *
> > >   * Input parameters:
> > >   *	- u32 ioasid;
> > >   *	- refer to vfio_iommu_type1_dma_{un}map
> > >   *
> > >   * Return: 0 on success, -errno on failure.
> > >   */
> > > #define IOASID_MAP_DMA	_IO(IOASID_TYPE, IOASID_BASE + 6)
> > > #define IOASID_UNMAP_DMA	_IO(IOASID_TYPE, IOASID_BASE + 7)
> >=20
> > I'm assuming these would be expected to fail if a user managed
> > pagetable has been bound?
>=20
> Me too, or a SVA page table.
>=20
> This document would do well to have a list of imagined page table
> types and the set of operations that act on them. I think they are all
> pretty disjoint..

Right.  With the possible exception that I can imagine a call for
several types which all support MAP/UNMAP, but have other different
characteristics.

> Your presentation of 'kernel owns the table' vs 'userspace owns the
> table' is a useful clarification to call out too
>=20
> > > 5. Use Cases and Flows
> > >=20
> > > Here assume VFIO will support a new model where every bound device
> > > is explicitly listed under /dev/vfio thus a device fd can be acquired=
 w/o=20
> > > going through legacy container/group interface. For illustration purp=
ose
> > > those devices are just called dev[1...N]:
> > >=20
> > > 	device_fd[1...N] =3D open("/dev/vfio/devices/dev[1...N]", mode);
> >=20
> > Minor detail, but I'd suggest /dev/vfio/pci/DDDD:BB:SS.F for the
> > filenames for actual PCI functions.  Maybe /dev/vfio/mdev/something
> > for mdevs.  That leaves other subdirs of /dev/vfio free for future
> > non-PCI device types, and /dev/vfio itself for the legacy group
> > devices.
>=20
> There are a bunch of nice options here if we go this path
>=20
> > > 5.2. Multiple IOASIDs (no nesting)
> > > ++++++++++++++++++++++++++++
> > >=20
> > > Dev1 and dev2 are assigned to the guest. vIOMMU is enabled. Initially
> > > both devices are attached to gpa_ioasid.
> >=20
> > Doesn't really affect your example, but note that the PAPR IOMMU does
> > not have a passthrough mode, so devices will not initially be attached
> > to gpa_ioasid - they will be unusable for DMA until attached to a
> > gIOVA ioasid.
>=20
> I think attachment should always be explicit in the API. If the user
> doesn't explicitly ask for a device to be attached to the IOASID then
> the iommu driver is free to block it.
>=20
> If you want passthrough then you have to create a passthrough IOASID
> and attach every device to it. Some of those attaches might be NOP's
> due to groups.

Agreed.

--=20
David Gibson			| I'll have my music baroque, and my code
david AT gibson.dropbear.id.au	| minimalist, thank you.  NOT _the_ _other_
				| _way_ _around_!
http://www.ozlabs.org/~dgibson

--FAcR9kiyfl4RJ44h
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEdfRlhq5hpmzETofcbDjKyiDZs5IFAmC4dgAACgkQbDjKyiDZ
s5K/jw/9Ht15/kL6FaoswulEdiuVCAgKdvNuVPejylpQTRm13DobP4fblnMQCx32
ioYph9Pw4ZWZTpGOI0mgIaIyUMY9yDVfhzYN2Q+ZqgIBRGkixn0Mwal3thGYWvdf
MJIcRNt6hAHFG9JUn4CaUcDt48nNrTAjp3p09iLNNKdOAs1BQ/AaPoQTQrMTMkJl
W7nWIZJbxgl7/chTwhVy25Tc5/Yf7PvrknCuPeRQ4MtkoDM3Q7yItWjIt3R9gNvK
Fh7rKb0KUOSS2TXgIzGlC951k9c/ZdWTY6+6Dw9+wwXXeq3Ub1zkQQ/yZ8O0jRa5
x+Te7OHCuk+heSCImstELpazPS7CZHfTSYoLuGLeFvu0+ElvSInV2TAHlWyjZ7Q4
0Or6ozRA5A6ZedHkGGp59x64+sY1cRcQ9zEXwhntw23S0ELah3Gmx3i8RQ7Sedes
O4LJ6owbWvdZ3Cr/2hRyJ7Y5YGmVGqB0Pc3VBburnhpleel+aT73twAxDQNzLLvz
8VgelhT9YG938EIw/7imS0Bnd306KYAepjYsWRYO6kUxoQQcHlt5gACvxczJWmyX
Q5axuhpCCEmQFfMKNtulH9pFP54j8ry5KGQRllFTjDzxyUdUmk02pOA/vI5ts/CA
e0puS1gwhbkFn1TNeHHNhOYiBUvHNJAyRLy81Z7mS6vUYBkymqQ=
=Oa53
-----END PGP SIGNATURE-----

--FAcR9kiyfl4RJ44h--
