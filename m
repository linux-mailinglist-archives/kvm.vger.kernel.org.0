Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 66A331805BA
	for <lists+kvm@lfdr.de>; Tue, 10 Mar 2020 19:00:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726290AbgCJSA4 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 10 Mar 2020 14:00:56 -0400
Received: from mail.kernel.org ([198.145.29.99]:50584 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726271AbgCJSAz (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 10 Mar 2020 14:00:55 -0400
Received: from disco-boy.misterjones.org (disco-boy.misterjones.org [51.254.78.96])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8F2C9205C9;
        Tue, 10 Mar 2020 18:00:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1583863254;
        bh=6sC5CXMZeZmFyPY4N3hUbTKkfIifAKMmggTGMEoEi7w=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=DJyvE1xtCnbRh7r668b7VkOHRUIsGfKDlP3v3NGffMrvqldyS1hDKGTXOdICt2Rgg
         4z/G+EmjJpbBXxZRvD0ZfhiI5fDBWuejP+KwW7P3xgxm7akx5/ubjOXDOGCGhnDcbC
         0Oo83kiBMe3Tg+Vm6lkkM/aBH78dsXh15ZfdkUwM=
Received: from disco-boy.misterjones.org ([51.254.78.96] helo=www.loen.fr)
        by disco-boy.misterjones.org with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.92)
        (envelope-from <maz@kernel.org>)
        id 1jBjBU-00Bh1d-TO; Tue, 10 Mar 2020 18:00:53 +0000
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8;
 format=flowed
Content-Transfer-Encoding: 8bit
Date:   Tue, 10 Mar 2020 18:00:52 +0000
From:   Marc Zyngier <maz@kernel.org>
To:     Auger Eric <eric.auger@redhat.com>
Cc:     Mark Rutland <mark.rutland@arm.com>, kvm@vger.kernel.org,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        James Morse <james.morse@arm.com>,
        linux-arm-kernel@lists.infradead.org,
        Robin Murphy <robin.murphy@arm.com>,
        kvmarm@lists.cs.columbia.edu,
        Julien Thierry <julien.thierry.kdev@gmail.com>
Subject: Re: [PATCH v2 1/2] KVM: arm64: Add PMU event filtering infrastructure
In-Reply-To: <7c9e2e55-95c8-a212-e566-c48f5d3bc417@redhat.com>
References: <20200309124837.19908-1-maz@kernel.org>
 <20200309124837.19908-2-maz@kernel.org>
 <70e712fc-6789-2384-c21c-d932b5e1a32f@redhat.com>
 <0027398587e8746a6a7459682330855f@kernel.org>
 <7c9e2e55-95c8-a212-e566-c48f5d3bc417@redhat.com>
Message-ID: <470c88271ef8c4f92ecf990b7b86658e@kernel.org>
X-Sender: maz@kernel.org
User-Agent: Roundcube Webmail/1.3.10
X-SA-Exim-Connect-IP: 51.254.78.96
X-SA-Exim-Rcpt-To: eric.auger@redhat.com, mark.rutland@arm.com, kvm@vger.kernel.org, suzuki.poulose@arm.com, james.morse@arm.com, linux-arm-kernel@lists.infradead.org, robin.murphy@arm.com, kvmarm@lists.cs.columbia.edu, julien.thierry.kdev@gmail.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 2020-03-10 17:40, Auger Eric wrote:
> Hi Marc,
> 
> On 3/10/20 12:03 PM, Marc Zyngier wrote:
>> Hi Eric,
>> 
>> On 2020-03-09 18:05, Auger Eric wrote:
>>> Hi Marc,
>>> 
>>> On 3/9/20 1:48 PM, Marc Zyngier wrote:
>>>> It can be desirable to expose a PMU to a guest, and yet not want the
>>>> guest to be able to count some of the implemented events (because 
>>>> this
>>>> would give information on shared resources, for example.
>>>> 
>>>> For this, let's extend the PMUv3 device API, and offer a way to 
>>>> setup a
>>>> bitmap of the allowed events (the default being no bitmap, and thus 
>>>> no
>>>> filtering).
>>>> 
>>>> Userspace can thus allow/deny ranges of event. The default policy
>>>> depends on the "polarity" of the first filter setup (default deny if 
>>>> the
>>>> filter allows events, and default allow if the filter denies 
>>>> events).
>>>> This allows to setup exactly what is allowed for a given guest.
>>>> 
>>>> Note that although the ioctl is per-vcpu, the map of allowed events 
>>>> is
>>>> global to the VM (it can be setup from any vcpu until the vcpu PMU 
>>>> is
>>>> initialized).
>>>> 
>>>> Signed-off-by: Marc Zyngier <maz@kernel.org>
>>>> ---
>>>>  arch/arm64/include/asm/kvm_host.h |  6 +++
>>>>  arch/arm64/include/uapi/asm/kvm.h | 16 ++++++
>>>>  virt/kvm/arm/arm.c                |  2 +
>>>>  virt/kvm/arm/pmu.c                | 84 
>>>> +++++++++++++++++++++++++------
>>>>  4 files changed, 92 insertions(+), 16 deletions(-)
>>>> 
>>>> diff --git a/arch/arm64/include/asm/kvm_host.h
>>>> b/arch/arm64/include/asm/kvm_host.h
>>>> index 57fd46acd058..8e63c618688d 100644
>>>> --- a/arch/arm64/include/asm/kvm_host.h
>>>> +++ b/arch/arm64/include/asm/kvm_host.h
>>>> @@ -91,6 +91,12 @@ struct kvm_arch {
>>>>       * supported.
>>>>       */
>>>>      bool return_nisv_io_abort_to_user;
>>>> +
>>>> +    /*
>>>> +     * VM-wide PMU filter, implemented as a bitmap and big enough
>>>> +     * for up to 65536 events
>>>> +     */
>>>> +    unsigned long *pmu_filter;
>>>>  };
>>>> 
>>>>  #define KVM_NR_MEM_OBJS     40
>>>> diff --git a/arch/arm64/include/uapi/asm/kvm.h
>>>> b/arch/arm64/include/uapi/asm/kvm.h
>>>> index ba85bb23f060..7b1511d6ce44 100644
>>>> --- a/arch/arm64/include/uapi/asm/kvm.h
>>>> +++ b/arch/arm64/include/uapi/asm/kvm.h
>>>> @@ -159,6 +159,21 @@ struct kvm_sync_regs {
>>>>  struct kvm_arch_memory_slot {
>>>>  };
>>>> 
>>>> +/*
>>>> + * PMU filter structure. Describe a range of events with a 
>>>> particular
>>>> + * action. To be used with KVM_ARM_VCPU_PMU_V3_FILTER.
>>>> + */
>>>> +struct kvm_pmu_event_filter {
>>>> +    __u16    base_event;
>>>> +    __u16    nevents;
>>>> +
>>>> +#define KVM_PMU_EVENT_ALLOW    0
>>>> +#define KVM_PMU_EVENT_DENY    1
>>>> +
>>>> +    __u8    action;
>>>> +    __u8    pad[3];
>>>> +};
>>>> +
>>>>  /* for KVM_GET/SET_VCPU_EVENTS */
>>>>  struct kvm_vcpu_events {
>>>>      struct {
>>>> @@ -329,6 +344,7 @@ struct kvm_vcpu_events {
>>>>  #define KVM_ARM_VCPU_PMU_V3_CTRL    0
>>>>  #define   KVM_ARM_VCPU_PMU_V3_IRQ    0
>>>>  #define   KVM_ARM_VCPU_PMU_V3_INIT    1
>>>> +#define   KVM_ARM_VCPU_PMU_V3_FILTER    2
>>>>  #define KVM_ARM_VCPU_TIMER_CTRL        1
>>>>  #define   KVM_ARM_VCPU_TIMER_IRQ_VTIMER        0
>>>>  #define   KVM_ARM_VCPU_TIMER_IRQ_PTIMER        1
>>>> diff --git a/virt/kvm/arm/arm.c b/virt/kvm/arm/arm.c
>>>> index eda7b624eab8..8d849ac88a44 100644
>>>> --- a/virt/kvm/arm/arm.c
>>>> +++ b/virt/kvm/arm/arm.c
>>>> @@ -164,6 +164,8 @@ void kvm_arch_destroy_vm(struct kvm *kvm)
>>>>      free_percpu(kvm->arch.last_vcpu_ran);
>>>>      kvm->arch.last_vcpu_ran = NULL;
>>>> 
>>>> +    bitmap_free(kvm->arch.pmu_filter);
>>>> +
>>>>      for (i = 0; i < KVM_MAX_VCPUS; ++i) {
>>>>          if (kvm->vcpus[i]) {
>>>>              kvm_vcpu_destroy(kvm->vcpus[i]);
>>>> diff --git a/virt/kvm/arm/pmu.c b/virt/kvm/arm/pmu.c
>>>> index f0d0312c0a55..9f0fd0224d5b 100644
>>>> --- a/virt/kvm/arm/pmu.c
>>>> +++ b/virt/kvm/arm/pmu.c
>>>> @@ -579,10 +579,19 @@ static void kvm_pmu_create_perf_event(struct
>>>> kvm_vcpu *vcpu, u64 select_idx)
>>>> 
>>>>      kvm_pmu_stop_counter(vcpu, pmc);
>>>>      eventsel = data & ARMV8_PMU_EVTYPE_EVENT;
>>>> +    if (pmc->idx == ARMV8_PMU_CYCLE_IDX)
>>>> +        eventsel = ARMV8_PMUV3_PERFCTR_CPU_CYCLES;
>>> nit:
>>>     if (pmc->idx == ARMV8_PMU_CYCLE_IDX)
>>>         eventsel = ARMV8_PMUV3_PERFCTR_CPU_CYCLES;
>>>     else
>>>         eventsel = data & ARMV8_PMU_EVTYPE_EVENT;
>> 
>> You don't like it? ;-)
> ? eventset set only once instead of 2 times

The compiler does the right thing, but sore, I'll change it.

>> 
>>>> 
>>>>      /* Software increment event does't need to be backed by a perf
>>>> event */
>>> nit: while wer are at it fix the does't typo
>>>> -    if (eventsel == ARMV8_PMUV3_PERFCTR_SW_INCR &&
>>>> -        pmc->idx != ARMV8_PMU_CYCLE_IDX)
>>>> +    if (eventsel == ARMV8_PMUV3_PERFCTR_SW_INCR)
>>>> +        return;
>>>> +
>>>> +    /*
>>>> +     * If we have a filter in place and that the event isn't
>>>> allowed, do
>>>> +     * not install a perf event either.
>>>> +     */
>>>> +    if (vcpu->kvm->arch.pmu_filter &&
>>>> +        !test_bit(eventsel, vcpu->kvm->arch.pmu_filter))
>>>>          return;
>>>> 
>>>>      memset(&attr, 0, sizeof(struct perf_event_attr));
>>>> @@ -594,8 +603,7 @@ static void kvm_pmu_create_perf_event(struct
>>>> kvm_vcpu *vcpu, u64 select_idx)
>>>>      attr.exclude_kernel = data & ARMV8_PMU_EXCLUDE_EL1 ? 1 : 0;
>>>>      attr.exclude_hv = 1; /* Don't count EL2 events */
>>>>      attr.exclude_host = 1; /* Don't count host events */
>>>> -    attr.config = (pmc->idx == ARMV8_PMU_CYCLE_IDX) ?
>>>> -        ARMV8_PMUV3_PERFCTR_CPU_CYCLES : eventsel;
>>>> +    attr.config = eventsel;
>>> So in that case the guest counter will not increment but the guest 
>>> does
>>> not know the counter is not implemented. Can't this lead to bad user
>>> experience. Shouldn't this disablement be reflected in PMCEID0/1 
>>> regs?
>> 
>> The whole point is that we want to keep things hidden from the guest.
>> Also, PMCEID{0,1} only describe a small set of events (the architected
>> common events), and not the whole range of microarchitectural events
>> that the CPU implements.
> 
> I am still not totally convinced. Things are not totally hidden to the
> guest as the counter does not increment, right? So a guest may try to
> use as it is advertised in PMCEID0/1 but not get the expected results
> leading to potential support request. I agree not all the events are
> described there but your API also allows to filter out some of the ones
> that are advertised.

I think we're at odds when it comes to the goal of this series. If you
read the CPU TRM, you will find that event X is implemented. You look
at PMCEIDx, and you find it is not. You still get a support request! ;-)

Dropping events from these registers is totally trivial, but I'm not
sure this will reduce the surprise effect. It doesn't hurt anyway, so
I'll implement that.

>> 
>>>> 
>>>>      counter = kvm_pmu_get_pair_counter_value(vcpu, pmc);
>>>> 
>>>> @@ -735,15 +743,6 @@ int kvm_arm_pmu_v3_enable(struct kvm_vcpu 
>>>> *vcpu)
>>>> 
>>>>  static int kvm_arm_pmu_v3_init(struct kvm_vcpu *vcpu)
>>>>  {
>>>> -    if (!kvm_arm_support_pmu_v3())
>>>> -        return -ENODEV;
>>>> -
>>>> -    if (!test_bit(KVM_ARM_VCPU_PMU_V3, vcpu->arch.features))
>>>> -        return -ENXIO;
>>>> -
>>>> -    if (vcpu->arch.pmu.created)
>>>> -        return -EBUSY;
>>>> -
>>>>      if (irqchip_in_kernel(vcpu->kvm)) {
>>>>          int ret;
>>>> 
>>>> @@ -794,8 +793,19 @@ static bool pmu_irq_is_valid(struct kvm *kvm,
>>>> int irq)
>>>>      return true;
>>>>  }
>>>> 
>>>> +#define NR_EVENTS    (ARMV8_PMU_EVTYPE_EVENT + 1)
>>>> +
>>>>  int kvm_arm_pmu_v3_set_attr(struct kvm_vcpu *vcpu, struct
>>>> kvm_device_attr *attr)
>>>>  {
>>>> +    if (!kvm_arm_support_pmu_v3())
>>>> +        return -ENODEV;
>>>> +
>>>> +    if (!test_bit(KVM_ARM_VCPU_PMU_V3, vcpu->arch.features))
>>>> +        return -ENODEV;
>>> I see you changed -ENXIO into -ENODEV. wanted?
>> 
>> Probably not... but see below.
>> 
>>>> +
>>>> +    if (vcpu->arch.pmu.created)
>>>> +        return -EBUSY;
>>>> +
>>>>      switch (attr->attr) {
>>>>      case KVM_ARM_VCPU_PMU_V3_IRQ: {
>>>>          int __user *uaddr = (int __user *)(long)attr->addr;
>>>> @@ -804,9 +814,6 @@ int kvm_arm_pmu_v3_set_attr(struct kvm_vcpu
>>>> *vcpu, struct kvm_device_attr *attr)
>>>>          if (!irqchip_in_kernel(vcpu->kvm))
>>>>              return -EINVAL;
>>>> 
>>>> -        if (!test_bit(KVM_ARM_VCPU_PMU_V3, vcpu->arch.features))
>>>> -            return -ENODEV;
>>>> -
>> 
>> Here's why. I wonder if we already have a problem with the consistency
>> of the
>> error codes returned to userspace.
> OK. Then you may document it in the commit message?

I still need to work out whether we actually have an issue on that.

[...]

>>> not related to this patch but shouldn't we advertise this only with
>>> in-kernel irqchip?
>> 
>> We do support the PMU without the in-kernel chip, unfortunately... 
>> Yes,
>> supporting this feature was a big mistake.
> But I see in kvm_arm_pmu_v3_set_attr:
> case KVM_ARM_VCPU_PMU_V3_IRQ:
> ../..
>                 if (!irqchip_in_kernel(vcpu->kvm))
>                         return -EINVAL;

Ah, I see what you mean. Yes, we probably shouldn't report that the PMU
IRQ attribute is supported when we don't have an in-kernel irqchip.

Thanks,

         M.
-- 
Jazz is not dead. It just smells funny...
