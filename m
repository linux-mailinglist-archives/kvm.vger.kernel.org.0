Return-Path: <kvm+bounces-18441-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id C7C058D5433
	for <lists+kvm@lfdr.de>; Thu, 30 May 2024 23:08:35 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id F37241C2298A
	for <lists+kvm@lfdr.de>; Thu, 30 May 2024 21:08:34 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8B2C1186280;
	Thu, 30 May 2024 21:07:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="kfAzZenM"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3291D17F4E0;
	Thu, 30 May 2024 21:07:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.10
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717103255; cv=none; b=rAxQbwyczOhI0J8sxyx3MUqYXO+SDfftbALWMDMcqQ3RVfaq/7ZJ8hWxyv1RnSS1Fdz58xHuT+pCw78CH5TuEuQfnjSme14TH2qPO1nYG1GGEw8TzALMs729LWpoqui3yPnZm3iPdXY9broXnjR4TnK2gKwgL6dFba6JTN4NC9s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717103255; c=relaxed/simple;
	bh=obPtbUnxNt43x6reWoyb4ohHWGS9ansaXpugJHDkDqY=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=ed4jS4V1w2h593NEZoTkoJfVWxubUh/30zL5Th0urg1M+yC8P2Q/60gwtifUfvE/w8RztBZslfiClpyLdGCUCueJqEnT3Fqm9MLspHPyfqUsJY8p23PJ0TH7F4yuTetwVl/0CzyNNFyzGr2Kq0rH2yJT0UJ4z3a/gWrT8PXkLrk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=kfAzZenM; arc=none smtp.client-ip=198.175.65.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1717103254; x=1748639254;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=obPtbUnxNt43x6reWoyb4ohHWGS9ansaXpugJHDkDqY=;
  b=kfAzZenMtpkhlQnG2rI5MyRiwRHQzjAtcHjlr3NFbfxtIiME7nc8I59Y
   Qh/g/1696cf4BEw0RB1/2ss35KeooOZNdvQ1MbxNk65X3ki6PzP1CwbAM
   dlY6SOQl6qQtNQVTLJ/ZPGI4n/b2yK5aIFFSEr+H9TRmsLYKcLX6KN0VJ
   jsh6wDMmU5nPOXgEo+niIxbs4Vt58HxiEROh3YBK30kdrzwCtpO+5s8H8
   7nlbuo+8hvlWW9XOrA96qDuxAIf50j25rkJlsX4WMBt64boY/uRUdlhw9
   wmyuWzKhsJ9CgiRzPY0ezUWOXwJxyO3UPR84vv9d1WLiRtSGs8LDDja2r
   Q==;
X-CSE-ConnectionGUID: qzBwBnHlQuetOKnlQR+qbA==
X-CSE-MsgGUID: mj5usqbaQZCFGbb56Cf2aw==
X-IronPort-AV: E=McAfee;i="6600,9927,11088"; a="31117094"
X-IronPort-AV: E=Sophos;i="6.08,202,1712646000"; 
   d="scan'208";a="31117094"
Received: from fmviesa007.fm.intel.com ([10.60.135.147])
  by orvoesa102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 May 2024 14:07:32 -0700
X-CSE-ConnectionGUID: DN1ieylEQouHbUW1/aHpJQ==
X-CSE-MsgGUID: SyoSlZ7RRRa8+7po4Vh8KQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.08,202,1712646000"; 
   d="scan'208";a="35874416"
Received: from hding1-mobl.ccr.corp.intel.com (HELO rpedgeco-desk4.intel.com) ([10.209.19.65])
  by fmviesa007-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 May 2024 14:07:32 -0700
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
Subject: [PATCH v2 04/15] KVM: x86/mmu: Add a new mirror_pt member for union kvm_mmu_page_role
Date: Thu, 30 May 2024 14:07:03 -0700
Message-Id: <20240530210714.364118-5-rick.p.edgecombe@intel.com>
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

Introduce a "mirror_pt" member to the kvm_mmu_page_role union to identify
SPTEs associated with the mirrored EPT.

The TDX module maintains the private half of the EPT mapped in the TD in
its protected memory. KVM keeps a copy of the private GPAs in a mirrored
EPT tree within host memory. This "mirror_pt" attribute enables vCPUs to
find and get the root page of mirrored EPT from the MMU root list for a
guest TD. This also allows KVM MMU code to detect changes in mirrored EPT
according to the "mirror_pt" mmu page role and propagate the changes to
the private EPT managed by TDX module.

Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
Signed-off-by: Rick Edgecombe <rick.p.edgecombe@intel.com>
---
TDX MMU Prep v2:
 - Rename private -> mirrored

TDX MMU Prep:
- Remove warning and NULL check in is_private_sptep() (Rick)
- Update commit log (Yan)

v19:
- Fix is_private_sptep() when NULL case.
- drop CONFIG_KVM_MMU_PRIVATE
---
 arch/x86/include/asm/kvm_host.h | 13 ++++++++++++-
 arch/x86/kvm/mmu/mmu_internal.h |  5 +++++
 arch/x86/kvm/mmu/spte.h         |  5 +++++
 3 files changed, 22 insertions(+), 1 deletion(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 250899a0239b..084f4708aff1 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -351,7 +351,8 @@ union kvm_mmu_page_role {
 		unsigned ad_disabled:1;
 		unsigned guest_mode:1;
 		unsigned passthrough:1;
-		unsigned :5;
+		unsigned mirror_pt:1;
+		unsigned :4;
 
 		/*
 		 * This is left at the top of the word so that
@@ -363,6 +364,16 @@ union kvm_mmu_page_role {
 	};
 };
 
+static inline bool kvm_mmu_page_role_is_mirror(union kvm_mmu_page_role role)
+{
+	return !!role.mirror_pt;
+}
+
+static inline void kvm_mmu_page_role_set_mirrored(union kvm_mmu_page_role *role)
+{
+	role->mirror_pt = 1;
+}
+
 /*
  * kvm_mmu_extended_role complements kvm_mmu_page_role, tracking properties
  * relevant to the current MMU configuration.   When loading CR0, CR4, or EFER,
diff --git a/arch/x86/kvm/mmu/mmu_internal.h b/arch/x86/kvm/mmu/mmu_internal.h
index faef40a561f9..6d82e389cd65 100644
--- a/arch/x86/kvm/mmu/mmu_internal.h
+++ b/arch/x86/kvm/mmu/mmu_internal.h
@@ -157,6 +157,11 @@ static inline int kvm_mmu_page_as_id(struct kvm_mmu_page *sp)
 	return kvm_mmu_role_as_id(sp->role);
 }
 
+static inline bool is_mirror_sp(const struct kvm_mmu_page *sp)
+{
+	return kvm_mmu_page_role_is_mirror(sp->role);
+}
+
 static inline void *kvm_mmu_mirrored_spt(struct kvm_mmu_page *sp)
 {
 	return sp->mirrored_spt;
diff --git a/arch/x86/kvm/mmu/spte.h b/arch/x86/kvm/mmu/spte.h
index 5dd5405fa07a..b3c065280ba1 100644
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


