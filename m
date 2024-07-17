Return-Path: <kvm+bounces-21755-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 22FD49335C0
	for <lists+kvm@lfdr.de>; Wed, 17 Jul 2024 05:43:30 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id CB00C2823FF
	for <lists+kvm@lfdr.de>; Wed, 17 Jul 2024 03:43:28 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 528502D611;
	Wed, 17 Jul 2024 03:41:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="WaFLygsM"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 64FCE1F95E;
	Wed, 17 Jul 2024 03:41:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.19
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721187678; cv=none; b=at8UJIww+1KWHrGByEfXOTKL8J9xcIt6/YDyIE0TMprFthHmwthFGjb9jOk3r+4ICBoFbWbktvsjdKYWGdz3AUtsg3Mzmjx0T7R6COdHRPClf3iUgOTk7ybP7hC3U4lrs1oeDbURn3GoIdkgsunzolTMd8qJ1Arc5SUhqPvs6uY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721187678; c=relaxed/simple;
	bh=omsHwj0X7BH66iJj+RL2DFUqA8reoIN6AdLHNWLvsRw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=avh6KTgcbS/qfvDM80LXFNLmUN5zuwURCRBc/ggesSrAYkTvUFAF/I8UqGWs1ki8eJfeDS3D8a2y6Xiu0DXRdMZu39dMmrG6BeeCcguouH3TdXn4cAFfNmpTKQtRwYLloz93c26tu1Z9EyqBHYPGVrr74+AJ9DVtQTOeFWiQ2Z4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=WaFLygsM; arc=none smtp.client-ip=198.175.65.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1721187676; x=1752723676;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=omsHwj0X7BH66iJj+RL2DFUqA8reoIN6AdLHNWLvsRw=;
  b=WaFLygsMyeydIK9iLoFUbOL1XuQAnpWkn8+6rOnI7H2t4YW6x92n4oFR
   pFuT15jZocYAOJM27o/3QZbYy/+ntYQoo1dPUtxeu67W+OzAYYCaVg6P7
   VWq6MgRuDKx/axNli9f4pSCaE6RUS5D0QzzckfRO0FWkxuGqhljY94HeY
   7FNl+3wJPtRvQyGC4gDJ3qfzmCluBH+4Vot2GZwR4EnufPUC0Ed1aIcuk
   UL6wqTsD9yOijbkycRjFEvlvyNg4nOKnyxAhDGENPsjQmwL/5LWY2Scod
   yz15e/UQ3dMMdxj/6fEN7JkotOsZTohGk9bdRkRlGlnG7dgUV+j/5IGIg
   g==;
X-CSE-ConnectionGUID: JxzjbWgMQFmmRqCPVvf8zw==
X-CSE-MsgGUID: mzm8C8NZT6S6InORlIflAg==
X-IronPort-AV: E=McAfee;i="6700,10204,11135"; a="18512474"
X-IronPort-AV: E=Sophos;i="6.09,213,1716274800"; 
   d="scan'208";a="18512474"
Received: from fmviesa005.fm.intel.com ([10.60.135.145])
  by orvoesa111.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Jul 2024 20:41:12 -0700
X-CSE-ConnectionGUID: gxPOXPLGQr29jWYrcj8eEw==
X-CSE-MsgGUID: qHP3OpFoQOy3t8WyKmUqZA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.09,213,1716274800"; 
   d="scan'208";a="54566766"
Received: from rfrazer-mobl3.amr.corp.intel.com (HELO khuang2-desk.gar.corp.intel.com) ([10.124.222.184])
  by fmviesa005-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Jul 2024 20:41:07 -0700
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
Subject: [PATCH v2 09/10] x86/virt/tdx: Reduce TDMR's reserved areas by using CMRs to find memory holes
Date: Wed, 17 Jul 2024 15:40:16 +1200
Message-ID: <39c7ffb3a6d5d4075017a1c0931f85486d64e9f7.1721186590.git.kai.huang@intel.com>
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

A TDX module initialization failure was reported on a Emerald Rapids
platform:

  virt/tdx: initialization failed: TDMR [0x0, 0x80000000): reserved areas exhausted.
  virt/tdx: module initialization failed (-28)

