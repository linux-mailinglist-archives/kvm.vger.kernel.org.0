Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2D7596317B6
	for <lists+kvm@lfdr.de>; Mon, 21 Nov 2022 01:29:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229996AbiKUA3K (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 20 Nov 2022 19:29:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58700 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229985AbiKUA1w (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 20 Nov 2022 19:27:52 -0500
Received: from mga07.intel.com (mga07.intel.com [134.134.136.100])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 158D31FCCC;
        Sun, 20 Nov 2022 16:27:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1668990468; x=1700526468;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=lQ+GUoAJqvHedg+d+kfODMpHJrhD7+ALFsnhNJ3753Q=;
  b=YWK/LEpxzXQ2aVSmi1U76NwlzB5WwN1BMiA+IPa4IKYvqXVDGSK+WxYG
   FeXsldcW6gz6SGxqYbPWWWMQquTzZbiwmW4o1xZWjP8NwdJ1dNRRLJWPT
   oBrRQXzIGIyQNolh3VAJoR/OSXrsvHy0lo3j6pQ97WvmZ9Og8nXfE4gXt
   Q/kjh1uAkzvE3KEJw71XrZPgOT0yJeQ02sgjGZ+eAPwT6edZxwHhH4PkD
   md4KKi6OKq8Ul5gU8qHuZlNO2eO/kqOm6pl5HPTH795A6MLDyex7cPi3i
   jh2A0l43zhrSrZCb7wOLLL2l5gNXiYSkfiooAszCxh4pp3PpzUjNr1XlC
   w==;
X-IronPort-AV: E=McAfee;i="6500,9779,10537"; a="377705713"
X-IronPort-AV: E=Sophos;i="5.96,180,1665471600"; 
   d="scan'208";a="377705713"
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Nov 2022 16:27:47 -0800
X-IronPort-AV: E=McAfee;i="6500,9779,10537"; a="729825418"
X-IronPort-AV: E=Sophos;i="5.96,180,1665471600"; 
   d="scan'208";a="729825418"
Received: from tomnavar-mobl.amr.corp.intel.com (HELO khuang2-desk.gar.corp.intel.com) ([10.209.176.15])
  by fmsmga003-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Nov 2022 16:27:42 -0800
From:   Kai Huang <kai.huang@intel.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     linux-mm@kvack.org, seanjc@google.com, pbonzini@redhat.com,
        dave.hansen@intel.com, dan.j.williams@intel.com,
        rafael.j.wysocki@intel.com, kirill.shutemov@linux.intel.com,
        ying.huang@intel.com, reinette.chatre@intel.com,
        len.brown@intel.com, tony.luck@intel.com, peterz@infradead.org,
        ak@linux.intel.com, isaku.yamahata@intel.com, chao.gao@intel.com,
        sathyanarayanan.kuppuswamy@linux.intel.com, bagasdotme@gmail.com,
        sagis@google.com, imammedo@redhat.com, kai.huang@intel.com
Subject: [PATCH v7 12/20] x86/virt/tdx: Create TDMRs to cover all TDX memory regions
Date:   Mon, 21 Nov 2022 13:26:34 +1300
Message-Id: <4db59b4a87f0309c29e61a79892b9fa6645754a8.1668988357.git.kai.huang@intel.com>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <cover.1668988357.git.kai.huang@intel.com>
References: <cover.1668988357.git.kai.huang@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
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

Create a number of TDMRs to cover all TDX memory regions.  To keep it
simple, always try to create one TDMR for each memory region.  As the
first step only set up the base/size for each TDMR.

Each TDMR must be 1G aligned and the size must be in 1G granularity.
This implies that one TDMR could cover multiple memory regions.  If a
memory region spans the 1GB boundary and the former part is already
covered by the previous TDMR, just create a new TDMR for the remaining
part.

TDX only supports a limited number of TDMRs.  Disable TDX if all TDMRs
are consumed but there is more memory region to cover.

Signed-off-by: Kai Huang <kai.huang@intel.com>
---

v6 -> v7:
 - No change.

v5 -> v6:
 - Rebase due to using 'tdx_memblock' instead of memblock.

- v3 -> v5 (no feedback on v4):
 - Removed allocating TDMR individually.
 - Improved changelog by using Dave's words.
 - Made TDMR_START() and TDMR_END() as static inline function.

---
 arch/x86/virt/vmx/tdx/tdx.c | 104 +++++++++++++++++++++++++++++++++++-
 1 file changed, 103 insertions(+), 1 deletion(-)

diff --git a/arch/x86/virt/vmx/tdx/tdx.c b/arch/x86/virt/vmx/tdx/tdx.c
index 26048c6b0170..57b448de59a0 100644
--- a/arch/x86/virt/vmx/tdx/tdx.c
+++ b/arch/x86/virt/vmx/tdx/tdx.c
@@ -445,6 +445,24 @@ static int build_tdx_memory(void)
 	return ret;
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
@@ -492,14 +510,98 @@ static struct tdmr_info *alloc_tdmr_array(int *array_sz)
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
+ * Create TDMRs to cover all TDX memory regions.  The actual number
+ * of TDMRs is set to @tdmr_num.
+ */
+static int create_tdmrs(struct tdmr_info *tdmr_array, int *tdmr_num)
+{
+	struct tdx_memblock *tmb;
+	int tdmr_idx = 0;
+
+	/*
+	 * Loop over TDX memory regions and create TDMRs to cover them.
+	 * To keep it simple, always try to use one TDMR to cover
+	 * one memory region.
+	 */
+	list_for_each_entry(tmb, &tdx_memlist, list) {
+		struct tdmr_info *tdmr;
+		u64 start, end;
+
+		tdmr = tdmr_array_entry(tdmr_array, tdmr_idx);
+		start = TDMR_ALIGN_DOWN(tmb->start_pfn << PAGE_SHIFT);
+		end = TDMR_ALIGN_UP(tmb->end_pfn << PAGE_SHIFT);
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
+			 * block has already been fully covered by the
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
  * Construct an array of TDMRs to cover all TDX memory ranges.
  * The actual number of TDMRs is kept to @tdmr_num.
  */
 static int construct_tdmrs(struct tdmr_info *tdmr_array, int *tdmr_num)
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
2.38.1

