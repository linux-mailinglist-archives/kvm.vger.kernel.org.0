Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6DF6935834A
	for <lists+kvm@lfdr.de>; Thu,  8 Apr 2021 14:30:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230467AbhDHMaw (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 8 Apr 2021 08:30:52 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:30694 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229964AbhDHMav (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 8 Apr 2021 08:30:51 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1617885039;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=s64/vAfSrBNQsCpuAMqXq7sIP9uWm8iiIR6se2Ly0S4=;
        b=LUitROKq9NbM2Defx5IrcSeHVF8kOXom9XPArw8kIzT6iCzTvXR6Gxef6hIz81DIqMlrjf
        qql8FZa58JHoCVjaijlDi/yWe0GKhiuS/TToCVr2Xxh2U1sx2vMbex+kDAxEay+DmvPLLp
        MQMRMCm5nAciXApLnmp6kRYehSAF670=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-363-TqiEpuyWMnmjarYH6YNu5g-1; Thu, 08 Apr 2021 08:30:35 -0400
X-MC-Unique: TqiEpuyWMnmjarYH6YNu5g-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id D8D10107ACC7;
        Thu,  8 Apr 2021 12:30:31 +0000 (UTC)
Received: from [10.36.115.214] (ovpn-115-214.ams2.redhat.com [10.36.115.214])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 5BEDB196E3;
        Thu,  8 Apr 2021 12:30:16 +0000 (UTC)
Subject: Re: [PATCH v14 06/13] iommu/smmuv3: Allow stage 1 invalidation with
 unmanaged ASIDs
To:     Kunkun Jiang <jiangkunkun@huawei.com>, eric.auger.pro@gmail.com,
        iommu@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu, will@kernel.org,
        maz@kernel.org, robin.murphy@arm.com, joro@8bytes.org,
        alex.williamson@redhat.com, tn@semihalf.com, zhukeqian1@huawei.com
Cc:     jacob.jun.pan@linux.intel.com, yi.l.liu@intel.com,
        wangxingang5@huawei.com, jean-philippe@linaro.org,
        zhangfei.gao@linaro.org, zhangfei.gao@gmail.com,
        vivek.gautam@arm.com, shameerali.kolothum.thodi@huawei.com,
        yuzenghui@huawei.com, nicoleotsuka@gmail.com,
        lushenming@huawei.com, vsethi@nvidia.com,
        wanghaibin.wang@huawei.com
References: <20210223205634.604221-1-eric.auger@redhat.com>
 <20210223205634.604221-7-eric.auger@redhat.com>
 <901720e6-6ca5-eb9a-1f24-0ca479bcfecc@huawei.com>
From:   Auger Eric <eric.auger@redhat.com>
Message-ID: <0246aec2-162d-0584-3ca4-b9c304ef3c8a@redhat.com>
Date:   Thu, 8 Apr 2021 14:30:13 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.0
MIME-Version: 1.0
In-Reply-To: <901720e6-6ca5-eb9a-1f24-0ca479bcfecc@huawei.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Kunkun,

On 4/1/21 2:37 PM, Kunkun Jiang wrote:
> Hi Eric,
> 
> On 2021/2/24 4:56, Eric Auger wrote:
>> With nested stage support, soon we will need to invalidate
>> S1 contexts and ranges tagged with an unmanaged asid, this
>> latter being managed by the guest. So let's introduce 2 helpers
>> that allow to invalidate with externally managed ASIDs
>>
>> Signed-off-by: Eric Auger <eric.auger@redhat.com>
>>
>> ---
>>
>> v13 -> v14
>> - Actually send the NH_ASID command (reported by Xingang Wang)
>> ---
>>   drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c | 38 ++++++++++++++++-----
>>   1 file changed, 29 insertions(+), 9 deletions(-)
>>
>> diff --git a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
>> b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
>> index 5579ec4fccc8..4c19a1114de4 100644
>> --- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
>> +++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
>> @@ -1843,9 +1843,9 @@ int arm_smmu_atc_inv_domain(struct
>> arm_smmu_domain *smmu_domain, int ssid,
>>   }
>>     /* IO_PGTABLE API */
>> -static void arm_smmu_tlb_inv_context(void *cookie)
>> +static void __arm_smmu_tlb_inv_context(struct arm_smmu_domain
>> *smmu_domain,
>> +                       int ext_asid)
>>   {
>> -    struct arm_smmu_domain *smmu_domain = cookie;
>>       struct arm_smmu_device *smmu = smmu_domain->smmu;
>>       struct arm_smmu_cmdq_ent cmd;
>>   @@ -1856,7 +1856,13 @@ static void arm_smmu_tlb_inv_context(void
>> *cookie)
>>        * insertion to guarantee those are observed before the TLBI. Do be
>>        * careful, 007.
>>        */
>> -    if (smmu_domain->stage == ARM_SMMU_DOMAIN_S1) {
>> +    if (ext_asid >= 0) { /* guest stage 1 invalidation */
>> +        cmd.opcode    = CMDQ_OP_TLBI_NH_ASID;
>> +        cmd.tlbi.asid    = ext_asid;
>> +        cmd.tlbi.vmid    = smmu_domain->s2_cfg.vmid;
>> +        arm_smmu_cmdq_issue_cmd(smmu, &cmd);
>> +        arm_smmu_cmdq_issue_sync(smmu);
>> +    } else if (smmu_domain->stage == ARM_SMMU_DOMAIN_S1) {
>>           arm_smmu_tlb_inv_asid(smmu, smmu_domain->s1_cfg.cd.asid);
>>       } else {
>>           cmd.opcode    = CMDQ_OP_TLBI_S12_VMALL;
>> @@ -1867,6 +1873,13 @@ static void arm_smmu_tlb_inv_context(void *cookie)
>>       arm_smmu_atc_inv_domain(smmu_domain, 0, 0, 0);
>>   }
>>   +static void arm_smmu_tlb_inv_context(void *cookie)
>> +{
>> +    struct arm_smmu_domain *smmu_domain = cookie;
>> +
>> +    __arm_smmu_tlb_inv_context(smmu_domain, -1);
>> +}
>> +
>>   static void __arm_smmu_tlb_inv_range(struct arm_smmu_cmdq_ent *cmd,
>>                        unsigned long iova, size_t size,
>>                        size_t granule,
>> @@ -1926,9 +1939,10 @@ static void __arm_smmu_tlb_inv_range(struct
>> arm_smmu_cmdq_ent *cmd,
>>       arm_smmu_cmdq_batch_submit(smmu, &cmds);
>>   }
>>   
> Here is the part of code in __arm_smmu_tlb_inv_range():
>>         if (smmu->features & ARM_SMMU_FEAT_RANGE_INV) {
>>                 /* Get the leaf page size */
>>                 tg = __ffs(smmu_domain->domain.pgsize_bitmap);
>>
>>                 /* Convert page size of 12,14,16 (log2) to 1,2,3 */
>>                 cmd->tlbi.tg = (tg - 10) / 2;
>>
>>                 /* Determine what level the granule is at */
>>                 cmd->tlbi.ttl = 4 - ((ilog2(granule) - 3) / (tg - 3));
>>
>>                 num_pages = size >> tg;
>>         }
> When pSMMU supports RIL, we get the leaf page size by __ffs(smmu_domain->
> domain.pgsize_bitmap). In nested mode, it is determined by host
> PAGE_SIZE. If
> the host kernel and guest kernel has different translation granule (e.g.
> host 16K,
> guest 4K), __arm_smmu_tlb_inv_range() will issue an incorrect tlbi command.
> 
> Do you have any idea about this issue?

I think this is the same issue as the one reported by Chenxiang

https://lore.kernel.org/lkml/15938ed5-2095-e903-a290-333c299015a2@hisilicon.com/

In case RIL is not supported by the host, next version will use the
smallest pSMMU supported page size, as done in __arm_smmu_tlb_inv_range

Thanks

Eric

> 
> Best Regards,
> Kunkun Jiang
>> -static void arm_smmu_tlb_inv_range_domain(unsigned long iova, size_t
>> size,
>> -                      size_t granule, bool leaf,
>> -                      struct arm_smmu_domain *smmu_domain)
>> +static void
>> +arm_smmu_tlb_inv_range_domain(unsigned long iova, size_t size,
>> +                  size_t granule, bool leaf, int ext_asid,
>> +                  struct arm_smmu_domain *smmu_domain)
>>   {
>>       struct arm_smmu_cmdq_ent cmd = {
>>           .tlbi = {
>> @@ -1936,7 +1950,12 @@ static void
>> arm_smmu_tlb_inv_range_domain(unsigned long iova, size_t size,
>>           },
>>       };
>>   -    if (smmu_domain->stage == ARM_SMMU_DOMAIN_S1) {
>> +    if (ext_asid >= 0) {  /* guest stage 1 invalidation */
>> +        cmd.opcode    = smmu_domain->smmu->features &
>> ARM_SMMU_FEAT_E2H ?
>> +                  CMDQ_OP_TLBI_EL2_VA : CMDQ_OP_TLBI_NH_VA;
>> +        cmd.tlbi.asid    = ext_asid;
>> +        cmd.tlbi.vmid    = smmu_domain->s2_cfg.vmid;
>> +    } else if (smmu_domain->stage == ARM_SMMU_DOMAIN_S1) {
>>           cmd.opcode    = smmu_domain->smmu->features &
>> ARM_SMMU_FEAT_E2H ?
>>                     CMDQ_OP_TLBI_EL2_VA : CMDQ_OP_TLBI_NH_VA;
>>           cmd.tlbi.asid    = smmu_domain->s1_cfg.cd.asid;
>> @@ -1944,6 +1963,7 @@ static void
>> arm_smmu_tlb_inv_range_domain(unsigned long iova, size_t size,
>>           cmd.opcode    = CMDQ_OP_TLBI_S2_IPA;
>>           cmd.tlbi.vmid    = smmu_domain->s2_cfg.vmid;
>>       }
>> +
>>       __arm_smmu_tlb_inv_range(&cmd, iova, size, granule, smmu_domain);
>>         /*
>> @@ -1982,7 +2002,7 @@ static void arm_smmu_tlb_inv_page_nosync(struct
>> iommu_iotlb_gather *gather,
>>   static void arm_smmu_tlb_inv_walk(unsigned long iova, size_t size,
>>                     size_t granule, void *cookie)
>>   {
>> -    arm_smmu_tlb_inv_range_domain(iova, size, granule, false, cookie);
>> +    arm_smmu_tlb_inv_range_domain(iova, size, granule, false, -1,
>> cookie);
>>   }
>>     static const struct iommu_flush_ops arm_smmu_flush_ops = {
>> @@ -2523,7 +2543,7 @@ static void arm_smmu_iotlb_sync(struct
>> iommu_domain *domain,
>>         arm_smmu_tlb_inv_range_domain(gather->start,
>>                         gather->end - gather->start + 1,
>> -                      gather->pgsize, true, smmu_domain);
>> +                      gather->pgsize, true, -1, smmu_domain);
>>   }
>>     static phys_addr_t
> 
> 

