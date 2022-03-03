Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 86D734CC656
	for <lists+kvm@lfdr.de>; Thu,  3 Mar 2022 20:41:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236267AbiCCTla (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 3 Mar 2022 14:41:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33880 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236198AbiCCTkw (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 3 Mar 2022 14:40:52 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 9A9131A615D
        for <kvm@vger.kernel.org>; Thu,  3 Mar 2022 11:39:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1646336362;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=80NKQcnoxJqdqNMFcuhq1sCr+ueHBMeLSlxdZvx+3+k=;
        b=Nm5tF6p67HPP10NAXnEPfvXR0mACGoC5QEc26sClTcT7ndZxszEqy/flsb/avGkMbIZRZS
        mVXDFHGPUHT6UKjZxVOoUT17dyRq16yUASmlp3dwfY1Pdb1qVMIYisX4aHnrIzsH66D5tw
        TTYmOFwjKjKovE9FGdP7VZPVlCAXHRU=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-266-NsoSNMXkNFy7-5gFudKZFQ-1; Thu, 03 Mar 2022 14:39:19 -0500
X-MC-Unique: NsoSNMXkNFy7-5gFudKZFQ-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 6DA0E1883522;
        Thu,  3 Mar 2022 19:39:18 +0000 (UTC)
Received: from virtlab701.virt.lab.eng.bos.redhat.com (virtlab701.virt.lab.eng.bos.redhat.com [10.19.152.228])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 9A6F85FC22;
        Thu,  3 Mar 2022 19:39:17 +0000 (UTC)
From:   Paolo Bonzini <pbonzini@redhat.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        David Hildenbrand <david@redhat.com>,
        David Matlack <dmatlack@google.com>,
        Ben Gardon <bgardon@google.com>,
        Mingwei Zhang <mizhang@google.com>
Subject: [PATCH v4 27/30] KVM: selftests: Move raw KVM_SET_USER_MEMORY_REGION helper to utils
Date:   Thu,  3 Mar 2022 14:38:39 -0500
Message-Id: <20220303193842.370645-28-pbonzini@redhat.com>
In-Reply-To: <20220303193842.370645-1-pbonzini@redhat.com>
References: <20220303193842.370645-1-pbonzini@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
X-Spam-Status: No, score=-3.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Sean Christopherson <seanjc@google.com>

Move set_memory_region_test's KVM_SET_USER_MEMORY_REGION helper to KVM's
utils so that it can be used by other tests.  Provide a raw version as
well as an assert-success version to reduce the amount of boilerplate
code need for basic usage.

No functional change intended.

Signed-off-by: Sean Christopherson <seanjc@google.com>
Message-Id: <20220226001546.360188-26-seanjc@google.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 .../selftests/kvm/include/kvm_util_base.h     |  4 +++
 tools/testing/selftests/kvm/lib/kvm_util.c    | 24 +++++++++++++
 .../selftests/kvm/set_memory_region_test.c    | 35 +++++--------------
 3 files changed, 36 insertions(+), 27 deletions(-)

diff --git a/tools/testing/selftests/kvm/include/kvm_util_base.h b/tools/testing/selftests/kvm/include/kvm_util_base.h
index f987cf7c0d2e..573de0354175 100644
--- a/tools/testing/selftests/kvm/include/kvm_util_base.h
+++ b/tools/testing/selftests/kvm/include/kvm_util_base.h
@@ -147,6 +147,10 @@ void vcpu_dump(FILE *stream, struct kvm_vm *vm, uint32_t vcpuid,
 
 void vm_create_irqchip(struct kvm_vm *vm);
 
+void vm_set_user_memory_region(struct kvm_vm *vm, uint32_t slot, uint32_t flags,
+			       uint64_t gpa, uint64_t size, void *hva);
+int __vm_set_user_memory_region(struct kvm_vm *vm, uint32_t slot, uint32_t flags,
+				uint64_t gpa, uint64_t size, void *hva);
 void vm_userspace_mem_region_add(struct kvm_vm *vm,
 	enum vm_mem_backing_src_type src_type,
 	uint64_t guest_paddr, uint32_t slot, uint64_t npages,
diff --git a/tools/testing/selftests/kvm/lib/kvm_util.c b/tools/testing/selftests/kvm/lib/kvm_util.c
index 64618032aa58..dcb8e96c6a54 100644
--- a/tools/testing/selftests/kvm/lib/kvm_util.c
+++ b/tools/testing/selftests/kvm/lib/kvm_util.c
@@ -839,6 +839,30 @@ static void vm_userspace_mem_region_hva_insert(struct rb_root *hva_tree,
 	rb_insert_color(&region->hva_node, hva_tree);
 }
 
+
+int __vm_set_user_memory_region(struct kvm_vm *vm, uint32_t slot, uint32_t flags,
+				uint64_t gpa, uint64_t size, void *hva)
+{
+	struct kvm_userspace_memory_region region = {
+		.slot = slot,
+		.flags = flags,
+		.guest_phys_addr = gpa,
+		.memory_size = size,
+		.userspace_addr = (uintptr_t)hva,
+	};
+
+	return ioctl(vm->fd, KVM_SET_USER_MEMORY_REGION, &region);
+}
+
+void vm_set_user_memory_region(struct kvm_vm *vm, uint32_t slot, uint32_t flags,
+			       uint64_t gpa, uint64_t size, void *hva)
+{
+	int ret = __vm_set_user_memory_region(vm, slot, flags, gpa, size, hva);
+
+	TEST_ASSERT(!ret, "KVM_SET_USER_MEMORY_REGION failed, errno = %d (%s)",
+		    errno, strerror(errno));
+}
+
 /*
  * VM Userspace Memory Region Add
  *
diff --git a/tools/testing/selftests/kvm/set_memory_region_test.c b/tools/testing/selftests/kvm/set_memory_region_test.c
index 72a1c9b4882c..73bc297dabe6 100644
--- a/tools/testing/selftests/kvm/set_memory_region_test.c
+++ b/tools/testing/selftests/kvm/set_memory_region_test.c
@@ -329,22 +329,6 @@ static void test_zero_memory_regions(void)
 }
 #endif /* __x86_64__ */
 
-static int test_memory_region_add(struct kvm_vm *vm, void *mem, uint32_t slot,
-				   uint32_t size, uint64_t guest_addr)
-{
-	struct kvm_userspace_memory_region region;
-	int ret;
-
-	region.slot = slot;
-	region.flags = 0;
-	region.guest_phys_addr = guest_addr;
-	region.memory_size = size;
-	region.userspace_addr = (uintptr_t) mem;
-	ret = ioctl(vm_get_fd(vm), KVM_SET_USER_MEMORY_REGION, &region);
-
-	return ret;
-}
-
 /*
  * Test it can be added memory slots up to KVM_CAP_NR_MEMSLOTS, then any
  * tentative to add further slots should fail.
@@ -382,23 +366,20 @@ static void test_add_max_memory_regions(void)
 	TEST_ASSERT(mem != MAP_FAILED, "Failed to mmap() host");
 	mem_aligned = (void *)(((size_t) mem + alignment - 1) & ~(alignment - 1));
 
-	for (slot = 0; slot < max_mem_slots; slot++) {
-		ret = test_memory_region_add(vm, mem_aligned +
-					     ((uint64_t)slot * MEM_REGION_SIZE),
-					     slot, MEM_REGION_SIZE,
-					     (uint64_t)slot * MEM_REGION_SIZE);
-		TEST_ASSERT(ret == 0, "KVM_SET_USER_MEMORY_REGION IOCTL failed,\n"
-			    "  rc: %i errno: %i slot: %i\n",
-			    ret, errno, slot);
-	}
+	for (slot = 0; slot < max_mem_slots; slot++)
+		vm_set_user_memory_region(vm, slot, 0,
+					  ((uint64_t)slot * MEM_REGION_SIZE),
+					  MEM_REGION_SIZE,
+					  mem_aligned + (uint64_t)slot * MEM_REGION_SIZE);
 
 	/* Check it cannot be added memory slots beyond the limit */
 	mem_extra = mmap(NULL, MEM_REGION_SIZE, PROT_READ | PROT_WRITE,
 			 MAP_PRIVATE | MAP_ANONYMOUS, -1, 0);
 	TEST_ASSERT(mem_extra != MAP_FAILED, "Failed to mmap() host");
 
-	ret = test_memory_region_add(vm, mem_extra, max_mem_slots, MEM_REGION_SIZE,
-				     (uint64_t)max_mem_slots * MEM_REGION_SIZE);
+	ret = __vm_set_user_memory_region(vm, max_mem_slots, 0,
+					  (uint64_t)max_mem_slots * MEM_REGION_SIZE,
+					  MEM_REGION_SIZE, mem_extra);
 	TEST_ASSERT(ret == -1 && errno == EINVAL,
 		    "Adding one more memory slot should fail with EINVAL");
 
-- 
2.31.1


