Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BA99D11D5F3
	for <lists+kvm@lfdr.de>; Thu, 12 Dec 2019 19:40:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730464AbfLLSjy (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 12 Dec 2019 13:39:54 -0500
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:37429 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1730427AbfLLSjy (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 12 Dec 2019 13:39:54 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1576175991;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Jixy/uOK0lYfwEbWZHcDrcSwWNy6LONfxAw9+gibE30=;
        b=bExda3QX2xmuZ+1koSWIcM7EjcxqxxPiz7o/tGXVx+2rqf25JDbnzVosq7PObdqXDsXhZh
        vLmbH1Cy8iVVAQW66pXpctsB5Ekv7oIYjozJOCXjVJ1+8A3M/WaVDl8fSdYPPUisfJx04K
        ixo0T/HDuaOINSrxkXxQDcxJWYDW1CU=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-296-GL5TWOPyO-GpImTb55-8ww-1; Thu, 12 Dec 2019 13:39:47 -0500
X-MC-Unique: GL5TWOPyO-GpImTb55-8ww-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id C81611005502;
        Thu, 12 Dec 2019 18:39:45 +0000 (UTC)
Received: from x1.home (ovpn04.gateway.prod.ext.phx2.redhat.com [10.5.9.4])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 4AA076609A;
        Thu, 12 Dec 2019 18:39:40 +0000 (UTC)
Date:   Thu, 12 Dec 2019 11:39:39 -0700
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
Message-ID: <20191212113939.1989c52f@x1.home>
In-Reply-To: <90723e79-c858-9ba0-3c60-a968656b1233@redhat.com>
References: <20191205032419.29606-1-yan.y.zhao@intel.com>
        <8bcf603c-f142-f96d-bb11-834d686f5519@redhat.com>
        <20191205085111.GD31791@joy-OptiPlex-7040>
        <fe84dba6-5af7-daad-3102-9fa86a90aa4d@redhat.com>
        <20191206082232.GH31791@joy-OptiPlex-7040>
        <8b97a35c-184c-cc87-4b4f-de5a1fa380a3@redhat.com>
        <20191206104250.770f2154@x1.home>
        <90723e79-c858-9ba0-3c60-a968656b1233@redhat.com>
Organization: Red Hat
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, 12 Dec 2019 12:09:48 +0800
Jason Wang <jasowang@redhat.com> wrote:

> On 2019/12/7 =E4=B8=8A=E5=8D=881:42, Alex Williamson wrote:
> > On Fri, 6 Dec 2019 17:40:02 +0800
> > Jason Wang <jasowang@redhat.com> wrote:
> > =20
> >> On 2019/12/6 =E4=B8=8B=E5=8D=884:22, Yan Zhao wrote: =20
> >>> On Thu, Dec 05, 2019 at 09:05:54PM +0800, Jason Wang wrote: =20
> >>>> On 2019/12/5 =E4=B8=8B=E5=8D=884:51, Yan Zhao wrote: =20
> >>>>> On Thu, Dec 05, 2019 at 02:33:19PM +0800, Jason Wang wrote: =20
> >>>>>> Hi:
> >>>>>>
> >>>>>> On 2019/12/5 =E4=B8=8A=E5=8D=8811:24, Yan Zhao wrote: =20
> >>>>>>> For SRIOV devices, VFs are passthroughed into guest directly with=
out host
> >>>>>>> driver mediation. However, when VMs migrating with passthroughed =
VFs,
> >>>>>>> dynamic host mediation is required to  (1) get device states, (2)=
 get
> >>>>>>> dirty pages. Since device states as well as other critical inform=
ation
> >>>>>>> required for dirty page tracking for VFs are usually retrieved fr=
om PFs,
> >>>>>>> it is handy to provide an extension in PF driver to centralizingl=
y control
> >>>>>>> VFs' migration.
> >>>>>>>
> >>>>>>> Therefore, in order to realize (1) passthrough VFs at normal time=
, (2)
> >>>>>>> dynamically trap VFs' bars for dirty page tracking and =20
> >>>>>> A silly question, what's the reason for doing this, is this a must=
 for dirty
> >>>>>> page tracking?
> >>>>>>    =20
> >>>>> For performance consideration. VFs' bars should be passthoughed at
> >>>>> normal time and only enter into trap state on need. =20
> >>>> Right, but how does this matter for the case of dirty page tracking?
> >>>>    =20
> >>> Take NIC as an example, to trap its VF dirty pages, software way is
> >>> required to trap every write of ring tail that resides in BAR0. =20
> >>
> >> Interesting, but it looks like we need:
> >> - decode the instruction
> >> - mediate all access to BAR0
> >> All of which seems a great burden for the VF driver. I wonder whether =
or
> >> not doing interrupt relay and tracking head is better in this case. =20
> > This sounds like a NIC specific solution, I believe the goal here is to
> > allow any device type to implement a partial mediation solution, in
> > this case to sufficiently track the device while in the migration
> > saving state. =20
>=20
>=20
> I suspect there's a solution that can work for any device type. E.g for=20
> virtio, avail index (head) doesn't belongs to any BAR and device may=20
> decide to disable doorbell from guest. So did interrupt relay since=20
> driver may choose to disable interrupt from device. In this case, the=20
> only way to track dirty pages correctly is to switch to software datapath.
>=20
>=20
> > =20
> >>>    There's
> >>> still no IOMMU Dirty bit available. =20
> >>>>>>>      (3) centralizing
> >>>>>>> VF critical states retrieving and VF controls into one driver, we=
 propose
> >>>>>>> to introduce mediate ops on top of current vfio-pci device driver.
> >>>>>>>
> >>>>>>>
> >>>>>>>                                        _ _ _ _ _ _ _ _ _ _ _ _ _ =
_ _ _ _
> >>>>>>>      __________   register mediate ops|  ___________     ________=
___    |
> >>>>>>> |          |<-----------------------|     VF    |   |           |
> >>>>>>> | vfio-pci |                      | |  mediate  |   | PF driver |=
   |
> >>>>>>> |__________|----------------------->|   driver  |   |___________|
> >>>>>>>          |            open(pdev)      |  -----------          |  =
       |
> >>>>>>>          |                                                    |
> >>>>>>>          |                            |_ _ _ _ _ _ _ _ _ _ _ _|_ =
_ _ _ _|
> >>>>>>>         \|/                                                  \|/
> >>>>>>> -----------                                         ------------
> >>>>>>> |    VF   |                                         |    PF    |
> >>>>>>> -----------                                         ------------
> >>>>>>>
> >>>>>>>
> >>>>>>> VF mediate driver could be a standalone driver that does not bind=
 to
> >>>>>>> any devices (as in demo code in patches 5-6) or it could be a bui=
lt-in
> >>>>>>> extension of PF driver (as in patches 7-9) .
> >>>>>>>
> >>>>>>> Rather than directly bind to VF, VF mediate driver register a med=
iate
> >>>>>>> ops into vfio-pci in driver init. vfio-pci maintains a list of su=
ch
> >>>>>>> mediate ops.
> >>>>>>> (Note that: VF mediate driver can register mediate ops into vfio-=
pci
> >>>>>>> before vfio-pci binding to any devices. And VF mediate driver can
> >>>>>>> support mediating multiple devices.)
> >>>>>>>
> >>>>>>> When opening a device (e.g. a VF), vfio-pci goes through the medi=
ate ops
> >>>>>>> list and calls each vfio_pci_mediate_ops->open() with pdev of the=
 opening
> >>>>>>> device as a parameter.
> >>>>>>> VF mediate driver should return success or failure depending on it
> >>>>>>> supports the pdev or not.
> >>>>>>> E.g. VF mediate driver would compare its supported VF devfn with =
the
> >>>>>>> devfn of the passed-in pdev.
> >>>>>>> Once vfio-pci finds a successful vfio_pci_mediate_ops->open(), it=
 will
> >>>>>>> stop querying other mediate ops and bind the opening device with =
this
> >>>>>>> mediate ops using the returned mediate handle.
> >>>>>>>
> >>>>>>> Further vfio-pci ops (VFIO_DEVICE_GET_REGION_INFO ioctl, rw, mmap=
) on the
> >>>>>>> VF will be intercepted into VF mediate driver as
> >>>>>>> vfio_pci_mediate_ops->get_region_info(),
> >>>>>>> vfio_pci_mediate_ops->rw,
> >>>>>>> vfio_pci_mediate_ops->mmap, and get customized.
> >>>>>>> For vfio_pci_mediate_ops->rw and vfio_pci_mediate_ops->mmap, they=
 will
> >>>>>>> further return 'pt' to indicate whether vfio-pci should further
> >>>>>>> passthrough data to hw.
> >>>>>>>
> >>>>>>> when vfio-pci closes the VF, it calls its vfio_pci_mediate_ops->r=
elease()
> >>>>>>> with a mediate handle as parameter.
> >>>>>>>
> >>>>>>> The mediate handle returned from vfio_pci_mediate_ops->open() let=
s VF
> >>>>>>> mediate driver be able to differentiate two opening VFs of the sa=
me device
> >>>>>>> id and vendor id.
> >>>>>>>
> >>>>>>> When VF mediate driver exits, it unregisters its mediate ops from
> >>>>>>> vfio-pci.
> >>>>>>>
> >>>>>>>
> >>>>>>> In this patchset, we enable vfio-pci to provide 3 things:
> >>>>>>> (1) calling mediate ops to allow vendor driver customizing default
> >>>>>>> region info/rw/mmap of a region.
> >>>>>>> (2) provide a migration region to support migration =20
> >>>>>> What's the benefit of introducing a region? It looks to me we don'=
t expect
> >>>>>> the region to be accessed directly from guest. Could we simply ext=
end device
> >>>>>> fd ioctl for doing such things?
> >>>>>>    =20
> >>>>> You may take a look on mdev live migration discussions in
> >>>>> https://lists.gnu.org/archive/html/qemu-devel/2019-11/msg01763.html
> >>>>>
> >>>>> or previous discussion at
> >>>>> https://lists.gnu.org/archive/html/qemu-devel/2019-02/msg04908.html,
> >>>>> which has kernel side implemetation https://patchwork.freedesktop.o=
rg/series/56876/
> >>>>>
> >>>>> generaly speaking, qemu part of live migration is consistent for
> >>>>> vfio-pci + mediate ops way or mdev way. =20
> >>>> So in mdev, do you still have a mediate driver? Or you expect the pa=
rent
> >>>> to implement the region?
> >>>>    =20
> >>> No, currently it's only for vfio-pci. =20
> >> And specific to PCI. =20
> > What's PCI specific?  The implementation, yes, it's done in the bus
> > vfio bus driver here but all device access is performed by the bus
> > driver.  I'm not sure how we could introduce the intercept at the
> > vfio-core level, but I'm open to suggestions. =20
>=20
>=20
> I haven't thought this too much, but if we can intercept at core level,=20
> it basically can do what mdev can do right now.

An intercept at the core level is essentially a new vfio bus driver.

> >>> mdev parent driver is free to customize its regions and hence does not
> >>> requires this mediate ops hooks.
> >>>    =20
> >>>>> The region is only a channel for
> >>>>> QEMU and kernel to communicate information without introducing IOCT=
Ls. =20
> >>>> Well, at least you introduce new type of region in uapi. So this does
> >>>> not answer why region is better than ioctl. If the region will only =
be
> >>>> used by qemu, using ioctl is much more easier and straightforward.
> >>>>    =20
> >>> It's not introduced by me :)
> >>> mdev live migration is actually using this way, I'm just keeping
> >>> compatible to the uapi. =20
> >>
> >> I meant e.g VFIO_REGION_TYPE_MIGRATION.
> >>
> >> =20
> >>>   From my own perspective, my answer is that a region is more flexible
> >>> compared to ioctl. vendor driver can freely define the size,
> >>>    =20
> >> Probably not since it's an ABI I think. =20
> > I think Kirti's thread proposing the migration interface is a better
> > place for this discussion, I believe Yan has already linked to it.  In
> > general we prefer to be frugal in our introduction of new ioctls,
> > especially when we have existing mechanisms via regions to support the
> > interactions.  The interface is designed to be flexible to the vendor
> > driver needs, partially thanks to it being a region.
> > =20
> >>>    mmap cap of
> >>> its data subregion.
> >>>    =20
> >> It doesn't help much unless it can be mapped into guest (which I don't
> >> think it was the case here).
> >> / =20
> >>>    Also, there're already too many ioctls in vfio. =20
> >> Probably not :) We had a brunch of=C2=A0 subsystems that have much more
> >> ioctls than VFIO. (e.g DRM) =20
> > And this is a good thing? =20
>=20
>=20
> Well, I just meant that "having too much ioctls already" is not a good=20
> reason for not introducing new ones.

