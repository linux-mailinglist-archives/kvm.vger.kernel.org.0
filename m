Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 289E219F5C
	for <lists+kvm@lfdr.de>; Fri, 10 May 2019 16:35:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727828AbfEJOfj (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 10 May 2019 10:35:39 -0400
Received: from mx1.redhat.com ([209.132.183.28]:46302 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727384AbfEJOfj (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 10 May 2019 10:35:39 -0400
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 826AF308A106;
        Fri, 10 May 2019 14:35:38 +0000 (UTC)
Received: from [10.36.116.17] (ovpn-116-17.ams2.redhat.com [10.36.116.17])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 5B2D75E7C1;
        Fri, 10 May 2019 14:35:30 +0000 (UTC)
Subject: Re: [PATCH v7 13/23] iommu/smmuv3: Implement
 attach/detach_pasid_table
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
 <20190408121911.24103-14-eric.auger@redhat.com>
 <acde8b95-9cbc-c5e6-eb28-37bff7431e40@arm.com>
From:   Auger Eric <eric.auger@redhat.com>
Message-ID: <30020e0d-2164-5b39-f1ca-04a85263b7f3@redhat.com>
Date:   Fri, 10 May 2019 16:35:28 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.4.0
MIME-Version: 1.0
In-Reply-To: <acde8b95-9cbc-c5e6-eb28-37bff7431e40@arm.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.44]); Fri, 10 May 2019 14:35:38 +0000 (UTC)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Robin,

On 5/8/19 4:38 PM, Robin Murphy wrote:
> On 08/04/2019 13:19, Eric Auger wrote:
>> On attach_pasid_table() we program STE S1 related info set
>> by the guest into the actual physical STEs. At minimum
>> we need to program the context descriptor GPA and compute
>> whether the stage1 is translated/bypassed or aborted.
>>
>> Signed-off-by: Eric Auger <eric.auger@redhat.com>
>>
>> ---
>> v6 -> v7:
>> - check versions and comment the fact we don't need to take
>>    into account s1dss and s1fmt
>> v3 -> v4:
>> - adapt to changes in iommu_pasid_table_config
>> - different programming convention at s1_cfg/s2_cfg/ste.abort
>>
>> v2 -> v3:
>> - callback now is named set_pasid_table and struct fields
>>    are laid out differently.
>>
>> v1 -> v2:
>> - invalidate the STE before changing them
>> - hold init_mutex
>> - handle new fields
>> ---
>>   drivers/iommu/arm-smmu-v3.c | 121 ++++++++++++++++++++++++++++++++++++
>>   1 file changed, 121 insertions(+)
>>
>> diff --git a/drivers/iommu/arm-smmu-v3.c b/drivers/iommu/arm-smmu-v3.c
>> index e22e944ffc05..1486baf53425 100644
>> --- a/drivers/iommu/arm-smmu-v3.c
>> +++ b/drivers/iommu/arm-smmu-v3.c
>> @@ -2207,6 +2207,125 @@ static void arm_smmu_put_resv_regions(struct
>> device *dev,
>>           kfree(entry);
>>   }
>>   +static int arm_smmu_attach_pasid_table(struct iommu_domain *domain,
>> +                       struct iommu_pasid_table_config *cfg)
>> +{
>> +    struct arm_smmu_domain *smmu_domain = to_smmu_domain(domain);
>> +    struct arm_smmu_master_data *entry;
>> +    struct arm_smmu_s1_cfg *s1_cfg;
>> +    struct arm_smmu_device *smmu;
>> +    unsigned long flags;
>> +    int ret = -EINVAL;
>> +
>> +    if (cfg->format != IOMMU_PASID_FORMAT_SMMUV3)
>> +        return -EINVAL;
>> +
>> +    if (cfg->version != PASID_TABLE_CFG_VERSION_1 ||
>> +        cfg->smmuv3.version != PASID_TABLE_SMMUV3_CFG_VERSION_1)
>> +        return -EINVAL;
>> +
>> +    mutex_lock(&smmu_domain->init_mutex);
>> +
>> +    smmu = smmu_domain->smmu;
>> +
>> +    if (!smmu)
>> +        goto out;
>> +
>> +    if (!((smmu->features & ARM_SMMU_FEAT_TRANS_S1) &&
>> +          (smmu->features & ARM_SMMU_FEAT_TRANS_S2))) {
>> +        dev_info(smmu_domain->smmu->dev,
>> +             "does not implement two stages\n");
>> +        goto out;
>> +    }
> 
> That check is redundant (and frankly looks a little bit spammy). If the
> one below is not enough, there is a problem elsewhere - if it's possible
> for smmu_domain->stage to ever get set to ARM_SMMU_DOMAIN_NESTED without
> both stages of translation present, we've already gone fundamentally wrong.

Makes sense. Moved that check to arm_smmu_domain_finalise() instead and
remove redundant ones.
> 
>> +
>> +    if (smmu_domain->stage != ARM_SMMU_DOMAIN_NESTED)
>> +        goto out;
>> +
>> +    switch (cfg->config) {
>> +    case IOMMU_PASID_CONFIG_ABORT:
>> +        spin_lock_irqsave(&smmu_domain->devices_lock, flags);
>> +        list_for_each_entry(entry, &smmu_domain->devices, list) {
>> +            entry->ste.s1_cfg = NULL;
>> +            entry->ste.abort = true;
>> +            arm_smmu_install_ste_for_dev(entry->dev->iommu_fwspec);
>> +        }
>> +        spin_unlock_irqrestore(&smmu_domain->devices_lock, flags);
>> +        ret = 0;
>> +        break;
>> +    case IOMMU_PASID_CONFIG_BYPASS:
>> +        spin_lock_irqsave(&smmu_domain->devices_lock, flags);
>> +        list_for_each_entry(entry, &smmu_domain->devices, list) {
>> +            entry->ste.s1_cfg = NULL;
>> +            entry->ste.abort = false;
>> +            arm_smmu_install_ste_for_dev(entry->dev->iommu_fwspec);
>> +        }
>> +        spin_unlock_irqrestore(&smmu_domain->devices_lock, flags);
>> +        ret = 0;
>> +        break;
>> +    case IOMMU_PASID_CONFIG_TRANSLATE:
>> +        /*
>> +         * we currently support a single CD so s1fmt and s1dss
>> +         * fields are also ignored
>> +         */
>> +        if (cfg->pasid_bits)
>> +            goto out;
>> +
>> +        s1_cfg = &smmu_domain->s1_cfg;
>> +        s1_cfg->cdptr_dma = cfg->base_ptr;
>> +
>> +        spin_lock_irqsave(&smmu_domain->devices_lock, flags);
>> +        list_for_each_entry(entry, &smmu_domain->devices, list) {
>> +            entry->ste.s1_cfg = s1_cfg;
> 
> Either we reject valid->valid transitions outright, or we need to remove
> and invalidate the existing S1 context from the STE at this point, no?
I agree. I added this in arm_smmu_write_strtab_ent().

> 
>> +            entry->ste.abort = false;
>> +            arm_smmu_install_ste_for_dev(entry->dev->iommu_fwspec);
>> +        }
>> +        spin_unlock_irqrestore(&smmu_domain->devices_lock, flags);
>> +        ret = 0;
>> +        break;
>> +    default:
>> +        break;
>> +    }
>> +out:
>> +    mutex_unlock(&smmu_domain->init_mutex);
>> +    return ret;
>> +}
>> +
>> +static void arm_smmu_detach_pasid_table(struct iommu_domain *domain)
>> +{
>> +    struct arm_smmu_domain *smmu_domain = to_smmu_domain(domain);
>> +    struct arm_smmu_master_data *entry;
>> +    struct arm_smmu_device *smmu;
>> +    unsigned long flags;
>> +
>> +    mutex_lock(&smmu_domain->init_mutex);
>> +
>> +    smmu = smmu_domain->smmu;
>> +
>> +    if (!smmu)
>> +        return;
>> +
>> +    if (!((smmu->features & ARM_SMMU_FEAT_TRANS_S1) &&
>> +          (smmu->features & ARM_SMMU_FEAT_TRANS_S2))) {
>> +        dev_info(smmu_domain->smmu->dev,
>> +             "does not implement two stages\n");
>> +        return;
>> +    }
> 
> Same comment as before.
OK

Thanks

Eric
> 
> Robin.
> 
>> +
>> +    if (smmu_domain->stage != ARM_SMMU_DOMAIN_NESTED)
>> +        return;
>> +
>> +    spin_lock_irqsave(&smmu_domain->devices_lock, flags);
>> +    list_for_each_entry(entry, &smmu_domain->devices, list) {
>> +        entry->ste.s1_cfg = NULL;
>> +        entry->ste.abort = true;
>> +        arm_smmu_install_ste_for_dev(entry->dev->iommu_fwspec);
>> +    }
>> +    spin_unlock_irqrestore(&smmu_domain->devices_lock, flags);
>> +
>> +    memset(&smmu_domain->s1_cfg, 0, sizeof(struct arm_smmu_s1_cfg));
>> +    mutex_unlock(&smmu_domain->init_mutex);
>> +}
>> +
>>   static struct iommu_ops arm_smmu_ops = {
>>       .capable        = arm_smmu_capable,
>>       .domain_alloc        = arm_smmu_domain_alloc,
>> @@ -2225,6 +2344,8 @@ static struct iommu_ops arm_smmu_ops = {
>>       .of_xlate        = arm_smmu_of_xlate,
>>       .get_resv_regions    = arm_smmu_get_resv_regions,
>>       .put_resv_regions    = arm_smmu_put_resv_regions,
>> +    .attach_pasid_table    = arm_smmu_attach_pasid_table,
>> +    .detach_pasid_table    = arm_smmu_detach_pasid_table,
>>       .pgsize_bitmap        = -1UL, /* Restricted during device attach */
>>   };
>>  
