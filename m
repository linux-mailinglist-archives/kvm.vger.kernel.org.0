Return-Path: <kvm+bounces-19745-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 478FD909D3C
	for <lists+kvm@lfdr.de>; Sun, 16 Jun 2024 14:04:42 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 7D250B217C9
	for <lists+kvm@lfdr.de>; Sun, 16 Jun 2024 12:04:39 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9C7A9190054;
	Sun, 16 Jun 2024 12:02:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="NAHrHhoj"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E941B18FDC3;
	Sun, 16 Jun 2024 12:02:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.12
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718539334; cv=none; b=YmgBIocuKWt1vu+XXncx8VX/xERoKAzniVLN1sRbWdgRqChcanIj+kDKFiBXCu15y+eDZOmphGEqPRxnLtJSzW56M+TLCCZQKurRtFNySSPv4g9qbViahEtj+FemZN3/R8TrxJQvvyWGulLVQdGAKPtApP03KZOYu8jHMtmjgNs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718539334; c=relaxed/simple;
	bh=RQWrTEisf+S1wvmj4mHQzWV4YWIV0ubVfjoG0Zw3l9U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZLe1WXnZMaWupYGtxcfYXcmtygryITVICg0bbiUViFn8+cTn8NiMnfyPqT0MO22F5wG6mPHjUqf9XAjzuXbaQkyufhtdxzshSQ7F06I1PzckJdy5cJCG3fviw9cE+9JutvkqWYEppz8DCc03hKm+BCNoI1p5TZt++r712Jwoj1E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=NAHrHhoj; arc=none smtp.client-ip=198.175.65.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1718539333; x=1750075333;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=RQWrTEisf+S1wvmj4mHQzWV4YWIV0ubVfjoG0Zw3l9U=;
  b=NAHrHhojuQKgYkVPpPTvl577U9zV1QFtDLOyTD/4lf6pR8Sgt+lzyEK5
   pfja+CNozquze6uG9qhaP1FVyQH8OKQ1XBGEnD1qAoKLoOdLpncEsnWhe
   v1qCPPi3NiIPS4mQyPQWJ/wf4VlTV2MGE7AremKcrqwJODKJajTHmx4qo
   ruTq3vNG+D0gIPm3d5qiPZSNsr88r+I9IoBdoHLnklAfXpFDkUdkbjhRm
   sAJMH2+73kqjJhyTRGtqS1NRqoUrnH6JgouFmRjnDs9dksN3LukLKobyK
   0QOcAT1HMcdffonN1Kh8xTDtTDaTbBsAVJluYnv5U6pYFtDhGJuwelA5M
   Q==;
X-CSE-ConnectionGUID: ydzXywC5SW2/28MtSB8GTA==
X-CSE-MsgGUID: SgKXS8BaSESx1e19ZG/WEg==
X-IronPort-AV: E=McAfee;i="6700,10204,11104"; a="26800078"
X-IronPort-AV: E=Sophos;i="6.08,242,1712646000"; 
   d="scan'208";a="26800078"
Received: from orviesa004.jf.intel.com ([10.64.159.144])
  by orvoesa104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Jun 2024 05:02:13 -0700
X-CSE-ConnectionGUID: NBFbaBVbRjCcfsSB9szseQ==
X-CSE-MsgGUID: 9WV9WJlVRrWXz4prTfoE/A==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.08,242,1712646000"; 
   d="scan'208";a="46055955"
Received: from mgoodin-mobl2.amr.corp.intel.com (HELO khuang2-desk.gar.corp.intel.com) ([10.124.223.226])
  by orviesa004-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Jun 2024 05:02:09 -0700
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
Subject: [PATCH 8/9] x86/virt/tdx: Exclude memory region hole within CMR as TDMR's reserved area
Date: Mon, 17 Jun 2024 00:01:18 +1200
Message-ID: <cfbed1139887416b6fe0d130883dbe210e97d598.1718538552.git.kai.huang@intel.com>
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

A TDX module initialization failure was reported on a Emerald Rapids
platform:

  virt/tdx: initialization failed: TDMR [0x0, 0x80000000): reserved areas exhausted.
  virt/tdx: module initialization failed (-28)

As a step of initializing the TDX module, the kernel tells the TDX
module all the "TDX-usable memory regions" via a set of TDX architecture
defined structure "TD Memory Region" (TDMR).  Each TDMR must be in 1GB
aligned and in 1GB granularity, and all "non-TDX-usable memory holes" in
a given TDMR must be marked as a "reserved area".  Each TDMR only
supports a maximum number of reserved areas reported by the TDX module.

As shown above, the root cause of this failure is when the kernel tries
to construct a TDMR to cover address range [0x0, 0x80000000), there
are too many memory holes within that range and the number of memory
holes exceeds the maximum number of reserved areas.

The E820 table of that platform (see [1] below) reflects this: the
number of memory holes among e820 "usable" entries exceeds 16, which is
the maximum number of reserved areas TDX module supports in practice.

