Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C0E8D426E4B
	for <lists+kvm@lfdr.de>; Fri,  8 Oct 2021 18:00:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243304AbhJHQBg (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 8 Oct 2021 12:01:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39868 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231161AbhJHQBf (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 8 Oct 2021 12:01:35 -0400
Received: from mail-pj1-x1029.google.com (mail-pj1-x1029.google.com [IPv6:2607:f8b0:4864:20::1029])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 412DEC061570
        for <kvm@vger.kernel.org>; Fri,  8 Oct 2021 08:59:40 -0700 (PDT)
Received: by mail-pj1-x1029.google.com with SMTP id oa12-20020a17090b1bcc00b0019f715462a8so8134382pjb.3
        for <kvm@vger.kernel.org>; Fri, 08 Oct 2021 08:59:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=bJec0c9ktptqsDIRs1X2HcXPXYu1ibmz/QQJZ4y4yPg=;
        b=kg9YVeYawZzybLo3q8WkLy6zH0pgQaMTVJdfl0mfr8jH6MtYApkqsoSz+HN9ZrQQYn
         SbmuuMR2QAIeXQYf/LdK+7V6fo6H2lm178w/ixi50eBnqKWmVdCsYseveBfIyKyh4YlW
         RN8EHk0263retrumj+2aMKt8qKfs2onGmOiO9YRsQZ9S+SEcYWyQQg6/4qbiLq6Kc+aL
         e3tEtEuPcKVHUeFiBYFbY4nrpialgKa8rpqMaWplq7yDVLw7VOYDUUhT99fvGm5aqiOW
         TgBqx4fU1Usbnp15gpAPqyeWPJfcUbCMEGpAYBzyT80wuL8GJnxooArnV1P97Xrx6P5K
         hi6Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=bJec0c9ktptqsDIRs1X2HcXPXYu1ibmz/QQJZ4y4yPg=;
        b=HKfZLc2ZwSel/ZpxxKgA/+w3uaHpLhbbWfmpyH9e3M9DzzO5W3KuY8UeDAQR8NQP0V
         O1hdb1b2uvAw+toZqxULmPfm1uHkZ6OAlgElfAhM8sWeylk5Gu32GppFfS/ccYRToksi
         YV25Yjpq2gTgzQ/PTqkfoUEFklxjl3eytNR5IRVn6aWYlvDGFGrJ2tqJELkpMxPtq+1a
         WJwVHvSiO8MAP5wSgJTRB9gkzzKCng5ILIScZ9EBl+T9HnMonS7lbBlWrRohyr3IaCW6
         ElSkWDacDKLRMQdqnOGBq2b316THAZAHkFsYdpCmecaPwZFp/rfKX9KQKb+kwXMeouBZ
         pkoA==
X-Gm-Message-State: AOAM533ZF/4oFJJE9YMTnmjEdzgXga8YDVl3hK4yJ8Hlt0wi6h0h6Xr0
        CdTK7kX6z2Gb7r3q4DspSU6e3Q==
X-Google-Smtp-Source: ABdhPJzd6PV7Rd+21PgnRpPtBsT4/PaePQlmjV4u+NB5Trx2NT06j9H3iMZhG2lZW82MNHLo65B8xQ==
X-Received: by 2002:a17:902:7c8d:b0:13a:768b:d6c0 with SMTP id y13-20020a1709027c8d00b0013a768bd6c0mr10288372pll.83.1633708779555;
        Fri, 08 Oct 2021 08:59:39 -0700 (PDT)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id m12sm2634450pjv.29.2021.10.08.08.59.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 08 Oct 2021 08:59:39 -0700 (PDT)
Date:   Fri, 8 Oct 2021 15:59:35 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Wanpeng Li <kernellwp@gmail.com>
Cc:     Vitaly Kuznetsov <vkuznets@redhat.com>,
        LKML <linux-kernel@vger.kernel.org>, kvm <kvm@vger.kernel.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>
Subject: Re: [PATCH 3/3] KVM: LAPIC: Optimize PMI delivering overhead
Message-ID: <YWBq56G/ZrsytEP7@google.com>
References: <1633687054-18865-1-git-send-email-wanpengli@tencent.com>
 <1633687054-18865-3-git-send-email-wanpengli@tencent.com>
 <87ily73i0x.fsf@vitty.brq.redhat.com>
 <CANRm+Cy=bb_iap6JKsux7ekmo6Td0FXqwpuVdgPSC8u8b2wFNA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CANRm+Cy=bb_iap6JKsux7ekmo6Td0FXqwpuVdgPSC8u8b2wFNA@mail.gmail.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Oct 08, 2021, Wanpeng Li wrote:
> On Fri, 8 Oct 2021 at 18:52, Vitaly Kuznetsov <vkuznets@redhat.com> wrote:
> >
> > Wanpeng Li <kernellwp@gmail.com> writes:
> >
> > > From: Wanpeng Li <wanpengli@tencent.com>
> > >
> > > The overhead of kvm_vcpu_kick() is huge since expensive rcu/memory
> > > barrier etc operations in rcuwait_wake_up(). It is worse when local

Memory barriers on x86 are just compiler barriers.  The only meaningful overhead
is the locked transaction in rcu_read_lock() => preempt_disable().  I suspect the
performance benefit from this patch comes either comes from avoiding a second
lock when disabling preemption again for get_cpu(), or by avoiding the cmpxchg()
in kvm_vcpu_exiting_guest_mode().

> > > delivery since the vCPU is scheduled and we still suffer from this.
> > > We can observe 12us+ for kvm_vcpu_kick() in kvm_pmu_deliver_pmi()
> > > path by ftrace before the patch and 6us+ after the optimization.

Those numbers seem off, I wouldn't expect a few locks to take 6us.

> > > Signed-off-by: Wanpeng Li <wanpengli@tencent.com>
> > > ---
> > >  arch/x86/kvm/lapic.c | 3 ++-
> > >  1 file changed, 2 insertions(+), 1 deletion(-)
> > >
> > > diff --git a/arch/x86/kvm/lapic.c b/arch/x86/kvm/lapic.c
> > > index 76fb00921203..ec6997187c6d 100644
> > > --- a/arch/x86/kvm/lapic.c
> > > +++ b/arch/x86/kvm/lapic.c
> > > @@ -1120,7 +1120,8 @@ static int __apic_accept_irq(struct kvm_lapic *apic, int delivery_mode,
> > >       case APIC_DM_NMI:
> > >               result = 1;
> > >               kvm_inject_nmi(vcpu);
> > > -             kvm_vcpu_kick(vcpu);
> > > +             if (vcpu != kvm_get_running_vcpu())
> > > +                     kvm_vcpu_kick(vcpu);
> >
> > Out of curiosity,
> >
> > can this be converted into a generic optimization for kvm_vcpu_kick()
> > instead? I.e. if kvm_vcpu_kick() is called for the currently running
> > vCPU, there's almost nothing to do, especially when we already have a
> > request pending, right? (I didn't put too much though to it)
> 
> I thought about it before, I will do it in the next version since you
> also vote for it. :)

Adding a kvm_get_running_vcpu() check before kvm_vcpu_wake_up() in kvm_vcpu_kick()
is not functionally correct as it's possible to reach kvm_cpu_kick() from (soft)
IRQ context, e.g. hrtimer => apic_timer_expired() and pi_wakeup_handler().  If
the kick occurs after prepare_to_rcuwait() and the final kvm_vcpu_check_block(),
but before the vCPU is scheduled out, then the kvm_vcpu_wake_up() is required to
wake the vCPU, even if it is the current running vCPU.

The extra check might also degrade performance for many cases since the full kick
path would need to disable preemption three times, though if the overhead is from
x86's cmpxchg() then it's a moot point.

I think we'd want something like this to avoid extra preempt_disable() as well
as the cmpxchg() when @vcpu is the running vCPU.

diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index 8b7dc6e89fd7..f148a7d2a8b9 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -3349,8 +3349,15 @@ void kvm_vcpu_kick(struct kvm_vcpu *vcpu)
 {
        int me, cpu;

-       if (kvm_vcpu_wake_up(vcpu))
-               return;
+       me = get_cpu();
+
+       if (rcuwait_active(&vcpu->wait) && kvm_vcpu_wake_up(vcpu))
+               goto out;
+
+       if (vcpu == __this_cpu_read(kvm_running_vcpu)) {
+               WARN_ON_ONCE(vcpu->mode == IN_GUEST_MODE);
+               goto out;
+       }

        /*
         * Note, the vCPU could get migrated to a different pCPU at any point
@@ -3359,12 +3366,12 @@ void kvm_vcpu_kick(struct kvm_vcpu *vcpu)
         * IPI is to force the vCPU to leave IN_GUEST_MODE, and migrating the
         * vCPU also requires it to leave IN_GUEST_MODE.
         */
-       me = get_cpu();
        if (kvm_arch_vcpu_should_kick(vcpu)) {
                cpu = READ_ONCE(vcpu->cpu);
                if (cpu != me && (unsigned)cpu < nr_cpu_ids && cpu_online(cpu))
                        smp_send_reschedule(cpu);
        }
+out:
        put_cpu();
 }
 EXPORT_SYMBOL_GPL(kvm_vcpu_kick);
