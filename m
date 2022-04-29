Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A60E7514852
	for <lists+kvm@lfdr.de>; Fri, 29 Apr 2022 13:37:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1358553AbiD2Lji (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 29 Apr 2022 07:39:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45438 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1358686AbiD2Li4 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 29 Apr 2022 07:38:56 -0400
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id B67708931D
        for <kvm@vger.kernel.org>; Fri, 29 Apr 2022 04:35:37 -0700 (PDT)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 5872E1063;
        Fri, 29 Apr 2022 04:35:37 -0700 (PDT)
Received: from [10.57.80.98] (unknown [10.57.80.98])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 0FFF03F73B;
        Fri, 29 Apr 2022 04:35:31 -0700 (PDT)
Message-ID: <599f3156-17f3-96fb-2736-ac6d63c91951@arm.com>
Date:   Fri, 29 Apr 2022 12:35:25 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; rv:91.0) Gecko/20100101
 Thunderbird/91.8.1
Subject: Re: [PATCH RFC 16/19] iommu/arm-smmu-v3: Enable HTTU for stage1 with
 io-pgtable mapping
Content-Language: en-GB
To:     Joao Martins <joao.m.martins@oracle.com>,
        iommu@lists.linux-foundation.org
Cc:     Joerg Roedel <joro@8bytes.org>,
        Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>,
        Will Deacon <will@kernel.org>,
        Jean-Philippe Brucker <jean-philippe@linaro.org>,
        Keqian Zhu <zhukeqian1@huawei.com>,
        Shameerali Kolothum Thodi 
        <shameerali.kolothum.thodi@huawei.com>,
        David Woodhouse <dwmw2@infradead.org>,
        Lu Baolu <baolu.lu@linux.intel.com>,
        Jason Gunthorpe <jgg@nvidia.com>,
        Nicolin Chen <nicolinc@nvidia.com>,
        Yishai Hadas <yishaih@nvidia.com>,
        Kevin Tian <kevin.tian@intel.com>,
        Eric Auger <eric.auger@redhat.com>,
        Yi Liu <yi.l.liu@intel.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>, kvm@vger.kernel.org,
        Kunkun Jiang <jiangkunkun@huawei.com>
References: <20220428210933.3583-1-joao.m.martins@oracle.com>
 <20220428210933.3583-17-joao.m.martins@oracle.com>
