Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8FCA5382C9A
	for <lists+kvm@lfdr.de>; Mon, 17 May 2021 14:53:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233280AbhEQMyr (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 17 May 2021 08:54:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47324 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230527AbhEQMyh (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 17 May 2021 08:54:37 -0400
Received: from theia.8bytes.org (8bytes.org [IPv6:2a01:238:4383:600:38bc:a715:4b6d:a889])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 33A40C061573
        for <kvm@vger.kernel.org>; Mon, 17 May 2021 05:53:21 -0700 (PDT)
Received: by theia.8bytes.org (Postfix, from userid 1000)
        id 771D72E7; Mon, 17 May 2021 14:53:18 +0200 (CEST)
Date:   Mon, 17 May 2021 14:53:16 +0200
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
Message-ID: <YKJnPGonR+d8rbu/@8bytes.org>
References: <20210510065405.2334771-4-hch@lst.de>
 <20210510155454.GA1096940@ziepe.ca>
 <MWHPR11MB1886E02BF7DE371E9665AA328C519@MWHPR11MB1886.namprd11.prod.outlook.com>
 <20210513120058.GG1096940@ziepe.ca>
 <MWHPR11MB1886B92507ED9015831A0CEA8C509@MWHPR11MB1886.namprd11.prod.outlook.com>
 <20210514121925.GI1096940@ziepe.ca>
 <MWHPR11MB18866205125E566FE05867A78C509@MWHPR11MB1886.namprd11.prod.outlook.com>
 <20210514133143.GK1096940@ziepe.ca>
 <YKJf7mphTHZoi7Qr@8bytes.org>
 <20210517123010.GO1096940@ziepe.ca>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210517123010.GO1096940@ziepe.ca>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, May 17, 2021 at 09:30:10AM -0300, Jason Gunthorpe wrote:
> On Mon, May 17, 2021 at 02:22:06PM +0200, Joerg Roedel wrote:
> > Yes, I know, We have the AUX-domain specific functions now, but I
> > suggested a while back to turn the mdev code into its own bus
> > implementation and let the IOMMU driver deal with whether it has an mdev
> > or a pdev. When that is done the aux-specific functions can go away.
> 
> Yuk, no.
> 
> PASID is not connected to the driver model. It is inherently wrong to
> suggest this.

There will be no drivers for that, but an mdev is a container for
resources of a physical device which can be assigned to a virtual
machine or a user-space process. In this way it fits very well into the
existing abstractions.

> PASID is a property of a PCI device and any PCI device driver should
> be able to spawn PASIDs without silly restrictions.

Some points here:

	1) The concept of PASIDs is not limited to PCI devices.
	
	2) An mdev is not a restriction. It is an abstraction with which
	   other parts of the kernel can work.

> Fixing the IOMMU API is clearly needed here to get a clean PASID
> implementation in the kernel.

You still have to convince me that this is needed and a good idea. By
now I am not even remotely convinced and putting words like 'fixing',
'clearly' and 'silly' in a sentence is by far not enough for this to
happen.

> We aren't talking about mm_struct.

Passing an mm_struct to a device is another use-case for PASIDs, you
should keep that in mind. The mdev abstraction was made for a different
use-case.

To be clear, I agree that the aux-domain specifics should be removed
from the IOMMU-API, but the mdev-abstraction itself still makes sense.

> As above a domain isn't an IOASID, it only does a few things an IOASID
> can do.

For example?


Regards,

	Joerg
