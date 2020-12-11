Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B8E5B2D82D7
	for <lists+kvm@lfdr.de>; Sat, 12 Dec 2020 00:43:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2406963AbgLKXmT (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 11 Dec 2020 18:42:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45144 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2394297AbgLKXmI (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 11 Dec 2020 18:42:08 -0500
Received: from mail-lj1-x243.google.com (mail-lj1-x243.google.com [IPv6:2a00:1450:4864:20::243])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 07D63C0613D6
        for <kvm@vger.kernel.org>; Fri, 11 Dec 2020 15:41:28 -0800 (PST)
Received: by mail-lj1-x243.google.com with SMTP id y16so12877710ljk.1
        for <kvm@vger.kernel.org>; Fri, 11 Dec 2020 15:41:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=B5oYtcI05/HUW08c5nQkZJHcJp3VMffDMRCN8r5A5m4=;
        b=fc66hbjDdZafO62K/7t7EDZ2tiN4nQgytRslt/72mIEzRQzzDx/xcEWjjHKIHYsGSh
         +RhZPpx7QCdvh5UX/Dudxo9mGnaRNm0FUur9feaJLGz/i5hOjWhiHQIOp7jE+zVkNND4
         DupSuTfbq5xhMA/j9V2FaVLa+dTSPoGdLLVNPLAkTxPOAuAOGmjN54L2/kwnHyI3RsSM
         Vz+vjdyeYcP8M8Fx9Igv9hoOdAQO977pLj7G3x+1Lagv7pGpcLTJVhhGx1G768gOQPON
         I9yqvAejbmEd9G2rHyPqdpI9LSZy57SzbE2BkqDlGb2ghMJaJoQGJ4DdcHMCrtjEj697
         fVCA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=B5oYtcI05/HUW08c5nQkZJHcJp3VMffDMRCN8r5A5m4=;
        b=owCW9c6B7Za6yLaq//f1hw61Wyo8RlOl065ONygUKd11/azWtSUXTWCVQX47cB3ySQ
         GeOVZuW1TtZMmDSkSh7+BK0uwRR9gOz9Lhhi0PPYtqE7fTc5vILX9cWo1cHRAp+cz6OB
         Crqk9CA+/Os6ggsbGttIu9BxznzpUyKBWLCPByRCtLHxfQJJvVMGrNWmnbzcBeA0InMm
         5n8/1pN6G59BRxVp0zV3JVnY/E+gXo2Q5Z3TjcrOhaJUQ82T1Mn9khk2w4Wuwwfb3A5u
         LgZqLW/IQOgX/gDkEhJ6a8QvJjox34CAfID8WM7NSCkF1J6uXW0Tj0gakpuYB7qqoj9v
         7ASQ==
X-Gm-Message-State: AOAM531Ij23kg5cA4bSSnOZvh2zwi9CeBG9bU5mJpv0nM9w4OOsc6GkT
        3UIT2ouf47J1frWRG9jzTbPsl7nQuOKohYceRNoRjw==
X-Google-Smtp-Source: ABdhPJzNnCt3vSEc2ApPy3kL6tgqiT6kt/2Cue/d/pTvBgn2knNkTvz7+2FYJTl4ygClcLNxZmwDZ7CeqEAeFu4FfCE=
X-Received: by 2002:a2e:b4ab:: with SMTP id q11mr5752976ljm.129.1607730086194;
 Fri, 11 Dec 2020 15:41:26 -0800 (PST)
MIME-Version: 1.0
References: <20201006212556.882066-1-oupton@google.com> <18085741-6370-bde6-0f28-fa788d5b68e5@redhat.com>
In-Reply-To: <18085741-6370-bde6-0f28-fa788d5b68e5@redhat.com>
From:   Oliver Upton <oupton@google.com>
Date:   Fri, 11 Dec 2020 17:41:15 -0600
Message-ID: <CAOQ_QsjABDVuaKJYSxZOMga4JbJkzQFnZPQJkx2F-XVEahtDqQ@mail.gmail.com>
Subject: Re: [kvm-unit-tests PATCH] x86: vmx: add regression test for posted interrupts
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm list <kvm@vger.kernel.org>, Jim Mattson <jmattson@google.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Dec 11, 2020 at 5:20 PM Paolo Bonzini <pbonzini@redhat.com> wrote:
>
> On 06/10/20 23:25, Oliver Upton wrote:
> > If a guest blocks interrupts for the entirety of running in root mode
> > (RFLAGS.IF=0), a pending interrupt corresponding to the posted-interrupt
> > vector set in the VMCS should result in an interrupt posting to the vIRR
> > at VM-entry. However, on KVM this is not the case. The pending interrupt
> > is not recognized as the posted-interrupt vector and instead results in
> > an external interrupt VM-exit.
> >
> > Add a regression test to exercise this issue.
> >
> > Signed-off-by: Oliver Upton <oupton@google.com>
>
> I am a bit confused.  Is this testing the KVM or the bare metal
> behavior?  Or was this fixed in KVM already?

This is a directed test case for
25bb2cf97139 ("KVM: nVMX: Morph notification vector IRQ on nested
VM-Enter to pending PI")

My local version of this patch has changed a bit. I'll send a v2 shortly.

--
Thanks,
Oliver

>
> Paolo
>
> > ---
> >   lib/x86/asm/bitops.h |  8 +++++
> >   x86/vmx_tests.c      | 76 ++++++++++++++++++++++++++++++++++++++++++++
> >   2 files changed, 84 insertions(+)
> >
> > diff --git a/lib/x86/asm/bitops.h b/lib/x86/asm/bitops.h
> > index 13a25ec9853d..ce5743538f65 100644
> > --- a/lib/x86/asm/bitops.h
> > +++ b/lib/x86/asm/bitops.h
> > @@ -13,4 +13,12 @@
> >
> >   #define HAVE_BUILTIN_FLS 1
> >
> > +static inline void test_and_set_bit(long nr, unsigned long *addr)
> > +{
> > +     asm volatile("lock; bts %1, %0"
> > +                  : "+m" (*addr)
> > +                  : "Ir" (nr)
> > +                  : "memory");
> > +}
> > +
> >   #endif
> > diff --git a/x86/vmx_tests.c b/x86/vmx_tests.c
> > index d2084ae9e8ce..9ba9a5d452a2 100644
> > --- a/x86/vmx_tests.c
> > +++ b/x86/vmx_tests.c
> > @@ -10430,6 +10430,81 @@ static void atomic_switch_overflow_msrs_test(void)
> >               test_skip("Test is only supported on KVM");
> >   }
> >
> > +#define PI_VECTOR 0xe0
> > +#define PI_TEST_VECTOR 0x21
> > +
> > +static void enable_posted_interrupts(void)
> > +{
> > +     void *pi_desc = alloc_page();
> > +
> > +     vmcs_set_bits(PIN_CONTROLS, PIN_POST_INTR);
> > +     vmcs_set_bits(EXI_CONTROLS, EXI_INTA);
> > +     vmcs_write(PINV, PI_VECTOR);
> > +     vmcs_write(POSTED_INTR_DESC_ADDR, (u64)pi_desc);
> > +}
> > +
> > +static unsigned long *get_pi_desc(void)
> > +{
> > +     return (unsigned long *)vmcs_read(POSTED_INTR_DESC_ADDR);
> > +}
> > +
> > +static void post_interrupt(u8 vector, u32 dest)
> > +{
> > +     unsigned long *pi_desc = get_pi_desc();
> > +
> > +     test_and_set_bit(vector, pi_desc);
> > +     test_and_set_bit(256, pi_desc);
> > +     apic_icr_write(PI_VECTOR, dest);
> > +}
> > +
> > +static struct vmx_posted_interrupt_test_args {
> > +     bool isr_fired;
> > +} vmx_posted_interrupt_test_args;
> > +
> > +static void vmx_posted_interrupt_test_isr(isr_regs_t *regs)
> > +{
> > +     volatile struct vmx_posted_interrupt_test_args *args
> > +                     = &vmx_posted_interrupt_test_args;
> > +
> > +     args->isr_fired = true;
> > +     eoi();
> > +}
> > +
> > +static void vmx_posted_interrupt_test_guest(void)
> > +{
> > +     handle_irq(PI_TEST_VECTOR, vmx_posted_interrupt_test_isr);
> > +     irq_enable();
> > +     vmcall();
> > +     asm volatile("nop");
> > +     vmcall();
> > +}
> > +
> > +static void vmx_posted_interrupt_test(void)
> > +{
> > +     volatile struct vmx_posted_interrupt_test_args *args
> > +                     = &vmx_posted_interrupt_test_args;
> > +
> > +     if (!cpu_has_apicv()) {
> > +             report_skip(__func__);
> > +             return;
> > +     }
> > +
> > +     enable_vid();
> > +     enable_posted_interrupts();
> > +     test_set_guest(vmx_posted_interrupt_test_guest);
> > +
> > +     enter_guest();
> > +     skip_exit_vmcall();
> > +
> > +     irq_disable();
> > +     post_interrupt(PI_TEST_VECTOR, apic_id());
> > +     enter_guest();
> > +
> > +     skip_exit_vmcall();
> > +     TEST_ASSERT(args->isr_fired);
> > +     enter_guest();
> > +}
> > +
> >   #define TEST(name) { #name, .v2 = name }
> >
> >   /* name/init/guest_main/exit_handler/syscall_handler/guest_regs */
> > @@ -10533,5 +10608,6 @@ struct vmx_test vmx_tests[] = {
> >       TEST(rdtsc_vmexit_diff_test),
> >       TEST(vmx_mtf_test),
> >       TEST(vmx_mtf_pdpte_test),
> > +     TEST(vmx_posted_interrupt_test),
> >       { NULL, NULL, NULL, NULL, NULL, {0} },
> >   };
> >
>
