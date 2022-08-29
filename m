Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4AD405A46A3
	for <lists+kvm@lfdr.de>; Mon, 29 Aug 2022 12:00:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229709AbiH2J77 convert rfc822-to-8bit (ORCPT
        <rfc822;lists+kvm@lfdr.de>); Mon, 29 Aug 2022 05:59:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46156 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229772AbiH2J75 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 29 Aug 2022 05:59:57 -0400
Received: from szxga08-in.huawei.com (szxga08-in.huawei.com [45.249.212.255])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 088845F6F
        for <kvm@vger.kernel.org>; Mon, 29 Aug 2022 02:59:52 -0700 (PDT)
Received: from dggemv711-chm.china.huawei.com (unknown [172.30.72.56])
        by szxga08-in.huawei.com (SkyGuard) with ESMTP id 4MGQnB4JP0z1N7ct;
        Mon, 29 Aug 2022 17:56:14 +0800 (CST)
Received: from kwepemm600016.china.huawei.com (7.193.23.20) by
 dggemv711-chm.china.huawei.com (10.1.198.66) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.24; Mon, 29 Aug 2022 17:59:50 +0800
Received: from lhrpeml500005.china.huawei.com (7.191.163.240) by
 kwepemm600016.china.huawei.com (7.193.23.20) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.24; Mon, 29 Aug 2022 17:59:50 +0800
Received: from lhrpeml500005.china.huawei.com ([7.191.163.240]) by
 lhrpeml500005.china.huawei.com ([7.191.163.240]) with mapi id 15.01.2375.024;
 Mon, 29 Aug 2022 10:59:48 +0100
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
Subject: RE: [PATCH RFC 14/19] iommu/arm-smmu-v3: Add read_and_clear_dirty()
 support
Thread-Topic: [PATCH RFC 14/19] iommu/arm-smmu-v3: Add read_and_clear_dirty()
 support
Thread-Index: AQHYW0SN5oDg1Pi/6EmdT1oyGkQtZq3GXLLA
Date:   Mon, 29 Aug 2022 09:59:48 +0000
Message-ID: <e7801ac3ad934363acf04425f00971ef@huawei.com>
References: <20220428210933.3583-1-joao.m.martins@oracle.com>
 <20220428210933.3583-15-joao.m.martins@oracle.com>
