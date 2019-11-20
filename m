Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 00BD11030C8
	for <lists+kvm@lfdr.de>; Wed, 20 Nov 2019 01:34:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727486AbfKTAeK (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 19 Nov 2019 19:34:10 -0500
Received: from mail-ot1-f67.google.com ([209.85.210.67]:35932 "EHLO
        mail-ot1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727222AbfKTAeK (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 19 Nov 2019 19:34:10 -0500
Received: by mail-ot1-f67.google.com with SMTP id f10so19690881oto.3;
        Tue, 19 Nov 2019 16:34:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=vIDPFDv14YIr7pVFE+E2prb7Qz+wtRmOQY6kwwVi08Y=;
        b=ROj16OLMWeKhISdCL0aCujoEZjbq3RfUcQIjSu8KMrWduWaRzLNQQlHNMs61mwJd75
         WC24frkhoCdFMbx/bspYbcAFj4e4rubNAOsfm2nLNiY54WfhKG8/Dt4BMa1RszOGX3D1
         FqkwSGAp7SdnJrvgfPICjTo0c9lHqDueRvt5Wv471XtVzasMZOSDG3+B/AWWjqQ9x8if
         i6oTiCvOXYEB/0ZRz5pIzpQMQBm5J7r2povxirUbTwSSc7GP4fMt8GqVKBd9pttJANVc
         GzER6NdY6bAFGVFlUPyq+tygFx8vJWurBjBA50AKtaDxub5xcHFgldQtFUv38zbFer7J
         G/Hw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=vIDPFDv14YIr7pVFE+E2prb7Qz+wtRmOQY6kwwVi08Y=;
        b=S7OFwwhcC5t4dI7HU5/eGRAroRGumZ1kgvjWt67/1i7/1qZSWV4rAToKgYpqnzf42U
         73gwAgx6ySUQVb0wL4YrcB1AoBh7mF90/S7UyDVNjRGhD15yKn8gjcTbsn6hhiFU0kQa
         EEwXiExKbSkMGD67l7j2rm4CSknuFgKof+333J4whxoDCZ8cWbOLWkwp1sKGPFKJhkJr
         sVOFbFziAxhE/nIjyW9ENpa2qKNUeHmWi+0tHBfdybcOfYAatBiZu5U8Y+02owFRIN6r
         wj1p/DOu6V+VS64DYKOEs5XEWjWAWJ/aRAPJ9262KgSdyANOJHo9XCFfemIXqo3g6Los
         RyPw==
X-Gm-Message-State: APjAAAVhpEcW1ngu4wcAphjRJoMGcoO9rCNYrZpwDZV3DZA5kjFe0C8r
        fLzT3ZtQxDeUtvM/zcI6wMGZqp6IuVQOF+SgIkA=
X-Google-Smtp-Source: APXvYqxYzK16reaX8WUbflI3mIKSk9fmdghW1jTufsZY+OLa8pFZUSlMGwqvfzf44tPnAy8e+x7p5I/QKGBQf3Ed/1M=
X-Received: by 2002:a05:6830:1697:: with SMTP id k23mr5533228otr.254.1574210047743;
 Tue, 19 Nov 2019 16:34:07 -0800 (PST)
MIME-Version: 1.0
References: <1574145389-12149-1-git-send-email-wanpengli@tencent.com>
 <20191119183658.GC25672@linux.intel.com> <4C827CE1-CF87-45BE-BE84-42ABDEA3DE8D@oracle.com>
In-Reply-To: <4C827CE1-CF87-45BE-BE84-42ABDEA3DE8D@oracle.com>
From:   Wanpeng Li <kernellwp@gmail.com>
Date:   Wed, 20 Nov 2019 08:34:00 +0800
Message-ID: <CANRm+CyOxwzOQXcPCCdzc7DGEc0dHOxaBV9SP0FYWt20JWaiSg@mail.gmail.com>
Subject: Re: [PATCH v2 1/2] KVM: VMX: FIXED+PHYSICAL mode single target IPI fastpath
To:     Liran Alon <liran.alon@oracle.com>
Cc:     Sean Christopherson <sean.j.christopherson@intel.com>,
        LKML <linux-kernel@vger.kernel.org>, kvm <kvm@vger.kernel.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        =?UTF-8?B?UmFkaW0gS3LEjW3DocWZ?= <rkrcmar@redhat.com>,
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

On Wed, 20 Nov 2019 at 02:58, Liran Alon <liran.alon@oracle.com> wrote:
>
>
>
> > On 19 Nov 2019, at 20:36, Sean Christopherson <sean.j.christopherson@in=
tel.com> wrote:
> >
> > On Tue, Nov 19, 2019 at 02:36:28PM +0800, Wanpeng Li wrote:
> >> From: Wanpeng Li <wanpengli@tencent.com>
> >>
> >> ICR and TSCDEADLINE MSRs write cause the main MSRs write vmexits in
> >> our product observation, multicast IPIs are not as common as unicast
> >> IPI like RESCHEDULE_VECTOR and CALL_FUNCTION_SINGLE_VECTOR etc.
> >>
> >> This patch tries to optimize x2apic physical destination mode, fixed
> >> delivery mode single target IPI by delivering IPI to receiver as soon
> >> as possible after sender writes ICR vmexit to avoid various checks
> >> when possible, especially when running guest w/ --overcommit cpu-pm=3D=
on
> >> or guest can keep running, IPI can be injected to target vCPU by
> >> posted-interrupt immediately.
> >>
> >> Testing on Xeon Skylake server:
> >>
> >> The virtual IPI latency from sender send to receiver receive reduces
> >> more than 200+ cpu cycles.
> >>
> >> Signed-off-by: Wanpeng Li <wanpengli@tencent.com>
> >> ---
> >> v1 -> v2:
> >> * add tracepoint
> >> * Instead of a separate vcpu->fast_vmexit, set exit_reason
> >>   to vmx->exit_reason to -1 if the fast path succeeds.
> >> * move the "kvm_skip_emulated_instruction(vcpu)" to vmx_handle_exit
> >> * moving the handling into vmx_handle_exit_irqoff()
> >>
> >> arch/x86/include/asm/kvm_host.h |  4 ++--
> >> arch/x86/include/uapi/asm/vmx.h |  1 +
> >> arch/x86/kvm/svm.c              |  4 ++--
> >> arch/x86/kvm/vmx/vmx.c          | 40 +++++++++++++++++++++++++++++++++=
++++---
> >> arch/x86/kvm/x86.c              |  5 +++--
> >> 5 files changed, 45 insertions(+), 9 deletions(-)
> >>
> >> diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kv=
m_host.h
> >> index 898ab9e..0daafa9 100644
> >> --- a/arch/x86/include/asm/kvm_host.h
> >> +++ b/arch/x86/include/asm/kvm_host.h
> >> @@ -1084,7 +1084,7 @@ struct kvm_x86_ops {
> >>      void (*tlb_flush_gva)(struct kvm_vcpu *vcpu, gva_t addr);
> >>
> >>      void (*run)(struct kvm_vcpu *vcpu);
> >> -    int (*handle_exit)(struct kvm_vcpu *vcpu);
> >> +    int (*handle_exit)(struct kvm_vcpu *vcpu, u32 *vcpu_exit_reason);
> >>      int (*skip_emulated_instruction)(struct kvm_vcpu *vcpu);
> >>      void (*set_interrupt_shadow)(struct kvm_vcpu *vcpu, int mask);
> >>      u32 (*get_interrupt_shadow)(struct kvm_vcpu *vcpu);
> >> @@ -1134,7 +1134,7 @@ struct kvm_x86_ops {
> >>      int (*check_intercept)(struct kvm_vcpu *vcpu,
> >>                             struct x86_instruction_info *info,
> >>                             enum x86_intercept_stage stage);
> >> -    void (*handle_exit_irqoff)(struct kvm_vcpu *vcpu);
> >> +    void (*handle_exit_irqoff)(struct kvm_vcpu *vcpu, u32 *vcpu_exit_=
reason);
> >>      bool (*mpx_supported)(void);
> >>      bool (*xsaves_supported)(void);
> >>      bool (*umip_emulated)(void);
> >> diff --git a/arch/x86/include/uapi/asm/vmx.h b/arch/x86/include/uapi/a=
sm/vmx.h
> >> index 3eb8411..b33c6e1 100644
> >> --- a/arch/x86/include/uapi/asm/vmx.h
> >> +++ b/arch/x86/include/uapi/asm/vmx.h
> >> @@ -88,6 +88,7 @@
> >> #define EXIT_REASON_XRSTORS             64
> >> #define EXIT_REASON_UMWAIT              67
> >> #define EXIT_REASON_TPAUSE              68
> >> +#define EXIT_REASON_NEED_SKIP_EMULATED_INSN -1
> >>
> >> #define VMX_EXIT_REASONS \
> >>      { EXIT_REASON_EXCEPTION_NMI,         "EXCEPTION_NMI" }, \
> >
> > Rather than pass a custom exit reason around, can we simply handle *all=
*
> > x2apic ICR writes during handle_exit_irqoff() for both VMX and SVM?  Th=
e
> > only risk I can think of is that KVM could stall too long before enabli=
ng
> > IRQs.
> >
>
> I agree that if it doesn=E2=80=99t cause to run with interrupts disabled =
then this is a nicer approach.

In x2apic cluster mode, each cluster can contain up to 16 logical IDs,
at the worst case, target vCPUs should be woken up one by one, and the
function select_idle_sibling() in scheduler is a well-known cpu burn
searching logic, I'm afraid we will extend the interrupts disabled and
preemption off time too much.

> However, I think we may generalise a bit this patch to a clear code-path =
where accelerated exit handling
> should be put. See my other reply in this email thread and tell me what y=
ou think:
> https://www.spinics.net/lists/kernel/msg3322282.html

Thanks for the nicer code-path suggestion, I will try it. :)

    Wanpeng
