Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 27F7529C104
	for <lists+kvm@lfdr.de>; Tue, 27 Oct 2020 18:22:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1818063AbgJ0RUt (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 27 Oct 2020 13:20:49 -0400
Received: from foss.arm.com ([217.140.110.172]:47680 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1818332AbgJ0RTF (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 27 Oct 2020 13:19:05 -0400
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 2FEF1150C;
        Tue, 27 Oct 2020 10:19:04 -0700 (PDT)
Received: from monolith.localdoman (unknown [172.31.20.19])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 5953B3F719;
        Tue, 27 Oct 2020 10:19:00 -0700 (PDT)
From:   Alexandru Elisei <alexandru.elisei@arm.com>
To:     kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu
Cc:     drjones@redhat.com, pbonzini@redhat.com
Subject: [kvm-unit-tests RFC PATCH v2 4/5] lib: arm/arm64: Add function to unmap a page
Date:   Tue, 27 Oct 2020 17:19:43 +0000
Message-Id: <20201027171944.13933-5-alexandru.elisei@arm.com>
X-Mailer: git-send-email 2.29.1
In-Reply-To: <20201027171944.13933-1-alexandru.elisei@arm.com>
References: <20201027171944.13933-1-alexandru.elisei@arm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Being able to cause a stage 1 data abort might be useful for future tests.
Add a function that unmaps a page from the translation tables.

Signed-off-by: Alexandru Elisei <alexandru.elisei@arm.com>
---
 lib/arm/asm/mmu-api.h |  1 +
 lib/arm/mmu.c         | 32 ++++++++++++++++++++++++++++++++
 2 files changed, 33 insertions(+)

diff --git a/lib/arm/asm/mmu-api.h b/lib/arm/asm/mmu-api.h
index 2bbe1faea900..305f77c6501f 100644
--- a/lib/arm/asm/mmu-api.h
+++ b/lib/arm/asm/mmu-api.h
@@ -23,4 +23,5 @@ extern void mmu_set_range_ptes(pgd_t *pgtable, uintptr_t virt_offset,
 			       phys_addr_t phys_start, phys_addr_t phys_end,
 			       pgprot_t prot);
 extern void mmu_clear_user(pgd_t *pgtable, unsigned long vaddr);
+extern void mmu_unmap_page(pgd_t *pgtable, unsigned long vaddr);
 #endif
diff --git a/lib/arm/mmu.c b/lib/arm/mmu.c
index 540a1e842d5b..72ac0be8d146 100644
--- a/lib/arm/mmu.c
+++ b/lib/arm/mmu.c
@@ -232,3 +232,35 @@ void mmu_clear_user(pgd_t *pgtable, unsigned long vaddr)
 out_flush_tlb:
 	flush_tlb_page(vaddr);
 }
+
+void mmu_unmap_page(pgd_t *pgtable, unsigned long vaddr)
+{
+	pgd_t *pgd;
+	pmd_t *pmd;
+	pte_t *pte;
+
+	if (!mmu_enabled())
+		return;
+
+	pgd = pgd_offset(pgtable, vaddr);
+	if (!pgd_valid(*pgd))
+		return;
+
+	pmd = pmd_offset(pgd, vaddr);
+	if (!pmd_valid(*pmd))
+		return;
+
+	if (pmd_huge(*pmd)) {
+		WRITE_ONCE(*pmd, 0);
+		goto out_flush_tlb;
+	} else {
+		pte = pte_offset(pmd, vaddr);
+		if (!pte_valid(*pte))
+			return;
+		WRITE_ONCE(*pte, 0);
+		goto out_flush_tlb;
+	}
+
+out_flush_tlb:
+	flush_tlb_page(vaddr);
+}
-- 
2.29.1

