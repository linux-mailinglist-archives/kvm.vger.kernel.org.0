Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5DCA3220187
	for <lists+kvm@lfdr.de>; Wed, 15 Jul 2020 02:52:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727086AbgGOAwS (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 14 Jul 2020 20:52:18 -0400
Received: from mga01.intel.com ([192.55.52.88]:45873 "EHLO mga01.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726945AbgGOAwS (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 14 Jul 2020 20:52:18 -0400
IronPort-SDR: YOcMRjkm70L7UG+T+Z2Gvp6TA+w+7VYE+v1Vd7bjXmXsO7CTS0cahZTGdXPjj0WSRB2SynQIwA
 uUzQwNJ3Yrgw==
X-IronPort-AV: E=McAfee;i="6000,8403,9682"; a="167172993"
X-IronPort-AV: E=Sophos;i="5.75,353,1589266800"; 
   d="scan'208";a="167172993"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Jul 2020 17:52:16 -0700
IronPort-SDR: uhH6lET2YrhupXWXMzYx7R/jUmdJmYQ7JIo1C7WeccSnrlffgZt3YYJCEeUD5ZwxTuQehJiY1N
 PUcBc0Tyq3fQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.75,353,1589266800"; 
   d="scan'208";a="459888717"
Received: from allen-box.sh.intel.com (HELO [10.239.159.139]) ([10.239.159.139])
  by orsmga005.jf.intel.com with ESMTP; 14 Jul 2020 17:52:13 -0700
Cc:     baolu.lu@linux.intel.com, Joerg Roedel <joro@8bytes.org>,
        Alex Williamson <alex.williamson@redhat.com>,
        Jean-Philippe Brucker <jean-philippe@linaro.org>,
        Kevin Tian <kevin.tian@intel.com>,
        Dave Jiang <dave.jiang@intel.com>,
        Ashok Raj <ashok.raj@intel.com>, kvm@vger.kernel.org,
        Cornelia Huck <cohuck@redhat.com>,
        linux-kernel@vger.kernel.org, iommu@lists.linux-foundation.org,
        Robin Murphy <robin.murphy@arm.com>
Subject: Re: [PATCH v3 2/4] iommu: Add iommu_aux_at(de)tach_group()
To:     Jacob Pan <jacob.jun.pan@linux.intel.com>
References: <20200714055703.5510-1-baolu.lu@linux.intel.com>
 <20200714055703.5510-3-baolu.lu@linux.intel.com>
 <20200714093909.1ab93c9e@jacob-builder>
From:   Lu Baolu <baolu.lu@linux.intel.com>
Message-ID: <b5b22e01-4a51-8dfe-9ba4-aeca783740f1@linux.intel.com>
Date:   Wed, 15 Jul 2020 08:47:36 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.8.0
MIME-Version: 1.0
In-Reply-To: <20200714093909.1ab93c9e@jacob-builder>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Jacob,

On 7/15/20 12:39 AM, Jacob Pan wrote:
> On Tue, 14 Jul 2020 13:57:01 +0800
> Lu Baolu<baolu.lu@linux.intel.com>  wrote:
> 
>> This adds two new aux-domain APIs for a use case like vfio/mdev where
>> sub-devices derived from an aux-domain capable device are created and
>> put in an iommu_group.
>>
>> /**
>>   * iommu_aux_attach_group - attach an aux-domain to an iommu_group
>> which
>>   *                          contains sub-devices (for example mdevs)
>> derived
>>   *                          from @dev.
>>   * @domain: an aux-domain;
>>   * @group:  an iommu_group which contains sub-devices derived from
>> @dev;
>>   * @dev:    the physical device which supports IOMMU_DEV_FEAT_AUX.
>>   *
>>   * Returns 0 on success, or an error value.
>>   */
>> int iommu_aux_attach_group(struct iommu_domain *domain,
>>                             struct iommu_group *group,
>>                             struct device *dev)
>>
>> /**
>>   * iommu_aux_detach_group - detach an aux-domain from an iommu_group
>>   *
>>   * @domain: an aux-domain;
>>   * @group:  an iommu_group which contains sub-devices derived from
>> @dev;
>>   * @dev:    the physical device which supports IOMMU_DEV_FEAT_AUX.
>>   *
>>   * @domain must have been attached to @group via
>> iommu_aux_attach_group(). */
>> void iommu_aux_detach_group(struct iommu_domain *domain,
>>                              struct iommu_group *group,
>>                              struct device *dev)
>>
>> It also adds a flag in the iommu_group data structure to identify
>> an iommu_group with aux-domain attached from those normal ones.
>>
>> Signed-off-by: Lu Baolu<baolu.lu@linux.intel.com>
>> ---
>>   drivers/iommu/iommu.c | 58
>> +++++++++++++++++++++++++++++++++++++++++++ include/linux/iommu.h |
>> 17 +++++++++++++ 2 files changed, 75 insertions(+)
>>
>> diff --git a/drivers/iommu/iommu.c b/drivers/iommu/iommu.c
>> index e1fdd3531d65..cad5a19ebf22 100644
>> --- a/drivers/iommu/iommu.c
>> +++ b/drivers/iommu/iommu.c
>> @@ -45,6 +45,7 @@ struct iommu_group {
>>   	struct iommu_domain *default_domain;
>>   	struct iommu_domain *domain;
>>   	struct list_head entry;
>> +	unsigned int aux_domain_attached:1;
>>   };
>>   
>>   struct group_device {
>> @@ -2759,6 +2760,63 @@ int iommu_aux_get_pasid(struct iommu_domain
>> *domain, struct device *dev) }
>>   EXPORT_SYMBOL_GPL(iommu_aux_get_pasid);
>>   
>> +/**
>> + * iommu_aux_attach_group - attach an aux-domain to an iommu_group
>> which
>> + *                          contains sub-devices (for example mdevs)
>> derived
>> + *                          from @dev.
>> + * @domain: an aux-domain;
>> + * @group:  an iommu_group which contains sub-devices derived from
>> @dev;
>> + * @dev:    the physical device which supports IOMMU_DEV_FEAT_AUX.
>> + *
>> + * Returns 0 on success, or an error value.
>> + */
>> +int iommu_aux_attach_group(struct iommu_domain *domain,
>> +			   struct iommu_group *group, struct device
>> *dev) +{
>> +	int ret = -EBUSY;
>> +
>> +	mutex_lock(&group->mutex);
>> +	if (group->domain)
>> +		goto out_unlock;
>> +
> Perhaps I missed something but are we assuming only one mdev per mdev
> group? That seems to change the logic where vfio does:
> iommu_group_for_each_dev()
> 	iommu_aux_attach_device()
> 

It has been changed in PATCH 4/4:

static int vfio_iommu_attach_group(struct vfio_domain *domain,
                                    struct vfio_group *group)
{
         if (group->mdev_group)
                 return iommu_aux_attach_group(domain->domain,
                                               group->iommu_group,
                                               group->iommu_device);
         else
                 return iommu_attach_group(domain->domain, 
group->iommu_group);
}

So, for both normal domain and aux-domain, we use the same concept:
attach a domain to a group.

Best regards,
baolu
