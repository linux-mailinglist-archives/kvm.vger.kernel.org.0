Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6F5C24EF942
	for <lists+kvm@lfdr.de>; Fri,  1 Apr 2022 19:56:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350653AbiDAR6E (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 1 Apr 2022 13:58:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34350 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347150AbiDAR57 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 1 Apr 2022 13:57:59 -0400
Received: from mail-pf1-x44a.google.com (mail-pf1-x44a.google.com [IPv6:2607:f8b0:4864:20::44a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DD5031834D4
        for <kvm@vger.kernel.org>; Fri,  1 Apr 2022 10:56:09 -0700 (PDT)
Received: by mail-pf1-x44a.google.com with SMTP id b7-20020aa79507000000b004fa88200f15so1990364pfp.14
        for <kvm@vger.kernel.org>; Fri, 01 Apr 2022 10:56:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=5zXRbPH5UCC0MzIPY39weUiVp/chM0xOMHiRWD4la3c=;
        b=judHef9BAzgj4FgeW1vRm9YBTxJbUYxIamY2hI0NMvlM3cr5VrZONZvMzgzY7mB5fc
         Et/RNC+awLN7YqYwnnpHGoSFIrpJq2iHlgSKmbY1a8X8r6AEMzIShNB2vOGVmDUH236e
         bLg+ZXy5E+OlhsYteEkCa49jGpzhz/nHN1WgF+BBZ9kL6bi5bSvI0HyGYah0G90zn0E7
         eWj9EUCrQC63YZptaVS06Wg5k6oo7X0VSsM4lBcYI4RQ3zm+9gffX0txYBDSpgOjhiIG
         tQBtKSlr0ySXNad11oRT+rju3gtUZm+AEg6oBd7n7RsnJLiJaciztvxcMN5HPBhVNkqD
         LwCg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=5zXRbPH5UCC0MzIPY39weUiVp/chM0xOMHiRWD4la3c=;
        b=zd3sRs6pdrrTIXG0X1/NVfGnX9xSG9pBuFKafbaAsrwcF37xlzXjTSsBeCMnylwOxG
         Hq7yZFJVQQEf8TmM4QLPXcAnprorGSRpRzM/BC9jGiJWyNTPUfCtWo6etKTb43j7ThqI
         kQHn/hm3iAzPC6woFYWqkN47QmU9NqNZoucrz6oIebU4tRPzkrhjIDALQTVl+Rmbn9Y+
         F9gQUPixwZq/QDqoi7YZUWu0riYnbmdvUpwjKP92apermIJC4dcs1Fz755d0nXUndfWS
         wPQbYZ5LlxV4VM71rrPW2blZuIVqwceFBjR9+MUm5Pr6Kj7aXMgbJVthvCtvrUWvceCj
         shIA==
X-Gm-Message-State: AOAM531FYyZDa1mKc0o53R+AyM8PJYAwGm7pe/9T9UXS5s92fZZD8tqM
        1npLKhFSORlYR1yak1wrHoPuqbhmMem9vA==
X-Google-Smtp-Source: ABdhPJyefj5gqr540fQC5ORDWM5/+t3TXsB4vdSmUL266n9Vg0IBeJqnGewfNN7AZaQki9m2eBNaBN075pqkiQ==
X-Received: from dmatlack-heavy.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:19cd])
 (user=dmatlack job=sendgmr) by 2002:a17:902:e8d1:b0:156:5651:777 with SMTP id
 v17-20020a170902e8d100b0015656510777mr9260591plg.65.1648835769357; Fri, 01
 Apr 2022 10:56:09 -0700 (PDT)
Date:   Fri,  1 Apr 2022 17:55:36 +0000
In-Reply-To: <20220401175554.1931568-1-dmatlack@google.com>
Message-Id: <20220401175554.1931568-6-dmatlack@google.com>
Mime-Version: 1.0
References: <20220401175554.1931568-1-dmatlack@google.com>
X-Mailer: git-send-email 2.35.1.1094.g7c7d902a7c-goog
Subject: [PATCH v3 05/23] KVM: x86/mmu: Rename shadow MMU functions that deal
 with shadow pages
From:   David Matlack <dmatlack@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Marc Zyngier <maz@kernel.org>, Huacai Chen <chenhuacai@kernel.org>,
        Aleksandar Markovic <aleksandar.qemu.devel@gmail.com>,
        Anup Patel <anup@brainfault.org>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        Palmer Dabbelt <palmer@dabbelt.com>,
        Albert Ou <aou@eecs.berkeley.edu>,
        Sean Christopherson <seanjc@google.com>,
        Andrew Jones <drjones@redhat.com>,
        Ben Gardon <bgardon@google.com>, Peter Xu <peterx@redhat.com>,
        maciej.szmigiero@oracle.com,
        "moderated list:KERNEL VIRTUAL MACHINE FOR ARM64 (KVM/arm64)" 
        <kvmarm@lists.cs.columbia.edu>,
        "open list:KERNEL VIRTUAL MACHINE FOR MIPS (KVM/mips)" 
        <linux-mips@vger.kernel.org>,
        "open list:KERNEL VIRTUAL MACHINE FOR MIPS (KVM/mips)" 
        <kvm@vger.kernel.org>,
        "open list:KERNEL VIRTUAL MACHINE FOR RISC-V (KVM/riscv)" 
        <kvm-riscv@lists.infradead.org>, Peter Feiner <pfeiner@google.com>,
        David Matlack <dmatlack@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Rename 3 functions:

  kvm_mmu_get_page()   -> kvm_mmu_get_shadow_page()
  kvm_mmu_alloc_page() -> kvm_mmu_alloc_shadow_page()
  kvm_mmu_free_page()  -> kvm_mmu_free_shadow_page()

This change makes it clear that these functions deal with shadow pages
rather than struct pages. Prefer "shadow_page" over the shorter "sp"
since these are core routines.

Acked-by: Peter Xu <peterx@redhat.com>
Signed-off-by: David Matlack <dmatlack@google.com>
---
 arch/x86/kvm/mmu/mmu.c | 18 ++++++++++--------
 1 file changed, 10 insertions(+), 8 deletions(-)

diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index 8fdddd25029d..dc1825de0752 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -1668,7 +1668,7 @@ static inline void kvm_mod_used_mmu_pages(struct kvm *kvm, long nr)
 	percpu_counter_add(&kvm_total_used_mmu_pages, nr);
 }
 