From:   Robin Murphy <robin.murphy@arm.com>
In-Reply-To: <20220428210933.3583-17-joao.m.martins@oracle.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-9.8 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        RCVD_IN_DNSWL_HI,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 2022-04-28 22:09, Joao Martins wrote:
> From: Kunkun Jiang <jiangkunkun@huawei.com>
> 
> As nested mode is not upstreamed now, we just aim to support dirty
> log tracking for stage1 with io-pgtable mapping (means not support
> SVA mapping). If HTTU is supported, we enable HA/HD bits in the SMMU
> CD and transfer ARM_HD quirk to io-pgtable.
> 
> We additionally filter out HD|HA if not supportted. The CD.HD bit
> is not particularly useful unless we toggle the DBM bit in the PTE
> entries.
> 
> Co-developed-by: Keqian Zhu <zhukeqian1@huawei.com>
> Signed-off-by: Keqian Zhu <zhukeqian1@huawei.com>
> Signed-off-by: Kunkun Jiang <jiangkunkun@huawei.com>
> [joaomart:Convey HD|HA bits over to the context descriptor
>   and update commit message]
> Signed-off-by: Joao Martins <joao.m.martins@oracle.com>
> ---
>   drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c | 11 +++++++++++
>   drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h |  3 +++
>   include/linux/io-pgtable.h                  |  1 +
>   3 files changed, 15 insertions(+)
> 
> diff --git a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
> index 1ca72fcca930..5f728f8f20a2 100644
> --- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
> +++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
> @@ -1077,10 +1077,18 @@ int arm_smmu_write_ctx_desc(struct arm_smmu_domain *smmu_domain, int ssid,
>   		 * this substream's traffic
>   		 */
>   	} else { /* (1) and (2) */
> +		struct arm_smmu_device *smmu = smmu_domain->smmu;
> +		u64 tcr = cd->tcr;
> +
>   		cdptr[1] = cpu_to_le64(cd->ttbr & CTXDESC_CD_1_TTB0_MASK);
>   		cdptr[2] = 0;
>   		cdptr[3] = cpu_to_le64(cd->mair);
>   
> +		if (!(smmu->features & ARM_SMMU_FEAT_HD))
> +			tcr &= ~CTXDESC_CD_0_TCR_HD;
> +		if (!(smmu->features & ARM_SMMU_FEAT_HA))
> +			tcr &= ~CTXDESC_CD_0_TCR_HA;

This is very backwards...

> +
>   		/*
>   		 * STE is live, and the SMMU might read dwords of this CD in any
>   		 * order. Ensure that it observes valid values before reading
> @@ -2100,6 +2108,7 @@ static int arm_smmu_domain_finalise_s1(struct arm_smmu_domain *smmu_domain,
>   			  FIELD_PREP(CTXDESC_CD_0_TCR_ORGN0, tcr->orgn) |
>   			  FIELD_PREP(CTXDESC_CD_0_TCR_SH0, tcr->sh) |
>   			  FIELD_PREP(CTXDESC_CD_0_TCR_IPS, tcr->ips) |
> +			  CTXDESC_CD_0_TCR_HA | CTXDESC_CD_0_TCR_HD |

...these should be set in io-pgtable's TCR value *if* io-pgatble is 
using DBM, then propagated through from there like everything else.

>   			  CTXDESC_CD_0_TCR_EPD1 | CTXDESC_CD_0_AA64;
>   	cfg->cd.mair	= pgtbl_cfg->arm_lpae_s1_cfg.mair;
>   
> @@ -2203,6 +2212,8 @@ static int arm_smmu_domain_finalise(struct iommu_domain *domain,
>   		.iommu_dev	= smmu->dev,
>   	};
>   
> +	if (smmu->features & ARM_SMMU_FEAT_HD)
> +		pgtbl_cfg.quirks |= IO_PGTABLE_QUIRK_ARM_HD;

You need to depend on ARM_SMMU_FEAT_COHERENCY for this as well, not 
least because you don't have any of the relevant business for 
synchronising non-coherent PTEs in your walk functions, but it's also 
implementation-defined whether HTTU even operates on non-cacheable 
pagetables, and frankly you just don't want to go there ;)

Robin.

>   	if (smmu->features & ARM_SMMU_FEAT_BBML1)
>   		pgtbl_cfg.quirks |= IO_PGTABLE_QUIRK_ARM_BBML1;
>   	else if (smmu->features & ARM_SMMU_FEAT_BBML2)
> diff --git a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h
> index e15750be1d95..ff32242f2fdb 100644
> --- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h
> +++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h
> @@ -292,6 +292,9 @@
>   #define CTXDESC_CD_0_TCR_IPS		GENMASK_ULL(34, 32)
>   #define CTXDESC_CD_0_TCR_TBI0		(1ULL << 38)
>   
> +#define CTXDESC_CD_0_TCR_HA            (1UL << 43)
> +#define CTXDESC_CD_0_TCR_HD            (1UL << 42)
> +
>   #define CTXDESC_CD_0_AA64		(1UL << 41)
>   #define CTXDESC_CD_0_S			(1UL << 44)
>   #define CTXDESC_CD_0_R			(1UL << 45)
> diff --git a/include/linux/io-pgtable.h b/include/linux/io-pgtable.h
> index d7626ca67dbf..a11902ae9cf1 100644
> --- a/include/linux/io-pgtable.h
> +++ b/include/linux/io-pgtable.h
> @@ -87,6 +87,7 @@ struct io_pgtable_cfg {
>   	#define IO_PGTABLE_QUIRK_ARM_OUTER_WBWA	BIT(6)
>   	#define IO_PGTABLE_QUIRK_ARM_BBML1      BIT(7)
>   	#define IO_PGTABLE_QUIRK_ARM_BBML2      BIT(8)
> +	#define IO_PGTABLE_QUIRK_ARM_HD         BIT(9)
>   
>   	unsigned long			quirks;
>   	unsigned long			pgsize_bitmap;
