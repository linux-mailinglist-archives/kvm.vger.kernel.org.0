Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EA45811782F
	for <lists+kvm@lfdr.de>; Mon,  9 Dec 2019 22:16:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726874AbfLIVQT (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 9 Dec 2019 16:16:19 -0500
Received: from us-smtp-1.mimecast.com ([207.211.31.81]:52126 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726589AbfLIVQT (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 9 Dec 2019 16:16:19 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1575926177;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=xEO9nbx9697hVpozbdU8tSUscLkVPikvUY7MQsTd/ck=;
        b=eBqRe0BnqShb1rKsIRwVDE2X9ykgdONCOs8uBy94JVRiBkqV1B7gg+Vq9jH3Y9c5aow6Ww
        b1lKtShZYqqzQRP0QPb4+YnhPDWZi20xo24DASdGd+lK6Kz9BqiqdMallqY9Xdmgcc+pYo
        LnT0ppEtms3fqFXNxo+Cz8V7xeDgt7k=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-259-hvcrTAXGMPuFy7lTGImKYg-1; Mon, 09 Dec 2019 16:16:13 -0500
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id EE8F4DB60;
        Mon,  9 Dec 2019 21:16:11 +0000 (UTC)
Received: from x1.home (ovpn04.gateway.prod.ext.phx2.redhat.com [10.5.9.4])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 676BF60148;
        Mon,  9 Dec 2019 21:16:08 +0000 (UTC)
Date:   Mon, 9 Dec 2019 14:16:08 -0700
From:   Alex Williamson <alex.williamson@redhat.com>
To:     Yan Zhao <yan.y.zhao@intel.com>
Cc:     "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "libvir-list@redhat.com" <libvir-list@redhat.com>,
        "qemu-devel@nongnu.org" <qemu-devel@nongnu.org>,
        "cohuck@redhat.com" <cohuck@redhat.com>,
        "zhenyuw@linux.intel.com" <zhenyuw@linux.intel.com>,
        "Wang, Zhi A" <zhi.a.wang@intel.com>,
        "Tian, Kevin" <kevin.tian@intel.com>,
        "He, Shaopeng" <shaopeng.he@intel.com>
Subject: Re: [RFC PATCH 4/9] vfio-pci: register default
 dynamic-trap-bar-info region
Message-ID: <20191209141608.310520fc@x1.home>
In-Reply-To: <20191209062212.GL31791@joy-OptiPlex-7040>
References: <20191205032419.29606-1-yan.y.zhao@intel.com>
        <20191205032650.29794-1-yan.y.zhao@intel.com>
        <20191205165530.1f29fe85@x1.home>
        <20191206060407.GF31791@joy-OptiPlex-7040>
        <20191206082038.2b1078d9@x1.home>
        <20191209062212.GL31791@joy-OptiPlex-7040>
Organization: Red Hat
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
X-MC-Unique: hvcrTAXGMPuFy7lTGImKYg-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, 9 Dec 2019 01:22:12 -0500
Yan Zhao <yan.y.zhao@intel.com> wrote:

> On Fri, Dec 06, 2019 at 11:20:38PM +0800, Alex Williamson wrote:
> > On Fri, 6 Dec 2019 01:04:07 -0500
> > Yan Zhao <yan.y.zhao@intel.com> wrote:
> >   
> > > On Fri, Dec 06, 2019 at 07:55:30AM +0800, Alex Williamson wrote:  
> > > > On Wed,  4 Dec 2019 22:26:50 -0500
> > > > Yan Zhao <yan.y.zhao@intel.com> wrote:
> > > >     
> > > > > Dynamic trap bar info region is a channel for QEMU and vendor driver to
> > > > > communicate dynamic trap info. It is of type
> > > > > VFIO_REGION_TYPE_DYNAMIC_TRAP_BAR_INFO and subtype
> > > > > VFIO_REGION_SUBTYPE_DYNAMIC_TRAP_BAR_INFO.
> > > > > 
> > > > > This region has two fields: dt_fd and trap.
> > > > > When QEMU detects a device regions of this type, it will create an
> > > > > eventfd and write its eventfd id to dt_fd field.
> > > > > When vendor drivre signals this eventfd, QEMU reads trap field of this
> > > > > info region.
> > > > > - If trap is true, QEMU would search the device's PCI BAR
> > > > > regions and disable all the sparse mmaped subregions (if the sparse
> > > > > mmaped subregion is disablable).
> > > > > - If trap is false, QEMU would re-enable those subregions.
> > > > > 
> > > > > A typical usage is
> > > > > 1. vendor driver first cuts its bar 0 into several sections, all in a
> > > > > sparse mmap array. So initally, all its bar 0 are passthroughed.
> > > > > 2. vendor driver specifys part of bar 0 sections to be disablable.
> > > > > 3. on migration starts, vendor driver signals dt_fd and set trap to true
> > > > > to notify QEMU disabling the bar 0 sections of disablable flags on.
> > > > > 4. QEMU disables those bar 0 section and hence let vendor driver be able
> > > > > to trap access of bar 0 registers and make dirty page tracking possible.
> > > > > 5. on migration failure, vendor driver signals dt_fd to QEMU again.
> > > > > QEMU reads trap field of this info region which is false and QEMU
> > > > > re-passthrough the whole bar 0 region.
> > > > > 
> > > > > Vendor driver specifies whether it supports dynamic-trap-bar-info region
> > > > > through cap VFIO_PCI_DEVICE_CAP_DYNAMIC_TRAP_BAR in
> > > > > vfio_pci_mediate_ops->open().
> > > > > 
> > > > > If vfio-pci detects this cap, it will create a default
> > > > > dynamic_trap_bar_info region on behalf of vendor driver with region len=0
> > > > > and region->ops=null.
> > > > > Vvendor driver should override this region's len, flags, rw, mmap in its
> > > > > vfio_pci_mediate_ops.    
> > > > 
> > > > TBH, I don't like this interface at all.  Userspace doesn't pass data
> > > > to the kernel via INFO ioctls.  We have a SET_IRQS ioctl for
> > > > configuring user signaling with eventfds.  I think we only need to
> > > > define an IRQ type that tells the user to re-evaluate the sparse mmap
> > > > information for a region.  The user would enumerate the device IRQs via
> > > > GET_IRQ_INFO, find one of this type where the IRQ info would also
> > > > indicate which region(s) should be re-evaluated on signaling.  The user
> > > > would enable that signaling via SET_IRQS and simply re-evaluate the    
> > > ok. I'll try to switch to this way. Thanks for this suggestion.
> > >   
> > > > sparse mmap capability for the associated regions when signaled.    
> > > 
> > > Do you like the "disablable" flag of sparse mmap ?
> > > I think it's a lightweight way for user to switch mmap state of a whole region,
> > > otherwise going through a complete flow of GET_REGION_INFO and re-setup
> > > region might be too heavy.  
> > 
> > No, I don't like the disable-able flag.  At what frequency do we expect
> > regions to change?  It seems like we'd only change when switching into
> > and out of the _SAVING state, which is rare.  It seems easy for
> > userspace, at least QEMU, to drop the entire mmap configuration and  
> ok. I'll try this way.
> 
> > re-read it.  Another concern here is how do we synchronize the event?
> > Are we assuming that this event would occur when a user switch to
> > _SAVING mode on the device?  That operation is synchronous, the device
> > must be in saving mode after the write to device state completes, but
> > it seems like this might be trying to add an asynchronous dependency.
> > Will the write to device_state only complete once the user handles the
> > eventfd?  How would the kernel know when the mmap re-evaluation is
> > complete.  It seems like there are gaps here that the vendor driver
> > could miss traps required for migration because the user hasn't
> > completed the mmap transition yet.  Thanks,
> > 
> > Alex  
> 
> yes, this asynchronous event notification will cause vendor driver miss
> traps. But it's supposed to be of very short period time. That's also a
> reason for us to wish the re-evaluation to be lightweight. E.g. if it's
> able to be finished before the first iterate, it's still safe.

Making the re-evaluation lightweight cannot solve the race, it only
masks it.

> But I agree, the timing is not guaranteed, and so it's best for kernel
> to wait for mmap re-evaluation to complete. 
> 
> migration_thread
>     |->qemu_savevm_state_setup
>     |   |->ram_save_setup
>     |   |   |->migration_bitmap_sync
>     |   |       |->kvm_log_sync
>     |   |       |->vfio_log_sync
>     |   |
>     |   |->vfio_save_setup
>     |       |->set_device_state(_SAVING)
>     |
>     |->qemu_savevm_state_pending
>     |   |->ram_save_pending
>     |   |   |->migration_bitmap_sync 
>     |   |      |->kvm_log_sync
>     |   |      |->vfio_log_sync
>     |   |->vfio_save_pending
>     |
>     |->qemu_savevm_state_iterate
>     |   |->ram_save_iterate //send pages
>     |   |->vfio_save_iterate
>     ...
> 
> 
> Actually, we previously let qemu trigger the re-evaluation when migration starts.
> And now the reason for we to wish kernel to trigger the mmap re-evaluation is that
> there're other two possible use cases:
> (1) keep passing through devices when migration starts and track dirty pages
>     using hardware IOMMU. Then when migration is about to complete, stop the
>     device and start trap PCI BARs for software emulation. (we made some
>     changes to let device stop ahead of vcpu )

How is that possible?  I/O devices need to continue to work until the
vCPU stops otherwise the vCPU can get blocked on the device.  Maybe QEMU
should assume all mmaps should be dropped on vfio device after we pass
some point of the migration process.

If there are a fixed set of mmap settings for a region and discrete
conditions under which they become active (ex. switch device to SAVING
mode) then QEMU could choose the right mapping itself and we wouldn't
need to worry about this asynchronous signaling problem, it would just
be defined as part of the protocol userspace needs to use.

> (2) performance optimization. There's an example in GVT (mdev case): 
>     PCI BARs are passed through on vGPU initialization and are mmaped to a host
>     dummy buffer. Then after initialization done, start trap of PCI BARs of
>     vGPUs and start normal host mediation. The initial pass-through can save
>     1000000 times of mmio trap.

Much of this discussion has me worried that many assumptions are being
made about the user and device interaction.  Backwards compatible
behavior is required.  If a mdev device presents an initial sparse mmap
capability for this acceleration, how do you support an existing
userspace that doesn't understand the new dynamic mmap semantics and
continues to try to operate with the initial sparse mmap?  Doesn't this
introduce another example of the raciness of the device trying to
switch mmaps?  Seems that if QEMU doesn't handle the eventfd with
sufficient timeliness the switch back to trap behavior could miss an
important transaction.  This also seems like an optimization targeted
at VMs running for only a short time, where it's not obvious to me that
GVT-g overlaps those sorts of use cases.  How much initialization time
is actually being saved with such a hack?  Thanks,

Alex

