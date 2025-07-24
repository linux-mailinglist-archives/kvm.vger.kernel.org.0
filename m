Return-Path: <kvm+bounces-53363-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id D21BFB10A93
	for <lists+kvm@lfdr.de>; Thu, 24 Jul 2025 14:49:06 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 8FA7C7B8A38
	for <lists+kvm@lfdr.de>; Thu, 24 Jul 2025 12:47:36 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BC2AF2BE7A8;
	Thu, 24 Jul 2025 12:48:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="baCfA6DX"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.8])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4CF6B2D5423;
	Thu, 24 Jul 2025 12:48:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.8
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753361315; cv=none; b=UT/1RR2ur/KyaGv9DT+2nlJeNxfueyJIe1kEAatZrhok78TSHLWbn7WXnszZI8vbWmvdedy+So/o9HVQJXsaNOYOx+RsdUb05igU6aW3s6pbxdhYeJFe4kHDi/1MflXps41d2hnUu1muDk6uTkRr/P0nYBnWg6H3SS73NQoSlIA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753361315; c=relaxed/simple;
	bh=Jh2RC03Ty92IWjhnsS2g/GxzXXk8a+aW99fIAIh6B4w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IaM723LUpa8kl00utV1E7Y0Wt6/7D0JAYQg5C6CrhS0b8TFXIxxUxqpNoKlf317miF7mEomkzfOr0EBh+AElcv4DGdS7ZtmhfpB6c6W2ZPZttigN6E9X6CrhAlvLzfTZ+cTwZS7Ro/mztjFHdhiqhyj/vRKfeN41kbLhKP9ORUc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=baCfA6DX; arc=none smtp.client-ip=192.198.163.8
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1753361315; x=1784897315;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=Jh2RC03Ty92IWjhnsS2g/GxzXXk8a+aW99fIAIh6B4w=;
  b=baCfA6DXZGsMAzBKjP9Yyis38oRvRDrP5r51Zz444kJvmKQ6yM5qbQOS
   V2TQ8iZKXgdovcnqMTLXLH14wrFajf0q4cnCQDQZSde+PVvi8CFgWbfm9
   37XdNAuDQujcDQMCBqgMOkWNMYouYkOS688ahzSY1vWjAM8G4yDFWkdc2
   jZZ6iIIEUxyYu3TyLrO/hQZE2HtCpgUQ0hg7+nr6A5hCBPIJFzZNnFXYd
   eINP4kWPwmgFxXcnZQ+G2SM/HmS38u1OY9+PRxG4yz5QOU8qEyvdS8ZT9
   QZN2BcpDMTwUMAK3PgUbiKXb0zDOxE5re3aiF05XfKdDR80XS3HQnTiJd
   g==;
X-CSE-ConnectionGUID: nesLTzqRQTSB0CWBMGEXiw==
X-CSE-MsgGUID: udymHJ8SSbq1ugMlCns0Ew==
X-IronPort-AV: E=McAfee;i="6800,10657,11501"; a="73253592"
X-IronPort-AV: E=Sophos;i="6.16,337,1744095600"; 
   d="scan'208";a="73253592"
Received: from orviesa006.jf.intel.com ([10.64.159.146])
  by fmvoesa102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Jul 2025 05:48:34 -0700
X-CSE-ConnectionGUID: 5PQyQ1DSRcS524oK79+cwg==
X-CSE-MsgGUID: YNEkFpESQWehCfKDNy2P+A==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.16,337,1744095600"; 
   d="scan'208";a="159460397"
Received: from sschumil-mobl2.ger.corp.intel.com (HELO localhost.localdomain) ([10.245.244.21])
  by orviesa006-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Jul 2025 05:48:29 -0700
From: Adrian Hunter <adrian.hunter@intel.com>
To: Dave Hansen <dave.hansen@linux.intel.com>,
	pbonzini@redhat.com,
	seanjc@google.com,
	vannapurve@google.com
