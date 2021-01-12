Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 898D82F383E
	for <lists+kvm@lfdr.de>; Tue, 12 Jan 2021 19:14:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2406121AbhALSMY (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 12 Jan 2021 13:12:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56814 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2405980AbhALSMX (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 12 Jan 2021 13:12:23 -0500
Received: from mail-pg1-x549.google.com (mail-pg1-x549.google.com [IPv6:2607:f8b0:4864:20::549])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 80410C0617BF
        for <kvm@vger.kernel.org>; Tue, 12 Jan 2021 10:11:05 -0800 (PST)
Received: by mail-pg1-x549.google.com with SMTP id o6so2149302pgg.8
        for <kvm@vger.kernel.org>; Tue, 12 Jan 2021 10:11:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=sender:date:in-reply-to:message-id:mime-version:references:subject
         :from:to:cc;
        bh=I5IsJbZuDYpFXFlSvTXHYskF+HsPl8YK9J43vEHOECY=;
        b=VwoMdWCCamn7/LtEg6RBTX9kpX7d/BuhrxswvYO+plPNfvLxvCdj4KPIAao+O4NmZw
         1rKgoW1SN3im8LUW8D00utBmeB22a/IjCJUsnuXeQsQV9ILuWzAHu2FzJg3C1u3OVUJi
         8uk4NDD7B97v+1HE8o6mK6k7Q8qxq1Rx1xqN47NviyQBfQS3uV1EoApFoWnCuw5J00G/
         UXdNPK9vyqbfIga9pFlfir7gowsNSg1hmVCoBBvpSQ5QvdPoKNQbYAlKJZ0kNQ3nAXqs
         7phOBNpnYycGrtPDdrXUKWCp1Ie6JT3yyfVnPWh2ihGMA8EPdtV4Z/not+b9BKhh3xjO
         liSA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=I5IsJbZuDYpFXFlSvTXHYskF+HsPl8YK9J43vEHOECY=;
        b=U5xw2c15ngd6sC3pJa3ChWWEORHEFO0slMpMQVzszf+mGfIxnkPauOdErqXlpX3ULS
         m1OEMWRltXkxDOUfe5S3SuO6MjTQjvCVjPGdpBVGRnupuN+APCopA/P12y8fLoZdiAnh
         8ZuQEJBP1VqL989k7VWJvqnsomTWxZgb6FC2476Nj8scouj/t9581I4ca+YWMwJeoDhh
         2RSMxPtagNNBAhEoyISLnHqL0MZd2X1Dt4yNlWOHZhOVj0EeXqCuEzXOnKe699lJ1RV5
         zSR+f3rWXnjFPUg4FReuFYvHBa8/VltgMSMHofpNbQ0+wGV6OqStH9JoHsRKouSmWbDs
         W6Bw==
X-Gm-Message-State: AOAM530hAIS1Q/jbfXcxPtEO9d85lgUEmKmDPLYFG+mzevIF5j8+N5sy
        NTtl/oNFdBGC+jaw7/lxZbiPerGVWv5b
X-Google-Smtp-Source: ABdhPJxbA3iapiR/f9u0K/8sUL1gu4aKEfntqg1SY+Pngz3C29pgj1likg4eP52VuPDdA1tup5WUnbUJi1kM
Sender: "bgardon via sendgmr" <bgardon@bgardon.sea.corp.google.com>
X-Received: from bgardon.sea.corp.google.com ([2620:15c:100:202:f693:9fff:fef4:a293])
 (user=bgardon job=sendgmr) by 2002:a17:90a:ff0d:: with SMTP id
 ce13mr326617pjb.109.1610475064980; Tue, 12 Jan 2021 10:11:04 -0800 (PST)
Date:   Tue, 12 Jan 2021 10:10:28 -0800
In-Reply-To: <20210112181041.356734-1-bgardon@google.com>
Message-Id: <20210112181041.356734-12-bgardon@google.com>
Mime-Version: 1.0
References: <20210112181041.356734-1-bgardon@google.com>
X-Mailer: git-send-email 2.30.0.284.gd98b1dd5eaa7-goog
Subject: [PATCH 11/24] kvm: x86/mmu: Put TDP MMU PT walks in RCU read-critical section
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

In order to enable concurrent modifications to the paging structures in
the TDP MMU, threads must be able to safely remove pages of page table
memory while other threads are traversing the same memory. To ensure
threads do not access PT memory after it is freed, protect PT memory
with RCU.

Reviewed-by: Peter Feiner <pfeiner@google.com>

Signed-off-by: Ben Gardon <bgardon@google.com>
---
 arch/x86/kvm/mmu/tdp_mmu.c | 53 ++++++++++++++++++++++++++++++++++++--
 1 file changed, 51 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kvm/mmu/tdp_mmu.c b/arch/x86/kvm/mmu/tdp_mmu.c
index e8f35cd46b4c..662907d374b3 100644
--- a/arch/x86/kvm/mmu/tdp_mmu.c
+++ b/arch/x86/kvm/mmu/tdp_mmu.c
@@ -458,11 +458,14 @@ static inline void tdp_mmu_set_spte_no_dirty_log(struct kvm *kvm,
  * Return true if this function yielded, the TLBs were flushed, and the
  * iterator's traversal was reset. Return false if a yield was not needed.
  */
-static bool tdp_mmu_iter_flush_cond_resched(struct kvm *kvm, struct tdp_iter *iter)
+static bool tdp_mmu_iter_flush_cond_resched(struct kvm *kvm,
+		struct tdp_iter *iter)
 {
 	if (need_resched() || spin_needbreak(&kvm->mmu_lock)) {
 		kvm_flush_remote_tlbs(kvm);
+		rcu_read_unlock();
 		cond_resched_lock(&kvm->mmu_lock);
+		rcu_read_lock();
 		tdp_iter_refresh_walk(iter);
 		return true;
 	} else
@@ -483,7 +486,9 @@ static bool tdp_mmu_iter_flush_cond_resched(struct kvm *kvm, struct tdp_iter *it
 static bool tdp_mmu_iter_cond_resched(struct kvm *kvm, struct tdp_iter *iter)
 {
 	if (need_resched() || spin_needbreak(&kvm->mmu_lock)) {
+		rcu_read_unlock();
 		cond_resched_lock(&kvm->mmu_lock);
+		rcu_read_lock();
 		tdp_iter_refresh_walk(iter);
 		return true;
 	} else
@@ -508,6 +513,8 @@ static bool zap_gfn_range(struct kvm *kvm, struct kvm_mmu_page *root,
 	gfn_t last_goal_gfn = start;
 	bool flush_needed = false;
 
+	rcu_read_lock();
+
 	tdp_root_for_each_pte(iter, root, start, end) {
 		/* Ensure forward progress has been made before yielding. */
 		if (can_yield && iter.goal_gfn != last_goal_gfn &&
@@ -538,6 +545,8 @@ static bool zap_gfn_range(struct kvm *kvm, struct kvm_mmu_page *root,
 		tdp_mmu_set_spte(kvm, &iter, 0);
 		flush_needed = true;
 	}
+
+	rcu_read_unlock();
 	return flush_needed;
 }
 
@@ -650,6 +659,9 @@ int kvm_tdp_mmu_map(struct kvm_vcpu *vcpu, gpa_t gpa, u32 error_code,
 					huge_page_disallowed, &req_level);
 
 	trace_kvm_mmu_spte_requested(gpa, level, pfn);
+
+	rcu_read_lock();
+
 	tdp_mmu_for_each_pte(iter, mmu, gfn, gfn + 1) {
 		if (nx_huge_page_workaround_enabled)
 			disallowed_hugepage_adjust(iter.old_spte, gfn,
@@ -693,11 +705,14 @@ int kvm_tdp_mmu_map(struct kvm_vcpu *vcpu, gpa_t gpa, u32 error_code,
 		}
 	}
 
-	if (WARN_ON(iter.level != level))
+	if (WARN_ON(iter.level != level)) {
+		rcu_read_unlock();
 		return RET_PF_RETRY;
+	}
 
 	ret = tdp_mmu_map_handle_target_level(vcpu, write, map_writable, &iter,
 					      pfn, prefault);
+	rcu_read_unlock();
 
 	return ret;
 }
@@ -768,6 +783,8 @@ static int age_gfn_range(struct kvm *kvm, struct kvm_memory_slot *slot,
 	int young = 0;
 	u64 new_spte = 0;
 
+	rcu_read_lock();
+
 	tdp_root_for_each_leaf_pte(iter, root, start, end) {
 		/*
 		 * If we have a non-accessed entry we don't need to change the
@@ -799,6 +816,8 @@ static int age_gfn_range(struct kvm *kvm, struct kvm_memory_slot *slot,
 		trace_kvm_age_page(iter.gfn, iter.level, slot, young);
 	}
 
+	rcu_read_unlock();
+
 	return young;
 }
 
@@ -844,6 +863,8 @@ static int set_tdp_spte(struct kvm *kvm, struct kvm_memory_slot *slot,
 	u64 new_spte;
 	int need_flush = 0;
 
+	rcu_read_lock();
+
 	WARN_ON(pte_huge(*ptep));
 
 	new_pfn = pte_pfn(*ptep);
@@ -872,6 +893,8 @@ static int set_tdp_spte(struct kvm *kvm, struct kvm_memory_slot *slot,
 	if (need_flush)
 		kvm_flush_remote_tlbs_with_address(kvm, gfn, 1);
 
+	rcu_read_unlock();
+
 	return 0;
 }
 
@@ -896,6 +919,8 @@ static bool wrprot_gfn_range(struct kvm *kvm, struct kvm_mmu_page *root,
 	gfn_t last_goal_gfn = start;
 	bool spte_set = false;
 
+	rcu_read_lock();
+
 	BUG_ON(min_level > KVM_MAX_HUGEPAGE_LEVEL);
 
 	for_each_tdp_pte_min_level(iter, root->spt, root->role.level,
@@ -924,6 +949,8 @@ static bool wrprot_gfn_range(struct kvm *kvm, struct kvm_mmu_page *root,
 		tdp_mmu_set_spte_no_dirty_log(kvm, &iter, new_spte);
 		spte_set = true;
 	}
+
+	rcu_read_unlock();
 	return spte_set;
 }
 
@@ -966,6 +993,8 @@ static bool clear_dirty_gfn_range(struct kvm *kvm, struct kvm_mmu_page *root,
 	gfn_t last_goal_gfn = start;
 	bool spte_set = false;
 
+	rcu_read_lock();
+
 	tdp_root_for_each_leaf_pte(iter, root, start, end) {
 		/* Ensure forward progress has been made before yielding. */
 		if (iter.goal_gfn != last_goal_gfn &&
@@ -994,6 +1023,8 @@ static bool clear_dirty_gfn_range(struct kvm *kvm, struct kvm_mmu_page *root,
 		tdp_mmu_set_spte_no_dirty_log(kvm, &iter, new_spte);
 		spte_set = true;
 	}
+
+	rcu_read_unlock();
 	return spte_set;
 }
 
@@ -1035,6 +1066,8 @@ static void clear_dirty_pt_masked(struct kvm *kvm, struct kvm_mmu_page *root,
 	struct tdp_iter iter;
 	u64 new_spte;
 
+	rcu_read_lock();
+
 	tdp_root_for_each_leaf_pte(iter, root, gfn + __ffs(mask),
 				    gfn + BITS_PER_LONG) {
 		if (!mask)
@@ -1060,6 +1093,8 @@ static void clear_dirty_pt_masked(struct kvm *kvm, struct kvm_mmu_page *root,
 
 		mask &= ~(1UL << (iter.gfn - gfn));
 	}
+
+	rcu_read_unlock();
 }
 
 /*
@@ -1100,6 +1135,8 @@ static bool set_dirty_gfn_range(struct kvm *kvm, struct kvm_mmu_page *root,
 	gfn_t last_goal_gfn = start;
 	bool spte_set = false;
 
+	rcu_read_lock();
+
 	tdp_root_for_each_pte(iter, root, start, end) {
 		/* Ensure forward progress has been made before yielding. */
 		if (iter.goal_gfn != last_goal_gfn &&
@@ -1125,6 +1162,7 @@ static bool set_dirty_gfn_range(struct kvm *kvm, struct kvm_mmu_page *root,
 		spte_set = true;
 	}
 
+	rcu_read_unlock();
 	return spte_set;
 }
 
@@ -1163,6 +1201,8 @@ static void zap_collapsible_spte_range(struct kvm *kvm,
 	gfn_t last_goal_gfn = start;
 	bool spte_set = false;
 
+	rcu_read_lock();
+
 	tdp_root_for_each_pte(iter, root, start, end) {
 		/* Ensure forward progress has been made before yielding. */
 		if (iter.goal_gfn != last_goal_gfn &&
@@ -1190,6 +1230,7 @@ static void zap_collapsible_spte_range(struct kvm *kvm,
 		spte_set = true;
 	}
 
+	rcu_read_unlock();
 	if (spte_set)
 		kvm_flush_remote_tlbs(kvm);
 }
@@ -1226,6 +1267,8 @@ static bool write_protect_gfn(struct kvm *kvm, struct kvm_mmu_page *root,
 	u64 new_spte;
 	bool spte_set = false;
 
+	rcu_read_lock();
+
 	tdp_root_for_each_leaf_pte(iter, root, gfn, gfn + 1) {
 		if (!is_writable_pte(iter.old_spte))
 			break;
@@ -1237,6 +1280,8 @@ static bool write_protect_gfn(struct kvm *kvm, struct kvm_mmu_page *root,
 		spte_set = true;
 	}
 
+	rcu_read_unlock();
+
 	return spte_set;
 }
 
@@ -1277,10 +1322,14 @@ int kvm_tdp_mmu_get_walk(struct kvm_vcpu *vcpu, u64 addr, u64 *sptes,
 
 	*root_level = vcpu->arch.mmu->shadow_root_level;
 
+	rcu_read_lock();
+
 	tdp_mmu_for_each_pte(iter, mmu, gfn, gfn + 1) {
 		leaf = iter.level;
 		sptes[leaf] = iter.old_spte;
 	}
 
+	rcu_read_unlock();
+
 	return leaf;
 }
-- 
2.30.0.284.gd98b1dd5eaa7-goog

