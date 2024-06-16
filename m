Return-Path: <kvm+bounces-19746-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 5F7A7909D3F
	for <lists+kvm@lfdr.de>; Sun, 16 Jun 2024 14:04:58 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id ED59F28168C
	for <lists+kvm@lfdr.de>; Sun, 16 Jun 2024 12:04:56 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 05CFD19046C;
	Sun, 16 Jun 2024 12:02:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="XSIZFUvf"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AFC6F19006B;
	Sun, 16 Jun 2024 12:02:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.12
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718539338; cv=none; b=mHW6M7yaMC2mVSx2ajqhzcCMLXtvMeznDzMRA4vUnFmx6qag4kvSDaF798O8N3gDwnPP4VXr/S7hxFUhRsAKYdmNTemTXoxYIO38EHugWNTc7bC100tJXEJWkiT7mCmbDPpmYN9W4wlfYHYWxigbzcl/smGDx+3CDlHehgL8YBE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718539338; c=relaxed/simple;
	bh=qDfrc/bFBjcwqB+Q39ise3546WOanRxKZPywjkw43Y4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=r2c1F0rJaUgGg9REwYF2ZIvNbwH12c5gDlixwdZxZWPJr+dy3GgxBv1k8BunnTkYk4nULGcMLKBTX2V6+qUEp1sBKSHLU3aDUtgdijkFMr+V+1Q2bLsjKNubjxwV5T3+SIz+j8Fq7hnKsLSn9KYH8TgsuX1TeejjVuXbBe7wACI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=XSIZFUvf; arc=none smtp.client-ip=198.175.65.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1718539337; x=1750075337;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=qDfrc/bFBjcwqB+Q39ise3546WOanRxKZPywjkw43Y4=;
  b=XSIZFUvfQbap8we4dI+1VMv8ROx7xcvaa0a86LsENbJkJOFOv1ATLCOM
   ysySzNfkRfeuIudRUYeFEF+i9adqsK3QQkAVmP03kpuNdjR0MqYd4RUYZ
   vtNbx8j75W7d3E1bC3S5JvKMJzWwjqaEbEuOK128cBrAYbGtQK0FBLkoU
   ZYm09OrI5+Bnz/YFeCO2DbPndLeTKlx+4XXDxIOaiq2Wh9jJYGXx8pTRl
   W/rUlq80mR4kCyrPBvMi49gf5djlRX35eXywipy6/7QRleV0oKu/4bOB6
   tJ42rAzXrY+kGIJOquKLCo4hmfc5M7yNcfLRcM2JTNPu/6lq4ARVWZyU5
   g==;
X-CSE-ConnectionGUID: Jpz/WQenQbOC5mOKZ5cvGA==
X-CSE-MsgGUID: 1AUnDGg7S6O7WS5zConFiQ==
X-IronPort-AV: E=McAfee;i="6700,10204,11104"; a="26800097"
X-IronPort-AV: E=Sophos;i="6.08,242,1712646000"; 
   d="scan'208";a="26800097"
Received: from orviesa004.jf.intel.com ([10.64.159.144])
  by orvoesa104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Jun 2024 05:02:16 -0700
X-CSE-ConnectionGUID: bqm0L40nS6+4jgOQUsEOyQ==
X-CSE-MsgGUID: 2hbUSlBySfSRU6EBdU1Y+Q==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.08,242,1712646000"; 
   d="scan'208";a="46055987"
Received: from mgoodin-mobl2.amr.corp.intel.com (HELO khuang2-desk.gar.corp.intel.com) ([10.124.223.226])
  by orviesa004-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Jun 2024 05:02:13 -0700
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
Subject: [PATCH 9/9] x86/virt/tdx: Don't initialize module that doesn't support NO_RBP_MOD feature
Date: Mon, 17 Jun 2024 00:01:19 +1200
Message-ID: <909d809d0a37e51babfe28f88c7fd1fdefa53e88.1718538552.git.kai.huang@intel.com>
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
---
 arch/x86/virt/vmx/tdx/tdx.c | 17 +++++++++++++++++
 arch/x86/virt/vmx/tdx/tdx.h |  1 +
 2 files changed, 18 insertions(+)

diff --git a/arch/x86/virt/vmx/tdx/tdx.c b/arch/x86/virt/vmx/tdx/tdx.c
index 88a0c8b788b7..c4ff68b565e8 100644
--- a/arch/x86/virt/vmx/tdx/tdx.c
+++ b/arch/x86/virt/vmx/tdx/tdx.c
@@ -487,6 +487,18 @@ static int get_tdx_sysinfo(struct tdx_sysinfo *sysinfo)
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
@@ -1304,6 +1316,11 @@ static int init_tdx_module(void)
 
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
index be93b6f31e5b..295c3b6d9505 100644
--- a/arch/x86/virt/vmx/tdx/tdx.h
+++ b/arch/x86/virt/vmx/tdx/tdx.h
@@ -148,6 +148,7 @@ struct tdx_sysinfo_module_info {
 };
 
 #define TDX_SYS_ATTR_DEBUG_MODULE	0x1
+#define TDX_FEATURES0_NO_RBP_MOD	_BITULL(18)
 
 /* Class "TDX Module Version" */
 struct tdx_sysinfo_module_version {
-- 
2.43.2


