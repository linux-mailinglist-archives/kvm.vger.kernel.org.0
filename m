Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7F3EC647E14
	for <lists+kvm@lfdr.de>; Fri,  9 Dec 2022 07:55:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229988AbiLIGz2 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 9 Dec 2022 01:55:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40878 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229769AbiLIGyr (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 9 Dec 2022 01:54:47 -0500
Received: from mga09.intel.com (mga09.intel.com [134.134.136.24])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E2241A65A1;
        Thu,  8 Dec 2022 22:53:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1670568825; x=1702104825;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=D+jCp1tbjtRLXfVHa9PahUAAUr8LxwkuzJ2V9nLXOCM=;
  b=EYBXwhwU4Yaw/NOUmsWzkLgyu6a5VqthJLougpNBbrs68LxuoU7PCRpk
   OAuKPTpRauLg7D8VwQTbldG+EZ+luFBUZSYmkKFeg2Eg7stbAcCT51O89
   iQdChA4GkXaDvy7UHyk4ty9RiVn6njAZA4Y0CdjACDzw4VGgYjIt9Fbf+
   fjxt6pejqVJ17RGb74FduLQPajFm8Y+3Lq8cTLpP6sf+VRX5R1f7scN2D
   1xwF4wVQsuyIYqNYTTeTKDJd5QKtSAWgulKULvWz8lgPEqn1s8R2YIcWC
   tLotj4wiZhMW46dacRHagLBjrjNEehr3jVbeHFHdZ/knL3zppkuqwVl+Z
   w==;
X-IronPort-AV: E=McAfee;i="6500,9779,10555"; a="318551372"
X-IronPort-AV: E=Sophos;i="5.96,230,1665471600"; 
   d="scan'208";a="318551372"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Dec 2022 22:53:41 -0800
X-IronPort-AV: E=McAfee;i="6500,9779,10555"; a="679836973"
X-IronPort-AV: E=Sophos;i="5.96,230,1665471600"; 
   d="scan'208";a="679836973"
Received: from omiramon-mobl1.amr.corp.intel.com (HELO khuang2-desk.gar.corp.intel.com) ([10.212.28.82])
  by orsmga001-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Dec 2022 22:53:36 -0800
From:   Kai Huang <kai.huang@intel.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     linux-mm@kvack.org, dave.hansen@intel.com, peterz@infradead.org,
        tglx@linutronix.de, seanjc@google.com, pbonzini@redhat.com,
        dan.j.williams@intel.com, rafael.j.wysocki@intel.com,
        kirill.shutemov@linux.intel.com, ying.huang@intel.com,
        reinette.chatre@intel.com, len.brown@intel.com,
        tony.luck@intel.com, ak@linux.intel.com, isaku.yamahata@intel.com,
        chao.gao@intel.com, sathyanarayanan.kuppuswamy@linux.intel.com,
        bagasdotme@gmail.com, sagis@google.com, imammedo@redhat.com,
        kai.huang@intel.com
Subject: [PATCH v8 08/16] x86/virt/tdx: Add placeholder to construct TDMRs to cover all TDX memory regions
Date:   Fri,  9 Dec 2022 19:52:29 +1300
Message-Id: <ef6fe9247007ee8e15272de01ded1e0a9152be02.1670566861.git.kai.huang@intel.com>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <cover.1670566861.git.kai.huang@intel.com>
References: <cover.1670566861.git.kai.huang@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

After the kernel selects all TDX-usable memory regions, the kernel needs
to pass those regions to the TDX module via data structure "TD Memory
Region" (TDMR).

Add a placeholder to construct a list of TDMRs (in multiple steps) to
cover all TDX-usable memory regions.

=== Long Version ===

TDX provides increased levels of memory confidentiality and integrity.
This requires special hardware support for features like memory
encryption and storage of memory integrity checksums.  Not all memory
satisfies these requirements.

As a result, TDX introduced the concept of a "Convertible Memory Region"
(CMR).  During boot, the firmware builds a list of all of the memory
ranges which can provide the TDX security guarantees.  The list of these
ranges is available to the kernel by querying the TDX module.

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
       be represented.
PAMT - Physically contiguous TDX metadata.  One table for each page size
       per TDMR.  Roughly 1/256th of TDMR in size.  256G TDMR = ~1G
       PAMT.

As one step of initializing the TDX module, the kernel configures
TDX-usable memory regions by passing a list of TDMRs to the TDX module.

Constructing the list of TDMRs consists below steps:

1) Fill out TDMRs to cover all memory regions that the TDX module will
   use for TD memory.
