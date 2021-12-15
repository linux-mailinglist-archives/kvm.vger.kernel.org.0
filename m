Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 86B824758D1
	for <lists+kvm@lfdr.de>; Wed, 15 Dec 2021 13:25:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242468AbhLOMZD (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 15 Dec 2021 07:25:03 -0500
Received: from mga07.intel.com ([134.134.136.100]:15730 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S242416AbhLOMZC (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 15 Dec 2021 07:25:02 -0500
X-IronPort-AV: E=McAfee;i="6200,9189,10198"; a="302588599"
X-IronPort-AV: E=Sophos;i="5.88,207,1635231600"; 
   d="scan'208";a="302588599"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Dec 2021 04:25:02 -0800
X-IronPort-AV: E=Sophos;i="5.88,207,1635231600"; 
   d="scan'208";a="518749567"
Received: from blu2-mobl3.ccr.corp.intel.com (HELO [10.254.215.57]) ([10.254.215.57])
  by orsmga008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Dec 2021 04:24:55 -0800
Message-ID: <faa67db1-cba7-cc23-2a36-7dd716a1f7e3@linux.intel.com>
Date:   Wed, 15 Dec 2021 20:24:52 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.4.0
Cc:     baolu.lu@linux.intel.com, Joerg Roedel <joro@8bytes.org>,
        Alex Williamson <alex.williamson@redhat.com>,
        Bjorn Helgaas <bhelgaas@google.com>,
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
Subject: Re: [PATCH v3 04/18] driver core: platform: Add driver dma ownership
 management
Content-Language: en-US
To:     Jason Gunthorpe <jgg@nvidia.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Christoph Hellwig <hch@infradead.org>
References: <20211206015903.88687-1-baolu.lu@linux.intel.com>
 <20211206015903.88687-5-baolu.lu@linux.intel.com>
 <Ya4f662Af+8kE2F/@infradead.org> <20211206150647.GE4670@nvidia.com>
 <56a63776-48ca-0d6e-c25c-016dc016e0d5@linux.intel.com>
 <20211207131627.GA6385@nvidia.com>
 <c170d215-6aef-ff21-8733-1bae4478e39c@linux.intel.com>
 <b42ffaee-bb96-6db4-8540-b399214f6881@linux.intel.com>
 <5d537286-2cb3-cf91-c0de-019355110aa1@linux.intel.com>
From:   Lu Baolu <baolu.lu@linux.intel.com>
In-Reply-To: <5d537286-2cb3-cf91-c0de-019355110aa1@linux.intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Greg,

On 2021/12/13 8:50, Lu Baolu wrote:
> On 12/10/21 9:23 AM, Lu Baolu wrote:
>> Hi Greg, Jason and Christoph,
>>
>> On 12/9/21 9:20 AM, Lu Baolu wrote:
>>> On 12/7/21 9:16 PM, Jason Gunthorpe wrote:
>>>> On Tue, Dec 07, 2021 at 10:57:25AM +0800, Lu Baolu wrote:
>>>>> On 12/6/21 11:06 PM, Jason Gunthorpe wrote:
>>>>>> On Mon, Dec 06, 2021 at 06:36:27AM -0800, Christoph Hellwig wrote:
>>>>>>> I really hate the amount of boilerplate code that having this in 
>>>>>>> each
>>>>>>> bus type causes.
>>>>>> +1
>>>>>>
>>>>>> I liked the first version of this series better with the code near
>>>>>> really_probe().
>>>>>>
>>>>>> Can we go back to that with some device_configure_dma() wrapper
>>>>>> condtionally called by really_probe as we discussed?
>>
>> [...]
>>
>>>
>>> diff --git a/drivers/base/dd.c b/drivers/base/dd.c
>>> index 68ea1f949daa..68ca5a579eb1 100644
>>> --- a/drivers/base/dd.c
>>> +++ b/drivers/base/dd.c
>>> @@ -538,6 +538,32 @@ static int call_driver_probe(struct device *dev, 
>>> struct device_driver *drv)
>>>          return ret;
>>>   }
>>>
>>> +static int device_dma_configure(struct device *dev, struct 
>>> device_driver *drv)
>>> +{
>>> +       int ret;
>>> +
>>> +       if (!dev->bus->dma_configure)
>>> +               return 0;
>>> +
>>> +       ret = dev->bus->dma_configure(dev);
>>> +       if (ret)
>>> +               return ret;
>>> +
>>> +       if (!drv->suppress_auto_claim_dma_owner)
>>> +               ret = iommu_device_set_dma_owner(dev, 
>>> DMA_OWNER_DMA_API, NULL);
>>> +
>>> +       return ret;
>>> +}
>>> +
>>> +static void device_dma_cleanup(struct device *dev, struct 
>>> device_driver *drv)
>>> +{
>>> +       if (!dev->bus->dma_configure)
>>> +               return;
>>> +
>>> +       if (!drv->suppress_auto_claim_dma_owner)
>>> +               iommu_device_release_dma_owner(dev, DMA_OWNER_DMA_API);
>>> +}
>>> +
>>>   static int really_probe(struct device *dev, struct device_driver *drv)
>>>   {
>>>          bool test_remove = 
>>> IS_ENABLED(CONFIG_DEBUG_TEST_DRIVER_REMOVE) &&
>>> @@ -574,11 +600,8 @@ static int really_probe(struct device *dev, 
>>> struct device_driver *drv)
>>>          if (ret)
>>>                  goto pinctrl_bind_failed;
>>>
>>> -       if (dev->bus->dma_configure) {
>>> -               ret = dev->bus->dma_configure(dev);
>>> -               if (ret)
>>> -                       goto probe_failed;
>>> -       }
>>> +       if (device_dma_configure(dev, drv))
>>> +               goto pinctrl_bind_failed;
>>>
>>>          ret = driver_sysfs_add(dev);
>>>          if (ret) {
>>> @@ -660,6 +683,8 @@ static int really_probe(struct device *dev, 
>>> struct device_driver *drv)
>>>          if (dev->bus)
>>>                  
>>> blocking_notifier_call_chain(&dev->bus->p->bus_notifier,
>>>
>>> BUS_NOTIFY_DRIVER_NOT_BOUND, dev);
>>> +
>>> +       device_dma_cleanup(dev, drv);
>>>   pinctrl_bind_failed:
>>>          device_links_no_driver(dev);
>>>          devres_release_all(dev);
>>> @@ -1204,6 +1229,7 @@ static void __device_release_driver(struct 
>>> device *dev, struct device *parent)
>>>                  else if (drv->remove)
>>>                          drv->remove(dev);
>>>
>>> +               device_dma_cleanup(dev, drv);
>>>                  device_links_driver_cleanup(dev);
>>>
>>>                  devres_release_all(dev);
>>> diff --git a/include/linux/device/driver.h 
>>> b/include/linux/device/driver.h
>>> index a498ebcf4993..374a3c2cc10d 100644
>>> --- a/include/linux/device/driver.h
>>> +++ b/include/linux/device/driver.h
>>> @@ -100,6 +100,7 @@ struct device_driver {
>>>          const char              *mod_name;      /* used for built-in 
>>> modules */
>>>
>>>          bool suppress_bind_attrs;       /* disables bind/unbind via 
>>> sysfs */
>>> +       bool suppress_auto_claim_dma_owner;
>>>          enum probe_type probe_type;
>>>
>>>          const struct of_device_id       *of_match_table;
>>
>> Does this work for you? Can I work towards this in the next version?
> 
> A kindly ping ... Is this heading the right direction? I need your
> advice to move ahead. :-)

Can I do it like this? :-)

Best regards,
baolu
