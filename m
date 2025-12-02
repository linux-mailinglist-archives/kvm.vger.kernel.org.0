Return-Path: <kvm+bounces-65066-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ams.mirrors.kernel.org (ams.mirrors.kernel.org [213.196.21.55])
	by mail.lfdr.de (Postfix) with ESMTPS id 6671CC9A134
	for <lists+kvm@lfdr.de>; Tue, 02 Dec 2025 06:25:13 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ams.mirrors.kernel.org (Postfix) with ESMTPS id ADA3E346738
	for <lists+kvm@lfdr.de>; Tue,  2 Dec 2025 05:25:01 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6F6BE2F8BCB;
	Tue,  2 Dec 2025 05:24:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="CJfFBpgF"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 606E52F60B3;
	Tue,  2 Dec 2025 05:24:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764653065; cv=none; b=an9fnFxTrnqqlr4rx/mS1MF/1xEbMb2nntYHuee08ASS7UxxYYBHEUfXGIN6p/Ur3czNXUd7fMpYZz8bhwFYUQOTC02zLbUW0BOL80Ys8ZuhLKvth6kufZUVrEtkbnMZNhhjtcWwic/v9RBlqKyBJR0WY6MvjnExF5Y0wx9Pueo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764653065; c=relaxed/simple;
	bh=h53ncUol0tv0NPlX/HBkG5nr7VwVBGm5wiQ32WEK1gc=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=dQ4A34IpsNJKHZ39S6eM03O3SH7DFQAa+X7OAPvmaslBdm6fSvCjdi7338ka0Hgbh0Bd/fdLjVASsMwqyHPOtoicXEbQvI8j0bLBOyd7QO6JbASsSKoUNI2rd07eUttKE/ahkNulTN8jrEp0VAArbd9iTtoskAerFSZzs5XHCsk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=pass smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=CJfFBpgF; arc=none smtp.client-ip=198.175.65.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1764653063; x=1796189063;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=h53ncUol0tv0NPlX/HBkG5nr7VwVBGm5wiQ32WEK1gc=;
  b=CJfFBpgFTOxKG9XEef/i/JfhQ99M3UGeoGmNmNRsz2pIpYI8zUJDk12p
   uyNFhZ7+uqVafVdIs+qDgObyAdPjfbuTE2aKbybbiobmcyfI/ztEOGAkU
   BtgTdUaSLfaG2nG5L+TPifsk0kBuF2AFKJiLZAEqB+hdlaKZ0np3vuf9K
   yw+++Bgqjqn3SkqEQ1hbWeTzuJvmIMtFsgmQqEc1WHeex3WFjQdy0VVCY
   GgYFHydnWr1ncUkibc0TjLSRwftHWf73kgFhR5OaIBX5fr3tgNo0hWA8E
   pH0IxTiczRKrsD8qP24KGYVADm0k9nRouq0agDVs5ohM4XLHZXcwl1/Oa
   A==;
X-CSE-ConnectionGUID: /R5A9lsQRJiHb6CSoSX+SQ==
X-CSE-MsgGUID: LA51VMAdSlCKxU1oTQAKKg==
X-IronPort-AV: E=McAfee;i="6800,10657,11630"; a="76929820"
X-IronPort-AV: E=Sophos;i="6.20,242,1758610800"; 
   d="scan'208";a="76929820"
Received: from orviesa005.jf.intel.com ([10.64.159.145])
  by orvoesa103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Dec 2025 21:24:19 -0800
X-CSE-ConnectionGUID: Wyx3EsBRT4a+naEi+TPAvg==
X-CSE-MsgGUID: DWmqWiK8RvGcXMcpxyk1qg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.20,242,1758610800"; 
   d="scan'208";a="199399241"
Received: from yilunxu-optiplex-7050.sh.intel.com ([10.239.159.165])
  by orviesa005.jf.intel.com with ESMTP; 01 Dec 2025 21:24:16 -0800
From: Xu Yilun <yilun.xu@linux.intel.com>
To: x86@kernel.org,
	dave.hansen@linux.intel.com,
	kas@kernel.org,
	linux-kernel@vger.kernel.org
Cc: chao.gao@intel.com,
	rick.p.edgecombe@intel.com,
	dan.j.williams@intel.com,
	baolu.lu@linux.intel.com,
	yilun.xu@linux.intel.com,
	yilun.xu@intel.com,
	zhenzhong.duan@intel.com,
	kvm@vger.kernel.org,
	adrian.hunter@intel.com
