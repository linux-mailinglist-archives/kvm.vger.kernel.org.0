Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 61F9C1E9EDC
	for <lists+kvm@lfdr.de>; Mon,  1 Jun 2020 09:07:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727828AbgFAHH1 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 1 Jun 2020 03:07:27 -0400
Received: from mga04.intel.com ([192.55.52.120]:2159 "EHLO mga04.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726142AbgFAHH0 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 1 Jun 2020 03:07:26 -0400
IronPort-SDR: vB+CrvNFpPZVWdLcEM7K8fg9qQveLd5zUlJGVguKqc3g7Dl7LlzDpDOaCiqe0ble5EGu29ck2e
 P/seCS2ovSSA==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Jun 2020 00:07:24 -0700
IronPort-SDR: zcCluIYtSPT8CcjgyuJRrV45SlK49+qBGDDhY+zCfhWm0aszxImrNQa4U+GjBxDqA2M6x4dmno
 T9rgKhp83LiQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.73,459,1583222400"; 
   d="scan'208";a="346947035"
Received: from joy-optiplex-7040.sh.intel.com (HELO joy-OptiPlex-7040) ([10.239.13.16])
  by orsmga001.jf.intel.com with ESMTP; 01 Jun 2020 00:07:21 -0700
Date:   Mon, 1 Jun 2020 02:57:26 -0400
From:   Yan Zhao <yan.y.zhao@intel.com>
To:     Alex Williamson <alex.williamson@redhat.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        cohuck@redhat.com, zhenyuw@linux.intel.com, zhi.a.wang@intel.com,
        kevin.tian@intel.com, shaopeng.he@intel.com, yi.l.liu@intel.com,
        xin.zeng@intel.com, hang.yuan@intel.com
Subject: Re: [RFC PATCH v4 07/10] vfio/pci: introduce a new irq type
 VFIO_IRQ_TYPE_REMAP_BAR_REGION
Message-ID: <20200601065726.GA5906@joy-OptiPlex-7040>
Reply-To: Yan Zhao <yan.y.zhao@intel.com>
References: <20200518024202.13996-1-yan.y.zhao@intel.com>
 <20200518025245.14425-1-yan.y.zhao@intel.com>
 <20200529154547.19a6685f@x1.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200529154547.19a6685f@x1.home>
User-Agent: Mutt/1.9.4 (2018-02-28)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, May 29, 2020 at 03:45:47PM -0600, Alex Williamson wrote:
> On Sun, 17 May 2020 22:52:45 -0400
> Yan Zhao <yan.y.zhao@intel.com> wrote:
> 
> > This is a virtual irq type.
> > vendor driver triggers this irq when it wants to notify userspace to
> > remap PCI BARs.
> > 
> > 1. vendor driver triggers this irq and packs the target bar number in
> >    the ctx count. i.e. "1 << bar_number".
> >    if a bit is set, the corresponding bar is to be remapped.
> > 
> > 2. userspace requery the specified PCI BAR from kernel and if flags of
> > the bar regions are changed, it removes the old subregions and attaches
> > subregions according to the new flags.
> > 
> > 3. userspace notifies back to kernel by writing one to the eventfd of
> > this irq.
> > 
> > Please check the corresponding qemu implementation from the reply of this
> > patch, and a sample usage in vendor driver in patch [10/10].
> > 
> > Cc: Kevin Tian <kevin.tian@intel.com>
> > Signed-off-by: Yan Zhao <yan.y.zhao@intel.com>
> > ---
> >  include/uapi/linux/vfio.h | 11 +++++++++++
> >  1 file changed, 11 insertions(+)
> > 
> > diff --git a/include/uapi/linux/vfio.h b/include/uapi/linux/vfio.h
> > index 2d0d85c7c4d4..55895f75d720 100644
> > --- a/include/uapi/linux/vfio.h
> > +++ b/include/uapi/linux/vfio.h
> > @@ -704,6 +704,17 @@ struct vfio_irq_info_cap_type {
> >  	__u32 subtype;  /* type specific */
> >  };
> >  
> > +/* Bar Region Query IRQ TYPE */
> > +#define VFIO_IRQ_TYPE_REMAP_BAR_REGION			(1)
> > +
> > +/* sub-types for VFIO_IRQ_TYPE_REMAP_BAR_REGION */
> > +/*
> > + * This irq notifies userspace to re-query BAR region and remaps the
> > + * subregions.
> > + */
> > +#define VFIO_IRQ_SUBTYPE_REMAP_BAR_REGION	(0)
> 
> Hi Yan,
> 
> How do we do this in a way that's backwards compatible?  Or maybe, how
> do we perform a handshake between the vendor driver and userspace to
> indicate this support?
hi Alex
thank you for your thoughtful review!

do you think below sequence can provide enough backwards compatibility?

- on vendor driver opening, it registers an irq of type
  VFIO_IRQ_TYPE_REMAP_BAR_REGION, and reports to driver vfio-pci there's
  1 vendor irq.

- after userspace detects the irq of type VFIO_IRQ_TYPE_REMAP_BAR_REGION
  it enables it by signaling ACTION_TRIGGER.
  
- on receiving this ACTION_TRIGGER, vendor driver will try to setup a
  virqfd to monitor file write to the fd of this irq, enable this irq
  and return its enabling status to userspace.


> Would the vendor driver refuse to change
> device_state in the migration region if the user has not enabled this
> IRQ?
yes, vendor driver can refuse to change device_state if the irq
VFIO_IRQ_TYPE_REMAP_BAR_REGION is not enabled.
in my sample i40e_vf driver (patch 10/10), it implemented this logic
like below:

i40e_vf_set_device_state
    |-> case VFIO_DEVICE_STATE_SAVING | VFIO_DEVICE_STATE_RUNNING:
    |          ret = i40e_vf_prepare_dirty_track(i40e_vf_dev);
                              |->ret = i40e_vf_remap_bars(i40e_vf_dev, true);
			                     |->if (!i40e_vf_dev->remap_irq_ctx.init)
                                                    return -ENODEV;


(i40e_vf_dev->remap_irq_ctx.init is set in below path)
i40e_vf_ioctl(cmd==VFIO_DEVICE_SET_IRQS)
    |->i40e_vf_set_irq_remap_bars
       |->i40e_vf_enable_remap_bars_irq
           |-> vf_dev->remap_irq_ctx.init = true;

> 
> Everything you've described in the commit log needs to be in this
> header, we can't have the usage protocol buried in a commit log.  It
got it! I'll move all descriptions in commit logs to this header so that
readers can understand the whole picture here.

> also seems like this is unnecessarily PCI specific.  Can't the count
> bitmap simply indicate the region index to re-evaluate?  Maybe you were
yes, it is possible. but what prevented me from doing it is that it's not
easy to write an irq handler in qemu to remap other regions dynamically.

for BAR regions, there're 3 layers as below.
1. bar->mr  -->bottom layer
2. bar->region.mem --> slow path
3. bar->region->mmaps[i].mem  --> fast path
so, bar remap irq handler can simply re-revaluate the region and
remove/re-generate the layer 3 (fast path) without losing track of any
guest accesses to the bar regions.

actually so far, the bar remap irq handler in qemu only supports remap
mmap'd subregions (layout of mmap'd subregions are re-queried) and
not supports updating the whole bar region size.
(do you think updating bar region size is a must?)

