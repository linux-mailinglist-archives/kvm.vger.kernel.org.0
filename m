Return-Path: <kvm+bounces-17408-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 584CF8C5E98
	for <lists+kvm@lfdr.de>; Wed, 15 May 2024 03:03:48 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id E8EF5B220CD
	for <lists+kvm@lfdr.de>; Wed, 15 May 2024 01:03:45 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 266CC3B1AC;
	Wed, 15 May 2024 01:00:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="CYE3EWNf"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A6AAE374F5;
	Wed, 15 May 2024 01:00:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.19
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715734814; cv=none; b=qiMJi0MRjZxVm+wj8nEcmYYowne7GNTphCNMb8S4xZdQpfi/ZkEnnec8Dvvu1pyuiquVLcrgRM8CFtTzUUv9wQ+lS48VeXbr7iE1AT2rGh5L98JSoZ/wJM+nMeyg75mJF00E/Mp85MR3IoD0tgx8ulJjiT7X/V8TAFvZLOT4ncQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715734814; c=relaxed/simple;
	bh=Qkp1GU5j+YcdfSEFw2npWErCnczzFIzBQgNqWdkwsPI=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=Iqov8m4AvY0KXAxPgf3H0CHl1mHCb5kBD+JFCB8iCv6rmc4MoAHnJbtfdADR29wUXcIFtrULY5D32ZSnyWyh+ZqXSJb8lasuJXN/t4Q7k0bQSME7+tISKn/1RNEv+OGQWEBvXnMWcoTF95KoXR2ubv04Fa7jKVLIr7hFfqetehk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=CYE3EWNf; arc=none smtp.client-ip=192.198.163.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1715734813; x=1747270813;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=Qkp1GU5j+YcdfSEFw2npWErCnczzFIzBQgNqWdkwsPI=;
  b=CYE3EWNfzC/Aj6mXMu0M2pN+C4Sz7TzhUgQlEfTHTXm97i3K/rlktZFO
   xr3c5xxcPQgauF0f9p5BsXmS5Rc0Jbu2HsAuh5jlYaLz3jGLByrvONTvZ
   SWvL5v7CJEGNNky7lcIviWHMX8BWpRgrIiFpWq5WWwPnC1Qf6NYaVhkpZ
   b7WbD985SSaEI0Ig3BZhhr+bcnplnkcquifxM44/m+cZQDKTJT5loYq5c
   8MuScPqQ/3fAVVO4VfPSverBO7I5aeTda9hRMihYuJWDBwXfK1le3UBAF
   obddVj8dXvm2lp04AU+2JA2GweB8sF9Z4ZpEKO6xsA0b0LW286dUfMB0+
   g==;
X-CSE-ConnectionGUID: ZkkOwBu+SdGhZLK+gS796A==
X-CSE-MsgGUID: sRYoHgc3TxSJTh0QCVjNgA==
X-IronPort-AV: E=McAfee;i="6600,9927,11073"; a="11613986"
X-IronPort-AV: E=Sophos;i="6.08,160,1712646000"; 
   d="scan'208";a="11613986"
Received: from fmviesa006.fm.intel.com ([10.60.135.146])
  by fmvoesa113.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 May 2024 18:00:08 -0700
X-CSE-ConnectionGUID: i110ikQjRa6RJzaukZ0gxQ==
X-CSE-MsgGUID: SK7QFYhpSkuSIdoCM5jSfw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.08,160,1712646000"; 
   d="scan'208";a="30942825"
Received: from oyildiz-mobl1.amr.corp.intel.com (HELO rpedgeco-desk4.intel.com) ([10.209.51.34])
  by fmviesa006-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 May 2024 18:00:07 -0700
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
Subject: [PATCH 13/16] KVM: x86/tdp_mmu: Introduce shared, private KVM MMU root types
Date: Tue, 14 May 2024 17:59:49 -0700
Message-Id: <20240515005952.3410568-14-rick.p.edgecombe@intel.com>
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

Add more types, shared and private to enum kvm_tdp_mmu_root_types to
specify KVM MMU roots [1] so that the iterator on the root page table can
consistently filter the root page table type.

