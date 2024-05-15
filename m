Return-Path: <kvm+bounces-17407-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 790088C5E95
	for <lists+kvm@lfdr.de>; Wed, 15 May 2024 03:03:35 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 9C4EA1C210CA
	for <lists+kvm@lfdr.de>; Wed, 15 May 2024 01:03:34 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B37433A1B9;
	Wed, 15 May 2024 01:00:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="ilYMBWQp"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 20C7D364AE;
	Wed, 15 May 2024 01:00:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.19
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715734813; cv=none; b=WcZ2uI6wphBIhEUjjwFQQzY+812yYlP8aMLjZKcMgj/b4Y0ecjTaC2+2UE5sLqDEHB3z/MG5r0nIylx6ayhGMv4LsnsgfnJS8JmdCG3lf28bWFVz7Vod8EeqfOcmWFOODF3Ejmc+/whwLDS+ojh2dxOnXUIgjPFDBudnkAsfegg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715734813; c=relaxed/simple;
	bh=hwT7Hnp4s9Rtxpw8GmgoIARXgPDTRvl14/AMhCiqMB0=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=LhHuIF/uawS0Q6EoO13WxzQEICcdE/KATpa7I+8ZE6qQWqB0plDMqi5ujg5GBbhBMNsegtSxMsZFwvzL7yJUvb+DwImhFZoZOtQh0Bm37TxnV5Wsi5cGjxT+GbIWHy3V22P+bgoXmdWGniqV8q+78u0Kky5UX+AT17FMA/QhAxI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=ilYMBWQp; arc=none smtp.client-ip=192.198.163.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1715734812; x=1747270812;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=hwT7Hnp4s9Rtxpw8GmgoIARXgPDTRvl14/AMhCiqMB0=;
  b=ilYMBWQpZp+ecPXQJNPTj3T1t9ErvQBDGfxncmpVPIWogmyfAavvmMqc
   ZwvTqnO2fK1lVy1jbIhul2qXG7KOwdFefCVEKzct+IHT2VBctAM2pLsm3
   kmMuTV4CDxs51SlgHwtgSHFGDxsyAOXvoKru4DJX01x/lBUsIkfobz5RK
   pkucL9SPR5QOUj30hbC6ha+W9cavBSuFB7LCHr31ppmgxdQEb508G2sd7
   u8zdsSZeemi28r3GHIwaClQVejCwUQmHaEzYG28eBxyD/TlfgsTGekd3g
   RHsBH0BD1jhqZS2rkX81PAa+h2p9EkcXqZRebX47v3cMFD8g/haBPxmMx
   g==;
X-CSE-ConnectionGUID: 9xW0yRnRSxu/XRoz1glDsw==
X-CSE-MsgGUID: XCMbw4nFS6yAZpDMY9CMkw==
X-IronPort-AV: E=McAfee;i="6600,9927,11073"; a="11613981"
X-IronPort-AV: E=Sophos;i="6.08,160,1712646000"; 
   d="scan'208";a="11613981"
Received: from fmviesa006.fm.intel.com ([10.60.135.146])
  by fmvoesa113.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 May 2024 18:00:07 -0700
X-CSE-ConnectionGUID: TUPxIWNtQLi04SmwZHLs4g==
X-CSE-MsgGUID: aLwVOWGzReuTVOfZnQUmNQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.08,160,1712646000"; 
   d="scan'208";a="30942814"
Received: from oyildiz-mobl1.amr.corp.intel.com (HELO rpedgeco-desk4.intel.com) ([10.209.51.34])
  by fmviesa006-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 May 2024 18:00:06 -0700
From: Rick Edgecombe <rick.p.edgecombe@intel.com>
To: pbonzini@redhat.com,
	seanjc@google.com,
	kvm@vger.kernel.org
Cc: linux-kernel@vger.kernel.org,
	isaku.yamahata@gmail.com,
	erdemaktas@google.com,
	sagis@google.com,
	yan.y.zhao@intel.com,
	dmatlack@google.com,
	rick.p.edgecombe@intel.com
Subject: [PATCH 12/16] KVM: x86/tdp_mmu: Introduce KVM MMU root types to specify page table type
Date: Tue, 14 May 2024 17:59:48 -0700
Message-Id: <20240515005952.3410568-13-rick.p.edgecombe@intel.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20240515005952.3410568-1-rick.p.edgecombe@intel.com>
References: <20240515005952.3410568-1-rick.p.edgecombe@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Isaku Yamahata <isaku.yamahata@intel.com>

