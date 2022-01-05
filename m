Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 92061484E8E
	for <lists+kvm@lfdr.de>; Wed,  5 Jan 2022 07:58:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237893AbiAEG6k (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 5 Jan 2022 01:58:40 -0500
Received: from mga17.intel.com ([192.55.52.151]:59573 "EHLO mga17.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234678AbiAEG6j (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 5 Jan 2022 01:58:39 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1641365919; x=1672901919;
  h=cc:subject:to:references:from:message-id:date:
   mime-version:in-reply-to:content-transfer-encoding;
  bh=yBeZgFZXz0WezV8A7VIFIHNPB9e3L10eKsd6tnEonRs=;
  b=IbTtRUuDOgIe6lZKuQCCjyynL/b/ah8lDue4fvo/1GCmvUFH3WQnPfmF
   HTuZLlm5Ybj89Qe1WfuBpxHDJpWn/B2ygtFsAb8v+mhJIRu3+dPkiPfbM
   ZMYdxlL9TqnU7Dg6DUzBh8g0layqTx+qVzY1NnafrvdPQi8+O2vxaty0a
   d1nJljJEAbeWe2dE5EvVtg7HG08VTUaWjoRU9JIO8szFwvFeaRfALhQ1+
   vy/+bkIkbvKQh+24rdlvJDFue5g+r1QH5MQNxQNdZId/6bJrUCA14ru55
   FSVEmCenNb+FleFD9OuMWQk4FF1nrzUTua/ShQ/GdfA4AiFA5U4qRjeJ4
   A==;
X-IronPort-AV: E=McAfee;i="6200,9189,10217"; a="223062697"
X-IronPort-AV: E=Sophos;i="5.88,262,1635231600"; 
   d="scan'208";a="223062697"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Jan 2022 22:58:39 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.88,262,1635231600"; 
   d="scan'208";a="526392923"
Received: from allen-box.sh.intel.com (HELO [10.239.159.118]) ([10.239.159.118])
  by orsmga008.jf.intel.com with ESMTP; 04 Jan 2022 22:58:32 -0800
Cc:     baolu.lu@linux.intel.com,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Joerg Roedel <joro@8bytes.org>,
        Alex Williamson <alex.williamson@redhat.com>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Jason Gunthorpe <jgg@nvidia.com>,
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
Subject: Re: [PATCH v5 01/14] iommu: Add dma ownership management interfaces
To:     Christoph Hellwig <hch@infradead.org>
References: <20220104015644.2294354-1-baolu.lu@linux.intel.com>
 <20220104015644.2294354-2-baolu.lu@linux.intel.com>
 <YdQcgFhIMYvUwABV@infradead.org>
From:   Lu Baolu <baolu.lu@linux.intel.com>
Message-ID: <a95e2aec-aabf-2db1-0d51-a7829c378d47@linux.intel.com>
Date:   Wed, 5 Jan 2022 14:57:54 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.14.0
MIME-Version: 1.0
In-Reply-To: <YdQcgFhIMYvUwABV@infradead.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Christoph,

On 1/4/22 6:08 PM, Christoph Hellwig wrote:
> On Tue, Jan 04, 2022 at 09:56:31AM +0800, Lu Baolu wrote:
>> Multiple devices may be placed in the same IOMMU group because they
>> cannot be isolated from each other. These devices must either be
>> entirely under kernel control or userspace control, never a mixture.
>>
>> This adds dma ownership management in iommu core and exposes several
>> interfaces for the device drivers and the device userspace assignment
>> framework (i.e. vfio), so that any conflict between user and kernel
>> controlled DMA could be detected at the beginning.
>>
>> The device driver oriented interfaces are,
>>
>> 	int iommu_device_use_dma_api(struct device *dev);
>> 	void iommu_device_unuse_dma_api(struct device *dev);
>>
>> Devices under kernel drivers control must call iommu_device_use_dma_api()
>> before driver probes. The driver binding process must be aborted if it
>> returns failure.
>>
>> The vfio oriented interfaces are,
>>
>> 	int iommu_group_set_dma_owner(struct iommu_group *group,
>> 				      void *owner);
>> 	void iommu_group_release_dma_owner(struct iommu_group *group);
>> 	bool iommu_group_dma_owner_claimed(struct iommu_group *group);
>>
>> The device userspace assignment must be disallowed if the set dma owner
>> interface returns failure.
>>
>> Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
>> Signed-off-by: Kevin Tian <kevin.tian@intel.com>
>> Signed-off-by: Lu Baolu <baolu.lu@linux.intel.com>
>> ---
>>   include/linux/iommu.h |  31 ++++++++
>>   drivers/iommu/iommu.c | 161 +++++++++++++++++++++++++++++++++++++++++-
>>   2 files changed, 189 insertions(+), 3 deletions(-)
>>
>> diff --git a/include/linux/iommu.h b/include/linux/iommu.h
>> index de0c57a567c8..568f285468cf 100644
>> --- a/include/linux/iommu.h
>> +++ b/include/linux/iommu.h
>> @@ -682,6 +682,13 @@ struct iommu_sva *iommu_sva_bind_device(struct device *dev,
>>   void iommu_sva_unbind_device(struct iommu_sva *handle);
>>   u32 iommu_sva_get_pasid(struct iommu_sva *handle);
>>   
>> +int iommu_device_use_dma_api(struct device *dev);
>> +void iommu_device_unuse_dma_api(struct device *dev);
>> +
>> +int iommu_group_set_dma_owner(struct iommu_group *group, void *owner);
>> +void iommu_group_release_dma_owner(struct iommu_group *group);
>> +bool iommu_group_dma_owner_claimed(struct iommu_group *group);
>> +
>>   #else /* CONFIG_IOMMU_API */
>>   
>>   struct iommu_ops {};
>> @@ -1082,6 +1089,30 @@ static inline struct iommu_fwspec *dev_iommu_fwspec_get(struct device *dev)
>>   {
>>   	return NULL;
>>   }
>> +
>> +static inline int iommu_device_use_dma_api(struct device *dev)
>> +{
>> +	return 0;
>> +}
>> +
>> +static inline void iommu_device_unuse_dma_api(struct device *dev)
>> +{
>> +}
>> +
>> +static inline int
>> +iommu_group_set_dma_owner(struct iommu_group *group, void *owner)
>> +{
>> +	return -ENODEV;
>> +}
>> +
>> +static inline void iommu_group_release_dma_owner(struct iommu_group *group)
>> +{
>> +}
>> +
>> +static inline bool iommu_group_dma_owner_claimed(struct iommu_group *group)
>> +{
>> +	return false;
>> +}
>>   #endif /* CONFIG_IOMMU_API */
>>   
>>   /**
>> diff --git a/drivers/iommu/iommu.c b/drivers/iommu/iommu.c
>> index 8b86406b7162..ff0c8c1ad5af 100644
>> --- a/drivers/iommu/iommu.c
>> +++ b/drivers/iommu/iommu.c
>> @@ -48,6 +48,8 @@ struct iommu_group {
>>   	struct iommu_domain *default_domain;
>>   	struct iommu_domain *domain;
>>   	struct list_head entry;
>> +	unsigned int owner_cnt;
>> +	void *owner;
>>   };
>>   
>>   struct group_device {
>> @@ -289,7 +291,12 @@ int iommu_probe_device(struct device *dev)
>>   	mutex_lock(&group->mutex);
>>   	iommu_alloc_default_domain(group, dev);
>>   
>> -	if (group->default_domain) {
>> +	/*
>> +	 * If device joined an existing group which has been claimed
>> +	 * for none kernel DMA purpose, avoid attaching the default
>> +	 * domain.
>> +	 */
>> +	if (group->default_domain && !group->owner) {
>>   		ret = __iommu_attach_device(group->default_domain, dev);
>>   		if (ret) {
>>   			mutex_unlock(&group->mutex);
>> @@ -2320,7 +2327,7 @@ static int __iommu_attach_group(struct iommu_domain *domain,
>>   {
>>   	int ret;
>>   
>> -	if (group->default_domain && group->domain != group->default_domain)
>> +	if (group->domain && group->domain != group->default_domain)
>>   		return -EBUSY;
>>   
>>   	ret = __iommu_group_for_each_dev(group, domain,
>> @@ -2357,7 +2364,11 @@ static void __iommu_detach_group(struct iommu_domain *domain,
>>   {
>>   	int ret;
>>   
>> -	if (!group->default_domain) {
>> +	/*
>> +	 * If group has been claimed for none kernel DMA purpose, avoid
>> +	 * re-attaching the default domain.
>> +	 */
> 
> none kernel reads odd.  But maybe drop that and just say 'claimed
> already' ala:
> 
> 	/*
> 	 * If the group has been claimed already, do not re-attach the default
> 	 * domain.
> 	 */
> 

Sure!

Best regards,
baolu
