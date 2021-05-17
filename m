Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1A8BF382BFA
	for <lists+kvm@lfdr.de>; Mon, 17 May 2021 14:22:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234618AbhEQMX2 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 17 May 2021 08:23:28 -0400
Received: from 8bytes.org ([81.169.241.247]:39434 "EHLO theia.8bytes.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230230AbhEQMXY (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 17 May 2021 08:23:24 -0400
Received: by theia.8bytes.org (Postfix, from userid 1000)
        id C5EF52E7; Mon, 17 May 2021 14:22:07 +0200 (CEST)
Date:   Mon, 17 May 2021 14:22:06 +0200
From:   Joerg Roedel <joro@8bytes.org>
To:     Jason Gunthorpe <jgg@ziepe.ca>
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
Message-ID: <YKJf7mphTHZoi7Qr@8bytes.org>
References: <20210510065405.2334771-1-hch@lst.de>
 <20210510065405.2334771-4-hch@lst.de>
 <20210510155454.GA1096940@ziepe.ca>
 <MWHPR11MB1886E02BF7DE371E9665AA328C519@MWHPR11MB1886.namprd11.prod.outlook.com>
 <20210513120058.GG1096940@ziepe.ca>
 <MWHPR11MB1886B92507ED9015831A0CEA8C509@MWHPR11MB1886.namprd11.prod.outlook.com>
 <20210514121925.GI1096940@ziepe.ca>
 <MWHPR11MB18866205125E566FE05867A78C509@MWHPR11MB1886.namprd11.prod.outlook.com>
 <20210514133143.GK1096940@ziepe.ca>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210514133143.GK1096940@ziepe.ca>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, May 14, 2021 at 10:31:43AM -0300, Jason Gunthorpe wrote:
> There is no place for "domain as a carrier of PASID"
> there. mdev_device should NOT participate in the IOMMU layer because
> it is NOT a HW device. Trying to warp mdev_device into an IOMMU
> presence is already the source of a lot of this hacky code.

Having the mdev abstraction is way better than making the IOMMU code
IOASID aware. The later requires either new parameters to existing
functions or new functions. With the mdev abstraction no new functions
are needed in the core API.

Yes, I know, We have the AUX-domain specific functions now, but I
suggested a while back to turn the mdev code into its own bus
implementation and let the IOMMU driver deal with whether it has an mdev
or a pdev. When that is done the aux-specific functions can go away.

We are not there yet, but I think this is a cleaner abstraction than
making the IOMMU-API ioasid-aware. Also because it separates the details
of device-partitioning nicely from the IOMMU core code.

> To juggle multiple IOASID per HW device the IOMMU API obviously has to
> be made IOASID aware. It can't just blindly assume that a struct
> device implies the single IOASID to use and hope for the best.

The one-device<->one address-space idea is blindly assumed. Simply
because the vast amount of devices out there work that way. When ioasids
come into the game this changes of course, but we can work that out
based on how the ioasids are used.

For device partitioning the mdev abstraction work well if it is
correctly implemented. The other use-case is device-access to user-space
memory, and that is a completely different story.

> IOASID represents the IOVA address space.

No, when it comes to the IOMMU-API, a domain represents an address
space.

> Two concepts that represent the same thing is not great :)

Agreed, so an IOASID should be an IOMMU-domain, if its not used for
passing an mm_struct to a device.

Regards,

	Joerg