-static void kvm_mmu_free_page(struct kvm_mmu_page *sp)
+static void kvm_mmu_free_shadow_page(struct kvm_mmu_page *sp)
 {
 	MMU_WARN_ON(!is_empty_shadow_page(sp->spt));
 	hlist_del(&sp->hash_link);
@@ -1706,7 +1706,8 @@ static void drop_parent_pte(struct kvm_mmu_page *sp,
 	mmu_spte_clear_no_track(parent_pte);
 }
 
-static struct kvm_mmu_page *kvm_mmu_alloc_page(struct kvm_vcpu *vcpu, bool direct)
+static struct kvm_mmu_page *kvm_mmu_alloc_shadow_page(struct kvm_vcpu *vcpu,
+						      bool direct)
 {
 	struct kvm_mmu_page *sp;
 
@@ -2130,7 +2131,7 @@ static struct kvm_mmu_page *kvm_mmu_new_shadow_page(struct kvm_vcpu *vcpu,
 
 	++vcpu->kvm->stat.mmu_cache_miss;
 
-	sp = kvm_mmu_alloc_page(vcpu, role.direct);
+	sp = kvm_mmu_alloc_shadow_page(vcpu, role.direct);
 	sp->gfn = gfn;
 	sp->role = role;
 
@@ -2146,8 +2147,9 @@ static struct kvm_mmu_page *kvm_mmu_new_shadow_page(struct kvm_vcpu *vcpu,
 	return sp;
 }
 
-static struct kvm_mmu_page *kvm_mmu_get_page(struct kvm_vcpu *vcpu, gfn_t gfn,
-					     union kvm_mmu_page_role role)
+static struct kvm_mmu_page *kvm_mmu_get_shadow_page(struct kvm_vcpu *vcpu,
+						    gfn_t gfn,
+						    union kvm_mmu_page_role role)
 {
 	struct kvm_mmu_page *sp;
 	bool created = false;
@@ -2204,7 +2206,7 @@ static struct kvm_mmu_page *kvm_mmu_get_child_sp(struct kvm_vcpu *vcpu,
 	union kvm_mmu_page_role role;
 
 	role = kvm_mmu_child_role(sptep, direct, access);
-	return kvm_mmu_get_page(vcpu, gfn, role);
+	return kvm_mmu_get_shadow_page(vcpu, gfn, role);
 }
 
 static void shadow_walk_init_using_root(struct kvm_shadow_walk_iterator *iterator,
@@ -2480,7 +2482,7 @@ static void kvm_mmu_commit_zap_page(struct kvm *kvm,
 
 	list_for_each_entry_safe(sp, nsp, invalid_list, link) {
 		WARN_ON(!sp->role.invalid || sp->root_count);
-		kvm_mmu_free_page(sp);
+		kvm_mmu_free_shadow_page(sp);
 	}
 }
 
@@ -3407,7 +3409,7 @@ static hpa_t mmu_alloc_root(struct kvm_vcpu *vcpu, gfn_t gfn, int quadrant,
 	if (role.has_4_byte_gpte)
 		role.quadrant = quadrant;
 
-	sp = kvm_mmu_get_page(vcpu, gfn, role);
+	sp = kvm_mmu_get_shadow_page(vcpu, gfn, role);
 	++sp->root_count;
 
 	return __pa(sp->spt);
-- 
2.35.1.1094.g7c7d902a7c-goog

