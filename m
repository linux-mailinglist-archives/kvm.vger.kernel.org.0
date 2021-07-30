Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 34FB83DC127
	for <lists+kvm@lfdr.de>; Sat, 31 Jul 2021 00:37:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233516AbhG3Wh1 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 30 Jul 2021 18:37:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52462 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233460AbhG3Wh0 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 30 Jul 2021 18:37:26 -0400
Received: from mail-yb1-xb4a.google.com (mail-yb1-xb4a.google.com [IPv6:2607:f8b0:4864:20::b4a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C6EC0C06175F
        for <kvm@vger.kernel.org>; Fri, 30 Jul 2021 15:37:20 -0700 (PDT)
Received: by mail-yb1-xb4a.google.com with SMTP id s123-20020a2577810000b02904f84a5c5297so12132027ybc.16
        for <kvm@vger.kernel.org>; Fri, 30 Jul 2021 15:37:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=dT/LFuHRBf+C472YuFJCuy5RtgpdJJjWKkeLjLnxKxA=;
        b=RNNXXejJfclzGPg5C/Iq75evsn6AF6dYeRc40IEs9g3Obv6ocIozNA8m4JXs/D+x/B
         kkDFMyvCIM4s6KCHC6j6hTRSrHn5OpxGnJgQz2HqgEgXXUEYbdaBwVrRSXlB9TfcKY2W
         E6kBBrdQHJWIpyNzz+FVh0GCSR7DrJNy+SMpg4zDpd4/kdpGjncESgbtbisg/x7RqWwv
         s+1bwp5OLztv3aZaxMDlQc6w3qV03grDqo9M6ZP+MjCdx2QwOZSLle9gQBAvz065FSiM
         RVqArbSsPunOnq/PBomgGRhqNqJtsmXABmWMymEq1Dhpv1RwKs9VWB+WD2NfLXsJGHG7
         FpEQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=dT/LFuHRBf+C472YuFJCuy5RtgpdJJjWKkeLjLnxKxA=;
        b=MtLzw3BftWXSbBzda0iN9QY8M9SSpp1MhqOVCAt1bz6zG6Zk4W7Hcfq8G/S63RQAxw
         jv12R0NwpjMCFv/HmEaAHS4O6Es8ONd91Y+zIMVIQlJiRAXwF/q3sN77NJizkCH9is7S
         IFM/BDwWjEF8aXB4oeCJBkq2fy4bZe59943LcSMoWdQOXGM9Df12V7VnO5jIW5knc/uw
         mMjQ4geysOpKtbQmEaL7lnEm5LLKR7uFYwKwhWH8hlHc8Qi4drTYV4eGmQaepr5hSWqf
         xBTgtVEJyBaHphuWBgPqm7+rU/Mt13RS1uDc+eqsoakwUYf0IASLhiwP/YU0Wq+736PG
         /z1Q==
X-Gm-Message-State: AOAM530v6geBgAYtjgyZ3mRz+BZX9EnVJ0AfSfxjVao+/+Pir+Rj7t9Y
        gVNxxZWfWzb0VPwm3XlsDw2PDjXkaacJJi8TSxiFHu/VSHVQo+Invxb9zcogg+0EVFhkdSyoqoM
        RoKtVZ6gfXKWDqtcvLquITexDpBm8o+TQVI7COGP/QPnZP9gq61Idk2UcOp5YBSw=
X-Google-Smtp-Source: ABdhPJxAMkvHC5nm2B+doIn5QGVay8C3OhySnZMSfi4ETddhbuY33oRb3sbBOAUpF8FnTHCw8B/9jJTycdG9Jw==
X-Received: from dmatlack-heavy.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:19cd])
 (user=dmatlack job=sendgmr) by 2002:a25:e6d1:: with SMTP id
 d200mr5962463ybh.451.1627684639957; Fri, 30 Jul 2021 15:37:19 -0700 (PDT)
Date:   Fri, 30 Jul 2021 22:37:05 +0000
In-Reply-To: <20210730223707.4083785-1-dmatlack@google.com>
Message-Id: <20210730223707.4083785-5-dmatlack@google.com>
Mime-Version: 1.0
References: <20210730223707.4083785-1-dmatlack@google.com>
X-Mailer: git-send-email 2.32.0.554.ge1b32706d8-goog
Subject: [PATCH 4/6] KVM: x86/mmu: Leverage vcpu->lru_slot_index for rmap_add
 and rmap_recycle
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

rmap_add() and rmap_recycle() both run in the context of the vCPU and
thus we can use kvm_vcpu_gfn_to_memslot() to look up the memslot. This
enables rmap_add() and rmap_recycle() to take advantage of
vcpu->lru_slot_index and avoid expensive memslot searching.

