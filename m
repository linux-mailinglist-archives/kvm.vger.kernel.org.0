Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7C00B49BF56
	for <lists+kvm@lfdr.de>; Wed, 26 Jan 2022 00:05:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234651AbiAYXFo (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 25 Jan 2022 18:05:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44308 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230468AbiAYXF3 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 25 Jan 2022 18:05:29 -0500
Received: from mail-pf1-x449.google.com (mail-pf1-x449.google.com [IPv6:2607:f8b0:4864:20::449])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 60479C06161C
        for <kvm@vger.kernel.org>; Tue, 25 Jan 2022 15:05:29 -0800 (PST)
Received: by mail-pf1-x449.google.com with SMTP id p16-20020aa78610000000b004c7cf2724beso5872728pfn.23
        for <kvm@vger.kernel.org>; Tue, 25 Jan 2022 15:05:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=49eFT8ZaENmW7lWo1NlcY1SJ/TxxnJcwmzqwK2CdB58=;
        b=q3UMorhvNjWVk29HQSEp0iR2oGfT8Tm5QXEOdGwAcjh2h1OLIWv3EWHWv7OhSivAid
         rDR5v3KAP9XcaQrG7rddQMObwqx0bWs3v0QkMHzrMu+fwvegft7a8dLgurjl1f6wJZ0p
         3gf58sz10p4eExSHpzZR5dZJ3waO0wPu4GH0hA2MvAmVfNphKo6rVD8AtJ2aH3QQVzJm
         DJsYbbVuAwu9O1iufj1r+O/1UeSWZNZe7E2P+p8HEQ+H0YskRz9vEA9dMqjuCYjqyqWc
         kV18MAcfWpc+l9ifsqPNDjAmLQqxcIGAFxhsIaeZKNsSVH3A1xqhaK5T0lFduZsk6hgX
         kn3g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=49eFT8ZaENmW7lWo1NlcY1SJ/TxxnJcwmzqwK2CdB58=;
        b=nAs5aqKDK43GwivibARqA1qDvcPuluU30xHIq9wHU47jtU8pLnGWhQt68b3cNIw+TX
         2unZ90n/haoq7gbxJ77GCbQ7DxPl5cbqNr+95viBFlz6jVjzTjvMXMBiNxJKIXrwWhzv
         hhNuqsOwSTgjdpHTl3mxrnV+5FAss0XHkrckW7XabND6RTsSG0DNGPOKUqjGtsX5WrBv
         gXkIWQEI6GG0j7CIo/isWvjXzH5Qd5HhfiKaE+dBg8tevlO7B5UqlnHl9as2E1otSbLr
         5+Gcw9IL0o6uALTNsnY1pC2S6vDYWHxgVorPfCjn9JbxHCX/rzU/6n7bEg2BsfW35J/J
         JsXQ==
X-Gm-Message-State: AOAM533QY1Ub66gSulLXjZNbEaDxe3iElxJohZ6L+ePi3XT+GBGWUzne
        IICVQSc8xVmoPsg6Ge9TcOd6Ygrgkwdsrw==
X-Google-Smtp-Source: ABdhPJwknMWMgIIX+paWkQ7OU70h3ZVmMtZN0fWXsr5RVmLkHHkFFoz3wcI17yuExtpjG+jSFPOLUz6TlqdfLQ==
X-Received: from dmatlack-heavy.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:19cd])
 (user=dmatlack job=sendgmr) by 2002:a05:6a00:b82:b0:4cb:9790:90ac with SMTP
 id g2-20020a056a000b8200b004cb979090acmr140278pfj.21.1643151928842; Tue, 25
 Jan 2022 15:05:28 -0800 (PST)
Date:   Tue, 25 Jan 2022 23:05:15 +0000
In-Reply-To: <20220125230518.1697048-1-dmatlack@google.com>
Message-Id: <20220125230518.1697048-3-dmatlack@google.com>
Mime-Version: 1.0
References: <20220125230518.1697048-1-dmatlack@google.com>
X-Mailer: git-send-email 2.35.0.rc0.227.g00780c9af4-goog
Subject: [PATCH 2/5] KVM: x86/mmu: Check SPTE writable invariants when setting
 leaf SPTEs
From:   David Matlack <dmatlack@google.com>
To:     pbonzini@redhat.com
Cc:     seanjc@google.com, vkuznets@redhat.com, wanpengli@tencent.com,
        jmattson@google.com, joro@8bytes.org, kvm@vger.kernel.org,
        David Matlack <dmatlack@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Check SPTE writable invariants when setting SPTEs rather than in
