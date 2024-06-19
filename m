Return-Path: <kvm+bounces-20027-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id AAE1790F925
	for <lists+kvm@lfdr.de>; Thu, 20 Jun 2024 00:40:27 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 575501F22482
	for <lists+kvm@lfdr.de>; Wed, 19 Jun 2024 22:40:27 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4505D1741E5;
	Wed, 19 Jun 2024 22:36:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="LyR0JExx"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 93EDA1662F0;
	Wed, 19 Jun 2024 22:36:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718836593; cv=none; b=s0twCo+I/UR+jTBcdNq9GPfyrL0N/6RSy1CQZe4wQRl8FN0FWf4XaEmQ+3qwGwUYIH7XuXr7ZklKVdVV6wy7fo0KGJzGFpeKPcFOtOGf1BHyFO8qv7JjTGltva9Wvmdvg+t2YqP6iK6o8mSCmEiGkfgqKne/vel7ZPUj1Kvz2Sw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718836593; c=relaxed/simple;
	bh=9j4VFn1eGwXgbBvfyH5uFmdbNPqNr34zzJ/r5P5TDOs=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=IgUU81K0+mfHtevn/lNn1M+d0FoVvMM3/dL0DtMQKGioIW2xRnpdS6GxWgtiJUql74GUYSY1q8DNM8+aZjW1fjr4IzF2l+rfuvfDwBtvB/08e1CJ3mkbSeYtWwhAYCQv+/5AwcQ8G7sUhv2Yuqdi+tP+d96Ttn8fs74dPnmwK7E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=LyR0JExx; arc=none smtp.client-ip=198.175.65.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1718836591; x=1750372591;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=9j4VFn1eGwXgbBvfyH5uFmdbNPqNr34zzJ/r5P5TDOs=;
  b=LyR0JExxRac8LxU88eQ/BBun71BurbVImqQvj6NXGd3S1cHl4gpjCDQY
   4lA9C6HrjuET45Y4kRxAM3NXvIzAiI+9zzsGKjK9+NjQNt8O0RlBTXSsX
   6T8ixSpS/rww9lJu4ESZN38pcFkyA4pTfvkPKBWHakGZelDSvZToMYJRL
   h4FjLuuz8a5V6x3GB8uGdATqNBvZ74sts0z8FBfyJMOqaoo2e0d1NZWVo
   t7ERvvj0C0b8OMhqNqr1YwU++3gNUr0JW/rwPAKpwMt5p+7kW9e6mVbC/
   5xXfqup/WOVuxJgwmCtupYk/QeUtiG6Nh5s1eLtcd/oMfC71gE+CtZFii
   g==;
X-CSE-ConnectionGUID: cDjtVetcQjODLejyRQOQJA==
X-CSE-MsgGUID: eOzy5BasQEqVsc3FvplO8A==
X-IronPort-AV: E=McAfee;i="6700,10204,11108"; a="15931980"
X-IronPort-AV: E=Sophos;i="6.08,251,1712646000"; 
   d="scan'208";a="15931980"
Received: from orviesa002.jf.intel.com ([10.64.159.142])
  by orvoesa110.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Jun 2024 15:36:23 -0700
X-CSE-ConnectionGUID: Dsp3EQeSS2yjrqEtmYjVjg==
X-CSE-MsgGUID: DBdN5H7zRQeGPtKTrtE5tg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.08,251,1712646000"; 
   d="scan'208";a="72793359"
Received: from ivsilic-mobl2.amr.corp.intel.com (HELO rpedgeco-desk4.intel.com) ([10.209.54.39])
  by orviesa002-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Jun 2024 15:36:23 -0700
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
Subject: [PATCH v3 12/17] KVM: x86/tdp_mmu: Take root in tdp_mmu_for_each_pte()
Date: Wed, 19 Jun 2024 15:36:09 -0700
Message-Id: <20240619223614.290657-13-rick.p.edgecombe@intel.com>
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

Take the root as an argument of tdp_mmu_for_each_pte() instead of looking
it up in the mmu. With no other purpose of passing the mmu, drop it.

Future changes will want to change which root is used based on the context
of the MMU operation. So change the callers to pass in the root currently
used, mmu->root.hpa in a preparatory patch to make the later one smaller
and easier to review.

Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
Signed-off-by: Rick Edgecombe <rick.p.edgecombe@intel.com>
---
TDX MMU Prep v3:
 - Split from "KVM: x86/mmu: Support GFN direct mask" (Paolo)
