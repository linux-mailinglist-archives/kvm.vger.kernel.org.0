Return-Path: <kvm+bounces-4136-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 9198F80E2FE
	for <lists+kvm@lfdr.de>; Tue, 12 Dec 2023 04:49:12 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 47FD0282BBD
	for <lists+kvm@lfdr.de>; Tue, 12 Dec 2023 03:49:11 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A55C8BE4D;
	Tue, 12 Dec 2023 03:49:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="hUoevrLQ"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.55.52.136])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 27774EB;
	Mon, 11 Dec 2023 19:48:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1702352939; x=1733888939;
  h=message-id:date:mime-version:cc:subject:to:references:
   from:in-reply-to:content-transfer-encoding;
  bh=4lw2LU6LOzQLXvpddYIS2KQBBXhlHrzxdjByPh7YKzM=;
  b=hUoevrLQMoBGqRxxxrzUVsuZF09qwH4CGvXmnbu3WA+6lKSu0SIlQxGk
   YdQ2NHkHo+sMC21lHF7EehzJeVSZUAujlG+VbHfIS+UXAyaPONFIwOm/y
   RzhWzpBoznrO/9WP5T3ZHig3Y8ybnxGlljW6zXrsPlt3BK6m1ALU1dRG1
   rW1BIMv42rWGbVGARI+iRlu7l+4RCNNxwyIh+iYESwHsLePnLDRZASlGm
   Jk5HWCHqhxx31p+8NQM8BdaUP3osLY98sxWQo4ALyAe6/kGvc3iPe4/j9
   /N4hzDpKnZcWmXon5HlkdRpPEGLaV/JNHujz2boymJMBUIvtZBT5MK5/g
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10921"; a="374255574"
X-IronPort-AV: E=Sophos;i="6.04,269,1695711600"; 
   d="scan'208";a="374255574"
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Dec 2023 19:48:58 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10921"; a="766651530"
X-IronPort-AV: E=Sophos;i="6.04,269,1695711600"; 
   d="scan'208";a="766651530"
Received: from allen-box.sh.intel.com (HELO [10.239.159.127]) ([10.239.159.127])
  by orsmga007.jf.intel.com with ESMTP; 11 Dec 2023 19:48:54 -0800
Message-ID: <62131360-e270-4ea5-92cb-8dd790be8779@linux.intel.com>
Date: Tue, 12 Dec 2023 11:44:14 +0800
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
Subject: Re: [PATCH v8 12/12] iommu: Use refcount for fault data access
Content-Language: en-US
To: Jason Gunthorpe <jgg@ziepe.ca>
References: <20231207064308.313316-1-baolu.lu@linux.intel.com>
 <20231207064308.313316-13-baolu.lu@linux.intel.com>
 <20231211151235.GA1489931@ziepe.ca>
