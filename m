Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B8B85103255
	for <lists+kvm@lfdr.de>; Wed, 20 Nov 2019 04:49:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727578AbfKTDtp (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 19 Nov 2019 22:49:45 -0500
Received: from mail-ot1-f68.google.com ([209.85.210.68]:40304 "EHLO
        mail-ot1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727378AbfKTDto (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 19 Nov 2019 22:49:44 -0500
Received: by mail-ot1-f68.google.com with SMTP id m15so19995207otq.7;
        Tue, 19 Nov 2019 19:49:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=AL7UwpZpDtrAGO1EXavPbI6HiHuHJD7YVcQ5aKTdQSg=;
        b=KgW+LNrma27erCDp4ciIxJVOnGkpFA33g/TmcXtqOzr1T5FDcPPv2i4gmoQJox1ej1
         PRU7014/ltoCn6wuy+O8sLwY0czxMd2hE9s7frbvCr6bbdIHS748oXlBBEssBFkuc24a
         oarvhLj94m+Xn54KwnPEDmADVa5JaQzFBvHgACL8apctznDsvX/SKPZCJ6xwbn80ioOF
         ADuhboJVLeqXjK2smvwMv2PAFSSBjmGuc5ePnt3saBSGkivSaUCzeoKLFkiVbL+7CbV9
         gDrjhTvpx6LPYbnjIBpiL/GHstpDst0Nwx/8iicQcLQ2FSK7p8hoMzN0dYvC4sHWUSx1
         jPhw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=AL7UwpZpDtrAGO1EXavPbI6HiHuHJD7YVcQ5aKTdQSg=;
        b=Y0bnADVRYmLUgpmr28L61ebBgQkvg6dyoCZDDmmjklIRgcxmw2PFLJ30gjMDnxPWw+
         uHTNeVps0DJ5pFyaWlwJ2HmGZlsI02itmLRW/roqYj76ecapR3hzVL/qCaap9U4oROjK
         SHFymmimWkGPCXbf6CDltP/uSmogA8ttOSy+n3sz0c1fxe5dZQQauLWwb43pO7t9X/8W
         hKTE2Kc7+wMZyk21UaGqPut/bZ6YuaEGSnUJtVuJGaptv8+EToGS43Y/PM4wOvn8gWza
         igrHyW4H7xM7q0JxTf8P3GxjrbfZXXIIWuhCWxh8rtlTaDOTEWTOg/fEUXzDDP5KAmlB
         KLFg==
X-Gm-Message-State: APjAAAXr/YWNMIgBHPguc13/q9vq3YVRb+DFJiJlggKYU7ehCSHa7lM5
        R/y4Ck4jfdfEYzD5U/sg92vdoWdO8gagnzWAUtE=
X-Google-Smtp-Source: APXvYqxpOUla8jdXFA9vNA64qE23aq6wGSr/g5HKdgZibrMRGtlZee2Dn0S/kPy81kpjdDcskJX1Yxc8lI3gBFOOMeE=
X-Received: by 2002:a9d:b83:: with SMTP id 3mr321505oth.56.1574221783615; Tue,
 19 Nov 2019 19:49:43 -0800 (PST)
MIME-Version: 1.0
References: <1574145389-12149-1-git-send-email-wanpengli@tencent.com> <09CD3BD3-1F5E-48DA-82ED-58E3196DBD83@oracle.com>
In-Reply-To: <09CD3BD3-1F5E-48DA-82ED-58E3196DBD83@oracle.com>
From:   Wanpeng Li <kernellwp@gmail.com>
Date:   Wed, 20 Nov 2019 11:49:36 +0800
Message-ID: <CANRm+CxZ5Opj44Aj+LL18nVSuU63hXpt9U9E3jJEQP67Hx6WMg@mail.gmail.com>
Subject: Re: [PATCH v2 1/2] KVM: VMX: FIXED+PHYSICAL mode single target IPI fastpath
To:     Liran Alon <liran.alon@oracle.com>
Cc:     LKML <linux-kernel@vger.kernel.org>, kvm <kvm@vger.kernel.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        =?UTF-8?B?UmFkaW0gS3LEjW3DocWZ?= <rkrcmar@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, 19 Nov 2019 at 20:11, Liran Alon <liran.alon@oracle.com> wrote:
>
>
>
> > On 19 Nov 2019, at 8:36, Wanpeng Li <kernellwp@gmail.com> wrote:
> >
> > From: Wanpeng Li <wanpengli@tencent.com>
> >
> > ICR and TSCDEADLINE MSRs write cause the main MSRs write vmexits in
> > our product observation, multicast IPIs are not as common as unicast
> > IPI like RESCHEDULE_VECTOR and CALL_FUNCTION_SINGLE_VECTOR etc.
> >
> > This patch tries to optimize x2apic physical destination mode, fixed
> > delivery mode single target IPI by delivering IPI to receiver as soon
> > as possible after sender writes ICR vmexit to avoid various checks
> > when possible, especially when running guest w/ --overcommit cpu-pm=3Do=
n
> > or guest can keep running, IPI can be injected to target vCPU by
> > posted-interrupt immediately.
> >
> > Testing on Xeon Skylake server:
> >
> > The virtual IPI latency from sender send to receiver receive reduces
> > more than 200+ cpu cycles.
> >
> > Signed-off-by: Wanpeng Li <wanpengli@tencent.com>
> > ---
> > v1 -> v2:
> > * add tracepoint
> > * Instead of a separate vcpu->fast_vmexit, set exit_reason
> >   to vmx->exit_reason to -1 if the fast path succeeds.
> > * move the "kvm_skip_emulated_instruction(vcpu)" to vmx_handle_exit
> > * moving the handling into vmx_handle_exit_irqoff()
> >
> > arch/x86/include/asm/kvm_host.h |  4 ++--
> > arch/x86/include/uapi/asm/vmx.h |  1 +
> > arch/x86/kvm/svm.c              |  4 ++--
> > arch/x86/kvm/vmx/vmx.c          | 40 ++++++++++++++++++++++++++++++++++=
+++---
> > arch/x86/kvm/x86.c              |  5 +++--
> > 5 files changed, 45 insertions(+), 9 deletions(-)
> >
> > diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm=
_host.h
> > index 898ab9e..0daafa9 100644
> > --- a/arch/x86/include/asm/kvm_host.h
> > +++ b/arch/x86/include/asm/kvm_host.h
> > @@ -1084,7 +1084,7 @@ struct kvm_x86_ops {
> >       void (*tlb_flush_gva)(struct kvm_vcpu *vcpu, gva_t addr);
> >
> >       void (*run)(struct kvm_vcpu *vcpu);
> > -     int (*handle_exit)(struct kvm_vcpu *vcpu);
> > +     int (*handle_exit)(struct kvm_vcpu *vcpu, u32 *vcpu_exit_reason);
> >       int (*skip_emulated_instruction)(struct kvm_vcpu *vcpu);
> >       void (*set_interrupt_shadow)(struct kvm_vcpu *vcpu, int mask);
> >       u32 (*get_interrupt_shadow)(struct kvm_vcpu *vcpu);
> > @@ -1134,7 +1134,7 @@ struct kvm_x86_ops {
> >       int (*check_intercept)(struct kvm_vcpu *vcpu,
> >                              struct x86_instruction_info *info,
> >                              enum x86_intercept_stage stage);
> > -     void (*handle_exit_irqoff)(struct kvm_vcpu *vcpu);
> > +     void (*handle_exit_irqoff)(struct kvm_vcpu *vcpu, u32 *vcpu_exit_=
reason);
> >       bool (*mpx_supported)(void);
> >       bool (*xsaves_supported)(void);
> >       bool (*umip_emulated)(void);
> > diff --git a/arch/x86/include/uapi/asm/vmx.h b/arch/x86/include/uapi/as=
m/vmx.h
> > index 3eb8411..b33c6e1 100644
> > --- a/arch/x86/include/uapi/asm/vmx.h
> > +++ b/arch/x86/include/uapi/asm/vmx.h
> > @@ -88,6 +88,7 @@
> > #define EXIT_REASON_XRSTORS             64
> > #define EXIT_REASON_UMWAIT              67
> > #define EXIT_REASON_TPAUSE              68
> > +#define EXIT_REASON_NEED_SKIP_EMULATED_INSN -1
> >
> > #define VMX_EXIT_REASONS \
> >       { EXIT_REASON_EXCEPTION_NMI,         "EXCEPTION_NMI" }, \
> > diff --git a/arch/x86/kvm/svm.c b/arch/x86/kvm/svm.c
> > index d02a73a..c8e063a 100644
> > --- a/arch/x86/kvm/svm.c
> > +++ b/arch/x86/kvm/svm.c
> > @@ -4929,7 +4929,7 @@ static void svm_get_exit_info(struct kvm_vcpu *vc=
pu, u64 *info1, u64 *info2)
> >       *info2 =3D control->exit_info_2;
> > }
> >
> > -static int handle_exit(struct kvm_vcpu *vcpu)
> > +static int handle_exit(struct kvm_vcpu *vcpu, u32 *vcpu_exit_reason)
> > {
> >       struct vcpu_svm *svm =3D to_svm(vcpu);
> >       struct kvm_run *kvm_run =3D vcpu->run;
> > @@ -6187,7 +6187,7 @@ static int svm_check_intercept(struct kvm_vcpu *v=
cpu,
> >       return ret;
> > }
> >
> > -static void svm_handle_exit_irqoff(struct kvm_vcpu *vcpu)
> > +static void svm_handle_exit_irqoff(struct kvm_vcpu *vcpu, u32 *vcpu_ex=
it_reason)
> > {
> >
> > }
> > diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
> > index 621142e5..b98198d 100644
> > --- a/arch/x86/kvm/vmx/vmx.c
> > +++ b/arch/x86/kvm/vmx/vmx.c
> > @@ -5792,7 +5792,7 @@ void dump_vmcs(void)
> >  * The guest has exited.  See if we can fix it or if we need userspace
> >  * assistance.
> >  */
> > -static int vmx_handle_exit(struct kvm_vcpu *vcpu)
> > +static int vmx_handle_exit(struct kvm_vcpu *vcpu, u32 *vcpu_exit_reaso=
n)
>
> vmx_handle_exit() should get second parameter by value and not by pointer=
. As it doesn=E2=80=99t need to modify it.
>
> I would also rename parameter to =E2=80=9Caccel_exit_completion=E2=80=9D =
to indicate this is additional work that needs to happen to complete accele=
rated-exit handling.
> This parameter should be an enum that currently only have 2 values: ACCEL=
_EXIT_NONE and ACCEL_EXIT_SKIP_EMUL_INS.
>
> > {
> >       struct vcpu_vmx *vmx =3D to_vmx(vcpu);
> >       u32 exit_reason =3D vmx->exit_reason;
> > @@ -5878,7 +5878,10 @@ static int vmx_handle_exit(struct kvm_vcpu *vcpu=
)
> >               }
> >       }
> >
> > -     if (exit_reason < kvm_vmx_max_exit_handlers
> > +     if (*vcpu_exit_reason =3D=3D EXIT_REASON_NEED_SKIP_EMULATED_INSN)=
 {
> > +             kvm_skip_emulated_instruction(vcpu);
> > +             return 1;
> > +     } else if (exit_reason < kvm_vmx_max_exit_handlers
> >           && kvm_vmx_exit_handlers[exit_reason]) {
> > #ifdef CONFIG_RETPOLINE
> >               if (exit_reason =3D=3D EXIT_REASON_MSR_WRITE)
> > @@ -6223,7 +6226,36 @@ static void handle_external_interrupt_irqoff(str=
uct kvm_vcpu *vcpu)
> > }
> > STACK_FRAME_NON_STANDARD(handle_external_interrupt_irqoff);
> >
> > -static void vmx_handle_exit_irqoff(struct kvm_vcpu *vcpu)
> > +static u32 handle_ipi_fastpath(struct kvm_vcpu *vcpu)
> > +{
> > +     u32 index;
> > +     u64 data;
> > +     int ret =3D 0;
> > +
> > +     if (lapic_in_kernel(vcpu) && apic_x2apic_mode(vcpu->arch.apic)) {
> > +             /*
> > +              * fastpath to IPI target, FIXED+PHYSICAL which is popula=
r
> > +              */
> > +             index =3D kvm_rcx_read(vcpu);
> > +             data =3D kvm_read_edx_eax(vcpu);
> > +
> > +             if (((index - APIC_BASE_MSR) << 4 =3D=3D APIC_ICR) &&
> > +                     ((data & KVM_APIC_DEST_MASK) =3D=3D APIC_DEST_PHY=
SICAL) &&
> > +                     ((data & APIC_MODE_MASK) =3D=3D APIC_DM_FIXED)) {
> > +
> > +                     trace_kvm_msr_write(index, data);
>
> On a standard EXIT_REASON_MSR_WRITE VMExit, this trace will be printed on=
ly after LAPIC emulation logic happens.
> You should preserve same ordering.
>
> > +                     kvm_lapic_set_reg(vcpu->arch.apic, APIC_ICR2, (u3=
2)(data >> 32));
> > +                     ret =3D kvm_lapic_reg_write(vcpu->arch.apic, APIC=
_ICR, (u32)data);
> > +
> > +                     if (ret =3D=3D 0)
> > +                             return EXIT_REASON_NEED_SKIP_EMULATED_INS=
N;
> > +             }
> > +     }
> > +
> > +     return ret;
> > +}
>
> Maybe it would be more elegant to modify this function as follows?
>
> static int handle_accel_set_x2apic_icr_irqoff(struct kvm_vcpu *vcpu, u32 =
msr, u64 data)
> {
>     if (lapic_in_kernel(vcpu) && apic_x2apic_mode(vcpu->arch.apic) &&
>         ((data & KVM_APIC_DEST_MASK) =3D=3D APIC_DEST_PHYSICAL) &&
>         ((data & APIC_MODE_MASK) =3D=3D APIC_DM_FIXED)) {
>
>         kvm_lapic_set_reg(vcpu->arch.apic, APIC_ICR2, (u32)(data >> 32));
>         return kvm_lapic_reg_write(vcpu->arch.apic, APIC_ICR, (u32)data);
>     }
>
>     return 1;
> }
>
> static enum accel_exit_completion handle_accel_set_msr_irqoff(struct kvm_=
vcpu *vcpu)
> {
>     u32 msr =3D kvm_rcx_read(vcpu);
>     u64 data =3D kvm_read_edx_eax(vcpu);
>     int ret =3D 0;
>
>     switch (msr) {
>     case APIC_BASE_MSR + (APIC_ICR >> 4):
>         ret =3D handle_accel_set_x2apic_icr_irqoff(vcpu, msr, data);
>         break;
>     default:
>         return ACCEL_EXIT_NONE;
>     }
>
>     if (!ret) {
>         trace_kvm_msr_write(msr, data);
>         return ACCEL_EXIT_SKIP_EMUL_INS;
>     }
>
>     return ACCEL_EXIT_NONE;
> }
>
> > +
> > +static void vmx_handle_exit_irqoff(struct kvm_vcpu *vcpu, u32 *exit_re=
ason)
> > {
> >       struct vcpu_vmx *vmx =3D to_vmx(vcpu);
> >
> > @@ -6231,6 +6263,8 @@ static void vmx_handle_exit_irqoff(struct kvm_vcp=
u *vcpu)
> >               handle_external_interrupt_irqoff(vcpu);
> >       else if (vmx->exit_reason =3D=3D EXIT_REASON_EXCEPTION_NMI)
> >               handle_exception_nmi_irqoff(vmx);
> > +     else if (vmx->exit_reason =3D=3D EXIT_REASON_MSR_WRITE)
> > +             *exit_reason =3D handle_ipi_fastpath(vcpu);
>
> 1) This case requires a comment as the only reason it is called here is a=
n optimisation.
> In contrast to the other cases which must be called before interrupts are=
 enabled on the host.
>
> 2) I would rename handler to handle_accel_set_msr_irqoff().
> To signal this handler runs with host interrupts disabled and to make it =
a general place for accelerating WRMSRs in case we would require more in th=
e future.

Yes, TSCDEADLINE/VMX PREEMPTION TIMER is in my todo list after this
merged upstream, handle all the comments in v3, thanks for making this
nicer further. :)

    Wanpeng
