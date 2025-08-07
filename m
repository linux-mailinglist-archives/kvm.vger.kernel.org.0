Return-Path: <kvm+bounces-54243-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 89E86B1D52E
	for <lists+kvm@lfdr.de>; Thu,  7 Aug 2025 11:47:35 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 697E63A532D
	for <lists+kvm@lfdr.de>; Thu,  7 Aug 2025 09:47:18 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E790F27057C;
	Thu,  7 Aug 2025 09:45:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="g2j2UeYv"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3149722D7B0;
	Thu,  7 Aug 2025 09:45:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754559955; cv=none; b=dvVTd11LzE06cAlINC3lPaoeLTiIiXv+HFMnKTHl8k8u3/QJgKlhRBJ8ih6SruPtDuVXQVSuLzJb10PLn+n2lQQoVLtXwPm58OPSZ+rR694jf/T/YuA1wOdvNxrx4d2DCel7yzcnvFH3nVZLV24tO5P+YT/IXQ8ynX5nWmqQbiA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754559955; c=relaxed/simple;
	bh=l29hIimh815GoKFm3H9eplWyu4g0DZR2lLgmyiXLfsk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mIOWdRbioFAholQwI0izWbnwGk3y9fRY5BZpC4QdbE8a5aBO9iymQXxLZX6IWl7B8Rux9xQg1D9hiOawX718HQSI1xclPSNNUjPSf6bkuqnCGrPfSI0O7wP/2LzZVlv6U9/74zcyu3H/+yILhWwJzCe/LHzAVzdmJj1RELHhIkQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=g2j2UeYv; arc=none smtp.client-ip=198.175.65.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1754559953; x=1786095953;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=l29hIimh815GoKFm3H9eplWyu4g0DZR2lLgmyiXLfsk=;
  b=g2j2UeYviSOMvdE9A/juneq4PLabTw5NPbL1lpDq+V2T0KBYAsGo2wlr
   dcmNowa0UnGZsFkEzkrmLxXQCHj0bVH+emeWibdjJw3qQpX70f/OcUzaI
   RJaYHRDjTXDJu2QKxbBlZWJLqUrQPGP7+rBlmIZ9o8FyeMTygT615LgVf
   Cw6hqWEW4rE8n66t318AMM1VU65ZYInog/aVpXk6gsnslA+1pu4DH1HTX
   pmVDgLBTZmrvNkd4cX962W7UC47U3OKZjLcZlMLreFc8NEWNhjbgTfkTz
   qbwAKIF46h0m/pRlK1g3nWSPmfkeiL1Sec2m2LbKVFYbirJ17YoukScT7
   w==;
X-CSE-ConnectionGUID: lSlgtCirR0esbptEACmicw==
X-CSE-MsgGUID: Azn3/zwjR8SIKc0i10KxFw==
X-IronPort-AV: E=McAfee;i="6800,10657,11514"; a="57028914"
X-IronPort-AV: E=Sophos;i="6.17,271,1747724400"; 
   d="scan'208";a="57028914"
Received: from orviesa001.jf.intel.com ([10.64.159.141])
  by orvoesa108.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Aug 2025 02:45:52 -0700
X-CSE-ConnectionGUID: sC/K2qvCTJmOT/2zC6GqcA==
X-CSE-MsgGUID: NC1tuRRITk+pgkHnDykcgg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.17,271,1747724400"; 
   d="scan'208";a="202196509"
Received: from yzhao56-desk.sh.intel.com ([10.239.47.19])
  by smtpauth.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Aug 2025 02:45:46 -0700
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
Subject: [RFC PATCH v2 18/23] x86/virt/tdx: Do not perform cache flushes unless CLFLUSH_BEFORE_ALLOC is set
Date: Thu,  7 Aug 2025 17:45:16 +0800
Message-ID: <20250807094516.4705-1-yan.y.zhao@intel.com>
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

From: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>

The TDX module enumerates with a TDX_FEATURES0 bit if an explicit cache
flush is necessary when switching KeyID for a page, like before
handing the page over to a TD.

Currently, none of the TDX-capable platforms have this bit enabled.