As part of initializing the TDX module, the kernel informs the TDX
module of all "TDX-usable memory regions" using an array of TDX defined
structure "TD Memory Region" (TDMR).  Each TDMR must be in 1GB aligned
and in 1GB granularity, and all "non-TDX-usable memory holes" within a
given TDMR must be marked as "reserved areas".  The TDX module reports a
maximum number of reserved areas that can be supported per TDMR.

Currently, the kernel finds those "non-TDX-usable memory holes" within a
given TDMR by walking over a list of "TDX-usable memory regions", which
essentially reflects the "usable" regions in the e820 table (w/o memory
hotplug operations precisely, but this is not relevant here).

As shown above, the root cause of this failure is when the kernel tries
to construct a TDMR to cover address range [0x0, 0x80000000), there
are too many memory holes within that range and the number of memory
holes exceeds the maximum number of reserved areas.

The E820 table of that platform (see [1] below) reflects this: the
number of memory holes among e820 "usable" entries exceeds 16, which is
the maximum number of reserved areas TDX module supports in practice.

=== Fix ===

There are two options to fix this: 1) reduce the number of memory holes
when constructing a TDMR to save "reserved areas"; 2) reduce the TDMR's
size to cover fewer memory regions, thus fewer memory holes.

Option 1) is possible, and in fact is easier and preferable:

TDX actually has a concept of "Convertible Memory Regions" (CMRs).  TDX
reports a list of CMRs that meet TDX's security requirements on memory.
TDX requires all the "TDX-usable memory regions" that the kernel passes
to the module via TDMRs, a.k.a, all the "non-reserved regions in TDMRs",
must be convertible memory.

In other words, if a memory hole is indeed CMR, then it's not mandatory
for the kernel to add it to the reserved areas.  By doing so, the number
of consumed reserved areas can be reduced w/o having any functional
impact.  The kernel still allocates TDX memory from the page allocator.
There's no harm if the kernel tells the TDX module some memory regions
are "TDX-usable" but they will never be allocated by the kernel as TDX
memory.

Note this doesn't have any security impact either because the kernel is
out of TDX's TCB anyway.

This is feasible because in practice the CMRs just reflect the nature of
whether the RAM can indeed be used by TDX, thus each CMR tends to be a
large, uninterrupted range of memory, i.e., unlike the e820 table which
contains numerous "ACPI *" entries in the first 2G range.  Refer to [2]
for CMRs reported on the problematic platform using off-tree TDX code.

So for this particular module initialization failure, the memory holes
that are within [0x0, 0x80000000) are mostly indeed CMR.  By not adding
them to the reserved areas, the number of consumed reserved areas for
the TDMR [0x0, 0x80000000) can be dramatically reduced.

Option 2) is also theoretically feasible, but it is not desired:

It requires more complicated logic to handle splitting TDMR into smaller
ones, which isn't trivial.  There are limitations to splitting TDMR too,
thus it may not always work: 1) The smallest TDMR is 1GB, and it cannot
be split any further; 2) This also increases the total number of TDMRs,
which also has a maximum value limited by the TDX module.

So, fix this issue by using option 1):

1) reading out the CMRs from the TDX module global metadata, and
2) changing to find memory holes for a given TDMR based on CMRs, but not
   based on the list of "TDX-usable memory regions".

Also dump the CMRs in dmesg.  They are helpful when something goes wrong
around "constructing the TDMRs and configuring the TDX module with
them".  Note there are no existing userspace tools that the user can get
CMRs since they can only be read via SEAMCALL (no CPUID, MSR etc).

