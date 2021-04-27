Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D93DA36C9FA
	for <lists+kvm@lfdr.de>; Tue, 27 Apr 2021 19:02:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238709AbhD0RCs (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 27 Apr 2021 13:02:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60780 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238754AbhD0RCn (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 27 Apr 2021 13:02:43 -0400
Received: from mail-qk1-x74a.google.com (mail-qk1-x74a.google.com [IPv6:2607:f8b0:4864:20::74a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 76C26C061574
        for <kvm@vger.kernel.org>; Tue, 27 Apr 2021 10:01:58 -0700 (PDT)
Received: by mail-qk1-x74a.google.com with SMTP id 81-20020a370c540000b02902e4d7b9e448so1694352qkm.16
        for <kvm@vger.kernel.org>; Tue, 27 Apr 2021 10:01:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=98hP2WlqScSgD04ERrNMjeg/wARfoo+Pf3jZJro3uY0=;
        b=r/WsgZ0aQSphA/JnmLNlj2rGOa5A7Ohvlo1CUY26gSlnJU0xkus0xb68FXS4hQv+SE
         t8K2cvejQbJI+4H18FjivN4b3BX9vvTv61482OTe35HOas2PCZ4eaKwTTNAGiMf1ojWx
         +hfLCpUy02VELDLq1XCaFT0kz/sC+lOKpQz/jSKbJzrlrMXACYEw2mixVaDbZfekjuRs
         3WmeXqNlSnQ1g714BWvNmPosypirAUcBISP88W7RIEQg9b3VC7sxd5kmOoj0bYKHAjay
         HVpLWpUJNXo+5/6AZKS50buMTAC37ZzjNBginksW2pPF+/bueRjLClKLlQ8VQPCtsWgI
         d/Fg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=98hP2WlqScSgD04ERrNMjeg/wARfoo+Pf3jZJro3uY0=;
        b=BGzTo3g6iheT+Ovpk6Od9x13xIjcEBaXCkDXzL4jasJILfhZuKuaFfmXuXxuNFDCbm
         xN28HG90ooPpjAssS61I+kTQRZsO9zlDSLWMl90h713BbVGUByGglnpmuRAFmp7lRUh4
         9KZY4PbT19N1PPl6kXsNiE/tvEIlHfSxvJsF+dei+V0WXN4T202UM1UFo8oJvqNGzejK
         Ub30JUjHq/8zh9tVOMZ6FZOsVe6FNsUZtWAoY+tBPfyzksAagnLmfYJkgyejr1E3ImI4
         3zwQzIQUlnDjcpfRe6znCoRURILeO9+srS/1AOiGYm+08fWYhOOJSOqp8DfsPPw1INJV
         LOUw==
X-Gm-Message-State: AOAM530DSIvtU0spelfWNrqJEEjFWf0KKvEJG313fQpqAlcFEt63GUDB
        b4XW8+LLhh1lwxD7JoSq8n50554jboxNTosl
X-Google-Smtp-Source: ABdhPJwab/5d9K/Pm8Nj7fUzqgo8NRY9KrGoAts5At3vYMxF2hQlQAF1SRna1aG+TdHZBGsbVyuecwBABm/OaF2V
X-Received: from aaronlewis1.sea.corp.google.com ([2620:15c:100:202:de04:ef9c:253d:9ead])
 (user=aaronlewis job=sendgmr) by 2002:ad4:4523:: with SMTP id
 l3mr8979614qvu.57.1619542917642; Tue, 27 Apr 2021 10:01:57 -0700 (PDT)
Date:   Tue, 27 Apr 2021 09:59:59 -0700
In-Reply-To: <20210427165958.705212-1-aaronlewis@google.com>
Message-Id: <20210427165958.705212-3-aaronlewis@google.com>
Mime-Version: 1.0
References: <20210427165958.705212-1-aaronlewis@google.com>
X-Mailer: git-send-email 2.31.1.498.g6c1eba8ee3d-goog
Subject: [PATCH v4 2/2] selftests: kvm: Allows userspace to handle emulation errors.
From:   Aaron Lewis <aaronlewis@google.com>
To:     david.edmondson@oracle.com, seanjc@google.com, jmattson@google.com
Cc:     kvm@vger.kernel.org, Aaron Lewis <aaronlewis@google.com>
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
 .../selftests/kvm/lib/x86_64/processor.c      |  79 ++++++
 .../kvm/x86_64/emulator_error_test.c          | 224 ++++++++++++++++++
 5 files changed, 308 insertions(+)
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
+void vm_set_page_table_entry(struct kvm_vm *vm, uint64_t vaddr, uint64_t pte);
+
 /*
  * set_cpuid() - overwrites a matching cpuid entry with the provided value.
  *		 matches based on ent->function && ent->index. returns true
diff --git a/tools/testing/selftests/kvm/lib/x86_64/processor.c b/tools/testing/selftests/kvm/lib/x86_64/processor.c
index a8906e60a108..195af5a9c9ec 100644
--- a/tools/testing/selftests/kvm/lib/x86_64/processor.c
+++ b/tools/testing/selftests/kvm/lib/x86_64/processor.c
@@ -292,6 +292,85 @@ void virt_pg_map(struct kvm_vm *vm, uint64_t vaddr, uint64_t paddr,
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
+	struct kvm_cpuid_entry2 *entry;
+	int max_phy_addr;
+	/* Set the bottom 52 bits. */
+	uint64_t rsvd_mask = 0x000fffffffffffff;
+
+	entry = kvm_get_supported_cpuid_index(0x80000008, 0);
+	max_phy_addr = entry->eax & 0x000000ff;
+	/* Clear the bottom bits of the reserved mask. */
+	rsvd_mask = (rsvd_mask >> max_phy_addr) << max_phy_addr;
+
+	TEST_ASSERT(vm->mode == VM_MODE_PXXV48_4K, "Attempt to use "
+		"unknown or unsupported guest mode, mode: 0x%x", vm->mode);
+	TEST_ASSERT(sparsebit_is_set(vm->vpages_valid,
+		(vaddr >> vm->page_shift)),
+		"Invalid virtual address, vaddr: 0x%lx",
+		vaddr);
+	/*
+	 * Based on the mode check above there are 48 bits in the vaddr, so
+	 * shift 16 to sign extend the last bit (bit-47),
+	 */
+	TEST_ASSERT(vaddr == ((vaddr << 16) >> 16),
+		"Canonical check failed.  The virtual addres is invalid.");
+
+	index[0] = (vaddr >> 12) & 0x1ffu;
+	index[1] = (vaddr >> 21) & 0x1ffu;
+	index[2] = (vaddr >> 30) & 0x1ffu;
+	index[3] = (vaddr >> 39) & 0x1ffu;
+
+	pml4e = addr_gpa2hva(vm, vm->pgd);
+	TEST_ASSERT(pml4e[index[3]].present,
+		"Expected pml4e to be present for gva: 0x%08lx", vaddr);
+	TEST_ASSERT(((pml4e[index[3]].address * vm->page_size) & rsvd_mask) == 0,
+		    "Unexpected reserved bits set.");
+
+	pdpe = addr_gpa2hva(vm, pml4e[index[3]].address * vm->page_size);
+	TEST_ASSERT(pdpe[index[2]].present,
+		"Expected pdpe to be present for gva: 0x%08lx", vaddr);
+	TEST_ASSERT(pdpe[index[2]].page_size == 0,
+		"Expected pdpe to map a pde not a 1-GByte page.");
+	TEST_ASSERT(((pdpe[index[2]].address * vm->page_size) & rsvd_mask) == 0,
+		    "Unexpected reserved bits set.");
+
+	pde = addr_gpa2hva(vm, pdpe[index[2]].address * vm->page_size);
+	TEST_ASSERT(pde[index[1]].present,
+		"Expected pde to be present for gva: 0x%08lx", vaddr);
+	TEST_ASSERT(pde[index[1]].page_size == 0,
+		"Expected pde to map a pte not a 2-MByte page.");
+	TEST_ASSERT(((pde[index[1]].address * vm->page_size) & rsvd_mask) == 0,
+		    "Unexpected reserved bits set.");
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
+void vm_set_page_table_entry(struct kvm_vm *vm, uint64_t vaddr, uint64_t pte)
+{
+	struct pageTableEntry *_pte = _vm_get_page_table_entry(vm, vaddr);
+
+	*(uint64_t *)_pte = pte;
+}
+
 void virt_dump(FILE *stream, struct kvm_vm *vm, uint8_t indent)
 {
 	struct pageMapL4Entry *pml4e, *pml4e_start;
diff --git a/tools/testing/selftests/kvm/x86_64/emulator_error_test.c b/tools/testing/selftests/kvm/x86_64/emulator_error_test.c
new file mode 100644
index 000000000000..8d824af5f17b
--- /dev/null
+++ b/tools/testing/selftests/kvm/x86_64/emulator_error_test.c
@@ -0,0 +1,224 @@
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
+/* Ensure we are dealing with a simple 2-byte flds instruction. */
+static bool is_flds(uint8_t *insn_bytes, uint8_t insn_size)
+{
+	return insn_size >= 2 &&
+	       insn_bytes[0] == 0xd9 &&
+	       GET_REG(insn_bytes[1]) == 0x0 &&
+	       GET_MOD(insn_bytes[1]) == 0x0 &&
+	       /* Ensure there is no SIB byte. */
+	       GET_RM(insn_bytes[1]) != 0x4 &&
+	       /* Ensure there is no displacement byte. */
+	       GET_RM(insn_bytes[1]) != 0x5;
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
+				    "Unexpected instruction.  Expected 'flds' (0xd9 /0), encountered instruction with opcode: 0x%x",
+				    insn_bytes[0]);
+
+			/*
+			 * If is_flds() succeeded then the instruction bytes
+			 * contained an flds instruction that is 2-bytes in
+			 * length (ie: no SIB nor displacement).
+			 */
+			vcpu_regs_get(vm, VCPU_ID, &regs);
+			regs.rip += 2;
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
+	uint64_t gpa, pte;
+	uint64_t *hva;
+	int rc;
+
+	/* Tell stdout not to buffer its content */
+	setbuf(stdout, NULL);
+
+	vm = vm_create_default(VCPU_ID, 0, guest_code);
+
+	if (!kvm_check_cap(KVM_CAP_SMALLER_MAXPHYADDR)) {
+		printf("module parameter 'allow_smaller_maxphyaddr' is not set.  Skipping test.\n");
+		return 0;
+	}
+
+	cpuid = kvm_get_supported_cpuid();
+
+	entry = kvm_get_supported_cpuid_index(0x80000008, 0);
+	entry->eax = (entry->eax & 0xffffff00) | MAXPHYADDR;
+	set_cpuid(cpuid, entry);
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
+	pte = vm_get_page_table_entry(vm, MEM_REGION_GVA);
+	vm_set_page_table_entry(vm, MEM_REGION_GVA, pte | (1ull << 36));
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

