Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 333AA7217C7
	for <lists+kvm@lfdr.de>; Sun,  4 Jun 2023 16:31:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232280AbjFDOa7 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 4 Jun 2023 10:30:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51484 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231839AbjFDOam (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 4 Jun 2023 10:30:42 -0400
Received: from mga11.intel.com (mga11.intel.com [192.55.52.93])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E8DCB197;
        Sun,  4 Jun 2023 07:30:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1685889033; x=1717425033;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=qGQvFPVJ/ZwcN4vwiSuVz3EM9zDZOkjR9z0WgIqkt7s=;
  b=QlhOXkcJAYaXYrMmGOK+uQ2qmIUqloovRhwbkWw1G+fhYYDsZS7Kc31x
   q4k217hgRoGa06PZG+Ru+shAcwJGrmf3ov1TvPWygVtF0gHjeRiwZNDbk
   uLFMCCsXiJD/oldsEMKsgI4b3WOu2Wx9YSOs/PFXBS2glDPko4O6HjTop
   sid43hnNH4k1yE91E9tg6ryA6xbtEpUt8RKqLOyIbfMtJ89pBvMsFSO5K
   kWXv5GP+tsFE/ZMeJckgxbhZOqFD7h8CdSGzHsJnnEl36vlwiqonmd5qH
   NIVjji05QfngKCGYaoTL+z70EaQPicVM3MNLLaLxiIZUhiCT2fwtTLYNs
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10731"; a="353683645"
X-IronPort-AV: E=Sophos;i="6.00,217,1681196400"; 
   d="scan'208";a="353683645"
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Jun 2023 07:29:05 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10731"; a="1038501155"
X-IronPort-AV: E=Sophos;i="6.00,217,1681196400"; 
   d="scan'208";a="1038501155"
Received: from tdhastx-mobl2.amr.corp.intel.com (HELO khuang2-desk.gar.corp.intel.com) ([10.212.50.31])
  by fmsmga005-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Jun 2023 07:29:00 -0700
From:   Kai Huang <kai.huang@intel.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     linux-mm@kvack.org, dave.hansen@intel.com,
        kirill.shutemov@linux.intel.com, tony.luck@intel.com,
        peterz@infradead.org, tglx@linutronix.de, seanjc@google.com,
        pbonzini@redhat.com, david@redhat.com, dan.j.williams@intel.com,
        rafael.j.wysocki@intel.com, ying.huang@intel.com,
        reinette.chatre@intel.com, len.brown@intel.com, ak@linux.intel.com,
        isaku.yamahata@intel.com, chao.gao@intel.com,
        sathyanarayanan.kuppuswamy@linux.intel.com, bagasdotme@gmail.com,
        sagis@google.com, imammedo@redhat.com, kai.huang@intel.com
Subject: [PATCH v11 14/20] x86/virt/tdx: Configure TDX module with the TDMRs and global KeyID
Date:   Mon,  5 Jun 2023 02:27:27 +1200
Message-Id: <4e6cd933edd2501147366df7a17e1087560a4320.1685887183.git.kai.huang@intel.com>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <cover.1685887183.git.kai.huang@intel.com>
References: <cover.1685887183.git.kai.huang@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
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
 arch/x86/virt/vmx/tdx/tdx.c | 41 ++++++++++++++++++++++++++++++++++++-
 arch/x86/virt/vmx/tdx/tdx.h |  2 ++
 2 files changed, 42 insertions(+), 1 deletion(-)

diff --git a/arch/x86/virt/vmx/tdx/tdx.c b/arch/x86/virt/vmx/tdx/tdx.c
index 0c2dedbc074c..6222a1456ca4 100644
--- a/arch/x86/virt/vmx/tdx/tdx.c
+++ b/arch/x86/virt/vmx/tdx/tdx.c
@@ -26,6 +26,7 @@
 #include <linux/pfn.h>
 #include <linux/align.h>
 #include <linux/sort.h>
+#include <linux/log2.h>
 #include <asm/msr-index.h>
 #include <asm/msr.h>
 #include <asm/archrandom.h>
@@ -902,6 +903,39 @@ static int construct_tdmrs(struct list_head *tmb_list,
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
@@ -941,16 +975,21 @@ static int init_tdx_module(void)
 	if (ret)
 		goto out_free_tdmrs;
 
+	/* Pass the TDMRs and the global KeyID to the TDX module */
+	ret = config_tdx_module(&tdx_tdmr_list, tdx_global_keyid);
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
 		tdmrs_free_pamt_all(&tdx_tdmr_list);
 	else
diff --git a/arch/x86/virt/vmx/tdx/tdx.h b/arch/x86/virt/vmx/tdx/tdx.h
index e8110e1a9980..7baf0d662b50 100644
--- a/arch/x86/virt/vmx/tdx/tdx.h
+++ b/arch/x86/virt/vmx/tdx/tdx.h
@@ -24,6 +24,7 @@
 #define TDH_SYS_INIT		33
 #define TDH_SYS_LP_INIT		35
 #define TDH_SYS_INFO		32
+#define TDH_SYS_CONFIG		45
 
 struct cmr_info {
 	u64	base;
@@ -100,6 +101,7 @@ struct tdmr_reserved_area {
 } __packed;
 
 #define TDMR_INFO_ALIGNMENT	512
+#define TDMR_INFO_PA_ARRAY_ALIGNMENT	512
 
 struct tdmr_info {
 	u64 base;
-- 
2.40.1

