Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 32F49233CF8
	for <lists+kvm@lfdr.de>; Fri, 31 Jul 2020 03:43:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731152AbgGaBnE (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 30 Jul 2020 21:43:04 -0400
Received: from mga05.intel.com ([192.55.52.43]:2827 "EHLO mga05.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731117AbgGaBmw (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 30 Jul 2020 21:42:52 -0400
IronPort-SDR: SxvUoYKdax5X9AfLlU1H9b5hghdhW8kJrW14XIOu7JnNws3+9gtq2UGmPMe/bRtvITDflEd4WN
 y3FSCSFhsckQ==
X-IronPort-AV: E=McAfee;i="6000,8403,9698"; a="236583891"
X-IronPort-AV: E=Sophos;i="5.75,416,1589266800"; 
   d="scan'208";a="236583891"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Jul 2020 18:42:51 -0700
IronPort-SDR: baMEzDWRkgxeQuoFC0ybDsUEFaxwWr9nxeCh/3VHi+mgCilOH1oafwKyMbMVumsNmjAqaPVQ+l
 EHJVYFGGSXFw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.75,416,1589266800"; 
   d="scan'208";a="395179041"
Received: from allen-box.sh.intel.com (HELO [10.239.159.139]) ([10.239.159.139])
  by fmsmga001.fm.intel.com with ESMTP; 30 Jul 2020 18:42:48 -0700
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
 <af6c95a7-3238-1cbd-8656-014c12498587@linux.intel.com>
 <20200730151703.5daf8ad4@x1.home>
From:   Lu Baolu <baolu.lu@linux.intel.com>
Message-ID: <7caa6533-b980-8135-6dba-2aac5b0bb23f@linux.intel.com>
Date:   Fri, 31 Jul 2020 09:37:52 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20200730151703.5daf8ad4@x1.home>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Alex,

On 7/31/20 5:17 AM, Alex Williamson wrote:
> On Thu, 30 Jul 2020 10:41:32 +0800
> Lu Baolu <baolu.lu@linux.intel.com> wrote:
> 
>> Hi Alex,
>>
>> On 7/30/20 4:32 AM, Alex Williamson wrote:
>>> On Tue, 14 Jul 2020 13:57:03 +0800
>>> Lu Baolu <baolu.lu@linux.intel.com> wrote:
>>>    
>>>> Replace iommu_aux_at(de)tach_device() with iommu_aux_at(de)tach_group().
>>>> It also saves the IOMMU_DEV_FEAT_AUX-capable physcail device in the
>>>> vfio_group data structure so that it could be reused in other places.
>>>>
>>>> Signed-off-by: Lu Baolu <baolu.lu@linux.intel.com>
>>>> ---
>>>>    drivers/vfio/vfio_iommu_type1.c | 44 ++++++---------------------------
>>>>    1 file changed, 7 insertions(+), 37 deletions(-)
>>>>
>>>> diff --git a/drivers/vfio/vfio_iommu_type1.c b/drivers/vfio/vfio_iommu_type1.c
>>>> index 5e556ac9102a..f8812e68de77 100644
>>>> --- a/drivers/vfio/vfio_iommu_type1.c
>>>> +++ b/drivers/vfio/vfio_iommu_type1.c
>>>> @@ -100,6 +100,7 @@ struct vfio_dma {
>>>>    struct vfio_group {
>>>>    	struct iommu_group	*iommu_group;
>>>>    	struct list_head	next;
>>>> +	struct device		*iommu_device;
>>>>    	bool			mdev_group;	/* An mdev group */
>>>>    	bool			pinned_page_dirty_scope;
>>>>    };
>>>> @@ -1627,45 +1628,13 @@ static struct device *vfio_mdev_get_iommu_device(struct device *dev)
>>>>    	return NULL;
>>>>    }
>>>>    
>>>> -static int vfio_mdev_attach_domain(struct device *dev, void *data)
>>>> -{
>>>> -	struct iommu_domain *domain = data;
>>>> -	struct device *iommu_device;
>>>> -
>>>> -	iommu_device = vfio_mdev_get_iommu_device(dev);
>>>> -	if (iommu_device) {
>>>> -		if (iommu_dev_feature_enabled(iommu_device, IOMMU_DEV_FEAT_AUX))
>>>> -			return iommu_aux_attach_device(domain, iommu_device);
>>>> -		else
>>>> -			return iommu_attach_device(domain, iommu_device);
>>>> -	}
>>>> -
>>>> -	return -EINVAL;
>>>> -}
>>>> -
>>>> -static int vfio_mdev_detach_domain(struct device *dev, void *data)
>>>> -{
>>>> -	struct iommu_domain *domain = data;
>>>> -	struct device *iommu_device;
>>>> -
>>>> -	iommu_device = vfio_mdev_get_iommu_device(dev);
>>>> -	if (iommu_device) {
>>>> -		if (iommu_dev_feature_enabled(iommu_device, IOMMU_DEV_FEAT_AUX))
>>>> -			iommu_aux_detach_device(domain, iommu_device);
>>>> -		else
>>>> -			iommu_detach_device(domain, iommu_device);
>>>> -	}
>>>> -
>>>> -	return 0;
>>>> -}
>>>> -
>>>>    static int vfio_iommu_attach_group(struct vfio_domain *domain,
>>>>    				   struct vfio_group *group)
>>>>    {
>>>>    	if (group->mdev_group)
>>>> -		return iommu_group_for_each_dev(group->iommu_group,
>>>> -						domain->domain,
>>>> -						vfio_mdev_attach_domain);
>>>> +		return iommu_aux_attach_group(domain->domain,
>>>> +					      group->iommu_group,
>>>> +					      group->iommu_device);
>>>
>>> No, we previously iterated all devices in the group and used the aux
>>> interface only when we have an iommu_device supporting aux.  If we
>>> simply assume an mdev group only uses an aux domain we break existing
>>> users, ex. SR-IOV VF backed mdevs.  Thanks,
>>
>> Oh, yes. Sorry! I didn't consider the physical device backed mdevs
>> cases.
>>
>> Looked into this part of code, it seems that there's a lock issue here.
>> The group->mutex is held in iommu_group_for_each_dev() and will be
>> acquired again in iommu_attach_device().
> 
> These are two different groups.  We walk the devices in the mdev's
> group with iommu_group_for_each_dev(), holding the mdev's group lock,
> but we call iommu_attach_device() with iommu_device, which results in
> acquiring the lock for the iommu_device's group.

You are right. Sorry for the noise. Please ignore it.

> 
>> How about making it like:
>>
>> static int vfio_iommu_attach_group(struct vfio_domain *domain,
>>                                      struct vfio_group *group)
>> {
>>           if (group->mdev_group) {
>>                   struct device *iommu_device = group->iommu_device;
>>
>>                   if (WARN_ON(!iommu_device))
>>                           return -EINVAL;
>>
>>                   if (iommu_dev_feature_enabled(iommu_device,
>> IOMMU_DEV_FEAT_AUX))
>>                           return iommu_aux_attach_device(domain->domain,
>> iommu_device);
>>                   else
>>                           return iommu_attach_device(domain->domain,
>> iommu_device);
>>           } else {
>>                   return iommu_attach_group(domain->domain,
>> group->iommu_group);
>>           }
>> }
>>
>> The caller (vfio_iommu_type1_attach_group) has guaranteed that all mdevs
>> in an iommu group should be derived from a same physical device.
> 
> Have we?

We have done this with below.

static int vfio_mdev_iommu_device(struct device *dev, void *data)
{
         struct device **old = data, *new;

         new = vfio_mdev_get_iommu_device(dev);
         if (!new || (*old && *old != new))
                 return -EINVAL;

         *old = new;

         return 0;
}

But I agree that as a generic iommu aux-domain api, we shouldn't put
this limited assumption in it.

> iommu_attach_device() will fail if the group is not
> singleton, but that's just encouraging us to use the _attach_group()
> interface where the _attach_device() interface is relegated to special
> cases.  Ideally we'd get out of those special cases and create an
> _attach_group() for aux that doesn't further promote these notions.

Yes. Fair enough.

> 
>> Any thoughts?
> 
> See my reply to Kevin, I'm thinking we need to provide a callback that
> can enlighten the IOMMU layer to be able to do _attach_group() with
> aux or separate IOMMU backed devices.

Thanks for the guide. I will check your reply.

Best regards,
baolu
