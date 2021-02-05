Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 67D953114E4
	for <lists+kvm@lfdr.de>; Fri,  5 Feb 2021 23:23:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231446AbhBEWRl (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 5 Feb 2021 17:17:41 -0500
Received: from foss.arm.com ([217.140.110.172]:35542 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231522AbhBEOd0 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 5 Feb 2021 09:33:26 -0500
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 8AD8431B;
        Fri,  5 Feb 2021 08:11:10 -0800 (PST)
Received: from [10.57.49.26] (unknown [10.57.49.26])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 60A403F719;
        Fri,  5 Feb 2021 08:11:07 -0800 (PST)
Subject: Re: [RFC PATCH 01/11] iommu/arm-smmu-v3: Add feature detection for
 HTTU
From:   Robin Murphy <robin.murphy@arm.com>
To:     Keqian Zhu <zhukeqian1@huawei.com>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org,
        kvmarm@lists.cs.columbia.edu, iommu@lists.linux-foundation.org,
        Jean-Philippe Brucker <jean-philippe@linaro.org>
Cc:     Mark Rutland <mark.rutland@arm.com>,
        "Tian, Kevin" <kevin.tian@intel.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Marc Zyngier <maz@kernel.org>, jiangkunkun@huawei.com,
        Kirti Wankhede <kwankhede@nvidia.com>, lushenming@huawei.com,
        Alex Williamson <alex.williamson@redhat.com>,
        James Morse <james.morse@arm.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        wanghaibin.wang@huawei.com, Will Deacon <will@kernel.org>
References: <20210128151742.18840-1-zhukeqian1@huawei.com>
 <20210128151742.18840-2-zhukeqian1@huawei.com>
 <f8be5718-d4d9-0565-eaf0-b5a128897d15@arm.com>
 <df1b8fb2-b853-e797-0072-9dbdffc4ff67@huawei.com>
 <5ada4a8b-8852-f83c-040a-9ef5dac51de2@arm.com>
Message-ID: <94375ed6-1e25-b592-8bb0-e433e7a09b4c@arm.com>
Date:   Fri, 5 Feb 2021 16:11:06 +0000
User-Agent: Mozilla/5.0 (Windows NT 10.0; rv:78.0) Gecko/20100101
 Thunderbird/78.7.0
MIME-Version: 1.0
In-Reply-To: <5ada4a8b-8852-f83c-040a-9ef5dac51de2@arm.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-GB
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 2021-02-05 11:48, Robin Murphy wrote:
> On 2021-02-05 09:13, Keqian Zhu wrote:
>> Hi Robin and Jean,
>>
>> On 2021/2/5 3:50, Robin Murphy wrote:
>>> On 2021-01-28 15:17, Keqian Zhu wrote:
>>>> From: jiangkunkun <jiangkunkun@huawei.com>
>>>>
>>>> The SMMU which supports HTTU (Hardware Translation Table Update) can
>>>> update the access flag and the dirty state of TTD by hardware. It is
>>>> essential to track dirty pages of DMA.
>>>>
>>>> This adds feature detection, none functional change.
>>>>
>>>> Co-developed-by: Keqian Zhu <zhukeqian1@huawei.com>
>>>> Signed-off-by: Kunkun Jiang <jiangkunkun@huawei.com>
>>>> ---
>>>>    drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c | 16 ++++++++++++++++
>>>>    drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h |  8 ++++++++
>>>>    include/linux/io-pgtable.h                  |  1 +
>>>>    3 files changed, 25 insertions(+)
>>>>
>>>> diff --git a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c 
>>>> b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
>>>> index 8ca7415d785d..0f0fe71cc10d 100644
>>>> --- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
>>>> +++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
>>>> @@ -1987,6 +1987,7 @@ static int arm_smmu_domain_finalise(struct 
>>>> iommu_domain *domain,
>>>>            .pgsize_bitmap    = smmu->pgsize_bitmap,
>>>>            .ias        = ias,
>>>>            .oas        = oas,
>>>> +        .httu_hd    = smmu->features & ARM_SMMU_FEAT_HTTU_HD,
>>>>            .coherent_walk    = smmu->features & 
>>>> ARM_SMMU_FEAT_COHERENCY,
>>>>            .tlb        = &arm_smmu_flush_ops,
>>>>            .iommu_dev    = smmu->dev,
>>>> @@ -3224,6 +3225,21 @@ static int arm_smmu_device_hw_probe(struct 
>>>> arm_smmu_device *smmu)
>>>>        if (reg & IDR0_HYP)
>>>>            smmu->features |= ARM_SMMU_FEAT_HYP;
>>>>    +    switch (FIELD_GET(IDR0_HTTU, reg)) {
>>>
>>> We need to accommodate the firmware override as well if we need this 
>>> to be meaningful. Jean-Philippe is already carrying a suitable patch 
>>> in the SVA stack[1].
>> Robin, Thanks for pointing it out.
>>
>> Jean, I see that the IORT HTTU flag overrides the hardware register 
>> info unconditionally. I have some concern about it:
>>
>> If the override flag has HTTU but hardware doesn't support it, then 
>> driver will use this feature but receive access fault or permission 
>> fault from SMMU unexpectedly.
>> 1) If IOPF is not supported, then kernel can not work normally.
>> 2) If IOPF is supported, kernel will perform useless actions, such as 
>> HTTU based dma dirty tracking (this series).
> 
> Yes, if the IORT describes the SMMU incorrectly, things will not work 
> well. Just like if it describes the wrong base address or the wrong 
> interrupt numbers, things will also not work well. The point is that 
> incorrect firmware can be updated in the field fairly easily; incorrect 
> hardware can not.
> 
> Say the SMMU designer hard-codes the ID register field to 0x2 because 
> the SMMU itself is capable of HTTU, and they assume it's always going to 
> be wired up coherently, but then a customer integrates it to a 
> non-coherent interconnect. Firmware needs to override that value to 
> prevent an OS thinking that the claimed HTTU capability is ever going to 
> work.
> 
> Or say the SMMU *is* integrated correctly, but due to an erratum 
> discovered later in the interconnect or SMMU itself, it turns out DBM 
> doesn't always work reliably, but AF is still OK. Firmware needs to 
> downgrade the indicated level of support from that which was intended to 
> that which works reliably.
> 
> Or say someone forgets to set an integration tieoff so their SMMU 
> reports 0x0 even though it and the interconnect *can* happily support 
> HTTU. In that case, firmware may want to upgrade the value to *allow* an 
> OS to use HTTU despite the ID register being wrong.
> 
>> As the IORT spec doesn't give an explicit explanation for HTTU 
>> override, can we comprehend it as a mask for HTTU related hardware 
>> register?
>> So the logic becomes: smmu->feature = HTTU override & IDR0_HTTU;
> 
> No, it literally states that the OS must use the value of the firmware 
> field *instead* of the value from the hardware field.

Oops, apologies for an oversight there - I've been reviewing IORT spec 
updates lately so naturally had the newest version open already. Turns 
out these descriptions were only clarified in the most recent release, 
so if you were looking at an older document they *were* horribly vague.

Robin.

>>>> +    case IDR0_HTTU_NONE:
>>>> +        break;
>>>> +    case IDR0_HTTU_HA:
>>>> +        smmu->features |= ARM_SMMU_FEAT_HTTU_HA;
>>>> +        break;
>>>> +    case IDR0_HTTU_HAD:
>>>> +        smmu->features |= ARM_SMMU_FEAT_HTTU_HA;
>>>> +        smmu->features |= ARM_SMMU_FEAT_HTTU_HD;
>>>> +        break;
>>>> +    default:
>>>> +        dev_err(smmu->dev, "unknown/unsupported HTTU!\n");
>>>> +        return -ENXIO;
>>>> +    }
>>>> +
>>>>        /*
>>>>         * The coherency feature as set by FW is used in preference 
>>>> to the ID
>>>>         * register, but warn on mismatch.
>>>> diff --git a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h 
>>>> b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h
>>>> index 96c2e9565e00..e91bea44519e 100644
>>>> --- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h
>>>> +++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h
>>>> @@ -33,6 +33,10 @@
>>>>    #define IDR0_ASID16            (1 << 12)
>>>>    #define IDR0_ATS            (1 << 10)
>>>>    #define IDR0_HYP            (1 << 9)
>>>> +#define IDR0_HTTU            GENMASK(7, 6)
>>>> +#define IDR0_HTTU_NONE            0
>>>> +#define IDR0_HTTU_HA            1
>>>> +#define IDR0_HTTU_HAD            2
>>>>    #define IDR0_COHACC            (1 << 4)
>>>>    #define IDR0_TTF            GENMASK(3, 2)
>>>>    #define IDR0_TTF_AARCH64        2
>>>> @@ -286,6 +290,8 @@
>>>>    #define CTXDESC_CD_0_TCR_TBI0        (1ULL << 38)
>>>>      #define CTXDESC_CD_0_AA64        (1UL << 41)
>>>> +#define CTXDESC_CD_0_HD            (1UL << 42)
>>>> +#define CTXDESC_CD_0_HA            (1UL << 43)
>>>>    #define CTXDESC_CD_0_S            (1UL << 44)
>>>>    #define CTXDESC_CD_0_R            (1UL << 45)
>>>>    #define CTXDESC_CD_0_A            (1UL << 46)
>>>> @@ -604,6 +610,8 @@ struct arm_smmu_device {
>>>>    #define ARM_SMMU_FEAT_RANGE_INV        (1 << 15)
>>>>    #define ARM_SMMU_FEAT_BTM        (1 << 16)
>>>>    #define ARM_SMMU_FEAT_SVA        (1 << 17)
>>>> +#define ARM_SMMU_FEAT_HTTU_HA        (1 << 18)
>>>> +#define ARM_SMMU_FEAT_HTTU_HD        (1 << 19)
>>>>        u32                features;
>>>>      #define ARM_SMMU_OPT_SKIP_PREFETCH    (1 << 0)
>>>> diff --git a/include/linux/io-pgtable.h b/include/linux/io-pgtable.h
>>>> index ea727eb1a1a9..1a00ea8562c7 100644
>>>> --- a/include/linux/io-pgtable.h
>>>> +++ b/include/linux/io-pgtable.h
>>>> @@ -97,6 +97,7 @@ struct io_pgtable_cfg {
>>>>        unsigned long            pgsize_bitmap;
>>>>        unsigned int            ias;
>>>>        unsigned int            oas;
>>>> +    bool                httu_hd;
>>>
>>> This is very specific to the AArch64 stage 1 format, not a generic 
>>> capability - I think it should be a quirk flag rather than a common 
>>> field.
>> OK, so BBML should be a quirk flag too?
>>
>> Though the word "quirk" is not suitable for HTTU and BBML, we have no 
>> other place to convey smmu feature to io-pgtable.
> 
> Indeed these features aren't decorative grooves on a piece of furniture, 
> but in the case of io-pgtable we're merely using "quirk" in its broadest 
> sense to imply something that differs from the baseline default 
> behaviour - ARM_MTK_EXT, ARM_TTBR1 and ARM_OUTER_WBWA (or whatever it's 
> called this week) are all just indicating extra hardware features 
> entirely comparable to HTTU; NON_STRICT is describing a similarly 
> intentional and desired software behaviour. In fact only ARM_NS 
> represents something that could be considered a "workaround".
> 
> Robin.
> _______________________________________________
> iommu mailing list
> iommu@lists.linux-foundation.org
> https://lists.linuxfoundation.org/mailman/listinfo/iommu
