Return-Path: <kvm+bounces-26054-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 0592396FEC6
	for <lists+kvm@lfdr.de>; Sat,  7 Sep 2024 02:55:16 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 882211F22B2F
	for <lists+kvm@lfdr.de>; Sat,  7 Sep 2024 00:55:15 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7529D12B8B;
	Sat,  7 Sep 2024 00:54:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Yi50GdrZ"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B24B1A95E
	for <kvm@vger.kernel.org>; Sat,  7 Sep 2024 00:54:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725670491; cv=none; b=EvgkDshE9GSsYGjOGRHmsVT40NRX+WkL+x54unRy+Hi6Iy1gL3lEKzZIHujYdTSPnD0J5R+IxyDekvaZL5HZf3QAwsM2bsqKB26MaJj8seQbxyNEisT8/2SvAwcSn+ueR6OOTbzjCf8YT86dVvIcWCdzCCkEnp4ySXfPXVmZF4k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725670491; c=relaxed/simple;
	bh=keUjaZS1E4JmSd2wqzoiYjUV+Cluk2k4s/L75vUHkwI=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=L6ZXcP0u9F1+AxKi1iZIwnqAq0U0f0itpkpogW1msoMimFdemsTjJGXKTUGEaeykkW4RB3CIDroG5+vHMBQV04HmobgX5g72sLX1e97rxwLQRGgvIgkhd3OIo+gNdoGFY7OZXxWVqhMG/h1YwMBwsbh295do8hi6tj13FcAj7yg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=Yi50GdrZ; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1725670488;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=H1i+WYeL0K3IZGrZjYeKsMzO6yl/hkrAy/65CwXy8es=;
	b=Yi50GdrZuur/XB2qAYUQBa9IrOzSuB65V/1I0DqwPovbfQIAWfiYm8ugd9q2uRtMJF1u50
	hr36sROr3eATlkpoS2BoHdG2IC3nGVRms+E4+N4cBPoLpkenuRAW0FiobfdkBoyOidJdHp
	vm3lxTdoPnbpm2WaQOJfgVEf3WF5brM=
Received: from mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-76-PKP83PpdMUezs6zYya0s0Q-1; Fri,
 06 Sep 2024 20:54:47 -0400
X-MC-Unique: PKP83PpdMUezs6zYya0s0Q-1
Received: from mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.12])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 763FD195608B
	for <kvm@vger.kernel.org>; Sat,  7 Sep 2024 00:54:46 +0000 (UTC)
Received: from starship.lan (unknown [10.22.65.51])
	by mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 7425719560AF;
	Sat,  7 Sep 2024 00:54:45 +0000 (UTC)
From: Maxim Levitsky <mlevitsk@redhat.com>
To: kvm@vger.kernel.org
Cc: Paolo Bonzini <pbonzini@redhat.com>,
	Maxim Levitsky <mlevitsk@redhat.com>
Subject: [kvm-unit-tests PATCH 4/5] Add a test for writing canonical values to various msrs and fields
Date: Fri,  6 Sep 2024 20:54:39 -0400
Message-Id: <20240907005440.500075-5-mlevitsk@redhat.com>
In-Reply-To: <20240907005440.500075-1-mlevitsk@redhat.com>
References: <20240907005440.500075-1-mlevitsk@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.12

Add a test that thoroughly tests the canonical checks
that are done when setting various msrs and cpu registers,
especially on CPUs that support 5 level paging.

Signed-off-by: Maxim Levitsky <mlevitsk@redhat.com>
---
 lib/x86/msr.h       |  42 ++++++
 lib/x86/processor.h |   6 +-
 x86/Makefile.x86_64 |   1 +
 x86/canonical_57.c  | 346 ++++++++++++++++++++++++++++++++++++++++++++
 4 files changed, 394 insertions(+), 1 deletion(-)
 create mode 100644 x86/canonical_57.c

diff --git a/lib/x86/msr.h b/lib/x86/msr.h
index 8abccf867..658d237fd 100644
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
index bb54ec610..f05175af5 100644
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
diff --git a/x86/Makefile.x86_64 b/x86/Makefile.x86_64
index 2771a6fad..0a7eb2c34 100644
--- a/x86/Makefile.x86_64
+++ b/x86/Makefile.x86_64
@@ -38,6 +38,7 @@ tests += $(TEST_DIR)/rdpru.$(exe)
 tests += $(TEST_DIR)/pks.$(exe)
 tests += $(TEST_DIR)/pmu_lbr.$(exe)
 tests += $(TEST_DIR)/pmu_pebs.$(exe)
+tests += $(TEST_DIR)/canonical_57.$(exe)
 
 ifeq ($(CONFIG_EFI),y)
 tests += $(TEST_DIR)/amd_sev.$(exe)
