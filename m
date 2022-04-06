Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 78EBA4F617A
	for <lists+kvm@lfdr.de>; Wed,  6 Apr 2022 16:17:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233995AbiDFODd (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 6 Apr 2022 10:03:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54268 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234060AbiDFODX (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 6 Apr 2022 10:03:23 -0400
Received: from mga18.intel.com (mga18.intel.com [134.134.136.126])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DE48095A20;
        Tue,  5 Apr 2022 21:50:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1649220655; x=1680756655;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=XT+Yu0zqAvB34KyhxTSK4J2jUzqJeBdgYuJKQre9+Fs=;
  b=KCalozvRFFIAKT+i1S41qpEnELIEWtBrF+PUbel6RY3is0qHkNu1FCpT
   7ABlQOYOzBu1QQRAE2U4IVhMpkeec6V5oNO32yeVqiH5oyrynRDKgTnjS
   0dn/zqO2Gy9X6aVH70pQYH4wXzgVkSFbeopB6IJyfjnVQ5vCwFRQ/2tWe
   RzVQ4Cs7RoDAH3WhDYO3Mfm9qS+bBWzMr31Bb88z0TNKs2vWUSUCjX/HW
   5u4KXgh6jKGZKkkp10SU1Xjix24HIHQeWPJJLY+7zmhna4gPI2pjIo7e4
   yzfM1MjoUQEET6Lj+T5enKZBw5h8Na5AQgimSyYFEfx4Ki3MMTVIxWoyW
   Q==;
X-IronPort-AV: E=McAfee;i="6200,9189,10308"; a="243089873"
X-IronPort-AV: E=Sophos;i="5.90,239,1643702400"; 
   d="scan'208";a="243089873"
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Apr 2022 21:50:40 -0700
X-IronPort-AV: E=Sophos;i="5.90,239,1643702400"; 
   d="scan'208";a="524302404"
Received: from dchang1-mobl3.amr.corp.intel.com (HELO khuang2-desk.gar.corp.intel.com) ([10.254.29.17])
  by orsmga006-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Apr 2022 21:50:36 -0700
From:   Kai Huang <kai.huang@intel.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     seanjc@google.com, pbonzini@redhat.com, dave.hansen@intel.com,
        len.brown@intel.com, tony.luck@intel.com,
        rafael.j.wysocki@intel.com, reinette.chatre@intel.com,
        dan.j.williams@intel.com, peterz@infradead.org, ak@linux.intel.com,
        kirill.shutemov@linux.intel.com,
        sathyanarayanan.kuppuswamy@linux.intel.com,
        isaku.yamahata@intel.com, kai.huang@intel.com
Subject: [PATCH v3 14/21] x86/virt/tdx: Set up reserved areas for all TDMRs
Date:   Wed,  6 Apr 2022 16:49:26 +1200
Message-Id: <b761a1b05a87c2c291daf811c325ceb4198dfba8.1649219184.git.kai.huang@intel.com>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <cover.1649219184.git.kai.huang@intel.com>
References: <cover.1649219184.git.kai.huang@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

As the last step of constructing TDMRs, create reserved area information
for the memory region holes in each TDMR.  If any PAMT (or part of it)
resides within a particular TDMR, also mark it as reserved.

All reserved areas in each TDMR must be in address ascending order,
required by TDX architecture.

Signed-off-by: Kai Huang <kai.huang@intel.com>
---
 arch/x86/virt/vmx/tdx/tdx.c | 148 +++++++++++++++++++++++++++++++++++-
 1 file changed, 146 insertions(+), 2 deletions(-)

diff --git a/arch/x86/virt/vmx/tdx/tdx.c b/arch/x86/virt/vmx/tdx/tdx.c
index 1b807dcbc101..bf0d13644898 100644
--- a/arch/x86/virt/vmx/tdx/tdx.c
+++ b/arch/x86/virt/vmx/tdx/tdx.c
@@ -15,6 +15,7 @@
 #include <linux/atomic.h>
 #include <linux/slab.h>
 #include <linux/math.h>
+#include <linux/sort.h>
 #include <asm/msr-index.h>
 #include <asm/msr.h>
 #include <asm/cpufeature.h>
@@ -1112,6 +1113,145 @@ static int tdmrs_setup_pamt_all(struct tdmr_info **tdmr_array, int tdmr_num)
 	return -ENOMEM;
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
+	WARN_ON(1);
+	return -1;
+}
+
+/* Set up reserved areas for a TDMR, including memory holes and PAMTs */
+static int tdmr_setup_rsvd_areas(struct tdmr_info *tdmr,
+				     struct tdmr_info **tdmr_array,
+				     int tdmr_num)
+{
+	u64 start, end, prev_end;
+	int rsvd_idx, i, ret = 0;
+
+	/* Mark holes between e820 RAM entries as reserved */
+	rsvd_idx = 0;
+	prev_end = TDMR_START(tdmr);
+	e820_for_each_mem(i, start, end) {
+		/* Break if this entry is after the TDMR */
+		if (start >= TDMR_END(tdmr))
+			break;
+
+		/* Exclude entries before this TDMR */
+		if (end < TDMR_START(tdmr))
+			continue;
+
+		/*
+		 * Skip if no hole exists before this entry. "<=" is
+		 * used because one e820 entry might span two TDMRs.
+		 * In that case the start address of this entry is
+		 * smaller then the start address of the second TDMR.
+		 */
+		if (start <= prev_end) {
+			prev_end = end;
+			continue;
+		}
+
+		/* Add the hole before this e820 entry */
+		ret = tdmr_add_rsvd_area(tdmr, &rsvd_idx, prev_end,
+				start - prev_end);
+		if (ret)
+			return ret;
+
+		prev_end = end;
+	}
+
+	/* Add the hole after the last RAM entry if it exists. */
+	if (prev_end < TDMR_END(tdmr)) {
+		ret = tdmr_add_rsvd_area(tdmr, &rsvd_idx, prev_end,
+				TDMR_END(tdmr) - prev_end);
+		if (ret)
+			return ret;
+	}
+
+	/*
+	 * Walk over all TDMRs to find out whether any PAMT falls into
+	 * the given TDMR. If yes, mark it as reserved too.
+	 */
+	for (i = 0; i < tdmr_num; i++) {
+		struct tdmr_info *tmp = tdmr_array[i];
+		u64 pamt_start, pamt_end;
+
+		pamt_start = tmp->pamt_4k_base;
+		pamt_end = pamt_start + tmp->pamt_4k_size +
+			tmp->pamt_2m_size + tmp->pamt_1g_size;
+
+		/* Skip PAMTs outside of the given TDMR */
+		if ((pamt_end <= TDMR_START(tdmr)) ||
+				(pamt_start >= TDMR_END(tdmr)))
+			continue;
+
+		/* Only mark the part within the TDMR as reserved */
+		if (pamt_start < TDMR_START(tdmr))
+			pamt_start = TDMR_START(tdmr);
+		if (pamt_end > TDMR_END(tdmr))
+			pamt_end = TDMR_END(tdmr);
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
+static int tdmrs_setup_rsvd_areas_all(struct tdmr_info **tdmr_array,
+				      int tdmr_num)
+{
+	int i;
+
+	for (i = 0; i < tdmr_num; i++) {
+		int ret;
+
+		ret = tdmr_setup_rsvd_areas(tdmr_array[i], tdmr_array,
+				tdmr_num);
+		if (ret)
+			return ret;
+	}
+
+	return 0;
+}
+
 static int construct_tdmrs(struct tdmr_info **tdmr_array, int *tdmr_num)
 {
 	int ret;
@@ -1128,8 +1268,12 @@ static int construct_tdmrs(struct tdmr_info **tdmr_array, int *tdmr_num)
 	if (ret)
 		goto err_free_tdmrs;
 
-	/* Return -EFAULT until constructing TDMRs is done */
-	ret = -EFAULT;
+	ret = tdmrs_setup_rsvd_areas_all(tdmr_array, *tdmr_num);
+	if (ret)
+		goto err_free_pamts;
+
+	return 0;
+err_free_pamts:
 	tdmrs_free_pamt_all(tdmr_array, *tdmr_num);
 err_free_tdmrs:
 	free_tdmrs(tdmr_array, *tdmr_num);
-- 
2.35.1

