Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BBEE44D7460
	for <lists+kvm@lfdr.de>; Sun, 13 Mar 2022 11:51:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234334AbiCMKwX (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 13 Mar 2022 06:52:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41918 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233197AbiCMKwH (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 13 Mar 2022 06:52:07 -0400
Received: from mga04.intel.com (mga04.intel.com [192.55.52.120])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D393746677;
        Sun, 13 Mar 2022 03:50:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1647168649; x=1678704649;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=n1crdIzrOnQqTGW/i63Bu9xmzYGPEZcLc2/KThxwLhQ=;
  b=hcMuXWetJPu8pp/HOoR636NNQnIOXZ6tD1uEWSIF5mbUbAkDhSakMFd2
   42W8u+Y0o7r+F237qCixBBofkj0hu3hZzLLRIaoQeXg8mSn9Gg5U8u9BC
   vNP7ClJJT47q4KC3XjMEjuLe3eiDyuB3v++ZSDylOPRPG+H0oUfb3U2aa
   BmDnqJaw4afZoUekRydBPVlCPtyTJQHKxJ45ehcwr/rd/t6k1b6vZxxm9
   /gY9RcMZ6pQ6/UZb/yFdD8TA/2sIeyF9cj01TERD0BCOI9dd+EWpgaKKK
   9F0fZhHucs+M5Z/jptboXXhohueYxFbifKYwXyNm138LIumuPG9LBFZt9
   g==;
X-IronPort-AV: E=McAfee;i="6200,9189,10284"; a="254689540"
X-IronPort-AV: E=Sophos;i="5.90,178,1643702400"; 
   d="scan'208";a="254689540"
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Mar 2022 03:50:49 -0700
X-IronPort-AV: E=Sophos;i="5.90,178,1643702400"; 
   d="scan'208";a="645448152"
Received: from mvideche-mobl1.amr.corp.intel.com (HELO khuang2-desk.gar.corp.intel.com) ([10.251.130.249])
  by orsmga004-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Mar 2022 03:50:46 -0700
From:   Kai Huang <kai.huang@intel.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     dave.hansen@intel.com, seanjc@google.com, pbonzini@redhat.com,
        kirill.shutemov@linux.intel.com,
        sathyanarayanan.kuppuswamy@linux.intel.com, peterz@infradead.org,
        tony.luck@intel.com, ak@linux.intel.com, dan.j.williams@intel.com,
        isaku.yamahata@intel.com, kai.huang@intel.com
Subject: [PATCH v2 12/21] x86/virt/tdx: Create TDMRs to cover all system RAM
Date:   Sun, 13 Mar 2022 23:49:52 +1300
Message-Id: <ff66e0ba7eb3bf28169d3d270d72caf49f7c50c5.1647167475.git.kai.huang@intel.com>
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

The kernel configures TDX usable memory regions to the TDX module via
an array of "TD Memory Region" (TDMR).  Each TDMR entry (TDMR_INFO)
contains the information of the base/size of a memory region, the
base/size of the associated Physical Address Metadata Table (PAMT) and
a list of reserved areas in the region.

Create a number of TDMRs according to the verified e820 RAM entries.
As the first step only set up the base/size information for each TDMR.

TDMR must be 1G aligned and the size must be in 1G granularity.  This
implies that one TDMR could cover multiple e820 RAM entries.  If a RAM
entry spans the 1GB boundary and the former part is already covered by
the previous TDMR, just create a new TDMR for the latter part.

TDX only supports a limited number of TDMRs (currently 64).  Abort the
TDMR construction process when the number of TDMRs exceeds this
limitation.

Signed-off-by: Kai Huang <kai.huang@intel.com>
---
 arch/x86/virt/vmx/tdx.c | 138 ++++++++++++++++++++++++++++++++++++++++
 1 file changed, 138 insertions(+)

diff --git a/arch/x86/virt/vmx/tdx.c b/arch/x86/virt/vmx/tdx.c
index e5206599f558..1939b64d23e8 100644
--- a/arch/x86/virt/vmx/tdx.c
+++ b/arch/x86/virt/vmx/tdx.c
@@ -54,6 +54,18 @@
 		((u32)(((_keyid_part) & 0xffffffffull) + 1))
 #define TDX_KEYID_NUM(_keyid_part)	((u32)((_keyid_part) >> 32))
 
+/* TDMR must be 1gb aligned */
+#define TDMR_ALIGNMENT		BIT_ULL(30)
+#define TDMR_PFN_ALIGNMENT	(TDMR_ALIGNMENT >> PAGE_SHIFT)
+
+/* Align up and down the address to TDMR boundary */
+#define TDMR_ALIGN_DOWN(_addr)	ALIGN_DOWN((_addr), TDMR_ALIGNMENT)
+#define TDMR_ALIGN_UP(_addr)	ALIGN((_addr), TDMR_ALIGNMENT)
+
+/* TDMR's start and end address */
+#define TDMR_START(_tdmr)	((_tdmr)->base)
+#define TDMR_END(_tdmr)		((_tdmr)->base + (_tdmr)->size)
+
 /*
  * TDX module status during initialization
  */
@@ -809,6 +821,44 @@ static int e820_check_against_cmrs(void)
 	return 0;
 }
 
+/* The starting offset of reserved areas within TDMR_INFO */
+#define TDMR_RSVD_START		64
+
+static struct tdmr_info *__alloc_tdmr(void)
+{
+	int tdmr_sz;
+
+	/*
+	 * TDMR_INFO's actual size depends on maximum number of reserved
+	 * areas that one TDMR supports.
+	 */
+	tdmr_sz = TDMR_RSVD_START + tdx_sysinfo.max_reserved_per_tdmr *
+		sizeof(struct tdmr_reserved_area);
+
+	/*
+	 * TDX requires TDMR_INFO to be 512 aligned.  Always align up
+	 * TDMR_INFO size to 512 so the memory allocated via kzalloc()
+	 * can meet the alignment requirement.
+	 */
+	tdmr_sz = ALIGN(tdmr_sz, TDMR_INFO_ALIGNMENT);
+
+	return kzalloc(tdmr_sz, GFP_KERNEL);
+}
+
+/* Create a new TDMR at given index in the TDMR array */
+static struct tdmr_info *alloc_tdmr(struct tdmr_info **tdmr_array, int idx)
+{
+	struct tdmr_info *tdmr;
+
+	if (WARN_ON_ONCE(tdmr_array[idx]))
+		return NULL;
+
+	tdmr = __alloc_tdmr();
+	tdmr_array[idx] = tdmr;
+
+	return tdmr;
+}
+
 static void free_tdmrs(struct tdmr_info **tdmr_array, int tdmr_num)
 {
 	int i;
@@ -822,6 +872,89 @@ static void free_tdmrs(struct tdmr_info **tdmr_array, int tdmr_num)
 	}
 }
 
