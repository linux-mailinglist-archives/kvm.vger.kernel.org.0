Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D6300486EBF
	for <lists+kvm@lfdr.de>; Fri,  7 Jan 2022 01:27:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344129AbiAGA1i (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 6 Jan 2022 19:27:38 -0500
Received: from mga17.intel.com ([192.55.52.151]:2934 "EHLO mga17.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1343753AbiAGA1h (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 6 Jan 2022 19:27:37 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1641515257; x=1673051257;
  h=cc:subject:to:references:from:message-id:date:
   mime-version:in-reply-to:content-transfer-encoding;
  bh=DHF9LNBkwjjdXkY2HtbzusqrhjTjnQLSGj+vV2UJQkc=;
  b=PJ0GyA693KFE5CU2BlIP22yksGPDRI/LiYl70Q/moZieMDe2ZOo1RYmP
   M8pPmXE5shZ6Wi0hCfWzeE9AjNFgYGXnJ/Pi5/yVSy2WjtNMozfW46HKF
   SHcTBB9b+tDCThMA4B7D5zdR5e9tYTCwOm83uM0l5FAC/vwNhhEUBbFPR
   sktfMj2LUK/ovNzNKOmNHwpT19noqlG4V5WC3qOnkJ1UEUsUAcqeDaRlk
   tBBBhWaGW4dfeUKBuY3YOx3sCWFuY5JLnyAvBn+xC1wgUrrspK4QJlzI8
   DHbrN7wA8qJmqGTpx4iNYcDhlvDbzWKuk6c9qhGK7JPIReIexith5fP7d
   g==;
X-IronPort-AV: E=McAfee;i="6200,9189,10217"; a="223464221"
X-IronPort-AV: E=Sophos;i="5.88,268,1635231600"; 
   d="scan'208";a="223464221"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Jan 2022 16:27:37 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.88,268,1635231600"; 
   d="scan'208";a="527180734"
Received: from allen-box.sh.intel.com (HELO [10.239.159.118]) ([10.239.159.118])
  by orsmga008.jf.intel.com with ESMTP; 06 Jan 2022 16:27:30 -0800
Cc:     baolu.lu@linux.intel.com, Joerg Roedel <joro@8bytes.org>,
        Alex Williamson <alex.williamson@redhat.com>,
        Robin Murphy <robin.murphy@arm.com>,
        Christoph Hellwig <hch@infradead.org>,
        Kevin Tian <kevin.tian@intel.com>,
        Ashok Raj <ashok.raj@intel.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Will Deacon <will@kernel.org>,
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
Subject: Re: [PATCH v1 1/8] iommu: Add iommu_group_replace_domain()
To:     Jason Gunthorpe <jgg@nvidia.com>
References: <20220106022053.2406748-1-baolu.lu@linux.intel.com>
 <20220106022053.2406748-2-baolu.lu@linux.intel.com>
 <20220106170608.GI2328285@nvidia.com>
From:   Lu Baolu <baolu.lu@linux.intel.com>
Message-ID: <58e2d0d2-649a-a3f5-e8ae-9cbf2719015f@linux.intel.com>
Date:   Fri, 7 Jan 2022 08:26:50 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.14.0
MIME-Version: 1.0
In-Reply-To: <20220106170608.GI2328285@nvidia.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 1/7/22 1:06 AM, Jason Gunthorpe wrote:
> On Thu, Jan 06, 2022 at 10:20:46AM +0800, Lu Baolu wrote:
>> Expose an interface to replace the domain of an iommu group for frameworks
>> like vfio which claims the ownership of the whole iommu group.
>>
>> Signed-off-by: Lu Baolu <baolu.lu@linux.intel.com>
>>   include/linux/iommu.h | 10 ++++++++++
>>   drivers/iommu/iommu.c | 37 +++++++++++++++++++++++++++++++++++++
>>   2 files changed, 47 insertions(+)
>>
>> diff --git a/include/linux/iommu.h b/include/linux/iommu.h
>> index 408a6d2b3034..66ebce3d1e11 100644
>> +++ b/include/linux/iommu.h
>> @@ -677,6 +677,9 @@ void iommu_device_unuse_dma_api(struct device *dev);
>>   int iommu_group_set_dma_owner(struct iommu_group *group, void *owner);
>>   void iommu_group_release_dma_owner(struct iommu_group *group);
>>   bool iommu_group_dma_owner_claimed(struct iommu_group *group);
>> +int iommu_group_replace_domain(struct iommu_group *group,
>> +			       struct iommu_domain *old,
>> +			       struct iommu_domain *new);
>>   
>>   #else /* CONFIG_IOMMU_API */
>>   
>> @@ -1090,6 +1093,13 @@ static inline bool iommu_group_dma_owner_claimed(struct iommu_group *group)
>>   {
>>   	return false;
>>   }
>> +
>> +static inline int
>> +iommu_group_replace_domain(struct iommu_group *group, struct iommu_domain *old,
>> +			   struct iommu_domain *new)
>> +{
>> +	return -ENODEV;
>> +}
>>   #endif /* CONFIG_IOMMU_API */
>>   
>>   /**
>> diff --git a/drivers/iommu/iommu.c b/drivers/iommu/iommu.c
>> index 72a95dea688e..ab8ab95969f5 100644
>> +++ b/drivers/iommu/iommu.c
>> @@ -3431,3 +3431,40 @@ bool iommu_group_dma_owner_claimed(struct iommu_group *group)
>>   	return user;
>>   }
>>   EXPORT_SYMBOL_GPL(iommu_group_dma_owner_claimed);
>> +
>> +/**
>> + * iommu_group_replace_domain() - Replace group's domain
>> + * @group: The group.
>> + * @old: The previous attached domain. NULL for none.
>> + * @new: The new domain about to be attached.
>> + *
>> + * This is to support backward compatibility for vfio which manages the dma
>> + * ownership in iommu_group level.
> 
> This should mention it can only be used with iommu_group_set_dma_owner()

Sure.

> 
>> +	if (old)
>> +		__iommu_detach_group(old, group);
>> +
>> +	if (new) {
>> +		ret = __iommu_attach_group(new, group);
>> +		if (ret && old)
>> +			__iommu_attach_group(old, group);
>> +	}
> 
> The sketchy error unwind here gives me some pause for sure. Maybe we
> should define that on error this leaves the domain as NULL
> 
> Complicates vfio a tiny bit to cope with this failure but seems
> cleaner than leaving it indeterminate.

Fair enough.

> 
> Jason
> 

Best regards,
baolu
