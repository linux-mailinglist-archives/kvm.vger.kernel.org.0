Return-Path: <kvm+bounces-67886-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sin.lore.kernel.org (sin.lore.kernel.org [IPv6:2600:3c15:e001:75::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 4E49FD160B0
	for <lists+kvm@lfdr.de>; Tue, 13 Jan 2026 01:35:29 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sin.lore.kernel.org (Postfix) with ESMTP id 2A14C3027BC9
	for <lists+kvm@lfdr.de>; Tue, 13 Jan 2026 00:32:42 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3B0C0280A56;
	Tue, 13 Jan 2026 00:32:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="dSiDu/mi"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f73.google.com (mail-pj1-f73.google.com [209.85.216.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E9B48231858
	for <kvm@vger.kernel.org>; Tue, 13 Jan 2026 00:32:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768264328; cv=none; b=Da/I8NG8NLa3BWYNm9DzuRg5PPf2zQ6p9Q6nJhYLnhh0p/BcMpL/3vth+BsKMm27suZkYBQTvSQlEM1V+Jj0zfKmHsU/+yLCt+FDfX1F/qJpYCd2XuGz1a/9gdTo0u8cD9D9A1WJewALG/KminylyZxrwxDPg3CytiwRG8HtxZU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768264328; c=relaxed/simple;
	bh=LFb8PJaZ7O48/gpsKEeRcky6ijgEfca1s/bblGJCDic=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=mNRfy/HSO/xNliY4a02SLpzWoYIf6qZcNlD/LBUAMaRchktGrsmtUDnb/BwAIFktNbgpM2kwGn3+3xa57stlTEKucr2K2I7A6TWoeo/KssZeMOf98gus9jAbhKSA5ROfiBQBxvKsIL7YrfdK+wJA0+80L7dwu93FGYLdvg7Ik1Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--chengkev.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=dSiDu/mi; arc=none smtp.client-ip=209.85.216.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--chengkev.bounces.google.com
Received: by mail-pj1-f73.google.com with SMTP id 98e67ed59e1d1-34ac819b2f2so6314193a91.0
        for <kvm@vger.kernel.org>; Mon, 12 Jan 2026 16:32:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1768264323; x=1768869123; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=BeIKqu9UX3wiO+X7/lEjMy9SvDjueEtdxROL1R2BZgA=;
        b=dSiDu/mi3AFupXMC6EZqu6deBPANwCFWcO/o52DylsbCDqowogYOytxP7K2GyK7ieY
         RBOd7E01NQ7NUO6WxKgS0y5COao4scm0HLAgO9qJ4s9fAmUxgWjySXALNcCfal1GH/WI
         kEn5ZnXM0j6laFET8DiTVVc1CEbxWSgeH3yNtB0wmcUW+8uZwD237TgIUg/nwSZBBqTc
         PBnTCYPYjRBdrfcc/684AtgtnVk/tjwAjEw0uWU8eWQn0OrT66OatGejDL8V9lwrGIRM
         rEIklTvJGH/LMzLNKRnAwn9++4A3UZO71QU4AxT5PNKhqpBPpxLeui4p7dqiWHKpbZho
         RyYg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768264323; x=1768869123;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=BeIKqu9UX3wiO+X7/lEjMy9SvDjueEtdxROL1R2BZgA=;
        b=udt3O4Ui5qTrQEcpjp+90M6eRreYYVbBT9VBDpgr4wbsuElmXBklHZhnBwIhVya4ai
         AVNNldUXGWynl+EI7ERoA+TxCkjOKo1Dlab7Fmu0tX+in9bCbZ6Zlq9pund4lcLp9L83
         85sdjyNeJRtFiyxfqssumOl8lrm/Y0Q9TeRK1LP+cJsjiodXkKe5XdCVqpZ1kGEP0v+s
         CkITrFdYpVppZBxr6rncWqEqMMgBAH6xDIY92jG8Eh+k/w95G9TCrjddBqCkHkaPEvVs
         9xUSuvNgyrWmMSIhcBaq2FyFLdFbMql1LitqNo0MQ1bh/+dW2huqLuyGY/qsVjVzzjR1
         nJjg==
X-Gm-Message-State: AOJu0Yy7WneuyxZNac4y3YPLfShNF5VhyQGf1+/fvMbQgnw6hbdb8Jhg
	Qt2vnSc61EPDLyN63aIFiQ/B2IhprDrCdi8BLiU7jNOmB2zbiB3YVu/18ZS8Dcg1ZOkXUqU7c1o
	KbhJHNN3nruSYT71mrqOfNaYOaL7v5lYR76ReRj4F7SQQEOfiSqwZn2t1Zw1rKzGENLkRudcGGp
	gWPcrcpCoJAxzaYlNQoC42SNmDPZq1ch917+/wYDos/q8=
X-Google-Smtp-Source: AGHT+IHAo+upLZrSkgRSv2tNVU/bo/kpfe4s+wHpXdAXQQUiVessvZks0UM/3st1tgAPcoQxm28EhMW8SOgRCw==
X-Received: from pjbjx24.prod.google.com ([2002:a17:90b:46d8:b0:34a:a1dd:9ba2])
 (user=chengkev job=prod-delivery.src-stubby-dispatcher) by
 2002:a17:90b:3d47:b0:340:bc27:97bd with SMTP id 98e67ed59e1d1-34f68b66369mr16371043a91.9.1768264323371;
 Mon, 12 Jan 2026 16:32:03 -0800 (PST)
Date: Tue, 13 Jan 2026 00:31:46 +0000
In-Reply-To: <20260113003153.3344500-1-chengkev@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20260113003153.3344500-1-chengkev@google.com>
X-Mailer: git-send-email 2.52.0.457.g6b5491de43-goog
Message-ID: <20260113003153.3344500-5-chengkev@google.com>
Subject: [kvm-unit-tests PATCH V2 04/10] x86/nSVM: Add tests for instruction interrupts
From: Kevin Cheng <chengkev@google.com>
To: kvm@vger.kernel.org
Cc: yosryahmed@google.com, andrew.jones@linux.dev, thuth@redhat.com, 
	pbonzini@redhat.com, seanjc@google.com, Kevin Cheng <chengkev@google.com>
Content-Type: text/plain; charset="UTF-8"

Add test cases for instruction intercepts. Enable instruction intercepts
and check that exit codes and exit info are equal to the expected
results after running corresponding instructions in guest.

The nVMX tests already have coverage for instruction intercepts.
Add a similar test for nSVM to improve test parity between nSVM and
nVMX.

Signed-off-by: Kevin Cheng <chengkev@google.com>
---
 lib/x86/processor.h |   6 ++
 x86/svm.c           |  14 +++
 x86/svm.h           |   7 ++
 x86/svm_tests.c     | 202 ++++++++++++++++++++++++++++++++++++++++++++
 x86/unittests.cfg   |  16 +++-
 x86/vmx_tests.c     |   5 --
 6 files changed, 244 insertions(+), 6 deletions(-)

diff --git a/lib/x86/processor.h b/lib/x86/processor.h
index 42dd2d2a4787c..b073ee168ce4b 100644
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
@@ -522,6 +523,11 @@ static inline u64 this_cpu_supported_xcr0(void)
 	       ((u64)this_cpu_property(X86_PROPERTY_SUPPORTED_XCR0_HI) << 32);
 }
 
+static inline bool this_cpu_has_mwait(void)
+{
+	return this_cpu_has(X86_FEATURE_MWAIT);
+}
+
 struct far_pointer32 {
 	u32 offset;
 	u16 selector;
diff --git a/x86/svm.c b/x86/svm.c
index de9eb19443caa..014feae3b48cc 100644
--- a/x86/svm.c
+++ b/x86/svm.c
@@ -83,6 +83,20 @@ bool pause_threshold_supported(void)
 	return this_cpu_has(X86_FEATURE_PFTHRESHOLD);
 }
 
+bool rdpru_supported(void)
+{
+	return this_cpu_has(X86_FEATURE_RDPRU);
+}
+
+bool skinit_supported(void)
+{
+	return this_cpu_has(X86_FEATURE_SKINIT);
+}
+
+bool xsave_supported(void)
+{
+	return this_cpu_has(X86_FEATURE_XSAVE);
+}
 
 void default_prepare(struct svm_test *test)
 {
diff --git a/x86/svm.h b/x86/svm.h
index 264583a6547ef..052324c683019 100644
--- a/x86/svm.h
+++ b/x86/svm.h
@@ -49,6 +49,8 @@ enum {
 	INTERCEPT_MONITOR,
 	INTERCEPT_MWAIT,
 	INTERCEPT_MWAIT_COND,
+	INTERCEPT_XSETBV,
+	INTERCEPT_RDPRU,
 };
 
 enum {
@@ -352,6 +354,8 @@ struct __attribute__ ((__packed__)) vmcb {
 #define SVM_EXIT_MONITOR	0x08a
 #define SVM_EXIT_MWAIT		0x08b
 #define SVM_EXIT_MWAIT_COND	0x08c
+#define SVM_EXIT_XSETBV		0x08d
+#define SVM_EXIT_RDPRU		0x08e
 #define SVM_EXIT_NPF  		0x400
 
 #define SVM_EXIT_ERR		-1
@@ -423,6 +427,9 @@ bool lbrv_supported(void);
 bool tsc_scale_supported(void);
 bool pause_filter_supported(void);
 bool pause_threshold_supported(void);
+bool rdpru_supported(void);
+bool skinit_supported(void);
+bool xsave_supported(void);
 void default_prepare(struct svm_test *test);
 void default_prepare_gif_clear(struct svm_test *test);
 bool default_finished(struct svm_test *test);
diff --git a/x86/svm_tests.c b/x86/svm_tests.c
index 0eedad6bc3af5..8dbc033533c00 100644
--- a/x86/svm_tests.c
+++ b/x86/svm_tests.c
@@ -2547,6 +2547,207 @@ static void test_dr(void)
 	vmcb->save.dr7 = dr_saved;
 }
 
+asm(
+	"insn_sidt: sidt idt_descr;ret\n\t"
+	"insn_sgdt: sgdt gdt_descr;ret\n\t"
+	"insn_sldt: sldt %ax;ret\n\t"
+	"insn_str: str %ax;ret\n\t"
+	"insn_ltr: ltr %ax;ret\n\t"
+	"insn_pushf: pushf;ret\n\t"
+	"insn_popf: popf;ret\n\t"
+	"insn_intn: int $0x22; vmmcall; ret\n\t"
+	"insn_int_handler: iretq\n\t"
+	"insn_stgi: stgi;ret\n\t"
+	"insn_clgi: clgi;ret\n\t"
+	"insn_rdtscp: rdtscp;ret\n\t"
+	"insn_wbinvd: wbinvd;ret\n\t"
+	"insn_lidt: lidt idt_descr;ret\n\t"
+	"insn_lgdt: lgdt gdt_descr;ret\n\t"
+	"insn_lldt: xor %eax, %eax; lldt %ax;ret\n\t"
+	"insn_rdpmc: xor %ecx, %ecx; rdpmc;ret\n\t"
+	"insn_cpuid: mov $10, %eax; cpuid;ret\n\t"
+	"insn_invd: invd;ret\n\t"
+	"insn_pause: pause;ret\n\t"
+	"insn_hlt: hlt;ret\n\t"
+	"insn_invlpg: invlpg 0x12345678;ret\n\t"
+	"insn_rdtsc: rdtsc;ret\n\t"
+	"insn_monitor: xor %eax, %eax; xor %ecx, %ecx; xor %edx, %edx; monitor;ret\n\t"
+	"insn_mwait: xor %eax, %eax; xor %ecx, %ecx; mwait;ret\n\t"
+	"insn_skinit: skinit;ret\n\t"
+	"insn_icebp: .byte 0xf1; ret\n\t"
+	"insn_xsetbv: mov $0, %ecx; xor %edx, %edx; xor %eax, %eax; xgetbv; xsetbv;ret\n\t"
+	"insn_rdpru: xor %ecx, %ecx; .byte 0x0f,0x01,0xfd;ret\n\t"
+);
+
+extern void insn_sidt(struct svm_test *test);
+extern void insn_sgdt(struct svm_test *test);
+extern void insn_sldt(struct svm_test *test);
+extern void insn_str(struct svm_test *test);
+extern void insn_ltr(struct svm_test *test);
+extern void insn_pushf(struct svm_test *test);
+extern void insn_popf(struct svm_test *test);
+extern void insn_intn(struct svm_test *test);
+extern void insn_int_handler(struct svm_test *test);
+extern void insn_stgi(struct svm_test *test);
+extern void insn_clgi(struct svm_test *test);
+extern void insn_rdtscp(struct svm_test *test);
+extern void insn_wbinvd(struct svm_test *test);
+extern void insn_lidt(struct svm_test *test);
+extern void insn_lgdt(struct svm_test *test);
+extern void insn_lldt(struct svm_test *test);
+extern void insn_rdpmc(struct svm_test *test);
+extern void insn_cpuid(struct svm_test *test);
+extern void insn_invd(struct svm_test *test);
+extern void insn_pause(struct svm_test *test);
+extern void insn_hlt(struct svm_test *test);
+extern void insn_invlpg(struct svm_test *test);
+extern void insn_rdtsc(struct svm_test *test);
+extern void insn_monitor(struct svm_test *test);
+extern void insn_mwait(struct svm_test *test);
+extern void insn_skinit(struct svm_test *test);
+extern void insn_icebp(struct svm_test *test);
+extern void insn_xsetbv(struct svm_test *test);
+extern void insn_rdpru(struct svm_test *test);
+
+u64 orig_cr4;
+
+static void insn_intercept_xsetbv_setup(void)
+{
+	orig_cr4 = vmcb->save.cr4;
+	vmcb->save.cr4 |= X86_CR4_OSXSAVE;
+}
+
+static void insn_intercept_xsetbv_cleanup(void)
+{
+	vmcb->save.cr4 = orig_cr4;
+}
+
+static idt_entry_t old_idt_entry;
+
+static void insn_int_setup(void)
+{
+	memcpy(&old_idt_entry, &boot_idt[0x22], sizeof(idt_entry_t));
+	set_idt_entry(0x22, insn_int_handler, 0);
+}
+
+static void insn_int_cleanup(void)
+{
+	memcpy(&boot_idt[0x22], &old_idt_entry, sizeof(idt_entry_t));
+}
+
+struct insn_table {
+	const char *name;
+	u64 intercept;
+	void (*insn_func)(struct svm_test *test);
+	u32 reason;
+	u64 exit_info_1;
+	u64 exit_info_2;
+	bool corrupts_guest;
+	bool (*supported_fn)(void);
+	void (*setup)(void);
+	void (*cleanup)(void);
+};
+
+static struct insn_table insn_table[] = {
+	{ "STORE IDTR", INTERCEPT_STORE_IDTR, insn_sidt, SVM_EXIT_IDTR_READ, 0,
+	  0 },
+	{ "STORE GDTR", INTERCEPT_STORE_GDTR, insn_sgdt, SVM_EXIT_GDTR_READ, 0,
+	  0 },
+	{ "STORE LDTR", INTERCEPT_STORE_LDTR, insn_sldt, SVM_EXIT_LDTR_READ, 0,
+	  0 },
+	{ "STORE TR", INTERCEPT_STORE_TR, insn_str, SVM_EXIT_TR_READ, 0, 0 },
+	/* corrupts_guest: LTR causes a #GP if done with a busy selector */
+	{ "LOAD TR", INTERCEPT_LOAD_TR, insn_ltr, SVM_EXIT_TR_WRITE, 0, 0, true },
+	/* corrupts_guest: PUSHF and POPF corrupt the L2 stack */
+	{ "PUSHF", INTERCEPT_PUSHF, insn_pushf, SVM_EXIT_PUSHF, 0, 0, true },
+	{ "POPF", INTERCEPT_POPF, insn_popf, SVM_EXIT_POPF, 0, 0, true },
+	{ "IRET", INTERCEPT_IRET, insn_intn, SVM_EXIT_IRET, 0, 0, false,
+	  NULL, insn_int_setup, insn_int_cleanup },
+	{ "INTn", INTERCEPT_INTn, insn_intn, SVM_EXIT_SWINT, 0x22, 0, false,
+	  NULL, insn_int_setup, insn_int_cleanup },
+	{ "STGI", INTERCEPT_STGI, insn_stgi, SVM_EXIT_STGI, 0, 0 },
+	{ "CLGI", INTERCEPT_CLGI, insn_clgi, SVM_EXIT_CLGI, 0, 0 },
+	{ "RDTSCP", INTERCEPT_RDTSCP, insn_rdtscp, SVM_EXIT_RDTSCP, 0, 0 },
+	{ "WBINVD", INTERCEPT_WBINVD, insn_wbinvd, SVM_EXIT_WBINVD, 0, 0 },
+	{ "LOAD IDTR", INTERCEPT_LOAD_IDTR, insn_lidt, SVM_EXIT_IDTR_WRITE, 0,
+	  0 },
+	{ "LOAD GDTR", INTERCEPT_LOAD_GDTR, insn_lgdt, SVM_EXIT_GDTR_WRITE, 0,
+	  0 },
+	{ "LOAD LDTR", INTERCEPT_LOAD_LDTR, insn_lldt, SVM_EXIT_LDTR_WRITE, 0,
+	  0 },
+	{ "RDPMC", INTERCEPT_RDPMC, insn_rdpmc, SVM_EXIT_RDPMC, 0, 0 },
+	{ "CPUID", INTERCEPT_CPUID, insn_cpuid, SVM_EXIT_CPUID, 0, 0 },
+	{ "INVD", INTERCEPT_INVD, insn_invd, SVM_EXIT_INVD, 0, 0 },
+	{ "PAUSE", INTERCEPT_PAUSE, insn_pause, SVM_EXIT_PAUSE, 0, 0 },
+	/* corrupts_guest: HLT causes guest to hang */
+	{ "HLT", INTERCEPT_HLT, insn_hlt, SVM_EXIT_HLT, 0, 0, true },
+	{ "INVLPG", INTERCEPT_INVLPG, insn_invlpg, SVM_EXIT_INVLPG, 0x12345678, 0 },
+	{ "RDTSC", INTERCEPT_RDTSC, insn_rdtsc, SVM_EXIT_RDTSC, 0, 0 },
+	{ "MONITOR", INTERCEPT_MONITOR, insn_monitor, SVM_EXIT_MONITOR, 0, 0,
+	  false, this_cpu_has_mwait },
+	{ "MWAIT", INTERCEPT_MWAIT, insn_mwait, SVM_EXIT_MWAIT, 0, 0,
+	  false, this_cpu_has_mwait },
+	{ "SKINIT", INTERCEPT_SKINIT, insn_skinit, SVM_EXIT_SKINIT, 0, 0,
+	  false, skinit_supported },
+	/* corrupts_guest: ICEBP triggers a #DB exception */
+	{ "ICEBP", INTERCEPT_ICEBP, insn_icebp, SVM_EXIT_ICEBP, 0, 0, true },
+	{ "XSETBV", INTERCEPT_XSETBV, insn_xsetbv, SVM_EXIT_XSETBV, 0, 0,
+	  false, xsave_supported, insn_intercept_xsetbv_setup,
+	  insn_intercept_xsetbv_cleanup },
+	{ "RDPRU", INTERCEPT_RDPRU, insn_rdpru, SVM_EXIT_RDPRU, 0, 0,
+	  false, rdpru_supported },
+	{ NULL },
+};
+
+static void svm_insn_intercept_test(void)
+{
+	u64 exit_info_1;
+	u64 exit_info_2;
+	u32 exit_code;
+	u32 cur_insn;
+
+	for (cur_insn = 0; insn_table[cur_insn].name != NULL; ++cur_insn) {
+		struct insn_table insn = insn_table[cur_insn];
+
+		if (insn.supported_fn && !insn.supported_fn()) {
+			report_skip("\tFeature required for %s is not supported.\n",
+				    insn_table[cur_insn].name);
+			continue;
+		}
+
+		test_set_guest(insn.insn_func);
+
+		if (insn.setup)
+			insn.setup();
+
+		if (!insn.corrupts_guest)
+			report(svm_vmrun() == SVM_EXIT_VMMCALL, "execute %s", insn.name);
+
+		vmcb->control.intercept |= (1ULL << insn.intercept);
+		svm_vmrun();
+
+		exit_code = vmcb->control.exit_code;
+		exit_info_1 = vmcb->control.exit_info_1;
+		exit_info_2 = vmcb->control.exit_info_2;
+
+		report(exit_code == insn.reason,
+			"Expected exit code: 0x%x, received exit code: 0x%x",
+			insn.reason, exit_code);
+
+		report(exit_info_1 == insn.exit_info_1,
+		       "Expected exit_info_1: 0x%lx, received exit_info_1: 0x%lx",
+		       insn.exit_info_1, exit_info_1);
+
+		report(exit_info_2 == insn.exit_info_2,
+		       "Expected exit_info_2: 0x%lx, received exit_info_2: 0x%lx",
+		       insn.exit_info_2, exit_info_2);
+
+		if (insn.cleanup)
+			insn.cleanup();
+		vmcb->control.intercept &= ~(1 << insn.intercept);
+	}
+}
+
 /* TODO: verify if high 32-bits are sign- or zero-extended on bare metal */
 #define	TEST_BITMAP_ADDR(save_intercept, type, addr, exit_code,		\
 			 msg) {						\
@@ -3891,6 +4092,7 @@ struct svm_test svm_tests[] = {
 	TEST(svm_tsc_scale_test),
 	TEST(pause_filter_test),
 	TEST(svm_shutdown_intercept_test),
+	TEST(svm_insn_intercept_test),
 	{ NULL, NULL, NULL, NULL, NULL, NULL, NULL }
 };
 
diff --git a/x86/unittests.cfg b/x86/unittests.cfg
index 522318d32bf68..1a89101a5b2dd 100644
--- a/x86/unittests.cfg
+++ b/x86/unittests.cfg
@@ -253,7 +253,21 @@ arch = x86_64
 [svm]
 file = svm.flat
 smp = 2
-test_args = "-pause_filter_test"
+test_args = "-pause_filter_test -svm_intr_intercept_mix_smi -svm_insn_intercept_test"
+qemu_params = -cpu max,+svm -m 4g
+arch = x86_64
+groups = svm
+
+[svm_insn_intercept_test]
+file = svm.flat
+test_args = svm_insn_intercept_test
+qemu_params = -cpu max,+svm -m 4g
+arch = x86_64
+groups = svm
+
+[svm_intr_intercept_mix_smi]
+file = svm.flat
+test_args = svm_intr_intercept_mix_smi
 qemu_params = -cpu max,+svm -m 4g
 arch = x86_64
 groups = svm
diff --git a/x86/vmx_tests.c b/x86/vmx_tests.c
index 5ffb80a3d866b..aa875ef722163 100644
--- a/x86/vmx_tests.c
+++ b/x86/vmx_tests.c
@@ -855,11 +855,6 @@ u64 cr3;
 
 typedef bool (*supported_fn)(void);
 
-static bool this_cpu_has_mwait(void)
-{
-	return this_cpu_has(X86_FEATURE_MWAIT);
-}
-
 struct insn_table {
 	const char *name;
 	u32 flag;
-- 
2.52.0.457.g6b5491de43-goog


