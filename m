Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3DFDF60EC34
	for <lists+kvm@lfdr.de>; Thu, 27 Oct 2022 01:19:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234197AbiJZXTL (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 26 Oct 2022 19:19:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58898 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234199AbiJZXSa (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 26 Oct 2022 19:18:30 -0400
Received: from mga09.intel.com (mga09.intel.com [134.134.136.24])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9FC10C0980;
        Wed, 26 Oct 2022 16:17:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1666826278; x=1698362278;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=hSfW4bJ5MptwqyAbvbhRogy6RGSa4Kgayz/Z+Dw3NS8=;
  b=OMbAmDpU0sYPBMALT54YX9w3BAeDjsciUmVJAuULrVG/5lHSPHYdxVCK
   K7oryLFL9uUEzOHlb8YrgniM92hYMu5xT4SFE6jegczJ3DvNkq/ovYcGY
   YTD9yGLJJBVr/Hl/sw358sYv7VOyz8JYkcO5CHditqqUkYL/2pHq31mas
   YpUCaYEt9Ldy6jE2ez4x0KVoK4GcxaqjzrA2AO/zDdRkq5qnEc5ZPzgDG
   sXeO7q+5RDUxNxgbToZ/sClCvuxvESWiNGZVAeOrwclu+A0+/EidvDBPS
   jFR7P75Rw8/rn+x8CiAxI3WQ7NnMz4hY6qVP6u66nFUE+ZrSrHsu7kdit
   w==;
X-IronPort-AV: E=McAfee;i="6500,9779,10512"; a="309175609"
X-IronPort-AV: E=Sophos;i="5.95,215,1661842800"; 
   d="scan'208";a="309175609"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Oct 2022 16:17:58 -0700
X-IronPort-AV: E=McAfee;i="6500,9779,10512"; a="737446442"
X-IronPort-AV: E=Sophos;i="5.95,215,1661842800"; 
   d="scan'208";a="737446442"
Received: from fordon1x-mobl.amr.corp.intel.com (HELO khuang2-desk.gar.corp.intel.com) ([10.212.24.177])
  by fmsmga002-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Oct 2022 16:17:54 -0700
From:   Kai Huang <kai.huang@intel.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     linux-mm@kvack.org, seanjc@google.com, pbonzini@redhat.com,
        dave.hansen@intel.com, dan.j.williams@intel.com,
        rafael.j.wysocki@intel.com, kirill.shutemov@linux.intel.com,
        reinette.chatre@intel.com, len.brown@intel.com,
        tony.luck@intel.com, peterz@infradead.org, ak@linux.intel.com,
        isaku.yamahata@intel.com, chao.gao@intel.com,
        sathyanarayanan.kuppuswamy@linux.intel.com, bagasdotme@gmail.com,
        sagis@google.com, imammedo@redhat.com, kai.huang@intel.com
Subject: [PATCH v6 14/21] x86/virt/tdx: Allocate and set up PAMTs for TDMRs
Date:   Thu, 27 Oct 2022 12:16:13 +1300
Message-Id: <71f0a13791f9bc3cbf92fc9f54508f7c4209a72a.1666824663.git.kai.huang@intel.com>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <cover.1666824663.git.kai.huang@intel.com>
References: <cover.1666824663.git.kai.huang@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.9 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
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
TDX module.

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
mitigation is to launch a TD guest early during system boot to get those
PAMTs allocated at early time, but the only way to fix is to add a boot
option to allocate or reserve PAMTs during kernel boot.

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
is initialized successfully.

Reviewed-by: Isaku Yamahata <isaku.yamahata@intel.com>
Signed-off-by: Kai Huang <kai.huang@intel.com>
---

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
 arch/x86/Kconfig            |   1 +
 arch/x86/virt/vmx/tdx/tdx.c | 193 ++++++++++++++++++++++++++++++++++++
 2 files changed, 194 insertions(+)

diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index f6f5e4f7a760..bb291b2de830 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -1961,6 +1961,7 @@ config INTEL_TDX_HOST
 	depends on X86_64
 	depends on KVM_INTEL
 	depends on X86_X2APIC
+	depends on CONTIG_ALLOC
 	help
 	  Intel Trust Domain Extensions (TDX) protects guest VMs from malicious
 	  host and certain physical attacks.  This option enables necessary TDX
diff --git a/arch/x86/virt/vmx/tdx/tdx.c b/arch/x86/virt/vmx/tdx/tdx.c
index f6dde82d94cc..f7142f45bb0c 100644
--- a/arch/x86/virt/vmx/tdx/tdx.c
+++ b/arch/x86/virt/vmx/tdx/tdx.c
@@ -669,6 +669,189 @@ static int create_tdmrs(struct tdmr_info *tdmr_array, int *tdmr_num)
 	return 0;
 }
 
+/*
+ * Calculate PAMT size given a TDMR and a page size.  The returned
+ * PAMT size is always aligned up to 4K page boundary.
+ */
+static unsigned long tdmr_get_pamt_sz(struct tdmr_info *tdmr,
+				      enum tdx_pg_level pgsz)
+{
+	unsigned long pamt_sz, nr_pamt_entries;
+
+	switch (pgsz) {
+	case TDX_PG_LEVEL_4K:
+		nr_pamt_entries = tdmr->size >> PAGE_SHIFT;
+		break;
+	case TDX_PG_LEVEL_2M:
+		nr_pamt_entries = tdmr->size >> PMD_SHIFT;
+		break;
+	case TDX_PG_LEVEL_1G:
+		nr_pamt_entries = tdmr->size >> PUD_SHIFT;
+		break;
+	default:
+		WARN_ON_ONCE(1);
+		return 0;
+	}
+
+	pamt_sz = nr_pamt_entries * tdx_sysinfo.pamt_entry_size;
+	/* TDX requires PAMT size must be 4K aligned */
+	pamt_sz = ALIGN(pamt_sz, PAGE_SIZE);
+
+	return pamt_sz;
+}
+
+/*
+ * Pick a NUMA node on which to allocate this TDMR's metadata.
+ *
+ * This is imprecise since TDMRs are 1G aligned and NUMA nodes might
+ * not be.  If the TDMR covers more than one node, just use the _first_
+ * one.  This can lead to small areas of off-node metadata for some
+ * memory.
+ */
+static int tdmr_get_nid(struct tdmr_info *tdmr)
+{
+	struct tdx_memblock *tmb;
+
+	/* Find the first memory region covered by the TDMR */
+	list_for_each_entry(tmb, &tdx_memlist, list) {
+		if (tmb->end_pfn > (tdmr_start(tdmr) >> PAGE_SHIFT))
+			return tmb->nid;
+	}
+
+	/*
+	 * Fall back to allocating the TDMR's metadata from node 0 when
+	 * no TDX memory block can be found.  This should never happen
+	 * since TDMRs originate from TDX memory blocks.
+	 */
+	WARN_ON_ONCE(1);
+	return 0;
+}
+
+static int tdmr_set_up_pamt(struct tdmr_info *tdmr)
+{
+	unsigned long pamt_base[TDX_PG_LEVEL_NUM];
+	unsigned long pamt_size[TDX_PG_LEVEL_NUM];
+	unsigned long tdmr_pamt_base;
+	unsigned long tdmr_pamt_size;
+	enum tdx_pg_level pgsz;
+	struct page *pamt;
+	int nid;
+
+	nid = tdmr_get_nid(tdmr);
+
+	/*
+	 * Calculate the PAMT size for each TDX supported page size
+	 * and the total PAMT size.
+	 */
+	tdmr_pamt_size = 0;
+	for (pgsz = TDX_PG_LEVEL_4K; pgsz < TDX_PG_LEVEL_NUM; pgsz++) {
+		pamt_size[pgsz] = tdmr_get_pamt_sz(tdmr, pgsz);
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
+	for (pgsz = TDX_PG_LEVEL_4K; pgsz < TDX_PG_LEVEL_NUM; pgsz++) {
+		pamt_base[pgsz] = tdmr_pamt_base;
+		tdmr_pamt_base += pamt_size[pgsz];
+	}
+
+	tdmr->pamt_4k_base = pamt_base[TDX_PG_LEVEL_4K];
+	tdmr->pamt_4k_size = pamt_size[TDX_PG_LEVEL_4K];
+	tdmr->pamt_2m_base = pamt_base[TDX_PG_LEVEL_2M];
+	tdmr->pamt_2m_size = pamt_size[TDX_PG_LEVEL_2M];
+	tdmr->pamt_1g_base = pamt_base[TDX_PG_LEVEL_1G];
+	tdmr->pamt_1g_size = pamt_size[TDX_PG_LEVEL_1G];
+
+	return 0;
+}
+
+static void tdmr_get_pamt(struct tdmr_info *tdmr, unsigned long *pamt_pfn,
+			  unsigned long *pamt_npages)
+{
+	unsigned long pamt_base, pamt_sz;
+
+	/*
+	 * The PAMT was allocated in one contiguous unit.  The 4K PAMT
+	 * should always point to the beginning of that allocation.
+	 */
+	pamt_base = tdmr->pamt_4k_base;
+	pamt_sz = tdmr->pamt_4k_size + tdmr->pamt_2m_size + tdmr->pamt_1g_size;
+
+	*pamt_pfn = pamt_base >> PAGE_SHIFT;
+	*pamt_npages = pamt_sz >> PAGE_SHIFT;
+}
+
+static void tdmr_free_pamt(struct tdmr_info *tdmr)
+{
+	unsigned long pamt_pfn, pamt_npages;
+
+	tdmr_get_pamt(tdmr, &pamt_pfn, &pamt_npages);
+
+	/* Do nothing if PAMT hasn't been allocated for this TDMR */
+	if (!pamt_npages)
+		return;
+
+	if (WARN_ON_ONCE(!pamt_pfn))
+		return;
+
+	free_contig_range(pamt_pfn, pamt_npages);
+}
+
+static void tdmrs_free_pamt_all(struct tdmr_info *tdmr_array, int tdmr_num)
+{
+	int i;
+
+	for (i = 0; i < tdmr_num; i++)
+		tdmr_free_pamt(tdmr_array_entry(tdmr_array, i));
+}
+
+/* Allocate and set up PAMTs for all TDMRs */
+static int tdmrs_set_up_pamt_all(struct tdmr_info *tdmr_array, int tdmr_num)
+{
+	int i, ret = 0;
+
+	for (i = 0; i < tdmr_num; i++) {
+		ret = tdmr_set_up_pamt(tdmr_array_entry(tdmr_array, i));
+		if (ret)
+			goto err;
+	}
+
+	return 0;
+err:
+	tdmrs_free_pamt_all(tdmr_array, tdmr_num);
+	return ret;
+}
+
+static unsigned long tdmrs_count_pamt_pages(struct tdmr_info *tdmr_array,
+					  int tdmr_num)
+{
+	unsigned long pamt_npages = 0;
+	int i;
+
+	for (i = 0; i < tdmr_num; i++) {
+		unsigned long pfn, npages;
+
+		tdmr_get_pamt(tdmr_array_entry(tdmr_array, i), &pfn, &npages);
+		pamt_npages += npages;
+	}
+
+	return pamt_npages;
+}
+
 /*
  * Construct an array of TDMRs to cover all TDX memory ranges.
  * The actual number of TDMRs is kept to @tdmr_num.
@@ -681,8 +864,13 @@ static int construct_tdmrs(struct tdmr_info *tdmr_array, int *tdmr_num)
 	if (ret)
 		goto err;
 
+	ret = tdmrs_set_up_pamt_all(tdmr_array, *tdmr_num);
+	if (ret)
+		goto err;
+
 	/* Return -EINVAL until constructing TDMRs is done */
 	ret = -EINVAL;
+	tdmrs_free_pamt_all(tdmr_array, *tdmr_num);
 err:
 	return ret;
 }
@@ -744,6 +932,11 @@ static int init_tdx_module(void)
 	 * process are done.
 	 */
 	ret = -EINVAL;
+	if (ret)
+		tdmrs_free_pamt_all(tdmr_array, tdmr_num);
+	else
+		pr_info("%lu pages allocated for PAMT.\n",
+				tdmrs_count_pamt_pages(tdmr_array, tdmr_num));
 out_free_tdmrs:
 	/*
 	 * The array of TDMRs is freed no matter the initialization is
-- 
2.37.3

