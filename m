Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 89FF116340A
	for <lists+kvm@lfdr.de>; Tue, 18 Feb 2020 22:08:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727872AbgBRVIQ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 18 Feb 2020 16:08:16 -0500
Received: from mga07.intel.com ([134.134.136.100]:6399 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727561AbgBRVHw (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 18 Feb 2020 16:07:52 -0500
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by orsmga105.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 18 Feb 2020 13:07:46 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.70,457,1574150400"; 
   d="scan'208";a="253856461"
Received: from sjchrist-coffee.jf.intel.com ([10.54.74.202])
  by orsmga002.jf.intel.com with ESMTP; 18 Feb 2020 13:07:46 -0800
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Paul Mackerras <paulus@ozlabs.org>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        David Hildenbrand <david@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, Marc Zyngier <maz@kernel.org>,
        James Morse <james.morse@arm.com>,
        Julien Thierry <julien.thierry.kdev@gmail.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        linux-mips@vger.kernel.org, kvm@vger.kernel.org,
        kvm-ppc@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        kvmarm@lists.cs.columbia.edu, linux-kernel@vger.kernel.org,
        Christoffer Dall <christoffer.dall@arm.com>,
        Peter Xu <peterx@redhat.com>,
        =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <f4bug@amsat.org>
Subject: [PATCH v6 19/22] KVM: selftests: Add test for KVM_SET_USER_MEMORY_REGION
Date:   Tue, 18 Feb 2020 13:07:33 -0800
Message-Id: <20200218210736.16432-20-sean.j.christopherson@intel.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200218210736.16432-1-sean.j.christopherson@intel.com>
References: <20200218210736.16432-1-sean.j.christopherson@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Add a KVM selftest to test moving the base gfn of a userspace memory
region.  Although the basic concept of moving memory regions is not x86
specific, the assumptions regarding large pages and MMIO shenanigans
used to verify the correctness make this x86_64 only for the time being.

Reviewed-by: Peter Xu <peterx@redhat.com>
Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
---
 tools/testing/selftests/kvm/.gitignore        |   1 +
 tools/testing/selftests/kvm/Makefile          |   1 +
 .../testing/selftests/kvm/include/kvm_util.h  |   1 +
 tools/testing/selftests/kvm/lib/kvm_util.c    |  30 ++++
 .../kvm/x86_64/set_memory_region_test.c       | 142 ++++++++++++++++++
 5 files changed, 175 insertions(+)
 create mode 100644 tools/testing/selftests/kvm/x86_64/set_memory_region_test.c

diff --git a/tools/testing/selftests/kvm/.gitignore b/tools/testing/selftests/kvm/.gitignore
index 9619d96e15c4..0abf0a8f00d5 100644
--- a/tools/testing/selftests/kvm/.gitignore
+++ b/tools/testing/selftests/kvm/.gitignore
@@ -5,6 +5,7 @@
 /x86_64/hyperv_cpuid
 /x86_64/mmio_warning_test
 /x86_64/platform_info_test
+/x86_64/set_memory_region_test
 /x86_64/set_sregs_test
 /x86_64/smm_test
 /x86_64/state_test
diff --git a/tools/testing/selftests/kvm/Makefile b/tools/testing/selftests/kvm/Makefile
index 833f4880c041..c9ba73498fd8 100644
--- a/tools/testing/selftests/kvm/Makefile
+++ b/tools/testing/selftests/kvm/Makefile
@@ -17,6 +17,7 @@ TEST_GEN_PROGS_x86_64 += x86_64/evmcs_test
 TEST_GEN_PROGS_x86_64 += x86_64/hyperv_cpuid
 TEST_GEN_PROGS_x86_64 += x86_64/mmio_warning_test
 TEST_GEN_PROGS_x86_64 += x86_64/platform_info_test
+TEST_GEN_PROGS_x86_64 += x86_64/set_memory_region_test
 TEST_GEN_PROGS_x86_64 += x86_64/set_sregs_test
 TEST_GEN_PROGS_x86_64 += x86_64/smm_test
 TEST_GEN_PROGS_x86_64 += x86_64/state_test
diff --git a/tools/testing/selftests/kvm/include/kvm_util.h b/tools/testing/selftests/kvm/include/kvm_util.h
index ae0d14c2540a..02d64e16218a 100644
--- a/tools/testing/selftests/kvm/include/kvm_util.h
+++ b/tools/testing/selftests/kvm/include/kvm_util.h
@@ -100,6 +100,7 @@ int _vcpu_ioctl(struct kvm_vm *vm, uint32_t vcpuid, unsigned long ioctl,
 		void *arg);
 void vm_ioctl(struct kvm_vm *vm, unsigned long ioctl, void *arg);
 void vm_mem_region_set_flags(struct kvm_vm *vm, uint32_t slot, uint32_t flags);
+void vm_mem_region_move(struct kvm_vm *vm, uint32_t slot, uint64_t new_gpa);
 void vm_vcpu_add(struct kvm_vm *vm, uint32_t vcpuid);
 vm_vaddr_t vm_vaddr_alloc(struct kvm_vm *vm, size_t sz, vm_vaddr_t vaddr_min,
 			  uint32_t data_memslot, uint32_t pgd_memslot);
diff --git a/tools/testing/selftests/kvm/lib/kvm_util.c b/tools/testing/selftests/kvm/lib/kvm_util.c
index fc597d7d6f84..c106e80b2208 100644
--- a/tools/testing/selftests/kvm/lib/kvm_util.c
+++ b/tools/testing/selftests/kvm/lib/kvm_util.c
@@ -772,6 +772,36 @@ void vm_mem_region_set_flags(struct kvm_vm *vm, uint32_t slot, uint32_t flags)
 		ret, errno, slot, flags);
 }
 
