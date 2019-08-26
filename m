Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9534A9C955
	for <lists+kvm@lfdr.de>; Mon, 26 Aug 2019 08:22:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729707AbfHZGWI (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 26 Aug 2019 02:22:08 -0400
Received: from mail-pl1-f196.google.com ([209.85.214.196]:39828 "EHLO
        mail-pl1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725446AbfHZGWH (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 26 Aug 2019 02:22:07 -0400
Received: by mail-pl1-f196.google.com with SMTP id z3so9525699pln.6;
        Sun, 25 Aug 2019 23:22:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=0Du7UptzbZ9d1irc9bFbfF0LjQiPPUrk+14MgHNA5PI=;
        b=rdDKUY2Xmjw/CZTWPpJd/XthVrbczKMQjy635goCa2XAeEm6OaM9vGgazxMPRI7wTR
         e+Ks9u8mCi6ySjfaTJTtBemtA1eFdFnI//P6wvHSdbQ+QyFTdQ0N6Hy38QLYEA2u5LEn
         yXgQ6hWQ7l4axiYmVRflYD3Fa+joeL3H4HZOx0Kn33HFNduW//Z34bbixylCcvlxDQDP
         Tb9osuCp64GHV2PTUy04VHx28qL3VaL3M0wBNLjFVgfN7xhyz3wEqukzaWG/yD2VdJQu
         Ln2jpt3/0e7x/75zCCcZnGtMivx2SP8Wd+ZXIlPTcKkjRl8OFHIvfnAx5UKIw0gMkflV
         ZlVQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=0Du7UptzbZ9d1irc9bFbfF0LjQiPPUrk+14MgHNA5PI=;
        b=l3xWPuSWPK66dEDNWJzHTvRbVeTAGpRoTvYFWxIe4LInP83jP6IJ9qzpG7BYBmGMwl
         QgWplqQa4tVbhYw92quoARYQI5Q1u765BXDpJwWa/oIsljkpLEflOdZqAekt/smxlaZ/
         HAsPJwiUqpEsB4P+y8EEN8zHWdlIPEDvSiWs84UxK6xG28vFw3nxaDPFEgfc6z/Jepuf
         kAerGn3zrI80EniwEbwnxEMVjZ51WfypWO2Bd98900KPlFmIkBvTE1f4KYdOHSw2X8m6
         SPZx4gRSLguQQbF/mvKvFJcybPKthzgMZ/IGJ3yii0EIsLcdGMCBpCt+gm8HgYax2Pf8
         HcxQ==
X-Gm-Message-State: APjAAAUs7gKp3eT3MiJS4L3ms51wWqMeEnb16GjM1e/S+7NsJxt98prj
        v4wk8rzs9TiW1sgc/8UH3OVAjWG8Qdo=
X-Google-Smtp-Source: APXvYqz6n8vm0Ipa+jhAEA19xjVbWISaaykXCMYan9n5G02rsJPI29a3Fv1IJMheosWqhR8rD4XN6w==
X-Received: by 2002:a17:902:96a:: with SMTP id 97mr10345558plm.264.1566800526843;
        Sun, 25 Aug 2019 23:22:06 -0700 (PDT)
Received: from surajjs2.ozlabs.ibm.com.ozlabs.ibm.com ([122.99.82.10])
        by smtp.gmail.com with ESMTPSA id f7sm10030353pfd.43.2019.08.25.23.22.04
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Sun, 25 Aug 2019 23:22:06 -0700 (PDT)
From:   Suraj Jitindar Singh <sjitindarsingh@gmail.com>
To:     kvm-ppc@vger.kernel.org
Cc:     paulus@ozlabs.org, kvm@vger.kernel.org,
        Suraj Jitindar Singh <sjitindarsingh@gmail.com>
Subject: [PATCH 21/23] KVM: PPC: Book3S HV: Nested: Implement nest rmap invalidations for hpt guests
Date:   Mon, 26 Aug 2019 16:21:07 +1000
Message-Id: <20190826062109.7573-22-sjitindarsingh@gmail.com>
X-Mailer: git-send-email 2.13.6
In-Reply-To: <20190826062109.7573-1-sjitindarsingh@gmail.com>
References: <20190826062109.7573-1-sjitindarsingh@gmail.com>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The nest rmap is used to store a reverse mapping from the (L1) guest real
address back to a pte in the shadow page table which maps it. This is used
when the host is modifying a L1 guest pte (either invalidating it or
modifying the rc bits) to make the necessary changes to the ptes in
the shadow tables which map that L1 guest page. This is already
implemented for a nested radix guest where the rmap entry stores the gpa
(guest physical address) of the nested pte which can be used to traverse
the shadow page table and find any matching ptes. Implement this nested
rmap invalidation for nested hpt (hash page table) guests.

We reuse the nest rmap structure that already exists for radix nested
guests for nested hpt guests. Instead of storing the gpa the hpt index
of the pte is stored. This means that a pte in the shadow hpt can be
uniquely identified by the nest rmap. As with the radix case we check
that the same host page is being addressed to detect if this is a stale
rmap entry, in which case we skip the invalidation.

When the host is invalidating a mapping for a L1 guest page use the
nest rmap to find any shadow ptes in the shadow hpt which map that page
and invalidate then, also invalidate any caching of the entry. A future
optimisation would be to make the pte absend so that we can avoid having
to lookup the guest rpte the next time an entry is faulted in.

When the host is clearing rc bits for a mapping for a L1 guest page use
the nest rmap to find any shadow ptes in the shadow hpt which map that
page and invalidate them as in the above case for invalidating a L1 guest
page. It is not sufficient to clear the rc bits in the shadow pte since
hardware can set them again without software intervention, so the mapping
must be made invalid so that we will take a page fault and can ensure that
the rc bits stay in sync in the page fault handler.

Signed-off-by: Suraj Jitindar Singh <sjitindarsingh@gmail.com>
---
 arch/powerpc/kvm/book3s_hv_nested.c | 114 +++++++++++++++++++++++++++---------
 1 file changed, 85 insertions(+), 29 deletions(-)

diff --git a/arch/powerpc/kvm/book3s_hv_nested.c b/arch/powerpc/kvm/book3s_hv_nested.c
index 57add167115e..90788a52b298 100644
--- a/arch/powerpc/kvm/book3s_hv_nested.c
+++ b/arch/powerpc/kvm/book3s_hv_nested.c
@@ -25,6 +25,9 @@ static struct patb_entry *pseries_partition_tb;
 static void kvmhv_update_ptbl_cache(struct kvm_nested_guest *gp);
 static void kvmhv_remove_all_nested_rmap_lpid(struct kvm *kvm, int lpid);
 static void kvmhv_free_memslot_nest_rmap(struct kvm_memory_slot *free);
+static void kvmhv_invalidate_shadow_pte_hash(struct kvm_hpt_info *hpt,
+					     unsigned int lpid, __be64 *hptep,
+					     unsigned long index);
 
 void kvmhv_save_hv_regs(struct kvm_vcpu *vcpu, struct hv_guest_state *hr)
 {
@@ -1135,30 +1138,57 @@ static void kvmhv_update_nest_rmap_rc(struct kvm *kvm, u64 n_rmap,
 				      unsigned long hpa, unsigned long mask)
 {
 	struct kvm_nested_guest *gp;
-	unsigned long gpa;
-	unsigned int shift, lpid;
-	pte_t *ptep;
+	unsigned int lpid;
 
-	gpa = n_rmap_to_gpa(n_rmap);
 	lpid = n_rmap_to_lpid(n_rmap);;
 	gp = kvmhv_find_nested(kvm, lpid);
 	if (!gp)
 		return;
 
-	/* Find the pte */
-	if (gp->radix)
-		ptep = __find_linux_pte(gp->shadow_pgtable, gpa, NULL, &shift);
-	else
-		ptep = NULL;	/* XXX TODO */
 	/*
-	 * If the pte is present and the pfn is still the same, update the pte.
-	 * If the pfn has changed then this is a stale rmap entry, the nested
-	 * gpa actually points somewhere else now, and there is nothing to do.
-	 * XXX A future optimisation would be to remove the rmap entry here.
+	 * Find the pte, and ensure it's valid and still points to the same
+	 * host page. If the pfn has changed then this is a stale rmap entry,
+	 * the shadow pte actually points somewhere else now, and there is
+	 * nothing to do. Otherwise clear the requested rc bits from the shadow
+	 * pte and perform the appropriate cache invalidation.
+	 * XXX A future optimisation would be to remove the rmap entry
 	 */
-	if (ptep && pte_present(*ptep) && ((pte_val(*ptep) & mask) == hpa)) {
-		__radix_pte_update(ptep, clr, set);
-		kvmppc_radix_tlbie_page(kvm, gpa, shift, lpid);
+	if (gp->radix) {
+		unsigned long gpa = n_rmap_to_gpa(n_rmap);
+		unsigned int shift;
+		pte_t *ptep;
+
+		ptep = __find_linux_pte(gp->shadow_pgtable, gpa, NULL, &shift);
+		/* pte present and still points to the same host page? */
+		if (ptep && pte_present(*ptep) && ((pte_val(*ptep) & mask) ==
+						   hpa)) {
+			__radix_pte_update(ptep, clr, set);
+			kvmppc_radix_tlbie_page(kvm, gpa, shift, lpid);
+		}
+	 } else {
+		unsigned long v, r, index = n_rmap_to_index(n_rmap);
+		__be64 *hptep = (__be64 *)(gp->shadow_hpt.virt + (index << 4));
+
+		preempt_disable();
+		while (!try_lock_hpte(hptep, HPTE_V_HVLOCK))
+			cpu_relax();
+		v = be64_to_cpu(hptep[0]) & ~HPTE_V_HVLOCK;
+		r = be64_to_cpu(hptep[1]);
+
+		/*
+		 * It's not enough to just clear the rc bits here since the
+		 * hardware can just set them again transparently, we need to
+		 * make the pte invalid so that an attempt to access the page
+		 * will invoke the page fault handler and we can ensure
+		 * consistency across the rc bits in the various ptes.
+		 */
+		if ((v & HPTE_V_VALID) && ((r & mask) == hpa))
+			kvmhv_invalidate_shadow_pte_hash(&gp->shadow_hpt,
+							 gp->shadow_lpid, hptep,
+							 index);
+		else	/* Leave pte unchanged */
+			__unlock_hpte(hptep, v);
+		preempt_enable();
 	}
 }
 
@@ -1179,7 +1209,7 @@ void kvmhv_update_nest_rmap_rc_list(struct kvm *kvm, unsigned long *rmapp,
 	if ((clr | set) & ~(_PAGE_DIRTY | _PAGE_ACCESSED))
 		return;
 
-	mask = PTE_RPN_MASK & ~(nbytes - 1);
+	mask = HPTE_R_RPN_3_0 & ~(nbytes - 1);
 	hpa &= mask;
 
 	llist_for_each_entry(cursor, head->first, list)
@@ -1195,24 +1225,50 @@ static void kvmhv_invalidate_nest_rmap(struct kvm *kvm, u64 n_rmap,
 				       unsigned long hpa, unsigned long mask)
 {
 	struct kvm_nested_guest *gp;
-	unsigned long gpa;
-	unsigned int shift, lpid;
-	pte_t *ptep;
+	unsigned int lpid;
 
-	gpa = n_rmap_to_gpa(n_rmap);
 	lpid = n_rmap_to_lpid(n_rmap);;
 	gp = kvmhv_find_nested(kvm, lpid);
 	if (!gp)
 		return;
 
-	/* Find and invalidate the pte */
-	if (gp->radix)
+	/*
+	 * Find the pte, and ensure it's valid and still points to the same
+	 * host page. If the pfn has changed then this is a stale rmap entry,
+	 * the shadow pte actually points somewhere else now, and there is
+	 * nothing to do. Otherwise invalidate the shadow pte and perform the
+	 * appropriate cache invalidation.
+	 */
+	if (gp->radix) {
+		unsigned long gpa = n_rmap_to_gpa(n_rmap);
+		unsigned int shift;
+		pte_t *ptep;
+
 		ptep = __find_linux_pte(gp->shadow_pgtable, gpa, NULL, &shift);
-	else
-		ptep = NULL;	/* XXX TODO */
-	/* Don't spuriously invalidate ptes if the pfn has changed */
-	if (ptep && pte_present(*ptep) && ((pte_val(*ptep) & mask) == hpa))
-		kvmppc_unmap_pte(kvm, ptep, gpa, shift, NULL, gp->shadow_lpid);
+		/* pte present and still points to the same host page? */
+		if (ptep && pte_present(*ptep) && ((pte_val(*ptep) & mask) ==
+						   hpa))
+			kvmppc_unmap_pte(kvm, ptep, gpa, shift, NULL,
+					 gp->shadow_lpid);
+	} else {
+		unsigned long v, r, index = n_rmap_to_index(n_rmap);
+		__be64 *hptep = (__be64 *)(gp->shadow_hpt.virt + (index << 4));
+
+		preempt_disable();
+		while (!try_lock_hpte(hptep, HPTE_V_HVLOCK))
+			cpu_relax();
+		v = be64_to_cpu(hptep[0]) & ~HPTE_V_HVLOCK;
+		r = be64_to_cpu(hptep[1]);
+
+		/* Invalidate existing pte if valid and host addr matches */
+		if ((v & HPTE_V_VALID) && ((r & mask) == hpa))
+			kvmhv_invalidate_shadow_pte_hash(&gp->shadow_hpt,
+							 gp->shadow_lpid, hptep,
+							 index);
+		else	/* Leave pte unchanged */
+			__unlock_hpte(hptep, v);
+		preempt_enable();
+	}
 }
 
 /*
@@ -1252,7 +1308,7 @@ void kvmhv_invalidate_nest_rmap_range(struct kvm *kvm,
 	gfn = (gpa >> PAGE_SHIFT) - memslot->base_gfn;
 	end_gfn = gfn + (nbytes >> PAGE_SHIFT);
 
-	addr_mask = PTE_RPN_MASK & ~(nbytes - 1);
+	addr_mask = HPTE_R_RPN_3_0 & ~(nbytes - 1);
 	hpa &= addr_mask;
 
 	for (; gfn < end_gfn; gfn++) {
-- 
2.13.6

