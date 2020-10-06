Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5081928539A
	for <lists+kvm@lfdr.de>; Tue,  6 Oct 2020 23:05:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727420AbgJFVFF (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 6 Oct 2020 17:05:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40250 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727413AbgJFVFE (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 6 Oct 2020 17:05:04 -0400
Received: from mail-pl1-x649.google.com (mail-pl1-x649.google.com [IPv6:2607:f8b0:4864:20::649])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5FE4EC061755
        for <kvm@vger.kernel.org>; Tue,  6 Oct 2020 14:05:04 -0700 (PDT)
Received: by mail-pl1-x649.google.com with SMTP id y18so2044039pll.22
        for <kvm@vger.kernel.org>; Tue, 06 Oct 2020 14:05:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=sender:date:in-reply-to:message-id:mime-version:references:subject
         :from:to:cc;
        bh=E4oDEpoy/X0OLVKh2R4Pl8Zyrh7BaryRPzdga7SKS1w=;
        b=ttMDKov/9evw6mce5q8irAhR8Wb9qrIakDe9FfLzy1CKoHmKigEuSKUmDFZmaxdrgJ
         58Z+ilDLqVHquhsDcy+RwVSbYpW9lkXHJFWqanZLApqC4jL0yVhnFNR3CGlhPJTs4jIf
         TJeMww0fCrard0akupElkUScQvPzR5lU/bVo8VScIOoxs5NHM85EQ3v9OFPKhjkg58tL
         adascrelo1HJ3a6eRG1XKbSKmOUfpUVY6q427LZvuwVMN6f8BDHy9NN+qNHTYpDvSK7h
         ZuFPSBL4HWKilPrTXv8nt7s/dxFQUzTwhiMGnb9VKBUMpBN3h9gUiOcqV7Jki/046YWO
         BU6A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=E4oDEpoy/X0OLVKh2R4Pl8Zyrh7BaryRPzdga7SKS1w=;
        b=M071h+8NZ08gMb4Dvn+9L4Ab+T5UzlRJBj6EtkOao/JrAIObca6SoM4wAHPwBHcpo0
         RbtT4e4L/UKCtJe0wZXoKR4AH+DZtQB9GuF+C73Nz/7nXiFKzla2qrn6POKFeFX19MRl
         MGtvJxSg9XgQp9IXByHYqxQbUU65THxPkccpX3UmX5e4S/8eVJuK/4DjYiafxSnsCdhU
         BEFvcs0FzQ8ZT14/NW6cy728bBTu2vTo3zwQwqRaxzKvgji6S33tOKgT2MV/lHbPcMaI
         zVHD5gJZeXt7XczOvvtEK9g86tBBPVyQo05BFMrW8Ng/iaTjByzoIQBSCZtKZkcvX4lk
         R+Rg==
X-Gm-Message-State: AOAM530goKHKDsAQeXoVsAuV6n+JUsfuVw3LpHhbZYqP/lKDf9xqqSCK
        dTpwhZz0nv+S5rP8C6UWNj+XpLHmwvMGgoqA
X-Google-Smtp-Source: ABdhPJxrPrzhAW5nipQExC1Uc5x8hnBsImK9ugLZEJRP+pbrVk30dsoblxAXLAkiOLUJtqoKyCKgbb8H3mCLu09g
Sender: "aaronlewis via sendgmr" <aaronlewis@aaronlewis1.sea.corp.google.com>
X-Received: from aaronlewis1.sea.corp.google.com ([2620:15c:100:202:a28c:fdff:fed8:8d46])
 (user=aaronlewis job=sendgmr) by 2002:a62:54c4:0:b029:142:2501:34d3 with SMTP
 id i187-20020a6254c40000b0290142250134d3mr6507487pfb.44.1602018303695; Tue,
 06 Oct 2020 14:05:03 -0700 (PDT)
Date:   Tue,  6 Oct 2020 14:04:44 -0700
In-Reply-To: <20201006210444.1342641-1-aaronlewis@google.com>
Message-Id: <20201006210444.1342641-5-aaronlewis@google.com>
Mime-Version: 1.0
References: <20201006210444.1342641-1-aaronlewis@google.com>
X-Mailer: git-send-email 2.28.0.806.g8561365e88-goog
Subject: [PATCH 4/4] selftests: kvm: Test MSR exiting to userspace
From:   Aaron Lewis <aaronlewis@google.com>
To:     graf@amazon.com
Cc:     pshier@google.com, jmattson@google.com, kvm@vger.kernel.org,
        Aaron Lewis <aaronlewis@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Add a selftest to test that when the ioctl KVM_X86_SET_MSR_FILTER is
called with an MSR list, those MSRs exit to userspace.

This test uses 3 MSRs to test this:
  1. MSR_IA32_XSS, an MSR the kernel knows about.
  2. MSR_IA32_FLUSH_CMD, an MSR the kernel does not know about.
  3. MSR_NON_EXISTENT, an MSR invented in this test for the purposes of
     passing a fake MSR from the guest to userspace.  KVM just acts as a
     pass through.

Userspace is also able to inject a #GP.  This is demonstrated when
MSR_IA32_XSS and MSR_IA32_FLUSH_CMD are misused in the test.  When this
happens a #GP is initiated in userspace to be thrown in the guest which is
handled gracefully by the expection handling framework introduced earlier
in this series.

Tests for the generic instruction emulator were also added.  For this to
work the module parameter kvm.force_emulation_prefix=1 has to be enabled.
If it isn't enabled the tests will be skipped.

A test was also added to ensure the MSR permission bitmap is being set
correctly by executing reads and writes of MSR_FS_BASE and MSR_GS_BASE
in the guest while alternating which MSR userspace should intercept.  If
the permission bitmap is being set correctly only one of the MSRs should
be coming through at a time, and the guest should be able to read and
write the other one directly.

Signed-off-by: Aaron Lewis <aaronlewis@google.com>
---
 tools/testing/selftests/kvm/.gitignore        |   1 +
 tools/testing/selftests/kvm/Makefile          |   1 +
 tools/testing/selftests/kvm/lib/kvm_util.c    |   2 +
 .../kvm/x86_64/userspace_msr_exit_test.c      | 560 ++++++++++++++++++
 4 files changed, 564 insertions(+)
 create mode 100644 tools/testing/selftests/kvm/x86_64/userspace_msr_exit_test.c

diff --git a/tools/testing/selftests/kvm/.gitignore b/tools/testing/selftests/kvm/.gitignore
index 307ceaadbbb9..30686fbb8b9f 100644
--- a/tools/testing/selftests/kvm/.gitignore
+++ b/tools/testing/selftests/kvm/.gitignore
@@ -15,6 +15,7 @@
 /x86_64/vmx_preemption_timer_test
 /x86_64/svm_vmcall_test
 /x86_64/sync_regs_test
+/x86_64/userspace_msr_exit_test
 /x86_64/vmx_close_while_nested_test
 /x86_64/vmx_dirty_log_test
 /x86_64/vmx_set_nested_state_test
diff --git a/tools/testing/selftests/kvm/Makefile b/tools/testing/selftests/kvm/Makefile
index aaaf992faf87..7acc14d06ba8 100644
--- a/tools/testing/selftests/kvm/Makefile
+++ b/tools/testing/selftests/kvm/Makefile
@@ -49,6 +49,7 @@ TEST_GEN_PROGS_x86_64 += x86_64/state_test
 TEST_GEN_PROGS_x86_64 += x86_64/vmx_preemption_timer_test
 TEST_GEN_PROGS_x86_64 += x86_64/svm_vmcall_test
 TEST_GEN_PROGS_x86_64 += x86_64/sync_regs_test
+TEST_GEN_PROGS_x86_64 += x86_64/userspace_msr_exit_test
 TEST_GEN_PROGS_x86_64 += x86_64/vmx_close_while_nested_test
 TEST_GEN_PROGS_x86_64 += x86_64/vmx_dirty_log_test
 TEST_GEN_PROGS_x86_64 += x86_64/vmx_set_nested_state_test
diff --git a/tools/testing/selftests/kvm/lib/kvm_util.c b/tools/testing/selftests/kvm/lib/kvm_util.c
index 9eed3fc21c39..f8dde1cdbef0 100644
--- a/tools/testing/selftests/kvm/lib/kvm_util.c
+++ b/tools/testing/selftests/kvm/lib/kvm_util.c
@@ -1605,6 +1605,8 @@ static struct exit_reason {
 	{KVM_EXIT_INTERNAL_ERROR, "INTERNAL_ERROR"},
 	{KVM_EXIT_OSI, "OSI"},
 	{KVM_EXIT_PAPR_HCALL, "PAPR_HCALL"},
+	{KVM_EXIT_X86_RDMSR, "RDMSR"},
+	{KVM_EXIT_X86_WRMSR, "WRMSR"},
 #ifdef KVM_EXIT_MEMORY_NOT_PRESENT
 	{KVM_EXIT_MEMORY_NOT_PRESENT, "MEMORY_NOT_PRESENT"},
 #endif
diff --git a/tools/testing/selftests/kvm/x86_64/userspace_msr_exit_test.c b/tools/testing/selftests/kvm/x86_64/userspace_msr_exit_test.c
new file mode 100644
index 000000000000..e8b6918cdea0
--- /dev/null
+++ b/tools/testing/selftests/kvm/x86_64/userspace_msr_exit_test.c
@@ -0,0 +1,560 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * Copyright (C) 2020, Google LLC.
+ *
+ * Tests for exiting into userspace on registered MSRs
+ */
+
+#define _GNU_SOURCE /* for program_invocation_short_name */
+#include <sys/ioctl.h>
+
+#include "test_util.h"
+#include "kvm_util.h"
+#include "vmx.h"
+
+/* Forced emulation prefix, used to invoke the emulator unconditionally. */
+#define KVM_FEP "ud2; .byte 'k', 'v', 'm';"
+#define KVM_FEP_LENGTH 5
+static int fep_available = 1;
+
+#define VCPU_ID	      1
+#define MSR_NON_EXISTENT 0x474f4f00
+
+u64 deny_bits = 0;
+struct kvm_msr_filter filter = {
+	.flags = KVM_MSR_FILTER_DEFAULT_ALLOW,
+	.ranges = {
+		{
+			.flags = KVM_MSR_FILTER_READ |
+				 KVM_MSR_FILTER_WRITE,
+			.nmsrs = 1,
+			/* Test an MSR the kernel knows about. */
+			.base = MSR_IA32_XSS,
+			.bitmap = (uint8_t*)&deny_bits,
+		}, {
+			.flags = KVM_MSR_FILTER_READ |
+				 KVM_MSR_FILTER_WRITE,
+			.nmsrs = 1,
+			/* Test an MSR the kernel doesn't know about. */
+			.base = MSR_IA32_FLUSH_CMD,
+			.bitmap = (uint8_t*)&deny_bits,
+		}, {
+			.flags = KVM_MSR_FILTER_READ |
+				 KVM_MSR_FILTER_WRITE,
+			.nmsrs = 1,
+			/* Test a fabricated MSR that no one knows about. */
+			.base = MSR_NON_EXISTENT,
+			.bitmap = (uint8_t*)&deny_bits,
+		},
+	},
+};
+
+struct kvm_msr_filter filter_fs = {
+	.flags = KVM_MSR_FILTER_DEFAULT_ALLOW,
+	.ranges = {
+		{
+			.flags = KVM_MSR_FILTER_READ |
+				 KVM_MSR_FILTER_WRITE,
+			.nmsrs = 1,
+			.base = MSR_FS_BASE,
+			.bitmap = (uint8_t*)&deny_bits,
+		},
+	},
+};
+
+struct kvm_msr_filter filter_gs = {
+	.flags = KVM_MSR_FILTER_DEFAULT_ALLOW,
+	.ranges = {
+		{
+			.flags = KVM_MSR_FILTER_READ |
+				 KVM_MSR_FILTER_WRITE,
+			.nmsrs = 1,
+			.base = MSR_GS_BASE,
+			.bitmap = (uint8_t*)&deny_bits,
+		},
+	},
+};
+
+uint64_t msr_non_existent_data;
+int guest_exception_count;
+
+/*
+ * Note: Force test_rdmsr() to not be inlined to prevent the labels,
+ * rdmsr_start and rdmsr_end, from being defined multiple times.
+ */
+static noinline uint64_t test_rdmsr(uint32_t msr)
+{
+	uint32_t a, d;
+
+	guest_exception_count = 0;
+
+	__asm__ __volatile__("rdmsr_start: rdmsr; rdmsr_end:" :
+			"=a"(a), "=d"(d) : "c"(msr) : "memory");
+
+	return a | ((uint64_t) d << 32);
+}
+
+/*
+ * Note: Force test_wrmsr() to not be inlined to prevent the labels,
+ * wrmsr_start and wrmsr_end, from being defined multiple times.
+ */
+static noinline void test_wrmsr(uint32_t msr, uint64_t value)
+{
+	uint32_t a = value;
+	uint32_t d = value >> 32;
+
+	guest_exception_count = 0;
+
+	__asm__ __volatile__("wrmsr_start: wrmsr; wrmsr_end:" ::
+			"a"(a), "d"(d), "c"(msr) : "memory");
+}
+
+extern char rdmsr_start, rdmsr_end;
+extern char wrmsr_start, wrmsr_end;
+
+/*
+ * Note: Force test_em_rdmsr() to not be inlined to prevent the labels,
+ * rdmsr_start and rdmsr_end, from being defined multiple times.
+ */
+static noinline uint64_t test_em_rdmsr(uint32_t msr)
+{
+	uint32_t a, d;
+
+	guest_exception_count = 0;
+
+	__asm__ __volatile__(KVM_FEP "em_rdmsr_start: rdmsr; em_rdmsr_end:" :
+			"=a"(a), "=d"(d) : "c"(msr) : "memory");
+
+	return a | ((uint64_t) d << 32);
+}
+
+/*
+ * Note: Force test_em_wrmsr() to not be inlined to prevent the labels,
+ * wrmsr_start and wrmsr_end, from being defined multiple times.
+ */
+static noinline void test_em_wrmsr(uint32_t msr, uint64_t value)
+{
+	uint32_t a = value;
+	uint32_t d = value >> 32;
+
+	guest_exception_count = 0;
+
+	__asm__ __volatile__(KVM_FEP "em_wrmsr_start: wrmsr; em_wrmsr_end:" ::
+			"a"(a), "d"(d), "c"(msr) : "memory");
+}
+
+extern char em_rdmsr_start, em_rdmsr_end;
+extern char em_wrmsr_start, em_wrmsr_end;
+
+static void guest_code(void)
+{
+	uint64_t data;
+
+	/*
+	 * Test userspace intercepting rdmsr / wrmsr for MSR_IA32_XSS.
+	 *
+	 * A GP is thrown if anything other than 0 is written to
+	 * MSR_IA32_XSS.
+	 */
+	data = test_rdmsr(MSR_IA32_XSS);
+	GUEST_ASSERT(data == 0);
+	GUEST_ASSERT(guest_exception_count == 0);
+
+	test_wrmsr(MSR_IA32_XSS, 0);
+	GUEST_ASSERT(guest_exception_count == 0);
+
+	test_wrmsr(MSR_IA32_XSS, 1);
+	GUEST_ASSERT(guest_exception_count == 1);
+
+	/*
+	 * Test userspace intercepting rdmsr / wrmsr for MSR_IA32_FLUSH_CMD.
+	 *
+	 * A GP is thrown if MSR_IA32_FLUSH_CMD is read
+	 * from or if a value other than 1 is written to it.
+	 */
+	test_rdmsr(MSR_IA32_FLUSH_CMD);
+	GUEST_ASSERT(guest_exception_count == 1);
+
+	test_wrmsr(MSR_IA32_FLUSH_CMD, 0);
+	GUEST_ASSERT(guest_exception_count == 1);
+
+	test_wrmsr(MSR_IA32_FLUSH_CMD, 1);
+	GUEST_ASSERT(guest_exception_count == 0);
+
+	/*
+	 * Test userspace intercepting rdmsr / wrmsr for MSR_NON_EXISTENT.
+	 *
+	 * Test that a fabricated MSR can pass through the kernel
+	 * and be handled in userspace.
+	 */
+	test_wrmsr(MSR_NON_EXISTENT, 2);
+	GUEST_ASSERT(guest_exception_count == 0);
+
+	data = test_rdmsr(MSR_NON_EXISTENT);
+	GUEST_ASSERT(data == 2);
+	GUEST_ASSERT(guest_exception_count == 0);
+
+	/*
+	 * Test to see if the instruction emulator is available (ie: the module
+	 * parameter 'kvm.force_emulation_prefix=1' is set).  This instruction
+	 * will #UD if it isn't available.
+	 */
+	__asm__ __volatile__(KVM_FEP "nop");
+
+	if (fep_available) {
+		/* Let userspace know we aren't done. */
+		GUEST_SYNC(0);
+
+		/*
+		 * Now run the same tests with the instruction emulator.
+		 */
+		data = test_em_rdmsr(MSR_IA32_XSS);
+		GUEST_ASSERT(data == 0);
+		GUEST_ASSERT(guest_exception_count == 0);
+		test_em_wrmsr(MSR_IA32_XSS, 0);
+		GUEST_ASSERT(guest_exception_count == 0);
+		test_em_wrmsr(MSR_IA32_XSS, 1);
+		GUEST_ASSERT(guest_exception_count == 1);
+
+		test_em_rdmsr(MSR_IA32_FLUSH_CMD);
+		GUEST_ASSERT(guest_exception_count == 1);
+		test_em_wrmsr(MSR_IA32_FLUSH_CMD, 0);
+		GUEST_ASSERT(guest_exception_count == 1);
+		test_em_wrmsr(MSR_IA32_FLUSH_CMD, 1);
+		GUEST_ASSERT(guest_exception_count == 0);
+
+		test_em_wrmsr(MSR_NON_EXISTENT, 2);
+		GUEST_ASSERT(guest_exception_count == 0);
+		data = test_em_rdmsr(MSR_NON_EXISTENT);
+		GUEST_ASSERT(data == 2);
+		GUEST_ASSERT(guest_exception_count == 0);
+	}
+
+	GUEST_DONE();
+}
+
+
+static void guest_code_permission_bitmap(void)
+{
+	uint64_t data;
+
+	test_wrmsr(MSR_FS_BASE, 0);
+	data = test_rdmsr(MSR_FS_BASE);
+	GUEST_ASSERT(data == MSR_FS_BASE);
+
+	test_wrmsr(MSR_GS_BASE, 0);
+	data = test_rdmsr(MSR_GS_BASE);
+	GUEST_ASSERT(data == 0);
+
+	/* Let userspace know to switch the filter */
+	GUEST_SYNC(0);
+
+	test_wrmsr(MSR_FS_BASE, 0);
+	data = test_rdmsr(MSR_FS_BASE);
+	GUEST_ASSERT(data == 0);
+
+	test_wrmsr(MSR_GS_BASE, 0);
+	data = test_rdmsr(MSR_GS_BASE);
+	GUEST_ASSERT(data == MSR_GS_BASE);
+
+	GUEST_DONE();
+}
+
+static void __guest_gp_handler(struct ex_regs *regs,
+			       char *r_start, char *r_end,
+			       char *w_start, char *w_end)
+{
+	if (regs->rip == (uintptr_t)r_start) {
+		regs->rip = (uintptr_t)r_end;
+		regs->rax = 0;
+		regs->rdx = 0;
+	} else if (regs->rip == (uintptr_t)w_start) {
+		regs->rip = (uintptr_t)w_end;
+	} else {
+		GUEST_ASSERT(!"RIP is at an unknown location!");
+	}
+
+	++guest_exception_count;
+}
+
+static void guest_gp_handler(struct ex_regs *regs)
+{
+	__guest_gp_handler(regs, &rdmsr_start, &rdmsr_end,
+			   &wrmsr_start, &wrmsr_end);
+}
+
+static void guest_fep_gp_handler(struct ex_regs *regs)
+{
+	__guest_gp_handler(regs, &em_rdmsr_start, &em_rdmsr_end,
+			   &em_wrmsr_start, &em_wrmsr_end);
+}
+
+static void guest_ud_handler(struct ex_regs *regs)
+{
+	fep_available = 0;
+	regs->rip += KVM_FEP_LENGTH;
+}
+
+static void run_guest(struct kvm_vm *vm)
+{
+	int rc;
+
+	rc = _vcpu_run(vm, VCPU_ID);
+	TEST_ASSERT(rc == 0, "vcpu_run failed: %d\n", rc);
+}
+
+static void check_for_guest_assert(struct kvm_vm *vm)
+{
+	struct kvm_run *run = vcpu_state(vm, VCPU_ID);
+	struct ucall uc;
+
+	if (run->exit_reason == KVM_EXIT_IO &&
+		get_ucall(vm, VCPU_ID, &uc) == UCALL_ABORT) {
+			TEST_FAIL("%s at %s:%ld", (const char *)uc.args[0],
+				__FILE__, uc.args[1]);
+	}
+}
+
+static void process_rdmsr(struct kvm_vm *vm, uint32_t msr_index)
+{
+	struct kvm_run *run = vcpu_state(vm, VCPU_ID);
+
+	check_for_guest_assert(vm);
+
+	TEST_ASSERT(run->exit_reason == KVM_EXIT_X86_RDMSR,
+		    "Unexpected exit reason: %u (%s),\n",
+		    run->exit_reason,
+		    exit_reason_str(run->exit_reason));
+	TEST_ASSERT(run->msr.index == msr_index,
+			"Unexpected msr (0x%04x), expected 0x%04x",
+			run->msr.index, msr_index);
+
+	switch (run->msr.index) {
+	case MSR_IA32_XSS:
+		run->msr.data = 0;
+		break;
+	case MSR_IA32_FLUSH_CMD:
+		run->msr.error = 1;
+		break;
+	case MSR_NON_EXISTENT:
+		run->msr.data = msr_non_existent_data;
+		break;
+	case MSR_FS_BASE:
+		run->msr.data = MSR_FS_BASE;
+		break;
+	case MSR_GS_BASE:
+		run->msr.data = MSR_GS_BASE;
+		break;
+	default:
+		TEST_ASSERT(false, "Unexpected MSR: 0x%04x", run->msr.index);
+	}
+}
+
+static void process_wrmsr(struct kvm_vm *vm, uint32_t msr_index)
+{
+	struct kvm_run *run = vcpu_state(vm, VCPU_ID);
+
+	check_for_guest_assert(vm);
+
+	TEST_ASSERT(run->exit_reason == KVM_EXIT_X86_WRMSR,
+		    "Unexpected exit reason: %u (%s),\n",
+		    run->exit_reason,
+		    exit_reason_str(run->exit_reason));
+	TEST_ASSERT(run->msr.index == msr_index,
+			"Unexpected msr (0x%04x), expected 0x%04x",
+			run->msr.index, msr_index);
+
+	switch (run->msr.index) {
+	case MSR_IA32_XSS:
+		if (run->msr.data != 0)
+			run->msr.error = 1;
+		break;
+	case MSR_IA32_FLUSH_CMD:
+		if (run->msr.data != 1)
+			run->msr.error = 1;
+		break;
+	case MSR_NON_EXISTENT:
+		msr_non_existent_data = run->msr.data;
+		break;
+	case MSR_FS_BASE:
+	case MSR_GS_BASE:
+		break;
+	default:
+		TEST_ASSERT(false, "Unexpected MSR: 0x%04x", run->msr.index);
+	}
+}
+
+static void process_ucall_done(struct kvm_vm *vm)
+{
+	struct kvm_run *run = vcpu_state(vm, VCPU_ID);
+	struct ucall uc;
+
+	check_for_guest_assert(vm);
+
+	TEST_ASSERT(run->exit_reason == KVM_EXIT_IO,
+		    "Unexpected exit reason: %u (%s)",
+		    run->exit_reason,
+		    exit_reason_str(run->exit_reason));
+
+	TEST_ASSERT(get_ucall(vm, VCPU_ID, &uc) == UCALL_DONE,
+		    "Unexpected ucall command: %lu, expected UCALL_DONE (%d)",
+		    uc.cmd, UCALL_DONE);
+}
+
+static uint64_t process_ucall(struct kvm_vm *vm)
+{
+	struct kvm_run *run = vcpu_state(vm, VCPU_ID);
+	struct ucall uc = {};
+
+	check_for_guest_assert(vm);
+
+	TEST_ASSERT(run->exit_reason == KVM_EXIT_IO,
+		    "Unexpected exit reason: %u (%s)",
+		    run->exit_reason,
+		    exit_reason_str(run->exit_reason));
+
+	switch (get_ucall(vm, VCPU_ID, &uc)) {
+	case UCALL_SYNC:
+		break;
+	case UCALL_ABORT:
+		check_for_guest_assert(vm);
+		break;
+	case UCALL_DONE:
+		process_ucall_done(vm);
+		break;
+	default:
+		TEST_ASSERT(false, "Unexpected ucall");
+	}
+
+	return uc.cmd;
+}
+
+static void run_guest_then_process_rdmsr(struct kvm_vm *vm, uint32_t msr_index)
+{
+	run_guest(vm);
+	process_rdmsr(vm, msr_index);
+}
+
+static void run_guest_then_process_wrmsr(struct kvm_vm *vm, uint32_t msr_index)
+{
+	run_guest(vm);
+	process_wrmsr(vm, msr_index);
+}
+
+static uint64_t run_guest_then_process_ucall(struct kvm_vm *vm)
+{
+	run_guest(vm);
+	return process_ucall(vm);
+}
+
+static void run_guest_then_process_ucall_done(struct kvm_vm *vm)
+{
+	run_guest(vm);
+	process_ucall_done(vm);
+}
+
+static void test_msr_filter(void) {
+	struct kvm_enable_cap cap = {
+		.cap = KVM_CAP_X86_USER_SPACE_MSR,
+		.args[0] = KVM_MSR_EXIT_REASON_FILTER,
+	};
+	struct kvm_vm *vm;
+	int rc;
+
+	/* Create VM */
+	vm = vm_create_default(VCPU_ID, 0, guest_code);
+	vcpu_set_cpuid(vm, VCPU_ID, kvm_get_supported_cpuid());
+
+	rc = kvm_check_cap(KVM_CAP_X86_USER_SPACE_MSR);
+	TEST_ASSERT(rc, "KVM_CAP_X86_USER_SPACE_MSR is available");
+	vm_enable_cap(vm, &cap);
+
+	rc = kvm_check_cap(KVM_CAP_X86_MSR_FILTER);
+	TEST_ASSERT(rc, "KVM_CAP_X86_MSR_FILTER is available");
+
+	vm_ioctl(vm, KVM_X86_SET_MSR_FILTER, &filter);
+
+	vm_init_descriptor_tables(vm);
+	vcpu_init_descriptor_tables(vm, VCPU_ID);
+
+	vm_handle_exception(vm, GP_VECTOR, guest_gp_handler);
+
+	/* Process guest code userspace exits. */
+	run_guest_then_process_rdmsr(vm, MSR_IA32_XSS);
+	run_guest_then_process_wrmsr(vm, MSR_IA32_XSS);
+	run_guest_then_process_wrmsr(vm, MSR_IA32_XSS);
+
+	run_guest_then_process_rdmsr(vm, MSR_IA32_FLUSH_CMD);
+	run_guest_then_process_wrmsr(vm, MSR_IA32_FLUSH_CMD);
+	run_guest_then_process_wrmsr(vm, MSR_IA32_FLUSH_CMD);
+
+	run_guest_then_process_wrmsr(vm, MSR_NON_EXISTENT);
+	run_guest_then_process_rdmsr(vm, MSR_NON_EXISTENT);
+
+	vm_handle_exception(vm, UD_VECTOR, guest_ud_handler);
+	run_guest(vm);
+	vm_handle_exception(vm, UD_VECTOR, NULL);
+
+	if (process_ucall(vm) != UCALL_DONE) {
+		vm_handle_exception(vm, GP_VECTOR, guest_fep_gp_handler);
+
+		/* Process emulated rdmsr and wrmsr instructions. */
+		run_guest_then_process_rdmsr(vm, MSR_IA32_XSS);
+		run_guest_then_process_wrmsr(vm, MSR_IA32_XSS);
+		run_guest_then_process_wrmsr(vm, MSR_IA32_XSS);
+
+		run_guest_then_process_rdmsr(vm, MSR_IA32_FLUSH_CMD);
+		run_guest_then_process_wrmsr(vm, MSR_IA32_FLUSH_CMD);
+		run_guest_then_process_wrmsr(vm, MSR_IA32_FLUSH_CMD);
+
+		run_guest_then_process_wrmsr(vm, MSR_NON_EXISTENT);
+		run_guest_then_process_rdmsr(vm, MSR_NON_EXISTENT);
+
+		/* Confirm the guest completed without issues. */
+		run_guest_then_process_ucall_done(vm);
+	} else {
+		printf("To run the instruction emulated tests set the module parameter 'kvm.force_emulation_prefix=1'\n");
+	}
+
+	kvm_vm_free(vm);
+}
+
+static void test_msr_permission_bitmap(void) {
+	struct kvm_enable_cap cap = {
+		.cap = KVM_CAP_X86_USER_SPACE_MSR,
+		.args[0] = KVM_MSR_EXIT_REASON_FILTER,
+	};
+	struct kvm_vm *vm;
+	int rc;
+
+	/* Create VM */
+	vm = vm_create_default(VCPU_ID, 0, guest_code_permission_bitmap);
+	vcpu_set_cpuid(vm, VCPU_ID, kvm_get_supported_cpuid());
+
+	rc = kvm_check_cap(KVM_CAP_X86_USER_SPACE_MSR);
+	TEST_ASSERT(rc, "KVM_CAP_X86_USER_SPACE_MSR is available");
+	vm_enable_cap(vm, &cap);
+
+	rc = kvm_check_cap(KVM_CAP_X86_MSR_FILTER);
+	TEST_ASSERT(rc, "KVM_CAP_X86_MSR_FILTER is available");
+
+	vm_ioctl(vm, KVM_X86_SET_MSR_FILTER, &filter_fs);
+	run_guest_then_process_wrmsr(vm, MSR_FS_BASE);
+	run_guest_then_process_rdmsr(vm, MSR_FS_BASE);
+	TEST_ASSERT(run_guest_then_process_ucall(vm) == UCALL_SYNC, "Expected ucall state to be UCALL_SYNC.");
+	vm_ioctl(vm, KVM_X86_SET_MSR_FILTER, &filter_gs);
+	run_guest_then_process_wrmsr(vm, MSR_GS_BASE);
+	run_guest_then_process_rdmsr(vm, MSR_GS_BASE);
+	run_guest_then_process_ucall_done(vm);
+
+	kvm_vm_free(vm);
+}
+
+int main(int argc, char *argv[])
+{
+	test_msr_filter();
+
+	test_msr_permission_bitmap();
+
+	return 0;
+}
-- 
2.28.0.806.g8561365e88-goog

