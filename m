Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 54EC21EEF77
	for <lists+kvm@lfdr.de>; Fri,  5 Jun 2020 04:25:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726096AbgFECZm (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 4 Jun 2020 22:25:42 -0400
Received: from mga01.intel.com ([192.55.52.88]:40097 "EHLO mga01.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725883AbgFECZm (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 4 Jun 2020 22:25:42 -0400
IronPort-SDR: P28gXnUD9VtcaUuaaeAPmrHXOr4uK424NV3pqrDa8cPNUKvITy0n3GIBCia4xSX899pOUZKJum
 XHHxzAtM6bEw==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Jun 2020 19:25:41 -0700
IronPort-SDR: mxrNqdaQqXQ2gqe6aEfcouUu7qOgm5ZEOjRThWqrlDi6crK3gAbnwHRXVZgkN/dqQzt+JyL14q
 mtXqo5zNvWkA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.73,474,1583222400"; 
   d="scan'208";a="313070957"
Received: from joy-optiplex-7040.sh.intel.com (HELO joy-OptiPlex-7040) ([10.239.13.16])
  by FMSMGA003.fm.intel.com with ESMTP; 04 Jun 2020 19:25:39 -0700
Date:   Thu, 4 Jun 2020 22:15:42 -0400
From:   Yan Zhao <yan.y.zhao@intel.com>
To:     Cornelia Huck <cohuck@redhat.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        alex.williamson@redhat.com, zhenyuw@linux.intel.com,
        zhi.a.wang@intel.com, kevin.tian@intel.com, shaopeng.he@intel.com,
        yi.l.liu@intel.com, xin.zeng@intel.com, hang.yuan@intel.com
Subject: Re: [RFC PATCH v4 04/10] vfio/pci: let vfio_pci know number of
 vendor regions and vendor irqs
Message-ID: <20200605021542.GG12300@joy-OptiPlex-7040>
Reply-To: Yan Zhao <yan.y.zhao@intel.com>
References: <20200518024202.13996-1-yan.y.zhao@intel.com>
 <20200518024944.14263-1-yan.y.zhao@intel.com>
 <20200604172515.614e9864.cohuck@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200604172515.614e9864.cohuck@redhat.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Jun 04, 2020 at 05:25:15PM +0200, Cornelia Huck wrote:
> On Sun, 17 May 2020 22:49:44 -0400
> Yan Zhao <yan.y.zhao@intel.com> wrote:
> 
> > This allows a simpler VFIO_DEVICE_GET_INFO ioctl in vendor driver
> > 
> > Cc: Kevin Tian <kevin.tian@intel.com>
> > Signed-off-by: Yan Zhao <yan.y.zhao@intel.com>
> > ---
> >  drivers/vfio/pci/vfio_pci.c         | 23 +++++++++++++++++++++--
> >  drivers/vfio/pci/vfio_pci_private.h |  2 ++
> >  include/linux/vfio.h                |  3 +++
> >  3 files changed, 26 insertions(+), 2 deletions(-)
> > 
> > diff --git a/drivers/vfio/pci/vfio_pci.c b/drivers/vfio/pci/vfio_pci.c
> > index 290b7ab55ecf..30137c1c5308 100644
> > --- a/drivers/vfio/pci/vfio_pci.c
> > +++ b/drivers/vfio/pci/vfio_pci.c
> > @@ -105,6 +105,24 @@ void *vfio_pci_vendor_data(void *device_data)
> >  }
> >  EXPORT_SYMBOL_GPL(vfio_pci_vendor_data);
> >  
> > +int vfio_pci_set_vendor_regions(void *device_data, int num_vendor_regions)
> > +{
> > +	struct vfio_pci_device *vdev = device_data;
> > +
> > +	vdev->num_vendor_regions = num_vendor_regions;
> 
> Do we need any kind of sanity check here, in case this is called with a
> bogus value?
>
you are right. it at least needs to be >=0.
maybe type of "unsigned int" is more appropriate for num_vendor_regions.
we don't need to check its max value as QEMU would check it.

> > +	return 0;
> > +}
> > +EXPORT_SYMBOL_GPL(vfio_pci_set_vendor_regions);
> > +
> > +
> > +int vfio_pci_set_vendor_irqs(void *device_data, int num_vendor_irqs)
> > +{
> > +	struct vfio_pci_device *vdev = device_data;
> > +
> > +	vdev->num_vendor_irqs = num_vendor_irqs;
> 
> Here as well.
yes. will change the type to "unsigned int". 
Thank you for kindly reviewing:)

Yan

> 
> > +	return 0;
> > +}
> > +EXPORT_SYMBOL_GPL(vfio_pci_set_vendor_irqs);
> >  /*
> >   * Our VGA arbiter participation is limited since we don't know anything
> >   * about the device itself.  However, if the device is the only VGA device
> 
> (...)
> 
