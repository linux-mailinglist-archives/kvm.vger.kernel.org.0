Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AD6D1365204
	for <lists+kvm@lfdr.de>; Tue, 20 Apr 2021 08:02:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229960AbhDTGCv (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 20 Apr 2021 02:02:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52412 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229577AbhDTGCu (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 20 Apr 2021 02:02:50 -0400
Received: from mail-ot1-x336.google.com (mail-ot1-x336.google.com [IPv6:2607:f8b0:4864:20::336])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7D508C061763;
        Mon, 19 Apr 2021 23:02:19 -0700 (PDT)
Received: by mail-ot1-x336.google.com with SMTP id o13-20020a9d404d0000b029028e0a0ae6b4so15806744oti.10;
        Mon, 19 Apr 2021 23:02:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=qt0lRKLsgtImiEowN6MCoMr9lqUeJDBLHkuJ/55/e98=;
        b=joOeOfH7NiOFE/0XKIgGIHJgPnQwYp23K21ed17iU7dg50T0fzNgQoIPWDNC3AlzQt
         lpSfy7m0ySvWg6PgQ9+Ag+PgkQARd+NQzBqgEMJTlZ5/l14220zPT23lvjwP78MuNn3Z
         zm4c4ZB2yhdIYDL8ErVMvrMlmLIZ9qj8dZcFgZeBR+Syzt32EM5yWU+RLdh3rkVXxFW8
         cZvW5nQTzeWGQsKs4pkH6ky0jnYeXbM2CnPhT+8Urkvwfx3Skd2hijerYL01xSciB9mk
         DP5BiOWb/Si6hbrZ0Z9Il9XvlkN3mmBnWYLbTexDSxZEBxnrxOHPP1P5cDhU1AD4MmaB
         I+AA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=qt0lRKLsgtImiEowN6MCoMr9lqUeJDBLHkuJ/55/e98=;
        b=j49Eqner5saUvUcgm5tLEHIsxBqkaJgezxVlujBsAny7uM+iTsuYZTj1p/4a8Oy1/s
         H5D+kZIbI+JDB6+1dlMS24muk5+aklhwlm9OJpW7dHsmfO+Uyai1euofhqCbVH8XccOW
         nCj3O3tbqKkukYo6fNityTYunwJQmxD9VXByhJKPDpso8oOcHEDK/AlEwbpU59kzs1xe
         b0H6NNSZYQLd6vXJTVHeXkSh2bv3/MDVD7x5Aiz8NP94taaGC3nDVfOa7OxxNkuHAaDy
         FjJ9hKjI5fn694l9F9Aeorh7OJZ0N0WS19gsFTSLpf4HDozP4LBEQQpzXBKZbvbFDOrm
         0BQQ==
X-Gm-Message-State: AOAM530D6YSMujS/GSXMQ+Ntc9lcgEZ+yIw2TCgvY0g0H22m9z8E4zZZ
        8omYfKzUGD25Kjndqn/cSD9ReSTLX2HniVhmyt4=
X-Google-Smtp-Source: ABdhPJy01S4bz+i/MSJiFM5wCIrqx6K4wHikx4zZZdKnntZ3F+W92lJPzs7GAnZVvyFP/Gtnc5QJ/i1cxdGJUzHkw90=
X-Received: by 2002:a9d:7cc7:: with SMTP id r7mr6838781otn.254.1618898538926;
 Mon, 19 Apr 2021 23:02:18 -0700 (PDT)
MIME-Version: 1.0
References: <1618542490-14756-1-git-send-email-wanpengli@tencent.com>
 <9c49c6ff-d896-e6a5-c051-b6707f6ec58a@redhat.com> <CANRm+Cy-xmDRQoUfOYm+GGvWiS+qC_sBjyZmcLykbKqTF2YDxQ@mail.gmail.com>
 <YH2wnl05UBqVhcHr@google.com> <c1909fa3-61f3-de6b-1aa1-8bc36285e1e4@redhat.com>
In-Reply-To: <c1909fa3-61f3-de6b-1aa1-8bc36285e1e4@redhat.com>
From:   Wanpeng Li <kernellwp@gmail.com>
Date:   Tue, 20 Apr 2021 14:02:07 +0800
Message-ID: <CANRm+CwQ266j6wTxqFZtGhp_HfQZ7Y_e843hzROqNUxf9BcaFA@mail.gmail.com>
Subject: Re: [PATCH] KVM: Boost vCPU candidiate in user mode which is
 delivering interrupt
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        LKML <linux-kernel@vger.kernel.org>, kvm <kvm@vger.kernel.org>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, 20 Apr 2021 at 00:59, Paolo Bonzini <pbonzini@redhat.com> wrote:
>
> On 19/04/21 18:32, Sean Christopherson wrote:
> > If false positives are a big concern, what about adding another pass to the loop
> > and only yielding to usermode vCPUs with interrupts in the second full pass?
> > I.e. give vCPUs that are already in kernel mode priority, and only yield to
> > handle an interrupt if there are no vCPUs in kernel mode.
> >
> > kvm_arch_dy_runnable() pulls in pv_unhalted, which seems like a good thing.
>
> pv_unhalted won't help if you're waiting for a kernel spinlock though,
> would it?  Doing two passes (or looking for a "best" candidate that
> prefers kernel mode vCPUs to user mode vCPUs waiting for an interrupt)
> seems like the best choice overall.

How about something like this:

diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index 6b4dd95..8ba50be 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -325,10 +325,12 @@ struct kvm_vcpu {
      * Cpu relax intercept or pause loop exit optimization
      * in_spin_loop: set when a vcpu does a pause loop exit
      *  or cpu relax intercepted.
+     * pending_interrupt: set when a vcpu waiting for an interrupt
      * dy_eligible: indicates whether vcpu is eligible for directed yield.
      */
     struct {
         bool in_spin_loop;
+        bool pending_interrupt;
         bool dy_eligible;
     } spin_loop;
 #endif
@@ -1427,6 +1429,12 @@ static inline void
kvm_vcpu_set_in_spin_loop(struct kvm_vcpu *vcpu, bool val)
 {
     vcpu->spin_loop.in_spin_loop = val;
 }
+
+static inline void kvm_vcpu_set_pending_interrupt(struct kvm_vcpu
*vcpu, bool val)
+{
+    vcpu->spin_loop.pending__interrupt = val;
+}
+
 static inline void kvm_vcpu_set_dy_eligible(struct kvm_vcpu *vcpu, bool val)
 {
     vcpu->spin_loop.dy_eligible = val;
@@ -1438,6 +1446,10 @@ static inline void
kvm_vcpu_set_in_spin_loop(struct kvm_vcpu *vcpu, bool val)
 {
 }

+static inline void kvm_vcpu_set_pending_interrupt(struct kvm_vcpu
*vcpu, bool val)
+{
+}
+
 static inline void kvm_vcpu_set_dy_eligible(struct kvm_vcpu *vcpu, bool val)
 {
 }
diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index 529cff1..42e0255 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -410,6 +410,7 @@ static void kvm_vcpu_init(struct kvm_vcpu *vcpu,
struct kvm *kvm, unsigned id)
     INIT_LIST_HEAD(&vcpu->blocked_vcpu_list);

     kvm_vcpu_set_in_spin_loop(vcpu, false);
+    kvm_vcpu_set_pending_interrupt(vcpu, false);
     kvm_vcpu_set_dy_eligible(vcpu, false);
     vcpu->preempted = false;
     vcpu->ready = false;
@@ -3079,14 +3080,17 @@ EXPORT_SYMBOL_GPL(kvm_vcpu_yield_to);
  * Helper that checks whether a VCPU is eligible for directed yield.
  * Most eligible candidate to yield is decided by following heuristics:
  *
- *  (a) VCPU which has not done pl-exit or cpu relax intercepted recently
- *  (preempted lock holder), indicated by @in_spin_loop.
- *  Set at the beginning and cleared at the end of interception/PLE handler.
+ *  (a) VCPU which has not done pl-exit or cpu relax intercepted and is not
+ *  waiting for an interrupt recently (preempted lock holder). The former
+ *  one is indicated by @in_spin_loop, set at the beginning and cleared at
+ *  the end of interception/PLE handler. The later one is indicated by
+ *  @pending_interrupt, set when interrupt is delivering and cleared at
+ *  the end of directed yield.
  *
- *  (b) VCPU which has done pl-exit/ cpu relax intercepted but did not get
- *  chance last time (mostly it has become eligible now since we have probably
- *  yielded to lockholder in last iteration. This is done by toggling
- *  @dy_eligible each time a VCPU checked for eligibility.)
+ *  (b) VCPU which has done pl-exit/ cpu relax intercepted or is waiting for
+ *  interrupt but did not get chance last time (mostly it has become eligible
+ *  now since we have probably yielded to lockholder in last iteration. This
+ *  is done by toggling @dy_eligible each time a VCPU checked for eligibility.)
  *
  *  Yielding to a recently pl-exited/cpu relax intercepted VCPU before yielding
  *  to preempted lock-holder could result in wrong VCPU selection and CPU
@@ -3102,10 +3106,10 @@ static bool
kvm_vcpu_eligible_for_directed_yield(struct kvm_vcpu *vcpu)
 #ifdef CONFIG_HAVE_KVM_CPU_RELAX_INTERCEPT
     bool eligible;

-    eligible = !vcpu->spin_loop.in_spin_loop ||
+    eligible = !(vcpu->spin_loop.in_spin_loop ||
vcpu->spin_loop.has_interrupt) ||
             vcpu->spin_loop.dy_eligible;

-    if (vcpu->spin_loop.in_spin_loop)
+    if (vcpu->spin_loop.in_spin_loop || vcpu->spin_loop.has_interrupt)
         kvm_vcpu_set_dy_eligible(vcpu, !vcpu->spin_loop.dy_eligible);

     return eligible;
@@ -3137,6 +3141,16 @@ static bool vcpu_dy_runnable(struct kvm_vcpu *vcpu)
     return false;
 }

+static bool kvm_has_interrupt_delivery(struct kvm_vcpu *vcpu)
+{
+    if (vcpu_dy_runnable(vcpu)) {
+        kvm_vcpu_set_pending_interrupt(vcpu, true);
+        return true;
+    }
+
+    return false;
+}
+
 void kvm_vcpu_on_spin(struct kvm_vcpu *me, bool yield_to_kernel_mode)
 {
     struct kvm *kvm = me->kvm;
@@ -3170,6 +3184,7 @@ void kvm_vcpu_on_spin(struct kvm_vcpu *me, bool
yield_to_kernel_mode)
                 !vcpu_dy_runnable(vcpu))
                 continue;
             if (READ_ONCE(vcpu->preempted) && yield_to_kernel_mode &&
+                !kvm_has_interrupt_delivery(vcpu) &&
                 !kvm_arch_vcpu_in_kernel(vcpu))
                 continue;
             if (!kvm_vcpu_eligible_for_directed_yield(vcpu))
@@ -3177,6 +3192,7 @@ void kvm_vcpu_on_spin(struct kvm_vcpu *me, bool
yield_to_kernel_mode)

             yielded = kvm_vcpu_yield_to(vcpu);
             if (yielded > 0) {
+                kvm_vcpu_set_pending_interrupt(vcpu, false);
                 kvm->last_boosted_vcpu = i;
                 break;
             } else if (yielded < 0) {
