Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 38C8F778524
	for <lists+kvm@lfdr.de>; Fri, 11 Aug 2023 03:55:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232663AbjHKBzP (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 10 Aug 2023 21:55:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51912 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229456AbjHKBzO (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 10 Aug 2023 21:55:14 -0400
Received: from mgamail.intel.com (mgamail.intel.com [134.134.136.24])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3050D2D52;
        Thu, 10 Aug 2023 18:55:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1691718914; x=1723254914;
  h=message-id:date:mime-version:cc:subject:to:references:
   from:in-reply-to:content-transfer-encoding;
  bh=IfHlH8JUVTQwrnI9x4YcZdegqcZ29aRj1abmEHrpcbI=;
  b=CoNmGeF8wOdLmoXeP8TmIqvQ0iri7KmvAim4PVCjjOK4Ci9B62w1EgQN
   tgWZP7I6wiKV/IoGfGfsYBKpVeqXbbziGG56XyKNZixjnMN3j/D9Clml1
   F7u+GZwBQJPfLV2zDSfGfog+4U78Uet525ttqGeK+Xj8f80B4ZuN5GWZ9
   z1iIndMWgqjOtsrZCXJyLvSteGXrxmmFU8vA27KwReE48LHnpqsT3ZXKt
   nnObYfCimUVZLUhAk9pgKgDfOcy7J0Y/ghiFrLIi9JugCcxoyKtImTzTZ
   4yp8CEcr9eadKUmiX0sWZJjJ7iceyjwj3Y9Mq18un3Lka1J9DAhkakMUz
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10798"; a="374336803"
X-IronPort-AV: E=Sophos;i="6.01,164,1684825200"; 
   d="scan'208";a="374336803"
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Aug 2023 18:55:13 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10798"; a="802480468"
X-IronPort-AV: E=Sophos;i="6.01,164,1684825200"; 
   d="scan'208";a="802480468"
Received: from blu2-mobl.ccr.corp.intel.com (HELO [10.254.214.70]) ([10.254.214.70])
  by fmsmga004-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Aug 2023 18:55:09 -0700
Message-ID: <74234ff1-492c-5934-49b6-69b08b732b91@linux.intel.com>
Date:   Fri, 11 Aug 2023 09:55:07 +0800
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
Subject: Re: [PATCH v2 09/12] iommu: Move iopf_handler() to iommu-sva.c
Content-Language: en-US
To:     Jason Gunthorpe <jgg@ziepe.ca>
References: <20230727054837.147050-1-baolu.lu@linux.intel.com>
 <20230727054837.147050-10-baolu.lu@linux.intel.com>
 <ZNU0U9XscuB3ILuX@ziepe.ca>
From:   Baolu Lu <baolu.lu@linux.intel.com>
In-Reply-To: <ZNU0U9XscuB3ILuX@ziepe.ca>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_BLOCKED,RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,
        SPF_HELO_NONE,SPF_NONE,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 2023/8/11 3:02, Jason Gunthorpe wrote:
> On Thu, Jul 27, 2023 at 01:48:34PM +0800, Lu Baolu wrote:
>> The iopf_handler() function handles a fault_group for a SVA domain. Move
>> it to the right place.
>>
>> Signed-off-by: Lu Baolu <baolu.lu@linux.intel.com>
>> ---
>>   drivers/iommu/iommu-sva.h  | 17 +++++++++++++
>>   drivers/iommu/io-pgfault.c | 50 +++-----------------------------------
>>   drivers/iommu/iommu-sva.c  | 49 +++++++++++++++++++++++++++++++++++++
>>   3 files changed, 69 insertions(+), 47 deletions(-)
>> diff --git a/drivers/iommu/iommu-sva.c b/drivers/iommu/iommu-sva.c
>> index 05c0fb2acbc4..ab42cfdd7636 100644
>> --- a/drivers/iommu/iommu-sva.c
>> +++ b/drivers/iommu/iommu-sva.c
>> @@ -219,3 +219,52 @@ void mm_pasid_drop(struct mm_struct *mm)
> 
>> +static void iopf_handler(struct work_struct *work)
>> +{
>> +	struct iopf_fault *iopf;
>> +	struct iopf_group *group;
>> +	struct iommu_domain *domain;
>> +	enum iommu_page_response_code status = IOMMU_PAGE_RESP_SUCCESS;
>> +
>> +	group = container_of(work, struct iopf_group, work);
>> +	domain = iommu_get_domain_for_dev_pasid(group->dev,
>> +				group->last_fault.fault.prm.pasid, 0);
>> +	if (!domain || !domain->iopf_handler)
>> +		status = IOMMU_PAGE_RESP_INVALID;
>> +
>> +	list_for_each_entry(iopf, &group->faults, list) {
>> +		/*
>> +		 * For the moment, errors are sticky: don't handle subsequent
>> +		 * faults in the group if there is an error.
>> +		 */
>> +		if (status == IOMMU_PAGE_RESP_SUCCESS)
>> +			status = domain->iopf_handler(&iopf->fault,
>> +						      domain->fault_data);
>> +	}
>> +
>> +	iopf_complete_group(group->dev, &group->last_fault, status);
>> +	iopf_free_group(group);
>> +}
> 
> Routing faults to domains is generic code, not SVA code.

You are right. This happens in the latter patch.

> SVA starts at domain->iopf_handler
> 
> Jason
> 

Best regards,
baolu
