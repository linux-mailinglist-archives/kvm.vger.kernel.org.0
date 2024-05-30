Return-Path: <kvm+bounces-18451-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id B96FD8D544A
	for <lists+kvm@lfdr.de>; Thu, 30 May 2024 23:11:40 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 6720E2828B6
	for <lists+kvm@lfdr.de>; Thu, 30 May 2024 21:11:39 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CEB2B1C0DC1;
	Thu, 30 May 2024 21:07:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="PER7bfOK"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4135619DF50;
	Thu, 30 May 2024 21:07:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.10
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717103263; cv=none; b=j72xYxrDb9PYGKZlM0xXRDa8inN5TcW383twKfUDvvF3qABgbGOZooifB9/GP+2zDvWD2HjLiVasXzSmDXYeTJAQWSEW2oFFbZZq2Te4oLPlSIdkaB6qevcpV8zbVRRO2kN8/D+Faz/QsExow6qPHTIsF7KV86M1GvreRsil23g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717103263; c=relaxed/simple;
	bh=9Pp24bLY4xVx3GW7EU2BvX+0wB/y+K+Bs5JHcdnD6yQ=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=u9tY0eycPQqdXDf+BdMNH+Fi45iBBwFoDJU5RWBW90o44pu8At4aHrtxrnmZU/0g0Rm+BB6GcdHqrBYuBy3OKG0j5EySVN8+gFVDyIbPlfqvZcT8TIsob/Wjw/MoaJPK99m9NV4HS8d5uffE15VWFlKXs+3F7HnfnGtzYp3TE3s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=PER7bfOK; arc=none smtp.client-ip=198.175.65.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1717103261; x=1748639261;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=9Pp24bLY4xVx3GW7EU2BvX+0wB/y+K+Bs5JHcdnD6yQ=;
  b=PER7bfOK1K77HPpdMAE4NhTAigHT4Wv+E30TvTXrHKhw8+J/mDOdLgw4
   adVH8M5bGdGvMHCfoZlBDWTBzzcxcKOHL6rBOkX4rXVwMiNEhUZLbxJ8h
   lrqbJbZTzly56Lb+9PHtvwdKB2Zk6hP4VT5K3RYPAUPyqdJZoNHyqITQt
   Ji89o1hFrz2+qsIzjLqMeQ5bqGWe4N+7yVeO3j1cK/Ozv1QXcRpwzTIV5
   O7FlTsegRtRb3GgAIQghAgYDiwmJQbswz7T6O6KcVsszfd3vQLQ67Fo/i
   EtdH+wUn43GthjtYMJKHUCJWWGxZHyQpViT3eWIjWKHytVfRlhyl76yCK
   g==;
X-CSE-ConnectionGUID: mGmHatQGSWinrVOV+PsESQ==
X-CSE-MsgGUID: tWcVqgYlSIGjd99Fu1r2Yg==
X-IronPort-AV: E=McAfee;i="6600,9927,11088"; a="31117156"
X-IronPort-AV: E=Sophos;i="6.08,202,1712646000"; 
   d="scan'208";a="31117156"
Received: from fmviesa007.fm.intel.com ([10.60.135.147])
  by orvoesa102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 May 2024 14:07:40 -0700
X-CSE-ConnectionGUID: zuF5gxscS7eV/OY7LybPWQ==
X-CSE-MsgGUID: hkGzcDBoTKilD7JNRk5bWw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.08,202,1712646000"; 
   d="scan'208";a="35874466"
Received: from hding1-mobl.ccr.corp.intel.com (HELO rpedgeco-desk4.intel.com) ([10.209.19.65])
  by fmviesa007-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 May 2024 14:07:40 -0700
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
	Sean Christopherson <sean.j.christopherson@intel.com>,
	Isaku Yamahata <isaku.yamahata@intel.com>
Subject: [PATCH v2 14/15] KVM: x86/tdp_mmu: Invalidate correct roots
Date: Thu, 30 May 2024 14:07:13 -0700
Message-Id: <20240530210714.364118-15-rick.p.edgecombe@intel.com>
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

From: Sean Christopherson <sean.j.christopherson@intel.com>

When invalidating roots, respect the root type passed.

kvm_tdp_mmu_invalidate_roots() is called with different root types. For
kvm_mmu_zap_all_fast() it only operates on shared roots. But when tearing
down a VM it needs to invalidate all roots. Check the root type in root
iterator.

Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
Co-developed-by: Isaku Yamahata <isaku.yamahata@intel.com>
Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
[evolved quite a bit from original author's patch]
Co-developed-by: Rick Edgecombe <rick.p.edgecombe@intel.com>
Signed-off-by: Rick Edgecombe <rick.p.edgecombe@intel.com>
---
TDX MMU Prep:
 - Rename from "Don't zap private pages for unsupported cases", and split
   many parts out.
 - Don't support MTRR, apic zapping (Rick)
 - Detangle private/shared alias logic in kvm_tdp_mmu_unmap_gfn_range()
   (Rick)
 - Fix TLB flushing bug debugged by (Chao Gao)
   https://lore.kernel.org/kvm/Zh8yHEiOKyvZO+QR@chao-email/
 - Split out MTRR part
 - Use enum based root iterators (Sean)
 - Reorder logic in kvm_mmu_zap_memslot_leafs().
 - Replace skip_private with enum kvm_tdp_mmu_root_type.
---
 arch/x86/kvm/mmu/tdp_mmu.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/arch/x86/kvm/mmu/tdp_mmu.c b/arch/x86/kvm/mmu/tdp_mmu.c
index da6024b8295f..0caa1029b6bd 100644
--- a/arch/x86/kvm/mmu/tdp_mmu.c
+++ b/arch/x86/kvm/mmu/tdp_mmu.c
@@ -1135,6 +1135,7 @@ void kvm_tdp_mmu_zap_invalidated_roots(struct kvm *kvm)
 void kvm_tdp_mmu_invalidate_roots(struct kvm *kvm,
 				  enum kvm_process process_types)
 {
+	enum kvm_tdp_mmu_root_types root_types = kvm_process_to_root_types(kvm, process_types);
 	struct kvm_mmu_page *root;
 
 	/*
@@ -1158,6 +1159,9 @@ void kvm_tdp_mmu_invalidate_roots(struct kvm *kvm,
 	 * or get/put references to roots.
 	 */
 	list_for_each_entry(root, &kvm->arch.tdp_mmu_roots, link) {
+		if (!tdp_mmu_root_match(root, root_types))
+			continue;
+
 		/*
 		 * Note, invalid roots can outlive a memslot update!  Invalid
 		 * roots must be *zapped* before the memslot update completes,
-- 
2.34.1


