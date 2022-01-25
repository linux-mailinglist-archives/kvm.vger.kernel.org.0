Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C702849BF57
	for <lists+kvm@lfdr.de>; Wed, 26 Jan 2022 00:05:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234652AbiAYXFp (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 25 Jan 2022 18:05:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44318 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231925AbiAYXFb (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 25 Jan 2022 18:05:31 -0500
Received: from mail-pl1-x649.google.com (mail-pl1-x649.google.com [IPv6:2607:f8b0:4864:20::649])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 04192C06161C
        for <kvm@vger.kernel.org>; Tue, 25 Jan 2022 15:05:31 -0800 (PST)
Received: by mail-pl1-x649.google.com with SMTP id q21-20020a170902edd500b0014ae79cc6d5so5805345plk.18
        for <kvm@vger.kernel.org>; Tue, 25 Jan 2022 15:05:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=konIu66tln70B4/KL1+Z+6gW9IXzyYE6pA+Z6X0RYPM=;
        b=oRPyQTE04G79fKhAUa9INSk+SDvbPvDYwvBhS6SkCHfqemQOR20h5gnyralD8fHuAF
         cJoRI4ybnOu4w/U7u/hzn9Th/fTEB2dkWYXg+ca0zwTzmppPOOMeX52rYQvAxC5cuvrl
         ftX1Fn8rt4b3D0Twuju/+5oFT0oFGt5qa2lbpmrezdU8gSkGov1a8zsRfYMENjdjfFwQ
         kWCAEojt73MRUdUQCab1gH5feUVM+wLUZJ0EuXARG3gNSJoiJXMkn0FcTCtikKOUwklt
         8bmZbxWLgmHYpmmBm1RV5X7TfuB35/iAqyPmDQj2z4chZufUUfZG+xK7sXe4hGSt2CYo
         lkhA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=konIu66tln70B4/KL1+Z+6gW9IXzyYE6pA+Z6X0RYPM=;
        b=q6Kk/XUNR8iNZYXYYOK1ziF3rLge/8BbDii4aFlzlXKc0MmRaBIBacmaKx4tBcbN7f
         v7Os1zehRC0FUrUjgF1qUf7A9v68erPn+OSXJzoXI7Ar8B90Rs+5nIrasqaI0UjQKmwD
         cRGzE17IDXhIPw+4l633cs9OnJzxggZuzDk8pgBatp2RxUpE79TOvsUbPCT70WnL13L4
         T5xoVPE00Aias3siO01SzfAqvs2j8D8/jY1I281NQhnNvUoaBXGhMKYgFSdW4HJgl4Fg
         Gxz7Tt9wGCYHNIJ9BuAU9Fz1oZOqfooug9q4m5f/dkU1LJ7qfG1E2RH9ExfDDarzl9MS
         Bp/A==
X-Gm-Message-State: AOAM533140+t0CzFVZpxu1iq2SOtqaodX5HIWlU/7hZAwZuKzTir/0XQ
        JQiJPLyEKZ6IccQm7qP4fGEBoUUssuixOQ==
X-Google-Smtp-Source: ABdhPJxN5JyFU7LEcJ2LMIGHaiVteFmQAJ+ky7pNyaIQPSmd4URUzNuloeTgEywJWXsmK55o4FhJpCFHkwmEDA==
X-Received: from dmatlack-heavy.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:19cd])
 (user=dmatlack job=sendgmr) by 2002:a17:90a:5d8c:: with SMTP id
 t12mr5687134pji.189.1643151930485; Tue, 25 Jan 2022 15:05:30 -0800 (PST)
Date:   Tue, 25 Jan 2022 23:05:16 +0000
In-Reply-To: <20220125230518.1697048-1-dmatlack@google.com>
Message-Id: <20220125230518.1697048-4-dmatlack@google.com>
Mime-Version: 1.0
References: <20220125230518.1697048-1-dmatlack@google.com>
X-Mailer: git-send-email 2.35.0.rc0.227.g00780c9af4-goog
Subject: [PATCH 3/5] KVM: x86/mmu: Move is_writable_pte() to spte.h
From:   David Matlack <dmatlack@google.com>
To:     pbonzini@redhat.com
Cc:     seanjc@google.com, vkuznets@redhat.com, wanpengli@tencent.com,
        jmattson@google.com, joro@8bytes.org, kvm@vger.kernel.org,
        David Matlack <dmatlack@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Move is_writable_pte() close to the other functions that check
writability information about SPTEs. While here opportunistically
replace the open-coded bit arithmetic in
check_spte_writable_invariants() with a call to is_writable_pte().

No functional change intended.

Suggested-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: David Matlack <dmatlack@google.com>
---
 arch/x86/kvm/mmu.h      | 38 --------------------------------------
 arch/x86/kvm/mmu/spte.h | 40 +++++++++++++++++++++++++++++++++++++++-
 2 files changed, 39 insertions(+), 39 deletions(-)

diff --git a/arch/x86/kvm/mmu.h b/arch/x86/kvm/mmu.h
index e9fbb2c8bbe2..51faa2c76ca5 100644
--- a/arch/x86/kvm/mmu.h
+++ b/arch/x86/kvm/mmu.h
@@ -202,44 +202,6 @@ static inline int kvm_mmu_do_page_fault(struct kvm_vcpu *vcpu, gpa_t cr2_or_gpa,
 	return vcpu->arch.mmu->page_fault(vcpu, &fault);
 }
 
