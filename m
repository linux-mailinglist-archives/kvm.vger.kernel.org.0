Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5F44A486F86
	for <lists+kvm@lfdr.de>; Fri,  7 Jan 2022 02:15:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344321AbiAGBP1 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 6 Jan 2022 20:15:27 -0500
Received: from mga09.intel.com ([134.134.136.24]:7791 "EHLO mga09.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239981AbiAGBP0 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 6 Jan 2022 20:15:26 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1641518126; x=1673054126;
  h=cc:subject:to:references:from:message-id:date:
   mime-version:in-reply-to:content-transfer-encoding;
  bh=nbnm/W/ou/jogJEbCGLPOkf+Msh2bjyG/ewZEC43WdY=;
  b=QQuHNOYz6pe1n9AoEZgw61JM8/Po8hch+/Dq94c+VgdwouyzE6xK9s6f
   UY7ttNiMcFan8vWmO/tnPZ9zv8Wa94CzYBgtLpuPWpn4KYZF6m5sJvkeJ
   g9pD+Eyjgu3gjmRhSKhrG/fvT2Nsp4eSTvsr+FiyN9UUjf2FLEQdruP7t
   IV+EEi+IXCd0ZXmaSmq8N06+yc/cjfpy/jhLLM4+4HFTvdgTLkGqvqXsh
   HK6/p3VtIGmJqHx0176J7h7a1i0RVUVdDAYoCyUkpaX9UfHZ1g49EgySM
   mRckYZuBUdVo74AW/YlisSZslEFoHv8A4GOK2PPvs2B5/Saf9hJpG9vee
   g==;
X-IronPort-AV: E=McAfee;i="6200,9189,10217"; a="242575074"
X-IronPort-AV: E=Sophos;i="5.88,268,1635231600"; 
   d="scan'208";a="242575074"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Jan 2022 17:15:25 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.88,268,1635231600"; 
   d="scan'208";a="527199929"
Received: from allen-box.sh.intel.com (HELO [10.239.159.118]) ([10.239.159.118])
  by orsmga008.jf.intel.com with ESMTP; 06 Jan 2022 17:15:18 -0800
Cc:     baolu.lu@linux.intel.com, Joerg Roedel <joro@8bytes.org>,
        Alex Williamson <alex.williamson@redhat.com>,
        Robin Murphy <robin.murphy@arm.com>,
        Christoph Hellwig <hch@infradead.org>,
        Kevin Tian <kevin.tian@intel.com>,
        Ashok Raj <ashok.raj@intel.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Will Deacon <will@kernel.org>,
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
Subject: Re: [PATCH v1 3/8] iommu: Extend iommu_at[de]tach_device() for
 multi-device groups
To:     Jason Gunthorpe <jgg@nvidia.com>
References: <20220106022053.2406748-1-baolu.lu@linux.intel.com>
 <20220106022053.2406748-4-baolu.lu@linux.intel.com>
 <20220106172249.GJ2328285@nvidia.com>
From:   Lu Baolu <baolu.lu@linux.intel.com>
Message-ID: <ec61dd78-7e21-c9ca-b042-32d396577a22@linux.intel.com>
Date:   Fri, 7 Jan 2022 09:14:38 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.14.0
MIME-Version: 1.0
In-Reply-To: <20220106172249.GJ2328285@nvidia.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Jason,

On 1/7/22 1:22 AM, Jason Gunthorpe wrote:
> On Thu, Jan 06, 2022 at 10:20:48AM +0800, Lu Baolu wrote:
>> The iommu_attach/detach_device() interfaces were exposed for the device
>> drivers to attach/detach their own domains. The commit <426a273834eae>
>> ("iommu: Limit iommu_attach/detach_device to device with their own group")
>> restricted them to singleton groups to avoid different device in a group
>> attaching different domain.
>>
>> As we've introduced device DMA ownership into the iommu core. We can now
>> extend these interfaces for muliple-device groups, and "all devices are in
>> the same address space" is still guaranteed.
>>
>> For multiple devices belonging to a same group, iommu_device_use_dma_api()
>> and iommu_attach_device() are exclusive. Therefore, when drivers decide to
>> use iommu_attach_domain(), they cannot call iommu_device_use_dma_api() at
>> the same time.
>>
>> Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
>> Signed-off-by: Lu Baolu <baolu.lu@linux.intel.com>
>>   drivers/iommu/iommu.c | 79 +++++++++++++++++++++++++++++++++----------
>>   1 file changed, 62 insertions(+), 17 deletions(-)
>>
>> diff --git a/drivers/iommu/iommu.c b/drivers/iommu/iommu.c
>> index ab8ab95969f5..2c9efd85e447 100644
>> +++ b/drivers/iommu/iommu.c
>> @@ -47,6 +47,7 @@ struct iommu_group {
>>   	struct iommu_domain *domain;
>>   	struct list_head entry;
>>   	unsigned int owner_cnt;
>> +	unsigned int attach_cnt;
> 
> Why did we suddenly need another counter? None of the prior versions
> needed this. I suppose this is being used a some flag to indicate if
> owner_cnt == 1 or owner_cnt == 0 should restore the default domain?

Yes, exactly.

> Would rather a flag 'auto_no_kernel_dma_api_compat' or something

Adding a flag also works.

> 
> 
>> +/**
>> + * iommu_attach_device() - attach external or UNMANAGED domain to device
>> + * @domain: the domain about to attach
>> + * @dev: the device about to be attached
>> + *
>> + * For devices belonging to the same group, iommu_device_use_dma_api() and
>> + * iommu_attach_device() are exclusive. Therefore, when drivers decide to
>> + * use iommu_attach_domain(), they cannot call iommu_device_use_dma_api()
>> + * at the same time.
>> + */
>>   int iommu_attach_device(struct iommu_domain *domain, struct device *dev)
>>   {
>>   	struct iommu_group *group;
>> +	int ret = 0;
>> +
>> +	if (domain->type != IOMMU_DOMAIN_UNMANAGED)
>> +		return -EINVAL;
>>   
>>   	group = iommu_group_get(dev);
>>   	if (!group)
>>   		return -ENODEV;
>>   
>> +	if (group->owner_cnt) {
>> +		/*
>> +		 * Group has been used for kernel-api dma or claimed explicitly
>> +		 * for exclusive occupation. For backward compatibility, device
>> +		 * in a singleton group is allowed to ignore setting the
>> +		 * drv.no_kernel_api_dma field.
> 
> BTW why is this call 'no kernel api dma' ? That reads backwards 'no
> kernel dma api' right?

Yes. Need to rephrase this wording.

> 
> Aother appeal of putting no_kernel_api_dma in the struct device_driver
> is that this could could simply do 'dev->driver->no_kernel_api_dma' to
> figure out how it is being called and avoid this messy implicitness.

Yes.

> 
> Once we know our calling context we can always automatic switch from
> DMA API mode to another domain without any trouble or special
> counters:
> 
> if (!dev->driver->no_kernel_api_dma) {
>      if (group->owner_cnt > 1 || group->owner)
>          return -EBUSY;
>      return __iommu_attach_group(domain, group);
> }

Is there any lock issue when referencing dev->driver here? I guess this
requires iommu_attach_device() only being called during the driver life
(a.k.a. between driver .probe and .release).

> 
> if (!group->owner_cnt) {
>      ret = __iommu_attach_group(domain, group);
>      if (ret)
>          return ret;
> } else if (group->owner || group->domain != domain)
>      return -EBUSY;
> group->owner_cnt++;
> 
> Right?

Yes. It's more straightforward if there's no issue around dev->driver
referencing.

> 
>> +	if (!group->attach_cnt) {
>> +		ret = __iommu_attach_group(domain, group);
> 
> How come we don't have to detatch the default domain here? Doesn't
> that mean that the iommu_replace_group could also just call attach
> directly without going through detatch?

__iommu_attach_group() allows replacing the default domain with a
private domain. Corresponding __iommu_detach_group() automatically
replaces private domain with the default domain.

The auto-switch logic should not apply to iommu_group_replace_domain()
which is designed for components with iommu_set_dma_owner() called.

> 
> Jason
> 

Best regards,
baolu
