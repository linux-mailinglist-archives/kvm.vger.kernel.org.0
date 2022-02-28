Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 29AD24C60F9
	for <lists+kvm@lfdr.de>; Mon, 28 Feb 2022 03:16:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230001AbiB1CPn (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 27 Feb 2022 21:15:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60822 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232470AbiB1CPe (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 27 Feb 2022 21:15:34 -0500
Received: from mga02.intel.com (mga02.intel.com [134.134.136.20])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 76AEF53B58;
        Sun, 27 Feb 2022 18:14:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1646014496; x=1677550496;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=tysrMtT8jEwXjyo7aI/e3eLENVwhS0HK0HhToMgzF9k=;
  b=TPyHV7qXEtu/MoEcyd88wzcXFvAlqS9NoVzkJYANiyG9jhls/qEKwM5i
   ilck1CjDpuTIoNZcXbRZYxecWHtL6FSKJbyxua9TdKQUbbiUJriVaCm9E
   pDvXqBXxhkJkDmymHqHzO/xFXyBA2jPQMO/ckNipqmtxDStQGcFe0YzDI
   Wz8Tzt3D1drKdiOkktS02cMdP44tr+FZgwgKJ2g5MFDDOnfOJ90HF7sR+
   V3kbcvfvmw/PY1Mqn/ZT3IQYiqtyM/8QcRTlzVx0iLLv1Eu2pVLncgHBt
   5rQT2/FZjTWytiyA2vuTiFmMnry5r8SoC3ywQtMirNMcuU52EijwgNs2w
   g==;
X-IronPort-AV: E=McAfee;i="6200,9189,10271"; a="240191958"
X-IronPort-AV: E=Sophos;i="5.90,142,1643702400"; 
   d="scan'208";a="240191958"
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Feb 2022 18:14:39 -0800
X-IronPort-AV: E=Sophos;i="5.90,142,1643702400"; 
   d="scan'208";a="777936958"
Received: from jdpanhor-mobl2.amr.corp.intel.com (HELO khuang2-desk.gar.corp.intel.com) ([10.254.49.36])
  by fmsmga006-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Feb 2022 18:14:35 -0800
From:   Kai Huang <kai.huang@intel.com>
To:     x86@kernel.org
Cc:     tglx@linutronix.de, mingo@redhat.com, bp@alien8.de,
        dave.hansen@intel.com, luto@kernel.org, kvm@vger.kernel.org,
        pbonzini@redhat.com, seanjc@google.com, hpa@zytor.com,
        peterz@infradead.org, kirill.shutemov@linux.intel.com,
        sathyanarayanan.kuppuswamy@linux.intel.com, tony.luck@intel.com,
        ak@linux.intel.com, dan.j.williams@intel.com,
        chang.seok.bae@intel.com, keescook@chromium.org,
        hengqi.arch@bytedance.com, laijs@linux.alibaba.com,
        metze@samba.org, linux-kernel@vger.kernel.org, kai.huang@intel.com
Subject: [RFC PATCH 13/21] x86/virt/tdx: Allocate and set up PAMTs for TDMRs
Date:   Mon, 28 Feb 2022 15:13:01 +1300
Message-Id: <79b431a26404951d34c9324c4f2d0e8023fcd259.1646007267.git.kai.huang@intel.com>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <cover.1646007267.git.kai.huang@intel.com>
References: <cover.1646007267.git.kai.huang@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
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
 arch/x86/Kconfig        |   2 +
 arch/x86/virt/vmx/tdx.c | 165 ++++++++++++++++++++++++++++++++++++++++
 2 files changed, 167 insertions(+)

diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index f4c5481cca46..700a9008dbbe 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -1961,6 +1961,8 @@ config INTEL_TDX_HOST
 	default n
 	depends on CPU_SUP_INTEL
 	depends on X86_64
+	depends on CONTIG_ALLOC
+	select NUMA_KEEP_MEMINFO if NUMA
 	help
 	  Intel Trust Domain Extensions (TDX) protects guest VMs from malicious
 	  host and certain physical attacks.  This option enables necessary TDX
diff --git a/arch/x86/virt/vmx/tdx.c b/arch/x86/virt/vmx/tdx.c
index fe83cf9ac2f9..d29e7943f890 100644
--- a/arch/x86/virt/vmx/tdx.c
+++ b/arch/x86/virt/vmx/tdx.c
@@ -20,6 +20,7 @@
 #include <asm/cpufeatures.h>
 #include <asm/virtext.h>
 #include <asm/e820/api.h>
+#include <asm/pgtable.h>
 #include <asm/tdx.h>
 #include "tdx.h"
 
@@ -65,6 +66,16 @@
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
@@ -878,6 +889,148 @@ static int create_tdmrs(struct tdmr_info **tdmr_array, int *tdmr_num)
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
+	e820_for_each_mem(e820_table, i, start, end)
+		if (end > TDMR_START(tdmr))
+			break;
+
+	/*
+	 * One TDMR must cover at least one (or partial) RAM entry,
+	 * otherwise it is kernel bug.  WARN_ON() in this case.
+	 */
+	if (WARN_ON(i == e820_table->nr_entries || start >= TDMR_END(tdmr)))
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
@@ -890,8 +1043,14 @@ static int construct_tdmrs(struct tdmr_info **tdmr_array, int *tdmr_num)
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
@@ -941,6 +1100,12 @@ static int init_tdx_module(void)
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
2.33.1

