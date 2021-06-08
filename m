Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 31E8C39EF0D
	for <lists+kvm@lfdr.de>; Tue,  8 Jun 2021 08:54:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230293AbhFHG4g (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 8 Jun 2021 02:56:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43254 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230323AbhFHG43 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 8 Jun 2021 02:56:29 -0400
Received: from ozlabs.org (bilbo.ozlabs.org [IPv6:2401:3900:2:1::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E131BC06178B;
        Mon,  7 Jun 2021 23:54:36 -0700 (PDT)
Received: by ozlabs.org (Postfix, from userid 1007)
        id 4Fzgvs0xfSz9sW6; Tue,  8 Jun 2021 16:54:33 +1000 (AEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
        d=gibson.dropbear.id.au; s=201602; t=1623135273;
        bh=6XrXYPDJzXROOAXXdd8a889l8o4k0qJLMeKixWa/h/0=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=QnUcTxkPj0P8bQn4t4lMXMTlpj+BS6+QLHtSAxmuZckPqPajgMMpSFAX5Z2hoqHtw
         4Hxfli9VuKXYkZOJQZUHmpaUHjJD+toFoqGOdSK8Z9aT52LyvySbGtqGvjPjREBsla
         BEwUIpcVDf7x+PabPrjj8X7f3dvdgGyyjUyZ0/04=
Date:   Tue, 8 Jun 2021 15:49:25 +1000
From:   David Gibson <david@gibson.dropbear.id.au>
To:     "Tian, Kevin" <kevin.tian@intel.com>
Cc:     LKML <linux-kernel@vger.kernel.org>,
        Joerg Roedel <joro@8bytes.org>,
        Jason Gunthorpe <jgg@nvidia.com>,
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
Message-ID: <YL8E5UoT0tndJZfh@yekko>
References: <MWHPR11MB1886422D4839B372C6AB245F8C239@MWHPR11MB1886.namprd11.prod.outlook.com>
 <YLch6zbbYqV4PyVf@yekko>
 <MWHPR11MB1886081DE676B0130D3D19258C3C9@MWHPR11MB1886.namprd11.prod.outlook.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="0m5ZmT5muBxt/Zml"
Content-Disposition: inline
In-Reply-To: <MWHPR11MB1886081DE676B0130D3D19258C3C9@MWHPR11MB1886.namprd11.prod.outlook.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


--0m5ZmT5muBxt/Zml
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Jun 03, 2021 at 07:17:23AM +0000, Tian, Kevin wrote:
> > From: David Gibson <david@gibson.dropbear.id.au>
> > Sent: Wednesday, June 2, 2021 2:15 PM
> >=20
> [...]=20
> > > An I/O address space takes effect in the IOMMU only after it is attac=
hed
> > > to a device. The device in the /dev/ioasid context always refers to a
> > > physical one or 'pdev' (PF or VF).
> >=20
> > What you mean by "physical" device here isn't really clear - VFs
> > aren't really physical devices, and the PF/VF terminology also doesn't
> > extent to non-PCI devices (which I think we want to consider for the
> > API, even if we're not implemenenting it any time soon).
>=20
> Yes, it's not very clear, and more in PCI context to simplify the=20
> description. A "physical" one here means an PCI endpoint function
> which has a unique RID. It's more to differentiate with later mdev/
> subdevice which uses both RID+PASID. Naming is always a hard
> exercise to me... Possibly I'll just use device vs. subdevice in future
> versions.
>=20
> >=20
> > Now, it's clear that we can't program things into the IOMMU before
> > attaching a device - we might not even know which IOMMU to use.
>=20
> yes
>=20
> > However, I'm not sure if its wise to automatically make the AS "real"
> > as soon as we attach a device:
> >=20
> >  * If we're going to attach a whole bunch of devices, could we (for at
> >    least some IOMMU models) end up doing a lot of work which then has
> >    to be re-done for each extra device we attach?
>=20
> which extra work did you specifically refer to? each attach just implies
> writing the base address of the I/O page table to the IOMMU structure
> corresponding to this device (either being a per-device entry, or per
> device+PASID entry).
>=20
> and generally device attach should not be in a hot path.
>=20
> >=20
> >  * With kernel managed IO page tables could attaching a second device
> >    (at least on some IOMMU models) require some operation which would
> >    require discarding those tables?  e.g. if the second device somehow
> >    forces a different IO page size
>=20
> Then the attach should fail and the user should create another IOASID
> for the second device.

Couldn't this make things weirdly order dependent though?  If device A
has strictly more capabilities than device B, then attaching A then B
will be fine, but B then A will trigger a new ioasid fd.

> > For that reason I wonder if we want some sort of explicit enable or
> > activate call.  Device attaches would only be valid before, map or
> > attach pagetable calls would only be valid after.
>=20
> I'm interested in learning a real example requiring explicit enable...
>=20
> >=20
> > > One I/O address space could be attached to multiple devices. In this =
case,
> > > /dev/ioasid uAPI applies to all attached devices under the specified =
IOASID.
> > >
> > > Based on the underlying IOMMU capability one device might be allowed
> > > to attach to multiple I/O address spaces, with DMAs accessing them by
> > > carrying different routing information. One of them is the default I/O
> > > address space routed by PCI Requestor ID (RID) or ARM Stream ID. The
> > > remaining are routed by RID + Process Address Space ID (PASID) or
> > > Stream+Substream ID. For simplicity the following context uses RID and
> > > PASID when talking about the routing information for I/O address spac=
es.
> >=20
> > I'm not really clear on how this interacts with nested ioasids.  Would
> > you generally expect the RID+PASID IOASes to be children of the base
> > RID IOAS, or not?
>=20
> No. With Intel SIOV both parent/children could be RID+PASID, e.g.
> when one enables vSVA on a mdev.

Hm, ok.  I really haven't understood how the PASIDs fit into this
then.  I'll try again on v2.

> > If the PASID ASes are children of the RID AS, can we consider this not
> > as the device explicitly attaching to multiple IOASIDs, but instead
> > attaching to the parent IOASID with awareness of the child ones?
> >=20
> > > Device attachment is initiated through passthrough framework uAPI (use
> > > VFIO for simplicity in following context). VFIO is responsible for id=
entifying
> > > the routing information and registering it to the ioasid driver when =
calling
> > > ioasid attach helper function. It could be RID if the assigned device=
 is
> > > pdev (PF/VF) or RID+PASID if the device is mediated (mdev). In additi=
on,
> > > user might also provide its view of virtual routing information (vPAS=
ID) in
> > > the attach call, e.g. when multiple user-managed I/O address spaces a=
re
> > > attached to the vfio_device. In this case VFIO must figure out whether
> > > vPASID should be directly used (for pdev) or converted to a kernel-
> > > allocated one (pPASID, for mdev) for physical routing (see section 4).
> > >
> > > Device must be bound to an IOASID FD before attach operation can be
> > > conducted. This is also through VFIO uAPI. In this proposal one device
> > > should not be bound to multiple FD's. Not sure about the gain of
> > > allowing it except adding unnecessary complexity. But if others have
> > > different view we can further discuss.
> > >
> > > VFIO must ensure its device composes DMAs with the routing information
> > > attached to the IOASID. For pdev it naturally happens since vPASID is
> > > directly programmed to the device by guest software. For mdev this
> > > implies any guest operation carrying a vPASID on this device must be
> > > trapped into VFIO and then converted to pPASID before sent to the
> > > device. A detail explanation about PASID virtualization policies can =
be
> > > found in section 4.
> > >
> > > Modern devices may support a scalable workload submission interface
> > > based on PCI DMWr capability, allowing a single work queue to access
> > > multiple I/O address spaces. One example is Intel ENQCMD, having
> > > PASID saved in the CPU MSR and carried in the instruction payload
> > > when sent out to the device. Then a single work queue shared by
> > > multiple processes can compose DMAs carrying different PASIDs.
> >=20
> > Is the assumption here that the processes share the IOASID FD
> > instance, but not memory?
>=20
> I didn't get this question

Ok, stepping back, what exactly do you mean by "processes" above?  Do
you mean Linux processes, or something else?

> > > When executing ENQCMD in the guest, the CPU MSR includes a vPASID
> > > which, if targeting a mdev, must be converted to pPASID before sent
> > > to the wire. Intel CPU provides a hardware PASID translation capabili=
ty
> > > for auto-conversion in the fast path. The user is expected to setup t=
he
> > > PASID mapping through KVM uAPI, with information about {vpasid,
> > > ioasid_fd, ioasid}. The ioasid driver provides helper function for KVM
> > > to figure out the actual pPASID given an IOASID.
> > >
> > > With above design /dev/ioasid uAPI is all about I/O address spaces.
> > > It doesn't include any device routing information, which is only
> > > indirectly registered to the ioasid driver through VFIO uAPI. For
> > > example, I/O page fault is always reported to userspace per IOASID,
> > > although it's physically reported per device (RID+PASID). If there is=
 a
> > > need of further relaying this fault into the guest, the user is respo=
nsible
> > > of identifying the device attached to this IOASID (randomly pick one =
if
> > > multiple attached devices) and then generates a per-device virtual I/O
> > > page fault into guest. Similarly the iotlb invalidation uAPI describe=
s the
> > > granularity in the I/O address space (all, or a range), different fro=
m the
> > > underlying IOMMU semantics (domain-wide, PASID-wide, range-based).
> > >
> > > I/O page tables routed through PASID are installed in a per-RID PASID
> > > table structure. Some platforms implement the PASID table in the guest
> > > physical space (GPA), expecting it managed by the guest. The guest
> > > PASID table is bound to the IOMMU also by attaching to an IOASID,
> > > representing the per-RID vPASID space.
> >=20
> > Do we need to consider two management modes here, much as we have for
> > the pagetables themsleves: either kernel managed, in which we have
> > explicit calls to bind a vPASID to a parent PASID, or user managed in
> > which case we register a table in some format.
>=20
> yes, this is related to PASID virtualization in section 4. And based on=
=20
> suggestion from Jason, the vPASID requirement will be reported to
> user space via the per-device reporting interface.
>=20
> Thanks
> Kevin
>=20

--=20
David Gibson			| I'll have my music baroque, and my code
david AT gibson.dropbear.id.au	| minimalist, thank you.  NOT _the_ _other_
				| _way_ _around_!
http://www.ozlabs.org/~dgibson

--0m5ZmT5muBxt/Zml
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEdfRlhq5hpmzETofcbDjKyiDZs5IFAmC/BOMACgkQbDjKyiDZ
s5LK5BAAs3fDG9X4n5k72QI9E302AvlcHhqDEV+QO9FVrJIBUNIGWtArJ3QpaMo9
YsRdjSzjUe4K2FixvHk+vhrIL0UgsEpKME/3wnAcTdcLRlmuiYOxnoNmay2FSBvz
+agr6JKxIPqKlIaweXV+ZgPE+UslAGwB+Y0WYZpAU/AgjHrv1WqDWKBdUdndhnKk
tqqXFUhAPV/SiRNFx1kZf5b8UKpGJtAQPmoE8lwpE+9PQSNPeDNX9gXgNkPpCu6E
86Yci0bFwMyb+DMgzmZn4iIiE4wIRT5C96dQ3obnW8bKsQm36HZmNB9pEjnjvBiM
GLG452DaoWg1eFxg8lEMyxsbo/eiEwC3QMzvXA8PlDsbptqxsRaE9GazeXKM97Vz
YBOQ1kbBzfa0FzNl62c0JiXiksCG7hZk/HvUKkycKW/919eYSqEyh505caHGDY2f
7hbCyXSoHxk3SUYo3tF8pUKAesWi+9DUJHEcWMygcwyM+W5CEjnsE3MUjnJWeWk/
e92lErcq27pLOYi0nWWZJVTvDWHBGMdzm5QQjjCh3s8a5iD5s+Q8fOr2ersQtDyO
/F+CcUqV+/E5auEHonn/6AKBcVapffQfoPCPQrsiuAEAOSoNYctoBcHAXX3BCHi1
gu8QAvrPQrUbLwXaqL2cgayEOif9QcKT/li/J7FAOA5xlqNPvzI=
=qPF8
-----END PGP SIGNATURE-----

--0m5ZmT5muBxt/Zml--
