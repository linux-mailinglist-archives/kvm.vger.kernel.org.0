Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 51A2A6317B4
	for <lists+kvm@lfdr.de>; Mon, 21 Nov 2022 01:28:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229952AbiKUA2w (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 20 Nov 2022 19:28:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58426 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229939AbiKUA1p (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 20 Nov 2022 19:27:45 -0500
Received: from mga07.intel.com (mga07.intel.com [134.134.136.100])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 329ED1DDC4;
        Sun, 20 Nov 2022 16:27:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1668990464; x=1700526464;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=znmF9BwMgILl7Jshlgv9LDu7pEGe6gH0wYN4oKNnxSU=;
  b=lIG1YbKVek7SRmRs2ulPJr/54zdTj04/YEKb14bLim0gDl7HAFBqoe7J
   ByBLoEQ+Sl7wMu4A3c+PN9058Uq/p3aWQoqBPVUBQ0mat6pxuysS+2UiU
   ON33luCIE6KYOZHRuvxCjFz+HjYXbPLtP2HtkR3/4OhduRbju2gqyCKWC
   IYqaxiSllS/rtDrLSv2nQHjsxOe80y1LDwE65pS1aJ3K4B3/Z6tAIxR5H
   fmxdhMnl0j05De0/f0SEZMaZoGlnqkDeBz2ZzWk0kOY2cqXNoq1jlhVkh
   CuGeUiD6kRWsafWUZGq6t+M2rWIJwSnPU2isakMZkBsuXZP6dClrOQSXs
   w==;
X-IronPort-AV: E=McAfee;i="6500,9779,10537"; a="377705706"
X-IronPort-AV: E=Sophos;i="5.96,180,1665471600"; 
   d="scan'208";a="377705706"
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Nov 2022 16:27:42 -0800
X-IronPort-AV: E=McAfee;i="6500,9779,10537"; a="729825390"
X-IronPort-AV: E=Sophos;i="5.96,180,1665471600"; 
   d="scan'208";a="729825390"
Received: from tomnavar-mobl.amr.corp.intel.com (HELO khuang2-desk.gar.corp.intel.com) ([10.209.176.15])
  by fmsmga003-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Nov 2022 16:27:38 -0800
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
Subject: [PATCH v7 11/20] x86/virt/tdx: Add placeholder to construct TDMRs to cover all TDX memory regions
Date:   Mon, 21 Nov 2022 13:26:33 +1300
Message-Id: <32c1968fe34c8cf3cb834e3a9966cd2a201efc5b.1668988357.git.kai.huang@intel.com>
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

TDX provides increased levels of memory confidentiality and integrity.
This requires special hardware support for features like memory
encryption and storage of memory integrity checksums.  Not all memory
satisfies these requirements.

As a result, the TDX introduced the concept of a "Convertible Memory
Region" (CMR).  During boot, the firmware builds a list of all of the
memory ranges which can provide the TDX security guarantees.  The list
of these ranges is available to the kernel by querying the TDX module.

The TDX architecture needs additional metadata to record things like
which TD guest "owns" a given page of memory.  This metadata essentially
serves as the 'struct page' for the TDX module.  The space for this
metadata is not reserved by the hardware up front and must be allocated
by the kernel and given to the TDX module.

Since this metadata consumes space, the VMM can choose whether or not to
allocate it for a given area of convertible memory.  If it chooses not
to, the memory cannot receive TDX protections and can not be used by TDX
guests as private memory.

For every memory region that the VMM wants to use as TDX memory, it sets
up a "TD Memory Region" (TDMR).  Each TDMR represents a physically
contiguous convertible range and must also have its own physically
contiguous metadata table, referred to as a Physical Address Metadata
Table (PAMT), to track status for each page in the TDMR range.

Unlike a CMR, each TDMR requires 1G granularity and alignment.  To
support physical RAM areas that don't meet those strict requirements,
each TDMR permits a number of internal "reserved areas" which can be
placed over memory holes.  If PAMT metadata is placed within a TDMR it
must be covered by one of these reserved areas.

Let's summarize the concepts:

 CMR - Firmware-enumerated physical ranges that support TDX.  CMRs are
       4K aligned.
TDMR - Physical address range which is chosen by the kernel to support
       TDX.  1G granularity and alignment required.  Each TDMR has
       reserved areas where TDX memory holes and overlapping PAMTs can
       be put into.
PAMT - Physically contiguous TDX metadata.  One table for each page size
       per TDMR.  Roughly 1/256th of TDMR in size.  256G TDMR = ~1G
       PAMT.

As one step of initializing the TDX module, the kernel configures
TDX-usable memory regions by passing an array of TDMRs to the TDX module.

Constructing the array of TDMRs consists below steps:

1) Create TDMRs to cover all memory regions that the TDX module can use;
2) Allocate and set up PAMT for each TDMR;
3) Set up reserved areas for each TDMR.

