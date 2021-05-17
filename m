Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6289E382D82
	for <lists+kvm@lfdr.de>; Mon, 17 May 2021 15:35:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235382AbhEQNgU (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 17 May 2021 09:36:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56794 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229624AbhEQNgT (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 17 May 2021 09:36:19 -0400
Received: from mail-qt1-x831.google.com (mail-qt1-x831.google.com [IPv6:2607:f8b0:4864:20::831])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 50978C061573
        for <kvm@vger.kernel.org>; Mon, 17 May 2021 06:35:02 -0700 (PDT)
Received: by mail-qt1-x831.google.com with SMTP id t7so4813360qtn.3
        for <kvm@vger.kernel.org>; Mon, 17 May 2021 06:35:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ziepe.ca; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=BBi0ImqVgaTdoUmufhblDvqZN98Dv2D+uHBf7NJmKTc=;
        b=fI4KjnpIUUKpAjz0x9Mzd07Rv5ptsOe1rhaTupiA8hmF87geY5yzv1KFjhj2KlQtNN
         9jwlCBJI1kXnwXZpR4fjxnEF/+MvGRBsFtjf5u7IZP8CQ1rdVAtvKWanISFV0QnesOzW
         6/AJFleh+D14Vt/LJZKJCdfr4tmhk6BZRTL2608U0hMq1yXvRS9NxoVsfEoOoSsNuVvx
         vP3nugx7H8NKy7lGHFTc0Hk+IEEMKRAAA2Xp2KtNverN3Z5XYxlydV3894Xr7A8P0Zgu
         bJUehgXTHdO3q1lXucrSXcvp4S9SlNPhgBa47ovmA9FPkZESI3Zj0F5i8X43JgN7CY5m
         UEgA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=BBi0ImqVgaTdoUmufhblDvqZN98Dv2D+uHBf7NJmKTc=;
        b=YFrgJ1Salr6Qxi9bnPOw7V2o9LpS9vpCXRGJ6yzWSwiKTpwqZEESEGabUqF2OAXvrD
         VIZBFjiDquu/QoS4Zwte+r4agDoten9+LPrMxFF0/wFeJ7dvpxsNrs9+3Nkf3KkNFyju
         nod25HtFYZ6mWTmGOhdNeWlYLZtR+j3iYYX3QLixVYGxbSyk5WVxIFn8YzSjZTx0YABW
         EGSkn9sLjQi0g4B4LmCWIyYgAu3iEnVn2E/dPP/LXYBeWOge5TCBJy2x3JdBNHF+6O/h
         xJow2i7zoWGyPmwHP0ujJrIe+4kt+AnZ9YrI0cn+Rodx3oD21RZEFIGIhHlEoVfuiPhW
         kE4A==
X-Gm-Message-State: AOAM530Y0GdGURNtz7uywU3LDo2rcUNel50WVjcM8qqbiAijMiA6FXJ9
        1l3KIMoXc4sOa2wDgS3vsAiNUw==
X-Google-Smtp-Source: ABdhPJxSGyi8nwynzq/W6C6jsXKUHeSS9Dh1cS5HbaxJxw3+c/sfqmRtKrfd7kUKoLlziJIkPGtxdg==
X-Received: by 2002:a05:622a:170b:: with SMTP id h11mr42137196qtk.330.1621258501565;
        Mon, 17 May 2021 06:35:01 -0700 (PDT)
Received: from ziepe.ca (hlfxns017vw-47-55-113-94.dhcp-dynamic.fibreop.ns.bellaliant.net. [47.55.113.94])
        by smtp.gmail.com with ESMTPSA id g5sm11495475qtm.2.2021.05.17.06.35.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 17 May 2021 06:35:00 -0700 (PDT)
Received: from jgg by mlx with local (Exim 4.94)
        (envelope-from <jgg@ziepe.ca>)
        id 1lidOe-009Gdr-0u; Mon, 17 May 2021 10:35:00 -0300
Date:   Mon, 17 May 2021 10:35:00 -0300
From:   Jason Gunthorpe <jgg@ziepe.ca>
To:     Joerg Roedel <joro@8bytes.org>
Cc:     "Tian, Kevin" <kevin.tian@intel.com>,
        Christoph Hellwig <hch@lst.de>,
        Alex Williamson <alex.williamson@redhat.com>,
        David Woodhouse <dwmw2@infradead.org>,
        Lu Baolu <baolu.lu@linux.intel.com>,
        Will Deacon <will@kernel.org>,
        Kirti Wankhede <kwankhede@nvidia.com>,
        "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>,
        "iommu@lists.linux-foundation.org" <iommu@lists.linux-foundation.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>
Subject: Re: [PATCH 3/6] vfio: remove the unused mdev iommu hook
Message-ID: <20210517133500.GP1096940@ziepe.ca>
References: <20210510155454.GA1096940@ziepe.ca>
 <MWHPR11MB1886E02BF7DE371E9665AA328C519@MWHPR11MB1886.namprd11.prod.outlook.com>
 <20210513120058.GG1096940@ziepe.ca>
 <MWHPR11MB1886B92507ED9015831A0CEA8C509@MWHPR11MB1886.namprd11.prod.outlook.com>
 <20210514121925.GI1096940@ziepe.ca>
 <MWHPR11MB18866205125E566FE05867A78C509@MWHPR11MB1886.namprd11.prod.outlook.com>
 <20210514133143.GK1096940@ziepe.ca>
 <YKJf7mphTHZoi7Qr@8bytes.org>
 <20210517123010.GO1096940@ziepe.ca>
 <YKJnPGonR+d8rbu/@8bytes.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YKJnPGonR+d8rbu/@8bytes.org>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, May 17, 2021 at 02:53:16PM +0200, Joerg Roedel wrote:
> On Mon, May 17, 2021 at 09:30:10AM -0300, Jason Gunthorpe wrote:
> > On Mon, May 17, 2021 at 02:22:06PM +0200, Joerg Roedel wrote:
> > > Yes, I know, We have the AUX-domain specific functions now, but I
> > > suggested a while back to turn the mdev code into its own bus
> > > implementation and let the IOMMU driver deal with whether it has an mdev
> > > or a pdev. When that is done the aux-specific functions can go away.
> > 
> > Yuk, no.
> > 
> > PASID is not connected to the driver model. It is inherently wrong to
> > suggest this.
> 
> There will be no drivers for that, but an mdev is a container for
> resources of a physical device which can be assigned to a virtual
> machine or a user-space process. In this way it fits very well into the
> existing abstractions.

There world is a lot bigger than just mdev and vfio.

> > PASID is a property of a PCI device and any PCI device driver should
> > be able to spawn PASIDs without silly restrictions.
> 
> Some points here:
> 
> 	1) The concept of PASIDs is not limited to PCI devices.

Do I have to type PASID/stream id/etc/etc in every place? We all know
this is gerenal, it is why Intel is picking IOASID for the uAPI name.

> 	2) An mdev is not a restriction. It is an abstraction with which
> 	   other parts of the kernel can work.

