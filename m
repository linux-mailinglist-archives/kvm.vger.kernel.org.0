Return-Path: <kvm+bounces-3280-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 252388029AD
	for <lists+kvm@lfdr.de>; Mon,  4 Dec 2023 02:03:04 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 547CF1C20404
	for <lists+kvm@lfdr.de>; Mon,  4 Dec 2023 01:03:03 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0AF57A49;
	Mon,  4 Dec 2023 01:02:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="N5E2+top"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.55.52.88])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EEEA1D7;
	Sun,  3 Dec 2023 17:02:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1701651771; x=1733187771;
  h=message-id:date:mime-version:cc:subject:to:references:
   from:in-reply-to:content-transfer-encoding;
  bh=/HuHnYJELZ3s+Pg2jAz1DP57zcUQSq+bWviBQSQi96k=;
  b=N5E2+top27vVKlKN+wlezayPzxcBdEAwNHtWzvIr/M95ELBUyJTh9C6U
   A9UprC/b3x5zZSg1swvHjXUWxImOO+6a+AYezGGzRxk9vp7a+BehlYga0
   qQOBsuk69nPzxdIOfQeHkjnoUjpSpjTVg74dpOb5et8HhOf75J3PL4Oaz
   LltmuQJf++RnBXLrBrMVE/bW3qArVAIK/CDUxMZdW3YxmeILM5w3UFPSe
   Xu7pGwIBT/+YCyw1ihC1i20Rlq36rSEdFqnSEbMUln0v1BFQKcK4my3yL
   jTAUzA/9e3t7Q30VLmI0EJ99HqR3v3pP1yPJG5By4nWZJyV2matHmf2G0
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10913"; a="424834469"
X-IronPort-AV: E=Sophos;i="6.04,248,1695711600"; 
   d="scan'208";a="424834469"
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Dec 2023 17:02:43 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10913"; a="774101136"
X-IronPort-AV: E=Sophos;i="6.04,248,1695711600"; 
   d="scan'208";a="774101136"
Received: from allen-box.sh.intel.com (HELO [10.239.159.127]) ([10.239.159.127])
  by fmsmga007.fm.intel.com with ESMTP; 03 Dec 2023 17:02:39 -0800
Message-ID: <1b82e10f-bf5c-4fca-b558-ce2e4fe9f128@linux.intel.com>
Date: Mon, 4 Dec 2023 08:58:07 +0800
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
 Jacob Pan <jacob.jun.pan@linux.intel.com>, Yan Zhao <yan.y.zhao@intel.com>,
 iommu@lists.linux.dev, kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v7 11/12] iommu: Consolidate per-device fault data
 management
Content-Language: en-US
To: Jason Gunthorpe <jgg@ziepe.ca>
References: <20231115030226.16700-1-baolu.lu@linux.intel.com>
 <20231115030226.16700-12-baolu.lu@linux.intel.com>
 <20231201194602.GF1489931@ziepe.ca>
From: Baolu Lu <baolu.lu@linux.intel.com>
In-Reply-To: <20231201194602.GF1489931@ziepe.ca>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 12/2/23 3:46 AM, Jason Gunthorpe wrote:
> On Wed, Nov 15, 2023 at 11:02:25AM +0800, Lu Baolu wrote:
> 
>> diff --git a/include/linux/iommu.h b/include/linux/iommu.h
>> index d19031c1b0e6..c17d5979d70d 100644
>> --- a/include/linux/iommu.h
>> +++ b/include/linux/iommu.h
>> @@ -597,6 +597,8 @@ struct iommu_device {
>>   /**
>>    * struct iommu_fault_param - per-device IOMMU fault data
>>    * @lock: protect pending faults list
>> + * @users: user counter to manage the lifetime of the data, this field
>> + *         is protected by dev->iommu->lock.
>>    * @dev: the device that owns this param
>>    * @queue: IOPF queue
>>    * @queue_list: index into queue->devices
>> @@ -606,6 +608,7 @@ struct iommu_device {
>>    */
>>   struct iommu_fault_param {
>>   	struct mutex lock;
>> +	int users;
> 
> Use refcount_t for the debugging features

Yes.

> 
>>   	struct device *dev;
>>   	struct iopf_queue *queue;
> 
> But why do we need this to be refcounted? iopf_queue_remove_device()
> is always called before we get to release? This struct isn't very big
> so I'd just leave it allocated and free it during release?

iopf_queue_remove_device() should always be called before device
release.

The reference counter is implemented to synchronize access to the fault
parameter among different paths. For example, iopf_queue_remove_device()
removes the parameter, while iommu_report_device_fault() and
iommu_page_response() have needs to reference it. These three paths
could possibly happen in different threads.

> 
>> @@ -72,23 +115,14 @@ static int iommu_handle_iopf(struct iommu_fault *fault, struct device *dev)
>>   	struct iopf_group *group;
>>   	struct iopf_fault *iopf, *next;
>>   	struct iommu_domain *domain = NULL;
>> -	struct iommu_fault_param *iopf_param;
>> -	struct dev_iommu *param = dev->iommu;
>> +	struct iommu_fault_param *iopf_param = dev->iommu->fault_param;
>>   
>> -	lockdep_assert_held(&param->lock);
>> +	lockdep_assert_held(&iopf_param->lock);
> 
> This patch seems like it is doing a few things, can the locking
> changes be kept in their own patch?

Yes. Let me try to.

Best regards,
baolu

