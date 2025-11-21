Return-Path: <kvm+bounces-64043-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [172.105.105.114])
	by mail.lfdr.de (Postfix) with ESMTPS id 3E1E6C76D22
	for <lists+kvm@lfdr.de>; Fri, 21 Nov 2025 01:56:38 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by tor.lore.kernel.org (Postfix) with ESMTPS id 3590029D1D
	for <lists+kvm@lfdr.de>; Fri, 21 Nov 2025 00:56:37 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EBE472D97BB;
	Fri, 21 Nov 2025 00:51:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="CGgxD631"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C228D2C15A8;
	Fri, 21 Nov 2025 00:51:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.19
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763686314; cv=none; b=hcRda/+t7Prh/Eft+2Ozmrf7S7XpKaNi0QLWTrCJBs6BiicPg6ORySYJ1Om1Kg6GdbxV3/LRZsXgZzn+gZEnjsLDguIKGeFTKl/vN3l2fU+U9pe1e77GXHEiPE3KyISAohGI+b88h6qhC8MCRlpXXUo21H1pWXsS644htUhzwlA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763686314; c=relaxed/simple;
	bh=wh+YRn0xltAgG792TBMu2z72y+pa2LZT1HUUgzS2Xjk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mjrtGpB+5Q/p2qGYq//5KaGrsbG0BT5HifNR0dUOEM5XUTg8e1U2Ixp1cUcKNpY8shLZf56ERy1/iuKMGf12EhrRI/EWK9JcxW5slMEgjw8R227WlUQGt20NVubbu4i/Zow97+8/OAP5C0F06ShVFJWC6VumCaeOter8868q0xQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=CGgxD631; arc=none smtp.client-ip=192.198.163.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1763686313; x=1795222313;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=wh+YRn0xltAgG792TBMu2z72y+pa2LZT1HUUgzS2Xjk=;
  b=CGgxD631V/0eLMn4fYHW2j5px5JLMqx8yB0g0ssDbFobtm4nbwnEOjbB
   fNEh/8McpMUs/3nsx+Q8WMdPUx79K6rhA9l9mDUj985n+VkgXFDVHdBvT
   hz8JXgPNsuw+1Bu6EGJ42deDCt549Z5AEiYEbNbJcVvRQkiDVqaSP+yUV
   +NcIUq2d1lAKLp4k2I+WIIZ6/X8VQkMciyVIfI484EO7Y7DIE3c7PPzU/
   EjIV1hjCKx9FY68MiGQ+LqBbFn00WxkzAr2Jf+sUXnHmYJJjIZZ2G1Xh/
   CKpKI8lcM7FRGown1iNKmNXYTgtLtRDYghtJuQTJD6PQJKzf4+swoj9Ys
   A==;
X-CSE-ConnectionGUID: kmOTHyn6T2KDxmvREs7KkA==
X-CSE-MsgGUID: gmH+ySouTvWz5+RLSBsJjw==
X-IronPort-AV: E=McAfee;i="6800,10657,11619"; a="64780827"
X-IronPort-AV: E=Sophos;i="6.20,214,1758610800"; 
   d="scan'208";a="64780827"
Received: from fmviesa003.fm.intel.com ([10.60.135.143])
  by fmvoesa113.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Nov 2025 16:51:47 -0800
X-CSE-ConnectionGUID: 7aTv8YVMRCGskKVI0B2T+Q==
X-CSE-MsgGUID: OhdmDVH6Sreh6hnJ6hGZFw==
X-ExtLoop1: 1
Received: from rpedgeco-desk.jf.intel.com ([10.88.27.139])
  by fmviesa003-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Nov 2025 16:51:47 -0800
From: Rick Edgecombe <rick.p.edgecombe@intel.com>
To: bp@alien8.de,
	chao.gao@intel.com,
	dave.hansen@intel.com,
	isaku.yamahata@intel.com,
	kai.huang@intel.com,
	kas@kernel.org,
	kvm@vger.kernel.org,
	linux-coco@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	mingo@redhat.com,
	pbonzini@redhat.com,
	seanjc@google.com,
	tglx@linutronix.de,
	vannapurve@google.com,
	x86@kernel.org,
	yan.y.zhao@intel.com,
	xiaoyao.li@intel.com,
	binbin.wu@intel.com
Cc: rick.p.edgecombe@intel.com,
	"Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Subject: [PATCH v4 15/16] x86/virt/tdx: Enable Dynamic PAMT
Date: Thu, 20 Nov 2025 16:51:24 -0800
Message-ID: <20251121005125.417831-16-rick.p.edgecombe@intel.com>
X-Mailer: git-send-email 2.51.2
In-Reply-To: <20251121005125.417831-1-rick.p.edgecombe@intel.com>
References: <20251121005125.417831-1-rick.p.edgecombe@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>

