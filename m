Return-Path: <kvm+bounces-28671-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id C5CF299B1C0
	for <lists+kvm@lfdr.de>; Sat, 12 Oct 2024 09:40:43 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 682A7282F1A
	for <lists+kvm@lfdr.de>; Sat, 12 Oct 2024 07:40:42 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6EE6C146019;
	Sat, 12 Oct 2024 07:40:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Bj/fusb0"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F406713B2B4;
	Sat, 12 Oct 2024 07:40:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728718818; cv=none; b=uVS21FqmqhJKe6CpEpuSoRJbYyPjmkPsVABJtwekRqSV4ZD5HbPBegLThNm804yNK4eIVzSdn3vA3dddgmcqEblpNMeYQ8eE69GsCEB9p3z57SOnkl1h/9INWv6oVyBjlVvBIXbReyrdWvx0oSZU/pXyePlKMLNRm4nVM1d3Dys=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728718818; c=relaxed/simple;
	bh=YT/k7Gq6sCJdO/+1YBvX//XsRVZLHffpk8V8WB4Uev4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=EVRPWzbZzbq9UsEY6Uhn9bJUWsQI97rllndzI/hHFGi6fq5cacDVSmupsn+Ci13UTTsnhJVAfls8rITZb+bDT+zpBVuU+vQqmxf4BUnCusUpce8Bn1NPmKhZBvQybGIHqDKXXy6m9r8DsFCpie2iJlMJh/+cDU+gZjDufEjD0UE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=Bj/fusb0; arc=none smtp.client-ip=198.175.65.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1728718817; x=1760254817;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=YT/k7Gq6sCJdO/+1YBvX//XsRVZLHffpk8V8WB4Uev4=;
  b=Bj/fusb0C7e/14c3/tih22sg5/fwgoGLVTBS3L8yCdtEsynaif4eH6WF
   /OX6zEP0SQmA3E5OIX1meclFGmpGT6itYFdAVqX5P2/KW46UEOMlU8x4x
   gESo9dw2TcNqygFcFgBBcWEJfWGhWuakpNuh9j0zyy1CQJxZ3HWbhg+3D
   f76rrL4kmiTi33aRgwTikCRfIORIu2m7vCGzcPgvof5Uix6gCbBoOVL67
   eRUiy90Go4xN4+jkqDTuUp6lnd82S0DDr7cUdz/ayurTJ3nKe6gqJyNzC
   /kuyYa7aSOLbEWv9LqLTCfZTjOSSpzAZJR9GL+1G2V9+aie1VH1l7U5Hf
   w==;
X-CSE-ConnectionGUID: exQ1vcZ3TUGjbtDOaaEuug==
X-CSE-MsgGUID: U4DZROqITlmfmDCoDpPyXw==
X-IronPort-AV: E=McAfee;i="6700,10204,11222"; a="28221677"
X-IronPort-AV: E=Sophos;i="6.11,198,1725346800"; 
   d="scan'208";a="28221677"
Received: from orviesa008.jf.intel.com ([10.64.159.148])
  by orvoesa108.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Oct 2024 00:40:15 -0700
X-CSE-ConnectionGUID: 6J5XRNh7QzG6Is5w/WFPHA==
X-CSE-MsgGUID: hIHpHFHKTsmxF07sFpYmLw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.11,198,1725346800"; 
   d="scan'208";a="77930916"
Received: from ls.amr.corp.intel.com (HELO localhost) ([172.25.112.54])
  by orviesa008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Oct 2024 00:40:14 -0700
From: Isaku Yamahata <isaku.yamahata@intel.com>
To: kvm@vger.kernel.org,
	pbonzini@redhat.com
Cc: Sean Christopherson <seanjc@google.com>,
	sagis@google.com,
	chao.gao@intel.com,
	isaku.yamahata@intel.com,
	rick.p.edgecombe@intel.com,
	yan.y.zhao@intel.com,
	linux-kernel@vger.kernel.org,
	isaku.yamahata@gmail.com
Subject: [PATCH v2 1/2] KVM: x86/tdp_mmu: Add WARN_ON_ONCE() in tdp_mmu_map_handle_target_level()
Date: Sat, 12 Oct 2024 00:39:55 -0700
Message-ID: <c20d70acf5f5b0db5f52d6e163bb49f1235182f4.1728718232.git.isaku.yamahata@intel.com>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <cover.1728718232.git.isaku.yamahata@intel.com>
References: <cover.1728718232.git.isaku.yamahata@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Add WARN_ON_ONCE() in tdp_mmu_map_handle_target_level() to check SPTE
validity made by make_spte() suggested at [1].

