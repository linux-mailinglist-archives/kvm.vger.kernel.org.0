Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C92B82763A6
	for <lists+kvm@lfdr.de>; Thu, 24 Sep 2020 00:14:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726761AbgIWWOL (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 23 Sep 2020 18:14:11 -0400
Received: from mga11.intel.com ([192.55.52.93]:60899 "EHLO mga11.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726720AbgIWWOI (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 23 Sep 2020 18:14:08 -0400
IronPort-SDR: 0co9eYTswt8X/tDM+w2E48lVzuuULjUblCdI+C2ms3L+xxfRvvn5MewU567R6RY0Hv7B33EnKV
 44fBL5pfuRvw==
X-IronPort-AV: E=McAfee;i="6000,8403,9753"; a="158382292"
X-IronPort-AV: E=Sophos;i="5.77,295,1596524400"; 
   d="scan'208";a="158382292"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Sep 2020 15:14:08 -0700
IronPort-SDR: wxEdB7Xmb7OXR+GL+bRbx6l0oESpRxYM6nMuQHUqHv/AnAUQ1WePj8uhtmn168SeujbWkz3id1
 gDonET1q92EQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.77,295,1596524400"; 
   d="scan'208";a="335651280"
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
Subject: [PATCH v3 2/2] KVM: x86/MMU: Recursively zap nested TDP SPs when zapping last/only parent
Date:   Wed, 23 Sep 2020 15:14:06 -0700
Message-Id: <20200923221406.16297-3-sean.j.christopherson@intel.com>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200923221406.16297-1-sean.j.christopherson@intel.com>
References: <20200923221406.16297-1-sean.j.christopherson@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Ben Gardon <bgardon@google.com>

Recursively zap all to-be-orphaned children, unsynced or otherwise, when
zapping a shadow page for a nested TDP MMU.  KVM currently only zaps the
unsynced child pages, but not the synced ones.  This can create problems
over time when running many nested guests because it leaves unlinked
pages which will not be freed until the page quota is hit. With the
default page quota of 20 shadow pages per 1000 guest pages, this looks
like a memory leak and can degrade MMU performance.

In a recent benchmark, substantial performance degradation was observed:
An L1 guest was booted with 64G memory.
2G nested Windows guests were booted, 10 at a time for 20
iterations. (200 total boots)
Windows was used in this benchmark because they touch all of their
memory on startup.
By the end of the benchmark, the nested guests were taking ~10% longer
to boot. With this patch there is no degradation in boot time.
Without this patch the benchmark ends with hundreds of thousands of
stale EPT02 pages cluttering up rmaps and the page hash map. As a
result, VM shutdown is also much slower: deleting memslot 0 was
observed to take over a minute. With this patch it takes just a
few miliseconds.

Cc: Peter Shier <pshier@google.com>
Signed-off-by: Ben Gardon <bgardon@google.com>
Co-developed-by: Sean Christopherson <sean.j.christopherson@intel.com>
Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
---
 arch/x86/kvm/mmu/mmu.c         | 30 +++++++++++++++++++++++-------
 arch/x86/kvm/mmu/paging_tmpl.h |  2 +-
 2 files changed, 24 insertions(+), 8 deletions(-)

diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index a91e8601594d..e993d5cd4bc8 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -2615,8 +2615,9 @@ static void validate_direct_spte(struct kvm_vcpu *vcpu, u64 *sptep,
 	}
 }
 
-static void mmu_page_zap_pte(struct kvm *kvm, struct kvm_mmu_page *sp,
-			     u64 *spte)
+/* Returns the number of zapped non-leaf child shadow pages. */
+static int mmu_page_zap_pte(struct kvm *kvm, struct kvm_mmu_page *sp,
+			    u64 *spte, struct list_head *invalid_list)
 {
 	u64 pte;
 	struct kvm_mmu_page *child;
@@ -2630,19 +2631,34 @@ static void mmu_page_zap_pte(struct kvm *kvm, struct kvm_mmu_page *sp,
 		} else {
 			child = to_shadow_page(pte & PT64_BASE_ADDR_MASK);
 			drop_parent_pte(child, spte);
+
+			/*
+			 * Recursively zap nested TDP SPs, parentless SPs are
+			 * unlikely to be used again in the near future.  This
+			 * avoids retaining a large number of stale nested SPs.
+			 */
+			if (tdp_enabled && invalid_list &&
+			    child->role.guest_mode && !child->parent_ptes.val)
+				return kvm_mmu_prepare_zap_page(kvm, child,
+								invalid_list);
 		}
 	} else if (is_mmio_spte(pte)) {
 		mmu_spte_clear_no_track(spte);
 	}
+	return 0;
 }
 
-static void kvm_mmu_page_unlink_children(struct kvm *kvm,
-					 struct kvm_mmu_page *sp)
+static int kvm_mmu_page_unlink_children(struct kvm *kvm,
+					struct kvm_mmu_page *sp,
+					struct list_head *invalid_list)
 {
+	int zapped = 0;
 	unsigned i;
 
 	for (i = 0; i < PT64_ENT_PER_PAGE; ++i)
-		mmu_page_zap_pte(kvm, sp, sp->spt + i);
+		zapped += mmu_page_zap_pte(kvm, sp, sp->spt + i, invalid_list);
+
+	return zapped;
 }
 
 static void kvm_mmu_unlink_parents(struct kvm *kvm, struct kvm_mmu_page *sp)
@@ -2688,7 +2704,7 @@ static bool __kvm_mmu_prepare_zap_page(struct kvm *kvm,
 	trace_kvm_mmu_prepare_zap_page(sp);
 	++kvm->stat.mmu_shadow_zapped;
 	*nr_zapped = mmu_zap_unsync_children(kvm, sp, invalid_list);
-	kvm_mmu_page_unlink_children(kvm, sp);
+	*nr_zapped += kvm_mmu_page_unlink_children(kvm, sp, invalid_list);
 	kvm_mmu_unlink_parents(kvm, sp);
 
 	/* Zapping children means active_mmu_pages has become unstable. */
@@ -5396,7 +5412,7 @@ static void kvm_mmu_pte_write(struct kvm_vcpu *vcpu, gpa_t gpa,
 			u32 base_role = vcpu->arch.mmu->mmu_role.base.word;
 
 			entry = *spte;
-			mmu_page_zap_pte(vcpu->kvm, sp, spte);
+			mmu_page_zap_pte(vcpu->kvm, sp, spte, NULL);
 			if (gentry &&
 			    !((sp->role.word ^ base_role) & ~role_ign.word) &&
 			    rmap_can_add(vcpu))
diff --git a/arch/x86/kvm/mmu/paging_tmpl.h b/arch/x86/kvm/mmu/paging_tmpl.h
index 3bb624a3dda9..e1066226b8f0 100644
--- a/arch/x86/kvm/mmu/paging_tmpl.h
+++ b/arch/x86/kvm/mmu/paging_tmpl.h
@@ -929,7 +929,7 @@ static void FNAME(invlpg)(struct kvm_vcpu *vcpu, gva_t gva, hpa_t root_hpa)
 			pte_gpa = FNAME(get_level1_sp_gpa)(sp);
 			pte_gpa += (sptep - sp->spt) * sizeof(pt_element_t);
 
-			mmu_page_zap_pte(vcpu->kvm, sp, sptep);
+			mmu_page_zap_pte(vcpu->kvm, sp, sptep, NULL);
 			if (is_shadow_present_pte(old_spte))
 				kvm_flush_remote_tlbs_with_address(vcpu->kvm,
 					sp->gfn, KVM_PAGES_PER_HPAGE(sp->role.level));
-- 
2.28.0

