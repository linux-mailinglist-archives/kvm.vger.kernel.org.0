Return-Path: <kvm+bounces-46395-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 03945AB5DE8
	for <lists+kvm@lfdr.de>; Tue, 13 May 2025 22:41:39 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id ECD794C110D
	for <lists+kvm@lfdr.de>; Tue, 13 May 2025 20:40:38 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8D21E2C3743;
	Tue, 13 May 2025 20:38:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="SlMflK2O"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 522B62C1799;
	Tue, 13 May 2025 20:38:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.14
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747168685; cv=none; b=iEHKxiJs3nV1ZyGWOocopTdBCrDlbft1bQf8TGzZD+YVdnDdRch1mMMvzsCcW5/QuQAX22e90VR08oe5+jHtnJTFZCg6QmKN9nCn4QDXnhfrsR8Xu8Dg8RasseimFuNeLRCtuWvg3sbygsN0Hg9E18Ts5IowvZx3bx36Cp6DuEg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747168685; c=relaxed/simple;
	bh=agLNp8oAxzQaWYhjfHFlOBrApju2Hbb0chhD8+zYEOA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=E9duIGLx0Fj6biFNhDDuBBV4lNeLNdy0IW9Q5v9w6gszlPp9jzFgYSd/l6rEjG8bbMnaqIMDeb1DUBt/iRZx5KQWZUZu76iVeuPfWKjKUC5L5mkGLEXIPu7ZOPhoM5AeJlH2tjLNIErYPDyL1Lm9ixeYtlQRt5Kj8/Xwb/fCEt0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=SlMflK2O; arc=none smtp.client-ip=192.198.163.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1747168683; x=1778704683;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=agLNp8oAxzQaWYhjfHFlOBrApju2Hbb0chhD8+zYEOA=;
  b=SlMflK2Ozr16aF5H5ehYlRXNlpcUmvALZCqGgA13XyBw7BpNk+2COTp8
   pSaOxDQ1JcXidMDw4sQGHKQdTSmkoGrPqfHalPqcKy/G2XhircdVErQQH
   ZW7inRo2Fs6wZfwCVi/dSklMdbW3TUq3YzRAUQblr4cNnOYtuQgUZanr/
   wfpC4e9MsBrj4acQnGzL7aXvDH4nv8e3gogyuzCH6Y6cKoupR98dcb+qk
   l3TEwI7sK0TT8sFMXZ9sDstSKugozphKbE/ShCxwm8gFm1UquWnousGHN
   RbQStn5lYbOr5lkKsFHiGdmg27SA65Z7CC3sirJL9am3YaP1N+tiYpIQK
   A==;
X-CSE-ConnectionGUID: V2wVW8IIT1yC6ehFsK5WXg==
X-CSE-MsgGUID: +Dc6+vhnR8yIvD6SqIYo6g==
X-IronPort-AV: E=McAfee;i="6700,10204,11432"; a="49160486"
X-IronPort-AV: E=Sophos;i="6.15,286,1739865600"; 
   d="scan'208";a="49160486"
Received: from fmviesa008.fm.intel.com ([10.60.135.148])
  by fmvoesa108.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 May 2025 13:38:00 -0700
X-CSE-ConnectionGUID: UCq+j34SQnyxy4tBG8PDfQ==
X-CSE-MsgGUID: VT1VdeJ9T1Sfv0wsLdaadw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.15,286,1739865600"; 
   d="scan'208";a="138241737"
Received: from sohilmeh.sc.intel.com ([172.25.103.65])
  by fmviesa008.fm.intel.com with ESMTP; 13 May 2025 13:37:59 -0700
From: Sohil Mehta <sohil.mehta@intel.com>
To: x86@kernel.org,
	linux-kernel@vger.kernel.org
Cc: Xin Li <xin@zytor.com>,
	"H . Peter Anvin" <hpa@zytor.com>,
	Andy Lutomirski <luto@kernel.org>,
	Thomas Gleixner <tglx@linutronix.de>,
	Ingo Molnar <mingo@redhat.com>,
	Borislav Petkov <bp@alien8.de>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	Peter Zijlstra <peterz@infradead.org>,
	Sean Christopherson <seanjc@google.com>,
	Adrian Hunter <adrian.hunter@intel.com>,
	Kan Liang <kan.liang@linux.intel.com>,
	Tony Luck <tony.luck@intel.com>,
	Zhang Rui <rui.zhang@intel.com>,
	Steven Rostedt <rostedt@goodmis.org>,
	Sohil Mehta <sohil.mehta@intel.com>,
	Andrew Cooper <andrew.cooper3@citrix.com>,
	"Kirill A . Shutemov" <kirill.shutemov@linux.intel.com>,
	Jacob Pan <jacob.pan@linux.microsoft.com>,
	Andi Kleen <ak@linux.intel.com>,
	Kai Huang <kai.huang@intel.com>,
	Sandipan Das <sandipan.das@amd.com>,
	linux-perf-users@vger.kernel.org,
	linux-edac@vger.kernel.org,
	kvm@vger.kernel.org,
	linux-pm@vger.kernel.org,
	linux-trace-kernel@vger.kernel.org
