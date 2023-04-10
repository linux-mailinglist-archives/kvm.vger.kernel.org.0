Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 989346DCA01
	for <lists+kvm@lfdr.de>; Mon, 10 Apr 2023 19:30:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230161AbjDJRac (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 10 Apr 2023 13:30:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54236 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229669AbjDJRaa (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 10 Apr 2023 13:30:30 -0400
Received: from mail-yw1-x1149.google.com (mail-yw1-x1149.google.com [IPv6:2607:f8b0:4864:20::1149])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C26751BC7
        for <kvm@vger.kernel.org>; Mon, 10 Apr 2023 10:30:29 -0700 (PDT)
Received: by mail-yw1-x1149.google.com with SMTP id 00721157ae682-54c1e4b7e63so110522367b3.20
        for <kvm@vger.kernel.org>; Mon, 10 Apr 2023 10:30:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112; t=1681147829;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=swVfre5E7m12aH0Nili/mE00RBn/7V3Gu0cV4TQa/FI=;
        b=Bkm3kfKfijVWKSJdjja05oxaylJKNgze8NUBaNrlZrjyYxB2BhIx2QCbiYpMYHgunp
         q9wpnImTxUPFCn+Obtm/P8HljpWVGrqboHSWsPwrb78ysw63WfhtsV/9PirFUGzp54Sw
         71dE4ZUWfRATRyE2naB8qPLZSxDshvQofaiqaWQoHsxnj4PjkDgjwtH0m8YM6VeR+Xhj
         PHuOWNB1u2d0sT44T9ps2SWjEU8wvY+WSlVHKjMimgd4beNNjExpHf02HfIP0KmaQjAB
         U1FEWFYPDu639l7qQNHrgb71v2k17lDH6gdA+akXxIpRK/3TErLnfvYHrUdeeM4CBsKK
         n0JQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1681147829;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=swVfre5E7m12aH0Nili/mE00RBn/7V3Gu0cV4TQa/FI=;
        b=oZ/Z695cawmJw1+agaeEunTnxvVsUgHoYZ86gq+ASfoT37UCJnJKCS97DZshSsKdEE
         tG6pa2Amh3TX1KLOp+3j9P0TbSO87qQs8LM76QgkmPhKujcJUmWVGYkgSwUiQ8MACo5G
         rHrYMXCqOsvEK7MjPAirs5P/ktthhF24u8rpCbiWloZqjTAZQeghry8rFLoBchJfWrPo
         xWhT3AVDC8hYxQtslg7UYfJxROvYRi230orK+QWe19533/FyVWxAS4tuXlJGoHjKgnCB
         FM5qRwRwFFJsWUkuHKPc6MBwtQP0u7zSb50SRClwZ8YZhDQsY35sryOaIdjfTzS7JHQ9
         6bfQ==
X-Gm-Message-State: AAQBX9crXx1pfp4MlUIyztLQ3jhwD+13+xLeyqJHWADHUkGU/U0E9Tlf
        zJrh7GePYnlUhlpWUFaOH4TjcDl/N2A=
X-Google-Smtp-Source: AKy350ZVyCIs5di6w8hxNKACB2pecEoa4FTRa10a0IuTcTLYi3jcffJrMoieyodIccC2/MdJ2P/JXn3MYIc=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a81:ad1b:0:b0:54c:637a:a154 with SMTP id
 l27-20020a81ad1b000000b0054c637aa154mr6574846ywh.8.1681147829075; Mon, 10 Apr
 2023 10:30:29 -0700 (PDT)
Date:   Mon, 10 Apr 2023 10:30:27 -0700
In-Reply-To: <ZCYj9yfbf+65OThn@yzhao56-desk.sh.intel.com>
Mime-Version: 1.0
References: <20230313111022.13793-1-yan.y.zhao@intel.com> <ZB4uoe9WBzhG9ddU@google.com>
 <ZCOaHWE6aS0vjvya@yzhao56-desk.sh.intel.com> <75ae80f7-b86e-3380-b3da-0e2201df4b7f@redhat.com>
 <ZCVcvuddkEFKW/0p@yzhao56-desk.sh.intel.com> <ZCXRgw5+5A7aluNc@google.com> <ZCYj9yfbf+65OThn@yzhao56-desk.sh.intel.com>
Message-ID: <ZDRHsyM00sJ1j4qX@google.com>
Subject: Re: [PATCH v3] KVM: VMX: fix lockdep warning on posted intr wakeup
From:   Sean Christopherson <seanjc@google.com>
To:     Yan Zhao <yan.y.zhao@intel.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="us-ascii"
X-Spam-Status: No, score=-7.7 required=5.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Mar 31, 2023, Yan Zhao wrote:
> On Thu, Mar 30, 2023 at 11:14:27AM -0700, Sean Christopherson wrote:
> > On Thu, Mar 30, 2023, Yan Zhao wrote:
> > > While with v3 of this patch (sched_in path holds both out_lock and in_lock),
> > > lockdep is still able to warn about this issue.
> > 
> > Couldn't we just add a manual assertion?  That'd also be a good location for a
> > comment to document all of this, and to clarify that current->pi_lock is a
> > completely different lock that has nothing to do with posted interrupts.
> > 
> > It's not foolproof, but any patches that substantially touch this code need a
> > ton of scrutiny as the scheduling interactions are gnarly, i.e. IMO a deadlock
> > bug sneaking in is highly unlikely.
> > 
> > diff --git a/arch/x86/kvm/vmx/posted_intr.c b/arch/x86/kvm/vmx/posted_intr.c
> > index 94c38bea60e7..19325a10e42f 100644
> > --- a/arch/x86/kvm/vmx/posted_intr.c
> > +++ b/arch/x86/kvm/vmx/posted_intr.c
> > @@ -90,6 +90,7 @@ void vmx_vcpu_pi_load(struct kvm_vcpu *vcpu, int cpu)
> >          */
> >         if (pi_desc->nv == POSTED_INTR_WAKEUP_VECTOR) {
> >                 raw_spin_lock(&per_cpu(wakeup_vcpus_on_cpu_lock, vcpu->cpu));
> > +               lockdep_assert_not_held(&current->pi_lock);
> >                 list_del(&vmx->pi_wakeup_list);
> >                 raw_spin_unlock(&per_cpu(wakeup_vcpus_on_cpu_lock, vcpu->cpu));
> >         }
> Hmm...No. It's not about "current->pi_lock" cannot be held, it's about
> the lock ordering.
> In sched_out thread, the lock ordering is
> "current->pi_lock" --> "rq->__lock" --> "per_cpu(wakeup_vcpus_on_cpu_lock, cpu)",
> then in sched_in thread, if the lock ordering is
> "per_cpu(wakeup_vcpus_on_cpu_lock, cpu)" --> "current->pi_lock",
> circular locking dependency will happen.
> while if the lock ordering in sched_in thread is
> "current->pi_lock" --> "per_cpu(wakeup_vcpus_on_cpu_lock, cpu)",
> it's fine!

Right, but IIUC, neither ordering happens today.  In other words, the lockdep
assertion isn't defining a hard rule, rather it's enforcing an assumption that KVM
relies on to avoid a potential deadlock.

> If sched_out thread and sched_in thread actually should hold the same
> subclass of lock, we can't fool the lockdep just to let it shut up.
> And, we may not be able to list or document out all potential locks that cannot
> be held inside the "per_cpu(wakeup_vcpus_on_cpu_lock, cpu)", right?

Eh, IMO this is a non-issue.  It's a raw_spin_lock() in an IRQs disabled section
that wraps a single line of benign code.  If it's really concerning, we could add
a scary comment like this.

diff --git a/arch/x86/kvm/vmx/posted_intr.c b/arch/x86/kvm/vmx/posted_intr.c
index 94c38bea60e7..a7ec0371aeca 100644
--- a/arch/x86/kvm/vmx/posted_intr.c
+++ b/arch/x86/kvm/vmx/posted_intr.c
@@ -87,6 +87,12 @@ void vmx_vcpu_pi_load(struct kvm_vcpu *vcpu, int cpu)
         * If the vCPU was waiting for wakeup, remove the vCPU from the wakeup
         * list of the _previous_ pCPU, which will not be the same as the
         * current pCPU if the task was migrated.
+        *
+        * Stating the obvious, do not under any circumstance let this path
+        * acquire a different lock while holding the per-CPU lock.  To avoid
+        * false postives in lockdep, KVM uses different lockdep subclasses for
+        * vmx_vcpu_pi_put() vs vmx_vcpu_pi_load(), i.e. lockdep may not be
+        * to detect circular dependencies and other issues.
         */
        if (pi_desc->nv == POSTED_INTR_WAKEUP_VECTOR) {
                raw_spin_lock(&per_cpu(wakeup_vcpus_on_cpu_lock, vcpu->cpu));
 
> BTW, could you tell me why you think v3 complicates KVM's functionality?
> It just splits a single lock into two sub locks, and let irq path only

Heh, "just".  

> takes in_lock, sched_out path only takes out_lock, while sched_in path takes
> both in_lock and out_lock.
> IMHO, it does not make any functional change to KVM code.
> Maybe it's because the commit message is not well written and gave people a wrong
> impression that the logic changes a lot?

No, this is not a problem that can be solved by any changelog.  My very strong
objection to having two separate locks is that when reading the code, it's not
remotely obvious why two locks are needed, or that the code is correct.  Adding
copious amounts of documentation/comments can help, but it'll never fully solve
the problem that having two locks simply isn't intuitive/straightforward.
