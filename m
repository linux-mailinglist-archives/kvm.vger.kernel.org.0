Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 377BA1150B5
	for <lists+kvm@lfdr.de>; Fri,  6 Dec 2019 13:58:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726193AbfLFM6L (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 6 Dec 2019 07:58:11 -0500
Received: from mga14.intel.com ([192.55.52.115]:43507 "EHLO mga14.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726157AbfLFM6L (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 6 Dec 2019 07:58:11 -0500
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmsmga103.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 06 Dec 2019 04:58:08 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.69,284,1571727600"; 
   d="scan'208";a="206111753"
Received: from joy-optiplex-7040.sh.intel.com (HELO joy-OptiPlex-7040) ([10.239.13.9])
  by orsmga008.jf.intel.com with ESMTP; 06 Dec 2019 04:58:06 -0800
Date:   Fri, 6 Dec 2019 07:49:56 -0500
From:   Yan Zhao <yan.y.zhao@intel.com>
To:     Jason Wang <jasowang@redhat.com>
Cc:     "alex.williamson@redhat.com" <alex.williamson@redhat.com>,
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
Message-ID: <20191206124956.GI31791@joy-OptiPlex-7040>
Reply-To: Yan Zhao <yan.y.zhao@intel.com>
References: <20191205032419.29606-1-yan.y.zhao@intel.com>
 <8bcf603c-f142-f96d-bb11-834d686f5519@redhat.com>
 <20191205085111.GD31791@joy-OptiPlex-7040>
 <fe84dba6-5af7-daad-3102-9fa86a90aa4d@redhat.com>
 <20191206082232.GH31791@joy-OptiPlex-7040>
 <8b97a35c-184c-cc87-4b4f-de5a1fa380a3@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <8b97a35c-184c-cc87-4b4f-de5a1fa380a3@redhat.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Dec 06, 2019 at 05:40:02PM +0800, Jason Wang wrote:
> 
> On 2019/12/6 下午4:22, Yan Zhao wrote:
> > On Thu, Dec 05, 2019 at 09:05:54PM +0800, Jason Wang wrote:
> >> On 2019/12/5 下午4:51, Yan Zhao wrote:
> >>> On Thu, Dec 05, 2019 at 02:33:19PM +0800, Jason Wang wrote:
> >>>> Hi:
> >>>>
> >>>> On 2019/12/5 上午11:24, Yan Zhao wrote:
> >>>>> For SRIOV devices, VFs are passthroughed into guest directly without host
> >>>>> driver mediation. However, when VMs migrating with passthroughed VFs,
> >>>>> dynamic host mediation is required to  (1) get device states, (2) get
> >>>>> dirty pages. Since device states as well as other critical information
> >>>>> required for dirty page tracking for VFs are usually retrieved from PFs,
> >>>>> it is handy to provide an extension in PF driver to centralizingly control
> >>>>> VFs' migration.
> >>>>>
> >>>>> Therefore, in order to realize (1) passthrough VFs at normal time, (2)
> >>>>> dynamically trap VFs' bars for dirty page tracking and
> >>>> A silly question, what's the reason for doing this, is this a must for dirty
> >>>> page tracking?
> >>>>
> >>> For performance consideration. VFs' bars should be passthoughed at
> >>> normal time and only enter into trap state on need.
> >>
> >> Right, but how does this matter for the case of dirty page tracking?
> >>
> > Take NIC as an example, to trap its VF dirty pages, software way is
> > required to trap every write of ring tail that resides in BAR0.
> 
> 
> Interesting, but it looks like we need:
> - decode the instruction
> - mediate all access to BAR0
> All of which seems a great burden for the VF driver. I wonder whether or 
> not doing interrupt relay and tracking head is better in this case.
>
hi Jason

not familiar with the way you mentioned. could you elaborate more?
> 
> >   There's
> > still no IOMMU Dirty bit available.
> >>>>>     (3) centralizing
> >>>>> VF critical states retrieving and VF controls into one driver, we propose
> >>>>> to introduce mediate ops on top of current vfio-pci device driver.
> >>>>>
> >>>>>
> >>>>>                                       _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _
> >>>>>     __________   register mediate ops|  ___________     ___________    |
> >>>>> |          |<-----------------------|     VF    |   |           |
> >>>>> | vfio-pci |                      | |  mediate  |   | PF driver |   |
> >>>>> |__________|----------------------->|   driver  |   |___________|
> >>>>>         |            open(pdev)      |  -----------          |         |
> >>>>>         |                                                    |
> >>>>>         |                            |_ _ _ _ _ _ _ _ _ _ _ _|_ _ _ _ _|
> >>>>>        \|/                                                  \|/
> >>>>> -----------                                         ------------
> >>>>> |    VF   |                                         |    PF    |
> >>>>> -----------                                         ------------
> >>>>>
> >>>>>
> >>>>> VF mediate driver could be a standalone driver that does not bind to
> >>>>> any devices (as in demo code in patches 5-6) or it could be a built-in
> >>>>> extension of PF driver (as in patches 7-9) .
> >>>>>
> >>>>> Rather than directly bind to VF, VF mediate driver register a mediate
> >>>>> ops into vfio-pci in driver init. vfio-pci maintains a list of such
> >>>>> mediate ops.
> >>>>> (Note that: VF mediate driver can register mediate ops into vfio-pci
> >>>>> before vfio-pci binding to any devices. And VF mediate driver can
> >>>>> support mediating multiple devices.)
> >>>>>
> >>>>> When opening a device (e.g. a VF), vfio-pci goes through the mediate ops
> >>>>> list and calls each vfio_pci_mediate_ops->open() with pdev of the opening
> >>>>> device as a parameter.
> >>>>> VF mediate driver should return success or failure depending on it
> >>>>> supports the pdev or not.
> >>>>> E.g. VF mediate driver would compare its supported VF devfn with the
> >>>>> devfn of the passed-in pdev.
> >>>>> Once vfio-pci finds a successful vfio_pci_mediate_ops->open(), it will
> >>>>> stop querying other mediate ops and bind the opening device with this
> >>>>> mediate ops using the returned mediate handle.
> >>>>>
> >>>>> Further vfio-pci ops (VFIO_DEVICE_GET_REGION_INFO ioctl, rw, mmap) on the
> >>>>> VF will be intercepted into VF mediate driver as
> >>>>> vfio_pci_mediate_ops->get_region_info(),
> >>>>> vfio_pci_mediate_ops->rw,
> >>>>> vfio_pci_mediate_ops->mmap, and get customized.
> >>>>> For vfio_pci_mediate_ops->rw and vfio_pci_mediate_ops->mmap, they will
> >>>>> further return 'pt' to indicate whether vfio-pci should further
> >>>>> passthrough data to hw.
> >>>>>
> >>>>> when vfio-pci closes the VF, it calls its vfio_pci_mediate_ops->release()
> >>>>> with a mediate handle as parameter.
> >>>>>
> >>>>> The mediate handle returned from vfio_pci_mediate_ops->open() lets VF
> >>>>> mediate driver be able to differentiate two opening VFs of the same device
> >>>>> id and vendor id.
> >>>>>
> >>>>> When VF mediate driver exits, it unregisters its mediate ops from
> >>>>> vfio-pci.
> >>>>>
> >>>>>
> >>>>> In this patchset, we enable vfio-pci to provide 3 things:
> >>>>> (1) calling mediate ops to allow vendor driver customizing default
> >>>>> region info/rw/mmap of a region.
> >>>>> (2) provide a migration region to support migration
> >>>> What's the benefit of introducing a region? It looks to me we don't expect
> >>>> the region to be accessed directly from guest. Could we simply extend device
> >>>> fd ioctl for doing such things?
> >>>>
> >>> You may take a look on mdev live migration discussions in
> >>> https://lists.gnu.org/archive/html/qemu-devel/2019-11/msg01763.html
> >>>
> >>> or previous discussion at
> >>> https://lists.gnu.org/archive/html/qemu-devel/2019-02/msg04908.html,
> >>> which has kernel side implemetation https://patchwork.freedesktop.org/series/56876/
> >>>
> >>> generaly speaking, qemu part of live migration is consistent for
> >>> vfio-pci + mediate ops way or mdev way.
> >>
> >> So in mdev, do you still have a mediate driver? Or you expect the parent
> >> to implement the region?
> >>
> > No, currently it's only for vfio-pci.
> 
> And specific to PCI.
> 
> > mdev parent driver is free to customize its regions and hence does not
> > requires this mediate ops hooks.
> >
> >>> The region is only a channel for
> >>> QEMU and kernel to communicate information without introducing IOCTLs.
> >>
> >> Well, at least you introduce new type of region in uapi. So this does
> >> not answer why region is better than ioctl. If the region will only be
> >> used by qemu, using ioctl is much more easier and straightforward.
> >>
> > It's not introduced by me :)
> > mdev live migration is actually using this way, I'm just keeping
> > compatible to the uapi.
> 
> 
> I meant e.g VFIO_REGION_TYPE_MIGRATION.
>
here's the history of vfio live migration:
https://lists.gnu.org/archive/html/qemu-devel/2017-06/msg05564.html
https://lists.gnu.org/archive/html/qemu-devel/2019-02/msg04908.html
https://lists.gnu.org/archive/html/qemu-devel/2019-11/msg01763.html

If you have any concern of this region way, feel free to comment to the
latest v9 patchset: 
https://lists.gnu.org/archive/html/qemu-devel/2019-11/msg01763.html

The patchset here will always keep compatible to there.
> 
> >
> >  From my own perspective, my answer is that a region is more flexible
> > compared to ioctl. vendor driver can freely define the size,
> >
> 
> Probably not since it's an ABI I think.
> 
that's why I need to define VFIO_REGION_TYPE_MIGRATION here in this
patchset, as it's not upstreamed yet.
maybe I should make it into a prerequisite patch, indicating it is not
introduced by this patchset

> >   mmap cap of
> > its data subregion.
> >
> 
> It doesn't help much unless it can be mapped into guest (which I don't 
> think it was the case here).
> 
it's access by host qemu, the same as how linux app access an mmaped
memory. the mmap here is to reduce memory copy from kernel to user.
No need to get mapped into guest.

> >   Also, there're already too many ioctls in vfio.
> 
> Probably not :) We had a brunch of  subsystems that have much more 
> ioctls than VFIO. (e.g DRM)
>

