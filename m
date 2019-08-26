Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9068D9D7FD
	for <lists+kvm@lfdr.de>; Mon, 26 Aug 2019 23:18:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726730AbfHZVSB (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 26 Aug 2019 17:18:01 -0400
Received: from mail-io1-f68.google.com ([209.85.166.68]:44880 "EHLO
        mail-io1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725866AbfHZVSB (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 26 Aug 2019 17:18:01 -0400
Received: by mail-io1-f68.google.com with SMTP id j4so32586711iog.11
        for <kvm@vger.kernel.org>; Mon, 26 Aug 2019 14:17:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=vE8tqbspCoXmKct+M0l7NyulXf44ovq5GP4DgcN/yf4=;
        b=eYJGWhV+7a+aypWvmqPPmI4THJ1dQQvXz4kTEWiJt8z4XbA+NaUbPZU0s9zg4vZO7v
         lrz7UE9YzI/xVHps1quixlAN4HoxsSy4Et9KztaYCsZy41PjpifZ6WM/977nl7YiPvA9
         9ycbRRGi5LBo8v7RZp/x8JWKokYnLIx3o3x37Yiyj8Gvn786JZQvk2RFlXCDTdpWhy4S
         Keqh4wTu53Viz8SxHpfO7Cdbdz4mt9xzBtcrwMw9qb0AJGhGoItv5r5LNVlKZ4Qq+Qc/
         kjHXzJeAe34+ZrhlUvjjsz9mRrH4KRM71XdF3WaB+3hDHiek2SRQ43H0sCyfj2QAPyqx
         rI5A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=vE8tqbspCoXmKct+M0l7NyulXf44ovq5GP4DgcN/yf4=;
        b=fQllJrDfzlkDoztEp5ycNBIsAeBUkxZ/zczwpd8ROXgTbHx2aMyvYV427ZtLSsK+9P
         /ExsfpntFzEWiKab9/GZ4aOXt3o5u7HhyotkfSwiq02MRAZR9dg98MQXf1w55NTmJXxC
         RfTqpc4/Y9ArZfJeJasYR4AS5jl/RVoQnSEhdh+CsL3EH3Bhc+GGmB3k8nVgsKJdjbc5
         cN4YO4uo3VVFjM+wP1bWfmoFRhcMBi17d+qDJ7DD1v4Y42zxDn6MNo52W/lDG8Kw9VAT
         0sbteDVSsQJ/hnh3Lun/Jwh1MTak4++C/DuIsjb4n0GZxKugMe+Q+uEULyWa+aF9JELn
         1Mkg==
X-Gm-Message-State: APjAAAUHLf3HDSFf3EJ9G7kDm0Ml8ulh8315CIcNLNlqLr46iNuO79Vd
        NbdJsLj5XrnZcJt05jbCQJtXSqQnU96IaMQmt5ZRpA==
X-Google-Smtp-Source: APXvYqyztZjeb97G1eWqbqQ4Itbpv4nWVfvMLGbgysIpeM73PWI5Hee5+wu8mHmV3lQM0oK9unVXvLHGkBPGQF43zJ8=
X-Received: by 2002:a5e:8f4d:: with SMTP id x13mr10483787iop.118.1566854279237;
 Mon, 26 Aug 2019 14:17:59 -0700 (PDT)
MIME-Version: 1.0
References: <20190826102449.142687-1-liran.alon@oracle.com> <20190826102449.142687-3-liran.alon@oracle.com>
In-Reply-To: <20190826102449.142687-3-liran.alon@oracle.com>
From:   Jim Mattson <jmattson@google.com>
Date:   Mon, 26 Aug 2019 14:17:47 -0700
Message-ID: <CALMp9eTDtZo73fCBF+ygPmT2ZmDr5-uSfZrtQSveWQBfMNPnEg@mail.gmail.com>
Subject: Re: [PATCH 2/2] KVM: x86: Fix INIT signal handling in various CPU states
To:     Liran Alon <liran.alon@oracle.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        =?UTF-8?B?UmFkaW0gS3LEjW3DocWZ?= <rkrcmar@redhat.com>,
        kvm list <kvm@vger.kernel.org>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Joao Martins <joao.m.martins@oracle.com>,
        Nikita Leshenko <nikita.leshchenko@oracle.com>,
        Marc Orr <marcorr@google.com>
Content-Type: text/plain; charset="UTF-8"
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Aug 26, 2019 at 3:25 AM Liran Alon <liran.alon@oracle.com> wrote:
>
> Commit cd7764fe9f73 ("KVM: x86: latch INITs while in system management mode")
> changed code to latch INIT while vCPU is in SMM and process latched INIT
> when leaving SMM. It left a subtle remark in commit message that similar
> treatment should also be done while vCPU is in VMX non-root-mode.
>
> However, INIT signals should actually be latched in various vCPU states:
> (*) For both Intel and AMD, INIT signals should be latched while vCPU
> is in SMM.
> (*) For Intel, INIT should also be latched while vCPU is in VMX
> operation and later processed when vCPU leaves VMX operation by
> executing VMXOFF.
> (*) For AMD, INIT should also be latched while vCPU runs with GIF=0
> or in guest-mode with intercept defined on INIT signal.
>
> To fix this:
> 1) Add kvm_x86_ops->apic_init_signal_blocked() such that each CPU vendor
> can define the various CPU states in which INIT signals should be
> blocked and modify kvm_apic_accept_events() to use it.
> 2) Modify vmx_check_nested_events() to check for pending INIT signal
> while vCPU in guest-mode. If so, emualte vmexit on
> EXIT_REASON_INIT_SIGNAL. Note that nSVM should have similar behaviour
> but is currently left as a TODO comment to implement in the future
> because nSVM don't yet implement svm_check_nested_events().
>
> Note: Currently KVM nVMX implementation don't support VMX wait-for-SIPI
> activity state as specified in MSR_IA32_VMX_MISC bits 6:8 exposed to
> guest (See nested_vmx_setup_ctls_msrs()).
> If and when support for this activity state will be implemented,
> kvm_check_nested_events() would need to avoid emulating vmexit on
> INIT signal in case activity-state is wait-for-SIPI. In addition,
> kvm_apic_accept_events() would need to be modified to avoid discarding
> SIPI in case VMX activity-state is wait-for-SIPI but instead delay
> SIPI processing to vmx_check_nested_events() that would clear
> pending APIC events and emulate vmexit on SIPI.
>
> Reviewed-by: Joao Martins <joao.m.martins@oracle.com>
> Co-developed-by: Nikita Leshenko <nikita.leshchenko@oracle.com>
> Signed-off-by: Nikita Leshenko <nikita.leshchenko@oracle.com>
> Signed-off-by: Liran Alon <liran.alon@oracle.com>

Thanks for doing this! I asked Marc to take a look at it earlier this
month, but he's been swamped.

> ---
>  arch/x86/include/asm/kvm_host.h |  2 ++
>  arch/x86/kvm/lapic.c            | 11 +++++++----
>  arch/x86/kvm/svm.c              | 20 ++++++++++++++++++++
>  arch/x86/kvm/vmx/nested.c       | 14 ++++++++++++++
>  arch/x86/kvm/vmx/vmx.c          |  6 ++++++
>  5 files changed, 49 insertions(+), 4 deletions(-)
>
> diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
> index 74e88e5edd9c..158483538181 100644
> --- a/arch/x86/include/asm/kvm_host.h
> +++ b/arch/x86/include/asm/kvm_host.h
> @@ -1209,6 +1209,8 @@ struct kvm_x86_ops {
>         uint16_t (*nested_get_evmcs_version)(struct kvm_vcpu *vcpu);
>
>         bool (*need_emulation_on_page_fault)(struct kvm_vcpu *vcpu);
> +
> +       bool (*apic_init_signal_blocked)(struct kvm_vcpu *vcpu);
>  };
>
>  struct kvm_arch_async_pf {
> diff --git a/arch/x86/kvm/lapic.c b/arch/x86/kvm/lapic.c
> index 685d17c11461..9620fe5ce8d1 100644
> --- a/arch/x86/kvm/lapic.c
> +++ b/arch/x86/kvm/lapic.c
> @@ -2702,11 +2702,14 @@ void kvm_apic_accept_events(struct kvm_vcpu *vcpu)
>                 return;
>
>         /*
> -        * INITs are latched while in SMM.  Because an SMM CPU cannot
> -        * be in KVM_MP_STATE_INIT_RECEIVED state, just eat SIPIs
> -        * and delay processing of INIT until the next RSM.
> +        * INITs are latched while CPU is in specific states.
> +        * Because a CPU cannot be in these states immediately
> +        * after it have processed an INIT signal (and thus in
> +        * KVM_MP_STATE_INIT_RECEIVED state), just eat SIPIs
> +        * and delay processing of INIT until CPU leaves
> +        * the state which latch INIT signal.
>          */
> -       if (is_smm(vcpu)) {
> +       if (kvm_x86_ops->apic_init_signal_blocked(vcpu)) {
>                 WARN_ON_ONCE(vcpu->arch.mp_state == KVM_MP_STATE_INIT_RECEIVED);
>                 if (test_bit(KVM_APIC_SIPI, &apic->pending_events))
>                         clear_bit(KVM_APIC_SIPI, &apic->pending_events);
> diff --git a/arch/x86/kvm/svm.c b/arch/x86/kvm/svm.c
> index 6462c386015d..0e43acf7bea4 100644
> --- a/arch/x86/kvm/svm.c
> +++ b/arch/x86/kvm/svm.c
> @@ -7205,6 +7205,24 @@ static bool svm_need_emulation_on_page_fault(struct kvm_vcpu *vcpu)
>         return false;
>  }
>
> +static bool svm_apic_init_signal_blocked(struct kvm_vcpu *vcpu)
> +{
> +       struct vcpu_svm *svm = to_svm(vcpu);
> +
> +       /*
> +        * TODO: Last condition latch INIT signals on vCPU when
> +        * vCPU is in guest-mode and vmcb12 defines intercept on INIT.
> +        * To properly emulate INIT intercept, SVM should also implement
> +        * kvm_x86_ops->check_nested_events() and process pending INIT
> +        * signal to cause nested_svm_vmexit(). As SVM currently don't
> +        * implement check_nested_events(), this work is delayed
> +        * for future improvement.
> +        */
> +       return is_smm(vcpu) ||
> +                  !gif_set(svm) ||
> +                  (svm->vmcb->control.intercept & (1ULL << INTERCEPT_INIT));
> +}
> +
>  static struct kvm_x86_ops svm_x86_ops __ro_after_init = {
>         .cpu_has_kvm_support = has_svm,
>         .disabled_by_bios = is_disabled,
> @@ -7341,6 +7359,8 @@ static struct kvm_x86_ops svm_x86_ops __ro_after_init = {
>         .nested_get_evmcs_version = nested_get_evmcs_version,
>
>         .need_emulation_on_page_fault = svm_need_emulation_on_page_fault,
> +
> +       .apic_init_signal_blocked = svm_apic_init_signal_blocked,
>  };
>
>  static int __init svm_init(void)
> diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
> index ced9fba32598..d655fcd04c01 100644
> --- a/arch/x86/kvm/vmx/nested.c
> +++ b/arch/x86/kvm/vmx/nested.c
> @@ -3401,6 +3401,15 @@ static int vmx_check_nested_events(struct kvm_vcpu *vcpu, bool external_intr)
>         unsigned long exit_qual;
>         bool block_nested_events =
>             vmx->nested.nested_run_pending || kvm_event_needs_reinjection(vcpu);
> +       struct kvm_lapic *apic = vcpu->arch.apic;
> +
> +       if (lapic_in_kernel(vcpu) &&
> +               test_bit(KVM_APIC_INIT, &apic->pending_events)) {
> +               if (block_nested_events)
> +                       return -EBUSY;
> +               nested_vmx_vmexit(vcpu, EXIT_REASON_INIT_SIGNAL, 0, 0);
> +               return 0;
> +       }

Suppose that L0 just finished emulating an L2 instruction with
EFLAGS.TF set. So, we've just queued up a #DB trap in
vcpu->arch.exception. On this emulated VM-exit from L2 to L1, the
guest pending debug exceptions field in the vmcs12 should get the
value of vcpu->arch.exception.payload, and the queued #DB should be
squashed.

>         if (vcpu->arch.exception.pending &&
>                 nested_vmx_check_exception(vcpu, &exit_qual)) {
> @@ -4466,7 +4475,12 @@ static int handle_vmoff(struct kvm_vcpu *vcpu)
>  {
>         if (!nested_vmx_check_permission(vcpu))
>                 return 1;
> +
>         free_nested(vcpu);
> +
> +       /* Process a latched INIT during time CPU was in VMX operation */
> +       kvm_make_request(KVM_REQ_EVENT, vcpu);
> +
>         return nested_vmx_succeed(vcpu);
>  }
>
> diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
> index b5b5b2e5dac5..5a1aa0640f2a 100644
> --- a/arch/x86/kvm/vmx/vmx.c
> +++ b/arch/x86/kvm/vmx/vmx.c
> @@ -7479,6 +7479,11 @@ static bool vmx_need_emulation_on_page_fault(struct kvm_vcpu *vcpu)
>         return false;
>  }
>
> +static bool vmx_apic_init_signal_blocked(struct kvm_vcpu *vcpu)
> +{
> +       return is_smm(vcpu) || to_vmx(vcpu)->nested.vmxon;
> +}
> +
>  static __init int hardware_setup(void)
>  {
>         unsigned long host_bndcfgs;
> @@ -7803,6 +7808,7 @@ static struct kvm_x86_ops vmx_x86_ops __ro_after_init = {
>         .get_vmcs12_pages = NULL,
>         .nested_enable_evmcs = NULL,
>         .need_emulation_on_page_fault = vmx_need_emulation_on_page_fault,
> +       .apic_init_signal_blocked = vmx_apic_init_signal_blocked,
>  };
>
>  static void vmx_cleanup_l1d_flush(void)
> --
> 2.20.1
>
