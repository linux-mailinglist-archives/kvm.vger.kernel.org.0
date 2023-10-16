Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CB5767C9D66
	for <lists+kvm@lfdr.de>; Mon, 16 Oct 2023 04:29:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230479AbjJPC3v (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 15 Oct 2023 22:29:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56486 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229600AbjJPC3u (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 15 Oct 2023 22:29:50 -0400
Received: from mgamail.intel.com (mgamail.intel.com [134.134.136.126])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 49928AB
        for <kvm@vger.kernel.org>; Sun, 15 Oct 2023 19:29:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1697423388; x=1728959388;
  h=message-id:date:mime-version:cc:subject:to:references:
   from:in-reply-to:content-transfer-encoding;
  bh=gseOgceRHYao21t+Y9InDhAwL61MBg6QiUjbCe2U8rY=;
  b=ijRlUq2PzpZAVgiy7/2m4cCVLFD0p+aHawh8JuZH67aDHf9eAGrqZjUu
   aJgFLL5KLjOlt31MOtVhYQLkmQCSlGv0kqgOOUe2PUkuqW04t21/y8ys+
   Map1JsUpKykvLPUiS17ydvhCy+ZD3ixkkdf7/K620excEGS3LNnf56Y6V
   PTt2YY9TjUBwXiUlLXLUbEYw1aEklHnZyspgmfiAqC1P+tWoacuSkPblN
   GO94k647FwNm9npf/qPRpdvhCzARrfVvj0ig0DYcoDLVrE/GISsaXpET5
   J0jeZoCYoINw+Rfpv9MaCyTqYd86S9kVA+H942hPSTFR+HRHiLDlMtBBx
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10863"; a="370507584"
X-IronPort-AV: E=Sophos;i="6.03,228,1694761200"; 
   d="scan'208";a="370507584"
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Oct 2023 19:29:45 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10863"; a="759225285"
X-IronPort-AV: E=Sophos;i="6.03,228,1694761200"; 
   d="scan'208";a="759225285"
Received: from allen-box.sh.intel.com (HELO [10.239.159.127]) ([10.239.159.127])
  by fmsmga007.fm.intel.com with ESMTP; 15 Oct 2023 19:29:41 -0700
Message-ID: <79e499e7-d009-4bea-b2f2-a09fe42d6fe1@linux.intel.com>
Date:   Mon, 16 Oct 2023 10:26:04 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Cc:     baolu.lu@linux.intel.com, Jason Gunthorpe <jgg@nvidia.com>,
        Kevin Tian <kevin.tian@intel.com>,
        Shameerali Kolothum Thodi 
        <shameerali.kolothum.thodi@huawei.com>,
        Yi Liu <yi.l.liu@intel.com>, Yi Y Sun <yi.y.sun@intel.com>,
        Nicolin Chen <nicolinc@nvidia.com>,
        Joerg Roedel <joro@8bytes.org>,
        Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>,
        Will Deacon <will@kernel.org>,
        Robin Murphy <robin.murphy@arm.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        kvm@vger.kernel.org
Subject: Re: [PATCH v3 19/19] iommu/intel: Access/Dirty bit support for SL
 domains
Content-Language: en-US
To:     Joao Martins <joao.m.martins@oracle.com>, iommu@lists.linux.dev
References: <20230923012511.10379-1-joao.m.martins@oracle.com>
 <20230923012511.10379-20-joao.m.martins@oracle.com>
 <32ad48e2-0aa5-2c26-4e75-16e7b1460b37@linux.intel.com>
 <d5e35a74-f44e-41aa-8599-059af888b9b9@oracle.com>
From:   Baolu Lu <baolu.lu@linux.intel.com>
In-Reply-To: <d5e35a74-f44e-41aa-8599-059af888b9b9@oracle.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 9/25/23 5:08 PM, Joao Martins wrote:
> 
> 
> On 25/09/2023 08:01, Baolu Lu wrote:
>> On 9/23/23 9:25 AM, Joao Martins wrote:
>>> IOMMU advertises Access/Dirty bits for second-stage page table if the
>>> extended capability DMAR register reports it (ECAP, mnemonic ECAP.SSADS).
>>> The first stage table is compatible with CPU page table thus A/D bits are
>>> implicitly supported. Relevant Intel IOMMU SDM ref for first stage table
>>> "3.6.2 Accessed, Extended Accessed, and Dirty Flags" and second stage table
>>> "3.7.2 Accessed and Dirty Flags".
>>>
>>> First stage page table is enabled by default so it's allowed to set dirty
>>> tracking and no control bits needed, it just returns 0. To use SSADS, set
>>> bit 9 (SSADE) in the scalable-mode PASID table entry and flush the IOTLB
>>> via pasid_flush_caches() following the manual. Relevant SDM refs:
>>>
>>> "3.7.2 Accessed and Dirty Flags"
>>> "6.5.3.3 Guidance to Software for Invalidations,
>>>    Table 23. Guidance to Software for Invalidations"
>>>
>>> PTE dirty bit is located in bit 9 and it's cached in the IOTLB so flush
>>> IOTLB to make sure IOMMU attempts to set the dirty bit again. Note that
>>> iommu_dirty_bitmap_record() will add the IOVA to iotlb_gather and thus
>>> the caller of the iommu op will flush the IOTLB. Relevant manuals over
>>> the hardware translation is chapter 6 with some special mention to:
>>>
>>> "6.2.3.1 Scalable-Mode PASID-Table Entry Programming Considerations"
>>> "6.2.4 IOTLB"
>>>
>>> Signed-off-by: Joao Martins<joao.m.martins@oracle.com>
>>> ---
>>> The IOPTE walker is still a bit inneficient. Making sure the UAPI/IOMMUFD is
>>> solid and agreed upon.
>>> ---
>>>    drivers/iommu/intel/iommu.c | 94 +++++++++++++++++++++++++++++++++++++
>>>    drivers/iommu/intel/iommu.h | 15 ++++++
>>>    drivers/iommu/intel/pasid.c | 94 +++++++++++++++++++++++++++++++++++++
>>>    drivers/iommu/intel/pasid.h |  4 ++
>>>    4 files changed, 207 insertions(+)
>>
>> The code is probably incomplete. When attaching a domain to a device,
>> check the domain's dirty tracking capability against the device's
>> capabilities. If the domain's dirty tracking capability is set but the
>> device does not support it, the attach callback should return -EINVAL.
>>
> Yeap, I did that for AMD, but it seems in the mix of changes I may have deleted
> and then forgot to include it here.
> 
> Here's what I added (together with consolidated cap checking):
> 
> diff --git a/drivers/iommu/intel/iommu.c b/drivers/iommu/intel/iommu.c
> index 7d5a8f5283a7..fabfe363f1f9 100644
> --- a/drivers/iommu/intel/iommu.c
> +++ b/drivers/iommu/intel/iommu.c
> @@ -4075,6 +4075,11 @@ static struct iommu_domain
> *intel_iommu_domain_alloc(unsigned type)
>          return NULL;
>   }
> 
> +static bool intel_iommu_slads_supported(struct intel_iommu *iommu)
> +{
> +       return sm_supported(iommu) && ecap_slads(iommu->ecap);
> +}
> +
>   static struct iommu_domain *
>   intel_iommu_domain_alloc_user(struct device *dev, u32 flags)
>   {
> @@ -4090,7 +4095,7 @@ intel_iommu_domain_alloc_user(struct device *dev, u32 flags)
>                  return ERR_PTR(-EOPNOTSUPP);
> 
>          if (enforce_dirty &&
> -           !device_iommu_capable(dev, IOMMU_CAP_DIRTY))
> +           !intel_iommu_slads_supported(iommu))
>                  return ERR_PTR(-EOPNOTSUPP);
> 
>          domain = iommu_domain_alloc(dev->bus);
> @@ -4121,6 +4126,9 @@ static int prepare_domain_attach_device(struct
> iommu_domain *domain,
>          if (dmar_domain->force_snooping && !ecap_sc_support(iommu->ecap))
>                  return -EINVAL;
> 
> +       if (domain->dirty_ops && !intel_iommu_slads_supported(iommu))
> +               return -EINVAL;
> +
>          /* check if this iommu agaw is sufficient for max mapped address */
>          addr_width = agaw_to_width(iommu->agaw);
>          if (addr_width > cap_mgaw(iommu->cap))
> @@ -4376,8 +4384,7 @@ static bool intel_iommu_capable(struct device *dev, enum
> iommu_cap cap)
>          case IOMMU_CAP_ENFORCE_CACHE_COHERENCY:
>                  return ecap_sc_support(info->iommu->ecap);
>          case IOMMU_CAP_DIRTY:
> -               return sm_supported(info->iommu) &&
> -                       ecap_slads(info->iommu->ecap);
> +               return intel_iommu_slads_supported(info->iommu);
>          default:
>                  return false;
>          }

Yes. Above additional change looks good to me.

Best regards,
baolu
