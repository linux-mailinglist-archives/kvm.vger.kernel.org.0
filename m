Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A092E17A24F
	for <lists+kvm@lfdr.de>; Thu,  5 Mar 2020 10:37:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726203AbgCEJgx (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 5 Mar 2020 04:36:53 -0500
Received: from mail-wr1-f67.google.com ([209.85.221.67]:37418 "EHLO
        mail-wr1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725877AbgCEJgw (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 5 Mar 2020 04:36:52 -0500
Received: by mail-wr1-f67.google.com with SMTP id 6so676047wre.4
        for <kvm@vger.kernel.org>; Thu, 05 Mar 2020 01:36:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=MOgK6NFNGxAA1r/EZk2AtBrPSIeqQ8JHV7jzUqNIolk=;
        b=k7pZFmyX5hAXYH2scTeP8vp0BzG6pEmDAdvQHDFS2gAHTKoRq+L8+uIoYW76L8VbNA
         oI54snd5Xi7YBRUT/jGMAnibTRR06BgeFxqn0U/yzZRDovQUizg1dVQ+aU83WTy0iBNj
         JUvYFt42eygd4VTWQknC4jDiO1gJIZE6Q6T9z/pRyKi09tdiqPN0YNy154xrU9BUSSBl
         erml+11QLY7B/D3mUDKuuaef0BwyObfBhuIGb25ODJWH0sA3XSVDMyo27kbQ0pxzqgwL
         b8cPfyiguVYtsLKDMQQducVttSlKDToJYch8xoRpoEOmRQjovFb70PMZ1qkodHiJ79lJ
         HBjw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:from:to:cc:subject:date:message-id
         :in-reply-to:references;
        bh=MOgK6NFNGxAA1r/EZk2AtBrPSIeqQ8JHV7jzUqNIolk=;
        b=EPnDeeRBOGq8FlbFjFxDn4oHxB2gAVXa3v6tZqr99fGJbKcb0Ffi61BMnPsGydssn2
         Mpg6fWvTnJFdmrMp+cqIn7WRSRsTJnv8lzU7OZXWdoQPOUcUd8ztyhM+NkrPFrNT69wL
         ijvCV+VOKUFKXeysWt/U3awKXNe5PyKTi+vEdDmmn6JMp4EZUAG79Sj0Wvr/GFJobrX2
         OjqnXBZ2laZsR6J80kN4ZEeIPGpLQuFMl1AIRhHISuHq4dibAVw9DM1Y4IoT9pQAKVAx
         FUP3fJZa8wThC7rDP5ORPPjX9ff6EAwLFqBx9eV1e0ZpVMe1OT8RaUMHlrIlb83UNSM+
         +DGw==
X-Gm-Message-State: ANhLgQ2Y5mqp/wVtW24aRu/vJ5jH5BvEUPJilbl8Zz/wh7KIxvJbhKeE
        e0DxdEChgQURVxfPeV7uEykEnY2J
X-Google-Smtp-Source: ADFU+vtg9fEJmRGt9TQNRDZsXDXRHVAm7hs8K2rEV4aPKqHDS2KrLh/m0z5B7/fidBlQYgz5XyQuKQ==
X-Received: by 2002:adf:b1d4:: with SMTP id r20mr8999826wra.303.1583401010346;
        Thu, 05 Mar 2020 01:36:50 -0800 (PST)
Received: from 640k.localdomain.com ([93.56.166.5])
        by smtp.gmail.com with ESMTPSA id w1sm8188563wmc.11.2020.03.05.01.36.49
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 05 Mar 2020 01:36:49 -0800 (PST)
From:   Paolo Bonzini <pbonzini@redhat.com>
To:     kvm@vger.kernel.org
Cc:     cavery@redhat.com
Subject: [PATCH kvm-unit-tests 2/2] svm: Add test cases around interrupt injection and halting
Date:   Thu,  5 Mar 2020 10:36:46 +0100
Message-Id: <1583401006-57136-3-git-send-email-pbonzini@redhat.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1583401006-57136-1-git-send-email-pbonzini@redhat.com>
References: <1583401006-57136-1-git-send-email-pbonzini@redhat.com>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Cathy Avery <cavery@redhat.com>

This test checks for interrupt delivery to L2 and
unintercepted hlt in L2. All tests are performed
both with direct interrupt injection and external
interrupt interception.

Based on VMX test by Jan Kiszka <jan.kiszka@siemens.com>

Signed-off-by: Cathy Avery <cavery@redhat.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 x86/svm.c | 141 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 141 insertions(+)

diff --git a/x86/svm.c b/x86/svm.c
index f300c8a..df7a7c4 100644
--- a/x86/svm.c
+++ b/x86/svm.c
@@ -1502,6 +1502,144 @@ static bool pending_event_cli_check(struct test *test)
     return get_test_stage(test) == 2;
 }
 
+#define TIMER_VECTOR    222
+
+static volatile bool timer_fired;
+
+static void timer_isr(isr_regs_t *regs)
+{
+    timer_fired = true;
+    apic_write(APIC_EOI, 0);
+}
+
+static void interrupt_prepare(struct test *test)
+{
+    default_prepare(test);
+    handle_irq(TIMER_VECTOR, timer_isr);
+    timer_fired = false;
+    set_test_stage(test, 0);
+}
+
+static void interrupt_test(struct test *test)
+{
+    long long start, loops;
+
+    apic_write(APIC_LVTT, TIMER_VECTOR);
+    irq_enable();
+    apic_write(APIC_TMICT, 1); //Timer Initial Count Register 0x380 one-shot
+    for (loops = 0; loops < 10000000 && !timer_fired; loops++)
+        asm volatile ("nop");
+
+    report(timer_fired, "direct interrupt while running guest");
+
+    if (!timer_fired) {
+        set_test_stage(test, -1);
+        vmmcall();
+    }
+
+    apic_write(APIC_TMICT, 0);
+    irq_disable();
+    vmmcall();
+
+    timer_fired = false;
+    apic_write(APIC_TMICT, 1);
+    for (loops = 0; loops < 10000000 && !timer_fired; loops++)
+        asm volatile ("nop");
+
+    report(timer_fired, "intercepted interrupt while running guest");
+
+    if (!timer_fired) {
+        set_test_stage(test, -1);
+        vmmcall();
+    }
+
+    irq_enable();
+    apic_write(APIC_TMICT, 0);
+    irq_disable();
+
+    timer_fired = false;
+    start = rdtsc();
+    apic_write(APIC_TMICT, 1000000);
+    asm volatile ("sti; hlt");
+
+    report(rdtsc() - start > 10000 && timer_fired,
+          "direct interrupt + hlt");
+
+    if (!timer_fired) {
+        set_test_stage(test, -1);
+        vmmcall();
+    }
+
+    apic_write(APIC_TMICT, 0);
+    irq_disable();
+    vmmcall();
+
+    timer_fired = false;
+    start = rdtsc();
+    apic_write(APIC_TMICT, 1000000);
+    asm volatile ("hlt");
+
+    report(rdtsc() - start > 10000 && timer_fired,
+           "intercepted interrupt + hlt");
+
+    if (!timer_fired) {
+        set_test_stage(test, -1);
+        vmmcall();
+    }
+
+    apic_write(APIC_TMICT, 0);
+    irq_disable();
+}
+
+static bool interrupt_finished(struct test *test)
+{
+    switch (get_test_stage(test)) {
+    case 0:
+    case 2:
+        if (test->vmcb->control.exit_code != SVM_EXIT_VMMCALL) {
+            report(false, "VMEXIT not due to vmmcall. Exit reason 0x%x",
+                   test->vmcb->control.exit_code);
+            return true;
+        }
+        test->vmcb->save.rip += 3;
+
+        test->vmcb->control.intercept |= (1ULL << INTERCEPT_INTR);
+        test->vmcb->control.int_ctl |= V_INTR_MASKING_MASK;
+        break;
+
+    case 1:
+    case 3:
+        if (test->vmcb->control.exit_code != SVM_EXIT_INTR) {
+            report(false, "VMEXIT not due to intr intercept. Exit reason 0x%x",
+                   test->vmcb->control.exit_code);
+            return true;
+        }
+
+        irq_enable();
+        asm volatile ("nop");
+        irq_disable();
+
+        test->vmcb->control.intercept &= ~(1ULL << INTERCEPT_INTR);
+        test->vmcb->control.int_ctl &= ~V_INTR_MASKING_MASK;
+        break;
+
+    case 4:
+        break;
+
+    default:
+        return true;
+    }
+
+    inc_test_stage(test);
+
+    return get_test_stage(test) == 5;
+}
+
+static bool interrupt_check(struct test *test)
+{
+    return get_test_stage(test) == 5;
+}
+
 static struct test tests[] = {
     { "null", default_supported, default_prepare,
       default_prepare_gif_clear, null_test,
@@ -1582,6 +1720,9 @@ static struct test tests[] = {
       pending_event_cli_prepare_gif_clear,
       pending_event_cli_test, pending_event_cli_finished,
       pending_event_cli_check },
+    { "interrupt", default_supported, interrupt_prepare,
+      default_prepare_gif_clear, interrupt_test,
+      interrupt_finished, interrupt_check },
 };
 
 int matched;
-- 
1.8.3.1

