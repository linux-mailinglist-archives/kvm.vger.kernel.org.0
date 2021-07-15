Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 88AE53CA4F1
	for <lists+kvm@lfdr.de>; Thu, 15 Jul 2021 20:06:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232890AbhGOSJM (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 15 Jul 2021 14:09:12 -0400
Received: from mga04.intel.com ([192.55.52.120]:16898 "EHLO mga04.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229797AbhGOSJL (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 15 Jul 2021 14:09:11 -0400
X-IronPort-AV: E=McAfee;i="6200,9189,10046"; a="208786306"
X-IronPort-AV: E=Sophos;i="5.84,243,1620716400"; 
   d="scan'208";a="208786306"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Jul 2021 11:06:12 -0700
X-IronPort-AV: E=Sophos;i="5.84,243,1620716400"; 
   d="scan'208";a="460476517"
Received: from otc-nc-03.jf.intel.com (HELO otc-nc-03) ([10.54.39.36])
  by orsmga008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Jul 2021 11:06:12 -0700
Date:   Thu, 15 Jul 2021 11:05:45 -0700
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
Message-ID: <20210715180545.GD593686@otc-nc-03>
References: <BN9PR11MB5433A9B792441CAF21A183A38C129@BN9PR11MB5433.namprd11.prod.outlook.com>
 <a8edb2c1-9c9c-6204-072c-4f1604b7dace@huawei.com>
 <BN9PR11MB54336D6A8CAE31F951770A428C129@BN9PR11MB5433.namprd11.prod.outlook.com>
 <20210715124813.GC543781@nvidia.com>
 <20210715135757.GC590891@otc-nc-03>
 <20210715152325.GF543781@nvidia.com>
 <20210715162141.GA593686@otc-nc-03>
 <20210715171826.GG543781@nvidia.com>
 <20210715174836.GB593686@otc-nc-03>
 <20210715175336.GH543781@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210715175336.GH543781@nvidia.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Jul 15, 2021 at 02:53:36PM -0300, Jason Gunthorpe wrote:
> On Thu, Jul 15, 2021 at 10:48:36AM -0700, Raj, Ashok wrote:
> 
> > > > Do we have any isolation requirements here? its the same process. So if the
> > > > page-request it sent to guest and even if you report it for mdev1, after
> > > > the PRQ is resolved by guest, the request from mdev2 from the same guest
> > > > should simply work?
> > > 
> > > I think we already talked about this and said it should not be done.
> > 
> > I get the should not be done, I'm wondering where should that be
> > implemented?
> 
> The iommu layer cannot have ambiguity. Every RID or RID,PASID slot
> must have only one device attached to it. Attempting to connect two
> devices to the same slot fails on the iommu layer.

I guess we are talking about two different things. I was referring to SVM
side of things. Maybe you are referring to the mdev.

A single guest process should be allowed to work with 2 different
accelerators. The PASID for the process is just 1. Limiting that to just
one accelerator per process seems wrong.

Unless there is something else to prevent this, the best way seems never
expose more than 1 mdev from same pdev to the same guest. I think this is a
reasonable restriction compared to limiting a process to bind to no more
than 1 accelerator.


> 
> So the 2nd mdev will fail during IOASID binding when it tries to bind
> to the same PASID that the first mdev is already bound to.
> 
> Jason

