Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D500A5F08A0
	for <lists+kvm@lfdr.de>; Fri, 30 Sep 2022 12:21:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232043AbiI3KVk (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 30 Sep 2022 06:21:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33974 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231591AbiI3KTJ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 30 Sep 2022 06:19:09 -0400
Received: from mga12.intel.com (mga12.intel.com [192.55.52.136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 91465184818;
        Fri, 30 Sep 2022 03:19:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1664533146; x=1696069146;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=eMAYrSW/5qYSJlJLH5ZEJvn4Gdu38EaJ747W91OgwZg=;
  b=F9VaNnk4DfY2wCdjBLgyo0Q5s8SVsq1bIGOpYiVA4AqeRzY6KqpqQjZD
   DAGnkJs4G42ZzTX/dOm0U2eXiOqV1yoVqcY8eSyWLqL958ohXLAH7O6Dm
   S35n2iHFgPO1rbclj/lbEfoh+OwgyXBiN6xsePftRNw330NlakarNMALy
   FFfgWEZzXuftyLvG3tgBwTmqYTdjanxWhGuqHpbxTWzpgviFH4NmG1v48
   IDrw2HUVmwwHq6asEm3kAvxwMgCB3/5+qD3iSRf+dmdBHSreaCRLwTJ1R
   rrYoIU5visaebnR9MVVTaCmh8GJZe1FZuHqqnVkcD366bPEqTR2EqJgds
   g==;
X-IronPort-AV: E=McAfee;i="6500,9779,10485"; a="281870101"
X-IronPort-AV: E=Sophos;i="5.93,358,1654585200"; 
   d="scan'208";a="281870101"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Sep 2022 03:18:58 -0700
X-IronPort-AV: E=McAfee;i="6500,9779,10485"; a="726807643"
X-IronPort-AV: E=Sophos;i="5.93,358,1654585200"; 
   d="scan'208";a="726807643"
Received: from ls.sc.intel.com (HELO localhost) ([143.183.96.54])
  by fmsmga002-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Sep 2022 03:18:58 -0700
From:   isaku.yamahata@intel.com
To:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     isaku.yamahata@intel.com, isaku.yamahata@gmail.com,
        Paolo Bonzini <pbonzini@redhat.com>, erdemaktas@google.com,
        Sean Christopherson <seanjc@google.com>,
        Sagi Shahar <sagis@google.com>
Subject: [PATCH v9 044/105] KVM: x86/mmu: Add a private pointer to struct kvm_mmu_page
Date:   Fri, 30 Sep 2022 03:17:38 -0700
Message-Id: <09c731bc5c12ff3c0bb2929305206a8d8f87d68c.1664530907.git.isaku.yamahata@intel.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <cover.1664530907.git.isaku.yamahata@intel.com>
References: <cover.1664530907.git.isaku.yamahata@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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
existing KVM MMU code and mitigate the heavy cost to directly walk
protected (encrypted) page table, allocate one more page to copy the
protected page table for KVM MMU code to directly walk.  Resolve KVM page
fault with the existing code, and do additional operations necessary for
the protected page table.  To distinguish such cases, the existing KVM page
table is called a shared page table (i.e. not associated with protected
page table), and the page table with protected page table is called a
private page table.  The relationship is depicted below.

Add a private pointer to struct kvm_mmu_page for protected page table and
add helper functions to allocate/initialize/free a protected page table
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
    shared PT root      private PT root          |    protected PT root
        |                      |                 |           |
        V                      V                 |           V
     shared PT            private PT ----propagate----> protected PT
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
- Protected PT is used by CPU but it is invisible to KVM.
- Private PT is visible to KVM but not used by CPU.  It is used to
  propagate PT change to the actual protected PT which is used by CPU.

Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
---
 arch/x86/include/asm/kvm_host.h |  7 +++
 arch/x86/kvm/mmu/mmu.c          |  8 +++
 arch/x86/kvm/mmu/mmu_internal.h | 90 +++++++++++++++++++++++++++++++--
 arch/x86/kvm/mmu/tdp_mmu.c      |  1 +
 4 files changed, 102 insertions(+), 4 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 5f18a6c16715..789a8de4028a 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -743,6 +743,13 @@ struct kvm_vcpu_arch {
 	struct kvm_mmu_memory_cache mmu_shadow_page_cache;
 	struct kvm_mmu_memory_cache mmu_shadowed_info_cache;
 	struct kvm_mmu_memory_cache mmu_page_header_cache;
+	/*
+	 * This cache is to allocate private page table. E.g.  Secure-EPT used
+	 * by the TDX module.  Because the TDX module doesn't trust VMM and
+	 * initializes the pages itself, KVM doesn't initialize them.  Allocate
+	 * pages with garbage and give them to the TDX module.
+	 */
+	struct kvm_mmu_memory_cache mmu_private_spt_cache;
 
 	/*
 	 * QEMU userspace and the guest each have their own FPU state.
diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index 97d575f787cc..7b38d9f4c457 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -653,6 +653,13 @@ static int mmu_topup_shadow_page_cache(struct kvm_vcpu *vcpu)
 	struct kvm_mmu_memory_cache *mc = &vcpu->arch.mmu_shadow_page_cache;
 	int start, end, i, r;
 
+	if (kvm_gfn_shared_mask(vcpu->kvm)) {
+		r = kvm_mmu_topup_memory_cache(&vcpu->arch.mmu_private_spt_cache,
+					       PT64_ROOT_MAX_LEVEL);
+		if (r)
+			return r;
+	}
+
 	start = kvm_mmu_memory_cache_nr_free_objects(mc);
 	r = kvm_mmu_topup_memory_cache(mc, PT64_ROOT_MAX_LEVEL);
 
@@ -702,6 +709,7 @@ static void mmu_free_memory_caches(struct kvm_vcpu *vcpu)
 	kvm_mmu_free_memory_cache(&vcpu->arch.mmu_pte_list_desc_cache);
 	kvm_mmu_free_memory_cache(&vcpu->arch.mmu_shadow_page_cache);
 	kvm_mmu_free_memory_cache(&vcpu->arch.mmu_shadowed_info_cache);
+	kvm_mmu_free_memory_cache(&vcpu->arch.mmu_private_spt_cache);
 	kvm_mmu_free_memory_cache(&vcpu->arch.mmu_page_header_cache);
 }
 
diff --git a/arch/x86/kvm/mmu/mmu_internal.h b/arch/x86/kvm/mmu/mmu_internal.h
index 222ee61a415a..fb867270829e 100644
--- a/arch/x86/kvm/mmu/mmu_internal.h
+++ b/arch/x86/kvm/mmu/mmu_internal.h
@@ -87,7 +87,23 @@ struct kvm_mmu_page {
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
@@ -109,9 +125,6 @@ struct kvm_mmu_page {
 	int clear_spte_count;
 #endif
 
-	/* Number of writes since the last time traversal visited this page.  */
-	atomic_t write_flooding_count;
-
 #ifdef CONFIG_X86_64
 	/* Used for freeing the page asynchronously if it is a TDP MMU page. */
 	struct rcu_head rcu_head;
@@ -153,6 +166,75 @@ static inline bool is_private_sptep(u64 *sptep)
 	return is_private_sp(sptep_to_sp(sptep));
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
+static inline void kvm_mmu_alloc_private_spt(struct kvm_vcpu *vcpu,
+					     struct kvm_mmu_memory_cache *private_spt_cache,
+					     struct kvm_mmu_page *sp)
+{
+	/*
+	 * vcpu == NULL means non-root SPT:
+	 * vcpu == NULL is used to split a large SPT into smaller SPT.  Root SPT
+	 * is not a large SPT.
+	 */
+	bool is_root = vcpu &&
+		vcpu->arch.root_mmu.root_role.level == sp->role.level;
+
+	if (vcpu)
+		private_spt_cache = &vcpu->arch.mmu_private_spt_cache;
+	KVM_BUG_ON(!kvm_mmu_page_role_is_private(sp->role), vcpu->kvm);
+	if (is_root)
+		/*
+		 * Because TDX module assigns root Secure-EPT page and set it to
+		 * Secure-EPTP when TD vcpu is created, secure page table for
+		 * root isn't needed.
+		 */
+		sp->private_spt = NULL;
+	else {
+		sp->private_spt = kvm_mmu_memory_cache_alloc(private_spt_cache);
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
+static inline void kvm_mmu_alloc_private_spt(struct kvm_vcpu *vcpu,
+					     struct kvm_mmu_memory_cache *private_spt_cache,
+					     struct kvm_mmu_page *sp)
+{
+}
+
+static inline void kvm_mmu_free_private_spt(struct kvm_mmu_page *sp)
+{
+}
+#endif
+
 bool kvm_mem_attr_is_mixed(struct kvm_memory_slot *slot, gfn_t gfn, int level);
 
 static inline bool kvm_mmu_page_ad_need_write_protect(struct kvm_mmu_page *sp)
diff --git a/arch/x86/kvm/mmu/tdp_mmu.c b/arch/x86/kvm/mmu/tdp_mmu.c
index 8f20c3857397..9327a77d7434 100644
--- a/arch/x86/kvm/mmu/tdp_mmu.c
+++ b/arch/x86/kvm/mmu/tdp_mmu.c
@@ -71,6 +71,7 @@ void kvm_mmu_uninit_tdp_mmu(struct kvm *kvm)
 
 static void tdp_mmu_free_sp(struct kvm_mmu_page *sp)
 {
+	kvm_mmu_free_private_spt(sp);
 	free_page((unsigned long)sp->spt);
 	kmem_cache_free(mmu_page_header_cache, sp);
 }
-- 
2.25.1

