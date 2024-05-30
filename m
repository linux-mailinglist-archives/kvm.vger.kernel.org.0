Return-Path: <kvm+bounces-18449-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 487868D5446
	for <lists+kvm@lfdr.de>; Thu, 30 May 2024 23:11:05 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 786EE1C24A77
	for <lists+kvm@lfdr.de>; Thu, 30 May 2024 21:11:04 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 91C6B1A0B10;
	Thu, 30 May 2024 21:07:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="FhfmNA5h"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0AB8B194C99;
	Thu, 30 May 2024 21:07:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.10
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717103261; cv=none; b=uGrZtZclwP7jsmpO0gujsFQo784tDVPvdl7XqbER1z50BlV7IoPNny6JsPU0xpMHUAIFDK27tw0u/WpPT8200FF+cG8RWeqgZ0xcD5LbV6Adj0fKukh4TnOE1TXNHJunj/1PIw7BPmEpXfh4YAbMV3lsC8GCYjbrA7uPtIdtR80=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717103261; c=relaxed/simple;
	bh=BtBJUebVXPPR75jnHMPrw//0iwfk/CpddHleWtgt9bA=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=T6av+pp2PFw/YjGG4FymOoI2nDoqZP8B/Dm2qlPA9tn/Vk0iz11JsbMq5PdXq9qV2/XgSVIHTLFts7BaPMAFwWyTPXePv3mDtg7oro1p4UK0FaddzJjiFqnZRxP6CJcQnLalLnMscS40ZX8DHg3RMVNOB8/8Z2hI/VYc0W1A+WE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=FhfmNA5h; arc=none smtp.client-ip=198.175.65.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1717103260; x=1748639260;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=BtBJUebVXPPR75jnHMPrw//0iwfk/CpddHleWtgt9bA=;
  b=FhfmNA5hlTbv2hD1wu6QanI1L3r2pxxfBpyRDulMUFRXhWcJJip4ziIz
   OcYk5pBPcv8yMa5deS33TSR6iU6nWqivL7ulqORT285dSjLy695uIjhlH
   5zZ8NOMKRwVWjfb7DzRbByujpPfVUxD9cQaxKDwd//723Mucr/7hbsLYE
   jF6hUsL26ApYxVCbOEN86caZkPWMxTzFL4v8AR36P6XeZhnR432uZov3W
   6VEGFK/P/cfhhy5sqMHoxcJXNTrXxR5nw68tl3w9NfheMsMSutScPELuW
   QSfc5Ufu/h/jpy3F7cuXCXIdJ04A0enASjclzGNpKLQ+/fuEveRWSMKy3
   g==;
X-CSE-ConnectionGUID: bnMp9hBVQlWrLFAfy5L+1A==
X-CSE-MsgGUID: PtB0TrZpRWe4sCFwrvXQ+A==
X-IronPort-AV: E=McAfee;i="6600,9927,11088"; a="31117144"
X-IronPort-AV: E=Sophos;i="6.08,202,1712646000"; 
   d="scan'208";a="31117144"
Received: from fmviesa007.fm.intel.com ([10.60.135.147])
  by orvoesa102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 May 2024 14:07:39 -0700
X-CSE-ConnectionGUID: vUaX34s0R0G/1HXAzpFU7g==
X-CSE-MsgGUID: oUS79fT0Rfu0lYmpVqewNA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.08,202,1712646000"; 
   d="scan'208";a="35874456"
Received: from hding1-mobl.ccr.corp.intel.com (HELO rpedgeco-desk4.intel.com) ([10.209.19.65])
  by fmviesa007-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 May 2024 14:07:39 -0700
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
Subject: [PATCH v2 12/15] KVM: x86/tdp_mmu: Take root types for kvm_tdp_mmu_invalidate_all_roots()
Date: Thu, 30 May 2024 14:07:11 -0700
Message-Id: <20240530210714.364118-13-rick.p.edgecombe@intel.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20240530210714.364118-1-rick.p.edgecombe@intel.com>
References: <20240530210714.364118-1-rick.p.edgecombe@intel.com>
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

