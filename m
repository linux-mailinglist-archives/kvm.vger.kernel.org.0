Return-Path: <kvm+bounces-27365-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 4FF089844AB
	for <lists+kvm@lfdr.de>; Tue, 24 Sep 2024 13:31:55 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 72BBD1C23E67
	for <lists+kvm@lfdr.de>; Tue, 24 Sep 2024 11:31:54 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DB5EC1AB510;
	Tue, 24 Sep 2024 11:29:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="hiaSN855"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.8])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2AC9B1AAE3D;
	Tue, 24 Sep 2024 11:29:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.8
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727177380; cv=none; b=dAISCB+W227kxw6qLQAisI4JS3I5S85EMYcc8WZFezfcXMCMHEBwthxlP1xfJJQqBFl1hWsr4H86QunWzyJ0hXNmQkd46PScyj1cS3vB+x7WzXxRFIeAUBB8CkKOfa1YQKsHBVXYVz8qsKZeAz6IChILXXjSFPvPe0p42zpVBGE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727177380; c=relaxed/simple;
	bh=b2Zpu6bNVNvwiXpYcKr+Aro9HlSAW2yxucUmtiP7yD8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dci5oYPAvqMZPvLRoLngzE5Lgx4jg8pPOSeiNQVW1flpI5wUVH7m/m2cwe/7AMC9Wovf4UIEptAmcwHE7K5yJn8ypBajq/wYFDFdPOTY7oRDGSX0vgfisNGfdJNjVlAFTA3MURhRW1E9c0hpngNjQkO086l0fQLllLfnDr8MLPc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=hiaSN855; arc=none smtp.client-ip=192.198.163.8
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1727177378; x=1758713378;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=b2Zpu6bNVNvwiXpYcKr+Aro9HlSAW2yxucUmtiP7yD8=;
  b=hiaSN855IA+of+5sGP49URBzwMXk0dzG9LL6oB9xVpc2+TsK592PKe75
   Y0rCA6da2bEEcxe1Zf59h4fsDRaGcGlKOCbn/Bbfqz3ZnqyAXkfvZhlOP
   YqiMLM/R5K5mgngCFhsgyS60uX7bd6CGUodA/1fxTs8FiPwVemBIwR4hW
   o+S0QM2tJnDy1QKffgQkItHLZ3PevPxNwk6aWOcaUj3rt7gnw8rBtseFo
   gzLJAhJeVkW7LkiW++YayXNHHXfwOZfTC81/gtRRSCyGubSKuykcSNZdF
   NQlNiPkog5hCfQCvlODNhMX7bMkPNxVVX17Mj+c8LsRpRY7U8RNfSwCaF
   Q==;
X-CSE-ConnectionGUID: QYw4k441QhGB6eN0kM7Q5w==
X-CSE-MsgGUID: 8ZX2Th8SQ8Sxsxk+eNBFqQ==
X-IronPort-AV: E=McAfee;i="6700,10204,11204"; a="43686597"
X-IronPort-AV: E=Sophos;i="6.10,254,1719903600"; 
   d="scan'208";a="43686597"
Received: from fmviesa007.fm.intel.com ([10.60.135.147])
  by fmvoesa102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Sep 2024 04:29:38 -0700
X-CSE-ConnectionGUID: obuwKZQYQCyMlZnl98vG/w==
X-CSE-MsgGUID: 0Wbw5c+HS+uRb+9buEmUOQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.10,254,1719903600"; 
   d="scan'208";a="70994703"
Received: from ccbilbre-mobl3.amr.corp.intel.com (HELO khuang2-desk.gar.corp.intel.com) ([10.124.221.10])
  by fmviesa007-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Sep 2024 04:29:34 -0700
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
Subject: [PATCH v4 8/8] x86/virt/tdx: Reduce TDMR's reserved areas by using CMRs to find memory holes
Date: Tue, 24 Sep 2024 23:28:35 +1200
Message-ID: <708d6c9d4d3ed9d47f62760f6d8bd88a3f16dd78.1727173372.git.kai.huang@intel.com>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <cover.1727173372.git.kai.huang@intel.com>
References: <cover.1727173372.git.kai.huang@intel.com>
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
given TDMR are marked as "reserved areas".  The TDX module reports a
maximum number of reserved areas that can be supported per TDMR (16).

