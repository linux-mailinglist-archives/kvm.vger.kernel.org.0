Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4AE251156AC
	for <lists+kvm@lfdr.de>; Fri,  6 Dec 2019 18:43:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726415AbfLFRnC (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 6 Dec 2019 12:43:02 -0500
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:39289 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726315AbfLFRnB (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 6 Dec 2019 12:43:01 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1575654179;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Dkvrev2wmPbJB9lI76+JG3E561zyQxHjuRmpbIOPn/8=;
        b=dzDgjowr29W8F4F4bX30VGqt6g+QRPpHyv+WBm21AdCwD/SzO+z/dwpf4Dd2OMWL8QL21l
        IX4A9fhgZg5lyH2DjbC3W/skbKHj3Wyh9C62ooYs4SI4g4wMWdTptVgZmChq3z51hw78i/
        KVljhUHk+WMFZ8hvG0D3g95SSSs8sUc=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-379-yLVVTb0-OuyIaz5L7-iEpQ-1; Fri, 06 Dec 2019 12:42:57 -0500
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 912D91005514;
        Fri,  6 Dec 2019 17:42:55 +0000 (UTC)
Received: from x1.home (ovpn-116-56.phx2.redhat.com [10.3.116.56])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 46EA21001B2D;
        Fri,  6 Dec 2019 17:42:51 +0000 (UTC)
Date:   Fri, 6 Dec 2019 10:42:50 -0700
From:   Alex Williamson <alex.williamson@redhat.com>
To:     Jason Wang <jasowang@redhat.com>
Cc:     Yan Zhao <yan.y.zhao@intel.com>,
        "Tian, Kevin" <kevin.tian@intel.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "libvir-list@redhat.com" <libvir-list@redhat.com>,
        "cohuck@redhat.com" <cohuck@redhat.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "zhenyuw@linux.intel.com" <zhenyuw@linux.intel.com>,
        "qemu-devel@nongnu.org" <qemu-devel@nongnu.org>,
        "He, Shaopeng" <shaopeng.he@intel.com>,
        "Wang, Zhi A" <zhi.a.wang@intel.com>
Subject: Re: [RFC PATCH 0/9] Introduce mediate ops in vfio-pci
Message-ID: <20191206104250.770f2154@x1.home>
In-Reply-To: <8b97a35c-184c-cc87-4b4f-de5a1fa380a3@redhat.com>
References: <20191205032419.29606-1-yan.y.zhao@intel.com>
        <8bcf603c-f142-f96d-bb11-834d686f5519@redhat.com>
        <20191205085111.GD31791@joy-OptiPlex-7040>
        <fe84dba6-5af7-daad-3102-9fa86a90aa4d@redhat.com>
        <20191206082232.GH31791@joy-OptiPlex-7040>
        <8b97a35c-184c-cc87-4b4f-de5a1fa380a3@redhat.com>
Organization: Red Hat
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
X-MC-Unique: yLVVTb0-OuyIaz5L7-iEpQ-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, 6 Dec 2019 17:40:02 +0800
Jason Wang <jasowang@redhat.com> wrote:

> On 2019/12/6 =E4=B8=8B=E5=8D=884:22, Yan Zhao wrote:
> > On Thu, Dec 05, 2019 at 09:05:54PM +0800, Jason Wang wrote: =20
> >> On 2019/12/5 =E4=B8=8B=E5=8D=884:51, Yan Zhao wrote: =20
> >>> On Thu, Dec 05, 2019 at 02:33:19PM +0800, Jason Wang wrote: =20
> >>>> Hi:
> >>>>
> >>>> On 2019/12/5 =E4=B8=8A=E5=8D=8811:24, Yan Zhao wrote: =20
> >>>>> For SRIOV devices, VFs are passthroughed into guest directly withou=
t host
> >>>>> driver mediation. However, when VMs migrating with passthroughed VF=
s,
> >>>>> dynamic host mediation is required to  (1) get device states, (2) g=
et
> >>>>> dirty pages. Since device states as well as other critical informat=
ion
> >>>>> required for dirty page tracking for VFs are usually retrieved from=
 PFs,
> >>>>> it is handy to provide an extension in PF driver to centralizingly =
control
> >>>>> VFs' migration.
> >>>>>
> >>>>> Therefore, in order to realize (1) passthrough VFs at normal time, =
(2)
> >>>>> dynamically trap VFs' bars for dirty page tracking and =20
> >>>> A silly question, what's the reason for doing this, is this a must f=
or dirty
> >>>> page tracking?
> >>>> =20
> >>> For performance consideration. VFs' bars should be passthoughed at
> >>> normal time and only enter into trap state on need. =20
> >>
> >> Right, but how does this matter for the case of dirty page tracking?
> >> =20
> > Take NIC as an example, to trap its VF dirty pages, software way is
> > required to trap every write of ring tail that resides in BAR0. =20
>=20
>=20
> Interesting, but it looks like we need:
> - decode the instruction
> - mediate all access to BAR0
> All of which seems a great burden for the VF driver. I wonder whether or=
=20
> not doing interrupt relay and tracking head is better in this case.

This sounds like a NIC specific solution, I believe the goal here is to
allow any device type to implement a partial mediation solution, in
this case to sufficiently track the device while in the migration
saving state.

> >   There's
> > still no IOMMU Dirty bit available. =20
> >>>>>     (3) centralizing
> >>>>> VF critical states retrieving and VF controls into one driver, we p=
ropose
> >>>>> to introduce mediate ops on top of current vfio-pci device driver.
> >>>>>
> >>>>>
> >>>>>                                       _ _ _ _ _ _ _ _ _ _ _ _ _ _ _=
 _ _
> >>>>>     __________   register mediate ops|  ___________     ___________=
    |
> >>>>> |          |<-----------------------|     VF    |   |           |
> >>>>> | vfio-pci |                      | |  mediate  |   | PF driver |  =
 |
> >>>>> |__________|----------------------->|   driver  |   |___________|
> >>>>>         |            open(pdev)      |  -----------          |     =
    |
> >>>>>         |                                                    |
> >>>>>         |                            |_ _ _ _ _ _ _ _ _ _ _ _|_ _ _=
 _ _|
> >>>>>        \|/                                                  \|/
> >>>>> -----------                                         ------------
> >>>>> |    VF   |                                         |    PF    |
> >>>>> -----------                                         ------------
> >>>>>
> >>>>>
> >>>>> VF mediate driver could be a standalone driver that does not bind t=
o
> >>>>> any devices (as in demo code in patches 5-6) or it could be a built=
-in
> >>>>> extension of PF driver (as in patches 7-9) .
> >>>>>
> >>>>> Rather than directly bind to VF, VF mediate driver register a media=
te
> >>>>> ops into vfio-pci in driver init. vfio-pci maintains a list of such
> >>>>> mediate ops.
> >>>>> (Note that: VF mediate driver can register mediate ops into vfio-pc=
i
> >>>>> before vfio-pci binding to any devices. And VF mediate driver can
> >>>>> support mediating multiple devices.)
> >>>>>
> >>>>> When opening a device (e.g. a VF), vfio-pci goes through the mediat=
e ops
> >>>>> list and calls each vfio_pci_mediate_ops->open() with pdev of the o=
pening
> >>>>> device as a parameter.
> >>>>> VF mediate driver should return success or failure depending on it
> >>>>> supports the pdev or not.
> >>>>> E.g. VF mediate driver would compare its supported VF devfn with th=
e
> >>>>> devfn of the passed-in pdev.
> >>>>> Once vfio-pci finds a successful vfio_pci_mediate_ops->open(), it w=
ill
> >>>>> stop querying other mediate ops and bind the opening device with th=
is
> >>>>> mediate ops using the returned mediate handle.
> >>>>>
> >>>>> Further vfio-pci ops (VFIO_DEVICE_GET_REGION_INFO ioctl, rw, mmap) =
on the
> >>>>> VF will be intercepted into VF mediate driver as
> >>>>> vfio_pci_mediate_ops->get_region_info(),
> >>>>> vfio_pci_mediate_ops->rw,
> >>>>> vfio_pci_mediate_ops->mmap, and get customized.
> >>>>> For vfio_pci_mediate_ops->rw and vfio_pci_mediate_ops->mmap, they w=
ill
> >>>>> further return 'pt' to indicate whether vfio-pci should further
> >>>>> passthrough data to hw.
> >>>>>
> >>>>> when vfio-pci closes the VF, it calls its vfio_pci_mediate_ops->rel=
ease()
> >>>>> with a mediate handle as parameter.
> >>>>>
> >>>>> The mediate handle returned from vfio_pci_mediate_ops->open() lets =
VF
> >>>>> mediate driver be able to differentiate two opening VFs of the same=
 device
> >>>>> id and vendor id.
> >>>>>
> >>>>> When VF mediate driver exits, it unregisters its mediate ops from
> >>>>> vfio-pci.
> >>>>>
> >>>>>
> >>>>> In this patchset, we enable vfio-pci to provide 3 things:
> >>>>> (1) calling mediate ops to allow vendor driver customizing default
> >>>>> region info/rw/mmap of a region.
> >>>>> (2) provide a migration region to support migration =20
> >>>> What's the benefit of introducing a region? It looks to me we don't =
expect
> >>>> the region to be accessed directly from guest. Could we simply exten=
d device
> >>>> fd ioctl for doing such things?
> >>>> =20
> >>> You may take a look on mdev live migration discussions in
> >>> https://lists.gnu.org/archive/html/qemu-devel/2019-11/msg01763.html
> >>>
> >>> or previous discussion at
> >>> https://lists.gnu.org/archive/html/qemu-devel/2019-02/msg04908.html,
> >>> which has kernel side implemetation https://patchwork.freedesktop.org=
/series/56876/
> >>>
> >>> generaly speaking, qemu part of live migration is consistent for
> >>> vfio-pci + mediate ops way or mdev way. =20
> >>
> >> So in mdev, do you still have a mediate driver? Or you expect the pare=
nt
> >> to implement the region?
> >> =20
> > No, currently it's only for vfio-pci. =20
>=20
> And specific to PCI.

What's PCI specific?  The implementation, yes, it's done in the bus
vfio bus driver here but all device access is performed by the bus
driver.  I'm not sure how we could introduce the intercept at the
vfio-core level, but I'm open to suggestions.

> > mdev parent driver is free to customize its regions and hence does not
> > requires this mediate ops hooks.
> > =20
> >>> The region is only a channel for
> >>> QEMU and kernel to communicate information without introducing IOCTLs=
. =20
> >>
> >> Well, at least you introduce new type of region in uapi. So this does
> >> not answer why region is better than ioctl. If the region will only be
> >> used by qemu, using ioctl is much more easier and straightforward.
> >> =20
> > It's not introduced by me :)
> > mdev live migration is actually using this way, I'm just keeping
> > compatible to the uapi. =20
>=20
>=20
> I meant e.g VFIO_REGION_TYPE_MIGRATION.
>=20
>=20
> >
> >  From my own perspective, my answer is that a region is more flexible
> > compared to ioctl. vendor driver can freely define the size,
> > =20
>=20
> Probably not since it's an ABI I think.

I think Kirti's thread proposing the migration interface is a better
place for this discussion, I believe Yan has already linked to it.  In
general we prefer to be frugal in our introduction of new ioctls,
especially when we have existing mechanisms via regions to support the
interactions.  The interface is designed to be flexible to the vendor
driver needs, partially thanks to it being a region.

> >   mmap cap of
> > its data subregion.
> > =20
>=20
> It doesn't help much unless it can be mapped into guest (which I don't=20
> think it was the case here).
>=20
> >   Also, there're already too many ioctls in vfio. =20
>=20
> Probably not :) We had a brunch of=C2=A0 subsystems that have much more=
=20
> ioctls than VFIO. (e.g DRM)

