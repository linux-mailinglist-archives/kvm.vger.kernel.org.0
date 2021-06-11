Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 10FEE3A4B82
	for <lists+kvm@lfdr.de>; Sat, 12 Jun 2021 01:58:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230380AbhFLAAg (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 11 Jun 2021 20:00:36 -0400
Received: from mail-pf1-f201.google.com ([209.85.210.201]:39438 "EHLO
        mail-pf1-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230348AbhFLAAe (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 11 Jun 2021 20:00:34 -0400
Received: by mail-pf1-f201.google.com with SMTP id j206-20020a6280d70000b02902e9e02e1654so4110251pfd.6
        for <kvm@vger.kernel.org>; Fri, 11 Jun 2021 16:58:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=rs43XjvFocbBYfeRQNGhmBNnR9F38flGi3d9HcssKs8=;
        b=BL/bSA0nQYIes/M0Zr2z5Kk1DbXXupF67tUzFmDLzGvuBo7GtbKD4AinbYfrQyPLUW
         UQoVx4dSLpVTL5lkpXMNIyt8AJXWxBFsvFDcMiAee/F8ttti6GifbmtZPN6zRnEjbWU4
         uvb8Ku8GnBSb0RQJK/t/OQK3yUQkGNTwTrHg+n1xfinc7Vu4kUpeuYs2RnTjClgUlcmP
         Fhfa3/LkxukA1z0nCqMlfo6GZT6xHT8aB9kdS9H6j7pEjaqntaNJfxlzp8kNC98Yrecm
         6nY+wJ/G9JAsgGO+8Ak+DmjAso13xNyeSd1rOzpriJcTKrTeoezw5MTb+JDe1UKbiif9
         3GqQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=rs43XjvFocbBYfeRQNGhmBNnR9F38flGi3d9HcssKs8=;
        b=fl/Fpp55dBYsz6G6ucmmNUBsPOq0+woso3Bzj5MWlQnOgL3GlOrgdsCMTsjSo5difo
         74DACEY9UxfUtRcd7Dev6mitp8C5JRzJHRPXh1IH8pE5v+fPtsgoPf+Waog/2+4M55fY
         tOexl4tvlA84oVBb3iCqB1uFrg9gNJ0S7QqfgbJCThoAYEtSJu9BcZotEKR8Z8gAyavM
         TgcTmimVgtrGcwzui2qD1Pm+kn0oTEJCtMruFUV+VdM6ieWt5VVEJYwYby7nsVxfs5zG
         ie3lTlKDNuRaZINEClhILhP6fnDZk2V8o9iTglqgwewuoAZACTM928roaNXCPX/Cey2I
         oyxQ==
X-Gm-Message-State: AOAM530s1IOvfqO70rKLwAX4NVURic3dr5vKxt1JoPNET0EFxzbTHafl
        flYAVHhsWX/sAnn68E0z6Ekr6Qu1y/D5YZwPFnpBfdEnItufivvYgvHYnQRoVmCxqIedvovGQim
        LuQ7xJydoIf4rkKxIEozVgnkJJS5CsSezjUZUawfcBoH1Ea9RVjAlp1GSkyr/gwk=
X-Google-Smtp-Source: ABdhPJz39p6EOFQiDLMXN85np0Af5aeGr5Z5LvMSBxVcMsztht/KJmQsK3znalwig2YZl9OQysnmSEhvgzukDQ==
X-Received: from dmatlack-heavy.c.googlers.com ([fda3:e722:ac3:10:7f:e700:c0a8:19cd])
 (user=dmatlack job=sendgmr) by 2002:a62:6581:0:b029:2ef:bcb1:c406 with SMTP
 id z123-20020a6265810000b02902efbcb1c406mr10674990pfb.28.1623455848780; Fri,
 11 Jun 2021 16:57:28 -0700 (PDT)
Date:   Fri, 11 Jun 2021 23:56:59 +0000
In-Reply-To: <20210611235701.3941724-1-dmatlack@google.com>
Message-Id: <20210611235701.3941724-7-dmatlack@google.com>
Mime-Version: 1.0
References: <20210611235701.3941724-1-dmatlack@google.com>
X-Mailer: git-send-email 2.32.0.272.g935e593368-goog
Subject: [PATCH 6/8] KVM: x86/mmu: fast_page_fault support for the TDP MMU
From:   David Matlack <dmatlack@google.com>
To:     kvm@vger.kernel.org
Cc:     Ben Gardon <bgardon@google.com>, Joerg Roedel <joro@8bytes.org>,
        Jim Mattson <jmattson@google.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Junaid Shahid <junaids@google.com>,
        Andrew Jones <drjones@redhat.com>,
        David Matlack <dmatlack@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This commit enables the fast_page_fault handler to work when the TDP MMU
is enabled by leveraging the new walk_shadow_page_lockless* API to
collect page walks independent of the TDP MMU.

fast_page_fault was already using
walk_shadow_page_lockless_{begin,end}(), we just have to change the
actual walk to use walk_shadow_page_lockless() which does the right
thing if the TDP MMU is in use.

Signed-off-by: David Matlack <dmatlack@google.com>
---
 arch/x86/kvm/mmu/mmu.c | 52 +++++++++++++++++-------------------------
 1 file changed, 21 insertions(+), 31 deletions(-)

diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index 765f5b01768d..5562727c3699 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -657,6 +657,9 @@ static void walk_shadow_page_lockless_end(struct kvm_vcpu *vcpu)
 	local_irq_enable();
 }
 
+static bool walk_shadow_page_lockless(struct kvm_vcpu *vcpu, u64 addr,
+				      struct shadow_page_walk *walk);
+
 static int mmu_topup_memory_caches(struct kvm_vcpu *vcpu, bool maybe_indirect)
 {
 	int r;
@@ -2967,14 +2970,9 @@ static bool page_fault_can_be_fast(u32 error_code)
  * Returns true if the SPTE was fixed successfully. Otherwise,
  * someone else modified the SPTE from its original value.
  */
-static bool
-fast_pf_fix_direct_spte(struct kvm_vcpu *vcpu, struct kvm_mmu_page *sp,
-			u64 *sptep, u64 old_spte, u64 new_spte)
+static bool fast_pf_fix_direct_spte(struct kvm_vcpu *vcpu, gpa_t gpa,
+				    u64 *sptep, u64 old_spte, u64 new_spte)
 {
-	gfn_t gfn;
-
-	WARN_ON(!sp->role.direct);
-
 	/*
 	 * Theoretically we could also set dirty bit (and flush TLB) here in
 	 * order to eliminate unnecessary PML logging. See comments in
@@ -2990,14 +2988,8 @@ fast_pf_fix_direct_spte(struct kvm_vcpu *vcpu, struct kvm_mmu_page *sp,
 	if (cmpxchg64(sptep, old_spte, new_spte) != old_spte)
 		return false;
 
-	if (is_writable_pte(new_spte) && !is_writable_pte(old_spte)) {
-		/*
-		 * The gfn of direct spte is stable since it is
-		 * calculated by sp->gfn.
-		 */
-		gfn = kvm_mmu_page_get_gfn(sp, sptep - sp->spt);
-		kvm_vcpu_mark_page_dirty(vcpu, gfn);
-	}
+	if (is_writable_pte(new_spte) && !is_writable_pte(old_spte))
+		kvm_vcpu_mark_page_dirty(vcpu, gpa >> PAGE_SHIFT);
 
 	return true;
 }
@@ -3019,10 +3011,9 @@ static bool is_access_allowed(u32 fault_err_code, u64 spte)
  */
 static int fast_page_fault(struct kvm_vcpu *vcpu, gpa_t gpa, u32 error_code)
 {
-	struct kvm_shadow_walk_iterator iterator;
-	struct kvm_mmu_page *sp;
 	int ret = RET_PF_INVALID;
 	u64 spte = 0ull;
+	u64 *sptep = NULL;
 	uint retry_count = 0;
 
 	if (!page_fault_can_be_fast(error_code))
@@ -3031,17 +3022,19 @@ static int fast_page_fault(struct kvm_vcpu *vcpu, gpa_t gpa, u32 error_code)
 	walk_shadow_page_lockless_begin(vcpu);
 
 	do {
+		struct shadow_page_walk walk;
 		u64 new_spte;
 
-		for_each_shadow_entry_lockless(vcpu, gpa, iterator, spte)
-			if (!is_shadow_present_pte(spte))
-				break;
+		if (!walk_shadow_page_lockless(vcpu, gpa, &walk))
+			break;
+
+		spte = walk.sptes[walk.last_level];
+		sptep = walk.spteps[walk.last_level];
 
 		if (!is_shadow_present_pte(spte))
 			break;
 
-		sp = sptep_to_sp(iterator.sptep);
-		if (!is_last_spte(spte, sp->role.level))
+		if (!is_last_spte(spte, walk.last_level))
 			break;
 
 		/*
@@ -3084,7 +3077,7 @@ static int fast_page_fault(struct kvm_vcpu *vcpu, gpa_t gpa, u32 error_code)
 			 *
 			 * See the comments in kvm_arch_commit_memory_region().
 			 */
-			if (sp->role.level > PG_LEVEL_4K)
+			if (walk.last_level > PG_LEVEL_4K)
 				break;
 		}
 
@@ -3098,8 +3091,7 @@ static int fast_page_fault(struct kvm_vcpu *vcpu, gpa_t gpa, u32 error_code)
 		 * since the gfn is not stable for indirect shadow page. See
 		 * Documentation/virt/kvm/locking.rst to get more detail.
 		 */
-		if (fast_pf_fix_direct_spte(vcpu, sp, iterator.sptep, spte,
-					    new_spte)) {
+		if (fast_pf_fix_direct_spte(vcpu, gpa, sptep, spte, new_spte)) {
 			ret = RET_PF_FIXED;
 			break;
 		}
@@ -3112,7 +3104,7 @@ static int fast_page_fault(struct kvm_vcpu *vcpu, gpa_t gpa, u32 error_code)
 
 	} while (true);
 
-	trace_fast_page_fault(vcpu, gpa, error_code, iterator.sptep, spte, ret);
+	trace_fast_page_fault(vcpu, gpa, error_code, sptep, spte, ret);
 	walk_shadow_page_lockless_end(vcpu);
 
 	return ret;
@@ -3748,11 +3740,9 @@ static int direct_page_fault(struct kvm_vcpu *vcpu, gpa_t gpa, u32 error_code,
 	if (page_fault_handle_page_track(vcpu, error_code, gfn))
 		return RET_PF_EMULATE;
 
-	if (!is_vcpu_using_tdp_mmu(vcpu)) {
-		r = fast_page_fault(vcpu, gpa, error_code);
-		if (r != RET_PF_INVALID)
-			return r;
-	}
+	r = fast_page_fault(vcpu, gpa, error_code);
+	if (r != RET_PF_INVALID)
+		return r;
 
 	r = mmu_topup_memory_caches(vcpu, false);
 	if (r)
-- 
2.32.0.272.g935e593368-goog