The possible SPTE change at present leaf is,
- Non leaf => leaf (large page).
- Read fault (SPTE doesn't have write permission) => write fault.
  Hardening permission, write protect for example, goes through zapping.
- Access tracking when AD bits aren't supported.
- AD bit change.  This should be removed when make_spte() is fixed [1].

[1] https://lore.kernel.org/kvm/ZuOCXarfAwPjYj19@google.com/
  One idea would be to WARN and skip setting the SPTE in
  tdp_mmu_map_handle_target_level().  I.e. WARN and ignore 1=>0 transitions
  for Writable and Dirty bits, and then drop the TLB flush (assuming the
  above patch lands).

Suggested-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
---
v2:
- Split out into an independent patch to make common TDP MMU logic. (Sean)
---
 arch/x86/kvm/mmu/spte.h    | 11 +++++++++++
 arch/x86/kvm/mmu/tdp_mmu.c | 14 +++++++++++++-
 2 files changed, 24 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kvm/mmu/spte.h b/arch/x86/kvm/mmu/spte.h
index a72f0e3bde17..85fd99c92960 100644
--- a/arch/x86/kvm/mmu/spte.h
+++ b/arch/x86/kvm/mmu/spte.h
@@ -214,6 +214,17 @@ extern u64 __read_mostly shadow_nonpresent_or_rsvd_mask;
  */
 #define FROZEN_SPTE	(SHADOW_NONPRESENT_VALUE | 0x5a0ULL)
 
+#define AD_SPTE_IGNORE_CHANGE_MASK				\
+	(PT_WRITABLE_MASK |                                     \
+	 shadow_host_writable_mask | shadow_mmu_writable_mask | \
+	 shadow_dirty_mask | shadow_accessed_mask)
+
+#define  ACCESS_TRACK_SPTE_IGNORE_CHANGE_MASK	\
+	(AD_SPTE_IGNORE_CHANGE_MASK |		\
+	 shadow_acc_track_mask |		\
+	 (SHADOW_ACC_TRACK_SAVED_BITS_MASK <<	\
+	  SHADOW_ACC_TRACK_SAVED_BITS_SHIFT))
+
 /* Removed SPTEs must not be misconstrued as shadow present PTEs. */
 static_assert(!(FROZEN_SPTE & SPTE_MMU_PRESENT_MASK));
 
diff --git a/arch/x86/kvm/mmu/tdp_mmu.c b/arch/x86/kvm/mmu/tdp_mmu.c
index 37b3769a5d32..1da3df517522 100644
--- a/arch/x86/kvm/mmu/tdp_mmu.c
+++ b/arch/x86/kvm/mmu/tdp_mmu.c
@@ -1186,11 +1186,23 @@ static int tdp_mmu_map_handle_target_level(struct kvm_vcpu *vcpu,
 
 	if (unlikely(!fault->slot))
 		new_spte = make_mmio_spte(vcpu, iter->gfn, ACC_ALL);
-	else
+	else {
 		wrprot = make_spte(vcpu, sp, fault->slot, ACC_ALL, iter->gfn,
 					 fault->pfn, iter->old_spte, fault->prefetch, true,
 					 fault->map_writable, &new_spte);
 
+		WARN_ON_ONCE(kvm_ad_enabled() &&
+			     is_shadow_present_pte(iter->old_spte) &&
+			     is_large_pte(iter->old_spte) == is_large_pte(new_spte) &&
+			     ~AD_SPTE_IGNORE_CHANGE_MASK &
+			     (iter->old_spte ^ new_spte));
+		WARN_ON_ONCE(!kvm_ad_enabled() &&
+			     is_shadow_present_pte(iter->old_spte) &&
+			     is_large_pte(iter->old_spte) == is_large_pte(new_spte) &&
+			     ~ACCESS_TRACK_SPTE_IGNORE_CHANGE_MASK &
+			     (iter->old_spte ^ new_spte));
+	}
+
 	if (new_spte == iter->old_spte)
 		ret = RET_PF_SPURIOUS;
 	else if (tdp_mmu_set_spte_atomic(vcpu->kvm, iter, new_spte))
-- 
2.45.2


