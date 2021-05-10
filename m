Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C9671379269
	for <lists+kvm@lfdr.de>; Mon, 10 May 2021 17:19:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234133AbhEJPUR (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 10 May 2021 11:20:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45504 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234860AbhEJPSy (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 10 May 2021 11:18:54 -0400
Received: from mail-yb1-xb49.google.com (mail-yb1-xb49.google.com [IPv6:2607:f8b0:4864:20::b49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 35FECC061761
        for <kvm@vger.kernel.org>; Mon, 10 May 2021 07:48:46 -0700 (PDT)
Received: by mail-yb1-xb49.google.com with SMTP id s10-20020a252c0a0000b02904f8e566d0f2so3153466ybs.3
        for <kvm@vger.kernel.org>; Mon, 10 May 2021 07:48:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=keUIE2poj9Yra0Ko2MBq/ehiH6gMJkYLr5BcaZ2lFdc=;
        b=grzZkf0oQ+3c707f7f5zzFiUkLEkK9pS/vZco0QIMLOju1t+AO+7iN2g51zhAtEIoa
         lx6n0eaXXFIwDgo5JNWSoqnRzZAdoHoGtaR0pS7eIKHeafXnqXxFK/l/OG6k9edKpcQf
         G6ajeniukUGifTXuwTbMrYB1urbCCg2QjoNly52xd9qfm+YpgzzwPFMPGUZlsKgdMH47
         C1If1mI8oePrBqabRKCnkGAP6Bfbe5Qa8dl37yaRDTRmELB+VCdQ2Z90zFQ/tC1PPrnQ
         aDx5y0IbMJZcXWLY/ecJT9bvWwBdI3zjJLmBIDxR333H8+45rfbynvVAvXaZ+Bgh40A/
         Tprg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=keUIE2poj9Yra0Ko2MBq/ehiH6gMJkYLr5BcaZ2lFdc=;
        b=tIvYPJUjwCruhtRFi85PyYIsIWkHP+no/t/sNqmmknblHT1/3hrwAtYd2AMohNcoSr
         sK2b86yqGJ0zKsfKwPkBipMF5RrafbHwxFUH1/WZfWT1+QAXMDi4JbrMX8h8Gl8qRbP3
         dRF5T76JiK206elSpm2SVlY5wJcGoIi5nvcnPIXSuq57vz67+Dcy6uJo81TxZEjSwDgc
         Bh1sJ3pH19eUNEyR/DVfX0b8bO9w12zg5T43So3cnAUDrV3y/Qzli35AYUwklpK7+sF/
         Ar6eAw+KBxFSj/BhbjCLHRUgBR4TsA7SmGVKRmxZCt0zkpjqCotSuxe1RlLdVXxiOaK1
         e2XQ==
X-Gm-Message-State: AOAM532YWC1OxKC5/m2vOxY676lGsCnyJgYCmmx1Z+coBEdVU5Wo+KQf
        CWzOdbvw/5HnPyJptdgnMGuYANZTK5koLLg9
X-Google-Smtp-Source: ABdhPJxzzNSFTsqeTG0MYXRWK+ke9zwGpajthFGLOUq8huwq6S3JHW/tnBMVxy1A2ISpgZR7avIuKOMDyiTt7ukY
X-Received: from aaronlewis1.sea.corp.google.com ([2620:15c:100:202:3396:9513:fac0:8ec7])
 (user=aaronlewis job=sendgmr) by 2002:a25:b009:: with SMTP id
 q9mr33611337ybf.506.1620658125420; Mon, 10 May 2021 07:48:45 -0700 (PDT)
Date:   Mon, 10 May 2021 07:48:34 -0700
In-Reply-To: <20210510144834.658457-1-aaronlewis@google.com>
Message-Id: <20210510144834.658457-3-aaronlewis@google.com>
Mime-Version: 1.0
References: <20210510144834.658457-1-aaronlewis@google.com>
X-Mailer: git-send-email 2.31.1.607.g51e8a6a459-goog
Subject: [PATCH v6 2/2] selftests: kvm: Allows userspace to handle emulation errors.
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
Reviewed-by: Jim Mattson <jmattson@google.com>
---
 tools/testing/selftests/kvm/.gitignore        |   1 +
 tools/testing/selftests/kvm/Makefile          |   1 +
 .../selftests/kvm/include/x86_64/processor.h  |   4 +
 .../selftests/kvm/lib/x86_64/processor.c      |  94 ++++++++
 .../kvm/x86_64/emulator_error_test.c          | 219 ++++++++++++++++++
 5 files changed, 319 insertions(+)
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
index 0b30b4e15c38..8fdd21710aae 100644
--- a/tools/testing/selftests/kvm/include/x86_64/processor.h
+++ b/tools/testing/selftests/kvm/include/x86_64/processor.h
@@ -394,6 +394,10 @@ void vcpu_init_descriptor_tables(struct kvm_vm *vm, uint32_t vcpuid);
 void vm_handle_exception(struct kvm_vm *vm, int vector,
 			void (*handler)(struct ex_regs *));
 
+uint64_t vm_get_page_table_entry(struct kvm_vm *vm, int vcpuid, uint64_t vaddr);
+void vm_set_page_table_entry(struct kvm_vm *vm, int vcpuid, uint64_t vaddr,
+			     uint64_t pte);
+
 /*
  * set_cpuid() - overwrites a matching cpuid entry with the provided value.
  *		 matches based on ent->function && ent->index. returns true
diff --git a/tools/testing/selftests/kvm/lib/x86_64/processor.c b/tools/testing/selftests/kvm/lib/x86_64/processor.c
index a8906e60a108..78f5109e30da 100644
--- a/tools/testing/selftests/kvm/lib/x86_64/processor.c
+++ b/tools/testing/selftests/kvm/lib/x86_64/processor.c
@@ -292,6 +292,100 @@ void virt_pg_map(struct kvm_vm *vm, uint64_t vaddr, uint64_t paddr,
 	pte[index[0]].present = 1;
 }
 
+static struct pageTableEntry *_vm_get_page_table_entry(struct kvm_vm *vm, int vcpuid,
+						       uint64_t vaddr)
+{
+	uint16_t index[4];
+	struct pageMapL4Entry *pml4e;
+	struct pageDirectoryPointerEntry *pdpe;
+	struct pageDirectoryEntry *pde;
+	struct pageTableEntry *pte;
+	struct kvm_cpuid_entry2 *entry;
+	struct kvm_sregs sregs;
+	int max_phy_addr;
+	/* Set the bottom 52 bits. */
+	uint64_t rsvd_mask = 0x000fffffffffffff;
+
+	entry = kvm_get_supported_cpuid_index(0x80000008, 0);
+	max_phy_addr = entry->eax & 0x000000ff;
+	/* Clear the bottom bits of the reserved mask. */
+	rsvd_mask = (rsvd_mask >> max_phy_addr) << max_phy_addr;
+
+	/*
+	 * SDM vol 3, fig 4-11 "Formats of CR3 and Paging-Structure Entries
+	 * with 4-Level Paging and 5-Level Paging".
+	 * If IA32_EFER.NXE = 0 and the P flag of a paging-structure entry is 1,
+	 * the XD flag (bit 63) is reserved.
+	 */
+	vcpu_sregs_get(vm, vcpuid, &sregs);
+	if ((sregs.efer & EFER_NX) == 0) {
+		rsvd_mask |= (1ull << 63);
+	}
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
+	TEST_ASSERT(vaddr == (((int64_t)vaddr << 16) >> 16),
+		"Canonical check failed.  The virtual address is invalid.");
+
+	index[0] = (vaddr >> 12) & 0x1ffu;
+	index[1] = (vaddr >> 21) & 0x1ffu;
+	index[2] = (vaddr >> 30) & 0x1ffu;
+	index[3] = (vaddr >> 39) & 0x1ffu;
+
+	pml4e = addr_gpa2hva(vm, vm->pgd);
+	TEST_ASSERT(pml4e[index[3]].present,
+		"Expected pml4e to be present for gva: 0x%08lx", vaddr);
+	TEST_ASSERT((*(uint64_t*)(&pml4e[index[3]]) &
+		(rsvd_mask | (1ull << 7))) == 0,
+		"Unexpected reserved bits set.");
+
+	pdpe = addr_gpa2hva(vm, pml4e[index[3]].address * vm->page_size);
+	TEST_ASSERT(pdpe[index[2]].present,
+		"Expected pdpe to be present for gva: 0x%08lx", vaddr);
+	TEST_ASSERT(pdpe[index[2]].page_size == 0,
+		"Expected pdpe to map a pde not a 1-GByte page.");
+	TEST_ASSERT((*(uint64_t*)(&pdpe[index[2]]) & rsvd_mask) == 0,
+		"Unexpected reserved bits set.");
+
+	pde = addr_gpa2hva(vm, pdpe[index[2]].address * vm->page_size);
+	TEST_ASSERT(pde[index[1]].present,
+		"Expected pde to be present for gva: 0x%08lx", vaddr);
+	TEST_ASSERT(pde[index[1]].page_size == 0,
+		"Expected pde to map a pte not a 2-MByte page.");
+	TEST_ASSERT((*(uint64_t*)(&pde[index[1]]) & rsvd_mask) == 0,
+		"Unexpected reserved bits set.");
+
+	pte = addr_gpa2hva(vm, pde[index[1]].address * vm->page_size);
+	TEST_ASSERT(pte[index[0]].present,
+		"Expected pte to be present for gva: 0x%08lx", vaddr);
+
+	return &pte[index[0]];
+}
+
+uint64_t vm_get_page_table_entry(struct kvm_vm *vm, int vcpuid, uint64_t vaddr)
+{
+	struct pageTableEntry *pte = _vm_get_page_table_entry(vm, vcpuid, vaddr);
+
+	return *(uint64_t *)pte;
+}
+
+void vm_set_page_table_entry(struct kvm_vm *vm, int vcpuid, uint64_t vaddr,
+			     uint64_t pte)
+{
+	struct pageTableEntry *new_pte = _vm_get_page_table_entry(vm, vcpuid,
+								  vaddr);
+
+	*(uint64_t *)new_pte = pte;
+}
+
 void virt_dump(FILE *stream, struct kvm_vm *vm, uint8_t indent)
 {
 	struct pageMapL4Entry *pml4e, *pml4e_start;
diff --git a/tools/testing/selftests/kvm/x86_64/emulator_error_test.c b/tools/testing/selftests/kvm/x86_64/emulator_error_test.c
new file mode 100644
index 000000000000..054b39e49413
--- /dev/null
+++ b/tools/testing/selftests/kvm/x86_64/emulator_error_test.c
@@ -0,0 +1,219 @@
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
+static void guest_code(void)
+{
+	__asm__ __volatile__("flds (%[addr])"
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
+				    "Unexpected instruction.  Expected 'flds' (0xd9 /0)");
+
+			/*
+			 * If is_flds() succeeded then the instruction bytes
+			 * contained an flds instruction that is 2-bytes in
+			 * length (ie: no prefix, no SIB, no displacement).
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
+	pte = vm_get_page_table_entry(vm, VCPU_ID, MEM_REGION_GVA);
+	vm_set_page_table_entry(vm, VCPU_ID, MEM_REGION_GVA, pte | (1ull << 36));
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
2.31.1.607.g51e8a6a459-goog

