Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C33903EBD73
	for <lists+kvm@lfdr.de>; Fri, 13 Aug 2021 22:35:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234260AbhHMUfi (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 13 Aug 2021 16:35:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37064 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233905AbhHMUfh (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 13 Aug 2021 16:35:37 -0400
Received: from mail-yb1-xb49.google.com (mail-yb1-xb49.google.com [IPv6:2607:f8b0:4864:20::b49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7FA9AC061756
        for <kvm@vger.kernel.org>; Fri, 13 Aug 2021 13:35:10 -0700 (PDT)
Received: by mail-yb1-xb49.google.com with SMTP id i32-20020a25b2200000b02904ed415d9d84so10317681ybj.0
        for <kvm@vger.kernel.org>; Fri, 13 Aug 2021 13:35:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=dQRNNRfUYYSqoQRN+a9ka9GBDidkG2hWiDMvCYRSnzI=;
        b=jvwfvTY1z5ZmMftwAcr2OTdyk63A5pj47T30cySYMd0WZ6+lh3A/DWWt7dDBKN5Elf
         1sZBk5/QsL1d2GRC3zps433zw5Ju3XyrC9HtKfImKPceHd7Bra7pg5mVbw8vel100AJC
         sZ8JXGLS7Db8epJVZzk2QYEzukfBYumh8Libnnrweo5AYn30x8FhbA7NiQhQoMgYk4nH
         7hAe3C0DqmM1H8Oj8Bvk9OP/5IKhcF+t4yUDXh1gBpInlw0KQRsi6l0bGN2lglLrjtcq
         7j+iNWFItwDZaiAU1uFmiEtqqUvaaDNy14ZTgfZMR3L/uzDaZtfKWPXrxR/sStLZBSA7
         4+AQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=dQRNNRfUYYSqoQRN+a9ka9GBDidkG2hWiDMvCYRSnzI=;
        b=tB6Dk9R7d6M5MqIW1DImn9RQ6As50NuABVhWYnQBMZzTjoRIgX8u2TAKhOWjnbbjM3
         50dyzQTnwaprgxvPq1fsUIv9Rq3Y8nClsy0fgVa8QYqDAZv7LZi0cvECzttBbtiy9amZ
         kZybYPWTAbtzbjmU1WQUOSgr3kDA96NKTPgt02VtY7H3Nvtl+cUMhf+Vr0/8MUWpb8XA
         AvBOSoLgEijUMi8qOL/tOxjv5jM1B3uE4uHQcdj2F73iuLjlpGrGrmIWf9qRFU3kqI38
         0Oi+pfPlS1rZ4DbFu9Ma44bKceW5kP+0IO+gbKb6siZZNHwWSyxHmeTs1evQKRZrn8sN
         zYyw==
X-Gm-Message-State: AOAM532XhhfcMx5FLqQ30GZDanMN63hkSms4JwBU/ep5Ky1vK08yp6gs
        sQHMZbTRagipnJ3UzMcCLyzLim5InnzTDQ==
X-Google-Smtp-Source: ABdhPJzDv3Bkges/YuIzD0gHw4ta7DoUmRiiSei/fG25sb100rDhNKkxRGkt42r6ehJnB5gtpAWjlR9zxVcsNQ==
X-Received: from dmatlack-heavy.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:19cd])
 (user=dmatlack job=sendgmr) by 2002:a25:7810:: with SMTP id
 t16mr5206376ybc.352.1628886909701; Fri, 13 Aug 2021 13:35:09 -0700 (PDT)
Date:   Fri, 13 Aug 2021 20:35:00 +0000
In-Reply-To: <20210813203504.2742757-1-dmatlack@google.com>
Message-Id: <20210813203504.2742757-3-dmatlack@google.com>
Mime-Version: 1.0
References: <20210813203504.2742757-1-dmatlack@google.com>
X-Mailer: git-send-email 2.33.0.rc1.237.g0d66db33f3-goog
Subject: [RFC PATCH 2/6] KVM: x86/mmu: Fold rmap_recycle into rmap_add
From:   David Matlack <dmatlack@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org, Ben Gardon <bgardon@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Jim Mattson <jmattson@google.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        David Matlack <dmatlack@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Consolidate rmap_recycle and rmap_add into a single function since they
are only ever called together (and only from one place). This has a nice
side effect of eliminating an extra kvm_vcpu_gfn_to_memslot(). In
addition it makes mmu_set_spte(), which is a very long function, a
little shorter.

No functional change intended.

Signed-off-by: David Matlack <dmatlack@google.com>
---
 arch/x86/kvm/mmu/mmu.c | 40 ++++++++++++++--------------------------
 1 file changed, 14 insertions(+), 26 deletions(-)

diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index a272ccbddfa1..3352312ab1c9 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -1076,20 +1076,6 @@ static bool rmap_can_add(struct kvm_vcpu *vcpu)
 	return kvm_mmu_memory_cache_nr_free_objects(mc);
 }
 
-static int rmap_add(struct kvm_vcpu *vcpu, u64 *spte, gfn_t gfn)
-{
-	struct kvm_memory_slot *slot;
-	struct kvm_mmu_page *sp;
-	struct kvm_rmap_head *rmap_head;
-
-	sp = sptep_to_sp(spte);
-	kvm_mmu_page_set_gfn(sp, spte - sp->spt, gfn);
-	slot = kvm_vcpu_gfn_to_memslot(vcpu, gfn);
-	rmap_head = gfn_to_rmap(gfn, sp->role.level, slot);
-	return pte_list_add(vcpu, spte, rmap_head);
-}
-
-
 static void rmap_remove(struct kvm *kvm, u64 *spte)
 {
 	struct kvm_memslots *slots;
@@ -1102,9 +1088,9 @@ static void rmap_remove(struct kvm *kvm, u64 *spte)
 	gfn = kvm_mmu_page_get_gfn(sp, spte - sp->spt);
 
 	/*
-	 * Unlike rmap_add and rmap_recycle, rmap_remove does not run in the
-	 * context of a vCPU so have to determine which memslots to use based
-	 * on context information in sp->role.
+	 * Unlike rmap_add, rmap_remove does not run in the context of a vCPU
+	 * so we have to determine which memslots to use based on context
+	 * information in sp->role.
 	 */
 	slots = kvm_memslots_for_spte_role(kvm, sp->role);
 
@@ -1644,19 +1630,24 @@ static bool kvm_test_age_rmapp(struct kvm *kvm, struct kvm_rmap_head *rmap_head,
 
 #define RMAP_RECYCLE_THRESHOLD 1000
 
-static void rmap_recycle(struct kvm_vcpu *vcpu, u64 *spte, gfn_t gfn)
+static void rmap_add(struct kvm_vcpu *vcpu, u64 *spte, gfn_t gfn)
 {
 	struct kvm_memory_slot *slot;
-	struct kvm_rmap_head *rmap_head;
 	struct kvm_mmu_page *sp;
+	struct kvm_rmap_head *rmap_head;
+	int rmap_count;
 
 	sp = sptep_to_sp(spte);
+	kvm_mmu_page_set_gfn(sp, spte - sp->spt, gfn);
 	slot = kvm_vcpu_gfn_to_memslot(vcpu, gfn);
 	rmap_head = gfn_to_rmap(gfn, sp->role.level, slot);
+	rmap_count = pte_list_add(vcpu, spte, rmap_head);
 
-	kvm_unmap_rmapp(vcpu->kvm, rmap_head, NULL, gfn, sp->role.level, __pte(0));
-	kvm_flush_remote_tlbs_with_address(vcpu->kvm, sp->gfn,
-			KVM_PAGES_PER_HPAGE(sp->role.level));
+	if (rmap_count > RMAP_RECYCLE_THRESHOLD) {
+		kvm_unmap_rmapp(vcpu->kvm, rmap_head, NULL, gfn, sp->role.level, __pte(0));
+		kvm_flush_remote_tlbs_with_address(
+				vcpu->kvm, sp->gfn, KVM_PAGES_PER_HPAGE(sp->role.level));
+	}
 }
 
 bool kvm_age_gfn(struct kvm *kvm, struct kvm_gfn_range *range)
@@ -2694,7 +2685,6 @@ static int mmu_set_spte(struct kvm_vcpu *vcpu, u64 *sptep,
 			bool host_writable)
 {
 	int was_rmapped = 0;
-	int rmap_count;
 	int set_spte_ret;
 	int ret = RET_PF_FIXED;
 	bool flush = false;
@@ -2754,9 +2744,7 @@ static int mmu_set_spte(struct kvm_vcpu *vcpu, u64 *sptep,
 
 	if (!was_rmapped) {
 		kvm_update_page_stats(vcpu->kvm, level, 1);
-		rmap_count = rmap_add(vcpu, sptep, gfn);
-		if (rmap_count > RMAP_RECYCLE_THRESHOLD)
-			rmap_recycle(vcpu, sptep, gfn);
+		rmap_add(vcpu, sptep, gfn);
 	}
 
 	return ret;
-- 
2.33.0.rc1.237.g0d66db33f3-goog

