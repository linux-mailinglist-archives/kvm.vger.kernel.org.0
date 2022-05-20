Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8255452F635
	for <lists+kvm@lfdr.de>; Sat, 21 May 2022 01:33:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1354127AbiETXdD (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 20 May 2022 19:33:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51102 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1354142AbiETXdB (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 20 May 2022 19:33:01 -0400
Received: from mail-pj1-x104a.google.com (mail-pj1-x104a.google.com [IPv6:2607:f8b0:4864:20::104a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C379C1AB7AD
        for <kvm@vger.kernel.org>; Fri, 20 May 2022 16:32:55 -0700 (PDT)
Received: by mail-pj1-x104a.google.com with SMTP id oa7-20020a17090b1bc700b001df2567933eso7686938pjb.4
        for <kvm@vger.kernel.org>; Fri, 20 May 2022 16:32:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=W8jgKI50ePyABDO/nK5JyQIAmfeyEG33bBQNVNWWMLo=;
        b=CALYiyk62hFjuWncJSXe274CFB+XqrNlB/FTOa8h3G/K7SxwE2IDqfJiXm6KYSqLkE
         sUtO92G6OidMqeU7ob1/NmxOAxRA3clJ8Qkvf9iiX/qYXg94rz2z1Aoi/l453wN5+zGV
         3LV5u0Podgo+TKy77VEUc2syPY+C6EQ3fg0IP6dH/yISLNs9CKX7WQZvPHRsaYvLkNqR
         Z2agefWMkRmGzbrtmtDcxCjiM9Ko8H2kI1kh2hozGJFl1BUZ6ZT+YgK5ZbW1JvWXw2k3
         m/yo1G2+b1CnOTULYOVGNWLZ7O2thkt5C96m2lhBb9IsdesX+667xJ7q+9ELl6zukIjv
         n+/A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=W8jgKI50ePyABDO/nK5JyQIAmfeyEG33bBQNVNWWMLo=;
        b=pWH2w9T8cuF7uyD64Yqcp2bI+CahlX2UYUot06Esb/lIWCZWkPSZGO1Xn5LEUbRdEH
         Dn37DswqkkgVohIx4+3gZevLdmM4bvK3hKCmi2CKgOmBuKDR6G32yPnLsFQwlW0EepTQ
         CD744yiI4qA+He/sqB5RTPbrUsv/e/Wl1PVe99RDzYVF97jOiNK0ZndlUF5rrznmiPp9
         PjMehkP+X10Nto+KybflZmOZRCEdE7QZFzrhZ4wJhNkxlyp4CKz6sTD1GwfaukpP7xJv
         tcj7VUPkktUNT1H5qio0ONGwhhoYy6Jfj/6m+sMFiIcGa8xeIEU1u9AhCKPYNJJHklAu
         NRzw==
X-Gm-Message-State: AOAM531t0UVeRbVlnN1rt7ft1lSqr4yoUK3xfwICiR876nAHEvoWimJd
        yHrKpqLZCTUKpWLga6I8h7/fetySJKpLfg==
X-Google-Smtp-Source: ABdhPJx5Nt5SgXktvTUHC0boR7QQERVLbLQJhVnl5M4X2Lk4ai5G/aRczaun5e88iLc2WK3VFh9Z8a+NOh9AlQ==
X-Received: from dmatlack-heavy.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:19cd])
 (user=dmatlack job=sendgmr) by 2002:a17:902:850b:b0:15f:2a59:1c02 with SMTP
 id bj11-20020a170902850b00b0015f2a591c02mr11797156plb.27.1653089575148; Fri,
 20 May 2022 16:32:55 -0700 (PDT)
Date:   Fri, 20 May 2022 23:32:39 +0000
In-Reply-To: <20220520233249.3776001-1-dmatlack@google.com>
Message-Id: <20220520233249.3776001-2-dmatlack@google.com>
Mime-Version: 1.0
References: <20220520233249.3776001-1-dmatlack@google.com>
X-Mailer: git-send-email 2.36.1.124.g0e6072fb45-goog
Subject: [PATCH v4 01/11] KVM: selftests: Replace x86_page_size with PG_LEVEL_XX
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

