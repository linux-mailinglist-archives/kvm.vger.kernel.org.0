Return-Path: <kvm+bounces-48756-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 4BF38AD2678
	for <lists+kvm@lfdr.de>; Mon,  9 Jun 2025 21:15:09 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 0B7EB17005A
	for <lists+kvm@lfdr.de>; Mon,  9 Jun 2025 19:15:10 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5D48D221F2E;
	Mon,  9 Jun 2025 19:14:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="MpE1Cek9"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 79F60220F47;
	Mon,  9 Jun 2025 19:13:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.19
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749496441; cv=none; b=sgp9Zb/EJzC9vNYZrLe5MM1ANkShzoHgonALQ1+y3yF0rjpAChCmGPJpSJz45vaLlXegIIZ/JKQCuiUG43SJKM5RFhRE9NFWnjtWFKwLzv1tSQ5rA18QxzNHbOMeEpzjm0MFZxPQonXqZbWmgRjWfZ3AdzWU21SCSUtd5ffk/8I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749496441; c=relaxed/simple;
	bh=glNGd8+NYynrmWy1sxr86AYIXrmFKY1sbbXyi9StH7s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GoszvMG68e7qalU4xUWQtp5uwrhVabYosOdEdH/cjl6QF7GbHC0xGr2zvF9EyT9bwygAgwwzMhA3HhzREKbj/kDUzyL4x5QBbruYiAADmpNafJgHidw+QxWDaIxr5L2GVefrSEDbuxYNySWjshmT+BMhlA1l0XTBv2h1+P4ZsbI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.helo=mgamail.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=MpE1Cek9; arc=none smtp.client-ip=198.175.65.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.helo=mgamail.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1749496439; x=1781032439;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=glNGd8+NYynrmWy1sxr86AYIXrmFKY1sbbXyi9StH7s=;
  b=MpE1Cek9dyXQl4i2gAP1rzFiEi3Plqz1vwgvsTUseIKHyPeFLF1oJfQl
   b5pd0/Ei/2W/3aOoiLVPlVVQ1VXgtnzW7xMnKNGzb8+q8wNHnxY7GjxIX
   wWQXCMQa2RKwMeKSm5Z3Gd81Wq+ZDtUs9Rk2jnMWXRDEmBUy3UtatM1yF
   kDrp6PKQya5OmKUaDoFTtOUOlxXt2oRQAlVuSEhJHZPPaDa5ghB9Hbc2R
   PG716qvHmKPJ/k9JZT89yAObE+tP8gfPlCu5sBvQAZlr7gnt8ac4kk0Nu
   wZLYjwK9JjEii01k2Vl9Q0crUsP2yOUhROHp6bGY+UoXcQzL3BBRLh6eO
   g==;
X-CSE-ConnectionGUID: +Oy6WJFuS8eEAeZNHDuzVA==
X-CSE-MsgGUID: nh5roFAsQymLDhtPyBOi6Q==
X-IronPort-AV: E=McAfee;i="6800,10657,11459"; a="51467262"
X-IronPort-AV: E=Sophos;i="6.16,223,1744095600"; 
   d="scan'208";a="51467262"
Received: from orviesa008.jf.intel.com ([10.64.159.148])
  by orvoesa111.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Jun 2025 12:13:59 -0700
X-CSE-ConnectionGUID: djTIjhqXSRmTDLZp0ei7vg==
X-CSE-MsgGUID: lMk54a/gQ76OMl7JysR4zg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.16,223,1744095600"; 
   d="scan'208";a="147562189"
Received: from black.fi.intel.com ([10.237.72.28])
  by orviesa008.jf.intel.com with ESMTP; 09 Jun 2025 12:13:56 -0700
Received: by black.fi.intel.com (Postfix, from userid 1000)
	id 3B3D06A8; Mon, 09 Jun 2025 22:13:49 +0300 (EEST)
From: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
To: pbonzini@redhat.com,
	seanjc@google.com,
	dave.hansen@linux.intel.com
Cc: rick.p.edgecombe@intel.com,
	isaku.yamahata@intel.com,
	kai.huang@intel.com,
	yan.y.zhao@intel.com,
	chao.gao@intel.com,
	tglx@linutronix.de,
	mingo@redhat.com,
	bp@alien8.de,
	kvm@vger.kernel.org,
	x86@kernel.org,
	linux-coco@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	"Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Subject: [PATCHv2 05/12] KVM: TDX: Allocate PAMT memory in __tdx_td_init()
Date: Mon,  9 Jun 2025 22:13:33 +0300
Message-ID: <20250609191340.2051741-6-kirill.shutemov@linux.intel.com>
X-Mailer: git-send-email 2.47.2
In-Reply-To: <20250609191340.2051741-1-kirill.shutemov@linux.intel.com>
References: <20250609191340.2051741-1-kirill.shutemov@linux.intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Allocate PAMT memory for TDH.MNG.CREATE and TDH.MNG.ADDCX.

PAMT memory that is associated with pages successfully added to the TD
with TDH.MNG.ADDCX will be removed in tdx_reclaim_page() on
tdx_reclaim_control_page().

Signed-off-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
---
 arch/x86/kvm/vmx/tdx.c | 16 ++++++----------
 1 file changed, 6 insertions(+), 10 deletions(-)

diff --git a/arch/x86/kvm/vmx/tdx.c b/arch/x86/kvm/vmx/tdx.c
index 7a48bd901536..13796b9a4bc5 100644
--- a/arch/x86/kvm/vmx/tdx.c
+++ b/arch/x86/kvm/vmx/tdx.c
@@ -2370,7 +2370,7 @@ static int __tdx_td_init(struct kvm *kvm, struct td_params *td_params,
 
 	atomic_inc(&nr_configured_hkid);
 
-	tdr_page = alloc_page(GFP_KERNEL);
+	tdr_page = tdx_alloc_page();
 	if (!tdr_page)
 		goto free_hkid;
 
@@ -2383,7 +2383,7 @@ static int __tdx_td_init(struct kvm *kvm, struct td_params *td_params,
 		goto free_tdr;
 
 	for (i = 0; i < kvm_tdx->td.tdcs_nr_pages; i++) {
-		tdcs_pages[i] = alloc_page(GFP_KERNEL);
+		tdcs_pages[i] = tdx_alloc_page();
 		if (!tdcs_pages[i])
 			goto free_tdcs;
 	}
@@ -2504,10 +2504,8 @@ static int __tdx_td_init(struct kvm *kvm, struct td_params *td_params,
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
@@ -2523,15 +2521,13 @@ static int __tdx_td_init(struct kvm *kvm, struct td_params *td_params,
 
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
 	kvm_tdx->td.tdr_page = 0;
 
 free_hkid:
-- 
2.47.2


