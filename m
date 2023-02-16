Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0CDB569A2A9
	for <lists+kvm@lfdr.de>; Fri, 17 Feb 2023 00:52:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230100AbjBPXwg (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 16 Feb 2023 18:52:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51866 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229614AbjBPXwe (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 16 Feb 2023 18:52:34 -0500
Received: from mail-pj1-x102c.google.com (mail-pj1-x102c.google.com [IPv6:2607:f8b0:4864:20::102c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8E00F5381D;
        Thu, 16 Feb 2023 15:52:32 -0800 (PST)
Received: by mail-pj1-x102c.google.com with SMTP id d2-20020a17090a498200b00236679bc70cso411935pjh.4;
        Thu, 16 Feb 2023 15:52:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=kQHFsymwP1ZZLc0CFl6UQv9PCMMVPDakGTSI35SyXo8=;
        b=j8dM48D1yPnvJXNL0l3p+ZrMTIijcSe9Sh/B1SKrGF6dTSH9zeNUcIzNJdFvw8J1Uv
         n4I9dlNhFGbTp7pUkEdm0+t9J4V+A7QP2oAkNOhtdcQBjTwn3O/fvI0SFIqjehZZXGki
         150EmfxC2d2TkzKbxX9xkMYLKkcGxYjjAHFRbYlhJMeLpcsLm+wu8a8E7aYN/+7W/05i
         SpYziElQ4eO2mvt56bHgOdB8KADA+jSOthDszDll5mGI6asay/PoyT0MpBIdNjeqQvXY
         M+xiw/Hbdflyt34VmTDsIjTWE4JBXUZEk5wkIsPXi3T0R1+6H2iwkjayV+CKhU9PkUCO
         y96w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=kQHFsymwP1ZZLc0CFl6UQv9PCMMVPDakGTSI35SyXo8=;
        b=sXNHDWBoVXHAxhk32jKxeH7pDqmkT3I+izb/0ksKusD3P54tSZkLlNEvFdSO5SZdrE
         V35r26AP/4X60+k089UbTwpce7Pcgb2jU6i2mBb0wsu17XWFIOgcesIKIQ5j0N3RNCWF
         ujuWOoAWGeGkTbIwLj3hiD0Q/jvOUnKa7h5CXSuVvfzln6B3HdvMQbizPfMA8qRT/7dJ
         9mn5odcarKCxvleN163MF1j5VmnxotUDvuATshBDMhx5TX0fDBzUOzI6u49AK+Mo8n5K
         2imiv9F3vjEvM2GFPq11XLgMiZiAHSNOxYo/oZtXTHOGfRLLbWbJrgs1pmZR9hZcwt1y
         MV+A==
X-Gm-Message-State: AO0yUKVsbAvoOl0jSH94H4Kmq4T4yJGS0ngdXz708slWE+olIdz9Co2n
        ExiOUgbEeJXA2afwRAYnvZ+vJKubk+E=
X-Google-Smtp-Source: AK7set/qPa6z8JxZhJvhjWgBZtOAHVA1bWMO2sDIblORgkkRNg4v+TSkQSLYRzNsosJwtAM5TO3KIQ==
X-Received: by 2002:a17:903:1388:b0:19a:b869:f2f8 with SMTP id jx8-20020a170903138800b0019ab869f2f8mr6093825plb.21.1676591551765;
        Thu, 16 Feb 2023 15:52:31 -0800 (PST)
Received: from localhost ([47.254.32.37])
        by smtp.gmail.com with ESMTPSA id a14-20020a170902ecce00b0019934030f46sm1840279plh.132.2023.02.16.15.52.30
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 16 Feb 2023 15:52:30 -0800 (PST)
From:   Lai Jiangshan <jiangshanlai@gmail.com>
To:     linux-kernel@vger.kernel.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Lai Jiangshan <jiangshan.ljs@antgroup.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org,
        "H. Peter Anvin" <hpa@zytor.com>, kvm@vger.kernel.org
Subject: [PATCH V3 12/14] kvm: x86/mmu: Remove FNAME(invlpg) and use FNAME(sync_spte) to update vTLB instead.
Date:   Fri, 17 Feb 2023 07:53:19 +0800
Message-Id: <20230216235321.735214-3-jiangshanlai@gmail.com>
X-Mailer: git-send-email 2.19.1.6.gb485710b
In-Reply-To: <20230216235321.735214-1-jiangshanlai@gmail.com>
References: <20230216154115.710033-1-jiangshanlai@gmail.com>
 <20230216235321.735214-1-jiangshanlai@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Lai Jiangshan <jiangshan.ljs@antgroup.com>

In hardware TLB, invalidating TLB entries means the translations are
removed from the TLB.

In KVM shadowed vTLB, the translations (combinations of shadow paging
and hardware TLB) are generally maintained as long as they remain clean
when the TLB of an address space (i.e. a PCID or all) is flushed with
the help of write-protections, sp->unsync, and kvm_sync_page().

However, a single vTLB entry is always removed in FNAME(invlpg) if
sp->unsync and then recreated, and thus a remote flush is required
even the original vTLB entry is clean.

Besides this, it is a duplicate implementation of FNAME(sync_spte) to
invalidate a vTLB entry.

To address this, FNAME(sync_spte) can be used to share the code and
slightly modify the semantics, where clean vTLB entries are kept.

Signed-off-by: Lai Jiangshan <jiangshan.ljs@antgroup.com>
---
 arch/x86/include/asm/kvm_host.h |  1 -
 arch/x86/kvm/mmu/mmu.c          | 56 ++++++++++++++++++++++----------
 arch/x86/kvm/mmu/paging_tmpl.h  | 57 ---------------------------------
 3 files changed, 39 insertions(+), 75 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index cce4243d6688..79dbf20ca026 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -447,7 +447,6 @@ struct kvm_mmu {
 			    struct x86_exception *exception);
 	int (*sync_spte)(struct kvm_vcpu *vcpu,
 			 struct kvm_mmu_page *sp, int i);
-	void (*invlpg)(struct kvm_vcpu *vcpu, u64 addr, hpa_t root_hpa);
 	struct kvm_mmu_root_info root;
 	union kvm_cpu_role cpu_role;
 	union kvm_mmu_page_role root_role;
diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index 7d5ff2b0f6d5..a8ac37d51287 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -1073,14 +1073,6 @@ static struct kvm_rmap_head *gfn_to_rmap(gfn_t gfn, int level,
 	return &slot->arch.rmap[level - PG_LEVEL_4K][idx];
 }
 
-static bool rmap_can_add(struct kvm_vcpu *vcpu)
-{
-	struct kvm_mmu_memory_cache *mc;
-
-	mc = &vcpu->arch.mmu_pte_list_desc_cache;
-	return kvm_mmu_memory_cache_nr_free_objects(mc);
-}
-
 static void rmap_remove(struct kvm *kvm, u64 *spte)
 {
 	struct kvm_memslots *slots;
@@ -4527,7 +4519,6 @@ static void nonpaging_init_context(struct kvm_mmu *context)
 	context->page_fault = nonpaging_page_fault;
 	context->gva_to_gpa = nonpaging_gva_to_gpa;
 	context->sync_spte = NULL;
-	context->invlpg = NULL;
 }
 
 static inline bool is_root_usable(struct kvm_mmu_root_info *root, gpa_t pgd,
@@ -5118,7 +5109,6 @@ static void paging64_init_context(struct kvm_mmu *context)
 	context->page_fault = paging64_page_fault;
 	context->gva_to_gpa = paging64_gva_to_gpa;
 	context->sync_spte = paging64_sync_spte;
-	context->invlpg = paging64_invlpg;
 }
 
 static void paging32_init_context(struct kvm_mmu *context)
@@ -5126,7 +5116,6 @@ static void paging32_init_context(struct kvm_mmu *context)
 	context->page_fault = paging32_page_fault;
 	context->gva_to_gpa = paging32_gva_to_gpa;
 	context->sync_spte = paging32_sync_spte;
-	context->invlpg = paging32_invlpg;
 }
 
 static union kvm_cpu_role
@@ -5215,7 +5204,6 @@ static void init_kvm_tdp_mmu(struct kvm_vcpu *vcpu,
 	context->root_role.word = root_role.word;
 	context->page_fault = kvm_tdp_page_fault;
 	context->sync_spte = NULL;
-	context->invlpg = NULL;
 	context->get_guest_pgd = get_cr3;
 	context->get_pdptr = kvm_pdptr_read;
 	context->inject_page_fault = kvm_inject_page_fault;
@@ -5347,7 +5335,6 @@ void kvm_init_shadow_ept_mmu(struct kvm_vcpu *vcpu, bool execonly,
 		context->page_fault = ept_page_fault;
 		context->gva_to_gpa = ept_gva_to_gpa;
 		context->sync_spte = ept_sync_spte;
-		context->invlpg = ept_invlpg;
 
 		update_permission_bitmask(context, true);
 		context->pkru_mask = 0;
@@ -5388,7 +5375,7 @@ static void init_kvm_nested_mmu(struct kvm_vcpu *vcpu,
 	 * L2 page tables are never shadowed, so there is no need to sync
 	 * SPTEs.
 	 */
-	g_context->invlpg            = NULL;
+	g_context->sync_spte         = NULL;
 
 	/*
 	 * Note that arch.mmu->gva_to_gpa translates l2_gpa to l1_gpa using
@@ -5763,6 +5750,41 @@ int noinline kvm_mmu_page_fault(struct kvm_vcpu *vcpu, gpa_t cr2_or_gpa, u64 err
 }
 EXPORT_SYMBOL_GPL(kvm_mmu_page_fault);
 
+static void __kvm_mmu_invalidate_addr(struct kvm_vcpu *vcpu, struct kvm_mmu *mmu,
+				      u64 addr, hpa_t root_hpa)
+{
+	struct kvm_shadow_walk_iterator iterator;
+
+	vcpu_clear_mmio_info(vcpu, addr);
+
+	if (!VALID_PAGE(root_hpa))
+		return;
+
+	write_lock(&vcpu->kvm->mmu_lock);
+	for_each_shadow_entry_using_root(vcpu, root_hpa, addr, iterator) {
+		struct kvm_mmu_page *sp = sptep_to_sp(iterator.sptep);
+
+		if (sp->unsync) {
+			/*
+			 * Get the gfn beforehand for later flushing.
+			 * Although mmu->sync_spte() doesn't change it, but just
+			 * avoid the dependence.
+			 */
+			gfn_t gfn = kvm_mmu_page_get_gfn(sp, iterator.index);
+			int ret = mmu->sync_spte(vcpu, sp, iterator.index);
+
+			if (ret < 0)
+				mmu_page_zap_pte(vcpu->kvm, sp, iterator.sptep, NULL);
+			if (ret)
+				kvm_flush_remote_tlbs_gfn(vcpu->kvm, gfn, PG_LEVEL_4K);
+		}
+
+		if (!sp->unsync_children)
+			break;
+	}
+	write_unlock(&vcpu->kvm->mmu_lock);
+}
+
 void kvm_mmu_invalidate_addr(struct kvm_vcpu *vcpu, struct kvm_mmu *mmu,
 			     u64 addr, unsigned long roots)
 {
@@ -5779,15 +5801,15 @@ void kvm_mmu_invalidate_addr(struct kvm_vcpu *vcpu, struct kvm_mmu *mmu,
 		static_call(kvm_x86_flush_tlb_gva)(vcpu, addr);
 	}
 
-	if (!mmu->invlpg)
+	if (!mmu->sync_spte)
 		return;
 
 	if (roots & KVM_MMU_ROOT_CURRENT)
-		mmu->invlpg(vcpu, addr, mmu->root.hpa);
+		__kvm_mmu_invalidate_addr(vcpu, mmu, addr, mmu->root.hpa);
 
 	for (i = 0; i < KVM_MMU_NUM_PREV_ROOTS; i++) {
 		if (roots & KVM_MMU_ROOT_PREVIOUS(i))
-			mmu->invlpg(vcpu, addr, mmu->prev_roots[i].hpa);
+			__kvm_mmu_invalidate_addr(vcpu, mmu, addr, mmu->prev_roots[i].hpa);
 	}
 }
 EXPORT_SYMBOL_GPL(kvm_mmu_invalidate_addr);
diff --git a/arch/x86/kvm/mmu/paging_tmpl.h b/arch/x86/kvm/mmu/paging_tmpl.h
index 9be5a0f22a9f..fca5ce349d9d 100644
--- a/arch/x86/kvm/mmu/paging_tmpl.h
+++ b/arch/x86/kvm/mmu/paging_tmpl.h
@@ -887,63 +887,6 @@ static gpa_t FNAME(get_level1_sp_gpa)(struct kvm_mmu_page *sp)
 	return gfn_to_gpa(sp->gfn) + offset * sizeof(pt_element_t);
 }
 
-/* Note, @addr is a GPA when invlpg() invalidates an L2 GPA translation in shadowed TDP */
-static void FNAME(invlpg)(struct kvm_vcpu *vcpu, u64 addr, hpa_t root_hpa)
-{
-	struct kvm_shadow_walk_iterator iterator;
-	struct kvm_mmu_page *sp;
-	u64 old_spte;
-	int level;
-	u64 *sptep;
-
-	vcpu_clear_mmio_info(vcpu, addr);
-
-	/*
-	 * No need to check return value here, rmap_can_add() can
-	 * help us to skip pte prefetch later.
-	 */
-	mmu_topup_memory_caches(vcpu, true);
-
-	if (!VALID_PAGE(root_hpa))
-		return;
-
-	write_lock(&vcpu->kvm->mmu_lock);
-	for_each_shadow_entry_using_root(vcpu, root_hpa, addr, iterator) {
-		level = iterator.level;
-		sptep = iterator.sptep;
-
-		sp = sptep_to_sp(sptep);
-		old_spte = *sptep;
-		if (is_last_spte(old_spte, level)) {
-			pt_element_t gpte;
-			gpa_t pte_gpa;
-
-			if (!sp->unsync)
-				break;
-
-			pte_gpa = FNAME(get_level1_sp_gpa)(sp);
-			pte_gpa += spte_index(sptep) * sizeof(pt_element_t);
-
-			mmu_page_zap_pte(vcpu->kvm, sp, sptep, NULL);
-			if (is_shadow_present_pte(old_spte))
-				kvm_flush_remote_tlbs_sptep(vcpu->kvm, sptep);
-
-			if (!rmap_can_add(vcpu))
-				break;
-
-			if (kvm_vcpu_read_guest_atomic(vcpu, pte_gpa, &gpte,
-						       sizeof(pt_element_t)))
-				break;
-
-			FNAME(prefetch_gpte)(vcpu, sp, sptep, gpte, false);
-		}
-
-		if (!sp->unsync_children)
-			break;
-	}
-	write_unlock(&vcpu->kvm->mmu_lock);
-}
-
 /* Note, @addr is a GPA when gva_to_gpa() translates an L2 GPA to an L1 GPA. */
 static gpa_t FNAME(gva_to_gpa)(struct kvm_vcpu *vcpu, struct kvm_mmu *mmu,
 			       gpa_t addr, u64 access,
-- 
2.19.1.6.gb485710b

