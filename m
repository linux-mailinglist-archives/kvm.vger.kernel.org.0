Return-Path: <kvm+bounces-28751-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 38EA499C8FD
	for <lists+kvm@lfdr.de>; Mon, 14 Oct 2024 13:34:14 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 5CCAB1C22915
	for <lists+kvm@lfdr.de>; Mon, 14 Oct 2024 11:34:13 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EBE521A7271;
	Mon, 14 Oct 2024 11:32:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="g1VY8idI"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 805161A724B;
	Mon, 14 Oct 2024 11:32:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.12
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728905551; cv=none; b=fY23MmKPCXOn+0XLBB1EHnbocKl+07wylSL9ofOylTnrgtRXoS+y7jnCxJCXbVhKPbLejUbpSGfYEj6JGVPkitOkRl6HPJNQLVFaXtRL0STkY+5Bnfp/45hywxMylJj1Yp2JFNIrPg0Mo/6YbbxX2prL2eXT62LwDQFMKGuwg5s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728905551; c=relaxed/simple;
	bh=tmloiPHkSiYU29S44SW51h+fO8fsbKe9hH9Xlss47aU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Zxlv5GWuvfHQnaxzNYZ9qqRkPyrmHt2s6AYNPzfbjj9aZ+jQlx3CK4i8sTKidcqqU8P39XKGDr8EdQoE9f1Pj8ou/tqdNLBwr9wMRKjtuzf/+iV1xfSrPKQ7X2I6WchKO+sXRmDZR/vppECS6QUDWsV4z07q3qshQnCo7E7WhQQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=g1VY8idI; arc=none smtp.client-ip=192.198.163.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1728905549; x=1760441549;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=tmloiPHkSiYU29S44SW51h+fO8fsbKe9hH9Xlss47aU=;
  b=g1VY8idIIsVOBI6zlOaU9ys89qqn18pmbDv4QBn4hgkg7LcuAjukURL1
   sUlULZBTMzUHGkbi3pDarr4An4NroJjcZ/1LCk9hMbMydtMDWdvDwHT/z
   d9ekMtfU1SKK0EjwrWD2zYuO1/zvPNGhlUYaqm6mqn17zTgRPz4u2d9Ya
   Ok+842Ti5gAUXpv39/dXpm8xpPAaovkXvnz7kFuIdUHkkGKMu2h72Lq9S
   HJUHWaUMzhwSKpnZuLpzgEqcyTgRVkTkF8IK9umGQSVfdZTxmOEfwcEvx
   SuTSU64IL+WzrvgyGmaC1rcMRCNvNUajj4cLA4+CewM1V03D4X2OC5kkX
   w==;
X-CSE-ConnectionGUID: WZgvcMJaR4GkXiFAOsKBzg==
X-CSE-MsgGUID: gZ7a8ZneSS20ULs4VBGk1Q==
X-IronPort-AV: E=McAfee;i="6700,10204,11224"; a="32166518"
X-IronPort-AV: E=Sophos;i="6.11,202,1725346800"; 
   d="scan'208";a="32166518"
Received: from fmviesa005.fm.intel.com ([10.60.135.145])
  by fmvoesa106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Oct 2024 04:32:29 -0700
X-CSE-ConnectionGUID: uEsSURAKRsimCJboM+QThA==
X-CSE-MsgGUID: MUOpB2bQQDmIcE0VKavKAw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.11,202,1725346800"; 
   d="scan'208";a="82117483"
Received: from jdoman-desk1.amr.corp.intel.com (HELO khuang2-desk.gar.corp.intel.com) ([10.124.220.204])
  by fmviesa005-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Oct 2024 04:32:26 -0700
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
Subject: [PATCH v5 5/8] x86/virt/tdx: Start to track all global metadata in one structure
Date: Tue, 15 Oct 2024 00:31:52 +1300
Message-ID: <93dbca28787da38e60d972d122ca6900cd1caf32.1728903647.git.kai.huang@intel.com>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <cover.1728903647.git.kai.huang@intel.com>
References: <cover.1728903647.git.kai.huang@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The TDX module provides a set of "Global Metadata Fields".  They report
things like TDX module version, supported features, and fields related
to create/run TDX guests and so on.

Currently the kernel only reads "TD Memory Region" (TDMR) related fields
for module initialization.  There are immediate needs which require the
TDX module initialization to read more global metadata including module
version, supported features and "Convertible Memory Regions" (CMRs).

Also, KVM will need to read more metadata fields to support baseline TDX
guests.  In the longer term, other TDX features like TDX Connect (which
supports assigning trusted IO devices to TDX guest) may also require
other kernel components such as pci/vt-d to access global metadata.

To meet all those requirements, the idea is the TDX host core-kernel to
to provide a centralized, canonical, and read-only structure for the
global metadata that comes out from the TDX module for all kernel
components to use.

As the first step, introduce a new 'struct tdx_sys_info' to track all
global metadata fields.

TDX categories global metadata fields into different "Classes".  E.g.,
the TDMR related fields are under class "TDMR Info".  Instead of making
'struct tdx_sys_info' a plain structure to contain all metadata fields,
organize them in smaller structures based on the "Class".

This allows those metadata fields to be used in finer granularity thus
makes the code more clear.  E.g., the construct_tdmr() can just take the
structure which contains "TDMR Info" metadata fields.

Add a new function get_tdx_sys_info() as the placeholder to read all
metadata fields, and call it at the beginning of init_tdx_module().  For
now it only calls get_tdx_sys_info_tdmr() to read TDMR related fields.

