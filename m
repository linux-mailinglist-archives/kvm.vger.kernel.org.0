Return-Path: <kvm+bounces-31565-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 042539C4F95
	for <lists+kvm@lfdr.de>; Tue, 12 Nov 2024 08:38:36 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id B5EA4281FE8
	for <lists+kvm@lfdr.de>; Tue, 12 Nov 2024 07:38:34 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 015EF20C022;
	Tue, 12 Nov 2024 07:37:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="WV+tQhiO"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7443C20A5FB;
	Tue, 12 Nov 2024 07:37:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.19
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731397051; cv=none; b=urayIIOixAaXAw6CogDrW8fzm5ciNFMToyivdGlXcX0lpuyF6u7XzYb/Br4j5IDQVNGRENHB+NFnUOpmH/fmOvgcJFgPSm/VxAn/2YiKlydp+KQ0N3P2pRqHC89xIagNF78IEwrarBh6TxWsPyXxYpAAa/WYflwA71qwBXuzanY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731397051; c=relaxed/simple;
	bh=czVlomoh24KL+gMFZIleuMzZnXotvPsIaQAUtpIa1oE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SLToCsSs4JbFt/w08fupPhAMS7TDbM/CjiDKGdxNoWE+D8aQMNzS7p0tjPNRIByZCR6kCQN+87m0HFxK6fUptT1xrJue9ZRW6d8hx5+oS2M7Na4K7ZSth+OFE7Xdc9QTvnWCLoFxydjR/c5rtGnZjQ/cNuOJwyruKCmgtW26wcA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=WV+tQhiO; arc=none smtp.client-ip=192.198.163.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1731397049; x=1762933049;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=czVlomoh24KL+gMFZIleuMzZnXotvPsIaQAUtpIa1oE=;
  b=WV+tQhiODcjPUxVn2XJG0qqVDUOJk4XXUinJmr9cJob6vnkd0FnfZ5S5
   5bvuJTmZvXY5XQvU5Kg9WqJySRzWUXszMwMiLZm4UHQltYXwXG2wPp7Kg
   /xGbe5zPRWpfCXr8qnJIIGkkxh8IrTIybFoN1xqQjYbVZow3cZsbRCGps
   X/XJp1jFqG2Cg0v9dZN2eRW9PzC8prC4j4qyjtXth23hb+D7fVQuWeThR
   HitR6dgcnx3kPM0YdEv7t6QaUrrf6N+jwB7GlrdYHNG/puxtyK36R0sc9
   x/3qecV4J4rLVb3gXNgn6NlLp3bQEjsVBkVAQbwKavD+ipHEZW3RW/k7z
   w==;
X-CSE-ConnectionGUID: UZIf8EhGQO2jdXcjjqWLJg==
X-CSE-MsgGUID: 7GkXf/jXQKKZ5tvL/cyJng==
X-IronPort-AV: E=McAfee;i="6700,10204,11253"; a="30616010"
X-IronPort-AV: E=Sophos;i="6.12,147,1728975600"; 
   d="scan'208";a="30616010"
Received: from orviesa004.jf.intel.com ([10.64.159.144])
  by fmvoesa113.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Nov 2024 23:37:28 -0800
X-CSE-ConnectionGUID: SVh5p95lQ8qwGhbtZoy0oA==
X-CSE-MsgGUID: RW8Yj9ERT+yWAUYH1Ru8Zw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.12,147,1728975600"; 
   d="scan'208";a="92416795"
Received: from yzhao56-desk.sh.intel.com ([10.239.159.62])
  by orviesa004-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Nov 2024 23:37:24 -0800
From: Yan Zhao <yan.y.zhao@intel.com>
To: pbonzini@redhat.com,
	seanjc@google.com,
	kvm@vger.kernel.org,
	dave.hansen@linux.intel.com
Cc: rick.p.edgecombe@intel.com,
	kai.huang@intel.com,
	adrian.hunter@intel.com,
	reinette.chatre@intel.com,
	xiaoyao.li@intel.com,
	tony.lindgren@intel.com,
	binbin.wu@linux.intel.com,
	dmatlack@google.com,
	isaku.yamahata@intel.com,
	isaku.yamahata@gmail.com,
	nik.borisov@suse.com,
	linux-kernel@vger.kernel.org,
	x86@kernel.org
Subject: [PATCH v2 02/24] KVM: x86/tdp_mmu: Add a helper function to walk down the TDP MMU
Date: Tue, 12 Nov 2024 15:34:57 +0800
Message-ID: <20241112073457.22011-1-yan.y.zhao@intel.com>
X-Mailer: git-send-email 2.43.2
In-Reply-To: <20241112073327.21979-1-yan.y.zhao@intel.com>
References: <20241112073327.21979-1-yan.y.zhao@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Isaku Yamahata <isaku.yamahata@intel.com>

Export a function to walk down the TDP without modifying it and simply
check if a GPA is mapped.

Future changes will support pre-populating TDX private memory. In order to
implement this KVM will need to check if a given GFN is already
pre-populated in the mirrored EPT. [1]

There is already a TDP MMU walker, kvm_tdp_mmu_get_walk() for use within
the KVM MMU that almost does what is required. However, to make sense of
the results, MMU internal PTE helpers are needed. Refactor the code to
provide a helper that can be used outside of the KVM MMU code.

Refactoring the KVM page fault handler to support this lookup usage was
also considered, but it was an awkward fit.

kvm_tdp_mmu_gpa_is_mapped() is based on a diff by Paolo Bonzini.

Link: https://lore.kernel.org/kvm/ZfBkle1eZFfjPI8l@google.com/ [1]
Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
Co-developed-by: Rick Edgecombe <rick.p.edgecombe@intel.com>
Signed-off-by: Rick Edgecombe <rick.p.edgecombe@intel.com>
Signed-off-by: Yan Zhao <yan.y.zhao@intel.com>
Reviewed-by: Paolo Bonzini <pbonzini@redhat.com>
---
TDX MMU part 2 v2:
- Added Paolo's rb

