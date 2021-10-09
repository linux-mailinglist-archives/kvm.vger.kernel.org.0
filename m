Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A833B427853
	for <lists+kvm@lfdr.de>; Sat,  9 Oct 2021 11:14:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231698AbhJIJQO (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 9 Oct 2021 05:16:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45748 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230455AbhJIJQN (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 9 Oct 2021 05:16:13 -0400
Received: from mail-oi1-x232.google.com (mail-oi1-x232.google.com [IPv6:2607:f8b0:4864:20::232])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 38B99C061570;
        Sat,  9 Oct 2021 02:14:17 -0700 (PDT)
Received: by mail-oi1-x232.google.com with SMTP id 24so17095541oix.0;
        Sat, 09 Oct 2021 02:14:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=MHz+fLkq0sPp6F+6xlYzKWQ6Hgd1dcKc+eCm2j1oBAM=;
        b=LlJTUeM3tz8zBMSDxBtJdys+DPI7z7uVXdrAAvfxCS/HO90vN97DhEVebwNZZYazFQ
         yqIXb0fLTfqzjgdzs7fKtqzXccix8ZOBEyLzKfY/hvT57ydUSH5tbuHJvoHjDjmaLvZ6
         TI3nn/K65oEChEm0J14oDzex9sAHQ7xY79aU7pdwydkyYgO8ziPh8xaFozD4vItc8Fku
         Q/h0MSyRo/Hc/grVLdqPNeAoCHlTnQjT1qhVIGL/ZSUjIj34hc99zKAdx8wCNcIBg+LD
         +z1RsfgqKOKBe/UzrCiKWwyv+pnsfdnzLb1fE4ne1lnP1vachTvl3ejujScrgkigpbRI
         2M8A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=MHz+fLkq0sPp6F+6xlYzKWQ6Hgd1dcKc+eCm2j1oBAM=;
        b=yMiTfjGIbZNelAViZfDYGgSLxMT7egPKTTq2idbplYbOeGF67uZFIFEgT1/F8NpkSh
         FQzU3ktxS2hd8MFs8p0gI5ShPCDUtTwp8nWFcT+moGO0vFXk4copR4Ua2adxC9t5Xxpm
         LdJfV8Qw3Kdc5pSLYdBxXN5zbSLn2WqTeeX37TSAexSEF5UAZNkXmBb3a9Hd3y0lj8Xi
         eeS9xHQpLwvJvOyo8rW6M9Q3+J9ji3mSZnhyBZQZQdx+B31w6gQ/NzME4Llwd53+lSi9
         Tkn7ZASMSK+WMXbo9H9det0I1b8gclMtr4w4dMra8/lHBrx80gs9lZ1lxC5nLWZgoAU4
         DCyg==
X-Gm-Message-State: AOAM533gn1DXBVbjYf5kVnrzAbbruJh3xlBWpmNenJHb+3ejJjJd+g5i
        HydB/Nfu3JioZ10UWfack/naP/LF6fB9VHeVRdQ=
X-Google-Smtp-Source: ABdhPJxvCeZUVnWEZeKcA3Hequb2mutBsquMD43Fn51l8katMgFyhwtwbhe2hVUhDluo2RGgUSPEsWdC2+l1mjR97gc=
X-Received: by 2002:aca:4587:: with SMTP id s129mr19335653oia.5.1633770856604;
 Sat, 09 Oct 2021 02:14:16 -0700 (PDT)
MIME-Version: 1.0
References: <1633687054-18865-1-git-send-email-wanpengli@tencent.com>
 <1633687054-18865-3-git-send-email-wanpengli@tencent.com> <87ily73i0x.fsf@vitty.brq.redhat.com>
 <CANRm+Cy=bb_iap6JKsux7ekmo6Td0FXqwpuVdgPSC8u8b2wFNA@mail.gmail.com> <YWBq56G/ZrsytEP7@google.com>
In-Reply-To: <YWBq56G/ZrsytEP7@google.com>
From:   Wanpeng Li <kernellwp@gmail.com>
Date:   Sat, 9 Oct 2021 17:14:05 +0800
Message-ID: <CANRm+Czj4Kv56HcX2vYu6mMa6o6xrMrCKmZ8x=rp-apLrrGHZQ@mail.gmail.com>
Subject: Re: [PATCH 3/3] KVM: LAPIC: Optimize PMI delivering overhead
To:     Sean Christopherson <seanjc@google.com>
Cc:     Vitaly Kuznetsov <vkuznets@redhat.com>,
        LKML <linux-kernel@vger.kernel.org>, kvm <kvm@vger.kernel.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, 8 Oct 2021 at 23:59, Sean Christopherson <seanjc@google.com> wrote:
>
> On Fri, Oct 08, 2021, Wanpeng Li wrote:
> > On Fri, 8 Oct 2021 at 18:52, Vitaly Kuznetsov <vkuznets@redhat.com> wrote:
> > >
> > > Wanpeng Li <kernellwp@gmail.com> writes:
> > >
> > > > From: Wanpeng Li <wanpengli@tencent.com>
> > > >
> > > > The overhead of kvm_vcpu_kick() is huge since expensive rcu/memory
> > > > barrier etc operations in rcuwait_wake_up(). It is worse when local
>
> Memory barriers on x86 are just compiler barriers.  The only meaningful overhead
> is the locked transaction in rcu_read_lock() => preempt_disable().  I suspect the
> performance benefit from this patch comes either comes from avoiding a second
> lock when disabling preemption again for get_cpu(), or by avoiding the cmpxchg()
> in kvm_vcpu_exiting_guest_mode().
>
> > > > delivery since the vCPU is scheduled and we still suffer from this.
> > > > We can observe 12us+ for kvm_vcpu_kick() in kvm_pmu_deliver_pmi()
> > > > path by ftrace before the patch and 6us+ after the optimization.
>
> Those numbers seem off, I wouldn't expect a few locks to take 6us.

Maybe the ftrace introduces more overhead.

>
> > > > Signed-off-by: Wanpeng Li <wanpengli@tencent.com>
> > > > ---
> > > >  arch/x86/kvm/lapic.c | 3 ++-
> > > >  1 file changed, 2 insertions(+), 1 deletion(-)
> > > >
> > > > diff --git a/arch/x86/kvm/lapic.c b/arch/x86/kvm/lapic.c
> > > > index 76fb00921203..ec6997187c6d 100644
> > > > --- a/arch/x86/kvm/lapic.c
> > > > +++ b/arch/x86/kvm/lapic.c
> > > > @@ -1120,7 +1120,8 @@ static int __apic_accept_irq(struct kvm_lapic *apic, int delivery_mode,
> > > >       case APIC_DM_NMI:
> > > >               result = 1;
> > > >               kvm_inject_nmi(vcpu);
> > > > -             kvm_vcpu_kick(vcpu);
> > > > +             if (vcpu != kvm_get_running_vcpu())
> > > > +                     kvm_vcpu_kick(vcpu);
> > >
> > > Out of curiosity,
> > >
> > > can this be converted into a generic optimization for kvm_vcpu_kick()
> > > instead? I.e. if kvm_vcpu_kick() is called for the currently running
> > > vCPU, there's almost nothing to do, especially when we already have a
> > > request pending, right? (I didn't put too much though to it)
> >
> > I thought about it before, I will do it in the next version since you
> > also vote for it. :)
>
> Adding a kvm_get_running_vcpu() check before kvm_vcpu_wake_up() in kvm_vcpu_kick()
> is not functionally correct as it's possible to reach kvm_cpu_kick() from (soft)
> IRQ context, e.g. hrtimer => apic_timer_expired() and pi_wakeup_handler().  If
> the kick occurs after prepare_to_rcuwait() and the final kvm_vcpu_check_block(),
> but before the vCPU is scheduled out, then the kvm_vcpu_wake_up() is required to
> wake the vCPU, even if it is the current running vCPU.

Good point.

>
> The extra check might also degrade performance for many cases since the full kick
> path would need to disable preemption three times, though if the overhead is from
> x86's cmpxchg() then it's a moot point.
>
> I think we'd want something like this to avoid extra preempt_disable() as well
> as the cmpxchg() when @vcpu is the running vCPU.

Do it in v2, thanks for the suggestion.

    Wanpeng
