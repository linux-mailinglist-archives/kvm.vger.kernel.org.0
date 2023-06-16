Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 162D8733664
	for <lists+kvm@lfdr.de>; Fri, 16 Jun 2023 18:46:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345302AbjFPQqS convert rfc822-to-8bit (ORCPT
        <rfc822;lists+kvm@lfdr.de>); Fri, 16 Jun 2023 12:46:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33884 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231138AbjFPQqR (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 16 Jun 2023 12:46:17 -0400
Received: from frasgout.his.huawei.com (frasgout.his.huawei.com [185.176.79.56])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 83D852D4E
        for <kvm@vger.kernel.org>; Fri, 16 Jun 2023 09:46:14 -0700 (PDT)
Received: from lhrpeml500001.china.huawei.com (unknown [172.18.147.226])
        by frasgout.his.huawei.com (SkyGuard) with ESMTP id 4QjQ336PCLz6GDcJ;
        Sat, 17 Jun 2023 00:43:43 +0800 (CST)
Received: from lhrpeml500005.china.huawei.com (7.191.163.240) by
 lhrpeml500001.china.huawei.com (7.191.163.213) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Fri, 16 Jun 2023 17:46:11 +0100
Received: from lhrpeml500005.china.huawei.com ([7.191.163.240]) by
 lhrpeml500005.china.huawei.com ([7.191.163.240]) with mapi id 15.01.2507.023;
 Fri, 16 Jun 2023 17:46:11 +0100
From:   Shameerali Kolothum Thodi <shameerali.kolothum.thodi@huawei.com>
To:     Joao Martins <joao.m.martins@oracle.com>,
        "iommu@lists.linux.dev" <iommu@lists.linux.dev>
CC:     Jason Gunthorpe <jgg@nvidia.com>,
        Kevin Tian <kevin.tian@intel.com>,
        "Lu Baolu" <baolu.lu@linux.intel.com>, Yi Liu <yi.l.liu@intel.com>,
        Yi Y Sun <yi.y.sun@intel.com>,
        Eric Auger <eric.auger@redhat.com>,
        Nicolin Chen <nicolinc@nvidia.com>,
        Joerg Roedel <joro@8bytes.org>,
        Jean-Philippe Brucker <jean-philippe@linaro.org>,
        Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>,
        Will Deacon <will@kernel.org>,
        Robin Murphy <robin.murphy@arm.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>
Subject: RE: [PATCH RFCv2 22/24] iommu/arm-smmu-v3: Add read_and_clear_dirty()
 support
Thread-Topic: [PATCH RFCv2 22/24] iommu/arm-smmu-v3: Add
 read_and_clear_dirty() support
Thread-Index: AQHZico8F+XQQUgz40mrFEyLOBzMNa+NzyIQ
Date:   Fri, 16 Jun 2023 16:46:11 +0000
Message-ID: <c4696aad77ef49e7b3c550c19b354223@huawei.com>
References: <20230518204650.14541-1-joao.m.martins@oracle.com>
 <20230518204650.14541-23-joao.m.martins@oracle.com>
In-Reply-To: <20230518204650.14541-23-joao.m.martins@oracle.com>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.202.227.178]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H4,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Joao,

