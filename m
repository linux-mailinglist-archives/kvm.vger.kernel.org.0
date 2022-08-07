Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 663D658BD75
	for <lists+kvm@lfdr.de>; Mon,  8 Aug 2022 00:18:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239159AbiHGWHo (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 7 Aug 2022 18:07:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52006 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237377AbiHGWFj (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 7 Aug 2022 18:05:39 -0400
Received: from mga04.intel.com (mga04.intel.com [192.55.52.120])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 39A1EB846;
        Sun,  7 Aug 2022 15:03:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1659909786; x=1691445786;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=L/cHuxa5MM5JMoCmZmAfMnKtIRRRZI2oWhQh51zuBso=;
  b=OlOkdHqKoOLsPeyqYQIBpNlspvUkXnU074kWOoQ7qLpJk2+5n3A7NH6Y
   7z8aYQoMFWPBd26MEvYeXb8fVkY9OYFHB2oXarQirLOa0/sb+OLgdZHpx
   1NWcrVaPKRWp6MdBGo0B8o4XHu1pbd/D5vOL44f2Ab9IytH0zcOUV77XN
   HG2wVKtEoo1XE2pS4PK57HVNR64wNLvZtdXbLCpqECoh7CrprLpQSLadF
   uhHeG15Z/RFbf+lrsOY+2LA0riD5mhldRzfeOBf8fukgrnltP2E0MUtfw
   HLqBylWYwFtjL6xgLPlhdH4Gd4n8QKHXLwoGvI3BWhEENDVwKFkqWGJEx
   A==;
X-IronPort-AV: E=McAfee;i="6400,9594,10432"; a="289224131"
X-IronPort-AV: E=Sophos;i="5.93,220,1654585200"; 
   d="scan'208";a="289224131"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Aug 2022 15:02:35 -0700
X-IronPort-AV: E=Sophos;i="5.93,220,1654585200"; 
   d="scan'208";a="663682576"
Received: from ls.sc.intel.com (HELO localhost) ([143.183.96.54])
  by fmsmga008-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Aug 2022 15:02:35 -0700
From:   isaku.yamahata@intel.com
To:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     isaku.yamahata@intel.com, isaku.yamahata@gmail.com,
        Paolo Bonzini <pbonzini@redhat.com>, erdemaktas@google.com,
        Sean Christopherson <seanjc@google.com>,
        Sagi Shahar <sagis@google.com>
Subject: [PATCH v8 042/103] KVM: x86/mmu: Add a private pointer to struct kvm_mmu_page
Date:   Sun,  7 Aug 2022 15:01:27 -0700
Message-Id: <a02d8e9a3c46b9627a5edccd76416abeccf45a20.1659854790.git.isaku.yamahata@intel.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <cover.1659854790.git.isaku.yamahata@intel.com>
References: <cover.1659854790.git.isaku.yamahata@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-5.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
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
 arch/x86/include/asm/kvm_host.h |  1 +
 arch/x86/kvm/mmu/mmu.c          |  9 ++++
 arch/x86/kvm/mmu/mmu_internal.h | 73 +++++++++++++++++++++++++++++++++
 arch/x86/kvm/mmu/tdp_mmu.c      |  2 +
 4 files changed, 85 insertions(+)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 25835b8c4c12..e4ecf6b8ea0b 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -743,6 +743,7 @@ struct kvm_vcpu_arch {
 	struct kvm_mmu_memory_cache mmu_shadow_page_cache;
 	struct kvm_mmu_memory_cache mmu_shadowed_info_cache;
 	struct kvm_mmu_memory_cache mmu_page_header_cache;
+	struct kvm_mmu_memory_cache mmu_private_sp_cache;
 
 	/*
 	 * QEMU userspace and the guest each have their own FPU state.
diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index 0e5a6dcc4966..aa0819905874 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -669,6 +669,13 @@ static int mmu_topup_shadow_page_cache(struct kvm_vcpu *vcpu)
 	struct kvm_mmu_memory_cache *mc = &vcpu->arch.mmu_shadow_page_cache;
 	int start, end, i, r;
 
+	if (kvm_gfn_shared_mask(vcpu->kvm)) {
+		r = kvm_mmu_topup_memory_cache(&vcpu->arch.mmu_private_sp_cache,
+					       PT64_ROOT_MAX_LEVEL);
+		if (r)
+			return r;
+	}
+
 	start = kvm_mmu_memory_cache_nr_free_objects(mc);
 	r = kvm_mmu_topup_memory_cache(mc, PT64_ROOT_MAX_LEVEL);
 
@@ -718,6 +725,7 @@ static void mmu_free_memory_caches(struct kvm_vcpu *vcpu)
 	kvm_mmu_free_memory_cache(&vcpu->arch.mmu_pte_list_desc_cache);
 	kvm_mmu_free_memory_cache(&vcpu->arch.mmu_shadow_page_cache);
 	kvm_mmu_free_memory_cache(&vcpu->arch.mmu_shadowed_info_cache);
+	kvm_mmu_free_memory_cache(&vcpu->arch.mmu_private_sp_cache);
 	kvm_mmu_free_memory_cache(&vcpu->arch.mmu_page_header_cache);
 }
 
@@ -2162,6 +2170,7 @@ static struct kvm_mmu_page *kvm_mmu_alloc_shadow_page(struct kvm *kvm,
 		sp->shadowed_translation = kvm_mmu_memory_cache_alloc(caches->shadowed_info_cache);
 
 	set_page_private(virt_to_page(sp->spt), (unsigned long)sp);
+	kvm_mmu_init_private_sp(sp, NULL);
 
 	/*
 	 * active_mmu_pages must be a FIFO list, as kvm_zap_obsolete_pages()
diff --git a/arch/x86/kvm/mmu/mmu_internal.h b/arch/x86/kvm/mmu/mmu_internal.h
index c9446e4e16e3..d43c01e7e37b 100644
--- a/arch/x86/kvm/mmu/mmu_internal.h
+++ b/arch/x86/kvm/mmu/mmu_internal.h
@@ -82,6 +82,10 @@ struct kvm_mmu_page {
 	 */
 	u64 *shadowed_translation;
 
+#ifdef CONFIG_KVM_MMU_PRIVATE
+	/* associated private shadow page, e.g. SEPT page. */
+	void *private_sp;
+#endif
 	/* Currently serving as active root */
 	union {
 		int root_count;
@@ -153,6 +157,75 @@ static inline bool is_private_sptep(u64 *sptep)
 	return is_private_sp(sptep_to_sp(sptep));
 }
 
+#ifdef CONFIG_KVM_MMU_PRIVATE
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
+static inline void kvm_mmu_alloc_private_sp(
+	struct kvm_vcpu *vcpu, struct kvm_mmu_memory_cache *private_sp_cache,
+	struct kvm_mmu_page *sp)
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
+		private_sp_cache = &vcpu->arch.mmu_private_sp_cache;
+	WARN_ON(!kvm_mmu_page_role_is_private(sp->role));
+	if (is_root)
+		/*
+		 * Because TDX module assigns root Secure-EPT page and set it to
+		 * Secure-EPTP when TD vcpu is created, secure page table for
+		 * root isn't needed.
+		 */
+		sp->private_sp = NULL;
+	else {
+		sp->private_sp = kvm_mmu_memory_cache_alloc(private_sp_cache);
+		/*
+		 * Because mmu_private_sp_cache is topped up before staring kvm
+		 * page fault resolving, the allocation above shouldn't fail.
+		 */
+		WARN_ON_ONCE(!sp->private_sp);
+	}
+}
+
+static inline void kvm_mmu_free_private_sp(struct kvm_mmu_page *sp)
+{
+	if (sp->private_sp)
+		free_page((unsigned long)sp->private_sp);
+}
+#else
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
+	struct kvm_vcpu *vcpu, struct kvm_mmu_memory_cache *private_sp_cache,
+	struct kvm_mmu_page *sp)
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
index 823c1ef807eb..3f5b019f9774 100644
--- a/arch/x86/kvm/mmu/tdp_mmu.c
+++ b/arch/x86/kvm/mmu/tdp_mmu.c
@@ -71,6 +71,7 @@ void kvm_mmu_uninit_tdp_mmu(struct kvm *kvm)
 
 static void tdp_mmu_free_sp(struct kvm_mmu_page *sp)
 {
+	kvm_mmu_free_private_sp(sp);
 	free_page((unsigned long)sp->spt);
 	kmem_cache_free(mmu_page_header_cache, sp);
 }
@@ -300,6 +301,7 @@ static void tdp_mmu_init_sp(struct kvm_mmu_page *sp, tdp_ptep_t sptep,
 	sp->gfn = gfn;
 	sp->ptep = sptep;
 	sp->tdp_mmu_page = true;
+	kvm_mmu_init_private_sp(sp, NULL);
 
 	trace_kvm_mmu_get_page(sp, true);
 }
-- 
2.25.1

