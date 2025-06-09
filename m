Return-Path: <kvm+bounces-48760-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id B3F2FAD2685
	for <lists+kvm@lfdr.de>; Mon,  9 Jun 2025 21:16:00 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 6FC8C1703B3
	for <lists+kvm@lfdr.de>; Mon,  9 Jun 2025 19:16:01 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 17D55221DA6;
	Mon,  9 Jun 2025 19:14:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="BRmw9W6K"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 36300221725;
	Mon,  9 Jun 2025 19:14:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.19
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749496443; cv=none; b=DAiIzHiFmXBP/l3V0zt1xUswJ9ovmA+vIjpQRcSjsxN8jjOCJ/swbSbLK2RPgAMcbJ3KDKhAkSI06GqNhYM1esFl/Zub4+vFMYpF0uY0u3p12A4nkHmMg8dD3Hb+YrsW+xo/Q//WtaNxAARQ+3yFGITS0cpDzaVqW8Wt+JOb+W8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749496443; c=relaxed/simple;
	bh=8rUB5lKZK3FbRxrTpkzxHWu3XBODRxiLmbQSXovzhx0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=heRNX9ADur89VFOL7u/7d5YoiZoba5Ov4PLz+ob4FzllkcxV96GkhM5W8Ats8g6FzuOvNrJPNJt+siy8RSCASlUrMRUJ7erYGvOExUw+Y8IWv4w8NDO15FEY3TOMufdJG/3vx6J/XzXr0edoFzVtDYSlnlmRLf9k2bnAEQKVvPQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.helo=mgamail.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=BRmw9W6K; arc=none smtp.client-ip=198.175.65.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.helo=mgamail.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1749496441; x=1781032441;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=8rUB5lKZK3FbRxrTpkzxHWu3XBODRxiLmbQSXovzhx0=;
  b=BRmw9W6K/z+mkJ2ICWHxyuGXs+UNGCf5fSNY/XSRyAS8iSshnOMWkID+
   iVcFjcTr8wSo50HyhAffc+DLkPr4A9DXmhYEaeXUVtzD9ojfjGGjr7ddD
   UFonQwmiJCpAm0EMLSfj+3RuycR6r9hzoemH4zpKFp4pNGLWjOe3bA3A/
   ZnBStxT9SZAA4wxKBpGjKfnNgvykdQ75RpNWm1Vr0sB6026UWlW7cwdLw
   mLB1UZNrD/SLLLwLhw8L0RYOjeY814MPosiLIakV6m7jWSg91y6fSZd58
   8hyfFa7AqoIExPk1QEl8yUetMypgS+DF4zWalE73ahKNoG9GU2X4ZytbJ
   A==;
X-CSE-ConnectionGUID: D8l5jOZ6TXaTW0WXeVejRA==
X-CSE-MsgGUID: Rmg+nucpRUuN7cn+bjhlLw==
X-IronPort-AV: E=McAfee;i="6800,10657,11459"; a="51467276"
X-IronPort-AV: E=Sophos;i="6.16,223,1744095600"; 
   d="scan'208";a="51467276"
Received: from orviesa008.jf.intel.com ([10.64.159.148])
  by orvoesa111.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Jun 2025 12:14:01 -0700
X-CSE-ConnectionGUID: hAoX+B1/T9O/+n1A8mtWNw==
X-CSE-MsgGUID: 7H05x142SKmu7hdMQ2oWJg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.16,223,1744095600"; 
   d="scan'208";a="147562196"
Received: from black.fi.intel.com ([10.237.72.28])
  by orviesa008.jf.intel.com with ESMTP; 09 Jun 2025 12:13:56 -0700
Received: by black.fi.intel.com (Postfix, from userid 1000)
	id 7D1A8B59; Mon, 09 Jun 2025 22:13:49 +0300 (EEST)
From: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
To: pbonzini@redhat.com,
	seanjc@google.com,
	dave.hansen@linux.intel.com
Cc: rick.p.edgecombe@intel.com,
	isaku.yamahata@intel.com,
	kai.huang@intel.com,
	yan.y.zhao@intel.com,
	chao.gao@intel.com,
	tglx@linutronix.de,
	mingo@redhat.com,
	bp@alien8.de,
	kvm@vger.kernel.org,
	x86@kernel.org,
	linux-coco@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	"Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Subject: [PATCHv2 11/12] x86/virt/tdx: Enable Dynamic PAMT
Date: Mon,  9 Jun 2025 22:13:39 +0300
Message-ID: <20250609191340.2051741-12-kirill.shutemov@linux.intel.com>
X-Mailer: git-send-email 2.47.2
In-Reply-To: <20250609191340.2051741-1-kirill.shutemov@linux.intel.com>
References: <20250609191340.2051741-1-kirill.shutemov@linux.intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

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
---
 arch/x86/include/asm/tdx.h  | 6 +++++-
 arch/x86/virt/vmx/tdx/tdx.c | 8 ++++++++
 arch/x86/virt/vmx/tdx/tdx.h | 3 ---
 3 files changed, 13 insertions(+), 4 deletions(-)

diff --git a/arch/x86/include/asm/tdx.h b/arch/x86/include/asm/tdx.h
index 853471e1eda1..8897c7416309 100644
--- a/arch/x86/include/asm/tdx.h
+++ b/arch/x86/include/asm/tdx.h
@@ -13,6 +13,10 @@
 #include <asm/tdx_errno.h>
 #include <asm/shared/tdx.h>
 
+/* Bit definitions of TDX_FEATURES0 metadata field */
+#define TDX_FEATURES0_NO_RBP_MOD		BIT_ULL(18)
+#define TDX_FEATURES0_DYNAMIC_PAMT		BIT_ULL(36)
+
 #ifndef __ASSEMBLER__
 
 #include <uapi/asm/mce.h>
@@ -108,7 +112,7 @@ const struct tdx_sys_info *tdx_get_sysinfo(void);
 
 static inline bool tdx_supports_dynamic_pamt(const struct tdx_sys_info *sysinfo)
 {
-	return false; /* To be enabled when kernel is ready */
+	return sysinfo->features.tdx_features0 & TDX_FEATURES0_DYNAMIC_PAMT;
 }
 
 int tdx_guest_keyid_alloc(void);
diff --git a/arch/x86/virt/vmx/tdx/tdx.c b/arch/x86/virt/vmx/tdx/tdx.c
index 4dcba7bf4ab9..d9f27647424d 100644
--- a/arch/x86/virt/vmx/tdx/tdx.c
+++ b/arch/x86/virt/vmx/tdx/tdx.c
@@ -1047,6 +1047,8 @@ static int construct_tdmrs(struct list_head *tmb_list,
 	return ret;
 }
 
+#define TDX_SYS_CONFIG_DYNAMIC_PAMT	BIT(16)
+
 static int config_tdx_module(struct tdmr_info_list *tdmr_list, u64 global_keyid)
 {
 	struct tdx_module_args args = {};
@@ -1074,6 +1076,12 @@ static int config_tdx_module(struct tdmr_info_list *tdmr_list, u64 global_keyid)
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
2.47.2


