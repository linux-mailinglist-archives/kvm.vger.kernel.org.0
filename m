Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8A0854943AE
	for <lists+kvm@lfdr.de>; Thu, 20 Jan 2022 00:10:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1357926AbiASXJc (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 19 Jan 2022 18:09:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50546 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344315AbiASXIF (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 19 Jan 2022 18:08:05 -0500
Received: from mail-pg1-x549.google.com (mail-pg1-x549.google.com [IPv6:2607:f8b0:4864:20::549])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DEBC6C061760
        for <kvm@vger.kernel.org>; Wed, 19 Jan 2022 15:08:04 -0800 (PST)
Received: by mail-pg1-x549.google.com with SMTP id j28-20020a637a5c000000b00344d66c3c56so2481778pgn.21
        for <kvm@vger.kernel.org>; Wed, 19 Jan 2022 15:08:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=8Pw7Aqpn0cUEA7Y4SFxOipMTDgK0HIMSO7Lb2esjwuk=;
        b=TcKM1h7/P2uugJkhId+Y2PU0zOqHJC9W+0K0iH2ie0re2dBJo3qYK0rrucaDLKpd3p
         y4aANyWppWLyHV41hySBCt7UHccL0fMJW4Lwm9YgmbSOXSIeDwMVAi4+nUhwnsdITkg5
         /qtDowYosYPT5iaxzN4BUAu6Ti9mpw8Qq6msKV0d1XowrYYddnXk7Pl2h/i+qEnaufcM
         lIgpMzLcAZLW7MBVhfHYwkdTKMeDTaCDSpcnd51bX4GqToYCj4QdSfJDP3bsRHMW0Jcd
         VlJ7bktFQDut3d7BmpSzbSKfRwMs0sWt/rkF0mRpXsWIaFpcJbpHQxmthe4OOwB7AJgm
         /38A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=8Pw7Aqpn0cUEA7Y4SFxOipMTDgK0HIMSO7Lb2esjwuk=;
        b=ay2MN3Q/GkwaOvMUftpZ+WZryEVfDVShVZNAuCuLM1K1/mhZr/QCxZdekfqYZHEFio
         ceQh8vHKBO4nmIWJ7orWb+qis877eCGNL7qRfOaIp4qFWzXBpNl/qlZdPZS8uq1WPdce
         u+BynAEvfKjh9dqU+ToTLGatildQIALTfEVkUTmqTrDNz8Uc7ZMulqcSsBelOdfXBMfV
         8q/zki7OWQ/y1kln71c8OLahN7ivjMpjK0Onk2zvXAFU7r1SzSnZCV+ZepNcd/ymTMh+
         q0ZzsEHaOu5Q9Ds3cekbKih6DQb5lOvMG9y8JvLnTecxGZ/D6Ij4JDi0mH0qRmkFTJUZ
         AlnA==
X-Gm-Message-State: AOAM533wj5Qe2b5WFolVHb7a5pju1w2Ubfk1b9UB1J6mr9EEvTPCpmlA
        g+wR5uD1zofzp9EqsBG+BWyVe/+HOzFuwg==
X-Google-Smtp-Source: ABdhPJykd/VixXLJY76BpFN6uDLRps03jE3W6C2TpxeniSVoo1qcdSppQvoa8vCmRqS6SOJ0aVhXFk3sz/a+uA==
X-Received: from dmatlack-heavy.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:19cd])
 (user=dmatlack job=sendgmr) by 2002:a65:464e:: with SMTP id
 k14mr17418292pgr.225.1642633684427; Wed, 19 Jan 2022 15:08:04 -0800 (PST)
Date:   Wed, 19 Jan 2022 23:07:31 +0000
In-Reply-To: <20220119230739.2234394-1-dmatlack@google.com>
Message-Id: <20220119230739.2234394-11-dmatlack@google.com>
Mime-Version: 1.0
References: <20220119230739.2234394-1-dmatlack@google.com>
X-Mailer: git-send-email 2.35.0.rc0.227.g00780c9af4-goog
Subject: [PATCH v2 10/18] KVM: x86/mmu: Move restore_acc_track_spte() to spte.h
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

restore_acc_track_spte() is pure SPTE bit manipulation, making it a good
fit for spte.h. And now that the WARN_ON_ONCE() calls have been removed,
there isn't any good reason to not inline it.

This move also prepares for a follow-up commit that will need to call
restore_acc_track_spte() from spte.c

No functional change intended.

Reviewed-by: Ben Gardon <bgardon@google.com>
Reviewed-by: Peter Xu <peterx@redhat.com>
Signed-off-by: David Matlack <dmatlack@google.com>
---
 arch/x86/kvm/mmu/mmu.c  | 14 --------------
 arch/x86/kvm/mmu/spte.h | 15 +++++++++++++++
 2 files changed, 15 insertions(+), 14 deletions(-)

diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index 7a70c238cd26..51aa38bdb858 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -646,20 +646,6 @@ static u64 mmu_spte_get_lockless(u64 *sptep)
 	return __get_spte_lockless(sptep);
 }
 
-/* Restore an acc-track PTE back to a regular PTE */
-static u64 restore_acc_track_spte(u64 spte)
-{
-	u64 saved_bits = (spte >> SHADOW_ACC_TRACK_SAVED_BITS_SHIFT)
-			 & SHADOW_ACC_TRACK_SAVED_BITS_MASK;
-
-	spte &= ~shadow_acc_track_mask;
-	spte &= ~(SHADOW_ACC_TRACK_SAVED_BITS_MASK <<
-		  SHADOW_ACC_TRACK_SAVED_BITS_SHIFT);
-	spte |= saved_bits;
-
-	return spte;
-}
-
 /* Returns the Accessed status of the PTE and resets it at the same time. */
 static bool mmu_spte_age(u64 *sptep)
 {
diff --git a/arch/x86/kvm/mmu/spte.h b/arch/x86/kvm/mmu/spte.h
index be6a007a4af3..e8ac1fab3185 100644
--- a/arch/x86/kvm/mmu/spte.h
+++ b/arch/x86/kvm/mmu/spte.h
@@ -367,6 +367,21 @@ bool make_spte(struct kvm_vcpu *vcpu, struct kvm_mmu_page *sp,
 u64 make_nonleaf_spte(u64 *child_pt, bool ad_disabled);
 u64 make_mmio_spte(struct kvm_vcpu *vcpu, u64 gfn, unsigned int access);
 u64 mark_spte_for_access_track(u64 spte);
+
+/* Restore an acc-track PTE back to a regular PTE */
+static inline u64 restore_acc_track_spte(u64 spte)
+{
+	u64 saved_bits = (spte >> SHADOW_ACC_TRACK_SAVED_BITS_SHIFT)
+			 & SHADOW_ACC_TRACK_SAVED_BITS_MASK;
+
+	spte &= ~shadow_acc_track_mask;
+	spte &= ~(SHADOW_ACC_TRACK_SAVED_BITS_MASK <<
+		  SHADOW_ACC_TRACK_SAVED_BITS_SHIFT);
+	spte |= saved_bits;
+
+	return spte;
+}
+
 u64 kvm_mmu_changed_pte_notifier_make_spte(u64 old_spte, kvm_pfn_t new_pfn);
 
 void kvm_mmu_reset_all_pte_masks(void);
-- 
2.35.0.rc0.227.g00780c9af4-goog