In-Reply-To: <20220428210933.3583-15-joao.m.martins@oracle.com>
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
> Cornelia Huck <cohuck@redhat.com>; kvm@vger.kernel.org; jiangkunkun
> <jiangkunkun@huawei.com>
> Subject: [PATCH RFC 14/19] iommu/arm-smmu-v3: Add
> read_and_clear_dirty() support
> 
> .read_and_clear_dirty() IOMMU domain op takes care of
> reading the dirty bits (i.e. PTE has both DBM and AP[2] set)
> and marshalling into a bitmap of a given page size.
> 
> While reading the dirty bits we also clear the PTE AP[2]
> bit to mark it as writable-clean.
> 
> Structure it in a way that the IOPTE walker is generic,
> and so we pass a function pointer over what to do on a per-PTE
> basis. This is useful for a followup patch where we supply an
> io-pgtable op to enable DBM when starting/stopping dirty tracking.
> 
> Co-developed-by: Keqian Zhu <zhukeqian1@huawei.com>
> Signed-off-by: Keqian Zhu <zhukeqian1@huawei.com>
> Co-developed-by: Kunkun Jiang <jiangkunkun@huawei.com>
> Signed-off-by: Kunkun Jiang <jiangkunkun@huawei.com>
> Signed-off-by: Joao Martins <joao.m.martins@oracle.com>
> ---
>  drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c |  27 ++++++
>  drivers/iommu/io-pgtable-arm.c              | 102
> +++++++++++++++++++-
>  2 files changed, 128 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
> b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
> index 4dba53bde2e3..232057d20197 100644
> --- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
> +++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
> @@ -2743,6 +2743,32 @@ static int arm_smmu_enable_nesting(struct
> iommu_domain *domain)
>  	return ret;
>  }
> 
> +static int arm_smmu_read_and_clear_dirty(struct iommu_domain
> *domain,
> +					 unsigned long iova, size_t size,
> +					 struct iommu_dirty_bitmap *dirty)
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
> +	if (!ops || !ops->read_and_clear_dirty) {
> +		pr_err_once("io-pgtable don't support dirty tracking\n");
> +		return -ENODEV;
> +	}
> +
> +	ret = ops->read_and_clear_dirty(ops, iova, size, dirty);
> +
> +	return ret;
> +}
> +
>  static int arm_smmu_of_xlate(struct device *dev, struct of_phandle_args
> *args)
>  {
>  	return iommu_fwspec_add_ids(dev, args->args, 1);
> @@ -2871,6 +2897,7 @@ static struct iommu_ops arm_smmu_ops = {
>  		.iova_to_phys		= arm_smmu_iova_to_phys,
>  		.enable_nesting		= arm_smmu_enable_nesting,
>  		.free			= arm_smmu_domain_free,
> +		.read_and_clear_dirty	= arm_smmu_read_and_clear_dirty,
>  	}
>  };
> 
> diff --git a/drivers/iommu/io-pgtable-arm.c
> b/drivers/iommu/io-pgtable-arm.c
> index 94ff319ae8ac..3c99028d315a 100644
> --- a/drivers/iommu/io-pgtable-arm.c
> +++ b/drivers/iommu/io-pgtable-arm.c
> @@ -75,6 +75,7 @@
> 
>  #define ARM_LPAE_PTE_NSTABLE		(((arm_lpae_iopte)1) << 63)
>  #define ARM_LPAE_PTE_XN			(((arm_lpae_iopte)3) << 53)
> +#define ARM_LPAE_PTE_DBM		(((arm_lpae_iopte)1) << 51)
>  #define ARM_LPAE_PTE_AF			(((arm_lpae_iopte)1) << 10)
>  #define ARM_LPAE_PTE_SH_NS		(((arm_lpae_iopte)0) << 8)
>  #define ARM_LPAE_PTE_SH_OS		(((arm_lpae_iopte)2) << 8)
> @@ -84,7 +85,7 @@
> 
>  #define ARM_LPAE_PTE_ATTR_LO_MASK	(((arm_lpae_iopte)0x3ff) << 2)
>  /* Ignore the contiguous bit for block splitting */
> -#define ARM_LPAE_PTE_ATTR_HI_MASK	(((arm_lpae_iopte)6) << 52)
> +#define ARM_LPAE_PTE_ATTR_HI_MASK	(((arm_lpae_iopte)13) << 51)
>  #define ARM_LPAE_PTE_ATTR_MASK		(ARM_LPAE_PTE_ATTR_LO_MASK
> |	\
>  					 ARM_LPAE_PTE_ATTR_HI_MASK)
>  /* Software bit for solving coherency races */
> @@ -93,6 +94,9 @@
>  /* Stage-1 PTE */
>  #define ARM_LPAE_PTE_AP_UNPRIV		(((arm_lpae_iopte)1) << 6)
>  #define ARM_LPAE_PTE_AP_RDONLY		(((arm_lpae_iopte)2) << 6)
> +#define ARM_LPAE_PTE_AP_RDONLY_BIT	7
> +#define ARM_LPAE_PTE_AP_WRITABLE	(ARM_LPAE_PTE_AP_RDONLY | \
> +					 ARM_LPAE_PTE_DBM)
>  #define ARM_LPAE_PTE_ATTRINDX_SHIFT	2
>  #define ARM_LPAE_PTE_nG			(((arm_lpae_iopte)1) << 11)
> 
> @@ -737,6 +741,101 @@ static phys_addr_t arm_lpae_iova_to_phys(struct
> io_pgtable_ops *ops,
>  	return iopte_to_paddr(pte, data) | iova;
>  }
> 
> +static int __arm_lpae_read_and_clear_dirty(unsigned long iova, size_t size,
> +					   arm_lpae_iopte *ptep, void *opaque)
> +{
> +	struct iommu_dirty_bitmap *dirty = opaque;
> +	arm_lpae_iopte pte;
> +
> +	pte = READ_ONCE(*ptep);
> +	if (WARN_ON(!pte))
> +		return -EINVAL;
> +
> +	if (pte & ARM_LPAE_PTE_AP_WRITABLE)
> +		return 0;

We might have set ARM_LPAE_PTE_DBM already. So does the above needs to be,
if ((pte & ARM_LPAE_PTE_AP_WRITABLE) == ARM_LPAE_PTE_AP_WRITABLE) ?

Thanks,
Shameer

> +
> +	if (!(pte & ARM_LPAE_PTE_DBM))
> +		return 0;
> +
> +	iommu_dirty_bitmap_record(dirty, iova, size);
> +	set_bit(ARM_LPAE_PTE_AP_RDONLY_BIT, (unsigned long *)ptep);
> +	return 0;
> +}
> +
> +static int __arm_lpae_iopte_walk(struct arm_lpae_io_pgtable *data,
> +				 unsigned long iova, size_t size,
> +				 int lvl, arm_lpae_iopte *ptep,
> +				 int (*fn)(unsigned long iova, size_t size,
> +					   arm_lpae_iopte *pte, void *opaque),
> +				 void *opaque)
> +{
> +	arm_lpae_iopte pte;
> +	struct io_pgtable *iop = &data->iop;
> +	size_t base, next_size;
> +	int ret;
> +
> +	if (WARN_ON_ONCE(!fn))
> +		return -EINVAL;
> +
> +	if (WARN_ON(lvl == ARM_LPAE_MAX_LEVELS))
> +		return -EINVAL;
> +
> +	ptep += ARM_LPAE_LVL_IDX(iova, lvl, data);
> +	pte = READ_ONCE(*ptep);
> +	if (WARN_ON(!pte))
> +		return -EINVAL;
> +
> +	if (size == ARM_LPAE_BLOCK_SIZE(lvl, data)) {
> +		if (iopte_leaf(pte, lvl, iop->fmt))
> +			return fn(iova, size, ptep, opaque);
> +
> +		/* Current level is table, traverse next level */
> +		next_size = ARM_LPAE_BLOCK_SIZE(lvl + 1, data);
> +		ptep = iopte_deref(pte, data);
> +		for (base = 0; base < size; base += next_size) {
> +			ret = __arm_lpae_iopte_walk(data, iova + base,
> +						    next_size, lvl + 1, ptep,
> +						    fn, opaque);
> +			if (ret)
> +				return ret;
> +		}
> +		return 0;
> +	} else if (iopte_leaf(pte, lvl, iop->fmt)) {
> +		return fn(iova, size, ptep, opaque);
> +	}
> +
> +	/* Keep on walkin */
> +	ptep = iopte_deref(pte, data);
> +	return __arm_lpae_iopte_walk(data, iova, size, lvl + 1, ptep,
> +				     fn, opaque);
> +}
> +
> +static int arm_lpae_read_and_clear_dirty(struct io_pgtable_ops *ops,
> +					 unsigned long iova, size_t size,
> +					 struct iommu_dirty_bitmap *dirty)
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
> +				     __arm_lpae_read_and_clear_dirty, dirty);
> +}
> +
>  static void arm_lpae_restrict_pgsizes(struct io_pgtable_cfg *cfg)
>  {
>  	unsigned long granule, page_sizes;
> @@ -817,6 +916,7 @@ arm_lpae_alloc_pgtable(struct io_pgtable_cfg *cfg)
>  		.unmap		= arm_lpae_unmap,
>  		.unmap_pages	= arm_lpae_unmap_pages,
>  		.iova_to_phys	= arm_lpae_iova_to_phys,
> +		.read_and_clear_dirty = arm_lpae_read_and_clear_dirty,
>  	};
> 
>  	return data;
> --
> 2.17.2

