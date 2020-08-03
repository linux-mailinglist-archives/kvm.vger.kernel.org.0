Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C3C8723A091
	for <lists+kvm@lfdr.de>; Mon,  3 Aug 2020 10:02:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725992AbgHCICP (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 3 Aug 2020 04:02:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57958 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725831AbgHCICN (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 3 Aug 2020 04:02:13 -0400
Received: from mail-pj1-x1044.google.com (mail-pj1-x1044.google.com [IPv6:2607:f8b0:4864:20::1044])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1388FC06174A
        for <kvm@vger.kernel.org>; Mon,  3 Aug 2020 01:02:12 -0700 (PDT)
Received: by mail-pj1-x1044.google.com with SMTP id d4so1046050pjx.5
        for <kvm@vger.kernel.org>; Mon, 03 Aug 2020 01:02:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=L2PblpgL3CGwc/wlyAeS1CF9qVtD8Duc1V7eteOfD0U=;
        b=mOXLUEYdmnWZcV98Jw0+r95FfC3RTrAUzbxzD/ODbkZ2fiK22TAC8JJiDYRK5iwOiC
         3kbSNZ2LhwU1B1C/Zeh/O8UtF4+bw0QCcLxjBB/e84ZmllmU4a1Gpr+ZPNr02pxF/qgS
         emwiRlPR7qbTee7oWplOYjf4U9oHHf5th8B2oHKpx2Iv9uViBltXLLYJqlJh9h912g44
         O3N9mqitQ1p6z2UJpUoPbq9yvPdmr1WquwNKSztcXW208RScxgE6agx0QFceY/A9VHt1
         bjjSkHUtrndnVpRgtvvp2mjpdW2NY63Lic01maMZpzyS8NaBCie3LXRvs4GwMeW1sIze
         kB7A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=L2PblpgL3CGwc/wlyAeS1CF9qVtD8Duc1V7eteOfD0U=;
        b=GzQdO0CsQbtrr2m6vllxjpWxdhFm1HXQGxfCeLfcAJ3bDGrIZt112/rVStkFzAa6yD
         l2Yz+domCbYqFhvocj7cU9gonGT3GeDhG6ZF4g4Mbb1KutZzC+2GydU3VoCrZxtSLe4Z
         5gbqBnqszmMjJAji4aWOvI7k6XHZm/2T1VufsnykkovvGC8BMCS5GKyp3ZqDYZoexAbq
         kHMNHhlcWhamuT2HN5RbaZb1MKry3FN9ljSncb4svL3wDK7dbeVnl253ZnzcSEHc8ijF
         04rR0KbcCsa+yp0x0l4acQK3gdN6OhgwJttzFAR+XCM5dsCBlHcQBTQMHlAtP21paGEP
         Ok8Q==
X-Gm-Message-State: AOAM530JF9eB9wwlyXz26QLZntF+R5mmdjYmKBDmoyCUnau2EuOnLMQx
        XTZiFMyRtKylilvkviPxKArUBDek
X-Google-Smtp-Source: ABdhPJyJBtb19IzBZaRClC1AVH+IuYPskgQrTu0+lcIy//03kBTQqkCSDq5etJT2sWp/+bLf46iThA==
X-Received: by 2002:a17:90b:4a4e:: with SMTP id lb14mr3938431pjb.228.1596441731500;
        Mon, 03 Aug 2020 01:02:11 -0700 (PDT)
Received: from localhost.localdomain ([103.7.29.6])
        by smtp.googlemail.com with ESMTPSA id h63sm16559661pjb.29.2020.08.03.01.02.09
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 03 Aug 2020 01:02:10 -0700 (PDT)
From:   Wanpeng Li <kernellwp@gmail.com>
X-Google-Original-From: Wanpeng Li <wanpengli@tencent.com>
To:     kvm@vger.kernel.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>
Subject: [kvm-unit-tests PATCH] x86: tscdeadline timer testing when apic is hw disabled
Date:   Mon,  3 Aug 2020 16:01:55 +0800
Message-Id: <1596441715-14959-1-git-send-email-wanpengli@tencent.com>
X-Mailer: git-send-email 2.7.4
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Wanpeng Li <wanpengli@tencent.com>

This patch adds tscdeadline timer testing when apic is hw disabled.

Signed-off-by: Wanpeng Li <wanpengli@tencent.com>
---
 x86/apic.c | 27 +++++++++++++++++++++------
 1 file changed, 21 insertions(+), 6 deletions(-)

diff --git a/x86/apic.c b/x86/apic.c
index a7681fe..bcf56e2 100644
--- a/x86/apic.c
+++ b/x86/apic.c
@@ -30,15 +30,18 @@ static void tsc_deadline_timer_isr(isr_regs_t *regs)
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
+    } else
+        report(rdmsr(MSR_IA32_TSCDEADLINE) == 0, "tsc deadline timer is not set");
 }
 
 static int enable_tsc_deadline_timer(void)
@@ -54,10 +57,10 @@ static int enable_tsc_deadline_timer(void)
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
@@ -132,6 +135,17 @@ static void verify_disabled_apic_mmio(void)
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
@@ -148,6 +162,7 @@ static void test_apic_disable(void)
     report(!this_cpu_has(X86_FEATURE_APIC),
            "CPUID.1H:EDX.APIC[bit 9] is clear");
     verify_disabled_apic_mmio();
+    verify_disabled_apic_tsc_deadline_timer();
 
     reset_apic();
     report((rdmsr(MSR_IA32_APICBASE) & (APIC_EN | APIC_EXTD)) == APIC_EN,
@@ -668,7 +683,7 @@ int main(void)
 
     test_apic_timer_one_shot();
     test_apic_change_mode();
-    test_tsc_deadline_timer();
+    test_tsc_deadline_timer(true);
 
     return report_summary();
 }
-- 
2.7.4

