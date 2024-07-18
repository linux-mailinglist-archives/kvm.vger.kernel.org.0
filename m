Return-Path: <kvm+bounces-21883-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 0DC389352F1
	for <lists+kvm@lfdr.de>; Thu, 18 Jul 2024 23:13:09 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 9E24DB219D3
	for <lists+kvm@lfdr.de>; Thu, 18 Jul 2024 21:13:06 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D40A3146016;
	Thu, 18 Jul 2024 21:12:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="LgLvlNbn"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.15])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8391B145B25;
	Thu, 18 Jul 2024 21:12:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.15
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721337164; cv=none; b=to0jBvfU4r8DnSmKD6suYXaTeSlcWAHmFbuOie8yrfoQ4j8nAiUW7IWp85T9Kv0MEZEx4JhRhVgcxoYJfaXv85XYXYquh/CyFrvw13a/UP1kLqECtRbily/53vyM5VNs9SoHTo+E1Z4KmUJZ5fckj4DnxXSrJw7s+mK9L3q+DR8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721337164; c=relaxed/simple;
	bh=voiJnSZtak3rX8dJyCOuacjfMZ/qUSt+GMJzT5DZdmQ=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=NEV02k7EWTnGWjrDMOHw7LZ6HqEChUxVtIChGeyH9PzML+4z/H9cjvzoOVMCf1eqrf8q4aC55pq3vsEh5Cx3pMDNojo+KFi3wspBRPaeCvin4tH71Bt5kNDoEyQwRV/NI/DQD0a+WJ0hdV5ozg1+hmnj/YzK2Q6ylSPNvSnWkgM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=LgLvlNbn; arc=none smtp.client-ip=198.175.65.15
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1721337162; x=1752873162;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=voiJnSZtak3rX8dJyCOuacjfMZ/qUSt+GMJzT5DZdmQ=;
  b=LgLvlNbnoMFzh6wyLtl5JgWvAO1zKeHf+qxFe4rSM2t9ZEbpJ24iQgOo
   Ir1at47rxdiurHJ1fEd/uOkNIq3vrfd6TFBDCdvPc2vxvSmEHJoXvq0wt
   CMrpcnjleAlW+qcl5qt/8iqocPoe9zA232Ak/p8XiaSbZ8KD+LXn1nG38
   Q7erYdnT7PsLVMpoQlVk2i6iA7YOSmoTsznRddpCN1/AaA6i8K1UceLbp
   1qqAE7sfwryjH7kJZiVIS2W/mzqfbnqRObov00fsy+bQ3gXOMxCAg8Ves
   WrlZ0Ekkn+wJ7DvWGsOc5r+FFXGPkzGTzs4VD2WW1sXOI0CQIGpyZQzRQ
   w==;
X-CSE-ConnectionGUID: 0FJU4/tLQqqC+fTKcgd2lQ==
X-CSE-MsgGUID: ZRtCus5BSN2JXkokrdV9WA==
X-IronPort-AV: E=McAfee;i="6700,10204,11137"; a="22697392"
X-IronPort-AV: E=Sophos;i="6.09,218,1716274800"; 
   d="scan'208";a="22697392"
Received: from orviesa003.jf.intel.com ([10.64.159.143])
  by orvoesa107.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Jul 2024 14:12:42 -0700
X-CSE-ConnectionGUID: jJ217vUeTeOpBDU/7FFOBA==
X-CSE-MsgGUID: qVLJpxVWTXe9AoEykOEPgA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.09,218,1716274800"; 
   d="scan'208";a="55760367"
Received: from ccbilbre-mobl3.amr.corp.intel.com (HELO rpedgeco-desk4..) ([10.124.223.76])
  by ORVIESA003-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Jul 2024 14:12:40 -0700
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
	rick.p.edgecombe@intel.com
Subject: [PATCH v4 01/18] KVM: x86/mmu: Zap invalid roots with mmu_lock holding for write at uninit
Date: Thu, 18 Jul 2024 14:12:13 -0700
Message-Id: <20240718211230.1492011-2-rick.p.edgecombe@intel.com>
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

Add a bool parameter to kvm_tdp_mmu_zap_invalidated_roots() to specify
zapping invalid roots under mmu_lock held for read or write. Hold mmu_lock
for write when kvm_tdp_mmu_zap_invalidated_roots() is called by
kvm_mmu_uninit_tdp_mmu().

kvm_mmu_uninit_tdp_mmu() is invoked either before or after executing any
atomic operations on SPTEs by vCPU threads. Therefore, it will not impact
vCPU threads performance if kvm_tdp_mmu_zap_invalidated_roots() acquires
mmu_lock for write to zap invalid roots.

This is a preparation for future TDX patch which asserts that "Users of
atomic zapping don't operate on mirror roots".

