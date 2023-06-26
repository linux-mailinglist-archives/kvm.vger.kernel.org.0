Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0A80F73E1D8
	for <lists+kvm@lfdr.de>; Mon, 26 Jun 2023 16:17:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231492AbjFZORM (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 26 Jun 2023 10:17:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35192 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230224AbjFZOQm (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 26 Jun 2023 10:16:42 -0400
Received: from mga18.intel.com (mga18.intel.com [134.134.136.126])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6103910E2;
        Mon, 26 Jun 2023 07:16:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1687788966; x=1719324966;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=MdgIAiAKsm5b7IZW1m4wCtAmfDlp9uu+ITFZtSJwHDU=;
  b=cqUMFl7uHmUzQPMTGgfSgEcm2VUKnic47G1hn2TbhzE5IN4RXtUBgXuI
   yGhvMwK7QXrcTj2jfOvktNg9Spls0qONNpT4onTyuiaWFlekCaLAaOPtJ
   Z71YzYMeCZJVd0ErDodGMwQjpBdrcWhb0ZzNIPBrCXA6V9l5FPm+RLvZH
   /264fRFSmovfvXsg2PHLqUBCKxXxFbF14P3Pdvpmau4YfciN2+Dl73Qfp
   p3WXqovmu7q3kyomLudc7DPSGxnSxJUKLsiQqIoMXqZHhM3qgSmU/w98j
   A3WHrj/16HpPxQyc1Mj7A2QAGnKI5e5rOSambnZ635OCleHk1WZdmo42a
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10753"; a="346034130"
X-IronPort-AV: E=Sophos;i="6.01,159,1684825200"; 
   d="scan'208";a="346034130"
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Jun 2023 07:15:36 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10753"; a="890292458"
X-IronPort-AV: E=Sophos;i="6.01,159,1684825200"; 
   d="scan'208";a="890292458"
Received: from smithau-mobl1.amr.corp.intel.com (HELO khuang2-desk.gar.corp.intel.com) ([10.213.179.223])
  by orsmga005-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Jun 2023 07:15:29 -0700
From:   Kai Huang <kai.huang@intel.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     linux-mm@kvack.org, x86@kernel.org, dave.hansen@intel.com,
        kirill.shutemov@linux.intel.com, tony.luck@intel.com,
        peterz@infradead.org, tglx@linutronix.de, bp@alien8.de,
        mingo@redhat.com, hpa@zytor.com, seanjc@google.com,
        pbonzini@redhat.com, david@redhat.com, dan.j.williams@intel.com,
        rafael.j.wysocki@intel.com, ashok.raj@intel.com,
        reinette.chatre@intel.com, len.brown@intel.com, ak@linux.intel.com,
        isaku.yamahata@intel.com, ying.huang@intel.com, chao.gao@intel.com,
        sathyanarayanan.kuppuswamy@linux.intel.com, nik.borisov@suse.com,
        bagasdotme@gmail.com, sagis@google.com, imammedo@redhat.com,
        kai.huang@intel.com
Subject: [PATCH v12 18/22] x86/virt/tdx: Keep TDMRs when module initialization is successful
Date:   Tue, 27 Jun 2023 02:12:48 +1200
Message-Id: <7d06fe5fda0e330895c1c9043b881f3c2a2d4f3f.1687784645.git.kai.huang@intel.com>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <cover.1687784645.git.kai.huang@intel.com>
References: <cover.1687784645.git.kai.huang@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On the platforms with the "partial write machine check" erratum, the
kexec() needs to convert all TDX private pages back to normal before
booting to the new kernel.  Otherwise, the new kernel may get unexpected
machine check.

There's no existing infrastructure to track TDX private pages.  Change
to keep TDMRs when module initialization is successful so that they can
be used to find PAMTs.

With this change, only put_online_mems() and freeing the buffer of the
TDSYSINFO_STRUCT and CMR array still need to be done even when module
initialization is successful.  Adjust the error handling to explicitly
do them when module initialization is successful and unconditionally
clean up the rest when initialization fails.

Signed-off-by: Kai Huang <kai.huang@intel.com>
---

v11 -> v12 (new patch):
  - Defer keeping TDMRs logic to this patch for better review
  - Improved error handling logic (Nikolay/Kirill in patch 15)

---
 arch/x86/virt/vmx/tdx/tdx.c | 84 ++++++++++++++++++-------------------
 1 file changed, 42 insertions(+), 42 deletions(-)

diff --git a/arch/x86/virt/vmx/tdx/tdx.c b/arch/x86/virt/vmx/tdx/tdx.c
index 52b7267ea226..85b24b2e9417 100644
--- a/arch/x86/virt/vmx/tdx/tdx.c
+++ b/arch/x86/virt/vmx/tdx/tdx.c
@@ -49,6 +49,8 @@ static DEFINE_MUTEX(tdx_module_lock);
 /* All TDX-usable memory regions.  Protected by mem_hotplug_lock. */
 static LIST_HEAD(tdx_memlist);
 
+static struct tdmr_info_list tdx_tdmr_list;
+
 /*
  * Wrapper of __seamcall() to convert SEAMCALL leaf function error code
  * to kernel error code.  @seamcall_ret and @out contain the SEAMCALL
@@ -1047,7 +1049,6 @@ static int init_tdmrs(struct tdmr_info_list *tdmr_list)
 static int init_tdx_module(void)
 {
 	struct tdsysinfo_struct *sysinfo;
-	struct tdmr_info_list tdmr_list;
 	struct cmr_info *cmr_array;
 	int ret;
 
@@ -1088,17 +1089,17 @@ static int init_tdx_module(void)
 		goto out_put_tdxmem;
 
 	/* Allocate enough space for constructing TDMRs */
-	ret = alloc_tdmr_list(&tdmr_list, sysinfo);
+	ret = alloc_tdmr_list(&tdx_tdmr_list, sysinfo);
 	if (ret)
 		goto out_free_tdxmem;
 
 	/* Cover all TDX-usable memory regions in TDMRs */
-	ret = construct_tdmrs(&tdx_memlist, &tdmr_list, sysinfo);
+	ret = construct_tdmrs(&tdx_memlist, &tdx_tdmr_list, sysinfo);
 	if (ret)
 		goto out_free_tdmrs;
 
 	/* Pass the TDMRs and the global KeyID to the TDX module */
-	ret = config_tdx_module(&tdmr_list, tdx_global_keyid);
+	ret = config_tdx_module(&tdx_tdmr_list, tdx_global_keyid);
 	if (ret)
 		goto out_free_pamts;
 
@@ -1118,51 +1119,50 @@ static int init_tdx_module(void)
 		goto out_reset_pamts;
 
 	/* Initialize TDMRs to complete the TDX module initialization */
-	ret = init_tdmrs(&tdmr_list);
+	ret = init_tdmrs(&tdx_tdmr_list);
+	if (ret)
+		goto out_reset_pamts;
+
+	pr_info("%lu KBs allocated for PAMT.\n",
+			tdmrs_count_pamt_kb(&tdx_tdmr_list));
+
+	/*
+	 * @tdx_memlist is written here and read at memory hotplug time.
+	 * Lock out memory hotplug code while building it.
+	 */
+	put_online_mems();
+	/*
+	 * For now both @sysinfo and @cmr_array are only used during
+	 * module initialization, so always free them.
+	 */
+	free_page((unsigned long)sysinfo);
+
+	return 0;
 out_reset_pamts:
-	if (ret) {
-		/*
-		 * Part of PAMTs may already have been initialized by the
-		 * TDX module.  Flush cache before returning PAMTs back
-		 * to the kernel.
-		 */
-		wbinvd_on_all_cpus();
-		/*
-		 * According to the TDX hardware spec, if the platform
-		 * doesn't have the "partial write machine check"
-		 * erratum, any kernel read/write will never cause #MC
-		 * in kernel space, thus it's OK to not convert PAMTs
-		 * back to normal.  But do the conversion anyway here
-		 * as suggested by the TDX spec.
-		 */
-		tdmrs_reset_pamt_all(&tdmr_list);
-	}
+	/*
+	 * Part of PAMTs may already have been initialized by the
+	 * TDX module.  Flush cache before returning PAMTs back
+	 * to the kernel.
+	 */
+	wbinvd_on_all_cpus();
+	/*
+	 * According to the TDX hardware spec, if the platform
+	 * doesn't have the "partial write machine check"
+	 * erratum, any kernel read/write will never cause #MC
+	 * in kernel space, thus it's OK to not convert PAMTs
+	 * back to normal.  But do the conversion anyway here
+	 * as suggested by the TDX spec.
+	 */
+	tdmrs_reset_pamt_all(&tdx_tdmr_list);
 out_free_pamts:
-	if (ret)
-		tdmrs_free_pamt_all(&tdmr_list);
-	else
-		pr_info("%lu KBs allocated for PAMT.\n",
-				tdmrs_count_pamt_kb(&tdmr_list));
+	tdmrs_free_pamt_all(&tdx_tdmr_list);
 out_free_tdmrs:
-	/*
-	 * Always free the buffer of TDMRs as they are only used during
-	 * module initialization.
-	 */
-	free_tdmr_list(&tdmr_list);
+	free_tdmr_list(&tdx_tdmr_list);
 out_free_tdxmem:
-	if (ret)
-		free_tdx_memlist(&tdx_memlist);
+	free_tdx_memlist(&tdx_memlist);
 out_put_tdxmem:
-	/*
-	 * @tdx_memlist is written here and read at memory hotplug time.
-	 * Lock out memory hotplug code while building it.
-	 */
 	put_online_mems();
 out:
-	/*
-	 * For now both @sysinfo and @cmr_array are only used during
-	 * module initialization, so always free them.
-	 */
 	free_page((unsigned long)sysinfo);
 	return ret;
 }
-- 
2.40.1

