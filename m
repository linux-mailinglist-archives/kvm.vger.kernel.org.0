Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A2998130FEB
	for <lists+kvm@lfdr.de>; Mon,  6 Jan 2020 11:04:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726484AbgAFKEJ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 6 Jan 2020 05:04:09 -0500
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:21218 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726498AbgAFKEI (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 6 Jan 2020 05:04:08 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1578305047;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=HpCRdtfOfEwYfb8ng+pocxnbSgz5NKQpQTrzqY+1vng=;
        b=bxx+Vj41GB0VBNbguiNq5DuvEknFrjri6smUVcn1d82yglE4jFdMBl5ZDODrbRmoHueqco
        1qaPatb06eUf8+Hi6OA4Ko53srm18gIAhjGbFJcEUJ2UrQXf4vzZnrSCcE0DPoEJSh8eRG
        Bzl1ITtW0dnompK+edFyRdeIL5CkbUQ=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-428-raJCSS1WMuukgHYA7AXeLw-1; Mon, 06 Jan 2020 05:04:05 -0500
X-MC-Unique: raJCSS1WMuukgHYA7AXeLw-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 2EAE78024CD;
        Mon,  6 Jan 2020 10:04:04 +0000 (UTC)
Received: from kamzik.brq.redhat.com (unknown [10.43.2.160])
        by smtp.corp.redhat.com (Postfix) with ESMTP id D323363BCA;
        Mon,  6 Jan 2020 10:04:02 +0000 (UTC)
From:   Andrew Jones <drjones@redhat.com>
To:     kvm@vger.kernel.org, pbonzini@redhat.com
Cc:     Alexandru Elisei <alexandru.elisei@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Andre Przywara <andre.przywara@arm.com>
Subject: [PULL kvm-unit-tests 08/17] lib: arm/arm64: Use WRITE_ONCE to update the translation tables
Date:   Mon,  6 Jan 2020 11:03:38 +0100
Message-Id: <20200106100347.1559-9-drjones@redhat.com>
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

Use WRITE_ONCE to prevent store tearing when updating an entry in the
translation tables. Without WRITE_ONCE, the compiler, even though it is
unlikely, can emit several stores when changing the table, and we might
end up with bogus TLB entries.

It's worth noting that the existing code is mostly fine without any
changes because the translation tables are updated in one of the
following situations:

- When the tables are being created with the MMU off, which means no TLB
  caching is being performed.

- When new page table entries are added as a result of vmalloc'ing a
  stack for a secondary CPU, which doesn't happen very often.

- When clearing the PTE_USER bit for the cache test, and store tearing
  has no effect on the table walker because there are no intermediate
  values between bit values 0 and 1. We still use WRITE_ONCE in this case
  for consistency.

However, the functions are global and there is nothing preventing someone
from writing a test that uses them in a different scenario. Let's make
sure that when that happens, there will be no breakage once in a blue
moon.

Reported-by: Mark Rutland <mark.rutland@arm.com>
Signed-off-by: Alexandru Elisei <alexandru.elisei@arm.com>
Reviewed-by: Andre Przywara <andre.przywara@arm.com>
Signed-off-by: Andrew Jones <drjones@redhat.com>
---
 lib/arm/asm/pgtable.h   | 12 ++++++++----
 lib/arm/mmu.c           | 19 +++++++++++++------
 lib/arm64/asm/pgtable.h |  7 +++++--
 3 files changed, 26 insertions(+), 12 deletions(-)

diff --git a/lib/arm/asm/pgtable.h b/lib/arm/asm/pgtable.h
index 241dff69b38a..794514b8c927 100644
--- a/lib/arm/asm/pgtable.h
+++ b/lib/arm/asm/pgtable.h
@@ -19,6 +19,8 @@
  * because we always allocate their pages with alloc_page(), and
  * alloc_page() always returns identity mapped pages.
  */
+#include <linux/compiler.h>
+
 #define pgtable_va(x)		((void *)(unsigned long)(x))
 #define pgtable_pa(x)		((unsigned long)(x))
=20
@@ -58,8 +60,9 @@ static inline pmd_t *pmd_alloc_one(void)
 static inline pmd_t *pmd_alloc(pgd_t *pgd, unsigned long addr)
 {
 	if (pgd_none(*pgd)) {
-		pmd_t *pmd =3D pmd_alloc_one();
-		pgd_val(*pgd) =3D pgtable_pa(pmd) | PMD_TYPE_TABLE;
+		pgd_t entry;
+		pgd_val(entry) =3D pgtable_pa(pmd_alloc_one()) | PMD_TYPE_TABLE;
+		WRITE_ONCE(*pgd, entry);
 	}
 	return pmd_offset(pgd, addr);
 }
@@ -84,8 +87,9 @@ static inline pte_t *pte_alloc_one(void)
 static inline pte_t *pte_alloc(pmd_t *pmd, unsigned long addr)
 {
 	if (pmd_none(*pmd)) {
-		pte_t *pte =3D pte_alloc_one();
-		pmd_val(*pmd) =3D pgtable_pa(pte) | PMD_TYPE_TABLE;
+		pmd_t entry;
+		pmd_val(entry) =3D pgtable_pa(pte_alloc_one()) | PMD_TYPE_TABLE;
+		WRITE_ONCE(*pmd, entry);
 	}
 	return pte_offset(pmd, addr);
 }
diff --git a/lib/arm/mmu.c b/lib/arm/mmu.c
index 5c31c00ccb31..86a829966a3c 100644
--- a/lib/arm/mmu.c
+++ b/lib/arm/mmu.c
@@ -17,6 +17,8 @@
 #include <asm/pgtable-hwdef.h>
 #include <asm/pgtable.h>
=20
+#include <linux/compiler.h>
+
 extern unsigned long etext;
=20
 pgd_t *mmu_idmap;
@@ -86,7 +88,7 @@ static pteval_t *install_pte(pgd_t *pgtable, uintptr_t =
vaddr, pteval_t pte)
 {
 	pteval_t *p_pte =3D get_pte(pgtable, vaddr);
=20
-	*p_pte =3D pte;
+	WRITE_ONCE(*p_pte, pte);
 	flush_tlb_page(vaddr);
 	return p_pte;
 }
@@ -131,12 +133,15 @@ void mmu_set_range_sect(pgd_t *pgtable, uintptr_t v=
irt_offset,
 	phys_addr_t paddr =3D phys_start & PGDIR_MASK;
 	uintptr_t vaddr =3D virt_offset & PGDIR_MASK;
 	uintptr_t virt_end =3D phys_end - paddr + vaddr;
+	pgd_t *pgd;
+	pgd_t entry;
=20
 	for (; vaddr < virt_end; vaddr +=3D PGDIR_SIZE, paddr +=3D PGDIR_SIZE) =
{
-		pgd_t *pgd =3D pgd_offset(pgtable, vaddr);
-		pgd_val(*pgd) =3D paddr;
-		pgd_val(*pgd) |=3D PMD_TYPE_SECT | PMD_SECT_AF | PMD_SECT_S;
-		pgd_val(*pgd) |=3D pgprot_val(prot);
+		pgd_val(entry) =3D paddr;
+		pgd_val(entry) |=3D PMD_TYPE_SECT | PMD_SECT_AF | PMD_SECT_S;
+		pgd_val(entry) |=3D pgprot_val(prot);
+		pgd =3D pgd_offset(pgtable, vaddr);
+		WRITE_ONCE(*pgd, entry);
 		flush_tlb_page(vaddr);
 	}
 }
@@ -210,6 +215,7 @@ void mmu_clear_user(unsigned long vaddr)
 {
 	pgd_t *pgtable;
 	pteval_t *pte;
+	pteval_t entry;
=20
 	if (!mmu_enabled())
 		return;
@@ -217,6 +223,7 @@ void mmu_clear_user(unsigned long vaddr)
 	pgtable =3D current_thread_info()->pgtable;
 	pte =3D get_pte(pgtable, vaddr);
=20
-	*pte &=3D ~PTE_USER;
+	entry =3D *pte & ~PTE_USER;
+	WRITE_ONCE(*pte, entry);
 	flush_tlb_page(vaddr);
 }
diff --git a/lib/arm64/asm/pgtable.h b/lib/arm64/asm/pgtable.h
index ee0a2c88cc18..dbf9e7253b71 100644
--- a/lib/arm64/asm/pgtable.h
+++ b/lib/arm64/asm/pgtable.h
@@ -18,6 +18,8 @@
 #include <asm/page.h>
 #include <asm/pgtable-hwdef.h>
=20
+#include <linux/compiler.h>
+
 /*
  * We can convert va <=3D> pa page table addresses with simple casts
  * because we always allocate their pages with alloc_page(), and
@@ -66,8 +68,9 @@ static inline pte_t *pte_alloc_one(void)
 static inline pte_t *pte_alloc(pmd_t *pmd, unsigned long addr)
 {
 	if (pmd_none(*pmd)) {
-		pte_t *pte =3D pte_alloc_one();
-		pmd_val(*pmd) =3D pgtable_pa(pte) | PMD_TYPE_TABLE;
+		pmd_t entry;
+		pmd_val(entry) =3D pgtable_pa(pte_alloc_one()) | PMD_TYPE_TABLE;
+		WRITE_ONCE(*pmd, entry);
 	}
 	return pte_offset(pmd, addr);
 }
--=20
2.21.0