=== Fix ===

There are two options to fix this: 1) put less memory holes as "reserved
area" when constructing a TDMR; 2) reduce the TDMR's size to cover less
memory regions, thus less memory holes.

Option 1) is possible, and in fact is easier and preferable:

TDX actually has a concept of "Convertible Memory Regions" (CMRs).  TDX
reports a list of CMRs that meet TDX's security requirements on memory.
TDX requires all the "TDX-usable memory regions" that the kernel passes
to the module via TDMRs, a.k.a, all the "non-reserved regions in TDMRs",
must be convertible memory.

In other words, if a memory hole is indeed CMR, then it's not mandatory
for the kernel to add it to the reserved areas.  The number of consumed
reserved areas can be reduced if the kernel doesn't add those memory
holes as reserved area.  Note this doesn't have security impact because
the kernel is out of TDX's TCB anyway.

This is feasible because in practice the CMRs just reflect the nature of
whether the RAM can indeed be used by TDX, thus each CMR tends to be a
large range w/o being split into small areas, e.g., in the way the e820
table does to contain a lot "ACPI *" entries.  [2] below shows the CMRs
reported on the problematic platform (using the off-tree TDX code).

So for this particular module initialization failure, the memory holes
that are within [0x0, 0x80000000) are mostly indeed CMR.  By not adding
them to the reserved areas, the number of consumed reserved areas for
the TDMR [0x0, 0x80000000) can be dramatically reduced.

On the other hand, although option 2) is also theoretically feasible, it
requires more complicated logic to handle around splitting TDMR into
smaller ones.  E.g., today one memory region must be fully in one TDMR,
while splitting TDMR will result in each TDMR only covering part of some
memory region.  And this also increases the total number of TDMRs, which
also cannot exceed a maximum value that TDX module supports.

So, fix this issue by:

1) reading out the CMRs from the TDX module global metadata, and
2) passing the CMRs to the function construct_tdmrs(), and changing to
   not add a memory hole to the reserved areas when it is indeed CMR.

Also dump the CMRs in dmesg.  They are helpful when something goes wrong
around "constructing and passing the TDMRs to the TDX module to
configure it".

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
 arch/x86/virt/vmx/tdx/tdx.c | 149 ++++++++++++++++++++++++++++++++----
 arch/x86/virt/vmx/tdx/tdx.h |  13 ++++
 2 files changed, 146 insertions(+), 16 deletions(-)

diff --git a/arch/x86/virt/vmx/tdx/tdx.c b/arch/x86/virt/vmx/tdx/tdx.c
index ced40e3b516e..88a0c8b788b7 100644
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
@@ -372,6 +446,8 @@ static void print_basic_sysinfo(struct tdx_sysinfo *sysinfo)
 			modver->major,		modver->minor,
 			modver->update,		modver->internal,
 			modver->build_num,	modver->build_date);
+
+	print_cmr_info(&sysinfo->cmr_info);
 }
 
 #define TD_SYSINFO_MAP_TDMR_INFO(_field_id, _member)	\
@@ -404,6 +480,10 @@ static int get_tdx_sysinfo(struct tdx_sysinfo *sysinfo)
 	if (ret)
 		return ret;
 
+	ret = get_tdx_cmr_info(&sysinfo->cmr_info);
+	if (ret)
+		return ret;
+
 	return get_tdx_tdmr_sysinfo(&sysinfo->tdmr_info);
 }
 
@@ -827,6 +907,23 @@ static int tdmr_add_rsvd_area(struct tdmr_info *tdmr, int *p_idx, u64 addr,
 	return 0;
 }
 
+/* Return whether a given region [start, end) is a sub-region of any CMR */
+static bool is_cmr_subregion(struct tdx_sysinfo_cmr_info *cmr_info, u64 start,
+			    u64 end)
+{
+	int i;
+
+	for (i = 0; i < cmr_info->num_cmrs; i++) {
+		u64 cmr_base = cmr_info->cmr_base[i];
+		u64 cmr_size = cmr_info->cmr_size[i];
+
+		if (start >= cmr_base && end <= (cmr_base + cmr_size))
+			return true;
+	}
+
+	return false;
+}
+
 /*
  * Go through @tmb_list to find holes between memory areas.  If any of
  * those holes fall within @tdmr, set up a TDMR reserved area to cover
@@ -835,7 +932,8 @@ static int tdmr_add_rsvd_area(struct tdmr_info *tdmr, int *p_idx, u64 addr,
 static int tdmr_populate_rsvd_holes(struct list_head *tmb_list,
 				    struct tdmr_info *tdmr,
 				    int *rsvd_idx,
-				    u16 max_reserved_per_tdmr)
+				    u16 max_reserved_per_tdmr,
+				    struct tdx_sysinfo_cmr_info *cmr_info)
 {
 	struct tdx_memblock *tmb;
 	u64 prev_end;
@@ -864,10 +962,16 @@ static int tdmr_populate_rsvd_holes(struct list_head *tmb_list,
 		 * Skip over memory areas that
 		 * have already been dealt with.
 		 */
