Return-Path: <kvm+bounces-20028-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 291C590F927
	for <lists+kvm@lfdr.de>; Thu, 20 Jun 2024 00:40:50 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 3AD221C213C3
	for <lists+kvm@lfdr.de>; Wed, 19 Jun 2024 22:40:49 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 022A717BB13;
	Wed, 19 Jun 2024 22:36:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="kr2dRD6y"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4BD8B1684AC;
	Wed, 19 Jun 2024 22:36:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718836594; cv=none; b=fTAh+3qSMl753yVGMobjCzDWEn69pbHQf5wMuwNfrzHOyAhA7SvPCP3dfGkg+5EaArh5eZjCI9TMnfbIHE0QidZNvw5xuxw+lxp4HP7KTv3JqXnK/wxk16WGpc7lhjdhhf7VWKhmSLMcwIVgt/Xbk619wcoFjw6VEVgealwxuwg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718836594; c=relaxed/simple;
	bh=pQpRxoD/bBZfiYxgtVnfsfU0R1AIIwksKAjwrmd0eJY=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=f7Tgb6gj8bQNIEJwKjprC8iKITgDxCcXe+WxY/TTaI6rda9MeYfzTeBCDpVDbfTvDttNogGoswoqNzesJhDSKJH++0mYRTMLWWUHJup+WXO2jeg7MVfRswG1kbOVEDuouPBCngwAb4VWMxC/jImmIBd4XG73kBeZM5l8kNTvm14=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=kr2dRD6y; arc=none smtp.client-ip=198.175.65.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1718836592; x=1750372592;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=pQpRxoD/bBZfiYxgtVnfsfU0R1AIIwksKAjwrmd0eJY=;
  b=kr2dRD6yHg1uqnqoIiNp5DMzSHw0vCSpzHNLwkATkdUBUjwcOT1yBDH8
   uJltiJJKivrT3m5hyIOsM8AfESB82O8lTYC9IVN4FJdqo96smKEc/3Pr2
   4HAHC+56McIuwLFHpASldkfIvL4e7WqZ0axx/AcG2f+fgZwlCn0eAOeFb
   xKqs2zTIJhYCHBhX3joRfx4MHlxnPd1EQCMP51jN825v1Ae1pl8wCN5p8
   BZQmOSwOz0P+X1tJjz5dwVHdTMtC8KCP3loc9H5jKYaT25deKfpZ+o/Vu
   8N0WlGnrm6EgMyllagNYx5+kzyjK0mkWcIEL0C89Cp8PePG95rLAY5dSm
   A==;
X-CSE-ConnectionGUID: 3l7MH1FnQpWBWZtR+D44pQ==
X-CSE-MsgGUID: SAs1MIAqSVWaiZXjp1XIlA==
X-IronPort-AV: E=McAfee;i="6700,10204,11108"; a="15931988"
X-IronPort-AV: E=Sophos;i="6.08,251,1712646000"; 
   d="scan'208";a="15931988"
Received: from orviesa002.jf.intel.com ([10.64.159.142])
  by orvoesa110.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Jun 2024 15:36:24 -0700
X-CSE-ConnectionGUID: xlsPyDZNTqat0+uZLyUM2w==
X-CSE-MsgGUID: p95uEyk6TYSiqqMIoaMzIw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.08,251,1712646000"; 
   d="scan'208";a="72793369"
Received: from ivsilic-mobl2.amr.corp.intel.com (HELO rpedgeco-desk4.intel.com) ([10.209.54.39])
  by orviesa002-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Jun 2024 15:36:23 -0700
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
	rick.p.edgecombe@intel.com,
	Isaku Yamahata <isaku.yamahata@intel.com>
Subject: [PATCH v3 14/17] KVM: x86/tdp_mmu: Propagate attr_filter to MMU notifier callbacks
Date: Wed, 19 Jun 2024 15:36:11 -0700
Message-Id: <20240619223614.290657-15-rick.p.edgecombe@intel.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20240619223614.290657-1-rick.p.edgecombe@intel.com>
References: <20240619223614.290657-1-rick.p.edgecombe@intel.com>
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
should target the normal(direct) root.

