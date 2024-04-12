Return-Path: <kvm+bounces-14509-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 8761D8A2C7A
	for <lists+kvm@lfdr.de>; Fri, 12 Apr 2024 12:36:50 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id AA2EE1C23AC0
	for <lists+kvm@lfdr.de>; Fri, 12 Apr 2024 10:36:49 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A814C57876;
	Fri, 12 Apr 2024 10:35:07 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CDE315730A
	for <kvm@vger.kernel.org>; Fri, 12 Apr 2024 10:35:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712918107; cv=none; b=Y6Kp2I8dpB9MJNV98eiak/RAXBuuBLx9lOyg6DxB4neWaoe9XVBQdzPn19MMAEWg4wb1ggPL44dhYYUb+cu6nJ9HvZYTekHoRLTmp0s3do9Q69RmdN9n0orSf/A9f5abgXLY0neefqWyyu+65/cztyIFr/MkT2ukMoFVQ55W/Xk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712918107; c=relaxed/simple;
	bh=Iz1tzHd06vo8/Hh7eG8kN11XPO46RPr6U7d77Y1J/7k=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=Mn9UFGw4sWR3vJsw6M9OP2jKmxlNmh8VJyKLMcYWfsY9cOYujHdHkPkBVrdjWcMH0DXLARuQG2W6fpzCQOrwTb8KCwW8Yzl0X3lHmyT2S2T56im5Sh8SKyVfqfjTnrT7AK7RN3GL26Mw4aiMGdN2mlGfqw1SRva0ztinIy/I6OA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 7B80A1596;
	Fri, 12 Apr 2024 03:35:34 -0700 (PDT)
Received: from ewhatever.cambridge.arm.com (ewhatever.cambridge.arm.com [10.1.197.1])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id 8519C3F64C;
	Fri, 12 Apr 2024 03:35:03 -0700 (PDT)
From: Suzuki K Poulose <suzuki.poulose@arm.com>
To: kvmarm@lists.linux.dev
Cc: kvm@vger.kernel.org,
	linux-coco@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org,
	maz@kernel.org,
	alexandru.elisei@arm.com,
	joey.gouly@arm.com,
	steven.price@arm.com,
	james.morse@arm.com,
	oliver.upton@linux.dev,
	yuzenghui@huawei.com,
	andrew.jones@linux.dev,
	eric.auger@redhat.com,
	Suzuki K Poulose <suzuki.poulose@arm.com>
Subject: [kvm-unit-tests PATCH 23/33] arm: realm: Enable memory encryption
Date: Fri, 12 Apr 2024 11:33:58 +0100
Message-Id: <20240412103408.2706058-24-suzuki.poulose@arm.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20240412103408.2706058-1-suzuki.poulose@arm.com>
References: <20240412103408.2706058-1-suzuki.poulose@arm.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Enable memory encryption support for Realms.

When a page is "decrypted", we set the RIPAS to EMPTY, hinting to the hypervisor
that it could reclaim the page backing the IPA. Also the pagetable is updated
with the PTE_NS_SHARED attrbiute, which in effect turns the "ipa" to the
unprotected alias.

Similarly for "encryption" we mark the IPA back to RIPAS_RAM and clear the
PTE_NS_SHARED attribute.

The addresses passed into the helpers must be idmap/linear map addresses.

Signed-off-by: Suzuki K Poulose <suzuki.poulose@arm.com>
---
 lib/arm/asm/io.h   |  6 ++++
 lib/arm/mmu.c      | 72 +++++++++++++++++++++++++++++++++++++++++++---
 lib/arm64/asm/io.h |  6 ++++
 3 files changed, 80 insertions(+), 4 deletions(-)

diff --git a/lib/arm/asm/io.h b/lib/arm/asm/io.h
index e4caa6ff..8529f668 100644
--- a/lib/arm/asm/io.h
+++ b/lib/arm/asm/io.h
@@ -95,6 +95,12 @@ static inline void *phys_to_virt(phys_addr_t x)
 	return (void *)__phys_to_virt(x);
 }
 
+extern void set_memory_decrypted(unsigned long va, size_t size);
+#define set_memory_decrypted		set_memory_decrypted
+
+extern void set_memory_encrypted(unsigned long va, size_t size);
+#define set_memory_encrypted	set_memory_encrypted
+
 #include <asm-generic/io.h>
 
 #endif /* _ASMARM_IO_H_ */
diff --git a/lib/arm/mmu.c b/lib/arm/mmu.c
index 16ceffcc..4d5770dc 100644
--- a/lib/arm/mmu.c
+++ b/lib/arm/mmu.c
@@ -23,6 +23,7 @@
 #include <linux/compiler.h>
 
 pgd_t *mmu_idmap;
+unsigned long idmap_end;
 
 /* Used by Realms, depends on IPA size */
 unsigned long prot_ns_shared = 0;
@@ -31,6 +32,11 @@ unsigned long phys_mask_shift = 48;
 /* CPU 0 starts with disabled MMU */
 static cpumask_t mmu_enabled_cpumask;
 
