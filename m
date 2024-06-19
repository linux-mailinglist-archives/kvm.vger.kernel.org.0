Return-Path: <kvm+bounces-20026-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id A923390F921
	for <lists+kvm@lfdr.de>; Thu, 20 Jun 2024 00:39:56 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 1D434B243E5
	for <lists+kvm@lfdr.de>; Wed, 19 Jun 2024 22:39:54 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 20E9116B39D;
	Wed, 19 Jun 2024 22:36:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="U/wf7ux+"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3E83415FA96;
	Wed, 19 Jun 2024 22:36:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718836592; cv=none; b=PL9yMrbb+Vj8p+qZlqPaoaLU+zrlKHyTqpd+ciLOIOVmxu8CaKLq1jMnfFlQlc02Gj/ISj6g/dFARj4aOEt28W6He47jwh5ocTY0NFeywTXbxzv7Q8mL1uRF9aGr6Zx/GQSvq/KKlFy4AjA1Y+mkHIgHAsumKhR4MB86R85JgfY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718836592; c=relaxed/simple;
	bh=3gBvRGkOGVwhZS+k6E07I4RJRyMHRxT6vEJpGlKab34=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=sAj+aRU2U0QjJy3bR6TYeggyaPGqHyHOsAPE7rvrp0Nxh3AZUxOgszLXxO9eILRl2VKbRPEAaOe3Xu8XGdie49DQyTWYXWwYZQIO4DWo6UdgwEztkNqlnbipfSwzEFs5x/kWf6+X3B8rId5LIUmDbh9Vz9H6nh3mFL1diQBRNS4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=U/wf7ux+; arc=none smtp.client-ip=198.175.65.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1718836590; x=1750372590;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=3gBvRGkOGVwhZS+k6E07I4RJRyMHRxT6vEJpGlKab34=;
  b=U/wf7ux+L2Hr8cweNQ2Pp3+QhPx50Cm8OTCYLe5EZqoJTYZHLaxbSFcP
   LtTMrUTkAjvdmJ1IAXUN1dp1fLepmOCGPYrZMotjC6r94STzh/wCML66r
   8nZgS/qOkeYPCDdO95gnT8xN6QCp4BtejEpFrPEEAvztprBsSH1GIq5CJ
   9p8Jy9JVt1li+QLSt9rczECZNQRLOYg6M6LTDmcbfiCSgvvl19DGG8OWC
   gTvhuV79r0TjqoV0gXfZeiCEWGVYpZlCVSzkGjIaLlgKNg7m0A0brUAdb
   397HmKNxgnfqmTLH+g+fWz6dmzdagVYzYBNJNiCAHr03QhvWfWg7Y2oHT
   Q==;
X-CSE-ConnectionGUID: klG2lcOGTvqy6I30F8MECw==
X-CSE-MsgGUID: 9rx3pUWES06zZ8WA6+W7vA==
X-IronPort-AV: E=McAfee;i="6700,10204,11108"; a="15931977"
X-IronPort-AV: E=Sophos;i="6.08,251,1712646000"; 
   d="scan'208";a="15931977"
Received: from orviesa002.jf.intel.com ([10.64.159.142])
  by orvoesa110.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Jun 2024 15:36:23 -0700
X-CSE-ConnectionGUID: 378aBVdAQ/+wfQ7Gn2/D3Q==
X-CSE-MsgGUID: iaXJ28PWQHO0FyA73C5bYg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.08,251,1712646000"; 
   d="scan'208";a="72793356"
Received: from ivsilic-mobl2.amr.corp.intel.com (HELO rpedgeco-desk4.intel.com) ([10.209.54.39])
  by orviesa002-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Jun 2024 15:36:22 -0700
From: Rick Edgecombe <rick.p.edgecombe@intel.com>
To: seanjc@google.com,
	pbonzini@redhat.com,
	kvm@vger.kernel.org
Cc: kai.huang@intel.com,
	dmatlack@google.com,
	erdemaktas@google.com,
	isaku.yamahata@gmail.com,
	linux-kernel@vger.kernel.org,
	sagis@google.com,
	yan.y.zhao@intel.com,
	rick.p.edgecombe@intel.com,
	Isaku Yamahata <isaku.yamahata@intel.com>
Subject: [PATCH v3 11/17] KVM: x86/tdp_mmu: Introduce KVM MMU root types to specify page table type
Date: Wed, 19 Jun 2024 15:36:08 -0700
Message-Id: <20240619223614.290657-12-rick.p.edgecombe@intel.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20240619223614.290657-1-rick.p.edgecombe@intel.com>
References: <20240619223614.290657-1-rick.p.edgecombe@intel.com>
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
KVM_VALID_ROOTS to avoid further code churn when direct vs mirror root
concepts are introduced in future patches.

