Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AE7D558EF48
	for <lists+kvm@lfdr.de>; Wed, 10 Aug 2022 17:21:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233121AbiHJPUt (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 10 Aug 2022 11:20:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37206 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233111AbiHJPUq (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 10 Aug 2022 11:20:46 -0400
Received: from mail-pj1-x1049.google.com (mail-pj1-x1049.google.com [IPv6:2607:f8b0:4864:20::1049])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9BEB82C134
        for <kvm@vger.kernel.org>; Wed, 10 Aug 2022 08:20:44 -0700 (PDT)
Received: by mail-pj1-x1049.google.com with SMTP id o69-20020a17090a0a4b00b001f527012a46so1177332pjo.5
        for <kvm@vger.kernel.org>; Wed, 10 Aug 2022 08:20:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:references:mime-version:message-id:in-reply-to
         :date:from:to:cc;
        bh=wUnNC45e2hnxoz0Q2Km6sVkIgu+FYYkWmLFW62kGR4A=;
        b=bE6EN2CKvCbMW6GRrrudOdbMe33OYr4fP/ZpAiuVlu4yctMBqSwGIK16Wi7w3hCQHd
         mjOAV8gTzcg7LJH9bk7/WLBHw2/VC3MwgYCtsHvV6VOL9uJLUSdj3KloYm4IuxKLtU2x
         R8vWMrpZE7CGKf0qi+hpELvBOiLNEiDi9ZLGakaMbrUhafmXca5Hrxt8XzQDN/2nPnb6
         xDw6k8NRvixy5FNufjHklnLRQsTtioVX9sQ4e7iOZTinzK+ZJosL+MOewei8ECwkIaNs
         M7RlDU7xoq+2CAC/fycg8CQi/vQ8pixKaYJ0vD3VtRsv7blNgszBK67kwtx/dHRVq/pw
         9Q0A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:references:mime-version:message-id:in-reply-to
         :date:x-gm-message-state:from:to:cc;
        bh=wUnNC45e2hnxoz0Q2Km6sVkIgu+FYYkWmLFW62kGR4A=;
        b=5qAwQ/9RMcTWXqp68f7PNZclEemNwI4gGDKvtDwBUc9j4WubBnPmQTCHaNXEigI4Ka
         nha/8nxQ/o8bQPM5IRJRv5Q9j7R87j4lSXiDHsxI4Uvg6rdaKDr9Gud5JaDKOzOYohJQ
         8V4W1AqZl3J4EbazYP1pQVdC8d01wWzMdCQzMuX0xaqzQl+iV+o1awavHxc2nZXkuYj8
         KOzngU/25Dh0EXtlRWYMYU8r+z+v5QW3gQfDtwD1BtwMSPwl7A5fyvr6LNvQgG1z7FuX
         jAqOGkgNGvEcT2GNy1EpPkEtH4mbaDFsmiBl++t24Z2YxvXOZAvKVpumr/8bXaApc8bS
         njDQ==
X-Gm-Message-State: ACgBeo2/Y6Slg3/N5hcdYnj/p/sml3YkHxZ2Xqo/5K3V8GzT91f/iC54
        KT5FW3LcsLGsjRyUKk0Wb5QeFjjmJUN+vQgnFLmCCgDnCGsCLeLvcQH+k1qCbV3E3rhEk6u/BbG
        MhveIYLToP+4A8zfCFFUcCQLqek+z/thh69rzbGs+R6KmVZLgS40IJUWCZw==
X-Google-Smtp-Source: AA6agR4kVXd/NdDCSVVCawPQsiv66EqvY8xWY/SBh432v2Bp2mnV7vaZNiumoN5iLQoCK7KKKpTo+0hqrKU=
X-Received: from pgonda1.kir.corp.google.com ([2620:15c:29:203:b185:1827:5b23:bbe2])
 (user=pgonda job=sendgmr) by 2002:a17:90b:1e50:b0:1f5:4f69:d6b8 with SMTP id
 pi16-20020a17090b1e5000b001f54f69d6b8mr4371150pjb.34.1660144844030; Wed, 10
 Aug 2022 08:20:44 -0700 (PDT)
Date:   Wed, 10 Aug 2022 08:20:26 -0700
In-Reply-To: <20220810152033.946942-1-pgonda@google.com>
Message-Id: <20220810152033.946942-5-pgonda@google.com>
Mime-Version: 1.0
References: <20220810152033.946942-1-pgonda@google.com>
X-Mailer: git-send-email 2.37.1.559.g78731f0fdb-goog
Subject: [V3 04/11] KVM: selftests: handle encryption bits in page tables
From:   Peter Gonda <pgonda@google.com>
To:     kvm@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org, marcorr@google.com,
        seanjc@google.com, michael.roth@amd.com, thomas.lendacky@amd.com,
        joro@8bytes.org, mizhang@google.com, pbonzini@redhat.com,
        andrew.jones@linux.dev, vannapurve@google.com,
        Peter Gonda <pgonda@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Michael Roth <michael.roth@amd.com>

SEV guests rely on an encyption bit which resides within the range that
current code treats as address bits. Guest code will expect these bits
to be set appropriately in their page tables, whereas the rest of the
kvm_util functions will generally expect these bits to not be present.
Introduce addr_gpa2raw()/addr_raw2gpa() to add/remove these bits, then
use them where appropriate.

Signed-off-by: Michael Roth <michael.roth@amd.com>
Signed-off-by: Peter Gonda <pgonda@google.com>
---
 .../selftests/kvm/include/kvm_util_base.h     |  2 +
 tools/testing/selftests/kvm/lib/kvm_util.c    | 55 ++++++++++++++++++-
 .../selftests/kvm/lib/x86_64/processor.c      | 15 +++--
 3 files changed, 66 insertions(+), 6 deletions(-)

diff --git a/tools/testing/selftests/kvm/include/kvm_util_base.h b/tools/testing/selftests/kvm/include/kvm_util_base.h
index 3928351e497e..de769b3de274 100644
--- a/tools/testing/selftests/kvm/include/kvm_util_base.h
+++ b/tools/testing/selftests/kvm/include/kvm_util_base.h
@@ -399,6 +399,8 @@ void *addr_gpa2hva(struct kvm_vm *vm, vm_paddr_t gpa);
 void *addr_gva2hva(struct kvm_vm *vm, vm_vaddr_t gva);
 vm_paddr_t addr_hva2gpa(struct kvm_vm *vm, void *hva);
 void *addr_gpa2alias(struct kvm_vm *vm, vm_paddr_t gpa);
+vm_paddr_t addr_raw2gpa(struct kvm_vm *vm, vm_vaddr_t gpa_raw);
+vm_paddr_t addr_gpa2raw(struct kvm_vm *vm, vm_vaddr_t gpa);
 
 void vcpu_run(struct kvm_vcpu *vcpu);
 int _vcpu_run(struct kvm_vcpu *vcpu);
diff --git a/tools/testing/selftests/kvm/lib/kvm_util.c b/tools/testing/selftests/kvm/lib/kvm_util.c
index c6b87b411186..87772e23d1b5 100644
--- a/tools/testing/selftests/kvm/lib/kvm_util.c
+++ b/tools/testing/selftests/kvm/lib/kvm_util.c
@@ -1377,6 +1377,58 @@ void virt_map(struct kvm_vm *vm, uint64_t vaddr, uint64_t paddr,
 	}
 }
 
+/*
+ * Mask off any special bits from raw GPA
+ *
+ * Input Args:
+ *   vm - Virtual Machine
+ *   gpa_raw - Raw VM physical address
+ *
+ * Output Args: None
+ *
+ * Return:
+ *   GPA with special bits (e.g. shared/encrypted) masked off.
+ */
+vm_paddr_t addr_raw2gpa(struct kvm_vm *vm, vm_paddr_t gpa_raw)
+{
+	if (!vm->memcrypt.has_enc_bit)
+		return gpa_raw;
+
+	return gpa_raw & ~(1ULL << vm->memcrypt.enc_bit);
+}
+
+/*
+ * Add special/encryption bits to a GPA based on encryption bitmap.
+ *
+ * Input Args:
+ *   vm - Virtual Machine
+ *   gpa - VM physical address
+ *
+ * Output Args: None
+ *
+ * Return:
+ *   GPA with special bits (e.g. shared/encrypted) added in.
+ */
+vm_paddr_t addr_gpa2raw(struct kvm_vm *vm, vm_paddr_t gpa)
+{
+	struct userspace_mem_region *region;
+	sparsebit_idx_t pg;
+	vm_paddr_t gpa_raw = gpa;
+
+	TEST_ASSERT(addr_raw2gpa(vm, gpa) == gpa, "Unexpected bits in GPA: %lx",
+		    gpa);
+
+	if (!vm->memcrypt.has_enc_bit)
+		return gpa;
+
+	region = userspace_mem_region_find(vm, gpa, gpa);
+	pg = gpa >> vm->page_shift;
+	if (sparsebit_is_set(region->encrypted_phy_pages, pg))
+		gpa_raw |= (1ULL << vm->memcrypt.enc_bit);
+
+	return gpa_raw;
+}
+
 /*
  * Address VM Physical to Host Virtual
  *
@@ -1394,9 +1446,10 @@ void virt_map(struct kvm_vm *vm, uint64_t vaddr, uint64_t paddr,
  * address providing the memory to the vm physical address is returned.
  * A TEST_ASSERT failure occurs if no region containing gpa exists.
  */
-void *addr_gpa2hva(struct kvm_vm *vm, vm_paddr_t gpa)
+void *addr_gpa2hva(struct kvm_vm *vm, vm_paddr_t gpa_raw)
 {
 	struct userspace_mem_region *region;
+	vm_paddr_t gpa = addr_raw2gpa(vm, gpa_raw);
 
 	region = userspace_mem_region_find(vm, gpa, gpa);
 	if (!region) {
diff --git a/tools/testing/selftests/kvm/lib/x86_64/processor.c b/tools/testing/selftests/kvm/lib/x86_64/processor.c
index f35626df1dea..55855594d26d 100644
--- a/tools/testing/selftests/kvm/lib/x86_64/processor.c
+++ b/tools/testing/selftests/kvm/lib/x86_64/processor.c
@@ -118,7 +118,7 @@ void virt_arch_pgd_alloc(struct kvm_vm *vm)
 
 	/* If needed, create page map l4 table. */
 	if (!vm->pgd_created) {
-		vm->pgd = vm_alloc_page_table(vm);
+		vm->pgd = addr_gpa2raw(vm, vm_alloc_page_table(vm));
 		vm->pgd_created = true;
 	}
 }
@@ -140,13 +140,15 @@ static uint64_t *virt_create_upper_pte(struct kvm_vm *vm,
 				       int target_level)
 {
 	uint64_t *pte = virt_get_pte(vm, pt_pfn, vaddr, current_level);
+	uint64_t paddr_raw = addr_gpa2raw(vm, paddr);
 
 	if (!(*pte & PTE_PRESENT_MASK)) {
 		*pte = PTE_PRESENT_MASK | PTE_WRITABLE_MASK;
 		if (current_level == target_level)
-			*pte |= PTE_LARGE_MASK | (paddr & PHYSICAL_PAGE_MASK);
+			*pte |= PTE_LARGE_MASK | (paddr_raw & PHYSICAL_PAGE_MASK);
 		else
-			*pte |= vm_alloc_page_table(vm) & PHYSICAL_PAGE_MASK;
+			*pte |= addr_gpa2raw(vm, vm_alloc_page_table(vm)) & PHYSICAL_PAGE_MASK;
+
 	} else {
 		/*
 		 * Entry already present.  Assert that the caller doesn't want
@@ -184,6 +186,8 @@ void __virt_pg_map(struct kvm_vm *vm, uint64_t vaddr, uint64_t paddr, int level)
 		    "Physical address beyond maximum supported,\n"
 		    "  paddr: 0x%lx vm->max_gfn: 0x%lx vm->page_size: 0x%x",
 		    paddr, vm->max_gfn, vm->page_size);
+	TEST_ASSERT(addr_raw2gpa(vm, paddr) == paddr,
+		    "Unexpected bits in paddr: %lx", paddr);
 
 	/*
 	 * Allocate upper level page tables, if not already present.  Return
@@ -206,7 +210,8 @@ void __virt_pg_map(struct kvm_vm *vm, uint64_t vaddr, uint64_t paddr, int level)
 	pte = virt_get_pte(vm, PTE_GET_PFN(*pde), vaddr, PG_LEVEL_4K);
 	TEST_ASSERT(!(*pte & PTE_PRESENT_MASK),
 		    "PTE already present for 4k page at vaddr: 0x%lx\n", vaddr);
-	*pte = PTE_PRESENT_MASK | PTE_WRITABLE_MASK | (paddr & PHYSICAL_PAGE_MASK);
+	*pte = PTE_PRESENT_MASK | PTE_WRITABLE_MASK |
+	       (addr_gpa2raw(vm, paddr) & PHYSICAL_PAGE_MASK);
 }
 
 void virt_arch_pg_map(struct kvm_vm *vm, uint64_t vaddr, uint64_t paddr)
@@ -515,7 +520,7 @@ vm_paddr_t addr_arch_gva2gpa(struct kvm_vm *vm, vm_vaddr_t gva)
 	if (!(pte[index[0]] & PTE_PRESENT_MASK))
 		goto unmapped_gva;
 
-	return (PTE_GET_PFN(pte[index[0]]) * vm->page_size) + (gva & ~PAGE_MASK);
+	return addr_raw2gpa(vm, PTE_GET_PFN(pte[index[0]]) * vm->page_size) + (gva & ~PAGE_MASK);
 
 unmapped_gva:
 	TEST_FAIL("No mapping for vm virtual address, gva: 0x%lx", gva);
-- 
2.37.1.559.g78731f0fdb-goog

