Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A52CD1A4C8A
	for <lists+kvm@lfdr.de>; Sat, 11 Apr 2020 01:17:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726865AbgDJXRX (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 10 Apr 2020 19:17:23 -0400
Received: from mga02.intel.com ([134.134.136.20]:20816 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726832AbgDJXRN (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 10 Apr 2020 19:17:13 -0400
IronPort-SDR: RO2yQBpYIN6MucWmw10fWEH4mTuHtf6D4wuY5DIF/p4PLOdUq22NfoHfq1Vx7eEEEZHWfJV54S
 KyDeQLxYjObA==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Apr 2020 16:17:13 -0700
IronPort-SDR: QT+kpRQhbqvgKW1eisSsS9c1ktxCZOJx2y/GvV787IdmprlyMFxnU4e+Its1dQgeHPOF3GL23s
 MwuG7bXa09WQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.72,368,1580803200"; 
   d="scan'208";a="452542254"
Received: from sjchrist-coffee.jf.intel.com ([10.54.74.202])
  by fmsmga005.fm.intel.com with ESMTP; 10 Apr 2020 16:17:13 -0700
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
Subject: [PATCH 10/10] selftests: kvm: Add testcase for creating max number of memslots
Date:   Fri, 10 Apr 2020 16:17:07 -0700
Message-Id: <20200410231707.7128-11-sean.j.christopherson@intel.com>
X-Mailer: git-send-email 2.26.0
In-Reply-To: <20200410231707.7128-1-sean.j.christopherson@intel.com>
References: <20200410231707.7128-1-sean.j.christopherson@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Wainer dos Santos Moschetta <wainersm@redhat.com>

This patch introduces test_add_max_memory_regions(), which checks
that a VM can have added memory slots up to the limit defined in
KVM_CAP_NR_MEMSLOTS. Then attempt to add one more slot to
verify it fails as expected.

Signed-off-by: Wainer dos Santos Moschetta <wainersm@redhat.com>
Reviewed-by: Andrew Jones <drjones@redhat.com>
Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
---
 .../selftests/kvm/set_memory_region_test.c    | 65 +++++++++++++++++--
 1 file changed, 60 insertions(+), 5 deletions(-)

diff --git a/tools/testing/selftests/kvm/set_memory_region_test.c b/tools/testing/selftests/kvm/set_memory_region_test.c
index 0f36941ebb96..cdf5024b2452 100644
--- a/tools/testing/selftests/kvm/set_memory_region_test.c
+++ b/tools/testing/selftests/kvm/set_memory_region_test.c
@@ -9,6 +9,7 @@
 #include <stdlib.h>
 #include <string.h>
 #include <sys/ioctl.h>
+#include <sys/mman.h>
 
 #include <linux/compiler.h>
 
@@ -18,14 +19,18 @@
 
 #define VCPU_ID 0
 
-#ifdef __x86_64__
 /*
- * Somewhat arbitrary location and slot, intended to not overlap anything.  The
- * location and size are specifically 2mb sized/aligned so that the initial
- * region corresponds to exactly one large page.
+ * s390x needs at least 1MB alignment, and the x86_64 MOVE/DELETE tests need a
+ * 2MB sized and aligned region so that the initial region corresponds to
+ * exactly one large page.
  */
-#define MEM_REGION_GPA		0xc0000000
 #define MEM_REGION_SIZE		0x200000
+
+#ifdef __x86_64__
+/*
+ * Somewhat arbitrary location and slot, intended to not overlap anything.
+ */
+#define MEM_REGION_GPA		0xc0000000
 #define MEM_REGION_SLOT		10
 
 static const uint64_t MMIO_VAL = 0xbeefull;
@@ -318,6 +323,54 @@ static void test_zero_memory_regions(void)
 	kvm_vm_free(vm);
 }
 
+/*
+ * Test it can be added memory slots up to KVM_CAP_NR_MEMSLOTS, then any
+ * tentative to add further slots should fail.
+ */
+static void test_add_max_memory_regions(void)
+{
+	int ret;
+	struct kvm_vm *vm;
+	uint32_t max_mem_slots;
+	uint32_t slot;
+	uint64_t guest_addr = 0x0;
+	uint64_t mem_reg_npages;
+	void *mem;
+
+	max_mem_slots = kvm_check_cap(KVM_CAP_NR_MEMSLOTS);
+	TEST_ASSERT(max_mem_slots > 0,
+		    "KVM_CAP_NR_MEMSLOTS should be greater than 0");
+	pr_info("Allowed number of memory slots: %i\n", max_mem_slots);
+
+	vm = vm_create(VM_MODE_DEFAULT, 0, O_RDWR);
+
+	mem_reg_npages = vm_calc_num_guest_pages(VM_MODE_DEFAULT, MEM_REGION_SIZE);
+
+	/* Check it can be added memory slots up to the maximum allowed */
+	pr_info("Adding slots 0..%i, each memory region with %dK size\n",
+		(max_mem_slots - 1), MEM_REGION_SIZE >> 10);
+	for (slot = 0; slot < max_mem_slots; slot++) {
+		vm_userspace_mem_region_add(vm, VM_MEM_SRC_ANONYMOUS,
+					    guest_addr, slot, mem_reg_npages,
+					    0);
+		guest_addr += MEM_REGION_SIZE;
+	}
+
+	/* Check it cannot be added memory slots beyond the limit */
+	mem = mmap(NULL, MEM_REGION_SIZE, PROT_READ | PROT_WRITE,
+		   MAP_PRIVATE | MAP_ANONYMOUS, -1, 0);
+	TEST_ASSERT(mem != MAP_FAILED, "Failed to mmap() host");
+
+	ret = ioctl(vm_get_fd(vm), KVM_SET_USER_MEMORY_REGION,
+		    &(struct kvm_userspace_memory_region) {slot, 0, guest_addr,
+		    MEM_REGION_SIZE, (uint64_t) mem});
+	TEST_ASSERT(ret == -1 && errno == EINVAL,
+		    "Adding one more memory slot should fail with EINVAL");
+
+	munmap(mem, MEM_REGION_SIZE);
+	kvm_vm_free(vm);
+}
+
 int main(int argc, char *argv[])
 {
 #ifdef __x86_64__
@@ -329,6 +382,8 @@ int main(int argc, char *argv[])
 
 	test_zero_memory_regions();
 
+	test_add_max_memory_regions();
+
 #ifdef __x86_64__
 	if (argc > 1)
 		loops = atoi(argv[1]);
-- 
2.26.0

