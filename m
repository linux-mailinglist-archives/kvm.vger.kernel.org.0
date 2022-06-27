Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A556455D6F9
	for <lists+kvm@lfdr.de>; Tue, 28 Jun 2022 15:17:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241781AbiF0V4o (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 27 Jun 2022 17:56:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59444 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241443AbiF0VzL (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 27 Jun 2022 17:55:11 -0400
Received: from mga14.intel.com (mga14.intel.com [192.55.52.115])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4D18A6561;
        Mon, 27 Jun 2022 14:54:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1656366899; x=1687902899;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=qpe8R7hqBWZ5gV/xAfrd56Tst5RgEZpDhaDmx51SRHU=;
  b=WpkJKJPkRok7sBEOm/za17zYqdXLiH/i/7lfJyMqWi41clavdbRF8q44
   5p6V5dn/GKJcHZSMFMDuI4uyon9EMzqeRZIsdWLOMqOIFxuxizoEbbqF7
   +ePUQl94+gXPE6zHOdtL7NoQiQD2siJeD87tlbgxudtSowOsdDr/wwKwI
   VR97Df1ZZkL/ideZ6JvbjnDZiruqgFjYEthG31CIrMIVb0xU8sHaXPNSD
   p1qbOywleKqyCAs3j64Hg/RmuOsKJo6jclOU0EdXr8Mi9Ax6+C6OwD/cD
   PYhLoKFRX+g6cOcG+zcShh+elOlr9s1ZWBJypNffq/O5IeFdJxmUIhSd1
   g==;
X-IronPort-AV: E=McAfee;i="6400,9594,10391"; a="281609562"
X-IronPort-AV: E=Sophos;i="5.92,227,1650956400"; 
   d="scan'208";a="281609562"
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Jun 2022 14:54:54 -0700
X-IronPort-AV: E=Sophos;i="5.92,227,1650956400"; 
   d="scan'208";a="657863577"
Received: from ls.sc.intel.com (HELO localhost) ([143.183.96.54])
  by fmsmga004-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Jun 2022 14:54:54 -0700
From:   isaku.yamahata@intel.com
To:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     isaku.yamahata@intel.com, isaku.yamahata@gmail.com,
        Paolo Bonzini <pbonzini@redhat.com>
Subject: [PATCH v7 044/102] KVM: x86/mmu: Add a private pointer to struct kvm_mmu_page
Date:   Mon, 27 Jun 2022 14:53:36 -0700
Message-Id: <392839e09c48ff4e14a598ff6ed8bd56429bf17b.1656366338.git.isaku.yamahata@intel.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <cover.1656366337.git.isaku.yamahata@intel.com>
References: <cover.1656366337.git.isaku.yamahata@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Isaku Yamahata <isaku.yamahata@intel.com>

For private GPA, CPU refers a private page table whose contents are
encrypted.  The dedicated APIs to operate on it (e.g. updating/reading its
PTE entry) are used and their cost is expensive.

When KVM resolves KVM page fault, it walks the page tables.  To reuse the
existing KVM MMU code and mitigate the heavy cost to directly walk
encrypted private page table, allocate a more page to mirror the existing
KVM page table.  Resolve KVM page fault with the existing code, and do
additional operations necessary for the mirrored private page table.  To
distinguish such cases, the existing KVM page table is called a shared page
table (i.e. no mirrored private page table), and the KVM page table with
mirrored private page table is called a private page table.  The
relationship is depicted below.

Add private pointer to struct kvm_mmu_page for mirrored private page table
and add helper functions to allocate/initialize/free a mirrored private
page table page.  Also, add helper functions to check if a given
kvm_mmu_page is private.  The later patch introduces hooks to operate on
the mirrored private page table.

              KVM page fault                     |
                     |                           |
                     V                           |
        -------------+----------                 |
        |                      |                 |
        V                      V                 |
     shared GPA           private GPA            |
        |                      |                 |
        V                      V                 |
 CPU/KVM shared PT root  KVM private PT root     |  CPU private PT root
        |                      |                 |           |
        V                      V                 |           V
     shared PT            private PT <----mirror----> mirrored private PT
        |                      |                 |           |
        |                      \-----------------+------\    |
        |                                        |      |    |
        V                                        |      V    V
  shared guest page                              |    private guest page
                                                 |
                           non-encrypted memory  |    encrypted memory
                                                 |
PT: page table

Both CPU and KVM refer to CPU/KVM shared page table.  Private page table
is used only by KVM.  CPU refers to mirrored private page table.

Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
---
 arch/x86/include/asm/kvm_host.h |  1 +
 arch/x86/kvm/mmu/mmu.c          |  9 ++++
 arch/x86/kvm/mmu/mmu_internal.h | 84 +++++++++++++++++++++++++++++++++
 arch/x86/kvm/mmu/tdp_mmu.c      |  3 ++
 4 files changed, 97 insertions(+)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index f4d4ed41641b..bfc934dc9a33 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -716,6 +716,7 @@ struct kvm_vcpu_arch {
 	struct kvm_mmu_memory_cache mmu_shadow_page_cache;
 	struct kvm_mmu_memory_cache mmu_gfn_array_cache;
 	struct kvm_mmu_memory_cache mmu_page_header_cache;
+	struct kvm_mmu_memory_cache mmu_private_sp_cache;
 
 	/*
 	 * QEMU userspace and the guest each have their own FPU state.
diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index c517c7bca105..a5bf3e40e209 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -691,6 +691,13 @@ static int mmu_topup_shadow_page_cache(struct kvm_vcpu *vcpu)
 	int start, end, i, r;
 	bool is_tdp_mmu = is_tdp_mmu_enabled(vcpu->kvm);
 
+	if (kvm_gfn_shared_mask(vcpu->kvm)) {
+		r = kvm_mmu_topup_memory_cache(&vcpu->arch.mmu_private_sp_cache,
+					       PT64_ROOT_MAX_LEVEL);
+		if (r)
+			return r;
+	}
+
 	if (is_tdp_mmu && shadow_nonpresent_value)
 		start = kvm_mmu_memory_cache_nr_free_objects(mc);
 
@@ -732,6 +739,7 @@ static void mmu_free_memory_caches(struct kvm_vcpu *vcpu)
 {
 	kvm_mmu_free_memory_cache(&vcpu->arch.mmu_pte_list_desc_cache);
 	kvm_mmu_free_memory_cache(&vcpu->arch.mmu_shadow_page_cache);
+	kvm_mmu_free_memory_cache(&vcpu->arch.mmu_private_sp_cache);
 	kvm_mmu_free_memory_cache(&vcpu->arch.mmu_gfn_array_cache);
 	kvm_mmu_free_memory_cache(&vcpu->arch.mmu_page_header_cache);
 }
@@ -1736,6 +1744,7 @@ static struct kvm_mmu_page *kvm_mmu_alloc_page(struct kvm_vcpu *vcpu, int direct
 	if (!direct)
 		sp->gfns = kvm_mmu_memory_cache_alloc(&vcpu->arch.mmu_gfn_array_cache);
 	set_page_private(virt_to_page(sp->spt), (unsigned long)sp);
+	kvm_mmu_init_private_sp(sp, NULL);
 
 	/*
 	 * active_mmu_pages must be a FIFO list, as kvm_zap_obsolete_pages()
diff --git a/arch/x86/kvm/mmu/mmu_internal.h b/arch/x86/kvm/mmu/mmu_internal.h
index 44a04fad4bed..9f3a6bea60a3 100644
--- a/arch/x86/kvm/mmu/mmu_internal.h
+++ b/arch/x86/kvm/mmu/mmu_internal.h
@@ -55,6 +55,10 @@ struct kvm_mmu_page {
 	u64 *spt;
 	/* hold the gfn of each spte inside spt */
 	gfn_t *gfns;
+#ifdef CONFIG_KVM_MMU_PRIVATE
+	/* associated private shadow page, e.g. SEPT page. */
+	void *private_sp;
+#endif
 	/* Currently serving as active root */
 	union {
 		int root_count;
@@ -115,6 +119,86 @@ static inline int kvm_mmu_page_as_id(struct kvm_mmu_page *sp)
 	return kvm_mmu_role_as_id(sp->role);
 }
 
+/*
+ * TDX vcpu allocates page for root Secure EPT page and assigns to CPU secure
+ * EPT pointer.  KVM doesn't need to allocate and link to the secure EPT.
+ * Dummy value to make is_pivate_sp() return true.
+ */
+#define KVM_MMU_PRIVATE_SP_ROOT	((void *)1)
+
+#ifdef CONFIG_KVM_MMU_PRIVATE
+static inline bool is_private_sp(struct kvm_mmu_page *sp)
+{
+	return !!sp->private_sp;
+}
+
+static inline bool is_private_sptep(u64 *sptep)
+{
+	WARN_ON(!sptep);
+	return is_private_sp(sptep_to_sp(sptep));
+}
+
+static inline void *kvm_mmu_private_sp(struct kvm_mmu_page *sp)
+{
+	return sp->private_sp;
+}
+
+static inline void kvm_mmu_init_private_sp(struct kvm_mmu_page *sp, void *private_sp)
+{
+	sp->private_sp = private_sp;
+}
+
+/* Valid sp->role.level is required. */
+static inline void kvm_mmu_alloc_private_sp(
+	struct kvm_vcpu *vcpu, struct kvm_mmu_page *sp, bool is_root)
+{
+	if (is_root)
+		sp->private_sp = KVM_MMU_PRIVATE_SP_ROOT;
+	else
+		sp->private_sp = kvm_mmu_memory_cache_alloc(
+			&vcpu->arch.mmu_private_sp_cache);
+	/*
+	 * Because mmu_private_sp_cache is topped up before staring kvm page
+	 * fault resolving, the allocation above shouldn't fail.
+	 */
+	WARN_ON_ONCE(!sp->private_sp);
+}
+
+static inline void kvm_mmu_free_private_sp(struct kvm_mmu_page *sp)
+{
+	if (sp->private_sp != KVM_MMU_PRIVATE_SP_ROOT)
+		free_page((unsigned long)sp->private_sp);
+}
+#else
+static inline bool is_private_sp(struct kvm_mmu_page *sp)
+{
+	return false;
+}
+
+static inline bool is_private_sptep(u64 *sptep)
+{
+	return false;
+}
+
+static inline void *kvm_mmu_private_sp(struct kvm_mmu_page *sp)
+{
+	return NULL;
+}
+
+static inline void kvm_mmu_init_private_sp(struct kvm_mmu_page *sp, void *private_sp)
+{
+}
+
+static inline void kvm_mmu_alloc_private_sp(
+	struct kvm_vcpu *vcpu, struct kvm_mmu_page *sp, bool is_root)
+{
+}
+
+static inline void kvm_mmu_free_private_sp(struct kvm_mmu_page *sp)
+{
+}
+#endif
+
 static inline bool kvm_mmu_page_ad_need_write_protect(struct kvm_mmu_page *sp)
 {
 	/*
diff --git a/arch/x86/kvm/mmu/tdp_mmu.c b/arch/x86/kvm/mmu/tdp_mmu.c
index 7eb41b176d1e..b2568b062faa 100644
--- a/arch/x86/kvm/mmu/tdp_mmu.c
+++ b/arch/x86/kvm/mmu/tdp_mmu.c
@@ -72,6 +72,8 @@ void kvm_mmu_uninit_tdp_mmu(struct kvm *kvm)
 
 static void tdp_mmu_free_sp(struct kvm_mmu_page *sp)
 {
+	if (is_private_sp(sp))
+		kvm_mmu_free_private_sp(sp);
 	free_page((unsigned long)sp->spt);
 	kmem_cache_free(mmu_page_header_cache, sp);
 }
@@ -295,6 +297,7 @@ static void tdp_mmu_init_sp(struct kvm_mmu_page *sp, tdp_ptep_t sptep,
 	sp->gfn = gfn;
 	sp->ptep = sptep;
 	sp->tdp_mmu_page = true;
+	kvm_mmu_init_private_sp(sp);
 
 	trace_kvm_mmu_get_page(sp, true);
 }
-- 
2.25.1

