Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 18C9C232F9
	for <lists+kvm@lfdr.de>; Mon, 20 May 2019 13:46:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730887AbfETLqD (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 20 May 2019 07:46:03 -0400
Received: from mail-ot1-f65.google.com ([209.85.210.65]:39887 "EHLO
        mail-ot1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728719AbfETLqC (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 20 May 2019 07:46:02 -0400
Received: by mail-ot1-f65.google.com with SMTP id r7so12659458otn.6;
        Mon, 20 May 2019 04:46:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=YK40W8FYXPsem3N0M5GP+38ah6mkX7Im5MvwKipFNsw=;
        b=RoY4Rk0tf3pwB6ho+Y7WLAFKHG+h2TTjnpz9K/w1TMsCjFsOQ8uYov3Grmlp2nYp47
         vJt0VoWo13wdxNwTnNn0xyVAWlLZzYArcIzgKJBXYsCDjTScjv+V9bNqaDV6xHIG8YKT
         Sxzbeg+qUtwGFull//2leGoW4yzKdzTMnmkmN8dkiNEryvLSr3Z4qsSdKC/ZCJkYZl+H
         z32RRiFVizIG+0HhWlg4jgwHd9fYYlMEK/FUARTkSsZ63SdIJw/pxi6zUj7j8IPBy6hY
         enPvETd/fAA9ts/JglX8blm6o1iVQzon2FtUoFTZ8e9JsVOcQaHXP2hEtbq+ynt++bKt
         9q6A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=YK40W8FYXPsem3N0M5GP+38ah6mkX7Im5MvwKipFNsw=;
        b=DNBTyB7z+RG8uhACv66tUvFb3JSLRHZ82tYDBJDtuVuoYicxn4SS1c/PhN4dA7pizW
         1dtGUz7xwYbqjejkOs4bFlqOZsPsPwpk9VEMObDVsqePna0rwHP67hqxDupufbttnoaZ
         y17OFittYO0VwMlDzWNRoleL9uIPkHXkbtJVF+MNWXqF3g8zoqnG1WaH3OGPi/fAFirZ
         d0RZeyMRARVPcUvsjEbshLkoGo7oM9Hpk7F9GwUuUfvfea7gw/LDizUZiSsaPUYdwMwS
         9BBbBnUD5UIL0lpg00dizq2F3Ryykp4CKGlo8SMdKGog7tD7UFzUfzrV5XZ9RvrXUeXP
         Dj6w==
X-Gm-Message-State: APjAAAXocQF0XGLPdDikRxJcGHAKivhMzGmlgG1QyW+BTwQlDYRnhAnp
        trGjiahyBhG347Y4zNuK78aa11rIWDT7buSTl1qfVQ==
X-Google-Smtp-Source: APXvYqyLirWDkCv1jsHOwXXeOs+83ro/jbI0opgbhIzBti3BcptCNQgwATHJ6OMUc0oyBh10kyjZ7F49+xcusFtpogU=
X-Received: by 2002:a9d:1405:: with SMTP id h5mr20033485oth.118.1558352761836;
 Mon, 20 May 2019 04:46:01 -0700 (PDT)
MIME-Version: 1.0
References: <1558340289-6857-1-git-send-email-wanpengli@tencent.com>
 <1558340289-6857-5-git-send-email-wanpengli@tencent.com> <b80a0c3b-c5b1-bfd1-83d7-ace3436b230e@redhat.com>
 <CANRm+CyDpA-2j28soX9si5CX3vFadd4_BASFzt1f4FbNNNDzyw@mail.gmail.com>
 <bd60e5c2-e3c5-80fc-3a1d-c75809573945@redhat.com> <CANRm+CzFQy4UC9oGxFK8UVVhdtV_LGeF3JcNohpRcgspSqcxwg@mail.gmail.com>
 <024a0c93-f8a3-abe0-85de-fa41babf06a0@redhat.com>
In-Reply-To: <024a0c93-f8a3-abe0-85de-fa41babf06a0@redhat.com>
From:   Wanpeng Li <kernellwp@gmail.com>
Date:   Mon, 20 May 2019 19:45:52 +0800
Message-ID: <CANRm+Cy69VH+5w4en-Q+N85bRCBoCWNi6oEwpJGgp+MBaUUX8Q@mail.gmail.com>
Subject: Re: [PATCH v4 4/5] KVM: LAPIC: Delay trace advance expire delta
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     LKML <linux-kernel@vger.kernel.org>, kvm <kvm@vger.kernel.org>,
        =?UTF-8?B?UmFkaW0gS3LEjW3DocWZ?= <rkrcmar@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Liran Alon <liran.alon@oracle.com>
Content-Type: text/plain; charset="UTF-8"
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, 20 May 2019 at 19:41, Paolo Bonzini <pbonzini@redhat.com> wrote:
>
> On 20/05/19 13:36, Wanpeng Li wrote:
> >> Hmm, yeah, that makes sense.  The location of the tracepoint is a bit
> >> weird, but I guess we can add a comment in the code.
> > Do you need me to post a new patchset? :)
>
> No problem.  The final patch that I committed is this:
>
> diff --git a/arch/x86/kvm/lapic.c b/arch/x86/kvm/lapic.c
> index c12b090f4fad..f8615872ae64 100644
> --- a/arch/x86/kvm/lapic.c
> +++ b/arch/x86/kvm/lapic.c
> @@ -1502,27 +1502,27 @@ static inline void __wait_lapic_expire(struct kvm_vcpu *vcpu, u64 guest_cycles)
>  }
>
>  static inline void adjust_lapic_timer_advance(struct kvm_vcpu *vcpu,
> -                                             u64 guest_tsc, u64 tsc_deadline)
> +                                             s64 advance_expire_delta)
>  {
>         struct kvm_lapic *apic = vcpu->arch.apic;
>         u32 timer_advance_ns = apic->lapic_timer.timer_advance_ns;
>         u64 ns;
>
>         /* too early */
> -       if (guest_tsc < tsc_deadline) {
> -               ns = (tsc_deadline - guest_tsc) * 1000000ULL;
> +       if (advance_expire_delta < 0) {
> +               ns = -advance_expire_delta * 1000000ULL;
>                 do_div(ns, vcpu->arch.virtual_tsc_khz);
>                 timer_advance_ns -= min((u32)ns,
>                         timer_advance_ns / LAPIC_TIMER_ADVANCE_ADJUST_STEP);
>         } else {
>         /* too late */
> -               ns = (guest_tsc - tsc_deadline) * 1000000ULL;
> +               ns = advance_expire_delta * 1000000ULL;
>                 do_div(ns, vcpu->arch.virtual_tsc_khz);
>                 timer_advance_ns += min((u32)ns,
>                         timer_advance_ns / LAPIC_TIMER_ADVANCE_ADJUST_STEP);
>         }
>
> -       if (abs(guest_tsc - tsc_deadline) < LAPIC_TIMER_ADVANCE_ADJUST_DONE)
> +       if (abs(advance_expire_delta) < LAPIC_TIMER_ADVANCE_ADJUST_DONE)
>                 apic->lapic_timer.timer_advance_adjust_done = true;
>         if (unlikely(timer_advance_ns > 5000)) {
>                 timer_advance_ns = 0;
> @@ -1545,13 +1545,13 @@ void wait_lapic_expire(struct kvm_vcpu *vcpu)
>         tsc_deadline = apic->lapic_timer.expired_tscdeadline;
>         apic->lapic_timer.expired_tscdeadline = 0;
>         guest_tsc = kvm_read_l1_tsc(vcpu, rdtsc());
> -       trace_kvm_wait_lapic_expire(vcpu->vcpu_id, guest_tsc - tsc_deadline);
> +       apic->lapic_timer.advance_expire_delta = guest_tsc - tsc_deadline;
>
>         if (guest_tsc < tsc_deadline)
>                 __wait_lapic_expire(vcpu, tsc_deadline - guest_tsc);
>
>         if (unlikely(!apic->lapic_timer.timer_advance_adjust_done))
> -               adjust_lapic_timer_advance(vcpu, guest_tsc, tsc_deadline);
> +               adjust_lapic_timer_advance(vcpu, apic->lapic_timer.advance_expire_delta);
>  }
>
>  static void start_sw_tscdeadline(struct kvm_lapic *apic)
> diff --git a/arch/x86/kvm/lapic.h b/arch/x86/kvm/lapic.h
> index d6d049ba3045..3e72a255543d 100644
> --- a/arch/x86/kvm/lapic.h
> +++ b/arch/x86/kvm/lapic.h
> @@ -32,6 +32,7 @@ struct kvm_timer {
>         u64 tscdeadline;
>         u64 expired_tscdeadline;
>         u32 timer_advance_ns;
> +       s64 advance_expire_delta;
>         atomic_t pending;                       /* accumulated triggered timers */
>         bool hv_timer_in_use;
>         bool timer_advance_adjust_done;
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index e7e57de50a3c..35631505421c 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -8008,6 +8008,13 @@ static int vcpu_enter_guest(struct kvm_vcpu *vcpu)
>         ++vcpu->stat.exits;
>
>         guest_exit_irqoff();
> +       if (lapic_in_kernel(vcpu)) {
> +               s64 delta = vcpu->arch.apic->lapic_timer.advance_expire_delta;
> +               if (delta != S64_MIN) {
> +                       trace_kvm_wait_lapic_expire(vcpu->vcpu_id, delta);
> +                       vcpu->arch.apic->lapic_timer.advance_expire_delta = S64_MIN;
> +               }
> +       }
>
>         local_irq_enable();
>         preempt_enable();
>
> so that KVM tracks whether wait_lapic_expire was called, and do not
> invoke the tracepoint if not.

Looks good to me, thank you. :)

Regards,
Wanpeng Li
