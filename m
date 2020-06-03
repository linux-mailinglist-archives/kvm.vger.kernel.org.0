Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 147F11EC6F0
	for <lists+kvm@lfdr.de>; Wed,  3 Jun 2020 03:51:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728174AbgFCBu7 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 2 Jun 2020 21:50:59 -0400
Received: from mga17.intel.com ([192.55.52.151]:21751 "EHLO mga17.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726894AbgFCBu6 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 2 Jun 2020 21:50:58 -0400
IronPort-SDR: TwPbWURlaHIX3uYqKWMMhw8vxk5cWkTnTvJ9zG3pyITWd0hRlBQipWPtkxBbiiiIY74DjbDYFv
 BfeGgxqAoI+w==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Jun 2020 18:50:57 -0700
IronPort-SDR: j2Z7viKCmsJU1mmomZoW5W19MWXUDbXzOkZI2L6v04CNK37pFgWeML/DJI4IXGVojnfCED6FW9
 DszEeHsj77Cw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.73,466,1583222400"; 
   d="scan'208";a="286862705"
Received: from joy-optiplex-7040.sh.intel.com (HELO joy-OptiPlex-7040) ([10.239.13.16])
  by orsmga002.jf.intel.com with ESMTP; 02 Jun 2020 18:50:54 -0700
Date:   Tue, 2 Jun 2020 21:40:58 -0400
From:   Yan Zhao <yan.y.zhao@intel.com>
To:     Alex Williamson <alex.williamson@redhat.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        cohuck@redhat.com, zhenyuw@linux.intel.com, zhi.a.wang@intel.com,
        kevin.tian@intel.com, shaopeng.he@intel.com, yi.l.liu@intel.com,
        xin.zeng@intel.com, hang.yuan@intel.com
Subject: Re: [RFC PATCH v4 07/10] vfio/pci: introduce a new irq type
 VFIO_IRQ_TYPE_REMAP_BAR_REGION
Message-ID: <20200603014058.GA12300@joy-OptiPlex-7040>
Reply-To: Yan Zhao <yan.y.zhao@intel.com>
References: <20200518024202.13996-1-yan.y.zhao@intel.com>
 <20200518025245.14425-1-yan.y.zhao@intel.com>
 <20200529154547.19a6685f@x1.home>
 <20200601065726.GA5906@joy-OptiPlex-7040>
 <20200601104307.259b0fe1@x1.home>
 <20200602082858.GA8915@joy-OptiPlex-7040>
 <20200602133435.1ab650c5@x1.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200602133435.1ab650c5@x1.home>
User-Agent: Mutt/1.9.4 (2018-02-28)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Jun 02, 2020 at 01:34:35PM -0600, Alex Williamson wrote:
> I'm not at all happy with this.  Why do we need to hide the migration
> sparse mmap from the user until migration time?  What if instead we
> introduced a new VFIO_REGION_INFO_CAP_SPARSE_MMAP_SAVING capability
> where the existing capability is the normal runtime sparse setup and
> the user is required to use this new one prior to enabled device_state
> with _SAVING.  The vendor driver could then simply track mmap vmas to
> the region and refuse to change device_state if there are outstanding
> mmaps conflicting with the _SAVING sparse mmap layout.  No new IRQs
> required, no new irqfds, an incremental change to the protocol,
> backwards compatible to the extent that a vendor driver requiring this
> will automatically fail migration.
> 
right. looks we need to use this approach to solve the problem.
thanks for your guide.
so I'll abandon the current remap irq way for dirty tracking during live
migration.
but anyway, it demos how to customize irq_types in vendor drivers.
then, what do you think about patches 1-5?

> > > What happens if the mmap re-evaluation occurs asynchronous to the
> > > device_state write?  The vendor driver can track outstanding mmap vmas
> > > to areas it's trying to revoke, so the vendor driver can know when
> > > userspace has reached an acceptable state (assuming we require
> > > userspace to munmap areas that are no longer valid).  We should also
> > > consider what we can accomplish by invalidating user mmaps, ex. can we
> > > fault them back in on a per-page basis and continue to mark them dirty
> > > in the migration state, re-invalidating on each iteration until they've
> > > finally been closed.   It seems the vendor driver needs to handle
> > > incrementally closing each mmap anyway, there's no requirement to the
> > > user to stop the device (ie. block all access), make these changes,
> > > then restart the device.  So perhaps the vendor driver can "limp" along
> > > until userspace completes the changes.  I think we can assume we are in
> > > a cooperative environment here, userspace wants to perform a migration,
> > > disabling direct access to some regions is for mediating those accesses
> > > during migration, not for preventing the user from accessing something
> > > they shouldn't have access to, userspace is only delaying the migration
> > > or affecting the state of their device by not promptly participating in
> > > the protocol.
> > >   
> > the problem is that the mmap re-evaluation has to be done before
> > device_state is successfully set to SAVING. otherwise, the QEMU may
> > have left save_setup stage and it's too late to start dirty tracking.
> > And the reason for us to trap the BAR regions is not because there're
> > dirty data in this region, it is because we want to know when the device
> > registers mapped in the BARs are written, so we can do dirty page track
> > of system memory in software way.
> 
> I think my proposal above resolves this.
>
yes.

> > > Another problem I see though is what about p2p DMA?  If the vendor
> > > driver invalidates an mmap we're removing it from both direct CPU as
> > > well as DMA access via the IOMMU.  We can't signal to the guest OS that
> > > a DMA channel they've been using is suddenly no longer valid.  Is QEMU
> > > going to need to avoid ever IOMMU mapping device_ram for regions
> > > subject to mmap invalidation?  That would introduce an undesirable need
> > > to choose whether we want to support p2p or migration unless we had an
> > > IOMMU that could provide dirty tracking via p2p, right?  Thanks,  
> > 
> > yes, if there are device memory mapped in the BARs to be remapped, p2p
> > DMA would be affected. Perhaps it is what vendor driver should be aware
> > of and know what it is doing before sending out the remap irq ?
> > in i40e vf's case, the BAR 0 to be remapped is only for device registers,
> > so is it still good?
> 
> No, we can't design the interface based on one vendor driver's
> implementation of the interface or the requirements of a single device.
> If we took the approach above where the user is provided both the
> normal sparse mmap and the _SAVING sparse mmap, perhaps QEMU could
> avoid DMA mapping portions that don't exist in the _SAVING version, at
> least then the p2p DMA mappings would be consistent across the
> transition.  QEMU might be able to combine the sparse mmap maps such
> that it can easily drop ranges not present during _SAVING.  QEMU would
> need to munmap() the dropped ranges rather than simply mark the
> MemoryRegion disabled though for the vendor driver to have visibility
> of the vm_ops.close callback.  Thanks,
>
ok. got it! thanks you!

Yan
