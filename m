Return-Path: <kvm+bounces-21900-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 87C6893531A
	for <lists+kvm@lfdr.de>; Thu, 18 Jul 2024 23:17:49 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 3F2AD2833C4
	for <lists+kvm@lfdr.de>; Thu, 18 Jul 2024 21:17:48 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0F6F214B971;
	Thu, 18 Jul 2024 21:13:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="a5ogO27E"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.15])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 459E714A09E;
	Thu, 18 Jul 2024 21:12:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.15
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721337179; cv=none; b=rr/ZhLJWj/AycPR44qAMJFXnsqn1KpESfX96UpBJItWtHzXEWJMBz2WzoYmFFlc4IuzeQ80SlQ/oxPZUGq/UCEhpgc/4QArVNEV0HDZbQQ89/yl5TP/RSuk70xPfgGOZ4/dmOIM79Us2OSotkNKWGhfGKDLWfPVmmSslFKOwgW0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721337179; c=relaxed/simple;
	bh=NXIuTu49zOahyxCR2t7PbDM9QfUDq2d6bkMaQkdeb5Q=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=Yj3EH1QjTWCtTlwS1TJnZXUoKE0dE7sw6gVMtQGvy4qvI6PXAJmVJ/vfLUopHqu57Z4ORjgTHOeCqyFNlRhYC9KUvUSO6QZGW3srLK+UA8PjDDx+2wVrmti4i2PZLOAvxxEaPaV1aGdcPSwmcy+JgzQxzX+Dn06ImHiIUj14B4M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=a5ogO27E; arc=none smtp.client-ip=198.175.65.15
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1721337177; x=1752873177;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=NXIuTu49zOahyxCR2t7PbDM9QfUDq2d6bkMaQkdeb5Q=;
  b=a5ogO27EJXQz5CblWw7YHCFwL0ctMtnMJRHJyeL46mCzu72L+GBU0mZm
   hf0hZyU3ocO5UJijYe2iPPu3eULkZ7b7zM0OMbl1SdFp70xhi0Ysv9CME
   pw5ObbL3fHwcMOEpNlrEvhurt3ZIM+GX+Ee4ekdmCVHugFfTqTc+LYfs6
   ZTpVD3MJqkDH6vn6djTrV6QjnwlT5z9pG0F91IEspAXV5AvlggaCRIMdU
   eBtalEXVdj28Z8ZdkWiOsRXMn4YR+bWPzO5vxlMGmJ9ElwGfz8WSndGdn
   Yhpy9EjFTEprf5Gfd6yVsQUrSTp09FhP8aKnJfk4+HVJaCs/oN2cJBdx5
   g==;
X-CSE-ConnectionGUID: BYiuRY24TOyR3HN5vsYZxQ==
X-CSE-MsgGUID: ZcDWVEV5SLqUbdFEuPpI8Q==
X-IronPort-AV: E=McAfee;i="6700,10204,11137"; a="22697487"
X-IronPort-AV: E=Sophos;i="6.09,218,1716274800"; 
   d="scan'208";a="22697487"
Received: from orviesa003.jf.intel.com ([10.64.159.143])
  by orvoesa107.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Jul 2024 14:12:53 -0700
X-CSE-ConnectionGUID: Ehj5O1VDTuelfLWxbbeNBg==
X-CSE-MsgGUID: CwTw9HX0R9e8QCPlfmBH/w==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.09,218,1716274800"; 
   d="scan'208";a="55760437"
Received: from ccbilbre-mobl3.amr.corp.intel.com (HELO rpedgeco-desk4..) ([10.124.223.76])
  by ORVIESA003-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Jul 2024 14:12:53 -0700
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
	rick.p.edgecombe@intel.com
Subject: [PATCH v4 18/18] KVM: x86/mmu: Prevent aliased memslot GFNs
Date: Thu, 18 Jul 2024 14:12:30 -0700
Message-Id: <20240718211230.1492011-19-rick.p.edgecombe@intel.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20240718211230.1492011-1-rick.p.edgecombe@intel.com>
References: <20240718211230.1492011-1-rick.p.edgecombe@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Add a few sanity checks to prevent memslot GFNs from ever having alias bits
set.

Like other Coco technologies, TDX has the concept of private and shared
memory. For TDX the private and shared mappings are managed on separate
EPT roots. The private half is managed indirectly though calls into a
protected runtime environment called the TDX module, where the shared half
is managed within KVM in normal page tables.

For TDX, the shared half will be mapped in the higher alias, with a "shared
bit" set in the GPA. However, KVM will still manage it with the same
memslots as the private half. This means memslot looks ups and zapping
operations will be provided with a GFN without the shared bit set.

