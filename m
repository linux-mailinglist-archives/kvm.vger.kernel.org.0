Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E1ADE9AE00
	for <lists+kvm@lfdr.de>; Fri, 23 Aug 2019 13:20:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732355AbfHWLUQ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 23 Aug 2019 07:20:16 -0400
Received: from mail-wm1-f66.google.com ([209.85.128.66]:52499 "EHLO
        mail-wm1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730588AbfHWLUP (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 23 Aug 2019 07:20:15 -0400
Received: by mail-wm1-f66.google.com with SMTP id o4so8570436wmh.2
        for <kvm@vger.kernel.org>; Fri, 23 Aug 2019 04:20:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=brainfault-org.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=gt/naIOsY8gmLD5TiOQ5MS/GAPTKfYYmo7pVy0WBBDI=;
        b=CvVwFPC8yH2+//gj5H6htQvO8jMX80EB4Ob0udMTsg5dVmSnwqvlfPBOn19MQmvh1t
         0+gTiPSXjcG6Kq7/ct99UONMkj7NH3HDnDhV70oGwB3YObB2Wkn89ChzmeH2GYV/LGM5
         P6EvoeR/oU5Fc5/a5pulhzXDcOzCWzaGpJOKbZok51UiTho9IqFUuKEN11eoQTBDg0Uw
         V46Y+nraqGqQUaLGhg/Xc2ybEyjhptriU80XPJBFxgMKlpgEU4t7UM7sojfleE3auC8i
         y0A+2B7Wb2JAsFR57V2kYf09vQZL8o9htoNz6Xofi0YAQU0tVIAM3JtYzLcl0/ja2PMp
         OL8w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=gt/naIOsY8gmLD5TiOQ5MS/GAPTKfYYmo7pVy0WBBDI=;
        b=srSYBps02rv1TrJMMJcSAFvgHyObwLACYUPopssweBd7F9gpAIZl+YeojFxO/qM1kY
         f05UQrENUorsRdTRqaAucYFKdlKvWsN20COflrrB3x11sshuISEUReMA3XaiW1wIPQnL
         wV+UHaYalVYouUg3jzYSA6n0ZbBHsMkL2t4AUHdOWnYBQ8wITpW3gCY3UhwF7kVFNC0U
         tz3l/jpoBdLurCYAeG9DF2I7u5qknoWd7EIk5u7tmtUPEAzFjp0N9FPNEKWm0Ru3MO2j
         RvCIRm7hsnJYeNi4hfwKNjwraq5QknBgDIUqPPGSETQLmi15VGOoo7ksiun9kKO+Pj2Q
         jdQw==
X-Gm-Message-State: APjAAAUZ3DtjGc7wHRY2gKRq697/sW3xoNXNzOSWt5B9bQZ5jvDXfSDr
        IJKvfagZ3TCPNS9JsOHjCuDzZfii1Onpp/HwNivibw==
X-Google-Smtp-Source: APXvYqxutjgh00+PyGeA3aINGZRH4UJOayx2wxrA1dv+Wwr2q4vnqnklJFh+sUqeMXjcAb5uef7DhVDhZU3kGeuwGDQ=
X-Received: by 2002:a7b:c933:: with SMTP id h19mr4389590wml.177.1566559212602;
 Fri, 23 Aug 2019 04:20:12 -0700 (PDT)
MIME-Version: 1.0
References: <20190822084131.114764-1-anup.patel@wdc.com> <20190822084131.114764-9-anup.patel@wdc.com>
 <d306ffaf-c9ac-4a9f-4382-95001487364d@amazon.com> <CAAhSdy0t7P1a_eYmLo9sSYTCbumCqqWcvuv4yJXGCBQOXvw5TQ@mail.gmail.com>
 <2871ee6a-ae7c-6937-e8ef-38a8c318638a@amazon.com>
In-Reply-To: <2871ee6a-ae7c-6937-e8ef-38a8c318638a@amazon.com>
From:   Anup Patel <anup@brainfault.org>
Date:   Fri, 23 Aug 2019 16:50:01 +0530
Message-ID: <CAAhSdy05EWBP5Y5oTpW_J6AT=fe=E1UNGXVncsBRWTrr_sgjWw@mail.gmail.com>
Subject: Re: [PATCH v5 08/20] RISC-V: KVM: Implement KVM_GET_ONE_REG/KVM_SET_ONE_REG
 ioctls
To:     Alexander Graf <graf@amazon.com>
Cc:     Anup Patel <Anup.Patel@wdc.com>,
        Palmer Dabbelt <palmer@sifive.com>,
        Paul Walmsley <paul.walmsley@sifive.com>,
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
Content-Type: text/plain; charset="UTF-8"
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Aug 22, 2019 at 7:42 PM Alexander Graf <graf@amazon.com> wrote:
>
>
>
> On 22.08.19 16:00, Anup Patel wrote:
> > On Thu, Aug 22, 2019 at 5:31 PM Alexander Graf <graf@amazon.com> wrote:
> >>
> >> On 22.08.19 10:44, Anup Patel wrote:
> >>> For KVM RISC-V, we use KVM_GET_ONE_REG/KVM_SET_ONE_REG ioctls to access
> >>> VCPU config and registers from user-space.
> >>>
> >>> We have three types of VCPU registers:
> >>> 1. CONFIG - these are VCPU config and capabilities
> >>> 2. CORE   - these are VCPU general purpose registers
> >>> 3. CSR    - these are VCPU control and status registers
> >>>
> >>> The CONFIG registers available to user-space are ISA and TIMEBASE. Out
> >>> of these, TIMEBASE is a read-only register which inform user-space about
> >>> VCPU timer base frequency. The ISA register is a read and write register
> >>> where user-space can only write the desired VCPU ISA capabilities before
> >>> running the VCPU.
> >>>
> >>> The CORE registers available to user-space are PC, RA, SP, GP, TP, A0-A7,
> >>> T0-T6, S0-S11 and MODE. Most of these are RISC-V general registers except
> >>> PC and MODE. The PC register represents program counter whereas the MODE
> >>> register represent VCPU privilege mode (i.e. S/U-mode).
> >>>
> >>> The CSRs available to user-space are SSTATUS, SIE, STVEC, SSCRATCH, SEPC,
> >>> SCAUSE, STVAL, SIP, and SATP. All of these are read/write registers.
> >>>
> >>> In future, more VCPU register types will be added (such as FP) for the
> >>> KVM_GET_ONE_REG/KVM_SET_ONE_REG ioctls.
> >>>
> >>> Signed-off-by: Anup Patel <anup.patel@wdc.com>
> >>> Acked-by: Paolo Bonzini <pbonzini@redhat.com>
> >>> Reviewed-by: Paolo Bonzini <pbonzini@redhat.com>
> >>> ---
> >>>    arch/riscv/include/uapi/asm/kvm.h |  40 ++++-
> >>>    arch/riscv/kvm/vcpu.c             | 235 +++++++++++++++++++++++++++++-
> >>>    2 files changed, 272 insertions(+), 3 deletions(-)
> >>>
> >>> diff --git a/arch/riscv/include/uapi/asm/kvm.h b/arch/riscv/include/uapi/asm/kvm.h
> >>> index 6dbc056d58ba..024f220eb17e 100644
> >>> --- a/arch/riscv/include/uapi/asm/kvm.h
> >>> +++ b/arch/riscv/include/uapi/asm/kvm.h
> >>> @@ -23,8 +23,15 @@
> >>>
> >>>    /* for KVM_GET_REGS and KVM_SET_REGS */
> >>>    struct kvm_regs {
> >>> +     /* out (KVM_GET_REGS) / in (KVM_SET_REGS) */
> >>> +     struct user_regs_struct regs;
> >>> +     unsigned long mode;
> >>
> >> Is there any particular reason you're reusing kvm_regs and don't invent
> >> your own struct? kvm_regs is explicitly meant for the get_regs and
> >> set_regs ioctls.
> >
> > We are implementing only ONE_REG interface so most of these
> > structs are unused hence we tried to reuse these struct instead
> > of introducing new structs. (Similar to KVM ARM64)
> >
> >>
> >>>    };
> >>>
> >>> +/* Possible privilege modes for kvm_regs */
> >>> +#define KVM_RISCV_MODE_S     1
> >>> +#define KVM_RISCV_MODE_U     0
> >>> +
> >>>    /* for KVM_GET_FPU and KVM_SET_FPU */
> >>>    struct kvm_fpu {
> >>>    };
> >>> @@ -41,10 +48,41 @@ struct kvm_guest_debug_arch {
> >>>    struct kvm_sync_regs {
> >>>    };
> >>>
> >>> -/* dummy definition */
> >>> +/* for KVM_GET_SREGS and KVM_SET_SREGS */
> >>>    struct kvm_sregs {
> >>> +     unsigned long sstatus;
> >>> +     unsigned long sie;
> >>> +     unsigned long stvec;
> >>> +     unsigned long sscratch;
> >>> +     unsigned long sepc;
> >>> +     unsigned long scause;
> >>> +     unsigned long stval;
> >>> +     unsigned long sip;
> >>> +     unsigned long satp;
> >>
> >> Same comment here.
> >
> > Same as above, we are trying to use unused struct.
> >
> >>
> >>>    };
> >>>
> >>> +#define KVM_REG_SIZE(id)             \
> >>> +     (1U << (((id) & KVM_REG_SIZE_MASK) >> KVM_REG_SIZE_SHIFT))
> >>> +
> >>> +/* If you need to interpret the index values, here is the key: */
> >>> +#define KVM_REG_RISCV_TYPE_MASK              0x00000000FF000000
> >>> +#define KVM_REG_RISCV_TYPE_SHIFT     24
> >>> +
> >>> +/* Config registers are mapped as type 1 */
> >>> +#define KVM_REG_RISCV_CONFIG         (0x01 << KVM_REG_RISCV_TYPE_SHIFT)
> >>> +#define KVM_REG_RISCV_CONFIG_ISA     0x0
> >>> +#define KVM_REG_RISCV_CONFIG_TIMEBASE        0x1
> >>> +
> >>> +/* Core registers are mapped as type 2 */
> >>> +#define KVM_REG_RISCV_CORE           (0x02 << KVM_REG_RISCV_TYPE_SHIFT)
> >>> +#define KVM_REG_RISCV_CORE_REG(name) \
> >>> +             (offsetof(struct kvm_regs, name) / sizeof(unsigned long))
> >>
> >> I see, you're trying to implicitly use the struct offsets as index.
> >>
> >> I'm not a really big fan of it, but I can't pinpoint exactly why just
> >> yet. It just seems too magical (read: potentially breaking down the
> >> road) for me.
> >>
> >>> +
> >>> +/* Control and status registers are mapped as type 3 */
> >>> +#define KVM_REG_RISCV_CSR            (0x03 << KVM_REG_RISCV_TYPE_SHIFT)
> >>> +#define KVM_REG_RISCV_CSR_REG(name)  \
> >>> +             (offsetof(struct kvm_sregs, name) / sizeof(unsigned long))
> >>> +
> >>>    #endif
> >>>
> >>>    #endif /* __LINUX_KVM_RISCV_H */
> >>> diff --git a/arch/riscv/kvm/vcpu.c b/arch/riscv/kvm/vcpu.c
> >>> index 7f59e85c6af8..9396a83c0611 100644
> >>> --- a/arch/riscv/kvm/vcpu.c
> >>> +++ b/arch/riscv/kvm/vcpu.c
> >>> @@ -164,6 +164,215 @@ vm_fault_t kvm_arch_vcpu_fault(struct kvm_vcpu *vcpu, struct vm_fault *vmf)
> >>>        return VM_FAULT_SIGBUS;
> >>>    }
> >>>
> >>> +static int kvm_riscv_vcpu_get_reg_config(struct kvm_vcpu *vcpu,
> >>> +                                      const struct kvm_one_reg *reg)
> >>> +{
> >>> +     unsigned long __user *uaddr =
> >>> +                     (unsigned long __user *)(unsigned long)reg->addr;
> >>> +     unsigned long reg_num = reg->id & ~(KVM_REG_ARCH_MASK |
> >>> +                                         KVM_REG_SIZE_MASK |
> >>> +                                         KVM_REG_RISCV_CONFIG);
> >>> +     unsigned long reg_val;
> >>> +
> >>> +     if (KVM_REG_SIZE(reg->id) != sizeof(unsigned long))
> >>> +             return -EINVAL;
> >>> +
> >>> +     switch (reg_num) {
> >>> +     case KVM_REG_RISCV_CONFIG_ISA:
> >>> +             reg_val = vcpu->arch.isa;
> >>> +             break;
> >>> +     case KVM_REG_RISCV_CONFIG_TIMEBASE:
> >>> +             reg_val = riscv_timebase;
> >>
> >> What does this reflect? The current guest time hopefully not? An offset?
> >> Related to what?
> >
> > riscv_timebase is the frequency in HZ of the system timer.
> >
> > The name "timebase" is not appropriate but we have been
> > carrying it since quite some time now.
>
> What do you mean by "some time"? So far I only see a kernel internal
> variable named after it. That's dramatically different from something
> exposed via uapi.
>
> Just name it tbfreq.

Sure, I will use TBFREQ name.

>
> So if this is the frequency, where is the offset? You will need it on
> save/restore. If you're saying that's out of scope for now, that's fine
> with me too :).

tbfreq is read-only and fixed.

The Guest tbfreq has to be same as Host tbfreq. This means we
can only migrate Guest from Host A to Host B only if:
1. They have matching ISA capabilities
2. They have matching tbfreq

Regards,
Anup

>
>
> Alex
