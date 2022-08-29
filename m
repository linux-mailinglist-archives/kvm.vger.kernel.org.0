Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ECFA75A52D1
	for <lists+kvm@lfdr.de>; Mon, 29 Aug 2022 19:11:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231388AbiH2RLI (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 29 Aug 2022 13:11:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52756 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231343AbiH2RLD (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 29 Aug 2022 13:11:03 -0400
Received: from mail-yw1-x114a.google.com (mail-yw1-x114a.google.com [IPv6:2607:f8b0:4864:20::114a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5CEC165647
        for <kvm@vger.kernel.org>; Mon, 29 Aug 2022 10:10:59 -0700 (PDT)
Received: by mail-yw1-x114a.google.com with SMTP id 00721157ae682-33dc390f26cso137209947b3.9
        for <kvm@vger.kernel.org>; Mon, 29 Aug 2022 10:10:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:references:mime-version:message-id:in-reply-to
         :date:from:to:cc;
        bh=BWDSIQFh5SU/Yj/rdeVVfM86JlFg7CLWWjt3RvlTVT8=;
        b=rPBdqSr3qzyN9GHMLkW1dGpcU20ZGIp9yOgxBxxd8cBGRmLCfZnbqe4DSJ7oY2X2bd
         qW4QITYBAmBXXFANzMZWokFig9TMa6Jc9r1UjxOZBX+JEX2LlkYY1W5stRYLZGjSFbDw
         OoOOnSa6zorbTcaJ8xWoGDtkO3ABEhj2JjidS1J/yfkKWck3bLv7Enfko42XSCMXlJbY
         akDfphYzbvDGHyG7eHqozDh/M1LlbSe5xe9rsZe5XOXzRtWBVGL30zE/27rEgOtgcsug
         B5DvBGYu+dEbOTmrllEVg+V4TyhQFHahfO4T9BOBGDdz2rb2EhaG3au38yO1FVB3U5XF
         xbaw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:references:mime-version:message-id:in-reply-to
         :date:x-gm-message-state:from:to:cc;
        bh=BWDSIQFh5SU/Yj/rdeVVfM86JlFg7CLWWjt3RvlTVT8=;
        b=LANTt6UpdbQCrRH/zMi++7v01+oHG4ycCkvQgGqcPTIdQ6DBn6jIHyc+VvlcHS1Obg
         moyngx3C3heXMyHAQwbQak+Oo7lSvs97djmz0Q3NVPMqzvxN7CFFqMxTBvFszUtEYuuc
         54UuJM/hKq3LugrgN5Ylj3plX3gLlG3kakloFqsoJ373mQj9HI9wQUxGgB6kR0UH0kmL
         zX+1U2oGN5lmd90B4Z0CWBJUsGg888Wq4DuIGU1VCXis8o02LTnn3kKHSvNNezsr8jHe
         0o23jojGikbO+z1kwQR+6FZ5EatxNcb/0ravUqSUEZ8r9EcTqLh2Swm0L7rdKRMNgAdX
         avTQ==
X-Gm-Message-State: ACgBeo3KESS42TheNEq6HaXV30uSGwNkHTCqcRFoP+lWrdoXksEI3aYF
        55ymigDeraMJ0ke0sy2EZkKWQVSBPSB+x28vEHy7xHCVMSRllyWcLIDjqkESP2sXy8eS3hJoPPl
        xcFPFKq2w32s7Xp0KNCxU78qLfT983Z4FLy+jP7ekl2tvbNodANuz/bbJuQ==
X-Google-Smtp-Source: AA6agR67NBL7H7Y4dIIhiq7N/9qsKQbiKZwmYiZZSoWxuyk6Bkle2OXlTT7glTdGNJi02DHYb8dMtiobkL0=
X-Received: from pgonda1.kir.corp.google.com ([2620:15c:29:203:cddb:77a7:c55e:a7a2])
 (user=pgonda job=sendgmr) by 2002:a81:7346:0:b0:329:ca9b:a53 with SMTP id
 o67-20020a817346000000b00329ca9b0a53mr11121530ywc.377.1661793057997; Mon, 29
 Aug 2022 10:10:57 -0700 (PDT)
Date:   Mon, 29 Aug 2022 10:10:17 -0700
In-Reply-To: <20220829171021.701198-1-pgonda@google.com>
Message-Id: <20220829171021.701198-5-pgonda@google.com>
Mime-Version: 1.0
References: <20220829171021.701198-1-pgonda@google.com>
X-Mailer: git-send-email 2.37.2.672.g94769d06f0-goog
Subject: [V4 4/8] KVM: selftests: handle encryption bits in page tables
From:   Peter Gonda <pgonda@google.com>
To:     kvm@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org, marcorr@google.com,
        seanjc@google.com, michael.roth@amd.com, thomas.lendacky@amd.com,
        joro@8bytes.org, mizhang@google.com, pbonzini@redhat.com,
        andrew.jones@linux.dev, Peter Gonda <pgonda@google.com>
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
index 5ecde5ad4c2f..dda8467d1434 100644
--- a/tools/testing/selftests/kvm/include/kvm_util_base.h
+++ b/tools/testing/selftests/kvm/include/kvm_util_base.h
@@ -401,6 +401,8 @@ void *addr_gpa2hva(struct kvm_vm *vm, vm_paddr_t gpa);
 void *addr_gva2hva(struct kvm_vm *vm, vm_vaddr_t gva);
 vm_paddr_t addr_hva2gpa(struct kvm_vm *vm, void *hva);
 void *addr_gpa2alias(struct kvm_vm *vm, vm_paddr_t gpa);
+vm_paddr_t addr_raw2gpa(struct kvm_vm *vm, vm_vaddr_t gpa_raw);
+vm_paddr_t addr_gpa2raw(struct kvm_vm *vm, vm_vaddr_t gpa);
 
 void vcpu_run(struct kvm_vcpu *vcpu);
 int _vcpu_run(struct kvm_vcpu *vcpu);
diff --git a/tools/testing/selftests/kvm/lib/kvm_util.c b/tools/testing/selftests/kvm/lib/kvm_util.c
index 53b9a509c1d5..de13be62d52d 100644
--- a/tools/testing/selftests/kvm/lib/kvm_util.c
+++ b/tools/testing/selftests/kvm/lib/kvm_util.c
@@ -1388,6 +1388,58 @@ void virt_map(struct kvm_vm *vm, uint64_t vaddr, uint64_t paddr,
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
@@ -1405,9 +1457,10 @@ void virt_map(struct kvm_vm *vm, uint64_t vaddr, uint64_t paddr,
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
index 2e6e61bbe81b..b2df259ce706 100644
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
2.37.2.672.g94769d06f0-goog

