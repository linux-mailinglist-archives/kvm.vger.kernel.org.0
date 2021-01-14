Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EC8CF2F6108
	for <lists+kvm@lfdr.de>; Thu, 14 Jan 2021 13:24:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728240AbhANMXf (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 14 Jan 2021 07:23:35 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:33608 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726687AbhANMXe (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 14 Jan 2021 07:23:34 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1610626928;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=XR2s4YFGROTlHAcNlvNLo586ZjIBWoE1m72oGkgf7L8=;
        b=KH4MmjEB7PLbHhZLRkPF+xZyh1y8pZoTL19R+uFRhYJ9l33CEBWrtz8w5obSRvWaHih706
        XA8e3prCkK7aD9awPjuJ6N7csv8i57WsD1jze6BVeODjYZNq3OCpVK41hhyUEqnN4UK5m+
        Ndmp5Fc5b/1EKhnGTFdKiSBgJO8ea/8=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-442-ziYmnt3tOQKytvq-K5_f5w-1; Thu, 14 Jan 2021 07:22:06 -0500
X-MC-Unique: ziYmnt3tOQKytvq-K5_f5w-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 89C681005E4A;
        Thu, 14 Jan 2021 12:22:05 +0000 (UTC)
Received: from localhost.localdomain (unknown [10.35.206.51])
        by smtp.corp.redhat.com (Postfix) with ESMTP id C5DDA19C47;
        Thu, 14 Jan 2021 12:22:00 +0000 (UTC)
From:   Maxim Levitsky <mlevitsk@redhat.com>
To:     kvm@vger.kernel.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Wei Huang <wei.huang2@amd.com>, Bandan Das <bsd@redhat.com>,
        Maxim Levitsky <mlevitsk@redhat.com>
Subject: [PATCH] Add a reproducer for the AMD nested virtualization errata
Date:   Thu, 14 Jan 2021 14:21:59 +0200
Message-Id: <20210114122159.1147290-1-mlevitsk@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

While this test doesn't test every case of this errata, it should
reproduce it on all systems where the errata is known to exist.

Signed-off-by: Maxim Levitsky <mlevitsk@redhat.com>
---
 x86/svm_tests.c   | 68 +++++++++++++++++++++++++++++++++++++++++++++++
 x86/unittests.cfg |  2 +-
 2 files changed, 69 insertions(+), 1 deletion(-)

diff --git a/x86/svm_tests.c b/x86/svm_tests.c
index dc86efd..0c75400 100644
--- a/x86/svm_tests.c
+++ b/x86/svm_tests.c
@@ -2315,6 +2315,73 @@ static void svm_guest_state_test(void)
 	test_dr();
 }
 
+
+static bool volatile svm_errata_reproduced = false;
+static unsigned long volatile physical = 0;
+
+
+/*
+ *
+ * Test the following errata:
+ * If the VMRUN/VMSAVE/VMLOAD are attempted by the nested guest,
+ * the CPU would first check the EAX against host reserved memory
+ * regions (so far only SMM_ADDR/SMM_MASK are known to cause it),
+ * and only then signal #VMexit
+ *
+ * Try to reproduce this by trying vmsave on each possible 4K aligned memory
+ * address in the low 4G where the SMM area has to reside.
+ */
+
+static void gp_isr(struct ex_regs *r)
+{
+    svm_errata_reproduced = true;
+    /* skip over the vmsave instruction*/
+    r->rip += 3;
+}
+
+static void svm_vmrun_errata_test(void)
+{
+    unsigned long *last_page = NULL;
+
+    handle_exception(GP_VECTOR, gp_isr);
+
+    while (!svm_errata_reproduced) {
+
+        unsigned long *page = alloc_pages(1);
+
+        if (!page) {
+            report(true, "All guest memory tested, no bug found");;
+            break;
+        }
+
+        physical = virt_to_phys(page);
+
+        asm volatile (
+            "mov %[_physical], %%rax\n\t"
+            "vmsave\n\t"
+
+            : [_physical] "=m" (physical)
+            : /* no inputs*/
+            : "rax" /*clobbers*/
+        );
+
+        if (svm_errata_reproduced) {
+            report(false, "Got #GP exception - svm errata reproduced at 0x%lx",
+                   physical);
+            break;
+        }
+
+        *page = (unsigned long)last_page;
+        last_page = page;
+    }
+
+    while (last_page) {
+        unsigned long *page = last_page;
+        last_page = (unsigned long *)*last_page;
+        free_pages_by_order(page, 1);
+    }
+}
+
 struct svm_test svm_tests[] = {
     { "null", default_supported, default_prepare,
       default_prepare_gif_clear, null_test,
@@ -2427,5 +2494,6 @@ struct svm_test svm_tests[] = {
       init_intercept_finished, init_intercept_check, .on_vcpu = 2 },
     TEST(svm_cr4_osxsave_test),
     TEST(svm_guest_state_test),
+    TEST(svm_vmrun_errata_test),
     { NULL, NULL, NULL, NULL, NULL, NULL, NULL }
 };
diff --git a/x86/unittests.cfg b/x86/unittests.cfg
index b48c98b..f4ea370 100644
--- a/x86/unittests.cfg
+++ b/x86/unittests.cfg
@@ -213,7 +213,7 @@ arch = x86_64
 [svm]
 file = svm.flat
 smp = 2
-extra_params = -cpu host,+svm
+extra_params = -cpu host,+svm -m 4g
 arch = x86_64
 
 [taskswitch]
-- 
2.26.2

