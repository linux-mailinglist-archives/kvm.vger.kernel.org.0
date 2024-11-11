Return-Path: <kvm+bounces-31445-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 4C2999C3C42
	for <lists+kvm@lfdr.de>; Mon, 11 Nov 2024 11:44:01 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id D25741F22348
	for <lists+kvm@lfdr.de>; Mon, 11 Nov 2024 10:44:00 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5124619EEBD;
	Mon, 11 Nov 2024 10:40:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="KFfG0+qo"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EE68D19E97B;
	Mon, 11 Nov 2024 10:40:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731321637; cv=none; b=ZPfAaiBOTDddeHX+EpNmR/RfUsqqI2p5eipy0rE6M5eYvT6T6PxCAxstqYPZQYDEpqeGAzqZyA18ic82dWSDEvSvze/Jo2xacM+Y+7npScrWFpzuWiLx/BLdy+QUuBdQcqhLEGATo18GHYqdzzK6PWxl9NokdWFj2qhT3tkVjV8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731321637; c=relaxed/simple;
	bh=sZVhSxzA8SMiIDj3Do3YITjBswuCGDLqzgeSyO5HxQw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=q0B02Kc0d00bVR1T2CsMBwdOlov1fiZulsoSZ/4kk0ENtv5u2O4HD3M9XofNfyhwVf6wONu5r1vTsbs02siwIDGqlwT6wC5V+VNDgT80LSLqlF9rEVS2MYg8JigR4D02FkubfNtSCvlUJyQn3sEa0DUWcNKtFrJGYlGWDpjaPgs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=KFfG0+qo; arc=none smtp.client-ip=198.175.65.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1731321637; x=1762857637;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=sZVhSxzA8SMiIDj3Do3YITjBswuCGDLqzgeSyO5HxQw=;
  b=KFfG0+qorwcI3q7zs8SM0HRE6iDko883lf61yffOIExz515JvFYVbEbt
   jyUARcZS8gIpn+5gmTaTkcIA4aFZGp8Z7xyQ5eGgMxGJJ1TX74RDyz0bU
   xcRXDcJyd/zXAvfcKJb85OjxDUQ9kDtB3hK2ow4UGX8J4HsayvKbnJB9q
   HlW0e+Uk69tye4DGy5FgGsdvstTcC0ABHvC+Dn4upEePijMV/Au3w4irB
   nlDKcjkGfweONyBg49WOOqRXHsKyEZ5OPTrUesZfezdh+26shK1p712pq
   hpGony48DRHQlYn9SAHZyGzKUCWuHjE8hS3QMruVgx2HKBwvNTbt+sq82
   w==;
X-CSE-ConnectionGUID: CHj/6UCoQgWkbVgawCcJ0Q==
X-CSE-MsgGUID: F9RoycdoSXWvjoKKCSb++A==
X-IronPort-AV: E=McAfee;i="6700,10204,11222"; a="41682696"
X-IronPort-AV: E=Sophos;i="6.11,199,1725346800"; 
   d="scan'208";a="41682696"
Received: from orviesa002.jf.intel.com ([10.64.159.142])
  by orvoesa103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Nov 2024 02:40:36 -0800
X-CSE-ConnectionGUID: n21rhjUWTR67udJyV3TZFg==
X-CSE-MsgGUID: I6JDnHdORE2jam7w4uqOLA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.12,144,1728975600"; 
   d="scan'208";a="117667509"
Received: from uaeoff-desk2.amr.corp.intel.com (HELO khuang2-desk.gar.corp.intel.com) ([10.124.223.207])
  by orviesa002-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Nov 2024 02:40:32 -0800
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
Subject: [PATCH v7 06/10] x86/virt/tdx: Switch to use auto-generated global metadata reading code
Date: Mon, 11 Nov 2024 23:39:42 +1300
Message-ID: <fa82c8fe2d19292a8536da06117b88cca6f34301.1731318868.git.kai.huang@intel.com>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <cover.1731318868.git.kai.huang@intel.com>
References: <cover.1731318868.git.kai.huang@intel.com>
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
Reviewed-by: Nikolay Borisov <nik.borisov@suse.com>
Reviewed-by: Dan Williams <dan.j.williams@intel.com>
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


