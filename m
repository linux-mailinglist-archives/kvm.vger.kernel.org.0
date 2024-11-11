Return-Path: <kvm+bounces-31440-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 26AD19C3C37
	for <lists+kvm@lfdr.de>; Mon, 11 Nov 2024 11:42:27 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id A67861F210C4
	for <lists+kvm@lfdr.de>; Mon, 11 Nov 2024 10:42:26 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D09F419005D;
	Mon, 11 Nov 2024 10:40:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Gna16277"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 55E3B18B46A;
	Mon, 11 Nov 2024 10:40:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731321618; cv=none; b=MBct1bDxEOhhZygyjau6zVU5N1xC1iX8YnxntQlP9CkQYhVSgb9S0uU5bqPFIEo3t3arJBDcLGBDPnY0w34Gk54vA1XKcCTazEv2ZGueoOGv56AYZGh5pvfsEm3AakOTNwHvewt8BaWNNS+wDqooY2SbWeG/KnALsKmMqrcDoYM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731321618; c=relaxed/simple;
	bh=iJrknpuZDTQn1my2KbzFpSYQx081vYUCNcNifeNVA2E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WbstDdJNrsYdArelxDGItFv+2W1fiJ30ZUAFBc2CSQ+G/bV5uRsq65bjEH5bOn+6S2WD3sZ72rb6na8PR5h8clMf7lKZ5MX3348U+yfyoPOn6FzKc//yvI1ttnstMKAxII/xTtoGv+ekhNgcV1YQ6sezcxcTWkdDwvNsblMGylE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=Gna16277; arc=none smtp.client-ip=198.175.65.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1731321617; x=1762857617;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=iJrknpuZDTQn1my2KbzFpSYQx081vYUCNcNifeNVA2E=;
  b=Gna16277GnTm5xzw4EiT9hPljsTYlk3ivkiRmE/Cip6tigwNBLRpZLz1
   w9w3m6K13hqpIHZg09JUnef/kFOS/AztP6Jy7GtL3dD95XbRjy45idk/D
   wxJnKWNWMHZku8oVzB1A0YsjMuv96m+ROId2DkPipgGuCG6YjHPO1tSxM
   H6NjMdIAh2RIixoaEn72nfExfyvysx8SPwQAfT4OvHDzS08No4ZYpJ4ZB
   3T2dHzSkjZcrLLhDZoGP8R0gq75iueUrbXlTl0IVKEWLfBEtRo2DSFWq8
   z/S9qlhCayaw7KAkVtvTsRzpXDqFz+6A2btFUS7cdsJOZ9dZ4JuBsFLGu
   w==;
X-CSE-ConnectionGUID: meyLUSsbT12FjaLPlE3qqg==
X-CSE-MsgGUID: 0vaCs/T9S6OJhju+rCl1cA==
X-IronPort-AV: E=McAfee;i="6700,10204,11222"; a="41682599"
X-IronPort-AV: E=Sophos;i="6.11,199,1725346800"; 
   d="scan'208";a="41682599"
Received: from orviesa002.jf.intel.com ([10.64.159.142])
  by orvoesa103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Nov 2024 02:40:17 -0800
X-CSE-ConnectionGUID: +WyXE9gqQCSkc1MK+lKBug==
X-CSE-MsgGUID: QZTZEme4TkWYfpeZO318iA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.12,144,1728975600"; 
   d="scan'208";a="117667090"
Received: from uaeoff-desk2.amr.corp.intel.com (HELO khuang2-desk.gar.corp.intel.com) ([10.124.223.207])
  by orviesa002-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Nov 2024 02:40:12 -0800
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
Subject: [PATCH v7 01/10] x86/virt/tdx: Rename 'struct tdx_tdmr_sysinfo' to reflect the spec better
Date: Mon, 11 Nov 2024 23:39:37 +1300
Message-ID: <7d0dea29bc6abff051c45048d26547acb6f2a62b.1731318868.git.kai.huang@intel.com>
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

TDX organizes those metadata fields by "Classes" based on the meaning of
those fields.  E.g., for now the kernel only reads "TD Memory Region"
(TDMR) related fields for module initialization.  Those fields are
defined under class "TDMR Info".

There are both immediate needs to read more metadata fields for module
initialization and near-future needs for other kernel components like
KVM to run TDX guests.  To meet all those requirements, the idea is the
TDX host core-kernel to provide a centralized, canonical, and read-only
structure for the global metadata that comes out from the TDX module for
all kernel components to use.