2) Allocate and set up PAMT for each TDMR.
3) Designate reserved areas for each TDMR.

Add a placeholder to construct TDMRs to do the above steps.  Always free
the space for TDMRs at the end of the module initialization (no matter
successful or not) as TDMRs are only used during the initialization.

Reviewed-by: Isaku Yamahata <isaku.yamahata@intel.com>
Signed-off-by: Kai Huang <kai.huang@intel.com>
---

v7 -> v8:
 - Improved changelog to tell this is one step of "TODO list" in
   init_tdx_module().
 - Other changelog improvement suggested by Dave (with "Create TDMRs" to
   "Fill out TDMRs" to align with the code).
 - Added a "TODO list" comment to lay out the steps to construct TDMRs,
   following the same idea of "TODO list" in tdx_module_init().
 - Introduced 'struct tdmr_info_list' (Dave)
 - Further added additional members (tdmr_sz/max_tdmrs/nr_tdmrs) to
   simplify getting TDMR by given index, and reduce passing arguments
   around functions.
 - Added alloc_tdmr_list()/free_tdmr_list() accordingly, which internally
   uses tdmr_size_single() (Dave).
 - tdmr_num -> nr_tdmrs (Dave).

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
 arch/x86/virt/vmx/tdx/tdx.c | 104 +++++++++++++++++++++++++++++++++++-
 arch/x86/virt/vmx/tdx/tdx.h |  23 ++++++++
 2 files changed, 125 insertions(+), 2 deletions(-)

diff --git a/arch/x86/virt/vmx/tdx/tdx.c b/arch/x86/virt/vmx/tdx/tdx.c
index f010402f443d..d36ac72ef299 100644
--- a/arch/x86/virt/vmx/tdx/tdx.c
+++ b/arch/x86/virt/vmx/tdx/tdx.c
@@ -20,6 +20,7 @@
 #include <linux/minmax.h>
 #include <linux/sizes.h>
 #include <linux/pfn.h>
+#include <linux/align.h>
 #include <asm/pgtable_types.h>
 #include <asm/msr.h>
 #include <asm/tdx.h>
@@ -347,6 +348,86 @@ static int build_tdx_memlist(struct list_head *tmb_list)
 	return ret;
 }
 
