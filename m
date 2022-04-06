Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C7A424F6459
	for <lists+kvm@lfdr.de>; Wed,  6 Apr 2022 18:08:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236896AbiDFQGl (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 6 Apr 2022 12:06:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56898 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236994AbiDFQGI (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 6 Apr 2022 12:06:08 -0400
Received: from mga18.intel.com (mga18.intel.com [134.134.136.126])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5F459451D76;
        Tue,  5 Apr 2022 21:50:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1649220636; x=1680756636;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=U7JIb6jRGaOT3Ma7lXiC1ZND2BbsDZGoURUyJcHBlHw=;
  b=eEw4pvWPbXrO+SkDyCvIjELa7ITe0wLJemM30qmeL9ml4LkDBqW0u6/7
   i/auPoBewbRv7T+LgtTkGv0NFWF9ORnSInFfX4f3RyAhy0bOoEJYFZjQk
   9B4f7yT7qP/k4xRzH4Fv4gygDKAJOrFv4AtXK1Pagsa2td6mbUeYr8Zdy
   ZTD2fH3P8YisJa/XcY1vJ8qlaaFosgS0cVRxKqbRqIyELru7wxR24MaFa
   YN/sQ6dHuX5YOJUhFyCq+8mTmkKI1yf4Ge6o2+/86EvopZ+4Hf/Q/6/Vb
   18mjTrAVBg4KDFHYaxrFo1+YreLuy0/4DrfkXb46UlVn9ztx7dJ/edzH3
   w==;
X-IronPort-AV: E=McAfee;i="6200,9189,10308"; a="243089867"
X-IronPort-AV: E=Sophos;i="5.90,239,1643702400"; 
   d="scan'208";a="243089867"
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Apr 2022 21:50:36 -0700
X-IronPort-AV: E=Sophos;i="5.90,239,1643702400"; 
   d="scan'208";a="524302385"
Received: from dchang1-mobl3.amr.corp.intel.com (HELO khuang2-desk.gar.corp.intel.com) ([10.254.29.17])
  by orsmga006-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Apr 2022 21:50:32 -0700
From:   Kai Huang <kai.huang@intel.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     seanjc@google.com, pbonzini@redhat.com, dave.hansen@intel.com,
        len.brown@intel.com, tony.luck@intel.com,
        rafael.j.wysocki@intel.com, reinette.chatre@intel.com,
        dan.j.williams@intel.com, peterz@infradead.org, ak@linux.intel.com,
        kirill.shutemov@linux.intel.com,
        sathyanarayanan.kuppuswamy@linux.intel.com,
        isaku.yamahata@intel.com, kai.huang@intel.com
Subject: [PATCH v3 13/21] x86/virt/tdx: Allocate and set up PAMTs for TDMRs
Date:   Wed,  6 Apr 2022 16:49:25 +1200
Message-Id: <ffc2eefdd212a31278978e8bfccd571355db69b0.1649219184.git.kai.huang@intel.com>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <cover.1649219184.git.kai.huang@intel.com>
References: <cover.1649219184.git.kai.huang@intel.com>
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

In order to provide crypto protection to guests, the TDX module uses
additional metadata to record things like which guest "owns" a given
page of memory.  This metadata, referred as Physical Address Metadata
Table (PAMT), essentially serves as the 'struct page' for the TDX
module.  PAMTs are not reserved by hardware upfront.  They must be
allocated by the kernel and then given to the TDX module.

TDX supports 3 page sizes: 4K, 2M, and 1G.  Each "TD Memory Region"
(TDMR) has 3 PAMTs to track the 3 supported page sizes respectively.
Each PAMT must be a physically contiguous area from the Convertible
Memory Regions (CMR).  However, the PAMTs which track pages in one TDMR
do not need to reside within that TDMR but can be anywhere in CMRs.
If one PAMT overlaps with any TDMR, the overlapping part must be
reported as a reserved area in that particular TDMR.

Use alloc_contig_pages() since PAMT must be a physically contiguous area
and it may be potentially large (~1/256th of the size of the given TDMR).

The current version of TDX supports at most 16 reserved areas per TDMR
to cover both PAMTs and potential memory holes within the TDMR.  If many
PAMTs are allocated within a single TDMR, 16 reserved areas may not be
sufficient to cover all of them.

Adopt the following policies when allocating PAMTs for a given TDMR:

  - Allocate three PAMTs of the TDMR in one contiguous chunk to minimize
    the total number of reserved areas consumed for PAMTs.
  - Try to first allocate PAMT from the local node of the TDMR for better
    NUMA locality.

Signed-off-by: Kai Huang <kai.huang@intel.com>
---
 arch/x86/Kconfig            |   1 +
 arch/x86/virt/vmx/tdx/tdx.c | 165 ++++++++++++++++++++++++++++++++++++
 2 files changed, 166 insertions(+)

diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index 7414625b938f..ff68d0829bd7 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -1973,6 +1973,7 @@ config INTEL_TDX_HOST
 	depends on CPU_SUP_INTEL
 	depends on X86_64
 	select NUMA_KEEP_MEMINFO if NUMA
+	depends on CONTIG_ALLOC
 	help
 	  Intel Trust Domain Extensions (TDX) protects guest VMs from malicious
 	  host and certain physical attacks.  This option enables necessary TDX
diff --git a/arch/x86/virt/vmx/tdx/tdx.c b/arch/x86/virt/vmx/tdx/tdx.c
index 82534e70df96..1b807dcbc101 100644
--- a/arch/x86/virt/vmx/tdx/tdx.c
+++ b/arch/x86/virt/vmx/tdx/tdx.c
@@ -21,6 +21,7 @@
 #include <asm/cpufeatures.h>
 #include <asm/virtext.h>
 #include <asm/e820/api.h>
+#include <asm/pgtable.h>
 #include <asm/tdx.h>
 #include "tdx.h"
 
@@ -66,6 +67,16 @@
 #define TDMR_START(_tdmr)	((_tdmr)->base)
 #define TDMR_END(_tdmr)		((_tdmr)->base + (_tdmr)->size)
 
+/* Page sizes supported by TDX */
+enum tdx_page_sz {
+	TDX_PG_4K = 0,
+	TDX_PG_2M,
+	TDX_PG_1G,
+	TDX_PG_MAX,
+};
+
+#define TDX_HPAGE_SHIFT	9
+
 /*
  * TDX module status during initialization
  */
@@ -959,6 +970,148 @@ static int create_tdmrs(struct tdmr_info **tdmr_array, int *tdmr_num)
 	return ret;
 }
 
+/* Calculate PAMT size given a TDMR and a page size */
+static unsigned long __tdmr_get_pamt_sz(struct tdmr_info *tdmr,
+					enum tdx_page_sz pgsz)
+{
+	unsigned long pamt_sz;
+
+	pamt_sz = (tdmr->size >> ((TDX_HPAGE_SHIFT * pgsz) + PAGE_SHIFT)) *
+		tdx_sysinfo.pamt_entry_size;
+	/* PAMT size must be 4K aligned */
+	pamt_sz = ALIGN(pamt_sz, PAGE_SIZE);
+
+	return pamt_sz;
+}
+
+/* Calculate the size of all PAMTs for a TDMR */
+static unsigned long tdmr_get_pamt_sz(struct tdmr_info *tdmr)
+{
+	enum tdx_page_sz pgsz;
+	unsigned long pamt_sz;
+
+	pamt_sz = 0;
+	for (pgsz = TDX_PG_4K; pgsz < TDX_PG_MAX; pgsz++)
+		pamt_sz += __tdmr_get_pamt_sz(tdmr, pgsz);
+
+	return pamt_sz;
+}
+
+/*
+ * Locate the NUMA node containing the start of the given TDMR's first
+ * RAM entry.  The given TDMR may also cover memory in other NUMA nodes.
+ */
+static int tdmr_get_nid(struct tdmr_info *tdmr)
+{
+	u64 start, end;
+	int i;
+
+	/* Find the first RAM entry covered by the TDMR */
+	e820_for_each_mem(i, start, end)
+		if (end > TDMR_START(tdmr))
+			break;
+
+	/*
+	 * One TDMR must cover at least one (or partial) RAM entry,
+	 * otherwise it is kernel bug.  WARN_ON() in this case.
+	 */
+	if (WARN_ON_ONCE((start >= end) || start >= TDMR_END(tdmr)))
+		return 0;
+
+	/*
+	 * The first RAM entry may be partially covered by the previous
+	 * TDMR.  In this case, use TDMR's start to find the NUMA node.
+	 */
+	if (start < TDMR_START(tdmr))
+		start = TDMR_START(tdmr);
+
+	return phys_to_target_node(start);
+}
+
+static int tdmr_setup_pamt(struct tdmr_info *tdmr)
+{
+	unsigned long tdmr_pamt_base, pamt_base[TDX_PG_MAX];
+	unsigned long pamt_sz[TDX_PG_MAX];
+	unsigned long pamt_npages;
+	struct page *pamt;
+	enum tdx_page_sz pgsz;
+	int nid;
+
+	/*
+	 * Allocate one chunk of physically contiguous memory for all
+	 * PAMTs.  This helps minimize the PAMT's use of reserved areas
+	 * in overlapped TDMRs.
+	 */
+	nid = tdmr_get_nid(tdmr);
+	pamt_npages = tdmr_get_pamt_sz(tdmr) >> PAGE_SHIFT;
+	pamt = alloc_contig_pages(pamt_npages, GFP_KERNEL, nid,
+			&node_online_map);
+	if (!pamt)
+		return -ENOMEM;
+
+	/* Calculate PAMT base and size for all supported page sizes. */
+	tdmr_pamt_base = page_to_pfn(pamt) << PAGE_SHIFT;
+	for (pgsz = TDX_PG_4K; pgsz < TDX_PG_MAX; pgsz++) {
+		unsigned long sz = __tdmr_get_pamt_sz(tdmr, pgsz);
+
+		pamt_base[pgsz] = tdmr_pamt_base;
+		pamt_sz[pgsz] = sz;
+
+		tdmr_pamt_base += sz;
+	}
+
+	tdmr->pamt_4k_base = pamt_base[TDX_PG_4K];
+	tdmr->pamt_4k_size = pamt_sz[TDX_PG_4K];
+	tdmr->pamt_2m_base = pamt_base[TDX_PG_2M];
+	tdmr->pamt_2m_size = pamt_sz[TDX_PG_2M];
+	tdmr->pamt_1g_base = pamt_base[TDX_PG_1G];
+	tdmr->pamt_1g_size = pamt_sz[TDX_PG_1G];
+
+	return 0;
+}
+
+static void tdmr_free_pamt(struct tdmr_info *tdmr)
+{
+	unsigned long pamt_pfn, pamt_sz;
+
+	pamt_pfn = tdmr->pamt_4k_base >> PAGE_SHIFT;
+	pamt_sz = tdmr->pamt_4k_size + tdmr->pamt_2m_size + tdmr->pamt_1g_size;
+
+	/* Do nothing if PAMT hasn't been allocated for this TDMR */
+	if (!pamt_sz)
+		return;
+
+	if (WARN_ON(!pamt_pfn))
+		return;
+
+	free_contig_range(pamt_pfn, pamt_sz >> PAGE_SHIFT);
+}
+
+static void tdmrs_free_pamt_all(struct tdmr_info **tdmr_array, int tdmr_num)
+{
+	int i;
+
+	for (i = 0; i < tdmr_num; i++)
+		tdmr_free_pamt(tdmr_array[i]);
+}
+
+/* Allocate and set up PAMTs for all TDMRs */
+static int tdmrs_setup_pamt_all(struct tdmr_info **tdmr_array, int tdmr_num)
+{
+	int i, ret;
+
+	for (i = 0; i < tdmr_num; i++) {
+		ret = tdmr_setup_pamt(tdmr_array[i]);
+		if (ret)
+			goto err;
+	}
+
+	return 0;
+err:
+	tdmrs_free_pamt_all(tdmr_array, tdmr_num);
+	return -ENOMEM;
+}
+
 static int construct_tdmrs(struct tdmr_info **tdmr_array, int *tdmr_num)
 {
 	int ret;
@@ -971,8 +1124,14 @@ static int construct_tdmrs(struct tdmr_info **tdmr_array, int *tdmr_num)
 	if (ret)
 		goto err;
 
+	ret = tdmrs_setup_pamt_all(tdmr_array, *tdmr_num);
+	if (ret)
+		goto err_free_tdmrs;
+
 	/* Return -EFAULT until constructing TDMRs is done */
 	ret = -EFAULT;
+	tdmrs_free_pamt_all(tdmr_array, *tdmr_num);
+err_free_tdmrs:
 	free_tdmrs(tdmr_array, *tdmr_num);
 err:
 	return ret;
@@ -1022,6 +1181,12 @@ static int init_tdx_module(void)
 	 * initialization are done.
 	 */
 	ret = -EFAULT;
+	/*
+	 * Free PAMTs allocated in construct_tdmrs() when TDX module
+	 * initialization fails.
+	 */
+	if (ret)
+		tdmrs_free_pamt_all(tdmr_array, tdmr_num);
 out_free_tdmrs:
 	/*
 	 * TDMRs are only used during initializing TDX module.  Always
-- 
2.35.1

