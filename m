Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EFE4B9AE2F
	for <lists+kvm@lfdr.de>; Fri, 23 Aug 2019 13:35:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2392725AbfHWLd0 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 23 Aug 2019 07:33:26 -0400
Received: from smtp-fw-4101.amazon.com ([72.21.198.25]:65005 "EHLO
        smtp-fw-4101.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2392704AbfHWLd0 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 23 Aug 2019 07:33:26 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1566560003; x=1598096003;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=81CTaPZaKOLwXU85VXfYe0tONlmkxyvkCHYS85SolVs=;
  b=Ojzxm4utxHAJbhBi/FGe4lOzkxUglpSuKzeOeBVshOrM/NCO/mO93vCm
   KT+x1SdEgWf4HVtyockHgOEteokr+lCwxWUgGSwwaiUZoOCwIEdekVvow
   u2q4132+c2t5lY1YHb9R4kJQg6MPQ2a6wf7QsAp43UTdgbFs9M+ZErAUL
   E=;
X-IronPort-AV: E=Sophos;i="5.64,421,1559520000"; 
   d="scan'208";a="780986641"
Received: from iad6-co-svc-p1-lb1-vlan3.amazon.com (HELO email-inbound-relay-2a-538b0bfb.us-west-2.amazon.com) ([10.124.125.6])
  by smtp-border-fw-out-4101.iad4.amazon.com with ESMTP; 23 Aug 2019 11:33:20 +0000
Received: from EX13MTAUWC001.ant.amazon.com (pdx4-ws-svc-p6-lb7-vlan3.pdx.amazon.com [10.170.41.166])
        by email-inbound-relay-2a-538b0bfb.us-west-2.amazon.com (Postfix) with ESMTPS id 64E64A22BE;
        Fri, 23 Aug 2019 11:33:19 +0000 (UTC)
Received: from EX13D20UWC001.ant.amazon.com (10.43.162.244) by
 EX13MTAUWC001.ant.amazon.com (10.43.162.135) with Microsoft SMTP Server (TLS)
 id 15.0.1367.3; Fri, 23 Aug 2019 11:33:18 +0000
Received: from EX13D20UWC001.ant.amazon.com (10.43.162.244) by
 EX13D20UWC001.ant.amazon.com (10.43.162.244) with Microsoft SMTP Server (TLS)
 id 15.0.1367.3; Fri, 23 Aug 2019 11:33:18 +0000
Received: from EX13D20UWC001.ant.amazon.com ([10.43.162.244]) by
 EX13D20UWC001.ant.amazon.com ([10.43.162.244]) with mapi id 15.00.1367.000;
 Fri, 23 Aug 2019 11:33:18 +0000
From:   "Graf (AWS), Alexander" <graf@amazon.com>
To:     Anup Patel <anup@brainfault.org>
CC:     Anup Patel <Anup.Patel@wdc.com>,
        Palmer Dabbelt <palmer@sifive.com>,
        "Paul Walmsley" <paul.walmsley@sifive.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Radim K <rkrcmar@redhat.com>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Atish Patra <Atish.Patra@wdc.com>,
        Alistair Francis <Alistair.Francis@wdc.com>,
        Damien Le Moal <Damien.LeMoal@wdc.com>,
        Christoph Hellwig <hch@infradead.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-riscv@lists.infradead.org" <linux-riscv@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v5 15/20] RISC-V: KVM: Add timer functionality
Thread-Topic: [PATCH v5 15/20] RISC-V: KVM: Add timer functionality
Thread-Index: AQHVWYfCZ6HwGxWfCka5TRHKqhp666cIkgaAgAAICQ0=
Date:   Fri, 23 Aug 2019 11:33:18 +0000
Message-ID: <CA3A6A8A-0227-4B92-B892-86A0C7CA369E@amazon.com>
References: <20190822084131.114764-1-anup.patel@wdc.com>
 <20190822084131.114764-16-anup.patel@wdc.com>
 <09d74212-4fa3-d64c-5a63-d556e955b88c@amazon.com>,<CAAhSdy36q5-x8cXM=M5S3cnE2nvCMhcsfuQayVt7jahd58HWFw@mail.gmail.com>
In-Reply-To: <CAAhSdy36q5-x8cXM=M5S3cnE2nvCMhcsfuQayVt7jahd58HWFw@mail.gmail.com>
Accept-Language: en-US
Content-Language: de-DE
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-exchange-transport-fromentityheader: Hosted
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



> Am 23.08.2019 um 13:05 schrieb Anup Patel <anup@brainfault.org>:
>=20
>> On Fri, Aug 23, 2019 at 1:23 PM Alexander Graf <graf@amazon.com> wrote:
>>=20
>>> On 22.08.19 10:46, Anup Patel wrote:
>>> From: Atish Patra <atish.patra@wdc.com>
>>>=20
>>> The RISC-V hypervisor specification doesn't have any virtual timer
>>> feature.
>>>=20
>>> Due to this, the guest VCPU timer will be programmed via SBI calls.
>>> The host will use a separate hrtimer event for each guest VCPU to
>>> provide timer functionality. We inject a virtual timer interrupt to
>>> the guest VCPU whenever the guest VCPU hrtimer event expires.
>>>=20
>>> The following features are not supported yet and will be added in
>>> future:
>>> 1. A time offset to adjust guest time from host time
>>> 2. A saved next event in guest vcpu for vm migration
>>=20
>> Implementing these 2 bits right now should be trivial. Why wait?
>=20
> We were waiting for HTIMEDELTA CSR to be merged so we
> deferred this items.
>=20
>>=20
>>>=20
>>> Signed-off-by: Atish Patra <atish.patra@wdc.com>
>>> Signed-off-by: Anup Patel <anup.patel@wdc.com>
>>> Acked-by: Paolo Bonzini <pbonzini@redhat.com>
>>> Reviewed-by: Paolo Bonzini <pbonzini@redhat.com>
>>> ---
>>>  arch/riscv/include/asm/kvm_host.h       |   4 +
>>>  arch/riscv/include/asm/kvm_vcpu_timer.h |  32 +++++++
>>>  arch/riscv/kvm/Makefile                 |   2 +-
>>>  arch/riscv/kvm/vcpu.c                   |   6 ++
>>>  arch/riscv/kvm/vcpu_timer.c             | 106 ++++++++++++++++++++++++
>>>  drivers/clocksource/timer-riscv.c       |   8 ++
>>>  include/clocksource/timer-riscv.h       |  16 ++++
>>>  7 files changed, 173 insertions(+), 1 deletion(-)
>>>  create mode 100644 arch/riscv/include/asm/kvm_vcpu_timer.h
>>>  create mode 100644 arch/riscv/kvm/vcpu_timer.c
>>>  create mode 100644 include/clocksource/timer-riscv.h
>>>=20
>>> diff --git a/arch/riscv/include/asm/kvm_host.h b/arch/riscv/include/asm=
/kvm_host.h
>>> index ab33e59a3d88..d2a2e45eefc0 100644
>>> --- a/arch/riscv/include/asm/kvm_host.h
>>> +++ b/arch/riscv/include/asm/kvm_host.h
>>> @@ -12,6 +12,7 @@
>>>  #include <linux/types.h>
>>>  #include <linux/kvm.h>
>>>  #include <linux/kvm_types.h>
>>> +#include <asm/kvm_vcpu_timer.h>
>>>=20
>>>  #ifdef CONFIG_64BIT
>>>  #define KVM_MAX_VCPUS                       (1U << 16)
>>> @@ -167,6 +168,9 @@ struct kvm_vcpu_arch {
>>>      unsigned long irqs_pending;
>>>      unsigned long irqs_pending_mask;
>>>=20
>>> +     /* VCPU Timer */
>>> +     struct kvm_vcpu_timer timer;
>>> +
>>>      /* MMIO instruction details */
>>>      struct kvm_mmio_decode mmio_decode;
>>>=20
>>> diff --git a/arch/riscv/include/asm/kvm_vcpu_timer.h b/arch/riscv/inclu=
de/asm/kvm_vcpu_timer.h
>>> new file mode 100644
>>> index 000000000000..df67ea86988e
>>> --- /dev/null
>>> +++ b/arch/riscv/include/asm/kvm_vcpu_timer.h
>>> @@ -0,0 +1,32 @@
>>> +/* SPDX-License-Identifier: GPL-2.0-only */
>>> +/*
>>> + * Copyright (C) 2019 Western Digital Corporation or its affiliates.
>>> + *
>>> + * Authors:
>>> + *   Atish Patra <atish.patra@wdc.com>
>>> + */
>>> +
>>> +#ifndef __KVM_VCPU_RISCV_TIMER_H
>>> +#define __KVM_VCPU_RISCV_TIMER_H
>>> +
>>> +#include <linux/hrtimer.h>
>>> +
>>> +#define VCPU_TIMER_PROGRAM_THRESHOLD_NS 1000
>>> +
>>> +struct kvm_vcpu_timer {
>>> +     bool init_done;
>>> +     /* Check if the timer is programmed */
>>> +     bool is_set;
>>> +     struct hrtimer hrt;
>>> +     /* Mult & Shift values to get nanosec from cycles */
>>> +     u32 mult;
>>> +     u32 shift;
>>> +};
>>> +
>>> +int kvm_riscv_vcpu_timer_init(struct kvm_vcpu *vcpu);
>>> +int kvm_riscv_vcpu_timer_deinit(struct kvm_vcpu *vcpu);
>>> +int kvm_riscv_vcpu_timer_reset(struct kvm_vcpu *vcpu);
>>> +int kvm_riscv_vcpu_timer_next_event(struct kvm_vcpu *vcpu,
>>> +                                 unsigned long ncycles);
>>=20
>> This function never gets called?
>=20
> It's called from SBI emulation.
>=20
>>=20
>>> +
>>> +#endif
>>> diff --git a/arch/riscv/kvm/Makefile b/arch/riscv/kvm/Makefile
>>> index c0f57f26c13d..3e0c7558320d 100644
>>> --- a/arch/riscv/kvm/Makefile
>>> +++ b/arch/riscv/kvm/Makefile
>>> @@ -9,6 +9,6 @@ ccflags-y :=3D -Ivirt/kvm -Iarch/riscv/kvm
>>>  kvm-objs :=3D $(common-objs-y)
>>>=20
>>>  kvm-objs +=3D main.o vm.o vmid.o tlb.o mmu.o
>>> -kvm-objs +=3D vcpu.o vcpu_exit.o vcpu_switch.o
>>> +kvm-objs +=3D vcpu.o vcpu_exit.o vcpu_switch.o vcpu_timer.o
>>>=20
>>>  obj-$(CONFIG_KVM)   +=3D kvm.o
>>> diff --git a/arch/riscv/kvm/vcpu.c b/arch/riscv/kvm/vcpu.c
>>> index 6124077d154f..018fca436776 100644
>>> --- a/arch/riscv/kvm/vcpu.c
>>> +++ b/arch/riscv/kvm/vcpu.c
>>> @@ -54,6 +54,8 @@ static void kvm_riscv_reset_vcpu(struct kvm_vcpu *vcp=
u)
>>>=20
>>>      memcpy(cntx, reset_cntx, sizeof(*cntx));
>>>=20
>>> +     kvm_riscv_vcpu_timer_reset(vcpu);
>>> +
>>>      WRITE_ONCE(vcpu->arch.irqs_pending, 0);
>>>      WRITE_ONCE(vcpu->arch.irqs_pending_mask, 0);
>>>  }
>>> @@ -108,6 +110,9 @@ int kvm_arch_vcpu_init(struct kvm_vcpu *vcpu)
>>>      cntx->hstatus |=3D HSTATUS_SP2P;
>>>      cntx->hstatus |=3D HSTATUS_SPV;
>>>=20
>>> +     /* Setup VCPU timer */
>>> +     kvm_riscv_vcpu_timer_init(vcpu);
>>> +
>>>      /* Reset VCPU */
>>>      kvm_riscv_reset_vcpu(vcpu);
>>>=20
>>> @@ -116,6 +121,7 @@ int kvm_arch_vcpu_init(struct kvm_vcpu *vcpu)
>>>=20
>>>  void kvm_arch_vcpu_destroy(struct kvm_vcpu *vcpu)
>>>  {
>>> +     kvm_riscv_vcpu_timer_deinit(vcpu);
>>>      kvm_riscv_stage2_flush_cache(vcpu);
>>>      kmem_cache_free(kvm_vcpu_cache, vcpu);
>>>  }
>>> diff --git a/arch/riscv/kvm/vcpu_timer.c b/arch/riscv/kvm/vcpu_timer.c
>>> new file mode 100644
>>> index 000000000000..a45ca06e1aa6
>>> --- /dev/null
>>> +++ b/arch/riscv/kvm/vcpu_timer.c
>>> @@ -0,0 +1,106 @@
>>> +// SPDX-License-Identifier: GPL-2.0
>>> +/*
>>> + * Copyright (C) 2019 Western Digital Corporation or its affiliates.
>>> + *
>>> + * Authors:
>>> + *     Atish Patra <atish.patra@wdc.com>
>>> + */
>>> +
>>> +#include <linux/errno.h>
>>> +#include <linux/err.h>
>>> +#include <linux/kvm_host.h>
>>> +#include <clocksource/timer-riscv.h>
>>> +#include <asm/csr.h>
>>> +#include <asm/kvm_vcpu_timer.h>
>>> +
>>> +static enum hrtimer_restart kvm_riscv_vcpu_hrtimer_expired(struct hrti=
mer *h)
>>> +{
>>> +     struct kvm_vcpu_timer *t =3D container_of(h, struct kvm_vcpu_time=
r, hrt);
>>> +     struct kvm_vcpu *vcpu =3D container_of(t, struct kvm_vcpu, arch.t=
imer);
>>> +
>>> +     t->is_set =3D false;
>>> +     kvm_riscv_vcpu_set_interrupt(vcpu, IRQ_S_TIMER);
>>> +
>>> +     return HRTIMER_NORESTART;
>>> +}
>>> +
>>> +static u64 kvm_riscv_delta_cycles2ns(u64 cycles, struct kvm_vcpu_timer=
 *t)
>>> +{
>>> +     unsigned long flags;
>>> +     u64 cycles_now, cycles_delta, delta_ns;
>>> +
>>> +     local_irq_save(flags);
>>> +     cycles_now =3D get_cycles64();
>>> +     if (cycles_now < cycles)
>>> +             cycles_delta =3D cycles - cycles_now;
>>> +     else
>>> +             cycles_delta =3D 0;
>>> +     delta_ns =3D (cycles_delta * t->mult) >> t->shift;
>>> +     local_irq_restore(flags);
>>> +
>>> +     return delta_ns;
>>> +}
>>> +
>>> +static int kvm_riscv_vcpu_timer_cancel(struct kvm_vcpu_timer *t)
>>> +{
>>> +     if (!t->init_done || !t->is_set)
>>> +             return -EINVAL;
>>> +
>>> +     hrtimer_cancel(&t->hrt);
>>> +     t->is_set =3D false;
>>> +
>>> +     return 0;
>>> +}
>>> +
>>> +int kvm_riscv_vcpu_timer_next_event(struct kvm_vcpu *vcpu,
>>> +                                 unsigned long ncycles)
>>> +{
>>> +     struct kvm_vcpu_timer *t =3D &vcpu->arch.timer;
>>> +     u64 delta_ns =3D kvm_riscv_delta_cycles2ns(ncycles, t);
>>=20
>> ... in fact, I feel like I'm missing something obvious here. How does
>> the guest trigger the timer event? What is the argument it uses for that
>> and how does that play with the tbfreq in the earlier patch?
>=20
> We have SBI call inferface between Hypervisor and Guest. One of the
> SBI call allows Guest to program time event. The next event is specified
> as absolute cycles. The Guest can read time using TIME CSR which
> returns system timer value (@ tbfreq freqency).
>=20
> Guest Linux will know the tbfreq from DTB passed by QEMU/KVMTOOL
> and it has to be same as Host tbfreq.
>=20
> The TBFREQ config register visible to user-space is a read-only CONFIG
> register which tells user-space tools (QEMU/KVMTOOL) about Host tbfreq.

And it's read-only because you can not trap on TB reads?

Alex

>=20
> Regards,
> Anup
>=20
>>=20
>>=20
>> Alex
>>=20
