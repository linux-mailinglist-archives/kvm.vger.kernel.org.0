Return-Path: <kvm+bounces-54226-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id A298EB1D4FF
	for <lists+kvm@lfdr.de>; Thu,  7 Aug 2025 11:42:18 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id BF5AD16586A
	for <lists+kvm@lfdr.de>; Thu,  7 Aug 2025 09:42:18 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5387125F963;
	Thu,  7 Aug 2025 09:42:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Ln1sFSz9"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 121BD4431;
	Thu,  7 Aug 2025 09:42:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.14
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754559729; cv=none; b=tCBrDU+TnGel6e1Rel37vwgSCzQ482DPdLtB56ZZXCA5h8QXjEIATPHJdc8Cem9XQrZF599yuI5RWqu+0CZwE0krz911ouoqkAo6irpS5+JN8LyyIcCrW9pKrcutkTP9DhmNOamY3U1pBfJ3n3XSPGU/XfI6myW4O+iNGEes1ww=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754559729; c=relaxed/simple;
	bh=h99/yXrpLZnsXTN/NGQaDPgwO9zsRViJOfnzyFynxLQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Fu0qfjtb7a2CFnlzcdeJsSdXar6hb6Ecgv+Een7fwDSOSS3TJBp6diWwicJEFwP5ADIAYUoxlAMxOGvq61wFZT1OnPgF5QBVw9erQc3jGmERsExPhiusrKCXNYxobdlqqvM+rS59kt0zri/igXnTlqNrS603Zb/KECwiGo1Kfjo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=Ln1sFSz9; arc=none smtp.client-ip=198.175.65.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1754559728; x=1786095728;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=h99/yXrpLZnsXTN/NGQaDPgwO9zsRViJOfnzyFynxLQ=;
  b=Ln1sFSz9l+3PZ6SEjuvvv930WGyD+e4Up6RvAaeQ/IT/j6I1iPS/dp7I
   IY0xjiL+EMpksB6NCPxegvfkkDIJ/7hBOVbxZeF8T7gYriqwvGigfAaUc
   DjPJcLXf19gKt0ZnMHG3n5E1JGlTeSI/mr7qzqql/9MzJ9ER3kovr+a0Y
   kYixDlnDsEnqg7aUQyk4VqssU+d1EoYQb4pTcpNyJQHotn/uUTEIWJmDG
   4+eHr4y65Knx62wrrsvw3LsQa9lWBcIXWEtmFQkrKK7Zhv5uL/hp5615P
   33wP6jr+2T400L06WhiGholSsThpl1xK/AcRh2Rrc/BZjpqQTrv/+8PGi
   w==;
X-CSE-ConnectionGUID: QyWrZWr1RM6vq9tL8qaphw==
X-CSE-MsgGUID: 8k1KQuwBSumtaCysf2BY4g==
X-IronPort-AV: E=McAfee;i="6800,10657,11514"; a="60728777"
X-IronPort-AV: E=Sophos;i="6.17,271,1747724400"; 
   d="scan'208";a="60728777"
Received: from fmviesa009.fm.intel.com ([10.60.135.149])
  by orvoesa106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Aug 2025 02:42:07 -0700
X-CSE-ConnectionGUID: mvg2/whKRt6CqS7eOWVjlw==
X-CSE-MsgGUID: M6IDKKUlTySl+so/YHEiFA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.17,271,1747724400"; 
   d="scan'208";a="165400949"
Received: from yzhao56-desk.sh.intel.com ([10.239.47.19])
  by fmviesa009-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Aug 2025 02:42:02 -0700
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
Subject: [RFC PATCH v2 01/23] x86/tdx: Enhance tdh_mem_page_aug() to support huge pages
Date: Thu,  7 Aug 2025 17:41:32 +0800
Message-ID: <20250807094132.4453-1-yan.y.zhao@intel.com>
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

Enhance the SEAMCALL wrapper tdh_mem_page_aug() to support huge pages.

The SEAMCALL TDH_MEM_PAGE_AUG currently supports adding physical memory to
the S-EPT up to 2MB in size.

While keeping the "level" parameter in the tdh_mem_page_aug() wrapper to
allow callers to specify the physical memory size, introduce the parameters
"folio" and "start_idx" to specify the physical memory starting from the
page at "start_idx" within the "folio". The specified physical memory must
be fully contained within a single folio.

Invoke tdx_clflush_page() for each 4KB segment of the physical memory being
added. tdx_clflush_page() performs CLFLUSH operations on certain
TDX-capable platforms, or conservatively on all TDX-capable platforms, to
prevent dirty cache lines from writing back later and corrupting TD memory.

Signed-off-by: Xiaoyao Li <xiaoyao.li@intel.com>
Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
Signed-off-by: Yan Zhao <yan.y.zhao@intel.com>
---
RFC v2:
- Refine patch log. (Rick)
- Removed the level checking. (Kirill, Chao Gao)
- Use "folio", and "start_idx" rather than "page".
- Return TDX_OPERAND_INVALID if the specified physical memory is not
  contained within a single folio.
