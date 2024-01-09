Return-Path: <kvm+bounces-5863-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id C85DD827D6C
	for <lists+kvm@lfdr.de>; Tue,  9 Jan 2024 04:41:49 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 7742A284C12
	for <lists+kvm@lfdr.de>; Tue,  9 Jan 2024 03:41:48 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 15E7353A4;
	Tue,  9 Jan 2024 03:41:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="agEMEu1T"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.9])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F02DD3D86;
	Tue,  9 Jan 2024 03:41:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1704771697; x=1736307697;
  h=message-id:date:mime-version:cc:subject:to:references:
   from:in-reply-to:content-transfer-encoding;
  bh=0LdLdd5VFFhLorx8pbQnlS22X5wJJoCIwyGO5I6Dq9A=;
  b=agEMEu1TNril1O3jlbBCjBr6ne98c9odINZ2FWUST+vjAwn6MdnqMiBg
   xoIp3BdOMd2ziVK14cKmRuEUl4knqkFw4Pz+zyiKKIhgRIFNAhHw2KOxc
   M/dsnd0sncJkBW/g6C/EX3CTv3ofiXlXNy+70LD9LU2VSovKxjCl6J87T
   OD0mK1qNC6pZzqRaLUwhc/eTOXy+LHmfbAsswL8hVkELA8QoXUfFxCCuM
   Hhzw+Doz1zFMwNLmqlhRnxFio93vdumvO1BSenQrprpvkORhCy+pJSDGH
   0NSANstjXGkJtkfb0hApieXATjvlAQGRsj6Rrbl9E3DG/UetUF+VZ0xJT
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10947"; a="16667563"
X-IronPort-AV: E=Sophos;i="6.04,181,1695711600"; 
   d="scan'208";a="16667563"
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by orvoesa101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Jan 2024 19:41:36 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10947"; a="852024581"
X-IronPort-AV: E=Sophos;i="6.04,181,1695711600"; 
   d="scan'208";a="852024581"
Received: from allen-box.sh.intel.com (HELO [10.239.159.127]) ([10.239.159.127])
  by fmsmga004.fm.intel.com with ESMTP; 08 Jan 2024 19:41:32 -0800
Message-ID: <91c2add2-3015-4935-9dd5-d4e42aff473a@linux.intel.com>
Date: Tue, 9 Jan 2024 11:36:19 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Cc: baolu.lu@linux.intel.com, Joerg Roedel <joro@8bytes.org>,
 Will Deacon <will@kernel.org>, Robin Murphy <robin.murphy@arm.com>,
 Kevin Tian <kevin.tian@intel.com>,
 Jean-Philippe Brucker <jean-philippe@linaro.org>,
 Nicolin Chen <nicolinc@nvidia.com>, Yi Liu <yi.l.liu@intel.com>,
 Jacob Pan <jacob.jun.pan@linux.intel.com>,
 Longfang Liu <liulongfang@huawei.com>, Yan Zhao <yan.y.zhao@intel.com>,
 iommu@lists.linux.dev, kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v9 13/14] iommu: Improve iopf_queue_remove_device()
Content-Language: en-US
To: Jason Gunthorpe <jgg@ziepe.ca>
References: <20231220012332.168188-1-baolu.lu@linux.intel.com>
 <20231220012332.168188-14-baolu.lu@linux.intel.com>
 <20240105162540.GH50608@ziepe.ca>
From: Baolu Lu <baolu.lu@linux.intel.com>
In-Reply-To: <20240105162540.GH50608@ziepe.ca>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 1/6/24 12:25 AM, Jason Gunthorpe wrote:
> On Wed, Dec 20, 2023 at 09:23:31AM +0800, Lu Baolu wrote:
>> -int iopf_queue_remove_device(struct iopf_queue *queue, struct device *dev)
>> +void iopf_queue_remove_device(struct iopf_queue *queue, struct device *dev)
>>   {
>> -	int ret = 0;
>>   	struct iopf_fault *iopf, *next;
>> +	struct iommu_page_response resp;
>>   	struct dev_iommu *param = dev->iommu;
>>   	struct iommu_fault_param *fault_param;
>> +	const struct iommu_ops *ops = dev_iommu_ops(dev);
>>   
>>   	mutex_lock(&queue->lock);
>>   	mutex_lock(&param->lock);
>>   	fault_param = rcu_dereference_check(param->fault_param,
>>   					    lockdep_is_held(&param->lock));
>> -	if (!fault_param) {
>> -		ret = -ENODEV;
>> -		goto unlock;
>> -	}
>> -
>> -	if (fault_param->queue != queue) {
>> -		ret = -EINVAL;
>> -		goto unlock;
>> -	}
>>   
>> -	if (!list_empty(&fault_param->faults)) {
>> -		ret = -EBUSY;
>> +	if (WARN_ON(!fault_param || fault_param->queue != queue))
>>   		goto unlock;
>> -	}
>> -
>> -	list_del(&fault_param->queue_list);
>>   
>> -	/* Just in case some faults are still stuck */
>> +	mutex_lock(&fault_param->lock);
>>   	list_for_each_entry_safe(iopf, next, &fault_param->partial, list)
>>   		kfree(iopf);
>>   
>> +	list_for_each_entry_safe(iopf, next, &fault_param->faults, list) {
>> +		memset(&resp, 0, sizeof(struct iommu_page_response));
>> +		resp.pasid = iopf->fault.prm.pasid;
>> +		resp.grpid = iopf->fault.prm.grpid;
>> +		resp.code = IOMMU_PAGE_RESP_INVALID;
> 
> I would probably move the resp and iopf variables into here:
> 
> 		struct iopf_fault *iopf = &group->last_fault;
> 		struct iommu_page_response resp = {
> 			.pasid = iopf->fault.prm.pasid,
> 			.grpid = iopf->fault.prm.grpid,
> 			.code = IOMMU_PAGE_RESP_INVALID
> 		};
> 
> (and call the other one partial_iopf)

Yours looks better. Done.

> 
> But this looks fine either way
> 
> Reviewed-by: Jason Gunthorpe <jgg@nvidia.com>

Thank you very much!

Best regards,
baolu

