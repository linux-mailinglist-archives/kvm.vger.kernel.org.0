Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D127D1A4C92
	for <lists+kvm@lfdr.de>; Sat, 11 Apr 2020 01:17:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726921AbgDJXRr (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 10 Apr 2020 19:17:47 -0400
Received: from mga02.intel.com ([134.134.136.20]:20814 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726721AbgDJXRK (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 10 Apr 2020 19:17:10 -0400
IronPort-SDR: zXaX8TPs9n25n01XElJb20nFOG0I+hqLkbXjz+55XBPF0y5a88KPYKjpCGzOvXcxCDwejlMWqg
 j1ybAM/6WouA==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Apr 2020 16:17:10 -0700
IronPort-SDR: 2Cu09jbKFyvsJU+NIboKqwB91wTC7sS18HZ68K9UU8zhRc8mGbfSkbfLtQJ+oGUqjjs63AbrEa
 cHF/j8wCSsjA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.72,368,1580803200"; 
   d="scan'208";a="452542224"
Received: from sjchrist-coffee.jf.intel.com ([10.54.74.202])
  by fmsmga005.fm.intel.com with ESMTP; 10 Apr 2020 16:17:09 -0700
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
Subject: [PATCH 03/10] KVM: selftests: Add util to delete memory region
Date:   Fri, 10 Apr 2020 16:17:00 -0700
Message-Id: <20200410231707.7128-4-sean.j.christopherson@intel.com>
X-Mailer: git-send-email 2.26.0
In-Reply-To: <20200410231707.7128-1-sean.j.christopherson@intel.com>
References: <20200410231707.7128-1-sean.j.christopherson@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Add a utility to delete a memory region, it will be used by x86's
set_memory_region_test.

Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
---
 .../testing/selftests/kvm/include/kvm_util.h  |  1 +
 tools/testing/selftests/kvm/lib/kvm_util.c    | 56 +++++++++++++------
 2 files changed, 40 insertions(+), 17 deletions(-)

diff --git a/tools/testing/selftests/kvm/include/kvm_util.h b/tools/testing/selftests/kvm/include/kvm_util.h
index 2f329e785c58..d4c3e4d9cd92 100644
--- a/tools/testing/selftests/kvm/include/kvm_util.h
+++ b/tools/testing/selftests/kvm/include/kvm_util.h
@@ -114,6 +114,7 @@ int _vcpu_ioctl(struct kvm_vm *vm, uint32_t vcpuid, unsigned long ioctl,
 void vm_ioctl(struct kvm_vm *vm, unsigned long ioctl, void *arg);
 void vm_mem_region_set_flags(struct kvm_vm *vm, uint32_t slot, uint32_t flags);
 void vm_mem_region_move(struct kvm_vm *vm, uint32_t slot, uint64_t new_gpa);
+void vm_mem_region_delete(struct kvm_vm *vm, uint32_t slot);
 void vm_vcpu_add(struct kvm_vm *vm, uint32_t vcpuid);
 vm_vaddr_t vm_vaddr_alloc(struct kvm_vm *vm, size_t sz, vm_vaddr_t vaddr_min,
 			  uint32_t data_memslot, uint32_t pgd_memslot);
diff --git a/tools/testing/selftests/kvm/lib/kvm_util.c b/tools/testing/selftests/kvm/lib/kvm_util.c
index 105ee9bc09f0..ab5b7ea60f4b 100644
--- a/tools/testing/selftests/kvm/lib/kvm_util.c
+++ b/tools/testing/selftests/kvm/lib/kvm_util.c
@@ -433,34 +433,38 @@ void kvm_vm_release(struct kvm_vm *vmp)
 		"  vmp->kvm_fd: %i rc: %i errno: %i", vmp->kvm_fd, ret, errno);
 }
 
+static void __vm_mem_region_delete(struct kvm_vm *vm,
+				   struct userspace_mem_region *region)
+{
+	int ret;
+
+	list_del(&region->list);
+
+	region->region.memory_size = 0;
+	ret = ioctl(vm->fd, KVM_SET_USER_MEMORY_REGION, &region->region);
+	TEST_ASSERT(ret == 0, "KVM_SET_USER_MEMORY_REGION IOCTL failed, "
+		    "rc: %i errno: %i", ret, errno);
+
+	sparsebit_free(&region->unused_phy_pages);
+	ret = munmap(region->mmap_start, region->mmap_size);
+	TEST_ASSERT(ret == 0, "munmap failed, rc: %i errno: %i", ret, errno);
+
+	free(region);
+}
+
 /*
  * Destroys and frees the VM pointed to by vmp.
  */
 void kvm_vm_free(struct kvm_vm *vmp)
 {
 	struct userspace_mem_region *region, *tmp;
-	int ret;
 
 	if (vmp == NULL)
 		return;
 
 	/* Free userspace_mem_regions. */
-	list_for_each_entry_safe(region, tmp, &vmp->userspace_mem_regions, list) {
-		list_del(&region->list);
-
-		region->region.memory_size = 0;
-		ret = ioctl(vmp->fd, KVM_SET_USER_MEMORY_REGION,
-			&region->region);
-		TEST_ASSERT(ret == 0, "KVM_SET_USER_MEMORY_REGION IOCTL failed, "
-			"rc: %i errno: %i", ret, errno);
-
-		sparsebit_free(&region->unused_phy_pages);
-		ret = munmap(region->mmap_start, region->mmap_size);
-		TEST_ASSERT(ret == 0, "munmap failed, rc: %i errno: %i",
-			    ret, errno);
-
-		free(region);
-	}
+	list_for_each_entry_safe(region, tmp, &vmp->userspace_mem_regions, list)
+		__vm_mem_region_delete(vmp, region);
 
 	/* Free sparsebit arrays. */
 	sparsebit_free(&vmp->vpages_valid);
@@ -775,6 +779,24 @@ void vm_mem_region_move(struct kvm_vm *vm, uint32_t slot, uint64_t new_gpa)
 		    ret, errno, slot, new_gpa);
 }
 
+/*
+ * VM Memory Region Delete
+ *
+ * Input Args:
+ *   vm - Virtual Machine
+ *   slot - Slot of the memory region to delete
+ *
+ * Output Args: None
+ *
+ * Return: None
+ *
+ * Delete a memory region.
+ */
+void vm_mem_region_delete(struct kvm_vm *vm, uint32_t slot)
+{
+	__vm_mem_region_delete(vm, memslot2region(vm, slot));
+}
+
 /*
  * VCPU mmap Size
  *
-- 
2.26.0

