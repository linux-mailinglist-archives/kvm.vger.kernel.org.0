Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5FED7BF776
	for <lists+kvm@lfdr.de>; Thu, 26 Sep 2019 19:18:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727747AbfIZRSh (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 26 Sep 2019 13:18:37 -0400
Received: from mail-wr1-f65.google.com ([209.85.221.65]:43450 "EHLO
        mail-wr1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727723AbfIZRSg (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 26 Sep 2019 13:18:36 -0400
Received: by mail-wr1-f65.google.com with SMTP id q17so3377237wrx.10;
        Thu, 26 Sep 2019 10:18:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=zLN+r2W5U/KLTUp8ommfyNpxfdEpCNafvs1bua4gTA8=;
        b=VDrOBpsF++eFZEnD0Pze5vlFve/wRD3+H+Gqr5tcCZaYj39vUoF0Or4pzn3jHl0CS9
         DLnR4kAa7Knv3vHpxjwzPjgzRiz/2Gm2BLyGE3m4Dr00zF4tpHQEXy615OXz4zMxR3r0
         kgdIGsdFHNgEzAU7Kys4j1767NTLvuiBqAtkyIyO+894mjfYMjw9FtqllrZa20lCkmSJ
         gpAS3bH7plvCJ+U16lvXU674M7VdvmXfRoaKF0J2V+wK8KEdD4l+mMXmuMTtLGxxujHE
         QtoqC1/dQ/uemnN2tnzNpgTbsNrjpH93cDudS0MYzQ4ksKCn0n9N7eg6EI4YukjhaNOP
         dn4Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:from:to:cc:subject:date:message-id
         :in-reply-to:references;
        bh=zLN+r2W5U/KLTUp8ommfyNpxfdEpCNafvs1bua4gTA8=;
        b=D0tObl1W8q/fGvtxtTzgfi8Y9/Ciq2WBlHaHhqcRSYQin/blCbi0qSiEGAjN3T8x9A
         seoZVgKMi3QAlfAUFRcifDQVB7oE7fmDAxJq+7LkiwXSVM8h1Lecxby7J32rbpNSIIb+
         jpRvc7/W4O93r434iP1WdowlhfyUmVKxVC/i4eRh+jIcUjpKSe/N654uPagpAEBCuTse
         0wcmzA83egNgIaPM8ZZa7HRThm26r/k4Lc6oIRwKFxAnHCj98ZlKlWUMew4xBKGv6vRY
         KU1etZQ8wjzssOpqRmAwMvPiRI0N3UU8Yfm1LIPcPfT1LWEb5SVen0mD21/TI8fIAJHw
         IrRw==
X-Gm-Message-State: APjAAAUmAFCfQwBfMkMkgmzatO2kfSUb7ZMuCwgwa8mbYONQ1lP2+n6y
        MczZSRWyumoiRDbV1cEKtyiaHXDJ
X-Google-Smtp-Source: APXvYqyoDAaj5sEE7SrIFcWuHL+Ysq1MZ0vSFLRtrds6Cnavjpr9VcnuVaokYeR7XWXaziBoBgqxCA==
X-Received: by 2002:a5d:5231:: with SMTP id i17mr3932732wra.142.1569518312284;
        Thu, 26 Sep 2019 10:18:32 -0700 (PDT)
Received: from 640k.localdomain.com ([93.56.166.5])
        by smtp.gmail.com with ESMTPSA id v4sm4792782wrg.56.2019.09.26.10.18.31
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 26 Sep 2019 10:18:31 -0700 (PDT)
From:   Paolo Bonzini <pbonzini@redhat.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     Vitaly Kuznetsov <vkuznets@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Junaid Shahid <junaids@google.com>
Subject: [PATCH 3/3] selftests: kvm: add test for dirty logging inside nested guests
Date:   Thu, 26 Sep 2019 19:18:26 +0200
Message-Id: <1569518306-46567-4-git-send-email-pbonzini@redhat.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1569518306-46567-1-git-send-email-pbonzini@redhat.com>
References: <1569518306-46567-1-git-send-email-pbonzini@redhat.com>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Check that accesses by nested guests are logged according to the
L1 physical addresses rather than L2.

Most of the patch is really adding EPT support to the testing
framework.

Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 tools/testing/selftests/kvm/Makefile               |   1 +
 .../selftests/kvm/include/x86_64/processor.h       |   3 +
 tools/testing/selftests/kvm/include/x86_64/vmx.h   |  14 ++
 tools/testing/selftests/kvm/lib/kvm_util.c         |   2 +-
 .../testing/selftests/kvm/lib/kvm_util_internal.h  |   3 +
 tools/testing/selftests/kvm/lib/x86_64/vmx.c       | 201 ++++++++++++++++++++-
 .../selftests/kvm/x86_64/vmx_dirty_log_test.c      | 156 ++++++++++++++++
 7 files changed, 377 insertions(+), 3 deletions(-)
 create mode 100644 tools/testing/selftests/kvm/x86_64/vmx_dirty_log_test.c

diff --git a/tools/testing/selftests/kvm/Makefile b/tools/testing/selftests/kvm/Makefile
index 62c591f87dab..fd84b7a78dcf 100644
--- a/tools/testing/selftests/kvm/Makefile
+++ b/tools/testing/selftests/kvm/Makefile
@@ -22,6 +22,7 @@ TEST_GEN_PROGS_x86_64 += x86_64/smm_test
 TEST_GEN_PROGS_x86_64 += x86_64/state_test
 TEST_GEN_PROGS_x86_64 += x86_64/sync_regs_test
 TEST_GEN_PROGS_x86_64 += x86_64/vmx_close_while_nested_test
+TEST_GEN_PROGS_x86_64 += x86_64/vmx_dirty_log_test
 TEST_GEN_PROGS_x86_64 += x86_64/vmx_set_nested_state_test
 TEST_GEN_PROGS_x86_64 += x86_64/vmx_tsc_adjust_test
 TEST_GEN_PROGS_x86_64 += clear_dirty_log_test
diff --git a/tools/testing/selftests/kvm/include/x86_64/processor.h b/tools/testing/selftests/kvm/include/x86_64/processor.h
index 0c17f2ee685e..ff234018219c 100644
--- a/tools/testing/selftests/kvm/include/x86_64/processor.h
+++ b/tools/testing/selftests/kvm/include/x86_64/processor.h
@@ -1083,6 +1083,9 @@ void vcpu_set_msr(struct kvm_vm *vm, uint32_t vcpuid, uint64_t msr_index,
 #define VMX_BASIC_MEM_TYPE_WB	6LLU
 #define VMX_BASIC_INOUT		0x0040000000000000LLU
 
+/* VMX_EPT_VPID_CAP bits */
+#define VMX_EPT_VPID_CAP_AD_BITS	(1ULL << 21)
+
 /* MSR_IA32_VMX_MISC bits */
 #define MSR_IA32_VMX_MISC_VMWRITE_SHADOW_RO_FIELDS (1ULL << 29)
 #define MSR_IA32_VMX_MISC_PREEMPTION_TIMER_SCALE   0x1F
diff --git a/tools/testing/selftests/kvm/include/x86_64/vmx.h b/tools/testing/selftests/kvm/include/x86_64/vmx.h
index 69b17055f63d..6ae5a47fe067 100644
--- a/tools/testing/selftests/kvm/include/x86_64/vmx.h
+++ b/tools/testing/selftests/kvm/include/x86_64/vmx.h
@@ -569,6 +569,10 @@ struct vmx_pages {
 	void *enlightened_vmcs_hva;
 	uint64_t enlightened_vmcs_gpa;
 	void *enlightened_vmcs;
+
+	void *eptp_hva;
+	uint64_t eptp_gpa;
+	void *eptp;
 };
 
 struct vmx_pages *vcpu_alloc_vmx(struct kvm_vm *vm, vm_vaddr_t *p_vmx_gva);
@@ -576,4 +580,14 @@ struct vmx_pages {
 void prepare_vmcs(struct vmx_pages *vmx, void *guest_rip, void *guest_rsp);
 bool load_vmcs(struct vmx_pages *vmx);
 
+void nested_pg_map(struct vmx_pages *vmx, struct kvm_vm *vm,
+		   uint64_t nested_paddr, uint64_t paddr, uint32_t eptp_memslot);
+void nested_map(struct vmx_pages *vmx, struct kvm_vm *vm,
+		 uint64_t nested_paddr, uint64_t paddr, uint64_t size,
+		 uint32_t eptp_memslot);
+void nested_map_memslot(struct vmx_pages *vmx, struct kvm_vm *vm,
+			uint32_t memslot, uint32_t eptp_memslot);
+void prepare_eptp(struct vmx_pages *vmx, struct kvm_vm *vm,
+		  uint32_t eptp_memslot);
+
 #endif /* SELFTEST_KVM_VMX_H */
diff --git a/tools/testing/selftests/kvm/lib/kvm_util.c b/tools/testing/selftests/kvm/lib/kvm_util.c
index 80a338b5403c..41cf45416060 100644
--- a/tools/testing/selftests/kvm/lib/kvm_util.c
+++ b/tools/testing/selftests/kvm/lib/kvm_util.c
@@ -705,7 +705,7 @@ void vm_userspace_mem_region_add(struct kvm_vm *vm,
  *   on error (e.g. currently no memory region using memslot as a KVM
  *   memory slot ID).
  */
-static struct userspace_mem_region *
+struct userspace_mem_region *
 memslot2region(struct kvm_vm *vm, uint32_t memslot)
 {
 	struct userspace_mem_region *region;
diff --git a/tools/testing/selftests/kvm/lib/kvm_util_internal.h b/tools/testing/selftests/kvm/lib/kvm_util_internal.h
index f36262e0f655..ac50c42750cf 100644
--- a/tools/testing/selftests/kvm/lib/kvm_util_internal.h
+++ b/tools/testing/selftests/kvm/lib/kvm_util_internal.h
@@ -68,4 +68,7 @@ struct kvm_vm {
 void regs_dump(FILE *stream, struct kvm_regs *regs, uint8_t indent);
 void sregs_dump(FILE *stream, struct kvm_sregs *sregs, uint8_t indent);
 
+struct userspace_mem_region *
+memslot2region(struct kvm_vm *vm, uint32_t memslot);
+
 #endif /* SELFTEST_KVM_UTIL_INTERNAL_H */
diff --git a/tools/testing/selftests/kvm/lib/x86_64/vmx.c b/tools/testing/selftests/kvm/lib/x86_64/vmx.c
index 9cef0455b819..fab8f6b0bf52 100644
--- a/tools/testing/selftests/kvm/lib/x86_64/vmx.c
+++ b/tools/testing/selftests/kvm/lib/x86_64/vmx.c
@@ -7,11 +7,39 @@
 
 #include "test_util.h"
 #include "kvm_util.h"
+#include "../kvm_util_internal.h"
 #include "processor.h"
 #include "vmx.h"
 
+#define PAGE_SHIFT_4K  12
+
+#define KVM_EPT_PAGE_TABLE_MIN_PADDR 0x1c0000
+
 bool enable_evmcs;
 
+struct eptPageTableEntry {
+	uint64_t readable:1;
+	uint64_t writable:1;
+	uint64_t executable:1;
+	uint64_t memory_type:3;
+	uint64_t ignore_pat:1;
+	uint64_t page_size:1;
+	uint64_t accessed:1;
+	uint64_t dirty:1;
+	uint64_t ignored_11_10:2;
+	uint64_t address:40;
+	uint64_t ignored_62_52:11;
+	uint64_t suppress_ve:1;
+};
+
+struct eptPageTablePointer {
+	uint64_t memory_type:3;
+	uint64_t page_walk_length:3;
+	uint64_t ad_enabled:1;
+	uint64_t reserved_11_07:5;
+	uint64_t address:40;
+	uint64_t reserved_63_52:12;
+};
 int vcpu_enable_evmcs(struct kvm_vm *vm, int vcpu_id)
 {
 	uint16_t evmcs_ver;
@@ -174,15 +202,35 @@ bool load_vmcs(struct vmx_pages *vmx)
  */
 static inline void init_vmcs_control_fields(struct vmx_pages *vmx)
 {
+	uint32_t sec_exec_ctl = 0;
+
 	vmwrite(VIRTUAL_PROCESSOR_ID, 0);
 	vmwrite(POSTED_INTR_NV, 0);
 
 	vmwrite(PIN_BASED_VM_EXEC_CONTROL, rdmsr(MSR_IA32_VMX_TRUE_PINBASED_CTLS));
-	if (!vmwrite(SECONDARY_VM_EXEC_CONTROL, 0))
+
+	if (vmx->eptp_gpa) {
+		uint64_t ept_paddr;
+		struct eptPageTablePointer eptp = {
+			.memory_type = VMX_BASIC_MEM_TYPE_WB,
+			.page_walk_length = 3, /* + 1 */
+			.ad_enabled = !!(rdmsr(MSR_IA32_VMX_EPT_VPID_CAP) & VMX_EPT_VPID_CAP_AD_BITS),
+			.address = vmx->eptp_gpa >> PAGE_SHIFT_4K,
+		};
+
+		memcpy(&ept_paddr, &eptp, sizeof(ept_paddr));
+		vmwrite(EPT_POINTER, ept_paddr);
+		sec_exec_ctl |= SECONDARY_EXEC_ENABLE_EPT;
+	}
+
+	if (!vmwrite(SECONDARY_VM_EXEC_CONTROL, sec_exec_ctl))
 		vmwrite(CPU_BASED_VM_EXEC_CONTROL,
 			rdmsr(MSR_IA32_VMX_TRUE_PROCBASED_CTLS) | CPU_BASED_ACTIVATE_SECONDARY_CONTROLS);
-	else
+	else {
 		vmwrite(CPU_BASED_VM_EXEC_CONTROL, rdmsr(MSR_IA32_VMX_TRUE_PROCBASED_CTLS));
+		GUEST_ASSERT(!sec_exec_ctl);
+	}
+
 	vmwrite(EXCEPTION_BITMAP, 0);
 	vmwrite(PAGE_FAULT_ERROR_CODE_MASK, 0);
 	vmwrite(PAGE_FAULT_ERROR_CODE_MATCH, -1); /* Never match */
@@ -327,3 +375,152 @@ void prepare_vmcs(struct vmx_pages *vmx, void *guest_rip, void *guest_rsp)
 	init_vmcs_host_state();
 	init_vmcs_guest_state(guest_rip, guest_rsp);
 }
+
+void nested_pg_map(struct vmx_pages *vmx, struct kvm_vm *vm,
+	 	   uint64_t nested_paddr, uint64_t paddr, uint32_t eptp_memslot)
+{
+	uint16_t index[4];
+	struct eptPageTableEntry *pml4e;
+
+	TEST_ASSERT(vm->mode == VM_MODE_PXXV48_4K, "Attempt to use "
+		    "unknown or unsupported guest mode, mode: 0x%x", vm->mode);
+
+	TEST_ASSERT((nested_paddr % vm->page_size) == 0,
+		    "Nested physical address not on page boundary,\n"
+		    "  nested_paddr: 0x%lx vm->page_size: 0x%x",
+		    nested_paddr, vm->page_size);
+	TEST_ASSERT((nested_paddr >> vm->page_shift) <= vm->max_gfn,
+		    "Physical address beyond beyond maximum supported,\n"
+		    "  nested_paddr: 0x%lx vm->max_gfn: 0x%lx vm->page_size: 0x%x",
+		    paddr, vm->max_gfn, vm->page_size);
+	TEST_ASSERT((paddr % vm->page_size) == 0,
+		    "Physical address not on page boundary,\n"
+		    "  paddr: 0x%lx vm->page_size: 0x%x",
+		    paddr, vm->page_size);
+	TEST_ASSERT((paddr >> vm->page_shift) <= vm->max_gfn,
+		    "Physical address beyond beyond maximum supported,\n"
+		    "  paddr: 0x%lx vm->max_gfn: 0x%lx vm->page_size: 0x%x",
+		    paddr, vm->max_gfn, vm->page_size);
+
+	index[0] = (nested_paddr >> 12) & 0x1ffu;
+	index[1] = (nested_paddr >> 21) & 0x1ffu;
+	index[2] = (nested_paddr >> 30) & 0x1ffu;
+	index[3] = (nested_paddr >> 39) & 0x1ffu;
+
+	/* Allocate page directory pointer table if not present. */
+	pml4e = vmx->eptp_hva;
+	if (!pml4e[index[3]].readable) {
+		pml4e[index[3]].address = vm_phy_page_alloc(vm,
+			  KVM_EPT_PAGE_TABLE_MIN_PADDR, eptp_memslot)
+			>> vm->page_shift;
+		pml4e[index[3]].writable = true;
+		pml4e[index[3]].readable = true;
+		pml4e[index[3]].executable = true;
+	}
+
+	/* Allocate page directory table if not present. */
+	struct eptPageTableEntry *pdpe;
+	pdpe = addr_gpa2hva(vm, pml4e[index[3]].address * vm->page_size);
+	if (!pdpe[index[2]].readable) {
+		pdpe[index[2]].address = vm_phy_page_alloc(vm,
+			  KVM_EPT_PAGE_TABLE_MIN_PADDR, eptp_memslot)
+			>> vm->page_shift;
+		pdpe[index[2]].writable = true;
+		pdpe[index[2]].readable = true;
+		pdpe[index[2]].executable = true;
+	}
+
+	/* Allocate page table if not present. */
+	struct eptPageTableEntry *pde;
+	pde = addr_gpa2hva(vm, pdpe[index[2]].address * vm->page_size);
+	if (!pde[index[1]].readable) {
+		pde[index[1]].address = vm_phy_page_alloc(vm,
+			  KVM_EPT_PAGE_TABLE_MIN_PADDR, eptp_memslot)
+			>> vm->page_shift;
+		pde[index[1]].writable = true;
+		pde[index[1]].readable = true;
+		pde[index[1]].executable = true;
+	}
+
+	/* Fill in page table entry. */
+	struct eptPageTableEntry *pte;
+	pte = addr_gpa2hva(vm, pde[index[1]].address * vm->page_size);
+	pte[index[0]].address = paddr >> vm->page_shift;
+	pte[index[0]].writable = true;
+	pte[index[0]].readable = true;
+	pte[index[0]].executable = true;
+
+	/*
+	 * For now mark these as accessed and dirty because the only
+	 * testcase we have needs that.  Can be reconsidered later.
+	 */
+	pte[index[0]].accessed = true;
+	pte[index[0]].dirty = true;
+}
+
+/*
+ * Map a range of EPT guest physical addresses to the VM's physical address
+ *
+ * Input Args:
+ *   vm - Virtual Machine
+ *   nested_paddr - Nested guest physical address to map
+ *   paddr - VM Physical Address
+ *   size - The size of the range to map
+ *   eptp_memslot - Memory region slot for new virtual translation tables
+ *
+ * Output Args: None
+ *
+ * Return: None
+ *
+ * Within the VM given by vm, creates a nested guest translation for the
+ * page range starting at nested_paddr to the page range starting at paddr.
+ */
+void nested_map(struct vmx_pages *vmx, struct kvm_vm *vm,
+		uint64_t nested_paddr, uint64_t paddr, uint64_t size,
+		uint32_t eptp_memslot)
+{
+	size_t page_size = vm->page_size;
+	size_t npages = size / page_size;
+
+	TEST_ASSERT(nested_paddr + size > nested_paddr, "Vaddr overflow");
+	TEST_ASSERT(paddr + size > paddr, "Paddr overflow");
+
+	while (npages--) {
+		nested_pg_map(vmx, vm, nested_paddr, paddr, eptp_memslot);
+		nested_paddr += page_size;
+		paddr += page_size;
+	}
+}
+
+/* Prepare an identity extended page table that maps all the
+ * physical pages in VM.
+ */
+void nested_map_memslot(struct vmx_pages *vmx, struct kvm_vm *vm,
+			uint32_t memslot, uint32_t eptp_memslot)
+{
+	sparsebit_idx_t i, last;
+	struct userspace_mem_region *region =
+		memslot2region(vm, memslot);
+
+	i = (region->region.guest_phys_addr >> vm->page_shift) - 1;
+	last = i + (region->region.memory_size >> vm->page_shift);
+	for (;;) {
+		i = sparsebit_next_clear(region->unused_phy_pages, i);
+		if (i > last)
+			break;
+
+		nested_map(vmx, vm,
+			   (uint64_t)i << vm->page_shift,
+			   (uint64_t)i << vm->page_shift,
+			   1 << vm->page_shift,
+			   eptp_memslot);
+	}
+}
+
+void prepare_eptp(struct vmx_pages *vmx, struct kvm_vm *vm,
+		  uint32_t eptp_memslot)
+{
+	vmx->eptp = (void *)vm_vaddr_alloc(vm, getpagesize(), 0x10000, 0, 0);
+	vmx->eptp_hva = addr_gva2hva(vm, (uintptr_t)vmx->eptp);
+	vmx->eptp_gpa = addr_gva2gpa(vm, (uintptr_t)vmx->eptp);
+}
diff --git a/tools/testing/selftests/kvm/x86_64/vmx_dirty_log_test.c b/tools/testing/selftests/kvm/x86_64/vmx_dirty_log_test.c
new file mode 100644
index 000000000000..0bca1cfe2c1e
--- /dev/null
+++ b/tools/testing/selftests/kvm/x86_64/vmx_dirty_log_test.c
@@ -0,0 +1,156 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * KVM dirty page logging test
+ *
+ * Copyright (C) 2018, Red Hat, Inc.
+ */
+
+#define _GNU_SOURCE /* for program_invocation_name */
+
+#include <stdio.h>
+#include <stdlib.h>
+#include <linux/bitmap.h>
+#include <linux/bitops.h>
+
+#include "test_util.h"
+#include "kvm_util.h"
+#include "processor.h"
+#include "vmx.h"
+
+#define VCPU_ID				1
+
+/* The memory slot index to track dirty pages */
+#define TEST_MEM_SLOT_INDEX		1
+#define TEST_MEM_SIZE			3
+
+/* L1 guest test virtual memory offset */
+#define GUEST_TEST_MEM			0xc0000000
+
+/* L2 guest test virtual memory offset */
+#define NESTED_TEST_MEM1		0xc0001000
+#define NESTED_TEST_MEM2		0xc0002000
+
+static void l2_guest_code(void)
+{
+	*(volatile uint64_t *)NESTED_TEST_MEM1;
+	*(volatile uint64_t *)NESTED_TEST_MEM1 = 1;
+	GUEST_SYNC(true);
+	GUEST_SYNC(false);
+
+	*(volatile uint64_t *)NESTED_TEST_MEM2 = 1;
+	GUEST_SYNC(true);
+	*(volatile uint64_t *)NESTED_TEST_MEM2 = 1;
+	GUEST_SYNC(true);
+	GUEST_SYNC(false);
+
+	/* Exit to L1 and never come back.  */
+	vmcall();
+}
+
+void l1_guest_code(struct vmx_pages *vmx)
+{
+#define L2_GUEST_STACK_SIZE 64
+	unsigned long l2_guest_stack[L2_GUEST_STACK_SIZE];
+
+	GUEST_ASSERT(vmx->vmcs_gpa);
+	GUEST_ASSERT(prepare_for_vmx_operation(vmx));
+	GUEST_ASSERT(load_vmcs(vmx));
+
+	prepare_vmcs(vmx, l2_guest_code,
+		     &l2_guest_stack[L2_GUEST_STACK_SIZE]);
+
+	GUEST_SYNC(false);
+	GUEST_ASSERT(!vmlaunch());
+	GUEST_SYNC(false);
+	GUEST_ASSERT(vmreadz(VM_EXIT_REASON) == EXIT_REASON_VMCALL);
+	GUEST_DONE();
+}
+
+int main(int argc, char *argv[])
+{
+	vm_vaddr_t vmx_pages_gva = 0;
+	struct vmx_pages *vmx;
+	unsigned long *bmap;
+	uint64_t *host_test_mem;
+
+	struct kvm_vm *vm;
+	struct kvm_run *run;
+	struct ucall uc;
+	bool done = false;
+
+	/* Create VM */
+	vm = vm_create_default(VCPU_ID, 0, l1_guest_code);
+	vcpu_set_cpuid(vm, VCPU_ID, kvm_get_supported_cpuid());
+	vmx = vcpu_alloc_vmx(vm, &vmx_pages_gva);
+	vcpu_args_set(vm, VCPU_ID, 1, vmx_pages_gva);
+	run = vcpu_state(vm, VCPU_ID);
+
+	/* Add an extra memory slot for testing dirty logging */
+	vm_userspace_mem_region_add(vm, VM_MEM_SRC_ANONYMOUS,
+				    GUEST_TEST_MEM,
+				    TEST_MEM_SLOT_INDEX,
+				    TEST_MEM_SIZE,
+				    KVM_MEM_LOG_DIRTY_PAGES);
+
+	/*
+	 * Add an identity map for GVA range [0xc0000000, 0xc0002000).  This
+	 * affects both L1 and L2.  However...
+	 */
+	virt_map(vm, GUEST_TEST_MEM, GUEST_TEST_MEM,
+		 TEST_MEM_SIZE * 4096, 0);
+
+	/*
+	 * ... pages in the L2 GPA range [0xc0001000, 0xc0003000) will map to
+	 * 0xc0000000.
+	 *
+	 * Note that prepare_eptp should be called only L1's GPA map is done,
+	 * meaning after the last call to virt_map.
+	 */
+	prepare_eptp(vmx, vm, 0);
+	nested_map_memslot(vmx, vm, 0, 0);
+	nested_map(vmx, vm, NESTED_TEST_MEM1, GUEST_TEST_MEM, 4096, 0);
+	nested_map(vmx, vm, NESTED_TEST_MEM2, GUEST_TEST_MEM, 4096, 0);
+
+	bmap = bitmap_alloc(TEST_MEM_SIZE);
+	host_test_mem = addr_gpa2hva(vm, GUEST_TEST_MEM);
+
+	while (!done) {
+		memset(host_test_mem, 0xaa, TEST_MEM_SIZE * 4096);
+		_vcpu_run(vm, VCPU_ID);
+		TEST_ASSERT(run->exit_reason == KVM_EXIT_IO,
+			    "Unexpected exit reason: %u (%s),\n",
+			    run->exit_reason,
+			    exit_reason_str(run->exit_reason));
+
+		switch (get_ucall(vm, VCPU_ID, &uc)) {
+		case UCALL_ABORT:
+			TEST_ASSERT(false, "%s at %s:%d", (const char *)uc.args[0],
+				    __FILE__, uc.args[1]);
+			/* NOT REACHED */
+		case UCALL_SYNC:
+			/*
+			 * The nested guest wrote at offset 0x1000 in the memslot, but the
+			 * dirty bitmap must be filled in according to L1 GPA, not L2.
+			 */
+			kvm_vm_get_dirty_log(vm, TEST_MEM_SLOT_INDEX, bmap);
+			if (uc.args[1]) {
+				TEST_ASSERT(test_bit(0, bmap), "Page 0 incorrectly reported clean\n");
+				TEST_ASSERT(host_test_mem[0] == 1, "Page 0 not written by guest\n");
+			} else {
+				TEST_ASSERT(!test_bit(0, bmap), "Page 0 incorrectly reported dirty\n");
+				TEST_ASSERT(host_test_mem[0] == 0xaaaaaaaaaaaaaaaaULL, "Page 0 written by guest\n");
+			}
+
+			TEST_ASSERT(!test_bit(1, bmap), "Page 1 incorrectly reported dirty\n");
+			TEST_ASSERT(host_test_mem[4096 / 8] == 0xaaaaaaaaaaaaaaaaULL, "Page 1 written by guest\n");
+			TEST_ASSERT(!test_bit(2, bmap), "Page 2 incorrectly reported dirty\n");
+			TEST_ASSERT(host_test_mem[8192 / 8] == 0xaaaaaaaaaaaaaaaaULL, "Page 2 written by guest\n");
+			break;
+		case UCALL_DONE:
+			done = true;
+			break;
+		default:
+			TEST_ASSERT(false, "Unknown ucall 0x%x.", uc.cmd);
+		}
+	}
+}
-- 
1.8.3.1

