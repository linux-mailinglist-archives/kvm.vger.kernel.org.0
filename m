Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ED85E4508AF
	for <lists+kvm@lfdr.de>; Mon, 15 Nov 2021 16:37:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236407AbhKOPkl (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 15 Nov 2021 10:40:41 -0500
Received: from foss.arm.com ([217.140.110.172]:56782 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236527AbhKOPkg (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 15 Nov 2021 10:40:36 -0500
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id F31FE1063;
        Mon, 15 Nov 2021 07:37:40 -0800 (PST)
Received: from [10.57.82.45] (unknown [10.57.82.45])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 5BBB93F766;
        Mon, 15 Nov 2021 07:37:38 -0800 (PST)
Message-ID: <8499f0ab-9701-2ca2-ac7a-842c36c54f8a@arm.com>
Date:   Mon, 15 Nov 2021 15:37:18 +0000
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; rv:91.0) Gecko/20100101
 Thunderbird/91.3.0
Subject: Re: [PATCH 02/11] driver core: Set DMA ownership during driver
 bind/unbind
Content-Language: en-GB
To:     Jason Gunthorpe <jgg@nvidia.com>,
        Christoph Hellwig <hch@infradead.org>
Cc:     Kevin Tian <kevin.tian@intel.com>,
        Chaitanya Kulkarni <kch@nvidia.com>,
        Ashok Raj <ashok.raj@intel.com>, kvm@vger.kernel.org,
        rafael@kernel.org, Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Cornelia Huck <cohuck@redhat.com>,
        Will Deacon <will@kernel.org>, linux-kernel@vger.kernel.org,
        iommu@lists.linux-foundation.org,
        Alex Williamson <alex.williamson@redhat.com>,
        Jacob jun Pan <jacob.jun.pan@intel.com>,
        linux-pci@vger.kernel.org, Bjorn Helgaas <bhelgaas@google.com>,
        Diana Craciun <diana.craciun@oss.nxp.com>
References: <20211115020552.2378167-1-baolu.lu@linux.intel.com>
 <20211115020552.2378167-3-baolu.lu@linux.intel.com>
 <YZJeRomcJjDqDv9q@infradead.org> <20211115132442.GA2379906@nvidia.com>
From:   Robin Murphy <robin.murphy@arm.com>
In-Reply-To: <20211115132442.GA2379906@nvidia.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 2021-11-15 13:24, Jason Gunthorpe via iommu wrote:
> On Mon, Nov 15, 2021 at 05:19:02AM -0800, Christoph Hellwig wrote:
>> On Mon, Nov 15, 2021 at 10:05:43AM +0800, Lu Baolu wrote:
>>> @@ -566,6 +567,12 @@ static int really_probe(struct device *dev, struct device_driver *drv)
>>>   		goto done;
>>>   	}
>>>   
>>> +	if (!drv->suppress_auto_claim_dma_owner) {
>>> +		ret = iommu_device_set_dma_owner(dev, DMA_OWNER_KERNEL, NULL);
>>> +		if (ret)
>>> +			return ret;
>>> +	}
>>
>> I'd expect this to go into iommu_setup_dma_ops (and its arm and s390
>> equivalents), as that is what claims an IOMMU for in-kernel usage
> 
> If iommu_device_set_dma_owner(dev_a) fails changes dynamically
> depending on what iommu_device_set_dma_owner(dev_b, DMA_OWNER_USER)
> have been done.
> 
> The whole point here is that doing a
>   iommu_device_set_dma_owner(dev_b, DMA_OWNER_USER)
> needs to revoke kernel usage from a whole bunch of other devices in
> the same group.
> 
> revoking kernel usage means it needs to ensure that no driver is bound
> and prevent future drivers from being bound.
> 
> iommu_setup_dma_ops() is something done once early on in boot, not at
> every driver probe, so I don't see how it can help??

Note that there's some annoying inconsistency across architectures, and 
with the {acpi,of}_dma_configure() code in general. I guess Christoph 
might be thinking of the case where iommu_setup_dma_ops() *does* end up 
being called off the back of the bus->dma_configure() hook a few lines 
below the context above.

iommu_setup_dma_ops() itself is indeed not the appropriate place for 
this (the fact that it can be called as late as driver probe is subtly 
broken and still on my list to fix...) but
bus->dma_configure() definitely is. Only a handful of buses care about 
IOMMUs, and possibly even fewer of them support VFIO, so I'm in full 
agreement with Greg and Christoph that this absolutely warrants being 
scoped per-bus. I mean, we literally already have infrastructure to 
prevent drivers binding if the IOMMU/DMA configuration is broken or not 
ready yet; why would we want a totally different mechanism to prevent 
driver binding when the only difference is that that configuration *is* 
ready and working to the point that someone's already claimed it for 
other purposes?

Robin.
