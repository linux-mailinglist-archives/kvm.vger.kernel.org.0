Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B67A84D7469
	for <lists+kvm@lfdr.de>; Sun, 13 Mar 2022 11:51:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232031AbiCMKwz (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 13 Mar 2022 06:52:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41990 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232118AbiCMKwW (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 13 Mar 2022 06:52:22 -0400
Received: from mga04.intel.com (mga04.intel.com [192.55.52.120])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CC28F11942E;
        Sun, 13 Mar 2022 03:50:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1647168658; x=1678704658;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=hgk+D3xp6Yl1JTOiq87VMlJ490hywAh5/YmDigNeXH4=;
  b=U8Joqr11SHQnlnsWmxrJrUqhodsL5dIpA8fElyEQjDPGphxo00yXxH76
   k3+abgiBO6xqFieXg4aEtMIZqq3J2E+/gbB97WAAXg2hTlbp/VE/ANDkt
   G6blzObqYEiOd99elS6OCbbzuzPhSWJ+1zGN0nuUj3oFUlhFSFuxhTpu8
   XhuchyRQiAmkkbR+3tR7006II22Pv4Agfdp/RO2ELgbAcbJfqRgSk6v91
   lSy4IPTid/v3okhdhzeqXkg1yTiQpiaXeZ7x80Shsc/cY49mAh5wtO3wO
   o1FtPjVLMbrFfsLN/RquszGExRXGuqgQSJjBoq4PNBC/fo3HYeDZTY0PF
   w==;
X-IronPort-AV: E=McAfee;i="6200,9189,10284"; a="254689545"
X-IronPort-AV: E=Sophos;i="5.90,178,1643702400"; 
   d="scan'208";a="254689545"
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Mar 2022 03:50:55 -0700
X-IronPort-AV: E=Sophos;i="5.90,178,1643702400"; 
   d="scan'208";a="645448169"
Received: from mvideche-mobl1.amr.corp.intel.com (HELO khuang2-desk.gar.corp.intel.com) ([10.251.130.249])
  by orsmga004-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Mar 2022 03:50:52 -0700
From:   Kai Huang <kai.huang@intel.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     dave.hansen@intel.com, seanjc@google.com, pbonzini@redhat.com,
        kirill.shutemov@linux.intel.com,
        sathyanarayanan.kuppuswamy@linux.intel.com, peterz@infradead.org,
        tony.luck@intel.com, ak@linux.intel.com, dan.j.williams@intel.com,
        isaku.yamahata@intel.com, kai.huang@intel.com
Subject: [PATCH v2 14/21] x86/virt/tdx: Set up reserved areas for all TDMRs
Date:   Sun, 13 Mar 2022 23:49:54 +1300
Message-Id: <0927dacd2476c96fd8c24f9a777162cb1a252401.1647167475.git.kai.huang@intel.com>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <cover.1647167475.git.kai.huang@intel.com>
References: <cover.1647167475.git.kai.huang@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-5.9 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
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
index c58c99b94c72..f6345af29414 100644
--- a/arch/x86/virt/vmx/tdx.c
+++ b/arch/x86/virt/vmx/tdx.c
@@ -15,6 +15,7 @@
 #include <linux/atomic.h>
 #include <linux/slab.h>
 #include <linux/math.h>
+#include <linux/sort.h>
 #include <asm/msr-index.h>
 #include <asm/msr.h>
 #include <asm/cpufeature.h>
@@ -1108,6 +1109,145 @@ static int tdmrs_setup_pamt_all(struct tdmr_info **tdmr_array, int tdmr_num)
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
@@ -1124,8 +1264,12 @@ static int construct_tdmrs(struct tdmr_info **tdmr_array, int *tdmr_num)
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

