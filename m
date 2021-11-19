Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 995864579D2
	for <lists+kvm@lfdr.de>; Sat, 20 Nov 2021 00:58:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236285AbhKTAB6 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 19 Nov 2021 19:01:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47352 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236262AbhKTAB2 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 19 Nov 2021 19:01:28 -0500
Received: from mail-pf1-x44a.google.com (mail-pf1-x44a.google.com [IPv6:2607:f8b0:4864:20::44a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 731FAC061757
        for <kvm@vger.kernel.org>; Fri, 19 Nov 2021 15:58:25 -0800 (PST)
Received: by mail-pf1-x44a.google.com with SMTP id l7-20020a622507000000b00494608c84a4so6468808pfl.6
        for <kvm@vger.kernel.org>; Fri, 19 Nov 2021 15:58:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=iwzx2oWOtBNJIUC+MupnoX64lt1LDWHXN4CjIPxQ/kI=;
        b=pQB6J9GR2SnGMs3nv0wKQPq4/1Io7NUDcPtwhakBHFqLv7JqJnP07ad39B8iWMdYih
         l7ZWSGjm2PzZdJYK9YVNdxrn6v/SW7ZcfY1fW62jKkHay6qf5NnE8F0nl/JFtv/QZAeh
         TdZHAb94Sp9CbmRqQceNWPK7whydNn9CP1qdN9UEABbF4PlIq5lAjqvnq7B6YAwcPxNN
         EKNQCi17v85u6GRRw3SUEwiHHT9odecprQUnUX5avaXVrFDQPuJnGS7P+zxJR3eoshtS
         mb9VhpMuo0s97t1GoqojkprqCtLj6Q1ksebaiTcm5kEdjBeQhohFXzhdx4fe1tTRzTZG
         OTyw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=iwzx2oWOtBNJIUC+MupnoX64lt1LDWHXN4CjIPxQ/kI=;
        b=5JlNdujBOrVh2djYZ2Ryk8CjqEUNghSraFAEU7NTWHsWU9LpswQ9qJyeTiBTWyOOVR
         PdN1NTEpmmgn4nq4NBMZ0lC584opAIkMEk3uhIZwT7dF4CJEsErK5dPqb6gPaRp/DU0T
         vdNBrR8zORPvfEzxpucMfwUUTKHF7bGue9EHxhZHhFf6FVx3x5xWLzeqgz0WEG8Q8bCN
         hk+EEiPKfjU0sgSo+OZPvZjJZSgD12bPLNJqjbEtgRu8T8zY1xuOqlHCTS4XBhpWyO2J
         odOeVfoVRpfF8HB0nNZCjp9tExuMcosqTAHRE/JixZAXXFGeNSteX8+anBsVcsUai5f5
         pPyQ==
X-Gm-Message-State: AOAM530JTRjidN0nS1r4BeUOn9N6yydAAMlDNZnwcvYzxiiX1NgflNti
        x07SzhhuOlYm8Inxny3U0K5ESIJ/bzr4+Q==
X-Google-Smtp-Source: ABdhPJyJqE+C+B5GvHmHAN94QpH6FQygbHRpdL8kRCYSEiIgl32QIJgZFA4dPvOSdZvSwSI79FjpGIjcabgfVg==
X-Received: from dmatlack-heavy.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:19cd])
 (user=dmatlack job=sendgmr) by 2002:a17:902:f283:b0:141:f719:c434 with SMTP
 id k3-20020a170902f28300b00141f719c434mr79956908plc.79.1637366304900; Fri, 19
 Nov 2021 15:58:24 -0800 (PST)
Date:   Fri, 19 Nov 2021 23:57:53 +0000
In-Reply-To: <20211119235759.1304274-1-dmatlack@google.com>
Message-Id: <20211119235759.1304274-10-dmatlack@google.com>
Mime-Version: 1.0
References: <20211119235759.1304274-1-dmatlack@google.com>
X-Mailer: git-send-email 2.34.0.rc2.393.gf8c9666880-goog
Subject: [RFC PATCH 09/15] KVM: x86/mmu: Move restore_acc_track_spte to spte.c
From:   David Matlack <dmatlack@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org, Ben Gardon <bgardon@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Jim Mattson <jmattson@google.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Janis Schoetterl-Glausch <scgl@linux.vnet.ibm.com>,
        Junaid Shahid <junaids@google.com>,
        Oliver Upton <oupton@google.com>,
        Harish Barathvajasankar <hbarath@google.com>,
        Peter Xu <peterx@redhat.com>, Peter Shier <pshier@google.com>,
        David Matlack <dmatlack@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

