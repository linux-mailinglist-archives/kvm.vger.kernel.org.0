Return-Path: <kvm+bounces-21887-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 0F06A9352FA
	for <lists+kvm@lfdr.de>; Thu, 18 Jul 2024 23:14:12 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 8E415B21DC4
	for <lists+kvm@lfdr.de>; Thu, 18 Jul 2024 21:14:09 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 62ED41474BA;
	Thu, 18 Jul 2024 21:12:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="jnmQPZT6"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.15])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F257B146A9B;
	Thu, 18 Jul 2024 21:12:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.15
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721337169; cv=none; b=nBcEATm2ogoaHGKQ4CpwlIqu0NxomfJOgYMjcFJ1NXWGKzX6ue0sAJqZuwGaI/FFPhss0352m/3BmjEZh/Z5A1usa1el7aSGj3bGNLUtghTaGxeK0aPKFN796e8UH+HDigC9tVVGNA26X6KPpTr/gwtdwXwjOm8uAg31j8MmRLY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721337169; c=relaxed/simple;
	bh=SBvf9S0EhqB8FK0uuYH+CPawVD501/FTiaC8zBC9RBo=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=EFmSGd0afWPCUQedPQK2YhUqwt14Y8Tf8jlzLEmjmtgnAIx/go4FP1iqHpMErW6GSGtE5XpGXBU83nAqeTyURV/Bk6Dv0qKQlFU2sWdixBeFu4yWQOvfyk/ww8u4nLWipBx2AHsetVQ70I1I8SAB3Iko1J5rghuzjLCIVtmY/V0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=jnmQPZT6; arc=none smtp.client-ip=198.175.65.15
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1721337168; x=1752873168;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=SBvf9S0EhqB8FK0uuYH+CPawVD501/FTiaC8zBC9RBo=;
  b=jnmQPZT6H3McSWfNQ7gVPRLL7r0xpqiOY2y7wS9LDhDvgQs9URopLRt0
   sc/zFz8IRlx3VFwgDvnCQB3ghcwycMzPyTHBiQaUfPlC+UBCJwAwESv9f
   m4moy3nx7bBk39FySe3vpVVvU0uiWt/wEZxrVIo85nPn0Dzk1ZFveUiZu
   erY6kZ7eUOlU9RFziJBJjQaQ9EGW8zzPh1mawICvAGmF8P77o7IzPAgff
   Bs+LMxBKTNL1JrHQO/jQF5kOl83xgYpP6d59DQvyWpHwWNTzGSJN9fJwB
   dtxmfm7fXxVF4IPFk7ewrGh+BEic/IhU3NtnZy56I6p2K4wqObXUkk6d1
   A==;
X-CSE-ConnectionGUID: YwFJpdYvTnedTxpnY3tl0A==
X-CSE-MsgGUID: nWdstOe/T569NekDMJoXjQ==
X-IronPort-AV: E=McAfee;i="6700,10204,11137"; a="22697409"
X-IronPort-AV: E=Sophos;i="6.09,218,1716274800"; 
   d="scan'208";a="22697409"
Received: from orviesa003.jf.intel.com ([10.64.159.143])
  by orvoesa107.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Jul 2024 14:12:44 -0700
X-CSE-ConnectionGUID: ZaD1Z0ovTgaKEpR7r3Azow==
X-CSE-MsgGUID: e8Y7W5V3S0aa86I68HiMDA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.09,218,1716274800"; 
   d="scan'208";a="55760381"
Received: from ccbilbre-mobl3.amr.corp.intel.com (HELO rpedgeco-desk4..) ([10.124.223.76])
  by ORVIESA003-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Jul 2024 14:12:43 -0700
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
Subject: [PATCH v4 05/18] KVM: x86/mmu: Add an is_mirror member for union kvm_mmu_page_role
Date: Thu, 18 Jul 2024 14:12:17 -0700
Message-Id: <20240718211230.1492011-6-rick.p.edgecombe@intel.com>
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
v3:
 - Rename role mirror_pt -> is_mirror (Paolo)
 - Remove unnessary helpers that just access a member (Paolo)

v2:
 - Rename private -> mirrored

v1:
- Remove warning and NULL check in is_private_sptep() (Rick)
- Update commit log (Yan)
---
 arch/x86/include/asm/kvm_host.h | 3 ++-
 arch/x86/kvm/mmu/mmu_internal.h | 5 +++++
 arch/x86/kvm/mmu/spte.h         | 5 +++++
 3 files changed, 12 insertions(+), 1 deletion(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 09aa2c56bab6..f764a07a32f9 100644
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
index 68f99d9d6e7c..3319d0a42f36 100644
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
index ef793c459b05..a72f0e3bde17 100644
--- a/arch/x86/kvm/mmu/spte.h
+++ b/arch/x86/kvm/mmu/spte.h
@@ -267,6 +267,11 @@ static inline struct kvm_mmu_page *root_to_sp(hpa_t root)
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


