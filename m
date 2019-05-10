Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9119219F4A
	for <lists+kvm@lfdr.de>; Fri, 10 May 2019 16:34:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728023AbfEJOej (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 10 May 2019 10:34:39 -0400
Received: from mx1.redhat.com ([209.132.183.28]:55356 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727248AbfEJOej (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 10 May 2019 10:34:39 -0400
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 8D5E3285CC;
        Fri, 10 May 2019 14:34:34 +0000 (UTC)
Received: from [10.36.116.17] (ovpn-116-17.ams2.redhat.com [10.36.116.17])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 1A7AD5DE85;
        Fri, 10 May 2019 14:34:24 +0000 (UTC)
Subject: Re: [PATCH v7 12/23] iommu/smmuv3: Get prepared for nested stage
 support
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
 <20190408121911.24103-13-eric.auger@redhat.com>
 <66f873eb-35c0-d1e9-794e-9150dbdb13fe@arm.com>
From:   Auger Eric <eric.auger@redhat.com>
Message-ID: <a1099cec-a8ad-6efa-b7e8-77388814f7e2@redhat.com>
Date:   Fri, 10 May 2019 16:34:23 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.4.0
MIME-Version: 1.0
In-Reply-To: <66f873eb-35c0-d1e9-794e-9150dbdb13fe@arm.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.30]); Fri, 10 May 2019 14:34:38 +0000 (UTC)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Robin,

On 5/8/19 4:24 PM, Robin Murphy wrote:
> On 08/04/2019 13:19, Eric Auger wrote:
>> To allow nested stage support, we need to store both
>> stage 1 and stage 2 configurations (and remove the former
>> union).
>>
>> A nested setup is characterized by both s1_cfg and s2_cfg
>> set.
>>
>> We introduce a new ste.abort field that will be set upon
>> guest stage1 configuration passing. If s1_cfg is NULL and
>> ste.abort is set, traffic can't pass. If ste.abort is not set,
>> S1 is bypassed.
>>
>> arm_smmu_write_strtab_ent() is modified to write both stage
>> fields in the STE and deal with the abort field.
>>
>> In nested mode, only stage 2 is "finalized" as the host does
>> not own/configure the stage 1 context descriptor, guest does.
>>
>> Signed-off-by: Eric Auger <eric.auger@redhat.com>
>>
>> ---
>>
>> v4 -> v5:
>> - reset ste.abort on detach
>>
>> v3 -> v4:
>> - s1_cfg.nested_abort and nested_bypass removed.
>> - s/ste.nested/ste.abort
>> - arm_smmu_write_strtab_ent modifications with introduction
>>    of local abort, bypass and translate local variables
>> - comment updated
>>
>> v1 -> v2:
>> - invalidate the STE before moving from a live STE config to another
>> - add the nested_abort and nested_bypass fields
>> ---
>>   drivers/iommu/arm-smmu-v3.c | 35 ++++++++++++++++++++---------------
>>   1 file changed, 20 insertions(+), 15 deletions(-)
>>
>> diff --git a/drivers/iommu/arm-smmu-v3.c b/drivers/iommu/arm-smmu-v3.c
>> index 21d027695181..e22e944ffc05 100644
>> --- a/drivers/iommu/arm-smmu-v3.c
>> +++ b/drivers/iommu/arm-smmu-v3.c
>> @@ -211,6 +211,7 @@
>>   #define STRTAB_STE_0_CFG_BYPASS        4
>>   #define STRTAB_STE_0_CFG_S1_TRANS    5
>>   #define STRTAB_STE_0_CFG_S2_TRANS    6
>> +#define STRTAB_STE_0_CFG_NESTED        7
>>     #define STRTAB_STE_0_S1FMT        GENMASK_ULL(5, 4)
>>   #define STRTAB_STE_0_S1FMT_LINEAR    0
>> @@ -514,6 +515,7 @@ struct arm_smmu_strtab_ent {
>>        * configured according to the domain type.
>>        */
>>       bool                assigned;
>> +    bool                abort;
>>       struct arm_smmu_s1_cfg        *s1_cfg;
>>       struct arm_smmu_s2_cfg        *s2_cfg;
>>   };
>> @@ -628,10 +630,8 @@ struct arm_smmu_domain {
>>       bool                non_strict;
>>         enum arm_smmu_domain_stage    stage;
>> -    union {
>> -        struct arm_smmu_s1_cfg    s1_cfg;
>> -        struct arm_smmu_s2_cfg    s2_cfg;
>> -    };
>> +    struct arm_smmu_s1_cfg    s1_cfg;
>> +    struct arm_smmu_s2_cfg    s2_cfg;
>>         struct iommu_domain        domain;
>>   @@ -1108,12 +1108,13 @@ static void arm_smmu_write_strtab_ent(struct
>> arm_smmu_device *smmu, u32 sid,
>>                         __le64 *dst, struct arm_smmu_strtab_ent *ste)
>>   {
>>       /*
>> -     * This is hideously complicated, but we only really care about
>> -     * three cases at the moment:
>> +     * We care about the following transitions:
>>        *
>>        * 1. Invalid (all zero) -> bypass/fault (init)
>> -     * 2. Bypass/fault -> translation/bypass (attach)
>> -     * 3. Translation/bypass -> bypass/fault (detach)
>> +     * 2. Bypass/fault -> single stage translation/bypass (attach)
>> +     * 3. single stage Translation/bypass -> bypass/fault (detach)
>> +     * 4. S2 -> S1 + S2 (attach_pasid_table)
>> +     * 5. S1 + S2 -> S2 (detach_pasid_table)
>>        *
>>        * Given that we can't update the STE atomically and the SMMU
>>        * doesn't read the thing in a defined order, that leaves us
>> @@ -1124,7 +1125,7 @@ static void arm_smmu_write_strtab_ent(struct
>> arm_smmu_device *smmu, u32 sid,
>>        * 3. Update Config, sync
>>        */
>>       u64 val = le64_to_cpu(dst[0]);
>> -    bool ste_live = false;
>> +    bool abort, bypass, translate, ste_live = false;
>>       struct arm_smmu_cmdq_ent prefetch_cmd = {
>>           .opcode        = CMDQ_OP_PREFETCH_CFG,
>>           .prefetch    = {
>> @@ -1138,11 +1139,11 @@ static void arm_smmu_write_strtab_ent(struct
>> arm_smmu_device *smmu, u32 sid,
>>               break;
>>           case STRTAB_STE_0_CFG_S1_TRANS:
>>           case STRTAB_STE_0_CFG_S2_TRANS:
>> +        case STRTAB_STE_0_CFG_NESTED:
>>               ste_live = true;
>>               break;
>>           case STRTAB_STE_0_CFG_ABORT:
>> -            if (disable_bypass)
>> -                break;
>> +            break;
>>           default:
>>               BUG(); /* STE corruption */
>>           }
>> @@ -1152,8 +1153,13 @@ static void arm_smmu_write_strtab_ent(struct
>> arm_smmu_device *smmu, u32 sid,
>>       val = STRTAB_STE_0_V;
>>         /* Bypass/fault */
>> -    if (!ste->assigned || !(ste->s1_cfg || ste->s2_cfg)) {
>> -        if (!ste->assigned && disable_bypass)
>> +
>> +    abort = (!ste->assigned && disable_bypass) || ste->abort;
>> +    translate = ste->s1_cfg || ste->s2_cfg;
>> +    bypass = !abort && !translate;
>> +
>> +    if (abort || bypass) {
>> +        if (abort)
>>               val |= FIELD_PREP(STRTAB_STE_0_CFG,
>> STRTAB_STE_0_CFG_ABORT);
>>           else
>>               val |= FIELD_PREP(STRTAB_STE_0_CFG,
>> STRTAB_STE_0_CFG_BYPASS);
>> @@ -1172,7 +1178,6 @@ static void arm_smmu_write_strtab_ent(struct
>> arm_smmu_device *smmu, u32 sid,
>>       }
>>         if (ste->s1_cfg) {
>> -        BUG_ON(ste_live);
> 
> Hmm, I'm a little uneasy about just removing these checks altogether, as
> there are still cases where rewriting a live entry is bogus, that we'd
> really like to keep catching. Is the problem that it's hard to tell when
> you're 'rewriting' the S2 config of a nested entry with the same thing
> on attaching/detaching its S1 context?
No, I restored the original checks in !nested mode and added a new check
to make sure we never update a live S1 in nested mode. Only S2 can be live.

Thanks

Eric
> 
> Robin.
> 
>>           dst[1] = cpu_to_le64(
>>                FIELD_PREP(STRTAB_STE_1_S1CIR,
>> STRTAB_STE_1_S1C_CACHE_WBRA) |
>>                FIELD_PREP(STRTAB_STE_1_S1COR,
>> STRTAB_STE_1_S1C_CACHE_WBRA) |
>> @@ -1191,7 +1196,6 @@ static void arm_smmu_write_strtab_ent(struct
>> arm_smmu_device *smmu, u32 sid,
>>       }
>>         if (ste->s2_cfg) {
>> -        BUG_ON(ste_live);
>>           dst[2] = cpu_to_le64(
>>                FIELD_PREP(STRTAB_STE_2_S2VMID, ste->s2_cfg->vmid) |
>>                FIELD_PREP(STRTAB_STE_2_VTCR, ste->s2_cfg->vtcr) |
>> @@ -1773,6 +1777,7 @@ static void arm_smmu_detach_dev(struct device *dev)
>>       }
>>         master->ste.assigned = false;
>> +    master->ste.abort = false;
>>       arm_smmu_install_ste_for_dev(fwspec);
>>   }
>>  