Avoiding ioctl proliferation is a reason to require a high bar for any
new ioctl though.  Push back on every ioctl and maybe we won't get to
that point.

> > We can more easily deprecate and revise
> > region support than we can take back ioctls that have been previously
> > used. =20
>=20
>=20
> It belongs to uapi, how easily can we deprecate that?

I'm not saying there shouldn't be a deprecation process, but the core
uapi for vfio remains (relatively) unchanged.  The user has a protocol
for discovering the features of a device and if we decide we've screwed
up the implementation of the migration_region-v1 we can simply add a
migration_region-v2 and both can be exposed via the same core ioctls
until we decide to no longer expose v1.  Our address space of region
types is defined within vfio, not shared with every driver in the
kernel.  The "add an ioctl for that" approach is not the model I
advocate.

> > I generally don't like the "let's create a new ioctl for that"
> > approach versus trying to fit something within the existing
> > architecture and convention.
> > =20
> >>>>>>> (3) provide a dynamic trap bar info region to allow vendor driver
> >>>>>>> control trap/untrap of device pci bars
> >>>>>>>
> >>>>>>> This vfio-pci + mediate ops way differs from mdev way in that
> >>>>>>> (1) medv way needs to create a 1:1 mdev device on top of one VF, =
device
> >>>>>>> specific mdev parent driver is bound to VF directly.
> >>>>>>> (2) vfio-pci + mediate ops way does not create mdev devices and VF
> >>>>>>> mediate driver does not bind to VFs. Instead, vfio-pci binds to V=
Fs.
> >>>>>>>
> >>>>>>> The reason why we don't choose the way of writing mdev parent dri=
ver is
> >>>>>>> that
> >>>>>>> (1) VFs are almost all the time directly passthroughed. Directly =
binding
> >>>>>>> to vfio-pci can make most of the code shared/reused. =20
> >>>>>> Can we split out the common parts from vfio-pci?
> >>>>>>    =20
> >>>>> That's very attractive. but one cannot implement a vfio-pci except
> >>>>> export everything in it as common part :) =20
> >>>> Well, I think there should be not hard to do that. E..g you can rout=
e it
> >>>> back to like:
> >>>>
> >>>> vfio -> vfio_mdev -> parent -> vfio_pci
> >>>>    =20
> >>> it's desired for us to have mediate driver binding to PF device.
> >>> so once a VF device is created, only PF driver and vfio-pci are
> >>> required. Just the same as what needs to be done for a normal VF pass=
through.
> >>> otherwise, a separate parent driver binding to VF is required.
> >>> Also, this parent driver has many drawbacks as I mentions in this
> >>> cover-letter. =20
> >> Well, as discussed, no need to duplicate the code, bar trick should
> >> still work. The main issues I saw with this proposal is:
> >>
> >> 1) PCI specific, other bus may need something similar =20
> > Propose how it could be implemented higher in the vfio stack to make it
> > device agnostic. =20
>=20
>=20
> E.g doing it in vfio_device_fops instead of vfio_pci_ops?

