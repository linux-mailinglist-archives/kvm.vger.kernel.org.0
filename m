Return-Path: <kvm+bounces-55196-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 7F45DB2E24E
	for <lists+kvm@lfdr.de>; Wed, 20 Aug 2025 18:30:30 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 58953188EFC7
	for <lists+kvm@lfdr.de>; Wed, 20 Aug 2025 16:30:19 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 36EC0334360;
	Wed, 20 Aug 2025 16:29:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="H0l08jQ6"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f202.google.com (mail-pf1-f202.google.com [209.85.210.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E48463314C9
	for <kvm@vger.kernel.org>; Wed, 20 Aug 2025 16:29:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755707374; cv=none; b=aIDC4C2zorguKCoFO2YIuHIkifTfNlq6vMl5GarqblJ1MXsICR1j1xuwqH/kj+/y4U6Q9QZBvHaKmwHLbSELZrsrlSEHOLpoJ5HciwckSrvg7jhW/+hPPkPn8WoOnX171PqXLWOgKWcV3zuiqjmaZ9NfMs7OhihVTl5aX1VxtNQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755707374; c=relaxed/simple;
	bh=oeEOEoX4hvj4fnGYZ5YGbaQOVxfwa4cjxMy6v64Ohm4=;
	h=Date:Mime-Version:Message-ID:Subject:From:To:Cc:Content-Type; b=FXhqfH3ObjERLYK93vEYR3DNewrIy3vN/wEX4trQ10SIop6qsV9/mV+EL8a5QcnTRAQjU8hnvHDqstNXL0qQH407mkRaeUwik1uRyHAmXJfclGl7w8+sAeYAu3H6wl/ZTyHh3jwtEiHAB//WrKlZXKqXGfZAxsxnTQPlBu7IW6Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--chengkev.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=H0l08jQ6; arc=none smtp.client-ip=209.85.210.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--chengkev.bounces.google.com
Received: by mail-pf1-f202.google.com with SMTP id d2e1a72fcca58-76e2ead3b51so167833b3a.2
        for <kvm@vger.kernel.org>; Wed, 20 Aug 2025 09:29:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1755707372; x=1756312172; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=Ov90MaHlyGaJsgKwGzvu0uizEpf4vGAAGH/Vm0tBmOA=;
        b=H0l08jQ6iq7t3ZUPWYNmTnXY8TMSWUbFyVlQ0kpm7y3VISCknYNFum4cA+mX+NQAqM
         p2WCvrjI4z1P2NIu0f20y9evbrgNi+Wi/t4kkEzTPPcUmdxzEt+6un+U83YRVdS1777k
         jSzx2u+P/So6mmTXedTShj+blYN9+F49dFh5GPBWqf2h4m4QhneOsBDLJRnVzzCV1pHg
         TxuUPL3w5lW6f9E1MrywVgOL6cMLTq/BTkZOOLELF82rWKlouHsKzKHSdq+O/ceQ/yCB
         wG/r7DXsiSbsgRj89z38R6YpqrkUVTJkiAuktV/NBM4nBXG/3LOTk9vx7GJnPS2KOMCr
         b8ew==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755707372; x=1756312172;
        h=cc:to:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=Ov90MaHlyGaJsgKwGzvu0uizEpf4vGAAGH/Vm0tBmOA=;
        b=jV/lslqkNaY8zGW2LBQp+7gjJO4eyMGCgisx/bdIE7OYtPIsxFASEkhd5SGqLgvoFa
         YToWFUKD756FmXG1NDLuUe5byv2BFEEwwjdcwjiqoVyEmZEMJnVGJgegkMjjw1ZvhPsp
         a6axRrDu48TASHLyXgX9t6JXLIdwrWTuFwG23tfRYBWhHC3DRb3Dj1YHWKbtqjXvJNpJ
         Q60+c8pWEWBUqnP8qSbueHc2ewQ5psvuYvrDz7Oy1rKKdpwQd+Ch/aJl/Gi7LiAatLdm
         ngFNMTNWy6JewGHVTj108fmq37QOZZMdW/JXe3k0gFJbYqdgDsZctg7+heBtU83khxjE
         z3fg==
X-Gm-Message-State: AOJu0Yyqo8vEFZTGXgYQ9DM7Tn8L2qZh7ZGzVbEWLr4RfeKb963ZWobj
	NHIw70isR2/L4ktI+s0JpjuDNjw53HllzHow/eF5oSo6mLNle0hdXigghNFSR7LuBVfPAvdVQUX
	run94L696D9VNoVJ5x7JNhF5K75GAut15z4f+d3qV96yRNbwKQ2G8fdwDUvB4hI3SvUbzLlXZEE
	B2CHzVO4c/MqE0GNKuq5/IEed5S72VccrxmzMppsObKoM=
X-Google-Smtp-Source: AGHT+IHGmY6Eh8CEnOMBo5yCitO5bFYNmga/IGWNJeYYSlfSs0FSspNu1d55PYKK1yFy1MVhW3SJBZczTx8Gcg==
X-Received: from pfbjw5.prod.google.com ([2002:a05:6a00:9285:b0:76b:de2b:6796])
 (user=chengkev job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6a00:21cd:b0:76b:f06f:3bdf with SMTP id d2e1a72fcca58-76e8dd0aac3mr5925457b3a.17.1755707372117;
 Wed, 20 Aug 2025 09:29:32 -0700 (PDT)
Date: Wed, 20 Aug 2025 16:29:26 +0000
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
X-Mailer: git-send-email 2.51.0.261.g7ce5a0a67e-goog
Message-ID: <20250820162926.3498713-1-chengkev@google.com>
Subject: [kvm-unit-tests PATCH] x86: nSVM: Add tests for instruction interrupts
From: Kevin Cheng <chengkev@google.com>
To: kvm@vger.kernel.org
Cc: jmattson@google.com, pbonzini@redhat.com, 
	Kevin Cheng <chengkev@google.com>
Content-Type: text/plain; charset="UTF-8"

The nVMX tests already have coverage for instruction intercepts.
Add a similar test for nSVM to improve test parity between nSVM and
nVMX.

Signed-off-by: Kevin Cheng <chengkev@google.com>
---
 x86/svm_tests.c | 120 ++++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 120 insertions(+)

diff --git a/x86/svm_tests.c b/x86/svm_tests.c
index 80d5aeb1..50201683 100644
--- a/x86/svm_tests.c
+++ b/x86/svm_tests.c
@@ -12,6 +12,7 @@
 #include "util.h"
 #include "x86/usermode.h"
 #include "vmalloc.h"
+#include "pmu.h"
 
 #define SVM_EXIT_MAX_DR_INTERCEPT 0x3f
 
@@ -2487,6 +2488,124 @@ static void test_dr(void)
 	vmcb->save.dr7 = dr_saved;
 }
 
+asm(
+	"insn_sidt: sidt idt_descr;ret\n\t"
+	"insn_sgdt: sgdt gdt_descr;ret\n\t"
+	"insn_sldt: sldt %ax;ret\n\t"
+	"insn_str: str %ax;ret\n\t"
+	"insn_lidt: lidt idt_descr;ret\n\t"
+	"insn_lgdt: lgdt gdt_descr;ret\n\t"
+	"insn_lldt: xor %eax, %eax; lldt %ax;ret\n\t"
+	"insn_rdpmc: xor %ecx, %ecx; rdpmc;ret\n\t"
+	"insn_cpuid: mov $10, %eax; cpuid;ret\n\t"
+	"insn_invd: invd;ret\n\t"
+	"insn_pause: pause;ret\n\t"
+	"insn_hlt: hlt;ret\n\t"
+	"insn_invlpg: invlpg 0x12345678;ret\n\t"
+	"insn_monitor: xor %eax, %eax; xor %ecx, %ecx; xor %edx, %edx; monitor;ret\n\t"
+	"insn_mwait: xor %eax, %eax; xor %ecx, %ecx; mwait;ret\n\t"
+);
+
+extern void insn_sidt(struct svm_test *test);
+extern void insn_sgdt(struct svm_test *test);
+extern void insn_sldt(struct svm_test *test);
+extern void insn_str(struct svm_test *test);
+extern void insn_lidt(struct svm_test *test);
+extern void insn_lgdt(struct svm_test *test);
+extern void insn_lldt(struct svm_test *test);
+extern void insn_rdpmc(struct svm_test *test);
+extern void insn_cpuid(struct svm_test *test);
+extern void insn_invd(struct svm_test *test);
+extern void insn_pause(struct svm_test *test);
+extern void insn_hlt(struct svm_test *test);
+extern void insn_invlpg(struct svm_test *test);
+extern void insn_monitor(struct svm_test *test);
+extern void insn_mwait(struct svm_test *test);
+
+u32 cur_insn;
+
+typedef bool (*supported_fn)(void);
+
+static bool this_cpu_has_mwait(void)
+{
+	return this_cpu_has(X86_FEATURE_MWAIT);
+}
+
+struct insn_table {
+	const char *name;
+	u32 flag;
+	void (*insn_func)(struct svm_test *test);
+	u32 reason;
+	u64 exit_info_1;
+	u64 exit_info_2;
+	bool always_traps;
+	const supported_fn supported_fn;
+};
+
+static struct insn_table insn_table[] = {
+	{"STORE IDTR", INTERCEPT_STORE_IDTR, insn_sidt, SVM_EXIT_IDTR_READ, 0, 0},
+	{"STORE GDTR", INTERCEPT_STORE_GDTR, insn_sgdt, SVM_EXIT_GDTR_READ, 0, 0},
+	{"STORE LDTR", INTERCEPT_STORE_LDTR, insn_sldt, SVM_EXIT_LDTR_READ, 0, 0},
+	{"STORE TR", INTERCEPT_STORE_TR, insn_str, SVM_EXIT_TR_READ, 0, 0},
+	{"LOAD IDTR", INTERCEPT_LOAD_IDTR, insn_lidt, SVM_EXIT_IDTR_WRITE, 0, 0},
+	{"LOAD GDTR", INTERCEPT_LOAD_GDTR, insn_lgdt, SVM_EXIT_GDTR_WRITE, 0, 0},
+	{"LOAD LDTR", INTERCEPT_LOAD_LDTR, insn_lldt, SVM_EXIT_LDTR_WRITE, 0, 0},
+	{"RDPMC", INTERCEPT_RDPMC, insn_rdpmc, SVM_EXIT_RDPMC, 0, 0, false, this_cpu_has_pmu},
+	{"CPUID", INTERCEPT_CPUID, insn_cpuid, SVM_EXIT_CPUID, 0, 0, true},
+	{"INVD", INTERCEPT_INVD, insn_invd, SVM_EXIT_INVD, 0, 0, true},
+	{"PAUSE", INTERCEPT_PAUSE, insn_pause, SVM_EXIT_PAUSE, 0, 0},
+	{"HLT", INTERCEPT_HLT, insn_hlt, SVM_EXIT_HLT, 0, 0},
+	{"INVLPG", INTERCEPT_INVLPG, insn_invlpg, SVM_EXIT_INVLPG, 0, 0},
+	{"MONITOR", INTERCEPT_MONITOR, insn_monitor, SVM_EXIT_MONITOR, 0, 0, false, this_cpu_has_mwait},
+	{"MWAIT", INTERCEPT_MWAIT, insn_mwait, SVM_EXIT_MWAIT, 0, 0, false, this_cpu_has_mwait},
+	{NULL},
+};
+
+static void insn_intercept_test(void)
+{
+	u32 exit_code;
+	u64 exit_info_1;
+	u64 exit_info_2;
+
+	for (cur_insn = 0; insn_table[cur_insn].name != NULL; ++cur_insn) {
+		struct insn_table insn = insn_table[cur_insn];
+
+		if (insn.supported_fn && !insn.supported_fn()) {
+			printf("\tFeature required for %s is not supported.\n",
+			       insn_table[cur_insn].name);
+			continue;
+		}
+
+		test_set_guest(insn.insn_func);
+
+		if (insn.insn_func != insn_hlt && !insn.always_traps)
+			report(svm_vmrun() == SVM_EXIT_VMMCALL, "execute %s", insn.name);
+
+		vmcb->control.intercept |= 1 << insn.flag;
+
+		svm_vmrun();
+
+		exit_code = vmcb->control.exit_code;
+		exit_info_1 = vmcb->control.exit_info_1;
+		exit_info_2 = vmcb->control.exit_info_2;
+
+		report(exit_code == insn.reason,
+			"Expected exit code: 0x%x, received exit code: 0x%x",
+			exit_code, insn.reason);
+
+		if (!exit_info_1)
+			report(exit_info_1 == insn.exit_info_1,
+			"Expected exit_info_1: 0x%lx, received exit_info_1: 0x%lx",
+			exit_info_1, insn.exit_info_1);
+		if (!exit_info_2)
+			report(exit_info_2 == insn.exit_info_2,
+			"Expected exit_info_2: 0x%lx, received exit_info_2: 0x%lx",
+			exit_info_2, insn.exit_info_2);
+
+		vmcb->control.intercept &= ~(1 << insn.flag);
+	}
+}
+
 /* TODO: verify if high 32-bits are sign- or zero-extended on bare metal */
 #define	TEST_BITMAP_ADDR(save_intercept, type, addr, exit_code,		\
 			 msg) {						\
@@ -3564,6 +3683,7 @@ struct svm_test svm_tests[] = {
 	TEST(svm_tsc_scale_test),
 	TEST(pause_filter_test),
 	TEST(svm_shutdown_intercept_test),
+	TEST(insn_intercept_test),
 	{ NULL, NULL, NULL, NULL, NULL, NULL, NULL }
 };
 
-- 
2.51.0.261.g7ce5a0a67e-goog


