Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AC4D6249001
	for <lists+kvm@lfdr.de>; Tue, 18 Aug 2020 23:17:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727064AbgHRVRD (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 18 Aug 2020 17:17:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59640 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726956AbgHRVQq (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 18 Aug 2020 17:16:46 -0400
Received: from mail-pg1-x54a.google.com (mail-pg1-x54a.google.com [IPv6:2607:f8b0:4864:20::54a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 074A6C061346
        for <kvm@vger.kernel.org>; Tue, 18 Aug 2020 14:16:46 -0700 (PDT)
Received: by mail-pg1-x54a.google.com with SMTP id y10so12874590pgo.6
        for <kvm@vger.kernel.org>; Tue, 18 Aug 2020 14:16:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=sender:date:in-reply-to:message-id:mime-version:references:subject
         :from:to:cc;
        bh=AqDFz7jpBTxI2gPBSN5oCl2I2sWn3WbmAXCID09eksg=;
        b=gxXh9a8V1iDeKGevH32i9UFQUt4k3qfpembzM3xYdeX5koHtZUO8/kbF8JpNFxnwyg
         DFF/yHI0tt3RYf+b9hYu7AXN9IJVOtMoWg01zjU/QbLKqpzWfIYal3un5tndl8fAeCew
         PB9DifzDqxQFeq5GFTYnDlC1dHikVRhIhWCz2BSzYnJp40Ke4U0nxrMQu1BOS5D9deI8
         iVY0dqoAJbofyqJG9tNmFmzJgEtimLc01tFNXTir7KBAlIzmvTzqAFZRYTPXsTT4Cd+Q
         OsURfqHgHa0BSig0IGBbXSe1G2OVeILHcTli2MGd+rsx935xVgJEzzL0vuUfRqkQhwSf
         pL/w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=AqDFz7jpBTxI2gPBSN5oCl2I2sWn3WbmAXCID09eksg=;
        b=nKUITlmjYSSC3/PY55rOO3ZE3l3QIvqWyhflklWQaw/Oiv4x0zfw/1iZBCCzQ13Gj/
         tw5gjpStFFH6LlPMSmewbitJAyX+lRk6iM4pAlwX3YHywqjwk3k6Gb/K4Wh97OVACUOb
         e9gtJF8xQIH7E1Bl2Fau0ViGncO4988LRnWrrSYnvetYunLgUpdC4vGMQUCrshjulj+4
         DSq/AWbGNb/t84oQGuX44AUaii2BNUKOeshW9vBqBJ1sm0eNEbUFbOo+rxxOiTgQyxVQ
         kLiMS5+2ApdvNO8UwGEAi2du1CQuOGYmXtELH9ScQkGeXhyTQEKk274BaZqUYpmQPD6k
         tniA==
X-Gm-Message-State: AOAM530EStv7fui0uN5CNbIAEzecbqbhs61OCThVRAtalswn9pvCCzuw
        AbCNKwSYfTppZxEejTd1YguAhBQXNyw1vxFL
X-Google-Smtp-Source: ABdhPJzjiHR+D6h/SPpEBy+OK/MfAinKcOg2Wb39mJhK2c7nYKidMxXNPMJBPy3WtSX8655KE8AskAPL6cLEOiz6
X-Received: from aaronlewis1.sea.corp.google.com ([2620:15c:100:202:a28c:fdff:fed8:8d46])
 (user=aaronlewis job=sendgmr) by 2002:a17:90a:6807:: with SMTP id
 p7mr1504620pjj.42.1597785405522; Tue, 18 Aug 2020 14:16:45 -0700 (PDT)
Date:   Tue, 18 Aug 2020 14:15:33 -0700
In-Reply-To: <20200818211533.849501-1-aaronlewis@google.com>
Message-Id: <20200818211533.849501-12-aaronlewis@google.com>
Mime-Version: 1.0
References: <20200818211533.849501-1-aaronlewis@google.com>
X-Mailer: git-send-email 2.28.0.220.ged08abb693-goog
Subject: [PATCH v3 11/12] selftests: kvm: Add a test to exercise the userspace
 MSR list
From:   Aaron Lewis <aaronlewis@google.com>
To:     jmattson@google.com, graf@amazon.com
Cc:     pshier@google.com, oupton@google.com, kvm@vger.kernel.org,
        Aaron Lewis <aaronlewis@google.com>
Content-Type: text/plain; charset="UTF-8"
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Add a selftest to test that when ioctl KVM_SET_EXIT_MSRS is called with
an MSR list the guest exits to the host and then to userspace when an
MSR in that list is read from or written to.

This test uses 3 MSRs to test these new features:
  1. MSR_IA32_XSS, an MSR the kernel knows about.
  2. MSR_IA32_FLUSH_CMD, an MSR the kernel does not know about.
  3. MSR_NON_EXISTENT, an MSR invented in this test for the purposes of
     passing a fake MSR from the guest to userspace and having the guest
     be able to read from and write to it, with userspace handling it.
     KVM just acts as a pass through.

Userspace is also able to inject a #GP.  This is demonstrated when
MSR_IA32_XSS and MSR_IA32_FLUSH_CMD are misused in the test.  When this
happens a #GP is initiated in userspace to be thrown in the guest.  The
#GP exception has been overridden in the test so it can be handled
gracefully.

Signed-off-by: Aaron Lewis <aaronlewis@google.com>
---

v2 -> v3

 - Simplified this change by removing exception handling support from it.
   This commit now just implements the test needed to verify the changes made
   in this series.

---
 tools/testing/selftests/kvm/.gitignore        |   1 +
 tools/testing/selftests/kvm/Makefile          |   1 +
 .../selftests/kvm/include/x86_64/processor.h  |   3 +
 tools/testing/selftests/kvm/lib/kvm_util.c    |   2 +
 .../selftests/kvm/lib/x86_64/processor.c      |  65 ++++
 .../selftests/kvm/x86_64/userspace_msr_exit.c | 279 ++++++++++++++++++
 6 files changed, 351 insertions(+)
 create mode 100644 tools/testing/selftests/kvm/x86_64/userspace_msr_exit.c

diff --git a/tools/testing/selftests/kvm/.gitignore b/tools/testing/selftests/kvm/.gitignore
index 452787152748..33619f915857 100644
--- a/tools/testing/selftests/kvm/.gitignore
+++ b/tools/testing/selftests/kvm/.gitignore
@@ -14,6 +14,7 @@
 /x86_64/vmx_preemption_timer_test
 /x86_64/svm_vmcall_test
 /x86_64/sync_regs_test
+/x86_64/userspace_msr_exit
 /x86_64/vmx_close_while_nested_test
 /x86_64/vmx_dirty_log_test
 /x86_64/vmx_set_nested_state_test
diff --git a/tools/testing/selftests/kvm/Makefile b/tools/testing/selftests/kvm/Makefile
index 6ba4f61a9765..15536d98fe02 100644
--- a/tools/testing/selftests/kvm/Makefile
+++ b/tools/testing/selftests/kvm/Makefile
@@ -49,6 +49,7 @@ TEST_GEN_PROGS_x86_64 += x86_64/state_test
 TEST_GEN_PROGS_x86_64 += x86_64/vmx_preemption_timer_test
 TEST_GEN_PROGS_x86_64 += x86_64/svm_vmcall_test
 TEST_GEN_PROGS_x86_64 += x86_64/sync_regs_test
+TEST_GEN_PROGS_x86_64 += x86_64/userspace_msr_exit
 TEST_GEN_PROGS_x86_64 += x86_64/vmx_close_while_nested_test
 TEST_GEN_PROGS_x86_64 += x86_64/vmx_dirty_log_test
 TEST_GEN_PROGS_x86_64 += x86_64/vmx_set_nested_state_test
diff --git a/tools/testing/selftests/kvm/include/x86_64/processor.h b/tools/testing/selftests/kvm/include/x86_64/processor.h
index 02530dc6339b..df3ceb1af166 100644
--- a/tools/testing/selftests/kvm/include/x86_64/processor.h
+++ b/tools/testing/selftests/kvm/include/x86_64/processor.h
@@ -341,6 +341,9 @@ int _vcpu_set_msr(struct kvm_vm *vm, uint32_t vcpuid, uint64_t msr_index,
 void vcpu_set_msr(struct kvm_vm *vm, uint32_t vcpuid, uint64_t msr_index,
 	  	  uint64_t msr_value);
 
+void kvm_set_exit_msrs(struct kvm_vm *vm, uint32_t nmsrs,
+	uint32_t msr_indices[]);
+
 uint32_t kvm_get_cpuid_max_basic(void);
 uint32_t kvm_get_cpuid_max_extended(void);
 void kvm_get_cpu_address_width(unsigned int *pa_bits, unsigned int *va_bits);
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
diff --git a/tools/testing/selftests/kvm/lib/x86_64/processor.c b/tools/testing/selftests/kvm/lib/x86_64/processor.c
index c15817b36267..7022528fd938 100644
--- a/tools/testing/selftests/kvm/lib/x86_64/processor.c
+++ b/tools/testing/selftests/kvm/lib/x86_64/processor.c
@@ -851,6 +851,71 @@ void vcpu_set_msr(struct kvm_vm *vm, uint32_t vcpuid, uint64_t msr_index,
 		"  rc: %i errno: %i", r, errno);
 }
 
+/*
+ * __KVM Set Exit MSR
+ *
+ * Input Args:
+ *   vm - Virtual Machine
+ *   nmsrs - Number of msrs in msr_indices
+ *   msr_indices[] - List of msrs.
+ *
+ * Output Args: None
+ *
+ * Return: The result of KVM_SET_EXIT_MSRS.
+ *
+ * Sets a list of MSRs that will force an exit to userspace when
+ * any of them are read from or written to by the guest.
+ */
+int __kvm_set_exit_msrs(struct kvm_vm *vm, uint32_t nmsrs,
+	uint32_t msr_indices[])
+{
+	const uint32_t max_nmsrs = 256;
+	struct kvm_msr_list *msr_list;
+	uint32_t i;
+	int r;
+
+	TEST_ASSERT(nmsrs <= max_nmsrs,
+		"'nmsrs' is too large.  Max is %u, currently %u.\n",
+		max_nmsrs, nmsrs);
+	uint32_t msr_list_byte_size = sizeof(struct kvm_msr_list) +
+							     (sizeof(msr_list->indices[0]) * nmsrs);
+	msr_list = alloca(msr_list_byte_size);
+	memset(msr_list, 0, msr_list_byte_size);
+
+	msr_list->nmsrs = nmsrs;
+	for (i = 0; i < nmsrs; i++)
+		msr_list->indices[i] = msr_indices[i];
+
+	r = ioctl(vm->fd, KVM_SET_EXIT_MSRS, msr_list);
+
+	return r;
+}
+
+/*
+ * KVM Set Exit MSR
+ *
+ * Input Args:
+ *   vm - Virtual Machine
+ *   nmsrs - Number of msrs in msr_indices
+ *   msr_indices[] - List of msrs.
+ *
+ * Output Args: None
+ *
+ * Return: None
+ *
+ * Sets a list of MSRs that will force an exit to userspace when
+ * any of them are read from or written to by the guest.
+ */
+void kvm_set_exit_msrs(struct kvm_vm *vm, uint32_t nmsrs,
+	uint32_t msr_indices[])
+{
+	int r;
+
+	r = __kvm_set_exit_msrs(vm, nmsrs, msr_indices);
+	TEST_ASSERT(r == 0, "KVM_SET_EXIT_MSRS IOCTL failed,\n"
+		"  rc: %i errno: %i", r, errno);
+}
+
 void vcpu_args_set(struct kvm_vm *vm, uint32_t vcpuid, unsigned int num, ...)
 {
 	va_list ap;
diff --git a/tools/testing/selftests/kvm/x86_64/userspace_msr_exit.c b/tools/testing/selftests/kvm/x86_64/userspace_msr_exit.c
new file mode 100644
index 000000000000..79acfe004e78
--- /dev/null
+++ b/tools/testing/selftests/kvm/x86_64/userspace_msr_exit.c
@@ -0,0 +1,279 @@
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
+#define VCPU_ID	      1
+
+#define MSR_NON_EXISTENT 0x474f4f00
+
+uint32_t msrs[] = {
+	/* Test an MSR the kernel knows about. */
+	MSR_IA32_XSS,
+	/* Test an MSR the kernel doesn't know about. */
+	MSR_IA32_FLUSH_CMD,
+	/* Test a fabricated MSR that no one knows about. */
+	MSR_NON_EXISTENT,
+};
+uint32_t nmsrs = ARRAY_SIZE(msrs);
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
+	GUEST_DONE();
+}
+
+static void guest_gp_handler(struct ex_regs *regs)
+{
+	if (regs->rip == (uintptr_t)&rdmsr_start) {
+		regs->rip = (uintptr_t)&rdmsr_end;
+		regs->rax = 0;
+		regs->rdx = 0;
+	} else if (regs->rip == (uintptr_t)&wrmsr_start) {
+		regs->rip = (uintptr_t)&wrmsr_end;
+	} else {
+		GUEST_ASSERT(!"RIP is at an unknown location!");
+	}
+
+	++guest_exception_count;
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
+static void run_guest_then_process_ucall_done(struct kvm_vm *vm)
+{
+	run_guest(vm);
+	process_ucall_done(vm);
+}
+
+int main(int argc, char *argv[])
+{
+	struct kvm_vm *vm;
+
+	vm = vm_create(VM_MODE_DEFAULT, DEFAULT_GUEST_PHY_PAGES, O_RDWR);
+	kvm_vm_elf_load(vm, program_invocation_name, 0, 0);
+	vm_create_irqchip(vm);
+
+	kvm_set_exit_msrs(vm, nmsrs, msrs);
+
+	vm_vcpu_add_default(vm, VCPU_ID, guest_code);
+
+	vm_init_descriptor_tables(vm);
+	vcpu_init_descriptor_tables(vm, VCPU_ID);
+
+	vm_handle_exception(vm, GP_VECTOR, guest_gp_handler);
+
+	/* Process guest code userspace exits */
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
+	run_guest_then_process_ucall_done(vm);
+
+	kvm_vm_free(vm);
+	return 0;
+}
-- 
2.28.0.220.ged08abb693-goog

