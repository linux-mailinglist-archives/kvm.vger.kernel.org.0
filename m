Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E314F7784DE
	for <lists+kvm@lfdr.de>; Fri, 11 Aug 2023 03:25:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231962AbjHKBZa (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 10 Aug 2023 21:25:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43140 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229503AbjHKBZ3 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 10 Aug 2023 21:25:29 -0400
Received: from mgamail.intel.com (mgamail.intel.com [134.134.136.65])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6611E2D47;
        Thu, 10 Aug 2023 18:25:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1691717129; x=1723253129;
  h=message-id:date:mime-version:cc:subject:to:references:
   from:in-reply-to:content-transfer-encoding;
  bh=D5xLR5lmykDRMllq56ksssP5MhV1WjAoaSUCU/qhycs=;
  b=ggDRqHUalvjjGWSY5DqwrfXa742+fGH/t69gT4Qyf++P3uWy6XCybyei
   ipry+FgUG/Ax6Q6i/UUkBJLNn0WgkdME7HnF4SyuxCOzRnnWhvrDOfJlV
   yJi50epB+ND0RtIu98dmbdALB1gGB6ARvKrSs2/Lqvf5IGJK6lFcrcsWY
   Xv5/2F0Yy9WLx+uvSndM6a1wxn895tglWi7WPXXzcfq4zJqGATi2yZbXj
   sgQ/IkIzT2pj+EDg3T2G3rizlWrNI8TIxo8a79nhHYQPPGOc57M5yCtY0
   l30ZFnL5QE+D7LAXplBKslikQCWOF/JmGDoujITbEQeEnf9poveglTH3j
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10798"; a="375279067"
X-IronPort-AV: E=Sophos;i="6.01,164,1684825200"; 
   d="scan'208";a="375279067"
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Aug 2023 18:25:28 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10798"; a="822483323"
X-IronPort-AV: E=Sophos;i="6.01,164,1684825200"; 
   d="scan'208";a="822483323"
Received: from blu2-mobl.ccr.corp.intel.com (HELO [10.254.214.70]) ([10.254.214.70])
  by fmsmga003-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Aug 2023 18:25:25 -0700
Message-ID: <1066c330-616a-cd16-3b30-61624e2cd69c@linux.intel.com>
Date:   Fri, 11 Aug 2023 09:25:23 +0800
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
 <ZNUtkjRhi5c/W8pD@ziepe.ca>
From:   Baolu Lu <baolu.lu@linux.intel.com>
In-Reply-To: <ZNUtkjRhi5c/W8pD@ziepe.ca>
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

On 2023/8/11 2:33, Jason Gunthorpe wrote:
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
> Also fix the function signature at this point:
> 
> int iommu_queue_iopf(struct iommu_fault *fault, void *cookie)
> 
> It should not be 'void *cookie' anymore, it is just 'struct device *dev'

I have included this change in the subsequent cleanup patch.

Best regards,
baolu
