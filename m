Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AB71860EC36
	for <lists+kvm@lfdr.de>; Thu, 27 Oct 2022 01:19:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233965AbiJZXTR (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 26 Oct 2022 19:19:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59672 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229456AbiJZXSm (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 26 Oct 2022 19:18:42 -0400
Received: from mga09.intel.com (mga09.intel.com [134.134.136.24])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DD850C694F;
        Wed, 26 Oct 2022 16:18:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1666826282; x=1698362282;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=TR56OM4CfmVGYfY6LIC91MQ2Q91e8LDcsPGGWUQt60E=;
  b=Sglv5IDJDK60UmDlwqeTt+Ez9T9UATppT5QMkNCUtIKFacw21IZBAyln
   MKrhyp/ldNMNNymYkAR25UF/YtUjXYB4oe83w8vreWipE/Ksu/qnGgsNg
   oCPaJgR8G4rd7ELhHlstMVhpV0GSFqK3Y6NjDlFHWDQeHRbaYFwLZQJLE
   kxjQ+Z8emunmtk1YGjxXi4pwahDfKNUJo3wLxrTBTAI9PdEmWTdmeRVmW
   AvCcAXBnNb7D5piygCoBJvz0Bc0ck5rQpaMc57ufJhjBUCbDv61s5Xtrf
   plA+O15eabqdztzJodYfq6QBX2GlBZ7kd5Tjg8HfIqXmdXMyLhPclZYyq
   A==;
X-IronPort-AV: E=McAfee;i="6500,9779,10512"; a="309175616"
X-IronPort-AV: E=Sophos;i="5.95,215,1661842800"; 
   d="scan'208";a="309175616"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Oct 2022 16:18:02 -0700
X-IronPort-AV: E=McAfee;i="6500,9779,10512"; a="737446464"
X-IronPort-AV: E=Sophos;i="5.95,215,1661842800"; 
   d="scan'208";a="737446464"
Received: from fordon1x-mobl.amr.corp.intel.com (HELO khuang2-desk.gar.corp.intel.com) ([10.212.24.177])
  by fmsmga002-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Oct 2022 16:17:58 -0700
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
Subject: [PATCH v6 15/21] x86/virt/tdx: Set up reserved areas for all TDMRs
Date:   Thu, 27 Oct 2022 12:16:14 +1300
Message-Id: <babddabb3cb4363f61ae8c102eae129f5601aaae.1666824663.git.kai.huang@intel.com>
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

As the last step of constructing TDMRs, set up reserved areas for all
TDMRs.  For each TDMR, put all memory holes within this TDMR to the
reserved areas.  And for all PAMTs which overlap with this TDMR, put
all the overlapping parts to reserved areas too.

Reviewed-by: Isaku Yamahata <isaku.yamahata@intel.com>
Signed-off-by: Kai Huang <kai.huang@intel.com>
---

v5 -> v6:
 - Rebase due to using 'tdx_memblock' instead of memblock.
 - Split tdmr_set_up_rsvd_areas() into two functions to handle memory
   hole and PAMT respectively.
 - Added Isaku's Reviewed-by.

---
 arch/x86/virt/vmx/tdx/tdx.c | 190 +++++++++++++++++++++++++++++++++++-
 1 file changed, 188 insertions(+), 2 deletions(-)

diff --git a/arch/x86/virt/vmx/tdx/tdx.c b/arch/x86/virt/vmx/tdx/tdx.c
index f7142f45bb0c..5d74ada072ca 100644
--- a/arch/x86/virt/vmx/tdx/tdx.c
+++ b/arch/x86/virt/vmx/tdx/tdx.c
@@ -19,6 +19,7 @@
 #include <linux/gfp.h>
 #include <linux/align.h>
 #include <linux/atomic.h>
+#include <linux/sort.h>
 #include <asm/msr-index.h>
 #include <asm/msr.h>
 #include <asm/apic.h>
@@ -852,6 +853,187 @@ static unsigned long tdmrs_count_pamt_pages(struct tdmr_info *tdmr_array,
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
+static int tdmr_set_up_memory_hole_rsvd_areas(struct tdmr_info *tdmr,
+					      int *rsvd_idx)
+{
+	struct tdx_memblock *tmb;
+	u64 prev_end;
+	int ret;
+
+	/* Mark holes between memory regions as reserved */
+	prev_end = tdmr_start(tdmr);
+	list_for_each_entry(tmb, &tdx_memlist, list) {
+		u64 start, end;
+
+		start = tmb->start_pfn << PAGE_SHIFT;
+		end = tmb->end_pfn << PAGE_SHIFT;
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
+		ret = tdmr_add_rsvd_area(tdmr, rsvd_idx, prev_end,
+				start - prev_end);
+		if (ret)
+			return ret;
+
+		prev_end = end;
+	}
+
+	/* Add the hole after the last region if it exists. */
+	if (prev_end < tdmr_end(tdmr)) {
+		ret = tdmr_add_rsvd_area(tdmr, rsvd_idx, prev_end,
+				tdmr_end(tdmr) - prev_end);
+		if (ret)
+			return ret;
+	}
+
+	return 0;
+}
+
+static int tdmr_set_up_pamt_rsvd_areas(struct tdmr_info *tdmr, int *rsvd_idx,
+				       struct tdmr_info *tdmr_array,
+				       int tdmr_num)
+{
+	int i, ret;
+
+	/*
+	 * If any PAMT overlaps with this TDMR, the overlapping part
+	 * must also be put to the reserved area too.  Walk over all
+	 * TDMRs to find out those overlapping PAMTs and put them to
+	 * reserved areas.
+	 */
+	for (i = 0; i < tdmr_num; i++) {
+		struct tdmr_info *tmp = tdmr_array_entry(tdmr_array, i);
+		unsigned long pamt_start_pfn, pamt_npages;
+		u64 pamt_start, pamt_end;
+
+		tdmr_get_pamt(tmp, &pamt_start_pfn, &pamt_npages);
+		/* Each TDMR must already have PAMT allocated */
+		WARN_ON_ONCE(!pamt_npages || !pamt_start_pfn);
+
+		pamt_start = pamt_start_pfn << PAGE_SHIFT;
+		pamt_end = pamt_start + (pamt_npages << PAGE_SHIFT);
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
+		ret = tdmr_add_rsvd_area(tdmr, rsvd_idx, pamt_start,
+				pamt_end - pamt_start);
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
+	/* Reserved areas cannot overlap.  The caller should guarantee. */
+	WARN_ON_ONCE(1);
+	return -1;
+}
+
+/* Set up reserved areas for a TDMR, including memory holes and PAMTs */
+static int tdmr_set_up_rsvd_areas(struct tdmr_info *tdmr,
+				  struct tdmr_info *tdmr_array,
+				  int tdmr_num)
+{
+	int ret, rsvd_idx = 0;
+
+	/* Put all memory holes within the TDMR into reserved areas */
+	ret = tdmr_set_up_memory_hole_rsvd_areas(tdmr, &rsvd_idx);
+	if (ret)
+		return ret;
+
+	/* Put all (overlapping) PAMTs within the TDMR into reserved areas */
+	ret = tdmr_set_up_pamt_rsvd_areas(tdmr, &rsvd_idx, tdmr_array, tdmr_num);
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
+static int tdmrs_set_up_rsvd_areas_all(struct tdmr_info *tdmr_array,
+				       int tdmr_num)
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
  * Construct an array of TDMRs to cover all TDX memory ranges.
  * The actual number of TDMRs is kept to @tdmr_num.
@@ -868,8 +1050,12 @@ static int construct_tdmrs(struct tdmr_info *tdmr_array, int *tdmr_num)
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
2.37.3