> >>>
> >>>>> (3) provide a dynamic trap bar info region to allow vendor driver
> >>>>> control trap/untrap of device pci bars
> >>>>>
> >>>>> This vfio-pci + mediate ops way differs from mdev way in that
> >>>>> (1) medv way needs to create a 1:1 mdev device on top of one VF, device
> >>>>> specific mdev parent driver is bound to VF directly.
> >>>>> (2) vfio-pci + mediate ops way does not create mdev devices and VF
> >>>>> mediate driver does not bind to VFs. Instead, vfio-pci binds to VFs.
> >>>>>
> >>>>> The reason why we don't choose the way of writing mdev parent driver is
> >>>>> that
> >>>>> (1) VFs are almost all the time directly passthroughed. Directly binding
> >>>>> to vfio-pci can make most of the code shared/reused.
> >>>> Can we split out the common parts from vfio-pci?
> >>>>
> >>> That's very attractive. but one cannot implement a vfio-pci except
> >>> export everything in it as common part :)
> >>
> >> Well, I think there should be not hard to do that. E..g you can route it
> >> back to like:
> >>
> >> vfio -> vfio_mdev -> parent -> vfio_pci
> >>
> > it's desired for us to have mediate driver binding to PF device.
> > so once a VF device is created, only PF driver and vfio-pci are
> > required. Just the same as what needs to be done for a normal VF passthrough.
> > otherwise, a separate parent driver binding to VF is required.
> > Also, this parent driver has many drawbacks as I mentions in this
> > cover-letter.
> 
> Well, as discussed, no need to duplicate the code, bar trick should 
> still work. The main issues I saw with this proposal is:
> 
> 1) PCI specific, other bus may need something similar
vfio-pci is only for PCI of course.

