Return-Path: <kvm+bounces-20022-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id D52B690F91A
	for <lists+kvm@lfdr.de>; Thu, 20 Jun 2024 00:38:44 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 5F34EB241A0
	for <lists+kvm@lfdr.de>; Wed, 19 Jun 2024 22:38:42 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CA0B4160791;
	Wed, 19 Jun 2024 22:36:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="fUBav+Bk"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D02C615D5AA;
	Wed, 19 Jun 2024 22:36:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718836590; cv=none; b=QzDD9vLO5h914LbqEOlND2Bhc1Sc/VgA+VJLApDBMODNDy3gSNaGCunx3ZchZHs5N/Kisg+TGAAQ6KDz/BkKAaq78UL1pPtQ74RObRFBIipi6RvWa7ngjJTZ3YSp/goN4VN0KpTIhZWd+SVHRjYpid4EUMDSXY/bMM64D0qhBEo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718836590; c=relaxed/simple;
	bh=P/xpmJ/VWG0UWqXBQ4LtNLyFz/OomrsM9WB8JXsA3Wo=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=s3wDnDgEap50HBbJghqaaQfrVHeeYBFk/ZhkQl0UfgCH7xpHEq5AmIsjq5f/KJ5qBnm9bJh2GbAFdjblopwFPlUeSGW7smSIkxnl6xBCuRqnOFqxzy4hZ9ezaNswdpdOBQx2wIMBK93OwvnSvbpUkfLiTxigtS09L973T3FY4vk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=fUBav+Bk; arc=none smtp.client-ip=198.175.65.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1718836588; x=1750372588;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=P/xpmJ/VWG0UWqXBQ4LtNLyFz/OomrsM9WB8JXsA3Wo=;
  b=fUBav+Bklyjo85LJ8JiqraZZhQ/lLtNoXKPXLnXiGsD5wLxx6LYpAYo9
   3MUNukFxAXyiPu+VO92jA6JKcQY4fdd81lm6TMmYHqOFHghVuYO3rFYTi
   htJt1yPhdabkQJJTJpu2l/ADM3hZAjXeGnX+sy5t4ZwAnaM1UkemkQwiJ
   0kK/rCD6MZSi+SoFSBlSUftu0o+ayCnzyAeQylAU3SF0ylg5mZuC01/Cr
   +FqkKd7MRABNyK+sfqSgpbF4SmjAFQgnN7Gmhib3E//hOpTwPFeXqygwV
   sCB/YozeyhiHqOE/Z3Fio0fYYWklmM1njTQD0VJVKUQI6v8ZwZeLyLIVj
   g==;
X-CSE-ConnectionGUID: zFvf2pIISo6e5U7luqJuNw==
X-CSE-MsgGUID: WCrzS4qxRUyQM5vzJ0DeUA==
X-IronPort-AV: E=McAfee;i="6700,10204,11108"; a="15931946"
X-IronPort-AV: E=Sophos;i="6.08,251,1712646000"; 
   d="scan'208";a="15931946"
Received: from orviesa002.jf.intel.com ([10.64.159.142])
  by orvoesa110.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Jun 2024 15:36:21 -0700
X-CSE-ConnectionGUID: 8KXdDHpEQ0ueMFUHnC/GZw==
X-CSE-MsgGUID: 6rrnuRMASUGhnqUZTSA8Jw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.08,251,1712646000"; 
   d="scan'208";a="72793333"
Received: from ivsilic-mobl2.amr.corp.intel.com (HELO rpedgeco-desk4.intel.com) ([10.209.54.39])
  by orviesa002-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Jun 2024 15:36:21 -0700
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
Subject: [PATCH v3 05/17] KVM: x86/mmu: Add an is_mirror member for union kvm_mmu_page_role
Date: Wed, 19 Jun 2024 15:36:02 -0700
Message-Id: <20240619223614.290657-6-rick.p.edgecombe@intel.com>
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

Introduce a "is_mirror" member to the kvm_mmu_page_role union to identify
SPTEs associated with the mirrored EPT.

The TDX module maintains the private half of the EPT mapped in the TD in
its protected memory. KVM keeps a copy of the private GPAs in a mirrored
EPT tree within host memory. This "is_mirror" attribute enables vCPUs to
find and get the root page of mirrored EPT from the MMU root list for a
guest TD. This also allows KVM MMU code to detect changes in mirrored EPT
according to the "is_mirror" mmu page role and propagate the changes to
the private EPT managed by TDX module.

Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
Signed-off-by: Rick Edgecombe <rick.p.edgecombe@intel.com>
---
TDX MMU Prep v3:
 - Rename role mirror_pt -> is_mirror (Paolo)
 - Remove unnessary helpers that just access a member (Paolo)

TDX MMU Prep v2:
 - Rename private -> mirrored

TDX MMU Prep:
- Remove warning and NULL check in is_private_sptep() (Rick)
- Update commit log (Yan)

v19:
- Fix is_private_sptep() when NULL case.
- drop CONFIG_KVM_MMU_PRIVATE
---
 arch/x86/include/asm/kvm_host.h | 3 ++-
 arch/x86/kvm/mmu/mmu_internal.h | 5 +++++
 arch/x86/kvm/mmu/spte.h         | 5 +++++
 3 files changed, 12 insertions(+), 1 deletion(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 9e35fe32f500..6c59b129f382 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -351,7 +351,8 @@ union kvm_mmu_page_role {
 		unsigned ad_disabled:1;
 		unsigned guest_mode:1;
 		unsigned passthrough:1;
-		unsigned :5;
+		unsigned is_mirror:1;
+		unsigned :4;
 
 		/*
 		 * This is left at the top of the word so that
diff --git a/arch/x86/kvm/mmu/mmu_internal.h b/arch/x86/kvm/mmu/mmu_internal.h
index d2837f796f34..5a2c9be23627 100644
--- a/arch/x86/kvm/mmu/mmu_internal.h
+++ b/arch/x86/kvm/mmu/mmu_internal.h
@@ -157,6 +157,11 @@ static inline int kvm_mmu_page_as_id(struct kvm_mmu_page *sp)
 	return kvm_mmu_role_as_id(sp->role);
 }
 
+static inline bool is_mirror_sp(const struct kvm_mmu_page *sp)
+{
+	return sp->role.is_mirror;
+}
+
 static inline void kvm_mmu_alloc_external_spt(struct kvm_vcpu *vcpu, struct kvm_mmu_page *sp)
 {
 	/*
diff --git a/arch/x86/kvm/mmu/spte.h b/arch/x86/kvm/mmu/spte.h
index 86e5259aa824..4883d139761b 100644
--- a/arch/x86/kvm/mmu/spte.h
+++ b/arch/x86/kvm/mmu/spte.h
@@ -265,6 +265,11 @@ static inline struct kvm_mmu_page *root_to_sp(hpa_t root)
 	return spte_to_child_sp(root);
 }
 
+static inline bool is_mirror_sptep(u64 *sptep)
+{
+	return is_mirror_sp(sptep_to_sp(sptep));
+}
+
 static inline bool is_mmio_spte(struct kvm *kvm, u64 spte)
 {
 	return (spte & shadow_mmio_mask) == kvm->arch.shadow_mmio_value &&
-- 
2.34.1


