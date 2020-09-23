Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E755527602F
	for <lists+kvm@lfdr.de>; Wed, 23 Sep 2020 20:43:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726853AbgIWSmw (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 23 Sep 2020 14:42:52 -0400
Received: from mga14.intel.com ([192.55.52.115]:9840 "EHLO mga14.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726773AbgIWSmj (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 23 Sep 2020 14:42:39 -0400
IronPort-SDR: tjvLHaFuhsZQ3suH6JnRuejKE8Q73RULv+fEjKUnvtW1K7Xf4FoxsO//EhsWHH9K3a1uiWHmIZ
 QCXtDg58rwRw==
X-IronPort-AV: E=McAfee;i="6000,8403,9753"; a="160276868"
X-IronPort-AV: E=Sophos;i="5.77,293,1596524400"; 
   d="scan'208";a="160276868"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Sep 2020 11:37:38 -0700
IronPort-SDR: 0dI5XWKiAV94jrqzn/5qZQ9UBXuf857qBWo85Twb+wnPwwG1AVWVg5cFF7LZmy8dSdeLY/ac47
 I5q0pxRni1hQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.77,293,1596524400"; 
   d="scan'208";a="486561633"
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
Subject: [PATCH v2 8/8] KVM: x86/mmu: Track write/user faults using bools
Date:   Wed, 23 Sep 2020 11:37:35 -0700
Message-Id: <20200923183735.584-9-sean.j.christopherson@intel.com>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200923183735.584-1-sean.j.christopherson@intel.com>
References: <20200923183735.584-1-sean.j.christopherson@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Use bools to track write and user faults throughout the page fault paths
and down into mmu_set_spte().  The actual usage is purely boolean, but
that's not obvious without digging into all paths as the current code
uses a mix of bools (TDP and try_async_pf) and ints (shadow paging and
mmu_set_spte()).

No true functional change intended (although the pgprintk() will now
print 0/1 instead of 0/PFERR_WRITE_MASK).

Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
---
 arch/x86/kvm/mmu/mmu.c         |  4 ++--
 arch/x86/kvm/mmu/paging_tmpl.h | 10 +++++-----
 2 files changed, 7 insertions(+), 7 deletions(-)

diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index fbee958927ce..a49a98ae1b25 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -3064,7 +3064,7 @@ static int set_spte(struct kvm_vcpu *vcpu, u64 *sptep,
 }
 
 static int mmu_set_spte(struct kvm_vcpu *vcpu, u64 *sptep,
-			unsigned int pte_access, int write_fault, int level,
+			unsigned int pte_access, bool write_fault, int level,
 			gfn_t gfn, kvm_pfn_t pfn, bool speculative,
 			bool host_writable)
 {
@@ -3161,7 +3161,7 @@ static int direct_pte_prefetch_many(struct kvm_vcpu *vcpu,
 		return -1;
 
 	for (i = 0; i < ret; i++, gfn++, start++) {
-		mmu_set_spte(vcpu, start, access, 0, sp->role.level, gfn,
+		mmu_set_spte(vcpu, start, access, false, sp->role.level, gfn,
 			     page_to_pfn(pages[i]), true, true);
 		put_page(pages[i]);
 	}
diff --git a/arch/x86/kvm/mmu/paging_tmpl.h b/arch/x86/kvm/mmu/paging_tmpl.h
index 84ea1094fbe2..012ef1548983 100644
--- a/arch/x86/kvm/mmu/paging_tmpl.h
+++ b/arch/x86/kvm/mmu/paging_tmpl.h
@@ -550,7 +550,7 @@ FNAME(prefetch_gpte)(struct kvm_vcpu *vcpu, struct kvm_mmu_page *sp,
 	 * we call mmu_set_spte() with host_writable = true because
 	 * pte_prefetch_gfn_to_pfn always gets a writable pfn.
 	 */
-	mmu_set_spte(vcpu, spte, pte_access, 0, PG_LEVEL_4K, gfn, pfn,
+	mmu_set_spte(vcpu, spte, pte_access, false, PG_LEVEL_4K, gfn, pfn,
 		     true, true);
 
 	kvm_release_pfn_clean(pfn);
@@ -630,7 +630,7 @@ static int FNAME(fetch)(struct kvm_vcpu *vcpu, gpa_t addr,
 			 bool prefault)
 {
 	bool nx_huge_page_workaround_enabled = is_nx_huge_page_enabled();
-	int write_fault = error_code & PFERR_WRITE_MASK;
+	bool write_fault = error_code & PFERR_WRITE_MASK;
 	bool exec = error_code & PFERR_FETCH_MASK;
 	bool huge_page_disallowed = exec && nx_huge_page_workaround_enabled;
 	struct kvm_mmu_page *sp = NULL;
@@ -743,7 +743,7 @@ static int FNAME(fetch)(struct kvm_vcpu *vcpu, gpa_t addr,
  */
 static bool
 FNAME(is_self_change_mapping)(struct kvm_vcpu *vcpu,
-			      struct guest_walker *walker, int user_fault,
+			      struct guest_walker *walker, bool user_fault,
 			      bool *write_fault_to_shadow_pgtable)
 {
 	int level;
@@ -781,8 +781,8 @@ FNAME(is_self_change_mapping)(struct kvm_vcpu *vcpu,
 static int FNAME(page_fault)(struct kvm_vcpu *vcpu, gpa_t addr, u32 error_code,
 			     bool prefault)
 {
-	int write_fault = error_code & PFERR_WRITE_MASK;
-	int user_fault = error_code & PFERR_USER_MASK;
+	bool write_fault = error_code & PFERR_WRITE_MASK;
+	bool user_fault = error_code & PFERR_USER_MASK;
 	struct guest_walker walker;
 	int r;
 	kvm_pfn_t pfn;
-- 
2.28.0

