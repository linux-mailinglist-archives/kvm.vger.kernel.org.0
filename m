Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 587A730B930
	for <lists+kvm@lfdr.de>; Tue,  2 Feb 2021 09:06:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231484AbhBBIEd (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 2 Feb 2021 03:04:33 -0500
Received: from szxga07-in.huawei.com ([45.249.212.35]:12380 "EHLO
        szxga07-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230430AbhBBIEY (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 2 Feb 2021 03:04:24 -0500
Received: from DGGEMS407-HUB.china.huawei.com (unknown [172.30.72.58])
        by szxga07-in.huawei.com (SkyGuard) with ESMTP id 4DVHND3fyRz7f54;
        Tue,  2 Feb 2021 16:02:20 +0800 (CST)
Received: from [10.174.184.42] (10.174.184.42) by
 DGGEMS407-HUB.china.huawei.com (10.3.19.207) with Microsoft SMTP Server id
 14.3.498.0; Tue, 2 Feb 2021 16:03:32 +0800
Subject: Re: [PATCH v13 06/15] iommu/smmuv3: Implement
 attach/detach_pasid_table
To:     Eric Auger <eric.auger@redhat.com>, <eric.auger.pro@gmail.com>,
        <iommu@lists.linux-foundation.org>, <linux-kernel@vger.kernel.org>,
        <kvm@vger.kernel.org>, <kvmarm@lists.cs.columbia.edu>,
        <will@kernel.org>, <joro@8bytes.org>, <maz@kernel.org>,
        <robin.murphy@arm.com>, <alex.williamson@redhat.com>
References: <20201118112151.25412-1-eric.auger@redhat.com>
 <20201118112151.25412-7-eric.auger@redhat.com>
CC:     <jean-philippe@linaro.org>, <jacob.jun.pan@linux.intel.com>,
        <nicoleotsuka@gmail.com>, <vivek.gautam@arm.com>,
        <yi.l.liu@intel.com>, <zhangfei.gao@linaro.org>
From:   Keqian Zhu <zhukeqian1@huawei.com>
Message-ID: <4c3dded7-8b60-a303-3bdf-fa610f0e1a73@huawei.com>
Date:   Tue, 2 Feb 2021 16:03:31 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:45.0) Gecko/20100101
 Thunderbird/45.7.1
MIME-Version: 1.0
In-Reply-To: <20201118112151.25412-7-eric.auger@redhat.com>
Content-Type: text/plain; charset="windows-1252"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.174.184.42]
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Eric,

On 2020/11/18 19:21, Eric Auger wrote:
> On attach_pasid_table() we program STE S1 related info set
> by the guest into the actual physical STEs. At minimum
> we need to program the context descriptor GPA and compute
> whether the stage1 is translated/bypassed or aborted.
> 
> Signed-off-by: Eric Auger <eric.auger@redhat.com>
> 
> ---
> v7 -> v8:
> - remove smmu->features check, now done on domain finalize
> 
> v6 -> v7:
> - check versions and comment the fact we don't need to take
>   into account s1dss and s1fmt
> v3 -> v4:
> - adapt to changes in iommu_pasid_table_config
> - different programming convention at s1_cfg/s2_cfg/ste.abort
> 
> v2 -> v3:
> - callback now is named set_pasid_table and struct fields
>   are laid out differently.
> 
> v1 -> v2:
> - invalidate the STE before changing them
> - hold init_mutex
> - handle new fields
> ---
>  drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c | 89 +++++++++++++++++++++
>  1 file changed, 89 insertions(+)
> 
> diff --git a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
> index 412ea1bafa50..805acdc18a3a 100644
> --- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
> +++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
> @@ -2661,6 +2661,93 @@ static void arm_smmu_get_resv_regions(struct device *dev,
>  	iommu_dma_get_resv_regions(dev, head);
>  }
>  
> +static int arm_smmu_attach_pasid_table(struct iommu_domain *domain,
> +				       struct iommu_pasid_table_config *cfg)
> +{
> +	struct arm_smmu_domain *smmu_domain = to_smmu_domain(domain);
> +	struct arm_smmu_master *master;
> +	struct arm_smmu_device *smmu;
> +	unsigned long flags;
> +	int ret = -EINVAL;
> +
> +	if (cfg->format != IOMMU_PASID_FORMAT_SMMUV3)
> +		return -EINVAL;
> +
> +	if (cfg->version != PASID_TABLE_CFG_VERSION_1 ||
> +	    cfg->vendor_data.smmuv3.version != PASID_TABLE_SMMUV3_CFG_VERSION_1)
> +		return -EINVAL;
> +
> +	mutex_lock(&smmu_domain->init_mutex);
> +
> +	smmu = smmu_domain->smmu;
> +
> +	if (!smmu)
> +		goto out;
> +
> +	if (smmu_domain->stage != ARM_SMMU_DOMAIN_NESTED)
> +		goto out;
> +
> +	switch (cfg->config) {
> +	case IOMMU_PASID_CONFIG_ABORT:
> +		smmu_domain->s1_cfg.set = false;
> +		smmu_domain->abort = true;
> +		break;
> +	case IOMMU_PASID_CONFIG_BYPASS:
> +		smmu_domain->s1_cfg.set = false;
> +		smmu_domain->abort = false;
I didn't test it, but it seems that this will cause BUG() in arm_smmu_write_strtab_ent().
At the line "BUG_ON(ste_live && !nested);". Maybe I miss something?

> +		break;
> +	case IOMMU_PASID_CONFIG_TRANSLATE:
> +		/* we do not support S1 <-> S1 transitions */
> +		if (smmu_domain->s1_cfg.set)
> +			goto out;
> +
> +		/*
> +		 * we currently support a single CD so s1fmt and s1dss
> +		 * fields are also ignored
> +		 */
> +		if (cfg->pasid_bits)
> +			goto out;
> +
> +		smmu_domain->s1_cfg.cdcfg.cdtab_dma = cfg->base_ptr;
> +		smmu_domain->s1_cfg.set = true;
> +		smmu_domain->abort = false;
> +		break;
> +	default:
> +		goto out;
> +	}
> +	spin_lock_irqsave(&smmu_domain->devices_lock, flags);
> +	list_for_each_entry(master, &smmu_domain->devices, domain_head)
> +		arm_smmu_install_ste_for_dev(master);
> +	spin_unlock_irqrestore(&smmu_domain->devices_lock, flags);
> +	ret = 0;
> +out:
> +	mutex_unlock(&smmu_domain->init_mutex);
> +	return ret;
> +}
> +
[...]

Thanks,
Keqian
