Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0741F2A29F7
	for <lists+kvm@lfdr.de>; Mon,  2 Nov 2020 12:53:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728579AbgKBLxQ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 2 Nov 2020 06:53:16 -0500
Received: from foss.arm.com ([217.140.110.172]:58358 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728297AbgKBLxP (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 2 Nov 2020 06:53:15 -0500
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 01E0B31B;
        Mon,  2 Nov 2020 03:53:15 -0800 (PST)
Received: from camtx2.cambridge.arm.com (camtx2.cambridge.arm.com [10.1.7.22])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 011333F66E;
        Mon,  2 Nov 2020 03:53:13 -0800 (PST)
From:   Nikos Nikoleris <nikos.nikoleris@arm.com>
To:     kvm@vger.kernel.org
Cc:     mark.rutland@arm.com, jade.alglave@arm.com, luc.maranget@inria.fr,
        andre.przywara@arm.com, alexandru.elisei@arm.com,
        Luc Maranget <Luc.Maranget@inria.fr>
Subject: [kvm-unit-tests PATCH 1/2] arm: Add mmu_get_pte() to the MMU API
Date:   Mon,  2 Nov 2020 11:53:10 +0000
Message-Id: <20201102115311.103750-2-nikos.nikoleris@arm.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20201102115311.103750-1-nikos.nikoleris@arm.com>
References: <20201102115311.103750-1-nikos.nikoleris@arm.com>
X-ARM-No-Footer: FoSSMail
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Luc Maranget <Luc.Maranget@inria.fr>

Add the mmu_get_pte() function that allows a test to get a pointer to
the PTE for a valid virtual address. Return NULL if the MMU is off.

Signed-off-by: Nikos Nikoleris <nikos.nikoleris@arm.com>
---
 lib/arm/asm/mmu-api.h |  1 +
 lib/arm/mmu.c         | 23 ++++++++++++++---------
 2 files changed, 15 insertions(+), 9 deletions(-)

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
index 51fa745..2113604 100644
--- a/lib/arm/mmu.c
+++ b/lib/arm/mmu.c
@@ -210,7 +210,7 @@ unsigned long __phys_to_virt(phys_addr_t addr)
 	return addr;
 }
 
-void mmu_clear_user(pgd_t *pgtable, unsigned long vaddr)
+pteval_t *mmu_get_pte(pgd_t *pgtable, uintptr_t vaddr)
 {
 	pgd_t *pgd;
 	pud_t *pud;
@@ -218,7 +218,7 @@ void mmu_clear_user(pgd_t *pgtable, unsigned long vaddr)
 	pte_t *pte;
 
 	if (!mmu_enabled())
-		return;
+		return NULL;
 
 	pgd = pgd_offset(pgtable, vaddr);
 	assert(pgd_valid(*pgd));
@@ -228,16 +228,21 @@ void mmu_clear_user(pgd_t *pgtable, unsigned long vaddr)
 	assert(pmd_valid(*pmd));
 
 	if (pmd_huge(*pmd)) {
-		pmd_t entry = __pmd(pmd_val(*pmd) & ~PMD_SECT_USER);
-		WRITE_ONCE(*pmd, entry);
-		goto out_flush_tlb;
+		return &pmd_val(*pmd);
 	}
 
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

