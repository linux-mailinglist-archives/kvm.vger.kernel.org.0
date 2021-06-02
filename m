Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 06E7F3982EC
	for <lists+kvm@lfdr.de>; Wed,  2 Jun 2021 09:29:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231577AbhFBHbD (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 2 Jun 2021 03:31:03 -0400
Received: from bilbo.ozlabs.org ([203.11.71.1]:59903 "EHLO ozlabs.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230228AbhFBHbA (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 2 Jun 2021 03:31:00 -0400
Received: by ozlabs.org (Postfix, from userid 1007)
        id 4Fw0yh2jB1z9sRK; Wed,  2 Jun 2021 17:29:16 +1000 (AEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
        d=gibson.dropbear.id.au; s=201602; t=1622618956;
        bh=wRTXISEDG4M4DX/zss0f7Qzb084HLLHwM9+VOjbsb30=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=lL5edZqsHApE5ojrB2pugjW4EUYLQAKJsvhpxMZWKqD3/R30sjiww/j/KA5oVyOlf
         EFuc8g4DkNHF56DmKY23KMC4GoekI3p7htRDahtPDv2mprfp6WFyGUDYctzvF/Ulzi
         0PrvfoZg/qj7iKwvbsZthkJI6mOhOdlTAkRfT+KU=
Date:   Wed, 2 Jun 2021 16:48:35 +1000
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
Message-ID: <YLcpw5Kx61L7TVmR@yekko>
References: <MWHPR11MB1886422D4839B372C6AB245F8C239@MWHPR11MB1886.namprd11.prod.outlook.com>
 <20210528195839.GO1002214@nvidia.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="Hex0SSC4iy2pvQ2b"
Content-Disposition: inline
In-Reply-To: <20210528195839.GO1002214@nvidia.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


--Hex0SSC4iy2pvQ2b
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, May 28, 2021 at 04:58:39PM -0300, Jason Gunthorpe wrote:
> On Thu, May 27, 2021 at 07:58:12AM +0000, Tian, Kevin wrote:
> >=20
> > 5. Use Cases and Flows
> >=20
> > Here assume VFIO will support a new model where every bound device
> > is explicitly listed under /dev/vfio thus a device fd can be acquired w=
/o=20
> > going through legacy container/group interface. For illustration purpose
> > those devices are just called dev[1...N]:
> >=20
> > 	device_fd[1...N] =3D open("/dev/vfio/devices/dev[1...N]", mode);
> >=20
> > As explained earlier, one IOASID fd is sufficient for all intended use =
cases:
> >=20
> > 	ioasid_fd =3D open("/dev/ioasid", mode);
> >=20
> > For simplicity below examples are all made for the virtualization story.
> > They are representative and could be easily adapted to a non-virtualiza=
tion
> > scenario.
>=20
> For others, I don't think this is *strictly* necessary, we can
> probably still get to the device_fd using the group_fd and fit in
> /dev/ioasid. It does make the rest of this more readable though.

Leaving aside whether group fds should exist, while they *do* exist
binding to an IOASID should be done on the group not an individual
device.

[snip]
> > 	/* if dev1 is ENQCMD-capable mdev, update CPU PASID=20
> > 	  * translation structure through KVM
> > 	  */
> > 	pa_data =3D {
> > 		.ioasid_fd	=3D ioasid_fd;
> > 		.ioasid		=3D gva_ioasid;
> > 		.guest_pasid	=3D gpasid1;
> > 	};
> > 	ioctl(kvm_fd, KVM_MAP_PASID, &pa_data);
>=20
> Make sense
>=20
> > 	/* Bind guest I/O page table  */
> > 	bind_data =3D {
> > 		.ioasid	=3D gva_ioasid;
> > 		.addr	=3D gva_pgtable1;
> > 		// and format information
> > 	};
> > 	ioctl(ioasid_fd, IOASID_BIND_PGTABLE, &bind_data);
>=20
> Again I do wonder if this should just be part of alloc_ioasid. Is
> there any reason to split these things? The only advantage to the
> split is the device is known, but the device shouldn't impact
> anything..

I'm pretty sure the device(s) could matter, although they probably
won't usually.  But it would certainly be possible for a system to
have two different host bridges with two different IOMMUs with
different pagetable formats.  Until you know which devices (and
therefore which host bridge) you're talking about, you don't know what
formats of pagetable to accept.  And if you have devices from *both*
bridges you can't bind a page table at all - you could theoretically
support a kernel managed pagetable by mirroring each MAP and UNMAP to
tables in both formats, but it would be pretty reasonable not to
support that.

> > 5.6. I/O page fault
> > +++++++++++++++
> >=20
> > (uAPI is TBD. Here is just about the high-level flow from host IOMMU dr=
iver
> > to guest IOMMU driver and backwards).
> >=20
> > -   Host IOMMU driver receives a page request with raw fault_data {rid,=
=20
> >     pasid, addr};
> >=20
> > -   Host IOMMU driver identifies the faulting I/O page table according =
to
> >     information registered by IOASID fault handler;
> >=20
> > -   IOASID fault handler is called with raw fault_data (rid, pasid, add=
r), which=20
> >     is saved in ioasid_data->fault_data (used for response);
> >=20
> > -   IOASID fault handler generates an user fault_data (ioasid, addr), l=
inks it=20
> >     to the shared ring buffer and triggers eventfd to userspace;
>=20
> Here rid should be translated to a labeled device and return the
> device label from VFIO_BIND_IOASID_FD. Depending on how the device
> bound the label might match to a rid or to a rid,pasid

I like the idea of labelling devices when they're attached, it makes
extension to non-PCI devices much more obvious that having to deal
with concrete RIDs.

But, remember we can only (reliably) determine rid up to the group
boundary.  So if you're labelling devices, all devices in a group
would have to have the same label.  Or you attach the label to a group
not a device, which would be a reason to represent the group as an
object again.

> > -   Upon received event, Qemu needs to find the virtual routing informa=
tion=20
> >     (v_rid + v_pasid) of the device attached to the faulting ioasid. If=
 there are=20
> >     multiple, pick a random one. This should be fine since the purpose =
is to
> >     fix the I/O page table on the guest;
>=20
> The device label should fix this
> =20
> > -   Qemu finds the pending fault event, converts virtual completion dat=
a=20
> >     into (ioasid, response_code), and then calls a /dev/ioasid ioctl to=
=20
> >     complete the pending fault;
> >=20
> > -   /dev/ioasid finds out the pending fault data {rid, pasid, addr} sav=
ed in=20
> >     ioasid_data->fault_data, and then calls iommu api to complete it wi=
th
> >     {rid, pasid, response_code};
>=20
> So resuming a fault on an ioasid will resume all devices pending on
> the fault?
>=20
> > 5.7. BIND_PASID_TABLE
> > ++++++++++++++++++++
> >=20
> > PASID table is put in the GPA space on some platform, thus must be upda=
ted
> > by the guest. It is treated as another user page table to be bound with=
 the=20
> > IOMMU.
> >=20
> > As explained earlier, the user still needs to explicitly bind every use=
r I/O=20
> > page table to the kernel so the same pgtable binding protocol (bind, ca=
che=20
> > invalidate and fault handling) is unified cross platforms.
> >
> > vIOMMUs may include a caching mode (or paravirtualized way) which, once=
=20
> > enabled, requires the guest to invalidate PASID cache for any change on=
 the=20
> > PASID table. This allows Qemu to track the lifespan of guest I/O page t=
ables.
> >
> > In case of missing such capability, Qemu could enable write-protection =
on
> > the guest PASID table to achieve the same effect.
> >=20
> > 	/* After boots */
> > 	/* Make vPASID space nested on GPA space */
> > 	pasidtbl_ioasid =3D ioctl(ioasid_fd, IOASID_CREATE_NESTING,
> > 				gpa_ioasid);
> >=20
> > 	/* Attach dev1 to pasidtbl_ioasid */
> > 	at_data =3D { .ioasid =3D pasidtbl_ioasid};
> > 	ioctl(device_fd1, VFIO_ATTACH_IOASID, &at_data);
> >=20
> > 	/* Bind PASID table */
> > 	bind_data =3D {
> > 		.ioasid	=3D pasidtbl_ioasid;
> > 		.addr	=3D gpa_pasid_table;
> > 		// and format information
> > 	};
> > 	ioctl(ioasid_fd, IOASID_BIND_PASID_TABLE, &bind_data);
> >=20
> > 	/* vIOMMU detects a new GVA I/O space created */
> > 	gva_ioasid =3D ioctl(ioasid_fd, IOASID_CREATE_NESTING,
> > 				gpa_ioasid);
> >=20
> > 	/* Attach dev1 to the new address space, with gpasid1 */
> > 	at_data =3D {
> > 		.ioasid		=3D gva_ioasid;
> > 		.flag 		=3D IOASID_ATTACH_USER_PASID;
> > 		.user_pasid	=3D gpasid1;
> > 	};
> > 	ioctl(device_fd1, VFIO_ATTACH_IOASID, &at_data);
> >=20
> > 	/* Bind guest I/O page table. Because SET_PASID_TABLE has been
> > 	  * used, the kernel will not update the PASID table. Instead, just
> > 	  * track the bound I/O page table for handling invalidation and
> > 	  * I/O page faults.
> > 	  */
> > 	bind_data =3D {
> > 		.ioasid	=3D gva_ioasid;
> > 		.addr	=3D gva_pgtable1;
> > 		// and format information
> > 	};
> > 	ioctl(ioasid_fd, IOASID_BIND_PGTABLE, &bind_data);
>=20
> I still don't quite get the benifit from doing this.
>=20
> The idea to create an all PASID IOASID seems to work better with less
> fuss on HW that is directly parsing the guest's PASID table.
>=20
> Cache invalidate seems easy enough to support
>=20
> Fault handling needs to return the (ioasid, device_label, pasid) when
> working with this kind of ioasid.
>=20
> It is true that it does create an additional flow qemu has to
> implement, but it does directly mirror the HW.
>=20
> Jason
>=20

--=20
David Gibson			| I'll have my music baroque, and my code
david AT gibson.dropbear.id.au	| minimalist, thank you.  NOT _the_ _other_
				| _way_ _around_!
http://www.ozlabs.org/~dgibson

--Hex0SSC4iy2pvQ2b
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEdfRlhq5hpmzETofcbDjKyiDZs5IFAmC3KcEACgkQbDjKyiDZ
s5I9MA/+KLEL4S2rT7+vVvtYMGshHBiNPVG7KHTKbttVIgsw0M1awKtV5gZJnXWP
qO+J9JxQ5jmvPWjQjppt9ViWsswUK9dyd2CHuKUBgpE2kDRC67snpDG3VTTW274N
cee6RrMXOvXx56BX/Y/Ytktzm5vejtnHyo6kmWvLkXjZ94zVO1jXo/m3n4WyOREM
/N9tP7KzfrPLfPKS00DDQXfTKjVEyFSbZ4j+4cdP+YejEA3wV5E+oWcVvO4FaiZi
njLX6aYpowzO+dMlDm51gYoANnORtHyxsdeuf39L5glLgEu7qKulUDRqjLeH+Mpj
kxoPRbCKekjrGAqpV0up9cNC0YG1vyW4DZwBmICAb4d+CMcE7CmX93xwgMrma2SL
gRPaMqCDqiNaWeB4a1jDfjxIsl4jxjBCcxMYdKKhUUFbO73dnYONr8acS27MU05O
mA2igLvfBJGAZNvk+v8jyj8Ec3ecZO7C7rhXE3Qooe1geGBqhPUWgy8u6j8YNyAI
14myX2eeFmSHLSogE1a5L/VPFrMmpuRJatQKyprzZ0EnZRwoSr0rILhoN0j7pl3T
E2I/Q2cCk8dTDC4K1Xy2DFxFg2zZGlcw0SQCB1E9hi1ly2/5XTJswljZMATiM6gB
kWXkBcTbb5yBy0ZWs0y65n4tyzmAJYFdRbdQlBHkbouIvftzcAc=
=Te+B
-----END PGP SIGNATURE-----

--Hex0SSC4iy2pvQ2b--
