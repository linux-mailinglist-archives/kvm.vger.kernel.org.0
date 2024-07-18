Return-Path: <kvm+bounces-21888-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 7ADE89352FB
	for <lists+kvm@lfdr.de>; Thu, 18 Jul 2024 23:14:22 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id AC9DB1C211CF
	for <lists+kvm@lfdr.de>; Thu, 18 Jul 2024 21:14:21 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1983B147C98;
	Thu, 18 Jul 2024 21:12:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Z7G6/40T"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.15])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B511B146D51;
	Thu, 18 Jul 2024 21:12:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.15
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721337170; cv=none; b=e1vvADlajaDi53pyA7xvt2xqF9u8u0bLdvmATg97uurrjZmFi2F9vEsxdHjuO/Jk0EAsSxAl09Q5wLzYuQ9/ccb5n46UKusNz2Ug1J2HNcUsjd2Wt3YDgPY3bJ0oeYGlc71GW3n107pp08+7oi2rh6dzMupMVT/F9iaaCv/qaFs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721337170; c=relaxed/simple;
	bh=5NadTCqiMWDnFtXY+jGIgYvx41nj3b0uLCzChii5Rj8=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=WW00BlDBokAbvQ7daWjxr1tan6hDeovjR2ZYaYD0XmtiFX0CTMt97BaYHdO44Z0CzuLfEIdjdW5In6vYHiGV/VdvRMB6uBsRNqfneFhPnJ+6M4tCai+UfpQKP+1EEF4rpQAO8bQygzvQBJSF2041vfS9JhBF0F05vmKMFoJ0yMY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=Z7G6/40T; arc=none smtp.client-ip=198.175.65.15
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1721337168; x=1752873168;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=5NadTCqiMWDnFtXY+jGIgYvx41nj3b0uLCzChii5Rj8=;
  b=Z7G6/40TV02Md3rpgoxB1OQGOXCiwlvJIZKCJ01hI55WtPGVw7qEqxIF
   81KdE+sPA8ojGZwiR+oWRmKa7Bgjtc/Uh54iUV/x0218wn+8GTkU41dmr
   93AlDU5M0cfMRwCWy+5L6oXwT5wdv7q2Jcm6BdPCzcxOeGzEy1yntD+QB
   HOMD/Y4/PpKjMfma7HAPVan4crA/T9ZMD/3nvWG9brpYetK2vwZXKcaEp
   cqLQWFzFAxz0bb7DfAp0K7oqbh/A9ZA7mkSyUvtp2kPnru63m08hJuMZt
   IDkFxiT60fdfAQ7sjB8Y11C+WwwNxA6dHHjxvrV8NESB/y1QGaHuO1MK5
   A==;
X-CSE-ConnectionGUID: /d4yyoZyRU+pInHBaUVqpA==
X-CSE-MsgGUID: xyYRkNBgSpm7t1JGKuBypQ==
X-IronPort-AV: E=McAfee;i="6700,10204,11137"; a="22697416"
X-IronPort-AV: E=Sophos;i="6.09,218,1716274800"; 
   d="scan'208";a="22697416"
Received: from orviesa003.jf.intel.com ([10.64.159.143])
  by orvoesa107.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Jul 2024 14:12:44 -0700
X-CSE-ConnectionGUID: lrQCgITwTuuV0OjLTWQLfw==
X-CSE-MsgGUID: OUmGSwmATBG0kdfWnQHhcA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.09,218,1716274800"; 
   d="scan'208";a="55760384"
Received: from ccbilbre-mobl3.amr.corp.intel.com (HELO rpedgeco-desk4..) ([10.124.223.76])
  by ORVIESA003-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Jul 2024 14:12:44 -0700
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
Subject: [PATCH v4 06/18] KVM: x86/mmu: Make kvm_tdp_mmu_alloc_root() return void
Date: Thu, 18 Jul 2024 14:12:18 -0700
Message-Id: <20240718211230.1492011-7-rick.p.edgecombe@intel.com>
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
Reviewed-by: Paolo Bonzini <pbonzini@redhat.com>
---
v3:
 - Add Paolo's reviewed-by

v1:
 - New patch
---
 arch/x86/kvm/mmu/mmu.c     | 6 ++++--
 arch/x86/kvm/mmu/tdp_mmu.c | 3 +--
 arch/x86/kvm/mmu/tdp_mmu.h | 2 +-
 3 files changed, 6 insertions(+), 5 deletions(-)

diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index 50ba7f63a067..2f7f372a4bfe 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -3703,8 +3703,10 @@ static int mmu_alloc_direct_roots(struct kvm_vcpu *vcpu)
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
index 2d09c353e4bc..f4df20b91817 100644
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
index 14421d080fe6..a0e00284b75d 100644
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


