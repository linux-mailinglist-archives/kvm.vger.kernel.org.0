Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 676DC1EC2D3
	for <lists+kvm@lfdr.de>; Tue,  2 Jun 2020 21:34:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726937AbgFBTer (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 2 Jun 2020 15:34:47 -0400
Received: from us-smtp-2.mimecast.com ([207.211.31.81]:55986 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726139AbgFBTeq (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 2 Jun 2020 15:34:46 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1591126483;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=kyNyknCmtWeGSgtjfj/C5ALDuXkGfeNYlQPkJTd7vus=;
        b=IupJ7HgJVeUdal5+6S/j+aGuFELJQdreN7Qr7hjQ3XBHxiLcjEXvQ4AvrDtIbBbzGkNnKR
        0m7QeiZbmvdzwx8S+AdveKb+/dmiyqflY0Baghui7B2xbSC2o5OpfXglAlUx5JxIV4lhTy
        yq9qUA/y1SdwEXpsQEHIF3AgX/xtPxA=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-333-cPjCQkj7O4GR-8sqLT8myA-1; Tue, 02 Jun 2020 15:34:39 -0400
X-MC-Unique: cPjCQkj7O4GR-8sqLT8myA-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id BA4E5872FEB;
        Tue,  2 Jun 2020 19:34:37 +0000 (UTC)
Received: from x1.home (ovpn-112-195.phx2.redhat.com [10.3.112.195])
        by smtp.corp.redhat.com (Postfix) with ESMTP id DC5777A8C1;
        Tue,  2 Jun 2020 19:34:36 +0000 (UTC)
Date:   Tue, 2 Jun 2020 13:34:35 -0600
From:   Alex Williamson <alex.williamson@redhat.com>
To:     Yan Zhao <yan.y.zhao@intel.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        cohuck@redhat.com, zhenyuw@linux.intel.com, zhi.a.wang@intel.com,
        kevin.tian@intel.com, shaopeng.he@intel.com, yi.l.liu@intel.com,
        xin.zeng@intel.com, hang.yuan@intel.com
Subject: Re: [RFC PATCH v4 07/10] vfio/pci: introduce a new irq type
 VFIO_IRQ_TYPE_REMAP_BAR_REGION
Message-ID: <20200602133435.1ab650c5@x1.home>
In-Reply-To: <20200602082858.GA8915@joy-OptiPlex-7040>
References: <20200518024202.13996-1-yan.y.zhao@intel.com>
        <20200518025245.14425-1-yan.y.zhao@intel.com>
        <20200529154547.19a6685f@x1.home>
        <20200601065726.GA5906@joy-OptiPlex-7040>
        <20200601104307.259b0fe1@x1.home>
        <20200602082858.GA8915@joy-OptiPlex-7040>
Organization: Red Hat
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, 2 Jun 2020 04:28:58 -0400
Yan Zhao <yan.y.zhao@intel.com> wrote:

> On Mon, Jun 01, 2020 at 10:43:07AM -0600, Alex Williamson wrote:
> > On Mon, 1 Jun 2020 02:57:26 -0400
> > Yan Zhao <yan.y.zhao@intel.com> wrote:
> >   
> > > On Fri, May 29, 2020 at 03:45:47PM -0600, Alex Williamson wrote:  
> > > > On Sun, 17 May 2020 22:52:45 -0400
> > > > Yan Zhao <yan.y.zhao@intel.com> wrote:
> > > >     
> > > > > This is a virtual irq type.
> > > > > vendor driver triggers this irq when it wants to notify userspace to
> > > > > remap PCI BARs.
> > > > > 
> > > > > 1. vendor driver triggers this irq and packs the target bar number in
> > > > >    the ctx count. i.e. "1 << bar_number".
> > > > >    if a bit is set, the corresponding bar is to be remapped.
> > > > > 
> > > > > 2. userspace requery the specified PCI BAR from kernel and if flags of
> > > > > the bar regions are changed, it removes the old subregions and attaches
> > > > > subregions according to the new flags.
> > > > > 
> > > > > 3. userspace notifies back to kernel by writing one to the eventfd of
> > > > > this irq.
> > > > > 
> > > > > Please check the corresponding qemu implementation from the reply of this
> > > > > patch, and a sample usage in vendor driver in patch [10/10].
> > > > > 
> > > > > Cc: Kevin Tian <kevin.tian@intel.com>
> > > > > Signed-off-by: Yan Zhao <yan.y.zhao@intel.com>
> > > > > ---
> > > > >  include/uapi/linux/vfio.h | 11 +++++++++++
> > > > >  1 file changed, 11 insertions(+)
> > > > > 
> > > > > diff --git a/include/uapi/linux/vfio.h b/include/uapi/linux/vfio.h
> > > > > index 2d0d85c7c4d4..55895f75d720 100644
> > > > > --- a/include/uapi/linux/vfio.h
> > > > > +++ b/include/uapi/linux/vfio.h
> > > > > @@ -704,6 +704,17 @@ struct vfio_irq_info_cap_type {
> > > > >  	__u32 subtype;  /* type specific */
> > > > >  };
> > > > >  
> > > > > +/* Bar Region Query IRQ TYPE */
> > > > > +#define VFIO_IRQ_TYPE_REMAP_BAR_REGION			(1)
> > > > > +
> > > > > +/* sub-types for VFIO_IRQ_TYPE_REMAP_BAR_REGION */
> > > > > +/*
> > > > > + * This irq notifies userspace to re-query BAR region and remaps the
> > > > > + * subregions.
> > > > > + */
> > > > > +#define VFIO_IRQ_SUBTYPE_REMAP_BAR_REGION	(0)    
> > > > 
> > > > Hi Yan,
> > > > 
> > > > How do we do this in a way that's backwards compatible?  Or maybe, how
> > > > do we perform a handshake between the vendor driver and userspace to
> > > > indicate this support?    
> > > hi Alex
> > > thank you for your thoughtful review!
> > > 
> > > do you think below sequence can provide enough backwards compatibility?
> > > 
> > > - on vendor driver opening, it registers an irq of type
> > >   VFIO_IRQ_TYPE_REMAP_BAR_REGION, and reports to driver vfio-pci there's
> > >   1 vendor irq.
> > > 
> > > - after userspace detects the irq of type VFIO_IRQ_TYPE_REMAP_BAR_REGION
> > >   it enables it by signaling ACTION_TRIGGER.
> > >   
> > > - on receiving this ACTION_TRIGGER, vendor driver will try to setup a
> > >   virqfd to monitor file write to the fd of this irq, enable this irq
> > >   and return its enabling status to userspace.  
> > 
> > I'm not sure I follow here, what's the purpose of the irqfd?  When and
> > what does the user signal by writing to the irqfd?  Is this an ACK
> > mechanism?  Is this a different fd from the signaling eventfd?  
> it's not the kvm irqfd.
> in the vendor driver side, once ACTION_TRIGGER is received for the remap irq,
> interface vfio_virqfd_enable() is called to monitor writes to the eventfd of
> this irq.
> 
> when vendor driver signals the eventfd, remap handler in QEMU is
> called and it writes to the eventfd after remapping is done.
> Then the virqfd->handler registered in vendor driver is called to receive
> the QEMU ack.

This seems racy to use the same fd as both an eventfd and irqfd, does
the host need to wait for the user to service the previous IRQ before
sending a new one?  Don't we have gaps where the user is either reading
or writing where we can lose an interrupt?  Does the user also write a
bitmap?  How do we avoid getting out of sync?  Why do we even need
this, can't the vendor driver look for vm_ops.close callbacks for the
offending vma mmaps?

> > > > Would the vendor driver refuse to change
> > > > device_state in the migration region if the user has not enabled this
> > > > IRQ?    
> > > yes, vendor driver can refuse to change device_state if the irq
> > > VFIO_IRQ_TYPE_REMAP_BAR_REGION is not enabled.
> > > in my sample i40e_vf driver (patch 10/10), it implemented this logic
> > > like below:
> > > 
> > > i40e_vf_set_device_state
> > >     |-> case VFIO_DEVICE_STATE_SAVING | VFIO_DEVICE_STATE_RUNNING:
> > >     |          ret = i40e_vf_prepare_dirty_track(i40e_vf_dev);
> > >                               |->ret = i40e_vf_remap_bars(i40e_vf_dev, true);
> > > 			                     |->if (!i40e_vf_dev->remap_irq_ctx.init)
> > >                                                     return -ENODEV;
> > > 
> > > 
> > > (i40e_vf_dev->remap_irq_ctx.init is set in below path)
> > > i40e_vf_ioctl(cmd==VFIO_DEVICE_SET_IRQS)
> > >     |->i40e_vf_set_irq_remap_bars
> > >        |->i40e_vf_enable_remap_bars_irq
> > >            |-> vf_dev->remap_irq_ctx.init = true;  
> > 
> > This should be a documented aspect of the uapi, not left to vendor
> > discretion to implement.
> >  
> ok. got it.
> 
> > > > 
> > > > Everything you've described in the commit log needs to be in this
> > > > header, we can't have the usage protocol buried in a commit log.  It    
> > > got it! I'll move all descriptions in commit logs to this header so that
> > > readers can understand the whole picture here.
> > >   
> > > > also seems like this is unnecessarily PCI specific.  Can't the count
> > > > bitmap simply indicate the region index to re-evaluate?  Maybe you were    
> > > yes, it is possible. but what prevented me from doing it is that it's not
> > > easy to write an irq handler in qemu to remap other regions dynamically.
> > > 
> > > for BAR regions, there're 3 layers as below.
> > > 1. bar->mr  -->bottom layer
> > > 2. bar->region.mem --> slow path
> > > 3. bar->region->mmaps[i].mem  --> fast path
> > > so, bar remap irq handler can simply re-revaluate the region and
> > > remove/re-generate the layer 3 (fast path) without losing track of any
> > > guest accesses to the bar regions.
> > > 
> > > actually so far, the bar remap irq handler in qemu only supports remap
> > > mmap'd subregions (layout of mmap'd subregions are re-queried) and
> > > not supports updating the whole bar region size.
> > > (do you think updating bar region size is a must?)  
> > 
> > It depends on whether our interrupt is defined that the user should
> > re-evaluate the entire region_info or just the spare mmap capability.
> > A device spontaneously changing region size seems like a much more
> > abstract problem.  We do need to figure out how to support resizeable
> > BARs, but it seems that would be at the direction of the user, for
> > example emulating the resizeable BAR capability and requiring userspace
> > to re-evaluate the region_info after interacting with that emulation.
> > So long as we specify that this IRQ is limited to re-evaluating the
> > sparse mmap capability for the indicated regions, I don't think we need
> > to handle the remainder of region_info spontaneously changing.  
> got it.
> 
> > > however, there are no such fast path and slow path in other regions, so
> > > remap handlers for them are region specific.  
> > 
> > QEMU support for re-evaluating arbitrary regions for sparse mmap
> > changes should not limit our kernel implementation.  Maybe it does
> > suggest though that userspace should be informed of the region indexes
> > subject to re-evaluation such that it can choose to ignore this
> > interrupt (and lose the features enabled by the IRQ), if it doesn't
> > support re-evaluating all of the indicated regions.  For example the
> > capability could include a bitmap indicating regions that might be
> > signaled and the QEMU driver might skip registering an eventfd via
> > SET_IRQS if support for non-BAR region indexes is indicated as a
> > requirement.  I'd really prefer if we can design this to not be limited
> > to PCI BARs.
> >   
> what about use the irq_set->start and irq_set->count in ioctl SET_IRQS
> to notify vendor driver of the supported invalidation range of region
> indexes? e.g. currently it's irq_set->start = 0, and irq_set->count=6.
> this SET_IRQS ioctl can be called multiple of times to notify vendor
> driver all supported ranges.
> if vendor driver signals indexes outside of this range, QEMU just
> ignores the request.


You want an IRQ per region?  I don't think I understand this proposal.
Overloading sub-indexes within a SET_IRQS index is not acceptable.
Also, "if vendor driver signals indexes outside of this range, QEMU
just ignores the request", if that means that QEMU doesn't handle a
request to re-evaluate the sparse mmap capability I think that
nullifies the entire proposal.

> > > > worried about running out of bits in the ctx count?  An IRQ per region    
> > > yes. that's also possible :) 
> > > but current ctx count is 64bit, so it can support regions of index up to 63.
> > > if we don't need to remap dev regions, seems it's enough?  
> > 
> > This is the kind of decision we might look back on 10yrs later and
> > wonder how we were so short sighted, but yes it does seem like enough
> > and we can define additional IRQs for each of the next 64 region
> > indexes if we need too.  
> ok.
> 
> >    
> > > > could resolve that, but maybe we could also just add another IRQ for
> > > > the next bitmap of regions.  I assume that the bitmap can indicate
> > > > multiple regions to re-evaluate, but that should be documented.    
> > > hmm. would you mind elaborating more about it?  
> > 
> > I'm just confirming that the usage expectation would allow the user to
> > be signaled with multiple bits in the bitmap set and the user is
> > expected to re-evaluate each region index sparse bitmap.  
> yes, currently, vendor driver is able to specify multiple bits in the
> bitmap set.
> 
> >   
> > > > Also, what sort of service requirements does this imply?  Would the
> > > > vendor driver send this IRQ when the user tries to set the device_state
> > > > to _SAVING and therefore we'd require the user to accept, implement the
> > > > mapping change, and acknowledge the IRQ all while waiting for the write
> > > > to device_state to return?  That implies quite a lot of asynchronous
> > > > support in the userspace driver.  Thanks,    
> > > yes.
> > > (1) when user sets device_state to _SAVING, the vendor driver notifies this
> > > IRQ, waits until user IRQ ack is received.
> > > (2) in IRQ handler, user decodes and sends IRQ ack to vendor driver.
> > > 
> > > if a wait is required in (1) returns, it demands the qemu_mutex_iothread is
> > > not locked in migration thread when device_state is set in (1), as before
> > > entering (2), acquiring of this mutex is required.
> > > 
> > > Currently, this lock is not hold in vfio_migration_set_state() at
> > > save_setup stage but is hold in stop and copy stage. so we wait in
> > > kernel in save_setup stage and not wait in stop stage.
> > > it can be fixed by calling qemu_mutex_unlock_iothread() on entering
> > > vfio_migration_set_state() and qemu_mutex_lock_iothread() on leaving
> > > vfio_migration_set_state() in qemu.
> > > 
> > > do you think it's acceptable?  
> > 
> > I'm not thrilled by it, it seems a bit tricky for both userspace and
> > the vendor driver to get right.  Userspace needs to handle this eventfd
> > while blocked on write(2) into a region, which for QEMU means
> > additional ioctls to retrieve new REGION_INFO, closing some mmaps,
> > maybe opening other mmaps, which implies new layering of MemoryRegion
> > sub-regions and all of the calls through KVM to implement those address
> > space changes.  The vendor driver must also be able to support
> > concurrency of handling the REGION_INFO ioctl, new calls to mmap
> > regions, and maybe vm_ops.close and vm_ops.fault.  These regions might
> > also be IOMMU mapped, so re-evaluating the sparse mmap could result in
> > DMA maps and unmaps, which the vendor driver might see via the notify
> > forcing it to unpin pages.  How would the vendor driver know when to
> > unblock the write to device_state, would it look for vm_ops.close on
> > infringing vmas or are you thinking of an ACK via irqfd?  I wouldn't
> > want to debug lockups as a result of this design :-\  
> hmm, do you think below sequence is acceptable?
> 1. QEMU sets device_state to PRE_SAVING.
>    vendor driver signals the remap irq and returns the device_state
>    write.

We have no PRE_SAVING device state.  We haven't even gotten an
implementation of the agreed migration protocol into mainline and we're
already abandoning it?

> 2. QEMU remap irq handler is invoked to do the region remapping. after
>    that user ack is sent to vendor driver by the handler writing to eventfd.

Why would we even need an remap IRQ, if we're going to throw away the
migration protocol we could just define that the user should
re-evaluate the sparse mmaps when switching to _SAVING.

> 3. QEMU sets device state to SAVING.
>    vendor driver returns success if user ack is received or failure
>    after a timeout wait.

I'm not at all happy with this.  Why do we need to hide the migration
sparse mmap from the user until migration time?  What if instead we
introduced a new VFIO_REGION_INFO_CAP_SPARSE_MMAP_SAVING capability
where the existing capability is the normal runtime sparse setup and
the user is required to use this new one prior to enabled device_state
with _SAVING.  The vendor driver could then simply track mmap vmas to
the region and refuse to change device_state if there are outstanding
mmaps conflicting with the _SAVING sparse mmap layout.  No new IRQs
required, no new irqfds, an incremental change to the protocol,
backwards compatible to the extent that a vendor driver requiring this
will automatically fail migration.

> > What happens if the mmap re-evaluation occurs asynchronous to the
> > device_state write?  The vendor driver can track outstanding mmap vmas
> > to areas it's trying to revoke, so the vendor driver can know when
> > userspace has reached an acceptable state (assuming we require
> > userspace to munmap areas that are no longer valid).  We should also
> > consider what we can accomplish by invalidating user mmaps, ex. can we
> > fault them back in on a per-page basis and continue to mark them dirty
> > in the migration state, re-invalidating on each iteration until they've
> > finally been closed.   It seems the vendor driver needs to handle
> > incrementally closing each mmap anyway, there's no requirement to the
> > user to stop the device (ie. block all access), make these changes,
> > then restart the device.  So perhaps the vendor driver can "limp" along
> > until userspace completes the changes.  I think we can assume we are in
> > a cooperative environment here, userspace wants to perform a migration,
> > disabling direct access to some regions is for mediating those accesses
> > during migration, not for preventing the user from accessing something
> > they shouldn't have access to, userspace is only delaying the migration
> > or affecting the state of their device by not promptly participating in
> > the protocol.
> >   
> the problem is that the mmap re-evaluation has to be done before
> device_state is successfully set to SAVING. otherwise, the QEMU may
> have left save_setup stage and it's too late to start dirty tracking.
> And the reason for us to trap the BAR regions is not because there're
> dirty data in this region, it is because we want to know when the device
> registers mapped in the BARs are written, so we can do dirty page track
> of system memory in software way.

I think my proposal above resolves this.

> > Another problem I see though is what about p2p DMA?  If the vendor
> > driver invalidates an mmap we're removing it from both direct CPU as
> > well as DMA access via the IOMMU.  We can't signal to the guest OS that
> > a DMA channel they've been using is suddenly no longer valid.  Is QEMU
> > going to need to avoid ever IOMMU mapping device_ram for regions
> > subject to mmap invalidation?  That would introduce an undesirable need
> > to choose whether we want to support p2p or migration unless we had an
> > IOMMU that could provide dirty tracking via p2p, right?  Thanks,  
> 
> yes, if there are device memory mapped in the BARs to be remapped, p2p
> DMA would be affected. Perhaps it is what vendor driver should be aware
> of and know what it is doing before sending out the remap irq ?
> in i40e vf's case, the BAR 0 to be remapped is only for device registers,
> so is it still good?

No, we can't design the interface based on one vendor driver's
implementation of the interface or the requirements of a single device.
If we took the approach above where the user is provided both the
normal sparse mmap and the _SAVING sparse mmap, perhaps QEMU could
avoid DMA mapping portions that don't exist in the _SAVING version, at
least then the p2p DMA mappings would be consistent across the
transition.  QEMU might be able to combine the sparse mmap maps such
that it can easily drop ranges not present during _SAVING.  QEMU would
need to munmap() the dropped ranges rather than simply mark the
MemoryRegion disabled though for the vendor driver to have visibility
of the vm_ops.close callback.  Thanks,

Alex