This change improves the performance of "Populate memory time" in
dirty_log_perf_test with tdp_mmu=N. In addition to improving the
performance, "Populate memory time" no longer scales with the number
of memslots in the VM.

Command                         | Before           | After
------------------------------- | ---------------- | -------------
./dirty_log_perf_test -v64 -x1  | 15.18001570s     | 14.99469366s
./dirty_log_perf_test -v64 -x64 | 18.71336392s     | 14.98675076s

Signed-off-by: David Matlack <dmatlack@google.com>
---
 arch/x86/kvm/mmu/mmu.c | 35 ++++++++++++++++++++---------------
 1 file changed, 20 insertions(+), 15 deletions(-)

diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index a8cdfd8d45c4..370a6ebc2ede 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -1043,17 +1043,6 @@ static struct kvm_rmap_head *__gfn_to_rmap(gfn_t gfn, int level,
 	return &slot->arch.rmap[level - PG_LEVEL_4K][idx];
 }
 
-static struct kvm_rmap_head *gfn_to_rmap(struct kvm *kvm, gfn_t gfn,
-					 struct kvm_mmu_page *sp)
-{
-	struct kvm_memslots *slots;
-	struct kvm_memory_slot *slot;
-
-	slots = kvm_memslots_for_spte_role(kvm, sp->role);
-	slot = __gfn_to_memslot(slots, gfn);
-	return __gfn_to_rmap(gfn, sp->role.level, slot);
-}
-
 static bool rmap_can_add(struct kvm_vcpu *vcpu)
 {
 	struct kvm_mmu_memory_cache *mc;
@@ -1064,24 +1053,39 @@ static bool rmap_can_add(struct kvm_vcpu *vcpu)
 
 static int rmap_add(struct kvm_vcpu *vcpu, u64 *spte, gfn_t gfn)
 {
+	struct kvm_memory_slot *slot;
 	struct kvm_mmu_page *sp;
 	struct kvm_rmap_head *rmap_head;
 
 	sp = sptep_to_sp(spte);
 	kvm_mmu_page_set_gfn(sp, spte - sp->spt, gfn);
-	rmap_head = gfn_to_rmap(vcpu->kvm, gfn, sp);
+	slot = kvm_vcpu_gfn_to_memslot(vcpu, gfn);
+	rmap_head = __gfn_to_rmap(gfn, sp->role.level, slot);
 	return pte_list_add(vcpu, spte, rmap_head);
 }
 
+
 static void rmap_remove(struct kvm *kvm, u64 *spte)
 {
+	struct kvm_memslots *slots;
+	struct kvm_memory_slot *slot;
 	struct kvm_mmu_page *sp;
 	gfn_t gfn;
 	struct kvm_rmap_head *rmap_head;
 
 	sp = sptep_to_sp(spte);
 	gfn = kvm_mmu_page_get_gfn(sp, spte - sp->spt);
-	rmap_head = gfn_to_rmap(kvm, gfn, sp);
+
+	/*
+	 * Unlike rmap_add and rmap_recycle, rmap_remove does not run in the
+	 * context of a vCPU so have to determine which memslots to use based
+	 * on context information in sp->role.
+	 */
+	slots = kvm_memslots_for_spte_role(kvm, sp->role);
+
+	slot = __gfn_to_memslot(slots, gfn);
+	rmap_head = __gfn_to_rmap(gfn, sp->role.level, slot);
+
 	__pte_list_remove(spte, rmap_head);
 }
 
@@ -1628,12 +1632,13 @@ static bool kvm_test_age_rmapp(struct kvm *kvm, struct kvm_rmap_head *rmap_head,
 
 static void rmap_recycle(struct kvm_vcpu *vcpu, u64 *spte, gfn_t gfn)
 {
+	struct kvm_memory_slot *slot;
 	struct kvm_rmap_head *rmap_head;
 	struct kvm_mmu_page *sp;
 
 	sp = sptep_to_sp(spte);
-
-	rmap_head = gfn_to_rmap(vcpu->kvm, gfn, sp);
+	slot = kvm_vcpu_gfn_to_memslot(vcpu, gfn);
+	rmap_head = __gfn_to_rmap(gfn, sp->role.level, slot);
 
 	kvm_unmap_rmapp(vcpu->kvm, rmap_head, NULL, gfn, sp->role.level, __pte(0));
 	kvm_flush_remote_tlbs_with_address(vcpu->kvm, sp->gfn,
-- 
2.32.0.554.ge1b32706d8-goog

