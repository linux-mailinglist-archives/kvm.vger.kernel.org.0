Return-Path: <kvm+bounces-29845-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id A66089B309E
	for <lists+kvm@lfdr.de>; Mon, 28 Oct 2024 13:44:19 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id AD4631C21B7A
	for <lists+kvm@lfdr.de>; Mon, 28 Oct 2024 12:44:18 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DB6B71DE2C9;
	Mon, 28 Oct 2024 12:42:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="emMVgtHT"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.13])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9B9B51DD88F;
	Mon, 28 Oct 2024 12:41:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.13
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730119321; cv=none; b=NQxSxY4HHgxqqjXVwflPHUTwlU+70SwRjEFGGfnIasFGU1LAgIr02H8WGhWJmkQu98PxTLZcjzTB15Fo3Og7AkFFFwXwLXeCSMHF3lXr+2iYFWnZr3xuX5FNIbIZWVrTs869gU0vAwAnIna2z0tAtZfmbj977znFsA4ZHuBZD0M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730119321; c=relaxed/simple;
	bh=hfzixhlFvX2/oRSbHXeYOUlbsEzot5XO1Fc5YbXmcWc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=EuWAdCDL60fqVwq1fKERQuqamAwm9dfXIYEmoF48IRV/kK6gTpdQa4sbjLh6qoGJFlQCjRyNdhBzpVXzEmwVPERDCnubQ5RRUiTM9+O1C2QD+VeBFjbBMCT18fOPXAoU+Qcg90dneTXOzOK6P4GHPUl0j+1rQesOkryYX7X2rkY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=emMVgtHT; arc=none smtp.client-ip=192.198.163.13
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1730119319; x=1761655319;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=hfzixhlFvX2/oRSbHXeYOUlbsEzot5XO1Fc5YbXmcWc=;
  b=emMVgtHT+M0kAtyAGFL4yeJMzz6AkCsM4SGM+/T8ecNecZ/4ZwN7z+Qz
   M9ijrgE9d58IA7APcvd8bssL6TNwyQ/4EcCKTSp+xsOYAj6ObjBwD8Q/J
   UxaTGL69OoYp5kUG7lnX+3OalR0tW5CXakddSMZMxO8UKiwy2gCr8+NUd
   O7qb1nLuPIg7jm32oVoxm5vZ+Kc+kpODkBSjH7hZ1A/Uqt/osuWMTt0w5
   o7h98lvIzjMG6sABkEseEzse6XF/CLi8wxw34z2Jc7E9Aa4GtOTcaOSuj
   Ti4bafwhdfqSp78X6nBTP8Tn5NtJH1kZANWBouPcr9hVv5YEseDAyIrwa
   g==;
X-CSE-ConnectionGUID: LSgzI9JZQG2uSCbhhul6Eg==
X-CSE-MsgGUID: xAk64FWqTcO8KeOSKLbI2A==
X-IronPort-AV: E=McAfee;i="6700,10204,11238"; a="32575322"
X-IronPort-AV: E=Sophos;i="6.11,239,1725346800"; 
   d="scan'208";a="32575322"
Received: from orviesa008.jf.intel.com ([10.64.159.148])
  by fmvoesa107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Oct 2024 05:41:58 -0700
X-CSE-ConnectionGUID: gHELiwkPRIOilX9WpSfz0Q==
X-CSE-MsgGUID: sJZ1MIo9R/GOACDOJBPv7Q==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.11,239,1725346800"; 
   d="scan'208";a="82420943"
Received: from gargmani-mobl1.amr.corp.intel.com (HELO khuang2-desk.gar.corp.intel.com) ([10.124.222.169])
  by orviesa008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Oct 2024 05:41:54 -0700
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
Subject: [PATCH v6 08/10] x86/virt/tdx: Reduce TDMR's reserved areas by using CMRs to find memory holes
Date: Tue, 29 Oct 2024 01:41:10 +1300
Message-ID: <b152bd39f9b235d5b20b8579a058a7f2bdbc111d.1730118186.git.kai.huang@intel.com>
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

A TDX module initialization failure was reported on a Emerald Rapids
platform [*]:

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

Link: https://github.com/canonical/tdx/issues/135 [*]
Fixes: dde3b60d572c ("x86/virt/tdx: Designate reserved areas for all TDMRs")
Signed-off-by: Kai Huang <kai.huang@intel.com>
---
 arch/x86/virt/vmx/tdx/tdx.c | 33 +++++++++++++++++----------------
 1 file changed, 17 insertions(+), 16 deletions(-)

diff --git a/arch/x86/virt/vmx/tdx/tdx.c b/arch/x86/virt/vmx/tdx/tdx.c
index e81bdcfc20bf..9acb12c75e9b 100644
--- a/arch/x86/virt/vmx/tdx/tdx.c
+++ b/arch/x86/virt/vmx/tdx/tdx.c
@@ -747,29 +747,28 @@ static int tdmr_add_rsvd_area(struct tdmr_info *tdmr, int *p_idx, u64 addr,
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
@@ -870,16 +869,16 @@ static int rsvd_area_cmp_func(const void *a, const void *b)
 
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
@@ -898,10 +897,10 @@ static int tdmr_populate_rsvd_areas(struct tdmr_info *tdmr,
 
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
@@ -910,7 +909,7 @@ static int tdmrs_populate_rsvd_areas_all(struct tdmr_info_list *tdmr_list,
 		int ret;
 
 		ret = tdmr_populate_rsvd_areas(tdmr_entry(tdmr_list, i),
-				tmb_list, tdmr_list, max_reserved_per_tdmr);
+				sysinfo_cmr, tdmr_list, max_reserved_per_tdmr);
 		if (ret)
 			return ret;
 	}
@@ -925,7 +924,8 @@ static int tdmrs_populate_rsvd_areas_all(struct tdmr_info_list *tdmr_list,
  */
 static int construct_tdmrs(struct list_head *tmb_list,
 			   struct tdmr_info_list *tdmr_list,
-			   struct tdx_sys_info_tdmr *sysinfo_tdmr)
+			   struct tdx_sys_info_tdmr *sysinfo_tdmr,
+			   struct tdx_sys_info_cmr *sysinfo_cmr)
 {
 	u16 pamt_entry_size[TDX_PS_NR] = {
 		sysinfo_tdmr->pamt_4k_entry_size,
@@ -942,7 +942,7 @@ static int construct_tdmrs(struct list_head *tmb_list,
 	if (ret)
 		return ret;
 
-	ret = tdmrs_populate_rsvd_areas_all(tdmr_list, tmb_list,
+	ret = tdmrs_populate_rsvd_areas_all(tdmr_list, sysinfo_cmr,
 			sysinfo_tdmr->max_reserved_per_tdmr);
 	if (ret)
 		tdmrs_free_pamt_all(tdmr_list);
@@ -1131,7 +1131,8 @@ static int init_tdx_module(void)
 		goto err_free_tdxmem;
 
 	/* Cover all TDX-usable memory regions in TDMRs */
-	ret = construct_tdmrs(&tdx_memlist, &tdx_tdmr_list, &sysinfo.tdmr);
+	ret = construct_tdmrs(&tdx_memlist, &tdx_tdmr_list, &sysinfo.tdmr,
+			&sysinfo.cmr);
 	if (ret)
 		goto err_free_tdmrs;
 
-- 
2.46.2


