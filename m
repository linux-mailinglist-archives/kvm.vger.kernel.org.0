Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 492EDB33D7
	for <lists+kvm@lfdr.de>; Mon, 16 Sep 2019 06:03:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725853AbfIPEDC (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 16 Sep 2019 00:03:02 -0400
Received: from mail-ot1-f66.google.com ([209.85.210.66]:42637 "EHLO
        mail-ot1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725730AbfIPEDC (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 16 Sep 2019 00:03:02 -0400
Received: by mail-ot1-f66.google.com with SMTP id c10so34357754otd.9;
        Sun, 15 Sep 2019 21:03:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=MO99i9mXaEOJiKYYZONOtDCqaLIAO0yEzXnTE3xFd9w=;
        b=axVUIv6tfRpmCQypOp3Nufj7NSNtRNUeb9NufEPHAGxJ8SgNj6UdRWuWFtLsXSFNnT
         7ZaiW+4NvLUY2+hdrgMM1tJRxLt18fJhxmDyBBHMtfsHe8YAxRAJNRCDfSZxVFfLF1Di
         /iWmIyQd7QdGuj5kaQKG9c816QfBhnpuM1PcovlSNK+rCG/Zxm5bdViHQEuVGlP5NjaK
         6AuUq2ILZfd9YWFQaKOVhsiDYKCgNeUTrKFjokX4hqhS0z5s+yjz6bCKV2HvJPfO9jIN
         mgnmyWcsxgksSx71IbPiCPWQTHk1yw8pYzz2/M9JBJv0gwBX17Uzk76vci9c+p2/Gcqp
         kqqA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=MO99i9mXaEOJiKYYZONOtDCqaLIAO0yEzXnTE3xFd9w=;
        b=S5VgOErPQ8OswcVGdo6++c4dYPYtL+JGeAaAPFM5nw6Zyr5x9fFUQJ+Z3kICIEFf27
         83WQ9u8hhA4lt+m9/ZNF1Z9HMf9SLscII2jErUXbtOtHYuvmNnXlNr4Wa5eY1yn5P0hJ
         2krGtDFDcYXS/id7HwpzAEurwdLy0eH/4+QDjVeKAxpQFugCbVywc3CU7YWUchxFKUKX
         eoizv4qU5o3igRhscUvL9C1t2kzsacFPalnQxy4SZOCvhHubcMwyN1n3dysTE0Xy0Snq
         Om74K+XTUDKixzYzrxs5A6sjXsNOCetUFrU3guQ50ajqjSfvS9VriIl9GsrThOFlwIuI
         FL2g==
X-Gm-Message-State: APjAAAVDN26kJUgUdfNQZUAfrhjGE4pSqbeZsQDnGECZ/3obpMSCmn5I
        NGkze3xVjXr9HUxwbBZfWBrqCuCJ7eBssKg/90w=
X-Google-Smtp-Source: APXvYqz1THClfa3II9z8tDk6V/d875qMpiUs/xIoWf8/qmW7KQU7arC18V1uI5yIs3jrYcLpWxnEnmMtTXHhv84129A=
X-Received: by 2002:a9d:4597:: with SMTP id x23mr31647946ote.185.1568606580868;
 Sun, 15 Sep 2019 21:03:00 -0700 (PDT)
MIME-Version: 1.0
References: <1566980342-22045-1-git-send-email-wanpengli@tencent.com>
 <a1c6c974-a6f2-aa71-aa2e-4c987447f419@redhat.com> <TY2PR02MB4160421A8C88D96C8BCB971180B00@TY2PR02MB4160.apcprd02.prod.outlook.com>
 <8054e73d-1e09-0f98-4beb-3caa501f2ac7@redhat.com>
In-Reply-To: <8054e73d-1e09-0f98-4beb-3caa501f2ac7@redhat.com>
From:   Wanpeng Li <kernellwp@gmail.com>
Date:   Mon, 16 Sep 2019 12:02:49 +0800
Message-ID: <CANRm+Cy+5pompcDDS2C9YnxvE_-87i24gbBfc53Qa1tcWNck2Q@mail.gmail.com>
Subject: Re: [PATCH v3 1/2] KVM: LAPIC: Tune lapic_timer_advance_ns smoothly
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Wanpeng Li <wanpeng.li@hotmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        =?UTF-8?B?UmFkaW0gS3LEjW3DocWZ?= <rkrcmar@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, 12 Sep 2019 at 20:37, Paolo Bonzini <pbonzini@redhat.com> wrote:
>
> On 12/09/19 02:34, Wanpeng Li wrote:
> >>> -        timer_advance_ns -= min((u32)ns,
> >>> -            timer_advance_ns / LAPIC_TIMER_ADVANCE_ADJUST_STEP);
> >>> +        timer_advance_ns -= ns;
>
> Looking more closely, this assignment...
>
> >>>    } else {
> >>>    /* too late */
> >>>        ns = advance_expire_delta * 1000000ULL;
> >>>        do_div(ns, vcpu->arch.virtual_tsc_khz);
> >>> -        timer_advance_ns += min((u32)ns,
> >>> -            timer_advance_ns / LAPIC_TIMER_ADVANCE_ADJUST_STEP);
> >>> +        timer_advance_ns += ns;
>
> ... and this one are dead code now.  However...
>
> >>>    }
> >>>
> >>> +    timer_advance_ns = (apic->lapic_timer.timer_advance_ns *
> >>> +        (LAPIC_TIMER_ADVANCE_ADJUST_STEP - 1) + advance_expire_delta) /
> >>> +        LAPIC_TIMER_ADVANCE_ADJUST_STEP;
>
> ... you should instead remove this new assignment and just make the
> assignments above just
>
>         timer_advance -= ns / LAPIC_TIMER_ADVANCE_ADJUST_STEP;
>
> and
>
>         timer_advance -= ns / LAPIC_TIMER_ADVANCE_ADJUST_STEP;
>
> In fact this whole last assignment is buggy, since advance_expire_delta
> is in TSC units rather than nanoseconds.
>
> >>>    if (abs(advance_expire_delta) < LAPIC_TIMER_ADVANCE_ADJUST_DONE)
> >>>        apic->lapic_timer.timer_advance_adjust_done = true;
> >>>    if (unlikely(timer_advance_ns > 5000)) {
> >> This looks great.  But instead of patch 2, why not remove
> >> timer_advance_adjust_done altogether?
> > It can fluctuate w/o stop.
>
> Possibly because of the wrong calculation of timer_advance_ns?

Hi Paolo,

Something like below? It still fluctuate when running complex guest os
like linux. Removing timer_advance_adjust_done will hinder introduce
patch v3 2/2 since there is no adjust done flag in each round
evaluation. I have two questions here, best-effort tune always as
below or periodically revaluate to get conservative value and get
best-effort value in each round evaluation as patch v3 2/2, which one
do you prefer? The former one can wast time to wait sometimes and the
later one can not get the best latency. In addition, can the adaptive
tune algorithm be using in all the scenarios contain
RT/over-subscribe?

---8<---
diff --git a/arch/x86/kvm/lapic.c b/arch/x86/kvm/lapic.c
index 685d17c..895735b 100644
--- a/arch/x86/kvm/lapic.c
+++ b/arch/x86/kvm/lapic.c
@@ -69,6 +69,7 @@
 #define LAPIC_TIMER_ADVANCE_ADJUST_INIT 1000
 /* step-by-step approximation to mitigate fluctuation */
 #define LAPIC_TIMER_ADVANCE_ADJUST_STEP 8
+#define LAPIC_TIMER_ADVANCE_FILTER 5000

 static inline int apic_test_vector(int vec, void *bitmap)
 {
@@ -1479,29 +1480,28 @@ static inline void
adjust_lapic_timer_advance(struct kvm_vcpu *vcpu,
                           s64 advance_expire_delta)
 {
     struct kvm_lapic *apic = vcpu->arch.apic;
-    u32 timer_advance_ns = apic->lapic_timer.timer_advance_ns;
-    u64 ns;
+    u32 timer_advance_ns = apic->lapic_timer.timer_advance_ns, ns;
+
+    if (abs(advance_expire_delta) > LAPIC_TIMER_ADVANCE_FILTER ||
+        abs(advance_expire_delta) < LAPIC_TIMER_ADVANCE_ADJUST_DONE) {
+        /* filter out random fluctuations */
+        return;
+    }

     /* too early */
     if (advance_expire_delta < 0) {
         ns = -advance_expire_delta * 1000000ULL;
         do_div(ns, vcpu->arch.virtual_tsc_khz);
-        timer_advance_ns -= min((u32)ns,
-            timer_advance_ns / LAPIC_TIMER_ADVANCE_ADJUST_STEP);
+        timer_advance_ns -= ns/LAPIC_TIMER_ADVANCE_ADJUST_STEP;
     } else {
     /* too late */
         ns = advance_expire_delta * 1000000ULL;
         do_div(ns, vcpu->arch.virtual_tsc_khz);
-        timer_advance_ns += min((u32)ns,
-            timer_advance_ns / LAPIC_TIMER_ADVANCE_ADJUST_STEP);
+        timer_advance_ns += ns/LAPIC_TIMER_ADVANCE_ADJUST_STEP;
     }

-    if (abs(advance_expire_delta) < LAPIC_TIMER_ADVANCE_ADJUST_DONE)
-        apic->lapic_timer.timer_advance_adjust_done = true;
-    if (unlikely(timer_advance_ns > 5000)) {
+    if (unlikely(timer_advance_ns > 5000))
         timer_advance_ns = LAPIC_TIMER_ADVANCE_ADJUST_INIT;
-        apic->lapic_timer.timer_advance_adjust_done = false;
-    }
     apic->lapic_timer.timer_advance_ns = timer_advance_ns;
 }

@@ -1521,7 +1521,7 @@ static void __kvm_wait_lapic_expire(struct kvm_vcpu *vcpu)
     if (guest_tsc < tsc_deadline)
         __wait_lapic_expire(vcpu, tsc_deadline - guest_tsc);

-    if (unlikely(!apic->lapic_timer.timer_advance_adjust_done))
+    if (lapic_timer_advance_ns == -1)
         adjust_lapic_timer_advance(vcpu,
apic->lapic_timer.advance_expire_delta);
 }

@@ -2298,10 +2298,8 @@ int kvm_create_lapic(struct kvm_vcpu *vcpu, int
timer_advance_ns)
     apic->lapic_timer.timer.function = apic_timer_fn;
     if (timer_advance_ns == -1) {
         apic->lapic_timer.timer_advance_ns = LAPIC_TIMER_ADVANCE_ADJUST_INIT;
-        apic->lapic_timer.timer_advance_adjust_done = false;
     } else {
         apic->lapic_timer.timer_advance_ns = timer_advance_ns;
-        apic->lapic_timer.timer_advance_adjust_done = true;
     }


diff --git a/arch/x86/kvm/lapic.h b/arch/x86/kvm/lapic.h
index 50053d2..2aad7e2 100644
--- a/arch/x86/kvm/lapic.h
+++ b/arch/x86/kvm/lapic.h
@@ -35,7 +35,6 @@ struct kvm_timer {
     s64 advance_expire_delta;
     atomic_t pending;            /* accumulated triggered timers */
     bool hv_timer_in_use;
-    bool timer_advance_adjust_done;
 };

 struct kvm_lapic {
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 93b0bd4..4f65ef1 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -141,7 +141,7 @@
  * advancement entirely.  Any other value is used as-is and disables adaptive
  * tuning, i.e. allows priveleged userspace to set an exact advancement time.
  */
-static int __read_mostly lapic_timer_advance_ns = -1;
+int __read_mostly lapic_timer_advance_ns = -1;
 module_param(lapic_timer_advance_ns, int, S_IRUGO | S_IWUSR);

 static bool __read_mostly vector_hashing = true;
diff --git a/arch/x86/kvm/x86.h b/arch/x86/kvm/x86.h
index 6594020..2c6ba86 100644
--- a/arch/x86/kvm/x86.h
+++ b/arch/x86/kvm/x86.h
@@ -301,6 +301,7 @@ int x86_emulate_instruction(struct kvm_vcpu *vcpu,
unsigned long cr2,

 extern bool enable_vmware_backdoor;

+extern int lapic_timer_advance_ns;
 extern int pi_inject_timer;

 extern struct static_key kvm_no_apic_vcpu;