restore_acc_track_spte is purely an SPTE manipulation, making it a good
fit for spte.c. It is also needed in spte.c in a follow-up commit so we
can construct child SPTEs during large page splitting.

No functional change intended.

Signed-off-by: David Matlack <dmatlack@google.com>
---
 arch/x86/kvm/mmu/mmu.c  | 18 ------------------
 arch/x86/kvm/mmu/spte.c | 18 ++++++++++++++++++
 arch/x86/kvm/mmu/spte.h |  1 +
 3 files changed, 19 insertions(+), 18 deletions(-)

diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index 537952574211..54f0d2228135 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -652,24 +652,6 @@ static u64 mmu_spte_get_lockless(u64 *sptep)
 	return __get_spte_lockless(sptep);
 }
 
-/* Restore an acc-track PTE back to a regular PTE */
-static u64 restore_acc_track_spte(u64 spte)
-{
-	u64 new_spte = spte;
-	u64 saved_bits = (spte >> SHADOW_ACC_TRACK_SAVED_BITS_SHIFT)
-			 & SHADOW_ACC_TRACK_SAVED_BITS_MASK;
-
-	WARN_ON_ONCE(spte_ad_enabled(spte));
-	WARN_ON_ONCE(!is_access_track_spte(spte));
-
-	new_spte &= ~shadow_acc_track_mask;
-	new_spte &= ~(SHADOW_ACC_TRACK_SAVED_BITS_MASK <<
-		      SHADOW_ACC_TRACK_SAVED_BITS_SHIFT);
-	new_spte |= saved_bits;
-
-	return new_spte;
-}
-
 /* Returns the Accessed status of the PTE and resets it at the same time. */
 static bool mmu_spte_age(u64 *sptep)
 {
diff --git a/arch/x86/kvm/mmu/spte.c b/arch/x86/kvm/mmu/spte.c
index 0c76c45fdb68..df2cdb8bcf77 100644
--- a/arch/x86/kvm/mmu/spte.c
+++ b/arch/x86/kvm/mmu/spte.c
@@ -268,6 +268,24 @@ u64 mark_spte_for_access_track(u64 spte)
 	return spte;
 }
 
+/* Restore an acc-track PTE back to a regular PTE */
+u64 restore_acc_track_spte(u64 spte)
+{
+	u64 new_spte = spte;
+	u64 saved_bits = (spte >> SHADOW_ACC_TRACK_SAVED_BITS_SHIFT)
+			 & SHADOW_ACC_TRACK_SAVED_BITS_MASK;
+
+	WARN_ON_ONCE(spte_ad_enabled(spte));
+	WARN_ON_ONCE(!is_access_track_spte(spte));
+
+	new_spte &= ~shadow_acc_track_mask;
+	new_spte &= ~(SHADOW_ACC_TRACK_SAVED_BITS_MASK <<
+		      SHADOW_ACC_TRACK_SAVED_BITS_SHIFT);
+	new_spte |= saved_bits;
+
+	return new_spte;
+}
+
 void kvm_mmu_set_mmio_spte_mask(u64 mmio_value, u64 mmio_mask, u64 access_mask)
 {
 	BUG_ON((u64)(unsigned)access_mask != access_mask);
diff --git a/arch/x86/kvm/mmu/spte.h b/arch/x86/kvm/mmu/spte.h
index e73c41d31816..3e4943ee5a01 100644
--- a/arch/x86/kvm/mmu/spte.h
+++ b/arch/x86/kvm/mmu/spte.h
@@ -342,6 +342,7 @@ bool make_spte(struct kvm_vcpu *vcpu, struct kvm_mmu_page *sp,
 u64 make_nonleaf_spte(u64 *child_pt, bool ad_disabled);
 u64 make_mmio_spte(struct kvm_vcpu *vcpu, u64 gfn, unsigned int access);
 u64 mark_spte_for_access_track(u64 spte);
+u64 restore_acc_track_spte(u64 spte);
 u64 kvm_mmu_changed_pte_notifier_make_spte(u64 old_spte, kvm_pfn_t new_pfn);
 
 void kvm_mmu_reset_all_pte_masks(void);
-- 
2.34.0.rc2.393.gf8c9666880-goog

