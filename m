Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5A1717784DB
	for <lists+kvm@lfdr.de>; Fri, 11 Aug 2023 03:24:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231489AbjHKBYE (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 10 Aug 2023 21:24:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37680 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229503AbjHKBYD (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 10 Aug 2023 21:24:03 -0400
Received: from mgamail.intel.com (mgamail.intel.com [134.134.136.65])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BD3E91728;
        Thu, 10 Aug 2023 18:24:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1691717042; x=1723253042;
  h=message-id:date:mime-version:cc:subject:to:references:
   from:in-reply-to:content-transfer-encoding;
  bh=vCgMYStlmDlVJXKeZPtoTbQHCySrsyYJ68bnKcTfn8w=;
  b=SXWT1Z7K6IG4qY8gR8vI5ZzePeK0RYRvATkzWVqVOHrUud889jzy2KRI
   rtA26BvqINwpU26X62/AuL/m0WMsG+mpyYO1nw07zacW7uL3eAIq2bUTB
   xMWB/3wjK01Z4me/RiD12IDLyP9GoVULD4CNt9q/v8otEz+YQgFaXfXi/
   A7GwzZZjBFU118IHHAC33ZOCCCZJw0v6eOzWXafl9Sl/7j+k/y0Cy9UAJ
   TR4NBCB/E2EU/9H8DbtdhIVkMCQQz858w+g6zpchivq2fG3/cF58s1MGb
   ec+hA7sKTMXX2G13K7K42h0X3Y3RNkR2+Y6smqaeZbeRVl3xIM1gZiGhe
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10798"; a="375278989"
X-IronPort-AV: E=Sophos;i="6.01,164,1684825200"; 
   d="scan'208";a="375278989"
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Aug 2023 18:24:01 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10798"; a="822483106"
X-IronPort-AV: E=Sophos;i="6.01,164,1684825200"; 
   d="scan'208";a="822483106"
Received: from blu2-mobl.ccr.corp.intel.com (HELO [10.254.214.70]) ([10.254.214.70])
  by fmsmga003-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Aug 2023 18:23:57 -0700
Message-ID: <3882aec9-c221-f431-c0f7-a764ca947655@linux.intel.com>
Date:   Fri, 11 Aug 2023 09:23:55 +0800
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
Subject: Re: [PATCH v2 04/12] iommu: Replace device fault handler with
 iommu_queue_iopf()
Content-Language: en-US
To:     Jason Gunthorpe <jgg@ziepe.ca>
References: <20230727054837.147050-1-baolu.lu@linux.intel.com>
 <20230727054837.147050-5-baolu.lu@linux.intel.com>
 <ZNUq2IcvjEkwQewc@ziepe.ca>
From:   Baolu Lu <baolu.lu@linux.intel.com>
In-Reply-To: <ZNUq2IcvjEkwQewc@ziepe.ca>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-6.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 2023/8/11 2:22, Jason Gunthorpe wrote:
> On Thu, Jul 27, 2023 at 01:48:29PM +0800, Lu Baolu wrote:
>> The individual iommu drivers report iommu faults by calling
>> iommu_report_device_fault(), where a pre-registered device fault handler
>> is called to route the fault to another fault handler installed on the
>> corresponding iommu domain.
>>
>> The pre-registered device fault handler is static and won't be dynamic
>> as the fault handler is eventually per iommu domain. Replace calling
>> device fault handler with iommu_queue_iopf().
>>
>> Signed-off-by: Lu Baolu<baolu.lu@linux.intel.com>
>> ---
>>   drivers/iommu/iommu.c | 2 +-
>>   1 file changed, 1 insertion(+), 1 deletion(-)
>>
>> diff --git a/drivers/iommu/iommu.c b/drivers/iommu/iommu.c
>> index 4352a149a935..00309f66153b 100644
>> --- a/drivers/iommu/iommu.c
>> +++ b/drivers/iommu/iommu.c
>> @@ -1381,7 +1381,7 @@ int iommu_report_device_fault(struct device *dev, struct iommu_fault_event *evt)
>>   		mutex_unlock(&fparam->lock);
>>   	}
>>   
>> -	ret = fparam->handler(&evt->fault, fparam->data);
>> +	ret = iommu_queue_iopf(&evt->fault, dev);
>>   	if (ret && evt_pending) {
>>   		mutex_lock(&fparam->lock);
>>   		list_del(&evt_pending->list);
> I don't get it, why not remove fparam->handler/data entirely in this
> patch? There is no user once you do this change?

It needs some cleanups elsewhere, so I put it in a separate patch.

Best regards,
baolu
