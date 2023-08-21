Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 93DE6782349
	for <lists+kvm@lfdr.de>; Mon, 21 Aug 2023 07:46:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233178AbjHUFqz (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 21 Aug 2023 01:46:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51952 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230478AbjHUFqy (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 21 Aug 2023 01:46:54 -0400
Received: from mgamail.intel.com (mgamail.intel.com [192.55.52.43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F2F90A3;
        Sun, 20 Aug 2023 22:46:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1692596812; x=1724132812;
  h=message-id:date:mime-version:cc:subject:to:references:
   from:in-reply-to:content-transfer-encoding;
  bh=DZPw1NWTFq7LuLCGSWf0Br/UddGbCKlhkmuvqbcJsYo=;
  b=FEMHgLrXBjADx8Lc/DfNmzMfaiLGiis3qzn95O72oILqMBsbcSefZLIw
   auqfnjDz7gx4NZlg9k9U5Ex4j0QdRsXWMYFS04iKo17zZFySfJIjpHGCA
   hJF62Jaq0yMaVF943fH8F7qfdU1l8XaYHGoKaqUqZ+NH0A/07ZR2ixy3j
   Q4O6DJD//laCNCLr6qriWxuYm0IJ8iy8kUaFuEWYTJSa3k4DmsnOcI7+M
   LUIOmuXtrcywleZ64NnyptytUs9tHnfxqk4C7SxIGe8XkgtuD9k/H1h3G
   H1YsD7UV1KF9hAeM06lwhP/ZkQn/zez2yu0fhwjrMXbeOXkv3VkZlayoM
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10808"; a="459869396"
X-IronPort-AV: E=Sophos;i="6.01,189,1684825200"; 
   d="scan'208";a="459869396"
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Aug 2023 22:46:52 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10808"; a="738781142"
X-IronPort-AV: E=Sophos;i="6.01,189,1684825200"; 
   d="scan'208";a="738781142"
Received: from blu2-mobl.ccr.corp.intel.com (HELO [10.252.185.204]) ([10.252.185.204])
  by fmsmga007-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Aug 2023 22:46:47 -0700
Message-ID: <6d5303a7-18d2-2481-18d1-c3d8fcf0d864@linux.intel.com>
Date:   Mon, 21 Aug 2023 13:46:44 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.14.0
Cc:     baolu.lu@linux.intel.com, Joerg Roedel <joro@8bytes.org>,
        Will Deacon <will@kernel.org>,
        Robin Murphy <robin.murphy@arm.com>,
        Jason Gunthorpe <jgg@ziepe.ca>,
        Kevin Tian <kevin.tian@intel.com>,
        Jean-Philippe Brucker <jean-philippe@linaro.org>,
        Yi Liu <yi.l.liu@intel.com>,
        Jacob Pan <jacob.jun.pan@linux.intel.com>,
        iommu@lists.linux.dev, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 2/3] iommu: Consolidate pasid dma ownership check
Content-Language: en-US
To:     Nicolin Chen <nicolinc@nvidia.com>
References: <20230814011759.102089-1-baolu.lu@linux.intel.com>
 <20230814011759.102089-3-baolu.lu@linux.intel.com>
 <ZN8FAKHCzWODGRmC@Asurada-Nvidia>
From:   Baolu Lu <baolu.lu@linux.intel.com>
In-Reply-To: <ZN8FAKHCzWODGRmC@Asurada-Nvidia>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-8.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 2023/8/18 13:43, Nicolin Chen wrote:
> On Mon, Aug 14, 2023 at 09:17:58AM +0800, Lu Baolu wrote:
> 
>> When switching device DMA ownership, it is required that all the device's
>> pasid DMA be disabled. This is done by checking if the pasid array of the
>> group is empty. Consolidate all the open code into a single helper. No
>> intentional functionality change.
>>
>> Signed-off-by: Lu Baolu<baolu.lu@linux.intel.com>
>> ---
>>   drivers/iommu/iommu.c | 23 ++++++++++++++++++-----
>>   1 file changed, 18 insertions(+), 5 deletions(-)
>>
>> diff --git a/drivers/iommu/iommu.c b/drivers/iommu/iommu.c
>> index f1eba60e573f..d4a06a37ce39 100644
>> --- a/drivers/iommu/iommu.c
>> +++ b/drivers/iommu/iommu.c
>> @@ -3127,6 +3127,19 @@ static bool iommu_is_default_domain(struct iommu_group *group)
>>          return false;
>>   }
>>
>> +/*
>> + * Assert no PASID DMA when claiming or releasing group's DMA ownership.
>               ^
> 	     |...
> 
>> + * The device pasid interfaces are only for device drivers that have
>> + * claimed the DMA ownership. Return true if no pasid DMA setup, otherwise
>> + * return false with a WARN().
>> + */
>> +static bool assert_pasid_dma_ownership(struct iommu_group *group)
> ... should it be assert_no_pasid_dma_ownership?

Fair enough. Or, perhaps just assert_no_pasid_dma()?

Best regards,
baolu
