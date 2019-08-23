Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AEFD49AE4B
	for <lists+kvm@lfdr.de>; Fri, 23 Aug 2019 13:42:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2393040AbfHWLm2 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 23 Aug 2019 07:42:28 -0400
Received: from smtp-fw-4101.amazon.com ([72.21.198.25]:46651 "EHLO
        smtp-fw-4101.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2392936AbfHWLm2 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 23 Aug 2019 07:42:28 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1566560547; x=1598096547;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=efWf68RHTEU5jfUDP/jimurqpfPCyrlIgwD0X4wcJVg=;
  b=vFkF2h6Nr/ecemEKbelP6HXIzJcVknnzaYUHX+F3VU6oApPIwG6U2I4S
   Ta6I0BhvD9zFypbvura2UDaQ62tphuQrL2uzV+N+WURy0JsBisOhs9y8v
   bQrtbWBy4hyUykjmn+IJsgU5zoA55IO7NzJ/6QxpRKfr3u8uB5QKbXP2b
   g=;
X-IronPort-AV: E=Sophos;i="5.64,421,1559520000"; 
   d="scan'208";a="780987669"
Received: from iad6-co-svc-p1-lb1-vlan3.amazon.com (HELO email-inbound-relay-2b-baacba05.us-west-2.amazon.com) ([10.124.125.6])
  by smtp-border-fw-out-4101.iad4.amazon.com with ESMTP; 23 Aug 2019 11:42:25 +0000
Received: from EX13MTAUWC001.ant.amazon.com (pdx4-ws-svc-p6-lb7-vlan2.pdx.amazon.com [10.170.41.162])
        by email-inbound-relay-2b-baacba05.us-west-2.amazon.com (Postfix) with ESMTPS id 7EE04A1EAF;
        Fri, 23 Aug 2019 11:42:24 +0000 (UTC)
Received: from EX13D20UWC001.ant.amazon.com (10.43.162.244) by
 EX13MTAUWC001.ant.amazon.com (10.43.162.135) with Microsoft SMTP Server (TLS)
 id 15.0.1367.3; Fri, 23 Aug 2019 11:42:23 +0000
Received: from EX13D20UWC001.ant.amazon.com (10.43.162.244) by
 EX13D20UWC001.ant.amazon.com (10.43.162.244) with Microsoft SMTP Server (TLS)
 id 15.0.1367.3; Fri, 23 Aug 2019 11:42:23 +0000
Received: from EX13D20UWC001.ant.amazon.com ([10.43.162.244]) by
 EX13D20UWC001.ant.amazon.com ([10.43.162.244]) with mapi id 15.00.1367.000;
 Fri, 23 Aug 2019 11:42:23 +0000
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
Subject: Re: [PATCH v5 08/20] RISC-V: KVM: Implement
 KVM_GET_ONE_REG/KVM_SET_ONE_REG ioctls
Thread-Topic: [PATCH v5 08/20] RISC-V: KVM: Implement
 KVM_GET_ONE_REG/KVM_SET_ONE_REG ioctls
Thread-Index: AQHVWOFJW41zI61GkUGV/QWGSrKC3acHMjmAgAADPoCAAWIugIAABkF9
Date:   Fri, 23 Aug 2019 11:42:23 +0000
Message-ID: <D4DA3654-9297-4CE4-8FF6-9BE6E13A89AD@amazon.com>
References: <20190822084131.114764-1-anup.patel@wdc.com>
 <20190822084131.114764-9-anup.patel@wdc.com>
 <d306ffaf-c9ac-4a9f-4382-95001487364d@amazon.com>
 <CAAhSdy0t7P1a_eYmLo9sSYTCbumCqqWcvuv4yJXGCBQOXvw5TQ@mail.gmail.com>
 <2871ee6a-ae7c-6937-e8ef-38a8c318638a@amazon.com>,<CAAhSdy05EWBP5Y5oTpW_J6AT=fe=E1UNGXVncsBRWTrr_sgjWw@mail.gmail.com>
In-Reply-To: <CAAhSdy05EWBP5Y5oTpW_J6AT=fe=E1UNGXVncsBRWTrr_sgjWw@mail.gmail.com>
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



> Am 23.08.2019 um 13:21 schrieb Anup Patel <anup@brainfault.org>:
>=20
>> On Thu, Aug 22, 2019 at 7:42 PM Alexander Graf <graf@amazon.com> wrote:
>>=20
>>=20
>>=20
>>> On 22.08.19 16:00, Anup Patel wrote:
>>>> On Thu, Aug 22, 2019 at 5:31 PM Alexander Graf <graf@amazon.com> wrote=
:
>>>>=20
>>>>> On 22.08.19 10:44, Anup Patel wrote:
>>>>> For KVM RISC-V, we use KVM_GET_ONE_REG/KVM_SET_ONE_REG ioctls to acce=
ss
>>>>> VCPU config and registers from user-space.
>>>>>=20
>>>>> We have three types of VCPU registers:
>>>>> 1. CONFIG - these are VCPU config and capabilities
>>>>> 2. CORE   - these are VCPU general purpose registers
>>>>> 3. CSR    - these are VCPU control and status registers
>>>>>=20
>>>>> The CONFIG registers available to user-space are ISA and TIMEBASE. Ou=
t
>>>>> of these, TIMEBASE is a read-only register which inform user-space ab=
out
>>>>> VCPU timer base frequency. The ISA register is a read and write regis=
ter
>>>>> where user-space can only write the desired VCPU ISA capabilities bef=
ore
>>>>> running the VCPU.
>>>>>=20
>>>>> The CORE registers available to user-space are PC, RA, SP, GP, TP, A0=
-A7,
>>>>> T0-T6, S0-S11 and MODE. Most of these are RISC-V general registers ex=
cept
>>>>> PC and MODE. The PC register represents program counter whereas the M=
ODE
>>>>> register represent VCPU privilege mode (i.e. S/U-mode).
>>>>>=20
>>>>> The CSRs available to user-space are SSTATUS, SIE, STVEC, SSCRATCH, S=
EPC,
>>>>> SCAUSE, STVAL, SIP, and SATP. All of these are read/write registers.
>>>>>=20
>>>>> In future, more VCPU register types will be added (such as FP) for th=
e
>>>>> KVM_GET_ONE_REG/KVM_SET_ONE_REG ioctls.
>>>>>=20
>>>>> Signed-off-by: Anup Patel <anup.patel@wdc.com>
>>>>> Acked-by: Paolo Bonzini <pbonzini@redhat.com>
>>>>> Reviewed-by: Paolo Bonzini <pbonzini@redhat.com>
>>>>> ---
>>>>>   arch/riscv/include/uapi/asm/kvm.h |  40 ++++-
>>>>>   arch/riscv/kvm/vcpu.c             | 235 +++++++++++++++++++++++++++=
++-
>>>>>   2 files changed, 272 insertions(+), 3 deletions(-)
>>>>>=20
>>>>> diff --git a/arch/riscv/include/uapi/asm/kvm.h b/arch/riscv/include/u=
api/asm/kvm.h
>>>>> index 6dbc056d58ba..024f220eb17e 100644
>>>>> --- a/arch/riscv/include/uapi/asm/kvm.h
>>>>> +++ b/arch/riscv/include/uapi/asm/kvm.h
>>>>> @@ -23,8 +23,15 @@
>>>>>=20
>>>>>   /* for KVM_GET_REGS and KVM_SET_REGS */
>>>>>   struct kvm_regs {
>>>>> +     /* out (KVM_GET_REGS) / in (KVM_SET_REGS) */
>>>>> +     struct user_regs_struct regs;
>>>>> +     unsigned long mode;
>>>>=20
>>>> Is there any particular reason you're reusing kvm_regs and don't inven=
t
>>>> your own struct? kvm_regs is explicitly meant for the get_regs and
>>>> set_regs ioctls.
>>>=20
>>> We are implementing only ONE_REG interface so most of these
>>> structs are unused hence we tried to reuse these struct instead
>>> of introducing new structs. (Similar to KVM ARM64)
>>>=20
>>>>=20
>>>>>   };
>>>>>=20
>>>>> +/* Possible privilege modes for kvm_regs */
>>>>> +#define KVM_RISCV_MODE_S     1
>>>>> +#define KVM_RISCV_MODE_U     0
>>>>> +
>>>>>   /* for KVM_GET_FPU and KVM_SET_FPU */
>>>>>   struct kvm_fpu {
>>>>>   };
>>>>> @@ -41,10 +48,41 @@ struct kvm_guest_debug_arch {
>>>>>   struct kvm_sync_regs {
>>>>>   };
>>>>>=20
>>>>> -/* dummy definition */
>>>>> +/* for KVM_GET_SREGS and KVM_SET_SREGS */
>>>>>   struct kvm_sregs {
>>>>> +     unsigned long sstatus;
>>>>> +     unsigned long sie;
>>>>> +     unsigned long stvec;
>>>>> +     unsigned long sscratch;
>>>>> +     unsigned long sepc;
>>>>> +     unsigned long scause;
>>>>> +     unsigned long stval;
>>>>> +     unsigned long sip;
>>>>> +     unsigned long satp;
>>>>=20
>>>> Same comment here.
>>>=20
>>> Same as above, we are trying to use unused struct.
>>>=20
>>>>=20
>>>>>   };
>>>>>=20
>>>>> +#define KVM_REG_SIZE(id)             \
>>>>> +     (1U << (((id) & KVM_REG_SIZE_MASK) >> KVM_REG_SIZE_SHIFT))
>>>>> +
>>>>> +/* If you need to interpret the index values, here is the key: */
>>>>> +#define KVM_REG_RISCV_TYPE_MASK              0x00000000FF000000
>>>>> +#define KVM_REG_RISCV_TYPE_SHIFT     24
>>>>> +
>>>>> +/* Config registers are mapped as type 1 */
>>>>> +#define KVM_REG_RISCV_CONFIG         (0x01 << KVM_REG_RISCV_TYPE_SHI=
FT)
>>>>> +#define KVM_REG_RISCV_CONFIG_ISA     0x0
>>>>> +#define KVM_REG_RISCV_CONFIG_TIMEBASE        0x1
>>>>> +
>>>>> +/* Core registers are mapped as type 2 */
>>>>> +#define KVM_REG_RISCV_CORE           (0x02 << KVM_REG_RISCV_TYPE_SHI=
FT)
>>>>> +#define KVM_REG_RISCV_CORE_REG(name) \
>>>>> +             (offsetof(struct kvm_regs, name) / sizeof(unsigned long=
))
>>>>=20
>>>> I see, you're trying to implicitly use the struct offsets as index.
>>>>=20
>>>> I'm not a really big fan of it, but I can't pinpoint exactly why just
>>>> yet. It just seems too magical (read: potentially breaking down the
>>>> road) for me.
>>>>=20
>>>>> +
>>>>> +/* Control and status registers are mapped as type 3 */
>>>>> +#define KVM_REG_RISCV_CSR            (0x03 << KVM_REG_RISCV_TYPE_SHI=
FT)
>>>>> +#define KVM_REG_RISCV_CSR_REG(name)  \
>>>>> +             (offsetof(struct kvm_sregs, name) / sizeof(unsigned lon=
g))
>>>>> +
>>>>>   #endif
>>>>>=20
>>>>>   #endif /* __LINUX_KVM_RISCV_H */
>>>>> diff --git a/arch/riscv/kvm/vcpu.c b/arch/riscv/kvm/vcpu.c
>>>>> index 7f59e85c6af8..9396a83c0611 100644
>>>>> --- a/arch/riscv/kvm/vcpu.c
>>>>> +++ b/arch/riscv/kvm/vcpu.c
>>>>> @@ -164,6 +164,215 @@ vm_fault_t kvm_arch_vcpu_fault(struct kvm_vcpu =
*vcpu, struct vm_fault *vmf)
>>>>>       return VM_FAULT_SIGBUS;
>>>>>   }
>>>>>=20
>>>>> +static int kvm_riscv_vcpu_get_reg_config(struct kvm_vcpu *vcpu,
>>>>> +                                      const struct kvm_one_reg *reg)
>>>>> +{
>>>>> +     unsigned long __user *uaddr =3D
>>>>> +                     (unsigned long __user *)(unsigned long)reg->add=
r;
>>>>> +     unsigned long reg_num =3D reg->id & ~(KVM_REG_ARCH_MASK |
>>>>> +                                         KVM_REG_SIZE_MASK |
>>>>> +                                         KVM_REG_RISCV_CONFIG);
>>>>> +     unsigned long reg_val;
>>>>> +
>>>>> +     if (KVM_REG_SIZE(reg->id) !=3D sizeof(unsigned long))
>>>>> +             return -EINVAL;
>>>>> +
>>>>> +     switch (reg_num) {
>>>>> +     case KVM_REG_RISCV_CONFIG_ISA:
>>>>> +             reg_val =3D vcpu->arch.isa;
>>>>> +             break;
>>>>> +     case KVM_REG_RISCV_CONFIG_TIMEBASE:
>>>>> +             reg_val =3D riscv_timebase;
>>>>=20
>>>> What does this reflect? The current guest time hopefully not? An offse=
t?
>>>> Related to what?
>>>=20
>>> riscv_timebase is the frequency in HZ of the system timer.
>>>=20
>>> The name "timebase" is not appropriate but we have been
>>> carrying it since quite some time now.
>>=20
>> What do you mean by "some time"? So far I only see a kernel internal
>> variable named after it. That's dramatically different from something
>> exposed via uapi.
>>=20
>> Just name it tbfreq.
>=20
> Sure, I will use TBFREQ name.
>=20
>>=20
>> So if this is the frequency, where is the offset? You will need it on
>> save/restore. If you're saying that's out of scope for now, that's fine
>> with me too :).
>=20
> tbfreq is read-only and fixed.
>=20
> The Guest tbfreq has to be same as Host tbfreq. This means we
> can only migrate Guest from Host A to Host B only if:
> 1. They have matching ISA capabilities

That's what we have on almost all archs, it's a fair statement.

> 2. They have matching tbfreq

This was true for most archs in the early virtualization days, but CPU vend=
ors learned since then. It really makes people upset if they can not move t=
heir guests to a new CPU.

If you see bits in the spec that are missing (tb freq scaling / trapping on=
 tb reads), please work with the ISA people to resolve them going forward.

Alex

>=20
> Regards,
> Anup
>=20
>>=20
>>=20
>> Alex
