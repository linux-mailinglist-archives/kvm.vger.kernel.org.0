Return-Path: <kvm+bounces-21578-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 3EC7F93026C
	for <lists+kvm@lfdr.de>; Sat, 13 Jul 2024 01:35:19 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id E80321F228DA
	for <lists+kvm@lfdr.de>; Fri, 12 Jul 2024 23:35:18 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 49490130A54;
	Fri, 12 Jul 2024 23:35:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="NssGijJK"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6C8B061FE0
	for <kvm@vger.kernel.org>; Fri, 12 Jul 2024 23:35:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.19
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720827311; cv=none; b=MzJ055OUZHks5dJh4AZrZcZPeQoL+1xyBx8vFVgBMp5zzVKwT0Xw3dwvpJ4MyW8ns07OG462NgPHLdBxupl5xrOvGNWr3H760EI78YaY2NjZSUofgk875xno8dr3xiJabjgQWoAWMAl+W5BwY4JuRaZzdk79iNpIqQX+qiRuAjE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720827311; c=relaxed/simple;
	bh=b30gVvTGVTTQuLv8c6HGD6Z8yxeAfSxZoivLJIsWuk0=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=ePH5aVnFqKxfGzVg9bZdAuu3Dp4MkxdhdVN+t9JXbsVyuWWGyeLtA2ae2UEvt1kswoWixlYwh3elo+mucm1a3tF0K8lgA3Qsn3yT5ATwsnFd35c7SNPSKlQyZW6vbmbtcyP8JcqzeSMQ8XqLNS7L5QBCjIlaKlzbU4BGVWV1bco=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=NssGijJK; arc=none smtp.client-ip=198.175.65.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1720827309; x=1752363309;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=b30gVvTGVTTQuLv8c6HGD6Z8yxeAfSxZoivLJIsWuk0=;
  b=NssGijJK9cbodKLeVON732cKmcMM7NHGOSc5ZnG+imYxesmeba5g84TO
   Ycysro+rygOu35JhPZ9bZBfAw4BoVYIyK1mQfKzyftP9C3RB7aFy7RipI
   z9szjyQeDtKFkiaMDsai4/hVEwD8pHIL7V8fyZ15uWX0Z+y6oIs02bwbT
   t6Yk6shRF0fXTfknRBEJLbacGYDD+1QtzF8PYPK7mRW+xH/sz86i+UbQh
   vS51jf8FEq03Azq1v5Ilue9eKd8AbJV7l4jWtmPemk85Xif6eL9ZhxtZo
   ecJVlmhTl+nTKOqCe7G/H2wmuF5Ok3hdsVVaBf+UtgoWY4vS8gToCdoWQ
   w==;
X-CSE-ConnectionGUID: BoJrBaJiSlyLL81mJqbJXw==
X-CSE-MsgGUID: Jlmz60MiTL2xnIAXFaRALw==
X-IronPort-AV: E=McAfee;i="6700,10204,11131"; a="18131989"
X-IronPort-AV: E=Sophos;i="6.09,204,1716274800"; 
   d="scan'208";a="18131989"
Received: from fmviesa007.fm.intel.com ([10.60.135.147])
  by orvoesa111.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Jul 2024 16:35:08 -0700
X-CSE-ConnectionGUID: hoEVDJs9Q2GHxswrubkViQ==
X-CSE-MsgGUID: 2HpxmSs/QPC2lwF3DVMulQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.09,204,1716274800"; 
   d="scan'208";a="48941071"
Received: from inaky-mobl1.amr.corp.intel.com (HELO rpedgeco-desk4..) ([10.125.110.163])
  by fmviesa007-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Jul 2024 16:35:08 -0700
From: Rick Edgecombe <rick.p.edgecombe@intel.com>
To: seanjc@google.com,
	pbonzini@redhat.com,
	kvm@vger.kernel.org
Cc: yan.y.zhao@intel.com,
	rick.p.edgecombe@intel.com
Subject: [PATCH] fixup! KVM: x86/tdp_mmu: Rename REMOVED_SPTE to FROZEN_SPTE
Date: Fri, 12 Jul 2024 16:34:38 -0700
Message-Id: <20240712233438.518591-1-rick.p.edgecombe@intel.com>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Yan Zhao <yan.y.zhao@intel.com>

Fixing the missed Removed/REMOVED.

Signed-off-by: Yan Zhao <yan.y.zhao@intel.com>
Signed-off-by: Rick Edgecombe <rick.p.edgecombe@intel.com>
---
Hi Paolo,

