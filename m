Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0A5FC74FCFC
	for <lists+kvm@lfdr.de>; Wed, 12 Jul 2023 04:16:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231674AbjGLCQW (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 11 Jul 2023 22:16:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38452 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229537AbjGLCQV (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 11 Jul 2023 22:16:21 -0400
Received: from mga06.intel.com (mga06b.intel.com [134.134.136.31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3320A171C;
        Tue, 11 Jul 2023 19:16:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1689128180; x=1720664180;
  h=message-id:date:mime-version:cc:subject:to:references:
   from:in-reply-to:content-transfer-encoding;
  bh=7teqUly4Me+A9J/Fx2asWCUANEjQCBGyzvt5+0uDrZE=;
  b=lzZE1Dwbuuyvuhb/lMw+7wy+hkI4wj7+nh4nKeOmhN8xYNIJzCBZ/17x
   zPImWk3knvZdmxIlI1pqLLkIMazcIOTRYeuOmozZ9Olqi6lvL2pvwvOsB
   NZYgxbw3Uxyfg2pXTLy2QP152c+/hy2LaYW1dKwCkocy28plRlrSDinXA
   vVFTATKkdqiqbWKY6ljz6lbqjHCJfNE3L4HJNxmHzAoZ7EZVymQkLQhCn
   zaytxIi9M+0Ck3mzdmaUuwJ1HcHQ4pPhzgxrqkkZ6AQZFR3ycQdaSv5sS
   SsbM9LlBDhicsdH+2BxI3kKnUF/mvpu3HgxC5YvpBlpv6ZWfvlhBmfNDt
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10768"; a="428520559"
X-IronPort-AV: E=Sophos;i="6.01,198,1684825200"; 
   d="scan'208";a="428520559"
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Jul 2023 19:16:19 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10768"; a="724696128"
X-IronPort-AV: E=Sophos;i="6.01,198,1684825200"; 
   d="scan'208";a="724696128"
Received: from blu2-mobl.ccr.corp.intel.com (HELO [10.252.187.60]) ([10.252.187.60])
  by fmsmga007-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Jul 2023 19:16:15 -0700
Message-ID: <4519fb58-9b56-3c99-48be-a70505571f4a@linux.intel.com>
Date:   Wed, 12 Jul 2023 10:16:11 +0800
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
Subject: Re: [PATCH 2/9] iommu: Add device parameter to iopf handler
Content-Language: en-US
To:     Jacob Pan <jacob.jun.pan@linux.intel.com>
References: <20230711010642.19707-1-baolu.lu@linux.intel.com>
 <20230711010642.19707-3-baolu.lu@linux.intel.com>
 <20230711102620.37b06884@jacob-builder>
From:   Baolu Lu <baolu.lu@linux.intel.com>
In-Reply-To: <20230711102620.37b06884@jacob-builder>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 2023/7/12 1:26, Jacob Pan wrote:
> Hi BaoLu,

Hi Jacob,

> 
> On Tue, 11 Jul 2023 09:06:35 +0800, Lu Baolu<baolu.lu@linux.intel.com>
> wrote:
> 
>> Add the device parameter to the iopf handler so that it can know which
>> device this fault was generated.
>>
>> This is necessary for use cases such as delivering IO page faults to user
>> space. The IOMMUFD layer needs to be able to lookup the device id of a
>> fault and route it together with the fault message to the user space.
>>
>> Signed-off-by: Lu Baolu<baolu.lu@linux.intel.com>
>> ---
>>   include/linux/iommu.h      | 1 +
>>   drivers/iommu/iommu-sva.h  | 4 ++--
>>   drivers/iommu/io-pgfault.c | 2 +-
>>   drivers/iommu/iommu-sva.c  | 2 +-
>>   4 files changed, 5 insertions(+), 4 deletions(-)
>>
>> diff --git a/include/linux/iommu.h b/include/linux/iommu.h
>> index 0eb0fb852020..a00fb43b5e73 100644
>> --- a/include/linux/iommu.h
>> +++ b/include/linux/iommu.h
>> @@ -249,6 +249,7 @@ struct iommu_domain {
>>   	struct iommu_domain_geometry geometry;
>>   	struct iommu_dma_cookie *iova_cookie;
>>   	enum iommu_page_response_code (*iopf_handler)(struct iommu_fault
>> *fault,
>> +						      struct device *dev,
>>   						      void *data);
>>   	void *fault_data;
>>   	union {
>> diff --git a/drivers/iommu/iommu-sva.h b/drivers/iommu/iommu-sva.h
>> index 54946b5a7caf..c848661c4e20 100644
>> --- a/drivers/iommu/iommu-sva.h
>> +++ b/drivers/iommu/iommu-sva.h
>> @@ -23,7 +23,7 @@ struct iopf_queue *iopf_queue_alloc(const char *name);
>>   void iopf_queue_free(struct iopf_queue *queue);
>>   int iopf_queue_discard_partial(struct iopf_queue *queue);
>>   enum iommu_page_response_code
>> -iommu_sva_handle_iopf(struct iommu_fault *fault, void *data);
>> +iommu_sva_handle_iopf(struct iommu_fault *fault, struct device *dev,
>> void *data);
>>   #else /* CONFIG_IOMMU_SVA */
>>   static inline int iommu_queue_iopf(struct iommu_fault *fault, void
>> *cookie) @@ -63,7 +63,7 @@ static inline int
>> iopf_queue_discard_partial(struct iopf_queue *queue) }
>>   
>>   static inline enum iommu_page_response_code
>> -iommu_sva_handle_iopf(struct iommu_fault *fault, void *data)
>> +iommu_sva_handle_iopf(struct iommu_fault *fault, struct device *dev,
>> void *data) {
>>   	return IOMMU_PAGE_RESP_INVALID;
>>   }
>> diff --git a/drivers/iommu/io-pgfault.c b/drivers/iommu/io-pgfault.c
>> index e5b8b9110c13..fa604e1b5c5c 100644
>> --- a/drivers/iommu/io-pgfault.c
>> +++ b/drivers/iommu/io-pgfault.c
>> @@ -88,7 +88,7 @@ static void iopf_handler(struct work_struct *work)
>>   		 * faults in the group if there is an error.
>>   		 */
>>   		if (status == IOMMU_PAGE_RESP_SUCCESS)
>> -			status = domain->iopf_handler(&iopf->fault,
>> +			status = domain->iopf_handler(&iopf->fault,
>> group->dev, domain->fault_data);
>>   
>>   		if (!(iopf->fault.prm.flags &
>> diff --git a/drivers/iommu/iommu-sva.c b/drivers/iommu/iommu-sva.c
>> index 3ebd4b6586b3..14766a2b61af 100644
>> --- a/drivers/iommu/iommu-sva.c
>> +++ b/drivers/iommu/iommu-sva.c
>> @@ -157,7 +157,7 @@ EXPORT_SYMBOL_GPL(iommu_sva_get_pasid);
>>    * I/O page fault handler for SVA
>>    */
>>   enum iommu_page_response_code
>> -iommu_sva_handle_iopf(struct iommu_fault *fault, void *data)
>> +iommu_sva_handle_iopf(struct iommu_fault *fault, struct device *dev,
> dev has no use for sva handler, right? mark them __always_unused?

My understanding is that __always_unused attribute in Linux kernel code
marks a variable or function as unused. It implies that the compiler is
free to optimize the variable or function away.

If my understanding is correct, then it may not be suitable here.

Best regards,
baolu

