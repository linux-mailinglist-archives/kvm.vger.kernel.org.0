Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D7C9F264A73
	for <lists+kvm@lfdr.de>; Thu, 10 Sep 2020 18:58:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726899AbgIJQ6J (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 10 Sep 2020 12:58:09 -0400
Received: from smtp-fw-9102.amazon.com ([207.171.184.29]:5068 "EHLO
        smtp-fw-9102.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727771AbgIJQ4L (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 10 Sep 2020 12:56:11 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1599756970; x=1631292970;
  h=subject:to:cc:references:from:message-id:date:
   mime-version:in-reply-to:content-transfer-encoding;
  bh=0/IRcBXXSwhC8hSJ9t/dyZ/Jf7bUnC+DYIzAVZtxAaU=;
  b=DiD8g7VFL794BSm8xVZNCHAUvizior1HquZptQk7/ug63bJl0WkfhzK+
   BJv0K4f1B0dLfqeSBOTIjRPZSUCgiL3S6M0Z9sP8f0E+X0wPAv5FRwaNw
   oRhjnOJEccKPFF7w24i0z5PqA99TM4PjdT2GB7Vh+OERf7ZMmyjdy2CIs
   U=;
X-IronPort-AV: E=Sophos;i="5.76,413,1592870400"; 
   d="scan'208";a="75173259"
Received: from sea32-co-svc-lb4-vlan3.sea.corp.amazon.com (HELO email-inbound-relay-2c-cc689b93.us-west-2.amazon.com) ([10.47.23.38])
  by smtp-border-fw-out-9102.sea19.amazon.com with ESMTP; 10 Sep 2020 16:46:42 +0000
Received: from EX13MTAUWC002.ant.amazon.com (pdx4-ws-svc-p6-lb7-vlan3.pdx.amazon.com [10.170.41.166])
        by email-inbound-relay-2c-cc689b93.us-west-2.amazon.com (Postfix) with ESMTPS id 23DDE120DE7;
        Thu, 10 Sep 2020 16:46:38 +0000 (UTC)
Received: from EX13D20UWC001.ant.amazon.com (10.43.162.244) by
 EX13MTAUWC002.ant.amazon.com (10.43.162.240) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Thu, 10 Sep 2020 16:46:38 +0000
Received: from Alexanders-MacBook-Air.local (10.43.161.85) by
 EX13D20UWC001.ant.amazon.com (10.43.162.244) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Thu, 10 Sep 2020 16:46:35 +0000
Subject: Re: [PATCH v2] KVM: arm64: Allow to limit number of PMU counters
To:     Robin Murphy <robin.murphy@arm.com>, Marc Zyngier <maz@kernel.org>
CC:     Mark Rutland <mark.rutland@arm.com>,
        Andrew Jones <drjones@redhat.com>, <kvm@vger.kernel.org>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Eric Auger <eric.auger@redhat.com>,
        James Morse <james.morse@arm.com>,
        <linux-arm-kernel@lists.infradead.org>,
        <kvmarm@lists.cs.columbia.edu>,
        Julien Thierry <julien.thierry.kdev@gmail.com>
References: <20200908205730.23898-1-graf@amazon.com>
 <9a4279aa9bf0a40bece3930c11c2f7cb@kernel.org>
 <07255b9e-95d3-94d4-cfb0-6408e8bf7818@amazon.com>
 <09d6b66a-e20b-b424-cc4a-480297b544cf@arm.com>
From:   Alexander Graf <graf@amazon.com>
Message-ID: <6cd8e545-f083-7d08-32aa-63e41dd69214@amazon.com>
Date:   Thu, 10 Sep 2020 18:46:32 +0200
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.16; rv:78.0)
 Gecko/20100101 Thunderbird/78.2.1
MIME-Version: 1.0
In-Reply-To: <09d6b66a-e20b-b424-cc4a-480297b544cf@arm.com>
Content-Language: en-US
X-Originating-IP: [10.43.161.85]
X-ClientProxiedBy: EX13D38UWC001.ant.amazon.com (10.43.162.170) To
 EX13D20UWC001.ant.amazon.com (10.43.162.244)
Content-Type: text/plain; charset="windows-1252"; format="flowed"
Content-Transfer-Encoding: quoted-printable
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 10.09.20 17:52, Robin Murphy wrote:
> =

> On 2020-09-10 11:18, Alexander Graf wrote:
>>
>>
>> On 10.09.20 12:06, Marc Zyngier wrote:
>>>
>>> On 2020-09-08 21:57, Alexander Graf wrote:
>>>> We currently pass through the number of PMU counters that we have
>>>> available
>>>> in hardware to guests. So if my host supports 10 concurrently active
>>>> PMU
>>>> counters, my guest will be able to spawn 10 counters as well.
>>>>
>>>> This is undesireable if we also want to use the PMU on the host for
>>>> monitoring. In that case, we want to split the PMU between guest and
>>>> host.
>>>>
>>>> To help that case, let's add a PMU attr that allows us to limit the
>>>> number
>>>> of PMU counters that we expose. With this patch in place, user space
>>>> can
>>>> keep some counters free for host use.
>>>>
>>>> Signed-off-by: Alexander Graf <graf@amazon.com>
>>>>
>>>> ---
>>>>
>>>> Because this patch touches the same code paths as the vPMU filtering
>>>> one
>>>> and the vPMU filtering generalized a few conditions in the attr path,
>>>> I've based it on top. Please let me know if you want it independent
>>>> instead.
>>>>
>>>> v1 -> v2:
>>>>
>>>> =A0 - Add documentation
>>>> =A0 - Add read support
>>>> ---
>>>> =A0Documentation/virt/kvm/devices/vcpu.rst | 25 ++++++++++++++++++++++=
+++
>>>> =A0arch/arm64/include/uapi/asm/kvm.h=A0=A0=A0=A0=A0=A0 |=A0 7 ++++---
>>>> =A0arch/arm64/kvm/pmu-emul.c=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
 | 32
>>>> ++++++++++++++++++++++++++++++++
>>>> =A0arch/arm64/kvm/sys_regs.c=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
 |=A0 5 +++++
>>>> =A0include/kvm/arm_pmu.h=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0 |=A0 1 +
>>>> =A05 files changed, 67 insertions(+), 3 deletions(-)
>>>>
>>>> diff --git a/Documentation/virt/kvm/devices/vcpu.rst
>>>> b/Documentation/virt/kvm/devices/vcpu.rst
>>>> index 203b91e93151..1a1c8d8c8b1d 100644
>>>> --- a/Documentation/virt/kvm/devices/vcpu.rst
>>>> +++ b/Documentation/virt/kvm/devices/vcpu.rst
>>>> @@ -102,6 +102,31 @@ isn't strictly speaking an event. Filtering the
>>>> cycle counter is possible
>>>> =A0using event 0x11 (CPU_CYCLES).
>>>>
>>>>
>>>> +1.4 ATTRIBUTE: KVM_ARM_VCPU_PMU_V3_NUM_EVENTS
>>>> +---------------------------------------------
>>>> +
>>>> +:Parameters: in kvm_device_attr.addr the address for the limit of
>>>> concurrent
>>>> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 events is a pointer to an int
>>>> +
>>>> +:Returns:
>>>> +
>>>> +=A0=A0=A0=A0=A0 =3D=3D=3D=3D=3D=3D=3D=A0 =3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
>>>> +=A0=A0=A0=A0=A0 -ENODEV: PMUv3 not supported
>>>> +=A0=A0=A0=A0=A0 -EBUSY:=A0 PMUv3 already initialized
>>>> +=A0=A0=A0=A0=A0 -EINVAL: Too large number of events
>>>> +=A0=A0=A0=A0=A0 =3D=3D=3D=3D=3D=3D=3D=A0 =3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
>>>> +
>>>> +Reconfigure the limit of concurrent PMU events that the guest can
>>>> monitor.
>>>> +This number is directly exposed as part of the PMCR_EL0 register.
>>>> +
>>>> +On vcpu creation, this attribute is set to the hardware limit of the
>>>> current
>>>> +platform. If you need to determine the hardware limit, you can read
>>>> this
>>>> +attribute before setting it.
>>>> +
>>>> +Restrictions: The default value for this property is the number of
>>>> hardware
>>>> +supported events. Only values that are smaller than the hardware limit
>>>> can
>>>> +be set.
>>>> +
>>>> =A02. GROUP: KVM_ARM_VCPU_TIMER_CTRL
>>>> =A0=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
>>>>
>>>> diff --git a/arch/arm64/include/uapi/asm/kvm.h
>>>> b/arch/arm64/include/uapi/asm/kvm.h
>>>> index 7b1511d6ce44..db025c0b5a40 100644
>>>> --- a/arch/arm64/include/uapi/asm/kvm.h
>>>> +++ b/arch/arm64/include/uapi/asm/kvm.h
>>>> @@ -342,9 +342,10 @@ struct kvm_vcpu_events {
>>>>
>>>> =A0/* Device Control API on vcpu fd */
>>>> =A0#define KVM_ARM_VCPU_PMU_V3_CTRL=A0=A0=A0=A0 0
>>>> -#define=A0=A0 KVM_ARM_VCPU_PMU_V3_IRQ=A0=A0=A0 0
>>>> -#define=A0=A0 KVM_ARM_VCPU_PMU_V3_INIT=A0=A0 1
>>>> -#define=A0=A0 KVM_ARM_VCPU_PMU_V3_FILTER 2
>>>> +#define=A0=A0 KVM_ARM_VCPU_PMU_V3_IRQ=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0 0
>>>> +#define=A0=A0 KVM_ARM_VCPU_PMU_V3_INIT=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 1
>>>> +#define=A0=A0 KVM_ARM_VCPU_PMU_V3_FILTER=A0=A0=A0=A0=A0=A0=A0=A0 2
>>>> +#define=A0=A0 KVM_ARM_VCPU_PMU_V3_NUM_EVENTS=A0=A0=A0=A0 3
>>>> =A0#define KVM_ARM_VCPU_TIMER_CTRL=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0 1
>>>> =A0#define=A0=A0 KVM_ARM_VCPU_TIMER_IRQ_VTIMER=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0 0
>>>> =A0#define=A0=A0 KVM_ARM_VCPU_TIMER_IRQ_PTIMER=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0 1
>>>> diff --git a/arch/arm64/kvm/pmu-emul.c b/arch/arm64/kvm/pmu-emul.c
>>>> index 0458860bade2..c7915b95fec0 100644
>>>> --- a/arch/arm64/kvm/pmu-emul.c
>>>> +++ b/arch/arm64/kvm/pmu-emul.c
>>>> @@ -253,6 +253,8 @@ void kvm_pmu_vcpu_init(struct kvm_vcpu *vcpu)
>>>>
>>>> =A0=A0=A0=A0=A0 for (i =3D 0; i < ARMV8_PMU_MAX_COUNTERS; i++)
>>>> =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 pmu->pmc[i].idx =3D i;
>>>> +
>>>> +=A0=A0=A0=A0 pmu->num_events =3D perf_num_counters() - 1;
>>>> =A0}
>>>>
>>>> =A0/**
>>>> @@ -978,6 +980,25 @@ int kvm_arm_pmu_v3_set_attr(struct kvm_vcpu
>>>> *vcpu, struct kvm_device_attr *attr)
>>>>
>>>> =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 return 0;
>>>> =A0=A0=A0=A0=A0 }
>>>> +=A0=A0=A0=A0 case KVM_ARM_VCPU_PMU_V3_NUM_EVENTS: {
>>>> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 u64 mask =3D ARMV8_PMU_PMCR_N_MA=
SK <<
>>>> ARMV8_PMU_PMCR_N_SHIFT;
>>>> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 int __user *uaddr =3D (int __use=
r *)(long)attr->addr;
>>>> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 u32 num_events;
>>>> +
>>>> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 if (get_user(num_events, uaddr))
>>>> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 return -=
EFAULT;
>>>> +
>>>> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 if (num_events >=3D perf_num_cou=
nters())
>>>> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 return -=
EINVAL;
>>>> +
>>>> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 vcpu->arch.pmu.num_events =3D nu=
m_events;
>>>> +
>>>> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 num_events <<=3D ARMV8_PMU_PMCR_=
N_SHIFT;
>>>> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 __vcpu_sys_reg(vcpu, SYS_PMCR_EL=
0) &=3D ~mask;
>>>> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 __vcpu_sys_reg(vcpu, SYS_PMCR_EL=
0) |=3D num_events;
>>>> +
>>>> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 return 0;
>>>> +=A0=A0=A0=A0 }
>>>> =A0=A0=A0=A0=A0 case KVM_ARM_VCPU_PMU_V3_INIT:
>>>> =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 return kvm_arm_pmu_v3_init(vcp=
u);
>>>> =A0=A0=A0=A0=A0 }
>>>> @@ -1004,6 +1025,16 @@ int kvm_arm_pmu_v3_get_attr(struct kvm_vcpu
>>>> *vcpu, struct kvm_device_attr *attr)
>>>> =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 irq =3D vcpu->arch.pmu.irq_num;
>>>> =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 return put_user(irq, uaddr);
>>>> =A0=A0=A0=A0=A0 }
>>>> +=A0=A0=A0=A0 case KVM_ARM_VCPU_PMU_V3_NUM_EVENTS: {
>>>> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 int __user *uaddr =3D (int __use=
r *)(long)attr->addr;
>>>> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 u32 num_events;
>>>> +
>>>> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 if (!test_bit(KVM_ARM_VCPU_PMU_V=
3, vcpu->arch.features))
>>>> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 return -=
ENODEV;
>>>> +
>>>> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 num_events =3D vcpu->arch.pmu.nu=
m_events;
>>>> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 return put_user(num_events, uadd=
r);
>>>> +=A0=A0=A0=A0 }
>>>> =A0=A0=A0=A0=A0 }
>>>>
>>>> =A0=A0=A0=A0=A0 return -ENXIO;
>>>> @@ -1015,6 +1046,7 @@ int kvm_arm_pmu_v3_has_attr(struct kvm_vcpu
>>>> *vcpu, struct kvm_device_attr *attr)
>>>> =A0=A0=A0=A0=A0 case KVM_ARM_VCPU_PMU_V3_IRQ:
>>>> =A0=A0=A0=A0=A0 case KVM_ARM_VCPU_PMU_V3_INIT:
>>>> =A0=A0=A0=A0=A0 case KVM_ARM_VCPU_PMU_V3_FILTER:
>>>> +=A0=A0=A0=A0 case KVM_ARM_VCPU_PMU_V3_NUM_EVENTS:
>>>> =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 if (kvm_arm_support_pmu_v3() &&
>>>> =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 test_bit(KVM_ARM_V=
CPU_PMU_V3, vcpu->arch.features))
>>>> =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 return=
 0;
>>>> diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
>>>> index 20ab2a7d37ca..d51e39600bbd 100644
>>>> --- a/arch/arm64/kvm/sys_regs.c
>>>> +++ b/arch/arm64/kvm/sys_regs.c
>>>> @@ -672,6 +672,11 @@ static void reset_pmcr(struct kvm_vcpu *vcpu,
>>>> const struct sys_reg_desc *r)
>>>> =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 | (ARMV8_PMU_PMCR_MASK & 0xdecafb=
ad)) &
>>>> (~ARMV8_PMU_PMCR_E);
>>>> =A0=A0=A0=A0=A0 if (!system_supports_32bit_el0())
>>>> =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 val |=3D ARMV8_PMU_PMCR_LC;
>>>> +
>>>> +=A0=A0=A0=A0 /* Override number of event selectors */
>>>> +=A0=A0=A0=A0 val &=3D ~(ARMV8_PMU_PMCR_N_MASK << ARMV8_PMU_PMCR_N_SHI=
FT);
>>>> +=A0=A0=A0=A0 val |=3D (u32)vcpu->arch.pmu.num_events << ARMV8_PMU_PMC=
R_N_SHIFT;
>>>> +
>>>> =A0=A0=A0=A0=A0 __vcpu_sys_reg(vcpu, r->reg) =3D val;
>>>> =A0}
>>>>
>>>> diff --git a/include/kvm/arm_pmu.h b/include/kvm/arm_pmu.h
>>>> index 98cbfe885a53..ea3fc96a37d9 100644
>>>> --- a/include/kvm/arm_pmu.h
>>>> +++ b/include/kvm/arm_pmu.h
>>>> @@ -27,6 +27,7 @@ struct kvm_pmu {
>>>> =A0=A0=A0=A0=A0 bool ready;
>>>> =A0=A0=A0=A0=A0 bool created;
>>>> =A0=A0=A0=A0=A0 bool irq_level;
>>>> +=A0=A0=A0=A0 u8 num_events;
>>>> =A0};
>>>>
>>>> =A0#define kvm_arm_pmu_v3_ready(v)=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0 ((v)->arch.pmu.ready)
>>>
>>> I see several problems with this approach:
>>>
>>> - userspace doesn't really have a good way to retrieve the number of
>>> =A0=A0 counters.
>> It does with v2, because it can then just read the register ;). I agree
>> that it's clunky though.
>>
>>>
>>> - Limiting the number of counters for the guest doesn't mean anything
>>> =A0=A0 when it comes to the actual use of the HW counters, given that we
>>> =A0=A0 don't allocate them ourselves (it's all perf doing the actual wo=
rk).
>>
>> We do cap the number of actively requestable counters via perf by the
>> PMCR.N limit. So in a way, it does mean something.
>>
>>> - If you want to "pin" counters for the host, why don't you just do
>>> =A0=A0 that before starting the guest?
>>
>> You can do that. Imagine I have 10 counters. I pin 4 of them to the
>> host. I still tell my guest that it can use 6. That means perf will then
>> time slice and juggle 10 guest event counters on those remaining 6
>> hardware counters. That juggling heavily reduces accuracy.
>>
>>> I think you need to look at the bigger picture: how to limit the use
>>> of physical counter usage for a given userspace task. This needs
>>> to happen in perf itself, and not in KVM.
>>
>> That's definitely another way to look at it that I agree with.
>>
>> What we really want is to expose the number of counters the guest has
>> available, not the number of counters hardware can support at maximum.
>>
>> So in theory it would be enough to ask perf how many counters it does
>> have free for me to consume without overcommitting. But that would
>> potentially change between multiple invocations of KVM and thus break
>> things like live migration, no?
>>
>> Maybe what we really want is an interface to perf from user space to say
>> "how many counters can you dedicate to me?" and "reserve them for me".
>> Then user space could reserve them as dedicated counters and KVM would
>> just need to either probe for the reservation or get told by user space
>> what to expose via ONE_REG as Drew suggested. It'd be up to user space
>> to ensure that the reservation matches the number of exposed counters =

>> then.
> =

> Note that if the aim is to avoid the guest seeing unexpectedly weird
> behaviour, then it's not just the *number* of counters that matters, but
> the underlying physical allocation too, thanks to the possibility of
> chained events.

Wouldn't ideally guest chaining propagate into host chaining as well? =

I'd have to double check if it does, but in my naive thinking if I =

reserve 4 hardware counters for the guest and the guest ends up using 4 =

hardware counters regardless of their chaining attributes, I'd still be =

able to fit them all?


Alex



Amazon Development Center Germany GmbH
Krausenstr. 38
10117 Berlin
Geschaeftsfuehrung: Christian Schlaeger, Jonathan Weiss
Eingetragen am Amtsgericht Charlottenburg unter HRB 149173 B
Sitz: Berlin
Ust-ID: DE 289 237 879



