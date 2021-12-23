Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 108B147E987
	for <lists+kvm@lfdr.de>; Thu, 23 Dec 2021 23:28:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350574AbhLWW2a (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 23 Dec 2021 17:28:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38738 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1350517AbhLWWZt (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 23 Dec 2021 17:25:49 -0500
Received: from mail-pg1-x549.google.com (mail-pg1-x549.google.com [IPv6:2607:f8b0:4864:20::549])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 44C42C06175B
        for <kvm@vger.kernel.org>; Thu, 23 Dec 2021 14:24:26 -0800 (PST)
Received: by mail-pg1-x549.google.com with SMTP id s22-20020a63d056000000b0033b09af4d13so3879044pgi.13
        for <kvm@vger.kernel.org>; Thu, 23 Dec 2021 14:24:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=reply-to:date:in-reply-to:message-id:mime-version:references
         :subject:from:to:cc;
        bh=NTWd/eLJg+oZzoP/2OC3KeQ8hrwm8MCA9hvEYELSgZQ=;
        b=BJbFbs6zx3b6NONCJh1BbEu1gCLTZ/pCoIckyh0v7CG8BpEflV8SaWjY3KyGRv6vty
         JqDIHR8WvJMmsGtNl7EhrpbYh85gLPUKYkLFHjDXbXdh642hy4OrInO4jyTA4Y3BzHi4
         MVGEO5q7YTqz6IuTrBJD89czl7SrvD8H6H2jX/8XDs5EGiIL2zFIKOPIsGzx2LLjPqmX
         3HYr7IaDEPZw3zqpXNyA4hpSxFthe4nhZ2Bu5a8lzV8+colY89dLU7xYa5WnKL37rx5P
         vTDKgXLwN88QSRBxEVcE6jOjRh8nWzO9DPKkKUodkDHNtv5f2/rSPOprahd21ZEqgtkE
         A9yg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:reply-to:date:in-reply-to:message-id
         :mime-version:references:subject:from:to:cc;
        bh=NTWd/eLJg+oZzoP/2OC3KeQ8hrwm8MCA9hvEYELSgZQ=;
        b=8L0vK4L0ly/xwHbepeDy/d7KQULyD/fexW/C+PN3xtusArSDx6qQ0JJLpko/g/RO4M
         YGMqpipiWF3+4tkAWtY9lq98AEe8Mzp9rHIlwvCQnLCVm31lqKcHlnV44yZQPgqaKmzm
         nd/dEzNSJJFiqWd6fRYRSfLIl6bHC16OCb/abV/m9MTeMFGWJpdIiA+OC5dYdlgVCtU6
         xX0APzoiyDU8NTJX8EIZ1rWgP4OR/AtL9DwHwXbbcWaOWH6oEDK2hpWvQ82uUCLahN51
         0ujk1GkTJcNuJrEk3n5/oU8KAkYfmPvLM1z///qchl3y3eTKDENerT0qO2m0WxLdhcDg
         K+xQ==
X-Gm-Message-State: AOAM530AR3r4ihfgNGLXEvs6Q+n4rcT1e21kLRH8lrn4hoLX+4P9Fgzd
        ROjfavUY0Cd2FqbpAwHAmX/m9taa7fI=
X-Google-Smtp-Source: ABdhPJwsc10SoowlAMp1LP+rgARsIGn5+UkTI3VN7Tm8sl6hGezd+4vtPjQ03g92/ZC5uIwUkBnn8V3Mpxo=
X-Received: from seanjc.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:3e5])
 (user=seanjc job=sendgmr) by 2002:a17:90b:343:: with SMTP id
 fh3mr4768409pjb.35.1640298265813; Thu, 23 Dec 2021 14:24:25 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Thu, 23 Dec 2021 22:23:15 +0000
In-Reply-To: <20211223222318.1039223-1-seanjc@google.com>
Message-Id: <20211223222318.1039223-28-seanjc@google.com>
Mime-Version: 1.0
References: <20211223222318.1039223-1-seanjc@google.com>
X-Mailer: git-send-email 2.34.1.448.ga2b2bfdf31-goog
Subject: [PATCH v2 27/30] KVM: selftests: Move raw KVM_SET_USER_MEMORY_REGION
 helper to utils
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Ben Gardon <bgardon@google.com>,
        David Matlack <dmatlack@google.com>,
        Mingwei Zhang <mizhang@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Move set_memory_region_test's KVM_SET_USER_MEMORY_REGION helper to KVM's
utils so that it can be used by other tests.  Provide a raw version as
well as an assert-success version to reduce the amount of boilerplate
code need for basic usage.

No functional change intended.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 .../testing/selftests/kvm/include/kvm_util.h  |  5 +++
 tools/testing/selftests/kvm/lib/kvm_util.c    | 24 +++++++++++++
 .../selftests/kvm/set_memory_region_test.c    | 35 +++++--------------
 3 files changed, 37 insertions(+), 27 deletions(-)

diff --git a/tools/testing/selftests/kvm/include/kvm_util.h b/tools/testing/selftests/kvm/include/kvm_util.h
index 2d62edc49d67..fba971189390 100644
--- a/tools/testing/selftests/kvm/include/kvm_util.h
+++ b/tools/testing/selftests/kvm/include/kvm_util.h
@@ -128,6 +128,11 @@ void vcpu_dump(FILE *stream, struct kvm_vm *vm, uint32_t vcpuid,
 
 void vm_create_irqchip(struct kvm_vm *vm);
 
+void vm_set_user_memory_region(struct kvm_vm *vm, uint32_t slot, uint32_t flags,
+			       uint64_t gpa, uint64_t size, void *hva);
+int __vm_set_user_memory_region(struct kvm_vm *vm, uint32_t slot, uint32_t flags,
+				uint64_t gpa, uint64_t size, void *hva);
+
 void vm_userspace_mem_region_add(struct kvm_vm *vm,
 	enum vm_mem_backing_src_type src_type,
 	uint64_t guest_paddr, uint32_t slot, uint64_t npages,
diff --git a/tools/testing/selftests/kvm/lib/kvm_util.c b/tools/testing/selftests/kvm/lib/kvm_util.c
index 53d2b5d04b82..45f39dd9b4da 100644
--- a/tools/testing/selftests/kvm/lib/kvm_util.c
+++ b/tools/testing/selftests/kvm/lib/kvm_util.c
@@ -779,6 +779,30 @@ static void vm_userspace_mem_region_hva_insert(struct rb_root *hva_tree,
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
2.34.1.448.ga2b2bfdf31-goog

