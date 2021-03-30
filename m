Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 38F7C34E42C
	for <lists+kvm@lfdr.de>; Tue, 30 Mar 2021 11:19:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231725AbhC3JSc (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 30 Mar 2021 05:18:32 -0400
Received: from szxga06-in.huawei.com ([45.249.212.32]:15395 "EHLO
        szxga06-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231665AbhC3JSK (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 30 Mar 2021 05:18:10 -0400
Received: from DGGEMS404-HUB.china.huawei.com (unknown [172.30.72.59])
        by szxga06-in.huawei.com (SkyGuard) with ESMTP id 4F8kMt0wnMzqSNJ;
        Tue, 30 Mar 2021 17:16:26 +0800 (CST)
Received: from [10.174.185.179] (10.174.185.179) by
 DGGEMS404-HUB.china.huawei.com (10.3.19.204) with Microsoft SMTP Server id
 14.3.498.0; Tue, 30 Mar 2021 17:17:59 +0800
Subject: Re: [PATCH v14 06/13] iommu/smmuv3: Allow stage 1 invalidation with
 unmanaged ASIDs
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
 <20210223205634.604221-7-eric.auger@redhat.com>
From:   Zenghui Yu <yuzenghui@huawei.com>
Message-ID: <7a270196-2a8d-1b23-ee5f-f977c53d2134@huawei.com>
Date:   Tue, 30 Mar 2021 17:17:57 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.9.0
MIME-Version: 1.0
In-Reply-To: <20210223205634.604221-7-eric.auger@redhat.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.174.185.179]
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 2021/2/24 4:56, Eric Auger wrote:
> @@ -1936,7 +1950,12 @@ static void arm_smmu_tlb_inv_range_domain(unsigned long iova, size_t size,
>   		},
>   	};
>   
> -	if (smmu_domain->stage == ARM_SMMU_DOMAIN_S1) {
> +	if (ext_asid >= 0) {  /* guest stage 1 invalidation */
> +		cmd.opcode	= smmu_domain->smmu->features & ARM_SMMU_FEAT_E2H ?
> +				  CMDQ_OP_TLBI_EL2_VA : CMDQ_OP_TLBI_NH_VA;

If I understand it correctly, the true nested mode effectively gives us
a *NS-EL1* StreamWorld. We should therefore use CMDQ_OP_TLBI_NH_VA to
invalidate the stage-1 NS-EL1 entries, no matter E2H is selected or not.
