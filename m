Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BDCB423B1B2
	for <lists+kvm@lfdr.de>; Tue,  4 Aug 2020 02:32:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729279AbgHDAcB (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 3 Aug 2020 20:32:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41488 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729221AbgHDAcA (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 3 Aug 2020 20:32:00 -0400
Received: from mail-pg1-x544.google.com (mail-pg1-x544.google.com [IPv6:2607:f8b0:4864:20::544])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B4A25C06174A
        for <kvm@vger.kernel.org>; Mon,  3 Aug 2020 17:32:00 -0700 (PDT)
Received: by mail-pg1-x544.google.com with SMTP id o13so21157889pgf.0
        for <kvm@vger.kernel.org>; Mon, 03 Aug 2020 17:32:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=ai8WbK+SXwuJDxkBKbMxeQLFCKmPAxXHO5IzqCRJqVQ=;
        b=nWO/47bGThgdVWwFmm/sXPM+Pkhj9f5jB7BK/bARXm/59F0OAi3Pnq2f/QFly+e8X2
         kPql01AcjTjHQzAoG2ARe/+KfCKPYwk01I8UwKvAdKWvpAClVIBUTPpGHhe/6fdTFBo0
         do37T6PeNbAFHzOXq3DTPg/1MHemey/TRnsqHCznYMRmXe5fDnQzMS6fexVCJ20gte6l
         Z3MGUvrKGD3wJwJ+X+wYQ/EAnNngba+7scdMzxJvMB4+4Rl6v7ALAjpuskrPnGtUKhwU
         gPWq9nmep0z8vOQG3JbNmdU5cRp69PAYjpVLGxZTpRg4EXmjc9SQXviIlEQiGeiAvO0x
         eb2w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=ai8WbK+SXwuJDxkBKbMxeQLFCKmPAxXHO5IzqCRJqVQ=;
        b=EKVijLCKjUTye1+7lkPrFDN1stCGG0gXWvw+o1e+NUyQSygwgNdTWx08CMWfDzvu63
         chiozg4kH4ZBRiysxyHSmoOZWclvxjX8444DUJaShCKE8y+BaKZ+onxxiXL/qjGE27BK
         XgibG/VkHVQBFcX0FZ5w4co0K9hH8fOiZKwKKZBqhg9XkfveN63XU7ABcrMwqBZD/8sJ
         heVg418ypqN27SXdeP7GvLR5VZkuFW2bYFOOmmXPIY9uOyw+ooc2u5zNnh94JkkzkhuS
         aHEGrGJ641CSwloTM4FBEBNcr7u7/HLQR968k3PA5stT1TH30EUBr2KbFdR/TK5nDgQM
         OVQQ==
X-Gm-Message-State: AOAM530rAu5W7QbbndQr8EHqIHNkslbeVumA135Nbbmeb2+7OS2oVl2w
        sVrnUUil3jY6oSSFJIfFRte+JfkI
X-Google-Smtp-Source: ABdhPJzzM8dc24JxlNdGyMx3aclJAJ8LBSFX5LszRE/moZVybJwdBjWtO3EqdK343GxogtHJFGl4cw==
X-Received: by 2002:a62:1951:: with SMTP id 78mr18280488pfz.137.1596501119886;
        Mon, 03 Aug 2020 17:31:59 -0700 (PDT)
Received: from localhost.localdomain ([103.7.29.6])
        by smtp.googlemail.com with ESMTPSA id e3sm19950714pgu.40.2020.08.03.17.31.57
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 03 Aug 2020 17:31:59 -0700 (PDT)
From:   Wanpeng Li <kernellwp@gmail.com>
X-Google-Original-From: Wanpeng Li <wanpengli@tencent.com>
To:     kvm@vger.kernel.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>
Subject: [PATCH v2] x86: tscdeadline timer testing when apic disabled
Date:   Tue,  4 Aug 2020 08:31:50 +0800
Message-Id: <1596501110-22239-1-git-send-email-wanpengli@tencent.com>
X-Mailer: git-send-email 2.7.4
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Wanpeng Li <wanpengli@tencent.com>

This patch adds tscdeadline timer testing when apic is hw disabled.

Signed-off-by: Wanpeng Li <wanpengli@tencent.com>
---
 x86/apic.c | 29 +++++++++++++++++++++++------
 1 file changed, 23 insertions(+), 6 deletions(-)

diff --git a/x86/apic.c b/x86/apic.c
index a7681fe..123ba26 100644
--- a/x86/apic.c
+++ b/x86/apic.c
@@ -30,15 +30,20 @@ static void tsc_deadline_timer_isr(isr_regs_t *regs)
     eoi();
 }
 
-static void __test_tsc_deadline_timer(void)
+static void __test_tsc_deadline_timer(bool apic_enabled)
 {
     handle_irq(TSC_DEADLINE_TIMER_VECTOR, tsc_deadline_timer_isr);
     irq_enable();
 
     wrmsr(MSR_IA32_TSCDEADLINE, rdmsr(MSR_IA32_TSC));
     asm volatile ("nop");
-    report(tdt_count == 1, "tsc deadline timer");
-    report(rdmsr(MSR_IA32_TSCDEADLINE) == 0, "tsc deadline timer clearing");
+    if (apic_enabled) {
+        report(tdt_count == 1, "tsc deadline timer");
+        report(rdmsr(MSR_IA32_TSCDEADLINE) == 0, "tsc deadline timer clearing");
+    } else {
+        report(tdt_count == 0, "tsc deadline timer didn't fire");
+        report(rdmsr(MSR_IA32_TSCDEADLINE) == 0, "tsc deadline timer is not set");
+    }
 }
 
 static int enable_tsc_deadline_timer(void)
@@ -54,10 +59,10 @@ static int enable_tsc_deadline_timer(void)
     }
 }
 
-static void test_tsc_deadline_timer(void)
+static void test_tsc_deadline_timer(bool apic_enabled)
 {
     if(enable_tsc_deadline_timer()) {
-        __test_tsc_deadline_timer();
+        __test_tsc_deadline_timer(apic_enabled);
     } else {
         report_skip("tsc deadline timer not detected");
     }
@@ -132,6 +137,17 @@ static void verify_disabled_apic_mmio(void)
     write_cr8(cr8);
 }
 
+static void verify_disabled_apic_tsc_deadline_timer(void)
+{
+    reset_apic();
+    if (enable_tsc_deadline_timer()) {
+        disable_apic();
+        __test_tsc_deadline_timer(false);
+    } else {
+        report_skip("tsc deadline timer not detected");
+    }
+}
+
 static void test_apic_disable(void)
 {
     volatile u32 *lvr = (volatile u32 *)(APIC_DEFAULT_PHYS_BASE + APIC_LVR);
@@ -148,6 +164,7 @@ static void test_apic_disable(void)
     report(!this_cpu_has(X86_FEATURE_APIC),
            "CPUID.1H:EDX.APIC[bit 9] is clear");
     verify_disabled_apic_mmio();
+    verify_disabled_apic_tsc_deadline_timer();
 
     reset_apic();
     report((rdmsr(MSR_IA32_APICBASE) & (APIC_EN | APIC_EXTD)) == APIC_EN,
@@ -668,7 +685,7 @@ int main(void)
 
     test_apic_timer_one_shot();
     test_apic_change_mode();
-    test_tsc_deadline_timer();
+    test_tsc_deadline_timer(true);
 
     return report_summary();
 }
-- 
2.7.4

