Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4D99F7886DE
	for <lists+kvm@lfdr.de>; Fri, 25 Aug 2023 14:16:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244731AbjHYMQc (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 25 Aug 2023 08:16:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48492 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244617AbjHYMQG (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 25 Aug 2023 08:16:06 -0400
Received: from mgamail.intel.com (mgamail.intel.com [134.134.136.31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 32FD31B2;
        Fri, 25 Aug 2023 05:16:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1692965764; x=1724501764;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=Tla0wUDKk90XC1uDwe9Va8zxEFxCcs7DriJgTjBaO3Y=;
  b=foHj1j0z5WvMU1qIJcUl5RPepI0xbRNPgNirhUox7U9KsMQRhpuDC7Sn
   ADRyxjPh3A7kptiDfkccK8tJLzKdBMishdyAe1WKFXitfHNNNyyUvBT2i
   AdP+RaE5fczJz4dUu0nI8uJxuoOosVZcmam8nkJVGVr20eloBDChgFopv
   SN6HuFmEkMLRxXHwsjAG2nREt+gqeBwURRDgEGpDCoI+D0FYTy4W/JSQA
   YgEdyBBXNKY+JA4x+AAeKHeYSMmn4r8QG1RgnwpxJqVCOlrDfSeyfzBYM
   bLD8fx+hZVwQvzkQRqb+YZ4Izt52CeAS6n+B5ugF3G0AZyXKw1y8ISXHq
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10812"; a="438639351"
X-IronPort-AV: E=Sophos;i="6.02,195,1688454000"; 
   d="scan'208";a="438639351"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Aug 2023 05:16:03 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.01,202,1684825200"; 
   d="scan'208";a="881158405"
Received: from vnaikawa-mobl1.amr.corp.intel.com (HELO khuang2-desk.gar.corp.intel.com) ([10.209.185.177])
  by fmsmga001-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Aug 2023 05:16:03 -0700
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
Subject: [PATCH v13 12/22] x86/virt/tdx: Allocate and set up PAMTs for TDMRs
Date:   Sat, 26 Aug 2023 00:14:31 +1200
Message-ID: <16b4aacc67e3080c4b9e1a31d9910ed03c0742e8.1692962263.git.kai.huang@intel.com>
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

The TDX module uses additional metadata to record things like which
guest "owns" a given page of memory.  This metadata, referred as
Physical Address Metadata Table (PAMT), essentially serves as the
'struct page' for the TDX module.  PAMTs are not reserved by hardware
up front.  They must be allocated by the kernel and then given to the
TDX module during module initialization.

TDX supports 3 page sizes: 4K, 2M, and 1G.  Each "TD Memory Region"
(TDMR) has 3 PAMTs to track the 3 supported page sizes.  Each PAMT must
be a physically contiguous area from a Convertible Memory Region (CMR).
However, the PAMTs which track pages in one TDMR do not need to reside
within that TDMR but can be anywhere in CMRs.  If one PAMT overlaps with
any TDMR, the overlapping part must be reported as a reserved area in
that particular TDMR.

Use alloc_contig_pages() since PAMT must be a physically contiguous area
and it may be potentially large (~1/256th of the size of the given TDMR).
The downside is alloc_contig_pages() may fail at runtime.  One (bad)
mitigation is to launch a TDX guest early during system boot to get
those PAMTs allocated at early time, but the only way to fix is to add a
boot option to allocate or reserve PAMTs during kernel boot.

It is imperfect but will be improved on later.

TDX only supports a limited number of reserved areas per TDMR to cover
both PAMTs and memory holes within the given TDMR.  If many PAMTs are
allocated within a single TDMR, the reserved areas may not be sufficient
to cover all of them.

Adopt the following policies when allocating PAMTs for a given TDMR:

  - Allocate three PAMTs of the TDMR in one contiguous chunk to minimize
    the total number of reserved areas consumed for PAMTs.
  - Try to first allocate PAMT from the local node of the TDMR for better
    NUMA locality.

Also dump out how many pages are allocated for PAMTs when the TDX module
is initialized successfully.  This helps answer the eternal "where did
all my memory go?" questions.

Signed-off-by: Kai Huang <kai.huang@intel.com>
Reviewed-by: Isaku Yamahata <isaku.yamahata@intel.com>
Reviewed-by: Dave Hansen <dave.hansen@linux.intel.com>
Reviewed-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Reviewed-by: Yuan Yao <yuan.yao@intel.com>
---

v12 -> v13:
 - Added Kirill and Yuan's tag.
 - Removed unintended space. (Yuan)

v11 -> v12:
 - Moved TDX_PS_NUM from tdx.c to <asm/tdx.h> (Kirill)
 - "<= TDX_PS_1G" -> "< TDX_PS_NUM" (Kirill)
 - Changed tdmr_get_pamt() to return base and size instead of base_pfn
   and npages and related code directly (Dave).
 - Simplified PAMT kb counting. (Dave)
 - tdmrs_count_pamt_pages() -> tdmr_count_pamt_kb() (Kirill/Dave)

v10 -> v11:
 - No update

v9 -> v10:
 - Removed code change in disable_tdx_module() as it doesn't exist
   anymore.

v8 -> v9:
 - Added TDX_PS_NR macro instead of open-coding (Dave).
 - Better alignment of 'pamt_entry_size' in tdmr_set_up_pamt() (Dave).
 - Changed to print out PAMTs in "KBs" instead of "pages" (Dave).
 - Added Dave's Reviewed-by.

v7 -> v8: (Dave)
 - Changelog:
  - Added a sentence to state PAMT allocation will be improved.
  - Others suggested by Dave.
 - Moved 'nid' of 'struct tdx_memblock' to this patch.
 - Improved comments around tdmr_get_nid().
 - WARN_ON_ONCE() -> pr_warn() in tdmr_get_nid().
 - Other changes due to 'struct tdmr_info_list'.

v6 -> v7:
 - Changes due to using macros instead of 'enum' for TDX supported page
   sizes.

v5 -> v6:
 - Rebase due to using 'tdx_memblock' instead of memblock.
 - 'int pamt_entry_nr' -> 'unsigned long nr_pamt_entries' (Dave/Sagis).
 - Improved comment around tdmr_get_nid() (Dave).
 - Improved comment in tdmr_set_up_pamt() around breaking the PAMT
   into PAMTs for 4K/2M/1G (Dave).
 - tdmrs_get_pamt_pages() -> tdmrs_count_pamt_pages() (Dave).   

- v3 -> v5 (no feedback on v4):
 - Used memblock to get the NUMA node for given TDMR.
 - Removed tdmr_get_pamt_sz() helper but use open-code instead.
 - Changed to use 'switch .. case..' for each TDX supported page size in
   tdmr_get_pamt_sz() (the original __tdmr_get_pamt_sz()).
 - Added printing out memory used for PAMT allocation when TDX module is
   initialized successfully.
 - Explained downside of alloc_contig_pages() in changelog.
 - Addressed other minor comments.



---
 arch/x86/Kconfig                  |   1 +
 arch/x86/include/asm/shared/tdx.h |   1 +
 arch/x86/virt/vmx/tdx/tdx.c       | 215 +++++++++++++++++++++++++++++-
 arch/x86/virt/vmx/tdx/tdx.h       |   1 +
 4 files changed, 213 insertions(+), 5 deletions(-)

diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index 92666bdfacda..62d7e3f0ff43 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -1956,6 +1956,7 @@ config INTEL_TDX_HOST
 	depends on KVM_INTEL
 	depends on X86_X2APIC
 	select ARCH_KEEP_MEMBLOCK
+	depends on CONTIG_ALLOC
 	help
 	  Intel Trust Domain Extensions (TDX) protects guest VMs from malicious
 	  host and certain physical attacks.  This option enables necessary TDX
diff --git a/arch/x86/include/asm/shared/tdx.h b/arch/x86/include/asm/shared/tdx.h
index 257a41d0a36d..464174c63d80 100644
--- a/arch/x86/include/asm/shared/tdx.h
+++ b/arch/x86/include/asm/shared/tdx.h
@@ -56,6 +56,7 @@
 #define TDX_PS_4K	0
 #define TDX_PS_2M	1
 #define TDX_PS_1G	2
+#define TDX_PS_NR	(TDX_PS_1G + 1)
 
 #ifndef __ASSEMBLY__
 
diff --git a/arch/x86/virt/vmx/tdx/tdx.c b/arch/x86/virt/vmx/tdx/tdx.c
index 8188f834674e..0ff83883ae68 100644
--- a/arch/x86/virt/vmx/tdx/tdx.c
+++ b/arch/x86/virt/vmx/tdx/tdx.c
@@ -257,7 +257,7 @@ static int get_tdx_sysinfo(struct tdsysinfo_struct *tdsysinfo,
  * overlap.
  */
 static int add_tdx_memblock(struct list_head *tmb_list, unsigned long start_pfn,
-			    unsigned long end_pfn)
+			    unsigned long end_pfn, int nid)
 {
 	struct tdx_memblock *tmb;
 
@@ -268,6 +268,7 @@ static int add_tdx_memblock(struct list_head *tmb_list, unsigned long start_pfn,
 	INIT_LIST_HEAD(&tmb->list);
 	tmb->start_pfn = start_pfn;
 	tmb->end_pfn = end_pfn;
+	tmb->nid = nid;
 
 	/* @tmb_list is protected by mem_hotplug_lock */
 	list_add_tail(&tmb->list, tmb_list);
@@ -295,9 +296,9 @@ static void free_tdx_memlist(struct list_head *tmb_list)
 static int build_tdx_memlist(struct list_head *tmb_list)
 {
 	unsigned long start_pfn, end_pfn;
-	int i, ret;
+	int i, nid, ret;
 
-	for_each_mem_pfn_range(i, MAX_NUMNODES, &start_pfn, &end_pfn, NULL) {
+	for_each_mem_pfn_range(i, MAX_NUMNODES, &start_pfn, &end_pfn, &nid) {
 		/*
 		 * The first 1MB is not reported as TDX convertible memory.
 		 * Although the first 1MB is always reserved and won't end up
@@ -313,7 +314,7 @@ static int build_tdx_memlist(struct list_head *tmb_list)
 		 * memblock has already guaranteed they are in address
 		 * ascending order and don't overlap.
 		 */
-		ret = add_tdx_memblock(tmb_list, start_pfn, end_pfn);
+		ret = add_tdx_memblock(tmb_list, start_pfn, end_pfn, nid);
 		if (ret)
 			goto err;
 	}
@@ -473,6 +474,202 @@ static int fill_out_tdmrs(struct list_head *tmb_list,
 	return 0;
 }
 
+/*
+ * Calculate PAMT size given a TDMR and a page size.  The returned
+ * PAMT size is always aligned up to 4K page boundary.
+ */
+static unsigned long tdmr_get_pamt_sz(struct tdmr_info *tdmr, int pgsz,
+				      u16 pamt_entry_size)
+{
+	unsigned long pamt_sz, nr_pamt_entries;
+
+	switch (pgsz) {
+	case TDX_PS_4K:
+		nr_pamt_entries = tdmr->size >> PAGE_SHIFT;
+		break;
+	case TDX_PS_2M:
+		nr_pamt_entries = tdmr->size >> PMD_SHIFT;
+		break;
+	case TDX_PS_1G:
+		nr_pamt_entries = tdmr->size >> PUD_SHIFT;
+		break;
+	default:
+		WARN_ON_ONCE(1);
+		return 0;
+	}
+
+	pamt_sz = nr_pamt_entries * pamt_entry_size;
+	/* TDX requires PAMT size must be 4K aligned */
+	pamt_sz = ALIGN(pamt_sz, PAGE_SIZE);
+
+	return pamt_sz;
+}
+
+/*
+ * Locate a NUMA node which should hold the allocation of the @tdmr
+ * PAMT.  This node will have some memory covered by the TDMR.  The
+ * relative amount of memory covered is not considered.
+ */
+static int tdmr_get_nid(struct tdmr_info *tdmr, struct list_head *tmb_list)
+{
+	struct tdx_memblock *tmb;
+
+	/*
+	 * A TDMR must cover at least part of one TMB.  That TMB will end
+	 * after the TDMR begins.  But, that TMB may have started before
+	 * the TDMR.  Find the next 'tmb' that _ends_ after this TDMR
+	 * begins.  Ignore 'tmb' start addresses.  They are irrelevant.
+	 */
+	list_for_each_entry(tmb, tmb_list, list) {
+		if (tmb->end_pfn > PHYS_PFN(tdmr->base))
+			return tmb->nid;
+	}
+
+	/*
+	 * Fall back to allocating the TDMR's metadata from node 0 when
+	 * no TDX memory block can be found.  This should never happen
+	 * since TDMRs originate from TDX memory blocks.
+	 */
+	pr_warn("TDMR [0x%llx, 0x%llx): unable to find local NUMA node for PAMT allocation, fallback to use node 0.\n",
+			tdmr->base, tdmr_end(tdmr));
+	return 0;
+}
+
+/*
+ * Allocate PAMTs from the local NUMA node of some memory in @tmb_list
+ * within @tdmr, and set up PAMTs for @tdmr.
+ */
+static int tdmr_set_up_pamt(struct tdmr_info *tdmr,
+			    struct list_head *tmb_list,
+			    u16 pamt_entry_size)
+{
+	unsigned long pamt_base[TDX_PS_NR];
+	unsigned long pamt_size[TDX_PS_NR];
+	unsigned long tdmr_pamt_base;
+	unsigned long tdmr_pamt_size;
+	struct page *pamt;
+	int pgsz, nid;
+
+	nid = tdmr_get_nid(tdmr, tmb_list);
+
+	/*
+	 * Calculate the PAMT size for each TDX supported page size
+	 * and the total PAMT size.
+	 */
+	tdmr_pamt_size = 0;
+	for (pgsz = TDX_PS_4K; pgsz < TDX_PS_NR; pgsz++) {
+		pamt_size[pgsz] = tdmr_get_pamt_sz(tdmr, pgsz,
+					pamt_entry_size);
+		tdmr_pamt_size += pamt_size[pgsz];
+	}
+
+	/*
+	 * Allocate one chunk of physically contiguous memory for all
+	 * PAMTs.  This helps minimize the PAMT's use of reserved areas
+	 * in overlapped TDMRs.
+	 */
+	pamt = alloc_contig_pages(tdmr_pamt_size >> PAGE_SHIFT, GFP_KERNEL,
+			nid, &node_online_map);
+	if (!pamt)
+		return -ENOMEM;
+
+	/*
+	 * Break the contiguous allocation back up into the
+	 * individual PAMTs for each page size.
+	 */
+	tdmr_pamt_base = page_to_pfn(pamt) << PAGE_SHIFT;
+	for (pgsz = TDX_PS_4K; pgsz < TDX_PS_NR; pgsz++) {
+		pamt_base[pgsz] = tdmr_pamt_base;
+		tdmr_pamt_base += pamt_size[pgsz];
+	}
+
+	tdmr->pamt_4k_base = pamt_base[TDX_PS_4K];
+	tdmr->pamt_4k_size = pamt_size[TDX_PS_4K];
+	tdmr->pamt_2m_base = pamt_base[TDX_PS_2M];
+	tdmr->pamt_2m_size = pamt_size[TDX_PS_2M];
+	tdmr->pamt_1g_base = pamt_base[TDX_PS_1G];
+	tdmr->pamt_1g_size = pamt_size[TDX_PS_1G];
+
+	return 0;
+}
+
+static void tdmr_get_pamt(struct tdmr_info *tdmr, unsigned long *pamt_base,
+			  unsigned long *pamt_size)
+{
+	unsigned long pamt_bs, pamt_sz;
+
+	/*
+	 * The PAMT was allocated in one contiguous unit.  The 4K PAMT
+	 * should always point to the beginning of that allocation.
+	 */
+	pamt_bs = tdmr->pamt_4k_base;
+	pamt_sz = tdmr->pamt_4k_size + tdmr->pamt_2m_size + tdmr->pamt_1g_size;
+
+	WARN_ON_ONCE((pamt_bs & ~PAGE_MASK) || (pamt_sz & ~PAGE_MASK));
+
+	*pamt_base = pamt_bs;
+	*pamt_size = pamt_sz;
+}
+
+static void tdmr_free_pamt(struct tdmr_info *tdmr)
+{
+	unsigned long pamt_base, pamt_size;
+
+	tdmr_get_pamt(tdmr, &pamt_base, &pamt_size);
+
+	/* Do nothing if PAMT hasn't been allocated for this TDMR */
+	if (!pamt_size)
+		return;
+
+	if (WARN_ON_ONCE(!pamt_base))
+		return;
+
+	free_contig_range(pamt_base >> PAGE_SHIFT, pamt_size >> PAGE_SHIFT);
+}
+
+static void tdmrs_free_pamt_all(struct tdmr_info_list *tdmr_list)
+{
+	int i;
+
+	for (i = 0; i < tdmr_list->nr_consumed_tdmrs; i++)
+		tdmr_free_pamt(tdmr_entry(tdmr_list, i));
+}
+
+/* Allocate and set up PAMTs for all TDMRs */
+static int tdmrs_set_up_pamt_all(struct tdmr_info_list *tdmr_list,
+				 struct list_head *tmb_list,
+				 u16 pamt_entry_size)
+{
+	int i, ret = 0;
+
+	for (i = 0; i < tdmr_list->nr_consumed_tdmrs; i++) {
+		ret = tdmr_set_up_pamt(tdmr_entry(tdmr_list, i), tmb_list,
+				pamt_entry_size);
+		if (ret)
+			goto err;
+	}
+
+	return 0;
+err:
+	tdmrs_free_pamt_all(tdmr_list);
+	return ret;
+}
+
+static unsigned long tdmrs_count_pamt_kb(struct tdmr_info_list *tdmr_list)
+{
+	unsigned long pamt_size = 0;
+	int i;
+
+	for (i = 0; i < tdmr_list->nr_consumed_tdmrs; i++) {
+		unsigned long base, size;
+
+		tdmr_get_pamt(tdmr_entry(tdmr_list, i), &base, &size);
+		pamt_size += size;
+	}
+
+	return pamt_size / 1024;
+}
+
 /*
  * Construct a list of TDMRs on the preallocated space in @tdmr_list
  * to cover all TDX memory regions in @tmb_list based on the TDX module
@@ -488,10 +685,13 @@ static int construct_tdmrs(struct list_head *tmb_list,
 	if (ret)
 		return ret;
 
+	ret = tdmrs_set_up_pamt_all(tdmr_list, tmb_list,
+			sysinfo->pamt_entry_size);
+	if (ret)
+		return ret;
 	/*
 	 * TODO:
 	 *
-	 *  - Allocate and set up PAMTs for each TDMR.
 	 *  - Designate reserved areas for each TDMR.
 	 *
 	 * Return -EINVAL until constructing TDMRs is done
@@ -564,6 +764,11 @@ static int init_tdx_module(void)
 	 *  Return error before all steps are done.
 	 */
 	ret = -EINVAL;
+	if (ret)
+		tdmrs_free_pamt_all(&tdmr_list);
+	else
+		pr_info("%lu KBs allocated for PAMT.\n",
+				tdmrs_count_pamt_kb(&tdmr_list));
 out_free_tdmrs:
 	/*
 	 * Always free the buffer of TDMRs as they are only used during
diff --git a/arch/x86/virt/vmx/tdx/tdx.h b/arch/x86/virt/vmx/tdx/tdx.h
index 15afd6a56fdc..6987af46d096 100644
--- a/arch/x86/virt/vmx/tdx/tdx.h
+++ b/arch/x86/virt/vmx/tdx/tdx.h
@@ -118,6 +118,7 @@ struct tdx_memblock {
 	struct list_head list;
 	unsigned long start_pfn;
 	unsigned long end_pfn;
+	int nid;
 };
 
 /* Warn if kernel has less than TDMR_NR_WARN TDMRs after allocation */
-- 
2.41.0