Subject: [PATCH 2/6] x86/virt/tdx: Move read_sys_metadata_field() to where it is called
Date: Tue,  2 Dec 2025 13:08:40 +0800
Message-Id: <20251202050844.2520762-3-yilun.xu@linux.intel.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20251202050844.2520762-1-yilun.xu@linux.intel.com>
References: <20251202050844.2520762-1-yilun.xu@linux.intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Moving read_sys_metadata_field() to tdx_global_metadata.c marks the end
of auto-generating global metadata parsing code. The source of the
auto-generation, the JSON file, is not stable and not authoritative
enough. Switch back to manual editing and improve code readability.

The only possible usage of read_sys_metadata_field() is to cache all
global metadata in system memory on TDX Module initialization. Moving it
alongside other metadata reading code improves readability.

Take the opportunity to remove any description for auto-generation.

Signed-off-by: Xu Yilun <yilun.xu@linux.intel.com>
---
 arch/x86/include/asm/tdx_global_metadata.h  |  6 +++---
 arch/x86/virt/vmx/tdx/tdx.c                 | 20 -------------------
 arch/x86/virt/vmx/tdx/tdx_global_metadata.c | 22 ++++++++++++++++++++-
 3 files changed, 24 insertions(+), 24 deletions(-)

diff --git a/arch/x86/include/asm/tdx_global_metadata.h b/arch/x86/include/asm/tdx_global_metadata.h
index 060a2ad744bf..b44f1df013b2 100644
--- a/arch/x86/include/asm/tdx_global_metadata.h
+++ b/arch/x86/include/asm/tdx_global_metadata.h
@@ -1,7 +1,7 @@
 /* SPDX-License-Identifier: GPL-2.0 */
-/* Automatically generated TDX global metadata structures. */
-#ifndef _X86_VIRT_TDX_AUTO_GENERATED_TDX_GLOBAL_METADATA_H
-#define _X86_VIRT_TDX_AUTO_GENERATED_TDX_GLOBAL_METADATA_H
+/* TDX global metadata structures. */
+#ifndef _X86_VIRT_TDX_GLOBAL_METADATA_H
+#define _X86_VIRT_TDX_GLOBAL_METADATA_H
 
 #include <linux/types.h>
 
diff --git a/arch/x86/virt/vmx/tdx/tdx.c b/arch/x86/virt/vmx/tdx/tdx.c
index eac403248462..0d7f9bdac8a4 100644
--- a/arch/x86/virt/vmx/tdx/tdx.c
+++ b/arch/x86/virt/vmx/tdx/tdx.c
@@ -257,26 +257,6 @@ static int build_tdx_memlist(struct list_head *tmb_list)
 	return ret;
 }
 
-static int read_sys_metadata_field(u64 field_id, u64 *data)
-{
-	struct tdx_module_args args = {};
-	int ret;
-
-	/*
-	 * TDH.SYS.RD -- reads one global metadata field
-	 *  - RDX (in): the field to read
-	 *  - R8 (out): the field data
-	 */
-	args.rdx = field_id;
-	ret = seamcall_prerr_ret(TDH_SYS_RD, &args);
-	if (ret)
-		return ret;
-
-	*data = args.r8;
-
-	return 0;
-}
-
 #include "tdx_global_metadata.c"
 
 static int check_features(struct tdx_sys_info *sysinfo)
diff --git a/arch/x86/virt/vmx/tdx/tdx_global_metadata.c b/arch/x86/virt/vmx/tdx/tdx_global_metadata.c
index 13ad2663488b..0dfb3a9995fe 100644
--- a/arch/x86/virt/vmx/tdx/tdx_global_metadata.c
+++ b/arch/x86/virt/vmx/tdx/tdx_global_metadata.c
@@ -1,12 +1,32 @@
 // SPDX-License-Identifier: GPL-2.0
 /*
- * Automatically generated functions to read TDX global metadata.
+ * Functions to read TDX global metadata.
  *
  * This file doesn't compile on its own as it lacks of inclusion
  * of SEAMCALL wrapper primitive which reads global metadata.
  * Include this file to other C file instead.
  */
 
+static int read_sys_metadata_field(u64 field_id, u64 *data)
+{
+	struct tdx_module_args args = {};
+	int ret;
+
+	/*
+	 * TDH.SYS.RD -- reads one global metadata field
+	 *  - RDX (in): the field to read
+	 *  - R8 (out): the field data
+	 */
+	args.rdx = field_id;
+	ret = seamcall_prerr_ret(TDH_SYS_RD, &args);
+	if (ret)
+		return ret;
+
+	*data = args.r8;
+
+	return 0;
+}
+
 static int get_tdx_sys_info_features(struct tdx_sys_info_features *sysinfo_features)
 {
 	int ret = 0;
-- 
2.25.1