The kernel builds the "TDX-usable memory regions" based on memblocks
(which reflects e820), and uses this list to find all "reserved areas"
for each TDMR.

It turns out that the kernel's view of memory holes is too fine grained
and sometimes exceeds the number of holes that the TDX module can track
per TDMR [1], resulting in the above failure.

Thankfully the module also lists memory that is potentially convertible
in a list of "Convertible Memory Regions" (CMRs).  That coarser grained
CMR list tends to track usable memory in the memory map even if it might
be reserved for host usage like 'ACPI data' [2].

Use that list to relax what the kernel considers unusable memory.  If it
falls in a CMR no need to instantiate a hole, and rely on the fact that
kernel will keep what it considers 'reserved' out of the page allocator.

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

Fixes: dde3b60d572c ("x86/virt/tdx: Designate reserved areas for all TDMRs")
Signed-off-by: Kai Huang <kai.huang@intel.com>
---

v3 -> v4:
 - Trim down changelog - Dan.
 - "must be marked as reserved areas" -> "are marked as reserved areas" - Ardian.
 - Remove all WARN_ON_ONCE() for CMR sanity checks, and clarify in the
   comment that CMRs are verified by MCHECK before it enables TDX so we
   can trust hardware.
 - Change CMR_BASE(i) macro back to just define CMR_BASE and do the
   "+i" in the code.

v2 -> v3:

 - Add the Fixes tag, although this patch depends on previous patches.
 - CMR_BASE0 -> CMR_BASE(_i), CMR_SIZE0 -> CMR_SIZE(_i) to silence the
   build-check error.

v1 -> v2:
 - Change to walk over CMRs directly to find out memory holes, instead
   of walking over TDX memory blocks and explicitly check whether a hole
   is subregion of CMR.  (Chao)
 - Mention any constant macro definitions in global metadata structures
   are TDX architectural. (Binbin)
 - Slightly improve the changelog.


---
 arch/x86/virt/vmx/tdx/tdx.c | 103 ++++++++++++++++++++++++++++++------
 arch/x86/virt/vmx/tdx/tdx.h |  12 +++++
 2 files changed, 99 insertions(+), 16 deletions(-)

diff --git a/arch/x86/virt/vmx/tdx/tdx.c b/arch/x86/virt/vmx/tdx/tdx.c
index cd8cca5139ac..aac13c3c10f5 100644
--- a/arch/x86/virt/vmx/tdx/tdx.c
+++ b/arch/x86/virt/vmx/tdx/tdx.c
@@ -332,6 +332,58 @@ static int get_tdx_sys_info_version(struct tdx_sys_info_version *sysinfo_version
 	return ret;
 }
 
+/* Update the @sysinfo_cmr->num_cmrs to trim tail empty CMRs */
+static void trim_empty_tail_cmrs(struct tdx_sys_info_cmr *sysinfo_cmr)
+{
+	int i;
+
+	/*
+	 * The TDX module may report the maximum number of CMRs that
+	 * TDX architecturally supports as the actual number of CMRs,
+	 * despite the latter is smaller.  In this case all the tail
+	 * CMRs will be empty.  Trim them away.
+	 *
+	 * Note MCHECK verifies CMRs before enabling TDX on hardware.
+	 * Skip other sanity checks (e.g., verify CMR is 4KB aligned)
+	 * but trust MCHECK to work properly.  CMRs are printed later
+	 * anyway, and the worst case is module fails to initialize.
+	 */
+	for (i = 0; i < sysinfo_cmr->num_cmrs; i++)
+		if (!sysinfo_cmr->cmr_size[i])
+			break;
+
+	sysinfo_cmr->num_cmrs = i;
+}
+
+static int get_tdx_sys_info_cmr(struct tdx_sys_info_cmr *sysinfo_cmr)
+{
+	int ret = 0;
+	u16 i;
+
+#define READ_SYS_INFO(_field_id, _member, _size)			\
+	ret = ret ?: read_sys_metadata_field(MD_FIELD_ID_##_field_id,	\
+					&sysinfo_cmr->_member, _size)
+
+	READ_SYS_INFO(NUM_CMRS, num_cmrs, 16);
+
+	if (ret)
+		return ret;
+
+	for (i = 0; i < sysinfo_cmr->num_cmrs; i++) {
+		READ_SYS_INFO(CMR_BASE + i, cmr_base[i], 64);
+		READ_SYS_INFO(CMR_SIZE + i, cmr_size[i], 64);
+	}
+
+	if (ret)
+		return ret;
+
+	trim_empty_tail_cmrs(sysinfo_cmr);
+
+#undef READ_SYS_INFO
+
+	return 0;
+}
+
 static int get_tdx_sys_info_tdmr(struct tdx_sys_info_tdmr *sysinfo_tdmr)
 {
 	int ret = 0;
@@ -363,6 +415,10 @@ static int get_tdx_sys_info(struct tdx_sys_info *sysinfo)
 	if (ret)
 		return ret;
 
+	ret = get_tdx_sys_info_cmr(&sysinfo->cmr);
+	if (ret)
+		return ret;
+
 	return get_tdx_sys_info_tdmr(&sysinfo->tdmr);
 }
 