TDX MMU part 2 v1:
 - Change exported function to just return of GPA is mapped because "You
   are executing with the filemap_invalidate_lock() taken, and therefore
   cannot race with kvm_gmem_punch_hole()" (Paolo)
   https://lore.kernel.org/kvm/CABgObfbpNN842noAe77WYvgi5MzK2SAA_FYw-=fGa+PcT_Z22w@mail.gmail.com/
 - Take root hpa instead of enum (Paolo)

TDX MMU Prep v2:
 - Rename function with "mirror" and use root enum

TDX MMU Prep:
 - New patch
---
 arch/x86/kvm/mmu.h         |  3 +++
 arch/x86/kvm/mmu/mmu.c     |  3 +--
 arch/x86/kvm/mmu/tdp_mmu.c | 37 ++++++++++++++++++++++++++++++++-----
 3 files changed, 36 insertions(+), 7 deletions(-)

diff --git a/arch/x86/kvm/mmu.h b/arch/x86/kvm/mmu.h
index 0fa86e47e9f3..398b6b06ed73 100644
--- a/arch/x86/kvm/mmu.h
+++ b/arch/x86/kvm/mmu.h
@@ -252,6 +252,9 @@ extern bool tdp_mmu_enabled;
 #define tdp_mmu_enabled false
 #endif
 
+bool kvm_tdp_mmu_gpa_is_mapped(struct kvm_vcpu *vcpu, u64 gpa);
+int kvm_tdp_map_page(struct kvm_vcpu *vcpu, gpa_t gpa, u64 error_code, u8 *level);
+
 static inline bool kvm_memslots_have_rmaps(struct kvm *kvm)
 {
 	return !tdp_mmu_enabled || kvm_shadow_root_allocated(kvm);
diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index 68bb78a2306c..3a338df541c1 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -4743,8 +4743,7 @@ int kvm_tdp_page_fault(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault)
 	return direct_page_fault(vcpu, fault);
 }
 
-static int kvm_tdp_map_page(struct kvm_vcpu *vcpu, gpa_t gpa, u64 error_code,
-			    u8 *level)
+int kvm_tdp_map_page(struct kvm_vcpu *vcpu, gpa_t gpa, u64 error_code, u8 *level)
 {
 	int r;
 
diff --git a/arch/x86/kvm/mmu/tdp_mmu.c b/arch/x86/kvm/mmu/tdp_mmu.c
index d7d60116672b..b0e1c4cb3004 100644
--- a/arch/x86/kvm/mmu/tdp_mmu.c
+++ b/arch/x86/kvm/mmu/tdp_mmu.c
@@ -1898,16 +1898,13 @@ bool kvm_tdp_mmu_write_protect_gfn(struct kvm *kvm,
  *
  * Must be called between kvm_tdp_mmu_walk_lockless_{begin,end}.
  */
-int kvm_tdp_mmu_get_walk(struct kvm_vcpu *vcpu, u64 addr, u64 *sptes,
-			 int *root_level)
+static int __kvm_tdp_mmu_get_walk(struct kvm_vcpu *vcpu, u64 addr, u64 *sptes,
+				  struct kvm_mmu_page *root)
 {
-	struct kvm_mmu_page *root = root_to_sp(vcpu->arch.mmu->root.hpa);
 	struct tdp_iter iter;
 	gfn_t gfn = addr >> PAGE_SHIFT;
 	int leaf = -1;
 
-	*root_level = vcpu->arch.mmu->root_role.level;
-
 	tdp_mmu_for_each_pte(iter, vcpu->kvm, root, gfn, gfn + 1) {
 		leaf = iter.level;
 		sptes[leaf] = iter.old_spte;
@@ -1916,6 +1913,36 @@ int kvm_tdp_mmu_get_walk(struct kvm_vcpu *vcpu, u64 addr, u64 *sptes,
 	return leaf;
 }
 
+int kvm_tdp_mmu_get_walk(struct kvm_vcpu *vcpu, u64 addr, u64 *sptes,
+			 int *root_level)
+{
+	struct kvm_mmu_page *root = root_to_sp(vcpu->arch.mmu->root.hpa);
+	*root_level = vcpu->arch.mmu->root_role.level;
+
+	return __kvm_tdp_mmu_get_walk(vcpu, addr, sptes, root);
+}
+
+bool kvm_tdp_mmu_gpa_is_mapped(struct kvm_vcpu *vcpu, u64 gpa)
+{
+	struct kvm *kvm = vcpu->kvm;
+	bool is_direct = kvm_is_addr_direct(kvm, gpa);
+	hpa_t root = is_direct ? vcpu->arch.mmu->root.hpa :
+				 vcpu->arch.mmu->mirror_root_hpa;
+	u64 sptes[PT64_ROOT_MAX_LEVEL + 1], spte;
+	int leaf;
+
+	lockdep_assert_held(&kvm->mmu_lock);
+	rcu_read_lock();
+	leaf = __kvm_tdp_mmu_get_walk(vcpu, gpa, sptes, root_to_sp(root));
+	rcu_read_unlock();
+	if (leaf < 0)
+		return false;
+
+	spte = sptes[leaf];
+	return is_shadow_present_pte(spte) && is_last_spte(spte, leaf);
+}
+EXPORT_SYMBOL_GPL(kvm_tdp_mmu_gpa_is_mapped);
+
 /*
  * Returns the last level spte pointer of the shadow page walk for the given
  * gpa, and sets *spte to the spte value. This spte may be non-preset. If no
-- 
2.43.2