The Physical Address Metadata Table (PAMT) holds TDX metadata for
physical memory and must be allocated by the kernel during TDX module
initialization.

The exact size of the required PAMT memory is determined by the TDX
module and may vary between TDX module versions, but currently it is
approximately 0.4% of the system memory. This is a significant
commitment, especially if it is not known upfront whether the machine
will run any TDX guests.

The Dynamic PAMT feature reduces static PAMT allocations. PAMT_1G and
PAMT_2M levels are still allocated on TDX module initialization, but the
PAMT_4K level is allocated dynamically, reducing static allocations to
approximately 0.004% of the system memory.

All pieces are in place. Enable Dynamic PAMT if it is supported.

Signed-off-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Signed-off-by: Rick Edgecombe <rick.p.edgecombe@intel.com>
---
 arch/x86/include/asm/tdx.h  | 6 +++++-
 arch/x86/virt/vmx/tdx/tdx.c | 8 ++++++++
 arch/x86/virt/vmx/tdx/tdx.h | 3 ---
 3 files changed, 13 insertions(+), 4 deletions(-)

diff --git a/arch/x86/include/asm/tdx.h b/arch/x86/include/asm/tdx.h
index 416ca9a738ee..0ccd0e0e0df7 100644
--- a/arch/x86/include/asm/tdx.h
+++ b/arch/x86/include/asm/tdx.h
@@ -12,6 +12,10 @@
 #include <asm/trapnr.h>
 #include <asm/shared/tdx.h>
 
+/* Bit definitions of TDX_FEATURES0 metadata field */
+#define TDX_FEATURES0_NO_RBP_MOD		BIT_ULL(18)
+#define TDX_FEATURES0_DYNAMIC_PAMT		BIT_ULL(36)
+
 #ifndef __ASSEMBLER__
 
 #include <uapi/asm/mce.h>
@@ -133,7 +137,7 @@ const struct tdx_sys_info *tdx_get_sysinfo(void);
 
 static inline bool tdx_supports_dynamic_pamt(const struct tdx_sys_info *sysinfo)
 {
-	return false; /* To be enabled when kernel is ready */
+	return sysinfo->features.tdx_features0 & TDX_FEATURES0_DYNAMIC_PAMT;
 }
 
 void tdx_quirk_reset_page(struct page *page);
diff --git a/arch/x86/virt/vmx/tdx/tdx.c b/arch/x86/virt/vmx/tdx/tdx.c
index 74b0342b7570..144e62303aa3 100644
--- a/arch/x86/virt/vmx/tdx/tdx.c
+++ b/arch/x86/virt/vmx/tdx/tdx.c
@@ -1067,6 +1067,8 @@ static int construct_tdmrs(struct list_head *tmb_list,
 	return ret;
 }
 
+#define TDX_SYS_CONFIG_DYNAMIC_PAMT	BIT(16)
+
 static int config_tdx_module(struct tdmr_info_list *tdmr_list, u64 global_keyid)
 {
 	struct tdx_module_args args = {};
@@ -1094,6 +1096,12 @@ static int config_tdx_module(struct tdmr_info_list *tdmr_list, u64 global_keyid)
 	args.rcx = __pa(tdmr_pa_array);
 	args.rdx = tdmr_list->nr_consumed_tdmrs;
 	args.r8 = global_keyid;
+
+	if (tdx_supports_dynamic_pamt(&tdx_sysinfo)) {
+		pr_info("Enable Dynamic PAMT\n");
+		args.r8 |= TDX_SYS_CONFIG_DYNAMIC_PAMT;
+	}
+
 	ret = seamcall_prerr(TDH_SYS_CONFIG, &args);
 
 	/* Free the array as it is not required anymore. */
diff --git a/arch/x86/virt/vmx/tdx/tdx.h b/arch/x86/virt/vmx/tdx/tdx.h
index 46c4214b79fb..096c78a1d438 100644
--- a/arch/x86/virt/vmx/tdx/tdx.h
+++ b/arch/x86/virt/vmx/tdx/tdx.h
@@ -86,9 +86,6 @@ struct tdmr_info {
 	DECLARE_FLEX_ARRAY(struct tdmr_reserved_area, reserved_areas);
 } __packed __aligned(TDMR_INFO_ALIGNMENT);
 
-/* Bit definitions of TDX_FEATURES0 metadata field */
-#define TDX_FEATURES0_NO_RBP_MOD	BIT(18)
-
 /*
  * Do not put any hardware-defined TDX structure representations below
  * this comment!
-- 
2.51.2


