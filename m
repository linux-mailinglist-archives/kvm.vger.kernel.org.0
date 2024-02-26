Return-Path: <kvm+bounces-9768-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 635D9866DE2
	for <lists+kvm@lfdr.de>; Mon, 26 Feb 2024 10:15:16 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 93D751C2162E
	for <lists+kvm@lfdr.de>; Mon, 26 Feb 2024 09:15:15 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4905813664A;
	Mon, 26 Feb 2024 08:29:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="m91SWsCt"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BAC9B1353EE;
	Mon, 26 Feb 2024 08:29:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.10
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708936197; cv=none; b=nG6C/Pg9ZyF3+QF7ukdDWfEDyiOAi2T+VjGTAPbKMP5mgnk9oY4fF9pqnC64We1L6hk4eQywwRdxn1P4WrDVllitXjHQ5cijA0B9GJwoPmWEuJONDFZ4e0FIMemwkqHWQqAQoYbTQY+GUNvpVYBjcQns9hLmM/eVRkfXQSBYYXk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708936197; c=relaxed/simple;
	bh=dO1PBJiymwhAoqOQlpC9i+z46NWUa5VVHxrGTwyy1RQ=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=fHhgBQ9ljtmcxfg9iC5SZTw7CBHbJ2GBkYKjK3onTyHJYJqDOLv9xavo7uHYEEPraD0p3ETV0XxC5DXvWjmp+vikHd8n1ri+WAMjw17gq3zGTAl4f6NPapGPmBC/qNxra9SxBXc5OwDFAqc9YuwpOIJuyOIiO4ZIFlvYb1IitA0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=m91SWsCt; arc=none smtp.client-ip=192.198.163.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1708936196; x=1740472196;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=dO1PBJiymwhAoqOQlpC9i+z46NWUa5VVHxrGTwyy1RQ=;
  b=m91SWsCtSnzLOtQWK2fkYgMAG6TOnLUc/4mvOZgtc/9I8gU+bEtPdm1m
   tFCDORSARgcdQ6ADMtcpzwRYBVtNyGfksoVKTul71VP9AkRXkVIGGGv5A
   DKRVmwkKujlzFbmpkrhAp8egZIxNFym5ZJ1z8rlScx0dAguvF9kqMSHtf
   +eS+M0fg7Cy9nHpJy9b19nkNDDyRgWZ6n3WCkBNTxhnm2bkWF8zkNxouV
   XqCBOoy54Q01omCvYJXn24dPVlSoFkhs4xqc6cG7gyyU/9NZJghvNbTeB
   BP5KOlrSFZD87f6JxxIIyuimEB3S0KDQPFwdiNeBpXzHp735MWk7HLbM0
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10995"; a="14623341"
X-IronPort-AV: E=Sophos;i="6.06,185,1705392000"; 
   d="scan'208";a="14623341"
Received: from fmviesa009.fm.intel.com ([10.60.135.149])
  by fmvoesa104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Feb 2024 00:29:37 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.06,185,1705392000"; 
   d="scan'208";a="6519439"
Received: from ls.sc.intel.com (HELO localhost) ([172.25.112.31])
  by fmviesa009-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Feb 2024 00:29:37 -0800
From: isaku.yamahata@intel.com
To: kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org
Cc: isaku.yamahata@intel.com,
	isaku.yamahata@gmail.com,
	Paolo Bonzini <pbonzini@redhat.com>,
	erdemaktas@google.com,
	Sean Christopherson <seanjc@google.com>,
	Sagi Shahar <sagis@google.com>,
	Kai Huang <kai.huang@intel.com>,
	chen.bo@intel.com,
	hang.yuan@intel.com,
	tina.zhang@intel.com,
	Xiaoyao Li <xiaoyao.li@intel.com>
Subject: [PATCH v8 14/14] KVM: TDX: Allow 2MB large page for TD GUEST
Date: Mon, 26 Feb 2024 00:29:28 -0800
Message-Id: <2f5ea6d9ae5ce86c7eebd52de4a061ffb05eb420.1708933625.git.isaku.yamahata@intel.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <cover.1708933624.git.isaku.yamahata@intel.com>
References: <cover.1708933624.git.isaku.yamahata@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Xiaoyao Li <xiaoyao.li@intel.com>

Now that everything is there to support 2MB page for TD guest.  Because TDX
module TDH.MEM.PAGE.AUG supports 4KB page and 2MB page, set struct
kvm_arch.tdp_max_page_level to 2MB page level.

Signed-off-by: Xiaoyao Li <xiaoyao.li@intel.com>
Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
---
 arch/x86/kvm/mmu/tdp_mmu.c | 9 ++-------
 arch/x86/kvm/vmx/tdx.c     | 7 +++++--
 2 files changed, 7 insertions(+), 9 deletions(-)

diff --git a/arch/x86/kvm/mmu/tdp_mmu.c b/arch/x86/kvm/mmu/tdp_mmu.c
index d6ce8496803f..8663e163427c 100644
--- a/arch/x86/kvm/mmu/tdp_mmu.c
+++ b/arch/x86/kvm/mmu/tdp_mmu.c
@@ -1544,14 +1544,9 @@ int kvm_tdp_mmu_map(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault)
 
 		sp->nx_huge_page_disallowed = fault->huge_page_disallowed;
 
-		if (is_shadow_present_pte(iter.old_spte)) {
-			/*
-			 * TODO: large page support.
-			 * Doesn't support large page for TDX now
-			 */
-			KVM_BUG_ON(is_private_sptep(iter.sptep), vcpu->kvm);
+		if (is_shadow_present_pte(iter.old_spte))
 			r = tdp_mmu_split_huge_page(kvm, &iter, sp, true);
-		} else
+		else
 			r = tdp_mmu_link_sp(kvm, &iter, sp, true);
 
 		/*
diff --git a/arch/x86/kvm/vmx/tdx.c b/arch/x86/kvm/vmx/tdx.c
index 5b4d94a6c6e2..1a94b1072068 100644
--- a/arch/x86/kvm/vmx/tdx.c
+++ b/arch/x86/kvm/vmx/tdx.c
@@ -3109,8 +3109,11 @@ int tdx_gmem_max_level(struct kvm *kvm, kvm_pfn_t pfn, gfn_t gfn,
 	if (!is_private)
 		return 0;
 
-	/* TODO: Enable 2mb and 1gb large page support. */
-	*max_level = min(*max_level, PG_LEVEL_4K);
+	/*
+	 * TDH.MEM.PAGE.AUG supports up to 2MB page.
+	 * TODO: Enable 1gb large page support.
+	 */
+	*max_level = min(*max_level, PG_LEVEL_2M);
 	return 0;
 }
 
-- 
2.25.1


