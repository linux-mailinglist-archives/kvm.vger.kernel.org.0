Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EE5991EFD4E
	for <lists+kvm@lfdr.de>; Fri,  5 Jun 2020 18:13:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726173AbgFEQNT (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 5 Jun 2020 12:13:19 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:54442 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1725955AbgFEQNP (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 5 Jun 2020 12:13:15 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1591373592;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Dk0D6F0ICjCfnN0RBhfqSVuT8M3mkdxTxpZ0Pcn6UQs=;
        b=YyFGTTWGxfX77RO5nG93ymksgM2qDRzmzqKFiX/5QJ1eNVPjnEmlJiSpFXoTmeWZBuLjs5
        AJ9HDBsnZ+07iHPrvLViIeZ6DbbZvXdqNLU5/b0Ly6mIY/pHWO9jXSOUjcSQDNwPJxveUP
        WO6pnPMyU6JcJOB7gxsTepy3mmvVdXI=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-298-loos8mndMeaZ3MksX5ihtQ-1; Fri, 05 Jun 2020 12:13:04 -0400
X-MC-Unique: loos8mndMeaZ3MksX5ihtQ-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 2CA71464;
        Fri,  5 Jun 2020 16:13:03 +0000 (UTC)
Received: from x1.home (ovpn-112-195.phx2.redhat.com [10.3.112.195])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 62BB35D9DC;
        Fri,  5 Jun 2020 16:13:02 +0000 (UTC)
Date:   Fri, 5 Jun 2020 10:13:01 -0600
From:   Alex Williamson <alex.williamson@redhat.com>
To:     Yan Zhao <yan.y.zhao@intel.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        cohuck@redhat.com, zhenyuw@linux.intel.com, zhi.a.wang@intel.com,
        kevin.tian@intel.com, shaopeng.he@intel.com, yi.l.liu@intel.com,
        xin.zeng@intel.com, hang.yuan@intel.com
Subject: Re: [RFC PATCH v4 07/10] vfio/pci: introduce a new irq type
 VFIO_IRQ_TYPE_REMAP_BAR_REGION
Message-ID: <20200605101301.6abb8a3b@x1.home>
In-Reply-To: <20200605020231.GE12300@joy-OptiPlex-7040>
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
        <20200605020231.GE12300@joy-OptiPlex-7040>
Organization: Red Hat
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, 4 Jun 2020 22:02:31 -0400
Yan Zhao <yan.y.zhao@intel.com> wrote:

> On Wed, Jun 03, 2020 at 10:10:58PM -0600, Alex Williamson wrote:
> > On Wed, 3 Jun 2020 22:42:28 -0400
> > Yan Zhao <yan.y.zhao@intel.com> wrote:
> >   
> > > On Wed, Jun 03, 2020 at 05:04:52PM -0600, Alex Williamson wrote:  
> > > > On Tue, 2 Jun 2020 21:40:58 -0400
> > > > Yan Zhao <yan.y.zhao@intel.com> wrote:
> > > >     
> > > > > On Tue, Jun 02, 2020 at 01:34:35PM -0600, Alex Williamson wrote:    
> > > > > > I'm not at all happy with this.  Why do we need to hide the migration
> > > > > > sparse mmap from the user until migration time?  What if instead we
> > > > > > introduced a new VFIO_REGION_INFO_CAP_SPARSE_MMAP_SAVING capability
> > > > > > where the existing capability is the normal runtime sparse setup and
> > > > > > the user is required to use this new one prior to enabled device_state
> > > > > > with _SAVING.  The vendor driver could then simply track mmap vmas to
> > > > > > the region and refuse to change device_state if there are outstanding
> > > > > > mmaps conflicting with the _SAVING sparse mmap layout.  No new IRQs
> > > > > > required, no new irqfds, an incremental change to the protocol,
> > > > > > backwards compatible to the extent that a vendor driver requiring this
> > > > > > will automatically fail migration.
> > > > > >       
> > > > > right. looks we need to use this approach to solve the problem.
> > > > > thanks for your guide.
> > > > > so I'll abandon the current remap irq way for dirty tracking during live
> > > > > migration.
> > > > > but anyway, it demos how to customize irq_types in vendor drivers.
> > > > > then, what do you think about patches 1-5?    
> > > > 
> > > > In broad strokes, I don't think we've found the right solution yet.  I
> > > > really question whether it's supportable to parcel out vfio-pci like
> > > > this and I don't know how I'd support unraveling whether we have a bug
> > > > in vfio-pci, the vendor driver, or how the vendor driver is making use
> > > > of vfio-pci.
> > > >
> > > > Let me also ask, why does any of this need to be in the kernel?  We
> > > > spend 5 patches slicing up vfio-pci so that we can register a vendor
> > > > driver and have that vendor driver call into vfio-pci as it sees fit.
> > > > We have two patches creating device specific interrupts and a BAR
> > > > remapping scheme that we've decided we don't need.  That brings us to
> > > > the actual i40e vendor driver, where the first patch is simply making
> > > > the vendor driver work like vfio-pci already does, the second patch is
> > > > handling the migration region, and the third patch is implementing the
> > > > BAR remapping IRQ that we decided we don't need.  It's difficult to
> > > > actually find the small bit of code that's required to support
> > > > migration outside of just dealing with the protocol we've defined to
> > > > expose this from the kernel.  So why are we trying to do this in the
> > > > kernel?  We have quirk support in QEMU, we can easily flip
> > > > MemoryRegions on and off, etc.  What access to the device outside of
> > > > what vfio-pci provides to the user, and therefore QEMU, is necessary to
> > > > implement this migration support for i40e VFs?  Is this just an
> > > > exercise in making use of the migration interface?  Thanks,
> > > >     
> > > hi Alex
> > > 
> > > There was a description of intention of this series in RFC v1
> > > (https://www.spinics.net/lists/kernel/msg3337337.html).
> > > sorry, I didn't include it in starting from RFC v2.
> > > 
> > > "
> > > The reason why we don't choose the way of writing mdev parent driver is
> > > that  
> > 
> > I didn't mention an mdev approach, I'm asking what are we accomplishing
> > by doing this in the kernel at all versus exposing the device as normal
> > through vfio-pci and providing the migration support in QEMU.  Are you
> > actually leveraging having some sort of access to the PF in supporting
> > migration of the VF?  Is vfio-pci masking the device in a way that
> > prevents migrating the state from QEMU?
> >  
> yes, communication to PF is required. VF state is managed by PF and is
> queried from PF when VF is stopped.
> 
> migration support in QEMU seems only suitable to devices with dirty
> pages and device state available by reading/writing device MMIOs, which
> is not the case for most devices.

Post code for such a device.
 
> > > (1) VFs are almost all the time directly passthroughed. Directly binding
> > > to vfio-pci can make most of the code shared/reused. If we write a
> > > vendor specific mdev parent driver, most of the code (like passthrough
> > > style of rw/mmap) still needs to be copied from vfio-pci driver, which is
> > > actually a duplicated and tedious work.
> > > (2) For features like dynamically trap/untrap pci bars, if they are in
> > > vfio-pci, they can be available to most people without repeated code
> > > copying and re-testing.
> > > (3) with a 1:1 mdev driver which passes through VFs most of the time, people
> > > have to decide whether to bind VFs to vfio-pci or mdev parent driver before
> > > it runs into a real migration need. However, if vfio-pci is bound
> > > initially, they have no chance to do live migration when there's a need
> > > later.
> > > "
> > > particularly, there're some devices (like NVMe) they purely reply on
> > > vfio-pci to do device pass-through and they have no standalone parent driver
> > > to do mdev way.
> > > 
> > > I think live migration is a general requirement for most devices and to
> > > interact with the migration interface requires vendor drivers to do
> > > device specific tasks like geting/seting device state, starting/stopping
> > > devices, tracking dirty data, report migration capabilities... all those
> > > works need be in kernel.  
> > 
> > I think Alex Graf proved they don't necessarily need to be done in
> > kernel back in 2015: https://www.youtube.com/watch?v=4RFsSgzuFso
> > He was able to achieve i40e VF live migration by only hacking QEMU.  In  
> I checked the qemu code. https://github.com/agraf/qemu/tree/vfio-i40vf.
> a new vfio-i40e device type is registered as a child type of vfio-pci, as well
> as its exclusive savevm handlers, which are not compatible to Kirti's
> general VFIO live migration framework.

Obviously, saved state is managed within QEMU.  We've already seen
pushback to using mdev as a means to implement emulation in the kernel.
A vfio migration interface is not an excuse to move everything to
in-kernel drivers just to make use of it.  IF migration support can be
achieved for a device within QEMU, then that's the correct place to put
it.

> > this series you're allowing a vendor driver to interpose itself between
> > the user (QEMU) and vfio-pci such that we switch to the vendor code
> > during migration.  Why can't that interpose layer be in QEMU rather
> > than the kernel?  It seems that it only must be in the kernel if we
> > need to provide migration state via backdoor, perhaps like going
> > through the PF.  So what access to the i40e VF device is not provided to
> > the user through vfio-pci that is necessary to implement migration of
> > this device?  The tasks listed above are mostly standard device driver
> > activities and clearly vfio-pci allows userspace device drivers.
> >   
> tasks like interacting with PF driver, preparing resources and tracking dirty
> pages in device internal memory, detecting of whether dirty page is able
> to be tracked by hardware and reporting migration capabilities, exposing
> hardware dirty bitmap buffer... all those are hard to be done in QEMU.

Something being easier to do in the kernel does not automatically make
the kernel the right place to do it.  The kernel manages resources, so
if access through a PF, where the PF is a shared resources, is
necessary then those aspects might justify a kernel interface.  We
should also consider that the kernel presents a much richer attack
vector.  QEMU is already confined and a single set of ioctls through
vfio-pci is much easier to audit for security than allowing every
vendor driver to re-implement their own version.  Attempting to re-use
vfio-pci code is an effort to contain that risk, but I think it ends up
turning into a Frankenstein's monster of intermingled dependencies
without a defined API.

> maintaining migration code in kernel can also allow vendors to re-use common
> code for devices across generations. e.g. for i40e, in some generations,
> software dirty page track is used,  some generations hardware dirty
> track is enabled and some other generations leveraging IOMMU A/D bit is
> feasible. is QEMU quirks allowing such flexibility as in kernel?

These arguments all sound like excuses, ie. hiding migration code in
the kernel for convenience.  Obviously we can re-use code between
devices in QEMU.  What I think I see happening here is using the vfio
migration interface as an excuse to push more code into the kernel, and
the vfio-pci vendor extensions are a mechanism to masquerade behind a
known driver and avoid defining interfaces for specific features.

> besides, migration version string as a sysfs attribute requires a vendor
> driver to generate.

We don't have that yet anyway, and it's also a false dependency.  The
external version string is required _because_ the migration backend is
not provided _within_ QEMU.  If QEMU manages generating the migration
data for a device, we don't need an external version string.

> > > do you think it's better to create numerous vendor quirks in vfio-pci?  
> > 
> > In QEMU, perhaps.  Alternatively, let's look at exactly what access is
> > not provided through vfio-pci that's necessary for this and decide if
> > we want to enable that access or if cracking vfio-pci wide open for
> > vendor drivers to pick and choose when and how to use it is really the
> > right answer.
> >   
> I think the position of vendor modules is just like vfio_pci_igd.c under
> vfio-pci. the difference is that the vendor modules are able to be
> dynamically loaded outside of vfio-pci.

No, this is entirely false.  vfio_pci_igd provides two supplemental,
read-only regions necessary to satisfy some of the dependencies of the
guest driver.  It does not attempt to take over the device.
 
> > > as to this series, though patch 9/10 currently only demos reporting a
> > > migration region, it actually shows the capability iof vendor driver to
> > > customize device regions. e.g. in patch 10/10, it customizes the BAR0 to
> > > be read/write. and though we abandoned the REMAP BAR irq_type in patch
> > > 10/10 for migration purpose, I have to say this irq_type has its usage
> > > in other use cases, where synchronization is not a hard requirement and
> > > all it needs is a notification channel from kernel to use. this series
> > > just provides a possibility for vendors to customize device regions and
> > > irqs.  
> > 
> > I don't disagree that a device specific interrupt might be useful, but
> > I would object to implementing this one only as an artificial use case.
> > We can wait for a legitimate use case to implement that.
> >  
> ok. sure.
> 
> > > for interfaces exported in patch 3/10-5/10, they anyway need to be
> > > exported for writing mdev parent drivers that pass through devices at
> > > normal time to avoid duplication. and yes, your worry about  
> > 
> > Where are those parent drivers?  What are their actual requirements?
> >  
> if this way of registering vendor ops to vfio-pci is not permitted,
> vendors have to resort to writing its mdev parent drivers for VFs. Those
> parent drivers need to pass through VFs at normal time, doing exactly what
> vfio-pci does and only doing what vendor ops does during migration.
> 
> if vfio-pci could export common code to those parent drivers, lots of
> duplicated code can be avoided.

There are two sides to this argument though.  We could also argue that
mdev has already made it too easy to implement device emulation in the
kernel, the barrier is that such emulation is more transparent because
it does require a fair bit of code duplication from vfio-pci.  If we
make it easier to simply re-use vfio-pci for much of this, and even
take it a step further by allowing vendor drivers to masquerade behind
vfio-pci, then we're creating an environment where vendors don't need
to work with QEMU to get their device emulation accepted.  They can
write their own vendor drivers, which are now simplified and sanctioned
by exported functions in vfio-pci.  They can do this easily and open up
massive attack vectors, hiding behind vfio-pci.

I know that I was advocating avoiding user driver confusion, ie. does
the user bind a device to vfio-pci, i40e_vf_vfio, etc, but maybe that's
the barrier we need such that a user can make an informed decision
about what they're actually using.  If a vendor then wants to implement
a feature in vfio-pci, we'll need to architect an interface for it
rather than letting them pick and choose which pieces of vfio-pci to
override.

> > > identification of bug sources is reasonable. but if a device is binding
> > > to vfio-pci with a vendor module loaded, and there's a bug, they can do at
> > > least two ways to identify if it's a bug in vfio-pci itself.
> > > (1) prevent vendor modules from loading and see if the problem exists
> > > with pure vfio-pci.
> > > (2) do what's demoed in patch 8/10, i.e. do nothing but simply pass all
> > > operations to vfio-pci.  
> > 
> > The code split is still extremely ad-hoc, there's no API.  An mdev
> > driver isn't even a sub-driver of vfio-pci like you're trying to
> > accomplish here, there would need to be a much more defined API when
> > the base device isn't even a vfio_pci_device.  I don't see how this
> > series would directly enable an mdev use case.
> >   
> similar to Yi's series https://patchwork.kernel.org/patch/11320841/.
> we can parcel the vdev creation code in vfio_pci_probe() to allow calling from
> mdev parent probe routine. (of course, also need to parcel code to free vdev)
> e.g.
> 
> void *vfio_pci_alloc_vdev(struct pci_dev *pdev, const struct pci_device_id *id)
> {
> 	struct vfio_pci_device *vdev;
>         vdev = kzalloc(sizeof(*vdev), GFP_KERNEL);
>         if (!vdev) {
>                 ret = -ENOMEM;
>                 goto out_group_put;
>         }
> 
>         vdev->pdev = pdev;
>         vdev->irq_type = VFIO_PCI_NUM_IRQS;
>         mutex_init(&vdev->igate);
>         spin_lock_init(&vdev->irqlock);
>         mutex_init(&vdev->ioeventfds_lock);
>         INIT_LIST_HEAD(&vdev->ioeventfds_list);
> 	...
> 	vfio_pci_probe_power_state(vdev);
> 
>         if (!disable_idle_d3) {
>                 vfio_pci_set_power_state(vdev, PCI_D0);
>                 vfio_pci_set_power_state(vdev, PCI_D3hot);
>         }
> 	return vdev;
> }
> 
> static int vfio_mdev_pci_driver_probe(struct pci_dev *pdev, const struct pci_device_id *id))
> {
> 
>        void *vdev = vfio_pci_alloc_vdev(pdev, id);
> 
>        //save the vdev pointer 
> 
> }
> then all the exported interfaces from this series can also benefit the
> mdev use case.

You need to convince me that we're not just doing this for the sake of
re-using a migration interface.  We do need vendor specific drivers to
support migration, but implementing those vendor specific drivers in
the kernel just because we have that interface is the wrong answer.  If
we can implement that device specific migration support in QEMU and
limit the attack surface from the hypervisor or guest into the host
kernel, that's a better answer.  As I've noted above, I'm afraid all of
these attempts to parcel out vfio-pci are only going to serve to
proliferate vendor modules that have limited community review, expand
the attack surface, and potentially harm the vfio ecosystem overall
through bad actors and reduced autonomy.  Thanks,

Alex

