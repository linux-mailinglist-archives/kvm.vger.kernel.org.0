Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 31B0641E63A
	for <lists+kvm@lfdr.de>; Fri,  1 Oct 2021 05:31:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351637AbhJADcn (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 30 Sep 2021 23:32:43 -0400
Received: from verein.lst.de ([213.95.11.211]:33497 "EHLO verein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230346AbhJADcm (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 30 Sep 2021 23:32:42 -0400
Received: by verein.lst.de (Postfix, from userid 2407)
        id D489D68B05; Fri,  1 Oct 2021 05:30:54 +0200 (CEST)
Date:   Fri, 1 Oct 2021 05:30:54 +0200
From:   "hch@lst.de" <hch@lst.de>
To:     Jason Gunthorpe <jgg@nvidia.com>
Cc:     "Tian, Kevin" <kevin.tian@intel.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        "Liu, Yi L" <yi.l.liu@intel.com>, "hch@lst.de" <hch@lst.de>,
        "jasowang@redhat.com" <jasowang@redhat.com>,
        "joro@8bytes.org" <joro@8bytes.org>,
        "jean-philippe@linaro.org" <jean-philippe@linaro.org>,
        "parav@mellanox.com" <parav@mellanox.com>,
        "lkml@metux.net" <lkml@metux.net>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "lushenming@huawei.com" <lushenming@huawei.com>,
        "eric.auger@redhat.com" <eric.auger@redhat.com>,
        "corbet@lwn.net" <corbet@lwn.net>,
        "Raj, Ashok" <ashok.raj@intel.com>,
        "yi.l.liu@linux.intel.com" <yi.l.liu@linux.intel.com>,
        "Tian, Jun J" <jun.j.tian@intel.com>, "Wu, Hao" <hao.wu@intel.com>,
        "Jiang, Dave" <dave.jiang@intel.com>,
        "jacob.jun.pan@linux.intel.com" <jacob.jun.pan@linux.intel.com>,
        "kwankhede@nvidia.com" <kwankhede@nvidia.com>,
        "robin.murphy@arm.com" <robin.murphy@arm.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "iommu@lists.linux-foundation.org" <iommu@lists.linux-foundation.org>,
        "dwmw2@infradead.org" <dwmw2@infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "baolu.lu@linux.intel.com" <baolu.lu@linux.intel.com>,
        "david@gibson.dropbear.id.au" <david@gibson.dropbear.id.au>,
        "nicolinc@nvidia.com" <nicolinc@nvidia.com>
Subject: Re: [RFC 10/20] iommu/iommufd: Add IOMMU_DEVICE_GET_INFO
Message-ID: <20211001033054.GD16450@lst.de>
References: <20210919063848.1476776-1-yi.l.liu@intel.com> <20210919063848.1476776-11-yi.l.liu@intel.com> <20210922152407.1bfa6ff7.alex.williamson@redhat.com> <20210922234954.GB964074@nvidia.com> <BN9PR11MB5433409DF766AAEF1BB2CF258CA39@BN9PR11MB5433.namprd11.prod.outlook.com> <BN9PR11MB54333BDB1E58387FD9999DF18CA39@BN9PR11MB5433.namprd11.prod.outlook.com> <20210923114219.GG964074@nvidia.com> <BN9PR11MB5433519229319BA951CA97638CAA9@BN9PR11MB5433.namprd11.prod.outlook.com> <20210930222355.GH964074@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210930222355.GH964074@nvidia.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Sep 30, 2021 at 07:23:55PM -0300, Jason Gunthorpe wrote:
> > > The Intel functional issue is that Intel blocks the cache maintaince
> > > ops from the VM and the VM has no way to self-discover that the cache
> > > maintaince ops don't work.
> > 
> > the VM doesn't need to know whether the maintenance ops 
> > actually works.
> 
> Which is the whole problem.
> 
> Intel has a design where the device driver tells the device to issue
> non-cachable TLPs.
> 
> The driver is supposed to know if it can issue the cache maintaince
> instructions - if it can then it should ask the device to issue
> no-snoop TLPs.

The driver should never issue them.  This whole idea that a driver
can just magically poke the cache directly is just one of these horrible
short cuts that seems to happen in GPU land all the time but nowhere
else.

> > coherency and indirectly the underlying I/O page table format. 
> > If yes, then I don't see a reason why such decision should not be 
> > given to userspace for passthrough case.
> 
> The choice all comes down to if the other arches have cache
> maintenance instructions in the VM that *don't work*

Or have them at all.
