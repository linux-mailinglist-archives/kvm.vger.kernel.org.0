Return-Path: <kvm+bounces-17401-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 9026F8C5E8A
	for <lists+kvm@lfdr.de>; Wed, 15 May 2024 03:01:36 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id C26DC1C2134E
	for <lists+kvm@lfdr.de>; Wed, 15 May 2024 01:01:35 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C7B2F25777;
	Wed, 15 May 2024 01:00:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="kis8Slub"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 203E0107A6;
	Wed, 15 May 2024 01:00:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.19
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715734808; cv=none; b=Z54P11ETZ2eLP+QsmavJTNbjPiXDh8jCLL6ZV19V6lZEazCcXZZoo+DpbNmnVhmlFXk7ETslbXSgZcIaajncfYh9CMO5YheOV61oofWvTCkmaRSyvXlIXcijQr5zL8mQ5uUZYO9ycPcI3djP75nhffbPP7IcLDkttmgWgzTWXjc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715734808; c=relaxed/simple;
	bh=3riEeBhx8HzcTBEGj7bVXK60LuEYP5+ldqG1Lza6N1w=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=u09Xs/CSPtiFaz3KO1b7K8AB+m7WuPqJv7PsYxRKhKeW4KeGwgoAI3Q7VmapigESVGbraxFkZyojKoAg32gXFoV/cZLK3mVc/hJkpMQ3VTsrbP44/GdQ3zHXoyYPkkxllM4wsolNwdHHd4dFtAWUen3j3mUTzbzDxyd8UH5iTFo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=kis8Slub; arc=none smtp.client-ip=192.198.163.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1715734807; x=1747270807;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=3riEeBhx8HzcTBEGj7bVXK60LuEYP5+ldqG1Lza6N1w=;
  b=kis8SlubXlqWRPw0CjW3BqFRbt9q9lANPwWHjQHLqXv+zwwi1LeD8cEA
   bUw/mYu3ki4UdgDngF8adGDq44jxibmZxuTzDesXM3Guvm9sJfNPwhjlR
   ycpSza3zY6yoiw5w2NydDTFdxlAtaUAypqZskJGmzP4ALPvhB4cDOe+yy
   nFKVv25BgudvMCW3EKpIIWHzj1/E78bp8Gc19Q3aDT++4fLeMrwtkTij5
   BfwvYmsvNjIMh+STOuh6E75Kvejpcgu6UKVK2dWjxNR5aZiAWmdiCakLZ
   HNefuZ3/x6vcmj85eLqEZ3eQvoD4ikx+57hHE3Q8OTduYLAFZpUt4UWK/
   Q==;
X-CSE-ConnectionGUID: Q1eCECccTP2qSzmiFe906g==
X-CSE-MsgGUID: /g9g7oVwSbCnOhZA/HoWTg==
X-IronPort-AV: E=McAfee;i="6600,9927,11073"; a="11613955"
X-IronPort-AV: E=Sophos;i="6.08,160,1712646000"; 
   d="scan'208";a="11613955"
Received: from fmviesa006.fm.intel.com ([10.60.135.146])
  by fmvoesa113.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 May 2024 18:00:04 -0700
X-CSE-ConnectionGUID: hLuB4nMQRHKGeaLU1S3wxQ==
X-CSE-MsgGUID: jkgl2X01RX2y2ngdP0369g==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.08,160,1712646000"; 
   d="scan'208";a="30942747"
Received: from oyildiz-mobl1.amr.corp.intel.com (HELO rpedgeco-desk4.intel.com) ([10.209.51.34])
  by fmviesa006-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 May 2024 18:00:03 -0700
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
Subject: [PATCH 06/16] KVM: x86/mmu: Add a new is_private member for union kvm_mmu_page_role
Date: Tue, 14 May 2024 17:59:42 -0700
Message-Id: <20240515005952.3410568-7-rick.p.edgecombe@intel.com>
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

Introduce a "is_private" member to the kvm_mmu_page_role union to identify
SPTEs associated with the mirrored EPT.

The TDX module maintains the private half of the EPT mapped in the TD in
its protected memory. KVM keeps a copy of the private GPAs in a mirrored
EPT tree within host memory, recording the root page HPA in each vCPU's
mmu->private_root_hpa. This "is_private" attribute enables vCPUs to find
and get the root page of mirrored EPT from the MMU root list for a guest
TD. This also allows KVM MMU code to detect changes in mirrored EPT
according to the "is_private" mmu page role and propagate the changes to
the private EPT managed by TDX module.

Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
Signed-off-by: Rick Edgecombe <rick.p.edgecombe@intel.com>
---
TDX MMU Part 1:
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
index d2f924f1d579..13119d4e44e5 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -351,7 +351,8 @@ union kvm_mmu_page_role {
 		unsigned ad_disabled:1;
 		unsigned guest_mode:1;
 		unsigned passthrough:1;
-		unsigned :5;
+		unsigned is_private:1;
+		unsigned :4;
 
 		/*
 		 * This is left at the top of the word so that
@@ -363,6 +364,16 @@ union kvm_mmu_page_role {
 	};
 };
 
+static inline bool kvm_mmu_page_role_is_private(union kvm_mmu_page_role role)
+{
+	return !!role.is_private;
+}
+
+static inline void kvm_mmu_page_role_set_private(union kvm_mmu_page_role *role)
+{
+	role->is_private = 1;
+}
+
 /*
  * kvm_mmu_extended_role complements kvm_mmu_page_role, tracking properties
  * relevant to the current MMU configuration.   When loading CR0, CR4, or EFER,
diff --git a/arch/x86/kvm/mmu/mmu_internal.h b/arch/x86/kvm/mmu/mmu_internal.h
index 706f0ce8784c..b114589a595a 100644
--- a/arch/x86/kvm/mmu/mmu_internal.h
+++ b/arch/x86/kvm/mmu/mmu_internal.h
@@ -145,6 +145,11 @@ static inline int kvm_mmu_page_as_id(struct kvm_mmu_page *sp)
 	return kvm_mmu_role_as_id(sp->role);
 }
 
+static inline bool is_private_sp(const struct kvm_mmu_page *sp)
+{
+	return kvm_mmu_page_role_is_private(sp->role);
+}
+
 static inline bool kvm_mmu_page_ad_need_write_protect(struct kvm_mmu_page *sp)
 {
 	/*
diff --git a/arch/x86/kvm/mmu/spte.h b/arch/x86/kvm/mmu/spte.h
index 5dd5405fa07a..d0df691ced5c 100644
--- a/arch/x86/kvm/mmu/spte.h
+++ b/arch/x86/kvm/mmu/spte.h
@@ -265,6 +265,11 @@ static inline struct kvm_mmu_page *root_to_sp(hpa_t root)
 	return spte_to_child_sp(root);
 }
 
+static inline bool is_private_sptep(u64 *sptep)
+{
+	return is_private_sp(sptep_to_sp(sptep));
+}
+
 static inline bool is_mmio_spte(struct kvm *kvm, u64 spte)
 {
 	return (spte & shadow_mmio_mask) == kvm->arch.shadow_mmio_value &&
-- 
2.34.1


