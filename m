Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0DEA35153D6
	for <lists+kvm@lfdr.de>; Fri, 29 Apr 2022 20:39:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1380073AbiD2SnF (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 29 Apr 2022 14:43:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35852 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1359759AbiD2SnE (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 29 Apr 2022 14:43:04 -0400
Received: from mail-pf1-x44a.google.com (mail-pf1-x44a.google.com [IPv6:2607:f8b0:4864:20::44a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AD5D1D64C7
        for <kvm@vger.kernel.org>; Fri, 29 Apr 2022 11:39:45 -0700 (PDT)
Received: by mail-pf1-x44a.google.com with SMTP id i19-20020aa79093000000b0050d44b83506so4551977pfa.22
        for <kvm@vger.kernel.org>; Fri, 29 Apr 2022 11:39:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=Lae+OTId74MWDDAUiScLgZRF0Bn5hrr1t6aBaPS6xDM=;
        b=ZN22D5TNK2jNXTqIBP/FxfLVW3oXhxOENvV2jjKgN3OvVSx048Wv4BG8OEQYIVXk75
         lJWy07GrdtpMMpQG2RIdaA2wXAET2GBXRb/kw3VCpHbtRtr1hs0TstVcHRE6Vmm4Ul34
         hk16yhS/g6lgVh4dk8poSP0el9ZoVwRz3J+7RMLQc1H+v7BNptAg6vzufQDz5EjXF1ad
         jRX7I62DZUnmQBpTD+sl7I7ezsbEKs5jWAGtLFzMvBTEvzvaOMrszZHlh3yeRL/+8jUd
         oyqq+Wkz2SWhGD+CJ4gjQQM/c9WHPZzxry54fnjrV2kgGwNhsNrOsC1IpaIFciBG+uAP
         6NWw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=Lae+OTId74MWDDAUiScLgZRF0Bn5hrr1t6aBaPS6xDM=;
        b=fQDsFuT+vdmSJNr7hOXDJbvd2Vs761Q4zXWkU4Ejm8R/w74z/fYe/ZyBGc81XRjps5
         1QMo3Ye3o4l9fOtoVF7JrbeSXivpdPGipaJQPnVNiWhuy3+fVExIVyJ6hFnSkzHns0co
         tYkPyQMsj6bxd4hqLvEfkIYP8/cTBdRXFcnUedbiahG5kPET7m8HByIC8Criu6CB2za9
         Y/l+wtNLosJouNcT/0xozMoTb2HvFX2qrNVS42FEdwtHr4P+X1kDXykrfahTYmWfTg5/
         uVfH2HQb+G7IjNo770G+air5JkgVcZMKaO9DoItbt3C/prrzIUhP+xI2kPyqLzgJowQ2
         kR9w==
X-Gm-Message-State: AOAM532FZRABekmItzJsOEjdkl5ePVoXMUYMXkw3cazfu+kDk309QH9Y
        5iSRU8yaXgr+uy86XuzOheTKWoOC4vYlxw==
X-Google-Smtp-Source: ABdhPJx9bvX2UVkTXHY+DCKjNe8Eo/qxZZmJx1pUqYjXf4kf4RryjjZNyNVO+k5rXAgVMLffAC2fbs9eyiJH5Q==
X-Received: from dmatlack-heavy.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:19cd])
 (user=dmatlack job=sendgmr) by 2002:a17:902:6b83:b0:15d:1ea2:4f80 with SMTP
 id p3-20020a1709026b8300b0015d1ea24f80mr681304plk.41.1651257585187; Fri, 29
 Apr 2022 11:39:45 -0700 (PDT)
Date:   Fri, 29 Apr 2022 18:39:27 +0000
In-Reply-To: <20220429183935.1094599-1-dmatlack@google.com>
Message-Id: <20220429183935.1094599-2-dmatlack@google.com>
Mime-Version: 1.0
References: <20220429183935.1094599-1-dmatlack@google.com>
X-Mailer: git-send-email 2.36.0.464.gb9c8b46e94-goog
Subject: [PATCH 1/9] KVM: selftests: Replace x86_page_size with raw levels
From:   David Matlack <dmatlack@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Ben Gardon <bgardon@google.com>,
        Sean Christopherson <seanjc@google.com>,
        Oliver Upton <oupton@google.com>, Peter Xu <peterx@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Andrew Jones <drjones@redhat.com>,
        "open list:KERNEL VIRTUAL MACHINE (KVM)" <kvm@vger.kernel.org>,
        David Matlack <dmatlack@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

x86_page_size is an enum used to communicate the desired page size with
which to map a range of memory. Under the hood they just encode the
desired level at which to map the page. This ends up being clunky in a
few ways:

 - The name suggests it encodes the size of the page rather than the
   level.
 - In other places in x86_64/processor.c we just use a raw int to encode
   the level.

Simplify this by just admitting that x86_page_size is just the level and
using an int and some more obviously named macros (e.g. PG_LEVEL_1G).

Signed-off-by: David Matlack <dmatlack@google.com>
---
 .../selftests/kvm/include/x86_64/processor.h  | 14 +++++-----
 .../selftests/kvm/lib/x86_64/processor.c      | 27 +++++++++----------
 .../selftests/kvm/max_guest_memory_test.c     |  2 +-
 .../selftests/kvm/x86_64/mmu_role_test.c      |  2 +-
 4 files changed, 22 insertions(+), 23 deletions(-)

diff --git a/tools/testing/selftests/kvm/include/x86_64/processor.h b/tools/testing/selftests/kvm/include/x86_64/processor.h
index 37db341d4cc5..b512f9f508ae 100644
--- a/tools/testing/selftests/kvm/include/x86_64/processor.h
+++ b/tools/testing/selftests/kvm/include/x86_64/processor.h
@@ -465,13 +465,13 @@ void vcpu_set_hv_cpuid(struct kvm_vm *vm, uint32_t vcpuid);
 struct kvm_cpuid2 *vcpu_get_supported_hv_cpuid(struct kvm_vm *vm, uint32_t vcpuid);
 void vm_xsave_req_perm(int bit);
 
-enum x86_page_size {
-	X86_PAGE_SIZE_4K = 0,
-	X86_PAGE_SIZE_2M,
-	X86_PAGE_SIZE_1G,
-};
-void __virt_pg_map(struct kvm_vm *vm, uint64_t vaddr, uint64_t paddr,
-		   enum x86_page_size page_size);
+#define PG_LEVEL_4K 0
+#define PG_LEVEL_2M 1
+#define PG_LEVEL_1G 2
+
+#define PG_LEVEL_SIZE(_level) (1ull << (((_level) * 9) + 12))
+
+void __virt_pg_map(struct kvm_vm *vm, uint64_t vaddr, uint64_t paddr, int level);
 
 /*
  * Basic CPU control in CR0
diff --git a/tools/testing/selftests/kvm/lib/x86_64/processor.c b/tools/testing/selftests/kvm/lib/x86_64/processor.c
index 9f000dfb5594..1a7de69e2495 100644
--- a/tools/testing/selftests/kvm/lib/x86_64/processor.c
+++ b/tools/testing/selftests/kvm/lib/x86_64/processor.c
@@ -199,15 +199,15 @@ static struct pageUpperEntry *virt_create_upper_pte(struct kvm_vm *vm,
 						    uint64_t pt_pfn,
 						    uint64_t vaddr,
 						    uint64_t paddr,
-						    int level,
-						    enum x86_page_size page_size)
+						    int current_level,
+						    int target_level)
 {
-	struct pageUpperEntry *pte = virt_get_pte(vm, pt_pfn, vaddr, level);
+	struct pageUpperEntry *pte = virt_get_pte(vm, pt_pfn, vaddr, current_level);
 
 	if (!pte->present) {
 		pte->writable = true;
 		pte->present = true;
-		pte->page_size = (level == page_size);
+		pte->page_size = (current_level == target_level);
 		if (pte->page_size)
 			pte->pfn = paddr >> vm->page_shift;
 		else
@@ -218,20 +218,19 @@ static struct pageUpperEntry *virt_create_upper_pte(struct kvm_vm *vm,
 		 * a hugepage at this level, and that there isn't a hugepage at
 		 * this level.
 		 */
-		TEST_ASSERT(level != page_size,
+		TEST_ASSERT(current_level != target_level,
 			    "Cannot create hugepage at level: %u, vaddr: 0x%lx\n",
-			    page_size, vaddr);
+			    current_level, vaddr);
 		TEST_ASSERT(!pte->page_size,
 			    "Cannot create page table at level: %u, vaddr: 0x%lx\n",
-			    level, vaddr);
+			    current_level, vaddr);
 	}
 	return pte;
 }
 
