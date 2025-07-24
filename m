Return-Path: <kvm+bounces-53364-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 4F625B10A96
	for <lists+kvm@lfdr.de>; Thu, 24 Jul 2025 14:49:25 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 274417B8C82
	for <lists+kvm@lfdr.de>; Thu, 24 Jul 2025 12:47:54 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3D3A52D63F5;
	Thu, 24 Jul 2025 12:48:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="EVQyAuYM"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.8])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 02D342D46D7;
	Thu, 24 Jul 2025 12:48:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.8
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753361321; cv=none; b=D+x/6YLMpwbPVEJDVdU/99d3JAmVhB8oxHDSEgC9smylCu8h9CEsAhMVUN3+E+IuihTwd3GAJahjH9VVCu93YQbudrLBfgKmiB90CK2eEeCqeLd8N9XIE/MHpphAxxG1jpL2Y/Xz2AByD2cL8zG09pzEBHAShUQ75jKxH7UbLCM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753361321; c=relaxed/simple;
	bh=2KC2OqEE/dclPdbLUMqQybjRHpzAD8giJl/QxPHD7HQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gY7vQzCa0/lWpY9alAD9npSYECMXMORGBqMxBQWS2TEIWc+uHRceAdrt39ykG670d4JDbqs7eImihGdzpg1Gjh3b8bgTt1kZ7ABOmoHl6Qf5lnAWo+Q7ePqL06iG5gXjKb8OiVk9zYafgVhqJ6OnbX8haWI/Kdf6N64THqKwjIA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=EVQyAuYM; arc=none smtp.client-ip=192.198.163.8
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1753361320; x=1784897320;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=2KC2OqEE/dclPdbLUMqQybjRHpzAD8giJl/QxPHD7HQ=;
  b=EVQyAuYMNrW5EaPXkWRhhe+B0FqKXaDzZUN6s6CB8u3oEPEq3LtBywEs
   rL58d1cmmUZObxd5wEHib38bjkIWYK27pwU4ltZ5BM1lVUCqJsCeVElnA
   Muh4t9t5Gx+OTmEMdU8FGW9JaHCUHoOEnGzCKBLHOBXF9B80p8K91mz/Q
   LKSQVVdQlrcZZ9/byfRQwF0EmDEWgvcI+W8rSaB/R8MacTxOBnEvMawjW
   Mpdb/Wm1pKFMpAHnCeF2jhmWcc0EtYqcVOX2Xe7M+pXWh5VyiuFm3g1Zl
   74U5oIykyJN14smpgcgouvCPmHC6ntZWkm/lDPcTTy0aFo8uW4Ng8ai6F
   g==;
X-CSE-ConnectionGUID: IHYBPXyPQVechtfI94YO1w==
X-CSE-MsgGUID: sNrzlIkXSJSuEPIIVdmCyA==
X-IronPort-AV: E=McAfee;i="6800,10657,11501"; a="73253611"
X-IronPort-AV: E=Sophos;i="6.16,337,1744095600"; 
   d="scan'208";a="73253611"
Received: from orviesa006.jf.intel.com ([10.64.159.146])
  by fmvoesa102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Jul 2025 05:48:40 -0700
X-CSE-ConnectionGUID: a51jSHiFQK+wF2yFslXFHw==
X-CSE-MsgGUID: dK017B30SIqBkoHXrDFILQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.16,337,1744095600"; 
   d="scan'208";a="159460420"
Received: from sschumil-mobl2.ger.corp.intel.com (HELO localhost.localdomain) ([10.245.244.21])
  by orviesa006-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Jul 2025 05:48:35 -0700
From: Adrian Hunter <adrian.hunter@intel.com>
To: Dave Hansen <dave.hansen@linux.intel.com>,
	pbonzini@redhat.com,
	seanjc@google.com,
	vannapurve@google.com