-		if (start <= prev_end) {
-			prev_end = end;
-			continue;
-		}
+		if (start <= prev_end)
+			goto next_tmb;
+
+		/*
+		 * Found the hole [prev_end, start) before this region.
+		 * Skip the hole if it is within any CMR to reduce the
+		 * consumption of reserved areas.
+		 */
+		if (is_cmr_subregion(cmr_info, prev_end, start))
+			goto next_tmb;
 
 		/* Add the hole before this region */
 		ret = tdmr_add_rsvd_area(tdmr, rsvd_idx, prev_end,
@@ -876,11 +980,16 @@ static int tdmr_populate_rsvd_holes(struct list_head *tmb_list,
 		if (ret)
 			return ret;
 
+next_tmb:
 		prev_end = end;
 	}
 
-	/* Add the hole after the last region if it exists. */
-	if (prev_end < tdmr_end(tdmr)) {
+	/*
+	 * Add the hole after the last region if it exists, but skip
+	 * if it is within any CMR.
+	 */
+	if (prev_end < tdmr_end(tdmr) &&
+			!is_cmr_subregion(cmr_info, prev_end, tdmr_end(tdmr))) {
 		ret = tdmr_add_rsvd_area(tdmr, rsvd_idx, prev_end,
 				tdmr_end(tdmr) - prev_end,
 				max_reserved_per_tdmr);
@@ -956,12 +1065,13 @@ static int rsvd_area_cmp_func(const void *a, const void *b)
 static int tdmr_populate_rsvd_areas(struct tdmr_info *tdmr,
 				    struct list_head *tmb_list,
 				    struct tdmr_info_list *tdmr_list,
-				    u16 max_reserved_per_tdmr)
+				    u16 max_reserved_per_tdmr,
+				    struct tdx_sysinfo_cmr_info *cmr_info)
 {
 	int ret, rsvd_idx = 0;
 
 	ret = tdmr_populate_rsvd_holes(tmb_list, tdmr, &rsvd_idx,
-			max_reserved_per_tdmr);
+			max_reserved_per_tdmr, cmr_info);
 	if (ret)
 		return ret;
 
@@ -979,11 +1089,13 @@ static int tdmr_populate_rsvd_areas(struct tdmr_info *tdmr,
 
 /*
  * Populate reserved areas for all TDMRs in @tdmr_list, including memory
- * holes (via @tmb_list) and PAMTs.
+ * holes (via @tmb_list) and PAMTs.  Exclude the memory holes within any
+ * CMR to reduce number of consumed reserved areas.
  */
 static int tdmrs_populate_rsvd_areas_all(struct tdmr_info_list *tdmr_list,
 					 struct list_head *tmb_list,
-					 u16 max_reserved_per_tdmr)
+					 u16 max_reserved_per_tdmr,
+					 struct tdx_sysinfo_cmr_info *cmr_info)
 {
 	int i;
 
@@ -991,7 +1103,8 @@ static int tdmrs_populate_rsvd_areas_all(struct tdmr_info_list *tdmr_list,
 		int ret;
 
 		ret = tdmr_populate_rsvd_areas(tdmr_entry(tdmr_list, i),
-				tmb_list, tdmr_list, max_reserved_per_tdmr);
+				tmb_list, tdmr_list, max_reserved_per_tdmr,
+				cmr_info);
 		if (ret)
 			return ret;
 	}
@@ -1002,11 +1115,13 @@ static int tdmrs_populate_rsvd_areas_all(struct tdmr_info_list *tdmr_list,
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
 
@@ -1020,7 +1135,8 @@ static int construct_tdmrs(struct list_head *tmb_list,
 		return ret;
 
 	ret = tdmrs_populate_rsvd_areas_all(tdmr_list, tmb_list,
-			tdmr_sysinfo->max_reserved_per_tdmr);
+			tdmr_sysinfo->max_reserved_per_tdmr,
+			cmr_info);
 	if (ret)
 		tdmrs_free_pamt_all(tdmr_list);
 
@@ -1210,7 +1326,8 @@ static int init_tdx_module(void)
 		goto err_free_tdxmem;
 
 	/* Cover all TDX-usable memory regions in TDMRs */
-	ret = construct_tdmrs(&tdx_memlist, &tdx_tdmr_list, &sysinfo.tdmr_info);
+	ret = construct_tdmrs(&tdx_memlist, &tdx_tdmr_list, &sysinfo.tdmr_info,
+			&sysinfo.cmr_info);
 	if (ret)
 		goto err_free_tdmrs;
 
diff --git a/arch/x86/virt/vmx/tdx/tdx.h b/arch/x86/virt/vmx/tdx/tdx.h
index d80ec797fbf1..be93b6f31e5b 100644
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
2.43.2


