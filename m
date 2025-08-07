Return-Path: <kvm+bounces-54230-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id E7035B1D507
	for <lists+kvm@lfdr.de>; Thu,  7 Aug 2025 11:43:22 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id E5737189EAB6
	for <lists+kvm@lfdr.de>; Thu,  7 Aug 2025 09:43:40 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BBF7726159E;
	Thu,  7 Aug 2025 09:43:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="dLS7D+9n"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 37CE625C6F1;
	Thu,  7 Aug 2025 09:43:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.10
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754559786; cv=none; b=kX3sHp+uujnkEItLlafeaG4ErK4WeuVNOR/Od0XsWQEnXseCYaMaSdFqM85C4QGlmiAbe5RZUSAO9eeiFFs1PGacrIsyck4DR6ZlmjV9D0M5YxjJi0DIbLfWCjdHJIIsSkOu5csN/qlR5icKkdDo34bCHg0FpY9++YcfDQQ5ssk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754559786; c=relaxed/simple;
	bh=drqT1KujXX0g1ykXaCYwPaVAfrJzjT9SequGRqO2V6Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lWPd2L4lwkKYM6tYDrnFGoe0V6GI2oatpbqxrqWuF527U7+l7aIihrBUtBwJU69sWfRH5TNmH3N3uHEvlN6pHlr1M3xa49hoqH5MZJzLgecFWllNmWVLL0t5ECf3go+mLvTaLCRPpkzndcwSRUbOMAu0jbjeE3llWCuflYDdwTQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=dLS7D+9n; arc=none smtp.client-ip=192.198.163.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1754559785; x=1786095785;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=drqT1KujXX0g1ykXaCYwPaVAfrJzjT9SequGRqO2V6Y=;
  b=dLS7D+9nfv155KTdz8WWUzSSes4F+vhtPV9CmmOht2lsaWPMzQbWAe7x
   eaMrP5zn57HwHg3Kvs9RngsbttV/3PebEvky+IPIkiLR55k0rDwu+aCts
   AXAMytja8xC+ALInRcGEvF2X80v7KKv+qa2fxOx9xAmH7WoxMBvFn4wgc
   H5G+MsktpdNvCdq4+2WYHU8V+GriSsfqhT7kvvmujjGMk1wsZPJh0WeX9
   GCQl5dMefmd278fQ9S0KzHxy9cfpuvu6yO/sB/Y6tvIiabTh9ulLCpvQS
   waXGESWZOlcFOnX9f+Dd0HHiAjKDO7Jt6FqqYSFg8JbP/1jW5eijjfDad
   A==;
X-CSE-ConnectionGUID: bNW4zTTAQxej8BEDwwh3tA==
X-CSE-MsgGUID: lkYAyl74S6OuWOwqySgdAw==
X-IronPort-AV: E=McAfee;i="6800,10657,11514"; a="68265937"
X-IronPort-AV: E=Sophos;i="6.17,271,1747724400"; 
   d="scan'208";a="68265937"
Received: from orviesa002.jf.intel.com ([10.64.159.142])
  by fmvoesa104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Aug 2025 02:43:04 -0700
X-CSE-ConnectionGUID: okYZamr3Ry+ZjPAr4SJpYA==
X-CSE-MsgGUID: YFJ1j7xuT7Ci67LuIQnQvw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.17,271,1747724400"; 
   d="scan'208";a="196006829"
Received: from yzhao56-desk.sh.intel.com ([10.239.47.19])
  by orviesa002-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Aug 2025 02:42:56 -0700
From: Yan Zhao <yan.y.zhao@intel.com>
To: pbonzini@redhat.com,
	seanjc@google.com
Cc: linux-kernel@vger.kernel.org,
	kvm@vger.kernel.org,
	x86@kernel.org,
	rick.p.edgecombe@intel.com,
	dave.hansen@intel.com,
	kas@kernel.org,
	tabba@google.com,
	ackerleytng@google.com,
	quic_eberman@quicinc.com,
	michael.roth@amd.com,
	david@redhat.com,
	vannapurve@google.com,
	vbabka@suse.cz,
	thomas.lendacky@amd.com,
	pgonda@google.com,
	zhiquan1.li@intel.com,
	fan.du@intel.com,
	jun.miao@intel.com,
	ira.weiny@intel.com,
	isaku.yamahata@intel.com,
	xiaoyao.li@intel.com,
	binbin.wu@linux.intel.com,
	chao.p.peng@intel.com,
	yan.y.zhao@intel.com
