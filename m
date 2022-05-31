Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 60AD753972F
	for <lists+kvm@lfdr.de>; Tue, 31 May 2022 21:43:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347402AbiEaTle (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 31 May 2022 15:41:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39428 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347421AbiEaTlR (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 31 May 2022 15:41:17 -0400
Received: from mga11.intel.com (mga11.intel.com [192.55.52.93])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 54BF69CF30;
        Tue, 31 May 2022 12:41:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1654026067; x=1685562067;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=rfeaYtk7QAFdJKkF9Rcx/YVIhD7DmXRd0Ex3Ohrn9YI=;
  b=nNvpUOaVfVksG80f1Q/Ixterc7I5ndJQV+RimwYj05yPpmc8C1Sh7KfR
   hb8YxlcwbykohVSblJ1R+ZvPxRGz2CXMaxYOkNrvwL+xfCXopyXCoEznY
   qb1/7yblmGLYOCLrjojdyVRAqcMh/yIiPdAjWQkat05AGIspNzOAEZ6GN
   OG0GiLYmEif7YMQsZz+UirITDZqGRq+VpsYM693rtaLy24GZxXCmytbHA
   LJBUA4QP14K043vGX2ZaJBB8kFkM66UeRfkYoFncPOyiV6VipXYTkOYm6
   A9ZhXnk9HOxxQjbjpwcK7y9vv8UGwb6pjz0fFPr22rjOfzgmM6O7JpIqa
   w==;
X-IronPort-AV: E=McAfee;i="6400,9594,10364"; a="272935161"
X-IronPort-AV: E=Sophos;i="5.91,266,1647327600"; 
   d="scan'208";a="272935161"
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 31 May 2022 12:40:43 -0700
X-IronPort-AV: E=Sophos;i="5.91,266,1647327600"; 
   d="scan'208";a="645164564"
Received: from maciejwo-mobl1.ger.corp.intel.com (HELO khuang2-desk.gar.corp.intel.com) ([10.254.36.207])
  by fmsmga004-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 31 May 2022 12:40:39 -0700
From:   Kai Huang <kai.huang@intel.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     seanjc@google.com, pbonzini@redhat.com, dave.hansen@intel.com,
        len.brown@intel.com, tony.luck@intel.com,
        rafael.j.wysocki@intel.com, reinette.chatre@intel.com,
        dan.j.williams@intel.com, peterz@infradead.org, ak@linux.intel.com,
        kirill.shutemov@linux.intel.com,
        sathyanarayanan.kuppuswamy@linux.intel.com,
        isaku.yamahata@intel.com, kai.huang@intel.com
Subject: [PATCH v4 14/22] x86/virt/tdx: Create TDMRs to cover all memblock memory regions
Date:   Wed,  1 Jun 2022 07:39:37 +1200
Message-Id: <78fd4dd9f4659ae66b262864ebe58fbb0f4d5c73.1654025431.git.kai.huang@intel.com>
X-Mailer: git-send-email 2.35.3
In-Reply-To: <cover.1654025430.git.kai.huang@intel.com>
References: <cover.1654025430.git.kai.huang@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The kernel configures TDX-usable memory regions by passing an array of
"TD Memory Regions" (TDMRs) to the TDX module.  Each TDMR contains the
information of the base/size of a memory region, the base/size of the
associated Physical Address Metadata Table (PAMT) and a list of reserved
areas in the region.

Create a number of TDMRs according to the memblock memory regions.  To
keep it simple, always try to create one TDMR for each memory region.
As the first step only set up the base/size for each TDMR.

Each TDMR must be 1G aligned and the size must be in 1G granularity.
This implies that one TDMR could cover multiple memory regions.  If a
memory region spans the 1GB boundary and the former part is already
covered by the previous TDMR, just create a new TDMR for the remaining
part.

TDX only supports a limited number of TDMRs.  Disable TDX if all TDMRs
are consumed but there is more memory region to cover.

Signed-off-by: Kai Huang <kai.huang@intel.com>
---

- v3 -> v4:
 - Removed allocating TDMR individually.
 - Improved changelog by using Dave's words.
 - Made TDMR_START() and TDMR_END() as static inline function.

---
 arch/x86/virt/vmx/tdx/tdx.c | 104 +++++++++++++++++++++++++++++++++++-
 1 file changed, 103 insertions(+), 1 deletion(-)

diff --git a/arch/x86/virt/vmx/tdx/tdx.c b/arch/x86/virt/vmx/tdx/tdx.c
index 4aa02a992b59..129994c191f5 100644
--- a/arch/x86/virt/vmx/tdx/tdx.c
+++ b/arch/x86/virt/vmx/tdx/tdx.c
@@ -433,6 +433,24 @@ static int check_memblock_tdx_convertible(void)
 	return 0;
 }
 
+/* TDMR must be 1gb aligned */
+#define TDMR_ALIGNMENT		BIT_ULL(30)
+#define TDMR_PFN_ALIGNMENT	(TDMR_ALIGNMENT >> PAGE_SHIFT)
+
+/* Align up and down the address to TDMR boundary */
+#define TDMR_ALIGN_DOWN(_addr)	ALIGN_DOWN((_addr), TDMR_ALIGNMENT)
+#define TDMR_ALIGN_UP(_addr)	ALIGN((_addr), TDMR_ALIGNMENT)
+
+static inline u64 tdmr_start(struct tdmr_info *tdmr)
+{
+	return tdmr->base;
+}
+
+static inline u64 tdmr_end(struct tdmr_info *tdmr)
+{
+	return tdmr->base + tdmr->size;
+}
+
 /* Calculate the actual TDMR_INFO size */
 static inline int cal_tdmr_size(void)
 {
@@ -470,6 +488,82 @@ static struct tdmr_info *alloc_tdmr_array(int *array_sz)
 	return alloc_pages_exact(*array_sz, GFP_KERNEL | __GFP_ZERO);
 }
 
+static struct tdmr_info *tdmr_array_entry(struct tdmr_info *tdmr_array,
+					  int idx)
+{
+	return (struct tdmr_info *)((unsigned long)tdmr_array +
+			cal_tdmr_size() * idx);
+}
+
+/*
+ * Create TDMRs to cover all memory regions in memblock.  The actual
+ * number of TDMRs is set to @tdmr_num.
+ */
+static int create_tdmrs(struct tdmr_info *tdmr_array, int *tdmr_num)
+{
+	unsigned long start_pfn, end_pfn;
+	int i, nid, tdmr_idx = 0;
+
+	/*
+	 * Loop over all memory regions in memblock and create TDMRs to
+	 * cover them.  To keep it simple, always try to use one TDMR to
+	 * cover memory region.
+	 */
+	memblock_for_each_tdx_mem_pfn_range(i, &start_pfn, &end_pfn, &nid) {
+		struct tdmr_info *tdmr;
+		u64 start, end;
+
+		tdmr = tdmr_array_entry(tdmr_array, tdmr_idx);
+		start = TDMR_ALIGN_DOWN(start_pfn << PAGE_SHIFT);
+		end = TDMR_ALIGN_UP(end_pfn << PAGE_SHIFT);
+
+		/*
+		 * If the current TDMR's size hasn't been initialized,
+		 * it is a new TDMR to cover the new memory region.
+		 * Otherwise, the current TDMR has already covered the
+		 * previous memory region.  In the latter case, check
+		 * whether the current memory region has been fully or
+		 * partially covered by the current TDMR, since TDMR is
+		 * 1G aligned.
+		 */
+		if (tdmr->size) {
+			/*
+			 * Loop to the next memory region if the current
+			 * region has already fully covered by the
+			 * current TDMR.
+			 */
+			if (end <= tdmr_end(tdmr))
+				continue;
+
+			/*
+			 * If part of the current memory region has
+			 * already been covered by the current TDMR,
+			 * skip the already covered part.
+			 */
+			if (start < tdmr_end(tdmr))
+				start = tdmr_end(tdmr);
+
+			/*
+			 * Create a new TDMR to cover the current memory
+			 * region, or the remaining part of it.
+			 */
+			tdmr_idx++;
+			if (tdmr_idx >= tdx_sysinfo.max_tdmrs)
+				return -E2BIG;
+
+			tdmr = tdmr_array_entry(tdmr_array, tdmr_idx);
+		}
+
+		tdmr->base = start;
+		tdmr->size = end - start;
+	}
+
+	/* @tdmr_idx is always the index of last valid TDMR. */
+	*tdmr_num = tdmr_idx + 1;
+
+	return 0;
+}
+
 /*
  * Construct an array of TDMRs to cover all memory regions in memblock.
  * This makes sure all pages managed by the page allocator are TDX
@@ -478,8 +572,16 @@ static struct tdmr_info *alloc_tdmr_array(int *array_sz)
 static int construct_tdmrs_memeblock(struct tdmr_info *tdmr_array,
 				     int *tdmr_num)
 {
+	int ret;
+
+	ret = create_tdmrs(tdmr_array, tdmr_num);
+	if (ret)
+		goto err;
+
 	/* Return -EINVAL until constructing TDMRs is done */
-	return -EINVAL;
+	ret = -EINVAL;
+err:
+	return ret;
 }
 
 /*
-- 
2.35.3

