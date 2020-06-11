Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1DDCA1F710A
	for <lists+kvm@lfdr.de>; Fri, 12 Jun 2020 01:50:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726369AbgFKXuu (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 11 Jun 2020 19:50:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33610 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726284AbgFKXus (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 11 Jun 2020 19:50:48 -0400
Received: from mail-io1-xd43.google.com (mail-io1-xd43.google.com [IPv6:2607:f8b0:4864:20::d43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9155CC08C5C2
        for <kvm@vger.kernel.org>; Thu, 11 Jun 2020 16:50:48 -0700 (PDT)
Received: by mail-io1-xd43.google.com with SMTP id i25so8415074iog.0
        for <kvm@vger.kernel.org>; Thu, 11 Jun 2020 16:50:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=93n58JlbTzQHwlJI2pok5svmyI/MThLFd0Aotf1DgMs=;
        b=cczANLzvQhJ1yfcj2R3/ewly07KCDishAHfcfv+SAFsZtudG5k9JcukGmFjq7GybLz
         bcfCl5rtAzypBF6JvEovR9FJjAOphIowCzsosYSDOs97ONo+yW6eGNM/yxuZB+k+3G4j
         n2FUEitUU9x1NmcbvtBnbb9H0rKf0F68FM6L066in5h7L+BC0putg0Bq0Jq0NTg4AaB8
         /vpEw+yOkbdCLHPkEbuB0OmXyMNinGZZP8mbSosL4+rC8fkjfbl0UJgUmuD0I1XfYieA
         WJsUl4TpC1IxI9Or9NKCfAacndQ1ezDArhbDekiCI6KKgBqX9rbzOTtFkJhtjBOGfRxb
         Q2xQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=93n58JlbTzQHwlJI2pok5svmyI/MThLFd0Aotf1DgMs=;
        b=Fjw0tyu6gS/I1nDlBuVgbZINtL/UgGJFY4Crp2KGq8f4xmWwYnYW75GmzRipe+2pq6
         fEp2EehLpt/TrKv6yf+wJCcOLwHOGpUGc6CVet2xeQzzvg5BWL1fVJz/EJx/pd46f3x8
         0haixJTVYS/KQ0pA4ttETnsqB1pvMpU65jaC3Tf2xehu899DJuhNZeopcbeRHCVhubn8
         Zn8xGPOGGmQU4UW+GSkySt6jvrzCejhC8kJpDVlmobZgo384Q++kzFDJIpYibsyAsCdF
         zo+rTXDD4j5Lbd+Tw+LLr0mT6hV4YRB04uewk5PK5ru198RiyAVTy8VKCwh9F1i1vuYD
         32+A==
X-Gm-Message-State: AOAM530DZWsUvNzr2I2XqDd7bR1CswoggVvo+bdvfpP3/D10DCnpvPaN
        IAhhcN3FrMzmSZRldqwofB6r35aUJd7zC66PNNAabw==
X-Google-Smtp-Source: ABdhPJyo8bDnKKBLYgtlBf951W9VZgGEt7oQKsn+a2dTFPyjqgkEcmSM2wonYqe0wTVN1CuSc1Cq099NBglXCGOuwkg=
X-Received: by 2002:a5e:a705:: with SMTP id b5mr11057427iod.12.1591919447631;
 Thu, 11 Jun 2020 16:50:47 -0700 (PDT)
MIME-Version: 1.0
References: <159191202523.31436.11959784252237488867.stgit@bmoger-ubuntu> <159191213022.31436.11150808867377936241.stgit@bmoger-ubuntu>
In-Reply-To: <159191213022.31436.11150808867377936241.stgit@bmoger-ubuntu>
From:   Jim Mattson <jmattson@google.com>
Date:   Thu, 11 Jun 2020 16:50:36 -0700
Message-ID: <CALMp9eSC-wwP50gtprpakKjPYeZ5LdDSFS6i__csVCJwUKmqjA@mail.gmail.com>
Subject: Re: [PATCH 3/3] KVM:SVM: Enable INVPCID feature on AMD
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

On Thu, Jun 11, 2020 at 2:48 PM Babu Moger <babu.moger@amd.com> wrote:
>
> The following intercept is added for INVPCID instruction:
> Code    Name            Cause
> A2h     VMEXIT_INVPCID  INVPCID instruction
>
> The following bit is added to the VMCB layout control area
> to control intercept of INVPCID:
> Byte Offset     Bit(s)    Function
> 14h             2         intercept INVPCID
>
> For the guests with nested page table (NPT) support, the INVPCID
> feature works as running it natively. KVM does not need to do any
> special handling in this case.
>
> Interceptions are required in the following cases.
> 1. If the guest tries to disable the feature when the underlying
> hardware supports it. In this case hypervisor needs to report #UD.

Per the AMD documentation, attempts to use INVPCID at CPL>0 will
result in a #GP, regardless of the intercept bit. If the guest CPUID
doesn't enumerate the feature, shouldn't the instruction raise #UD
regardless of CPL? This seems to imply that we should intercept #GP
and decode the instruction to see if we should synthesize #UD instead.

> 2. When the guest is running with shadow page table enabled, in
> this case the hypervisor needs to handle the tlbflush based on the
> type of invpcid instruction type.
>
> AMD documentation for INVPCID feature is available at "AMD64
> Architecture Programmer=E2=80=99s Manual Volume 2: System Programming,
> Pub. 24593 Rev. 3.34(or later)"
>
> The documentation can be obtained at the links below:
> Link: https://www.amd.com/system/files/TechDocs/24593.pdf
> Link: https://bugzilla.kernel.org/show_bug.cgi?id=3D206537
>
> Signed-off-by: Babu Moger <babu.moger@amd.com>
> ---
>  arch/x86/include/asm/svm.h      |    4 ++++
>  arch/x86/include/uapi/asm/svm.h |    2 ++
>  arch/x86/kvm/svm/svm.c          |   42 +++++++++++++++++++++++++++++++++=
++++++
>  3 files changed, 48 insertions(+)
>
> diff --git a/arch/x86/include/asm/svm.h b/arch/x86/include/asm/svm.h
> index 62649fba8908..6488094f67fa 100644
> --- a/arch/x86/include/asm/svm.h
> +++ b/arch/x86/include/asm/svm.h
> @@ -55,6 +55,10 @@ enum {
>         INTERCEPT_RDPRU,
>  };
>
> +/* Extended Intercept bits */
> +enum {
> +       INTERCEPT_INVPCID =3D 2,
> +};
>
>  struct __attribute__ ((__packed__)) vmcb_control_area {
>         u32 intercept_cr;
> diff --git a/arch/x86/include/uapi/asm/svm.h b/arch/x86/include/uapi/asm/=
svm.h
> index 2e8a30f06c74..522d42dfc28c 100644
> --- a/arch/x86/include/uapi/asm/svm.h
> +++ b/arch/x86/include/uapi/asm/svm.h
> @@ -76,6 +76,7 @@
>  #define SVM_EXIT_MWAIT_COND    0x08c
>  #define SVM_EXIT_XSETBV        0x08d
>  #define SVM_EXIT_RDPRU         0x08e
> +#define SVM_EXIT_INVPCID       0x0a2
>  #define SVM_EXIT_NPF           0x400
>  #define SVM_EXIT_AVIC_INCOMPLETE_IPI           0x401
>  #define SVM_EXIT_AVIC_UNACCELERATED_ACCESS     0x402
> @@ -171,6 +172,7 @@
>         { SVM_EXIT_MONITOR,     "monitor" }, \
>         { SVM_EXIT_MWAIT,       "mwait" }, \
>         { SVM_EXIT_XSETBV,      "xsetbv" }, \
> +       { SVM_EXIT_INVPCID,     "invpcid" }, \
>         { SVM_EXIT_NPF,         "npf" }, \
>         { SVM_EXIT_AVIC_INCOMPLETE_IPI,         "avic_incomplete_ipi" }, =
\
>         { SVM_EXIT_AVIC_UNACCELERATED_ACCESS,   "avic_unaccelerated_acces=
s" }, \
> diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
> index 285e5e1ff518..82d974338f68 100644
> --- a/arch/x86/kvm/svm/svm.c
> +++ b/arch/x86/kvm/svm/svm.c
> @@ -813,6 +813,11 @@ static __init void svm_set_cpu_caps(void)
>         if (boot_cpu_has(X86_FEATURE_LS_CFG_SSBD) ||
>             boot_cpu_has(X86_FEATURE_AMD_SSBD))
>                 kvm_cpu_cap_set(X86_FEATURE_VIRT_SSBD);
> +
> +       /* Enable INVPCID if both PCID and INVPCID enabled */
> +       if (boot_cpu_has(X86_FEATURE_PCID) &&
> +           boot_cpu_has(X86_FEATURE_INVPCID))
> +               kvm_cpu_cap_set(X86_FEATURE_INVPCID);
>  }
>
>  static __init int svm_hardware_setup(void)
> @@ -1099,6 +1104,17 @@ static void init_vmcb(struct vcpu_svm *svm)
>                 clr_intercept(svm, INTERCEPT_PAUSE);
>         }
>
> +       /*
> +        * Intercept INVPCID instruction only if shadow page table is
> +        * enabled. Interception is not required with nested page table.
> +        */
> +       if (boot_cpu_has(X86_FEATURE_INVPCID)) {
> +               if (!npt_enabled)
> +                       set_extended_intercept(svm, INTERCEPT_INVPCID);
> +               else
> +                       clr_extended_intercept(svm, INTERCEPT_INVPCID);
> +       }
> +
>         if (kvm_vcpu_apicv_active(&svm->vcpu))
>                 avic_init_vmcb(svm);
>
> @@ -2715,6 +2731,23 @@ static int mwait_interception(struct vcpu_svm *svm=
)
>         return nop_interception(svm);
>  }
>
> +static int invpcid_interception(struct vcpu_svm *svm)
> +{
> +       struct kvm_vcpu *vcpu =3D &svm->vcpu;
> +       unsigned long type;
> +       gva_t gva;
> +
> +       /*
> +        * For an INVPCID intercept:
> +        * EXITINFO1 provides the linear address of the memory operand.
> +        * EXITINFO2 provides the contents of the register operand.
> +        */
> +       type =3D svm->vmcb->control.exit_info_2;
> +       gva =3D svm->vmcb->control.exit_info_1;
> +
> +       return kvm_handle_invpcid_types(vcpu,  gva, type);
> +}
> +
>  static int (*const svm_exit_handlers[])(struct vcpu_svm *svm) =3D {
>         [SVM_EXIT_READ_CR0]                     =3D cr_interception,
>         [SVM_EXIT_READ_CR3]                     =3D cr_interception,
> @@ -2777,6 +2810,7 @@ static int (*const svm_exit_handlers[])(struct vcpu=
_svm *svm) =3D {
>         [SVM_EXIT_MWAIT]                        =3D mwait_interception,
>         [SVM_EXIT_XSETBV]                       =3D xsetbv_interception,
>         [SVM_EXIT_RDPRU]                        =3D rdpru_interception,
> +       [SVM_EXIT_INVPCID]                      =3D invpcid_interception,
>         [SVM_EXIT_NPF]                          =3D npf_interception,
>         [SVM_EXIT_RSM]                          =3D rsm_interception,
>         [SVM_EXIT_AVIC_INCOMPLETE_IPI]          =3D avic_incomplete_ipi_i=
nterception,
> @@ -3562,6 +3596,14 @@ static void svm_cpuid_update(struct kvm_vcpu *vcpu=
)
>         svm->nrips_enabled =3D kvm_cpu_cap_has(X86_FEATURE_NRIPS) &&
>                              guest_cpuid_has(&svm->vcpu, X86_FEATURE_NRIP=
S);
>
> +       /*
> +        * Intercept INVPCID instruction if the baremetal has the support
> +        * but the guest doesn't claim the feature.
> +        */
> +       if (boot_cpu_has(X86_FEATURE_INVPCID) &&
> +           !guest_cpuid_has(vcpu, X86_FEATURE_INVPCID))
> +               set_extended_intercept(svm, INTERCEPT_INVPCID);
> +

What if INVPCID is enabled in the guest CPUID later? Shouldn't we then
clear this intercept bit?

>         if (!kvm_vcpu_apicv_active(vcpu))
>                 return;
>
>
