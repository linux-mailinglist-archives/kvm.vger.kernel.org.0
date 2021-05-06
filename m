Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 455F9375D7C
	for <lists+kvm@lfdr.de>; Fri,  7 May 2021 01:34:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232696AbhEFXfX (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 6 May 2021 19:35:23 -0400
Received: from mga18.intel.com ([134.134.136.126]:63204 "EHLO mga18.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230387AbhEFXfX (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 6 May 2021 19:35:23 -0400
IronPort-SDR: MOyIKmpnUjhO6rDlQd8ci6kntW7ut6uMBheo2SdaTfSi9tr9QWKrqpTKwn5htWw7rC4NRZZIAs
 8dpANCkAEwmQ==
X-IronPort-AV: E=McAfee;i="6200,9189,9976"; a="186066173"
X-IronPort-AV: E=Sophos;i="5.82,279,1613462400"; 
   d="scan'208";a="186066173"
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 May 2021 16:34:24 -0700
IronPort-SDR: a29ItPBPiJF2+Rbg6oyKknw2aJc5QqOTLlwE/V0nXITIyCut5F4lBnw4BC3x6l/uRSkqngFX3P
 RkQ0/iZCV49Q==
X-IronPort-AV: E=Sophos;i="5.82,279,1613462400"; 
   d="scan'208";a="608004676"
Received: from jasonbai-mobl.amr.corp.intel.com (HELO khuang2-desk.gar.corp.intel.com) ([10.252.141.48])
  by orsmga005-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 May 2021 16:34:22 -0700
From:   Kai Huang <kai.huang@intel.com>
To:     kvm@vger.kernel.org
Cc:     pbonzini@redhat.com, bgardon@google.com, seanjc@google.com,
        vkuznets@redhat.com, wanpengli@tencent.com, jmattson@google.com,
        joro@8bytes.org, Kai Huang <kai.huang@intel.com>
Subject: [PATCH v2 3/3] KVM: x86/mmu: Fix TDP MMU page table level
Date:   Fri,  7 May 2021 11:34:02 +1200
Message-Id: <d689dc6f19fc92d3db64065377df2eb48c09f07b.1620343751.git.kai.huang@intel.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <cover.1620343751.git.kai.huang@intel.com>
References: <cover.1620343751.git.kai.huang@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

TDP MMU iterator's level is identical to page table's actual level.  For
instance, for the last level page table (whose entry points to one 4K
page), iter->level is 1 (PG_LEVEL_4K), and in case of 5 level paging,
the iter->level is mmu->shadow_root_level, which is 5.  However, struct
kvm_mmu_page's level currently is not set correctly when it is allocated
in kvm_tdp_mmu_map().  When iterator hits non-present SPTE and needs to
allocate a new child page table, currently iter->level, which is the
level of the page table where the non-present SPTE belongs to, is used.
This results in struct kvm_mmu_page's level always having its parent's
level (excpet root table's level, which is initialized explicitly using
mmu->shadow_root_level).

This is kinda wrong, and not consistent with existing non TDP MMU code.
Fortuantely sp->role.level is only used in handle_removed_tdp_mmu_page()
and kvm_tdp_mmu_zap_sp(), and they are already aware of this and behave
correctly.  However to make it consistent with legacy MMU code (and fix
the issue that both root page table and its child page table have
shadow_root_level), use iter->level - 1 in kvm_tdp_mmu_map(), and change
handle_removed_tdp_mmu_page() and kvm_tdp_mmu_zap_sp() accordingly.

Reviewed-by: Ben Gardon <bgardon@google.com>
Signed-off-by: Kai Huang <kai.huang@intel.com>
---
 arch/x86/kvm/mmu/tdp_mmu.c | 8 ++++----
 arch/x86/kvm/mmu/tdp_mmu.h | 2 +-
 2 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/arch/x86/kvm/mmu/tdp_mmu.c b/arch/x86/kvm/mmu/tdp_mmu.c
index c389d20418e3..a1db99d10680 100644
--- a/arch/x86/kvm/mmu/tdp_mmu.c
+++ b/arch/x86/kvm/mmu/tdp_mmu.c
@@ -335,7 +335,7 @@ static void handle_removed_tdp_mmu_page(struct kvm *kvm, tdp_ptep_t pt,
 
 	for (i = 0; i < PT64_ENT_PER_PAGE; i++) {
 		sptep = rcu_dereference(pt) + i;
-		gfn = base_gfn + (i * KVM_PAGES_PER_HPAGE(level - 1));
+		gfn = base_gfn + i * KVM_PAGES_PER_HPAGE(level);
 
 		if (shared) {
 			/*
@@ -377,12 +377,12 @@ static void handle_removed_tdp_mmu_page(struct kvm *kvm, tdp_ptep_t pt,
 			WRITE_ONCE(*sptep, REMOVED_SPTE);
 		}
 		handle_changed_spte(kvm, kvm_mmu_page_as_id(sp), gfn,
-				    old_child_spte, REMOVED_SPTE, level - 1,
+				    old_child_spte, REMOVED_SPTE, level,
 				    shared);
 	}
 
 	kvm_flush_remote_tlbs_with_address(kvm, gfn,
-					   KVM_PAGES_PER_HPAGE(level));
+					   KVM_PAGES_PER_HPAGE(level + 1));
 
 	call_rcu(&sp->rcu_head, tdp_mmu_free_sp_rcu_callback);
 }
@@ -1013,7 +1013,7 @@ int kvm_tdp_mmu_map(struct kvm_vcpu *vcpu, gpa_t gpa, u32 error_code,
 		}
 
 		if (!is_shadow_present_pte(iter.old_spte)) {
-			sp = alloc_tdp_mmu_page(vcpu, iter.gfn, iter.level);
+			sp = alloc_tdp_mmu_page(vcpu, iter.gfn, iter.level - 1);
 			child_pt = sp->spt;
 
 			new_spte = make_nonleaf_spte(child_pt,
diff --git a/arch/x86/kvm/mmu/tdp_mmu.h b/arch/x86/kvm/mmu/tdp_mmu.h
index 5fdf63090451..7f9974c5d0b4 100644
--- a/arch/x86/kvm/mmu/tdp_mmu.h
+++ b/arch/x86/kvm/mmu/tdp_mmu.h
@@ -31,7 +31,7 @@ static inline bool kvm_tdp_mmu_zap_gfn_range(struct kvm *kvm, int as_id,
 }
 static inline bool kvm_tdp_mmu_zap_sp(struct kvm *kvm, struct kvm_mmu_page *sp)
 {
-	gfn_t end = sp->gfn + KVM_PAGES_PER_HPAGE(sp->role.level);
+	gfn_t end = sp->gfn + KVM_PAGES_PER_HPAGE(sp->role.level + 1);
 
 	/*
 	 * Don't allow yielding, as the caller may have a flush pending.  Note,
-- 
2.31.1

