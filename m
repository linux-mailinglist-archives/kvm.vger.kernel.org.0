Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 850051CC1FF
	for <lists+kvm@lfdr.de>; Sat,  9 May 2020 16:06:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727106AbgEIOGV (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 9 May 2020 10:06:21 -0400
Received: from us-smtp-2.mimecast.com ([205.139.110.61]:35211 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727092AbgEIOGV (ORCPT
        <rfc822;kvm@vger.kernel.org>); Sat, 9 May 2020 10:06:21 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1589033180;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc; bh=4i8mGUWttw4oOkp1Jk8ARsgUGl5YbWkieitfPAJSHiA=;
        b=f9Dwad1P+RYqIw5nX752alfqLv973EZ0/LtImKphsLelKKG2opSy3TpP+J3UHLFr5nrc7t
        lkWMAmBpMt2dcAC3c4sBKlXezYFZ9IdzOoxR6UuJxpjbG1POS5DyvmUzH0Vu1NFM8OZqJ7
        bUTlcg/50gWfKtr1SRTnlyeWm97db9k=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-468-11Dnuj8vNXqWR5uP-mxXTQ-1; Sat, 09 May 2020 10:06:16 -0400
X-MC-Unique: 11Dnuj8vNXqWR5uP-mxXTQ-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id EA7751895A3F
        for <kvm@vger.kernel.org>; Sat,  9 May 2020 14:06:15 +0000 (UTC)
Received: from virtlab511.virt.lab.eng.bos.redhat.com (virtlab511.virt.lab.eng.bos.redhat.com [10.19.152.198])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 95FB219C58
        for <kvm@vger.kernel.org>; Sat,  9 May 2020 14:06:15 +0000 (UTC)
From:   Paolo Bonzini <pbonzini@redhat.com>
To:     kvm@vger.kernel.org
Subject: [PATCH kvm-unit-tests] svm_tests: add RSM intercept test
Date:   Sat,  9 May 2020 10:06:14 -0400
Message-Id: <20200509140614.531850-1-pbonzini@redhat.com>
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This test is currently broken, but it passes under QEMU.

Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 x86/svm_tests.c | 49 +++++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 49 insertions(+)

diff --git a/x86/svm_tests.c b/x86/svm_tests.c
index cb3ace1..c1abd55 100644
--- a/x86/svm_tests.c
+++ b/x86/svm_tests.c
@@ -66,6 +66,52 @@ static bool check_vmrun(struct svm_test *test)
     return vmcb->control.exit_code == SVM_EXIT_VMRUN;
 }
 
+static void prepare_rsm_intercept(struct svm_test *test)
+{
+    default_prepare(test);
+    vmcb->control.intercept |= 1 << INTERCEPT_RSM;
+    vmcb->control.intercept_exceptions |= (1ULL << UD_VECTOR);
+}
+
+static void test_rsm_intercept(struct svm_test *test)
+{
+    asm volatile ("rsm" : : : "memory");
+}
+
+static bool check_rsm_intercept(struct svm_test *test)
+{
+    return get_test_stage(test) == 2;
+}
+
+static bool finished_rsm_intercept(struct svm_test *test)
+{
+    switch (get_test_stage(test)) {
+    case 0:
+        if (vmcb->control.exit_code != SVM_EXIT_RSM) {
+            report(false, "VMEXIT not due to rsm. Exit reason 0x%x",
+                   vmcb->control.exit_code);
+            return true;
+        }
+        vmcb->control.intercept &= ~(1 << INTERCEPT_RSM);
+        inc_test_stage(test);
+        break;
+
+    case 1:
+        if (vmcb->control.exit_code != SVM_EXIT_EXCP_BASE + UD_VECTOR) {
+            report(false, "VMEXIT not due to #UD. Exit reason 0x%x",
+                   vmcb->control.exit_code);
+            return true;
+        }
+        vmcb->save.rip += 2;
+        inc_test_stage(test);
+        break;
+
+    default:
+        return true;
+    }
+    return get_test_stage(test) == 2;
+}
+
 static void prepare_cr3_intercept(struct svm_test *test)
 {
     default_prepare(test);
@@ -1819,6 +1865,9 @@ struct svm_test svm_tests[] = {
     { "vmrun intercept check", default_supported, prepare_no_vmrun_int,
       default_prepare_gif_clear, null_test, default_finished,
       check_no_vmrun_int },
+    { "rsm", default_supported,
+      prepare_rsm_intercept, default_prepare_gif_clear,
+      test_rsm_intercept, finished_rsm_intercept, check_rsm_intercept },
     { "cr3 read intercept", default_supported,
       prepare_cr3_intercept, default_prepare_gif_clear,
       test_cr3_intercept, default_finished, check_cr3_intercept },
-- 
2.18.2

