Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 34B58421569
	for <lists+kvm@lfdr.de>; Mon,  4 Oct 2021 19:49:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235906AbhJDRvC (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 4 Oct 2021 13:51:02 -0400
Received: from mail.kernel.org ([198.145.29.99]:60942 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235312AbhJDRuv (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 4 Oct 2021 13:50:51 -0400
Received: from disco-boy.misterjones.org (disco-boy.misterjones.org [51.254.78.96])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id BB564611F0;
        Mon,  4 Oct 2021 17:49:01 +0000 (UTC)
Received: from sofa.misterjones.org ([185.219.108.64] helo=why.lan)
        by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <maz@kernel.org>)
        id 1mXS5E-00EhBv-1M; Mon, 04 Oct 2021 18:49:00 +0100
From:   Marc Zyngier <maz@kernel.org>
To:     linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     will@kernel.org, qperret@google.com, dbrazdil@google.com,
        Steven Price <steven.price@arm.com>,
        Andrew Jones <drjones@redhat.com>,
        Fuad Tabba <tabba@google.com>,
        Srivatsa Vaddagiri <vatsa@codeaurora.org>,
        Shanker R Donthineni <sdonthineni@nvidia.com>,
        James Morse <james.morse@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        kernel-team@android.com
Subject: [PATCH v2 03/16] KVM: arm64: Turn kvm_pgtable_stage2_set_owner into kvm_pgtable_stage2_annotate
Date:   Mon,  4 Oct 2021 18:48:36 +0100
Message-Id: <20211004174849.2831548-4-maz@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20211004174849.2831548-1-maz@kernel.org>
References: <20211004174849.2831548-1-maz@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, linux-kernel@vger.kernel.org, will@kernel.org, qperret@google.com, dbrazdil@google.com, steven.price@arm.com, drjones@redhat.com, tabba@google.com, vatsa@codeaurora.org, sdonthineni@nvidia.com, james.morse@arm.com, suzuki.poulose@arm.com, alexandru.elisei@arm.com, kernel-team@android.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

kvm_pgtable_stage2_set_owner() could be generalised into a way
to store up to 63 bits in the page tables, as long as we don't
set bit 0.

Let's just do that.

Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/include/asm/kvm_pgtable.h          | 12 ++++++-----
 arch/arm64/kvm/hyp/include/nvhe/mem_protect.h |  2 +-
 arch/arm64/kvm/hyp/nvhe/mem_protect.c         | 11 ++++------
 arch/arm64/kvm/hyp/nvhe/setup.c               | 10 +++++++++-
 arch/arm64/kvm/hyp/pgtable.c                  | 20 ++++++-------------
 5 files changed, 27 insertions(+), 28 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_pgtable.h b/arch/arm64/include/asm/kvm_pgtable.h
index 027783829584..d4d3ae0b5edb 100644
--- a/arch/arm64/include/asm/kvm_pgtable.h
+++ b/arch/arm64/include/asm/kvm_pgtable.h
@@ -329,14 +329,16 @@ int kvm_pgtable_stage2_map(struct kvm_pgtable *pgt, u64 addr, u64 size,
 			   void *mc);
 
 /**
- * kvm_pgtable_stage2_set_owner() - Unmap and annotate pages in the IPA space to
- *				    track ownership.
+ * kvm_pgtable_stage2_annotate() - Unmap and annotate pages in the IPA space
+ *				   to track ownership (and more).
  * @pgt:	Page-table structure initialised by kvm_pgtable_stage2_init*().
  * @addr:	Base intermediate physical address to annotate.
  * @size:	Size of the annotated range.
  * @mc:		Cache of pre-allocated and zeroed memory from which to allocate
  *		page-table pages.
- * @owner_id:	Unique identifier for the owner of the page.
+ * @annotation:	A 63 bit value that will be stored in the page tables.
+ *		@annotation[0] must be 0, and @annotation[63:1] is stored
+ *		in the page tables.
  *
  * By default, all page-tables are owned by identifier 0. This function can be
  * used to mark portions of the IPA space as owned by other entities. When a
@@ -345,8 +347,8 @@ int kvm_pgtable_stage2_map(struct kvm_pgtable *pgt, u64 addr, u64 size,
  *
  * Return: 0 on success, negative error code on failure.
  */
-int kvm_pgtable_stage2_set_owner(struct kvm_pgtable *pgt, u64 addr, u64 size,
-				 void *mc, u8 owner_id);
+int kvm_pgtable_stage2_annotate(struct kvm_pgtable *pgt, u64 addr, u64 size,
+				void *mc, kvm_pte_t annotation);
 
 /**
  * kvm_pgtable_stage2_unmap() - Remove a mapping from a guest stage-2 page-table.
diff --git a/arch/arm64/kvm/hyp/include/nvhe/mem_protect.h b/arch/arm64/kvm/hyp/include/nvhe/mem_protect.h
index b58c910babaf..9d2ca173ea9a 100644
--- a/arch/arm64/kvm/hyp/include/nvhe/mem_protect.h
+++ b/arch/arm64/kvm/hyp/include/nvhe/mem_protect.h
@@ -53,7 +53,7 @@ int __pkvm_host_share_hyp(u64 pfn);
 
 bool addr_is_memory(phys_addr_t phys);
 int host_stage2_idmap_locked(phys_addr_t addr, u64 size, enum kvm_pgtable_prot prot);
-int host_stage2_set_owner_locked(phys_addr_t addr, u64 size, u8 owner_id);
+int host_stage2_annotate_locked(phys_addr_t addr, u64 size, kvm_pte_t owner_id);
 int kvm_host_prepare_stage2(void *pgt_pool_base);
 void handle_host_mem_abort(struct kvm_cpu_context *host_ctxt);
 
diff --git a/arch/arm64/kvm/hyp/nvhe/mem_protect.c b/arch/arm64/kvm/hyp/nvhe/mem_protect.c
index bacd493a4eac..8cd0c3bdb911 100644
--- a/arch/arm64/kvm/hyp/nvhe/mem_protect.c
+++ b/arch/arm64/kvm/hyp/nvhe/mem_protect.c
@@ -286,17 +286,14 @@ static int host_stage2_adjust_range(u64 addr, struct kvm_mem_range *range)
 int host_stage2_idmap_locked(phys_addr_t addr, u64 size,
 			     enum kvm_pgtable_prot prot)
 {
-	hyp_assert_lock_held(&host_kvm.lock);
-
 	return host_stage2_try(__host_stage2_idmap, addr, addr + size, prot);
 }
 
-int host_stage2_set_owner_locked(phys_addr_t addr, u64 size, u8 owner_id)
+int host_stage2_annotate_locked(phys_addr_t addr, u64 size,
+				kvm_pte_t annotation)
 {
-	hyp_assert_lock_held(&host_kvm.lock);
-
-	return host_stage2_try(kvm_pgtable_stage2_set_owner, &host_kvm.pgt,
-			       addr, size, &host_s2_pool, owner_id);
+	return host_stage2_try(kvm_pgtable_stage2_annotate, &host_kvm.pgt,
+			       addr, size, &host_s2_pool, annotation);
 }
 
 static bool host_stage2_force_pte_cb(u64 addr, u64 end, enum kvm_pgtable_prot prot)
diff --git a/arch/arm64/kvm/hyp/nvhe/setup.c b/arch/arm64/kvm/hyp/nvhe/setup.c
index 57c27846320f..d489fb9b8c29 100644
--- a/arch/arm64/kvm/hyp/nvhe/setup.c
+++ b/arch/arm64/kvm/hyp/nvhe/setup.c
@@ -159,6 +159,13 @@ static void hpool_put_page(void *addr)
 	hyp_put_page(&hpool, addr);
 }
 
+#define KVM_INVALID_PTE_OWNER_MASK	GENMASK(9, 2)
+
+static kvm_pte_t kvm_init_invalid_leaf_owner(u8 owner_id)
+{
+	return FIELD_PREP(KVM_INVALID_PTE_OWNER_MASK, owner_id);
+}
+
 static int finalize_host_mappings_walker(u64 addr, u64 end, u32 level,
 					 kvm_pte_t *ptep,
 					 enum kvm_pgtable_walk_flags flag,
@@ -186,7 +193,8 @@ static int finalize_host_mappings_walker(u64 addr, u64 end, u32 level,
 	state = pkvm_getstate(kvm_pgtable_hyp_pte_prot(pte));
 	switch (state) {
 	case PKVM_PAGE_OWNED:
-		return host_stage2_set_owner_locked(phys, PAGE_SIZE, pkvm_hyp_id);
+		return host_stage2_annotate_locked(phys, PAGE_SIZE,
+						   kvm_init_invalid_leaf_owner(pkvm_hyp_id));
 	case PKVM_PAGE_SHARED_OWNED:
 		prot = pkvm_mkstate(PKVM_HOST_MEM_PROT, PKVM_PAGE_SHARED_BORROWED);
 		break;
diff --git a/arch/arm64/kvm/hyp/pgtable.c b/arch/arm64/kvm/hyp/pgtable.c
index 6bbfd952f0c5..4201e512da48 100644
--- a/arch/arm64/kvm/hyp/pgtable.c
+++ b/arch/arm64/kvm/hyp/pgtable.c
@@ -46,9 +46,6 @@
 					 KVM_PTE_LEAF_ATTR_LO_S2_S2AP_W | \
 					 KVM_PTE_LEAF_ATTR_HI_S2_XN)
 
-#define KVM_INVALID_PTE_OWNER_MASK	GENMASK(9, 2)
-#define KVM_MAX_OWNER_ID		1
-
 struct kvm_pgtable_walk_data {
 	struct kvm_pgtable		*pgt;
 	struct kvm_pgtable_walker	*walker;
@@ -167,11 +164,6 @@ static kvm_pte_t kvm_init_valid_leaf_pte(u64 pa, kvm_pte_t attr, u32 level)
 	return pte;
 }
 
-static kvm_pte_t kvm_init_invalid_leaf_owner(u8 owner_id)
-{
-	return FIELD_PREP(KVM_INVALID_PTE_OWNER_MASK, owner_id);
-}
-
 static int kvm_pgtable_visitor_cb(struct kvm_pgtable_walk_data *data, u64 addr,
 				  u32 level, kvm_pte_t *ptep,
 				  enum kvm_pgtable_walk_flags flag)
@@ -503,7 +495,7 @@ void kvm_pgtable_hyp_destroy(struct kvm_pgtable *pgt)
 struct stage2_map_data {
 	u64				phys;
 	kvm_pte_t			attr;
-	u8				owner_id;
+	u64				annotation;
 
 	kvm_pte_t			*anchor;
 	kvm_pte_t			*childp;
@@ -670,7 +662,7 @@ static int stage2_map_walker_try_leaf(u64 addr, u64 end, u32 level,
 	if (kvm_phys_is_valid(phys))
 		new = kvm_init_valid_leaf_pte(phys, data->attr, level);
 	else
-		new = kvm_init_invalid_leaf_owner(data->owner_id);
+		new = data->annotation;
 
 	if (stage2_pte_is_counted(old)) {
 		/*
@@ -859,8 +851,8 @@ int kvm_pgtable_stage2_map(struct kvm_pgtable *pgt, u64 addr, u64 size,
 	return ret;
 }
 
-int kvm_pgtable_stage2_set_owner(struct kvm_pgtable *pgt, u64 addr, u64 size,
-				 void *mc, u8 owner_id)
+int kvm_pgtable_stage2_annotate(struct kvm_pgtable *pgt, u64 addr, u64 size,
+				void *mc, kvm_pte_t annotation)
 {
 	int ret;
 	struct stage2_map_data map_data = {
@@ -868,8 +860,8 @@ int kvm_pgtable_stage2_set_owner(struct kvm_pgtable *pgt, u64 addr, u64 size,
 		.mmu		= pgt->mmu,
 		.memcache	= mc,
 		.mm_ops		= pgt->mm_ops,
-		.owner_id	= owner_id,
 		.force_pte	= true,
+		.annotation	= annotation,
 	};
 	struct kvm_pgtable_walker walker = {
 		.cb		= stage2_map_walker,
@@ -879,7 +871,7 @@ int kvm_pgtable_stage2_set_owner(struct kvm_pgtable *pgt, u64 addr, u64 size,
 		.arg		= &map_data,
 	};
 
-	if (owner_id > KVM_MAX_OWNER_ID)
+	if (annotation & PTE_VALID)
 		return -EINVAL;
 
 	ret = kvm_pgtable_walk(pgt, addr, size, &walker);
-- 
2.30.2

