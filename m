Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 15BEF57676B
	for <lists+kvm@lfdr.de>; Fri, 15 Jul 2022 21:33:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230242AbiGOTaZ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 15 Jul 2022 15:30:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60974 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231339AbiGOTaT (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 15 Jul 2022 15:30:19 -0400
Received: from mail-pl1-x649.google.com (mail-pl1-x649.google.com [IPv6:2607:f8b0:4864:20::649])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2521A57E30
        for <kvm@vger.kernel.org>; Fri, 15 Jul 2022 12:30:16 -0700 (PDT)
Received: by mail-pl1-x649.google.com with SMTP id u3-20020a17090341c300b0016c3c083636so2483870ple.8
        for <kvm@vger.kernel.org>; Fri, 15 Jul 2022 12:30:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=yOrbZ7RaV7Jx4ZXQ1D7tU72Pr1kFVsoHo/rJhv/+f3g=;
        b=oArOwSWG8Bb9+5BGHMFgAnUdMJxS2ROAx0bvTpoTeYW2xU5V2YPuMnDS8qUXvn+fvW
         Ql+JiTST9SKDeO+ivkOfAJj7zazO4OTmqwrxFZRYnEznjhQOw9BBiTNMom7bjYgr8kV0
         oyw35ZqK1AxRHnIXQHJW3fVxvYj4+YlXxasXIWCRvlo2HqVFD+MfYOivXiuP1Qblk5wO
         ja68CsCXWGbxy9+mZRXaWBtLOxdX7R8RJfKQ/mdHfuVjXjFGBsrfBoodbYThusFjUJJY
         cbpDCsyiGE5LURNEhxzmqUdGt5fPbqsAnOPD9GQDKE+0feDY+z0DDkHeh1vEmxmy5IDX
         1Eew==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=yOrbZ7RaV7Jx4ZXQ1D7tU72Pr1kFVsoHo/rJhv/+f3g=;
        b=vqETiqutTDpxx0Y4wY6PQWL/LHAkGmcBINqhyATUv8obonhOnsdbj++qbq19K9pSkD
         tvJp/1MPE9qOPdCI8zUqBVnhx5XUNu3nlA4RhPBW3uHfzSz6oopIvsqnNbVtWeqFWk76
         Qv4VsxD2R/JvYVM9QqN7K2ZkiPmkpPfrAI8JkwNYCuNlirMLJPWs3yKlWprtdUstvyRa
         L8467d0VU2tVmyjG5vHjCe574osvq054Sv3Es9r9CVMHd5a0uWDFtq4KViThO8rstIxd
         n2Aik+r3aalMFfXc4cWC+cqtdWU88u9hX25K051J+Or9epWllrA+s7X16fDdKvL9Ia34
         INhA==
X-Gm-Message-State: AJIora8sKBPQdwmLG0n+VE46dVmBsTkTHcMH8MstvlYTQ4JhK+3yam3n
        h7jZpATy3mg333Gbhu7sbM6ACy+N38t4mXyOVzOp6OQWA9di247r+eCJFgj/BLb54APz/tytvsz
        ipqu/qhOirSdQmjWrA1HxqkkCpFqvaKo0buSh1Mj3rBFTHKaG0+J3LSJL0A==
X-Google-Smtp-Source: AGRyM1sFsC+wz7TDFZzydmeHoaICojlZlmCb3NmxuIgDy3cyoQAxunjB+rE54Ba/PvXoFrpJkvBTv48sd9E=
X-Received: from pgonda1.kir.corp.google.com ([2620:15c:29:203:bd4e:b81d:4780:497d])
 (user=pgonda job=sendgmr) by 2002:a17:90a:249:b0:1e0:a8a3:3c6c with SMTP id
 t9-20020a17090a024900b001e0a8a33c6cmr911058pje.0.1657913414519; Fri, 15 Jul
 2022 12:30:14 -0700 (PDT)
Date:   Fri, 15 Jul 2022 12:29:50 -0700
In-Reply-To: <20220715192956.1873315-1-pgonda@google.com>
Message-Id: <20220715192956.1873315-6-pgonda@google.com>
Mime-Version: 1.0
References: <20220715192956.1873315-1-pgonda@google.com>
X-Mailer: git-send-email 2.37.0.170.g444d1eabd0-goog
Subject: [RFC V1 04/10] KVM: selftests: handle encryption bits in page tables
From:   Peter Gonda <pgonda@google.com>
To:     kvm@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org, marcorr@google.com,
        seanjc@google.com, michael.roth@amd.com, thomas.lendacky@amd.com,
        joro@8bytes.org, mizhang@google.com, pbonzini@redhat.com,
        Peter Gonda <pgonda@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=unavailable
        autolearn_force=no version=3.4.6
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
index 3acb1552942b..17eb5fb70867 100644
--- a/tools/testing/selftests/kvm/include/kvm_util_base.h
+++ b/tools/testing/selftests/kvm/include/kvm_util_base.h
@@ -396,6 +396,8 @@ void *addr_gpa2hva(struct kvm_vm *vm, vm_paddr_t gpa);
 void *addr_gva2hva(struct kvm_vm *vm, vm_vaddr_t gva);
 vm_paddr_t addr_hva2gpa(struct kvm_vm *vm, void *hva);
 void *addr_gpa2alias(struct kvm_vm *vm, vm_paddr_t gpa);
+vm_paddr_t addr_raw2gpa(struct kvm_vm *vm, vm_vaddr_t gpa_raw);
+vm_paddr_t addr_gpa2raw(struct kvm_vm *vm, vm_vaddr_t gpa);
 
 void vcpu_run(struct kvm_vcpu *vcpu);
 int _vcpu_run(struct kvm_vcpu *vcpu);
diff --git a/tools/testing/selftests/kvm/lib/kvm_util.c b/tools/testing/selftests/kvm/lib/kvm_util.c
index 6f96d1c51f75..5b473a8c90ae 100644
--- a/tools/testing/selftests/kvm/lib/kvm_util.c
+++ b/tools/testing/selftests/kvm/lib/kvm_util.c
@@ -1365,6 +1365,58 @@ void virt_map(struct kvm_vm *vm, uint64_t vaddr, uint64_t paddr,
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
@@ -1382,9 +1434,10 @@ void virt_map(struct kvm_vm *vm, uint64_t vaddr, uint64_t paddr,
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
index 1a32b1c75e9a..53b115876417 100644
--- a/tools/testing/selftests/kvm/lib/x86_64/processor.c
+++ b/tools/testing/selftests/kvm/lib/x86_64/processor.c
@@ -116,7 +116,7 @@ void virt_arch_pgd_alloc(struct kvm_vm *vm)
 
 	/* If needed, create page map l4 table. */
 	if (!vm->pgd_created) {
-		vm->pgd = vm_alloc_page_table(vm);
+		vm->pgd = addr_gpa2raw(vm, vm_alloc_page_table(vm));
 		vm->pgd_created = true;
 	}
 }
@@ -138,13 +138,15 @@ static uint64_t *virt_create_upper_pte(struct kvm_vm *vm,
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
@@ -182,6 +184,8 @@ void __virt_pg_map(struct kvm_vm *vm, uint64_t vaddr, uint64_t paddr, int level)
 		    "Physical address beyond maximum supported,\n"
 		    "  paddr: 0x%lx vm->max_gfn: 0x%lx vm->page_size: 0x%x",
 		    paddr, vm->max_gfn, vm->page_size);
+	TEST_ASSERT(addr_raw2gpa(vm, paddr) == paddr,
+		    "Unexpected bits in paddr: %lx", paddr);
 
 	/*
 	 * Allocate upper level page tables, if not already present.  Return
@@ -204,7 +208,8 @@ void __virt_pg_map(struct kvm_vm *vm, uint64_t vaddr, uint64_t paddr, int level)
 	pte = virt_get_pte(vm, PTE_GET_PFN(*pde), vaddr, PG_LEVEL_4K);
 	TEST_ASSERT(!(*pte & PTE_PRESENT_MASK),
 		    "PTE already present for 4k page at vaddr: 0x%lx\n", vaddr);
-	*pte = PTE_PRESENT_MASK | PTE_WRITABLE_MASK | (paddr & PHYSICAL_PAGE_MASK);
+	*pte = PTE_PRESENT_MASK | PTE_WRITABLE_MASK |
+	       (addr_gpa2raw(vm, paddr) & PHYSICAL_PAGE_MASK);
 }
 
 void virt_arch_pg_map(struct kvm_vm *vm, uint64_t vaddr, uint64_t paddr)
@@ -517,7 +522,7 @@ vm_paddr_t addr_arch_gva2gpa(struct kvm_vm *vm, vm_vaddr_t gva)
 	if (!(pte[index[0]] & PTE_PRESENT_MASK))
 		goto unmapped_gva;
 
-	return (PTE_GET_PFN(pte[index[0]]) * vm->page_size) + (gva & ~PAGE_MASK);
+	return addr_raw2gpa(vm, PTE_GET_PFN(pte[index[0]]) * vm->page_size) + (gva & ~PAGE_MASK);
 
 unmapped_gva:
 	TEST_FAIL("No mapping for vm virtual address, gva: 0x%lx", gva);
-- 
2.37.0.170.g444d1eabd0-goog

