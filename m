Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BA21F18D9C9
	for <lists+kvm@lfdr.de>; Fri, 20 Mar 2020 21:56:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727270AbgCTUz5 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 20 Mar 2020 16:55:57 -0400
Received: from mga11.intel.com ([192.55.52.93]:32133 "EHLO mga11.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727261AbgCTUzu (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 20 Mar 2020 16:55:50 -0400
IronPort-SDR: 8BiWnNS+6mXPlf4+gzqOzbZ6athxilkvaY5AY5DwpOuvj/w6Y8GmsdlCo60KzmEpipwuwRN+3u
 bZ6mD/W67mow==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Mar 2020 13:55:49 -0700
IronPort-SDR: +0unh8FONmtrG2sfnffBwNWGCe9gpTodDsZWyehaUdctPxUcGfVFDt60dRhTfzLxKOIwlyUizX
 FJNNMGUF3iLw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.72,285,1580803200"; 
   d="scan'208";a="280543339"
Received: from sjchrist-coffee.jf.intel.com ([10.54.74.202])
  by fmsmga002.fm.intel.com with ESMTP; 20 Mar 2020 13:55:49 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Christian Borntraeger <borntraeger@de.ibm.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     David Hildenbrand <david@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Qian Cai <cai@lca.pw>,
        Peter Xu <peterx@redhat.com>
Subject: [PATCH 7/7] KVM: selftests: Add "delete" testcase to set_memory_region_test
Date:   Fri, 20 Mar 2020 13:55:46 -0700
Message-Id: <20200320205546.2396-8-sean.j.christopherson@intel.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200320205546.2396-1-sean.j.christopherson@intel.com>
References: <20200320205546.2396-1-sean.j.christopherson@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Add coverate for running a guest with no memslots, and for deleting
memslots while the guest is running.  Enhance the test to use, and
expect, a unique value for MMIO reads, e.g. to verify each stage of
the test.

Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
---
 .../kvm/x86_64/set_memory_region_test.c       | 122 ++++++++++++++++--
 1 file changed, 108 insertions(+), 14 deletions(-)

diff --git a/tools/testing/selftests/kvm/x86_64/set_memory_region_test.c b/tools/testing/selftests/kvm/x86_64/set_memory_region_test.c
index c6691cff4e19..44aed8ac932b 100644
--- a/tools/testing/selftests/kvm/x86_64/set_memory_region_test.c
+++ b/tools/testing/selftests/kvm/x86_64/set_memory_region_test.c
@@ -26,42 +26,109 @@
 #define MEM_REGION_SIZE		0x200000
 #define MEM_REGION_SLOT		10
 
-static void guest_code(void)
+static const uint64_t MMIO_VAL = 0xbeefull;
+
+extern const uint64_t final_rip_start;
+extern const uint64_t final_rip_end;
+
+static inline uint64_t guest_spin_on_val(uint64_t spin_val)
 {
 	uint64_t val;
 
 	do {
 		val = READ_ONCE(*((uint64_t *)MEM_REGION_GPA));
-	} while (!val);
+	} while (val == spin_val);
+	return val;
+}
 
