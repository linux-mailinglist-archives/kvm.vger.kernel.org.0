Return-Path: <kvm+bounces-9759-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id E2AE1866DCE
	for <lists+kvm@lfdr.de>; Mon, 26 Feb 2024 10:12:52 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 0103DB2625C
	for <lists+kvm@lfdr.de>; Mon, 26 Feb 2024 09:12:50 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CF901133411;
	Mon, 26 Feb 2024 08:29:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="ArhkQ4kG"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.8])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 22798132C10;
	Mon, 26 Feb 2024 08:29:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.8
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708936178; cv=none; b=vENp1inbgoPzdwUvWgx9GY1IMR05WTI8yT0EA/trwkKEJrmZGkWedk5kwRMdpfq7kXhYjcA1nMU6Y/w/xX9oeYhoNbtodDMPC9Ii9KsSfP4PoQoDebTFXKiUyEp/nd6QxM6AfgAHUS8PuvMmMuByo02Lj+u01OCxHjINYTypvNA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708936178; c=relaxed/simple;
	bh=8X8eohflvuTsoO2p7zC4NMuohj2rz7u5lPxyLlFmN3Q=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=HkxxkpDtPaiaEEoQZoT/S6IspC9+fLPV1dfvXJ4H63Z0dNFKt1wDarNHKslVz4xdJZH8W9y8W88qXc6EbQg/88cqOppox4ztBLWv36F2KKDtam6m4K8HTQdMxOG2D9LRwl2rqq+0AZCiBCIZUz6JuZCrChscL0h0pxs09q1nb5A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=ArhkQ4kG; arc=none smtp.client-ip=192.198.163.8
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1708936176; x=1740472176;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=8X8eohflvuTsoO2p7zC4NMuohj2rz7u5lPxyLlFmN3Q=;
  b=ArhkQ4kGQ2doDEJYN1Iqqj1ASNgJlvaDHrzFhdzNUEgO/aIuypen3Zxw
   ipbciZZIrbFkZpq7tfZsg0R+orJs9zetKK7keCPtpu6nc/fgz7kEb8AHT
   Bsbf128bhxQAExudbpvG5c3kDQv4dAL50vZKDeRtLDUgWgygohWC3XPhF
   1yrImYOiytaiKGkuMUfd3am548hXxNALSwfv6+N9IqE/aTh7sEb1jB06v
   SOVUnvrZ42Yna4DrpaNl2YjA+SdzIA7JjJEHKTSaFteDCzaFM9Rj/Em1c
   /A/xDhnkl2LFmYhvGBRRAwboJ0SuCQKesoppdgrutxNBIWmqI113qImbL
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10995"; a="20751512"
X-IronPort-AV: E=Sophos;i="6.06,185,1705392000"; 
   d="scan'208";a="20751512"
Received: from fmviesa008.fm.intel.com ([10.60.135.148])
  by fmvoesa102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Feb 2024 00:29:33 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.06,185,1705392000"; 
   d="scan'208";a="6735299"
Received: from ls.sc.intel.com (HELO localhost) ([172.25.112.31])
  by fmviesa008-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Feb 2024 00:29:33 -0800
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
Subject: [PATCH v8 04/14] KVM: TDX: Pass size to reclaim_page()
Date: Mon, 26 Feb 2024 00:29:18 -0800
Message-Id: <e5c072236b40f75229418c411e2e6cbbecb3e9fb.1708933624.git.isaku.yamahata@intel.com>
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

A 2MB large page can be tdh_mem_page_aug()'ed to TD directly. In this case,
it needs to reclaim and clear the page as 2MB size.

Signed-off-by: Xiaoyao Li <xiaoyao.li@intel.com>
Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
---
v5:
- Change type of page size from int to unsigned long
---
 arch/x86/kvm/vmx/tdx.c | 27 +++++++++++++++------------
 1 file changed, 15 insertions(+), 12 deletions(-)

diff --git a/arch/x86/kvm/vmx/tdx.c b/arch/x86/kvm/vmx/tdx.c
index fd992966379c..8205d68ed477 100644
--- a/arch/x86/kvm/vmx/tdx.c
+++ b/arch/x86/kvm/vmx/tdx.c
@@ -233,12 +233,13 @@ static void tdx_disassociate_vp_on_cpu(struct kvm_vcpu *vcpu)
 	smp_call_function_single(cpu, tdx_disassociate_vp_arg, vcpu, 1);
 }
 
