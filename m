Return-Path: <kvm+bounces-30457-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 19A6E9BAE69
	for <lists+kvm@lfdr.de>; Mon,  4 Nov 2024 09:45:08 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id C66911F22B49
	for <lists+kvm@lfdr.de>; Mon,  4 Nov 2024 08:45:07 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0F4401AB507;
	Mon,  4 Nov 2024 08:44:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="fjeKMbNh"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B2C7718BC21;
	Mon,  4 Nov 2024 08:44:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730709897; cv=none; b=k04oOyWCor4zgaYWaJs0Qdswsc5XT580nJXCAodHSmNnL2LDikRA1cBkbiDtdx8pjK637YgdEqqH/sDKciV0xoPbI0upcEdX9S9SSPmXJ8UElx2n6LiUgHLbHXl1Flmlroyf03u6zw5t9VqewikyuttGjssL/ZrVJJ8IfftRKmY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730709897; c=relaxed/simple;
	bh=WXe+1g9hJjbnrumUeVMcn94TiAct027Qwd/gvVK+69s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=luIZ5gyZMUQNXtq7htI8wsIDrSWJqcA3B6pR4DGXS7aG9buZwiKeSxM6GOMdIglvk8LiJs0oQJOhnf8gsQ9hWDfBabOYy0PgNXy9afmwiD3ShtMyrf5Gi1Mki5rEEQ8NttWTlllHqHlcM8RpDTrqqKHGQr1DNeszfnTfhCRyYHQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=fjeKMbNh; arc=none smtp.client-ip=198.175.65.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1730709895; x=1762245895;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=WXe+1g9hJjbnrumUeVMcn94TiAct027Qwd/gvVK+69s=;
  b=fjeKMbNhd1OcwgEpY9BpbrGOVkKu/Y0RX3kOZiQ7QOUcB3VPXCoQS11a
   l1o+AG62BAWWU4Rug+v8Pszsb5NFmHBOOtaHa6hgmJed312K+UkmkQ3U4
   2v6lFSoaTfuEoYh+BoU0hkQ60udhFH9m7yFgveV9Xpz41M0fNN1+ySD25
   DqcGtVwS676WR8NV36m0qKqVKLYBYpNjOAf9qFBFhel7di3XUgJ7vokNf
   v+ToqGRKJwXu4oKy3W6UxOedp/6eKvtVlp6942bY/nFAZWRK6SPmuk5nz
   LmUD7NDfrwGp/c5PCq78SpWCIwg+jPNMskqwY9qVsR7agbdM/AXMWagr+
   A==;
X-CSE-ConnectionGUID: 11alLq4ISF+5GryHQe/xwQ==
X-CSE-MsgGUID: y7d/saQqQ7OZnupx3Ni9XA==
X-IronPort-AV: E=McAfee;i="6700,10204,11222"; a="40946474"
X-IronPort-AV: E=Sophos;i="6.11,199,1725346800"; 
   d="scan'208";a="40946474"
Received: from fmviesa010.fm.intel.com ([10.60.135.150])
  by orvoesa103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Nov 2024 00:44:55 -0800
X-CSE-ConnectionGUID: ygr69nuUQB21KWVr/PJ+Ig==
X-CSE-MsgGUID: DPVo+WaqQIqCFp5wUyLBBA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.11,256,1725346800"; 
   d="scan'208";a="83927932"
Received: from yzhao56-desk.sh.intel.com ([10.239.159.62])
  by fmviesa010-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Nov 2024 00:44:53 -0800
From: Yan Zhao <yan.y.zhao@intel.com>
To: pbonzini@redhat.com,
	seanjc@google.com
Cc: linux-kernel@vger.kernel.org,
	kvm@vger.kernel.org,
	Rick Edgecombe <rick.p.edgecombe@intel.com>,
	kernel test robot <lkp@intel.com>,
	Yan Zhao <yan.y.zhao@intel.com>