Note there is a functional change: get_tdx_sys_info_tdmr() is moved from
after build_tdx_memlist() to before it, but it is fine to do so.

Signed-off-by: Kai Huang <kai.huang@intel.com>
Reviewed-by: Adrian Hunter <adrian.hunter@intel.com>
---

v4 -> v5:
 - Rebase due to patch 3 change.

v3 -> v4:
 - "global metadata fields" -> "Global Metadata Fields" - Ardian.
 - "Class"es -> "Classes" - Ardian.
 - Add tag from Ardian.

v2 -> v3:
 - Split out the part to rename 'struct tdx_tdmr_sysinfo' to 'struct
   tdx_sys_info_tdmr'.


---
 arch/x86/virt/vmx/tdx/tdx.c | 19 ++++++++++++-------
 arch/x86/virt/vmx/tdx/tdx.h | 36 +++++++++++++++++++++++++++++-------
 2 files changed, 41 insertions(+), 14 deletions(-)

diff --git a/arch/x86/virt/vmx/tdx/tdx.c b/arch/x86/virt/vmx/tdx/tdx.c
index d63efb2d50d1..a4496c4c765f 100644
--- a/arch/x86/virt/vmx/tdx/tdx.c
+++ b/arch/x86/virt/vmx/tdx/tdx.c
@@ -311,6 +311,11 @@ static int get_tdx_sys_info_tdmr(struct tdx_sys_info_tdmr *sysinfo_tdmr)
 	return ret;
 }
 
+static int get_tdx_sys_info(struct tdx_sys_info *sysinfo)
+{
+	return get_tdx_sys_info_tdmr(&sysinfo->tdmr);
+}
+
 /* Calculate the actual TDMR size */
 static int tdmr_size_single(u16 max_reserved_per_tdmr)
 {
@@ -1083,9 +1088,13 @@ static int init_tdmrs(struct tdmr_info_list *tdmr_list)
 
 static int init_tdx_module(void)
 {
-	struct tdx_sys_info_tdmr sysinfo_tdmr;
+	struct tdx_sys_info sysinfo;
 	int ret;
 
+	ret = get_tdx_sys_info(&sysinfo);
+	if (ret)
+		return ret;
+
 	/*
 	 * To keep things simple, assume that all TDX-protected memory
 	 * will come from the page allocator.  Make sure all pages in the
@@ -1102,17 +1111,13 @@ static int init_tdx_module(void)
 	if (ret)
 		goto out_put_tdxmem;
 
-	ret = get_tdx_sys_info_tdmr(&sysinfo_tdmr);
-	if (ret)
-		goto err_free_tdxmem;
-
 	/* Allocate enough space for constructing TDMRs */
-	ret = alloc_tdmr_list(&tdx_tdmr_list, &sysinfo_tdmr);
+	ret = alloc_tdmr_list(&tdx_tdmr_list, &sysinfo.tdmr);
 	if (ret)
 		goto err_free_tdxmem;
 
 	/* Cover all TDX-usable memory regions in TDMRs */
-	ret = construct_tdmrs(&tdx_memlist, &tdx_tdmr_list, &sysinfo_tdmr);
+	ret = construct_tdmrs(&tdx_memlist, &tdx_tdmr_list, &sysinfo.tdmr);
 	if (ret)
 		goto err_free_tdmrs;
 
diff --git a/arch/x86/virt/vmx/tdx/tdx.h b/arch/x86/virt/vmx/tdx/tdx.h
index 8345ae1f7fb1..4c924124347c 100644
--- a/arch/x86/virt/vmx/tdx/tdx.h
+++ b/arch/x86/virt/vmx/tdx/tdx.h
@@ -81,6 +81,35 @@ struct tdmr_info {
 	DECLARE_FLEX_ARRAY(struct tdmr_reserved_area, reserved_areas);
 } __packed __aligned(TDMR_INFO_ALIGNMENT);
 
+/*
+ * Data structures for "Global Scope Metadata".
+ *
+ * TDX global metadata fields are categorized by "Classes".  See the
+ * "global_metadata.json" in the "TDX 1.5 ABI Definitions".
+ *
+ * 'struct tdx_sys_info' is the main structure to contain all metadata
+ * used by the kernel.  It contains sub-structures with each reflecting
+ * the "Class" in the 'global_metadata.json'.
+ *
+ * Note the structure name may not exactly follow the name of the
+ * "Class" in the TDX spec, but the comment of that structure always
+ * reflect that.
+ *
+ * Also note not all metadata fields in each class are defined, only
+ * those used by the kernel are.
+ */
+
+/* Class "TDMR info" */
+struct tdx_sys_info_tdmr {
+	u16 max_tdmrs;
+	u16 max_reserved_per_tdmr;
+	u16 pamt_entry_size[TDX_PS_NR];
+};
+
+struct tdx_sys_info {
+	struct tdx_sys_info_tdmr tdmr;
+};
+
 /*
  * Do not put any hardware-defined TDX structure representations below
  * this comment!
@@ -100,13 +129,6 @@ struct tdx_memblock {
 	int nid;
 };
 
-/* "TDMR info" part of "Global Scope Metadata" for constructing TDMRs */
-struct tdx_sys_info_tdmr {
-	u16 max_tdmrs;
-	u16 max_reserved_per_tdmr;
-	u16 pamt_entry_size[TDX_PS_NR];
-};
-
 /* Warn if kernel has less than TDMR_NR_WARN TDMRs after allocation */
 #define TDMR_NR_WARN 4
 
-- 
2.46.2