> -----Original Message-----
> From: Joao Martins [mailto:joao.m.martins@oracle.com]
> Sent: 18 May 2023 21:47
> To: iommu@lists.linux.dev
> Cc: Jason Gunthorpe <jgg@nvidia.com>; Kevin Tian <kevin.tian@intel.com>;
> Shameerali Kolothum Thodi <shameerali.kolothum.thodi@huawei.com>; Lu
> Baolu <baolu.lu@linux.intel.com>; Yi Liu <yi.l.liu@intel.com>; Yi Y Sun
> <yi.y.sun@intel.com>; Eric Auger <eric.auger@redhat.com>; Nicolin Chen
> <nicolinc@nvidia.com>; Joerg Roedel <joro@8bytes.org>; Jean-Philippe
> Brucker <jean-philippe@linaro.org>; Suravee Suthikulpanit
> <suravee.suthikulpanit@amd.com>; Will Deacon <will@kernel.org>; Robin
> Murphy <robin.murphy@arm.com>; Alex Williamson
> <alex.williamson@redhat.com>; kvm@vger.kernel.org; Joao Martins
> <joao.m.martins@oracle.com>
> Subject: [PATCH RFCv2 22/24] iommu/arm-smmu-v3: Add
> read_and_clear_dirty() support
> 
> From: Keqian Zhu <zhukeqian1@huawei.com>
> 
> .read_and_clear_dirty() IOMMU domain op takes care of reading the dirty
> bits (i.e. PTE has both DBM and AP[2] set) and marshalling into a bitmap of
> a given page size.
> 
> While reading the dirty bits we also clear the PTE AP[2] bit to mark it as
> writable-clean depending on read_and_clear_dirty() flags.
> 
> Structure it in a way that the IOPTE walker is generic, and so we pass a
> function pointer over what to do on a per-PTE basis.
> 
> [Link below points to the original version that was based on]
> 
> Link:
> https://lore.kernel.org/lkml/20210413085457.25400-11-zhukeqian1@huaw
> ei.com/
> Co-developed-by: Keqian Zhu <zhukeqian1@huawei.com>
> Co-developed-by: Kunkun Jiang <jiangkunkun@huawei.com>
> Signed-off-by: Kunkun Jiang <jiangkunkun@huawei.com>
> [joaomart: Massage commit message]
> Co-developed-by: Joao Martins <joao.m.martins@oracle.com>
> Signed-off-by: Joao Martins <joao.m.martins@oracle.com>
> ---
>  drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c |  23 +++++
>  drivers/iommu/io-pgtable-arm.c              | 104
> ++++++++++++++++++++
>  2 files changed, 127 insertions(+)
> 
> diff --git a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
> b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
> index e2b98a6a6b74..2cde14003469 100644
> --- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
> +++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
> @@ -2765,6 +2765,28 @@ static int arm_smmu_enable_nesting(struct
> iommu_domain *domain)
>  	return ret;
>  }
> 
> +static int arm_smmu_read_and_clear_dirty(struct iommu_domain
> *domain,
> +					 unsigned long iova, size_t size,
> +					 unsigned long flags,
> +					 struct iommu_dirty_bitmap *dirty)
> +{
> +	struct arm_smmu_domain *smmu_domain =
> to_smmu_domain(domain);
> +	struct io_pgtable_ops *ops = smmu_domain->pgtbl_ops;
> +	int ret;
> +
> +	if (smmu_domain->stage != ARM_SMMU_DOMAIN_S1)
> +		return -EINVAL;
> +
> +	if (!ops || !ops->read_and_clear_dirty) {
> +		pr_err_once("io-pgtable don't support dirty tracking\n");
> +		return -ENODEV;
> +	}
> +
> +	ret = ops->read_and_clear_dirty(ops, iova, size, flags, dirty);
> +
> +	return ret;
> +}
> +
>  static int arm_smmu_of_xlate(struct device *dev, struct of_phandle_args
> *args)
>  {
>  	return iommu_fwspec_add_ids(dev, args->args, 1);
> @@ -2893,6 +2915,7 @@ static struct iommu_ops arm_smmu_ops = {
>  		.iova_to_phys		= arm_smmu_iova_to_phys,
>  		.enable_nesting		= arm_smmu_enable_nesting,
>  		.free			= arm_smmu_domain_free,
> +		.read_and_clear_dirty	= arm_smmu_read_and_clear_dirty,
>  	}
>  };
> 
> diff --git a/drivers/iommu/io-pgtable-arm.c
> b/drivers/iommu/io-pgtable-arm.c
> index b2f470529459..de9e61f8452d 100644
> --- a/drivers/iommu/io-pgtable-arm.c
> +++ b/drivers/iommu/io-pgtable-arm.c
> @@ -717,6 +717,109 @@ static phys_addr_t arm_lpae_iova_to_phys(struct
> io_pgtable_ops *ops,
>  	return iopte_to_paddr(pte, data) | iova;
>  }
> 
> +struct arm_lpae_iopte_read_dirty {
> +	unsigned long flags;
> +	struct iommu_dirty_bitmap *dirty;
> +};
> +
> +static int __arm_lpae_read_and_clear_dirty(unsigned long iova, size_t size,
> +					   arm_lpae_iopte *ptep, void *opaque)
> +{
> +	struct arm_lpae_iopte_read_dirty *arg = opaque;
> +	struct iommu_dirty_bitmap *dirty = arg->dirty;
> +	arm_lpae_iopte pte;
> +
> +	pte = READ_ONCE(*ptep);
> +	if (WARN_ON(!pte))
> +		return -EINVAL;
> +
> +	if ((pte & ARM_LPAE_PTE_AP_WRITABLE) ==
> ARM_LPAE_PTE_AP_WRITABLE)
> +		return 0;
> +
> +	iommu_dirty_bitmap_record(dirty, iova, size);
> +	if (!(arg->flags & IOMMU_DIRTY_NO_CLEAR))
> +		set_bit(ARM_LPAE_PTE_AP_RDONLY_BIT, (unsigned long *)ptep);
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
> +					 unsigned long flags,
> +					 struct iommu_dirty_bitmap *dirty)
> +{
> +	struct arm_lpae_io_pgtable *data = io_pgtable_ops_to_data(ops);
> +	struct io_pgtable_cfg *cfg = &data->iop.cfg;
> +	struct arm_lpae_iopte_read_dirty arg = {
> +		.flags = flags, .dirty = dirty,
> +	};
> +	arm_lpae_iopte *ptep = data->pgd;
> +	int lvl = data->start_level;
> +	long iaext = (s64)iova >> cfg->ias;
> +
> +	if (WARN_ON(!size || (size & cfg->pgsize_bitmap) != size))
> +		return -EINVAL;

I guess the size here is supposed to be one of the pgsize that iommu supports.
But looking at the code, it looks like we are passing the iova mapped length and
it fails here in my test setup. Could you please check and confirm.

Thanks,
Shameer


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
> +				     __arm_lpae_read_and_clear_dirty, &arg);
> +}
> +
>  static void arm_lpae_restrict_pgsizes(struct io_pgtable_cfg *cfg)
>  {
>  	unsigned long granule, page_sizes;
> @@ -795,6 +898,7 @@ arm_lpae_alloc_pgtable(struct io_pgtable_cfg *cfg)
>  		.map_pages	= arm_lpae_map_pages,
>  		.unmap_pages	= arm_lpae_unmap_pages,
>  		.iova_to_phys	= arm_lpae_iova_to_phys,
> +		.read_and_clear_dirty = arm_lpae_read_and_clear_dirty,
>  	};
> 
>  	return data;
> --
> 2.17.2

