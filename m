Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2AD031023B7
	for <lists+kvm@lfdr.de>; Tue, 19 Nov 2019 12:59:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727770AbfKSL7l (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 19 Nov 2019 06:59:41 -0500
Received: from mail-oi1-f195.google.com ([209.85.167.195]:46939 "EHLO
        mail-oi1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727255AbfKSL7l (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 19 Nov 2019 06:59:41 -0500
Received: by mail-oi1-f195.google.com with SMTP id n14so18601649oie.13;
        Tue, 19 Nov 2019 03:59:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=4O09fLk0awbGhr8W3v8THYqRhAXp4gJYDWRQ9Jk2IYk=;
        b=PyacJ+fa9IHaecahJcdD6PP2K7i2gbhm07GSuUtekBL8iYc/Mxm6Ooy24zv0bhR5A3
         vXh5KLuaiMoc63fWrSbMl6tRpjTubLqRXwluoi1AodVvfCe6AROgmlpuwCiE7DcCXyKW
         WBRmihvKA0oXNDFiFv3dJYpCMuWKtrzmaaeSr9e4hkvTe2IGY7nYA3+FeaC7ykwV7gTh
         yLBYXNubVzOYfwMhpc+vow0CrUbJEDSwAYb5qwqlrcSPdXMVp1jA0UD6ysTg73NQ/MU+
         Q47pIUEKagAri/2CXIbp90GheJzmG3lilzVlavzyYNBafuNQI0JvTofGUtYLewwGXTZq
         QfzA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=4O09fLk0awbGhr8W3v8THYqRhAXp4gJYDWRQ9Jk2IYk=;
        b=Iv2EWZyVA2NppQSTKrdHsWaySv/h/Y4QB2lOdoYgKpnx7+hG6P7SxVeENOAZlsihhj
         Deh3d85akPdHIYogerBbFSkGwhyKMD/rhvxPmFMDkRRQi+6NtECFWqRI7njmmnhulnmN
         nDG6L0jaKwGsp/C7kgaOyczWc/BxjXRdgWfThhxJ4hHXEYRAbdIFJsCO6T7vbiHgHua8
         Qmfxvsb0wWw+LYkKBvJ2n8GUiS5O0+U4VsxwGc2ETYeeOcYDcpWBlT+FhEDiueiHTqEb
         enYD5A78mNZcQbpnTLxziAymfzDhpgn5RlBfWfsL9VfdmP7ctdx6qYFHepxKTxt2EsYg
         InIA==
X-Gm-Message-State: APjAAAUGdfTqNV6HCQAJbhkEgzjTkBbbwnM3uftkCTUH1sWRvMzg14l7
        i2lVRpJ4bn805nyL7jMBQ+zdoEM41Utt4JdAfoo=
X-Google-Smtp-Source: APXvYqwkhqwvg0MpWSxUNPBbZ1N19daYoLmPvdXd0YR/oXcr1pjNPyXmy8m4gwha+LwwmncSGQ6575DFwRtvgkUQv10=
X-Received: by 2002:aca:ebd4:: with SMTP id j203mr3627225oih.141.1574164780151;
 Tue, 19 Nov 2019 03:59:40 -0800 (PST)
MIME-Version: 1.0
References: <1574145389-12149-1-git-send-email-wanpengli@tencent.com> <87r224gjyt.fsf@vitty.brq.redhat.com>
In-Reply-To: <87r224gjyt.fsf@vitty.brq.redhat.com>
From:   Wanpeng Li <kernellwp@gmail.com>
Date:   Tue, 19 Nov 2019 19:59:32 +0800
Message-ID: <CANRm+CzcWDvRA0+iaQZ6hd2HGRKyZpRnurghQXdagDCffKaSPg@mail.gmail.com>
Subject: Re: [PATCH v2 1/2] KVM: VMX: FIXED+PHYSICAL mode single target IPI fastpath
To:     Vitaly Kuznetsov <vkuznets@redhat.com>
Cc:     LKML <linux-kernel@vger.kernel.org>, kvm <kvm@vger.kernel.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        =?UTF-8?B?UmFkaW0gS3LEjW3DocWZ?= <rkrcmar@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>
Content-Type: text/plain; charset="UTF-8"
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, 19 Nov 2019 at 19:54, Vitaly Kuznetsov <vkuznets@redhat.com> wrote:
>
> Wanpeng Li <kernellwp@gmail.com> writes:
>
> > From: Wanpeng Li <wanpengli@tencent.com>
> >
> > ICR and TSCDEADLINE MSRs write cause the main MSRs write vmexits in
> > our product observation, multicast IPIs are not as common as unicast
> > IPI like RESCHEDULE_VECTOR and CALL_FUNCTION_SINGLE_VECTOR etc.
> >
> > This patch tries to optimize x2apic physical destination mode, fixed
> > delivery mode single target IPI by delivering IPI to receiver as soon
> > as possible after sender writes ICR vmexit to avoid various checks
> > when possible, especially when running guest w/ --overcommit cpu-pm=on
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
> >  * add tracepoint
> >  * Instead of a separate vcpu->fast_vmexit, set exit_reason
> >    to vmx->exit_reason to -1 if the fast path succeeds.
> >  * move the "kvm_skip_emulated_instruction(vcpu)" to vmx_handle_exit
> >  * moving the handling into vmx_handle_exit_irqoff()
> >
> >  arch/x86/include/asm/kvm_host.h |  4 ++--
> >  arch/x86/include/uapi/asm/vmx.h |  1 +
> >  arch/x86/kvm/svm.c              |  4 ++--
> >  arch/x86/kvm/vmx/vmx.c          | 40 +++++++++++++++++++++++++++++++++++++---
> >  arch/x86/kvm/x86.c              |  5 +++--
> >  5 files changed, 45 insertions(+), 9 deletions(-)
> >
> > diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
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
> > +     void (*handle_exit_irqoff)(struct kvm_vcpu *vcpu, u32 *vcpu_exit_reason);
> >       bool (*mpx_supported)(void);
> >       bool (*xsaves_supported)(void);
> >       bool (*umip_emulated)(void);
> > diff --git a/arch/x86/include/uapi/asm/vmx.h b/arch/x86/include/uapi/asm/vmx.h
> > index 3eb8411..b33c6e1 100644
> > --- a/arch/x86/include/uapi/asm/vmx.h
> > +++ b/arch/x86/include/uapi/asm/vmx.h
> > @@ -88,6 +88,7 @@
> >  #define EXIT_REASON_XRSTORS             64
> >  #define EXIT_REASON_UMWAIT              67
> >  #define EXIT_REASON_TPAUSE              68
> > +#define EXIT_REASON_NEED_SKIP_EMULATED_INSN -1
>
> Maybe just EXIT_REASON_INSN_SKIP ?
>
> >
> >  #define VMX_EXIT_REASONS \
> >       { EXIT_REASON_EXCEPTION_NMI,         "EXCEPTION_NMI" }, \
> > diff --git a/arch/x86/kvm/svm.c b/arch/x86/kvm/svm.c
> > index d02a73a..c8e063a 100644
> > --- a/arch/x86/kvm/svm.c
> > +++ b/arch/x86/kvm/svm.c
> > @@ -4929,7 +4929,7 @@ static void svm_get_exit_info(struct kvm_vcpu *vcpu, u64 *info1, u64 *info2)
> >       *info2 = control->exit_info_2;
> >  }
> >
> > -static int handle_exit(struct kvm_vcpu *vcpu)
> > +static int handle_exit(struct kvm_vcpu *vcpu, u32 *vcpu_exit_reason)
> >  {
> >       struct vcpu_svm *svm = to_svm(vcpu);
> >       struct kvm_run *kvm_run = vcpu->run;
> > @@ -6187,7 +6187,7 @@ static int svm_check_intercept(struct kvm_vcpu *vcpu,
> >       return ret;
> >  }
> >
> > -static void svm_handle_exit_irqoff(struct kvm_vcpu *vcpu)
> > +static void svm_handle_exit_irqoff(struct kvm_vcpu *vcpu, u32 *vcpu_exit_reason)
> >  {
> >
> >  }
> > diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
> > index 621142e5..b98198d 100644
> > --- a/arch/x86/kvm/vmx/vmx.c
> > +++ b/arch/x86/kvm/vmx/vmx.c
> > @@ -5792,7 +5792,7 @@ void dump_vmcs(void)
> >   * The guest has exited.  See if we can fix it or if we need userspace
> >   * assistance.
> >   */
> > -static int vmx_handle_exit(struct kvm_vcpu *vcpu)
> > +static int vmx_handle_exit(struct kvm_vcpu *vcpu, u32 *vcpu_exit_reason)
> >  {
> >       struct vcpu_vmx *vmx = to_vmx(vcpu);
> >       u32 exit_reason = vmx->exit_reason;
> > @@ -5878,7 +5878,10 @@ static int vmx_handle_exit(struct kvm_vcpu *vcpu)
> >               }
> >       }
> >
> > -     if (exit_reason < kvm_vmx_max_exit_handlers
> > +     if (*vcpu_exit_reason == EXIT_REASON_NEED_SKIP_EMULATED_INSN) {
> > +             kvm_skip_emulated_instruction(vcpu);
> > +             return 1;
> > +     } else if (exit_reason < kvm_vmx_max_exit_handlers
> >           && kvm_vmx_exit_handlers[exit_reason]) {
> >  #ifdef CONFIG_RETPOLINE
> >               if (exit_reason == EXIT_REASON_MSR_WRITE)
> > @@ -6223,7 +6226,36 @@ static void handle_external_interrupt_irqoff(struct kvm_vcpu *vcpu)
> >  }
> >  STACK_FRAME_NON_STANDARD(handle_external_interrupt_irqoff);
> >
> > -static void vmx_handle_exit_irqoff(struct kvm_vcpu *vcpu)
> > +static u32 handle_ipi_fastpath(struct kvm_vcpu *vcpu)
> > +{
> > +     u32 index;
> > +     u64 data;
> > +     int ret = 0;
> > +
> > +     if (lapic_in_kernel(vcpu) && apic_x2apic_mode(vcpu->arch.apic)) {
> > +             /*
> > +              * fastpath to IPI target, FIXED+PHYSICAL which is popular
> > +              */
> > +             index = kvm_rcx_read(vcpu);
> > +             data = kvm_read_edx_eax(vcpu);
> > +
> > +             if (((index - APIC_BASE_MSR) << 4 == APIC_ICR) &&
>
> What if index (RCX) is < APIC_BASE_MSR?

How about if (index == (APIC_BASE_MSR + 0x300) &&

>
> > +                     ((data & KVM_APIC_DEST_MASK) == APIC_DEST_PHYSICAL) &&
> > +                     ((data & APIC_MODE_MASK) == APIC_DM_FIXED)) {
> > +
> > +                     trace_kvm_msr_write(index, data);
> > +                     kvm_lapic_set_reg(vcpu->arch.apic, APIC_ICR2, (u32)(data >> 32));
> > +                     ret = kvm_lapic_reg_write(vcpu->arch.apic, APIC_ICR, (u32)data);
> > +
> > +                     if (ret == 0)
> > +                             return EXIT_REASON_NEED_SKIP_EMULATED_INSN;
> > +             }
> > +     }
> > +
> > +     return ret;
> > +}
> > +
> > +static void vmx_handle_exit_irqoff(struct kvm_vcpu *vcpu, u32 *exit_reason)
> >  {
> >       struct vcpu_vmx *vmx = to_vmx(vcpu);
> >
> > @@ -6231,6 +6263,8 @@ static void vmx_handle_exit_irqoff(struct kvm_vcpu *vcpu)
> >               handle_external_interrupt_irqoff(vcpu);
> >       else if (vmx->exit_reason == EXIT_REASON_EXCEPTION_NMI)
> >               handle_exception_nmi_irqoff(vmx);
> > +     else if (vmx->exit_reason == EXIT_REASON_MSR_WRITE)
> > +             *exit_reason = handle_ipi_fastpath(vcpu);
> >  }
> >
> >  static bool vmx_has_emulated_msr(int index)
> > diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> > index 991dd01..a53bce3 100644
> > --- a/arch/x86/kvm/x86.c
> > +++ b/arch/x86/kvm/x86.c
> > @@ -7981,6 +7981,7 @@ EXPORT_SYMBOL_GPL(__kvm_request_immediate_exit);
> >  static int vcpu_enter_guest(struct kvm_vcpu *vcpu)
> >  {
> >       int r;
> > +     u32 exit_reason = 0;
> >       bool req_int_win =
> >               dm_request_for_irq_injection(vcpu) &&
> >               kvm_cpu_accept_dm_intr(vcpu);
> > @@ -8226,7 +8227,7 @@ static int vcpu_enter_guest(struct kvm_vcpu *vcpu)
> >       vcpu->mode = OUTSIDE_GUEST_MODE;
> >       smp_wmb();
> >
> > -     kvm_x86_ops->handle_exit_irqoff(vcpu);
> > +     kvm_x86_ops->handle_exit_irqoff(vcpu, &exit_reason);
> >
> >       /*
> >        * Consume any pending interrupts, including the possible source of
> > @@ -8270,7 +8271,7 @@ static int vcpu_enter_guest(struct kvm_vcpu *vcpu)
> >               kvm_lapic_sync_from_vapic(vcpu);
> >
> >       vcpu->arch.gpa_available = false;
> > -     r = kvm_x86_ops->handle_exit(vcpu);
> > +     r = kvm_x86_ops->handle_exit(vcpu, &exit_reason);
> >       return r;
> >
> >  cancel_injection:
>
> --
> Vitaly
>
