Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 116E658720B
	for <lists+kvm@lfdr.de>; Mon,  1 Aug 2022 22:12:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233561AbiHAUL4 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 1 Aug 2022 16:11:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54594 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234285AbiHAULV (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 1 Aug 2022 16:11:21 -0400
Received: from mail-pf1-x44a.google.com (mail-pf1-x44a.google.com [IPv6:2607:f8b0:4864:20::44a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6654F20F47
        for <kvm@vger.kernel.org>; Mon,  1 Aug 2022 13:11:20 -0700 (PDT)
Received: by mail-pf1-x44a.google.com with SMTP id h9-20020a628309000000b0052d519c3bd6so1303888pfe.7
        for <kvm@vger.kernel.org>; Mon, 01 Aug 2022 13:11:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=Acabi+of9RwHZE3YF7H/hkvoQhBCcjJw3NUErSxIQ/Y=;
        b=SSthzXS/ZFgkFIDg0OLy40hpM2vQsVJanHdbyDq9p/jEo8rYnpOIYi+cjq9nbBPint
         dc4B9TmgbPNuKbF2+x37iEoOZSum/0f2xV7+KVYddSQrVmIVEuJ0wUsTzU6LIBdBJuPP
         TRIV94Zj5dOV9+4CWGjGHBZB3GYQ/+6HcU6/vXIO/DwiW8bM9e6p/287baQxlnsFg4Ie
         nPf99ryOKyvVJKVPtFRB/jMzXbivKQ5gOvHENpQRUa3oNbzZzkYIO14hdqDVH6tcSqWL
         ahFOHFj/Vp1fjHY5c7/7/pMvzo/bjM49I18YxxQnoi52iUb4s7Mh0fHCG2Woai+a+WiW
         hL+Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=Acabi+of9RwHZE3YF7H/hkvoQhBCcjJw3NUErSxIQ/Y=;
        b=FlF9Iw4EIQUzs8u0Nr+hLHVQ2NTAnVFsXQ6b+3To1OpxE/W5OMqVKNF8I0jFtf/ukM
         c4O6V2nFTyBsFQNs4jr/aKFg0Ig/HhNegjqs4khQmey1w4bkCKBfSrYnUS4S5/NaNUyZ
         jOjt6ucuazY5ZL442Lh66ryAbeGuFy1Dar2AiG6k4TnLr0yS49Oq1ixGmrmt74Saf92O
         hLgHivKDZHBzVLFDgwwgca052tMlmTOOmem1Yg4rP09813vVNL3yi43M3XmwGF1zp6Ak
         pj+KOUiCVvzMvlfsGiwKEfXszLVBeD06WSnreg0S5PPOHhy81EioKUcfFTdk3CZ5TnE6
         aO4w==
X-Gm-Message-State: AJIora+jKXJJgUndLqSQsb3iSFCebIQt3Vhg3qu6mllJ/bUnMoNBxHge
        3koQccuqeQF5TEOZfnzWjZKV21FyJTCuTy1HWfvgHPZkyuTmaymwVMGZtmGON/7v+fe6BY7XSPx
        CJi/eRCIwLgaULQUPzYfsxUPLi5wsXa74hKCD3C9jZdHy0O4R8SNvQdTHkA==
X-Google-Smtp-Source: AGRyM1vxSXAfHO5s9sFu6pmmoL4BuR+gcmulRHXq842/1D+7IqhGqttt3AVkSHwiOdRkn9CbBe1Pt6NwccI=
X-Received: from pgonda1.kir.corp.google.com ([2620:15c:29:203:6be2:f99c:e23c:fa12])
 (user=pgonda job=sendgmr) by 2002:a05:6a00:cc9:b0:52a:b63a:4e5 with SMTP id
 b9-20020a056a000cc900b0052ab63a04e5mr17908249pfv.59.1659384679668; Mon, 01
 Aug 2022 13:11:19 -0700 (PDT)
Date:   Mon,  1 Aug 2022 13:11:02 -0700
In-Reply-To: <20220801201109.825284-1-pgonda@google.com>
Message-Id: <20220801201109.825284-5-pgonda@google.com>
Mime-Version: 1.0
References: <20220801201109.825284-1-pgonda@google.com>
X-Mailer: git-send-email 2.37.1.455.g008518b4e5-goog
Subject: [V2 04/11] KVM: selftests: handle encryption bits in page tables
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
2.37.1.455.g008518b4e5-goog

