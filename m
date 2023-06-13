Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A729A72D812
	for <lists+kvm@lfdr.de>; Tue, 13 Jun 2023 05:17:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239489AbjFMDRV (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 12 Jun 2023 23:17:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59038 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239475AbjFMDQm (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 12 Jun 2023 23:16:42 -0400
Received: from mga06.intel.com (mga06b.intel.com [134.134.136.31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 92FB9172A;
        Mon, 12 Jun 2023 20:15:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1686626141; x=1718162141;
  h=message-id:date:mime-version:cc:subject:to:references:
   from:in-reply-to:content-transfer-encoding;
  bh=2YVq3aZ9XIb0zceB5aVAvaOJdnAo1cIPmdg8DLRTCLU=;
  b=RECczq4ijrgMofYOofaSxkbbGi1L/Gc5kiYude2MfV0lyYtfrAFHVX0c
   24Z4jiYqqFw37aiQFmpcE7dngbDyGQxtXH5MjFBkBfeJIL0UMD6q5Uw5C
   xrIbNE8CA5utjCecQng8niIvl9sbUTMENXMINv8Qwea4LBKKGjoZV42K+
   kTWG/riL92A1+W43bCuw0mb14XJNUVn+PHAndhGwPs7Mrqwj5SDFMeMO7
   L65nmDH7QgpJvAvS/9Ct2fsmsb9VbVYaV+DnAPBb2SgKWv+S5EkW4nX8W
   xMm/tVnGz0g3PgJaa72wj0iydlSr4N8KX72GjCRWa400ugt4V6R7pilLU
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10739"; a="421807839"
X-IronPort-AV: E=Sophos;i="6.00,238,1681196400"; 
   d="scan'208";a="421807839"
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Jun 2023 20:15:40 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10739"; a="958242936"
X-IronPort-AV: E=Sophos;i="6.00,238,1681196400"; 
   d="scan'208";a="958242936"
Received: from allen-box.sh.intel.com (HELO [10.239.159.127]) ([10.239.159.127])
  by fmsmga006.fm.intel.com with ESMTP; 12 Jun 2023 20:15:37 -0700
Message-ID: <69f50ced-e806-717a-0c74-a4cfa58600fa@linux.intel.com>
Date:   Tue, 13 Jun 2023 11:14:30 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.11.0
Cc:     baolu.lu@linux.intel.com, iommu@lists.linux.dev,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Jason Gunthorpe <jgg@nvidia.com>
Subject: Re: [PATCH 1/2] iommu: Prevent RESV_DIRECT devices from blocking
 domains
Content-Language: en-US
To:     "Liu, Jingqi" <jingqi.liu@intel.com>,
        Jason Gunthorpe <jgg@ziepe.ca>,
        Kevin Tian <kevin.tian@intel.com>,
        Joerg Roedel <joro@8bytes.org>, Will Deacon <will@kernel.org>,
        Robin Murphy <robin.murphy@arm.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        Nicolin Chen <nicolinc@nvidia.com>
References: <20230607035145.343698-1-baolu.lu@linux.intel.com>
 <20230607035145.343698-2-baolu.lu@linux.intel.com>
 <8cc1d69e-f86d-fd04-7737-914d967dc0f5@intel.com>
From:   Baolu Lu <baolu.lu@linux.intel.com>
In-Reply-To: <8cc1d69e-f86d-fd04-7737-914d967dc0f5@intel.com>
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

On 6/12/23 4:28 PM, Liu, Jingqi wrote:
> On 6/7/2023 11:51 AM, Lu Baolu wrote:
>> The IOMMU_RESV_DIRECT flag indicates that a memory region must be mapped
>> 1:1 at all times. This means that the region must always be accessible to
>> the device, even if the device is attached to a blocking domain. This is
>> equal to saying that IOMMU_RESV_DIRECT flag prevents devices from being
>> attached to blocking domains.
>>
>> This also implies that devices that implement RESV_DIRECT regions will be
>> prevented from being assigned to user space since taking the DMA 
>> ownership
>> immediately switches to a blocking domain.
>>
>> The rule of preventing devices with the IOMMU_RESV_DIRECT regions from
>> being assigned to user space has existed in the Intel IOMMU driver for
>> a long time. Now, this rule is being lifted up to a general core rule,
>> as other architectures like AMD and ARM also have RMRR-like reserved
>> regions. This has been discussed in the community mailing list and refer
>> to below link for more details.
>>
>> Other places using unmanaged domains for kernel DMA must follow the
>> iommu_get_resv_regions() and setup IOMMU_RESV_DIRECT - we do not restrict
>> them in the core code.
>>
>> Cc: Robin Murphy <robin.murphy@arm.com>
>> Cc: Alex Williamson <alex.williamson@redhat.com>
>> Cc: Kevin Tian <kevin.tian@intel.com>
>> Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
>> Link: 
>> https://lore.kernel.org/linux-iommu/BN9PR11MB5276E84229B5BD952D78E9598C639@BN9PR11MB5276.namprd11.prod.outlook.com
>> Signed-off-by: Lu Baolu <baolu.lu@linux.intel.com>
>> ---
>>   include/linux/iommu.h |  2 ++
>>   drivers/iommu/iommu.c | 39 +++++++++++++++++++++++++++++----------
>>   2 files changed, 31 insertions(+), 10 deletions(-)
>>
>> diff --git a/include/linux/iommu.h b/include/linux/iommu.h
>> index d31642596675..fd18019ac951 100644
>> --- a/include/linux/iommu.h
>> +++ b/include/linux/iommu.h
>> @@ -409,6 +409,7 @@ struct iommu_fault_param {
>>    * @priv:     IOMMU Driver private data
>>    * @max_pasids:  number of PASIDs this device can consume
>>    * @attach_deferred: the dma domain attachment is deferred
>> + * @requires_direct: The driver requested IOMMU_RESV_DIRECT
>>    *
>>    * TODO: migrate other per device data pointers under 
>> iommu_dev_data, e.g.
>>    *    struct iommu_group    *iommu_group;
>> @@ -422,6 +423,7 @@ struct dev_iommu {
>>       void                *priv;
>>       u32                max_pasids;
>>       u32                attach_deferred:1;
>> +    u32                requires_direct:1;
>>   };
>>   int iommu_device_register(struct iommu_device *iommu,
>> diff --git a/drivers/iommu/iommu.c b/drivers/iommu/iommu.c
>> index 9e0228ef612b..e59de7852067 100644
>> --- a/drivers/iommu/iommu.c
>> +++ b/drivers/iommu/iommu.c
>> @@ -959,12 +959,7 @@ static int 
>> iommu_create_device_direct_mappings(struct iommu_domain *domain,
>>       unsigned long pg_size;
>>       int ret = 0;
>> -    if (!iommu_is_dma_domain(domain))
>> -        return 0;
>> -
>> -    BUG_ON(!domain->pgsize_bitmap);
>> -
>> -    pg_size = 1UL << __ffs(domain->pgsize_bitmap);
>> +    pg_size = domain->pgsize_bitmap ? 1UL << 
>> __ffs(domain->pgsize_bitmap) : 0;
> Would it be better to add the following check here?
>      if (WARN_ON(!pg_size))
>              return -EINVAL;
> 
> Instead of checking latter in the loop as follows.
>      if (WARN_ON_ONCE(!pg_size)) {
>              ret = -EINVAL;
>              goto out;
>      }

I am afraid no. Only the paging domains need a valid pg_size. That's the
reason why I put it after the iommu_is_dma_domain() check. The previous
code has the same behavior too.

Best regards,
baolu