Cc: Tony Luck <tony.luck@intel.com>,
	Borislav Petkov <bp@alien8.de>,
	Thomas Gleixner <tglx@linutronix.de>,
	Ingo Molnar <mingo@redhat.com>,
	x86@kernel.org,
	H Peter Anvin <hpa@zytor.com>,
	linux-kernel@vger.kernel.org,
	kvm@vger.kernel.org,
	rick.p.edgecombe@intel.com,
	kas@kernel.org,
	kai.huang@intel.com,
	reinette.chatre@intel.com,
	xiaoyao.li@intel.com,
	tony.lindgren@linux.intel.com,
	binbin.wu@linux.intel.com,
	isaku.yamahata@intel.com,
	yan.y.zhao@intel.com,
	chao.gao@intel.com
Subject: [PATCH V5 1/3] x86/tdx: Eliminate duplicate code in tdx_clear_page()
Date: Thu, 24 Jul 2025 15:48:09 +0300
Message-ID: <20250724124811.78326-2-adrian.hunter@intel.com>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250724124811.78326-1-adrian.hunter@intel.com>
References: <20250724124811.78326-1-adrian.hunter@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Organization: Intel Finland Oy, Registered Address: c/o Alberga Business Park, 6 krs, Bertel Jungin Aukio 5, 02600 Espoo, Business Identity Code: 0357606 - 4, Domiciled in Helsinki
Content-Transfer-Encoding: 8bit

tdx_clear_page() and reset_tdx_pages() duplicate the TDX page clearing
logic.  Rename reset_tdx_pages() to tdx_quirk_reset_paddr() and create
tdx_quirk_reset_page() to call tdx_quirk_reset_paddr() and be used in
place of tdx_clear_page().

The new name reflects that, in fact, the clearing is necessary only for
hardware with a certain quirk.  That is dealt with in a subsequent patch
but doing the rename here avoids additional churn.

Note reset_tdx_pages() is slightly different from tdx_clear_page() because,
more appropriately, it uses mb() in place of __mb().  Except when extra
debugging is enabled (kcsan at present), mb() just calls __mb().

Reviewed-by: Kirill A. Shutemov <kas@kernel.org>
Reviewed-by: Binbin Wu <binbin.wu@linux.intel.com>
Reviewed-by: Xiaoyao Li <xiaoyao.li@intel.com>
Acked-by: Kai Huang <kai.huang@intel.com>
Signed-off-by: Adrian Hunter <adrian.hunter@intel.com>
---


Changes in V5:

	None

Changes in V4:

	Add and use tdx_quirk_reset_page() for KVM (Sean)

Changes in V3:

	Explain "quirk" rename in commit message (Rick)
	Explain mb() change in commit message  (Rick)
	Add Rev'd-by, Ack'd-by tags

Changes in V2:

	Rename reset_tdx_pages() to tdx_quirk_reset_paddr()
	Call tdx_quirk_reset_paddr() directly


 arch/x86/include/asm/tdx.h  |  2 ++
 arch/x86/kvm/vmx/tdx.c      | 25 +++----------------------
 arch/x86/virt/vmx/tdx/tdx.c | 10 ++++++++--
 3 files changed, 13 insertions(+), 24 deletions(-)

diff --git a/arch/x86/include/asm/tdx.h b/arch/x86/include/asm/tdx.h
index 7ddef3a69866..57b46f05ff97 100644
--- a/arch/x86/include/asm/tdx.h
+++ b/arch/x86/include/asm/tdx.h
@@ -131,6 +131,8 @@ int tdx_guest_keyid_alloc(void);
 u32 tdx_get_nr_guest_keyids(void);
 void tdx_guest_keyid_free(unsigned int keyid);
 
+void tdx_quirk_reset_page(struct page *page);
+
 struct tdx_td {
 	/* TD root structure: */
 	struct page *tdr_page;
diff --git a/arch/x86/kvm/vmx/tdx.c b/arch/x86/kvm/vmx/tdx.c
index 573d6f7d1694..ebb36229c7c8 100644
--- a/arch/x86/kvm/vmx/tdx.c
+++ b/arch/x86/kvm/vmx/tdx.c
@@ -283,25 +283,6 @@ static inline void tdx_disassociate_vp(struct kvm_vcpu *vcpu)
 	vcpu->cpu = -1;
 }
 