And this is a good thing?  We can more easily deprecate and revise
region support than we can take back ioctls that have been previously
used.  I generally don't like the "let's create a new ioctl for that"
approach versus trying to fit something within the existing
architecture and convention.

> >>>>> (3) provide a dynamic trap bar info region to allow vendor driver
> >>>>> control trap/untrap of device pci bars
> >>>>>
> >>>>> This vfio-pci + mediate ops way differs from mdev way in that
> >>>>> (1) medv way needs to create a 1:1 mdev device on top of one VF, de=
vice
> >>>>> specific mdev parent driver is bound to VF directly.
> >>>>> (2) vfio-pci + mediate ops way does not create mdev devices and VF
> >>>>> mediate driver does not bind to VFs. Instead, vfio-pci binds to VFs=
.
> >>>>>
> >>>>> The reason why we don't choose the way of writing mdev parent drive=
r is
> >>>>> that
> >>>>> (1) VFs are almost all the time directly passthroughed. Directly bi=
nding
> >>>>> to vfio-pci can make most of the code shared/reused. =20
> >>>> Can we split out the common parts from vfio-pci?
> >>>> =20
> >>> That's very attractive. but one cannot implement a vfio-pci except
> >>> export everything in it as common part :) =20
> >>
> >> Well, I think there should be not hard to do that. E..g you can route =
it
> >> back to like:
> >>
> >> vfio -> vfio_mdev -> parent -> vfio_pci
> >> =20
> > it's desired for us to have mediate driver binding to PF device.
> > so once a VF device is created, only PF driver and vfio-pci are
> > required. Just the same as what needs to be done for a normal VF passth=
rough.
> > otherwise, a separate parent driver binding to VF is required.
> > Also, this parent driver has many drawbacks as I mentions in this
> > cover-letter. =20
>=20
> Well, as discussed, no need to duplicate the code, bar trick should=20
> still work. The main issues I saw with this proposal is:
>=20
> 1) PCI specific, other bus may need something similar

