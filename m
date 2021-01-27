Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 87F433062E4
	for <lists+kvm@lfdr.de>; Wed, 27 Jan 2021 19:01:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344003AbhA0SAj (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 27 Jan 2021 13:00:39 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:53133 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1343545AbhA0SAa (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 27 Jan 2021 13:00:30 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1611770342;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=xM3NmsWlQLbOeN4KfuSYLVfbjl0sV5BEAGILhGcJNwY=;
        b=TezWgwAmFn5k7tn37vCjwfaC3jxYgxcSKkNVPsaXodITJxlVxZABdqjmzOVKgyE2Y0qaQB
        yYXwRGEzN2Wa/Fp98CcxYnXG03nOZFaWT1OFIlbRc3f+7fbzqq18o4gflwjIFklBgWxVh/
        HQu90R2VwckVRntAJCZ/Kjm8/cuRDQs=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-37-7KW3MrEGO76xAyrUZz7eUg-1; Wed, 27 Jan 2021 12:58:06 -0500
X-MC-Unique: 7KW3MrEGO76xAyrUZz7eUg-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id B6E898030B1;
        Wed, 27 Jan 2021 17:58:04 +0000 (UTC)
Received: from vitty.brq.redhat.com (unknown [10.40.195.57])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 185A560917;
        Wed, 27 Jan 2021 17:57:48 +0000 (UTC)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Igor Mammedov <imammedo@redhat.com>,
        "Maciej S . Szmigiero" <maciej.szmigiero@oracle.com>
Subject: [PATCH 4/5] selftests: kvm: Test the newly introduced KVM_CAP_MEMSLOTS_LIMIT
Date:   Wed, 27 Jan 2021 18:57:30 +0100
Message-Id: <20210127175731.2020089-5-vkuznets@redhat.com>
In-Reply-To: <20210127175731.2020089-1-vkuznets@redhat.com>
References: <20210127175731.2020089-1-vkuznets@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The number of user memslots can now be limited with KVM_CAP_MEMSLOTS_LIMIT
and, when limited, per-VM KVM_CHECK_EXTENSION(KVM_CAP_NR_MEMSLOTS) should
return the updated value.

Signed-off-by: Vitaly Kuznetsov <vkuznets@redhat.com>
---
 .../testing/selftests/kvm/include/kvm_util.h  |  1 +
 tools/testing/selftests/kvm/lib/kvm_util.c    | 30 ++++++++++++-
 .../selftests/kvm/set_memory_region_test.c    | 43 ++++++++++++++++---
 3 files changed, 67 insertions(+), 7 deletions(-)

diff --git a/tools/testing/selftests/kvm/include/kvm_util.h b/tools/testing/selftests/kvm/include/kvm_util.h
index 5cbb861525ed..eb759a54dfc6 100644
--- a/tools/testing/selftests/kvm/include/kvm_util.h
+++ b/tools/testing/selftests/kvm/include/kvm_util.h
@@ -86,6 +86,7 @@ enum vm_mem_backing_src_type {
 };
 
 int kvm_check_cap(long cap);
+int vm_check_cap(struct kvm_vm *vm, long cap);
 int vm_enable_cap(struct kvm_vm *vm, struct kvm_enable_cap *cap);
 int vcpu_enable_cap(struct kvm_vm *vm, uint32_t vcpu_id,
 		    struct kvm_enable_cap *cap);
diff --git a/tools/testing/selftests/kvm/lib/kvm_util.c b/tools/testing/selftests/kvm/lib/kvm_util.c
index fa5a90e6c6f0..115947b77808 100644
--- a/tools/testing/selftests/kvm/lib/kvm_util.c
+++ b/tools/testing/selftests/kvm/lib/kvm_util.c
@@ -31,7 +31,7 @@ static void *align(void *x, size_t size)
 }
 
 /*
- * Capability
+ * Check a global capability
  *
  * Input Args:
  *   cap - Capability
@@ -64,6 +64,34 @@ int kvm_check_cap(long cap)
 	return ret;
 }
 
+/*
+ * Check a per-VM capability
+ *
+ * Input Args:
+ *   vm - Virtual Machine
+ *   cap - Capability
+ *
+ * Output Args: None
+ *
+ * Return:
+ *   On success, the Value corresponding to the capability (KVM_CAP_*)
+ *   specified by the value of cap.  On failure a TEST_ASSERT failure
+ *   is produced.
+ *
+ * Looks up and returns the value corresponding to the capability
+ * (KVM_CAP_*) given by cap.
+ */
+int vm_check_cap(struct kvm_vm *vm, long cap)
+{
+	int ret;
+
+	ret = ioctl(vm->fd, KVM_CHECK_EXTENSION, cap);
+	TEST_ASSERT(ret != -1, "KVM_CHECK_EXTENSION IOCTL failed,\n"
+		"  rc: %i errno: %i", ret, errno);
+
+	return ret;
+}
+
 /* VM Enable Capability
  *
  * Input Args:
diff --git a/tools/testing/selftests/kvm/set_memory_region_test.c b/tools/testing/selftests/kvm/set_memory_region_test.c
index f127ed31dba7..66ed011f26f3 100644
--- a/tools/testing/selftests/kvm/set_memory_region_test.c
+++ b/tools/testing/selftests/kvm/set_memory_region_test.c
@@ -330,14 +330,14 @@ static void test_zero_memory_regions(void)
 #endif /* __x86_64__ */
 
 /*
- * Test it can be added memory slots up to KVM_CAP_NR_MEMSLOTS, then any
- * tentative to add further slots should fail.
+ * Test it can be added memory slots up to KVM_CAP_NR_MEMSLOTS/given limit,
+ * then any tentative to add further slots should fail.
  */
-static void test_add_max_memory_regions(void)
+static void test_add_max_memory_regions(int limit)
 {
 	int ret;
 	struct kvm_vm *vm;
-	uint32_t max_mem_slots;
+	uint32_t max_mem_slots, vm_mem_slots;
 	uint32_t slot;
 	uint64_t guest_addr = 0x0;
 	uint64_t mem_reg_npages;
@@ -346,10 +346,38 @@ static void test_add_max_memory_regions(void)
 	max_mem_slots = kvm_check_cap(KVM_CAP_NR_MEMSLOTS);
 	TEST_ASSERT(max_mem_slots > 0,
 		    "KVM_CAP_NR_MEMSLOTS should be greater than 0");
-	pr_info("Allowed number of memory slots: %i\n", max_mem_slots);
+
+	if (!limit)
+		pr_info("Allowed number of memory slots: %i\n", max_mem_slots);
 
 	vm = vm_create(VM_MODE_DEFAULT, 0, O_RDWR);
 
+	if (limit) {
+		struct kvm_enable_cap cap = {
+			.cap = KVM_CAP_MEMSLOTS_LIMIT,
+			.args[0] = limit
+		};
+
+		pr_info("Default max number of memory slots: %i\n", max_mem_slots);
+
+		vm_mem_slots = vm_check_cap(vm, KVM_CAP_NR_MEMSLOTS);
+		TEST_ASSERT(vm_mem_slots == max_mem_slots,
+			    "KVM_CAP_NR_MEMSLOTS for a newly created VM: %d"
+			    " should equal to the global limit: %d",
+			    vm_mem_slots, max_mem_slots);
+
+		pr_info("Limiting the number of memory slots to: %i\n", limit);
+
+		vm_enable_cap(vm, &cap);
+		vm_mem_slots = vm_check_cap(vm, KVM_CAP_NR_MEMSLOTS);
+		TEST_ASSERT(vm_mem_slots == limit,
+			    "KVM_CAP_NR_MEMSLOTS was limited to: %d"
+			    " but is currently set to %d instead",
+			    limit, vm_mem_slots);
+
+		max_mem_slots = vm_mem_slots;
+	}
+
 	mem_reg_npages = vm_calc_num_guest_pages(VM_MODE_DEFAULT, MEM_REGION_SIZE);
 
 	/* Check it can be added memory slots up to the maximum allowed */
@@ -394,7 +422,10 @@ int main(int argc, char *argv[])
 	test_zero_memory_regions();
 #endif
 
-	test_add_max_memory_regions();
+	test_add_max_memory_regions(0);
+
+	test_add_max_memory_regions(10);
+
 
 #ifdef __x86_64__
 	if (argc > 1)
-- 
2.29.2

