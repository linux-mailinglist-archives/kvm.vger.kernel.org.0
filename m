Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 225D3201E43
	for <lists+kvm@lfdr.de>; Sat, 20 Jun 2020 00:56:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729861AbgFSWzq (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 19 Jun 2020 18:55:46 -0400
Received: from us-smtp-2.mimecast.com ([207.211.31.81]:35275 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1729848AbgFSWzp (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 19 Jun 2020 18:55:45 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1592607342;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=1fEONkl9Gy02J0c8XlWrhRAhX7Fsb4oNDGiD/9Th2Aw=;
        b=X4+3GNNf5ePxHfn2X+F/ycm5RCiFojQjLRO94TNfDDCMq+M1NcgQXpLAwiI3et36jq+DXZ
        N46Wn0Cde8804lqSDaZK4K0AjBGVQTdFSfox9UcG1s7Y63rRYbO8TIJbmzjgGzki7WAOz5
        jdmTFrbMOqS5YYZqq2jFoYD7g5kBS3Y=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-115-wu38IFGPONCQkEv5id5BfQ-1; Fri, 19 Jun 2020 18:55:38 -0400
X-MC-Unique: wu38IFGPONCQkEv5id5BfQ-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 0B211800053;
        Fri, 19 Jun 2020 22:55:36 +0000 (UTC)
Received: from w520.home (ovpn-112-195.phx2.redhat.com [10.3.112.195])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 3802871661;
        Fri, 19 Jun 2020 22:55:35 +0000 (UTC)
Date:   Fri, 19 Jun 2020 16:55:34 -0600
From:   Alex Williamson <alex.williamson@redhat.com>
To:     Yan Zhao <yan.y.zhao@intel.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        cohuck@redhat.com, zhenyuw@linux.intel.com, zhi.a.wang@intel.com,
        kevin.tian@intel.com, shaopeng.he@intel.com, yi.l.liu@intel.com,
        xin.zeng@intel.com, hang.yuan@intel.com
Subject: Re: [RFC PATCH v4 07/10] vfio/pci: introduce a new irq type
 VFIO_IRQ_TYPE_REMAP_BAR_REGION
Message-ID: <20200619165534.6d0c22e2@w520.home>
In-Reply-To: <20200610052314.GB13961@joy-OptiPlex-7040>
References: <20200601065726.GA5906@joy-OptiPlex-7040>
        <20200601104307.259b0fe1@x1.home>
        <20200602082858.GA8915@joy-OptiPlex-7040>
        <20200602133435.1ab650c5@x1.home>
        <20200603014058.GA12300@joy-OptiPlex-7040>
        <20200603170452.7f172baf@x1.home>
        <20200604024228.GD12300@joy-OptiPlex-7040>
        <20200603221058.1927a0fc@x1.home>
        <20200605020231.GE12300@joy-OptiPlex-7040>
        <20200605101301.6abb8a3b@x1.home>
        <20200610052314.GB13961@joy-OptiPlex-7040>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, 10 Jun 2020 01:23:14 -0400
Yan Zhao <yan.y.zhao@intel.com> wrote:

> On Fri, Jun 05, 2020 at 10:13:01AM -0600, Alex Williamson wrote:
> > On Thu, 4 Jun 2020 22:02:31 -0400
> > Yan Zhao <yan.y.zhao@intel.com> wrote:
> >   
> > > On Wed, Jun 03, 2020 at 10:10:58PM -0600, Alex Williamson wrote:  
> > > > On Wed, 3 Jun 2020 22:42:28 -0400
> > > > Yan Zhao <yan.y.zhao@intel.com> wrote:
> > > >     
> > > > > On Wed, Jun 03, 2020 at 05:04:52PM -0600, Alex Williamson wrote:    
> > > > > > On Tue, 2 Jun 2020 21:40:58 -0400
> > > > > > Yan Zhao <yan.y.zhao@intel.com> wrote:
> > > > > >       
> > > > > > > On Tue, Jun 02, 2020 at 01:34:35PM -0600, Alex Williamson wrote:      
> > > > > > > > I'm not at all happy with this.  Why do we need to hide the migration
> > > > > > > > sparse mmap from the user until migration time?  What if instead we
> > > > > > > > introduced a new VFIO_REGION_INFO_CAP_SPARSE_MMAP_SAVING capability
> > > > > > > > where the existing capability is the normal runtime sparse setup and
> > > > > > > > the user is required to use this new one prior to enabled device_state
> > > > > > > > with _SAVING.  The vendor driver could then simply track mmap vmas to
> > > > > > > > the region and refuse to change device_state if there are outstanding
> > > > > > > > mmaps conflicting with the _SAVING sparse mmap layout.  No new IRQs
> > > > > > > > required, no new irqfds, an incremental change to the protocol,
> > > > > > > > backwards compatible to the extent that a vendor driver requiring this
> > > > > > > > will automatically fail migration.
> > > > > > > >         
> > > > > > > right. looks we need to use this approach to solve the problem.
> > > > > > > thanks for your guide.
> > > > > > > so I'll abandon the current remap irq way for dirty tracking during live
> > > > > > > migration.
> > > > > > > but anyway, it demos how to customize irq_types in vendor drivers.
> > > > > > > then, what do you think about patches 1-5?      
> > > > > > 
> > > > > > In broad strokes, I don't think we've found the right solution yet.  I
> > > > > > really question whether it's supportable to parcel out vfio-pci like
> > > > > > this and I don't know how I'd support unraveling whether we have a bug
> > > > > > in vfio-pci, the vendor driver, or how the vendor driver is making use
> > > > > > of vfio-pci.
> > > > > >
> > > > > > Let me also ask, why does any of this need to be in the kernel?  We
> > > > > > spend 5 patches slicing up vfio-pci so that we can register a vendor
> > > > > > driver and have that vendor driver call into vfio-pci as it sees fit.
> > > > > > We have two patches creating device specific interrupts and a BAR
> > > > > > remapping scheme that we've decided we don't need.  That brings us to
> > > > > > the actual i40e vendor driver, where the first patch is simply making
> > > > > > the vendor driver work like vfio-pci already does, the second patch is
> > > > > > handling the migration region, and the third patch is implementing the
> > > > > > BAR remapping IRQ that we decided we don't need.  It's difficult to
> > > > > > actually find the small bit of code that's required to support
> > > > > > migration outside of just dealing with the protocol we've defined to
> > > > > > expose this from the kernel.  So why are we trying to do this in the
> > > > > > kernel?  We have quirk support in QEMU, we can easily flip
> > > > > > MemoryRegions on and off, etc.  What access to the device outside of
> > > > > > what vfio-pci provides to the user, and therefore QEMU, is necessary to
> > > > > > implement this migration support for i40e VFs?  Is this just an
> > > > > > exercise in making use of the migration interface?  Thanks,
> > > > > >       
> > > > > hi Alex
> > > > > 
> > > > > There was a description of intention of this series in RFC v1
> > > > > (https://www.spinics.net/lists/kernel/msg3337337.html).
> > > > > sorry, I didn't include it in starting from RFC v2.
> > > > > 
> > > > > "
> > > > > The reason why we don't choose the way of writing mdev parent driver is
> > > > > that    
> > > > 
> > > > I didn't mention an mdev approach, I'm asking what are we accomplishing
> > > > by doing this in the kernel at all versus exposing the device as normal
> > > > through vfio-pci and providing the migration support in QEMU.  Are you
> > > > actually leveraging having some sort of access to the PF in supporting
> > > > migration of the VF?  Is vfio-pci masking the device in a way that
> > > > prevents migrating the state from QEMU?
> > > >    
> > > yes, communication to PF is required. VF state is managed by PF and is
> > > queried from PF when VF is stopped.
> > > 
> > > migration support in QEMU seems only suitable to devices with dirty
> > > pages and device state available by reading/writing device MMIOs, which
> > > is not the case for most devices.  
> > 
> > Post code for such a device.
> >  
> hi Alex,
> There's an example in i40e vf. virtual channel related resources are in
> guest memory. dirty page tracking requires the info stored in those
> guest memory.
> 
> there're two ways to get the resources addresses:
> (1) always trap VF registers related. as in Alex Graf's qemu code.
> 
> starting from beginning, it tracks rw of Admin Queue Configuration registers.
> Then in the write handler vfio_i40evf_aq_mmio_mem_region_write(), guest
> commands are processed to record the guest dma addresses of the virtual
> channel related resources.
> e.g. vdev->vsi_config is read from the guest dma addr contained in
> command I40E_VIRTCHNL_OP_CONFIG_VSI_QUEUES.
> 
> 
> vfio_i40evf_initfn()
> {
>  ...
>  memory_region_init_io(&vdev->aq_mmio_mem, OBJECT(dev),
>                           &vfio_i40evf_aq_mmio_mem_region_ops,
>                           vdev, "i40evf AQ config",
>                           I40E_VFGEN_RSTAT - I40E_VF_ARQBAH1);
>  ...
> }
> 
> vfio_i40evf_aq_mmio_mem_region_write()
> {
>    ...
>     switch (addr) {
>     case I40E_VF_ARQBAH1:
>     case I40E_VF_ARQBAL1:
>     case I40E_VF_ARQH1:
>     case I40E_VF_ARQLEN1:
>     case I40E_VF_ARQT1:
>     case I40E_VF_ATQBAH1:
>     case I40E_VF_ATQBAL1:
>     case I40E_VF_ATQH1:
>     case I40E_VF_ATQT1:
>     case I40E_VF_ATQLEN1:
>         vfio_i40evf_vw32(vdev, addr, data);
>         vfio_i40e_aq_update(vdev); ==> update & process atq commands
>         break;
>     default:
>         vfio_i40evf_w32(vdev, addr, data);
>         break;
>     }
> }
> vfio_i40e_aq_update(vdev)
> 	|->vfio_i40e_atq_process_one(vdev, vfio_i40evf_vr32(vdev, I40E_VF_ATQH1)
> 		|-> hwaddr addr = vfio_i40e_get_atqba(vdev) + (index * sizeof(desc));
> 		|   pci_dma_read(pdev, addr, &desc, sizeof(desc));//read guest's command
> 		|   vfio_i40e_record_atq_cmd(vdev, pdev, &desc)
> 			
> 		
> 
> vfio_i40e_record_atq_cmd(...I40eAdminQueueDescriptor *desc) {
> 	data_addr = desc->params.external.addr_high;
> 	...
> 
> 	switch (desc->cookie_high) {
> 	...
> 	case I40E_VIRTCHNL_OP_CONFIG_VSI_QUEUES:
> 	pci_dma_read(pdev, data_addr, &vdev->vsi_config,
> 		         MIN(desc->datalen, sizeof(vdev->vsi_config)));
> 	...
> 	}
> 	...
> }
> 
> 
> (2) pass through all guest MMIO accesses and only do MMIO trap when migration
> is about to start.
> This is the way we're using in the host vfio-pci vendor driver (or mdev parent driver)
> of i40e vf device (sorry for no public code available still).
> 
> when migration is about to start, it's already too late to get the guest dma
> address for those virtual channel related resources merely by MMIO
> trapping, so we have to ask for them from PF.
> 
> 
> 
> <...>
> 
> > > > > for interfaces exported in patch 3/10-5/10, they anyway need to be
> > > > > exported for writing mdev parent drivers that pass through devices at
> > > > > normal time to avoid duplication. and yes, your worry about    
> > > > 
> > > > Where are those parent drivers?  What are their actual requirements?
> > > >    
> > > if this way of registering vendor ops to vfio-pci is not permitted,
> > > vendors have to resort to writing its mdev parent drivers for VFs. Those
> > > parent drivers need to pass through VFs at normal time, doing exactly what
> > > vfio-pci does and only doing what vendor ops does during migration.
> > > 
> > > if vfio-pci could export common code to those parent drivers, lots of
> > > duplicated code can be avoided.  
> > 
> > There are two sides to this argument though.  We could also argue that
> > mdev has already made it too easy to implement device emulation in the
> > kernel, the barrier is that such emulation is more transparent because
> > it does require a fair bit of code duplication from vfio-pci.  If we
> > make it easier to simply re-use vfio-pci for much of this, and even
> > take it a step further by allowing vendor drivers to masquerade behind
> > vfio-pci, then we're creating an environment where vendors don't need
> > to work with QEMU to get their device emulation accepted.  They can
> > write their own vendor drivers, which are now simplified and sanctioned
> > by exported functions in vfio-pci.  They can do this easily and open up
> > massive attack vectors, hiding behind vfio-pci.
> >   
> your concern is reasonable.
> 
> > I know that I was advocating avoiding user driver confusion, ie. does
> > the user bind a device to vfio-pci, i40e_vf_vfio, etc, but maybe that's
> > the barrier we need such that a user can make an informed decision
> > about what they're actually using.  If a vendor then wants to implement
> > a feature in vfio-pci, we'll need to architect an interface for it
> > rather than letting them pick and choose which pieces of vfio-pci to
> > override.
> >   
> > > > > identification of bug sources is reasonable. but if a device is binding
> > > > > to vfio-pci with a vendor module loaded, and there's a bug, they can do at
> > > > > least two ways to identify if it's a bug in vfio-pci itself.
> > > > > (1) prevent vendor modules from loading and see if the problem exists
> > > > > with pure vfio-pci.
> > > > > (2) do what's demoed in patch 8/10, i.e. do nothing but simply pass all
> > > > > operations to vfio-pci.    
> > > > 
> > > > The code split is still extremely ad-hoc, there's no API.  An mdev
> > > > driver isn't even a sub-driver of vfio-pci like you're trying to
> > > > accomplish here, there would need to be a much more defined API when
> > > > the base device isn't even a vfio_pci_device.  I don't see how this
> > > > series would directly enable an mdev use case.
> > > >     
> > > similar to Yi's series https://patchwork.kernel.org/patch/11320841/.
> > > we can parcel the vdev creation code in vfio_pci_probe() to allow calling from
> > > mdev parent probe routine. (of course, also need to parcel code to free vdev)
> > > e.g.
> > > 
> > > void *vfio_pci_alloc_vdev(struct pci_dev *pdev, const struct pci_device_id *id)
> > > {
> > > 	struct vfio_pci_device *vdev;
> > >         vdev = kzalloc(sizeof(*vdev), GFP_KERNEL);
> > >         if (!vdev) {
> > >                 ret = -ENOMEM;
> > >                 goto out_group_put;
> > >         }
> > > 
> > >         vdev->pdev = pdev;
> > >         vdev->irq_type = VFIO_PCI_NUM_IRQS;
> > >         mutex_init(&vdev->igate);
> > >         spin_lock_init(&vdev->irqlock);
> > >         mutex_init(&vdev->ioeventfds_lock);
> > >         INIT_LIST_HEAD(&vdev->ioeventfds_list);
> > > 	...
> > > 	vfio_pci_probe_power_state(vdev);
> > > 
> > >         if (!disable_idle_d3) {
> > >                 vfio_pci_set_power_state(vdev, PCI_D0);
> > >                 vfio_pci_set_power_state(vdev, PCI_D3hot);
> > >         }
> > > 	return vdev;
> > > }
> > > 
> > > static int vfio_mdev_pci_driver_probe(struct pci_dev *pdev, const struct pci_device_id *id))
> > > {
> > > 
> > >        void *vdev = vfio_pci_alloc_vdev(pdev, id);
> > > 
> > >        //save the vdev pointer 
> > > 
> > > }
> > > then all the exported interfaces from this series can also benefit the
> > > mdev use case.  
> > 
> > You need to convince me that we're not just doing this for the sake of
> > re-using a migration interface.  We do need vendor specific drivers to
> > support migration, but implementing those vendor specific drivers in
> > the kernel just because we have that interface is the wrong answer.  If
> > we can implement that device specific migration support in QEMU and
> > limit the attack surface from the hypervisor or guest into the host
> > kernel, that's a better answer.  As I've noted above, I'm afraid all of
> > these attempts to parcel out vfio-pci are only going to serve to
> > proliferate vendor modules that have limited community review, expand
> > the attack surface, and potentially harm the vfio ecosystem overall
> > through bad actors and reduced autonomy.  Thanks,
> >  
> The requirement to access PF as mentioned above is one of the reason for
> us to implement the emulation in kernel.
> Another reason is that we don't want to duplicate a lot of kernel logic in
> QEMU as what'd done in Alex Graf's "vfio-i40e". then QEMU has to be
> updated along kernel driver changing. The effort for maintenance and
> version matching is a big burden to vendors.
> But you are right, there're less review in virtualization side to code under
> vendor specific directory. That's also the pulse for us to propose
> common helper APIs for them to call, not only for convenience and
> duplication-less, but also for code with full review.
> 
> would you mind giving us some suggestions for where to go?

Not duplicating kernel code into userspace isn't a great excuse.  What
we need to do to emulate a device is not an exact mapping to what a
driver for that device needs to do.  If we need to keep the device
driver and the emulation in sync then we haven't done a good job with
the emulation.  What would it look like if we only had an additional
device specific region on the vfio device fd we could use to get the
descriptor information we need from the PF?  This would be more inline
with the quirks we provide for IGD assignment.  Thanks,

Alex

