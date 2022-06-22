Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5C3E75549AA
	for <lists+kvm@lfdr.de>; Wed, 22 Jun 2022 14:17:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1357636AbiFVLTl (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 22 Jun 2022 07:19:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56472 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1357563AbiFVLTP (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 22 Jun 2022 07:19:15 -0400
Received: from mga01.intel.com (mga01.intel.com [192.55.52.88])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 60CE03C73F;
        Wed, 22 Jun 2022 04:18:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1655896687; x=1687432687;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=3JGxoe6NHexl//cHqZzIWIKFvcAtKyhn1DljxO9aurQ=;
  b=ZreCxMPSEdhDPf0yAvfKhQqEliGH+I8epmtCnye1iIzo0hNky424Xq0h
   UooyAx9QEAQTTSVNLMnOU6c95lSJWfGD0P7/b/+aH1ToeRv1v7cpLQFYN
   BAZJBauNNoUMQ2utvy8Cue8SbJaAYMRrYlwRBal+ZN0unwOr6abWPiJDg
   qNc+bPjmh1ewdsJlEQNOP12+qGu+Nk3Sn881eBsFjLlrYH2AwEk2GOGeA
   aQJZiznZ3TWLLR+T8mRSeCNBdcf/DEOLtI538s6qS41JtWpTK5i8ZJiHZ
   Cdt52taNBQUEaAf6Es+wXeM2nRMRRn28/DGH+hFMMMsPcFMhwTu0GenuH
   Q==;
X-IronPort-AV: E=McAfee;i="6400,9594,10385"; a="305841127"
X-IronPort-AV: E=Sophos;i="5.92,212,1650956400"; 
   d="scan'208";a="305841127"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Jun 2022 04:17:39 -0700
X-IronPort-AV: E=Sophos;i="5.92,212,1650956400"; 
   d="scan'208";a="730302302"
Received: from jmatsis-mobl.amr.corp.intel.com (HELO khuang2-desk.gar.corp.intel.com) ([10.209.178.197])
  by fmsmga001-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Jun 2022 04:17:36 -0700
From:   Kai Huang <kai.huang@intel.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     seanjc@google.com, pbonzini@redhat.com, dave.hansen@intel.com,
        len.brown@intel.com, tony.luck@intel.com,
        rafael.j.wysocki@intel.com, reinette.chatre@intel.com,
        dan.j.williams@intel.com, peterz@infradead.org, ak@linux.intel.com,
        kirill.shutemov@linux.intel.com,
        sathyanarayanan.kuppuswamy@linux.intel.com,
        isaku.yamahata@intel.com, kai.huang@intel.com
Subject: [PATCH v5 16/22] x86/virt/tdx: Set up reserved areas for all TDMRs
Date:   Wed, 22 Jun 2022 23:17:05 +1200
Message-Id: <984ae2b9201876e9ac22399cf36d26ad6eff1007.1655894131.git.kai.huang@intel.com>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <cover.1655894131.git.kai.huang@intel.com>
References: <cover.1655894131.git.kai.huang@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

As the last step of constructing TDMRs, set up reserved areas for all
TDMRs.  For each TDMR, put all memory holes within this TDMR to the
reserved areas.  And for all PAMTs which overlap with this TDMR, put
all the overlapping parts to reserved areas too.

Signed-off-by: Kai Huang <kai.huang@intel.com>
---
 arch/x86/virt/vmx/tdx/tdx.c | 160 +++++++++++++++++++++++++++++++++++-
 1 file changed, 158 insertions(+), 2 deletions(-)

diff --git a/arch/x86/virt/vmx/tdx/tdx.c b/arch/x86/virt/vmx/tdx/tdx.c
index 36260dd7e69f..86d98c47bd37 100644
--- a/arch/x86/virt/vmx/tdx/tdx.c
+++ b/arch/x86/virt/vmx/tdx/tdx.c
@@ -19,6 +19,7 @@
 #include <linux/memblock.h>
 #include <linux/gfp.h>
 #include <linux/align.h>
+#include <linux/sort.h>
 #include <asm/cpufeatures.h>
 #include <asm/cpufeature.h>
 #include <asm/msr-index.h>
@@ -748,6 +749,157 @@ static unsigned long tdmrs_get_pamt_pages(struct tdmr_info *tdmr_array,
 	return pamt_npages;
 }
 
+static int tdmr_add_rsvd_area(struct tdmr_info *tdmr, int *p_idx,
+			      u64 addr, u64 size)
+{
+	struct tdmr_reserved_area *rsvd_areas = tdmr->reserved_areas;
+	int idx = *p_idx;
+
+	/* Reserved area must be 4K aligned in offset and size */
+	if (WARN_ON(addr & ~PAGE_MASK || size & ~PAGE_MASK))
+		return -EINVAL;
+
+	/* Cannot exceed maximum reserved areas supported by TDX */
+	if (idx >= tdx_sysinfo.max_reserved_per_tdmr)
+		return -E2BIG;
+
+	rsvd_areas[idx].offset = addr - tdmr->base;
+	rsvd_areas[idx].size = size;
+
+	*p_idx = idx + 1;
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
+	/* Reserved areas cannot overlap.  Caller should guarantee. */
+	WARN_ON_ONCE(1);
+	return -1;
+}
+
+/* Set up reserved areas for a TDMR, including memory holes and PAMTs */
+static int tdmr_set_up_rsvd_areas(struct tdmr_info *tdmr,
+				  struct tdmr_info *tdmr_array,
+				  int tdmr_num)
+{
+	unsigned long start_pfn, end_pfn;
+	int rsvd_idx, i, ret = 0;
+	u64 prev_end;
+
+	/* Mark holes between memory regions as reserved */
+	rsvd_idx = 0;
+	prev_end = tdmr_start(tdmr);
+	memblock_for_each_tdx_mem_pfn_range(i, &start_pfn, &end_pfn, NULL) {
+		u64 start, end;
+
+		start = start_pfn << PAGE_SHIFT;
+		end = end_pfn << PAGE_SHIFT;
+
+		/* Break if this region is after the TDMR */
+		if (start >= tdmr_end(tdmr))
+			break;
+
+		/* Exclude regions before this TDMR */
+		if (end < tdmr_start(tdmr))
+			continue;
+
+		/*
+		 * Skip if no hole exists before this region. "<=" is
+		 * used because one memory region might span two TDMRs
+		 * (when the previous TDMR covers part of this region).
+		 * In this case the start address of this region is
+		 * smaller than the start address of the second TDMR.
+		 *
+		 * Update the prev_end to the end of this region where
+		 * the possible memory hole starts.
+		 */
+		if (start <= prev_end) {
+			prev_end = end;
+			continue;
+		}
+
+		/* Add the hole before this region */
+		ret = tdmr_add_rsvd_area(tdmr, &rsvd_idx, prev_end,
+				start - prev_end);
+		if (ret)
+			return ret;
+
+		prev_end = end;
+	}
+
+	/* Add the hole after the last region if it exists. */
+	if (prev_end < tdmr_end(tdmr)) {
+		ret = tdmr_add_rsvd_area(tdmr, &rsvd_idx, prev_end,
+				tdmr_end(tdmr) - prev_end);
+		if (ret)
+			return ret;
+	}
+
+	/*
+	 * If any PAMT overlaps with this TDMR, the overlapping part
+	 * must also be put to the reserved area too.  Walk over all
+	 * TDMRs to find out those overlapping PAMTs and put them to
+	 * reserved areas.
+	 */
+	for (i = 0; i < tdmr_num; i++) {
+		struct tdmr_info *tmp = tdmr_array_entry(tdmr_array, i);
+		u64 pamt_start, pamt_end;
+
+		pamt_start = tmp->pamt_4k_base;
+		pamt_end = pamt_start + tmp->pamt_4k_size +
+			tmp->pamt_2m_size + tmp->pamt_1g_size;
+
+		/* Skip PAMTs outside of the given TDMR */
+		if ((pamt_end <= tdmr_start(tdmr)) ||
+				(pamt_start >= tdmr_end(tdmr)))
+			continue;
+
+		/* Only mark the part within the TDMR as reserved */
+		if (pamt_start < tdmr_start(tdmr))
+			pamt_start = tdmr_start(tdmr);
+		if (pamt_end > tdmr_end(tdmr))
+			pamt_end = tdmr_end(tdmr);
+
+		ret = tdmr_add_rsvd_area(tdmr, &rsvd_idx, pamt_start,
+				pamt_end - pamt_start);
+		if (ret)
+			return ret;
+	}
+
+	/* TDX requires reserved areas listed in address ascending order */
+	sort(tdmr->reserved_areas, rsvd_idx, sizeof(struct tdmr_reserved_area),
+			rsvd_area_cmp_func, NULL);
+
+	return 0;
+}
+
+static int tdmrs_set_up_rsvd_areas_all(struct tdmr_info *tdmr_array,
+				      int tdmr_num)
+{
+	int i;
+
+	for (i = 0; i < tdmr_num; i++) {
+		int ret;
+
+		ret = tdmr_set_up_rsvd_areas(tdmr_array_entry(tdmr_array, i),
+				tdmr_array, tdmr_num);
+		if (ret)
+			return ret;
+	}
+
+	return 0;
+}
+
 /*
  * Construct an array of TDMRs to cover all memory regions in memblock.
  * This makes sure all pages managed by the page allocator are TDX
@@ -766,8 +918,12 @@ static int construct_tdmrs_memeblock(struct tdmr_info *tdmr_array,
 	if (ret)
 		goto err;
 
-	/* Return -EINVAL until constructing TDMRs is done */
-	ret = -EINVAL;
+	ret = tdmrs_set_up_rsvd_areas_all(tdmr_array, *tdmr_num);
+	if (ret)
+		goto err_free_pamts;
+
+	return 0;
+err_free_pamts:
 	tdmrs_free_pamt_all(tdmr_array, *tdmr_num);
 err:
 	return ret;
-- 
2.36.1

