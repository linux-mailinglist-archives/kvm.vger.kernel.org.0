Return-Path: <kvm+bounces-1337-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 112317E6A1A
	for <lists+kvm@lfdr.de>; Thu,  9 Nov 2023 12:58:17 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 69B54281418
	for <lists+kvm@lfdr.de>; Thu,  9 Nov 2023 11:58:15 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 926EF1DA35;
	Thu,  9 Nov 2023 11:58:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Sz7lgws8"
X-Original-To: kvm@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EB49E1DA20
	for <kvm@vger.kernel.org>; Thu,  9 Nov 2023 11:58:09 +0000 (UTC)
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.8])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5C96830C5;
	Thu,  9 Nov 2023 03:58:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1699531089; x=1731067089;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=e1m89qe/PzNN+KLpQ7ZsJzE2/nAUTRSCVxK2Ox/J100=;
  b=Sz7lgws8ATrpnm5IhvDBzR/aT/Z5AbFRO0/PyAx42wqiqJmDDIOon2qR
   ovCUJdE5XXPeLq9YRPCRx7w1Pm2pMgaf+KNDB/Vl+n8yEq+V+QefIfRIG
   QhO+fpmmCExejB3Xrmxi1q2sZ2UysIC19vyJ0ddaoAktYiA4Ep61FiboS
   cxojo5FqdDosae8LDel7vBzkrOZYN9j7GQm8WX+PA+KuZzkWtmHe9RTRL
   PNasUN3dILTGr5fbrBL2UC7ySZ+oaB7nLmwlsbp0/sh7vHIqvZXMGpT9+
   XI3AnXLB2IsnM3T6bTLEUNmA36Ykb4znMURF+jPAGCGaRejBGyxphF7dQ
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10888"; a="2936723"
X-IronPort-AV: E=Sophos;i="6.03,289,1694761200"; 
   d="scan'208";a="2936723"
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by fmvoesa102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Nov 2023 03:58:09 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10888"; a="766976860"
X-IronPort-AV: E=Sophos;i="6.03,289,1694761200"; 
   d="scan'208";a="766976860"
Received: from shadphix-mobl.amr.corp.intel.com (HELO khuang2-desk.gar.corp.intel.com) ([10.209.83.35])
  by fmsmga007-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Nov 2023 03:58:02 -0800
From: Kai Huang <kai.huang@intel.com>
To: linux-kernel@vger.kernel.org,
	kvm@vger.kernel.org
Cc: x86@kernel.org,
	dave.hansen@intel.com,
	kirill.shutemov@linux.intel.com,
	peterz@infradead.org,
	tony.luck@intel.com,
	tglx@linutronix.de,
	bp@alien8.de,
	mingo@redhat.com,
	hpa@zytor.com,
	seanjc@google.com,
	pbonzini@redhat.com,
	rafael@kernel.org,
	david@redhat.com,
	dan.j.williams@intel.com,
	len.brown@intel.com,
	ak@linux.intel.com,
	isaku.yamahata@intel.com,
	ying.huang@intel.com,
	chao.gao@intel.com,
	sathyanarayanan.kuppuswamy@linux.intel.com,
	nik.borisov@suse.com,
	bagasdotme@gmail.com,
	sagis@google.com,
	imammedo@redhat.com,
	kai.huang@intel.com
Subject: [PATCH v15 18/23] x86/virt/tdx: Keep TDMRs when module initialization is successful
Date: Fri, 10 Nov 2023 00:55:55 +1300
Message-ID: <1b44fddf2f5d9e0dd58df5d4a42e98ff308be0f1.1699527082.git.kai.huang@intel.com>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <cover.1699527082.git.kai.huang@intel.com>
References: <cover.1699527082.git.kai.huang@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

On the platforms with the "partial write machine check" erratum, the
kexec() needs to convert all TDX private pages back to normal before
booting to the new kernel.  Otherwise, the new kernel may get unexpected
machine check.

There's no existing infrastructure to track TDX private pages.  Keep
TDMRs when module initialization is successful so that they can be used
to find PAMTs.

Signed-off-by: Kai Huang <kai.huang@intel.com>
Reviewed-by: Rick Edgecombe <rick.p.edgecombe@intel.com>
Reviewed-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
---

v14 -> v15:
 - No change

