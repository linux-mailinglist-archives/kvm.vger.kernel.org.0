Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3BF6160EC2E
	for <lists+kvm@lfdr.de>; Thu, 27 Oct 2022 01:18:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233731AbiJZXSq (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 26 Oct 2022 19:18:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59682 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233997AbiJZXSJ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 26 Oct 2022 19:18:09 -0400
Received: from mga09.intel.com (mga09.intel.com [134.134.136.24])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 71592BA257;
        Wed, 26 Oct 2022 16:17:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1666826266; x=1698362266;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=ZngkJ1hy62z1ZJ9j+OUr9HiZ6dC7QfTSzP7zLtYV5ys=;
  b=eGFaQhzgsOb9J0QM3Its9LN/b/FbPgY/3+ZRJBEGLU1ZHRM8putz1xhq
   +lpmkmlC0mw1Ep1qTG2dJIgb8a5MG/DMM5KcgNDG0GobkCW3cD2IXNQR/
   Venn3KPm5Z0ivPvIW2yGiN5HBD5RwkIen9g/dCi19GiiOqUaXo/kllCu4
   IltTOyEbb3p62GtkdWYLdj3pNUn0mOoD4QSPkbYrnyKCV0mjrrb1M0DeL
   XwwBNUfQ7NJbagKMT/5dmTefMB9/EEiv5dc0ZR+1uN4wCFwuvutIrI+U0
   qi86VFz8TCZU2KpvUh684+UdyvBu4WDfEAImqCfqai7cb6OcYK1Yp34v4
   A==;
X-IronPort-AV: E=McAfee;i="6500,9779,10512"; a="309175574"
X-IronPort-AV: E=Sophos;i="5.95,215,1661842800"; 
   d="scan'208";a="309175574"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Oct 2022 16:17:46 -0700
X-IronPort-AV: E=McAfee;i="6500,9779,10512"; a="737446374"
X-IronPort-AV: E=Sophos;i="5.95,215,1661842800"; 
   d="scan'208";a="737446374"
Received: from fordon1x-mobl.amr.corp.intel.com (HELO khuang2-desk.gar.corp.intel.com) ([10.212.24.177])
  by fmsmga002-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Oct 2022 16:17:41 -0700
From:   Kai Huang <kai.huang@intel.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     linux-mm@kvack.org, seanjc@google.com, pbonzini@redhat.com,
        dave.hansen@intel.com, dan.j.williams@intel.com,
        rafael.j.wysocki@intel.com, kirill.shutemov@linux.intel.com,
        reinette.chatre@intel.com, len.brown@intel.com,
        tony.luck@intel.com, peterz@infradead.org, ak@linux.intel.com,
        isaku.yamahata@intel.com, chao.gao@intel.com,
        sathyanarayanan.kuppuswamy@linux.intel.com, bagasdotme@gmail.com,
        sagis@google.com, imammedo@redhat.com, kai.huang@intel.com
Subject: [PATCH v6 11/21] x86/virt/tdx: Sanity check all TDX memory ranges are convertible memory
Date:   Thu, 27 Oct 2022 12:16:10 +1300
Message-Id: <27f99598d368dc24fbd2bdb9a79247a8dc3039e9.1666824663.git.kai.huang@intel.com>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <cover.1666824663.git.kai.huang@intel.com>
References: <cover.1666824663.git.kai.huang@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.9 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

All TDX-usable memory ranges were built during early kernel boot, and
they were not verified that they are truly convertible memory since CMRs
were not available until now.

Explicitly check all TDX memory ranges to make sure they are convertible
memory before passing those ranges to the TDX module.

Signed-off-by: Kai Huang <kai.huang@intel.com>
---

v5 -> v6:
 - Added a comment to explain two contiguous CMRs case (Isaku).
 - Rebase due to using 'tdx_memblock' to represent TDX memory, thus
   removed using memblock directly, and the handling of excluding
   first 1MB as TDX memory.

 v3 -> v4 (no feedback on v4):
 - Changed to use memblock from e820.
 - Simplified changelog a lot.

---
 arch/x86/virt/vmx/tdx/tdx.c | 61 +++++++++++++++++++++++++++++++++++++
 1 file changed, 61 insertions(+)

diff --git a/arch/x86/virt/vmx/tdx/tdx.c b/arch/x86/virt/vmx/tdx/tdx.c
index 7d7205615873..ff3ef7ed4509 100644
--- a/arch/x86/virt/vmx/tdx/tdx.c
+++ b/arch/x86/virt/vmx/tdx/tdx.c
@@ -483,6 +483,59 @@ static int tdx_get_sysinfo(void)
 	return check_cmrs(tdx_cmr_array, &tdx_cmr_num);
 }
 
+/* Check whether the first range is the subrange of the second */
+static bool is_subrange(u64 r1_start, u64 r1_end, u64 r2_start, u64 r2_end)
+{
+	return r1_start >= r2_start && r1_end <= r2_end;
+}
+
+/* Check whether the address range is covered by any CMR or not. */
+static bool range_covered_by_cmr(struct cmr_info *cmr_array, int cmr_num,
+				 u64 start, u64 end)
+{
+	int i;
+
+	for (i = 0; i < cmr_num; i++) {
+		struct cmr_info *cmr = &cmr_array[i];
+
+		if (is_subrange(start, end, cmr->base, cmr->base + cmr->size))
+			return true;
+	}
+
+	return false;
+}
+
+/*
+ * Check whether all memory regions in memblock are TDX convertible
+ * memory.  Return 0 if all memory regions are convertible, or error.
+ */
+static int sanity_check_tdx_memory(void)
+{
+	struct tdx_memblock *tmb;
+
+	list_for_each_entry(tmb, &tdx_memlist, list) {
+		u64 start = tmb->start_pfn << PAGE_SHIFT;
+		u64 end = tmb->end_pfn << PAGE_SHIFT;
+
+		/*
+		 * Note: The spec doesn't say two CMRs cannot be
+		 * contiguous.  Theoretically a memory region crossing
+		 * two contiguous CMRs (but still falls into the two
+		 * CMRs) should be treated as covered by CMR.  But this
+		 * is purely theoretically thing that doesn't occur in
+		 * practice.
+		 */
+		if (!range_covered_by_cmr(tdx_cmr_array, tdx_cmr_num, start,
+					end)) {
+			pr_err("[0x%llx, 0x%llx) is not fully convertible memory\n",
+					start, end);
+			return -EINVAL;
+		}
+	}
+
+	return 0;
+}
+
 /*
  * Detect and initialize the TDX module.
  *
@@ -511,6 +564,14 @@ static int init_tdx_module(void)
 	if (ret)
 		goto out;
 
+	/*
+	 * TDX memory ranges were built during kernel boot.  Need to
+	 * make sure all those ranges are truly convertible memory
+	 * before passing them to the TDX module.
+	 */
+	ret = sanity_check_tdx_memory();
+	if (ret)
+		goto out;
 	/*
 	 * Return -EINVAL until all steps of TDX module initialization
 	 * process are done.
-- 
2.37.3

