Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 901C938B1CC
	for <lists+kvm@lfdr.de>; Thu, 20 May 2021 16:34:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236920AbhETOfo (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 20 May 2021 10:35:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56854 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232781AbhETOfn (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 20 May 2021 10:35:43 -0400
Received: from mail-qt1-x833.google.com (mail-qt1-x833.google.com [IPv6:2607:f8b0:4864:20::833])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 777FEC061574
        for <kvm@vger.kernel.org>; Thu, 20 May 2021 07:34:22 -0700 (PDT)
Received: by mail-qt1-x833.google.com with SMTP id h21so12906407qtu.5
        for <kvm@vger.kernel.org>; Thu, 20 May 2021 07:34:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ziepe.ca; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=OpoqGZ3A/8qRiAsl8YBeGFq3Y08k8ObE2zfSbQGbkDw=;
        b=gUM1zdl9Abha3cPJv5gRQZgKr1Ffmsd5MwHf2fIfUdraIoaE0cGoqbofW/xNNGw4Ad
         tIdaNqYlPU8oicIi5AtHsN4SylYLZCRQvidxSN2we34qHMt1NYx6OOPm5zmJ8PqWWlw4
         wiZdB1fwuwlsPBIRY3MTgmnnYj/Jbk476crStUxbBoOiMD7efzWEIV8xc3vuzoVPUfO1
         QY1YLNM5nKeEhWEMzwgpwyiVXMrnYgKqI1xockOg/9/BxckQFzBYOxyJ5ccmlzsO3dKo
         lYO87FEbmQIqC2CgYVbww7aOZd9Q0KPVIgPN1rLHv1JVoE8htlZTnFN+vjaIV8AvV7gb
         Ib9A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=OpoqGZ3A/8qRiAsl8YBeGFq3Y08k8ObE2zfSbQGbkDw=;
        b=re8mD/t9iLGLV2oe4fEg6Bu17dCzfGC4JBWYPWH5Xv6meX4HgPfPgm3QShGtxp3M/R
         ZQ1LUaRPa6Xbrish7sBD1vd51cS6AfiSWHGgodV62W0HS/zzzKzUWYF0Df+2Y+Xev3OZ
         VEJFgvs+t9F3g1iBgqf54SiDMX8hvNF2DTKwb1t+R15i8ll12NigrGcrSKAsGsQ9e1d3
         N9rli6iYVJrzYOuxPdd9pk8hw5ft6oC8TrwLTRPw5Cf60VHl0ukUVYVh5g1zyq7ld5sJ
         +uRAEZaxoSVKMqM4n1D1eDIYCsaqRxfB1DAeaydu7HDjzi9ZZ1nOXx3Tc2bCtmDItLvg
         PO/w==
X-Gm-Message-State: AOAM530l0InUy0HMNPEIPESpBtZOMg6jqXkgEgSNzyEzb2dfj3pIyQog
        CXGABNJdHMJkVmDWgKZGlG1/xg==
X-Google-Smtp-Source: ABdhPJwHOT/1k3DuCHDAx3Xvnqq9GL3kCgR+0mUPss3IDQnLOCtNIHl2f9EI7XlwZ2X6CoeaPh0j3g==
X-Received: by 2002:ac8:5419:: with SMTP id b25mr5300042qtq.328.1621521261577;
        Thu, 20 May 2021 07:34:21 -0700 (PDT)
Received: from ziepe.ca (hlfxns017vw-47-55-113-94.dhcp-dynamic.fibreop.ns.bellaliant.net. [47.55.113.94])
        by smtp.gmail.com with ESMTPSA id e19sm2035011qtr.45.2021.05.20.07.34.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 20 May 2021 07:34:21 -0700 (PDT)
Received: from jgg by mlx with local (Exim 4.94)
        (envelope-from <jgg@ziepe.ca>)
        id 1ljjki-00BOJ9-6V; Thu, 20 May 2021 11:34:20 -0300
Date:   Thu, 20 May 2021 11:34:20 -0300
From:   Jason Gunthorpe <jgg@ziepe.ca>
To:     Robin Murphy <robin.murphy@arm.com>
Cc:     "Tian, Kevin" <kevin.tian@intel.com>,
        Joerg Roedel <joro@8bytes.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        Will Deacon <will@kernel.org>,
        Kirti Wankhede <kwankhede@nvidia.com>,
        "iommu@lists.linux-foundation.org" <iommu@lists.linux-foundation.org>,
        Alex Williamson <alex.williamson@redhat.com>,
        David Woodhouse <dwmw2@infradead.org>,
        Christoph Hellwig <hch@lst.de>,
        "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH 3/6] vfio: remove the unused mdev iommu hook
Message-ID: <20210520143420.GW1096940@ziepe.ca>
References: <YKJf7mphTHZoi7Qr@8bytes.org>
 <20210517123010.GO1096940@ziepe.ca>
 <YKJnPGonR+d8rbu/@8bytes.org>
 <20210517133500.GP1096940@ziepe.ca>
 <YKKNLrdQ4QjhLrKX@8bytes.org>
 <131327e3-5066-7a88-5b3c-07013585eb01@arm.com>
 <20210519180635.GT1096940@ziepe.ca>
 <MWHPR11MB1886C64EAEB752DE9E1633358C2B9@MWHPR11MB1886.namprd11.prod.outlook.com>
 <20210519232459.GV1096940@ziepe.ca>
 <1d154445-f762-1147-0b8c-6e244e7c66dc@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1d154445-f762-1147-0b8c-6e244e7c66dc@arm.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, May 20, 2021 at 03:13:55PM +0100, Robin Murphy wrote:

> By "mdev-like" I mean it's very similar in shape to the general SIOV-style
> mediated device concept - i.e. a physical device with an awareness of
> operating on multiple contexts at once, using a Substream ID/PASID for each
> one - but instead of exposing control of the contexts to anyone else, they
> remain hidden behind the kernel driver which already has its own abstracted
> uAPI, so overall it ends up as more just internal housekeeping than any
> actual mediation. We were looking at the mdev code for inspiration, but
> directly using it was never the plan.

Well:
 - Who maps memory into the IOASID (ie the specific sub stream id)?
 - What memory must be mapped?
 - Who triggers DMA to this memory?
 
> The driver simply needs to keep track of the domains and PASIDs -
> when a process submits some work, it can look up the relevant
> domain, iommu_map() the user pages to the right addresses, dma_map()
> them for coherency, then poke in the PASID as part of scheduling the
> work on the physical device.

If you are doing stuff like this then the /dev/ioasid is what you
actually want. The userprocess can create its own IOASID, program the
io page tables for that IOASID to point to pages as it wants and then
just hand over a fully instantiated io page table to the device
driver.

What you are describing is the literal use case of /dev/ioasid - a
clean seperation of managing the IOMMU related parts through
/dev/ioasid and the device driver itself is only concerned with
generating device DMA that has the proper PASID/substream tag.

The entire point is to not duplicate all the iommu code you are
describing having written into every driver that just wants an IOASID.

In particular, you are talking about having a substream capable device
and driver but your driver's uAPI is so limited it can't address the
full range of substream configurations:

 - A substream pointing at a SVA
 - A substream pointing a IO page table nested under another
 - A substream pointing at an IOMMU page table shared by many users

And more. Which is bad.

> > We already talked about this on the "how to use PASID from the kernel"
> > thread.
> 
> Do you have a pointer to the right thread so I can catch up? It's not the
> easiest thing to search for on lore amongst all the other PASID-related
> business :(

Somewhere in here:

http://lore.kernel.org/r/20210517143758.GP1002214@nvidia.com

> FWIW my non-SVA view is that a PASID is merely an index into a set of
> iommu_domains, and in that context it doesn't even really matter *who*
> allocates them, only that the device driver and IOMMU driver are in sync :)

Right, this is where /dev/ioasid is going.

However it gets worked out at the kAPI level in the iommu layer the
things you asked for are intended to be solved, and lots more.

Jason