Subject: [PATCH 1/2] KVM: x86/tdp_mmu: Use rcu_dereference() to protect sptep for dereferencing
Date: Mon,  4 Nov 2024 16:42:29 +0800
Message-ID: <20241104084229.29882-1-yan.y.zhao@intel.com>
X-Mailer: git-send-email 2.43.2
In-Reply-To: <20241104084137.29855-1-yan.y.zhao@intel.com>
References: <20241104084137.29855-1-yan.y.zhao@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Rick Edgecombe <rick.p.edgecombe@intel.com>

Use rcu_dereference() to copy the RCU-protected pointer sptep into a local
variable for later dereferencing. This also checks that the dereferencing
occurs within the RCU read-side critical section.

Change is_mirror_sptep()'s input type from "u64 *" to "tdp_ptep_t" (typedef
as "u64 __rcu *") to centralize the call of rcu_dereference().

Opportunistically, since try_cmpxchg64() is now the only place in
__tdp_mmu_set_spte_atomic() that dereferences the local variable, move
the rcu_dereference() call closer to its point of use.

Reported-by: kernel test robot <lkp@intel.com>
Closes: https://lore.kernel.org/oe-kbuild-all/202410121644.Eq7zRGPO-lkp@intel.com
Co-developed-by: Yan Zhao <yan.y.zhao@intel.com>
Signed-off-by: Yan Zhao <yan.y.zhao@intel.com>
Signed-off-by: Rick Edgecombe <rick.p.edgecombe@intel.com>
---
 arch/x86/kvm/mmu/spte.h    | 4 ++--
 arch/x86/kvm/mmu/tdp_mmu.c | 6 +++---
 2 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/arch/x86/kvm/mmu/spte.h b/arch/x86/kvm/mmu/spte.h
index 8496a2abbde2..ef322f972948 100644
--- a/arch/x86/kvm/mmu/spte.h
+++ b/arch/x86/kvm/mmu/spte.h
@@ -267,9 +267,9 @@ static inline struct kvm_mmu_page *root_to_sp(hpa_t root)
 	return spte_to_child_sp(root);
 }
 
-static inline bool is_mirror_sptep(u64 *sptep)
+static inline bool is_mirror_sptep(tdp_ptep_t sptep)
 {
-	return is_mirror_sp(sptep_to_sp(sptep));
+	return is_mirror_sp(sptep_to_sp(rcu_dereference(sptep)));
 }
 
 static inline bool is_mmio_spte(struct kvm *kvm, u64 spte)
diff --git a/arch/x86/kvm/mmu/tdp_mmu.c b/arch/x86/kvm/mmu/tdp_mmu.c
index b0e1c4cb3004..2741b6587ec9 100644
--- a/arch/x86/kvm/mmu/tdp_mmu.c
+++ b/arch/x86/kvm/mmu/tdp_mmu.c
@@ -511,7 +511,7 @@ static int __must_check set_external_spte_present(struct kvm *kvm, tdp_ptep_t sp
 	 * page table has been modified. Use FROZEN_SPTE similar to
 	 * the zapping case.
 	 */
-	if (!try_cmpxchg64(sptep, &old_spte, FROZEN_SPTE))
+	if (!try_cmpxchg64(rcu_dereference(sptep), &old_spte, FROZEN_SPTE))
 		return -EBUSY;
 
 	/*
@@ -637,8 +637,6 @@ static inline int __must_check __tdp_mmu_set_spte_atomic(struct kvm *kvm,
 							 struct tdp_iter *iter,
 							 u64 new_spte)
 {
-	u64 *sptep = rcu_dereference(iter->sptep);
-
 	/*
 	 * The caller is responsible for ensuring the old SPTE is not a FROZEN
 	 * SPTE.  KVM should never attempt to zap or manipulate a FROZEN SPTE,
@@ -662,6 +660,8 @@ static inline int __must_check __tdp_mmu_set_spte_atomic(struct kvm *kvm,
 		if (ret)
 			return ret;
 	} else {
+		u64 *sptep = rcu_dereference(iter->sptep);
+
 		/*
 		 * Note, fast_pf_fix_direct_spte() can also modify TDP MMU SPTEs
 		 * and does not hold the mmu_lock.  On failure, i.e. if a
-- 
2.43.2


