Return-Path: <kvm+bounces-19743-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id B5B8C909D38
	for <lists+kvm@lfdr.de>; Sun, 16 Jun 2024 14:03:57 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 3693C1F213FB
	for <lists+kvm@lfdr.de>; Sun, 16 Jun 2024 12:03:57 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 74E4B18FDA4;
	Sun, 16 Jun 2024 12:02:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="nAOwGN3P"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0CF1F18FC93;
	Sun, 16 Jun 2024 12:02:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.12
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718539326; cv=none; b=Nidj03adjZTPYS0dlW9KMumLTQQPVrv7LEEZw9/2qs0Ru/TxpCOu8pIZL0QMY+BK10fRi9+7k2Sl6MpOZ4KC3+QtuYowPar3scz8h35yWHt31tH6MTl2MCu/l3KiCBZrW/iS3gO3x//iyxuv7BXNxWhT13L4cIzX9dSLe/m7NAs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718539326; c=relaxed/simple;
	bh=DBhTRbapgojfCSzdbMaFFi64591mOutWYsEqjKoRI9w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dV22udbGpINa46XgjPip3i94+IC5S64iZ1onV0vrapydMiDgtARksK4PUKLB80+NqMfohn6oTyE4R+yHSPVs34NWNIoS4p/L5U14DxHJZLks3nZUEHylxagi63du7KwGkzHFkvY8wFQRulKCS4HJZNuTj2m2Lm5dD02/EarCnx4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=nAOwGN3P; arc=none smtp.client-ip=198.175.65.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1718539325; x=1750075325;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=DBhTRbapgojfCSzdbMaFFi64591mOutWYsEqjKoRI9w=;
  b=nAOwGN3P19jz6dZgSNsAysB4vN0eqPN/NlveNVd1yKK5mmpU7s2IyRd+
   Te4KgarEPiYH0Bllt02Ol1bfi7l81xVfGOQaZvvhvvReeirt+82aenhqz
   RQEaQ0DhOpeW4JoeqWBVUTXwNxw81x3oWqd1+g5apA8EUu1GYF3wfwMNr
   3HihhF4R5NJVAAJajoSDvSUmVcTHN6BPOA7OXT0iu1dJWB1iWmPH84uv2
   SoDUU3NmXNl8Gn9V9MTWonwBHFCWJgqqst7ZE/1aGnutaIZRx8Z14EdM6
   Hk6RVLspwUbZvqxzqMXBpA58/5MFq5+seWgL8AZPkOD1dqu5T1BuhdfZW
   w==;
X-CSE-ConnectionGUID: KG6KA87yTt2pFlWYWORvUw==
X-CSE-MsgGUID: iIZWoODyQzGH8Eb25tS3hQ==
X-IronPort-AV: E=McAfee;i="6700,10204,11104"; a="26800035"
X-IronPort-AV: E=Sophos;i="6.08,242,1712646000"; 
   d="scan'208";a="26800035"
Received: from orviesa004.jf.intel.com ([10.64.159.144])
  by orvoesa104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Jun 2024 05:02:05 -0700
X-CSE-ConnectionGUID: tT3MKe9HSTqZNzCqT9CX4Q==
X-CSE-MsgGUID: atuuzNGMQQio/V51WeGHMw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.08,242,1712646000"; 
   d="scan'208";a="46055885"
Received: from mgoodin-mobl2.amr.corp.intel.com (HELO khuang2-desk.gar.corp.intel.com) ([10.124.223.226])
  by orviesa004-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Jun 2024 05:02:01 -0700
From: Kai Huang <kai.huang@intel.com>
To: linux-kernel@vger.kernel.org
Cc: x86@kernel.org,
	dave.hansen@intel.com,
	dan.j.williams@intel.com,
	kirill.shutemov@linux.intel.com,
	rick.p.edgecombe@intel.com,
	peterz@infradead.org,
	tglx@linutronix.de,
	bp@alien8.de,
	mingo@redhat.com,
	hpa@zytor.com,
	seanjc@google.com,
	pbonzini@redhat.com,
	kvm@vger.kernel.org,
	isaku.yamahata@intel.com,
	binbin.wu@linux.intel.com,
	kai.huang@intel.com
Subject: [PATCH 6/9] x86/virt/tdx: Start to track all global metadata in one structure
Date: Mon, 17 Jun 2024 00:01:16 +1200
Message-ID: <9759a946d7861821bf45c6bc73c9f596235087bc.1718538552.git.kai.huang@intel.com>
X-Mailer: git-send-email 2.43.2
In-Reply-To: <cover.1718538552.git.kai.huang@intel.com>
References: <cover.1718538552.git.kai.huang@intel.com>
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
index fad42014ca37..4683884efcc6 100644
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
index 812943516946..6b61dc67b0af 100644
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
+ * 'global_metadata.json' in the "TDX 1.5 ABI Definitions".
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
2.43.2


