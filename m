Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 47240130FE7
	for <lists+kvm@lfdr.de>; Mon,  6 Jan 2020 11:04:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726448AbgAFKEC (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 6 Jan 2020 05:04:02 -0500
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:54029 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726477AbgAFKEA (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 6 Jan 2020 05:04:00 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1578305039;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=eRih+aQTzeaO1j/V45KE8WnShB/LCgRg1Uv+Q1QA5h8=;
        b=en5aXWXlbJLjYBkFg7VM9Yt1pmA0rsbt38o39jI+/Ply25hGCBaSdEOe0Uv8Goi2sthATK
        o2wobK+T8X9KvTgm3HzDD6qSc0jCA4gRhp/JgrPYGpA9NJibXhKUaCk4YWvZ5IZzXLqRST
        EhpTc4F7qjKODqw4ou2lMLsJzDj6YoU=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-41-5765ry8pMWeaX4IKyveZqg-1; Mon, 06 Jan 2020 05:03:58 -0500
X-MC-Unique: 5765ry8pMWeaX4IKyveZqg-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id EB786477;
        Mon,  6 Jan 2020 10:03:56 +0000 (UTC)
Received: from kamzik.brq.redhat.com (unknown [10.43.2.160])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 7DFA763BCA;
        Mon,  6 Jan 2020 10:03:55 +0000 (UTC)
From:   Andrew Jones <drjones@redhat.com>
To:     kvm@vger.kernel.org, pbonzini@redhat.com
Cc:     Alexandru Elisei <alexandru.elisei@arm.com>,
        Mark Rutland <mark.rutland@arm.com>
Subject: [PULL kvm-unit-tests 05/17] lib: arm/arm64: Remove unnecessary dcache maintenance operations
Date:   Mon,  6 Jan 2020 11:03:35 +0100
Message-Id: <20200106100347.1559-6-drjones@redhat.com>
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

On ARMv7 with multiprocessing extensions (which are mandated by the
virtualization extensions [1]), and on ARMv8, translation table walks are
coherent [2, 3], which means that no dcache maintenance operations are
required when changing the tables. Remove the maintenance operations so
that we do only the minimum required to ensure correctness.

Translation table walks are coherent if the memory where the tables
themselves reside have the same shareability and cacheability attributes
as the translation table walks. For ARMv8, this is already the case, and
it is only a matter of removing the cache operations.

However, for ARMv7, translation table walks were being configured as
Non-shareable (TTBCR.SH0 =3D 0b00) and Non-cacheable
(TTBCR.{I,O}RGN0 =3D 0b00). Fix that by marking them as Inner Shareable,
Normal memory, Inner and Outer Write-Back Write-Allocate Cacheable.

Because translation table walks are now coherent on arm, replace the
TLBIMVAA operation with TLBIMVAAIS in flush_tlb_page, which acts on the
Inner Shareable domain instead of being private to the PE.

The functions that update the translation table are called when the MMU
is off, or to modify permissions, in the case of the cache test, so
break-before-make is not necessary.

[1] ARM DDI 0406C.d, section B1.7
[2] ARM DDI 0406C.d, section B3.3.1
[3] ARM DDI 0487E.a, section D13.2.72
[4] ARM DDI 0487E.a, section K11.5.3

Reported-by: Mark Rutland <mark.rutland@arm.com>
Signed-off-by: Alexandru Elisei <alexandru.elisei@arm.com>
Signed-off-by: Andrew Jones <drjones@redhat.com>
---
 arm/cstart.S                |  7 +++++--
 lib/arm/asm/mmu.h           |  4 ++--
 lib/arm/asm/pgtable-hwdef.h |  8 ++++++++
 lib/arm/mmu.c               | 14 +-------------
 4 files changed, 16 insertions(+), 17 deletions(-)

diff --git a/arm/cstart.S b/arm/cstart.S
index bc6219d8a3ee..8c041da50ae2 100644
--- a/arm/cstart.S
+++ b/arm/cstart.S
@@ -9,6 +9,7 @@
 #include <auxinfo.h>
 #include <asm/thread_info.h>
 #include <asm/asm-offsets.h>
+#include <asm/pgtable-hwdef.h>
 #include <asm/ptrace.h>
 #include <asm/sysreg.h>
=20
@@ -166,9 +167,11 @@ halt:
 .globl asm_mmu_enable
 asm_mmu_enable:
 	/* TTBCR */
-	mrc	p15, 0, r2, c2, c0, 2
-	orr	r2, #(1 << 31)		@ TTB_EAE
+	ldr	r2, =3D(TTBCR_EAE | 				\
+		      TTBCR_SH0_SHARED | 			\
+		      TTBCR_IRGN0_WBWA | TTBCR_ORGN0_WBWA)
 	mcr	p15, 0, r2, c2, c0, 2
+	isb
=20
 	/* MAIR */
 	ldr	r2, =3DPRRR
diff --git a/lib/arm/asm/mmu.h b/lib/arm/asm/mmu.h
index 915c2b07dead..361f3cdcc3d5 100644
--- a/lib/arm/asm/mmu.h
+++ b/lib/arm/asm/mmu.h
@@ -31,8 +31,8 @@ static inline void flush_tlb_all(void)
=20
 static inline void flush_tlb_page(unsigned long vaddr)
 {
-	/* TLBIMVAA */
-	asm volatile("mcr p15, 0, %0, c8, c7, 3" :: "r" (vaddr));
+	/* TLBIMVAAIS */
+	asm volatile("mcr p15, 0, %0, c8, c3, 3" :: "r" (vaddr));
 	dsb();
 	isb();
 }
diff --git a/lib/arm/asm/pgtable-hwdef.h b/lib/arm/asm/pgtable-hwdef.h
index c08e6e2c01b4..4f24c78ee011 100644
--- a/lib/arm/asm/pgtable-hwdef.h
+++ b/lib/arm/asm/pgtable-hwdef.h
@@ -108,4 +108,12 @@
 #define PHYS_MASK_SHIFT		(40)
 #define PHYS_MASK		((_AC(1, ULL) << PHYS_MASK_SHIFT) - 1)
=20
+#define TTBCR_IRGN0_WBWA	(_AC(1, UL) << 8)
+#define TTBCR_ORGN0_WBWA	(_AC(1, UL) << 10)
+#define TTBCR_SH0_SHARED	(_AC(3, UL) << 12)
+#define TTBCR_IRGN1_WBWA	(_AC(1, UL) << 24)
+#define TTBCR_ORGN1_WBWA	(_AC(1, UL) << 26)
+#define TTBCR_SH1_SHARED	(_AC(3, UL) << 28)
+#define TTBCR_EAE		(_AC(1, UL) << 31)
+
 #endif /* _ASMARM_PGTABLE_HWDEF_H_ */
diff --git a/lib/arm/mmu.c b/lib/arm/mmu.c
index 78db22e6af14..5c31c00ccb31 100644
--- a/lib/arm/mmu.c
+++ b/lib/arm/mmu.c
@@ -73,17 +73,6 @@ void mmu_disable(void)
 	asm_mmu_disable();
 }
=20
-static void flush_entry(pgd_t *pgtable, uintptr_t vaddr)
-{
-	pgd_t *pgd =3D pgd_offset(pgtable, vaddr);
-	pmd_t *pmd =3D pmd_offset(pgd, vaddr);
-
-	flush_dcache_addr((ulong)pgd);
-	flush_dcache_addr((ulong)pmd);
-	flush_dcache_addr((ulong)pte_offset(pmd, vaddr));
-	flush_tlb_page(vaddr);
-}
-
 static pteval_t *get_pte(pgd_t *pgtable, uintptr_t vaddr)
 {
 	pgd_t *pgd =3D pgd_offset(pgtable, vaddr);
@@ -98,7 +87,7 @@ static pteval_t *install_pte(pgd_t *pgtable, uintptr_t =
vaddr, pteval_t pte)
 	pteval_t *p_pte =3D get_pte(pgtable, vaddr);
=20
 	*p_pte =3D pte;
-	flush_entry(pgtable, vaddr);
+	flush_tlb_page(vaddr);
 	return p_pte;
 }
=20
@@ -148,7 +137,6 @@ void mmu_set_range_sect(pgd_t *pgtable, uintptr_t vir=
t_offset,
 		pgd_val(*pgd) =3D paddr;
 		pgd_val(*pgd) |=3D PMD_TYPE_SECT | PMD_SECT_AF | PMD_SECT_S;
 		pgd_val(*pgd) |=3D pgprot_val(prot);
-		flush_dcache_addr((ulong)pgd);
 		flush_tlb_page(vaddr);
 	}
 }
--=20
2.21.0

