Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 44320239D77
	for <lists+kvm@lfdr.de>; Mon,  3 Aug 2020 04:20:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726321AbgHCCUb (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 2 Aug 2020 22:20:31 -0400
Received: from mga07.intel.com ([134.134.136.100]:64772 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725820AbgHCCUb (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 2 Aug 2020 22:20:31 -0400
IronPort-SDR: E42l+X6uc+x0susDBFNWFK1kuROhbRZF3kO2BaTfxeNNloQqv4jHWftIJG0Q3JNns724cmMvkf
 3qegQIiWCppQ==
X-IronPort-AV: E=McAfee;i="6000,8403,9701"; a="216461700"
X-IronPort-AV: E=Sophos;i="5.75,428,1589266800"; 
   d="scan'208";a="216461700"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Aug 2020 19:20:29 -0700
IronPort-SDR: qBWMv2KDbNwROoK6QxaoQTKg3p7yCiwqOsxCFMDmeLzSALxSB3YfchntlexrlpC10igfhQ/2Jw
 Jb+scsqpJqsQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.75,428,1589266800"; 
   d="scan'208";a="395909209"
Received: from allen-box.sh.intel.com (HELO [10.239.159.139]) ([10.239.159.139])
  by fmsmga001.fm.intel.com with ESMTP; 02 Aug 2020 19:20:26 -0700
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
 <06fd91c1-a978-d526-7e2b-fec619a458e4@linux.intel.com>
 <20200731121418.0274afb8@x1.home>
From:   Lu Baolu <baolu.lu@linux.intel.com>
Message-ID: <3fd171a2-a5cc-89d7-f539-04eb2faf130f@linux.intel.com>
Date:   Mon, 3 Aug 2020 10:15:27 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20200731121418.0274afb8@x1.home>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Alex,

On 8/1/20 2:14 AM, Alex Williamson wrote:
> On Fri, 31 Jul 2020 14:30:03 +0800
> Lu Baolu <baolu.lu@linux.intel.com> wrote:
> 
>> Hi Alex,
>>
>> On 2020/7/30 4:25, Alex Williamson wrote:
>>> On Tue, 14 Jul 2020 13:57:02 +0800
>>> Lu Baolu<baolu.lu@linux.intel.com>  wrote:
>>>    
>>>> The device driver needs an API to get its aux-domain. A typical usage
>>>> scenario is:
>>>>
>>>>           unsigned long pasid;
>>>>           struct iommu_domain *domain;
>>>>           struct device *dev = mdev_dev(mdev);
>>>>           struct device *iommu_device = vfio_mdev_get_iommu_device(dev);
>>>>
>>>>           domain = iommu_aux_get_domain_for_dev(dev);
>>>>           if (!domain)
>>>>                   return -ENODEV;
>>>>
>>>>           pasid = iommu_aux_get_pasid(domain, iommu_device);
>>>>           if (pasid <= 0)
>>>>                   return -EINVAL;
>>>>
>>>>            /* Program the device context */
>>>>            ....
>>>>
>>>> This adds an API for such use case.
>>>>
>>>> Suggested-by: Alex Williamson<alex.williamson@redhat.com>
>>>> Signed-off-by: Lu Baolu<baolu.lu@linux.intel.com>
>>>> ---
>>>>    drivers/iommu/iommu.c | 18 ++++++++++++++++++
>>>>    include/linux/iommu.h |  7 +++++++
>>>>    2 files changed, 25 insertions(+)
>>>>
>>>> diff --git a/drivers/iommu/iommu.c b/drivers/iommu/iommu.c
>>>> index cad5a19ebf22..434bf42b6b9b 100644
>>>> --- a/drivers/iommu/iommu.c
>>>> +++ b/drivers/iommu/iommu.c
>>>> @@ -2817,6 +2817,24 @@ void iommu_aux_detach_group(struct iommu_domain *domain,
>>>>    }
>>>>    EXPORT_SYMBOL_GPL(iommu_aux_detach_group);
>>>>    
>>>> +struct iommu_domain *iommu_aux_get_domain_for_dev(struct device *dev)
>>>> +{
>>>> +	struct iommu_domain *domain = NULL;
>>>> +	struct iommu_group *group;
>>>> +
>>>> +	group = iommu_group_get(dev);
>>>> +	if (!group)
>>>> +		return NULL;
>>>> +
>>>> +	if (group->aux_domain_attached)
>>>> +		domain = group->domain;
>>> Why wouldn't the aux domain flag be on the domain itself rather than
>>> the group?  Then if we wanted sanity checking in patch 1/ we'd only
>>> need to test the flag on the object we're provided.
>>
>> Agreed. Given that a group may contain both non-aux and aux devices,
>> adding such flag in iommu_group doesn't make sense.
>>
>>>
>>> If we had such a flag, we could create an iommu_domain_is_aux()
>>> function and then simply use iommu_get_domain_for_dev() and test that
>>> it's an aux domain in the example use case.  It seems like that would
>>> resolve the jump from a domain to an aux-domain just as well as adding
>>> this separate iommu_aux_get_domain_for_dev() interface.  The is_aux
>>> test might also be useful in other cases too.
>>
>> Let's rehearsal our use case.
>>
>>           unsigned long pasid;
>>           struct iommu_domain *domain;
>>           struct device *dev = mdev_dev(mdev);
>>           struct device *iommu_device = vfio_mdev_get_iommu_device(dev);
>>
>> [1]     domain = iommu_get_domain_for_dev(dev);
>>           if (!domain)
>>                   return -ENODEV;
>>
>> [2]     pasid = iommu_aux_get_pasid(domain, iommu_device);
>>           if (pasid <= 0)
>>                   return -EINVAL;
>>
>>            /* Program the device context */
>>            ....
>>
>> The reason why I add this iommu_aux_get_domain_for_dev() is that we need
>> to make sure the domain got at [1] is valid to be used at [2].
>>
>> https://lore.kernel.org/linux-iommu/20200707150408.474d81f1@x1.home/
> 
> Yep, I thought that was a bit of a leap in logic.
> 
>> When calling into iommu_aux_get_pasid(), the iommu driver should make
>> sure that @domain is a valid aux-domain for @iommu_device. Hence, for
>> our use case, it seems that there's no need for a is_aux_domain() api.
>>
>> Anyway, I'm not against adding a new is_aux_domain() api if there's a
>> need elsewhere.
> 
> I think it could work either way, we could have an
> iommu_get_aux_domain_for_dev() which returns NULL if the domain is not
> an aux domain, or we could use iommu_get_domain_for_dev() and the
> caller could test the domain with iommu_is_aux_domain() if they need to
> confirm if it's an aux domain.  The former could even be written using
> the latter, a wrapper of iommu_get_domain_for_dev() that checks aux
> property before returning.

Okay. So iommu_get_domain_for_dev() and iommu_is_aux_domain() are what
we wanted. The iommu_get_domain_for_dev() could be a simple wrapper of
them.

Thanks a lot for the guide. I will implement a new version according to
the feedbacks.

Best regards,
baolu
