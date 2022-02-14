Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A20C84B51E9
	for <lists+kvm@lfdr.de>; Mon, 14 Feb 2022 14:40:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346008AbiBNNjc (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 14 Feb 2022 08:39:32 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:52790 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232787AbiBNNjb (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 14 Feb 2022 08:39:31 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 84A544F9E2;
        Mon, 14 Feb 2022 05:39:23 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 384C0B80EBA;
        Mon, 14 Feb 2022 13:39:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 426C2C340E9;
        Mon, 14 Feb 2022 13:39:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1644845961;
        bh=4U+A1gw9pHI8+F1lRx72vcSbg59p+z2E+RDWPKyoPxk=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=VvTuMQbyYZ+oxoBg9e7TOef1M4ivC4+20f8nXQhpZ/l1FFQB8pk4gMFSguknC5UTG
         DDMjq9zO15j6PI+WRGN+ygfcoJnD4iUh/bCu00K998ZP92NBi7im/xSt+51loqvxdd
         ObfQNYeFBG3xEAgCtvkEmb/rUjEPZ4Ug1Ji9f83o=
Date:   Mon, 14 Feb 2022 14:39:18 +0100
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Jason Gunthorpe <jgg@nvidia.com>
Cc:     Lu Baolu <baolu.lu@linux.intel.com>,
        Joerg Roedel <joro@8bytes.org>,
        Alex Williamson <alex.williamson@redhat.com>,
        Bjorn Helgaas <bhelgaas@google.com>,
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
Subject: Re: [PATCH v5 07/14] PCI: Add driver dma ownership management
Message-ID: <YgpbhlPOZsLFm4It@kroah.com>
References: <20220104015644.2294354-1-baolu.lu@linux.intel.com>
 <20220104015644.2294354-8-baolu.lu@linux.intel.com>
 <Ygoo/lCt/G6tWDz9@kroah.com>
 <20220214123842.GT4160@nvidia.com>
 <YgpQOmBA7QJJu+2E@kroah.com>
 <20220214131117.GW4160@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220214131117.GW4160@nvidia.com>
X-Spam-Status: No, score=-7.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Feb 14, 2022 at 09:11:17AM -0400, Jason Gunthorpe wrote:
> On Mon, Feb 14, 2022 at 01:51:06PM +0100, Greg Kroah-Hartman wrote:
> > On Mon, Feb 14, 2022 at 08:38:42AM -0400, Jason Gunthorpe wrote:
> > > On Mon, Feb 14, 2022 at 11:03:42AM +0100, Greg Kroah-Hartman wrote:
> > > > On Tue, Jan 04, 2022 at 09:56:37AM +0800, Lu Baolu wrote:
> > > > > Multiple PCI devices may be placed in the same IOMMU group because
> > > > > they cannot be isolated from each other. These devices must either be
> > > > > entirely under kernel control or userspace control, never a mixture. This
> > > > > checks and sets DMA ownership during driver binding, and release the
> > > > > ownership during driver unbinding.
> > > > > 
> > > > > The device driver may set a new flag (no_kernel_api_dma) to skip calling
> > > > > iommu_device_use_dma_api() during the binding process. For instance, the
> > > > > userspace framework drivers (vfio etc.) which need to manually claim
> > > > > their own dma ownership when assigning the device to userspace.
> > > > > 
> > > > > Signed-off-by: Lu Baolu <baolu.lu@linux.intel.com>
> > > > >  include/linux/pci.h      |  5 +++++
> > > > >  drivers/pci/pci-driver.c | 21 +++++++++++++++++++++
> > > > >  2 files changed, 26 insertions(+)
> > > > > 
> > > > > diff --git a/include/linux/pci.h b/include/linux/pci.h
> > > > > index 18a75c8e615c..d29a990e3f02 100644
> > > > > +++ b/include/linux/pci.h
> > > > > @@ -882,6 +882,10 @@ struct module;
> > > > >   *              created once it is bound to the driver.
> > > > >   * @driver:	Driver model structure.
> > > > >   * @dynids:	List of dynamically added device IDs.
> > > > > + * @no_kernel_api_dma: Device driver doesn't use kernel DMA API for DMA.
> > > > > + *		Drivers which don't require DMA or want to manually claim the
> > > > > + *		owner type (e.g. userspace driver frameworks) could set this
> > > > > + *		flag.
> > > > 
> > > > Again with the bikeshedding, but this name is a bit odd.  Of course it's
> > > > in the kernel, this is all kernel code, so you can drop that.  And
> > > > again, "negative" flags are rough.  So maybe just "prevent_dma"?
> > > 
> > > That is misleading too, it is not that DMA is prevented, but that the
> > > kernel's dma_api has not been setup.
> > 
> > "has not been" or "will not be"?
> 
> "has not been" as that action was supposed to happen before probe(),
> but the flag skips it.
> 
> A driver that sets this flag can still decide to enable the dma API on
> its own. eg tegra drivers do this.

So you are just forcing the driver to manage this all on their own, so
how about, "driver_managed_dma", or even shorter "managed_dma"?

> > What you want to prevent is the iommu core claiming the device
> > automatically, right?  So how about "prevent_iommu_dma"?
> 
> "claim" is not a good description. iommu always "claims" the device -
> eg sets a domain, sets the dev and bus parameters, etc.
> 
> This really is only about setting up the in-kernel dma api, eg
> allowing dma_map_sg()/etc to work.
> 
> dma api is just one way to operate the iommu, there are others too.
> 
> Think of this flag as 
>   false = the driver is going to use the dma api (most common)
>   true = the driver will decide how to use the iommu by itself
> 
> Does it help think of a clearer name?

See above, you want a driver author to know instantly what this is and
not have to look anything up.
"I_will_manage_the_dma_myself_as_I_really_know_what_I_am_doing" might be
good, but a bit too long :)

thanks,

greg k-h