If these memslot GFNs ever had the bit that selects between the two aliases
it could lead to unexpected behavior in the complicated code that directs
faulting or zapping operations between the roots that map the two aliases.

As a safety measure, prevent memslots from being set at a GFN range that
contains the alias bit.

Also, check in the kvm_faultin_pfn() for the fault path. This later check
does less today, as the alias bits are specifically stripped from the GFN
being checked, however future code could possibly call in to the fault
handler in a way that skips this stripping. Since kvm_faultin_pfn() now
has many references to vcpu->kvm, extract it to local variable.

Link: https://lore.kernel.org/kvm/ZpbKqG_ZhCWxl-Fc@google.com/
Suggested-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Rick Edgecombe <rick.p.edgecombe@intel.com>
---
v4:
 - New patch
---
 arch/x86/kvm/mmu.h     |  5 +++++
 arch/x86/kvm/mmu/mmu.c | 10 +++++++---
 arch/x86/kvm/x86.c     |  3 +++
 3 files changed, 15 insertions(+), 3 deletions(-)

diff --git a/arch/x86/kvm/mmu.h b/arch/x86/kvm/mmu.h
index 4f6c86294f05..e6923cd7d648 100644
--- a/arch/x86/kvm/mmu.h
+++ b/arch/x86/kvm/mmu.h
@@ -344,4 +344,9 @@ static inline bool kvm_is_addr_direct(struct kvm *kvm, gpa_t gpa)
 
 	return !gpa_direct_bits || (gpa & gpa_direct_bits);
 }
+
+static inline bool kvm_is_gfn_alias(struct kvm *kvm, gfn_t gfn)
+{
+	return gfn & kvm_gfn_direct_bits(kvm);
+}
 #endif
diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index 3fe7f7d94c7e..010ebcf628b4 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -4415,8 +4415,12 @@ static int kvm_faultin_pfn(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault,
 			   unsigned int access)
 {
 	struct kvm_memory_slot *slot = fault->slot;
+	struct kvm *kvm = vcpu->kvm;
 	int ret;
 
+	if (KVM_BUG_ON(kvm_is_gfn_alias(kvm, fault->gfn), kvm))
+		return -EFAULT;
+
 	/*
 	 * Note that the mmu_invalidate_seq also serves to detect a concurrent
 	 * change in attributes.  is_page_fault_stale() will detect an
@@ -4430,7 +4434,7 @@ static int kvm_faultin_pfn(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault,
 	 * Now that we have a snapshot of mmu_invalidate_seq we can check for a
 	 * private vs. shared mismatch.
 	 */
-	if (fault->is_private != kvm_mem_is_private(vcpu->kvm, fault->gfn)) {
+	if (fault->is_private != kvm_mem_is_private(kvm, fault->gfn)) {
 		kvm_mmu_prepare_memory_fault_exit(vcpu, fault);
 		return -EFAULT;
 	}
@@ -4492,7 +4496,7 @@ static int kvm_faultin_pfn(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault,
 	 * *guaranteed* to need to retry, i.e. waiting until mmu_lock is held
 	 * to detect retry guarantees the worst case latency for the vCPU.
 	 */
-	if (mmu_invalidate_retry_gfn_unsafe(vcpu->kvm, fault->mmu_seq, fault->gfn))
+	if (mmu_invalidate_retry_gfn_unsafe(kvm, fault->mmu_seq, fault->gfn))
 		return RET_PF_RETRY;
 
 	ret = __kvm_faultin_pfn(vcpu, fault);
@@ -4512,7 +4516,7 @@ static int kvm_faultin_pfn(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault,
 	 * overall cost of failing to detect the invalidation until after
 	 * mmu_lock is acquired.
 	 */
-	if (mmu_invalidate_retry_gfn_unsafe(vcpu->kvm, fault->mmu_seq, fault->gfn)) {
+	if (mmu_invalidate_retry_gfn_unsafe(kvm, fault->mmu_seq, fault->gfn)) {
 		kvm_release_pfn_clean(fault->pfn);
 		return RET_PF_RETRY;
 	}
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 4f58423c6148..28bae3f95ef6 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -12942,6 +12942,9 @@ int kvm_arch_prepare_memory_region(struct kvm *kvm,
 		if ((new->base_gfn + new->npages - 1) > kvm_mmu_max_gfn())
 			return -EINVAL;
 
+		if (kvm_is_gfn_alias(kvm, new->base_gfn + new->npages - 1))
+			return -EINVAL;
+
 		return kvm_alloc_memslot_metadata(kvm, new);
 	}
 
-- 
2.34.1