@@ -383,9 +439,23 @@ static void print_sys_info_version(struct tdx_sys_info_version *version)
 			version->build_date);
 }
 
+static void print_sys_info_cmr(struct tdx_sys_info_cmr *sysinfo_cmr)
+{
+	int i;
+
+	for (i = 0; i < sysinfo_cmr->num_cmrs; i++) {
+		u64 cmr_base = sysinfo_cmr->cmr_base[i];
+		u64 cmr_size = sysinfo_cmr->cmr_size[i];
+
+		pr_info("CMR[%d]: [0x%llx, 0x%llx)\n", i, cmr_base,
+				cmr_base + cmr_size);
+	}
+}
+
 static void print_basic_sys_info(struct tdx_sys_info *sysinfo)
 {
 	print_sys_info_version(&sysinfo->version);
+	print_sys_info_cmr(&sysinfo->cmr);
 }
 
 static int check_features(struct tdx_sys_info *sysinfo)
@@ -821,29 +891,28 @@ static int tdmr_add_rsvd_area(struct tdmr_info *tdmr, int *p_idx, u64 addr,
 }
 
 /*
- * Go through @tmb_list to find holes between memory areas.  If any of
+ * Go through all CMRs in @sysinfo_cmr to find memory holes.  If any of
  * those holes fall within @tdmr, set up a TDMR reserved area to cover
  * the hole.
  */
