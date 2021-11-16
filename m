Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 786C0453901
	for <lists+kvm@lfdr.de>; Tue, 16 Nov 2021 18:57:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239259AbhKPSAo (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 16 Nov 2021 13:00:44 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:27430 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S239255AbhKPSAi (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 16 Nov 2021 13:00:38 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1637085460;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=+eUARFHOxU4OIAktpFmhvthpI+NaXepjdzqs96Y0XYk=;
        b=hxlIMvXwLgV9TQSy0ehJGAt9w0Hb3CPrpJUQYECI52VcoE/+0xuK7APPjnKiG8nfUWcuOj
        gIK5Pes/+OBW2fCXhkfgV7qTX0KVZmo2wuEhjyRHn/oa8qQ5Ha8Sp+qwoUBFfEtE2+i3ek
        FqoaV0kV9uGe953I/pzp9lc0Av3k/Y4=
Received: from mail-oo1-f69.google.com (mail-oo1-f69.google.com
 [209.85.161.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-454-lXvzvEALOQ-eE9EwCa39lQ-1; Tue, 16 Nov 2021 12:57:39 -0500
X-MC-Unique: lXvzvEALOQ-eE9EwCa39lQ-1
Received: by mail-oo1-f69.google.com with SMTP id h15-20020a4a6b4f000000b002b6fa118bfeso9299127oof.18
        for <kvm@vger.kernel.org>; Tue, 16 Nov 2021 09:57:39 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=+eUARFHOxU4OIAktpFmhvthpI+NaXepjdzqs96Y0XYk=;
        b=M/GIsUhGmnSlXmnaw3wb6+mDjwj6N1OWFslmppdAGVZMWgp7IJmnBGyH/CVE3nywcf
         vWpI+11H4f9p8yY8J0owqP3H5a3lbVryjmjAD19pgV/84hIevEyY/mF25EckYgSXuV1U
         MHnRFYDFvK2O4sTPsg27QN6rHsyrV6dqfSJk6N1tBP1Vpg3Ib2gZKInkuzxSPBHoxO6i
         y+h1/vu9frBhDaCCo3o+JmNJkUa9Yg7nOZzGb+IxKzPsf4EldxaD7EoAtmJCpNIVppzB
         n/0mHAW3gcxVzIjE7/I7R1yUPNoVbTARwNrMPHdKZbi9aF40WHW+kw/ZRvRbdYpU9oZW
         2f2g==
X-Gm-Message-State: AOAM533xcG2F8ART06ZZgRxAU4PZx6i/xN9Nm3v/0bieKyhRpzxwBUul
        5T08wG0lE2eAC77mO5xyaPXHfLGXXRBvb/r0ygcDWRXK6LjZ3aa5Djl2ZOiKiSQwgMF5/kDLChA
        DLOmDdx1pG9V1
X-Received: by 2002:a9d:6752:: with SMTP id w18mr7372584otm.13.1637085458581;
        Tue, 16 Nov 2021 09:57:38 -0800 (PST)
X-Google-Smtp-Source: ABdhPJwJwyUET5Y+vjLdMGjqz8zpyWs20WzNkFAzkhwdjelo4QOL6kP0p3e8T5PhM7dsBwMrTJ/pQw==
X-Received: by 2002:a9d:6752:: with SMTP id w18mr7372551otm.13.1637085458244;
        Tue, 16 Nov 2021 09:57:38 -0800 (PST)
Received: from redhat.com ([38.15.36.239])
        by smtp.gmail.com with ESMTPSA id f25sm3179417oog.44.2021.11.16.09.57.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 16 Nov 2021 09:57:37 -0800 (PST)
Date:   Tue, 16 Nov 2021 10:57:36 -0700
From:   Alex Williamson <alex.williamson@redhat.com>
To:     Jason Gunthorpe <jgg@nvidia.com>
Cc:     Shameerali Kolothum Thodi <shameerali.kolothum.thodi@huawei.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Yishai Hadas <yishaih@nvidia.com>, bhelgaas@google.com,
        saeedm@nvidia.com, linux-pci@vger.kernel.org, kvm@vger.kernel.org,
        netdev@vger.kernel.org, kuba@kernel.org, leonro@nvidia.com,
        kwankhede@nvidia.com, mgurtovoy@nvidia.com, maorg@nvidia.com,
        "Dr. David Alan Gilbert" <dgilbert@redhat.com>
Subject: Re: [PATCH V2 mlx5-next 12/14] vfio/mlx5: Implement vfio_pci driver
 for mlx5 devices
Message-ID: <20211116105736.0388a183.alex.williamson@redhat.com>
In-Reply-To: <20211115232921.GV2105516@nvidia.com>
References: <20211102155420.GK2744544@nvidia.com>
        <20211102102236.711dc6b5.alex.williamson@redhat.com>
        <20211102163610.GG2744544@nvidia.com>
        <20211102141547.6f1b0bb3.alex.williamson@redhat.com>
        <20211103120955.GK2744544@nvidia.com>
        <20211103094409.3ea180ab.alex.williamson@redhat.com>
        <20211103161019.GR2744544@nvidia.com>
        <20211103120411.3a470501.alex.williamson@redhat.com>
        <20211105132404.GB2744544@nvidia.com>
        <20211105093145.386d0e89.alex.williamson@redhat.com>
        <20211115232921.GV2105516@nvidia.com>
X-Mailer: Claws Mail 3.18.0 (GTK+ 2.24.33; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, 15 Nov 2021 19:29:21 -0400
Jason Gunthorpe <jgg@nvidia.com> wrote:

> On Fri, Nov 05, 2021 at 09:31:45AM -0600, Alex Williamson wrote:
> > On Fri, 5 Nov 2021 10:24:04 -0300
> > Jason Gunthorpe <jgg@nvidia.com> wrote:
> >   
> > > On Wed, Nov 03, 2021 at 12:04:11PM -0600, Alex Williamson wrote:
> > >   
> > > > We agreed that it's easier to add a feature than a restriction in a
> > > > uAPI, so how do we resolve that some future device may require a new
> > > > state in order to apply the SET_IRQS configuration?    
> > > 
> > > I would say don't support those devices. If there is even a hint that
> > > they could maybe exist then we should fix it now. Once the uapi is set
> > > and documented we should expect device makers to consider it when
> > > building their devices.
> > > 
> > > As for SET_IRQs, I have been looking at making documentation and I
> > > don't like the way the documentation has to be wrriten because of
> > > this.
> > > 
> > > What I see as an understandable, clear, documentation is:
> > > 
> > >  - SAVING set - no device touches allowed beyond migration operations
> > >    and reset via XX  
> > 
> > I'd suggest defining reset via ioctl only.
> >   
> > >    Must be set with !RUNNING  
> > 
> > Not sure what this means.  Pre-copy requires SAVING and RUNNING
> > together, is this only suggesting that to get the final device state we
> > need to do so in a !RUNNING state?  
> 
> Sorry, I did not think about pre-copy here, mlx5 doesn't do it so I'm
> not as familiar
> 
> > >  - RESUMING set - same as SAVING  
> > 
> > I take it then that we're defining a new protocol if we can't do
> > SET_IRQS here.  
> 
> We've been working on some documentation and one of the challenges
> turns out that all the PCI device state owned by other subsystems (eg
> the PCI core, the interrupt code, power management, etc) must be kept
> in sync. No matter what RESUMING cannot just async change device state
> that the kernel assumes it is controlling.
> 
> So, in practice, this necessarily requires forbidding the device from
> touching the MSI table, and other stuff, during RESUMING.
> 
> Further, since we can't just halt all the other kernel subsystems
> during SAVING/RESUMING the device must be able to accept touches in
> those areas, for completely unrelated reasons, (eg a MSI addr/data
> being changed) safely.
> 
> Seems like no need to change SET_IRQs.
> 
> 
> > >  - NDMA set - full device touches
> > >    Device may not issue DMA or interrupts (??)
> > >    Device may not dirty pages  
> > 
> > Is this achievable?  We can't bound the time where incoming DMA is
> > possible, devices don't have infinite buffers.  
> 
> It is a necessary evil for migration. 
> 
> The device cannot know how long it will be suspended for and must
> cope. With networking discarded packets can be resent, but the reality
> is that real deployments need a QOS that the device will not be paused
> for too long otherwise the peers may declare the node dead.
> 
> > > Not entirely, to support P2P going from RESUMING directly to RUNNING
> > > is not possible. There must be an in between state that all devices
> > > reach before they go to RUNNING. It seems P2P cannot be bolted into
> > > the existing qmeu flow with a kernel only change?  
> > 
> > Perhaps, yes.  
> 
> We have also been looking at dirty tracking and we are wondering how
> that should work. (Dirty tracking will be another followup)
> 
> If we look at mlx5, it will have built in dirty tracking, and when
> used with a newer IOMMUs there is also system dirty tracking
> available.
> 
> I think userspace should decide if it wants to use mlx5 built in or
> the system IOMMU to do dirty tracking.

What information does userspace use to inform such a decision?
Ultimately userspace just wants the finest granularity of tracking,
shouldn't that guide our decisions which to provide?

> Presumably the system IOMMU is turned on via
> VFIO_IOMMU_DIRTY_PAGES_FLAG_START, but what controls if the mlx5
> mechanism should be used or not?
> 
> mlx5 also has no way to return the dirty log. If the system IOMMU is
> not used then VFIO_IOMMU_DIRTY_PAGES_FLAG_START should not be done,
> however that is what controls all the logic under the two GET_BITMAP
> APIs. (even if fixed I don't really like the idea of the IOMMU
> extracting this data from the migration driver in the context of
> iommufd)
> 
> Further how does mlx5 even report that it has dirty tracking?
> 
> Was there some plan here we are missing?

I believe the intended progression of dirty tracking is that by default
all mapped ranges are dirty.  If the device supports page pinning, then
we reduce the set of dirty pages to those pages which are pinned.  A
device that doesn't otherwise need page pinning, such as a fully IOMMU
backed device, would use gratuitous page pinning triggered by the
_SAVING state activation on the device.  It sounds like mlx5 could use
this existing support today.

We had also discussed variants to page pinning that might be more
useful as device dirty page support improves.  For example calls to
mark pages dirty once rather than the perpetual dirtying of pinned
pages, calls to pin pages for read vs write, etc.  We didn't dive much
into system IOMMU dirtying, but presumably we'd have a fault handler
triggered if a page is written by the device and go from there.

> In light of all this I'm wondering if device dirty tracking should
> exist as new ioctls on the device FD and reserve the type1 code to
> only work the IOMMU dirty tracking.

Our existing model is working towards the IOMMU, ie. container,
interface aggregating dirty page context.  For example when page
pinning is used, it's only when all devices within the container are
using page pinning that we can report the pinned subset as dirty.
Otherwise userspace needs to poll each device, which I suppose enables
your idea that userspace decides which source to use, but why?  Does
the IOMMU dirty page tracking exclude devices if the user queries the
device separately?  How would it know?  What's the advantage?  It seems
like this creates too many support paths that all need to converge on
the same answer.  Consolidating DMA dirty page tracking to the DMA
mapping interface for all devices within a DMA context makes more sense
to me.  Thanks,

Alex

