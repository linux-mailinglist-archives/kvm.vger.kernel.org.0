Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 95C516AC30A
	for <lists+kvm@lfdr.de>; Mon,  6 Mar 2023 15:21:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231378AbjCFOVM (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 6 Mar 2023 09:21:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55216 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231633AbjCFOUX (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 6 Mar 2023 09:20:23 -0500
Received: from mga09.intel.com (mga09.intel.com [134.134.136.24])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 52D592C64A;
        Mon,  6 Mar 2023 06:19:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1678112373; x=1709648373;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=q2ZzkvRd96FY3VJXKPI1qSfLMJtLptSGiDgztHPFXG0=;
  b=fu2eVjCOV5kET2FkRv2FZDjJCIBjxuV/w4jv1zlIEomcXjQYJAlGPHPS
   KjueSjuw+qOW6pBt3sdWFiV/lY89crN19TIVOPNW7cmz7Jin74qXwSTPQ
   Dv2cqKuVCTmJeU1YQUHASxOmqxnUnvWpqZAvB3oO5u8RQPYEbsdm1gUdV
   p8vb/7bVR/3aoMNQDXietYF59lf9eBoOSnQEf/0sTu40i0SVckQanE3Bh
   Ttqo4GGLGzPoaV+Y/uF4U81bhkU4C4EVCNne2bosRAaSgDMn7CrbmVtTT
   ERHBFKnuxTZ6YMS50ZBVRBxEB8szdVi742w5DmFYzb8r0ZNMp+B1CgQ3Y
   g==;
X-IronPort-AV: E=McAfee;i="6500,9779,10641"; a="337080263"
X-IronPort-AV: E=Sophos;i="5.98,238,1673942400"; 
   d="scan'208";a="337080263"
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Mar 2023 06:15:27 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10641"; a="765232461"
X-IronPort-AV: E=Sophos;i="5.98,238,1673942400"; 
   d="scan'208";a="765232461"
Received: from jwhisle1-mobl2.amr.corp.intel.com (HELO khuang2-desk.gar.corp.intel.com) ([10.212.92.57])
  by fmsmga003-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Mar 2023 06:15:23 -0800
From:   Kai Huang <kai.huang@intel.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     linux-mm@kvack.org, dave.hansen@intel.com, peterz@infradead.org,
        tglx@linutronix.de, seanjc@google.com, pbonzini@redhat.com,
        dan.j.williams@intel.com, rafael.j.wysocki@intel.com,
        kirill.shutemov@linux.intel.com, ying.huang@intel.com,
        reinette.chatre@intel.com, len.brown@intel.com,
        tony.luck@intel.com, ak@linux.intel.com, isaku.yamahata@intel.com,
        chao.gao@intel.com, sathyanarayanan.kuppuswamy@linux.intel.com,
        david@redhat.com, bagasdotme@gmail.com, sagis@google.com,
        imammedo@redhat.com, kai.huang@intel.com
Subject: [PATCH v10 12/16] x86/virt/tdx: Configure TDX module with the TDMRs and global KeyID
Date:   Tue,  7 Mar 2023 03:13:57 +1300
Message-Id: <1685ddaf26d80bc356cfe0d0d571d142293bbd34.1678111292.git.kai.huang@intel.com>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <cover.1678111292.git.kai.huang@intel.com>
References: <cover.1678111292.git.kai.huang@intel.com>
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

The TDX module uses a private KeyID as the "global KeyID" for mapping
things like the PAMT and other TDX metadata.  This KeyID has already
been reserved when detecting TDX during the kernel early boot.

After the list of "TD Memory Regions" (TDMRs) has been constructed to
cover all TDX-usable memory regions, the next step is to pass them to
the TDX module together with the global KeyID.

Signed-off-by: Kai Huang <kai.huang@intel.com>
Reviewed-by: Isaku Yamahata <isaku.yamahata@intel.com>
---

v9 -> v10:
 - Code change due to change static 'tdx_tdmr_list' to local 'tdmr_list'.

v8 -> v9:
 - Removed 'i.e.' in changelog and removed the passive voice (Dave).
 - Improved changelog (Dave).
 - Changed the way to allocate aligned PA array (Dave).
 - Moved reserving the TDX global KeyID to the second patch, and also
   changed 'tdx_keyid_start' and 'nr_tdx_keyid' to guest's KeyIDs in
   that patch (Dave).

v7 -> v8:
 - Merged "Reserve TDX module global KeyID" patch to this patch, and
   removed 'tdx_global_keyid' but use 'tdx_keyid_start' directly.
 - Changed changelog accordingly.
 - Changed how to allocate aligned array (Dave).

---
 arch/x86/virt/vmx/tdx/tdx.c | 41 ++++++++++++++++++++++++++++++++++++-
 arch/x86/virt/vmx/tdx/tdx.h |  2 ++
 2 files changed, 42 insertions(+), 1 deletion(-)

diff --git a/arch/x86/virt/vmx/tdx/tdx.c b/arch/x86/virt/vmx/tdx/tdx.c
index 99d2e8d939d3..28562cf88414 100644
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
@@ -1025,6 +1026,39 @@ static int construct_tdmrs(struct list_head *tmb_list,
 	return ret;
 }
 
+static int config_tdx_module(struct tdmr_info_list *tdmr_list, u64 global_keyid)
+{
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
+	ret = seamcall(TDH_SYS_CONFIG, __pa(tdmr_pa_array),
+				tdmr_list->nr_consumed_tdmrs,
+				global_keyid, 0, NULL, NULL);
+
+	/* Free the array as it is not required anymore. */
+	kfree(tdmr_pa_array);
+
+	return ret;
+}
+
 static int init_tdx_module(void)
 {
 	static DECLARE_PADDED_STRUCT(tdsysinfo_struct, tdsysinfo,
@@ -1065,10 +1099,14 @@ static int init_tdx_module(void)
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
@@ -1076,6 +1114,7 @@ static int init_tdx_module(void)
 	 */
 
 	ret = -EINVAL;
+out_free_pamts:
 	if (ret)
 		tdmrs_free_pamt_all(&tdmr_list);
 	else
diff --git a/arch/x86/virt/vmx/tdx/tdx.h b/arch/x86/virt/vmx/tdx/tdx.h
index 65fe34f21025..6cab15184af5 100644
--- a/arch/x86/virt/vmx/tdx/tdx.h
+++ b/arch/x86/virt/vmx/tdx/tdx.h
@@ -19,6 +19,7 @@
 #define TDH_SYS_INIT		33
 #define TDH_SYS_LP_INIT		35
 #define TDH_SYS_INFO		32
+#define TDH_SYS_CONFIG		45
 
 struct cmr_info {
 	u64	base;
@@ -95,6 +96,7 @@ struct tdmr_reserved_area {
 } __packed;
 
 #define TDMR_INFO_ALIGNMENT	512
+#define TDMR_INFO_PA_ARRAY_ALIGNMENT	512
 
 struct tdmr_info {
 	u64 base;
-- 
2.39.2

