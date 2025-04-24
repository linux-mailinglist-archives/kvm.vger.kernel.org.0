Return-Path: <kvm+bounces-44031-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 099A0A99F35
	for <lists+kvm@lfdr.de>; Thu, 24 Apr 2025 05:06:31 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 14A2417FA3B
	for <lists+kvm@lfdr.de>; Thu, 24 Apr 2025 03:06:31 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F06DD1A4F12;
	Thu, 24 Apr 2025 03:06:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="X0XbfcVi"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 710151A23AC;
	Thu, 24 Apr 2025 03:06:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745463984; cv=none; b=m+kd0xJFh+MCF+pO9V/OBAyZCNF2MeZ/RQcaZlnhYEnw1gp1CQxgxPFh1stk3V8rGS2mJ+LFMwz6UarCzFONIeaOw6K7eUBL4tZBKzKUKwdlQA6+fjsH4htwxqmklQ0CzITNZBKUflbHG3G5+CXe+xzOyi26LgcIgYchLFAPRgE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745463984; c=relaxed/simple;
	bh=J1QhRvWhGNX1qcfCsY/s2pFV6LF7Jxs7qOu/mZoiXEA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cqYXGqsY0WxDowAuGDGZ6fQOVSesfsDoc+Aik24xJV6r24sq7pw3Rey4WnlZ5NQ9F4ARNaiMfBvRX3c4IQf5UF8kVUSr0YhGUaJ4CqRzVFRkia/GWJ/f0XnMi6ZQ7ewq2L+iiwdzJB0cGFkt/rSLo/F9sGg4N2bsKeSioe9+WYE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=X0XbfcVi; arc=none smtp.client-ip=198.175.65.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1745463982; x=1776999982;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=J1QhRvWhGNX1qcfCsY/s2pFV6LF7Jxs7qOu/mZoiXEA=;
  b=X0XbfcViRAF5qHO2ooV3HrnKAENOIuoM9bf+dUmjTlvgAUM2le2AolpG
   jdqM1SHRceqpIRKNTyXkOFTYlFLxnPSOZJCuVkUgxQ0YSkMLV3yjG51vw
   T24KOr0DwU2VepcZKrqTq3irHsCaegxIwHPkOhoVx9y4s67AbChIwHFs2
   LjJMdLoaAPD3RhWGxRsogiNj28tG6vjygRlTjEUt+r8wTAYBW0Vxe0CC+
   oBaUxnde3SrcLfeqhEDIOLc7hk0k3uuUAWQU1IjdyX658+Png8rVwcBnY
   P5dutEBDAPqQeU0mXyOl4JB9ZNXuXMWGOd6UxpAw72do8khUN4myPP8qu
   w==;
X-CSE-ConnectionGUID: cGNjB1jMQ0mwUUpGnMwRjA==
X-CSE-MsgGUID: 6C72jKNRSPaUzjgvoHu7zQ==
X-IronPort-AV: E=McAfee;i="6700,10204,11412"; a="47205540"
X-IronPort-AV: E=Sophos;i="6.15,233,1739865600"; 
   d="scan'208";a="47205540"
Received: from fmviesa009.fm.intel.com ([10.60.135.149])
  by orvoesa110.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Apr 2025 20:06:22 -0700
X-CSE-ConnectionGUID: ki3UGCczQ/KZrgRIINUE0A==
X-CSE-MsgGUID: KH1R96BfTOaZU1hGE8NrXQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.15,233,1739865600"; 
   d="scan'208";a="133383652"
Received: from yzhao56-desk.sh.intel.com ([10.239.159.62])
  by fmviesa009-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Apr 2025 20:06:16 -0700
From: Yan Zhao <yan.y.zhao@intel.com>
To: pbonzini@redhat.com,
	seanjc@google.com
Cc: linux-kernel@vger.kernel.org,
	kvm@vger.kernel.org,
	x86@kernel.org,
	rick.p.edgecombe@intel.com,
	dave.hansen@intel.com,
	kirill.shutemov@intel.com,
	tabba@google.com,
	ackerleytng@google.com,
	quic_eberman@quicinc.com,
	michael.roth@amd.com,
	david@redhat.com,
	vannapurve@google.com,
	vbabka@suse.cz,
	jroedel@suse.de,
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
	Yan Zhao <yan.y.zhao@intel.com>
Subject: [RFC PATCH 02/21] x86/virt/tdx: Enhance tdh_mem_page_aug() to support huge pages
Date: Thu, 24 Apr 2025 11:04:28 +0800
Message-ID: <20250424030428.32687-1-yan.y.zhao@intel.com>
X-Mailer: git-send-email 2.43.2
In-Reply-To: <20250424030033.32635-1-yan.y.zhao@intel.com>
References: <20250424030033.32635-1-yan.y.zhao@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Enhance the SEAMCALL wrapper tdh_mem_page_aug() to support huge pages.

Verify the validity of the level and ensure that the mapping range is fully
contained within the page folio.

As a conservative solution, perform CLFLUSH on all pages to be mapped into
the TD before invoking the SEAMCALL TDH_MEM_PAGE_AUG. This ensures that any
dirty cache lines do not write back later and clobber TD memory.

Signed-off-by: Xiaoyao Li <xiaoyao.li@intel.com>
Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
Signed-off-by: Yan Zhao <yan.y.zhao@intel.com>
---
 arch/x86/virt/vmx/tdx/tdx.c | 11 ++++++++++-
 1 file changed, 10 insertions(+), 1 deletion(-)

diff --git a/arch/x86/virt/vmx/tdx/tdx.c b/arch/x86/virt/vmx/tdx/tdx.c
index f5e2a937c1e7..a66d501b5677 100644
--- a/arch/x86/virt/vmx/tdx/tdx.c
+++ b/arch/x86/virt/vmx/tdx/tdx.c
@@ -1595,9 +1595,18 @@ u64 tdh_mem_page_aug(struct tdx_td *td, u64 gpa, int level, struct page *page, u
 		.rdx = tdx_tdr_pa(td),
 		.r8 = page_to_phys(page),
 	};
+	unsigned long nr_pages = 1 << (level * 9);
+	struct folio *folio = page_folio(page);
+	unsigned long idx = 0;
 	u64 ret;
 
-	tdx_clflush_page(page);
+	if (!(level >= TDX_PS_4K && level < TDX_PS_NR) ||
+	    (folio_page_idx(folio, page) + nr_pages > folio_nr_pages(folio)))
+		return -EINVAL;
+
+	while (nr_pages--)
+		tdx_clflush_page(nth_page(page, idx++));
+
 	ret = seamcall_ret(TDH_MEM_PAGE_AUG, &args);
 
 	*ext_err1 = args.rcx;
-- 
2.43.2


