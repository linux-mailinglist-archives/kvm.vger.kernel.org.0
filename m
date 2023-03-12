Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D79446B6937
	for <lists+kvm@lfdr.de>; Sun, 12 Mar 2023 19:00:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231292AbjCLSAS (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 12 Mar 2023 14:00:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38754 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231228AbjCLR7g (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 12 Mar 2023 13:59:36 -0400
Received: from mga12.intel.com (mga12.intel.com [192.55.52.136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5588F234CC;
        Sun, 12 Mar 2023 10:58:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1678643898; x=1710179898;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=/RUF/1M7lbObQliay1fGdkomRTy4Urcb4yGde3C1aks=;
  b=RUCfLIFskXt1E0/QIfnIyFOMVkGNGaiJy+MA0jJ3a0Zs+UTndINiAlcG
   m/2Qn8HojsYcVR+Cq5n98kP4uzRiH60XRiU6pOwpn4UvYYl+iHfEhifSL
   G+J6DnjVhUiZN7N1QBMA8JoWQ0RxKKuLf94cDNgBypSo8Zg68SrcCX0W4
   WvW8aW9SFgpFkSVXoq8VA9UrIt7hfswMbZw8XJbW9Ii6lhGSwjgIJ53pt
   qHfHKDx2I4uh7msSrBH+BTCE8NdXWlG72PD8mFDRVDqg65tPJlVfmHNOc
   qDGZM+ibdkD0ZQwZD/I3fuFZeTgqzEAum5Shas2DcXxs1/R7o3RsBAX9Y
   Q==;
X-IronPort-AV: E=McAfee;i="6500,9779,10647"; a="316659862"
X-IronPort-AV: E=Sophos;i="5.98,254,1673942400"; 
   d="scan'208";a="316659862"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Mar 2023 10:58:04 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10647"; a="742596615"
X-IronPort-AV: E=Sophos;i="5.98,254,1673942400"; 
   d="scan'208";a="742596615"
Received: from ls.sc.intel.com (HELO localhost) ([143.183.96.54])
  by fmsmga008-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Mar 2023 10:58:04 -0700
From:   isaku.yamahata@intel.com
To:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     isaku.yamahata@intel.com, isaku.yamahata@gmail.com,
        Paolo Bonzini <pbonzini@redhat.com>, erdemaktas@google.com,
        Sean Christopherson <seanjc@google.com>,
        Sagi Shahar <sagis@google.com>,
        David Matlack <dmatlack@google.com>,
        Kai Huang <kai.huang@intel.com>,
        Zhi Wang <zhi.wang.linux@gmail.com>
Subject: [PATCH v13 042/113] KVM: x86/mmu: Add a private pointer to struct kvm_mmu_page
Date:   Sun, 12 Mar 2023 10:56:06 -0700
Message-Id: <c7701f14f3470a93ecd0e4ef152c75400acfd7f3.1678643052.git.isaku.yamahata@intel.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <cover.1678643051.git.isaku.yamahata@intel.com>
References: <cover.1678643051.git.isaku.yamahata@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_PASS,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
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
existing KVM MMU code and mitigate the heavy cost to directly walk private
page table, allocate one more page to copy the dummy page table for KVM MMU
code to directly walk.  Resolve KVM page fault with the existing code, and
do additional operations necessary for the private page table.  To
distinguish such cases, the existing KVM page table is called a shared page
table (i.e. not associated with private page table), and the page table
with private page table is called a private page table.  The relationship
is depicted below.

Add a private pointer to struct kvm_mmu_page for private page table and
add helper functions to allocate/initialize/free a private page table
page.

              KVM page fault                     |
                     |                           |
                     V                           |
        -------------+----------                 |
        |                      |                 |
        V                      V                 |
     shared GPA           private GPA            |
        |                      |                 |
        V                      V                 |
    shared PT root      dummy PT root            |    private PT root
        |                      |                 |           |
        V                      V                 |           V
     shared PT            dummy PT ----propagate---->   private PT
        |                      |                 |           |
        |                      \-----------------+------\    |
        |                                        |      |    |
        V                                        |      V    V
  shared guest page                              |    private guest page
                                                 |
                           non-encrypted memory  |    encrypted memory
                                                 |
PT: page table
- Shared PT is visible to KVM and it is used by CPU.
- Private PT is used by CPU but it is invisible to KVM.
- Dummy PT is visible to KVM but not used by CPU.  It is used to
  propagate PT change to the actual private PT which is used by CPU.

Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
---
 arch/x86/include/asm/kvm_host.h |  5 ++
 arch/x86/kvm/mmu/mmu.c          |  7 +++
 arch/x86/kvm/mmu/mmu_internal.h | 83 +++++++++++++++++++++++++++++++--
 arch/x86/kvm/mmu/tdp_mmu.c      |  1 +
 4 files changed, 92 insertions(+), 4 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 38d9a972f78e..130e6e86f009 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -817,6 +817,11 @@ struct kvm_vcpu_arch {
 	struct kvm_mmu_memory_cache mmu_shadow_page_cache;
 	struct kvm_mmu_memory_cache mmu_shadowed_info_cache;
 	struct kvm_mmu_memory_cache mmu_page_header_cache;
+	/*
+	 * This cache is to allocate private page table. E.g.  Secure-EPT used
+	 * by the TDX module.
+	 */
+	struct kvm_mmu_memory_cache mmu_private_spt_cache;
 
 	/*
 	 * QEMU userspace and the guest each have their own FPU state.
diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index ce8a896a3cfa..98f20ffd12e4 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -677,6 +677,12 @@ static int mmu_topup_memory_caches(struct kvm_vcpu *vcpu, bool maybe_indirect)
 				       1 + PT64_ROOT_MAX_LEVEL + PTE_PREFETCH_NUM);
 	if (r)
 		return r;
+	if (kvm_gfn_shared_mask(vcpu->kvm)) {
+		r = kvm_mmu_topup_memory_cache(&vcpu->arch.mmu_private_spt_cache,
+					       PT64_ROOT_MAX_LEVEL);
+		if (r)
+			return r;
+	}
 	r = kvm_mmu_topup_memory_cache(&vcpu->arch.mmu_shadow_page_cache,
 				       PT64_ROOT_MAX_LEVEL);
 	if (r)
@@ -696,6 +702,7 @@ static void mmu_free_memory_caches(struct kvm_vcpu *vcpu)
 	kvm_mmu_free_memory_cache(&vcpu->arch.mmu_pte_list_desc_cache);
 	kvm_mmu_free_memory_cache(&vcpu->arch.mmu_shadow_page_cache);
 	kvm_mmu_free_memory_cache(&vcpu->arch.mmu_shadowed_info_cache);
+	kvm_mmu_free_memory_cache(&vcpu->arch.mmu_private_spt_cache);
 	kvm_mmu_free_memory_cache(&vcpu->arch.mmu_page_header_cache);
 }
 
diff --git a/arch/x86/kvm/mmu/mmu_internal.h b/arch/x86/kvm/mmu/mmu_internal.h
index 6c6379d4dcf9..b0d4b31557b2 100644
--- a/arch/x86/kvm/mmu/mmu_internal.h
+++ b/arch/x86/kvm/mmu/mmu_internal.h
@@ -93,7 +93,23 @@ struct kvm_mmu_page {
 		int root_count;
 		refcount_t tdp_mmu_root_count;
 	};
-	unsigned int unsync_children;
+	union {
+		struct {
+			unsigned int unsync_children;
+			/*
+			 * Number of writes since the last time traversal
+			 * visited this page.
+			 */
+			atomic_t write_flooding_count;
+		};
+#ifdef CONFIG_KVM_MMU_PRIVATE
+		/*
+		 * Associated private shadow page table, e.g. Secure-EPT page
+		 * passed to the TDX module.
+		 */
+		void *private_spt;
+#endif
+	};
 	union {
 		struct kvm_rmap_head parent_ptes; /* rmap pointers to parent sptes */
 		tdp_ptep_t ptep;
@@ -122,9 +138,6 @@ struct kvm_mmu_page {
 	int clear_spte_count;
 #endif
 
-	/* Number of writes since the last time traversal visited this page.  */
-	atomic_t write_flooding_count;
-
 #ifdef CONFIG_X86_64
 	/* Used for freeing the page asynchronously if it is a TDP MMU page. */
 	struct rcu_head rcu_head;
@@ -148,6 +161,68 @@ static inline bool is_private_sp(const struct kvm_mmu_page *sp)
 	return kvm_mmu_page_role_is_private(sp->role);
 }
 
+#ifdef CONFIG_KVM_MMU_PRIVATE
+static inline void *kvm_mmu_private_spt(struct kvm_mmu_page *sp)
+{
+	return sp->private_spt;
+}
+
+static inline void kvm_mmu_init_private_spt(struct kvm_mmu_page *sp, void *private_spt)
+{
+	sp->private_spt = private_spt;
+}
+
+static inline void kvm_mmu_alloc_private_spt(struct kvm_vcpu *vcpu, struct kvm_mmu_page *sp)
+{
+	bool is_root = vcpu->arch.root_mmu.root_role.level == sp->role.level;
+
+	KVM_BUG_ON(!kvm_mmu_page_role_is_private(sp->role), vcpu->kvm);
+	if (is_root)
+		/*
+		 * Because TDX module assigns root Secure-EPT page and set it to
+		 * Secure-EPTP when TD vcpu is created, secure page table for
+		 * root isn't needed.
+		 */
+		sp->private_spt = NULL;
+	else {
+		/*
+		 * Because the TDX module doesn't trust VMM and initializes
+		 * the pages itself, KVM doesn't initialize them.  Allocate
+		 * pages with garbage and give them to the TDX module.
+		 */
+		sp->private_spt = kvm_mmu_memory_cache_alloc(&vcpu->arch.mmu_private_spt_cache);
+		/*
+		 * Because mmu_private_spt_cache is topped up before staring kvm
+		 * page fault resolving, the allocation above shouldn't fail.
+		 */
+		WARN_ON_ONCE(!sp->private_spt);
+	}
+}
+
+static inline void kvm_mmu_free_private_spt(struct kvm_mmu_page *sp)
+{
+	if (sp->private_spt)
+		free_page((unsigned long)sp->private_spt);
+}
+#else
+static inline void *kvm_mmu_private_spt(struct kvm_mmu_page *sp)
+{
+	return NULL;
+}
+
+static inline void kvm_mmu_init_private_spt(struct kvm_mmu_page *sp, void *private_spt)
+{
+}
+
+static inline void kvm_mmu_alloc_private_spt(struct kvm_vcpu *vcpu, struct kvm_mmu_page *sp)
+{
+}
+
+static inline void kvm_mmu_free_private_spt(struct kvm_mmu_page *sp)
+{
+}
+#endif
+
 static inline bool kvm_mmu_page_ad_need_write_protect(struct kvm_mmu_page *sp)
 {
 	/*
diff --git a/arch/x86/kvm/mmu/tdp_mmu.c b/arch/x86/kvm/mmu/tdp_mmu.c
index 920d5dc633b0..4094bc080a6c 100644
--- a/arch/x86/kvm/mmu/tdp_mmu.c
+++ b/arch/x86/kvm/mmu/tdp_mmu.c
@@ -56,6 +56,7 @@ void kvm_mmu_uninit_tdp_mmu(struct kvm *kvm)
 
 static void tdp_mmu_free_sp(struct kvm_mmu_page *sp)
 {
+	kvm_mmu_free_private_spt(sp);
 	free_page((unsigned long)sp->spt);
 	kmem_cache_free(mmu_page_header_cache, sp);
 }
-- 
2.25.1

