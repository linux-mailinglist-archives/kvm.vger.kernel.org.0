Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2440B25BFBC
	for <lists+kvm@lfdr.de>; Thu,  3 Sep 2020 12:57:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726678AbgICK5d (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 3 Sep 2020 06:57:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59612 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725984AbgICK5M (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 3 Sep 2020 06:57:12 -0400
Received: from mail-oi1-x241.google.com (mail-oi1-x241.google.com [IPv6:2607:f8b0:4864:20::241])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 33F3DC061244;
        Thu,  3 Sep 2020 03:57:12 -0700 (PDT)
Received: by mail-oi1-x241.google.com with SMTP id 3so2712971oih.0;
        Thu, 03 Sep 2020 03:57:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=tgb1FdYv8T82Jd6w5jRiU48hqo7xQeiF2mEiL9yBweU=;
        b=QFG/4bUkbs9VfBy21pDL9Q8XUyyPe9wXhceKeY2wgDmKXEA040vTUIwfRV0anGw9Fh
         20i2QkS+e18LGuIHnf7Qj+m6Grn9ty+Nchm1j6pNiTyT7X8yzPAdxuQcBhuo5trdG2NY
         wTQ/hz8cXn8mmGN2qp/dKQTMXLCCmupdOGqrBICW66VOIo7pgOdpnT04f9RVqJ7Xv9G7
         Esl5vhvRB2opUuXpcoLRO2I4bmYhiNPAR6DXdQ5GSWN7xOxo5c7H0BSxfSc+atHaRwmn
         dxjThco2hiJjRWAR/Nt4vI92yT3+uUrmX9sjIk0Em6QJWiRPD8WnxVqrcJab6K0aJbmO
         cUJQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=tgb1FdYv8T82Jd6w5jRiU48hqo7xQeiF2mEiL9yBweU=;
        b=VpTONxvU38qntM8tR6PSXNFY7UlSQLhmOrz42wkY4vyrAeCfC32RWut9kkIzHzp4rE
         4ucrEQ+wJmoq/JjkYkAGHkRK37UBQjGMIGtN8phWQtZuzxUEMyeK3apZSo6otEEF46fa
         Ro2xXit2SF/Wu4mlK3v7vKVzvlxh1mTAPJGRO7Rq/B5h0k9d6eNlWx3z3aqE6dFlRXi7
         q5hxat6k+XjNoau2GMYccdxjkxiTxm4dQC8e6Vd7PEHc4TqwI2LwfC76TFGCmIwCniv3
         S9lZpA2qUSizYdHpj2vvdo1llnCX1gBWwYJoidAKIbBFQrJy17SFILKo/cHHEVeeGweM
         jKJA==
X-Gm-Message-State: AOAM532Dr/0ViK8Wz3BwxnrzgnK31HMrSY/0B+iQ7tE4GoqG2vDx0cGv
        SQxqHMUzB6Ga+jEbAd21Uze8HGiBui7Kv/GyoKU=
X-Google-Smtp-Source: ABdhPJz3CH6WP1pRo6OeZzRZ+/kzxbL2XIpvU4N0H7F6AR4b/9j6Kqpznt5rFAtYT7bzUgGIbfNI1Vl9iw2Z/rMwS8w=
X-Received: by 2002:aca:aa84:: with SMTP id t126mr1658938oie.5.1599130631528;
 Thu, 03 Sep 2020 03:57:11 -0700 (PDT)
MIME-Version: 1.0
References: <1598578508-14134-1-git-send-email-wanpengli@tencent.com> <20200902212328.GI11695@sjchrist-ice>
In-Reply-To: <20200902212328.GI11695@sjchrist-ice>
From:   Wanpeng Li <kernellwp@gmail.com>
Date:   Thu, 3 Sep 2020 18:57:00 +0800
Message-ID: <CANRm+CzQ00nFoYsxLQ7xhDaAnbi01U4BGkmuS9WLY80Nyt254w@mail.gmail.com>
Subject: Re: [PATCH] KVM: LAPIC: Reset timer_advance_ns if timer mode switch
To:     Sean Christopherson <sean.j.christopherson@intel.com>
Cc:     LKML <linux-kernel@vger.kernel.org>, kvm <kvm@vger.kernel.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>
Content-Type: text/plain; charset="UTF-8"
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, 3 Sep 2020 at 05:23, Sean Christopherson
<sean.j.christopherson@intel.com> wrote:
>
> On Fri, Aug 28, 2020 at 09:35:08AM +0800, Wanpeng Li wrote:
> > From: Wanpeng Li <wanpengli@tencent.com>
> >
> > per-vCPU timer_advance_ns should be set to 0 if timer mode is not tscdeadline
> > otherwise we waste cpu cycles in the function lapic_timer_int_injected(),
> > especially on AMD platform which doesn't support tscdeadline mode. We can
> > reset timer_advance_ns to the initial value if switch back to tscdealine
> > timer mode.
> >
> > Signed-off-by: Wanpeng Li <wanpengli@tencent.com>
> > ---
> >  arch/x86/kvm/lapic.c | 6 ++++++
> >  1 file changed, 6 insertions(+)
> >
> > diff --git a/arch/x86/kvm/lapic.c b/arch/x86/kvm/lapic.c
> > index 654649b..abc296d 100644
> > --- a/arch/x86/kvm/lapic.c
> > +++ b/arch/x86/kvm/lapic.c
> > @@ -1499,10 +1499,16 @@ static void apic_update_lvtt(struct kvm_lapic *apic)
> >                       kvm_lapic_set_reg(apic, APIC_TMICT, 0);
> >                       apic->lapic_timer.period = 0;
> >                       apic->lapic_timer.tscdeadline = 0;
> > +                     if (timer_mode == APIC_LVT_TIMER_TSCDEADLINE &&
> > +                             lapic_timer_advance_dynamic)
>
> Bad indentation.
>
> > +                             apic->lapic_timer.timer_advance_ns = LAPIC_TIMER_ADVANCE_NS_INIT;
>
> Redoing the tuning seems odd.  Doubt it will matter, but it feels weird to
> have to retune the advancement just because the guest toggled between modes.
>
> Rather than clear timer_advance_ns, can we simply move the check against
> apic->lapic_timer.expired_tscdeadline much earlier?  I think that would
> solve this performance hiccup, and IMO would be a logical change in any
> case.  E.g. with some refactoring to avoid more duplication between VMX and
> SVM

How about something like below:

diff --git a/arch/x86/kvm/lapic.c b/arch/x86/kvm/lapic.c
index 3b32d3b..51ed4f0 100644
--- a/arch/x86/kvm/lapic.c
+++ b/arch/x86/kvm/lapic.c
@@ -1582,9 +1582,6 @@ static void __kvm_wait_lapic_expire(struct kvm_vcpu *vcpu)
     struct kvm_lapic *apic = vcpu->arch.apic;
     u64 guest_tsc, tsc_deadline;

-    if (apic->lapic_timer.expired_tscdeadline == 0)
-        return;
-
     tsc_deadline = apic->lapic_timer.expired_tscdeadline;
     apic->lapic_timer.expired_tscdeadline = 0;
     guest_tsc = kvm_read_l1_tsc(vcpu, rdtsc());
@@ -1599,7 +1596,10 @@ static void __kvm_wait_lapic_expire(struct
kvm_vcpu *vcpu)

 void kvm_wait_lapic_expire(struct kvm_vcpu *vcpu)
 {
-    if (lapic_timer_int_injected(vcpu))
+    if (lapic_in_kernel(vcpu) &&
+        vcpu->arch.apic->lapic_timer.expired_tscdeadline &&
+        vcpu->arch.apic->lapic_timer.timer_advance_ns &&
+        lapic_timer_int_injected(vcpu))
         __kvm_wait_lapic_expire(vcpu);
 }
 EXPORT_SYMBOL_GPL(kvm_wait_lapic_expire);
@@ -1635,8 +1635,7 @@ static void apic_timer_expired(struct kvm_lapic
*apic, bool from_timer_fn)
     }

     if (kvm_use_posted_timer_interrupt(apic->vcpu)) {
-        if (apic->lapic_timer.timer_advance_ns)
-            __kvm_wait_lapic_expire(vcpu);
+        kvm_wait_lapic_expire(vcpu);
         kvm_apic_inject_pending_timer_irqs(apic);
         return;
     }
diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index 0194336..19e622a 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -3456,9 +3456,7 @@ static __no_kcsan fastpath_t svm_vcpu_run(struct
kvm_vcpu *vcpu)
     clgi();
     kvm_load_guest_xsave_state(vcpu);

-    if (lapic_in_kernel(vcpu) &&
-        vcpu->arch.apic->lapic_timer.timer_advance_ns)
-        kvm_wait_lapic_expire(vcpu);
+    kvm_wait_lapic_expire(vcpu);

     /*
      * If this vCPU has touched SPEC_CTRL, restore the guest's value if
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index a544351..d6e1656 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -6800,9 +6800,7 @@ static fastpath_t vmx_vcpu_run(struct kvm_vcpu *vcpu)
     if (enable_preemption_timer)
         vmx_update_hv_timer(vcpu);

-    if (lapic_in_kernel(vcpu) &&
-        vcpu->arch.apic->lapic_timer.timer_advance_ns)
-        kvm_wait_lapic_expire(vcpu);
+    kvm_wait_lapic_expire(vcpu);

     /*
      * If this vCPU has touched SPEC_CTRL, restore the guest's value if