Subject: [PATCH v6 8/9] perf/x86: Enable NMI-source reporting for perfmon
Date: Tue, 13 May 2025 13:38:02 -0700
Message-ID: <20250513203803.2636561-9-sohil.mehta@intel.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20250513203803.2636561-1-sohil.mehta@intel.com>
References: <20250513203803.2636561-1-sohil.mehta@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Jacob Pan <jacob.jun.pan@linux.intel.com>

Program the designated PMI NMI-source vector into the local vector table
for the PMU. An NMI for the PMU would directly invoke the PMI handler
without polling other NMI handlers, resulting in reduced PMI delivery
latency.

Co-developed-by: Zeng Guang <guang.zeng@intel.com>
Signed-off-by: Zeng Guang <guang.zeng@intel.com>
Signed-off-by: Jacob Pan <jacob.jun.pan@linux.intel.com>
Signed-off-by: Sohil Mehta <sohil.mehta@intel.com>
Reviewed-by: Kan Liang <kan.liang@linux.intel.com>
Tested-by: Sandipan Das <sandipan.das@amd.com> # AMD overlapping bits
---
v6: Picked up a tested-by tag.

v5: No significant change.
---
 arch/x86/events/core.c       | 4 ++--
 arch/x86/events/intel/core.c | 6 +++---
 arch/x86/include/asm/apic.h  | 1 +
 3 files changed, 6 insertions(+), 5 deletions(-)

diff --git a/arch/x86/events/core.c b/arch/x86/events/core.c
index 031e908f0d61..42b270526631 100644
--- a/arch/x86/events/core.c
+++ b/arch/x86/events/core.c
@@ -1695,7 +1695,7 @@ int x86_pmu_handle_irq(struct pt_regs *regs)
 	 * This generic handler doesn't seem to have any issues where the
 	 * unmasking occurs so it was left at the top.
 	 */
-	apic_write(APIC_LVTPC, APIC_DM_NMI);
+	apic_write(APIC_LVTPC, PERF_NMI);
 
 	for_each_set_bit(idx, x86_pmu.cntr_mask, X86_PMC_IDX_MAX) {
 		if (!test_bit(idx, cpuc->active_mask))
@@ -1737,7 +1737,7 @@ void perf_events_lapic_init(void)
 	/*
 	 * Always use NMI for PMU
 	 */
-	apic_write(APIC_LVTPC, APIC_DM_NMI);
+	apic_write(APIC_LVTPC, PERF_NMI);
 }
 
 static int
diff --git a/arch/x86/events/intel/core.c b/arch/x86/events/intel/core.c
index 09d2d66c9f21..87c624686c58 100644
--- a/arch/x86/events/intel/core.c
+++ b/arch/x86/events/intel/core.c
@@ -3202,7 +3202,7 @@ static int intel_pmu_handle_irq(struct pt_regs *regs)
 	 * NMI handler.
 	 */
 	if (!late_ack && !mid_ack)
-		apic_write(APIC_LVTPC, APIC_DM_NMI);
+		apic_write(APIC_LVTPC, PERF_NMI);
 	intel_bts_disable_local();
 	cpuc->enabled = 0;
 	__intel_pmu_disable_all(true);
@@ -3239,7 +3239,7 @@ static int intel_pmu_handle_irq(struct pt_regs *regs)
 
 done:
 	if (mid_ack)
-		apic_write(APIC_LVTPC, APIC_DM_NMI);
+		apic_write(APIC_LVTPC, PERF_NMI);
 	/* Only restore PMU state when it's active. See x86_pmu_disable(). */
 	cpuc->enabled = pmu_enabled;
 	if (pmu_enabled)
@@ -3252,7 +3252,7 @@ static int intel_pmu_handle_irq(struct pt_regs *regs)
 	 * Haswell CPUs.
 	 */
 	if (late_ack)
-		apic_write(APIC_LVTPC, APIC_DM_NMI);
+		apic_write(APIC_LVTPC, PERF_NMI);
 	return handled;
 }
 
diff --git a/arch/x86/include/asm/apic.h b/arch/x86/include/asm/apic.h
index 99033bfb26ea..d637717d42bd 100644
--- a/arch/x86/include/asm/apic.h
+++ b/arch/x86/include/asm/apic.h
@@ -30,6 +30,7 @@
 #define BT_NMI			(APIC_DM_NMI | NMIS_VECTOR_BT)
 #define KGDB_NMI		(APIC_DM_NMI | NMIS_VECTOR_KGDB)
 #define MCE_NMI			(APIC_DM_NMI | NMIS_VECTOR_MCE)
+#define PERF_NMI		(APIC_DM_NMI | NMIS_VECTOR_PMI)
 
 /*
  * Debugging macros
-- 
2.43.0


