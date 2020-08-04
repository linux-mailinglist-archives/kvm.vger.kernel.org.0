Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8659023B1B9
	for <lists+kvm@lfdr.de>; Tue,  4 Aug 2020 02:39:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727779AbgHDAjf (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 3 Aug 2020 20:39:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42638 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726130AbgHDAjf (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 3 Aug 2020 20:39:35 -0400
Received: from mail-pf1-x444.google.com (mail-pf1-x444.google.com [IPv6:2607:f8b0:4864:20::444])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 45836C06174A
        for <kvm@vger.kernel.org>; Mon,  3 Aug 2020 17:39:35 -0700 (PDT)
Received: by mail-pf1-x444.google.com with SMTP id f193so8843355pfa.12
        for <kvm@vger.kernel.org>; Mon, 03 Aug 2020 17:39:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=P7K1/or27Q5kuNX+G726+alc8/6c9ST1cR6CdnWA9Ek=;
        b=sE2zzvp+3n8gXNBzs1nAoCGBiFS/us8VMTP5rvpCJdHhaQ0xMm4+SWWplfOk3oTBOo
         qBQ39Iid9wIFlsjXqSS4SAbvzL1HLf9jjr8q15KuJdJwqXrbZixDHcnb1xBNrVHifT7N
         L4fgdzUm48L6j5g2mfW9O4IhzM4jg3geakAz8I+IO/HnCCRgW3N0rfcr5tLbawLa7Utt
         onrUAjYtU1VOwqTn6NsMdfQ2S3D7pfquZ1PomSZdoMOKBlf1ON26msbFsk0hJGl29dZc
         ClFCB3/5x/n5Ug3PFy3491pzXE+4MbDY38FmwEeFJjyjCyQNS/D9m6KDhcLc8Bmxo9Kp
         IX1w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=P7K1/or27Q5kuNX+G726+alc8/6c9ST1cR6CdnWA9Ek=;
        b=a39i50OeUiAKO8kkWZ8YJPya+6tg3jI2qK5QhV3nPPiJV+A5itsPqlEDMm3jrOyxgl
         Kv95OyZOnKQKJ9TWrMXl7coGNSrn9L9VDRuCU2yB6/608/HmWE0pxSH/UY5ItklEjMk7
         fkSi9aLhGYxhOHAyCVYpjiI1F9rt8vwYQJsYgPfNkNrAl5hA8RMH1W/RG2d5w7Xrg39e
         HDt89mEyaIobpaSRlBZ/VWFI2Jpq9dlZQpLJWpQRv9jdec92Ls3lnb48dBXMalOJNeKJ
         3SbQclVdhZCqIJfzcgvJfm+mPtu/xW1471CwEmYUbSxVwPUTQPuRY7/T2/CyuxJRPa6s
         EpCg==
X-Gm-Message-State: AOAM533ji34RNA4J0xjHGug8VD6Nnc9qXgt0zYhHvr9ixpGEZA0YvBLG
        ZWqYvEa8ew8va4YnnwjXDYWlgg19
X-Google-Smtp-Source: ABdhPJw4o7EGEKLPsrHpIa9TFgV/JQQ1z3OM+JXUuEvqMEfeVaHT9ac1Q3vS2pyuLzsqpbgMkqE+Lw==
X-Received: by 2002:a63:1a44:: with SMTP id a4mr17241160pgm.281.1596501574581;
        Mon, 03 Aug 2020 17:39:34 -0700 (PDT)
Received: from localhost.localdomain ([103.7.29.6])
        by smtp.googlemail.com with ESMTPSA id mp3sm2426610pjb.0.2020.08.03.17.39.32
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 03 Aug 2020 17:39:34 -0700 (PDT)
From:   Wanpeng Li <kernellwp@gmail.com>
X-Google-Original-From: Wanpeng Li <wanpengli@tencent.com>
To:     kvm@vger.kernel.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>
Subject: [kvm-unit-tests PATCH RESEND v2] x86: tscdeadline timer testing when apic disabled
Date:   Tue,  4 Aug 2020 08:39:19 +0800
Message-Id: <1596501559-22385-1-git-send-email-wanpengli@tencent.com>
X-Mailer: git-send-email 2.7.4
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Wanpeng Li <wanpengli@tencent.com>

This patch adds tscdeadline timer testing when apic is hw disabled.

Signed-off-by: Wanpeng Li <wanpengli@tencent.com>
---
v1 -> v2:
 * check tscdeadline timer didn't fire

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