mdev is really gross, new things should avoid using it. It is also
100% VFIO specific and should never be used outside VFIO.

My recent work significantly eliminates the need for mdev at all, the
remaining gaps have to do with the way mdev hackily overrides the
iommu mechanisms in VFIO.

Tying any decision to the assumption that mdev will, or even should,
continue is not aligned with the direction things are going.

> > Fixing the IOMMU API is clearly needed here to get a clean PASID
> > implementation in the kernel.
> 
> You still have to convince me that this is needed and a good idea. By
> now I am not even remotely convinced and putting words like 'fixing',
> 'clearly' and 'silly' in a sentence is by far not enough for this to
> happen.

Well, I'm sorry, but there is a huge other thread talking about the
IOASID design in great detail and why this is all needed. Jumping into
this thread without context and basically rejecting all the
conclusions that were reached over the last several weeks is really
not helpful - especially since your objection is not technical.

I think you should wait for Intel to put together the /dev/ioasid uAPI
proposal and the example use cases it should address then you can give
feedback there, with proper context.

In this case the mdev specific auxdomain for PASID use is replaced by
sane /dev/ioasid objects - and how that gets implemented through the
iommu layer would still be a big TBD. Though I can't forsee any
quality implementation of /dev/ioasid being driven by a one io page
table per struct device scheme.

Hopefully Intel will make the reasons why, and the use cases
supporting the desgin, clear in their RFC.

> To be clear, I agree that the aux-domain specifics should be removed
> from the IOMMU-API, but the mdev-abstraction itself still makes sense.

Expect mdev is basically legacy too. 

Jason
