Return-Path: <kvm+bounces-31441-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id ED6089C3C39
	for <lists+kvm@lfdr.de>; Mon, 11 Nov 2024 11:42:47 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id A48842811A4
	for <lists+kvm@lfdr.de>; Mon, 11 Nov 2024 10:42:46 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F2FC019C566;
	Mon, 11 Nov 2024 10:40:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Ut4zkQFn"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8F38517C7BD;
	Mon, 11 Nov 2024 10:40:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731321624; cv=none; b=YXbeS9q9SvYVrjc1exft8c4JTgWN5vCFQEEuAfCZ9cvWHsTlcHfLYOxj4PI+09K5D7XZpN/4iGk2o0J14t0t17iBN4mXA+buIATfWxpet23QAaHTOkXOn3YBLPj6zLMdJCwH6AbVi5SYT3KDx+QSkFZOBHZq65azMeT/yYVtqyQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731321624; c=relaxed/simple;
	bh=2IDZXwCDtWKg5ndNfy9hroXbFgjIWFer4PMCB8Dobdc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NyaJuYgVulEtrr63qYUNaGHnWDTHGfE4AJ5nOsciwSyRS5w/9qThkhFbLDnp64i8My+DiTWb1S/+4qOnoKNwYMBBySCD41l2p5GonXlbp7IHC2gEZM+Nr8HYAeLO89ysqyA5247cLO/aF0L8vDD+dzYzcwvhAnO7HL2XIEIE3PM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=Ut4zkQFn; arc=none smtp.client-ip=198.175.65.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1731321623; x=1762857623;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=2IDZXwCDtWKg5ndNfy9hroXbFgjIWFer4PMCB8Dobdc=;
  b=Ut4zkQFnejY6qgtYf+RmOhwUYua2pjxcKNzQoH3fSg7YXLN3whN4p09i
   rOHoVFGJt56ViqBmOweyEMWkm66CYRIdwnsCW5NFCwfsGcGAzX8a61ZT8
   GytGf6Iqc2Z2aKSDWzyRco5iq3UJXfFCcfHyjZm32N8RFNQNH9tw0EP0O
   sFbJINzWbT6b/j5Em7bCM5RQwejOboqIZpSC8gfvnXi/IhQSk+C6YkkIl
   gtkr++YLDKJm0XXsbBHWq1KQ34UtOJtuaHMLJ6kHdrsS+hR94Hxf6f5bw
   bpsoUytBKEqfYaRsZLqIb71N9Fgq1XGzMXiKRjXygdBvwJv/G3/EbYmIW
   A==;
X-CSE-ConnectionGUID: rdd3chZrRfW1kDBVVq2plw==
X-CSE-MsgGUID: I2d4KB/yS3+N8P+a8qL7rw==
X-IronPort-AV: E=McAfee;i="6700,10204,11222"; a="41682632"
X-IronPort-AV: E=Sophos;i="6.11,199,1725346800"; 
   d="scan'208";a="41682632"
Received: from orviesa002.jf.intel.com ([10.64.159.142])
  by orvoesa103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Nov 2024 02:40:22 -0800
X-CSE-ConnectionGUID: bh4npz3DRO+q3OcX/739Wg==
X-CSE-MsgGUID: at8Gm3j+RM6IAFomt8x9xw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.12,144,1728975600"; 
   d="scan'208";a="117667107"
Received: from uaeoff-desk2.amr.corp.intel.com (HELO khuang2-desk.gar.corp.intel.com) ([10.124.223.207])
  by orviesa002-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Nov 2024 02:40:16 -0800
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
Subject: [PATCH v7 02/10] x86/virt/tdx: Start to track all global metadata in one structure
Date: Mon, 11 Nov 2024 23:39:38 +1300
Message-ID: <0fd3b59a754f7f21d790ab2e9781badec293c0ff.1731318868.git.kai.huang@intel.com>
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
Reviewed-by: Dan Williams <dan.j.williams@intel.com>
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


