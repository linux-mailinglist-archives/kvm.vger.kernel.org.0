Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 520B54E47E2
	for <lists+kvm@lfdr.de>; Tue, 22 Mar 2022 21:56:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234552AbiCVU6E (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 22 Mar 2022 16:58:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53988 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235371AbiCVU57 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 22 Mar 2022 16:57:59 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 32ECADF3C
        for <kvm@vger.kernel.org>; Tue, 22 Mar 2022 13:56:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1647982590;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Q9HneRc10pAdn+BEXX8opU9Z5KQsphxSp3uraYqDUMw=;
        b=U3sc2Nh/3rWyJw8Uc1By3HhD7AdjLw6uDdyXhY6ouhmumvjnHr0oWxASv50dj+hHSveT0b
        /bI0CIfCNCyuPyR5iN6bcuoTsicSIOm2DS4+ZVUT/w0G8zTOgAu+a3tnoRRJtf8LC9TUxW
        FugPjWtDxptfRMVnrHdZnej40k3py6c=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-665-hZidn-09MvKLGFN2E9MbwQ-1; Tue, 22 Mar 2022 16:56:27 -0400
X-MC-Unique: hZidn-09MvKLGFN2E9MbwQ-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com [10.11.54.8])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 782DD280550F
        for <kvm@vger.kernel.org>; Tue, 22 Mar 2022 20:56:27 +0000 (UTC)
Received: from localhost.localdomain (unknown [10.40.194.231])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 5AED0C26E9A;
        Tue, 22 Mar 2022 20:56:26 +0000 (UTC)
From:   Maxim Levitsky <mlevitsk@redhat.com>
To:     kvm@vger.kernel.org
Cc:     Maxim Levitsky <mlevitsk@redhat.com>,
        Cathy Avery <cavery@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Subject: [kvm-unit-tests PATCH 8/9] svm: add test for nested tsc scaling
Date:   Tue, 22 Mar 2022 22:56:12 +0200
Message-Id: <20220322205613.250925-9-mlevitsk@redhat.com>
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
 lib/x86/msr.h       |  1 +
 lib/x86/processor.h |  2 ++
 x86/svm.c           |  5 ++++
 x86/svm.h           |  3 +++
 x86/svm_tests.c     | 65 +++++++++++++++++++++++++++++++++++++++++++++
 5 files changed, 76 insertions(+)

diff --git a/lib/x86/msr.h b/lib/x86/msr.h
index 5001b16..fa1c0c8 100644
--- a/lib/x86/msr.h
+++ b/lib/x86/msr.h
@@ -431,6 +431,7 @@
 
 /* AMD-V MSRs */
 
+#define MSR_AMD64_TSC_RATIO             0xc0000104
 #define MSR_VM_CR                       0xc0010114
 #define MSR_VM_IGNNE                    0xc0010115
 #define MSR_VM_HSAVE_PA                 0xc0010117
diff --git a/lib/x86/processor.h b/lib/x86/processor.h
index b01c3d0..b3fe924 100644
--- a/lib/x86/processor.h
+++ b/lib/x86/processor.h
@@ -189,9 +189,11 @@ static inline bool is_intel(void)
 #define	X86_FEATURE_NPT			(CPUID(0x8000000A, 0, EDX, 0))
 #define	X86_FEATURE_LBRV		(CPUID(0x8000000A, 0, EDX, 1))
 #define	X86_FEATURE_NRIPS		(CPUID(0x8000000A, 0, EDX, 3))
+#define X86_FEATURE_TSCRATEMSR  (CPUID(0x8000000A, 0, EDX, 4))
 #define	X86_FEATURE_VGIF		(CPUID(0x8000000A, 0, EDX, 16))
 
 
+
 static inline bool this_cpu_has(u64 feature)
 {
 	u32 input_eax = feature >> 32;
diff --git a/x86/svm.c b/x86/svm.c
index bb58d7c..460fc59 100644
--- a/x86/svm.c
+++ b/x86/svm.c
@@ -75,6 +75,11 @@ bool lbrv_supported(void)
     return this_cpu_has(X86_FEATURE_LBRV);
 }
 