> 2) Function duplicated with mdev and mdev can do even more
> 
could you elaborate how mdev can do solve the above saying problem ?
> 
> >>>>>     If we write a
> >>>>> vendor specific mdev parent driver, most of the code (like passthrough
> >>>>> style of rw/mmap) still needs to be copied from vfio-pci driver, which is
> >>>>> actually a duplicated and tedious work.
> >>>> The mediate ops looks quite similar to what vfio-mdev did. And it looks to
> >>>> me we need to consider live migration for mdev as well. In that case, do we
> >>>> still expect mediate ops through VFIO directly?
> >>>>
> >>>>
> >>>>> (2) For features like dynamically trap/untrap pci bars, if they are in
> >>>>> vfio-pci, they can be available to most people without repeated code
> >>>>> copying and re-testing.
> >>>>> (3) with a 1:1 mdev driver which passthrough VFs most of the time, people
> >>>>> have to decide whether to bind VFs to vfio-pci or mdev parent driver before
> >>>>> it runs into a real migration need. However, if vfio-pci is bound
> >>>>> initially, they have no chance to do live migration when there's a need
> >>>>> later.
> >>>> We can teach management layer to do this.
> >>>>
> >>> No. not possible as vfio-pci by default has no migration region and
> >>> dirty page tracking needs vendor's mediation at least for most
> >>> passthrough devices now.
> >>
> >> I'm not quite sure I get here but in this case, just tech them to use
> >> the driver that has migration support?
> >>
> > That's a way, but as more and more passthrough devices have demands and
> > caps to do migration, will vfio-pci be used in future any more ?
> 
> 
> This should not be a problem:
> - If we introduce a common mdev for vfio-pci, we can just bind that 
> driver always
what is common mdev for vfio-pci? a common mdev parent driver that have
the same implementation as vfio-pci?

