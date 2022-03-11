Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 242604D5690
	for <lists+kvm@lfdr.de>; Fri, 11 Mar 2022 01:26:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245520AbiCKA0k (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 10 Mar 2022 19:26:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48286 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345136AbiCKA0j (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 10 Mar 2022 19:26:39 -0500
Received: from mail-pj1-x104a.google.com (mail-pj1-x104a.google.com [IPv6:2607:f8b0:4864:20::104a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 03C111A1C71
        for <kvm@vger.kernel.org>; Thu, 10 Mar 2022 16:25:37 -0800 (PST)
Received: by mail-pj1-x104a.google.com with SMTP id p15-20020a17090a748f00b001bf3ba2ae95so4229701pjk.9
        for <kvm@vger.kernel.org>; Thu, 10 Mar 2022 16:25:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=hQ1Yj2jpLZU8m0KHZ3b2ZXi72STV++YRQqlTTShJ2JQ=;
        b=dUwKeuepnbyw5I0D0zMuN7US6l4wxLHljA5AApQQ7F8dXrKm4tCACM2Ugps7u8EbNv
         svxWhyuNtv4ZPIQtNMet7fhETJw6LR+X7042fh/hfghQ3hS09G7ORdIa66X94PRknWNe
         WK9BK6Rvd5d3JqbdXSUu3+i8v4WCdWIECzAvF96kUgv4gf++6omtsET5AXA6x5yqpYgI
         Tx8LI9oPouldhO9zpRH8GBq7bLkogNVqyx+Ou4bVr1nF61MdAK4Ix1sg8d9fdsmyAtt0
         EltlXSsxXMf72xinEOHYBHxQQQ7yXKNtvWah99RgqxrSPGbmumNksNzAiNgfuIXaV7qV
         yJfg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=hQ1Yj2jpLZU8m0KHZ3b2ZXi72STV++YRQqlTTShJ2JQ=;
        b=zUbhLEYQjMZ4GH0Bk7DvansETYM3t9KCcT+/5q9OjLHoqP6G7fVoKbQHbl/+Oub1JD
         qnrdpqER1B6HiuM6gS54LqQkL2HfnANEYIj/pBhIj5nS9HIAqL5Z7PaINn+AwIr+evkp
         bljwwqWzIwxLqzf2cUs1jr9Z6sh3BZIL5i1Sq0TDxNt5Q+j6yh8pthgTFfOGFDS4N3eA
         2QhG7o2yUt2jXj5HosQbl3Gdg+LC/9emTM8GcUf7Bxmdk1JLokpq6muXQJgTzwa2wZDM
         hxhSYwaY36Y3+Vqna+4sTk8M0E3IiU/bTGV1sk0bD+rDqhHyFOLVaC7EMwPh3DbcFbm0
         2Krw==
X-Gm-Message-State: AOAM5338cMRHtm7+hNNMoprGimO+nhlaz0uFiSYP8iYvjolC3/0DJARh
        TWjCMU2GLgr8DhJQb0mMs1l2IuXiahdylQ==
X-Google-Smtp-Source: ABdhPJxLj1e/WCXwjYQhN24wNkEVjpXHDZLELDbVrBV5t0YYirawE+RJcKOjpyzusMz/lduTyqsGweKfuUl38w==
X-Received: from dmatlack-heavy.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:19cd])
 (user=dmatlack job=sendgmr) by 2002:a17:90b:4d81:b0:1bf:8ce4:4f51 with SMTP
 id oj1-20020a17090b4d8100b001bf8ce44f51mr322491pjb.0.1646958335898; Thu, 10
 Mar 2022 16:25:35 -0800 (PST)
Date:   Fri, 11 Mar 2022 00:25:05 +0000
In-Reply-To: <20220311002528.2230172-1-dmatlack@google.com>
Message-Id: <20220311002528.2230172-4-dmatlack@google.com>
Mime-Version: 1.0
References: <20220311002528.2230172-1-dmatlack@google.com>
X-Mailer: git-send-email 2.35.1.723.g4982287a31-goog
Subject: [PATCH v2 03/26] KVM: x86/mmu: Derive shadow MMU page role from parent
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

Instead of computing the shadow page role from scratch for every new
page, we can derive most of the information from the parent shadow page.
This avoids redundant calculations and reduces the number of parameters
to kvm_mmu_get_page().

Preemptively split out the role calculation to a separate function for
use in a following commit.

No functional change intended.

Signed-off-by: David Matlack <dmatlack@google.com>
---
 arch/x86/kvm/mmu/mmu.c         | 91 ++++++++++++++++++++++++----------
 arch/x86/kvm/mmu/paging_tmpl.h |  9 ++--
 2 files changed, 71 insertions(+), 29 deletions(-)

diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index 146df73a982e..23c2004c6435 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -2027,30 +2027,14 @@ static void clear_sp_write_flooding_count(u64 *spte)
 	__clear_sp_write_flooding_count(sptep_to_sp(spte));
 }
 
-static struct kvm_mmu_page *kvm_mmu_get_page(struct kvm_vcpu *vcpu,
-					     gfn_t gfn,
-					     gva_t gaddr,
-					     unsigned level,
-					     bool direct,
-					     unsigned int access)
+static struct kvm_mmu_page *kvm_mmu_get_page(struct kvm_vcpu *vcpu, gfn_t gfn,
+					     union kvm_mmu_page_role role)
 {
-	union kvm_mmu_page_role role;
 	struct hlist_head *sp_list;
-	unsigned quadrant;
 	struct kvm_mmu_page *sp;
 	int collisions = 0;
 	LIST_HEAD(invalid_list);
 
-	role = vcpu->arch.mmu->mmu_role.base;
-	role.level = level;
-	role.direct = direct;
-	role.access = access;
-	if (role.has_4_byte_gpte) {
-		quadrant = gaddr >> (PAGE_SHIFT + (PT64_PT_BITS * level));
-		quadrant &= (1 << ((PT32_PT_BITS - PT64_PT_BITS) * level)) - 1;
-		role.quadrant = quadrant;
-	}
-
 	sp_list = &vcpu->kvm->arch.mmu_page_hash[kvm_page_table_hashfn(gfn)];
 	for_each_valid_sp(vcpu->kvm, sp, sp_list) {
 		if (sp->gfn != gfn) {
@@ -2068,7 +2052,7 @@ static struct kvm_mmu_page *kvm_mmu_get_page(struct kvm_vcpu *vcpu,
 			 * Unsync pages must not be left as is, because the new
 			 * upper-level page will be write-protected.
 			 */
-			if (level > PG_LEVEL_4K && sp->unsync)
+			if (role.level > PG_LEVEL_4K && sp->unsync)
 				kvm_mmu_prepare_zap_page(vcpu->kvm, sp,
 							 &invalid_list);
 			continue;
@@ -2107,14 +2091,14 @@ static struct kvm_mmu_page *kvm_mmu_get_page(struct kvm_vcpu *vcpu,
 
 	++vcpu->kvm->stat.mmu_cache_miss;
 
-	sp = kvm_mmu_alloc_page(vcpu, direct);
+	sp = kvm_mmu_alloc_page(vcpu, role.direct);
 
 	sp->gfn = gfn;
 	sp->role = role;
 	hlist_add_head(&sp->hash_link, sp_list);
-	if (!direct) {
+	if (!role.direct) {
 		account_shadowed(vcpu->kvm, sp);
-		if (level == PG_LEVEL_4K && kvm_vcpu_write_protect_gfn(vcpu, gfn))
+		if (role.level == PG_LEVEL_4K && kvm_vcpu_write_protect_gfn(vcpu, gfn))
 			kvm_flush_remote_tlbs_with_address(vcpu->kvm, gfn, 1);
 	}
 	trace_kvm_mmu_get_page(sp, true);
@@ -2126,6 +2110,51 @@ static struct kvm_mmu_page *kvm_mmu_get_page(struct kvm_vcpu *vcpu,
 	return sp;
 }
 
+static union kvm_mmu_page_role kvm_mmu_child_role(u64 *sptep, bool direct, u32 access)
+{
+	struct kvm_mmu_page *parent_sp = sptep_to_sp(sptep);
+	union kvm_mmu_page_role role;
+
+	role = parent_sp->role;
+	role.level--;
+	role.access = access;
+	role.direct = direct;
+
+	/*
+	 * If the guest has 4-byte PTEs then that means it's using 32-bit,
+	 * 2-level, non-PAE paging. KVM shadows such guests using 4 PAE page
+	 * directories, each mapping 1/4 of the guest's linear address space
+	 * (1GiB). The shadow pages for those 4 page directories are
+	 * pre-allocated and assigned a separate quadrant in their role.
+	 *
+	 * Since we are allocating a child shadow page and there are only 2
+	 * levels, this must be a PG_LEVEL_4K shadow page. Here the quadrant
+	 * will either be 0 or 1 because it maps 1/2 of the address space mapped
+	 * by the guest's PG_LEVEL_4K page table (or 4MiB huge page) that it
+	 * is shadowing. In this case, the quadrant can be derived by the index
+	 * of the SPTE that points to the new child shadow page in the page
+	 * directory (parent_sp). Specifically, every 2 SPTEs in parent_sp
+	 * shadow one half of a guest's page table (or 4MiB huge page) so the
+	 * quadrant is just the parity of the index of the SPTE.
+	 */
+	if (role.has_4_byte_gpte) {
+		BUG_ON(role.level != PG_LEVEL_4K);
+		role.quadrant = (sptep - parent_sp->spt) % 2;
+	}
+
+	return role;
+}
+
+static struct kvm_mmu_page *kvm_mmu_get_child_sp(struct kvm_vcpu *vcpu,
+						 u64 *sptep, gfn_t gfn,
+						 bool direct, u32 access)
+{
+	union kvm_mmu_page_role role;
+
+	role = kvm_mmu_child_role(sptep, direct, access);
+	return kvm_mmu_get_page(vcpu, gfn, role);
+}
+
 static void shadow_walk_init_using_root(struct kvm_shadow_walk_iterator *iterator,
 					struct kvm_vcpu *vcpu, hpa_t root,
 					u64 addr)
@@ -2930,8 +2959,7 @@ static int __direct_map(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault)
 		if (is_shadow_present_pte(*it.sptep))
 			continue;
 
-		sp = kvm_mmu_get_page(vcpu, base_gfn, it.addr,
-				      it.level - 1, true, ACC_ALL);
+		sp = kvm_mmu_get_child_sp(vcpu, it.sptep, base_gfn, true, ACC_ALL);
 
 		link_shadow_page(vcpu, it.sptep, sp);
 		if (fault->is_tdp && fault->huge_page_disallowed &&
@@ -3316,9 +3344,22 @@ static int mmu_check_root(struct kvm_vcpu *vcpu, gfn_t root_gfn)
 static hpa_t mmu_alloc_root(struct kvm_vcpu *vcpu, gfn_t gfn, gva_t gva,
 			    u8 level, bool direct)
 {
+	union kvm_mmu_page_role role;
 	struct kvm_mmu_page *sp;
+	unsigned int quadrant;
+
+	role = vcpu->arch.mmu->mmu_role.base;
+	role.level = level;
+	role.direct = direct;
+	role.access = ACC_ALL;
+
+	if (role.has_4_byte_gpte) {
+		quadrant = gva >> (PAGE_SHIFT + (PT64_PT_BITS * level));
+		quadrant &= (1 << ((PT32_PT_BITS - PT64_PT_BITS) * level)) - 1;
+		role.quadrant = quadrant;
+	}
 
-	sp = kvm_mmu_get_page(vcpu, gfn, gva, level, direct, ACC_ALL);
+	sp = kvm_mmu_get_page(vcpu, gfn, role);
 	++sp->root_count;
 
 	return __pa(sp->spt);
diff --git a/arch/x86/kvm/mmu/paging_tmpl.h b/arch/x86/kvm/mmu/paging_tmpl.h
index 252c77805eb9..c3909a07e938 100644
--- a/arch/x86/kvm/mmu/paging_tmpl.h
+++ b/arch/x86/kvm/mmu/paging_tmpl.h
@@ -683,8 +683,9 @@ static int FNAME(fetch)(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault,
 		if (!is_shadow_present_pte(*it.sptep)) {
 			table_gfn = gw->table_gfn[it.level - 2];
 			access = gw->pt_access[it.level - 2];
-			sp = kvm_mmu_get_page(vcpu, table_gfn, fault->addr,
-					      it.level-1, false, access);
+			sp = kvm_mmu_get_child_sp(vcpu, it.sptep, table_gfn,
+						  false, access);
+
 			/*
 			 * We must synchronize the pagetable before linking it
 			 * because the guest doesn't need to flush tlb when
@@ -740,8 +741,8 @@ static int FNAME(fetch)(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault,
 		drop_large_spte(vcpu, it.sptep);
 
 		if (!is_shadow_present_pte(*it.sptep)) {
-			sp = kvm_mmu_get_page(vcpu, base_gfn, fault->addr,
-					      it.level - 1, true, direct_access);
+			sp = kvm_mmu_get_child_sp(vcpu, it.sptep, base_gfn,
+						  true, direct_access);
 			link_shadow_page(vcpu, it.sptep, sp);
 			if (fault->huge_page_disallowed &&
 			    fault->req_level >= it.level)
-- 
2.35.1.723.g4982287a31-goog

