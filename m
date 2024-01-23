Return-Path: <kvm+bounces-6699-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id CE46A837B90
	for <lists+kvm@lfdr.de>; Tue, 23 Jan 2024 02:02:57 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 7604128391F
	for <lists+kvm@lfdr.de>; Tue, 23 Jan 2024 01:02:56 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 55D8114E2FA;
	Tue, 23 Jan 2024 00:22:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="I5iZ/ABY"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [134.134.136.65])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CF6EC14DB4A;
	Tue, 23 Jan 2024 00:22:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=134.134.136.65
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705969361; cv=none; b=eAUBqgsJcOI/w+n6+BhPzHElzyZoXQ+sKP4vAYxChe6rcDj1dYWTK1zViDya6DzTmnx3q9Ss3XrOt+da1q0T6+sZ3hf+2AaP4LLxk0jDk/YCq1KpEn+Ee0p1/yasuetUWL4utL6aWoBfUewt6m/Ljcfa8KPOLwFfCzQ93Xw2JBo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705969361; c=relaxed/simple;
	bh=yBYDoMpYcORK+18VbncuiQAFR1zA0t3kn0ekXcEBpzc=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=QfEJB4OMfMrNe7ofv1CGW3kHBDWrRa/OHA+KA96XyOHOpfvpilrhqt7vVlIJF/i/V2Y/iHizUH3/1KGpTxg0h30FmcW1+usjeRdiFZbXOAlsGhjvMnkSLPBTk+/fME2r48Hsuc7h1UGOUCHGY9gYPiY/1sNYFQfrvavAJhnEy+s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=I5iZ/ABY; arc=none smtp.client-ip=134.134.136.65
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1705969359; x=1737505359;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=yBYDoMpYcORK+18VbncuiQAFR1zA0t3kn0ekXcEBpzc=;
  b=I5iZ/ABY2IKQsopv2VnDOlE3HHP9W6BmHJmJZVQwnL4EOXGdyugdmiw5
   PHj3sjhrgvTj4RKnPag3mfQgN6c1qOVEu5dgpBjXGaxJo9UDh4eclLJJt
   5O8zAmGJuANBZNhNQK26H4hkRdilNzp9diyb24y3e28BqC4y82677zkxa
   WPy/j2MD4bM6mI00Nd2aoHfh2i8igBxUrM7+kayvYE2XIWOp8ml+Mhh1r
   R6hmLsZpHnLO0P54CVTwaJxsgQIhqLdO+xwIqo7NGhs6L4lED6s1ect/c
   Q2ID42mJ7S4Vrdg+WVeF5yal6FkqLKqfd9pAxawrs/gEXB202CyPAUIHG
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10961"; a="405125650"
X-IronPort-AV: E=Sophos;i="6.05,212,1701158400"; 
   d="scan'208";a="405125650"
Received: from fmviesa001.fm.intel.com ([10.60.135.141])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Jan 2024 16:22:37 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.05,212,1701158400"; 
   d="scan'208";a="27825630"
Received: from ls.sc.intel.com (HELO localhost) ([172.25.112.31])
  by smtpauth.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Jan 2024 16:22:37 -0800
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
Subject: [PATCH v7 03/13] KVM: TDX: Pass size to reclaim_page()
Date: Mon, 22 Jan 2024 16:22:18 -0800
Message-Id: <c547f5ba335b879406adbaa5c1786758b834562a.1705965958.git.isaku.yamahata@intel.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <cover.1705965958.git.isaku.yamahata@intel.com>
References: <cover.1705965958.git.isaku.yamahata@intel.com>
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
index 549dec05ccad..68f3a4c40be4 100644
--- a/arch/x86/kvm/vmx/tdx.c
+++ b/arch/x86/kvm/vmx/tdx.c
@@ -277,12 +277,13 @@ static void tdx_disassociate_vp_on_cpu(struct kvm_vcpu *vcpu)
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
@@ -291,7 +292,7 @@ static void tdx_clear_page(unsigned long page_pa)
 	 * clflush doesn't flush cache with HKID set.  The cache line could be
 	 * poisoned (even without MKTME-i), clear the poison bit.
 	 */
