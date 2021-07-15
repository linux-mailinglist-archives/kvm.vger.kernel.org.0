Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C39383CA4B7
	for <lists+kvm@lfdr.de>; Thu, 15 Jul 2021 19:49:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235437AbhGORwD (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 15 Jul 2021 13:52:03 -0400
Received: from mga14.intel.com ([192.55.52.115]:16124 "EHLO mga14.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235390AbhGORwC (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 15 Jul 2021 13:52:02 -0400
X-IronPort-AV: E=McAfee;i="6200,9189,10046"; a="210412295"
X-IronPort-AV: E=Sophos;i="5.84,243,1620716400"; 
   d="scan'208";a="210412295"
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Jul 2021 10:49:04 -0700
X-IronPort-AV: E=Sophos;i="5.84,243,1620716400"; 
   d="scan'208";a="489539779"
Received: from otc-nc-03.jf.intel.com (HELO otc-nc-03) ([10.54.39.36])
  by fmsmga004-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Jul 2021 10:49:03 -0700
Date:   Thu, 15 Jul 2021 10:48:36 -0700
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
Message-ID: <20210715174836.GB593686@otc-nc-03>
References: <BN9PR11MB5433B1E4AE5B0480369F97178C189@BN9PR11MB5433.namprd11.prod.outlook.com>
 <7ea349f8-8c53-e240-fe80-382954ba7f28@huawei.com>
 <BN9PR11MB5433A9B792441CAF21A183A38C129@BN9PR11MB5433.namprd11.prod.outlook.com>
 <a8edb2c1-9c9c-6204-072c-4f1604b7dace@huawei.com>
 <BN9PR11MB54336D6A8CAE31F951770A428C129@BN9PR11MB5433.namprd11.prod.outlook.com>
 <20210715124813.GC543781@nvidia.com>
 <20210715135757.GC590891@otc-nc-03>
 <20210715152325.GF543781@nvidia.com>
 <20210715162141.GA593686@otc-nc-03>
 <20210715171826.GG543781@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210715171826.GG543781@nvidia.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Jul 15, 2021 at 02:18:26PM -0300, Jason Gunthorpe wrote:
> On Thu, Jul 15, 2021 at 09:21:41AM -0700, Raj, Ashok wrote:
> > On Thu, Jul 15, 2021 at 12:23:25PM -0300, Jason Gunthorpe wrote:
> > > On Thu, Jul 15, 2021 at 06:57:57AM -0700, Raj, Ashok wrote:
> > > > On Thu, Jul 15, 2021 at 09:48:13AM -0300, Jason Gunthorpe wrote:
> > > > > On Thu, Jul 15, 2021 at 06:49:54AM +0000, Tian, Kevin wrote:
> > > > > 
> > > > > > No. You are right on this case. I don't think there is a way to 
> > > > > > differentiate one mdev from the other if they come from the
> > > > > > same parent and attached by the same guest process. In this
> > > > > > case the fault could be reported on either mdev (e.g. the first
> > > > > > matching one) to get it fixed in the guest.
> > > > > 
> > > > > If the IOMMU can't distinguish the two mdevs they are not isolated
> > > > > and would have to share a group. Since group sharing is not supported
> > > > > today this seems like a non-issue
> > > > 
> > > > Does this mean we have to prevent 2 mdev's from same pdev being assigned to
> > > > the same guest? 
> > > 
> > > No, it means that the IOMMU layer has to be able to distinguish them.
> > 
> > Ok, the guest has no control over it, as it see 2 separate pci devices and
> > thinks they are all different.
> > 
> > Only time when it can fail is during the bind operation. From guest
> > perspective a bind in vIOMMU just turns into a write to local table and a
> > invalidate will cause the host to update the real copy from the shadow.
> > 
> > There is no way to fail the bind? and Allocation of the PASID is also a
> > separate operation and has no clue how its going to be used in the guest.
> 
> You can't attach the same RID to the same PASID twice. The IOMMU code
> should prevent this.
> 
> As we've talked about several times, it seems to me the vIOMMU
> interface is misdesigned for the requirements you have. The hypervisor
> should have a role in allocating the PASID since there are invisible
> hypervisor restrictions. This is one of them.

Allocating a PASID is a separate step from binding, isn't it? In vt-d we
have a virtual command interface that can fail an allocation of PASID. But
which device its bound to is a dynamic thing that only gets at bind_mm()
right?

> 
> > Do we have any isolation requirements here? its the same process. So if the
> > page-request it sent to guest and even if you report it for mdev1, after
> > the PRQ is resolved by guest, the request from mdev2 from the same guest
> > should simply work?
> 
> I think we already talked about this and said it should not be done.

I get the should not be done, I'm wondering where should that be
implemented?
