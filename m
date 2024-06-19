Return-Path: <kvm+bounces-20032-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 702E690F932
	for <lists+kvm@lfdr.de>; Thu, 20 Jun 2024 00:42:08 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id ED2741F211B5
	for <lists+kvm@lfdr.de>; Wed, 19 Jun 2024 22:42:07 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9454C18A935;
	Wed, 19 Jun 2024 22:36:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="WgeGxQlo"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9AD7A178398;
	Wed, 19 Jun 2024 22:36:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718836597; cv=none; b=HsUynZeOiZGk5W1hZRhWjP9uHbqiXD3j3LD1y7gntbFLkWS4O3ROgzuMCLaayLFs5OrABARfkDsJygdggl9nYV31xkQYJfZXBezXuYQ7Yc5HEHj9dkFXSSlp5QZOY3k8Jg53bbT4rMAc6jvgKlWcBLd/ahPzLgGJPYXVaeDmFHc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718836597; c=relaxed/simple;
	bh=gyqCXAqInwpLDUh8xpugEw+DovtUHFTkAAI6HBG3UV4=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=vFLCS2DHRemSzwhQs1M7IQN9RuHGmd650MFLEwQkZWyYjDRh1xPwVhgGzke/n0o7xBQnT7ZRjW+HX9v3t/o/HCgaC0RjVwFmhnKpb7EmrAfnPQh/5DLwMSXATWdqDce2u0qsDvJKDS3AD8mfyWf/AGFE2hUlhusrJy8kzO/7FL8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=WgeGxQlo; arc=none smtp.client-ip=198.175.65.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1718836594; x=1750372594;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=gyqCXAqInwpLDUh8xpugEw+DovtUHFTkAAI6HBG3UV4=;
  b=WgeGxQlowLO50XCjMRxYIfIi7pR8sVD/4Tg4QkMeezmK1PZBRzadSs40
   V6A1f6afQTOszBYIYXAilSB8bApGB91BrP/fH1rDC39PO8oHIDIPmasxx
   e83MoQQqMo5HkbtZDLBKvz6JoY5CKaLHWvqSE6vJEe9FzvrHD2Ly6fIsB
   Y2zj8eZOxMG/ou3TfwQj9qPQyaSZxzWGnLQXnGz16iEWt/0A6oMNeLt95
   CNdo239kCSE8tMlfSt0SLiXjrXWKcAX4j78n81ly+r4ast30e7RDTLj4+
   HGysP4wfki7P32jqKDc1PbkwYt/SsDniXKtJdkhBZ8wIsONNhFcCLBgYZ
   g==;
X-CSE-ConnectionGUID: CYZ9uVDISNy9noMitPzqAA==
X-CSE-MsgGUID: NzoTKDlES1SNroxY03HTww==
X-IronPort-AV: E=McAfee;i="6700,10204,11108"; a="15932004"
X-IronPort-AV: E=Sophos;i="6.08,251,1712646000"; 
   d="scan'208";a="15932004"
Received: from orviesa002.jf.intel.com ([10.64.159.142])
  by orvoesa110.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Jun 2024 15:36:25 -0700
X-CSE-ConnectionGUID: bKgTxUzcRAyngctzyjICuw==
X-CSE-MsgGUID: d0wp7W2rS3urT4KyXn9KiQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.08,251,1712646000"; 
   d="scan'208";a="72793380"
Received: from ivsilic-mobl2.amr.corp.intel.com (HELO rpedgeco-desk4.intel.com) ([10.209.54.39])
  by orviesa002-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Jun 2024 15:36:24 -0700
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
	Isaku Yamahata <isaku.yamahata@intel.com>,
	Chao Gao <chao.gao@intel.com>
Subject: [PATCH v3 17/17] KVM: x86/tdp_mmu: Take root types for kvm_tdp_mmu_invalidate_all_roots()
Date: Wed, 19 Jun 2024 15:36:14 -0700
Message-Id: <20240619223614.290657-18-rick.p.edgecombe@intel.com>
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

Rename kvm_tdp_mmu_invalidate_all_roots() to
kvm_tdp_mmu_invalidate_roots(), and make it enum kvm_tdp_mmu_root_types
as an argument.

kvm_tdp_mmu_invalidate_roots() is called with different root types. For
kvm_mmu_zap_all_fast() it only operates on shared roots. But when tearing
down a VM it needs to invalidate all roots. Have the callers only
invalidate the required roots instead of all roots.

Within kvm_tdp_mmu_invalidate_roots(), respect the root type
passed by checking the root type in root iterator.

Suggested-by: Chao Gao <chao.gao@intel.com>
Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
Signed-off-by: Rick Edgecombe <rick.p.edgecombe@intel.com>
---
TDX MMU Prep v3:
 - Use root enum instead of process enum (Paolo)
 - Squash with "KVM: x86/tdp_mmu: Invalidate correct roots" (Paolo)
 - Update comment in kvm_mmu_zap_all_fast() (Paolo)
 - Add warning for attempting to invalidate invalid roots (Paolo)

