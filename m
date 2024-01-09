Return-Path: <kvm+bounces-5862-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 93A23827D01
	for <lists+kvm@lfdr.de>; Tue,  9 Jan 2024 03:53:11 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 928181C23404
	for <lists+kvm@lfdr.de>; Tue,  9 Jan 2024 02:53:10 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 357A833EE;
	Tue,  9 Jan 2024 02:53:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="jjdx1tjv"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.9])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 56DED5390;
	Tue,  9 Jan 2024 02:52:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1704768778; x=1736304778;
  h=message-id:date:mime-version:cc:subject:to:references:
   from:in-reply-to:content-transfer-encoding;
  bh=UArfAUbovcI7fB2bfs6Ng4TVNlajHZ5AT7kwEtscyUg=;
  b=jjdx1tjvfHfTH+kkGtl6BsNAydiNm1thk1R3ntqMRuJvrI0xW0PDl/Yc
   lqrNnzcY/xvv3Dl3Ykccqw4xPSwOLliomTroBANablAUCjVid9Rzw4/Wf
   4uoL1JdlN8WynpxZ3FL6HN+5qQrCrRdE155tSUwLgLc3cZIyxYCRAp58F
   5SXrbxmq13/8xpkkQsyPtrU0JkRLlmcF2f+76gfeYD3h35I/b9VY8DrLt
   vjMYHBnXok3eTVSRdeLpzd09lhZUiDmWhGCtS72ejBtvxnNumUMmk2QDl
   fXNsvA1kitQJHyCYCmVOO7PLDTomWuFPTLkjiUxDn018a8Ci3D1BM6A8Q
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10947"; a="4844584"
X-IronPort-AV: E=Sophos;i="6.04,181,1695711600"; 
   d="scan'208";a="4844584"
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by fmvoesa103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Jan 2024 18:52:57 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10947"; a="905002419"
X-IronPort-AV: E=Sophos;i="6.04,181,1695711600"; 
   d="scan'208";a="905002419"
Received: from allen-box.sh.intel.com (HELO [10.239.159.127]) ([10.239.159.127])
  by orsmga004.jf.intel.com with ESMTP; 08 Jan 2024 18:52:53 -0800
Message-ID: <8071d34f-e247-41b4-bd50-f68e58d84902@linux.intel.com>
Date: Tue, 9 Jan 2024 10:47:40 +0800
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
Subject: Re: [PATCH v9 12/14] iommu: Use refcount for fault data access
To: Jason Gunthorpe <jgg@ziepe.ca>
References: <20231220012332.168188-1-baolu.lu@linux.intel.com>
 <20231220012332.168188-13-baolu.lu@linux.intel.com>
 <20240105160913.GG50608@ziepe.ca>
Content-Language: en-US
From: Baolu Lu <baolu.lu@linux.intel.com>
In-Reply-To: <20240105160913.GG50608@ziepe.ca>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 1/6/24 12:09 AM, Jason Gunthorpe wrote:
> On Wed, Dec 20, 2023 at 09:23:30AM +0800, Lu Baolu wrote:
>> The per-device fault data structure stores information about faults
>> occurring on a device. Its lifetime spans from IOPF enablement to
>> disablement. Multiple paths, including IOPF reporting, handling, and
>> responding, may access it concurrently.
>>
>> Previously, a mutex protected the fault data from use after free. But
>> this is not performance friendly due to the critical nature of IOPF
>> handling paths.
>>
>> Refine this with a refcount-based approach. The fault data pointer is
>> obtained within an RCU read region with a refcount. The fault data
>> pointer is returned for usage only when the pointer is valid and a
>> refcount is successfully obtained. The fault data is freed with
>> kfree_rcu(), ensuring data is only freed after all RCU critical regions
>> complete.
>>
>> An iopf handling work starts once an iopf group is created. The handling
>> work continues until iommu_page_response() is called to respond to the
>> iopf and the iopf group is freed. During this time, the device fault
>> parameter should always be available. Add a pointer to the device fault
>> parameter in the iopf_group structure and hold the reference until the
>> iopf_group is freed.
>>
>> Make iommu_page_response() static as it is only used in io-pgfault.c.
>>
>> Co-developed-by: Jason Gunthorpe <jgg@nvidia.com>
>> Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
>> Signed-off-by: Lu Baolu <baolu.lu@linux.intel.com>
>> Tested-by: Yan Zhao <yan.y.zhao@intel.com>
>> ---
>>   include/linux/iommu.h      |  17 +++--
>>   drivers/iommu/io-pgfault.c | 129 +++++++++++++++++++++++--------------
>>   drivers/iommu/iommu-sva.c  |   2 +-
>>   3 files changed, 90 insertions(+), 58 deletions(-)
> 
> This looks basically Ok
> 
>> +/* Caller must hold a reference of the fault parameter. */
>> +static void iopf_put_dev_fault_param(struct iommu_fault_param *fault_param)
>> +{
>> +	if (refcount_dec_and_test(&fault_param->users))
>> +		kfree_rcu(fault_param, rcu);
>> +}
> 
> [..]
> 
>> @@ -402,10 +429,12 @@ int iopf_queue_add_device(struct iopf_queue *queue, struct device *dev)
>>   	INIT_LIST_HEAD(&fault_param->faults);
>>   	INIT_LIST_HEAD(&fault_param->partial);
>>   	fault_param->dev = dev;
>> +	refcount_set(&fault_param->users, 1);
>> +	init_rcu_head(&fault_param->rcu);
> 
> No need to do init_rcu_head() when only using it for calling
> kfree_rcu()

Removed.

> 
>> @@ -454,8 +485,10 @@ int iopf_queue_remove_device(struct iopf_queue *queue, struct device *dev)
>>   	list_for_each_entry_safe(iopf, next, &fault_param->partial, list)
>>   		kfree(iopf);
>>   
>> -	param->fault_param = NULL;
>> -	kfree(fault_param);
>> +	/* dec the ref owned by iopf_queue_add_device() */
>> +	rcu_assign_pointer(param->fault_param, NULL);
>> +	if (refcount_dec_and_test(&fault_param->users))
>> +		kfree_rcu(fault_param, rcu);
> 
> Why open code iopf_put_dev_fault_param()? Just call it.

Done.

> 
> With those:
> 
> Reviewed-by: Jason Gunthorpe <jgg@nvidia.com>
> 
> Jason

Thank you very much!

Best regards,
baolu