Link: https://lore.kernel.org/kvm/ZivazWQw1oCU8VBC@google.com/ [1]
Suggested-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
Signed-off-by: Rick Edgecombe <rick.p.edgecombe@intel.com>
---
TDX MMU Prep v3:
 - Drop KVM_ANY_ROOTS, KVM_ANY_VALID_ROOTS and switch to KVM_VALID_ROOTS
   and KVM_ALL_ROOTS. (Paolo)

TDX MMU Prep:
 - Newly introduced.
---
 arch/x86/kvm/mmu/tdp_mmu.c | 41 +++++++++++++++++++-------------------
 arch/x86/kvm/mmu/tdp_mmu.h |  7 +++++++
 2 files changed, 28 insertions(+), 20 deletions(-)

diff --git a/arch/x86/kvm/mmu/tdp_mmu.c b/arch/x86/kvm/mmu/tdp_mmu.c
index cecc25947001..c8e5e779967e 100644
--- a/arch/x86/kvm/mmu/tdp_mmu.c
+++ b/arch/x86/kvm/mmu/tdp_mmu.c
@@ -92,27 +92,28 @@ void kvm_tdp_mmu_put_root(struct kvm *kvm, struct kvm_mmu_page *root)
 	call_rcu(&root->rcu_head, tdp_mmu_free_sp_rcu_callback);
 }
 
-static bool tdp_mmu_root_match(struct kvm_mmu_page *root, bool only_valid)
+static bool tdp_mmu_root_match(struct kvm_mmu_page *root,
+			       enum kvm_tdp_mmu_root_types types)
 {
-	if (only_valid && root->role.invalid)
-		return false;
+	if (root->role.invalid)
+		return types & KVM_INVALID_ROOTS;
 
 	return true;
 }
 
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
+	__for_each_tdp_mmu_root_yield_safe(_kvm, _root, _as_id, KVM_VALID_ROOTS)
 
 #define for_each_tdp_mmu_root_yield_safe(_kvm, _root)			\
-	for (_root = tdp_mmu_next_root(_kvm, NULL, false);		\
+	for (_root = tdp_mmu_next_root(_kvm, NULL, KVM_ALL_ROOTS);		\
 	     ({ lockdep_assert_held(&(_kvm)->mmu_lock); }), _root;	\
-	     _root = tdp_mmu_next_root(_kvm, _root, false))
+	     _root = tdp_mmu_next_root(_kvm, _root, KVM_ALL_ROOTS))
 
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
+	__for_each_tdp_mmu_root(_kvm, _root, _as_id, KVM_ALL_ROOTS)
 
 #define for_each_valid_tdp_mmu_root(_kvm, _root, _as_id)		\
-	__for_each_tdp_mmu_root(_kvm, _root, _as_id, true)
+	__for_each_tdp_mmu_root(_kvm, _root, _as_id, KVM_VALID_ROOTS)
 
 static struct kvm_mmu_page *tdp_mmu_alloc_sp(struct kvm_vcpu *vcpu)
 {
@@ -1197,7 +1198,7 @@ bool kvm_tdp_mmu_unmap_gfn_range(struct kvm *kvm, struct kvm_gfn_range *range,
 {
 	struct kvm_mmu_page *root;
 
-	__for_each_tdp_mmu_root_yield_safe(kvm, root, range->slot->as_id, false)
+	__for_each_tdp_mmu_root_yield_safe(kvm, root, range->slot->as_id, KVM_ALL_ROOTS)
 		flush = tdp_mmu_zap_leafs(kvm, root, range->start, range->end,
 					  range->may_block, flush);
 
diff --git a/arch/x86/kvm/mmu/tdp_mmu.h b/arch/x86/kvm/mmu/tdp_mmu.h
index 1ba84487f3b7..b887c225ff24 100644
--- a/arch/x86/kvm/mmu/tdp_mmu.h
+++ b/arch/x86/kvm/mmu/tdp_mmu.h
@@ -19,6 +19,13 @@ __must_check static inline bool kvm_tdp_mmu_get_root(struct kvm_mmu_page *root)
 
 void kvm_tdp_mmu_put_root(struct kvm *kvm, struct kvm_mmu_page *root);
 
+enum kvm_tdp_mmu_root_types {
+	KVM_INVALID_ROOTS = BIT(0),
+
+	KVM_VALID_ROOTS = BIT(1),
+	KVM_ALL_ROOTS = KVM_VALID_ROOTS | KVM_INVALID_ROOTS,
+};
+
 bool kvm_tdp_mmu_zap_leafs(struct kvm *kvm, gfn_t start, gfn_t end, bool flush);
 bool kvm_tdp_mmu_zap_sp(struct kvm *kvm, struct kvm_mmu_page *sp);
 void kvm_tdp_mmu_zap_all(struct kvm *kvm);
-- 
2.34.1


