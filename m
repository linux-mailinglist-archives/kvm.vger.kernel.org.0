Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 75A477CC06F
	for <lists+kvm@lfdr.de>; Tue, 17 Oct 2023 12:17:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343822AbjJQKRp (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 17 Oct 2023 06:17:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51620 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235047AbjJQKR0 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 17 Oct 2023 06:17:26 -0400
Received: from mgamail.intel.com (mgamail.intel.com [192.55.52.43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 02B2F19A2;
        Tue, 17 Oct 2023 03:16:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1697537790; x=1729073790;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=VgX9sPSJs1p1hYJxhznYVCny+0lfqZGWlm7qyMbXIcc=;
  b=YSX8cb9NKk4e1aQU5kKU76wZET6bBTHo68XysD7jYZl49dniukPAzqAF
   9RS8HLXw9/4Dk6ZafOvpC15YPCHGzZL9GjudWtmemab3h8ApuG6SDg901
   DlyoNXarhfhRkvl79UtqlYdLcX78du8hA3e4NG2ZPC64aXzzXsRrRtuGH
   CqywwdgBmuqtwtMC03J9rPtVcy1AAH/DCQ2YXQ6DORF55Fz4SoOaawUNZ
   TdFG7mMuMu1sQYs7CHJdu6Bi3ssj7nW4Yag8aAHMVlOPi9N+v+mqeeP8n
   UL9PN1KSfF8oyH6SKWHLld1h/8W38JDAbGBxR2skfE+V7hcKWTnhmOrBU
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10865"; a="471972462"
X-IronPort-AV: E=Sophos;i="6.03,231,1694761200"; 
   d="scan'208";a="471972462"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Oct 2023 03:16:29 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10865"; a="872503739"
X-IronPort-AV: E=Sophos;i="6.03,231,1694761200"; 
   d="scan'208";a="872503739"
Received: from chowe-mobl.amr.corp.intel.com (HELO khuang2-desk.gar.corp.intel.com) ([10.255.229.64])
  by fmsmga002-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Oct 2023 03:16:23 -0700
From:   Kai Huang <kai.huang@intel.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     x86@kernel.org, dave.hansen@intel.com,
        kirill.shutemov@linux.intel.com, peterz@infradead.org,
        tony.luck@intel.com, tglx@linutronix.de, bp@alien8.de,
        mingo@redhat.com, hpa@zytor.com, seanjc@google.com,
        pbonzini@redhat.com, rafael@kernel.org, david@redhat.com,
        dan.j.williams@intel.com, len.brown@intel.com, ak@linux.intel.com,
        isaku.yamahata@intel.com, ying.huang@intel.com, chao.gao@intel.com,
        sathyanarayanan.kuppuswamy@linux.intel.com, nik.borisov@suse.com,
        bagasdotme@gmail.com, sagis@google.com, imammedo@redhat.com,
        kai.huang@intel.com
Subject: [PATCH v14 14/23] x86/virt/tdx: Configure TDX module with the TDMRs and global KeyID
Date:   Tue, 17 Oct 2023 23:14:38 +1300
Message-ID: <7b8293d905fbcd5fa939897f38b4aae1f8d397f8.1697532085.git.kai.huang@intel.com>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <cover.1697532085.git.kai.huang@intel.com>
References: <cover.1697532085.git.kai.huang@intel.com>
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
 arch/x86/virt/vmx/tdx/tdx.c | 43 ++++++++++++++++++++++++++++++++++++-
 arch/x86/virt/vmx/tdx/tdx.h |  2 ++
 2 files changed, 44 insertions(+), 1 deletion(-)

diff --git a/arch/x86/virt/vmx/tdx/tdx.c b/arch/x86/virt/vmx/tdx/tdx.c
index d1c6f8ce4e16..764f3f7a5ca2 100644
--- a/arch/x86/virt/vmx/tdx/tdx.c
+++ b/arch/x86/virt/vmx/tdx/tdx.c
@@ -26,6 +26,7 @@
 #include <linux/pfn.h>
 #include <linux/align.h>
 #include <linux/sort.h>
+#include <linux/log2.h>
 #include <asm/msr-index.h>
 #include <asm/msr.h>
 #include <asm/page.h>
@@ -878,6 +879,41 @@ static int construct_tdmrs(struct list_head *tmb_list,
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
 	struct tdsysinfo_struct *tdsysinfo;
@@ -933,16 +969,21 @@ static int init_tdx_module(void)
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
index 6987af46d096..b8c9e3d016f9 100644
--- a/arch/x86/virt/vmx/tdx/tdx.h
+++ b/arch/x86/virt/vmx/tdx/tdx.h
@@ -19,6 +19,7 @@
 #define TDH_SYS_INFO		32
 #define TDH_SYS_INIT		33
 #define TDH_SYS_LP_INIT		35
+#define TDH_SYS_CONFIG		45
 
 struct cmr_info {
 	u64	base;
@@ -85,6 +86,7 @@ struct tdmr_reserved_area {
 } __packed;
 
 #define TDMR_INFO_ALIGNMENT	512
+#define TDMR_INFO_PA_ARRAY_ALIGNMENT	512
 
 struct tdmr_info {
 	u64 base;
-- 
2.41.0

