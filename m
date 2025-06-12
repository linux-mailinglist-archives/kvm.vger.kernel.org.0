Return-Path: <kvm+bounces-49331-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 81B0EAD7DE7
	for <lists+kvm@lfdr.de>; Thu, 12 Jun 2025 23:53:29 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 77BEC7A2A0C
	for <lists+kvm@lfdr.de>; Thu, 12 Jun 2025 21:52:05 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0F2792E7647;
	Thu, 12 Jun 2025 21:50:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="gwQkh9QX"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 525672E612D;
	Thu, 12 Jun 2025 21:50:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.14
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749765037; cv=none; b=VSrAz2glgFlHipXvTLNjz7Yu1YEOoBLsLRzG9vp0iLRpSrOL00Msue2Hax4ADfcjVKMomKbZf3fCRpG6B0wAF+35+4K6H4nJXQy+y8IhHcFrIsZHo5arwodmVYt6ueYq7qsC4JK20abBoNDdxz9+XBgZqUHsgrH1XTcvUGuXU94=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749765037; c=relaxed/simple;
	bh=0yJO8+t59kyXCqaGy07bQzCzjDip1tbJbjX7B+1zjMs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UXo4mMtoz6t4/mBh24VJqV8TtFHKhgZOJkQb4lOyJIK3BCvfpyhw+VwMZFw2pXvUwRXprZM4rpdIjPeUNBHkQCndyxdZOzlavHTYAl5qaSowDOAbDjV2SZcvV56DxFIO5DkYzWT5CZ0Wi4PRIdEmkjqJCI5D1pSl3ARWJNqLWVM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=gwQkh9QX; arc=none smtp.client-ip=192.198.163.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1749765035; x=1781301035;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=0yJO8+t59kyXCqaGy07bQzCzjDip1tbJbjX7B+1zjMs=;
  b=gwQkh9QXF5veqFEGK+k3JyRi1l+0f8UqyiWXk5b7BwQhGKipIeYRl5wn
   ua5g6zqp9q2s1aN/2uMSiDqFwvE/pkLW2RZYxPYpJh7fx2iJn/NaErbmO
   s9YuzVRZL7M/ISU9rxxeo2SGJhTKGnzM8tJNd6AuxBMLFEtANxecahgEt
   dj0JDBSMO7YbLpArn0tWAwnuFoFZzp10OvLy2dIP6uoScxFF3ZrN0H96M
   iKgVVUvw0Qkha8wX83BQVsrL/RGAuDm7aIs9UgYVQf+WBfMnfkJS0J0UE
   IobNbMxSWU2hp9u0zTlg3qZb5NzQgtTPkzf1qfvBPNO3ifyPRY+95ZYDP
   Q==;
X-CSE-ConnectionGUID: LwkZftrJR3aNuUUjdotWng==
X-CSE-MsgGUID: R1ElUbUHSrOnaTWAydoLgQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11462"; a="52065400"
X-IronPort-AV: E=Sophos;i="6.16,231,1744095600"; 
   d="scan'208";a="52065400"
Received: from orviesa001.jf.intel.com ([10.64.159.141])
  by fmvoesa108.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Jun 2025 14:50:35 -0700
X-CSE-ConnectionGUID: Icu8J/9VSGWuSuzQVlWxaQ==
X-CSE-MsgGUID: SFH2AFFXSDyjnoZ73RK4QQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.16,231,1744095600"; 
   d="scan'208";a="184881999"
Received: from sohilmeh.sc.intel.com ([172.25.103.65])
  by orviesa001.jf.intel.com with ESMTP; 12 Jun 2025 14:50:34 -0700
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
Subject: [PATCH v7 09/10] perf/x86: Enable NMI-source reporting for perfmon
Date: Thu, 12 Jun 2025 14:48:48 -0700
Message-ID: <20250612214849.3950094-10-sohil.mehta@intel.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20250612214849.3950094-1-sohil.mehta@intel.com>
References: <20250612214849.3950094-1-sohil.mehta@intel.com>
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
Tested-by: Sandipan Das <sandipan.das@amd.com> # AMD overlapping bits
Reviewed-by: Kan Liang <kan.liang@linux.intel.com>
Reviewed-by: Xin Li (Intel) <xin@zytor.com>
---
v7: Pick up a review tag (Xin).

v6: Pick up a tested-by tag (Sandipan).

v5: No significant change.
---
 arch/x86/events/core.c       | 4 ++--
 arch/x86/events/intel/core.c | 6 +++---
 arch/x86/include/asm/apic.h  | 1 +
 3 files changed, 6 insertions(+), 5 deletions(-)

diff --git a/arch/x86/events/core.c b/arch/x86/events/core.c
index dd42fe7bce9c..3336609288b0 100644
--- a/arch/x86/events/core.c
+++ b/arch/x86/events/core.c
@@ -1704,7 +1704,7 @@ int x86_pmu_handle_irq(struct pt_regs *regs)
 	 * This generic handler doesn't seem to have any issues where the
 	 * unmasking occurs so it was left at the top.
 	 */
-	apic_write(APIC_LVTPC, APIC_DM_NMI);
+	apic_write(APIC_LVTPC, PERF_NMI);
 
 	for_each_set_bit(idx, x86_pmu.cntr_mask, X86_PMC_IDX_MAX) {
 		if (!test_bit(idx, cpuc->active_mask))
@@ -1746,7 +1746,7 @@ void perf_events_lapic_init(void)
 	/*
 	 * Always use NMI for PMU
 	 */
-	apic_write(APIC_LVTPC, APIC_DM_NMI);
+	apic_write(APIC_LVTPC, PERF_NMI);
 }
 
 static int
diff --git a/arch/x86/events/intel/core.c b/arch/x86/events/intel/core.c
index 741b229f0718..000d3ab72bd2 100644
--- a/arch/x86/events/intel/core.c
+++ b/arch/x86/events/intel/core.c
@@ -3318,7 +3318,7 @@ static int intel_pmu_handle_irq(struct pt_regs *regs)
 	 * NMI handler.
 	 */
 	if (!late_ack && !mid_ack)
-		apic_write(APIC_LVTPC, APIC_DM_NMI);
+		apic_write(APIC_LVTPC, PERF_NMI);
 	intel_bts_disable_local();
 	cpuc->enabled = 0;
 	__intel_pmu_disable_all(true);
@@ -3355,7 +3355,7 @@ static int intel_pmu_handle_irq(struct pt_regs *regs)
 
 done:
 	if (mid_ack)
-		apic_write(APIC_LVTPC, APIC_DM_NMI);
+		apic_write(APIC_LVTPC, PERF_NMI);
 	/* Only restore PMU state when it's active. See x86_pmu_disable(). */
 	cpuc->enabled = pmu_enabled;
 	if (pmu_enabled)
@@ -3368,7 +3368,7 @@ static int intel_pmu_handle_irq(struct pt_regs *regs)
 	 * Haswell CPUs.
 	 */
 	if (late_ack)
-		apic_write(APIC_LVTPC, APIC_DM_NMI);
+		apic_write(APIC_LVTPC, PERF_NMI);
 	return handled;
 }
 
diff --git a/arch/x86/include/asm/apic.h b/arch/x86/include/asm/apic.h
index 5789df1708bd..7287005f05a6 100644
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


