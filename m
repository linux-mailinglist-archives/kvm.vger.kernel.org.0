Return-Path: <kvm+bounces-64036-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sin.lore.kernel.org (sin.lore.kernel.org [IPv6:2600:3c15:e001:75::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 529E4C76D2E
	for <lists+kvm@lfdr.de>; Fri, 21 Nov 2025 01:57:20 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sin.lore.kernel.org (Postfix) with ESMTPS id 216CD2EFCA
	for <lists+kvm@lfdr.de>; Fri, 21 Nov 2025 00:54:21 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B38542BE7C3;
	Fri, 21 Nov 2025 00:51:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Z85ZAgN6"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9CDDD288CA6;
	Fri, 21 Nov 2025 00:51:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.19
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763686309; cv=none; b=kQoYNXrzkQZDhrU9X9Q9cFNAJKkmHaUmchr58hwXbEWYY4dsFhtiE+0jRjeaf9zrR6wgP+WI4dk6pF2McpZJlvax3/oMQVU+WqMU59ZqDyZdDHK1YbMJyNFY4mXNRVvFU2NE5KhzxtusbWnPmwKAVvfDm7/tZ+NYhZLEnf1mlxQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763686309; c=relaxed/simple;
	bh=79xQkIJuz06sItl6ATwysWTQBqW/BysewDEEWdMSceY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=I2DQ1GUbntLefk909QsRhFPwMVXhaqvd07lNIV2qhbMX+ImL3NEL4nO1OW4NeGR/KnZJn77OYrmB19KuPHSxk95gtlXlms/YTHvNf0CYF2w3FMhFsZ9D2XsbzlgDnpVdbMT8gFaSSH1R6OLK7lh3GkmVy48+C7+YVV1Oboidq9M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=Z85ZAgN6; arc=none smtp.client-ip=192.198.163.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1763686308; x=1795222308;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=79xQkIJuz06sItl6ATwysWTQBqW/BysewDEEWdMSceY=;
  b=Z85ZAgN6BGIaF8G/6xFGHIoLbsMOlUGfNEXUrwQQ1NNRJGlSzcaU/XFm
   Q2m+6ACHs8y85ClPHuv3FMyzq7pTKCqhR3cG1rPnxFVEUogspyRiPs6SO
   wxqx/nneqtBKc1uQJX2MEjOeOlLeeQjzskA0ycsm7eLp+Sc55tFWpsLk5
   W8Po3qLC5Y35rAQCpaBAFLl6pZNWyMjwPyEDa9yruXFnUy2l5jwocBFT2
   NR5P430+tn/GK75PHhhSak/+TEzqql15TFIxdl/LnEteHbeWeyW2yfZnx
   +BmyFDcmzrHEPY2IIiG3me/lkGRaU2UZ+cRNOOOt2ec0oj+GUYNu7k7Pf
   A==;
X-CSE-ConnectionGUID: BOtW5N9MROO0gSTj2jPv5Q==
X-CSE-MsgGUID: kUmjsnhVTjSLjuuzW72X3g==
X-IronPort-AV: E=McAfee;i="6800,10657,11619"; a="64780781"
X-IronPort-AV: E=Sophos;i="6.20,214,1758610800"; 
   d="scan'208";a="64780781"
Received: from fmviesa003.fm.intel.com ([10.60.135.143])
  by fmvoesa113.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Nov 2025 16:51:45 -0800
X-CSE-ConnectionGUID: txT64Tm1RaeYpmlW8nPJVw==
X-CSE-MsgGUID: qowO2VGTSFOMloQ1+2t+QA==
X-ExtLoop1: 1
Received: from rpedgeco-desk.jf.intel.com ([10.88.27.139])
  by fmviesa003-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Nov 2025 16:51:44 -0800
From: Rick Edgecombe <rick.p.edgecombe@intel.com>
To: bp@alien8.de,
	chao.gao@intel.com,
	dave.hansen@intel.com,
	isaku.yamahata@intel.com,
	kai.huang@intel.com,
	kas@kernel.org,
	kvm@vger.kernel.org,
	linux-coco@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	mingo@redhat.com,
	pbonzini@redhat.com,
	seanjc@google.com,
	tglx@linutronix.de,
	vannapurve@google.com,
	x86@kernel.org,
	yan.y.zhao@intel.com,
	xiaoyao.li@intel.com,
	binbin.wu@intel.com
Cc: rick.p.edgecombe@intel.com,
	"Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Subject: [PATCH v4 09/16] KVM: TDX: Allocate PAMT memory for TD control structures
Date: Thu, 20 Nov 2025 16:51:18 -0800
Message-ID: <20251121005125.417831-10-rick.p.edgecombe@intel.com>
X-Mailer: git-send-email 2.51.2
In-Reply-To: <20251121005125.417831-1-rick.p.edgecombe@intel.com>
References: <20251121005125.417831-1-rick.p.edgecombe@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>

TDX TD control structures are provided to the TDX module at 4KB page size
and require PAMT backing. This means for Dynamic PAMT they need to also
have 4KB backings installed.

Previous changes introduced tdx_alloc_page()/tdx_free_page() that can
allocate a page and automatically handle the DPAMT maintenance. Use them
for vCPU control structures instead of alloc_page()/__free_page().

Signed-off-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
[update log]
Signed-off-by: Rick Edgecombe <rick.p.edgecombe@intel.com>
---
v3:
 - Write log. Rename from “KVM: TDX: Allocate PAMT memory in __tdx_td_init()”
---
 arch/x86/kvm/vmx/tdx.c | 16 ++++++----------
 1 file changed, 6 insertions(+), 10 deletions(-)

diff --git a/arch/x86/kvm/vmx/tdx.c b/arch/x86/kvm/vmx/tdx.c
index 0eed334176b3..8c4c1221e311 100644
--- a/arch/x86/kvm/vmx/tdx.c
+++ b/arch/x86/kvm/vmx/tdx.c
@@ -2398,7 +2398,7 @@ static int __tdx_td_init(struct kvm *kvm, struct td_params *td_params,
 
 	atomic_inc(&nr_configured_hkid);
 
-	tdr_page = alloc_page(GFP_KERNEL);
+	tdr_page = tdx_alloc_page();
 	if (!tdr_page)
 		goto free_hkid;
 
@@ -2411,7 +2411,7 @@ static int __tdx_td_init(struct kvm *kvm, struct td_params *td_params,
 		goto free_tdr;
 
 	for (i = 0; i < kvm_tdx->td.tdcs_nr_pages; i++) {
-		tdcs_pages[i] = alloc_page(GFP_KERNEL);
+		tdcs_pages[i] = tdx_alloc_page();
 		if (!tdcs_pages[i])
 			goto free_tdcs;
 	}
@@ -2529,10 +2529,8 @@ static int __tdx_td_init(struct kvm *kvm, struct td_params *td_params,
 teardown:
 	/* Only free pages not yet added, so start at 'i' */
 	for (; i < kvm_tdx->td.tdcs_nr_pages; i++) {
-		if (tdcs_pages[i]) {
-			__free_page(tdcs_pages[i]);
-			tdcs_pages[i] = NULL;
-		}
+		tdx_free_page(tdcs_pages[i]);
+		tdcs_pages[i] = NULL;
 	}
 	if (!kvm_tdx->td.tdcs_pages)
 		kfree(tdcs_pages);
@@ -2548,15 +2546,13 @@ static int __tdx_td_init(struct kvm *kvm, struct td_params *td_params,
 
 free_tdcs:
 	for (i = 0; i < kvm_tdx->td.tdcs_nr_pages; i++) {
-		if (tdcs_pages[i])
-			__free_page(tdcs_pages[i]);
+		tdx_free_page(tdcs_pages[i]);
 	}
 	kfree(tdcs_pages);
 	kvm_tdx->td.tdcs_pages = NULL;
 
 free_tdr:
-	if (tdr_page)
-		__free_page(tdr_page);
+	tdx_free_page(tdr_page);
 	kvm_tdx->td.tdr_page = NULL;
 
 free_hkid:
-- 
2.51.2


