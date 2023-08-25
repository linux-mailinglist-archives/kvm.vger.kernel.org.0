Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5B0DD7886DB
	for <lists+kvm@lfdr.de>; Fri, 25 Aug 2023 14:16:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244741AbjHYMQc (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 25 Aug 2023 08:16:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53076 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244618AbjHYMQN (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 25 Aug 2023 08:16:13 -0400
Received: from mgamail.intel.com (mgamail.intel.com [134.134.136.31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A48C1E6B;
        Fri, 25 Aug 2023 05:16:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1692965770; x=1724501770;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=Id8uT34pzre7Kj4w76legMiqdok7NHLz0sqDNhd6HE8=;
  b=lqFdQtID8CLApqcK9ppYlTcZA0m7eUR61vUfJeNZmpm2AHjyGSQ4qW7o
   ke4eBHR8MADkvtvG0Xwki42Dlr7156Ohqm+dlYaFCYDuwUnj0cuXlQIgU
   f+jVOuxkC3ht9QWWvmQ3whnU2T5Ss11vX585syTDoRD+nNxXwoUa7Z+p6
   hSUN/KCWLzHe3UcCpEeDWFTK8ek24cDrkdF0f+inunA8w9sEMP9vEj1W2
   Ksxyt3GgyycdPFFYKnzIHgrkXqeo0J4ZE9Su2+3z+ljZ8J0ny9VrNRzYS
   sAsxeYZArEyZ7zrGMZ0eL89QDIdSzwTRwSZvqBwkaSvEPVoJ3HOGrvx1S
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10812"; a="438639373"
X-IronPort-AV: E=Sophos;i="6.02,195,1688454000"; 
   d="scan'208";a="438639373"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Aug 2023 05:16:10 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.01,202,1684825200"; 
   d="scan'208";a="881158522"
Received: from vnaikawa-mobl1.amr.corp.intel.com (HELO khuang2-desk.gar.corp.intel.com) ([10.209.185.177])
  by fmsmga001-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Aug 2023 05:16:08 -0700
From:   Kai Huang <kai.huang@intel.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     x86@kernel.org, dave.hansen@intel.com,
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
Subject: [PATCH v13 13/22] x86/virt/tdx: Designate reserved areas for all TDMRs
Date:   Sat, 26 Aug 2023 00:14:32 +1200
Message-ID: <d9af25244b465a0d762ac7d78118fab858338ba4.1692962263.git.kai.huang@intel.com>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <cover.1692962263.git.kai.huang@intel.com>
References: <cover.1692962263.git.kai.huang@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
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
Reviewed-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Reviewed-by: Yuan Yao <yuan.yao@intel.com>
---

v12 -> v13:
 - Added Yuan's tag.

v11 -> v12:
 - Code change due to tdmr_get_pamt() change from returning pfn/npages to
   base/size
 - Added Kirill's tag

v10 -> v11:
 - No update

v9 -> v10:
 - No change.

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
 arch/x86/virt/vmx/tdx/tdx.c | 217 ++++++++++++++++++++++++++++++++++--
 1 file changed, 209 insertions(+), 8 deletions(-)

diff --git a/arch/x86/virt/vmx/tdx/tdx.c b/arch/x86/virt/vmx/tdx/tdx.c
index 0ff83883ae68..9173d9798231 100644
--- a/arch/x86/virt/vmx/tdx/tdx.c
+++ b/arch/x86/virt/vmx/tdx/tdx.c
@@ -25,6 +25,7 @@
 #include <linux/sizes.h>
 #include <linux/pfn.h>
 #include <linux/align.h>
+#include <linux/sort.h>
 #include <asm/msr-index.h>
 #include <asm/msr.h>
 #include <asm/page.h>
@@ -670,6 +671,207 @@ static unsigned long tdmrs_count_pamt_kb(struct tdmr_info_list *tdmr_list)
 	return pamt_size / 1024;
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
+		unsigned long pamt_base, pamt_size, pamt_end;
+
+		tdmr_get_pamt(tmp, &pamt_base, &pamt_size);
+		/* Each TDMR must already have PAMT allocated */
+		WARN_ON_ONCE(!pamt_size || !pamt_base);
+
+		pamt_end = pamt_base + pamt_size;
+		/* Skip PAMTs outside of the given TDMR */
+		if ((pamt_end <= tdmr->base) ||
+				(pamt_base >= tdmr_end(tdmr)))
+			continue;
+
+		/* Only mark the part within the TDMR as reserved */
+		if (pamt_base < tdmr->base)
+			pamt_base = tdmr->base;
+		if (pamt_end > tdmr_end(tdmr))
+			pamt_end = tdmr_end(tdmr);
+
+		ret = tdmr_add_rsvd_area(tdmr, rsvd_idx, pamt_base,
+				pamt_end - pamt_base,
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
@@ -689,14 +891,13 @@ static int construct_tdmrs(struct list_head *tmb_list,
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
2.41.0