-static int tdmr_populate_rsvd_holes(struct list_head *tmb_list,
+static int tdmr_populate_rsvd_holes(struct tdx_sys_info_cmr *sysinfo_cmr,
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
+	for (i = 0; i < sysinfo_cmr->num_cmrs; i++) {
 		u64 start, end;
 
-		start = PFN_PHYS(tmb->start_pfn);
-		end   = PFN_PHYS(tmb->end_pfn);
+		start = sysinfo_cmr->cmr_base[i];
+		end   = start + sysinfo_cmr->cmr_size[i];
 
 		/* Break if this region is after the TDMR */
 		if (start >= tdmr_end(tdmr))
@@ -944,16 +1013,16 @@ static int rsvd_area_cmp_func(const void *a, const void *b)
 
 /*
  * Populate reserved areas for the given @tdmr, including memory holes
- * (via @tmb_list) and PAMTs (via @tdmr_list).
+ * (via @sysinfo_cmr) and PAMTs (via @tdmr_list).
  */
 static int tdmr_populate_rsvd_areas(struct tdmr_info *tdmr,
-				    struct list_head *tmb_list,
+				    struct tdx_sys_info_cmr *sysinfo_cmr,
 				    struct tdmr_info_list *tdmr_list,
 				    u16 max_reserved_per_tdmr)
 {
 	int ret, rsvd_idx = 0;
 
-	ret = tdmr_populate_rsvd_holes(tmb_list, tdmr, &rsvd_idx,
+	ret = tdmr_populate_rsvd_holes(sysinfo_cmr, tdmr, &rsvd_idx,
 			max_reserved_per_tdmr);
 	if (ret)
 		return ret;
@@ -972,10 +1041,10 @@ static int tdmr_populate_rsvd_areas(struct tdmr_info *tdmr,
 
 /*
  * Populate reserved areas for all TDMRs in @tdmr_list, including memory
- * holes (via @tmb_list) and PAMTs.
+ * holes (via @sysinfo_cmr) and PAMTs.
  */
 static int tdmrs_populate_rsvd_areas_all(struct tdmr_info_list *tdmr_list,
-					 struct list_head *tmb_list,
+					 struct tdx_sys_info_cmr *sysinfo_cmr,
 					 u16 max_reserved_per_tdmr)
 {
 	int i;
@@ -984,7 +1053,7 @@ static int tdmrs_populate_rsvd_areas_all(struct tdmr_info_list *tdmr_list,
 		int ret;
 
 		ret = tdmr_populate_rsvd_areas(tdmr_entry(tdmr_list, i),
-				tmb_list, tdmr_list, max_reserved_per_tdmr);
+				sysinfo_cmr, tdmr_list, max_reserved_per_tdmr);
 		if (ret)
 			return ret;
 	}
@@ -999,7 +1068,8 @@ static int tdmrs_populate_rsvd_areas_all(struct tdmr_info_list *tdmr_list,
  */
 static int construct_tdmrs(struct list_head *tmb_list,
 			   struct tdmr_info_list *tdmr_list,
-			   struct tdx_sys_info_tdmr *sysinfo_tdmr)
+			   struct tdx_sys_info_tdmr *sysinfo_tdmr,
+			   struct tdx_sys_info_cmr *sysinfo_cmr)
 {
 	int ret;
 
@@ -1012,7 +1082,7 @@ static int construct_tdmrs(struct list_head *tmb_list,
 	if (ret)
 		return ret;
 
-	ret = tdmrs_populate_rsvd_areas_all(tdmr_list, tmb_list,
+	ret = tdmrs_populate_rsvd_areas_all(tdmr_list, sysinfo_cmr,
 			sysinfo_tdmr->max_reserved_per_tdmr);
 	if (ret)
 		tdmrs_free_pamt_all(tdmr_list);
@@ -1208,7 +1278,8 @@ static int init_tdx_module(void)
 		goto err_free_tdxmem;
 
 	/* Cover all TDX-usable memory regions in TDMRs */
-	ret = construct_tdmrs(&tdx_memlist, &tdx_tdmr_list, &sysinfo.tdmr);
+	ret = construct_tdmrs(&tdx_memlist, &tdx_tdmr_list, &sysinfo.tdmr,
+			&sysinfo.cmr);
 	if (ret)
 		goto err_free_tdmrs;
 
diff --git a/arch/x86/virt/vmx/tdx/tdx.h b/arch/x86/virt/vmx/tdx/tdx.h
index 9314f6ecbcb5..b933abefe8b4 100644
--- a/arch/x86/virt/vmx/tdx/tdx.h
+++ b/arch/x86/virt/vmx/tdx/tdx.h
@@ -43,6 +43,9 @@
 #define MD_FIELD_ID_PAMT_4K_ENTRY_SIZE		0x9100000100000010ULL
 #define MD_FIELD_ID_PAMT_2M_ENTRY_SIZE		0x9100000100000011ULL
 #define MD_FIELD_ID_PAMT_1G_ENTRY_SIZE		0x9100000100000012ULL
+#define MD_FIELD_ID_NUM_CMRS			0x9000000100000000ULL
+#define MD_FIELD_ID_CMR_BASE			0x9000000300000080ULL
+#define MD_FIELD_ID_CMR_SIZE			0x9000000300000100ULL
 
 /*
  * Sub-field definition of metadata field ID.
@@ -131,6 +134,14 @@ struct tdx_sys_info_version {
 	u32 build_date;
 };
 
+/* Class "CMR Info" */
+#define TDX_MAX_CMRS	32
+struct tdx_sys_info_cmr {
+	u16 num_cmrs;
+	u64 cmr_base[TDX_MAX_CMRS];
+	u64 cmr_size[TDX_MAX_CMRS];
+};
+
 /* Class "TDMR info" */
 struct tdx_sys_info_tdmr {
 	u16 max_tdmrs;
@@ -141,6 +152,7 @@ struct tdx_sys_info_tdmr {
 struct tdx_sys_info {
 	struct tdx_sys_info_features	features;
 	struct tdx_sys_info_version	version;
+	struct tdx_sys_info_cmr		cmr;
 	struct tdx_sys_info_tdmr	tdmr;
 };
 
-- 
2.46.0


