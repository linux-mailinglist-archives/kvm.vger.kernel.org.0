Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A628E2F381F
	for <lists+kvm@lfdr.de>; Tue, 12 Jan 2021 19:14:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728469AbhALSMp (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 12 Jan 2021 13:12:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56826 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2406306AbhALSMl (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 12 Jan 2021 13:12:41 -0500
Received: from mail-yb1-xb4a.google.com (mail-yb1-xb4a.google.com [IPv6:2607:f8b0:4864:20::b4a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8EB62C06134A
        for <kvm@vger.kernel.org>; Tue, 12 Jan 2021 10:11:25 -0800 (PST)
Received: by mail-yb1-xb4a.google.com with SMTP id a206so3311391ybg.0
        for <kvm@vger.kernel.org>; Tue, 12 Jan 2021 10:11:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=sender:date:in-reply-to:message-id:mime-version:references:subject
         :from:to:cc;
        bh=l+I+bLoy5utbOpCikl2L8mHdXXvFsr/pgAIn4+WfC5A=;
        b=FyNjxbQGAv0YdqOhXA4BwEs4JKTkEI1PzhKb4+kP6NRE66OJcfyF82O1fFyGtyddtE
         d+q+x+Z/vncrFRscx7imQbNPcGuIK1UJpHX8hcR+m1UbroJaFgSKIcsrtt0sTGyNWakK
         qYNJM+PBLdNCcgfu0zjAGPIfEgvzPV8yp3szhLGiM+VQlaArXNZnM4mdl6R2nB4xtWNT
         leRU2wZNhyaMnHjF3e8AfjAOZOFwLTvt5RH55oQwF5GBw6xpFe56J/D6X0bDkXTnHLlP
         1OkpJK/+q1ZflkJ7I74Vxuhtxrcf/sFHEon9NCtw/8CegZ/sifROxAswsaxOZPJRISsK
         oAcQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=l+I+bLoy5utbOpCikl2L8mHdXXvFsr/pgAIn4+WfC5A=;
        b=Ob6n09FZ3CGAcwlhl05grBDq0bwPwifDl3UwGdrnYUZOmUJD7+JOLQmu+JJI0OT+Cp
         mVbkYSeLYIrbTI29nLYsQgmaLTEyztCO+i6BtY/1H9aC0HmbstHS7ulo9xXV2OAMTcmL
         Pr5TRPB2852D6w8DcJpw9yIw2NhrAUelDGNu5B2y4h840jzM6LKXIOQdskyRdPLD+hu2
         C3qpz8nOZh/GLRBSgsJ0k/wcqv7As+NPMmsnqlb5tlvHO9rtPErqcua9XqjBye+K+1UB
         IqzoLsYloiyX1QMpYm6ZWO5JbFjMD8eVox/h0Noi3vgoMx7CfgMngPyPb/I/V5wBgSPG
         JMkQ==
X-Gm-Message-State: AOAM5314n5hlrxQzpwte8llNhYms7GWOYwGi4jVku64n57620jYzBi5r
        mcxHPIj0/lGJSClr4b2EGQjxLVUhCGND
X-Google-Smtp-Source: ABdhPJxak5SYdNqV732YONbr/FySR+NrMxiKTt7HH0qlBQi0b4+BbB3dDDdCXWYuEMGlUxh/dNEzD59+9Moj
Sender: "bgardon via sendgmr" <bgardon@bgardon.sea.corp.google.com>
X-Received: from bgardon.sea.corp.google.com ([2620:15c:100:202:f693:9fff:fef4:a293])
 (user=bgardon job=sendgmr) by 2002:a25:40d:: with SMTP id 13mr1054607ybe.422.1610475084759;
 Tue, 12 Jan 2021 10:11:24 -0800 (PST)
Date:   Tue, 12 Jan 2021 10:10:39 -0800
In-Reply-To: <20210112181041.356734-1-bgardon@google.com>
Message-Id: <20210112181041.356734-23-bgardon@google.com>
Mime-Version: 1.0
References: <20210112181041.356734-1-bgardon@google.com>
X-Mailer: git-send-email 2.30.0.284.gd98b1dd5eaa7-goog
Subject: [PATCH 22/24] kvm: x86/mmu: Flush TLBs after zap in TDP MMU PF handler
From:   Ben Gardon <bgardon@google.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>, Peter Xu <peterx@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Peter Shier <pshier@google.com>,
        Peter Feiner <pfeiner@google.com>,
        Junaid Shahid <junaids@google.com>,
        Jim Mattson <jmattson@google.com>,
        Yulei Zhang <yulei.kernel@gmail.com>,
        Wanpeng Li <kernellwp@gmail.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Xiao Guangrong <xiaoguangrong.eric@gmail.com>,
        Ben Gardon <bgardon@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

When the TDP MMU is allowed to handle page faults in parallel there is
the possiblity of a race where an SPTE is cleared and then imediately
replaced with a present SPTE pointing to a different PFN, before the
TLBs can be flushed. This race would violate architectural specs. Ensure
that the TLBs are flushed properly before other threads are allowed to
install any present value for the SPTE.

Reviewed-by: Peter Feiner <pfeiner@google.com>

Signed-off-by: Ben Gardon <bgardon@google.com>
---
 arch/x86/kvm/mmu/spte.h    | 16 +++++++++-
 arch/x86/kvm/mmu/tdp_mmu.c | 62 ++++++++++++++++++++++++++++++++------
 2 files changed, 68 insertions(+), 10 deletions(-)

diff --git a/arch/x86/kvm/mmu/spte.h b/arch/x86/kvm/mmu/spte.h
index 2b3a30bd38b0..ecd9bfbccef4 100644
--- a/arch/x86/kvm/mmu/spte.h
+++ b/arch/x86/kvm/mmu/spte.h
@@ -130,6 +130,20 @@ extern u64 __read_mostly shadow_nonpresent_or_rsvd_mask;
 					  PT64_EPT_EXECUTABLE_MASK)
 #define SHADOW_ACC_TRACK_SAVED_BITS_SHIFT PT64_SECOND_AVAIL_BITS_SHIFT
 
+/*
+ * If a thread running without exclusive control of the MMU lock must perform a
+ * multi-part operation on an SPTE, it can set the SPTE to FROZEN_SPTE as a
+ * non-present intermediate value. This will guarantee that other threads will
+ * not modify the spte.
+ *
+ * This constant works because it is considered non-present on both AMD and
+ * Intel CPUs and does not create a L1TF vulnerability because the pfn section
+ * is zeroed out.
+ *
+ * Only used by the TDP MMU.
+ */
+#define FROZEN_SPTE (1ull << 59)
+
 /*
  * In some cases, we need to preserve the GFN of a non-present or reserved
  * SPTE when we usurp the upper five bits of the physical address space to
@@ -187,7 +201,7 @@ static inline bool is_access_track_spte(u64 spte)
 
 static inline int is_shadow_present_pte(u64 pte)
 {
-	return (pte != 0) && !is_mmio_spte(pte);
+	return (pte != 0) && !is_mmio_spte(pte) && (pte != FROZEN_SPTE);
 }
 
 static inline int is_large_pte(u64 pte)
diff --git a/arch/x86/kvm/mmu/tdp_mmu.c b/arch/x86/kvm/mmu/tdp_mmu.c
index 7b12a87a4124..5c9d053000ad 100644
--- a/arch/x86/kvm/mmu/tdp_mmu.c
+++ b/arch/x86/kvm/mmu/tdp_mmu.c
@@ -429,15 +429,19 @@ static void __handle_changed_spte(struct kvm *kvm, int as_id, gfn_t gfn,
 	 */
 	if (!was_present && !is_present) {
 		/*
-		 * If this change does not involve a MMIO SPTE, it is
-		 * unexpected. Log the change, though it should not impact the
-		 * guest since both the former and current SPTEs are nonpresent.
+		 * If this change does not involve a MMIO SPTE or FROZEN_SPTE,
+		 * it is unexpected. Log the change, though it should not
+		 * impact the guest since both the former and current SPTEs
+		 * are nonpresent.
 		 */
-		if (WARN_ON(!is_mmio_spte(old_spte) && !is_mmio_spte(new_spte)))
+		if (WARN_ON(!is_mmio_spte(old_spte) &&
+			    !is_mmio_spte(new_spte) &&
+			    new_spte != FROZEN_SPTE))
 			pr_err("Unexpected SPTE change! Nonpresent SPTEs\n"
 			       "should not be replaced with another,\n"
 			       "different nonpresent SPTE, unless one or both\n"
-			       "are MMIO SPTEs.\n"
+			       "are MMIO SPTEs, or the new SPTE is\n"
+			       "FROZEN_SPTE.\n"
 			       "as_id: %d gfn: %llx old_spte: %llx new_spte: %llx level: %d",
 			       as_id, gfn, old_spte, new_spte, level);
 		return;
@@ -488,6 +492,13 @@ static inline bool tdp_mmu_set_spte_atomic(struct kvm *kvm,
 
 	kvm_mmu_lock_assert_held_shared(kvm);
 
+	/*
+	 * Do not change FROZEN_SPTEs. Only the thread that froze the SPTE
+	 * may modify it.
+	 */
+	if (iter->old_spte == FROZEN_SPTE)
+		return false;
+
 	if (cmpxchg64(iter->sptep, iter->old_spte, new_spte) != iter->old_spte)
 		return false;
 
@@ -497,6 +508,34 @@ static inline bool tdp_mmu_set_spte_atomic(struct kvm *kvm,
 	return true;
 }
 
+static inline bool tdp_mmu_zap_spte_atomic(struct kvm *kvm,
+					   struct tdp_iter *iter)
+{
+	/*
+	 * Freeze the SPTE by setting it to a special,
+	 * non-present value. This will stop other threads from
+	 * immediately installing a present entry in its place
+	 * before the TLBs are flushed.
+	 */
+	if (!tdp_mmu_set_spte_atomic(kvm, iter, FROZEN_SPTE))
+		return false;
+
+	kvm_flush_remote_tlbs_with_address(kvm, iter->gfn,
+					   KVM_PAGES_PER_HPAGE(iter->level));
+
+	/*
+	 * No other thread can overwrite the frozen SPTE as they
+	 * must either wait on the MMU lock or use
+	 * tdp_mmu_set_spte_atomic which will not overrite the
+	 * special frozen SPTE value. No bookkeeping is needed
+	 * here since the SPTE is going from non-present
+	 * to non-present.
+	 */
+	WRITE_ONCE(*iter->sptep, 0);
+
+	return true;
+}
+
 
 /*
  * __tdp_mmu_set_spte - Set a TDP MMU SPTE and handle the associated bookkeeping
@@ -524,6 +563,14 @@ static inline void __tdp_mmu_set_spte(struct kvm *kvm, struct tdp_iter *iter,
 
 	kvm_mmu_lock_assert_held_exclusive(kvm);
 
+	/*
+	 * No thread should be using this function to set SPTEs to FROZEN_SPTE.
+	 * If operating under the MMU lock in read mode, tdp_mmu_set_spte_atomic
+	 * should be used. If operating under the MMU lock in write mode, the
+	 * use of FROZEN_SPTE should not be necessary.
+	 */
+	WARN_ON(iter->old_spte == FROZEN_SPTE);
+
 	WRITE_ONCE(*iter->sptep, new_spte);
 
 	__handle_changed_spte(kvm, as_id, iter->gfn, iter->old_spte, new_spte,
@@ -801,12 +848,9 @@ int kvm_tdp_mmu_map(struct kvm_vcpu *vcpu, gpa_t gpa, u32 error_code,
 		 */
 		if (is_shadow_present_pte(iter.old_spte) &&
 		    is_large_pte(iter.old_spte)) {
-			if (!tdp_mmu_set_spte_atomic(vcpu->kvm, &iter, 0))
+			if (!tdp_mmu_zap_spte_atomic(vcpu->kvm, &iter))
 				break;
 
-			kvm_flush_remote_tlbs_with_address(vcpu->kvm, iter.gfn,
-					KVM_PAGES_PER_HPAGE(iter.level));
-
 			/*
 			 * The iter must explicitly re-read the spte here
 			 * because the new value informs the !present
-- 
2.30.0.284.gd98b1dd5eaa7-goog

