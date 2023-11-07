Return-Path: <kvm+bounces-926-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 000E87E4275
	for <lists+kvm@lfdr.de>; Tue,  7 Nov 2023 16:00:38 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id ADE0E28176E
	for <lists+kvm@lfdr.de>; Tue,  7 Nov 2023 15:00:37 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2BDE531A60;
	Tue,  7 Nov 2023 14:58:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="VyP4gAtD"
X-Original-To: kvm@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 620F431591
	for <kvm@vger.kernel.org>; Tue,  7 Nov 2023 14:58:42 +0000 (UTC)
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.8])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 41F02130;
	Tue,  7 Nov 2023 06:58:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1699369103; x=1730905103;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=fq9sl/Hvu6AYyJ20Nrfcvuiz9xnZGWqLLJDKXzXZMyU=;
  b=VyP4gAtDV6KEEYQQIs5bCHO775QvK3m0kYMH5s3j6fuy07I68Op5zSpz
   I4oRLwwEiYxMp+XcQFzGmIn/bVJyJyZ+zuaHU2gmJkrH+A8DkvjnM9MC0
   +2XzT/mb7ytuW5sd8OUc7zm+m//9baf0/4BzlxwckSI0/E1ma0OVuLdmt
   eA+BTW9I9DUU/+VttbqI7xa/U4B1tEbZ7f2G0+cU0CF93jtGCwk30sU5+
   dSC+uHF/YTb9xtUIM4zFc2qpUCnbRzYoY78rccjU06PUMqDOswbenbSY8
   tRVMpzsSsrlLcwZr/SWuuB5D1BQcBGpuknfiv/fP/+vnhhFTlA1h86mGy
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10887"; a="2462214"
X-IronPort-AV: E=Sophos;i="6.03,284,1694761200"; 
   d="scan'208";a="2462214"
Received: from fmviesa001.fm.intel.com ([10.60.135.141])
  by fmvoesa102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Nov 2023 06:58:09 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.03,284,1694761200"; 
   d="scan'208";a="10851293"
Received: from ls.sc.intel.com (HELO localhost) ([172.25.112.31])
  by smtpauth.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Nov 2023 06:58:08 -0800
From: isaku.yamahata@intel.com
To: kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org
Cc: isaku.yamahata@intel.com,
	isaku.yamahata@gmail.com,
	Paolo Bonzini <pbonzini@redhat.com>,
	erdemaktas@google.com,
	Sean Christopherson <seanjc@google.com>,
	Sagi Shahar <sagis@google.com>,
	David Matlack <dmatlack@google.com>,
	Kai Huang <kai.huang@intel.com>,
	Zhi Wang <zhi.wang.linux@gmail.com>,
	chen.bo@intel.com,
	hang.yuan@intel.com,
	tina.zhang@intel.com,
	Sean Christopherson <sean.j.christopherson@intel.com>
Subject: [PATCH v17 033/116] KVM: x86/mmu: Allow non-zero value for non-present SPTE and removed SPTE
Date: Tue,  7 Nov 2023 06:55:59 -0800
Message-Id: <1589b7cbcf1d64f2be6729a58cc533452b766943.1699368322.git.isaku.yamahata@intel.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <cover.1699368322.git.isaku.yamahata@intel.com>
References: <cover.1699368322.git.isaku.yamahata@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Sean Christopherson <sean.j.christopherson@intel.com>

For TD guest, the current way to emulate MMIO doesn't work any more, as KVM
is not able to access the private memory of TD guest and do the emulation.
Instead, TD guest expects to receive #VE when it accesses the MMIO and then
it can explicitly make hypercall to KVM to get the expected information.

To achieve this, the TDX module always enables "EPT-violation #VE" in the
VMCS control.  And accordingly, for the MMIO spte for the shared GPA,
1. KVM needs to set "suppress #VE" bit for the non-present SPTE so that EPT
violation happens on TD accessing MMIO range.  2. On EPT violation, KVM
sets the MMIO spte to clear "suppress #VE" bit so the TD guest can receive
the #VE instead of EPT misconfigration unlike VMX case.  For the shared GPA
that is not populated yet, EPT violation need to be triggered when TD guest
accesses such shared GPA.  The non-present SPTE value for shared GPA should
set "suppress #VE" bit.

Add "suppress #VE" bit (bit 63) to SHADOW_NONPRESENT_VALUE and
REMOVED_SPTE.  Unconditionally set the "suppress #VE" bit (which is bit 63)
for both AMD and Intel as: 1) AMD hardware doesn't use this bit when
present bit is off; 2) for normal VMX guest, KVM never enables the
"EPT-violation #VE" in VMCS control and "suppress #VE" bit is ignored by
hardware.

Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
---
 arch/x86/kvm/mmu/spte.h | 15 ++++++++++++++-
 1 file changed, 14 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kvm/mmu/spte.h b/arch/x86/kvm/mmu/spte.h
index 4d1799ba2bf8..26bc95bbc962 100644
--- a/arch/x86/kvm/mmu/spte.h
+++ b/arch/x86/kvm/mmu/spte.h
@@ -149,7 +149,20 @@ static_assert(MMIO_SPTE_GEN_LOW_BITS == 8 && MMIO_SPTE_GEN_HIGH_BITS == 11);
 
 #define MMIO_SPTE_GEN_MASK		GENMASK_ULL(MMIO_SPTE_GEN_LOW_BITS + MMIO_SPTE_GEN_HIGH_BITS - 1, 0)
 
+/*
+ * Non-present SPTE value for both VMX and SVM for TDP MMU.
+ * For SVM NPT, for non-present spte (bit 0 = 0), other bits are ignored.
+ * For VMX EPT, bit 63 is ignored if #VE is disabled. (EPT_VIOLATION_VE=0)
+ *              bit 63 is #VE suppress if #VE is enabled. (EPT_VIOLATION_VE=1)
+ * For TDX:
+ *   TDX module sets EPT_VIOLATION_VE for Secure-EPT and conventional EPT
+ */
+#ifdef CONFIG_X86_64
+#define SHADOW_NONPRESENT_VALUE	BIT_ULL(63)
+static_assert(!(SHADOW_NONPRESENT_VALUE & SPTE_MMU_PRESENT_MASK));
+#else
 #define SHADOW_NONPRESENT_VALUE	0ULL
+#endif
 
 extern u64 __read_mostly shadow_host_writable_mask;
 extern u64 __read_mostly shadow_mmu_writable_mask;
@@ -196,7 +209,7 @@ extern u64 __read_mostly shadow_nonpresent_or_rsvd_mask;
  *
  * Only used by the TDP MMU.
  */
-#define REMOVED_SPTE	0x5a0ULL
+#define REMOVED_SPTE	(SHADOW_NONPRESENT_VALUE | 0x5a0ULL)
 
 /* Removed SPTEs must not be misconstrued as shadow present PTEs. */
 static_assert(!(REMOVED_SPTE & SPTE_MMU_PRESENT_MASK));
-- 
2.25.1


