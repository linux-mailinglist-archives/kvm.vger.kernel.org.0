Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D1AF44C1A24
	for <lists+kvm@lfdr.de>; Wed, 23 Feb 2022 18:47:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243499AbiBWRsC (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 23 Feb 2022 12:48:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38860 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237003AbiBWRsB (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 23 Feb 2022 12:48:01 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BAD92B7CC;
        Wed, 23 Feb 2022 09:47:31 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 6FC2EB81FE7;
        Wed, 23 Feb 2022 17:47:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B1CDCC340E7;
        Wed, 23 Feb 2022 17:47:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1645638449;
        bh=PzqyA2XrzzGeBSeh0QDm0Df3zNauEEpV0xJ738q5m/o=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=GQ5bixyNFUH7AJNZGLnUkHJBuszfRkKABSy2/C2lsveMJsuQFFxLDUDGH5B7VsWWa
         ISD0DgXptmhra66h9sdr8wPimVDvIAfn/bzFfXZ8z5OasBUTwbI2wpXCoOwQN2cbFE
         3I95qlanVxIUnpn5ViUUsymh3+vZj7EP6Hc3G9Xw=
Date:   Wed, 23 Feb 2022 18:47:26 +0100
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Robin Murphy <robin.murphy@arm.com>
Cc:     Jason Gunthorpe <jgg@nvidia.com>,
        Lu Baolu <baolu.lu@linux.intel.com>,
        Christoph Hellwig <hch@infradead.org>,
        Joerg Roedel <joro@8bytes.org>,
        Alex Williamson <alex.williamson@redhat.com>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Kevin Tian <kevin.tian@intel.com>,
        Ashok Raj <ashok.raj@intel.com>, kvm@vger.kernel.org,
        rafael@kernel.org, David Airlie <airlied@linux.ie>,
        linux-pci@vger.kernel.org,
        Thierry Reding <thierry.reding@gmail.com>,
        Diana Craciun <diana.craciun@oss.nxp.com>,
        Dmitry Osipenko <digetx@gmail.com>,
        Will Deacon <will@kernel.org>,
        Stuart Yoder <stuyoder@gmail.com>,
        Jonathan Hunter <jonathanh@nvidia.com>,
        Chaitanya Kulkarni <kch@nvidia.com>,
        Dan Williams <dan.j.williams@intel.com>,
        Cornelia Huck <cohuck@redhat.com>,
        linux-kernel@vger.kernel.org, Li Yang <leoyang.li@nxp.com>,
        iommu@lists.linux-foundation.org,
        Jacob jun Pan <jacob.jun.pan@intel.com>,
        Daniel Vetter <daniel@ffwll.ch>
Subject: Re: [PATCH v6 02/11] driver core: Add dma_cleanup callback in
 bus_type
Message-ID: <YhZzLmjVckPRLYj2@kroah.com>
References: <3d4c3bf1-fed6-f640-dc20-36d667de7461@arm.com>
 <20220222235353.GF10061@nvidia.com>
 <171bec90-5ea6-b35b-f027-1b5e961f5ddf@linux.intel.com>
 <880a269d-d39d-bab3-8d19-b493e874ec99@arm.com>
 <20220223134627.GO10061@nvidia.com>
 <YhY/a9wTjmYXsuwt@kroah.com>
 <20220223140901.GP10061@nvidia.com>
 <20220223143011.GQ10061@nvidia.com>
 <YhZa3D5Xwv5oZm7L@kroah.com>
 <78d2dd11-db30-39c8-6df4-d20f0dfbfce2@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <78d2dd11-db30-39c8-6df4-d20f0dfbfce2@arm.com>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Feb 23, 2022 at 05:05:23PM +0000, Robin Murphy wrote:
> On 2022-02-23 16:03, Greg Kroah-Hartman wrote:
> > On Wed, Feb 23, 2022 at 10:30:11AM -0400, Jason Gunthorpe wrote:
> > > On Wed, Feb 23, 2022 at 10:09:01AM -0400, Jason Gunthorpe wrote:
> > > > On Wed, Feb 23, 2022 at 03:06:35PM +0100, Greg Kroah-Hartman wrote:
> > > > > On Wed, Feb 23, 2022 at 09:46:27AM -0400, Jason Gunthorpe wrote:
> > > > > > On Wed, Feb 23, 2022 at 01:04:00PM +0000, Robin Murphy wrote:
> > > > > > 
> > > > > > > 1 - tmp->driver is non-NULL because tmp is already bound.
> > > > > > >    1.a - If tmp->driver->driver_managed_dma == 0, the group must currently be
> > > > > > > DMA-API-owned as a whole. Regardless of what driver dev has unbound from,
> > > > > > > its removal does not release someone else's DMA API (co-)ownership.
> > > > > > 
> > > > > > This is an uncommon locking pattern, but it does work. It relies on
> > > > > > the mutex being an effective synchronization barrier for an unlocked
> > > > > > store:
> > > > > > 
> > > > > > 				      WRITE_ONCE(dev->driver, NULL)
> > > > > 
> > > > > Only the driver core should be messing with the dev->driver pointer as
> > > > > when it does so, it already has the proper locks held.  Do I need to
> > > > > move that to a "private" location so that nothing outside of the driver
> > > > > core can mess with it?
> > > > 
> > > > It would be nice, I've seen a abuse and mislocking of it in drivers
> > > 
> > > Though to be clear, what Robin is describing is still keeping the
> > > dev->driver stores in dd.c, just reading it in a lockless way from
> > > other modules.
> > 
> > "other modules" should never care if a device has a driver bound to it
> > because instantly after the check happens, it can change so what ever
> > logic it wanted to do with that knowledge is gone.
> > 
> > Unless the bus lock is held that the device is on, but that should be
> > only accessable from within the driver core as it controls that type of
> > stuff, not any random other part of the kernel.
> > 
> > And in looking at this, ick, there are loads of places in the kernel
> > that are thinking that this pointer being set to something actually
> > means something.  Sometimes it does, but lots of places, it doesn't as
> > it can change.
> 
> That's fine. In this case we're only talking about the low-level IOMMU code
> which has to be in cahoots with the driver core to some degree (via these
> new callbacks) anyway, but if you're uncomfortable about relying on
> dev->driver even there, I can live with that. There are several potential
> places to capture the relevant information in IOMMU API private data, from
> the point in really_probe() where it *is* stable, and then never look at
> dev->driver ever again - even from .dma_cleanup() or future equivalent,
> which is the aspect from whence this whole proof-of-concept tangent span
> out.

For a specific driver core callback, like dma_cleanup(), all is fine,
but you shouldn't be caring about a driver pointer in your bus callback
for stuff like this as you "know" what happened by virtue of the
callback being called.

thanks,

greg k-h
