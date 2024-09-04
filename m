Return-Path: <kvm+bounces-25811-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id DD75C96AEFA
	for <lists+kvm@lfdr.de>; Wed,  4 Sep 2024 05:15:41 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 8C910286555
	for <lists+kvm@lfdr.de>; Wed,  4 Sep 2024 03:15:40 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9CDBF770E4;
	Wed,  4 Sep 2024 03:14:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Uip2eje8"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3419C47796;
	Wed,  4 Sep 2024 03:14:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725419674; cv=none; b=u4m4LOLQZVMijtrtoJiybv7JRCLn9J36am0UGgVBeLRLBO3isw2lShOXF4gxfuANH5x4kk6ygcHo6QLz1qx7eK118roxm8oyZNoCAnTXKKY4LBBuf1axzPDYAVYfPifE6zZFI/uhMJXrsbwplDrBbvpUvyFFUVfHpo72Q7a+FMc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725419674; c=relaxed/simple;
	bh=cTe8OOkqYquI2I1s891XT0thE+RLb9ytTyB9PBl4YMY=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=gquMYzP85Htep7Lt2lxbOKDVtbvNLTqMI3kz8/uE+Oz1TdICvI5ZtifqnnsPU6uarEmrOlqpsIHxcjcuM/FKQm/XnmmNxL7zDObPHzAl0BHhJex0Mc+gMPsPWUJtqB3bXwyItfUiJ3aGGI3HQzaTOD9oEXg3sxgCmN0uye/4Ouc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=Uip2eje8; arc=none smtp.client-ip=192.198.163.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1725419672; x=1756955672;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=cTe8OOkqYquI2I1s891XT0thE+RLb9ytTyB9PBl4YMY=;
  b=Uip2eje8LX28B8KNpndVfzZ751AslrSX0LdOzg9ZDAYqY80wZo+deQ+G
   dr5zjd9AtvFafstzYP0N4yNkzbBYG8p1wDDA+jTIyxn+VNtev1x0Ervqx
   AdIMpB3bTfQ38tK8bXLc21Y5uRA0ujmByTK+bBOuW9XaIVVMn2U95QBrg
   LjNzxiQWoMc/R4QAvYDYc3aXKSpkYMdjps1RQgg+5MLI2i+KPFKAgMLHw
   YcdEhcu79sXm+rF73GICNJiuwXCt0kxy87pVwrhsvLGKl09JNu5b6IJgL
   nzQxzbT5GoBAIO6cG6YjZOO+idzuO8tO+Kmqja2miFfMaQ06vAqeCz9rm
   g==;
X-CSE-ConnectionGUID: dy9R9gKTTi2yOBAgJdws2g==
X-CSE-MsgGUID: SzoLDgY2RN2xo6Y9sk+E7Q==
X-IronPort-AV: E=McAfee;i="6700,10204,11184"; a="23564629"
X-IronPort-AV: E=Sophos;i="6.10,200,1719903600"; 
   d="scan'208";a="23564629"
Received: from orviesa009.jf.intel.com ([10.64.159.149])
  by fmvoesa112.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Sep 2024 20:07:59 -0700
X-CSE-ConnectionGUID: RATggeyJTZ235pnag5nl4Q==
X-CSE-MsgGUID: WbwoMKdZQAW/bOOyvvJ7ZA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.10,200,1719903600"; 
   d="scan'208";a="65106218"
Received: from dgramcko-desk.amr.corp.intel.com (HELO rpedgeco-desk4..) ([10.124.221.153])
  by orviesa009-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Sep 2024 20:07:58 -0700
From: Rick Edgecombe <rick.p.edgecombe@intel.com>
To: seanjc@google.com,
	pbonzini@redhat.com,
	kvm@vger.kernel.org
Cc: kai.huang@intel.com,
	dmatlack@google.com,
	isaku.yamahata@gmail.com,
	yan.y.zhao@intel.com,
	nik.borisov@suse.com,
	rick.p.edgecombe@intel.com,
	linux-kernel@vger.kernel.org
Subject: [PATCH 02/21] KVM: x86/tdp_mmu: Add a helper function to walk down the TDP MMU
Date: Tue,  3 Sep 2024 20:07:32 -0700
Message-Id: <20240904030751.117579-3-rick.p.edgecombe@intel.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20240904030751.117579-1-rick.p.edgecombe@intel.com>
References: <20240904030751.117579-1-rick.p.edgecombe@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Isaku Yamahata <isaku.yamahata@intel.com>

Export a function to walk down the TDP without modifying it and simply
check if a PGA is mapped.

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
---
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
index 8f289222b353..5faa416ac874 100644
--- a/arch/x86/kvm/mmu.h
+++ b/arch/x86/kvm/mmu.h
@@ -254,6 +254,9 @@ extern bool tdp_mmu_enabled;
 #define tdp_mmu_enabled false
 #endif
 
+bool kvm_tdp_mmu_gpa_is_mapped(struct kvm_vcpu *vcpu, u64 gpa);
+int kvm_tdp_map_page(struct kvm_vcpu *vcpu, gpa_t gpa, u64 error_code, u8 *level);
+
 static inline bool kvm_memslots_have_rmaps(struct kvm *kvm)
 {
 	return !tdp_mmu_enabled || kvm_shadow_root_allocated(kvm);
diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index 7e66d7c426c1..01808cdf8627 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -4713,8 +4713,7 @@ int kvm_tdp_page_fault(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault)
 	return direct_page_fault(vcpu, fault);
 }
 
-static int kvm_tdp_map_page(struct kvm_vcpu *vcpu, gpa_t gpa, u64 error_code,
-			    u8 *level)
+int kvm_tdp_map_page(struct kvm_vcpu *vcpu, gpa_t gpa, u64 error_code, u8 *level)
 {
 	int r;
 
diff --git a/arch/x86/kvm/mmu/tdp_mmu.c b/arch/x86/kvm/mmu/tdp_mmu.c
index 37b3769a5d32..019b43723d90 100644
--- a/arch/x86/kvm/mmu/tdp_mmu.c
+++ b/arch/x86/kvm/mmu/tdp_mmu.c
@@ -1911,16 +1911,13 @@ bool kvm_tdp_mmu_write_protect_gfn(struct kvm *kvm,
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
@@ -1929,6 +1926,36 @@ int kvm_tdp_mmu_get_walk(struct kvm_vcpu *vcpu, u64 addr, u64 *sptes,
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
2.34.1


