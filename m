Return-Path: <kvm+bounces-7078-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id CB73583D491
	for <lists+kvm@lfdr.de>; Fri, 26 Jan 2024 09:09:53 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id ACDD91C2490E
	for <lists+kvm@lfdr.de>; Fri, 26 Jan 2024 08:09:52 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C13AD14292;
	Fri, 26 Jan 2024 06:42:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="AbpMgwS4"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.9])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 483F18C17;
	Fri, 26 Jan 2024 06:42:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.9
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706251353; cv=none; b=OS4I/i0Jc5zh87yz9DHvE7HFSyrWho6pY4GwmqflUH5zqt1E/zm1tqHANA61CPbpNKyKDOugFB5FR5OCEK0mdtOqeHwtkoTGRKQ+fmAmkadr4ZpCWBuGTtkKaMkDZw/n/h+3vnpiVMTInRiylCPdcPVKLMyMIV9Hvcul06XbVUY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706251353; c=relaxed/simple;
	bh=jLo3KMxRBpSL6yydPU4YbSnqbAzXDAidgHeP3g7yHHE=;
	h=Message-ID:Date:MIME-Version:Cc:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=pDIjZpe3ygTzuq/kVVPyKfO6NGoO+2mNYf8pZH4J/0emGYklbwAn8ZWFXKyfxiDO/MSqzWNawbXcMXQclgymuSj2NUceX1CC8OiX9u1/NGZVsKi66a/RoXopPjIg+R1Iwtmahzp06pBvyTfhLnyh1Z9PlJVydZZrDmyjGjCQ3Os=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=AbpMgwS4; arc=none smtp.client-ip=192.198.163.9
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1706251352; x=1737787352;
  h=message-id:date:mime-version:cc:subject:to:references:
   from:in-reply-to:content-transfer-encoding;
  bh=jLo3KMxRBpSL6yydPU4YbSnqbAzXDAidgHeP3g7yHHE=;
  b=AbpMgwS4+nF9EQDxEGx+Bg//oGLsHx9FTEn/oBGmLyzFfYLjT1Sb743m
   IYTnywNx7is2R/O1/Iz27PvmMLz/7JJqoHrHcDE58fsQMkssqDhdXepEb
   EkBcPPjwyMHJYl+aR/WDHFs9K/DI0EXbTX6YG0MrGpOklCUecd6T7dG7y
   m4tR78n8ZOJG2DQWpzHjWncmUfzd3yGx3HbXR05uVXbMYHkXU4WLN8j3B
   RoM7YKw2o+dqIRuhR24RXYxqHz1Do80/P36Ymv2tmNB/xN4cW9W4ugPHv
   O1n7P7xCEjqApgy4/991ABPKeyvSSil9y7Fcwe533YYHyf1B9KWgYz8Y1
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10964"; a="9155592"
X-IronPort-AV: E=Sophos;i="6.05,216,1701158400"; 
   d="scan'208";a="9155592"
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by fmvoesa103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Jan 2024 22:42:31 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10964"; a="877304337"
X-IronPort-AV: E=Sophos;i="6.05,216,1701158400"; 
   d="scan'208";a="877304337"
Received: from blu2-mobl.ccr.corp.intel.com (HELO [10.249.174.176]) ([10.249.174.176])
  by fmsmga003-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Jan 2024 22:42:27 -0800
Message-ID: <cdcb1026-4119-43df-b754-78071eb4b964@linux.intel.com>
Date: Fri, 26 Jan 2024 14:42:25 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Cc: baolu.lu@linux.intel.com, Joerg Roedel <joro@8bytes.org>,
 Will Deacon <will@kernel.org>, Robin Murphy <robin.murphy@arm.com>,
 Jason Gunthorpe <jgg@ziepe.ca>, Kevin Tian <kevin.tian@intel.com>,
 Jean-Philippe Brucker <jean-philippe@linaro.org>,
 Nicolin Chen <nicolinc@nvidia.com>, Yi Liu <yi.l.liu@intel.com>,
 Jacob Pan <jacob.jun.pan@linux.intel.com>,
 Longfang Liu <liulongfang@huawei.com>, Yan Zhao <yan.y.zhao@intel.com>,
 iommu@lists.linux.dev, kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
 Jason Gunthorpe <jgg@nvidia.com>
Subject: Re: [PATCH v10 16/16] iommu: Make iommu_report_device_fault() reutrn
 void
To: Joel Granados <j.granados@samsung.com>
References: <20240122054308.23901-1-baolu.lu@linux.intel.com>
 <20240122054308.23901-17-baolu.lu@linux.intel.com>
 <CGME20240125162625eucas1p1e9ae0f7cc7ba63f88316552048e77401@eucas1p1.samsung.com>
 <20240125162623.l3hg2i5k5kyh57cc@localhost>
