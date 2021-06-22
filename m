Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F1AC33B0E4F
	for <lists+kvm@lfdr.de>; Tue, 22 Jun 2021 22:07:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233249AbhFVUJY (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 22 Jun 2021 16:09:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38346 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233019AbhFVUJC (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 22 Jun 2021 16:09:02 -0400
Received: from mail-qk1-x749.google.com (mail-qk1-x749.google.com [IPv6:2607:f8b0:4864:20::749])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9143FC06114C
        for <kvm@vger.kernel.org>; Tue, 22 Jun 2021 13:06:20 -0700 (PDT)
Received: by mail-qk1-x749.google.com with SMTP id 81-20020a370e540000b02903aacdbd70b7so19382177qko.23
        for <kvm@vger.kernel.org>; Tue, 22 Jun 2021 13:06:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=reply-to:date:in-reply-to:message-id:mime-version:references
         :subject:from:to:cc;
        bh=GrfMAola6gddFitesBXZsmG+RUWwJ0hTCm8HOWv8lMA=;
        b=OtkPNGkUfKyTykV6MIPXwPtACqNYdKiMVrmVZgithFtkKevkpXs9aBjAUMaj3tIhJq
         pFx9DJiiGTTKeztlqq9gtwc72OCyOJsAY72U9PWdzfCRNsTtTBSKIX20sjVRK5VeJbqz
         Tk1UFanmaE/aAdZp0xE8Sheq0KZgQVFRllx6IqCmT/Eeg3KsmMs2WK5GhY2vqdZxvpBG
         6HYhVR/qGt09Jtpj9a4gP/eyUYTkHc7TCGdelRlUOkc9mABzjWcjg7qaPzqj7NzZo7AU
         8F/JhgSKWmmfaF24+8n+Ittxy+TEL2rwKtyjXlnZgUF+Vh8DDUe0iezRoLOpmBRovhFi
         qIiQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:reply-to:date:in-reply-to:message-id
         :mime-version:references:subject:from:to:cc;
        bh=GrfMAola6gddFitesBXZsmG+RUWwJ0hTCm8HOWv8lMA=;
        b=kKZWah0lMpwvy0RxQFUErm4hNy2CQsxBSWIvFDte2tkx6Ba9ne/YN7pC3w0T+BmdZK
         M6DkYvyEPLPD9Up7RyoDeChiZ9tiKVYl+WmmRz0P19A7UZPSrDE+uBIpV0w5kbIeali5
         qCjaaO+KJrGYVXEUS6BA59SxpUCkEe6SbbAjVKv7BliaSpCFyCXANcDAgs9tvFrCf3XM
         lRjzlJhAmLH2+bpi1uD8NhIjXVknZo6hOA31O8v+xC8DROVPW7VvWWkMc6iA8QTEDMnr
         dIg8CYqH/Ju2TTutgeAAuaN5vWnVqnDbOw8KEN4q0l6EPAEbnHKBRZFyfKDiGvGc4S+G
         wYmg==
X-Gm-Message-State: AOAM531yait8A5r8xrVh9bKw6/3ucYoCT27PTVof+tCyRAwVTO9PS6TW
        FohVlr4zQmA6V/FFaocW3fag/4e7v+E=
X-Google-Smtp-Source: ABdhPJzPB0EjUbRyo0XA+/E6+jq74qa1wKsj3CmG5GTC/Kc56BVqTOBldRjYoUlQ9D3D8LxUFi/LNf/19go=
X-Received: from seanjc798194.pdx.corp.google.com ([2620:15c:f:10:7d90:4528:3c45:18fb])
 (user=seanjc job=sendgmr) by 2002:a25:208b:: with SMTP id g133mr6491488ybg.211.1624392379721;
 Tue, 22 Jun 2021 13:06:19 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Tue, 22 Jun 2021 13:05:28 -0700
In-Reply-To: <20210622200529.3650424-1-seanjc@google.com>
Message-Id: <20210622200529.3650424-19-seanjc@google.com>
Mime-Version: 1.0
References: <20210622200529.3650424-1-seanjc@google.com>
X-Mailer: git-send-email 2.32.0.288.g62a8d224e6-goog
Subject: [PATCH 18/19] KVM: selftests: Add hugepage support for x86-64
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Janosch Frank <frankja@linux.ibm.com>
Cc:     David Hildenbrand <david@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Peter Xu <peterx@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Peter Shier <pshier@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Add x86-64 hugepage support in the form of a x86-only variant of
virt_pg_map() that takes an explicit page size.  To keep things simple,
follow the existing logic for 4k pages and disallow creating a hugepage
if the upper-level entry is present, even if the desired pfn matches.

Opportunistically fix a double "beyond beyond" reported by checkpatch.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 .../selftests/kvm/include/x86_64/processor.h  |  8 ++
 .../selftests/kvm/lib/x86_64/processor.c      | 83 +++++++++++++------
 2 files changed, 67 insertions(+), 24 deletions(-)

diff --git a/tools/testing/selftests/kvm/include/x86_64/processor.h b/tools/testing/selftests/kvm/include/x86_64/processor.h
index 9a5b47d2d5d6..f21126941f19 100644
--- a/tools/testing/selftests/kvm/include/x86_64/processor.h
+++ b/tools/testing/selftests/kvm/include/x86_64/processor.h
@@ -412,6 +412,14 @@ struct kvm_cpuid2 *kvm_get_supported_hv_cpuid(void);
 void vcpu_set_hv_cpuid(struct kvm_vm *vm, uint32_t vcpuid);
 struct kvm_cpuid2 *vcpu_get_supported_hv_cpuid(struct kvm_vm *vm, uint32_t vcpuid);
 
+enum x86_page_size {
+	X86_PAGE_SIZE_4K = 0,
+	X86_PAGE_SIZE_2M,
+	X86_PAGE_SIZE_1G,
+};
+void __virt_pg_map(struct kvm_vm *vm, uint64_t vaddr, uint64_t paddr,
+		   enum x86_page_size page_size);
+
 /*
  * Basic CPU control in CR0
  */
diff --git a/tools/testing/selftests/kvm/lib/x86_64/processor.c b/tools/testing/selftests/kvm/lib/x86_64/processor.c
index cc2483db47a9..a770a5fc852c 100644
--- a/tools/testing/selftests/kvm/lib/x86_64/processor.c
+++ b/tools/testing/selftests/kvm/lib/x86_64/processor.c
@@ -198,55 +198,90 @@ static void *virt_get_pte(struct kvm_vm *vm, uint64_t pt_pfn, uint64_t vaddr,
 static struct pageUpperEntry *virt_create_upper_pte(struct kvm_vm *vm,
 						    uint64_t pt_pfn,
 						    uint64_t vaddr,
-						    int level)
+						    uint64_t paddr,
+						    int level,
+						    enum x86_page_size page_size)
 {
 	struct pageUpperEntry *pte = virt_get_pte(vm, pt_pfn, vaddr, level);
 
 	if (!pte->present) {
-		pte->pfn = vm_alloc_page_table(vm) >> vm->page_shift;
 		pte->writable = true;
 		pte->present = true;
+		pte->page_size = (level == page_size);
+		if (pte->page_size)
+			pte->pfn = paddr >> vm->page_shift;
+		else
+			pte->pfn = vm_alloc_page_table(vm) >> vm->page_shift;
+	} else {
+		/*
+		 * Entry already present.  Assert that the caller doesn't want
+		 * a hugepage at this level, and that there isn't a hugepage at
+		 * this level.
+		 */
+		TEST_ASSERT(level != page_size,
+			    "Cannot create hugepage at level: %u, vaddr: 0x%lx\n",
+			    page_size, vaddr);
+		TEST_ASSERT(!pte->page_size,
+			    "Cannot create page table at level: %u, vaddr: 0x%lx\n",
+			    level, vaddr);
 	}
 	return pte;
 }
 
-void virt_pg_map(struct kvm_vm *vm, uint64_t vaddr, uint64_t paddr)
+void __virt_pg_map(struct kvm_vm *vm, uint64_t vaddr, uint64_t paddr,
+		   enum x86_page_size page_size)
 {
+	const uint64_t pg_size = 1ull << ((page_size * 9) + 12);
 	struct pageUpperEntry *pml4e, *pdpe, *pde;
 	struct pageTableEntry *pte;
 
-	TEST_ASSERT(vm->mode == VM_MODE_PXXV48_4K, "Attempt to use "
-		"unknown or unsupported guest mode, mode: 0x%x", vm->mode);
+	TEST_ASSERT(vm->mode == VM_MODE_PXXV48_4K,
+		    "Unknown or unsupported guest mode, mode: 0x%x", vm->mode);
 
-	TEST_ASSERT((vaddr % vm->page_size) == 0,
-		"Virtual address not on page boundary,\n"
-		"  vaddr: 0x%lx vm->page_size: 0x%x",
-		vaddr, vm->page_size);
-	TEST_ASSERT(sparsebit_is_set(vm->vpages_valid,
-		(vaddr >> vm->page_shift)),
-		"Invalid virtual address, vaddr: 0x%lx",
-		vaddr);
-	TEST_ASSERT((paddr % vm->page_size) == 0,
-		"Physical address not on page boundary,\n"
-		"  paddr: 0x%lx vm->page_size: 0x%x",
-		paddr, vm->page_size);
+	TEST_ASSERT((vaddr % pg_size) == 0,
+		    "Virtual address not aligned,\n"
+		    "vaddr: 0x%lx page size: 0x%lx", vaddr, pg_size);
+	TEST_ASSERT(sparsebit_is_set(vm->vpages_valid, (vaddr >> vm->page_shift)),
+		    "Invalid virtual address, vaddr: 0x%lx", vaddr);
+	TEST_ASSERT((paddr % pg_size) == 0,
+		    "Physical address not aligned,\n"
+		    "  paddr: 0x%lx page size: 0x%lx", paddr, pg_size);
 	TEST_ASSERT((paddr >> vm->page_shift) <= vm->max_gfn,
-		"Physical address beyond beyond maximum supported,\n"
-		"  paddr: 0x%lx vm->max_gfn: 0x%lx vm->page_size: 0x%x",
-		paddr, vm->max_gfn, vm->page_size);
+		    "Physical address beyond maximum supported,\n"
+		    "  paddr: 0x%lx vm->max_gfn: 0x%lx vm->page_size: 0x%x",
+		    paddr, vm->max_gfn, vm->page_size);
 
-	/* Allocate upper level page tables, if not already present. */
-	pml4e = virt_create_upper_pte(vm, vm->pgd >> vm->page_shift, vaddr, 3);
-	pdpe = virt_create_upper_pte(vm, pml4e->pfn, vaddr, 2);
-	pde = virt_create_upper_pte(vm, pdpe->pfn, vaddr, 1);
+	/*
+	 * Allocate upper level page tables, if not already present.  Return
+	 * early if a hugepage was created.
+	 */
+	pml4e = virt_create_upper_pte(vm, vm->pgd >> vm->page_shift,
+				      vaddr, paddr, 3, page_size);
+	if (pml4e->page_size)
+		return;
+
+	pdpe = virt_create_upper_pte(vm, pml4e->pfn, vaddr, paddr, 2, page_size);
+	if (pdpe->page_size)
+		return;
+
+	pde = virt_create_upper_pte(vm, pdpe->pfn, vaddr, paddr, 1, page_size);
+	if (pde->page_size)
+		return;
 
 	/* Fill in page table entry. */
 	pte = virt_get_pte(vm, pde->pfn, vaddr, 0);
+	TEST_ASSERT(!pte->present,
+		    "PTE already present for 4k page at vaddr: 0x%lx\n", vaddr);
 	pte->pfn = paddr >> vm->page_shift;
 	pte->writable = true;
 	pte->present = 1;
 }
 
+void virt_pg_map(struct kvm_vm *vm, uint64_t vaddr, uint64_t paddr)
+{
+	__virt_pg_map(vm, vaddr, paddr, X86_PAGE_SIZE_4K);
+}
+
 void virt_dump(FILE *stream, struct kvm_vm *vm, uint8_t indent)
 {
 	struct pageUpperEntry *pml4e, *pml4e_start;
-- 
2.32.0.288.g62a8d224e6-goog

