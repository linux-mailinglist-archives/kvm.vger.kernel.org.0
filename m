Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E9B7132534B
	for <lists+kvm@lfdr.de>; Thu, 25 Feb 2021 17:13:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233236AbhBYQN2 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 25 Feb 2021 11:13:28 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:21221 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233597AbhBYQLv (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 25 Feb 2021 11:11:51 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1614269422;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=PO3qZUTHG4qkGyWUyaGvKkfQcCTQSsXP6qdxfpaxZig=;
        b=YthUdM/r2vkIi3tGZTBTivfVpRq0c4a3mEb3rPcYIvVr1+BxefbwbiC7RoDzFW6xzhRsVx
        2z96in4o6gDhhTBKxOqcTcjm899XzVMT7d7DLVOPY9JchPeuCdq+FesqfmSVfQ22WxetpM
        lao6F9r0/fh97JCiAUfJSPnMYHoAdU4=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-537-YVUNemNvO-Sa4qLNXw8vUg-1; Thu, 25 Feb 2021 11:10:17 -0500
X-MC-Unique: YVUNemNvO-Sa4qLNXw8vUg-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id F3FB9801997
        for <kvm@vger.kernel.org>; Thu, 25 Feb 2021 16:10:16 +0000 (UTC)
Received: from localhost.localdomain (unknown [10.35.207.18])
        by smtp.corp.redhat.com (Postfix) with ESMTP id E33621001281;
        Thu, 25 Feb 2021 16:10:13 +0000 (UTC)
From:   Maxim Levitsky <mlevitsk@redhat.com>
To:     kvm@vger.kernel.org
Cc:     Maxim Levitsky <mlevitsk@redhat.com>
Subject: [PATCH] SVM: add two tests for exitintinto on exception
Date:   Thu, 25 Feb 2021 18:10:12 +0200
Message-Id: <20210225161012.408860-1-mlevitsk@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Test that exitintinfo is set correctly when
exception happens during exception/interrupt delivery
and that exception is intercepted.

Note that those tests currently fail, due to few bugs in KVM.

Also note that those bugs are in KVM's common x86 code,
thus the issue exists on VMX as well and unit tests
that reproduce those on VMX will be written as well.

Signed-off-by: Maxim Levitsky <mlevitsk@redhat.com>
---
 x86/svm_tests.c | 162 +++++++++++++++++++++++++++++++++++++++++++++++-
 1 file changed, 160 insertions(+), 2 deletions(-)

diff --git a/x86/svm_tests.c b/x86/svm_tests.c
index 29a0b59..c14129a 100644
--- a/x86/svm_tests.c
+++ b/x86/svm_tests.c
@@ -1886,7 +1886,7 @@ static bool reg_corruption_finished(struct svm_test *test)
                "No RIP corruption detected after %d timer interrupts",
                isr_cnt);
         set_test_stage(test, 1);
-        return true;
+        goto finished;
     }
 
     if (vmcb->control.exit_code == SVM_EXIT_INTR) {
@@ -1901,11 +1901,14 @@ static bool reg_corruption_finished(struct svm_test *test)
             report(false,
                    "RIP corruption detected after %d timer interrupts",
                    isr_cnt);
-            return true;
+            goto finished;
         }
 
     }
     return false;
+finished:
+    apic_write(APIC_LVTT, APIC_LVT_TIMER_MASK);
+    return true;
 }
 
 static bool reg_corruption_check(struct svm_test *test)
@@ -2382,6 +2385,155 @@ static void svm_vmrun_errata_test(void)
     }
 }
 