---
 arch/x86/kvm/mmu/tdp_mmu.c | 16 ++++++++--------
 1 file changed, 8 insertions(+), 8 deletions(-)

diff --git a/arch/x86/kvm/mmu/tdp_mmu.c b/arch/x86/kvm/mmu/tdp_mmu.c
index c8e5e779967e..2200bdc7681f 100644
--- a/arch/x86/kvm/mmu/tdp_mmu.c
+++ b/arch/x86/kvm/mmu/tdp_mmu.c
@@ -693,8 +693,8 @@ static inline void tdp_mmu_iter_set_spte(struct kvm *kvm, struct tdp_iter *iter,
 			continue;					\
 		else
 
-#define tdp_mmu_for_each_pte(_iter, _kvm, _mmu, _start, _end)		\
-	for_each_tdp_pte(_iter, _kvm, root_to_sp(_mmu->root.hpa), _start, _end)
+#define tdp_mmu_for_each_pte(_iter, _kvm, _root, _start, _end)	\
+	for_each_tdp_pte(_iter, _kvm, _root, _start, _end)
 
 /*
  * Yield if the MMU lock is contended or this thread needs to return control
@@ -1113,8 +1113,8 @@ static int tdp_mmu_split_huge_page(struct kvm *kvm, struct tdp_iter *iter,
  */
 int kvm_tdp_mmu_map(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault)
 {
-	struct kvm_mmu *mmu = vcpu->arch.mmu;
 	struct kvm *kvm = vcpu->kvm;
+	struct kvm_mmu_page *root = root_to_sp(vcpu->arch.mmu->root.hpa);
 	struct tdp_iter iter;
 	struct kvm_mmu_page *sp;
 	int ret = RET_PF_RETRY;
@@ -1125,7 +1125,7 @@ int kvm_tdp_mmu_map(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault)
 
 	rcu_read_lock();
 
-	tdp_mmu_for_each_pte(iter, kvm, mmu, fault->gfn, fault->gfn + 1) {
+	tdp_mmu_for_each_pte(iter, kvm, root, fault->gfn, fault->gfn + 1) {
 		int r;
 
 		if (fault->nx_huge_page_workaround_enabled)
@@ -1784,14 +1784,14 @@ bool kvm_tdp_mmu_write_protect_gfn(struct kvm *kvm,
 int kvm_tdp_mmu_get_walk(struct kvm_vcpu *vcpu, u64 addr, u64 *sptes,
 			 int *root_level)
 {
+	struct kvm_mmu_page *root = root_to_sp(vcpu->arch.mmu->root.hpa);
 	struct tdp_iter iter;
-	struct kvm_mmu *mmu = vcpu->arch.mmu;
 	gfn_t gfn = addr >> PAGE_SHIFT;
 	int leaf = -1;
 
 	*root_level = vcpu->arch.mmu->root_role.level;
 
-	tdp_mmu_for_each_pte(iter, vcpu->kvm, mmu, gfn, gfn + 1) {
+	tdp_mmu_for_each_pte(iter, vcpu->kvm, root, gfn, gfn + 1) {
 		leaf = iter.level;
 		sptes[leaf] = iter.old_spte;
 	}
@@ -1813,11 +1813,11 @@ int kvm_tdp_mmu_get_walk(struct kvm_vcpu *vcpu, u64 addr, u64 *sptes,
 u64 *kvm_tdp_mmu_fast_pf_get_last_sptep(struct kvm_vcpu *vcpu, gfn_t gfn,
 					u64 *spte)
 {
+	struct kvm_mmu_page *root = root_to_sp(vcpu->arch.mmu->root.hpa);
 	struct tdp_iter iter;
-	struct kvm_mmu *mmu = vcpu->arch.mmu;
 	tdp_ptep_t sptep = NULL;
 
-	tdp_mmu_for_each_pte(iter, vcpu->kvm, mmu, gfn, gfn + 1) {
+	tdp_mmu_for_each_pte(iter, vcpu->kvm, root, gfn, gfn + 1) {
 		*spte = iter.old_spte;
 		sptep = iter.sptep;
 	}
-- 
2.34.1