Subject: [RFC PATCH v2 05/23] x86/tdx: Enhance tdh_phymem_page_reclaim() to support huge pages
Date: Thu,  7 Aug 2025 17:42:28 +0800
Message-ID: <20250807094228.4509-1-yan.y.zhao@intel.com>
X-Mailer: git-send-email 2.43.2
In-Reply-To: <20250807093950.4395-1-yan.y.zhao@intel.com>
References: <20250807093950.4395-1-yan.y.zhao@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Enhance the SEAMCALL wrapper tdh_phymem_page_reclaim() to support huge
pages by introducing new parameters: "folio", "start_idx", and "npages".
These parameters specify the physical memory to be reclaimed, i.e.,
starting from the page at "start_idx" within a folio and spanning "npages"
contiguous PFNs. The specified memory must be entirely contained within a
single folio. Return TDX_SW_ERROR if the size of the reclaimed memory does
not match the specified size.

On the KVM side, introduce tdx_reclaim_folio() to align with and invoke the
SEAMCALL wrapper tdh_phymem_page_reclaim(). The "noclear" parameter
specifies whether tdx_clear_folio() should be subsequently invoked within
tdx_reclaim_folio(). Additionally, provide two helper functions,
tdx_reclaim_page() and tdx_reclaim_page_noclear(), to facilitate the
reclaiming of 4KB pages.

Signed-off-by: Xiaoyao Li <xiaoyao.li@intel.com>
Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
Signed-off-by: Yan Zhao <yan.y.zhao@intel.com>
---
RFC v2:
- Introduce new params "folio", "start_idx" and "npages" to wrapper
  tdh_phymem_page_reclaim().
- Move the checking of return size from KVM to x86/virt and return error.
- Rename tdx_reclaim_page() to tdx_reclaim_folio().
- Add two helper functions tdx_reclaim_page() tdx_reclaim_page_noclear()
  to faciliate the reclaiming of 4KB pages.

RFC v1:
- Rebased and split patch.
---
 arch/x86/include/asm/tdx.h  |  3 ++-
 arch/x86/kvm/vmx/tdx.c      | 27 ++++++++++++++++++---------
 arch/x86/virt/vmx/tdx/tdx.c | 12 ++++++++++--
 3 files changed, 30 insertions(+), 12 deletions(-)

diff --git a/arch/x86/include/asm/tdx.h b/arch/x86/include/asm/tdx.h
index a125bb20a28a..f1bd74348b34 100644
--- a/arch/x86/include/asm/tdx.h
+++ b/arch/x86/include/asm/tdx.h
@@ -189,7 +189,8 @@ u64 tdh_mng_init(struct tdx_td *td, u64 td_params, u64 *extended_err);
 u64 tdh_vp_init(struct tdx_vp *vp, u64 initial_rcx, u32 x2apicid);
 u64 tdh_vp_rd(struct tdx_vp *vp, u64 field, u64 *data);
 u64 tdh_vp_wr(struct tdx_vp *vp, u64 field, u64 data, u64 mask);
-u64 tdh_phymem_page_reclaim(struct page *page, u64 *tdx_pt, u64 *tdx_owner, u64 *tdx_size);
+u64 tdh_phymem_page_reclaim(struct folio *folio, unsigned long start_idx, unsigned long npages,
+			    u64 *tdx_pt, u64 *tdx_owner, u64 *tdx_size);
 u64 tdh_mem_track(struct tdx_td *tdr);
 u64 tdh_mem_page_remove(struct tdx_td *td, u64 gpa, u64 level, u64 *ext_err1, u64 *ext_err2);
 u64 tdh_phymem_cache_wb(bool resume);
diff --git a/arch/x86/kvm/vmx/tdx.c b/arch/x86/kvm/vmx/tdx.c
index 4fabefb27135..facfe589e006 100644
--- a/arch/x86/kvm/vmx/tdx.c
+++ b/arch/x86/kvm/vmx/tdx.c
@@ -327,11 +327,12 @@ static void tdx_no_vcpus_enter_stop(struct kvm *kvm)
 }
 
 /* TDH.PHYMEM.PAGE.RECLAIM is allowed only when destroying the TD. */