however, there are no such fast path and slow path in other regions, so
remap handlers for them are region specific.

> worried about running out of bits in the ctx count?  An IRQ per region
yes. that's also possible :) 
but current ctx count is 64bit, so it can support regions of index up to 63.
if we don't need to remap dev regions, seems it's enough?

> could resolve that, but maybe we could also just add another IRQ for
> the next bitmap of regions.  I assume that the bitmap can indicate
> multiple regions to re-evaluate, but that should be documented.
hmm. would you mind elaborating more about it?

> 
> Also, what sort of service requirements does this imply?  Would the
> vendor driver send this IRQ when the user tries to set the device_state
> to _SAVING and therefore we'd require the user to accept, implement the
> mapping change, and acknowledge the IRQ all while waiting for the write
> to device_state to return?  That implies quite a lot of asynchronous
> support in the userspace driver.  Thanks,
yes.
(1) when user sets device_state to _SAVING, the vendor driver notifies this
IRQ, waits until user IRQ ack is received.
(2) in IRQ handler, user decodes and sends IRQ ack to vendor driver.

if a wait is required in (1) returns, it demands the qemu_mutex_iothread is
not locked in migration thread when device_state is set in (1), as before
entering (2), acquiring of this mutex is required.

Currently, this lock is not hold in vfio_migration_set_state() at
save_setup stage but is hold in stop and copy stage. so we wait in
kernel in save_setup stage and not wait in stop stage.
it can be fixed by calling qemu_mutex_unlock_iothread() on entering
vfio_migration_set_state() and qemu_mutex_lock_iothread() on leaving
vfio_migration_set_state() in qemu.

do you think it's acceptable?

Thanks
Yan
> 
> 
> > +
> > +
> >  /**
> >   * VFIO_DEVICE_SET_IRQS - _IOW(VFIO_TYPE, VFIO_BASE + 10, struct vfio_irq_set)
> >   *
> 