[1] BIOS-E820 table of the problematic platform:

  BIOS-e820: [mem 0x0000000000000000-0x000000000009efff] usable
  BIOS-e820: [mem 0x000000000009f000-0x00000000000fffff] reserved
  BIOS-e820: [mem 0x0000000000100000-0x000000005d168fff] usable
  BIOS-e820: [mem 0x000000005d169000-0x000000005d22afff] ACPI data
  BIOS-e820: [mem 0x000000005d22b000-0x000000005d3cefff] usable
  BIOS-e820: [mem 0x000000005d3cf000-0x000000005d469fff] reserved
  BIOS-e820: [mem 0x000000005d46a000-0x000000005e5b2fff] usable
  BIOS-e820: [mem 0x000000005e5b3000-0x000000005e5c2fff] reserved
  BIOS-e820: [mem 0x000000005e5c3000-0x000000005e5d2fff] usable
  BIOS-e820: [mem 0x000000005e5d3000-0x000000005e5e4fff] reserved
  BIOS-e820: [mem 0x000000005e5e5000-0x000000005eb57fff] usable
  BIOS-e820: [mem 0x000000005eb58000-0x0000000061357fff] ACPI NVS
  BIOS-e820: [mem 0x0000000061358000-0x000000006172afff] usable
  BIOS-e820: [mem 0x000000006172b000-0x0000000061794fff] ACPI data
  BIOS-e820: [mem 0x0000000061795000-0x00000000617fefff] usable
  BIOS-e820: [mem 0x00000000617ff000-0x0000000061912fff] ACPI data
  BIOS-e820: [mem 0x0000000061913000-0x0000000061998fff] usable
  BIOS-e820: [mem 0x0000000061999000-0x00000000619dffff] ACPI data
  BIOS-e820: [mem 0x00000000619e0000-0x00000000619e1fff] usable
  BIOS-e820: [mem 0x00000000619e2000-0x00000000619e9fff] reserved
  BIOS-e820: [mem 0x00000000619ea000-0x0000000061a26fff] usable
  BIOS-e820: [mem 0x0000000061a27000-0x0000000061baefff] ACPI data
  BIOS-e820: [mem 0x0000000061baf000-0x00000000623c2fff] usable
  BIOS-e820: [mem 0x00000000623c3000-0x0000000062471fff] reserved
  BIOS-e820: [mem 0x0000000062472000-0x0000000062823fff] usable
  BIOS-e820: [mem 0x0000000062824000-0x0000000063a24fff] reserved
  BIOS-e820: [mem 0x0000000063a25000-0x0000000063d57fff] usable
  BIOS-e820: [mem 0x0000000063d58000-0x0000000064157fff] reserved
  BIOS-e820: [mem 0x0000000064158000-0x0000000064158fff] usable
  BIOS-e820: [mem 0x0000000064159000-0x0000000064194fff] reserved
  BIOS-e820: [mem 0x0000000064195000-0x000000006e9cefff] usable
  BIOS-e820: [mem 0x000000006e9cf000-0x000000006eccefff] reserved
  BIOS-e820: [mem 0x000000006eccf000-0x000000006f6fefff] ACPI NVS
  BIOS-e820: [mem 0x000000006f6ff000-0x000000006f7fefff] ACPI data
  BIOS-e820: [mem 0x000000006f7ff000-0x000000006f7fffff] usable
  BIOS-e820: [mem 0x000000006f800000-0x000000008fffffff] reserved
  ......

[2] Convertible Memory Regions of the problematic platform:

  virt/tdx: CMR: [0x100000, 0x6f800000)
  virt/tdx: CMR: [0x100000000, 0x107a000000)
  virt/tdx: CMR: [0x1080000000, 0x207c000000)
  virt/tdx: CMR: [0x2080000000, 0x307c000000)
  virt/tdx: CMR: [0x3080000000, 0x407c000000)

Signed-off-by: Kai Huang <kai.huang@intel.com>
---

v1 -> v2:
 - Change to walk over CMRs directly to find out memory holes, instead
   of walking over TDX memory blocks and explicitly check whether a hole
   is subregion of CMR.  (Chao)
 - Mention any constant macro definitions in global metadata structures
   are TDX architectural. (Binbin)
 - Slightly improve the changelog.

---
 arch/x86/virt/vmx/tdx/tdx.c | 116 ++++++++++++++++++++++++++++++------
 arch/x86/virt/vmx/tdx/tdx.h |  15 ++++-
 2 files changed, 113 insertions(+), 18 deletions(-)

