Return-Path: <kvm+bounces-53122-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 4DE4AB0DA98
	for <lists+kvm@lfdr.de>; Tue, 22 Jul 2025 15:16:39 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 9CFDA1C25A19
	for <lists+kvm@lfdr.de>; Tue, 22 Jul 2025 13:16:56 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 76F1F2EA166;
	Tue, 22 Jul 2025 13:16:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Tg2wxFs1"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E4C7F3B19A;
	Tue, 22 Jul 2025 13:16:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.10
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753190176; cv=none; b=s7q5wBomL/Ck9IbrBKTVithAj8EBKbUdqx+MUbeOfVxdcDF6b7OeQ14CAW/0qvCJijaskfOxVQDGAqSlmm2rW7QTIHQPmS9YiWW3bxNBs+2DIB50xeVzH4WXzgwdHrhAouNKpRTl9s5kT7PPgYNuN7RbpGWyXd6QlW89CXKaq7I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753190176; c=relaxed/simple;
	bh=6QyobneToT6PLjwRMCefzreEVftewuKBROPwE+Uw5Ug=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=oM7VvxqmCPJCCWkUNb9XtxCwBo27z9eHzvryj5cAPjLaxxA9vCjunXCYDeoaZjhEDVtW5KuelhWQ27MBhzankIG/CBg3ZB0DB6kxfb3C6r46O2i8sH45L0AB4Slhq6hIUXdsb47qaWJdIjuLu83dzWXjduxt8MC79wNtBmUbrng=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=Tg2wxFs1; arc=none smtp.client-ip=198.175.65.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1753190175; x=1784726175;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=6QyobneToT6PLjwRMCefzreEVftewuKBROPwE+Uw5Ug=;
  b=Tg2wxFs1gtSklYKjM3sOvkQeA7840nMuPf7+ISAXyq7orWgGfaz/ewRq
   uG5f+x+ZJ6FaYSGdxzGzxT9m+Mmy7h2RWsmAzBis3P1L7xU/5vyioo1fk
   lv0mmxjokxtCP1nIfnFX99IIlrHrjz3tuExA0xozNrr3JXHtrLiP+PXNF
   cXy9ebvEcUdO/BrhtZbnuM/4M2/NPFn677/r2E/RUldT6baAeIzIPvlkB
   p/xunsML28UyewKSWJsIgDOhjpHR0kJgPpMLIuF96hDw0959TT3SPNn4+
   WifvHgCZSLA+c1mPBDA4Ox/oZQaGqMmx61YNLwMyEha177Ixj27V2gUrX
   A==;
X-CSE-ConnectionGUID: NjZ0y7edRsCLi2ZN+956Hg==
X-CSE-MsgGUID: nOX2sdk0TmmG0FK6XEW9Qw==
X-IronPort-AV: E=McAfee;i="6800,10657,11500"; a="72893110"
X-IronPort-AV: E=Sophos;i="6.16,331,1744095600"; 
   d="scan'208";a="72893110"
Received: from orviesa004.jf.intel.com ([10.64.159.144])
  by orvoesa102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Jul 2025 06:16:00 -0700
X-CSE-ConnectionGUID: GY38ZJkbQV+f8eAJ4YM2Mg==
X-CSE-MsgGUID: /T07D8zlQDS9s/39ZnneTg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.16,331,1744095600"; 
   d="scan'208";a="163695160"
Received: from pgcooper-mobl3.ger.corp.intel.com (HELO localhost.localdomain) ([10.245.244.161])
  by orviesa004-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Jul 2025 06:15:54 -0700
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
Subject: [PATCH V3 1/2] x86/tdx: Eliminate duplicate code in tdx_clear_page()
Date: Tue, 22 Jul 2025 16:15:32 +0300
Message-ID: <20250722131533.106473-2-adrian.hunter@intel.com>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250722131533.106473-1-adrian.hunter@intel.com>
References: <20250722131533.106473-1-adrian.hunter@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Organization: Intel Finland Oy, Registered Address: c/o Alberga Business Park, 6 krs, Bertel Jungin Aukio 5, 02600 Espoo, Business Identity Code: 0357606 - 4, Domiciled in Helsinki
Content-Transfer-Encoding: 8bit