Define an enum kvm_tdp_mmu_root_types to specify the KVM MMU root type [1]
so that the iterator on the root page table can consistently filter the
root page table type instead of only_valid.

TDX KVM will operate on KVM page tables with specified types.  Shared page
table, private page table, or both.  Introduce an enum instead of bool
only_valid so that we can easily enhance page table types applicable to
shared, private, or both in addition to valid or not.  Replace
only_valid=false with KVM_ANY_ROOTS and only_valid=true with
KVM_ANY_VALID_ROOTS.  Use KVM_ANY_ROOTS and KVM_ANY_VALID_ROOTS to wrap
KVM_VALID_ROOTS to avoid further code churn when shared and private are
introduced.

Link: https://lore.kernel.org/kvm/ZivazWQw1oCU8VBC@google.com/ [1]
Suggested-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
Signed-off-by: Rick Edgecombe <rick.p.edgecombe@intel.com>
---
TDX MMU Part 1:
 - Newly introduced.
---
 arch/x86/kvm/mmu/tdp_mmu.c | 39 +++++++++++++++++++-------------------
 arch/x86/kvm/mmu/tdp_mmu.h |  7 +++++++
 2 files changed, 27 insertions(+), 19 deletions(-)

diff --git a/arch/x86/kvm/mmu/tdp_mmu.c b/arch/x86/kvm/mmu/tdp_mmu.c
index a0b7c43e843d..7af395073e92 100644
--- a/arch/x86/kvm/mmu/tdp_mmu.c
+++ b/arch/x86/kvm/mmu/tdp_mmu.c
@@ -92,9 +92,10 @@ void kvm_tdp_mmu_put_root(struct kvm *kvm, struct kvm_mmu_page *root)
 	call_rcu(&root->rcu_head, tdp_mmu_free_sp_rcu_callback);
 }
 
