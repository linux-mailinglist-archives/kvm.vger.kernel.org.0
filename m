Return-Path: <kvm+bounces-53224-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id EDC53B0F1E1
	for <lists+kvm@lfdr.de>; Wed, 23 Jul 2025 14:06:29 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 7E94C1C2229F
	for <lists+kvm@lfdr.de>; Wed, 23 Jul 2025 12:06:45 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 281202E6106;
	Wed, 23 Jul 2025 12:06:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="c11NQ1rA"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.9])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AAB6715A87C;
	Wed, 23 Jul 2025 12:06:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.9
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753272364; cv=none; b=cxgD1WOkJdle++9pGzj0yC41jPHyor5N7i4Gd7s+tgxpktqctjiKoW7HkDtr4AoCR0touTeOhmBMfIQBg6Qes23XCBEIrLBPwwx1C3qHKTypWup3fU7fngMGPWT+yi5+9oopRVh5BUuh86i2VUcs2+vb+qLfxSyu0Tzv3lKCgLQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753272364; c=relaxed/simple;
	bh=9FyLLAJ7tsUOSel1FJzkf5sgvB8mvHFedI7KtruoPvg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pLdoXBmuHWnpXAQkH0EAIThi9Ml6Z1FzhBvMbbcYLGhM9WaRl7GmvQ14i7f2kE2J1pW9Vrn8R4NCX8/YYGT2ss2WaI1eq9RzYcIdKUNMe6cT2CUsoyq5yUfAzUxefWUtSw/EIdmVmRRLdCoQBmpMJzMo9xqWiGUYKuPEe1JGfyU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=c11NQ1rA; arc=none smtp.client-ip=192.198.163.9
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1753272362; x=1784808362;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=9FyLLAJ7tsUOSel1FJzkf5sgvB8mvHFedI7KtruoPvg=;
  b=c11NQ1rAsn9hJwthY4CbelF82HPg4xgs5IOqophmfCpxUfZoXOOLduZ3
   P3Yh+VW7yeuPFRQvDyanG6YMchWyQSXvEMVy/6iHQWYn2u2aN4ZRuVxY9
   PsDGBwgjSE3mm8Ae3kvs7HEUwPixUcb4XP88QFXCQqHGpO6ZafijN/wai
   Yw95LoTGdtl4gMs83hJ2UzLq/P17IjFheMwdlH9qtHeXjHXSqlgcOzSCk
   RNYVT33mxArJiDgr/wfd7NUfw2NZwkCmJGMeUrFWL4VYYUOfxdZHq+5vz
   +CFhXM3ysV8AU7nYJdxoyixuiSA5S+1fKxiQ9awolY+9p/YxIXMGmFFYk
   g==;
X-CSE-ConnectionGUID: zJN+wRWiRtO4BqhMBtS1tg==
X-CSE-MsgGUID: 7tW+eLdnQcq8rdHnMjV6BA==
X-IronPort-AV: E=McAfee;i="6800,10657,11501"; a="66249199"
X-IronPort-AV: E=Sophos;i="6.16,333,1744095600"; 
   d="scan'208";a="66249199"
Received: from fmviesa002.fm.intel.com ([10.60.135.142])
  by fmvoesa103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Jul 2025 05:06:02 -0700
X-CSE-ConnectionGUID: Rb0hiCohRCyjn/Q0MoJKiw==
X-CSE-MsgGUID: +pxALaqYS0ajK9KA41VS4A==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.16,333,1744095600"; 
   d="scan'208";a="183154051"
Received: from pgcooper-mobl3.ger.corp.intel.com (HELO localhost.localdomain) ([10.245.245.72])
  by fmviesa002-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Jul 2025 05:05:57 -0700
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
Subject: [PATCH V4 1/2] x86/tdx: Eliminate duplicate code in tdx_clear_page()
Date: Wed, 23 Jul 2025 15:05:38 +0300
Message-ID: <20250723120539.122752-2-adrian.hunter@intel.com>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250723120539.122752-1-adrian.hunter@intel.com>
References: <20250723120539.122752-1-adrian.hunter@intel.com>
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


