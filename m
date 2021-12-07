Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CF85D46B011
	for <lists+kvm@lfdr.de>; Tue,  7 Dec 2021 02:52:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235439AbhLGB4X (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 6 Dec 2021 20:56:23 -0500
Received: from mga12.intel.com ([192.55.52.136]:2913 "EHLO mga12.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234802AbhLGB4W (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 6 Dec 2021 20:56:22 -0500
X-IronPort-AV: E=McAfee;i="6200,9189,10190"; a="217481070"
X-IronPort-AV: E=Sophos;i="5.87,293,1631602800"; 
   d="scan'208";a="217481070"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Dec 2021 17:52:52 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.87,293,1631602800"; 
   d="scan'208";a="515038186"
Received: from allen-box.sh.intel.com (HELO [10.239.159.118]) ([10.239.159.118])
  by orsmga008.jf.intel.com with ESMTP; 06 Dec 2021 17:52:44 -0800
Cc:     baolu.lu@linux.intel.com,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Alex Williamson <alex.williamson@redhat.com>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Christoph Hellwig <hch@infradead.org>,
        Kevin Tian <kevin.tian@intel.com>,
        Ashok Raj <ashok.raj@intel.com>, Will Deacon <will@kernel.org>,
        Robin Murphy <robin.murphy@arm.com>,
        Dan Williams <dan.j.williams@intel.com>, rafael@kernel.org,
        Diana Craciun <diana.craciun@oss.nxp.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Eric Auger <eric.auger@redhat.com>,
        Liu Yi L <yi.l.liu@intel.com>,
        Jacob jun Pan <jacob.jun.pan@intel.com>,
        Chaitanya Kulkarni <kch@nvidia.com>,
        Stuart Yoder <stuyoder@gmail.com>,
        Laurentiu Tudor <laurentiu.tudor@nxp.com>,
        Thierry Reding <thierry.reding@gmail.com>,
        David Airlie <airlied@linux.ie>,
        Daniel Vetter <daniel@ffwll.ch>,
        Jonathan Hunter <jonathanh@nvidia.com>,
        Li Yang <leoyang.li@nxp.com>,
        Dmitry Osipenko <digetx@gmail.com>,
        iommu@lists.linux-foundation.org, linux-pci@vger.kernel.org,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 01/18] iommu: Add device dma ownership set/release
 interfaces
To:     Jason Gunthorpe <jgg@nvidia.com>, Joerg Roedel <joro@8bytes.org>
References: <20211206015903.88687-1-baolu.lu@linux.intel.com>
 <20211206015903.88687-2-baolu.lu@linux.intel.com>
 <Ya4Ru/GtILJYzI6j@8bytes.org> <20211206150144.GC4670@nvidia.com>
From:   Lu Baolu <baolu.lu@linux.intel.com>
Message-ID: <fa30d398-746c-c7d0-830f-40e3aaee16d6@linux.intel.com>
Date:   Tue, 7 Dec 2021 09:52:37 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.14.0
MIME-Version: 1.0
In-Reply-To: <20211206150144.GC4670@nvidia.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 12/6/21 11:01 PM, Jason Gunthorpe wrote:
> On Mon, Dec 06, 2021 at 02:35:55PM +0100, Joerg Roedel wrote:
>> On Mon, Dec 06, 2021 at 09:58:46AM +0800, Lu Baolu wrote:
>>> >From the perspective of who is initiating the device to do DMA, device
>>> DMA could be divided into the following types:
>>>
>>>          DMA_OWNER_DMA_API: Device DMAs are initiated by a kernel driver
>>> 			through the kernel DMA API.
>>>          DMA_OWNER_PRIVATE_DOMAIN: Device DMAs are initiated by a kernel
>>> 			driver with its own PRIVATE domain.
>>> 	DMA_OWNER_PRIVATE_DOMAIN_USER: Device DMAs are initiated by
>>> 			userspace.
>>
>> I have looked at the other iommu patches in this series, but I still
>> don't quite get what the difference in the code flow is between
>> DMA_OWNER_PRIVATE_DOMAIN and DMA_OWNER_PRIVATE_DOMAIN_USER. What are the
>> differences in the iommu core behavior based on this setting?
> 
> USER causes the IOMMU code to spend extra work to never assign the
> default domain. Lu, it would be good to update the comment with this
> detail
> 
> Once in USER mode the domain is always a /dev/null domain or a domain
> controlled by userspace. Never a domain pointing at kernel memory.

Yes. The __iommu_detach_group() re-attaches the default domain
automatically. This is not allowed once in USER mode.

I will update the comments whit this detail.

> 
>>>   struct group_device {
>>> @@ -621,6 +624,7 @@ struct iommu_group *iommu_group_alloc(void)
>>>   	INIT_LIST_HEAD(&group->devices);
>>>   	INIT_LIST_HEAD(&group->entry);
>>>   	BLOCKING_INIT_NOTIFIER_HEAD(&group->notifier);
>>> +	group->dma_owner = DMA_OWNER_NONE;
>>
>>
>> DMA_OWNER_NONE is also questionable. All devices are always in one
>> domain, and the default domain is always the one used for DMA-API, so
>> why isn't the initial value DMA_OWNER_DMA_API?
> 
> 'NONE' means the group is in the default domain but no driver is bound
> and thus DMA isn't being used. Seeing NONE is the only condition when
> it is OK to change the domain.
> 
> This could be reworked to instead rely on the refcount == 0 as the
> signal to know it is OK to change the domain and then we never have
> NONE at all. Lu?

NONE is just a parking state. It's okay to rely on the "refcount == 0"
for state transition as far as I see. I will work towards this.

Best regards,
baolu
