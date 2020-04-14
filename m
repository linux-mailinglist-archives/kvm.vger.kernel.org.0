Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 31BF31A8F4C
	for <lists+kvm@lfdr.de>; Wed, 15 Apr 2020 01:53:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2634408AbgDNXty (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 14 Apr 2020 19:49:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43620 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731255AbgDNXtq (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 14 Apr 2020 19:49:46 -0400
Received: from mail-il1-x142.google.com (mail-il1-x142.google.com [IPv6:2607:f8b0:4864:20::142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8910EC061A0C
        for <kvm@vger.kernel.org>; Tue, 14 Apr 2020 16:43:16 -0700 (PDT)
Received: by mail-il1-x142.google.com with SMTP id i2so1489650ils.12
        for <kvm@vger.kernel.org>; Tue, 14 Apr 2020 16:43:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=nF6mcrWBKY3Lw7X3n7U2bo09XEzz3zOIBI7lwt/Nx0o=;
        b=huQw4m0fZ8/RjL+6uHE1vyttcW1Iiysatfgup9mD0O4OjvMo3loBrkfvuaPWuHXLkc
         8VTtVoltD1pLIMcl/AFRCzxYMPIUmn80NWC5NGDJlwuYqLRcLRW2w1IH6zSLVQmmeGB9
         s0nSX6cPk8MAHWuWi5tG6ajpKz9zqg6fVmyhNg7cXudspeuiAn/npTGwilXWueEZAt51
         CZ/g8ZXx+ZqGyG/hIWZoEMW2jP+H+mfgqa1b7HqRC7pPc5yRcMnl1b+zM9HDdC6hPHmn
         EJsJpClrpZndKJa6g4wOpB2s+eeM6yTxTMRDrZ00N5skVprR2E1Sk0qGCFytbODGr7oM
         jBTQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=nF6mcrWBKY3Lw7X3n7U2bo09XEzz3zOIBI7lwt/Nx0o=;
        b=cMt2qjvXT93pqi8EhyNtLSJzWvyrcMOOUhSDeEUJNj6Tc34CVcX4sUa1uxn+Dh2kXD
         fHMd3LXGhJ7rfd4qsBjl9lvOH8gUDgouNFKOsn6M3mcjMTkeZJEb7aeqE4NUhmMsoyv+
         MKHKD4PTBI8BpXc+Os6+n9OhiKfD4d/60BxKobxpafmOCHl/Fr4JkhISFV+fRhTNL/XD
         naCqgbMTjY7qDWcRc7sxEEAx9GJrBe9gGUpXUxA3TjFhr3eW2R0hyyR45qa6pHKKfx37
         megSS1n0EqwBh9NQujYEKTLqnFHW5zOR6f2kFfFtWBXv+gpGEpxbZ9Hg0erZ14NCU6FJ
         TR8w==
X-Gm-Message-State: AGi0PubcRvX+KTCFwACvOHieZnfS8+6/YnhY98zIY+gsRIHDUuQodcw9
        msbSNDmt3DTwvfYp1Bhj8IKO6qiFcgGYXGQZdzhCFg==
X-Google-Smtp-Source: APiQypJNBLb2jDg64YW05QUwgbaJX+fI8elyOEVzxDarqjrkTjj1NWqPrGr1PZdfMnk+UwceVMaVpRqbp8rpfpF6lCM=
X-Received: by 2002:a92:8bcb:: with SMTP id i194mr2764748ild.119.1586907795545;
 Tue, 14 Apr 2020 16:43:15 -0700 (PDT)
MIME-Version: 1.0
References: <20181010225653.238911-1-pshier@google.com> <CANRm+Cwq7foDTcD_jbASzV+YCiQwWuNXGjXH8Ew7a+h_ze_VEA@mail.gmail.com>
In-Reply-To: <CANRm+Cwq7foDTcD_jbASzV+YCiQwWuNXGjXH8Ew7a+h_ze_VEA@mail.gmail.com>
From:   Jim Mattson <jmattson@google.com>
Date:   Tue, 14 Apr 2020 16:43:04 -0700
Message-ID: <CALMp9eQajZRaZJ=PD-1T4JfiBqje-G1OtXEgcrwLjan3j-BC0w@mail.gmail.com>
Subject: Re: [PATCH 1/1] KVM: x86: Return updated timer current count register
 from KVM_GET_LAPIC
To:     Wanpeng Li <kernellwp@gmail.com>
Cc:     Peter Shier <pshier@google.com>, kvm <kvm@vger.kernel.org>,
        Paolo Bonzini <pbonzini@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Oct 16, 2018 at 12:53 AM Wanpeng Li <kernellwp@gmail.com> wrote:
>
> On Thu, 11 Oct 2018 at 06:59, Peter Shier <pshier@google.com> wrote:
> >
> > kvm_vcpu_ioctl_get_lapic (implements KVM_GET_LAPIC ioctl) does a bulk copy
> > of the LAPIC registers but must take into account that the one-shot and
> > periodic timer current count register is computed upon reads and is not
> > present in register state. When restoring LAPIC state (e.g. after
> > migration), restart timers from their their current count values at time of
> > save.
> >
> > Note: When a one-shot timer expires, the code in arch/x86/kvm/lapic.c does
> > not zero the value of the LAPIC initial count register (emulating HW
> > behavior). If no other timer is run and pending prior to a subsequent
> > KVM_GET_LAPIC call, the returned register set will include the expired
> > one-shot initial count. On a subsequent KVM_SET_LAPIC call the code will
> > see a non-zero initial count and start a new one-shot timer using the
> > expired timer's count. This is a prior existing bug and will be addressed
> > in a separate patch. Thanks to jmattson@google.com for this find.
> >
> > Signed-off-by: Peter Shier <pshier@google.com>
> > Reviewed-by: Jim Mattson <jmattson@google.com>
>
> Reviewed-by: Wanpeng Li <wanpengli@tencent.com>
>
> > ---
> >  arch/x86/kvm/lapic.c | 64 +++++++++++++++++++++++++++++++++++---------
> >  arch/x86/kvm/lapic.h |  7 ++++-
> >  2 files changed, 58 insertions(+), 13 deletions(-)
> >
> > diff --git a/arch/x86/kvm/lapic.c b/arch/x86/kvm/lapic.c
> > index fbb0e6df121b2..8e7f3cf552871 100644
> > --- a/arch/x86/kvm/lapic.c
> > +++ b/arch/x86/kvm/lapic.c
> > @@ -1524,13 +1524,18 @@ static void start_sw_tscdeadline(struct kvm_lapic *apic)
> >         local_irq_restore(flags);
> >  }
> >
> > +static inline u64 tmict_to_ns(struct kvm_lapic *apic, u32 tmict)
> > +{
> > +       return (u64)tmict * APIC_BUS_CYCLE_NS * (u64)apic->divide_count;
> > +}
> > +
> >  static void update_target_expiration(struct kvm_lapic *apic, uint32_t old_divisor)
> >  {
> >         ktime_t now, remaining;
> >         u64 ns_remaining_old, ns_remaining_new;
> >
> > -       apic->lapic_timer.period = (u64)kvm_lapic_get_reg(apic, APIC_TMICT)
> > -               * APIC_BUS_CYCLE_NS * apic->divide_count;
> > +       apic->lapic_timer.period =
> > +                       tmict_to_ns(apic, kvm_lapic_get_reg(apic, APIC_TMICT));
> >         limit_periodic_timer_frequency(apic);
> >
> >         now = ktime_get();
> > @@ -1548,14 +1553,15 @@ static void update_target_expiration(struct kvm_lapic *apic, uint32_t old_diviso
> >         apic->lapic_timer.target_expiration = ktime_add_ns(now, ns_remaining_new);
> >  }
> >
> > -static bool set_target_expiration(struct kvm_lapic *apic)
> > +static bool set_target_expiration(struct kvm_lapic *apic, u32 count_reg)
> >  {
> >         ktime_t now;
> >         u64 tscl = rdtsc();
> > +       s64 deadline;
> >
> >         now = ktime_get();
> > -       apic->lapic_timer.period = (u64)kvm_lapic_get_reg(apic, APIC_TMICT)
> > -               * APIC_BUS_CYCLE_NS * apic->divide_count;
> > +       apic->lapic_timer.period =
> > +                       tmict_to_ns(apic, kvm_lapic_get_reg(apic, APIC_TMICT));
> >
> >         if (!apic->lapic_timer.period) {
> >                 apic->lapic_timer.tscdeadline = 0;
> > @@ -1563,6 +1569,28 @@ static bool set_target_expiration(struct kvm_lapic *apic)
> >         }
> >
> >         limit_periodic_timer_frequency(apic);
> > +       deadline = apic->lapic_timer.period;
> > +
> > +       if (apic_lvtt_period(apic) || apic_lvtt_oneshot(apic)) {
> > +               if (unlikely(count_reg != APIC_TMICT)) {
> > +                       deadline = tmict_to_ns(apic,
> > +                                    kvm_lapic_get_reg(apic, count_reg));
> > +                       if (unlikely(deadline <= 0))
> > +                               deadline = apic->lapic_timer.period;
> > +                       else if (unlikely(deadline > apic->lapic_timer.period)) {
> > +                               pr_info_ratelimited(
> > +                                   "kvm: vcpu %i: requested lapic timer restore with "
> > +                                   "starting count register %#x=%u (%lld ns) > initial count (%lld ns). "
> > +                                   "Using initial count to start timer.\n",
> > +                                   apic->vcpu->vcpu_id,
> > +                                   count_reg,
> > +                                   kvm_lapic_get_reg(apic, count_reg),
> > +                                   deadline, apic->lapic_timer.period);
> > +                               kvm_lapic_set_reg(apic, count_reg, 0);
> > +                               deadline = apic->lapic_timer.period;
> > +                       }
> > +               }
> > +       }
> >
> >         apic_debug("%s: bus cycle is %" PRId64 "ns, now 0x%016"
> >                    PRIx64 ", "
> > @@ -1571,12 +1599,11 @@ static bool set_target_expiration(struct kvm_lapic *apic)
> >                    APIC_BUS_CYCLE_NS, ktime_to_ns(now),
> >                    kvm_lapic_get_reg(apic, APIC_TMICT),
> >                    apic->lapic_timer.period,
> > -                  ktime_to_ns(ktime_add_ns(now,
> > -                               apic->lapic_timer.period)));
> > +                  ktime_to_ns(ktime_add_ns(now, deadline)));
> >
> >         apic->lapic_timer.tscdeadline = kvm_read_l1_tsc(apic->vcpu, tscl) +
> > -               nsec_to_cycles(apic->vcpu, apic->lapic_timer.period);
> > -       apic->lapic_timer.target_expiration = ktime_add_ns(now, apic->lapic_timer.period);
> > +               nsec_to_cycles(apic->vcpu, deadline);
> > +       apic->lapic_timer.target_expiration = ktime_add_ns(now, deadline);
> >
> >         return true;
> >  }
> > @@ -1748,17 +1775,22 @@ void kvm_lapic_restart_hv_timer(struct kvm_vcpu *vcpu)
> >         restart_apic_timer(apic);
> >  }
> >
> > -static void start_apic_timer(struct kvm_lapic *apic)
> > +static void __start_apic_timer(struct kvm_lapic *apic, u32 count_reg)
> >  {
> >         atomic_set(&apic->lapic_timer.pending, 0);
> >
> >         if ((apic_lvtt_period(apic) || apic_lvtt_oneshot(apic))
> > -           && !set_target_expiration(apic))
> > +           && !set_target_expiration(apic, count_reg))
> >                 return;
> >
> >         restart_apic_timer(apic);
> >  }
> >
> > +static void start_apic_timer(struct kvm_lapic *apic)
> > +{
> > +       __start_apic_timer(apic, APIC_TMICT);
> > +}
> > +
> >  static void apic_manage_nmi_watchdog(struct kvm_lapic *apic, u32 lvt0_val)
> >  {
> >         bool lvt0_in_nmi_mode = apic_lvt_nmi_mode(lvt0_val);
> > @@ -2370,6 +2402,14 @@ static int kvm_apic_state_fixup(struct kvm_vcpu *vcpu,
> >  int kvm_apic_get_state(struct kvm_vcpu *vcpu, struct kvm_lapic_state *s)
> >  {
> >         memcpy(s->regs, vcpu->arch.apic->regs, sizeof(*s));
> > +
> > +       /*
> > +        * Get calculated timer current count for remaining timer period (if
> > +        * any) and store it in the returned register set.
> > +        */
> > +       __kvm_lapic_set_reg(s->regs, APIC_TMCCT,
> > +                      __apic_read(vcpu->arch.apic, APIC_TMCCT));
> > +
> >         return kvm_apic_state_fixup(vcpu, s, false);
> >  }
> >
> > @@ -2396,7 +2436,7 @@ int kvm_apic_set_state(struct kvm_vcpu *vcpu, struct kvm_lapic_state *s)
> >         apic_update_lvtt(apic);
> >         apic_manage_nmi_watchdog(apic, kvm_lapic_get_reg(apic, APIC_LVT0));
> >         update_divide_count(apic);
> > -       start_apic_timer(apic);
> > +       __start_apic_timer(apic, APIC_TMCCT);
> >         apic->irr_pending = true;
> >         apic->isr_count = vcpu->arch.apicv_active ?
> >                                 1 : count_vectors(apic->regs + APIC_ISR);
> > diff --git a/arch/x86/kvm/lapic.h b/arch/x86/kvm/lapic.h
> > index ed0ed39abd369..fadefa1a9d678 100644
> > --- a/arch/x86/kvm/lapic.h
> > +++ b/arch/x86/kvm/lapic.h
> > @@ -147,9 +147,14 @@ static inline u32 kvm_lapic_get_reg(struct kvm_lapic *apic, int reg_off)
> >         return *((u32 *) (apic->regs + reg_off));
> >  }
> >
> > +static inline void __kvm_lapic_set_reg(char *regs, int reg_off, u32 val)
> > +{
> > +       *((u32 *) (regs + reg_off)) = val;
> > +}
> > +
> >  static inline void kvm_lapic_set_reg(struct kvm_lapic *apic, int reg_off, u32 val)
> >  {
> > -       *((u32 *) (apic->regs + reg_off)) = val;
> > +       __kvm_lapic_set_reg(apic->regs, reg_off, val);
> >  }
> >
> >  extern struct static_key kvm_no_apic_vcpu;
> > --
> > 2.19.0.605.g01d371f741-goog
> >

Ping?
