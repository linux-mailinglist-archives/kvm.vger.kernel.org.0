Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B20EE762634
	for <lists+kvm@lfdr.de>; Wed, 26 Jul 2023 00:20:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232397AbjGYWUR (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 25 Jul 2023 18:20:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33762 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232353AbjGYWTV (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 25 Jul 2023 18:19:21 -0400
Received: from mga02.intel.com (mga02.intel.com [134.134.136.20])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D27DA423C;
        Tue, 25 Jul 2023 15:16:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1690323391; x=1721859391;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=PI66i/YrGN1PUdZt3jE6X7iD6PIxSsfOjRKHLyYrHqw=;
  b=CkrbOmG+KlDoRfp3mAb4aQuCkZbWXZE5kT8KZqbTJthLLBe3ojjSKAgK
   wX5wMIjPS/9sgRQ6J4JvsUWxTdmt7HSe5VW1oX6ipAX1JAXwF8QQMX7sO
   IWLz9kbf3OIsEnKOdz15JYt1ohlL9ZRyQX1RVuQ26nJDCo0JWr09/esqa
   sYyHjHp4cP015uvng5+88Fh6C5vqY0DgBg1YIv6Vj5Wd/kK9QG4wkAVpS
   44wBvRsuASHj0n1lujic86UR/XzDkPr8qsx97DIshZbUnuGVzvlZXb5Aq
   2lcmseorduWK1eyFZQfNHbbJwKOLfxL+6keIKHdKodN8anCSM/dwfzHz/
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10782"; a="357863254"
X-IronPort-AV: E=Sophos;i="6.01,231,1684825200"; 
   d="scan'208";a="357863254"
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Jul 2023 15:15:36 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10782"; a="1056938919"
X-IronPort-AV: E=Sophos;i="6.01,231,1684825200"; 
   d="scan'208";a="1056938919"
Received: from ls.sc.intel.com (HELO localhost) ([172.25.112.31])
  by fmsmga005-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Jul 2023 15:15:36 -0700
From:   isaku.yamahata@intel.com
To:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     isaku.yamahata@intel.com, isaku.yamahata@gmail.com,
        Paolo Bonzini <pbonzini@redhat.com>, erdemaktas@google.com,
        Sean Christopherson <seanjc@google.com>,
        Sagi Shahar <sagis@google.com>,
        David Matlack <dmatlack@google.com>,
        Kai Huang <kai.huang@intel.com>,
        Zhi Wang <zhi.wang.linux@gmail.com>, chen.bo@intel.com,
        hang.yuan@intel.com, tina.zhang@intel.com
Subject: [PATCH v15 041/115] KVM: x86/tdp_mmu: Init role member of struct kvm_mmu_page at allocation
Date:   Tue, 25 Jul 2023 15:13:52 -0700
Message-Id: <6006f01ea54c46d0688cd307b648d7d66b26b5e6.1690322424.git.isaku.yamahata@intel.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <cover.1690322424.git.isaku.yamahata@intel.com>
References: <cover.1690322424.git.isaku.yamahata@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
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
 arch/x86/kvm/mmu/tdp_mmu.c  | 44 ++++++++++++++++---------------------
 2 files changed, 31 insertions(+), 25 deletions(-)

diff --git a/arch/x86/kvm/mmu/tdp_iter.h b/arch/x86/kvm/mmu/tdp_iter.h
index fae559559a80..e1e40e3f5eb7 100644
--- a/arch/x86/kvm/mmu/tdp_iter.h
+++ b/arch/x86/kvm/mmu/tdp_iter.h
@@ -135,4 +135,16 @@ void tdp_iter_start(struct tdp_iter *iter, struct kvm_mmu_page *root,
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
index 4fe31a1efa9a..87c378d0677f 100644
--- a/arch/x86/kvm/mmu/tdp_mmu.c
+++ b/arch/x86/kvm/mmu/tdp_mmu.c
@@ -227,24 +227,30 @@ static struct kvm_mmu_page *tdp_mmu_next_root(struct kvm *kvm,
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
 	INIT_LIST_HEAD(&sp->possible_nx_huge_page_link);
 
 	set_page_private(virt_to_page(sp->spt), (unsigned long)sp);
 
-	sp->role = role;
+	/*
+	 * role must be set before calling this function.  At least role.level
+	 * is not 0 (PG_LEVEL_NONE).
+	 */
+	WARN_ON_ONCE(!sp->role.word);
 	sp->gfn = gfn;
 	sp->ptep = sptep;
 	sp->tdp_mmu_page = true;
@@ -252,20 +258,6 @@ static void tdp_mmu_init_sp(struct kvm_mmu_page *sp, tdp_ptep_t sptep,
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
@@ -284,8 +276,8 @@ hpa_t kvm_tdp_mmu_get_vcpu_root_hpa(struct kvm_vcpu *vcpu)
 			goto out;
 	}
 
-	root = tdp_mmu_alloc_sp(vcpu);
-	tdp_mmu_init_sp(root, NULL, 0, role);
+	root = tdp_mmu_alloc_sp(vcpu, role);
+	tdp_mmu_init_sp(root, NULL, 0);
 
 	/*
 	 * TDP MMU roots are kept until they are explicitly invalidated, either
@@ -1100,8 +1092,8 @@ int kvm_tdp_mmu_map(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault)
 		 * The SPTE is either non-present or points to a huge page that
 		 * needs to be split.
 		 */
-		sp = tdp_mmu_alloc_sp(vcpu);
-		tdp_mmu_init_child_sp(sp, &iter);
+		sp = tdp_mmu_alloc_sp(vcpu, tdp_iter_child_role(&iter));
+		tdp_mmu_init_sp(sp, iter.sptep, iter.gfn);
 
 		sp->nx_huge_page_disallowed = fault->huge_page_disallowed;
 
@@ -1339,7 +1331,7 @@ bool kvm_tdp_mmu_wrprot_slot(struct kvm *kvm,
 	return spte_set;
 }
 
-static struct kvm_mmu_page *__tdp_mmu_alloc_sp_for_split(gfp_t gfp)
+static struct kvm_mmu_page *__tdp_mmu_alloc_sp_for_split(gfp_t gfp, union kvm_mmu_page_role role)
 {
 	struct kvm_mmu_page *sp;
 
@@ -1349,6 +1341,7 @@ static struct kvm_mmu_page *__tdp_mmu_alloc_sp_for_split(gfp_t gfp)
 	if (!sp)
 		return NULL;
 
+	sp->role = role;
 	sp->spt = (void *)__get_free_page(gfp);
 	if (!sp->spt) {
 		kmem_cache_free(mmu_page_header_cache, sp);
@@ -1362,6 +1355,7 @@ static struct kvm_mmu_page *tdp_mmu_alloc_sp_for_split(struct kvm *kvm,
 						       struct tdp_iter *iter,
 						       bool shared)
 {
+	union kvm_mmu_page_role role = tdp_iter_child_role(iter);
 	struct kvm_mmu_page *sp;
 
 	/*
@@ -1373,7 +1367,7 @@ static struct kvm_mmu_page *tdp_mmu_alloc_sp_for_split(struct kvm *kvm,
 	 * If this allocation fails we drop the lock and retry with reclaim
 	 * allowed.
 	 */
-	sp = __tdp_mmu_alloc_sp_for_split(GFP_NOWAIT | __GFP_ACCOUNT);
+	sp = __tdp_mmu_alloc_sp_for_split(GFP_NOWAIT | __GFP_ACCOUNT, role);
 	if (sp)
 		return sp;
 
@@ -1385,7 +1379,7 @@ static struct kvm_mmu_page *tdp_mmu_alloc_sp_for_split(struct kvm *kvm,
 		write_unlock(&kvm->mmu_lock);
 
 	iter->yielded = true;
-	sp = __tdp_mmu_alloc_sp_for_split(GFP_KERNEL_ACCOUNT);
+	sp = __tdp_mmu_alloc_sp_for_split(GFP_KERNEL_ACCOUNT, role);
 
 	if (shared)
 		read_lock(&kvm->mmu_lock);
@@ -1480,7 +1474,7 @@ static int tdp_mmu_split_huge_pages_root(struct kvm *kvm,
 				continue;
 		}
 
-		tdp_mmu_init_child_sp(sp, &iter);
+		tdp_mmu_init_sp(sp, iter.sptep, iter.gfn);
 
 		if (tdp_mmu_split_huge_page(kvm, &iter, sp, shared))
 			goto retry;
-- 
2.25.1

