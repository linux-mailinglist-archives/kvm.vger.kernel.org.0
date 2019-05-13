Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CCD6B1B575
	for <lists+kvm@lfdr.de>; Mon, 13 May 2019 14:04:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729593AbfEMMEa (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 13 May 2019 08:04:30 -0400
Received: from foss.arm.com ([217.140.101.70]:54056 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727487AbfEMMEa (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 13 May 2019 08:04:30 -0400
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.72.51.249])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 32888374;
        Mon, 13 May 2019 05:04:29 -0700 (PDT)
Received: from [10.1.196.75] (e110467-lin.cambridge.arm.com [10.1.196.75])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 564573F703;
        Mon, 13 May 2019 05:04:26 -0700 (PDT)
Subject: Re: [PATCH v7 13/23] iommu/smmuv3: Implement
 attach/detach_pasid_table
To:     Auger Eric <eric.auger@redhat.com>, eric.auger.pro@gmail.com,
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
 <30020e0d-2164-5b39-f1ca-04a85263b7f3@redhat.com>
From:   Robin Murphy <robin.murphy@arm.com>
Message-ID: <1b700d41-71c3-a68d-58a5-4715a58c6b84@arm.com>
Date:   Mon, 13 May 2019 13:04:24 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.6.1
MIME-Version: 1.0
In-Reply-To: <30020e0d-2164-5b39-f1ca-04a85263b7f3@redhat.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-GB
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 10/05/2019 15:35, Auger Eric wrote:
> Hi Robin,
> 
> On 5/8/19 4:38 PM, Robin Murphy wrote:
>> On 08/04/2019 13:19, Eric Auger wrote:
>>> On attach_pasid_table() we program STE S1 related info set
>>> by the guest into the actual physical STEs. At minimum
>>> we need to program the context descriptor GPA and compute
>>> whether the stage1 is translated/bypassed or aborted.
>>>
>>> Signed-off-by: Eric Auger <eric.auger@redhat.com>
>>>
>>> ---
>>> v6 -> v7:
>>> - check versions and comment the fact we don't need to take
>>>     into account s1dss and s1fmt
>>> v3 -> v4:
>>> - adapt to changes in iommu_pasid_table_config
>>> - different programming convention at s1_cfg/s2_cfg/ste.abort
>>>
>>> v2 -> v3:
>>> - callback now is named set_pasid_table and struct fields
>>>     are laid out differently.
>>>
>>> v1 -> v2:
>>> - invalidate the STE before changing them
>>> - hold init_mutex
>>> - handle new fields
>>> ---
>>>    drivers/iommu/arm-smmu-v3.c | 121 ++++++++++++++++++++++++++++++++++++
>>>    1 file changed, 121 insertions(+)
>>>
>>> diff --git a/drivers/iommu/arm-smmu-v3.c b/drivers/iommu/arm-smmu-v3.c
>>> index e22e944ffc05..1486baf53425 100644
>>> --- a/drivers/iommu/arm-smmu-v3.c
>>> +++ b/drivers/iommu/arm-smmu-v3.c
>>> @@ -2207,6 +2207,125 @@ static void arm_smmu_put_resv_regions(struct
>>> device *dev,
>>>            kfree(entry);
>>>    }
>>>    +static int arm_smmu_attach_pasid_table(struct iommu_domain *domain,
>>> +                       struct iommu_pasid_table_config *cfg)
>>> +{
>>> +    struct arm_smmu_domain *smmu_domain = to_smmu_domain(domain);
>>> +    struct arm_smmu_master_data *entry;
>>> +    struct arm_smmu_s1_cfg *s1_cfg;
>>> +    struct arm_smmu_device *smmu;
>>> +    unsigned long flags;
>>> +    int ret = -EINVAL;
>>> +
>>> +    if (cfg->format != IOMMU_PASID_FORMAT_SMMUV3)
>>> +        return -EINVAL;
>>> +
>>> +    if (cfg->version != PASID_TABLE_CFG_VERSION_1 ||
>>> +        cfg->smmuv3.version != PASID_TABLE_SMMUV3_CFG_VERSION_1)
>>> +        return -EINVAL;
>>> +
>>> +    mutex_lock(&smmu_domain->init_mutex);
>>> +
>>> +    smmu = smmu_domain->smmu;
>>> +
>>> +    if (!smmu)
>>> +        goto out;
>>> +
>>> +    if (!((smmu->features & ARM_SMMU_FEAT_TRANS_S1) &&
>>> +          (smmu->features & ARM_SMMU_FEAT_TRANS_S2))) {
>>> +        dev_info(smmu_domain->smmu->dev,
>>> +             "does not implement two stages\n");
>>> +        goto out;
>>> +    }
>>
>> That check is redundant (and frankly looks a little bit spammy). If the
>> one below is not enough, there is a problem elsewhere - if it's possible
>> for smmu_domain->stage to ever get set to ARM_SMMU_DOMAIN_NESTED without
>> both stages of translation present, we've already gone fundamentally wrong.
> 
> Makes sense. Moved that check to arm_smmu_domain_finalise() instead and
> remove redundant ones.

Urgh, I forgot exactly how the crazy domain-allocation dance worked, 
such that we're not in a position to refuse the domain_set_attr() call 
itself, but that does sound like the best compromise for now.

Thanks,
Robin.
