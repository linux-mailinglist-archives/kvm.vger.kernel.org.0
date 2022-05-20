Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7EEDF52F561
	for <lists+kvm@lfdr.de>; Fri, 20 May 2022 23:57:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353781AbiETV5b (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 20 May 2022 17:57:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56748 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245252AbiETV53 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 20 May 2022 17:57:29 -0400
Received: from mail-pl1-x649.google.com (mail-pl1-x649.google.com [IPv6:2607:f8b0:4864:20::649])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E581518C059
        for <kvm@vger.kernel.org>; Fri, 20 May 2022 14:57:28 -0700 (PDT)
Received: by mail-pl1-x649.google.com with SMTP id c4-20020a170902c2c400b0015f16fb4a54so4635904pla.22
        for <kvm@vger.kernel.org>; Fri, 20 May 2022 14:57:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=W8jgKI50ePyABDO/nK5JyQIAmfeyEG33bBQNVNWWMLo=;
        b=EVC2Tw6hx0pB9+hI6J2bqVFQKDQoSGY2N3j6GE270SRsLPPqI0BCr7fjHnrwO/7sOw
         JgiuqMTP9nBq0VlX4yaKaI5XspIpEKS+Yy/m9iGcXPw55Mx+StZIdikaPM6lbmFShNh1
         Aek0OdJKFkwZt+JjHp4sby5LARG0olFca7Tvr7Kt7jagnXcaN/SVAj1/nBlLuPFZ3fJ/
         XKflfN8YO4093ZP6hq3fMZEqLUKJVz3wwMtoCIN3kNL9gek96ne7r39n1sPTPiZGduwi
         JNO6+jxxPqbfGV/GaBkdnAs7A6d8pPZt6RkftP9WDMmFJYU2KQx3vl03Q59m/uK3lkXo
         F6Eg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=W8jgKI50ePyABDO/nK5JyQIAmfeyEG33bBQNVNWWMLo=;
        b=c2hZy6Y2t8tEZ3RnY+secw6JiR0QU7R/Us8klBpvD3qY3r8QjzYbCYnsfWIeD0MpXu
         9GROTuNSA7C6s3MKfy9EfIkCqPnQn1rf5Gv0pgnwHE9bH5hCXCPHyRvedH2ECsTpAezA
         pQxarIhf5A7fzytZPdOPYoiBlXRAxXV22wsFcHyj/ersm4USc83GZct25+7pCJD7tXcH
         +cfcs+AT3jYof+ADg63aLFSGZuOZXTqY1yF3BDsg46hwvCXo+IGRl2VqZiExccr0CFrc
         nVBDBW3f0tS7qMq3lDpx9UBwcWsZT1n92VedLSLK6GcNlP1ZWSEt57w59oIe7y202J8R
         biSA==
X-Gm-Message-State: AOAM5323GFZgQibPMoGVDwiKXIzI1XRCMrBX3kMMPkiDTfNWib6UN2/N
        NV5VFGkiMup9TjPULDa3UP4vc0htNOdEWQ==
X-Google-Smtp-Source: ABdhPJwnZnJbPPG4z8dPZ5fHdEejCqMoUkVbpW2rjaLMv/9xYxzPSqtqIOwHMn/cWeh119XL8VfcIL5p6Yruwg==
X-Received: from dmatlack-heavy.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:19cd])
 (user=dmatlack job=sendgmr) by 2002:a17:903:248:b0:155:e8c6:8770 with SMTP id
 j8-20020a170903024800b00155e8c68770mr11265080plh.129.1653083848320; Fri, 20
 May 2022 14:57:28 -0700 (PDT)
Date:   Fri, 20 May 2022 21:57:14 +0000
In-Reply-To: <20220520215723.3270205-1-dmatlack@google.com>
Message-Id: <20220520215723.3270205-2-dmatlack@google.com>
Mime-Version: 1.0
References: <20220520215723.3270205-1-dmatlack@google.com>
X-Mailer: git-send-email 2.36.1.124.g0e6072fb45-goog
Subject: [PATCH v3 01/10] KVM: selftests: Replace x86_page_size with PG_LEVEL_XX
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
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL
        autolearn=ham autolearn_force=no version=3.4.6
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

Simplify this by adopting the kernel style of PG_LEVEL_XX enums and pass
around raw ints when referring to the level. This makes the code easier
to understand since these macros are very common in KVM MMU code.

