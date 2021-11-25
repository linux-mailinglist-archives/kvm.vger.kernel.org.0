Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3936A45D1AF
	for <lists+kvm@lfdr.de>; Thu, 25 Nov 2021 01:24:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353251AbhKYAYx (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 24 Nov 2021 19:24:53 -0500
Received: from mga12.intel.com ([192.55.52.136]:16249 "EHLO mga12.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1352952AbhKYAY0 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 24 Nov 2021 19:24:26 -0500
X-IronPort-AV: E=McAfee;i="6200,9189,10178"; a="215432204"
X-IronPort-AV: E=Sophos;i="5.87,261,1631602800"; 
   d="scan'208";a="215432204"
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Nov 2021 16:21:15 -0800
X-IronPort-AV: E=Sophos;i="5.87,261,1631602800"; 
   d="scan'208";a="675042235"
Received: from ls.sc.intel.com (HELO localhost) ([143.183.96.54])
  by orsmga005-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Nov 2021 16:21:15 -0800
From:   isaku.yamahata@intel.com
To:     Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        "H . Peter Anvin" <hpa@zytor.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, erdemaktas@google.com,
        Connor Kuehl <ckuehl@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     isaku.yamahata@intel.com, isaku.yamahata@gmail.com,
        Sean Christopherson <sean.j.christopherson@intel.com>
Subject: [RFC PATCH v3 33/59] KVM: x86/mmu: Ignore bits 63 and 62 when checking for "present" SPTEs
Date:   Wed, 24 Nov 2021 16:20:16 -0800
Message-Id: <93d466c4850603ea73703a3a39f82e9f3cba5cc5.1637799475.git.isaku.yamahata@intel.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <cover.1637799475.git.isaku.yamahata@intel.com>
References: <cover.1637799475.git.isaku.yamahata@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Sean Christopherson <sean.j.christopherson@intel.com>

Ignore bits 63 and 62 when checking for present SPTEs to allow setting
said bits in not-present SPTEs.  TDX will set bit 63 in "zero" SPTEs to
suppress #VEs (TDX-SEAM unconditionally enables EPT Violation #VE), and
will use bit 62 to track zapped private SPTEs.

Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
---
 arch/x86/kvm/mmu/paging_tmpl.h |  2 +-
 arch/x86/kvm/mmu/spte.h        | 13 +++++++++++++
 2 files changed, 14 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kvm/mmu/paging_tmpl.h b/arch/x86/kvm/mmu/paging_tmpl.h
index 3a515c71e09c..80e821996728 100644
--- a/arch/x86/kvm/mmu/paging_tmpl.h
+++ b/arch/x86/kvm/mmu/paging_tmpl.h
@@ -1102,7 +1102,7 @@ static int FNAME(sync_page)(struct kvm_vcpu *vcpu, struct kvm_mmu_page *sp)
 		gpa_t pte_gpa;
 		gfn_t gfn;
 
-		if (!sp->spt[i])
+		if (!__is_shadow_present_pte(sp->spt[i]))
 			continue;
 
 		pte_gpa = first_pte_gpa + i * sizeof(pt_element_t);
diff --git a/arch/x86/kvm/mmu/spte.h b/arch/x86/kvm/mmu/spte.h
index cc432f9a966b..56b6dd750fb1 100644
--- a/arch/x86/kvm/mmu/spte.h
+++ b/arch/x86/kvm/mmu/spte.h
@@ -208,6 +208,19 @@ static inline bool is_mmio_spte(u64 spte)
 	       likely(shadow_mmio_value);
 }
 
+static inline bool __is_shadow_present_pte(u64 pte)
+{
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
 static inline bool is_shadow_present_pte(u64 pte)
 {
 	return !!(pte & SPTE_MMU_PRESENT_MASK);
-- 
2.25.1

