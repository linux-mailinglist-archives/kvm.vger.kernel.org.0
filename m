Return-Path: <kvm+bounces-53370-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id ED4D2B10AE0
	for <lists+kvm@lfdr.de>; Thu, 24 Jul 2025 15:04:59 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id A2B22AC6A80
	for <lists+kvm@lfdr.de>; Thu, 24 Jul 2025 13:04:26 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 21D932D6605;
	Thu, 24 Jul 2025 13:04:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="dwUOmfZg"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E49501FECA1;
	Thu, 24 Jul 2025 13:04:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.14
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753362264; cv=none; b=be1MrY7/dk60JWRNf5CWOUDPs1hm+bNO/MX9G8rGz1AP5e5iC8aK7HU4nI6Uk0E5pmrjtHOadS8qqDxgQLqZLP/6ZQP0y6vmJ5fT8e9NwzLeU/aVUiKrPlCrX2K6QkGwvFHiQ2YaAYbEKM0XXcBxH9Gcz5j712YexlQUPAOqV14=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753362264; c=relaxed/simple;
	bh=8GjyEObjGPm97BL6XENXBdv7Tzisq8N6S+v6q/ehmnE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BYxXhU5JuxIEE2PuUZFH4vm7U0mvfqW+9Ob8ReWVR07EF+JzDkWVh1OfJl663xIJOg4bUqwxtmRuDZ8CC/aoPPVXaxtvnGCcfVX7TLlMz6K9Jiq9Cyuwa5jguDy+4eL4lKMcYC8XkNVrFxaVF1ylO3Y8Ruvt1R3M1bAoio9g9ew=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=dwUOmfZg; arc=none smtp.client-ip=198.175.65.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1753362263; x=1784898263;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=8GjyEObjGPm97BL6XENXBdv7Tzisq8N6S+v6q/ehmnE=;
  b=dwUOmfZgh5ERO4qPwfgrnLcnTiV5dfnaTwqYFhT3NQQT3H76UaelgMr8
   +SeLGf8POLi0sg7jye9RIZG719R9HrGcnFc0/MQ/kfHMMhmuTg25tqmCn
   Z8tFOlkyYmGgQ9m6BHK4MwKi9M0tvM4TUKWFuzsQIlCdYGy+hJVfs2hhU
   qrVjEbGk+dcKX6aS/itQGlCjOy7Pxf7QV3fYBVtP3WGeLuvZyyrlI08TG
   7LlkqO6eqaeddsNAaLLEYSQjiK3gJSJazHX+jlOLDujjRiG49Ih7JLfyq
   +XsHCt/PbsqaY8ACvna0rCZ5Ojlry8XQmeO4kgLO7zX+GPGJz2JV3A6t2
   w==;
X-CSE-ConnectionGUID: tB06t2g0QAGQKS+m1HWl2w==
X-CSE-MsgGUID: a2dcepEoR36XOPFPvB3m2w==
X-IronPort-AV: E=McAfee;i="6800,10657,11501"; a="59480686"
X-IronPort-AV: E=Sophos;i="6.16,337,1744095600"; 
   d="scan'208";a="59480686"
Received: from fmviesa004.fm.intel.com ([10.60.135.144])
  by orvoesa106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Jul 2025 06:04:23 -0700
X-CSE-ConnectionGUID: W2p0ZB70Rh+fzMRB5ORY+A==
X-CSE-MsgGUID: LvqKxXESSuujafSR00n16A==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.16,337,1744095600"; 
   d="scan'208";a="165599032"
Received: from sschumil-mobl2.ger.corp.intel.com (HELO localhost.localdomain) ([10.245.244.21])
  by fmviesa004-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Jul 2025 06:04:17 -0700
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
Subject: [PATCH V6 2/3] x86/tdx: Tidy reset_pamt functions
Date: Thu, 24 Jul 2025 16:03:53 +0300
Message-ID: <20250724130354.79392-3-adrian.hunter@intel.com>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250724130354.79392-1-adrian.hunter@intel.com>
References: <20250724130354.79392-1-adrian.hunter@intel.com>
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


Changes in V6:

	None

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


