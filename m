Return-Path: <kvm+bounces-9635-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id D478D866C49
	for <lists+kvm@lfdr.de>; Mon, 26 Feb 2024 09:31:49 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 61804283030
	for <lists+kvm@lfdr.de>; Mon, 26 Feb 2024 08:31:48 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3B92E4F896;
	Mon, 26 Feb 2024 08:27:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="kwXRcev7"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.7])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7BE5A47A76;
	Mon, 26 Feb 2024 08:27:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.7
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708936065; cv=none; b=Wz3RT4olsqdH1Y/11c/B77RNtTCWvsyB6Nqfv/QSUbRjGpLTvLt0m0by0/BXoKggd9OsV1TCTrMUjzu5ye2NXo1uJtl7zmu98uREew/MCcxM1YMYcc1OgtQ2O32huOwLEjUgvP7Qmnac6lY0SyfJSLczghWE85rjWv6pyD8uyoY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708936065; c=relaxed/simple;
	bh=UFjZ9FiwgdrptLt8Ffkz8jHayts9vWGjhO2Osf/SglA=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=iQHIuGJPKICl4XmL77nAvHeZ5yx7ZZY1rlt+0PC7lr2dLBugyvZndjAbi0vSQ4UOiWB5lnFlG0rEGmlQB3hHOX2lH5vU9DJBuqiMVofA33LdPb5EsY2FVkgO7lXMOeqsCvXoYJgiMlZhQYcNDZb/2NiHWxnA5VDRYBGIQsyIrNQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=kwXRcev7; arc=none smtp.client-ip=192.198.163.7
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1708936063; x=1740472063;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=UFjZ9FiwgdrptLt8Ffkz8jHayts9vWGjhO2Osf/SglA=;
  b=kwXRcev7ZOZJFKoN8FDhMXJQ0YapgcuJ95znKjW0+7Y5sNk362koTeut
   VVBBBiFqZayI+Safg9VuhuhD53EtecmpGmq6EXgoi/ORyUhnxguatn6nU
   dYUv1/TGiCiUXCPphlyKvba1OOcwjfd5MdGFVjg1JHJo7dRsewlU5dh0b
   IiEtdzkf87kR6SYIAOb46xWxnvAnWNmX9btuFMSQA7YaWNY4456IRPamJ
   ZgVtMZzMlLWTB+simjjENvdTEYaY0G/aQIN42ItwwcWZxB7HTHhDFzdA5
   Bhrx166ycI0lQuv4jiVIH6eVJhwaygHnIactwyc/dG/8KOGcRLta/SW73
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10995"; a="28631470"
X-IronPort-AV: E=Sophos;i="6.06,185,1705392000"; 
   d="scan'208";a="28631470"
Received: from fmviesa007.fm.intel.com ([10.60.135.147])
  by fmvoesa101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Feb 2024 00:27:41 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.06,185,1705392000"; 
   d="scan'208";a="6474327"
Received: from ls.sc.intel.com (HELO localhost) ([172.25.112.31])
  by fmviesa007-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Feb 2024 00:27:40 -0800
From: isaku.yamahata@intel.com
To: kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org
Cc: isaku.yamahata@intel.com,
	isaku.yamahata@gmail.com,
	Paolo Bonzini <pbonzini@redhat.com>,
	erdemaktas@google.com,
	Sean Christopherson <seanjc@google.com>,
	Sagi Shahar <sagis@google.com>,
	Kai Huang <kai.huang@intel.com>,
	chen.bo@intel.com,
	hang.yuan@intel.com,
	tina.zhang@intel.com
Subject: [PATCH v19 011/130] KVM: Add new members to struct kvm_gfn_range to operate on
Date: Mon, 26 Feb 2024 00:25:13 -0800
Message-Id: <e324ff5e47e07505648c0092a5370ac9ddd72f0b.1708933498.git.isaku.yamahata@intel.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <cover.1708933498.git.isaku.yamahata@intel.com>
References: <cover.1708933498.git.isaku.yamahata@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Isaku Yamahata <isaku.yamahata@intel.com>

Add new members to strut kvm_gfn_range to indicate which mapping
(private-vs-shared) to operate on.  only_private and only_shared.  Update
mmu notifier, set memory attributes ioctl or KVM gmem callback to
initialize them.

It was premature for set_memory_attributes ioctl to call
kvm_unmap_gfn_range().  Instead, let kvm_arch_ste_memory_attributes()
handle it and add a new x86 vendor callback to react to memory attribute
change.  [1]

- If it's from the mmu notifier, zap shared pages only
- If it's from the KVM gmem, zap private pages only
- If setting memory attributes, vendor callback checks new attributes
  and make decisions.
  SNP would do nothing and handle it later with gmem callback
  TDX callback would do as follows.
  When it converts pages to shared, zap private pages only.
  When it converts pages to private, zap shared pages only.

