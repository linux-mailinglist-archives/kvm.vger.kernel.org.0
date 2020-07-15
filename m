Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 032F22203F8
	for <lists+kvm@lfdr.de>; Wed, 15 Jul 2020 06:28:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728265AbgGOE2D (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 15 Jul 2020 00:28:03 -0400
Received: from mga05.intel.com ([192.55.52.43]:59540 "EHLO mga05.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726780AbgGOE12 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 15 Jul 2020 00:27:28 -0400
IronPort-SDR: H7eK1RSY1BZZagiC3h5/Jpbj99JPH4F+JQ1xlgzJPe1VHK17CcR2xgKjgSqv49tRg/JOYe9gXt
 MalkdKGVNosQ==
X-IronPort-AV: E=McAfee;i="6000,8403,9682"; a="233936297"
X-IronPort-AV: E=Sophos;i="5.75,354,1589266800"; 
   d="scan'208";a="233936297"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Jul 2020 21:27:27 -0700
IronPort-SDR: 4b5FfUz1z2vyggpQuTzBGG5pbJLZUer9B/ILHKL5vCY3QJpNVVrpJSUEeZKkF663KHcIJbdQ+S
 41dbgY74ibTg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.75,354,1589266800"; 
   d="scan'208";a="308118786"
Received: from sjchrist-coffee.jf.intel.com ([10.54.74.152])
  by fmsmga004.fm.intel.com with ESMTP; 14 Jul 2020 21:27:26 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <sean.j.christopherson@intel.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Junaid Shahid <junaids@google.com>
Subject: [PATCH 4/8] KVM: x86/mmu: Capture requested page level before NX huge page workaround
Date:   Tue, 14 Jul 2020 21:27:21 -0700
Message-Id: <20200715042725.10961-5-sean.j.christopherson@intel.com>
X-Mailer: git-send-email 2.26.0
In-Reply-To: <20200715042725.10961-1-sean.j.christopherson@intel.com>
References: <20200715042725.10961-1-sean.j.christopherson@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Apply the "huge page disallowed" adjustment of the max level only after
capturing the original requested level.  The requested level will be
used in a future patch to skip adding pages to the list of disallowed
huge pages if a huge page wasn't possible anyways, e.g. if the page
isn't mapped as a huge page in the host.

No functional change intended.

Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
---
 arch/x86/kvm/mmu/mmu.c         | 22 +++++++++++++++-------
 arch/x86/kvm/mmu/paging_tmpl.h |  8 +++-----
 2 files changed, 18 insertions(+), 12 deletions(-)

diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index bbd7e8be2b936..974c9a89c2454 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -3238,7 +3238,8 @@ static int host_pfn_mapping_level(struct kvm_vcpu *vcpu, gfn_t gfn,
 }
 
 static int kvm_mmu_hugepage_adjust(struct kvm_vcpu *vcpu, gfn_t gfn,
-				   int max_level, kvm_pfn_t *pfnp)
+				   int max_level, kvm_pfn_t *pfnp,
+				   bool huge_page_disallowed, int *req_level)
 {
 	struct kvm_memory_slot *slot;
 	struct kvm_lpage_info *linfo;
@@ -3246,6 +3247,8 @@ static int kvm_mmu_hugepage_adjust(struct kvm_vcpu *vcpu, gfn_t gfn,
 	kvm_pfn_t mask;
 	int level;
 
+	*req_level = PG_LEVEL_4K;
+
 	if (unlikely(max_level == PG_LEVEL_4K))
 		return PG_LEVEL_4K;
 
@@ -3270,7 +3273,14 @@ static int kvm_mmu_hugepage_adjust(struct kvm_vcpu *vcpu, gfn_t gfn,
 	if (level == PG_LEVEL_4K)
 		return level;
 
-	level = min(level, max_level);
+	*req_level = level = min(level, max_level);
+
+	/*
+	 * Enforce the iTLB multihit workaround after capturing the requested
+	 * level, which will be used to do precise, accurate accounting.
+	 */
+	if (huge_page_disallowed)
+		return PG_LEVEL_4K;
 
 	/*
 	 * mmu_notifier_retry() was successful and mmu_lock is held, so
@@ -3316,17 +3326,15 @@ static int __direct_map(struct kvm_vcpu *vcpu, gpa_t gpa, u32 error_code,
 	bool huge_page_disallowed = exec && nx_huge_page_workaround_enabled;
 	struct kvm_shadow_walk_iterator it;
 	struct kvm_mmu_page *sp;
-	int level, ret;
+	int level, req_level, ret;
 	gfn_t gfn = gpa >> PAGE_SHIFT;
 	gfn_t base_gfn = gfn;
 
 	if (WARN_ON(!VALID_PAGE(vcpu->arch.mmu->root_hpa)))
 		return RET_PF_RETRY;
 
-	if (huge_page_disallowed)
-		max_level = PG_LEVEL_4K;
-
-	level = kvm_mmu_hugepage_adjust(vcpu, gfn, max_level, &pfn);
+	level = kvm_mmu_hugepage_adjust(vcpu, gfn, max_level, &pfn,
+					huge_page_disallowed, &req_level);
 
 	trace_kvm_mmu_spte_requested(gpa, level, pfn);
 	for_each_shadow_entry(vcpu, gpa, it) {
diff --git a/arch/x86/kvm/mmu/paging_tmpl.h b/arch/x86/kvm/mmu/paging_tmpl.h
index 5536b2004dac8..b92d936c0900d 100644
--- a/arch/x86/kvm/mmu/paging_tmpl.h
+++ b/arch/x86/kvm/mmu/paging_tmpl.h
@@ -636,7 +636,7 @@ static int FNAME(fetch)(struct kvm_vcpu *vcpu, gpa_t addr,
 	struct kvm_mmu_page *sp = NULL;
 	struct kvm_shadow_walk_iterator it;
 	unsigned direct_access, access = gw->pt_access;
-	int top_level, hlevel, ret;
+	int top_level, hlevel, req_level, ret;
 	gfn_t base_gfn = gw->gfn;
 
 	direct_access = gw->pte_access;
@@ -682,10 +682,8 @@ static int FNAME(fetch)(struct kvm_vcpu *vcpu, gpa_t addr,
 			link_shadow_page(vcpu, it.sptep, sp);
 	}
 
-	if (huge_page_disallowed)
-		max_level = PG_LEVEL_4K;
-
-	hlevel = kvm_mmu_hugepage_adjust(vcpu, gw->gfn, max_level, &pfn);
+	hlevel = kvm_mmu_hugepage_adjust(vcpu, gw->gfn, max_level, &pfn,
+					 huge_page_disallowed, &req_level);
 
 	trace_kvm_mmu_spte_requested(addr, gw->level, pfn);
 
-- 
2.26.0

