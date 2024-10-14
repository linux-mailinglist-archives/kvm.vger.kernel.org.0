Return-Path: <kvm+bounces-28747-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 71AF899C8F1
	for <lists+kvm@lfdr.de>; Mon, 14 Oct 2024 13:32:55 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 31CE12915C7
	for <lists+kvm@lfdr.de>; Mon, 14 Oct 2024 11:32:54 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D8B5019F489;
	Mon, 14 Oct 2024 11:32:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="LRTN+i8V"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 59C0119D8B5;
	Mon, 14 Oct 2024 11:32:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.12
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728905537; cv=none; b=m1stGtOUIr8wSdvUikxVBbgaoKviyWDKQ2LUOELQ2bFg/hyTILMeoJjiu0A2PQQOaTXNKkfIvwksYcZ7ivZZnf5OLJQvu1fcCVnFCISi7dLWHedkfaZS1aEYrLiW8bz06suAlO/HIMHbuodSpN7Pbc1s9bEDHywHTz1+DdGnc6o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728905537; c=relaxed/simple;
	bh=cQAl2DIUCEYx9ze1aKAOpRrIGrQdcbonzNi6afsmBjs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CrpF6JI6E0Pu1B2nleH31es8xuztxBFqbeQHq6l7UvdnFFLYOar5akhQY+JzoSlr2oCudFdxYHwiGpXeAoSiNXLTGbkOTG6HhXjwJjCNZzE8iR6cv+qh9rI5uNo7oyognCL/fLHaRsToNfGvH2MPYbwrs2zIYuGCQiWYeGxfq9M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=LRTN+i8V; arc=none smtp.client-ip=192.198.163.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1728905535; x=1760441535;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=cQAl2DIUCEYx9ze1aKAOpRrIGrQdcbonzNi6afsmBjs=;
  b=LRTN+i8VwQzEqj9st+pvU7N/Lwd9JSfV0zRaNx6bIYjmjESw9u0HvOWc
   9kUJzr26HuSDzn0cuegRwlFbjZ0DOPtlL0P1J35B9riQfWPS9a/Wz5DL4
   0hK5Ete7wNIvuVryQmTI73bvECkssHcG3cURS12X7INP+DtDtwWwI+O1G
   MPGgDIUIm2RgqfzjtkXyHGdSlsdmpZ/dGdeSQxQxUQT2ixXFlBgkUXouU
   +bC8tcUMvqHWWfsV5LmIij6NcBqUAYybw6UnvZ3RsWqVyCq32iv1/a7sz
   rcK9/KTm5GP7QQLRTBvMyu3KwSD7tgH4YDZaWOeJPhRiM6udA2b56j8HP
   g==;
X-CSE-ConnectionGUID: NzkThZwCQ4qXd247iMo8Ww==
X-CSE-MsgGUID: pEzMt5NWR7iTsc6cTaZUsg==
X-IronPort-AV: E=McAfee;i="6700,10204,11224"; a="32166460"
X-IronPort-AV: E=Sophos;i="6.11,202,1725346800"; 
   d="scan'208";a="32166460"
Received: from fmviesa005.fm.intel.com ([10.60.135.145])
  by fmvoesa106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Oct 2024 04:32:15 -0700
X-CSE-ConnectionGUID: vOzFU7frQG2rHn7c7FSwTg==
X-CSE-MsgGUID: RhVeU4SlRuqw9OldBQt5nQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.11,202,1725346800"; 
   d="scan'208";a="82117462"
Received: from jdoman-desk1.amr.corp.intel.com (HELO khuang2-desk.gar.corp.intel.com) ([10.124.220.204])
  by fmviesa005-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Oct 2024 04:32:12 -0700
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
Subject: [PATCH v5 1/8] x86/virt/tdx: Rename 'struct tdx_tdmr_sysinfo' to reflect the spec better
Date: Tue, 15 Oct 2024 00:31:48 +1300
Message-ID: <610e4030201c337d5e9b4f3a13d3da565f7ed6c7.1728903647.git.kai.huang@intel.com>
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

v4 -> v5:
 - No change

v3 -> v4:
 - "global metadata fields" -> "Global Metadata Fields" - Ardian.
 - "Class"es -> "Classes" - Ardian.
 - Add tag from Ardian and Dan.

v2 -> v3:
 - Split out as a separate patch and place it at beginning:

   https://lore.kernel.org/kvm/cover.1721186590.git.kai.huang@intel.com/T/#m8fec7c429242d640cf5e756eb68e3b822e6dff8b
 
 - Rename to 'struct tdx_sys_info_tdmr':

   https://lore.kernel.org/kvm/cover.1721186590.git.kai.huang@intel.com/T/#md73dd9b02a492acf4a6facae63e8d030e320967d
   https://lore.kernel.org/kvm/cover.1721186590.git.kai.huang@intel.com/T/#m8fec7c429242d640cf5e756eb68e3b822e6dff8b


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


