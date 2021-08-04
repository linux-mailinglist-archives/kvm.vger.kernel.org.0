Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9BD1C3E0A61
	for <lists+kvm@lfdr.de>; Thu,  5 Aug 2021 00:29:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233949AbhHDW3W (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 4 Aug 2021 18:29:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51664 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233831AbhHDW3V (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 4 Aug 2021 18:29:21 -0400
Received: from mail-qt1-x84a.google.com (mail-qt1-x84a.google.com [IPv6:2607:f8b0:4864:20::84a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 51556C061798
        for <kvm@vger.kernel.org>; Wed,  4 Aug 2021 15:29:08 -0700 (PDT)
Received: by mail-qt1-x84a.google.com with SMTP id o7-20020ac87c470000b029025f8084df09so1746600qtv.6
        for <kvm@vger.kernel.org>; Wed, 04 Aug 2021 15:29:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=5Eu+aw1lRqoNOShs52yKOmU8oimqSDtgVqbv4t5aTj4=;
        b=WwJsObmem6DyHnnFm7cNADHNS/GI0KmHlvBFGH37H0MzRvjcMYZ7ZVcF8+qlnU+S5y
         4HugHwFBwOTZ2qnbq2bAm8y+OOTeuZX4xlnaLAy43lqKgx17SOhBrWoONjXtda7anmgC
         AtsSqqdkxP1Y8ClhzGZXQGbOXkUJwHa2JwJaAx+IE96IXEyCB+jtjqGZ/NjS8/FT0MDK
         OhYm0EXV5ESpvbYoHjEM3Q6q/9gThDX4IT/DI6ftGrSTnqWkvB+NX/EOCY6BnUMwIXvW
         8obp9X2N11POEW0VvhxOUiDb72y+ng+t/N1ULPT7DnQjOem+spe2KGE7L4/SEUj47grG
         JghQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=5Eu+aw1lRqoNOShs52yKOmU8oimqSDtgVqbv4t5aTj4=;
        b=B9N9ty1VLuguHp+C9/ixU73dCfJq+DmzgBwltoK/CEx5j9IwHOQtxpyNcvbuaZGXJ/
         K2Tt5hpkbEhEuWspPAAV5qLOR9dAGY9e9usSsnWmWC0qdSIO8GnYzZQ4rQOvfhm1lBHB
         GlCc7KFjCRYLmelS0j0b9z53xTzS7ey2oBsOjpMt0H8JyEf/+pGryB2J6CwDCVKdkBS9
         u7UX4M9EueZhh98Mqoz6xtfdZq4BzqTfQxlIbzcrR4Gc/Y9S5TpMk30b+zDB1RusDDjZ
         SMW3rPcZHcf5Yli5sU4/KE+i/AvCMx8HE1Zwa7CeiAvaledNcw7TlksHKzOFXTxiBAal
         FqYQ==
X-Gm-Message-State: AOAM532KG7srwX3r7fvArydGbLYqOxdF0F9dxK/kKi/d6nJE8SgLsaTq
        K7XNDjBqfx7DEMgBZPPARYFerAdCYpnyHA==
X-Google-Smtp-Source: ABdhPJx5lVjgRawVW2hr2ptJDN68IEgkF3aMXKLbo7D7swoDh5EM1HRZ30u7K6X4M583pTQEhdE6HP/dV5OV6w==
X-Received: from dmatlack-heavy.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:19cd])
 (user=dmatlack job=sendgmr) by 2002:a05:6214:20ea:: with SMTP id
 10mr1892816qvk.13.1628116147552; Wed, 04 Aug 2021 15:29:07 -0700 (PDT)
Date:   Wed,  4 Aug 2021 22:28:42 +0000
In-Reply-To: <20210804222844.1419481-1-dmatlack@google.com>
Message-Id: <20210804222844.1419481-6-dmatlack@google.com>
Mime-Version: 1.0
References: <20210804222844.1419481-1-dmatlack@google.com>
X-Mailer: git-send-email 2.32.0.554.ge1b32706d8-goog
Subject: [PATCH v2 5/7] KVM: x86/mmu: Leverage vcpu->last_used_slot for
 rmap_add and rmap_recycle
From:   David Matlack <dmatlack@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org, kvm-ppc@vger.kernel.org,
        Ben Gardon <bgardon@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Jim Mattson <jmattson@google.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Junaid Shahid <junaids@google.com>,
        Andrew Jones <drjones@redhat.com>,
        Paul Mackerras <paulus@ozlabs.org>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        David Matlack <dmatlack@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

rmap_add() and rmap_recycle() both run in the context of the vCPU and
thus we can use kvm_vcpu_gfn_to_memslot() to look up the memslot. This
enables rmap_add() and rmap_recycle() to take advantage of
vcpu->last_used_slot and avoid expensive memslot searching.

This change improves the performance of "Populate memory time" in
dirty_log_perf_test with tdp_mmu=N. In addition to improving the
performance, "Populate memory time" no longer scales with the number
of memslots in the VM.

Command                         | Before           | After
------------------------------- | ---------------- | -------------
./dirty_log_perf_test -v64 -x1  | 15.18001570s     | 14.99469366s
./dirty_log_perf_test -v64 -x64 | 18.71336392s     | 14.98675076s

Reviewed-by: Paolo Bonzini <pbonzini@redhat.com>
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

