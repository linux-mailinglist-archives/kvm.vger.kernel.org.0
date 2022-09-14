Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 348025B8310
	for <lists+kvm@lfdr.de>; Wed, 14 Sep 2022 10:36:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229688AbiINIgS (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 14 Sep 2022 04:36:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36118 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230247AbiINIgF (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 14 Sep 2022 04:36:05 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EAA17696C2
        for <kvm@vger.kernel.org>; Wed, 14 Sep 2022 01:36:00 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id BB0DE6192E
        for <kvm@vger.kernel.org>; Wed, 14 Sep 2022 08:35:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 20CE2C43142;
        Wed, 14 Sep 2022 08:35:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1663144559;
        bh=NdcwyZr3nw9nx5iSGB+jkhU/GJP7vNURVb5JHlMnQvM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=PF9ezhSqEfs46o74gQuEQadeWN9tTDEkANNdcF9rWNk0KI6EB5CJFS758rTHIYmo3
         He+pn383SeqlOQRNWvpxrnCA7XpQLPyBvga+AcekdNvHODM0xAAh2IROwAiadgOmhi
         7B5ACmtQSDi41hec6wedS9z/G3WvbTMATaTiRxVMUcOwqzoZLChlbAlaitgH3OVw8H
         TlAQ2Q0hWhwrnD5h7T4+l3CJaT8jNZI8XA3r0tnKSZ1weBq4ee8DyTbi9P0B1izycf
         YzDqJo2MyBgDWGWuYdjjq4pFaHeJPOEBS0MASJkBJCMjofOOBXxwmwGYVtBNhOdPlI
         l4iSjAefwi+AA==
From:   Will Deacon <will@kernel.org>
To:     kvmarm@lists.cs.columbia.edu
Cc:     Will Deacon <will@kernel.org>,
        Sean Christopherson <seanjc@google.com>,
        Vincent Donnefort <vdonnefort@google.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        James Morse <james.morse@arm.com>,
        Chao Peng <chao.p.peng@linux.intel.com>,
        Quentin Perret <qperret@google.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Fuad Tabba <tabba@google.com>,
        Oliver Upton <oliver.upton@linux.dev>,
        Marc Zyngier <maz@kernel.org>, kernel-team@android.com,
        kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: [PATCH v3 14/25] KVM: arm64: Add per-cpu fixmap infrastructure at EL2
Date:   Wed, 14 Sep 2022 09:34:49 +0100
Message-Id: <20220914083500.5118-15-will@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20220914083500.5118-1-will@kernel.org>
References: <20220914083500.5118-1-will@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Quentin Perret <qperret@google.com>

Mapping pages in a guest page-table from within the pKVM hypervisor at
EL2 may require cache maintenance to ensure that the initialised page
contents is visible even to non-cacheable (e.g. MMU-off) accesses from
the guest.

In preparation for performing this maintenance at EL2, introduce a
per-vCPU fixmap which allows the pKVM hypervisor to map guest pages
temporarily into its stage-1 page-table for the purposes of cache
maintenance and, in future, poisoning on the reclaim path. The use of a
fixmap avoids the need for memory allocation or locking on the map()
path.

Signed-off-by: Quentin Perret <qperret@google.com>
Signed-off-by: Will Deacon <will@kernel.org>
---
 arch/arm64/include/asm/kvm_pgtable.h          | 12 +++
 arch/arm64/kvm/hyp/include/nvhe/mem_protect.h |  2 +
 arch/arm64/kvm/hyp/include/nvhe/mm.h          |  4 +
 arch/arm64/kvm/hyp/nvhe/mem_protect.c         |  1 -
 arch/arm64/kvm/hyp/nvhe/mm.c                  | 94 +++++++++++++++++++
 arch/arm64/kvm/hyp/nvhe/setup.c               |  4 +
 arch/arm64/kvm/hyp/pgtable.c                  | 12 ---
 7 files changed, 116 insertions(+), 13 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_pgtable.h b/arch/arm64/include/asm/kvm_pgtable.h
index b5913d692ce9..6824af1f680b 100644
--- a/arch/arm64/include/asm/kvm_pgtable.h
+++ b/arch/arm64/include/asm/kvm_pgtable.h
@@ -30,6 +30,8 @@ typedef u64 kvm_pte_t;
 #define KVM_PTE_ADDR_MASK		GENMASK(47, PAGE_SHIFT)
 #define KVM_PTE_ADDR_51_48		GENMASK(15, 12)
 
+#define KVM_PHYS_INVALID		(-1ULL)
+
 static inline bool kvm_pte_valid(kvm_pte_t pte)
 {
 	return pte & KVM_PTE_VALID;
@@ -45,6 +47,16 @@ static inline u64 kvm_pte_to_phys(kvm_pte_t pte)
 	return pa;
 }
 
+static inline kvm_pte_t kvm_phys_to_pte(u64 pa)
+{
+	kvm_pte_t pte = pa & KVM_PTE_ADDR_MASK;
+
+	if (PAGE_SHIFT == 16)
+		pte |= FIELD_PREP(KVM_PTE_ADDR_51_48, pa >> 48);
+
+	return pte;
+}
+
 static inline u64 kvm_granule_shift(u32 level)
 {
 	/* Assumes KVM_PGTABLE_MAX_LEVELS is 4 */
diff --git a/arch/arm64/kvm/hyp/include/nvhe/mem_protect.h b/arch/arm64/kvm/hyp/include/nvhe/mem_protect.h
index ce9a796a85ee..ef31a1872c93 100644
--- a/arch/arm64/kvm/hyp/include/nvhe/mem_protect.h
+++ b/arch/arm64/kvm/hyp/include/nvhe/mem_protect.h
@@ -59,6 +59,8 @@ enum pkvm_component_id {
 	PKVM_ID_HYP,
 };
 
+extern unsigned long hyp_nr_cpus;
+
 int __pkvm_prot_finalize(void);
 int __pkvm_host_share_hyp(u64 pfn);
 int __pkvm_host_unshare_hyp(u64 pfn);
diff --git a/arch/arm64/kvm/hyp/include/nvhe/mm.h b/arch/arm64/kvm/hyp/include/nvhe/mm.h
index b2ee6d5df55b..d5ec972b5c1e 100644
--- a/arch/arm64/kvm/hyp/include/nvhe/mm.h
+++ b/arch/arm64/kvm/hyp/include/nvhe/mm.h
@@ -13,6 +13,10 @@
 extern struct kvm_pgtable pkvm_pgtable;
 extern hyp_spinlock_t pkvm_pgd_lock;
 
+int hyp_create_pcpu_fixmap(void);
+void *hyp_fixmap_map(phys_addr_t phys);
+void hyp_fixmap_unmap(void);
+
 int hyp_create_idmap(u32 hyp_va_bits);
 int hyp_map_vectors(void);
 int hyp_back_vmemmap(phys_addr_t back);
diff --git a/arch/arm64/kvm/hyp/nvhe/mem_protect.c b/arch/arm64/kvm/hyp/nvhe/mem_protect.c
index 2ef6aaa21ba5..1c38451050e5 100644
--- a/arch/arm64/kvm/hyp/nvhe/mem_protect.c
+++ b/arch/arm64/kvm/hyp/nvhe/mem_protect.c
@@ -21,7 +21,6 @@
 
 #define KVM_HOST_S2_FLAGS (KVM_PGTABLE_S2_NOFWB | KVM_PGTABLE_S2_IDMAP)
 
-extern unsigned long hyp_nr_cpus;
 struct host_mmu host_mmu;
 
 static struct hyp_pool host_s2_pool;
diff --git a/arch/arm64/kvm/hyp/nvhe/mm.c b/arch/arm64/kvm/hyp/nvhe/mm.c
index d3a3b47181de..b77215630d5c 100644
--- a/arch/arm64/kvm/hyp/nvhe/mm.c
+++ b/arch/arm64/kvm/hyp/nvhe/mm.c
@@ -14,6 +14,7 @@
 #include <nvhe/early_alloc.h>
 #include <nvhe/gfp.h>
 #include <nvhe/memory.h>
+#include <nvhe/mem_protect.h>
 #include <nvhe/mm.h>
 #include <nvhe/spinlock.h>
 
@@ -25,6 +26,12 @@ unsigned int hyp_memblock_nr;
 
 static u64 __io_map_base;
 
+struct hyp_fixmap_slot {
+	u64 addr;
+	kvm_pte_t *ptep;
+};
+static DEFINE_PER_CPU(struct hyp_fixmap_slot, fixmap_slots);
+
 static int __pkvm_create_mappings(unsigned long start, unsigned long size,
 				  unsigned long phys, enum kvm_pgtable_prot prot)
 {
@@ -212,6 +219,93 @@ int hyp_map_vectors(void)
 	return 0;
 }
 
+void *hyp_fixmap_map(phys_addr_t phys)
+{
+	struct hyp_fixmap_slot *slot = this_cpu_ptr(&fixmap_slots);
+	kvm_pte_t pte, *ptep = slot->ptep;
+
+	pte = *ptep;
+	pte &= ~kvm_phys_to_pte(KVM_PHYS_INVALID);
+	pte |= kvm_phys_to_pte(phys) | KVM_PTE_VALID;
+	WRITE_ONCE(*ptep, pte);
+	dsb(nshst);
+
+	return (void *)slot->addr;
+}
+
+static void fixmap_clear_slot(struct hyp_fixmap_slot *slot)
+{
+	kvm_pte_t *ptep = slot->ptep;
+	u64 addr = slot->addr;
+
+	WRITE_ONCE(*ptep, *ptep & ~KVM_PTE_VALID);
+	dsb(nshst);
+	__tlbi_level(vale2, __TLBI_VADDR(addr, 0), (KVM_PGTABLE_MAX_LEVELS - 1));
+	dsb(nsh);
+	isb();
+}
+
+void hyp_fixmap_unmap(void)
+{
+	fixmap_clear_slot(this_cpu_ptr(&fixmap_slots));
+}
+
+static int __create_fixmap_slot_cb(u64 addr, u64 end, u32 level, kvm_pte_t *ptep,
+				   enum kvm_pgtable_walk_flags flag,
+				   void * const arg)
+{
+	struct hyp_fixmap_slot *slot = per_cpu_ptr(&fixmap_slots, (u64)arg);
+
+	if (!kvm_pte_valid(*ptep) || level != KVM_PGTABLE_MAX_LEVELS - 1)
+		return -EINVAL;
+
+	slot->addr = addr;
+	slot->ptep = ptep;
+
+	/*
+	 * Clear the PTE, but keep the page-table page refcount elevated to
+	 * prevent it from ever being freed. This lets us manipulate the PTEs
+	 * by hand safely without ever needing to allocate memory.
+	 */
+	fixmap_clear_slot(slot);
+
+	return 0;
+}
+
+static int create_fixmap_slot(u64 addr, u64 cpu)
+{
+	struct kvm_pgtable_walker walker = {
+		.cb	= __create_fixmap_slot_cb,
+		.flags	= KVM_PGTABLE_WALK_LEAF,
+		.arg = (void *)cpu,
+	};
+
+	return kvm_pgtable_walk(&pkvm_pgtable, addr, PAGE_SIZE, &walker);
+}
+
+int hyp_create_pcpu_fixmap(void)
+{
+	unsigned long addr, i;
+	int ret;
+
+	for (i = 0; i < hyp_nr_cpus; i++) {
+		ret = pkvm_alloc_private_va_range(PAGE_SIZE, &addr);
+		if (ret)
+			return ret;
+
+		ret = kvm_pgtable_hyp_map(&pkvm_pgtable, addr, PAGE_SIZE,
+					  __hyp_pa(__hyp_bss_start), PAGE_HYP);
+		if (ret)
+			return ret;
+
+		ret = create_fixmap_slot(addr, i);
+		if (ret)
+			return ret;
+	}
+
+	return 0;
+}
+
 int hyp_create_idmap(u32 hyp_va_bits)
 {
 	unsigned long start, end;
diff --git a/arch/arm64/kvm/hyp/nvhe/setup.c b/arch/arm64/kvm/hyp/nvhe/setup.c
index 2be72fbe7279..0f69c1393416 100644
--- a/arch/arm64/kvm/hyp/nvhe/setup.c
+++ b/arch/arm64/kvm/hyp/nvhe/setup.c
@@ -321,6 +321,10 @@ void __noreturn __pkvm_init_finalise(void)
 	if (ret)
 		goto out;
 
+	ret = hyp_create_pcpu_fixmap();
+	if (ret)
+		goto out;
+
 	pkvm_hyp_vm_table_init(vm_table_base);
 out:
 	/*
diff --git a/arch/arm64/kvm/hyp/pgtable.c b/arch/arm64/kvm/hyp/pgtable.c
index 1d300313009d..517cecd5950c 100644
--- a/arch/arm64/kvm/hyp/pgtable.c
+++ b/arch/arm64/kvm/hyp/pgtable.c
@@ -57,8 +57,6 @@ struct kvm_pgtable_walk_data {
 	u64				end;
 };
 
-#define KVM_PHYS_INVALID (-1ULL)
-
 static bool kvm_phys_is_valid(u64 phys)
 {
 	return phys < BIT(id_aa64mmfr0_parange_to_phys_shift(ID_AA64MMFR0_PARANGE_MAX));
@@ -122,16 +120,6 @@ static bool kvm_pte_table(kvm_pte_t pte, u32 level)
 	return FIELD_GET(KVM_PTE_TYPE, pte) == KVM_PTE_TYPE_TABLE;
 }
 
-static kvm_pte_t kvm_phys_to_pte(u64 pa)
-{
-	kvm_pte_t pte = pa & KVM_PTE_ADDR_MASK;
-
-	if (PAGE_SHIFT == 16)
-		pte |= FIELD_PREP(KVM_PTE_ADDR_51_48, pa >> 48);
-
-	return pte;
-}
-
 static kvm_pte_t *kvm_pte_follow(kvm_pte_t pte, struct kvm_pgtable_mm_ops *mm_ops)
 {
 	return mm_ops->phys_to_virt(kvm_pte_to_phys(pte));
-- 
2.37.2.789.g6183377224-goog

