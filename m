Return-Path: <kvm+bounces-41342-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 5C2ADA66530
	for <lists+kvm@lfdr.de>; Tue, 18 Mar 2025 02:35:41 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 3C8593A456A
	for <lists+kvm@lfdr.de>; Tue, 18 Mar 2025 01:35:28 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B5B7514D2BB;
	Tue, 18 Mar 2025 01:35:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="cODzODeD"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 633657DA95;
	Tue, 18 Mar 2025 01:35:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.19
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742261728; cv=none; b=u9kBgbbxjwGlcJnHvZowaDQggsRXdLWiUme/BV359tfaGioyByKHcTWsoT0h4CM+soc8hINjE00YOuMM+xaBxx2WQvHa4iLWHQmXogyYBvwlkGVPps/6zziGZPxrhBkebxzv3oKVsBMDHctJeGTJZ7E3yzAzFYbrKjEDMzJCRpg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742261728; c=relaxed/simple;
	bh=NwOAx5+dxnQzBsBey2xQSL2X0FYSBltO7FxvfjiIzGI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=amB4a7V7ODegivhzvLq2OkvGk1oYJnxcOZ1UZdf6qTazbMgRgw3ZFIMQpMi2EpbROMCt4zF0tdzc6V6woykdmlUgA7aqK9kX5NdVF8x7J5UeYoHd/YtB/yGSuZaXokUy2J05ynVMxFG+72RkqdiRCtvEVjUSQOZWoHubMaCJAQU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=cODzODeD; arc=none smtp.client-ip=192.198.163.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1742261727; x=1773797727;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=NwOAx5+dxnQzBsBey2xQSL2X0FYSBltO7FxvfjiIzGI=;
  b=cODzODeDdb4JJFbz9uIjAwovKd1P3a9FOIhTLAIt7fbZQdQvB9HSGPQ6
   vKG6BW/SVXK4jji+KZJno4Rq+MZSMBwZoCus4yb/ie/U+007+6+q52GCR
   qyxK+vPsALpeWG1UAviE1J4zokxcfBvzEJXKMdBjoSXXQ9PSiHg8rprBR
   2lLLTVbRDUpshw/i9WGSfzLtir5UjIiFURPS3lZjn43nfxMvwSe0wEWbR
   Bhk9rZx7prJy9gMUltwxJjPoChpFGKxMSaGaqyu70ORTZBQal2QEXyGDd
   rxuroRyC5AZdAASeQy9DPk47BgJMTZJZifDRlUxuK0h3R57yqHCJuWlBr
   A==;
X-CSE-ConnectionGUID: Uay7iiDdRXqOkB5RknVR2A==
X-CSE-MsgGUID: rlhHD+ehSuKYeVKnQaVFHg==
X-IronPort-AV: E=McAfee;i="6700,10204,11376"; a="42556046"
X-IronPort-AV: E=Sophos;i="6.14,255,1736841600"; 
   d="scan'208";a="42556046"
Received: from fmviesa008.fm.intel.com ([10.60.135.148])
  by fmvoesa113.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Mar 2025 18:35:27 -0700
X-CSE-ConnectionGUID: S/fEzu+6Q+im8JVS/vbgUA==
X-CSE-MsgGUID: RTb5KkJlSuS1fUqap6gR8Q==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.14,255,1736841600"; 
   d="scan'208";a="122284291"
Received: from yzhao56-desk.sh.intel.com ([10.239.159.62])
  by fmviesa008-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Mar 2025 18:33:00 -0700
From: Yan Zhao <yan.y.zhao@intel.com>
To: pbonzini@redhat.com,
	seanjc@google.com
Cc: linux-kernel@vger.kernel.org,
	kvm@vger.kernel.org,
	Yan Zhao <yan.y.zhao@intel.com>
Subject: [PATCH v2 1/5] KVM: x86/mmu: Further check old SPTE is leaf for spurious prefetch fault
Date: Tue, 18 Mar 2025 09:31:11 +0800
Message-ID: <20250318013111.5648-1-yan.y.zhao@intel.com>
X-Mailer: git-send-email 2.43.2
In-Reply-To: <20250318013038.5628-1-yan.y.zhao@intel.com>
References: <20250318013038.5628-1-yan.y.zhao@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Instead of simply treating a prefetch fault as spurious when there's a
shadow-present old SPTE, further check if the old SPTE is leaf to determine
if a prefetch fault is spurious.

It's not reasonable to treat a prefetch fault as spurious when there's a
shadow-present non-leaf SPTE without a corresponding shadow-present leaf
SPTE. e.g., in the following sequence, a prefetch fault should not be
considered spurious:
1. add a memslot with size 4K
2. prefault GPA A in the memslot
3. delete the memslot (zap all disabled)
4. re-add the memslot with size 2M
5. prefault GPA A again.
In step 5, the prefetch fault attempts to install a 2M huge entry.
Since step 3 zaps the leaf SPTE for GPA A while keeping the non-leaf SPTE,
the leaf entry will remain empty after step 5 if the fetch fault is
regarded as spurious due to a shadow-present non-leaf SPTE.

Signed-off-by: Yan Zhao <yan.y.zhao@intel.com>
---
 arch/x86/kvm/mmu/mmu.c     | 2 +-
 arch/x86/kvm/mmu/tdp_mmu.c | 3 ++-
 2 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index 8160870398b9..94c677f8cc05 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -2846,7 +2846,7 @@ static int mmu_set_spte(struct kvm_vcpu *vcpu, struct kvm_memory_slot *slot,
 	}
 
 	if (is_shadow_present_pte(*sptep)) {
-		if (prefetch)
+		if (prefetch && is_last_spte(*sptep, level))
 			return RET_PF_SPURIOUS;
 
 		/*
diff --git a/arch/x86/kvm/mmu/tdp_mmu.c b/arch/x86/kvm/mmu/tdp_mmu.c
index 046b6ba31197..ab65fd915ef2 100644
--- a/arch/x86/kvm/mmu/tdp_mmu.c
+++ b/arch/x86/kvm/mmu/tdp_mmu.c
@@ -1137,7 +1137,8 @@ static int tdp_mmu_map_handle_target_level(struct kvm_vcpu *vcpu,
 	if (WARN_ON_ONCE(sp->role.level != fault->goal_level))
 		return RET_PF_RETRY;
 
-	if (fault->prefetch && is_shadow_present_pte(iter->old_spte))
+	if (fault->prefetch && is_shadow_present_pte(iter->old_spte) &&
+	    is_last_spte(iter->old_spte, iter->level))
 		return RET_PF_SPURIOUS;
 
 	if (is_shadow_present_pte(iter->old_spte) &&
-- 
2.43.2


