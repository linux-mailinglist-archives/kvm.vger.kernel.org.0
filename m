Return-Path: <kvm+bounces-18450-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id CE5468D5448
	for <lists+kvm@lfdr.de>; Thu, 30 May 2024 23:11:08 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 5DC7DB25812
	for <lists+kvm@lfdr.de>; Thu, 30 May 2024 21:11:06 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 919D91A0B0F;
	Thu, 30 May 2024 21:07:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="SrnqCO9E"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 25B2C145B3C;
	Thu, 30 May 2024 21:07:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.10
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717103261; cv=none; b=FUh2khd/Ol+tnSfAEj7pVuyAyRBo0yoWy7vbunJBiptw2lUAwJVD8hOkVWa2Tepx9YOxQCVmOAY+njbDbHIKPHsVPgZMLo5cccySt23tlMiOrYKTYtZrs6jR5KsPjyc2sQZoSfiFAfDUTOUxEVDsU4yvAysEfE7OzwNAYobSwDE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717103261; c=relaxed/simple;
	bh=H8Lqvtvr2lFQORPewKuEfjj4pQBscZw0DAAFruHeiT8=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=JA0oxKFrH3IMAtBPL51yB8znh8dk/cmzBbcAJ8fLtcAbKODATqLj/Q1L4sNz/+LbVF2mS3z0CbJLdqhNKv7A80lFpzLAfjwRbQrKSW+r+yILyrS/nDQ8v99quioD963MqxPgI0PCB3oA2X5vqWOpAVWULxbDKTjUexhRjqkGWCE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=SrnqCO9E; arc=none smtp.client-ip=198.175.65.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1717103260; x=1748639260;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=H8Lqvtvr2lFQORPewKuEfjj4pQBscZw0DAAFruHeiT8=;
  b=SrnqCO9EKmDrafmTXqReOitSK5CWvUyCU6FxBGe2J6/xfQDZIA0HVVe8
   WDUqCQYteE7SXwODufbjN9jVjfrl6C7b+G9iwO/p7TqrjNyItH/a1hevF
   UTSE7pQSbFohvTiF+XqyGl3qDMtDoC8dk8Zg8KCPw7CP2/VQsPdqVse0A
   RYF5CdcBRKARXVXO/h/mSQvWKFWuCd0TjU6DZsVukeIh4dPSzLSBsFH4T
   oIxWQO/JhHOVGGcCdFY9tkhXnWUP3AIvx0EYwrSe2y1AHyITEQXcYEH69
   wNDLHhX3Z579xdrRu/pBmXgsVTym5XqcRjp2+i6/EPp+1QzPDTq3MwHC+
   Q==;
X-CSE-ConnectionGUID: h/LCozAIRneQBCKdJNBwAQ==
X-CSE-MsgGUID: 2T5fwHAkQ2ucN27j5lvwWw==
X-IronPort-AV: E=McAfee;i="6600,9927,11088"; a="31117150"
X-IronPort-AV: E=Sophos;i="6.08,202,1712646000"; 
   d="scan'208";a="31117150"
Received: from fmviesa007.fm.intel.com ([10.60.135.147])
  by orvoesa102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 May 2024 14:07:39 -0700
X-CSE-ConnectionGUID: 9OxmouqaRg62zdwiVYjdIQ==
X-CSE-MsgGUID: ehaXV5F+RMyKDdixYlrUqg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.08,202,1712646000"; 
   d="scan'208";a="35874462"
Received: from hding1-mobl.ccr.corp.intel.com (HELO rpedgeco-desk4.intel.com) ([10.209.19.65])
  by fmviesa007-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 May 2024 14:07:39 -0700
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
Subject: [PATCH v2 13/15] KVM: x86/tdp_mmu: Make mmu notifier callbacks to check kvm_process
Date: Thu, 30 May 2024 14:07:12 -0700
Message-Id: <20240530210714.364118-14-rick.p.edgecombe@intel.com>
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

Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
Signed-off-by: Rick Edgecombe <rick.p.edgecombe@intel.com>
---
TDX MMU Prep v2:
 - Use newly added kvm_process_to_root_types()

TDX MMU Prep:
 - Remove warning (Rick)
 - Remove confusing mention of mapping flags (Chao)
 - Re-write coverletter

v19:
 - type: test_gfn() => test_young()

v18:
 - newly added
---
 arch/x86/kvm/mmu/tdp_mmu.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kvm/mmu/tdp_mmu.c b/arch/x86/kvm/mmu/tdp_mmu.c
index 4f00ae7da072..da6024b8295f 100644
--- a/arch/x86/kvm/mmu/tdp_mmu.c
+++ b/arch/x86/kvm/mmu/tdp_mmu.c
@@ -1351,12 +1351,14 @@ int kvm_tdp_mmu_map(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault)
 	return ret;
 }
 
+/* Used by mmu notifier via kvm_unmap_gfn_range() */
 bool kvm_tdp_mmu_unmap_gfn_range(struct kvm *kvm, struct kvm_gfn_range *range,
 				 bool flush)
 {
+	enum kvm_tdp_mmu_root_types types = kvm_process_to_root_types(kvm, range->process);
 	struct kvm_mmu_page *root;
 
-	__for_each_tdp_mmu_root_yield_safe(kvm, root, range->slot->as_id, KVM_ANY_ROOTS)
+	__for_each_tdp_mmu_root_yield_safe(kvm, root, range->slot->as_id, types)
 		flush = tdp_mmu_zap_leafs(kvm, root, range->start, range->end,
 					  range->may_block, flush);
 
@@ -1370,6 +1372,7 @@ static __always_inline bool kvm_tdp_mmu_handle_gfn(struct kvm *kvm,
 						   struct kvm_gfn_range *range,
 						   tdp_handler_t handler)
 {
+	enum kvm_tdp_mmu_root_types types = kvm_process_to_root_types(kvm, range->process);
 	struct kvm_mmu_page *root;
 	struct tdp_iter iter;
 	bool ret = false;
@@ -1378,7 +1381,7 @@ static __always_inline bool kvm_tdp_mmu_handle_gfn(struct kvm *kvm,
 	 * Don't support rescheduling, none of the MMU notifiers that funnel
 	 * into this helper allow blocking; it'd be dead, wasteful code.
 	 */
-	for_each_tdp_mmu_root(kvm, root, range->slot->as_id) {
+	__for_each_tdp_mmu_root(kvm, root, range->slot->as_id, types) {
 		rcu_read_lock();
 
 		tdp_root_for_each_leaf_pte(iter, kvm, root, range->start, range->end)
-- 
2.34.1