From: Baolu Lu <baolu.lu@linux.intel.com>
In-Reply-To: <20231211151235.GA1489931@ziepe.ca>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 12/11/23 11:12 PM, Jason Gunthorpe wrote:
> On Thu, Dec 07, 2023 at 02:43:08PM +0800, Lu Baolu wrote:
>> +/*
>> + * Return the fault parameter of a device if it exists. Otherwise, return NULL.
>> + * On a successful return, the caller takes a reference of this parameter and
>> + * should put it after use by calling iopf_put_dev_fault_param().
>> + */
>> +static struct iommu_fault_param *iopf_get_dev_fault_param(struct device *dev)
>> +{
>> +	struct dev_iommu *param = dev->iommu;
>> +	struct iommu_fault_param *fault_param;
>> +
>> +	if (!param)
>> +		return NULL;
> 
> Is it actually possible to call this function on a device that does
> not have an iommu driver probed? I'd be surprised by that, maybe this
> should be WARN_ONE

Above check seems to be unnecessary. This helper should only be used
during the iommu probe and release. We can just remove it as any drivers
that abuse this will generate a null-pointer reference warning.

> 
>> +
>> +	rcu_read_lock();
>> +	fault_param = param->fault_param;
> 
> The RCU stuff is not right, like this:
> 
> diff --git a/drivers/iommu/io-pgfault.c b/drivers/iommu/io-pgfault.c
> index 2ace32c6d13bf3..0258f79c8ddf98 100644
> --- a/drivers/iommu/io-pgfault.c
> +++ b/drivers/iommu/io-pgfault.c
> @@ -40,7 +40,7 @@ static struct iommu_fault_param *iopf_get_dev_fault_param(struct device *dev)
>   		return NULL;
>   
>   	rcu_read_lock();
> -	fault_param = param->fault_param;
> +	fault_param = rcu_dereference(param->fault_param);
>   	if (fault_param && !refcount_inc_not_zero(&fault_param->users))
>   		fault_param = NULL;
>   	rcu_read_unlock();
> @@ -51,17 +51,8 @@ static struct iommu_fault_param *iopf_get_dev_fault_param(struct device *dev)
>   /* Caller must hold a reference of the fault parameter. */
>   static void iopf_put_dev_fault_param(struct iommu_fault_param *fault_param)
>   {
> -	struct dev_iommu *param = fault_param->dev->iommu;
> -
> -	rcu_read_lock();
> -	if (!refcount_dec_and_test(&fault_param->users)) {
> -		rcu_read_unlock();
> -		return;
> -	}
> -	rcu_read_unlock();
> -
> -	param->fault_param = NULL;
> -	kfree_rcu(fault_param, rcu);
> +	if (refcount_dec_and_test(&fault_param->users))
> +		kfree_rcu(fault_param, rcu);
>   }
>   
>   /**
> @@ -174,7 +165,7 @@ static int iommu_handle_iopf(struct iommu_fault *fault,
>   	}
>   
>   	mutex_unlock(&iopf_param->lock);
> -	ret = domain->iopf_handler(group);
> +	ret = domain->iopf_handler(iopf_param, group);
>   	mutex_lock(&iopf_param->lock);
>   	if (ret)
>   		iopf_free_group(group);
> @@ -398,7 +389,8 @@ int iopf_queue_add_device(struct iopf_queue *queue, struct device *dev)
>   
>   	mutex_lock(&queue->lock);
>   	mutex_lock(&param->lock);
> -	if (param->fault_param) {
> +	if (rcu_dereference_check(param->fault_param,
> +				  lockdep_is_held(&param->lock))) {
>   		ret = -EBUSY;
>   		goto done_unlock;
>   	}
> @@ -418,7 +410,7 @@ int iopf_queue_add_device(struct iopf_queue *queue, struct device *dev)
>   	list_add(&fault_param->queue_list, &queue->devices);
>   	fault_param->queue = queue;
>   
> -	param->fault_param = fault_param;
> +	rcu_assign_pointer(param->fault_param, fault_param);
>   
>   done_unlock:
>   	mutex_unlock(&param->lock);
> @@ -442,10 +434,12 @@ int iopf_queue_remove_device(struct iopf_queue *queue, struct device *dev)
>   	int ret = 0;
>   	struct iopf_fault *iopf, *next;
>   	struct dev_iommu *param = dev->iommu;
> -	struct iommu_fault_param *fault_param = param->fault_param;
> +	struct iommu_fault_param *fault_param;
>   
>   	mutex_lock(&queue->lock);
>   	mutex_lock(&param->lock);
> +	fault_param = rcu_dereference_check(param->fault_param,
> +					    lockdep_is_held(&param->lock));
>   	if (!fault_param) {
>   		ret = -ENODEV;
>   		goto unlock;
> @@ -467,7 +461,10 @@ int iopf_queue_remove_device(struct iopf_queue *queue, struct device *dev)
>   	list_for_each_entry_safe(iopf, next, &fault_param->partial, list)
>   		kfree(iopf);
>   
> -	iopf_put_dev_fault_param(fault_param);
> +	/* dec the ref owned by iopf_queue_add_device() */
> +	rcu_assign_pointer(param->fault_param, NULL);
> +	if (refcount_dec_and_test(&fault_param->users))
> +		kfree_rcu(fault_param, rcu);
>   unlock:
>   	mutex_unlock(&param->lock);
>   	mutex_unlock(&queue->lock);
> diff --git a/drivers/iommu/iommu-sva.c b/drivers/iommu/iommu-sva.c
> index 325d1810e133a1..63c1a233a7e91f 100644
> --- a/drivers/iommu/iommu-sva.c
> +++ b/drivers/iommu/iommu-sva.c
> @@ -232,10 +232,9 @@ static void iommu_sva_handle_iopf(struct work_struct *work)
>   	iopf_free_group(group);
>   }
>   
> -static int iommu_sva_iopf_handler(struct iopf_group *group)
> +static int iommu_sva_iopf_handler(struct iommu_fault_param *fault_param,
> +				  struct iopf_group *group)
>   {
> -	struct iommu_fault_param *fault_param = group->dev->iommu->fault_param;
> -
>   	INIT_WORK(&group->work, iommu_sva_handle_iopf);
>   	if (!queue_work(fault_param->queue->wq, &group->work))
>   		return -EBUSY;
> diff --git a/include/linux/iommu.h b/include/linux/iommu.h
> index 8020bb44a64ab1..e16fa9811d5023 100644
> --- a/include/linux/iommu.h
> +++ b/include/linux/iommu.h
> @@ -41,6 +41,7 @@ struct iommu_dirty_ops;
>   struct notifier_block;
>   struct iommu_sva;
>   struct iommu_dma_cookie;
> +struct iommu_fault_param;
>   
>   #define IOMMU_FAULT_PERM_READ	(1 << 0) /* read */
>   #define IOMMU_FAULT_PERM_WRITE	(1 << 1) /* write */
> @@ -210,7 +211,8 @@ struct iommu_domain {
>   	unsigned long pgsize_bitmap;	/* Bitmap of page sizes in use */
>   	struct iommu_domain_geometry geometry;
>   	struct iommu_dma_cookie *iova_cookie;
> -	int (*iopf_handler)(struct iopf_group *group);
> +	int (*iopf_handler)(struct iommu_fault_param *fault_param,
> +			    struct iopf_group *group);

How about folding fault_param into iopf_group?

iopf_group is the central data around a iopf handling. The iopf_group
holds the reference count of the device's fault parameter structure
throughout its entire lifecycle.

>   	void *fault_data;
>   	union {
>   		struct {
> @@ -637,7 +639,7 @@ struct iommu_fault_param {
>    */
>   struct dev_iommu {
>   	struct mutex lock;
> -	struct iommu_fault_param	*fault_param;
> +	struct iommu_fault_param __rcu	*fault_param;
>   	struct iommu_fwspec		*fwspec;
>   	struct iommu_device		*iommu_dev;
>   	void				*priv;

The iommu_page_response() needs to change accordingly which is pointed
out in the next email.

Others look good to me. Thank you so much!

Best regards,
baolu

