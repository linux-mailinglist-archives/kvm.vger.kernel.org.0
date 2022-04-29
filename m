Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 90A255147C6
	for <lists+kvm@lfdr.de>; Fri, 29 Apr 2022 13:11:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1358073AbiD2LPK (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 29 Apr 2022 07:15:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58116 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348440AbiD2LPJ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 29 Apr 2022 07:15:09 -0400
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 21DCD78900
        for <kvm@vger.kernel.org>; Fri, 29 Apr 2022 04:11:51 -0700 (PDT)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id BAE241063;
        Fri, 29 Apr 2022 04:11:50 -0700 (PDT)
Received: from [10.57.80.98] (unknown [10.57.80.98])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 3866B3F73B;
        Fri, 29 Apr 2022 04:11:47 -0700 (PDT)
Message-ID: <8e897628-61fa-b3fb-b609-44eeda11b45e@arm.com>
Date:   Fri, 29 Apr 2022 12:11:41 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; rv:91.0) Gecko/20100101
 Thunderbird/91.8.1
Subject: Re: [PATCH RFC 13/19] iommu/arm-smmu-v3: Add feature detection for
 BBML
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
 <20220428210933.3583-14-joao.m.martins@oracle.com>
From:   Robin Murphy <robin.murphy@arm.com>
In-Reply-To: <20220428210933.3583-14-joao.m.martins@oracle.com>
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
> This detects BBML feature and if SMMU supports it, transfer BBMLx
> quirk to io-pgtable.
> 
> BBML1 requires still marking PTE nT prior to performing a
> translation table update, while BBML2 requires neither break-before-make
> nor PTE nT bit being set. For dirty tracking it needs to clear
> the dirty bit so checking BBML2 tells us the prerequisite. See SMMUv3.2
> manual, section "3.21.1.3 When SMMU_IDR3.BBML == 2 (Level 2)" and
> "3.21.1.2 When SMMU_IDR3.BBML == 1 (Level 1)"

You can drop this, and the dependencies on BBML elsewhere, until you get 
round to the future large-page-splitting work, since that's the only 
thing this represents. Not much point having the feature flags without 
an actual implementation, or any users.

Robin.

> Co-developed-by: Keqian Zhu <zhukeqian1@huawei.com>
> Signed-off-by: Keqian Zhu <zhukeqian1@huawei.com>
> Signed-off-by: Kunkun Jiang <jiangkunkun@huawei.com>
> [joaomart: massage commit message with the need to have BBML quirk
>   and add the Quirk io-pgtable flags]
> Signed-off-by: Joao Martins <joao.m.martins@oracle.com>
> ---
>   drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c | 19 +++++++++++++++++++
>   drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h |  6 ++++++
>   include/linux/io-pgtable.h                  |  3 +++
>   3 files changed, 28 insertions(+)
> 
> diff --git a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
> index 14609ece4e33..4dba53bde2e3 100644
> --- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
> +++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
> @@ -2203,6 +2203,11 @@ static int arm_smmu_domain_finalise(struct iommu_domain *domain,
>   		.iommu_dev	= smmu->dev,
>   	};
>   
> +	if (smmu->features & ARM_SMMU_FEAT_BBML1)
> +		pgtbl_cfg.quirks |= IO_PGTABLE_QUIRK_ARM_BBML1;
> +	else if (smmu->features & ARM_SMMU_FEAT_BBML2)
> +		pgtbl_cfg.quirks |= IO_PGTABLE_QUIRK_ARM_BBML2;
> +
>   	pgtbl_ops = alloc_io_pgtable_ops(fmt, &pgtbl_cfg, smmu_domain);
>   	if (!pgtbl_ops)
>   		return -ENOMEM;
> @@ -3591,6 +3596,20 @@ static int arm_smmu_device_hw_probe(struct arm_smmu_device *smmu)
>   
>   	/* IDR3 */
>   	reg = readl_relaxed(smmu->base + ARM_SMMU_IDR3);
> +	switch (FIELD_GET(IDR3_BBML, reg)) {
> +	case IDR3_BBML0:
> +		break;
> +	case IDR3_BBML1:
> +		smmu->features |= ARM_SMMU_FEAT_BBML1;
> +		break;
> +	case IDR3_BBML2:
> +		smmu->features |= ARM_SMMU_FEAT_BBML2;
> +		break;
> +	default:
> +		dev_err(smmu->dev, "unknown/unsupported BBM behavior level\n");
> +		return -ENXIO;
> +	}
> +
>   	if (FIELD_GET(IDR3_RIL, reg))
>   		smmu->features |= ARM_SMMU_FEAT_RANGE_INV;
>   
> diff --git a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h
> index 1487a80fdf1b..e15750be1d95 100644
> --- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h
> +++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h
> @@ -54,6 +54,10 @@
>   #define IDR1_SIDSIZE			GENMASK(5, 0)
>   
>   #define ARM_SMMU_IDR3			0xc
> +#define IDR3_BBML			GENMASK(12, 11)
> +#define IDR3_BBML0			0
> +#define IDR3_BBML1			1
> +#define IDR3_BBML2			2
>   #define IDR3_RIL			(1 << 10)
>   
>   #define ARM_SMMU_IDR5			0x14
> @@ -644,6 +648,8 @@ struct arm_smmu_device {
>   #define ARM_SMMU_FEAT_E2H		(1 << 18)
>   #define ARM_SMMU_FEAT_HA		(1 << 19)
>   #define ARM_SMMU_FEAT_HD		(1 << 20)
> +#define ARM_SMMU_FEAT_BBML1		(1 << 21)
> +#define ARM_SMMU_FEAT_BBML2		(1 << 22)
>   	u32				features;
>   
>   #define ARM_SMMU_OPT_SKIP_PREFETCH	(1 << 0)
> diff --git a/include/linux/io-pgtable.h b/include/linux/io-pgtable.h
> index c2ebfe037f5d..d7626ca67dbf 100644
> --- a/include/linux/io-pgtable.h
> +++ b/include/linux/io-pgtable.h
> @@ -85,6 +85,9 @@ struct io_pgtable_cfg {
>   	#define IO_PGTABLE_QUIRK_ARM_MTK_EXT	BIT(3)
>   	#define IO_PGTABLE_QUIRK_ARM_TTBR1	BIT(5)
>   	#define IO_PGTABLE_QUIRK_ARM_OUTER_WBWA	BIT(6)
> +	#define IO_PGTABLE_QUIRK_ARM_BBML1      BIT(7)
> +	#define IO_PGTABLE_QUIRK_ARM_BBML2      BIT(8)
> +
>   	unsigned long			quirks;
>   	unsigned long			pgsize_bitmap;
>   	unsigned int			ias;
