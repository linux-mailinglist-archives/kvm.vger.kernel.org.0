Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E8694647E18
	for <lists+kvm@lfdr.de>; Fri,  9 Dec 2022 07:56:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229912AbiLIG4K (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 9 Dec 2022 01:56:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40866 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229512AbiLIGz1 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 9 Dec 2022 01:55:27 -0500
Received: from mga09.intel.com (mga09.intel.com [134.134.136.24])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EAEBC26ADE;
        Thu,  8 Dec 2022 22:54:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1670568843; x=1702104843;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=HPAlT0aW+bbZfotxgLBpex47Tjhj/8q36otLhqMPWFg=;
  b=FDark/jS4Gxqf+OxyUdOuwmKz/3ldxX8fmFSZ92PMIIOT84THvDnYJNu
   vfQvJF9vtTQK8h729X04YNmrTXFFtmRWoHxbeLd8LkRFnHpo8YRdAdCHc
   diTdpk36A+iUNVklnLCo13ui1MyW9Bhu3ioiY/IJJ6MKAI7dcn7j8THuh
   jIVEi7P6a42GFkctaiE9LdOS2etGWlCvIX8tbVW40eQMYgsJHoTKr4XWh
   cxZondvgjqBV9dfBF12OF1tkm78rISRZXtWuooHygrkfAuVb1B+fyVbD5
   8d8Nv/rpu12O9Pq6a1sLiL87n6KyGeku1xurSlQWhzr7hTlwVx3anWYX4
   Q==;
X-IronPort-AV: E=McAfee;i="6500,9779,10555"; a="318551416"
X-IronPort-AV: E=Sophos;i="5.96,230,1665471600"; 
   d="scan'208";a="318551416"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Dec 2022 22:53:52 -0800
X-IronPort-AV: E=McAfee;i="6500,9779,10555"; a="679837012"
X-IronPort-AV: E=Sophos;i="5.96,230,1665471600"; 
   d="scan'208";a="679837012"
Received: from omiramon-mobl1.amr.corp.intel.com (HELO khuang2-desk.gar.corp.intel.com) ([10.212.28.82])
  by orsmga001-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Dec 2022 22:53:46 -0800
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
Subject: [PATCH v8 10/16] x86/virt/tdx: Allocate and set up PAMTs for TDMRs
Date:   Fri,  9 Dec 2022 19:52:31 +1300
Message-Id: <76a17c574da18c10ad7a4f96e010697aaa5f7c04.1670566861.git.kai.huang@intel.com>
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

Reviewed-by: Isaku Yamahata <isaku.yamahata@intel.com>
Signed-off-by: Kai Huang <kai.huang@intel.com>
---

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
 arch/x86/Kconfig            |   1 +
 arch/x86/virt/vmx/tdx/tdx.c | 215 +++++++++++++++++++++++++++++++++++-
 2 files changed, 211 insertions(+), 5 deletions(-)

diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index b36129183035..b86a333b860f 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -1960,6 +1960,7 @@ config INTEL_TDX_HOST
 	depends on KVM_INTEL
 	depends on X86_X2APIC
 	select ARCH_KEEP_MEMBLOCK
+	depends on CONTIG_ALLOC
 	help
 	  Intel Trust Domain Extensions (TDX) protects guest VMs from malicious
 	  host and certain physical attacks.  This option enables necessary TDX
diff --git a/arch/x86/virt/vmx/tdx/tdx.c b/arch/x86/virt/vmx/tdx/tdx.c
index 5b1de0200c6b..cf970a783f1f 100644
--- a/arch/x86/virt/vmx/tdx/tdx.c
+++ b/arch/x86/virt/vmx/tdx/tdx.c
@@ -37,6 +37,7 @@ struct tdx_memblock {
 	struct list_head list;
 	unsigned long start_pfn;
 	unsigned long end_pfn;
+	int nid;
 };
 
 static u32 tdx_keyid_start __ro_after_init;
@@ -283,7 +284,7 @@ static int tdx_get_sysinfo(struct tdsysinfo_struct *sysinfo,
  * overlap.
  */
 static int add_tdx_memblock(struct list_head *tmb_list, unsigned long start_pfn,
-			    unsigned long end_pfn)
+			    unsigned long end_pfn, int nid)
 {
 	struct tdx_memblock *tmb;
 
@@ -294,6 +295,7 @@ static int add_tdx_memblock(struct list_head *tmb_list, unsigned long start_pfn,
 	INIT_LIST_HEAD(&tmb->list);
 	tmb->start_pfn = start_pfn;
 	tmb->end_pfn = end_pfn;
+	tmb->nid = nid;
 
 	list_add_tail(&tmb->list, tmb_list);
 	return 0;
@@ -319,9 +321,9 @@ static void free_tdx_memlist(struct list_head *tmb_list)
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
@@ -337,7 +339,7 @@ static int build_tdx_memlist(struct list_head *tmb_list)
 		 * memblock has already guaranteed they are in address
 		 * ascending order and don't overlap.
 		 */
-		ret = add_tdx_memblock(tmb_list, start_pfn, end_pfn);
+		ret = add_tdx_memblock(tmb_list, start_pfn, end_pfn, nid);
 		if (ret)
 			goto err;
 	}
@@ -491,6 +493,200 @@ static int fill_out_tdmrs(struct list_head *tmb_list,
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
+	unsigned long pamt_base[TDX_PS_1G + 1];
+	unsigned long pamt_size[TDX_PS_1G + 1];
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
+	for (pgsz = TDX_PS_4K; pgsz <= TDX_PS_1G ; pgsz++) {
+		pamt_size[pgsz] = tdmr_get_pamt_sz(tdmr, pgsz,
+				pamt_entry_size);
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
+	for (pgsz = TDX_PS_4K; pgsz <= TDX_PS_1G; pgsz++) {
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
+	*pamt_pfn = PHYS_PFN(pamt_base);
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
+static void tdmrs_free_pamt_all(struct tdmr_info_list *tdmr_list)
+{
+	int i;
+
+	for (i = 0; i < tdmr_list->nr_tdmrs; i++)
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
+	for (i = 0; i < tdmr_list->nr_tdmrs; i++) {
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
+static unsigned long tdmrs_count_pamt_pages(struct tdmr_info_list *tdmr_list)
+{
+	unsigned long pamt_npages = 0;
+	int i;
+
+	for (i = 0; i < tdmr_list->nr_tdmrs; i++) {
+		unsigned long pfn, npages;
+
+		tdmr_get_pamt(tdmr_entry(tdmr_list, i), &pfn, &npages);
+		pamt_npages += npages;
+	}
+
+	return pamt_npages;
+}
+
 /*
  * Construct a list of TDMRs on the preallocated space in @tdmr_list
  * to cover all TDX memory regions in @tmb_list based on the TDX module
@@ -506,15 +702,19 @@ static int construct_tdmrs(struct list_head *tmb_list,
 	if (ret)
 		goto err;
 
+	ret = tdmrs_set_up_pamt_all(tdmr_list, tmb_list,
+			sysinfo->pamt_entry_size);
+	if (ret)
+		goto err;
 	/*
 	 * TODO:
 	 *
-	 *  - Allocate and set up PAMTs for each TDMR.
 	 *  - Designate reserved areas for each TDMR.
 	 *
 	 * Return -EINVAL until constructing TDMRs is done
 	 */
 	ret = -EINVAL;
+	tdmrs_free_pamt_all(tdmr_list);
 err:
 	return ret;
 }
@@ -574,6 +774,11 @@ static int init_tdx_module(void)
 	 *  Return error before all steps are done.
 	 */
 	ret = -EINVAL;
+	if (ret)
+		tdmrs_free_pamt_all(&tdmr_list);
+	else
+		pr_info("%lu pages allocated for PAMT.\n",
+				tdmrs_count_pamt_pages(&tdmr_list));
 out_free_tdmrs:
 	/*
 	 * Free the space for the TDMRs no matter the initialization is
-- 
2.38.1