-static bool tdp_mmu_root_match(struct kvm_mmu_page *root, bool only_valid)
+static bool tdp_mmu_root_match(struct kvm_mmu_page *root,
+			       enum kvm_tdp_mmu_root_types types)
 {
-	if (only_valid && root->role.invalid)
+	if ((types & KVM_VALID_ROOTS) && root->role.invalid)
 		return false;
 
 	return true;
@@ -102,17 +103,17 @@ static bool tdp_mmu_root_match(struct kvm_mmu_page *root, bool only_valid)
 
 /*
  * Returns the next root after @prev_root (or the first root if @prev_root is
- * NULL).  A reference to the returned root is acquired, and the reference to
- * @prev_root is released (the caller obviously must hold a reference to
- * @prev_root if it's non-NULL).
+ * NULL) that matches with @types.  A reference to the returned root is
+ * acquired, and the reference to @prev_root is released (the caller obviously
+ * must hold a reference to @prev_root if it's non-NULL).
  *
- * If @only_valid is true, invalid roots are skipped.
+ * Roots that doesn't match with @types are skipped.
  *
  * Returns NULL if the end of tdp_mmu_roots was reached.
  */
 static struct kvm_mmu_page *tdp_mmu_next_root(struct kvm *kvm,
 					      struct kvm_mmu_page *prev_root,
-					      bool only_valid)
+					      enum kvm_tdp_mmu_root_types types)
 {
 	struct kvm_mmu_page *next_root;
 
@@ -133,7 +134,7 @@ static struct kvm_mmu_page *tdp_mmu_next_root(struct kvm *kvm,
 						   typeof(*next_root), link);
 
 	while (next_root) {
-		if (tdp_mmu_root_match(next_root, only_valid) &&
+		if (tdp_mmu_root_match(next_root, types) &&
 		    kvm_tdp_mmu_get_root(next_root))
 			break;
 
@@ -158,20 +159,20 @@ static struct kvm_mmu_page *tdp_mmu_next_root(struct kvm *kvm,
  * If shared is set, this function is operating under the MMU lock in read
  * mode.
  */
-#define __for_each_tdp_mmu_root_yield_safe(_kvm, _root, _as_id, _only_valid)	\
-	for (_root = tdp_mmu_next_root(_kvm, NULL, _only_valid);		\
+#define __for_each_tdp_mmu_root_yield_safe(_kvm, _root, _as_id, _types)	\
+	for (_root = tdp_mmu_next_root(_kvm, NULL, _types);		\
 	     ({ lockdep_assert_held(&(_kvm)->mmu_lock); }), _root;		\
-	     _root = tdp_mmu_next_root(_kvm, _root, _only_valid))		\
+	     _root = tdp_mmu_next_root(_kvm, _root, _types))		\
 		if (_as_id >= 0 && kvm_mmu_page_as_id(_root) != _as_id) {	\
 		} else
 
 #define for_each_valid_tdp_mmu_root_yield_safe(_kvm, _root, _as_id)	\
-	__for_each_tdp_mmu_root_yield_safe(_kvm, _root, _as_id, true)
+	__for_each_tdp_mmu_root_yield_safe(_kvm, _root, _as_id, KVM_ANY_VALID_ROOTS)
 
 #define for_each_tdp_mmu_root_yield_safe(_kvm, _root)			\
-	for (_root = tdp_mmu_next_root(_kvm, NULL, false);		\
+	for (_root = tdp_mmu_next_root(_kvm, NULL, KVM_ANY_ROOTS);		\
 	     ({ lockdep_assert_held(&(_kvm)->mmu_lock); }), _root;	\
-	     _root = tdp_mmu_next_root(_kvm, _root, false))
+	     _root = tdp_mmu_next_root(_kvm, _root, KVM_ANY_ROOTS))
 
 /*
  * Iterate over all TDP MMU roots.  Requires that mmu_lock be held for write,
@@ -180,18 +181,18 @@ static struct kvm_mmu_page *tdp_mmu_next_root(struct kvm *kvm,
  * Holding mmu_lock for write obviates the need for RCU protection as the list
  * is guaranteed to be stable.
  */
-#define __for_each_tdp_mmu_root(_kvm, _root, _as_id, _only_valid)		\
+#define __for_each_tdp_mmu_root(_kvm, _root, _as_id, _types)			\
 	list_for_each_entry(_root, &_kvm->arch.tdp_mmu_roots, link)		\
 		if (kvm_lockdep_assert_mmu_lock_held(_kvm, false) &&		\
 		    ((_as_id >= 0 && kvm_mmu_page_as_id(_root) != _as_id) ||	\
-		     !tdp_mmu_root_match((_root), (_only_valid)))) {		\
+		     !tdp_mmu_root_match((_root), (_types)))) {			\
 		} else
 
 #define for_each_tdp_mmu_root(_kvm, _root, _as_id)			\
-	__for_each_tdp_mmu_root(_kvm, _root, _as_id, false)
+	__for_each_tdp_mmu_root(_kvm, _root, _as_id, KVM_ANY_ROOTS)
 
 #define for_each_valid_tdp_mmu_root(_kvm, _root, _as_id)		\
-	__for_each_tdp_mmu_root(_kvm, _root, _as_id, true)
+	__for_each_tdp_mmu_root(_kvm, _root, _as_id, KVM_ANY_VALID_ROOTS)
 
 static struct kvm_mmu_page *tdp_mmu_alloc_sp(struct kvm_vcpu *vcpu)
 {
@@ -1389,7 +1390,7 @@ bool kvm_tdp_mmu_unmap_gfn_range(struct kvm *kvm, struct kvm_gfn_range *range,
 {
 	struct kvm_mmu_page *root;
 
-	__for_each_tdp_mmu_root_yield_safe(kvm, root, range->slot->as_id, false)
+	__for_each_tdp_mmu_root_yield_safe(kvm, root, range->slot->as_id, KVM_ANY_ROOTS)
 		flush = tdp_mmu_zap_leafs(kvm, root, range->start, range->end,
 					  range->may_block, flush);
 
diff --git a/arch/x86/kvm/mmu/tdp_mmu.h b/arch/x86/kvm/mmu/tdp_mmu.h
index ac350c51bc18..30f2ab88a642 100644
--- a/arch/x86/kvm/mmu/tdp_mmu.h
+++ b/arch/x86/kvm/mmu/tdp_mmu.h
@@ -19,6 +19,13 @@ __must_check static inline bool kvm_tdp_mmu_get_root(struct kvm_mmu_page *root)
 
 void kvm_tdp_mmu_put_root(struct kvm *kvm, struct kvm_mmu_page *root);
 
+enum kvm_tdp_mmu_root_types {
+	KVM_VALID_ROOTS = BIT(0),
+
+	KVM_ANY_ROOTS = 0,
+	KVM_ANY_VALID_ROOTS = KVM_VALID_ROOTS,
+};
+
 bool kvm_tdp_mmu_zap_leafs(struct kvm *kvm, gfn_t start, gfn_t end, bool flush);
 bool kvm_tdp_mmu_zap_sp(struct kvm *kvm, struct kvm_mmu_page *sp);
 void kvm_tdp_mmu_zap_all(struct kvm *kvm);
-- 
2.34.1


