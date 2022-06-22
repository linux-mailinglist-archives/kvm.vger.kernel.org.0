Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 25DA355494B
	for <lists+kvm@lfdr.de>; Wed, 22 Jun 2022 14:17:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1357458AbiFVLSN (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 22 Jun 2022 07:18:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57420 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1357448AbiFVLR6 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 22 Jun 2022 07:17:58 -0400
Received: from mga03.intel.com (mga03.intel.com [134.134.136.65])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7A6273CA44;
        Wed, 22 Jun 2022 04:17:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1655896651; x=1687432651;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=4wAXVlXrRybVMRZIe1PorOVh4HwvIaxV8WnHdKrV4cg=;
  b=kYjZFCgDc1A5dCdQwano/pfUnfBIngD4QEok5cp8hfV3T5T5ExNI459Z
   EbruSApseoFhEJvWuzZuYfA2Uz6rXgPRwpFFmIUGavfWqBiCwd7mVQoiU
   tBWTNZwYRDQ1uV+lSKUKUqIQvtKOKEPbk1d+YtS+zhbLQ+ez0WOd22ju9
   2DBQYZd0DI+SMJ8HxnfQ8nOUOwwx5kPFTonpMDu8AWugjJmwKSzsud8Up
   6X5G5LRA3J6H8GMZM1RyVF8uuGcwMEUoaDukSl4L0jGFXdclii9Dh5bkT
   5ktEQOhTpVwohxMd7zrHmdA/JQXyJZslkfoYMo6Im/mEEoMEV7q6qwlYB
   Q==;
X-IronPort-AV: E=McAfee;i="6400,9594,10385"; a="281464740"
X-IronPort-AV: E=Sophos;i="5.92,212,1650956400"; 
   d="scan'208";a="281464740"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Jun 2022 04:17:26 -0700
X-IronPort-AV: E=Sophos;i="5.92,212,1650956400"; 
   d="scan'208";a="730302245"
Received: from jmatsis-mobl.amr.corp.intel.com (HELO khuang2-desk.gar.corp.intel.com) ([10.209.178.197])
  by fmsmga001-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Jun 2022 04:17:23 -0700
From:   Kai Huang <kai.huang@intel.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     seanjc@google.com, pbonzini@redhat.com, dave.hansen@intel.com,
        len.brown@intel.com, tony.luck@intel.com,
        rafael.j.wysocki@intel.com, reinette.chatre@intel.com,
        dan.j.williams@intel.com, peterz@infradead.org, ak@linux.intel.com,
        kirill.shutemov@linux.intel.com,
        sathyanarayanan.kuppuswamy@linux.intel.com,
        isaku.yamahata@intel.com, kai.huang@intel.com
Subject: [PATCH v5 12/22] x86/virt/tdx: Convert all memory regions in memblock to TDX memory
Date:   Wed, 22 Jun 2022 23:17:01 +1200
Message-Id: <8288396be7fedd10521a28531e138579594d757a.1655894131.git.kai.huang@intel.com>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <cover.1655894131.git.kai.huang@intel.com>
References: <cover.1655894131.git.kai.huang@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-5.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
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
BIOS bug) and driver managed memory hotplug are both prevented when TDX
is enabled by BIOS, so no new non-TDX-convertible memory can end up to
the page allocator.

Select ARCH_KEEP_MEMBLOCK when CONFIG_INTEL_TDX_HOST to keep memblock
after boot so it can be used during the TDX module initialization.

Also, explicitly exclude memory regions below first 1MB as TDX memory
because those regions may not be reported as convertible memory.  This
is OK as the first 1MB is always reserved during kernel boot and won't
end up to the page allocator.

Signed-off-by: Kai Huang <kai.huang@intel.com>
---

- v3 -> v4 (no feedback on v4):
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
index 1bc97756bc0d..2b20d4a7a62b 100644
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
@@ -338,6 +340,91 @@ static int tdx_get_sysinfo(struct tdsysinfo_struct *tdsysinfo,
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
@@ -371,6 +458,19 @@ static int init_tdx_module(void)
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
2.36.1

