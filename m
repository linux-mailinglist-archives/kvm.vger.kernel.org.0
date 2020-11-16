Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4D4AF2B4FA8
	for <lists+kvm@lfdr.de>; Mon, 16 Nov 2020 19:34:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388589AbgKPSas (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 16 Nov 2020 13:30:48 -0500
Received: from mga06.intel.com ([134.134.136.31]:20645 "EHLO mga06.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388229AbgKPS2K (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 16 Nov 2020 13:28:10 -0500
IronPort-SDR: YL/rgSuRDWEANztkCs2RMvtR3U4OO0Ing6QQIK3RFzq/QgrW0mlWqHzefqoHnhdekJhUVRhA3a
 ch3DfDvm2+wg==
X-IronPort-AV: E=McAfee;i="6000,8403,9807"; a="232410052"
X-IronPort-AV: E=Sophos;i="5.77,483,1596524400"; 
   d="scan'208";a="232410052"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Nov 2020 10:28:09 -0800
IronPort-SDR: XDNgKlubACap/YjCiy30MO5c7BvGj9iaXY7uhsLE1kPts++UzGrhS27GqeyeIbE7E8WcHIw1g/
 hXMG8di6Ouxg==
X-IronPort-AV: E=Sophos;i="5.77,483,1596524400"; 
   d="scan'208";a="400528130"
Received: from ls.sc.intel.com (HELO localhost) ([143.183.96.54])
  by orsmga001-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Nov 2020 10:28:09 -0800
From:   isaku.yamahata@intel.com
To:     Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        "H . Peter Anvin" <hpa@zytor.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, x86@kernel.org,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     isaku.yamahata@intel.com, isaku.yamahata@gmail.com,
        Sean Christopherson <sean.j.christopherson@intel.com>
Subject: [RFC PATCH 37/67] KVM: x86/mmu: Ignore bits 63 and 62 when checking for "present" SPTEs
Date:   Mon, 16 Nov 2020 10:26:22 -0800
Message-Id: <7ca4ebee9566d6fb5ecdbffd32468a6b756ab515.1605232743.git.isaku.yamahata@intel.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <cover.1605232743.git.isaku.yamahata@intel.com>
References: <cover.1605232743.git.isaku.yamahata@intel.com>
In-Reply-To: <cover.1605232743.git.isaku.yamahata@intel.com>
References: <cover.1605232743.git.isaku.yamahata@intel.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Sean Christopherson <sean.j.christopherson@intel.com>

Ignore bits 63 and 62 when checking for present SPTEs to allow setting
said bits in not-present SPTEs.  TDX will set bit 63 in "zero" SPTEs to
suppress #VEs (TDX-SEAM unconditionally enables EPT Violation #VE), and
will use bit 62 to track zapped private SPTEs.

Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
---
 arch/x86/kvm/mmu/paging_tmpl.h |  2 +-
 arch/x86/kvm/mmu/spte.h        | 17 +++++++++++++++--
 2 files changed, 16 insertions(+), 3 deletions(-)

diff --git a/arch/x86/kvm/mmu/paging_tmpl.h b/arch/x86/kvm/mmu/paging_tmpl.h
index 5d4e9f404018..06659d5c8ba0 100644
--- a/arch/x86/kvm/mmu/paging_tmpl.h
+++ b/arch/x86/kvm/mmu/paging_tmpl.h
@@ -1039,7 +1039,7 @@ static int FNAME(sync_page)(struct kvm_vcpu *vcpu, struct kvm_mmu_page *sp)
 		gpa_t pte_gpa;
 		gfn_t gfn;
 
-		if (!sp->spt[i])
+		if (!__is_shadow_present_pte(sp->spt[i]))
 			continue;
 
 		pte_gpa = first_pte_gpa + i * sizeof(pt_element_t);
diff --git a/arch/x86/kvm/mmu/spte.h b/arch/x86/kvm/mmu/spte.h
index e5c94848ade1..22256cc8cce6 100644
--- a/arch/x86/kvm/mmu/spte.h
+++ b/arch/x86/kvm/mmu/spte.h
@@ -174,9 +174,22 @@ static inline bool is_access_track_spte(u64 spte)
 	return !spte_ad_enabled(spte) && (spte & shadow_acc_track_mask) == 0;
 }
 
-static inline int is_shadow_present_pte(u64 pte)
+static inline bool __is_shadow_present_pte(u64 pte)
 {
-	return (pte != 0) && !is_mmio_spte(pte);
+	/*
+	 * Ignore bits 63 and 62 so that they can be set in SPTEs that are well
+	 * and truly not present.  We can't use the sane/obvious approach of
+	 * querying bits 2:0 (RWX or P) because EPT without A/D bits will clear
+	 * RWX of a "present" SPTE to do access tracking.  Tracking updates can
+	 * be done out of mmu_lock, so even the flushing logic needs to treat
+	 * such SPTEs as present.
+	 */
+	return !!(pte << 2);
+}
+
+static inline bool is_shadow_present_pte(u64 pte)
+{
+	return __is_shadow_present_pte(pte) && !is_mmio_spte(pte);
 }
 
 static inline int is_large_pte(u64 pte)
-- 
2.17.1

