Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 314C02763A7
	for <lists+kvm@lfdr.de>; Thu, 24 Sep 2020 00:14:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726716AbgIWWOI (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 23 Sep 2020 18:14:08 -0400
Received: from mga11.intel.com ([192.55.52.93]:60899 "EHLO mga11.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726634AbgIWWOI (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 23 Sep 2020 18:14:08 -0400
IronPort-SDR: 30nJLBPhSviJN17fRQdmXWeLaGiiHtgETWseeN4Juymr5i51Pf9XbMGQXo3B/BdTb0Ge1oYYAZ
 QHYaYHoStVjQ==
X-IronPort-AV: E=McAfee;i="6000,8403,9753"; a="158382291"
X-IronPort-AV: E=Sophos;i="5.77,295,1596524400"; 
   d="scan'208";a="158382291"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Sep 2020 15:14:07 -0700
IronPort-SDR: cCTeeWFMolGsyhT8Q/AwiNXndCi7jkVxeU33R4MNLcOL/fa3dBRHcMlJhCHZtWRldZZ82fej6v
 JheR34ho4dTg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.77,295,1596524400"; 
   d="scan'208";a="335651275"
Received: from sjchrist-coffee.jf.intel.com ([10.54.74.160])
  by fmsmga004.fm.intel.com with ESMTP; 23 Sep 2020 15:14:07 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <sean.j.christopherson@intel.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Peter Shier <pshier@google.com>,
        Ben Gardon <bgardon@google.com>
Subject: [PATCH v3 1/2] KVM: x86/mmu: Move flush logic from mmu_page_zap_pte() to FNAME(invlpg)
Date:   Wed, 23 Sep 2020 15:14:05 -0700
Message-Id: <20200923221406.16297-2-sean.j.christopherson@intel.com>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200923221406.16297-1-sean.j.christopherson@intel.com>
References: <20200923221406.16297-1-sean.j.christopherson@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Move the logic that controls whether or not FNAME(invlpg) needs to flush
fully into FNAME(invlpg) so that mmu_page_zap_pte() doesn't return a
value.  This allows a future patch to redefine the return semantics for
mmu_page_zap_pte() so that it can recursively zap orphaned child shadow
pages for nested TDP MMUs.

No functional change intended.

Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
---
 arch/x86/kvm/mmu/mmu.c         | 10 +++-------
 arch/x86/kvm/mmu/paging_tmpl.h |  7 +++++--
 2 files changed, 8 insertions(+), 9 deletions(-)

diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index 76c5826e29a2..a91e8601594d 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -2615,7 +2615,7 @@ static void validate_direct_spte(struct kvm_vcpu *vcpu, u64 *sptep,
 	}
 }
 
-static bool mmu_page_zap_pte(struct kvm *kvm, struct kvm_mmu_page *sp,
+static void mmu_page_zap_pte(struct kvm *kvm, struct kvm_mmu_page *sp,
 			     u64 *spte)
 {
 	u64 pte;
@@ -2631,13 +2631,9 @@ static bool mmu_page_zap_pte(struct kvm *kvm, struct kvm_mmu_page *sp,
 			child = to_shadow_page(pte & PT64_BASE_ADDR_MASK);
 			drop_parent_pte(child, spte);
 		}
-		return true;
-	}
-
-	if (is_mmio_spte(pte))
+	} else if (is_mmio_spte(pte)) {
 		mmu_spte_clear_no_track(spte);
-
-	return false;
+	}
 }
 
 static void kvm_mmu_page_unlink_children(struct kvm *kvm,
diff --git a/arch/x86/kvm/mmu/paging_tmpl.h b/arch/x86/kvm/mmu/paging_tmpl.h
index 4dd6b1e5b8cf..3bb624a3dda9 100644
--- a/arch/x86/kvm/mmu/paging_tmpl.h
+++ b/arch/x86/kvm/mmu/paging_tmpl.h
@@ -895,6 +895,7 @@ static void FNAME(invlpg)(struct kvm_vcpu *vcpu, gva_t gva, hpa_t root_hpa)
 {
 	struct kvm_shadow_walk_iterator iterator;
 	struct kvm_mmu_page *sp;
+	u64 old_spte;
 	int level;
 	u64 *sptep;
 
@@ -917,7 +918,8 @@ static void FNAME(invlpg)(struct kvm_vcpu *vcpu, gva_t gva, hpa_t root_hpa)
 		sptep = iterator.sptep;
 
 		sp = sptep_to_sp(sptep);
-		if (is_last_spte(*sptep, level)) {
+		old_spte = *sptep;
+		if (is_last_spte(old_spte, level)) {
 			pt_element_t gpte;
 			gpa_t pte_gpa;
 
@@ -927,7 +929,8 @@ static void FNAME(invlpg)(struct kvm_vcpu *vcpu, gva_t gva, hpa_t root_hpa)
 			pte_gpa = FNAME(get_level1_sp_gpa)(sp);
 			pte_gpa += (sptep - sp->spt) * sizeof(pt_element_t);
 
-			if (mmu_page_zap_pte(vcpu->kvm, sp, sptep))
+			mmu_page_zap_pte(vcpu->kvm, sp, sptep);
+			if (is_shadow_present_pte(old_spte))
 				kvm_flush_remote_tlbs_with_address(vcpu->kvm,
 					sp->gfn, KVM_PAGES_PER_HPAGE(sp->role.level));
 
-- 
2.28.0

