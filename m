Return-Path: <kvm+bounces-21753-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id CF1529335BC
	for <lists+kvm@lfdr.de>; Wed, 17 Jul 2024 05:42:48 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id D5A8C1C22A09
	for <lists+kvm@lfdr.de>; Wed, 17 Jul 2024 03:42:47 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C154E22612;
	Wed, 17 Jul 2024 03:41:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="UemADL5x"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5B0791B5A4;
	Wed, 17 Jul 2024 03:41:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.19
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721187665; cv=none; b=e0Ox9yiUtSOiF3u6jAXsrWu1sAOxmnp7+UomVNwSeWsm+Q1MZHNwP+/blwtmo4VYYKOdVR4xLG6kSTptXewMCsP/av2S/O+oYIG/qv4rAJ2Gq7lPGOrHrU6sJochW0fROC20qe4oRi5K4Bl5DOtZJs1ITnY9QPlolUa8I78CIOc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721187665; c=relaxed/simple;
	bh=i0wgO63rXikDOYBQPNzbg/gYjeP6zKdB0pk5XTYyPpE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dk7Zh/F33FMZ+VcVKvEU+s9b+IC8Y5Q5EHA4nTsrtlJqmguWA1J0iaqhVhekoZRKhH7rdz8xHohAc2G05aDBbw5RTxBA9isPBdDWXVSwo4NQLPjL09scveRoBobVtVf+ikNdZPZ/KbQOpIkytqWN18DbWzgBHxFwGwcb8kaqfKw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=UemADL5x; arc=none smtp.client-ip=198.175.65.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1721187663; x=1752723663;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=i0wgO63rXikDOYBQPNzbg/gYjeP6zKdB0pk5XTYyPpE=;
  b=UemADL5xc/MdGkTOSXqE8zIIpgtkB1PUz4mjo4szCnlWxkZnpLh3Adud
   JDBS9Uu+Qfhy4jp2/ZAofB+mnlviLokYvknuWAJq9040vgzfVMurHrDxB
   mmnz86WkxX16ssn1Q+UAcfeP5+zFFmZXGTVeZc/bEv/w4CIFkAtc3cqdO
   woapWi1X3AxH4ewiV4LJUqMZWDMP2B2xgxHKNM9v4d9c3nxSe1dBTNV65
   bmDiqyjyBTVIqVDo5XPE3lu97lWd6eex3MYYtYA3nWV0ROMbTWBqPU3X8
   8tgobP+fLnn341CJDTtxW80UQFOIbJ5CSypPqrn2oKWn6jhDHeadUffON
   g==;
X-CSE-ConnectionGUID: ipu4gMhdS+epQv0zDjat3g==
X-CSE-MsgGUID: ZppBlLxEQv++SkHeYVkEnQ==
X-IronPort-AV: E=McAfee;i="6700,10204,11135"; a="18512432"
X-IronPort-AV: E=Sophos;i="6.09,213,1716274800"; 
   d="scan'208";a="18512432"
Received: from fmviesa005.fm.intel.com ([10.60.135.145])
  by orvoesa111.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Jul 2024 20:41:00 -0700
X-CSE-ConnectionGUID: abeYhN4bRrWYDFgHOKjPmw==
X-CSE-MsgGUID: b5w72BBoR1CNNMmcl7u61Q==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.09,213,1716274800"; 
   d="scan'208";a="54566749"
Received: from rfrazer-mobl3.amr.corp.intel.com (HELO khuang2-desk.gar.corp.intel.com) ([10.124.222.184])
  by fmviesa005-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Jul 2024 20:40:57 -0700
From: Kai Huang <kai.huang@intel.com>
To: dave.hansen@intel.com,
	kirill.shutemov@linux.intel.com,
	bp@alien8.de,
	tglx@linutronix.de,
	peterz@infradead.org,
	mingo@redhat.com,
	hpa@zytor.com,
	seanjc@google.com,
	pbonzini@redhat.com,
	dan.j.williams@intel.com
Cc: x86@kernel.org,
	kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	rick.p.edgecombe@intel.com,
	isaku.yamahata@intel.com,
	chao.gao@intel.com,
	binbin.wu@linux.intel.com,
	kai.huang@intel.com
