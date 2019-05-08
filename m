Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BA87317CBA
	for <lists+kvm@lfdr.de>; Wed,  8 May 2019 17:01:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726928AbfEHPBV (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 8 May 2019 11:01:21 -0400
Received: from usa-sjc-mx-foss1.foss.arm.com ([217.140.101.70]:37402 "EHLO
        foss.arm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726163AbfEHPBV (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 8 May 2019 11:01:21 -0400
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.72.51.249])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 5BBEFA78;
        Wed,  8 May 2019 08:01:20 -0700 (PDT)
Received: from [10.1.196.75] (e110467-lin.cambridge.arm.com [10.1.196.75])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 744F03F238;
        Wed,  8 May 2019 08:01:16 -0700 (PDT)
Subject: Re: [PATCH v7 14/23] iommu/smmuv3: Implement cache_invalidate
To:     Eric Auger <eric.auger@redhat.com>, eric.auger.pro@gmail.com,
        iommu@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu, joro@8bytes.org,
        alex.williamson@redhat.com, jacob.jun.pan@linux.intel.com,
        yi.l.liu@intel.com, jean-philippe.brucker@arm.com,
        will.deacon@arm.com
Cc:     kevin.tian@intel.com, ashok.raj@intel.com, marc.zyngier@arm.com,
        christoffer.dall@arm.com, peter.maydell@linaro.org,
        vincent.stehle@arm.com
References: <20190408121911.24103-1-eric.auger@redhat.com>
 <20190408121911.24103-15-eric.auger@redhat.com>
From:   Robin Murphy <robin.murphy@arm.com>
Message-ID: <a53d72f5-c8a2-a9e9-eb0b-2fac65964caf@arm.com>
Date:   Wed, 8 May 2019 16:01:14 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.6.1
MIME-Version: 1.0
In-Reply-To: <20190408121911.24103-15-eric.auger@redhat.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-GB
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 08/04/2019 13:19, Eric Auger wrote:
> Implement domain-selective and page-selective IOTLB invalidations.
> 
> Signed-off-by: Eric Auger <eric.auger@redhat.com>
> 
> ---
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
>   drivers/iommu/arm-smmu-v3.c | 60 +++++++++++++++++++++++++++++++++++++
>   1 file changed, 60 insertions(+)
> 
> diff --git a/drivers/iommu/arm-smmu-v3.c b/drivers/iommu/arm-smmu-v3.c
> index 1486baf53425..4366921d8318 100644
> --- a/drivers/iommu/arm-smmu-v3.c
> +++ b/drivers/iommu/arm-smmu-v3.c
> @@ -2326,6 +2326,65 @@ static void arm_smmu_detach_pasid_table(struct iommu_domain *domain)
>   	mutex_unlock(&smmu_domain->init_mutex);
>   }
>   
> +static int
> +arm_smmu_cache_invalidate(struct iommu_domain *domain, struct device *dev,
> +			  struct iommu_cache_invalidate_info *inv_info)
> +{
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
> +	if (inv_info->cache & IOMMU_CACHE_INV_TYPE_IOTLB) {
> +		if (inv_info->granularity == IOMMU_INV_GRANU_PASID) {
> +			struct arm_smmu_cmdq_ent cmd = {
> +				.opcode = CMDQ_OP_TLBI_NH_ASID,
> +				.tlbi = {
> +					.vmid = smmu_domain->s2_cfg.vmid,
> +					.asid = inv_info->pasid,
> +				},
> +			};
> +
> +			arm_smmu_cmdq_issue_cmd(smmu, &cmd);
> +			arm_smmu_cmdq_issue_sync(smmu);

I'd much rather make arm_smmu_tlb_inv_context() understand nested 
domains than open-code commands all over the place.

> +
> +		} else if (inv_info->granularity == IOMMU_INV_GRANU_ADDR) {
> +			struct iommu_inv_addr_info *info = &inv_info->addr_info;
> +			size_t size = info->nb_granules * info->granule_size;
> +			bool leaf = info->flags & IOMMU_INV_ADDR_FLAGS_LEAF;
> +			struct arm_smmu_cmdq_ent cmd = {
> +				.opcode = CMDQ_OP_TLBI_NH_VA,
> +				.tlbi = {
> +					.addr = info->addr,
> +					.vmid = smmu_domain->s2_cfg.vmid,
> +					.asid = info->pasid,
> +					.leaf = leaf,
> +				},
> +			};
> +
> +			do {
> +				arm_smmu_cmdq_issue_cmd(smmu, &cmd);
> +				cmd.tlbi.addr += info->granule_size;
> +			} while (size -= info->granule_size);
> +			arm_smmu_cmdq_issue_sync(smmu);

An this in particular I would really like to go all the way through 
io_pgtable_tlb_add_flush()/io_pgtable_sync() if at all possible. Hooking 
up range-based invalidations is going to be a massive headache if the 
abstraction isn't solid.

Robin.

> +		} else {
> +			return -EINVAL;
> +		}
> +	}
> +	if (inv_info->cache & IOMMU_CACHE_INV_TYPE_PASID ||
> +	    inv_info->cache & IOMMU_CACHE_INV_TYPE_DEV_IOTLB) {
> +		return -ENOENT;
> +	}
> +	return 0;
> +}
> +
>   static struct iommu_ops arm_smmu_ops = {
>   	.capable		= arm_smmu_capable,
>   	.domain_alloc		= arm_smmu_domain_alloc,
> @@ -2346,6 +2405,7 @@ static struct iommu_ops arm_smmu_ops = {
>   	.put_resv_regions	= arm_smmu_put_resv_regions,
>   	.attach_pasid_table	= arm_smmu_attach_pasid_table,
>   	.detach_pasid_table	= arm_smmu_detach_pasid_table,
> +	.cache_invalidate	= arm_smmu_cache_invalidate,
>   	.pgsize_bitmap		= -1UL, /* Restricted during device attach */
>   };
>   
> 