-	if (val != 1)
-		ucall(UCALL_ABORT, 1, val);
+static void guest_code(void)
+{
+	uint64_t val;
 
-	GUEST_DONE();
+	/*
+	 * Spin until the memory region is moved to a misaligned address.  This
+	 * may or may not trigger MMIO, as the window where the memslot is
+	 * invalid is quite small.
+	 */
+	val = guest_spin_on_val(0);
+	GUEST_ASSERT(val == 1 || val == MMIO_VAL);
+
+	/* Spin until the memory region is realigned. */
+	GUEST_ASSERT(guest_spin_on_val(MMIO_VAL) == 1);
+
+	/* Spin until the memory region is deleted. */
+	GUEST_ASSERT(guest_spin_on_val(1) == MMIO_VAL);
+
+	/* Spin until the memory region is recreated. */
+	GUEST_ASSERT(guest_spin_on_val(MMIO_VAL) == 0);
+
+	/* Spin until the memory region is deleted. */
+	GUEST_ASSERT(guest_spin_on_val(0) == MMIO_VAL);
+
+	asm("1:\n\t"
+	    ".pushsection .rodata\n\t"
+	    ".global final_rip_start\n\t"
+	    "final_rip_start: .quad 1b\n\t"
+	    ".popsection");
+
+	/* Spin indefinitely (until the code memslot is deleted). */
+	guest_spin_on_val(MMIO_VAL);
+
+	asm("1:\n\t"
+	    ".pushsection .rodata\n\t"
+	    ".global final_rip_end\n\t"
+	    "final_rip_end: .quad 1b\n\t"
+	    ".popsection");
+
+	GUEST_ASSERT(0);
 }
 
 static void *vcpu_worker(void *data)
 {
 	struct kvm_vm *vm = data;
+	struct kvm_regs regs;
 	struct kvm_run *run;
 	struct ucall uc;
-	uint64_t cmd;
 
 	/*
 	 * Loop until the guest is done.  Re-enter the guest on all MMIO exits,
-	 * which will occur if the guest attempts to access a memslot while it
-	 * is being moved.
+	 * which will occur if the guest attempts to access a memslot after it
+	 * has been deleted or while it is being moved .
 	 */
 	run = vcpu_state(vm, VCPU_ID);
-	do {
+
+	memcpy(run->mmio.data, &MMIO_VAL, 8);
+	while (1) {
 		vcpu_run(vm, VCPU_ID);
-	} while (run->exit_reason == KVM_EXIT_MMIO);
+		if (run->exit_reason != KVM_EXIT_MMIO)
+			break;
 
-	TEST_ASSERT(run->exit_reason == KVM_EXIT_IO,
+		TEST_ASSERT(!run->mmio.is_write, "Unexpected exit mmio write");
+		TEST_ASSERT(run->mmio.len == 8,
+			    "Unexpected exit mmio size = %u", run->mmio.len);
+
+		TEST_ASSERT(run->mmio.phys_addr == MEM_REGION_GPA,
+			    "Unexpected exit mmio address = 0x%llx",
+			    run->mmio.phys_addr);
+	}
+
+	if (run->exit_reason == KVM_EXIT_IO) {
+		(void)get_ucall(vm, VCPU_ID, &uc);
+		TEST_FAIL("%s at %s:%ld",
+			  (const char *)uc.args[0], __FILE__, uc.args[1]);
+	}
+
+	TEST_ASSERT(run->exit_reason == KVM_EXIT_SHUTDOWN ||
+		    run->exit_reason == KVM_INTERNAL_ERROR_EMULATION,
 		    "Unexpected exit reason = %d", run->exit_reason);
 
-	cmd = get_ucall(vm, VCPU_ID, &uc);
-	TEST_ASSERT(cmd == UCALL_DONE, "Unexpected val in guest = %lu", uc.args[0]);
+	vcpu_regs_get(vm, VCPU_ID, &regs);
+
+	TEST_ASSERT(regs.rip >= final_rip_start &&
+		    regs.rip < final_rip_end,
+		    "Bad rip, expected 0x%lx - 0x%lx, got 0x%llx\n",
+		    final_rip_start, final_rip_end, regs.rip);
+
 	return NULL;
 }
 
@@ -72,6 +139,13 @@ static void test_move_memory_region(void)
 	uint64_t *hva;
 	uint64_t gpa;
 
+	vm = vm_create(VM_MODE_DEFAULT, 0, O_RDWR);
+	vm_vcpu_add(vm, VCPU_ID);
+	/* Fails with ENOSPC because the MMU can't create pages (no slots). */
+	TEST_ASSERT(_vcpu_run(vm, VCPU_ID) == -1 && errno == ENOSPC,
+		    "Unexpected error code = %d", errno);
+	kvm_vm_free(vm);
+
 	vm = vm_create_default(VCPU_ID, 0, guest_code);
 
 	vcpu_set_cpuid(vm, VCPU_ID, kvm_get_supported_cpuid());
@@ -105,7 +179,6 @@ static void test_move_memory_region(void)
 	 */
 	vm_mem_region_move(vm, MEM_REGION_SLOT, MEM_REGION_GPA - 4096);
 	WRITE_ONCE(*hva, 2);
-
 	usleep(100000);
 
 	/*
@@ -116,6 +189,27 @@ static void test_move_memory_region(void)
 
 	/* Restore the original base, the guest should see "1". */
 	vm_mem_region_move(vm, MEM_REGION_SLOT, MEM_REGION_GPA);
+	usleep(100000);
+
+	/* Delete the memory region, the guest should not die. */
+	vm_mem_region_delete(vm, MEM_REGION_SLOT);
+	usleep(100000);
+
+	/* Recreate the memory region.  The guest should see "0". */
+	vm_userspace_mem_region_add(vm, VM_MEM_SRC_ANONYMOUS_THP,
+				    MEM_REGION_GPA, MEM_REGION_SLOT,
+				    MEM_REGION_SIZE / getpagesize(), 0);
+	usleep(100000);
+
+	/* Delete the region again so that there's only one memslot left. */
+	vm_mem_region_delete(vm, MEM_REGION_SLOT);
+	usleep(100000);
+
+	/*
+	 * Delete the primary memslot.  This should cause an emulation error or
+	 * shutdown due to the page tables getting nuked.
+	 */
+	vm_mem_region_delete(vm, VM_PRIMARY_MEM_SLOT);
 
 	pthread_join(vcpu_thread, NULL);
 
-- 
2.24.1

