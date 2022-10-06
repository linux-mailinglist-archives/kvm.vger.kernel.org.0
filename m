Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 508FC5F64F7
	for <lists+kvm@lfdr.de>; Thu,  6 Oct 2022 13:12:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231508AbiJFLL7 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 6 Oct 2022 07:11:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44006 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231488AbiJFLL4 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 6 Oct 2022 07:11:56 -0400
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 3415A3890
        for <kvm@vger.kernel.org>; Thu,  6 Oct 2022 04:11:53 -0700 (PDT)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 983081BF7;
        Thu,  6 Oct 2022 04:11:59 -0700 (PDT)
Received: from monolith.localdoman (unknown [172.31.20.19])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 62D493F73B;
        Thu,  6 Oct 2022 04:11:52 -0700 (PDT)
From:   Alexandru Elisei <alexandru.elisei@arm.com>
To:     pbonzini@redhat.com, thuth@redhat.com, andrew.jones@linux.dev,
        kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu
Subject: [kvm-unit-tests PATCH 2/3] arm/arm64: mmu: Teach virt_to_pte_phys() about block descriptors
Date:   Thu,  6 Oct 2022 12:12:40 +0100
Message-Id: <20221006111241.15083-3-alexandru.elisei@arm.com>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20221006111241.15083-1-alexandru.elisei@arm.com>
References: <20221006111241.15083-1-alexandru.elisei@arm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The arm and arm64 architectures allow a virtual address to be mapped using
a block descriptor (or huge page, as Linux calls it), and the function
mmu_set_ranges_sect() is made available for a test to do just that. But
virt_to_pte_phys() assumes that all virtual addresses are mapped with page
granularity, which can lead to erroneous addresses being returned in the
case of block mappings.

Signed-off-by: Alexandru Elisei <alexandru.elisei@arm.com>
---
 lib/arm/mmu.c | 89 +++++++++++++++++++++++++++++++--------------------
 1 file changed, 54 insertions(+), 35 deletions(-)

diff --git a/lib/arm/mmu.c b/lib/arm/mmu.c
index e1a72fe4941f..2aaa63d538c0 100644
--- a/lib/arm/mmu.c
+++ b/lib/arm/mmu.c
@@ -111,10 +111,61 @@ pteval_t *install_page(pgd_t *pgtable, phys_addr_t phys, void *virt)
 				 __pgprot(PTE_WBWA | PTE_USER));
 }
 
-phys_addr_t virt_to_pte_phys(pgd_t *pgtable, void *mem)
+/*
+ * NOTE: The Arm architecture might require the use of a
+ * break-before-make sequence before making changes to a PTE and
+ * certain conditions are met (see Arm ARM D5-2669 for AArch64 and
+ * B3-1378 for AArch32 for more details).
+ */
+pteval_t *mmu_get_pte(pgd_t *pgtable, uintptr_t vaddr)
 {
-	return (*get_pte(pgtable, (uintptr_t)mem) & PHYS_MASK & -PAGE_SIZE)
-		+ ((ulong)mem & (PAGE_SIZE - 1));
+	pgd_t *pgd;
+	pud_t *pud;
+	pmd_t *pmd;
+	pte_t *pte;
+
+	if (!mmu_enabled())
+		return NULL;
+
+	pgd = pgd_offset(pgtable, vaddr);
+	if (!pgd_valid(*pgd))
+		return NULL;
+
+	pud = pud_offset(pgd, vaddr);
+	if (!pud_valid(*pud))
+		return NULL;
+
+	pmd = pmd_offset(pud, vaddr);
+	if (!pmd_valid(*pmd))
+		return NULL;
+	if (pmd_huge(*pmd))
+		return &pmd_val(*pmd);
+
+	pte = pte_offset(pmd, vaddr);
+	if (!pte_valid(*pte))
+		return NULL;
+
+        return &pte_val(*pte);
+}
+
+phys_addr_t virt_to_pte_phys(pgd_t *pgtable, void *virt)
+{
+	phys_addr_t mask;
+	pteval_t *pteval;
+
+	pteval = mmu_get_pte(pgtable, (uintptr_t)virt);
+	if (!pteval || !pte_valid(__pte(*pteval))) {
+		install_page(pgtable, (phys_addr_t)(unsigned long)virt, virt);
+		return (phys_addr_t)(unsigned long)virt;
+	}
+
+	if (pmd_huge(__pmd(*pteval)))
+		mask = PMD_MASK;
+	else
+		mask = PAGE_MASK;
+
+	return (*pteval & PHYS_MASK & mask) |
+		((phys_addr_t)(unsigned long)virt & ~mask);
 }
 
 void mmu_set_range_ptes(pgd_t *pgtable, uintptr_t virt_offset,
@@ -231,38 +282,6 @@ unsigned long __phys_to_virt(phys_addr_t addr)
 	return addr;
 }
 
-/*
- * NOTE: The Arm architecture might require the use of a
- * break-before-make sequence before making changes to a PTE and
- * certain conditions are met (see Arm ARM D5-2669 for AArch64 and
- * B3-1378 for AArch32 for more details).
- */
-pteval_t *mmu_get_pte(pgd_t *pgtable, uintptr_t vaddr)
-{
-	pgd_t *pgd;
-	pud_t *pud;
-	pmd_t *pmd;
-	pte_t *pte;
-
-	if (!mmu_enabled())
-		return NULL;
-
-	pgd = pgd_offset(pgtable, vaddr);
-	assert(pgd_valid(*pgd));
-	pud = pud_offset(pgd, vaddr);
-	assert(pud_valid(*pud));
-	pmd = pmd_offset(pud, vaddr);
-	assert(pmd_valid(*pmd));
-
-	if (pmd_huge(*pmd))
-		return &pmd_val(*pmd);
-
-	pte = pte_offset(pmd, vaddr);
-	assert(pte_valid(*pte));
-
-        return &pte_val(*pte);
-}
-
 void mmu_clear_user(pgd_t *pgtable, unsigned long vaddr)
 {
 	pteval_t *p_pte = mmu_get_pte(pgtable, vaddr);
-- 
2.37.0

