Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 53AB453973B
	for <lists+kvm@lfdr.de>; Tue, 31 May 2022 21:43:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347498AbiEaTl0 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 31 May 2022 15:41:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38922 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347376AbiEaTlP (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 31 May 2022 15:41:15 -0400
Received: from mga11.intel.com (mga11.intel.com [192.55.52.93])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E5A589CC8B;
        Tue, 31 May 2022 12:41:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1654026065; x=1685562065;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=As9TmP4V0cek54GSueWyDu7ZH47ZH3ThoezN5vKTOaI=;
  b=QmO3R5pzkUAXjWeYyfQqiGBEfyPyNUS87ajYrodNY1L1kEh4YjUa7Dv8
   KNgtgUDrG91/pTTVQhL2NggPkinoxAjS85PGhVV2vyyqpz6C/dWxAr46Y
   gNa9oGRaXUNgt2mfIp329u2TcyziSf59Vc2u+inmlzmNQrDz2dPcAI2N+
   QzFcmdFdraqfdVLoK/BmxdM5bpS9wqJDfPYveC/Ubl74B/w7mJkKE9lqq
   ODTbNb8QhqKXL0XvqPCMud6GBR6O8N6kQOTIF5JQfWCqKe8l73v8D7wR+
   uOByRIaMvx1R779k5yZmrcL19v4QtDOYXOGuJF5unvSxR4MSB6erg6pNW
   Q==;
X-IronPort-AV: E=McAfee;i="6400,9594,10364"; a="272935139"
X-IronPort-AV: E=Sophos;i="5.91,266,1647327600"; 
   d="scan'208";a="272935139"
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 31 May 2022 12:40:39 -0700
X-IronPort-AV: E=Sophos;i="5.91,266,1647327600"; 
   d="scan'208";a="645164522"
Received: from maciejwo-mobl1.ger.corp.intel.com (HELO khuang2-desk.gar.corp.intel.com) ([10.254.36.207])
  by fmsmga004-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 31 May 2022 12:40:36 -0700
From:   Kai Huang <kai.huang@intel.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     seanjc@google.com, pbonzini@redhat.com, dave.hansen@intel.com,
        len.brown@intel.com, tony.luck@intel.com,
        rafael.j.wysocki@intel.com, reinette.chatre@intel.com,
        dan.j.williams@intel.com, peterz@infradead.org, ak@linux.intel.com,
        kirill.shutemov@linux.intel.com,
        sathyanarayanan.kuppuswamy@linux.intel.com,
        isaku.yamahata@intel.com, kai.huang@intel.com
Subject: [PATCH v4 13/22] x86/virt/tdx: Add placeholder to construct TDMRs based on memblock
Date:   Wed,  1 Jun 2022 07:39:36 +1200
Message-Id: <aaee061c8bd2b779ae082049a32f704bdfe6d570.1654025431.git.kai.huang@intel.com>
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
TDX-usable memory by passing an array of TDMRs to the TDX module.

Constructing the array of TDMRs consists below steps:

1) Create TDMRs to cover all memory regions that TDX module can use;
2) Allocate and set up PAMT for each TDMR;
3) Set up reserved areas for each TDMR.

Add a placeholder to construct TDMRs to do the above steps after all
memblock memory regions are verified to be convertible.  Always free
TDMRs at the end of the initialization (no matter successful or not)
as TDMRs are only used during the initialization.

Signed-off-by: Kai Huang <kai.huang@intel.com>
---

- v3 -> v4:
 - Moved calculating TDMR size to this patch.
 - Changed to use alloc_pages_exact() to allocate buffer for all TDMRs
   once, instead of allocating each TDMR individually.
 - Removed "crypto protection" in the changelog.
 - -EFAULT -> -EINVAL in couple of places.

---
 arch/x86/virt/vmx/tdx/tdx.c | 73 +++++++++++++++++++++++++++++++++++++
 arch/x86/virt/vmx/tdx/tdx.h | 23 ++++++++++++
 2 files changed, 96 insertions(+)

diff --git a/arch/x86/virt/vmx/tdx/tdx.c b/arch/x86/virt/vmx/tdx/tdx.c
index b0b4841ec144..4aa02a992b59 100644
--- a/arch/x86/virt/vmx/tdx/tdx.c
+++ b/arch/x86/virt/vmx/tdx/tdx.c
@@ -17,6 +17,8 @@
 #include <linux/atomic.h>
 #include <linux/sizes.h>
 #include <linux/memblock.h>
+#include <linux/gfp.h>
+#include <linux/align.h>
 #include <asm/cpufeatures.h>
 #include <asm/cpufeature.h>
 #include <asm/msr-index.h>
@@ -431,6 +433,55 @@ static int check_memblock_tdx_convertible(void)
 	return 0;
 }
 
+/* Calculate the actual TDMR_INFO size */
+static inline int cal_tdmr_size(void)
+{
+	int tdmr_sz;
+
+	/*
+	 * The actual size of TDMR_INFO depends on the maximum number
+	 * of reserved areas.
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
+	 * cal_tdmr_size() always return 512-byte aligned size.
+	 */
+	*array_sz = cal_tdmr_size() * tdx_sysinfo.max_tdmrs;
+
+	/*
+	 * Zero the buffer so 'struct tdmr_info::size' can be
+	 * used to determine whether a TDMR is valid.
+	 */
+	return alloc_pages_exact(*array_sz, GFP_KERNEL | __GFP_ZERO);
+}
+
+/*
+ * Construct an array of TDMRs to cover all memory regions in memblock.
+ * This makes sure all pages managed by the page allocator are TDX
+ * memory.  The actual number of TDMRs is kept to @tdmr_num.
+ */
+static int construct_tdmrs_memeblock(struct tdmr_info *tdmr_array,
+				     int *tdmr_num)
+{
+	/* Return -EINVAL until constructing TDMRs is done */
+	return -EINVAL;
+}
+
 /*
  * Detect and initialize the TDX module.
  *
@@ -440,6 +491,9 @@ static int check_memblock_tdx_convertible(void)
  */
 static int init_tdx_module(void)
 {
+	struct tdmr_info *tdmr_array;
+	int tdmr_array_sz;
+	int tdmr_num;
 	int ret;
 
 	/*
@@ -477,11 +531,30 @@ static int init_tdx_module(void)
 	if (ret)
 		goto out;
 
+	/* Prepare enough space to construct TDMRs */
+	tdmr_array = alloc_tdmr_array(&tdmr_array_sz);
+	if (!tdmr_array) {
+		ret = -ENOMEM;
+		goto out;
+	}
+
+	/* Construct TDMRs to cover all memory regions in memblock */
+	ret = construct_tdmrs_memeblock(tdmr_array, &tdmr_num);
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
 out:
 	return ret;
 }
diff --git a/arch/x86/virt/vmx/tdx/tdx.h b/arch/x86/virt/vmx/tdx/tdx.h
index 63b1edd11660..55d6c69ab900 100644
--- a/arch/x86/virt/vmx/tdx/tdx.h
+++ b/arch/x86/virt/vmx/tdx/tdx.h
@@ -114,6 +114,29 @@ struct tdsysinfo_struct {
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
  * Do not put any hardware-defined TDX structure representations below this
  * comment!
-- 
2.35.3