-	for (i = 0; i < PAGE_SIZE; i += 64)
+	for (i = 0; i < size; i += 64)
 		movdir64b(page + i, zero_page);
 	/*
 	 * MOVDIR64B store uses WC buffer.  Prevent following memory reads
@@ -300,7 +301,7 @@ static void tdx_clear_page(unsigned long page_pa)
 	__mb();
 }
 
-static int __tdx_reclaim_page(hpa_t pa)
+static int __tdx_reclaim_page(hpa_t pa, enum pg_level level)
 {
 	struct tdx_module_args out;
 	u64 err;
@@ -318,17 +319,19 @@ static int __tdx_reclaim_page(hpa_t pa)
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
 
@@ -342,7 +345,7 @@ static void tdx_reclaim_control_page(unsigned long td_page_pa)
 	 * was already flushed by TDH.PHYMEM.CACHE.WB before here, So
 	 * cache doesn't need to be flushed again.
 	 */
-	if (tdx_reclaim_page(td_page_pa))
+	if (tdx_reclaim_page(td_page_pa, PG_LEVEL_4K))
 		/*
 		 * Leak the page on failure:
 		 * tdx_reclaim_page() returns an error if and only if there's an
@@ -573,7 +576,7 @@ void tdx_vm_free(struct kvm *kvm)
 
 	if (!kvm_tdx->tdr_pa)
 		return;
-	if (__tdx_reclaim_page(kvm_tdx->tdr_pa))
+	if (__tdx_reclaim_page(kvm_tdx->tdr_pa, PG_LEVEL_4K))
 		return;
 	/*
 	 * TDX module maps TDR with TDX global HKID.  TDX module may access TDR
@@ -586,7 +589,7 @@ void tdx_vm_free(struct kvm *kvm)
 		pr_tdx_error(TDH_PHYMEM_PAGE_WBINVD, err, NULL);
 		return;
 	}
-	tdx_clear_page(kvm_tdx->tdr_pa);
+	tdx_clear_page(kvm_tdx->tdr_pa, PAGE_SIZE);
 
 	free_page((unsigned long)__va(kvm_tdx->tdr_pa));
 	kvm_tdx->tdr_pa = 0;
@@ -1654,7 +1657,7 @@ static int tdx_sept_drop_private_spte(struct kvm *kvm, gfn_t gfn,
 		 * The HKID assigned to this TD was already freed and cache
 		 * was already flushed. We don't have to flush again.
 		 */
-		err = tdx_reclaim_page(hpa);
+		err = tdx_reclaim_page(hpa, level);
 		if (KVM_BUG_ON(err, kvm))
 			return -EIO;
 		tdx_unpin(kvm, pfn);
@@ -1687,7 +1690,7 @@ static int tdx_sept_drop_private_spte(struct kvm *kvm, gfn_t gfn,
 		pr_tdx_error(TDH_PHYMEM_PAGE_WBINVD, err, NULL);
 		return -EIO;
 	}
-	tdx_clear_page(hpa);
+	tdx_clear_page(hpa, PAGE_SIZE);
 	tdx_unpin(kvm, pfn);
 	return 0;
 }
@@ -1799,7 +1802,7 @@ static int tdx_sept_free_private_spt(struct kvm *kvm, gfn_t gfn,
 	 * already flushed. We don't have to flush again.
 	 */
 	if (!is_hkid_assigned(kvm_tdx))
-		return tdx_reclaim_page(__pa(private_spt));
+		return tdx_reclaim_page(__pa(private_spt), PG_LEVEL_4K);
 
 	/*
 	 * free_private_spt() is (obviously) called when a shadow page is being
-- 
2.25.1


