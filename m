Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9A4482329AC
	for <lists+kvm@lfdr.de>; Thu, 30 Jul 2020 03:51:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726932AbgG3Bvt (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 29 Jul 2020 21:51:49 -0400
Received: from mga14.intel.com ([192.55.52.115]:37826 "EHLO mga14.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726319AbgG3Bvt (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 29 Jul 2020 21:51:49 -0400
IronPort-SDR: I6H8gqtjXqNXh+M8ktJFynhPJFW1UBlxGeaNX3OHJB9g/9dQv9twNbBcCrTwR8dPN9ZYBxCz97
 xga5TYUWraVw==
X-IronPort-AV: E=McAfee;i="6000,8403,9697"; a="150698831"
X-IronPort-AV: E=Sophos;i="5.75,412,1589266800"; 
   d="scan'208";a="150698831"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Jul 2020 18:51:48 -0700
IronPort-SDR: mT16C5NyPsxn9MJXNYqMS14s5QIUvuwtRvX/76esEFS1SspGL7kzTyn8n88de3vL1Hj02sl5kJ
 ipd+68EVbFPQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.75,412,1589266800"; 
   d="scan'208";a="394831078"
Received: from allen-box.sh.intel.com (HELO [10.239.159.139]) ([10.239.159.139])
  by fmsmga001.fm.intel.com with ESMTP; 29 Jul 2020 18:51:45 -0700
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
Subject: Re: [PATCH v3 1/4] iommu: Check IOMMU_DEV_FEAT_AUX feature in aux
 api's
To:     Alex Williamson <alex.williamson@redhat.com>
References: <20200714055703.5510-1-baolu.lu@linux.intel.com>
 <20200714055703.5510-2-baolu.lu@linux.intel.com>
 <20200729140343.2b7047b2@x1.home>
From:   Lu Baolu <baolu.lu@linux.intel.com>
Message-ID: <64c11e95-125a-0654-5a3a-2a2739f96d3a@linux.intel.com>
Date:   Thu, 30 Jul 2020 09:46:50 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20200729140343.2b7047b2@x1.home>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Alex,

On 7/30/20 4:03 AM, Alex Williamson wrote:
> On Tue, 14 Jul 2020 13:57:00 +0800
> Lu Baolu <baolu.lu@linux.intel.com> wrote:
> 
>> The iommu aux-domain api's work only when IOMMU_DEV_FEAT_AUX is enabled
>> for the device. Add this check to avoid misuse.
> 
> Shouldn't this really be the IOMMU driver's responsibility to test?  If
> nothing else, iommu_dev_feature_enabled() needs to get the iommu_ops
> from dev->bus->iommu_ops, which is presumably the same iommu_ops we're
> then calling from domain->ops to attach/detach the device, so it'd be
> more efficient for the IOMMU driver to error on devices that don't
> support aux.  Thanks,

Fair enough. The vendor iommu driver always knows the status of aux-
domain support. So this check is duplicated. I will drop this patch.

Best regards,
baolu

> 
> Alex
> 
>> Signed-off-by: Lu Baolu <baolu.lu@linux.intel.com>
>> ---
>>   drivers/iommu/iommu.c | 16 +++++++++-------
>>   1 file changed, 9 insertions(+), 7 deletions(-)
>>
>> diff --git a/drivers/iommu/iommu.c b/drivers/iommu/iommu.c
>> index 1ed1e14a1f0c..e1fdd3531d65 100644
>> --- a/drivers/iommu/iommu.c
>> +++ b/drivers/iommu/iommu.c
>> @@ -2725,11 +2725,13 @@ EXPORT_SYMBOL_GPL(iommu_dev_feature_enabled);
>>    */
>>   int iommu_aux_attach_device(struct iommu_domain *domain, struct device *dev)
>>   {
>> -	int ret = -ENODEV;
>> +	int ret;
>>   
>> -	if (domain->ops->aux_attach_dev)
>> -		ret = domain->ops->aux_attach_dev(domain, dev);
>> +	if (!iommu_dev_feature_enabled(dev, IOMMU_DEV_FEAT_AUX) ||
>> +	    !domain->ops->aux_attach_dev)
>> +		return -ENODEV;
>>   
>> +	ret = domain->ops->aux_attach_dev(domain, dev);
>>   	if (!ret)
>>   		trace_attach_device_to_domain(dev);
>>   
>> @@ -2748,12 +2750,12 @@ EXPORT_SYMBOL_GPL(iommu_aux_detach_device);
>>   
>>   int iommu_aux_get_pasid(struct iommu_domain *domain, struct device *dev)
>>   {
>> -	int ret = -ENODEV;
>> +	if (!iommu_dev_feature_enabled(dev, IOMMU_DEV_FEAT_AUX) ||
>> +	    !domain->ops->aux_get_pasid)
>> +		return -ENODEV;
>>   
>> -	if (domain->ops->aux_get_pasid)
>> -		ret = domain->ops->aux_get_pasid(domain, dev);
>> +	return domain->ops->aux_get_pasid(domain, dev);
>>   
>> -	return ret;
>>   }
>>   EXPORT_SYMBOL_GPL(iommu_aux_get_pasid);
>>   
> 