+bool tsc_scale_supported(void)
+{
+    return this_cpu_has(X86_FEATURE_TSCRATEMSR);
+}
+
 void default_prepare(struct svm_test *test)
 {
 	vmcb_ident(vmcb);
diff --git a/x86/svm.h b/x86/svm.h
index df1b1ac..d92c4f2 100644
--- a/x86/svm.h
+++ b/x86/svm.h
@@ -147,6 +147,8 @@ struct __attribute__ ((__packed__)) vmcb_control_area {
 #define SVM_VM_CR_SVM_LOCK_MASK 0x0008ULL
 #define SVM_VM_CR_SVM_DIS_MASK  0x0010ULL
 
+#define TSC_RATIO_DEFAULT   0x0100000000ULL
+
 struct __attribute__ ((__packed__)) vmcb_seg {
 	u16 selector;
 	u16 attrib;
@@ -408,6 +410,7 @@ bool smp_supported(void);
 bool default_supported(void);
 bool vgif_supported(void);
 bool lbrv_supported(void);
+bool tsc_scale_supported(void);
 void default_prepare(struct svm_test *test);
 void default_prepare_gif_clear(struct svm_test *test);
 bool default_finished(struct svm_test *test);
diff --git a/x86/svm_tests.c b/x86/svm_tests.c
index ef8b5ee..e7bd788 100644
--- a/x86/svm_tests.c
+++ b/x86/svm_tests.c
@@ -918,6 +918,70 @@ static bool tsc_adjust_check(struct svm_test *test)
     return ok && adjust <= -2 * TSC_ADJUST_VALUE;
 }
 
+
+static u64 guest_tsc_delay_value;
+/* number of bits to shift tsc right for stable result */
+#define TSC_SHIFT 24
+#define TSC_SCALE_ITERATIONS 10
+
+static void svm_tsc_scale_guest(struct svm_test *test)
+{
+    u64 start_tsc = rdtsc();
+
+    while (rdtsc() - start_tsc < guest_tsc_delay_value)
+        cpu_relax();
+}
+
+static void svm_tsc_scale_run_testcase(u64 duration,
+        double tsc_scale, u64 tsc_offset)
+{
+    u64 start_tsc, actual_duration;
+
+    guest_tsc_delay_value = (duration << TSC_SHIFT) * tsc_scale;
+
+    test_set_guest(svm_tsc_scale_guest);
+    vmcb->control.tsc_offset = tsc_offset;
+    wrmsr(MSR_AMD64_TSC_RATIO, (u64)(tsc_scale * (1ULL << 32)));
+
+    start_tsc = rdtsc();
+
+    if (svm_vmrun() != SVM_EXIT_VMMCALL)
+        report_fail("unexpected vm exit code 0x%x", vmcb->control.exit_code);
+
+    actual_duration = (rdtsc() - start_tsc) >> TSC_SHIFT;
+
+    report(duration == actual_duration, "tsc delay (expected: %lu, actual: %lu)",
+            duration, actual_duration);
+}
+
+static void svm_tsc_scale_test(void)
+{
+    int i;
+
+    if (!tsc_scale_supported()) {
+        report_skip("TSC scale not supported in the guest");
+        return;
+    }
+
+    report(rdmsr(MSR_AMD64_TSC_RATIO) == TSC_RATIO_DEFAULT,
+           "initial TSC scale ratio");
+
+    for (i = 0 ; i < TSC_SCALE_ITERATIONS; i++) {
+
+        double tsc_scale = (double)(rdrand() % 100 + 1) / 10;
+        int duration = rdrand() % 50 + 1;
+        u64 tsc_offset = rdrand();
+
+        report_info("duration=%d, tsc_scale=%d, tsc_offset=%ld",
+                    duration, (int)(tsc_scale * 100), tsc_offset);
+
+        svm_tsc_scale_run_testcase(duration, tsc_scale, tsc_offset);
+    }
+
+    svm_tsc_scale_run_testcase(50, 255, rdrand());
+    svm_tsc_scale_run_testcase(50, 0.0001, rdrand());
+}
+
 static void latency_prepare(struct svm_test *test)
 {
     default_prepare(test);
@@ -3633,5 +3697,6 @@ struct svm_test svm_tests[] = {
     TEST(svm_intr_intercept_mix_gif2),
     TEST(svm_intr_intercept_mix_nmi),
     TEST(svm_intr_intercept_mix_smi),
+    TEST(svm_tsc_scale_test),
     { NULL, NULL, NULL, NULL, NULL, NULL, NULL }
 };
-- 
2.26.3

