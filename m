Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 56C5865E870
	for <lists+kvm@lfdr.de>; Thu,  5 Jan 2023 10:58:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232498AbjAEJ6j (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 5 Jan 2023 04:58:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54822 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232284AbjAEJ6D (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 5 Jan 2023 04:58:03 -0500
Received: from mail-pj1-x102f.google.com (mail-pj1-x102f.google.com [IPv6:2607:f8b0:4864:20::102f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3504B4FD5D;
        Thu,  5 Jan 2023 01:58:02 -0800 (PST)
Received: by mail-pj1-x102f.google.com with SMTP id v23so39321041pju.3;
        Thu, 05 Jan 2023 01:58:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=xooBmoFIJz8fPGLDNUh+0vSduR7yUeIqQpdajeiQf9s=;
        b=bZoPpF30y1Ot8G/sAAV52wi99QXPiohVC+XteLpF9qas44F8VFP2KMG+GUweX3vBA5
         Ju6GMqxVDKB20IheDiK06F49xNrE+NiL+0vIx2ew5GJFYFdbXKqSwqhoFUzrvM2n3cuF
         xR13DzhLupNfTCattVj+pMWmgALou/OBu5O0XMIqcrp5NKEptizI86J9yRw4wZrorESA
         g5aSwjNg585DKWZnd3vFH3/BzaOFlr7wm0jnPeNeqsbhFD+M2VFk3uStX1NL8jq1GtpQ
         h0RpOUV730H5BbRQatsT/8MOzxXVDEpE471HTCah61jMyhiY3ALnzK6tbFAmZl3WMgoe
         GCug==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=xooBmoFIJz8fPGLDNUh+0vSduR7yUeIqQpdajeiQf9s=;
        b=cX4n2VT/UK8VkPKLkW21r6LSlmiL0hAel6/Hr46b57UUw5JK62gJMLP3qztzCMDNBN
         F150loVq8W4SpatMpM+//Y6IzHiosiWPcW9CXL0PysBj8eEOQHU/M+bH0KawqCmKX10F
         EVJA/ufBXpeMB58/TsJucbur4C/t2dE9sjJAcVDzq5fBR9fFSqpfBPTVM0/8PoQm9xDQ
         zE/CXgJCaly3y0opIv/Rr0JnaaZSfvJ3AzcrmAtgECiNlGZ3OMaigep7aWHUzse1Ngz1
         ffNKgc2W7NCIQidOORsgl7/TKcB+8BhS/KbTV5SA17JyD5lEuaU5J5iWqOyt0PF1+vig
         2CLQ==
X-Gm-Message-State: AFqh2koc6H39QAn2u4+FccEnwaCG3J+2dJz49+khZ4/GMiTf8ji6qnBT
        XMj0oTcg8uXoumNpg8IzHDE8oF4VbfU=
X-Google-Smtp-Source: AMrXdXsvnCw1RJAEDpVR8qvEBXpmg93qx0yB+REAWGcRLJQQHhhFwH4lDUx9vNfZ5IZsfcTGncesnQ==
X-Received: by 2002:a17:902:8e8b:b0:192:e4cf:ca64 with SMTP id bg11-20020a1709028e8b00b00192e4cfca64mr7038155plb.28.1672912681423;
        Thu, 05 Jan 2023 01:58:01 -0800 (PST)
Received: from localhost ([47.254.32.37])
        by smtp.gmail.com with ESMTPSA id y7-20020a17090322c700b00192aa53a7d5sm12523926plg.8.2023.01.05.01.58.00
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 05 Jan 2023 01:58:00 -0800 (PST)
From:   Lai Jiangshan <jiangshanlai@gmail.com>
To:     linux-kernel@vger.kernel.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Lai Jiangshan <jiangshan.ljs@antgroup.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org,
        "H. Peter Anvin" <hpa@zytor.com>, kvm@vger.kernel.org
Subject: [PATCH 6/7] kvm: x86/mmu: Remove FNAME(invlpg)
Date:   Thu,  5 Jan 2023 17:58:47 +0800
Message-Id: <20230105095848.6061-7-jiangshanlai@gmail.com>
X-Mailer: git-send-email 2.19.1.6.gb485710b
In-Reply-To: <20230105095848.6061-1-jiangshanlai@gmail.com>
References: <20230105095848.6061-1-jiangshanlai@gmail.com>
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

Replace it with FNAME(sync_spte).

FNAME(sync_spte) combined with the shadow pagetable walk meets the
semantics of the instruction INVLPG.

Using FNAME(sync_spte) can share the code with flushing vTLB
(kvm_sync_page()) on invalidating each vTLB entry.

Signed-off-by: Lai Jiangshan <jiangshan.ljs@antgroup.com>
---
 arch/x86/include/asm/kvm_host.h |  1 -
 arch/x86/kvm/mmu/mmu.c          | 48 +++++++++++++++++----------
 arch/x86/kvm/mmu/paging_tmpl.h  | 59 ---------------------------------
 3 files changed, 31 insertions(+), 77 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 69b7967cd743..b80de8f53130 100644
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
index f39bee1542d8..1e5f2e79863f 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -1061,14 +1061,6 @@ static struct kvm_rmap_head *gfn_to_rmap(gfn_t gfn, int level,
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
@@ -4505,7 +4497,6 @@ static void nonpaging_init_context(struct kvm_mmu *context)
 	context->page_fault = nonpaging_page_fault;
 	context->gva_to_gpa = nonpaging_gva_to_gpa;
 	context->sync_spte = NULL;
-	context->invlpg = NULL;
 }
 
 static inline bool is_root_usable(struct kvm_mmu_root_info *root, gpa_t pgd,
@@ -5094,7 +5085,6 @@ static void paging64_init_context(struct kvm_mmu *context)
 	context->page_fault = paging64_page_fault;
 	context->gva_to_gpa = paging64_gva_to_gpa;
 	context->sync_spte = paging64_sync_spte;
-	context->invlpg = paging64_invlpg;
 }
 
 static void paging32_init_context(struct kvm_mmu *context)
@@ -5102,7 +5092,6 @@ static void paging32_init_context(struct kvm_mmu *context)
 	context->page_fault = paging32_page_fault;
 	context->gva_to_gpa = paging32_gva_to_gpa;
 	context->sync_spte = paging32_sync_spte;
-	context->invlpg = paging32_invlpg;
 }
 
 static union kvm_cpu_role
@@ -5191,7 +5180,6 @@ static void init_kvm_tdp_mmu(struct kvm_vcpu *vcpu,
 	context->root_role.word = root_role.word;
 	context->page_fault = kvm_tdp_page_fault;
 	context->sync_spte = NULL;
-	context->invlpg = NULL;
 	context->get_guest_pgd = get_cr3;
 	context->get_pdptr = kvm_pdptr_read;
 	context->inject_page_fault = kvm_inject_page_fault;
@@ -5323,7 +5311,6 @@ void kvm_init_shadow_ept_mmu(struct kvm_vcpu *vcpu, bool execonly,
 		context->page_fault = ept_page_fault;
 		context->gva_to_gpa = ept_gva_to_gpa;
 		context->sync_spte = ept_sync_spte;
-		context->invlpg = ept_invlpg;
 
 		update_permission_bitmask(context, true);
 		context->pkru_mask = 0;
@@ -5364,7 +5351,7 @@ static void init_kvm_nested_mmu(struct kvm_vcpu *vcpu,
 	 * L2 page tables are never shadowed, so there is no need to sync
 	 * SPTEs.
 	 */
-	g_context->invlpg            = NULL;
+	g_context->sync_spte         = NULL;
 
 	/*
 	 * Note that arch.mmu->gva_to_gpa translates l2_gpa to l1_gpa using
@@ -5739,6 +5726,33 @@ int noinline kvm_mmu_page_fault(struct kvm_vcpu *vcpu, gpa_t cr2_or_gpa, u64 err
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
 /* roots_to_invalidte must be some combination of the KVM_MMU_ROOT_* flags */
 void kvm_mmu_invalidate_gva(struct kvm_vcpu *vcpu, struct kvm_mmu *mmu,
 			    gva_t gva, ulong roots_to_invalidate)
@@ -5754,16 +5768,16 @@ void kvm_mmu_invalidate_gva(struct kvm_vcpu *vcpu, struct kvm_mmu *mmu,
 		static_call(kvm_x86_flush_tlb_gva)(vcpu, gva);
 	}
 
-	if (!mmu->invlpg)
+	if (!mmu->sync_spte)
 		return;
 
 	if ((roots_to_invalidate & KVM_MMU_ROOT_CURRENT) && VALID_PAGE(mmu->root.hpa))
-		mmu->invlpg(vcpu, gva, mmu->root.hpa);
+		__kvm_mmu_invalidate_gva(vcpu, mmu, gva, mmu->root.hpa);
 
 	for (i = 0; i < KVM_MMU_NUM_PREV_ROOTS; i++)
 		if ((roots_to_invalidate & KVM_MMU_ROOT_PREVIOUS(i)) &&
 		    VALID_PAGE(mmu->prev_roots[i].hpa))
-			mmu->invlpg(vcpu, gva, mmu->prev_roots[i].hpa);
+			__kvm_mmu_invalidate_gva(vcpu, mmu, gva, mmu->prev_roots[i].hpa);
 }
 EXPORT_SYMBOL_GPL(kvm_mmu_invalidate_gva);
 
diff --git a/arch/x86/kvm/mmu/paging_tmpl.h b/arch/x86/kvm/mmu/paging_tmpl.h
index 3bc13b9b61d1..62aac5d7d38c 100644
--- a/arch/x86/kvm/mmu/paging_tmpl.h
+++ b/arch/x86/kvm/mmu/paging_tmpl.h
@@ -851,65 +851,6 @@ static gpa_t FNAME(get_level1_sp_gpa)(struct kvm_mmu_page *sp)
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
-				kvm_flush_remote_tlbs_with_address(vcpu->kvm,
-					sp->gfn, KVM_PAGES_PER_HPAGE(sp->role.level));
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

