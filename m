Return-Path: <kvm+bounces-18444-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 6D2B08D5438
	for <lists+kvm@lfdr.de>; Thu, 30 May 2024 23:09:32 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id C596FB25233
	for <lists+kvm@lfdr.de>; Thu, 30 May 2024 21:09:29 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id ADAAE190680;
	Thu, 30 May 2024 21:07:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="b4l/jQDG"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 33591183996;
	Thu, 30 May 2024 21:07:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.10
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717103257; cv=none; b=giRNA/HMiLh9kTYWDGdheQgplx5D5CyvQGWLuSQ08O6y5v33WfNZ7yjMNFypmA7eaRaWn1XRqrJ0N2YJybMycVZVQG8kzWOnBrwww5JNgKp6Lkcb3af7RbTyk6vxL707BhcyDk7MfQIY0tS8XQm3qkxYOrJ7TVobgFaclUjFCG4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717103257; c=relaxed/simple;
	bh=/CD6I0QgOfsuCvTGL7/JUd7uU7BlYectRMf0iYH407Y=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=c9EzvNeTAISNtM+H9ah9Oe2XR6gIjVjgxkXU3Hac/ai9xg+91sRmhKO2KCaaGf/Wnhgwon+VHsiefjZ/2V1WKPgHNMI9JUbOxPVhIE85RTvycJDdqeSelIwDVbQ6Z1SicvAYcgegOtCDM6+amtijtQEc2KJ0OfswE7sErZi6lZw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=b4l/jQDG; arc=none smtp.client-ip=198.175.65.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1717103256; x=1748639256;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=/CD6I0QgOfsuCvTGL7/JUd7uU7BlYectRMf0iYH407Y=;
  b=b4l/jQDG82BmAYKnYFGWGP1cWgrmpqgIxHfcZu2puya2JXrI+4JSUVRI
   TMSYeLIKgECStnqTTCJltcNbIc++NWuLgi+lh5VuNdtdUwcmCpa+pEq9D
   8/pFoWgWEjpMzfOavJrzDzEAIHyS7ccX/bOBw4S3agT9TQYk4oIVCkinR
   mBrVKgTReHDqTYKnnSan6BNiEu8EaNo4eVw1NMEvmIFt7T7o9WB8RMPin
   qIWjpZx9g+fov+QxiSX2RtMNLSybg232y9U9V1rJnJ2uzKGfJ2MZnSzHX
   05cDsCCX9vFtI/PyVkIiFxH3Hqavh96EIT8M62bi2YL2JGfJHKxK5n1+D
   w==;
X-CSE-ConnectionGUID: mbSqxLo/RACrMj59CPVSTw==
X-CSE-MsgGUID: qp1qsts8SCC8m1a9wmKdQg==
X-IronPort-AV: E=McAfee;i="6600,9927,11088"; a="31117113"
X-IronPort-AV: E=Sophos;i="6.08,202,1712646000"; 
   d="scan'208";a="31117113"
Received: from fmviesa007.fm.intel.com ([10.60.135.147])
  by orvoesa102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 May 2024 14:07:36 -0700
X-CSE-ConnectionGUID: DKA30Iv4R7qvB3duYmjZQw==
X-CSE-MsgGUID: SMt5W75FTKKd+62RlwNPjA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.08,202,1712646000"; 
   d="scan'208";a="35874435"
Received: from hding1-mobl.ccr.corp.intel.com (HELO rpedgeco-desk4.intel.com) ([10.209.19.65])
  by fmviesa007-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 May 2024 14:07:36 -0700
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
Subject: [PATCH v2 07/15] KVM: x86/tdp_mmu: Extract root invalid check from tdx_mmu_next_root()
Date: Thu, 30 May 2024 14:07:06 -0700
Message-Id: <20240530210714.364118-8-rick.p.edgecombe@intel.com>
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

Extract tdp_mmu_root_match() to check if the root has given types and use
it for the root page table iterator.  It checks only_invalid now.

TDX KVM operates on a shared page table only (Shared-EPT), a mirrored page
table only (Secure-EPT), or both based on the operation.  KVM MMU notifier
operations only on shared page table.  KVM guest_memfd invalidation
operations only on mirrored page table, and so on.  Introduce a centralized
matching function instead of open coding matching logic in the iterator.
The next step is to extend the function to check whether the page is shared
or private

Link: https://lore.kernel.org/kvm/ZivazWQw1oCU8VBC@google.com/
Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
Signed-off-by: Rick Edgecombe <rick.p.edgecombe@intel.com>
---
TDX MMU Prep:
 - New patch
---
 arch/x86/kvm/mmu/tdp_mmu.c | 12 ++++++++++--
 1 file changed, 10 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kvm/mmu/tdp_mmu.c b/arch/x86/kvm/mmu/tdp_mmu.c
index ed93bba76483..d49abf1e3f37 100644
--- a/arch/x86/kvm/mmu/tdp_mmu.c
+++ b/arch/x86/kvm/mmu/tdp_mmu.c
@@ -92,6 +92,14 @@ void kvm_tdp_mmu_put_root(struct kvm *kvm, struct kvm_mmu_page *root)
 	call_rcu(&root->rcu_head, tdp_mmu_free_sp_rcu_callback);
 }
 
+static bool tdp_mmu_root_match(struct kvm_mmu_page *root, bool only_valid)
+{
+	if (only_valid && root->role.invalid)
+		return false;
+
+	return true;
+}
+
 /*
  * Returns the next root after @prev_root (or the first root if @prev_root is
  * NULL).  A reference to the returned root is acquired, and the reference to
@@ -125,7 +133,7 @@ static struct kvm_mmu_page *tdp_mmu_next_root(struct kvm *kvm,
 						   typeof(*next_root), link);
 
 	while (next_root) {
-		if ((!only_valid || !next_root->role.invalid) &&
+		if (tdp_mmu_root_match(next_root, only_valid) &&
 		    kvm_tdp_mmu_get_root(next_root))
 			break;
 
@@ -176,7 +184,7 @@ static struct kvm_mmu_page *tdp_mmu_next_root(struct kvm *kvm,
 	list_for_each_entry(_root, &_kvm->arch.tdp_mmu_roots, link)		\
 		if (kvm_lockdep_assert_mmu_lock_held(_kvm, false) &&		\
 		    ((_as_id >= 0 && kvm_mmu_page_as_id(_root) != _as_id) ||	\
-		     ((_only_valid) && (_root)->role.invalid))) {		\
+		     !tdp_mmu_root_match((_root), (_only_valid)))) {		\
 		} else
 
 #define for_each_tdp_mmu_root(_kvm, _root, _as_id)			\
-- 
2.34.1


