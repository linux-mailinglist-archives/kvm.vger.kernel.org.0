Return-Path: <kvm+bounces-33002-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 97D519E3796
	for <lists+kvm@lfdr.de>; Wed,  4 Dec 2024 11:35:26 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 590BE280E43
	for <lists+kvm@lfdr.de>; Wed,  4 Dec 2024 10:35:25 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 31C941F12FF;
	Wed,  4 Dec 2024 10:31:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="sDoF8VaH"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 580C21E3DF7;
	Wed,  4 Dec 2024 10:31:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733308288; cv=none; b=kSmq65Fh47rgF6OsnvYah0/QMUVnOd24rKLojVjXA8to1HY5YSKLKEe2hBsdIgzNSfyppcFGno7oiSgPLfvUq2JNzc2i+kr7naL3H+zqeuWNbqdhJcSkVpWYN4tEWiX3HsP14Xiq36vTJ1G0assNazlN1G0ZPtITCOQlGMsy+38=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733308288; c=relaxed/simple;
	bh=NXpil0dDa1CdzIC4Hd6SCr6UtCBY59zoL0p5pdLcUns=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=Zg/ZZpYR27NZQcNwLOxpJ2F0H/8Yy5zik/q0iZwuLMtPXzFdgNrlqjAWUwsAe87SphSNd41nvytevtzrtkdpfFy5szEMiKBs2z1nZyHtRrd80lF011I6TwzmABNejT/CIp7x/uuCoWJJFYmIEMzIka1KthHWn2WsEvzRfgfuBqY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=sDoF8VaH; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1A385C4CED6;
	Wed,  4 Dec 2024 10:31:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1733308288;
	bh=NXpil0dDa1CdzIC4Hd6SCr6UtCBY59zoL0p5pdLcUns=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=sDoF8VaHK0NiKugchsLccWP7WTeYUxReORvD6JHYVVKhEK7MVwm3fTj4jqZ1YRW7M
	 5LIb8jZ5pVDM25d0eEliFVMzlogchcIzLVgAzlF01kIFSX7SZQ6ZLZ0s8bbmeOL91e
	 uj1jlmmr6avQ97ljdkyWI/sSL+WZ8zx7jS2LyYaKr1xlnhJIQXCzyjcQJxxv9OvdAc
	 /yRmYRUtzCoYruvmpyIKUdUL0/sc3gH5UZDFvt/SiZI1MCZaJEQGX4XkXIvDEZsBLg
	 cyLQS0Nw8FojQdc1GzqcCjBNwHwe6JAJyeQtwu9/wI7M6UaRzzr2dUcB0HIMDkWTUU
	 5Hc5IYx0Nb8lw==
From: Arnd Bergmann <arnd@kernel.org>
To: linux-kernel@vger.kernel.org,
	x86@kernel.org
Cc: Arnd Bergmann <arnd@arndb.de>,
	Thomas Gleixner <tglx@linutronix.de>,
	Ingo Molnar <mingo@redhat.com>,
	Borislav Petkov <bp@alien8.de>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	"H. Peter Anvin" <hpa@zytor.com>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Andy Shevchenko <andy@kernel.org>,
	Matthew Wilcox <willy@infradead.org>,
	Sean Christopherson <seanjc@google.com>,
	Davide Ciminaghi <ciminaghi@gnudd.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	kvm@vger.kernel.org
Subject: [PATCH 07/11] x86: drop support for CONFIG_HIGHPTE
Date: Wed,  4 Dec 2024 11:30:38 +0100
Message-Id: <20241204103042.1904639-8-arnd@kernel.org>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20241204103042.1904639-1-arnd@kernel.org>
References: <20241204103042.1904639-1-arnd@kernel.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Arnd Bergmann <arnd@arndb.de>

With the maximum amount of RAM now 4GB, there is very little point
to still have PTE pages in highmem. Drop this for simplification.

The only other architecture supporting HIGHPTE is 32-bit arm, and
once that feature is removed as well, the highpte logic can be
dropped from common code as well.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
 .../admin-guide/kernel-parameters.txt         |  7 -----
 arch/x86/Kconfig                              |  9 -------
 arch/x86/include/asm/pgalloc.h                |  5 ----
 arch/x86/mm/pgtable.c                         | 27 +------------------
 4 files changed, 1 insertion(+), 47 deletions(-)

