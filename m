Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8F1022AD90C
	for <lists+kvm@lfdr.de>; Tue, 10 Nov 2020 15:42:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731036AbgKJOmh (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 10 Nov 2020 09:42:37 -0500
Received: from foss.arm.com ([217.140.110.172]:56828 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730059AbgKJOmg (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 10 Nov 2020 09:42:36 -0500
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 29FE21063;
        Tue, 10 Nov 2020 06:42:36 -0800 (PST)
Received: from camtx2.cambridge.arm.com (camtx2.cambridge.arm.com [10.1.7.22])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id F1E1B3F718;
        Tue, 10 Nov 2020 06:42:34 -0800 (PST)
From:   Nikos Nikoleris <nikos.nikoleris@arm.com>
To:     kvm@vger.kernel.org
Cc:     mark.rutland@arm.com, jade.alglave@arm.com, luc.maranget@inria.fr,
        andre.przywara@arm.com, alexandru.elisei@arm.com,
        drjones@redhat.com, Luc Maranget <Luc.Maranget@inria.fr>
Subject: [kvm-unit-tests PATCH v2 1/2] arm: Add mmu_get_pte() to the MMU API
Date:   Tue, 10 Nov 2020 14:42:05 +0000
Message-Id: <20201110144207.90693-2-nikos.nikoleris@arm.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20201110144207.90693-1-nikos.nikoleris@arm.com>
References: <20201110144207.90693-1-nikos.nikoleris@arm.com>
X-ARM-No-Footer: FoSSMail
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Luc Maranget <Luc.Maranget@inria.fr>

Add the mmu_get_pte() function that allows a test to get a pointer to
the PTE for a valid virtual address. Return NULL if the MMU is off.

Signed-off-by: Nikos Nikoleris <nikos.nikoleris@arm.com>
Signed-off-by: Luc Maranget <Luc.Maranget@inria.fr>
Co-Developed-by: Nikos Nikoleris <nikos.nikoleris@arm.com>
Reviewed-by: Andrew Jones <drjones@redhat.com>
Reviewed-by: Alexandru Elisei <alexandru.elisei@arm.com>
---
 lib/arm/asm/mmu-api.h |  1 +
 lib/arm/mmu.c         | 32 +++++++++++++++++++++-----------
 2 files changed, 22 insertions(+), 11 deletions(-)

diff --git a/lib/arm/asm/mmu-api.h b/lib/arm/asm/mmu-api.h
index 2bbe1fa..3d04d03 100644
--- a/lib/arm/asm/mmu-api.h
+++ b/lib/arm/asm/mmu-api.h
@@ -22,5 +22,6 @@ extern void mmu_set_range_sect(pgd_t *pgtable, uintptr_t virt_offset,
 extern void mmu_set_range_ptes(pgd_t *pgtable, uintptr_t virt_offset,
 			       phys_addr_t phys_start, phys_addr_t phys_end,
 			       pgprot_t prot);
+extern pteval_t *mmu_get_pte(pgd_t *pgtable, uintptr_t vaddr);
 extern void mmu_clear_user(pgd_t *pgtable, unsigned long vaddr);
 #endif
diff --git a/lib/arm/mmu.c b/lib/arm/mmu.c
index d937f20..e58da10 100644
--- a/lib/arm/mmu.c
+++ b/lib/arm/mmu.c
@@ -212,15 +212,21 @@ unsigned long __phys_to_virt(phys_addr_t addr)
 	return addr;
 }
 
-void mmu_clear_user(pgd_t *pgtable, unsigned long vaddr)
+pteval_t *mmu_get_pte(pgd_t *pgtable, uintptr_t vaddr)
 {
+	/*
+	 * NOTE: The Arm architecture requires the use of a
+	 * break-before-make sequence before making any changes to
+	 * PTEs (Arm ARM D5-2669 for AArch64, B3-1378 for AArch32).
+	 */
+
 	pgd_t *pgd;
 	pud_t *pud;
 	pmd_t *pmd;
 	pte_t *pte;
 
 	if (!mmu_enabled())
-		return;
+		return NULL;
 
 	pgd = pgd_offset(pgtable, vaddr);
 	assert(pgd_valid(*pgd));
@@ -229,17 +235,21 @@ void mmu_clear_user(pgd_t *pgtable, unsigned long vaddr)
 	pmd = pmd_offset(pud, vaddr);
 	assert(pmd_valid(*pmd));
 
-	if (pmd_huge(*pmd)) {
-		pmd_t entry = __pmd(pmd_val(*pmd) & ~PMD_SECT_USER);
-		WRITE_ONCE(*pmd, entry);
-		goto out_flush_tlb;
-	}
+	if (pmd_huge(*pmd))
+		return &pmd_val(*pmd);
 
 	pte = pte_offset(pmd, vaddr);
 	assert(pte_valid(*pte));
-	pte_t entry = __pte(pte_val(*pte) & ~PTE_USER);
-	WRITE_ONCE(*pte, entry);
 
-out_flush_tlb:
-	flush_tlb_page(vaddr);
+        return &pte_val(*pte);
+}
+
+void mmu_clear_user(pgd_t *pgtable, unsigned long vaddr)
+{
+	pteval_t *p_pte = mmu_get_pte(pgtable, vaddr);
+	if (p_pte) {
+		pteval_t entry = *p_pte & ~PTE_USER;
+		WRITE_ONCE(*p_pte, entry);
+		flush_tlb_page(vaddr);
+	}
 }
-- 
2.17.1