+static bool is_idmap_address(phys_addr_t pa)
+{
+	return pa < idmap_end;
+}
+
 bool mmu_enabled(void)
 {
 	/*
@@ -93,12 +99,17 @@ static pteval_t *get_pte(pgd_t *pgtable, uintptr_t vaddr)
 	return &pte_val(*pte);
 }
 
-static pteval_t *install_pte(pgd_t *pgtable, uintptr_t vaddr, pteval_t pte)
+static void set_pte(uintptr_t vaddr, pteval_t *p_pte, pteval_t pte)
 {
-	pteval_t *p_pte = get_pte(pgtable, vaddr);
-
 	WRITE_ONCE(*p_pte, pte);
 	flush_tlb_page(vaddr);
+}
+
+static pteval_t *install_pte(pgd_t *pgtable, uintptr_t vaddr, pteval_t pte)
+{
+	pteval_t *p_pte = get_pte(pgtable, vaddr);
+
+	set_pte(vaddr, p_pte, pte);
 	return p_pte;
 }
 
@@ -171,6 +182,39 @@ phys_addr_t virt_to_pte_phys(pgd_t *pgtable, void *virt)
 		((phys_addr_t)(unsigned long)virt & ~mask);
 }
 
+/*
+ * __idmap_set_range_prot - Apply permissions to the given idmap range.
+ */
+static void __idmap_set_range_prot(unsigned long virt_offset, size_t size, pgprot_t prot)
+{
+	pteval_t *ptep;
+	pteval_t default_prot = PTE_TYPE_PAGE | PTE_AF | PTE_SHARED;
+
+	while (size > 0) {
+		pteval_t pte = virt_offset | default_prot | pgprot_val(prot);
+
+		if (!is_idmap_address(virt_offset))
+			break;
+		/* Break before make : Clear the PTE entry first */
+		ptep = install_pte(mmu_idmap, (uintptr_t)virt_offset, 0);
+		/* Now apply the changes */
+		set_pte((uintptr_t)virt_offset, ptep, pte);
+
+		size -= PAGE_SIZE;
+		virt_offset += PAGE_SIZE;
+	}
+}
+
+static void idmap_set_range_shared(unsigned long virt_offset, size_t size)
+{
+	return __idmap_set_range_prot(virt_offset, size, __pgprot(PTE_WBWA | PTE_USER | PTE_NS_SHARED));
+}
+
+static void idmap_set_range_protected(unsigned long virt_offset, size_t size)
+{
+	__idmap_set_range_prot(virt_offset, size, __pgprot(PTE_WBWA | PTE_USER));
+}
+
 void mmu_set_range_ptes(pgd_t *pgtable, uintptr_t virt_offset,
 			phys_addr_t phys_start, phys_addr_t phys_end,
 			pgprot_t prot)
@@ -210,11 +254,12 @@ void mmu_set_range_sect(pgd_t *pgtable, uintptr_t virt_offset,
 void *setup_mmu(phys_addr_t phys_end, void *unused)
 {
 	struct mem_region *r;
+	unsigned long end = 0;
 
 	/* 3G-4G region is reserved for vmalloc, cap phys_end at 3G */
 	if (phys_end > (3ul << 30))
 		phys_end = 3ul << 30;
-
+	end = phys_end;
 #ifdef __aarch64__
 	init_alloc_vpage((void*)(4ul << 30));
 
@@ -236,9 +281,12 @@ void *setup_mmu(phys_addr_t phys_end, void *unused)
 			mmu_set_range_ptes(mmu_idmap, r->start, r->start, r->end,
 					   __pgprot(PTE_WBWA | PTE_USER));
 		}
+		if (r->end > end)
+			end = r->end;
 	}
 
 	mmu_enable(mmu_idmap);
+	idmap_end = end;
 	return mmu_idmap;
 }
 
@@ -295,3 +343,19 @@ void mmu_clear_user(pgd_t *pgtable, unsigned long vaddr)
 		flush_tlb_page(vaddr);
 	}
 }
+
+void set_memory_encrypted(unsigned long va, size_t size)
+{
+	if (is_realm()) {
+		arm_set_memory_protected(__virt_to_phys(va), size);
+		idmap_set_range_protected(va, size);
+	}
+}
+
+void set_memory_decrypted(unsigned long va, size_t size)
+{
+	if (is_realm()) {
+		arm_set_memory_shared(__virt_to_phys(va), size);
+		idmap_set_range_shared(va, size);
+	}
+}
diff --git a/lib/arm64/asm/io.h b/lib/arm64/asm/io.h
index be19f471..3f71254d 100644
--- a/lib/arm64/asm/io.h
+++ b/lib/arm64/asm/io.h
@@ -89,6 +89,12 @@ static inline void *phys_to_virt(phys_addr_t x)
 	return (void *)__phys_to_virt(x);
 }
 
+extern void set_memory_decrypted(unsigned long va, size_t size);
+#define set_memory_decrypted		set_memory_decrypted
+
+extern void set_memory_encrypted(unsigned long va, size_t size);
+#define set_memory_encrypted	set_memory_encrypted
+
 #include <asm-generic/io.h>
 
 #endif /* _ASMARM64_IO_H_ */
-- 
2.34.1


