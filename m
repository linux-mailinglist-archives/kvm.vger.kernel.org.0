Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6DD57262CB6
	for <lists+kvm@lfdr.de>; Wed,  9 Sep 2020 11:58:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727075AbgIIJ6w (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 9 Sep 2020 05:58:52 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:39695 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726535AbgIIJ6u (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 9 Sep 2020 05:58:50 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1599645527;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=9GYfr76gMmlD7R8eAq7IC3Rm6lO9WVaWytangZoFZ6w=;
        b=RQJv4WWaY5T/LWGvbKeTM3RqL7xwD58SOF2uXRVBkyIHQV66+B++q5rwPquJBHZLBPZRrV
        E5tKBEDehYnBYgI60OCua1btHU2Cy84MbYOGyuiwBIC2Bz7xPhOcPbHqQm5EACa2ir7D2q
        RrpAnbZyPU30Kzs+ejF/5MkXMWLLVtw=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-541-M-G5JZA-MZ6V-0MfQAepgA-1; Wed, 09 Sep 2020 05:58:46 -0400
X-MC-Unique: M-G5JZA-MZ6V-0MfQAepgA-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id D80021007466;
        Wed,  9 Sep 2020 09:58:43 +0000 (UTC)
Received: from [10.36.115.123] (ovpn-115-123.ams2.redhat.com [10.36.115.123])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 2A7125D9E8;
        Wed,  9 Sep 2020 09:58:40 +0000 (UTC)
Subject: Re: [PATCH v3 2/5] KVM: arm64: Use event mask matching architecture
 revision
To:     Marc Zyngier <maz@kernel.org>
Cc:     linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
        kvm@vger.kernel.org, James Morse <james.morse@arm.com>,
        Julien Thierry <julien.thierry.kdev@gmail.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Robin Murphy <robin.murphy@arm.com>,
        Mark Rutland <mark.rutland@arm.com>, graf@amazon.com,
        kernel-team@android.com
References: <20200908075830.1161921-1-maz@kernel.org>
 <20200908075830.1161921-3-maz@kernel.org>
 <2e1257aa-9e8c-89ba-c09b-3cfee38c8486@redhat.com>
 <a84f6d17414c0fae3df1038f0e17e225@kernel.org>
From:   Auger Eric <eric.auger@redhat.com>
Message-ID: <17ffe591-7416-a467-0c31-9c316f0bfc2a@redhat.com>
Date:   Wed, 9 Sep 2020 11:58:39 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.5.0
MIME-Version: 1.0
In-Reply-To: <a84f6d17414c0fae3df1038f0e17e225@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Marc,

On 9/9/20 11:54 AM, Marc Zyngier wrote:
> Hi Eric,
> 
> On 2020-09-09 10:38, Auger Eric wrote:
>> Hi Marc,
>>
>> On 9/8/20 9:58 AM, Marc Zyngier wrote:
>>> The PMU code suffers from a small defect where we assume that the event
>>> number provided by the guest is always 16 bit wide, even if the CPU only
>>> implements the ARMv8.0 architecture. This isn't really problematic in
>>> the sense that the event number ends up in a system register, cropping
>>> it to the right width, but still this needs fixing.
>>>
>>> In order to make it work, let's probe the version of the PMU that the
>>> guest is going to use. This is done by temporarily creating a kernel
>>> event and looking at the PMUVer field that has been saved at probe time
>>> in the associated arm_pmu structure. This in turn gets saved in the kvm
>>> structure, and subsequently used to compute the event mask that gets
>>> used throughout the PMU code.
>>>
>>> Signed-off-by: Marc Zyngier <maz@kernel.org>
>>> ---
>>>  arch/arm64/include/asm/kvm_host.h |  2 +
>>>  arch/arm64/kvm/pmu-emul.c         | 81 +++++++++++++++++++++++++++++--
>>>  2 files changed, 78 insertions(+), 5 deletions(-)
>>>
>>> diff --git a/arch/arm64/include/asm/kvm_host.h
>>> b/arch/arm64/include/asm/kvm_host.h
>>> index 65568b23868a..6cd60be69c28 100644
>>> --- a/arch/arm64/include/asm/kvm_host.h
>>> +++ b/arch/arm64/include/asm/kvm_host.h
>>> @@ -110,6 +110,8 @@ struct kvm_arch {
>>>       * supported.
>>>       */
>>>      bool return_nisv_io_abort_to_user;
>>> +
>>> +    unsigned int pmuver;
>>>  };
>>>
>>>  struct kvm_vcpu_fault_info {
>>> diff --git a/arch/arm64/kvm/pmu-emul.c b/arch/arm64/kvm/pmu-emul.c
>>> index 93d797df42c6..8a5f65763814 100644
>>> --- a/arch/arm64/kvm/pmu-emul.c
>>> +++ b/arch/arm64/kvm/pmu-emul.c
>>> @@ -20,6 +20,20 @@ static void kvm_pmu_stop_counter(struct kvm_vcpu
>>> *vcpu, struct kvm_pmc *pmc);
>>>
>>>  #define PERF_ATTR_CFG1_KVM_PMU_CHAINED 0x1
>>>
>>> +static u32 kvm_pmu_event_mask(struct kvm *kvm)
>>> +{
>>> +    switch (kvm->arch.pmuver) {
>>> +    case 1:            /* ARMv8.0 */
>>> +        return GENMASK(9, 0);
>>> +    case 4:            /* ARMv8.1 */
>>> +    case 5:            /* ARMv8.4 */
>>> +    case 6:            /* ARMv8.5 */
>>> +        return GENMASK(15, 0);
>>> +    default:        /* Shouldn't be there, just for sanity */
>>> +        return 0;
>>> +    }
>>> +}
>>> +
>>>  /**
>>>   * kvm_pmu_idx_is_64bit - determine if select_idx is a 64bit counter
>>>   * @vcpu: The vcpu pointer
>>> @@ -100,7 +114,7 @@ static bool kvm_pmu_idx_has_chain_evtype(struct
>>> kvm_vcpu *vcpu, u64 select_idx)
>>>          return false;
>>>
>>>      reg = PMEVTYPER0_EL0 + select_idx;
>>> -    eventsel = __vcpu_sys_reg(vcpu, reg) & ARMV8_PMU_EVTYPE_EVENT;
>>> +    eventsel = __vcpu_sys_reg(vcpu, reg) &
>>> kvm_pmu_event_mask(vcpu->kvm);
>>>
>>>      return eventsel == ARMV8_PMUV3_PERFCTR_CHAIN;
>>>  }
>>> @@ -495,7 +509,7 @@ void kvm_pmu_software_increment(struct kvm_vcpu
>>> *vcpu, u64 val)
>>>
>>>          /* PMSWINC only applies to ... SW_INC! */
>>>          type = __vcpu_sys_reg(vcpu, PMEVTYPER0_EL0 + i);
>>> -        type &= ARMV8_PMU_EVTYPE_EVENT;
>>> +        type &= kvm_pmu_event_mask(vcpu->kvm);
>>>          if (type != ARMV8_PMUV3_PERFCTR_SW_INCR)
>>>              continue;
>>>
>>> @@ -578,7 +592,7 @@ static void kvm_pmu_create_perf_event(struct
>>> kvm_vcpu *vcpu, u64 select_idx)
>>>      data = __vcpu_sys_reg(vcpu, reg);
>>>
>>>      kvm_pmu_stop_counter(vcpu, pmc);
>>> -    eventsel = data & ARMV8_PMU_EVTYPE_EVENT;
>>> +    eventsel = data & kvm_pmu_event_mask(vcpu->kvm);;
>>>
>>>      /* Software increment event does't need to be backed by a perf
>>> event */
>>>      if (eventsel == ARMV8_PMUV3_PERFCTR_SW_INCR &&
>>> @@ -679,17 +693,68 @@ static void kvm_pmu_update_pmc_chained(struct
>>> kvm_vcpu *vcpu, u64 select_idx)
>>>  void kvm_pmu_set_counter_event_type(struct kvm_vcpu *vcpu, u64 data,
>>>                      u64 select_idx)
>>>  {
>>> -    u64 reg, event_type = data & ARMV8_PMU_EVTYPE_MASK;
>>> +    u64 reg, mask;
>>> +
>>> +    mask  =  ARMV8_PMU_EVTYPE_MASK;
>>> +    mask &= ~ARMV8_PMU_EVTYPE_EVENT;
>>> +    mask |= kvm_pmu_event_mask(vcpu->kvm);
>>>
>>>      reg = (select_idx == ARMV8_PMU_CYCLE_IDX)
>>>            ? PMCCFILTR_EL0 : PMEVTYPER0_EL0 + select_idx;
>>>
>>> -    __vcpu_sys_reg(vcpu, reg) = event_type;
>>> +    __vcpu_sys_reg(vcpu, reg) = data & mask;
>>>
>>>      kvm_pmu_update_pmc_chained(vcpu, select_idx);
>>>      kvm_pmu_create_perf_event(vcpu, select_idx);
>>>  }
>>>
>>> +static int kvm_pmu_probe_pmuver(void)
>>> +{
>>> +    struct perf_event_attr attr = { };
>>> +    struct perf_event *event;
>>> +    struct arm_pmu *pmu;
>>> +    int pmuver = 0xf;
>>> +
>>> +    /*
>>> +     * Create a dummy event that only counts user cycles. As we'll
>>> never
>>> +     * leave thing function with the event being live, it will never
>>> +     * count anything. But it allows us to probe some of the PMU
>>> +     * details. Yes, this is terrible.
>> I fail to understand why we can't directly read ID_DFR0_EL1.PerfMon?
> 
> Because you're missing the big-little nightmare. What you read on the
> current CPU is irrelevant. You want to read the PMU version on the PMU
> that is going to actually be used (and that's the whatever perf decides
> to use at this point).
> 
> That's also the reason why PMU in guests only work in BL systems
> on one class of CPUs only.
> 
> Yes, all CPUs should have the same PMU version. Unfortunately,
> that's not always the case...

Ah OK. I Forgot this...

Thanks

Eric
> 
>         M.

