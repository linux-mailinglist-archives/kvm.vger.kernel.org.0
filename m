Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1092026B964
	for <lists+kvm@lfdr.de>; Wed, 16 Sep 2020 03:31:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726273AbgIPBbg (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 15 Sep 2020 21:31:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53012 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726172AbgIPBbe (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 15 Sep 2020 21:31:34 -0400
Received: from mail-oi1-x241.google.com (mail-oi1-x241.google.com [IPv6:2607:f8b0:4864:20::241])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D36C0C06174A;
        Tue, 15 Sep 2020 18:31:33 -0700 (PDT)
Received: by mail-oi1-x241.google.com with SMTP id x14so6190289oic.9;
        Tue, 15 Sep 2020 18:31:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=XcTqkVu7zkYa856gUsq83PU17ZhqrGDVpLNgq8R1Ocg=;
        b=Vw8SR1xio5QVZt0ZYJlfOwyGU01Aab0fwS83XVnlGNNupQZXrqrzCVI4WsdLnUjc99
         Lb82aUpf8PjK+qtzcPnuqvwTR3t1fj7acngdDT7G+SUcrPSW9yIPhcBjoyVDFbxeIOh5
         /EEWtFoGLryDdWn/n50KnpZZPdtjB9tL5qgHzDS+DKzS2ZtjPPs7tuZgZSnj06/pRLCH
         +okjR6mdrV+lQM9SkS2jyiUCCvfXHntFwnV114gb/2uI6D3KxTjhywdqzJ7riMo0Cn2g
         Q7GJT5JrI+ahTjtghahtu3BtrI0tIe21K4sIWwTCaGAjWlDcseaJE8DqZQvcE/JsjpkH
         hBGQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=XcTqkVu7zkYa856gUsq83PU17ZhqrGDVpLNgq8R1Ocg=;
        b=Rm0D9tQ3kMZRe3Rq6nX27kPqqQnvx6DIS5phqzxNdMXlZW6/9DGdli1g5jPCEeqKdM
         32PV5xYaVl8fcRADlgsMsSndenQNQez6kGwDvo6WNQSKYd5P93LRxpCWE3L7eYgbKrIq
         hazk+2d8fim+PyYgK9k+4h5IZoLKWH1YMvythu9hyD9shDIvNNIMhaxLafX4JI8tRH+4
         pZxtbxok+AqeqUe7ltoazaF8ABsDSrjkcjn/ka4Rbao7GOiGXLuL2NMqt67vK93FBdBf
         4mUekQXcXGyLt6iGp1rsO0em39R/Oi+VjewsDi7abz5aYzr+tv/a7UPl75GR4a4nTzh6
         qS6A==
X-Gm-Message-State: AOAM533gzrBk3EZNe0InvA8rD5K109b8BtJrIzc7D8BX3qfZnhcRIzCM
        k9EB/SulVbvw/8B/1Wgr4u3JIw0zA8kHFEPbRuUhW+4R
X-Google-Smtp-Source: ABdhPJxvBb3MvxZdsnrRDww2ACvfEpTYcONzrB8s3WoKbwN6qGZQmg/kwgI21/UAKF/RyuxPcDwETjRdHC8MPyH1K9w=
X-Received: by 2002:a05:6808:8e5:: with SMTP id d5mr1550636oic.33.1600219893229;
 Tue, 15 Sep 2020 18:31:33 -0700 (PDT)
MIME-Version: 1.0
References: <20200915232702.15945-1-sean.j.christopherson@intel.com>
In-Reply-To: <20200915232702.15945-1-sean.j.christopherson@intel.com>
From:   Wanpeng Li <kernellwp@gmail.com>
Date:   Wed, 16 Sep 2020 09:31:22 +0800
Message-ID: <CANRm+Cx85NBnL76VoFV+DNrShp_2o+c4dgQCwNARzrAcmX1KAw@mail.gmail.com>
Subject: Re: [PATCH] KVM: x86: Add kvm_x86_ops hook to short circuit emulation
To:     Sean Christopherson <sean.j.christopherson@intel.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm <kvm@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Tom Lendacky <thomas.lendacky@amd.com>
Content-Type: text/plain; charset="UTF-8"
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, 16 Sep 2020 at 07:29, Sean Christopherson
<sean.j.christopherson@intel.com> wrote:
>
> Replace the existing kvm_x86_ops.need_emulation_on_page_fault() with a
> more generic is_emulatable(), and unconditionally call the new function
> in x86_emulate_instruction().
>
> KVM will use the generic hook to support multiple security related
> technologies that prevent emulation in one way or another.  Similar to
> the existing AMD #NPF case where emulation of the current instruction is
> not possible due to lack of information, AMD's SEV-ES and Intel's SGX
> and TDX will introduce scenarios where emulation is impossible due to
> the guest's register state being inaccessible.  And again similar to the
> existing #NPF case, emulation can be initiated by kvm_mmu_page_fault(),
> i.e. outside of the control of vendor-specific code.
>
> While the cause and architecturally visible behavior of the various
> cases are different, e.g. SGX will inject a #UD, AMD #NPF is a clean
> resume or complete shutdown, and SEV-ES and TDX "return" an error, the
> impact on the common emulation code is identical: KVM must stop
> emulation immediately and resume the guest.
>
> Query is_emulatable() in handle_ud() as well so that the
> force_emulation_prefix code doesn't incorrectly modify RIP before
> calling emulate_instruction() in the absurdly unlikely scenario that
> KVM encounters forced emulation in conjunction with "do not emulate".
>
> Cc: Tom Lendacky <thomas.lendacky@amd.com>
> Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
> ---
>  arch/x86/include/asm/kvm_host.h |  2 +-
>  arch/x86/kvm/mmu/mmu.c          | 12 ------------
>  arch/x86/kvm/svm/svm.c          | 31 ++++++++++++++++++-------------
>  arch/x86/kvm/vmx/vmx.c          | 12 ++++++------
>  arch/x86/kvm/x86.c              |  9 ++++++++-
>  5 files changed, 33 insertions(+), 33 deletions(-)
>
> diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
> index 5303dbc5c9bc..fa89511ed9d6 100644
> --- a/arch/x86/include/asm/kvm_host.h
> +++ b/arch/x86/include/asm/kvm_host.h
> @@ -1221,7 +1221,7 @@ struct kvm_x86_ops {
>
>         int (*get_msr_feature)(struct kvm_msr_entry *entry);
>
> -       bool (*need_emulation_on_page_fault)(struct kvm_vcpu *vcpu);
> +       bool (*is_emulatable)(struct kvm_vcpu *vcpu, void *insn, int insn_len);
>
>         bool (*apic_init_signal_blocked)(struct kvm_vcpu *vcpu);
>         int (*enable_direct_tlbflush)(struct kvm_vcpu *vcpu);
> diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
> index a5d0207e7189..f818a46db58c 100644
> --- a/arch/x86/kvm/mmu/mmu.c
> +++ b/arch/x86/kvm/mmu/mmu.c
> @@ -5485,18 +5485,6 @@ int kvm_mmu_page_fault(struct kvm_vcpu *vcpu, gpa_t cr2_or_gpa, u64 error_code,
>         if (!mmio_info_in_cache(vcpu, cr2_or_gpa, direct) && !is_guest_mode(vcpu))
>                 emulation_type |= EMULTYPE_ALLOW_RETRY_PF;
>  emulate:
> -       /*
> -        * On AMD platforms, under certain conditions insn_len may be zero on #NPF.
> -        * This can happen if a guest gets a page-fault on data access but the HW
> -        * table walker is not able to read the instruction page (e.g instruction
> -        * page is not present in memory). In those cases we simply restart the
> -        * guest, with the exception of AMD Erratum 1096 which is unrecoverable.
> -        */
> -       if (unlikely(insn && !insn_len)) {
> -               if (!kvm_x86_ops.need_emulation_on_page_fault(vcpu))
> -                       return 1;
> -       }
> -
>         return x86_emulate_instruction(vcpu, cr2_or_gpa, emulation_type, insn,
>                                        insn_len);
>  }
> diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
> index 03dd7bac8034..3a55495d985f 100644
> --- a/arch/x86/kvm/svm/svm.c
> +++ b/arch/x86/kvm/svm/svm.c
> @@ -3933,19 +3933,10 @@ static void enable_smi_window(struct kvm_vcpu *vcpu)
>         }
>  }
>
> -static bool svm_need_emulation_on_page_fault(struct kvm_vcpu *vcpu)
> +static bool svm_is_emulatable(struct kvm_vcpu *vcpu, void *insn, int insn_len)
>  {
> -       unsigned long cr4 = kvm_read_cr4(vcpu);
> -       bool smep = cr4 & X86_CR4_SMEP;
> -       bool smap = cr4 & X86_CR4_SMAP;
> -       bool is_user = svm_get_cpl(vcpu) == 3;
> -
> -       /*
> -        * If RIP is invalid, go ahead with emulation which will cause an
> -        * internal error exit.
> -        */
> -       if (!kvm_vcpu_gfn_to_memslot(vcpu, kvm_rip_read(vcpu) >> PAGE_SHIFT))
> -               return true;
> +       bool smep, smap, is_user;
> +       unsigned long cr4;
>
>         /*
>          * Detect and workaround Errata 1096 Fam_17h_00_0Fh.
> @@ -3987,6 +3978,20 @@ static bool svm_need_emulation_on_page_fault(struct kvm_vcpu *vcpu)
>          * instruction pointer so we will not able to workaround it. Lets
>          * print the error and request to kill the guest.
>          */
> +       if (likely(!insn || insn_len))
> +               return true;
> +
> +       /*
> +        * If RIP is invalid, go ahead with emulation which will cause an
> +        * internal error exit.
> +        */
> +       if (!kvm_vcpu_gfn_to_memslot(vcpu, kvm_rip_read(vcpu) >> PAGE_SHIFT))
> +               return true;
> +
> +       cr4 = kvm_read_cr4(vcpu);
> +       smep = cr4 & X86_CR4_SMEP;
> +       smap = cr4 & X86_CR4_SMAP;
> +       is_user = svm_get_cpl(vcpu) == 3;
>         if (smap && (!smep || is_user)) {
>                 if (!sev_guest(vcpu->kvm))
>                         return true;
> @@ -4148,7 +4153,7 @@ static struct kvm_x86_ops svm_x86_ops __initdata = {
>         .mem_enc_reg_region = svm_register_enc_region,
>         .mem_enc_unreg_region = svm_unregister_enc_region,
>
> -       .need_emulation_on_page_fault = svm_need_emulation_on_page_fault,
> +       .is_emulatable = svm_is_emulatable,
>
>         .apic_init_signal_blocked = svm_apic_init_signal_blocked,
>  };
> diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
> index 46ba2e03a892..c92717c54bf9 100644
> --- a/arch/x86/kvm/vmx/vmx.c
> +++ b/arch/x86/kvm/vmx/vmx.c
> @@ -1561,6 +1561,11 @@ static int vmx_rtit_ctl_check(struct kvm_vcpu *vcpu, u64 data)
>         return 0;
>  }
>
> +static bool vmx_is_emulatable(struct kvm_vcpu *vcpu, void *insn, int insn_len)
> +{
> +       return true;
> +}
> +
>  static int skip_emulated_instruction(struct kvm_vcpu *vcpu)
>  {
>         unsigned long rip, orig_rip;
> @@ -7843,11 +7848,6 @@ static void enable_smi_window(struct kvm_vcpu *vcpu)
>         /* RSM will cause a vmexit anyway.  */
>  }
>
> -static bool vmx_need_emulation_on_page_fault(struct kvm_vcpu *vcpu)
> -{
> -       return false;
> -}
> -
>  static bool vmx_apic_init_signal_blocked(struct kvm_vcpu *vcpu)
>  {
>         return to_vmx(vcpu)->nested.vmxon;
> @@ -8002,7 +8002,7 @@ static struct kvm_x86_ops vmx_x86_ops __initdata = {
>         .pre_leave_smm = vmx_pre_leave_smm,
>         .enable_smi_window = enable_smi_window,
>
> -       .need_emulation_on_page_fault = vmx_need_emulation_on_page_fault,
> +       .is_emulatable = vmx_is_emulatable,
>         .apic_init_signal_blocked = vmx_apic_init_signal_blocked,
>         .migrate_timers = vmx_migrate_timers,
>  };
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index 539ea1cd6020..5208217049d9 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -5707,6 +5707,9 @@ int handle_ud(struct kvm_vcpu *vcpu)
>         char sig[5]; /* ud2; .ascii "kvm" */
>         struct x86_exception e;
>
> +       if (unlikely(!kvm_x86_ops.is_emulatable(vcpu, NULL, 0)))
> +               return 1;
> +

Both VMX and SVM scenarios always fail this check.

    Wanpeng
