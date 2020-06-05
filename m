Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 160B71EEF62
	for <lists+kvm@lfdr.de>; Fri,  5 Jun 2020 04:15:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726039AbgFECPn (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 4 Jun 2020 22:15:43 -0400
Received: from mga11.intel.com ([192.55.52.93]:40348 "EHLO mga11.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725497AbgFECPn (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 4 Jun 2020 22:15:43 -0400
IronPort-SDR: 4cZvkpiO5iy+TjrzPkBPFkERG+G1jTgZr6YhfH6TlYH2IfkYVkF7mIVLTYLiEmwMFRjrmkvFS/
 tC4pxQw39ALQ==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Jun 2020 19:15:42 -0700
IronPort-SDR: c0ydNC01UE0ed8Wck3XmLlgqeosrsEOvl11BGLEIUWO2YGQ4jc4RaVFDt5iTwsgncgaR5V5Q/T
 hYt4fEvYJZ5A==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.73,474,1583222400"; 
   d="scan'208";a="313068854"
Received: from joy-optiplex-7040.sh.intel.com (HELO joy-OptiPlex-7040) ([10.239.13.16])
  by FMSMGA003.fm.intel.com with ESMTP; 04 Jun 2020 19:15:39 -0700
Date:   Thu, 4 Jun 2020 22:05:43 -0400
From:   Yan Zhao <yan.y.zhao@intel.com>
To:     Cornelia Huck <cohuck@redhat.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        alex.williamson@redhat.com, zhenyuw@linux.intel.com,
        zhi.a.wang@intel.com, kevin.tian@intel.com, shaopeng.he@intel.com,
        yi.l.liu@intel.com, xin.zeng@intel.com, hang.yuan@intel.com
Subject: Re: [RFC PATCH v4 02/10] vfio/pci: macros to generate module_init
 and module_exit for vendor modules
Message-ID: <20200605020543.GF12300@joy-OptiPlex-7040>
Reply-To: Yan Zhao <yan.y.zhao@intel.com>
References: <20200518024202.13996-1-yan.y.zhao@intel.com>
 <20200518024510.14115-1-yan.y.zhao@intel.com>
 <20200604170106.561db9ad.cohuck@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200604170106.561db9ad.cohuck@redhat.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Jun 04, 2020 at 05:01:06PM +0200, Cornelia Huck wrote:
> On Sun, 17 May 2020 22:45:10 -0400
> Yan Zhao <yan.y.zhao@intel.com> wrote:
> 
> > vendor modules call macro module_vfio_pci_register_vendor_handler to
> > generate module_init and module_exit.
> > It is necessary to ensure that vendor modules always call
> > vfio_pci_register_vendor_driver() on driver loading and
> > vfio_pci_unregister_vendor_driver on driver unloading,
> > because
> > (1) at compiling time, there's only a dependency of vendor modules on
> > vfio_pci.
> > (2) at runtime,
> > - vendor modules add refs of vfio_pci on a successful calling of
> >   vfio_pci_register_vendor_driver() and deref of vfio_pci on a
> >   successful calling of vfio_pci_unregister_vendor_driver().
> > - vfio_pci only adds refs of vendor module on a successful probe of vendor
> >   driver.
> >   vfio_pci derefs vendor module when unbinding from a device.
> > 
> > So, after vfio_pci is unbound from a device, the vendor module to that
> > device is free to get unloaded. However, if that vendor module does not
> > call vfio_pci_unregister_vendor_driver() in its module_exit, vfio_pci may
> > hold a stale pointer to vendor module.
> > 
> > Cc: Kevin Tian <kevin.tian@intel.com>
> > Suggested-by: Alex Williamson <alex.williamson@redhat.com>
> > Signed-off-by: Yan Zhao <yan.y.zhao@intel.com>
> > ---
> >  include/linux/vfio.h | 27 +++++++++++++++++++++++++++
> >  1 file changed, 27 insertions(+)
> > 
> > diff --git a/include/linux/vfio.h b/include/linux/vfio.h
> > index 3e53deb012b6..f3746608c2d9 100644
> > --- a/include/linux/vfio.h
> > +++ b/include/linux/vfio.h
> > @@ -223,4 +223,31 @@ struct vfio_pci_vendor_driver_ops {
> >  };
> >  int __vfio_pci_register_vendor_driver(struct vfio_pci_vendor_driver_ops *ops);
> >  void vfio_pci_unregister_vendor_driver(struct vfio_device_ops *device_ops);
> > +
> > +#define vfio_pci_register_vendor_driver(__name, __probe, __remove,	\
> > +					__device_ops)			\
> > +static struct vfio_pci_vendor_driver_ops  __ops ## _node = {		\
> > +	.owner		= THIS_MODULE,					\
> > +	.name		= __name,					\
> > +	.probe		= __probe,					\
> > +	.remove		= __remove,					\
> > +	.device_ops	= __device_ops,					\
> > +};									\
> > +__vfio_pci_register_vendor_driver(&__ops ## _node)
> > +
> > +#define module_vfio_pci_register_vendor_handler(name, probe, remove,	\
> > +						device_ops)		\
> > +static int __init device_ops ## _module_init(void)			\
> > +{									\
> > +	vfio_pci_register_vendor_driver(name, probe, remove,		\
> > +					device_ops);			\
> 
> What if this function fails (e.g. with -ENOMEM)?
>
right. I need to return error in that case.

Thanks for pointing it out!

Yan

> > +	return 0;							\
> > +};									\
> > +static void __exit device_ops ## _module_exit(void)			\
> > +{									\
> > +	vfio_pci_unregister_vendor_driver(device_ops);			\
> > +};									\
> > +module_init(device_ops ## _module_init);				\
> > +module_exit(device_ops ## _module_exit)
> > +
> >  #endif /* VFIO_H */
> 
