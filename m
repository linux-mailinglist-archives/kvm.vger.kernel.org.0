Return-Path: <kvm+bounces-18442-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id E6CE98D5435
	for <lists+kvm@lfdr.de>; Thu, 30 May 2024 23:09:14 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 8DA581F2176C
	for <lists+kvm@lfdr.de>; Thu, 30 May 2024 21:09:14 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 286E3187344;
	Thu, 30 May 2024 21:07:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="EQ25/GjL"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D60B3181BBE;
	Thu, 30 May 2024 21:07:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.10
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717103257; cv=none; b=AxkPNE2gujohpVHk3TkL0WikOB9cQtwZNxUdv4O1Jq2y8AjgCsQFWSMRtx9EoODUhO918/VY1Ux+Y9S8WiLHrU2BKmWwWaIMWFUJxEvJ8R5x/Y0tsPk5SONZk93JSN9mEr/o7tlTEimkdpXQyHbDcdy0uvvNfHX2Apn/kd0cskg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717103257; c=relaxed/simple;
	bh=HH94uw5e8Q4po8NGWdKp5C9D5EVvEK4acu436dVpbbg=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=iBEV9LNJYl097m+82YUoT2zhsCWyNLq+K6WlatYLThpUUG8dfyp72zA791hG5Mw1HexHsX8pRuWvJZdR0HggpI6YVQICuz+5LY/vj1o0BzRkirbI8FKRJIgsNHSc/pNBhY0Jnh/gVylYoyPAMch/p7o1diOO5RIXhSkcdY78TMU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=EQ25/GjL; arc=none smtp.client-ip=198.175.65.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1717103255; x=1748639255;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=HH94uw5e8Q4po8NGWdKp5C9D5EVvEK4acu436dVpbbg=;
  b=EQ25/GjLThmFjJsi1blP39Zsoue7/6Lkqrj5ElcipAtk7HFezaEWsSAR
   eYu2xYz2s5T1S9R3oX/Dao5E1kqRUhA3ZqgU05zAJPFuFGzVsD8PkWxMa
   XhHphO1Lu5l9gQs+TwFUEaHJGuVT1D6yrWP4J1DOGJIH0gRaxAR3b1p06
   g0EuN6yEELQ3332U27oO888m3Pmi28Y4TQv3BemD0/kIOfuEdoyc60gD1
   kbg7pvJ5WABdhDGJ6OsbLUarQFCwmc/GypLza1YRvK35juyTV80q48rmP
   2TJ8OrewkdrvUJMTlRwQKSihzgfAt8okYJeKnxSQwPXqzQPQWL3WLF0Xv
   g==;
X-CSE-ConnectionGUID: oM1bKoA4TZSRrc5+v2iETg==
X-CSE-MsgGUID: AoR4IsWEQrWEyZ1dt5iR8w==
X-IronPort-AV: E=McAfee;i="6600,9927,11088"; a="31117099"
X-IronPort-AV: E=Sophos;i="6.08,202,1712646000"; 
   d="scan'208";a="31117099"
Received: from fmviesa007.fm.intel.com ([10.60.135.147])
  by orvoesa102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 May 2024 14:07:32 -0700
X-CSE-ConnectionGUID: TBuSU5QmR4iDpXNLIfWUrw==
X-CSE-MsgGUID: Fk+FJpEHQyW2zG8hSUlwng==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.08,202,1712646000"; 
   d="scan'208";a="35874420"
Received: from hding1-mobl.ccr.corp.intel.com (HELO rpedgeco-desk4.intel.com) ([10.209.19.65])
  by fmviesa007-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 May 2024 14:07:32 -0700
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
Subject: [PATCH v2 05/15] KVM: x86/mmu: Make kvm_tdp_mmu_alloc_root() return void
Date: Thu, 30 May 2024 14:07:04 -0700
Message-Id: <20240530210714.364118-6-rick.p.edgecombe@intel.com>
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

