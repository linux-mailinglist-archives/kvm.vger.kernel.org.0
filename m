Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CDB5A694520
	for <lists+kvm@lfdr.de>; Mon, 13 Feb 2023 13:03:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231400AbjBMMDZ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 13 Feb 2023 07:03:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38586 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230334AbjBMMC7 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 13 Feb 2023 07:02:59 -0500
Received: from mga01.intel.com (mga01.intel.com [192.55.52.88])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C37EF1A66A;
        Mon, 13 Feb 2023 04:02:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1676289743; x=1707825743;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=cPTXs6TistRhJL+86sIA6aP4IWCDYwochHr95MYjXrw=;
  b=iptv0ecoB34Jcl2bXIGXLCJyBlJUeHb1CCpxTetARfDZa56jCf1C7i0U
   6ekuLpjwhL71Wr18zZkBnth0MyP4NTSD4VbhnoPpTJzPK+RymgQOJ+OU8
   2PAm3nQZHNWnVgKdKpagSOXwlPw5XQ63lyiA6ehWvBIiSfxf9t1oiz17O
   h+RIC5lL20EtaclzZCOoZm8z06BtOBL1b+7BjkYK/q/WrVvwO5/YbAtOo
   851p115D4fekGIk6HTEcIqCXWnVlxKBBKuGvuzDN06PkQJRVb25Y5CJRW
   MRfaEelQuv88zPCTcDZfsipjnQX9bVhEm4eEZOEUt6pXCnp68CGp8ex3+
   A==;
X-IronPort-AV: E=McAfee;i="6500,9779,10619"; a="358283428"
X-IronPort-AV: E=Sophos;i="5.97,293,1669104000"; 
   d="scan'208";a="358283428"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Feb 2023 04:01:21 -0800
X-IronPort-AV: E=McAfee;i="6500,9779,10619"; a="701243473"
X-IronPort-AV: E=Sophos;i="5.97,293,1669104000"; 
   d="scan'208";a="701243473"
Received: from wonger-mobl.amr.corp.intel.com (HELO khuang2-desk.gar.corp.intel.com) ([10.209.188.34])
  by orsmga001-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Feb 2023 04:01:16 -0800
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
Subject: [PATCH v9 13/18] x86/virt/tdx: Designate reserved areas for all TDMRs
Date:   Tue, 14 Feb 2023 00:59:20 +1300
Message-Id: <5c2c0fbc422223470c5b38ff86e1b9e3dd81e22e.1676286526.git.kai.huang@intel.com>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <cover.1676286526.git.kai.huang@intel.com>
References: <cover.1676286526.git.kai.huang@intel.com>
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

As the last step of constructing TDMRs, populate reserved areas for all
TDMRs.  For each TDMR, put all memory holes within this TDMR to the
reserved areas.  And for all PAMTs which overlap with this TDMR, put
all the overlapping parts to reserved areas too.

Signed-off-by: Kai Huang <kai.huang@intel.com>
Reviewed-by: Isaku Yamahata <isaku.yamahata@intel.com>
---

v8 -> v9:
 - Added comment around 'tdmr_add_rsvd_area()' to point out it doesn't do
   optimization to save reserved areas. (Dave).

v7 -> v8: (Dave)
 - "set_up" -> "populate" in function name change (Dave).
 - Improved comment suggested by Dave.
 - Other changes due to 'struct tdmr_info_list'.

v6 -> v7:
 - No change.

v5 -> v6:
 - Rebase due to using 'tdx_memblock' instead of memblock.
 - Split tdmr_set_up_rsvd_areas() into two functions to handle memory
   hole and PAMT respectively.
 - Added Isaku's Reviewed-by.


---
 arch/x86/virt/vmx/tdx/tdx.c | 220 ++++++++++++++++++++++++++++++++++--
 1 file changed, 212 insertions(+), 8 deletions(-)

diff --git a/arch/x86/virt/vmx/tdx/tdx.c b/arch/x86/virt/vmx/tdx/tdx.c
index ce71a3ef86d3..34aed2aa9f4b 100644
--- a/arch/x86/virt/vmx/tdx/tdx.c
+++ b/arch/x86/virt/vmx/tdx/tdx.c
@@ -23,6 +23,7 @@
 #include <linux/sizes.h>
 #include <linux/pfn.h>
 #include <linux/align.h>
