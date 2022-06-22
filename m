Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7D0ED5548B9
	for <lists+kvm@lfdr.de>; Wed, 22 Jun 2022 14:16:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1357590AbiFVLTS (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 22 Jun 2022 07:19:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57804 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1357438AbiFVLTB (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 22 Jun 2022 07:19:01 -0400
Received: from mga01.intel.com (mga01.intel.com [192.55.52.88])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 141BBBCA;
        Wed, 22 Jun 2022 04:17:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1655896672; x=1687432672;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=yRtHLb3R36woCrpA1QVLqu3p65ADPQV4gzJG23hwXEg=;
  b=W+uNHGn7n8po5Pm6bmoy22SHyIfZdjD4mbXRB+/4i/uga88OTr7RS9lU
   OUyNrPAoUWfuNrmZwkdaDhZ1vLdOQ/zWQacjXbLaaC++2sOuw7yOPl/U+
   gOawloiVeRmTimaWfeKvF7QklMmHYi3xkDLc61PtsNVYBC3KGesPecvO6
   hLL+9TTkH2iDxdICKUHCcMmPFDCgt7CaPKPoPPAM+XC8qcS7uZr22DE19
   unrHE9I6qn6SYGzua6SxZawuVyotItNJQ4ZMrCSHSFLztppCFFCZVoWYZ
   n9a/BoDu9sPUXXO1NjES+E1mKaoJmUxco6pZ65dSUJl9aJDE4c1WFZpOt
   A==;
X-IronPort-AV: E=McAfee;i="6400,9594,10385"; a="305841108"
X-IronPort-AV: E=Sophos;i="5.92,212,1650956400"; 
   d="scan'208";a="305841108"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Jun 2022 04:17:36 -0700
X-IronPort-AV: E=Sophos;i="5.92,212,1650956400"; 
   d="scan'208";a="730302277"
Received: from jmatsis-mobl.amr.corp.intel.com (HELO khuang2-desk.gar.corp.intel.com) ([10.209.178.197])
  by fmsmga001-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Jun 2022 04:17:33 -0700
From:   Kai Huang <kai.huang@intel.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     seanjc@google.com, pbonzini@redhat.com, dave.hansen@intel.com,
        len.brown@intel.com, tony.luck@intel.com,
        rafael.j.wysocki@intel.com, reinette.chatre@intel.com,
        dan.j.williams@intel.com, peterz@infradead.org, ak@linux.intel.com,
        kirill.shutemov@linux.intel.com,
        sathyanarayanan.kuppuswamy@linux.intel.com,
        isaku.yamahata@intel.com, kai.huang@intel.com
Subject: [PATCH v5 15/22] x86/virt/tdx: Allocate and set up PAMTs for TDMRs
Date:   Wed, 22 Jun 2022 23:17:04 +1200
Message-Id: <c504a8acd06dc455050c25e2a4cc70aef5eb9358.1655894131.git.kai.huang@intel.com>
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

Signed-off-by: Kai Huang <kai.huang@intel.com>
---

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
 arch/x86/virt/vmx/tdx/tdx.c | 200 ++++++++++++++++++++++++++++++++++++
 2 files changed, 201 insertions(+)

diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index 4988a91d5283..ec496e96d120 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -1973,6 +1973,7 @@ config INTEL_TDX_HOST
 	depends on CPU_SUP_INTEL
 	depends on X86_64
 	depends on KVM_INTEL
+	depends on CONTIG_ALLOC
 	select ARCH_HAS_CC_PLATFORM
 	select ARCH_KEEP_MEMBLOCK
 	help
diff --git a/arch/x86/virt/vmx/tdx/tdx.c b/arch/x86/virt/vmx/tdx/tdx.c
index fd9f449b5395..36260dd7e69f 100644
--- a/arch/x86/virt/vmx/tdx/tdx.c
+++ b/arch/x86/virt/vmx/tdx/tdx.c
@@ -558,6 +558,196 @@ static int create_tdmrs(struct tdmr_info *tdmr_array, int *tdmr_num)
 	return 0;
 }
 
+/* Page sizes supported by TDX */
+enum tdx_page_sz {
+	TDX_PG_4K,
+	TDX_PG_2M,
+	TDX_PG_1G,
+	TDX_PG_MAX,
+};
+
+/*
+ * Calculate PAMT size given a TDMR and a page size.  The returned
+ * PAMT size is always aligned up to 4K page boundary.
+ */
+static unsigned long tdmr_get_pamt_sz(struct tdmr_info *tdmr,
+				      enum tdx_page_sz pgsz)
+{
+	unsigned long pamt_sz;
+	int pamt_entry_nr;
+
+	switch (pgsz) {
+	case TDX_PG_4K:
+		pamt_entry_nr = tdmr->size >> PAGE_SHIFT;
+		break;
+	case TDX_PG_2M:
+		pamt_entry_nr = tdmr->size >> PMD_SHIFT;
+		break;
+	case TDX_PG_1G:
+		pamt_entry_nr = tdmr->size >> PUD_SHIFT;
+		break;
+	default:
+		WARN_ON_ONCE(1);
+		return 0;
+	}
+
+	pamt_sz = pamt_entry_nr * tdx_sysinfo.pamt_entry_size;
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
+	unsigned long start_pfn, end_pfn;
+	int i, nid;
+
+	/* Find the first memory region covered by the TDMR */
+	memblock_for_each_tdx_mem_pfn_range(i, &start_pfn, &end_pfn, &nid) {
+		if (end_pfn > (tdmr_start(tdmr) >> PAGE_SHIFT))
+			return nid;
+	}
+
+	/*
+	 * No memory region found for this TDMR.  It cannot happen since
+	 * when one TDMR is created, it must cover at least one (or
+	 * partial) memory region.
+	 */
+	WARN_ON_ONCE(1);
+	return 0;
+}
+
+static int tdmr_set_up_pamt(struct tdmr_info *tdmr)
+{
+	unsigned long pamt_base[TDX_PG_MAX];
+	unsigned long pamt_size[TDX_PG_MAX];
+	unsigned long tdmr_pamt_base;
+	unsigned long tdmr_pamt_size;
+	enum tdx_page_sz pgsz;
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
+	for (pgsz = TDX_PG_4K; pgsz < TDX_PG_MAX; pgsz++) {
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
+	/* Calculate PAMT base and size for all supported page sizes. */
+	tdmr_pamt_base = page_to_pfn(pamt) << PAGE_SHIFT;
+	for (pgsz = TDX_PG_4K; pgsz < TDX_PG_MAX; pgsz++) {
+		pamt_base[pgsz] = tdmr_pamt_base;
+		tdmr_pamt_base += pamt_size[pgsz];
+	}
+
+	tdmr->pamt_4k_base = pamt_base[TDX_PG_4K];
+	tdmr->pamt_4k_size = pamt_size[TDX_PG_4K];
+	tdmr->pamt_2m_base = pamt_base[TDX_PG_2M];
+	tdmr->pamt_2m_size = pamt_size[TDX_PG_2M];
+	tdmr->pamt_1g_base = pamt_base[TDX_PG_1G];
+	tdmr->pamt_1g_size = pamt_size[TDX_PG_1G];
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
+static unsigned long tdmrs_get_pamt_pages(struct tdmr_info *tdmr_array,
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
  * Construct an array of TDMRs to cover all memory regions in memblock.
  * This makes sure all pages managed by the page allocator are TDX
@@ -572,8 +762,13 @@ static int construct_tdmrs_memeblock(struct tdmr_info *tdmr_array,
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
@@ -644,6 +839,11 @@ static int init_tdx_module(void)
 	 * process are done.
 	 */
 	ret = -EINVAL;
+	if (ret)
+		tdmrs_free_pamt_all(tdmr_array, tdmr_num);
+	else
+		pr_info("%lu pages allocated for PAMT.\n",
+				tdmrs_get_pamt_pages(tdmr_array, tdmr_num));
 out_free_tdmrs:
 	/*
 	 * The array of TDMRs is freed no matter the initialization is
-- 
2.36.1

