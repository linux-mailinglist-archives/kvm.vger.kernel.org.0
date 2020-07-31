Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B97B5233F1C
	for <lists+kvm@lfdr.de>; Fri, 31 Jul 2020 08:30:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731398AbgGaGaN (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 31 Jul 2020 02:30:13 -0400
Received: from mga04.intel.com ([192.55.52.120]:4982 "EHLO mga04.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731351AbgGaGaM (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 31 Jul 2020 02:30:12 -0400
IronPort-SDR: 8HyRPrYh1AVKywSXyjvIpkuHMZ3NFqTzfjFtBI+PG/9qPh11XTP0NAasCj7/4tn57O838F0UvK
 +kom63vbr/7g==
X-IronPort-AV: E=McAfee;i="6000,8403,9698"; a="149203168"
X-IronPort-AV: E=Sophos;i="5.75,417,1589266800"; 
   d="scan'208";a="149203168"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Jul 2020 23:30:08 -0700
IronPort-SDR: zX0i7UjX9khEP8dd1fClb0ZgGv4jktjUAWeeAPNWqdnllhKOSoYF4zKfKXMGsBk6HaRnhUzDgA
 XHE5s3SdIx7g==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.75,417,1589266800"; 
   d="scan'208";a="321320272"
Received: from daisygao-mobl.ccr.corp.intel.com (HELO [10.254.211.68]) ([10.254.211.68])
  by orsmga008.jf.intel.com with ESMTP; 30 Jul 2020 23:30:04 -0700
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
Subject: Re: [PATCH v3 3/4] iommu: Add iommu_aux_get_domain_for_dev()
To:     Alex Williamson <alex.williamson@redhat.com>
References: <20200714055703.5510-1-baolu.lu@linux.intel.com>
 <20200714055703.5510-4-baolu.lu@linux.intel.com>
 <20200729142507.182cd18a@x1.home>
From:   Lu Baolu <baolu.lu@linux.intel.com>
Message-ID: <06fd91c1-a978-d526-7e2b-fec619a458e4@linux.intel.com>
Date:   Fri, 31 Jul 2020 14:30:03 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20200729142507.182cd18a@x1.home>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Alex,

On 2020/7/30 4:25, Alex Williamson wrote:
> On Tue, 14 Jul 2020 13:57:02 +0800
> Lu Baolu<baolu.lu@linux.intel.com>  wrote:
> 
>> The device driver needs an API to get its aux-domain. A typical usage
>> scenario is:
>>
>>          unsigned long pasid;
>>          struct iommu_domain *domain;
>>          struct device *dev = mdev_dev(mdev);
>>          struct device *iommu_device = vfio_mdev_get_iommu_device(dev);
>>
>>          domain = iommu_aux_get_domain_for_dev(dev);
>>          if (!domain)
>>                  return -ENODEV;
>>
>>          pasid = iommu_aux_get_pasid(domain, iommu_device);
>>          if (pasid <= 0)
>>                  return -EINVAL;
>>
>>           /* Program the device context */
>>           ....
>>
>> This adds an API for such use case.
>>
>> Suggested-by: Alex Williamson<alex.williamson@redhat.com>
>> Signed-off-by: Lu Baolu<baolu.lu@linux.intel.com>
>> ---
>>   drivers/iommu/iommu.c | 18 ++++++++++++++++++
>>   include/linux/iommu.h |  7 +++++++
>>   2 files changed, 25 insertions(+)
>>
>> diff --git a/drivers/iommu/iommu.c b/drivers/iommu/iommu.c
>> index cad5a19ebf22..434bf42b6b9b 100644
>> --- a/drivers/iommu/iommu.c
>> +++ b/drivers/iommu/iommu.c
>> @@ -2817,6 +2817,24 @@ void iommu_aux_detach_group(struct iommu_domain *domain,
>>   }
>>   EXPORT_SYMBOL_GPL(iommu_aux_detach_group);
>>   
>> +struct iommu_domain *iommu_aux_get_domain_for_dev(struct device *dev)
>> +{
>> +	struct iommu_domain *domain = NULL;
>> +	struct iommu_group *group;
>> +
>> +	group = iommu_group_get(dev);
>> +	if (!group)
>> +		return NULL;
>> +
>> +	if (group->aux_domain_attached)
>> +		domain = group->domain;
> Why wouldn't the aux domain flag be on the domain itself rather than
> the group?  Then if we wanted sanity checking in patch 1/ we'd only
> need to test the flag on the object we're provided.

Agreed. Given that a group may contain both non-aux and aux devices,
adding such flag in iommu_group doesn't make sense.

> 
> If we had such a flag, we could create an iommu_domain_is_aux()
> function and then simply use iommu_get_domain_for_dev() and test that
> it's an aux domain in the example use case.  It seems like that would
> resolve the jump from a domain to an aux-domain just as well as adding
> this separate iommu_aux_get_domain_for_dev() interface.  The is_aux
> test might also be useful in other cases too.

Let's rehearsal our use case.

         unsigned long pasid;
         struct iommu_domain *domain;
         struct device *dev = mdev_dev(mdev);
         struct device *iommu_device = vfio_mdev_get_iommu_device(dev);

[1]     domain = iommu_get_domain_for_dev(dev);
         if (!domain)
                 return -ENODEV;

[2]     pasid = iommu_aux_get_pasid(domain, iommu_device);
         if (pasid <= 0)
                 return -EINVAL;

          /* Program the device context */
          ....

The reason why I add this iommu_aux_get_domain_for_dev() is that we need
to make sure the domain got at [1] is valid to be used at [2].

https://lore.kernel.org/linux-iommu/20200707150408.474d81f1@x1.home/

When calling into iommu_aux_get_pasid(), the iommu driver should make
sure that @domain is a valid aux-domain for @iommu_device. Hence, for
our use case, it seems that there's no need for a is_aux_domain() api.

Anyway, I'm not against adding a new is_aux_domain() api if there's a
need elsewhere.

Best regards,
baolu