Which is essentially a new vfio bus driver.  This is something vfio has
supported since day one.  Issues with doing that here are that it puts
the burden on the mediation/vendor driver to re-implement or re-use a
lot of existing code in vfio-pci, and I think it creates user confusion
around which driver to use for what feature set when using a device
through vfio.  You're complaining this series is PCI specific, when
re-using the vfio-pci code is exactly what we're trying to achieve.
Other bus types can do something similar and injecting vendor
specific drivers a layer above the bus driver is already a fundamental
part of the infrastructure.

> >> 2) Function duplicated with mdev and mdev can do even more =20
> > mdev also comes with a device lifecycle interface that doesn't really
> > make sense when a driver is only trying to partially mediate a single
> > physical device rather than multiplex a physical device into virtual
> > devices. =20
>=20
>=20
> Yes, but that part could be decoupled out of mdev.

There would be nothing left.  vfio-mdev is essentially nothing more than
a vfio bus driver that forwards through to mdev to provide that
lifecycle interface to the vendor driver.  Without that, it's just
another vfio bus driver.

> >   mdev would also require vendor drivers to re-implement
> > much of vfio-pci for the direct access mechanisms.  Also, do we really
> > want users or management tools to decide between binding a device to
> > vfio-pci or a separate mdev driver to get this functionality.  We've
> > already been burnt trying to use mdev beyond its scope. =20
>=20
>=20
> The problem is, if we had a device that support both SRIOV and mdev.=20
> Does this mean we need prepare two set of drivers?

