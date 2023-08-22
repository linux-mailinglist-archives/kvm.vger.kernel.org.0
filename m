Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 17FFC783C1B
	for <lists+kvm@lfdr.de>; Tue, 22 Aug 2023 10:49:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233023AbjHVItT (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 22 Aug 2023 04:49:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59064 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232330AbjHVItR (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 22 Aug 2023 04:49:17 -0400
Received: from mgamail.intel.com (mgamail.intel.com [192.55.52.151])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DE77BE56;
        Tue, 22 Aug 2023 01:48:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1692694135; x=1724230135;
  h=message-id:date:mime-version:cc:subject:to:references:
   from:in-reply-to:content-transfer-encoding;
  bh=V7k1Zg/RPqdwWHATuNXhAjOqDVUVwOY4KgEaXrdvYjc=;
  b=Wc7GdIJ2praf9AaKSoqgbwQB6TwnO7chq/chyfTJ5jB+tYERD5q+ky+m
   RVZeIQzDZu6/goZmJ2YVQ2NyA6tJ5CW6MHiXdbLiUNMaJ8Bcpq0I8GruH
   DZsBLpYO1R76R0fgOP7aNyaxnUQC9WPHwn2nXID8pAldo+XOqCIJOLrP9
   EJ6iipPRf41lVskQxxrv6FqNdIEk1baCnZAh1+/mxJ9Lhaz33tAoxKgjj
   kQgQkE7gQ4VNkC4+BD/wNVt/q/wYPW1P7MLGBwRZhGFmylIB6iyhbuZMY
   ZjHGXCONo1LmWXkULVYOsxaaAamsvvUhSDFjcXGC0TQROStNIv8DnvgZV
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10809"; a="354160593"
X-IronPort-AV: E=Sophos;i="6.01,192,1684825200"; 
   d="scan'208";a="354160593"
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Aug 2023 01:48:04 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10809"; a="713076519"
X-IronPort-AV: E=Sophos;i="6.01,192,1684825200"; 
   d="scan'208";a="713076519"
Received: from blu2-mobl.ccr.corp.intel.com (HELO [10.252.189.107]) ([10.252.189.107])
  by orsmga006-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Aug 2023 01:47:58 -0700
Message-ID: <f67333a7-cfea-f595-90f0-d3e1f18d5b74@linux.intel.com>
Date:   Tue, 22 Aug 2023 16:47:55 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.14.0
Cc:     baolu.lu@linux.intel.com, Joerg Roedel <joro@8bytes.org>,
        Will Deacon <will@kernel.org>,
        Robin Murphy <robin.murphy@arm.com>,
        Kevin Tian <kevin.tian@intel.com>,
        Jean-Philippe Brucker <jean-philippe@linaro.org>,
        Nicolin Chen <nicolinc@nvidia.com>,
        Yi Liu <yi.l.liu@intel.com>,
        Jacob Pan <jacob.jun.pan@linux.intel.com>,
        iommu@lists.linux.dev, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 09/11] iommu: Make iommu_queue_iopf() more generic
Content-Language: en-US
To:     Jason Gunthorpe <jgg@ziepe.ca>
References: <20230817234047.195194-1-baolu.lu@linux.intel.com>
 <20230817234047.195194-10-baolu.lu@linux.intel.com>
 <ZOOauSJpcE2YgIzG@ziepe.ca>
From:   Baolu Lu <baolu.lu@linux.intel.com>
In-Reply-To: <ZOOauSJpcE2YgIzG@ziepe.ca>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-3.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_NONE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 2023/8/22 1:11, Jason Gunthorpe wrote:
> On Fri, Aug 18, 2023 at 07:40:45AM +0800, Lu Baolu wrote:
>> This completely separates the IO page fault handling framework from the
>> SVA implementation. Previously, the SVA implementation was tightly coupled
>> with the IO page fault handling framework. This makes SVA a "customer" of
>> the IO page fault handling framework by converting domain's page fault
>> handler to handle a group of faults and calling it directly from
>> iommu_queue_iopf().
>>
>> Signed-off-by: Lu Baolu <baolu.lu@linux.intel.com>
>> ---
>>   include/linux/iommu.h      |  5 +++--
>>   drivers/iommu/iommu-sva.h  |  8 --------
>>   drivers/iommu/io-pgfault.c | 16 +++++++++++++---
>>   drivers/iommu/iommu-sva.c  | 14 ++++----------
>>   drivers/iommu/iommu.c      |  4 ++--
>>   5 files changed, 22 insertions(+), 25 deletions(-)
>>
>> diff --git a/include/linux/iommu.h b/include/linux/iommu.h
>> index ff292eea9d31..cf1cb0bb46af 100644
>> --- a/include/linux/iommu.h
>> +++ b/include/linux/iommu.h
>> @@ -41,6 +41,7 @@ struct iommu_sva;
>>   struct iommu_fault_event;
>>   struct iommu_dma_cookie;
>>   struct iopf_queue;
>> +struct iopf_group;
>>   
>>   #define IOMMU_FAULT_PERM_READ	(1 << 0) /* read */
>>   #define IOMMU_FAULT_PERM_WRITE	(1 << 1) /* write */
>> @@ -175,8 +176,7 @@ struct iommu_domain {
>>   	unsigned long pgsize_bitmap;	/* Bitmap of page sizes in use */
>>   	struct iommu_domain_geometry geometry;
>>   	struct iommu_dma_cookie *iova_cookie;
>> -	enum iommu_page_response_code (*iopf_handler)(struct iommu_fault *fault,
>> -						      void *data);
>> +	int (*iopf_handler)(struct iopf_group *group);
>>   	void *fault_data;
>>   	union {
>>   		struct {
>> @@ -526,6 +526,7 @@ struct iopf_group {
>>   	struct list_head		faults;
>>   	struct work_struct		work;
>>   	struct device			*dev;
>> +	void				*data;
>>   };
>>   
>>   int iommu_device_register(struct iommu_device *iommu,
>> diff --git a/drivers/iommu/iommu-sva.h b/drivers/iommu/iommu-sva.h
>> index 510a7df23fba..cf41e88fac17 100644
>> --- a/drivers/iommu/iommu-sva.h
>> +++ b/drivers/iommu/iommu-sva.h
>> @@ -22,8 +22,6 @@ int iopf_queue_flush_dev(struct device *dev);
>>   struct iopf_queue *iopf_queue_alloc(const char *name);
>>   void iopf_queue_free(struct iopf_queue *queue);
>>   int iopf_queue_discard_partial(struct iopf_queue *queue);
>> -enum iommu_page_response_code
>> -iommu_sva_handle_iopf(struct iommu_fault *fault, void *data);
>>   void iopf_free_group(struct iopf_group *group);
>>   int iopf_queue_work(struct iopf_group *group, work_func_t func);
>>   int iommu_sva_handle_iopf_group(struct iopf_group *group);
>> @@ -65,12 +63,6 @@ static inline int iopf_queue_discard_partial(struct iopf_queue *queue)
>>   	return -ENODEV;
>>   }
>>   
>> -static inline enum iommu_page_response_code
>> -iommu_sva_handle_iopf(struct iommu_fault *fault, void *data)
>> -{
>> -	return IOMMU_PAGE_RESP_INVALID;
>> -}
>> -
>>   static inline void iopf_free_group(struct iopf_group *group)
>>   {
>>   }
>> diff --git a/drivers/iommu/io-pgfault.c b/drivers/iommu/io-pgfault.c
>> index 00c2e447b740..a61c2aabd1b8 100644
>> --- a/drivers/iommu/io-pgfault.c
>> +++ b/drivers/iommu/io-pgfault.c
>> @@ -11,8 +11,6 @@
>>   #include <linux/slab.h>
>>   #include <linux/workqueue.h>
>>   
>> -#include "iommu-sva.h"
>> -
>>   /**
>>    * struct iopf_queue - IO Page Fault queue
>>    * @wq: the fault workqueue
>> @@ -93,6 +91,7 @@ int iommu_queue_iopf(struct iommu_fault *fault, struct device *dev)
>>   {
>>   	int ret;
>>   	struct iopf_group *group;
>> +	struct iommu_domain *domain;
>>   	struct iopf_fault *iopf, *next;
>>   	struct iommu_fault_param *iopf_param;
>>   	struct dev_iommu *param = dev->iommu;
>> @@ -124,6 +123,16 @@ int iommu_queue_iopf(struct iommu_fault *fault, struct device *dev)
>>   		return 0;
>>   	}
>>   
>> +	if (fault->prm.flags & IOMMU_FAULT_PAGE_REQUEST_PASID_VALID)
>> +		domain = iommu_get_domain_for_dev_pasid(dev, fault->prm.pasid, 0);
>> +	else
>> +		domain = iommu_get_domain_for_dev(dev);
>> +
>> +	if (!domain || !domain->iopf_handler) {
>> +		ret = -ENODEV;
>> +		goto cleanup_partial;
>> +	}
>> +
>>   	group = kzalloc(sizeof(*group), GFP_KERNEL);
>>   	if (!group) {
>>   		/*
>> @@ -137,6 +146,7 @@ int iommu_queue_iopf(struct iommu_fault *fault, struct device *dev)
>>   
>>   	group->dev = dev;
>>   	group->last_fault.fault = *fault;
>> +	group->data = domain->fault_data;
>>   	INIT_LIST_HEAD(&group->faults);
>>   	list_add(&group->last_fault.list, &group->faults);
>>   
>> @@ -147,7 +157,7 @@ int iommu_queue_iopf(struct iommu_fault *fault, struct device *dev)
>>   			list_move(&iopf->list, &group->faults);
>>   	}
>>   
>> -	ret = iommu_sva_handle_iopf_group(group);
>> +	ret = domain->iopf_handler(group);
>>   	if (ret)
>>   		iopf_free_group(group);
>>   
>> diff --git a/drivers/iommu/iommu-sva.c b/drivers/iommu/iommu-sva.c
>> index df8734b6ec00..2811f34947ab 100644
>> --- a/drivers/iommu/iommu-sva.c
>> +++ b/drivers/iommu/iommu-sva.c
>> @@ -148,13 +148,14 @@ EXPORT_SYMBOL_GPL(iommu_sva_get_pasid);
>>   /*
>>    * I/O page fault handler for SVA
>>    */
>> -enum iommu_page_response_code
>> +static enum iommu_page_response_code
>>   iommu_sva_handle_iopf(struct iommu_fault *fault, void *data)
>>   {
>>   	vm_fault_t ret;
>>   	struct vm_area_struct *vma;
>> -	struct mm_struct *mm = data;
>>   	unsigned int access_flags = 0;
>> +	struct iommu_domain *domain = data;
>> +	struct mm_struct *mm = domain->mm;
>>   	unsigned int fault_flags = FAULT_FLAG_REMOTE;
>>   	struct iommu_fault_page_request *prm = &fault->prm;
>>   	enum iommu_page_response_code status = IOMMU_PAGE_RESP_INVALID;
>> @@ -231,23 +232,16 @@ static void iommu_sva_iopf_handler(struct work_struct *work)
>>   {
>>   	struct iopf_fault *iopf;
>>   	struct iopf_group *group;
>> -	struct iommu_domain *domain;
>>   	enum iommu_page_response_code status = IOMMU_PAGE_RESP_SUCCESS;
>>   
>>   	group = container_of(work, struct iopf_group, work);
>> -	domain = iommu_get_domain_for_dev_pasid(group->dev,
>> -				group->last_fault.fault.prm.pasid, 0);
>> -	if (!domain || !domain->iopf_handler)
>> -		status = IOMMU_PAGE_RESP_INVALID;
>> -
>>   	list_for_each_entry(iopf, &group->faults, list) {
>>   		/*
>>   		 * For the moment, errors are sticky: don't handle subsequent
>>   		 * faults in the group if there is an error.
>>   		 */
>>   		if (status == IOMMU_PAGE_RESP_SUCCESS)
>> -			status = domain->iopf_handler(&iopf->fault,
>> -						      domain->fault_data);
>> +			status = iommu_sva_handle_iopf(&iopf->fault, group->data);
>>   	}
>>   
>>   	iommu_sva_complete_iopf(group->dev, &group->last_fault, status);
>> diff --git a/drivers/iommu/iommu.c b/drivers/iommu/iommu.c
>> index b280b9f4d8b4..9b622088c741 100644
>> --- a/drivers/iommu/iommu.c
>> +++ b/drivers/iommu/iommu.c
>> @@ -3395,8 +3395,8 @@ struct iommu_domain *iommu_sva_domain_alloc(struct device *dev,
>>   	domain->type = IOMMU_DOMAIN_SVA;
>>   	mmgrab(mm);
>>   	domain->mm = mm;
>> -	domain->iopf_handler = iommu_sva_handle_iopf;
>> -	domain->fault_data = mm;
>> +	domain->iopf_handler = iommu_sva_handle_iopf_group;
>> +	domain->fault_data = domain;
> 
> Why fault_data? The domain handling the fault should be passed
> through naturally without relying on fault_data.
> 
> eg make
> 
>    iommu_sva_handle_iopf(struct iommu_fault *fault, void *data)
> 
> into
>    iommu_sva_handle_iopf(struct iommu_fault *fault, struct iommu_domain *domain)

See your point now. I will remove "void *data" and move "domain" to
"group->domain".

> 
> And delete domain->fault_data until we have some use for it.

Perhaps we will soon have a use for it.

In the iommufd case, the iommufd iopf handler has a need to retrieve the
hwpt pointer from a domain pointer, right? With the domain->fault_data
pointing to the hwpt, the iopf handler has no need to lookup it in the
critical path.

> 
> The core code should be keeping track of the iommu_domain lifetime.

I added the debugging code in the next patch as you suggested.

Best regards,
baolu
