Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D33C44C60EF
	for <lists+kvm@lfdr.de>; Mon, 28 Feb 2022 03:16:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232516AbiB1CPp (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 27 Feb 2022 21:15:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60844 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232080AbiB1CPe (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 27 Feb 2022 21:15:34 -0500
Received: from mga02.intel.com (mga02.intel.com [134.134.136.20])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ACB9C52B0B;
        Sun, 27 Feb 2022 18:14:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1646014496; x=1677550496;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=bFLy9fpNKQd2QeHf+C89Gyebuh/eSQ0CtscuysTcNBI=;
  b=l2Bw9RMHKTr3DBkyS5wOtrY07VkbY9dMXIUe7lp/tAES+pndaQJXLnHN
   dJ8A8mEykDvY8NmnMEzIpwv7mcWK0XjNznSK+jScx1DbTcGJfhGBbi6xV
   05RZetQ28bcrUO7RLZTlvv/XTewXeqzfdHPERI2FNKM7j/KCdsE3hZulX
   ZIU/ejTp9TTM4fnPlB6zf0Etr1MgSYoyhXIyQjDiTjJ9SouKZ7senEyg7
   FVcEhWtQSw8a/eeIrOFNOo6uurYHK7uMe5g/IrufCetlFeJohVcwTd0jV
   C58ndQXE1jXVqOUdAAq/M2vYR4siUMKcXVR6WgWvfaMXAImqgMIJPRARA
   g==;
X-IronPort-AV: E=McAfee;i="6200,9189,10271"; a="240191961"
X-IronPort-AV: E=Sophos;i="5.90,142,1643702400"; 
   d="scan'208";a="240191961"
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Feb 2022 18:14:43 -0800
X-IronPort-AV: E=Sophos;i="5.90,142,1643702400"; 
   d="scan'208";a="777936962"
Received: from jdpanhor-mobl2.amr.corp.intel.com (HELO khuang2-desk.gar.corp.intel.com) ([10.254.49.36])
  by fmsmga006-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Feb 2022 18:14:39 -0800
From:   Kai Huang <kai.huang@intel.com>
To:     x86@kernel.org
Cc:     tglx@linutronix.de, mingo@redhat.com, bp@alien8.de,
        dave.hansen@intel.com, luto@kernel.org, kvm@vger.kernel.org,
        pbonzini@redhat.com, seanjc@google.com, hpa@zytor.com,
        peterz@infradead.org, kirill.shutemov@linux.intel.com,
        sathyanarayanan.kuppuswamy@linux.intel.com, tony.luck@intel.com,
        ak@linux.intel.com, dan.j.williams@intel.com,
        chang.seok.bae@intel.com, keescook@chromium.org,
        hengqi.arch@bytedance.com, laijs@linux.alibaba.com,
        metze@samba.org, linux-kernel@vger.kernel.org, kai.huang@intel.com
Subject: [RFC PATCH 14/21] x86/virt/tdx: Set up reserved areas for all TDMRs
Date:   Mon, 28 Feb 2022 15:13:02 +1300
Message-Id: <e097477f93c17a42f977a75ac0f060ad68f54ec7.1646007267.git.kai.huang@intel.com>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <cover.1646007267.git.kai.huang@intel.com>
References: <cover.1646007267.git.kai.huang@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

As the last step of constructing TDMRs, create reserved area information
for the memory region holes in each TDMR.  If any PAMT (or part of it)
resides within a particular TDMR, also it as reserved.

All reserved areas in each TDMR must be in address ascending order,
required by TDX architecture.

Signed-off-by: Kai Huang <kai.huang@intel.com>
---
 arch/x86/virt/vmx/tdx.c | 148 +++++++++++++++++++++++++++++++++++++++-
 1 file changed, 146 insertions(+), 2 deletions(-)

diff --git a/arch/x86/virt/vmx/tdx.c b/arch/x86/virt/vmx/tdx.c
index d29e7943f890..8dac98b91c77 100644
--- a/arch/x86/virt/vmx/tdx.c
+++ b/arch/x86/virt/vmx/tdx.c
@@ -14,6 +14,7 @@
 #include <linux/smp.h>
 #include <linux/atomic.h>
 #include <linux/slab.h>
+#include <linux/sort.h>
 #include <asm/msr-index.h>
 #include <asm/msr.h>
 #include <asm/cpufeature.h>
@@ -1031,6 +1032,145 @@ static int tdmrs_setup_pamt_all(struct tdmr_info **tdmr_array, int tdmr_num)
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
+	e820_for_each_mem(e820_table, i, start, end) {
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
@@ -1047,8 +1187,12 @@ static int construct_tdmrs(struct tdmr_info **tdmr_array, int *tdmr_num)
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
2.33.1