Add a placeholder to construct TDMRs to do the above steps after all
TDX memory regions are verified to be truly convertible.  Always free
TDMRs at the end of the initialization (no matter successful or not)
as TDMRs are only used during the initialization.

Reviewed-by: Isaku Yamahata <isaku.yamahata@intel.com>
Signed-off-by: Kai Huang <kai.huang@intel.com>
---

v6 -> v7:
 - Improved commit message to explain 'int' overflow cannot happen
   in cal_tdmr_size() and alloc_tdmr_array(). -- Andy/Dave.

v5 -> v6:
 - construct_tdmrs_memblock() -> construct_tdmrs() as 'tdx_memblock' is
   used instead of memblock.
 - Added Isaku's Reviewed-by.

- v3 -> v5 (no feedback on v4):
 - Moved calculating TDMR size to this patch.
 - Changed to use alloc_pages_exact() to allocate buffer for all TDMRs
   once, instead of allocating each TDMR individually.
 - Removed "crypto protection" in the changelog.
 - -EFAULT -> -EINVAL in couple of places.


---
 arch/x86/virt/vmx/tdx/tdx.c | 83 +++++++++++++++++++++++++++++++++++++
 arch/x86/virt/vmx/tdx/tdx.h | 23 ++++++++++
 2 files changed, 106 insertions(+)

diff --git a/arch/x86/virt/vmx/tdx/tdx.c b/arch/x86/virt/vmx/tdx/tdx.c
index 32af86e31c47..26048c6b0170 100644
--- a/arch/x86/virt/vmx/tdx/tdx.c
+++ b/arch/x86/virt/vmx/tdx/tdx.c
@@ -445,6 +445,63 @@ static int build_tdx_memory(void)
 	return ret;
 }
 
