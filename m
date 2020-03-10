Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 293CE180638
	for <lists+kvm@lfdr.de>; Tue, 10 Mar 2020 19:27:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726546AbgCJS06 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 10 Mar 2020 14:26:58 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:46810 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726283AbgCJS06 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 10 Mar 2020 14:26:58 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1583864816;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=qSmGN4dMvvK+dw3odF4mALnzrgPrNskbCVyk+qDk+AI=;
        b=HJYtw/OU9LHbdiH1qexQYS5RS03t/1g8J+zu20nGhBrGG5VOmWvYIhcZzmzblSC2/iWLSN
        oUVvYqmM7g8OfDiCKMM1M5fRYPn1zv7dEi7/ed+rpy14c/inYUJhvZRDh4NrxzVR+UWSQy
        MPrSHOQbkKeqv7Nui9hym1OKVL/i3d4=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-270-f5sDQYcOOUyLGKHNr271fA-1; Tue, 10 Mar 2020 14:26:54 -0400
X-MC-Unique: f5sDQYcOOUyLGKHNr271fA-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 70C778024ED;
        Tue, 10 Mar 2020 18:26:52 +0000 (UTC)
Received: from [10.36.117.85] (ovpn-117-85.ams2.redhat.com [10.36.117.85])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id D117010372EA;
        Tue, 10 Mar 2020 18:26:49 +0000 (UTC)
Subject: Re: [PATCH v2 1/2] KVM: arm64: Add PMU event filtering infrastructure
To:     Marc Zyngier <maz@kernel.org>
Cc:     Mark Rutland <mark.rutland@arm.com>, kvm@vger.kernel.org,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        James Morse <james.morse@arm.com>,
        linux-arm-kernel@lists.infradead.org,
        Robin Murphy <robin.murphy@arm.com>,
        kvmarm@lists.cs.columbia.edu,
        Julien Thierry <julien.thierry.kdev@gmail.com>
References: <20200309124837.19908-1-maz@kernel.org>
 <20200309124837.19908-2-maz@kernel.org>
 <70e712fc-6789-2384-c21c-d932b5e1a32f@redhat.com>
 <0027398587e8746a6a7459682330855f@kernel.org>
 <7c9e2e55-95c8-a212-e566-c48f5d3bc417@redhat.com>
 <470c88271ef8c4f92ecf990b7b86658e@kernel.org>
From:   Auger Eric <eric.auger@redhat.com>
Message-ID: <c7f40bad-de16-4862-9936-b01ccc547df2@redhat.com>
Date:   Tue, 10 Mar 2020 19:26:48 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.4.0
MIME-Version: 1.0
In-Reply-To: <470c88271ef8c4f92ecf990b7b86658e@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Content-Transfer-Encoding: quoted-printable
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Marc,