diff --git a/x86/canonical_57.c b/x86/canonical_57.c
new file mode 100644
index 000000000..a2f2438b5
--- /dev/null
+++ b/x86/canonical_57.c
@@ -0,0 +1,346 @@
+#include "libcflat.h"
+#include "apic.h"
+#include "processor.h"
+#include "msr.h"
+#include "x86/vm.h"
+#include "asm/setup.h"
+
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
+
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
+	u64 old_value, expected_value;
+	bool success, test_passed = false;
+	int test_mode = (force_emulation ? SET_REGISTER_MODE_FEP : SET_REGISTER_MODE_SAFE);
+
+	old_value = get_test_register_value(test_register);
+	expected_value = expect_success ? test_value : old_value;
+
+	/*
+	 * TODO: Successful write to the MSR_GS_BASE corrupts it,
+	 * and that breaks the wrmsr_safe macro.
+	 */
+	if ((test_register >> 32) == MSR_GS_BASE && expect_success)
+		test_mode = SET_REGISTER_MODE_UNSAFE;
+
+	/* Write the test value*/
+	success =  set_test_register_value(test_register, test_mode, test_value);
+
+	if (success != expect_success) {
+		report(false,
+		       "Write of test register %s with value %lx unexpectedly %s",
+		       register_name, test_value,
+		       (success ? "succeeded" : "failed"));
+		goto exit;
+	}
+
+	/*
+	 * Check that the value was really written.
+	 * Don't test TR and LDTR, because it's not possible to read them
+	 * directly.
+	 */
+
+	if (test_register != TEST_REGISTER_TR_BASE &&
+	    test_register != TEST_REGISTER_LDT_BASE) {
+		u64 new_value = get_test_register_value(test_register);
+
+		if (new_value != expected_value) {
+			report(false,
+			       "Register %s wasn't set to %lx as expected (actual value %lx)",
+			       register_name, expected_value, new_value);
+			goto exit;
+		}
+	}
+
+	/*
+	 * Restore the old value directly without safety wrapper,
+	 * to avoid test crashes related to temporary clobbered GDT/IDT/etc bases.
+	 */
+
+	set_test_register_value(test_register, SET_REGISTER_MODE_UNSAFE, old_value);
+	test_passed = true;
+exit:
+	report(test_passed, "Tested setting %s to 0x%lx value - %s", register_name,
+	       test_value, success ? "success" : "failure");
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
+#define TEST_REGISTER(register_name, force_emulation) \
+		      test_register(#register_name, register_name, force_emulation)
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
+
+	assert(write_cr4_safe(read_cr4() | X86_CR4_PCIDE) == 0);
+
+	__test_invpcid(CANONICAL_48_VAL, true);
+	__test_invpcid(CANONICAL_57_VAL, this_cpu_has(X86_FEATURE_LA57));
+	__test_invpcid(NONCANONICAL, false);
+}
+
+static void __do_test(bool force_emulation)
+{
+	/* Direct DT addresses */
+	TEST_REGISTER(TEST_REGISTER_GDTR_BASE, force_emulation);
+	TEST_REGISTER(TEST_REGISTER_IDTR_BASE, force_emulation);
+
+	/* Indirect DT addresses */
+	TEST_REGISTER(TEST_REGISTER_TR_BASE, force_emulation);
+	TEST_REGISTER(TEST_REGISTER_LDT_BASE, force_emulation);
+
+	/* x86_64 extended segment bases */
+	TEST_MSR(MSR_FS_BASE, force_emulation);
+	TEST_MSR(MSR_GS_BASE, force_emulation);
+	TEST_MSR(MSR_KERNEL_GS_BASE, force_emulation);
+
+	/*
+	 * SYSENTER ESP/EIP MSRs have canonical checks only on Intel,
+	 * because only on Intel these instructions were extended to 64 bit.
+	 *
+	 * TODO: KVM emulation however ignores canonical checks for these MSRs
+	 * even on Intel, to support cross-vendor migration.
+	 *
+	 * Thus only run the check on bare metal.
+	 *
+	 */
+	if (is_intel() && !force_emulation) {
+		TEST_MSR(MSR_IA32_SYSENTER_ESP, force_emulation);
+		TEST_MSR(MSR_IA32_SYSENTER_EIP, force_emulation);
+	} else
+		report_skip("skipping MSR_IA32_SYSENTER_ESP/MSR_IA32_SYSENTER_EIP %s",
+			    (is_intel() ? "due to known errata in KVM": "due to AMD host"));
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
+	} else
+		report_skip("Skipping MSR_IA32_RTIT_ADDR* - Intel PT is not supported");
+
+	/* Test that INVPCID type 0 #GPs correctly */
+	if (this_cpu_has(X86_FEATURE_INVPCID))
+		test_invpcid();
+	else
+		report_skip("Skipping INVPCID - not supported");
+}
+
+static void do_test(void)
+{
+	printf("\n");
+	printf("Running the test without emulation:\n");
+	__do_test(false);
+
+	printf("\n");
+
+	if (is_fep_available()) {
+		printf("Running the test with forced emulation:\n");
+		__do_test(true);
+	} else
+		report_skip("force emulation prefix not enabled - skipping");
+}
+
+int main(int ac, char **av)
+{
+	/* set dummy LDTR pointer */
+	set_gdt_entry(FIRST_SPARE_SEL, 0xffaabb, 0xffff, 0x82, 0);
+	lldt(FIRST_SPARE_SEL);
+
+	do_test();
+
+	printf("\n");
+
+	if (this_cpu_has(X86_FEATURE_LA57)) {
+		printf("Switching to 5 level paging mode and rerunning the test...\n");
+		setup_5level_page_table();
+		do_test();
+	} else
+		report_skip("Skipping the test in 5-level paging mode - not supported on the host");
+
+	return report_summary();
+}
-- 
2.26.3