+/*
+ * VM Memory Region Move
+ *
+ * Input Args:
+ *   vm - Virtual Machine
+ *   slot - Slot of the memory region to move
+ *   flags - Starting guest physical address
+ *
+ * Output Args: None
+ *
+ * Return: None
+ *
+ * Change the gpa of a memory region.
+ */
+void vm_mem_region_move(struct kvm_vm *vm, uint32_t slot, uint64_t new_gpa)
+{
+	struct userspace_mem_region *region;
+	int ret;
+
+	region = memslot2region(vm, slot);
+
+	region->region.guest_phys_addr = new_gpa;
+
+	ret = ioctl(vm->fd, KVM_SET_USER_MEMORY_REGION, &region->region);
+
+	TEST_ASSERT(!ret, "KVM_SET_USER_MEMORY_REGION failed\n"
+		    "ret: %i errno: %i slot: %u flags: 0x%x",
+		    ret, errno, slot, new_gpa);
+}
+
 /*
  * VCPU mmap Size
  *
diff --git a/tools/testing/selftests/kvm/x86_64/set_memory_region_test.c b/tools/testing/selftests/kvm/x86_64/set_memory_region_test.c
new file mode 100644
index 000000000000..125aeab59ab6
--- /dev/null
+++ b/tools/testing/selftests/kvm/x86_64/set_memory_region_test.c
@@ -0,0 +1,142 @@
+// SPDX-License-Identifier: GPL-2.0
+#define _GNU_SOURCE /* for program_invocation_short_name */
+#include <fcntl.h>
+#include <pthread.h>
+#include <sched.h>
+#include <signal.h>
+#include <stdio.h>
+#include <stdlib.h>
+#include <string.h>
+#include <sys/ioctl.h>
+
+#include <linux/compiler.h>
+
+#include <test_util.h>
+#include <kvm_util.h>
+#include <processor.h>
+
+#define VCPU_ID 0
+
+/*
+ * Somewhat arbitrary location and slot, intended to not overlap anything.  The
+ * location and size are specifically 2mb sized/aligned so that the initial
+ * region corresponds to exactly one large page.
+ */
+#define MEM_REGION_GPA		0xc0000000
+#define MEM_REGION_SIZE		0x200000
+#define MEM_REGION_SLOT		10
+
+static void guest_code(void)
+{
+	uint64_t val;
+
+	do {
+		val = READ_ONCE(*((uint64_t *)MEM_REGION_GPA));
+	} while (!val);
+
+	if (val != 1)
+		ucall(UCALL_ABORT, 1, val);
+
+	GUEST_DONE();
+}
+
+static void *vcpu_worker(void *data)
+{
+	struct kvm_vm *vm = data;
+	struct kvm_run *run;
+	struct ucall uc;
+	uint64_t cmd;
+
+	/*
+	 * Loop until the guest is done.  Re-enter the guest on all MMIO exits,
+	 * which will occur if the guest attempts to access a memslot while it
+	 * is being moved.
+	 */
+	run = vcpu_state(vm, VCPU_ID);
+	do {
+		vcpu_run(vm, VCPU_ID);
+	} while (run->exit_reason == KVM_EXIT_MMIO);
+
+	TEST_ASSERT(run->exit_reason == KVM_EXIT_IO,
+		    "Unexpected exit reason = %d", run->exit_reason);
+
+	cmd = get_ucall(vm, VCPU_ID, &uc);
+	TEST_ASSERT(cmd == UCALL_DONE, "Unexpected val in guest = %llu",
+		    uc.args[0]);
+	return NULL;
+}
+
+static void test_move_memory_region(void)
+{
+	pthread_t vcpu_thread;
+	struct kvm_vm *vm;
+	uint64_t *hva;
+	uint64_t gpa;
+
+	vm = vm_create_default(VCPU_ID, 0, guest_code);
+
+	vcpu_set_cpuid(vm, VCPU_ID, kvm_get_supported_cpuid());
+
+	vm_userspace_mem_region_add(vm, VM_MEM_SRC_ANONYMOUS_THP,
+				    MEM_REGION_GPA, MEM_REGION_SLOT,
+				    MEM_REGION_SIZE / getpagesize(), 0);
+
+	/*
+	 * Allocate and map two pages so that the GPA accessed by guest_code()
+	 * stays valid across the memslot move.
+	 */
+	gpa = vm_phy_pages_alloc(vm, 2, MEM_REGION_GPA, MEM_REGION_SLOT);
+	TEST_ASSERT(gpa == MEM_REGION_GPA, "Failed vm_phy_pages_alloc\n");
+
+	virt_map(vm, MEM_REGION_GPA, MEM_REGION_GPA, 2 * 4096, 0);
+
+	/* Ditto for the host mapping so that both pages can be zeroed. */
+	hva = addr_gpa2hva(vm, MEM_REGION_GPA);
+	memset(hva, 0, 2 * 4096);
+
+	pthread_create(&vcpu_thread, NULL, vcpu_worker, vm);
+
+	/* Ensure the guest thread is spun up. */
+	usleep(100000);
+
+	/*
+	 * Shift the region's base GPA.  The guest should not see "2" as the
+	 * hva->gpa translation is misaligned, i.e. the guest is accessing a
+	 * different host pfn.
+	 */
+	vm_mem_region_move(vm, MEM_REGION_SLOT, MEM_REGION_GPA - 4096);
+	WRITE_ONCE(*hva, 2);
+
+	usleep(100000);
+
+	/*
+	 * Note, value in memory needs to be changed *before* restoring the
+	 * memslot, else the guest could race the update and see "2".
+	 */
+	WRITE_ONCE(*hva, 1);
+
+	/* Restore the original base, the guest should see "1". */
+	vm_mem_region_move(vm, MEM_REGION_SLOT, MEM_REGION_GPA);
+
+	pthread_join(vcpu_thread, NULL);
+
+	kvm_vm_free(vm);
+}
+
+int main(int argc, char *argv[])
+{
+	int i, loops;
+
+	/* Tell stdout not to buffer its content */
+	setbuf(stdout, NULL);
+
+	if (argc > 1)
+		loops = atoi(argv[1]);
+	else
+		loops = 10;
+
+	for (i = 0; i < loops; i++)
+		test_move_memory_region();
+
+	return 0;
+}
-- 
2.24.1

