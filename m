Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E7A96356155
	for <lists+kvm@lfdr.de>; Wed,  7 Apr 2021 04:08:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343907AbhDGCHr (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 6 Apr 2021 22:07:47 -0400
Received: from mga01.intel.com ([192.55.52.88]:25943 "EHLO mga01.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S241715AbhDGCHq (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 6 Apr 2021 22:07:46 -0400
IronPort-SDR: +R5yOZzTnHkUIDs6V3XAYgmzl4VCFHx+1j5Nf9FxAj1r4fVoFHDRVV236L3MGkLsiO8/5X/qLG
 0IaHugJ16Z8A==
X-IronPort-AV: E=McAfee;i="6000,8403,9946"; a="213578681"
X-IronPort-AV: E=Sophos;i="5.82,201,1613462400"; 
   d="scan'208";a="213578681"
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Apr 2021 19:07:38 -0700
IronPort-SDR: fDuRvZeWJpzEPmRn66RzhNe3/ZDoww0cSNF+LwBZVLnGb13yx5oCd77HZxLU9/AtWTRhoJQ/lP
 Ho6tkLrKH2oQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.82,201,1613462400"; 
   d="scan'208";a="441153756"
Received: from allen-box.sh.intel.com (HELO [10.239.159.128]) ([10.239.159.128])
  by fmsmga004.fm.intel.com with ESMTP; 06 Apr 2021 19:07:33 -0700
Cc:     baolu.lu@linux.intel.com, Joerg Roedel <joro@8bytes.org>,
        David Woodhouse <dwmw2@infradead.org>,
        Alex Williamson <alex.williamson@redhat.com>,
        Kirti Wankhede <kwankhede@nvidia.com>, ashok.raj@intel.com,
        sanjay.k.kumar@intel.com, jacob.jun.pan@intel.com,
        kevin.tian@intel.com,
        Jean-Philippe Brucker <jean-philippe.brucker@arm.com>,
        yi.l.liu@intel.com, yi.y.sun@intel.com, peterx@redhat.com,
        tiwei.bie@intel.com, xin.zeng@intel.com,
        iommu@lists.linux-foundation.org, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Jacob Pan <jacob.jun.pan@linux.intel.com>
Subject: Re: [PATCH v8 7/9] vfio/mdev: Add iommu related member in mdev_device
To:     Jason Gunthorpe <jgg@nvidia.com>, Christoph Hellwig <hch@lst.de>
References: <20190325013036.18400-1-baolu.lu@linux.intel.com>
 <20190325013036.18400-8-baolu.lu@linux.intel.com>
 <20210406200030.GA425310@nvidia.com>
From:   Lu Baolu <baolu.lu@linux.intel.com>
Message-ID: <1cbe97fb-5595-8cf5-9e0c-1a2edf8c5d9a@linux.intel.com>
Date:   Wed, 7 Apr 2021 09:58:05 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.1
MIME-Version: 1.0
In-Reply-To: <20210406200030.GA425310@nvidia.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Jason,

On 4/7/21 4:00 AM, Jason Gunthorpe wrote:
> On Mon, Mar 25, 2019 at 09:30:34AM +0800, Lu Baolu wrote:
>> A parent device might create different types of mediated
>> devices. For example, a mediated device could be created
>> by the parent device with full isolation and protection
>> provided by the IOMMU. One usage case could be found on
>> Intel platforms where a mediated device is an assignable
>> subset of a PCI, the DMA requests on behalf of it are all
>> tagged with a PASID. Since IOMMU supports PASID-granular
>> translations (scalable mode in VT-d 3.0), this mediated
>> device could be individually protected and isolated by an
>> IOMMU.
>>
>> This patch adds a new member in the struct mdev_device to
>> indicate that the mediated device represented by mdev could
>> be isolated and protected by attaching a domain to a device
>> represented by mdev->iommu_device. It also adds a helper to
>> add or set the iommu device.
>>
>> * mdev_device->iommu_device
>>    - This, if set, indicates that the mediated device could
>>      be fully isolated and protected by IOMMU via attaching
>>      an iommu domain to this device. If empty, it indicates
>>      using vendor defined isolation, hence bypass IOMMU.
>>
>> * mdev_set/get_iommu_device(dev, iommu_device)
>>    - Set or get the iommu device which represents this mdev
>>      in IOMMU's device scope. Drivers don't need to set the
>>      iommu device if it uses vendor defined isolation.
>>
>> Cc: Ashok Raj <ashok.raj@intel.com>
>> Cc: Jacob Pan <jacob.jun.pan@linux.intel.com>
>> Cc: Kevin Tian <kevin.tian@intel.com>
>> Cc: Liu Yi L <yi.l.liu@intel.com>
>> Suggested-by: Kevin Tian <kevin.tian@intel.com>
>> Suggested-by: Alex Williamson <alex.williamson@redhat.com>
>> Signed-off-by: Lu Baolu <baolu.lu@linux.intel.com>
>> Reviewed-by: Jean-Philippe Brucker <jean-philippe.brucker@arm.com>
>> ---
>>   drivers/vfio/mdev/mdev_core.c    | 18 ++++++++++++++++++
>>   drivers/vfio/mdev/mdev_private.h |  1 +
>>   include/linux/mdev.h             | 14 ++++++++++++++
>>   3 files changed, 33 insertions(+)
>>
>> diff --git a/drivers/vfio/mdev/mdev_core.c b/drivers/vfio/mdev/mdev_core.c
>> index b96fedc77ee5..1b6435529166 100644
>> +++ b/drivers/vfio/mdev/mdev_core.c
>> @@ -390,6 +390,24 @@ int mdev_device_remove(struct device *dev, bool force_remove)
>>   	return 0;
>>   }
>>   
>> +int mdev_set_iommu_device(struct device *dev, struct device *iommu_device)
>> +{
>> +	struct mdev_device *mdev = to_mdev_device(dev);
>> +
>> +	mdev->iommu_device = iommu_device;
>> +
>> +	return 0;
>> +}
>> +EXPORT_SYMBOL(mdev_set_iommu_device);
> 
> I was looking at these functions when touching the mdev stuff and I
> have some concerns.
> 
> 1) Please don't merge dead code. It is a year later and there is still
>     no in-tree user for any of this. This is not our process. Even
>     worse it was exported so it looks like this dead code is supporting
>     out of tree modules.
> 
> 2) Why is this like this? Every struct device already has a connection
>     to the iommu layer and every mdev has a struct device all its own.
> 
>     Why did we need to add special 'if (mdev)' stuff all over the
>     place? This smells like the same abuse Thomas
>     and I pointed out for the interrupt domains.

I've ever tried to implement a bus iommu_ops for mdev devices.

https://lore.kernel.org/lkml/20201030045809.957927-1-baolu.lu@linux.intel.com/

Any comments?

Best regards,
baolu

> 
>     After my next series the mdev drivers will have direct access to
>     the vfio_device. So an alternative to using the struct device, or
>     adding 'if mdev' is to add an API to the vfio_device world to
>     inject what iommu configuration is needed from that direction
>     instead of trying to discover it from a struct device.
> 
> 3) The vfio_bus_is_mdev() and related symbol_get() nonsense in
>     drivers/vfio/vfio_iommu_type1.c has to go, for the same reasons
>     it was not acceptable to do this for the interrupt side either.
> 
> 4) It seems pretty clear to me this will be heavily impacted by the
>     /dev/ioasid discussion. Please consider removing the dead code now.
> 
> Basically, please fix this before trying to get idxd mdev merged as
> the first user.
> 
> Jason
> 
