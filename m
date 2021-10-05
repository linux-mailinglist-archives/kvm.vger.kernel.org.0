Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F1673421F5B
	for <lists+kvm@lfdr.de>; Tue,  5 Oct 2021 09:21:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232717AbhJEHXK (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 5 Oct 2021 03:23:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56586 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232730AbhJEHXI (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 5 Oct 2021 03:23:08 -0400
Received: from mail-oi1-x231.google.com (mail-oi1-x231.google.com [IPv6:2607:f8b0:4864:20::231])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CE252C061745
        for <kvm@vger.kernel.org>; Tue,  5 Oct 2021 00:21:18 -0700 (PDT)
Received: by mail-oi1-x231.google.com with SMTP id s24so25005164oij.8
        for <kvm@vger.kernel.org>; Tue, 05 Oct 2021 00:21:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=t50iClouvR5wNCpxVuPLY/4woxgBaeq2YJxilfcBxqQ=;
        b=J+94v5pHqshDYiJxv8ZiKIUzq3WoDzxQ6USi+tcv2o8XFm3vczBmpRbsSeFYCnJifN
         odYbvqEwPcw/FPG1AFa9lzP83y7WHTj44NOsOKcvDNOrt2eCJoT2mBTa5fSD6OywWwkC
         BLd7H+8rRl2+Lwb/+0bqWau6yYX/qXemovS3VeePF1IlgOw3eT/n5V6CRfkBKxWwDH33
         xjAQEJ8nofWJ/EhrEhdWzEWOmkshYoBVfFgwubbO+qfY472Fn1Tyjq55esDuKfg2RSYF
         eNPLDGRBuL7G2AIaQ5t8esAthukpMn5VdNjxBaRw4SCuYZB0dtrvgP3p/lfO7xDze8VS
         4Z1g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=t50iClouvR5wNCpxVuPLY/4woxgBaeq2YJxilfcBxqQ=;
        b=LEqrXQlx8RflfO511+q+po9cUiZ2psiDK3Bie6sKT+YBC2FRCAptRt//kHbI2IiawP
         zQ87kX4jetWZdRDjEvS3nH1r+NTYfHwuuCb7sKtP6BAWOaLM9qfIz9x6jB5sCZi8bzrO
         2Wwxm+h17A/hRHQYw95pat84uhCENnfhZfCarCIBs0uEf0sDa+Cr/R1vUZqf8co9RJzw
         tAN8tYAghsCcUcycBbjmC/sV5zHtuOqmRfZQgQPlmAXTfbI+BCbg4/uQzOODRe436fW8
         nHU9b72vHCv8vgwRQ7hhjbGglIccPQMd21WvzrDWFVqYTD3TL6YR8DL2jUjBcSXx80wq
         Iw9g==
X-Gm-Message-State: AOAM530yptOzkcABxVmCAmrSOscOPGHOE1TFECkuKe49iFz8ci5wC23t
        jjxkpZWGV1bazIoy+etP0HR7urhcp7tVyf/ff6CG8g==
X-Google-Smtp-Source: ABdhPJxEaJp7LF/gYfQZpn3JIvXZDIElO6AVcWj+FJM4+9kwneOgxH1YTpeV0ZXlGKdCSSn4gfibW+UcW15ckdXKP6o=
X-Received: by 2002:a05:6808:1641:: with SMTP id az1mr1237774oib.67.1633418477949;
 Tue, 05 Oct 2021 00:21:17 -0700 (PDT)
MIME-Version: 1.0
References: <20210922124704.600087-1-tabba@google.com> <20210922124704.600087-12-tabba@google.com>
 <87tuhwr98w.wl-maz@kernel.org>
In-Reply-To: <87tuhwr98w.wl-maz@kernel.org>
From:   Fuad Tabba <tabba@google.com>
Date:   Tue, 5 Oct 2021 08:20:41 +0100
Message-ID: <CA+EHjTxH4MhqrO1G_YmYSEwLceG6xxMe4SSRbSHVtmXSSSpy4A@mail.gmail.com>
Subject: Re: [PATCH v6 11/12] KVM: arm64: Trap access to pVM restricted features
To:     Marc Zyngier <maz@kernel.org>
Cc:     kvmarm@lists.cs.columbia.edu, will@kernel.org, james.morse@arm.com,
        alexandru.elisei@arm.com, suzuki.poulose@arm.com,
        mark.rutland@arm.com, christoffer.dall@arm.com,
        pbonzini@redhat.com, drjones@redhat.com, oupton@google.com,
        qperret@google.com, kvm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, kernel-team@android.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Marc,

On Mon, Oct 4, 2021 at 6:27 PM Marc Zyngier <maz@kernel.org> wrote:
>
> Hi Fuad,
>
> On Wed, 22 Sep 2021 13:47:03 +0100,
> Fuad Tabba <tabba@google.com> wrote:
> >
> > Trap accesses to restricted features for VMs running in protected
> > mode.
> >
> > Access to feature registers are emulated, and only supported
> > features are exposed to protected VMs.
> >
> > Accesses to restricted registers as well as restricted
> > instructions are trapped, and an undefined exception is injected
> > into the protected guests, i.e., with EC = 0x0 (unknown reason).
> > This EC is the one used, according to the Arm Architecture
> > Reference Manual, for unallocated or undefined system registers
> > or instructions.
> >
> > Only affects the functionality of protected VMs. Otherwise,
> > should not affect non-protected VMs when KVM is running in
> > protected mode.
> >
> > Signed-off-by: Fuad Tabba <tabba@google.com>
> > ---
> >  arch/arm64/kvm/hyp/nvhe/switch.c | 60 ++++++++++++++++++++++++++++++++
> >  1 file changed, 60 insertions(+)
> >
> > diff --git a/arch/arm64/kvm/hyp/nvhe/switch.c b/arch/arm64/kvm/hyp/nvhe/switch.c
> > index 49080c607838..2bf5952f651b 100644
> > --- a/arch/arm64/kvm/hyp/nvhe/switch.c
> > +++ b/arch/arm64/kvm/hyp/nvhe/switch.c
> > @@ -20,6 +20,7 @@
> >  #include <asm/kprobes.h>
> >  #include <asm/kvm_asm.h>
> >  #include <asm/kvm_emulate.h>
> > +#include <asm/kvm_fixed_config.h>
> >  #include <asm/kvm_hyp.h>
> >  #include <asm/kvm_mmu.h>
> >  #include <asm/fpsimd.h>
> > @@ -28,6 +29,7 @@
> >  #include <asm/thread_info.h>
> >
> >  #include <nvhe/mem_protect.h>
> > +#include <nvhe/sys_regs.h>
> >
> >  /* Non-VHE specific context */
> >  DEFINE_PER_CPU(struct kvm_host_data, kvm_host_data);
> > @@ -158,6 +160,49 @@ static void __pmu_switch_to_host(struct kvm_cpu_context *host_ctxt)
> >               write_sysreg(pmu->events_host, pmcntenset_el0);
> >  }
> >
> > +/**
> > + * Handler for protected VM restricted exceptions.
> > + *
> > + * Inject an undefined exception into the guest and return true to indicate that
> > + * the hypervisor has handled the exit, and control should go back to the guest.
> > + */
> > +static bool kvm_handle_pvm_restricted(struct kvm_vcpu *vcpu, u64 *exit_code)
> > +{
> > +     __inject_undef64(vcpu);
> > +     return true;
> > +}
> > +
> > +/**
> > + * Handler for protected VM MSR, MRS or System instruction execution in AArch64.
> > + *
> > + * Returns true if the hypervisor has handled the exit, and control should go
> > + * back to the guest, or false if it hasn't.
> > + */
> > +static bool kvm_handle_pvm_sys64(struct kvm_vcpu *vcpu, u64 *exit_code)
> > +{
> > +     if (kvm_handle_pvm_sysreg(vcpu, exit_code))
> > +             return true;
> > +     else
> > +             return kvm_hyp_handle_sysreg(vcpu, exit_code);
>
> nit: drop the else.

Will do.

> I wonder though: what if there is an overlap between between the pVM
> handling and the normal KVM stuff? Are we guaranteed that there is
> none?
>
> For example, ESR_ELx_EC_SYS64 is used when working around some bugs
> (see the TX2 TVM handling). What happens if you return early and don't
> let it happen? This has a huge potential for some bad breakage.

This is a tough one. Especially because it's dealing with bugs, there
is no guarantee really. I think that for the TVM handling there is no
overlap and the TVM handling code in kvm_hyp_handle_sysreg() will be
invoked. However, workarounds could always be added, and if that
happens, we need to make sure that they're on all paths. One solution
is to make sure that such code is in a common function called by both
paths. Not sure how we could enforce that other than by documenting
it.

What do you think?

> > +}
> > +
> > +/**
> > + * Handler for protected floating-point and Advanced SIMD accesses.
> > + *
> > + * Returns true if the hypervisor has handled the exit, and control should go
> > + * back to the guest, or false if it hasn't.
> > + */
> > +static bool kvm_handle_pvm_fpsimd(struct kvm_vcpu *vcpu, u64 *exit_code)
> > +{
> > +     /* Linux guests assume support for floating-point and Advanced SIMD. */
> > +     BUILD_BUG_ON(!FIELD_GET(ARM64_FEATURE_MASK(ID_AA64PFR0_FP),
> > +                             PVM_ID_AA64PFR0_ALLOW));
> > +     BUILD_BUG_ON(!FIELD_GET(ARM64_FEATURE_MASK(ID_AA64PFR0_ASIMD),
> > +                             PVM_ID_AA64PFR0_ALLOW));
> > +
> > +     return kvm_hyp_handle_fpsimd(vcpu, exit_code);
> > +}
> > +
> >  static const exit_handler_fn hyp_exit_handlers[] = {
> >       [0 ... ESR_ELx_EC_MAX]          = NULL,
> >       [ESR_ELx_EC_CP15_32]            = kvm_hyp_handle_cp15,
> > @@ -170,8 +215,23 @@ static const exit_handler_fn hyp_exit_handlers[] = {
> >       [ESR_ELx_EC_PAC]                = kvm_hyp_handle_ptrauth,
> >  };
> >
> > +static const exit_handler_fn pvm_exit_handlers[] = {
> > +     [0 ... ESR_ELx_EC_MAX]          = NULL,
> > +     [ESR_ELx_EC_CP15_32]            = kvm_hyp_handle_cp15,
> > +     [ESR_ELx_EC_CP15_64]            = kvm_hyp_handle_cp15,
>
> Heads up, this one was bogus, and I removed it in my patches[1].
>
> But it really begs the question: given that you really don't want to
> handle any AArch32 for protected VMs, why handling anything at all the
> first place? You really should let the exit happen and let the outer
> run loop deal with it.

Good point. Will fix this.

Cheers,
/fuad

> > +     [ESR_ELx_EC_SYS64]              = kvm_handle_pvm_sys64,
> > +     [ESR_ELx_EC_SVE]                = kvm_handle_pvm_restricted,
> > +     [ESR_ELx_EC_FP_ASIMD]           = kvm_handle_pvm_fpsimd,
> > +     [ESR_ELx_EC_IABT_LOW]           = kvm_hyp_handle_iabt_low,
> > +     [ESR_ELx_EC_DABT_LOW]           = kvm_hyp_handle_dabt_low,
> > +     [ESR_ELx_EC_PAC]                = kvm_hyp_handle_ptrauth,
> > +};
> > +
> >  static const exit_handler_fn *kvm_get_exit_handler_array(struct kvm *kvm)
> >  {
> > +     if (unlikely(kvm_vm_is_protected(kvm)))
> > +             return pvm_exit_handlers;
> > +
> >       return hyp_exit_handlers;
> >  }
> >
> > --
> > 2.33.0.464.g1972c5931b-goog
> >
> >
>
> Thanks,
>
>         M.
>
> [1] https://git.kernel.org/pub/scm/linux/kernel/git/maz/arm-platforms.git/commit/?h=kvm-arm64/early-ec-handlers&id=f84ff369795ed47f2cd5e556170166ee8b3a988f
>
> --
> Without deviation from the norm, progress is not possible.
