Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6D737382C20
	for <lists+kvm@lfdr.de>; Mon, 17 May 2021 14:30:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235019AbhEQMbb (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 17 May 2021 08:31:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42100 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231400AbhEQMb3 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 17 May 2021 08:31:29 -0400
Received: from mail-qk1-x72e.google.com (mail-qk1-x72e.google.com [IPv6:2607:f8b0:4864:20::72e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DF171C061573
        for <kvm@vger.kernel.org>; Mon, 17 May 2021 05:30:12 -0700 (PDT)
Received: by mail-qk1-x72e.google.com with SMTP id a22so5434503qkl.10
        for <kvm@vger.kernel.org>; Mon, 17 May 2021 05:30:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ziepe.ca; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=V+Cch8xRW1WYGs40hx7Gew5bxUxEUdJtQZFXQJNl02s=;
        b=kEzgnQZu3uqvJz2RaM/nnMkpzVJMQjIqjYX5Ljayco5bkCRl+S7HGeOjFbHPgM+IlC
         lWJ/bHi7bPCSq+4QCFcUHYL6Dr4qY84zB7C+bCOUOW3BiKD/+yqO8kcVYc5cibj4cpOM
         sNm4drLaUaAUS12Gs3VDK1RKKiP2+GJgtuYm3PgXPkMmFG7oT/ROW1QcCn2Iq/GCyGQZ
         mmKYB4X9+Gygg83a8q/pcOfDTD73Zrk+yfHFTQvm/ulqoBH5ntaT1Bhvau11rLut46/x
         txhKkcOKSItA8osf8jKtip5kiWN/wowysbsuMI7z+TWK38kRWnVNS+iEjHVP55NZ9sBt
         7j0Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=V+Cch8xRW1WYGs40hx7Gew5bxUxEUdJtQZFXQJNl02s=;
        b=QL6yOI0uOIVdwwWD9vpvYnPtEznAm0KtqslBFCBcl2vuyGVnLcYRqyxyCN17QLy8oY
         xjK+UlcIGws6pHSW8D/aGt7xr/uZDd8ZSeYEp6GXoq3G4NjF5wemPFlFHbMqy6Y/pYZD
         t6PVAL/X+LoF5bR7l/IFW7IEn39siVr78N9LuzlpipOvhJn7YNeBNoDSChnFCw+iRv1E
         1dqGiRfBZQ7/PazKsNVfpL7cr0BMWUcEUojiFuDY8ONO801B162FZ0OqEhoN4DiRU2wt
         CrNj+Udd9EgMCgnYPzr6y5Q3sH4ffvSes5p69MD+FfuLO1U6Ez2NLCfijfPygP5uuvzh
         OV5Q==
X-Gm-Message-State: AOAM530RixYeX0HUbqN6Y3Z0uIVO6ym9caAjc7UOtMsjfLz25KdDosJh
        bww0577fM0siiwuZwcVBE3pB7Q==
X-Google-Smtp-Source: ABdhPJxQlOtNjYIpu2zCl+Q2+BPq9eQ5stqEINHnYWdlSJ7QCi8aM7fqT8qcIavvrMRN9eX7fr+1uA==
X-Received: by 2002:a37:98c4:: with SMTP id a187mr56051528qke.277.1621254612180;
        Mon, 17 May 2021 05:30:12 -0700 (PDT)
Received: from ziepe.ca (hlfxns017vw-47-55-113-94.dhcp-dynamic.fibreop.ns.bellaliant.net. [47.55.113.94])
        by smtp.gmail.com with ESMTPSA id q7sm10302543qki.17.2021.05.17.05.30.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 17 May 2021 05:30:11 -0700 (PDT)
Received: from jgg by mlx with local (Exim 4.94)
        (envelope-from <jgg@ziepe.ca>)
        id 1licNu-009Fa7-J0; Mon, 17 May 2021 09:30:10 -0300
Date:   Mon, 17 May 2021 09:30:10 -0300
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
Message-ID: <20210517123010.GO1096940@ziepe.ca>
References: <20210510065405.2334771-1-hch@lst.de>
 <20210510065405.2334771-4-hch@lst.de>
 <20210510155454.GA1096940@ziepe.ca>
 <MWHPR11MB1886E02BF7DE371E9665AA328C519@MWHPR11MB1886.namprd11.prod.outlook.com>
 <20210513120058.GG1096940@ziepe.ca>
 <MWHPR11MB1886B92507ED9015831A0CEA8C509@MWHPR11MB1886.namprd11.prod.outlook.com>
 <20210514121925.GI1096940@ziepe.ca>
 <MWHPR11MB18866205125E566FE05867A78C509@MWHPR11MB1886.namprd11.prod.outlook.com>
 <20210514133143.GK1096940@ziepe.ca>
 <YKJf7mphTHZoi7Qr@8bytes.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YKJf7mphTHZoi7Qr@8bytes.org>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, May 17, 2021 at 02:22:06PM +0200, Joerg Roedel wrote:
> On Fri, May 14, 2021 at 10:31:43AM -0300, Jason Gunthorpe wrote:
> > There is no place for "domain as a carrier of PASID"
> > there. mdev_device should NOT participate in the IOMMU layer because
> > it is NOT a HW device. Trying to warp mdev_device into an IOMMU
> > presence is already the source of a lot of this hacky code.
> 
> Having the mdev abstraction is way better than making the IOMMU code
> IOASID aware. The later requires either new parameters to existing
> functions or new functions. With the mdev abstraction no new functions
> are needed in the core API.

All that does it lock PASID to mdev which is not at all where this
needs to go.

> Yes, I know, We have the AUX-domain specific functions now, but I
> suggested a while back to turn the mdev code into its own bus
> implementation and let the IOMMU driver deal with whether it has an mdev
> or a pdev. When that is done the aux-specific functions can go away.

Yuk, no.

PASID is not connected to the driver model. It is inherently wrong to
suggest this. 

PASID is a property of a PCI device and any PCI device driver should
be able to spawn PASIDs without silly restrictions.

Fixing the IOMMU API is clearly needed here to get a clean PASID
implementation in the kernel.

> > IOASID represents the IOVA address space.
> 
> No, when it comes to the IOMMU-API, a domain represents an address
> space.

Intel is building a new uAPI and here IOASID is the word they picked
to represent the IOVA address space. How it is mapped to the kernel is
TBD, I guess, but domain implies both more and less than a IOASID so it
isn't a 1:1 correspondence.

> > Two concepts that represent the same thing is not great :)
> 
> Agreed, so an IOASID should be an IOMMU-domain, if its not used for
> passing an mm_struct to a device.

We aren't talking about mm_struct.

As above a domain isn't an IOASID, it only does a few things an IOASID
can do.

Jason
