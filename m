Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BD23A130FEE
	for <lists+kvm@lfdr.de>; Mon,  6 Jan 2020 11:04:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726518AbgAFKEN (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 6 Jan 2020 05:04:13 -0500
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:53832 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726548AbgAFKEN (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 6 Jan 2020 05:04:13 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1578305052;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=ulS87Yr3rKFd1P0CS2kYxSf9pNhd16j6+kqnZ4ssOPI=;
        b=duSDZWhvjLslhGQKJ+SA7bKHJS7mu7665UsmJVXpBrTgwwDUluT1fkrMoRxB4t5ELlTz7Y
        EwZqkzMxo9XmjBTIqS2phoAsHMTiaTa8fIF9AzckWe1w95LDEv1xIDzx2W2gZ2oW6zaR2x
        iSKynrKmMNFF7N5oaBJkHcXfVz/Hpb0=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-329-EkLUUQyKO1m4opEhv0zlQw-1; Mon, 06 Jan 2020 05:04:10 -0500
X-MC-Unique: EkLUUQyKO1m4opEhv0zlQw-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id C7E938024D1;
        Mon,  6 Jan 2020 10:04:09 +0000 (UTC)
Received: from kamzik.brq.redhat.com (unknown [10.43.2.160])
        by smtp.corp.redhat.com (Postfix) with ESMTP id C88B963BCA;
        Mon,  6 Jan 2020 10:04:08 +0000 (UTC)
From:   Andrew Jones <drjones@redhat.com>
To:     kvm@vger.kernel.org, pbonzini@redhat.com
Cc:     Alexandru Elisei <alexandru.elisei@arm.com>
Subject: [PULL kvm-unit-tests 12/17] lib: arm/arm64: Teach mmu_clear_user about block mappings
Date:   Mon,  6 Jan 2020 11:03:42 +0100
Message-Id: <20200106100347.1559-13-drjones@redhat.com>
In-Reply-To: <20200106100347.1559-1-drjones@redhat.com>
References: <20200106100347.1559-1-drjones@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Content-Transfer-Encoding: quoted-printable
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Alexandru Elisei <alexandru.elisei@arm.com>

kvm-unit-tests uses block mappings, so let's expand the mmu_clear_user
function to handle those as well.

Now that the function knows about block mappings, we cannot simply
assume that if an address isn't mapped we can map it as a regular page.
Change the semantics of the function to fail quite loudly if the address
isn't mapped, and shift the burden on the caller to map the address as a
page or block mapping before calling mmu_clear_user.

Also make mmu_clear_user more flexible by adding a pgtable parameter,
instead of assuming that the change always applies to the current
translation tables.

Signed-off-by: Alexandru Elisei <alexandru.elisei@arm.com>
Signed-off-by: Andrew Jones <drjones@redhat.com>
---
 arm/cache.c                   |  3 ++-
 lib/arm/asm/mmu-api.h         |  2 +-
 lib/arm/asm/pgtable-hwdef.h   |  3 +++
 lib/arm/asm/pgtable.h         |  7 +++++++
 lib/arm/mmu.c                 | 26 +++++++++++++++++++-------
 lib/arm64/asm/pgtable-hwdef.h |  3 +++
 lib/arm64/asm/pgtable.h       |  7 +++++++
 7 files changed, 42 insertions(+), 9 deletions(-)

diff --git a/arm/cache.c b/arm/cache.c
index 13dc5d52d40c..2756066fd4e9 100644
--- a/arm/cache.c
+++ b/arm/cache.c
@@ -2,6 +2,7 @@
 #include <alloc_page.h>
 #include <asm/mmu.h>
 #include <asm/processor.h>
+#include <asm/thread_info.h>
=20
 #define NTIMES			(1 << 16)
=20
@@ -47,7 +48,7 @@ static void check_code_generation(bool dcache_clean, bo=
ol icache_inval)
 	bool success;
=20
 	/* Make sure we can execute from a writable page */
-	mmu_clear_user((unsigned long)code);
+	mmu_clear_user(current_thread_info()->pgtable, (unsigned long)code);
=20
 	sctlr =3D read_sysreg(sctlr_el1);
 	if (sctlr & SCTLR_EL1_WXN) {
diff --git a/lib/arm/asm/mmu-api.h b/lib/arm/asm/mmu-api.h
index 8fe85ba31ec9..2bbe1faea900 100644
--- a/lib/arm/asm/mmu-api.h
+++ b/lib/arm/asm/mmu-api.h
@@ -22,5 +22,5 @@ extern void mmu_set_range_sect(pgd_t *pgtable, uintptr_=
t virt_offset,
 extern void mmu_set_range_ptes(pgd_t *pgtable, uintptr_t virt_offset,
 			       phys_addr_t phys_start, phys_addr_t phys_end,
 			       pgprot_t prot);
-extern void mmu_clear_user(unsigned long vaddr);
+extern void mmu_clear_user(pgd_t *pgtable, unsigned long vaddr);
 #endif
diff --git a/lib/arm/asm/pgtable-hwdef.h b/lib/arm/asm/pgtable-hwdef.h
index 4f24c78ee011..4107e188014a 100644
--- a/lib/arm/asm/pgtable-hwdef.h
+++ b/lib/arm/asm/pgtable-hwdef.h
@@ -14,6 +14,8 @@
 #define PGDIR_SIZE		(_AC(1,UL) << PGDIR_SHIFT)
 #define PGDIR_MASK		(~((1 << PGDIR_SHIFT) - 1))
=20
+#define PGD_VALID		(_AT(pgdval_t, 1) << 0)
+
 #define PTRS_PER_PTE		512
 #define PTRS_PER_PMD		512
=20
@@ -54,6 +56,7 @@
 #define PMD_TYPE_FAULT		(_AT(pmdval_t, 0) << 0)
 #define PMD_TYPE_TABLE		(_AT(pmdval_t, 3) << 0)
 #define PMD_TYPE_SECT		(_AT(pmdval_t, 1) << 0)
+#define PMD_SECT_VALID		(_AT(pmdval_t, 1) << 0)
 #define PMD_TABLE_BIT		(_AT(pmdval_t, 1) << 1)
 #define PMD_BIT4		(_AT(pmdval_t, 0))
 #define PMD_DOMAIN(x)		(_AT(pmdval_t, 0))
diff --git a/lib/arm/asm/pgtable.h b/lib/arm/asm/pgtable.h
index e7f967071980..078dd16fa799 100644
--- a/lib/arm/asm/pgtable.h
+++ b/lib/arm/asm/pgtable.h
@@ -29,6 +29,13 @@
 #define pmd_none(pmd)		(!pmd_val(pmd))
 #define pte_none(pte)		(!pte_val(pte))
=20
+#define pgd_valid(pgd)		(pgd_val(pgd) & PGD_VALID)
+#define pmd_valid(pmd)		(pmd_val(pmd) & PMD_SECT_VALID)
+#define pte_valid(pte)		(pte_val(pte) & L_PTE_VALID)
+
+#define pmd_huge(pmd)	\
+	((pmd_val(pmd) & PMD_TYPE_MASK) =3D=3D PMD_TYPE_SECT)
+
 #define pgd_index(addr) \
 	(((addr) >> PGDIR_SHIFT) & (PTRS_PER_PGD - 1))
 #define pgd_offset(pgtable, addr) ((pgtable) + pgd_index(addr))
diff --git a/lib/arm/mmu.c b/lib/arm/mmu.c
index 86a829966a3c..928a3702c563 100644
--- a/lib/arm/mmu.c
+++ b/lib/arm/mmu.c
@@ -211,19 +211,31 @@ unsigned long __phys_to_virt(phys_addr_t addr)
 	return addr;
 }
=20
-void mmu_clear_user(unsigned long vaddr)
+void mmu_clear_user(pgd_t *pgtable, unsigned long vaddr)
 {
-	pgd_t *pgtable;
-	pteval_t *pte;
-	pteval_t entry;
+	pgd_t *pgd;
+	pmd_t *pmd;
+	pte_t *pte;
=20
 	if (!mmu_enabled())
 		return;
=20
-	pgtable =3D current_thread_info()->pgtable;
-	pte =3D get_pte(pgtable, vaddr);
+	pgd =3D pgd_offset(pgtable, vaddr);
+	assert(pgd_valid(*pgd));
+	pmd =3D pmd_offset(pgd, vaddr);
+	assert(pmd_valid(*pmd));
+
+	if (pmd_huge(*pmd)) {
+		pmd_t entry =3D __pmd(pmd_val(*pmd) & ~PMD_SECT_USER);
+		WRITE_ONCE(*pmd, entry);
+		goto out_flush_tlb;
+	}
=20
-	entry =3D *pte & ~PTE_USER;
+	pte =3D pte_offset(pmd, vaddr);
+	assert(pte_valid(*pte));
+	pte_t entry =3D __pte(pte_val(*pte) & ~PTE_USER);
 	WRITE_ONCE(*pte, entry);
+
+out_flush_tlb:
 	flush_tlb_page(vaddr);
 }
diff --git a/lib/arm64/asm/pgtable-hwdef.h b/lib/arm64/asm/pgtable-hwdef.=
h
index 045a3ce12645..33524899e5fa 100644
--- a/lib/arm64/asm/pgtable-hwdef.h
+++ b/lib/arm64/asm/pgtable-hwdef.h
@@ -22,6 +22,8 @@
 #define PGDIR_MASK		(~(PGDIR_SIZE-1))
 #define PTRS_PER_PGD		(1 << (VA_BITS - PGDIR_SHIFT))
=20
+#define PGD_VALID		(_AT(pgdval_t, 1) << 0)
+
 /* From include/asm-generic/pgtable-nopmd.h */
 #define PMD_SHIFT		PGDIR_SHIFT
 #define PTRS_PER_PMD		1
@@ -71,6 +73,7 @@
 #define PTE_TYPE_MASK		(_AT(pteval_t, 3) << 0)
 #define PTE_TYPE_FAULT		(_AT(pteval_t, 0) << 0)
 #define PTE_TYPE_PAGE		(_AT(pteval_t, 3) << 0)
+#define PTE_VALID		(_AT(pteval_t, 1) << 0)
 #define PTE_TABLE_BIT		(_AT(pteval_t, 1) << 1)
 #define PTE_USER		(_AT(pteval_t, 1) << 6)		/* AP[1] */
 #define PTE_RDONLY		(_AT(pteval_t, 1) << 7)		/* AP[2] */
diff --git a/lib/arm64/asm/pgtable.h b/lib/arm64/asm/pgtable.h
index 6412d67759e4..e577d9cf304e 100644
--- a/lib/arm64/asm/pgtable.h
+++ b/lib/arm64/asm/pgtable.h
@@ -33,6 +33,13 @@
 #define pmd_none(pmd)		(!pmd_val(pmd))
 #define pte_none(pte)		(!pte_val(pte))
=20
+#define pgd_valid(pgd)		(pgd_val(pgd) & PGD_VALID)
+#define pmd_valid(pmd)		(pmd_val(pmd) & PMD_SECT_VALID)
+#define pte_valid(pte)		(pte_val(pte) & PTE_VALID)
+
+#define pmd_huge(pmd)	\
+	((pmd_val(pmd) & PMD_TYPE_MASK) =3D=3D PMD_TYPE_SECT)
+
 #define pgd_index(addr) \
 	(((addr) >> PGDIR_SHIFT) & (PTRS_PER_PGD - 1))
 #define pgd_offset(pgtable, addr) ((pgtable) + pgd_index(addr))
--=20
2.21.0

