Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7D0625A46A6
	for <lists+kvm@lfdr.de>; Mon, 29 Aug 2022 12:00:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229895AbiH2KAX convert rfc822-to-8bit (ORCPT
        <rfc822;lists+kvm@lfdr.de>); Mon, 29 Aug 2022 06:00:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46684 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229980AbiH2KAS (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 29 Aug 2022 06:00:18 -0400
Received: from szxga03-in.huawei.com (szxga03-in.huawei.com [45.249.212.189])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 27212A185
        for <kvm@vger.kernel.org>; Mon, 29 Aug 2022 03:00:12 -0700 (PDT)
Received: from dggemv711-chm.china.huawei.com (unknown [172.30.72.57])
        by szxga03-in.huawei.com (SkyGuard) with ESMTP id 4MGQqj2j1mzHnVS;
        Mon, 29 Aug 2022 17:58:25 +0800 (CST)
Received: from kwepemm600015.china.huawei.com (7.193.23.52) by
 dggemv711-chm.china.huawei.com (10.1.198.66) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.24; Mon, 29 Aug 2022 18:00:10 +0800
Received: from lhrpeml500005.china.huawei.com (7.191.163.240) by
 kwepemm600015.china.huawei.com (7.193.23.52) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.24; Mon, 29 Aug 2022 18:00:09 +0800
Received: from lhrpeml500005.china.huawei.com ([7.191.163.240]) by
 lhrpeml500005.china.huawei.com ([7.191.163.240]) with mapi id 15.01.2375.024;
 Mon, 29 Aug 2022 11:00:07 +0100
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
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>
Subject: RE: [PATCH RFC 15/19] iommu/arm-smmu-v3: Add
 set_dirty_tracking_range() support
Thread-Topic: [PATCH RFC 15/19] iommu/arm-smmu-v3: Add
 set_dirty_tracking_range() support
Thread-Index: AQHYW0SOJt+hrtPz+UGjCaMWTRJpLK3GS1vw
Date:   Mon, 29 Aug 2022 10:00:07 +0000
Message-ID: <0ec9388a1db441c79c8f38d2d2e8f1c2@huawei.com>
References: <20220428210933.3583-1-joao.m.martins@oracle.com>
 <20220428210933.3583-16-joao.m.martins@oracle.com>
In-Reply-To: <20220428210933.3583-16-joao.m.martins@oracle.com>
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
> Sent: 28 April 2022 22:09
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
> Cornelia Huck <cohuck@redhat.com>; kvm@vger.kernel.org
> Subject: [PATCH RFC 15/19] iommu/arm-smmu-v3: Add
> set_dirty_tracking_range() support
> 
> Similar to .read_and_clear_dirty() use the page table
> walker helper functions and set DBM|RDONLY bit, thus
> switching the IOPTE to writeable-clean.
> 
> Signed-off-by: Joao Martins <joao.m.martins@oracle.com>
> ---
>  drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c | 29 ++++++++++++
>  drivers/iommu/io-pgtable-arm.c              | 52
> +++++++++++++++++++++
>  2 files changed, 81 insertions(+)
> 
> diff --git a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
> b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
> index 232057d20197..1ca72fcca930 100644
> --- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
> +++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
> @@ -2769,6 +2769,34 @@ static int
> arm_smmu_read_and_clear_dirty(struct iommu_domain *domain,
>  	return ret;
>  }
> 
> +static int arm_smmu_set_dirty_tracking(struct iommu_domain *domain,
> +				       unsigned long iova, size_t size,
> +				       struct iommu_iotlb_gather *iotlb_gather,
> +				       bool enabled)
> +{
> +	struct arm_smmu_domain *smmu_domain =
> to_smmu_domain(domain);
> +	struct io_pgtable_ops *ops = smmu_domain->pgtbl_ops;
> +	struct arm_smmu_device *smmu = smmu_domain->smmu;
> +	int ret;
> +
> +	if (!(smmu->features & ARM_SMMU_FEAT_HD) ||
> +	    !(smmu->features & ARM_SMMU_FEAT_BBML2))
> +		return -ENODEV;
> +
> +	if (smmu_domain->stage != ARM_SMMU_DOMAIN_S1)
> +		return -EINVAL;
> +
> +	if (!ops || !ops->set_dirty_tracking) {
> +		pr_err_once("io-pgtable don't support dirty tracking\n");
> +		return -ENODEV;
> +	}
> +
> +	ret = ops->set_dirty_tracking(ops, iova, size, enabled);
> +	iommu_iotlb_gather_add_range(iotlb_gather, iova, size);
> +
> +	return ret;
> +}
> +
>  static int arm_smmu_of_xlate(struct device *dev, struct of_phandle_args
> *args)
>  {
>  	return iommu_fwspec_add_ids(dev, args->args, 1);
> @@ -2898,6 +2926,7 @@ static struct iommu_ops arm_smmu_ops = {
>  		.enable_nesting		= arm_smmu_enable_nesting,
>  		.free			= arm_smmu_domain_free,
>  		.read_and_clear_dirty	= arm_smmu_read_and_clear_dirty,
> +		.set_dirty_tracking_range = arm_smmu_set_dirty_tracking,
>  	}
>  };
> 
> diff --git a/drivers/iommu/io-pgtable-arm.c
> b/drivers/iommu/io-pgtable-arm.c
> index 3c99028d315a..361410aa836c 100644
> --- a/drivers/iommu/io-pgtable-arm.c
> +++ b/drivers/iommu/io-pgtable-arm.c
> @@ -76,6 +76,7 @@
>  #define ARM_LPAE_PTE_NSTABLE		(((arm_lpae_iopte)1) << 63)
>  #define ARM_LPAE_PTE_XN			(((arm_lpae_iopte)3) << 53)
>  #define ARM_LPAE_PTE_DBM		(((arm_lpae_iopte)1) << 51)
> +#define ARM_LPAE_PTE_DBM_BIT		51
>  #define ARM_LPAE_PTE_AF			(((arm_lpae_iopte)1) << 10)
>  #define ARM_LPAE_PTE_SH_NS		(((arm_lpae_iopte)0) << 8)
>  #define ARM_LPAE_PTE_SH_OS		(((arm_lpae_iopte)2) << 8)
> @@ -836,6 +837,56 @@ static int arm_lpae_read_and_clear_dirty(struct
> io_pgtable_ops *ops,
>  				     __arm_lpae_read_and_clear_dirty, dirty);
>  }
> 
> +static int __arm_lpae_set_dirty_modifier(unsigned long iova, size_t size,
> +					 arm_lpae_iopte *ptep, void *opaque)
> +{
> +	bool enabled = *((bool *) opaque);
> +	arm_lpae_iopte pte;
> +
> +	pte = READ_ONCE(*ptep);
> +	if (WARN_ON(!pte))
> +		return -EINVAL;
> +
> +	if ((pte & ARM_LPAE_PTE_AP_WRITABLE) ==
> ARM_LPAE_PTE_AP_RDONLY)
> +		return -EINVAL;
> +
> +	if (!(enabled ^ !(pte & ARM_LPAE_PTE_DBM)))
> +		return 0;

Does the above needs to be double negative?

if (!(enabled ^ !!(pte & ARM_LPAE_PTE_DBM)))

Thanks,
Shameer

> +
> +	pte = enabled ? pte | (ARM_LPAE_PTE_DBM |
> ARM_LPAE_PTE_AP_RDONLY) :
> +		pte & ~(ARM_LPAE_PTE_DBM | ARM_LPAE_PTE_AP_RDONLY);
> +
> +	WRITE_ONCE(*ptep, pte);
> +	return 0;
> +}
> +
> +
> +static int arm_lpae_set_dirty_tracking(struct io_pgtable_ops *ops,
> +				       unsigned long iova, size_t size,
> +				       bool enabled)
> +{
> +	struct arm_lpae_io_pgtable *data = io_pgtable_ops_to_data(ops);
> +	struct io_pgtable_cfg *cfg = &data->iop.cfg;
> +	arm_lpae_iopte *ptep = data->pgd;
> +	int lvl = data->start_level;
> +	long iaext = (s64)iova >> cfg->ias;
> +
> +	if (WARN_ON(!size || (size & cfg->pgsize_bitmap) != size))
> +		return -EINVAL;
> +
> +	if (cfg->quirks & IO_PGTABLE_QUIRK_ARM_TTBR1)
> +		iaext = ~iaext;
> +	if (WARN_ON(iaext))
> +		return -EINVAL;
> +
> +	if (data->iop.fmt != ARM_64_LPAE_S1 &&
> +	    data->iop.fmt != ARM_32_LPAE_S1)
> +		return -EINVAL;
> +
> +	return __arm_lpae_iopte_walk(data, iova, size, lvl, ptep,
> +				     __arm_lpae_set_dirty_modifier, &enabled);
> +}
> +
>  static void arm_lpae_restrict_pgsizes(struct io_pgtable_cfg *cfg)
>  {
>  	unsigned long granule, page_sizes;
> @@ -917,6 +968,7 @@ arm_lpae_alloc_pgtable(struct io_pgtable_cfg *cfg)
>  		.unmap_pages	= arm_lpae_unmap_pages,
>  		.iova_to_phys	= arm_lpae_iova_to_phys,
>  		.read_and_clear_dirty = arm_lpae_read_and_clear_dirty,
> +		.set_dirty_tracking   = arm_lpae_set_dirty_tracking,
>  	};
> 
>  	return data;
> --
> 2.17.2

