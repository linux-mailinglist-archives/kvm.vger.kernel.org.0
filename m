Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 17050452E3D
	for <lists+kvm@lfdr.de>; Tue, 16 Nov 2021 10:42:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233267AbhKPJpP (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 16 Nov 2021 04:45:15 -0500
Received: from mga03.intel.com ([134.134.136.65]:11756 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233149AbhKPJpN (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 16 Nov 2021 04:45:13 -0500
X-IronPort-AV: E=McAfee;i="6200,9189,10169"; a="233599062"
X-IronPort-AV: E=Sophos;i="5.87,238,1631602800"; 
   d="scan'208";a="233599062"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Nov 2021 01:42:14 -0800
X-IronPort-AV: E=Sophos;i="5.87,238,1631602800"; 
   d="scan'208";a="506359272"
Received: from blu2-mobl3.ccr.corp.intel.com (HELO [10.254.210.220]) ([10.254.210.220])
  by orsmga008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Nov 2021 01:42:07 -0800
Message-ID: <14bed5c1-a385-7e99-bda9-1041341fe68d@linux.intel.com>
Date:   Tue, 16 Nov 2021 17:42:04 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.3.0
Cc:     baolu.lu@linux.intel.com,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Joerg Roedel <joro@8bytes.org>,
        Alex Williamson <alex.williamson@redhat.com>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Jason Gunthorpe <jgg@nvidia.com>,
        Kevin Tian <kevin.tian@intel.com>,
        Ashok Raj <ashok.raj@intel.com>,
        Chaitanya Kulkarni <kch@nvidia.com>, kvm@vger.kernel.org,
        rafael@kernel.org, linux-pci@vger.kernel.org,
        Cornelia Huck <cohuck@redhat.com>,
        linux-kernel@vger.kernel.org, iommu@lists.linux-foundation.org,
        Jacob jun Pan <jacob.jun.pan@intel.com>,
        Diana Craciun <diana.craciun@oss.nxp.com>,
        Will Deacon <will@kernel.org>
Content-Language: en-US
To:     Christoph Hellwig <hch@infradead.org>
References: <20211115020552.2378167-1-baolu.lu@linux.intel.com>
 <20211115020552.2378167-7-baolu.lu@linux.intel.com>
 <YZJgMzYzuxjJpWIC@infradead.org>
From:   Lu Baolu <baolu.lu@linux.intel.com>
Subject: Re: [PATCH 06/11] iommu: Expose group variants of dma ownership
 interfaces
In-Reply-To: <YZJgMzYzuxjJpWIC@infradead.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Christoph,

On 2021/11/15 21:27, Christoph Hellwig wrote:
> On Mon, Nov 15, 2021 at 10:05:47AM +0800, Lu Baolu wrote:
>> The vfio needs to set DMA_OWNER_USER for the entire group when attaching
> 
> The vfio subsystem?  driver?

"vfio subsystem"

> 
>> it to a vfio container. So expose group variants of setting/releasing dma
>> ownership for this purpose.
>>
>> This also exposes the helper iommu_group_dma_owner_unclaimed() for vfio
>> report to userspace if the group is viable to user assignment, for
> 
> .. for vfio to report .. ?

Yes.

> 
>>   void iommu_device_release_dma_owner(struct device *dev, enum iommu_dma_owner owner);
>> +int iommu_group_set_dma_owner(struct iommu_group *group, enum iommu_dma_owner owner,
>> +			      struct file *user_file);
>> +void iommu_group_release_dma_owner(struct iommu_group *group, enum iommu_dma_owner owner);
> 
> Pleae avoid all these overly long lines.

Sure. Thanks!

> 
>> +static inline int iommu_group_set_dma_owner(struct iommu_group *group,
>> +					    enum iommu_dma_owner owner,
>> +					    struct file *user_file)
>> +{
>> +	return -EINVAL;
>> +}
>> +
>> +static inline void iommu_group_release_dma_owner(struct iommu_group *group,
>> +						 enum iommu_dma_owner owner)
>> +{
>> +}
>> +
>> +static inline bool iommu_group_dma_owner_unclaimed(struct iommu_group *group)
>> +{
>> +	return false;
>> +}
> 
> Why do we need these stubs?  All potential callers should already
> require CONFIG_IOMMU_API?  Same for the helpers added in patch 1, btw.

You are right. This helper is only for vfio which requires IOMMU_API. I
will remove this.

The helpers in patch 1 seem not the same. The driver core (or bus
dma_configure() callback as suggested) will also call them.

> 
>> +	mutex_lock(&group->mutex);
>> +	ret = __iommu_group_set_dma_owner(group, owner, user_file);
>> +	mutex_unlock(&group->mutex);
> 
>> +	mutex_lock(&group->mutex);
>> +	__iommu_group_release_dma_owner(group, owner);
>> +	mutex_unlock(&group->mutex);
> 
> Unless I'm missing something (just skipping over the patches),
> the existing callers also take the lock just around these calls,
> so we don't really need the __-prefixed lowlevel helpers.
> 

Move mutex_lock/unlock will make the helper implementation easier. :-)
It seems to be common code style in iommu core. For example,
__iommu_attach_group(), __iommu_group_for_each_dev(), etc.

>> +	mutex_lock(&group->mutex);
>> +	owner = group->dma_owner;
>> +	mutex_unlock(&group->mutex);
> 
> No need for a lock to read a single scalar.

Adding the lock will make kcasn happy. Jason G also told me that

[citing from his review comment]
"
It is always incorrect to read concurrent data without an annotation
of some kind.

For instance it can cause mis-execution of logic where the compiler is
unaware that a value it loads is allowed to change - ie no 
READ_ONCE/WRITE_ONCE semantic.
"

> 
>> +
>> +	return owner == DMA_OWNER_NONE;
>> +}
>> +EXPORT_SYMBOL_GPL(iommu_group_dma_owner_unclaimed);

Best regards,
baolu
