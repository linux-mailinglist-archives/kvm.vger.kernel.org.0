Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6686A486EB6
	for <lists+kvm@lfdr.de>; Fri,  7 Jan 2022 01:23:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344093AbiAGAXx (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 6 Jan 2022 19:23:53 -0500
Received: from mga06.intel.com ([134.134.136.31]:38685 "EHLO mga06.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1343928AbiAGAXw (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 6 Jan 2022 19:23:52 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1641515032; x=1673051032;
  h=cc:subject:to:references:from:message-id:date:
   mime-version:in-reply-to:content-transfer-encoding;
  bh=ZIszb2ptLlWN5jiqIqtYtNRvhlbcJxtJfClvbQTYBwI=;
  b=dMYuhm+ct68A0mK/AURSdYZzwaoMXCHBssqJ0sBrPk0JE156EZJ6n2mv
   Q8jnb2iPDsj6tJWZcwdg+0KIehA3WyzA91viaU1zX9qKa60909iFiJHFr
   JWGJvIv0HndwQUW4K5kzd+5xgH7sbDgvcio9sx1Th/Z3XPbEVMaD5GKu6
   98VgoUhnG0dK4uPqixS/2fWbOCdvJigpSzHc06TGL+sPGrONaQ0QEEwrk
   vVmVC2zzfRBUZFZPn+3eADy422LnLb4EKarkGtUkaRmpQhvuvp2TINEJ1
   nkzsw6NwpYqyWGSeJ6jNqLk7BBkxaYRIeEpAcU9SpJQYNxku2CFSeScub
   w==;
X-IronPort-AV: E=McAfee;i="6200,9189,10217"; a="303514982"
X-IronPort-AV: E=Sophos;i="5.88,268,1635231600"; 
   d="scan'208";a="303514982"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Jan 2022 16:23:52 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.88,268,1635231600"; 
   d="scan'208";a="527179688"
Received: from allen-box.sh.intel.com (HELO [10.239.159.118]) ([10.239.159.118])
  by orsmga008.jf.intel.com with ESMTP; 06 Jan 2022 16:23:45 -0800
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
Subject: Re: [PATCH v1 5/8] iommu/amd: Use iommu_attach/detach_device()
To:     Jason Gunthorpe <jgg@nvidia.com>
References: <20220106022053.2406748-1-baolu.lu@linux.intel.com>
 <20220106022053.2406748-6-baolu.lu@linux.intel.com>
 <20220106143345.GC2328285@nvidia.com>
From:   Lu Baolu <baolu.lu@linux.intel.com>
Message-ID: <456972f1-0237-81db-69cf-363f9ac611e0@linux.intel.com>
Date:   Fri, 7 Jan 2022 08:23:05 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.14.0
MIME-Version: 1.0
In-Reply-To: <20220106143345.GC2328285@nvidia.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Jason,

On 1/6/22 10:33 PM, Jason Gunthorpe wrote:
> On Thu, Jan 06, 2022 at 10:20:50AM +0800, Lu Baolu wrote:
>> The individual device driver should use iommu_attach/detach_device()
>> for domain attachment/detachment.
>>
>> Signed-off-by: Lu Baolu <baolu.lu@linux.intel.com>
>>   drivers/iommu/amd/iommu_v2.c | 4 ++--
>>   1 file changed, 2 insertions(+), 2 deletions(-)
>>
>> diff --git a/drivers/iommu/amd/iommu_v2.c b/drivers/iommu/amd/iommu_v2.c
>> index 58da08cc3d01..7d9d0fe89064 100644
>> +++ b/drivers/iommu/amd/iommu_v2.c
>> @@ -133,7 +133,7 @@ static void free_device_state(struct device_state *dev_state)
>>   	if (WARN_ON(!group))
>>   		return;
>>   
>> -	iommu_detach_group(dev_state->domain, group);
>> +	iommu_detach_device(dev_state->domain, &dev_state->pdev->dev);
>>   
>>   	iommu_group_put(group);
> 
> This is the only user of the group in the function all the
> group_get/put should be deleted too.
> 
> Joerg said in commit 55c99a4dc50f ("iommu/amd: Use
> iommu_attach_group()") that the device API doesn't work here because
> there are multi-device groups?
> 
> But I'm not sure how this can work with multi-device groups - this
> seems to assigns a domain setup for direct map, so perhaps this only
> works if all devices are setup for direct map?

It's also difficult for me to understand how this can work with multi-
device group. The iommu_attach_group() returns -EBUSY if _init_device()
is called for the second device in the group. That's the reason why I
didn't set no_kernel_dma.

> 
>> @@ -791,7 +791,7 @@ int amd_iommu_init_device(struct pci_dev *pdev, int pasids)
>>   		goto out_free_domain;
>>   	}
>>   
>> -	ret = iommu_attach_group(dev_state->domain, group);
>> +	ret = iommu_attach_device(dev_state->domain, &pdev->dev);
>>   	if (ret != 0)
>>   		goto out_drop_group;
> 
> Same comment here

Yes.

> 
> Jason
> 

Best regards,
baolu
