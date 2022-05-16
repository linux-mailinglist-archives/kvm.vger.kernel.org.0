Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D603852953D
	for <lists+kvm@lfdr.de>; Tue, 17 May 2022 01:22:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350340AbiEPXWz (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 16 May 2022 19:22:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60320 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1350368AbiEPXWU (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 16 May 2022 19:22:20 -0400
Received: from mail-pf1-x44a.google.com (mail-pf1-x44a.google.com [IPv6:2607:f8b0:4864:20::44a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A98014704E
        for <kvm@vger.kernel.org>; Mon, 16 May 2022 16:22:09 -0700 (PDT)
Received: by mail-pf1-x44a.google.com with SMTP id cn13-20020a056a00340d00b0050e0f04e467so6764935pfb.21
        for <kvm@vger.kernel.org>; Mon, 16 May 2022 16:22:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=UxU6llbJ6HBZvnaM/EEiEqyXtBTmOLKOiggl4KFhuBs=;
        b=P6lXkkncxE4eIZq2VhgSaZGfJYjY6JgVM7vssUpPdCGfSjLoDfUHhSD+t66pBcHEJ3
         qRswnFyZDupF1l48f2tBJPjRFWhjHkSb3zGIJKOMQM8K9hBsvTAxSra7Z2MC+dNgbXVV
         nXjVTUXFQ8MnHoZoj+juTn5gVl8CaLOw9z8XkzH/mDuWolL1Pf/J7YS2U+TfCutxAnIH
         JUCjTr+ooCCW/J2+4gPL73sHGMNn7SkOYYCa24LdEXOwohM4L1c0yk+vt3TEoCm2OSR5
         3hrAU5RTyT07qMiHwkk5HTEb1MvPh/AifAcodEkhaUPU+m/sNrXmn1mEf6lCsZ2WPI+y
         0dgA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=UxU6llbJ6HBZvnaM/EEiEqyXtBTmOLKOiggl4KFhuBs=;
        b=x8aO4mDqiPE/AMvo/zMXbTFJORwnpmX6OeyjzohQCdLCPCYz5H43CSJtcxRRFHhnht
         V3xx+9kzLcHwMIWcqtz8+Q0ZPfGeznEPJkddOMUvVkY1s/nCXoLVzP6kjtZTpQKUMiz0
         /953AyTSvcl50nZa5hPc4EwPhCD+Qpxpf8bKo5xOlzd0IcKOTXXOuIJNYbyi6BYltEv2
         bPmIH23ED2GMKFm6rmMcxFOC0b+s1BynuZ0RQ8KqwraIlbupEQBcyUCS9Gw+22G/WJnN
         j91bAQGRXAnn9/wq8FxjTDEAtmv0aUY5d6yAGY+gDS5LNOzOIL3Wq785hJJBUrdGKfBT
         uNNw==
X-Gm-Message-State: AOAM531PMYYOWUZrJak5h522erlgi6MI/KmP/bBNISo1A9nUp0bDv8c5
        zlDthf8+AxiY+IHIM74WtIY4jfYBR7OqCw==
X-Google-Smtp-Source: ABdhPJzbcm+ZIPmtIZ+O121bMrmKGdRtvqad6c2WtGn8W5/FXw1wzo6hbujq2MN2/GYzkicT21jpXtlddG64Vg==
X-Received: from dmatlack-heavy.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:19cd])
 (user=dmatlack job=sendgmr) by 2002:a17:90a:ab90:b0:1da:375f:2f44 with SMTP
 id n16-20020a17090aab9000b001da375f2f44mr21806399pjq.33.1652743328831; Mon,
 16 May 2022 16:22:08 -0700 (PDT)
Date:   Mon, 16 May 2022 23:21:33 +0000
In-Reply-To: <20220516232138.1783324-1-dmatlack@google.com>
Message-Id: <20220516232138.1783324-18-dmatlack@google.com>
Mime-Version: 1.0
References: <20220516232138.1783324-1-dmatlack@google.com>
X-Mailer: git-send-email 2.36.0.550.gb090851708-goog
Subject: [PATCH v6 17/22] KVM: x86/mmu: Cache the access bits of shadowed translations
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
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Splitting huge pages requires allocating/finding shadow pages to replace
the huge page. Shadow pages are keyed, in part, off the guest access
permissions they are shadowing. For fully direct MMUs, there is no
shadowing so the access bits in the shadow page role are always ACC_ALL.
But during shadow paging, the guest can enforce whatever access
permissions it wants.

When KVM is resolving a fault, it walks the guest pages tables to
determine the guest access permissions. But that is difficult to plumb
when splitting huge pages outside of a fault context, e.g. for eager
page splitting.

To enable eager page splitting, KVM can cache the shadowed (guest)
access permissions whenever it updates the shadow page tables (e.g.
during fault, or FNAME(sync_page)). In fact KVM already does this to
cache the shadowed GFN using the gfns array in the shadow page.
The access bits only take up 3 bits, which leaves 61 bits left over for
gfns, which is more than enough. So this change does not require any
additional memory.

Now that the gfns array caches more information than just GFNs, rename
it to shadowed_translation.

While here, preemptively fix up the WARN_ON() that detects gfn
mismatches in direct SPs. The WARN_ON() was paired with a
pr_err_ratelimited(), which means that users could sometimes see the
WARN without the accompanying error message. Fix this by outputting the
error message as part of the WARN splat.

Signed-off-by: David Matlack <dmatlack@google.com>
---
 arch/x86/include/asm/kvm_host.h |  2 +-
 arch/x86/kvm/mmu/mmu.c          | 85 +++++++++++++++++++++++----------
 arch/x86/kvm/mmu/mmu_internal.h | 17 ++++++-
 arch/x86/kvm/mmu/paging_tmpl.h  |  8 +++-
 4 files changed, 83 insertions(+), 29 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 9cdc5bbd721f..9193a700fe2d 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -710,7 +710,7 @@ struct kvm_vcpu_arch {
 
 	struct kvm_mmu_memory_cache mmu_pte_list_desc_cache;
 	struct kvm_mmu_memory_cache mmu_shadow_page_cache;
-	struct kvm_mmu_memory_cache mmu_gfn_array_cache;
+	struct kvm_mmu_memory_cache mmu_shadowed_info_cache;
 	struct kvm_mmu_memory_cache mmu_page_header_cache;
 
 	/*
diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index 6aef85dac1e2..f83de72feeac 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -682,7 +682,7 @@ static int mmu_topup_memory_caches(struct kvm_vcpu *vcpu, bool maybe_indirect)
 	if (r)
 		return r;
 	if (maybe_indirect) {
-		r = kvm_mmu_topup_memory_cache(&vcpu->arch.mmu_gfn_array_cache,
+		r = kvm_mmu_topup_memory_cache(&vcpu->arch.mmu_shadowed_info_cache,
 					       PT64_ROOT_MAX_LEVEL);
 		if (r)
 			return r;
@@ -695,7 +695,7 @@ static void mmu_free_memory_caches(struct kvm_vcpu *vcpu)
 {
 	kvm_mmu_free_memory_cache(&vcpu->arch.mmu_pte_list_desc_cache);
 	kvm_mmu_free_memory_cache(&vcpu->arch.mmu_shadow_page_cache);
-	kvm_mmu_free_memory_cache(&vcpu->arch.mmu_gfn_array_cache);
+	kvm_mmu_free_memory_cache(&vcpu->arch.mmu_shadowed_info_cache);
 	kvm_mmu_free_memory_cache(&vcpu->arch.mmu_page_header_cache);
 }
 
@@ -704,34 +704,68 @@ static void mmu_free_pte_list_desc(struct pte_list_desc *pte_list_desc)
 	kmem_cache_free(pte_list_desc_cache, pte_list_desc);
 }
 
+static bool sp_has_gptes(struct kvm_mmu_page *sp);
+
 static gfn_t kvm_mmu_page_get_gfn(struct kvm_mmu_page *sp, int index)
 {
 	if (sp->role.passthrough)
 		return sp->gfn;
 
 	if (!sp->role.direct)
-		return sp->gfns[index];
+		return sp->shadowed_translation[index] >> PAGE_SHIFT;
 
 	return sp->gfn + (index << ((sp->role.level - 1) * PT64_LEVEL_BITS));
 }
 
-static void kvm_mmu_page_set_gfn(struct kvm_mmu_page *sp, int index, gfn_t gfn)
+/*
+ * For leaf SPTEs, fetch the *guest* access permissions being shadowed. Note
+ * that the SPTE itself may have a more constrained access permissions that
+ * what the guest enforces. For example, a guest may create an executable
+ * huge PTE but KVM may disallow execution to mitigate iTLB multihit.
+ */
+static u32 kvm_mmu_page_get_access(struct kvm_mmu_page *sp, int index)
 {
-	if (sp->role.passthrough) {
-		WARN_ON_ONCE(gfn != sp->gfn);
-		return;
-	}
+	if (sp_has_gptes(sp))
+		return sp->shadowed_translation[index] & ACC_ALL;
 
-	if (!sp->role.direct) {
-		sp->gfns[index] = gfn;
+	/*
+	 * For direct MMUs (e.g. TDP or non-paging guests) or passthrough SPs,
+	 * KVM is not shadowing any guest page tables, so the "guest access
+	 * permissions" are just ACC_ALL.
+	 *
+	 * For direct SPs in indirect MMUs (shadow paging), i.e. when KVM
+	 * is shadowing a guest huge page with small pages, the guest access
+	 * permissions being shadowed are the access permissions of the huge
+	 * page.
+	 *
+	 * In both cases, sp->role.access contains the correct access bits.
+	 */
+	return sp->role.access;
+}
+
+static void kvm_mmu_page_set_translation(struct kvm_mmu_page *sp, int index, gfn_t gfn, u32 access)
+{
+	if (sp_has_gptes(sp)) {
+		sp->shadowed_translation[index] = (gfn << PAGE_SHIFT) | access;
 		return;
 	}
 
-	if (WARN_ON(gfn != kvm_mmu_page_get_gfn(sp, index)))
-		pr_err_ratelimited("gfn mismatch under direct page %llx "
-				   "(expected %llx, got %llx)\n",
-				   sp->gfn,
-				   kvm_mmu_page_get_gfn(sp, index), gfn);
+	WARN(access != kvm_mmu_page_get_access(sp, index),
+	     "access mismatch under %s page %llx (expected %u, got %u)\n",
+	     sp->role.passthrough ? "passthrough" : "direct",
+	     sp->gfn, kvm_mmu_page_get_access(sp, index), access);
+
+	WARN(gfn != kvm_mmu_page_get_gfn(sp, index),
+	     "gfn mismatch under %s page %llx (expected %llx, got %llx)\n",
+	     sp->role.passthrough ? "passthrough" : "direct",
+	     sp->gfn, kvm_mmu_page_get_gfn(sp, index), gfn);
+}
+
+static void kvm_mmu_page_set_access(struct kvm_mmu_page *sp, int index, u32 access)
+{
+	gfn_t gfn = kvm_mmu_page_get_gfn(sp, index);
+
+	kvm_mmu_page_set_translation(sp, index, gfn, access);
 }
 
 /*
@@ -1580,14 +1614,14 @@ static bool kvm_test_age_rmapp(struct kvm *kvm, struct kvm_rmap_head *rmap_head,
 static void __rmap_add(struct kvm *kvm,
 		       struct kvm_mmu_memory_cache *cache,
 		       const struct kvm_memory_slot *slot,
-		       u64 *spte, gfn_t gfn)
+		       u64 *spte, gfn_t gfn, u32 access)
 {
 	struct kvm_mmu_page *sp;
 	struct kvm_rmap_head *rmap_head;
 	int rmap_count;
 
 	sp = sptep_to_sp(spte);
-	kvm_mmu_page_set_gfn(sp, spte - sp->spt, gfn);
+	kvm_mmu_page_set_translation(sp, spte - sp->spt, gfn, access);
 	kvm_update_page_stats(kvm, sp->role.level, 1);
 
 	rmap_head = gfn_to_rmap(gfn, sp->role.level, slot);
@@ -1601,9 +1635,9 @@ static void __rmap_add(struct kvm *kvm,
 }
 
 static void rmap_add(struct kvm_vcpu *vcpu, const struct kvm_memory_slot *slot,
-		     u64 *spte, gfn_t gfn)
+		     u64 *spte, gfn_t gfn, u32 access)
 {
-	__rmap_add(vcpu->kvm, &vcpu->arch.mmu_pte_list_desc_cache, slot, spte, gfn);
+	__rmap_add(vcpu->kvm, &vcpu->arch.mmu_pte_list_desc_cache, slot, spte, gfn, access);
 }
 
 bool kvm_age_gfn(struct kvm *kvm, struct kvm_gfn_range *range)
@@ -1667,7 +1701,7 @@ static void kvm_mmu_free_shadow_page(struct kvm_mmu_page *sp)
 	list_del(&sp->link);
 	free_page((unsigned long)sp->spt);
 	if (!sp->role.direct)
-		free_page((unsigned long)sp->gfns);
+		free_page((unsigned long)sp->shadowed_translation);
 	kmem_cache_free(mmu_page_header_cache, sp);
 }
 
@@ -2097,7 +2131,7 @@ static struct kvm_mmu_page *kvm_mmu_find_shadow_page(struct kvm *kvm,
 struct shadow_page_caches {
 	struct kvm_mmu_memory_cache *page_header_cache;
 	struct kvm_mmu_memory_cache *shadow_page_cache;
-	struct kvm_mmu_memory_cache *gfn_array_cache;
+	struct kvm_mmu_memory_cache *shadowed_info_cache;
 };
 
 static struct kvm_mmu_page *kvm_mmu_alloc_shadow_page(struct kvm *kvm,
@@ -2111,7 +2145,7 @@ static struct kvm_mmu_page *kvm_mmu_alloc_shadow_page(struct kvm *kvm,
 	sp = kvm_mmu_memory_cache_alloc(caches->page_header_cache);
 	sp->spt = kvm_mmu_memory_cache_alloc(caches->shadow_page_cache);
 	if (!role.direct)
-		sp->gfns = kvm_mmu_memory_cache_alloc(caches->gfn_array_cache);
+		sp->shadowed_translation = kvm_mmu_memory_cache_alloc(caches->shadowed_info_cache);
 
 	set_page_private(virt_to_page(sp->spt), (unsigned long)sp);
 
@@ -2163,7 +2197,7 @@ static struct kvm_mmu_page *kvm_mmu_get_shadow_page(struct kvm_vcpu *vcpu,
 	struct shadow_page_caches caches = {
 		.page_header_cache = &vcpu->arch.mmu_page_header_cache,
 		.shadow_page_cache = &vcpu->arch.mmu_shadow_page_cache,
-		.gfn_array_cache = &vcpu->arch.mmu_gfn_array_cache,
+		.shadowed_info_cache = &vcpu->arch.mmu_shadowed_info_cache,
 	};
 
 	return __kvm_mmu_get_shadow_page(vcpu->kvm, vcpu, &caches, gfn, role);
@@ -2812,7 +2846,10 @@ static int mmu_set_spte(struct kvm_vcpu *vcpu, struct kvm_memory_slot *slot,
 
 	if (!was_rmapped) {
 		WARN_ON_ONCE(ret == RET_PF_SPURIOUS);
-		rmap_add(vcpu, slot, sptep, gfn);
+		rmap_add(vcpu, slot, sptep, gfn, pte_access);
+	} else {
+		/* Already rmapped but the pte_access bits may have changed. */
+		kvm_mmu_page_set_access(sp, sptep - sp->spt, pte_access);
 	}
 
 	return ret;
diff --git a/arch/x86/kvm/mmu/mmu_internal.h b/arch/x86/kvm/mmu/mmu_internal.h
index bd2a26897b97..0395950045d1 100644
--- a/arch/x86/kvm/mmu/mmu_internal.h
+++ b/arch/x86/kvm/mmu/mmu_internal.h
@@ -53,8 +53,21 @@ struct kvm_mmu_page {
 	gfn_t gfn;
 
 	u64 *spt;
-	/* hold the gfn of each spte inside spt */
-	gfn_t *gfns;
+
+	/*
+	 * Stores the result of the guest translation being shadowed by each
+	 * SPTE.  KVM shadows two types of guest translations: nGPA -> GPA
+	 * (shadow EPT/NPT) and GVA -> GPA (traditional shadow paging). In both
+	 * cases the result of the translation is a GPA and a set of access
+	 * constraints.
+	 *
+	 * The GFN is stored in the upper bits (PAGE_SHIFT) and the shadowed
+	 * access permissions are stored in the lower bits. Note, for
+	 * convenience and uniformity across guests, the access permissions are
+	 * stored in KVM format (e.g.  ACC_EXEC_MASK) not the raw guest format.
+	 */
+	u64 *shadowed_translation;
+
 	/* Currently serving as active root */
 	union {
 		int root_count;
diff --git a/arch/x86/kvm/mmu/paging_tmpl.h b/arch/x86/kvm/mmu/paging_tmpl.h
index fd73c857af90..37ceb6e452e6 100644
--- a/arch/x86/kvm/mmu/paging_tmpl.h
+++ b/arch/x86/kvm/mmu/paging_tmpl.h
@@ -979,7 +979,8 @@ static gpa_t FNAME(gva_to_gpa)(struct kvm_vcpu *vcpu, struct kvm_mmu *mmu,
 }
 
 /*
- * Using the cached information from sp->gfns is safe because:
+ * Using the information in sp->shadowed_translation (kvm_mmu_page_get_gfn()) is
+ * safe because:
  * - The spte has a reference to the struct page, so the pfn for a given gfn
  *   can't change unless all sptes pointing to it are nuked first.
  *
@@ -1054,12 +1055,15 @@ static int FNAME(sync_page)(struct kvm_vcpu *vcpu, struct kvm_mmu_page *sp)
 		if (sync_mmio_spte(vcpu, &sp->spt[i], gfn, pte_access))
 			continue;
 
-		if (gfn != sp->gfns[i]) {
+		if (gfn != kvm_mmu_page_get_gfn(sp, i)) {
 			drop_spte(vcpu->kvm, &sp->spt[i]);
 			flush = true;
 			continue;
 		}
 
+		/* Update the shadowed access bits in case they changed. */
+		kvm_mmu_page_set_access(sp, i, pte_access);
+
 		sptep = &sp->spt[i];
 		spte = *sptep;
 		host_writable = spte & shadow_host_writable_mask;
-- 
2.36.0.550.gb090851708-goog