We have this situation today, modulo SR-IOV, but that's a red herring
anyway, VF vs PF is irrelevant.  For example we can either directly
assign IGD graphics to a VM with vfio-pci or we can enable GVT-g
support in the i915 driver, which registers vGPU support via mdev.
These are different use cases, expose different features, and have
different support models.  NVIDIA is the same way, assigning a GPU via
vfio-pci or a vGPU via vfio-mdev are entirely separate usage models.
Once we use mdev, it's at the vendor driver's discretion how the device
resources are backed, they might make use of the resource isolation of
SR-IOV or they might divide a single function.

If your question is whether there's a concern around proliferation of
vfio bus drivers and user confusion over which to use for what
features, yes, absolutely.  I think this is why we're starting with
seeing what it looks like to add mediation to vfio-pci rather than
modularize vfio-pci and ask Intel to develop a new vfio-pci-intel-dsa
driver.  I'm not yet convinced we won't eventually come back to that
latter approach though if this initial draft is what we can expect of a
mediated vfio-pci.

> >>>>>>>      If we write a
> >>>>>>> vendor specific mdev parent driver, most of the code (like passth=
rough
> >>>>>>> style of rw/mmap) still needs to be copied from vfio-pci driver, =
which is
> >>>>>>> actually a duplicated and tedious work. =20
> >>>>>> The mediate ops looks quite similar to what vfio-mdev did. And it =
looks to
> >>>>>> me we need to consider live migration for mdev as well. In that ca=
se, do we
> >>>>>> still expect mediate ops through VFIO directly?
> >>>>>>
> >>>>>>    =20
> >>>>>>> (2) For features like dynamically trap/untrap pci bars, if they a=
re in
> >>>>>>> vfio-pci, they can be available to most people without repeated c=
ode
> >>>>>>> copying and re-testing.
> >>>>>>> (3) with a 1:1 mdev driver which passthrough VFs most of the time=
, people
> >>>>>>> have to decide whether to bind VFs to vfio-pci or mdev parent dri=
ver before
> >>>>>>> it runs into a real migration need. However, if vfio-pci is bound
> >>>>>>> initially, they have no chance to do live migration when there's =
a need
> >>>>>>> later. =20
> >>>>>> We can teach management layer to do this.
> >>>>>>    =20
> >>>>> No. not possible as vfio-pci by default has no migration region and
> >>>>> dirty page tracking needs vendor's mediation at least for most
> >>>>> passthrough devices now. =20
> >>>> I'm not quite sure I get here but in this case, just tech them to use
> >>>> the driver that has migration support?
> >>>>    =20
> >>> That's a way, but as more and more passthrough devices have demands a=
nd
> >>> caps to do migration, will vfio-pci be used in future any more ? =20
> >>
> >> This should not be a problem:
> >> - If we introduce a common mdev for vfio-pci, we can just bind that
> >> driver always =20
> > There's too much of mdev that doesn't make sense for this usage model,
> > this is why Yi's proposed generic mdev PCI wrapper is only a sample
> > driver.  I think we do not want to introduce user confusion regarding
> > which driver to use and there are outstanding non-singleton group
> > issues with mdev that don't seem worthwhile to resolve. =20
>=20
>=20
> I agree, but I think what user want is a unified driver that works for=20
> both SRIOV and mdev. That's why trying to have a common way for doing=20
> mediation may make sense.

I don't think we can get to one driver, nor is it clear to me that we
should.  Direct assignment and mdev currently provide different usage
models.  Both are valid, both are useful.  That said, I don't
necessarily want a user to need to choose whether to bind a device to
vfio-pci for base functionality or vfio-pci-vendor-foo for extended
functionality either.  I think that's why we're exploring this
mediation approach and there's already precedent in vfio-pci for some
extent of device specific support.  It's still a question though
whether it can be done clean enough to make it worthwhile.  Thanks,

Alex

