Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 22B5A74FD5B
	for <lists+kvm@lfdr.de>; Wed, 12 Jul 2023 05:03:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231520AbjGLDDF (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 11 Jul 2023 23:03:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55106 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229983AbjGLDDD (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 11 Jul 2023 23:03:03 -0400
Received: from mga12.intel.com (mga12.intel.com [192.55.52.136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F0181171F;
        Tue, 11 Jul 2023 20:02:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1689130978; x=1720666978;
  h=message-id:date:mime-version:cc:subject:to:references:
   from:in-reply-to:content-transfer-encoding;
  bh=QK32cJv9qYLbn/6zU+E5RkqF3WLxlh7y7udGakhTrRA=;
  b=YdVkFEW37nJLSPf0gqhQWBmcqq7+fQ8zEoldogTXtopkgOEw3pagDsKX
   P5QHZ9eii1Uo7oKBBoRUka1TuUdM8Lfn4AxAbP+e2tOIpIMC0sdPoNH8R
   Jk0ZsK7JCzb1kr/8CdwUfdPPvpiF5e6xgjAmLSCN+rEwiDt7sdsHkEOOr
   Ebe3V+wJzgqaHtnXQfxzTwPqnGTkqup5uOttlWorTk8hSE3PqHx8bgyze
   kj1JRasVzgx4+o2K6ok/1DfO8OqotOiXpgZyPL2unzYtjd4KWYK8yFb/j
   Lk+SuqQpE3hEI5isvVNkWcUWvhi8fPHXCGIkgpAitoz+JtWcvssSwuQK6
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10768"; a="344390067"
X-IronPort-AV: E=Sophos;i="6.01,198,1684825200"; 
   d="scan'208";a="344390067"
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Jul 2023 20:02:58 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10768"; a="715412363"
X-IronPort-AV: E=Sophos;i="6.01,198,1684825200"; 
   d="scan'208";a="715412363"
Received: from blu2-mobl.ccr.corp.intel.com (HELO [10.252.187.60]) ([10.252.187.60])
  by orsmga007-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Jul 2023 20:02:53 -0700
Message-ID: <98d6e7a3-8988-604f-1b67-27a25fadb627@linux.intel.com>
Date:   Wed, 12 Jul 2023 11:02:50 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.13.0
Cc:     baolu.lu@linux.intel.com, Joerg Roedel <joro@8bytes.org>,
        Will Deacon <will@kernel.org>,
        Robin Murphy <robin.murphy@arm.com>,
        Jason Gunthorpe <jgg@ziepe.ca>,
        Kevin Tian <kevin.tian@intel.com>,
        Jean-Philippe Brucker <jean-philippe@linaro.org>,
        Nicolin Chen <nicolinc@nvidia.com>,
        Yi Liu <yi.l.liu@intel.com>, iommu@lists.linux.dev,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 5/9] iommu: Make fault_param generic
Content-Language: en-US
To:     Jacob Pan <jacob.jun.pan@linux.intel.com>
References: <20230711010642.19707-1-baolu.lu@linux.intel.com>
 <20230711010642.19707-6-baolu.lu@linux.intel.com>
 <20230711143151.3191f23c@jacob-builder>
From:   Baolu Lu <baolu.lu@linux.intel.com>
In-Reply-To: <20230711143151.3191f23c@jacob-builder>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_MED,
        SPF_HELO_PASS,SPF_NONE,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 2023/7/12 5:31, Jacob Pan wrote:
> On Tue, 11 Jul 2023 09:06:38 +0800, Lu Baolu<baolu.lu@linux.intel.com>
> wrote:
> 
>> The iommu faults, including recoverable faults (IO page faults) and
>> unrecoverable faults (DMA faults), are generic to all devices. The
>> iommu faults could possibly be triggered for every device.
>>
>> The fault_param pointer under struct dev_iommu is the per-device fault
>> data. Therefore, the fault_param pointer should be allocated during
>> iommu device probe and freed when the device is released.
>>
>> With this done, the individual iommu drivers that support iopf have no
>> need to call iommu_[un]register_device_fault_handler() any more.
>> This will make it easier for the iommu drivers to support iopf, and it
>> will also make the fault_param allocation and free simpler.
>>
>> Signed-off-by: Lu Baolu<baolu.lu@linux.intel.com>
>> ---
>>   .../iommu/arm/arm-smmu-v3/arm-smmu-v3-sva.c    | 13 +------------
>>   drivers/iommu/intel/iommu.c                    | 18 ++++--------------
>>   drivers/iommu/iommu.c                          | 14 ++++++++++++++
>>   3 files changed, 19 insertions(+), 26 deletions(-)
>>
>> diff --git a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-sva.c
>> b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-sva.c index
>> a5a63b1c947e..fa8ab9d413f8 100644 ---
>> a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-sva.c +++
>> b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-sva.c @@ -437,7 +437,6 @@
>> bool arm_smmu_master_sva_enabled(struct arm_smmu_master *master)
>>   static int arm_smmu_master_sva_enable_iopf(struct arm_smmu_master
>> *master) {
>> -	int ret;
>>   	struct device *dev = master->dev;
>>   
>>   	/*
>> @@ -450,16 +449,7 @@ static int arm_smmu_master_sva_enable_iopf(struct
>> arm_smmu_master *master) if (!master->iopf_enabled)
>>   		return -EINVAL;
>>   
>> -	ret = iopf_queue_add_device(master->smmu->evtq.iopf, dev);
>> -	if (ret)
>> -		return ret;
>> -
>> -	ret = iommu_register_device_fault_handler(dev, iommu_queue_iopf,
>> dev);
>> -	if (ret) {
>> -		iopf_queue_remove_device(master->smmu->evtq.iopf, dev);
>> -		return ret;
>> -	}
>> -	return 0;
>> +	return iopf_queue_add_device(master->smmu->evtq.iopf, dev);
>>   }
>>   
>>   static void arm_smmu_master_sva_disable_iopf(struct arm_smmu_master
>> *master) @@ -469,7 +459,6 @@ static void
>> arm_smmu_master_sva_disable_iopf(struct arm_smmu_master *master) if
>> (!master->iopf_enabled) return;
>>   
>> -	iommu_unregister_device_fault_handler(dev);
>>   	iopf_queue_remove_device(master->smmu->evtq.iopf, dev);
>>   }
>>   
>> diff --git a/drivers/iommu/intel/iommu.c b/drivers/iommu/intel/iommu.c
>> index 5c8c5cdc36cf..22e43db20252 100644
>> --- a/drivers/iommu/intel/iommu.c
>> +++ b/drivers/iommu/intel/iommu.c
>> @@ -4594,23 +4594,14 @@ static int intel_iommu_enable_iopf(struct device
>> *dev) if (ret)
>>   		return ret;
>>   
>> -	ret = iommu_register_device_fault_handler(dev, iommu_queue_iopf,
>> dev);
>> -	if (ret)
>> -		goto iopf_remove_device;
>> -
>>   	ret = pci_enable_pri(pdev, PRQ_DEPTH);
>> -	if (ret)
>> -		goto iopf_unregister_handler;
>> +	if (ret) {
>> +		iopf_queue_remove_device(iommu->iopf_queue, dev);
>> +		return ret;
>> +	}
>>   	info->pri_enabled = 1;
>>   
>>   	return 0;
>> -
>> -iopf_unregister_handler:
>> -	iommu_unregister_device_fault_handler(dev);
>> -iopf_remove_device:
>> -	iopf_queue_remove_device(iommu->iopf_queue, dev);
>> -
>> -	return ret;
>>   }
>>   
>>   static int intel_iommu_disable_iopf(struct device *dev)
>> @@ -4637,7 +4628,6 @@ static int intel_iommu_disable_iopf(struct device
>> *dev)
>>   	 * fault handler and removing device from iopf queue should never
>>   	 * fail.
>>   	 */
>> -	WARN_ON(iommu_unregister_device_fault_handler(dev));
>>   	WARN_ON(iopf_queue_remove_device(iommu->iopf_queue, dev));
>>   
>>   	return 0;
>> diff --git a/drivers/iommu/iommu.c b/drivers/iommu/iommu.c
>> index 65895b987e22..8d1f0935ea71 100644
>> --- a/drivers/iommu/iommu.c
>> +++ b/drivers/iommu/iommu.c
>> @@ -299,7 +299,15 @@ static int dev_iommu_get(struct device *dev)
>>   		return -ENOMEM;
>>   
>>   	mutex_init(&param->lock);
>> +	param->fault_param = kzalloc(sizeof(*param->fault_param),
>> GFP_KERNEL);
> since fault_param is_always_  allocated/freed along with param, can we merge
> into one allocation? i.e.
>   struct dev_iommu {
>          struct mutex lock;
> -       struct iommu_fault_param        *fault_param;
> +       struct iommu_fault_param        fault_param;

I am not pretty sure about the change in this patch. It's a simple-and-
stupid way. But it also wastes memory for devices that have not pri-
capable domain attached.

So probably it's better to allocate fault_param at the place where a
real pri-capable domain is attached to the device?

Best regards,
baolu
