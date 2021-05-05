Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5A43F3737AC
	for <lists+kvm@lfdr.de>; Wed,  5 May 2021 11:38:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232403AbhEEJjV (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 5 May 2021 05:39:21 -0400
Received: from mga12.intel.com ([192.55.52.136]:56202 "EHLO mga12.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232400AbhEEJjT (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 5 May 2021 05:39:19 -0400
IronPort-SDR: 9fkEGdYhLSinM+UR+zgOQSzrYpP3sTV7nUoXhRtWhF+O8aWuANCP5GXSSySJ9eASLXyUTgnqak
 GOxZdebRxTNg==
X-IronPort-AV: E=McAfee;i="6200,9189,9974"; a="177724169"
X-IronPort-AV: E=Sophos;i="5.82,274,1613462400"; 
   d="scan'208";a="177724169"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 May 2021 02:38:23 -0700
IronPort-SDR: eTrtip3kXIYTI3APaUksonfaKi1zfxGlKcPrW2+ymX42uIzw3Vu4t5Jerzsozn7WroHzmamcQu
 /vupcYL3OqSg==
X-IronPort-AV: E=Sophos;i="5.82,274,1613462400"; 
   d="scan'208";a="433728493"
Received: from smorlan-mobl.amr.corp.intel.com (HELO khuang2-desk.gar.corp.intel.com) ([10.212.190.185])
  by orsmga008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 May 2021 02:38:21 -0700
From:   Kai Huang <kai.huang@intel.com>
To:     kvm@vger.kernel.org
Cc:     pbonzini@redhat.com, bgardon@google.com, seanjc@google.com,
        vkuznets@redhat.com, wanpengli@tencent.com, jmattson@google.com,
        joro@8bytes.org, Kai Huang <kai.huang@intel.com>
Subject: [PATCH 3/3] KVM: x86/mmu: Fix TDP MMU page table level
Date:   Wed,  5 May 2021 21:37:59 +1200
Message-Id: <817eae486273adad0a622671f628c5a99b72a375.1620200410.git.kai.huang@intel.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <cover.1620200410.git.kai.huang@intel.com>
References: <cover.1620200410.git.kai.huang@intel.com>
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
mmu->shadow_root_level).  This is kinda wrong, and not consistent with
existing non TDP MMU code.  Fortuantely the sp->role.level is only used
in handle_removed_tdp_mmu_page(), which apparently is already aware of
this, and handles correctly.  However to make it consistent with non TDP
MMU code (and fix the issue that both root page table and any child of
it having shadow_root_level), fix this by using iter->level - 1 in
kvm_tdp_mmu_map().  Also modify handle_removed_tdp_mmu_page() to handle
such change.

Signed-off-by: Kai Huang <kai.huang@intel.com>
---
 arch/x86/kvm/mmu/tdp_mmu.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/arch/x86/kvm/mmu/tdp_mmu.c b/arch/x86/kvm/mmu/tdp_mmu.c
index debe8c3ec844..bcfb87e1c06e 100644
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
@@ -1009,7 +1009,7 @@ int kvm_tdp_mmu_map(struct kvm_vcpu *vcpu, gpa_t gpa, u32 error_code,
 		}
 
 		if (!is_shadow_present_pte(iter.old_spte)) {
-			sp = alloc_tdp_mmu_page(vcpu, iter.gfn, iter.level);
+			sp = alloc_tdp_mmu_page(vcpu, iter.gfn, iter.level - 1);
 			child_pt = sp->spt;
 
 			new_spte = make_nonleaf_spte(child_pt,
-- 
2.31.1

