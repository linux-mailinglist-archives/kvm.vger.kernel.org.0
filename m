Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D72EA6317BE
	for <lists+kvm@lfdr.de>; Mon, 21 Nov 2022 01:30:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229974AbiKUAah (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 20 Nov 2022 19:30:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57430 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229978AbiKUAaT (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 20 Nov 2022 19:30:19 -0500
Received: from mga07.intel.com (mga07.intel.com [134.134.136.100])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 30CE66A693;
        Sun, 20 Nov 2022 16:28:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1668990532; x=1700526532;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=UBAtxkoUHDLhrJ6Ir/h/0EBfmIyd0UUVQOxLVLHPC58=;
  b=M0Aj5QrcALu7z12Di0o4q8ex3qwTkai9hCfK/LwRCCNKBw0QzJd9lb2/
   QPi9Bnt6hs/z/gEeejH08PuRVRg23ClkroYbYIKw4uZ3hbVfSny6CrVrG
   Avw4ibiDzjnrH/nijc5oTMwrqo6j9gfAIz5W/GM0s0lLt2oLsiqe+OYqE
   HjtZ/vA4f2pR9WWHyf58Xu3KaXitadFMDlwqJo692xgoltsOBlZ3483Ea
   8yG1/+epNuPxPPuLYbO5Aeze+nI4kPw+ZNtqw+xxkECCN69qfAxyTsG+w
   SWQu6c9dX7jG5WEBLNcRUST4LqK5b9M2Qb46KxB4tXA2ndyB14RJCGqHc
   g==;
X-IronPort-AV: E=McAfee;i="6500,9779,10537"; a="377705751"
X-IronPort-AV: E=Sophos;i="5.96,180,1665471600"; 
   d="scan'208";a="377705751"
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Nov 2022 16:28:05 -0800
X-IronPort-AV: E=McAfee;i="6500,9779,10537"; a="729825519"
X-IronPort-AV: E=Sophos;i="5.96,180,1665471600"; 
   d="scan'208";a="729825519"
Received: from tomnavar-mobl.amr.corp.intel.com (HELO khuang2-desk.gar.corp.intel.com) ([10.209.176.15])
  by fmsmga003-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Nov 2022 16:28:00 -0800
From:   Kai Huang <kai.huang@intel.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     linux-mm@kvack.org, seanjc@google.com, pbonzini@redhat.com,
        dave.hansen@intel.com, dan.j.williams@intel.com,
        rafael.j.wysocki@intel.com, kirill.shutemov@linux.intel.com,
        ying.huang@intel.com, reinette.chatre@intel.com,
        len.brown@intel.com, tony.luck@intel.com, peterz@infradead.org,
        ak@linux.intel.com, isaku.yamahata@intel.com, chao.gao@intel.com,
        sathyanarayanan.kuppuswamy@linux.intel.com, bagasdotme@gmail.com,
        sagis@google.com, imammedo@redhat.com, kai.huang@intel.com
Subject: [PATCH v7 16/20] x86/virt/tdx: Configure TDX module with TDMRs and global KeyID
Date:   Mon, 21 Nov 2022 13:26:38 +1300
Message-Id: <344234642a5eb9dc1aa34410f641f596ec428ea5.1668988357.git.kai.huang@intel.com>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <cover.1668988357.git.kai.huang@intel.com>
References: <cover.1668988357.git.kai.huang@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

After the TDX-usable memory regions are constructed in an array of TDMRs
and the global KeyID is reserved, configure them to the TDX module using
TDH.SYS.CONFIG SEAMCALL.  TDH.SYS.CONFIG can only be called once and can
be done on any logical cpu.

Reviewed-by: Isaku Yamahata <isaku.yamahata@intel.com>
Signed-off-by: Kai Huang <kai.huang@intel.com>
---
 arch/x86/virt/vmx/tdx/tdx.c | 37 +++++++++++++++++++++++++++++++++++++
 arch/x86/virt/vmx/tdx/tdx.h |  2 ++
 2 files changed, 39 insertions(+)

diff --git a/arch/x86/virt/vmx/tdx/tdx.c b/arch/x86/virt/vmx/tdx/tdx.c
index e2cbeeb7f0dc..3a032930e58a 100644
--- a/arch/x86/virt/vmx/tdx/tdx.c
+++ b/arch/x86/virt/vmx/tdx/tdx.c
@@ -979,6 +979,37 @@ static int construct_tdmrs(struct tdmr_info *tdmr_array, int *tdmr_num)
 	return ret;
 }
 
+static int config_tdx_module(struct tdmr_info *tdmr_array, int tdmr_num,
+			     u64 global_keyid)
+{
+	u64 *tdmr_pa_array;
+	int i, array_sz;
+	u64 ret;
+
+	/*
+	 * TDMR_INFO entries are configured to the TDX module via an
+	 * array of the physical address of each TDMR_INFO.  TDX module
+	 * requires the array itself to be 512-byte aligned.  Round up
+	 * the array size to 512-byte aligned so the buffer allocated
+	 * by kzalloc() will meet the alignment requirement.
+	 */
+	array_sz = ALIGN(tdmr_num * sizeof(u64), TDMR_INFO_PA_ARRAY_ALIGNMENT);
+	tdmr_pa_array = kzalloc(array_sz, GFP_KERNEL);
+	if (!tdmr_pa_array)
+		return -ENOMEM;
+
+	for (i = 0; i < tdmr_num; i++)
+		tdmr_pa_array[i] = __pa(tdmr_array_entry(tdmr_array, i));
+
+	ret = seamcall(TDH_SYS_CONFIG, __pa(tdmr_pa_array), tdmr_num,
+				global_keyid, 0, NULL, NULL);
+
+	/* Free the array as it is not required anymore. */
+	kfree(tdmr_pa_array);
+
+	return ret;
+}
+
 /*
  * Detect and initialize the TDX module.
  *
@@ -1062,11 +1093,17 @@ static int init_tdx_module(void)
 	 */
 	tdx_global_keyid = tdx_keyid_start;
 
+	/* Pass the TDMRs and the global KeyID to the TDX module */
+	ret = config_tdx_module(tdmr_array, tdmr_num, tdx_global_keyid);
+	if (ret)
+		goto out_free_pamts;
+
 	/*
 	 * Return -EINVAL until all steps of TDX module initialization
 	 * process are done.
 	 */
 	ret = -EINVAL;
+out_free_pamts:
 	if (ret)
 		tdmrs_free_pamt_all(tdmr_array, tdmr_num);
 	else
diff --git a/arch/x86/virt/vmx/tdx/tdx.h b/arch/x86/virt/vmx/tdx/tdx.h
index a737f2b51474..c26bab2555ca 100644
--- a/arch/x86/virt/vmx/tdx/tdx.h
+++ b/arch/x86/virt/vmx/tdx/tdx.h
@@ -19,6 +19,7 @@
 #define TDH_SYS_INIT		33
 #define TDH_SYS_LP_INIT		35
 #define TDH_SYS_LP_SHUTDOWN	44
+#define TDH_SYS_CONFIG		45
 
 struct cmr_info {
 	u64	base;
@@ -86,6 +87,7 @@ struct tdmr_reserved_area {
 } __packed;
 
 #define TDMR_INFO_ALIGNMENT	512
+#define TDMR_INFO_PA_ARRAY_ALIGNMENT	512
 
 struct tdmr_info {
 	u64 base;
-- 
2.38.1

