Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B740D2D8239
	for <lists+kvm@lfdr.de>; Fri, 11 Dec 2020 23:39:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2406964AbgLKWhs (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 11 Dec 2020 17:37:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35186 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2406969AbgLKWhT (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 11 Dec 2020 17:37:19 -0500
Received: from mail-oi1-x243.google.com (mail-oi1-x243.google.com [IPv6:2607:f8b0:4864:20::243])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 75078C0613D3
        for <kvm@vger.kernel.org>; Fri, 11 Dec 2020 14:36:39 -0800 (PST)
Received: by mail-oi1-x243.google.com with SMTP id q25so11644069oij.10
        for <kvm@vger.kernel.org>; Fri, 11 Dec 2020 14:36:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=me7pZBCCC6C4vmXTYs8zR2DK1M/nmZJANtE1sbs6rXY=;
        b=GpPry6NGp8B7XEE6H0c6U5/K4Vd379ySpHfSoh/gbK4XY1p+evKT1ba/h7tm/jFW3T
         hYoA2QSWGmrcRD/Mp2VoBOxVDVBn+JIz2U6JmfwBe3Sq+aDD4JpnH5aY9TO3lxt+u9m+
         fYVzobsJVDy6VgMXnvttGFCoqyDwcqeL2UdQf7ZR8JAdKlBJeCWpw2TvcJ9xfiUCvOQd
         RLh/i9b+pzhdfzWt6KEYD0ImID57bUy6JtMI4xl4KIbRpgbrbE+MI2geMo2MAiya9msF
         8FA1RRyo9UbjmU14PJLf1Z+HbE9fr/0muvIyu6zcVD9uCbKtfx8hHES1bi003BpLIa0F
         A/MA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=me7pZBCCC6C4vmXTYs8zR2DK1M/nmZJANtE1sbs6rXY=;
        b=lVcxzzshu+wHwiFam/bZ65xbE88PFXp+DrUSMDu7jhUlBj1yxm6QMe80n8cWYVi+EF
         UHOHsRFxiXI8z3O2tcroRXjANQq9b1zY5xYJpp9zypwW4TWjA7dXN5BNNacm7c2nDz+Y
         Su8B4fjjcIWr9gaKIp8dXP2NSaJ7deZ7BJdeLGY4h45ytZ28SeO+5JYj1+RycK+YS0uR
         nYlkYF51Z2dM8SJZxGErUO3hMjM8QikvgKEST9JorZjJIB1J6BoEW9XZaDeGbEJknX9u
         sBxrsK+++9Q1JddBylelIjw5MNrcBIHPX0L3XzPPdb1DHVEqmnc1wbgib/DFuKXECBc2
         gK4g==
X-Gm-Message-State: AOAM5302zHlhqNIVJTpavVhmKLOq1jhYdSnCtaF6ek+8/iVqsSPAp6ce
        N3e986s/SJFijR5NqPsCUQpfx0UQtz23YSc/KG/onw==
X-Google-Smtp-Source: ABdhPJxa6JCzF5ToMNCQopi+4YgsIiP6hy2Oo4Xz/+p2eiODWIREUVdjQG1Z3Stlk0hu9WNBiXWbHZJsSn7AKVtf5NM=
X-Received: by 2002:aca:bf0b:: with SMTP id p11mr5936446oif.6.1607726198532;
 Fri, 11 Dec 2020 14:36:38 -0800 (PST)
MIME-Version: 1.0
References: <20201006212556.882066-1-oupton@google.com>
In-Reply-To: <20201006212556.882066-1-oupton@google.com>
From:   Jim Mattson <jmattson@google.com>
Date:   Fri, 11 Dec 2020 14:36:27 -0800
Message-ID: <CALMp9eQ_iFBDRcfffhTO1Nnqpf7tPqDk=HSUqUPpF4B4kyyuNg@mail.gmail.com>
Subject: Re: [kvm-unit-tests PATCH] x86: vmx: add regression test for posted interrupts
To:     Oliver Upton <oupton@google.com>
Cc:     kvm list <kvm@vger.kernel.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Oct 6, 2020 at 2:26 PM Oliver Upton <oupton@google.com> wrote:
>
> If a guest blocks interrupts for the entirety of running in root mode
> (RFLAGS.IF=0), a pending interrupt corresponding to the posted-interrupt
> vector set in the VMCS should result in an interrupt posting to the vIRR
> at VM-entry. However, on KVM this is not the case. The pending interrupt
> is not recognized as the posted-interrupt vector and instead results in
> an external interrupt VM-exit.
>
> Add a regression test to exercise this issue.
>
> Signed-off-by: Oliver Upton <oupton@google.com>
> ---
>  lib/x86/asm/bitops.h |  8 +++++
>  x86/vmx_tests.c      | 76 ++++++++++++++++++++++++++++++++++++++++++++
>  2 files changed, 84 insertions(+)
>
> diff --git a/lib/x86/asm/bitops.h b/lib/x86/asm/bitops.h
> index 13a25ec9853d..ce5743538f65 100644
> --- a/lib/x86/asm/bitops.h
> +++ b/lib/x86/asm/bitops.h
> @@ -13,4 +13,12 @@
>
>  #define HAVE_BUILTIN_FLS 1
>
> +static inline void test_and_set_bit(long nr, unsigned long *addr)
> +{
> +       asm volatile("lock; bts %1, %0"
> +                    : "+m" (*addr)
> +                    : "Ir" (nr)
> +                    : "memory");
> +}
> +
>  #endif
> diff --git a/x86/vmx_tests.c b/x86/vmx_tests.c
> index d2084ae9e8ce..9ba9a5d452a2 100644
> --- a/x86/vmx_tests.c
> +++ b/x86/vmx_tests.c
> @@ -10430,6 +10430,81 @@ static void atomic_switch_overflow_msrs_test(void)
>                 test_skip("Test is only supported on KVM");
>  }
>
> +#define PI_VECTOR 0xe0
> +#define PI_TEST_VECTOR 0x21
> +
> +static void enable_posted_interrupts(void)
> +{
> +       void *pi_desc = alloc_page();
> +
> +       vmcs_set_bits(PIN_CONTROLS, PIN_POST_INTR);
> +       vmcs_set_bits(EXI_CONTROLS, EXI_INTA);
> +       vmcs_write(PINV, PI_VECTOR);
> +       vmcs_write(POSTED_INTR_DESC_ADDR, (u64)pi_desc);
> +}
> +
> +static unsigned long *get_pi_desc(void)
> +{
> +       return (unsigned long *)vmcs_read(POSTED_INTR_DESC_ADDR);
> +}
> +
> +static void post_interrupt(u8 vector, u32 dest)
> +{
> +       unsigned long *pi_desc = get_pi_desc();
> +
> +       test_and_set_bit(vector, pi_desc);
> +       test_and_set_bit(256, pi_desc);
> +       apic_icr_write(PI_VECTOR, dest);
> +}
> +
> +static struct vmx_posted_interrupt_test_args {
> +       bool isr_fired;
> +} vmx_posted_interrupt_test_args;
> +
> +static void vmx_posted_interrupt_test_isr(isr_regs_t *regs)
> +{
> +       volatile struct vmx_posted_interrupt_test_args *args
> +                       = &vmx_posted_interrupt_test_args;
> +
> +       args->isr_fired = true;
> +       eoi();
> +}
> +
> +static void vmx_posted_interrupt_test_guest(void)
> +{
> +       handle_irq(PI_TEST_VECTOR, vmx_posted_interrupt_test_isr);
> +       irq_enable();
> +       vmcall();
> +       asm volatile("nop");
> +       vmcall();
> +}
> +
> +static void vmx_posted_interrupt_test(void)
> +{
> +       volatile struct vmx_posted_interrupt_test_args *args
> +                       = &vmx_posted_interrupt_test_args;
> +
> +       if (!cpu_has_apicv()) {
> +               report_skip(__func__);
> +               return;
> +       }
> +
> +       enable_vid();
> +       enable_posted_interrupts();
> +       test_set_guest(vmx_posted_interrupt_test_guest);
> +
> +       enter_guest();
> +       skip_exit_vmcall();
> +
> +       irq_disable();
> +       post_interrupt(PI_TEST_VECTOR, apic_id());
> +       enter_guest();
> +
> +       skip_exit_vmcall();
> +       TEST_ASSERT(args->isr_fired);
> +       enter_guest();
> +}
> +
>  #define TEST(name) { #name, .v2 = name }
>
>  /* name/init/guest_main/exit_handler/syscall_handler/guest_regs */
> @@ -10533,5 +10608,6 @@ struct vmx_test vmx_tests[] = {
>         TEST(rdtsc_vmexit_diff_test),
>         TEST(vmx_mtf_test),
>         TEST(vmx_mtf_pdpte_test),
> +       TEST(vmx_posted_interrupt_test),
>         { NULL, NULL, NULL, NULL, NULL, {0} },
>  };
> --
> 2.28.0.806.g8561365e88-goog
>

Ping.