Content-Language: en-US
From: Baolu Lu <baolu.lu@linux.intel.com>
In-Reply-To: <20240125162623.l3hg2i5k5kyh57cc@localhost>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 2024/1/26 0:26, Joel Granados wrote:
> On Mon, Jan 22, 2024 at 01:43:08PM +0800, Lu Baolu wrote:
>> As the iommu_report_device_fault() has been converted to auto-respond a
>> page fault if it fails to enqueue it, there's no need to return a code
>> in any case. Make it return void.
>>
>> Suggested-by: Jason Gunthorpe<jgg@nvidia.com>
>> Signed-off-by: Lu Baolu<baolu.lu@linux.intel.com>
>> ---
>>   include/linux/iommu.h                       |  5 ++---
>>   drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c |  4 ++--
>>   drivers/iommu/intel/svm.c                   | 19 +++++++----------
>>   drivers/iommu/io-pgfault.c                  | 23 +++++++--------------
>>   4 files changed, 19 insertions(+), 32 deletions(-)
>>
>> diff --git a/include/linux/iommu.h b/include/linux/iommu.h
>> index d7b6f4017254..1ccad10e8164 100644
>> --- a/include/linux/iommu.h
>> +++ b/include/linux/iommu.h
>> @@ -1549,7 +1549,7 @@ struct iopf_queue *iopf_queue_alloc(const char *name);
>>   void iopf_queue_free(struct iopf_queue *queue);
>>   int iopf_queue_discard_partial(struct iopf_queue *queue);
>>   void iopf_free_group(struct iopf_group *group);
>> -int iommu_report_device_fault(struct device *dev, struct iopf_fault *evt);
>> +void iommu_report_device_fault(struct device *dev, struct iopf_fault *evt);
>>   void iopf_group_response(struct iopf_group *group,
>>   			 enum iommu_page_response_code status);
>>   #else
>> @@ -1587,10 +1587,9 @@ static inline void iopf_free_group(struct iopf_group *group)
>>   {
>>   }
>>   
>> -static inline int
>> +static inline void
>>   iommu_report_device_fault(struct device *dev, struct iopf_fault *evt)
>>   {
>> -	return -ENODEV;
>>   }
>>   
>>   static inline void iopf_group_response(struct iopf_group *group,
>> diff --git a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
>> index 42eb59cb99f4..02580364acda 100644
>> --- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
>> +++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
>> @@ -1455,7 +1455,7 @@ arm_smmu_find_master(struct arm_smmu_device *smmu, u32 sid)
>>   /* IRQ and event handlers */
>>   static int arm_smmu_handle_evt(struct arm_smmu_device *smmu, u64 *evt)
>>   {
>> -	int ret;
>> +	int ret = 0;
>>   	u32 perm = 0;
>>   	struct arm_smmu_master *master;
>>   	bool ssid_valid = evt[0] & EVTQ_0_SSV;
>> @@ -1511,7 +1511,7 @@ static int arm_smmu_handle_evt(struct arm_smmu_device *smmu, u64 *evt)
>>   		goto out_unlock;
>>   	}
>>   
>> -	ret = iommu_report_device_fault(master->dev, &fault_evt);
>> +	iommu_report_device_fault(master->dev, &fault_evt);
>>   out_unlock:
>>   	mutex_unlock(&smmu->streams_mutex);
>>   	return ret;
>> diff --git a/drivers/iommu/intel/svm.c b/drivers/iommu/intel/svm.c
>> index 2f8716636dbb..b644d57da841 100644
>> --- a/drivers/iommu/intel/svm.c
>> +++ b/drivers/iommu/intel/svm.c
>> @@ -561,14 +561,11 @@ static int prq_to_iommu_prot(struct page_req_dsc *req)
>>   	return prot;
>>   }
>>   
>> -static int intel_svm_prq_report(struct intel_iommu *iommu, struct device *dev,
>> -				struct page_req_dsc *desc)
>> +static void intel_svm_prq_report(struct intel_iommu *iommu, struct device *dev,
>> +				 struct page_req_dsc *desc)
>>   {
>>   	struct iopf_fault event = { };
>>   
>> -	if (!dev || !dev_is_pci(dev))
>> -		return -ENODEV;
>> -
>>   	/* Fill in event data for device specific processing */
>>   	event.fault.type = IOMMU_FAULT_PAGE_REQ;
>>   	event.fault.prm.addr = (u64)desc->addr << VTD_PAGE_SHIFT;
>> @@ -601,7 +598,7 @@ static int intel_svm_prq_report(struct intel_iommu *iommu, struct device *dev,
>>   		event.fault.prm.private_data[0] = ktime_to_ns(ktime_get());
>>   	}
>>   
>> -	return iommu_report_device_fault(dev, &event);
>> +	iommu_report_device_fault(dev, &event);
>>   }
>>   
>>   static void handle_bad_prq_event(struct intel_iommu *iommu,
>> @@ -704,12 +701,10 @@ static irqreturn_t prq_event_thread(int irq, void *d)
>>   		if (!pdev)
>>   			goto bad_req;
>>   
>> -		if (intel_svm_prq_report(iommu, &pdev->dev, req))
>> -			handle_bad_prq_event(iommu, req, QI_RESP_INVALID);
>> -		else
>> -			trace_prq_report(iommu, &pdev->dev, req->qw_0, req->qw_1,
>> -					 req->priv_data[0], req->priv_data[1],
>> -					 iommu->prq_seq_number++);
>> +		intel_svm_prq_report(iommu, &pdev->dev, req);
>> +		trace_prq_report(iommu, &pdev->dev, req->qw_0, req->qw_1,
>> +				 req->priv_data[0], req->priv_data[1],
>> +				 iommu->prq_seq_number++);
>>   		pci_dev_put(pdev);
>>   prq_advance:
>>   		head = (head + sizeof(*req)) & PRQ_RING_MASK;
>> diff --git a/drivers/iommu/io-pgfault.c b/drivers/iommu/io-pgfault.c
>> index 6e63e5a02884..b64229dab976 100644
>> --- a/drivers/iommu/io-pgfault.c
>> +++ b/drivers/iommu/io-pgfault.c
>> @@ -179,23 +179,21 @@ static struct iopf_group *iopf_group_alloc(struct iommu_fault_param *iopf_param,
>>    *
>>    * Return: 0 on success and <0 on error.
>>    */
> Should you remove the documentation that describes the return also?

Yes. Will do.

Best regards,
baolu

