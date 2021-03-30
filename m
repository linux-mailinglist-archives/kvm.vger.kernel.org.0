Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E400234E43C
	for <lists+kvm@lfdr.de>; Tue, 30 Mar 2021 11:24:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231732AbhC3JY0 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 30 Mar 2021 05:24:26 -0400
Received: from szxga07-in.huawei.com ([45.249.212.35]:15822 "EHLO
        szxga07-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231737AbhC3JYH (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 30 Mar 2021 05:24:07 -0400
Received: from DGGEMS404-HUB.china.huawei.com (unknown [172.30.72.58])
        by szxga07-in.huawei.com (SkyGuard) with ESMTP id 4F8kVF4Ljjz9tHp;
        Tue, 30 Mar 2021 17:21:57 +0800 (CST)
Received: from [10.174.185.179] (10.174.185.179) by
 DGGEMS404-HUB.china.huawei.com (10.3.19.204) with Microsoft SMTP Server id
 14.3.498.0; Tue, 30 Mar 2021 17:23:55 +0800
Subject: Re: [PATCH v14 13/13] iommu/smmuv3: Accept configs with more than one
 context descriptor
To:     Eric Auger <eric.auger@redhat.com>
CC:     <eric.auger.pro@gmail.com>, <iommu@lists.linux-foundation.org>,
        <linux-kernel@vger.kernel.org>, <kvm@vger.kernel.org>,
        <kvmarm@lists.cs.columbia.edu>, <will@kernel.org>,
        <maz@kernel.org>, <robin.murphy@arm.com>, <joro@8bytes.org>,
        <alex.williamson@redhat.com>, <tn@semihalf.com>,
        <zhukeqian1@huawei.com>, <jacob.jun.pan@linux.intel.com>,
        <yi.l.liu@intel.com>, <wangxingang5@huawei.com>,
        <jiangkunkun@huawei.com>, <jean-philippe@linaro.org>,
        <zhangfei.gao@linaro.org>, <zhangfei.gao@gmail.com>,
        <vivek.gautam@arm.com>, <shameerali.kolothum.thodi@huawei.com>,
        <nicoleotsuka@gmail.com>, <lushenming@huawei.com>,
        <vsethi@nvidia.com>, <wanghaibin.wang@huawei.com>
References: <20210223205634.604221-1-eric.auger@redhat.com>
 <20210223205634.604221-14-eric.auger@redhat.com>
From:   Zenghui Yu <yuzenghui@huawei.com>
Message-ID: <86614466-3c74-3a38-5f2e-6ac2f55c309a@huawei.com>
Date:   Tue, 30 Mar 2021 17:23:54 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.9.0
MIME-Version: 1.0
In-Reply-To: <20210223205634.604221-14-eric.auger@redhat.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.174.185.179]
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Eric,

On 2021/2/24 4:56, Eric Auger wrote:
> In preparation for vSVA, let's accept userspace provided configs
> with more than one CD. We check the max CD against the host iommu
> capability and also the format (linear versus 2 level).
> 
> Signed-off-by: Eric Auger <eric.auger@redhat.com>
> Signed-off-by: Shameer Kolothum <shameerali.kolothum.thodi@huawei.com>
> ---
>   drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c | 13 ++++++++-----
>   1 file changed, 8 insertions(+), 5 deletions(-)
> 
> diff --git a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
> index 332d31c0680f..ab74a0289893 100644
> --- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
> +++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
> @@ -3038,14 +3038,17 @@ static int arm_smmu_attach_pasid_table(struct iommu_domain *domain,
>   		if (smmu_domain->s1_cfg.set)
>   			goto out;
>   
> -		/*
> -		 * we currently support a single CD so s1fmt and s1dss
> -		 * fields are also ignored
> -		 */
> -		if (cfg->pasid_bits)
> +		list_for_each_entry(master, &smmu_domain->devices, domain_head) {
> +			if (cfg->pasid_bits > master->ssid_bits)
> +				goto out;
> +		}
> +		if (cfg->vendor_data.smmuv3.s1fmt == STRTAB_STE_0_S1FMT_64K_L2 &&
> +				!(smmu->features & ARM_SMMU_FEAT_2_LVL_CDTAB))
>   			goto out;
>   
>   		smmu_domain->s1_cfg.cdcfg.cdtab_dma = cfg->base_ptr;
> +		smmu_domain->s1_cfg.s1cdmax = cfg->pasid_bits;
> +		smmu_domain->s1_cfg.s1fmt = cfg->vendor_data.smmuv3.s1fmt;

And what about the SIDSS field?