+
+/*
+ * Test that nested exceptions are delivered correctly
+ * when parent exception is intercepted
+ */
+
+static void exception_merging_prepare(struct svm_test *test)
+{
+    default_prepare(test);
+    set_test_stage(test, 0);
+
+    vmcb->control.intercept_exceptions |= (1ULL << GP_VECTOR);
+
+    /* break UD vector idt entry to get #GP*/
+    boot_idt[UD_VECTOR].type = 1;
+}
+
+static void exception_merging_test(struct svm_test *test)
+{
+    asm volatile (
+        "ud2\n\t" :
+        /* no outputs*/ :
+        /* no inputs*/ :
+        /* no clobbers*/
+    );
+}
+
+static bool exception_merging_finished(struct svm_test *test)
+{
+    u32 vec = vmcb->control.exit_int_info & SVM_EXITINTINFO_VEC_MASK;
+    u32 type = vmcb->control.exit_int_info & SVM_EXITINTINFO_TYPE_MASK;
+
+    if (vmcb->control.exit_code != SVM_EXIT_EXCP_BASE + GP_VECTOR) {
+        report(false, "unexpected VM exit");
+        goto out;
+    }
+
+    if (! (vmcb->control.exit_int_info & SVM_EXITINTINFO_VALID)) {
+        report(false, "EXITINTINFO not valid");
+        goto out;
+    }
+
+    if (type != SVM_EXITINTINFO_TYPE_EXEPT) {
+        report(false, "Incorrect event type in EXITINTINFO");
+        goto out;
+    }
+
+    if (vec != UD_VECTOR) {
+        report(false, "Incorrect vector in EXITINTINFO");
+        goto out;
+    }
+
+    set_test_stage(test, 1);
+out:
+    boot_idt[UD_VECTOR].type = 14;
+    return true;
+}
+
+static bool exception_merging_check(struct svm_test *test)
+{
+    return get_test_stage(test) == 1;
+}
+
+
+/*
+ * Test that if exception is raised during interrupt delivery,
+ * and that exception is intercepted, the interrupt is preserved
+ * in EXITINTINFO of the exception
+ */
+
+static void interrupt_merging_prepare(struct svm_test *test)
+{
+    default_prepare(test);
+    set_test_stage(test, 0);
+
+    /* intercept #GP */
+    vmcb->control.intercept_exceptions |= (1ULL << GP_VECTOR);
+
+    /* set local APIC to inject external interrupts */
+    apic_write(APIC_TMICT, 0);
+    apic_write(APIC_TDCR, 0);
+    apic_write(APIC_LVTT, TIMER_VECTOR | APIC_LVT_TIMER_PERIODIC);
+    apic_write(APIC_TMICT, 1000);
+}
+
+static void interrupt_merging_test(struct svm_test *test)
+{
+    /* break timer vector IDT entry to get #GP on interrupt delivery */
+    boot_idt[TIMER_VECTOR].type = 1;
+
+    irq_enable();
+
+    /* just wait forever */
+    for(;;);
+}
+
+static bool interrupt_merging_finished(struct svm_test *test)
+{
+    u32 vec = vmcb->control.exit_int_info & SVM_EXITINTINFO_VEC_MASK;
+    u32 type = vmcb->control.exit_int_info & SVM_EXITINTINFO_TYPE_MASK;
+    u32 error_code = vmcb->control.exit_info_1;
+
+    /* exit on external interrupts is disabled, thus timer interrupt
+     * should be attempted to be delivered, but due to incorrect IDT entry
+     * an #GP should be raised
+     */
+    if (vmcb->control.exit_code != SVM_EXIT_EXCP_BASE + GP_VECTOR) {
+        report(false, "unexpected VM exit");
+        goto out;
+    }
+
+    /* GP error code should be about an IDT entry, and due to external event */
+    if (error_code != (TIMER_VECTOR << 3 | 3)) {
+        report(false, "Incorrect error code of the GP exception");
+        goto out;
+    }
+
+    /* Original interrupt should be preserved in EXITINTINFO */
+    if (! (vmcb->control.exit_int_info & SVM_EXITINTINFO_VALID)) {
+        report(false, "EXITINTINFO not valid");
+        goto out;
+    }
+
+    if (type != SVM_EXITINTINFO_TYPE_INTR) {
+        report(false, "Incorrect event type in EXITINTINFO");
+        goto out;
+    }
+
+    if (vec != TIMER_VECTOR) {
+        report(false, "Incorrect vector in EXITINTINFO");
+        goto out;
+    }
+
+    set_test_stage(test, 1);
+out:
+    boot_idt[TIMER_VECTOR].type = 14;
+    apic_write(APIC_LVTT, APIC_LVT_TIMER_MASK);
+    return true;
+
+}
+
+static bool interrupt_merging_check(struct svm_test *test)
+{
+    return get_test_stage(test) == 1;
+}
+
+////////////////////////////////////////////////
+
+
 struct svm_test svm_tests[] = {
     { "null", default_supported, default_prepare,
       default_prepare_gif_clear, null_test,
@@ -2492,6 +2644,12 @@ struct svm_test svm_tests[] = {
     { "svm_init_intercept_test", smp_supported, init_intercept_prepare,
       default_prepare_gif_clear, init_intercept_test,
       init_intercept_finished, init_intercept_check, .on_vcpu = 2 },
+    { "exception_merging", default_supported, exception_merging_prepare,
+      default_prepare_gif_clear, exception_merging_test,
+      exception_merging_finished, exception_merging_check },
+    { "interrupt_merging", default_supported, interrupt_merging_prepare,
+      default_prepare_gif_clear, interrupt_merging_test,
+      interrupt_merging_finished, interrupt_merging_check },
     TEST(svm_cr4_osxsave_test),
     TEST(svm_guest_state_test),
     TEST(svm_vmrun_errata_test),
-- 
2.26.2

