Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 805771A4C8E
	for <lists+kvm@lfdr.de>; Sat, 11 Apr 2020 01:17:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726798AbgDJXRM (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 10 Apr 2020 19:17:12 -0400
Received: from mga02.intel.com ([134.134.136.20]:20816 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726754AbgDJXRM (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 10 Apr 2020 19:17:12 -0400
IronPort-SDR: o0sIHX59e389PtayW/+8IJWfcGRxhgehK1hMofllJSb/Yhzk3a6c0SZRUG3/JbynGPM2Ms8Ekd
 oVpYXRUbAxCw==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Apr 2020 16:17:12 -0700
IronPort-SDR: G+OQw9ZukDDBGA2G6uYhmVeZ1GuJFi+TqS3SwAF4lFf8j++4nznbK/6AIQlgIgckP/Has5EEFE
 uvgtVrdXNPlA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.72,368,1580803200"; 
   d="scan'208";a="452542240"
Received: from sjchrist-coffee.jf.intel.com ([10.54.74.202])
  by fmsmga005.fm.intel.com with ESMTP; 10 Apr 2020 16:17:11 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Paolo Bonzini <pbonzini@redhat.com>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Janosch Frank <frankja@linux.ibm.com>
Cc:     David Hildenbrand <david@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Peter Xu <peterx@redhat.com>,
        Andrew Jones <drjones@redhat.com>,
        Wainer dos Santos Moschetta <wainersm@redhat.com>
Subject: [PATCH 06/10] KVM: selftests: Add "delete" testcase to set_memory_region_test
Date:   Fri, 10 Apr 2020 16:17:03 -0700
Message-Id: <20200410231707.7128-7-sean.j.christopherson@intel.com>
X-Mailer: git-send-email 2.26.0
In-Reply-To: <20200410231707.7128-1-sean.j.christopherson@intel.com>
References: <20200410231707.7128-1-sean.j.christopherson@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Add a testcase for deleting memslots while the guest is running.
Like the "move" testcase, this is x86_64-only as it relies on MMIO
happening when a non-existent memslot is encountered.

Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
---
 .../kvm/x86_64/set_memory_region_test.c       | 91 +++++++++++++++++++
 1 file changed, 91 insertions(+)

diff --git a/tools/testing/selftests/kvm/x86_64/set_memory_region_test.c b/tools/testing/selftests/kvm/x86_64/set_memory_region_test.c
index 629dd8579b73..b556024af683 100644
--- a/tools/testing/selftests/kvm/x86_64/set_memory_region_test.c
+++ b/tools/testing/selftests/kvm/x86_64/set_memory_region_test.c
@@ -29,6 +29,9 @@
 
 static const uint64_t MMIO_VAL = 0xbeefull;
 
+extern const uint64_t final_rip_start;
+extern const uint64_t final_rip_end;
+
 static sem_t vcpu_ready;
 
 static inline uint64_t guest_spin_on_val(uint64_t spin_val)
@@ -203,6 +206,89 @@ static void test_move_memory_region(void)
 	kvm_vm_free(vm);
 }
 
+static void guest_code_delete_memory_region(void)
+{
+	uint64_t val;
+
+	GUEST_SYNC(0);
+
+	/* Spin until the memory region is deleted. */
+	val = guest_spin_on_val(0);
+	GUEST_ASSERT_1(val == MMIO_VAL, val);
+
+	/* Spin until the memory region is recreated. */
+	val = guest_spin_on_val(MMIO_VAL);
+	GUEST_ASSERT_1(val == 0, val);
+
+	/* Spin until the memory region is deleted. */
+	val = guest_spin_on_val(0);
+	GUEST_ASSERT_1(val == MMIO_VAL, val);
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
+	GUEST_ASSERT_1(0, 0);
+}
+
+static void test_delete_memory_region(void)
+{
+	pthread_t vcpu_thread;
+	struct kvm_regs regs;
+	struct kvm_run *run;
+	struct kvm_vm *vm;
+
+	vm = spawn_vm(&vcpu_thread, guest_code_delete_memory_region);
+
+	/* Delete the memory region, the guest should not die. */
+	vm_mem_region_delete(vm, MEM_REGION_SLOT);
+	wait_for_vcpu();
+
+	/* Recreate the memory region.  The guest should see "0". */
+	vm_userspace_mem_region_add(vm, VM_MEM_SRC_ANONYMOUS_THP,
+				    MEM_REGION_GPA, MEM_REGION_SLOT,
+				    MEM_REGION_SIZE / getpagesize(), 0);
+	wait_for_vcpu();
+
+	/* Delete the region again so that there's only one memslot left. */
+	vm_mem_region_delete(vm, MEM_REGION_SLOT);
+	wait_for_vcpu();
+
+	/*
+	 * Delete the primary memslot.  This should cause an emulation error or
+	 * shutdown due to the page tables getting nuked.
+	 */
+	vm_mem_region_delete(vm, 0);
+
+	pthread_join(vcpu_thread, NULL);
+
+	run = vcpu_state(vm, VCPU_ID);
+
+	TEST_ASSERT(run->exit_reason == KVM_EXIT_SHUTDOWN ||
+		    run->exit_reason == KVM_EXIT_INTERNAL_ERROR,
+		    "Unexpected exit reason = %d", run->exit_reason);
+
+	vcpu_regs_get(vm, VCPU_ID, &regs);
+
+	TEST_ASSERT(regs.rip >= final_rip_start &&
+		    regs.rip < final_rip_end,
+		    "Bad rip, expected 0x%lx - 0x%lx, got 0x%llx\n",
+		    final_rip_start, final_rip_end, regs.rip);
+
+	kvm_vm_free(vm);
+}
+
 int main(int argc, char *argv[])
 {
 	int i, loops;
@@ -215,8 +301,13 @@ int main(int argc, char *argv[])
 	else
 		loops = 10;
 
+	pr_info("Testing MOVE of in-use region, %d loops\n", loops);
 	for (i = 0; i < loops; i++)
 		test_move_memory_region();
 
+	pr_info("Testing DELETE of in-use region, %d loops\n", loops);
+	for (i = 0; i < loops; i++)
+		test_delete_memory_region();
+
 	return 0;
 }
-- 
2.26.0