diff --git a/arch/x86/virt/vmx/tdx/tdx.c b/arch/x86/virt/vmx/tdx/tdx.c
index 5ac0c411f4f7..3c19295f1f8f 100644
--- a/arch/x86/virt/vmx/tdx/tdx.c
+++ b/arch/x86/virt/vmx/tdx/tdx.c
@@ -293,6 +293,10 @@ static int stbuf_read_sysmd_field(u64 field_id, void *stbuf, int offset,
 	return 0;
 }
 
+/* Wrapper to read one metadata field to u8/u16/u32/u64 */
+#define stbuf_read_sysmd_single(_field_id, _pdata)	\
+	stbuf_read_sysmd_field(_field_id, _pdata, 0, sizeof(typeof(*(_pdata))))
+
 struct field_mapping {
 	u64 field_id;
 	int offset;
@@ -349,6 +353,76 @@ static int get_tdx_module_version(struct tdx_sysinfo_module_version *modver)
 	return stbuf_read_sysmd_multi(fields, ARRAY_SIZE(fields), modver);
 }
 
+/* Update the @cmr_info->num_cmrs to trim tail empty CMRs */
+static void trim_empty_tail_cmrs(struct tdx_sysinfo_cmr_info *cmr_info)
+{
+	int i;
+
+	for (i = 0; i < cmr_info->num_cmrs; i++) {
+		u64 cmr_base = cmr_info->cmr_base[i];
+		u64 cmr_size = cmr_info->cmr_size[i];
+
+		if (!cmr_size) {
+			WARN_ON_ONCE(cmr_base);
+			break;
+		}
+
+		/* TDX architecture: CMR must be 4KB aligned */
+		WARN_ON_ONCE(!PAGE_ALIGNED(cmr_base) ||
+				!PAGE_ALIGNED(cmr_size));
+	}
+
+	cmr_info->num_cmrs = i;
+}
+
+#define TD_SYSINFO_MAP_CMR_INFO(_field_id, _member)	\
+	TD_SYSINFO_MAP(_field_id, struct tdx_sysinfo_cmr_info, _member)
+
+static int get_tdx_cmr_info(struct tdx_sysinfo_cmr_info *cmr_info)
+{
+	int i, ret;
+
+	ret = stbuf_read_sysmd_single(MD_FIELD_ID_NUM_CMRS,
+			&cmr_info->num_cmrs);
+	if (ret)
+		return ret;
+
+	for (i = 0; i < cmr_info->num_cmrs; i++) {
+		const struct field_mapping fields[] = {
+			TD_SYSINFO_MAP_CMR_INFO(CMR_BASE0 + i, cmr_base[i]),
+			TD_SYSINFO_MAP_CMR_INFO(CMR_SIZE0 + i, cmr_size[i]),
+		};
+
+		ret = stbuf_read_sysmd_multi(fields, ARRAY_SIZE(fields),
+				cmr_info);
+		if (ret)
+			return ret;
+	}
+
+	/*
+	 * The TDX module may just report the maximum number of CMRs that
+	 * TDX architecturally supports as the actual number of CMRs,
+	 * despite the latter is smaller.  In this case all the tail
+	 * CMRs will be empty.  Trim them away.
+	 */
+	trim_empty_tail_cmrs(cmr_info);
+
+	return 0;
+}
+
+static void print_cmr_info(struct tdx_sysinfo_cmr_info *cmr_info)
+{
+	int i;
+
+	for (i = 0; i < cmr_info->num_cmrs; i++) {
+		u64 cmr_base = cmr_info->cmr_base[i];
+		u64 cmr_size = cmr_info->cmr_size[i];
+
+		pr_info("CMR[%d]: [0x%llx, 0x%llx)\n", i, cmr_base,
+				cmr_base + cmr_size);
+	}
+}
+
 static void print_basic_sysinfo(struct tdx_sysinfo *sysinfo)
 {
 	struct tdx_sysinfo_module_version *modver = &sysinfo->module_version;
@@ -369,6 +443,8 @@ static void print_basic_sysinfo(struct tdx_sysinfo *sysinfo)
 			modver->internal, modver->build_num,
 			modver->build_date, debug ? "Debug" : "Production",
 			modinfo->tdx_features0);
+
+	print_cmr_info(&sysinfo->cmr_info);
 }
 
 #define TD_SYSINFO_MAP_TDMR_INFO(_field_id, _member)	\