diff --git a/Documentation/admin-guide/kernel-parameters.txt b/Documentation/admin-guide/kernel-parameters.txt
index eca370e99844..cf25853a5c4a 100644
--- a/Documentation/admin-guide/kernel-parameters.txt
+++ b/Documentation/admin-guide/kernel-parameters.txt
@@ -7341,13 +7341,6 @@
 				16 - SIGBUS faults
 			Example: user_debug=31
 
-	userpte=
-			[X86,EARLY] Flags controlling user PTE allocations.
-
-				nohigh = do not allocate PTE pages in
-					HIGHMEM regardless of setting
-					of CONFIG_HIGHPTE.
-
 	vdso=		[X86,SH,SPARC]
 			On X86_32, this is an alias for vdso32=.  Otherwise:
 
diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index d0d055f6f56e..d8a8bf9ea9b9 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -1621,15 +1621,6 @@ config X86_PMEM_LEGACY
 
 	  Say Y if unsure.
 
-config HIGHPTE
-	bool "Allocate 3rd-level pagetables from highmem"
-	depends on HIGHMEM
-	help
-	  The VM uses one page table entry for each page of physical memory.
-	  For systems with a lot of RAM, this can be wasteful of precious
-	  low memory.  Setting this option will put user-space page table
-	  entries in high memory.
-
 config X86_CHECK_BIOS_CORRUPTION
 	bool "Check for low memory corruption"
 	help
diff --git a/arch/x86/include/asm/pgalloc.h b/arch/x86/include/asm/pgalloc.h
index dcd836b59beb..582cf5b7ec8c 100644
--- a/arch/x86/include/asm/pgalloc.h
+++ b/arch/x86/include/asm/pgalloc.h
@@ -29,11 +29,6 @@ static inline void paravirt_release_pud(unsigned long pfn) {}
 static inline void paravirt_release_p4d(unsigned long pfn) {}
 #endif
 
-/*
- * Flags to use when allocating a user page table page.
- */
-extern gfp_t __userpte_alloc_gfp;
-
 #ifdef CONFIG_MITIGATION_PAGE_TABLE_ISOLATION
 /*
  * Instead of one PGD, we acquire two PGDs.  Being order-1, it is
diff --git a/arch/x86/mm/pgtable.c b/arch/x86/mm/pgtable.c
index bdf63524e30a..895d91e879b4 100644
--- a/arch/x86/mm/pgtable.c
+++ b/arch/x86/mm/pgtable.c
@@ -12,12 +12,6 @@ phys_addr_t physical_mask __ro_after_init = (1ULL << __PHYSICAL_MASK_SHIFT) - 1;
 EXPORT_SYMBOL(physical_mask);
 #endif
 
-#ifdef CONFIG_HIGHPTE
-#define PGTABLE_HIGHMEM __GFP_HIGHMEM
-#else
-#define PGTABLE_HIGHMEM 0
-#endif
-
 #ifndef CONFIG_PARAVIRT
 static inline
 void paravirt_tlb_remove_table(struct mmu_gather *tlb, void *table)
@@ -26,29 +20,10 @@ void paravirt_tlb_remove_table(struct mmu_gather *tlb, void *table)
 }
 #endif
 
-gfp_t __userpte_alloc_gfp = GFP_PGTABLE_USER | PGTABLE_HIGHMEM;
-
 pgtable_t pte_alloc_one(struct mm_struct *mm)
 {
-	return __pte_alloc_one(mm, __userpte_alloc_gfp);
-}
-
-static int __init setup_userpte(char *arg)
-{
-	if (!arg)
-		return -EINVAL;
-
-	/*
-	 * "userpte=nohigh" disables allocation of user pagetables in
-	 * high memory.
-	 */
-	if (strcmp(arg, "nohigh") == 0)
-		__userpte_alloc_gfp &= ~__GFP_HIGHMEM;
-	else
-		return -EINVAL;
-	return 0;
+	return __pte_alloc_one(mm, GFP_PGTABLE_USER);
 }
-early_param("userpte", setup_userpte);
 
 void ___pte_free_tlb(struct mmu_gather *tlb, struct page *pte)
 {
-- 
2.39.5


