Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 582D1451013
	for <lists+kvm@lfdr.de>; Mon, 15 Nov 2021 19:38:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242571AbhKOSl0 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 15 Nov 2021 13:41:26 -0500
Received: from foss.arm.com ([217.140.110.172]:59582 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S242558AbhKOSin (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 15 Nov 2021 13:38:43 -0500
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 62236D6E;
        Mon, 15 Nov 2021 10:35:47 -0800 (PST)
Received: from [10.57.82.45] (unknown [10.57.82.45])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id A4A423F70D;
        Mon, 15 Nov 2021 10:35:44 -0800 (PST)
Message-ID: <cc9878ae-df49-950c-f4f8-2e6ba545079b@arm.com>
Date:   Mon, 15 Nov 2021 18:35:37 +0000
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; rv:91.0) Gecko/20100101
 Thunderbird/91.3.0
Subject: Re: [PATCH 02/11] driver core: Set DMA ownership during driver
 bind/unbind
Content-Language: en-GB
To:     Jason Gunthorpe <jgg@nvidia.com>
Cc:     Alex Williamson <alex.williamson@redhat.com>,
        Kevin Tian <kevin.tian@intel.com>,
        Chaitanya Kulkarni <kch@nvidia.com>,
        Ashok Raj <ashok.raj@intel.com>, kvm@vger.kernel.org,
        rafael@kernel.org, Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Cornelia Huck <cohuck@redhat.com>,
        linux-kernel@vger.kernel.org,
        Christoph Hellwig <hch@infradead.org>,
        iommu@lists.linux-foundation.org,
        Jacob jun Pan <jacob.jun.pan@intel.com>,
        linux-pci@vger.kernel.org, Bjorn Helgaas <bhelgaas@google.com>,
        Will Deacon <will@kernel.org>,
        Diana Craciun <diana.craciun@oss.nxp.com>
References: <20211115020552.2378167-1-baolu.lu@linux.intel.com>
 <20211115020552.2378167-3-baolu.lu@linux.intel.com>
 <YZJeRomcJjDqDv9q@infradead.org> <20211115132442.GA2379906@nvidia.com>
 <8499f0ab-9701-2ca2-ac7a-842c36c54f8a@arm.com>
 <20211115155613.GA2388278@nvidia.com>
From:   Robin Murphy <robin.murphy@arm.com>
In-Reply-To: <20211115155613.GA2388278@nvidia.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 2021-11-15 15:56, Jason Gunthorpe via iommu wrote:
> On Mon, Nov 15, 2021 at 03:37:18PM +0000, Robin Murphy wrote:
> 
>> IOMMUs, and possibly even fewer of them support VFIO, so I'm in full
>> agreement with Greg and Christoph that this absolutely warrants being scoped
>> per-bus. I mean, we literally already have infrastructure to prevent drivers
>> binding if the IOMMU/DMA configuration is broken or not ready yet; why would
>> we want a totally different mechanism to prevent driver binding when the
>> only difference is that that configuration *is* ready and working to the
>> point that someone's already claimed it for other purposes?
> 
> I see, that does make sense
> 
> I see these implementations:
> 
> drivers/amba/bus.c:     .dma_configure  = platform_dma_configure,
> drivers/base/platform.c:        .dma_configure  = platform_dma_configure,
> drivers/bus/fsl-mc/fsl-mc-bus.c:        .dma_configure  = fsl_mc_dma_configure,
> drivers/pci/pci-driver.c:       .dma_configure  = pci_dma_configure,
> drivers/gpu/host1x/bus.c:       .dma_configure = host1x_dma_configure,
> 
> Other than host1x they all work with VFIO.
> 
> Also, there is no bus->dma_unconfigure() which would be needed to
> restore the device as well.

Not if we reduce the notion of "ownership" down to 
"dev->iommu_group->domain != dev->iommu_group->default_domain", which 
I'm becoming increasingly convinced is all we actually need here.

> So, would you rather see duplicated code into the 4 drivers, and a new
> bus op to 'unconfigure dma'

The .dma_configure flow is unavoidably a bit boilerplatey already, so 
personally I'd go for having the implementations call back into a common 
check, similarly to their current flow. That also leaves room for the 
bus code to further refine the outcome based on what it might know, 
which I can particularly imagine for cleverer buses like fsl-mc and 
host1x which can have lots of inside knowledge about how their devices 
may interact.

Robin.

> Or, a 'dev_configure_dma()' function that is roughly:
> 
>          if (dev->bus->dma_configure) {
>                  ret = dev->bus->dma_configure(dev);
>                  if (ret)
>                          return ret;
>                  if (!drv->suppress_auto_claim_dma_owner) {
>                         ret = iommu_device_set_dma_owner(dev, DMA_OWNER_KERNEL,
>                                                          NULL);
>                         if (ret)
>                                 ret;
>                  }
>           }
> 
> And a pair'd undo.
> 
> This is nice because we can enforce dev->bus->dma_configure when doing
> a user bind so everything holds together safely without relying on
> each bus_type to properly implement security.
> 
> Jason
> _______________________________________________
> iommu mailing list
> iommu@lists.linux-foundation.org
> https://lists.linuxfoundation.org/mailman/listinfo/iommu
> 