TDX KVM will operate on KVM page tables with specified types.  Shared page
table, private page table, or both.  Introduce an enum to specify those
page table types and make the iterator take it with the specified root
type.  Valid or not, and shared, private, or both.  Enhance
tdp_mmu_root_match() to understand private vs shared.

Suggested-by: Sean Christopherson <seanjc@google.com>
Link: https://lore.kernel.org/kvm/ZivazWQw1oCU8VBC@google.com/ [1]
Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
Signed-off-by: Rick Edgecombe <rick.p.edgecombe@intel.com>
---
TDX MMU Part 1:
 - New patch
---
 arch/x86/kvm/mmu/tdp_mmu.c | 12 +++++++++++-
 arch/x86/kvm/mmu/tdp_mmu.h | 14 ++++++++++----
 2 files changed, 21 insertions(+), 5 deletions(-)

diff --git a/arch/x86/kvm/mmu/tdp_mmu.c b/arch/x86/kvm/mmu/tdp_mmu.c
index 7af395073e92..8914c5b0d5ab 100644
--- a/arch/x86/kvm/mmu/tdp_mmu.c
+++ b/arch/x86/kvm/mmu/tdp_mmu.c
@@ -95,10 +95,20 @@ void kvm_tdp_mmu_put_root(struct kvm *kvm, struct kvm_mmu_page *root)
 static bool tdp_mmu_root_match(struct kvm_mmu_page *root,
 			       enum kvm_tdp_mmu_root_types types)
 {
+	if (WARN_ON_ONCE(types == BUGGY_KVM_ROOTS))
+		return false;
+	if (WARN_ON_ONCE(!(types & (KVM_SHARED_ROOTS | KVM_PRIVATE_ROOTS))))
+		return false;
+
 	if ((types & KVM_VALID_ROOTS) && root->role.invalid)
 		return false;
 
-	return true;
+	if ((types & KVM_SHARED_ROOTS) && !is_private_sp(root))
+		return true;
+	if ((types & KVM_PRIVATE_ROOTS) && is_private_sp(root))
+		return true;
+
+	return false;
 }
 
 /*
diff --git a/arch/x86/kvm/mmu/tdp_mmu.h b/arch/x86/kvm/mmu/tdp_mmu.h
index 30f2ab88a642..6a65498b481c 100644
--- a/arch/x86/kvm/mmu/tdp_mmu.h
+++ b/arch/x86/kvm/mmu/tdp_mmu.h
@@ -20,12 +20,18 @@ __must_check static inline bool kvm_tdp_mmu_get_root(struct kvm_mmu_page *root)
 void kvm_tdp_mmu_put_root(struct kvm *kvm, struct kvm_mmu_page *root);
 
 enum kvm_tdp_mmu_root_types {
-	KVM_VALID_ROOTS = BIT(0),
-
-	KVM_ANY_ROOTS = 0,
-	KVM_ANY_VALID_ROOTS = KVM_VALID_ROOTS,
+	BUGGY_KVM_ROOTS = BUGGY_KVM_INVALIDATION,
+	KVM_SHARED_ROOTS = KVM_PROCESS_SHARED,
+	KVM_PRIVATE_ROOTS = KVM_PROCESS_PRIVATE,
+	KVM_VALID_ROOTS = BIT(2),
+	KVM_ANY_VALID_ROOTS = KVM_SHARED_ROOTS | KVM_PRIVATE_ROOTS | KVM_VALID_ROOTS,
+	KVM_ANY_ROOTS = KVM_SHARED_ROOTS | KVM_PRIVATE_ROOTS,
 };
 
+static_assert(!(KVM_SHARED_ROOTS & KVM_VALID_ROOTS));
+static_assert(!(KVM_PRIVATE_ROOTS & KVM_VALID_ROOTS));
+static_assert(KVM_PRIVATE_ROOTS == (KVM_SHARED_ROOTS << 1));
+
 bool kvm_tdp_mmu_zap_leafs(struct kvm *kvm, gfn_t start, gfn_t end, bool flush);
 bool kvm_tdp_mmu_zap_sp(struct kvm *kvm, struct kvm_mmu_page *sp);
 void kvm_tdp_mmu_zap_all(struct kvm *kvm);
-- 
2.34.1


