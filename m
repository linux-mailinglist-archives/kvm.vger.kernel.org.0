Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E1DB232A6FB
	for <lists+kvm@lfdr.de>; Tue,  2 Mar 2021 18:05:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1838954AbhCBPzf (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 2 Mar 2021 10:55:35 -0500
Received: from szxga04-in.huawei.com ([45.249.212.190]:13107 "EHLO
        szxga04-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1837868AbhCBI71 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 2 Mar 2021 03:59:27 -0500
Received: from DGGEMS410-HUB.china.huawei.com (unknown [172.30.72.59])
        by szxga04-in.huawei.com (SkyGuard) with ESMTP id 4DqVlY4HmHz16Fdw;
        Tue,  2 Mar 2021 16:33:45 +0800 (CST)
Received: from [10.174.184.42] (10.174.184.42) by
 DGGEMS410-HUB.china.huawei.com (10.3.19.210) with Microsoft SMTP Server id
 14.3.498.0; Tue, 2 Mar 2021 16:35:16 +0800
Subject: Re: [PATCH v14 05/13] iommu/smmuv3: Implement
 attach/detach_pasid_table
To:     Eric Auger <eric.auger@redhat.com>, <eric.auger.pro@gmail.com>,
        <iommu@lists.linux-foundation.org>, <linux-kernel@vger.kernel.org>,
        <kvm@vger.kernel.org>, <kvmarm@lists.cs.columbia.edu>,
        <will@kernel.org>, <maz@kernel.org>, <robin.murphy@arm.com>,
        <joro@8bytes.org>, <alex.williamson@redhat.com>, <tn@semihalf.com>
References: <20210223205634.604221-1-eric.auger@redhat.com>
 <20210223205634.604221-6-eric.auger@redhat.com>
CC:     <jacob.jun.pan@linux.intel.com>, <yi.l.liu@intel.com>,
        <wangxingang5@huawei.com>, <jiangkunkun@huawei.com>,
        <jean-philippe@linaro.org>, <zhangfei.gao@linaro.org>,
        <zhangfei.gao@gmail.com>, <vivek.gautam@arm.com>,
        <shameerali.kolothum.thodi@huawei.com>, <yuzenghui@huawei.com>,
        <nicoleotsuka@gmail.com>, <lushenming@huawei.com>,
        <vsethi@nvidia.com>
From:   Keqian Zhu <zhukeqian1@huawei.com>
Message-ID: <5a22a597-0fba-edcc-bcf0-50d92346af08@huawei.com>
Date:   Tue, 2 Mar 2021 16:35:15 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:45.0) Gecko/20100101
 Thunderbird/45.7.1
MIME-Version: 1.0
In-Reply-To: <20210223205634.604221-6-eric.auger@redhat.com>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.174.184.42]
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Eric,

On 2021/2/24 4:56, Eric Auger wrote:
> On attach_pasid_table() we program STE S1 related info set
> by the guest into the actual physical STEs. At minimum
> we need to program the context descriptor GPA and compute
> whether the stage1 is translated/bypassed or aborted.
> 
> On detach, the stage 1 config is unset and the abort flag is
> unset.
> 
> Signed-off-by: Eric Auger <eric.auger@redhat.com>
> 
[...]

> +
> +		/*
> +		 * we currently support a single CD so s1fmt and s1dss
> +		 * fields are also ignored
> +		 */
> +		if (cfg->pasid_bits)
> +			goto out;
> +
> +		smmu_domain->s1_cfg.cdcfg.cdtab_dma = cfg->base_ptr;
only the "cdtab_dma" field of "cdcfg" is set, we are not able to locate a specific cd using arm_smmu_get_cd_ptr().

Maybe we'd better use a specialized function to fill other fields of "cdcfg" or add a sanity check in arm_smmu_get_cd_ptr()
to prevent calling it under nested mode?

As now we just call arm_smmu_get_cd_ptr() during finalise_s1(), no problem found. Just a suggestion ;-)

Thanks,
Keqian


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
> +static void arm_smmu_detach_pasid_table(struct iommu_domain *domain)
> +{
> +	struct arm_smmu_domain *smmu_domain = to_smmu_domain(domain);
> +	struct arm_smmu_master *master;
> +	unsigned long flags;
> +
> +	mutex_lock(&smmu_domain->init_mutex);
> +
> +	if (smmu_domain->stage != ARM_SMMU_DOMAIN_NESTED)
> +		goto unlock;
> +
> +	smmu_domain->s1_cfg.set = false;
> +	smmu_domain->abort = false;
> +
> +	spin_lock_irqsave(&smmu_domain->devices_lock, flags);
> +	list_for_each_entry(master, &smmu_domain->devices, domain_head)
> +		arm_smmu_install_ste_for_dev(master);
> +	spin_unlock_irqrestore(&smmu_domain->devices_lock, flags);
> +
> +unlock:
> +	mutex_unlock(&smmu_domain->init_mutex);
> +}
> +
>  static bool arm_smmu_dev_has_feature(struct device *dev,
>  				     enum iommu_dev_features feat)
>  {
> @@ -2939,6 +3026,8 @@ static struct iommu_ops arm_smmu_ops = {
>  	.of_xlate		= arm_smmu_of_xlate,
>  	.get_resv_regions	= arm_smmu_get_resv_regions,
>  	.put_resv_regions	= generic_iommu_put_resv_regions,
> +	.attach_pasid_table	= arm_smmu_attach_pasid_table,
> +	.detach_pasid_table	= arm_smmu_detach_pasid_table,
>  	.dev_has_feat		= arm_smmu_dev_has_feature,
>  	.dev_feat_enabled	= arm_smmu_dev_feature_enabled,
>  	.dev_enable_feat	= arm_smmu_dev_enable_feature,
> 
