Return-Path: <kvm+bounces-10661-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 6616C86E742
	for <lists+kvm@lfdr.de>; Fri,  1 Mar 2024 18:31:06 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id B4AFAB2D10A
	for <lists+kvm@lfdr.de>; Fri,  1 Mar 2024 17:30:38 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D8F5A282F7;
	Fri,  1 Mar 2024 17:29:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Y30lMCQs"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.13])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BF76FC8E1;
	Fri,  1 Mar 2024 17:29:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.13
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709314187; cv=none; b=M6btWXGYTKCaUMuurdCqt6O+PI7vW5rDYtP2cHg0NYI+dkTHAJa17dtDykbr0nMxKLRNUlSBzkvqwwu2bT12q4FDh2MyE+Pgnuk/Kdvq505wottWj+zbOIrd2RS+9Q5/Lz5/qwR7xcy2gNJV/MqpJD3M0Mbj6aRySPsdGARY7Ps=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709314187; c=relaxed/simple;
	bh=y+3G5VwEI5knod2LBHcytheyiy4/iGNmorazZWFPAdo=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=eF/x3qTH46B9jbn2583jDbcZdXinRTzpqna/BELIr4iL6uG4BE8Q+6zxVzEfiI3ISbTcFwXSBUCWEFEJBcEW/i78vS5Hx0MSgK8XmR5RDiNs/b29fGEdwC5NGC2e28/sdCEDufGj3PxTr8ENlPqjJz1JdJyAQ7kPlXjiMErjtwE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=Y30lMCQs; arc=none smtp.client-ip=192.198.163.13
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1709314185; x=1740850185;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=y+3G5VwEI5knod2LBHcytheyiy4/iGNmorazZWFPAdo=;
  b=Y30lMCQsS9pdnnabuPZXE01IpHSgyn7gCWl4RUtKnFbRNSh4qy0IqB7a
   df01n+4KuUFlZA8GWkxR6jz19I0csEGpmxk8chHTf8j2NKs8TgjutCTJk
   o8+6LnziGZVvEFpQhd26+IsFTPYaKOaCIMJj45+FuCSj/WSwOD9MnP1pL
   8lBIGFG1rfnXOEZoJlTLPGlHhhRBDf7op50jLCq+Ej5CA8bXUEV1kg4nB
   i5UYrhjD1b27ilVffZ9WhkTbpidaC1Y1E1RZtF8i93aI7s/FP6JSIR5V/
   Tamn/hP+ZcrhS/JfdgsGZWkzf8w/F4EsUMb8vjnLFaCOQpB/URAKoQEyo
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,11000"; a="6812397"
X-IronPort-AV: E=Sophos;i="6.06,196,1705392000"; 
   d="scan'208";a="6812397"
Received: from orviesa003.jf.intel.com ([10.64.159.143])
  by fmvoesa107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Mar 2024 09:29:24 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.06,196,1705392000"; 
   d="scan'208";a="12946546"
Received: from ls.sc.intel.com (HELO localhost) ([172.25.112.31])
  by ORVIESA003-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Mar 2024 09:29:24 -0800
From: isaku.yamahata@intel.com
To: kvm@vger.kernel.org
Cc: isaku.yamahata@intel.com,
	isaku.yamahata@gmail.com,
	linux-kernel@vger.kernel.org,
	Sean Christopherson <seanjc@google.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Michael Roth <michael.roth@amd.com>,
	David Matlack <dmatlack@google.com>,
	Federico Parola <federico.parola@polito.it>
Subject: [RFC PATCH 3/8] KVM: x86/mmu: Introduce initialier macro for struct kvm_page_fault
Date: Fri,  1 Mar 2024 09:28:45 -0800
Message-Id: <b045dc17abd4f1330406964528ade5722ab63aa1.1709288671.git.isaku.yamahata@intel.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <cover.1709288671.git.isaku.yamahata@intel.com>
References: <cover.1709288671.git.isaku.yamahata@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Isaku Yamahata <isaku.yamahata@intel.com>

Another function will initialize struct kvm_page_fault.  Add initializer
macro to unify the big struct initialization.

No functional change intended.

Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
---
 arch/x86/kvm/mmu/mmu_internal.h | 44 +++++++++++++++++++--------------
 1 file changed, 26 insertions(+), 18 deletions(-)

diff --git a/arch/x86/kvm/mmu/mmu_internal.h b/arch/x86/kvm/mmu/mmu_internal.h
index 0669a8a668ca..72ef09fc9322 100644
--- a/arch/x86/kvm/mmu/mmu_internal.h
+++ b/arch/x86/kvm/mmu/mmu_internal.h
@@ -279,27 +279,35 @@ enum {
 	RET_PF_SPURIOUS,
 };
 
+#define KVM_PAGE_FAULT_INIT(_vcpu, _cr2_or_gpa, _err, _prefetch, _max_level) {	\
+	.addr = (_cr2_or_gpa),							\
+	.error_code = (_err),							\
+	.exec = (_err) & PFERR_FETCH_MASK,					\
+	.write = (_err) & PFERR_WRITE_MASK,					\
+	.present = (_err) & PFERR_PRESENT_MASK,					\
+	.rsvd = (_err) & PFERR_RSVD_MASK,					\
+	.user = (_err) & PFERR_USER_MASK,					\
+	.prefetch = (_prefetch),						\
+	.is_tdp =								\
+	likely((_vcpu)->arch.mmu->page_fault == kvm_tdp_page_fault),		\
+	.nx_huge_page_workaround_enabled =					\
+	is_nx_huge_page_enabled((_vcpu)->kvm),					\
+										\
+	.max_level = (_max_level),						\
+	.req_level = PG_LEVEL_4K,						\
+	.goal_level = PG_LEVEL_4K,						\
+	.is_private =								\
+	kvm_mem_is_private((_vcpu)->kvm, (_cr2_or_gpa) >> PAGE_SHIFT),		\
+										\
+	.pfn = KVM_PFN_ERR_FAULT,						\
+	.hva = KVM_HVA_ERR_BAD, }
+
 static inline int kvm_mmu_do_page_fault(struct kvm_vcpu *vcpu, gpa_t cr2_or_gpa,
 					u32 err, bool prefetch, int *emulation_type)
 {
-	struct kvm_page_fault fault = {
-		.addr = cr2_or_gpa,
-		.error_code = err,
-		.exec = err & PFERR_FETCH_MASK,
-		.write = err & PFERR_WRITE_MASK,
-		.present = err & PFERR_PRESENT_MASK,
-		.rsvd = err & PFERR_RSVD_MASK,
-		.user = err & PFERR_USER_MASK,
-		.prefetch = prefetch,
-		.is_tdp = likely(vcpu->arch.mmu->page_fault == kvm_tdp_page_fault),
-		.nx_huge_page_workaround_enabled =
-			is_nx_huge_page_enabled(vcpu->kvm),
-
-		.max_level = KVM_MAX_HUGEPAGE_LEVEL,
-		.req_level = PG_LEVEL_4K,
-		.goal_level = PG_LEVEL_4K,
-		.is_private = kvm_mem_is_private(vcpu->kvm, cr2_or_gpa >> PAGE_SHIFT),
-	};
+	struct kvm_page_fault fault = KVM_PAGE_FAULT_INIT(vcpu, cr2_or_gpa, err,
+							  prefetch,
+							  KVM_MAX_HUGEPAGE_LEVEL);
 	int r;
 
 	if (vcpu->arch.mmu->root_role.direct) {
-- 
2.25.1