v13 -> v14:
 - "Change to keep" -> "Keep" (Kirill)
 - Add Kirill/Rick's tags

v12 -> v13:
  - Split "improve error handling" part out as a separate patch.

v11 -> v12 (new patch):
  - Defer keeping TDMRs logic to this patch for better review
  - Improved error handling logic (Nikolay/Kirill in patch 15)

---
 arch/x86/virt/vmx/tdx/tdx.c | 24 +++++++++++-------------
 1 file changed, 11 insertions(+), 13 deletions(-)

diff --git a/arch/x86/virt/vmx/tdx/tdx.c b/arch/x86/virt/vmx/tdx/tdx.c
index ac47d58f8c74..753e435a3040 100644
--- a/arch/x86/virt/vmx/tdx/tdx.c
+++ b/arch/x86/virt/vmx/tdx/tdx.c
@@ -44,6 +44,8 @@ static DEFINE_MUTEX(tdx_module_lock);
 /* All TDX-usable memory regions.  Protected by mem_hotplug_lock. */
 static LIST_HEAD(tdx_memlist);
 
+static struct tdmr_info_list tdx_tdmr_list;
+
 typedef void (*sc_err_func_t)(u64 fn, u64 err, struct tdx_module_args *args);
 
 static inline void seamcall_err(u64 fn, u64 err, struct tdx_module_args *args)
@@ -1059,7 +1061,6 @@ static int init_tdmrs(struct tdmr_info_list *tdmr_list)
 static int init_tdx_module(void)
 {
 	struct tdx_tdmr_sysinfo tdmr_sysinfo;
-	struct tdmr_info_list tdmr_list;
 	int ret;
 
 	/*
@@ -1083,17 +1084,17 @@ static int init_tdx_module(void)
 		goto out_free_tdxmem;
 
 	/* Allocate enough space for constructing TDMRs */
-	ret = alloc_tdmr_list(&tdmr_list, &tdmr_sysinfo);
+	ret = alloc_tdmr_list(&tdx_tdmr_list, &tdmr_sysinfo);
 	if (ret)
 		goto out_free_tdxmem;
 
 	/* Cover all TDX-usable memory regions in TDMRs */
-	ret = construct_tdmrs(&tdx_memlist, &tdmr_list, &tdmr_sysinfo);
+	ret = construct_tdmrs(&tdx_memlist, &tdx_tdmr_list, &tdmr_sysinfo);
 	if (ret)
 		goto out_free_tdmrs;
 
 	/* Pass the TDMRs and the global KeyID to the TDX module */
-	ret = config_tdx_module(&tdmr_list, tdx_global_keyid);
+	ret = config_tdx_module(&tdx_tdmr_list, tdx_global_keyid);
 	if (ret)
 		goto out_free_pamts;
 
@@ -1113,7 +1114,7 @@ static int init_tdx_module(void)
 		goto out_reset_pamts;
 
 	/* Initialize TDMRs to complete the TDX module initialization */
-	ret = init_tdmrs(&tdmr_list);
+	ret = init_tdmrs(&tdx_tdmr_list);
 out_reset_pamts:
 	if (ret) {
 		/*
@@ -1130,20 +1131,17 @@ static int init_tdx_module(void)
 		 * back to normal.  But do the conversion anyway here
 		 * as suggested by the TDX spec.
 		 */
-		tdmrs_reset_pamt_all(&tdmr_list);
+		tdmrs_reset_pamt_all(&tdx_tdmr_list);
 	}
 out_free_pamts:
 	if (ret)
-		tdmrs_free_pamt_all(&tdmr_list);
+		tdmrs_free_pamt_all(&tdx_tdmr_list);
 	else
 		pr_info("%lu KBs allocated for PAMT\n",
-				tdmrs_count_pamt_kb(&tdmr_list));
+				tdmrs_count_pamt_kb(&tdx_tdmr_list));
 out_free_tdmrs:
-	/*
-	 * Always free the buffer of TDMRs as they are only used during
-	 * module initialization.
-	 */
-	free_tdmr_list(&tdmr_list);
+	if (ret)
+		free_tdmr_list(&tdx_tdmr_list);
 out_free_tdxmem:
 	if (ret)
 		free_tdx_memlist(&tdx_memlist);
-- 
2.41.0


