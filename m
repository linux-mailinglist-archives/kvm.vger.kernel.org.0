Return-Path: <kvm+bounces-20024-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 94A9190F91F
	for <lists+kvm@lfdr.de>; Thu, 20 Jun 2024 00:39:25 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 1D13FB2150B
	for <lists+kvm@lfdr.de>; Wed, 19 Jun 2024 22:39:23 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4CADA1684AD;
	Wed, 19 Jun 2024 22:36:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="cPefVl+f"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BB4D615F412;
	Wed, 19 Jun 2024 22:36:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718836591; cv=none; b=dxt7h5AFyJiugBgwPeWXQ1zAmgMKVywPOVrBYYPd8uiPev+jSHnRSR9r+sy+SfD5xUddFVbfHsCnUQl5lj/2mSYO0mrUZWKCt29sN2qZshlfvvE99wpqHuK/LjKmJ4VBf32mhg53lb4caSUu/CfvTJkiVFz+G41sMeHIemUDdJg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718836591; c=relaxed/simple;
	bh=ZlIb92BMB80InpzZaKVXT9xYdBdfZ5FxKMSdfWqrTw0=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=j/RPK+oVvHw7XlfK36/Bgnkp/7CDrXGFgd7palcPXzB2ONYwrOpvE+tLr0CLaylSgOqEzZEyxwHO6viLPX4u15XVYwzs126NBp4r/b3Bykn4HAaKkxeFNZh0HFx7m7LI/1AIGkdV9KQuyz5D0yh/AzLkZCHw4/Ul86KfJIvUMSs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=cPefVl+f; arc=none smtp.client-ip=198.175.65.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1718836590; x=1750372590;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=ZlIb92BMB80InpzZaKVXT9xYdBdfZ5FxKMSdfWqrTw0=;
  b=cPefVl+fW59IQ5q5mC7IGQVjdskdo0qr9Sml5GjBI5D9fYF+atlSmQUv
   cakNLy8TwEluKjMGVh8stYQEToq6p7ezrkPw+a6m3vcQ2zGtIvGr68NBd
   0iqeYN4WhzCrsL3CnH0UJUhW2o4X/MFmsKDnXJV0R/lANHaNUoTI7DAYx
   UFq1h3qegoAg5BFsZrZS1hKAJ7J7S3K3N5sXP5jGsXZMOfIm1khnSB7kV
   PZyELG/Kny34RhJFnjbD3UsvKYYP6iyrGM9QMKkAAyw1qSRLWErzg5Z5W
   mvk5meDnVoFmaYT16fzmOfOLpvRagmzdeDO077wkBJaeuTX0VMNbM8bWB
   Q==;
X-CSE-ConnectionGUID: LF/NTc8JRPG/Eg/CiDrsXw==
X-CSE-MsgGUID: KW91Jr0QTx26814zL5+Nrg==
X-IronPort-AV: E=McAfee;i="6700,10204,11108"; a="15931973"
X-IronPort-AV: E=Sophos;i="6.08,251,1712646000"; 
   d="scan'208";a="15931973"
Received: from orviesa002.jf.intel.com ([10.64.159.142])
  by orvoesa110.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Jun 2024 15:36:22 -0700
X-CSE-ConnectionGUID: ITPKL5KXQ7+OcmjS+VqW2A==
X-CSE-MsgGUID: SCJ2EYcbQ9e+D1Whi5+gyg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.08,251,1712646000"; 
   d="scan'208";a="72793353"
Received: from ivsilic-mobl2.amr.corp.intel.com (HELO rpedgeco-desk4.intel.com) ([10.209.54.39])
  by orviesa002-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Jun 2024 15:36:22 -0700
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
Subject: [PATCH v3 10/17] KVM: x86/tdp_mmu: Extract root invalid check from tdx_mmu_next_root()
Date: Wed, 19 Jun 2024 15:36:07 -0700
Message-Id: <20240619223614.290657-11-rick.p.edgecombe@intel.com>
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
index 067249dbbb5e..cecc25947001 100644
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