Subject: [PATCH v2 07/10] x86/virt/tdx: Start to track all global metadata in one structure
Date: Wed, 17 Jul 2024 15:40:14 +1200
Message-ID: <3d75e730cc514adfc9ac3200da5abd4d5e5d1bad.1721186590.git.kai.huang@intel.com>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <cover.1721186590.git.kai.huang@intel.com>
References: <cover.1721186590.git.kai.huang@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The TDX module provides a set of "global metadata fields".  They report
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

As the first step, introduce a new 'struct tdx_sysinfo' to track all
global metadata fields.

TDX categories global metadata fields into different "Class"es.  E.g.,
the current TDMR related fields are under class "TDMR Info".  Instead of
making 'struct tdx_sysinfo' a plain structure to contain all metadata
fields, organize them in smaller structures based on the "Class".

This allows those metadata fields to be used in finer granularity thus
makes the code more clear.  E.g., the current construct_tdmr() can just
take the structure which contains "TDMR Info" metadata fields.

Start with moving 'struct tdx_tdmr_sysinfo' to 'struct tdx_sysinfo', and
rename 'struct tdx_tdmr_sysinfo' to 'struct tdx_sysinfo_tdmr_info' to
make it consistent with the "class name".

Add a new function get_tdx_sysinfo() as the place to read all metadata
fields, and call it at the beginning of init_tdx_module().  Move the
existing get_tdx_tdmr_sysinfo() to get_tdx_sysinfo().

Note there is a functional change: get_tdx_tdmr_sysinfo() is moved from
after build_tdx_memlist() to before it, but it is fine to do so.

Signed-off-by: Kai Huang <kai.huang@intel.com>
---
 arch/x86/virt/vmx/tdx/tdx.c | 29 +++++++++++++++++------------
 arch/x86/virt/vmx/tdx/tdx.h | 32 +++++++++++++++++++++++++-------
 2 files changed, 42 insertions(+), 19 deletions(-)

diff --git a/arch/x86/virt/vmx/tdx/tdx.c b/arch/x86/virt/vmx/tdx/tdx.c
index 86c47db64e42..3253cdfa5207 100644
--- a/arch/x86/virt/vmx/tdx/tdx.c
+++ b/arch/x86/virt/vmx/tdx/tdx.c
@@ -320,11 +320,11 @@ static int stbuf_read_sysmd_multi(const struct field_mapping *fields,
 }
 
 #define TD_SYSINFO_MAP_TDMR_INFO(_field_id, _member)	\
-	TD_SYSINFO_MAP(_field_id, struct tdx_tdmr_sysinfo, _member)
+	TD_SYSINFO_MAP(_field_id, struct tdx_sysinfo_tdmr_info, _member)
 
