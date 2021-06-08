Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C299C39EF09
	for <lists+kvm@lfdr.de>; Tue,  8 Jun 2021 08:54:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230371AbhFHG4c (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 8 Jun 2021 02:56:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43252 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230316AbhFHG43 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 8 Jun 2021 02:56:29 -0400
Received: from ozlabs.org (ozlabs.org [IPv6:2401:3900:2:1::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CB07BC061789;
        Mon,  7 Jun 2021 23:54:36 -0700 (PDT)
Received: by ozlabs.org (Postfix, from userid 1007)
        id 4Fzgvs2C2lz9sWD; Tue,  8 Jun 2021 16:54:33 +1000 (AEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
        d=gibson.dropbear.id.au; s=201602; t=1623135273;
        bh=OamA9aFyY4QDHhsQAn6QhZV/ZpUjpyrDqT3NoIMfoxQ=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=nAf7BCvi6S19YIwMN4pKDgg8oR+2LFlo6kmh/3Z1V4bzqCDgXBUYDU5/yLTjexgDw
         ccB8KOs21+4grjXuS93i+rQsPRDUleJeOshDJKELE5YtfU3ZKalEppWcDUeqXncrUR
         P3pzuNTOnDKMXyOwTW52a02VG9aX0Rr8cSkwwFCk=
Date:   Tue, 8 Jun 2021 16:13:16 +1000
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
Message-ID: <YL8KfCo8H5aK9Xj+@yekko>
References: <MWHPR11MB1886422D4839B372C6AB245F8C239@MWHPR11MB1886.namprd11.prod.outlook.com>
 <20210528195839.GO1002214@nvidia.com>
 <YLcpw5Kx61L7TVmR@yekko>
 <20210602165838.GA1002214@nvidia.com>
 <YLhsZRc72aIMZajz@yekko>
 <20210603121105.GR1002214@nvidia.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="ZnWbrY5rMXMZUAOB"
Content-Disposition: inline
In-Reply-To: <20210603121105.GR1002214@nvidia.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


--ZnWbrY5rMXMZUAOB
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Jun 03, 2021 at 09:11:05AM -0300, Jason Gunthorpe wrote:
> On Thu, Jun 03, 2021 at 03:45:09PM +1000, David Gibson wrote:
> > On Wed, Jun 02, 2021 at 01:58:38PM -0300, Jason Gunthorpe wrote:
> > > On Wed, Jun 02, 2021 at 04:48:35PM +1000, David Gibson wrote:
> > > > > > 	/* Bind guest I/O page table  */
> > > > > > 	bind_data =3D {
> > > > > > 		.ioasid	=3D gva_ioasid;
> > > > > > 		.addr	=3D gva_pgtable1;
> > > > > > 		// and format information
> > > > > > 	};
> > > > > > 	ioctl(ioasid_fd, IOASID_BIND_PGTABLE, &bind_data);
> > > > >=20
> > > > > Again I do wonder if this should just be part of alloc_ioasid. Is
> > > > > there any reason to split these things? The only advantage to the
> > > > > split is the device is known, but the device shouldn't impact
> > > > > anything..
> > > >=20
> > > > I'm pretty sure the device(s) could matter, although they probably
> > > > won't usually.=20
> > >=20
> > > It is a bit subtle, but the /dev/iommu fd itself is connected to the
> > > devices first. This prevents wildly incompatible devices from being
> > > joined together, and allows some "get info" to report the capability
> > > union of all devices if we want to do that.
> >=20
> > Right.. but I've not been convinced that having a /dev/iommu fd
> > instance be the boundary for these types of things actually makes
> > sense.  For example if we were doing the preregistration thing
> > (whether by child ASes or otherwise) then that still makes sense
> > across wildly different devices, but we couldn't share that layer if
> > we have to open different instances for each of them.
>=20
> It is something that still seems up in the air.. What seems clear for
> /dev/iommu is that it
>  - holds a bunch of IOASID's organized into a tree
>  - holds a bunch of connected devices

Right, and it's still not really clear to me what devices connected to
the same /dev/iommu instance really need to have in common, as
distinct from what devices connected to the same specific ioasid need
to have in common.

>  - holds a pinned memory cache
>=20
> One thing it must do is enforce IOMMU group security. A device cannot
> be attached to an IOASID unless all devices in its IOMMU group are
> part of the same /dev/iommu FD.

Well, you can't attach a device to an individual IOASID unless all
devices in its group are attached to the same individual IOASID
either, so I'm not clear what benefit there is to enforcing it at the
/dev/iommu instance as well as at the individual ioasid level.

> The big open question is what parameters govern allowing devices to
> connect to the /dev/iommu:
>  - all devices can connect and we model the differences inside the API
>    somehow.
>  - Only sufficiently "similar" devices can be connected
>  - The FD's capability is the minimum of all the connected devices
>=20
> There are some practical problems here, when an IOASID is created the
> kernel does need to allocate a page table for it, and that has to be
> in some definite format.
>=20
> It may be that we had a false start thinking the FD container should
> be limited. Perhaps creating an IOASID should pass in a list
> of the "device labels" that the IOASID will be used with and that can
> guide the kernel what to do?
>=20
> > Right, but at this stage I'm just not seeing a really clear (across
> > platforms and device typpes) boundary for what things have to be per
> > IOASID container and what have to be per IOASID, so I'm just not sure
> > the /dev/iommu instance grouping makes any sense.
>=20
> I would push as much stuff as possible to be per-IOASID..

I agree.  But the question is what's *not* possible to be per-IOASID,
so what's the semantic boundary that defines when things have to be in
the same /dev/iommu instance, but not the same IOASID.

> > > I don't know if that small advantage is worth the extra complexity
> > > though.
> > >=20
> > > > But it would certainly be possible for a system to have two
> > > > different host bridges with two different IOMMUs with different
> > > > pagetable formats.  Until you know which devices (and therefore
> > > > which host bridge) you're talking about, you don't know what formats
> > > > of pagetable to accept.  And if you have devices from *both* bridges
> > > > you can't bind a page table at all - you could theoretically support
> > > > a kernel managed pagetable by mirroring each MAP and UNMAP to tables
> > > > in both formats, but it would be pretty reasonable not to support
> > > > that.
> > >=20
> > > The basic process for a user space owned pgtable mode would be:
> > >=20
> > >  1) qemu has to figure out what format of pgtable to use
> > >=20
> > >     Presumably it uses query functions using the device label.
> >=20
> > No... in the qemu case it would always select the page table format
> > that it needs to present to the guest.  That's part of the
> > guest-visible platform that's selected by qemu's configuration.
>=20
> I should have said "vfio user" here because apps like DPDK might use
> this path

Ok.

> > >  4) For the next device qemu would have to figure out if it can re-use
> > >     an existing IOASID based on the required proeprties.
> >=20
> > Nope.  Again, what devices share an IO address space is a guest
> > visible part of the platform.  If the host kernel can't supply that,
> > then qemu must not start (or fail the hotplug if the new device is
> > being hotplugged).
>=20
> qemu can always emulate.

No, not always, only sometimes.  The host side IOVA has to be able to
process all the IOVAs that the guest might generate, and it needs to
have an equal or smaller pagesize than the guest expects.

> If the config requires to devices that cannot
> share an IOASID because the local platform is wonky then qemu needs to
> shadow and duplicate the IO page table from the guest into two IOASID
> objects to make it work. This is a SW emulation option.
>=20
> > For this reason, amongst some others, I think when selecting a kernel
> > managed pagetable we need to also have userspace explicitly request
> > which IOVA ranges are mappable, and what (minimum) page size it
> > needs.
>=20
> It does make sense
>=20
> Jason
>=20

--=20
David Gibson			| I'll have my music baroque, and my code
david AT gibson.dropbear.id.au	| minimalist, thank you.  NOT _the_ _other_
				| _way_ _around_!
http://www.ozlabs.org/~dgibson

--ZnWbrY5rMXMZUAOB
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEdfRlhq5hpmzETofcbDjKyiDZs5IFAmC/CnsACgkQbDjKyiDZ
s5I04A/9GiD0mWZD0hcg3FJQ1EJF8YAtKTovMnsTqnTBXEbggWeJt/F/K8oYSB1A
bjZ8iT9srlxb2RudsBL9TV2vIPB4wXPq7oincGx903VngPDLl0D2LsFuKlGB61pg
UFt7cVzTptTR7qQIPR5zQdn6/RpVotJEMNjzg996apMusfPq+Ql5kkLnSh9MAVSw
2K1KISP7IREoY5VfaO4OTix8xoL47+w/QjiPjJdLWcUaNaZp+IIM3210SJa0tqN4
oyHol4yIPSL7BQpXr0yug8OprHFD/pUtXrP+UL4pSn42cKoL6gG4dhK0wm/sOBkN
oTEFCOAhXfrfzoBr0TzCrKKlgvGuyc4ibgdJjSFLe+hQ5iioojIVND+fpxAJJ7Tq
2sT2gtweRR1Jp46vxbzUmkKCkMCHK7HV14Li5RjfB7jyYITf2962huFZEBvgOucI
NLzpJ0dBGw5fwL96C2n/LlSIPrMLed42FYfT+kdI6pAwOvhq1b32OAG7RwHxn2Kr
jml6jkyfGa7fQ0/Jm15ku1PS9TKJFvz9dPELwvCC5EtlftwqcSDy0abdAOKz8zBY
+aL0TTv1LPQ/fLNChZpijWbYItAbM8IaQGk+ASukWwMnfP5WTZtl8Lueio5GdK3u
o3r1uRcV8efyHAZkke/yeUm8iuOcYRZuVTRoBZGqGQRXRvHzMNU=
=gbUa
-----END PGP SIGNATURE-----

--ZnWbrY5rMXMZUAOB--
