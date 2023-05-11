Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D93586FFD9B
	for <lists+kvm@lfdr.de>; Fri, 12 May 2023 02:00:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239612AbjELAAG (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 11 May 2023 20:00:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53782 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239652AbjEKX7o (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 11 May 2023 19:59:44 -0400
Received: from mail-pl1-x64a.google.com (mail-pl1-x64a.google.com [IPv6:2607:f8b0:4864:20::64a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2AF1E93D1
        for <kvm@vger.kernel.org>; Thu, 11 May 2023 16:59:34 -0700 (PDT)
Received: by mail-pl1-x64a.google.com with SMTP id d9443c01a7336-1aae803a5eeso56318065ad.0
        for <kvm@vger.kernel.org>; Thu, 11 May 2023 16:59:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1683849573; x=1686441573;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=dN6VmGM2zS2bKeFyzPEe5BkbZy3+Yl9CkJ/vyhAlFJE=;
        b=1HHzzZmlSWuBI2Il2a5v5W8oLlA5YWunYryBelZHRr4cU7Xy72WnhQAKYwNrSranEd
         rWz3WOmczD4xBiW66jWliz5GmMUf9GRJZnsvJYHMTWzGUnV5huLtOf2UuZlTST6inmcn
         nqJbvU+9L4QzoWmO2TsFqBrwSvmH5cW0HcrcOJ9zbQ0U/sXLOR++nPUNK4aVKbB6tmpf
         AO2bjqXGaYvxT6lLtpYOmnWp5gkF/iR4OuI04enrwbWGcDeU82+p+xZp3KkEC2bgXB2D
         xQy33HL1cFoxFibtrMxmbbEz5gi5Z8ZarJQOCdwnT8hLURkG+PmufoLjF33JMYwJtx1l
         0plA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1683849573; x=1686441573;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=dN6VmGM2zS2bKeFyzPEe5BkbZy3+Yl9CkJ/vyhAlFJE=;
        b=bZSAwFAGAgjPu01cDiWOeZyV2TW/kOJmbvvYSPrbpm+amlitw523GibxqYEXAW5W2M
         pwO2uz6QOU3LtoLrGQ/+c8zWZ29CpCZcNGMk4PmgmL2RPy7VMr/yMucsv+3csQzOnDml
         BPGSCmXuGdeFz91olAjaJF7WjyPjr3ZefN2a9hmXEqPmjLxcjWamMEybqPWQIgEFUfHJ
         KuPXrKKD5We1fJ8iWGJmsoiRi7mgtU2AWQ7uQkjJ3GmsGQFvB236XN+IpTgAW7Mtrucj
         lRTDl2Tep6cQnh6M/IxzSpbPIniam1Nap18EJddWNj1Bm+vtQw2zteMW5ZS0iFMKmiCU
         QGRQ==
X-Gm-Message-State: AC+VfDxHn8zBLfBBvzeR9dK6kKkJ+frwV4F8bdynkecTugDgA11iQ2r0
        3Sy1so9Go6rg6YifGjLw+XOE/3rbjr0=
X-Google-Smtp-Source: ACHHUZ4mNLERypAs+m+7901J9SW6AbXGZiMSOHDKoj9yYJslw1BME/5QGWveOg114OVRm3Jz+zKTPvRuJxA=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:903:230a:b0:1ac:8cd4:741a with SMTP id
 d10-20020a170903230a00b001ac8cd4741amr4891193plh.6.1683849573449; Thu, 11 May
 2023 16:59:33 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Thu, 11 May 2023 16:59:16 -0700
In-Reply-To: <20230511235917.639770-1-seanjc@google.com>
Mime-Version: 1.0
References: <20230511235917.639770-1-seanjc@google.com>
X-Mailer: git-send-email 2.40.1.606.ga4b1b128d6-goog
Message-ID: <20230511235917.639770-9-seanjc@google.com>
Subject: [PATCH 8/9] KVM: x86/mmu: Plumb "struct kvm" all the way to pte_list_remove()
From:   Sean Christopherson <seanjc@google.com>
To:     Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Mingwei Zhang <mizhang@google.com>,
        David Matlack <dmatlack@google.com>,
        Jim Mattson <jmattson@google.com>
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

From: Mingwei Zhang <mizhang@google.com>

Plumb "struct kvm" all the way to pte_list_remove() to allow the usage of
KVM_BUG() and/or KVM_BUG_ON().  This will allow killing only the offending
VM instead of doing BUG() if the kernel is built with
CONFIG_BUG_ON_DATA_CORRUPTION=n, i.e. does NOT want to BUG() if KVM's data
structures (rmaps) appear to be corrupted.

Signed-off-by: Mingwei Zhang <mizhang@google.com>
[sean: tweak changelog]
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/mmu/mmu.c | 33 ++++++++++++++++++---------------
 1 file changed, 18 insertions(+), 15 deletions(-)

diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index d209d466d58f..8a8adeaa7dd7 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -962,7 +962,8 @@ static int pte_list_add(struct kvm_mmu_memory_cache *cache, u64 *spte,
 	return count;
 }
 
-static void pte_list_desc_remove_entry(struct kvm_rmap_head *rmap_head,
+static void pte_list_desc_remove_entry(struct kvm *kvm,
+				       struct kvm_rmap_head *rmap_head,
 				       struct pte_list_desc *desc, int i)
 {
 	struct pte_list_desc *head_desc = (struct pte_list_desc *)(rmap_head->val & ~1ul);
@@ -998,7 +999,8 @@ static void pte_list_desc_remove_entry(struct kvm_rmap_head *rmap_head,
 	mmu_free_pte_list_desc(head_desc);
 }
 
-static void pte_list_remove(u64 *spte, struct kvm_rmap_head *rmap_head)
+static void pte_list_remove(struct kvm *kvm, u64 *spte,
+			    struct kvm_rmap_head *rmap_head)
 {
 	struct pte_list_desc *desc;
 	int i;
@@ -1017,7 +1019,8 @@ static void pte_list_remove(u64 *spte, struct kvm_rmap_head *rmap_head)
 		while (desc) {
 			for (i = 0; i < desc->spte_count; ++i) {
 				if (desc->sptes[i] == spte) {
-					pte_list_desc_remove_entry(rmap_head, desc, i);
+					pte_list_desc_remove_entry(kvm, rmap_head,
+								   desc, i);
 					return;
 				}
 			}
@@ -1032,7 +1035,7 @@ static void kvm_zap_one_rmap_spte(struct kvm *kvm,
 				  struct kvm_rmap_head *rmap_head, u64 *sptep)
 {
 	mmu_spte_clear_track_bits(kvm, sptep);
-	pte_list_remove(sptep, rmap_head);
+	pte_list_remove(kvm, sptep, rmap_head);
 }
 
 /* Return true if at least one SPTE was zapped, false otherwise */
@@ -1107,7 +1110,7 @@ static void rmap_remove(struct kvm *kvm, u64 *spte)
 	slot = __gfn_to_memslot(slots, gfn);
 	rmap_head = gfn_to_rmap(gfn, sp->role.level, slot);
 
-	pte_list_remove(spte, rmap_head);
+	pte_list_remove(kvm, spte, rmap_head);
 }
 
 /*
@@ -1751,16 +1754,16 @@ static void mmu_page_add_parent_pte(struct kvm_mmu_memory_cache *cache,
 	pte_list_add(cache, parent_pte, &sp->parent_ptes);
 }
 
-static void mmu_page_remove_parent_pte(struct kvm_mmu_page *sp,
+static void mmu_page_remove_parent_pte(struct kvm *kvm, struct kvm_mmu_page *sp,
 				       u64 *parent_pte)
 {
-	pte_list_remove(parent_pte, &sp->parent_ptes);
+	pte_list_remove(kvm, parent_pte, &sp->parent_ptes);
 }
 
-static void drop_parent_pte(struct kvm_mmu_page *sp,
+static void drop_parent_pte(struct kvm *kvm, struct kvm_mmu_page *sp,
 			    u64 *parent_pte)
 {
-	mmu_page_remove_parent_pte(sp, parent_pte);
+	mmu_page_remove_parent_pte(kvm, sp, parent_pte);
 	mmu_spte_clear_no_track(parent_pte);
 }
 
@@ -2475,7 +2478,7 @@ static void validate_direct_spte(struct kvm_vcpu *vcpu, u64 *sptep,
 		if (child->role.access == direct_access)
 			return;
 
-		drop_parent_pte(child, sptep);
+		drop_parent_pte(vcpu->kvm, child, sptep);
 		kvm_flush_remote_tlbs_sptep(vcpu->kvm, sptep);
 	}
 }
@@ -2493,7 +2496,7 @@ static int mmu_page_zap_pte(struct kvm *kvm, struct kvm_mmu_page *sp,
 			drop_spte(kvm, spte);
 		} else {
 			child = spte_to_child_sp(pte);
-			drop_parent_pte(child, spte);
+			drop_parent_pte(kvm, child, spte);
 
 			/*
 			 * Recursively zap nested TDP SPs, parentless SPs are
@@ -2524,13 +2527,13 @@ static int kvm_mmu_page_unlink_children(struct kvm *kvm,
 	return zapped;
 }
 
-static void kvm_mmu_unlink_parents(struct kvm_mmu_page *sp)
+static void kvm_mmu_unlink_parents(struct kvm *kvm, struct kvm_mmu_page *sp)
 {
 	u64 *sptep;
 	struct rmap_iterator iter;
 
 	while ((sptep = rmap_get_first(&sp->parent_ptes, &iter)))
-		drop_parent_pte(sp, sptep);
+		drop_parent_pte(kvm, sp, sptep);
 }
 
 static int mmu_zap_unsync_children(struct kvm *kvm,
@@ -2569,7 +2572,7 @@ static bool __kvm_mmu_prepare_zap_page(struct kvm *kvm,
 	++kvm->stat.mmu_shadow_zapped;
 	*nr_zapped = mmu_zap_unsync_children(kvm, sp, invalid_list);
 	*nr_zapped += kvm_mmu_page_unlink_children(kvm, sp, invalid_list);
-	kvm_mmu_unlink_parents(sp);
+	kvm_mmu_unlink_parents(kvm, sp);
 
 	/* Zapping children means active_mmu_pages has become unstable. */
 	list_unstable = *nr_zapped;
@@ -2927,7 +2930,7 @@ static int mmu_set_spte(struct kvm_vcpu *vcpu, struct kvm_memory_slot *slot,
 			u64 pte = *sptep;
 
 			child = spte_to_child_sp(pte);
-			drop_parent_pte(child, sptep);
+			drop_parent_pte(vcpu->kvm, child, sptep);
 			flush = true;
 		} else if (pfn != spte_to_pfn(*sptep)) {
 			drop_spte(vcpu->kvm, sptep);
-- 
2.40.1.606.ga4b1b128d6-goog

