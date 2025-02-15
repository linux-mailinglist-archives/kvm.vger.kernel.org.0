Return-Path: <kvm+bounces-38252-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id D6D56A36B02
	for <lists+kvm@lfdr.de>; Sat, 15 Feb 2025 02:30:55 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 31AD93B1F8A
	for <lists+kvm@lfdr.de>; Sat, 15 Feb 2025 01:30:46 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 06F45156669;
	Sat, 15 Feb 2025 01:30:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="fI9Z1DOb"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com [209.85.216.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5314B5103F
	for <kvm@vger.kernel.org>; Sat, 15 Feb 2025 01:30:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739583031; cv=none; b=bTU6ql8D7NC5R0fAeDbkD2q4yvnfH0Mlj5iPXNFwVKyTWUbsYaJJNOP2KRIzQETHWkTBDNw2EE1rF96xAiHS3DlTKJpmWsocGAI6CikgoMlUm/qc0oajhl9sp/mZ+NcNatW+2/k6IL/p054rBJnGYBdUYPTcKJE0pU4xIzcrfpE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739583031; c=relaxed/simple;
	bh=mwz5QcwW9jgOSBKmmQD/+HauyGrfkwfJrF+CkxGAzws=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=B6iZmX2kEu+5UgyEhWneKV8YIRGGyhlzXD9PQkyDNdWohB6Xz03K7R7e8FH68Samanqg+r6brKsu3ctVafpp3Ad+WCk/Hvd+DlPDFta+cY9NGuBa7R6OHqKXAyBX9enZHmzNkVR2YiFX1pYdql4O6qxp7NkthPHz1kag+bn/UhE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=fI9Z1DOb; arc=none smtp.client-ip=209.85.216.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f74.google.com with SMTP id 98e67ed59e1d1-2fc404aaed5so1019202a91.3
        for <kvm@vger.kernel.org>; Fri, 14 Feb 2025 17:30:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1739583029; x=1740187829; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=y2g/OmxUsvKV+8oequFLjqUZQ69y0ZK14wwkZI8Rs1I=;
        b=fI9Z1DObP5kUB8RjRQDMOpeOwk4v2hvcmw1eax6FloEDy1nE+zoRXbFfoJKvwntVV5
         cmrTInwky7CU+UBMh76qX3yaYUxvWYM5o7Tt/Bb+H9R5J38ueU6u6ioHSzZMTpNxCSAw
         3/FJ4VffmyymYm13lZCkMbc+a7cWXCr5WYCiuTLdnqPewUCJEemWk9jQq8wtsHBejPQK
         n6xg7aNsUx23eNq2ADtmzr8JWeYQeKPLJhZCceLDZsK2iqfy3THvCr7/ZY6YATi9Fd6S
         xDtu870nUMfJOqrMI1jKAV2zEZmfQrBSTcIACaOh6gj+2IHv1klzpQzbmAUosYMUa6xx
         xs1Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1739583029; x=1740187829;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=y2g/OmxUsvKV+8oequFLjqUZQ69y0ZK14wwkZI8Rs1I=;
        b=cguUhf8azuajO2DK0sz8f91WGLIZvuwuPAiVywcIeqc0RrE/7j19ZMJVENPLnMB0KX
         7rPoAtW7USt1CQGMlQE41vPKZa1zpY0Klja9VJDREi/4yl6RpB44hX/zEik8wzsOFFxj
         cFCYPer+TVoTE4f6boFUxQYU3p3c704ADQGZN2b+4CT+qsWhEohuhqnHpM3JfjZ9xxEQ
         GnXfvTMnQzU6lbSlkUjvBDcaV+ETibmVJOPOGnP7cb0m4+IDqe0FhzL7Xakq+NFhkScU
         Chct6vH4oNg5J+0kAEprJbmOIAHa8BAu6VVC5fjvI6jvKDVMFhV1PhVwzD78JOKNodw2
         wD5w==
X-Gm-Message-State: AOJu0YwZRdYh63mpO6GwMwWT0yrD8msTp8AdrcazuHSr+9tkq4YtHe6u
	oYsIT0LU0vSROttbEQcHGP8j0igecmg1F3KXUXG22JHaHpVRZGQLrW9dAEeJdJsoS7tJhjxIgDy
	YcA==
X-Google-Smtp-Source: AGHT+IHtTpfJ5lNbMPEiZ87Cpm67I2edlxTJj8FnJXgUKzpzCIACvJ0/ZAdo93zuN81ZbJG7MwmiLa3tdfM=
X-Received: from pjf15.prod.google.com ([2002:a17:90b:3f0f:b0:2f4:465d:5c61])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:3ec5:b0:2f6:be57:49d2
 with SMTP id 98e67ed59e1d1-2fc40f22cefmr2309354a91.17.1739583028892; Fri, 14
 Feb 2025 17:30:28 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Fri, 14 Feb 2025 17:30:17 -0800
In-Reply-To: <20250215013018.1210432-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250215013018.1210432-1-seanjc@google.com>
X-Mailer: git-send-email 2.48.1.601.g30ceb7b040-goog
Message-ID: <20250215013018.1210432-6-seanjc@google.com>
Subject: [kvm-unit-tests PATCH v2 5/6] x86: Add testcases for writing
 (non)canonical LA57 values to MSRs and bases
From: Sean Christopherson <seanjc@google.com>
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, Maxim Levitsky <mlevitsk@redhat.com>, 
	Sean Christopherson <seanjc@google.com>
Content-Type: text/plain; charset="UTF-8"

From: Maxim Levitsky <mlevitsk@redhat.com>

Extend the LA57 test to thoroughly validate the canonical checks that are
done when setting various MSRs and CPU registers.  CPUs that support LA57
have convoluted behavior when it comes to canonical checks.  Writes to
MSRs, descriptor table bases, and for TLB invalidation instructions,
don't consult CR4.LA57, and so a value that is 57-bit canonical but not
48-bit canonical is allowed irrespective of CR4.LA57 if the CPU supports
5-level paging.

Signed-off-by: Maxim Levitsky <mlevitsk@redhat.com>
Link: https://lore.kernel.org/r/20240907005440.500075-5-mlevitsk@redhat.com
Co-developed-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 lib/x86/msr.h       |  42 ++++++
 lib/x86/processor.h |   6 +-
 x86/la57.c          | 333 +++++++++++++++++++++++++++++++++++++++++++-
 3 files changed, 379 insertions(+), 2 deletions(-)

diff --git a/lib/x86/msr.h b/lib/x86/msr.h
index 8abccf86..658d237f 100644
--- a/lib/x86/msr.h
+++ b/lib/x86/msr.h
@@ -131,6 +131,48 @@
 #define MSR_P6_EVNTSEL0			0x00000186
 #define MSR_P6_EVNTSEL1			0x00000187
 
+#define MSR_IA32_RTIT_CTL		0x00000570
+#define RTIT_CTL_TRACEEN		BIT(0)
+#define RTIT_CTL_CYCLEACC		BIT(1)
+#define RTIT_CTL_OS			BIT(2)
+#define RTIT_CTL_USR			BIT(3)
+#define RTIT_CTL_PWR_EVT_EN		BIT(4)
+#define RTIT_CTL_FUP_ON_PTW		BIT(5)
+#define RTIT_CTL_FABRIC_EN		BIT(6)
+#define RTIT_CTL_CR3EN			BIT(7)
+#define RTIT_CTL_TOPA			BIT(8)
+#define RTIT_CTL_MTC_EN			BIT(9)
+#define RTIT_CTL_TSC_EN			BIT(10)
+#define RTIT_CTL_DISRETC		BIT(11)
+#define RTIT_CTL_PTW_EN			BIT(12)
+#define RTIT_CTL_BRANCH_EN		BIT(13)
+#define RTIT_CTL_EVENT_EN		BIT(31)
+#define RTIT_CTL_NOTNT			BIT_ULL(55)
+#define RTIT_CTL_MTC_RANGE_OFFSET	14
+#define RTIT_CTL_MTC_RANGE		(0x0full << RTIT_CTL_MTC_RANGE_OFFSET)
+#define RTIT_CTL_CYC_THRESH_OFFSET	19
+#define RTIT_CTL_CYC_THRESH		(0x0full << RTIT_CTL_CYC_THRESH_OFFSET)
+#define RTIT_CTL_PSB_FREQ_OFFSET	24
+#define RTIT_CTL_PSB_FREQ		(0x0full << RTIT_CTL_PSB_FREQ_OFFSET)
+#define RTIT_CTL_ADDR0_OFFSET		32
+#define RTIT_CTL_ADDR0			(0x0full << RTIT_CTL_ADDR0_OFFSET)
+#define RTIT_CTL_ADDR1_OFFSET		36
+#define RTIT_CTL_ADDR1			(0x0full << RTIT_CTL_ADDR1_OFFSET)
+#define RTIT_CTL_ADDR2_OFFSET		40
+#define RTIT_CTL_ADDR2			(0x0full << RTIT_CTL_ADDR2_OFFSET)
+#define RTIT_CTL_ADDR3_OFFSET		44
+#define RTIT_CTL_ADDR3			(0x0full << RTIT_CTL_ADDR3_OFFSET)
+
+
+#define MSR_IA32_RTIT_ADDR0_A		0x00000580
+#define MSR_IA32_RTIT_ADDR0_B		0x00000581
+#define MSR_IA32_RTIT_ADDR1_A		0x00000582
+#define MSR_IA32_RTIT_ADDR1_B		0x00000583
+#define MSR_IA32_RTIT_ADDR2_A		0x00000584
+#define MSR_IA32_RTIT_ADDR2_B		0x00000585
+#define MSR_IA32_RTIT_ADDR3_A		0x00000586
+#define MSR_IA32_RTIT_ADDR3_B		0x00000587
+
 /* AMD64 MSRs. Not complete. See the architecture manual for a more
    complete list. */
 
diff --git a/lib/x86/processor.h b/lib/x86/processor.h
index bb54ec61..f05175af 100644
--- a/lib/x86/processor.h
+++ b/lib/x86/processor.h
@@ -7,7 +7,9 @@
 #include <bitops.h>
 #include <stdint.h>
 
-#define NONCANONICAL	0xaaaaaaaaaaaaaaaaull
+#define CANONICAL_48_VAL 0xffffaaaaaaaaaaaaull
+#define CANONICAL_57_VAL 0xffaaaaaaaaaaaaaaull
+#define NONCANONICAL	 0xaaaaaaaaaaaaaaaaull
 
 #ifdef __x86_64__
 #  define R "r"
@@ -241,6 +243,7 @@ static inline bool is_intel(void)
 #define	X86_FEATURE_MCE			(CPUID(0x1, 0, EDX, 7))
 #define	X86_FEATURE_APIC		(CPUID(0x1, 0, EDX, 9))
 #define	X86_FEATURE_CLFLUSH		(CPUID(0x1, 0, EDX, 19))
+#define	X86_FEATURE_DS			(CPUID(0x1, 0, EDX, 21))
 #define	X86_FEATURE_XMM			(CPUID(0x1, 0, EDX, 25))
 #define	X86_FEATURE_XMM2		(CPUID(0x1, 0, EDX, 26))
 #define	X86_FEATURE_TSC_ADJUST		(CPUID(0x7, 0, EBX, 1))
@@ -252,6 +255,7 @@ static inline bool is_intel(void)
 #define	X86_FEATURE_PCOMMIT		(CPUID(0x7, 0, EBX, 22))
 #define	X86_FEATURE_CLFLUSHOPT		(CPUID(0x7, 0, EBX, 23))
 #define	X86_FEATURE_CLWB		(CPUID(0x7, 0, EBX, 24))
+#define X86_FEATURE_INTEL_PT		(CPUID(0x7, 0, EBX, 25))
 #define	X86_FEATURE_UMIP		(CPUID(0x7, 0, ECX, 2))
 #define	X86_FEATURE_PKU			(CPUID(0x7, 0, ECX, 3))
 #define	X86_FEATURE_LA57		(CPUID(0x7, 0, ECX, 16))
diff --git a/x86/la57.c b/x86/la57.c
index aff35ead..41764110 100644
--- a/x86/la57.c
+++ b/x86/la57.c
@@ -1,6 +1,324 @@
 #include "libcflat.h"
+#include "apic.h"
 #include "processor.h"
-#include "desc.h"
+#include "msr.h"
+#include "x86/vm.h"
+#include "asm/setup.h"
+
+#ifdef __x86_64__
+enum TEST_REGISTER {
+	TEST_REGISTER_GDTR_BASE,
+	TEST_REGISTER_IDTR_BASE,
+	TEST_REGISTER_TR_BASE,
+	TEST_REGISTER_LDT_BASE,
+	TEST_REGISTER_MSR /* upper 32 bits = msr address */
+};
+
+static u64 get_test_register_value(u64 test_register)
+{
+	struct descriptor_table_ptr dt_ptr;
+	u32 msr = test_register >> 32;
+
+	/*
+	 * Note: value for LDT and TSS base might not reflect the actual base
+	 * that the CPU currently uses, because the (hidden) base value can't be
+	 * directly read.
+	 */
+	switch ((u32)test_register) {
+	case TEST_REGISTER_GDTR_BASE:
+		sgdt(&dt_ptr);
+		return  dt_ptr.base;
+	case TEST_REGISTER_IDTR_BASE:
+		sidt(&dt_ptr);
+		return dt_ptr.base;
+	case TEST_REGISTER_TR_BASE:
+		return get_gdt_entry_base(get_tss_descr());
+	case TEST_REGISTER_LDT_BASE:
+		return get_gdt_entry_base(get_ldt_descr());
+	case TEST_REGISTER_MSR:
+		return rdmsr(msr);
+	default:
+		assert(0);
+		return 0;
+	}
+}
+
+enum SET_REGISTER_MODE {
+	SET_REGISTER_MODE_UNSAFE,
+	SET_REGISTER_MODE_SAFE,
+	SET_REGISTER_MODE_FEP,
+};
+
+static bool set_test_register_value(u64 test_register, int test_mode, u64 value)
+{
+	struct descriptor_table_ptr dt_ptr;
+	u32 msr = test_register >> 32;
+	u16 sel;
+
+	switch ((u32)test_register) {
+	case TEST_REGISTER_GDTR_BASE:
+		sgdt(&dt_ptr);
+		dt_ptr.base = value;
+
+		switch (test_mode) {
+		case SET_REGISTER_MODE_UNSAFE:
+			lgdt(&dt_ptr);
+			return true;
+		case SET_REGISTER_MODE_SAFE:
+			return lgdt_safe(&dt_ptr) == 0;
+		case SET_REGISTER_MODE_FEP:
+			return lgdt_fep_safe(&dt_ptr) == 0;
+		}
+	case TEST_REGISTER_IDTR_BASE:
+		sidt(&dt_ptr);
+		dt_ptr.base = value;
+
+		switch (test_mode) {
+		case SET_REGISTER_MODE_UNSAFE:
+			lidt(&dt_ptr);
+			return true;
+		case SET_REGISTER_MODE_SAFE:
+			return lidt_safe(&dt_ptr) == 0;
+		case SET_REGISTER_MODE_FEP:
+			return lidt_fep_safe(&dt_ptr) == 0;
+		}
+	case TEST_REGISTER_TR_BASE:
+		sel = str();
+		set_gdt_entry_base(sel, value);
+		clear_tss_busy(sel);
+
+		switch (test_mode) {
+		case SET_REGISTER_MODE_UNSAFE:
+			ltr(sel);
+			return true;
+		case SET_REGISTER_MODE_SAFE:
+			return ltr_safe(sel) == 0;
+		case SET_REGISTER_MODE_FEP:
+			return ltr_fep_safe(sel) == 0;
+		}
+
+	case TEST_REGISTER_LDT_BASE:
+		sel = sldt();
+		set_gdt_entry_base(sel, value);
+
+		switch (test_mode) {
+		case SET_REGISTER_MODE_UNSAFE:
+			lldt(sel);
+			return true;
+		case SET_REGISTER_MODE_SAFE:
+			return lldt_safe(sel) == 0;
+		case SET_REGISTER_MODE_FEP:
+			return lldt_fep_safe(sel) == 0;
+		}
+	case TEST_REGISTER_MSR:
+		switch (test_mode) {
+		case SET_REGISTER_MODE_UNSAFE:
+			wrmsr(msr, value);
+			return true;
+		case SET_REGISTER_MODE_SAFE:
+			return wrmsr_safe(msr, value) == 0;
+		case SET_REGISTER_MODE_FEP:
+			return wrmsr_fep_safe(msr, value) == 0;
+		}
+	default:
+		assert(false);
+		return 0;
+	}
+}
+
+static void test_register_write(const char *register_name, u64 test_register,
+				bool force_emulation, u64 test_value,
+				bool expect_success)
+{
+	int test_mode = (force_emulation ? SET_REGISTER_MODE_FEP : SET_REGISTER_MODE_SAFE);
+	u64 old_value, expected_value;
+	bool success;
+
+	old_value = get_test_register_value(test_register);
+	expected_value = expect_success ? test_value : old_value;
+
+	/*
+	 * TODO: A successful write to the MSR_GS_BASE corrupts it, and that
+	 * breaks the wrmsr_safe macro (it uses GS for per-CPU data).
+	 */
+	if ((test_register >> 32) == MSR_GS_BASE && expect_success)
+		test_mode = SET_REGISTER_MODE_UNSAFE;
+
+	/* Write the test value*/
+	success = set_test_register_value(test_register, test_mode, test_value);
+	report(success == expect_success,
+	       "Write to %s with value %lx did %s%s as expected",
+	       register_name, test_value,
+	       success == expect_success ? "" : "NOT ",
+	       (expect_success ? "succeed" : "fail"));
+
+	/*
+	 * Check that the value was really written.  Don't test TR and LDTR,
+	 * because it's not possible to read them directly.
+	 */
+	if (success == expect_success &&
+	    test_register != TEST_REGISTER_TR_BASE &&
+	    test_register != TEST_REGISTER_LDT_BASE) {
+		u64 new_value = get_test_register_value(test_register);
+
+		report(new_value == expected_value,
+		       "%s set to %lx as expected (actual value %lx)",
+		       register_name, expected_value, new_value);
+	}
+
+
+	/*
+	 * Restore the old value directly without safety wrapper, to avoid test
+	 * crashes related to temporary clobbered GDT/IDT/etc bases.
+	 */
+	set_test_register_value(test_register, SET_REGISTER_MODE_UNSAFE, old_value);
+}
+
+static void test_register(const char *register_name, u64 test_register,
+			  bool force_emulation)
+{
+	/* Canonical 48 bit value should always succeed */
+	test_register_write(register_name, test_register, force_emulation,
+			    CANONICAL_48_VAL, true);
+
+	/* 57-canonical value will work on CPUs that *support* LA57 */
+	test_register_write(register_name, test_register, force_emulation,
+			    CANONICAL_57_VAL, this_cpu_has(X86_FEATURE_LA57));
+
+	/* Non 57 canonical value should never work */
+	test_register_write(register_name, test_register, force_emulation,
+			    NONCANONICAL, false);
+}
+
+
+#define TEST_REGISTER(name, force_emulation) \
+		      test_register(#name, TEST_REGISTER_ ##name, force_emulation)
+
+#define __TEST_MSR(msr_name, address, force_emulation) \
+		   test_register(msr_name, ((u64)TEST_REGISTER_MSR |  \
+		   ((u64)(address) << 32)), force_emulation)
+
+#define TEST_MSR(msr_name, force_emulation) \
+	__TEST_MSR(#msr_name, msr_name, force_emulation)
+
+static void __test_invpcid(u64 test_value, bool expect_success)
+{
+	struct invpcid_desc desc;
+
+	memset(&desc, 0, sizeof(desc));
+	bool success;
+
+	desc.addr = test_value;
+	desc.pcid = 10; /* Arbitrary number*/
+
+	success = invpcid_safe(0, &desc) == 0;
+
+	report(success == expect_success,
+	       "Tested invpcid type 0 with 0x%lx value - %s",
+	       test_value, success ? "success" : "failure");
+}
+
+static void test_invpcid(void)
+{
+	/*
+	 * Note that this test tests the kvm's behavior only when ept=0.
+	 * Otherwise invpcid is not intercepted.
+	 *
+	 * Also KVM's x86 emulator doesn't support invpcid, thus testing invpcid
+	 * with FEP is pointless.
+	 */
+	assert(write_cr4_safe(read_cr4() | X86_CR4_PCIDE) == 0);
+
+	__test_invpcid(CANONICAL_48_VAL, true);
+	__test_invpcid(CANONICAL_57_VAL, this_cpu_has(X86_FEATURE_LA57));
+	__test_invpcid(NONCANONICAL, false);
+}
+
+static void __test_canonical_checks(bool force_emulation)
+{
+	printf("\nRunning canonical test %s forced emulation:\n",
+	       force_emulation ? "with" : "without");
+
+	/* Direct DT addresses */
+	TEST_REGISTER(GDTR_BASE, force_emulation);
+	TEST_REGISTER(IDTR_BASE, force_emulation);
+
+	/* Indirect DT addresses */
+	TEST_REGISTER(TR_BASE, force_emulation);
+	TEST_REGISTER(LDT_BASE, force_emulation);
+
+	/* x86_64 extended segment bases */
+	TEST_MSR(MSR_FS_BASE, force_emulation);
+	TEST_MSR(MSR_GS_BASE, force_emulation);
+	TEST_MSR(MSR_KERNEL_GS_BASE, force_emulation);
+
+	/*
+	 * SYSENTER ESP/EIP MSRs have canonical checks only on Intel, because
+	 * only on Intel these instructions were extended to 64 bit.
+	 *
+	 * KVM emulation however ignores canonical checks for these MSRs, even
+	 * on Intel, to support cross-vendor migration.  This includes nested
+	 * virtualization.
+	 *
+	 * Thus, the checks only work when run on bare metal, without forced
+	 * emulation.  Unfortunately, there is no foolproof way to detect bare
+	 * metal from within this test.  E.g. checking HYPERVISOR in CPUID is
+	 * useless because that only detects if _this_ code is running in a VM,
+	 * it doesn't detect if the "host" is itself a VM.
+	 *
+	 * TODO: Enable testing of SYSENTER MSRs on bare metal.
+	 */
+	if (false && is_intel() && !force_emulation) {
+		TEST_MSR(MSR_IA32_SYSENTER_ESP, force_emulation);
+		TEST_MSR(MSR_IA32_SYSENTER_EIP, force_emulation);
+	} else {
+		report_skip("skipping MSR_IA32_SYSENTER_ESP/MSR_IA32_SYSENTER_EIP %s",
+			    (is_intel() ? "due to known errata in KVM" : "due to AMD host"));
+	}
+
+	/*  SYSCALL target MSRs */
+	TEST_MSR(MSR_CSTAR, force_emulation);
+	TEST_MSR(MSR_LSTAR, force_emulation);
+
+	/* PEBS DS area */
+	if (this_cpu_has(X86_FEATURE_DS))
+		TEST_MSR(MSR_IA32_DS_AREA, force_emulation);
+	else
+		report_skip("Skipping MSR_IA32_DS_AREA - PEBS not supported");
+
+	/* PT filter ranges */
+	if (this_cpu_has(X86_FEATURE_INTEL_PT)) {
+		int n_ranges = cpuid_indexed(0x14, 0x1).a & 0x7;
+		int i;
+
+		for (i = 0 ; i < n_ranges ; i++) {
+			wrmsr(MSR_IA32_RTIT_CTL, (1ull << (RTIT_CTL_ADDR0_OFFSET+i*4)));
+			__TEST_MSR("MSR_IA32_RTIT_ADDR_A",
+				   MSR_IA32_RTIT_ADDR0_A + i*2, force_emulation);
+			__TEST_MSR("MSR_IA32_RTIT_ADDR_B",
+				   MSR_IA32_RTIT_ADDR0_B + i*2, force_emulation);
+		}
+	} else {
+		report_skip("Skipping MSR_IA32_RTIT_ADDR* - Intel PT is not supported");
+	}
+
+	/* Test that INVPCID type 0 #GPs correctly */
+	if (this_cpu_has(X86_FEATURE_INVPCID))
+		test_invpcid();
+	else
+		report_skip("Skipping INVPCID - not supported");
+}
+
+static void test_canonical_checks(void)
+{
+	__test_canonical_checks(false);
+
+	if (is_fep_available())
+		__test_canonical_checks(true);
+	else
+		report_skip("Force emulation prefix not enabled");
+}
+#endif
 
 int main(int ac, char **av)
 {
@@ -12,5 +330,18 @@ int main(int ac, char **av)
 	       expected ? "#GP" : "No fault",
 	       this_cpu_has(X86_FEATURE_LA57) ? "un" : "", is_64bit ? 64 : 32);
 
+#ifdef __x86_64__
+	/* set dummy LDTR pointer */
+	set_gdt_entry(FIRST_SPARE_SEL, 0xffaabb, 0xffff, 0x82, 0);
+	lldt(FIRST_SPARE_SEL);
+
+	test_canonical_checks();
+
+	if (is_64bit && this_cpu_has(X86_FEATURE_LA57)) {
+		printf("Switching to 5 level paging mode and rerunning canonical tests.\n");
+		setup_5level_page_table();
+	}
+#endif
+
 	return report_summary();
 }
-- 
2.48.1.601.g30ceb7b040-goog


