Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 139484CDEAF
	for <lists+kvm@lfdr.de>; Fri,  4 Mar 2022 21:26:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230206AbiCDUKT (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 4 Mar 2022 15:10:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53792 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231231AbiCDUH6 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 4 Mar 2022 15:07:58 -0500
Received: from mga03.intel.com (mga03.intel.com [134.134.136.65])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 949D626F65D;
        Fri,  4 Mar 2022 12:02:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1646424146; x=1677960146;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=ZiL9hgZEAUKVOdEWMUWd4NYmkbO0xBXy57oH0fZ044k=;
  b=MBAU9MciPopC14vI4tVZZ+UfX/UKILeA+iklzw5zPXCTNT5jqHVrD7jp
   F94VHeX1cNNwnaSYjzim7a2uyX6R024T3fPTsPexB6MPRvVQ1mP80LLxs
   kL9TvTx5Z+lIZFSV7Rj9RTN4NO2lDyCm+3FcP9cygBn/dNW4nhYe+J6LF
   WoA03dO9ls+77TbV849pOOS/10X4aH0R62ZA31Oe7DfJ+bQ8xTLw2cPLf
   T6oNmdVlTHFvTAF6by3rmojDxs4AoqlES8TIbwutQ6wHYnEOKHpB2C3H9
   qY2wmmNKAwwjZzEgRNA4KtAsb4VC4MlaVF7rRgSgG0SoKh/tZvJWTrvg1
   Q==;
X-IronPort-AV: E=McAfee;i="6200,9189,10276"; a="253983508"
X-IronPort-AV: E=Sophos;i="5.90,156,1643702400"; 
   d="scan'208";a="253983508"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Mar 2022 11:50:24 -0800
X-IronPort-AV: E=Sophos;i="5.90,156,1643702400"; 
   d="scan'208";a="552344359"
Received: from ls.sc.intel.com (HELO localhost) ([143.183.96.54])
  by orsmga008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Mar 2022 11:50:24 -0800
From:   isaku.yamahata@intel.com
To:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     isaku.yamahata@intel.com, isaku.yamahata@gmail.com,
        Paolo Bonzini <pbonzini@redhat.com>,
        Jim Mattson <jmattson@google.com>, erdemaktas@google.com,
        Connor Kuehl <ckuehl@redhat.com>,
        Sean Christopherson <seanjc@google.com>
Subject: [RFC PATCH v5 047/104] KVM: x86/mmu: add a private pointer to struct kvm_mmu_page
Date:   Fri,  4 Mar 2022 11:49:03 -0800
Message-Id: <499d1fd01b0d1d9a8b46a55bb863afd0c76f1111.1646422845.git.isaku.yamahata@intel.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <cover.1646422845.git.isaku.yamahata@intel.com>
References: <cover.1646422845.git.isaku.yamahata@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Isaku Yamahata <isaku.yamahata@intel.com>

Add a private pointer to kvm_mmu_page for private EPT.

To resolve KVM page fault on private GPA, it will allocate additional page
for Secure EPT in addition to private EPT.  Add memory allocator for it and
topup its memory allocator before resolving KVM page fault similar to
shared EPT page.  Allocation of those memory will be done for TDP MMU by
alloc_tdp_mmu_page().  Freeing those memory will be done for TDP MMU on
behalf of kvm_tdp_mmu_zap_all() called by kvm_mmu_zap_all().  Private EPT
page needs to carry one more page used for Secure EPT in addition to the
private EPT page.  Add private pointer to struct kvm_mmu_page for that
purpose and Add helper functions to allocate/free a page for Secure EPT.
Also add helper functions to check if a given kvm_mmu_page is private.

Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
---
 arch/x86/include/asm/kvm_host.h |  1 +
 arch/x86/kvm/mmu/mmu.c          |  9 ++++
 arch/x86/kvm/mmu/mmu_internal.h | 84 +++++++++++++++++++++++++++++++++
 arch/x86/kvm/mmu/tdp_mmu.c      |  3 ++
 4 files changed, 97 insertions(+)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index fcab2337819c..0c8cc7d73371 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -689,6 +689,7 @@ struct kvm_vcpu_arch {
 	struct kvm_mmu_memory_cache mmu_shadow_page_cache;
 	struct kvm_mmu_memory_cache mmu_gfn_array_cache;
 	struct kvm_mmu_memory_cache mmu_page_header_cache;
+	struct kvm_mmu_memory_cache mmu_private_sp_cache;
 
 	/*
 	 * QEMU userspace and the guest each have their own FPU state.
diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index 6e9847b1124b..8def8b97978f 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -758,6 +758,13 @@ static int mmu_topup_shadow_page_cache(struct kvm_vcpu *vcpu)
 	struct kvm_mmu_memory_cache *mc = &vcpu->arch.mmu_shadow_page_cache;
 	int start, end, i, r;
 
+	if (kvm_gfn_stolen_mask(vcpu->kvm)) {
+		r = kvm_mmu_topup_memory_cache(&vcpu->arch.mmu_private_sp_cache,
+					       PT64_ROOT_MAX_LEVEL);
+		if (r)
+			return r;
+	}
+
 	if (shadow_init_value)
 		start = kvm_mmu_memory_cache_nr_free_objects(mc);
 
@@ -799,6 +806,7 @@ static void mmu_free_memory_caches(struct kvm_vcpu *vcpu)
 {
 	kvm_mmu_free_memory_cache(&vcpu->arch.mmu_pte_list_desc_cache);
 	kvm_mmu_free_memory_cache(&vcpu->arch.mmu_shadow_page_cache);
+	kvm_mmu_free_memory_cache(&vcpu->arch.mmu_private_sp_cache);
 	kvm_mmu_free_memory_cache(&vcpu->arch.mmu_gfn_array_cache);
 	kvm_mmu_free_memory_cache(&vcpu->arch.mmu_page_header_cache);
 }
@@ -1791,6 +1799,7 @@ static struct kvm_mmu_page *kvm_mmu_alloc_page(struct kvm_vcpu *vcpu, int direct
 	if (!direct)
 		sp->gfns = kvm_mmu_memory_cache_alloc(&vcpu->arch.mmu_gfn_array_cache);
 	set_page_private(virt_to_page(sp->spt), (unsigned long)sp);
+	kvm_mmu_init_private_sp(sp);
 
 	/*
 	 * active_mmu_pages must be a FIFO list, as kvm_zap_obsolete_pages()
diff --git a/arch/x86/kvm/mmu/mmu_internal.h b/arch/x86/kvm/mmu/mmu_internal.h
index da6166b5c377..80f7a74a71dc 100644
--- a/arch/x86/kvm/mmu/mmu_internal.h
+++ b/arch/x86/kvm/mmu/mmu_internal.h
@@ -53,6 +53,10 @@ struct kvm_mmu_page {
 	u64 *spt;
 	/* hold the gfn of each spte inside spt */
 	gfn_t *gfns;
+#ifdef CONFIG_KVM_MMU_PRIVATE
+	/* associated private shadow page, e.g. SEPT page */
+	void *private_sp;
+#endif
 	/* Currently serving as active root */
 	union {
 		int root_count;
@@ -104,6 +108,86 @@ static inline int kvm_mmu_page_as_id(struct kvm_mmu_page *sp)
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
+static inline bool is_private_spte(u64 *sptep)
+{
+	return is_private_sp(sptep_to_sp(sptep));
+}
+
+static inline void *kvm_mmu_private_sp(struct kvm_mmu_page *sp)
+{
+	return sp->private_sp;
+}
+
+static inline void kvm_mmu_init_private_sp(struct kvm_mmu_page *sp)
+{
+	sp->private_sp = NULL;
+}
+
+/* Valid sp->role.level is required. */
+static inline void kvm_mmu_alloc_private_sp(struct kvm_vcpu *vcpu,
+					struct kvm_mmu_page *sp)
+{
+	if (vcpu->arch.mmu->shadow_root_level == sp->role.level)
+		sp->private_sp = KVM_MMU_PRIVATE_SP_ROOT;
+	else
+		sp->private_sp =
+			kvm_mmu_memory_cache_alloc(
+				&vcpu->arch.mmu_private_sp_cache);
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
+static inline bool is_private_spte(u64 *sptep)
+{
+	return false;
+}
+
+static inline void *kvm_mmu_private_sp(struct kvm_mmu_page *sp)
+{
+	return NULL;
+}
+
+static inline void kvm_mmu_init_private_sp(struct kvm_mmu_page *sp)
+{
+}
+
+static inline void kvm_mmu_alloc_private_sp(struct kvm_vcpu *vcpu,
+					struct kvm_mmu_page *sp)
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
index 8db262440d5c..a68f3a22836b 100644
--- a/arch/x86/kvm/mmu/tdp_mmu.c
+++ b/arch/x86/kvm/mmu/tdp_mmu.c
@@ -59,6 +59,8 @@ static bool zap_gfn_range(struct kvm *kvm, struct kvm_mmu_page *root,
 
 static void tdp_mmu_free_sp(struct kvm_mmu_page *sp)
 {
+	if (is_private_sp(sp))
+		kvm_mmu_free_private_sp(sp);
 	free_page((unsigned long)sp->spt);
 	kmem_cache_free(mmu_page_header_cache, sp);
 }
@@ -184,6 +186,7 @@ static struct kvm_mmu_page *alloc_tdp_mmu_page(struct kvm_vcpu *vcpu, gfn_t gfn,
 	sp->role.word = page_role_for_level(vcpu, level).word;
 	sp->gfn = gfn;
 	sp->tdp_mmu_page = true;
+	kvm_mmu_init_private_sp(sp);
 
 	trace_kvm_mmu_get_page(sp, true);
 
-- 
2.25.1

