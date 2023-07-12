Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 42A7C74FD1D
	for <lists+kvm@lfdr.de>; Wed, 12 Jul 2023 04:37:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231758AbjGLChR (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 11 Jul 2023 22:37:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44224 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231528AbjGLChM (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 11 Jul 2023 22:37:12 -0400
Received: from mga18.intel.com (mga18.intel.com [134.134.136.126])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A8BEF1733;
        Tue, 11 Jul 2023 19:37:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1689129431; x=1720665431;
  h=message-id:date:mime-version:cc:subject:to:references:
   from:in-reply-to:content-transfer-encoding;
  bh=iMf8JNcoSyGQ7ckXfjvHnpCeOzm0RVCB8bPfuDgzuMc=;
  b=YR2WvjwcgdqY7aMBWt5FMN1Wk+9qfVcpNQDhBqNAzSQHggHbU3z0jMQa
   7BndTDwhwc3sO+lo9DfepVb0/GTycV7ZkFZf+69uDTDtyqt5IPI5Le11i
   MXbTzg903kOnncccOm8/Lweg+86nZh22N+8Mkoe1SPWK40LmVLt/YKVgr
   WsovUj3kax0TZF1lB+30D+jQounwmqp3t+pGh8eEPx87bTl4jdJEeiya6
   D+SDy3/oemvKUcCkTU1Mxmyw2CzUL+JbheXAVxl2XVuZv0EXwCGuZdeYz
   PtopMtwsCsgRNRMxu1u6nKkti0MphqjkDtguZo5X7Ki1WDEm1Ym+YZ23k
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10768"; a="349636888"
X-IronPort-AV: E=Sophos;i="6.01,198,1684825200"; 
   d="scan'208";a="349636888"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Jul 2023 19:37:11 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10768"; a="751003044"
X-IronPort-AV: E=Sophos;i="6.01,198,1684825200"; 
   d="scan'208";a="751003044"
Received: from blu2-mobl.ccr.corp.intel.com (HELO [10.252.187.60]) ([10.252.187.60])
  by orsmga008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Jul 2023 19:37:06 -0700
Message-ID: <0438aba6-650b-9b9f-21d1-dc355759fd65@linux.intel.com>
Date:   Wed, 12 Jul 2023 10:37:03 +0800
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
Subject: Re: [PATCH 3/9] iommu: Add common code to handle IO page faults
Content-Language: en-US
To:     Jacob Pan <jacob.jun.pan@linux.intel.com>
References: <20230711010642.19707-1-baolu.lu@linux.intel.com>
 <20230711010642.19707-4-baolu.lu@linux.intel.com>
 <20230711135056.4b1fd94a@jacob-builder>
From:   Baolu Lu <baolu.lu@linux.intel.com>
In-Reply-To: <20230711135056.4b1fd94a@jacob-builder>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 2023/7/12 4:50, Jacob Pan wrote:
> Hi Lu,
> 
> On Tue, 11 Jul 2023 09:06:36 +0800, Lu Baolu <baolu.lu@linux.intel.com>
> wrote:
> 
>> The individual iommu drivers report iommu faults by calling
>> iommu_report_device_fault(), where a pre-registered device fault handler
>> is called to route the fault to another fault handler installed on the
>> corresponding iommu domain.
>>
>> The pre-registered device fault handler is static and won't be dynamic
>> as the fault handler is eventually per iommu domain. Replace the device
>> fault handler with a static common code to avoid unnecessary code.
>>
>> Signed-off-by: Lu Baolu <baolu.lu@linux.intel.com>
>> ---
>>   drivers/iommu/iommu.c | 24 +++++++++++++++++++++++-
>>   1 file changed, 23 insertions(+), 1 deletion(-)
>>
>> diff --git a/drivers/iommu/iommu.c b/drivers/iommu/iommu.c
>> index da340f11c5f5..41328f03e8b4 100644
>> --- a/drivers/iommu/iommu.c
>> +++ b/drivers/iommu/iommu.c
>> @@ -1278,6 +1278,28 @@ int iommu_unregister_device_fault_handler(struct
>> device *dev) }
>>   EXPORT_SYMBOL_GPL(iommu_unregister_device_fault_handler);
>>   
>> +static int iommu_handle_io_pgfault(struct device *dev,
>> +				   struct iommu_fault *fault)
>> +{
>> +	struct iommu_domain *domain;
>> +
>> +	if (fault->type != IOMMU_FAULT_PAGE_REQ)
>> +		return -EINVAL;
>> +
>> +	if (fault->prm.flags & IOMMU_FAULT_PAGE_REQUEST_PASID_VALID)
>> +		domain = iommu_get_domain_for_dev_pasid(dev,
>> fault->prm.pasid, 0);
>> +	else
>> +		domain = iommu_get_domain_for_dev(dev);
> we don't support IOPF w/o PASID yet, right?

It's the individual driver that decides whether iopf w/o pasid is
supported or not. The iommu core doesn't need to make such assumption.

> 
>> +
>> +	if (!domain || !domain->iopf_handler)
>> +		return -ENODEV;
>> +
>> +	if (domain->iopf_handler == iommu_sva_handle_iopf)
>> +		return iommu_queue_iopf(fault, dev);
> Just wondering why have a special treatment for SVA domain. Can
> iommu_queue_iopf() be used as SVA domain->iopf_handler?

Yes. I will make this change according to Kevin's suggestion in this
thread.

> 
>> +
>> +	return domain->iopf_handler(fault, dev, domain->fault_data);
>> +}
>> +
>>   /**
>>    * iommu_report_device_fault() - Report fault event to device driver
>>    * @dev: the device
>> @@ -1320,7 +1342,7 @@ int iommu_report_device_fault(struct device *dev,
>> struct iommu_fault_event *evt) mutex_unlock(&fparam->lock);
>>   	}
>>   
>> -	ret = fparam->handler(&evt->fault, fparam->data);
>> +	ret = iommu_handle_io_pgfault(dev, &evt->fault);
>>   	if (ret && evt_pending) {
>>   		mutex_lock(&fparam->lock);
>>   		list_del(&evt_pending->list);
> 
> 
> Thanks,
> 
> Jacob
> 

Best regards,
baolu
