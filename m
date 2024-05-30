Return-Path: <kvm+bounces-18438-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 1234D8D542C
	for <lists+kvm@lfdr.de>; Thu, 30 May 2024 23:07:56 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 323121C20D6B
	for <lists+kvm@lfdr.de>; Thu, 30 May 2024 21:07:55 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D8675181CE5;
	Thu, 30 May 2024 21:07:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="i6BH87Ax"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0B7076F303;
	Thu, 30 May 2024 21:07:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.10
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717103254; cv=none; b=jhINE1Q/1d5A6kBspJebgpKgHSNNonr1YO8Ung0oJkVYe34ORra5TJc2T4uvgb2AuggzUKb3/TDDRTDNpsh1IvsoQVw1cfzWUQhQ1UMZE/HGNw5AgVlbaMcldqzZNsBXw4VUZ98bjBYt7dOzHNOa/ZlqeXFWRr5bNF0QRkY1b0g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717103254; c=relaxed/simple;
	bh=fn4Z2U5ZWfUCedFPrFaQ77HHY8nmIRDemqc13Vn9nWs=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=eWU4kVBMseNY8PGr2AbUGhi+8U29MyW0PirvFuSoC1iIIzYuHUI9KYRkavFey1qksYLmRbGSObhj2vf1AcqfPtLBNMTY/5J3nk1MtD39lhkgKf5SnBQuGKeRRRiGUwssc1yWLkZfSk68lQVhmQZxKARVkdoZb2Q4ojUREdFjFBE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=i6BH87Ax; arc=none smtp.client-ip=198.175.65.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1717103252; x=1748639252;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=fn4Z2U5ZWfUCedFPrFaQ77HHY8nmIRDemqc13Vn9nWs=;
  b=i6BH87AxlwOkkSj73cXSeCejKBX9lCPYX2JyJqGfGfHZLbYQPn5mGV91
   W9wL9v2bBeHC4+aiDPNqlXj05u2YPaAmWmrczjw7u0BRkZfmheLGPvgox
   WKeS3U8q3eJSZYeKIm5mTNhWulNMy+VaE5nshykK2MQQCPdcausuaBaff
   uppdT4hq7px4VyGOSAMjbtfusMJWt2O1Wrojqo2Br0ZEwO6d5Jo8vGNYK
   b6x6TUkEa/z5LkeL3TnWHiiZond344ykyI5NTL8w2naQYA99eC/0IoOAl
   BlP5hsXjxDwjlpdOOrVKJfIzC2/3GlJcFlcmo6YNJ/lH1Xcu0TLdlxBEr
   Q==;
X-CSE-ConnectionGUID: 11dYpo56RpO5Ai/KvDrlzg==
X-CSE-MsgGUID: 0pMk15A5TSO3s3C9qHnpmg==
X-IronPort-AV: E=McAfee;i="6600,9927,11088"; a="31117082"
X-IronPort-AV: E=Sophos;i="6.08,202,1712646000"; 
   d="scan'208";a="31117082"
Received: from fmviesa007.fm.intel.com ([10.60.135.147])
  by orvoesa102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 May 2024 14:07:31 -0700
X-CSE-ConnectionGUID: LWNw8NhRTXWnXk2UWNZi5Q==
X-CSE-MsgGUID: ixEFpwtIRpWC6P30OKE7DA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.08,202,1712646000"; 
   d="scan'208";a="35874401"
Received: from hding1-mobl.ccr.corp.intel.com (HELO rpedgeco-desk4.intel.com) ([10.209.19.65])
  by fmviesa007-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 May 2024 14:07:30 -0700
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
Subject: [PATCH v2 01/15] KVM: Add member to struct kvm_gfn_range for target alias
Date: Thu, 30 May 2024 14:07:00 -0700
Message-Id: <20240530210714.364118-2-rick.p.edgecombe@intel.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20240530210714.364118-1-rick.p.edgecombe@intel.com>
References: <20240530210714.364118-1-rick.p.edgecombe@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Isaku Yamahata <isaku.yamahata@intel.com>

Add new members to strut kvm_gfn_range to indicate which mapping
(private-vs-shared) to operate on: enum kvm_process process.
Update the core zapping operations to set them appropriately.

TDX utilizes two GPA aliases for the same memslots, one for memory that is
for private memory and one that is for shared. For private memory, KVM
cannot always perform the same operations it does on memory for default
VMs, such as zapping pages and having them be faulted back in, as this
requires guest coordination. However, some operations such as guest driven
conversion of memory between private and shared should zap private memory.

Internally to the MMU, private and shared mappings are tracked on separate
roots. Mapping and zapping operations will operate on the respective GFN
alias for each root (private or shared). So zapping operations will by
default zap both aliases. Add fields in struct kvm_gfn_range to allow
callers to specify which aliases so they can only target the aliases
appropriate for their specific operation.

There was feedback that target aliases should be specified such that the
default value (0) is to operate on both aliases. Several options were
considered. Several variations of having separate bools defined such
that the default behavior was to process both aliases. They either allowed
nonsensical configurations, or were confusing for the caller. A simple
enum was also explored and was close, but was hard to process in the
caller. Instead, use an enum with the default value (0) reserved as a
disallowed value. Catch ranges that didn't have the target aliases
specified by looking for that specific value.

Set target alias with enum appropriately for these MMU operations:
 - For KVM's mmu notifier callbacks, zap shared pages only because private
   pages won't have a userspace mapping
 - For setting memory attributes, kvm_arch_pre_set_memory_attributes()
   chooses the aliases based on the attribute.
 - For guest_memfd invalidations, zap private only.

