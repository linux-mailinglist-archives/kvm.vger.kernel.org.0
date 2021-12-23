Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1CE6747DF85
	for <lists+kvm@lfdr.de>; Thu, 23 Dec 2021 08:24:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346798AbhLWHY0 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 23 Dec 2021 02:24:26 -0500
Received: from mga11.intel.com ([192.55.52.93]:46723 "EHLO mga11.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235223AbhLWHY0 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 23 Dec 2021 02:24:26 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1640244266; x=1671780266;
  h=cc:subject:to:references:from:message-id:date:
   mime-version:in-reply-to:content-transfer-encoding;
  bh=aUqSTgtjYorgHIpTZQT6Y/tE/0+lDO+GqEPURXGr+QE=;
  b=RB27nEGgJK23xmtLA4soCFrBt3qvwsmPVOhVNCSgopGUr16+apEP7SqA
   cpltkCPn+ndl5Ta2X74ILZimRIhDh1y1jAMhSQMj5rJf7d+oIhosmuZ69
   HnOk3PMl8gCGH1GqOtW+CEEMcYuSWHBY0QX0eV/tZcVxXjS124xQpp2O8
   JZQasl6Ev02D37ndGGiAEtQcf7Ah3VRJcgdF3H2PcO3Y83ID49M5nBv4X
   KPBqv719tYzkzkk0Rj1eDX8yDpK/SLc+E9DKx5NY4RlixUHyJohKjCqxi
   aWQ53yJjqzMDGVC2Q9xxBo+emtBk9KAqQnypY+foc92T7PjjQJMN/aOCW
   w==;
X-IronPort-AV: E=McAfee;i="6200,9189,10206"; a="238309643"
X-IronPort-AV: E=Sophos;i="5.88,228,1635231600"; 
   d="scan'208";a="238309643"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Dec 2021 23:24:26 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.88,228,1635231600"; 
   d="scan'208";a="664504933"
Received: from allen-box.sh.intel.com (HELO [10.239.159.118]) ([10.239.159.118])
  by fmsmga001.fm.intel.com with ESMTP; 22 Dec 2021 23:24:19 -0800
Cc:     baolu.lu@linux.intel.com, Joerg Roedel <joro@8bytes.org>,
        Alex Williamson <alex.williamson@redhat.com>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Jason Gunthorpe <jgg@nvidia.com>,
        Christoph Hellwig <hch@infradead.org>,
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
Subject: Re: [PATCH v4 02/13] driver core: Set DMA ownership during driver
 bind/unbind
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
References: <20211217063708.1740334-1-baolu.lu@linux.intel.com>
 <20211217063708.1740334-3-baolu.lu@linux.intel.com>
 <YcMeZlN3798noycN@kroah.com>
 <94e37c45-abc1-c682-5adf-1cc4b6887640@linux.intel.com>
 <YcQhka64aqHJ5uE7@kroah.com>
From:   Lu Baolu <baolu.lu@linux.intel.com>
Message-ID: <2350bea8-1ca0-0945-2084-77a3c7f54f27@linux.intel.com>
Date:   Thu, 23 Dec 2021 15:23:54 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.14.0
MIME-Version: 1.0
In-Reply-To: <YcQhka64aqHJ5uE7@kroah.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 12/23/21 3:13 PM, Greg Kroah-Hartman wrote:
> On Thu, Dec 23, 2021 at 11:02:54AM +0800, Lu Baolu wrote:
>> Hi Greg,
>>
>> On 12/22/21 8:47 PM, Greg Kroah-Hartman wrote:
>>>> +
>>>> +	return ret;
>>>> +}
>>>> +
>>>> +static void device_dma_cleanup(struct device *dev, struct device_driver *drv)
>>>> +{
>>>> +	if (!dev->bus->dma_configure)
>>>> +		return;
>>>> +
>>>> +	if (!drv->suppress_auto_claim_dma_owner)
>>>> +		iommu_device_release_dma_owner(dev, DMA_OWNER_DMA_API);
>>>> +}
>>>> +
>>>>    static int really_probe(struct device *dev, struct device_driver *drv)
>>>>    {
>>>>    	bool test_remove = IS_ENABLED(CONFIG_DEBUG_TEST_DRIVER_REMOVE) &&
>>>> @@ -574,11 +601,8 @@ static int really_probe(struct device *dev, struct device_driver *drv)
>>>>    	if (ret)
>>>>    		goto pinctrl_bind_failed;
>>>> -	if (dev->bus->dma_configure) {
>>>> -		ret = dev->bus->dma_configure(dev);
>>>> -		if (ret)
>>>> -			goto probe_failed;
>>>> -	}
>>>> +	if (device_dma_configure(dev, drv))
>>>> +		goto pinctrl_bind_failed;
>>> Are you sure you are jumping to the proper error path here?  It is not
>>> obvious why you changed this.
>> The error handling path in really_probe() seems a bit wrong. For
>> example,
>>
>>   572         /* If using pinctrl, bind pins now before probing */
>>   573         ret = pinctrl_bind_pins(dev);
>>   574         if (ret)
>>   575                 goto pinctrl_bind_failed;
>>
>> [...]
>>
>>   663 pinctrl_bind_failed:
>>   664         device_links_no_driver(dev);
>>   665         devres_release_all(dev);
>>   666         arch_teardown_dma_ops(dev);
>>   667         kfree(dev->dma_range_map);
>>   668         dev->dma_range_map = NULL;
>>   669         driver_sysfs_remove(dev);
>>               ^^^^^^^^^^^^^^^^^^^^^^^^^
>>   670         dev->driver = NULL;
>>   671         dev_set_drvdata(dev, NULL);
>>   672         if (dev->pm_domain && dev->pm_domain->dismiss)
>>   673                 dev->pm_domain->dismiss(dev);
>>   674         pm_runtime_reinit(dev);
>>   675         dev_pm_set_driver_flags(dev, 0);
>>   676 done:
>>   677         return ret;
>>
>> The driver_sysfs_remove() will be called even driver_sysfs_add() hasn't
>> been called yet. I can fix this in a separated patch if I didn't miss
>> anything.
> If this is a bug in the existing kernel, please submit it as a separate
> patch so that it can be properly backported to all affected kernels.
> Never bury it in an unrelated change that will never get sent to older
> kernels.

Sure! I will. Thank you!

Best regards,
baolu
