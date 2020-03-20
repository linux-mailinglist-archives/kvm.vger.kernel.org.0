Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 609C018D9C4
	for <lists+kvm@lfdr.de>; Fri, 20 Mar 2020 21:56:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727278AbgCTUzu (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 20 Mar 2020 16:55:50 -0400
Received: from mga11.intel.com ([192.55.52.93]:32133 "EHLO mga11.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727239AbgCTUzt (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 20 Mar 2020 16:55:49 -0400
IronPort-SDR: ZDqmjQ3WRtqT4fuHqgn3iW7oyRqJZd2zzZaGzyDkP4xR6QxejhCn+E+FDaOXq/ynY62b6JgT/E
 asBb4BAwaadg==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Mar 2020 13:55:49 -0700
IronPort-SDR: HUedZPOcKoeRnrtk/PXMNnf0CuC3dYa4TPb0nwO+slqSjfA/dpGuLYKiCB7vzRBeMqmRxwr5VD
 4o3IX90/WHOA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.72,285,1580803200"; 
   d="scan'208";a="280543330"
Received: from sjchrist-coffee.jf.intel.com ([10.54.74.202])
  by fmsmga002.fm.intel.com with ESMTP; 20 Mar 2020 13:55:48 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Christian Borntraeger <borntraeger@de.ibm.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     David Hildenbrand <david@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Qian Cai <cai@lca.pw>,
        Peter Xu <peterx@redhat.com>
Subject: [PATCH 5/7] KVM: selftests: Add util to delete memory region
Date:   Fri, 20 Mar 2020 13:55:44 -0700
Message-Id: <20200320205546.2396-6-sean.j.christopherson@intel.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200320205546.2396-1-sean.j.christopherson@intel.com>
References: <20200320205546.2396-1-sean.j.christopherson@intel.com>
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
 tools/testing/selftests/kvm/lib/kvm_util.c    | 60 ++++++++++++-------
 2 files changed, 40 insertions(+), 21 deletions(-)

diff --git a/tools/testing/selftests/kvm/include/kvm_util.h b/tools/testing/selftests/kvm/include/kvm_util.h
index a99b875f50d2..0f0e86e188c4 100644
--- a/tools/testing/selftests/kvm/include/kvm_util.h
+++ b/tools/testing/selftests/kvm/include/kvm_util.h
@@ -113,6 +113,7 @@ int _vcpu_ioctl(struct kvm_vm *vm, uint32_t vcpuid, unsigned long ioctl,
 void vm_ioctl(struct kvm_vm *vm, unsigned long ioctl, void *arg);
 void vm_mem_region_set_flags(struct kvm_vm *vm, uint32_t slot, uint32_t flags);
 void vm_mem_region_move(struct kvm_vm *vm, uint32_t slot, uint64_t new_gpa);
+void vm_mem_region_delete(struct kvm_vm *vm, uint32_t slot);
 void vm_vcpu_add(struct kvm_vm *vm, uint32_t vcpuid);
 vm_vaddr_t vm_vaddr_alloc(struct kvm_vm *vm, size_t sz, vm_vaddr_t vaddr_min,
 			  uint32_t data_memslot, uint32_t pgd_memslot);
diff --git a/tools/testing/selftests/kvm/lib/kvm_util.c b/tools/testing/selftests/kvm/lib/kvm_util.c
index d7b74f465570..f69fa84c9a4c 100644
--- a/tools/testing/selftests/kvm/lib/kvm_util.c
+++ b/tools/testing/selftests/kvm/lib/kvm_util.c
@@ -451,36 +451,36 @@ void kvm_vm_release(struct kvm_vm *vmp)
 		"  vmp->kvm_fd: %i rc: %i errno: %i", vmp->kvm_fd, ret, errno);
 }
 
+static void __vm_mem_region_delete(struct kvm_vm *vm,
+				   struct userspace_mem_region *region)
+{
+	int ret;
+
+	kvm_list_del(vm->userspace_mem_region_head, region);
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
-	int ret;
-
 	if (vmp == NULL)
 		return;
 
 	/* Free userspace_mem_regions. */
-	while (vmp->userspace_mem_region_head) {
-		struct userspace_mem_region *region
-			= vmp->userspace_mem_region_head;
-
-		kvm_list_del(vmp->userspace_mem_region_head, region);
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
+	while (vmp->userspace_mem_region_head)
+		__vm_mem_region_delete(vmp, vmp->userspace_mem_region_head);
 
 	/* Free sparsebit arrays. */
 	sparsebit_free(&vmp->vpages_valid);
@@ -797,6 +797,24 @@ void vm_mem_region_move(struct kvm_vm *vm, uint32_t slot, uint64_t new_gpa)
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
2.24.1