+/*
+ * Create TDMRs to cover all RAM entries in e820_table.  The created
+ * TDMRs are saved to @tdmr_array and @tdmr_num is set to the actual
+ * number of TDMRs.  All entries in @tdmr_array must be initially NULL.
+ */
+static int create_tdmrs(struct tdmr_info **tdmr_array, int *tdmr_num)
+{
+	struct tdmr_info *tdmr;
+	u64 start, end;
+	int i, tdmr_idx;
+	int ret = 0;
+
+	tdmr_idx = 0;
+	tdmr = alloc_tdmr(tdmr_array, 0);
+	if (!tdmr)
+		return -ENOMEM;
+	/*
+	 * Loop over all RAM entries in e820 and create TDMRs to cover
+	 * them.  To keep it simple, always try to use one TDMR to cover
+	 * one RAM entry.
+	 */
+	e820_for_each_mem(e820_table, i, start, end) {
+		start = TDMR_ALIGN_DOWN(start);
+		end = TDMR_ALIGN_UP(end);
+
+		/*
+		 * If the current TDMR's size hasn't been initialized, it
+		 * is a new allocated TDMR to cover the new RAM entry.
+		 * Otherwise the current TDMR already covers the previous
+		 * RAM entry.  In the latter case, check whether the
+		 * current RAM entry has been fully or partially covered
+		 * by the current TDMR, since TDMR is 1G aligned.
+		 */
+		if (tdmr->size) {
+			/*
+			 * Loop to next RAM entry if the current entry
+			 * is already fully covered by the current TDMR.
+			 */
+			if (end <= TDMR_END(tdmr))
+				continue;
+
+			/*
+			 * If part of current RAM entry has already been
+			 * covered by current TDMR, skip the already
+			 * covered part.
+			 */
+			if (start < TDMR_END(tdmr))
+				start = TDMR_END(tdmr);
+
+			/*
+			 * Create a new TDMR to cover the current RAM
+			 * entry, or the remaining part of it.
+			 */
+			tdmr_idx++;
+			if (tdmr_idx >= tdx_sysinfo.max_tdmrs) {
+				ret = -E2BIG;
+				goto err;
+			}
+			tdmr = alloc_tdmr(tdmr_array, tdmr_idx);
+			if (!tdmr) {
+				ret = -ENOMEM;
+				goto err;
+			}
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
+err:
+	/*
+	 * Clean up already allocated TDMRs in case of error.  @tdmr_idx
+	 * indicates the last TDMR that wasn't created successfully,
+	 * therefore only needs to free @tdmr_idx TDMRs.
+	 */
+	free_tdmrs(tdmr_array, tdmr_idx);
+	return ret;
+}
+
 static int construct_tdmrs(struct tdmr_info **tdmr_array, int *tdmr_num)
 {
 	int ret;
@@ -830,8 +963,13 @@ static int construct_tdmrs(struct tdmr_info **tdmr_array, int *tdmr_num)
 	if (ret)
 		goto err;
 
+	ret = create_tdmrs(tdmr_array, tdmr_num);
+	if (ret)
+		goto err;
+
 	/* Return -EFAULT until constructing TDMRs is done */
 	ret = -EFAULT;
+	free_tdmrs(tdmr_array, *tdmr_num);
 err:
 	return ret;
 }
-- 
2.35.1

