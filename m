Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1846D561D48
	for <lists+kvm@lfdr.de>; Thu, 30 Jun 2022 16:16:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237030AbiF3ONu (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 30 Jun 2022 10:13:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40618 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237476AbiF3ONS (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 30 Jun 2022 10:13:18 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9EB9F1F2FB
        for <kvm@vger.kernel.org>; Thu, 30 Jun 2022 06:58:13 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 3692362167
        for <kvm@vger.kernel.org>; Thu, 30 Jun 2022 13:58:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 50356C341CD;
        Thu, 30 Jun 2022 13:58:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1656597492;
        bh=LWPbj07zdr1J5u/vxz1+ial058U/0WpGZVOfRtvuDrs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=u8usHZIihd9a312Z0uCw/7sRaSff7f9LYAeqoxQWBjSUwFhsxvcu2Kca/P+GvIn11
         JjfPlRvd+MH8l2sNoaAxTHQGgqvu09z0USPJzyQYscDAbOn1FjPHjLVJ6yuA7JePvg
         qmfY62qmwFGRoc4b3TRr1DgXxBGnrk6YBY0zZMg/WSANMVXHP1n/nyzRvE9UmTu8q9
         p9aH8I7S3LczWk6sYt7sDGQyF/D7z7sGr0ylhISVOmd/afM/Sb8+zx+ziDcyX+4xtM
         WwnnC8kqb+sQHCzesZM8Cw08Ko+gt+hScQLkr/oyzo8H8hh8MBzM+7oLuFjZb6eTKD
         qJf45FF7PsH2w==
From:   Will Deacon <will@kernel.org>
To:     kvmarm@lists.cs.columbia.edu
Cc:     Will Deacon <will@kernel.org>, Ard Biesheuvel <ardb@kernel.org>,
        Sean Christopherson <seanjc@google.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Andy Lutomirski <luto@amacapital.net>,
        Catalin Marinas <catalin.marinas@arm.com>,
        James Morse <james.morse@arm.com>,
        Chao Peng <chao.p.peng@linux.intel.com>,
        Quentin Perret <qperret@google.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Michael Roth <michael.roth@amd.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Fuad Tabba <tabba@google.com>,
        Oliver Upton <oliver.upton@linux.dev>,
        Marc Zyngier <maz@kernel.org>, kernel-team@android.com,
        kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: [PATCH v2 04/24] KVM: arm64: Back hyp_vmemmap for all of memory
Date:   Thu, 30 Jun 2022 14:57:27 +0100
Message-Id: <20220630135747.26983-5-will@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20220630135747.26983-1-will@kernel.org>
References: <20220630135747.26983-1-will@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Quentin Perret <qperret@google.com>

The EL2 vmemmap in nVHE Protected mode is currently very sparse: only
memory pages owned by the hypervisor itself have a matching struct
hyp_page. But since the size of these structs has been reduced
significantly, it appears that we can afford backing the vmemmap for all
of memory.

This will simplify a lot memory tracking as the hypervisor will have a
place to store metadata (e.g. refcounts) that wouldn't otherwise fit in
the 4 SW bits we have in the host stage-2 page-table for instance.

Signed-off-by: Quentin Perret <qperret@google.com>
Signed-off-by: Will Deacon <will@kernel.org>
---
 arch/arm64/include/asm/kvm_pkvm.h    | 26 +++++++++++++++++++++++
 arch/arm64/kvm/hyp/include/nvhe/mm.h | 14 +------------
 arch/arm64/kvm/hyp/nvhe/mm.c         | 31 ++++++++++++++++++++++++----
 arch/arm64/kvm/hyp/nvhe/page_alloc.c |  4 +---
 arch/arm64/kvm/hyp/nvhe/setup.c      |  7 +++----
 arch/arm64/kvm/pkvm.c                | 18 ++--------------
 6 files changed, 60 insertions(+), 40 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_pkvm.h b/arch/arm64/include/asm/kvm_pkvm.h
index 9f4ad2a8df59..8f7b8a2314bb 100644
--- a/arch/arm64/include/asm/kvm_pkvm.h
+++ b/arch/arm64/include/asm/kvm_pkvm.h
@@ -14,6 +14,32 @@
 extern struct memblock_region kvm_nvhe_sym(hyp_memory)[];
 extern unsigned int kvm_nvhe_sym(hyp_memblock_nr);
 
+static inline unsigned long
+hyp_vmemmap_memblock_size(struct memblock_region *reg, size_t vmemmap_entry_size)
+{
+	unsigned long nr_pages = reg->size >> PAGE_SHIFT;
+	unsigned long start, end;
+
+	start = (reg->base >> PAGE_SHIFT) * vmemmap_entry_size;
+	end = start + nr_pages * vmemmap_entry_size;
+	start = ALIGN_DOWN(start, PAGE_SIZE);
+	end = ALIGN(end, PAGE_SIZE);
+
+	return end - start;
+}
+
+static inline unsigned long hyp_vmemmap_pages(size_t vmemmap_entry_size)
+{
+	unsigned long res = 0, i;
+
+	for (i = 0; i < kvm_nvhe_sym(hyp_memblock_nr); i++) {
+		res += hyp_vmemmap_memblock_size(&kvm_nvhe_sym(hyp_memory)[i],
+						 vmemmap_entry_size);
+	}
+
+	return res >> PAGE_SHIFT;
+}
+
 static inline unsigned long __hyp_pgtable_max_pages(unsigned long nr_pages)
 {
 	unsigned long total = 0, i;
diff --git a/arch/arm64/kvm/hyp/include/nvhe/mm.h b/arch/arm64/kvm/hyp/include/nvhe/mm.h
index 42d8eb9bfe72..b2ee6d5df55b 100644
--- a/arch/arm64/kvm/hyp/include/nvhe/mm.h
+++ b/arch/arm64/kvm/hyp/include/nvhe/mm.h
@@ -15,7 +15,7 @@ extern hyp_spinlock_t pkvm_pgd_lock;
 
 int hyp_create_idmap(u32 hyp_va_bits);
 int hyp_map_vectors(void);
-int hyp_back_vmemmap(phys_addr_t phys, unsigned long size, phys_addr_t back);
+int hyp_back_vmemmap(phys_addr_t back);
 int pkvm_cpu_set_vector(enum arm64_hyp_spectre_vector slot);
 int pkvm_create_mappings(void *from, void *to, enum kvm_pgtable_prot prot);
 int pkvm_create_mappings_locked(void *from, void *to, enum kvm_pgtable_prot prot);
@@ -24,16 +24,4 @@ int __pkvm_create_private_mapping(phys_addr_t phys, size_t size,
 				  unsigned long *haddr);
 int pkvm_alloc_private_va_range(size_t size, unsigned long *haddr);
 
-static inline void hyp_vmemmap_range(phys_addr_t phys, unsigned long size,
-				     unsigned long *start, unsigned long *end)
-{
-	unsigned long nr_pages = size >> PAGE_SHIFT;
-	struct hyp_page *p = hyp_phys_to_page(phys);
-
-	*start = (unsigned long)p;
-	*end = *start + nr_pages * sizeof(struct hyp_page);
-	*start = ALIGN_DOWN(*start, PAGE_SIZE);
-	*end = ALIGN(*end, PAGE_SIZE);
-}
-
 #endif /* __KVM_HYP_MM_H */
diff --git a/arch/arm64/kvm/hyp/nvhe/mm.c b/arch/arm64/kvm/hyp/nvhe/mm.c
index 96193cb31a39..d3a3b47181de 100644
--- a/arch/arm64/kvm/hyp/nvhe/mm.c
+++ b/arch/arm64/kvm/hyp/nvhe/mm.c
@@ -129,13 +129,36 @@ int pkvm_create_mappings(void *from, void *to, enum kvm_pgtable_prot prot)
 	return ret;
 }
 
-int hyp_back_vmemmap(phys_addr_t phys, unsigned long size, phys_addr_t back)
+int hyp_back_vmemmap(phys_addr_t back)
 {
-	unsigned long start, end;
+	unsigned long i, start, size, end = 0;
+	int ret;
 
-	hyp_vmemmap_range(phys, size, &start, &end);
+	for (i = 0; i < hyp_memblock_nr; i++) {
+		start = hyp_memory[i].base;
+		start = ALIGN_DOWN((u64)hyp_phys_to_page(start), PAGE_SIZE);
+		/*
+		 * The begining of the hyp_vmemmap region for the current
+		 * memblock may already be backed by the page backing the end
+		 * the previous region, so avoid mapping it twice.
+		 */
+		start = max(start, end);
+
+		end = hyp_memory[i].base + hyp_memory[i].size;
+		end = PAGE_ALIGN((u64)hyp_phys_to_page(end));
+		if (start >= end)
+			continue;
+
+		size = end - start;
+		ret = __pkvm_create_mappings(start, size, back, PAGE_HYP);
+		if (ret)
+			return ret;
+
+		memset(hyp_phys_to_virt(back), 0, size);
+		back += size;
+	}
 
-	return __pkvm_create_mappings(start, end - start, back, PAGE_HYP);
+	return 0;
 }
 
 static void *__hyp_bp_vect_base;
diff --git a/arch/arm64/kvm/hyp/nvhe/page_alloc.c b/arch/arm64/kvm/hyp/nvhe/page_alloc.c
index e6e4b550752b..01976a58d850 100644
--- a/arch/arm64/kvm/hyp/nvhe/page_alloc.c
+++ b/arch/arm64/kvm/hyp/nvhe/page_alloc.c
@@ -235,10 +235,8 @@ int hyp_pool_init(struct hyp_pool *pool, u64 pfn, unsigned int nr_pages,
 
 	/* Init the vmemmap portion */
 	p = hyp_phys_to_page(phys);
-	for (i = 0; i < nr_pages; i++) {
-		p[i].order = 0;
+	for (i = 0; i < nr_pages; i++)
 		hyp_set_page_refcounted(&p[i]);
-	}
 
 	/* Attach the unused pages to the buddy tree */
 	for (i = reserved_pages; i < nr_pages; i++)
diff --git a/arch/arm64/kvm/hyp/nvhe/setup.c b/arch/arm64/kvm/hyp/nvhe/setup.c
index e8d4ea2fcfa0..579eb4f73476 100644
--- a/arch/arm64/kvm/hyp/nvhe/setup.c
+++ b/arch/arm64/kvm/hyp/nvhe/setup.c
@@ -31,12 +31,11 @@ static struct hyp_pool hpool;
 
 static int divide_memory_pool(void *virt, unsigned long size)
 {
-	unsigned long vstart, vend, nr_pages;
+	unsigned long nr_pages;
 
 	hyp_early_alloc_init(virt, size);
 
-	hyp_vmemmap_range(__hyp_pa(virt), size, &vstart, &vend);
-	nr_pages = (vend - vstart) >> PAGE_SHIFT;
+	nr_pages = hyp_vmemmap_pages(sizeof(struct hyp_page));
 	vmemmap_base = hyp_early_alloc_contig(nr_pages);
 	if (!vmemmap_base)
 		return -ENOMEM;
@@ -78,7 +77,7 @@ static int recreate_hyp_mappings(phys_addr_t phys, unsigned long size,
 	if (ret)
 		return ret;
 
-	ret = hyp_back_vmemmap(phys, size, hyp_virt_to_phys(vmemmap_base));
+	ret = hyp_back_vmemmap(hyp_virt_to_phys(vmemmap_base));
 	if (ret)
 		return ret;
 
diff --git a/arch/arm64/kvm/pkvm.c b/arch/arm64/kvm/pkvm.c
index ebecb7c045f4..34229425b25d 100644
--- a/arch/arm64/kvm/pkvm.c
+++ b/arch/arm64/kvm/pkvm.c
@@ -53,7 +53,7 @@ static int __init register_memblock_regions(void)
 
 void __init kvm_hyp_reserve(void)
 {
-	u64 nr_pages, prev, hyp_mem_pages = 0;
+	u64 hyp_mem_pages = 0;
 	int ret;
 
 	if (!is_hyp_mode_available() || is_kernel_in_hyp_mode())
@@ -71,21 +71,7 @@ void __init kvm_hyp_reserve(void)
 
 	hyp_mem_pages += hyp_s1_pgtable_pages();
 	hyp_mem_pages += host_s2_pgtable_pages();
-
-	/*
-	 * The hyp_vmemmap needs to be backed by pages, but these pages
-	 * themselves need to be present in the vmemmap, so compute the number
-	 * of pages needed by looking for a fixed point.
-	 */
-	nr_pages = 0;
-	do {
-		prev = nr_pages;
-		nr_pages = hyp_mem_pages + prev;
-		nr_pages = DIV_ROUND_UP(nr_pages * STRUCT_HYP_PAGE_SIZE,
-					PAGE_SIZE);
-		nr_pages += __hyp_pgtable_max_pages(nr_pages);
-	} while (nr_pages != prev);
-	hyp_mem_pages += nr_pages;
+	hyp_mem_pages += hyp_vmemmap_pages(STRUCT_HYP_PAGE_SIZE);
 
 	/*
 	 * Try to allocate a PMD-aligned region to reduce TLB pressure once
-- 
2.37.0.rc0.161.g10f37bed90-goog

