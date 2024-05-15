Return-Path: <kvm+bounces-17410-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id D49158C5E9D
	for <lists+kvm@lfdr.de>; Wed, 15 May 2024 03:04:23 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 042281C21057
	for <lists+kvm@lfdr.de>; Wed, 15 May 2024 01:04:23 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8C1873D57D;
	Wed, 15 May 2024 01:00:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="OUaaLWMV"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0CEB239847;
	Wed, 15 May 2024 01:00:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.19
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715734815; cv=none; b=NL0n0AEL5re1ERlbALnxky0vcsAFB45RfTYPBkBYK0BW4xduT792ZCrTN1ZEDnRlmuZ5ZJqdFlnUmDVh+d3Xd9VPWtG202g6/0+LnjnPGELdmWPwPF3TUOib6jXl5m3dLQp+BXebTcCqxe2D7xtSqy3qlDegdactnsq8QUDk+sE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715734815; c=relaxed/simple;
	bh=ncuxWk4n+cq8Op23zgOE/XZqoYu8BbW/SQHwcjWe9Yk=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=I2lodamewsTpymNXLWxzHNT8/kn53yvd/lgKDaE0SCLpfppAsVusrTZxHhCejoHD19714ft1auNnhq1vWPx9H+a8E5lSCD8jiNtI3evk12RS/JkuWXcs6iDg+yG2q8RlWhcp5O0Lfe8wKd/BLxYEmPAvVKkc6ZGAbS45FCBQOVQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=OUaaLWMV; arc=none smtp.client-ip=192.198.163.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1715734814; x=1747270814;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=ncuxWk4n+cq8Op23zgOE/XZqoYu8BbW/SQHwcjWe9Yk=;
  b=OUaaLWMVcXZBsphfIUntX13iQ8oMA/cEf38S7JzYjAX5+9xCzQbm3Up/
   vaw3X5Gmj8lanBGfp05mK0M5gsJoHx5JQVPFHS/ahL82EA2YWGLGceNV5
   z8E06nJNiZhrPB2a1bWHW0APnn9sr4lCOk4/1/4f4Ih46MvcGRmhqQxGB
   Aaynz9hyNZC4kyw+6qlPTJqmlC3Ev1YeNrxy6SdyDWJ6jLMEecKbFFBmi
   HoqAmU368ncKgu/roTkbKty/lSt45cwBOd4+X2yoRY2WDNUAP/2BqG+HR
   O1uPPzDxBuZl+7bWdFM+LUi1D26V4l9QoubpXaOP7U3vgjSQSRGUxX2lx
   A==;
X-CSE-ConnectionGUID: 0rgenTWKQ3OPWcvSoiPrsw==
X-CSE-MsgGUID: LrHh3l5uS8ezYxp+Ud+TfQ==
X-IronPort-AV: E=McAfee;i="6600,9927,11073"; a="11613994"
X-IronPort-AV: E=Sophos;i="6.08,160,1712646000"; 
   d="scan'208";a="11613994"
Received: from fmviesa006.fm.intel.com ([10.60.135.146])
  by fmvoesa113.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 May 2024 18:00:09 -0700
X-CSE-ConnectionGUID: dn1mAM6GR0exhGcx8v+U5A==
X-CSE-MsgGUID: bNhNrPqHSdqaemDkCQmK6w==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.08,160,1712646000"; 
   d="scan'208";a="30942853"
Received: from oyildiz-mobl1.amr.corp.intel.com (HELO rpedgeco-desk4.intel.com) ([10.209.51.34])
  by fmviesa006-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 May 2024 18:00:08 -0700
From: Rick Edgecombe <rick.p.edgecombe@intel.com>
To: pbonzini@redhat.com,
	seanjc@google.com,
	kvm@vger.kernel.org
Cc: linux-kernel@vger.kernel.org,
	isaku.yamahata@gmail.com,
	erdemaktas@google.com,
	sagis@google.com,
	yan.y.zhao@intel.com,
	dmatlack@google.com,
	rick.p.edgecombe@intel.com
Subject: [PATCH 15/16] KVM: x86/tdp_mmu: Make mmu notifier callbacks to check kvm_process
Date: Tue, 14 May 2024 17:59:51 -0700
Message-Id: <20240515005952.3410568-16-rick.p.edgecombe@intel.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20240515005952.3410568-1-rick.p.edgecombe@intel.com>
References: <20240515005952.3410568-1-rick.p.edgecombe@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Isaku Yamahata <isaku.yamahata@intel.com>

Teach the MMU notifier callbacks how to check kvm_gfn_range.process to
filter which KVM MMU root types to operate on.