Moreover, cache flushing with TDH.PHYMEM.PAGE.WBINVD fails if
Dynamic PAMT is active and the target page is not 4k. The SEAMCALL only
supports 4k pages and will fail if there is no PAMT_4K for the HPA.

Avoid performing these cache flushes unless the CLFLUSH_BEFORE_ALLOC bit
of TDX_FEATURES0 is set.

Signed-off-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Signed-off-by: Yan Zhao <yan.y.zhao@intel.com>
---
RFC v2:
- Pulled from
  git://git.kernel.org/pub/scm/linux/kernel/git/kas/linux.git tdx/dpamt-huge.
- Rebased on top of TDX huge page RFC v2 (Yan)
---
 arch/x86/include/asm/tdx.h  |  1 +
 arch/x86/virt/vmx/tdx/tdx.c | 19 +++++++++++++------
 2 files changed, 14 insertions(+), 6 deletions(-)

diff --git a/arch/x86/include/asm/tdx.h b/arch/x86/include/asm/tdx.h
index f1bd74348b34..c058a82d4a97 100644
--- a/arch/x86/include/asm/tdx.h
+++ b/arch/x86/include/asm/tdx.h
@@ -15,6 +15,7 @@
 
 /* Bit definitions of TDX_FEATURES0 metadata field */
 #define TDX_FEATURES0_NO_RBP_MOD		BIT_ULL(18)
+#define TDX_FEATURES0_CLFLUSH_BEFORE_ALLOC	BIT_ULL(23)
 #define TDX_FEATURES0_DYNAMIC_PAMT		BIT_ULL(36)
 
 #ifndef __ASSEMBLER__
diff --git a/arch/x86/virt/vmx/tdx/tdx.c b/arch/x86/virt/vmx/tdx/tdx.c
index 9ed585bde062..b7a0ee0f4a50 100644
--- a/arch/x86/virt/vmx/tdx/tdx.c
+++ b/arch/x86/virt/vmx/tdx/tdx.c
@@ -1648,14 +1648,13 @@ static inline u64 tdx_tdvpr_pa(struct tdx_vp *td)
 	return page_to_phys(td->tdvpr_page);
 }
 
-/*
- * The TDX module exposes a CLFLUSH_BEFORE_ALLOC bit to specify whether
- * a CLFLUSH of pages is required before handing them to the TDX module.
- * Be conservative and make the code simpler by doing the CLFLUSH
- * unconditionally.
- */
 static void tdx_clflush_page(struct page *page)
 {
+	u64 tdx_features0 = tdx_sysinfo.features.tdx_features0;
+
+	if (tdx_features0 & TDX_FEATURES0_CLFLUSH_BEFORE_ALLOC)
+		return;
+
 	clflush_cache_range(page_to_virt(page), PAGE_SIZE);
 }
 
@@ -2030,8 +2029,12 @@ EXPORT_SYMBOL_GPL(tdh_phymem_cache_wb);
 
 u64 tdh_phymem_page_wbinvd_tdr(struct tdx_td *td)
 {
+	u64 tdx_features0 = tdx_sysinfo.features.tdx_features0;
 	struct tdx_module_args args = {};
 
+	if (tdx_features0 & TDX_FEATURES0_CLFLUSH_BEFORE_ALLOC)
+		return 0;
+
 	args.rcx = mk_keyed_paddr(tdx_global_keyid, td->tdr_page);
 
 	return seamcall(TDH_PHYMEM_PAGE_WBINVD, &args);
@@ -2041,10 +2044,14 @@ EXPORT_SYMBOL_GPL(tdh_phymem_page_wbinvd_tdr);
 u64 tdh_phymem_page_wbinvd_hkid(u64 hkid, struct folio *folio,
 				unsigned long start_idx, unsigned long npages)
 {
+	u64 tdx_features0 = tdx_sysinfo.features.tdx_features0;
 	struct page *start = folio_page(folio, start_idx);
 	struct tdx_module_args args = {};
 	u64 err;
 
+	if (tdx_features0 & TDX_FEATURES0_CLFLUSH_BEFORE_ALLOC)
+		return 0;
+
 	if (start_idx + npages > folio_nr_pages(folio))
 		return TDX_OPERAND_INVALID;
 
-- 
2.43.2


