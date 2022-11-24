Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E12B0637CF9
	for <lists+kvm@lfdr.de>; Thu, 24 Nov 2022 16:28:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230024AbiKXP23 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 24 Nov 2022 10:28:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44062 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229622AbiKXP22 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 24 Nov 2022 10:28:28 -0500
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 29ABDAF08A
        for <kvm@vger.kernel.org>; Thu, 24 Nov 2022 07:28:27 -0800 (PST)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 712681516;
        Thu, 24 Nov 2022 07:28:33 -0800 (PST)
Received: from monolith.localdoman (unknown [172.31.20.19])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 1834D3F73B;
        Thu, 24 Nov 2022 07:28:25 -0800 (PST)
From:   Alexandru Elisei <alexandru.elisei@arm.com>
To:     andrew.jones@linux.dev, kvm@vger.kernel.org,
        kvmarm@lists.linux.dev, kvmarm@lists.cs.columbia.edu
Subject: [kvm-unit-tests PATCH v2 2/2] arm/arm64: mmu: Rename mmu_get_pte() -> follow_pte()
Date:   Thu, 24 Nov 2022 15:28:16 +0000
Message-Id: <20221124152816.22305-3-alexandru.elisei@arm.com>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221124152816.22305-1-alexandru.elisei@arm.com>
References: <20221124152816.22305-1-alexandru.elisei@arm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The function get_pte() from mmu.c returns a pointer to the PTE
associated with the requested virtual address, mapping the virtual
address in the process if it's not already mapped.

mmu_get_pte() returns a pointer to the PTE if and only if the virtual is
mapped in pgtable, otherwise returns NULL. Rename it to follow_pte() to
avoid any confusion with get_pte(). follow_pte() also matches the name
of Linux kernel function with a similar purpose.

Also remove the mmu_enabled() check from the function, as the purpose of
the function is to get the mapping for the virtual address in the pgtable
supplied as the argument, not to translate the virtual address to a
physical address using the current translation; that's what
virt_to_phys() does.

Signed-off-by: Alexandru Elisei <alexandru.elisei@arm.com>
---
 lib/arm/asm/mmu-api.h | 2 +-
 lib/arm/mmu.c         | 9 +++------
 2 files changed, 4 insertions(+), 7 deletions(-)

diff --git a/lib/arm/asm/mmu-api.h b/lib/arm/asm/mmu-api.h
index 3d77cbfd8b24..6c1136d957f9 100644
--- a/lib/arm/asm/mmu-api.h
+++ b/lib/arm/asm/mmu-api.h
@@ -17,6 +17,6 @@ extern void mmu_set_range_sect(pgd_t *pgtable, uintptr_t virt_offset,
 extern void mmu_set_range_ptes(pgd_t *pgtable, uintptr_t virt_offset,
 			       phys_addr_t phys_start, phys_addr_t phys_end,
 			       pgprot_t prot);
-extern pteval_t *mmu_get_pte(pgd_t *pgtable, uintptr_t vaddr);
+extern pteval_t *follow_pte(pgd_t *pgtable, uintptr_t vaddr);
 extern void mmu_clear_user(pgd_t *pgtable, unsigned long vaddr);
 #endif
diff --git a/lib/arm/mmu.c b/lib/arm/mmu.c
index 6022e356ddd4..18e32b2b8927 100644
--- a/lib/arm/mmu.c
+++ b/lib/arm/mmu.c
@@ -117,16 +117,13 @@ pteval_t *install_page(pgd_t *pgtable, phys_addr_t phys, void *virt)
  * certain conditions are met (see Arm ARM D5-2669 for AArch64 and
  * B3-1378 for AArch32 for more details).
  */
-pteval_t *mmu_get_pte(pgd_t *pgtable, uintptr_t vaddr)
+pteval_t *follow_pte(pgd_t *pgtable, uintptr_t vaddr)
 {
 	pgd_t *pgd;
 	pud_t *pud;
 	pmd_t *pmd;
 	pte_t *pte;
 
-	if (!mmu_enabled())
-		return NULL;
-
 	pgd = pgd_offset(pgtable, vaddr);
 	if (!pgd_valid(*pgd))
 		return NULL;
@@ -153,7 +150,7 @@ phys_addr_t virt_to_pte_phys(pgd_t *pgtable, void *virt)
 	phys_addr_t mask;
 	pteval_t *pteval;
 
-	pteval = mmu_get_pte(pgtable, (uintptr_t)virt);
+	pteval = follow_pte(pgtable, (uintptr_t)virt);
 	if (!pteval) {
 		install_page(pgtable, (phys_addr_t)(unsigned long)virt, virt);
 		return (phys_addr_t)(unsigned long)virt;
@@ -284,7 +281,7 @@ unsigned long __phys_to_virt(phys_addr_t addr)
 
 void mmu_clear_user(pgd_t *pgtable, unsigned long vaddr)
 {
-	pteval_t *p_pte = mmu_get_pte(pgtable, vaddr);
+	pteval_t *p_pte = follow_pte(pgtable, vaddr);
 	if (p_pte) {
 		pteval_t entry = *p_pte & ~PTE_USER;
 		WRITE_ONCE(*p_pte, entry);
-- 
2.37.0

