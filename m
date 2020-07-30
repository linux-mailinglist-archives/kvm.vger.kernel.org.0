Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A75FF232A29
	for <lists+kvm@lfdr.de>; Thu, 30 Jul 2020 04:46:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727008AbgG3Cqb (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 29 Jul 2020 22:46:31 -0400
Received: from mga06.intel.com ([134.134.136.31]:41718 "EHLO mga06.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726319AbgG3Cqb (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 29 Jul 2020 22:46:31 -0400
IronPort-SDR: oAB8JHGA3wWyT+VPQxsR3nu6HH7gaD2NYzrJMTh6GgKF847aJQYRV/ERCBvb80juJA6gBzB2R2
 a3Uq49UW7mlQ==
X-IronPort-AV: E=McAfee;i="6000,8403,9697"; a="213064114"
X-IronPort-AV: E=Sophos;i="5.75,412,1589266800"; 
   d="scan'208";a="213064114"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Jul 2020 19:46:30 -0700
IronPort-SDR: 0iJ7hBD9wyNkQ0O5ISSl6IT4NwwZIo8wpg/gAFopSKoJ5cAqj8JDZihqnOYhqnpMw7UrdG+sE+
 qJaypzmRJj9Q==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.75,412,1589266800"; 
   d="scan'208";a="394841270"
Received: from allen-box.sh.intel.com (HELO [10.239.159.139]) ([10.239.159.139])
  by fmsmga001.fm.intel.com with ESMTP; 29 Jul 2020 19:46:27 -0700
Cc:     baolu.lu@linux.intel.com, Joerg Roedel <joro@8bytes.org>,
        Robin Murphy <robin.murphy@arm.com>,
        Jean-Philippe Brucker <jean-philippe@linaro.org>,
        Cornelia Huck <cohuck@redhat.com>,
        Kevin Tian <kevin.tian@intel.com>,
        Ashok Raj <ashok.raj@intel.com>,
        Dave Jiang <dave.jiang@intel.com>,
        Liu Yi L <yi.l.liu@intel.com>,
        iommu@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org
Subject: Re: [PATCH v3 4/4] vfio/type1: Use iommu_aux_at(de)tach_group() APIs
To:     Alex Williamson <alex.williamson@redhat.com>
References: <20200714055703.5510-1-baolu.lu@linux.intel.com>
 <20200714055703.5510-5-baolu.lu@linux.intel.com>
 <20200729143258.22533170@x1.home>
From:   Lu Baolu <baolu.lu@linux.intel.com>
Message-ID: <af6c95a7-3238-1cbd-8656-014c12498587@linux.intel.com>
Date:   Thu, 30 Jul 2020 10:41:32 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20200729143258.22533170@x1.home>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Alex,

On 7/30/20 4:32 AM, Alex Williamson wrote:
> On Tue, 14 Jul 2020 13:57:03 +0800
> Lu Baolu <baolu.lu@linux.intel.com> wrote:
> 
>> Replace iommu_aux_at(de)tach_device() with iommu_aux_at(de)tach_group().
>> It also saves the IOMMU_DEV_FEAT_AUX-capable physcail device in the
>> vfio_group data structure so that it could be reused in other places.
>>
>> Signed-off-by: Lu Baolu <baolu.lu@linux.intel.com>
>> ---
>>   drivers/vfio/vfio_iommu_type1.c | 44 ++++++---------------------------
>>   1 file changed, 7 insertions(+), 37 deletions(-)
>>
>> diff --git a/drivers/vfio/vfio_iommu_type1.c b/drivers/vfio/vfio_iommu_type1.c
>> index 5e556ac9102a..f8812e68de77 100644
>> --- a/drivers/vfio/vfio_iommu_type1.c
>> +++ b/drivers/vfio/vfio_iommu_type1.c
>> @@ -100,6 +100,7 @@ struct vfio_dma {
>>   struct vfio_group {
>>   	struct iommu_group	*iommu_group;
>>   	struct list_head	next;
>> +	struct device		*iommu_device;
>>   	bool			mdev_group;	/* An mdev group */
>>   	bool			pinned_page_dirty_scope;
>>   };
>> @@ -1627,45 +1628,13 @@ static struct device *vfio_mdev_get_iommu_device(struct device *dev)
>>   	return NULL;
>>   }
>>   
>> -static int vfio_mdev_attach_domain(struct device *dev, void *data)
>> -{
>> -	struct iommu_domain *domain = data;
>> -	struct device *iommu_device;
>> -
>> -	iommu_device = vfio_mdev_get_iommu_device(dev);
>> -	if (iommu_device) {
>> -		if (iommu_dev_feature_enabled(iommu_device, IOMMU_DEV_FEAT_AUX))
>> -			return iommu_aux_attach_device(domain, iommu_device);
>> -		else
>> -			return iommu_attach_device(domain, iommu_device);
>> -	}
>> -
>> -	return -EINVAL;
>> -}
>> -
>> -static int vfio_mdev_detach_domain(struct device *dev, void *data)
>> -{
>> -	struct iommu_domain *domain = data;
>> -	struct device *iommu_device;
>> -
>> -	iommu_device = vfio_mdev_get_iommu_device(dev);
>> -	if (iommu_device) {
>> -		if (iommu_dev_feature_enabled(iommu_device, IOMMU_DEV_FEAT_AUX))
>> -			iommu_aux_detach_device(domain, iommu_device);
>> -		else
>> -			iommu_detach_device(domain, iommu_device);
>> -	}
>> -
>> -	return 0;
>> -}
>> -
>>   static int vfio_iommu_attach_group(struct vfio_domain *domain,
>>   				   struct vfio_group *group)
>>   {
>>   	if (group->mdev_group)
>> -		return iommu_group_for_each_dev(group->iommu_group,
>> -						domain->domain,
>> -						vfio_mdev_attach_domain);
>> +		return iommu_aux_attach_group(domain->domain,
>> +					      group->iommu_group,
>> +					      group->iommu_device);
> 
> No, we previously iterated all devices in the group and used the aux
> interface only when we have an iommu_device supporting aux.  If we
> simply assume an mdev group only uses an aux domain we break existing
> users, ex. SR-IOV VF backed mdevs.  Thanks,

Oh, yes. Sorry! I didn't consider the physical device backed mdevs
cases.

Looked into this part of code, it seems that there's a lock issue here.
The group->mutex is held in iommu_group_for_each_dev() and will be
acquired again in iommu_attach_device().

How about making it like:

static int vfio_iommu_attach_group(struct vfio_domain *domain,
                                    struct vfio_group *group)
{
         if (group->mdev_group) {
                 struct device *iommu_device = group->iommu_device;

                 if (WARN_ON(!iommu_device))
                         return -EINVAL;

                 if (iommu_dev_feature_enabled(iommu_device, 
IOMMU_DEV_FEAT_AUX))
                         return iommu_aux_attach_device(domain->domain, 
iommu_device);
                 else
                         return iommu_attach_device(domain->domain, 
iommu_device);
         } else {
                 return iommu_attach_group(domain->domain, 
group->iommu_group);
         }
}

The caller (vfio_iommu_type1_attach_group) has guaranteed that all mdevs
in an iommu group should be derived from a same physical device.

Any thoughts?

> 
> Alex

Best regards,
baolu

> 
> 
>>   	else
>>   		return iommu_attach_group(domain->domain, group->iommu_group);
>>   }
>> @@ -1674,8 +1643,8 @@ static void vfio_iommu_detach_group(struct vfio_domain *domain,
>>   				    struct vfio_group *group)
>>   {
>>   	if (group->mdev_group)
>> -		iommu_group_for_each_dev(group->iommu_group, domain->domain,
>> -					 vfio_mdev_detach_domain);
>> +		iommu_aux_detach_group(domain->domain, group->iommu_group,
>> +				       group->iommu_device);
>>   	else
>>   		iommu_detach_group(domain->domain, group->iommu_group);
>>   }
>> @@ -2007,6 +1976,7 @@ static int vfio_iommu_type1_attach_group(void *iommu_data,
>>   			return 0;
>>   		}
>>   
>> +		group->iommu_device = iommu_device;
>>   		bus = iommu_device->bus;
>>   	}
>>   
> 
