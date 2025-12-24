Return-Path: <kvm+bounces-66659-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 11FA5CDB18E
	for <lists+kvm@lfdr.de>; Wed, 24 Dec 2025 02:44:18 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id CAFAE30380FC
	for <lists+kvm@lfdr.de>; Wed, 24 Dec 2025 01:43:34 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A0917280308;
	Wed, 24 Dec 2025 01:43:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="va/B1/QZ"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f73.google.com (mail-pj1-f73.google.com [209.85.216.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8BBB127E07E
	for <kvm@vger.kernel.org>; Wed, 24 Dec 2025 01:43:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766540613; cv=none; b=rLq9t+EkcQjriwysDdF/pP2o4M1la4kLSz7Zi/gB60Ho+PHtth8y2/OjxZBVr5x+55J+/hwHEB2tl/XOpHC/ynKsWV9eTYBRuWEZZhb8102YTi/e1PbH+e5TTalHDYt/0UCZo+bPAySYU7LzVzVG4rVGPyQbWMmr7CDTpEaa5Vs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766540613; c=relaxed/simple;
	bh=2gBOukd8P0+d94IFZ3cvcQeNSIg0XUhdih1vBjqpR3Y=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=IJ4OrWcG2joPMsHiFxr2xjaLpzi5mlyiTwPwl5D5R5RZgVAVqcnCtcob7T3EAjekJqQ1csrnYu5aBc1H0MvXm/W31cpIw/hjqvKb4FLXAKqDLF7fGwqBHm9rd8Acz9XVMXDK5mX2yWwcSb2xH18IXx9oWYhirKqkuOgVvnLcYPQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--chengkev.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=va/B1/QZ; arc=none smtp.client-ip=209.85.216.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--chengkev.bounces.google.com
Received: by mail-pj1-f73.google.com with SMTP id 98e67ed59e1d1-34cc8bf226cso12273457a91.3
        for <kvm@vger.kernel.org>; Tue, 23 Dec 2025 17:43:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1766540611; x=1767145411; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=OYrgx3fhnAwijJ2RM64Eo+7F0BoQTHdfVNbtE9OQfxk=;
        b=va/B1/QZeOhx3uW6fgUiMewD6DrG5Um+Afyiaf8MyQhBzGRX6h2MsaCrN3ztHUoj5F
         pWaZLSuYaGcKC2OHeic3BcjF6AXL/OxFuoGDQRmqLoKaIkFvBbu+oqHwbhzaf3NF6qyJ
         E3Qdnrtpx9gHyUQptg+vufkcxWRaBg/A/ekNzFwzUGYAoYbM7nXHAgAZT0Xfvfyumg6Q
         03vvLF5/8VcAthfyD16krjlW0ZHyHvmxLqjXb2DVMcokLWBYtNSmUjTuQL/xq7oVrxNG
         YWRkpfknvvnoT8g1ORid6Q/0ZX3dCX5fXDBPjJkT0KUeXK9Jmlojouoi8dq1s5SNScVm
         iACA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1766540611; x=1767145411;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=OYrgx3fhnAwijJ2RM64Eo+7F0BoQTHdfVNbtE9OQfxk=;
        b=tQHJKZdgaJeWm7j3LcPrwQkucAqo9lztviRyeaFt6jnAD6MmQRWVK5RwnOYzGUvB9S
         HDhFsPfbO2H6pKnXvhtdpFGFHmZD2P4zcvWLr44nMudNr7tfmj9TipGJN1KvwPhxl4Ll
         GM0ORcA9pzUyp/nJMfn95GREJ0AGOQOT7VjApXYBXEIBJD9WGyBMJdNeqIukZh05DAsu
         16oFH3skCk3CGP6FnXRggeRGGUPBVvT5gb6TJClXiu4XmuzYPZiVgyEhzebzCChITgA8
         hvNciYFU16oo4XutFfdoKjignnr4towjWw+RXy1QfGjLBE7QCrQWtxgHvB+MjGQ6Y7Dj
         xWaw==
X-Gm-Message-State: AOJu0YxceLum2DPl+HPriVNI6AWYurWQGNnlychFNRb1DYluYK2yOQaZ
	LQ8HNwjoov2uuooUg4cU6YzdKuKKJXAWuER9fDokpoOYwgAoY06p9SrzPNgeLpRcyvXEEc1d+BY
	IXutYUv8kQvMRxFHFzajpzJ0D4dww3Xfw3SkOjRhdXKCGaxJrUJdp7scCYDp3e2aDhnz2Z1RwJl
	7Gw6Ow4b3EUcp3vu0vDIXsb7OTgND3haePAutSNDyPLro=
X-Google-Smtp-Source: AGHT+IFQLaE6qe+8WTvll70QG0bZuApIj+uic3oLZFaV5L6BoVzYoDRnMy/xWYDSjrxjyYaidg3FBD7pJ9cAZQ==
X-Received: from pjvm16.prod.google.com ([2002:a17:90a:de10:b0:34b:75f2:43e])
 (user=chengkev job=prod-delivery.src-stubby-dispatcher) by
 2002:a17:90b:2688:b0:34a:a1c1:90a0 with SMTP id 98e67ed59e1d1-34e921be0e1mr12470121a91.28.1766540610654;
 Tue, 23 Dec 2025 17:43:30 -0800 (PST)
Date: Wed, 24 Dec 2025 01:43:24 +0000
In-Reply-To: <20251224014324.1307211-1-chengkev@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20251224014324.1307211-1-chengkev@google.com>
X-Mailer: git-send-email 2.52.0.351.gbe84eed79e-goog
Message-ID: <20251224014324.1307211-3-chengkev@google.com>
Subject: [kvm-unit-tests PATCH v3 2/2] x86/svm: Add unsupported instruction
 intercept test
From: Kevin Cheng <chengkev@google.com>
To: kvm@vger.kernel.org
Cc: yosryahmed@google.com, andrew.jones@linux.dev, thuth@redhat.com, 
	pbonzini@redhat.com, seanjc@google.com, Kevin Cheng <chengkev@google.com>
Content-Type: text/plain; charset="UTF-8"

Add tests that expect a nested vm exit, due to an unsupported
instruction, to be handled by L0 even if L1 intercepts are set for that
instruction.

The new test exercises bug fixed by:
https://lore.kernel.org/all/20251205070630.4013452-1-chengkev@google.com/

Signed-off-by: Kevin Cheng <chengkev@google.com>
---
 lib/x86/processor.h |  1 +
 x86/svm.h           |  5 ++-
 x86/svm_tests.c     | 88 +++++++++++++++++++++++++++++++++++++++++++++
 x86/unittests.cfg   | 11 +++++-
 4 files changed, 103 insertions(+), 2 deletions(-)

diff --git a/lib/x86/processor.h b/lib/x86/processor.h
index 42dd2d2a4787c..7e1c562aa7378 100644
--- a/lib/x86/processor.h
+++ b/lib/x86/processor.h
@@ -358,6 +358,7 @@ struct x86_cpu_feature {
  * Extended Leafs, a.k.a. AMD defined
  */
 #define X86_FEATURE_SVM			X86_CPU_FEATURE(0x80000001, 0, ECX, 2)
+#define X86_FEATURE_SKINIT		X86_CPU_FEATURE(0x80000001, 0, ECX, 12)
 #define X86_FEATURE_PERFCTR_CORE	X86_CPU_FEATURE(0x80000001, 0, ECX, 23)
 #define X86_FEATURE_NX			X86_CPU_FEATURE(0x80000001, 0, EDX, 20)
 #define X86_FEATURE_GBPAGES		X86_CPU_FEATURE(0x80000001, 0, EDX, 26)
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
index e732fb4eeea38..8ea3c344ec4fa 100644
--- a/x86/svm_tests.c
+++ b/x86/svm_tests.c
@@ -3575,6 +3575,93 @@ static void svm_shutdown_intercept_test(void)
 	report(vmcb->control.exit_code == SVM_EXIT_SHUTDOWN, "shutdown test passed");
 }
 
+struct invpcid_desc desc;
+
+asm(
+	"insn_rdtscp: rdtscp;ret\n\t"
+	"insn_skinit: skinit;ret\n\t"
+	"insn_xsetbv: xor %eax, %eax; xor %edx, %edx; xor %ecx, %ecx; xsetbv;ret\n\t"
+	"insn_rdpru: xor %ecx, %ecx; rdpru;ret\n\t"
+	"insn_invpcid: xor %eax, %eax; invpcid desc, %rax;ret\n\t"
+);
+
+extern void insn_rdtscp(struct svm_test *test);
+extern void insn_skinit(struct svm_test *test);
+extern void insn_xsetbv(struct svm_test *test);
+extern void insn_rdpru(struct svm_test *test);
+extern void insn_invpcid(struct svm_test *test);
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
+static void assert_unsupported_instructions(void)
+{
+	assert(!this_cpu_has(X86_FEATURE_RDTSCP));
+	assert(!this_cpu_has(X86_FEATURE_SKINIT));
+	assert(!this_cpu_has(X86_FEATURE_XSAVE));
+	assert(!this_cpu_has(X86_FEATURE_RDPRU));
+	assert(!this_cpu_has(X86_FEATURE_INVPCID));
+}
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
+	assert_unsupported_instructions();
+
+	vmcb_set_intercept(INTERCEPT_EXCEPTION_OFFSET + UD_VECTOR);
+
+	for (cur_insn = 0; insn_table[cur_insn].name != NULL; ++cur_insn) {
+		struct insn_table insn = insn_table[cur_insn];
+
+		test_set_guest(insn.insn_func);
+		vmcb_set_intercept(insn.intercept);
+		svm_vmrun();
+		exit_code = vmcb->control.exit_code;
+
+		if (exit_code == SVM_EXIT_EXCP_BASE + UD_VECTOR)
+			report_pass("UD Exception injected");
+		else if (exit_code == insn.reason)
+			report_fail("L1 should not intercept %s when instruction is not advertised in guest CPUID",
+				    insn.name);
+		else
+			report_fail("Unknown exit reason, 0x%x", exit_code);
+
+		/*
+		 * Verify that the intercept bits are not cleared in the vmcb.
+		 * This is mainly to catch any potential bugs in the future
+		 * if we ever directly copy from the cached vmcb12 to L1's
+		 * vmcb12. KVM currently ignores the L1 intercept by
+		 * conditionally clearing intercept bits from KVM's cached
+		 * vmcb12 based on guest's CPUID table. This is only allowed as
+		 * long as the assumption that the cached vmcb12 doesn't affect
+		 * L1's vmcb12 holds true.
+		 */
+		report(test_and_clear_bit(insn.intercept,
+					  vmcb->control.intercept),
+					  "%s intercept bit not cleared by KVM",
+					  insn.name);
+	}
+}
+
 struct svm_test svm_tests[] = {
 	{ "null", default_supported, default_prepare,
 	  default_prepare_gif_clear, null_test,
@@ -3716,6 +3803,7 @@ struct svm_test svm_tests[] = {
 	TEST(svm_tsc_scale_test),
 	TEST(pause_filter_test),
 	TEST(svm_shutdown_intercept_test),
+	TEST(svm_unsupported_instruction_intercept_test),
 	{ NULL, NULL, NULL, NULL, NULL, NULL, NULL }
 };
 
diff --git a/x86/unittests.cfg b/x86/unittests.cfg
index 522318d32bf68..27a1a68104362 100644
--- a/x86/unittests.cfg
+++ b/x86/unittests.cfg
@@ -253,11 +253,20 @@ arch = x86_64
 [svm]
 file = svm.flat
 smp = 2
-test_args = "-pause_filter_test"
+test_args = "-pause_filter_test -svm_unsupported_instruction_intercept_test"
 qemu_params = -cpu max,+svm -m 4g
 arch = x86_64
 groups = svm
 
+# RDPRU feature name is not defined in Qemu so it can't be excluded here. This
+# should be okay though since KVM does not advertise RDPRU by default anyways.
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
2.52.0.351.gbe84eed79e-goog


