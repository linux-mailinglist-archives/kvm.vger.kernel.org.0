Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9D14A539721
	for <lists+kvm@lfdr.de>; Tue, 31 May 2022 21:41:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347422AbiEaTlR (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 31 May 2022 15:41:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38566 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347397AbiEaTlG (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 31 May 2022 15:41:06 -0400
Received: from mga11.intel.com (mga11.intel.com [192.55.52.93])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2FD5F9D4C5;
        Tue, 31 May 2022 12:40:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1654026056; x=1685562056;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=iS2G3zq8V+EXqa65rsnM1imgoaFK0JtVT3k8puf41SM=;
  b=QVZCD9Of2NnueDYwxrQbp5qt4Fz8M/gCk8wDx5qo4l3f4TAF30Fc+H08
   1JlWR5/LZjesOJvkknqmz+iVbtuSmGz+X3kPlHaDXLsHcXOSglxW+WrWG
   g48Teu4LtqRQwHgNu+WHL4UcNig7gZUI0cx6+1K0Mw4RTegspQ45/C+Y8
   k4OGmi7fCWzUQFH+/TqyemvN+OCYuLklk40nsxWNx9tkZcSKleh1u+IN4
   79XQja7s/KluzJqdkxD32rMdLWViY425jRob6VP5NVAdl0ls7suhM5/Tl
   kCLRTIUzyhGWA3Fy59TeaxaP3HEisDcWX+WhvWguECyrb0rATqEw5g/MT
   Q==;
X-IronPort-AV: E=McAfee;i="6400,9594,10364"; a="272935120"
X-IronPort-AV: E=Sophos;i="5.91,266,1647327600"; 
   d="scan'208";a="272935120"
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 31 May 2022 12:40:36 -0700
X-IronPort-AV: E=Sophos;i="5.91,266,1647327600"; 
   d="scan'208";a="645164484"
Received: from maciejwo-mobl1.ger.corp.intel.com (HELO khuang2-desk.gar.corp.intel.com) ([10.254.36.207])
  by fmsmga004-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 31 May 2022 12:40:33 -0700
From:   Kai Huang <kai.huang@intel.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     seanjc@google.com, pbonzini@redhat.com, dave.hansen@intel.com,
        len.brown@intel.com, tony.luck@intel.com,
        rafael.j.wysocki@intel.com, reinette.chatre@intel.com,
        dan.j.williams@intel.com, peterz@infradead.org, ak@linux.intel.com,
        kirill.shutemov@linux.intel.com,
        sathyanarayanan.kuppuswamy@linux.intel.com,
        isaku.yamahata@intel.com, kai.huang@intel.com
Subject: [PATCH v4 12/22] x86/virt/tdx: Convert all memory regions in memblock to TDX memory
Date:   Wed,  1 Jun 2022 07:39:35 +1200
Message-Id: <2cfbf8d3e2c9befd9aac905c239ac76d2e15558e.1654025431.git.kai.huang@intel.com>
X-Mailer: git-send-email 2.35.3
In-Reply-To: <cover.1654025430.git.kai.huang@intel.com>
References: <cover.1654025430.git.kai.huang@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The TDX module reports a list of Convertible Memory Regions (CMR) to
identify which memory regions can be used as TDX memory, but they are
not automatically usable to the TDX module.  The kernel needs to choose
which convertible memory regions to be TDX memory and configure those
regions by passing an array of "TD Memory Regions" (TDMR) to the TDX
module.

To avoid having to modify the page allocator to distinguish TDX and
non-TDX memory allocation, convert all memory regions in the memblock to
TDX memory.  As the first step, sanity check all memory regions in
memblock are fully covered by CMRs so the above conversion is guaranteed
to work.  This works also because both ACPI memory hotplug (reported as
BIOS bug) and kmem-hot-add are both prevented when TDX is enabled by
BIOS, so no new non-TDX-convertible memory can end up to the page
allocator.

Select ARCH_KEEP_MEMBLOCK when CONFIG_INTEL_TDX_HOST to keep memblock
after boot so it can be used during the TDX module initialization.

Signed-off-by: Kai Huang <kai.huang@intel.com>
---

- v3 -> v4:
 - Changed to use memblock from e820.
 - Simplified changelog a lot.

---
 arch/x86/Kconfig            |   1 +
 arch/x86/virt/vmx/tdx/tdx.c | 100 ++++++++++++++++++++++++++++++++++++
 2 files changed, 101 insertions(+)

diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index efa830853e98..4988a91d5283 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -1974,6 +1974,7 @@ config INTEL_TDX_HOST
 	depends on X86_64
 	depends on KVM_INTEL
 	select ARCH_HAS_CC_PLATFORM
+	select ARCH_KEEP_MEMBLOCK
 	help
 	  Intel Trust Domain Extensions (TDX) protects guest VMs from malicious
 	  host and certain physical attacks.  This option enables necessary TDX
diff --git a/arch/x86/virt/vmx/tdx/tdx.c b/arch/x86/virt/vmx/tdx/tdx.c
index 08590a6ea6f9..b0b4841ec144 100644
--- a/arch/x86/virt/vmx/tdx/tdx.c
+++ b/arch/x86/virt/vmx/tdx/tdx.c
@@ -15,6 +15,8 @@
 #include <linux/cpumask.h>
 #include <linux/smp.h>
 #include <linux/atomic.h>
+#include <linux/sizes.h>
+#include <linux/memblock.h>
 #include <asm/cpufeatures.h>
 #include <asm/cpufeature.h>
 #include <asm/msr-index.h>
@@ -344,6 +346,91 @@ static int tdx_get_sysinfo(struct tdsysinfo_struct *tdsysinfo,
 	return check_cmrs(cmr_array, actual_cmr_num);
 }
 
+/*
+ * Skip the memory region below 1MB.  Return true if the entire
+ * region is skipped.  Otherwise, the updated range is returned.
+ */
+static bool pfn_range_skip_lowmem(unsigned long *p_start_pfn,
+				  unsigned long *p_end_pfn)
+{
+	u64 start, end;
+
+	start = *p_start_pfn << PAGE_SHIFT;
+	end = *p_end_pfn << PAGE_SHIFT;
+
+	if (start < SZ_1M)
+		start = SZ_1M;
+
+	if (start >= end)
+		return true;
+
+	*p_start_pfn = (start >> PAGE_SHIFT);
+
+	return false;
+}
+
+/*
+ * Walks over all memblock memory regions that are intended to be
+ * converted to TDX memory.  Essentially, it is all memblock memory
+ * regions excluding the low memory below 1MB.
+ *
+ * This is because on some TDX platforms the low memory below 1MB is
+ * not included in CMRs.  Excluding the low 1MB can still guarantee
+ * that the pages managed by the page allocator are always TDX memory,
+ * as the low 1MB is reserved during kernel boot and won't end up to
+ * the ZONE_DMA (see reserve_real_mode()).
+ */
+#define memblock_for_each_tdx_mem_pfn_range(i, p_start, p_end, p_nid)	\
+	for_each_mem_pfn_range(i, MAX_NUMNODES, p_start, p_end, p_nid)	\
+		if (!pfn_range_skip_lowmem(p_start, p_end))
+
+/* Check whether first range is the subrange of the second */
+static bool is_subrange(u64 r1_start, u64 r1_end, u64 r2_start, u64 r2_end)
+{
+	return r1_start >= r2_start && r1_end <= r2_end;
+}
+
+/* Check whether address range is covered by any CMR or not. */
+static bool range_covered_by_cmr(struct cmr_info *cmr_array, int cmr_num,
+				 u64 start, u64 end)
+{
+	int i;
+
+	for (i = 0; i < cmr_num; i++) {
+		struct cmr_info *cmr = &cmr_array[i];
+
+		if (is_subrange(start, end, cmr->base, cmr->base + cmr->size))
+			return true;
+	}
+
+	return false;
+}
+
+/*
+ * Check whether all memory regions in memblock are TDX convertible
+ * memory.  Return 0 if all memory regions are convertible, or error.
+ */
+static int check_memblock_tdx_convertible(void)
+{
+	unsigned long start_pfn, end_pfn;
+	int i;
+
+	memblock_for_each_tdx_mem_pfn_range(i, &start_pfn, &end_pfn, NULL) {
+		u64 start, end;
+
+		start = start_pfn << PAGE_SHIFT;
+		end = end_pfn << PAGE_SHIFT;
+		if (!range_covered_by_cmr(tdx_cmr_array, tdx_cmr_num, start,
+					end)) {
+			pr_err("[0x%llx, 0x%llx) is not fully convertible memory\n",
+					start, end);
+			return -EINVAL;
+		}
+	}
+
+	return 0;
+}
+
 /*
  * Detect and initialize the TDX module.
  *
@@ -377,6 +464,19 @@ static int init_tdx_module(void)
 	if (ret)
 		goto out;
 
+	/*
+	 * To avoid having to modify the page allocator to distinguish
+	 * TDX and non-TDX memory allocation, convert all memory regions
+	 * in memblock to TDX memory to make sure all pages managed by
+	 * the page allocator are TDX memory.
+	 *
+	 * Sanity check all memory regions are fully covered by CMRs to
+	 * make sure they are truly convertible.
+	 */
+	ret = check_memblock_tdx_convertible();
+	if (ret)
+		goto out;
+
 	/*
 	 * Return -EINVAL until all steps of TDX module initialization
 	 * process are done.
-- 
2.35.3

