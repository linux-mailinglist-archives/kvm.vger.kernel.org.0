Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 09FA9166FA6
	for <lists+kvm@lfdr.de>; Fri, 21 Feb 2020 07:30:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726930AbgBUG3p (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 21 Feb 2020 01:29:45 -0500
Received: from mga01.intel.com ([192.55.52.88]:34367 "EHLO mga01.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726853AbgBUG3p (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 21 Feb 2020 01:29:45 -0500
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by fmsmga101.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 20 Feb 2020 22:29:45 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.70,467,1574150400"; 
   d="scan'208";a="315971204"
Received: from joy-optiplex-7040.sh.intel.com (HELO joy-OptiPlex-7040) ([10.239.13.16])
  by orsmga001.jf.intel.com with ESMTP; 20 Feb 2020 22:29:42 -0800
Date:   Fri, 21 Feb 2020 01:20:21 -0500
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
Subject: Re: [RFC PATCH v3 6/9] vfio/pci: export vfio_pci_setup_barmap
Message-ID: <20200221062021.GD30338@joy-OptiPlex-7040>
Reply-To: Yan Zhao <yan.y.zhao@intel.com>
References: <20200211095727.20426-1-yan.y.zhao@intel.com>
 <20200211101419.21067-1-yan.y.zhao@intel.com>
 <20200220140013.66a6b52c@w520.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200220140013.66a6b52c@w520.home>
User-Agent: Mutt/1.9.4 (2018-02-28)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Feb 21, 2020 at 05:00:13AM +0800, Alex Williamson wrote:
> On Tue, 11 Feb 2020 05:14:19 -0500
> Yan Zhao <yan.y.zhao@intel.com> wrote:
> 
> > This allows vendor driver to read/write to bars directly which is useful
> > in security checking condition.
> > 
> > Signed-off-by: Yan Zhao <yan.y.zhao@intel.com>
> > ---
> >  drivers/vfio/pci/vfio_pci_rdwr.c | 26 +++++++++++++-------------
> >  include/linux/vfio.h             |  2 ++
> >  2 files changed, 15 insertions(+), 13 deletions(-)
> > 
> > diff --git a/drivers/vfio/pci/vfio_pci_rdwr.c b/drivers/vfio/pci/vfio_pci_rdwr.c
> > index a0ef1de4f74a..3ba85fb2af5b 100644
> > --- a/drivers/vfio/pci/vfio_pci_rdwr.c
> > +++ b/drivers/vfio/pci/vfio_pci_rdwr.c
> > @@ -129,7 +129,7 @@ static ssize_t do_io_rw(void __iomem *io, char __user *buf,
> >  	return done;
> >  }
> >  
> > -static int vfio_pci_setup_barmap(struct vfio_pci_device *vdev, int bar)
> > +void __iomem *vfio_pci_setup_barmap(struct vfio_pci_device *vdev, int bar)
> >  {
> >  	struct pci_dev *pdev = vdev->pdev;
> >  	struct vfio_pci_device_private *priv = VDEV_TO_PRIV(vdev);
> > @@ -137,22 +137,23 @@ static int vfio_pci_setup_barmap(struct vfio_pci_device *vdev, int bar)
> >  	void __iomem *io;
> >  
> >  	if (priv->barmap[bar])
> > -		return 0;
> > +		return priv->barmap[bar];
> >  
> >  	ret = pci_request_selected_regions(pdev, 1 << bar, "vfio");
> >  	if (ret)
> > -		return ret;
> > +		return NULL;
> >  
> >  	io = pci_iomap(pdev, bar, 0);
> >  	if (!io) {
> >  		pci_release_selected_regions(pdev, 1 << bar);
> > -		return -ENOMEM;
> > +		return NULL;
> >  	}
> >  
> >  	priv->barmap[bar] = io;
> >  
> > -	return 0;
> > +	return io;
> >  }
> > +EXPORT_SYMBOL_GPL(vfio_pci_setup_barmap);
> 
> This should instead become a vfio_pci_get_barmap() function that tests
> for an optionally calls vfio_pci_setup_barmap before returning the
> pointer.  I'm now willing to lose the better error returns in the
> original.  Thanks,
>
Got it. will change it.
Thanks!

Yan