Cc: Tony Luck <tony.luck@intel.com>,
	Borislav Petkov <bp@alien8.de>,
	Thomas Gleixner <tglx@linutronix.de>,
	Ingo Molnar <mingo@redhat.com>,
	x86@kernel.org,
	H Peter Anvin <hpa@zytor.com>,
	linux-kernel@vger.kernel.org,
	kvm@vger.kernel.org,
	rick.p.edgecombe@intel.com,
	kas@kernel.org,
	kai.huang@intel.com,
	reinette.chatre@intel.com,
	xiaoyao.li@intel.com,
	tony.lindgren@linux.intel.com,
	binbin.wu@linux.intel.com,
	isaku.yamahata@intel.com,
	yan.y.zhao@intel.com,
	chao.gao@intel.com
Subject: [PATCH V5 2/3] x86/tdx: Tidy reset_pamt functions
Date: Thu, 24 Jul 2025 15:48:10 +0300
Message-ID: <20250724124811.78326-3-adrian.hunter@intel.com>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250724124811.78326-1-adrian.hunter@intel.com>
References: <20250724124811.78326-1-adrian.hunter@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Organization: Intel Finland Oy, Registered Address: c/o Alberga Business Park, 6 krs, Bertel Jungin Aukio 5, 02600 Espoo, Business Identity Code: 0357606 - 4, Domiciled in Helsinki
Content-Transfer-Encoding: 8bit

tdx_quirk_reset_paddr() was renamed to reflect that, in fact, the clearing
is necessary only for hardware with a certain quirk.  That is dealt with in
a subsequent patch.

Rename reset_pamt functions to contain "quirk" to reflect the new
functionality, and remove the now misleading comment.

Signed-off-by: Adrian Hunter <adrian.hunter@intel.com>
---


Changes in V5:

	New patch


 arch/x86/virt/vmx/tdx/tdx.c | 16 ++++------------
 1 file changed, 4 insertions(+), 12 deletions(-)

diff --git a/arch/x86/virt/vmx/tdx/tdx.c b/arch/x86/virt/vmx/tdx/tdx.c
index fc8d8e444f15..9e4638f68ba0 100644
--- a/arch/x86/virt/vmx/tdx/tdx.c
+++ b/arch/x86/virt/vmx/tdx/tdx.c
@@ -660,17 +660,17 @@ void tdx_quirk_reset_page(struct page *page)
 }
 EXPORT_SYMBOL_GPL(tdx_quirk_reset_page);
 
-static void tdmr_reset_pamt(struct tdmr_info *tdmr)
+static void tdmr_quirk_reset_pamt(struct tdmr_info *tdmr)
 {
 	tdmr_do_pamt_func(tdmr, tdx_quirk_reset_paddr);
 }
 
-static void tdmrs_reset_pamt_all(struct tdmr_info_list *tdmr_list)
+static void tdmrs_quirk_reset_pamt_all(struct tdmr_info_list *tdmr_list)
 {
 	int i;
 
 	for (i = 0; i < tdmr_list->nr_consumed_tdmrs; i++)
-		tdmr_reset_pamt(tdmr_entry(tdmr_list, i));
+		tdmr_quirk_reset_pamt(tdmr_entry(tdmr_list, i));
 }
 
 static unsigned long tdmrs_count_pamt_kb(struct tdmr_info_list *tdmr_list)
@@ -1142,15 +1142,7 @@ static int init_tdx_module(void)
 	 * to the kernel.
 	 */
 	wbinvd_on_all_cpus();
-	/*
-	 * According to the TDX hardware spec, if the platform
-	 * doesn't have the "partial write machine check"
-	 * erratum, any kernel read/write will never cause #MC
-	 * in kernel space, thus it's OK to not convert PAMTs
-	 * back to normal.  But do the conversion anyway here
-	 * as suggested by the TDX spec.
-	 */
-	tdmrs_reset_pamt_all(&tdx_tdmr_list);
+	tdmrs_quirk_reset_pamt_all(&tdx_tdmr_list);
 err_free_pamts:
 	tdmrs_free_pamt_all(&tdx_tdmr_list);
 err_free_tdmrs:
-- 
2.48.1


