Return-Path: <kvm+bounces-29839-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id D5AB99B308F
	for <lists+kvm@lfdr.de>; Mon, 28 Oct 2024 13:42:17 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 94963281D24
	for <lists+kvm@lfdr.de>; Mon, 28 Oct 2024 12:42:16 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EBA301DA2E0;
	Mon, 28 Oct 2024 12:41:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="T6EGaXOp"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.13])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C8EDE1DA631;
	Mon, 28 Oct 2024 12:41:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.13
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730119297; cv=none; b=aUW/tevnJICd2WnEUj9Cmw1Trr+F/JYkNRiANukHIm+kJhO++9gaDvYwElwwjddtE2TNXKoi2E1tm9Wdn7NrNQ6AWpz4AO05iEoR/T1Z8Y2S/l1kr/qDhUoKVO+yyfbDeeOrAwfoG4VHMTn2aHyKz2eivwVFhSJVoBexH8WKnSo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730119297; c=relaxed/simple;
	bh=pYi7OIDoJ46CKm4Mw+eRhen0urbKuTZSrqUBZnHH8ag=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mc7qf2kuk3d/rBx5WNKW7Mc3l9OpuPkCnKWWusG0o8DAPRKRNWEKpR0IGEUKMnd5pCJ6Nbti+ewlL3Omj36ksLrOm1sl33pF37vkbvSOZhYyV6Q8SNiPCK36NrQJTAr4kWplK4QCSE6ekGrspY9jjD3HAbBBXTWxN//+2ZJ1/YQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=T6EGaXOp; arc=none smtp.client-ip=192.198.163.13
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1730119295; x=1761655295;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=pYi7OIDoJ46CKm4Mw+eRhen0urbKuTZSrqUBZnHH8ag=;
  b=T6EGaXOpnutmpkqgprrb+qBqAu66zhsrs1YED2EpzmNXwtfVR5E2tbEl
   firB+h+PJQJRiNowXEe+iQa6hg0L+23BMitipFBUtGKP4RBE04jgU4Efj
   ieJjZ/ua6VrAsyiqhCczFsfNWcvSCpN18Lj2jRmINFYCB6auXYNI+jJKk
   ntzU0MQRNuO1cr3t4Sf6DIQfdC2xREnPO1/1FB2H9r69kGFHyVPWKOTmL
   z/np6qI3v+Lr2Eku1Au03tyUinD9lrrNfvi0qKPz8fQ8oPkRfNQgSaaxV
   D5PUgmXQBMeRSjpAY7KLX5sLkj5oYuXbqcFBrO/5rfORGJT6wylIdQYqv
   g==;
X-CSE-ConnectionGUID: sxkkmFOmRcyMbW/PlKE51Q==
X-CSE-MsgGUID: nTkPq76eQ7iVYljPh/QMPg==
X-IronPort-AV: E=McAfee;i="6700,10204,11238"; a="32575238"
X-IronPort-AV: E=Sophos;i="6.11,239,1725346800"; 
   d="scan'208";a="32575238"
Received: from orviesa008.jf.intel.com ([10.64.159.148])
  by fmvoesa107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Oct 2024 05:41:34 -0700
X-CSE-ConnectionGUID: U9gC8a2BQVqpOUNGKlCqsA==
X-CSE-MsgGUID: IoAm5Sm1QT29zfypvjo2Lw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.11,239,1725346800"; 
   d="scan'208";a="82420884"
Received: from gargmani-mobl1.amr.corp.intel.com (HELO khuang2-desk.gar.corp.intel.com) ([10.124.222.169])
  by orviesa008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Oct 2024 05:41:30 -0700
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
Subject: [PATCH v6 02/10] x86/virt/tdx: Start to track all global metadata in one structure
Date: Tue, 29 Oct 2024 01:41:04 +1300
Message-ID: <b7981f18adadf6ff60751063790b2e084d453e87.1730118186.git.kai.huang@intel.com>
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
 arch/x86/virt/vmx/tdx/tdx.c | 19 ++++++++++++-------
 arch/x86/virt/vmx/tdx/tdx.h | 19 ++++++++++++-------
 2 files changed, 24 insertions(+), 14 deletions(-)

diff --git a/arch/x86/virt/vmx/tdx/tdx.c b/arch/x86/virt/vmx/tdx/tdx.c
index e979bf442929..7a2f979092e7 100644
--- a/arch/x86/virt/vmx/tdx/tdx.c
+++ b/arch/x86/virt/vmx/tdx/tdx.c
@@ -326,6 +326,11 @@ static int get_tdx_sys_info_tdmr(struct tdx_sys_info_tdmr *sysinfo_tdmr)
 	return 0;
 }
 
+static int get_tdx_sys_info(struct tdx_sys_info *sysinfo)
+{
+	return get_tdx_sys_info_tdmr(&sysinfo->tdmr);
+}
+
 /* Calculate the actual TDMR size */
 static int tdmr_size_single(u16 max_reserved_per_tdmr)
 {
@@ -1098,9 +1103,13 @@ static int init_tdmrs(struct tdmr_info_list *tdmr_list)
 
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
@@ -1117,17 +1126,13 @@ static int init_tdx_module(void)
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
index 148f9b4d1140..2600ec3752f5 100644
--- a/arch/x86/virt/vmx/tdx/tdx.h
+++ b/arch/x86/virt/vmx/tdx/tdx.h
@@ -80,6 +80,18 @@ struct tdmr_info {
 	DECLARE_FLEX_ARRAY(struct tdmr_reserved_area, reserved_areas);
 } __packed __aligned(TDMR_INFO_ALIGNMENT);
 
+/* Class "TDMR info" */
+struct tdx_sys_info_tdmr {
+	u16 max_tdmrs;
+	u16 max_reserved_per_tdmr;
+	u16 pamt_entry_size[TDX_PS_NR];
+};
+
+/* Kernel used global metadata fields */
+struct tdx_sys_info {
+	struct tdx_sys_info_tdmr tdmr;
+};
+
 /*
  * Do not put any hardware-defined TDX structure representations below
  * this comment!
@@ -99,13 +111,6 @@ struct tdx_memblock {
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


