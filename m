Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B4CD13454FF
	for <lists+kvm@lfdr.de>; Tue, 23 Mar 2021 02:29:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231152AbhCWB3T (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 22 Mar 2021 21:29:19 -0400
Received: from szxga05-in.huawei.com ([45.249.212.191]:14002 "EHLO
        szxga05-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230511AbhCWB2q (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 22 Mar 2021 21:28:46 -0400
Received: from DGGEMS412-HUB.china.huawei.com (unknown [172.30.72.60])
        by szxga05-in.huawei.com (SkyGuard) with ESMTP id 4F4DHB1G3YzwPJl;
        Tue, 23 Mar 2021 09:26:46 +0800 (CST)
Received: from [127.0.0.1] (10.40.193.166) by DGGEMS412-HUB.china.huawei.com
 (10.3.19.212) with Microsoft SMTP Server id 14.3.498.0; Tue, 23 Mar 2021
 09:28:35 +0800
Subject: Re: [Linuxarm] Re: [PATCH v14 07/13] iommu/smmuv3: Implement
 cache_invalidate
To:     Auger Eric <eric.auger@redhat.com>, <eric.auger.pro@gmail.com>,
        <iommu@lists.linux-foundation.org>, <linux-kernel@vger.kernel.org>,
        <kvm@vger.kernel.org>, <kvmarm@lists.cs.columbia.edu>,
        <will@kernel.org>, <maz@kernel.org>, <robin.murphy@arm.com>,
        <joro@8bytes.org>, <alex.williamson@redhat.com>, <tn@semihalf.com>,
        <zhukeqian1@huawei.com>
References: <20210223205634.604221-1-eric.auger@redhat.com>
 <20210223205634.604221-8-eric.auger@redhat.com>
 <c10c6405-5efe-5a41-2b3a-f3af85a528ba@hisilicon.com>
 <d5dcb7fe-2e09-b1fb-24d6-36249f047632@redhat.com>
 <1cf3fa95-45c6-5846-e1c2-12c222ebed46@hisilicon.com>
 <a691418f-5aa8-1d02-3519-732b39cd91cb@redhat.com>
CC:     <jean-philippe@linaro.org>, <wangxingang5@huawei.com>,
        <lushenming@huawei.com>, <jiangkunkun@huawei.com>,
        <vivek.gautam@arm.com>, <vsethi@nvidia.com>,
        <zhangfei.gao@linaro.org>, <linuxarm@openeuler.org>
From:   "chenxiang (M)" <chenxiang66@hisilicon.com>
Message-ID: <15938ed5-2095-e903-a290-333c299015a2@hisilicon.com>
Date:   Tue, 23 Mar 2021 09:28:34 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:45.0) Gecko/20100101
 Thunderbird/45.2.0
MIME-Version: 1.0
In-Reply-To: <a691418f-5aa8-1d02-3519-732b39cd91cb@redhat.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.40.193.166]
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Eric,


在 2021/3/22 17:05, Auger Eric 写道:
> Hi Chenxiang,
>
> On 3/22/21 7:40 AM, chenxiang (M) wrote:
>> Hi Eric,
>>
>>
>> 在 2021/3/20 1:36, Auger Eric 写道:
>>> Hi Chenxiang,
>>>
>>> On 3/4/21 8:55 AM, chenxiang (M) wrote:
>>>> Hi Eric,
>>>>
>>>>
>>>> 在 2021/2/24 4:56, Eric Auger 写道:
>>>>> Implement domain-selective, pasid selective and page-selective
>>>>> IOTLB invalidations.
>>>>>
>>>>> Signed-off-by: Eric Auger <eric.auger@redhat.com>
>>>>>
>>>>> ---
>>>>>
>>>>> v13 -> v14:
>>>>> - Add domain invalidation
>>>>> - do global inval when asid is not provided with addr
>>>>>     granularity
>>>>>
>>>>> v7 -> v8:
>>>>> - ASID based invalidation using iommu_inv_pasid_info
>>>>> - check ARCHID/PASID flags in addr based invalidation
>>>>> - use __arm_smmu_tlb_inv_context and __arm_smmu_tlb_inv_range_nosync
>>>>>
>>>>> v6 -> v7
>>>>> - check the uapi version
>>>>>
>>>>> v3 -> v4:
>>>>> - adapt to changes in the uapi
>>>>> - add support for leaf parameter
>>>>> - do not use arm_smmu_tlb_inv_range_nosync or arm_smmu_tlb_inv_context
>>>>>     anymore
>>>>>
>>>>> v2 -> v3:
>>>>> - replace __arm_smmu_tlb_sync by arm_smmu_cmdq_issue_sync
>>>>>
>>>>> v1 -> v2:
>>>>> - properly pass the asid
>>>>> ---
>>>>>    drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c | 74
>>>>> +++++++++++++++++++++
>>>>>    1 file changed, 74 insertions(+)
>>>>>
>>>>> diff --git a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
>>>>> b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
>>>>> index 4c19a1114de4..df3adc49111c 100644
>>>>> --- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
>>>>> +++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
>>>>> @@ -2949,6 +2949,79 @@ static void
>>>>> arm_smmu_detach_pasid_table(struct iommu_domain *domain)
>>>>>        mutex_unlock(&smmu_domain->init_mutex);
>>>>>    }
>>>>>    +static int
>>>>> +arm_smmu_cache_invalidate(struct iommu_domain *domain, struct
>>>>> device *dev,
>>>>> +              struct iommu_cache_invalidate_info *inv_info)
>>>>> +{
>>>>> +    struct arm_smmu_cmdq_ent cmd = {.opcode = CMDQ_OP_TLBI_NSNH_ALL};
>>>>> +    struct arm_smmu_domain *smmu_domain = to_smmu_domain(domain);
>>>>> +    struct arm_smmu_device *smmu = smmu_domain->smmu;
>>>>> +
>>>>> +    if (smmu_domain->stage != ARM_SMMU_DOMAIN_NESTED)
>>>>> +        return -EINVAL;
>>>>> +
>>>>> +    if (!smmu)
>>>>> +        return -EINVAL;
>>>>> +
>>>>> +    if (inv_info->version != IOMMU_CACHE_INVALIDATE_INFO_VERSION_1)
>>>>> +        return -EINVAL;
>>>>> +
>>>>> +    if (inv_info->cache & IOMMU_CACHE_INV_TYPE_PASID ||
>>>>> +        inv_info->cache & IOMMU_CACHE_INV_TYPE_DEV_IOTLB) {
>>>>> +        return -ENOENT;
>>>>> +    }
>>>>> +
>>>>> +    if (!(inv_info->cache & IOMMU_CACHE_INV_TYPE_IOTLB))
>>>>> +        return -EINVAL;
>>>>> +
>>>>> +    /* IOTLB invalidation */
>>>>> +
>>>>> +    switch (inv_info->granularity) {
>>>>> +    case IOMMU_INV_GRANU_PASID:
>>>>> +    {
>>>>> +        struct iommu_inv_pasid_info *info =
>>>>> +            &inv_info->granu.pasid_info;
>>>>> +
>>>>> +        if (info->flags & IOMMU_INV_ADDR_FLAGS_PASID)
>>>>> +            return -ENOENT;
>>>>> +        if (!(info->flags & IOMMU_INV_PASID_FLAGS_ARCHID))
>>>>> +            return -EINVAL;
>>>>> +
>>>>> +        __arm_smmu_tlb_inv_context(smmu_domain, info->archid);
>>>>> +        return 0;
>>>>> +    }
>>>>> +    case IOMMU_INV_GRANU_ADDR:
>>>>> +    {
>>>>> +        struct iommu_inv_addr_info *info = &inv_info->granu.addr_info;
>>>>> +        size_t size = info->nb_granules * info->granule_size;
>>>>> +        bool leaf = info->flags & IOMMU_INV_ADDR_FLAGS_LEAF;
>>>>> +
>>>>> +        if (info->flags & IOMMU_INV_ADDR_FLAGS_PASID)
>>>>> +            return -ENOENT;
>>>>> +
>>>>> +        if (!(info->flags & IOMMU_INV_ADDR_FLAGS_ARCHID))
>>>>> +            break;
>>>>> +
>>>>> +        arm_smmu_tlb_inv_range_domain(info->addr, size,
>>>>> +                          info->granule_size, leaf,
>>>>> +                          info->archid, smmu_domain);
>>>> Is it possible to add a check before the function to make sure that
>>>> info->granule_size can be recognized by SMMU?
>>>> There is a scenario which will cause TLBI issue: RIL feature is enabled
>>>> on guest but is disabled on host, and then on
>>>> host it just invalidate 4K/2M/1G once a time, but from QEMU,
>>>> info->nb_granules is always 1 and info->granule_size = size,
>>>> if size is not equal to 4K or 2M or 1G (for example size = granule_size
>>>> is 5M), it will only part of the size it wants to invalidate.
>> Do you have any idea about this issue?
> At the QEMU VFIO notifier level, when I fill the struct
> iommu_cache_invalidate_info, I currently miss the granule info, hence
> this weird choice of setting setting info->nb_granules is always 1 and
> info->granule_size = size. I think in arm_smmu_cache_invalidate() I need
> to convert this info back to a the leaf page size, in case the host does
> not support RIL. Just as it is done in  __arm_smmu_tlb_inv_range if RIL
> is supported.
>
> Does it makes sense to you?

Yes, it makes sense to me.
I am glad to test them if the patchset are ready.


>
> Thank you for spotting the issue.
>
> Eric
>>>> I think maybe we can add a check here: if RIL is not enabled and also
>>>> size is not the granule_size (4K/2M/1G) supported by
>>>> SMMU hardware, can we just simply use the smallest granule_size
>>>> supported by hardware all the time?
>>>>
>>>>> +
>>>>> +        arm_smmu_cmdq_issue_sync(smmu);
>>>>> +        return 0;
>>>>> +    }
>>>>> +    case IOMMU_INV_GRANU_DOMAIN:
>>>>> +        break;
>>>> I check the qemu code
>>>> (https://github.com/eauger/qemu/tree/v5.2.0-2stage-rfcv8), for opcode
>>>> CMD_TLBI_NH_ALL or CMD_TLBI_NSNH_ALL from guest OS
>>>> it calls smmu_inv_notifiers_all() to unamp all notifiers of all mr's,
>>>> but it seems not set event.entry.granularity which i think it should set
>>>> IOMMU_INV_GRAN_ADDR.
>>> this is because IOMMU_INV_GRAN_ADDR = 0. But for clarity I should rather
>>> set it explicitly ;-)
>> ok
>>
>>>> BTW, for opcode CMD_TLBI_NH_ALL or CMD_TLBI_NSNH_ALL, it needs to unmap
>>>> size = 0x1000000000000 on 48bit system (it may spend much time),  maybe
>>>> it is better
>>>> to set it as IOMMU_INV_GRANU_DOMAIN, then in host OS, send TLBI_NH_ALL
>>>> directly when IOMMU_INV_GRANU_DOMAIN.
>>> Yes you're right. If the host does not support RIL then it is an issue.
>>> This is going to be fixed in the next version.
>> Great
>>
>>> Thank you for the report!
>>>
>>> Best Regards
>>>
>>> Eric
>>>>> +    default:
>>>>> +        return -EINVAL;
>>>>> +    }
>>>>> +
>>>>> +    /* Global S1 invalidation */
>>>>> +    cmd.tlbi.vmid   = smmu_domain->s2_cfg.vmid;
>>>>> +    arm_smmu_cmdq_issue_cmd(smmu, &cmd);
>>>>> +    arm_smmu_cmdq_issue_sync(smmu);
>>>>> +    return 0;
>>>>> +}
>>>>> +
>>>>>    static bool arm_smmu_dev_has_feature(struct device *dev,
>>>>>                         enum iommu_dev_features feat)
>>>>>    {
>>>>> @@ -3048,6 +3121,7 @@ static struct iommu_ops arm_smmu_ops = {
>>>>>        .put_resv_regions    = generic_iommu_put_resv_regions,
>>>>>        .attach_pasid_table    = arm_smmu_attach_pasid_table,
>>>>>        .detach_pasid_table    = arm_smmu_detach_pasid_table,
>>>>> +    .cache_invalidate    = arm_smmu_cache_invalidate,
>>>>>        .dev_has_feat        = arm_smmu_dev_has_feature,
>>>>>        .dev_feat_enabled    = arm_smmu_dev_feature_enabled,
>>>>>        .dev_enable_feat    = arm_smmu_dev_enable_feature,
>>> _______________________________________________
>>> Linuxarm mailing list -- linuxarm@openeuler.org
>>> To unsubscribe send an email to linuxarm-leave@openeuler.org
>>
>
> .
>


