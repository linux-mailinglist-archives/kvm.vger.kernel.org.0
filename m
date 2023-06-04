Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D465D7217BE
	for <lists+kvm@lfdr.de>; Sun,  4 Jun 2023 16:30:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232103AbjFDOaq (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 4 Jun 2023 10:30:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51664 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231809AbjFDOae (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 4 Jun 2023 10:30:34 -0400
Received: from mga11.intel.com (mga11.intel.com [192.55.52.93])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 944FFDB;
        Sun,  4 Jun 2023 07:30:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1685889032; x=1717425032;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=SPu7gga2Qr+sF/L3q9bud62cw+UMH24+I/PnNJ9xQb8=;
  b=Ak5aO3TgOw20nL0+sgfxdhilVMG39Q/AAPvKw1/IeIRI+cqabI4kA7S9
   kPAYcDsYyPfdF/Yj6AJJORfdAejJFjxfDO48GUd1x5kF7aqdztshXze76
   lyEO+UKYcbQyMoBEZzX9dYkJOUhaWYv3oivm2+AL2XnzdRqHeABFx3RCo
   PMxzkwtHjHFCrZkwqvpaQjUXiq3jm9duBPXSczzu9qDEy+vGENg3pFEFQ
   j483fr1YOtwGe9q1Xy5l+4vL60arr6BSMCk2mG0nvoVbviQsvHNZBymjW
   tByd8xqm4GfNhFWp2n891RXJSMgVyedPinz5dy/C0R3rhlcggnxwmfd3g
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10731"; a="353683606"
X-IronPort-AV: E=Sophos;i="6.00,217,1681196400"; 
   d="scan'208";a="353683606"
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Jun 2023 07:28:50 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10731"; a="1038501126"
X-IronPort-AV: E=Sophos;i="6.00,217,1681196400"; 
   d="scan'208";a="1038501126"
Received: from tdhastx-mobl2.amr.corp.intel.com (HELO khuang2-desk.gar.corp.intel.com) ([10.212.50.31])
  by fmsmga005-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Jun 2023 07:28:46 -0700
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
Subject: [PATCH v11 11/20] x86/virt/tdx: Fill out TDMRs to cover all TDX memory regions
Date:   Mon,  5 Jun 2023 02:27:24 +1200
Message-Id: <927ec9871721d2a50f1aba7d1cf7c3be50e4f49b.1685887183.git.kai.huang@intel.com>
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
---

v10 -> v11:
 - No update

v9 -> v10:
 - No change.

v8 -> v9:

 - Added the last paragraph in the changelog (Dave).
 - Removed unnecessary type cast in tdmr_entry() (Dave).


---
 arch/x86/virt/vmx/tdx/tdx.c | 94 ++++++++++++++++++++++++++++++++++++-
 1 file changed, 93 insertions(+), 1 deletion(-)

diff --git a/arch/x86/virt/vmx/tdx/tdx.c b/arch/x86/virt/vmx/tdx/tdx.c
index 7a20c72361e7..fa9fa8bc581a 100644
--- a/arch/x86/virt/vmx/tdx/tdx.c
+++ b/arch/x86/virt/vmx/tdx/tdx.c
@@ -385,6 +385,93 @@ static void free_tdmr_list(struct tdmr_info_list *tdmr_list)
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
+#define TDMR_ALIGNMENT		BIT_ULL(30)
+#define TDMR_PFN_ALIGNMENT	(TDMR_ALIGNMENT >> PAGE_SHIFT)
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
+	 * In practice TDX1.0 supports 64 TDMRs, which is big enough to
+	 * cover all memory regions in reality if the admin doesn't use
+	 * 'memmap' to create a bunch of discrete memory regions.  When
+	 * there's a real problem, enhancement can be done to merge TDMRs
+	 * to reduce the final number of TDMRs.
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
+	/* @tdmr_idx is always the index of last valid TDMR. */
+	tdmr_list->nr_consumed_tdmrs = tdmr_idx + 1;
+
+	return 0;
+}
+
 /*
  * Construct a list of TDMRs on the preallocated space in @tdmr_list
  * to cover all TDX memory regions in @tmb_list based on the TDX module
@@ -394,10 +481,15 @@ static int construct_tdmrs(struct list_head *tmb_list,
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
-- 
2.40.1

