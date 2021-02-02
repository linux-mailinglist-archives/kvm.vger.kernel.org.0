Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 968A530CB17
	for <lists+kvm@lfdr.de>; Tue,  2 Feb 2021 20:14:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239375AbhBBTNN (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 2 Feb 2021 14:13:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57656 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239372AbhBBTCL (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 2 Feb 2021 14:02:11 -0500
Received: from mail-qk1-x749.google.com (mail-qk1-x749.google.com [IPv6:2607:f8b0:4864:20::749])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5EDD1C061A28
        for <kvm@vger.kernel.org>; Tue,  2 Feb 2021 10:58:17 -0800 (PST)
Received: by mail-qk1-x749.google.com with SMTP id e187so18190785qkf.0
        for <kvm@vger.kernel.org>; Tue, 02 Feb 2021 10:58:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=sender:date:in-reply-to:message-id:mime-version:references:subject
         :from:to:cc;
        bh=1ycHnD8yBYRgNZEKk0ejNdseFr7uCl6yWeGqf8KX/VU=;
        b=mG0aFaq5nsmo6fjZ/HD5Y2NZ0DvhSk++/kMPBovaVNTtOxQH7d/KjMq21euaAx9EFs
         roqwbN959lta0upadznPxBEK31CgnAsiHZExHxlmrg6GnzSghCM9T1XNwEbm0NNPHlOp
         hW0NZJyLvVKaVbcJT7SsPue+3cRwiO+kV2dEaSePzRtr1ZhcdvY4Raa9DvyX/owDVMME
         Bv/hBZAb20Qi5um5jdMo67wrTZS18SQnAQkQnUzQIiRNwGESA2ByMI4ixiYwrVrk6eJM
         7VUBaWOBQemHX5YMYkVJTPTTTW1eW/zYGDgZn0w99zVTuRsYqqJIhHY7OCadqhneNCrF
         zhbw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=1ycHnD8yBYRgNZEKk0ejNdseFr7uCl6yWeGqf8KX/VU=;
        b=PKtXoe9EB7H6hb/vb9l5oHk/3JKe6cTxIeoL++cvVJmgR+oFERVCV+Q2EByYu8NQDC
         KoYB4G9xVcowK9Z0XmEnM4WJ9tzw9Us0rvTkyYCGsA/ra6oVa8JenusmVwjr9/T9sWZL
         DNxBeT0abfZFRYlLI2MwZwUg9dPUT+74QN/NU9e2UjfV04hNjYk4krGqF7EuHFCeaCBu
         CLJ9I4AZrOBzZqELXNgYL+B6Bx4QiZmfKChTqplg9Mp0/pmSrPpmpz87o6SK951IS3W1
         1o+FaSNCxY4U5vtgyjj4iS39yGzPGyfCoqd3MZ4C4SkLTPI9nfKq6S4udliMunowdB1o
         cjdA==
X-Gm-Message-State: AOAM532oFmNixjb8pRqbHBKBKnzNGNgCh6LzvAOs76CpECjBbfsgi7eE
        iFFi4SzsRoML/opNPdQPH9OHGrve6cO9
X-Google-Smtp-Source: ABdhPJzGa8t3f1SiTVspjcJISfRIFygOEpq5RCtshb8W8OkSAdVoTK9Vg/AgSxM6PsQQJt3fiLPnXddL2nue
Sender: "bgardon via sendgmr" <bgardon@bgardon.sea.corp.google.com>
X-Received: from bgardon.sea.corp.google.com ([2620:15c:100:202:9090:561:5a98:6d47])
 (user=bgardon job=sendgmr) by 2002:a0c:8485:: with SMTP id
 m5mr22102786qva.14.1612292296548; Tue, 02 Feb 2021 10:58:16 -0800 (PST)
Date:   Tue,  2 Feb 2021 10:57:27 -0800
In-Reply-To: <20210202185734.1680553-1-bgardon@google.com>
Message-Id: <20210202185734.1680553-22-bgardon@google.com>
Mime-Version: 1.0
References: <20210202185734.1680553-1-bgardon@google.com>
X-Mailer: git-send-email 2.30.0.365.g02bc693789-goog
Subject: [PATCH v2 21/28] KVM: x86/mmu: Flush TLBs after zap in TDP MMU PF handler
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

v1 -> v2
- Renamed "FROZEN_SPTE" to "REMOVED_SPTE" and updated derivative
  comments and code

 arch/x86/kvm/mmu/spte.h    | 21 ++++++++++++-
 arch/x86/kvm/mmu/tdp_mmu.c | 63 ++++++++++++++++++++++++++++++++------
 2 files changed, 74 insertions(+), 10 deletions(-)

diff --git a/arch/x86/kvm/mmu/spte.h b/arch/x86/kvm/mmu/spte.h
index 2b3a30bd38b0..3f974006cfb6 100644
--- a/arch/x86/kvm/mmu/spte.h
+++ b/arch/x86/kvm/mmu/spte.h
@@ -130,6 +130,25 @@ extern u64 __read_mostly shadow_nonpresent_or_rsvd_mask;
 					  PT64_EPT_EXECUTABLE_MASK)
 #define SHADOW_ACC_TRACK_SAVED_BITS_SHIFT PT64_SECOND_AVAIL_BITS_SHIFT
 
+/*
+ * If a thread running without exclusive control of the MMU lock must perform a
+ * multi-part operation on an SPTE, it can set the SPTE to REMOVED_SPTE as a
+ * non-present intermediate value. Other threads which encounter this value
+ * should not modify the SPTE.
+ *
+ * This constant works because it is considered non-present on both AMD and
+ * Intel CPUs and does not create a L1TF vulnerability because the pfn section
+ * is zeroed out.
+ *
+ * Only used by the TDP MMU.
+ */
+#define REMOVED_SPTE (1ull << 59)
+
+static inline bool is_removed_spte(u64 spte)
+{
+	return spte == REMOVED_SPTE;
+}
+
 /*
  * In some cases, we need to preserve the GFN of a non-present or reserved
  * SPTE when we usurp the upper five bits of the physical address space to
@@ -187,7 +206,7 @@ static inline bool is_access_track_spte(u64 spte)
 
 static inline int is_shadow_present_pte(u64 pte)
 {
-	return (pte != 0) && !is_mmio_spte(pte);
+	return (pte != 0) && !is_mmio_spte(pte) && !is_removed_spte(pte);
 }
 
 static inline int is_large_pte(u64 pte)
diff --git a/arch/x86/kvm/mmu/tdp_mmu.c b/arch/x86/kvm/mmu/tdp_mmu.c
index 0b5a9339ac55..7a2cdfeac4d2 100644
--- a/arch/x86/kvm/mmu/tdp_mmu.c
+++ b/arch/x86/kvm/mmu/tdp_mmu.c
@@ -427,15 +427,19 @@ static void __handle_changed_spte(struct kvm *kvm, int as_id, gfn_t gfn,
 	 */
 	if (!was_present && !is_present) {
 		/*
-		 * If this change does not involve a MMIO SPTE, it is
-		 * unexpected. Log the change, though it should not impact the
-		 * guest since both the former and current SPTEs are nonpresent.
+		 * If this change does not involve a MMIO SPTE or removed SPTE,
+		 * it is unexpected. Log the change, though it should not
+		 * impact the guest since both the former and current SPTEs
+		 * are nonpresent.
 		 */
-		if (WARN_ON(!is_mmio_spte(old_spte) && !is_mmio_spte(new_spte)))
+		if (WARN_ON(!is_mmio_spte(old_spte) &&
+			    !is_mmio_spte(new_spte) &&
+			    !is_removed_spte(new_spte)))
 			pr_err("Unexpected SPTE change! Nonpresent SPTEs\n"
 			       "should not be replaced with another,\n"
 			       "different nonpresent SPTE, unless one or both\n"
-			       "are MMIO SPTEs.\n"
+			       "are MMIO SPTEs, or the new SPTE is\n"
+			       "a temporary removed SPTE.\n"
 			       "as_id: %d gfn: %llx old_spte: %llx new_spte: %llx level: %d",
 			       as_id, gfn, old_spte, new_spte, level);
 		return;
@@ -486,6 +490,13 @@ static inline bool tdp_mmu_set_spte_atomic(struct kvm *kvm,
 
 	lockdep_assert_held_read(&kvm->mmu_lock);
 
+	/*
+	 * Do not change removed SPTEs. Only the thread that froze the SPTE
+	 * may modify it.
+	 */
+	if (iter->old_spte == REMOVED_SPTE)
+		return false;
+
 	if (cmpxchg64(rcu_dereference(iter->sptep), iter->old_spte,
 		      new_spte) != iter->old_spte)
 		return false;
@@ -496,6 +507,34 @@ static inline bool tdp_mmu_set_spte_atomic(struct kvm *kvm,
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
+	if (!tdp_mmu_set_spte_atomic(kvm, iter, REMOVED_SPTE))
+		return false;
+
+	kvm_flush_remote_tlbs_with_address(kvm, iter->gfn,
+					   KVM_PAGES_PER_HPAGE(iter->level));
+
+	/*
+	 * No other thread can overwrite the removed SPTE as they
+	 * must either wait on the MMU lock or use
+	 * tdp_mmu_set_spte_atomic which will not overrite the
+	 * special removed SPTE value. No bookkeeping is needed
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
@@ -523,6 +562,15 @@ static inline void __tdp_mmu_set_spte(struct kvm *kvm, struct tdp_iter *iter,
 
 	lockdep_assert_held_write(&kvm->mmu_lock);
 
+	/*
+	 * No thread should be using this function to set SPTEs to the
+	 * temporary removed SPTE value.
+	 * If operating under the MMU lock in read mode, tdp_mmu_set_spte_atomic
+	 * should be used. If operating under the MMU lock in write mode, the
+	 * use of the removed SPTE should not be necessary.
+	 */
+	WARN_ON(iter->old_spte == REMOVED_SPTE);
+
 	WRITE_ONCE(*rcu_dereference(iter->sptep), new_spte);
 
 	__handle_changed_spte(kvm, as_id, iter->gfn, iter->old_spte, new_spte,
@@ -790,12 +838,9 @@ int kvm_tdp_mmu_map(struct kvm_vcpu *vcpu, gpa_t gpa, u32 error_code,
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
2.30.0.365.g02bc693789-goog

