Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 716AE5A46A7
	for <lists+kvm@lfdr.de>; Mon, 29 Aug 2022 12:00:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229463AbiH2KAi convert rfc822-to-8bit (ORCPT
        <rfc822;lists+kvm@lfdr.de>); Mon, 29 Aug 2022 06:00:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48396 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229921AbiH2KAe (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 29 Aug 2022 06:00:34 -0400
Received: from szxga02-in.huawei.com (szxga02-in.huawei.com [45.249.212.188])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 22F74A189
        for <kvm@vger.kernel.org>; Mon, 29 Aug 2022 03:00:33 -0700 (PDT)
Received: from dggemv703-chm.china.huawei.com (unknown [172.30.72.55])
        by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4MGQpF5rDyzlWW6;
        Mon, 29 Aug 2022 17:57:09 +0800 (CST)
Received: from kwepemm000013.china.huawei.com (7.193.23.81) by
 dggemv703-chm.china.huawei.com (10.3.19.46) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.24; Mon, 29 Aug 2022 18:00:31 +0800
Received: from lhrpeml500005.china.huawei.com (7.191.163.240) by
 kwepemm000013.china.huawei.com (7.193.23.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.24; Mon, 29 Aug 2022 18:00:30 +0800
Received: from lhrpeml500005.china.huawei.com ([7.191.163.240]) by
 lhrpeml500005.china.huawei.com ([7.191.163.240]) with mapi id 15.01.2375.024;
 Mon, 29 Aug 2022 11:00:28 +0100
From:   Shameerali Kolothum Thodi <shameerali.kolothum.thodi@huawei.com>
To:     Joao Martins <joao.m.martins@oracle.com>,
        "iommu@lists.linux-foundation.org" <iommu@lists.linux-foundation.org>
CC:     Joerg Roedel <joro@8bytes.org>,
        Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>,
        Will Deacon <will@kernel.org>,
        Robin Murphy <robin.murphy@arm.com>,
        Jean-Philippe Brucker <jean-philippe@linaro.org>,
        zhukeqian <zhukeqian1@huawei.com>,
        David Woodhouse <dwmw2@infradead.org>,
        "Lu Baolu" <baolu.lu@linux.intel.com>,
        Jason Gunthorpe <jgg@nvidia.com>,
        "Nicolin Chen" <nicolinc@nvidia.com>,
        Yishai Hadas <yishaih@nvidia.com>,
        Kevin Tian <kevin.tian@intel.com>,
        Eric Auger <eric.auger@redhat.com>,
        Yi Liu <yi.l.liu@intel.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        "Cornelia Huck" <cohuck@redhat.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        jiangkunkun <jiangkunkun@huawei.com>
Subject: RE: [PATCH RFC 16/19] iommu/arm-smmu-v3: Enable HTTU for stage1 with
 io-pgtable mapping
Thread-Topic: [PATCH RFC 16/19] iommu/arm-smmu-v3: Enable HTTU for stage1 with
 io-pgtable mapping
Thread-Index: AQHYW0SR1twbeG3dsECjk3V3+BLoTK3GTk/w
Date:   Mon, 29 Aug 2022 10:00:28 +0000
Message-ID: <52ac76ef336b48f2b16aeb001cc9cbf5@huawei.com>
References: <20220428210933.3583-1-joao.m.martins@oracle.com>
 <20220428210933.3583-17-joao.m.martins@oracle.com>
In-Reply-To: <20220428210933.3583-17-joao.m.martins@oracle.com>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.48.156.182]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



> -----Original Message-----
> From: Joao Martins [mailto:joao.m.martins@oracle.com]
> Sent: 28 April 2022 22:10
> To: iommu@lists.linux-foundation.org
> Cc: Joao Martins <joao.m.martins@oracle.com>; Joerg Roedel
> <joro@8bytes.org>; Suravee Suthikulpanit
> <suravee.suthikulpanit@amd.com>; Will Deacon <will@kernel.org>; Robin
> Murphy <robin.murphy@arm.com>; Jean-Philippe Brucker
> <jean-philippe@linaro.org>; zhukeqian <zhukeqian1@huawei.com>;
> Shameerali Kolothum Thodi <shameerali.kolothum.thodi@huawei.com>;
> David Woodhouse <dwmw2@infradead.org>; Lu Baolu
> <baolu.lu@linux.intel.com>; Jason Gunthorpe <jgg@nvidia.com>; Nicolin
> Chen <nicolinc@nvidia.com>; Yishai Hadas <yishaih@nvidia.com>; Kevin Tian
> <kevin.tian@intel.com>; Eric Auger <eric.auger@redhat.com>; Yi Liu
> <yi.l.liu@intel.com>; Alex Williamson <alex.williamson@redhat.com>;
> Cornelia Huck <cohuck@redhat.com>; kvm@vger.kernel.org; jiangkunkun
> <jiangkunkun@huawei.com>
> Subject: [PATCH RFC 16/19] iommu/arm-smmu-v3: Enable HTTU for stage1
> with io-pgtable mapping
> 
> From: Kunkun Jiang <jiangkunkun@huawei.com>
> 
> As nested mode is not upstreamed now, we just aim to support dirty log
> tracking for stage1 with io-pgtable mapping (means not support SVA
> mapping). If HTTU is supported, we enable HA/HD bits in the SMMU CD and
> transfer ARM_HD quirk to io-pgtable.
> 
> We additionally filter out HD|HA if not supportted. The CD.HD bit is not
> particularly useful unless we toggle the DBM bit in the PTE entries.
> 
> Co-developed-by: Keqian Zhu <zhukeqian1@huawei.com>
> Signed-off-by: Keqian Zhu <zhukeqian1@huawei.com>
> Signed-off-by: Kunkun Jiang <jiangkunkun@huawei.com> [joaomart:Convey
> HD|HA bits over to the context descriptor  and update commit message]
> Signed-off-by: Joao Martins <joao.m.martins@oracle.com>
> ---
>  drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c | 11 +++++++++++
> drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h |  3 +++
>  include/linux/io-pgtable.h                  |  1 +
>  3 files changed, 15 insertions(+)
> 
> diff --git a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
> b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
> index 1ca72fcca930..5f728f8f20a2 100644
> --- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
> +++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
> @@ -1077,10 +1077,18 @@ int arm_smmu_write_ctx_desc(struct
> arm_smmu_domain *smmu_domain, int ssid,
>  		 * this substream's traffic
>  		 */
>  	} else { /* (1) and (2) */
> +		struct arm_smmu_device *smmu = smmu_domain->smmu;
> +		u64 tcr = cd->tcr;
> +
>  		cdptr[1] = cpu_to_le64(cd->ttbr & CTXDESC_CD_1_TTB0_MASK);
>  		cdptr[2] = 0;
>  		cdptr[3] = cpu_to_le64(cd->mair);
> 
> +		if (!(smmu->features & ARM_SMMU_FEAT_HD))
> +			tcr &= ~CTXDESC_CD_0_TCR_HD;
> +		if (!(smmu->features & ARM_SMMU_FEAT_HA))
> +			tcr &= ~CTXDESC_CD_0_TCR_HA;
> +
>  		/*
>  		 * STE is live, and the SMMU might read dwords of this CD in any
>  		 * order. Ensure that it observes valid values before reading @@
> -2100,6 +2108,7 @@ static int arm_smmu_domain_finalise_s1(struct
> arm_smmu_domain *smmu_domain,
>  			  FIELD_PREP(CTXDESC_CD_0_TCR_ORGN0, tcr->orgn) |
>  			  FIELD_PREP(CTXDESC_CD_0_TCR_SH0, tcr->sh) |
>  			  FIELD_PREP(CTXDESC_CD_0_TCR_IPS, tcr->ips) |
> +			  CTXDESC_CD_0_TCR_HA | CTXDESC_CD_0_TCR_HD |
>  			  CTXDESC_CD_0_TCR_EPD1 | CTXDESC_CD_0_AA64;
>  	cfg->cd.mair	= pgtbl_cfg->arm_lpae_s1_cfg.mair;
> 
> @@ -2203,6 +2212,8 @@ static int arm_smmu_domain_finalise(struct
> iommu_domain *domain,
>  		.iommu_dev	= smmu->dev,
>  	};
> 
> +	if (smmu->features & ARM_SMMU_FEAT_HD)
> +		pgtbl_cfg.quirks |= IO_PGTABLE_QUIRK_ARM_HD;

Setting these quirk bits requires updating the check in arm_64_lpae_alloc_pgtable_s1()
in drivers/iommu/io-pgtable-arm.c

Thanks,
Shameer

>  	if (smmu->features & ARM_SMMU_FEAT_BBML1)
>  		pgtbl_cfg.quirks |= IO_PGTABLE_QUIRK_ARM_BBML1;
>  	else if (smmu->features & ARM_SMMU_FEAT_BBML2) diff --git
> a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h
> b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h
> index e15750be1d95..ff32242f2fdb 100644
> --- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h
> +++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h
> @@ -292,6 +292,9 @@
>  #define CTXDESC_CD_0_TCR_IPS		GENMASK_ULL(34, 32)
>  #define CTXDESC_CD_0_TCR_TBI0		(1ULL << 38)
> 
> +#define CTXDESC_CD_0_TCR_HA            (1UL << 43)
> +#define CTXDESC_CD_0_TCR_HD            (1UL << 42)
> +
>  #define CTXDESC_CD_0_AA64		(1UL << 41)
>  #define CTXDESC_CD_0_S			(1UL << 44)
>  #define CTXDESC_CD_0_R			(1UL << 45)
> diff --git a/include/linux/io-pgtable.h b/include/linux/io-pgtable.h index
> d7626ca67dbf..a11902ae9cf1 100644
> --- a/include/linux/io-pgtable.h
> +++ b/include/linux/io-pgtable.h
> @@ -87,6 +87,7 @@ struct io_pgtable_cfg {
>  	#define IO_PGTABLE_QUIRK_ARM_OUTER_WBWA	BIT(6)
>  	#define IO_PGTABLE_QUIRK_ARM_BBML1      BIT(7)
>  	#define IO_PGTABLE_QUIRK_ARM_BBML2      BIT(8)
> +	#define IO_PGTABLE_QUIRK_ARM_HD         BIT(9)
> 
>  	unsigned long			quirks;
>  	unsigned long			pgsize_bitmap;
> --
> 2.17.2

