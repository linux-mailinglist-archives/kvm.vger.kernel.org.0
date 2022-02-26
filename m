Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9FF444C52A2
	for <lists+kvm@lfdr.de>; Sat, 26 Feb 2022 01:19:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241024AbiBZASU (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 25 Feb 2022 19:18:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50296 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241444AbiBZARz (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 25 Feb 2022 19:17:55 -0500
Received: from mail-pg1-x54a.google.com (mail-pg1-x54a.google.com [IPv6:2607:f8b0:4864:20::54a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 306652272EA
        for <kvm@vger.kernel.org>; Fri, 25 Feb 2022 16:16:54 -0800 (PST)
Received: by mail-pg1-x54a.google.com with SMTP id b5-20020a631b05000000b00373bd90134dso3462940pgb.22
        for <kvm@vger.kernel.org>; Fri, 25 Feb 2022 16:16:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=reply-to:date:in-reply-to:message-id:mime-version:references
         :subject:from:to:cc;
        bh=+ihvawenlM+RVaDEQQYPtZrNBiUrDBlH+9+s6Q7Lpgg=;
        b=gi+AK6xiPwg8yu9CBcTyfHYef7XWZNnVoQKdY8/aXjUXsERCE0nm9lclBLqqNsXyiN
         BxgwOHKiIJ6xXSFIMIdy0dJynk2AfLQcrOVwVN+9xCU6DhB7++i99o/ZVpat7qEINVP/
         dOf5yjb3vUeCKhWb3Ot0z0Uq/Yq8Y53XbcNFZXRuArHSyqLPhx9yu6WugYFGdCmESrqa
         piy8r4w9N51N7fmM6D39bBLP/0PoXTHA//5BOUoXupZrzOIjeiS8yFter7hyVp36xdvO
         csPPbNPwXsFJOt3B1JZ2p9EQ8e1hKjJOkeatusfWeQpfXRr2hI8WjJLIWNhKMaMGzDHk
         QtLg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:reply-to:date:in-reply-to:message-id
         :mime-version:references:subject:from:to:cc;
        bh=+ihvawenlM+RVaDEQQYPtZrNBiUrDBlH+9+s6Q7Lpgg=;
        b=iOt1Q9dR6WV9ZOJbthd8Ak/RbQPpzv9NuBIFOyRmriJSEd4fZwN7O3Hc+XadC675mS
         TmQdi99cAQN+slL3+E56FrtA36vUQkYIzS2TVUpA3Cj1T49Ibm2A6n94KaCVXVIsm/kA
         rXv+PgR0m+WpXmGy+q9trBfMbkRlOiASMP2jubHl8L/PK3/9ciWuKRPJsYukbkKY34WU
         tgpWvaohm7jmJC66QaAbIhu1uYIwvJLKZXIlquTI4pfwxM1wpjWs7sbMdrcxvsUsgM5Z
         qeSG0FUrWUmfsn6CVzpy88Jojenb4bTkh4xLu9/iyGycT9Esug22DJy/fxV6ldNimIrt
         4SiQ==
X-Gm-Message-State: AOAM533e0PIE5gjuq13O+D1hpBmUovLj96f7HzyXUM5PYKysfBKwjZdh
        37mLRmwRpQ62m4hVqm+/P8s3d35xZUc=
X-Google-Smtp-Source: ABdhPJx+UIaYHh+lMWdP364BFZ+D4/nfCyFwVwf964cgqgQ6fWSrhGA4Dl7N8WsaGSdET2qADpF3LMCjOjg=
X-Received: from seanjc.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:3e5])
 (user=seanjc job=sendgmr) by 2002:aa7:874b:0:b0:4df:808f:2a1d with SMTP id
 g11-20020aa7874b000000b004df808f2a1dmr10259646pfo.68.1645834603632; Fri, 25
 Feb 2022 16:16:43 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Sat, 26 Feb 2022 00:15:43 +0000
In-Reply-To: <20220226001546.360188-1-seanjc@google.com>
Message-Id: <20220226001546.360188-26-seanjc@google.com>
Mime-Version: 1.0
References: <20220226001546.360188-1-seanjc@google.com>
X-Mailer: git-send-email 2.35.1.574.g5d30c73bfb-goog
Subject: [PATCH v3 25/28] KVM: selftests: Move raw KVM_SET_USER_MEMORY_REGION
 helper to utils
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>,
        Christian Borntraeger <borntraeger@linux.ibm.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        David Hildenbrand <david@redhat.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, David Matlack <dmatlack@google.com>,
        Ben Gardon <bgardon@google.com>,
        Mingwei Zhang <mizhang@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
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
2.35.1.574.g5d30c73bfb-goog