Propose how it could be implemented higher in the vfio stack to make it
device agnostic.

> 2) Function duplicated with mdev and mdev can do even more

mdev also comes with a device lifecycle interface that doesn't really
make sense when a driver is only trying to partially mediate a single
physical device rather than multiplex a physical device into virtual
devices.  mdev would also require vendor drivers to re-implement
much of vfio-pci for the direct access mechanisms.  Also, do we really
want users or management tools to decide between binding a device to
vfio-pci or a separate mdev driver to get this functionality.  We've
already been burnt trying to use mdev beyond its scope.

> >>>>>     If we write a
> >>>>> vendor specific mdev parent driver, most of the code (like passthro=
ugh
> >>>>> style of rw/mmap) still needs to be copied from vfio-pci driver, wh=
ich is
> >>>>> actually a duplicated and tedious work. =20
> >>>> The mediate ops looks quite similar to what vfio-mdev did. And it lo=
oks to
> >>>> me we need to consider live migration for mdev as well. In that case=
, do we
> >>>> still expect mediate ops through VFIO directly?
> >>>>
> >>>> =20
> >>>>> (2) For features like dynamically trap/untrap pci bars, if they are=
 in
> >>>>> vfio-pci, they can be available to most people without repeated cod=
e
> >>>>> copying and re-testing.
> >>>>> (3) with a 1:1 mdev driver which passthrough VFs most of the time, =
people
> >>>>> have to decide whether to bind VFs to vfio-pci or mdev parent drive=
r before
> >>>>> it runs into a real migration need. However, if vfio-pci is bound
> >>>>> initially, they have no chance to do live migration when there's a =
need
> >>>>> later. =20
> >>>> We can teach management layer to do this.
> >>>> =20
> >>> No. not possible as vfio-pci by default has no migration region and
> >>> dirty page tracking needs vendor's mediation at least for most
> >>> passthrough devices now. =20
> >>
> >> I'm not quite sure I get here but in this case, just tech them to use
> >> the driver that has migration support?
> >> =20
> > That's a way, but as more and more passthrough devices have demands and
> > caps to do migration, will vfio-pci be used in future any more ? =20
>=20
>=20
> This should not be a problem:
> - If we introduce a common mdev for vfio-pci, we can just bind that=20
> driver always

There's too much of mdev that doesn't make sense for this usage model,
this is why Yi's proposed generic mdev PCI wrapper is only a sample
driver.  I think we do not want to introduce user confusion regarding
which driver to use and there are outstanding non-singleton group
issues with mdev that don't seem worthwhile to resolve.

> - The most straightforward way to support dirty page tracking is done by=
=20
> IOMMU instead of device specific operations.

Of course, but it doesn't exist yet.  We're attempting to design the
dirty page tracking in a way that's mostly transparent for current mdev
drivers, would provide generic support for IOMMU-based dirty tracking,
and extensible to the inevitability of vendor driver tracking.  Thanks,

Alex