-static int __tdx_reclaim_page(struct page *page)
+static int tdx_reclaim_folio(struct folio *folio, unsigned long start_idx,
+			     unsigned long npages, bool noclear)
 {
 	u64 err, tdx_pt, tdx_owner, tdx_size;
 
-	err = tdh_phymem_page_reclaim(page, &tdx_pt, &tdx_owner, &tdx_size);
+	err = tdh_phymem_page_reclaim(folio, start_idx, npages, &tdx_pt, &tdx_owner, &tdx_size);
 
 	/*
 	 * No need to check for TDX_OPERAND_BUSY; all TD pages are freed
@@ -342,19 +343,25 @@ static int __tdx_reclaim_page(struct page *page)
 		pr_tdx_error_3(TDH_PHYMEM_PAGE_RECLAIM, err, tdx_pt, tdx_owner, tdx_size);
 		return -EIO;
 	}
+
+	if (!noclear)
+		tdx_clear_folio(folio, start_idx, npages);
 	return 0;
 }
 
 static int tdx_reclaim_page(struct page *page)
 {
-	int r;
+	struct folio *folio = page_folio(page);
 
-	r = __tdx_reclaim_page(page);
-	if (!r)
-		tdx_clear_page(page);
-	return r;
+	return tdx_reclaim_folio(folio, folio_page_idx(folio, page), 1, false);
 }
 
+static int tdx_reclaim_page_noclear(struct page *page)
+{
+	struct folio *folio = page_folio(page);
+
+	return tdx_reclaim_folio(folio, folio_page_idx(folio, page), 1, true);
+}
 
 /*
  * Reclaim the TD control page(s) which are crypto-protected by TDX guest's
@@ -587,7 +594,7 @@ static void tdx_reclaim_td_control_pages(struct kvm *kvm)
 	if (!kvm_tdx->td.tdr_page)
 		return;
 
-	if (__tdx_reclaim_page(kvm_tdx->td.tdr_page))
+	if (tdx_reclaim_page_noclear(kvm_tdx->td.tdr_page))
 		return;
 
 	/*
@@ -1932,11 +1939,13 @@ static int tdx_sept_remove_private_spte(struct kvm *kvm, gfn_t gfn,
 					enum pg_level level, kvm_pfn_t pfn)
 {
 	struct page *page = pfn_to_page(pfn);
+	struct folio *folio = page_folio(page);
 	int ret;
 
 	if (!is_hkid_assigned(to_kvm_tdx(kvm))) {
 		KVM_BUG_ON(!kvm->vm_dead, kvm);
-		ret = tdx_reclaim_page(page);
+		ret = tdx_reclaim_folio(folio, folio_page_idx(folio, page),
+					KVM_PAGES_PER_HPAGE(level), false);
 		if (!ret) {
 			tdx_pamt_put(page, level);
 			tdx_unpin(kvm, page);
diff --git a/arch/x86/virt/vmx/tdx/tdx.c b/arch/x86/virt/vmx/tdx/tdx.c
index 64219c659844..9ed585bde062 100644
--- a/arch/x86/virt/vmx/tdx/tdx.c
+++ b/arch/x86/virt/vmx/tdx/tdx.c
@@ -1966,19 +1966,27 @@ EXPORT_SYMBOL_GPL(tdh_vp_init);
  * So despite the names, they must be interpted specially as described by the spec. Return
  * them only for error reporting purposes.
  */
-u64 tdh_phymem_page_reclaim(struct page *page, u64 *tdx_pt, u64 *tdx_owner, u64 *tdx_size)
+u64 tdh_phymem_page_reclaim(struct folio *folio, unsigned long start_idx, unsigned long npages,
+			    u64 *tdx_pt, u64 *tdx_owner, u64 *tdx_size)
 {
+	struct page *start = folio_page(folio, start_idx);
 	struct tdx_module_args args = {
-		.rcx = page_to_phys(page),
+		.rcx = page_to_phys(start),
 	};
 	u64 ret;
 
+	if (start_idx + npages > folio_nr_pages(folio))
+		return TDX_OPERAND_INVALID;
+
 	ret = seamcall_ret(TDH_PHYMEM_PAGE_RECLAIM, &args);
 
 	*tdx_pt = args.rcx;
 	*tdx_owner = args.rdx;
 	*tdx_size = args.r8;
 
+	if (npages != (1 << (*tdx_size) * PTE_SHIFT))
+		return TDX_SW_ERROR;
+
 	return ret;
 }
 EXPORT_SYMBOL_GPL(tdh_phymem_page_reclaim);
-- 
2.43.2


