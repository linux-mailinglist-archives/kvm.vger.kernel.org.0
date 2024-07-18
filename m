Return-Path: <kvm+bounces-21892-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 1B94C935303
	for <lists+kvm@lfdr.de>; Thu, 18 Jul 2024 23:15:32 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 7A868B223F3
	for <lists+kvm@lfdr.de>; Thu, 18 Jul 2024 21:15:29 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1C68E1494A1;
	Thu, 18 Jul 2024 21:12:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="NZY/caG7"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.15])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 45A061482E7;
	Thu, 18 Jul 2024 21:12:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.15
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721337173; cv=none; b=XnChky+WqYgzcLs7X3QyIRtY2Ia4a44CBnU/37oTe5Vptc0wvuXG5G69scOtdxFuoX446iFF3xQSSS97sd3PenqJCr+0XBKlgB/iHw2zDMY3btsrg+MbMYvKENY4/JykrhGXsF7S8Ks4gkKw0ChltuTHDE3kmjZFq18kvrL3lpU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721337173; c=relaxed/simple;
	bh=ZFEM13pQvfYyREXhXVeK7dytiHFqPZUsq9cnopNZdxc=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=Op3U6804BYL+HAoi/U4oql+DwGjFtmcS8CWlrW4IixFgUvvVAa2vjd2/1dLwV7mCwKNiS1LXqD6Tp5viHPVUzaKS30KzFPAk/AEomJnMBUyZE8Yy7GiFoZ+KNfG38vAFL5YimtjQs+V1V0F3SdMZGsU5vsz4W8Lyuqnzm66KauQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=NZY/caG7; arc=none smtp.client-ip=198.175.65.15
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1721337171; x=1752873171;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=ZFEM13pQvfYyREXhXVeK7dytiHFqPZUsq9cnopNZdxc=;
  b=NZY/caG7L9eq1eSHtHJlcZawM1FBYbqC/+yGxqorvCazVZU4MULEnZMY
   QrGElgRMKYvnfm9cQTQDlXh2IExLlrkxRtNmpix0LNjPk2zRlCY5RwmSk
   OF2P+eZFxwIvH7aAU+FvUIpHROZC5tloq2U454GoCvr0J5rm2M2pzMIZt
   w1kfNR+Dhc3RHIjQ3EcsXa/umfLYrTVeGUTgWH87KOlY66gz0Sj55r1iY
   WrjnI4oNCnbuBRPEgT52WuWRYOppGWQ/pJBI/4fQYeesjC/q9rroSPqpM
   pF9TG6ALxL6wdADnypGMpkIkgU8WgcCabefo6braNkMahhPn1+w5wmtfC
   w==;
X-CSE-ConnectionGUID: Hfhdsz5kQsKCPeks4+yxfg==
X-CSE-MsgGUID: nfajXWD6QnmnCMM5uaODpw==
X-IronPort-AV: E=McAfee;i="6700,10204,11137"; a="22697437"
X-IronPort-AV: E=Sophos;i="6.09,218,1716274800"; 
   d="scan'208";a="22697437"
Received: from orviesa003.jf.intel.com ([10.64.159.143])
  by orvoesa107.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Jul 2024 14:12:47 -0700
X-CSE-ConnectionGUID: O3E8WUe1Rzus0cbpJc80zQ==
X-CSE-MsgGUID: aX30zjW5RzS18Ttt0DWOiQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.09,218,1716274800"; 
   d="scan'208";a="55760403"
Received: from ccbilbre-mobl3.amr.corp.intel.com (HELO rpedgeco-desk4..) ([10.124.223.76])
  by ORVIESA003-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Jul 2024 14:12:47 -0700
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
Subject: [PATCH v4 10/18] KVM: x86/tdp_mmu: Introduce KVM MMU root types to specify page table type
Date: Thu, 18 Jul 2024 14:12:22 -0700
Message-Id: <20240718211230.1492011-11-rick.p.edgecombe@intel.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20240718211230.1492011-1-rick.p.edgecombe@intel.com>
References: <20240718211230.1492011-1-rick.p.edgecombe@intel.com>
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
v3:
 - Drop KVM_ANY_ROOTS, KVM_ANY_VALID_ROOTS and switch to KVM_VALID_ROOTS
   and KVM_ALL_ROOTS. (Paolo)

v1:
 - Newly introduced.
---
 arch/x86/kvm/mmu/tdp_mmu.c | 41 +++++++++++++++++++-------------------
 arch/x86/kvm/mmu/tdp_mmu.h |  7 +++++++
 2 files changed, 28 insertions(+), 20 deletions(-)

diff --git a/arch/x86/kvm/mmu/tdp_mmu.c b/arch/x86/kvm/mmu/tdp_mmu.c
index 412e9a031671..2e7e6e3137c6 100644
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
@@ -1201,7 +1202,7 @@ bool kvm_tdp_mmu_unmap_gfn_range(struct kvm *kvm, struct kvm_gfn_range *range,
 {
 	struct kvm_mmu_page *root;
 
-	__for_each_tdp_mmu_root_yield_safe(kvm, root, range->slot->as_id, false)
+	__for_each_tdp_mmu_root_yield_safe(kvm, root, range->slot->as_id, KVM_ALL_ROOTS)
 		flush = tdp_mmu_zap_leafs(kvm, root, range->start, range->end,
 					  range->may_block, flush);
 
diff --git a/arch/x86/kvm/mmu/tdp_mmu.h b/arch/x86/kvm/mmu/tdp_mmu.h
index a0e00284b75d..8980c869e39c 100644
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


