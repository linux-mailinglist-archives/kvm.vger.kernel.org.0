Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A696C473831
	for <lists+kvm@lfdr.de>; Mon, 13 Dec 2021 23:59:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244062AbhLMW7b (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 13 Dec 2021 17:59:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47526 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242437AbhLMW7a (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 13 Dec 2021 17:59:30 -0500
Received: from mail-pj1-x1049.google.com (mail-pj1-x1049.google.com [IPv6:2607:f8b0:4864:20::1049])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6F4BBC061574
        for <kvm@vger.kernel.org>; Mon, 13 Dec 2021 14:59:30 -0800 (PST)
Received: by mail-pj1-x1049.google.com with SMTP id gf15-20020a17090ac7cf00b001a9a31687d0so9486300pjb.1
        for <kvm@vger.kernel.org>; Mon, 13 Dec 2021 14:59:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=CUA8Kpd1Qp4b7Qr2EMkSmyJ+XKRmg8wbahlTIVobdrE=;
        b=PbcEzTdKafMKp+eUzL1oodmKvuQHx6/c4TZfNF7+r53N2md0gHPMcpwQGuYtHgZr8g
         hGJe738lQgrtLog6yPCTT705/UXkkpbi+rItGaBZ8gpBO0NRF64lT6BW3lc0+frB8SLV
         QHNl9lSZoofOnbrYx23ziOF0Q4fN7ktsb9K7Ssk4McM+JDbsFk9Kj8mKmB1OiayU/zrS
         4407ac0dAC/NCwvd3M9+ZFUrs/nwitysaupXFOikbSWq2VrwABUrvNqEa5CnfK2c75N6
         X8+6pMc0t2yrB7w8PEV/AE+JLnf38/H0aDV0+mU4YE6fDfcxC7f7vuWpDgLKSa6nPjLI
         w5VA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=CUA8Kpd1Qp4b7Qr2EMkSmyJ+XKRmg8wbahlTIVobdrE=;
        b=vtsDpHhr7js3KOWPA1m7Wlh2UFzsM3HCcfX5FWOrq46aOwzzouvE+SijBistgI180E
         qBmvcQVpB6bQ1BXwBbHf+24tV9uscdD37t4GStul9eaLGl6hT3/XZVR0YMzC0DWdesFG
         Reh3/BYlA8DlJ99DAI5fXoWI0O+9g/5/yY6phEXMl/crM38S9ZT3PQ4AIbTPAGs8Wq9H
         E0H6RMpFfwhrqVwtiP3OQiUv6na9vsrkTiy/MptUKuRUGBR3BGGSFMTt9SFOlUBG1Glg
         XvCCATUCjAGAyXjYLkh6Dl366Wdz3GwO2Gi7ds/PAk9qhPHB6UKo2mnNkpMnMDAblmfh
         6LAQ==
X-Gm-Message-State: AOAM530v6q8+xG9en+/hiHTod9rC5WD3nGGhqHkHr9WIchjonMoUzX3j
        f/4UyVPph2mdZHz9qrxgwIl9jAhQ6LxS2A==
X-Google-Smtp-Source: ABdhPJyF9vipN2UHMSw4CPV8el2571Um5meXegkAgICDEMzS+8ut7ADT8jfu+VcMHESL5tC+aPch9d0L8jE01A==
X-Received: from dmatlack-heavy.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:19cd])
 (user=dmatlack job=sendgmr) by 2002:a17:90b:3889:: with SMTP id
 mu9mr1275973pjb.160.1639436369901; Mon, 13 Dec 2021 14:59:29 -0800 (PST)
Date:   Mon, 13 Dec 2021 22:59:10 +0000
In-Reply-To: <20211213225918.672507-1-dmatlack@google.com>
Message-Id: <20211213225918.672507-6-dmatlack@google.com>
Mime-Version: 1.0
References: <20211213225918.672507-1-dmatlack@google.com>
X-Mailer: git-send-email 2.34.1.173.g76aa8bc2d0-goog
Subject: [PATCH v1 05/13] KVM: x86/mmu: Move restore_acc_track_spte to spte.c
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
        "Nikunj A . Dadhania" <nikunj@amd.com>,
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
Reviewed-by: Ben Gardon <bgardon@google.com>
---
 arch/x86/kvm/mmu/mmu.c  | 18 ------------------
 arch/x86/kvm/mmu/spte.c | 18 ++++++++++++++++++
 arch/x86/kvm/mmu/spte.h |  1 +
 3 files changed, 19 insertions(+), 18 deletions(-)

diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index 8b702f2b6a70..3c2cb4dd1f11 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -646,24 +646,6 @@ static u64 mmu_spte_get_lockless(u64 *sptep)
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
index 8a7b03207762..fd34ae5d6940 100644
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
index a4af2a42695c..9b0c7b27f23f 100644
--- a/arch/x86/kvm/mmu/spte.h
+++ b/arch/x86/kvm/mmu/spte.h
@@ -337,6 +337,7 @@ bool make_spte(struct kvm_vcpu *vcpu, struct kvm_mmu_page *sp,
 u64 make_nonleaf_spte(u64 *child_pt, bool ad_disabled);
 u64 make_mmio_spte(struct kvm_vcpu *vcpu, u64 gfn, unsigned int access);
 u64 mark_spte_for_access_track(u64 spte);
+u64 restore_acc_track_spte(u64 spte);
 u64 kvm_mmu_changed_pte_notifier_make_spte(u64 old_spte, kvm_pfn_t new_pfn);
 
 void kvm_mmu_reset_all_pte_masks(void);
-- 
2.34.1.173.g76aa8bc2d0-goog

