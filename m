Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B096F47DDF9
	for <lists+kvm@lfdr.de>; Thu, 23 Dec 2021 04:03:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346127AbhLWDDa (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 22 Dec 2021 22:03:30 -0500
Received: from mga09.intel.com ([134.134.136.24]:62604 "EHLO mga09.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231389AbhLWDD0 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 22 Dec 2021 22:03:26 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1640228606; x=1671764606;
  h=cc:subject:to:references:from:message-id:date:
   mime-version:in-reply-to:content-transfer-encoding;
  bh=5d4GcwvuSuDNN/LCrM8VSrs/VLqePmPsfkX8JRr6fXw=;
  b=dJ6qRIXP9J3TpHKRIw5tBkStO2iFZp4TxNQp/YSdb2oBwmL6lT9T0W6n
   DL+6GFjowKD2gsynz6Sgh+oArg/X4vTV0hUJ4uoKTawVt+EMJdIzDZ7hX
   A8fWLaZcfw3nSoFGVQqTiuifTfxyn0GhJ6vdrYJkgnNjP/YW98X1cHUJB
   9mJgkfJ0s7anDf/4qkNDX2GVaR9/50LepMggmBtI5nD6vQoQsExRiMCr9
   FuS4WeFJBm0ob9yDU37q83H7cruTBV7KkX59hAXl5ATVgSsc1CihFRO6x
   DWaUbjD3ko5FzyiiCYEBLYdoVq1/UjeDwQvTMBg8/TjCRE+47k7Kt155r
   A==;
X-IronPort-AV: E=McAfee;i="6200,9189,10206"; a="240549254"
X-IronPort-AV: E=Sophos;i="5.88,228,1635231600"; 
   d="scan'208";a="240549254"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Dec 2021 19:03:25 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.88,228,1635231600"; 
   d="scan'208";a="664454653"
Received: from allen-box.sh.intel.com (HELO [10.239.159.118]) ([10.239.159.118])
  by fmsmga001.fm.intel.com with ESMTP; 22 Dec 2021 19:03:18 -0800
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
From:   Lu Baolu <baolu.lu@linux.intel.com>
Message-ID: <94e37c45-abc1-c682-5adf-1cc4b6887640@linux.intel.com>
Date:   Thu, 23 Dec 2021 11:02:54 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.14.0
MIME-Version: 1.0
In-Reply-To: <YcMeZlN3798noycN@kroah.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Greg,

On 12/22/21 8:47 PM, Greg Kroah-Hartman wrote:
>> +
>> +	return ret;
>> +}
>> +
>> +static void device_dma_cleanup(struct device *dev, struct device_driver *drv)
>> +{
>> +	if (!dev->bus->dma_configure)
>> +		return;
>> +
>> +	if (!drv->suppress_auto_claim_dma_owner)
>> +		iommu_device_release_dma_owner(dev, DMA_OWNER_DMA_API);
>> +}
>> +
>>   static int really_probe(struct device *dev, struct device_driver *drv)
>>   {
>>   	bool test_remove = IS_ENABLED(CONFIG_DEBUG_TEST_DRIVER_REMOVE) &&
>> @@ -574,11 +601,8 @@ static int really_probe(struct device *dev, struct device_driver *drv)
>>   	if (ret)
>>   		goto pinctrl_bind_failed;
>>   
>> -	if (dev->bus->dma_configure) {
>> -		ret = dev->bus->dma_configure(dev);
>> -		if (ret)
>> -			goto probe_failed;
>> -	}
>> +	if (device_dma_configure(dev, drv))
>> +		goto pinctrl_bind_failed;
> Are you sure you are jumping to the proper error path here?  It is not
> obvious why you changed this.

The error handling path in really_probe() seems a bit wrong. For
example,

  572         /* If using pinctrl, bind pins now before probing */
  573         ret = pinctrl_bind_pins(dev);
  574         if (ret)
  575                 goto pinctrl_bind_failed;

[...]

  663 pinctrl_bind_failed:
  664         device_links_no_driver(dev);
  665         devres_release_all(dev);
  666         arch_teardown_dma_ops(dev);
  667         kfree(dev->dma_range_map);
  668         dev->dma_range_map = NULL;
  669         driver_sysfs_remove(dev);
              ^^^^^^^^^^^^^^^^^^^^^^^^^
  670         dev->driver = NULL;
  671         dev_set_drvdata(dev, NULL);
  672         if (dev->pm_domain && dev->pm_domain->dismiss)
  673                 dev->pm_domain->dismiss(dev);
  674         pm_runtime_reinit(dev);
  675         dev_pm_set_driver_flags(dev, 0);
  676 done:
  677         return ret;

The driver_sysfs_remove() will be called even driver_sysfs_add() hasn't
been called yet. I can fix this in a separated patch if I didn't miss
anything.

Best regards,
baolu
