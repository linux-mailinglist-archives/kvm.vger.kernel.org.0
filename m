Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 82D4B114C3C
	for <lists+kvm@lfdr.de>; Fri,  6 Dec 2019 06:59:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726203AbfLFF7J (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 6 Dec 2019 00:59:09 -0500
Received: from mga01.intel.com ([192.55.52.88]:56909 "EHLO mga01.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726043AbfLFF7J (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 6 Dec 2019 00:59:09 -0500
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by fmsmga101.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 05 Dec 2019 21:59:08 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.69,283,1571727600"; 
   d="scan'208";a="413229029"
Received: from joy-optiplex-7040.sh.intel.com (HELO joy-OptiPlex-7040) ([10.239.13.9])
  by fmsmga006.fm.intel.com with ESMTP; 05 Dec 2019 21:59:06 -0800
Date:   Fri, 6 Dec 2019 00:50:57 -0500
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
Subject: Re: [RFC PATCH 3/9] vfio/pci: register a default migration region
Message-ID: <20191206055057.GE31791@joy-OptiPlex-7040>
Reply-To: Yan Zhao <yan.y.zhao@intel.com>
References: <20191205032419.29606-1-yan.y.zhao@intel.com>
 <20191205032638.29747-1-yan.y.zhao@intel.com>
 <20191205165515.3a9ac7b6@x1.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191205165515.3a9ac7b6@x1.home>
User-Agent: Mutt/1.9.4 (2018-02-28)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Dec 06, 2019 at 07:55:15AM +0800, Alex Williamson wrote:
> On Wed,  4 Dec 2019 22:26:38 -0500
> Yan Zhao <yan.y.zhao@intel.com> wrote:
> 
> > Vendor driver specifies when to support a migration region through cap
> > VFIO_PCI_DEVICE_CAP_MIGRATION in vfio_pci_mediate_ops->open().
> > 
> > If vfio-pci detects this cap, it creates a default migration region on
> > behalf of vendor driver with region len=0 and region->ops=null.
> > Vendor driver should override this region's len, flags, rw, mmap in
> > its vfio_pci_mediate_ops.
> > 
> > This migration region definition is aligned to QEMU vfio migration code v8:
> > (https://lists.gnu.org/archive/html/qemu-devel/2019-08/msg05542.html)
> > 
> > Cc: Kevin Tian <kevin.tian@intel.com>
> > 
> > Signed-off-by: Yan Zhao <yan.y.zhao@intel.com>
> > ---
> >  drivers/vfio/pci/vfio_pci.c |  15 ++++
> >  include/linux/vfio.h        |   1 +
> >  include/uapi/linux/vfio.h   | 149 ++++++++++++++++++++++++++++++++++++
> >  3 files changed, 165 insertions(+)
> > 
> > diff --git a/drivers/vfio/pci/vfio_pci.c b/drivers/vfio/pci/vfio_pci.c
> > index f3730252ee82..059660328be2 100644
> > --- a/drivers/vfio/pci/vfio_pci.c
> > +++ b/drivers/vfio/pci/vfio_pci.c
> > @@ -115,6 +115,18 @@ static inline bool vfio_pci_is_vga(struct pci_dev *pdev)
> >  	return (pdev->class >> 8) == PCI_CLASS_DISPLAY_VGA;
> >  }
> >  
> > +/**
> > + * init a region to hold migration ctl & data
> > + */
> > +void init_migration_region(struct vfio_pci_device *vdev)
> > +{
> > +	vfio_pci_register_dev_region(vdev, VFIO_REGION_TYPE_MIGRATION,
> > +		VFIO_REGION_SUBTYPE_MIGRATION,
> > +		NULL, 0,
> > +		VFIO_REGION_INFO_FLAG_READ | VFIO_REGION_INFO_FLAG_WRITE,
> > +		NULL);
> > +}
> > +
> >  static void vfio_pci_probe_mmaps(struct vfio_pci_device *vdev)
> >  {
> >  	struct resource *res;
> > @@ -523,6 +535,9 @@ static int vfio_pci_open(void *device_data)
> >  				vdev->mediate_ops = mentry->ops;
> >  				vdev->mediate_handle = handle;
> >  
> > +				if (caps & VFIO_PCI_DEVICE_CAP_MIGRATION)
> > +					init_migration_region(vdev);
> 
> No.  We're not going to add a cap flag for every region the mediation
> driver wants to add.  The mediation driver should have the ability to
> add regions and irqs to the device itself.  Thanks,
> 
> Alex
>
ok. got it. will do it.

Thanks
Yan

> > +
> >  				pr_info("vfio pci found mediate_ops %s, caps=%llx, handle=%x for %x:%x\n",
> >  						vdev->mediate_ops->name, caps,
> >  						handle, vdev->pdev->vendor,
> 
