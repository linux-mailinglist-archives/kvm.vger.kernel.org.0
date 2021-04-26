Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B656236B3B3
	for <lists+kvm@lfdr.de>; Mon, 26 Apr 2021 15:01:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233567AbhDZNCP (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 26 Apr 2021 09:02:15 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:25865 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233549AbhDZNCK (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 26 Apr 2021 09:02:10 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1619442089;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=+/MOXnX9h7hR/cxq9q03AL7bpej16e5GaIUuHzQUeWc=;
        b=YBWBCoS6voYBYJ8E0/m7MlI+YdmY9XeMnAvphj7mwFUZGwCbML/rh4FdaPIV/5OWQ85VIR
        olAISZzqTObtTS8Wf8eg+X14HKCpdDgx9MrF4itS7C7EvLkJDI2lBQEpudWqHTKE5+Wxmv
        9eYYs40H6G0Y3bXF3HxWq39B5MtJYes=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-339-_QcW6wdhPr6ldfNflr999w-1; Mon, 26 Apr 2021 09:01:25 -0400
X-MC-Unique: _QcW6wdhPr6ldfNflr999w-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 473861922963;
        Mon, 26 Apr 2021 13:01:24 +0000 (UTC)
Received: from vitty.brq.redhat.com (unknown [10.40.195.54])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 4B41C5C1CF;
        Mon, 26 Apr 2021 13:01:22 +0000 (UTC)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        kernel test robot <oliver.sang@intel.com>,
        linux-kernel@vger.kernel.org
Subject: [PATCH] KVM: selftests: Speed up set_memory_region_test
Date:   Mon, 26 Apr 2021 15:01:21 +0200
Message-Id: <20210426130121.758229-1-vkuznets@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

After commit 4fc096a99e01 ("KVM: Raise the maximum number of user memslots")
set_memory_region_test may take too long, reports are that the default
timeout value we have (120s) may not be enough even on a physical host.

Speed things up a bit by throwing away vm_userspace_mem_region_add() usage
from test_add_max_memory_regions(), we don't really need to do the majority
of the stuff it does for the sake of this test.

On my AMD EPYC 7401P, # time ./set_memory_region_test
pre-patch:
 Testing KVM_RUN with zero added memory regions
 Allowed number of memory slots: 32764
 Adding slots 0..32763, each memory region with 2048K size
 Testing MOVE of in-use region, 10 loops
 Testing DELETE of in-use region, 10 loops

 real	0m44.917s
 user	0m7.416s
 sys	0m34.601s

post-patch:
 Testing KVM_RUN with zero added memory regions
 Allowed number of memory slots: 32764
 Adding slots 0..32763, each memory region with 2048K size
 Testing MOVE of in-use region, 10 loops
 Testing DELETE of in-use region, 10 loops

 real	0m20.714s
 user	0m0.109s
 sys	0m18.359s

Reported-by: kernel test robot <oliver.sang@intel.com>
Signed-off-by: Vitaly Kuznetsov <vkuznets@redhat.com>
---
 .../selftests/kvm/set_memory_region_test.c    | 61 ++++++++++++++-----
 1 file changed, 45 insertions(+), 16 deletions(-)

diff --git a/tools/testing/selftests/kvm/set_memory_region_test.c b/tools/testing/selftests/kvm/set_memory_region_test.c
index f127ed31dba7..978f5b5f4dc0 100644
--- a/tools/testing/selftests/kvm/set_memory_region_test.c
+++ b/tools/testing/selftests/kvm/set_memory_region_test.c
@@ -329,6 +329,22 @@ static void test_zero_memory_regions(void)
 }
 #endif /* __x86_64__ */
 
+static int test_memory_region_add(struct kvm_vm *vm, void *mem, uint32_t slot,
+				   uint32_t size, uint64_t guest_addr)
+{
+	struct kvm_userspace_memory_region region;
+	int ret;
+
+	region.slot = slot;
+	region.flags = 0;
+	region.guest_phys_addr = guest_addr;
+	region.memory_size = size;
+	region.userspace_addr = (uintptr_t) mem;
+	ret = ioctl(vm_get_fd(vm), KVM_SET_USER_MEMORY_REGION, &region);
+
+	return ret;
+}
+
 /*
  * Test it can be added memory slots up to KVM_CAP_NR_MEMSLOTS, then any
  * tentative to add further slots should fail.
@@ -339,9 +355,15 @@ static void test_add_max_memory_regions(void)
 	struct kvm_vm *vm;
 	uint32_t max_mem_slots;
 	uint32_t slot;
-	uint64_t guest_addr = 0x0;
-	uint64_t mem_reg_npages;
-	void *mem;
+	void *mem, *mem_aligned, *mem_extra;
+	size_t alignment;
+
+#ifdef __s390x__
+	/* On s390x, the host address must be aligned to 1M (due to PGSTEs) */
+	alignment = 0x100000;
+#else
+	alignment = 1;
+#endif
 
 	max_mem_slots = kvm_check_cap(KVM_CAP_NR_MEMSLOTS);
 	TEST_ASSERT(max_mem_slots > 0,
@@ -350,30 +372,37 @@ static void test_add_max_memory_regions(void)
 
 	vm = vm_create(VM_MODE_DEFAULT, 0, O_RDWR);
 
-	mem_reg_npages = vm_calc_num_guest_pages(VM_MODE_DEFAULT, MEM_REGION_SIZE);
-
 	/* Check it can be added memory slots up to the maximum allowed */
 	pr_info("Adding slots 0..%i, each memory region with %dK size\n",
 		(max_mem_slots - 1), MEM_REGION_SIZE >> 10);
+
+	mem = mmap(NULL, MEM_REGION_SIZE * max_mem_slots + alignment,
+		   PROT_READ | PROT_WRITE, MAP_PRIVATE | MAP_ANONYMOUS, -1, 0);
+	TEST_ASSERT(mem != MAP_FAILED, "Failed to mmap() host");
+	mem_aligned = (void *)(((size_t) mem + alignment - 1) & ~(alignment - 1));
+
 	for (slot = 0; slot < max_mem_slots; slot++) {
-		vm_userspace_mem_region_add(vm, VM_MEM_SRC_ANONYMOUS,
-					    guest_addr, slot, mem_reg_npages,
-					    0);
-		guest_addr += MEM_REGION_SIZE;
+		ret = test_memory_region_add(vm, mem_aligned +
+					     ((uint64_t)slot * MEM_REGION_SIZE),
+					     slot, MEM_REGION_SIZE,
+					     (uint64_t)slot * MEM_REGION_SIZE);
+		TEST_ASSERT(ret == 0, "KVM_SET_USER_MEMORY_REGION IOCTL failed,\n"
+			    "  rc: %i errno: %i slot: %i\n",
+			    ret, errno, slot);
 	}
 
 	/* Check it cannot be added memory slots beyond the limit */
-	mem = mmap(NULL, MEM_REGION_SIZE, PROT_READ | PROT_WRITE,
-		   MAP_PRIVATE | MAP_ANONYMOUS, -1, 0);
-	TEST_ASSERT(mem != MAP_FAILED, "Failed to mmap() host");
+	mem_extra = mmap(NULL, MEM_REGION_SIZE, PROT_READ | PROT_WRITE,
+			 MAP_PRIVATE | MAP_ANONYMOUS, -1, 0);
+	TEST_ASSERT(mem_extra != MAP_FAILED, "Failed to mmap() host");
 
-	ret = ioctl(vm_get_fd(vm), KVM_SET_USER_MEMORY_REGION,
-		    &(struct kvm_userspace_memory_region) {slot, 0, guest_addr,
-		    MEM_REGION_SIZE, (uint64_t) mem});
+	ret = test_memory_region_add(vm, mem_extra, max_mem_slots, MEM_REGION_SIZE,
+				     (uint64_t)max_mem_slots * MEM_REGION_SIZE);
 	TEST_ASSERT(ret == -1 && errno == EINVAL,
 		    "Adding one more memory slot should fail with EINVAL");
 
-	munmap(mem, MEM_REGION_SIZE);
+	munmap(mem, MEM_REGION_SIZE * max_mem_slots + alignment);
+	munmap(mem_extra, MEM_REGION_SIZE);
 	kvm_vm_free(vm);
 }
 
-- 
2.30.2

