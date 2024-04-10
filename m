Return-Path: <kvm+bounces-14159-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id C7C498A02DC
	for <lists+kvm@lfdr.de>; Thu, 11 Apr 2024 00:08:38 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id DE3D71C22296
	for <lists+kvm@lfdr.de>; Wed, 10 Apr 2024 22:08:37 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D61A3190695;
	Wed, 10 Apr 2024 22:07:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="FdjO+Psj"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.17])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6CD6218410C;
	Wed, 10 Apr 2024 22:07:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.17
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712786878; cv=none; b=E2jvCW9jsSOEVoK23QVVFxgpVCm8uErKQW8RduqqPLF/uxg6P/dTNfumIemRbN3Op5Ax8VHdA3YkPXuwkBzPbb9Q18ifUg8NPbcyPIm17bII+F6lCwLeLg0IKTiHYPLSIUxSWeHyAo5TJWhnc+/nMmTdRc+FSdC4rtPUOrDBEV8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712786878; c=relaxed/simple;
	bh=AJ9A7wEL2oUuSn9GN771f2P12p85yWpOqELXl0aB/hM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=C7uJQirZXdJkDK+7hOVfQY/XXotGnRzViQpkLA/kjHw9YsseQ7JgvtJxFIB1l7xLByEhDtmZ7IhWsUPHY8A1YITXjDhxE1+WxNMh9h5xVlby/HO3zJ+5VqHqI6PvC0dPXukzw1qfXpEDC2xGmpxQSkCxETBbCjYnwfCoiMW/Wtk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=FdjO+Psj; arc=none smtp.client-ip=192.198.163.17
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1712786877; x=1744322877;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=AJ9A7wEL2oUuSn9GN771f2P12p85yWpOqELXl0aB/hM=;
  b=FdjO+PsjnFYOUy2M065IBBGUu6LFwiabuMxGNxpHyYnhKE/7ttI6gptp
   wy/VFErgxztdrlGLNVIrri00aKEWzQHS8v1/AnBR835H3uaFHwk/10LWl
   XK/zx2FfL+P07M+AJ2Eu3okh8yl0STZnfF/TL+k0Q2FhP0xbw9Xy4664W
   xDMxXLYNATLDmyOOANMYrvl/FR86+a+ynpyh/wNn+z9o6LGl6jpBvCI6m
   iumP94wXW5hAbWSqbgDuqupZPzcQnifXPtvvjc8XwYPmr+7GPBu7Tm5dW
   eSO0mWRWB3nUppglLncLFDO6Pt7PIiJQSsFgrM2zIAwC7nUItLzd5NVOK
   w==;
X-CSE-ConnectionGUID: aCDDcJYsQpmJUyhbUH2vrA==
X-CSE-MsgGUID: HEPUGIYCQVaqMI5w/hAckQ==
X-IronPort-AV: E=McAfee;i="6600,9927,11039"; a="8041117"
X-IronPort-AV: E=Sophos;i="6.07,191,1708416000"; 
   d="scan'208";a="8041117"
Received: from orviesa005.jf.intel.com ([10.64.159.145])
  by fmvoesa111.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Apr 2024 15:07:54 -0700
X-CSE-ConnectionGUID: 7VklZRaVRj6+btQbbxDMog==
X-CSE-MsgGUID: 0ig66S/pR9yDuZQ5DVz9Gw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.07,191,1708416000"; 
   d="scan'208";a="25476305"
Received: from ls.sc.intel.com (HELO localhost) ([172.25.112.31])
  by orviesa005-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Apr 2024 15:07:54 -0700
From: isaku.yamahata@intel.com
To: kvm@vger.kernel.org
Cc: isaku.yamahata@intel.com,
	isaku.yamahata@gmail.com,
	linux-kernel@vger.kernel.org,
	Sean Christopherson <seanjc@google.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Michael Roth <michael.roth@amd.com>,
	David Matlack <dmatlack@google.com>,
	Federico Parola <federico.parola@polito.it>,
	Kai Huang <kai.huang@intel.com>