-static int get_tdx_tdmr_sysinfo(struct tdx_tdmr_sysinfo *tdmr_sysinfo)
+static int get_tdx_tdmr_sysinfo(struct tdx_sysinfo_tdmr_info *tdmr_sysinfo)
 {
-	/* Map TD_SYSINFO fields into 'struct tdx_tdmr_sysinfo': */
+	/* Map TD_SYSINFO fields into 'struct tdx_sysinfo_tdmr_info': */
 	static const struct field_mapping fields[] = {
 		TD_SYSINFO_MAP_TDMR_INFO(MAX_TDMRS,		max_tdmrs),
 		TD_SYSINFO_MAP_TDMR_INFO(MAX_RESERVED_PER_TDMR, max_reserved_per_tdmr),
@@ -337,6 +337,11 @@ static int get_tdx_tdmr_sysinfo(struct tdx_tdmr_sysinfo *tdmr_sysinfo)
 	return stbuf_read_sysmd_multi(fields, ARRAY_SIZE(fields), tdmr_sysinfo);
 }
 
+static int get_tdx_sysinfo(struct tdx_sysinfo *sysinfo)
+{
+	return get_tdx_tdmr_sysinfo(&sysinfo->tdmr_info);
+}
+
 /* Calculate the actual TDMR size */
 static int tdmr_size_single(u16 max_reserved_per_tdmr)
 {
@@ -353,7 +358,7 @@ static int tdmr_size_single(u16 max_reserved_per_tdmr)
 }
 
 static int alloc_tdmr_list(struct tdmr_info_list *tdmr_list,
-			   struct tdx_tdmr_sysinfo *tdmr_sysinfo)
+			   struct tdx_sysinfo_tdmr_info *tdmr_sysinfo)
 {
 	size_t tdmr_sz, tdmr_array_sz;
 	void *tdmr_array;
@@ -936,7 +941,7 @@ static int tdmrs_populate_rsvd_areas_all(struct tdmr_info_list *tdmr_list,
  */
 static int construct_tdmrs(struct list_head *tmb_list,
 			   struct tdmr_info_list *tdmr_list,
-			   struct tdx_tdmr_sysinfo *tdmr_sysinfo)
+			   struct tdx_sysinfo_tdmr_info *tdmr_sysinfo)
 {
 	int ret;
 
@@ -1109,9 +1114,13 @@ static int init_tdmrs(struct tdmr_info_list *tdmr_list)
 
 static int init_tdx_module(void)
 {
-	struct tdx_tdmr_sysinfo tdmr_sysinfo;
+	struct tdx_sysinfo sysinfo;
 	int ret;
 
+	ret = get_tdx_sysinfo(&sysinfo);
+	if (ret)
+		return ret;
+
 	/*
 	 * To keep things simple, assume that all TDX-protected memory
 	 * will come from the page allocator.  Make sure all pages in the
@@ -1128,17 +1137,13 @@ static int init_tdx_module(void)
 	if (ret)
 		goto out_put_tdxmem;
 
-	ret = get_tdx_tdmr_sysinfo(&tdmr_sysinfo);
-	if (ret)
-		goto err_free_tdxmem;
-
 	/* Allocate enough space for constructing TDMRs */
-	ret = alloc_tdmr_list(&tdx_tdmr_list, &tdmr_sysinfo);
+	ret = alloc_tdmr_list(&tdx_tdmr_list, &sysinfo.tdmr_info);
 	if (ret)
 		goto err_free_tdxmem;
 
 	/* Cover all TDX-usable memory regions in TDMRs */
-	ret = construct_tdmrs(&tdx_memlist, &tdx_tdmr_list, &tdmr_sysinfo);
+	ret = construct_tdmrs(&tdx_memlist, &tdx_tdmr_list, &sysinfo.tdmr_info);
 	if (ret)
 		goto err_free_tdmrs;
 
diff --git a/arch/x86/virt/vmx/tdx/tdx.h b/arch/x86/virt/vmx/tdx/tdx.h
index 4e43cec19917..b5eb7c35f1dc 100644
--- a/arch/x86/virt/vmx/tdx/tdx.h
+++ b/arch/x86/virt/vmx/tdx/tdx.h
@@ -100,13 +100,6 @@ struct tdx_memblock {
 	int nid;
 };
 
-/* "TDMR info" part of "Global Scope Metadata" for constructing TDMRs */
-struct tdx_tdmr_sysinfo {
-	u16 max_tdmrs;
-	u16 max_reserved_per_tdmr;
-	u16 pamt_entry_size[TDX_PS_NR];
-};
-
 /* Warn if kernel has less than TDMR_NR_WARN TDMRs after allocation */
 #define TDMR_NR_WARN 4
 
@@ -119,4 +112,29 @@ struct tdmr_info_list {
 	int max_tdmrs;	/* How many 'tdmr_info's are allocated */
 };
 
+/*
+ * Kernel-defined structures to contain "Global Scope Metadata".
+ *
+ * TDX global metadata fields are categorized by "Class".  See the
+ * "global_metadata.json" in the "TDX 1.5 ABI Definitions".
+ *
+ * 'struct tdx_sysinfo' is the main structure to contain all metadata
+ * used by the kernel.  It contains sub-structures with each reflecting
+ * the "Class" in the 'global_metadata.json'.
+ *
+ * Note not all metadata fields in each class are defined, only those
+ * used by the kernel are.
+ */
+
+/* Class "TDMR Info" */
+struct tdx_sysinfo_tdmr_info {
+	u16 max_tdmrs;
+	u16 max_reserved_per_tdmr;
+	u16 pamt_entry_size[TDX_PS_NR];
+};
+
+struct tdx_sysinfo {
+	struct tdx_sysinfo_tdmr_info tdmr_info;
+};
+
 #endif
-- 
2.45.2


