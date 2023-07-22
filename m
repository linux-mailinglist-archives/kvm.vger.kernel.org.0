Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 62DB575DCD1
	for <lists+kvm@lfdr.de>; Sat, 22 Jul 2023 15:58:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229668AbjGVN6M (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 22 Jul 2023 09:58:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59308 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229452AbjGVN6K (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 22 Jul 2023 09:58:10 -0400
Received: from mga04.intel.com (mga04.intel.com [192.55.52.120])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 03E4810FD;
        Sat, 22 Jul 2023 06:58:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1690034290; x=1721570290;
  h=message-id:date:mime-version:cc:subject:to:references:
   from:in-reply-to:content-transfer-encoding;
  bh=bCsFYrqFuCb1H/kujsBcoErnwUesU07r4y1J/imt6q0=;
  b=awPCWlMiM/s6TaqzbBt0nK2+Lmdyr0GETPjQc/yRIr8a9To1KEJ8M3Bn
   /AS4ngXHXFMWH52ql8isqtHT93fRStyh5+lfWejI/a6wFFbZyc4pgb0GD
   GMNKN3i73m1SYrxIG0kqMdeMzfW5PCaHjWXGh1IO35vSXkSTL16ARFDEE
   QEGa93LkqVolgX0Kqr+ZWPKUH6KXufVMyRodtHlm/ozJTEtou0G1C35ML
   ZdvUe5NzHrDpA68vvk1a20fCgNyW533udckMOWRUsg1Mcr5yPm+Siaqr5
   2pxNyL3PJ5GCIOqx9rIK2F2hXELfT+kAe4/DnojmdBcl3AJl7t6veapeK
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10779"; a="366084843"
X-IronPort-AV: E=Sophos;i="6.01,224,1684825200"; 
   d="scan'208";a="366084843"
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Jul 2023 06:58:09 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10779"; a="849131841"
X-IronPort-AV: E=Sophos;i="6.01,224,1684825200"; 
   d="scan'208";a="849131841"
Received: from jianhuis-mobl.ccr.corp.intel.com (HELO [10.249.173.108]) ([10.249.173.108])
  by orsmga004-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Jul 2023 06:58:06 -0700
Message-ID: <46a5bbcd-424a-7d85-bb2a-0d5634166c8c@linux.intel.com>
Date:   Sat, 22 Jul 2023 21:58:03 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.13.0
Cc:     baolu.lu@linux.intel.com,
        "iommu@lists.linux.dev" <iommu@lists.linux.dev>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Jason Gunthorpe <jgg@nvidia.com>
Subject: Re: [PATCH v2 1/2] iommu: Prevent RESV_DIRECT devices from blocking
 domains
To:     "Tian, Kevin" <kevin.tian@intel.com>,
        Jason Gunthorpe <jgg@ziepe.ca>, Joerg Roedel <joro@8bytes.org>,
        Will Deacon <will@kernel.org>,
        Robin Murphy <robin.murphy@arm.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        Nicolin Chen <nicolinc@nvidia.com>
References: <20230713043248.41315-1-baolu.lu@linux.intel.com>
 <20230713043248.41315-2-baolu.lu@linux.intel.com>
 <BN9PR11MB52768040BD1C88E4EB8001878C3FA@BN9PR11MB5276.namprd11.prod.outlook.com>
Content-Language: en-US
From:   Baolu Lu <baolu.lu@linux.intel.com>
In-Reply-To: <BN9PR11MB52768040BD1C88E4EB8001878C3FA@BN9PR11MB5276.namprd11.prod.outlook.com>
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

On 2023/7/21 11:07, Tian, Kevin wrote:
>> From: Lu Baolu <baolu.lu@linux.intel.com>
>> Sent: Thursday, July 13, 2023 12:33 PM
>>
>> @@ -409,6 +409,7 @@ struct iommu_fault_param {
>>    * @priv:	 IOMMU Driver private data
>>    * @max_pasids:  number of PASIDs this device can consume
>>    * @attach_deferred: the dma domain attachment is deferred
>> + * @requires_direct: The driver requested IOMMU_RESV_DIRECT
> 
> it's not accurate to say "driver requested" as it's a device attribute.
> 
> s/requires_direct/require_direct/
> 
> what about "has_resv_direct"?

How about

  * @require_direct: device requires IOMMU_RESV_DIRECT reserved regions

?

> 
>> @@ -959,14 +959,12 @@ static int
>> iommu_create_device_direct_mappings(struct iommu_domain *domain,
>>   	unsigned long pg_size;
>>   	int ret = 0;
>>
>> -	if (!iommu_is_dma_domain(domain))
>> -		return 0;
>> -
>> -	BUG_ON(!domain->pgsize_bitmap);
>> -
>> -	pg_size = 1UL << __ffs(domain->pgsize_bitmap);
>> +	pg_size = domain->pgsize_bitmap ? 1UL << __ffs(domain-
>>> pgsize_bitmap) : 0;
>>   	INIT_LIST_HEAD(&mappings);
>>
>> +	if (WARN_ON_ONCE(iommu_is_dma_domain(domain) && !pg_size))
>> +		return -EINVAL;
>> +
>>   	iommu_get_resv_regions(dev, &mappings);
>>
>>   	/* We need to consider overlapping regions for different devices */
>> @@ -974,13 +972,17 @@ static int
>> iommu_create_device_direct_mappings(struct iommu_domain *domain,
>>   		dma_addr_t start, end, addr;
>>   		size_t map_size = 0;
>>
>> +		if (entry->type == IOMMU_RESV_DIRECT)
>> +			dev->iommu->requires_direct = 1;
>> +
>> +		if ((entry->type != IOMMU_RESV_DIRECT &&
>> +		     entry->type != IOMMU_RESV_DIRECT_RELAXABLE) ||
>> +		    !iommu_is_dma_domain(domain))
>> +			continue;
>> +
>>   		start = ALIGN(entry->start, pg_size);
>>   		end   = ALIGN(entry->start + entry->length, pg_size);
>>
>> -		if (entry->type != IOMMU_RESV_DIRECT &&
>> -		    entry->type != IOMMU_RESV_DIRECT_RELAXABLE)
>> -			continue;
>> -
>>   		for (addr = start; addr <= end; addr += pg_size) {
>>   			phys_addr_t phys_addr;
>>
> 
> piggybacking a device attribute detection in a function which tries to
> populate domain mappings is a bit confusing.
> 
> Does it work better to introduce a new function to detect this attribute
> and has it directly called in the probe path?

Jason answered this.

> 
>> @@ -2121,6 +2123,21 @@ static int __iommu_device_set_domain(struct
>> iommu_group *group,
>>   {
>>   	int ret;
>>
>> +	/*
>> +	 * If the driver has requested IOMMU_RESV_DIRECT then we cannot
> 
> ditto. It's not requested by the driver.
> 
>> allow
>> +	 * the blocking domain to be attached as it does not contain the
>> +	 * required 1:1 mapping. This test effectively exclusive the device
> 
> s/exclusive/excludes/
> 

Updated. Thanks!

Best regards,
baolu
