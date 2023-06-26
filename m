Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CB51173E1C4
	for <lists+kvm@lfdr.de>; Mon, 26 Jun 2023 16:15:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229681AbjFZOPx (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 26 Jun 2023 10:15:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35186 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231397AbjFZOPa (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 26 Jun 2023 10:15:30 -0400
Received: from mga18.intel.com (mga18.intel.com [134.134.136.126])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 827ED212B;
        Mon, 26 Jun 2023 07:14:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1687788895; x=1719324895;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=euqo82fz3Bf0isL6tyk0IDxgpH21RqTQiuaH2+Qt2xg=;
  b=NvB+Dko+QAot2ysKpDjaxlrp7XPcIfNOdtqpU+llMwJrF3AHX4GKpheo
   R7GAIbpcXs+pGMC+Mz7vW7ZcelAIAMzDEIb09zh1mrMO/UdMEWq0dndBx
   NVeTrP3ZoxW0lrNdeNPPAu5vEWqtPc4FV/QHyOcFOZVSIhNw/tLHpJXAO
   /2e5NdiUaJRtn/dJO5GlKm/G9UZZf3Qai96QwuVWNVPbMMAXkYY6kTP4Y
   Z2eKP90goYb1Hg0hQB9WrzOpTrRGU/mutG/P5/wV9yUlcyZwTz7IJgkv5
   3jcMu9Rxf9y6Ii+XoC6eqpOJz4+d8iU5wHvwPHjoinWWh+05KtIF0OPQ7
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10753"; a="346033836"
X-IronPort-AV: E=Sophos;i="6.01,159,1684825200"; 
   d="scan'208";a="346033836"
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Jun 2023 07:14:47 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10753"; a="890292354"
X-IronPort-AV: E=Sophos;i="6.01,159,1684825200"; 
   d="scan'208";a="890292354"
Received: from smithau-mobl1.amr.corp.intel.com (HELO khuang2-desk.gar.corp.intel.com) ([10.213.179.223])
  by orsmga005-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Jun 2023 07:14:40 -0700
From:   Kai Huang <kai.huang@intel.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     linux-mm@kvack.org, x86@kernel.org, dave.hansen@intel.com,
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
Subject: [PATCH v12 11/22] x86/virt/tdx: Fill out TDMRs to cover all TDX memory regions
Date:   Tue, 27 Jun 2023 02:12:41 +1200
Message-Id: <a4794b1c6fe8994bfe5fb6d3067bf2a7682fdb4a.1687784645.git.kai.huang@intel.com>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <cover.1687784645.git.kai.huang@intel.com>
References: <cover.1687784645.git.kai.huang@intel.com>
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

Start to transit out the "multi-steps" to construct a list of "TD Memory
Regions" (TDMRs) to cover all TDX-usable memory regions.

The kernel configures TDX-usable memory regions by passing a list of
TDMRs "TD Memory Regions" (TDMRs) to the TDX module.  Each TDMR contains
the information of the base/size of a memory region, the base/size of the
associated Physical Address Metadata Table (PAMT) and a list of reserved
areas in the region.

Do the first step to fill out a number of TDMRs to cover all TDX memory
regions.  To keep it simple, always try to use one TDMR for each memory
region.  As the first step only set up the base/size for each TDMR.

Each TDMR must be 1G aligned and the size must be in 1G granularity.
This implies that one TDMR could cover multiple memory regions.  If a
memory region spans the 1GB boundary and the former part is already
covered by the previous TDMR, just use a new TDMR for the remaining
part.

TDX only supports a limited number of TDMRs.  Disable TDX if all TDMRs
are consumed but there is more memory region to cover.

There are fancier things that could be done like trying to merge
adjacent TDMRs.  This would allow more pathological memory layouts to be
supported.  But, current systems are not even close to exhausting the
existing TDMR resources in practice.  For now, keep it simple.

Signed-off-by: Kai Huang <kai.huang@intel.com>
Reviewed-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Reviewed-by: Kuppuswamy Sathyanarayanan <sathyanarayanan.kuppuswamy@linux.intel.com>
---

v11 -> v12:
 - Improved comments around looping over TDX memblock to create TDMRs.
   (Dave).
 - Added code to pr_warn() when consumed TDMRs reaching maximum TDMRs
   (Dave).
 - BIT_ULL(30) -> SZ_1G (Kirill)
 - Removed unused TDMR_PFN_ALIGNMENT (Sathy)
 - Added tags from Kirill/Sathy

v10 -> v11:
 - No update

v9 -> v10:
 - No change.

v8 -> v9:

 - Added the last paragraph in the changelog (Dave).
 - Removed unnecessary type cast in tdmr_entry() (Dave).

---
 arch/x86/virt/vmx/tdx/tdx.c | 103 +++++++++++++++++++++++++++++++++++-
 arch/x86/virt/vmx/tdx/tdx.h |   3 ++
 2 files changed, 105 insertions(+), 1 deletion(-)

diff --git a/arch/x86/virt/vmx/tdx/tdx.c b/arch/x86/virt/vmx/tdx/tdx.c
index e28615b60f9b..2ffc1517a93b 100644
--- a/arch/x86/virt/vmx/tdx/tdx.c
+++ b/arch/x86/virt/vmx/tdx/tdx.c
@@ -341,6 +341,102 @@ static void free_tdmr_list(struct tdmr_info_list *tdmr_list)
 			tdmr_list->max_tdmrs * tdmr_list->tdmr_sz);
 }
 