Link: https://lore.kernel.org/kvm/ZivIF9vjKcuGie3s@google.com/
Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
Co-developed-by: Rick Edgecombe <rick.p.edgecombe@intel.com>
Signed-off-by: Rick Edgecombe <rick.p.edgecombe@intel.com>
---
TDX MMU Prep:
 - Replaced KVM_PROCESS_BASED_ON_ARG with BUGGY_KVM_INVALIDATION to follow
   the original suggestion and not populte kvm_handle_gfn_range(). And add
   WARN_ON_ONCE().
 - Move attribute specific logic into kvm_vm_set_mem_attributes()
 - Drop Sean's suggested-by tag as the solution has changed
 - Re-write commit log

v18:
 - rebased to kvm-next

v3:
 - Drop the KVM_GFN_RANGE flags
 - Updated struct kvm_gfn_range
 - Change kvm_arch_set_memory_attributes() to return bool for flush
 - Added set_memory_attributes x86 op for vendor backends
 - Refined commit message to describe TDX care concretely

v2:
 - consolidate KVM_GFN_RANGE_FLAGS_GMEM_{PUNCH_HOLE, RELEASE} into
   KVM_GFN_RANGE_FLAGS_GMEM.
 - Update the commit message to describe TDX more.  Drop SEV_SNP.
---
 arch/x86/kvm/mmu/mmu.c   |  6 ++++++
 include/linux/kvm_host.h |  8 ++++++++
 virt/kvm/guest_memfd.c   |  2 ++
 virt/kvm/kvm_main.c      | 14 ++++++++++++++
 4 files changed, 30 insertions(+)

diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index 61982da8c8b2..b97241945596 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -7451,6 +7451,12 @@ bool kvm_arch_pre_set_memory_attributes(struct kvm *kvm,
 	if (WARN_ON_ONCE(!kvm_arch_has_private_mem(kvm)))
 		return false;
 
+	/* Unmmap the old attribute page. */
+	if (range->arg.attributes & KVM_MEMORY_ATTRIBUTE_PRIVATE)
+		range->process = KVM_PROCESS_SHARED;
+	else
+		range->process = KVM_PROCESS_PRIVATE;
+
 	return kvm_unmap_gfn_range(kvm, range);
 }
 
diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index c3c922bf077f..f92c8b605b03 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -260,11 +260,19 @@ union kvm_mmu_notifier_arg {
 	unsigned long attributes;
 };
 
+enum kvm_process {
+	BUGGY_KVM_INVALIDATION		= 0,
+	KVM_PROCESS_SHARED		= BIT(0),
+	KVM_PROCESS_PRIVATE		= BIT(1),
+	KVM_PROCESS_PRIVATE_AND_SHARED	= KVM_PROCESS_SHARED | KVM_PROCESS_PRIVATE,
+};
+
 struct kvm_gfn_range {
 	struct kvm_memory_slot *slot;
 	gfn_t start;
 	gfn_t end;
 	union kvm_mmu_notifier_arg arg;
+	enum kvm_process process;
 	bool may_block;
 };
 bool kvm_unmap_gfn_range(struct kvm *kvm, struct kvm_gfn_range *range);
diff --git a/virt/kvm/guest_memfd.c b/virt/kvm/guest_memfd.c
index 9714add38852..e5ff6fde2db3 100644
--- a/virt/kvm/guest_memfd.c
+++ b/virt/kvm/guest_memfd.c
@@ -109,6 +109,8 @@ static void kvm_gmem_invalidate_begin(struct kvm_gmem *gmem, pgoff_t start,
 			.end = slot->base_gfn + min(pgoff + slot->npages, end) - pgoff,
 			.slot = slot,
 			.may_block = true,
+			/* guest memfd is relevant to only private mappings. */
+			.process = KVM_PROCESS_PRIVATE,
 		};
 
 		if (!found_memslot) {
diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index 81b90bf03f2f..4ff137058cec 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -635,6 +635,11 @@ static __always_inline kvm_mn_ret_t __kvm_handle_hva_range(struct kvm *kvm,
 			 */
 			gfn_range.arg = range->arg;
 			gfn_range.may_block = range->may_block;
+			/*
+			 * HVA-based notifications aren't relevant to private
+			 * mappings as they don't have a userspace mapping.
+			 */
+			gfn_range.process = KVM_PROCESS_SHARED;
 
 			/*
 			 * {gfn(page) | page intersects with [hva_start, hva_end)} =
@@ -2450,6 +2455,14 @@ static __always_inline void kvm_handle_gfn_range(struct kvm *kvm,
 	gfn_range.arg = range->arg;
 	gfn_range.may_block = range->may_block;
 
+	/*
+	 * If/when KVM supports more attributes beyond private .vs shared, this
+	 * _could_ set exclude_{private,shared} appropriately if the entire target
+	 * range already has the desired private vs. shared state (it's unclear
+	 * if that is a net win).  For now, KVM reaches this point if and only
+	 * if the private flag is being toggled, i.e. all mappings are in play.
+	 */
+
 	for (i = 0; i < kvm_arch_nr_memslot_as_ids(kvm); i++) {
 		slots = __kvm_memslots(kvm, i);
 
@@ -2506,6 +2519,7 @@ static int kvm_vm_set_mem_attributes(struct kvm *kvm, gfn_t start, gfn_t end,
 	struct kvm_mmu_notifier_range pre_set_range = {
 		.start = start,
 		.end = end,
+		.arg.attributes = attributes,
 		.handler = kvm_pre_set_memory_attributes,
 		.on_lock = kvm_mmu_invalidate_begin,
 		.flush_on_ret = true,
-- 
2.34.1


