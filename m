Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1709742D4B6
	for <lists+kvm@lfdr.de>; Thu, 14 Oct 2021 10:22:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230072AbhJNIYd (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 14 Oct 2021 04:24:33 -0400
Received: from verein.lst.de ([213.95.11.211]:49147 "EHLO verein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230010AbhJNIYd (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 14 Oct 2021 04:24:33 -0400
Received: by verein.lst.de (Postfix, from userid 2407)
        id E172B68B05; Thu, 14 Oct 2021 10:22:24 +0200 (CEST)
Date:   Thu, 14 Oct 2021 10:22:24 +0200
From:   "hch@lst.de" <hch@lst.de>
To:     "Tian, Kevin" <kevin.tian@intel.com>
Cc:     "hch@lst.de" <hch@lst.de>, Jason Gunthorpe <jgg@nvidia.com>,
        Jean-Philippe Brucker <jean-philippe@linaro.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "jasowang@redhat.com" <jasowang@redhat.com>,
        "kwankhede@nvidia.com" <kwankhede@nvidia.com>,
        "Jiang, Dave" <dave.jiang@intel.com>,
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
Message-ID: <20211014082224.GA30554@lst.de>
References: <20210923112716.GE964074@nvidia.com> <BN9PR11MB5433BCFCF3B0CB657E9BFE898CA39@BN9PR11MB5433.namprd11.prod.outlook.com> <20210923122220.GL964074@nvidia.com> <BN9PR11MB5433D75C09C6FDA01C2B7CF48CA99@BN9PR11MB5433.namprd11.prod.outlook.com> <20210929123630.GS964074@nvidia.com> <BN9PR11MB5433C9B5A0CD0B58163859EC8CAA9@BN9PR11MB5433.namprd11.prod.outlook.com> <YVWSaU4CHFHnwEA5@myrica> <20210930220446.GF964074@nvidia.com> <20211001032816.GC16450@lst.de> <BN9PR11MB5433075C677D7E33C20431418CB89@BN9PR11MB5433.namprd11.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <BN9PR11MB5433075C677D7E33C20431418CB89@BN9PR11MB5433.namprd11.prod.outlook.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Oct 14, 2021 at 08:13:03AM +0000, Tian, Kevin wrote:
> Based on above information my interpretation is that existing 
> DMA API manages coherency per device and It's not designed for
> devices which are coherent in nature but also set PCI no-snoop
> for selective traffic. Then the new DMA_ATTR_NO_SNOOP, once
> set in dma_map, allows the driver to follow non-coherent
> semantics even when the device itself is considered coherent.
> 
> Does it capture the whole story correct? 

Yes.

> > > What I don't really understand is why ARM, with an IOMMU that supports
> > > PTE WB, has devices where dev_is_dma_coherent() == false ?
> > 
> > Because no IOMMU in the world can help that fact that a periphal on the
> > SOC is not part of the cache coherency protocol.
> 
> but since DMA goes through IOMMU then isn't IOMMU the one who
> should decide the final cache coherency? What would be the case
> if the IOMMU sets WB while the peripheral doesn't want it?

No.  And IOMMU deal with address translation, it can't paper over
a fact that there is no coherency possible.
