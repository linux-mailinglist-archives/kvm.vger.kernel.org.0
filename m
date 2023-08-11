Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6914077855C
	for <lists+kvm@lfdr.de>; Fri, 11 Aug 2023 04:22:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231962AbjHKCV4 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 10 Aug 2023 22:21:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37986 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229475AbjHKCVz (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 10 Aug 2023 22:21:55 -0400
Received: from mgamail.intel.com (mgamail.intel.com [192.55.52.88])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1A1962724;
        Thu, 10 Aug 2023 19:21:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1691720515; x=1723256515;
  h=message-id:date:mime-version:cc:subject:to:references:
   from:in-reply-to:content-transfer-encoding;
  bh=HAP/eskbsc+N4M5VFl3LLuJJfEKwbBGpcJbMA/EsezE=;
  b=BrD2zj2kOzAa5Te+xisUjmj5q5qFhP5KJkh97PWYHlJdPe444aq9l6TK
   sADiRKVA7M114RYWrBRpOHQbkOEXDxbs1qKbrlGim9Q4TFUKWuUxDT+8f
   TXD3ZWhv2r2jiC8Tt3RuOnAP3ZR7bZo3vIC2ns4txBXrPIq7NxApevBEN
   sqmcfm2OvgHNQ8+9og8zboIqhJjOeFX2+rfST2y7dj+9flp9JM3z0lD3U
   lZLJhfj1x6d5XfuM2TxZBAZ5yNj7DFIfcfTF6WLvoRq3Zstv510D7qtJh
   y2RRigrABBuIF91eGpLfz/Zn0X5TwqDa3SUAaiK/kj4T5g5YC+xFiMlq4
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10798"; a="402544075"
X-IronPort-AV: E=Sophos;i="6.01,164,1684825200"; 
   d="scan'208";a="402544075"
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Aug 2023 19:21:26 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10798"; a="822499274"
X-IronPort-AV: E=Sophos;i="6.01,164,1684825200"; 
   d="scan'208";a="822499274"
Received: from chenglei-mobl2.ccr.corp.intel.com (HELO [10.254.214.65]) ([10.254.214.65])
  by fmsmga003-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Aug 2023 19:21:22 -0700
Message-ID: <7fc396d5-e2bd-b126-b3a6-88f8033c14b4@linux.intel.com>
Date:   Fri, 11 Aug 2023 10:21:20 +0800
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
Subject: Re: [PATCH v2 10/12] iommu: Make iommu_queue_iopf() more generic
To:     Jason Gunthorpe <jgg@ziepe.ca>
References: <20230727054837.147050-1-baolu.lu@linux.intel.com>
 <20230727054837.147050-11-baolu.lu@linux.intel.com>
 <ZNU1Zev6j92IJRjn@ziepe.ca>
Content-Language: en-US
From:   Baolu Lu <baolu.lu@linux.intel.com>
In-Reply-To: <ZNU1Zev6j92IJRjn@ziepe.ca>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-6.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 2023/8/11 3:07, Jason Gunthorpe wrote:
> On Thu, Jul 27, 2023 at 01:48:35PM +0800, Lu Baolu wrote:
>> @@ -137,6 +136,16 @@ int iommu_queue_iopf(struct iommu_fault *fault, struct device *dev)
>>   		return 0;
>>   	}
>>   
>> +	if (fault->prm.flags & IOMMU_FAULT_PAGE_REQUEST_PASID_VALID)
>> +		domain = iommu_get_domain_for_dev_pasid(dev, fault->prm.pasid, 0);
>> +	else
>> +		domain = iommu_get_domain_for_dev(dev);
> 
> How does the lifetime work for this? What prevents UAF on domain?

Replied below.

> 
>> diff --git a/drivers/iommu/iommu-sva.c b/drivers/iommu/iommu-sva.c
>> index ab42cfdd7636..668f4c2bcf65 100644
>> --- a/drivers/iommu/iommu-sva.c
>> +++ b/drivers/iommu/iommu-sva.c
>> @@ -157,7 +157,7 @@ EXPORT_SYMBOL_GPL(iommu_sva_get_pasid);
>>   /*
>>    * I/O page fault handler for SVA
>>    */
>> -enum iommu_page_response_code
>> +static enum iommu_page_response_code
>>   iommu_sva_handle_iopf(struct iommu_fault *fault, void *data)
>>   {
>>   	vm_fault_t ret;
>> @@ -241,23 +241,16 @@ static void iopf_handler(struct work_struct *work)
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
>>   	iopf_complete_group(group->dev, &group->last_fault, status);
>> diff --git a/drivers/iommu/iommu.c b/drivers/iommu/iommu.c
>> index 157a28a49473..535a36e3edc9 100644
>> --- a/drivers/iommu/iommu.c
>> +++ b/drivers/iommu/iommu.c
>> @@ -3330,7 +3330,7 @@ struct iommu_domain *iommu_sva_domain_alloc(struct device *dev,
>>   	domain->type = IOMMU_DOMAIN_SVA;
>>   	mmgrab(mm);
>>   	domain->mm = mm;
>> -	domain->iopf_handler = iommu_sva_handle_iopf;
>> +	domain->iopf_handler = iommu_sva_handle_iopf_group;
>>   	domain->fault_data = mm;
> 
> This also has lifetime problems on the mm.
> 
> The domain should flow into the iommu_sva_handle_iopf() instead of the
> void *data.

Okay, but I still want to keep void *data as a private pointer of the
iopf consumer. For SVA, it's probably NULL.

> 
> The SVA code can then just use domain->mm directly.

Yes.

> 
> We need to document/figure out some how to ensure that the faults are
> all done processing before a fault enabled domain can be freed.

This has been documented in drivers/iommu/io-pgfault.c:

[...]
  * Any valid page fault will be eventually routed to an iommu domain 
and the
  * page fault handler installed there will get called. The users of this
  * handling framework should guarantee that the iommu domain could only be
  * freed after the device has stopped generating page faults (or the iommu
  * hardware has been set to block the page faults) and the pending page 
faults
  * have been flushed.
  *
  * Return: 0 on success and <0 on error.
  */
int iommu_queue_iopf(struct iommu_fault *fault, void *cookie)
[...]

> This patch would be better ordered before the prior patch.

Let me try this in the next version.

Best regards,
baolu