Signed-off-by: David Matlack <dmatlack@google.com>
---
 .../selftests/kvm/include/x86_64/processor.h  | 18 ++++++----
 .../selftests/kvm/lib/x86_64/processor.c      | 33 ++++++++++---------
 .../selftests/kvm/max_guest_memory_test.c     |  2 +-
 .../selftests/kvm/x86_64/mmu_role_test.c      |  2 +-
 4 files changed, 31 insertions(+), 24 deletions(-)

diff --git a/tools/testing/selftests/kvm/include/x86_64/processor.h b/tools/testing/selftests/kvm/include/x86_64/processor.h
index 37db341d4cc5..434a4f60f4d9 100644
--- a/tools/testing/selftests/kvm/include/x86_64/processor.h
+++ b/tools/testing/selftests/kvm/include/x86_64/processor.h
@@ -465,13 +465,19 @@ void vcpu_set_hv_cpuid(struct kvm_vm *vm, uint32_t vcpuid);
 struct kvm_cpuid2 *vcpu_get_supported_hv_cpuid(struct kvm_vm *vm, uint32_t vcpuid);
 void vm_xsave_req_perm(int bit);
 
-enum x86_page_size {
-	X86_PAGE_SIZE_4K = 0,
-	X86_PAGE_SIZE_2M,
-	X86_PAGE_SIZE_1G,
+enum pg_level {
+	PG_LEVEL_NONE,
+	PG_LEVEL_4K,
+	PG_LEVEL_2M,
+	PG_LEVEL_1G,
+	PG_LEVEL_512G,
+	PG_LEVEL_NUM
 };
-void __virt_pg_map(struct kvm_vm *vm, uint64_t vaddr, uint64_t paddr,
-		   enum x86_page_size page_size);
+
+#define PG_LEVEL_SHIFT(_level) ((_level - 1) * 9 + 12)
+#define PG_LEVEL_SIZE(_level) (1ull << PG_LEVEL_SHIFT(_level))
+
+void __virt_pg_map(struct kvm_vm *vm, uint64_t vaddr, uint64_t paddr, int level);
 
 /*
  * Basic CPU control in CR0
diff --git a/tools/testing/selftests/kvm/lib/x86_64/processor.c b/tools/testing/selftests/kvm/lib/x86_64/processor.c
index 9f000dfb5594..f733c5b02da5 100644
--- a/tools/testing/selftests/kvm/lib/x86_64/processor.c
+++ b/tools/testing/selftests/kvm/lib/x86_64/processor.c
@@ -190,7 +190,7 @@ static void *virt_get_pte(struct kvm_vm *vm, uint64_t pt_pfn, uint64_t vaddr,
 			  int level)
 {
 	uint64_t *page_table = addr_gpa2hva(vm, pt_pfn << vm->page_shift);
-	int index = vaddr >> (vm->page_shift + level * 9) & 0x1ffu;
+	int index = (vaddr >> PG_LEVEL_SHIFT(level)) & 0x1ffu;
 
 	return &page_table[index];
 }
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
 
@@ -256,20 +255,22 @@ void __virt_pg_map(struct kvm_vm *vm, uint64_t vaddr, uint64_t paddr,
 	 * early if a hugepage was created.
 	 */
 	pml4e = virt_create_upper_pte(vm, vm->pgd >> vm->page_shift,
-				      vaddr, paddr, 3, page_size);
+				      vaddr, paddr, PG_LEVEL_512G, level);
 	if (pml4e->page_size)
 		return;
 
-	pdpe = virt_create_upper_pte(vm, pml4e->pfn, vaddr, paddr, 2, page_size);
+	pdpe = virt_create_upper_pte(vm, pml4e->pfn, vaddr, paddr, PG_LEVEL_1G,
+				     level);
 	if (pdpe->page_size)
 		return;
 
-	pde = virt_create_upper_pte(vm, pdpe->pfn, vaddr, paddr, 1, page_size);
+	pde = virt_create_upper_pte(vm, pdpe->pfn, vaddr, paddr, PG_LEVEL_2M,
+				    level);
 	if (pde->page_size)
 		return;
 
 	/* Fill in page table entry. */
-	pte = virt_get_pte(vm, pde->pfn, vaddr, 0);
+	pte = virt_get_pte(vm, pde->pfn, vaddr, PG_LEVEL_4K);
 	TEST_ASSERT(!pte->present,
 		    "PTE already present for 4k page at vaddr: 0x%lx\n", vaddr);
 	pte->pfn = paddr >> vm->page_shift;
@@ -279,7 +280,7 @@ void __virt_pg_map(struct kvm_vm *vm, uint64_t vaddr, uint64_t paddr,
 
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
 
-- 
2.36.1.124.g0e6072fb45-goog