-static void tdx_clear_page(struct page *page)
-{
-	const void *zero_page = (const void *) page_to_virt(ZERO_PAGE(0));
-	void *dest = page_to_virt(page);
-	unsigned long i;
-
-	/*
-	 * The page could have been poisoned.  MOVDIR64B also clears
-	 * the poison bit so the kernel can safely use the page again.
-	 */
-	for (i = 0; i < PAGE_SIZE; i += 64)
-		movdir64b(dest + i, zero_page);
-	/*
-	 * MOVDIR64B store uses WC buffer.  Prevent following memory reads
-	 * from seeing potentially poisoned cache.
-	 */
-	__mb();
-}
-
 static void tdx_no_vcpus_enter_start(struct kvm *kvm)
 {
 	struct kvm_tdx *kvm_tdx = to_kvm_tdx(kvm);
@@ -347,7 +328,7 @@ static int tdx_reclaim_page(struct page *page)
 
 	r = __tdx_reclaim_page(page);
 	if (!r)
-		tdx_clear_page(page);
+		tdx_quirk_reset_page(page);
 	return r;
 }
 
@@ -596,7 +577,7 @@ static void tdx_reclaim_td_control_pages(struct kvm *kvm)
 		pr_tdx_error(TDH_PHYMEM_PAGE_WBINVD, err);
 		return;
 	}
-	tdx_clear_page(kvm_tdx->td.tdr_page);
+	tdx_quirk_reset_page(kvm_tdx->td.tdr_page);
 
 	__free_page(kvm_tdx->td.tdr_page);
 	kvm_tdx->td.tdr_page = NULL;
@@ -1717,7 +1698,7 @@ static int tdx_sept_drop_private_spte(struct kvm *kvm, gfn_t gfn,
 		pr_tdx_error(TDH_PHYMEM_PAGE_WBINVD, err);
 		return -EIO;
 	}
-	tdx_clear_page(page);
+	tdx_quirk_reset_page(page);
 	tdx_unpin(kvm, page);
 	return 0;
 }
diff --git a/arch/x86/virt/vmx/tdx/tdx.c b/arch/x86/virt/vmx/tdx/tdx.c
index c7a9a087ccaf..fc8d8e444f15 100644
--- a/arch/x86/virt/vmx/tdx/tdx.c
+++ b/arch/x86/virt/vmx/tdx/tdx.c
@@ -637,7 +637,7 @@ static int tdmrs_set_up_pamt_all(struct tdmr_info_list *tdmr_list,
  * clear these pages.  Note this function doesn't flush cache of
  * these TDX private pages.  The caller should make sure of that.
  */
-static void reset_tdx_pages(unsigned long base, unsigned long size)
+static void tdx_quirk_reset_paddr(unsigned long base, unsigned long size)
 {
 	const void *zero_page = (const void *)page_address(ZERO_PAGE(0));
 	unsigned long phys, end;
@@ -654,9 +654,15 @@ static void reset_tdx_pages(unsigned long base, unsigned long size)
 	mb();
 }
 
+void tdx_quirk_reset_page(struct page *page)
+{
+	tdx_quirk_reset_paddr(page_to_phys(page), PAGE_SIZE);
+}
+EXPORT_SYMBOL_GPL(tdx_quirk_reset_page);
+
 static void tdmr_reset_pamt(struct tdmr_info *tdmr)
 {
-	tdmr_do_pamt_func(tdmr, reset_tdx_pages);
+	tdmr_do_pamt_func(tdmr, tdx_quirk_reset_paddr);
 }
 
 static void tdmrs_reset_pamt_all(struct tdmr_info_list *tdmr_list)
-- 
2.48.1