TDX needs to know which mapping to operate on.  Shared-EPT vs. Secure-EPT.
The following sequence to convert the GPA to private doesn't work for TDX
because the page can already be private.

1) Update memory attributes to private in memory attributes xarray
2) Zap the GPA range irrespective of private-or-shared.
   Even if the page is already private, zap the entry.
3) EPT violation on the GPA
4) Populate the GPA as private
   The page is zeroed, and the guest has to accept the page again.

In step 2, TDX wants to zap only shared pages and skip private ones.

[1] https://lore.kernel.org/all/ZJX0hk+KpQP0KUyB@google.com/

Suggested-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>

---
Changes v18:
- rebased to kvm-next

Changes v2 -> v3:
- Drop the KVM_GFN_RANGE flags
- Updated struct kvm_gfn_range
- Change kvm_arch_set_memory_attributes() to return bool for flush
- Added set_memory_attributes x86 op for vendor backends
- Refined commit message to describe TDX care concretely

Changes v1 -> v2:
- consolidate KVM_GFN_RANGE_FLAGS_GMEM_{PUNCH_HOLE, RELEASE} into
  KVM_GFN_RANGE_FLAGS_GMEM.
- Update the commit message to describe TDX more.  Drop SEV_SNP.

Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
---
 include/linux/kvm_host.h |  2 ++
 virt/kvm/guest_memfd.c   |  3 +++
 virt/kvm/kvm_main.c      | 17 +++++++++++++++++
 3 files changed, 22 insertions(+)

diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index 7e7fd25b09b3..0520cd8d03cc 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -264,6 +264,8 @@ struct kvm_gfn_range {
 	gfn_t start;
 	gfn_t end;
 	union kvm_mmu_notifier_arg arg;
+	bool only_private;
+	bool only_shared;
 	bool may_block;
 };
 bool kvm_unmap_gfn_range(struct kvm *kvm, struct kvm_gfn_range *range);
diff --git a/virt/kvm/guest_memfd.c b/virt/kvm/guest_memfd.c
index 0f4e0cf4f158..3830d50b9b67 100644
--- a/virt/kvm/guest_memfd.c
+++ b/virt/kvm/guest_memfd.c
@@ -64,6 +64,9 @@ static void kvm_gmem_invalidate_begin(struct kvm_gmem *gmem, pgoff_t start,
 			.end = slot->base_gfn + min(pgoff + slot->npages, end) - pgoff,
 			.slot = slot,
 			.may_block = true,
+			/* guest memfd is relevant to only private mappings. */
+			.only_private = true,
+			.only_shared = false,
 		};
 
 		if (!found_memslot) {
diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index 10bfc88a69f7..0349e1f241d1 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -634,6 +634,12 @@ static __always_inline kvm_mn_ret_t __kvm_handle_hva_range(struct kvm *kvm,
 			 */
 			gfn_range.arg = range->arg;
 			gfn_range.may_block = range->may_block;
+			/*
+			 * HVA-based notifications aren't relevant to private
+			 * mappings as they don't have a userspace mapping.
+			 */
+			gfn_range.only_private = false;
+			gfn_range.only_shared = true;
 
 			/*
 			 * {gfn(page) | page intersects with [hva_start, hva_end)} =
@@ -2486,6 +2492,16 @@ static __always_inline void kvm_handle_gfn_range(struct kvm *kvm,
 	gfn_range.arg = range->arg;
 	gfn_range.may_block = range->may_block;
 
+	/*
+	 * If/when KVM supports more attributes beyond private .vs shared, this
+	 * _could_ set only_{private,shared} appropriately if the entire target
+	 * range already has the desired private vs. shared state (it's unclear
+	 * if that is a net win).  For now, KVM reaches this point if and only
+	 * if the private flag is being toggled, i.e. all mappings are in play.
+	 */
+	gfn_range.only_private = false;
+	gfn_range.only_shared = false;
+
 	for (i = 0; i < kvm_arch_nr_memslot_as_ids(kvm); i++) {
 		slots = __kvm_memslots(kvm, i);
 
@@ -2542,6 +2558,7 @@ static int kvm_vm_set_mem_attributes(struct kvm *kvm, gfn_t start, gfn_t end,
 	struct kvm_mmu_notifier_range pre_set_range = {
 		.start = start,
 		.end = end,
+		.arg.attributes = attributes,
 		.handler = kvm_pre_set_memory_attributes,
 		.on_lock = kvm_mmu_invalidate_begin,
 		.flush_on_ret = true,
-- 
2.25.1


