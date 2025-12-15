Return-Path: <kvm+bounces-66040-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sto.lore.kernel.org (sto.lore.kernel.org [172.232.135.74])
	by mail.lfdr.de (Postfix) with ESMTPS id 92639CBFDC4
	for <lists+kvm@lfdr.de>; Mon, 15 Dec 2025 22:00:41 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sto.lore.kernel.org (Postfix) with ESMTP id E84E830019E1
	for <lists+kvm@lfdr.de>; Mon, 15 Dec 2025 21:00:40 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D11CF2874ED;
	Mon, 15 Dec 2025 21:00:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="qxUKAmtH"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com [209.85.216.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0ADB82C11F1
	for <kvm@vger.kernel.org>; Mon, 15 Dec 2025 21:00:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765832437; cv=none; b=ABxsZUtA1FJoYyhWlfTsq/ONqONAhI+9clMTmcxM8tDCMqqHGrX6Gel0TbGyRa/96eXmvC+Qucifp9zayvrRqRjanKlQscqtkvQfABt/o1HB7XdwYh7/HUoe+I/731vc16jnoV2EyfvdXVQpNYy04xqpsw8xvY+XbrSb8qvMyDk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765832437; c=relaxed/simple;
	bh=kw+x7GshWcJKswgx4fP6xZofUgTAm/XP2lu6G4c6xto=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=rrmG+GOWYQNjbjL8CUh56pqW3GvT2snEUXzBDxnZd4wWqvuQXL1Yj+UIy7rBsaZsrQvBH1Yz+/h8Kv7s23la5uBwrSIuvBAb0bvzVHQJqVIF3SUDpQ9x0KLIkVUMmQT0QdFjKiOlWAqo0BmkuoOtAM54OrQwgZZc5MhTsYRJ8YY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--chengkev.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=qxUKAmtH; arc=none smtp.client-ip=209.85.216.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--chengkev.bounces.google.com
Received: by mail-pj1-f74.google.com with SMTP id 98e67ed59e1d1-34c704d5d15so3872245a91.1
        for <kvm@vger.kernel.org>; Mon, 15 Dec 2025 13:00:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1765832433; x=1766437233; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=5MnrlV0Tb9SM+anUDHFbl+f1LDdDfLOIm3X1Yix2fvA=;
        b=qxUKAmtHSrqfz/JPRhIQqx3+qYzBuyIYvpbNXTj/xVZlmL2aCreioniA0KdTyrTaQb
         0vWTMWUkNNdCTl3HNyAkJsvj51+1j+ldI0/O11U8apmj1sLNrTJawSs5pPZhkHIvXlxA
         dOKB7YBLMhLYC6GigpXN+wp+SfV4ICCRUKbiPu/2y8YKiq1ioWJuHOBzPC0ADkn2avKa
         Z0JjfVDY1L3rxScqobAUHlAzCmN0qZJGsuIFlueC8uFMJqP02SopBv1quJLj0MpYu5hF
         T1RRI820oCbGnsRIrT+jB7MsYAlmgbLQCjJNXOCyMjXZwelJTiJvgVdxy+1KqsAdXO+Z
         8PPA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1765832433; x=1766437233;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=5MnrlV0Tb9SM+anUDHFbl+f1LDdDfLOIm3X1Yix2fvA=;
        b=QO+ygvx3OPoKigPTR97YbKIyrsY2DpoqajEOyvXkdvThWCYbxGxWlrKx9/LEPGLer7
         CBr69YSDAY7bbkmDUtjIrI8pesopvrlqzZhS4GGaccAidad3lDe/U+r4oLuofWfrWVNb
         31WO/GxwdlQDLllkHzcXPHsGflVkACihQ1Z8w3RcqSC6v2SxxB1nvhyc9+AhO8yXMtTS
         7XD2JZlI4b1qRNQly5goxLsQD9+x5EAfBJtMcGklYnUwpMketGygKxXKXECRsAAPVziA
         saE88hFNjYYXJPK88qIMYt/YQT1ojGtUUyI3ulpe2hG9lqwik1JI/27fMgLv3MsM5ID3
         VGig==
X-Gm-Message-State: AOJu0YwzD+OL/hCGImv+n9rMPPlS2QeGt+zFFnxwh2XjuVAVGtCjcPBw
	QehYNvxAwqVLIjtKaqXbFUPAJhFk7aPdX9XXyMLO8d/jqRSKQe521Kk8o3ouQ/v5LiE08nAjL4J
	PEKvCSGFuxIOPGiPwN6xL4L2Pb5nnjzzYqFG5P2p/+BVM2VJIsZ9y2Ir8ZLSwJ6IGlSrQXcUAwf
	BZphWp9RrM9B0b9QxC0LnXHO4/TQl+eWqxiaEGHuzFoa4=
X-Google-Smtp-Source: AGHT+IHVZYg5aBULWI5KNDuQpiKyB0pxc3/0PJfdgzZe0jxBSozzKDuwN+L0OvV9j27tUhxS7GMTDxtfhgP5HA==
X-Received: from pge9.prod.google.com ([2002:a05:6a02:2d09:b0:bc4:8a19:36d4])
 (user=chengkev job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6a20:914e:b0:34f:c83b:b3fa with SMTP id adf61e73a8af0-369afc01103mr11389602637.41.1765832433102;
 Mon, 15 Dec 2025 13:00:33 -0800 (PST)
Date: Mon, 15 Dec 2025 21:00:26 +0000
In-Reply-To: <20251215210026.2422155-1-chengkev@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20251215210026.2422155-1-chengkev@google.com>
X-Mailer: git-send-email 2.52.0.239.gd5f0c6e74e-goog
Message-ID: <20251215210026.2422155-3-chengkev@google.com>
Subject: [kvm-unit-tests PATCH v2 2/2] x86/svm: Add unsupported instruction
 intercept test
From: Kevin Cheng <chengkev@google.com>
To: kvm@vger.kernel.org
Cc: yosryahmed@google.com, andrew.jones@linux.dev, thuth@redhat.com, 
	pbonzini@redhat.com, seanjc@google.com, Kevin Cheng <chengkev@google.com>, 
	Yosry Ahmed <yosry.ahmed@linux.dev>
Content-Type: text/plain; charset="UTF-8"

Add tests that expect a nested vm exit, due to an unsupported
instruction, to be handled by L0 even if L1 intercepts are set for that
instruction.

The new test exercises bug fixed by:
https://lore.kernel.org/all/20251205070630.4013452-1-chengkev@google.com/

Signed-off-by: Kevin Cheng <chengkev@google.com>
Reviewed-by: Yosry Ahmed <yosry.ahmed@linux.dev>
---
 x86/svm.h         |  5 +++-
 x86/svm_tests.c   | 63 +++++++++++++++++++++++++++++++++++++++++++++++
 x86/unittests.cfg |  9 ++++++-
 3 files changed, 75 insertions(+), 2 deletions(-)

diff --git a/x86/svm.h b/x86/svm.h
index c22c252fed001..e2158ab0622bb 100644
--- a/x86/svm.h
+++ b/x86/svm.h
@@ -406,7 +406,10 @@ struct __attribute__ ((__packed__)) vmcb {
 #define SVM_EXIT_MONITOR	0x08a
 #define SVM_EXIT_MWAIT		0x08b
 #define SVM_EXIT_MWAIT_COND	0x08c
-#define SVM_EXIT_NPF  		0x400
+#define SVM_EXIT_XSETBV		0x08d
+#define SVM_EXIT_RDPRU		0x08e
+#define SVM_EXIT_INVPCID	0x0a2
+#define SVM_EXIT_NPF		0x400
 
 #define SVM_EXIT_ERR		-1
 
diff --git a/x86/svm_tests.c b/x86/svm_tests.c
index e732fb4eeea38..ec14f13c06d4b 100644
--- a/x86/svm_tests.c
+++ b/x86/svm_tests.c
@@ -3575,6 +3575,68 @@ static void svm_shutdown_intercept_test(void)
 	report(vmcb->control.exit_code == SVM_EXIT_SHUTDOWN, "shutdown test passed");
 }
 
+static void insn_invpcid(struct svm_test *test)
+{
+	struct invpcid_desc desc = {0};
+
+	invpcid_safe(0, &desc);
+}
+
+asm(
+	"insn_rdtscp: rdtscp;ret\n\t"
+	"insn_skinit: skinit;ret\n\t"
+	"insn_xsetbv: xor %eax, %eax; xor %edx, %edx; xor %ecx, %ecx; xsetbv;ret\n\t"
+	"insn_rdpru: xor %ecx, %ecx; rdpru;ret\n\t"
+);
+
+extern void insn_rdtscp(struct svm_test *test);
+extern void insn_skinit(struct svm_test *test);
+extern void insn_xsetbv(struct svm_test *test);
+extern void insn_rdpru(struct svm_test *test);
+
+struct insn_table {
+	const char *name;
+	u64 intercept;
+	void (*insn_func)(struct svm_test *test);
+	u32 reason;
+};
+
+static struct insn_table insn_table[] = {
+	{ "RDTSCP", INTERCEPT_RDTSCP, insn_rdtscp, SVM_EXIT_RDTSCP},
+	{ "SKINIT", INTERCEPT_SKINIT, insn_skinit, SVM_EXIT_SKINIT},
+	{ "XSETBV", INTERCEPT_XSETBV, insn_xsetbv, SVM_EXIT_XSETBV},
+	{ "RDPRU", INTERCEPT_RDPRU, insn_rdpru, SVM_EXIT_RDPRU},
+	{ "INVPCID", INTERCEPT_INVPCID, insn_invpcid, SVM_EXIT_INVPCID},
+	{ NULL },
+};
+
+/*
+ * Test that L1 does not intercept instructions that are not advertised in
+ * guest CPUID.
+ */
+static void svm_unsupported_instruction_intercept_test(void)
+{
+	u32 cur_insn;
+	u32 exit_code;
+
+	vmcb_set_intercept(INTERCEPT_EXCEPTION_OFFSET + UD_VECTOR);
+
+	for (cur_insn = 0; insn_table[cur_insn].name != NULL; ++cur_insn) {
+		test_set_guest(insn_table[cur_insn].insn_func);
+		vmcb_set_intercept(insn_table[cur_insn].intercept);
+		svm_vmrun();
+		exit_code = vmcb->control.exit_code;
+
+		if (exit_code == SVM_EXIT_EXCP_BASE + UD_VECTOR)
+			report_pass("UD Exception injected");
+		else if (exit_code == insn_table[cur_insn].reason)
+			report_fail("L1 should not intercept %s when instruction is not advertised in guest CPUID",
+				    insn_table[cur_insn].name);
+		else
+			report_fail("Unknown exit reason, 0x%x", exit_code);
+	}
+}
+
 struct svm_test svm_tests[] = {
 	{ "null", default_supported, default_prepare,
 	  default_prepare_gif_clear, null_test,
@@ -3716,6 +3778,7 @@ struct svm_test svm_tests[] = {
 	TEST(svm_tsc_scale_test),
 	TEST(pause_filter_test),
 	TEST(svm_shutdown_intercept_test),
+	TEST(svm_unsupported_instruction_intercept_test),
 	{ NULL, NULL, NULL, NULL, NULL, NULL, NULL }
 };
 
diff --git a/x86/unittests.cfg b/x86/unittests.cfg
index 522318d32bf68..5a2084e457167 100644
--- a/x86/unittests.cfg
+++ b/x86/unittests.cfg
@@ -253,11 +253,18 @@ arch = x86_64
 [svm]
 file = svm.flat
 smp = 2
-test_args = "-pause_filter_test"
+test_args = "-pause_filter_test -svm_unsupported_instruction_intercept_test"
 qemu_params = -cpu max,+svm -m 4g
 arch = x86_64
 groups = svm
 
+[svm_unsupported_instruction_intercept_test]
+file = svm.flat
+test_args = "svm_unsupported_instruction_intercept_test"
+qemu_params = -cpu max,+svm,-rdtscp,-xsave,-invpcid,-skinit
+arch = x86_64
+groups = svm
+
 [svm_pause_filter]
 file = svm.flat
 test_args = pause_filter_test
-- 
2.52.0.239.gd5f0c6e74e-goog