+/* Get the TDMR from the list at the given index. */
+static struct tdmr_info *tdmr_entry(struct tdmr_info_list *tdmr_list,
+				    int idx)
+{
+	int tdmr_info_offset = tdmr_list->tdmr_sz * idx;
+
+	return (void *)tdmr_list->tdmrs + tdmr_info_offset;
+}
+
+#define TDMR_ALIGNMENT		SZ_1G
+#define TDMR_ALIGN_DOWN(_addr)	ALIGN_DOWN((_addr), TDMR_ALIGNMENT)
+#define TDMR_ALIGN_UP(_addr)	ALIGN((_addr), TDMR_ALIGNMENT)
+
+static inline u64 tdmr_end(struct tdmr_info *tdmr)
+{
+	return tdmr->base + tdmr->size;
+}
+
+/*
+ * Take the memory referenced in @tmb_list and populate the
+ * preallocated @tdmr_list, following all the special alignment
+ * and size rules for TDMR.
+ */
+static int fill_out_tdmrs(struct list_head *tmb_list,
+			  struct tdmr_info_list *tdmr_list)
+{
+	struct tdx_memblock *tmb;
+	int tdmr_idx = 0;
+
+	/*
+	 * Loop over TDX memory regions and fill out TDMRs to cover them.
+	 * To keep it simple, always try to use one TDMR to cover one
+	 * memory region.
+	 *
+	 * In practice TDX supports at least 64 TDMRs.  A 2-socket system
+	 * typically only consumes less than 10 of those.  This code is
+	 * dumb and simple and may use more TMDRs than is strictly
+	 * required.
+	 */
+	list_for_each_entry(tmb, tmb_list, list) {
+		struct tdmr_info *tdmr = tdmr_entry(tdmr_list, tdmr_idx);
+		u64 start, end;
+
+		start = TDMR_ALIGN_DOWN(PFN_PHYS(tmb->start_pfn));
+		end   = TDMR_ALIGN_UP(PFN_PHYS(tmb->end_pfn));
+
+		/*
+		 * A valid size indicates the current TDMR has already
+		 * been filled out to cover the previous memory region(s).
+		 */
+		if (tdmr->size) {
+			/*
+			 * Loop to the next if the current memory region
+			 * has already been fully covered.
+			 */
+			if (end <= tdmr_end(tdmr))
+				continue;
+
+			/* Otherwise, skip the already covered part. */
+			if (start < tdmr_end(tdmr))
+				start = tdmr_end(tdmr);
+
+			/*
+			 * Create a new TDMR to cover the current memory
+			 * region, or the remaining part of it.
+			 */
+			tdmr_idx++;
+			if (tdmr_idx >= tdmr_list->max_tdmrs) {
+				pr_warn("initialization failed: TDMRs exhausted.\n");
+				return -ENOSPC;
+			}
+
+			tdmr = tdmr_entry(tdmr_list, tdmr_idx);
+		}
+
+		tdmr->base = start;
+		tdmr->size = end - start;
+	}
+
+	/* @tdmr_idx is always the index of the last valid TDMR. */
+	tdmr_list->nr_consumed_tdmrs = tdmr_idx + 1;
+
+	/*
+	 * Warn early that kernel is about to run out of TDMRs.
+	 *
+	 * This is an indication that TDMR allocation has to be
+	 * reworked to be smarter to not run into an issue.
+	 */
+	if (tdmr_list->max_tdmrs - tdmr_list->nr_consumed_tdmrs < TDMR_NR_WARN)
+		pr_warn("consumed TDMRs reaching limit: %d used out of %d\n",
+				tdmr_list->nr_consumed_tdmrs,
+				tdmr_list->max_tdmrs);
+
+	return 0;
+}
+
 /*
  * Construct a list of TDMRs on the preallocated space in @tdmr_list
  * to cover all TDX memory regions in @tmb_list based on the TDX module
@@ -350,10 +446,15 @@ static int construct_tdmrs(struct list_head *tmb_list,
 			   struct tdmr_info_list *tdmr_list,
 			   struct tdsysinfo_struct *sysinfo)
 {
+	int ret;
+
+	ret = fill_out_tdmrs(tmb_list, tdmr_list);
+	if (ret)
+		return ret;
+
 	/*
 	 * TODO:
 	 *
-	 *  - Fill out TDMRs to cover all TDX memory regions.
 	 *  - Allocate and set up PAMTs for each TDMR.
 	 *  - Designate reserved areas for each TDMR.
 	 *
diff --git a/arch/x86/virt/vmx/tdx/tdx.h b/arch/x86/virt/vmx/tdx/tdx.h
index 193764afc602..3086f7ad0522 100644
--- a/arch/x86/virt/vmx/tdx/tdx.h
+++ b/arch/x86/virt/vmx/tdx/tdx.h
@@ -123,6 +123,9 @@ struct tdx_memblock {
 	unsigned long end_pfn;
 };
 
+/* Warn if kernel has less than TDMR_NR_WARN TDMRs after allocation */
+#define TDMR_NR_WARN 4
+
 struct tdmr_info_list {
 	void *tdmrs;	/* Flexible array to hold 'tdmr_info's */
 	int nr_consumed_tdmrs;	/* How many 'tdmr_info's are in use */
-- 
2.40.1

