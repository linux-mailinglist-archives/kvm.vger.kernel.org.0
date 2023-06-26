Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C37B873E1C2
	for <lists+kvm@lfdr.de>; Mon, 26 Jun 2023 16:15:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231304AbjFZOPo (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 26 Jun 2023 10:15:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35038 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231317AbjFZOPO (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 26 Jun 2023 10:15:14 -0400
Received: from mga18.intel.com (mga18.intel.com [134.134.136.126])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5C2721BEB;
        Mon, 26 Jun 2023 07:14:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1687788888; x=1719324888;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=wvJSBN1kOn+AYyboyGj5Bhc8rXHBHFIzE6dnntQRy8s=;
  b=U+96Ot/yUAP8UudKJNtPSglTN8Mn2ezMYJlOmM6GQznMVUqBkxfFTHYs
   kGDhwZIV/Kwk4BEVXdWBDSpwnqaAxcRzc2u0QTPicKwz0MYMMNDA8QOMA
   alwiKJI2sjcuanhqNsF/LohBb7NK3XrUQU7K8crGm6BjHcsQXebHVBzuH
   fUlLKhGPKx5wHZiibiJR2DSkk/GIN9trbyrJX0ZpAoACr7rebqSIEMOay
   PdtGLP3P537MXfKsR6op+SfWJ69XvWMtP/E9VGlGWay91KsAY65/MmXFm
   8Z43qj7eoE6hx5d37lJ63lQvfK9RP1ca/CH5gASiFifbzA8Qg42nbxO4i
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10753"; a="346033799"
X-IronPort-AV: E=Sophos;i="6.01,159,1684825200"; 
   d="scan'208";a="346033799"
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Jun 2023 07:14:40 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10753"; a="890292348"
X-IronPort-AV: E=Sophos;i="6.01,159,1684825200"; 
   d="scan'208";a="890292348"
Received: from smithau-mobl1.amr.corp.intel.com (HELO khuang2-desk.gar.corp.intel.com) ([10.213.179.223])
  by orsmga005-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Jun 2023 07:14:33 -0700
From:   Kai Huang <kai.huang@intel.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     linux-mm@kvack.org, x86@kernel.org, dave.hansen@intel.com,
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
Subject: [PATCH v12 10/22] x86/virt/tdx: Add placeholder to construct TDMRs to cover all TDX memory regions
Date:   Tue, 27 Jun 2023 02:12:40 +1200
Message-Id: <9029b7497505c861c4a0d47b8f6e442df376bd32.1687784645.git.kai.huang@intel.com>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <cover.1687784645.git.kai.huang@intel.com>
References: <cover.1687784645.git.kai.huang@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
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
TDMRs up front.  Always free the buffer of TDMRs since they are only
used during module initialization.

Signed-off-by: Kai Huang <kai.huang@intel.com>
Reviewed-by: Isaku Yamahata <isaku.yamahata@intel.com>
Reviewed-by: Dave Hansen <dave.hansen@linux.intel.com>
Reviewed-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
---

v11 -> v12:
 - Added tags from Dave/Kirill.

v10 -> v11:
 - Changed to keep TDMRs after module initialization to deal with TDX
   erratum in future patches. 

v9 -> v10:
 - Changed the TDMR list from static variable back to local variable as
   now TDX module isn't disabled when tdx_cpu_enable() fails.

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
index 127036f06752..e28615b60f9b 100644
--- a/arch/x86/virt/vmx/tdx/tdx.c
+++ b/arch/x86/virt/vmx/tdx/tdx.c
@@ -24,6 +24,7 @@
 #include <linux/minmax.h>
 #include <linux/sizes.h>
 #include <linux/pfn.h>
+#include <linux/align.h>
 #include <asm/msr-index.h>
 #include <asm/msr.h>
 #include <asm/archrandom.h>
@@ -287,9 +288,84 @@ static int build_tdx_memlist(struct list_head *tmb_list)
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
 	struct tdsysinfo_struct *sysinfo;
+	struct tdmr_info_list tdmr_list;
 	struct cmr_info *cmr_array;
 	int ret;
 
@@ -329,11 +405,19 @@ static int init_tdx_module(void)
 	if (ret)
 		goto out_put_tdxmem;
 
+	/* Allocate enough space for constructing TDMRs */
+	ret = alloc_tdmr_list(&tdmr_list, sysinfo);
+	if (ret)
+		goto out_free_tdxmem;
+
+	/* Cover all TDX-usable memory regions in TDMRs */
+	ret = construct_tdmrs(&tdx_memlist, &tdmr_list, sysinfo);
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
@@ -341,6 +425,15 @@ static int init_tdx_module(void)
 	 *  Return error before all steps are done.
 	 */
 	ret = -EINVAL;
+out_free_tdmrs:
+	/*
+	 * Always free the buffer of TDMRs as they are only used during
+	 * module initialization.
+	 */
+	free_tdmr_list(&tdmr_list);
+out_free_tdxmem:
+	if (ret)
+		free_tdx_memlist(&tdx_memlist);
 out_put_tdxmem:
 	/*
 	 * @tdx_memlist is written here and read at memory hotplug time.
diff --git a/arch/x86/virt/vmx/tdx/tdx.h b/arch/x86/virt/vmx/tdx/tdx.h
index 37ee7c5dce1c..193764afc602 100644
--- a/arch/x86/virt/vmx/tdx/tdx.h
+++ b/arch/x86/virt/vmx/tdx/tdx.h
@@ -82,6 +82,29 @@ struct tdsysinfo_struct {
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
@@ -100,6 +123,15 @@ struct tdx_memblock {
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
2.40.1