+/* Calculate the actual TDMR_INFO size */
+static inline int cal_tdmr_size(void)
+{
+	int tdmr_sz;
+
+	/*
+	 * The actual size of TDMR_INFO depends on the maximum number
+	 * of reserved areas.
+	 *
+	 * Note: for TDX1.0 the max_reserved_per_tdmr is 16, and
+	 * TDMR_INFO size is aligned up to 512-byte.  Even it is
+	 * extended in the future, it would be insane if TDMR_INFO
+	 * becomes larger than 4K.  The tdmr_sz here should never
+	 * overflow.
+	 */
+	tdmr_sz = sizeof(struct tdmr_info);
+	tdmr_sz += sizeof(struct tdmr_reserved_area) *
+		   tdx_sysinfo.max_reserved_per_tdmr;
+
+	/*
+	 * TDX requires each TDMR_INFO to be 512-byte aligned.  Always
+	 * round up TDMR_INFO size to the 512-byte boundary.
+	 */
+	return ALIGN(tdmr_sz, TDMR_INFO_ALIGNMENT);
+}
+
+static struct tdmr_info *alloc_tdmr_array(int *array_sz)
+{
+	/*
+	 * TDX requires each TDMR_INFO to be 512-byte aligned.
+	 * Use alloc_pages_exact() to allocate all TDMRs at once.
+	 * Each TDMR_INFO will still be 512-byte aligned since
+	 * cal_tdmr_size() always returns 512-byte aligned size.
+	 */
+	*array_sz = cal_tdmr_size() * tdx_sysinfo.max_tdmrs;
+
+	/*
+	 * Zero the buffer so 'struct tdmr_info::size' can be
+	 * used to determine whether a TDMR is valid.
+	 *
+	 * Note: for TDX1.0 the max_tdmrs is 64 and TDMR_INFO size
+	 * is 512-byte.  Even they are extended in the future, it
+	 * would be insane if the total size exceeds 4MB.
+	 */
+	return alloc_pages_exact(*array_sz, GFP_KERNEL | __GFP_ZERO);
+}
+
+/*
+ * Construct an array of TDMRs to cover all TDX memory ranges.
+ * The actual number of TDMRs is kept to @tdmr_num.
+ */
+static int construct_tdmrs(struct tdmr_info *tdmr_array, int *tdmr_num)
+{
+	/* Return -EINVAL until constructing TDMRs is done */
+	return -EINVAL;
+}
+
 /*
  * Detect and initialize the TDX module.
  *
@@ -454,6 +511,9 @@ static int build_tdx_memory(void)
  */
 static int init_tdx_module(void)
 {
+	struct tdmr_info *tdmr_array;
+	int tdmr_array_sz;
+	int tdmr_num;
 	int ret;
 
 	/*
@@ -506,11 +566,34 @@ static int init_tdx_module(void)
 	ret = build_tdx_memory();
 	if (ret)
 		goto out;
+
+	/* Prepare enough space to construct TDMRs */
+	tdmr_array = alloc_tdmr_array(&tdmr_array_sz);
+	if (!tdmr_array) {
+		ret = -ENOMEM;
+		goto out_free_tdx_mem;
+	}
+
+	/* Construct TDMRs to cover all TDX memory ranges */
+	ret = construct_tdmrs(tdmr_array, &tdmr_num);
+	if (ret)
+		goto out_free_tdmrs;
+
 	/*
 	 * Return -EINVAL until all steps of TDX module initialization
 	 * process are done.
 	 */
 	ret = -EINVAL;
+out_free_tdmrs:
+	/*
+	 * The array of TDMRs is freed no matter the initialization is
+	 * successful or not.  They are not needed anymore after the
+	 * module initialization.
+	 */
+	free_pages_exact(tdmr_array, tdmr_array_sz);
+out_free_tdx_mem:
+	if (ret)
+		free_tdx_memory();
 out:
 	/*
 	 * Memory hotplug checks the hot-added memory region against the
diff --git a/arch/x86/virt/vmx/tdx/tdx.h b/arch/x86/virt/vmx/tdx/tdx.h
index 8e273756098c..a737f2b51474 100644
--- a/arch/x86/virt/vmx/tdx/tdx.h
+++ b/arch/x86/virt/vmx/tdx/tdx.h
@@ -80,6 +80,29 @@ struct tdsysinfo_struct {
 	};
 } __packed __aligned(TDSYSINFO_STRUCT_ALIGNMENT);
 
+struct tdmr_reserved_area {
+	u64 offset;
+	u64 size;
+} __packed;
+
+#define TDMR_INFO_ALIGNMENT	512
+
+struct tdmr_info {
+	u64 base;
+	u64 size;
+	u64 pamt_1g_base;
+	u64 pamt_1g_size;
+	u64 pamt_2m_base;
+	u64 pamt_2m_size;
+	u64 pamt_4k_base;
+	u64 pamt_4k_size;
+	/*
+	 * Actual number of reserved areas depends on
+	 * 'struct tdsysinfo_struct'::max_reserved_per_tdmr.
+	 */
+	struct tdmr_reserved_area reserved_areas[0];
+} __packed __aligned(TDMR_INFO_ALIGNMENT);
+
 /*
  * Do not put any hardware-defined TDX structure representations below
  * this comment!
-- 
2.38.1