On 3/10/20 7:00 PM, Marc Zyngier wrote:
> On 2020-03-10 17:40, Auger Eric wrote:
>> Hi Marc,
>>
>> On 3/10/20 12:03 PM, Marc Zyngier wrote:
>>> Hi Eric,
>>>
>>> On 2020-03-09 18:05, Auger Eric wrote:
>>>> Hi Marc,
>>>>
>>>> On 3/9/20 1:48 PM, Marc Zyngier wrote:
>>>>> It can be desirable to expose a PMU to a guest, and yet not want th=
e
>>>>> guest to be able to count some of the implemented events (because t=
his
>>>>> would give information on shared resources, for example.
>>>>>
>>>>> For this, let's extend the PMUv3 device API, and offer a way to
>>>>> setup a
>>>>> bitmap of the allowed events (the default being no bitmap, and thus=
 no
>>>>> filtering).
>>>>>
>>>>> Userspace can thus allow/deny ranges of event. The default policy
>>>>> depends on the "polarity" of the first filter setup (default deny
>>>>> if the
>>>>> filter allows events, and default allow if the filter denies events=
).
>>>>> This allows to setup exactly what is allowed for a given guest.
>>>>>
>>>>> Note that although the ioctl is per-vcpu, the map of allowed events=
 is
>>>>> global to the VM (it can be setup from any vcpu until the vcpu PMU =
is
>>>>> initialized).
>>>>>
>>>>> Signed-off-by: Marc Zyngier <maz@kernel.org>
>>>>> ---
>>>>> =C2=A0arch/arm64/include/asm/kvm_host.h |=C2=A0 6 +++
>>>>> =C2=A0arch/arm64/include/uapi/asm/kvm.h | 16 ++++++
>>>>> =C2=A0virt/kvm/arm/arm.c=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 |=C2=A0 2 +
>>>>> =C2=A0virt/kvm/arm/pmu.c=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 | 84
>>>>> +++++++++++++++++++++++++------
>>>>> =C2=A04 files changed, 92 insertions(+), 16 deletions(-)
>>>>>
>>>>> diff --git a/arch/arm64/include/asm/kvm_host.h
>>>>> b/arch/arm64/include/asm/kvm_host.h
>>>>> index 57fd46acd058..8e63c618688d 100644
>>>>> --- a/arch/arm64/include/asm/kvm_host.h
>>>>> +++ b/arch/arm64/include/asm/kvm_host.h
>>>>> @@ -91,6 +91,12 @@ struct kvm_arch {
>>>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 * supported.
>>>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 */
>>>>> =C2=A0=C2=A0=C2=A0=C2=A0 bool return_nisv_io_abort_to_user;
>>>>> +
>>>>> +=C2=A0=C2=A0=C2=A0 /*
>>>>> +=C2=A0=C2=A0=C2=A0=C2=A0 * VM-wide PMU filter, implemented as a bi=
tmap and big enough
>>>>> +=C2=A0=C2=A0=C2=A0=C2=A0 * for up to 65536 events
>>>>> +=C2=A0=C2=A0=C2=A0=C2=A0 */
>>>>> +=C2=A0=C2=A0=C2=A0 unsigned long *pmu_filter;
>>>>> =C2=A0};
>>>>>
>>>>> =C2=A0#define KVM_NR_MEM_OBJS=C2=A0=C2=A0=C2=A0=C2=A0 40
>>>>> diff --git a/arch/arm64/include/uapi/asm/kvm.h
>>>>> b/arch/arm64/include/uapi/asm/kvm.h
>>>>> index ba85bb23f060..7b1511d6ce44 100644
>>>>> --- a/arch/arm64/include/uapi/asm/kvm.h
>>>>> +++ b/arch/arm64/include/uapi/asm/kvm.h
>>>>> @@ -159,6 +159,21 @@ struct kvm_sync_regs {
>>>>> =C2=A0struct kvm_arch_memory_slot {
>>>>> =C2=A0};
>>>>>
>>>>> +/*
>>>>> + * PMU filter structure. Describe a range of events with a particu=
lar
>>>>> + * action. To be used with KVM_ARM_VCPU_PMU_V3_FILTER.
>>>>> + */
>>>>> +struct kvm_pmu_event_filter {
>>>>> +=C2=A0=C2=A0=C2=A0 __u16=C2=A0=C2=A0=C2=A0 base_event;
>>>>> +=C2=A0=C2=A0=C2=A0 __u16=C2=A0=C2=A0=C2=A0 nevents;
>>>>> +
>>>>> +#define KVM_PMU_EVENT_ALLOW=C2=A0=C2=A0=C2=A0 0
>>>>> +#define KVM_PMU_EVENT_DENY=C2=A0=C2=A0=C2=A0 1
>>>>> +
>>>>> +=C2=A0=C2=A0=C2=A0 __u8=C2=A0=C2=A0=C2=A0 action;
>>>>> +=C2=A0=C2=A0=C2=A0 __u8=C2=A0=C2=A0=C2=A0 pad[3];
>>>>> +};
>>>>> +
>>>>> =C2=A0/* for KVM_GET/SET_VCPU_EVENTS */
>>>>> =C2=A0struct kvm_vcpu_events {
>>>>> =C2=A0=C2=A0=C2=A0=C2=A0 struct {
>>>>> @@ -329,6 +344,7 @@ struct kvm_vcpu_events {
>>>>> =C2=A0#define KVM_ARM_VCPU_PMU_V3_CTRL=C2=A0=C2=A0=C2=A0 0
>>>>> =C2=A0#define=C2=A0=C2=A0 KVM_ARM_VCPU_PMU_V3_IRQ=C2=A0=C2=A0=C2=A0=
 0
>>>>> =C2=A0#define=C2=A0=C2=A0 KVM_ARM_VCPU_PMU_V3_INIT=C2=A0=C2=A0=C2=A0=
 1
>>>>> +#define=C2=A0=C2=A0 KVM_ARM_VCPU_PMU_V3_FILTER=C2=A0=C2=A0=C2=A0 2
>>>>> =C2=A0#define KVM_ARM_VCPU_TIMER_CTRL=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0 1
>>>>> =C2=A0#define=C2=A0=C2=A0 KVM_ARM_VCPU_TIMER_IRQ_VTIMER=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 0
>>>>> =C2=A0#define=C2=A0=C2=A0 KVM_ARM_VCPU_TIMER_IRQ_PTIMER=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 1
>>>>> diff --git a/virt/kvm/arm/arm.c b/virt/kvm/arm/arm.c
>>>>> index eda7b624eab8..8d849ac88a44 100644
>>>>> --- a/virt/kvm/arm/arm.c
>>>>> +++ b/virt/kvm/arm/arm.c
>>>>> @@ -164,6 +164,8 @@ void kvm_arch_destroy_vm(struct kvm *kvm)
>>>>> =C2=A0=C2=A0=C2=A0=C2=A0 free_percpu(kvm->arch.last_vcpu_ran);
>>>>> =C2=A0=C2=A0=C2=A0=C2=A0 kvm->arch.last_vcpu_ran =3D NULL;
>>>>>
>>>>> +=C2=A0=C2=A0=C2=A0 bitmap_free(kvm->arch.pmu_filter);
>>>>> +
>>>>> =C2=A0=C2=A0=C2=A0=C2=A0 for (i =3D 0; i < KVM_MAX_VCPUS; ++i) {
>>>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 if (kvm->vcpus[i])=
 {
>>>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0 kvm_vcpu_destroy(kvm->vcpus[i]);
>>>>> diff --git a/virt/kvm/arm/pmu.c b/virt/kvm/arm/pmu.c
>>>>> index f0d0312c0a55..9f0fd0224d5b 100644
>>>>> --- a/virt/kvm/arm/pmu.c
>>>>> +++ b/virt/kvm/arm/pmu.c
>>>>> @@ -579,10 +579,19 @@ static void kvm_pmu_create_perf_event(struct
>>>>> kvm_vcpu *vcpu, u64 select_idx)
>>>>>
>>>>> =C2=A0=C2=A0=C2=A0=C2=A0 kvm_pmu_stop_counter(vcpu, pmc);
>>>>> =C2=A0=C2=A0=C2=A0=C2=A0 eventsel =3D data & ARMV8_PMU_EVTYPE_EVENT=
;
>>>>> +=C2=A0=C2=A0=C2=A0 if (pmc->idx =3D=3D ARMV8_PMU_CYCLE_IDX)
>>>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 eventsel =3D ARMV8_PMUV=
3_PERFCTR_CPU_CYCLES;
>>>> nit:
>>>> =C2=A0=C2=A0=C2=A0=C2=A0if (pmc->idx =3D=3D ARMV8_PMU_CYCLE_IDX)
>>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 eventsel =3D ARMV8_PMUV3_=
PERFCTR_CPU_CYCLES;
>>>> =C2=A0=C2=A0=C2=A0=C2=A0else
>>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 eventsel =3D data & ARMV8=
_PMU_EVTYPE_EVENT;
>>>
>>> You don't like it? ;-)
>> ? eventset set only once instead of 2 times
>=20
> The compiler does the right thing, but sore, I'll change it.
>=20
>>>
>>>>>
>>>>> =C2=A0=C2=A0=C2=A0=C2=A0 /* Software increment event does't need to=
 be backed by a perf
>>>>> event */
>>>> nit: while wer are at it fix the does't typo
>>>>> -=C2=A0=C2=A0=C2=A0 if (eventsel =3D=3D ARMV8_PMUV3_PERFCTR_SW_INCR=
 &&
>>>>> -=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 pmc->idx !=3D ARMV8_PMU=
_CYCLE_IDX)
>>>>> +=C2=A0=C2=A0=C2=A0 if (eventsel =3D=3D ARMV8_PMUV3_PERFCTR_SW_INCR=
)
>>>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 return;
>>>>> +
>>>>> +=C2=A0=C2=A0=C2=A0 /*
>>>>> +=C2=A0=C2=A0=C2=A0=C2=A0 * If we have a filter in place and that t=
he event isn't
>>>>> allowed, do
>>>>> +=C2=A0=C2=A0=C2=A0=C2=A0 * not install a perf event either.
>>>>> +=C2=A0=C2=A0=C2=A0=C2=A0 */
>>>>> +=C2=A0=C2=A0=C2=A0 if (vcpu->kvm->arch.pmu_filter &&
>>>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 !test_bit(eventsel, vcp=
u->kvm->arch.pmu_filter))
>>>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 return;
>>>>>
>>>>> =C2=A0=C2=A0=C2=A0=C2=A0 memset(&attr, 0, sizeof(struct perf_event_=
attr));
>>>>> @@ -594,8 +603,7 @@ static void kvm_pmu_create_perf_event(struct
>>>>> kvm_vcpu *vcpu, u64 select_idx)
>>>>> =C2=A0=C2=A0=C2=A0=C2=A0 attr.exclude_kernel =3D data & ARMV8_PMU_E=
XCLUDE_EL1 ? 1 : 0;
>>>>> =C2=A0=C2=A0=C2=A0=C2=A0 attr.exclude_hv =3D 1; /* Don't count EL2 =
events */
>>>>> =C2=A0=C2=A0=C2=A0=C2=A0 attr.exclude_host =3D 1; /* Don't count ho=
st events */
>>>>> -=C2=A0=C2=A0=C2=A0 attr.config =3D (pmc->idx =3D=3D ARMV8_PMU_CYCL=
E_IDX) ?
>>>>> -=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 ARMV8_PMUV3_PERFCTR_CPU=
_CYCLES : eventsel;
>>>>> +=C2=A0=C2=A0=C2=A0 attr.config =3D eventsel;
>>>> So in that case the guest counter will not increment but the guest d=
oes
>>>> not know the counter is not implemented. Can't this lead to bad user
>>>> experience. Shouldn't this disablement be reflected in PMCEID0/1 reg=
s?
>>>
>>> The whole point is that we want to keep things hidden from the guest.
>>> Also, PMCEID{0,1} only describe a small set of events (the architecte=
d
>>> common events), and not the whole range of microarchitectural events
>>> that the CPU implements.
>>
>> I am still not totally convinced. Things are not totally hidden to the
>> guest as the counter does not increment, right? So a guest may try to
>> use as it is advertised in PMCEID0/1 but not get the expected results
>> leading to potential support request. I agree not all the events are
>> described there but your API also allows to filter out some of the one=
s
>> that are advertised.
>=20
> I think we're at odds when it comes to the goal of this series. If you
> read the CPU TRM, you will find that event X is implemented. You look
> at PMCEIDx, and you find it is not. You still get a support request! ;-=
)
Yep that's a weird situation indeed, I haven't thought about the TRM.
>=20
> Dropping events from these registers is totally trivial, but I'm not
> sure this will reduce the surprise effect. It doesn't hurt anyway, so
> I'll implement that.
Up to you. Or at least you can document it in the commit msg.

Thanks

Eric

>=20
>>>
>>>>>
>>>>> =C2=A0=C2=A0=C2=A0=C2=A0 counter =3D kvm_pmu_get_pair_counter_value=
(vcpu, pmc);
>>>>>
>>>>> @@ -735,15 +743,6 @@ int kvm_arm_pmu_v3_enable(struct kvm_vcpu *vcp=
u)
>>>>>
>>>>> =C2=A0static int kvm_arm_pmu_v3_init(struct kvm_vcpu *vcpu)
>>>>> =C2=A0{
>>>>> -=C2=A0=C2=A0=C2=A0 if (!kvm_arm_support_pmu_v3())
>>>>> -=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 return -ENODEV;
>>>>> -
>>>>> -=C2=A0=C2=A0=C2=A0 if (!test_bit(KVM_ARM_VCPU_PMU_V3, vcpu->arch.f=
eatures))
>>>>> -=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 return -ENXIO;
>>>>> -
>>>>> -=C2=A0=C2=A0=C2=A0 if (vcpu->arch.pmu.created)
>>>>> -=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 return -EBUSY;
>>>>> -
>>>>> =C2=A0=C2=A0=C2=A0=C2=A0 if (irqchip_in_kernel(vcpu->kvm)) {
>>>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 int ret;
>>>>>
>>>>> @@ -794,8 +793,19 @@ static bool pmu_irq_is_valid(struct kvm *kvm,
>>>>> int irq)
>>>>> =C2=A0=C2=A0=C2=A0=C2=A0 return true;
>>>>> =C2=A0}
>>>>>
>>>>> +#define NR_EVENTS=C2=A0=C2=A0=C2=A0 (ARMV8_PMU_EVTYPE_EVENT + 1)
>>>>> +
>>>>> =C2=A0int kvm_arm_pmu_v3_set_attr(struct kvm_vcpu *vcpu, struct
>>>>> kvm_device_attr *attr)
>>>>> =C2=A0{
>>>>> +=C2=A0=C2=A0=C2=A0 if (!kvm_arm_support_pmu_v3())
>>>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 return -ENODEV;
>>>>> +
>>>>> +=C2=A0=C2=A0=C2=A0 if (!test_bit(KVM_ARM_VCPU_PMU_V3, vcpu->arch.f=
eatures))
>>>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 return -ENODEV;
>>>> I see you changed -ENXIO into -ENODEV. wanted?
>>>
>>> Probably not... but see below.
>>>
>>>>> +
>>>>> +=C2=A0=C2=A0=C2=A0 if (vcpu->arch.pmu.created)
>>>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 return -EBUSY;
>>>>> +
>>>>> =C2=A0=C2=A0=C2=A0=C2=A0 switch (attr->attr) {
>>>>> =C2=A0=C2=A0=C2=A0=C2=A0 case KVM_ARM_VCPU_PMU_V3_IRQ: {
>>>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 int __user *uaddr =
=3D (int __user *)(long)attr->addr;
>>>>> @@ -804,9 +814,6 @@ int kvm_arm_pmu_v3_set_attr(struct kvm_vcpu
>>>>> *vcpu, struct kvm_device_attr *attr)
>>>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 if (!irqchip_in_ke=
rnel(vcpu->kvm))
>>>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0 return -EINVAL;
>>>>>
>>>>> -=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 if (!test_bit(KVM_ARM_V=
CPU_PMU_V3, vcpu->arch.features))
>>>>> -=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
 return -ENODEV;
>>>>> -
>>>
>>> Here's why. I wonder if we already have a problem with the consistenc=
y
>>> of the
>>> error codes returned to userspace.
>> OK. Then you may document it in the commit message?
>=20
> I still need to work out whether we actually have an issue on that.
>=20
> [...]
>=20
>>>> not related to this patch but shouldn't we advertise this only with
>>>> in-kernel irqchip?
>>>
>>> We do support the PMU without the in-kernel chip, unfortunately... Ye=
s,
>>> supporting this feature was a big mistake.
>> But I see in kvm_arm_pmu_v3_set_attr:
>> case KVM_ARM_VCPU_PMU_V3_IRQ:
>> ../..
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0 if (!irqchip_in_kernel(vcpu->kvm))
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 return=
 -EINVAL;
>=20
> Ah, I see what you mean. Yes, we probably shouldn't report that the PMU
> IRQ attribute is supported when we don't have an in-kernel irqchip.
>=20
> Thanks,
>=20
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 M.