Subject: [PATCH v2 03/10] KVM: x86/mmu: Extract __kvm_mmu_do_page_fault()
Date: Wed, 10 Apr 2024 15:07:29 -0700
Message-ID: <ddf1d98420f562707b11e12c416cce8fdb986bb1.1712785629.git.isaku.yamahata@intel.com>
X-Mailer: git-send-email 2.43.2
In-Reply-To: <cover.1712785629.git.isaku.yamahata@intel.com>
References: <cover.1712785629.git.isaku.yamahata@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Isaku Yamahata <isaku.yamahata@intel.com>

Extract out __kvm_mmu_do_page_fault() from kvm_mmu_do_page_fault().  The
inner function is to initialize struct kvm_page_fault and to call the fault
handler, and the outer function handles updating stats and converting
return code.  KVM_MAP_MEMORY will call the KVM page fault handler.

This patch makes the emulation_type always set irrelevant to the return
code.  kvm_mmu_page_fault() is the only caller of kvm_mmu_do_page_fault(),
and references the value only when PF_RET_EMULATE is returned.  Therefore,
this adjustment doesn't affect functionality.

No functional change intended.

Suggested-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
---
v2:
- Newly introduced. (Sean)
---
 arch/x86/kvm/mmu/mmu_internal.h | 32 +++++++++++++++++++++-----------
 1 file changed, 21 insertions(+), 11 deletions(-)

diff --git a/arch/x86/kvm/mmu/mmu_internal.h b/arch/x86/kvm/mmu/mmu_internal.h
index e68a60974cf4..9baae6c223ee 100644
--- a/arch/x86/kvm/mmu/mmu_internal.h
+++ b/arch/x86/kvm/mmu/mmu_internal.h
@@ -287,8 +287,8 @@ static inline void kvm_mmu_prepare_memory_fault_exit(struct kvm_vcpu *vcpu,
 				      fault->is_private);
 }
 
-static inline int kvm_mmu_do_page_fault(struct kvm_vcpu *vcpu, gpa_t cr2_or_gpa,
-					u64 err, bool prefetch, int *emulation_type)
+static inline int __kvm_mmu_do_page_fault(struct kvm_vcpu *vcpu, gpa_t cr2_or_gpa,
+					  u64 err, bool prefetch, int *emulation_type)
 {
 	struct kvm_page_fault fault = {
 		.addr = cr2_or_gpa,
@@ -318,14 +318,6 @@ static inline int kvm_mmu_do_page_fault(struct kvm_vcpu *vcpu, gpa_t cr2_or_gpa,
 		fault.slot = kvm_vcpu_gfn_to_memslot(vcpu, fault.gfn);
 	}
 
-	/*
-	 * Async #PF "faults", a.k.a. prefetch faults, are not faults from the
-	 * guest perspective and have already been counted at the time of the
-	 * original fault.
-	 */
-	if (!prefetch)
-		vcpu->stat.pf_taken++;
-
 	if (IS_ENABLED(CONFIG_MITIGATION_RETPOLINE) && fault.is_tdp)
 		r = kvm_tdp_page_fault(vcpu, &fault);
 	else
@@ -333,12 +325,30 @@ static inline int kvm_mmu_do_page_fault(struct kvm_vcpu *vcpu, gpa_t cr2_or_gpa,
 
 	if (r == RET_PF_EMULATE && fault.is_private) {
 		kvm_mmu_prepare_memory_fault_exit(vcpu, &fault);
-		return -EFAULT;
+		r = -EFAULT;
 	}
 
 	if (fault.write_fault_to_shadow_pgtable && emulation_type)
 		*emulation_type |= EMULTYPE_WRITE_PF_TO_SP;
 
+	return r;
+}
+
+static inline int kvm_mmu_do_page_fault(struct kvm_vcpu *vcpu, gpa_t cr2_or_gpa,
+					u64 err, bool prefetch, int *emulation_type)
+{
+	int r;
+
+	/*
+	 * Async #PF "faults", a.k.a. prefetch faults, are not faults from the
+	 * guest perspective and have already been counted at the time of the
+	 * original fault.
+	 */
+	if (!prefetch)
+		vcpu->stat.pf_taken++;
+
+	r = __kvm_mmu_do_page_fault(vcpu, cr2_or_gpa, err, prefetch, emulation_type);
+
 	/*
 	 * Similar to above, prefetch faults aren't truly spurious, and the
 	 * async #PF path doesn't do emulation.  Do count faults that are fixed
-- 
2.43.2


