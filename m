Return-Path: <kvm+bounces-9674-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 9AB09866CAE
	for <lists+kvm@lfdr.de>; Mon, 26 Feb 2024 09:43:59 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 39C8E1F24D91
	for <lists+kvm@lfdr.de>; Mon, 26 Feb 2024 08:43:59 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3DFD05FEF6;
	Mon, 26 Feb 2024 08:28:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="XhTRymRZ"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.13])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 247BC5F848;
	Mon, 26 Feb 2024 08:28:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.13
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708936098; cv=none; b=usiRSGURtuOW3xpxprppGNarNfIp7aH2WQKB2xtFdXCxRaP5mH3EW1sR0QnU9ewAaN0kq3DySczn0loQ65e9s5reWwxu8bbQYb/QiMYLCuazCtvo0dlTAsoIgkF9+fsxGn59xRucNtpGj3yqBPtDN2TidCSML8FOH03/sq7PicU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708936098; c=relaxed/simple;
	bh=ZLlfjMU1TFlONfmUGruGN81Gisxxqe67EafNn/XTWPg=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=YuneVuffTYYLbw7rsr9xm1y0+sCwcUF5nP66leJ5mu/GQDPq7p5WFdq+19m2TG+DNs8Gn54p9pZlNGYvC4j/EBg2KKV3Sk5s6T7b3OBgxtw/WWcmaqwdO7ZH7rHarhmSA3YlNUkeVwOD2GMu/Ml7619p5hRO4nQZiJfL3o84XJ4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=XhTRymRZ; arc=none smtp.client-ip=192.198.163.13
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1708936096; x=1740472096;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=ZLlfjMU1TFlONfmUGruGN81Gisxxqe67EafNn/XTWPg=;
  b=XhTRymRZwWxAuU5gF4S3s7EB13n59eeAt6SUFajNzrxvOEK/+ECkOfTu
   c6gpw45eaJev/YJMD2GoZ75MZ1mj0zHyT4Nq//DaKfM/2rp8lWxdv5mPL
   QkhEf3KIu2ZTzLIYRMm6FUi+k3N1qFYlWEXCaCbSOH56PsWqfkjA0m4X0
   +5hbJ3sdI+/stx2IUHOjFGDEYOmC1eDupEB4f9JjNHJRy0TZn9HHCTKhe
   PHL2oPBkfnLT34wUwoSiAKvM1jSI365j4CTNf2WqFVIzTOBBpZBUSmuFi
   7D9oqgzPo/JPaEByBupZIqouIQ9q7olQzpeY4b/c3aI/4U02P343LjAY9
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10995"; a="6155378"
X-IronPort-AV: E=Sophos;i="6.06,185,1705392000"; 
   d="scan'208";a="6155378"
Received: from orviesa009.jf.intel.com ([10.64.159.149])
  by fmvoesa107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Feb 2024 00:28:11 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.06,185,1705392000"; 
   d="scan'208";a="6615804"
Received: from ls.sc.intel.com (HELO localhost) ([172.25.112.31])
  by orviesa009-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Feb 2024 00:28:11 -0800
From: isaku.yamahata@intel.com
To: kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org
Cc: isaku.yamahata@intel.com,
	isaku.yamahata@gmail.com,
	Paolo Bonzini <pbonzini@redhat.com>,
	erdemaktas@google.com,
	Sean Christopherson <seanjc@google.com>,
	Sagi Shahar <sagis@google.com>,
	Kai Huang <kai.huang@intel.com>,
	chen.bo@intel.com,
	hang.yuan@intel.com,
	tina.zhang@intel.com,
	Sean Christopherson <sean.j.christopherson@intel.com>,
	Binbin Wu <binbin.wu@linux.intel.com>
Subject: [PATCH v19 050/130] KVM: x86/mmu: Allow non-zero value for non-present SPTE and removed SPTE
Date: Mon, 26 Feb 2024 00:25:52 -0800
Message-Id: <e125f0e3277c7cfe37b4ba9219fb7562c3979546.1708933498.git.isaku.yamahata@intel.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <cover.1708933498.git.isaku.yamahata@intel.com>
References: <cover.1708933498.git.isaku.yamahata@intel.com>
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
the #VE instead of EPT misconfiguration unlike VMX case.  For the shared
GPA that is not populated yet, EPT violation need to be triggered when TD
guest accesses such shared GPA.  The non-present SPTE value for shared GPA
should set "suppress #VE" bit.

Add "suppress #VE" bit (bit 63) to SHADOW_NONPRESENT_VALUE and
REMOVED_SPTE.  Unconditionally set the "suppress #VE" bit (which is bit 63)
for both AMD and Intel as: 1) AMD hardware doesn't use this bit when
present bit is off; 2) for normal VMX guest, KVM never enables the
"EPT-violation #VE" in VMCS control and "suppress #VE" bit is ignored by
hardware.

Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
Reviewed-by: Binbin Wu <binbin.wu@linux.intel.com>

---
v19:
- fix typo in the commit message

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


