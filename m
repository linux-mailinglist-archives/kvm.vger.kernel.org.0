Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BD280526B5B
	for <lists+kvm@lfdr.de>; Fri, 13 May 2022 22:29:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1384337AbiEMU33 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 13 May 2022 16:29:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59834 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1384280AbiEMU3W (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 13 May 2022 16:29:22 -0400
Received: from mail-pj1-x104a.google.com (mail-pj1-x104a.google.com [IPv6:2607:f8b0:4864:20::104a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 956BC79803
        for <kvm@vger.kernel.org>; Fri, 13 May 2022 13:29:02 -0700 (PDT)
Received: by mail-pj1-x104a.google.com with SMTP id o16-20020a17090ab89000b001d84104fc2cso4182151pjr.1
        for <kvm@vger.kernel.org>; Fri, 13 May 2022 13:29:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=kFuYqeri/i2mfzPJXttr8ceJqhbq0CpxLPyTsiOWWyk=;
        b=O4NlK+8k7gmd18lqfTy8sEoNPPvMvxz5L/5++1dc4ytp2igE0C/3bmDVsBjymz4Vzz
         L4lOXpWkRtxtjdbPnVIr5AinXZ6byMiNXFIKDi7VXznjjQRIQ081gsePpcnX5xPVURLC
         oJQjOxNzGRaQFt8BgbCZHqChP9vy7zh0nEHGLkP/Xrj1NwIBiIO9p25vKfmq9hUhCcC0
         C5wdaHimdFJuQxGDkihGSyidiZ0OELRqLU/1JkVkYuznhk1vi+mmv0I/vMT++0X/Lg6J
         LhbrITbjUmFbGYd86xkaGerJuqs73y2X1MzDk592FIZ3FAKqHTRy9vkxVFGSNGBp96VP
         G8DQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=kFuYqeri/i2mfzPJXttr8ceJqhbq0CpxLPyTsiOWWyk=;
        b=n3yJgRQNW1Npj5c6paqh6cwRvSlBy4ikxN4g0LTNUUHtdqaEDlHOfwGVX9k2E5m5bY
         tIDbyKMXslqAgyjZtJZfxb6lFw+j4AkfSAvOkvMMy+QIWsGbVQNlnn8l6ZUb7T0rGLx3
         O5IXuIODNCs6ZURnpCEzdDnRBDGcIMky6sn7HbgcJtttnAumrlrT2iRxGxnQasljcC/3
         EM358RA9B1zvQA+clFWwzccfTqEely3PTDhC5AgGYh8Avu8CLq2yiG3T6xxKuI13nTul
         NtmWXwE2Ig9ptfTGw3E96Ga5qLNp7s5eDlDCiPSxkKXuoTQEbvKWEOFsRUChjckH0ujw
         qbtw==
X-Gm-Message-State: AOAM530sf4yf4+acirX6rjuLf/TLYsVgL/JrnZ+9eMUgwatxigoFJUfx
        5X06H3GkJMwjxlNJ+s3a5j1FT6Cd2/zYJw==
X-Google-Smtp-Source: ABdhPJwbhKeBP2C9GQ82ntIUdys3AYLftb+6HzL+D/4LCZmV5/QDrCtkTJx0DOJ9fPF4XW+LwcPUGW6co1h8zA==
X-Received: from dmatlack-heavy.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:19cd])
 (user=dmatlack job=sendgmr) by 2002:a17:90a:8d83:b0:1dd:258c:7c55 with SMTP
 id d3-20020a17090a8d8300b001dd258c7c55mr250788pjo.1.1652473734975; Fri, 13
 May 2022 13:28:54 -0700 (PDT)
Date:   Fri, 13 May 2022 20:28:12 +0000
In-Reply-To: <20220513202819.829591-1-dmatlack@google.com>
Message-Id: <20220513202819.829591-15-dmatlack@google.com>
Mime-Version: 1.0
References: <20220513202819.829591-1-dmatlack@google.com>
X-Mailer: git-send-email 2.36.0.550.gb090851708-goog
Subject: [PATCH v5 14/21] KVM: x86/mmu: Decouple rmap_add() and
 link_shadow_page() from kvm_vcpu
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
        Lai Jiangshan <jiangshanlai@gmail.com>,
        David Matlack <dmatlack@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Allow adding new entries to the rmap and linking shadow pages without a
struct kvm_vcpu pointer by moving the implementation of rmap_add() and
link_shadow_page() into inner helper functions.

No functional change intended.

Reviewed-by: Ben Gardon <bgardon@google.com>
Reviewed-by: Peter Xu <peterx@redhat.com>
Signed-off-by: David Matlack <dmatlack@google.com>
---
 arch/x86/kvm/mmu/mmu.c | 45 +++++++++++++++++++++++++-----------------
 1 file changed, 27 insertions(+), 18 deletions(-)

diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index 8a6dec1c27c8..0a14320fb148 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -699,11 +699,6 @@ static void mmu_free_memory_caches(struct kvm_vcpu *vcpu)
 	kvm_mmu_free_memory_cache(&vcpu->arch.mmu_page_header_cache);
 }
 