Have the callers only invalidate the required roots instead of all
roots.

Suggested-by: Chao Gao <chao.gao@intel.com>
Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
Signed-off-by: Rick Edgecombe <rick.p.edgecombe@intel.com>
---
TDX MMU Prep v2:
 - Use process enum instead of root

TDX MMU Prep:
 - New patch
---
 arch/x86/kvm/mmu/mmu.c     | 9 +++++++--
 arch/x86/kvm/mmu/tdp_mmu.c | 5 +++--
 arch/x86/kvm/mmu/tdp_mmu.h | 3 ++-
 3 files changed, 12 insertions(+), 5 deletions(-)

diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index 01fb918612ae..0b173aa08728 100644
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
+		 * The private page tables doesn't support fast zapping.  The
+		 * caller should handle it by other way.
+		 */
+		kvm_tdp_mmu_invalidate_roots(kvm, KVM_PROCESS_SHARED);
+	}
 
 	/*
 	 * Notify all vcpus to reload its shadow page table and flush TLB.
diff --git a/arch/x86/kvm/mmu/tdp_mmu.c b/arch/x86/kvm/mmu/tdp_mmu.c
index 1245f6a48dbe..4f00ae7da072 100644
--- a/arch/x86/kvm/mmu/tdp_mmu.c
+++ b/arch/x86/kvm/mmu/tdp_mmu.c
@@ -37,7 +37,7 @@ void kvm_mmu_uninit_tdp_mmu(struct kvm *kvm)
 	 * for zapping and thus puts the TDP MMU's reference to each root, i.e.
 	 * ultimately frees all roots.
 	 */
-	kvm_tdp_mmu_invalidate_all_roots(kvm);
+	kvm_tdp_mmu_invalidate_roots(kvm, KVM_PROCESS_PRIVATE_AND_SHARED);
 	kvm_tdp_mmu_zap_invalidated_roots(kvm);
 
 	WARN_ON(atomic64_read(&kvm->arch.tdp_mmu_pages));
@@ -1132,7 +1132,8 @@ void kvm_tdp_mmu_zap_invalidated_roots(struct kvm *kvm)
  * Note, kvm_tdp_mmu_zap_invalidated_roots() is gifted the TDP MMU's reference.
  * See kvm_tdp_mmu_alloc_root().
  */
-void kvm_tdp_mmu_invalidate_all_roots(struct kvm *kvm)
+void kvm_tdp_mmu_invalidate_roots(struct kvm *kvm,
+				  enum kvm_process process_types)
 {
 	struct kvm_mmu_page *root;
 
diff --git a/arch/x86/kvm/mmu/tdp_mmu.h b/arch/x86/kvm/mmu/tdp_mmu.h
index 934269b82f20..30b1288c1e4d 100644
--- a/arch/x86/kvm/mmu/tdp_mmu.h
+++ b/arch/x86/kvm/mmu/tdp_mmu.h
@@ -62,7 +62,8 @@ static inline struct kvm_mmu_page *tdp_mmu_get_root(struct kvm_vcpu *vcpu, enum
 bool kvm_tdp_mmu_zap_leafs(struct kvm *kvm, gfn_t start, gfn_t end, bool flush);
 bool kvm_tdp_mmu_zap_sp(struct kvm *kvm, struct kvm_mmu_page *sp);
 void kvm_tdp_mmu_zap_all(struct kvm *kvm);
-void kvm_tdp_mmu_invalidate_all_roots(struct kvm *kvm);
+void kvm_tdp_mmu_invalidate_roots(struct kvm *kvm,
+				  enum kvm_process types);
 void kvm_tdp_mmu_zap_invalidated_roots(struct kvm *kvm);
 
 int kvm_tdp_mmu_map(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault);
-- 
2.34.1


