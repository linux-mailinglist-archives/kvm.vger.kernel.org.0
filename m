Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 713BD1CC0C9
	for <lists+kvm@lfdr.de>; Sat,  9 May 2020 13:16:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728635AbgEILQl (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 9 May 2020 07:16:41 -0400
Received: from us-smtp-1.mimecast.com ([205.139.110.61]:41124 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1728260AbgEILQ3 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Sat, 9 May 2020 07:16:29 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1589022987;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=i65u0loZ+URx1fB/wqG6cjTO7Ynjzo+5bpMPHJof7I0=;
        b=bWiaLslBj1Kchbzs7zG+iZoX2vp7C5AUXeot6X23NiroeRP3JYjzsAVzXn0GBY97GeJhWb
        lKk5sXRglyni6i2fw8om42sxq57V5g/oATg1D+6RT1siy+yk10p24gNI7XtZCPtIdA3Jqa
        0xGrUXOkaiqtmpC2QNtYAmeGYUjSQsM=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-78-pgXS5jojMwenKNne6iLgaA-1; Sat, 09 May 2020 07:16:24 -0400
X-MC-Unique: pgXS5jojMwenKNne6iLgaA-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 2E42A80058A;
        Sat,  9 May 2020 11:16:23 +0000 (UTC)
Received: from virtlab710.virt.lab.eng.bos.redhat.com (virtlab710.virt.lab.eng.bos.redhat.com [10.19.152.252])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 998DA61982;
        Sat,  9 May 2020 11:16:22 +0000 (UTC)
From:   Cathy Avery <cavery@redhat.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        pbonzini@redhat.com
Subject: [PATCH kvm-unit-tests] svm: Test V_IRQ injection
Date:   Sat,  9 May 2020 07:16:22 -0400
Message-Id: <20200509111622.2184-1-cavery@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Test V_IRQ injection from L1 to L2 with V_TPR less
than or greater than V_INTR_PRIO. Also test VINTR
intercept with differing V_TPR and V_INTR_PRIO.

Signed-off-by: Cathy Avery <cavery@redhat.com>
---
 x86/svm_tests.c | 150 ++++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 150 insertions(+)

diff --git a/x86/svm_tests.c b/x86/svm_tests.c
index 65008ba..aa6f3c2 100644
--- a/x86/svm_tests.c
+++ b/x86/svm_tests.c
@@ -1595,6 +1595,153 @@ static bool exc_inject_check(struct svm_test *test)
     return count_exc == 1 && get_test_stage(test) == 3;
 }
 
+static volatile bool virq_fired;
+
+static void virq_isr(isr_regs_t *regs)
+{
+    virq_fired = true;
+}
+
+static void virq_inject_prepare(struct svm_test *test)
+{
+    handle_irq(0xf1, virq_isr);
+    default_prepare(test);
+    vmcb->control.int_ctl = V_INTR_MASKING_MASK | V_IRQ_MASK |
+                            (0x0f << V_INTR_PRIO_SHIFT); // Set to the highest priority
+    vmcb->control.int_vector = 0xf1;
+    virq_fired = false;
+    set_test_stage(test, 0);
+}
+
+static void virq_inject_test(struct svm_test *test)
+{
+    if (virq_fired) {
+        report(false, "virtual interrupt fired before L2 sti");
+        set_test_stage(test, -1);
+        vmmcall();
+    }
+
+    irq_enable();
+    asm volatile ("nop");
+    irq_disable();
+
+    if (!virq_fired) {
+        report(false, "virtual interrupt not fired after L2 sti");
+        set_test_stage(test, -1);
+    }
+
+    vmmcall();
+
+    if (virq_fired) {
+        report(false, "virtual interrupt fired before L2 sti after VINTR intercept");
+        set_test_stage(test, -1);
+        vmmcall();
+    }
+
+    irq_enable();
+    asm volatile ("nop");
+    irq_disable();
+
+    if (!virq_fired) {
+        report(false, "virtual interrupt not fired after return from VINTR intercept");
+        set_test_stage(test, -1);
+    }
+
+    vmmcall();
+
+    irq_enable();
+    asm volatile ("nop");
+    irq_disable();
+
+    if (virq_fired) {
+        report(false, "virtual interrupt fired when V_IRQ_PRIO less than V_TPR");
+        set_test_stage(test, -1);
+    }
+
+    vmmcall();
+    vmmcall();
+}
+
+static bool virq_inject_finished(struct svm_test *test)
+{
+    vmcb->save.rip += 3;
+
+    switch (get_test_stage(test)) {
+    case 0:
+        if (vmcb->control.exit_code != SVM_EXIT_VMMCALL) {
+            report(false, "VMEXIT not due to vmmcall. Exit reason 0x%x",
+                   vmcb->control.exit_code);
+            return true;
+        }
+        if (vmcb->control.int_ctl & V_IRQ_MASK) {
+            report(false, "V_IRQ not cleared on VMEXIT after firing");
+            return true;
+        }
+        virq_fired = false;
+        vmcb->control.intercept |= (1ULL << INTERCEPT_VINTR);
+        vmcb->control.int_ctl = V_INTR_MASKING_MASK | V_IRQ_MASK |
+                            (0x0f << V_INTR_PRIO_SHIFT);
+        break;
+
+    case 1:
+        if (vmcb->control.exit_code != SVM_EXIT_VINTR) {
+            report(false, "VMEXIT not due to vintr. Exit reason 0x%x",
+                   vmcb->control.exit_code);
+            return true;
+        }
+        if (virq_fired) {
+            report(false, "V_IRQ fired before SVM_EXIT_VINTR");
+            return true;
+        }
+        vmcb->control.intercept &= ~(1ULL << INTERCEPT_VINTR);
+        break;
+
+    case 2:
+        if (vmcb->control.exit_code != SVM_EXIT_VMMCALL) {
+            report(false, "VMEXIT not due to vmmcall. Exit reason 0x%x",
+                   vmcb->control.exit_code);
+            return true;
+        }
+        virq_fired = false;
+        // Set irq to lower priority
+        vmcb->control.int_ctl = V_INTR_MASKING_MASK | V_IRQ_MASK |
+                            (0x08 << V_INTR_PRIO_SHIFT);
+        // Raise guest TPR
+        vmcb->control.int_ctl |= 0x0a & V_TPR_MASK;
+        break;
+
+    case 3:
+        if (vmcb->control.exit_code != SVM_EXIT_VMMCALL) {
+            report(false, "VMEXIT not due to vmmcall. Exit reason 0x%x",
+                   vmcb->control.exit_code);
+            return true;
+        }
+        vmcb->control.intercept |= (1ULL << INTERCEPT_VINTR);
+        break;
+
+    case 4:
+        // INTERCEPT_VINTR should be ignored because V_INTR_PRIO < V_TPR
+        if (vmcb->control.exit_code != SVM_EXIT_VMMCALL) {
+            report(false, "VMEXIT not due to vmmcall. Exit reason 0x%x",
+                   vmcb->control.exit_code);
+            return true;
+        }
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
+static bool virq_inject_check(struct svm_test *test)
+{
+    return get_test_stage(test) == 5;
+}
+
 #define TEST(name) { #name, .v2 = name }
 
 /*
@@ -1750,6 +1897,9 @@ struct svm_test svm_tests[] = {
     { "nmi_hlt", smp_supported, nmi_prepare,
       default_prepare_gif_clear, nmi_hlt_test,
       nmi_hlt_finished, nmi_hlt_check },
+    { "virq_inject", default_supported, virq_inject_prepare,
+      default_prepare_gif_clear, virq_inject_test,
+      virq_inject_finished, virq_inject_check },
     TEST(svm_guest_state_test),
     { NULL, NULL, NULL, NULL, NULL, NULL, NULL }
 };
-- 
2.20.1