-static struct pte_list_desc *mmu_alloc_pte_list_desc(struct kvm_vcpu *vcpu)
-{
-	return kvm_mmu_memory_cache_alloc(&vcpu->arch.mmu_pte_list_desc_cache);
-}
-
 static void mmu_free_pte_list_desc(struct pte_list_desc *pte_list_desc)
 {
 	kmem_cache_free(pte_list_desc_cache, pte_list_desc);
@@ -858,7 +853,7 @@ gfn_to_memslot_dirty_bitmap(struct kvm_vcpu *vcpu, gfn_t gfn,
 /*
  * Returns the number of pointers in the rmap chain, not counting the new one.
  */
-static int pte_list_add(struct kvm_vcpu *vcpu, u64 *spte,
+static int pte_list_add(struct kvm_mmu_memory_cache *cache, u64 *spte,
 			struct kvm_rmap_head *rmap_head)
 {
 	struct pte_list_desc *desc;
@@ -869,7 +864,7 @@ static int pte_list_add(struct kvm_vcpu *vcpu, u64 *spte,
 		rmap_head->val = (unsigned long)spte;
 	} else if (!(rmap_head->val & 1)) {
 		rmap_printk("%p %llx 1->many\n", spte, *spte);
-		desc = mmu_alloc_pte_list_desc(vcpu);
+		desc = kvm_mmu_memory_cache_alloc(cache);
 		desc->sptes[0] = (u64 *)rmap_head->val;
 		desc->sptes[1] = spte;
 		desc->spte_count = 2;
@@ -881,7 +876,7 @@ static int pte_list_add(struct kvm_vcpu *vcpu, u64 *spte,
 		while (desc->spte_count == PTE_LIST_EXT) {
 			count += PTE_LIST_EXT;
 			if (!desc->more) {
-				desc->more = mmu_alloc_pte_list_desc(vcpu);
+				desc->more = kvm_mmu_memory_cache_alloc(cache);
 				desc = desc->more;
 				desc->spte_count = 0;
 				break;
@@ -1582,8 +1577,10 @@ static bool kvm_test_age_rmapp(struct kvm *kvm, struct kvm_rmap_head *rmap_head,
 
 #define RMAP_RECYCLE_THRESHOLD 1000
 
-static void rmap_add(struct kvm_vcpu *vcpu, const struct kvm_memory_slot *slot,
-		     u64 *spte, gfn_t gfn)
+static void __rmap_add(struct kvm *kvm,
+		       struct kvm_mmu_memory_cache *cache,
+		       const struct kvm_memory_slot *slot,
+		       u64 *spte, gfn_t gfn)
 {
 	struct kvm_mmu_page *sp;
 	struct kvm_rmap_head *rmap_head;
@@ -1592,15 +1589,21 @@ static void rmap_add(struct kvm_vcpu *vcpu, const struct kvm_memory_slot *slot,
 	sp = sptep_to_sp(spte);
 	kvm_mmu_page_set_gfn(sp, spte - sp->spt, gfn);
 	rmap_head = gfn_to_rmap(gfn, sp->role.level, slot);
-	rmap_count = pte_list_add(vcpu, spte, rmap_head);
+	rmap_count = pte_list_add(cache, spte, rmap_head);
 
 	if (rmap_count > RMAP_RECYCLE_THRESHOLD) {
-		kvm_unmap_rmapp(vcpu->kvm, rmap_head, NULL, gfn, sp->role.level, __pte(0));
+		kvm_unmap_rmapp(kvm, rmap_head, NULL, gfn, sp->role.level, __pte(0));
 		kvm_flush_remote_tlbs_with_address(
-				vcpu->kvm, sp->gfn, KVM_PAGES_PER_HPAGE(sp->role.level));
+				kvm, sp->gfn, KVM_PAGES_PER_HPAGE(sp->role.level));
 	}
 }
 
+static void rmap_add(struct kvm_vcpu *vcpu, const struct kvm_memory_slot *slot,
+		     u64 *spte, gfn_t gfn)
+{
+	__rmap_add(vcpu->kvm, &vcpu->arch.mmu_pte_list_desc_cache, slot, spte, gfn);
+}
+
 bool kvm_age_gfn(struct kvm *kvm, struct kvm_gfn_range *range)
 {
 	bool young = false;
@@ -1671,13 +1674,13 @@ static unsigned kvm_page_table_hashfn(gfn_t gfn)
 	return hash_64(gfn, KVM_MMU_HASH_SHIFT);
 }
 
-static void mmu_page_add_parent_pte(struct kvm_vcpu *vcpu,
+static void mmu_page_add_parent_pte(struct kvm_mmu_memory_cache *cache,
 				    struct kvm_mmu_page *sp, u64 *parent_pte)
 {
 	if (!parent_pte)
 		return;
 
-	pte_list_add(vcpu, parent_pte, &sp->parent_ptes);
+	pte_list_add(cache, parent_pte, &sp->parent_ptes);
 }
 
 static void mmu_page_remove_parent_pte(struct kvm_mmu_page *sp,
@@ -2276,8 +2279,8 @@ static void shadow_walk_next(struct kvm_shadow_walk_iterator *iterator)
 	__shadow_walk_next(iterator, *iterator->sptep);
 }
 
-static void link_shadow_page(struct kvm_vcpu *vcpu, u64 *sptep,
-			     struct kvm_mmu_page *sp)
+static void __link_shadow_page(struct kvm_mmu_memory_cache *cache, u64 *sptep,
+			       struct kvm_mmu_page *sp)
 {
 	u64 spte;
 
@@ -2287,12 +2290,18 @@ static void link_shadow_page(struct kvm_vcpu *vcpu, u64 *sptep,
 
 	mmu_spte_set(sptep, spte);
 
-	mmu_page_add_parent_pte(vcpu, sp, sptep);
+	mmu_page_add_parent_pte(cache, sp, sptep);
 
 	if (sp->unsync_children || sp->unsync)
 		mark_unsync(sptep);
 }
 
+static void link_shadow_page(struct kvm_vcpu *vcpu, u64 *sptep,
+			     struct kvm_mmu_page *sp)
+{
+	__link_shadow_page(&vcpu->arch.mmu_pte_list_desc_cache, sptep, sp);
+}
+
 static void validate_direct_spte(struct kvm_vcpu *vcpu, u64 *sptep,
 				   unsigned direct_access)
 {
-- 
2.36.0.550.gb090851708-goog