spte_can_locklessly_be_made_writable(). By the time KVM checks
spte_can_locklessly_be_made_writable(), the SPTE has long been since
corrupted.

Note that these invariants only apply to shadow-present leaf SPTEs (i.e.
not to MMIO SPTEs, non-leaf SPTEs, etc.). Add a comment explaining the
restriction and only instrument the code paths that set shadow-present
leaf SPTEs.

To account for access tracking, also check the SPTE writable invariants
when marking an SPTE as an access track SPTE. This also lets us remove
a redundant WARN from mark_spte_for_access_track().

Suggested-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: David Matlack <dmatlack@google.com>
---
 arch/x86/kvm/mmu/mmu.c     | 1 +
 arch/x86/kvm/mmu/spte.c    | 9 +--------
 arch/x86/kvm/mmu/spte.h    | 2 +-
 arch/x86/kvm/mmu/tdp_mmu.c | 3 +++
 4 files changed, 6 insertions(+), 9 deletions(-)

diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index 593093b52395..795db506c230 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -529,6 +529,7 @@ static u64 mmu_spte_update_no_track(u64 *sptep, u64 new_spte)
 	u64 old_spte = *sptep;
 
 	WARN_ON(!is_shadow_present_pte(new_spte));
+	check_spte_writable_invariants(new_spte);
 
 	if (!is_shadow_present_pte(old_spte)) {
 		mmu_spte_set(sptep, new_spte);
diff --git a/arch/x86/kvm/mmu/spte.c b/arch/x86/kvm/mmu/spte.c
index f8677404c93c..24d66bb899a4 100644
--- a/arch/x86/kvm/mmu/spte.c
+++ b/arch/x86/kvm/mmu/spte.c
@@ -249,14 +249,7 @@ u64 mark_spte_for_access_track(u64 spte)
 	if (is_access_track_spte(spte))
 		return spte;
 
-	/*
-	 * Making an Access Tracking PTE will result in removal of write access
-	 * from the PTE. So, verify that we will be able to restore the write
-	 * access in the fast page fault path later on.
-	 */
-	WARN_ONCE((spte & PT_WRITABLE_MASK) &&
-		  !spte_can_locklessly_be_made_writable(spte),
-		  "kvm: Writable SPTE is not locklessly dirty-trackable\n");
+	check_spte_writable_invariants(spte);
 
 	WARN_ONCE(spte & (SHADOW_ACC_TRACK_SAVED_BITS_MASK <<
 			  SHADOW_ACC_TRACK_SAVED_BITS_SHIFT),
diff --git a/arch/x86/kvm/mmu/spte.h b/arch/x86/kvm/mmu/spte.h
index 912e66859ea0..b8fd055acdbd 100644
--- a/arch/x86/kvm/mmu/spte.h
+++ b/arch/x86/kvm/mmu/spte.h
@@ -339,6 +339,7 @@ static __always_inline bool is_rsvd_spte(struct rsvd_bits_validate *rsvd_check,
 	       __is_rsvd_bits_set(rsvd_check, spte, level);
 }
 
+/* Note: spte must be a shadow-present leaf SPTE. */
 static inline void check_spte_writable_invariants(u64 spte)
 {
 	if (spte & shadow_mmu_writable_mask)
@@ -352,7 +353,6 @@ static inline void check_spte_writable_invariants(u64 spte)
 
 static inline bool spte_can_locklessly_be_made_writable(u64 spte)
 {
-	check_spte_writable_invariants(spte);
 	return spte & shadow_mmu_writable_mask;
 }
 
diff --git a/arch/x86/kvm/mmu/tdp_mmu.c b/arch/x86/kvm/mmu/tdp_mmu.c
index bc9e3553fba2..814c42def6e7 100644
--- a/arch/x86/kvm/mmu/tdp_mmu.c
+++ b/arch/x86/kvm/mmu/tdp_mmu.c
@@ -435,6 +435,9 @@ static void __handle_changed_spte(struct kvm *kvm, int as_id, gfn_t gfn,
 
 	trace_kvm_tdp_mmu_spte_changed(as_id, gfn, level, old_spte, new_spte);
 
+	if (is_leaf)
+		check_spte_writable_invariants(new_spte);
+
 	/*
 	 * The only times a SPTE should be changed from a non-present to
 	 * non-present state is when an MMIO entry is installed/modified/
-- 
2.35.0.rc0.227.g00780c9af4-goog

