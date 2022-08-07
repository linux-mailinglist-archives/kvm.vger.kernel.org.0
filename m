Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E19D758BD6A
	for <lists+kvm@lfdr.de>; Mon,  8 Aug 2022 00:07:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241589AbiHGWGq (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 7 Aug 2022 18:06:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48922 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236820AbiHGWEz (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 7 Aug 2022 18:04:55 -0400
Received: from mga04.intel.com (mga04.intel.com [192.55.52.120])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EBCB6B4AC;
        Sun,  7 Aug 2022 15:02:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1659909777; x=1691445777;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=SV08ws+YHrptESEQIDWZJWgO0TWhPO1RQptFYoSOqX0=;
  b=JGt1zMoRAwUfgt52Xy2mZ2Vr8vu5PWKXOR2g+OBLhnjcJZeLMNx02zyh
   IYBRQnE/akQWpaIIKxzBHPW3OYnyajEjnlKogp0fO7hloMh4l+YqPlTlN
   zSlPfk8jIPk7e2vjE21mIv7CvkSFTuLogTrHmKZsFGN83zkFpQxZmp1Cq
   jQ3xfQzzDHy73p8p4VOK2cOFX6usXLv34Q1lONtPd5Y+hJEbNpw1dMvax
   RgWgiKjiIimamJ+xt65bLhfa+s3FlemmkjhsZhlFb3PMn+8CGwdsglEq8
   jD8lmPo/DwyA9F1Uy8IqrCO0e00LNXA/fD8UOliVpVTqJB8G2Evk0YTSt
   Q==;
X-IronPort-AV: E=McAfee;i="6400,9594,10432"; a="289224125"
X-IronPort-AV: E=Sophos;i="5.93,220,1654585200"; 
   d="scan'208";a="289224125"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Aug 2022 15:02:35 -0700
X-IronPort-AV: E=Sophos;i="5.93,220,1654585200"; 
   d="scan'208";a="663682567"
Received: from ls.sc.intel.com (HELO localhost) ([143.183.96.54])
  by fmsmga008-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Aug 2022 15:02:34 -0700
From:   isaku.yamahata@intel.com
To:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     isaku.yamahata@intel.com, isaku.yamahata@gmail.com,
        Paolo Bonzini <pbonzini@redhat.com>, erdemaktas@google.com,
        Sean Christopherson <seanjc@google.com>,
        Sagi Shahar <sagis@google.com>
Subject: [PATCH v8 039/103] KVM: x86/tdp_mmu: Init role member of struct kvm_mmu_page at allocation
Date:   Sun,  7 Aug 2022 15:01:24 -0700
Message-Id: <0a8fa20533048189106f9d0f100acf59602bb502.1659854790.git.isaku.yamahata@intel.com>
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

Refactor tdp_mmu_alloc_sp() and tdp_mmu_init_sp and eliminate
tdp_mmu_init_child_sp().  Currently tdp_mmu_init_sp() (or
tdp_mmu_init_child_sp()) sets kvm_mmu_page.role after tdp_mmu_alloc_sp()
allocating struct kvm_mmu_page and its page table page.  This patch makes
tdp_mmu_alloc_sp() initialize kvm_mmu_page.role instead of
tdp_mmu_init_sp().

To handle private page tables, argument of is_private needs to be passed
down.  Given that already page level is passed down, it would be cumbersome
to add one more parameter about sp. Instead replace the level argument with
union kvm_mmu_page_role.  Thus the number of argument won't be increased
and more info about sp can be passed down.

For private sp, secure page table will be also allocated in addition to
struct kvm_mmu_page and page table (spt member).  The allocation functions
(tdp_mmu_alloc_sp() and __tdp_mmu_alloc_sp_for_split()) need to know if the
allocation is for the conventional page table or private page table.  Pass
union kvm_mmu_role to those functions and initialize role member of struct
kvm_mmu_page.

Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
---
 arch/x86/kvm/mmu/tdp_iter.h | 12 ++++++++++
 arch/x86/kvm/mmu/tdp_mmu.c  | 45 +++++++++++++++++--------------------
 2 files changed, 32 insertions(+), 25 deletions(-)

diff --git a/arch/x86/kvm/mmu/tdp_iter.h b/arch/x86/kvm/mmu/tdp_iter.h
index f0af385c56e0..9e56a5b1024c 100644
--- a/arch/x86/kvm/mmu/tdp_iter.h
+++ b/arch/x86/kvm/mmu/tdp_iter.h
@@ -115,4 +115,16 @@ void tdp_iter_start(struct tdp_iter *iter, struct kvm_mmu_page *root,
 void tdp_iter_next(struct tdp_iter *iter);
 void tdp_iter_restart(struct tdp_iter *iter);
 
+static inline union kvm_mmu_page_role tdp_iter_child_role(struct tdp_iter *iter)
+{
+	union kvm_mmu_page_role child_role;
+	struct kvm_mmu_page *parent_sp;
+
+	parent_sp = sptep_to_sp(rcu_dereference(iter->sptep));
+
+	child_role = parent_sp->role;
+	child_role.level--;
+	return child_role;
+}
+
 #endif /* __KVM_X86_MMU_TDP_ITER_H */
diff --git a/arch/x86/kvm/mmu/tdp_mmu.c b/arch/x86/kvm/mmu/tdp_mmu.c
index 90b468a3a1a2..ce69535754ff 100644
--- a/arch/x86/kvm/mmu/tdp_mmu.c
+++ b/arch/x86/kvm/mmu/tdp_mmu.c
@@ -271,22 +271,28 @@ static struct kvm_mmu_page *tdp_mmu_next_root(struct kvm *kvm,
 		    kvm_mmu_page_as_id(_root) != _as_id) {		\
 		} else
 
-static struct kvm_mmu_page *tdp_mmu_alloc_sp(struct kvm_vcpu *vcpu)
+static struct kvm_mmu_page *tdp_mmu_alloc_sp(struct kvm_vcpu *vcpu,
+					     union kvm_mmu_page_role role)
 {
 	struct kvm_mmu_page *sp;
 
 	sp = kvm_mmu_memory_cache_alloc(&vcpu->arch.mmu_page_header_cache);
 	sp->spt = kvm_mmu_memory_cache_alloc(&vcpu->arch.mmu_shadow_page_cache);
+	sp->role = role;
 
 	return sp;
 }
 
 static void tdp_mmu_init_sp(struct kvm_mmu_page *sp, tdp_ptep_t sptep,
-			    gfn_t gfn, union kvm_mmu_page_role role)
+			    gfn_t gfn)
 {
 	set_page_private(virt_to_page(sp->spt), (unsigned long)sp);
 
-	sp->role = role;
+	/*
+	 * role must be set before calling this function.  At least role.level
+	 * is not 0 (PG_LEVEL_NONE).
+	 */
+	WARN_ON(!sp->role.word);
 	sp->gfn = gfn;
 	sp->ptep = sptep;
 	sp->tdp_mmu_page = true;
@@ -294,20 +300,6 @@ static void tdp_mmu_init_sp(struct kvm_mmu_page *sp, tdp_ptep_t sptep,
 	trace_kvm_mmu_get_page(sp, true);
 }
 
-static void tdp_mmu_init_child_sp(struct kvm_mmu_page *child_sp,
-				  struct tdp_iter *iter)
-{
-	struct kvm_mmu_page *parent_sp;
-	union kvm_mmu_page_role role;
-
-	parent_sp = sptep_to_sp(rcu_dereference(iter->sptep));
-
-	role = parent_sp->role;
-	role.level--;
-
-	tdp_mmu_init_sp(child_sp, iter->sptep, iter->gfn, role);
-}
-
 hpa_t kvm_tdp_mmu_get_vcpu_root_hpa(struct kvm_vcpu *vcpu)
 {
 	union kvm_mmu_page_role role = vcpu->arch.mmu->root_role;
@@ -326,8 +318,8 @@ hpa_t kvm_tdp_mmu_get_vcpu_root_hpa(struct kvm_vcpu *vcpu)
 			goto out;
 	}
 
-	root = tdp_mmu_alloc_sp(vcpu);
-	tdp_mmu_init_sp(root, NULL, 0, role);
+	root = tdp_mmu_alloc_sp(vcpu, role);
+	tdp_mmu_init_sp(root, NULL, 0);
 
 	refcount_set(&root->tdp_mmu_root_count, 1);
 
@@ -1154,8 +1146,8 @@ static int tdp_mmu_populate_nonleaf(
 	WARN_ON(is_shadow_present_pte(iter->old_spte));
 	WARN_ON(is_removed_spte(iter->old_spte));
 
-	sp = tdp_mmu_alloc_sp(vcpu);
-	tdp_mmu_init_child_sp(sp, iter);
+	sp = tdp_mmu_alloc_sp(vcpu, tdp_iter_child_role(iter));
+	tdp_mmu_init_sp(sp, iter->sptep, iter->gfn);
 
 	ret = tdp_mmu_link_sp(vcpu->kvm, iter, sp, account_nx, true);
 	if (ret)
@@ -1423,7 +1415,8 @@ bool kvm_tdp_mmu_wrprot_slot(struct kvm *kvm,
 	return spte_set;
 }
 
-static struct kvm_mmu_page *__tdp_mmu_alloc_sp_for_split(gfp_t gfp)
+static struct kvm_mmu_page *__tdp_mmu_alloc_sp_for_split(
+	gfp_t gfp, union kvm_mmu_page_role role)
 {
 	struct kvm_mmu_page *sp;
 
@@ -1433,6 +1426,7 @@ static struct kvm_mmu_page *__tdp_mmu_alloc_sp_for_split(gfp_t gfp)
 	if (!sp)
 		return NULL;
 
+	sp->role = role;
 	sp->spt = (void *)__get_free_page(gfp);
 	if (!sp->spt) {
 		kmem_cache_free(mmu_page_header_cache, sp);
@@ -1446,6 +1440,7 @@ static struct kvm_mmu_page *tdp_mmu_alloc_sp_for_split(struct kvm *kvm,
 						       struct tdp_iter *iter,
 						       bool shared)
 {
+	union kvm_mmu_page_role role = tdp_iter_child_role(iter);
 	struct kvm_mmu_page *sp;
 
 	/*
@@ -1457,7 +1452,7 @@ static struct kvm_mmu_page *tdp_mmu_alloc_sp_for_split(struct kvm *kvm,
 	 * If this allocation fails we drop the lock and retry with reclaim
 	 * allowed.
 	 */
-	sp = __tdp_mmu_alloc_sp_for_split(GFP_NOWAIT | __GFP_ACCOUNT);
+	sp = __tdp_mmu_alloc_sp_for_split(GFP_NOWAIT | __GFP_ACCOUNT, role);
 	if (sp)
 		return sp;
 
@@ -1469,7 +1464,7 @@ static struct kvm_mmu_page *tdp_mmu_alloc_sp_for_split(struct kvm *kvm,
 		write_unlock(&kvm->mmu_lock);
 
 	iter->yielded = true;
-	sp = __tdp_mmu_alloc_sp_for_split(GFP_KERNEL_ACCOUNT);
+	sp = __tdp_mmu_alloc_sp_for_split(GFP_KERNEL_ACCOUNT, role);
 
 	if (shared)
 		read_lock(&kvm->mmu_lock);
@@ -1488,7 +1483,7 @@ static int tdp_mmu_split_huge_page(struct kvm *kvm, struct tdp_iter *iter,
 	const int level = iter->level;
 	int ret, i;
 
-	tdp_mmu_init_child_sp(sp, iter);
+	tdp_mmu_init_sp(sp, iter->sptep, iter->gfn);
 
 	/*
 	 * No need for atomics when writing to sp->spt since the page table has
-- 
2.25.1