The kvm_tdp_mmu_alloc_root() function currently always returns 0. This
allows for the caller, mmu_alloc_direct_roots(), to call
kvm_tdp_mmu_alloc_root() and also return 0 in one line:
   return kvm_tdp_mmu_alloc_root(vcpu);

So it is useful even though the return value of kvm_tdp_mmu_alloc_root()
is always the same. However, in future changes, kvm_tdp_mmu_alloc_root()
will be called twice in mmu_alloc_direct_roots(). This will force the
first call to either awkwardly handle the return value that will always
be zero or ignore it. So change kvm_tdp_mmu_alloc_root() to return void.
Do it in a separate change so the future change will be cleaner.

Signed-off-by: Rick Edgecombe <rick.p.edgecombe@intel.com>
---
TDX MMU Prep:
 - New patch
---
 arch/x86/kvm/mmu/mmu.c     | 6 ++++--
 arch/x86/kvm/mmu/tdp_mmu.c | 3 +--
 arch/x86/kvm/mmu/tdp_mmu.h | 2 +-
 3 files changed, 6 insertions(+), 5 deletions(-)

diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index 5070ba7c6e89..12178945922f 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -3700,8 +3700,10 @@ static int mmu_alloc_direct_roots(struct kvm_vcpu *vcpu)
 	unsigned i;
 	int r;
 
-	if (tdp_mmu_enabled)
-		return kvm_tdp_mmu_alloc_root(vcpu);
+	if (tdp_mmu_enabled) {
+		kvm_tdp_mmu_alloc_root(vcpu);
+		return 0;
+	}
 
 	write_lock(&vcpu->kvm->mmu_lock);
 	r = make_mmu_pages_available(vcpu);
diff --git a/arch/x86/kvm/mmu/tdp_mmu.c b/arch/x86/kvm/mmu/tdp_mmu.c
index e7cd4921afe7..2770230a5636 100644
--- a/arch/x86/kvm/mmu/tdp_mmu.c
+++ b/arch/x86/kvm/mmu/tdp_mmu.c
@@ -224,7 +224,7 @@ static void tdp_mmu_init_child_sp(struct kvm_mmu_page *child_sp,
 	tdp_mmu_init_sp(child_sp, iter->sptep, iter->gfn, role);
 }
 
-int kvm_tdp_mmu_alloc_root(struct kvm_vcpu *vcpu)
+void kvm_tdp_mmu_alloc_root(struct kvm_vcpu *vcpu)
 {
 	struct kvm_mmu *mmu = vcpu->arch.mmu;
 	union kvm_mmu_page_role role = mmu->root_role;
@@ -285,7 +285,6 @@ int kvm_tdp_mmu_alloc_root(struct kvm_vcpu *vcpu)
 	 */
 	mmu->root.hpa = __pa(root->spt);
 	mmu->root.pgd = 0;
-	return 0;
 }
 
 static void handle_changed_spte(struct kvm *kvm, int as_id, gfn_t gfn,
diff --git a/arch/x86/kvm/mmu/tdp_mmu.h b/arch/x86/kvm/mmu/tdp_mmu.h
index 58b55e61bd33..437ddd4937a9 100644
--- a/arch/x86/kvm/mmu/tdp_mmu.h
+++ b/arch/x86/kvm/mmu/tdp_mmu.h
@@ -10,7 +10,7 @@
 void kvm_mmu_init_tdp_mmu(struct kvm *kvm);
 void kvm_mmu_uninit_tdp_mmu(struct kvm *kvm);
 
-int kvm_tdp_mmu_alloc_root(struct kvm_vcpu *vcpu);
+void kvm_tdp_mmu_alloc_root(struct kvm_vcpu *vcpu);
 
 __must_check static inline bool kvm_tdp_mmu_get_root(struct kvm_mmu_page *root)
 {
-- 
2.34.1


