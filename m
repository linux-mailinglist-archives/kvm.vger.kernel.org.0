Return-Path: <kvm+bounces-29843-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id B8DDC9B3098
	for <lists+kvm@lfdr.de>; Mon, 28 Oct 2024 13:43:27 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id DC2D21C21C12
	for <lists+kvm@lfdr.de>; Mon, 28 Oct 2024 12:43:26 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 504B31DB522;
	Mon, 28 Oct 2024 12:41:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="gW52PwuS"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.13])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 696951DD88F;
	Mon, 28 Oct 2024 12:41:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.13
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730119312; cv=none; b=cX9QZJfKecSEf3L/kkGPPKCU+S0cViS7RgBxNtrcKKtTw/M9qUea9enYI//VyHlmMrq1R5Ql3bWRj2aoa5v6irhb1EDJufyFewrCeBQEtl3FuyADUp0VDkmscDrPpBPg4TE336dwp9VyzWtPlxOxUh/FqyhKFaEje7j7DqENDDI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730119312; c=relaxed/simple;
	bh=X8PJeFZaZMWrGhqDp0QDC1zBg/lEysrTSsrCDJufiZc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=etbDMi3u2X0Alw1O5OJ1ql4F0gZYhYu/rd/ttXY6f0kuW6e67aNV/j8NNfUO/4pRmD6IxAvuwqywp5aMJ0Jem/GgqUIFP/q5qp/5XjZCwodlX/c8CIj7y3EwTTBNvJUMad1PJI3ZxcdnrC8GSaBha9sYUATXry8ZaoguNOuqGwg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=gW52PwuS; arc=none smtp.client-ip=192.198.163.13
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1730119310; x=1761655310;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=X8PJeFZaZMWrGhqDp0QDC1zBg/lEysrTSsrCDJufiZc=;
  b=gW52PwuS4toxo8lrG9h87EjXaX0EcdvTnxiZRTAhhmL7f3qx/hqRXf/u
   gDRejgslKRlLaFeGM6a5et0iy4amWgT3+21iPIN1eDrHgqfA2V79zuWMc
   q2l3SgWU50DD7uCMQITiGwnIVcL6efxy9uxgjhwva7Tu95ITePb8af+L5
   LfZo2o3Fo+F3QlBFTyG33p2PMl0p7ZLmBtJAvZ9Ij/G9GR+/OIROHEFDY
   if4OVPOI6Bb/34zIwTNl3LGdo860oSwA8FrZpWrTCBRyM1upYKkD5JKnA
   9WQWpAj6b4pv0WBZugJwGzIOCJ7OvEMju0VDlbnsGgxt0e4GZeqgEvbuR
   w==;
X-CSE-ConnectionGUID: HTlW77xGSzKoFnZBDWTwRw==
X-CSE-MsgGUID: i6CmZmpaQ4G3nBimCWfXPw==
X-IronPort-AV: E=McAfee;i="6700,10204,11238"; a="32575294"
X-IronPort-AV: E=Sophos;i="6.11,239,1725346800"; 
   d="scan'208";a="32575294"
Received: from orviesa008.jf.intel.com ([10.64.159.148])
  by fmvoesa107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Oct 2024 05:41:50 -0700
X-CSE-ConnectionGUID: k0PH3NDDT8WmmqPepANj+A==
X-CSE-MsgGUID: RuM0cbalQhWKdLZ4u3fdug==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.11,239,1725346800"; 
   d="scan'208";a="82420926"
Received: from gargmani-mobl1.amr.corp.intel.com (HELO khuang2-desk.gar.corp.intel.com) ([10.124.222.169])
  by orviesa008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Oct 2024 05:41:46 -0700
From: Kai Huang <kai.huang@intel.com>
To: dave.hansen@intel.com,
	kirill.shutemov@linux.intel.com,
	tglx@linutronix.de,
	bp@alien8.de,
	peterz@infradead.org,
	mingo@redhat.com,
	hpa@zytor.com,
	dan.j.williams@intel.com,
	seanjc@google.com,
	pbonzini@redhat.com
Cc: x86@kernel.org,
	linux-kernel@vger.kernel.org,
	kvm@vger.kernel.org,
	rick.p.edgecombe@intel.com,
	isaku.yamahata@intel.com,
	adrian.hunter@intel.com,
	nik.borisov@suse.com,
	kai.huang@intel.com
Subject: [PATCH v6 06/10] x86/virt/tdx: Switch to use auto-generated global metadata reading code
Date: Tue, 29 Oct 2024 01:41:08 +1300
Message-ID: <7382397ef94470c8a2b074bbdf507581b1b9db7e.1730118186.git.kai.huang@intel.com>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <cover.1730118186.git.kai.huang@intel.com>
References: <cover.1730118186.git.kai.huang@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Now the caller to read global metadata has been tweaked to be ready to
use auto-generated metadata reading code.  Switch to use it.

Signed-off-by: Kai Huang <kai.huang@intel.com>
---
 arch/x86/virt/vmx/tdx/tdx.c | 61 +------------------------------------
 arch/x86/virt/vmx/tdx/tdx.h | 45 +--------------------------
 2 files changed, 2 insertions(+), 104 deletions(-)

diff --git a/arch/x86/virt/vmx/tdx/tdx.c b/arch/x86/virt/vmx/tdx/tdx.c
index 28537a6c47fc..43ec56db5084 100644
--- a/arch/x86/virt/vmx/tdx/tdx.c
+++ b/arch/x86/virt/vmx/tdx/tdx.c
@@ -270,66 +270,7 @@ static int read_sys_metadata_field(u64 field_id, u64 *data)
 	return 0;
 }
 
