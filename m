Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4C6E469451A
	for <lists+kvm@lfdr.de>; Mon, 13 Feb 2023 13:02:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231356AbjBMMCj (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 13 Feb 2023 07:02:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39550 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231259AbjBMMCL (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 13 Feb 2023 07:02:11 -0500
Received: from mga01.intel.com (mga01.intel.com [192.55.52.88])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D9E401ABCA;
        Mon, 13 Feb 2023 04:01:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1676289705; x=1707825705;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=Qg+L2xamk2c4dM8UMQqLpZigSzwKoQvWiqi4pXBJ/Dw=;
  b=fHyevYYphDetfX6rECRsJG53eBB7yKvyKpCighteDq1lujmMSoOKMyWG
   byEm6iRWdcJW6xe0felYf5TGuwYBj1RKTibJ5jckyu102kOWEKCdh7ABZ
   bT7vs6yS2Xw3fbQpRN6791tYfRIyBTILxgbhZlASbr05xd1qp8ghCxxWt
   KV6prBSkdxuzhyr4w+Rv3WqMildJRm+7Ugf9pkuFiNhKAXb1p0c6nVpah
   bCW23aRVuf1lP4ZSXPkjtg9k0lGePlhzp6hIIX2Nk2Em0LfaBD6z4sPbY
   KQg41LHmpDULAI2ZTW0MY6mZ7Y356MSF4WhDthToBhA/F2eUFoxWqR0+d
   g==;
X-IronPort-AV: E=McAfee;i="6500,9779,10619"; a="358283350"
X-IronPort-AV: E=Sophos;i="5.97,293,1669104000"; 
   d="scan'208";a="358283350"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Feb 2023 04:01:05 -0800
X-IronPort-AV: E=McAfee;i="6500,9779,10619"; a="701243352"
X-IronPort-AV: E=Sophos;i="5.97,293,1669104000"; 
   d="scan'208";a="701243352"
Received: from wonger-mobl.amr.corp.intel.com (HELO khuang2-desk.gar.corp.intel.com) ([10.209.188.34])
  by orsmga001-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Feb 2023 04:01:00 -0800
From:   Kai Huang <kai.huang@intel.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     linux-mm@kvack.org, dave.hansen@intel.com, peterz@infradead.org,
        tglx@linutronix.de, seanjc@google.com, pbonzini@redhat.com,
        dan.j.williams@intel.com, rafael.j.wysocki@intel.com,
        kirill.shutemov@linux.intel.com, ying.huang@intel.com,
        reinette.chatre@intel.com, len.brown@intel.com,
        tony.luck@intel.com, ak@linux.intel.com, isaku.yamahata@intel.com,
        chao.gao@intel.com, sathyanarayanan.kuppuswamy@linux.intel.com,
        david@redhat.com, bagasdotme@gmail.com, sagis@google.com,
        imammedo@redhat.com, kai.huang@intel.com
Subject: [PATCH v9 10/18] x86/virt/tdx: Add placeholder to construct TDMRs to cover all TDX memory regions
Date:   Tue, 14 Feb 2023 00:59:17 +1300
Message-Id: <017a73980fbf276fbd18811ed567462febd2c085.1676286526.git.kai.huang@intel.com>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <cover.1676286526.git.kai.huang@intel.com>
References: <cover.1676286526.git.kai.huang@intel.com>
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

Add a placeholder to construct TDMRs to do the above steps.  To keep
things simple, just allocate enough space to hold maximum number of
TDMRs up front.

Although the TDMRs are not used by the TDX module anymore after module
initialization, still keep the TDMRs as static as they are needed to
find PAMTs when TDX gets disabled after module initialization.

Signed-off-by: Kai Huang <kai.huang@intel.com>
Reviewed-by: Isaku Yamahata <isaku.yamahata@intel.com>
---

v8 -> v9:
 - Changes around 'struct tdmr_info_list' (Dave):
   - Moved the declaration from tdx.c to tdx.h.
   - Renamed 'first_tdmr' to 'tdmrs'.
   - 'nr_tdmrs' -> 'nr_consumed_tdmrs'.
   - Changed 'tdmrs' to 'void *'.
   - Improved comments for all structure members.
 - Added a missing empty line in alloc_tdmr_list() (Dave).

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
 arch/x86/virt/vmx/tdx/tdx.c | 97 ++++++++++++++++++++++++++++++++++++-
 arch/x86/virt/vmx/tdx/tdx.h | 32 ++++++++++++
 2 files changed, 127 insertions(+), 2 deletions(-)

diff --git a/arch/x86/virt/vmx/tdx/tdx.c b/arch/x86/virt/vmx/tdx/tdx.c
index 5101b636a9b0..f604e3399d03 100644
--- a/arch/x86/virt/vmx/tdx/tdx.c
+++ b/arch/x86/virt/vmx/tdx/tdx.c
@@ -22,6 +22,7 @@
 #include <linux/minmax.h>
 #include <linux/sizes.h>
 #include <linux/pfn.h>
+#include <linux/align.h>
 #include <asm/msr-index.h>
 #include <asm/msr.h>
 #include <asm/page.h>
@@ -43,6 +44,9 @@ static cpumask_t *cpu_tdx_mask = &__cpu_tdx_mask;
 /* All TDX-usable memory regions.  Protected by mem_hotplug_lock. */
 static LIST_HEAD(tdx_memlist);
 
+/* The list of TDMRs passed to TDX module */
+struct tdmr_info_list tdx_tdmr_list;
+
 /*
  * Use tdx_global_keyid to indicate that TDX is uninitialized.
  * This is used in TDX initialization error paths to take it from
@@ -423,6 +427,80 @@ static int build_tdx_memlist(struct list_head *tmb_list)
 	return ret;
 }
 
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
+	tdmr_list->tdmrs = tdmr_array;
+
+	/*
+	 * Keep the size of TDMR to find the target TDMR
+	 * at a given index in the TDMR list.
+	 */
+	tdmr_list->tdmr_sz = tdmr_sz;
+	tdmr_list->max_tdmrs = sysinfo->max_tdmrs;
+	tdmr_list->nr_consumed_tdmrs = 0;
+
+	return 0;
+}
+
+static void free_tdmr_list(struct tdmr_info_list *tdmr_list)
+{
+	free_pages_exact(tdmr_list->tdmrs,
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
 	static DECLARE_PADDED_STRUCT(tdsysinfo_struct, tdsysinfo,
@@ -477,11 +555,19 @@ static int init_tdx_module(void)
 	if (ret)
 		goto out;
 
+	/* Allocate enough space for constructing TDMRs */
+	ret = alloc_tdmr_list(&tdx_tdmr_list, sysinfo);
+	if (ret)
+		goto out_free_tdx_mem;
+
+	/* Cover all TDX-usable memory regions in TDMRs */
+	ret = construct_tdmrs(&tdx_memlist, &tdx_tdmr_list, sysinfo);
+	if (ret)
+		goto out_free_tdmrs;
+
 	/*
 	 * TODO:
 	 *
-	 *  - Construct a list of "TD Memory Regions" (TDMRs) to cover
-	 *    all TDX-usable memory regions.
 	 *  - Configure the TDMRs and the global KeyID to the TDX module.
 	 *  - Configure the global KeyID on all packages.
 	 *  - Initialize all TDMRs.
@@ -489,6 +575,12 @@ static int init_tdx_module(void)
 	 *  Return error before all steps are done.
 	 */
 	ret = -EINVAL;
+out_free_tdmrs:
+	if (ret)
+		free_tdmr_list(&tdx_tdmr_list);
+out_free_tdx_mem:
+	if (ret)
+		free_tdx_memlist(&tdx_memlist);
 out:
 	/*
 	 * @tdx_memlist is written here and read at memory hotplug time.
@@ -538,6 +630,7 @@ static void disable_tdx_module(void)
 	 * init_tdx_module().  Remove this comment after
 	 * all steps are done.
 	 */
+	free_tdmr_list(&tdx_tdmr_list);
 	free_tdx_memlist(&tdx_memlist);
 	cpumask_clear(cpu_tdx_mask);
 }
diff --git a/arch/x86/virt/vmx/tdx/tdx.h b/arch/x86/virt/vmx/tdx/tdx.h
index edb1d697347f..66c7617b357c 100644
--- a/arch/x86/virt/vmx/tdx/tdx.h
+++ b/arch/x86/virt/vmx/tdx/tdx.h
@@ -87,6 +87,29 @@ struct tdsysinfo_struct {
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
@@ -118,6 +141,15 @@ struct tdx_memblock {
 	unsigned long end_pfn;
 };
 
+struct tdmr_info_list {
+	void *tdmrs;	/* Flexible array to hold 'tdmr_info's */
+	int nr_consumed_tdmrs;	/* How many 'tdmr_info's are in use */
+
+	/* Metadata for finding target 'tdmr_info' and freeing @tdmrs */
+	int tdmr_sz;	/* Size of one 'tdmr_info' */
+	int max_tdmrs;	/* How many 'tdmr_info's are allocated */
+};
+
 struct tdx_module_output;
 u64 __seamcall(u64 fn, u64 rcx, u64 rdx, u64 r8, u64 r9,
 	       struct tdx_module_output *out);
-- 
2.39.1

