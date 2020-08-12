Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C07D2242F37
	for <lists+kvm@lfdr.de>; Wed, 12 Aug 2020 21:28:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726707AbgHLT2D (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 12 Aug 2020 15:28:03 -0400
Received: from mga18.intel.com ([134.134.136.126]:34390 "EHLO mga18.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726696AbgHLT2C (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 12 Aug 2020 15:28:02 -0400
IronPort-SDR: Gye5TaLB8vBybfLFGz+pJHYUwWPN/ATqJxoBZI6Aeo/y2DJizVIJhO4iAlt8oJv0y0ALt+lGao
 itT03wouAVtQ==
X-IronPort-AV: E=McAfee;i="6000,8403,9711"; a="141673020"
X-IronPort-AV: E=Sophos;i="5.76,305,1592895600"; 
   d="scan'208";a="141673020"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Aug 2020 12:28:00 -0700
IronPort-SDR: ubvIu4pacWxl5gQJ7CO6LwXqKhD1nRnwWeUvzONYK/R0W+6S7rbMo18RZplME3/4+xguW7Wzux
 qF2ZXEHzBXmg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.76,305,1592895600"; 
   d="scan'208";a="327304457"
Received: from sjchrist-coffee.jf.intel.com ([10.54.74.160])
  by fmsmga002.fm.intel.com with ESMTP; 12 Aug 2020 12:28:00 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <sean.j.christopherson@intel.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Peter Shier <pshier@google.com>,
        Ben Gardon <bgardon@google.com>
Subject: [PATCH v2 2/2] KVM: x86/MMU: Recursively zap nested TDP SPs when zapping last/only parent
Date:   Wed, 12 Aug 2020 12:27:58 -0700
Message-Id: <20200812192758.25587-3-sean.j.christopherson@intel.com>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200812192758.25587-1-sean.j.christopherson@intel.com>
References: <20200812192758.25587-1-sean.j.christopherson@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
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
index 38180befce321..87f1e73a8d365 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -2614,8 +2614,9 @@ static void validate_direct_spte(struct kvm_vcpu *vcpu, u64 *sptep,
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
@@ -2629,19 +2630,34 @@ static void mmu_page_zap_pte(struct kvm *kvm, struct kvm_mmu_page *sp,
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
@@ -2687,7 +2703,7 @@ static bool __kvm_mmu_prepare_zap_page(struct kvm *kvm,
 	trace_kvm_mmu_prepare_zap_page(sp);
 	++kvm->stat.mmu_shadow_zapped;
 	*nr_zapped = mmu_zap_unsync_children(kvm, sp, invalid_list);
-	kvm_mmu_page_unlink_children(kvm, sp);
+	*nr_zapped += kvm_mmu_page_unlink_children(kvm, sp, invalid_list);
 	kvm_mmu_unlink_parents(kvm, sp);
 
 	/* Zapping children means active_mmu_pages has become unstable. */
@@ -5395,7 +5411,7 @@ static void kvm_mmu_pte_write(struct kvm_vcpu *vcpu, gpa_t gpa,
 			u32 base_role = vcpu->arch.mmu->mmu_role.base.word;
 
 			entry = *spte;
-			mmu_page_zap_pte(vcpu->kvm, sp, spte);
+			mmu_page_zap_pte(vcpu->kvm, sp, spte, NULL);
 			if (gentry &&
 			    !((sp->role.word ^ base_role) & ~role_ign.word) &&
 			    rmap_can_add(vcpu))
diff --git a/arch/x86/kvm/mmu/paging_tmpl.h b/arch/x86/kvm/mmu/paging_tmpl.h
index 3bb624a3dda92..e1066226b8f0c 100644
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