tdx_clear_page() and reset_tdx_pages() duplicate the TDX page clearing
logic.  Rename reset_tdx_pages() to tdx_quirk_reset_paddr() and use it
in place of tdx_clear_page().

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


Changes in V3:

	Explain "quirk" rename in commit message (Rick)
	Explain mb() change in commit message  (Rick)
	Add Rev'd-by, Ack'd-by tags

Changes in V2:

	Rename reset_tdx_pages() to tdx_quirk_reset_paddr()
	Call tdx_quirk_reset_paddr() directly


 arch/x86/include/asm/tdx.h  |  2 ++
 arch/x86/kvm/vmx/tdx.c      | 25 +++----------------------
 arch/x86/virt/vmx/tdx/tdx.c |  5 +++--
 3 files changed, 8 insertions(+), 24 deletions(-)

diff --git a/arch/x86/include/asm/tdx.h b/arch/x86/include/asm/tdx.h
index 7ddef3a69866..f66328404724 100644
--- a/arch/x86/include/asm/tdx.h
+++ b/arch/x86/include/asm/tdx.h
@@ -131,6 +131,8 @@ int tdx_guest_keyid_alloc(void);
 u32 tdx_get_nr_guest_keyids(void);
 void tdx_guest_keyid_free(unsigned int keyid);
 
+void tdx_quirk_reset_paddr(unsigned long base, unsigned long size);
+
 struct tdx_td {
 	/* TD root structure: */
 	struct page *tdr_page;
diff --git a/arch/x86/kvm/vmx/tdx.c b/arch/x86/kvm/vmx/tdx.c
index 573d6f7d1694..1b549de6da06 100644
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
+		tdx_quirk_reset_paddr(page_to_phys(page), PAGE_SIZE);
 	return r;
 }
 
@@ -596,7 +577,7 @@ static void tdx_reclaim_td_control_pages(struct kvm *kvm)
 		pr_tdx_error(TDH_PHYMEM_PAGE_WBINVD, err);
 		return;
 	}
-	tdx_clear_page(kvm_tdx->td.tdr_page);
+	tdx_quirk_reset_paddr(page_to_phys(kvm_tdx->td.tdr_page), PAGE_SIZE);
 
 	__free_page(kvm_tdx->td.tdr_page);
 	kvm_tdx->td.tdr_page = NULL;
@@ -1717,7 +1698,7 @@ static int tdx_sept_drop_private_spte(struct kvm *kvm, gfn_t gfn,
 		pr_tdx_error(TDH_PHYMEM_PAGE_WBINVD, err);
 		return -EIO;
 	}
-	tdx_clear_page(page);
+	tdx_quirk_reset_paddr(page_to_phys(page), PAGE_SIZE);
 	tdx_unpin(kvm, page);
 	return 0;
 }
diff --git a/arch/x86/virt/vmx/tdx/tdx.c b/arch/x86/virt/vmx/tdx/tdx.c
index c7a9a087ccaf..14d93ed05bd2 100644
--- a/arch/x86/virt/vmx/tdx/tdx.c
+++ b/arch/x86/virt/vmx/tdx/tdx.c
@@ -637,7 +637,7 @@ static int tdmrs_set_up_pamt_all(struct tdmr_info_list *tdmr_list,
  * clear these pages.  Note this function doesn't flush cache of
  * these TDX private pages.  The caller should make sure of that.
  */
-static void reset_tdx_pages(unsigned long base, unsigned long size)
+void tdx_quirk_reset_paddr(unsigned long base, unsigned long size)
 {
 	const void *zero_page = (const void *)page_address(ZERO_PAGE(0));
 	unsigned long phys, end;
@@ -653,10 +653,11 @@ static void reset_tdx_pages(unsigned long base, unsigned long size)
 	 */
 	mb();
 }
+EXPORT_SYMBOL_GPL(tdx_quirk_reset_paddr);
 
 static void tdmr_reset_pamt(struct tdmr_info *tdmr)
 {
-	tdmr_do_pamt_func(tdmr, reset_tdx_pages);
+	tdmr_do_pamt_func(tdmr, tdx_quirk_reset_paddr);
 }
 
 static void tdmrs_reset_pamt_all(struct tdmr_info_list *tdmr_list)
-- 
2.48.1


