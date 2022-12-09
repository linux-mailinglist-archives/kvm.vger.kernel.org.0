Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 21107647E1B
	for <lists+kvm@lfdr.de>; Fri,  9 Dec 2022 07:56:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230078AbiLIG4N (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 9 Dec 2022 01:56:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40926 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229907AbiLIGzs (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 9 Dec 2022 01:55:48 -0500
Received: from mga09.intel.com (mga09.intel.com [134.134.136.24])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BA517ACB2C;
        Thu,  8 Dec 2022 22:54:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1670568846; x=1702104846;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=HQ0ARWB5QqQjACtiLE4nnaxso1L0OZgpdlJycabR6Bk=;
  b=VYO7EMeluQfsCE+7cNveQtJ/5JDx5+OeefJTXSz2UGdg4u9M2MroDl11
   aGHf7v724uwbiqsBI8vz4lA2KTyMi+DytG6GV9hznLMLUOALQ5ukQ5EEa
   XukCf4BHL6ZhYzmZYzeSBzTYf8wSb5I5BhkIj13BNks/ZC9TfpyrKCPKM
   NmiBKndu/b0H3OBWCib3vidp1KrqdKw0bHqoiCrwna7Ha6EysnSE6M2xx
   I4sDRGN4XNuOPNhULdk1iFKVwL1ROlOiG63MXwjf5ryxv1WthNsQvAIgm
   oGeBHPGoJGM3eCjmM1BIFUrw5WgdLdRlrsbXqyUttAFBc9fY2TULXQfE6
   w==;
X-IronPort-AV: E=McAfee;i="6500,9779,10555"; a="318551455"
X-IronPort-AV: E=Sophos;i="5.96,230,1665471600"; 
   d="scan'208";a="318551455"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Dec 2022 22:54:02 -0800
X-IronPort-AV: E=McAfee;i="6500,9779,10555"; a="679837066"
X-IronPort-AV: E=Sophos;i="5.96,230,1665471600"; 
   d="scan'208";a="679837066"
Received: from omiramon-mobl1.amr.corp.intel.com (HELO khuang2-desk.gar.corp.intel.com) ([10.212.28.82])
  by orsmga001-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Dec 2022 22:53:57 -0800
From:   Kai Huang <kai.huang@intel.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     linux-mm@kvack.org, dave.hansen@intel.com, peterz@infradead.org,
        tglx@linutronix.de, seanjc@google.com, pbonzini@redhat.com,
        dan.j.williams@intel.com, rafael.j.wysocki@intel.com,
        kirill.shutemov@linux.intel.com, ying.huang@intel.com,
        reinette.chatre@intel.com, len.brown@intel.com,
        tony.luck@intel.com, ak@linux.intel.com, isaku.yamahata@intel.com,
        chao.gao@intel.com, sathyanarayanan.kuppuswamy@linux.intel.com,
        bagasdotme@gmail.com, sagis@google.com, imammedo@redhat.com,
        kai.huang@intel.com
Subject: [PATCH v8 12/16] x86/virt/tdx: Designate the global KeyID and configure the TDX module
Date:   Fri,  9 Dec 2022 19:52:33 +1300
Message-Id: <d7b01f396908da796644e58298a34c1f8a140be7.1670566861.git.kai.huang@intel.com>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <cover.1670566861.git.kai.huang@intel.com>
References: <cover.1670566861.git.kai.huang@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

After a list of "TD Memory Regions" (TDMRs) has been constructed to
cover all TDX-usable memory regions, the next step is to pick up a TDX
private KeyID as the "global KeyID" (which protects, i.e. TDX module's
metadata), and configure it to the TDX module along with the TDMRs.

To keep things simple, just use the first TDX KeyID as the global KeyID.

Reviewed-by: Isaku Yamahata <isaku.yamahata@intel.com>
Signed-off-by: Kai Huang <kai.huang@intel.com>
---

v7 -> v8:
 - Merged "Reserve TDX module global KeyID" patch to this patch, and
   removed 'tdx_global_keyid' but use 'tdx_keyid_start' directly.
 - Changed changelog accordingly.
 - Changed how to allocate aligned array (Dave).

---
 arch/x86/virt/vmx/tdx/tdx.c | 41 +++++++++++++++++++++++++++++++++++--
 arch/x86/virt/vmx/tdx/tdx.h |  2 ++
 2 files changed, 41 insertions(+), 2 deletions(-)

diff --git a/arch/x86/virt/vmx/tdx/tdx.c b/arch/x86/virt/vmx/tdx/tdx.c
index 620b35e2a61b..ab961443fed5 100644
--- a/arch/x86/virt/vmx/tdx/tdx.c
+++ b/arch/x86/virt/vmx/tdx/tdx.c
@@ -916,6 +916,36 @@ static int construct_tdmrs(struct list_head *tmb_list,
 	return ret;
 }
 
+static int config_tdx_module(struct tdmr_info_list *tdmr_list, u64 global_keyid)
+{
+	u64 *tdmr_pa_array, *p;
+	size_t array_sz;
+	int i, ret;
+
+	/*
+	 * TDMRs are passed to the TDX module via an array of physical
+	 * addresses of each TDMR.  The array itself has alignment
+	 * requirement.
+	 */
+	array_sz = tdmr_list->nr_tdmrs * sizeof(u64) +
+		TDMR_INFO_PA_ARRAY_ALIGNMENT - 1;
+	p = kzalloc(array_sz, GFP_KERNEL);
+	if (!p)
+		return -ENOMEM;
+
+	tdmr_pa_array = PTR_ALIGN(p, TDMR_INFO_PA_ARRAY_ALIGNMENT);
+	for (i = 0; i < tdmr_list->nr_tdmrs; i++)
+		tdmr_pa_array[i] = __pa(tdmr_entry(tdmr_list, i));
+
+	ret = seamcall(TDH_SYS_CONFIG, __pa(tdmr_pa_array), tdmr_list->nr_tdmrs,
+				global_keyid, 0, NULL, NULL);
+
+	/* Free the array as it is not required anymore. */
+	kfree(p);
+
+	return ret;
+}
+
 static int init_tdx_module(void)
 {
 	/*
@@ -960,17 +990,24 @@ static int init_tdx_module(void)
 	if (ret)
 		goto out_free_tdmrs;
 
+	/*
+	 * Use the first private KeyID as the global KeyID, and pass
+	 * it along with the TDMRs to the TDX module.
+	 */
+	ret = config_tdx_module(&tdmr_list, tdx_keyid_start);
+	if (ret)
+		goto out_free_pamts;
+
 	/*
 	 * TODO:
 	 *
-	 *  - Pick up one TDX private KeyID as the global KeyID.
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
index d0c762f1a94c..4d2edd477480 100644
--- a/arch/x86/virt/vmx/tdx/tdx.h
+++ b/arch/x86/virt/vmx/tdx/tdx.h
@@ -20,6 +20,7 @@
  * TDX module SEAMCALL leaf functions
  */
 #define TDH_SYS_INFO		32
+#define TDH_SYS_CONFIG		45
 
 struct cmr_info {
 	u64	base;
@@ -96,6 +97,7 @@ struct tdmr_reserved_area {
 } __packed;
 
 #define TDMR_INFO_ALIGNMENT	512
+#define TDMR_INFO_PA_ARRAY_ALIGNMENT	512
 
 struct tdmr_info {
 	u64 base;
-- 
2.38.1

