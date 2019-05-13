Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 977A71B7BF
	for <lists+kvm@lfdr.de>; Mon, 13 May 2019 16:05:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730401AbfEMOFH (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 13 May 2019 10:05:07 -0400
Received: from mx1.redhat.com ([209.132.183.28]:15053 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729401AbfEMOFG (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 13 May 2019 10:05:06 -0400
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 6E30E7FD6C;
        Mon, 13 May 2019 14:05:00 +0000 (UTC)
Received: from [10.36.116.17] (ovpn-116-17.ams2.redhat.com [10.36.116.17])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id C655F608C3;
        Mon, 13 May 2019 14:04:49 +0000 (UTC)
Subject: Re: [PATCH v7 14/23] iommu/smmuv3: Implement cache_invalidate
To:     Robin Murphy <robin.murphy@arm.com>, eric.auger.pro@gmail.com,
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
 <a53d72f5-c8a2-a9e9-eb0b-2fac65964caf@arm.com>
 <edff2a6f-66e6-6d7e-49ca-3065e93a41a4@redhat.com>
 <a181689b-94b5-5ff6-9fec-66b3f319cbc4@arm.com>
From:   Auger Eric <eric.auger@redhat.com>
Message-ID: <405002b2-5663-7c03-d5df-b9da6499a238@redhat.com>
Date:   Mon, 13 May 2019 16:04:48 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.4.0
MIME-Version: 1.0
In-Reply-To: <a181689b-94b5-5ff6-9fec-66b3f319cbc4@arm.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.27]); Mon, 13 May 2019 14:05:06 +0000 (UTC)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Robin,

On 5/13/19 4:01 PM, Robin Murphy wrote:
> On 13/05/2019 13:16, Auger Eric wrote:
>> Hi Robin,
>> On 5/8/19 5:01 PM, Robin Murphy wrote:
>>> On 08/04/2019 13:19, Eric Auger wrote:
>>>> Implement domain-selective and page-selective IOTLB invalidations.
>>>>
>>>> Signed-off-by: Eric Auger <eric.auger@redhat.com>
>>>>
>>>> ---
>>>> v6 -> v7
>>>> - check the uapi version
>>>>
>>>> v3 -> v4:
>>>> - adapt to changes in the uapi
>>>> - add support for leaf parameter
>>>> - do not use arm_smmu_tlb_inv_range_nosync or arm_smmu_tlb_inv_context
>>>>     anymore
>>>>
>>>> v2 -> v3:
>>>> - replace __arm_smmu_tlb_sync by arm_smmu_cmdq_issue_sync
>>>>
>>>> v1 -> v2:
>>>> - properly pass the asid
>>>> ---
>>>>    drivers/iommu/arm-smmu-v3.c | 60
>>>> +++++++++++++++++++++++++++++++++++++
>>>>    1 file changed, 60 insertions(+)
>>>>
>>>> diff --git a/drivers/iommu/arm-smmu-v3.c b/drivers/iommu/arm-smmu-v3.c
>>>> index 1486baf53425..4366921d8318 100644
>>>> --- a/drivers/iommu/arm-smmu-v3.c
>>>> +++ b/drivers/iommu/arm-smmu-v3.c
>>>> @@ -2326,6 +2326,65 @@ static void arm_smmu_detach_pasid_table(struct
>>>> iommu_domain *domain)
>>>>        mutex_unlock(&smmu_domain->init_mutex);
>>>>    }
>>>>    +static int
>>>> +arm_smmu_cache_invalidate(struct iommu_domain *domain, struct device
>>>> *dev,
>>>> +              struct iommu_cache_invalidate_info *inv_info)
>>>> +{
>>>> +    struct arm_smmu_domain *smmu_domain = to_smmu_domain(domain);
>>>> +    struct arm_smmu_device *smmu = smmu_domain->smmu;
>>>> +
>>>> +    if (smmu_domain->stage != ARM_SMMU_DOMAIN_NESTED)
>>>> +        return -EINVAL;
>>>> +
>>>> +    if (!smmu)
>>>> +        return -EINVAL;
>>>> +
>>>> +    if (inv_info->version != IOMMU_CACHE_INVALIDATE_INFO_VERSION_1)
>>>> +        return -EINVAL;
>>>> +
>>>> +    if (inv_info->cache & IOMMU_CACHE_INV_TYPE_IOTLB) {
>>>> +        if (inv_info->granularity == IOMMU_INV_GRANU_PASID) {
>>>> +            struct arm_smmu_cmdq_ent cmd = {
>>>> +                .opcode = CMDQ_OP_TLBI_NH_ASID,
>>>> +                .tlbi = {
>>>> +                    .vmid = smmu_domain->s2_cfg.vmid,
>>>> +                    .asid = inv_info->pasid,
>>>> +                },
>>>> +            };
>>>> +
>>>> +            arm_smmu_cmdq_issue_cmd(smmu, &cmd);
>>>> +            arm_smmu_cmdq_issue_sync(smmu);
>>>
>>> I'd much rather make arm_smmu_tlb_inv_context() understand nested
>>> domains than open-code commands all over the place.
>>
>>
>>>
>>>> +
>>>> +        } else if (inv_info->granularity == IOMMU_INV_GRANU_ADDR) {
>>>> +            struct iommu_inv_addr_info *info = &inv_info->addr_info;
>>>> +            size_t size = info->nb_granules * info->granule_size;
>>>> +            bool leaf = info->flags & IOMMU_INV_ADDR_FLAGS_LEAF;
>>>> +            struct arm_smmu_cmdq_ent cmd = {
>>>> +                .opcode = CMDQ_OP_TLBI_NH_VA,
>>>> +                .tlbi = {
>>>> +                    .addr = info->addr,
>>>> +                    .vmid = smmu_domain->s2_cfg.vmid,
>>>> +                    .asid = info->pasid,
>>>> +                    .leaf = leaf,
>>>> +                },
>>>> +            };
>>>> +
>>>> +            do {
>>>> +                arm_smmu_cmdq_issue_cmd(smmu, &cmd);
>>>> +                cmd.tlbi.addr += info->granule_size;
>>>> +            } while (size -= info->granule_size);
>>>> +            arm_smmu_cmdq_issue_sync(smmu);
>>>
>>> An this in particular I would really like to go all the way through
>>> io_pgtable_tlb_add_flush()/io_pgtable_sync() if at all possible. Hooking
>>> up range-based invalidations is going to be a massive headache if the
>>> abstraction isn't solid.
>>
>> The concern is the host does not "own" the s1 config asid
>> (smmu_domain->s1_cfg.cd.asid is not set, practically). In our case the
>> asid only is passed by the userspace on CACHE_INVALIDATE ioctl call.
>>
>> arm_smmu_tlb_inv_context and arm_smmu_tlb_inv_range_nosync use this field
> 
> Right, but that's not exactly hard to solve. Even just something like
> the (untested, purely illustrative) refactoring below would be beneficial.
Sure I can go this way.

Thank you for detailing

Eric
> 
> Robin.
> 
> ----->8-----
> diff --git a/drivers/iommu/arm-smmu-v3.c b/drivers/iommu/arm-smmu-v3.c
> index d3880010c6cf..31ef703cf671 100644
> --- a/drivers/iommu/arm-smmu-v3.c
> +++ b/drivers/iommu/arm-smmu-v3.c
> @@ -1423,11 +1423,9 @@ static void arm_smmu_tlb_inv_context(void *cookie)
>      arm_smmu_cmdq_issue_sync(smmu);
>  }
> 
> -static void arm_smmu_tlb_inv_range_nosync(unsigned long iova, size_t size,
> -                      size_t granule, bool leaf, void *cookie)
> +static void __arm_smmu_tlb_inv_range(struct arm_smmu_domain
> *smmu_domain, u16 asid,
> +        unsigned long iova, size_t size, size_t granule, bool leaf)
>  {
> -    struct arm_smmu_domain *smmu_domain = cookie;
> -    struct arm_smmu_device *smmu = smmu_domain->smmu;
>      struct arm_smmu_cmdq_ent cmd = {
>          .tlbi = {
>              .leaf    = leaf,
> @@ -1437,18 +1435,27 @@ static void
> arm_smmu_tlb_inv_range_nosync(unsigned long iova, size_t size,
> 
>      if (smmu_domain->stage == ARM_SMMU_DOMAIN_S1) {
>          cmd.opcode    = CMDQ_OP_TLBI_NH_VA;
> -        cmd.tlbi.asid    = smmu_domain->s1_cfg.cd.asid;
> +        cmd.tlbi.asid    = asid;
>      } else {
>          cmd.opcode    = CMDQ_OP_TLBI_S2_IPA;
>          cmd.tlbi.vmid    = smmu_domain->s2_cfg.vmid;
>      }
> 
>      do {
> -        arm_smmu_cmdq_issue_cmd(smmu, &cmd);
> +        arm_smmu_cmdq_issue_cmd(smmu_domain->smmu, &cmd);
>          cmd.tlbi.addr += granule;
>      } while (size -= granule);
>  }
> 
> +static void arm_smmu_tlb_inv_range_nosync(unsigned long iova, size_t size,
> +                      size_t granule, bool leaf, void *cookie)
> +{
> +    struct arm_smmu_domain *smmu_domain = cookie;
> +
> +    __arm_smmu_tlb_inv_range(smmu_domain, smmu_domain->s1_cfg.cd.asid,
> iova,
> +            size, granule, leaf);
> +}
> +
>  static const struct iommu_gather_ops arm_smmu_gather_ops = {
>      .tlb_flush_all    = arm_smmu_tlb_inv_context,
>      .tlb_add_flush    = arm_smmu_tlb_inv_range_nosync,
