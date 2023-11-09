Return-Path: <kvm+bounces-1333-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id AF8C37E6A14
	for <lists+kvm@lfdr.de>; Thu,  9 Nov 2023 12:57:51 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id DFC211C20D1F
	for <lists+kvm@lfdr.de>; Thu,  9 Nov 2023 11:57:50 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D3F001DA36;
	Thu,  9 Nov 2023 11:57:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="O9AGUOem"
X-Original-To: kvm@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 178F01DA2C
	for <kvm@vger.kernel.org>; Thu,  9 Nov 2023 11:57:45 +0000 (UTC)
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.8])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2D9503243;
	Thu,  9 Nov 2023 03:57:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1699531064; x=1731067064;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=UivIbwKOnuoRy52iq1LnnkoCBbVc6eDzrqha0yv46l0=;
  b=O9AGUOemm6fVceECcMzUFbZfePU6zfGSfmAmYJpooKrKwjDjhqNk+7Al
   0VJNckG6Crzyo5/Y9hNWp7k7eV0Nwh2uDb0tCyQrRgRpUqigSK3XtM0ES
   imzY02V6ay3aoV7m1X3F+K0ISKhdwqQdYWGgAY+S6fOmDty164fAOUH03
   cPWML7ZPauO8Dy9vwGdNi7jTgSkhCYXjwagGaFdVtqkixBA5Xcyrej6VZ
   LCyriM3Tj37nWv7csIEd6/RLpyCs9rx4HCA4vnH5ag3OOp92hQWvSH4fF
   KTiMSiNfWsf6vOGikHR/CmxuqU2HmaBHVdKr53fZCsRXfUQ4Df8Q2Fiqm
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10888"; a="2936638"
X-IronPort-AV: E=Sophos;i="6.03,289,1694761200"; 
   d="scan'208";a="2936638"
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by fmvoesa102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Nov 2023 03:57:44 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10888"; a="766976787"
X-IronPort-AV: E=Sophos;i="6.03,289,1694761200"; 
   d="scan'208";a="766976787"
Received: from shadphix-mobl.amr.corp.intel.com (HELO khuang2-desk.gar.corp.intel.com) ([10.209.83.35])
  by fmsmga007-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Nov 2023 03:57:37 -0800
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
Subject: [PATCH v15 14/23] x86/virt/tdx: Configure TDX module with the TDMRs and global KeyID
Date: Fri, 10 Nov 2023 00:55:51 +1300
Message-ID: <02423dbdd46c07016793290c6ed0300b5383d234.1699527082.git.kai.huang@intel.com>
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

The TDX module uses a private KeyID as the "global KeyID" for mapping
things like the PAMT and other TDX metadata.  This KeyID has already
been reserved when detecting TDX during the kernel early boot.

After the list of "TD Memory Regions" (TDMRs) has been constructed to
cover all TDX-usable memory regions, the next step is to pass them to
the TDX module together with the global KeyID.

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
 arch/x86/virt/vmx/tdx/tdx.c | 44 ++++++++++++++++++++++++++++++++++++-
 arch/x86/virt/vmx/tdx/tdx.h |  2 ++
 2 files changed, 45 insertions(+), 1 deletion(-)

diff --git a/arch/x86/virt/vmx/tdx/tdx.c b/arch/x86/virt/vmx/tdx/tdx.c
index a3340a6e23c5..aba851e11c72 100644
--- a/arch/x86/virt/vmx/tdx/tdx.c
+++ b/arch/x86/virt/vmx/tdx/tdx.c
@@ -24,8 +24,10 @@
 #include <linux/pfn.h>
 #include <linux/align.h>
 #include <linux/sort.h>
+#include <linux/log2.h>
 #include <asm/msr-index.h>
 #include <asm/msr.h>
+#include <asm/page.h>
 #include <asm/tdx.h>
 #include "tdx.h"
 
@@ -878,6 +880,41 @@ static int construct_tdmrs(struct list_head *tmb_list,
 	return ret;
 }
 
+static int config_tdx_module(struct tdmr_info_list *tdmr_list, u64 global_keyid)
+{
+	struct tdx_module_args args = {};
+	u64 *tdmr_pa_array;
+	size_t array_sz;
+	int i, ret;
+
+	/*
+	 * TDMRs are passed to the TDX module via an array of physical
+	 * addresses of each TDMR.  The array itself also has certain
+	 * alignment requirement.
+	 */
+	array_sz = tdmr_list->nr_consumed_tdmrs * sizeof(u64);
+	array_sz = roundup_pow_of_two(array_sz);
+	if (array_sz < TDMR_INFO_PA_ARRAY_ALIGNMENT)
+		array_sz = TDMR_INFO_PA_ARRAY_ALIGNMENT;
+
+	tdmr_pa_array = kzalloc(array_sz, GFP_KERNEL);
+	if (!tdmr_pa_array)
+		return -ENOMEM;
+
+	for (i = 0; i < tdmr_list->nr_consumed_tdmrs; i++)
+		tdmr_pa_array[i] = __pa(tdmr_entry(tdmr_list, i));
+
+	args.rcx = __pa(tdmr_pa_array);
+	args.rdx = tdmr_list->nr_consumed_tdmrs;
+	args.r8 = global_keyid;
+	ret = seamcall_prerr(TDH_SYS_CONFIG, &args);
+
+	/* Free the array as it is not required anymore. */
+	kfree(tdmr_pa_array);
+
+	return ret;
+}
+
 static int init_tdx_module(void)
 {
 	struct tdx_tdmr_sysinfo tdmr_sysinfo;
@@ -914,16 +951,21 @@ static int init_tdx_module(void)
 	if (ret)
 		goto out_free_tdmrs;
 
+	/* Pass the TDMRs and the global KeyID to the TDX module */
+	ret = config_tdx_module(&tdmr_list, tdx_global_keyid);
+	if (ret)
+		goto out_free_pamts;
+
 	/*
 	 * TODO:
 	 *
-	 *  - Configure the TDMRs and the global KeyID to the TDX module.
 	 *  - Configure the global KeyID on all packages.
 	 *  - Initialize all TDMRs.
 	 *
 	 *  Return error before all steps are done.
 	 */
 	ret = -EINVAL;
+out_free_pamts:
 	if (ret)
 		tdmrs_free_pamt_all(&tdmr_list);
 	else
diff --git a/arch/x86/virt/vmx/tdx/tdx.h b/arch/x86/virt/vmx/tdx/tdx.h
index 1b04efece9db..fa5bcf8b5a9c 100644
--- a/arch/x86/virt/vmx/tdx/tdx.h
+++ b/arch/x86/virt/vmx/tdx/tdx.h
@@ -17,6 +17,7 @@
 #define TDH_SYS_INIT		33
 #define TDH_SYS_RD		34
 #define TDH_SYS_LP_INIT		35
+#define TDH_SYS_CONFIG		45
 
 /*
  * Global scope metadata field ID.
@@ -53,6 +54,7 @@ struct tdmr_reserved_area {
 } __packed;
 
 #define TDMR_INFO_ALIGNMENT	512
+#define TDMR_INFO_PA_ARRAY_ALIGNMENT	512
 
 struct tdmr_info {
 	u64 base;
-- 
2.41.0


