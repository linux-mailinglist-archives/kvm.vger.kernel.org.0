Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 98BF54E47E5
	for <lists+kvm@lfdr.de>; Tue, 22 Mar 2022 21:56:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234894AbiCVU6K (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 22 Mar 2022 16:58:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54310 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235397AbiCVU57 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 22 Mar 2022 16:57:59 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 6AB2CDFCB
        for <kvm@vger.kernel.org>; Tue, 22 Mar 2022 13:56:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1647982590;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=VLfMQnuAfS6OkVhoyOp/zryzpDhHZ9uEK2Up2UGEWTo=;
        b=IAiBwhqnZcMJb6O//+cmmXWpPUELOeik0ltY3KXitjbi8KNXykjHGEzIOHnw5L6rkFwN0z
        J3On4c7HwO0SN53S7ARQcX8utNy843+cZe4p1zX0n12FovvaaZb9lHVGHGRXzi705j1qbZ
        0ekouwHnBjz27sZxwjNwfpFX/Q9q2TY=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-9-1b33s2QmN9Gx7nLKJbMUXg-1; Tue, 22 Mar 2022 16:56:29 -0400
X-MC-Unique: 1b33s2QmN9Gx7nLKJbMUXg-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com [10.11.54.8])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id ECA9D2805513
        for <kvm@vger.kernel.org>; Tue, 22 Mar 2022 20:56:28 +0000 (UTC)
Received: from localhost.localdomain (unknown [10.40.194.231])
        by smtp.corp.redhat.com (Postfix) with ESMTP id CFDFBC27E80;
        Tue, 22 Mar 2022 20:56:27 +0000 (UTC)
From:   Maxim Levitsky <mlevitsk@redhat.com>
To:     kvm@vger.kernel.org
Cc:     Maxim Levitsky <mlevitsk@redhat.com>,
        Cathy Avery <cavery@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Subject: [kvm-unit-tests PATCH 9/9] svm: add test for pause filter and threshold
Date:   Tue, 22 Mar 2022 22:56:13 +0200
Message-Id: <20220322205613.250925-10-mlevitsk@redhat.com>
In-Reply-To: <20220322205613.250925-1-mlevitsk@redhat.com>
References: <20220322205613.250925-1-mlevitsk@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.8
X-Spam-Status: No, score=-2.9 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H4,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Signed-off-by: Maxim Levitsky <mlevitsk@redhat.com>
---
 lib/x86/processor.h |  3 +-
 x86/svm.c           | 11 +++++++
 x86/svm.h           |  5 +++-
 x86/svm_tests.c     | 70 +++++++++++++++++++++++++++++++++++++++++++++
 x86/unittests.cfg   |  7 ++++-
 5 files changed, 93 insertions(+), 3 deletions(-)

diff --git a/lib/x86/processor.h b/lib/x86/processor.h
index b3fe924..9a0dad6 100644
--- a/lib/x86/processor.h
+++ b/lib/x86/processor.h
@@ -190,10 +190,11 @@ static inline bool is_intel(void)
 #define	X86_FEATURE_LBRV		(CPUID(0x8000000A, 0, EDX, 1))
 #define	X86_FEATURE_NRIPS		(CPUID(0x8000000A, 0, EDX, 3))
 #define X86_FEATURE_TSCRATEMSR  (CPUID(0x8000000A, 0, EDX, 4))
+#define X86_FEATURE_PAUSEFILTER     (CPUID(0x8000000A, 0, EDX, 10))
+#define X86_FEATURE_PFTHRESHOLD     (CPUID(0x8000000A, 0, EDX, 12))
 #define	X86_FEATURE_VGIF		(CPUID(0x8000000A, 0, EDX, 16))
 
 
-
 static inline bool this_cpu_has(u64 feature)
 {
 	u32 input_eax = feature >> 32;
diff --git a/x86/svm.c b/x86/svm.c
index 460fc59..f6896f0 100644
--- a/x86/svm.c
+++ b/x86/svm.c
@@ -80,6 +80,17 @@ bool tsc_scale_supported(void)
     return this_cpu_has(X86_FEATURE_TSCRATEMSR);
 }
 