I saw kvm-coco-queue got re-arranged and thought we better send this one
out ahead of the rest. It seems the target of this fixup patch is now
merged from some branch not in the public git. Hopefully, it's not too
difficult to squash.

Since these are just fixes for not too problematically wrong comments
(given that removed is currently the only use of frozen), we could also
instead do them in another patch later if you prefer.

It is based on the HEAD of the latest kvm-coco-queue, but also applies
cleanly to eb162c941c0b (Merge branch 'kvm-tdx-prep-1-truncated' into
HEAD).

Thanks,

Rick
---
 arch/x86/kvm/mmu/spte.c    | 6 +++---
 arch/x86/kvm/mmu/spte.h    | 2 +-
 arch/x86/kvm/mmu/tdp_mmu.c | 8 ++++----
 3 files changed, 8 insertions(+), 8 deletions(-)

diff --git a/arch/x86/kvm/mmu/spte.c b/arch/x86/kvm/mmu/spte.c
index 59cac37615b6..5b8f005dac64 100644
--- a/arch/x86/kvm/mmu/spte.c
+++ b/arch/x86/kvm/mmu/spte.c
@@ -377,9 +377,9 @@ void kvm_mmu_set_mmio_spte_mask(u64 mmio_value, u64 mmio_mask, u64 access_mask)
 		mmio_value = 0;
 
 	/*
-	 * The masked MMIO value must obviously match itself and a removed SPTE
-	 * must not get a false positive.  Removed SPTEs and MMIO SPTEs should
-	 * never collide as MMIO must set some RWX bits, and removed SPTEs must
+	 * The masked MMIO value must obviously match itself and a frozen SPTE
+	 * must not get a false positive.  Frozen SPTEs and MMIO SPTEs should
+	 * never collide as MMIO must set some RWX bits, and frozen SPTEs must
 	 * not set any RWX bits.
 	 */
 	if (WARN_ON((mmio_value & mmio_mask) != mmio_value) ||
diff --git a/arch/x86/kvm/mmu/spte.h b/arch/x86/kvm/mmu/spte.h
index a72f0e3bde17..47c06f86c1af 100644
--- a/arch/x86/kvm/mmu/spte.h
+++ b/arch/x86/kvm/mmu/spte.h
@@ -214,7 +214,7 @@ extern u64 __read_mostly shadow_nonpresent_or_rsvd_mask;
  */
 #define FROZEN_SPTE	(SHADOW_NONPRESENT_VALUE | 0x5a0ULL)
 
-/* Removed SPTEs must not be misconstrued as shadow present PTEs. */
+/* Frozen SPTEs must not be misconstrued as shadow present PTEs. */
 static_assert(!(FROZEN_SPTE & SPTE_MMU_PRESENT_MASK));
 
 static inline bool is_frozen_spte(u64 spte)
diff --git a/arch/x86/kvm/mmu/tdp_mmu.c b/arch/x86/kvm/mmu/tdp_mmu.c
index 2abe65226a57..6f88d6b47555 100644
--- a/arch/x86/kvm/mmu/tdp_mmu.c
+++ b/arch/x86/kvm/mmu/tdp_mmu.c
@@ -400,10 +400,10 @@ static void handle_removed_pt(struct kvm *kvm, tdp_ptep_t pt, bool shared)
 			/*
 			 * Set the SPTE to a nonpresent value that other
 			 * threads will not overwrite. If the SPTE was
-			 * already marked as removed then another thread
+			 * already marked as frozen then another thread
 			 * handling a page fault could overwrite it, so
 			 * set the SPTE until it is set from some other
-			 * value to the removed SPTE value.
+			 * value to the frozen SPTE value.
 			 */
 			for (;;) {
 				old_spte = kvm_tdp_mmu_write_spte_atomic(sptep, FROZEN_SPTE);
@@ -648,8 +648,8 @@ static inline int __must_check __tdp_mmu_set_spte_atomic(struct kvm *kvm,
 	u64 *sptep = rcu_dereference(iter->sptep);
 
 	/*
-	 * The caller is responsible for ensuring the old SPTE is not a REMOVED
-	 * SPTE.  KVM should never attempt to zap or manipulate a REMOVED SPTE,
+	 * The caller is responsible for ensuring the old SPTE is not a FROZEN
+	 * SPTE.  KVM should never attempt to zap or manipulate a FROZEN SPTE,
 	 * and pre-checking before inserting a new SPTE is advantageous as it
 	 * avoids unnecessary work.
 	 */
-- 
2.34.1


