Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 14086166FA2
	for <lists+kvm@lfdr.de>; Fri, 21 Feb 2020 07:29:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726244AbgBUG2y (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 21 Feb 2020 01:28:54 -0500
Received: from mga07.intel.com ([134.134.136.100]:53861 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726045AbgBUG2y (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 21 Feb 2020 01:28:54 -0500
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by orsmga105.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 20 Feb 2020 22:28:52 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.70,467,1574150400"; 
   d="scan'208";a="383375860"
Received: from joy-optiplex-7040.sh.intel.com (HELO joy-OptiPlex-7040) ([10.239.13.16])
  by orsmga004.jf.intel.com with ESMTP; 20 Feb 2020 22:28:50 -0800
Date:   Fri, 21 Feb 2020 01:19:29 -0500
From:   Yan Zhao <yan.y.zhao@intel.com>
To:     Alex Williamson <alex.williamson@redhat.com>
Cc:     "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "cohuck@redhat.com" <cohuck@redhat.com>,
        "zhenyuw@linux.intel.com" <zhenyuw@linux.intel.com>,
        "Wang, Zhi A" <zhi.a.wang@intel.com>,
        "Tian, Kevin" <kevin.tian@intel.com>,
        "He, Shaopeng" <shaopeng.he@intel.com>,
        "Liu, Yi L" <yi.l.liu@intel.com>
Subject: Re: [RFC PATCH v3 1/9] vfio/pci: export vfio_pci_device public and
 add vfio_pci_device_private
Message-ID: <20200221061929.GC30338@joy-OptiPlex-7040>
Reply-To: Yan Zhao <yan.y.zhao@intel.com>
References: <20200211095727.20426-1-yan.y.zhao@intel.com>
 <20200211101038.20772-1-yan.y.zhao@intel.com>
 <20200220140011.79621d7f@w520.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200220140011.79621d7f@w520.home>
User-Agent: Mutt/1.9.4 (2018-02-28)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Feb 21, 2020 at 05:00:11AM +0800, Alex Williamson wrote:
> On Tue, 11 Feb 2020 05:10:38 -0500
> Yan Zhao <yan.y.zhao@intel.com> wrote:
> 
> > (1) make vfio_pci_device public, so it is accessible from external code.
> > (2) add a private struct vfio_pci_device_private, which is only accessible
> > from internal code. It extends struct vfio_pci_device.
> > 
> > Signed-off-by: Yan Zhao <yan.y.zhao@intel.com>
> > ---
> >  drivers/vfio/pci/vfio_pci.c         | 256 +++++++++++++++-------------
> >  drivers/vfio/pci/vfio_pci_config.c  | 186 ++++++++++++--------
> >  drivers/vfio/pci/vfio_pci_igd.c     |  19 ++-
> >  drivers/vfio/pci/vfio_pci_intrs.c   | 186 +++++++++++---------
> >  drivers/vfio/pci/vfio_pci_nvlink2.c |  22 +--
> >  drivers/vfio/pci/vfio_pci_private.h |   7 +-
> >  drivers/vfio/pci/vfio_pci_rdwr.c    |  40 +++--
> >  include/linux/vfio.h                |   5 +
> >  8 files changed, 408 insertions(+), 313 deletions(-)
> 
> [SNIP!]
> 
> > diff --git a/include/linux/vfio.h b/include/linux/vfio.h
> > index e42a711a2800..70a2b8fb6179 100644
> > --- a/include/linux/vfio.h
> > +++ b/include/linux/vfio.h
> > @@ -195,4 +195,9 @@ extern int vfio_virqfd_enable(void *opaque,
> >  			      void *data, struct virqfd **pvirqfd, int fd);
> >  extern void vfio_virqfd_disable(struct virqfd **pvirqfd);
> >  
> > +struct vfio_pci_device {
> > +	struct pci_dev			*pdev;
> > +	int				num_regions;
> > +	int				irq_type;
> > +};
> >  #endif /* VFIO_H */
> 
> Hi Yan,
> 
> Sorry for the delay.  I'm still not very happy with this result, I was
> hoping the changes could be done less intrusively.  Maybe here's
> another suggestion, why can't the vendor driver use a struct
> vfio_pci_device* as an opaque pointer?  If you only want these three
> things initially, I think this whole massive patch can be reduced to:
> 
> struct pci_dev *vfio_pci_pdev(struct vfio_pci_device *vdev)
> {
> 	return vdev->pdev;
> }
> EXPORT_SYMBOL_GPL(vfio_pci_dev);
> 
> int vfio_pci_num_regions(struct vfio_pci_device *vdev)
> {
> 	return vdev->num_regions;
> }
> EXPORT_SYMBOL_GPL(vfio_pci_num_region);
> 
> int vfio_pci_irq_type(struct vfio_pci_device *vdev)
> {
> 	return vdev->irq_type;
> }
> EXPORT_SYMBOL_GPL(vfio_pci_irq_type);
> 
> This is how vfio-pci works with vfio, we don't know a struct
> vfio_device as anything other than an opaque pointer and we have access
> function where we need to see some property of that object.
> 
> Patch 5/9 would become a vfio_pci_set_vendor_regions() interface.
>
you are right!
I'll change it to this way. Thanks.

Yan
