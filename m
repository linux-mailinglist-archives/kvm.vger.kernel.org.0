Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 144DB4D7461
	for <lists+kvm@lfdr.de>; Sun, 13 Mar 2022 11:51:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229808AbiCMKwW (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 13 Mar 2022 06:52:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43076 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234291AbiCMKwF (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 13 Mar 2022 06:52:05 -0400
Received: from mga04.intel.com (mga04.intel.com [192.55.52.120])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A218342EDB;
        Sun, 13 Mar 2022 03:50:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1647168646; x=1678704646;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=6w4wpWsKsHJjPcV/gxFlGtmd6yOnj3Ocq7tPmvnI3hg=;
  b=Nwl0SqVg4kEz5qLJDrkTAdVm7zpYNgFfPhPI9lr1E+PT3ad4+5cUDlQv
   KHTtvCGJ8ogMjWoeRIyzWgXhyPmN24uwE/053uDjhFqUBZ3eQmGqEkwhl
   CjL2pE6KJ90KFGBSpiFbKHEsMHu4rFhf2ync54aANPEQRmYU1kmyHm9ZL
   8rdqZqxH3iLqt+P7GA1pXiWMDRAJzB2m9YJty6ML0KOtDNarjJxsNg5eP
   kM5c4Wx2fLFd7dltx8bFkfBfYiZJw5hWngEwP5Dtm/sJOe//SUQqTjo1E
   EbkZwH9RrNF82Wn25oqHkPKXbkNuI9WgS6UIIY1ZAYJL65a0ETXYr6odE
   Q==;
X-IronPort-AV: E=McAfee;i="6200,9189,10284"; a="254689538"
X-IronPort-AV: E=Sophos;i="5.90,178,1643702400"; 
   d="scan'208";a="254689538"
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Mar 2022 03:50:46 -0700
X-IronPort-AV: E=Sophos;i="5.90,178,1643702400"; 
   d="scan'208";a="645448145"
Received: from mvideche-mobl1.amr.corp.intel.com (HELO khuang2-desk.gar.corp.intel.com) ([10.251.130.249])
  by orsmga004-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Mar 2022 03:50:43 -0700
From:   Kai Huang <kai.huang@intel.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     dave.hansen@intel.com, seanjc@google.com, pbonzini@redhat.com,
        kirill.shutemov@linux.intel.com,
        sathyanarayanan.kuppuswamy@linux.intel.com, peterz@infradead.org,
        tony.luck@intel.com, ak@linux.intel.com, dan.j.williams@intel.com,
        isaku.yamahata@intel.com, kai.huang@intel.com
Subject: [PATCH v2 11/21] x86/virt/tdx: Choose to use all system RAM as TDX memory
Date:   Sun, 13 Mar 2022 23:49:51 +1300
Message-Id: <d5c4273029a67579365472f1594107089dd04d50.1647167475.git.kai.huang@intel.com>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <cover.1647167475.git.kai.huang@intel.com>
References: <cover.1647167475.git.kai.huang@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-5.9 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

As one step of initializing the TDX module, the memory regions that the
TDX module can use must be configured to it via an array of 'TD Memory
Regions' (TDMR).  The kernel is responsible for choosing which memory
regions to be used as TDX memory and building the array of TDMRs to
cover those memory regions.

The first generation of TDX-capable platforms basically guarantees all
system RAM regions during machine boot are Convertible Memory Regions
(excluding the memory below 1MB) and can be used by TDX.  The memory
pages allocated to TD guests can be any pages managed by the page
allocator.  To avoid having to modify the page allocator to distinguish
TDX and non-TDX memory allocation, adopt a simple policy to use all
system RAM regions as TDX memory.  The low 1MB pages are excluded from
TDX memory since they are not in CMRs in some platforms (those pages are
reserved at boot time and won't be managed by page allocator anyway).

This policy could be revised later if future TDX generations break
the guarantee or when the size of the metadata (~1/256th of the size of
the TDX usable memory) becomes a concern.  At that time a CMR-aware
page allocator may be necessary.

Also, on the first generation of TDX-capable machine, the system RAM
ranges discovered during boot time are all memory regions that kernel
can use during its runtime.  This is because the first generation of TDX
architecturally doesn't support ACPI memory hotplug (CMRs are generated
during machine boot and are static during machine's runtime).  Also, the
first generation of TDX-capable platform doesn't support TDX and ACPI
memory hotplug at the same time on a single machine.  Another case of
memory hotplug is user may use NVDIMM as system RAM via kmem driver.
But the first generation of TDX-capable machine doesn't support TDX and
NVDIMM simultaneously, therefore in practice it cannot happen.  One
special case is user may use 'memmap' kernel command line to reserve
part of system RAM as x86 legacy PMEMs, and user can theoretically add
them as system RAM via kmem driver.  This can be resolved by always
treating legacy PMEMs as TDX memory.

Implement a helper to loop over all RAM entries in e820 table to find
all system RAM ranges, as a preparation to covert all of them to TDX
memory.  Use 'e820_table', rather than 'e820_table_firmware' to honor
'mem' and 'memmap' command lines.  Following e820__memblock_setup(),
both E820_TYPE_RAM and E820_TYPE_RESERVED_KERN types are treated as TDX
memory, and contiguous ranges in the same NUMA node are merged together.

One difference is, as mentioned above, x86 legacy PMEMs (E820_TYPE_PRAM)
are also always treated as TDX memory.  They are underneath RAM, and
they could be used as TD guest memory.  Always including them as TDX
memory also avoids having to modify memory hotplug code to handle adding
them as system RAM via kmem driver.

To begin with, sanity check all memory regions found in e820 are fully
covered by any CMR and can be used as TDX memory.

Signed-off-by: Kai Huang <kai.huang@intel.com>
---
 arch/x86/Kconfig        |   1 +
 arch/x86/virt/vmx/tdx.c | 228 +++++++++++++++++++++++++++++++++++++++-
 2 files changed, 228 insertions(+), 1 deletion(-)

diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index f4c5481cca46..2d3f983e3582 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -1961,6 +1961,7 @@ config INTEL_TDX_HOST
 	default n
 	depends on CPU_SUP_INTEL
 	depends on X86_64
+	select NUMA_KEEP_MEMINFO if NUMA
 	help
 	  Intel Trust Domain Extensions (TDX) protects guest VMs from malicious
 	  host and certain physical attacks.  This option enables necessary TDX
diff --git a/arch/x86/virt/vmx/tdx.c b/arch/x86/virt/vmx/tdx.c
index 1571bf192dde..e5206599f558 100644
--- a/arch/x86/virt/vmx/tdx.c
+++ b/arch/x86/virt/vmx/tdx.c
@@ -14,11 +14,13 @@
 #include <linux/smp.h>
 #include <linux/atomic.h>
 #include <linux/slab.h>
+#include <linux/math.h>
 #include <asm/msr-index.h>
 #include <asm/msr.h>
 #include <asm/cpufeature.h>
 #include <asm/cpufeatures.h>
 #include <asm/virtext.h>
+#include <asm/e820/api.h>
 #include <asm/tdx.h>
 #include "tdx.h"
 
@@ -591,6 +593,222 @@ static int tdx_get_sysinfo(void)
 	return sanitize_cmrs(tdx_cmr_array, cmr_num);
 }
 
+/* Check whether one e820 entry is RAM and could be used as TDX memory */
+static bool e820_entry_is_ram(struct e820_entry *entry)
+{
+	/*
+	 * Besides E820_TYPE_RAM, E820_TYPE_RESERVED_KERN type entries
+	 * are also treated as TDX memory as they are also added to
+	 * memblock.memory in e820__memblock_setup().
+	 *
+	 * E820_TYPE_SOFT_RESERVED type entries are excluded as they are
+	 * marked as reserved and are not later freed to page allocator
+	 * (only part of kernel image, initrd, etc are freed to page
+	 * allocator).
+	 *
+	 * Also unconditionally treat x86 legacy PMEMs (E820_TYPE_PRAM)
+	 * as TDX memory since they are RAM underneath, and could be used
+	 * as TD guest memory.
+	 */
+	return (entry->type == E820_TYPE_RAM) ||
+		(entry->type == E820_TYPE_RESERVED_KERN) ||
+		(entry->type == E820_TYPE_PRAM);
+}
+
+/*
+ * The low memory below 1MB is not covered by CMRs on some TDX platforms.
+ * In practice, this range cannot be used for guest memory because it is
+ * not managed by the page allocator due to boot-time reservation.  Just
+ * skip the low 1MB so this range won't be treated as TDX memory.
+ *
+ * Return true if the e820 entry is completely skipped, in which case
+ * caller should ignore this entry.  Otherwise the actual memory range
+ * after skipping the low 1MB is returned via @start and @end.
+ */
+static bool e820_entry_skip_lowmem(struct e820_entry *entry, u64 *start,
+				   u64 *end)
+{
+	u64 _start = entry->addr;
+	u64 _end = entry->addr + entry->size;
+
+	if (_start < SZ_1M)
+		_start = SZ_1M;
+
+	*start = _start;
+	*end = _end;
+
+	return _start >= _end;
+}
+
+/*
+ * Trim away non-page-aligned memory at the beginning and the end for a
+ * given region.  Return true when there are still pages remaining after
+ * trimming, and the trimmed region is returned via @start and @end.
+ */
+static bool e820_entry_trim(u64 *start, u64 *end)
+{
+	u64 s, e;
+
+	s = round_up(*start, PAGE_SIZE);
+	e = round_down(*end, PAGE_SIZE);
+
+	if (s >= e)
+		return false;
+
+	*start = s;
+	*end = e;
+
+	return true;
+}
+
+/*
+ * Get the next memory region (excluding low 1MB) in e820.  @idx points
+ * to the entry to start to walk with.  Multiple memory regions in the
+ * same NUMA node that are contiguous are merged together (following
+ * e820__memblock_setup()).  The merged range is returned via @start and
+ * @end.  After return, @idx points to the next entry of the last RAM
+ * entry that has been walked, or table->nr_entries (indicating all
+ * entries in the e820 table have been walked).
+ */
+static void e820_next_mem(struct e820_table *table, int *idx, u64 *start,
+			  u64 *end)
+{
+	u64 rs, re;
+	int rnid, i;
+
+again:
+	rs = re = 0;
+	for (i = *idx; i < table->nr_entries; i++) {
+		struct e820_entry *entry = &table->entries[i];
+		u64 s, e;
+		int nid;
+
+		if (!e820_entry_is_ram(entry))
+			continue;
+
+		if (e820_entry_skip_lowmem(entry, &s, &e))
+			continue;
+
+		/*
+		 * Found the first RAM entry.  Record it and keep
+		 * looping to find other RAM entries that can be
+		 * merged.
+		 */
+		if (!rs) {
+			rs = s;
+			re = e;
+			rnid = phys_to_target_node(rs);
+			if (WARN_ON_ONCE(rnid == NUMA_NO_NODE))
+				rnid = 0;
+			continue;
+		}
+
+		/*
+		 * Try to merge with previous RAM entry.  E820 entries
+		 * are not necessarily page aligned.  For instance, the
+		 * setup_data elements in boot_params are marked as
+		 * E820_TYPE_RESERVED_KERN, and they may not be page
+		 * aligned.  In e820__memblock_setup() all adjancent
+		 * memory regions within the same NUMA node are merged to
+		 * a single one, and the non-page-aligned parts (at the
+		 * beginning and the end) are trimmed.  Follow the same
+		 * rule here.
+		 */
+		nid = phys_to_target_node(s);
+		if (WARN_ON_ONCE(nid == NUMA_NO_NODE))
+			nid = 0;
+		if ((nid == rnid) && (s == re)) {
+			/* Merge with previous range and update the end */
+			re = e;
+			continue;
+		}
+
+		/*
+		 * Stop if current entry cannot be merged with previous
+		 * one (or more) entries.
+		 */
+		break;
+	}
+
+	/*
+	 * @i is either the RAM entry that cannot be merged with previous
+	 * one (or more) entries, or table->nr_entries.
+	 */
+	*idx = i;
+	/*
+	 * Trim non-page-aligned parts of [@rs, @re), which is either a
+	 * valid memory region, or empty.  If there's nothing left after
+	 * trimming and there are still entries that have not been
+	 * walked, continue to walk.
+	 */
+	if (!e820_entry_trim(&rs, &re) && i < table->nr_entries)
+		goto again;
+
+	*start = rs;
+	*end = re;
+}
+
+/*
+ * Helper to loop all e820 RAM entries with low 1MB excluded
+ * in a given e820 table.
+ */
+#define _e820_for_each_mem(_table, _i, _start, _end)				\
+	for ((_i) = 0, e820_next_mem((_table), &(_i), &(_start), &(_end));	\
+		(_start) < (_end);						\
+		e820_next_mem((_table), &(_i), &(_start), &(_end)))
+
+/*
+ * Helper to loop all e820 RAM entries with low 1MB excluded
+ * in kernel modified 'e820_table' to honor 'mem' and 'memmap' kernel
+ * command lines.
+ */
+#define e820_for_each_mem(_i, _start, _end)	\
+	_e820_for_each_mem(e820_table, _i, _start, _end)
+
+/* Check whether first range is the subrange of the second */
+static bool is_subrange(u64 r1_start, u64 r1_end, u64 r2_start, u64 r2_end)
+{
+	return (r1_start >= r2_start && r1_end <= r2_end) ? true : false;
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
+/* Sanity check whether all e820 RAM entries are fully covered by CMRs. */
+static int e820_check_against_cmrs(void)
+{
+	u64 start, end;
+	int i;
+
+	/*
+	 * Loop over e820_table to find all RAM entries and check
+	 * whether they are all fully covered by any CMR.
+	 */
+	e820_for_each_mem(i, start, end) {
+		if (!range_covered_by_cmr(tdx_cmr_array, tdx_cmr_num,
+					start, end)) {
+			pr_err("[0x%llx, 0x%llx) is not fully convertible memory\n",
+					start, end);
+			return -EFAULT;
+		}
+	}
+
+	return 0;
+}
+
 static void free_tdmrs(struct tdmr_info **tdmr_array, int tdmr_num)
 {
 	int i;
@@ -606,8 +824,16 @@ static void free_tdmrs(struct tdmr_info **tdmr_array, int tdmr_num)
 
 static int construct_tdmrs(struct tdmr_info **tdmr_array, int *tdmr_num)
 {
+	int ret;
+
+	ret = e820_check_against_cmrs();
+	if (ret)
+		goto err;
+
 	/* Return -EFAULT until constructing TDMRs is done */
-	return -EFAULT;
+	ret = -EFAULT;
+err:
+	return ret;
 }
 
 static int init_tdx_module(void)
-- 
2.35.1

