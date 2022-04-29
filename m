Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 29F0F515650
	for <lists+kvm@lfdr.de>; Fri, 29 Apr 2022 23:01:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1381170AbiD2VEF (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 29 Apr 2022 17:04:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36994 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1381155AbiD2VDx (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 29 Apr 2022 17:03:53 -0400
Received: from mail-pj1-x104a.google.com (mail-pj1-x104a.google.com [IPv6:2607:f8b0:4864:20::104a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 76946D3AD5
        for <kvm@vger.kernel.org>; Fri, 29 Apr 2022 14:00:33 -0700 (PDT)
Received: by mail-pj1-x104a.google.com with SMTP id s5-20020a17090aa10500b001d9a8e99e3aso4566834pjp.2
        for <kvm@vger.kernel.org>; Fri, 29 Apr 2022 14:00:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=reply-to:date:in-reply-to:message-id:mime-version:references
         :subject:from:to:cc;
        bh=sYmSDs9vemF3/Z3s2wsijCq+GxxHmSayON1stTWk5n0=;
        b=axe09GMhmDkuVVX0wJP6zD6p/9eeAdfzoaERIJvgaCYAJ/25lJeRvMtNtT8DshPc22
         Ojo2DaWzd0GfyAeYzSjc9RkXYxXseXe7XlvEWLDTHiWs+Y0YQBzcsy8B2Wcc8gQ/3Qdd
         7Y2gG4sCtcemlR0Z7Hyhsp9obwKZw2RWUJ2Bx2nB9eMSKnvfeM3xPvUV1z2r3i4py7Ti
         1pAqbEinMDC9JRVd9C5W1p6DEDVnXKVBC+e1E9T5Dr2xwGSiF6dV7D9uRYWyWky6eceH
         INIcv4oUHP8fv7aYlJsX/StGDfHmCRQ817gSS/hNaX4VRyj1Eg1dacIqLTXu8lGBgrPa
         BiZA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:reply-to:date:in-reply-to:message-id
         :mime-version:references:subject:from:to:cc;
        bh=sYmSDs9vemF3/Z3s2wsijCq+GxxHmSayON1stTWk5n0=;
        b=iCpCuYbBaJVmGMqFqsnfuphlUUHwmGAtpu8L+ez/bFtBiy1q3fev/qe4EmbnD00y17
         skqrne8bt08nw3ujctjUrUGZ9TpCkAwGHCPWObjOxIoCZhFX2Mac3JqlbwKZVAf1HW6i
         R5MHLywJTJ90nMcWU0w3O32DzP6oBEaV8qtKG3WF3RBAh645W0qZyAi/xqJkfAgRmE1q
         p2gycoHfG8Uq+2NzTaJJDXNt8FowLhKAH3nTtaYDuMQt8IuSoVE48lZUSElmr4hsWU4h
         8Px7LIJQJ0RAZyqoicLM04RW3iE6mkQZ2TD921wI/67FNATFueecNzWQjTTgtZGF/SF0
         cKBw==
X-Gm-Message-State: AOAM5300oNB6tUILSoC/fD58hsYeW2zjXCRaqzgZIhnEeFk6Yg+6cwzf
        w0nFqcvSZE0nB64Usi2Mwk3iK2k7/pw=
X-Google-Smtp-Source: ABdhPJzlW0WaPMyp/bOXIZS1s6MQhTk2krjEOUAtgwDxh+MZT2t41lytl+fXSJDNza7yoec7QJVyrwx/9iA=
X-Received: from seanjc.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:3e5])
 (user=seanjc job=sendgmr) by 2002:a17:902:9f97:b0:15d:1b87:6164 with SMTP id
 g23-20020a1709029f9700b0015d1b876164mr1107742plq.71.1651266032987; Fri, 29
 Apr 2022 14:00:32 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Fri, 29 Apr 2022 21:00:19 +0000
In-Reply-To: <20220429210025.3293691-1-seanjc@google.com>
Message-Id: <20220429210025.3293691-3-seanjc@google.com>
Mime-Version: 1.0
References: <20220429210025.3293691-1-seanjc@google.com>
X-Mailer: git-send-email 2.36.0.464.gb9c8b46e94-goog
Subject: [PATCH v3 2/8] Revert "KVM: Fix race between mmu_notifier
 invalidation and pfncache refresh"
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Sean Christopherson <seanjc@google.com>,
        Lai Jiangshan <jiangshanlai@gmail.com>,
        David Woodhouse <dwmw@amazon.co.uk>,
        Mingwei Zhang <mizhang@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This reverts commit c496097d2c0bdc229f82d72b4b1e55d64974c316.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 virt/kvm/kvm_main.c |  9 ------
 virt/kvm/pfncache.c | 70 ++++++++++++++-------------------------------
 2 files changed, 21 insertions(+), 58 deletions(-)

diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index 0848430f36c6..dfb7dabdbc63 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -705,15 +705,6 @@ static int kvm_mmu_notifier_invalidate_range_start(struct mmu_notifier *mn,
 	kvm->mn_active_invalidate_count++;
 	spin_unlock(&kvm->mn_invalidate_lock);
 
-	/*
-	 * Invalidate pfn caches _before_ invalidating the secondary MMUs, i.e.
-	 * before acquiring mmu_lock, to avoid holding mmu_lock while acquiring
-	 * each cache's lock.  There are relatively few caches in existence at
-	 * any given time, and the caches themselves can check for hva overlap,
-	 * i.e. don't need to rely on memslot overlap checks for performance.
-	 * Because this runs without holding mmu_lock, the pfn caches must use
-	 * mn_active_invalidate_count (see above) instead of mmu_notifier_count.
-	 */
 	gfn_to_pfn_cache_invalidate_start(kvm, range->start, range->end,
 					  hva_range.may_block);
 
diff --git a/virt/kvm/pfncache.c b/virt/kvm/pfncache.c
index 71c84a43024c..dd84676615f1 100644
--- a/virt/kvm/pfncache.c
+++ b/virt/kvm/pfncache.c
@@ -112,63 +112,29 @@ static void __release_gpc(struct kvm *kvm, kvm_pfn_t pfn, void *khva, gpa_t gpa)
 	}
 }
 
-static kvm_pfn_t hva_to_pfn_retry(struct kvm *kvm, struct gfn_to_pfn_cache *gpc)
+static kvm_pfn_t hva_to_pfn_retry(struct kvm *kvm, unsigned long uhva)
 {
-	bool first_attempt = true;
 	unsigned long mmu_seq;
 	kvm_pfn_t new_pfn;
+	int retry;
 
-	lockdep_assert_held_write(&gpc->lock);
-
-	for (;;) {
+	do {
 		mmu_seq = kvm->mmu_notifier_seq;
 		smp_rmb();
 
-		write_unlock_irq(&gpc->lock);
-
-		/* Opportunistically check for resched while the lock isn't held. */
-		if (!first_attempt)
-			cond_resched();
-
 		/* We always request a writeable mapping */
-		new_pfn = hva_to_pfn(gpc->uhva, false, NULL, true, NULL);
-
-		write_lock_irq(&gpc->lock);
-
+		new_pfn = hva_to_pfn(uhva, false, NULL, true, NULL);
 		if (is_error_noslot_pfn(new_pfn))
 			break;
 
-		first_attempt = false;
-
-		/*
-		 * Wait for mn_active_invalidate_count, not mmu_notifier_count,
-		 * to go away, as the invalidation in the mmu_notifier event
-		 * occurs _before_ mmu_notifier_count is elevated.
-		 *
-		 * Note, mn_active_invalidate_count can change at any time as
-		 * it's not protected by gpc->lock.  But, it is guaranteed to
-		 * be elevated before the mmu_notifier acquires gpc->lock, and
-		 * isn't dropped until after mmu_notifier_seq is updated.  So,
-		 * this task may get a false positive of sorts, i.e. see an
-		 * elevated count and wait even though it's technically safe to
-		 * proceed (becase the mmu_notifier will invalidate the cache
-		 * _after_ it's refreshed here), but the cache will never be
-		 * refreshed with stale data, i.e. won't get false negatives.
-		 */
-		if (kvm->mn_active_invalidate_count)
-			continue;
-
-		/*
-		 * Ensure mn_active_invalidate_count is read before
-		 * mmu_notifier_seq.  This pairs with the smp_wmb() in
-		 * mmu_notifier_invalidate_range_end() to guarantee either the
-		 * old (non-zero) value of mn_active_invalidate_count or the
-		 * new (incremented) value of mmu_notifier_seq is observed.
-		 */
-		smp_rmb();
-		if (kvm->mmu_notifier_seq == mmu_seq)
+		KVM_MMU_READ_LOCK(kvm);
+		retry = mmu_notifier_retry_hva(kvm, mmu_seq, uhva);
+		KVM_MMU_READ_UNLOCK(kvm);
+		if (!retry)
 			break;
-	}
+
+		cond_resched();
+	} while (1);
 
 	return new_pfn;
 }
@@ -224,6 +190,7 @@ int kvm_gfn_to_pfn_cache_refresh(struct kvm *kvm, struct gfn_to_pfn_cache *gpc,
 	 * drop the lock and do the HVA to PFN lookup again.
 	 */
 	if (!old_valid || old_uhva != gpc->uhva) {
+		unsigned long uhva = gpc->uhva;
 		void *new_khva = NULL;
 
 		/* Placeholders for "hva is valid but not yet mapped" */
@@ -231,10 +198,15 @@ int kvm_gfn_to_pfn_cache_refresh(struct kvm *kvm, struct gfn_to_pfn_cache *gpc,
 		gpc->khva = NULL;
 		gpc->valid = true;
 
-		new_pfn = hva_to_pfn_retry(kvm, gpc);
+		write_unlock_irq(&gpc->lock);
+
+		new_pfn = hva_to_pfn_retry(kvm, uhva);
 		if (is_error_noslot_pfn(new_pfn)) {
 			ret = -EFAULT;
-		} else if (gpc->usage & KVM_HOST_USES_PFN) {
+			goto map_done;
+		}
+
+		if (gpc->usage & KVM_HOST_USES_PFN) {
 			if (new_pfn == old_pfn) {
 				new_khva = old_khva;
 				old_pfn = KVM_PFN_ERR_FAULT;
@@ -250,10 +222,10 @@ int kvm_gfn_to_pfn_cache_refresh(struct kvm *kvm, struct gfn_to_pfn_cache *gpc,
 				new_khva += page_offset;
 			else
 				ret = -EFAULT;
-		} else {
-			/* Nothing more to do, the pfn is consumed only by the guest. */
 		}
 
+	map_done:
+		write_lock_irq(&gpc->lock);
 		if (ret) {
 			gpc->valid = false;
 			gpc->pfn = KVM_PFN_ERR_FAULT;
-- 
2.36.0.464.gb9c8b46e94-goog

