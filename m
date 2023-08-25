Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 111357886DA
	for <lists+kvm@lfdr.de>; Fri, 25 Aug 2023 14:16:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244716AbjHYMQb (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 25 Aug 2023 08:16:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48466 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244614AbjHYMQB (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 25 Aug 2023 08:16:01 -0400
Received: from mgamail.intel.com (mgamail.intel.com [134.134.136.31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EE2A41B2;
        Fri, 25 Aug 2023 05:15:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1692965759; x=1724501759;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=S0MReKnMTpb11puF/W+gQrU8zuZB7oNw99xXMt859ak=;
  b=YYOzg4e5lPEnqh8Eg6fdcXb4y9sPJNvM+/Am34AI0zAMFGobE5fcDPeX
   +FP4Hj7FRIcizqv+sdg3XlZ2YXf+3WR+hDzgpVJ7n2ApkRUWdhlHF9fpU
   SlOZF96l9ewv0V+tYy8+Vv0yNsAKZrJcXKLY5A+GUO366g1HaUTgSr8g+
   wxwvJpLX1vX0SFSk/QlhOdJ1Cj7a3DnTzMqqKobUrpwLn7c9xGllirO2u
   dW9I5mAqDBp0K2L7AhNIVdi8UmE3b2wB5U8Uoija9YGVEwaQKcA2GpxtE
   NRr4v3UCoGs3K0SOYKCiinVfmu5TfOD/3NfdlLpRPuxZIIoMoel/lVhRM
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10812"; a="438639335"
X-IronPort-AV: E=Sophos;i="6.02,195,1688454000"; 
   d="scan'208";a="438639335"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Aug 2023 05:15:58 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.01,202,1684825200"; 
   d="scan'208";a="881158306"
Received: from vnaikawa-mobl1.amr.corp.intel.com (HELO khuang2-desk.gar.corp.intel.com) ([10.209.185.177])
  by fmsmga001-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Aug 2023 05:15:57 -0700
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
Subject: [PATCH v13 11/22] x86/virt/tdx: Fill out TDMRs to cover all TDX memory regions
Date:   Sat, 26 Aug 2023 00:14:30 +1200
Message-ID: <e5c22820e3400b20760d782f601869c5023f3928.1692962263.git.kai.huang@intel.com>
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
Reviewed-by: Yuan Yao <yuan.yao@intel.com>
---

v12 -> v13:
 - Added Yuan's tag.

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
index 64a7afefc214..8188f834674e 100644
--- a/arch/x86/virt/vmx/tdx/tdx.c
+++ b/arch/x86/virt/vmx/tdx/tdx.c
@@ -377,6 +377,102 @@ static void free_tdmr_list(struct tdmr_info_list *tdmr_list)
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
@@ -386,10 +482,15 @@ static int construct_tdmrs(struct list_head *tmb_list,
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
index 536d89928cd6..15afd6a56fdc 100644
--- a/arch/x86/virt/vmx/tdx/tdx.h
+++ b/arch/x86/virt/vmx/tdx/tdx.h
@@ -120,6 +120,9 @@ struct tdx_memblock {
 	unsigned long end_pfn;
 };
 
+/* Warn if kernel has less than TDMR_NR_WARN TDMRs after allocation */
+#define TDMR_NR_WARN 4
+
 struct tdmr_info_list {
 	void *tdmrs;	/* Flexible array to hold 'tdmr_info's */
 	int nr_consumed_tdmrs;	/* How many 'tdmr_info's are in use */
-- 
2.41.0

