Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AB1AE11C3D4
	for <lists+kvm@lfdr.de>; Thu, 12 Dec 2019 04:19:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726970AbfLLDTu (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 11 Dec 2019 22:19:50 -0500
Received: from mga06.intel.com ([134.134.136.31]:50385 "EHLO mga06.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726638AbfLLDTu (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 11 Dec 2019 22:19:50 -0500
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by orsmga104.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 11 Dec 2019 19:19:48 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.69,304,1571727600"; 
   d="scan'208";a="210971074"
Received: from joy-optiplex-7040.sh.intel.com (HELO joy-OptiPlex-7040) ([10.239.13.9])
  by fmsmga008.fm.intel.com with ESMTP; 11 Dec 2019 19:19:46 -0800
Date:   Wed, 11 Dec 2019 22:11:35 -0500
From:   Yan Zhao <yan.y.zhao@intel.com>
To:     Alex Williamson <alex.williamson@redhat.com>
Cc:     "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "libvir-list@redhat.com" <libvir-list@redhat.com>,
        "qemu-devel@nongnu.org" <qemu-devel@nongnu.org>,
        "cohuck@redhat.com" <cohuck@redhat.com>,
        "zhenyuw@linux.intel.com" <zhenyuw@linux.intel.com>,
        "Wang, Zhi A" <zhi.a.wang@intel.com>,
        "Tian, Kevin" <kevin.tian@intel.com>,
        "He, Shaopeng" <shaopeng.he@intel.com>
Subject: Re: [RFC PATCH 4/9] vfio-pci: register default dynamic-trap-bar-info
 region
Message-ID: <20191212031135.GC21868@joy-OptiPlex-7040>
Reply-To: Yan Zhao <yan.y.zhao@intel.com>
References: <20191206060407.GF31791@joy-OptiPlex-7040>
 <20191206082038.2b1078d9@x1.home>
 <20191209062212.GL31791@joy-OptiPlex-7040>
 <20191209141608.310520fc@x1.home>
 <20191210074444.GA28339@joy-OptiPlex-7040>
 <20191210093805.36a5b443@x1.home>
 <20191211062555.GC28339@joy-OptiPlex-7040>
 <20191211115655.7ecc5c83@x1.home>
 <20191212020240.GA21868@joy-OptiPlex-7040>
 <20191211200742.0f361607@x1.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191211200742.0f361607@x1.home>
User-Agent: Mutt/1.9.4 (2018-02-28)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Dec 12, 2019 at 11:07:42AM +0800, Alex Williamson wrote:
> On Wed, 11 Dec 2019 21:02:40 -0500
> Yan Zhao <yan.y.zhao@intel.com> wrote:
> 
> > On Thu, Dec 12, 2019 at 02:56:55AM +0800, Alex Williamson wrote:
> > > On Wed, 11 Dec 2019 01:25:55 -0500
> > > Yan Zhao <yan.y.zhao@intel.com> wrote:
> > >   
> > > > On Wed, Dec 11, 2019 at 12:38:05AM +0800, Alex Williamson wrote:  
> > > > > On Tue, 10 Dec 2019 02:44:44 -0500
> > > > > Yan Zhao <yan.y.zhao@intel.com> wrote:
> > > > >     
> > > > > > On Tue, Dec 10, 2019 at 05:16:08AM +0800, Alex Williamson wrote:    
> > > > > > > On Mon, 9 Dec 2019 01:22:12 -0500
> > > > > > > Yan Zhao <yan.y.zhao@intel.com> wrote:
> > > > > > >       
> > > > > > > > On Fri, Dec 06, 2019 at 11:20:38PM +0800, Alex Williamson wrote:      
> > > > > > > > > On Fri, 6 Dec 2019 01:04:07 -0500
> > > > > > > > > Yan Zhao <yan.y.zhao@intel.com> wrote:
> > > > > > > > >         
> > > > > > > > > > On Fri, Dec 06, 2019 at 07:55:30AM +0800, Alex Williamson wrote:        
> > > > > > > > > > > On Wed,  4 Dec 2019 22:26:50 -0500
> > > > > > > > > > > Yan Zhao <yan.y.zhao@intel.com> wrote:
> > > > > > > > > > >           
> > > > > > > > > > > > Dynamic trap bar info region is a channel for QEMU and vendor driver to
> > > > > > > > > > > > communicate dynamic trap info. It is of type
> > > > > > > > > > > > VFIO_REGION_TYPE_DYNAMIC_TRAP_BAR_INFO and subtype
> > > > > > > > > > > > VFIO_REGION_SUBTYPE_DYNAMIC_TRAP_BAR_INFO.
> > > > > > > > > > > > 
> > > > > > > > > > > > This region has two fields: dt_fd and trap.
> > > > > > > > > > > > When QEMU detects a device regions of this type, it will create an
> > > > > > > > > > > > eventfd and write its eventfd id to dt_fd field.
> > > > > > > > > > > > When vendor drivre signals this eventfd, QEMU reads trap field of this
> > > > > > > > > > > > info region.
> > > > > > > > > > > > - If trap is true, QEMU would search the device's PCI BAR
> > > > > > > > > > > > regions and disable all the sparse mmaped subregions (if the sparse
> > > > > > > > > > > > mmaped subregion is disablable).
> > > > > > > > > > > > - If trap is false, QEMU would re-enable those subregions.
> > > > > > > > > > > > 
> > > > > > > > > > > > A typical usage is
> > > > > > > > > > > > 1. vendor driver first cuts its bar 0 into several sections, all in a
> > > > > > > > > > > > sparse mmap array. So initally, all its bar 0 are passthroughed.
> > > > > > > > > > > > 2. vendor driver specifys part of bar 0 sections to be disablable.
> > > > > > > > > > > > 3. on migration starts, vendor driver signals dt_fd and set trap to true
> > > > > > > > > > > > to notify QEMU disabling the bar 0 sections of disablable flags on.
> > > > > > > > > > > > 4. QEMU disables those bar 0 section and hence let vendor driver be able
> > > > > > > > > > > > to trap access of bar 0 registers and make dirty page tracking possible.
> > > > > > > > > > > > 5. on migration failure, vendor driver signals dt_fd to QEMU again.
> > > > > > > > > > > > QEMU reads trap field of this info region which is false and QEMU
> > > > > > > > > > > > re-passthrough the whole bar 0 region.
> > > > > > > > > > > > 
> > > > > > > > > > > > Vendor driver specifies whether it supports dynamic-trap-bar-info region
> > > > > > > > > > > > through cap VFIO_PCI_DEVICE_CAP_DYNAMIC_TRAP_BAR in
> > > > > > > > > > > > vfio_pci_mediate_ops->open().
> > > > > > > > > > > > 
> > > > > > > > > > > > If vfio-pci detects this cap, it will create a default
> > > > > > > > > > > > dynamic_trap_bar_info region on behalf of vendor driver with region len=0
> > > > > > > > > > > > and region->ops=null.
> > > > > > > > > > > > Vvendor driver should override this region's len, flags, rw, mmap in its
> > > > > > > > > > > > vfio_pci_mediate_ops.          
> > > > > > > > > > > 
> > > > > > > > > > > TBH, I don't like this interface at all.  Userspace doesn't pass data
> > > > > > > > > > > to the kernel via INFO ioctls.  We have a SET_IRQS ioctl for
> > > > > > > > > > > configuring user signaling with eventfds.  I think we only need to
> > > > > > > > > > > define an IRQ type that tells the user to re-evaluate the sparse mmap
> > > > > > > > > > > information for a region.  The user would enumerate the device IRQs via
> > > > > > > > > > > GET_IRQ_INFO, find one of this type where the IRQ info would also
> > > > > > > > > > > indicate which region(s) should be re-evaluated on signaling.  The user
> > > > > > > > > > > would enable that signaling via SET_IRQS and simply re-evaluate the          
> > > > > > > > > > ok. I'll try to switch to this way. Thanks for this suggestion.
> > > > > > > > > >         
> > > > > > > > > > > sparse mmap capability for the associated regions when signaled.          
> > > > > > > > > > 
> > > > > > > > > > Do you like the "disablable" flag of sparse mmap ?
> > > > > > > > > > I think it's a lightweight way for user to switch mmap state of a whole region,
> > > > > > > > > > otherwise going through a complete flow of GET_REGION_INFO and re-setup
> > > > > > > > > > region might be too heavy.        
> > > > > > > > > 
> > > > > > > > > No, I don't like the disable-able flag.  At what frequency do we expect
> > > > > > > > > regions to change?  It seems like we'd only change when switching into
> > > > > > > > > and out of the _SAVING state, which is rare.  It seems easy for
> > > > > > > > > userspace, at least QEMU, to drop the entire mmap configuration and        
> > > > > > > > ok. I'll try this way.
> > > > > > > >       
> > > > > > > > > re-read it.  Another concern here is how do we synchronize the event?
> > > > > > > > > Are we assuming that this event would occur when a user switch to
> > > > > > > > > _SAVING mode on the device?  That operation is synchronous, the device
> > > > > > > > > must be in saving mode after the write to device state completes, but
> > > > > > > > > it seems like this might be trying to add an asynchronous dependency.
> > > > > > > > > Will the write to device_state only complete once the user handles the
> > > > > > > > > eventfd?  How would the kernel know when the mmap re-evaluation is
> > > > > > > > > complete.  It seems like there are gaps here that the vendor driver
> > > > > > > > > could miss traps required for migration because the user hasn't
> > > > > > > > > completed the mmap transition yet.  Thanks,
> > > > > > > > > 
> > > > > > > > > Alex        
> > > > > > > > 
> > > > > > > > yes, this asynchronous event notification will cause vendor driver miss
> > > > > > > > traps. But it's supposed to be of very short period time. That's also a
> > > > > > > > reason for us to wish the re-evaluation to be lightweight. E.g. if it's
> > > > > > > > able to be finished before the first iterate, it's still safe.      
> > > > > > > 
> > > > > > > Making the re-evaluation lightweight cannot solve the race, it only
> > > > > > > masks it.
> > > > > > >       
> > > > > > > > But I agree, the timing is not guaranteed, and so it's best for kernel
> > > > > > > > to wait for mmap re-evaluation to complete. 
> > > > > > > > 
> > > > > > > > migration_thread
> > > > > > > >     |->qemu_savevm_state_setup
> > > > > > > >     |   |->ram_save_setup
> > > > > > > >     |   |   |->migration_bitmap_sync
> > > > > > > >     |   |       |->kvm_log_sync
> > > > > > > >     |   |       |->vfio_log_sync
> > > > > > > >     |   |
> > > > > > > >     |   |->vfio_save_setup
> > > > > > > >     |       |->set_device_state(_SAVING)
> > > > > > > >     |
> > > > > > > >     |->qemu_savevm_state_pending
> > > > > > > >     |   |->ram_save_pending
> > > > > > > >     |   |   |->migration_bitmap_sync 
> > > > > > > >     |   |      |->kvm_log_sync
> > > > > > > >     |   |      |->vfio_log_sync
> > > > > > > >     |   |->vfio_save_pending
> > > > > > > >     |
> > > > > > > >     |->qemu_savevm_state_iterate
> > > > > > > >     |   |->ram_save_iterate //send pages
> > > > > > > >     |   |->vfio_save_iterate
> > > > > > > >     ...
> > > > > > > > 
> > > > > > > > 
> > > > > > > > Actually, we previously let qemu trigger the re-evaluation when migration starts.
> > > > > > > > And now the reason for we to wish kernel to trigger the mmap re-evaluation is that
> > > > > > > > there're other two possible use cases:
> > > > > > > > (1) keep passing through devices when migration starts and track dirty pages
> > > > > > > >     using hardware IOMMU. Then when migration is about to complete, stop the
> > > > > > > >     device and start trap PCI BARs for software emulation. (we made some
> > > > > > > >     changes to let device stop ahead of vcpu )      
> > > > > > > 
> > > > > > > How is that possible?  I/O devices need to continue to work until the
> > > > > > > vCPU stops otherwise the vCPU can get blocked on the device.  Maybe QEMU      
> > > > > > hi Alex
> > > > > > For devices like DSA [1], it can support SVM mode. In this mode, when a
> > > > > > page fault happens, the Intel DSA device blocks until the page fault is
> > > > > > resolved, if PRS is enabled; otherwise it is reported as an error.
> > > > > > 
> > > > > > Therefore, to pass through DSA into guest and do live migration with it,
> > > > > > it is desired to stop DSA before stopping vCPU, as there may be an
> > > > > > outstanding page fault to be resolved.
> > > > > > 
> > > > > > During the period when DSA is stopped and vCPUs are still running, all the
> > > > > > pass-through resources are trapped and emulated by host mediation driver until
> > > > > > vCPUs stop.    
> > > > > 
> > > > > If the DSA is stopped and resources are trapped and emulated, then is
> > > > > the device really stopped from a QEMU perspective or has it simply
> > > > > switched modes underneath QEMU?  If the device is truly stopped, then
> > > > > I'd like to understand how a vCPU doing a PIO read from the device
> > > > > wouldn't wedge the VM.
> > > > >    
> > > > It doesn't matter if the device is truly stopped or not (although from
> > > > my point of view, just draining commands and keeping device running is
> > > > better as it handles live migration failure better).
> > > > PIOs also need to be trapped and emulated if a vCPU accesses them.  
> > > 
> > > We seem to be talking around each other here.  If PIOs are trapped and
> > > emulated then the device is not "stopped" as far as QEMU is concerned,
> > > right?  "Stopping" a device suggests to me that a running vCPU doing a
> > > PIO read from the device would block and cause problems in the still
> > > running VM.  So I think you're suggesting some sort of mode switch in
> > > the device where direct access is disabled an emulation takes over
> > > until the vCPUs are stopped.  
> > 
> > sorry for this confusion.
> > yes, it's a kind of mode switch from a QEMU perspective.
> > Currently, its implementation in our local branch is like that:
> > 1. before migration thread stopping vCPUs, a migration state
> > (COMPLETING) notification is sent to vfio migration state notifier, and
> > this notifier would put device state to !RUNNING, and put all BARs to trap
> > state.
> > 2. in the kernel, when device state is set to !RUNNING, draining all
> > pending device requests, and starts emulation.
> > 
> > This implementation has two issues:
> > 1. it requires hardcode in QEMU to put all BARs trapped and the time
> > spending on revoking mmaps is not necessary for devices that do not need it.
> > 2. !RUNNING state here is not accurate and it will confuse vendor
> > drivers who stop devices after vCPUs stop.
> > 
> > For the 2nd issue, I think we can propose a new device state like
> > PRE-STOPPING.
> 
> Yes, this is absolutely abusing the !RUNNING state, if the device is
> still processing accesses by the vCPU, it's still running.
>  
> > But for the 1st issue, not sure how to fix it right now.
> > Maybe we can still add an asynchronous kernel notification and wait until
> > QEMU have switched the region mmap state?
> 
> It seems like you're preemptively trying to optimize the SAVING state
> before we even have migration working.  Shouldn't SAVING be the point
> at which you switch to trapping the device in order to track it?
> Thanks,

But for some devices, start trapping on entering SAVING state is too
early. They don't really need the trapping until PRE_STOPPING stage.
E.g. for DSA, it can get dirty pages without trapping. The intention for
it to enter trap is not for SAVING, but for emulation.

Thanks
Yan
