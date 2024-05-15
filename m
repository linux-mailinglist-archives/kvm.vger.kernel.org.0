Return-Path: <kvm+bounces-17409-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 262FC8C5E9A
	for <lists+kvm@lfdr.de>; Wed, 15 May 2024 03:04:08 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 459A01C21013
	for <lists+kvm@lfdr.de>; Wed, 15 May 2024 01:04:07 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 088893BBF5;
	Wed, 15 May 2024 01:00:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="N/832aU/"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8FAED383BE;
	Wed, 15 May 2024 01:00:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.19
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715734815; cv=none; b=jAFp81kyV/2VTG1nVT1n2dIL4ewSSKjzeZ1+DZc4iMUWjqs3fQV1hT27EU7D/GnvFngRogoMVgzBjPquK5/sNkkJQhgkGbJ1wMHlSRlRL7fJ63E35ziaBgYvr/33EArwu6KYeR2kcTYYrYisQYArtcDc5TwuIF7r2zP+GrEyMWo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715734815; c=relaxed/simple;
	bh=YcYrPvm62cI+4A1/6iEWc+sBYrpX+wYdWWAThta5Qro=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=mu+ejgMSIc0m3S1pwwvVtUgPgneshzVyRUhN4GxxtqajzXrT7bMsw+I+kgQbbYQrxuIf670X/HPvqkd3DigIf8eWNQ45oOS8tbLg6Co2WMrs2+qCpullv8tQKSkLirjS6UsuIY48TMg3EVGXMErngPn403vUppw5t1XUFX8Knts=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=N/832aU/; arc=none smtp.client-ip=192.198.163.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1715734814; x=1747270814;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=YcYrPvm62cI+4A1/6iEWc+sBYrpX+wYdWWAThta5Qro=;
  b=N/832aU/jx5M5XU4K0OWyY7yufcqL8XkRl/GGhRZLBS2S+Y9bIiHMdOt
   570c059o3WKshg50Ed9KC08TK5IKuteWXys+HGtV5zSiMhgo68sDyGANt
   lTAY1Y14/jE3ipLboyeKr2s1HXKalQd3ZlpkxWNyH6Qtk07VQaMN9nFoP
   KTpBj37RGNfjRBSgVT8Kt8W1IK+qP5YCzUHGidsoYXOhP5nwOJDpzUKOg
   z8u5sZJOqRCPmTft2yfF8p/6DJ7QLFiaXCCqAGpk3EIUsfS/XrdGoV1xd
   2R2LhL2UaEvVTXkR7Ub8yv61Lt4TgCO2wi8WOKdZqkKuBcaR8EtDen4Ah
   w==;
X-CSE-ConnectionGUID: 74Hcq4I6Qg6EDRa60m1qFQ==
X-CSE-MsgGUID: rL4IxInCRKKRGbknql24oA==
X-IronPort-AV: E=McAfee;i="6600,9927,11073"; a="11613990"
X-IronPort-AV: E=Sophos;i="6.08,160,1712646000"; 
   d="scan'208";a="11613990"
Received: from fmviesa006.fm.intel.com ([10.60.135.146])
  by fmvoesa113.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 May 2024 18:00:08 -0700
X-CSE-ConnectionGUID: kG7EbLaVSrepTn16J4iMxg==
X-CSE-MsgGUID: 4BA517K8RgukFZNAhdnQcQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.08,160,1712646000"; 
   d="scan'208";a="30942837"
Received: from oyildiz-mobl1.amr.corp.intel.com (HELO rpedgeco-desk4.intel.com) ([10.209.51.34])
  by fmviesa006-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 May 2024 18:00:07 -0700
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
Subject: [PATCH 14/16] KVM: x86/tdp_mmu: Take root types for kvm_tdp_mmu_invalidate_all_roots()
Date: Tue, 14 May 2024 17:59:50 -0700
Message-Id: <20240515005952.3410568-15-rick.p.edgecombe@intel.com>
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

Rename kvm_tdp_mmu_invalidate_all_roots() to
kvm_tdp_mmu_invalidate_roots(), and make it enum kvm_tdp_mmu_root_types
as an argument.

Have the callers only invalidate the required roots instead of all
roots.

Suggested-by: Chao Gao <chao.gao@intel.com>
Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
Signed-off-by: Rick Edgecombe <rick.p.edgecombe@intel.com>
---
TDX MMU Part 1:
 - New patch
---
 arch/x86/kvm/mmu/mmu.c     | 9 +++++++--
 arch/x86/kvm/mmu/tdp_mmu.c | 5 +++--
 arch/x86/kvm/mmu/tdp_mmu.h | 3 ++-
 3 files changed, 12 insertions(+), 5 deletions(-)

diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index 2506d6277818..338628094ad7 100644
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
+		kvm_tdp_mmu_invalidate_roots(kvm, KVM_SHARED_ROOTS);
+	}
 
 	/*
 	 * Notify all vcpus to reload its shadow page table and flush TLB.
diff --git a/arch/x86/kvm/mmu/tdp_mmu.c b/arch/x86/kvm/mmu/tdp_mmu.c
index 8914c5b0d5ab..eb88af48c8f0 100644
--- a/arch/x86/kvm/mmu/tdp_mmu.c
+++ b/arch/x86/kvm/mmu/tdp_mmu.c
@@ -37,7 +37,7 @@ void kvm_mmu_uninit_tdp_mmu(struct kvm *kvm)
 	 * for zapping and thus puts the TDP MMU's reference to each root, i.e.
 	 * ultimately frees all roots.
 	 */
-	kvm_tdp_mmu_invalidate_all_roots(kvm);
+	kvm_tdp_mmu_invalidate_roots(kvm, KVM_ANY_ROOTS);
 	kvm_tdp_mmu_zap_invalidated_roots(kvm);
 
 	WARN_ON(atomic64_read(&kvm->arch.tdp_mmu_pages));
@@ -1170,7 +1170,8 @@ void kvm_tdp_mmu_zap_invalidated_roots(struct kvm *kvm)
  * Note, kvm_tdp_mmu_zap_invalidated_roots() is gifted the TDP MMU's reference.
  * See kvm_tdp_mmu_alloc_root().
  */
-void kvm_tdp_mmu_invalidate_all_roots(struct kvm *kvm)
+void kvm_tdp_mmu_invalidate_roots(struct kvm *kvm,
+				  enum kvm_tdp_mmu_root_types types)
 {
 	struct kvm_mmu_page *root;
 
diff --git a/arch/x86/kvm/mmu/tdp_mmu.h b/arch/x86/kvm/mmu/tdp_mmu.h
index 6a65498b481c..b8a967426fac 100644
--- a/arch/x86/kvm/mmu/tdp_mmu.h
+++ b/arch/x86/kvm/mmu/tdp_mmu.h
@@ -35,7 +35,8 @@ static_assert(KVM_PRIVATE_ROOTS == (KVM_SHARED_ROOTS << 1));
 bool kvm_tdp_mmu_zap_leafs(struct kvm *kvm, gfn_t start, gfn_t end, bool flush);
 bool kvm_tdp_mmu_zap_sp(struct kvm *kvm, struct kvm_mmu_page *sp);
 void kvm_tdp_mmu_zap_all(struct kvm *kvm);
-void kvm_tdp_mmu_invalidate_all_roots(struct kvm *kvm);
+void kvm_tdp_mmu_invalidate_roots(struct kvm *kvm,
+				  enum kvm_tdp_mmu_root_types types);
 void kvm_tdp_mmu_zap_invalidated_roots(struct kvm *kvm);
 
 int kvm_tdp_mmu_map(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault);
-- 
2.34.1


