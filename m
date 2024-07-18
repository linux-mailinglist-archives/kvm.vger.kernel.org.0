Return-Path: <kvm+bounces-21885-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 02A539352F5
	for <lists+kvm@lfdr.de>; Thu, 18 Jul 2024 23:13:31 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 25A061C21486
	for <lists+kvm@lfdr.de>; Thu, 18 Jul 2024 21:13:30 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 91F591465BE;
	Thu, 18 Jul 2024 21:12:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="a6d3VlMU"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.15])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2E74C145FEB;
	Thu, 18 Jul 2024 21:12:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.15
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721337165; cv=none; b=laIzAnzp/tJ+gXe9MwXird8hWxScFkM2Q52V/JSyHNpd4MQAM2p1LxFsmsVY0z0Ss8Gyky8F7564Zu/s9tEW9O/8J7mn/nCvNDXwlozGCLya8BPMfZd+nIguN4hkMmnJE7LFW5s+XskRsUFiutynJil5Mo+TFiMmP9d6cgz9c4c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721337165; c=relaxed/simple;
	bh=BBy7GPOg0d+2ljCCqnuvdMtNSo89q9d+zR/eMMOn/U4=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=payp4V+wCYCa3yBjABNB9XkN+WsGMhQBtM+ubvVuY39fa1hdv+bBMtXhDGDxhhf4K0N14Mxso1pKBraLQDoGqU+O+0Bta3i0vLgC3iRooNndYsP8DMS3eO2zAclHfp4zqhxILJ56U/lkqfQu2WxiRkdHK+345tg5gB1M2mbFXw0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=a6d3VlMU; arc=none smtp.client-ip=198.175.65.15
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1721337164; x=1752873164;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=BBy7GPOg0d+2ljCCqnuvdMtNSo89q9d+zR/eMMOn/U4=;
  b=a6d3VlMU6ADxe/jbqBEv38JX+fwMo3bIwDpeWrfQRdnkmvA0oXkhkeTs
   a7Fokfaks+OBIqNV2YkhzuwBnv7NAI9Og1qXxfGkGr1XGmLfuViXQGK+/
   Cdfo8acOCdCV8u2/qgpdfKeNnhpXsjSOE957ACR2ZjtCtEt7+MT8Jf4up
   wbeaj583rDyBXzIhc1UIfVz4Ccn/VfYXl8pvDXsU2BeRLPj6tphWTTfFH
   UjaZ7lLFJ8wPpydFmeNXIO7uokoztboEEp9ilFzGiizBvxi2P24CwmFqO
   aQWtJLCMhW6MrLrjXjVNKqWy1J9ooDdhvtdN9o9KqpR/ccd1biNAMNeCO
   g==;
X-CSE-ConnectionGUID: 93m0vft7RwC3g/FoFw8VEA==
X-CSE-MsgGUID: j1s8CAlPSS2Gt83mqeuZig==
X-IronPort-AV: E=McAfee;i="6700,10204,11137"; a="22697398"
X-IronPort-AV: E=Sophos;i="6.09,218,1716274800"; 
   d="scan'208";a="22697398"
Received: from orviesa003.jf.intel.com ([10.64.159.143])
  by orvoesa107.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Jul 2024 14:12:42 -0700
X-CSE-ConnectionGUID: 6q3phqdzRE68GH7pnAttGA==
X-CSE-MsgGUID: pTGUhlVrSsW2i7RFVf9oRQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.09,218,1716274800"; 
   d="scan'208";a="55760370"
Received: from ccbilbre-mobl3.amr.corp.intel.com (HELO rpedgeco-desk4..) ([10.124.223.76])
  by ORVIESA003-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Jul 2024 14:12:41 -0700
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
Subject: [PATCH v4 02/18] KVM: Add member to struct kvm_gfn_range for target alias
Date: Thu, 18 Jul 2024 14:12:14 -0700
Message-Id: <20240718211230.1492011-3-rick.p.edgecombe@intel.com>
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

From: Isaku Yamahata <isaku.yamahata@intel.com>

