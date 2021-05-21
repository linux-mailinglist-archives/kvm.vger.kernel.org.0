Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C924A38BFF6
	for <lists+kvm@lfdr.de>; Fri, 21 May 2021 08:48:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232616AbhEUGtb (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 21 May 2021 02:49:31 -0400
Received: from szxga05-in.huawei.com ([45.249.212.191]:3610 "EHLO
        szxga05-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231303AbhEUGtb (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 21 May 2021 02:49:31 -0400
Received: from dggems702-chm.china.huawei.com (unknown [172.30.72.59])
        by szxga05-in.huawei.com (SkyGuard) with ESMTP id 4FmcXf3CB9zQm2c;
        Fri, 21 May 2021 14:44:34 +0800 (CST)
Received: from dggema765-chm.china.huawei.com (10.1.198.207) by
 dggems702-chm.china.huawei.com (10.3.19.179) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256) id
 15.1.2176.2; Fri, 21 May 2021 14:48:06 +0800
Received: from [10.174.185.210] (10.174.185.210) by
 dggema765-chm.china.huawei.com (10.1.198.207) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.2176.2; Fri, 21 May 2021 14:48:05 +0800
Subject: Re: [PATCH v15 07/12] iommu/smmuv3: Implement cache_invalidate
To:     Eric Auger <eric.auger@redhat.com>, <eric.auger.pro@gmail.com>,
        <iommu@lists.linux-foundation.org>, <linux-kernel@vger.kernel.org>,
        <kvm@vger.kernel.org>, <kvmarm@lists.cs.columbia.edu>,
        <will@kernel.org>, <maz@kernel.org>, <robin.murphy@arm.com>,
        <joro@8bytes.org>, <alex.williamson@redhat.com>, <tn@semihalf.com>,
        <zhukeqian1@huawei.com>
CC:     <jacob.jun.pan@linux.intel.com>, <yi.l.liu@intel.com>,
        <wangxingang5@huawei.com>, <jean-philippe@linaro.org>,
        <zhangfei.gao@linaro.org>, <zhangfei.gao@gmail.com>,
        <vivek.gautam@arm.com>, <shameerali.kolothum.thodi@huawei.com>,
        <yuzenghui@huawei.com>, <nicoleotsuka@gmail.com>,
        <lushenming@huawei.com>, <vsethi@nvidia.com>,
        <chenxiang66@hisilicon.com>, <vdumpa@nvidia.com>,
        <wanghaibin.wang@huawei.com>
References: <20210411111228.14386-1-eric.auger@redhat.com>
 <20210411111228.14386-8-eric.auger@redhat.com>
From:   Kunkun Jiang <jiangkunkun@huawei.com>
Message-ID: <fa06a2bf-9e85-8f05-cf51-10f694f486ff@huawei.com>
Date:   Fri, 21 May 2021 14:48:04 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.1
MIME-Version: 1.0
In-Reply-To: <20210411111228.14386-8-eric.auger@redhat.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-Originating-IP: [10.174.185.210]
X-ClientProxiedBy: dggeme708-chm.china.huawei.com (10.1.199.104) To
 dggema765-chm.china.huawei.com (10.1.198.207)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Eric,

On 2021/4/11 19:12, Eric Auger wrote:
> Implement domain-selective, pasid selective and page-selective
> IOTLB invalidations.
>
> Signed-off-by: Eric Auger <eric.auger@redhat.com>
>
> ---
> v4 -> v15:
> - remove the redundant arm_smmu_cmdq_issue_sync(smmu)
>    in IOMMU_INV_GRANU_ADDR case (Zenghui)
> - if RIL is not supported by the host, make sure the granule_size
>    that is passed by the userspace is supported or fix it
>    (Chenxiang)
>
> v13 -> v14:
> - Add domain invalidation
> - do global inval when asid is not provided with addr
>    granularity
>
> v7 -> v8:
> - ASID based invalidation using iommu_inv_pasid_info
> - check ARCHID/PASID flags in addr based invalidation
> - use __arm_smmu_tlb_inv_context and __arm_smmu_tlb_inv_range_nosync
>
> v6 -> v7
> - check the uapi version
>
> v3 -> v4:
> - adapt to changes in the uapi
> - add support for leaf parameter
> - do not use arm_smmu_tlb_inv_range_nosync or arm_smmu_tlb_inv_context
>    anymore
>
> v2 -> v3:
> - replace __arm_smmu_tlb_sync by arm_smmu_cmdq_issue_sync
>
> v1 -> v2:
> - properly pass the asid
> ---
>   drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c | 89 +++++++++++++++++++++
>   1 file changed, 89 insertions(+)
>
> diff --git a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
> index 56a301fbe75a..bfc112cc0d38 100644
> --- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
> +++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
> @@ -2961,6 +2961,94 @@ static void arm_smmu_detach_pasid_table(struct iommu_domain *domain)
>   	mutex_unlock(&smmu_domain->init_mutex);
>   }
>   
> +static int
> +arm_smmu_cache_invalidate(struct iommu_domain *domain, struct device *dev,
> +			  struct iommu_cache_invalidate_info *inv_info)
> +{
> +	struct arm_smmu_cmdq_ent cmd = {.opcode = CMDQ_OP_TLBI_NSNH_ALL};
> +	struct arm_smmu_domain *smmu_domain = to_smmu_domain(domain);
> +	struct arm_smmu_device *smmu = smmu_domain->smmu;
> +
> +	if (smmu_domain->stage != ARM_SMMU_DOMAIN_NESTED)
> +		return -EINVAL;
> +
> +	if (!smmu)
> +		return -EINVAL;
> +
> +	if (inv_info->version != IOMMU_CACHE_INVALIDATE_INFO_VERSION_1)
> +		return -EINVAL;
> +
> +	if (inv_info->cache & IOMMU_CACHE_INV_TYPE_PASID ||
> +	    inv_info->cache & IOMMU_CACHE_INV_TYPE_DEV_IOTLB) {
> +		return -ENOENT;
> +	}
> +
> +	if (!(inv_info->cache & IOMMU_CACHE_INV_TYPE_IOTLB))
> +		return -EINVAL;
> +
> +	/* IOTLB invalidation */
> +
> +	switch (inv_info->granularity) {
> +	case IOMMU_INV_GRANU_PASID:
> +	{
> +		struct iommu_inv_pasid_info *info =
> +			&inv_info->granu.pasid_info;
> +
> +		if (info->flags & IOMMU_INV_ADDR_FLAGS_PASID)
> +			return -ENOENT;
> +		if (!(info->flags & IOMMU_INV_PASID_FLAGS_ARCHID))
> +			return -EINVAL;
> +
> +		__arm_smmu_tlb_inv_context(smmu_domain, info->archid);
> +		return 0;
> +	}
> +	case IOMMU_INV_GRANU_ADDR:
> +	{
> +		struct iommu_inv_addr_info *info = &inv_info->granu.addr_info;
> +		size_t granule_size  = info->granule_size;
> +		size_t size = info->nb_granules * info->granule_size;
> +		bool leaf = info->flags & IOMMU_INV_ADDR_FLAGS_LEAF;
> +		int tg;
> +
> +		if (info->flags & IOMMU_INV_ADDR_FLAGS_PASID)
> +			return -ENOENT;
> +
> +		if (!(info->flags & IOMMU_INV_ADDR_FLAGS_ARCHID))
> +			break;
> +
> +		tg = __ffs(granule_size);
> +		if (granule_size & ~(1 << tg))
> +			return -EINVAL;
> +		/*
> +		 * When RIL is not supported, make sure the granule size that is
> +		 * passed is supported. In RIL mode, this is enforced in
> +		 * __arm_smmu_tlb_inv_range()
> +		 */
> +		if (!(smmu->features & ARM_SMMU_FEAT_RANGE_INV) &&
> +		    !(granule_size & smmu_domain->domain.pgsize_bitmap)) {
> +			tg = __ffs(smmu_domain->domain.pgsize_bitmap);
> +			granule_size = 1 << tg;
> +			size = size >> tg;
> +		}
> +
> +		arm_smmu_tlb_inv_range_domain(info->addr, size,
> +					      granule_size, leaf,
> +					      info->archid, smmu_domain);
I encountered some errors when I tested the SMMU nested mode.

Test scenario description:
guest kernel: 4KB translation granule
host kernel: 16KB translation granule

errors:
1. encountered an endless loop in __arm_smmu_tlb_inv_range because
num_pages is 0
2. encountered CERROR_ILL because the fields of TLB invalidation
command are as follow: TG = 2, NUM = 0, SCALE = 0, TTL = 0. The
combination is exactly the kind of reserved combination pointed
out in the SMMUv3 spec(page 143-144, version D.a)

According to my analysis, we should do a bit more validation on the
'size' and 'granule_size' when SMMU supports RIL:
1. Align 'size' with the smallest granule size supported by SMMU upwards.
2. If the granule size isn't supported by SMMU, we set it to the smallest
granule size supported by SMMU

I sent two patches to fix them in the  __arm_smmu_tlb_inv_range(). [1]
(These patches may better explain what I want to express.)
According to the reply, it seems that it is more appropriate to modify here.

Thanks,
Kunkun Jiang

[1] [RFC PATCH v1 0/2] iommu/arm-smmu-v3: Add some parameter check in 
__arm_smmu_tlb_inv_range()
https://lore.kernel.org/linux-iommu/20210519094307.3275-1-jiangkunkun@huawei.com/
> +		return 0;
> +	}
> +	case IOMMU_INV_GRANU_DOMAIN:
> +		break;
> +	default:
> +		return -EINVAL;
> +	}
> +
> +	/* Global S1 invalidation */
> +	cmd.tlbi.vmid   = smmu_domain->s2_cfg.vmid;
> +	arm_smmu_cmdq_issue_cmd(smmu, &cmd);
> +	arm_smmu_cmdq_issue_sync(smmu);
> +	return 0;
> +}
> +
>   static bool arm_smmu_dev_has_feature(struct device *dev,
>   				     enum iommu_dev_features feat)
>   {
> @@ -3060,6 +3148,7 @@ static struct iommu_ops arm_smmu_ops = {
>   	.put_resv_regions	= generic_iommu_put_resv_regions,
>   	.attach_pasid_table	= arm_smmu_attach_pasid_table,
>   	.detach_pasid_table	= arm_smmu_detach_pasid_table,
> +	.cache_invalidate	= arm_smmu_cache_invalidate,
>   	.dev_has_feat		= arm_smmu_dev_has_feature,
>   	.dev_feat_enabled	= arm_smmu_dev_feature_enabled,
>   	.dev_enable_feat	= arm_smmu_dev_enable_feature,


