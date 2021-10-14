Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DFEA942D23F
	for <lists+kvm@lfdr.de>; Thu, 14 Oct 2021 08:22:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229669AbhJNGYj (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 14 Oct 2021 02:24:39 -0400
Received: from gandalf.ozlabs.org ([150.107.74.76]:57751 "EHLO
        gandalf.ozlabs.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229530AbhJNGYi (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 14 Oct 2021 02:24:38 -0400
Received: by gandalf.ozlabs.org (Postfix, from userid 1007)
        id 4HVK7r2LY8z4xqS; Thu, 14 Oct 2021 17:22:32 +1100 (AEDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gibson.dropbear.id.au; s=201602; t=1634192552;
        bh=7Wh2Sf7H1OnK1ukGq1qUmZ2CTp58mdA8SR1DDVPmPgA=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=QbIvwfSi/vkdqqrWPcKFZGL3wELCH7CpF7VDKsuacOBbSm78iYEnkTjbOPOtS05rx
         LaCVysA7bovnjYuo4iVHWbJ1w87SJJB8VSn6JkJRrmTel94Zbu/7VDgL1fsuSC4VcC
         6jnvKE1aLkrNxc0eqeVTajnRYv0OjLwKr/pS/ZyI=
Date:   Thu, 14 Oct 2021 16:00:03 +1100
From:   David Gibson <david@gibson.dropbear.id.au>
To:     "Tian, Kevin" <kevin.tian@intel.com>
Cc:     "Liu, Yi L" <yi.l.liu@intel.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "jasowang@redhat.com" <jasowang@redhat.com>,
        "kwankhede@nvidia.com" <kwankhede@nvidia.com>,
        "hch@lst.de" <hch@lst.de>,
        "jean-philippe@linaro.org" <jean-philippe@linaro.org>,
        "Jiang, Dave" <dave.jiang@intel.com>,
        "Raj, Ashok" <ashok.raj@intel.com>,
        "corbet@lwn.net" <corbet@lwn.net>,
        "jgg@nvidia.com" <jgg@nvidia.com>,
        "parav@mellanox.com" <parav@mellanox.com>,
        "alex.williamson@redhat.com" <alex.williamson@redhat.com>,
        "lkml@metux.net" <lkml@metux.net>,
        "dwmw2@infradead.org" <dwmw2@infradead.org>,
        "Tian, Jun J" <jun.j.tian@intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "lushenming@huawei.com" <lushenming@huawei.com>,
        "iommu@lists.linux-foundation.org" <iommu@lists.linux-foundation.org>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "robin.murphy@arm.com" <robin.murphy@arm.com>
Subject: Re: [RFC 11/20] iommu/iommufd: Add IOMMU_IOASID_ALLOC/FREE
Message-ID: <YWe5U0fL3t+ldXC2@yekko>
References: <20210919063848.1476776-1-yi.l.liu@intel.com>
 <20210919063848.1476776-12-yi.l.liu@intel.com>
 <YVamgnMzuv3TCQiX@yekko>
 <BN9PR11MB5433E3BE7550BBF176636F8A8CB79@BN9PR11MB5433.namprd11.prod.outlook.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="dmIgXiGx504ZaxcN"
Content-Disposition: inline
In-Reply-To: <BN9PR11MB5433E3BE7550BBF176636F8A8CB79@BN9PR11MB5433.namprd11.prod.outlook.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


--dmIgXiGx504ZaxcN
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Oct 13, 2021 at 07:00:58AM +0000, Tian, Kevin wrote:
> > From: David Gibson
> > Sent: Friday, October 1, 2021 2:11 PM
> >=20
> > On Sun, Sep 19, 2021 at 02:38:39PM +0800, Liu Yi L wrote:
> > > This patch adds IOASID allocation/free interface per iommufd. When
> > > allocating an IOASID, userspace is expected to specify the type and
> > > format information for the target I/O page table.
> > >
> > > This RFC supports only one type (IOMMU_IOASID_TYPE_KERNEL_TYPE1V2),
> > > implying a kernel-managed I/O page table with vfio type1v2 mapping
> > > semantics. For this type the user should specify the addr_width of
> > > the I/O address space and whether the I/O page table is created in
> > > an iommu enfore_snoop format. enforce_snoop must be true at this poin=
t,
> > > as the false setting requires additional contract with KVM on handling
> > > WBINVD emulation, which can be added later.
> > >
> > > Userspace is expected to call IOMMU_CHECK_EXTENSION (see next patch)
> > > for what formats can be specified when allocating an IOASID.
> > >
> > > Open:
> > > - Devices on PPC platform currently use a different iommu driver in v=
fio.
> > >   Per previous discussion they can also use vfio type1v2 as long as t=
here
> > >   is a way to claim a specific iova range from a system-wide address =
space.
> > >   This requirement doesn't sound PPC specific, as addr_width for pci
> > devices
> > >   can be also represented by a range [0, 2^addr_width-1]. This RFC ha=
sn't
> > >   adopted this design yet. We hope to have formal alignment in v1
> > discussion
> > >   and then decide how to incorporate it in v2.
> >=20
> > Ok, there are several things we need for ppc.  None of which are
> > inherently ppc specific and some of which will I think be useful for
> > most platforms.  So, starting from most general to most specific
> > here's basically what's needed:
> >=20
> > 1. We need to represent the fact that the IOMMU can only translate
> >    *some* IOVAs, not a full 64-bit range.  You have the addr_width
> >    already, but I'm entirely sure if the translatable range on ppc
> >    (or other platforms) is always a power-of-2 size.  It usually will
> >    be, of course, but I'm not sure that's a hard requirement.  So
> >    using a size/max rather than just a number of bits might be safer.
> >=20
> >    I think basically every platform will need this.  Most platforms
> >    don't actually implement full 64-bit translation in any case, but
> >    rather some smaller number of bits that fits their page table
> >    format.
> >=20
> > 2. The translatable range of IOVAs may not begin at 0.  So we need to
> >    advertise to userspace what the base address is, as well as the
> >    size.  POWER's main IOVA range begins at 2^59 (at least on the
> >    models I know about).
> >=20
> >    I think a number of platforms are likely to want this, though I
> >    couldn't name them apart from POWER.  Putting the translated IOVA
> >    window at some huge address is a pretty obvious approach to making
> >    an IOMMU which can translate a wide address range without colliding
> >    with any legacy PCI addresses down low (the IOMMU can check if this
> >    transaction is for it by just looking at some high bits in the
> >    address).
> >=20
> > 3. There might be multiple translatable ranges.  So, on POWER the
> >    IOMMU can typically translate IOVAs from 0..2GiB, and also from
> >    2^59..2^59+<RAM size>.  The two ranges have completely separate IO
> >    page tables, with (usually) different layouts.  (The low range will
> >    nearly always be a single-level page table with 4kiB or 64kiB
> >    entries, the high one will be multiple levels depending on the size
> >    of the range and pagesize).
> >=20
> >    This may be less common, but I suspect POWER won't be the only
> >    platform to do something like this.  As above, using a high range
> >    is a pretty obvious approach, but clearly won't handle older
> >    devices which can't do 64-bit DMA.  So adding a smaller range for
> >    those devices is again a pretty obvious solution.  Any platform
> >    with an "IO hole" can be treated as having two ranges, one below
> >    the hole and one above it (although in that case they may well not
> >    have separate page tables
>=20
> 1-3 are common on all platforms with fixed reserved ranges. Current
> vfio already reports permitted iova ranges to user via VFIO_IOMMU_
> TYPE1_INFO_CAP_IOVA_RANGE and the user is expected to construct
> maps only in those ranges. iommufd can follow the same logic for the
> baseline uAPI.
>=20
> For above cases a [base, max] hint can be provided by the user per
> Jason's recommendation.

Provided at which stage?

> It is a hint as no additional restriction is
> imposed,

For the qemu type use case, that's not true.  In that case we
*require* the available mapping ranges to match what the guest
platform expects.

> since the kernel only cares about no violation on permitted
> ranges that it reports to the user. Underlying iommu driver may use=20
> this hint to optimize e.g. deciding how many levels are used for
> the kernel-managed page table according to max addr.
>=20
> >=20
> > 4. The translatable ranges might not be fixed.  On ppc that 0..2GiB
> >    and 2^59..whatever ranges are kernel conventions, not specified by
> >    the hardware or firmware.  When running as a guest (which is the
> >    normal case on POWER), there are explicit hypercalls for
> >    configuring the allowed IOVA windows (along with pagesize, number
> >    of levels etc.).  At the moment it is fixed in hardware that there
> >    are only 2 windows, one starting at 0 and one at 2^59 but there's
> >    no inherent reason those couldn't also be configurable.
>=20
> If ppc iommu driver needs to configure hardware according to the=20
> specified ranges, then it requires more than a hint thus better be
> conveyed via ppc specific cmd as Jason suggested.

Again, a hint at what stage of the setup process are you thinking?

> >    This will probably be rarer, but I wouldn't be surprised if it
> >    appears on another platform.  If you were designing an IOMMU ASIC
> >    for use in a variety of platforms, making the base address and size
> >    of the translatable range(s) configurable in registers would make
> >    sense.
> >=20
> >=20
> > Now, for (3) and (4), representing lists of windows explicitly in
> > ioctl()s is likely to be pretty ugly.  We might be able to avoid that,
> > for at least some of the interfaces, by using the nested IOAS stuff.
> > One way or another, though, the IOASes which are actually attached to
> > devices need to represent both windows.
> >=20
> > e.g.
> > Create a "top-level" IOAS <A> representing the device's view.  This
> > would be either TYPE_KERNEL or maybe a special type.  Into that you'd
> > make just two iomappings one for each of the translation windows,
> > pointing to IOASes <B> and <C>.  IOAS <B> and <C> would have a single
> > window, and would represent the IO page tables for each of the
> > translation windows.  These could be either TYPE_KERNEL or (say)
> > TYPE_POWER_TCE for a user managed table.  Well.. in theory, anyway.
> > The way paravirtualization on POWER is done might mean user managed
> > tables aren't really possible for other reasons, but that's not
> > relevant here.
> >=20
> > The next problem here is that we don't want userspace to have to do
> > different things for POWER, at least not for the easy case of a
> > userspace driver that just wants a chunk of IOVA space and doesn't
> > really care where it is.
> >=20
> > In general I think the right approach to handle that is to
> > de-emphasize "info" or "query" interfaces.  We'll probably still need
> > some for debugging and edge cases, but in the normal case userspace
> > should just specify what it *needs* and (ideally) no more with
> > optional hints, and the kernel will either supply that or fail.
> >=20
> > e.g. A simple userspace driver would simply say "I need an IOAS with
> > at least 1GiB of IOVA space" and the kernel says "Ok, you can use
> > 2^59..2^59+2GiB".  qemu, emulating the POWER vIOMMU might say "I need
> > an IOAS with translatable addresses from 0..2GiB with 4kiB page size
> > and from 2^59..2^59+1TiB with 64kiB page size" and the kernel would
> > either say "ok", or "I can't do that".
> >=20
>=20
> This doesn't work for other platforms, which don't have vIOMMU=20
> mandatory as on ppc. For those platforms, the initial address space
> is GPA (for vm case) and Qemu needs to mark those GPA holes as=20
> reserved in firmware structure. I don't think anyone wants a tedious
> try-and-fail process to figure out how many holes exists in a 64bit
> address space...

Ok, I'm not quite sure how this works.  The holes are guest visible,
which generally means they have to be fixed by the guest *platform*
and can't depend on host information.  Otherwise, migration is totally
broken.  I'm wondering if this only works by accident now, because the
holes are usually in the same place on all x86 machines.

--=20
David Gibson			| I'll have my music baroque, and my code
david AT gibson.dropbear.id.au	| minimalist, thank you.  NOT _the_ _other_
				| _way_ _around_!
http://www.ozlabs.org/~dgibson

--dmIgXiGx504ZaxcN
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEdfRlhq5hpmzETofcbDjKyiDZs5IFAmFnuVMACgkQbDjKyiDZ
s5JyGg/+P0xR7fE3WvJbPd/WhZBEs5KCLmtLtomqS7nMuEcPfH/cyM/4pPsgVAP7
+01JmIYm1AGPV2xL7cP3Ca8cGp5CXoGrRoFapP57nVQ1yE3pmRKVPeCcGv3+VE7A
jCrTMzElnuYK9SPTqWP4Y0flDqO/zRZv/sGr/1/Bt36sGchXPiKEmyKLuokMQBBO
ymE/NiXeL9BEcdgIsxGf8fP1ZGHA1NDJcR8oPJCSdXxFljtBNHpr1cItsIr7e3+Q
alFc/yW/NIqI2Oe0H+GzS6faeoOxGBysBOG6Iy4rfneZkzTXuEZCkL1CD0AK1ob6
wijqFCAPjHBMypaAQzupo8q7uhSe6zlGMVU5AHg8mKEAHdmTVrc+pFEuIHR6/vPN
L94Xs6YFpkSmCCR4Q/8Jg5S23ipJq6/CioN1zAXbrfjApBPEoPm1yOhX7YSRTs61
xNjBJ02eeiF7efyE2LsYU6qhxnHxmwz/4BL8VPaLTSgwHxUS+3ySV+q5fX0Bd59Z
AevNE9CaQc1nIPkvuARLQ0h6CG/ZLY4owOIo2xmnIfJPF5B3v1+FrpVoEaV3j0tC
WVwI7X/UXD3v3dOfthYycdCISRyVpZq7j3vujLgiTYHukKQKuXtZgGwKBJdbAFwd
Zo3Ry4jBlulhZoRxEUTu3cupqU4i4anGJT2Q/H/B/KVJMp0xs2I=
=pDZ+
-----END PGP SIGNATURE-----

--dmIgXiGx504ZaxcN--
