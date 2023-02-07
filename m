Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 75A1068DD75
	for <lists+kvm@lfdr.de>; Tue,  7 Feb 2023 16:57:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232752AbjBGP5j (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 7 Feb 2023 10:57:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54576 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232726AbjBGP5N (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 7 Feb 2023 10:57:13 -0500
Received: from mail-pf1-x42c.google.com (mail-pf1-x42c.google.com [IPv6:2607:f8b0:4864:20::42c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8EACA3D09C;
        Tue,  7 Feb 2023 07:56:56 -0800 (PST)
Received: by mail-pf1-x42c.google.com with SMTP id ea13so1791202pfb.13;
        Tue, 07 Feb 2023 07:56:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=IO+JMapXJDsVghpHInjqEBNXRoXI+h2VyeiakV33xtE=;
        b=PzaMe5XudmvXBLGLehAPnf3zt/QAijE3r/Bzs8KqzLkjQ3RKtv82dsloHYRr89a6pf
         DZnufhXM4lwpZDEnRPk+FyV7//M70L+EjHQUxRwJWq/qJLTP3KB3XC615TUAmq4YKCS3
         MvCAKocI3ENNOaC6yhsgHluB0LH+efDdFHZXAgWI7TeqtG/w+nRdhtD1OD2abc5S6M0m
         K5iu2NdGPSICimJ1fgJoXj6UUTuUVzc4cNRnIrY/OEF0uPRMNBFklIAI4ZsQa1DdvNvn
         E/+iaiAaEQ9+BO9CLrTJEAIwa7WEejI5Pl0FtSYj3i+QpVfl6UvV+dEr498kiKA6HzoS
         kN1Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=IO+JMapXJDsVghpHInjqEBNXRoXI+h2VyeiakV33xtE=;
        b=YU5IpxAhtBOJ1sg1oqiM/6pRdxv0VgV6gatYR5qgn5+pQZwZ/5rQmn9CkUETPhChuN
         hyn6qEDmm+j/Q+2lYbbFEMUkuAZIG/U4r5k+Vm5jFIPOGGOmSqR/+pBzrwn8xuQ13ijp
         V4R/UK7AyDyUP4PWhjfPnGG42X3TOBGR5bXar7aSKb/aY9W9tUT6zCBwmUGq9Qz6LTKT
         e4MPPtx0tegh4YsE/4Slh8cOLy/dbylq7XUymI/Nzknaf1q6wSZaQZjGKBxGVKwUzTZu
         GU3gVJTXpmyIlg7dddvOOXGA1ZIjyWPJ/ZSfjtfirrHuIVY8CUsGtGDpP8IbrBKrkmDC
         qGdg==
X-Gm-Message-State: AO0yUKVeGzkml9w+FWg4drv/FwziVAyBJVO1CG1pLFsTTgQnzIithf8h
        QsWNB1hPd3r/x9s9nPcF6NQy0G8vIe4=
X-Google-Smtp-Source: AK7set8047yit0338Qn0QMgF0JPAjYzonfdm9VZuck+g/PtCLQRsKQ3oBxHgJ6H+jotFyH77/utYHg==
X-Received: by 2002:a62:6d85:0:b0:590:7616:41eb with SMTP id i127-20020a626d85000000b00590761641ebmr3114790pfc.30.1675785403870;
        Tue, 07 Feb 2023 07:56:43 -0800 (PST)
Received: from localhost ([198.11.178.15])
        by smtp.gmail.com with ESMTPSA id p18-20020a62ab12000000b005a7135a0290sm2014900pff.161.2023.02.07.07.56.42
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 07 Feb 2023 07:56:43 -0800 (PST)
From:   Lai Jiangshan <jiangshanlai@gmail.com>
To:     linux-kernel@vger.kernel.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Lai Jiangshan <jiangshan.ljs@antgroup.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org,
        "H. Peter Anvin" <hpa@zytor.com>, kvm@vger.kernel.org
Subject: [PATCH V2 6/8] kvm: x86/mmu: Remove FNAME(invlpg)
Date:   Tue,  7 Feb 2023 23:57:32 +0800
Message-Id: <20230207155735.2845-7-jiangshanlai@gmail.com>
X-Mailer: git-send-email 2.19.1.6.gb485710b
In-Reply-To: <20230207155735.2845-1-jiangshanlai@gmail.com>
References: <20230207155735.2845-1-jiangshanlai@gmail.com>
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

Use FNAME(sync_spte) to invalidate vTLB instead.

In hardware TLB, invalidating TLB entries means the translations are
removed from the TLB.

In kvm shadowed vTLB, vTLB translations (combinations of shadowpaging
and hardware TLB) are usually kept as long as they are clean when flushing
TLB of an address space (a PCID or all) with the help of write-protections,
sp->unsync, kvm_sync_page().

But a single vTLB entry is always removed in FNAME(invlpg) if sp->unsync
and then prefetched.  And clean vTLB entry is always removed and a new one
is recreated.  The new one might be failed to be created or different
(with more permission) and a remote flush is always requred.

Above all, it is duplicate implementation of FNAME(sync_spte) to invalidate
a vTLB entry.  

Use FNAME(sync_spte) to share the code which has a slight semantics
changed: clean vTLB entry is kept.

Signed-off-by: Lai Jiangshan <jiangshan.ljs@antgroup.com>
---
 arch/x86/include/asm/kvm_host.h |  1 -
 arch/x86/kvm/mmu/mmu.c          | 48 +++++++++++++++++----------
 arch/x86/kvm/mmu/paging_tmpl.h  | 58 ---------------------------------
 3 files changed, 31 insertions(+), 76 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 6c64ebfbd778..86ae8f6419f1 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -443,7 +443,6 @@ struct kvm_mmu {
 			    struct x86_exception *exception);
 	int (*sync_spte)(struct kvm_vcpu *vcpu,
 			 struct kvm_mmu_page *sp, int i);
-	void (*invlpg)(struct kvm_vcpu *vcpu, gva_t gva, hpa_t root_hpa);
 	struct kvm_mmu_root_info root;
 	union kvm_cpu_role cpu_role;
 	union kvm_mmu_page_role root_role;
diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index c271d0a1ed54..3880f98a9cb6 100644
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
@@ -4516,7 +4508,6 @@ static void nonpaging_init_context(struct kvm_mmu *context)
 	context->page_fault = nonpaging_page_fault;
 	context->gva_to_gpa = nonpaging_gva_to_gpa;
 	context->sync_spte = NULL;
-	context->invlpg = NULL;
 }
 
 static inline bool is_root_usable(struct kvm_mmu_root_info *root, gpa_t pgd,
@@ -5107,7 +5098,6 @@ static void paging64_init_context(struct kvm_mmu *context)
 	context->page_fault = paging64_page_fault;
 	context->gva_to_gpa = paging64_gva_to_gpa;
 	context->sync_spte = paging64_sync_spte;
-	context->invlpg = paging64_invlpg;
 }
 
 static void paging32_init_context(struct kvm_mmu *context)
@@ -5115,7 +5105,6 @@ static void paging32_init_context(struct kvm_mmu *context)
 	context->page_fault = paging32_page_fault;
 	context->gva_to_gpa = paging32_gva_to_gpa;
 	context->sync_spte = paging32_sync_spte;
-	context->invlpg = paging32_invlpg;
 }
 
 static union kvm_cpu_role
@@ -5204,7 +5193,6 @@ static void init_kvm_tdp_mmu(struct kvm_vcpu *vcpu,
 	context->root_role.word = root_role.word;
 	context->page_fault = kvm_tdp_page_fault;
 	context->sync_spte = NULL;
-	context->invlpg = NULL;
 	context->get_guest_pgd = get_cr3;
 	context->get_pdptr = kvm_pdptr_read;
 	context->inject_page_fault = kvm_inject_page_fault;
@@ -5336,7 +5324,6 @@ void kvm_init_shadow_ept_mmu(struct kvm_vcpu *vcpu, bool execonly,
 		context->page_fault = ept_page_fault;
 		context->gva_to_gpa = ept_gva_to_gpa;
 		context->sync_spte = ept_sync_spte;
-		context->invlpg = ept_invlpg;
 
 		update_permission_bitmask(context, true);
 		context->pkru_mask = 0;
@@ -5377,7 +5364,7 @@ static void init_kvm_nested_mmu(struct kvm_vcpu *vcpu,
 	 * L2 page tables are never shadowed, so there is no need to sync
 	 * SPTEs.
 	 */
-	g_context->invlpg            = NULL;
+	g_context->sync_spte         = NULL;
 
 	/*
 	 * Note that arch.mmu->gva_to_gpa translates l2_gpa to l1_gpa using
@@ -5752,6 +5739,33 @@ int noinline kvm_mmu_page_fault(struct kvm_vcpu *vcpu, gpa_t cr2_or_gpa, u64 err
 }
 EXPORT_SYMBOL_GPL(kvm_mmu_page_fault);
 
+static void __kvm_mmu_invalidate_gva(struct kvm_vcpu *vcpu, struct kvm_mmu *mmu,
+				     gva_t gva, hpa_t root_hpa)
+{
+	struct kvm_shadow_walk_iterator iterator;
+
+	vcpu_clear_mmio_info(vcpu, gva);
+
+	write_lock(&vcpu->kvm->mmu_lock);
+	for_each_shadow_entry_using_root(vcpu, root_hpa, gva, iterator) {
+		struct kvm_mmu_page *sp = sptep_to_sp(iterator.sptep);
+
+		if (sp->unsync && *iterator.sptep) {
+			gfn_t gfn = kvm_mmu_page_get_gfn(sp, iterator.index);
+			int ret = mmu->sync_spte(vcpu, sp, iterator.index);
+
+			if (ret < 0)
+				mmu_page_zap_pte(vcpu->kvm, sp, iterator.sptep, NULL);
+			if (ret)
+				kvm_flush_remote_tlbs_with_address(vcpu->kvm, gfn, 1);
+		}
+
+		if (!sp->unsync_children)
+			break;
+	}
+	write_unlock(&vcpu->kvm->mmu_lock);
+}
+
 void kvm_mmu_invalidate_gva(struct kvm_vcpu *vcpu, struct kvm_mmu *mmu,
 			    gva_t gva, unsigned long roots)
 {
@@ -5768,16 +5782,16 @@ void kvm_mmu_invalidate_gva(struct kvm_vcpu *vcpu, struct kvm_mmu *mmu,
 		static_call(kvm_x86_flush_tlb_gva)(vcpu, gva);
 	}
 
-	if (!mmu->invlpg)
+	if (!mmu->sync_spte)
 		return;
 
 	if ((roots & KVM_MMU_ROOT_CURRENT) && VALID_PAGE(mmu->root.hpa))
-		mmu->invlpg(vcpu, gva, mmu->root.hpa);
+		__kvm_mmu_invalidate_gva(vcpu, mmu, gva, mmu->root.hpa);
 
 	for (i = 0; i < KVM_MMU_NUM_PREV_ROOTS; i++) {
 		if ((roots & KVM_MMU_ROOT_PREVIOUS(i)) &&
 		    VALID_PAGE(mmu->prev_roots[i].hpa))
-			mmu->invlpg(vcpu, gva, mmu->prev_roots[i].hpa);
+			__kvm_mmu_invalidate_gva(vcpu, mmu, gva, mmu->prev_roots[i].hpa);
 	}
 }
 EXPORT_SYMBOL_GPL(kvm_mmu_invalidate_gva);
diff --git a/arch/x86/kvm/mmu/paging_tmpl.h b/arch/x86/kvm/mmu/paging_tmpl.h
index 5ab9e974fdac..0031fe22af3d 100644
--- a/arch/x86/kvm/mmu/paging_tmpl.h
+++ b/arch/x86/kvm/mmu/paging_tmpl.h
@@ -887,64 +887,6 @@ static gpa_t FNAME(get_level1_sp_gpa)(struct kvm_mmu_page *sp)
 	return gfn_to_gpa(sp->gfn) + offset * sizeof(pt_element_t);
 }
 
-static void FNAME(invlpg)(struct kvm_vcpu *vcpu, gva_t gva, hpa_t root_hpa)
-{
-	struct kvm_shadow_walk_iterator iterator;
-	struct kvm_mmu_page *sp;
-	u64 old_spte;
-	int level;
-	u64 *sptep;
-
-	vcpu_clear_mmio_info(vcpu, gva);
-
-	/*
-	 * No need to check return value here, rmap_can_add() can
-	 * help us to skip pte prefetch later.
-	 */
-	mmu_topup_memory_caches(vcpu, true);
-
-	if (!VALID_PAGE(root_hpa)) {
-		WARN_ON(1);
-		return;
-	}
-
-	write_lock(&vcpu->kvm->mmu_lock);
-	for_each_shadow_entry_using_root(vcpu, root_hpa, gva, iterator) {
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