The private GPAs are backed by guest memfd. Such memory is not subjected
to MMU notifier callbacks because it can't be mapped into the host user
address space. Now kvm_gfn_range conveys info about which root to operate
on. Enhance the callback to filter the root page table type.

The KVM MMU notifier comes down to two functions.
kvm_tdp_mmu_unmap_gfn_range() and kvm_tdp_mmu_handle_gfn().

For VM's without a private/shared split in the EPT, all operations
should target the normal(shared) root. Adjust the target roots based
on kvm_gfn_shared_mask().

invalidate_range_start() comes into kvm_tdp_mmu_unmap_gfn_range().
invalidate_range_end() doesn't come into arch code.

Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
Signed-off-by: Rick Edgecombe <rick.p.edgecombe@intel.com>
---
TDX MMU Part 1:
 - Remove warning (Rick)
 - Remove confusing mention of mapping flags (Chao)
 - Re-write coverletter

v19:
- type: test_gfn() => test_young()

v18:
- newly added
---
 arch/x86/kvm/mmu/tdp_mmu.c | 40 +++++++++++++++++++++++++++++++++++---
 1 file changed, 37 insertions(+), 3 deletions(-)

diff --git a/arch/x86/kvm/mmu/tdp_mmu.c b/arch/x86/kvm/mmu/tdp_mmu.c
index eb88af48c8f0..af61d131d2dc 100644
--- a/arch/x86/kvm/mmu/tdp_mmu.c
+++ b/arch/x86/kvm/mmu/tdp_mmu.c
@@ -1396,12 +1396,32 @@ int kvm_tdp_mmu_map(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault)
 	return ret;
 }
 
+static enum kvm_tdp_mmu_root_types kvm_process_to_root_types(struct kvm *kvm,
+							     enum kvm_process process)
+{
+	WARN_ON_ONCE(process == BUGGY_KVM_INVALIDATION);
+
+	/* Always process shared for cases where private is not on a separate root */
+	if (!kvm_gfn_shared_mask(kvm)) {
+		process |= KVM_PROCESS_SHARED;
+		process &= ~KVM_PROCESS_PRIVATE;
+	}
+
+	return (enum kvm_tdp_mmu_root_types)process;
+}
+
+/* Used by mmu notifier via kvm_unmap_gfn_range() */
 bool kvm_tdp_mmu_unmap_gfn_range(struct kvm *kvm, struct kvm_gfn_range *range,
 				 bool flush)
 {
+	enum kvm_tdp_mmu_root_types types = kvm_process_to_root_types(kvm, range->process);
 	struct kvm_mmu_page *root;
 
-	__for_each_tdp_mmu_root_yield_safe(kvm, root, range->slot->as_id, KVM_ANY_ROOTS)
+	/* kvm_process_to_root_types() has WARN_ON_ONCE().  Don't warn it again. */
+	if (types == BUGGY_KVM_ROOTS)
+		return flush;
+
+	__for_each_tdp_mmu_root_yield_safe(kvm, root, range->slot->as_id, types)
 		flush = tdp_mmu_zap_leafs(kvm, root, range->start, range->end,
 					  range->may_block, flush);
 
@@ -1415,18 +1435,32 @@ static __always_inline bool kvm_tdp_mmu_handle_gfn(struct kvm *kvm,
 						   struct kvm_gfn_range *range,
 						   tdp_handler_t handler)
 {
+	enum kvm_tdp_mmu_root_types types = kvm_process_to_root_types(kvm, range->process);
 	struct kvm_mmu_page *root;
 	struct tdp_iter iter;
 	bool ret = false;
 
+	if (types == BUGGY_KVM_ROOTS)
+		return ret;
+
 	/*
 	 * Don't support rescheduling, none of the MMU notifiers that funnel
 	 * into this helper allow blocking; it'd be dead, wasteful code.
 	 */
-	for_each_tdp_mmu_root(kvm, root, range->slot->as_id) {
+	__for_each_tdp_mmu_root(kvm, root, range->slot->as_id, types) {
+		gfn_t start, end;
+
+		/*
+		 * For TDX shared mapping, set GFN shared bit to the range,
+		 * so the handler() doesn't need to set it, to avoid duplicated
+		 * code in multiple handler()s.
+		 */
+		start = kvm_gfn_for_root(kvm, root, range->start);
+		end = kvm_gfn_for_root(kvm, root, range->end);
+
 		rcu_read_lock();
 
-		tdp_root_for_each_leaf_pte(iter, root, range->start, range->end)
+		tdp_root_for_each_leaf_pte(iter, root, start, end)
 			ret |= handler(kvm, &iter, range);
 
 		rcu_read_unlock();
-- 
2.34.1


