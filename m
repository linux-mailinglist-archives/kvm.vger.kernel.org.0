Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 276F71033E5
	for <lists+kvm@lfdr.de>; Wed, 20 Nov 2019 06:31:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726440AbfKTFbP (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 20 Nov 2019 00:31:15 -0500
Received: from mail-ot1-f65.google.com ([209.85.210.65]:35787 "EHLO
        mail-ot1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725832AbfKTFbP (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 20 Nov 2019 00:31:15 -0500
Received: by mail-ot1-f65.google.com with SMTP id c14so13164135oth.2;
        Tue, 19 Nov 2019 21:31:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=6e8SujYjRtrGbDIJN+KGArRXZzU18cG+HqyXm6ajTcU=;
        b=KxN/VUF+IVhOSAw0qmAjBYYhN8n8i7FleiBBgs+RDzfC5P7ZKHn4/cFur+w/eyi6qh
         P+KE2oSrvc6MmhBCXBD0U+KiG1Jj2EDl/hr9RXoX/960/3RNbmXE691SdBPIQe6YdCrK
         iIUwgl5Z30o8ICPFh9ay0xphKnWlGUsGdoq5LibYmKFp/MyiX/YrFiG3aDsa0jbPIsj5
         6WsV9r+UNYne+uO/ViyEaiHMJ12tIzw2Zi32OlgwG67ZZwuZHvylkIlYUbdfiZyWfVSc
         ImshTJNR9hzBgS7MVaMM9Aly6qzculUEWdS/djP51kwuWRZV5jgbD02+PAZGPzsfSdvn
         moGw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=6e8SujYjRtrGbDIJN+KGArRXZzU18cG+HqyXm6ajTcU=;
        b=Sk/gOfaK4ha0DqlHG/0HNGeT9QPPugcpvfWaOLBgxJiouHGUKjZOVQl2l5u8YOA7Hu
         LNB2z3qZT1k/B2s2A/MtJLM7ymc5zsRBVGex72g/8U7nj7qqE7A132Ttu53NpCg9GQx/
         JqU/Ikz6I0lly7hWgT+tvT4I3lvDfWM8hUo7eaBXoStdTM/3uukEs/+FfYs5R/QiYqx8
         Zr36N8bG9B7spC2hpNdRGAqerFIeEwpuQDLfwsxZrin021pjwaLmd9wCOS7cspSbisJr
         wJ0O5gcuC+X/vDeL5pU4rnTDIOLm9ZHNflW49/bFcEuWTk+BF+2qgekqpsjk3PuXQGk/
         f8ug==
X-Gm-Message-State: APjAAAW2VGWBkDl/JN88rxWcSlmBgmf5fRdIbZXhbMp2b2vqHqMSk58B
        TNyzqA3XAwhEPNYQUvioWyJXBqOu6BR+ROKprDJuDQ==
X-Google-Smtp-Source: APXvYqzK772ihafmySm5R2xJSodjlntnYnNQxtXeg20APfjEVUN6lvWidSvhHbcpi6jxXogFOn8AWBEQPxfwxqbrTFg=
X-Received: by 2002:a05:6830:4ae:: with SMTP id l14mr566844otd.185.1574227873250;
 Tue, 19 Nov 2019 21:31:13 -0800 (PST)
MIME-Version: 1.0
References: <1574221329-12370-1-git-send-email-wanpengli@tencent.com>
In-Reply-To: <1574221329-12370-1-git-send-email-wanpengli@tencent.com>
From:   Wanpeng Li <kernellwp@gmail.com>
Date:   Wed, 20 Nov 2019 13:31:05 +0800
Message-ID: <CANRm+Cx6vVywCY8mDSW6yE653gXdc6gM9zg1ZwRXTPWbs4b1ow@mail.gmail.com>
Subject: Re: [PATCH v3 1/2] KVM: VMX: FIXED+PHYSICAL mode single target IPI fastpath
To:     LKML <linux-kernel@vger.kernel.org>, kvm <kvm@vger.kernel.org>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        =?UTF-8?B?UmFkaW0gS3LEjW3DocWZ?= <rkrcmar@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Liran Alon <liran.alon@oracle.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, 20 Nov 2019 at 11:42, Wanpeng Li <kernellwp@gmail.com> wrote:
>
> From: Wanpeng Li <wanpengli@tencent.com>
>
> ICR and TSCDEADLINE MSRs write cause the main MSRs write vmexits in
> our product observation, multicast IPIs are not as common as unicast
> IPI like RESCHEDULE_VECTOR and CALL_FUNCTION_SINGLE_VECTOR etc.
>
> This patch tries to optimize x2apic physical destination mode, fixed
> delivery mode single target IPI. The fast path is invoked at
> ->handle_exit_irqoff() to emulate only the effect of the ICR write
> itself, i.e. the sending of IPIs.  Sending IPIs early in the VM-Exit
> flow reduces the latency of virtual IPIs by avoiding the expensive bits
> of transitioning from guest to host, e.g. reacquiring KVM's SRCU lock.
> Especially when running guest w/ KVM_CAP_X86_DISABLE_EXITS capability
> enabled or guest can keep running, IPI can be injected to target vCPU
> by posted-interrupt immediately.
>
> Testing on Xeon Skylake server:
>
> The virtual IPI latency from sender send to receiver receive reduces
> more than 200+ cpu cycles.
>
> Cc: Paolo Bonzini <pbonzini@redhat.com>
> Cc: Radim Kr=C4=8Dm=C3=A1=C5=99 <rkrcmar@redhat.com>
> Cc: Sean Christopherson <sean.j.christopherson@intel.com>
> Cc: Vitaly Kuznetsov <vkuznets@redhat.com>
> Cc: Liran Alon <liran.alon@oracle.com>
> Signed-off-by: Wanpeng Li <wanpengli@tencent.com>
> ---
> v2 -> v3:
>  * for both VMX and SVM
>  * vmx_handle_exit() get second parameter by value and not by pointer
>  * rename parameter to =E2=80=9Caccel_exit_completion=E2=80=9D
>  * preserve tracepoint ordering
>  * rename handler to handle_accel_set_msr_irqoff and more generic
>  * add comments above handle_accel_set_msr_irqoff
>  * msr index APIC_BASE_MSR + (APIC_ICR >> 4)
> v1 -> v2:
>  * add tracepoint
>  * Instead of a separate vcpu->fast_vmexit, set exit_reason
>   to vmx->exit_reason to -1 if the fast path succeeds.
>  * move the "kvm_skip_emulated_instruction(vcpu)" to vmx_handle_exit
>  * moving the handling into vmx_handle_exit_irqoff()
>
>  arch/x86/include/asm/kvm_host.h | 11 ++++++++--
>  arch/x86/kvm/svm.c              | 14 ++++++++----
>  arch/x86/kvm/vmx/vmx.c          | 13 ++++++++---
>  arch/x86/kvm/x86.c              | 48 +++++++++++++++++++++++++++++++++++=
++++--
>  arch/x86/kvm/x86.h              |  1 +
>  5 files changed, 76 insertions(+), 11 deletions(-)
>
> diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_h=
ost.h
> index 898ab9e..67c7889 100644
> --- a/arch/x86/include/asm/kvm_host.h
> +++ b/arch/x86/include/asm/kvm_host.h
> @@ -175,6 +175,11 @@ enum {
>         VCPU_SREG_LDTR,
>  };
>
> +enum accel_exit_completion {
> +       ACCEL_EXIT_NONE,
> +       ACCEL_EXIT_SKIP_EMUL_INS =3D -1,

Don't need to be -1 any more, I guess maintainer can clean it up if
this is the last version.

> +};
> +
>  #include <asm/kvm_emulate.h>
>
>  #define KVM_NR_MEM_OBJS 40
> @@ -1084,7 +1089,8 @@ struct kvm_x86_ops {
>         void (*tlb_flush_gva)(struct kvm_vcpu *vcpu, gva_t addr);
>
>         void (*run)(struct kvm_vcpu *vcpu);
> -       int (*handle_exit)(struct kvm_vcpu *vcpu);
> +       int (*handle_exit)(struct kvm_vcpu *vcpu,
> +               enum accel_exit_completion accel_exit);
>         int (*skip_emulated_instruction)(struct kvm_vcpu *vcpu);
>         void (*set_interrupt_shadow)(struct kvm_vcpu *vcpu, int mask);
>         u32 (*get_interrupt_shadow)(struct kvm_vcpu *vcpu);
> @@ -1134,7 +1140,8 @@ struct kvm_x86_ops {
>         int (*check_intercept)(struct kvm_vcpu *vcpu,
>                                struct x86_instruction_info *info,
>                                enum x86_intercept_stage stage);
> -       void (*handle_exit_irqoff)(struct kvm_vcpu *vcpu);
> +       void (*handle_exit_irqoff)(struct kvm_vcpu *vcpu,
> +               enum accel_exit_completion *accel_exit);
>         bool (*mpx_supported)(void);
>         bool (*xsaves_supported)(void);
>         bool (*umip_emulated)(void);
> diff --git a/arch/x86/kvm/svm.c b/arch/x86/kvm/svm.c
> index d02a73a..060b11d 100644
> --- a/arch/x86/kvm/svm.c
> +++ b/arch/x86/kvm/svm.c
> @@ -4929,7 +4929,8 @@ static void svm_get_exit_info(struct kvm_vcpu *vcpu=
, u64 *info1, u64 *info2)
>         *info2 =3D control->exit_info_2;
>  }
>
> -static int handle_exit(struct kvm_vcpu *vcpu)
> +static int handle_exit(struct kvm_vcpu *vcpu,
> +       enum accel_exit_completion accel_exit)
>  {
>         struct vcpu_svm *svm =3D to_svm(vcpu);
>         struct kvm_run *kvm_run =3D vcpu->run;
> @@ -4987,7 +4988,10 @@ static int handle_exit(struct kvm_vcpu *vcpu)
>                        __func__, svm->vmcb->control.exit_int_info,
>                        exit_code);
>
> -       if (exit_code >=3D ARRAY_SIZE(svm_exit_handlers)
> +       if (accel_exit =3D=3D ACCEL_EXIT_SKIP_EMUL_INS) {
> +               kvm_skip_emulated_instruction(vcpu);
> +               return 1;
> +       } else if (exit_code >=3D ARRAY_SIZE(svm_exit_handlers)
>             || !svm_exit_handlers[exit_code]) {
>                 vcpu_unimpl(vcpu, "svm: unexpected exit reason 0x%x\n", e=
xit_code);
>                 dump_vmcb(vcpu);
> @@ -6187,9 +6191,11 @@ static int svm_check_intercept(struct kvm_vcpu *vc=
pu,
>         return ret;
>  }
>
> -static void svm_handle_exit_irqoff(struct kvm_vcpu *vcpu)
> +static void svm_handle_exit_irqoff(struct kvm_vcpu *vcpu,
> +       enum accel_exit_completion *accel_exit)
>  {
> -
> +       if (to_svm(vcpu)->vmcb->control.exit_code =3D=3D EXIT_REASON_MSR_=
WRITE)
> +               *accel_exit =3D handle_accel_set_msr_irqoff(vcpu);
>  }
>
>  static void svm_sched_in(struct kvm_vcpu *vcpu, int cpu)
> diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
> index 621142e5..86c0a23 100644
> --- a/arch/x86/kvm/vmx/vmx.c
> +++ b/arch/x86/kvm/vmx/vmx.c
> @@ -5792,7 +5792,8 @@ void dump_vmcs(void)
>   * The guest has exited.  See if we can fix it or if we need userspace
>   * assistance.
>   */
> -static int vmx_handle_exit(struct kvm_vcpu *vcpu)
> +static int vmx_handle_exit(struct kvm_vcpu *vcpu,
> +       enum accel_exit_completion accel_exit)
>  {
>         struct vcpu_vmx *vmx =3D to_vmx(vcpu);
>         u32 exit_reason =3D vmx->exit_reason;
> @@ -5878,7 +5879,10 @@ static int vmx_handle_exit(struct kvm_vcpu *vcpu)
>                 }
>         }
>
> -       if (exit_reason < kvm_vmx_max_exit_handlers
> +       if (accel_exit =3D=3D ACCEL_EXIT_SKIP_EMUL_INS) {
> +               kvm_skip_emulated_instruction(vcpu);
> +               return 1;
> +       } else if (exit_reason < kvm_vmx_max_exit_handlers
>             && kvm_vmx_exit_handlers[exit_reason]) {
>  #ifdef CONFIG_RETPOLINE
>                 if (exit_reason =3D=3D EXIT_REASON_MSR_WRITE)
> @@ -6223,7 +6227,8 @@ static void handle_external_interrupt_irqoff(struct=
 kvm_vcpu *vcpu)
>  }
>  STACK_FRAME_NON_STANDARD(handle_external_interrupt_irqoff);
>
> -static void vmx_handle_exit_irqoff(struct kvm_vcpu *vcpu)
> +static void vmx_handle_exit_irqoff(struct kvm_vcpu *vcpu,
> +       enum accel_exit_completion *accel_exit)
>  {
>         struct vcpu_vmx *vmx =3D to_vmx(vcpu);
>
> @@ -6231,6 +6236,8 @@ static void vmx_handle_exit_irqoff(struct kvm_vcpu =
*vcpu)
>                 handle_external_interrupt_irqoff(vcpu);
>         else if (vmx->exit_reason =3D=3D EXIT_REASON_EXCEPTION_NMI)
>                 handle_exception_nmi_irqoff(vmx);
> +       else if (vmx->exit_reason =3D=3D EXIT_REASON_MSR_WRITE)
> +               *accel_exit =3D handle_accel_set_msr_irqoff(vcpu);
>  }
>
>  static bool vmx_has_emulated_msr(int index)
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index 991dd01..966c659 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -1509,6 +1509,49 @@ int kvm_emulate_wrmsr(struct kvm_vcpu *vcpu)
>  }
>  EXPORT_SYMBOL_GPL(kvm_emulate_wrmsr);
>
> +static int handle_accel_set_x2apic_icr_irqoff(struct kvm_vcpu *vcpu, u64=
 data)
> +{
> +       if (lapic_in_kernel(vcpu) && apic_x2apic_mode(vcpu->arch.apic) &&
> +               ((data & KVM_APIC_DEST_MASK) =3D=3D APIC_DEST_PHYSICAL) &=
&
> +               ((data & APIC_MODE_MASK) =3D=3D APIC_DM_FIXED)) {
> +
> +               kvm_lapic_set_reg(vcpu->arch.apic, APIC_ICR2, (u32)(data =
>> 32));
> +               return kvm_lapic_reg_write(vcpu->arch.apic, APIC_ICR, (u3=
2)data);
> +       }
> +
> +       return 1;
> +}
> +
> +/*
> + * The fast path for frequent and performance sensitive wrmsr emulation,
> + * i.e. the sending of IPI, sending IPI early in the VM-Exit flow reduce=
s
> + * the latency of virtual IPI by avoiding the expensive bits of transiti=
oning
> + * from guest to host, e.g. reacquiring KVM's SRCU lock. In contrast to =
the
> + * other cases which must be called after interrupts are enabled on the =
host.
> + */
> +enum accel_exit_completion handle_accel_set_msr_irqoff(struct kvm_vcpu *=
vcpu)
> +{
> +       u32 msr =3D kvm_rcx_read(vcpu);
> +       u64 data =3D kvm_read_edx_eax(vcpu);
> +       int ret =3D 0;
> +
> +       switch (msr) {
> +       case APIC_BASE_MSR + (APIC_ICR >> 4):
> +               ret =3D handle_accel_set_x2apic_icr_irqoff(vcpu, data);
> +               break;
> +       default:
> +               return ACCEL_EXIT_NONE;
> +       }
> +
> +       if (!ret) {
> +               trace_kvm_msr_write(msr, data);
> +               return ACCEL_EXIT_SKIP_EMUL_INS;
> +       }
> +
> +       return ACCEL_EXIT_NONE;
> +}
> +EXPORT_SYMBOL_GPL(handle_accel_set_msr_irqoff);
> +
>  /*
>   * Adapt set_msr() to msr_io()'s calling convention
>   */
> @@ -7984,6 +8027,7 @@ static int vcpu_enter_guest(struct kvm_vcpu *vcpu)
>         bool req_int_win =3D
>                 dm_request_for_irq_injection(vcpu) &&
>                 kvm_cpu_accept_dm_intr(vcpu);
> +       enum accel_exit_completion accel_exit =3D ACCEL_EXIT_NONE;
>
>         bool req_immediate_exit =3D false;
>
> @@ -8226,7 +8270,7 @@ static int vcpu_enter_guest(struct kvm_vcpu *vcpu)
>         vcpu->mode =3D OUTSIDE_GUEST_MODE;
>         smp_wmb();
>
> -       kvm_x86_ops->handle_exit_irqoff(vcpu);
> +       kvm_x86_ops->handle_exit_irqoff(vcpu, &accel_exit);
>
>         /*
>          * Consume any pending interrupts, including the possible source =
of
> @@ -8270,7 +8314,7 @@ static int vcpu_enter_guest(struct kvm_vcpu *vcpu)
>                 kvm_lapic_sync_from_vapic(vcpu);
>
>         vcpu->arch.gpa_available =3D false;
> -       r =3D kvm_x86_ops->handle_exit(vcpu);
> +       r =3D kvm_x86_ops->handle_exit(vcpu, accel_exit);
>         return r;
>
>  cancel_injection:
> diff --git a/arch/x86/kvm/x86.h b/arch/x86/kvm/x86.h
> index 29391af..f14ec14 100644
> --- a/arch/x86/kvm/x86.h
> +++ b/arch/x86/kvm/x86.h
> @@ -291,6 +291,7 @@ bool kvm_mtrr_check_gfn_range_consistency(struct kvm_=
vcpu *vcpu, gfn_t gfn,
>  bool kvm_vector_hashing_enabled(void);
>  int x86_emulate_instruction(struct kvm_vcpu *vcpu, unsigned long cr2,
>                             int emulation_type, void *insn, int insn_len)=
;
> +enum accel_exit_completion handle_accel_set_msr_irqoff(struct kvm_vcpu *=
vcpu);
>
>  #define KVM_SUPPORTED_XCR0     (XFEATURE_MASK_FP | XFEATURE_MASK_SSE \
>                                 | XFEATURE_MASK_YMM | XFEATURE_MASK_BNDRE=
GS \
> --
> 2.7.4
>
