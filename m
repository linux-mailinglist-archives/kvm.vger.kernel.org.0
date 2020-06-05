Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E88E81EEF5F
	for <lists+kvm@lfdr.de>; Fri,  5 Jun 2020 04:13:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726022AbgFECNf (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 4 Jun 2020 22:13:35 -0400
Received: from mga12.intel.com ([192.55.52.136]:37038 "EHLO mga12.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725601AbgFECNd (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 4 Jun 2020 22:13:33 -0400
IronPort-SDR: 01CEsNVrnqV8kkESzOoKJS2LJfmyUh90NK5ACBd8q5Qje8Ik1lGljaZPfyf3vtF+1cpaA+a+jS
 w0RMJiadz02Q==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Jun 2020 19:12:31 -0700
IronPort-SDR: uBZCnW47vhqASYTQw67hEfMf2OLrdUlZRX2RjdFTVDlO53dtx/Wg2n95mRNB5KuUs/dCfU0lhD
 YMSXiuq90jVw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.73,474,1583222400"; 
   d="scan'208";a="258549649"
Received: from joy-optiplex-7040.sh.intel.com (HELO joy-OptiPlex-7040) ([10.239.13.16])
  by orsmga007.jf.intel.com with ESMTP; 04 Jun 2020 19:12:28 -0700
Date:   Thu, 4 Jun 2020 22:02:31 -0400
From:   Yan Zhao <yan.y.zhao@intel.com>
To:     Alex Williamson <alex.williamson@redhat.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        cohuck@redhat.com, zhenyuw@linux.intel.com, zhi.a.wang@intel.com,
        kevin.tian@intel.com, shaopeng.he@intel.com, yi.l.liu@intel.com,
        xin.zeng@intel.com, hang.yuan@intel.com
Subject: Re: [RFC PATCH v4 07/10] vfio/pci: introduce a new irq type
 VFIO_IRQ_TYPE_REMAP_BAR_REGION
Message-ID: <20200605020231.GE12300@joy-OptiPlex-7040>
Reply-To: Yan Zhao <yan.y.zhao@intel.com>
References: <20200518025245.14425-1-yan.y.zhao@intel.com>
 <20200529154547.19a6685f@x1.home>
 <20200601065726.GA5906@joy-OptiPlex-7040>
 <20200601104307.259b0fe1@x1.home>
 <20200602082858.GA8915@joy-OptiPlex-7040>
 <20200602133435.1ab650c5@x1.home>
 <20200603014058.GA12300@joy-OptiPlex-7040>
 <20200603170452.7f172baf@x1.home>
 <20200604024228.GD12300@joy-OptiPlex-7040>
 <20200603221058.1927a0fc@x1.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200603221058.1927a0fc@x1.home>
User-Agent: Mutt/1.9.4 (2018-02-28)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Jun 03, 2020 at 10:10:58PM -0600, Alex Williamson wrote:
> On Wed, 3 Jun 2020 22:42:28 -0400
> Yan Zhao <yan.y.zhao@intel.com> wrote:
> 
> > On Wed, Jun 03, 2020 at 05:04:52PM -0600, Alex Williamson wrote:
> > > On Tue, 2 Jun 2020 21:40:58 -0400
> > > Yan Zhao <yan.y.zhao@intel.com> wrote:
> > >   
> > > > On Tue, Jun 02, 2020 at 01:34:35PM -0600, Alex Williamson wrote:  
> > > > > I'm not at all happy with this.  Why do we need to hide the migration
> > > > > sparse mmap from the user until migration time?  What if instead we
> > > > > introduced a new VFIO_REGION_INFO_CAP_SPARSE_MMAP_SAVING capability
> > > > > where the existing capability is the normal runtime sparse setup and
> > > > > the user is required to use this new one prior to enabled device_state
> > > > > with _SAVING.  The vendor driver could then simply track mmap vmas to
> > > > > the region and refuse to change device_state if there are outstanding
> > > > > mmaps conflicting with the _SAVING sparse mmap layout.  No new IRQs
> > > > > required, no new irqfds, an incremental change to the protocol,
> > > > > backwards compatible to the extent that a vendor driver requiring this
> > > > > will automatically fail migration.
> > > > >     
> > > > right. looks we need to use this approach to solve the problem.
> > > > thanks for your guide.
> > > > so I'll abandon the current remap irq way for dirty tracking during live
> > > > migration.
> > > > but anyway, it demos how to customize irq_types in vendor drivers.
> > > > then, what do you think about patches 1-5?  
> > > 
> > > In broad strokes, I don't think we've found the right solution yet.  I
> > > really question whether it's supportable to parcel out vfio-pci like
> > > this and I don't know how I'd support unraveling whether we have a bug
> > > in vfio-pci, the vendor driver, or how the vendor driver is making use
> > > of vfio-pci.
> > >
> > > Let me also ask, why does any of this need to be in the kernel?  We
> > > spend 5 patches slicing up vfio-pci so that we can register a vendor
> > > driver and have that vendor driver call into vfio-pci as it sees fit.
> > > We have two patches creating device specific interrupts and a BAR
> > > remapping scheme that we've decided we don't need.  That brings us to
> > > the actual i40e vendor driver, where the first patch is simply making
> > > the vendor driver work like vfio-pci already does, the second patch is
> > > handling the migration region, and the third patch is implementing the
> > > BAR remapping IRQ that we decided we don't need.  It's difficult to
> > > actually find the small bit of code that's required to support
> > > migration outside of just dealing with the protocol we've defined to
> > > expose this from the kernel.  So why are we trying to do this in the
> > > kernel?  We have quirk support in QEMU, we can easily flip
> > > MemoryRegions on and off, etc.  What access to the device outside of
> > > what vfio-pci provides to the user, and therefore QEMU, is necessary to
> > > implement this migration support for i40e VFs?  Is this just an
> > > exercise in making use of the migration interface?  Thanks,
> > >   
> > hi Alex
> > 
> > There was a description of intention of this series in RFC v1
> > (https://www.spinics.net/lists/kernel/msg3337337.html).
> > sorry, I didn't include it in starting from RFC v2.
> > 
> > "
> > The reason why we don't choose the way of writing mdev parent driver is
> > that
> 
> I didn't mention an mdev approach, I'm asking what are we accomplishing
> by doing this in the kernel at all versus exposing the device as normal
> through vfio-pci and providing the migration support in QEMU.  Are you
> actually leveraging having some sort of access to the PF in supporting
> migration of the VF?  Is vfio-pci masking the device in a way that
> prevents migrating the state from QEMU?
>
yes, communication to PF is required. VF state is managed by PF and is
queried from PF when VF is stopped.

migration support in QEMU seems only suitable to devices with dirty
pages and device state available by reading/writing device MMIOs, which
is not the case for most devices.

> > (1) VFs are almost all the time directly passthroughed. Directly binding
> > to vfio-pci can make most of the code shared/reused. If we write a
> > vendor specific mdev parent driver, most of the code (like passthrough
> > style of rw/mmap) still needs to be copied from vfio-pci driver, which is
> > actually a duplicated and tedious work.
> > (2) For features like dynamically trap/untrap pci bars, if they are in
> > vfio-pci, they can be available to most people without repeated code
> > copying and re-testing.
> > (3) with a 1:1 mdev driver which passes through VFs most of the time, people
> > have to decide whether to bind VFs to vfio-pci or mdev parent driver before
> > it runs into a real migration need. However, if vfio-pci is bound
> > initially, they have no chance to do live migration when there's a need
> > later.
> > "
> > particularly, there're some devices (like NVMe) they purely reply on
> > vfio-pci to do device pass-through and they have no standalone parent driver
> > to do mdev way.
> > 
> > I think live migration is a general requirement for most devices and to
> > interact with the migration interface requires vendor drivers to do
> > device specific tasks like geting/seting device state, starting/stopping
> > devices, tracking dirty data, report migration capabilities... all those
> > works need be in kernel.
> 
> I think Alex Graf proved they don't necessarily need to be done in
> kernel back in 2015: https://www.youtube.com/watch?v=4RFsSgzuFso
> He was able to achieve i40e VF live migration by only hacking QEMU.  In
I checked the qemu code. https://github.com/agraf/qemu/tree/vfio-i40vf.
a new vfio-i40e device type is registered as a child type of vfio-pci, as well
as its exclusive savevm handlers, which are not compatible to Kirti's
general VFIO live migration framework.

> this series you're allowing a vendor driver to interpose itself between
> the user (QEMU) and vfio-pci such that we switch to the vendor code
> during migration.  Why can't that interpose layer be in QEMU rather
> than the kernel?  It seems that it only must be in the kernel if we
> need to provide migration state via backdoor, perhaps like going
> through the PF.  So what access to the i40e VF device is not provided to
> the user through vfio-pci that is necessary to implement migration of
> this device?  The tasks listed above are mostly standard device driver
> activities and clearly vfio-pci allows userspace device drivers.
> 
tasks like interacting with PF driver, preparing resources and tracking dirty
pages in device internal memory, detecting of whether dirty page is able
to be tracked by hardware and reporting migration capabilities, exposing
hardware dirty bitmap buffer... all those are hard to be done in QEMU.

maintaining migration code in kernel can also allow vendors to re-use common
code for devices across generations. e.g. for i40e, in some generations,
software dirty page track is used,  some generations hardware dirty
track is enabled and some other generations leveraging IOMMU A/D bit is
feasible. is QEMU quirks allowing such flexibility as in kernel?

besides, migration version string as a sysfs attribute requires a vendor
driver to generate.

> > do you think it's better to create numerous vendor quirks in vfio-pci?
> 
> In QEMU, perhaps.  Alternatively, let's look at exactly what access is
> not provided through vfio-pci that's necessary for this and decide if
> we want to enable that access or if cracking vfio-pci wide open for
> vendor drivers to pick and choose when and how to use it is really the
> right answer.
> 
I think the position of vendor modules is just like vfio_pci_igd.c under
vfio-pci. the difference is that the vendor modules are able to be
dynamically loaded outside of vfio-pci.

> > as to this series, though patch 9/10 currently only demos reporting a
> > migration region, it actually shows the capability iof vendor driver to
> > customize device regions. e.g. in patch 10/10, it customizes the BAR0 to
> > be read/write. and though we abandoned the REMAP BAR irq_type in patch
> > 10/10 for migration purpose, I have to say this irq_type has its usage
> > in other use cases, where synchronization is not a hard requirement and
> > all it needs is a notification channel from kernel to use. this series
> > just provides a possibility for vendors to customize device regions and
> > irqs.
> 
> I don't disagree that a device specific interrupt might be useful, but
> I would object to implementing this one only as an artificial use case.
> We can wait for a legitimate use case to implement that.
>
ok. sure.

> > for interfaces exported in patch 3/10-5/10, they anyway need to be
> > exported for writing mdev parent drivers that pass through devices at
> > normal time to avoid duplication. and yes, your worry about
> 
> Where are those parent drivers?  What are their actual requirements?
>
if this way of registering vendor ops to vfio-pci is not permitted,
vendors have to resort to writing its mdev parent drivers for VFs. Those
parent drivers need to pass through VFs at normal time, doing exactly what
vfio-pci does and only doing what vendor ops does during migration.

if vfio-pci could export common code to those parent drivers, lots of
duplicated code can be avoided.

> > identification of bug sources is reasonable. but if a device is binding
> > to vfio-pci with a vendor module loaded, and there's a bug, they can do at
> > least two ways to identify if it's a bug in vfio-pci itself.
> > (1) prevent vendor modules from loading and see if the problem exists
> > with pure vfio-pci.
> > (2) do what's demoed in patch 8/10, i.e. do nothing but simply pass all
> > operations to vfio-pci.
> 
> The code split is still extremely ad-hoc, there's no API.  An mdev
> driver isn't even a sub-driver of vfio-pci like you're trying to
> accomplish here, there would need to be a much more defined API when
> the base device isn't even a vfio_pci_device.  I don't see how this
> series would directly enable an mdev use case.
> 
similar to Yi's series https://patchwork.kernel.org/patch/11320841/.
we can parcel the vdev creation code in vfio_pci_probe() to allow calling from
mdev parent probe routine. (of course, also need to parcel code to free vdev)
e.g.

void *vfio_pci_alloc_vdev(struct pci_dev *pdev, const struct pci_device_id *id)
{
	struct vfio_pci_device *vdev;
        vdev = kzalloc(sizeof(*vdev), GFP_KERNEL);
        if (!vdev) {
                ret = -ENOMEM;
                goto out_group_put;
        }

        vdev->pdev = pdev;
        vdev->irq_type = VFIO_PCI_NUM_IRQS;
        mutex_init(&vdev->igate);
        spin_lock_init(&vdev->irqlock);
        mutex_init(&vdev->ioeventfds_lock);
        INIT_LIST_HEAD(&vdev->ioeventfds_list);
	...
	vfio_pci_probe_power_state(vdev);

        if (!disable_idle_d3) {
                vfio_pci_set_power_state(vdev, PCI_D0);
                vfio_pci_set_power_state(vdev, PCI_D3hot);
        }
	return vdev;
}

static int vfio_mdev_pci_driver_probe(struct pci_dev *pdev, const struct pci_device_id *id))
{

       void *vdev = vfio_pci_alloc_vdev(pdev, id);

       //save the vdev pointer 

}
then all the exported interfaces from this series can also benefit the
mdev use case.

> > so, do you think this series has its merit and we can continue improving
> > it?
> 
> I think this series is trying to push an artificial use case that is
> perhaps better done in userspace.  What is the actual interaction with
> the VF device that can only be done in the host kernel for this
> example?  Thanks,
>
yes, as with shaopeng's reply, looking forward to their early release of
code.
Besides, there're other real use cases as well, like NVMe, QAT.
we can show the interactions for those devices as well.

Thanks
Yan
