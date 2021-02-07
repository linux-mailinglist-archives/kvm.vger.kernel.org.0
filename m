Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BC3D63120CB
	for <lists+kvm@lfdr.de>; Sun,  7 Feb 2021 02:58:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229570AbhBGB5o (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 6 Feb 2021 20:57:44 -0500
Received: from szxga07-in.huawei.com ([45.249.212.35]:12858 "EHLO
        szxga07-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229548AbhBGB5o (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 6 Feb 2021 20:57:44 -0500
Received: from DGGEMS407-HUB.china.huawei.com (unknown [172.30.72.59])
        by szxga07-in.huawei.com (SkyGuard) with ESMTP id 4DYC0p1g6Yz7hJb;
        Sun,  7 Feb 2021 09:55:38 +0800 (CST)
Received: from [10.174.184.42] (10.174.184.42) by
 DGGEMS407-HUB.china.huawei.com (10.3.19.207) with Microsoft SMTP Server id
 14.3.498.0; Sun, 7 Feb 2021 09:56:49 +0800
Subject: Re: [RFC PATCH 01/11] iommu/arm-smmu-v3: Add feature detection for
 HTTU
To:     Robin Murphy <robin.murphy@arm.com>,
        <linux-kernel@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>, <kvm@vger.kernel.org>,
        <kvmarm@lists.cs.columbia.edu>, <iommu@lists.linux-foundation.org>,
        Jean-Philippe Brucker <jean-philippe@linaro.org>
References: <20210128151742.18840-1-zhukeqian1@huawei.com>
 <20210128151742.18840-2-zhukeqian1@huawei.com>
 <f8be5718-d4d9-0565-eaf0-b5a128897d15@arm.com>
 <df1b8fb2-b853-e797-0072-9dbdffc4ff67@huawei.com>
 <5ada4a8b-8852-f83c-040a-9ef5dac51de2@arm.com>
 <94375ed6-1e25-b592-8bb0-e433e7a09b4c@arm.com>
CC:     Mark Rutland <mark.rutland@arm.com>,
        "Tian, Kevin" <kevin.tian@intel.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Marc Zyngier <maz@kernel.org>, <jiangkunkun@huawei.com>,
        Kirti Wankhede <kwankhede@nvidia.com>, <lushenming@huawei.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        James Morse <james.morse@arm.com>,
        "Catalin Marinas" <catalin.marinas@arm.com>,
        <wanghaibin.wang@huawei.com>, Will Deacon <will@kernel.org>
From:   Keqian Zhu <zhukeqian1@huawei.com>
Message-ID: <e3ace87c-a57f-ede9-834a-8bbbcced728a@huawei.com>
Date:   Sun, 7 Feb 2021 09:56:48 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:45.0) Gecko/20100101
 Thunderbird/45.7.1
MIME-Version: 1.0
In-Reply-To: <94375ed6-1e25-b592-8bb0-e433e7a09b4c@arm.com>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.174.184.42]
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Robin,

On 2021/2/6 0:11, Robin Murphy wrote:
> On 2021-02-05 11:48, Robin Murphy wrote:
>> On 2021-02-05 09:13, Keqian Zhu wrote:
>>> Hi Robin and Jean,
>>>
>>> On 2021/2/5 3:50, Robin Murphy wrote:
>>>> On 2021-01-28 15:17, Keqian Zhu wrote:
>>>>> From: jiangkunkun <jiangkunkun@huawei.com>
>>>>>
>>>>> The SMMU which supports HTTU (Hardware Translation Table Update) can
>>>>> update the access flag and the dirty state of TTD by hardware. It is
>>>>> essential to track dirty pages of DMA.
>>>>>
>>>>> This adds feature detection, none functional change.
>>>>>
>>>>> Co-developed-by: Keqian Zhu <zhukeqian1@huawei.com>
>>>>> Signed-off-by: Kunkun Jiang <jiangkunkun@huawei.com>
>>>>> ---
>>>>>    drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c | 16 ++++++++++++++++
>>>>>    drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h |  8 ++++++++
>>>>>    include/linux/io-pgtable.h                  |  1 +
>>>>>    3 files changed, 25 insertions(+)
>>>>>
>>>>> diff --git a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
>>>>> index 8ca7415d785d..0f0fe71cc10d 100644
>>>>> --- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
>>>>> +++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
>>>>> @@ -1987,6 +1987,7 @@ static int arm_smmu_domain_finalise(struct iommu_domain *domain,
>>>>>            .pgsize_bitmap    = smmu->pgsize_bitmap,
>>>>>            .ias        = ias,
>>>>>            .oas        = oas,
>>>>> +        .httu_hd    = smmu->features & ARM_SMMU_FEAT_HTTU_HD,
>>>>>            .coherent_walk    = smmu->features & ARM_SMMU_FEAT_COHERENCY,
>>>>>            .tlb        = &arm_smmu_flush_ops,
>>>>>            .iommu_dev    = smmu->dev,
>>>>> @@ -3224,6 +3225,21 @@ static int arm_smmu_device_hw_probe(struct arm_smmu_device *smmu)
>>>>>        if (reg & IDR0_HYP)
>>>>>            smmu->features |= ARM_SMMU_FEAT_HYP;
>>>>>    +    switch (FIELD_GET(IDR0_HTTU, reg)) {
>>>>
>>>> We need to accommodate the firmware override as well if we need this to be meaningful. Jean-Philippe is already carrying a suitable patch in the SVA stack[1].
>>> Robin, Thanks for pointing it out.
>>>
>>> Jean, I see that the IORT HTTU flag overrides the hardware register info unconditionally. I have some concern about it:
>>>
>>> If the override flag has HTTU but hardware doesn't support it, then driver will use this feature but receive access fault or permission fault from SMMU unexpectedly.
>>> 1) If IOPF is not supported, then kernel can not work normally.
>>> 2) If IOPF is supported, kernel will perform useless actions, such as HTTU based dma dirty tracking (this series).
>>
>> Yes, if the IORT describes the SMMU incorrectly, things will not work well. Just like if it describes the wrong base address or the wrong interrupt numbers, things will also not work well. The point is that incorrect firmware can be updated in the field fairly easily; incorrect hardware can not.
>>
>> Say the SMMU designer hard-codes the ID register field to 0x2 because the SMMU itself is capable of HTTU, and they assume it's always going to be wired up coherently, but then a customer integrates it to a non-coherent interconnect. Firmware needs to override that value to prevent an OS thinking that the claimed HTTU capability is ever going to work.
>>
>> Or say the SMMU *is* integrated correctly, but due to an erratum discovered later in the interconnect or SMMU itself, it turns out DBM doesn't always work reliably, but AF is still OK. Firmware needs to downgrade the indicated level of support from that which was intended to that which works reliably.
>>
>> Or say someone forgets to set an integration tieoff so their SMMU reports 0x0 even though it and the interconnect *can* happily support HTTU. In that case, firmware may want to upgrade the value to *allow* an OS to use HTTU despite the ID register being wrong.
>>
>>> As the IORT spec doesn't give an explicit explanation for HTTU override, can we comprehend it as a mask for HTTU related hardware register?
>>> So the logic becomes: smmu->feature = HTTU override & IDR0_HTTU;
>>
>> No, it literally states that the OS must use the value of the firmware field *instead* of the value from the hardware field.
> 
> Oops, apologies for an oversight there - I've been reviewing IORT spec updates lately so naturally had the newest version open already. Turns out these descriptions were only clarified in the most recent release, so if you were looking at an older document they *were* horribly vague.
Yep, my local version is E which was released at July 2020. I download the version E.a just now, thanks. ;-)

Thanks,
Keqian
