Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 43249380950
	for <lists+kvm@lfdr.de>; Fri, 14 May 2021 14:19:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232354AbhENMUl (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 14 May 2021 08:20:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51512 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233148AbhENMUi (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 14 May 2021 08:20:38 -0400
Received: from mail-qk1-x72f.google.com (mail-qk1-x72f.google.com [IPv6:2607:f8b0:4864:20::72f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2C6CBC061574
        for <kvm@vger.kernel.org>; Fri, 14 May 2021 05:19:27 -0700 (PDT)
Received: by mail-qk1-x72f.google.com with SMTP id 76so28424539qkn.13
        for <kvm@vger.kernel.org>; Fri, 14 May 2021 05:19:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ziepe.ca; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=2orjcu+bFDK+ZSi8hWNlQqJx3e5HbNzAGaAd0cCLl7g=;
        b=bQUUjd0Y4a6jO+AmWs9nTp7PcXEayvZpEcpTja9XAf9f0gsuBo2iiJ+6gx+jk0U5kd
         weeVe+O5yPXANFk4bakBZ9VR+fQKl4ro6ucLBeC6rI1RoJ5zH5sj6bWeq13jzOvHJ2zW
         J/Nf0mMevGfLVFlcO+zybm8dCCfdx7uIYkH032E20HlRF+iVy4bB1b9NujfatCC/tKHr
         d7Cv6bttrnbKHyUJ9ksPbW1NNCVlgMUAQefzPXc+ZpDeAfvx9+q5INdn+Bm5+o+ngwMP
         GUyS7asnsIhk3K1BqpI1SFN+oq2oKy/e6KVLu9NSbj3c7oNMm8ghfeq84QzlZv2AQNbS
         x0iQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=2orjcu+bFDK+ZSi8hWNlQqJx3e5HbNzAGaAd0cCLl7g=;
        b=giQgl8MNIGg+mqmci7QA6IzN26Bvr019tAcgzz+20Yn61rAuVFBn8DgDdMiBEdoTXA
         LsVAvtDwXVxWserGy3F+r/UpK7Xau//HFb7ZwSl89BjqZFo8vZbAS2Bniq000sl5PBnB
         uQICh2L4SsZKM+jlnDCMhxGeTr8JxA5dw17FPr/owqI94J3lVhXvW52gp5VCgfj9NxMb
         vRrBfrZmSLe2OeHuN+zyiLiBAMtPCMRtgvieyxbBncB3GKNgwqLmbKLQI7qIx8NqXzGA
         eDpUZ2/9FpBQgcIaukA/FP+0uzV1DdhDlKkVxrOQHnbfYhjLDuqmWbTj1e5cFcQML3Um
         PWOg==
X-Gm-Message-State: AOAM532bfmsG/CKNKVslynhD1HbtpLt2D3vqNcgBQ1QS0AM9uBFeEMar
        cWpzzKScDfogYhzVtmeIPmGhqU2FoYjhjrY4
X-Google-Smtp-Source: ABdhPJxGyNQCvNGQGAHGa/24dlS2hhEnAClK5ht9t3tJrdkRDG96uMryqbLbGHeLVVgSRnKW4/+s6A==
X-Received: by 2002:a37:7246:: with SMTP id n67mr41596564qkc.71.1620994766455;
        Fri, 14 May 2021 05:19:26 -0700 (PDT)
Received: from ziepe.ca (hlfxns017vw-47-55-113-94.dhcp-dynamic.fibreop.ns.bellaliant.net. [47.55.113.94])
        by smtp.gmail.com with ESMTPSA id i9sm4807353qtg.18.2021.05.14.05.19.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 14 May 2021 05:19:25 -0700 (PDT)
Received: from jgg by mlx with local (Exim 4.94)
        (envelope-from <jgg@ziepe.ca>)
        id 1lhWmr-007OI8-0o; Fri, 14 May 2021 09:19:25 -0300
Date:   Fri, 14 May 2021 09:19:25 -0300
From:   Jason Gunthorpe <jgg@ziepe.ca>
To:     "Tian, Kevin" <kevin.tian@intel.com>
Cc:     Christoph Hellwig <hch@lst.de>, Joerg Roedel <joro@8bytes.org>,
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
Message-ID: <20210514121925.GI1096940@ziepe.ca>
References: <20210510065405.2334771-1-hch@lst.de>
 <20210510065405.2334771-4-hch@lst.de>
 <20210510155454.GA1096940@ziepe.ca>
 <MWHPR11MB1886E02BF7DE371E9665AA328C519@MWHPR11MB1886.namprd11.prod.outlook.com>
 <20210513120058.GG1096940@ziepe.ca>
 <MWHPR11MB1886B92507ED9015831A0CEA8C509@MWHPR11MB1886.namprd11.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <MWHPR11MB1886B92507ED9015831A0CEA8C509@MWHPR11MB1886.namprd11.prod.outlook.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, May 14, 2021 at 06:54:16AM +0000, Tian, Kevin wrote:
> > From: Tian, Kevin
> > Sent: Friday, May 14, 2021 2:28 PM
> > 
> > > From: Jason Gunthorpe <jgg@ziepe.ca>
> > > Sent: Thursday, May 13, 2021 8:01 PM
> > >
> > > On Thu, May 13, 2021 at 03:28:52AM +0000, Tian, Kevin wrote:
> > >
> > > > Are you specially concerned about this iommu_device hack which
> > > > directly connects mdev_device to iommu layer or the entire removed
> > > > logic including the aux domain concept? For the former we are now
> > > > following up the referred thread to find a clean way. But for the latter
> > > > we feel it's still necessary regardless of how iommu interface is
> > redesigned
> > > > to support device connection from the upper level driver. The reason is
> > > > that with mdev or subdevice one physical device could be attached to
> > > > multiple domains now. there could be a primary domain with DOMAIN_
> > > > DMA type for DMA_API use by parent driver itself, and multiple auxiliary
> > > > domains with DOMAIN_UNMANAGED types for subdevices assigned to
> > > > different VMs.
> > >
> > > Why do we need more domains than just the physical domain for the
> > > parent? How does auxdomain appear in /dev/ioasid?
> > >
> > 
> > Say the parent device has three WQs. WQ1 is used by parent driver itself,
> > while WQ2/WQ3 are assigned to VM1/VM2 respectively.
> > 
> > WQ1 is attached to domain1 for an IOVA space to support DMA API
> > operations in parent driver.

More specifically WQ1 uses a PASID that is represented by an IOASID to
userspace.

> > WQ2 is attached to domain2 for the GPA space of VM1. Domain2 is
> > created when WQ2 is assigned to VM1 as a mdev.
> > 
> > WQ3 is attached to domain3 for the GPA space of VM2. Domain3 is
> > created when WQ3 is assigned to VM2 as a mdev.
> > 
> > In this case domain1 is the primary while the other two are auxiliary
> > to the parent.
> > 
> > auxdomain represents as a normal domain in /dev/ioasid, with only
> > care required when doing attachment.
> > 
> > e.g. VM1 is assigned with both a pdev and mdev. Qemu creates
> > gpa_ioasid which is associated with a single domain for VM1's
> > GPA space and this domain is shared by both pdev and mdev.
> 
> Here pdev/mdev are just conceptual description. Following your
> earlier suggestion /dev/ioasid will not refer to explicit mdev_device.
> Instead, each vfio device attached to an ioasid is represented by either
> "struct device" for pdev or "struct device + pasid" for mdev. The
> presence of pasid decides which iommu_attach api should be used.

But you still haven't explained what an aux domain is to /dev/ioasid.

Why do I need more public kernel objects to represent a PASID IOASID?

Are you creating a domain for every IOASID? Why?

Jason