+struct tdmr_info_list {
+	struct tdmr_info *first_tdmr;
+	int tdmr_sz;
+	int max_tdmrs;
+	int nr_tdmrs;	/* Actual number of TDMRs */
+};
+
+/* Calculate the actual TDMR size */
+static int tdmr_size_single(u16 max_reserved_per_tdmr)
+{
+	int tdmr_sz;
+
+	/*
+	 * The actual size of TDMR depends on the maximum
+	 * number of reserved areas.
+	 */
+	tdmr_sz = sizeof(struct tdmr_info);
+	tdmr_sz += sizeof(struct tdmr_reserved_area) * max_reserved_per_tdmr;
+
+	return ALIGN(tdmr_sz, TDMR_INFO_ALIGNMENT);
+}
+
+static int alloc_tdmr_list(struct tdmr_info_list *tdmr_list,
+			   struct tdsysinfo_struct *sysinfo)
+{
+	size_t tdmr_sz, tdmr_array_sz;
+	void *tdmr_array;
+
+	tdmr_sz = tdmr_size_single(sysinfo->max_reserved_per_tdmr);
+	tdmr_array_sz = tdmr_sz * sysinfo->max_tdmrs;
+
+	/*
+	 * To keep things simple, allocate all TDMRs together.
+	 * The buffer needs to be physically contiguous to make
+	 * sure each TDMR is physically contiguous.
+	 */
+	tdmr_array = alloc_pages_exact(tdmr_array_sz,
+			GFP_KERNEL | __GFP_ZERO);
+	if (!tdmr_array)
+		return -ENOMEM;
+
+	tdmr_list->first_tdmr = tdmr_array;
+	/*
+	 * Keep the size of TDMR to find the target TDMR
+	 * at a given index in the TDMR list.
+	 */
+	tdmr_list->tdmr_sz = tdmr_sz;
+	tdmr_list->max_tdmrs = sysinfo->max_tdmrs;
+	tdmr_list->nr_tdmrs = 0;
+
+	return 0;
+}
+
+static void free_tdmr_list(struct tdmr_info_list *tdmr_list)
+{
+	free_pages_exact(tdmr_list->first_tdmr,
+			tdmr_list->max_tdmrs * tdmr_list->tdmr_sz);
+}
+
+/*
+ * Construct a list of TDMRs on the preallocated space in @tdmr_list
+ * to cover all TDX memory regions in @tmb_list based on the TDX module
+ * information in @sysinfo.
+ */
+static int construct_tdmrs(struct list_head *tmb_list,
+			   struct tdmr_info_list *tdmr_list,
+			   struct tdsysinfo_struct *sysinfo)
+{
+	/*
+	 * TODO:
+	 *
+	 *  - Fill out TDMRs to cover all TDX memory regions.
+	 *  - Allocate and set up PAMTs for each TDMR.
+	 *  - Designate reserved areas for each TDMR.
+	 *
+	 * Return -EINVAL until constructing TDMRs is done
+	 */
+	return -EINVAL;
+}
+
 static int init_tdx_module(void)
 {
 	/*
@@ -358,6 +439,7 @@ static int init_tdx_module(void)
 			TDSYSINFO_STRUCT_SIZE, TDSYSINFO_STRUCT_ALIGNMENT);
 	struct cmr_info cmr_array[MAX_CMRS] __aligned(CMR_INFO_ARRAY_ALIGNMENT);
 	struct tdsysinfo_struct *sysinfo = &PADDED_STRUCT(tdsysinfo);
+	struct tdmr_info_list tdmr_list;
 	int ret;
 
 	ret = tdx_get_sysinfo(sysinfo, cmr_array);
@@ -380,11 +462,19 @@ static int init_tdx_module(void)
 	if (ret)
 		goto out;
 
+	/* Allocate enough space for constructing TDMRs */
+	ret = alloc_tdmr_list(&tdmr_list, sysinfo);
+	if (ret)
+		goto out_free_tdx_mem;
+
+	/* Cover all TDX-usable memory regions in TDMRs */
+	ret = construct_tdmrs(&tdx_memlist, &tdmr_list, sysinfo);
+	if (ret)
+		goto out_free_tdmrs;
+
 	/*
 	 * TODO:
 	 *
-	 *  - Construct a list of TDMRs to cover all TDX-usable memory
-	 *    regions.
 	 *  - Pick up one TDX private KeyID as the global KeyID.
 	 *  - Configure the TDMRs and the global KeyID to the TDX module.
 	 *  - Configure the global KeyID on all packages.
@@ -393,6 +483,16 @@ static int init_tdx_module(void)
 	 *  Return error before all steps are done.
 	 */
 	ret = -EINVAL;
+out_free_tdmrs:
+	/*
+	 * Free the space for the TDMRs no matter the initialization is
+	 * successful or not.  They are not needed anymore after the
+	 * module initialization.
+	 */
+	free_tdmr_list(&tdmr_list);
+out_free_tdx_mem:
+	if (ret)
+		free_tdx_memlist(&tdx_memlist);
 out:
 	/*
 	 * @tdx_memlist is written here and read at memory hotplug time.
diff --git a/arch/x86/virt/vmx/tdx/tdx.h b/arch/x86/virt/vmx/tdx/tdx.h
index 6d32f62e4182..d0c762f1a94c 100644
--- a/arch/x86/virt/vmx/tdx/tdx.h
+++ b/arch/x86/virt/vmx/tdx/tdx.h
@@ -90,6 +90,29 @@ struct tdsysinfo_struct {
 	DECLARE_FLEX_ARRAY(struct cpuid_config, cpuid_configs);
 } __packed;
 
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
+	DECLARE_FLEX_ARRAY(struct tdmr_reserved_area, reserved_areas);
+} __packed __aligned(TDMR_INFO_ALIGNMENT);
+
 /*
  * Do not put any hardware-defined TDX structure representations below
  * this comment!
-- 
2.38.1

