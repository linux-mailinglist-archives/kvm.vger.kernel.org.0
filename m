Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 98EBB6317B8
	for <lists+kvm@lfdr.de>; Mon, 21 Nov 2022 01:29:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230059AbiKUA3R (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 20 Nov 2022 19:29:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57306 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229848AbiKUA2o (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 20 Nov 2022 19:28:44 -0500
Received: from mga07.intel.com (mga07.intel.com [134.134.136.100])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 365E72DA96;
        Sun, 20 Nov 2022 16:27:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1668990472; x=1700526472;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=USq/NN8kgkdf9mW4R0hp3+fsrsI45C1gLZr7XotHn6c=;
  b=NO2NeigfGmh2RjuvhPVrgDp/n8PaPOEdJf3uHQfN+gS/qyPX7A2F2imv
   y0bLkjT19YimGW2t29jKDwbG7R/+CeHVIAUDGgrjbPsNlzZIAd0o6i4VI
   Gz/kO2J+so720BIWditXBTThw5Dp+WWziGmXJmzACATbGbvsEyZOv7VVb
   Hz/8BjMuPONVfwHc6HQfGRTMQHj1kBR1MnChYVrcq4ykXbpZz4cPJ6ZBl
   Qu/aAQAEHLxIUiVq0+wgLL55NuTJ9nJ/UnAsG/2+9h/2kdZ0MRwro5hMd
   btWc4OQ6musfc4/Qy56HfFkeAxon2ZIiqctBEQyU+sdI74S7mE/8xKQTF
   Q==;
X-IronPort-AV: E=McAfee;i="6500,9779,10537"; a="377705718"
X-IronPort-AV: E=Sophos;i="5.96,180,1665471600"; 
   d="scan'208";a="377705718"
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Nov 2022 16:27:51 -0800
X-IronPort-AV: E=McAfee;i="6500,9779,10537"; a="729825444"
X-IronPort-AV: E=Sophos;i="5.96,180,1665471600"; 
   d="scan'208";a="729825444"
Received: from tomnavar-mobl.amr.corp.intel.com (HELO khuang2-desk.gar.corp.intel.com) ([10.209.176.15])
  by fmsmga003-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Nov 2022 16:27:47 -0800
From:   Kai Huang <kai.huang@intel.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     linux-mm@kvack.org, seanjc@google.com, pbonzini@redhat.com,
        dave.hansen@intel.com, dan.j.williams@intel.com,
        rafael.j.wysocki@intel.com, kirill.shutemov@linux.intel.com,
        ying.huang@intel.com, reinette.chatre@intel.com,
        len.brown@intel.com, tony.luck@intel.com, peterz@infradead.org,
        ak@linux.intel.com, isaku.yamahata@intel.com, chao.gao@intel.com,
        sathyanarayanan.kuppuswamy@linux.intel.com, bagasdotme@gmail.com,
        sagis@google.com, imammedo@redhat.com, kai.huang@intel.com
Subject: [PATCH v7 13/20] x86/virt/tdx: Allocate and set up PAMTs for TDMRs
Date:   Mon, 21 Nov 2022 13:26:35 +1300
Message-Id: <ef6cdab2c371b9f068f2b4bf493b1dd0c9bb3c99.1668988357.git.kai.huang@intel.com>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <cover.1668988357.git.kai.huang@intel.com>
References: <cover.1668988357.git.kai.huang@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
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
 arch/x86/virt/vmx/tdx/tdx.c | 191 ++++++++++++++++++++++++++++++++++++
 2 files changed, 192 insertions(+)

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
index 57b448de59a0..9d76e70de46e 100644
--- a/arch/x86/virt/vmx/tdx/tdx.c
+++ b/arch/x86/virt/vmx/tdx/tdx.c
@@ -586,6 +586,187 @@ static int create_tdmrs(struct tdmr_info *tdmr_array, int *tdmr_num)
 	return 0;
 }
 
+/*
+ * Calculate PAMT size given a TDMR and a page size.  The returned
+ * PAMT size is always aligned up to 4K page boundary.
+ */
+static unsigned long tdmr_get_pamt_sz(struct tdmr_info *tdmr, int pgsz)
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
+	unsigned long pamt_base[TDX_PS_1G + 1];
+	unsigned long pamt_size[TDX_PS_1G + 1];
+	unsigned long tdmr_pamt_base;
+	unsigned long tdmr_pamt_size;
+	struct page *pamt;
+	int pgsz, nid;
+
+	nid = tdmr_get_nid(tdmr);
+
+	/*
+	 * Calculate the PAMT size for each TDX supported page size
+	 * and the total PAMT size.
+	 */
+	tdmr_pamt_size = 0;
+	for (pgsz = TDX_PS_4K; pgsz <= TDX_PS_1G ; pgsz++) {
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
@@ -598,8 +779,13 @@ static int construct_tdmrs(struct tdmr_info *tdmr_array, int *tdmr_num)
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
@@ -686,6 +872,11 @@ static int init_tdx_module(void)
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
2.38.1

