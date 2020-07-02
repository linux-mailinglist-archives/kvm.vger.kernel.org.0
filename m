Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 03C0D2119AD
	for <lists+kvm@lfdr.de>; Thu,  2 Jul 2020 03:38:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728673AbgGBBg4 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 1 Jul 2020 21:36:56 -0400
Received: from mga05.intel.com ([192.55.52.43]:62645 "EHLO mga05.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728214AbgGBBgy (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 1 Jul 2020 21:36:54 -0400
IronPort-SDR: TZBpTelp9mVVdw+E83ac5/hjCpSkxuO9Vw4Xoa2JzKcoiA5H7Cnzh7AoDZU4+/hIfCITNTKtGH
 TQ+M5mWVzAug==
X-IronPort-AV: E=McAfee;i="6000,8403,9669"; a="231639030"
X-IronPort-AV: E=Sophos;i="5.75,302,1589266800"; 
   d="scan'208";a="231639030"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Jul 2020 18:36:46 -0700
IronPort-SDR: WkKQyRyyqk5ma2TxGzRlpWt9aUvcoXaeaKhhIOT8ecUHVr18IikLb5bXNbGzjSNv+vu2aYJSOH
 JT/Lsj+Ot3yw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.75,302,1589266800"; 
   d="scan'208";a="304068748"
Received: from allen-box.sh.intel.com (HELO [10.239.159.139]) ([10.239.159.139])
  by fmsmga004.fm.intel.com with ESMTP; 01 Jul 2020 18:36:44 -0700
Cc:     baolu.lu@linux.intel.com, Kevin Tian <kevin.tian@intel.com>,
        Dave Jiang <dave.jiang@intel.com>,
        Ashok Raj <ashok.raj@intel.com>, kvm@vger.kernel.org,
        Cornelia Huck <cohuck@redhat.com>,
        linux-kernel@vger.kernel.org, iommu@lists.linux-foundation.org
Subject: Re: [PATCH 1/2] iommu: Add iommu_group_get/set_domain()
To:     Robin Murphy <robin.murphy@arm.com>,
        Joerg Roedel <joro@8bytes.org>,
        Alex Williamson <alex.williamson@redhat.com>
References: <20200627031532.28046-1-baolu.lu@linux.intel.com>
 <acc0a8fd-bd23-fc34-aecc-67796ab216e7@arm.com>
 <5dc1cece-6111-9b56-d04c-9553d592675b@linux.intel.com>
 <48dd9f1e-c18b-77b7-650a-c35ecbb69f2b@arm.com>
 <c38784ad-9dba-0840-3a61-e2c21e781f1e@linux.intel.com>
 <ffbb405b-5617-5659-3fc1-302c530aceef@arm.com>
From:   Lu Baolu <baolu.lu@linux.intel.com>
Message-ID: <122f0e0a-5220-f00a-a329-6679d5aa8077@linux.intel.com>
Date:   Thu, 2 Jul 2020 09:32:20 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.8.0
MIME-Version: 1.0
In-Reply-To: <ffbb405b-5617-5659-3fc1-302c530aceef@arm.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hello,

On 7/1/20 8:18 PM, Robin Murphy wrote:
> On 2020-07-01 08:32, Lu Baolu wrote:
>> Hi Robin,
>>
>> On 2020/7/1 0:51, Robin Murphy wrote:
>>> On 2020-06-30 02:03, Lu Baolu wrote:
>>>> Hi Robin,
>>>>
>>>> On 6/29/20 7:56 PM, Robin Murphy wrote:
>>>>> On 2020-06-27 04:15, Lu Baolu wrote:
>>>>>> The hardware assistant vfio mediated device is a use case of iommu
>>>>>> aux-domain. The interactions between vfio/mdev and iommu during mdev
>>>>>> creation and passthr are:
>>>>>>
>>>>>> - Create a group for mdev with iommu_group_alloc();
>>>>>> - Add the device to the group with
>>>>>>          group = iommu_group_alloc();
>>>>>>          if (IS_ERR(group))
>>>>>>                  return PTR_ERR(group);
>>>>>>
>>>>>>          ret = iommu_group_add_device(group, &mdev->dev);
>>>>>>          if (!ret)
>>>>>>                  dev_info(&mdev->dev, "MDEV: group_id = %d\n",
>>>>>>                           iommu_group_id(group));
>>>>>> - Allocate an aux-domain
>>>>>>     iommu_domain_alloc()
>>>>>> - Attach the aux-domain to the physical device from which the mdev is
>>>>>>    created.
>>>>>>     iommu_aux_attach_device()
>>>>>>
>>>>>> In the whole process, an iommu group was allocated for the mdev 
>>>>>> and an
>>>>>> iommu domain was attached to the group, but the group->domain leaves
>>>>>> NULL. As the result, iommu_get_domain_for_dev() doesn't work anymore.
>>>>>>
>>>>>> This adds iommu_group_get/set_domain() so that group->domain could be
>>>>>> managed whenever a domain is attached or detached through the 
>>>>>> aux-domain
>>>>>> api's.
>>>>>
>>>>> Letting external callers poke around directly in the internals of 
>>>>> iommu_group doesn't look right to me.
>>>>
>>>> Unfortunately, it seems that the vifo iommu abstraction is deeply bound
>>>> to the IOMMU subsystem. We can easily find other examples:
>>>>
>>>> iommu_group_get/set_iommudata()
>>>> iommu_group_get/set_name()
>>>> ...
>>>
>>> Sure, but those are ways for users of a group to attach useful 
>>> information of their own to it, that doesn't matter to the IOMMU 
>>> subsystem itself. The interface you've proposed gives callers rich 
>>> new opportunities to fundamentally break correct operation of the API:
>>>
>>>      dom = iommu_domain_alloc();
>>>      iommu_attach_group(dom, grp);
>>>      ...
>>>      iommu_group_set_domain(grp, NULL);
>>>      // oops, leaked and can't ever detach properly now
>>>
>>> or perhaps:
>>>
>>>      grp = iommu_group_alloc();
>>>      iommu_group_add_device(grp, dev);
>>>      iommu_group_set_domain(grp, dom);
>>>      ...
>>>      iommu_detach_group(dom, grp);
>>>      // oops, IOMMU driver might not handle this
>>>
>>>>> If a regular device is attached to one or more aux domains for 
>>>>> PASID use, iommu_get_domain_for_dev() is still going to return the 
>>>>> primary domain, so why should it be expected to behave differently 
>>>>> for mediated
>>>>
>>>> Unlike the normal device attach, we will encounter two devices when it
>>>> comes to aux-domain.
>>>>
>>>> - Parent physical device - this might be, for example, a PCIe device
>>>> with PASID feature support, hence it is able to tag an unique PASID
>>>> for DMA transfers originated from its subset. The device driver hence
>>>> is able to wrapper this subset into an isolated:
>>>>
>>>> - Mediated device - a fake device created by the device driver 
>>>> mentioned
>>>> above.
>>>>
>>>> Yes. All you mentioned are right for the parent device. But for 
>>>> mediated
>>>> device, iommu_get_domain_for_dev() doesn't work even it has an valid
>>>> iommu_group and iommu_domain.
>>>>
>>>> iommu_get_domain_for_dev() is a necessary interface for device drivers
>>>> which want to support aux-domain. For example,
>>>
>>> Only if they want to follow this very specific notion of using 
>>> made-up devices and groups to represent aux attachments. Even if a 
>>> driver managing its own aux domains entirely privately does create 
>>> child devices for them, it's not like it can't keep its domain 
>>> pointers in drvdata if it wants to ;)
>>>
>>> Let's not conflate the current implementation of vfio_mdev with the 
>>> general concepts involved here.
>>>
>>>>            struct iommu_domain *domain;
>>>>            struct device *dev = mdev_dev(mdev);
>>>>        unsigned long pasid;
>>>>
>>>>            domain = iommu_get_domain_for_dev(dev);
>>>>            if (!domain)
>>>>                    return -ENODEV;
>>>>
>>>>            pasid = iommu_aux_get_pasid(domain, dev->parent);
>>>>        if (pasid == IOASID_INVALID)
>>>>            return -EINVAL;
>>>>
>>>>        /* Program the device context with the PASID value */
>>>>        ....
>>>>
>>>> Without this fix, iommu_get_domain_for_dev() always returns NULL and 
>>>> the
>>>> device driver has no means to support aux-domain.
>>>
>>> So either the IOMMU API itself is missing the ability to do the right 
>>> thing internally, or the mdev layer isn't using it appropriately. 
>>> Either way, simply punching holes in the API for mdev to hack around 
>>> its own mess doesn't seem like the best thing to do.
>>>
>>> The initial impression I got was that it's implicitly assumed here 
>>> that the mdev itself is attached to exactly one aux domain and 
>>> nothing else, at which point I would wonder why it's using aux at 
>>> all, but are you saying that in fact no attach happens with the mdev 
>>> group either way, only to the parent device?
>>>
>>> I'll admit I'm not hugely familiar with any of this, but it seems to 
>>> me that the logical flow should be:
>>>
>>>      - allocate domain
>>>      - attach as aux to parent
>>>      - retrieve aux domain PASID
>>>      - create mdev child based on PASID
>>>      - attach mdev to domain (normally)
>>>
>>> Of course that might require giving the IOMMU API a proper 
>>> first-class notion of mediated devices, such that it knows the mdev 
>>> represents the PASID, and can recognise the mdev attach is equivalent 
>>> to the earlier parent aux attach so not just blindly hand it down to 
>>> an IOMMU driver that's never heard of this new device before. Or 
>>> perhaps the IOMMU drivers do their own bookkeeping for the mdev bus, 
>>> such that they do handle the attach call, and just validate it 
>>> internally based on the associated parent device and PASID. Either 
>>> way, the inside maintains self-consistency and from the outside it 
>>> looks like standard API usage without nasty hacks.
>>>
>>> I'm pretty sure I've heard suggestions of using mediated devices 
>>> beyond VFIO (e.g. within the kernel itself), so chances are this is a 
>>> direction that we'll have to take at some point anyway.
>>>
>>> And, that said, even if people do want an immediate quick fix 
>>> regardless of technical debt, I'd still be a lot happier to see 
>>> iommu_group_set_domain() lightly respun as iommu_attach_mdev() ;)
>>
>> Get your point and I agree with your concerns.
>>
>> To maintain the relationship between mdev's iommu_group and
>> iommu_domain, how about extending below existing aux_attach api
>>
>> int iommu_aux_attach_device(struct iommu_domain *domain,
>>                  struct device *dev)
>>
>> by adding the mdev's iommu_group?
>>
>> int iommu_aux_attach_device(struct iommu_domain *domain,
>>                  struct device *dev,
>>                  struct iommu_group *group)
>>
>> And, in iommu_aux_attach_device(), we require,
>>   - @group only has a single device;
>>   - @group hasn't been attached by any devices;
>>   - Set the @domain to @group
>>
>> Just like what we've done in iommu_attach_device().
>>
>> Any thoughts?
> 
> Rather than pass a bare iommu_group with implicit restrictions, it might 
> be neater to just pass an mdev_device, so that the IOMMU core can also 
> take care of allocating and setting up the group. Then we flag the group 
> internally as a special "mdev group" such that we can prevent callers 
> from subsequently trying to add/remove devices or attach/detach its 
> domain directly. That seems like it would make a pretty straightforward 
> and robust API extension, as long as the mdev argument here is optional 
> so that SVA and other aux users don't have to care. Other than the 
> slightly different ordering where caller would have to allocate the mdev 
> first, then finish it's PASID-based configuration afterwards, I guess 
> it's not far off what I was thinking yesterday :)

Hi Alex, Joerg and others, any comments here?

Best regards,
baolu
