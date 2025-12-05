Return-Path: <kvm+bounces-65333-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [IPv6:2600:3c04:e001:36c::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id D8036CA6F9F
	for <lists+kvm@lfdr.de>; Fri, 05 Dec 2025 10:45:34 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 3990E343B70D
	for <lists+kvm@lfdr.de>; Fri,  5 Dec 2025 08:33:17 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9388234026B;
	Fri,  5 Dec 2025 08:03:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="ffRxXccA"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f202.google.com (mail-pf1-f202.google.com [209.85.210.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2E1D131A55F
	for <kvm@vger.kernel.org>; Fri,  5 Dec 2025 08:02:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764921786; cv=none; b=HHysBQ98aMWSX5XuxXnQiARWcv8yyCpQMqB35HULKvzaNTTavNrukvvM6TmJHJy89N2wJ2CkHbXO74hCFCL5F2CF+VEfvOMwak77xXpmw4jEAsJS69dSIBIpQHooW7UrYulbM9ms8+1ECG/gA7r9jJIM46tkkUhsNG2CHM3Q68U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764921786; c=relaxed/simple;
	bh=bxsSbO9CejoAq5ITGojN6dsguFM7NyPkmnWZkCb8YLY=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=JVr1jSR7ssf2NhDvRKXKzUVz3AUvNO+iIO0k+13RXdPN0lyw2kqOCcGTfIXyvtcgkadF9Y5E0mUFYVhiD8rTUr/Er/q+zRjUwCL1r6i4lXqUDLkcLcllrqiSQ5HxLwNisIPpPCTjWTpEtgNFbINnQG/1LUTzNr9B97oR3n8w/NA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--chengkev.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=ffRxXccA; arc=none smtp.client-ip=209.85.210.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--chengkev.bounces.google.com
Received: by mail-pf1-f202.google.com with SMTP id d2e1a72fcca58-7b895b520a2so1884096b3a.0
        for <kvm@vger.kernel.org>; Fri, 05 Dec 2025 00:02:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1764921770; x=1765526570; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=VfBC4L0W4+2xgM5lrvsI6u556ehImIGcx3NQ/mn6oQQ=;
        b=ffRxXccAOWeanVXLYuQ1Z+gkOo3461UhjS6LIhBJSRBJ94FlkY9/daDtDMVpn40aqi
         XhMtfGvs5DvryUbpSKxIrsT0YvXDKrLIIUdI+DyFOFUvNsqYah151I5RjgLBRXYDKRg+
         vek3BaDZNkmtr6/tgrApK2hysnwx/dxFEV/MJzRsY+XI6RmEGT3ycG51mHBR3FiwJGgv
         qQ0NPgI9JZNMzp9+ZvVmIZgCg/aAVoLvHCmdj5psLVP7KJ+L9Qmp+1Wy1vfFfBGRth8X
         Fyu+ZtfLi8vEsBc9G0P7++KPP/Hd+pdeBb28BQBBKyWFshIjo6XcahkUZz4dLBg4uI6X
         aOpA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764921770; x=1765526570;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=VfBC4L0W4+2xgM5lrvsI6u556ehImIGcx3NQ/mn6oQQ=;
        b=KhrujspBrlxxQqP3d87aoK6SZHG1fseKyrVj6QoOF1H7fzuYOBN8rLh8o3bkMGin/0
         bmfZ53UrA9c99Sk9jMCp0xW1HwW0/K8OI8TeZDJ02pYASbpZe8AM7F3RhAFEuUkOs0O6
         4DPu85xnNjf1JzDlQbY1zfSxkj70CAf+itrZGC578hoasR4pO/oQxpPqx9ox0GkhczIf
         NpOTMfhwLlHM1HgSAEjCq+gGQjvu2HjdyiiDHe8mHGYT6UH4NxizelxSwR1Bi+fw/Jxn
         d5YanUbzVelslRUeMjb5/hQeoHfr0ZKQZyY2VGQ0giZ0ELe7SA8thJT+so1K0+i+OUzG
         9OMA==
X-Gm-Message-State: AOJu0YzXaeP+DZQZhW+hSlGMYNpbEUHRzoDcaJD+ZcwkDSMdi5x3lCqe
	4TZY8byBbMUAF9OZtR2kNCPo5+RR1N6liQQAbI2Y8Fi9VlROgcFzJqWTy3PLqd/GEbWbNGQRqJI
	LhtToS474/msUiuJliqcJyow44XE7GLR6TBllg3x6RPHGG1sX+M1PuN0Ux3syOVbTltwrN5GK4e
	43DD9cSUcZp6ZtmPRfQ9dxbkOE23/AWYIBzDXwA1JYgf4=
X-Google-Smtp-Source: AGHT+IEiKJnHKtMpYJeNh2draPB300yT1TVCNN7rudJcrVv6ri3wYvzspAc49w3uRJWQUnpdrAr0Dlxce27Mcg==
X-Received: from pgac24.prod.google.com ([2002:a05:6a02:2958:b0:b47:34d0:d386])
 (user=chengkev job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6a21:998b:b0:2fb:2e04:eeae with SMTP id adf61e73a8af0-3640378a658mr6944856637.21.1764921770109;
 Fri, 05 Dec 2025 00:02:50 -0800 (PST)
Date: Fri,  5 Dec 2025 08:02:28 +0000
In-Reply-To: <20251205080228.4055341-1-chengkev@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20251205080228.4055341-1-chengkev@google.com>
X-Mailer: git-send-email 2.52.0.223.gf5cc29aaa4-goog
Message-ID: <20251205080228.4055341-3-chengkev@google.com>
Subject: [kvm-unit-tests PATCH] x86/svm: Add unsupported instruction intercept test
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
 x86/svm.h         |  5 +++-
 x86/svm_tests.c   | 75 +++++++++++++++++++++++++++++++++++++++++++++++
 x86/unittests.cfg |  9 +++++-
 3 files changed, 87 insertions(+), 2 deletions(-)

diff --git a/x86/svm.h b/x86/svm.h
index 93ef6f772c6ee..86d58c3100275 100644
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
index ccc89d45d4db9..cea8865787545 100644
--- a/x86/svm_tests.c
+++ b/x86/svm_tests.c
@@ -3572,6 +3572,80 @@ static void svm_shutdown_intercept_test(void)
 	report(vmcb->control.exit_code == SVM_EXIT_SHUTDOWN, "shutdown test passed");
 }
 
+struct InvpcidDesc {
+	uint64_t pcid : 12;
+	uint64_t reserved : 52;
+	uint64_t addr;
+};
+
+static void insn_invpcid(struct svm_test *test)
+{
+	struct InvpcidDesc desc = {0};
+	unsigned long type = 0;
+
+	__asm__ volatile (
+		"invpcid %1, %0"
+		:
+		: "r" (type), "m" (desc)
+		: "memory"
+	);
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
@@ -3713,6 +3787,7 @@ struct svm_test svm_tests[] = {
 	TEST(svm_tsc_scale_test),
 	TEST(pause_filter_test),
 	TEST(svm_shutdown_intercept_test),
+	TEST(svm_unsupported_instruction_intercept_test),
 	{ NULL, NULL, NULL, NULL, NULL, NULL, NULL }
 };
 
diff --git a/x86/unittests.cfg b/x86/unittests.cfg
index 522318d32bf68..ec456d779b35c 100644
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
+qemu_params = -cpu max,+svm,-rdtscp,-xsave,-invpcid
+arch = x86_64
+groups = svm
+
 [svm_pause_filter]
 file = svm.flat
 test_args = pause_filter_test
-- 
2.52.0.223.gf5cc29aaa4-goog