-/*
- * Currently, we have two sorts of write-protection, a) the first one
- * write-protects guest page to sync the guest modification, b) another one is
- * used to sync dirty bitmap when we do KVM_GET_DIRTY_LOG. The differences
- * between these two sorts are:
- * 1) the first case clears MMU-writable bit.
- * 2) the first case requires flushing tlb immediately avoiding corrupting
- *    shadow page table between all vcpus so it should be in the protection of
- *    mmu-lock. And the another case does not need to flush tlb until returning
- *    the dirty bitmap to userspace since it only write-protects the page
- *    logged in the bitmap, that means the page in the dirty bitmap is not
- *    missed, so it can flush tlb out of mmu-lock.
- *
- * So, there is the problem: the first case can meet the corrupted tlb caused
- * by another case which write-protects pages but without flush tlb
- * immediately. In order to making the first case be aware this problem we let
- * it flush tlb if we try to write-protect a spte whose MMU-writable bit
- * is set, it works since another case never touches MMU-writable bit.
- *
- * Anyway, whenever a spte is updated (only permission and status bits are
- * changed) we need to check whether the spte with MMU-writable becomes
- * readonly, if that happens, we need to flush tlb. Fortunately,
- * mmu_spte_update() has already handled it perfectly.
- *
- * The rules to use MMU-writable and PT_WRITABLE_MASK:
- * - if we want to see if it has writable tlb entry or if the spte can be
- *   writable on the mmu mapping, check MMU-writable, this is the most
- *   case, otherwise
- * - if we fix page fault on the spte or do write-protection by dirty logging,
- *   check PT_WRITABLE_MASK.
- *
- * TODO: introduce APIs to split these two cases.
- */
-static inline bool is_writable_pte(unsigned long pte)
-{
-	return pte & PT_WRITABLE_MASK;
-}
-
 /*
  * Check if a given access (described through the I/D, W/R and U/S bits of a
  * page fault error code pfec) causes a permission fault with the given PTE
diff --git a/arch/x86/kvm/mmu/spte.h b/arch/x86/kvm/mmu/spte.h
index b8fd055acdbd..e1ddba45bba1 100644
--- a/arch/x86/kvm/mmu/spte.h
+++ b/arch/x86/kvm/mmu/spte.h
@@ -339,6 +339,44 @@ static __always_inline bool is_rsvd_spte(struct rsvd_bits_validate *rsvd_check,
 	       __is_rsvd_bits_set(rsvd_check, spte, level);
 }
 
+/*
+ * Currently, we have two sorts of write-protection, a) the first one
+ * write-protects guest page to sync the guest modification, b) another one is
+ * used to sync dirty bitmap when we do KVM_GET_DIRTY_LOG. The differences
+ * between these two sorts are:
+ * 1) the first case clears MMU-writable bit.
+ * 2) the first case requires flushing tlb immediately avoiding corrupting
+ *    shadow page table between all vcpus so it should be in the protection of
+ *    mmu-lock. And the another case does not need to flush tlb until returning
+ *    the dirty bitmap to userspace since it only write-protects the page
+ *    logged in the bitmap, that means the page in the dirty bitmap is not
+ *    missed, so it can flush tlb out of mmu-lock.
+ *
+ * So, there is the problem: the first case can meet the corrupted tlb caused
+ * by another case which write-protects pages but without flush tlb
+ * immediately. In order to making the first case be aware this problem we let
+ * it flush tlb if we try to write-protect a spte whose MMU-writable bit
+ * is set, it works since another case never touches MMU-writable bit.
+ *
+ * Anyway, whenever a spte is updated (only permission and status bits are
+ * changed) we need to check whether the spte with MMU-writable becomes
+ * readonly, if that happens, we need to flush tlb. Fortunately,
+ * mmu_spte_update() has already handled it perfectly.
+ *
+ * The rules to use MMU-writable and PT_WRITABLE_MASK:
+ * - if we want to see if it has writable tlb entry or if the spte can be
+ *   writable on the mmu mapping, check MMU-writable, this is the most
+ *   case, otherwise
+ * - if we fix page fault on the spte or do write-protection by dirty logging,
+ *   check PT_WRITABLE_MASK.
+ *
+ * TODO: introduce APIs to split these two cases.
+ */
+static inline bool is_writable_pte(unsigned long pte)
+{
+	return pte & PT_WRITABLE_MASK;
+}
+
 /* Note: spte must be a shadow-present leaf SPTE. */
 static inline void check_spte_writable_invariants(u64 spte)
 {
@@ -347,7 +385,7 @@ static inline void check_spte_writable_invariants(u64 spte)
 			  "kvm: MMU-writable SPTE is not Host-writable: %llx",
 			  spte);
 	else
-		WARN_ONCE(spte & PT_WRITABLE_MASK,
+		WARN_ONCE(is_writable_pte(spte),
 			  "kvm: Writable SPTE is not MMU-writable: %llx", spte);
 }
 
-- 
2.35.0.rc0.227.g00780c9af4-goog