There's actually already a solution of creating only one mdev on top
of each passthrough device, and make mdev share the same iommu group
with it. We've also made an implementation on it already. here's a
sample one made by Yi at https://patchwork.kernel.org/cover/11134695/.

But, as I said, it's desired to re-use vfio-pci directly for SRIOV,
which is straghtforward :)

> - The most straightforward way to support dirty page tracking is done by 
> IOMMU instead of device specific operations.
>
No such IOMMU yet. And all kinds of platforms should be cared, right?

Thanks
Yan

> Thanks
> 
> >
> > Thanks
> > Yan
> >
> >> Thanks
> >>
> >>
> >>> Thanks
> >>> Yn
> >>>
> >>>> Thanks
> >>>>
> >>>>
> >>>>> In this patchset,
> >>>>> - patches 1-4 enable vfio-pci to call mediate ops registered by vendor
> >>>>>      driver to mediate/customize region info/rw/mmap.
> >>>>>
> >>>>> - patches 5-6 provide a standalone sample driver to register a mediate ops
> >>>>>      for Intel Graphics Devices. It does not bind to IGDs directly but decides
> >>>>>      what devices it supports via its pciidlist. It also demonstrates how to
> >>>>>      dynamic trap a device's PCI bars. (by adding more pciids in its
> >>>>>      pciidlist, this sample driver actually is not necessarily limited to
> >>>>>      support IGDs)
> >>>>>
> >>>>> - patch 7-9 provide a sample on i40e driver that supports Intel(R)
> >>>>>      Ethernet Controller XL710 Family of devices. It supports VF precopy live
> >>>>>      migration on Intel's 710 SRIOV. (but we commented out the real
> >>>>>      implementation of dirty page tracking and device state retrieving part
> >>>>>      to focus on demonstrating framework part. Will send out them in future
> >>>>>      versions)
> >>>>>      patch 7 registers/unregisters VF mediate ops when PF driver
> >>>>>      probes/removes. It specifies its supporting VFs via
> >>>>>      vfio_pci_mediate_ops->open(pdev)
> >>>>>
> >>>>>      patch 8 reports device cap of VFIO_PCI_DEVICE_CAP_MIGRATION and
> >>>>>      provides a sample implementation of migration region.
> >>>>>      The QEMU part of vfio migration is based on v8
> >>>>>      https://lists.gnu.org/archive/html/qemu-devel/2019-08/msg05542.html.
> >>>>>      We do not based on recent v9 because we think there are still opens in
> >>>>>      dirty page track part in that series.
> >>>>>
> >>>>>      patch 9 reports device cap of VFIO_PCI_DEVICE_CAP_DYNAMIC_TRAP_BAR and
> >>>>>      provides an example on how to trap part of bar0 when migration starts
> >>>>>      and passthrough this part of bar0 again when migration fails.
> >>>>>
> >>>>> Yan Zhao (9):
> >>>>>      vfio/pci: introduce mediate ops to intercept vfio-pci ops
> >>>>>      vfio/pci: test existence before calling region->ops
> >>>>>      vfio/pci: register a default migration region
> >>>>>      vfio-pci: register default dynamic-trap-bar-info region
> >>>>>      samples/vfio-pci/igd_dt: sample driver to mediate a passthrough IGD
> >>>>>      sample/vfio-pci/igd_dt: dynamically trap/untrap subregion of IGD bar0
> >>>>>      i40e/vf_migration: register mediate_ops to vfio-pci
> >>>>>      i40e/vf_migration: mediate migration region
> >>>>>      i40e/vf_migration: support dynamic trap of bar0
> >>>>>
> >>>>>     drivers/net/ethernet/intel/Kconfig            |   2 +-
> >>>>>     drivers/net/ethernet/intel/i40e/Makefile      |   3 +-
> >>>>>     drivers/net/ethernet/intel/i40e/i40e.h        |   2 +
> >>>>>     drivers/net/ethernet/intel/i40e/i40e_main.c   |   3 +
> >>>>>     .../ethernet/intel/i40e/i40e_vf_migration.c   | 626 ++++++++++++++++++
> >>>>>     .../ethernet/intel/i40e/i40e_vf_migration.h   |  78 +++
> >>>>>     drivers/vfio/pci/vfio_pci.c                   | 189 +++++-
> >>>>>     drivers/vfio/pci/vfio_pci_private.h           |   2 +
> >>>>>     include/linux/vfio.h                          |  18 +
> >>>>>     include/uapi/linux/vfio.h                     | 160 +++++
> >>>>>     samples/Kconfig                               |   6 +
> >>>>>     samples/Makefile                              |   1 +
> >>>>>     samples/vfio-pci/Makefile                     |   2 +
> >>>>>     samples/vfio-pci/igd_dt.c                     | 367 ++++++++++
> >>>>>     14 files changed, 1455 insertions(+), 4 deletions(-)
> >>>>>     create mode 100644 drivers/net/ethernet/intel/i40e/i40e_vf_migration.c
> >>>>>     create mode 100644 drivers/net/ethernet/intel/i40e/i40e_vf_migration.h
> >>>>>     create mode 100644 samples/vfio-pci/Makefile
> >>>>>     create mode 100644 samples/vfio-pci/igd_dt.c
> >>>>>
> 
