Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7344A7098B6
	for <lists+kvm@lfdr.de>; Fri, 19 May 2023 15:50:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231410AbjESNuj (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 19 May 2023 09:50:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33204 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230518AbjESNui (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 19 May 2023 09:50:38 -0400
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 4A8D11B3
        for <kvm@vger.kernel.org>; Fri, 19 May 2023 06:50:01 -0700 (PDT)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 8F1DA1FB;
        Fri, 19 May 2023 06:50:45 -0700 (PDT)
Received: from [10.57.84.114] (unknown [10.57.84.114])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 362B03F73F;
        Fri, 19 May 2023 06:49:58 -0700 (PDT)
Message-ID: <d7aad90c-e009-d577-eb89-3c0859ce3952@arm.com>
Date:   Fri, 19 May 2023 14:49:53 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; rv:102.0) Gecko/20100101
 Thunderbird/102.11.0
Subject: Re: [PATCH RFCv2 21/24] iommu/arm-smmu-v3: Enable HTTU for stage1
 with io-pgtable mapping
Content-Language: en-GB
To:     Joao Martins <joao.m.martins@oracle.com>, iommu@lists.linux.dev
Cc:     Jason Gunthorpe <jgg@nvidia.com>,
        Kevin Tian <kevin.tian@intel.com>,
        Shameerali Kolothum Thodi 
        <shameerali.kolothum.thodi@huawei.com>,
        Lu Baolu <baolu.lu@linux.intel.com>,
        Yi Liu <yi.l.liu@intel.com>, Yi Y Sun <yi.y.sun@intel.com>,
        Eric Auger <eric.auger@redhat.com>,
        Nicolin Chen <nicolinc@nvidia.com>,
        Joerg Roedel <joro@8bytes.org>,
        Jean-Philippe Brucker <jean-philippe@linaro.org>,
        Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>,
        Will Deacon <will@kernel.org>,
        Alex Williamson <alex.williamson@redhat.com>,
        kvm@vger.kernel.org
References: <20230518204650.14541-1-joao.m.martins@oracle.com>
 <20230518204650.14541-22-joao.m.martins@oracle.com>
From:   Robin Murphy <robin.murphy@arm.com>
In-Reply-To: <20230518204650.14541-22-joao.m.martins@oracle.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-5.7 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 2023-05-18 21:46, Joao Martins wrote:
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

...seeds odd to describe the control which fundamentally enables DBM or 
not as "not particularly useful" to the DBM use-case :/

> Link: https://lore.kernel.org/lkml/20210413085457.25400-6-zhukeqian1@huawei.com/
> Co-developed-by: Keqian Zhu <zhukeqian1@huawei.com>
> Signed-off-by: Keqian Zhu <zhukeqian1@huawei.com>
> Signed-off-by: Kunkun Jiang <jiangkunkun@huawei.com>
> [joaomart:Convey HD|HA bits over to the context descriptor
>   and update commit message; original in Link, where this is based on]
> Signed-off-by: Joao Martins <joao.m.martins@oracle.com>
> ---
>   drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c | 10 ++++++++++
>   drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h |  3 +++
>   drivers/iommu/io-pgtable-arm.c              | 11 +++++++++--
>   include/linux/io-pgtable.h                  |  4 ++++

For the sake of cleanliness, please split the io-pgtable and SMMU 
additions into separate patches (you could perhaps then squash 
set_dirty_tracking() into the SMMU patch as well).

Thanks,
Robin.

>   4 files changed, 26 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
> index e110ff4710bf..e2b98a6a6b74 100644
> --- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
> +++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
> @@ -1998,6 +1998,11 @@ static const struct iommu_flush_ops arm_smmu_flush_ops = {
>   	.tlb_add_page	= arm_smmu_tlb_inv_page_nosync,
>   };
>   
> +static bool arm_smmu_dbm_capable(struct arm_smmu_device *smmu)
> +{
> +	return smmu->features & (ARM_SMMU_FEAT_HD | ARM_SMMU_FEAT_COHERENCY);
> +}
> +
>   /* IOMMU API */
>   static bool arm_smmu_capable(struct device *dev, enum iommu_cap cap)
>   {
> @@ -2124,6 +2129,8 @@ static int arm_smmu_domain_finalise_s1(struct arm_smmu_domain *smmu_domain,
>   			  FIELD_PREP(CTXDESC_CD_0_TCR_SH0, tcr->sh) |
>   			  FIELD_PREP(CTXDESC_CD_0_TCR_IPS, tcr->ips) |
>   			  CTXDESC_CD_0_TCR_EPD1 | CTXDESC_CD_0_AA64;
> +	if (pgtbl_cfg->quirks & IO_PGTABLE_QUIRK_ARM_HD)
> +		cfg->cd.tcr |= CTXDESC_CD_0_TCR_HA | CTXDESC_CD_0_TCR_HD;
>   	cfg->cd.mair	= pgtbl_cfg->arm_lpae_s1_cfg.mair;
>   
>   	/*
> @@ -2226,6 +2233,9 @@ static int arm_smmu_domain_finalise(struct iommu_domain *domain,
>   		.iommu_dev	= smmu->dev,
>   	};
>   
> +	if (smmu->features & arm_smmu_dbm_capable(smmu))
> +		pgtbl_cfg.quirks |= IO_PGTABLE_QUIRK_ARM_HD;
> +
>   	pgtbl_ops = alloc_io_pgtable_ops(fmt, &pgtbl_cfg, smmu_domain);
>   	if (!pgtbl_ops)
>   		return -ENOMEM;
> diff --git a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h
> index d82dd125446c..83d6f3a2554f 100644
> --- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h
> +++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h
> @@ -288,6 +288,9 @@
>   #define CTXDESC_CD_0_TCR_IPS		GENMASK_ULL(34, 32)
>   #define CTXDESC_CD_0_TCR_TBI0		(1ULL << 38)
>   
> +#define CTXDESC_CD_0_TCR_HA            (1UL << 43)
> +#define CTXDESC_CD_0_TCR_HD            (1UL << 42)
> +
>   #define CTXDESC_CD_0_AA64		(1UL << 41)
>   #define CTXDESC_CD_0_S			(1UL << 44)
>   #define CTXDESC_CD_0_R			(1UL << 45)
> diff --git a/drivers/iommu/io-pgtable-arm.c b/drivers/iommu/io-pgtable-arm.c
> index 72dcdd468cf3..b2f470529459 100644
> --- a/drivers/iommu/io-pgtable-arm.c
> +++ b/drivers/iommu/io-pgtable-arm.c
> @@ -75,6 +75,7 @@
>   
>   #define ARM_LPAE_PTE_NSTABLE		(((arm_lpae_iopte)1) << 63)
>   #define ARM_LPAE_PTE_XN			(((arm_lpae_iopte)3) << 53)
> +#define ARM_LPAE_PTE_DBM		(((arm_lpae_iopte)1) << 51)
>   #define ARM_LPAE_PTE_AF			(((arm_lpae_iopte)1) << 10)
>   #define ARM_LPAE_PTE_SH_NS		(((arm_lpae_iopte)0) << 8)
>   #define ARM_LPAE_PTE_SH_OS		(((arm_lpae_iopte)2) << 8)
> @@ -84,7 +85,7 @@
>   
>   #define ARM_LPAE_PTE_ATTR_LO_MASK	(((arm_lpae_iopte)0x3ff) << 2)
>   /* Ignore the contiguous bit for block splitting */
> -#define ARM_LPAE_PTE_ATTR_HI_MASK	(((arm_lpae_iopte)6) << 52)
> +#define ARM_LPAE_PTE_ATTR_HI_MASK	(((arm_lpae_iopte)13) << 51)
>   #define ARM_LPAE_PTE_ATTR_MASK		(ARM_LPAE_PTE_ATTR_LO_MASK |	\
>   					 ARM_LPAE_PTE_ATTR_HI_MASK)
>   /* Software bit for solving coherency races */
> @@ -93,6 +94,9 @@
>   /* Stage-1 PTE */
>   #define ARM_LPAE_PTE_AP_UNPRIV		(((arm_lpae_iopte)1) << 6)
>   #define ARM_LPAE_PTE_AP_RDONLY		(((arm_lpae_iopte)2) << 6)
> +#define ARM_LPAE_PTE_AP_RDONLY_BIT	7
> +#define ARM_LPAE_PTE_AP_WRITABLE	(ARM_LPAE_PTE_AP_RDONLY | \
> +					 ARM_LPAE_PTE_DBM)
>   #define ARM_LPAE_PTE_ATTRINDX_SHIFT	2
>   #define ARM_LPAE_PTE_nG			(((arm_lpae_iopte)1) << 11)
>   
> @@ -407,6 +411,8 @@ static arm_lpae_iopte arm_lpae_prot_to_pte(struct arm_lpae_io_pgtable *data,
>   		pte = ARM_LPAE_PTE_nG;
>   		if (!(prot & IOMMU_WRITE) && (prot & IOMMU_READ))
>   			pte |= ARM_LPAE_PTE_AP_RDONLY;
> +		else if (data->iop.cfg.quirks & IO_PGTABLE_QUIRK_ARM_HD)
> +			pte |= ARM_LPAE_PTE_AP_WRITABLE;
>   		if (!(prot & IOMMU_PRIV))
>   			pte |= ARM_LPAE_PTE_AP_UNPRIV;
>   	} else {
> @@ -804,7 +810,8 @@ arm_64_lpae_alloc_pgtable_s1(struct io_pgtable_cfg *cfg, void *cookie)
>   
>   	if (cfg->quirks & ~(IO_PGTABLE_QUIRK_ARM_NS |
>   			    IO_PGTABLE_QUIRK_ARM_TTBR1 |
> -			    IO_PGTABLE_QUIRK_ARM_OUTER_WBWA))
> +			    IO_PGTABLE_QUIRK_ARM_OUTER_WBWA |
> +			    IO_PGTABLE_QUIRK_ARM_HD))
>   		return NULL;
>   
>   	data = arm_lpae_alloc_pgtable(cfg);
> diff --git a/include/linux/io-pgtable.h b/include/linux/io-pgtable.h
> index 25142a0e2fc2..9a996ba7856d 100644
> --- a/include/linux/io-pgtable.h
> +++ b/include/linux/io-pgtable.h
> @@ -85,6 +85,8 @@ struct io_pgtable_cfg {
>   	 *
>   	 * IO_PGTABLE_QUIRK_ARM_OUTER_WBWA: Override the outer-cacheability
>   	 *	attributes set in the TCR for a non-coherent page-table walker.
> +	 *
> +	 * IO_PGTABLE_QUIRK_ARM_HD: Enables dirty tracking.
>   	 */
>   	#define IO_PGTABLE_QUIRK_ARM_NS			BIT(0)
>   	#define IO_PGTABLE_QUIRK_NO_PERMS		BIT(1)
> @@ -92,6 +94,8 @@ struct io_pgtable_cfg {
>   	#define IO_PGTABLE_QUIRK_ARM_MTK_TTBR_EXT	BIT(4)
>   	#define IO_PGTABLE_QUIRK_ARM_TTBR1		BIT(5)
>   	#define IO_PGTABLE_QUIRK_ARM_OUTER_WBWA		BIT(6)
> +	#define IO_PGTABLE_QUIRK_ARM_HD			BIT(7)
> +
>   	unsigned long			quirks;
>   	unsigned long			pgsize_bitmap;
>   	unsigned int			ias;
