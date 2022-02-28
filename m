Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8CF264C60EB
	for <lists+kvm@lfdr.de>; Mon, 28 Feb 2022 03:16:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229714AbiB1CPk (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 27 Feb 2022 21:15:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60694 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232447AbiB1CPd (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 27 Feb 2022 21:15:33 -0500
Received: from mga02.intel.com (mga02.intel.com [134.134.136.20])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B8EEE52E58;
        Sun, 27 Feb 2022 18:14:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1646014495; x=1677550495;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=sXas/cs7+DF8UXx5TnXDuYHZFOLlYvCIkDZyCWv9Un4=;
  b=B7pM0yZ28MvfciQgXnXKb1GNeqSf4HB8DVUALZK2Bp85CORQ0V0VYND3
   DxJq0zySO9HFS/GoU6zId6HUDlwuXx5ykPN0iBBomL5ej+vanOiKPgW77
   aKpMIfFlpnZR5QZanzc5Qrk7Qsn2/VvLWNDM+7VCPRnXN3mlzgaq6BMXV
   sML3Wf+iTkKZexBi54dnAVCME0TG0UdbmhBe/O4A7yS0pqGMMQRaQqf3u
   dipbl8gYxTGDYP+hoMNMMeJOE5rgdZtKmdO1O4qAoB0mZSvNN06jOzsTy
   ADgDU/KRWKTcGY7qLeyNvXEH9ey17blKqf1okv8xZL93KyjMkc24pSWJI
   A==;
X-IronPort-AV: E=McAfee;i="6200,9189,10271"; a="240191942"
X-IronPort-AV: E=Sophos;i="5.90,142,1643702400"; 
   d="scan'208";a="240191942"
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Feb 2022 18:14:30 -0800
X-IronPort-AV: E=Sophos;i="5.90,142,1643702400"; 
   d="scan'208";a="777936943"
Received: from jdpanhor-mobl2.amr.corp.intel.com (HELO khuang2-desk.gar.corp.intel.com) ([10.254.49.36])
  by fmsmga006-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Feb 2022 18:14:26 -0800
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
Subject: [RFC PATCH 11/21] x86/virt/tdx: Choose to use all system RAM as TDX memory
Date:   Mon, 28 Feb 2022 15:12:59 +1300
Message-Id: <c947c74b52b3e58da8145e6b335e78c7c20bae35.1646007267.git.kai.huang@intel.com>
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

As one step of initializing the TDX module, the memory regions that TDX
module can use must be configured to the TDX module via an array of
TDMRs.  The kernel is responsible for choosing which memory regions to
be used as TDX memory.

The first generation of TDX-capable platforms basically guarantee all
system RAM regions are Convertible Memory Regions (excluding the memory
below 1MB).  The memory pages allocated to TD guests can be any pages
managed by the page allocator.  To avoid modifying the page allocator to
distinguish TDX and non-TDX memory allocation, adopt a simple policy to
use all system RAM regions as TDX memory.  The low 1MB pages are
excluded from TDX memory since they are not in CMRs.  But this is OK
since they are reserved at boot time and won't be managed by the page
allocator anyway.

This policy could be revised later if future TDX generations break
the guarantee or when the size of the metadata (~1/256th of the size of
the TDX usable memory) becomes a concern.  At that time a CMR-aware
page allocator may be necessary.

To begin with, sanity check all e820 RAM entries (excluding low 1MB) are
fully covered by any CMR and can be used as TDX memory.  Use e820_table,
rather than using e820_table_firmware or e820_table_kexec, to honor 'mem'
and 'memmap' kernel command lines.  X86 legacy PMEMs (PRAM) are also
treated as RAM since underneath they are RAM, and they may be used by
TD guest.

Signed-off-by: Kai Huang <kai.huang@intel.com>
---
 arch/x86/virt/vmx/tdx.c | 150 +++++++++++++++++++++++++++++++++++++++-
 1 file changed, 149 insertions(+), 1 deletion(-)

diff --git a/arch/x86/virt/vmx/tdx.c b/arch/x86/virt/vmx/tdx.c
index cd7c09a57235..0780ec71651b 100644
--- a/arch/x86/virt/vmx/tdx.c
+++ b/arch/x86/virt/vmx/tdx.c
@@ -19,6 +19,7 @@
 #include <asm/cpufeature.h>
 #include <asm/cpufeatures.h>
 #include <asm/virtext.h>
+#include <asm/e820/api.h>
 #include <asm/tdx.h>
 #include "tdx.h"
 
@@ -592,6 +593,145 @@ static int tdx_get_sysinfo(void)
 	return sanitize_cmrs(tdx_cmr_array, cmr_num);
 }
 
+/*
+ * Only E820_TYPE_RAM and E820_TYPE_PRAM are considered as candidate for
+ * TDX usable memory.  The latter is treated as RAM because it is created
+ * on top of real RAM via kernel command line and may be allocated for TD
+ * guests.
+ */
+static bool e820_entry_is_ram(struct e820_entry *entry)
+{
+	return (entry->type == E820_TYPE_RAM) ||
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
+/* Find the next RAM entry (excluding low 1MB) in e820 */
+static void e820_next_mem(struct e820_table *table, int *idx, u64 *start,
+			  u64 *end)
+{
+	int i;
+
+	for (i = *idx; i < table->nr_entries; i++) {
+		struct e820_entry *entry = &table->entries[i];
+		u64 s, e;
+
+		if (!e820_entry_is_ram(entry))
+			continue;
+
+		if (e820_entry_skip_lowmem(entry, &s, &e))
+			continue;
+
+		if (!e820_entry_trim(&s, &e))
+			continue;
+
+		*idx = i;
+		*start = s;
+		*end = e;
+
+		return;
+	}
+
+	*idx = table->nr_entries;
+}
+
+/* Helper to loop all e820 RAM entries with low 1MB excluded  */
+#define e820_for_each_mem(_table, _i, _start, _end)				\
+	for ((_i) = 0, e820_next_mem((_table), &(_i), &(_start), &(_end));	\
+		(_i) < (_table)->nr_entries;					\
+		(_i)++, e820_next_mem((_table), &(_i), &(_start), &(_end)))
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
+	 * whether they are all fully covered by any CMR.  Use e820_table
+	 * instead of e820_table_firmware or e820_table_kexec to honor
+	 * possible 'mem' and 'memmap' kernel command lines.
+	 */
+	e820_for_each_mem(e820_table, i, start, end) {
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
@@ -607,8 +747,16 @@ static void free_tdmrs(struct tdmr_info **tdmr_array, int tdmr_num)
 
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
2.33.1