-void __virt_pg_map(struct kvm_vm *vm, uint64_t vaddr, uint64_t paddr,
-		   enum x86_page_size page_size)
+void __virt_pg_map(struct kvm_vm *vm, uint64_t vaddr, uint64_t paddr, int level)
 {
-	const uint64_t pg_size = 1ull << ((page_size * 9) + 12);
+	const uint64_t pg_size = PG_LEVEL_SIZE(level);
 	struct pageUpperEntry *pml4e, *pdpe, *pde;
 	struct pageTableEntry *pte;
 
@@ -256,15 +255,15 @@ void __virt_pg_map(struct kvm_vm *vm, uint64_t vaddr, uint64_t paddr,
 	 * early if a hugepage was created.
 	 */
 	pml4e = virt_create_upper_pte(vm, vm->pgd >> vm->page_shift,
-				      vaddr, paddr, 3, page_size);
+				      vaddr, paddr, 3, level);
 	if (pml4e->page_size)
 		return;
 
-	pdpe = virt_create_upper_pte(vm, pml4e->pfn, vaddr, paddr, 2, page_size);
+	pdpe = virt_create_upper_pte(vm, pml4e->pfn, vaddr, paddr, 2, level);
 	if (pdpe->page_size)
 		return;
 
-	pde = virt_create_upper_pte(vm, pdpe->pfn, vaddr, paddr, 1, page_size);
+	pde = virt_create_upper_pte(vm, pdpe->pfn, vaddr, paddr, 1, level);
 	if (pde->page_size)
 		return;
 
@@ -279,7 +278,7 @@ void __virt_pg_map(struct kvm_vm *vm, uint64_t vaddr, uint64_t paddr,
 
 void virt_pg_map(struct kvm_vm *vm, uint64_t vaddr, uint64_t paddr)
 {
-	__virt_pg_map(vm, vaddr, paddr, X86_PAGE_SIZE_4K);
+	__virt_pg_map(vm, vaddr, paddr, PG_LEVEL_4K);
 }
 
 static struct pageTableEntry *_vm_get_page_table_entry(struct kvm_vm *vm, int vcpuid,
diff --git a/tools/testing/selftests/kvm/max_guest_memory_test.c b/tools/testing/selftests/kvm/max_guest_memory_test.c
index 3875c4b23a04..15f046e19cb2 100644
--- a/tools/testing/selftests/kvm/max_guest_memory_test.c
+++ b/tools/testing/selftests/kvm/max_guest_memory_test.c
@@ -244,7 +244,7 @@ int main(int argc, char *argv[])
 #ifdef __x86_64__
 		/* Identity map memory in the guest using 1gb pages. */
 		for (i = 0; i < slot_size; i += size_1gb)
-			__virt_pg_map(vm, gpa + i, gpa + i, X86_PAGE_SIZE_1G);
+			__virt_pg_map(vm, gpa + i, gpa + i, PG_LEVEL_1G);
 #else
 		for (i = 0; i < slot_size; i += vm_get_page_size(vm))
 			virt_pg_map(vm, gpa + i, gpa + i);
diff --git a/tools/testing/selftests/kvm/x86_64/mmu_role_test.c b/tools/testing/selftests/kvm/x86_64/mmu_role_test.c
index da2325fcad87..bdecd532f935 100644
--- a/tools/testing/selftests/kvm/x86_64/mmu_role_test.c
+++ b/tools/testing/selftests/kvm/x86_64/mmu_role_test.c
@@ -35,7 +35,7 @@ static void mmu_role_test(u32 *cpuid_reg, u32 evil_cpuid_val)
 	run = vcpu_state(vm, VCPU_ID);
 
 	/* Map 1gb page without a backing memlot. */
-	__virt_pg_map(vm, MMIO_GPA, MMIO_GPA, X86_PAGE_SIZE_1G);
+	__virt_pg_map(vm, MMIO_GPA, MMIO_GPA, PG_LEVEL_1G);
 
 	r = _vcpu_run(vm, VCPU_ID);
 

base-commit: 84e5ffd045f33e4fa32370135436d987478d0bf7
-- 
2.36.0.464.gb9c8b46e94-goog