@@ -401,6 +477,10 @@ static int get_tdx_sysinfo(struct tdx_sysinfo *sysinfo)
 	if (ret)
 		return ret;
 
+	ret = get_tdx_cmr_info(&sysinfo->cmr_info);
+	if (ret)
+		return ret;
+
 	return get_tdx_tdmr_sysinfo(&sysinfo->tdmr_info);
 }
 
@@ -825,29 +905,28 @@ static int tdmr_add_rsvd_area(struct tdmr_info *tdmr, int *p_idx, u64 addr,
 }
 
 /*
- * Go through @tmb_list to find holes between memory areas.  If any of
+ * Go through all CMRs in @cmr_info to find memory holes.  If any of
  * those holes fall within @tdmr, set up a TDMR reserved area to cover
  * the hole.
  */
-static int tdmr_populate_rsvd_holes(struct list_head *tmb_list,
+static int tdmr_populate_rsvd_holes(struct tdx_sysinfo_cmr_info *cmr_info,
 				    struct tdmr_info *tdmr,
 				    int *rsvd_idx,
 				    u16 max_reserved_per_tdmr)
 {
-	struct tdx_memblock *tmb;
 	u64 prev_end;
-	int ret;
+	int i, ret;
 
 	/*
 	 * Start looking for reserved blocks at the
 	 * beginning of the TDMR.
 	 */
 	prev_end = tdmr->base;
-	list_for_each_entry(tmb, tmb_list, list) {
+	for (i = 0; i < cmr_info->num_cmrs; i++) {
 		u64 start, end;
 
-		start = PFN_PHYS(tmb->start_pfn);
-		end   = PFN_PHYS(tmb->end_pfn);
+		start = cmr_info->cmr_base[i];
+		end   = start + cmr_info->cmr_size[i];
 
 		/* Break if this region is after the TDMR */
 		if (start >= tdmr_end(tdmr))
@@ -948,16 +1027,16 @@ static int rsvd_area_cmp_func(const void *a, const void *b)
 
 /*
  * Populate reserved areas for the given @tdmr, including memory holes
- * (via @tmb_list) and PAMTs (via @tdmr_list).
+ * (via @cmr_info) and PAMTs (via @tdmr_list).
  */
 static int tdmr_populate_rsvd_areas(struct tdmr_info *tdmr,
-				    struct list_head *tmb_list,
+				    struct tdx_sysinfo_cmr_info *cmr_info,
 				    struct tdmr_info_list *tdmr_list,
 				    u16 max_reserved_per_tdmr)
 {
 	int ret, rsvd_idx = 0;
 
-	ret = tdmr_populate_rsvd_holes(tmb_list, tdmr, &rsvd_idx,
+	ret = tdmr_populate_rsvd_holes(cmr_info, tdmr, &rsvd_idx,
 			max_reserved_per_tdmr);
 	if (ret)
 		return ret;
@@ -976,10 +1055,10 @@ static int tdmr_populate_rsvd_areas(struct tdmr_info *tdmr,
 
 /*
  * Populate reserved areas for all TDMRs in @tdmr_list, including memory
- * holes (via @tmb_list) and PAMTs.
+ * holes (via @cmr_info) and PAMTs.
  */
 static int tdmrs_populate_rsvd_areas_all(struct tdmr_info_list *tdmr_list,
-					 struct list_head *tmb_list,
+					 struct tdx_sysinfo_cmr_info *cmr_info,
 					 u16 max_reserved_per_tdmr)
 {
 	int i;
@@ -988,7 +1067,7 @@ static int tdmrs_populate_rsvd_areas_all(struct tdmr_info_list *tdmr_list,
 		int ret;
 
 		ret = tdmr_populate_rsvd_areas(tdmr_entry(tdmr_list, i),
-				tmb_list, tdmr_list, max_reserved_per_tdmr);
+				cmr_info, tdmr_list, max_reserved_per_tdmr);
 		if (ret)
 			return ret;
 	}
@@ -999,11 +1078,13 @@ static int tdmrs_populate_rsvd_areas_all(struct tdmr_info_list *tdmr_list,
 /*
  * Construct a list of TDMRs on the preallocated space in @tdmr_list
  * to cover all TDX memory regions in @tmb_list based on the TDX module
- * TDMR global information in @tdmr_sysinfo.
+ * TDMR global information in @tdmr_sysinfo and CMR information in
+ * @cmr_info.
  */
 static int construct_tdmrs(struct list_head *tmb_list,
 			   struct tdmr_info_list *tdmr_list,
-			   struct tdx_sysinfo_tdmr_info *tdmr_sysinfo)
+			   struct tdx_sysinfo_tdmr_info *tdmr_sysinfo,
+			   struct tdx_sysinfo_cmr_info *cmr_info)
 {
 	int ret;
 
@@ -1016,7 +1097,7 @@ static int construct_tdmrs(struct list_head *tmb_list,
 	if (ret)
 		return ret;
 
-	ret = tdmrs_populate_rsvd_areas_all(tdmr_list, tmb_list,
+	ret = tdmrs_populate_rsvd_areas_all(tdmr_list, cmr_info,
 			tdmr_sysinfo->max_reserved_per_tdmr);
 	if (ret)
 		tdmrs_free_pamt_all(tdmr_list);
@@ -1207,7 +1288,8 @@ static int init_tdx_module(void)
 		goto err_free_tdxmem;
 
 	/* Cover all TDX-usable memory regions in TDMRs */
-	ret = construct_tdmrs(&tdx_memlist, &tdx_tdmr_list, &sysinfo.tdmr_info);
+	ret = construct_tdmrs(&tdx_memlist, &tdx_tdmr_list, &sysinfo.tdmr_info,
+			&sysinfo.cmr_info);
 	if (ret)
 		goto err_free_tdmrs;
 
diff --git a/arch/x86/virt/vmx/tdx/tdx.h b/arch/x86/virt/vmx/tdx/tdx.h
index 861ddf2c2e88..4b43eb774ffa 100644
--- a/arch/x86/virt/vmx/tdx/tdx.h
+++ b/arch/x86/virt/vmx/tdx/tdx.h
@@ -40,6 +40,10 @@
 #define MD_FIELD_ID_UPDATE_VERSION		0x0800000100000005ULL
 #define MD_FIELD_ID_INTERNAL_VERSION		0x0800000100000006ULL
 
+#define MD_FIELD_ID_NUM_CMRS			0x9000000100000000ULL
+#define MD_FIELD_ID_CMR_BASE0			0x9000000300000080ULL
+#define MD_FIELD_ID_CMR_SIZE0			0x9000000300000100ULL
+
 #define MD_FIELD_ID_MAX_TDMRS			0x9100000100000008ULL
 #define MD_FIELD_ID_MAX_RESERVED_PER_TDMR	0x9100000100000009ULL
 #define MD_FIELD_ID_PAMT_4K_ENTRY_SIZE		0x9100000100000010ULL
@@ -134,7 +138,7 @@ struct tdmr_info_list {
  * Note not all metadata fields in each class are defined, only those
  * used by the kernel are.
  *
- * Also note the "bit definitions" are architectural.
+ * Also note the "bit/constant definitions" are architectural.
  */
 
 /* Class "TDX Module Info" */
@@ -155,6 +159,14 @@ struct tdx_sysinfo_module_version {
 	u32 build_date;
 };
 
+/* Class "CMR Info" */
+#define TDX_MAX_CMRS	32
+struct tdx_sysinfo_cmr_info {
+	u16 num_cmrs;
+	u64 cmr_base[TDX_MAX_CMRS];
+	u64 cmr_size[TDX_MAX_CMRS];
+};
+
 /* Class "TDMR Info" */
 struct tdx_sysinfo_tdmr_info {
 	u16 max_tdmrs;
@@ -165,6 +177,7 @@ struct tdx_sysinfo_tdmr_info {
 struct tdx_sysinfo {
 	struct tdx_sysinfo_module_info		module_info;
 	struct tdx_sysinfo_module_version	module_version;
+	struct tdx_sysinfo_cmr_info		cmr_info;
 	struct tdx_sysinfo_tdmr_info		tdmr_info;
 };
 
-- 
2.45.2