invalidate_range_start() comes into kvm_tdp_mmu_unmap_gfn_range().
invalidate_range_end() doesn't come into arch code.

With the switch from for_each_tdp_mmu_root() to
__for_each_tdp_mmu_root() in kvm_tdp_mmu_handle_gfn(), there are no
longer any users of for_each_tdp_mmu_root(). Remove it.

Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
Signed-off-by: Rick Edgecombe <rick.p.edgecombe@intel.com>
---
TDX MMU Prep v3:
 - Change subject from "Make mmu notifier callbacks to check
   kvm_process" to "Propagate attr_filter to MMU notifier callbacks"
   (Paolo)
 - Remove no longer used for_each_tdp_mmu_root() (Binbin)

TDX MMU Prep v2:
 - Use newly added kvm_process_to_root_types()

TDX MMU Prep:
 - Remove warning (Rick)
 - Remove confusing mention of mapping flags (Chao)
 - Re-write coverletter

v19:
 - type: test_gfn() => test_young()

---
 arch/x86/kvm/mmu/tdp_mmu.c | 14 +++++++++-----
 1 file changed, 9 insertions(+), 5 deletions(-)

diff --git a/arch/x86/kvm/mmu/tdp_mmu.c b/arch/x86/kvm/mmu/tdp_mmu.c
index a0010c62425f..582e5a045bb7 100644
--- a/arch/x86/kvm/mmu/tdp_mmu.c
+++ b/arch/x86/kvm/mmu/tdp_mmu.c
@@ -193,9 +193,6 @@ static struct kvm_mmu_page *tdp_mmu_next_root(struct kvm *kvm,
 		     !tdp_mmu_root_match((_root), (_types)))) {			\
 		} else
 
-#define for_each_tdp_mmu_root(_kvm, _root, _as_id)			\
-	__for_each_tdp_mmu_root(_kvm, _root, _as_id, KVM_ALL_ROOTS)
-
 #define for_each_valid_tdp_mmu_root(_kvm, _root, _as_id)		\
 	__for_each_tdp_mmu_root(_kvm, _root, _as_id, KVM_VALID_ROOTS)
 
@@ -1210,12 +1207,16 @@ int kvm_tdp_mmu_map(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault)
 	return ret;
 }
 
+/* Used by mmu notifier via kvm_unmap_gfn_range() */
 bool kvm_tdp_mmu_unmap_gfn_range(struct kvm *kvm, struct kvm_gfn_range *range,
 				 bool flush)
 {
+	enum kvm_tdp_mmu_root_types types;
 	struct kvm_mmu_page *root;
 
-	__for_each_tdp_mmu_root_yield_safe(kvm, root, range->slot->as_id, KVM_ALL_ROOTS)
+	types = kvm_gfn_range_filter_to_root_types(kvm, range->attr_filter);
+
+	__for_each_tdp_mmu_root_yield_safe(kvm, root, range->slot->as_id, types)
 		flush = tdp_mmu_zap_leafs(kvm, root, range->start, range->end,
 					  range->may_block, flush);
 
@@ -1229,15 +1230,18 @@ static __always_inline bool kvm_tdp_mmu_handle_gfn(struct kvm *kvm,
 						   struct kvm_gfn_range *range,
 						   tdp_handler_t handler)
 {
+	enum kvm_tdp_mmu_root_types types;
 	struct kvm_mmu_page *root;
 	struct tdp_iter iter;
 	bool ret = false;
 
+	types = kvm_gfn_range_filter_to_root_types(kvm, range->attr_filter);
+
 	/*
 	 * Don't support rescheduling, none of the MMU notifiers that funnel
 	 * into this helper allow blocking; it'd be dead, wasteful code.
 	 */
-	for_each_tdp_mmu_root(kvm, root, range->slot->as_id) {
+	__for_each_tdp_mmu_root(kvm, root, range->slot->as_id, types) {
 		rcu_read_lock();
 
 		tdp_root_for_each_leaf_pte(iter, kvm, root, range->start, range->end)
-- 
2.34.1


