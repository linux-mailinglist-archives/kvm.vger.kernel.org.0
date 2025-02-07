Return-Path: <kvm+bounces-37551-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 20016A2B97E
	for <lists+kvm@lfdr.de>; Fri,  7 Feb 2025 04:11:06 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id A4A117A3084
	for <lists+kvm@lfdr.de>; Fri,  7 Feb 2025 03:10:04 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A4D25187858;
	Fri,  7 Feb 2025 03:10:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Ho0Mvoof"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F10381624C5;
	Fri,  7 Feb 2025 03:10:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.19
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738897814; cv=none; b=Am5Ek7BIJNSy9LSy8SEjvovyNd60gW9r8S97vpk6WPvRjDFxl30uGHZ0RL/+/6bKSisHZCTtv2IZGHPozTelug5aIomrzw2qEbW6F4cltJp7VAePmAOLzO0KP5xwYuyazF3UEGtG6YgM4fG150PXv3nzjVCiCRHqT7amEEPlo14=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738897814; c=relaxed/simple;
	bh=HEjW7p9mYif0anOP9XOUbSqHykMLvVgQ2FWDqLTVVDU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cZ9qAbOLM7a/mzA9uLfn9zRDQlh7ne96ga7EiaH/E7EncfhFrYkCeAnPmIT7TCrn9Fg9KTjH9l02+ixBpYcVaanwv4xaiBPqnTyaazZWZbl4q4S71UBd+4Ke1BU8U/Oh92mKjajVTprhQESHwMvU0hoWO03zKplVW7TXRPfDgiU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=Ho0Mvoof; arc=none smtp.client-ip=192.198.163.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1738897813; x=1770433813;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=HEjW7p9mYif0anOP9XOUbSqHykMLvVgQ2FWDqLTVVDU=;
  b=Ho0MvoofxEWygBbtfhBxvsSc2d7qtw8qJwesItMgmoJ+MuD+al62VeDa
   PFdEg/TyWceJnxFhAW79w0FzVTApmxXv3H176yVwp3wbxctdE3DfIYn9R
   JDkyFoBPw0vIRWlUJG+4915GJ2R/NIca/wFg8wZ+LLMwW+iJYYv2qRdXg
   XYdrpsp0SFAAWza45kUudbsPZlzND4+3c43N5rxf2rO36+FZkxrbTrH3R
   DEV+TSRjblYDB2Fg1D1R71N/V6YPCmNCJTrs7Wa3PDc/VE4Tqg31TIM1/
   MK28b4u391/hPH7ZICzYJY182tGlRrIBFdP8LSQr2M8JpsPQuXaAqILdu
   Q==;
X-CSE-ConnectionGUID: d11pezsvQgmEgjpPaOo67g==
X-CSE-MsgGUID: oB3Of98kT0C8U/SxtOiUxg==
X-IronPort-AV: E=McAfee;i="6700,10204,11336"; a="38731403"
X-IronPort-AV: E=Sophos;i="6.13,266,1732608000"; 
   d="scan'208";a="38731403"
Received: from orviesa004.jf.intel.com ([10.64.159.144])
  by fmvoesa113.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Feb 2025 19:10:12 -0800
X-CSE-ConnectionGUID: DxVbil/NQYGzhRcuQ80jXA==
X-CSE-MsgGUID: Uy2YKcudSs65ART/GtG7IQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.13,266,1732608000"; 
   d="scan'208";a="116412063"
Received: from yzhao56-desk.sh.intel.com ([10.239.159.62])
  by orviesa004-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Feb 2025 19:10:08 -0800
From: Yan Zhao <yan.y.zhao@intel.com>
To: pbonzini@redhat.com,
	seanjc@google.com
Cc: rick.p.edgecombe@intel.com,
	linux-kernel@vger.kernel.org,
	kvm@vger.kernel.org,
	Yan Zhao <yan.y.zhao@intel.com>
Subject: [PATCH 3/4] KVM: x86/mmu: Make sure pfn is not changed for spurious fault
Date: Fri,  7 Feb 2025 11:09:00 +0800
Message-ID: <20250207030900.1808-1-yan.y.zhao@intel.com>
X-Mailer: git-send-email 2.43.2
In-Reply-To: <20250207030640.1585-1-yan.y.zhao@intel.com>
References: <20250207030640.1585-1-yan.y.zhao@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Make sure pfn is not changed for a spurious fault by warning in the TDP
MMU. For shadow path, only treat a prefetch fault as spurious when pfn is
not changed, since the rmap removal and add are required when pfn is
changed.

Cc: Sean Christopherson <seanjc@google.com>
Signed-off-by: Yan Zhao <yan.y.zhao@intel.com>
---
 arch/x86/kvm/mmu/mmu.c     | 3 ++-
 arch/x86/kvm/mmu/tdp_mmu.c | 3 ++-
 2 files changed, 4 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index 3d74e680006f..47fd3712afe6 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -2846,7 +2846,8 @@ static int mmu_set_spte(struct kvm_vcpu *vcpu, struct kvm_memory_slot *slot,
 	}
 
 	if (is_shadow_present_pte(*sptep)) {
-		if (prefetch && is_last_spte(*sptep, level))
+		if (prefetch && is_last_spte(*sptep, level) &&
+		    pfn == spte_to_pfn(*sptep))
 			return RET_PF_SPURIOUS;
 
 		/*
diff --git a/arch/x86/kvm/mmu/tdp_mmu.c b/arch/x86/kvm/mmu/tdp_mmu.c
index 5f9e7374220e..8b37e4f542f3 100644
--- a/arch/x86/kvm/mmu/tdp_mmu.c
+++ b/arch/x86/kvm/mmu/tdp_mmu.c
@@ -1139,7 +1139,8 @@ static int tdp_mmu_map_handle_target_level(struct kvm_vcpu *vcpu,
 
 	if (is_shadow_present_pte(iter->old_spte) &&
 	    is_access_allowed(fault, iter->old_spte) &&
-	    is_last_spte(iter->old_spte, iter->level))
+	    is_last_spte(iter->old_spte, iter->level) &&
+	    !WARN_ON_ONCE(fault->pfn != spte_to_pfn(iter->old_spte)))
 		return RET_PF_SPURIOUS;
 
 	if (unlikely(!fault->slot))
-- 
2.43.2


