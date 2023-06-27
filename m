Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 09D0D73F6F5
	for <lists+kvm@lfdr.de>; Tue, 27 Jun 2023 10:23:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231761AbjF0IXY (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 27 Jun 2023 04:23:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59942 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231820AbjF0IXP (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 27 Jun 2023 04:23:15 -0400
Received: from mga14.intel.com (mga14.intel.com [192.55.52.115])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4BF052718;
        Tue, 27 Jun 2023 01:22:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1687854165; x=1719390165;
  h=message-id:date:mime-version:cc:subject:to:references:
   from:in-reply-to:content-transfer-encoding;
  bh=dVqZCQ9tRTsVoV0IWARrFflzjFDg8LSURCopWadXZ/g=;
  b=R5h9b+p0bkfBAdegbexzB762DDzQrk2TStPN55vBTJ/xMNHOOF2aqk3i
   CjElGdA+oMblilgTBbSUr0GghQTFes9RcaOU3riJnIycW1jYY3MLV2fLR
   1JNp+aZIT03lUnzoZt8ZEKG06GYG/pOIzAeYE+DoGU5IFXMTJKhxU4X6i
   1CUyrak3CCtZhxQRYBbMLiypNb5yLq0fxcMYqbvNRp+hDE88D5iThnJIK
   bBZggqWcj/iaU5M+xuijEIge3QuRT6svZ9f9PzYIg0ALa4euVlUMlZ4Bc
   ZjgOG5pTr76VWi9/eX7vFqWAS8JNBx8GaS0zp0van+qjnLt5Z6HZqOPmH
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10753"; a="361552084"
X-IronPort-AV: E=Sophos;i="6.01,161,1684825200"; 
   d="scan'208";a="361552084"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Jun 2023 01:22:41 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10753"; a="781757134"
X-IronPort-AV: E=Sophos;i="6.01,161,1684825200"; 
   d="scan'208";a="781757134"
Received: from blu2-mobl.ccr.corp.intel.com (HELO [10.254.215.29]) ([10.254.215.29])
  by fmsmga008-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Jun 2023 01:22:38 -0700
Message-ID: <1c8f6bf4-f0ad-2888-ada0-056c12647c41@linux.intel.com>
Date:   Tue, 27 Jun 2023 16:21:56 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.12.0
Cc:     baolu.lu@linux.intel.com,
        "iommu@lists.linux.dev" <iommu@lists.linux.dev>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Jason Gunthorpe <jgg@nvidia.com>
Subject: Re: [PATCH 1/2] iommu: Prevent RESV_DIRECT devices from blocking
 domains
Content-Language: en-US
To:     "Tian, Kevin" <kevin.tian@intel.com>,
        "Liu, Jingqi" <jingqi.liu@intel.com>,
        Jason Gunthorpe <jgg@ziepe.ca>, Joerg Roedel <joro@8bytes.org>,
        Will Deacon <will@kernel.org>,
        Robin Murphy <robin.murphy@arm.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        Nicolin Chen <nicolinc@nvidia.com>
References: <20230607035145.343698-1-baolu.lu@linux.intel.com>
 <20230607035145.343698-2-baolu.lu@linux.intel.com>
 <8cc1d69e-f86d-fd04-7737-914d967dc0f5@intel.com>
 <69f50ced-e806-717a-0c74-a4cfa58600fa@linux.intel.com>
 <BN9PR11MB52768ACA721898D5C43CBE9B8C27A@BN9PR11MB5276.namprd11.prod.outlook.com>
 <f1b2e7fa-7be3-9e4b-1eba-5dba01b88c19@linux.intel.com>
 <BN9PR11MB527613D6C657A4AE0DE169758C27A@BN9PR11MB5276.namprd11.prod.outlook.com>
From:   Baolu Lu <baolu.lu@linux.intel.com>
In-Reply-To: <BN9PR11MB527613D6C657A4AE0DE169758C27A@BN9PR11MB5276.namprd11.prod.outlook.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 2023/6/27 16:15, Tian, Kevin wrote:
>> From: Baolu Lu<baolu.lu@linux.intel.com>
>> Sent: Tuesday, June 27, 2023 4:01 PM
>>
>> On 2023/6/27 15:54, Tian, Kevin wrote:
>>>> From: Baolu Lu<baolu.lu@linux.intel.com>
>>>> Sent: Tuesday, June 13, 2023 11:15 AM
>>>>
>>>> On 6/12/23 4:28 PM, Liu, Jingqi wrote:
>>>>> On 6/7/2023 11:51 AM, Lu Baolu wrote:
>>>>>> -
>>>>>> -    BUG_ON(!domain->pgsize_bitmap);
>>>>>> -
>>>>>> -    pg_size = 1UL << __ffs(domain->pgsize_bitmap);
>>>>>> +    pg_size = domain->pgsize_bitmap ? 1UL <<
>>>>>> __ffs(domain->pgsize_bitmap) : 0;
>>>>> Would it be better to add the following check here?
>>>>>        if (WARN_ON(!pg_size))
>>>>>                return -EINVAL;
>>>>>
>>>>> Instead of checking latter in the loop as follows.
>>>>>        if (WARN_ON_ONCE(!pg_size)) {
>>>>>                ret = -EINVAL;
>>>>>                goto out;
>>>>>        }
>>>> I am afraid no. Only the paging domains need a valid pg_size. That's the
>>>> reason why I put it after the iommu_is_dma_domain() check. The
>> previous
>>>> code has the same behavior too.
>>>>
>>> You could also add the dma domain check here. pg_size is static
>>> then it makes more sense to verify it once instead of in a loop.
>> Agreed. Does below additional change make sense?
>>
>> diff --git a/drivers/iommu/iommu.c b/drivers/iommu/iommu.c
>> index e59de7852067..3be88b5f36bb 100644
>> --- a/drivers/iommu/iommu.c
>> +++ b/drivers/iommu/iommu.c
>> @@ -962,6 +962,9 @@ static int
>> iommu_create_device_direct_mappings(struct iommu_domain *domain,
>>           pg_size = domain->pgsize_bitmap ? 1UL <<
>> __ffs(domain->pgsize_bitmap) : 0;
>>           INIT_LIST_HEAD(&mappings);
>>
>> +       if (WARN_ON_ONCE((domain->type & __IOMMU_DOMAIN_PAGING)
>> &&
>> !pg_size))
>> +               return -EINVAL;
> what's the reason of not using iommu_is_dma_domain()? this is called
> in the probe path only for the default domain. Otherwise if you change
> like this then you also want to change the check in the loop later to be
> consistent.
> 

Yes. iommu_is_dma_domain() is better.

Best regards,
baolu
