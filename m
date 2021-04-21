Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5CDBA366ACA
	for <lists+kvm@lfdr.de>; Wed, 21 Apr 2021 14:28:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239832AbhDUM3U (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 21 Apr 2021 08:29:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58706 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239813AbhDUM3T (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 21 Apr 2021 08:29:19 -0400
Received: from mail-yb1-xb4a.google.com (mail-yb1-xb4a.google.com [IPv6:2607:f8b0:4864:20::b4a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E33E3C06174A
        for <kvm@vger.kernel.org>; Wed, 21 Apr 2021 05:28:45 -0700 (PDT)
Received: by mail-yb1-xb4a.google.com with SMTP id v63-20020a252f420000b02904ecfc17c803so4315884ybv.18
        for <kvm@vger.kernel.org>; Wed, 21 Apr 2021 05:28:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=bjPIkYCQqSWemUhQg8ClVLineBCrI6DyIHd1NNiJanM=;
        b=uLjP8lwJHyFLavKNl/3DFId/dEfzPUb6t7+oTZDrcQNRAfTthg9FCUA9FEvygc/Vr/
         hny70xkvXr4FYQGVm6SIFr/165ScUf0dF2XPhFrbIG5Orwfhnyw7nQxtNbn7vOjvyUe2
         T4m/3gAGx6O/5LYeE1EZHyhzKpSdU2qVUHdAWMviYizMs72qlIbdjvt0DgI9+NHxqz9W
         yy5kAqTmy6T4/scwxJoMbKn1o0KfTGpJvJG6ixknjtaykYzb5uCVXXAzL4ldB/R7csR9
         skGRR4Vk1o/XFMRdyb+dmu3AT5okTn691tqQT6fYIUtSVgDV+ydQcCVuZl3/z1eti+7I
         MsVA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=bjPIkYCQqSWemUhQg8ClVLineBCrI6DyIHd1NNiJanM=;
        b=UWeiLNZSkJsoCQwDDxnKpRE9XwNZIof6xoPH6koVOp8Q6lIrmD1sD7qeNXySfyfAJo
         JsRghapEMI9Us1CRghLTORxkssf8jweYEwlQ1asNG5plNaT57My+EU4iufZZQTv0vAW6
         l563Ux0TqhpTmZLUhLt7hNjw1fvydYQynXktRFwneSPbV1wnxdNWF7xRj4mbYlrTrnwD
         h+KevCCLuQdepFz1JdzZqPhMrUh8REpWfcDnc/lr1OyTrMR5C/ugSlXFbiSSJzOOsF1Q
         Hxvukvr844QcLFt1lFrHXOe4w9TsrKSLGVz5LEeVihJBQSJ/TmvT8zzjsQ0rzaELGGtL
         Y1oA==
X-Gm-Message-State: AOAM531BrGP/cDDnIwCeI7XTgQkfNGtSjHltrkbPQBNCgqE7C6J341cK
        FIOVij/YOcsz058LlIYspUsi3rDedNqDdyb0
X-Google-Smtp-Source: ABdhPJxruS6E0e8y3W+Bt1RCA5t2vJ5tOjOVkH9zqk9RYf0hedahZ2xvCK+NBNvp1a2gmKvzRDOiE/C8yVJNm/aQ
X-Received: from aaronlewis1.sea.corp.google.com ([2620:15c:100:202:218c:70d5:29b9:db76])
 (user=aaronlewis job=sendgmr) by 2002:a25:b098:: with SMTP id
 f24mr32461385ybj.210.1619008125165; Wed, 21 Apr 2021 05:28:45 -0700 (PDT)
Date:   Wed, 21 Apr 2021 05:28:33 -0700
In-Reply-To: <20210421122833.3881993-1-aaronlewis@google.com>
Message-Id: <20210421122833.3881993-2-aaronlewis@google.com>
Mime-Version: 1.0
References: <20210421122833.3881993-1-aaronlewis@google.com>
X-Mailer: git-send-email 2.31.1.498.g6c1eba8ee3d-goog
Subject: [PATCH v2 2/2] selftests: kvm: Allows userspace to handle emulation errors.
From:   Aaron Lewis <aaronlewis@google.com>
To:     david.edmondson@oracle.com, seanjc@google.com
Cc:     jmattson@google.com, kvm@vger.kernel.org,
        Aaron Lewis <aaronlewis@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This test exercises the feature KVM_CAP_EXIT_ON_EMULATION_FAILURE.  When
enabled, errors in the in-kernel instruction emulator are forwarded to
userspace with the instruction bytes stored in the exit struct for
KVM_EXIT_INTERNAL_ERROR.  So, when the guest attempts to emulate an
'flds' instruction, which isn't able to be emulated in KVM, instead
of failing, KVM sends the instruction to userspace to handle.

For this test to work properly the module parameter
'allow_smaller_maxphyaddr' has to be set.

Signed-off-by: Aaron Lewis <aaronlewis@google.com>
---
 tools/testing/selftests/kvm/.gitignore        |   1 +
 tools/testing/selftests/kvm/Makefile          |   1 +
 .../selftests/kvm/include/x86_64/processor.h  |   3 +
 .../selftests/kvm/lib/x86_64/processor.c      |  58 +++++
 .../kvm/x86_64/emulator_error_test.c          | 209 ++++++++++++++++++
 5 files changed, 272 insertions(+)
 create mode 100644 tools/testing/selftests/kvm/x86_64/emulator_error_test.c

diff --git a/tools/testing/selftests/kvm/.gitignore b/tools/testing/selftests/kvm/.gitignore
index 7bd7e776c266..ec9e20a2f752 100644
--- a/tools/testing/selftests/kvm/.gitignore
+++ b/tools/testing/selftests/kvm/.gitignore
@@ -7,6 +7,7 @@
 /x86_64/cr4_cpuid_sync_test
 /x86_64/debug_regs
 /x86_64/evmcs_test
+/x86_64/emulator_error_test
 /x86_64/get_cpuid_test
 /x86_64/get_msr_index_features
 /x86_64/kvm_pv_test
diff --git a/tools/testing/selftests/kvm/Makefile b/tools/testing/selftests/kvm/Makefile
index 67eebb53235f..5ff705d92d02 100644
--- a/tools/testing/selftests/kvm/Makefile
+++ b/tools/testing/selftests/kvm/Makefile
@@ -41,6 +41,7 @@ LIBKVM_s390x = lib/s390x/processor.c lib/s390x/ucall.c lib/s390x/diag318_test_ha
 TEST_GEN_PROGS_x86_64 = x86_64/cr4_cpuid_sync_test
 TEST_GEN_PROGS_x86_64 += x86_64/get_msr_index_features
 TEST_GEN_PROGS_x86_64 += x86_64/evmcs_test
+TEST_GEN_PROGS_x86_64 += x86_64/emulator_error_test
 TEST_GEN_PROGS_x86_64 += x86_64/get_cpuid_test
 TEST_GEN_PROGS_x86_64 += x86_64/hyperv_clock
 TEST_GEN_PROGS_x86_64 += x86_64/hyperv_cpuid
diff --git a/tools/testing/selftests/kvm/include/x86_64/processor.h b/tools/testing/selftests/kvm/include/x86_64/processor.h
index 0b30b4e15c38..40f70f91e6a2 100644
--- a/tools/testing/selftests/kvm/include/x86_64/processor.h
+++ b/tools/testing/selftests/kvm/include/x86_64/processor.h
@@ -394,6 +394,9 @@ void vcpu_init_descriptor_tables(struct kvm_vm *vm, uint32_t vcpuid);
 void vm_handle_exception(struct kvm_vm *vm, int vector,
 			void (*handler)(struct ex_regs *));
 
+uint64_t vm_get_page_table_entry(struct kvm_vm *vm, uint64_t vaddr);
+void vm_set_page_table_entry(struct kvm_vm *vm, uint64_t vaddr, uint64_t mask);
+
 /*
  * set_cpuid() - overwrites a matching cpuid entry with the provided value.
  *		 matches based on ent->function && ent->index. returns true
diff --git a/tools/testing/selftests/kvm/lib/x86_64/processor.c b/tools/testing/selftests/kvm/lib/x86_64/processor.c
index a8906e60a108..1aa4fc5e84c6 100644
--- a/tools/testing/selftests/kvm/lib/x86_64/processor.c
+++ b/tools/testing/selftests/kvm/lib/x86_64/processor.c
@@ -292,6 +292,64 @@ void virt_pg_map(struct kvm_vm *vm, uint64_t vaddr, uint64_t paddr,
 	pte[index[0]].present = 1;
 }
 
+static struct pageTableEntry *_vm_get_page_table_entry(struct kvm_vm *vm,
+						       uint64_t vaddr)
+{
+	uint16_t index[4];
+	struct pageMapL4Entry *pml4e;
+	struct pageDirectoryPointerEntry *pdpe;
+	struct pageDirectoryEntry *pde;
+	struct pageTableEntry *pte;
+
+	TEST_ASSERT(vm->mode == VM_MODE_PXXV48_4K, "Attempt to use "
+		"unknown or unsupported guest mode, mode: 0x%x", vm->mode);
+	TEST_ASSERT((vaddr % vm->page_size) == 0,
+		"Virtual address not on page boundary,\n"
+		"  vaddr: 0x%lx vm->page_size: 0x%x",
+		vaddr, vm->page_size);
+	TEST_ASSERT(sparsebit_is_set(vm->vpages_valid,
+		(vaddr >> vm->page_shift)),
+		"Invalid virtual address, vaddr: 0x%lx",
+		vaddr);
+
+	index[0] = (vaddr >> 12) & 0x1ffu;
+	index[1] = (vaddr >> 21) & 0x1ffu;
+	index[2] = (vaddr >> 30) & 0x1ffu;
+	index[3] = (vaddr >> 39) & 0x1ffu;
+
+	pml4e = addr_gpa2hva(vm, vm->pgd);
+	TEST_ASSERT(pml4e[index[3]].present,
+		"Expected pml4e to be present for gva: 0x%08lx", vaddr);
+
+	pdpe = addr_gpa2hva(vm, pml4e[index[3]].address * vm->page_size);
+	TEST_ASSERT(pdpe[index[2]].present,
+		"Expected pdpe to be present for gva: 0x%08lx", vaddr);
+
+	pde = addr_gpa2hva(vm, pdpe[index[2]].address * vm->page_size);
+	TEST_ASSERT(pde[index[1]].present,
+		"Expected pde to be present for gva: 0x%08lx", vaddr);
+
+	pte = addr_gpa2hva(vm, pde[index[1]].address * vm->page_size);
+	TEST_ASSERT(pte[index[0]].present,
+		"Expected pte to be present for gva: 0x%08lx", vaddr);
+
+	return &pte[index[0]];
+}
+
+uint64_t vm_get_page_table_entry(struct kvm_vm *vm, uint64_t vaddr)
+{
+	struct pageTableEntry *pte = _vm_get_page_table_entry(vm, vaddr);
+
+	return *(uint64_t *)pte;
+}
+
+void vm_set_page_table_entry(struct kvm_vm *vm, uint64_t vaddr, uint64_t mask)
+{
+	struct pageTableEntry *pte = _vm_get_page_table_entry(vm, vaddr);
+
+	*(uint64_t *)pte |= mask;
+}
+
 void virt_dump(FILE *stream, struct kvm_vm *vm, uint8_t indent)
 {
 	struct pageMapL4Entry *pml4e, *pml4e_start;
diff --git a/tools/testing/selftests/kvm/x86_64/emulator_error_test.c b/tools/testing/selftests/kvm/x86_64/emulator_error_test.c
new file mode 100644
index 000000000000..825da57ad791
--- /dev/null
+++ b/tools/testing/selftests/kvm/x86_64/emulator_error_test.c
@@ -0,0 +1,209 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * Copyright (C) 2020, Google LLC.
+ *
+ * Tests for KVM_CAP_EXIT_ON_EMULATION_FAILURE capability.
+ */
+
+#define _GNU_SOURCE /* for program_invocation_short_name */
+
+#include "test_util.h"
+#include "kvm_util.h"
+#include "vmx.h"
+
+#define VCPU_ID	   1
+#define PAGE_SIZE  4096
+#define MAXPHYADDR 36
+
+#define MEM_REGION_GVA	0x0000123456789000
+#define MEM_REGION_GPA	0x0000000700000000
+#define MEM_REGION_SLOT	10
+#define MEM_REGION_SIZE PAGE_SIZE
+
+extern char fld_start, fld_end;
+
+static void guest_code(void)
+{
+	__asm__ __volatile__("fld_start: flds (%[addr]); fld_end:"
+			     :: [addr]"r"(MEM_REGION_GVA));
+
+	GUEST_DONE();
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
+/*
+ * Accessors to get R/M, REG, and Mod bits described in the SDM vol 2,
+ * figure 2-2 "Table Interpretation of ModR/M Byte (C8H)".
+ */
+#define GET_RM(insn_byte) (insn_byte & 0x7)
+#define GET_REG(insn_byte) ((insn_byte & 0x38) >> 3)
+#define GET_MOD(insn_byte) ((insn_byte & 0xc) >> 6)
+
+bool is_flds(uint8_t *insn_bytes, uint8_t insn_size)
+{
+	return insn_size >= 2 &&
+	       insn_bytes[0] == 0xd9 &&
+	       GET_REG(insn_bytes[1]) == 0x0;
+}
+
+static void process_exit_on_emulation_error(struct kvm_vm *vm)
+{
+	struct kvm_run *run = vcpu_state(vm, VCPU_ID);
+	struct kvm_regs regs;
+	uint8_t *insn_bytes;
+	uint8_t insn_size;
+	uint64_t flags;
+
+	TEST_ASSERT(run->exit_reason == KVM_EXIT_INTERNAL_ERROR,
+		    "Unexpected exit reason: %u (%s)",
+		    run->exit_reason,
+		    exit_reason_str(run->exit_reason));
+
+	TEST_ASSERT(run->emulation_failure.suberror == KVM_INTERNAL_ERROR_EMULATION,
+		    "Unexpected suberror: %u",
+		    run->emulation_failure.suberror);
+
+	if (run->emulation_failure.ndata >= 1) {
+		flags = run->emulation_failure.flags;
+		if ((flags & KVM_INTERNAL_ERROR_EMULATION_FLAG_INSTRUCTION_BYTES) &&
+		    run->emulation_failure.ndata >= 3) {
+			insn_size = run->emulation_failure.insn_size;
+			insn_bytes = run->emulation_failure.insn_bytes;
+
+			TEST_ASSERT(insn_size <= 15 && insn_size > 0,
+				    "Unexpected instruction size: %u",
+				    insn_size);
+
+			TEST_ASSERT(is_flds(insn_bytes, insn_size),
+				    "Unexpected instruction.  Expected 'flds' (0xd9 /0), encountered (0x%x /%u)",
+				    insn_bytes[0], (insn_size >= 2) ? GET_REG(insn_bytes[1]) : 0);
+
+			vcpu_regs_get(vm, VCPU_ID, &regs);
+			regs.rip += (uintptr_t)(&fld_end) - (uintptr_t)(&fld_start);
+			vcpu_regs_set(vm, VCPU_ID, &regs);
+		}
+	}
+}
+
+static void do_guest_assert(struct kvm_vm *vm, struct ucall *uc)
+{
+	TEST_FAIL("%s at %s:%ld", (const char *)uc->args[0], __FILE__,
+		  uc->args[1]);
+}
+
+static void check_for_guest_assert(struct kvm_vm *vm)
+{
+	struct kvm_run *run = vcpu_state(vm, VCPU_ID);
+	struct ucall uc;
+
+	if (run->exit_reason == KVM_EXIT_IO &&
+	    get_ucall(vm, VCPU_ID, &uc) == UCALL_ABORT) {
+		do_guest_assert(vm, &uc);
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
+	struct ucall uc;
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
+		do_guest_assert(vm, &uc);
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
+int main(int argc, char *argv[])
+{
+	struct kvm_enable_cap emul_failure_cap = {
+		.cap = KVM_CAP_EXIT_ON_EMULATION_FAILURE,
+		.args[0] = 1,
+	};
+	struct kvm_cpuid_entry2 *entry;
+	struct kvm_cpuid2 *cpuid;
+	struct kvm_vm *vm;
+	uint64_t *hva;
+	uint64_t gpa;
+	int rc;
+
+	/* Tell stdout not to buffer its content */
+	setbuf(stdout, NULL);
+
+	vm = vm_create_default(VCPU_ID, 0, guest_code);
+
+	cpuid = kvm_get_supported_cpuid();
+
+	entry = kvm_get_supported_cpuid_index(0x80000008, 0);
+	if (entry) {
+		entry->eax = (entry->eax & 0xffffff00) | MAXPHYADDR;
+		set_cpuid(cpuid, entry);
+	}
+
+	vcpu_set_cpuid(vm, VCPU_ID, cpuid);
+
+	entry = kvm_get_supported_cpuid_index(0x80000008, 0);
+
+	rc = kvm_check_cap(KVM_CAP_EXIT_ON_EMULATION_FAILURE);
+	TEST_ASSERT(rc, "KVM_CAP_EXIT_ON_EMULATION_FAILURE is unavailable");
+	vm_enable_cap(vm, &emul_failure_cap);
+
+	vm_userspace_mem_region_add(vm, VM_MEM_SRC_ANONYMOUS,
+				    MEM_REGION_GPA, MEM_REGION_SLOT,
+				    MEM_REGION_SIZE / PAGE_SIZE, 0);
+	gpa = vm_phy_pages_alloc(vm, MEM_REGION_SIZE / PAGE_SIZE,
+				 MEM_REGION_GPA, MEM_REGION_SLOT);
+	TEST_ASSERT(gpa == MEM_REGION_GPA, "Failed vm_phy_pages_alloc\n");
+	virt_map(vm, MEM_REGION_GVA, MEM_REGION_GPA, 1, 0);
+	hva = addr_gpa2hva(vm, MEM_REGION_GPA);
+	memset(hva, 0, PAGE_SIZE);
+	vm_set_page_table_entry(vm, MEM_REGION_GVA, 1ull << 36);
+
+	run_guest(vm);
+	process_exit_on_emulation_error(vm);
+	run_guest(vm);
+
+	TEST_ASSERT(process_ucall(vm) == UCALL_DONE, "Expected UCALL_DONE");
+
+	kvm_vm_free(vm);
+
+	return 0;
+}
-- 
2.31.1.498.g6c1eba8ee3d-goog

