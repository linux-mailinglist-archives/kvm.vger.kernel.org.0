Return-Path: <kvm+bounces-25126-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 0134A9602CD
	for <lists+kvm@lfdr.de>; Tue, 27 Aug 2024 09:16:47 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 72DC41F2333B
	for <lists+kvm@lfdr.de>; Tue, 27 Aug 2024 07:16:46 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id ED595156C52;
	Tue, 27 Aug 2024 07:15:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="P+QKvUjd"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 84D02198837;
	Tue, 27 Aug 2024 07:15:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.12
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724742908; cv=none; b=aZiLHAQK1mA3PchHUyB5RvqS80OTa2EiEGXjEGyNXnr332rEZU3FePIuBjpmeIwjGRdVGWB9XMmOVw5RIiFRcb4qxqbMlok82cYzvTkdPTwh/Kq7D2HroCuQUs5FwNiW8HUuvHk8UOEDL2r8ECSMpWOEBJ56e6EQdBMEC6AhPKM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724742908; c=relaxed/simple;
	bh=8j1JpumKRiAlfRGl7WTqXqAxcV9FvwH+JqcwOXUhQgQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=i3W3mYy8YTu4X1trpw1HYVwLvwQhktIpPCm6RASTi0dKMoWBmipMoGfkULW64FotUoT74e84Cyq9NxqKje3MmWHkjNqXFhwaF8idCdG54p5uhLnfjoHIKZdRtvwXbFLntLTZjrKbAr1BFT0DVKATzKmFVxgZ1uGGKUuRaXqN8ys=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=P+QKvUjd; arc=none smtp.client-ip=198.175.65.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1724742907; x=1756278907;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=8j1JpumKRiAlfRGl7WTqXqAxcV9FvwH+JqcwOXUhQgQ=;
  b=P+QKvUjdD31UPWpqtHSRsAqWFc5K8w4qIbSyITZj4O+LOrnsF2S0ujAi
   vmpBN1NvfVW9XooK6KTA47E6WCP6rPstkoakNVu4t2s72A26/CG5UmVas
   DJ0i34shfQwUDvjf9lGdMWFnd1JI1554OgdVYy3X0ByfukWBgT/tkG67O
   rnQrpdLIrMWUs1/2ZE26BNa52rx39Z+njb6iSw+ZvS+jRI92KyTGxYh/4
   czvsDYS/fdnZNCRDDCNBGiL8sKioxm/dH7bIH+Fiq0Wn9WHBfPpiexCpC
   xWrWgHP6V5r9sPR9b03CrTnOfKU/pgmNMJewV7RanMmpKrD879D+yi8XG
   g==;
X-CSE-ConnectionGUID: N0JnyMAwQ9Kw8Z5uACnCxg==
X-CSE-MsgGUID: tiytNBLWRX6U/c1upZXN8Q==
X-IronPort-AV: E=McAfee;i="6700,10204,11176"; a="34575873"
X-IronPort-AV: E=Sophos;i="6.10,179,1719903600"; 
   d="scan'208";a="34575873"
Received: from orviesa006.jf.intel.com ([10.64.159.146])
  by orvoesa104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Aug 2024 00:15:06 -0700
X-CSE-ConnectionGUID: AARzS7DFTjmSzPoaQ6FjEQ==
X-CSE-MsgGUID: VHdMYHH4SXOAUV9etSA7QQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.10,179,1719903600"; 
   d="scan'208";a="63092583"
Received: from apaszkie-mobl2.apaszkie-mobl2 (HELO khuang2-desk.gar.corp.intel.com) ([10.124.223.81])
  by orviesa006-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Aug 2024 00:15:02 -0700
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
	chao.gao@intel.com,
	binbin.wu@linux.intel.com,
	adrian.hunter@intel.com,
	kai.huang@intel.com
Subject: [PATCH v3 5/8] x86/virt/tdx: Start to track all global metadata in one structure
Date: Tue, 27 Aug 2024 19:14:27 +1200
Message-ID: <994a0df50534c404d1b243a95067860fc296172a.1724741926.git.kai.huang@intel.com>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <cover.1724741926.git.kai.huang@intel.com>
References: <cover.1724741926.git.kai.huang@intel.com>
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

As the first step, introduce a new 'struct tdx_sys_info' to track all
global metadata fields.

TDX categories global metadata fields into different "Class"es.  E.g.,
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
---

v2 -> v3:
 - Split out the part to rename 'struct tdx_tdmr_sysinfo' to 'struct
   tdx_sys_info_tdmr'.


---
 arch/x86/virt/vmx/tdx/tdx.c | 19 ++++++++++++-------
 arch/x86/virt/vmx/tdx/tdx.h | 36 +++++++++++++++++++++++++++++-------
 2 files changed, 41 insertions(+), 14 deletions(-)

diff --git a/arch/x86/virt/vmx/tdx/tdx.c b/arch/x86/virt/vmx/tdx/tdx.c
index 1cd9035c783f..24eb289c80e8 100644
--- a/arch/x86/virt/vmx/tdx/tdx.c
+++ b/arch/x86/virt/vmx/tdx/tdx.c
@@ -318,6 +318,11 @@ static int get_tdx_sys_info_tdmr(struct tdx_sys_info_tdmr *sysinfo_tdmr)
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
@@ -1090,9 +1095,13 @@ static int init_tdmrs(struct tdmr_info_list *tdmr_list)
 
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
@@ -1109,17 +1118,13 @@ static int init_tdx_module(void)
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
index 8aabd03d8bf5..4cddbb035b9f 100644
--- a/arch/x86/virt/vmx/tdx/tdx.h
+++ b/arch/x86/virt/vmx/tdx/tdx.h
@@ -100,13 +100,6 @@ struct tdx_memblock {
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
 
@@ -119,4 +112,33 @@ struct tdmr_info_list {
 	int max_tdmrs;	/* How many 'tdmr_info's are allocated */
 };
 
+/*
+ * Kernel-defined structures to contain "Global Scope Metadata".
+ *
+ * TDX global metadata fields are categorized by "Class"es.  See the
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
 #endif
-- 
2.46.0


