Return-Path: <kvm+bounces-21894-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 6DFD1935308
	for <lists+kvm@lfdr.de>; Thu, 18 Jul 2024 23:16:06 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 9F8A41C2089D
	for <lists+kvm@lfdr.de>; Thu, 18 Jul 2024 21:16:05 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F099F149C6C;
	Thu, 18 Jul 2024 21:12:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="W4GZ5l1J"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.15])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 52F8C14885E;
	Thu, 18 Jul 2024 21:12:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.15
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721337175; cv=none; b=fWBxKMNNBkxcc9FQozaV3BcgmtxD++l6VMVX8/0XgQlCQsg2MrYw6PMksSaNkCeg1XxVML/HE02QMtpvT04ukzB3d31BfiqxwUiAgee+7dK7wcUqUTXnGCSBVmiEXYeuXMsJpAt3H42fFkBWW/Ud7E8T5o6lEjTpz8p62ceneec=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721337175; c=relaxed/simple;
	bh=Bd/MKvRZNcGPNNOzsHPszb0eImA7d/eHd9GNGvPVHAk=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=WZ8faK+ayyUQ0OzvvYclORPsrJaqqjDUdKGVTMaB/KREmweVrdLqTYG8tQ4Rmh8T5/BtOSMAskc7EXawnlVBKat5C18NicnXTHs6sZ5xdH0XiaF56pty4tNKm7bBe0yksu1DDPhaBSfSg9uqRdteK/WPmHy6HKoPZw0Tiz3yAB0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=W4GZ5l1J; arc=none smtp.client-ip=198.175.65.15
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1721337173; x=1752873173;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=Bd/MKvRZNcGPNNOzsHPszb0eImA7d/eHd9GNGvPVHAk=;
  b=W4GZ5l1JWAh6M2FgZfKjUj5ABRaBOuzLtcvp4rCWD3h7FuGHpbEPr+C+
   aj85wMORJDeRBb5U1ySKJw8PFobAH5YJgVYGhlg9nLJhyex+8xmCTtmfS
   CuAuU9MJuyDtDDlSMqd8tVpYN+63BGX/7Ka/o2amZoSzo41huPXU1b9SU
   72Ks16OGyJs3ftmrUK346WqgFj7XmvlBcp26iZF9KThexJpDJeNojDxnQ
   wW2bpqq1CrghFW6uQSjd8r1kKEBx3LKjpVIzX3Yhbr6dPaQ8FLxersQA8
   KAMmoCrlz3LgErs2jk3tjHQx2u4humxsmo4rVppxGSnslNWS7fNX0p/HG
   g==;
X-CSE-ConnectionGUID: 6xZan0xmRMKEsC3QDq7Qew==
X-CSE-MsgGUID: wZkctq5UQPy6OwlEG//NmA==
X-IronPort-AV: E=McAfee;i="6700,10204,11137"; a="22697451"
X-IronPort-AV: E=Sophos;i="6.09,218,1716274800"; 
   d="scan'208";a="22697451"
Received: from orviesa003.jf.intel.com ([10.64.159.143])
  by orvoesa107.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Jul 2024 14:12:49 -0700
X-CSE-ConnectionGUID: i3RRP1H2TQ6JK0sdBSNpyw==
X-CSE-MsgGUID: CYTRj0DuQU2UDq1MQ4EUEA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.09,218,1716274800"; 
   d="scan'208";a="55760415"
Received: from ccbilbre-mobl3.amr.corp.intel.com (HELO rpedgeco-desk4..) ([10.124.223.76])
  by ORVIESA003-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Jul 2024 14:12:49 -0700
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
Subject: [PATCH v4 13/18] KVM: x86/tdp_mmu: Propagate attr_filter to MMU notifier callbacks
Date: Thu, 18 Jul 2024 14:12:25 -0700
Message-Id: <20240718211230.1492011-14-rick.p.edgecombe@intel.com>
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
v3:
 - Change subject from "Make mmu notifier callbacks to check
   kvm_process" to "Propagate attr_filter to MMU notifier callbacks"
   (Paolo)
 - Remove no longer used for_each_tdp_mmu_root() (Binbin)

v2:
 - Use newly added kvm_process_to_root_types()

v1:
 - Remove warning (Rick)
 - Remove confusing mention of mapping flags (Chao)
 - Re-write coverletter
---
 arch/x86/kvm/mmu/tdp_mmu.c | 14 +++++++++-----
 1 file changed, 9 insertions(+), 5 deletions(-)

diff --git a/arch/x86/kvm/mmu/tdp_mmu.c b/arch/x86/kvm/mmu/tdp_mmu.c
index 5af7355ef015..748fdacc719c 100644
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
 
@@ -1214,12 +1211,16 @@ int kvm_tdp_mmu_map(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault)
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
 
@@ -1233,15 +1234,18 @@ static __always_inline bool kvm_tdp_mmu_handle_gfn(struct kvm *kvm,
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


