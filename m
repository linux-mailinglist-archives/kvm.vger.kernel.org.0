Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2445041E638
	for <lists+kvm@lfdr.de>; Fri,  1 Oct 2021 05:28:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230519AbhJADaE (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 30 Sep 2021 23:30:04 -0400
Received: from verein.lst.de ([213.95.11.211]:33481 "EHLO verein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230283AbhJADaD (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 30 Sep 2021 23:30:03 -0400
Received: by verein.lst.de (Postfix, from userid 2407)
        id C1AB068AFE; Fri,  1 Oct 2021 05:28:16 +0200 (CEST)
Date:   Fri, 1 Oct 2021 05:28:16 +0200
From:   "hch@lst.de" <hch@lst.de>
To:     Jason Gunthorpe <jgg@nvidia.com>
Cc:     Jean-Philippe Brucker <jean-philippe@linaro.org>,
        "Tian, Kevin" <kevin.tian@intel.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "jasowang@redhat.com" <jasowang@redhat.com>,
        "kwankhede@nvidia.com" <kwankhede@nvidia.com>,
        "hch@lst.de" <hch@lst.de>, "Jiang, Dave" <dave.jiang@intel.com>,
        "Raj, Ashok" <ashok.raj@intel.com>,
        "corbet@lwn.net" <corbet@lwn.net>,
        "parav@mellanox.com" <parav@mellanox.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        "lkml@metux.net" <lkml@metux.net>,
        "david@gibson.dropbear.id.au" <david@gibson.dropbear.id.au>,
        "dwmw2@infradead.org" <dwmw2@infradead.org>,
        "Tian, Jun J" <jun.j.tian@intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "lushenming@huawei.com" <lushenming@huawei.com>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "robin.murphy@arm.com" <robin.murphy@arm.com>
Subject: Re: [RFC 10/20] iommu/iommufd: Add IOMMU_DEVICE_GET_INFO
Message-ID: <20211001032816.GC16450@lst.de>
References: <BN9PR11MB543333AD3C81312115686AAA8CA39@BN9PR11MB5433.namprd11.prod.outlook.com> <YUxTvCt1mYDntO8z@myrica> <20210923112716.GE964074@nvidia.com> <BN9PR11MB5433BCFCF3B0CB657E9BFE898CA39@BN9PR11MB5433.namprd11.prod.outlook.com> <20210923122220.GL964074@nvidia.com> <BN9PR11MB5433D75C09C6FDA01C2B7CF48CA99@BN9PR11MB5433.namprd11.prod.outlook.com> <20210929123630.GS964074@nvidia.com> <BN9PR11MB5433C9B5A0CD0B58163859EC8CAA9@BN9PR11MB5433.namprd11.prod.outlook.com> <YVWSaU4CHFHnwEA5@myrica> <20210930220446.GF964074@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210930220446.GF964074@nvidia.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Sep 30, 2021 at 07:04:46PM -0300, Jason Gunthorpe wrote:
> > On Arm cache coherency is configured through PTE attributes. I don't think
> > PCI No_snoop should be used because it's not necessarily supported
> > throughout the system and, as far as I understand, software can't discover
> > whether it is.
> 
> The usage of no-snoop is a behavior of a device. A generic PCI driver
> should be able to program the device to generate no-snoop TLPs and
> ideally rely on an arch specific API in the OS to trigger the required
> cache maintenance.

Well, it is a combination of the device, the root port and the driver
which all need to be in line to use this.

> It doesn't make much sense for a portable driver to rely on a
> non-portable IO PTE flag to control coherency, since that is not a
> standards based approach.
> 
> That said, Linux doesn't have a generic DMA API to support
> no-snoop. The few GPUs drivers that use this stuff just hardwired
> wbsync on Intel..

Yes, as usual the GPU folks come up with nasty hacks instead of
providing generic helper.  Basically all we'd need to support it
in a generic way is:

 - a DMA_ATTR_NO_SNOOP (or DMA_ATTR_FORCE_NONCOHERENT to fit the Linux
   terminology) which treats the current dma_map/unmap/sync calls as
   if dev_is_dma_coherent was false
 - a way for the driver to discover that a given architecture / running
   system actually supports this

> What I don't really understand is why ARM, with an IOMMU that supports
> PTE WB, has devices where dev_is_dma_coherent() == false ? 

Because no IOMMU in the world can help that fact that a periphal on the
SOC is not part of the cache coherency protocol.