+#include <linux/sort.h>
 #include <asm/msr-index.h>
 #include <asm/msr.h>
 #include <asm/page.h>
@@ -764,6 +765,210 @@ static unsigned long tdmrs_count_pamt_pages(struct tdmr_info_list *tdmr_list)
 	return pamt_npages;
 }
 
+static int tdmr_add_rsvd_area(struct tdmr_info *tdmr, int *p_idx, u64 addr,
+			      u64 size, u16 max_reserved_per_tdmr)
+{
+	struct tdmr_reserved_area *rsvd_areas = tdmr->reserved_areas;
+	int idx = *p_idx;
+
+	/* Reserved area must be 4K aligned in offset and size */
+	if (WARN_ON(addr & ~PAGE_MASK || size & ~PAGE_MASK))
+		return -EINVAL;
+
+	if (idx >= max_reserved_per_tdmr) {
+		pr_warn("initialization failed: TDMR [0x%llx, 0x%llx): reserved areas exhausted.\n",
+				tdmr->base, tdmr_end(tdmr));
+		return -ENOSPC;
+	}
+
+	/*
+	 * Consume one reserved area per call.  Make no effort to
+	 * optimize or reduce the number of reserved areas which are
+	 * consumed by contiguous reserved areas, for instance.
+	 */
+	rsvd_areas[idx].offset = addr - tdmr->base;
+	rsvd_areas[idx].size = size;
+
+	*p_idx = idx + 1;
+
+	return 0;
+}
+
+/*
+ * Go through @tmb_list to find holes between memory areas.  If any of
+ * those holes fall within @tdmr, set up a TDMR reserved area to cover
+ * the hole.
+ */
+static int tdmr_populate_rsvd_holes(struct list_head *tmb_list,
+				    struct tdmr_info *tdmr,
+				    int *rsvd_idx,
+				    u16 max_reserved_per_tdmr)
+{
+	struct tdx_memblock *tmb;
+	u64 prev_end;
+	int ret;
+
+	/*
+	 * Start looking for reserved blocks at the
+	 * beginning of the TDMR.
+	 */
+	prev_end = tdmr->base;
+	list_for_each_entry(tmb, tmb_list, list) {
+		u64 start, end;
+
+		start = PFN_PHYS(tmb->start_pfn);
+		end   = PFN_PHYS(tmb->end_pfn);
+
+		/* Break if this region is after the TDMR */
+		if (start >= tdmr_end(tdmr))
+			break;
+
+		/* Exclude regions before this TDMR */
+		if (end < tdmr->base)
+			continue;
+
+		/*
+		 * Skip over memory areas that
+		 * have already been dealt with.
+		 */
+		if (start <= prev_end) {
+			prev_end = end;
+			continue;
+		}
+
+		/* Add the hole before this region */
+		ret = tdmr_add_rsvd_area(tdmr, rsvd_idx, prev_end,
+				start - prev_end,
+				max_reserved_per_tdmr);
+		if (ret)
+			return ret;
+
+		prev_end = end;
+	}
+
+	/* Add the hole after the last region if it exists. */
+	if (prev_end < tdmr_end(tdmr)) {
+		ret = tdmr_add_rsvd_area(tdmr, rsvd_idx, prev_end,
+				tdmr_end(tdmr) - prev_end,
+				max_reserved_per_tdmr);
+		if (ret)
+			return ret;
+	}
+
+	return 0;
+}
+
+/*
+ * Go through @tdmr_list to find all PAMTs.  If any of those PAMTs
+ * overlaps with @tdmr, set up a TDMR reserved area to cover the
+ * overlapping part.
+ */
+static int tdmr_populate_rsvd_pamts(struct tdmr_info_list *tdmr_list,
+				    struct tdmr_info *tdmr,
+				    int *rsvd_idx,
+				    u16 max_reserved_per_tdmr)
+{
+	int i, ret;
+
+	for (i = 0; i < tdmr_list->nr_consumed_tdmrs; i++) {
+		struct tdmr_info *tmp = tdmr_entry(tdmr_list, i);
+		unsigned long pamt_start_pfn, pamt_npages;
+		u64 pamt_start, pamt_end;
+
+		tdmr_get_pamt(tmp, &pamt_start_pfn, &pamt_npages);
+		/* Each TDMR must already have PAMT allocated */
+		WARN_ON_ONCE(!pamt_npages || !pamt_start_pfn);
+
+		pamt_start = PFN_PHYS(pamt_start_pfn);
+		pamt_end   = PFN_PHYS(pamt_start_pfn + pamt_npages);
+
+		/* Skip PAMTs outside of the given TDMR */
+		if ((pamt_end <= tdmr->base) ||
+				(pamt_start >= tdmr_end(tdmr)))
+			continue;
+
+		/* Only mark the part within the TDMR as reserved */
+		if (pamt_start < tdmr->base)
+			pamt_start = tdmr->base;
+		if (pamt_end > tdmr_end(tdmr))
+			pamt_end = tdmr_end(tdmr);
+
+		ret = tdmr_add_rsvd_area(tdmr, rsvd_idx, pamt_start,
+				pamt_end - pamt_start,
+				max_reserved_per_tdmr);
+		if (ret)
+			return ret;
+	}
+
+	return 0;
+}
+
+/* Compare function called by sort() for TDMR reserved areas */
+static int rsvd_area_cmp_func(const void *a, const void *b)
+{
+	struct tdmr_reserved_area *r1 = (struct tdmr_reserved_area *)a;
+	struct tdmr_reserved_area *r2 = (struct tdmr_reserved_area *)b;
+
+	if (r1->offset + r1->size <= r2->offset)
+		return -1;
+	if (r1->offset >= r2->offset + r2->size)
+		return 1;
+
+	/* Reserved areas cannot overlap.  The caller must guarantee. */
+	WARN_ON_ONCE(1);
+	return -1;
+}
+
+/*
+ * Populate reserved areas for the given @tdmr, including memory holes
+ * (via @tmb_list) and PAMTs (via @tdmr_list).
+ */
+static int tdmr_populate_rsvd_areas(struct tdmr_info *tdmr,
+				    struct list_head *tmb_list,
+				    struct tdmr_info_list *tdmr_list,
+				    u16 max_reserved_per_tdmr)
+{
+	int ret, rsvd_idx = 0;
+
+	ret = tdmr_populate_rsvd_holes(tmb_list, tdmr, &rsvd_idx,
+			max_reserved_per_tdmr);
+	if (ret)
+		return ret;
+
+	ret = tdmr_populate_rsvd_pamts(tdmr_list, tdmr, &rsvd_idx,
+			max_reserved_per_tdmr);
+	if (ret)
+		return ret;
+
+	/* TDX requires reserved areas listed in address ascending order */
+	sort(tdmr->reserved_areas, rsvd_idx, sizeof(struct tdmr_reserved_area),
+			rsvd_area_cmp_func, NULL);
+
+	return 0;
+}
+
+/*
+ * Populate reserved areas for all TDMRs in @tdmr_list, including memory
+ * holes (via @tmb_list) and PAMTs.
+ */
+static int tdmrs_populate_rsvd_areas_all(struct tdmr_info_list *tdmr_list,
+					 struct list_head *tmb_list,
+					 u16 max_reserved_per_tdmr)
+{
+	int i;
+
+	for (i = 0; i < tdmr_list->nr_consumed_tdmrs; i++) {
+		int ret;
+
+		ret = tdmr_populate_rsvd_areas(tdmr_entry(tdmr_list, i),
+				tmb_list, tdmr_list, max_reserved_per_tdmr);
+		if (ret)
+			return ret;
+	}
+
+	return 0;
+}
+
 /*
  * Construct a list of TDMRs on the preallocated space in @tdmr_list
  * to cover all TDX memory regions in @tmb_list based on the TDX module
@@ -783,14 +988,13 @@ static int construct_tdmrs(struct list_head *tmb_list,
 			sysinfo->pamt_entry_size);
 	if (ret)
 		return ret;
-	/*
-	 * TODO:
-	 *
-	 *  - Designate reserved areas for each TDMR.
-	 *
-	 * Return -EINVAL until constructing TDMRs is done
-	 */
-	return -EINVAL;
+
+	ret = tdmrs_populate_rsvd_areas_all(tdmr_list, tmb_list,
+			sysinfo->max_reserved_per_tdmr);
+	if (ret)
+		tdmrs_free_pamt_all(tdmr_list);
+
+	return ret;
 }
 
 static int init_tdx_module(void)
-- 
2.39.1

