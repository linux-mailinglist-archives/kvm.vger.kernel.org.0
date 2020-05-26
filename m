Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E34511A3204
	for <lists+kvm@lfdr.de>; Thu,  9 Apr 2020 11:43:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726702AbgDIJnL (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 9 Apr 2020 05:43:11 -0400
Received: from us-smtp-1.mimecast.com ([205.139.110.61]:20578 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726641AbgDIJnK (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 9 Apr 2020 05:43:10 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1586425390;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc; bh=6HrPdKOboS5D7jfHW3vNq4Ok66KCGk2a1g+aL7G4Ud4=;
        b=ZE+i++rrfOaru4g3uNjwX23qY1rdgyaR6QMQzU+j5yDx33yW4tE4qxtDM/0/F+hULJmVeq
        pH38+cLM8nxpSK+dQJm0ufXhVa/CYRszDqvkhYm3W5IGGq+xrNGFmXojtjMn3DX+iAp0+f
        44LHKMIpmqP3Jw6RZAQa5TfnoneV8vE=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-256-T0cC7uQ5O9GPPxJA6lkQjQ-1; Thu, 09 Apr 2020 05:43:05 -0400
X-MC-Unique: T0cC7uQ5O9GPPxJA6lkQjQ-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id BA8F813F9
        for <kvm@vger.kernel.org>; Thu,  9 Apr 2020 09:43:04 +0000 (UTC)
Received: from virtlab511.virt.lab.eng.bos.redhat.com (virtlab511.virt.lab.eng.bos.redhat.com [10.19.152.198])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 66E4B11481A
        for <kvm@vger.kernel.org>; Thu,  9 Apr 2020 09:43:04 +0000 (UTC)
From:   Paolo Bonzini <pbonzini@redhat.com>
To:     kvm@vger.kernel.org
Subject: [PATCH kvm-unit-tests] svm: add a test for exception injection
Date:   Thu,  9 Apr 2020 05:43:03 -0400
Message-Id: <20200409094303.949992-1-pbonzini@redhat.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Cover VMRUN's testing whether EVENTINJ.TYPE = 3 (exception) has been specified with
a vector that does not correspond to an exception.

Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 x86/svm.h       |  7 +++++
 x86/svm_tests.c | 70 +++++++++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 77 insertions(+)

diff --git a/x86/svm.h b/x86/svm.h
index 645deb7..bb5c552 100644
--- a/x86/svm.h
+++ b/x86/svm.h
@@ -324,6 +324,13 @@ struct __attribute__ ((__packed__)) vmcb {
 
 #define SVM_CR0_SELECTIVE_MASK (X86_CR0_TS | X86_CR0_MP)
 
+#define SVM_EVENT_INJ_HWINT	(0 << 8)
+#define SVM_EVENT_INJ_NMI	(2 << 8)
+#define SVM_EVENT_INJ_EXC	(3 << 8)
+#define SVM_EVENT_INJ_SWINT	(4 << 8)
+#define SVM_EVENT_INJ_ERRCODE	(1 << 11)
+#define SVM_EVENT_INJ_VALID	(1 << 31)
+
 #define MSR_BITMAP_SIZE 8192
 
 struct svm_test {
diff --git a/x86/svm_tests.c b/x86/svm_tests.c
index 16b9dfd..6292e68 100644
--- a/x86/svm_tests.c
+++ b/x86/svm_tests.c
@@ -1340,6 +1340,73 @@ static bool interrupt_check(struct svm_test *test)
     return get_test_stage(test) == 5;
 }
 
+static volatile int count_exc = 0;
+
+static void my_isr(struct ex_regs *r)
+{
+        count_exc++;
+}
+
+static void exc_inject_prepare(struct svm_test *test)
+{
+	handle_exception(DE_VECTOR, my_isr);
+	handle_exception(NMI_VECTOR, my_isr);
+}
+
+
+static void exc_inject_test(struct svm_test *test)
+{
+    asm volatile ("vmmcall\n\tvmmcall\n\t");
+}
+
+static bool exc_inject_finished(struct svm_test *test)
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
+        vmcb->control.event_inj = NMI_VECTOR | SVM_EVENT_INJ_EXC | SVM_EVENT_INJ_VALID;
+        break;
+
+    case 1:
+        if (vmcb->control.exit_code != SVM_EXIT_ERR) {
+            report(false, "VMEXIT not due to error. Exit reason 0x%x",
+                   vmcb->control.exit_code);
+            return true;
+        }
+        report(count_exc == 0, "exception with vector 2 not injected");
+        vmcb->control.event_inj = DE_VECTOR | SVM_EVENT_INJ_EXC | SVM_EVENT_INJ_VALID;
+	break;
+
+    case 2:
+        if (vmcb->control.exit_code != SVM_EXIT_VMMCALL) {
+            report(false, "VMEXIT not due to vmmcall. Exit reason 0x%x",
+                   vmcb->control.exit_code);
+            return true;
+        }
+        report(count_exc == 1, "divide overflow exception injected");
+	report(!(vmcb->control.event_inj & SVM_EVENT_INJ_VALID), "eventinj.VALID cleared");
+        break;
+
+    default:
+        return true;
+    }
+
+    inc_test_stage(test);
+
+    return get_test_stage(test) == 3;
+}
+
+static bool exc_inject_check(struct svm_test *test)
+{
+    return count_exc == 1 && get_test_stage(test) == 3;
+}
+
 #define TEST(name) { #name, .v2 = name }
 
 /*
@@ -1446,6 +1513,9 @@ struct svm_test svm_tests[] = {
     { "interrupt", default_supported, interrupt_prepare,
       default_prepare_gif_clear, interrupt_test,
       interrupt_finished, interrupt_check },
+    { "exc_inject", default_supported, exc_inject_prepare,
+      default_prepare_gif_clear, exc_inject_test,
+      exc_inject_finished, exc_inject_check },
     TEST(svm_guest_state_test),
     { NULL, NULL, NULL, NULL, NULL, NULL, NULL }
 };
-- 
2.18.2