More specifically, the target is to end up with something like:

       struct tdx_sys_info {
	       struct tdx_sys_info_classA a;
	       struct tdx_sys_info_classB b;
	       ...
       };

Currently the kernel organizes all fields under "TDMR Info" class in
'struct tdx_tdmr_sysinfo'.  To prepare for the above target, rename the
structure to 'struct tdx_sys_info_tdmr' to follow the class name better.

No functional change intended.

Signed-off-by: Kai Huang <kai.huang@intel.com>
Reviewed-by: Adrian Hunter <adrian.hunter@intel.com>
Reviewed-by: Dan Williams <dan.j.williams@intel.com>
---
 arch/x86/virt/vmx/tdx/tdx.c | 36 ++++++++++++++++++------------------
 arch/x86/virt/vmx/tdx/tdx.h |  2 +-
 2 files changed, 19 insertions(+), 19 deletions(-)

diff --git a/arch/x86/virt/vmx/tdx/tdx.c b/arch/x86/virt/vmx/tdx/tdx.c
index 4e2b2e2ac9f9..e979bf442929 100644
--- a/arch/x86/virt/vmx/tdx/tdx.c
+++ b/arch/x86/virt/vmx/tdx/tdx.c
@@ -272,7 +272,7 @@ static int read_sys_metadata_field(u64 field_id, u64 *data)
 
 static int read_sys_metadata_field16(u64 field_id,
 				     int offset,
-				     struct tdx_tdmr_sysinfo *ts)
+				     struct tdx_sys_info_tdmr *ts)
 {
 	u16 *ts_member = ((void *)ts) + offset;
 	u64 tmp;
@@ -298,9 +298,9 @@ struct field_mapping {
 
 #define TD_SYSINFO_MAP(_field_id, _offset) \
 	{ .field_id = MD_FIELD_ID_##_field_id,	   \
-	  .offset   = offsetof(struct tdx_tdmr_sysinfo, _offset) }
+	  .offset   = offsetof(struct tdx_sys_info_tdmr, _offset) }
 
-/* Map TD_SYSINFO fields into 'struct tdx_tdmr_sysinfo': */
+/* Map TD_SYSINFO fields into 'struct tdx_sys_info_tdmr': */
 static const struct field_mapping fields[] = {
 	TD_SYSINFO_MAP(MAX_TDMRS,	      max_tdmrs),
 	TD_SYSINFO_MAP(MAX_RESERVED_PER_TDMR, max_reserved_per_tdmr),
@@ -309,16 +309,16 @@ static const struct field_mapping fields[] = {
 	TD_SYSINFO_MAP(PAMT_1G_ENTRY_SIZE,    pamt_entry_size[TDX_PS_1G]),
 };
 
-static int get_tdx_tdmr_sysinfo(struct tdx_tdmr_sysinfo *tdmr_sysinfo)
+static int get_tdx_sys_info_tdmr(struct tdx_sys_info_tdmr *sysinfo_tdmr)
 {
 	int ret;
 	int i;
 
-	/* Populate 'tdmr_sysinfo' fields using the mapping structure above: */
+	/* Populate 'sysinfo_tdmr' fields using the mapping structure above: */
 	for (i = 0; i < ARRAY_SIZE(fields); i++) {
 		ret = read_sys_metadata_field16(fields[i].field_id,
 						fields[i].offset,
-						tdmr_sysinfo);
+						sysinfo_tdmr);
 		if (ret)
 			return ret;
 	}
@@ -342,13 +342,13 @@ static int tdmr_size_single(u16 max_reserved_per_tdmr)
 }
 
 static int alloc_tdmr_list(struct tdmr_info_list *tdmr_list,
-			   struct tdx_tdmr_sysinfo *tdmr_sysinfo)
+			   struct tdx_sys_info_tdmr *sysinfo_tdmr)
 {
 	size_t tdmr_sz, tdmr_array_sz;
 	void *tdmr_array;
 
-	tdmr_sz = tdmr_size_single(tdmr_sysinfo->max_reserved_per_tdmr);
-	tdmr_array_sz = tdmr_sz * tdmr_sysinfo->max_tdmrs;
+	tdmr_sz = tdmr_size_single(sysinfo_tdmr->max_reserved_per_tdmr);
+	tdmr_array_sz = tdmr_sz * sysinfo_tdmr->max_tdmrs;
 
 	/*
 	 * To keep things simple, allocate all TDMRs together.
@@ -367,7 +367,7 @@ static int alloc_tdmr_list(struct tdmr_info_list *tdmr_list,
 	 * at a given index in the TDMR list.
 	 */
 	tdmr_list->tdmr_sz = tdmr_sz;
-	tdmr_list->max_tdmrs = tdmr_sysinfo->max_tdmrs;
+	tdmr_list->max_tdmrs = sysinfo_tdmr->max_tdmrs;
 	tdmr_list->nr_consumed_tdmrs = 0;
 
 	return 0;
@@ -921,11 +921,11 @@ static int tdmrs_populate_rsvd_areas_all(struct tdmr_info_list *tdmr_list,
 /*
  * Construct a list of TDMRs on the preallocated space in @tdmr_list
  * to cover all TDX memory regions in @tmb_list based on the TDX module
- * TDMR global information in @tdmr_sysinfo.
+ * TDMR global information in @sysinfo_tdmr.
  */
 static int construct_tdmrs(struct list_head *tmb_list,
 			   struct tdmr_info_list *tdmr_list,
-			   struct tdx_tdmr_sysinfo *tdmr_sysinfo)
+			   struct tdx_sys_info_tdmr *sysinfo_tdmr)
 {
 	int ret;
 
@@ -934,12 +934,12 @@ static int construct_tdmrs(struct list_head *tmb_list,
 		return ret;
 
 	ret = tdmrs_set_up_pamt_all(tdmr_list, tmb_list,
-			tdmr_sysinfo->pamt_entry_size);
+			sysinfo_tdmr->pamt_entry_size);
 	if (ret)
 		return ret;
 
 	ret = tdmrs_populate_rsvd_areas_all(tdmr_list, tmb_list,
-			tdmr_sysinfo->max_reserved_per_tdmr);
+			sysinfo_tdmr->max_reserved_per_tdmr);
 	if (ret)
 		tdmrs_free_pamt_all(tdmr_list);
 
@@ -1098,7 +1098,7 @@ static int init_tdmrs(struct tdmr_info_list *tdmr_list)
 
 static int init_tdx_module(void)
 {
-	struct tdx_tdmr_sysinfo tdmr_sysinfo;
+	struct tdx_sys_info_tdmr sysinfo_tdmr;
 	int ret;
 
 	/*
@@ -1117,17 +1117,17 @@ static int init_tdx_module(void)
 	if (ret)
 		goto out_put_tdxmem;
 
-	ret = get_tdx_tdmr_sysinfo(&tdmr_sysinfo);
+	ret = get_tdx_sys_info_tdmr(&sysinfo_tdmr);
 	if (ret)
 		goto err_free_tdxmem;
 
 	/* Allocate enough space for constructing TDMRs */
-	ret = alloc_tdmr_list(&tdx_tdmr_list, &tdmr_sysinfo);
+	ret = alloc_tdmr_list(&tdx_tdmr_list, &sysinfo_tdmr);
 	if (ret)
 		goto err_free_tdxmem;
 
 	/* Cover all TDX-usable memory regions in TDMRs */
-	ret = construct_tdmrs(&tdx_memlist, &tdx_tdmr_list, &tdmr_sysinfo);
+	ret = construct_tdmrs(&tdx_memlist, &tdx_tdmr_list, &sysinfo_tdmr);
 	if (ret)
 		goto err_free_tdmrs;
 
diff --git a/arch/x86/virt/vmx/tdx/tdx.h b/arch/x86/virt/vmx/tdx/tdx.h
index b701f69485d3..148f9b4d1140 100644
--- a/arch/x86/virt/vmx/tdx/tdx.h
+++ b/arch/x86/virt/vmx/tdx/tdx.h
@@ -100,7 +100,7 @@ struct tdx_memblock {
 };
 
 /* "TDMR info" part of "Global Scope Metadata" for constructing TDMRs */
-struct tdx_tdmr_sysinfo {
+struct tdx_sys_info_tdmr {
 	u16 max_tdmrs;
 	u16 max_reserved_per_tdmr;
 	u16 pamt_entry_size[TDX_PS_NR];
-- 
2.46.2


