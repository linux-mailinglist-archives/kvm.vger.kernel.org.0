Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A2C3469A4BB
	for <lists+kvm@lfdr.de>; Fri, 17 Feb 2023 05:12:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229505AbjBQEMs (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 16 Feb 2023 23:12:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39062 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230220AbjBQEMn (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 16 Feb 2023 23:12:43 -0500
Received: from mail-yw1-x1149.google.com (mail-yw1-x1149.google.com [IPv6:2607:f8b0:4864:20::1149])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6C6995BD85
        for <kvm@vger.kernel.org>; Thu, 16 Feb 2023 20:12:41 -0800 (PST)
Received: by mail-yw1-x1149.google.com with SMTP id 00721157ae682-52ee93d7863so44927457b3.18
        for <kvm@vger.kernel.org>; Thu, 16 Feb 2023 20:12:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:references:mime-version:message-id:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=6v2BS1UfItgh1K5tfej0Iq92+WtqqMzCx/cGSgmoiSg=;
        b=gziB1BrvY9BHZS7WfBeSnKEbTJsWIJ/fFr2/PiFmwtTyfe68OsIjhQ61dZpnb87SkA
         JE0OnpGDz5FxpkIlNn0nA2tfqnhJ3b3cHbwE9Flj2oR041XOL5Rmeeme4csAtb6QB8A7
         1dwd6zfVUE8cwmDds621GWHJkAxZcDvbF53xftCwvOocB2lzYTkdoHlckg6k5SWObsu/
         JnAmp96+xPUNaXs4fnLZH6LMMVGk9cwNJZuiX9VYpp8GDr7rFYU2r6amNuFL9lTtFwOC
         0QGI/m4BCLP0eKmz8qQupuOfcUmAy+lDPbfLsyqst4coAeQie4wxcpaUJpvs3jf5QJc4
         t1MA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:references:mime-version:message-id:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=6v2BS1UfItgh1K5tfej0Iq92+WtqqMzCx/cGSgmoiSg=;
        b=ErchCXw33PL/BBnurRaCjyWtSQ8RDJLbo/Me1gOXivFoIfYE8tJ8KJHG0Csz4a0OWQ
         wo+F1Q0bO1Ain/o0aVhiV5twbOavfpzsewYaDudTKA6UCubLw0Loooy+1GUxeCa8Lb1X
         96WoWQWWLvVg9wVcTw1enUaNAFh4ZOrJ0J5c7pq7Rj4ouctQynji9oh1XPYARlhVvMOH
         VtIVml1jArsyXe+QSucNKZWSBv30SWG91O+mPfHHOEfRR/KCMNvftURrlLIj/p5XgzM4
         big2HCsFbxhxRMhEj6HlSm5KS4b5ggU81+fNsglIjr09DrYPV66g5OHC1NmDjlS7APkR
         1r4A==
X-Gm-Message-State: AO0yUKUtLoT66KxqbfW5SeJEFS2j52XxkAMQgrgfNSFH5PoQ66v0Q8ca
        0mth8wlfHBqWDfHaY0pU+kRQnJx3V1g=
X-Google-Smtp-Source: AK7set/Pxuk29uHWJwH5Tc+hpFqe2YNk4NRZV8/+4ud1blKjBerJFMDRpndxfsiGGJtM3eObeOVv77vpkZw=
X-Received: from yuzhao.bld.corp.google.com ([2620:15c:183:200:6fb3:61e:d31f:1ad3])
 (user=yuzhao job=sendgmr) by 2002:a25:9c83:0:b0:93c:785a:ba76 with SMTP id
 y3-20020a259c83000000b0093c785aba76mr1106910ybo.617.1676607160685; Thu, 16
 Feb 2023 20:12:40 -0800 (PST)
Date:   Thu, 16 Feb 2023 21:12:28 -0700
In-Reply-To: <20230217041230.2417228-1-yuzhao@google.com>
Message-Id: <20230217041230.2417228-4-yuzhao@google.com>
Mime-Version: 1.0
References: <20230217041230.2417228-1-yuzhao@google.com>
X-Mailer: git-send-email 2.39.2.637.g21b0678d19-goog
Subject: [PATCH mm-unstable v1 3/5] kvm/arm64: add kvm_arch_test_clear_young()
From:   Yu Zhao <yuzhao@google.com>
To:     Andrew Morton <akpm@linux-foundation.org>,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     Jonathan Corbet <corbet@lwn.net>,
        Michael Larabel <michael@michaellarabel.com>,
        kvmarm@lists.linux.dev, kvm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, linuxppc-dev@lists.ozlabs.org, x86@kernel.org,
        linux-mm@google.com, Yu Zhao <yuzhao@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This patch adds kvm_arch_test_clear_young() for the vast majority of
VMs that are not pKVM and run on hardware that sets the accessed bit
in KVM page tables.

It relies on two techniques, RCU and cmpxchg, to safely test and clear
the accessed bit without taking the MMU lock. The former protects KVM
page tables from being freed while the latter clears the accessed bit
atomically against both the hardware and other software page table
walkers.

Signed-off-by: Yu Zhao <yuzhao@google.com>
---
 arch/arm64/include/asm/kvm_host.h       |  7 +++
 arch/arm64/include/asm/kvm_pgtable.h    |  8 +++
 arch/arm64/include/asm/stage2_pgtable.h | 43 ++++++++++++++
 arch/arm64/kvm/arm.c                    |  1 +
 arch/arm64/kvm/hyp/pgtable.c            | 51 ++--------------
 arch/arm64/kvm/mmu.c                    | 77 ++++++++++++++++++++++++-
 6 files changed, 141 insertions(+), 46 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
index 35a159d131b5..572bcd321586 100644
--- a/arch/arm64/include/asm/kvm_host.h
+++ b/arch/arm64/include/asm/kvm_host.h
@@ -1031,4 +1031,11 @@ static inline void kvm_hyp_reserve(void) { }
 void kvm_arm_vcpu_power_off(struct kvm_vcpu *vcpu);
 bool kvm_arm_vcpu_stopped(struct kvm_vcpu *vcpu);
 
+/* see the comments on the generic kvm_arch_has_test_clear_young() */
+#define kvm_arch_has_test_clear_young kvm_arch_has_test_clear_young
+static inline bool kvm_arch_has_test_clear_young(void)
+{
+	return IS_ENABLED(CONFIG_KVM) && cpu_has_hw_af() && !is_protected_kvm_enabled();
+}
+
 #endif /* __ARM64_KVM_HOST_H__ */
diff --git a/arch/arm64/include/asm/kvm_pgtable.h b/arch/arm64/include/asm/kvm_pgtable.h
index 63f81b27a4e3..8c9a04388c88 100644
--- a/arch/arm64/include/asm/kvm_pgtable.h
+++ b/arch/arm64/include/asm/kvm_pgtable.h
@@ -105,6 +105,7 @@ static inline bool kvm_level_supports_block_mapping(u32 level)
  * @put_page:			Decrement the refcount on a page. When the
  *				refcount reaches 0 the page is automatically
  *				freed.
+ * @put_page_rcu:		RCU variant of put_page().
  * @page_count:			Return the refcount of a page.
  * @phys_to_virt:		Convert a physical address into a virtual
  *				address	mapped in the current context.
@@ -122,6 +123,7 @@ struct kvm_pgtable_mm_ops {
 	void		(*free_removed_table)(void *addr, u32 level);
 	void		(*get_page)(void *addr);
 	void		(*put_page)(void *addr);
+	void		(*put_page_rcu)(void *addr);
 	int		(*page_count)(void *addr);
 	void*		(*phys_to_virt)(phys_addr_t phys);
 	phys_addr_t	(*virt_to_phys)(void *addr);
@@ -188,6 +190,12 @@ typedef bool (*kvm_pgtable_force_pte_cb_t)(u64 addr, u64 end,
  *					children.
  * @KVM_PGTABLE_WALK_SHARED:		Indicates the page-tables may be shared
  *					with other software walkers.
+ *
+ * kvm_arch_test_clear_young() is a special case. It relies on two
+ * techniques, RCU and cmpxchg, to safely test and clear the accessed
+ * bit without taking the MMU lock. The former protects KVM page tables
+ * from being freed while the latter clears the accessed bit atomically
+ * against both the hardware and other software page table walkers.
  */
 enum kvm_pgtable_walk_flags {
 	KVM_PGTABLE_WALK_LEAF			= BIT(0),
diff --git a/arch/arm64/include/asm/stage2_pgtable.h b/arch/arm64/include/asm/stage2_pgtable.h
index c8dca8ae359c..350437661d4b 100644
--- a/arch/arm64/include/asm/stage2_pgtable.h
+++ b/arch/arm64/include/asm/stage2_pgtable.h
@@ -30,4 +30,47 @@
  */
 #define kvm_mmu_cache_min_pages(kvm)	(kvm_stage2_levels(kvm) - 1)
 
+#define KVM_PTE_TYPE			BIT(1)
+#define KVM_PTE_TYPE_BLOCK		0
+#define KVM_PTE_TYPE_PAGE		1
+#define KVM_PTE_TYPE_TABLE		1
+
+#define KVM_PTE_LEAF_ATTR_LO		GENMASK(11, 2)
+
+#define KVM_PTE_LEAF_ATTR_LO_S1_ATTRIDX	GENMASK(4, 2)
+#define KVM_PTE_LEAF_ATTR_LO_S1_AP	GENMASK(7, 6)
+#define KVM_PTE_LEAF_ATTR_LO_S1_AP_RO	3
+#define KVM_PTE_LEAF_ATTR_LO_S1_AP_RW	1
+#define KVM_PTE_LEAF_ATTR_LO_S1_SH	GENMASK(9, 8)
+#define KVM_PTE_LEAF_ATTR_LO_S1_SH_IS	3
+#define KVM_PTE_LEAF_ATTR_LO_S1_AF	BIT(10)
+
+#define KVM_PTE_LEAF_ATTR_LO_S2_MEMATTR	GENMASK(5, 2)
+#define KVM_PTE_LEAF_ATTR_LO_S2_S2AP_R	BIT(6)
+#define KVM_PTE_LEAF_ATTR_LO_S2_S2AP_W	BIT(7)
+#define KVM_PTE_LEAF_ATTR_LO_S2_SH	GENMASK(9, 8)
+#define KVM_PTE_LEAF_ATTR_LO_S2_SH_IS	3
+#define KVM_PTE_LEAF_ATTR_LO_S2_AF	BIT(10)
+
+#define KVM_PTE_LEAF_ATTR_HI		GENMASK(63, 51)
+
+#define KVM_PTE_LEAF_ATTR_HI_SW		GENMASK(58, 55)
+
+#define KVM_PTE_LEAF_ATTR_HI_S1_XN	BIT(54)
+
+#define KVM_PTE_LEAF_ATTR_HI_S2_XN	BIT(54)
+
+#define KVM_PTE_LEAF_ATTR_S2_PERMS	(KVM_PTE_LEAF_ATTR_LO_S2_S2AP_R | \
+					 KVM_PTE_LEAF_ATTR_LO_S2_S2AP_W | \
+					 KVM_PTE_LEAF_ATTR_HI_S2_XN)
+
+#define KVM_INVALID_PTE_OWNER_MASK	GENMASK(9, 2)
+#define KVM_MAX_OWNER_ID		1
+
+/*
+ * Used to indicate a pte for which a 'break-before-make' sequence is in
+ * progress.
+ */
+#define KVM_INVALID_PTE_LOCKED		BIT(10)
+
 #endif	/* __ARM64_S2_PGTABLE_H_ */
diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
index 9c5573bc4614..6770bc47f5c9 100644
--- a/arch/arm64/kvm/arm.c
+++ b/arch/arm64/kvm/arm.c
@@ -191,6 +191,7 @@ vm_fault_t kvm_arch_vcpu_fault(struct kvm_vcpu *vcpu, struct vm_fault *vmf)
  */
 void kvm_arch_destroy_vm(struct kvm *kvm)
 {
+	kvm_free_stage2_pgd(&kvm->arch.mmu);
 	bitmap_free(kvm->arch.pmu_filter);
 	free_cpumask_var(kvm->arch.supported_cpus);
 
diff --git a/arch/arm64/kvm/hyp/pgtable.c b/arch/arm64/kvm/hyp/pgtable.c
index b11cf2c618a6..8d65ee4767f1 100644
--- a/arch/arm64/kvm/hyp/pgtable.c
+++ b/arch/arm64/kvm/hyp/pgtable.c
@@ -12,49 +12,6 @@
 #include <asm/stage2_pgtable.h>
 
 
-#define KVM_PTE_TYPE			BIT(1)
-#define KVM_PTE_TYPE_BLOCK		0
-#define KVM_PTE_TYPE_PAGE		1
-#define KVM_PTE_TYPE_TABLE		1
-
-#define KVM_PTE_LEAF_ATTR_LO		GENMASK(11, 2)
-
-#define KVM_PTE_LEAF_ATTR_LO_S1_ATTRIDX	GENMASK(4, 2)
-#define KVM_PTE_LEAF_ATTR_LO_S1_AP	GENMASK(7, 6)
-#define KVM_PTE_LEAF_ATTR_LO_S1_AP_RO	3
-#define KVM_PTE_LEAF_ATTR_LO_S1_AP_RW	1
-#define KVM_PTE_LEAF_ATTR_LO_S1_SH	GENMASK(9, 8)
-#define KVM_PTE_LEAF_ATTR_LO_S1_SH_IS	3
-#define KVM_PTE_LEAF_ATTR_LO_S1_AF	BIT(10)
-
-#define KVM_PTE_LEAF_ATTR_LO_S2_MEMATTR	GENMASK(5, 2)
-#define KVM_PTE_LEAF_ATTR_LO_S2_S2AP_R	BIT(6)
-#define KVM_PTE_LEAF_ATTR_LO_S2_S2AP_W	BIT(7)
-#define KVM_PTE_LEAF_ATTR_LO_S2_SH	GENMASK(9, 8)
-#define KVM_PTE_LEAF_ATTR_LO_S2_SH_IS	3
-#define KVM_PTE_LEAF_ATTR_LO_S2_AF	BIT(10)
-
-#define KVM_PTE_LEAF_ATTR_HI		GENMASK(63, 51)
-
-#define KVM_PTE_LEAF_ATTR_HI_SW		GENMASK(58, 55)
-
-#define KVM_PTE_LEAF_ATTR_HI_S1_XN	BIT(54)
-
-#define KVM_PTE_LEAF_ATTR_HI_S2_XN	BIT(54)
-
-#define KVM_PTE_LEAF_ATTR_S2_PERMS	(KVM_PTE_LEAF_ATTR_LO_S2_S2AP_R | \
-					 KVM_PTE_LEAF_ATTR_LO_S2_S2AP_W | \
-					 KVM_PTE_LEAF_ATTR_HI_S2_XN)
-
-#define KVM_INVALID_PTE_OWNER_MASK	GENMASK(9, 2)
-#define KVM_MAX_OWNER_ID		1
-
-/*
- * Used to indicate a pte for which a 'break-before-make' sequence is in
- * progress.
- */
-#define KVM_INVALID_PTE_LOCKED		BIT(10)
-
 struct kvm_pgtable_walk_data {
 	struct kvm_pgtable_walker	*walker;
 
@@ -994,8 +951,12 @@ static int stage2_unmap_walker(const struct kvm_pgtable_visit_ctx *ctx,
 		mm_ops->dcache_clean_inval_poc(kvm_pte_follow(ctx->old, mm_ops),
 					       kvm_granule_size(ctx->level));
 
-	if (childp)
-		mm_ops->put_page(childp);
+	if (childp) {
+		if (mm_ops->put_page_rcu)
+			mm_ops->put_page_rcu(childp);
+		else
+			mm_ops->put_page(childp);
+	}
 
 	return 0;
 }
diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
index a3ee3b605c9b..761fffc788f5 100644
--- a/arch/arm64/kvm/mmu.c
+++ b/arch/arm64/kvm/mmu.c
@@ -171,6 +171,21 @@ static int kvm_host_page_count(void *addr)
 	return page_count(virt_to_page(addr));
 }
 
+static void kvm_s2_rcu_put_page(struct rcu_head *head)
+{
+	put_page(container_of(head, struct page, rcu_head));
+}
+
+static void kvm_s2_put_page_rcu(void *addr)
+{
+	struct page *page = virt_to_page(addr);
+
+	if (kvm_host_page_count(addr) == 1)
+		kvm_account_pgtable_pages(addr, -1);
+
+	call_rcu(&page->rcu_head, kvm_s2_rcu_put_page);
+}
+
 static phys_addr_t kvm_host_pa(void *addr)
 {
 	return __pa(addr);
@@ -684,6 +699,7 @@ static struct kvm_pgtable_mm_ops kvm_s2_mm_ops = {
 	.free_removed_table	= stage2_free_removed_table,
 	.get_page		= kvm_host_get_page,
 	.put_page		= kvm_s2_put_page,
+	.put_page_rcu		= kvm_s2_put_page_rcu,
 	.page_count		= kvm_host_page_count,
 	.phys_to_virt		= kvm_host_va,
 	.virt_to_phys		= kvm_host_pa,
@@ -1624,6 +1640,66 @@ bool kvm_age_gfn(struct kvm *kvm, struct kvm_gfn_range *range)
 	return pte_valid(pte) && pte_young(pte);
 }
 
+struct test_clear_young_arg {
+	struct kvm_gfn_range *range;
+	gfn_t lsb_gfn;
+	unsigned long *bitmap;
+};
+
+static int stage2_test_clear_young(const struct kvm_pgtable_visit_ctx *ctx,
+				   enum kvm_pgtable_walk_flags flags)
+{
+	struct test_clear_young_arg *arg = ctx->arg;
+	gfn_t gfn = ctx->addr / PAGE_SIZE;
+	kvm_pte_t new = ctx->old & ~KVM_PTE_LEAF_ATTR_LO_S2_AF;
+
+	VM_WARN_ON_ONCE(!page_count(virt_to_page(ctx->ptep)));
+	VM_WARN_ON_ONCE(gfn < arg->range->start || gfn >= arg->range->end);
+
+	if (!kvm_pte_valid(new))
+		return 0;
+
+	if (new == ctx->old)
+		return 0;
+
+	/* see the comments on the generic kvm_arch_has_test_clear_young() */
+	if (__test_and_change_bit(arg->lsb_gfn - gfn, arg->bitmap))
+		cmpxchg64(ctx->ptep, ctx->old, new);
+
+	return 0;
+}
+
+bool kvm_arch_test_clear_young(struct kvm *kvm, struct kvm_gfn_range *range,
+			       gfn_t lsb_gfn, unsigned long *bitmap)
+{
+	u64 start = range->start * PAGE_SIZE;
+	u64 end = range->end * PAGE_SIZE;
+	struct test_clear_young_arg arg = {
+		.range		= range,
+		.lsb_gfn	= lsb_gfn,
+		.bitmap		= bitmap,
+	};
+	struct kvm_pgtable_walker walker = {
+		.cb		= stage2_test_clear_young,
+		.arg		= &arg,
+		.flags		= KVM_PGTABLE_WALK_LEAF,
+	};
+
+	BUILD_BUG_ON(is_hyp_code());
+
+	if (WARN_ON_ONCE(!kvm_arch_has_test_clear_young()))
+		return false;
+
+	/* see the comments on kvm_pgtable_walk_flags */
+	rcu_read_lock();
+
+	kvm_pgtable_walk(kvm->arch.mmu.pgt, start, end - start, &walker);
+
+	rcu_read_unlock();
+
+	return true;
+}
+
 bool kvm_test_age_gfn(struct kvm *kvm, struct kvm_gfn_range *range)
 {
 	if (!kvm->arch.mmu.pgt)
@@ -1848,7 +1924,6 @@ void kvm_arch_memslots_updated(struct kvm *kvm, u64 gen)
 
 void kvm_arch_flush_shadow_all(struct kvm *kvm)
 {
-	kvm_free_stage2_pgd(&kvm->arch.mmu);
 }
 
 void kvm_arch_flush_shadow_memslot(struct kvm *kvm,
-- 
2.39.2.637.g21b0678d19-goog