TDX MMU Prep v2:
 - Use process enum instead of root

TDX MMU Prep:
 - New patch
---
 arch/x86/kvm/mmu/mmu.c     |  9 +++++++--
 arch/x86/kvm/mmu/tdp_mmu.c | 15 +++++++++++++--
 arch/x86/kvm/mmu/tdp_mmu.h |  3 ++-
 3 files changed, 22 insertions(+), 5 deletions(-)

diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index 287dcc2685e4..c5255aa62146 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -6414,8 +6414,13 @@ static void kvm_mmu_zap_all_fast(struct kvm *kvm)
 	 * write and in the same critical section as making the reload request,
 	 * e.g. before kvm_zap_obsolete_pages() could drop mmu_lock and yield.
 	 */
-	if (tdp_mmu_enabled)
-		kvm_tdp_mmu_invalidate_all_roots(kvm);
+	if (tdp_mmu_enabled) {
+		/*
+		 * External page tables don't support fast zapping, therefore
+		 * their mirrors must be invalidated separately by the caller.
+		 */
+		kvm_tdp_mmu_invalidate_roots(kvm, KVM_DIRECT_ROOTS);
+	}
 
 	/*
 	 * Notify all vcpus to reload its shadow page table and flush TLB.
diff --git a/arch/x86/kvm/mmu/tdp_mmu.c b/arch/x86/kvm/mmu/tdp_mmu.c
index 630e6b6d4bf2..a1ab67a4f41f 100644
--- a/arch/x86/kvm/mmu/tdp_mmu.c
+++ b/arch/x86/kvm/mmu/tdp_mmu.c
@@ -37,7 +37,7 @@ void kvm_mmu_uninit_tdp_mmu(struct kvm *kvm)
 	 * for zapping and thus puts the TDP MMU's reference to each root, i.e.
 	 * ultimately frees all roots.
 	 */
-	kvm_tdp_mmu_invalidate_all_roots(kvm);
+	kvm_tdp_mmu_invalidate_roots(kvm, KVM_VALID_ROOTS);
 	kvm_tdp_mmu_zap_invalidated_roots(kvm);
 
 	WARN_ON(atomic64_read(&kvm->arch.tdp_mmu_pages));
@@ -1110,10 +1110,18 @@ void kvm_tdp_mmu_zap_invalidated_roots(struct kvm *kvm)
  * Note, kvm_tdp_mmu_zap_invalidated_roots() is gifted the TDP MMU's reference.
  * See kvm_tdp_mmu_alloc_root().
  */
-void kvm_tdp_mmu_invalidate_all_roots(struct kvm *kvm)
+void kvm_tdp_mmu_invalidate_roots(struct kvm *kvm,
+				  enum kvm_tdp_mmu_root_types root_types)
 {
 	struct kvm_mmu_page *root;
 
+	/*
+	 * Invalidating invalid roots doesn't make sense, prevent developers from
+	 * having to think about it.
+	 */
+	if (WARN_ON_ONCE(root_types & KVM_INVALID_ROOTS))
+		root_types &= ~KVM_INVALID_ROOTS;
+
 	/*
 	 * mmu_lock must be held for write to ensure that a root doesn't become
 	 * invalid while there are active readers (invalidating a root while
@@ -1135,6 +1143,9 @@ void kvm_tdp_mmu_invalidate_all_roots(struct kvm *kvm)
 	 * or get/put references to roots.
 	 */
 	list_for_each_entry(root, &kvm->arch.tdp_mmu_roots, link) {
+		if (!tdp_mmu_root_match(root, root_types))
+			continue;
+
 		/*
 		 * Note, invalid roots can outlive a memslot update!  Invalid
 		 * roots must be *zapped* before the memslot update completes,
diff --git a/arch/x86/kvm/mmu/tdp_mmu.h b/arch/x86/kvm/mmu/tdp_mmu.h
index 2903f03a34be..56741d31048a 100644
--- a/arch/x86/kvm/mmu/tdp_mmu.h
+++ b/arch/x86/kvm/mmu/tdp_mmu.h
@@ -66,7 +66,8 @@ static inline struct kvm_mmu_page *tdp_mmu_get_root(struct kvm_vcpu *vcpu,
 bool kvm_tdp_mmu_zap_leafs(struct kvm *kvm, gfn_t start, gfn_t end, bool flush);
 bool kvm_tdp_mmu_zap_sp(struct kvm *kvm, struct kvm_mmu_page *sp);
 void kvm_tdp_mmu_zap_all(struct kvm *kvm);
-void kvm_tdp_mmu_invalidate_all_roots(struct kvm *kvm);
+void kvm_tdp_mmu_invalidate_roots(struct kvm *kvm,
+				  enum kvm_tdp_mmu_root_types root_types);
 void kvm_tdp_mmu_zap_invalidated_roots(struct kvm *kvm);
 
 int kvm_tdp_mmu_map(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault);
-- 
2.34.1