Co-developed-by: Yan Zhao <yan.y.zhao@intel.com>
Signed-off-by: Yan Zhao <yan.y.zhao@intel.com>
Signed-off-by: Rick Edgecombe <rick.p.edgecombe@intel.com>
---
v4:
 - New patch
---
 arch/x86/kvm/mmu/mmu.c     |  2 +-
 arch/x86/kvm/mmu/tdp_mmu.c | 16 +++++++++++-----
 arch/x86/kvm/mmu/tdp_mmu.h |  2 +-
 3 files changed, 13 insertions(+), 7 deletions(-)

diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index f6b7391fe438..6f721ab0cd33 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -6473,7 +6473,7 @@ static void kvm_mmu_zap_all_fast(struct kvm *kvm)
 	 * lead to use-after-free.
 	 */
 	if (tdp_mmu_enabled)
-		kvm_tdp_mmu_zap_invalidated_roots(kvm);
+		kvm_tdp_mmu_zap_invalidated_roots(kvm, true);
 }
 
 static bool kvm_has_zapped_obsolete_pages(struct kvm *kvm)
diff --git a/arch/x86/kvm/mmu/tdp_mmu.c b/arch/x86/kvm/mmu/tdp_mmu.c
index ff27e1eadd54..b92dcd5b266f 100644
--- a/arch/x86/kvm/mmu/tdp_mmu.c
+++ b/arch/x86/kvm/mmu/tdp_mmu.c
@@ -38,7 +38,7 @@ void kvm_mmu_uninit_tdp_mmu(struct kvm *kvm)
 	 * ultimately frees all roots.
 	 */
 	kvm_tdp_mmu_invalidate_all_roots(kvm);
-	kvm_tdp_mmu_zap_invalidated_roots(kvm);
+	kvm_tdp_mmu_zap_invalidated_roots(kvm, false);
 
 	WARN_ON(atomic64_read(&kvm->arch.tdp_mmu_pages));
 	WARN_ON(!list_empty(&kvm->arch.tdp_mmu_roots));
@@ -927,11 +927,14 @@ void kvm_tdp_mmu_zap_all(struct kvm *kvm)
  * Zap all invalidated roots to ensure all SPTEs are dropped before the "fast
  * zap" completes.
  */
-void kvm_tdp_mmu_zap_invalidated_roots(struct kvm *kvm)
+void kvm_tdp_mmu_zap_invalidated_roots(struct kvm *kvm, bool shared)
 {
 	struct kvm_mmu_page *root;
 
-	read_lock(&kvm->mmu_lock);
+	if (shared)
+		read_lock(&kvm->mmu_lock);
+	else
+		write_lock(&kvm->mmu_lock);
 
 	for_each_tdp_mmu_root_yield_safe(kvm, root) {
 		if (!root->tdp_mmu_scheduled_root_to_zap)
@@ -949,7 +952,7 @@ void kvm_tdp_mmu_zap_invalidated_roots(struct kvm *kvm)
 		 * that may be zapped, as such entries are associated with the
 		 * ASID on both VMX and SVM.
 		 */
-		tdp_mmu_zap_root(kvm, root, true);
+		tdp_mmu_zap_root(kvm, root, shared);
 
 		/*
 		 * The referenced needs to be put *after* zapping the root, as
@@ -959,7 +962,10 @@ void kvm_tdp_mmu_zap_invalidated_roots(struct kvm *kvm)
 		kvm_tdp_mmu_put_root(kvm, root);
 	}
 
-	read_unlock(&kvm->mmu_lock);
+	if (shared)
+		read_unlock(&kvm->mmu_lock);
+	else
+		write_unlock(&kvm->mmu_lock);
 }
 
 /*
diff --git a/arch/x86/kvm/mmu/tdp_mmu.h b/arch/x86/kvm/mmu/tdp_mmu.h
index 1b74e058a81c..14421d080fe6 100644
--- a/arch/x86/kvm/mmu/tdp_mmu.h
+++ b/arch/x86/kvm/mmu/tdp_mmu.h
@@ -23,7 +23,7 @@ bool kvm_tdp_mmu_zap_leafs(struct kvm *kvm, gfn_t start, gfn_t end, bool flush);
 bool kvm_tdp_mmu_zap_sp(struct kvm *kvm, struct kvm_mmu_page *sp);
 void kvm_tdp_mmu_zap_all(struct kvm *kvm);
 void kvm_tdp_mmu_invalidate_all_roots(struct kvm *kvm);
-void kvm_tdp_mmu_zap_invalidated_roots(struct kvm *kvm);
+void kvm_tdp_mmu_zap_invalidated_roots(struct kvm *kvm, bool shared);
 
 int kvm_tdp_mmu_map(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault);
 
-- 
2.34.1


