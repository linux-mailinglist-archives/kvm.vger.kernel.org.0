Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8728B1B557
	for <lists+kvm@lfdr.de>; Mon, 13 May 2019 13:55:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728841AbfEMLy7 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 13 May 2019 07:54:59 -0400
Received: from foss.arm.com ([217.140.101.70]:53854 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727339AbfEMLy7 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 13 May 2019 07:54:59 -0400
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.72.51.249])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id C6036374;
        Mon, 13 May 2019 04:54:57 -0700 (PDT)
Received: from [10.1.196.75] (e110467-lin.cambridge.arm.com [10.1.196.75])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id C2A443F703;
        Mon, 13 May 2019 04:54:54 -0700 (PDT)
Subject: Re: [PATCH v7 18/23] iommu/smmuv3: Report non recoverable faults
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
 <20190408121911.24103-19-eric.auger@redhat.com>
 <52dd9de0-67a9-0316-cfe1-83d855d26c66@arm.com>
 <46f39a8e-a909-5493-b1eb-f8f082b0bb20@redhat.com>
From:   Robin Murphy <robin.murphy@arm.com>
Message-ID: <3119943e-30f1-823d-c6a2-157b26901a41@arm.com>
Date:   Mon, 13 May 2019 12:54:53 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.6.1
MIME-Version: 1.0
In-Reply-To: <46f39a8e-a909-5493-b1eb-f8f082b0bb20@redhat.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-GB
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 13/05/2019 08:46, Auger Eric wrote:
> Hi Robin,
> 
> On 5/8/19 7:20 PM, Robin Murphy wrote:
>> On 08/04/2019 13:19, Eric Auger wrote:
>>> When a stage 1 related fault event is read from the event queue,
>>> let's propagate it to potential external fault listeners, ie. users
>>> who registered a fault handler.
>>>
>>> Signed-off-by: Eric Auger <eric.auger@redhat.com>
>>>
>>> ---
>>> v4 -> v5:
>>> - s/IOMMU_FAULT_PERM_INST/IOMMU_FAULT_PERM_EXEC
>>> ---
>>>    drivers/iommu/arm-smmu-v3.c | 169 +++++++++++++++++++++++++++++++++---
>>>    1 file changed, 158 insertions(+), 11 deletions(-)
>>>
>>> diff --git a/drivers/iommu/arm-smmu-v3.c b/drivers/iommu/arm-smmu-v3.c
>>> index 8044445bc32a..1fd320788dcb 100644
>>> --- a/drivers/iommu/arm-smmu-v3.c
>>> +++ b/drivers/iommu/arm-smmu-v3.c
>>> @@ -167,6 +167,26 @@
>>>    #define ARM_SMMU_PRIQ_IRQ_CFG1        0xd8
>>>    #define ARM_SMMU_PRIQ_IRQ_CFG2        0xdc
>>>    +/* Events */
>>> +#define ARM_SMMU_EVT_F_UUT        0x01
>>> +#define ARM_SMMU_EVT_C_BAD_STREAMID    0x02
>>> +#define ARM_SMMU_EVT_F_STE_FETCH    0x03
>>> +#define ARM_SMMU_EVT_C_BAD_STE        0x04
>>> +#define ARM_SMMU_EVT_F_BAD_ATS_TREQ    0x05
>>> +#define ARM_SMMU_EVT_F_STREAM_DISABLED    0x06
>>> +#define ARM_SMMU_EVT_F_TRANSL_FORBIDDEN    0x07
>>> +#define ARM_SMMU_EVT_C_BAD_SUBSTREAMID    0x08
>>> +#define ARM_SMMU_EVT_F_CD_FETCH        0x09
>>> +#define ARM_SMMU_EVT_C_BAD_CD        0x0a
>>> +#define ARM_SMMU_EVT_F_WALK_EABT    0x0b
>>> +#define ARM_SMMU_EVT_F_TRANSLATION    0x10
>>> +#define ARM_SMMU_EVT_F_ADDR_SIZE    0x11
>>> +#define ARM_SMMU_EVT_F_ACCESS        0x12
>>> +#define ARM_SMMU_EVT_F_PERMISSION    0x13
>>> +#define ARM_SMMU_EVT_F_TLB_CONFLICT    0x20
>>> +#define ARM_SMMU_EVT_F_CFG_CONFLICT    0x21
>>> +#define ARM_SMMU_EVT_E_PAGE_REQUEST    0x24
>>> +
>>>    /* Common MSI config fields */
>>>    #define MSI_CFG0_ADDR_MASK        GENMASK_ULL(51, 2)
>>>    #define MSI_CFG2_SH            GENMASK(5, 4)
>>> @@ -332,6 +352,15 @@
>>>    #define EVTQ_MAX_SZ_SHIFT        7
>>>      #define EVTQ_0_ID            GENMASK_ULL(7, 0)
>>> +#define EVTQ_0_SSV            GENMASK_ULL(11, 11)
>>> +#define EVTQ_0_SUBSTREAMID        GENMASK_ULL(31, 12)
>>> +#define EVTQ_0_STREAMID            GENMASK_ULL(63, 32)
>>> +#define EVTQ_1_PNU            GENMASK_ULL(33, 33)
>>> +#define EVTQ_1_IND            GENMASK_ULL(34, 34)
>>> +#define EVTQ_1_RNW            GENMASK_ULL(35, 35)
>>> +#define EVTQ_1_S2            GENMASK_ULL(39, 39)
>>> +#define EVTQ_1_CLASS            GENMASK_ULL(40, 41)
>>> +#define EVTQ_3_FETCH_ADDR        GENMASK_ULL(51, 3)
>>>      /* PRI queue */
>>>    #define PRIQ_ENT_DWORDS            2
>>> @@ -639,6 +668,64 @@ struct arm_smmu_domain {
>>>        spinlock_t            devices_lock;
>>>    };
>>>    +/* fault propagation */
>>> +
>>> +#define IOMMU_FAULT_F_FIELDS    (IOMMU_FAULT_UNRECOV_PASID_VALID | \
>>> +                 IOMMU_FAULT_UNRECOV_PERM_VALID | \
>>> +                 IOMMU_FAULT_UNRECOV_ADDR_VALID)
>>> +
>>> +struct arm_smmu_fault_propagation_data {
>>> +    enum iommu_fault_reason reason;
>>> +    bool s1_check;
>>> +    u32 fields; /* IOMMU_FAULT_UNRECOV_*_VALID bits */
>>> +};
>>> +
>>> +/*
>>> + * Describes how SMMU faults translate into generic IOMMU faults
>>> + * and if they need to be reported externally
>>> + */
>>> +static const struct arm_smmu_fault_propagation_data
>>> fault_propagation[] = {
>>> +[ARM_SMMU_EVT_F_UUT]            = { },
>>> +[ARM_SMMU_EVT_C_BAD_STREAMID]        = { },
>>> +[ARM_SMMU_EVT_F_STE_FETCH]        = { },
>>> +[ARM_SMMU_EVT_C_BAD_STE]        = { },
>>> +[ARM_SMMU_EVT_F_BAD_ATS_TREQ]        = { },
>>> +[ARM_SMMU_EVT_F_STREAM_DISABLED]    = { },
>>> +[ARM_SMMU_EVT_F_TRANSL_FORBIDDEN]    = { },
>>> +[ARM_SMMU_EVT_C_BAD_SUBSTREAMID]    = {IOMMU_FAULT_REASON_PASID_INVALID,
>>> +                       false,
>>> +                       IOMMU_FAULT_UNRECOV_PASID_VALID
>>> +                      },
>>> +[ARM_SMMU_EVT_F_CD_FETCH]        = {IOMMU_FAULT_REASON_PASID_FETCH,
>>> +                       false,
>>> +                       IOMMU_FAULT_UNRECOV_PASID_VALID |
>>
>> It doesn't make sense to presume validity here, or in any of the faults
>> below...
> 
> 
>>
>>> +                       IOMMU_FAULT_UNRECOV_FETCH_ADDR_VALID
>>> +                      },
>>> +[ARM_SMMU_EVT_C_BAD_CD]            =
>>> {IOMMU_FAULT_REASON_BAD_PASID_ENTRY,
>>> +                       false,
>>> +                       IOMMU_FAULT_UNRECOV_PASID_VALID
>>> +                      },
>>> +[ARM_SMMU_EVT_F_WALK_EABT]        = {IOMMU_FAULT_REASON_WALK_EABT, true,
>>> +                       IOMMU_FAULT_F_FIELDS |
>>> +                       IOMMU_FAULT_UNRECOV_FETCH_ADDR_VALID
>>> +                      },
>>> +[ARM_SMMU_EVT_F_TRANSLATION]        = {IOMMU_FAULT_REASON_PTE_FETCH,
>>> true,
>>> +                       IOMMU_FAULT_F_FIELDS
>>> +                      },
>>> +[ARM_SMMU_EVT_F_ADDR_SIZE]        = {IOMMU_FAULT_REASON_OOR_ADDRESS,
>>> true,
>>> +                       IOMMU_FAULT_F_FIELDS
>>> +                      },
>>> +[ARM_SMMU_EVT_F_ACCESS]            = {IOMMU_FAULT_REASON_ACCESS, true,
>>> +                       IOMMU_FAULT_F_FIELDS
>>> +                      },
>>> +[ARM_SMMU_EVT_F_PERMISSION]        = {IOMMU_FAULT_REASON_PERMISSION,
>>> true,
>>> +                       IOMMU_FAULT_F_FIELDS
>>> +                      },
>>> +[ARM_SMMU_EVT_F_TLB_CONFLICT]        = { },
>>> +[ARM_SMMU_EVT_F_CFG_CONFLICT]        = { },
>>> +[ARM_SMMU_EVT_E_PAGE_REQUEST]        = { },
>>> +};
>>> +
>>>    struct arm_smmu_option_prop {
>>>        u32 opt;
>>>        const char *prop;
>>> @@ -1258,7 +1345,6 @@ static int arm_smmu_init_l2_strtab(struct
>>> arm_smmu_device *smmu, u32 sid)
>>>        return 0;
>>>    }
>>>    -__maybe_unused
>>>    static struct arm_smmu_master_data *
>>>    arm_smmu_find_master(struct arm_smmu_device *smmu, u32 sid)
>>>    {
>>> @@ -1284,24 +1370,85 @@ arm_smmu_find_master(struct arm_smmu_device
>>> *smmu, u32 sid)
>>>        return master;
>>>    }
>>>    +/* Populates the record fields according to the input SMMU event */
>>> +static bool arm_smmu_transcode_fault(u64 *evt, u8 type,
>>> +                     struct iommu_fault_unrecoverable *record)
>>> +{
>>> +    const struct arm_smmu_fault_propagation_data *data;
>>> +    u32 fields;
>>> +
>>> +    if (type >= ARRAY_SIZE(fault_propagation))
>>> +        return false;
>>> +
>>> +    data = &fault_propagation[type];
>>> +    if (!data->reason)
>>> +        return false;
>>> +
>>> +    fields = data->fields;
>>> +
>>> +    if (data->s1_check & FIELD_GET(EVTQ_1_S2, evt[1]))
>>> +        return false; /* S2 related fault, don't propagate */
>>> +
>>> +    if (fields & IOMMU_FAULT_UNRECOV_PASID_VALID) {
>>> +        if (FIELD_GET(EVTQ_0_SSV, evt[0]))
>>> +            record->pasid = FIELD_GET(EVTQ_0_SUBSTREAMID, evt[0]);
>>> +        else
>>> +            fields &= ~IOMMU_FAULT_UNRECOV_PASID_VALID;
>>
>> ...because this logic then breaks for C_BAD_SUBSTREAMID, which ends up
>> coming out of here *without* reporting the offending PASID.
> Correct.
>>
>>> +    }
>>> +    if (fields & IOMMU_FAULT_UNRECOV_PERM_VALID) {
>>> +        if (!FIELD_GET(EVTQ_1_RNW, evt[1]))
>>> +            record->perm |= IOMMU_FAULT_PERM_WRITE;
>>> +        if (FIELD_GET(EVTQ_1_PNU, evt[1]))
>>> +            record->perm |= IOMMU_FAULT_PERM_PRIV;
>>> +        if (FIELD_GET(EVTQ_1_IND, evt[1]))
>>> +            record->perm |= IOMMU_FAULT_PERM_EXEC;
>>> +    }
>>> +    if (fields & IOMMU_FAULT_UNRECOV_ADDR_VALID)
>>> +        record->addr = evt[2];
>>> +
>>> +    if (fields & IOMMU_FAULT_UNRECOV_FETCH_ADDR_VALID)
>>> +        record->fetch_addr = FIELD_GET(EVTQ_3_FETCH_ADDR, evt[3]);
>>> +
>>> +    record->flags = fields;
>>> +    return true;
>>> +}
>>> +
>>> +static void arm_smmu_report_event(struct arm_smmu_device *smmu, u64
>>> *evt)
>>> +{
>>> +    u32 sid = FIELD_GET(EVTQ_0_STREAMID, evt[0]);
>>> +    u8 type = FIELD_GET(EVTQ_0_ID, evt[0]);
>>> +    struct arm_smmu_master_data *master;
>>> +    struct iommu_fault_event event = {};
>>> +    int i;
>>> +
>>> +    master = arm_smmu_find_master(smmu, sid);
>>> +    if (WARN_ON(!master))
>>> +        return;
>>
>> NAK. If I'm getting global faults like C_BAD_STE where a device almost
>> certainly *isn't* configured (because hey, we would have initialised its
>> STEs if we knew), then I sure as hell want to see the actual faults.
>> Spamming a constant stream of stack traces *instead* of showing them is
>> worse than useless.
> Sure, if !master I will output the original traces.
>>
>>> +
>>> +    event.fault.type = IOMMU_FAULT_DMA_UNRECOV;
>>> +
>>> +    if (arm_smmu_transcode_fault(evt, type, &event.fault.event)) {
>>> +        iommu_report_device_fault(master->dev, &event);
>>> +        return;
>>
>> And again, the vast majority of the time, there won't be a fault handler
>> registered, so unconditionally suppressing the most common and useful
>> stuff like translation and permission faults is very much not OK.
> Going to test whether we are in nested mode before entering that path.

I don't think this has to be exclusive to nesting - the generic 
reporting mechanism feels like it might ultimately be extensible to 
other things like Rob's case for generalised stalling. It's just that 
for robustness, even when a fault handler is present, we still want the 
driver to be able to report if it didn't actually handle a fault.

Thanks,
Robin.
