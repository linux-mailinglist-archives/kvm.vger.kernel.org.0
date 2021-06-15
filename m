Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E344F3A81E5
	for <lists+kvm@lfdr.de>; Tue, 15 Jun 2021 16:09:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230334AbhFOOLu (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 15 Jun 2021 10:11:50 -0400
Received: from mail.kernel.org ([198.145.29.99]:32998 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230179AbhFOOLq (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 15 Jun 2021 10:11:46 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id A68E36140B;
        Tue, 15 Jun 2021 14:09:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1623766181;
        bh=OMsydzJ7/CusvrwDxbCYLQi8oWAlMaMW3Xt8gZ1etAs=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Wm7A40d50+9VaKpz9XYeeOgBpJDmnTp0hAVk/RetFskhy4Bt2EBQaahKocXC4SMI3
         TVyoOTrEHU8DMYX62jKtl/LHOdlSxwZS7LUXDJB9zkQ3BVrZHrX9k5/QWdGufMHOmB
         QJBNHz/SjGTIx/pWmk0IewhuVqH4Alwo17ezCNW8=
Date:   Tue, 15 Jun 2021 16:09:39 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Cornelia Huck <cohuck@redhat.com>
Cc:     Christoph Hellwig <hch@lst.de>, Jason Gunthorpe <jgg@nvidia.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        Kirti Wankhede <kwankhede@nvidia.com>,
        David Airlie <airlied@linux.ie>,
        Tony Krowiak <akrowiak@linux.ibm.com>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Jonathan Corbet <corbet@lwn.net>,
        Daniel Vetter <daniel@ffwll.ch>,
        dri-devel@lists.freedesktop.org, Vasily Gorbik <gor@linux.ibm.com>,
        Heiko Carstens <hca@linux.ibm.com>,
        intel-gfx@lists.freedesktop.org,
        Jani Nikula <jani.nikula@linux.intel.com>,
        Jason Herne <jjherne@linux.ibm.com>,
        Joonas Lahtinen <joonas.lahtinen@linux.intel.com>,
        kvm@vger.kernel.org, linux-doc@vger.kernel.org,
        linux-s390@vger.kernel.org, Halil Pasic <pasic@linux.ibm.com>,
        "Rafael J. Wysocki" <rafael@kernel.org>,
        Rodrigo Vivi <rodrigo.vivi@intel.com>
Subject: Re: [PATCH 02/10] driver core: Better distinguish probe errors in
 really_probe
Message-ID: <YMi0o6iG/+BbPPO4@kroah.com>
References: <20210615133519.754763-1-hch@lst.de>
 <20210615133519.754763-3-hch@lst.de>
 <8735tjxmhh.fsf@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <8735tjxmhh.fsf@redhat.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Jun 15, 2021 at 03:53:46PM +0200, Cornelia Huck wrote:
> On Tue, Jun 15 2021, Christoph Hellwig <hch@lst.de> wrote:
> 
> > really_probe tries to special case errors from ->probe, but due to all
> > other initialization added to the function over time now a lot of
> > internal errors hit that code path as well.  Untangle that by adding
> > a new probe_err local variable and apply the special casing only to
> > that.
> >
> > Signed-off-by: Christoph Hellwig <hch@lst.de>
> > ---
> >  drivers/base/dd.c | 72 +++++++++++++++++++++++++++--------------------
> >  1 file changed, 42 insertions(+), 30 deletions(-)
> >
> > diff --git a/drivers/base/dd.c b/drivers/base/dd.c
> > index 7477d3322b3a..fd83817240e6 100644
> > --- a/drivers/base/dd.c
> > +++ b/drivers/base/dd.c
> > @@ -513,12 +513,44 @@ static ssize_t state_synced_show(struct device *dev,
> >  }
> >  static DEVICE_ATTR_RO(state_synced);
> >  
> > +
> > +static int call_driver_probe(struct device *dev, struct device_driver *drv)
> > +{
> > +	int ret = 0;
> > +
> > +	if (dev->bus->probe)
> > +		ret = dev->bus->probe(dev);
> > +	else if (drv->probe)
> > +		ret = drv->probe(dev);
> > +
> > +	switch (ret) {
> > +	case 0:
> > +		break;
> > +	case -EPROBE_DEFER:
> > +		/* Driver requested deferred probing */
> > +		dev_dbg(dev, "Driver %s requests probe deferral\n", drv->name);
> > +		break;
> > +	case -ENODEV:
> > +	case -ENXIO:
> > +		pr_debug("%s: probe of %s rejects match %d\n",
> > +			 drv->name, dev_name(dev), ret);
> > +		break;
> > +	default:
> > +		/* driver matched but the probe failed */
> > +		pr_warn("%s: probe of %s failed with error %d\n",
> > +			drv->name, dev_name(dev), ret);
> 
> Convert these two pr_* to dev_* when touching the code anyway?

It can wait, it's just moving code around for now.

thanks,

greg k-h