-static int read_sys_metadata_field16(u64 field_id,
-				     int offset,
-				     struct tdx_sys_info_tdmr *ts)
-{
-	u16 *ts_member = ((void *)ts) + offset;
-	u64 tmp;
-	int ret;
-
-	if (WARN_ON_ONCE(MD_FIELD_ID_ELE_SIZE_CODE(field_id) !=
-			MD_FIELD_ID_ELE_SIZE_16BIT))
-		return -EINVAL;
-
-	ret = read_sys_metadata_field(field_id, &tmp);
-	if (ret)
-		return ret;
-
-	*ts_member = tmp;
-
-	return 0;
-}
-
-struct field_mapping {
-	u64 field_id;
-	int offset;
-};
-
-#define TD_SYSINFO_MAP(_field_id, _offset) \
-	{ .field_id = MD_FIELD_ID_##_field_id,	   \
-	  .offset   = offsetof(struct tdx_sys_info_tdmr, _offset) }
-
-/* Map TD_SYSINFO fields into 'struct tdx_sys_info_tdmr': */
-static const struct field_mapping fields[] = {
-	TD_SYSINFO_MAP(MAX_TDMRS,	      max_tdmrs),
-	TD_SYSINFO_MAP(MAX_RESERVED_PER_TDMR, max_reserved_per_tdmr),
-	TD_SYSINFO_MAP(PAMT_4K_ENTRY_SIZE,    pamt_4k_entry_size),
-	TD_SYSINFO_MAP(PAMT_2M_ENTRY_SIZE,    pamt_2m_entry_size),
-	TD_SYSINFO_MAP(PAMT_1G_ENTRY_SIZE,    pamt_1g_entry_size),
-};
-
-static int get_tdx_sys_info_tdmr(struct tdx_sys_info_tdmr *sysinfo_tdmr)
-{
-	int ret;
-	int i;
-
-	/* Populate 'sysinfo_tdmr' fields using the mapping structure above: */
-	for (i = 0; i < ARRAY_SIZE(fields); i++) {
-		ret = read_sys_metadata_field16(fields[i].field_id,
-						fields[i].offset,
-						sysinfo_tdmr);
-		if (ret)
-			return ret;
-	}
-
-	return 0;
-}
-
-static int get_tdx_sys_info(struct tdx_sys_info *sysinfo)
-{
-	return get_tdx_sys_info_tdmr(&sysinfo->tdmr);
-}
+#include "tdx_global_metadata.c"
 
 /* Calculate the actual TDMR size */
 static int tdmr_size_single(u16 max_reserved_per_tdmr)
diff --git a/arch/x86/virt/vmx/tdx/tdx.h b/arch/x86/virt/vmx/tdx/tdx.h
index b1d705c3ab2a..0128b963b723 100644
--- a/arch/x86/virt/vmx/tdx/tdx.h
+++ b/arch/x86/virt/vmx/tdx/tdx.h
@@ -5,7 +5,7 @@
 #include <linux/types.h>
 #include <linux/compiler_attributes.h>
 #include <linux/stddef.h>
-#include <linux/bits.h>
+#include "tdx_global_metadata.h"
 
 /*
  * This file contains both macros and data structures defined by the TDX
@@ -29,35 +29,6 @@
 #define	PT_NDA		0x0
 #define	PT_RSVD		0x1
 
-/*
- * Global scope metadata field ID.
- *
- * See Table "Global Scope Metadata", TDX module 1.5 ABI spec.
- */
-#define MD_FIELD_ID_MAX_TDMRS			0x9100000100000008ULL
-#define MD_FIELD_ID_MAX_RESERVED_PER_TDMR	0x9100000100000009ULL
-#define MD_FIELD_ID_PAMT_4K_ENTRY_SIZE		0x9100000100000010ULL
-#define MD_FIELD_ID_PAMT_2M_ENTRY_SIZE		0x9100000100000011ULL
-#define MD_FIELD_ID_PAMT_1G_ENTRY_SIZE		0x9100000100000012ULL
-
-/*
- * Sub-field definition of metadata field ID.
- *
- * See Table "MD_FIELD_ID (Metadata Field Identifier / Sequence Header)
- * Definition", TDX module 1.5 ABI spec.
- *
- *  - Bit 33:32: ELEMENT_SIZE_CODE -- size of a single element of metadata
- *
- *	0: 8 bits
- *	1: 16 bits
- *	2: 32 bits
- *	3: 64 bits
- */
-#define MD_FIELD_ID_ELE_SIZE_CODE(_field_id)	\
-		(((_field_id) & GENMASK_ULL(33, 32)) >> 32)
-
-#define MD_FIELD_ID_ELE_SIZE_16BIT	1
-
 struct tdmr_reserved_area {
 	u64 offset;
 	u64 size;
@@ -83,20 +54,6 @@ struct tdmr_info {
 	DECLARE_FLEX_ARRAY(struct tdmr_reserved_area, reserved_areas);
 } __packed __aligned(TDMR_INFO_ALIGNMENT);
 
-/* Class "TDMR info" */
-struct tdx_sys_info_tdmr {
-	u16 max_tdmrs;
-	u16 max_reserved_per_tdmr;
-	u16 pamt_4k_entry_size;
-	u16 pamt_2m_entry_size;
-	u16 pamt_1g_entry_size;
-};
-
-/* Kernel used global metadata fields */
-struct tdx_sys_info {
-	struct tdx_sys_info_tdmr tdmr;
-};
-
 /*
  * Do not put any hardware-defined TDX structure representations below
  * this comment!
-- 
2.46.2


