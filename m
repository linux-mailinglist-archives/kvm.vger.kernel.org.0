Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 12C38554899
	for <lists+kvm@lfdr.de>; Wed, 22 Jun 2022 14:15:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1357580AbiFVLS5 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 22 Jun 2022 07:18:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57688 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1357511AbiFVLSH (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 22 Jun 2022 07:18:07 -0400
Received: from mga01.intel.com (mga01.intel.com [192.55.52.88])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EC1BA3CFE0;
        Wed, 22 Jun 2022 04:17:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1655896656; x=1687432656;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=bCtsiI9LBPd6oyXmHEYI1qzHkrFxdxp9TyBs4gud8x0=;
  b=jBG7SdZSB1kxiX3VkzFU8UgHhUIc8covOZ58tIlA+4wnPco3ae2xck+a
   VQhnrh7Ra2N7nSo4Vnhpd6QTsFPCJKS9VQoIoCa4etrPDW8ukhBgWlDus
   MijvEQxsu3GwPWH0x5UFiBKcLe7D2sDCqivkI+tfXgpXXk7kQwCp1jQSt
   art0GbsYbk76AsGDS4ksKmWhyEI9m3rLp7cyXSN5JXnqkJKWwJh+Ld2SI
   EVnT70vUqIOgbhKWtlHQxyQuFa8etFlqukwO1ufJ9G6ilj9x1znTa8iNI
   9WbGXmjs9mmapA3VQBalvmRrLvoDLn46jq6rfaJyFAN95glFsCp4o+pfY
   Q==;
X-IronPort-AV: E=McAfee;i="6400,9594,10385"; a="305841085"
X-IronPort-AV: E=Sophos;i="5.92,212,1650956400"; 
   d="scan'208";a="305841085"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Jun 2022 04:17:33 -0700
X-IronPort-AV: E=Sophos;i="5.92,212,1650956400"; 
   d="scan'208";a="730302272"
Received: from jmatsis-mobl.amr.corp.intel.com (HELO khuang2-desk.gar.corp.intel.com) ([10.209.178.197])
  by fmsmga001-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Jun 2022 04:17:30 -0700
From:   Kai Huang <kai.huang@intel.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     seanjc@google.com, pbonzini@redhat.com, dave.hansen@intel.com,
        len.brown@intel.com, tony.luck@intel.com,
        rafael.j.wysocki@intel.com, reinette.chatre@intel.com,
        dan.j.williams@intel.com, peterz@infradead.org, ak@linux.intel.com,
        kirill.shutemov@linux.intel.com,
        sathyanarayanan.kuppuswamy@linux.intel.com,
        isaku.yamahata@intel.com, kai.huang@intel.com
Subject: [PATCH v5 14/22] x86/virt/tdx: Create TDMRs to cover all memblock memory regions
Date:   Wed, 22 Jun 2022 23:17:03 +1200
Message-Id: <d2cbf8333375428c96f4872b7d1e895f059de0fe.1655894131.git.kai.huang@intel.com>
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

- v3 -> v5 (no feedback on v4):
 - Removed allocating TDMR individually.
 - Improved changelog by using Dave's words.
 - Made TDMR_START() and TDMR_END() as static inline function.

---
 arch/x86/virt/vmx/tdx/tdx.c | 104 +++++++++++++++++++++++++++++++++++-
 1 file changed, 103 insertions(+), 1 deletion(-)

diff --git a/arch/x86/virt/vmx/tdx/tdx.c b/arch/x86/virt/vmx/tdx/tdx.c
index 645addb1bea2..fd9f449b5395 100644
--- a/arch/x86/virt/vmx/tdx/tdx.c
+++ b/arch/x86/virt/vmx/tdx/tdx.c
@@ -427,6 +427,24 @@ static int check_memblock_tdx_convertible(void)
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
@@ -464,6 +482,82 @@ static struct tdmr_info *alloc_tdmr_array(int *array_sz)
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
@@ -472,8 +566,16 @@ static struct tdmr_info *alloc_tdmr_array(int *array_sz)
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
2.36.1

