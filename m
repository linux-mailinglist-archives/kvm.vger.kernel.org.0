Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8EA8B276027
	for <lists+kvm@lfdr.de>; Wed, 23 Sep 2020 20:42:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726820AbgIWSmk (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 23 Sep 2020 14:42:40 -0400
Received: from mga14.intel.com ([192.55.52.115]:9838 "EHLO mga14.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726557AbgIWSmi (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 23 Sep 2020 14:42:38 -0400
IronPort-SDR: Odfo8hEAIVPT7O8rjj09jqPiXZAJj06aNqimokAhTpAYM3tyq5vvj6dRj+rJSr+A7a2YhopGIn
 pi1wI6rjpuIQ==
X-IronPort-AV: E=McAfee;i="6000,8403,9753"; a="160276864"
X-IronPort-AV: E=Sophos;i="5.77,293,1596524400"; 
   d="scan'208";a="160276864"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Sep 2020 11:37:38 -0700
IronPort-SDR: ELiha0Jp1DUTCVmg8mVz13jgEbX+V2HohtuIcjyMTyVRJdbcnFNIEKgbwAJax5HhN1Ngb33Fpw
 n7CvfrZagFXg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.77,293,1596524400"; 
   d="scan'208";a="486561621"
Received: from sjchrist-coffee.jf.intel.com ([10.54.74.160])
  by orsmga005.jf.intel.com with ESMTP; 23 Sep 2020 11:37:37 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <sean.j.christopherson@intel.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Junaid Shahid <junaids@google.com>
Subject: [PATCH v2 4/8] KVM: x86/mmu: Capture requested page level before NX huge page workaround
Date:   Wed, 23 Sep 2020 11:37:31 -0700
Message-Id: <20200923183735.584-5-sean.j.christopherson@intel.com>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200923183735.584-1-sean.j.christopherson@intel.com>
References: <20200923183735.584-1-sean.j.christopherson@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
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
index feb326e79b7b..39bc9bc1ac2f 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -3240,7 +3240,8 @@ static int host_pfn_mapping_level(struct kvm_vcpu *vcpu, gfn_t gfn,
 }
 
 static int kvm_mmu_hugepage_adjust(struct kvm_vcpu *vcpu, gfn_t gfn,
-				   int max_level, kvm_pfn_t *pfnp)
+				   int max_level, kvm_pfn_t *pfnp,
+				   bool huge_page_disallowed, int *req_level)
 {
 	struct kvm_memory_slot *slot;
 	struct kvm_lpage_info *linfo;
@@ -3248,6 +3249,8 @@ static int kvm_mmu_hugepage_adjust(struct kvm_vcpu *vcpu, gfn_t gfn,
 	kvm_pfn_t mask;
 	int level;
 
+	*req_level = PG_LEVEL_4K;
+
 	if (unlikely(max_level == PG_LEVEL_4K))
 		return PG_LEVEL_4K;
 
@@ -3272,7 +3275,14 @@ static int kvm_mmu_hugepage_adjust(struct kvm_vcpu *vcpu, gfn_t gfn,
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
@@ -3318,17 +3328,15 @@ static int __direct_map(struct kvm_vcpu *vcpu, gpa_t gpa, u32 error_code,
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
index 3998ba0daf2e..e88d2acfd805 100644
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
2.28.0

