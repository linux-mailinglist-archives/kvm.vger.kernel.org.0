Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 84D9455A380
	for <lists+kvm@lfdr.de>; Fri, 24 Jun 2022 23:32:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231496AbiFXVa6 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 24 Jun 2022 17:30:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57992 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229915AbiFXVax (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 24 Jun 2022 17:30:53 -0400
Received: from mail-pf1-x449.google.com (mail-pf1-x449.google.com [IPv6:2607:f8b0:4864:20::449])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EEB4D7E00F
        for <kvm@vger.kernel.org>; Fri, 24 Jun 2022 14:30:52 -0700 (PDT)
Received: by mail-pf1-x449.google.com with SMTP id c77-20020a624e50000000b00525277a389bso1627203pfb.14
        for <kvm@vger.kernel.org>; Fri, 24 Jun 2022 14:30:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=reply-to:date:in-reply-to:message-id:mime-version:references
         :subject:from:to:cc;
        bh=ICaGYy1bxClqsMr84xS9Z2iY/dNy9kl//MDmpzal8X4=;
        b=EuR98mP+tn9jie3sAeJxuGzTMcy/XECRgpnOsmsm5vvlMkYMIto/8JtRhSIjw9lMSf
         1x72TWYnxmt53MX597QAUXAq1GcS98OkIDfi5g2oRBRx9l9QtSw/6RcIxm+URxRXvP7A
         1qDqUQ72llWr2Neo171cQpFRwtwycRmuHG6T90ZCbPwzPrLL4EDDS96RBNYkIIKzd9uj
         O9x+voPh91LaBga+5WFN0RBy6XY3RMGuQnBI6G2z3Uakvdo+U9W9iv5+brYZpY7s8Pv+
         liteH/FB2uTh1Ekc4XVQ0iB+xF7Volgpuxat8y7kvd/oRhGdgjWw5BdmzZwrajmTeDE/
         1pKw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:reply-to:date:in-reply-to:message-id
         :mime-version:references:subject:from:to:cc;
        bh=ICaGYy1bxClqsMr84xS9Z2iY/dNy9kl//MDmpzal8X4=;
        b=LIN8sMij4stB6vz0b7h2FMCKEDj+Jw6QCKUKA7AK7AgHsWy1rZJFPJiekpSz7WoYWB
         g7gNd7mSS7O5nRiX38bPX2HMfBOfboI0WGTDNyev1SOusiQ0w67AIkttvnuiCyIlekvn
         9lfbRwopr0Yf6dICkj4pRHWFIA24B1l3zT6WW8HwwmQYC0uqqcaZezITvIeUpsCWF2Xd
         zzxy+moU3XuVzuDF9dq9xxfuhK9buLKuo2XFnRBySKkYQ2JnhCrHMY1Q8E5rznslugR2
         DkdSrlN0nU9D8cBXhzmL3jqDw/kmCVmrjzxvkdgWqWBt9d7DQrjgwxlUlgmHP4Z7OQiv
         9zqA==
X-Gm-Message-State: AJIora+Nv6FNNgViiIbAnPH9WDljfI6mxAUhVNLZ/CsCB4sj2G0MZpsx
        axo3hR1LNza3Ew9N1nenjDp0yiwowPU=
X-Google-Smtp-Source: AGRyM1soHmDol5uisTNLRvpaxaglJLD4MnzM/G9seXjCj78n330EZb2VxQUAG9Uc7TQCeviIawphfk/SLPk=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a05:6a00:174b:b0:525:4eea:8ff2 with SMTP id
 j11-20020a056a00174b00b005254eea8ff2mr1147112pfc.23.1656106252545; Fri, 24
 Jun 2022 14:30:52 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Fri, 24 Jun 2022 21:30:36 +0000
In-Reply-To: <20220624213039.2872507-1-seanjc@google.com>
Message-Id: <20220624213039.2872507-2-seanjc@google.com>
Mime-Version: 1.0
References: <20220624213039.2872507-1-seanjc@google.com>
X-Mailer: git-send-email 2.37.0.rc0.161.g10f37bed90-goog
Subject: [PATCH v2 1/4] KVM: x86/mmu: Add optimized helper to retrieve an
 SPTE's index
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, David Matlack <dmatlack@google.com>
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

Add spte_index() to dedup all the code that calculates a SPTE's index
into its parent's page table and/or spt array.  Opportunistically tweak
the calculation to avoid pointer arithmetic, which is subtle (subtract in
8-byte chunks) and less performant (requires the compiler to generate the
subtraction).

Suggested-by: David Matlack <dmatlack@google.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/mmu/mmu.c         | 22 ++++++++++------------
 arch/x86/kvm/mmu/paging_tmpl.h |  4 ++--
 arch/x86/kvm/mmu/spte.h        |  6 ++++++
 3 files changed, 18 insertions(+), 14 deletions(-)

diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index bd74a287b54a..b04e9ce2469a 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -1036,7 +1036,7 @@ static void rmap_remove(struct kvm *kvm, u64 *spte)
 	struct kvm_rmap_head *rmap_head;
 
 	sp = sptep_to_sp(spte);
-	gfn = kvm_mmu_page_get_gfn(sp, spte - sp->spt);
+	gfn = kvm_mmu_page_get_gfn(sp, spte_index(spte));
 
 	/*
 	 * Unlike rmap_add, rmap_remove does not run in the context of a vCPU
@@ -1587,7 +1587,7 @@ static void __rmap_add(struct kvm *kvm,
 	int rmap_count;
 
 	sp = sptep_to_sp(spte);
-	kvm_mmu_page_set_translation(sp, spte - sp->spt, gfn, access);
+	kvm_mmu_page_set_translation(sp, spte_index(spte), gfn, access);
 	kvm_update_page_stats(kvm, sp->role.level, 1);
 
 	rmap_head = gfn_to_rmap(gfn, sp->role.level, slot);
@@ -1714,11 +1714,9 @@ static void kvm_mmu_mark_parents_unsync(struct kvm_mmu_page *sp)
 static void mark_unsync(u64 *spte)
 {
 	struct kvm_mmu_page *sp;
-	unsigned int index;
 
 	sp = sptep_to_sp(spte);
-	index = spte - sp->spt;
-	if (__test_and_set_bit(index, sp->unsync_child_bitmap))
+	if (__test_and_set_bit(spte_index(spte), sp->unsync_child_bitmap))
 		return;
 	if (sp->unsync_children++)
 		return;
@@ -2201,7 +2199,7 @@ static union kvm_mmu_page_role kvm_mmu_child_role(u64 *sptep, bool direct, unsig
 	 */
 	if (role.has_4_byte_gpte) {
 		WARN_ON_ONCE(role.level != PG_LEVEL_4K);
-		role.quadrant = (sptep - parent_sp->spt) % 2;
+		role.quadrant = spte_index(sptep) & 1;
 	}
 
 	return role;
@@ -2826,7 +2824,7 @@ static int mmu_set_spte(struct kvm_vcpu *vcpu, struct kvm_memory_slot *slot,
 		rmap_add(vcpu, slot, sptep, gfn, pte_access);
 	} else {
 		/* Already rmapped but the pte_access bits may have changed. */
-		kvm_mmu_page_set_access(sp, sptep - sp->spt, pte_access);
+		kvm_mmu_page_set_access(sp, spte_index(sptep), pte_access);
 	}
 
 	return ret;
@@ -2842,7 +2840,7 @@ static int direct_pte_prefetch_many(struct kvm_vcpu *vcpu,
 	int i, ret;
 	gfn_t gfn;
 
-	gfn = kvm_mmu_page_get_gfn(sp, start - sp->spt);
+	gfn = kvm_mmu_page_get_gfn(sp, spte_index(start));
 	slot = gfn_to_memslot_dirty_bitmap(vcpu, gfn, access & ACC_WRITE_MASK);
 	if (!slot)
 		return -1;
@@ -2868,7 +2866,7 @@ static void __direct_pte_prefetch(struct kvm_vcpu *vcpu,
 
 	WARN_ON(!sp->role.direct);
 
-	i = (sptep - sp->spt) & ~(PTE_PREFETCH_NUM - 1);
+	i = spte_index(sptep) & ~(PTE_PREFETCH_NUM - 1);
 	spte = sp->spt + i;
 
 	for (i = 0; i < PTE_PREFETCH_NUM; i++, spte++) {
@@ -6146,8 +6144,8 @@ static struct kvm_mmu_page *shadow_mmu_get_sp_for_split(struct kvm *kvm, u64 *hu
 	unsigned int access;
 	gfn_t gfn;
 
-	gfn = kvm_mmu_page_get_gfn(huge_sp, huge_sptep - huge_sp->spt);
-	access = kvm_mmu_page_get_access(huge_sp, huge_sptep - huge_sp->spt);
+	gfn = kvm_mmu_page_get_gfn(huge_sp, spte_index(huge_sptep));
+	access = kvm_mmu_page_get_access(huge_sp, spte_index(huge_sptep));
 
 	/*
 	 * Note, huge page splitting always uses direct shadow pages, regardless
@@ -6221,7 +6219,7 @@ static int shadow_mmu_try_split_huge_page(struct kvm *kvm,
 	u64 spte;
 
 	/* Grab information for the tracepoint before dropping the MMU lock. */
-	gfn = kvm_mmu_page_get_gfn(huge_sp, huge_sptep - huge_sp->spt);
+	gfn = kvm_mmu_page_get_gfn(huge_sp, spte_index(huge_sptep));
 	level = huge_sp->role.level;
 	spte = *huge_sptep;
 
diff --git a/arch/x86/kvm/mmu/paging_tmpl.h b/arch/x86/kvm/mmu/paging_tmpl.h
index 2448fa8d8438..d06dee7d38a8 100644
--- a/arch/x86/kvm/mmu/paging_tmpl.h
+++ b/arch/x86/kvm/mmu/paging_tmpl.h
@@ -595,7 +595,7 @@ static void FNAME(pte_prefetch)(struct kvm_vcpu *vcpu, struct guest_walker *gw,
 	if (sp->role.direct)
 		return __direct_pte_prefetch(vcpu, sp, sptep);
 
-	i = (sptep - sp->spt) & ~(PTE_PREFETCH_NUM - 1);
+	i = spte_index(sptep) & ~(PTE_PREFETCH_NUM - 1);
 	spte = sp->spt + i;
 
 	for (i = 0; i < PTE_PREFETCH_NUM; i++, spte++) {
@@ -933,7 +933,7 @@ static void FNAME(invlpg)(struct kvm_vcpu *vcpu, gva_t gva, hpa_t root_hpa)
 				break;
 
 			pte_gpa = FNAME(get_level1_sp_gpa)(sp);
-			pte_gpa += (sptep - sp->spt) * sizeof(pt_element_t);
+			pte_gpa += spte_index(sptep) * sizeof(pt_element_t);
 
 			mmu_page_zap_pte(vcpu->kvm, sp, sptep, NULL);
 			if (is_shadow_present_pte(old_spte))
diff --git a/arch/x86/kvm/mmu/spte.h b/arch/x86/kvm/mmu/spte.h
index b5c855f5514f..ba3dccb202bc 100644
--- a/arch/x86/kvm/mmu/spte.h
+++ b/arch/x86/kvm/mmu/spte.h
@@ -190,6 +190,12 @@ static inline bool is_removed_spte(u64 spte)
 	return spte == REMOVED_SPTE;
 }
 
+/* Get an SPTE's index into its parent's page table (and the spt array). */
+static inline int spte_index(u64 *sptep)
+{
+	return ((unsigned long)sptep / sizeof(*sptep)) & (SPTE_ENT_PER_PAGE - 1);
+}
+
 /*
  * In some cases, we need to preserve the GFN of a non-present or reserved
  * SPTE when we usurp the upper five bits of the physical address space to
-- 
2.37.0.rc0.161.g10f37bed90-goog