- Use PTE_SHIFT to replace the 9 in "1 << (level * 9)" (Kirill)
- Use C99-style definition of variables inside a loop. (Nikolay Borisov)

RFC v1:
- Rebased to new tdh_mem_page_aug() with "struct page *" as param.
- Check folio, folio_page_idx.
---
 arch/x86/include/asm/tdx.h  |  3 ++-
 arch/x86/kvm/vmx/tdx.c      |  4 +++-
 arch/x86/virt/vmx/tdx/tdx.c | 14 +++++++++++---
 3 files changed, 16 insertions(+), 5 deletions(-)

diff --git a/arch/x86/include/asm/tdx.h b/arch/x86/include/asm/tdx.h
index 48d579092590..f968b736871a 100644
--- a/arch/x86/include/asm/tdx.h
+++ b/arch/x86/include/asm/tdx.h
@@ -171,7 +171,8 @@ u64 tdh_mng_addcx(struct tdx_td *td, struct page *tdcs_page);
 u64 tdh_mem_page_add(struct tdx_td *td, u64 gpa, struct page *page, struct page *source, u64 *ext_err1, u64 *ext_err2);
 u64 tdh_mem_sept_add(struct tdx_td *td, u64 gpa, int level, struct page *page, u64 *ext_err1, u64 *ext_err2);
 u64 tdh_vp_addcx(struct tdx_vp *vp, struct page *tdcx_page);
-u64 tdh_mem_page_aug(struct tdx_td *td, u64 gpa, int level, struct page *page, u64 *ext_err1, u64 *ext_err2);
+u64 tdh_mem_page_aug(struct tdx_td *td, u64 gpa, int level, struct folio *folio,
+		     unsigned long start_idx, u64 *ext_err1, u64 *ext_err2);
 u64 tdh_mem_range_block(struct tdx_td *td, u64 gpa, int level, u64 *ext_err1, u64 *ext_err2);
 u64 tdh_mng_key_config(struct tdx_td *td);
 u64 tdh_mng_create(struct tdx_td *td, u16 hkid);
diff --git a/arch/x86/kvm/vmx/tdx.c b/arch/x86/kvm/vmx/tdx.c
index ed67f842b6ec..0a2b183899d8 100644
--- a/arch/x86/kvm/vmx/tdx.c
+++ b/arch/x86/kvm/vmx/tdx.c
@@ -1593,11 +1593,13 @@ static int tdx_mem_page_aug(struct kvm *kvm, gfn_t gfn,
 {
 	int tdx_level = pg_level_to_tdx_sept_level(level);
 	struct kvm_tdx *kvm_tdx = to_kvm_tdx(kvm);
+	struct folio *folio = page_folio(page);
 	gpa_t gpa = gfn_to_gpa(gfn);
 	u64 entry, level_state;
 	u64 err;
 
-	err = tdh_mem_page_aug(&kvm_tdx->td, gpa, tdx_level, page, &entry, &level_state);
+	err = tdh_mem_page_aug(&kvm_tdx->td, gpa, tdx_level, folio,
+			       folio_page_idx(folio, page), &entry, &level_state);
 	if (unlikely(tdx_operand_busy(err))) {
 		tdx_unpin(kvm, page);
 		return -EBUSY;
diff --git a/arch/x86/virt/vmx/tdx/tdx.c b/arch/x86/virt/vmx/tdx/tdx.c
index e411cf878547..580f14f64822 100644
--- a/arch/x86/virt/vmx/tdx/tdx.c
+++ b/arch/x86/virt/vmx/tdx/tdx.c
@@ -1730,16 +1730,24 @@ u64 tdh_vp_addcx(struct tdx_vp *vp, struct page *tdcx_page)
 }
 EXPORT_SYMBOL_GPL(tdh_vp_addcx);
 
-u64 tdh_mem_page_aug(struct tdx_td *td, u64 gpa, int level, struct page *page, u64 *ext_err1, u64 *ext_err2)
+u64 tdh_mem_page_aug(struct tdx_td *td, u64 gpa, int level, struct folio *folio,
+		     unsigned long start_idx, u64 *ext_err1, u64 *ext_err2)
 {
+	struct page *start = folio_page(folio, start_idx);
+	unsigned long npages = 1 << (level * PTE_SHIFT);
 	struct tdx_module_args args = {
 		.rcx = gpa | level,
 		.rdx = tdx_tdr_pa(td),
-		.r8 = page_to_phys(page),
+		.r8 = page_to_phys(start),
 	};
 	u64 ret;
 
-	tdx_clflush_page(page);
+	if (start_idx + npages > folio_nr_pages(folio))
+		return TDX_OPERAND_INVALID;
+
+	for (int i = 0; i < npages; i++)
+		tdx_clflush_page(nth_page(start, i));
+
 	ret = seamcall_ret(TDH_MEM_PAGE_AUG, &args);
 
 	*ext_err1 = args.rcx;
-- 
2.43.2


