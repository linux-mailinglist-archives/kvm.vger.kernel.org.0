Return-Path: <kvm+bounces-1335-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 29E9F7E6A17
	for <lists+kvm@lfdr.de>; Thu,  9 Nov 2023 12:58:06 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 89AD3B21006
	for <lists+kvm@lfdr.de>; Thu,  9 Nov 2023 11:58:03 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 685CA1DA35;
	Thu,  9 Nov 2023 11:57:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="kNWz7kuF"
X-Original-To: kvm@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E77981DA27
	for <kvm@vger.kernel.org>; Thu,  9 Nov 2023 11:57:56 +0000 (UTC)
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.8])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8AB0430FC;
	Thu,  9 Nov 2023 03:57:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1699531077; x=1731067077;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=7SvCl6cWh8dFf3vCQy3cb7PBPWZHI6XH79ha9gimpOE=;
  b=kNWz7kuFHvVEI7FP+YZolFOVQSOrxpJ2oOYtUTvUAWm1k7uDeNNqRuk7
   FU6fP+lqdgynMnURbvgSf2pqT7l278Vo0qBJjx1Yfqbi2o+V6Bz2CnNH6
   EBNxWM3BI1A+5adxS2684or+0Iv/zz1G7kUbKVCLszqNtskpstH29Na2f
   ciyv8EuM8FzJh6ejmmRhxUxXEaCVgVrQcBjuEXshzov0BSYF5lmzIdGw3
   yG3L/KgKsjWse/H3hoXN4ALYnCRwzQDvNVi2P/GNfHBtATJLDvuFJtEFs
   vHOVqwqJ7JATYD8ry1NkVB8Z+pfW18VfiKb8jbDW8DwU0h5nRh0A3Cm98
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10888"; a="2936681"
X-IronPort-AV: E=Sophos;i="6.03,289,1694761200"; 
   d="scan'208";a="2936681"
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by fmvoesa102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Nov 2023 03:57:56 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10888"; a="766976814"
X-IronPort-AV: E=Sophos;i="6.03,289,1694761200"; 
   d="scan'208";a="766976814"
Received: from shadphix-mobl.amr.corp.intel.com (HELO khuang2-desk.gar.corp.intel.com) ([10.209.83.35])
  by fmsmga007-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Nov 2023 03:57:49 -0800
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
Subject: [PATCH v15 16/23] x86/virt/tdx: Initialize all TDMRs
Date: Fri, 10 Nov 2023 00:55:53 +1300
Message-ID: <566ff8b05090c935d980d5ace3389d31c7cce7df.1699527082.git.kai.huang@intel.com>
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

After the global KeyID has been configured on all packages, initialize
all TDMRs to make all TDX-usable memory regions that are passed to the
TDX module become usable.

This is the last step of initializing the TDX module.

Initializing TDMRs can be time consuming on large memory systems as it
involves initializing all metadata entries for all pages that can be
used by TDX guests.  Initializing different TDMRs can be parallelized.
For now to keep it simple, just initialize all TDMRs one by one.  It can
be enhanced in the future.

Signed-off-by: Kai Huang <kai.huang@intel.com>
Reviewed-by: Isaku Yamahata <isaku.yamahata@intel.com>
Reviewed-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Reviewed-by: Yuan Yao <yuan.yao@intel.com>
---

v14 -> v15:
 - No change

v13 -> v14:
 - No change

v12 -> v13:
 - Added Yuan's tag.

v11 -> v12:
 - Added Kirill's tag

v10 -> v11:
 - No update

v9 -> v10:
 - Code change due to change static 'tdx_tdmr_list' to local 'tdmr_list'.

v8 -> v9:
 - Improved changlog to explain why initializing TDMRs can take long
   time (Dave).
 - Improved comments around 'next-to-initialize' address (Dave).

v7 -> v8: (Dave)
 - Changelog:
   - explicitly call out this is the last step of TDX module initialization.
   - Trimed down changelog by removing SEAMCALL name and details.
 - Removed/trimmed down unnecessary comments.
 - Other changes due to 'struct tdmr_info_list'.

v6 -> v7:
 - Removed need_resched() check. -- Andi.


---
 arch/x86/virt/vmx/tdx/tdx.c | 60 ++++++++++++++++++++++++++++++++-----
 arch/x86/virt/vmx/tdx/tdx.h |  1 +
 2 files changed, 53 insertions(+), 8 deletions(-)

diff --git a/arch/x86/virt/vmx/tdx/tdx.c b/arch/x86/virt/vmx/tdx/tdx.c
index 329d233c11da..ac47d58f8c74 100644
--- a/arch/x86/virt/vmx/tdx/tdx.c
+++ b/arch/x86/virt/vmx/tdx/tdx.c
@@ -1006,6 +1006,56 @@ static int config_global_keyid(void)
 	return ret;
 }
 
+static int init_tdmr(struct tdmr_info *tdmr)
+{
+	u64 next;
+
+	/*
+	 * Initializing a TDMR can be time consuming.  To avoid long
+	 * SEAMCALLs, the TDX module may only initialize a part of the
+	 * TDMR in each call.
+	 */
+	do {
+		struct tdx_module_args args = {
+			.rcx = tdmr->base,
+		};
+		int ret;
+
+		ret = seamcall_prerr_ret(TDH_SYS_TDMR_INIT, &args);
+		if (ret)
+			return ret;
+		/*
+		 * RDX contains 'next-to-initialize' address if
+		 * TDH.SYS.TDMR.INIT did not fully complete and
+		 * should be retried.
+		 */
+		next = args.rdx;
+		cond_resched();
+		/* Keep making SEAMCALLs until the TDMR is done */
+	} while (next < tdmr->base + tdmr->size);
+
+	return 0;
+}
+
+static int init_tdmrs(struct tdmr_info_list *tdmr_list)
+{
+	int i;
+
+	/*
+	 * This operation is costly.  It can be parallelized,
+	 * but keep it simple for now.
+	 */
+	for (i = 0; i < tdmr_list->nr_consumed_tdmrs; i++) {
+		int ret;
+
+		ret = init_tdmr(tdmr_entry(tdmr_list, i));
+		if (ret)
+			return ret;
+	}
+
+	return 0;
+}
+
 static int init_tdx_module(void)
 {
 	struct tdx_tdmr_sysinfo tdmr_sysinfo;
@@ -1062,14 +1112,8 @@ static int init_tdx_module(void)
 	if (ret)
 		goto out_reset_pamts;
 
-	/*
-	 * TODO:
-	 *
-	 *  - Initialize all TDMRs.
-	 *
-	 *  Return error before all steps are done.
-	 */
-	ret = -EINVAL;
+	/* Initialize TDMRs to complete the TDX module initialization */
+	ret = init_tdmrs(&tdmr_list);
 out_reset_pamts:
 	if (ret) {
 		/*
diff --git a/arch/x86/virt/vmx/tdx/tdx.h b/arch/x86/virt/vmx/tdx/tdx.h
index dd35baf756b8..c0610f0bb88c 100644
--- a/arch/x86/virt/vmx/tdx/tdx.h
+++ b/arch/x86/virt/vmx/tdx/tdx.h
@@ -18,6 +18,7 @@
 #define TDH_SYS_INIT		33
 #define TDH_SYS_RD		34
 #define TDH_SYS_LP_INIT		35
+#define TDH_SYS_TDMR_INIT	36
 #define TDH_SYS_CONFIG		45
 
 /*
-- 
2.41.0


