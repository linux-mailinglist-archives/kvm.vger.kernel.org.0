Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A551A264916
	for <lists+kvm@lfdr.de>; Thu, 10 Sep 2020 17:53:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731470AbgIJPxb (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 10 Sep 2020 11:53:31 -0400
Received: from foss.arm.com ([217.140.110.172]:38954 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731445AbgIJPw5 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 10 Sep 2020 11:52:57 -0400
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 528C4113E;
        Thu, 10 Sep 2020 08:52:56 -0700 (PDT)
Received: from [10.57.40.122] (unknown [10.57.40.122])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 92A433F68F;
        Thu, 10 Sep 2020 08:52:52 -0700 (PDT)
Subject: Re: [PATCH v2] KVM: arm64: Allow to limit number of PMU counters
To:     Alexander Graf <graf@amazon.com>, Marc Zyngier <maz@kernel.org>
Cc:     Mark Rutland <mark.rutland@arm.com>,
        Andrew Jones <drjones@redhat.com>, kvm@vger.kernel.org,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Eric Auger <eric.auger@redhat.com>,
        James Morse <james.morse@arm.com>,
        linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
        Julien Thierry <julien.thierry.kdev@gmail.com>
References: <20200908205730.23898-1-graf@amazon.com>
 <9a4279aa9bf0a40bece3930c11c2f7cb@kernel.org>
 <07255b9e-95d3-94d4-cfb0-6408e8bf7818@amazon.com>
From:   Robin Murphy <robin.murphy@arm.com>
Message-ID: <09d6b66a-e20b-b424-cc4a-480297b544cf@arm.com>
Date:   Thu, 10 Sep 2020 16:52:46 +0100
User-Agent: Mozilla/5.0 (Windows NT 10.0; rv:68.0) Gecko/20100101
 Thunderbird/68.12.0
MIME-Version: 1.0
In-Reply-To: <07255b9e-95d3-94d4-cfb0-6408e8bf7818@amazon.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Language: en-GB
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 2020-09-10 11:18, Alexander Graf wrote:
> 
> 
> On 10.09.20 12:06, Marc Zyngier wrote:
>>
>> On 2020-09-08 21:57, Alexander Graf wrote:
>>> We currently pass through the number of PMU counters that we have
>>> available
>>> in hardware to guests. So if my host supports 10 concurrently active
>>> PMU
>>> counters, my guest will be able to spawn 10 counters as well.
>>>
>>> This is undesireable if we also want to use the PMU on the host for
>>> monitoring. In that case, we want to split the PMU between guest and
>>> host.
>>>
>>> To help that case, let's add a PMU attr that allows us to limit the
>>> number
>>> of PMU counters that we expose. With this patch in place, user space
>>> can
>>> keep some counters free for host use.
>>>
>>> Signed-off-by: Alexander Graf <graf@amazon.com>
>>>
>>> ---
>>>
>>> Because this patch touches the same code paths as the vPMU filtering
>>> one
>>> and the vPMU filtering generalized a few conditions in the attr path,
>>> I've based it on top. Please let me know if you want it independent
>>> instead.
>>>
>>> v1 -> v2:
>>>
>>>   - Add documentation
>>>   - Add read support
>>> ---
>>>  Documentation/virt/kvm/devices/vcpu.rst | 25 +++++++++++++++++++++++++
>>>  arch/arm64/include/uapi/asm/kvm.h       |  7 ++++---
>>>  arch/arm64/kvm/pmu-emul.c               | 32
>>> ++++++++++++++++++++++++++++++++
>>>  arch/arm64/kvm/sys_regs.c               |  5 +++++
>>>  include/kvm/arm_pmu.h                   |  1 +
>>>  5 files changed, 67 insertions(+), 3 deletions(-)
>>>
>>> diff --git a/Documentation/virt/kvm/devices/vcpu.rst
>>> b/Documentation/virt/kvm/devices/vcpu.rst
>>> index 203b91e93151..1a1c8d8c8b1d 100644
>>> --- a/Documentation/virt/kvm/devices/vcpu.rst
>>> +++ b/Documentation/virt/kvm/devices/vcpu.rst
>>> @@ -102,6 +102,31 @@ isn't strictly speaking an event. Filtering the
>>> cycle counter is possible
>>>  using event 0x11 (CPU_CYCLES).
>>>
>>>
>>> +1.4 ATTRIBUTE: KVM_ARM_VCPU_PMU_V3_NUM_EVENTS
>>> +---------------------------------------------
>>> +
>>> +:Parameters: in kvm_device_attr.addr the address for the limit of
>>> concurrent
>>> +             events is a pointer to an int
>>> +
>>> +:Returns:
>>> +
>>> +      =======  ======================================================
>>> +      -ENODEV: PMUv3 not supported
>>> +      -EBUSY:  PMUv3 already initialized
>>> +      -EINVAL: Too large number of events
>>> +      =======  ======================================================
>>> +
>>> +Reconfigure the limit of concurrent PMU events that the guest can
>>> monitor.
>>> +This number is directly exposed as part of the PMCR_EL0 register.
>>> +
>>> +On vcpu creation, this attribute is set to the hardware limit of the
>>> current
>>> +platform. If you need to determine the hardware limit, you can read
>>> this
>>> +attribute before setting it.
>>> +
>>> +Restrictions: The default value for this property is the number of
>>> hardware
>>> +supported events. Only values that are smaller than the hardware limit
>>> can
>>> +be set.
>>> +
>>>  2. GROUP: KVM_ARM_VCPU_TIMER_CTRL
>>>  =================================
>>>
>>> diff --git a/arch/arm64/include/uapi/asm/kvm.h
>>> b/arch/arm64/include/uapi/asm/kvm.h
>>> index 7b1511d6ce44..db025c0b5a40 100644
>>> --- a/arch/arm64/include/uapi/asm/kvm.h
>>> +++ b/arch/arm64/include/uapi/asm/kvm.h
>>> @@ -342,9 +342,10 @@ struct kvm_vcpu_events {
>>>
>>>  /* Device Control API on vcpu fd */
>>>  #define KVM_ARM_VCPU_PMU_V3_CTRL     0
>>> -#define   KVM_ARM_VCPU_PMU_V3_IRQ    0
>>> -#define   KVM_ARM_VCPU_PMU_V3_INIT   1
>>> -#define   KVM_ARM_VCPU_PMU_V3_FILTER 2
>>> +#define   KVM_ARM_VCPU_PMU_V3_IRQ            0
>>> +#define   KVM_ARM_VCPU_PMU_V3_INIT           1
>>> +#define   KVM_ARM_VCPU_PMU_V3_FILTER         2
>>> +#define   KVM_ARM_VCPU_PMU_V3_NUM_EVENTS     3
>>>  #define KVM_ARM_VCPU_TIMER_CTRL              1
>>>  #define   KVM_ARM_VCPU_TIMER_IRQ_VTIMER              0
>>>  #define   KVM_ARM_VCPU_TIMER_IRQ_PTIMER              1
>>> diff --git a/arch/arm64/kvm/pmu-emul.c b/arch/arm64/kvm/pmu-emul.c
>>> index 0458860bade2..c7915b95fec0 100644
>>> --- a/arch/arm64/kvm/pmu-emul.c
>>> +++ b/arch/arm64/kvm/pmu-emul.c
>>> @@ -253,6 +253,8 @@ void kvm_pmu_vcpu_init(struct kvm_vcpu *vcpu)
>>>
>>>       for (i = 0; i < ARMV8_PMU_MAX_COUNTERS; i++)
>>>               pmu->pmc[i].idx = i;
>>> +
>>> +     pmu->num_events = perf_num_counters() - 1;
>>>  }
>>>
>>>  /**
>>> @@ -978,6 +980,25 @@ int kvm_arm_pmu_v3_set_attr(struct kvm_vcpu
>>> *vcpu, struct kvm_device_attr *attr)
>>>
>>>               return 0;
>>>       }
>>> +     case KVM_ARM_VCPU_PMU_V3_NUM_EVENTS: {
>>> +             u64 mask = ARMV8_PMU_PMCR_N_MASK << 
>>> ARMV8_PMU_PMCR_N_SHIFT;
>>> +             int __user *uaddr = (int __user *)(long)attr->addr;
>>> +             u32 num_events;
>>> +
>>> +             if (get_user(num_events, uaddr))
>>> +                     return -EFAULT;
>>> +
>>> +             if (num_events >= perf_num_counters())
>>> +                     return -EINVAL;
>>> +
>>> +             vcpu->arch.pmu.num_events = num_events;
>>> +
>>> +             num_events <<= ARMV8_PMU_PMCR_N_SHIFT;
>>> +             __vcpu_sys_reg(vcpu, SYS_PMCR_EL0) &= ~mask;
>>> +             __vcpu_sys_reg(vcpu, SYS_PMCR_EL0) |= num_events;
>>> +
>>> +             return 0;
>>> +     }
>>>       case KVM_ARM_VCPU_PMU_V3_INIT:
>>>               return kvm_arm_pmu_v3_init(vcpu);
>>>       }
>>> @@ -1004,6 +1025,16 @@ int kvm_arm_pmu_v3_get_attr(struct kvm_vcpu
>>> *vcpu, struct kvm_device_attr *attr)
>>>               irq = vcpu->arch.pmu.irq_num;
>>>               return put_user(irq, uaddr);
>>>       }
>>> +     case KVM_ARM_VCPU_PMU_V3_NUM_EVENTS: {
>>> +             int __user *uaddr = (int __user *)(long)attr->addr;
>>> +             u32 num_events;
>>> +
>>> +             if (!test_bit(KVM_ARM_VCPU_PMU_V3, vcpu->arch.features))
>>> +                     return -ENODEV;
>>> +
>>> +             num_events = vcpu->arch.pmu.num_events;
>>> +             return put_user(num_events, uaddr);
>>> +     }
>>>       }
>>>
>>>       return -ENXIO;
>>> @@ -1015,6 +1046,7 @@ int kvm_arm_pmu_v3_has_attr(struct kvm_vcpu
>>> *vcpu, struct kvm_device_attr *attr)
>>>       case KVM_ARM_VCPU_PMU_V3_IRQ:
>>>       case KVM_ARM_VCPU_PMU_V3_INIT:
>>>       case KVM_ARM_VCPU_PMU_V3_FILTER:
>>> +     case KVM_ARM_VCPU_PMU_V3_NUM_EVENTS:
>>>               if (kvm_arm_support_pmu_v3() &&
>>>                   test_bit(KVM_ARM_VCPU_PMU_V3, vcpu->arch.features))
>>>                       return 0;
>>> diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
>>> index 20ab2a7d37ca..d51e39600bbd 100644
>>> --- a/arch/arm64/kvm/sys_regs.c
>>> +++ b/arch/arm64/kvm/sys_regs.c
>>> @@ -672,6 +672,11 @@ static void reset_pmcr(struct kvm_vcpu *vcpu,
>>> const struct sys_reg_desc *r)
>>>              | (ARMV8_PMU_PMCR_MASK & 0xdecafbad)) & 
>>> (~ARMV8_PMU_PMCR_E);
>>>       if (!system_supports_32bit_el0())
>>>               val |= ARMV8_PMU_PMCR_LC;
>>> +
>>> +     /* Override number of event selectors */
>>> +     val &= ~(ARMV8_PMU_PMCR_N_MASK << ARMV8_PMU_PMCR_N_SHIFT);
>>> +     val |= (u32)vcpu->arch.pmu.num_events << ARMV8_PMU_PMCR_N_SHIFT;
>>> +
>>>       __vcpu_sys_reg(vcpu, r->reg) = val;
>>>  }
>>>
>>> diff --git a/include/kvm/arm_pmu.h b/include/kvm/arm_pmu.h
>>> index 98cbfe885a53..ea3fc96a37d9 100644
>>> --- a/include/kvm/arm_pmu.h
>>> +++ b/include/kvm/arm_pmu.h
>>> @@ -27,6 +27,7 @@ struct kvm_pmu {
>>>       bool ready;
>>>       bool created;
>>>       bool irq_level;
>>> +     u8 num_events;
>>>  };
>>>
>>>  #define kvm_arm_pmu_v3_ready(v)              ((v)->arch.pmu.ready)
>>
>> I see several problems with this approach:
>>
>> - userspace doesn't really have a good way to retrieve the number of
>>    counters.
> It does with v2, because it can then just read the register ;). I agree 
> that it's clunky though.
> 
>>
>> - Limiting the number of counters for the guest doesn't mean anything
>>    when it comes to the actual use of the HW counters, given that we
>>    don't allocate them ourselves (it's all perf doing the actual work).
> 
> We do cap the number of actively requestable counters via perf by the 
> PMCR.N limit. So in a way, it does mean something.
> 
>> - If you want to "pin" counters for the host, why don't you just do
>>    that before starting the guest?
> 
> You can do that. Imagine I have 10 counters. I pin 4 of them to the 
> host. I still tell my guest that it can use 6. That means perf will then 
> time slice and juggle 10 guest event counters on those remaining 6 
> hardware counters. That juggling heavily reduces accuracy.
> 
>> I think you need to look at the bigger picture: how to limit the use
>> of physical counter usage for a given userspace task. This needs
>> to happen in perf itself, and not in KVM.
> 
> That's definitely another way to look at it that I agree with.
> 
> What we really want is to expose the number of counters the guest has 
> available, not the number of counters hardware can support at maximum.
> 
> So in theory it would be enough to ask perf how many counters it does 
> have free for me to consume without overcommitting. But that would 
> potentially change between multiple invocations of KVM and thus break 
> things like live migration, no?
> 
> Maybe what we really want is an interface to perf from user space to say 
> "how many counters can you dedicate to me?" and "reserve them for me". 
> Then user space could reserve them as dedicated counters and KVM would 
> just need to either probe for the reservation or get told by user space 
> what to expose via ONE_REG as Drew suggested. It'd be up to user space 
> to ensure that the reservation matches the number of exposed counters then.

Note that if the aim is to avoid the guest seeing unexpectedly weird 
behaviour, then it's not just the *number* of counters that matters, but 
the underlying physical allocation too, thanks to the possibility of 
chained events.

Robin.
