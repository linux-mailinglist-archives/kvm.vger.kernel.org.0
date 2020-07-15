Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0A1522203F4
	for <lists+kvm@lfdr.de>; Wed, 15 Jul 2020 06:27:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728092AbgGOE1p (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 15 Jul 2020 00:27:45 -0400
Received: from mga05.intel.com ([192.55.52.43]:59539 "EHLO mga05.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725770AbgGOE1a (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 15 Jul 2020 00:27:30 -0400
IronPort-SDR: dv0aeoJGA7ho5RjqQ5M3Ye1ceiTmo9q1V+GHDlHvvWGt6K2RfkBIphOqJFBlNA39dGKVjosM8b
 F8rY8oAOkeEQ==
X-IronPort-AV: E=McAfee;i="6000,8403,9682"; a="233936296"
X-IronPort-AV: E=Sophos;i="5.75,354,1589266800"; 
   d="scan'208";a="233936296"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Jul 2020 21:27:26 -0700
IronPort-SDR: 10/bIyehB7O6p0S0ujr75Ti1qWiFAohdKvFBk0w0LnZZV6SzqFL1xqzX4Y7mbpp+VBz72YGHg1
 Lai4dH/jx8Vg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.75,354,1589266800"; 
   d="scan'208";a="308118782"
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
Subject: [PATCH 3/8] KVM: x86/mmu: Move "huge page disallowed" calculation into mapping helpers
Date:   Tue, 14 Jul 2020 21:27:20 -0700
Message-Id: <20200715042725.10961-4-sean.j.christopherson@intel.com>
X-Mailer: git-send-email 2.26.0
In-Reply-To: <20200715042725.10961-1-sean.j.christopherson@intel.com>
References: <20200715042725.10961-1-sean.j.christopherson@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Calculate huge_page_disallowed in __direct_map() and FNAME(fetch) in
preparation for reworking the calculation so that it preserves the
requested map level and eventually to avoid flagging a shadow page as
being disallowed for being used as a large/huge page when it couldn't
have been huge in the first place, e.g. because the backing page in the
host is not large.

Pass the error code into the helpers and use it to recalcuate exec and
write_fault instead adding yet more booleans to the parameters.

Opportunistically use huge_page_disallowed instead of lpage_disallowed
to match the nomenclature used within the mapping helpers (though even
they have existing inconsistencies).

No functional change intended.

Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
---
 arch/x86/kvm/mmu/mmu.c         | 22 ++++++++++++----------
 arch/x86/kvm/mmu/paging_tmpl.h | 24 ++++++++++++++----------
 2 files changed, 26 insertions(+), 20 deletions(-)

diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index 9cd3d2a23f8a5..bbd7e8be2b936 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -3306,10 +3306,14 @@ static void disallowed_hugepage_adjust(struct kvm_shadow_walk_iterator it,
 	}
 }
 
-static int __direct_map(struct kvm_vcpu *vcpu, gpa_t gpa, int write,
+static int __direct_map(struct kvm_vcpu *vcpu, gpa_t gpa, u32 error_code,
 			int map_writable, int max_level, kvm_pfn_t pfn,
-			bool prefault, bool account_disallowed_nx_lpage)
+			bool prefault, bool is_tdp)
 {
+	bool nx_huge_page_workaround_enabled = is_nx_huge_page_enabled();
+	bool write = error_code & PFERR_WRITE_MASK;
+	bool exec = error_code & PFERR_FETCH_MASK;
+	bool huge_page_disallowed = exec && nx_huge_page_workaround_enabled;
 	struct kvm_shadow_walk_iterator it;
 	struct kvm_mmu_page *sp;
 	int level, ret;
@@ -3319,6 +3323,9 @@ static int __direct_map(struct kvm_vcpu *vcpu, gpa_t gpa, int write,
 	if (WARN_ON(!VALID_PAGE(vcpu->arch.mmu->root_hpa)))
 		return RET_PF_RETRY;
 
+	if (huge_page_disallowed)
+		max_level = PG_LEVEL_4K;
+
 	level = kvm_mmu_hugepage_adjust(vcpu, gfn, max_level, &pfn);
 
 	trace_kvm_mmu_spte_requested(gpa, level, pfn);
@@ -3339,7 +3346,7 @@ static int __direct_map(struct kvm_vcpu *vcpu, gpa_t gpa, int write,
 					      it.level - 1, true, ACC_ALL);
 
 			link_shadow_page(vcpu, it.sptep, sp);
-			if (account_disallowed_nx_lpage)
+			if (is_tdp && huge_page_disallowed)
 				account_huge_nx_page(vcpu->kvm, sp);
 		}
 	}
@@ -4078,8 +4085,6 @@ static int direct_page_fault(struct kvm_vcpu *vcpu, gpa_t gpa, u32 error_code,
 			     bool prefault, int max_level, bool is_tdp)
 {
 	bool write = error_code & PFERR_WRITE_MASK;
-	bool exec = error_code & PFERR_FETCH_MASK;
-	bool lpage_disallowed = exec && is_nx_huge_page_enabled();
 	bool map_writable;
 
 	gfn_t gfn = gpa >> PAGE_SHIFT;
@@ -4097,9 +4102,6 @@ static int direct_page_fault(struct kvm_vcpu *vcpu, gpa_t gpa, u32 error_code,
 	if (r)
 		return r;
 
-	if (lpage_disallowed)
-		max_level = PG_LEVEL_4K;
-
 	mmu_seq = vcpu->kvm->mmu_notifier_seq;
 	smp_rmb();
 
@@ -4116,8 +4118,8 @@ static int direct_page_fault(struct kvm_vcpu *vcpu, gpa_t gpa, u32 error_code,
 	r = make_mmu_pages_available(vcpu);
 	if (r)
 		goto out_unlock;
-	r = __direct_map(vcpu, gpa, write, map_writable, max_level, pfn,
-			 prefault, is_tdp && lpage_disallowed);
+	r = __direct_map(vcpu, gpa, error_code, map_writable, max_level, pfn,
+			 prefault, is_tdp);
 
 out_unlock:
 	spin_unlock(&vcpu->kvm->mmu_lock);
diff --git a/arch/x86/kvm/mmu/paging_tmpl.h b/arch/x86/kvm/mmu/paging_tmpl.h
index 0172a949f6a75..5536b2004dac8 100644
--- a/arch/x86/kvm/mmu/paging_tmpl.h
+++ b/arch/x86/kvm/mmu/paging_tmpl.h
@@ -625,11 +625,14 @@ static void FNAME(pte_prefetch)(struct kvm_vcpu *vcpu, struct guest_walker *gw,
  * emulate this operation, return 1 to indicate this case.
  */
 static int FNAME(fetch)(struct kvm_vcpu *vcpu, gpa_t addr,
-			 struct guest_walker *gw,
-			 int write_fault, int max_level,
-			 kvm_pfn_t pfn, bool map_writable, bool prefault,
-			 bool lpage_disallowed)
+			 struct guest_walker *gw, u32 error_code,
+			 int max_level, kvm_pfn_t pfn, bool map_writable,
+			 bool prefault)
 {
+	bool nx_huge_page_workaround_enabled = is_nx_huge_page_enabled();
+	int write_fault = error_code & PFERR_WRITE_MASK;
+	bool exec = error_code & PFERR_FETCH_MASK;
+	bool huge_page_disallowed = exec && nx_huge_page_workaround_enabled;
 	struct kvm_mmu_page *sp = NULL;
 	struct kvm_shadow_walk_iterator it;
 	unsigned direct_access, access = gw->pt_access;
@@ -679,6 +682,9 @@ static int FNAME(fetch)(struct kvm_vcpu *vcpu, gpa_t addr,
 			link_shadow_page(vcpu, it.sptep, sp);
 	}
 
+	if (huge_page_disallowed)
+		max_level = PG_LEVEL_4K;
+
 	hlevel = kvm_mmu_hugepage_adjust(vcpu, gw->gfn, max_level, &pfn);
 
 	trace_kvm_mmu_spte_requested(addr, gw->level, pfn);
@@ -704,7 +710,7 @@ static int FNAME(fetch)(struct kvm_vcpu *vcpu, gpa_t addr,
 			sp = kvm_mmu_get_page(vcpu, base_gfn, addr,
 					      it.level - 1, true, direct_access);
 			link_shadow_page(vcpu, it.sptep, sp);
-			if (lpage_disallowed)
+			if (huge_page_disallowed)
 				account_huge_nx_page(vcpu->kvm, sp);
 		}
 	}
@@ -783,8 +789,6 @@ static int FNAME(page_fault)(struct kvm_vcpu *vcpu, gpa_t addr, u32 error_code,
 	kvm_pfn_t pfn;
 	unsigned long mmu_seq;
 	bool map_writable, is_self_change_mapping;
-	bool lpage_disallowed = (error_code & PFERR_FETCH_MASK) &&
-				is_nx_huge_page_enabled();
 	int max_level;
 
 	pgprintk("%s: addr %lx err %x\n", __func__, addr, error_code);
@@ -825,7 +829,7 @@ static int FNAME(page_fault)(struct kvm_vcpu *vcpu, gpa_t addr, u32 error_code,
 	is_self_change_mapping = FNAME(is_self_change_mapping)(vcpu,
 	      &walker, user_fault, &vcpu->arch.write_fault_to_shadow_pgtable);
 
-	if (lpage_disallowed || is_self_change_mapping)
+	if (is_self_change_mapping)
 		max_level = PG_LEVEL_4K;
 	else
 		max_level = walker.level;
@@ -869,8 +873,8 @@ static int FNAME(page_fault)(struct kvm_vcpu *vcpu, gpa_t addr, u32 error_code,
 	r = make_mmu_pages_available(vcpu);
 	if (r)
 		goto out_unlock;
-	r = FNAME(fetch)(vcpu, addr, &walker, write_fault, max_level, pfn,
-			 map_writable, prefault, lpage_disallowed);
+	r = FNAME(fetch)(vcpu, addr, &walker, error_code, max_level, pfn,
+			 map_writable, prefault);
 	kvm_mmu_audit(vcpu, AUDIT_POST_PAGE_FAULT);
 
 out_unlock:
-- 
2.26.0

