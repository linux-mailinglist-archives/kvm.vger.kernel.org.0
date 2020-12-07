Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B22C82D1E19
	for <lists+kvm@lfdr.de>; Tue,  8 Dec 2020 00:08:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726820AbgLGXHO (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 7 Dec 2020 18:07:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36392 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726069AbgLGXHN (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 7 Dec 2020 18:07:13 -0500
Received: from mail-ot1-x343.google.com (mail-ot1-x343.google.com [IPv6:2607:f8b0:4864:20::343])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7BB42C061749
        for <kvm@vger.kernel.org>; Mon,  7 Dec 2020 15:06:33 -0800 (PST)
Received: by mail-ot1-x343.google.com with SMTP id 11so14172705oty.9
        for <kvm@vger.kernel.org>; Mon, 07 Dec 2020 15:06:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=ulofPqprNeMVYSi4yhjqgNnz5dj3g3XsyO+WHyCMvcw=;
        b=Eb8aUwdEwvWWaT1AlZL1ZGuuVQiOmuxszXm/lq+dxr8/B147JYxLRZJ5627LTIExfH
         rqDm5IViR3YpwmNNEmIRSTC6vwsaIwuPceawkJVeRnAro5jEaLiXgMnovOc79c1tL/1R
         qwEKjSIRCba6j6Dag3jaqp5oVhoG36KBKQ3uUPiryvb2iHWv4mcFV5Xc8n/JeOkamm8j
         IJTjZOcao55qbf+RFDtndSpWlN5WvY6aNPLqKG9TewNfs7orwoHAM4H/y0WVQXY6vT7U
         UCKyCKiM1XrvvaoIdOqn5KFZXL8QP/2QM6ubHdZpEjgS845+pYSjX0x0RP+xlQ5nx+BM
         A8Fg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=ulofPqprNeMVYSi4yhjqgNnz5dj3g3XsyO+WHyCMvcw=;
        b=Dl8jb+UTdcrMo3ooi25qoVIOwVnutGg3MG8mSOuMcvaAjm7bA8bXheEiQMCci/pu/C
         VFJaqfH06p/Jkp8QzEakSvqpBr4FTArKp9yN5aPInURZcP9i9JQEY04q8AeDbjY3MItg
         B4nMVSWuJ0/m7+b7RM20lmChytMKanNdZzxthb0Q+9lmxpLkJOjfd54BTipXOwMnF4fE
         eyx+D1wQ5UR+UwhwdZCNHtjihsdwJ4fFsw21JiCqTERrVjrWLGe5uYH8QOt1xZkhGrLH
         oQGTGNTtBwt4IhclEr7AB/LmTjiCnUGz1lT7nboVuj6EJ7MDk8k0xSxtR7G26wtZyneC
         FepQ==
X-Gm-Message-State: AOAM5303pB/VAn2GKW/Zo42TtK0aD9CR0M55BUrgZugh0uRVJ5yRi/nN
        EJweOaqcl/RNugQZ5wCQ+8Dh5OAuHJBIWmvVHUBdpw==
X-Google-Smtp-Source: ABdhPJyrIfCqqsv11cZjIl0Vi/kpxCLyk/QZfiCC4V2m3aU63hwdBTonC+y9wBpD4seSHkAHNNKYcpnyRQagin+INB8=
X-Received: by 2002:a9d:5f9a:: with SMTP id g26mr8057191oti.241.1607382392473;
 Mon, 07 Dec 2020 15:06:32 -0800 (PST)
MIME-Version: 1.0
References: <160738054169.28590.5171339079028237631.stgit@bmoger-ubuntu> <160738067970.28590.1275116532320186155.stgit@bmoger-ubuntu>
In-Reply-To: <160738067970.28590.1275116532320186155.stgit@bmoger-ubuntu>
From:   Jim Mattson <jmattson@google.com>
Date:   Mon, 7 Dec 2020 15:06:21 -0800
Message-ID: <CALMp9eRSvWemdiBygMJ18yP9T0UzL0nNbpD__bRis7M5LqOK+g@mail.gmail.com>
Subject: Re: [PATCH 2/2] KVM: SVM: Add support for Virtual SPEC_CTRL
To:     Babu Moger <babu.moger@amd.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        "Yu, Fenghua" <fenghua.yu@intel.com>,
        Tony Luck <tony.luck@intel.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        kvm list <kvm@vger.kernel.org>,
        Tom Lendacky <thomas.lendacky@amd.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Sean Christopherson <seanjc@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        "the arch/x86 maintainers" <x86@kernel.org>,
        kyung.min.park@intel.com, LKML <linux-kernel@vger.kernel.org>,
        Krish Sadhukhan <krish.sadhukhan@oracle.com>,
        "H . Peter Anvin" <hpa@zytor.com>, mgross@linux.intel.com,
        Vitaly Kuznetsov <vkuznets@redhat.com>, kim.phillips@amd.com,
        wei.huang2@amd.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Dec 7, 2020 at 2:38 PM Babu Moger <babu.moger@amd.com> wrote:
>
> Newer AMD processors have a feature to virtualize the use of the
> SPEC_CTRL MSR. When supported, the SPEC_CTRL MSR is automatically
> virtualized and no longer requires hypervisor intervention.
>
> This feature is detected via CPUID function 0x8000000A_EDX[20]:
> GuestSpecCtrl.
>
> Hypervisors are not required to enable this feature since it is
> automatically enabled on processors that support it.
>
> When this feature is enabled, the hypervisor no longer has to
> intercept the usage of the SPEC_CTRL MSR and no longer is required to
> save and restore the guest SPEC_CTRL setting when switching
> hypervisor/guest modes.  The effective SPEC_CTRL setting is the guest
> SPEC_CTRL setting or'ed with the hypervisor SPEC_CTRL setting. This
> allows the hypervisor to ensure a minimum SPEC_CTRL if desired.
>
> This support also fixes an issue where a guest may sometimes see an
> inconsistent value for the SPEC_CTRL MSR on processors that support
> this feature. With the current SPEC_CTRL support, the first write to
> SPEC_CTRL is intercepted and the virtualized version of the SPEC_CTRL
> MSR is not updated. When the guest reads back the SPEC_CTRL MSR, it
> will be 0x0, instead of the actual expected value. There isn=E2=80=99t a
> security concern here, because the host SPEC_CTRL value is or=E2=80=99ed =
with
> the Guest SPEC_CTRL value to generate the effective SPEC_CTRL value.
> KVM writes with the guest's virtualized SPEC_CTRL value to SPEC_CTRL
> MSR just before the VMRUN, so it will always have the actual value
> even though it doesn=E2=80=99t appear that way in the guest. The guest wi=
ll
> only see the proper value for the SPEC_CTRL register if the guest was
> to write to the SPEC_CTRL register again. With Virtual SPEC_CTRL
> support, the MSR interception of SPEC_CTRL is disabled during
> vmcb_init, so this will no longer be an issue.
>
> Signed-off-by: Babu Moger <babu.moger@amd.com>
> ---

Shouldn't there be some code to initialize a new "guest SPEC_CTRL"
value in the VMCB, both at vCPU creation, and at virtual processor
reset?

>  arch/x86/kvm/svm/svm.c |   17 ++++++++++++++---
>  1 file changed, 14 insertions(+), 3 deletions(-)
>
> diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
> index 79b3a564f1c9..3d73ec0cdb87 100644
> --- a/arch/x86/kvm/svm/svm.c
> +++ b/arch/x86/kvm/svm/svm.c
> @@ -1230,6 +1230,14 @@ static void init_vmcb(struct vcpu_svm *svm)
>
>         svm_check_invpcid(svm);
>
> +       /*
> +        * If the host supports V_SPEC_CTRL then disable the interception
> +        * of MSR_IA32_SPEC_CTRL.
> +        */
> +       if (boot_cpu_has(X86_FEATURE_V_SPEC_CTRL))
> +               set_msr_interception(&svm->vcpu, svm->msrpm, MSR_IA32_SPE=
C_CTRL,
> +                                    1, 1);
> +
>         if (kvm_vcpu_apicv_active(&svm->vcpu))
>                 avic_init_vmcb(svm);
>
> @@ -3590,7 +3598,8 @@ static __no_kcsan fastpath_t svm_vcpu_run(struct kv=
m_vcpu *vcpu)
>          * is no need to worry about the conditional branch over the wrms=
r
>          * being speculatively taken.
>          */
> -       x86_spec_ctrl_set_guest(svm->spec_ctrl, svm->virt_spec_ctrl);
> +       if (!static_cpu_has(X86_FEATURE_V_SPEC_CTRL))
> +               x86_spec_ctrl_set_guest(svm->spec_ctrl, svm->virt_spec_ct=
rl);

Is this correct for the nested case? Presumably, there is now a "guest
SPEC_CTRL" value somewhere in the VMCB. If L1 does not intercept this
MSR, then we need to transfer the "guest SPEC_CTRL" value from the
vmcb01 to the vmcb02, don't we?

>         svm_vcpu_enter_exit(vcpu, svm);
>
> @@ -3609,12 +3618,14 @@ static __no_kcsan fastpath_t svm_vcpu_run(struct =
kvm_vcpu *vcpu)
>          * If the L02 MSR bitmap does not intercept the MSR, then we need=
 to
>          * save it.
>          */
> -       if (unlikely(!msr_write_intercepted(vcpu, MSR_IA32_SPEC_CTRL)))
> +       if (!static_cpu_has(X86_FEATURE_V_SPEC_CTRL) &&
> +           unlikely(!msr_write_intercepted(vcpu, MSR_IA32_SPEC_CTRL)))
>                 svm->spec_ctrl =3D native_read_msr(MSR_IA32_SPEC_CTRL);

Is this correct for the nested case? If L1 does not intercept this
MSR, then it might have changed while L2 is running. Presumably, the
hardware has stored the new value somewhere in the vmcb02 at #VMEXIT,
but now we need to move that value into the vmcb01, don't we?

>         reload_tss(vcpu);
>
> -       x86_spec_ctrl_restore_host(svm->spec_ctrl, svm->virt_spec_ctrl);
> +       if (!static_cpu_has(X86_FEATURE_V_SPEC_CTRL))
> +               x86_spec_ctrl_restore_host(svm->spec_ctrl, svm->virt_spec=
_ctrl);
>
>         vcpu->arch.cr2 =3D svm->vmcb->save.cr2;
>         vcpu->arch.regs[VCPU_REGS_RAX] =3D svm->vmcb->save.rax;
>

It would be great if you could add some tests to kvm-unit-tests.
