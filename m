Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B80666A3CA5
	for <lists+kvm@lfdr.de>; Mon, 27 Feb 2023 09:26:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231289AbjB0I0K (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 27 Feb 2023 03:26:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59242 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231176AbjB0IZl (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 27 Feb 2023 03:25:41 -0500
Received: from mga18.intel.com (mga18.intel.com [134.134.136.126])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3F2A61DBB3;
        Mon, 27 Feb 2023 00:24:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1677486261; x=1709022261;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=hbZQg/rKtctKAJPVs2bis0b54Gw3EaInb2Ubug/EbuU=;
  b=mBWK4AvZW+ZZvGVe2JxdaRiuMsAiJAtCF4C/3lZJQhEMPkrq1GcCCNe4
   G2t/yJaAmyIoVrprHjnP0Sp2MFiLZ5znbIMrTk0LuZL6yQ5S+GxsefB12
   lMXqijnOBDlcgZbQySimtlycinTDMqQk88hTN0anrbKl+MNmavGmWFT+7
   zhDIOA9hCa3XSmJ76MQWQqYBmDNCm0wjN1wkLjJdmqWUzfzVnQGu6vKxc
   Huru2wDIyRTKUB0bP7VEU5Qxbh3lJN9hePaT7JVyNrwFfMb/23Y+8LrRv
   d5jSNqwhKlK1Sny9fTscvbgly1LPrxPalSFBg9wJciy9TqUacyOSOj6KQ
   g==;
X-IronPort-AV: E=McAfee;i="6500,9779,10633"; a="317608817"
X-IronPort-AV: E=Sophos;i="5.97,331,1669104000"; 
   d="scan'208";a="317608817"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Feb 2023 00:24:07 -0800
X-IronPort-AV: E=McAfee;i="6500,9779,10633"; a="783242172"
X-IronPort-AV: E=Sophos;i="5.97,331,1669104000"; 
   d="scan'208";a="783242172"
Received: from ls.sc.intel.com (HELO localhost) ([143.183.96.54])
  by fmsmga002-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Feb 2023 00:24:07 -0800
From:   isaku.yamahata@intel.com
To:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     isaku.yamahata@intel.com, isaku.yamahata@gmail.com,
        Paolo Bonzini <pbonzini@redhat.com>, erdemaktas@google.com,
        Sean Christopherson <seanjc@google.com>,
        Sagi Shahar <sagis@google.com>,
        David Matlack <dmatlack@google.com>,
        Kai Huang <kai.huang@intel.com>,
        Zhi Wang <zhi.wang.linux@gmail.com>
Subject: [PATCH v12 036/106] KVM: x86/mmu: Add a private pointer to struct kvm_mmu_page
Date:   Mon, 27 Feb 2023 00:22:35 -0800
Message-Id: <1ac13fb0ac8647642aeff20d84001564f8fbfbd5.1677484918.git.isaku.yamahata@intel.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <cover.1677484918.git.isaku.yamahata@intel.com>
References: <cover.1677484918.git.isaku.yamahata@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
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
index afe9285930b3..0f25cd0a0f02 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -810,6 +810,11 @@ struct kvm_vcpu_arch {
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
index a6b0b53634e8..1d0560111554 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -666,6 +666,12 @@ static int mmu_topup_memory_caches(struct kvm_vcpu *vcpu, bool maybe_indirect)
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
@@ -685,6 +691,7 @@ static void mmu_free_memory_caches(struct kvm_vcpu *vcpu)
 	kvm_mmu_free_memory_cache(&vcpu->arch.mmu_pte_list_desc_cache);
 	kvm_mmu_free_memory_cache(&vcpu->arch.mmu_shadow_page_cache);
 	kvm_mmu_free_memory_cache(&vcpu->arch.mmu_shadowed_info_cache);
+	kvm_mmu_free_memory_cache(&vcpu->arch.mmu_private_spt_cache);
 	kvm_mmu_free_memory_cache(&vcpu->arch.mmu_page_header_cache);
 }
 
diff --git a/arch/x86/kvm/mmu/mmu_internal.h b/arch/x86/kvm/mmu/mmu_internal.h
index 0111eed08c04..e1168a01af64 100644
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
index d4e7880a2eea..cc93085e27a0 100644
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