+bool pause_filter_supported(void)
+{
+    return this_cpu_has(X86_FEATURE_PAUSEFILTER);
+}
+
+bool pause_threshold_supported(void)
+{
+    return this_cpu_has(X86_FEATURE_PFTHRESHOLD);
+}
+
+
 void default_prepare(struct svm_test *test)
 {
 	vmcb_ident(vmcb);
diff --git a/x86/svm.h b/x86/svm.h
index d92c4f2..e93822b 100644
--- a/x86/svm.h
+++ b/x86/svm.h
@@ -75,7 +75,8 @@ struct __attribute__ ((__packed__)) vmcb_control_area {
 	u16 intercept_dr_write;
 	u32 intercept_exceptions;
 	u64 intercept;
-	u8 reserved_1[42];
+	u8 reserved_1[40];
+	u16 pause_filter_thresh;
 	u16 pause_filter_count;
 	u64 iopm_base_pa;
 	u64 msrpm_base_pa;
@@ -411,6 +412,8 @@ bool default_supported(void);
 bool vgif_supported(void);
 bool lbrv_supported(void);
 bool tsc_scale_supported(void);
+bool pause_filter_supported(void);
+bool pause_threshold_supported(void);
 void default_prepare(struct svm_test *test);
 void default_prepare_gif_clear(struct svm_test *test);
 bool default_finished(struct svm_test *test);
diff --git a/x86/svm_tests.c b/x86/svm_tests.c
index e7bd788..6a9b03b 100644
--- a/x86/svm_tests.c
+++ b/x86/svm_tests.c
@@ -3030,6 +3030,75 @@ static bool vgif_check(struct svm_test *test)
     return get_test_stage(test) == 3;
 }
 
+
+static int pause_test_counter;
+static int wait_counter;
+
+static void pause_filter_test_guest_main(struct svm_test *test)
+{
+    int i;
+    for (i = 0 ; i < pause_test_counter ; i++)
+        pause();
+
+    if (!wait_counter)
+        return;
+
+    for (i = 0; i < wait_counter; i++)
+        ;
+
+    for (i = 0 ; i < pause_test_counter ; i++)
+        pause();
+
+}
+
+static void pause_filter_run_test(int pause_iterations, int filter_value, int wait_iterations, int threshold)
+{
+    test_set_guest(pause_filter_test_guest_main);
+
+    pause_test_counter = pause_iterations;
+    wait_counter = wait_iterations;
+
+    vmcb->control.pause_filter_count = filter_value;
+    vmcb->control.pause_filter_thresh = threshold;
+    svm_vmrun();
+
+    if (filter_value <= pause_iterations || wait_iterations < threshold)
+        report(vmcb->control.exit_code == SVM_EXIT_PAUSE, "expected PAUSE vmexit");
+    else
+        report(vmcb->control.exit_code == SVM_EXIT_VMMCALL, "no expected PAUSE vmexit");
+}
+
+static void pause_filter_test(void)
+{
+    if (!pause_filter_supported()) {
+            report_skip("PAUSE filter not supported in the guest");
+            return;
+    }
+
+    vmcb->control.intercept |= (1 << INTERCEPT_PAUSE);
+
+    // filter count more that pause count - no VMexit
+    pause_filter_run_test(10, 9, 0, 0);
+
+    // filter count smaller pause count - no VMexit
+    pause_filter_run_test(20, 21, 0, 0);
+
+
+    if (pause_threshold_supported()) {
+        // filter count smaller pause count - no VMexit +  large enough threshold
+        // so that filter counter resets
+        pause_filter_run_test(20, 21, 1000, 10);
+
+        // filter count smaller pause count - no VMexit +  small threshold
+        // so that filter doesn't reset
+        pause_filter_run_test(20, 21, 10, 1000);
+    } else {
+        report_skip("PAUSE threshold not supported in the guest");
+        return;
+    }
+}
+
+
 static int of_test_counter;
 
 static void guest_test_of_handler(struct ex_regs *r)
@@ -3698,5 +3767,6 @@ struct svm_test svm_tests[] = {
     TEST(svm_intr_intercept_mix_nmi),
     TEST(svm_intr_intercept_mix_smi),
     TEST(svm_tsc_scale_test),
+    TEST(pause_filter_test),
     { NULL, NULL, NULL, NULL, NULL, NULL, NULL }
 };
diff --git a/x86/unittests.cfg b/x86/unittests.cfg
index 89ff949..c277088 100644
--- a/x86/unittests.cfg
+++ b/x86/unittests.cfg
@@ -238,7 +238,12 @@ arch = x86_64
 [svm]
 file = svm.flat
 smp = 2
-extra_params = -cpu max,+svm -m 4g
+extra_params = -cpu max,+svm -m 4g -append "-pause_filter_test"
+arch = x86_64
+
+[svm_pause_filter]
+file = svm.flat
+extra_params = -cpu max,+svm -overcommit cpu-pm=on -m 4g -append pause_filter_test
 arch = x86_64
 
 [taskswitch]
-- 
2.26.3

