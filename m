Return-Path: <kvm+bounces-21898-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 71E7F93530E
	for <lists+kvm@lfdr.de>; Thu, 18 Jul 2024 23:17:01 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 959E51C20C31
	for <lists+kvm@lfdr.de>; Thu, 18 Jul 2024 21:17:00 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3B73B14A4F9;
	Thu, 18 Jul 2024 21:12:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="R23NPuGk"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.15])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5944E149C50;
	Thu, 18 Jul 2024 21:12:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.15
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721337177; cv=none; b=Dt0QZvth3W1kmt2JIqBaV9WXlcT0hRICrmhmfzYVipPCj4FfPi532NDQidFKc295uW8IwxQG6igxG8ZPd57cKeCFpEeIgcZsXEObeeb82z7TvUYyUlNeMcIIw8/ZI+EZveV8mFEHHzCzlXDs1NbsbVeS+UIsMId+wGlqaJ7kc9Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721337177; c=relaxed/simple;
	bh=xMNkuRIzC+H6nAOGbncvwl9AuctbTkUnvnIZlBceRDs=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=in2SaF68/6EivwjHSdMh75Cz81FL0kAmDj2d9acuZZaoxjB3Zxo9wnvntdNUJYTSLar1caiFRIa2oo41gjmhavBMe/h6wN+XgM5KUSWQQeXc+mAHf8gNp8lM69hWRFd7H7PjzTxKM5NbgteY1F8JLAzwr9UEYt2mjVCh7jiA624=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=R23NPuGk; arc=none smtp.client-ip=198.175.65.15
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1721337175; x=1752873175;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=xMNkuRIzC+H6nAOGbncvwl9AuctbTkUnvnIZlBceRDs=;
  b=R23NPuGkjUtmOzyhGCIzClaySzRHNuG4zVtVb4yWDggDeffp5H7HdPm5
   aRK2R1AUwIwSIl3GTpMPHrlXXNu0eSQVTvmWrRWyPwY4JTJYBTJ95jE3H
   DrK2phq1S4mzXbjWHF/x4jbIwO4+agLC5SV/3X4l3gx4kKNbR/YHtiRpS
   ZsrJPT0obMHuUmOp4jUwUufR+fJWExNjzt1s+Pg5ib9eGPlyxiOh53+oO
   +6MeH8DuAIJhGRM0C7G0/gGsr7PDx+638DowZ6emdLCAfCsv84Ga1ZdGc
   XgKmftVilvxrDPA7OUisTH/QXxmqBK5WEEeMiCQyl+tInd5tgGVWbJmWf
   w==;
X-CSE-ConnectionGUID: orL7qUrRRdGot/Iyr9mezg==
X-CSE-MsgGUID: OunEGVGhRwKeg3LnOfjuPA==
X-IronPort-AV: E=McAfee;i="6700,10204,11137"; a="22697472"
X-IronPort-AV: E=Sophos;i="6.09,218,1716274800"; 
   d="scan'208";a="22697472"
Received: from orviesa003.jf.intel.com ([10.64.159.143])
  by orvoesa107.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Jul 2024 14:12:52 -0700
X-CSE-ConnectionGUID: /3upg5TMTZen2AHm8YY8HQ==
X-CSE-MsgGUID: zmm0NoSjSjOx1QxWOEnHEw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.09,218,1716274800"; 
   d="scan'208";a="55760429"
Received: from ccbilbre-mobl3.amr.corp.intel.com (HELO rpedgeco-desk4..) ([10.124.223.76])
  by ORVIESA003-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Jul 2024 14:12:51 -0700
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
Subject: [PATCH v4 16/18] KVM: x86/tdp_mmu: Take root types for kvm_tdp_mmu_invalidate_all_roots()
Date: Thu, 18 Jul 2024 14:12:28 -0700
Message-Id: <20240718211230.1492011-17-rick.p.edgecombe@intel.com>
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
v3:
 - Use root enum instead of process enum (Paolo)
 - Squash with "KVM: x86/tdp_mmu: Invalidate correct roots" (Paolo)
 - Update comment in kvm_mmu_zap_all_fast() (Paolo)
 - Add warning for attempting to invalidate invalid roots (Paolo)

v2:
 - Use process enum instead of root

v1:
 - New patch
---
 arch/x86/kvm/mmu/mmu.c     |  9 +++++++--
 arch/x86/kvm/mmu/tdp_mmu.c | 15 +++++++++++++--
 arch/x86/kvm/mmu/tdp_mmu.h |  3 ++-
 3 files changed, 22 insertions(+), 5 deletions(-)

diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index 2c73360533c2..3fe7f7d94c7e 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -6460,8 +6460,13 @@ static void kvm_mmu_zap_all_fast(struct kvm *kvm)
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
index ea2c64450135..2f3ba9d477e9 100644
--- a/arch/x86/kvm/mmu/tdp_mmu.c
+++ b/arch/x86/kvm/mmu/tdp_mmu.c
@@ -37,7 +37,7 @@ void kvm_mmu_uninit_tdp_mmu(struct kvm *kvm)
 	 * for zapping and thus puts the TDP MMU's reference to each root, i.e.
 	 * ultimately frees all roots.
 	 */
-	kvm_tdp_mmu_invalidate_all_roots(kvm);
+	kvm_tdp_mmu_invalidate_roots(kvm, KVM_VALID_ROOTS);
 	kvm_tdp_mmu_zap_invalidated_roots(kvm, false);
 
 	WARN_ON(atomic64_read(&kvm->arch.tdp_mmu_pages));
@@ -1115,10 +1115,18 @@ void kvm_tdp_mmu_zap_invalidated_roots(struct kvm *kvm, bool shared)
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
@@ -1140,6 +1148,9 @@ void kvm_tdp_mmu_invalidate_all_roots(struct kvm *kvm)
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
index 5b607adca680..7927fa4a96e0 100644
--- a/arch/x86/kvm/mmu/tdp_mmu.h
+++ b/arch/x86/kvm/mmu/tdp_mmu.h
@@ -66,7 +66,8 @@ static inline struct kvm_mmu_page *tdp_mmu_get_root(struct kvm_vcpu *vcpu,
 bool kvm_tdp_mmu_zap_leafs(struct kvm *kvm, gfn_t start, gfn_t end, bool flush);
 bool kvm_tdp_mmu_zap_sp(struct kvm *kvm, struct kvm_mmu_page *sp);
 void kvm_tdp_mmu_zap_all(struct kvm *kvm);
-void kvm_tdp_mmu_invalidate_all_roots(struct kvm *kvm);
+void kvm_tdp_mmu_invalidate_roots(struct kvm *kvm,
+				  enum kvm_tdp_mmu_root_types root_types);
 void kvm_tdp_mmu_zap_invalidated_roots(struct kvm *kvm, bool shared);
 
 int kvm_tdp_mmu_map(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault);
-- 
2.34.1


