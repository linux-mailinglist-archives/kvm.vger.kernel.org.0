Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AAD9E4A3E29
	for <lists+kvm@lfdr.de>; Mon, 31 Jan 2022 08:25:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1357905AbiAaHZF (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 31 Jan 2022 02:25:05 -0500
Received: from mga03.intel.com ([134.134.136.65]:60936 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1357900AbiAaHZE (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 31 Jan 2022 02:25:04 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1643613904; x=1675149904;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=ZDpKgrbbd68DiL0edOPoBO+KnowsRpPIffYdKIWMdTs=;
  b=fY7QXN+cdkp6P3fpl2xHxDKqSS+m45umM7dqMx971QlH4G6O9FqKbKI5
   thlrweiBI5LfuWmhXf2P+0MZMrXPbgRZlIk6a0TZzqAci037UZgvqqJHr
   83OG9im+db2fD5KZ/Y9nhNGhKkXQKk+7hyo7ztgm9dCsjBpIdliL2Yc5Y
   ugtrEs97DpLtZNCMztQSfEeXROs6P3lhzwOoujb2cUs9RcBFFe7cWzL0N
   gSfMPsTuAYqBv5gt4XAVPvj1JkVBuMBZaQs3NjPu2jFkoCB+16QzemgdF
   G3/yX0f5DPZOaEuFrhPbzj+SO2qM0U3383xBKUo7WEdXyL4KhtieLvssj
   g==;
X-IronPort-AV: E=McAfee;i="6200,9189,10243"; a="247367026"
X-IronPort-AV: E=Sophos;i="5.88,330,1635231600"; 
   d="scan'208";a="247367026"
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Jan 2022 23:25:03 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.88,330,1635231600"; 
   d="scan'208";a="768515179"
Received: from ahunter-desktop.fi.intel.com ([10.237.72.92])
  by fmsmga006.fm.intel.com with ESMTP; 30 Jan 2022 23:24:59 -0800
From:   Adrian Hunter <adrian.hunter@intel.com>
To:     Peter Zijlstra <peterz@infradead.org>,
        Alexander Shishkin <alexander.shishkin@linux.intel.com>
Cc:     Arnaldo Carvalho de Melo <acme@kernel.org>,
        Jiri Olsa <jolsa@redhat.com>, linux-kernel@vger.kernel.org,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org,
        kvm@vger.kernel.org, H Peter Anvin <hpa@zytor.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Mathieu Poirier <mathieu.poirier@linaro.org>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Leo Yan <leo.yan@linaro.org>
Subject: [PATCH 1/5] perf/x86/intel/pt: Relax address filter validation
Date:   Mon, 31 Jan 2022 09:24:49 +0200
Message-Id: <20220131072453.2839535-2-adrian.hunter@intel.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220131072453.2839535-1-adrian.hunter@intel.com>
References: <20220131072453.2839535-1-adrian.hunter@intel.com>
MIME-Version: 1.0
Organization: Intel Finland Oy, Registered Address: PL 281, 00181 Helsinki, Business Identity Code: 0357606 - 4, Domiciled in Helsinki
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The requirement for 64-bit address filters is that they are canonical
addresses. In other respects any address range is allowed which would
include user space addresses.

That can be useful for tracing virtual machine guests because address
filtering can be used to advantage in place of current privilege level
(CPL) filtering.

Signed-off-by: Adrian Hunter <adrian.hunter@intel.com>
---
 arch/x86/events/intel/pt.c | 63 ++++++++++++++++++++++++++++++--------
 1 file changed, 50 insertions(+), 13 deletions(-)

diff --git a/arch/x86/events/intel/pt.c b/arch/x86/events/intel/pt.c
index ae396fdfabab..4443de56a2d5 100644
--- a/arch/x86/events/intel/pt.c
+++ b/arch/x86/events/intel/pt.c
@@ -13,6 +13,8 @@
 #define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
 
 #include <linux/types.h>
+#include <linux/bits.h>
+#include <linux/limits.h>
 #include <linux/slab.h>
 #include <linux/device.h>
 
@@ -1363,11 +1365,37 @@ static void pt_addr_filters_fini(struct perf_event *event)
 	event->hw.addr_filters = NULL;
 }
 
-static inline bool valid_kernel_ip(unsigned long ip)
+#ifdef CONFIG_X86_64
+static u64 canonical_address(u64 vaddr, u8 vaddr_bits)
 {
-	return virt_addr_valid(ip) && kernel_ip(ip);
+	return ((s64)vaddr << (64 - vaddr_bits)) >> (64 - vaddr_bits);
 }
 
+static u64 is_canonical_address(u64 vaddr, u8 vaddr_bits)
+{
+	return canonical_address(vaddr, vaddr_bits) == vaddr;
+}
+
+/* Clamp to a canonical address greater-than-or-equal-to the address given */
+static u64 clamp_to_ge_canonical_addr(u64 vaddr, u8 vaddr_bits)
+{
+	return is_canonical_address(vaddr, vaddr_bits) ?
+	       vaddr :
+	       -BIT_ULL(vaddr_bits - 1);
+}
+
+/* Clamp to a canonical address less-than-or-equal-to the address given */
+static u64 clamp_to_le_canonical_addr(u64 vaddr, u8 vaddr_bits)
+{
+	return is_canonical_address(vaddr, vaddr_bits) ?
+	       vaddr :
+	       BIT_ULL(vaddr_bits - 1) - 1;
+}
+#else
+#define clamp_to_ge_canonical_addr(x, y) (x)
+#define clamp_to_le_canonical_addr(x, y) (x)
+#endif
+
 static int pt_event_addr_filters_validate(struct list_head *filters)
 {
 	struct perf_addr_filter *filter;
@@ -1382,14 +1410,6 @@ static int pt_event_addr_filters_validate(struct list_head *filters)
 		    filter->action == PERF_ADDR_FILTER_ACTION_START)
 			return -EOPNOTSUPP;
 
-		if (!filter->path.dentry) {
-			if (!valid_kernel_ip(filter->offset))
-				return -EINVAL;
-
-			if (!valid_kernel_ip(filter->offset + filter->size))
-				return -EINVAL;
-		}
-
 		if (++range > intel_pt_validate_hw_cap(PT_CAP_num_address_ranges))
 			return -EOPNOTSUPP;
 	}
@@ -1413,9 +1433,26 @@ static void pt_event_addr_filters_sync(struct perf_event *event)
 		if (filter->path.dentry && !fr[range].start) {
 			msr_a = msr_b = 0;
 		} else {
-			/* apply the offset */
-			msr_a = fr[range].start;
-			msr_b = msr_a + fr[range].size - 1;
+			unsigned long n = fr[range].size - 1;
+			unsigned long a = fr[range].start;
+			unsigned long b;
+
+			if (a > ULONG_MAX - n)
+				b = ULONG_MAX;
+			else
+				b = a + n;
+			/*
+			 * Apply the offset. 64-bit addresses written to the
+			 * MSRs must be canonical, but the range can encompass
+			 * non-canonical addresses. Since software cannot
+			 * execute at non-canonical addresses, adjusting to
+			 * canonical addresses does not affect the result of the
+			 * address filter.
+			 */
+			msr_a = clamp_to_ge_canonical_addr(a, boot_cpu_data.x86_virt_bits);
+			msr_b = clamp_to_le_canonical_addr(b, boot_cpu_data.x86_virt_bits);
+			if (msr_b < msr_a)
+				msr_a = msr_b = 0;
 		}
 
 		filters->filter[range].msr_a  = msr_a;
-- 
2.25.1

