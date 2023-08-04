Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2367A76F860
	for <lists+kvm@lfdr.de>; Fri,  4 Aug 2023 05:28:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231187AbjHDD2Q (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 3 Aug 2023 23:28:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44830 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233619AbjHDD1j (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 3 Aug 2023 23:27:39 -0400
Received: from mgamail.intel.com (mgamail.intel.com [192.55.52.120])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 47EFA49F4;
        Thu,  3 Aug 2023 20:26:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1691119616; x=1722655616;
  h=message-id:date:mime-version:cc:subject:to:references:
   from:in-reply-to:content-transfer-encoding;
  bh=EqZyWhqIaB1YDuLhQBEaeAoycLm9r9oWm431mXQD3iE=;
  b=jJ480MAiN53a8Ho3YgDcDK+OlCu5n1Uen8Raq2cG0Zz/D5Er/TXAI0rc
   gbVLru+dP7tyO7FbidcaR8O1tP4bPYzfMm61NO/oiRPkIhLnKw1X658xX
   Xqf2gXoD8pH2muIue/JfEalJ/IKAZ7P4nPx/VoJ2k7roP/R+2kzoStni9
   SqBAjOi/l7NmaQsGG137fYXdY7X1LNW/Fy91RiFL7WuqCNbq4d1di4Xic
   77Fnp0WwUOy5ch2G4puDPX/1rA7Q4IosWN3ObF0VmQH6sXUeHDnCxkzR4
   cv2uZN29ERqFt41ShaBubsqjBmBjdpny3QPL2VnI57F5ui8Cb5dMsI1mD
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10791"; a="368955832"
X-IronPort-AV: E=Sophos;i="6.01,253,1684825200"; 
   d="scan'208";a="368955832"
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Aug 2023 20:26:55 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10791"; a="679741945"
X-IronPort-AV: E=Sophos;i="6.01,253,1684825200"; 
   d="scan'208";a="679741945"
Received: from blu2-mobl.ccr.corp.intel.com (HELO [10.254.210.88]) ([10.254.210.88])
  by orsmga003-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Aug 2023 20:26:52 -0700
Message-ID: <7763e467-c27f-cfc7-d11d-f25b0761faeb@linux.intel.com>
Date:   Fri, 4 Aug 2023 11:26:50 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.13.0
Cc:     baolu.lu@linux.intel.com, "Liu, Yi L" <yi.l.liu@intel.com>,
        Jacob Pan <jacob.jun.pan@linux.intel.com>,
        "iommu@lists.linux.dev" <iommu@lists.linux.dev>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2 08/12] iommu: Prepare for separating SVA and IOPF
Content-Language: en-US
To:     "Tian, Kevin" <kevin.tian@intel.com>,
        Joerg Roedel <joro@8bytes.org>, Will Deacon <will@kernel.org>,
        Robin Murphy <robin.murphy@arm.com>,
        Jason Gunthorpe <jgg@ziepe.ca>,
        Jean-Philippe Brucker <jean-philippe@linaro.org>,
        Nicolin Chen <nicolinc@nvidia.com>
References: <20230727054837.147050-1-baolu.lu@linux.intel.com>
 <20230727054837.147050-9-baolu.lu@linux.intel.com>
 <BN9PR11MB52769D22490BB09BB25E0C2E8C08A@BN9PR11MB5276.namprd11.prod.outlook.com>
From:   Baolu Lu <baolu.lu@linux.intel.com>
In-Reply-To: <BN9PR11MB52769D22490BB09BB25E0C2E8C08A@BN9PR11MB5276.namprd11.prod.outlook.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE,
        URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 2023/8/3 16:16, Tian, Kevin wrote:
>> From: Lu Baolu <baolu.lu@linux.intel.com>
>> Sent: Thursday, July 27, 2023 1:49 PM
>>
>> @@ -82,7 +82,7 @@ static void iopf_handler(struct work_struct *work)
>>   	if (!domain || !domain->iopf_handler)
>>   		status = IOMMU_PAGE_RESP_INVALID;
>>
>> -	list_for_each_entry_safe(iopf, next, &group->faults, list) {
>> +	list_for_each_entry(iopf, &group->faults, list) {
>>   		/*
>>   		 * For the moment, errors are sticky: don't handle
>> subsequent
>>   		 * faults in the group if there is an error.
>> @@ -90,14 +90,20 @@ static void iopf_handler(struct work_struct *work)
>>   		if (status == IOMMU_PAGE_RESP_SUCCESS)
>>   			status = domain->iopf_handler(&iopf->fault,
>>   						      domain->fault_data);
>> -
>> -		if (!(iopf->fault.prm.flags &
>> -		      IOMMU_FAULT_PAGE_REQUEST_LAST_PAGE))
>> -			kfree(iopf);
>>   	}
>>
>>   	iopf_complete_group(group->dev, &group->last_fault, status);
>> -	kfree(group);
>> +	iopf_free_group(group);
>> +}
> 
> this is perf-critical path. It's not good to traverse the list twice.

Freeing the fault group is not critical anymore, right?

> 
>> +
>> +static int iopf_queue_work(struct iopf_group *group, work_func_t func)
>> +{
>> +	struct iopf_device_param *iopf_param = group->dev->iommu-
>>> iopf_param;
>> +
>> +	INIT_WORK(&group->work, func);
>> +	queue_work(iopf_param->queue->wq, &group->work);
>> +
>> +	return 0;
>>   }
> 
> Is there plan to introduce further error in the future? otherwise this should
> be void.

queue_work() return true or false. I should check and return the value.

> 
> btw the work queue is only for sva. If there is no other caller this can be
> just kept in iommu-sva.c. No need to create a helper.

The definition of struct iopf_device_param is in this file. So I added a
helper to avoid making iopf_device_param visible globally.

> 
>> @@ -199,8 +204,11 @@ int iommu_queue_iopf(struct iommu_fault *fault,
>> struct device *dev)
>>   			list_move(&iopf->list, &group->faults);
>>   	}
>>
>> -	queue_work(iopf_param->queue->wq, &group->work);
>> -	return 0;
>> +	ret = iopf_queue_work(group, iopf_handler);
>> +	if (ret)
>> +		iopf_free_group(group);
>> +
>> +	return ret;
>>
> 
> Here we can document that the iopf handler (in patch10) should free the
> group, allowing the optimization inside the handler.

Yeah!

Best regards,
baolu
