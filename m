Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B40761FC230
	for <lists+kvm@lfdr.de>; Wed, 17 Jun 2020 01:20:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726369AbgFPXRZ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 16 Jun 2020 19:17:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59900 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725849AbgFPXRX (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 16 Jun 2020 19:17:23 -0400
Received: from mail-il1-x141.google.com (mail-il1-x141.google.com [IPv6:2607:f8b0:4864:20::141])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 87CD4C061573
        for <kvm@vger.kernel.org>; Tue, 16 Jun 2020 16:17:21 -0700 (PDT)
Received: by mail-il1-x141.google.com with SMTP id t8so273176ilm.7
        for <kvm@vger.kernel.org>; Tue, 16 Jun 2020 16:17:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=2suWlJa8CpH6BIGy7EoIm2xIgo7asmnb0ube9qU2ZKk=;
        b=eq+7vwnpvebg3rd3wG9R+noiw205POdh0tWyYaRranqq/PD30SLj0QFQlCh+9IrNPE
         lPcquAIew/6yDSLJ4H7rhCnTweLD0e5EXs2SBne34BYDYeHwV34PqkgyM0XBRQcyrkBD
         ZYZE7toxMTPsLxWi3AErNt2zSzuOb4tWYafwc4eFqQsaddLZmlyEZGtVMzhvRuRwDWrR
         LncAbtZYwsRE19gQNbbvhjW7sQUEL86wM3AVn+rY3Swkqwft3mWeVNV04Y+/Q8DilSvo
         FIcLi8slFYfuV8gDATUiLWBYABJmthAIbWyzER3395cFjAf2A02yrrAJTkEkAk+cJrjS
         y+bA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=2suWlJa8CpH6BIGy7EoIm2xIgo7asmnb0ube9qU2ZKk=;
        b=XWuskszYYc7wccn9SDmxHKYkimKj8OYlDYPB2an7FfZKNQGYTUoNDhU83JaApXKSia
         soe3/OnwACwHDhjprTJhHDHRwwumHM0IsE4UvpEDQig5TCnn+nYS8VbvpFx//PwXtdDP
         SQxACJtj2X+gUAamMs3cH6a7FMs1eTcFqnxUBRy5Pvsn9ULElw9hEMR1ZVR71ZIbmMe/
         XRBKFPW4pNRGTrZ1MdFm5mxkDW/wqaDlIrfts4YgEcNmuQ/EBlBbSYU2aOgDfCAjWi/r
         kGYMAH3aM8RV7fM4WHjWkLa7n9Fds0SHpaT/sDO0+tfFxqtN9QDEMVOiV4GOJ22jpCUO
         GdtA==
X-Gm-Message-State: AOAM532wZb0bxTCVSyriwK8hx/LENh8t7wVlT5tCpqTw62kDluhI89aR
        g14yy6vfj4f3mYtnxQnNljh4HIoxkIZM/99rnFLJow==
X-Google-Smtp-Source: ABdhPJwV6lb4T8E6Us4v6aI0n/kcJpPwIFqsk2SK5vA5bPQN6SJQSZlp17j1pgg0EWXgiE6GIBwyukvNj686beLRO3I=
X-Received: by 2002:a05:6e02:1208:: with SMTP id a8mr5682459ilq.118.1592349440425;
 Tue, 16 Jun 2020 16:17:20 -0700 (PDT)
MIME-Version: 1.0
References: <159234483706.6230.13753828995249423191.stgit@bmoger-ubuntu> <159234502394.6230.5169466123693241678.stgit@bmoger-ubuntu>
In-Reply-To: <159234502394.6230.5169466123693241678.stgit@bmoger-ubuntu>
From:   Jim Mattson <jmattson@google.com>
Date:   Tue, 16 Jun 2020 16:17:09 -0700
Message-ID: <CALMp9eTxs5nb9Ay0ELVa71cmA9VPzaMSuGgW_iM2tmAVvXs4Pg@mail.gmail.com>
Subject: Re: [PATCH v2 2/3] KVM:SVM: Add extended intercept support
To:     Babu Moger <babu.moger@amd.com>
Cc:     Wanpeng Li <wanpengli@tencent.com>, Joerg Roedel <joro@8bytes.org>,
        "the arch/x86 maintainers" <x86@kernel.org>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        "H . Peter Anvin" <hpa@zytor.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        LKML <linux-kernel@vger.kernel.org>,
        kvm list <kvm@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Jun 16, 2020 at 3:03 PM Babu Moger <babu.moger@amd.com> wrote:
>
> The new intercept bits have been added in vmcb control
> area to support the interception of INVPCID instruction.
>
> The following bit is added to the VMCB layout control area
> to control intercept of INVPCID:
>
> Byte Offset     Bit(s)          Function
> 14h             2               intercept INVPCID
>
> Add the interfaces to support these extended interception.
> Also update the tracing for extended intercepts.
>
> AMD documentation for INVPCID feature is available at "AMD64
> Architecture Programmer=E2=80=99s Manual Volume 2: System Programming,
> Pub. 24593 Rev. 3.34(or later)"
>
> The documentation can be obtained at the links below:
> Link: https://www.amd.com/system/files/TechDocs/24593.pdf
> Link: https://bugzilla.kernel.org/show_bug.cgi?id=3D206537

Not your change, but this documentation is terrible. There is no
INVLPCID instruction, nor is there a PCID instruction.

> Signed-off-by: Babu Moger <babu.moger@amd.com>
> ---
>  arch/x86/include/asm/svm.h |    3 ++-
>  arch/x86/kvm/svm/nested.c  |    6 +++++-
>  arch/x86/kvm/svm/svm.c     |    1 +
>  arch/x86/kvm/svm/svm.h     |   18 ++++++++++++++++++
>  arch/x86/kvm/trace.h       |   12 ++++++++----
>  5 files changed, 34 insertions(+), 6 deletions(-)
>
> diff --git a/arch/x86/include/asm/svm.h b/arch/x86/include/asm/svm.h
> index 8a1f5382a4ea..62649fba8908 100644
> --- a/arch/x86/include/asm/svm.h
> +++ b/arch/x86/include/asm/svm.h
> @@ -61,7 +61,8 @@ struct __attribute__ ((__packed__)) vmcb_control_area {
>         u32 intercept_dr;
>         u32 intercept_exceptions;
>         u64 intercept;
> -       u8 reserved_1[40];
> +       u32 intercept_extended;
> +       u8 reserved_1[36];

It seems like a more straightforward implementation would simply
change 'u64 intercept' to 'u32 intercept[3].'

>         u16 pause_filter_thresh;
>         u16 pause_filter_count;
>         u64 iopm_base_pa;
> diff --git a/arch/x86/kvm/svm/nested.c b/arch/x86/kvm/svm/nested.c
> index 8a6db11dcb43..7f6d0f2533e2 100644
> --- a/arch/x86/kvm/svm/nested.c
> +++ b/arch/x86/kvm/svm/nested.c
> @@ -121,6 +121,7 @@ void recalc_intercepts(struct vcpu_svm *svm)
>         c->intercept_dr =3D h->intercept_dr;
>         c->intercept_exceptions =3D h->intercept_exceptions;
>         c->intercept =3D h->intercept;
> +       c->intercept_extended =3D h->intercept_extended;
>
>         if (g->int_ctl & V_INTR_MASKING_MASK) {
>                 /* We only want the cr8 intercept bits of L1 */
> @@ -142,6 +143,7 @@ void recalc_intercepts(struct vcpu_svm *svm)
>         c->intercept_dr |=3D g->intercept_dr;
>         c->intercept_exceptions |=3D g->intercept_exceptions;
>         c->intercept |=3D g->intercept;
> +       c->intercept_extended |=3D g->intercept_extended;
>  }
>
>  static void copy_vmcb_control_area(struct vmcb_control_area *dst,
> @@ -151,6 +153,7 @@ static void copy_vmcb_control_area(struct vmcb_contro=
l_area *dst,
>         dst->intercept_dr         =3D from->intercept_dr;
>         dst->intercept_exceptions =3D from->intercept_exceptions;
>         dst->intercept            =3D from->intercept;
> +       dst->intercept_extended   =3D from->intercept_extended;
>         dst->iopm_base_pa         =3D from->iopm_base_pa;
>         dst->msrpm_base_pa        =3D from->msrpm_base_pa;
>         dst->tsc_offset           =3D from->tsc_offset;
> @@ -433,7 +436,8 @@ int nested_svm_vmrun(struct vcpu_svm *svm)
>         trace_kvm_nested_intercepts(nested_vmcb->control.intercept_cr & 0=
xffff,
>                                     nested_vmcb->control.intercept_cr >> =
16,
>                                     nested_vmcb->control.intercept_except=
ions,
> -                                   nested_vmcb->control.intercept);
> +                                   nested_vmcb->control.intercept,
> +                                   nested_vmcb->control.intercept_extend=
ed);
>
>         /* Clear internal status */
>         kvm_clear_exception_queue(&svm->vcpu);
> diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
> index 9e333b91ff78..285e5e1ff518 100644
> --- a/arch/x86/kvm/svm/svm.c
> +++ b/arch/x86/kvm/svm/svm.c
> @@ -2801,6 +2801,7 @@ static void dump_vmcb(struct kvm_vcpu *vcpu)
>         pr_err("%-20s%04x\n", "dr_write:", control->intercept_dr >> 16);
>         pr_err("%-20s%08x\n", "exceptions:", control->intercept_exception=
s);
>         pr_err("%-20s%016llx\n", "intercepts:", control->intercept);
> +       pr_err("%-20s%08x\n", "intercepts (extended):", control->intercep=
t_extended);
>         pr_err("%-20s%d\n", "pause filter count:", control->pause_filter_=
count);
>         pr_err("%-20s%d\n", "pause filter threshold:",
>                control->pause_filter_thresh);
> diff --git a/arch/x86/kvm/svm/svm.h b/arch/x86/kvm/svm/svm.h
> index 6ac4c00a5d82..935d08fac03d 100644
> --- a/arch/x86/kvm/svm/svm.h
> +++ b/arch/x86/kvm/svm/svm.h
> @@ -311,6 +311,24 @@ static inline void clr_intercept(struct vcpu_svm *sv=
m, int bit)
>         recalc_intercepts(svm);
>  }
>
> +static inline void set_extended_intercept(struct vcpu_svm *svm, int bit)
> +{
> +       struct vmcb *vmcb =3D get_host_vmcb(svm);
> +
> +       vmcb->control.intercept_extended |=3D (1U << bit);
> +
> +       recalc_intercepts(svm);
> +}
> +
> +static inline void clr_extended_intercept(struct vcpu_svm *svm, int bit)
> +{
> +       struct vmcb *vmcb =3D get_host_vmcb(svm);
> +
> +       vmcb->control.intercept_extended &=3D ~(1U << bit);
> +
> +       recalc_intercepts(svm);
> +}

You wouldn't need these new functions if you defined 'u32
intercept[3],' as I suggested above. Just change set_intercept and
clr_intercept to use __set_bit and __clear_bit.

>  static inline bool is_intercept(struct vcpu_svm *svm, int bit)
>  {
>         return (svm->vmcb->control.intercept & (1ULL << bit)) !=3D 0;
> diff --git a/arch/x86/kvm/trace.h b/arch/x86/kvm/trace.h
> index b66432b015d2..5c841c42b33d 100644
> --- a/arch/x86/kvm/trace.h
> +++ b/arch/x86/kvm/trace.h
> @@ -544,14 +544,16 @@ TRACE_EVENT(kvm_nested_vmrun,
>  );
>
>  TRACE_EVENT(kvm_nested_intercepts,
> -           TP_PROTO(__u16 cr_read, __u16 cr_write, __u32 exceptions, __u=
64 intercept),
> -           TP_ARGS(cr_read, cr_write, exceptions, intercept),
> +           TP_PROTO(__u16 cr_read, __u16 cr_write, __u32 exceptions, __u=
64 intercept,
> +                    __u32 extended),
> +           TP_ARGS(cr_read, cr_write, exceptions, intercept, extended),
>
>         TP_STRUCT__entry(
>                 __field(        __u16,          cr_read         )
>                 __field(        __u16,          cr_write        )
>                 __field(        __u32,          exceptions      )
>                 __field(        __u64,          intercept       )
> +               __field(        __u32,          extended        )
>         ),
>
>         TP_fast_assign(
> @@ -559,11 +561,13 @@ TRACE_EVENT(kvm_nested_intercepts,
>                 __entry->cr_write       =3D cr_write;
>                 __entry->exceptions     =3D exceptions;
>                 __entry->intercept      =3D intercept;
> +               __entry->extended       =3D extended;
>         ),
>
> -       TP_printk("cr_read: %04x cr_write: %04x excp: %08x intercept: %01=
6llx",
> +       TP_printk("cr_read: %04x cr_write: %04x excp: %08x intercept: %01=
6llx"
> +                 "intercept (extended): %08x",
>                 __entry->cr_read, __entry->cr_write, __entry->exceptions,
> -               __entry->intercept)
> +               __entry->intercept, __entry->extended)
>  );
>  /*
>   * Tracepoint for #VMEXIT while nested
>
