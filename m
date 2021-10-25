Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 10C7A438ED0
	for <lists+kvm@lfdr.de>; Mon, 25 Oct 2021 07:29:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229836AbhJYFbu (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 25 Oct 2021 01:31:50 -0400
Received: from gandalf.ozlabs.org ([150.107.74.76]:54953 "EHLO
        gandalf.ozlabs.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229489AbhJYFbt (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 25 Oct 2021 01:31:49 -0400
Received: by gandalf.ozlabs.org (Postfix, from userid 1007)
        id 4Hd3RV3mgpz4xbr; Mon, 25 Oct 2021 16:29:26 +1100 (AEDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gibson.dropbear.id.au; s=201602; t=1635139766;
        bh=8GLjpdm/8ye0RKRzmnVp1jfeMhW5LzdQvUNRWFyupK8=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=QARK0KWd0/yDtz/Q+dPsrIC+G3Ju7R4sP3wEMtLTDmnao4xojbn/BcZt/W6vfTMsM
         1R+tT0c9jW3mR/ENawyDnCxMC43NQVioZz27ZvVpMq9dD0Rh567smbb58hWopRJH+C
         F9POfYMornHlfJsMBlVZ1TJG1FpxajayLmqCH/2M=
Date:   Mon, 25 Oct 2021 16:05:07 +1100
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
Message-ID: <YXY7A+UQWC4gbIJc@yekko>
References: <20210919063848.1476776-1-yi.l.liu@intel.com>
 <20210919063848.1476776-12-yi.l.liu@intel.com>
 <YVamgnMzuv3TCQiX@yekko>
 <BN9PR11MB5433E3BE7550BBF176636F8A8CB79@BN9PR11MB5433.namprd11.prod.outlook.com>
 <YWe5U0fL3t+ldXC2@yekko>
 <BN9PR11MB54331C7936675EEE27C209948CB89@BN9PR11MB5433.namprd11.prod.outlook.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="lbICLZVDhL9/L42y"
Content-Disposition: inline
In-Reply-To: <BN9PR11MB54331C7936675EEE27C209948CB89@BN9PR11MB5433.namprd11.prod.outlook.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


--lbICLZVDhL9/L42y
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Oct 14, 2021 at 06:53:01AM +0000, Tian, Kevin wrote:
> > From: David Gibson <david@gibson.dropbear.id.au>
> > Sent: Thursday, October 14, 2021 1:00 PM
> >=20
> > On Wed, Oct 13, 2021 at 07:00:58AM +0000, Tian, Kevin wrote:
> > > > From: David Gibson
> > > > Sent: Friday, October 1, 2021 2:11 PM
> > > >
> > > > On Sun, Sep 19, 2021 at 02:38:39PM +0800, Liu Yi L wrote:
> > > > > This patch adds IOASID allocation/free interface per iommufd. When
> > > > > allocating an IOASID, userspace is expected to specify the type a=
nd
> > > > > format information for the target I/O page table.
> > > > >
> > > > > This RFC supports only one type
> > (IOMMU_IOASID_TYPE_KERNEL_TYPE1V2),
> > > > > implying a kernel-managed I/O page table with vfio type1v2 mapping
> > > > > semantics. For this type the user should specify the addr_width of
> > > > > the I/O address space and whether the I/O page table is created in
> > > > > an iommu enfore_snoop format. enforce_snoop must be true at this
> > point,
> > > > > as the false setting requires additional contract with KVM on han=
dling
> > > > > WBINVD emulation, which can be added later.
> > > > >
> > > > > Userspace is expected to call IOMMU_CHECK_EXTENSION (see next
> > patch)
> > > > > for what formats can be specified when allocating an IOASID.
> > > > >
> > > > > Open:
> > > > > - Devices on PPC platform currently use a different iommu driver =
in vfio.
> > > > >   Per previous discussion they can also use vfio type1v2 as long =
as there
> > > > >   is a way to claim a specific iova range from a system-wide addr=
ess
> > space.
> > > > >   This requirement doesn't sound PPC specific, as addr_width for =
pci
> > > > devices
> > > > >   can be also represented by a range [0, 2^addr_width-1]. This RFC
> > hasn't
> > > > >   adopted this design yet. We hope to have formal alignment in v1
> > > > discussion
> > > > >   and then decide how to incorporate it in v2.
> > > >
> > > > Ok, there are several things we need for ppc.  None of which are
> > > > inherently ppc specific and some of which will I think be useful for
> > > > most platforms.  So, starting from most general to most specific
> > > > here's basically what's needed:
> > > >
> > > > 1. We need to represent the fact that the IOMMU can only translate
> > > >    *some* IOVAs, not a full 64-bit range.  You have the addr_width
> > > >    already, but I'm entirely sure if the translatable range on ppc
> > > >    (or other platforms) is always a power-of-2 size.  It usually wi=
ll
> > > >    be, of course, but I'm not sure that's a hard requirement.  So
> > > >    using a size/max rather than just a number of bits might be safe=
r.
> > > >
> > > >    I think basically every platform will need this.  Most platforms
> > > >    don't actually implement full 64-bit translation in any case, but
> > > >    rather some smaller number of bits that fits their page table
> > > >    format.
> > > >
> > > > 2. The translatable range of IOVAs may not begin at 0.  So we need =
to
> > > >    advertise to userspace what the base address is, as well as the
> > > >    size.  POWER's main IOVA range begins at 2^59 (at least on the
> > > >    models I know about).
> > > >
> > > >    I think a number of platforms are likely to want this, though I
> > > >    couldn't name them apart from POWER.  Putting the translated IOVA
> > > >    window at some huge address is a pretty obvious approach to maki=
ng
> > > >    an IOMMU which can translate a wide address range without collid=
ing
> > > >    with any legacy PCI addresses down low (the IOMMU can check if t=
his
> > > >    transaction is for it by just looking at some high bits in the
> > > >    address).
> > > >
> > > > 3. There might be multiple translatable ranges.  So, on POWER the
> > > >    IOMMU can typically translate IOVAs from 0..2GiB, and also from
> > > >    2^59..2^59+<RAM size>.  The two ranges have completely separate =
IO
> > > >    page tables, with (usually) different layouts.  (The low range w=
ill
> > > >    nearly always be a single-level page table with 4kiB or 64kiB
> > > >    entries, the high one will be multiple levels depending on the s=
ize
> > > >    of the range and pagesize).
> > > >
> > > >    This may be less common, but I suspect POWER won't be the only
> > > >    platform to do something like this.  As above, using a high range
> > > >    is a pretty obvious approach, but clearly won't handle older
> > > >    devices which can't do 64-bit DMA.  So adding a smaller range for
> > > >    those devices is again a pretty obvious solution.  Any platform
> > > >    with an "IO hole" can be treated as having two ranges, one below
> > > >    the hole and one above it (although in that case they may well n=
ot
> > > >    have separate page tables
> > >
> > > 1-3 are common on all platforms with fixed reserved ranges. Current
> > > vfio already reports permitted iova ranges to user via VFIO_IOMMU_
> > > TYPE1_INFO_CAP_IOVA_RANGE and the user is expected to construct
> > > maps only in those ranges. iommufd can follow the same logic for the
> > > baseline uAPI.
> > >
> > > For above cases a [base, max] hint can be provided by the user per
> > > Jason's recommendation.
> >=20
> > Provided at which stage?
>=20
> IOMMU_IOASID_ALLOC

Ok.  I have mixed thoughts on this.  Doing this at ALLOC time was my
first instict as well.  However with Jason's suggestion that any of a
number of things could disambiguate multiple IOAS attached to a
device, I wonder if it makes more sense for consistency to put base
address at attach time, as with PASID.

I do think putting the size of the IOVA range makes sense to add at
IOASID_ALLOC time - for basically every type of window.  They'll
nearly always have some limit, which is relevant pretty early.

> > > It is a hint as no additional restriction is
> > > imposed,
> >=20
> > For the qemu type use case, that's not true.  In that case we
> > *require* the available mapping ranges to match what the guest
> > platform expects.
>=20
> I didn't get the 'match' part. Here we are talking about your case 3
> where the available ranges are fixed. There is nothing that the
> guest can change in this case, as long as it allocates iova always in
> the reported ranges.

Sorry, I don't understand the question.

> > > since the kernel only cares about no violation on permitted
> > > ranges that it reports to the user. Underlying iommu driver may use
> > > this hint to optimize e.g. deciding how many levels are used for
> > > the kernel-managed page table according to max addr.
> > >
> > > >
> > > > 4. The translatable ranges might not be fixed.  On ppc that 0..2GiB
> > > >    and 2^59..whatever ranges are kernel conventions, not specified =
by
> > > >    the hardware or firmware.  When running as a guest (which is the
> > > >    normal case on POWER), there are explicit hypercalls for
> > > >    configuring the allowed IOVA windows (along with pagesize, number
> > > >    of levels etc.).  At the moment it is fixed in hardware that the=
re
> > > >    are only 2 windows, one starting at 0 and one at 2^59 but there's
> > > >    no inherent reason those couldn't also be configurable.
> > >
> > > If ppc iommu driver needs to configure hardware according to the
> > > specified ranges, then it requires more than a hint thus better be
> > > conveyed via ppc specific cmd as Jason suggested.
> >=20
> > Again, a hint at what stage of the setup process are you thinking?
> >=20
> > > >    This will probably be rarer, but I wouldn't be surprised if it
> > > >    appears on another platform.  If you were designing an IOMMU ASIC
> > > >    for use in a variety of platforms, making the base address and s=
ize
> > > >    of the translatable range(s) configurable in registers would make
> > > >    sense.
> > > >
> > > >
> > > > Now, for (3) and (4), representing lists of windows explicitly in
> > > > ioctl()s is likely to be pretty ugly.  We might be able to avoid th=
at,
> > > > for at least some of the interfaces, by using the nested IOAS stuff.
> > > > One way or another, though, the IOASes which are actually attached =
to
> > > > devices need to represent both windows.
> > > >
> > > > e.g.
> > > > Create a "top-level" IOAS <A> representing the device's view.  This
> > > > would be either TYPE_KERNEL or maybe a special type.  Into that you=
'd
> > > > make just two iomappings one for each of the translation windows,
> > > > pointing to IOASes <B> and <C>.  IOAS <B> and <C> would have a sing=
le
> > > > window, and would represent the IO page tables for each of the
> > > > translation windows.  These could be either TYPE_KERNEL or (say)
> > > > TYPE_POWER_TCE for a user managed table.  Well.. in theory, anyway.
> > > > The way paravirtualization on POWER is done might mean user managed
> > > > tables aren't really possible for other reasons, but that's not
> > > > relevant here.
> > > >
> > > > The next problem here is that we don't want userspace to have to do
> > > > different things for POWER, at least not for the easy case of a
> > > > userspace driver that just wants a chunk of IOVA space and doesn't
> > > > really care where it is.
> > > >
> > > > In general I think the right approach to handle that is to
> > > > de-emphasize "info" or "query" interfaces.  We'll probably still ne=
ed
> > > > some for debugging and edge cases, but in the normal case userspace
> > > > should just specify what it *needs* and (ideally) no more with
> > > > optional hints, and the kernel will either supply that or fail.
> > > >
> > > > e.g. A simple userspace driver would simply say "I need an IOAS with
> > > > at least 1GiB of IOVA space" and the kernel says "Ok, you can use
> > > > 2^59..2^59+2GiB".  qemu, emulating the POWER vIOMMU might say "I
> > need
> > > > an IOAS with translatable addresses from 0..2GiB with 4kiB page size
> > > > and from 2^59..2^59+1TiB with 64kiB page size" and the kernel would
> > > > either say "ok", or "I can't do that".
> > > >
> > >
> > > This doesn't work for other platforms, which don't have vIOMMU
> > > mandatory as on ppc. For those platforms, the initial address space
> > > is GPA (for vm case) and Qemu needs to mark those GPA holes as
> > > reserved in firmware structure. I don't think anyone wants a tedious
> > > try-and-fail process to figure out how many holes exists in a 64bit
> > > address space...
> >=20
> > Ok, I'm not quite sure how this works.  The holes are guest visible,
> > which generally means they have to be fixed by the guest *platform*
> > and can't depend on host information.  Otherwise, migration is totally
> > broken.  I'm wondering if this only works by accident now, because the
> > holes are usually in the same place on all x86 machines.
>=20
> I haven't checked how qemu handle it today after vfio introduces the
> capability of reporting valid iova ranges (Alex, can you help confirm?).=
=20
> But there is no elegant answer. if qemu doesn't put the holes in=20
> GPA space it means guest driver might be broken if dma buffer happens=20
> to sit in the hole. this is even more severe than missing live migration.
> for x86 the situation is simpler as the only hole is 0xfeexxxxx on all
> platforms (with gpu as an exception).

Right.. I suspect this is the only reason it's working now on x86.

> other arch may have more holes
> though.
>=20
> regarding live migration with vfio devices, it's still in early stage. th=
ere
> are tons of compatibility check opens to be addressed before it can
> be widely deployed. this might just add another annoying open to that
> long list...

So, yes, live migration with VFIO is limited, unfortunately this
still affects us even if we don't (currently) have VFIO devices.  The
problem arises from the combination of two limitations:

1) Live migration means that we can't dynamically select guest visible
IOVA parameters at qemu start up time.  We need to get consistent
guest visible behaviour for a given set of qemu options, so that we
can migrate between them.

2) Device hotplug means that we don't know if a PCI domain will have
VFIO devices on it when we start qemu.  So, we don't know if host
limitations on IOVA ranges will affect the guest or not.

Together these mean that the best we can do is to define a *fixed*
(per machine type) configuration based on qemu options only.  That is,
defined by the guest platform we're trying to present, only, never
host capabilities.  We can then see if that configuration is possible
on the host and pass or fail.  It's never safe to go the other
direction and take host capabilities and present those to the guest.

Obviously, we then try to define the default platform configuration in
qemu to be usable on the greatest number of hosts we can.

--=20
David Gibson			| I'll have my music baroque, and my code
david AT gibson.dropbear.id.au	| minimalist, thank you.  NOT _the_ _other_
				| _way_ _around_!
http://www.ozlabs.org/~dgibson

--lbICLZVDhL9/L42y
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEdfRlhq5hpmzETofcbDjKyiDZs5IFAmF2Ov4ACgkQbDjKyiDZ
s5LvIg//fD/n6kcZ9IX2ZSzTu5uIW1rlfzjnvrZYZHVCn9cFkiSMcF4p9w1AJdwS
98wKNsaQKEo18D/pdlJOQAM49F3wBCUTgufJiARAX8un9lttiYG7gxcclmxHQ35q
yrtshQ7PboRd+M4Pw6ILN5Bxy6rQJUiWrSTRxMpMiIZf8gs4QM/C4XQf1MDOrHVb
ubJRuHzCXE4KE0UyxFBgF4avseeo+HKq6lryTzMwzwe94ZNtrUd0CzpMrWpJIFoR
PkosjFbMSov9/StdYJgjPJHdpfVZSRG5trM5W1uhb/2N3M6Kkws5tSYuHtroe161
5TieBfK+J31QEJJiVMyCDT4oRU+PlZXZQFDYOCbLRgv5xlK6Mkz1Vuut1//N9ReT
vdYgPq/ZZvtrxpx7FoVNgJTmOaw7vLe/7hhAYVusGmat7Kd9n5K3/qNblYoSm4ZR
gn6+Ve57gSQfQaqHCAY1htS4ODy2DUwT6snqhIZda5a+QLfHSSOrK8LLICL97vB+
Ul08wm4gSVKe9Hb5ktlsxu5NIXkzzhyBz6BQVN34Jo3JGvQiqlukQZYoRTce7ahB
HZl1kCdm516ZgaAaki18fMvRwrQtV3WICREo2PJPjvzom0uizLg/baTWkFFQEO5g
gNcK2uHGHg79+5drEM6DEJhOPp1VbAGwYBM2i63YxJ5AjYQDxGk=
=cBWl
-----END PGP SIGNATURE-----

--lbICLZVDhL9/L42y--
