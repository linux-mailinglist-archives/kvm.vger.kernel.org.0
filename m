Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3B58447DF5F
	for <lists+kvm@lfdr.de>; Thu, 23 Dec 2021 08:13:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346758AbhLWHN3 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 23 Dec 2021 02:13:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33194 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235212AbhLWHN2 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 23 Dec 2021 02:13:28 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2D978C061401;
        Wed, 22 Dec 2021 23:13:28 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id C68F2B81F7C;
        Thu, 23 Dec 2021 07:13:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 53BCDC36AE5;
        Thu, 23 Dec 2021 07:13:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1640243605;
        bh=yIZy+IXiNwlPro62GwZKOzKJyYp9ZVwUyRkhzfCo5Uk=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=RgquxtfV+yuQOJyPb2PfMc4Lc2pxHNJ6ljVc/4MoShgz9XCyOKVzWEynI2uNkeKld
         GiI7eYSqDI2wdjpmTXG6UMelhNYaji1XcL9xekE0a7xSj41VBa502BAeW0J/nmtQvG
         5FhjLfWMrrd4OqTsVFHhkcQQB8reAtmIm707kyV4=
Date:   Thu, 23 Dec 2021 08:13:21 +0100
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Lu Baolu <baolu.lu@linux.intel.com>
Cc:     Joerg Roedel <joro@8bytes.org>,
        Alex Williamson <alex.williamson@redhat.com>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Jason Gunthorpe <jgg@nvidia.com>,
        Christoph Hellwig <hch@infradead.org>,
        Kevin Tian <kevin.tian@intel.com>,
        Ashok Raj <ashok.raj@intel.com>, Will Deacon <will@kernel.org>,
        Robin Murphy <robin.murphy@arm.com>,
        Dan Williams <dan.j.williams@intel.com>, rafael@kernel.org,
        Diana Craciun <diana.craciun@oss.nxp.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Eric Auger <eric.auger@redhat.com>,
        Liu Yi L <yi.l.liu@intel.com>,
        Jacob jun Pan <jacob.jun.pan@intel.com>,
        Chaitanya Kulkarni <kch@nvidia.com>,
        Stuart Yoder <stuyoder@gmail.com>,
        Laurentiu Tudor <laurentiu.tudor@nxp.com>,
        Thierry Reding <thierry.reding@gmail.com>,
        David Airlie <airlied@linux.ie>,
        Daniel Vetter <daniel@ffwll.ch>,
        Jonathan Hunter <jonathanh@nvidia.com>,
        Li Yang <leoyang.li@nxp.com>,
        Dmitry Osipenko <digetx@gmail.com>,
        iommu@lists.linux-foundation.org, linux-pci@vger.kernel.org,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v4 02/13] driver core: Set DMA ownership during driver
 bind/unbind
Message-ID: <YcQhka64aqHJ5uE7@kroah.com>
References: <20211217063708.1740334-1-baolu.lu@linux.intel.com>
 <20211217063708.1740334-3-baolu.lu@linux.intel.com>
 <YcMeZlN3798noycN@kroah.com>
 <94e37c45-abc1-c682-5adf-1cc4b6887640@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <94e37c45-abc1-c682-5adf-1cc4b6887640@linux.intel.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Dec 23, 2021 at 11:02:54AM +0800, Lu Baolu wrote:
> Hi Greg,
> 
> On 12/22/21 8:47 PM, Greg Kroah-Hartman wrote:
> > > +
> > > +	return ret;
> > > +}
> > > +
> > > +static void device_dma_cleanup(struct device *dev, struct device_driver *drv)
> > > +{
> > > +	if (!dev->bus->dma_configure)
> > > +		return;
> > > +
> > > +	if (!drv->suppress_auto_claim_dma_owner)
> > > +		iommu_device_release_dma_owner(dev, DMA_OWNER_DMA_API);
> > > +}
> > > +
> > >   static int really_probe(struct device *dev, struct device_driver *drv)
> > >   {
> > >   	bool test_remove = IS_ENABLED(CONFIG_DEBUG_TEST_DRIVER_REMOVE) &&
> > > @@ -574,11 +601,8 @@ static int really_probe(struct device *dev, struct device_driver *drv)
> > >   	if (ret)
> > >   		goto pinctrl_bind_failed;
> > > -	if (dev->bus->dma_configure) {
> > > -		ret = dev->bus->dma_configure(dev);
> > > -		if (ret)
> > > -			goto probe_failed;
> > > -	}
> > > +	if (device_dma_configure(dev, drv))
> > > +		goto pinctrl_bind_failed;
> > Are you sure you are jumping to the proper error path here?  It is not
> > obvious why you changed this.
> 
> The error handling path in really_probe() seems a bit wrong. For
> example,
> 
>  572         /* If using pinctrl, bind pins now before probing */
>  573         ret = pinctrl_bind_pins(dev);
>  574         if (ret)
>  575                 goto pinctrl_bind_failed;
> 
> [...]
> 
>  663 pinctrl_bind_failed:
>  664         device_links_no_driver(dev);
>  665         devres_release_all(dev);
>  666         arch_teardown_dma_ops(dev);
>  667         kfree(dev->dma_range_map);
>  668         dev->dma_range_map = NULL;
>  669         driver_sysfs_remove(dev);
>              ^^^^^^^^^^^^^^^^^^^^^^^^^
>  670         dev->driver = NULL;
>  671         dev_set_drvdata(dev, NULL);
>  672         if (dev->pm_domain && dev->pm_domain->dismiss)
>  673                 dev->pm_domain->dismiss(dev);
>  674         pm_runtime_reinit(dev);
>  675         dev_pm_set_driver_flags(dev, 0);
>  676 done:
>  677         return ret;
> 
> The driver_sysfs_remove() will be called even driver_sysfs_add() hasn't
> been called yet. I can fix this in a separated patch if I didn't miss
> anything.

If this is a bug in the existing kernel, please submit it as a separate
patch so that it can be properly backported to all affected kernels.
Never bury it in an unrelated change that will never get sent to older
kernels.

greg k-h
