Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CB9A0576A93
	for <lists+kvm@lfdr.de>; Sat, 16 Jul 2022 01:21:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232298AbiGOXVU (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 15 Jul 2022 19:21:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47932 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232128AbiGOXVP (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 15 Jul 2022 19:21:15 -0400
Received: from mail-pl1-x64a.google.com (mail-pl1-x64a.google.com [IPv6:2607:f8b0:4864:20::64a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 247479284D
        for <kvm@vger.kernel.org>; Fri, 15 Jul 2022 16:21:13 -0700 (PDT)
Received: by mail-pl1-x64a.google.com with SMTP id a17-20020a170902ecd100b0016c012c4cf3so2805382plh.15
        for <kvm@vger.kernel.org>; Fri, 15 Jul 2022 16:21:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=reply-to:date:in-reply-to:message-id:mime-version:references
         :subject:from:to:cc;
        bh=OjnofI9H9ze+fn8El42EdD+BHILp0ViAq1IAqn7KhtQ=;
        b=S2dPlRloCOUbP6ylCwhyT9a6h+A+GRvDK3iRNO3z5OWDOJwwZjfLmRsuzN2oHBtFdL
         rc6W3ii9MJOzFXYCzkt3TnNp8AS8InYdpt4UkQrXiNvsvuAjQsF3nSVODTvkfb/iSd0B
         WHV2baEnVrgyQC8MFfTlJc1jAIDtzLW7F870EIl4q9zYLIAzyEM3XcX9xITyXu/40hf7
         alaDSJ4mLL9us2972IKI3ntZZL4P88soflbkdDHCJP3aoNeQjQpsRbIjxzv5sDf0dbcL
         6FXZJnyAxrDoouWxFDeEMCuGBz+tdaMXMzpO87MwKRRCVSAjHnLn2assDrnxiKswbsqU
         kaVA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:reply-to:date:in-reply-to:message-id
         :mime-version:references:subject:from:to:cc;
        bh=OjnofI9H9ze+fn8El42EdD+BHILp0ViAq1IAqn7KhtQ=;
        b=i3gN5RgB54qEl/Ppu5KFtl2RQBVXOe/zTV9dvSKJwCaM853SVa+mx36aN7IwkAwPFj
         kX1z2cdGWxtDVv3VZRGt+0/PJ0HcOQ/z9nv3Bp/69pGPMy22hAm+5BXA3M0pjDMPzbI5
         wswb9uZUQY25ugoKJy8X0Om17IR0mAY5Ujr+7mjlNbHz65WPpkphUAj9YvFpQYzve3T+
         NbqvCBUdj6s+YT0cSUdVUU/n2jO+JeXfWDIFw6yqAQO8BtsF7Bm2miWL7xvbXbkiaKkd
         lOMDjRvZfvdO+BEorqiGpBg9rB7g+NtlcE0iEaUxqVRrLa5++oJD4ISVZP40EuuF6wya
         PiUA==
X-Gm-Message-State: AJIora/YEqQ0FIwApjzXoCW395xOMTyCs11LsjSIGogAhxy1xK1jPPNW
        DzBNA4qErc3TNSs1kUIRcHoWGfgrQW0=
X-Google-Smtp-Source: AGRyM1sre0fLEDWot+IVSxJCCNTVY3AXYrJ+aXAKwfE6qqe573oNgkQ4QT8Sc4g6UKV0kjKiKcrdIKY4dJA=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:902:8543:b0:16b:fbd1:9f68 with SMTP id
 d3-20020a170902854300b0016bfbd19f68mr16292338plo.101.1657927273410; Fri, 15
 Jul 2022 16:21:13 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Fri, 15 Jul 2022 23:21:05 +0000
In-Reply-To: <20220715232107.3775620-1-seanjc@google.com>
Message-Id: <20220715232107.3775620-3-seanjc@google.com>
Mime-Version: 1.0
References: <20220715232107.3775620-1-seanjc@google.com>
X-Mailer: git-send-email 2.37.0.170.g444d1eabd0-goog
Subject: [PATCH 2/4] KVM: x86/mmu: Document the "rules" for using host_pfn_mapping_level()
From:   Sean Christopherson <seanjc@google.com>
To:     Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Mingwei Zhang <mizhang@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Add a comment to document how host_pfn_mapping_level() can be used safely,
as the line between safe and dangerous is quite thin.  E.g. if KVM were
to ever support in-place promotion to create huge pages, consuming the
level is safe if the caller holds mmu_lock and checks that there's an
existing _leaf_ SPTE, but unsafe if the caller only checks that there's a
non-leaf SPTE.

Opportunistically tweak the existing comments to explicitly document why
KVM needs to use READ_ONCE().

No functional change intended.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/mmu/mmu.c | 42 +++++++++++++++++++++++++++++++++++-------
 1 file changed, 35 insertions(+), 7 deletions(-)

diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index bebff1d5acd4..d5b644f3e003 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -2919,6 +2919,31 @@ static void direct_pte_prefetch(struct kvm_vcpu *vcpu, u64 *sptep)
 	__direct_pte_prefetch(vcpu, sp, sptep);
 }
 
+/*
+ * Lookup the mapping level for @gfn in the current mm.
+ *
+ * WARNING!  Use of host_pfn_mapping_level() requires the caller and the end
+ * consumer to be tied into KVM's handlers for MMU notifier events!
+ *
+ * There are several ways to safely use this helper:
+ *
+ * - Check mmu_notifier_retry_hva() after grabbing the mapping level, before
+ *   consuming it.  In this case, mmu_lock doesn't need to be held during the
+ *   lookup, but it does need to be held while checking the MMU notifier.
+ *
+ * - Hold mmu_lock AND ensure there is no in-progress MMU notifier invalidation
+ *   event for the hva.  This can be done by explicit checking the MMU notifier
+ *   or by ensuring that KVM already has a valid mapping that covers the hva.
+ *
+ * - Do not use the result to install new mappings, e.g. use the host mapping
+ *   level only to decide whether or not to zap an entry.  In this case, it's
+ *   not required to hold mmu_lock (though it's highly likely the caller will
+ *   want to hold mmu_lock anyways, e.g. to modify SPTEs).
+ *
+ * Note!  The lookup can still race with modifications to host page tables, but
+ * the above "rules" ensure KVM will not _consume_ the result of the walk if a
+ * race with the primary MMU occurs.
+ */
 static int host_pfn_mapping_level(struct kvm *kvm, gfn_t gfn,
 				  const struct kvm_memory_slot *slot)
 {
@@ -2941,16 +2966,19 @@ static int host_pfn_mapping_level(struct kvm *kvm, gfn_t gfn,
 	hva = __gfn_to_hva_memslot(slot, gfn);
 
 	/*
-	 * Lookup the mapping level in the current mm.  The information
-	 * may become stale soon, but it is safe to use as long as
-	 * 1) mmu_notifier_retry was checked after taking mmu_lock, and
-	 * 2) mmu_lock is taken now.
-	 *
-	 * We still need to disable IRQs to prevent concurrent tear down
-	 * of page tables.
+	 * Disable IRQs to prevent concurrent tear down of host page tables,
+	 * e.g. if the primary MMU promotes a P*D to a huge page and then frees
+	 * the original page table.
 	 */
 	local_irq_save(flags);
 
+	/*
+	 * Read each entry once.  As above, a non-leaf entry can be promoted to
+	 * a huge page _during_ this walk.  Re-reading the entry could send the
+	 * walk into the weeks, e.g. p*d_large() returns false (sees the old
+	 * value) and then p*d_offset() walks into the target huge page instead
+	 * of the old page table (sees the new value).
+	 */
 	pgd = READ_ONCE(*pgd_offset(kvm->mm, hva));
 	if (pgd_none(pgd))
 		goto out;
-- 
2.37.0.170.g444d1eabd0-goog

