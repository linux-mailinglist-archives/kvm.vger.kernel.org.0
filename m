Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4308C3CA237
	for <lists+kvm@lfdr.de>; Thu, 15 Jul 2021 18:24:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230314AbhGOQ0z (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 15 Jul 2021 12:26:55 -0400
Received: from mga02.intel.com ([134.134.136.20]:6821 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229506AbhGOQ0y (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 15 Jul 2021 12:26:54 -0400
X-IronPort-AV: E=McAfee;i="6200,9189,10046"; a="197765346"
X-IronPort-AV: E=Sophos;i="5.84,242,1620716400"; 
   d="scan'208";a="197765346"
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Jul 2021 09:22:09 -0700
X-IronPort-AV: E=Sophos;i="5.84,242,1620716400"; 
   d="scan'208";a="413692583"
Received: from otc-nc-03.jf.intel.com (HELO otc-nc-03) ([10.54.39.36])
  by orsmga003-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Jul 2021 09:22:08 -0700
Date:   Thu, 15 Jul 2021 09:21:41 -0700
From:   "Raj, Ashok" <ashok.raj@intel.com>
To:     Jason Gunthorpe <jgg@nvidia.com>
Cc:     "Tian, Kevin" <kevin.tian@intel.com>,
        Shenming Lu <lushenming@huawei.com>,
        "Alex Williamson (alex.williamson@redhat.com)" 
        <alex.williamson@redhat.com>,
        Jean-Philippe Brucker <jean-philippe@linaro.org>,
        David Gibson <david@gibson.dropbear.id.au>,
        Jason Wang <jasowang@redhat.com>,
        "parav@mellanox.com" <parav@mellanox.com>,
        "Enrico Weigelt, metux IT consult" <lkml@metux.net>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Joerg Roedel <joro@8bytes.org>,
        Eric Auger <eric.auger@redhat.com>,
        Jonathan Corbet <corbet@lwn.net>,
        "Liu, Yi L" <yi.l.liu@intel.com>, "Wu, Hao" <hao.wu@intel.com>,
        "Jiang, Dave" <dave.jiang@intel.com>,
        Jacob Pan <jacob.jun.pan@linux.intel.com>,
        Kirti Wankhede <kwankhede@nvidia.com>,
        Robin Murphy <robin.murphy@arm.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "iommu@lists.linux-foundation.org" <iommu@lists.linux-foundation.org>,
        David Woodhouse <dwmw2@infradead.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Lu Baolu <baolu.lu@linux.intel.com>,
        "wanghaibin.wang@huawei.com" <wanghaibin.wang@huawei.com>
Subject: Re: [RFC v2] /dev/iommu uAPI proposal
Message-ID: <20210715162141.GA593686@otc-nc-03>
References: <BN9PR11MB5433B1E4AE5B0480369F97178C189@BN9PR11MB5433.namprd11.prod.outlook.com>
 <7ea349f8-8c53-e240-fe80-382954ba7f28@huawei.com>
 <BN9PR11MB5433A9B792441CAF21A183A38C129@BN9PR11MB5433.namprd11.prod.outlook.com>
 <a8edb2c1-9c9c-6204-072c-4f1604b7dace@huawei.com>
 <BN9PR11MB54336D6A8CAE31F951770A428C129@BN9PR11MB5433.namprd11.prod.outlook.com>
 <20210715124813.GC543781@nvidia.com>
 <20210715135757.GC590891@otc-nc-03>
 <20210715152325.GF543781@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210715152325.GF543781@nvidia.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Jul 15, 2021 at 12:23:25PM -0300, Jason Gunthorpe wrote:
> On Thu, Jul 15, 2021 at 06:57:57AM -0700, Raj, Ashok wrote:
> > On Thu, Jul 15, 2021 at 09:48:13AM -0300, Jason Gunthorpe wrote:
> > > On Thu, Jul 15, 2021 at 06:49:54AM +0000, Tian, Kevin wrote:
> > > 
> > > > No. You are right on this case. I don't think there is a way to 
> > > > differentiate one mdev from the other if they come from the
> > > > same parent and attached by the same guest process. In this
> > > > case the fault could be reported on either mdev (e.g. the first
> > > > matching one) to get it fixed in the guest.
> > > 
> > > If the IOMMU can't distinguish the two mdevs they are not isolated
> > > and would have to share a group. Since group sharing is not supported
> > > today this seems like a non-issue
> > 
> > Does this mean we have to prevent 2 mdev's from same pdev being assigned to
> > the same guest? 
> 
> No, it means that the IOMMU layer has to be able to distinguish them.

Ok, the guest has no control over it, as it see 2 separate pci devices and
thinks they are all different.

Only time when it can fail is during the bind operation. From guest
perspective a bind in vIOMMU just turns into a write to local table and a
invalidate will cause the host to update the real copy from the shadow.

There is no way to fail the bind? and Allocation of the PASID is also a
separate operation and has no clue how its going to be used in the guest.

> 
> This either means they are "SW mdevs" which does not involve the IOMMU
> layer and puts both the responsibility for isolation and idenfication
> on the mdev driver.

When you mean SW mdev, is it the GPU like case where mdev is purely a SW
construct? or SIOV type where RID+PASID case?

> 
> Or they are some "PASID mdev" which does allow the IOMMU to isolate
> them.
> 
> What can't happen is to comingle /dev/iommu control over the pdev
> between two mdevs.
> 
> ie we can't talk about faults for IOMMU on SW mdevs - faults do not
> come from the IOMMU layer, they have to come from inside the mdev it
> self, somehow.

Recoverable faults for guest needs to be sent to guest? A page-request from
mdev1 and from mdev2 will both look alike when the process is sharing it.

Do we have any isolation requirements here? its the same process. So if the
page-request it sent to guest and even if you report it for mdev1, after
the PRQ is resolved by guest, the request from mdev2 from the same guest
should simply work?