-static void tdx_clear_page(unsigned long page_pa)
+static void tdx_clear_page(unsigned long page_pa, unsigned long size)
 {
 	const void *zero_page = (const void *) __va(page_to_phys(ZERO_PAGE(0)));
 	void *page = __va(page_pa);
 	unsigned long i;
 
+	WARN_ON_ONCE(size % PAGE_SIZE);
 	/*
 	 * When re-assign one page from old keyid to a new keyid, MOVDIR64B is
 	 * required to clear/write the page with new keyid to prevent integrity
@@ -247,7 +248,7 @@ static void tdx_clear_page(unsigned long page_pa)
 	 * clflush doesn't flush cache with HKID set.  The cache line could be
 	 * poisoned (even without MKTME-i), clear the poison bit.
 	 */
-	for (i = 0; i < PAGE_SIZE; i += 64)
+	for (i = 0; i < size; i += 64)
 		movdir64b(page + i, zero_page);
 	/*
 	 * MOVDIR64B store uses WC buffer.  Prevent following memory reads
@@ -256,7 +257,7 @@ static void tdx_clear_page(unsigned long page_pa)
 	__mb();
 }
 
-static int __tdx_reclaim_page(hpa_t pa)
+static int __tdx_reclaim_page(hpa_t pa, enum pg_level level)
 {
 	struct tdx_module_args out;
 	u64 err;
@@ -275,17 +276,19 @@ static int __tdx_reclaim_page(hpa_t pa)
 		pr_tdx_error(TDH_PHYMEM_PAGE_RECLAIM, err, &out);
 		return -EIO;
 	}
+	/* out.r8 == tdx sept page level */
+	WARN_ON_ONCE(out.r8 != pg_level_to_tdx_sept_level(level));
 
 	return 0;
 }
 
-static int tdx_reclaim_page(hpa_t pa)
+static int tdx_reclaim_page(hpa_t pa, enum pg_level level)
 {
 	int r;
 
-	r = __tdx_reclaim_page(pa);
+	r = __tdx_reclaim_page(pa, level);
 	if (!r)
-		tdx_clear_page(pa);
+		tdx_clear_page(pa, KVM_HPAGE_SIZE(level));
 	return r;
 }
 
@@ -299,7 +302,7 @@ static void tdx_reclaim_control_page(unsigned long td_page_pa)
 	 * was already flushed by TDH.PHYMEM.CACHE.WB before here, So
 	 * cache doesn't need to be flushed again.
 	 */
-	if (tdx_reclaim_page(td_page_pa))
+	if (tdx_reclaim_page(td_page_pa, PG_LEVEL_4K))
 		/*
 		 * Leak the page on failure:
 		 * tdx_reclaim_page() returns an error if and only if there's an
@@ -530,7 +533,7 @@ void tdx_vm_free(struct kvm *kvm)
 
 	if (!kvm_tdx->tdr_pa)
 		return;
-	if (__tdx_reclaim_page(kvm_tdx->tdr_pa))
+	if (__tdx_reclaim_page(kvm_tdx->tdr_pa, PG_LEVEL_4K))
 		return;
 	/*
 	 * TDX module maps TDR with TDX global HKID.  TDX module may access TDR
@@ -543,7 +546,7 @@ void tdx_vm_free(struct kvm *kvm)
 		pr_tdx_error(TDH_PHYMEM_PAGE_WBINVD, err, NULL);
 		return;
 	}
-	tdx_clear_page(kvm_tdx->tdr_pa);
+	tdx_clear_page(kvm_tdx->tdr_pa, PAGE_SIZE);
 
 	free_page((unsigned long)__va(kvm_tdx->tdr_pa));
 	kvm_tdx->tdr_pa = 0;
@@ -1586,7 +1589,7 @@ static int tdx_sept_drop_private_spte(struct kvm *kvm, gfn_t gfn,
 		 * The HKID assigned to this TD was already freed and cache
 		 * was already flushed. We don't have to flush again.
 		 */
-		err = tdx_reclaim_page(hpa);
+		err = tdx_reclaim_page(hpa, level);
 		if (KVM_BUG_ON(err, kvm))
 			return -EIO;
 		tdx_unpin(kvm, pfn);
@@ -1619,7 +1622,7 @@ static int tdx_sept_drop_private_spte(struct kvm *kvm, gfn_t gfn,
 		pr_tdx_error(TDH_PHYMEM_PAGE_WBINVD, err, NULL);
 		return -EIO;
 	}
-	tdx_clear_page(hpa);
+	tdx_clear_page(hpa, PAGE_SIZE);
 	tdx_unpin(kvm, pfn);
 	return 0;
 }
@@ -1753,7 +1756,7 @@ static int tdx_sept_free_private_spt(struct kvm *kvm, gfn_t gfn,
 	 * already flushed. We don't have to flush again.
 	 */
 	if (!is_hkid_assigned(kvm_tdx))
-		return tdx_reclaim_page(__pa(private_spt));
+		return tdx_reclaim_page(__pa(private_spt), PG_LEVEL_4K);
 
 	/*
 	 * free_private_spt() is (obviously) called when a shadow page is being
-- 
2.25.1


