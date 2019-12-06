Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9570C114C49
	for <lists+kvm@lfdr.de>; Fri,  6 Dec 2019 07:12:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726403AbfLFGMU (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 6 Dec 2019 01:12:20 -0500
Received: from mga02.intel.com ([134.134.136.20]:3059 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726156AbfLFGMU (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 6 Dec 2019 01:12:20 -0500
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by orsmga101.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 05 Dec 2019 22:12:19 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.69,283,1571727600"; 
   d="scan'208";a="209359347"
Received: from joy-optiplex-7040.sh.intel.com (HELO joy-OptiPlex-7040) ([10.239.13.9])
  by fmsmga008.fm.intel.com with ESMTP; 05 Dec 2019 22:12:17 -0800
Date:   Fri, 6 Dec 2019 01:04:07 -0500
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
Message-ID: <20191206060407.GF31791@joy-OptiPlex-7040>
Reply-To: Yan Zhao <yan.y.zhao@intel.com>
References: <20191205032419.29606-1-yan.y.zhao@intel.com>
 <20191205032650.29794-1-yan.y.zhao@intel.com>
 <20191205165530.1f29fe85@x1.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191205165530.1f29fe85@x1.home>
User-Agent: Mutt/1.9.4 (2018-02-28)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Dec 06, 2019 at 07:55:30AM +0800, Alex Williamson wrote:
> On Wed,  4 Dec 2019 22:26:50 -0500
> Yan Zhao <yan.y.zhao@intel.com> wrote:
> 
> > Dynamic trap bar info region is a channel for QEMU and vendor driver to
> > communicate dynamic trap info. It is of type
> > VFIO_REGION_TYPE_DYNAMIC_TRAP_BAR_INFO and subtype
> > VFIO_REGION_SUBTYPE_DYNAMIC_TRAP_BAR_INFO.
> > 
> > This region has two fields: dt_fd and trap.
> > When QEMU detects a device regions of this type, it will create an
> > eventfd and write its eventfd id to dt_fd field.
> > When vendor drivre signals this eventfd, QEMU reads trap field of this
> > info region.
> > - If trap is true, QEMU would search the device's PCI BAR
> > regions and disable all the sparse mmaped subregions (if the sparse
> > mmaped subregion is disablable).
> > - If trap is false, QEMU would re-enable those subregions.
> > 
> > A typical usage is
> > 1. vendor driver first cuts its bar 0 into several sections, all in a
> > sparse mmap array. So initally, all its bar 0 are passthroughed.
> > 2. vendor driver specifys part of bar 0 sections to be disablable.
> > 3. on migration starts, vendor driver signals dt_fd and set trap to true
> > to notify QEMU disabling the bar 0 sections of disablable flags on.
> > 4. QEMU disables those bar 0 section and hence let vendor driver be able
> > to trap access of bar 0 registers and make dirty page tracking possible.
> > 5. on migration failure, vendor driver signals dt_fd to QEMU again.
> > QEMU reads trap field of this info region which is false and QEMU
> > re-passthrough the whole bar 0 region.
> > 
> > Vendor driver specifies whether it supports dynamic-trap-bar-info region
> > through cap VFIO_PCI_DEVICE_CAP_DYNAMIC_TRAP_BAR in
> > vfio_pci_mediate_ops->open().
> > 
> > If vfio-pci detects this cap, it will create a default
> > dynamic_trap_bar_info region on behalf of vendor driver with region len=0
> > and region->ops=null.
> > Vvendor driver should override this region's len, flags, rw, mmap in its
> > vfio_pci_mediate_ops.
> 
> TBH, I don't like this interface at all.  Userspace doesn't pass data
> to the kernel via INFO ioctls.  We have a SET_IRQS ioctl for
> configuring user signaling with eventfds.  I think we only need to
> define an IRQ type that tells the user to re-evaluate the sparse mmap
> information for a region.  The user would enumerate the device IRQs via
> GET_IRQ_INFO, find one of this type where the IRQ info would also
> indicate which region(s) should be re-evaluated on signaling.  The user
> would enable that signaling via SET_IRQS and simply re-evaluate the
ok. I'll try to switch to this way. Thanks for this suggestion.

> sparse mmap capability for the associated regions when signaled.

Do you like the "disablable" flag of sparse mmap ?
I think it's a lightweight way for user to switch mmap state of a whole region,
otherwise going through a complete flow of GET_REGION_INFO and re-setup
region might be too heavy.

Thanks
Yan

> Thanks,
> 
> Alex
>




> > 
> > Cc: Kevin Tian <kevin.tian@intel.com>
> > 
> > Signed-off-by: Yan Zhao <yan.y.zhao@intel.com>
> > ---
> >  drivers/vfio/pci/vfio_pci.c | 16 ++++++++++++++++
> >  include/linux/vfio.h        |  3 ++-
> >  include/uapi/linux/vfio.h   | 11 +++++++++++
> >  3 files changed, 29 insertions(+), 1 deletion(-)
> > 
> > diff --git a/drivers/vfio/pci/vfio_pci.c b/drivers/vfio/pci/vfio_pci.c
> > index 059660328be2..62b811ca43e4 100644
> > --- a/drivers/vfio/pci/vfio_pci.c
> > +++ b/drivers/vfio/pci/vfio_pci.c
> > @@ -127,6 +127,19 @@ void init_migration_region(struct vfio_pci_device *vdev)
> >  		NULL);
> >  }
> >  
> > +/**
> > + * register a region to hold info for dynamically trap bar regions
> > + */
> > +void init_dynamic_trap_bar_info_region(struct vfio_pci_device *vdev)
> > +{
> > +	vfio_pci_register_dev_region(vdev,
> > +		VFIO_REGION_TYPE_DYNAMIC_TRAP_BAR_INFO,
> > +		VFIO_REGION_SUBTYPE_DYNAMIC_TRAP_BAR_INFO,
> > +		NULL, 0,
> > +		VFIO_REGION_INFO_FLAG_READ | VFIO_REGION_INFO_FLAG_WRITE,
> > +		NULL);
> > +}
> > +
> >  static void vfio_pci_probe_mmaps(struct vfio_pci_device *vdev)
> >  {
> >  	struct resource *res;
> > @@ -538,6 +551,9 @@ static int vfio_pci_open(void *device_data)
> >  				if (caps & VFIO_PCI_DEVICE_CAP_MIGRATION)
> >  					init_migration_region(vdev);
> >  
> > +				if (caps & VFIO_PCI_DEVICE_CAP_DYNAMIC_TRAP_BAR)
> > +					init_dynamic_trap_bar_info_region(vdev);
> > +
> >  				pr_info("vfio pci found mediate_ops %s, caps=%llx, handle=%x for %x:%x\n",
> >  						vdev->mediate_ops->name, caps,
> >  						handle, vdev->pdev->vendor,
> > diff --git a/include/linux/vfio.h b/include/linux/vfio.h
> > index cddea8e9dcb2..cf8ecf687bee 100644
> > --- a/include/linux/vfio.h
> > +++ b/include/linux/vfio.h
> > @@ -197,7 +197,8 @@ extern void vfio_virqfd_disable(struct virqfd **pvirqfd);
> >  
> >  struct vfio_pci_mediate_ops {
> >  	char	*name;
> > -#define VFIO_PCI_DEVICE_CAP_MIGRATION (0x01)
> > +#define VFIO_PCI_DEVICE_CAP_MIGRATION		(0x01)
> > +#define VFIO_PCI_DEVICE_CAP_DYNAMIC_TRAP_BAR	(0x02)
> >  	int	(*open)(struct pci_dev *pdev, u64 *caps, u32 *handle);
> >  	void	(*release)(int handle);
> >  	void	(*get_region_info)(int handle,
> > diff --git a/include/uapi/linux/vfio.h b/include/uapi/linux/vfio.h
> > index caf8845a67a6..74a2d0b57741 100644
> > --- a/include/uapi/linux/vfio.h
> > +++ b/include/uapi/linux/vfio.h
> > @@ -258,6 +258,9 @@ struct vfio_region_info {
> >  struct vfio_region_sparse_mmap_area {
> >  	__u64	offset;	/* Offset of mmap'able area within region */
> >  	__u64	size;	/* Size of mmap'able area */
> > +	__u32	disablable;	/* whether this mmap'able are able to
> > +				 *  be dynamically disabled
> > +				 */
> >  };
> >  
> >  struct vfio_region_info_cap_sparse_mmap {
> > @@ -454,6 +457,14 @@ struct vfio_device_migration_info {
> >  #define VFIO_DEVICE_DIRTY_PFNS_ALL	(~0ULL)
> >  } __attribute__((packed));
> >  
> > +/* Region type and sub-type to hold info to dynamically trap bars */
> > +#define VFIO_REGION_TYPE_DYNAMIC_TRAP_BAR_INFO		(4)
> > +#define VFIO_REGION_SUBTYPE_DYNAMIC_TRAP_BAR_INFO	(1)
> > +
> > +struct vfio_device_dt_bar_info_region {
> > +	__u32 dt_fd; /* fd of eventfd to notify qemu trap/untrap bars*/
> > +	__u32 trap;   /* trap/untrap bar regions */
> > +};
> >  
> >  /* sub-types for VFIO_REGION_TYPE_PCI_* */
> >  
> 
