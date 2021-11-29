Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1157B460DF4
	for <lists+kvm@lfdr.de>; Mon, 29 Nov 2021 05:05:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236973AbhK2EI5 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 28 Nov 2021 23:08:57 -0500
Received: from mga11.intel.com ([192.55.52.93]:11618 "EHLO mga11.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230207AbhK2EGy (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 28 Nov 2021 23:06:54 -0500
X-IronPort-AV: E=McAfee;i="6200,9189,10182"; a="233385854"
X-IronPort-AV: E=Sophos;i="5.87,272,1631602800"; 
   d="scan'208";a="233385854"
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Nov 2021 20:03:37 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.87,272,1631602800"; 
   d="scan'208";a="458985855"
Received: from allen-box.sh.intel.com (HELO [10.239.159.118]) ([10.239.159.118])
  by orsmga006.jf.intel.com with ESMTP; 28 Nov 2021 20:03:29 -0800
Cc:     baolu.lu@linux.intel.com, Joerg Roedel <joro@8bytes.org>,
        Alex Williamson <alex.williamson@redhat.com>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Jason Gunthorpe <jgg@nvidia.com>,
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
        Li Yang <leoyang.li@nxp.com>, iommu@lists.linux-foundation.org,
        linux-pci@vger.kernel.org, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 02/17] driver core: Add dma_unconfigure callback in
 bus_type
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
References: <20211128025051.355578-1-baolu.lu@linux.intel.com>
 <20211128025051.355578-3-baolu.lu@linux.intel.com>
 <YaM3slBGozqxsQ+m@kroah.com>
From:   Lu Baolu <baolu.lu@linux.intel.com>
Message-ID: <0eca1892-a063-a695-ac35-0ac1e2de28e0@linux.intel.com>
Date:   Mon, 29 Nov 2021 12:03:30 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.14.0
MIME-Version: 1.0
In-Reply-To: <YaM3slBGozqxsQ+m@kroah.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 11/28/21 4:02 PM, Greg Kroah-Hartman wrote:
> On Sun, Nov 28, 2021 at 10:50:36AM +0800, Lu Baolu wrote:
>> The bus_type structure defines dma_configure() callback for bus drivers
>> to configure DMA on the devices. This adds the paired dma_unconfigure()
>> callback and calls it during driver unbinding so that bus drivers can do
>> some cleanup work.
>>
>> One use case for this paired DMA callbacks is for the bus driver to check
>> for DMA ownership conflicts during driver binding, where multiple devices
>> belonging to a same IOMMU group (the minimum granularity of isolation and
>> protection) may be assigned to kernel drivers or user space respectively.
>>
>> Without this change, for example, the vfio driver has to listen to a bus
>> BOUND_DRIVER event and then BUG_ON() in case of dma ownership conflict.
>> This leads to bad user experience since careless driver binding operation
>> may crash the system if the admin overlooks the group restriction. Aside
>> from bad design, this leads to a security problem as a root user, even with
>> lockdown=integrity, can force the kernel to BUG.
>>
>> With this change, the bus driver could check and set the DMA ownership in
>> driver binding process and fail on ownership conflicts. The DMA ownership
>> should be released during driver unbinding.
>>
>> Suggested-by: Jason Gunthorpe <jgg@nvidia.com>
>> Link: https://lore.kernel.org/linux-iommu/20210922123931.GI327412@nvidia.com/
>> Link: https://lore.kernel.org/linux-iommu/20210928115751.GK964074@nvidia.com/
>> Signed-off-by: Lu Baolu <baolu.lu@linux.intel.com>
>> ---
>>   include/linux/device/bus.h | 3 +++
>>   drivers/base/dd.c          | 7 ++++++-
>>   2 files changed, 9 insertions(+), 1 deletion(-)
>>
>> diff --git a/include/linux/device/bus.h b/include/linux/device/bus.h
>> index a039ab809753..ef54a71e5f8f 100644
>> --- a/include/linux/device/bus.h
>> +++ b/include/linux/device/bus.h
>> @@ -59,6 +59,8 @@ struct fwnode_handle;
>>    *		bus supports.
>>    * @dma_configure:	Called to setup DMA configuration on a device on
>>    *			this bus.
>> + * @dma_unconfigure:	Called to cleanup DMA configuration on a device on
>> + *			this bus.
> 
> "dma_cleanup()" is a better name for this, don't you think?

I agree with you. dma_cleanup() is more explicit and better here.

> 
> thanks,
> 
> greg k-h
> 

Best regards,
baolu