Add new members to strut kvm_gfn_range to indicate which mapping
(private-vs-shared) to operate on: enum kvm_gfn_range_filter
attr_filter. Update the core zapping operations to set them appropriately.

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
v3:
 - Fix typo in comment (Paolo)
 - Remove KVM_PROCESS_PRIVATE_AND_SHARED (Paolo)
 - Remove outdated reference to exclude_{private,shared} (Paolo)
 - Set process member in new kvm_mmu_zap_memslot_leafs() function
 - Rename process -> filter (Paolo)

v1:
 - Replaced KVM_PROCESS_BASED_ON_ARG with BUGGY_KVM_INVALIDATION to follow
   the original suggestion and not populte kvm_handle_gfn_range(). And add
   WARN_ON_ONCE().
 - Move attribute specific logic into kvm_vm_set_mem_attributes()
 - Drop Sean's suggested-by tag as the solution has changed
 - Re-write commit log
---
 arch/x86/kvm/mmu/mmu.c   |  6 ++++++
 include/linux/kvm_host.h |  6 ++++++
 virt/kvm/guest_memfd.c   |  2 ++
 virt/kvm/kvm_main.c      | 14 ++++++++++++++
 4 files changed, 28 insertions(+)

diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index 6f721ab0cd33..1e184e524e97 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -7496,6 +7496,12 @@ bool kvm_arch_pre_set_memory_attributes(struct kvm *kvm,
 	if (WARN_ON_ONCE(!kvm_arch_has_private_mem(kvm)))
 		return false;
 
+	/* Unmap the old attribute page. */
+	if (range->arg.attributes & KVM_MEMORY_ATTRIBUTE_PRIVATE)
+		range->attr_filter = KVM_FILTER_SHARED;
+	else
+		range->attr_filter = KVM_FILTER_PRIVATE;
+
 	return kvm_unmap_gfn_range(kvm, range);
 }
 
diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index f7ba665652f3..4643680654d5 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -260,11 +260,17 @@ union kvm_mmu_notifier_arg {
 	unsigned long attributes;
 };
 
+enum kvm_gfn_range_filter {
+	KVM_FILTER_SHARED		= BIT(0),
+	KVM_FILTER_PRIVATE		= BIT(1),
+};
+
 struct kvm_gfn_range {
 	struct kvm_memory_slot *slot;
 	gfn_t start;
 	gfn_t end;
 	union kvm_mmu_notifier_arg arg;
+	enum kvm_gfn_range_filter attr_filter;
 	bool may_block;
 };
 bool kvm_unmap_gfn_range(struct kvm *kvm, struct kvm_gfn_range *range);
diff --git a/virt/kvm/guest_memfd.c b/virt/kvm/guest_memfd.c
index 8f4159dd7824..ce5c96f32c3f 100644
--- a/virt/kvm/guest_memfd.c
+++ b/virt/kvm/guest_memfd.c
@@ -113,6 +113,8 @@ static void kvm_gmem_invalidate_begin(struct kvm_gmem *gmem, pgoff_t start,
 			.end = slot->base_gfn + min(pgoff + slot->npages, end) - pgoff,
 			.slot = slot,
 			.may_block = true,
+			/* guest memfd is relevant to only private mappings. */
+			.attr_filter = KVM_FILTER_PRIVATE,
 		};
 
 		if (!found_memslot) {
diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index 293ae714e825..71df4968004e 100644
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
+			gfn_range.attr_filter = KVM_FILTER_SHARED;
 
 			/*
 			 * {gfn(page) | page intersects with [hva_start, hva_end)} =
@@ -2450,6 +2455,14 @@ static __always_inline void kvm_handle_gfn_range(struct kvm *kvm,
 	gfn_range.arg = range->arg;
 	gfn_range.may_block = range->may_block;
 
+	/*
+	 * If/when KVM supports more attributes beyond private .vs shared, this
+	 * _could_ set KVM_FILTER_{SHARED,PRIVATE} appropriately if the entire target
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


