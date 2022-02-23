Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4D5EA4C1810
	for <lists+kvm@lfdr.de>; Wed, 23 Feb 2022 17:04:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242598AbiBWQER (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 23 Feb 2022 11:04:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57410 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242589AbiBWQEO (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 23 Feb 2022 11:04:14 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4107AC1149;
        Wed, 23 Feb 2022 08:03:46 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 02341B81E07;
        Wed, 23 Feb 2022 16:03:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0674DC340E7;
        Wed, 23 Feb 2022 16:03:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1645632223;
        bh=jWeqBXnmhv/yp6ESTH9OA8NuBmEWEyuUdhFPVPzAZGc=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Hdc0lrA5dZRtIeA1RbNiQdoue/GFBd1uExyV5sEiImDGn9g8/0gnRnDq0hvxi4n2r
         v9O0f1M7TmK0c8lx+ozjSuDDz9e8c1PY0MtvWUMMlDY8fxkcE+//9igW8MESSZn74/
         uRYM/PUkLjQMaLa4jGCskJB1lUymU+lOib7KSWxA=
Date:   Wed, 23 Feb 2022 17:03:40 +0100
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Jason Gunthorpe <jgg@nvidia.com>
Cc:     Robin Murphy <robin.murphy@arm.com>,
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
Message-ID: <YhZa3D5Xwv5oZm7L@kroah.com>
References: <1acb8748-8d44-688d-2380-f39ec820776f@arm.com>
 <20220222151632.GB10061@nvidia.com>
 <3d4c3bf1-fed6-f640-dc20-36d667de7461@arm.com>
 <20220222235353.GF10061@nvidia.com>
 <171bec90-5ea6-b35b-f027-1b5e961f5ddf@linux.intel.com>
 <880a269d-d39d-bab3-8d19-b493e874ec99@arm.com>
 <20220223134627.GO10061@nvidia.com>
 <YhY/a9wTjmYXsuwt@kroah.com>
 <20220223140901.GP10061@nvidia.com>
 <20220223143011.GQ10061@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220223143011.GQ10061@nvidia.com>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Feb 23, 2022 at 10:30:11AM -0400, Jason Gunthorpe wrote:
> On Wed, Feb 23, 2022 at 10:09:01AM -0400, Jason Gunthorpe wrote:
> > On Wed, Feb 23, 2022 at 03:06:35PM +0100, Greg Kroah-Hartman wrote:
> > > On Wed, Feb 23, 2022 at 09:46:27AM -0400, Jason Gunthorpe wrote:
> > > > On Wed, Feb 23, 2022 at 01:04:00PM +0000, Robin Murphy wrote:
> > > > 
> > > > > 1 - tmp->driver is non-NULL because tmp is already bound.
> > > > >   1.a - If tmp->driver->driver_managed_dma == 0, the group must currently be
> > > > > DMA-API-owned as a whole. Regardless of what driver dev has unbound from,
> > > > > its removal does not release someone else's DMA API (co-)ownership.
> > > > 
> > > > This is an uncommon locking pattern, but it does work. It relies on
> > > > the mutex being an effective synchronization barrier for an unlocked
> > > > store:
> > > > 
> > > > 				      WRITE_ONCE(dev->driver, NULL)
> > > 
> > > Only the driver core should be messing with the dev->driver pointer as
> > > when it does so, it already has the proper locks held.  Do I need to
> > > move that to a "private" location so that nothing outside of the driver
> > > core can mess with it?
> > 
> > It would be nice, I've seen a abuse and mislocking of it in drivers
> 
> Though to be clear, what Robin is describing is still keeping the
> dev->driver stores in dd.c, just reading it in a lockless way from
> other modules.

"other modules" should never care if a device has a driver bound to it
because instantly after the check happens, it can change so what ever
logic it wanted to do with that knowledge is gone.

Unless the bus lock is held that the device is on, but that should be
only accessable from within the driver core as it controls that type of
stuff, not any random other part of the kernel.

And in looking at this, ick, there are loads of places in the kernel
that are thinking that this pointer being set to something actually
means something.  Sometimes it does, but lots of places, it doesn't as
it can change.

In a semi-related incident right now, we currently have a syzbot failure
in the usb gadget code where it was manipulating the ->driver pointer
directly and other parts of the kernel are crashing.  See
https://lore.kernel.org/r/PH0PR11MB58805E3C4CF7D4C41D49BFCFDA3C9@PH0PR11MB5880.namprd11.prod.outlook.com
for the thread.

I'll poke at this as a background task to try to clean up over time.

thanks,

greg k-h
