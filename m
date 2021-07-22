Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 41DB93D2474
	for <lists+kvm@lfdr.de>; Thu, 22 Jul 2021 15:17:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232041AbhGVMhG (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 22 Jul 2021 08:37:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57354 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231939AbhGVMhF (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 22 Jul 2021 08:37:05 -0400
Received: from mail-ed1-x52b.google.com (mail-ed1-x52b.google.com [IPv6:2a00:1450:4864:20::52b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9AA34C061575
        for <kvm@vger.kernel.org>; Thu, 22 Jul 2021 06:17:39 -0700 (PDT)
Received: by mail-ed1-x52b.google.com with SMTP id h8so6767808eds.4
        for <kvm@vger.kernel.org>; Thu, 22 Jul 2021 06:17:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=Qb0zglffKilSpXJ2TsXX/96dp9S0XxaKyapnjzwBTvY=;
        b=AX6sUO23ll7ariR4qKmtux1qBqdbvNFoujwhsCrj8xS4lF7/3FxZuAA9OYY4GBEm3Q
         cCMCzjMPMQRe9JFVbIQk24gJnZwjhHszrjp8XVhxV22w+14w6NhNWD5UG3Bhy2zUWcxJ
         ZnJM/nsLizriuF8H/Q2M6nEa5noZUiPpfcCiVPFLoCBe33RW0BUfWwgtKYrJpmsPGEdW
         /qzMfezOLrQoyh6oFQUyjm3kVnb8Z5My55/I4g8eh9kD4P1wRPpvVK7DnpidiZVF4kYd
         aApDPyeq/9/x4XJXOlu7cQkaSNjOEd5IkxVSAcmd36KtAu24jD6eFw/lLDOdwcgz812x
         iQzA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=Qb0zglffKilSpXJ2TsXX/96dp9S0XxaKyapnjzwBTvY=;
        b=sOdcQUq4n/Y+tkl9PDv8VLVvgA/rTGujPaHZv14dD9iOZYGDo9wnHf0mqMNBY8bY7r
         3w7WDhLiSPBbzYt2y91IBhiFd+dtognxwF1tH6TkX+tppZywZkJ3wSsSfAQ2tm5lYv3H
         n+CGptDCIk9YXHUUxqa7GLroP79f/umvHWnmdO+lUvKwscdVnYeRy+dyPPUKKPNQ6mEG
         nPl09xI9ltYUqbc4cLlNSAqjzHNVi5+psiDsUJ58cyeoyezIh+7xDS0Ym+Ux+uhT8fpc
         asxSGnuJ4S/pF8k8Y/ZKdxZJiJkH4NBrYyvCB0OCwTg3477jM9j14fQkYhZcUUb4wpTi
         epjA==
X-Gm-Message-State: AOAM533+nuHzBFR8WDVY75wAmFJZfkmpYAjAkmt2vT2NuKbQzUEhWqpo
        Bae74qATrQIIlHrHmyGnAq/6APliE9G+Tw==
X-Google-Smtp-Source: ABdhPJxn0ARLcNaNAddUTknZ5aIms8j4dtJKNkW40y5V5+Hg5RBSGQs103e54L5XCQIIXTsdEfpvCg==
X-Received: by 2002:aa7:d5c8:: with SMTP id d8mr53989957eds.165.1626959858195;
        Thu, 22 Jul 2021 06:17:38 -0700 (PDT)
Received: from localhost.localdomain ([151.38.126.47])
        by smtp.gmail.com with ESMTPSA id b16sm5364003ejq.32.2021.07.22.06.17.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 22 Jul 2021 06:17:37 -0700 (PDT)
From:   Lara Lazier <laramglazier@gmail.com>
To:     kvm@vger.kernel.org
Cc:     Lara Lazier <laramglazier@gmail.com>
Subject: [kvm-unit-tests PATCH] nSVM: Added test for VGIF feature
Date:   Thu, 22 Jul 2021 15:17:18 +0200
Message-Id: <20210722131718.11667-1-laramglazier@gmail.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

When VGIF is enabled STGI executed in guest mode
sets bit 9, while CLGI clears bit 9 in the int_ctl (offset 60h)
of the VMCB.

Signed-off-by: Lara Lazier <laramglazier@gmail.com>
---
 lib/x86/processor.h |  1 +
 x86/svm.c           |  5 ++++
 x86/svm.h           |  7 +++++
 x86/svm_tests.c     | 70 +++++++++++++++++++++++++++++++++++++++++++++
 4 files changed, 83 insertions(+)

diff --git a/lib/x86/processor.h b/lib/x86/processor.h
index 173520f..f4d1757 100644
--- a/lib/x86/processor.h
+++ b/lib/x86/processor.h
@@ -187,6 +187,7 @@ static inline bool is_intel(void)
 #define	X86_FEATURE_AMD_IBPB		(CPUID(0x80000008, 0, EBX, 12))
 #define	X86_FEATURE_NPT			(CPUID(0x8000000A, 0, EDX, 0))
 #define	X86_FEATURE_NRIPS		(CPUID(0x8000000A, 0, EDX, 3))
+#define	X86_FEATURE_VGIF		(CPUID(0x8000000A, 0, EDX, 16))
 
 
 static inline bool this_cpu_has(u64 feature)
diff --git a/x86/svm.c b/x86/svm.c
index 4eaa97e..b0096a9 100644
--- a/x86/svm.c
+++ b/x86/svm.c
@@ -65,6 +65,11 @@ bool default_supported(void)
     return true;
 }
 
+bool vgif_supported(void)
+{
+	return this_cpu_has(X86_FEATURE_VGIF);
+}
+
 void default_prepare(struct svm_test *test)
 {
 	vmcb_ident(vmcb);
diff --git a/x86/svm.h b/x86/svm.h
index 995b0f8..339b9f7 100644
--- a/x86/svm.h
+++ b/x86/svm.h
@@ -115,6 +115,12 @@ struct __attribute__ ((__packed__)) vmcb_control_area {
 #define V_IRQ_SHIFT 8
 #define V_IRQ_MASK (1 << V_IRQ_SHIFT)
 
+#define V_GIF_ENABLED_SHIFT 25
+#define V_GIF_ENABLED_MASK (1 << V_GIF_ENABLED_SHIFT)
+
+#define V_GIF_SHIFT 9
+#define V_GIF_MASK (1 << V_GIF_SHIFT)
+
 #define V_INTR_PRIO_SHIFT 16
 #define V_INTR_PRIO_MASK (0x0f << V_INTR_PRIO_SHIFT)
 
@@ -398,6 +404,7 @@ u64 *npt_get_pdpe(void);
 u64 *npt_get_pml4e(void);
 bool smp_supported(void);
 bool default_supported(void);
+bool vgif_supported(void);
 void default_prepare(struct svm_test *test);
 void default_prepare_gif_clear(struct svm_test *test);
 bool default_finished(struct svm_test *test);
diff --git a/x86/svm_tests.c b/x86/svm_tests.c
index 3777208..7c7b19d 100644
--- a/x86/svm_tests.c
+++ b/x86/svm_tests.c
@@ -2772,6 +2772,73 @@ static void svm_vmload_vmsave(void)
 	vmcb->control.intercept = intercept_saved;
 }
 
+static void prepare_vgif_enabled(struct svm_test *test)
+{
+    default_prepare(test);
+}
+
+static void test_vgif(struct svm_test *test)
+{
+    asm volatile ("vmmcall\n\tstgi\n\tvmmcall\n\tclgi\n\tvmmcall\n\t");
+
+}
+
+static bool vgif_finished(struct svm_test *test)
+{
+    switch (get_test_stage(test))
+    {
+    case 0:
+        if (vmcb->control.exit_code != SVM_EXIT_VMMCALL) {
+            report(false, "VMEXIT not due to vmmcall.");
+            return true;
+        }
+        vmcb->control.int_ctl |= V_GIF_ENABLED_MASK;
+        vmcb->save.rip += 3;
+        inc_test_stage(test);
+        break;
+    case 1:
+        if (vmcb->control.exit_code != SVM_EXIT_VMMCALL) {
+            report(false, "VMEXIT not due to vmmcall.");
+            return true;
+        }
+        if (!(vmcb->control.int_ctl & V_GIF_MASK)) {
+            report(false, "Failed to set VGIF when executing STGI.");
+            vmcb->control.int_ctl &= ~V_GIF_ENABLED_MASK;
+            return true;
+        }
+        report(true, "STGI set VGIF bit.");
+        vmcb->save.rip += 3;
+        inc_test_stage(test);
+        break;
+    case 2:
+        if (vmcb->control.exit_code != SVM_EXIT_VMMCALL) {
+            report(false, "VMEXIT not due to vmmcall.");
+            return true;
+        }
+        if (vmcb->control.int_ctl & V_GIF_MASK) {
+            report(false, "Failed to clear VGIF when executing CLGI.");
+            vmcb->control.int_ctl &= ~V_GIF_ENABLED_MASK;
+            return true;
+        }
+        report(true, "CLGI cleared VGIF bit.");
+        vmcb->save.rip += 3;
+        inc_test_stage(test);
+        vmcb->control.int_ctl &= ~V_GIF_ENABLED_MASK;
+        break;
+    default:
+        return true;
+        break;
+    }
+
+    return get_test_stage(test) == 3;
+}
+
+static bool vgif_check(struct svm_test *test)
+{
+    return get_test_stage(test) == 3;
+}
+
+
 struct svm_test svm_tests[] = {
     { "null", default_supported, default_prepare,
       default_prepare_gif_clear, null_test,
@@ -2882,6 +2949,9 @@ struct svm_test svm_tests[] = {
     { "host_rflags", default_supported, host_rflags_prepare,
       host_rflags_prepare_gif_clear, host_rflags_test,
       host_rflags_finished, host_rflags_check },
+    { "vgif", vgif_supported, prepare_vgif_enabled,
+      default_prepare_gif_clear, test_vgif, vgif_finished,
+      vgif_check },
     TEST(svm_cr4_osxsave_test),
     TEST(svm_guest_state_test),
     TEST(svm_npt_rsvd_bits_test),
-- 
2.25.1

