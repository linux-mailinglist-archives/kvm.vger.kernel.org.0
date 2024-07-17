Return-Path: <kvm+bounces-21756-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 5A0929335C3
	for <lists+kvm@lfdr.de>; Wed, 17 Jul 2024 05:43:41 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 102BD1F21739
	for <lists+kvm@lfdr.de>; Wed, 17 Jul 2024 03:43:41 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0CC1D33985;
	Wed, 17 Jul 2024 03:41:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="TG0v/cqH"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A6861FBEA;
	Wed, 17 Jul 2024 03:41:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.19
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721187680; cv=none; b=dEDVjns6DSKwc+xMKQkhpVJb4sclG/vm1tX7eh6GmWCenzNSaNXv2G3sQBoE2oQyQPUlWW8Ci5WmV3yQOdI9X/WIH+U2SA5UH3AXslhKkjCyOKqp8eCZ1ZW/WA4voswyIGzcPAZeED+rft7OvGxXXPFd3IJOC3qp4btINQogea4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721187680; c=relaxed/simple;
	bh=7hG+uRTOF5VT/BVJAB9g4uCVmdMHl/IaV9iSHLeVdZg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uQFZAO+G0nBHClkxlBGHstL5BGdMOQEX4kumWGKu+6jLwiJQlFhLzM2YLaw+c8Atf8q4vN+bndFNp7V0ZNgsTDlzxpRlTzpw5B8ALEQ+PUcAcdDY9x77ViGZ25n6vCse9jy6XcGcaOA5c2hU8oXF7MewDmijFx+uGaptfjF688o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=TG0v/cqH; arc=none smtp.client-ip=198.175.65.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1721187679; x=1752723679;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=7hG+uRTOF5VT/BVJAB9g4uCVmdMHl/IaV9iSHLeVdZg=;
  b=TG0v/cqHkZrnzqWfgS8cLghcYQcNk/X6ya4enai8xusOOV7d6JzDfDk6
   QMBIlrGAhoxHcm0RFjfFvv3n6Ksdcn7K26WszY4/2DuxN+DZ5N5k2na94
   97hLx+MFWM1t4cZf8fa3RB3z/9QQr+yJmjRFUG8tMyR4fSRQSVX8QlO77
   IYjsHsnMhqYhB4QgsS/WFnK80sCCNS1frllHSAiSHx2s1AiLHLpS8j7Lk
   dn2ziX6RD7dMK9Uzvmff4TZZ5nIPnC9UJACYkubWWnJkOt7VOaGzC8LIt
   sO1MrLSpTHeND7WwmftZLAIc1EQ3mkRCxaDwW4PUWlQ7NAp2whsNfm05F
   w==;
X-CSE-ConnectionGUID: W0kGoxpVQLukTfiJe5L70g==
X-CSE-MsgGUID: viLFhnx9TzS7eFCL26bAGA==
X-IronPort-AV: E=McAfee;i="6700,10204,11135"; a="18512479"
X-IronPort-AV: E=Sophos;i="6.09,213,1716274800"; 
   d="scan'208";a="18512479"
Received: from fmviesa005.fm.intel.com ([10.60.135.145])
  by orvoesa111.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Jul 2024 20:41:16 -0700
X-CSE-ConnectionGUID: Jv6nFXSATyGC2o0DgcuVkg==
X-CSE-MsgGUID: KNQmO0T+QQiYyCRPqZew1Q==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.09,213,1716274800"; 
   d="scan'208";a="54566771"
Received: from rfrazer-mobl3.amr.corp.intel.com (HELO khuang2-desk.gar.corp.intel.com) ([10.124.222.184])
  by fmviesa005-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Jul 2024 20:41:10 -0700
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
Subject: [PATCH v2 10/10] x86/virt/tdx: Don't initialize module that doesn't support NO_RBP_MOD feature
Date: Wed, 17 Jul 2024 15:40:17 +1200
Message-ID: <d307d82a52ef604cfff8c7745ad8613d3ddfa0c8.1721186590.git.kai.huang@intel.com>
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

Old TDX modules can clobber RBP in the TDH.VP.ENTER SEAMCALL.  However
RBP is used as frame pointer in the x86_64 calling convention, and
clobbering RBP could result in bad things like being unable to unwind
the stack if any non-maskable exceptions (NMI, #MC etc) happens in that
gap.

A new "NO_RBP_MOD" feature was introduced to more recent TDX modules to
not clobber RBP.  This feature is reported in the TDX_FEATURES0 global
metadata field via bit 18.

Don't initialize the TDX module if this feature is not supported [1].

Link: https://lore.kernel.org/all/c0067319-2653-4cbd-8fee-1ccf21b1e646@suse.com/T/#mef98469c51e2382ead2c537ea189752360bd2bef [1]
Signed-off-by: Kai Huang <kai.huang@intel.com>
Reviewed-by: Nikolay Borisov <nik.borisov@suse.com>
---

v1 -> v2:
 - Add tag from Nikolay.

---
 arch/x86/virt/vmx/tdx/tdx.c | 17 +++++++++++++++++
 arch/x86/virt/vmx/tdx/tdx.h |  1 +
 2 files changed, 18 insertions(+)

diff --git a/arch/x86/virt/vmx/tdx/tdx.c b/arch/x86/virt/vmx/tdx/tdx.c
index 3c19295f1f8f..ec6156728423 100644
--- a/arch/x86/virt/vmx/tdx/tdx.c
+++ b/arch/x86/virt/vmx/tdx/tdx.c
@@ -484,6 +484,18 @@ static int get_tdx_sysinfo(struct tdx_sysinfo *sysinfo)
 	return get_tdx_tdmr_sysinfo(&sysinfo->tdmr_info);
 }
 
+static int check_module_compatibility(struct tdx_sysinfo *sysinfo)
+{
+	u64 tdx_features0 = sysinfo->module_info.tdx_features0;
+
+	if (!(tdx_features0 & TDX_FEATURES0_NO_RBP_MOD)) {
+		pr_err("NO_RBP_MOD feature is not supported\n");
+		return -EINVAL;
+	}
+
+	return 0;
+}
+
 /* Calculate the actual TDMR size */
 static int tdmr_size_single(u16 max_reserved_per_tdmr)
 {
@@ -1266,6 +1278,11 @@ static int init_tdx_module(void)
 
 	print_basic_sysinfo(&sysinfo);
 
+	/* Check whether the kernel can support this module */
+	ret = check_module_compatibility(&sysinfo);
+	if (ret)
+		return ret;
+
 	/*
 	 * To keep things simple, assume that all TDX-protected memory
 	 * will come from the page allocator.  Make sure all pages in the
diff --git a/arch/x86/virt/vmx/tdx/tdx.h b/arch/x86/virt/vmx/tdx/tdx.h
index 4b43eb774ffa..20fd7cb5937a 100644
--- a/arch/x86/virt/vmx/tdx/tdx.h
+++ b/arch/x86/virt/vmx/tdx/tdx.h
@@ -148,6 +148,7 @@ struct tdx_sysinfo_module_info {
 };
 
 #define TDX_SYS_ATTR_DEBUG_MODULE	0x1
+#define TDX_FEATURES0_NO_RBP_MOD	_BITULL(18)
 
 /* Class "TDX Module Version" */
 struct tdx_sysinfo_module_version {
-- 
2.45.2


