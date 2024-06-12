Return-Path: <kvm+bounces-19454-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 23FC590558A
	for <lists+kvm@lfdr.de>; Wed, 12 Jun 2024 16:46:24 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id A23A01F23B49
	for <lists+kvm@lfdr.de>; Wed, 12 Jun 2024 14:46:23 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C4A7817F4F5;
	Wed, 12 Jun 2024 14:45:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="HzbNcj80"
X-Original-To: kvm@vger.kernel.org
Received: from mail-ej1-f50.google.com (mail-ej1-f50.google.com [209.85.218.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2C9F717F4E0
	for <kvm@vger.kernel.org>; Wed, 12 Jun 2024 14:45:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718203552; cv=none; b=ZOECbF094Jc80nD8k7xcWbEh/4jrP/OBZhRdweIUu1dR6OWzNLrdCkErPPpJCzbytaTl40mbtiP1Vzja7EGe+4tESucSt2eAtVi2G5/de7LfYoTqkZkbHLumG3Oldmeaj8FMchuiwTpsYNIhxyZJ8l+YUqn0/ALPsnemQDkoEHs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718203552; c=relaxed/simple;
	bh=xujwh6lH2Bs1x9EAbKCi6M+2vDidaWbKqXLLxpfVlaU=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=t926PByBkfQ2Fbw2Kxln4DmWO205N3S/1y9tszEucXwn8cUYSV9fYRDnDJhyIEbbdTiR/iessfFU5jX70L8+IsI64s5quzmWmodZ0+BJAhAuUEeKgsrQ9fg54gvepvqsD79kDZhI5T09MkAxOQSsvfSY7bmiQReu1/OI3jFyFNk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=HzbNcj80; arc=none smtp.client-ip=209.85.218.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ej1-f50.google.com with SMTP id a640c23a62f3a-a63359aaacaso329418466b.1
        for <kvm@vger.kernel.org>; Wed, 12 Jun 2024 07:45:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1718203548; x=1718808348; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=AfDoPk7aBDLgtejyaw77/ZfknsZulE2TGCGFLzn+aIU=;
        b=HzbNcj80S+LDtCGjkEWcU1tJNgOAbZx9Gioeu1z6Mo7hD6pDkjgK1z0SugLNK3q6IJ
         xt4uAD2NWpO3TLwEOdd9USuWzToNm5lvdeN+J1lWqRXOtUQPE6BXMjmwgVVKEm3uHCEy
         ZxvT0/4KD8bdlnHEKZj4n/tJiUahgQvoh933aE1kfBzOgNIWS5dilhzqQ7ewtXv511ZJ
         7Udc85327j5/GQNLmq+mOB09NHzEOT7hJ4zAQfWMocxVR2mlx+/lvE552dYJZu7CG8Ij
         Q9qfLs0c0KOTcXb0zRBQ/HvUvVE4Qk4uefzaopoqo3RhtoNOe+2MwY68sDz3pRga0+XC
         zj0g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1718203548; x=1718808348;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=AfDoPk7aBDLgtejyaw77/ZfknsZulE2TGCGFLzn+aIU=;
        b=b0A85atAhKYS9umX2D3qNThlhEp2EFV31gppT+/OTc1Rxvn8A/DOEbA9B5lmrENvhw
         dG2H0w2fKlqT2Vy7QNKNmNYLC0daQ9KsD3H8XLnKLNgYX6V60CwKs/7rs5ak72PPG/eJ
         uU61/BSW/spOTGqdrezOptB1o2HkJkNG7/qz4kEcWwC8udQ+icDqP061iX9UIKS/xi1F
         WaZm5clHkvDWvvz370VXGRs54gcvRS+2xu5r9sd+j8V/ws2jD4eHd9kJi489E3MqlfH9
         VpiZ/RLtccc9cWESoT8Y3zmazZsj+EMS7K/FR2T2DViDycUTWydXScH9D1d3XoKQS79/
         BXzw==
X-Gm-Message-State: AOJu0Yyr4hp6/rzVepSfxMLWrgsEgKVKI2qIisMYUVzJ41056mMST03N
	nEHo6Btdz5y1Nfo+HCaPNR8BBMhTulaUNwEa/XIEgUqcs4wwj3TDkl8QeRPt
X-Google-Smtp-Source: AGHT+IFzK5eY/Usal7HeP2vxeXVqhelcKfp+29RioGHFusgC1cgqXiBD1USzDI/GQDWrPFwnSgn9Pg==
X-Received: by 2002:a17:906:f6d4:b0:a6f:467d:19ec with SMTP id a640c23a62f3a-a6f47cbc19cmr132611366b.18.1718203547580;
        Wed, 12 Jun 2024 07:45:47 -0700 (PDT)
Received: from vasant-suse.suse.cz ([2001:9e8:ab7c:f800:473b:7cbe:2ac7:effa])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-a6f18bbf3cbsm456440366b.1.2024.06.12.07.45.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 12 Jun 2024 07:45:47 -0700 (PDT)
From: vsntk18@gmail.com
To: kvm@vger.kernel.org
Cc: vsntk18@gmail.com,
	andrew.jones@linux.dev,
	jroedel@suse.de,
	papaluri@amd.com,
	pbonzini@redhat.com,
	seanjc@google.com,
	vkarasulli@suse.de
Subject: [kvm-unit-tests PATCH v8 02/12] x86: Move architectural code to lib/x86
Date: Wed, 12 Jun 2024 16:45:29 +0200
Message-Id: <20240612144539.16147-3-vsntk18@gmail.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20240612144539.16147-1-vsntk18@gmail.com>
References: <20240612144539.16147-1-vsntk18@gmail.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Vasant Karasulli <vkarasulli@suse.de>

This enables sharing common definitions across testcases and lib/.

Signed-off-by: Vasant Karasulli <vkarasulli@suse.de>
---
 {x86 => lib/x86}/svm.h | 105 --------------------------------------
 x86/svm.c              |   2 +-
 x86/svm_npt.c          |   2 +-
 x86/svm_tests.c        |   2 +-
 x86/svm_tests.h        | 113 +++++++++++++++++++++++++++++++++++++++++
 5 files changed, 116 insertions(+), 108 deletions(-)
 rename {x86 => lib/x86}/svm.h (76%)
 create mode 100644 x86/svm_tests.h

diff --git a/x86/svm.h b/lib/x86/svm.h
similarity index 76%
rename from x86/svm.h
rename to lib/x86/svm.h
index 308daa55..0fc64be7 100644
--- a/x86/svm.h
+++ b/lib/x86/svm.h
@@ -372,22 +372,6 @@ struct __attribute__ ((__packed__)) vmcb {

 #define LBR_CTL_ENABLE_MASK BIT_ULL(0)

-struct svm_test {
-	const char *name;
-	bool (*supported)(void);
-	void (*prepare)(struct svm_test *test);
-	void (*prepare_gif_clear)(struct svm_test *test);
-	void (*guest_func)(struct svm_test *test);
-	bool (*finished)(struct svm_test *test);
-	bool (*succeeded)(struct svm_test *test);
-	int exits;
-	ulong scratch;
-	/* Alternative test interface. */
-	void (*v2)(void);
-	int on_vcpu;
-	bool on_vcpu_done;
-};
-
 struct regs {
 	u64 rax;
 	u64 rbx;
@@ -408,93 +392,4 @@ struct regs {
 	u64 rflags;
 };

-typedef void (*test_guest_func)(struct svm_test *);
-
-int run_svm_tests(int ac, char **av, struct svm_test *svm_tests);
-u64 *npt_get_pte(u64 address);
-u64 *npt_get_pde(u64 address);
-u64 *npt_get_pdpe(u64 address);
-u64 *npt_get_pml4e(void);
-bool smp_supported(void);
-bool default_supported(void);
-bool vgif_supported(void);
-bool lbrv_supported(void);
-bool tsc_scale_supported(void);
-bool pause_filter_supported(void);
-bool pause_threshold_supported(void);
-void default_prepare(struct svm_test *test);
-void default_prepare_gif_clear(struct svm_test *test);
-bool default_finished(struct svm_test *test);
-bool npt_supported(void);
-bool vnmi_supported(void);
-int get_test_stage(struct svm_test *test);
-void set_test_stage(struct svm_test *test, int s);
-void inc_test_stage(struct svm_test *test);
-void vmcb_ident(struct vmcb *vmcb);
-struct regs get_regs(void);
-void vmmcall(void);
-void svm_setup_vmrun(u64 rip);
-int __svm_vmrun(u64 rip);
-int svm_vmrun(void);
-void test_set_guest(test_guest_func func);
-
-extern struct vmcb *vmcb;
-
-static inline void stgi(void)
-{
-    asm volatile ("stgi");
-}
-
-static inline void clgi(void)
-{
-    asm volatile ("clgi");
-}
-
-
-
-#define SAVE_GPR_C                              \
-        "xchg %%rbx, regs+0x8\n\t"              \
-        "xchg %%rcx, regs+0x10\n\t"             \
-        "xchg %%rdx, regs+0x18\n\t"             \
-        "xchg %%rbp, regs+0x28\n\t"             \
-        "xchg %%rsi, regs+0x30\n\t"             \
-        "xchg %%rdi, regs+0x38\n\t"             \
-        "xchg %%r8, regs+0x40\n\t"              \
-        "xchg %%r9, regs+0x48\n\t"              \
-        "xchg %%r10, regs+0x50\n\t"             \
-        "xchg %%r11, regs+0x58\n\t"             \
-        "xchg %%r12, regs+0x60\n\t"             \
-        "xchg %%r13, regs+0x68\n\t"             \
-        "xchg %%r14, regs+0x70\n\t"             \
-        "xchg %%r15, regs+0x78\n\t"
-
-#define LOAD_GPR_C      SAVE_GPR_C
-
-#define ASM_PRE_VMRUN_CMD                       \
-                "vmload %%rax\n\t"              \
-                "mov regs+0x80, %%r15\n\t"      \
-                "mov %%r15, 0x170(%%rax)\n\t"   \
-                "mov regs, %%r15\n\t"           \
-                "mov %%r15, 0x1f8(%%rax)\n\t"   \
-                LOAD_GPR_C                      \
-
-#define ASM_POST_VMRUN_CMD                      \
-                SAVE_GPR_C                      \
-                "mov 0x170(%%rax), %%r15\n\t"   \
-                "mov %%r15, regs+0x80\n\t"      \
-                "mov 0x1f8(%%rax), %%r15\n\t"   \
-                "mov %%r15, regs\n\t"           \
-                "vmsave %%rax\n\t"              \
-
-
-
-#define SVM_BARE_VMRUN \
-	asm volatile ( \
-		ASM_PRE_VMRUN_CMD \
-                "vmrun %%rax\n\t"               \
-		ASM_POST_VMRUN_CMD \
-		: \
-		: "a" (virt_to_phys(vmcb)) \
-		: "memory", "r15") \
-
 #endif
diff --git a/x86/svm.c b/x86/svm.c
index e715e270..251e9ed6 100644
--- a/x86/svm.c
+++ b/x86/svm.c
@@ -2,7 +2,7 @@
  * Framework for testing nested virtualization
  */

-#include "svm.h"
+#include "svm_tests.h"
 #include "libcflat.h"
 #include "processor.h"
 #include "desc.h"
diff --git a/x86/svm_npt.c b/x86/svm_npt.c
index b791f1ac..c248a66f 100644
--- a/x86/svm_npt.c
+++ b/x86/svm_npt.c
@@ -1,4 +1,4 @@
-#include "svm.h"
+#include "svm_tests.h"
 #include "vm.h"
 #include "alloc_page.h"
 #include "vmalloc.h"
diff --git a/x86/svm_tests.c b/x86/svm_tests.c
index c81b7465..0f206632 100644
--- a/x86/svm_tests.c
+++ b/x86/svm_tests.c
@@ -1,4 +1,4 @@
-#include "svm.h"
+#include "svm_tests.h"
 #include "libcflat.h"
 #include "processor.h"
 #include "desc.h"
diff --git a/x86/svm_tests.h b/x86/svm_tests.h
new file mode 100644
index 00000000..fcf3bcb5
--- /dev/null
+++ b/x86/svm_tests.h
@@ -0,0 +1,107 @@
+#ifndef X86_SVM_TESTS_H
+#define X86_SVM_TESTS_H
+
+#include "x86/svm.h"
+
+struct svm_test {
+	const char *name;
+	bool (*supported)(void);
+	void (*prepare)(struct svm_test *test);
+	void (*prepare_gif_clear)(struct svm_test *test);
+	void (*guest_func)(struct svm_test *test);
+	bool (*finished)(struct svm_test *test);
+	bool (*succeeded)(struct svm_test *test);
+	int exits;
+	ulong scratch;
+	/* Alternative test interface. */
+	void (*v2)(void);
+	int on_vcpu;
+	bool on_vcpu_done;
+};
+
+typedef void (*test_guest_func)(struct svm_test *);
+
+int run_svm_tests(int ac, char **av, struct svm_test *svm_tests);
+u64 *npt_get_pte(u64 address);
+u64 *npt_get_pde(u64 address);
+u64 *npt_get_pdpe(u64 address);
+u64 *npt_get_pml4e(void);
+bool smp_supported(void);
+bool default_supported(void);
+bool vgif_supported(void);
+bool lbrv_supported(void);
+bool tsc_scale_supported(void);
+bool pause_filter_supported(void);
+bool pause_threshold_supported(void);
+void default_prepare(struct svm_test *test);
+void default_prepare_gif_clear(struct svm_test *test);
+bool default_finished(struct svm_test *test);
+bool npt_supported(void);
+bool vnmi_supported(void);
+int get_test_stage(struct svm_test *test);
+void set_test_stage(struct svm_test *test, int s);
+void inc_test_stage(struct svm_test *test);
+void vmcb_ident(struct vmcb *vmcb);
+struct regs get_regs(void);
+void vmmcall(void);
+void svm_setup_vmrun(u64 rip);
+int __svm_vmrun(u64 rip);
+int svm_vmrun(void);
+void test_set_guest(test_guest_func func);
+
+extern struct vmcb *vmcb;
+
+static inline void stgi(void)
+{
+    asm volatile ("stgi");
+}
+
+static inline void clgi(void)
+{
+    asm volatile ("clgi");
+}
+
+#define SAVE_GPR_C                              \
+        "xchg %%rbx, regs+0x8\n\t"              \
+        "xchg %%rcx, regs+0x10\n\t"             \
+        "xchg %%rdx, regs+0x18\n\t"             \
+        "xchg %%rbp, regs+0x28\n\t"             \
+        "xchg %%rsi, regs+0x30\n\t"             \
+        "xchg %%rdi, regs+0x38\n\t"             \
+        "xchg %%r8, regs+0x40\n\t"              \
+        "xchg %%r9, regs+0x48\n\t"              \
+        "xchg %%r10, regs+0x50\n\t"             \
+        "xchg %%r11, regs+0x58\n\t"             \
+        "xchg %%r12, regs+0x60\n\t"             \
+        "xchg %%r13, regs+0x68\n\t"             \
+        "xchg %%r14, regs+0x70\n\t"             \
+        "xchg %%r15, regs+0x78\n\t"
+
+#define LOAD_GPR_C      SAVE_GPR_C
+
+#define ASM_PRE_VMRUN_CMD                       \
+                "vmload %%rax\n\t"              \
+                "mov regs+0x80, %%r15\n\t"      \
+                "mov %%r15, 0x170(%%rax)\n\t"   \
+                "mov regs, %%r15\n\t"           \
+                "mov %%r15, 0x1f8(%%rax)\n\t"   \
+                LOAD_GPR_C                      \
+
+#define ASM_POST_VMRUN_CMD                      \
+                SAVE_GPR_C                      \
+                "mov 0x170(%%rax), %%r15\n\t"   \
+                "mov %%r15, regs+0x80\n\t"      \
+                "mov 0x1f8(%%rax), %%r15\n\t"   \
+                "mov %%r15, regs\n\t"           \
+                "vmsave %%rax\n\t"              \
+
+#define SVM_BARE_VMRUN \
+	asm volatile ( \
+		ASM_PRE_VMRUN_CMD \
+                "vmrun %%rax\n\t"               \
+		ASM_POST_VMRUN_CMD \
+		: \
+		: "a" (virt_to_phys(vmcb)) \
+		: "memory", "r15") \
+
+#endif
--
2.34.1


